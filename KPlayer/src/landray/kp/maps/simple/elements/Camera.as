package landray.kp.maps.simple.elements
{
	import model.vo.ElementVO;
	
	public final class Camera extends BaseElement
	{
		public function Camera($vo:ElementVO)
		{
			super($vo);
			mouseEnabled = false;
		}
		
		override public function render(scale:Number = 1):void
		{
			super.render();
			graphics.beginFill(0, 0);
			graphics.drawRect(vo.style.tx, vo.style.ty, vo.style.width, vo.style.height);
			graphics.endFill();
		}
	}
}