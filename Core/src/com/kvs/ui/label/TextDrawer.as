package com.kvs.ui.label
{
	import com.kvs.utils.graphic.BitmapUtil;
	
	import flash.display.BitmapData;
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
		public function checkTextBm(shape:Graphics, textCanvas:Sprite, scale:Number = 1, tx:Number = 0, ty:Number = 0):void
		{
			var r:Number = textBMD.width / (scale * textCanvas.width);
			
			//截图有最大尺寸限制，最大宽高乘积为 imgMaxSize
			var max:Number = scale * textCanvas.width * scale * textCanvas.height * scaleMultiple * scaleMultiple;
			
			if (host.visible && max < imgMaxSize && (textBMD.width < textCanvas.width * scale || r > bmMaxScaleMultiple))
			{
				//textCanvas.visible = true;
				renderTextBMD(shape, textCanvas, scale, tx, ty, (max < minSmoothSize) ? true : false);
			}
		}
		
		
		/**
		 * 将textCanvas上的文本转换为bitmapdata并绘制
		 */		
		public function renderTextBMD(shape:Graphics, textCanvas:Sprite, scale:Number = 1, tx:Number = 0, ty:Number = 0, smooth:Boolean = false):void
		{
			shape.clear();
			
			if (scale < 0)
				scale *= - 1;
			
			trace(textCanvas.width, textCanvas.height)
			try
			{
				textBMD = BitmapUtil.getBitmapData(textCanvas, false, scale * scaleMultiple);
				
				BitmapUtil.drawBitmapDataToGraphics(textBMD ,shape, textCanvas.width, textCanvas.height, 
					- textCanvas.width / 2 + tx,  - textCanvas.height / 2 + ty, smooth);
			}
			catch (e:Error)
			{
				trace(e.getStackTrace())
			}
			
			
			
			if (textCanvas.parent)
			{
				textCanvas.parent.removeChild(textCanvas);
			}
			//textCanvas.visible = false;
		}
		
		
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