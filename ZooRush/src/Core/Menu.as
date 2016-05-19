package Core
{
	import Engine.Locator;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.media.Sound;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;
	
	import net.Client;
	import net.ClientData;
	
	public class Menu
	{
		//////////////////////////////net////////////////////////////////////////
		public var me:Hero;
		public static var client:Client;
		public var allOthers:Dictionary = new Dictionary();
		////////////////////////////////////////////////////////////////////////
		
		
		public var menuOption:int;
		public var menu:int;
		public var menu1:MovieClip;
		public var menu2:MovieClip;
		public var creditos:MovieClip;
		public var howToPlay:MovieClip;
		
		public var mainlevel:Level;
		
		
		public var audioselection:SoundController;
		public var selectionsound:Sound;
		public var backsound:Sound;
		public var aceptarsounds:Sound;
		public function Menu()
		{
			selectionsound=Locator.assetsManager.getSound("soundchangeselection");
			backsound=Locator.assetsManager.getSound("soundselectionatras");
			aceptarsounds=Locator.assetsManager.getSound("soundselectionaceptar");
			
			menu1=Locator.assetsManager.getMovieClip("MC_Menu1");
			menu2=Locator.assetsManager.getMovieClip("MC_Menu2");
			creditos=Locator.assetsManager.getMovieClip("MC_Creditos");
			howToPlay=Locator.assetsManager.getMovieClip("MC_howToPlay");
			howToPlay.scaleX=0.5;
			howToPlay.scaleY=0.5;
			creditos.scaleX=0.5;
			creditos.scaleY=0.5;
			menu1.scaleX=0.5;
			menu1.scaleY=0.5;
			menu2.scaleX=0.5;
			menu2.scaleY=0.5;
			Locator.mainStage.addChild(menu1)
			menu1.MC_creditos.alpha=0
			menuOption=1;
			menu=1;
			Locator.mainStage.addEventListener(KeyboardEvent.KEY_UP, keyUp)
		}
		protected function keyUp(e:KeyboardEvent):void
		{
			switch(e.keyCode)
			{
				/*case Keyboard.I:
				{
					mainlevel.addPlayers();
					break;
				}*/
				case Keyboard.UP:
				{
					
					if(menu==1)
					{
						if(menuOption==2)
						{
							menu1.MC_jugar.alpha=1;
							menu1.MC_creditos.alpha=0;
							
							audioselection = new SoundController(selectionsound);
							audioselection.play(0);
							audioselection.volume=0.3;
						}
						else if(menuOption==3)
						{
							
						}
					}
					else if(menu==2)
					{
						if(menuOption==2)
						{
							menu2.MC_level2.alpha=0;
							menu2.MC_level1.alpha=1;
							
							audioselection = new SoundController(selectionsound);
							audioselection.play(0);
							audioselection.volume=0.3;
						}
						else if(menuOption==3)
						{
							
						}
					}
					if(menuOption>1)
					{
						menuOption--;
					}
					break;
				}
				case Keyboard.DOWN:
				{
					
					if(menu==1)
					{
						if(menuOption==1)
						{
							menu1.MC_jugar.alpha=0;
							menu1.MC_creditos.alpha=1;
							
							audioselection = new SoundController(selectionsound);
							audioselection.play(0);
							audioselection.volume=0.3;
						}
						else if(menuOption==2)
						{
						}
					}
					else if(menu==2)
					{
						if(menuOption==1)
						{
							menu2.MC_level2.alpha=1;
							menu2.MC_level1.alpha=0;
							
							audioselection = new SoundController(selectionsound);
							audioselection.play(0);
							audioselection.volume=0.3;
						}
						else if(menuOption==2)
						{
							
						}
					}
					if(menuOption<2)
					{
						menuOption++;
					}
					break;
				}
					
				case Keyboard.ENTER:
				{
					if(menu==1)
					{
						if(menuOption==1)
						{
							Locator.mainStage.removeChild(menu1);
							Locator.mainStage.addChild(menu2);
							menu2.MC_level1.alpha=1;
							menu2.MC_level2.alpha=0;
							audioselection = new SoundController(aceptarsounds);
							audioselection.play(0);
							audioselection.volume=0.4;
							menuOption=1;
							menu=2;
							
						}
						else if(menuOption==2)
						{
							Locator.mainStage.removeChild(menu1);
							Locator.mainStage.addChild(creditos);
							audioselection = new SoundController(aceptarsounds);
							audioselection.play(0);
							audioselection.volume=0.4;
							menuOption=1;
							menu=3;
						}
						else if(menuOption==3)
						{
							
						}
					}
					else if(menu==2)
					{
						if(menuOption==1)
						{
							Locator.mainStage.removeChild(menu2);
							//mainlevel=new Level("MCLevel1", 2);
							//me = mainlevel.addPlayers("theNigga");
							client= new Client("theNigga" + Math.random());
							client.connect("186.18.110.42", 8087);
							client.addEventListener(Client.EVENT_CONNECTED, evConnected);
							client.addEventListener(Client.EVENT_NEW_CLIENT, evNewClient);
							client.addEventListener(Client.EVENT_GET_ALL_CLIENTS, evGetAllClient);
							client.addEventListener(Client.EVENT_RECEIVE_MESSAGE, evReceiveMessage);
							
							
							
							
							
							
							Level.gamestarted=true;
							audioselection = new SoundController(aceptarsounds);
							audioselection.play(0);
							audioselection.volume=0.4;
							Locator.mainStage.removeEventListener(KeyboardEvent.KEY_UP, keyUp);
								
						}
						else if(menuOption==2)
						{
							Locator.mainStage.removeChild(menu2);
							//mainlevel=new Level("MCLevel2", 2);
							//Level.gamestarted=true;
							client= new Client("theNigga" + Math.random());
							client.connect("186.18.110.42", 8087);
							client.addEventListener(Client.EVENT_CONNECTED, evConnected2);
							client.addEventListener(Client.EVENT_NEW_CLIENT, evNewClient);
							client.addEventListener(Client.EVENT_GET_ALL_CLIENTS, evGetAllClient);
							client.addEventListener(Client.EVENT_RECEIVE_MESSAGE, evReceiveMessage);
							
							
							audioselection = new SoundController(aceptarsounds);
							audioselection.play(0);
							audioselection.volume=0.4;
							Locator.mainStage.removeEventListener(KeyboardEvent.KEY_UP, keyUp)
						}
						else if(menuOption==3)
						{
							
						}
					}
					else if(menu==3)
					{
						Locator.mainStage.removeChild(creditos);
						Locator.mainStage.addChild(menu1);
						menu1.MC_jugar.alpha=1;
						menu1.MC_creditos.alpha=0;
						audioselection = new SoundController(aceptarsounds);
						audioselection.play(0);
						audioselection.volume=0.4;
						menu=1;
					}
					break;
				}
				case Keyboard.H:
				{
					if(Locator.mainStage.contains(menu1) && !Locator.mainStage.contains(howToPlay))
					{
						Locator.mainStage.addChild(howToPlay);
					}
					else if(Locator.mainStage.contains(menu1) && Locator.mainStage.contains(howToPlay))
					{
						Locator.mainStage.removeChild(howToPlay);
					}
				}
			}
		}
		
		private function evConnected2():void
		{
			trace("CONECTADO...");
			mainlevel = new Level("MCLevel2", 6);
			
			me = mainlevel.addPlayers(client.data.name);
			me.spawn(mainlevel.level.MC_spawn.x, mainlevel.level.MC_spawn.y, mainlevel.level);
			
			Main.instance.stage.addEventListener(Event.ENTER_FRAME, evUpdate);
			
			client.getAllClient();
		}
		private function evConnected():void
		{
			trace("CONECTADO...");
			mainlevel = new Level("MCLevel1", 6);
			
			me = mainlevel.addPlayers(client.data.name);
			me.spawn(mainlevel.level.MC_spawn.x, mainlevel.level.MC_spawn.y, mainlevel.level);
			
			Main.instance.stage.addEventListener(Event.ENTER_FRAME, evUpdate);
			
			client.getAllClient();
		}
		
		private function evReceiveMessage(message:String, params:Object):void
		{
			var h:Hero = allOthers[params.owner];
			if(h != null)
			{
				switch(message)
				{
					case "MoveHero":
						h.model.x = params.x;
						h.model.y = params.y;
						h.model.scaleX = params.scale;
						break;
					case "Jump":
						h.fallSpeed=params.fallSpeedd;
						h.isjumping=params.isjumpingg;
						break;
					case "changeAnimation":
						h.changeAnimation(params.animName);
						break;
					case "throwGranade":
						h.throwGranade(params.x, params.y, params.r, params.sX, mainlevel.level);
						break;
					
					/*case "Dead":
						h.dead();
						h.startPoint.x = params.spawnX;
						h.startPoint.y = params.spawnY;
						break;*/
				}
			}
		}
		private function evGetAllClient(all:Vector.<ClientData>):void
		{
			for (var i:int = 0; i < all.length; i++) 
			{
				if(all[i].name != client.data.name)
				{
					evNewClient(all[i]);
				}
			}
			
		}
		
		private function evNewClient(data:ClientData):void
		{
			var h:Hero = mainlevel.addPlayers(data.name);
			h.spawn(mainlevel.level.MC_spawn.x, mainlevel.level.MC_spawn.y, mainlevel.level);
			allOthers[data.name] = h;
		}
		
		
		protected function evUpdate(event:Event):void
		{
			// TODO Auto-generated method stub
			
		}
		public function destroyall():void
		{
			for (var k:int = 0; k < mainlevel.allPlatformsOfLevel1.length; k++) 
			{
				mainlevel.allPlatformsOfLevel1.splice(k,1);
			}
			
			for (var c:int = 0; c < mainlevel.allplatformsbase.length; c++) 
			{
				mainlevel.allplatformsbase.splice(c,1);
			}
			
			for (var j:int = 0; j < mainlevel.allWallsOfLevel1.length; j++) 
			{
				mainlevel.allWallsOfLevel1.splice(j,1);
			}
			for (var i:int = Level.allPlayers.length-1; i >= 0; i--) 
			{
				Level.allPlayers[i].destroy();
				Level.allPlayers.splice(i,1);
			}
			mainlevel.cam.off();
			mainlevel.cam=new Camera
			Locator.mainStage.removeEventListener(Event.ENTER_FRAME, mainlevel.update)
			Locator.mainStage.removeEventListener(KeyboardEvent.KEY_UP, mainlevel.keyUp)
			mainlevel.audio.stop();
			mainlevel.pause=null;
		}
	}
}