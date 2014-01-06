package modules.pages
{
	import flash.events.Event;
	
	public final class PageEvent extends Event
	{
		/**
		 * 页面被添加后触发事件 
		 */				
		public static const PAGE_ADDED:String = "pageAdded";
		
		/**
		 * 页面被删除后触发
		 */		
		public static const PAGE_DELETED:String = "pageDeleted";
		
		/**
		 * 主UI上点击删除按钮后触发 
		 */		
		public static const DELETE_PAGE_FROM_UI:String = "deletePageFromUI";
		
		
		public static const PAGE_SELECTED:String = "pageSelected";
		
		/**
		 * 通知主UI刷新页面布局 
		 */		
		public static const UPDATE_PAGES_LAYOUT:String = "updatePagesLayout";
		
		/**
		 * 通知页面UI刷新截图 
		 */		
		public static const UPDATE_THUMB:String = "updateThumb";
		
		
		/**
		 */		
		public function PageEvent(type:String, $pageVO:PageVO = null, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
			__pageVO = $pageVO;
		}
		
		public function get pageVO():PageVO
		{
			return __pageVO;
		}
		
		override public function clone():Event
		{
			return new PageEvent(type, __pageVO, true);
		}
		
		private var __pageVO:PageVO;
		
	}
}