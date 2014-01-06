package view.pagePanel
{
	import com.kvs.ui.button.IconBtn;
	import com.kvs.ui.clickMove.ClickMoveControl;
	import com.kvs.ui.clickMove.IClickMove;
	import com.kvs.ui.label.LabelUI;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	
	import modules.pages.PageEvent;
	import modules.pages.PageVO;
	
	/**
	 */	
	public class PageUI extends IconBtn implements IClickMove
	{
		public function PageUI(vo:PageVO)
		{
			super();
			
			this.pageVO = vo;
			pageVO.addEventListener(PageEvent.PAGE_SELECTED, pageSelected);
			pageVO.addEventListener(PageEvent.UPDATE_THUMB, updateThumb);
			
			addChild(con);
			con.addChild(label);
			con.addChild(imgShape);
			
			imgShape.filters = [new GlowFilter(0x555555, 0.5, 2, 2, 2, 3)];//添加一个阴影轮廓
			con.addEventListener(MouseEvent.MOUSE_DOWN, downPage);
			
			deleteBtn = new IconBtn;
			deleteBtn.tips = '删除页面';
			deleteBtn.iconW = deleteBtn.iconH = 16;
			deleteBtn.setIcons('del_up', 'del_over', 'del_down');
			deleteBtn.visible = false;
			addChild(deleteBtn);
			
			deleteBtn.addEventListener(MouseEvent.CLICK, delHander);
			
			this.addEventListener(MouseEvent.ROLL_OVER, rollOver);
			this.addEventListener(MouseEvent.ROLL_OUT, rollOut);
			
			dragMoveControl = new ClickMoveControl(this, con);
		}
		
		/**
		 */		
		private var dragMoveControl:ClickMoveControl;
		
		/**
		 * 
		 */		
		public function moveOff(xOff:Number, yOff:Number):void
		{
			this.dispatchEvent(new PagePanelEvent(PagePanelEvent.PAGE_DRAGGING));
		}
		
		/**
		 * 当鼠标按下对象，没有拖动就释放时触发此方法
		 */		
		public function clicked():void
		{
			this.dispatchEvent(new PagePanelEvent(PagePanelEvent.PAGE_CLICKED, this));
		}
		
		/**
		 * 鼠标按下，切换页面，但不切换镜头
		 */		
		private function downPage(evt:MouseEvent):void
		{
			this.dispatchEvent(new PagePanelEvent(PagePanelEvent.PAGE_DOWN, this));
		}
		
		/**
		 */		
		public function startMove():void
		{
			this.dispatchEvent(new PagePanelEvent(PagePanelEvent.START_DRAG_PAGE, this));
		}
		
		/**
		 */		
		public function hoverUI():void
		{
			this.mouseChildren = this.mouseEnabled = false;
			
			this.graphics.clear();
			drawPageThumb();
			
			this.label.visible = false;
		}
			
		/**
		 */			
		public function stopMove():void
		{
			label.visible = true;
			this.statesControl.toDown();
			
			this.dispatchEvent(new PagePanelEvent(PagePanelEvent.END_DRAG_PAGE));
			this.mouseEnabled = this.mouseChildren = true;
		}
		
		/**
		 */		
		private function updateThumb(evt:PageEvent):void
		{
			
		}
		
		/**
		 */		
		private function pageSelected(evt:PageEvent):void
		{
			this.dispatchEvent(evt);
		}
		
		/**
		 */		
		private function delHander(evt:MouseEvent):void
		{
			pageVO.dispatchEvent(new PageEvent(PageEvent.DELETE_PAGE_FROM_UI, this.pageVO));
		}
		
		/**
		 */		
		private function rollOver(et:MouseEvent):void
		{
			deleteBtn.visible = true;
		}
		
		/**
		 */		
		private function rollOut(evt:MouseEvent):void
		{
			deleteBtn.visible = false;
		}
		
		/**
		 */		
		override public function render():void
		{
			super.render();
			
			drawPageThumb();
			
			deleteBtn.x = leftGutter + iconW;
			deleteBtn.y = (currState.height - iconH) / 2;;
		}
		
		/**
		 * 绘制页面截图
		 */		
		private function drawPageThumb():void
		{
			var ty:Number = (currState.height - iconH) / 2;
			
			imgShape.graphics.clear();
			imgShape.graphics.lineStyle(1, 0xEEEEEE);
			imgShape.graphics.beginFill(0xFFFFFF);
			imgShape.graphics.drawRect(leftGutter, ty, iconW, iconH);
			imgShape.graphics.endFill();
		}
		
		/**
		 * 左侧防止文字的间距 
		 */		
		private var leftGutter:uint = 35;
		
		/**
		 */		
		private var label:LabelUI = new LabelUI;
		
		/**
		 * 用于绘制页面缩略图 
		 */		
		private var imgShape:Shape = new Shape;
		
		/**
		 * 更新序号显示
		 */		
		public function updataLabel():void
		{
			label.text = (pageVO.index + 1).toString();
			
			updateLabelWidthStyle();
			
			label.x = (leftGutter - label.width) / 2;
            label.y = (h - label.height) / 2;
		}
		
		/**
		 */		
		override public function set selected(value:Boolean):void
		{
			super.selected = value;
			
			this.mouseEnabled = true;
			updateLabelWidthStyle();
		}
		
		/**
		 */		
		private function updateLabelWidthStyle():void
		{
			if(selected)
				label.styleXML = selectedTextStyle;
			else
				label.styleXML = normalTextStyle;
			
			label.render();
		}
		
		/**
		 */		
		override protected function init():void
		{
			super.init();
			
			this.mouseChildren = true;
			this.buttonMode = false;
		}
		
		/**
		 */		
		private var normalTextStyle:XML = <label radius='0' vPadding='0' hPadding='0'>
											<format color='#555555' font='雅痞' size='12'/>
										  </label>
			
		/**
		 */		
		private var selectedTextStyle:XML = <label radius='0' vPadding='0' hPadding='0'>
											<format color='#ffffff' font='雅痞' size='12'/>
										  </label>
		
		/**
		 * 用来响应点击，触发页面选择的容器对象；
		 * 
		 * 这么做的目的是为了防止点击删除按钮也触发clicked方法 
		 */			
		private var con:Sprite = new Sprite;
			
		/**
		 */		
		public var pageVO:PageVO;
		
		/**
		 */		
		private var deleteBtn:IconBtn
	}
}