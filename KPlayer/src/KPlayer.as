package
{
	import flash.display.Sprite;
	import flash.external.ExternalInterface;
	import flash.system.Security;
	
	import landray.kp.core.KPPresenter;
	import landray.kp.utils.CoreUtil;
	import landray.kp.utils.ExternalUtil;
	
	import view.toolBar.Debugger;
	
	/**
	 * KPlayer主容器类
	 */
	public class KPlayer extends Sprite
	{
		
		/**
		 * 构造函数。
		 */
		public function KPlayer()
		{
			super();
			//注册初始化函数，容器添加至舞台后调用
			CoreUtil.initApplication(this, initialize, true);
		}
		
		
		//===========================================================================
		// start the app,
		// call presenter.start(container, path) to start.
		// container here is this.
		//===========================================================================
		
		/**
		 * @private
		 * 
		 */
		private function initialize():void
		{
			//initDebugger();
			Debugger.debug("初始化");
			
			//从网页获取ID参数
			appID = (loaderInfo.parameters.id) ? loaderInfo.parameters.id : "0";
			//安全沙箱
			Security.allowDomain("*");
			//添加JS回调函数,通知JS 初始化完毕，可以传递数据。
			if (ExternalUtil.initCallBack(this))
				ExternalUtil.kanvasReady();
		}
		
		private function initDebugger():void
		{
			if(!debugger)
				addChild(debugger = new Debugger);
		}
		
		/**
		 * appID
		 */
		public var appID:String;
		
		private var debugger:Debugger;
	}
}