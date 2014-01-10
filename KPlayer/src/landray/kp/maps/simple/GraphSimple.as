package landray.kp.maps.simple
{
	import flash.geom.Rectangle;
	
	import landray.kp.maps.simple.elements.BaseElement;
	import landray.kp.maps.simple.elements.Label;
	import landray.kp.maps.simple.util.SimpleUtil;
	import landray.kp.utils.CoreUtil;
	import landray.kp.view.Graph;
	
	import model.vo.ElementVO;
	
	
	
	public final class GraphSimple extends Graph
	{
		public function GraphSimple()
		{
			super();
			initialize();
		}
		
		private function initialize():void
		{
			mouseEnabled = false;
			elements = new Vector.<BaseElement>;
		}
		
		override public function render(scale:Number = 1):void
		{
			if (stage)
			{
				var count:int = 0;
				for each (var element:BaseElement in elements)
				{
					addChild(element);
					var bound:Rectangle = element.getBounds(stage);
					element.visible = ! (bound.left > stage.stageWidth || bound.right < 0 || bound.bottom < 0 || bound.top > stage.stageHeight);
					if(!element.visible)
						removeChild(element);
					if (element.visible && element is Label)
					{
						count ++;
						element.render(scale);
					}
				}
				trace("label rendered:", count);
			}
			
		}
		
		override public function set dataProvider(value:XML):void
		{
			//clear
			elements.length = 0;
			while(numChildren) removeChildAt(0);
			
			//create vos and elements
			var list:XMLList = value.children();
			for each (var xml:XML in list) 
			{
				var vo:ElementVO = SimpleUtil.getElementVO(String(xml.@type));
				CoreUtil.mapping(xml, vo);
				var element:BaseElement = SimpleUtil.getElementUI(vo);
				CoreUtil.applyStyle(element.vo);
				CoreUtil.mapping(xml, vo);
				element.render();
				addChild(element);
				elements.push(element);
			}
		}
		
		private var elements:Vector.<BaseElement>;
		
	}
}