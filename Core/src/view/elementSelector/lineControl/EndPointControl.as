package view.elementSelector.lineControl
{
	import com.kvs.ui.clickMove.ClickMoveControl;
	import com.kvs.ui.clickMove.IClickMove;
	
	import flash.geom.Point;
	
	import model.vo.ElementVO;
	
	import util.CoreUtil;
	
	import view.elementSelector.ControlPointBase;
	import view.elementSelector.ElementSelector;
	
	/**
	 */	
	public class EndPointControl extends StartEndControlBase
	{
		public function EndPointControl(selector:ElementSelector, ui:ControlPointBase)
		{
			super(selector, ui);
		}
		
		/**
		 */		
		override public function moveOff(xOff:Number, yOff:Number):void
		{
			endX += xOff;
			endY += yOff;
			//CoreUtil.drawCircle(0x00FF00, new Point(endX, endY), 2);
			
			super.moveOff(xOff, yOff);
			
			var rotation:Number = selector.coreMdt.autoAlignController.checkRotation(selector.element, selector.element.rotation);
			if (! isNaN(rotation))
			{
				vo.rotation = rotation;
				
				selector.element.render();
				selector.update();
			}
			
		}
	}
}