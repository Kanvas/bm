package view.elementSelector.sizeControl
{
	import com.kvs.ui.clickMove.ClickMoveControl;
	
	import commands.Command;
	
	import flash.geom.Point;
	
	import view.elementSelector.ControlPointBase;
	import view.elementSelector.ElementSelector;
	
	/**
	 */	
	public class BottomPointControl extends SizeControlPointBase
	{
		public function BottomPointControl(holder:ElementSelector, ui:ControlPointBase)
		{
			super(holder);
			this.moveControl = new ClickMoveControl(this, ui);
		}
		
		/**
		 */		
		override public function startMove():void
		{
			super.startMove();
			
			//记录开始变换前的属性
			oldSize = holder.element.vo.height;
			oldPropertyObj = {};
			oldPropertyObj.height = holder.element.vo.height;
			oldPropertyObj.x = holder.element.vo.x;
			oldPropertyObj.y = holder.element.vo.y;
			
			topCenter = holder.element.topCenter;
			bottomCenter = holder.element.bottomCenter;
			
			lastMouseX = holder.coreMdt.mainUI.stage.mouseX;
			lastMouseY = holder.coreMdt.mainUI.stage.mouseY;
		}
		
		
		override public function stopMove():void
		{
			if (point && ! isNaN(point.x) && ! isNaN(point.y))
			{
				holder.element.vo.height = Point.distance(orign, point) / holder.element.scale;
				var center:Point = Point.interpolate(orign, point, .5);
				holder.element.vo.x = center.x;
				holder.element.vo.y = center.y;
				holder.element.render();
				updateHolderLayout();
			}
			super.stopMove();
			
			var index:Vector.<int> = holder.coreMdt.autoLayerController.autoLayer(holder.element);
			if (index)
			{
				oldPropertyObj.indexChangeElement = holder.coreMdt.autoLayerController.indexChangeElement;
				oldPropertyObj.index = index;
			}
			
			holder.coreMdt.sendNotification(Command.CHANGE_ELEMENT_PROPERTY, oldPropertyObj);
			
			var xDir:int = holder.coreMdt.mainUI.stage.mouseX - lastMouseX;
			xDir = (xDir == 0) ? xDir : ((xDir > 0) ? 1 : -1);
			var yDir:int = holder.coreMdt.mainUI.stage.mouseY - lastMouseY;
			yDir = (yDir == 0) ? yDir : ((yDir > 0) ? 1 : -1);
			
			holder.coreMdt.autofitController.autofitElementPosition(holder.coreMdt.currentElement, xDir, yDir);
		}
		
		
		/**
		 */		
		override public function moveOff(xOff:Number, yOff:Number):void
		{
			//鼠标到图形旋转法线的距离, 影响到图形的高度
			var newDis:Number = getDisFromMpToLine(this.curRad);
			
			// 防止因旋转角度不同造成的拉伸方向颠倒
			if (Math.cos(curRad) > 0)
				newDis *= - 1;
			
			var hDis:Number = newDis - oldDis;
			var newSize:Number = oldSize + hDis / holder.element.scale / holder.layoutTransformer.canvas.scaleY;
			//如newsize<0则为反向
			oppsite = (newSize < 0);
			
			holder.element.vo.height = Math.abs(newSize);
			
			var rote:Number = this.curRad - Math.PI / 2;
			holder.element.vo.x = holder.layoutTransformer.stageXToElementX(oldX - hDis / 2 * Math.cos(rote));
			holder.element.vo.y = holder.layoutTransformer.stageYToElementY(oldY - hDis / 2 * Math.sin(rote));
			holder.element.render();
			
			var currPoint:Point = (oppsite) ? holder.element.topCenter : holder.element.bottomCenter;
			orign = (oppsite) ? bottomCenter : topCenter;
			
			//元素y方向自动对齐检测
			point = holder.coreMdt.autoAlignController.checkPosition(holder.element, currPoint, "y");
			
			
			// 更新型变框布局
			updateHolderLayout();
		}
		
		private var topCenter:Point;
		private var bottomCenter:Point;
		private var oppsite:Boolean;
		private var oldPropertyObj:Object;
		
		private var lastMouseX:Number;
		private var lastMouseY:Number;
		
		private var point:Point;
		private var orign:Point;
		
	}
}