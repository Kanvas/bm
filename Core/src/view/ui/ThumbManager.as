package view.ui
{
	import com.adobe.images.JPGEncoder;
	import com.adobe.images.PNGEncoder;
	import com.kvs.utils.MathUtil;
	import com.kvs.utils.graphic.BitmapUtil;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	import model.CoreFacade;
	import model.vo.PageVO;
	
	import modules.pages.PageManager;
	import modules.pages.PageUtil;
	import modules.pages.Scene;
	
	import util.CoreUtil;
	import util.LayoutUtil;
	
	/**
	 * 
	 * 截图管理器，负责生成kanvas的截图
	 * 
	 */	
	public class ThumbManager
	{
		public function ThumbManager(app:CoreApp)
		{
			this.core = app;
		}
		
		/**
		 */		
		private var core:CoreApp;
		
		/**
		 * 输出指定宽高的截图，此截图为全场景范围
		 */		
		public function getShotCut(w:Number, h:Number):BitmapData
		{
			var rect:Rectangle = LayoutUtil.getContentRect(canvas, false);
			var cw:Number = rect.width;
			var ch:Number = rect.height;
			var vw:Number = w;
			var vh:Number = h;
			if (cw && ch && vw && vh)
			{
				var scale:Number = ((vw / vh) > (cw / ch)) ? vh / ch : vw / cw;
				var rotation:Number = 0;
				var tp:Point = new Point(rect.x, rect.y);
				LayoutUtil.convertPointCanvas2Stage(tp, -(vw - cw * scale) * .5, -(vh - ch * scale) * .5, scale, rotation);
				canvas.toShotcutState(-tp.x, -tp.y, scale, 0);
				var bmd:BitmapData = BitmapUtil.drawWithSize(canvas, vw, vh, true, CoreFacade.coreProxy.bgColor);
				canvas.toPreviewState();
			}
			else
			{
				bmd = new BitmapData(w, h, false, CoreFacade.coreProxy.bgColor);
			}
			return bmd;
		}
		
		public function getPageBytes(w:Number = 960, h:Number = 720):ByteArray
		{
			var manager:PageManager = CoreFacade.coreMediator.pageManager;
			if (manager.length)
			{
				var bytes:ByteArray = new ByteArray;
				var header:String = "";
				var shapes:Vector.<Shape> = new Vector.<Shape>;
				var l:int = manager.length;
				var gutter:int = 10;
				for (var i:int = 0; i < l; i++)
				{
					var m:int = i % 10;
					if (m == 0)
					{
						var shape:Shape = new Shape;
						var sw:Number = w + gutter * 2;
						var sh:Number = (h +　gutter) * Math.min(l - i, 10) + gutter;
						shape.graphics.beginFill(0x555555);
						shape.graphics.drawRect(0, 0, sw, sh);
						shape.graphics.endFill();
						shapes.push(shape);
					}
					var page:PageVO = manager.pages[i];
					
					var bmd:BitmapData = PageUtil.getThumbByPageVO(page, w, h, core, CoreFacade.coreProxy.bgColor);
					/*if (bmd)
						BitmapUtil.drawBitmapDataToShape(bmd, shape, w, h, gutter, (h + gutter) * m + gutter, true);
					else
						bmd = page.bitmapData = PageUtil.getThumbByPageVO(page, w, h, core, CoreFacade.coreProxy.bgColor);*/
				}
				l = shapes.length;
				var offset:int = 4;
				for (i = 0; i < l; i++)
				{
					bmd = BitmapUtil.getBitmapData(shapes[i]);
					var dat:ByteArray  = PNGEncoder.encode(bmd);
					bytes.position = offset;
					bytes.writeBytes(dat, 0, dat.length);
					var s:int = offset;
					var e:int = offset + dat.length;
					header += i + ":" + s + "-" + e + ((i < l - 1) ? "|" : "");
					offset += dat.length;
				}
				bytes.position = 0;
				bytes.writeInt(offset);
				bytes.position = offset;
				bytes.writeUTFBytes(header);
				bytes.position = offset;
			}
			return bytes;
		}
		
		public function resolvePageData(pageBytes:ByteArray):Vector.<ByteArray>
		{
			if (pageBytes)
			{
				var jpgBytes:Vector.<ByteArray> = new Vector.<ByteArray>;
				pageBytes.position = 0;
				pageBytes.position = pageBytes.readInt();
				var header:String = pageBytes.readUTFBytes(pageBytes.bytesAvailable);
				var pageIndexes:Array = header.split("|");
				for each (var pageStr:String in pageIndexes)
				{
					var pageTmp:Array = pageStr.split(":");
					var pageIdx:int = pageTmp[0];
					var pageLen:Array = pageTmp[1].split("-");
					var pageSta:int = pageLen[0];
					var pageEnd:int = pageLen[1];
					var pageByt:ByteArray = new ByteArray;
					pageBytes.position = pageSta;
					pageBytes.readBytes(pageByt, 0, pageEnd - pageSta);
					jpgBytes.push(pageByt);
				}
			}
			return jpgBytes;
		}
		
		/**
		 */		
		private function get canvas():Canvas
		{
			return core.canvas;
		}
		
		private function get bgImg():Shape
		{
			return core.bgImgCanvas;
		}
	}
}