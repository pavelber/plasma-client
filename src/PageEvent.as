package 
{
	import flash.events.Event;

	public class PageEvent extends Event
	{
		public var pageNumber:int;
		
		public function PageEvent(pageNumber:int,type:String)
		{
			super(type);
			this.pageNumber = pageNumber;
		}
		
		override public function clone():Event
		{
			return new PageEvent(pageNumber,type);
		}
		
	}
}