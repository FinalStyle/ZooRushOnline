package
{
	import Characters.RedPanda;
	
	import Core.Camera;
	import Core.Hero;
	import Core.Level;
	import Core.Menu;
	import Core.SoundController;
	
	import Engine.Locator;
	
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.ui.Mouse;
	
	
	[SWF(height="720", width="1280", frameRate="60")]
	public class Main extends Locator
	{
		public static var instance:Main;
		
		public var mainMenu:Menu;
		
		
		
		public function Main()
		{
			//mainStage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
			mainStage.scaleMode = StageScaleMode.EXACT_FIT;
			instance = this;
			mouseEnabled=false;
			Mouse.hide()
			loadAssets();
		}
		public function loadAssets():void
		{
			Locator.assetsManager.loadLinks("linksleveltry.txt");
			Locator.assetsManager.addEventListener(Event.COMPLETE, evMainMenu);
		}
		protected function evMainMenu(event:Event):void
		{
			mainMenu=new Menu();
			mainMenu.menu=1;
			mainMenu.menuOption=1;
			trace("entra")
		}
		public function update(e:Event):void
		{	
			
		}
	}
}