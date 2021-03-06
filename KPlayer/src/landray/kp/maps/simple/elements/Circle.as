package landray.kp.maps.simple.elements
{
	import com.kvs.utils.XMLConfigKit.StyleManager;
	
	import model.vo.ShapeVO;
		
	public class Circle extends BaseShape
	{
		public function Circle(vo:ShapeVO)
		{
			super(vo);
		}
		/**
		 * 渲染
		 */
		override public function render(scale:Number = 1):void
		{
			super.render();
			
			StyleManager.setShapeStyle( shapeVO.style, graphics, shapeVO );
			graphics.drawEllipse( shapeVO.style.tx, shapeVO.style.ty, shapeVO.width, shapeVO.height );
			graphics.endFill();
			
		}
	}
}