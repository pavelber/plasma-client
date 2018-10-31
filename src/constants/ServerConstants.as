package constants
{
	import flash.filesystem.File;
	
	public class ServerConstants
	{
		public static const SERVER_NAME:String = "http://localhost:8080/il.ac.weizmann.plasma.atomic.server/command/";
		//public static const SERVER_NAME:String = "http://plasma-b:8080/il.ac.weizmann.plasma.atomic.server/command/";

		public static const PROJECTS_REQUEST_NAME:String 					= "doProjectsList";
		public static const UPLOAD_REQUEST_NAME:String 						= "doFileUploading";
		public static const CREATE_CALC_TO_DB_REQUEST_NAME:String 			= "doCalcElementToDb";
		public static const STRUCTURE_TO_DB_REQUEST_NAME:String 				= "doStructureToDb";
		public static const TRANSITIONS_TO_DB_REQUEST_NAME:String 			= "doTransitionsToDb";
		public static const FITS_TO_DB_REQUEST_NAME:String 					= "doFitsToDb";
		public static const DB2CRM_REQUEST_NAME:String 						= "doCrmFiles";
		public static const FILE_LIST_REQUEST_NAME:String 					= "doCrmFileList";
		public static const DOWNLOAD_REQUEST_NAME:String 					= "doFileDownloading";
		public static const SQL_REQUEST_NAME:String 						= "doSqlQuery";
		
		public static const DO_CRM_FISHER_STRUCTURE_REQUEST_NAME:String 	= "doCrmFisherStructure";
		public static const DO_CRM_RALCHENKO_STRUCTURE_REQUEST_NAME:String 	= "doCrmRalchenkoStructure";
		public static const DO_CRM_TRANSITIONS_REQUEST_NAME:String 			= "doCrmTransitions";
		
		public static const HISTORY_FILE_NAME:String 						= "calculations.xml";
		public static const HISTORY_FILE:File = 
				File.applicationStorageDirectory.resolvePath(HISTORY_FILE_NAME);

	}
}