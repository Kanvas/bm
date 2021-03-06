package com.kvs.ui.label
{
	import com.kvs.utils.graphic.BitmapUtil;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	
	/**
	 * 将文本转化为bitmap截图
	 */	
	public class TextDrawer
	{
		public function TextDrawer(host:Sprite)
		{
			this.host = host;
		}
		
		/**
		 */		
		private var host:Sprite;
		
		/**
		 * 检测截图是否满足要求
		 */		
		public function checkTextBm(shape:Graphics, textCanvas:Sprite, scale:Number = 1, tx:Number = 0, ty:Number = 0, w:Number = 1, h:Number = 1):void
		{
			if (scale < 0)
				scale = -scale;
			try
			{
				if (textBMD)
				{
					var r:Number = textBMD.width / (scale * textCanvas.width);
					
					//截图有最大尺寸限制，最大宽高乘积为 imgMaxSize
					var max:Number = scale * textCanvas.width * scale * textCanvas.height * scaleMultiple * scaleMultiple;
					
					if (host.visible && max < imgMaxSize && (textBMD.width < textCanvas.width * scale || r > bmMaxScaleMultiple))
					{
						renderTextBMD(shape, textCanvas, scale, tx, ty, w, h, (max < minSmoothSize) ? true : false);
					}
					
					checkVisible(shape, textCanvas, scale, tx, ty, w, h);
				}
				
			} 
			catch(error:Error) 
			{
				trace(error.getStackTrace())
			}
			
		}
		
		/**
		 * 将textCanvas上的文本转换为bitmapdata并绘制
		 */		
		public function renderTextBMD(shape:Graphics, textCanvas:Sprite, scale:Number = 1, tx:Number = 0, ty:Number = 0, w:Number = 1, h:Number = 1, smooth:Boolean = false):void
		{
			shape.clear();
			
			if (scale < 0)
				scale *= - 1;
			
			try
			{
				textBMD = BitmapUtil.getBitmapData(textCanvas, false, scale * scaleMultiple);
				
				BitmapUtil.drawBitmapDataToGraphics(textBMD ,shape, w, h, 
					- w * .5 + tx,  - h * .5 + ty, false);
			} 
			catch(error:Error) 
			{
				
			}
			
		}			
		
		/**
		 * 检测字体原始字体是否可见，文字放大时用位图以提升性能；
		 * 
		 * 文字较小时用原始字体，提升可读性；
		 * 
		 * 文字太小时，隐藏文字；
		 */		
		public function checkVisible(shape:Graphics, textCanvas:Sprite, scale:Number = 1, tx:Number = 0, ty:Number = 0, w:Number = 1, h:Number = 1):void
		{
			if (scale < 0)
				scale *= - 1;
			
			if (scale <= 1.5 && scale >= 0.3)
			{
				textCanvas.visible = true;
				if (textCanvasParent)
				{
					textCanvasParent.addChild(textCanvas);
				}
				shape.clear();
			}
			else
			{
				if (textCanvas.visible)
				{
					BitmapUtil.drawBitmapDataToGraphics(textBMD ,shape, w, h, 
						- w / 2 + tx,  - h / 2 + ty, false);
				}
				
				textCanvas.visible = false;
				if (textCanvas.parent)
				{
					textCanvasParent = textCanvas.parent;
					textCanvas.parent.removeChild(textCanvas);
				}
			}
			
		}
		
		private var textCanvasParent:DisplayObjectContainer;
		
		/**
		 * 截图时不会恰好截取满足要求的尺寸，而是要多放大一些，这样截图计算就会少一点
		 * 
		 * 借以提升性能； 
		 */		
		public var scaleMultiple:Number = 2;
		
		/**
		 * 最大截图宽高乘积 
		 */		
		public var imgMaxSize:uint = 16000000;
		
		public var minSmoothSize:uint = 160000;
		
		/**
		 * 当截图尺大于实际需要尺寸倍数超过此值，需重新截图，防止显示异常问题 
		 */		
		public var bmMaxScaleMultiple:uint = 30;
		
		/**
		 */		
		public var textBMD:BitmapData;
	}
}