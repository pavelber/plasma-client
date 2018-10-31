package vo
{
	import mx.collections.ArrayCollection;
	import mx.messaging.AbstractConsumer;
	
	public class Ion
	{
		private var m_iIonCharge:int;
		private const m_fac:ArrayCollection = new ArrayCollection();
		private const m_fit:ArrayCollection = new ArrayCollection();
		
		
		public function Ion(iIonCharge:int)
		{
			m_iIonCharge = iIonCharge;
		}
		
		public function get facCollection():ArrayCollection
		{
			return m_fac;
		}
		
		public function get fitCollection():ArrayCollection
		{
			return m_fit;
		}
		
		public function addFileNode(fileNode:FileNode):void
		{
			var perspective:String = fileNode.perspective;
			switch(perspective)
			{
				case "fac":
					m_fac.addItem(fileNode);
				break;
				case "fit":
					m_fit.addItem(fileNode);
				break;
				default:
				break;
			}
		}
		
		public function removeFileNode(index:int, perspective:String):void
		{
			switch(perspective)
			{
				case "fac":
					m_fac.removeItemAt(index);
				break;
				case "fit":
					m_fit.removeItemAt(index);
				break;
				default:
				break;
			}
		}

		public function getFileNodeFor(process:String, perspective:String):FileNode
		{
			var res:FileNode = null;
			switch(perspective)
			{
				case "fac":
					for each(var oFac:Object in m_fac)
					{
						if(oFac is FileNode && oFac.fileType == process)
						{
							res = FileNode(oFac);
							break;
						}
					}
				break;
				case "fit":
					for each(var oFit:Object in m_fit)
					{
						if(oFit is FileNode && oFit.fileType == process)
						{
							res = FileNode(oFit);
							break;
						}
					}
				break;
				default:
				break;
			}
			return res;
		}

		public function getFileNode(fileName:String, perspective:String):FileNode
		{
			var res:FileNode = null;
			switch(perspective)
			{
				case "fac":
					for each(var oFac:Object in m_fac)
					{
						if(oFac is FileNode && oFac.fileName == fileName)
						{
							res = FileNode(oFac);
							break;
						}
					}
				break;
				case "fit":
					for each(var oFit:Object in m_fit)
					{
						if(oFit is FileNode && oFit.fileName == fileName)
						{
							res = FileNode(oFit);
							break;
						}
					}
				break;
				default:
				break;
			}
			return res;
		}


//		public function getFileNode(index:int, perspective:String):FileNode
//		{
//			var res:FileNode = null;
//			switch(perspective)
//			{
//				case "fac":
//					var o:Object = m_fac.getItemAt(index);
//					if(o is FileNode)
//					{
//						res = FileNode(o);
//					}
//				break;
//				case "fit":
//					o = m_fit.getItemAt(index);
//					if(o is FileNode)
//					{
//						res = FileNode(o);
//					}
//				break;
//				default:
//				break;
//			}
//			return res;
//		}
		
		public function getFileNodeIndex(fileNode:FileNode, perspective:String):int
		{
			var res:int = -1;
			switch(perspective)
			{
				case "fac":
					res = m_fac.getItemIndex(fileNode);
				break;
				case "fit":
					res = m_fit.getItemIndex(fileNode);
				break;
				default:
				break;
			}
			return res;
		}
		
		public function toXml(perspective:String):String
		{
			var res:String = "";
			
			switch(perspective)
			{
				case "fac":
					res += "<" + perspective + ">" + "\n";
					for each(var facItem:FileNode in m_fac)
					{
						res += facItem.toXml();
					}
					res += "</" + perspective + ">" + "\n";
				break;
				case "fit":
					res += "<" + perspective + ">" + "\n";
					for each(var fitItem:FileNode in m_fit)
					{
						res += fitItem.toXml();
					}
					res += "</" + perspective + ">" + "\n";
				break;
				default:
				break;
			}
			return res;
		}
		
		public function get ionCharge():int
		{
			return m_iIonCharge;
		}
	}
}