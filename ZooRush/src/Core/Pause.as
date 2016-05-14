package Core 
{
	
	import Engine.Locator;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.media.Sound;
	import flash.ui.Keyboard;
	
	public class Pause
	{
		public var model:MovieClip;
		public var black:MovieClip;
		public var optionnumber:int=1;
		public var currentlevel:String;
		public var numOfPlayers:int;
		
		public var audioSelection:SoundController;
		public var selectionsound:Sound = Locator.assetsManager.getSound("soundchangeselection");
		public var aceptarsounds:Sound =Locator.assetsManager.getSound("soundselectionaceptar");
		public function Pause()
		{
			
		}
		
		protected function keyUp(e:KeyboardEvent):void
		{
			switch(e.keyCode)
			{
				
				
				case Keyboard.UP:
					
					if (optionnumber==2)
					{
						model.MC_continue.alpha=1;
						model.MC_restart.alpha=0;
						model.MC_exit.alpha=0;
					}
					else if (optionnumber==3)
					{
						model.MC_continue.alpha=0;
						model.MC_restart.alpha=1;
						model.MC_exit.alpha=0;
					}
					if (optionnumber>1)
					{
						optionnumber--;
						audioSelection = new SoundController(selectionsound);
						audioSelection.play(0);
						audioSelection.volume=0.3;
						
					}
					break;
				
				
				case Keyboard.DOWN:
					
					
					if (optionnumber==1)
					{
						model.MC_continue.alpha=0;
						model.MC_restart.alpha=1;
						model.MC_exit.alpha=0;
					}
					else if (optionnumber==2)
					{
						model.MC_continue.alpha=0;
						model.MC_restart.alpha=0;
						model.MC_exit.alpha=1;
					}
					if (optionnumber<3)
					{
						audioSelection= new SoundController(selectionsound);
						audioSelection.play(0);
						audioSelection.volume=0.3;
						optionnumber++;
						
					}
					break;
				
				
				case Keyboard.ENTER:
					if(optionnumber==1 && !Level.gameEnded)
					{
						PausedOff()
						audioSelection= new SoundController(aceptarsounds);
						audioSelection.play(0);
						audioSelection.volume=0.4;
					}
					else if(optionnumber==2)
					{
						PausedOff()						
						Main.instance.mainMenu.destroyall()
						Main.instance.mainMenu.mainlevel.evStartGame(currentlevel, numOfPlayers)
						audioSelection= new SoundController(aceptarsounds);
						audioSelection.play(0);
						audioSelection.volume=0.4;
					}
					else if(optionnumber==3)
					{
						PausedOff()
						Main.instance.mainMenu.destroyall();
						Main.instance.mainMenu.mainlevel=null;
						Locator.resetassets()
						Main.instance.loadAssets();
						audioSelection = new SoundController(aceptarsounds);
						audioSelection.play(0);
						audioSelection.volume=0.4;
						Level.gamestarted=false;
					}
					break;
			}
			
		}
		public function getlevel(level:String, numOfP:int):void
		{
			currentlevel=level;
			numOfPlayers=numOfP;
		}
		
			
		
		public function PauseOn():void
		{
			model=Locator.assetsManager.getMovieClip("MC_Pause");
			black=Locator.assetsManager.getMovieClip("MC_Black");
			Locator.mainStage.addEventListener(KeyboardEvent.KEY_UP, keyUp);
			Locator.mainStage.addChild(black);
			black.alpha=0.4;
			Locator.mainStage.addChild(model);
			model.scaleX=model.scaleY=0.5
			model.x=Main.instance.stage.stageWidth/2;
			model.y=Main.instance.stage.stageHeight/2;
			
			
			Level.pauseboolean=true;
			model.MC_restart.alpha=0;
			model.MC_exit.alpha=0;
			
		}
		
		
		
		public function PausedOff():void
		{
			optionnumber=1;
			Locator.mainStage.removeEventListener(KeyboardEvent.KEY_UP, keyUp);
			Locator.mainStage.removeChild(black);
			Locator.mainStage.removeChild(model);
			Level.pauseboolean=false;
		}
	}
}