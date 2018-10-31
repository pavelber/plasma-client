package components.control
{
	import components.CalcToDbCreator;
	import components.CrmFromDbMaker;
	import components.FileDownloader;
	import components.FitToDbInserter;
	import components.TransToDbInserter;
	
	import constants.ServerConstants;
	
	import mx.controls.Alert;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
    import flash.filesystem.*;
	import flash.events.Event;
	
	import vo.Calculation;
	
	public class Requester
	{
		private var myHttpService:HTTPService; 
		private var m_sCalcId:String;
		private var m_fileDownloader:FileDownloader;
		private var m_crmFromDbMaker:CrmFromDbMaker;
		private var m_calcToDbCreator:CalcToDbCreator;
		private var m_fit2DbInserter:FitToDbInserter;
		private var m_trans2DbInserter:TransToDbInserter;
		private var m_calc:Calculation;
		private static var m_sFileName:String = "";
		
		public function Requester()
		{
		}
		
		public function set calcCreatorComponent(creator:CalcToDbCreator):void
		{
			m_calcToDbCreator = creator;
		}

		public function set transInserterComponent(inserter:TransToDbInserter):void
		{
			m_trans2DbInserter = inserter;
		}

		public function set fitInserterComponent(inserter:FitToDbInserter):void
		{
			m_fit2DbInserter = inserter;
		}

		public function set downloaderComponent(downloader:FileDownloader):void
		{
			m_fileDownloader = downloader;
		}

		public function set crmMakerComponent(maker:CrmFromDbMaker):void
		{
			m_crmFromDbMaker = maker;
		}

        public function initConnection():void 
        {
            myHttpService = new HTTPService();
			myHttpService.url = ServerConstants.SERVER_NAME + ServerConstants.PROJECTS_REQUEST_NAME;
  			myHttpService.resultFormat="e4x"; 
            myHttpService.addEventListener("result", initResultHandler);
            myHttpService.addEventListener("fault", initFaultHandler);
            myHttpService.send();
        }
		
        private function initResultHandler(event:ResultEvent):void 
        {
		   if( myHttpService.lastResult is XML )
		   {
		      	var calcsXml:XML = XML( myHttpService.lastResult );
        	
	        	if(calcsXml)
	        	{
		        	var xmlProjects:XMLList = calcsXml.calc;
		        	
	        		if(m_fileDownloader)
	        		{
	        			m_fileDownloader.calcCbx.dataProvider =  xmlProjects; 
	        		}
	        		
	        		if(m_crmFromDbMaker)
	        		{
	        			m_crmFromDbMaker.calcCbx.dataProvider =  xmlProjects; 
	        		}
	        	}
		   }        	
        }
        
        private function initFaultHandler(evt:FaultEvent):void 
        {
            Alert.show(evt.fault.faultString);
        }

        public function fileListRequest(sCalcName:String):void
        {
        	var params : Object = {};
			params.calcName = sCalcName;
            myHttpService = new HTTPService();
			myHttpService.url =  ServerConstants.SERVER_NAME + ServerConstants.FILE_LIST_REQUEST_NAME;
			myHttpService.method = "POST";
  			myHttpService.resultFormat="e4x"; 
            myHttpService.addEventListener("result", fileListResultHandler);
            myHttpService.addEventListener("fault", fileListFaultHandler);
            myHttpService.send(params);
            myHttpService.send();
        }
        
        private function fileListResultHandler(event:ResultEvent):void 
        {
		   if( myHttpService.lastResult is XML )
		   {
		      	var calcXml:XML = XML( myHttpService.lastResult );
	        	if(calcXml)
	        	{
	        		m_fileDownloader.setData(calcXml);
	        	}
		   }        	
        }
      
        private function fileListFaultHandler(evt:FaultEvent):void 
        {
            Alert.show(evt.fault.faultString);
        }
        
        public function fileDownloadRequest(params:Object):void
        {
        	m_sFileName = params.fileName;
            myHttpService = new HTTPService();
			myHttpService.url =  ServerConstants.SERVER_NAME + ServerConstants.DOWNLOAD_REQUEST_NAME;
			myHttpService.method = "POST";
  			myHttpService.resultFormat="text"; 
            myHttpService.addEventListener("result", fileDownloadResultHandler);
            myHttpService.addEventListener("fault", fileDownloadFaultHandler);
            myHttpService.send(params);
        }
        
        private function fileDownloadResultHandler(event:ResultEvent):void 
        {
			var file:File = new File(m_fileDownloader.dir);
			file = file.resolvePath(m_sFileName);
			var fileStream:FileStream = new FileStream();
			fileStream.open(file, FileMode.WRITE);
			fileStream.writeUTFBytes(myHttpService.lastResult.toString());
			fileStream.addEventListener(Event.CLOSE, fileClosed);
			fileStream.close();
		
			m_fileDownloader.onDownloadComplete();
			
			function fileClosed(event:Event):void 
			{
				
				trace("closed event fired");
			}
        }
     
        private function fileDownloadFaultHandler(evt:FaultEvent):void 
        {
            Alert.show(evt.fault.faultString);
        }
        
        public function crmRalchenkoStructureRequest(params:Object):void
        {
            myHttpService = new HTTPService();
			myHttpService.url =  ServerConstants.SERVER_NAME + ServerConstants.DO_CRM_RALCHENKO_STRUCTURE_REQUEST_NAME;
			myHttpService.method = "POST";
  			myHttpService.resultFormat="e4x"; 
            myHttpService.addEventListener("result", crmRalchenkoStructureResultHandler);
            myHttpService.addEventListener("fault", crmRalchenkoStructureFaultHandler);
            myHttpService.send(params);
        }
        
        private function crmRalchenkoStructureResultHandler(event:ResultEvent):void 
        {
		   if( myHttpService.lastResult is XML )
		   {
		      	var makingCrmResponseXml:XML = XML( myHttpService.lastResult );
	        	if(makingCrmResponseXml)
	        	{
					m_crmFromDbMaker.setMakingResultsData(makingCrmResponseXml);
					m_crmFromDbMaker.onDownloadComplete();
	        	}
		   }        	
        }
      
        private function crmRalchenkoStructureFaultHandler(evt:FaultEvent):void 
        {
            Alert.show(evt.fault.faultString);
        }
       
        public function crmFisherStructureRequest(params:Object):void
        {
            myHttpService = new HTTPService();
			myHttpService.url =  ServerConstants.SERVER_NAME + ServerConstants.DO_CRM_FISHER_STRUCTURE_REQUEST_NAME;
			myHttpService.method = "POST";
  			myHttpService.resultFormat="e4x"; 
            myHttpService.addEventListener("result", crmFisherStructureResultHandler);
            myHttpService.addEventListener("fault", crmFisherStructureFaultHandler);
            myHttpService.send(params);
        }
        
        private function crmFisherStructureResultHandler(event:ResultEvent):void 
        {
		   if( myHttpService.lastResult is XML )
		   {
		      	var makingCrmResponseXml:XML = XML( myHttpService.lastResult );
	        	if(makingCrmResponseXml)
	        	{
					m_crmFromDbMaker.setMakingResultsData(makingCrmResponseXml);
					m_crmFromDbMaker.onDownloadComplete();
	        	}
		   }        	
        }
      
        private function crmFisherStructureFaultHandler(evt:FaultEvent):void 
        {
            Alert.show(evt.fault.faultString);
        }
        
        public function crmTransitionsRequest(params:Object):void
        {
            myHttpService = new HTTPService();
			myHttpService.url =  ServerConstants.SERVER_NAME + ServerConstants.DO_CRM_TRANSITIONS_REQUEST_NAME;
			myHttpService.method = "POST";
  			myHttpService.resultFormat="e4x"; 
            myHttpService.addEventListener("result", crmTransitionsResultHandler);
            myHttpService.addEventListener("fault", crmTransitionsFaultHandler);
            myHttpService.send(params);
        }
        
        private function crmTransitionsResultHandler(event:ResultEvent):void 
        {
		   if( myHttpService.lastResult is XML )
		   {
		      	var makingCrmResponseXml:XML = XML( myHttpService.lastResult );
	        	if(makingCrmResponseXml)
	        	{
					m_crmFromDbMaker.setMakingResultsData(makingCrmResponseXml);
					m_crmFromDbMaker.onDownloadComplete();
	        	}
		   }        	
        }
      
        private function crmTransitionsFaultHandler(evt:FaultEvent):void 
        {
            Alert.show(evt.fault.faultString);
        }

         public function calcCreatorRequest(params:Object):void
        {
        	m_calc = m_calcToDbCreator.currentCalc;
            myHttpService = new HTTPService();
			myHttpService.url =  m_calcToDbCreator.calcCreatorUrl;
			myHttpService.method = "POST";
  			myHttpService.resultFormat="e4x"; 
            myHttpService.addEventListener("result", calcCreatorResultHandler);
            myHttpService.addEventListener("fault", calcCreatorFaultHandler);
            myHttpService.send(params);
        }
        
        private function calcCreatorResultHandler(event:ResultEvent):void 
        {
            Alert.show("Calculation to Atomic DB was created successfully!");
        }
      
        private function calcCreatorFaultHandler(evt:FaultEvent):void 
        {
            Alert.show(evt.fault.faultString);
        }

         public function structureInserterRequest(params:Object):void
        {
        	m_calc = m_calcToDbCreator.currentCalc;
            myHttpService = new HTTPService();
			myHttpService.url =  m_calcToDbCreator.structureInserterUrl;
			myHttpService.method = "POST";
  			myHttpService.resultFormat="e4x"; 
            myHttpService.addEventListener("result", structureInserterResultHandler);
            myHttpService.addEventListener("fault", structureInserterFaultHandler);
            myHttpService.send(params);
        }
        
        private function structureInserterResultHandler(event:ResultEvent):void 
        {
            var bytesLoaded:Number = 0;
            if( myHttpService.lastResult is XML )
		    {
		      	var structureInserterResponseXml:XML = XML( myHttpService.lastResult );
		      	
	        	if(structureInserterResponseXml)
	        	{
	        		var sizeInBytes:Number = Number(structureInserterResponseXml..size);
					bytesLoaded = sizeInBytes
					m_calcToDbCreator.onInsertingProgress(bytesLoaded);
					m_calcToDbCreator.onInsertingComplete();
	        	}
		    }        	
        }
      
        private function structureInserterFaultHandler(evt:FaultEvent):void 
        {
        	m_calcToDbCreator.clearInserting();
            Alert.show(evt.fault.faultString);
        }

        public function transitionsInserterRequest(params:Object):void
        {
        	m_calc = m_trans2DbInserter.currentCalc;
            myHttpService = new HTTPService();
			myHttpService.url =  m_trans2DbInserter.transInserterUrl;
			myHttpService.method = "POST";
  			myHttpService.resultFormat="e4x"; 
            myHttpService.addEventListener("result", transitionsInserterResultHandler);
            myHttpService.addEventListener("fault", transitionsInserterFaultHandler);
            myHttpService.send(params);
        }
        
        private function transitionsInserterResultHandler(event:ResultEvent):void 
        {
            var bytesLoaded:Number = 0;
            if( myHttpService.lastResult is XML )
		    {
		      	var transInserterResponseXml:XML = XML( myHttpService.lastResult );
	        	if(transInserterResponseXml)
	        	{
	        		var sizeInBytes:Number = Number(transInserterResponseXml..size);
					bytesLoaded = sizeInBytes
					m_trans2DbInserter.onInsertingProgress(bytesLoaded);
					m_trans2DbInserter.onInsertingComplete();
	        	}
		    }        	
        }
      
        private function transitionsInserterFaultHandler(evt:FaultEvent):void 
        {
        	m_trans2DbInserter.clearInserting();
            Alert.show(evt.fault.faultString);
        }

        public function fitsInserterRequest(params:Object):void
        {
        	m_calc = m_fit2DbInserter.currentCalc;
            myHttpService = new HTTPService();
			myHttpService.url =  m_fit2DbInserter.fitInserterUrl;
			myHttpService.method = "POST";
  			myHttpService.resultFormat="e4x"; 
            myHttpService.addEventListener("result", fitsInserterResultHandler);
            myHttpService.addEventListener("fault", fitsInserterFaultHandler);
            myHttpService.send(params);
        }
        
        private function fitsInserterResultHandler(event:ResultEvent):void 
        {
            var bytesLoaded:Number = 0;
            if( myHttpService.lastResult is XML )
		    {
		      	var fitInserterResponseXml:XML = XML( myHttpService.lastResult );
	        	if(fitInserterResponseXml)
	        	{
	        		var sizeInBytes:Number = Number(fitInserterResponseXml..size);
					bytesLoaded = sizeInBytes
					m_fit2DbInserter.onInsertingProgress(bytesLoaded);
					m_fit2DbInserter.onInsertingComplete();
	        	}
		    }        	
        }
      
        private function fitsInserterFaultHandler(evt:FaultEvent):void 
        {
        	m_fit2DbInserter.clearInserting();
            Alert.show(evt.fault.faultString);
        }
	}
}