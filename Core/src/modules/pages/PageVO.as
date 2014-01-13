package modules.pages
{
	import model.vo.ElementVO;
	
	import modules.pages.pg_internal;
	
	[Event(name="updateThumb", type="modules.pages.PageEvent")]
	
	[Event(name="deletePageFromUI", type="modules.pages.PageEvent")]
	
	[Event(name="pageSelected", type="modules.pages.PageEvent")]
	
	public final class PageVO extends ElementVO
	{
		public function PageVO()
		{
			super();
		}
		
		
		
		public function get parent():PageQuene
		{
			return pg_internal::parent;
		}
		pg_internal var parent:PageQuene
		
		
		
		public function get index():int
		{
			return pg_internal::index;
		}
		
		pg_internal var index:int = -1;
		
		
	}
}