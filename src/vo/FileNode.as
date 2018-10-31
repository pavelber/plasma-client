package vo
{
	import mx.collections.ArrayCollection;
	
	public class FileNode
	{
		private var m_sFileName:String;
		private var m_sFileType:String;
		private var m_fileSize:Number;
		private var m_bWasUploaded:Boolean = false;
		private var m_bWasInserted:Boolean = false;
		private var m_sPerspective:String;
		
		
		public function FileNode(item:Object)
		{
			var facItemWasFound:Boolean = false;
			for each(var facItem:Object in FileCatalog.FAC_CATALOG)
			{
				if(facItem.name == item.name)
				{
					m_sFileName = facItem.name;
					m_sPerspective = "fac";
					m_sFileType = facItem.type;
					m_fileSize = item.size;
					facItemWasFound = true;
					break;
				}
			}
			if(!facItemWasFound)
			{
				for each(var fitItem:Object in FileCatalog.FIT_CATALOG)
				{
					if(fitItem.name == item.name)
					{
						m_sFileName = fitItem.name;
						m_sPerspective = "fit";
						m_sFileType = fitItem.type;
						m_fileSize = item.size;
						break;
					}
				}
			}
		}
		
		public function toXml():String
		{
			var res:String = "<fileNode>" + "\n";
			res +=  "<name>" + m_sFileName + "</name>" + "\n" + 
					"<type>" + m_sFileType + "</type>" + "\n" +
					"<size>" + m_fileSize + "</size>" + "\n" +
					"<wasUploaded>" + m_bWasUploaded + "</wasUploaded>" + "\n" +
					"<wasInserted>" + m_bWasInserted + "</wasInserted>" + "\n";
			res += "</fileNode>" + "\n";
			return res;
		}
		
		public function get fileName():String
		{
			return m_sFileName;
		}

		public function get fileSize():Number
		{
			return m_fileSize;
		}
				
		public function get fileType():String
		{
			return m_sFileType;
		}
		
		public function get perspective():String
		{
			return m_sPerspective;
		}
		
		public function get wasUploaded():Boolean
		{
			return m_bWasUploaded;
		}
		
		public function get wasInserted():Boolean
		{
			return m_bWasInserted;
		}
		
		public function set wasUploaded(flag:Boolean):void
		{
			trace("Upload");
			trace("before " + m_sFileName + "    " + m_bWasUploaded);
			m_bWasUploaded = flag;
			trace("after " + m_sFileName + "    " + m_bWasUploaded);
		}

		public function set wasInserted(flag:Boolean):void
		{
			trace("Insert");
			trace("before " + m_sFileName + "    " + m_bWasInserted);
			m_bWasInserted = flag;
			trace("after " + m_sFileName + "    " + m_bWasInserted);
		}

	}
}