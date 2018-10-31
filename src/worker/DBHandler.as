/*
Copyright (c) 2007 Adobe Systems Incorporated

Author: Anirudh Sasikumar
Website: http://anirudhs.chaosnet.org/

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
*/
package worker
{
    import flash.data.SQLConnection;
    import flash.data.SQLResult;
    import flash.data.SQLStatement;
    import flash.data.SQLSchemaResult;
    import flash.events.Event;
    import flash.events.SQLErrorEvent;
    import flash.events.SQLEvent;
    import flash.filesystem.File;
    import flash.errors.SQLError;
    
    import mx.controls.DataGrid;
    import mx.controls.Alert;
    import mx.events.CloseEvent;
    
    public class DBHandler
    {
        private var conn:SQLConnection = null;
        private var fnOpenErr:Function = null;
        private var fnOpenSuccess:Function = null;
        private var parentDGrid:DataGrid = null;
        private var fnSQL:Function = null;
        public var dbName:String = "";
        private var sqlStmt:SQLStatement = null;
        
        public function DBHandler()
            {
                conn = new SQLConnection();
            }
        private function alertHandler(evt:CloseEvent):void
            {
                if ( evt.detail == Alert.YES )
                {
                    open(fnOpenSuccess, fnOpenErr,false);				
                }
            }
        public function open(openfn:Function, errfn:Function, askcreate:Boolean=true):void
            {
                trace("creating new conn");
                if ( conn != null )
                {                    
                    /* this is to ignore error thrown when new
                     * SQLConnection is being created. This doesn't
                     * happen in Beta 3, only Beta 2. */
                    conn.removeEventListener(SQLErrorEvent.ERROR, this.onOpenError);
                    conn.addEventListener(SQLErrorEvent.ERROR, function(evt:Event):void{});
                }

                conn = new SQLConnection();
                
                fnOpenErr = errfn;
                fnOpenSuccess = openfn;
                
                try
                {
                    var dbFile:File = new File(dbName);
                    if ( !dbFile.exists && askcreate == true )
                    {
                    	Alert.show("Database does not exist, do you want to create it?", 
                                   "Database file not found",Alert.YES | Alert.NO,
                                   null,alertHandler,null,Alert.NO);
                    	return;
                    }
                    conn.addEventListener(SQLEvent.OPEN, openfn);
                    conn.addEventListener(SQLErrorEvent.ERROR, this.onOpenError);
                    trace("opening db conn");
                    conn.open(dbFile);
                    
                }
                catch (e:Error)
                {
                    trace("open exception");
                    if ( askcreate == false )
                    {
                        onOpenError(new Event("DB Creation Failed:"+e));
                        return;
                    }
                    onOpenError(new Event(e.toString()));
                    return;
                }
            }
        public function close():void
            {
                /* this may throw an exception if any async db operation is in progress */
                if ( conn != null)
                {
                    try
                    {
                        conn.close();
                    }
                    catch(e:Error)
                    {
                        trace("close exception");
                        conn = null;
                    }
                }
            }
        private function onOpenError(event:Event):void
            {
                trace("onOpenError");
                conn = null;
                if ( fnOpenErr != null )
                    fnOpenErr(event);
            }
        
        
        public function execute(sql:String,params:Array, sqlResult:Function, sqlError:Function):void
            {
                if ( conn != null )
                {
                    sqlStmt = new SQLStatement();
                    sqlStmt.sqlConnection = conn;
                    sqlStmt.text = sql;
                    fnSQL = sqlResult;                   
                    sqlStmt.clearParameters();
                    if ( params != null && params.length > 0 )
                    {
                        for ( var i:int = 0; i < params.length; i++ )
                            sqlStmt.parameters[i] = params[i];
                    }
                    sqlStmt.addEventListener(SQLEvent.RESULT, getResult);
                    sqlStmt.addEventListener(SQLErrorEvent.ERROR, sqlError);
                                        
                    try
                    {
                    	sqlStmt.execute();
                    }
                    catch(e:Error)
                    {
                    	if ( e is SQLError )                    	
                            sqlError(new SQLErrorEvent("SQLStatement error:",false,false,e as SQLError));
                    	else
                            sqlError(new SQLErrorEvent("SQLStatement error:",false,false,new SQLError("execute","failed","Check if tables / vars exist")));
                    }
                    
                }
            }
        
        public function getResult(evt:Event):void
            {
                if ( conn != null && sqlStmt != null )
                {
                    var sqlres:SQLResult = sqlStmt.getResult();
                    if ( sqlres.data != null )
                    {
                        fnSQL(sqlres.data);
                    }
                    else
                    	fnSQL(sqlres.rowsAffected);
                    sqlStmt = null;
                }
            }
        
        public function getTag(sql:String,sqlResult:Function, sqlError:Function):void
            {   
                execute(sql, null, sqlResult, sqlError);
            }

        private function gotSchema(evt:SQLEvent):void
            {
                trace("got schema");
                var res:Array = getSchema(null, true);
                if ( parentDGrid != null )
                {
                    parentDGrid.dataProvider = res;
                }
            }

        public function getSchema(pargrid:DataGrid, bGotSchema:Boolean=false):Array
            {
                if ( pargrid != null )
                    parentDGrid = pargrid;
                if ( conn != null )
                {
                    var theres:SQLSchemaResult;
                    if ( (theres = conn.getSchemaResult()) == null && bGotSchema == false)
                    {
                        try {
                            trace("loading schema");
                            if ( parentDGrid != null )
                            	parentDGrid.dataProvider = null;
                            conn.addEventListener(SQLEvent.SCHEMA, gotSchema);
                            conn.loadSchema();
                            return null;
                        }
                        catch (e:Error)
                        {
                            return null;						
                        }
                    }
                    if ( theres == null )
                        return null;
                    trace("returning tables");
                    return theres.tables;
                }		
                return null;
            }
    }
}