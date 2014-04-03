package
{
	import com.adobe.images.PNGEncoder;
	import com.coltware.airxzip.ZipEntry;
	import com.coltware.airxzip.ZipErrorEvent;
	import com.coltware.airxzip.ZipEvent;
	import com.coltware.airxzip.ZipFileReader;
	import com.coltware.airxzip.ZipFileWriter;
	import com.kvs.utils.PerformaceTest;
	
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.net.FileFilter;
	import flash.utils.ByteArray;
	
	import model.ConfigInitor;
	
	import util.img.ImgLib;

	/**
	 * air客户端的api
	 */	
	public class APIForAIR extends KanvasAPI
	{
		public function APIForAIR(core:CoreApp)
		{
			super(core);
		}
		
		/**
		 * 当前文件
		 */		
		public var file:File;
		
		/**
		 * 打开文件 
		 */		
		public function openFile(newfile:File = null):void
		{
			if (newfile)
			{
				this.file = newfile;
				readFile();
			}
			else
			{
				file = new File;
				file.addEventListener(Event.SELECT, fileSelected);
				file.browse([new FileFilter("kvs", "*.kvs")]);
			}
		}
		
		/**
		 */		
		private function fileSelected(evt:Event):void
		{
			readFile();
			file.removeEventListener(Event.SELECT, fileSelected);
		}
		
		/**
		 */		
		private function readFile():void
		{
			var reader:ZipFileReader = new ZipFileReader();
			reader.open(file);
			
			PerformaceTest.ifRun = true;
			PerformaceTest.start();
			
			var list:Array = reader.getEntries();
			var xml:String;
			var imgID:String;
			var imgData:ByteArray;
			
			for each(var entry:ZipEntry in list)
			{
				if(entry.getFilename() == "kvs.xml")
				{
					xml = reader.unzip(entry).toString();
				}
				else
				{
					imgData = reader.unzip(entry);
					imgID = entry.getFilename().split('.')[0].toString();
					
					if (uint(imgID) != 0)
						ImgLib.register(imgID, imgData);
				}
			}
			
			this.setXMLData(xml);
			
			PerformaceTest.end();
		}
		
		/**
		 * 保存文件 
		 */		
		public function saveFile():void
		{
			if (file)
			{
				writeFile();
			}
			else
			{
				file = new File;
				file.addEventListener(Event.SELECT, selectFileForSave);
				file.browseForSave("保存kanvas文件");
			}
		}
		
		/**
		 */		
		private function selectFileForSave(evt:Event):void
		{
			file.removeEventListener(Event.SELECT, selectFileForSave);
				
			file = new File(file.nativePath + ".kvs")
			writeFile();
		}
		
		/**
		 */		
		private function writeFile():void
		{
			PerformaceTest.start("save");
			
			var writer:ZipFileWriter = new ZipFileWriter();
			writer.openAsync(this.file);
			
			// file info
			var fileData:ByteArray = new ByteArray();
			fileData.writeUTFBytes(this.getXMLData());
			writer.addBytes(fileData,"kvs.xml");
			//fileData.clear();
			
			//图片相关
			var imgIDs:Array = ImgLib.imgKeys;
			var imgDataBytes:ByteArray;
			
			//缩略图
			var bmd:BitmapData = core.thumbManager.getShotCut(ConfigInitor.THUMB_WIDTH, ConfigInitor.THUMB_HEIGHT);
			if (bmd)
			{
				imgDataBytes = PNGEncoder.encode(bmd);
				writer.addBytes(imgDataBytes,"preview.png");
			}
			
			// 添加图片资源数据
			for each (var imgID:uint in imgIDs)
			{
				//imgDataBytes.clear();
				imgDataBytes = ImgLib.getData(imgID);
				writer.addBytes(imgDataBytes,imgID.toString() + '.png');
			}
			
			writer.close();
			
			PerformaceTest.end("save");
		}
	}
}