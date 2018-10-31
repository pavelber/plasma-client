package vo
{
	import mx.collections.ArrayCollection;
	
	public class Calculation
	{
		private var m_sCalcName:String;
		private var m_iStartIon:Number;
		private var m_iEndIon:Number;
		private var m_iElementNumber:int;
		private var m_sElementsName:String;
		private const m_ions:ArrayCollection = new ArrayCollection();
		
		
		public function Calculation(sCalcDescriptor:String)
		{
			var parts:Array = sCalcDescriptor.split("-");
			m_sElementsName = parts[0];
			m_iElementNumber = Number(parts[1]);
			m_iStartIon = Number(parts[2]);
			m_iEndIon = Number(parts[3]);
			m_sCalcName = sCalcDescriptor;
		}
		
		public function setWasUploadedForFile(ionCharge:int, perspective:String, fileName:String):void
		{
			var ion:Ion = getIon(ionCharge);
			var fileNode:FileNode = ion.getFileNode(fileName, perspective);
			if(fileNode) fileNode.wasUploaded = true;
		}
		
		public function setWasInsertedFile(ionCharge:int, perspective:String, fileName:String):void
		{
			var ion:Ion = getIon(ionCharge);
			var fileNode:FileNode = ion.getFileNode(fileName, perspective);
			if(fileNode) fileNode.wasInserted = true;
		}

		public function addIon(ion:Ion):void
		{
			m_ions.addItem(ion);
		}

//		public function visitAllLevelFileNodes()
//		{
//			for(var i:int = m_iStartIon; i < (m_iEndIon + 1); i++)
//			{
//				var ion:Ion = getIon(i);
//				var levFile:FileNode = ion.getFileNodeFor("Levels", "fac");
//				
//				var levDescriptor:Object = new Object({ion:ion.ionCharge, });
//			}
//		}


		public function isFileExists(ionCharge:Number, searchType:String):Boolean
		{
			var res:Boolean = false;
			var ion:Ion = getIon(ionCharge);
			var fac:ArrayCollection = ion.facCollection;
			for each(var facItem:FileNode in fac)
			{
				var type:String = facItem.fileType;
				if(searchType == type)
				{
					res = true;
					break;
				}
			}
			return res;
		}

		
		public function getFileTypesFor(ion:Ion):Array
		{
			var res:ArrayCollection = null;
			var fac:ArrayCollection = ion.facCollection;
			for each(var facItem:FileNode in fac)
			{
				var type:String = facItem.fileType;
				res.addItem(type);
			}
			return res.toArray();
		}
		
//		public function visitAllFacFileNodes():Array
//		{
//			var res:ArrayCollection = null;
//			for(var i:int = m_iStartIon; i < (m_iEndIon + 1); i++)
//			{
//				var ion:Ion = getIon(i);
//				var fac:ArrayCollection = ion.facCollection;
//				for each(var facItem:FileNode in fac)
//				{
//					var type:String = facItem.fileType;
//					res.addItem(type);
//				}
//			}
//			return res.toArray();
//		}
		
		public function getIon(ionCharge:int):Ion
		{
			var res:Ion = null;
			for each(var ion:Ion in m_ions)
			{
				if(ion.ionCharge == ionCharge)
				{
					res = ion;
					break;
				}
			}
			return res;
		}
		
		public function getIonIndex(ion:Ion):int
		{
			return m_ions.getItemIndex(ion);
		}
		
		public function toXml():String
		{
			var res:String = "<calculation>" + "\n";
			res +=  "<name>" + m_sCalcName + "</name>" + "\n" + 
					"<elementname>" + m_sElementsName + "</elementname>" + "\n" +
					"<elementnum>" + m_iElementNumber + "</elementnum>" + "\n" +
					"<startionnum>" + m_iStartIon + "</startionnum>" + "\n" +
					"<endionnum>" + m_iEndIon + "</endionnum>" + "\n";
			res += "<ions>" + "\n";
			
			var perspective:String;// = "fac";
			for each(var ionItem:Ion in m_ions)
			{
				res += "<ion num='" + ionItem.ionCharge + "'>" + "\n";
				perspective = "fac";
				res += ionItem.toXml(perspective);

				perspective = "fit";
				res += ionItem.toXml(perspective);
				res += "</ion>" + "\n";
			}
			
			res += "</ions>" + "\n";
			res += "</calculation>" + "\n";
			return res;
		}
		
		public function get calcName():String
		{
			return m_sCalcName;
		}
		
		public function get startIon():int
		{
			return m_iStartIon;
		}
		
		public function get endIon():int
		{
			return m_iEndIon;
		}
		
		public function get elementNumber():int
		{
			return m_iElementNumber;
		}
		
		public function get elementName():String
		{
			return m_sElementsName;
		}
	}
}