package Core
{
	import Characters.RedPanda;
	
	import Engine.Locator;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.filters.GlowFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.media.Sound;
	import flash.sampler.NewObjectSample;
	import flash.ui.Keyboard;
	
	public class Level
	{
		//public static var instance:Level;
		public var levelName:String;
		
		public var level:MovieClip;
		public var deadline:MovieClip;
		public static var gamestarted:Boolean=false;
		public static var gameEnded:Boolean = false;
		
		public var allPlatformsOfLevel1:Array;
		public var allplatformsbase:Array;
		public var allWallsOfLevel1:Array;
		
		
		public static var allPlayers:Vector.<Hero>;
		public var playersCount:int;
		//////////////////////////////////////CameraSet////////////////////////////////////////////
		public var camLookAt:MovieClip;
		public var mid2Players:Point;
		public var playersGlobalPositions:Vector.<Point>;
		public var playersLocalPositions:Vector.<Point>;
		public var playersGlobalPositionNearestToEdges:Vector.<Point>;
		public var playersLocalPositionNearestToEdges:Vector.<Point>;
		public static var canZoomIn:Boolean=true;
		public var cam:Camera;
		public var sideLimitsX:Number;
		public var stop:Boolean=false;
		public var fixCamera:Boolean;
		public var fixCameraTimer:Number;
		
		/////////////////////////////////////////////Pause//////////////////////////////////////////////////////////
		public var pause:Pause = new Pause;
		public static var pauseboolean:Boolean=false;
		////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		public var audio:SoundController;
		public var audiovictory:SoundController;
		public var audioselection:SoundController;
		public var bool:Boolean;
		
		
		public function Level(level:String, amountOfPlayers:int)
		{
			evStartGame(level, amountOfPlayers);
		}
		public function evStartGame(level:String, playersCountForGame:int):void
		{
			
			levelName=level;
			bool=false;
			playersCount = playersCountForGame;
			createPause();
			var song:Sound=	Locator.assetsManager.getSound("song1");
			audio = new SoundController(song);
			audio.play(11)
			audio.volume=0.2;
			
			allPlatformsOfLevel1 = new Array();
			allplatformsbase = new Array();
			allWallsOfLevel1= new Array();
			allPlayers= new Vector.<Hero>;
			
			//////////////////////////////////////CameraSet////////////////////////////////////////////
			mid2Players = new Point(0, 0);
			playersGlobalPositions = new Vector.<Point>;
			playersLocalPositions = new Vector.<Point>;
			sideLimitsX=100;
			
			this.level=Locator.assetsManager.getMovieClip(level);
			this.level.MC_spawn.alpha=0
			this.level.MC_spawn2.alpha=0
			camLookAt=Locator.assetsManager.getMovieClip("MCBackGround");
			camLookAt.scaleX = camLookAt.scaleY = 0.05;
			camLookAt.alpha=0;
			camLookAt.x=Locator.mainStage.stageWidth/2;
			camLookAt.y=Locator.mainStage.stage.stageHeight/2;
			this.level.addChild(camLookAt);
			///////////////////////////////////////////////////////////////////////////////////////////
			
			cam = new Camera();
			cam.on();
			
			
			
			
			deadline=this.level.MC_dead;
			deadline.alpha=0;
			
			cam.addToView(this.level);
			
			allPlatformsToArrayLevel1();
			allWallsToArrayLevel1();
			
			
			playersGlobalPositionNearestToEdges= new Vector.<Point>;
			playersLocalPositionNearestToEdges= new Vector.<Point>;
			
			gameEnded=false;
			Locator.mainStage.addEventListener(Event.ENTER_FRAME, update)
			Locator.mainStage.addEventListener(KeyboardEvent.KEY_UP, keyUp)
				
			
		}
		public function createPause():void
		{
			pause=new Pause;
			pause.getlevel(levelName, playersCount);
		}
		public function keyUp(event:KeyboardEvent):void
		{
			switch(event.keyCode)
			{
				case Keyboard.P:
				{
					if(!pauseboolean)
					{
						createPause();
						pause.PauseOn();
						pauseboolean=true;	
						break;
					}
					else
					{
						pauseboolean=false;	
						pause.PausedOff();
					}
				}
			}
		}
		
		public function update(event:Event):void
		{
			cam.lookAt(camLookAt)
			if (!pauseboolean)
			{
				
				if(!gameEnded)
				{
					for (var i:int = 0; i < allPlayers.length; i++) 
					{
						allPlayers[i].Update();
					}
					checkDeaths();
					/////////////////actualizo posiciones guardadas////////////////////
					updatePlayerGlobalAndLocalPositions();
					GetNearestPlayersToSides();
					GetNearestPlayersToSidesLocal();
					checkCamera();
					///////////////////////////Collitions//////////////////////////////
					granadeCollitions()
					
				}
				checkPlayersColitions();
				
				if(allPlayers.length==1 && gameEnded)
				{
					victorySet();
					gameEnded=true;
					if(camLookAt.x>allPlayers[0].model.x+10)
					{
						camLookAt.x-=8;
						zoomIn();
					}
					else if(camLookAt.x<allPlayers[0].model.x-10)
					{
						camLookAt.x+=8;
						zoomIn();
					}
					else
					{
						if (!pauseboolean)
						{
							pause.PauseOn();
						}
					}
					
					if(camLookAt.y>allPlayers[0].model.y+10)
					{
						camLookAt.y-=8;
					}
					else if(camLookAt.y<allPlayers[0].model.y-10)
					{
						camLookAt.y+=8;
					}
				}
			}
		}
		
		public function addPlayers(name:String):Hero
		{
			var player:Hero;
			if(allPlayers.length==0)
			{
				player = new RedPanda(name, Keyboard.W, Keyboard.S, Keyboard.D, Keyboard.A,Keyboard.SPACE, Keyboard.Q);
			}
			else
			{
				player = new RedPanda(name, null, null, null, null, null, null);
			}
			allPlayers.push(player);
			playersCount++;
			//playersCount=1;
			//player.spawn(this.level.MC_spawn.x, this.level.MC_spawn.y, this.level);
				/*for (var j:int = 0; j < playersCount; j++) 
				{
					if(j==0)
					{
						
						
					}
					else if(j==1)
					{
						player = new RedPanda(Keyboard.UP, Keyboard.DOWN, Keyboard.RIGHT, Keyboard.LEFT, Keyboard.COMMA, Keyboard.M);
						player.model.transform.colorTransform= new ColorTransform(1.35,1.66,1.77)
						allPlayers.push(player);
					}
					else if(j==2)
					{
						player = new RedPanda(Keyboard.Y, Keyboard.H, Keyboard.J, Keyboard.G, Keyboard.K, Keyboard.L);
						allPlayers.push(player);
					}
					else if(j==3)
					{
						player = new RedPanda(Keyboard.NUMPAD_8, Keyboard.NUMPAD_5, Keyboard.NUMPAD_6, Keyboard.NUMPAD_4, Keyboard.NUMPAD_7, Keyboard.NUMPAD_9);
						allPlayers.push(player);
					}
					player.model.transform.colorTransform = new ColorTransform(0,0,115,1)
					player.model.transform.colorTransform= new ColorTransform(2.55,2.06,0.88)
					player.model.transform.colorTransform= new ColorTransform(1.69,2.32,2.55)
					player.model.transform.colorTransform= new ColorTransform(1.69,1.92,2.05)
				}*/
				
				
				
				/*for (var i:int = 0; i < allPlayers.length; i++) 
				{
					if(i==0)
					{
						allPlayers[i].spawn(this.level.MC_spawn.x, this.level.MC_spawn.y, this.level);
					}
					else if(i==1)
					{
						allPlayers[i].model.scaleX*=-1;
						allPlayers[i].spawn(this.level.MC_spawn2.x, this.level.MC_spawn2.y, this.level);
					}
					else if(i==2)
					{
						allPlayers[i].spawn(this.level.MC_spawn.x+500, this.level.MC_spawn.y, this.level);
					}
					else if(i==3)
					{
						allPlayers[i].model.scaleX*=-1;
						allPlayers[i].spawn(this.level.MC_spawn2.x-500, this.level.MC_spawn2.y, this.level);
					}
					getPlayerPositionFromLocalToGlobal(allPlayers[i]);
				}*/
			return player;
		}
		public function victorySet():void
		{
			if (!bool)
			{
				var yeah:Sound=Locator.assetsManager.getSound("yeahsound")
				var horn:Sound=Locator.assetsManager.getSound("victoryhorn")
				audioselection = new SoundController(yeah);
				audiovictory = new SoundController(horn);
				audiovictory.play(0);
				audiovictory.volume=0.3;
				audioselection.play(0);
				audioselection.volume=0.3;
				bool=true
				allPlayers[0].block=true;
				if(allPlayers[0].arrowbool)
				{
					allPlayers[0].deleteArrowForThrowingGranade();
				}
				for (var i:int = allPlayers[0].granades.length-1; i >= 0; i--) 
				{
					allPlayers[0].granades[i].destroy(level);
					allPlayers[0].granades.splice(i, 1);
				}
				
				
			}
		}
		///////////////////////////////////////////////////////CameraControl/////////////////////////////////////
		protected function zoomIn():void
		{
			if(canZoomIn && cam.zoom<=1.4)
			{
				cam.smoothZoom = cam.zoom * 1.1;
				sideLimitsX=100;
			}
		}
		
		protected function zoomOut():void
		{
			if(cam.zoom>=0.3)
			{
				canZoomIn=false;
				cam.smoothZoom = cam.zoom / 1.3;
				sideLimitsX--
			}
			
		}		
		public function GetNearestPlayersToSidesLocal():void 
		{
			var lowestValues:Point = new Point(10000, 10000);
			var highestValues:Point = new Point(-10000, -10000);
			var tempPlayer:Vector.<Point> = new Vector.<Point>();
			var tempPlayerY:Vector.<Point> = new Vector.<Point>();
			for (var i:int = 0; i < playersLocalPositions.length; i++) 
			{
				if(playersLocalPositions[i].x<lowestValues.x)
				{
					lowestValues.x=playersLocalPositions[i].x;
				}
				if(playersLocalPositions[i].x>highestValues.x)
				{
					highestValues.x=playersLocalPositions[i].x;
				}
				if(playersLocalPositions[i].y<lowestValues.y)
				{
					lowestValues.y=playersLocalPositions[i].y;
				}
				if(playersLocalPositions[i].y>highestValues.y)
				{
					highestValues.y=playersLocalPositions[i].y;
				}
			}
			tempPlayer.push(lowestValues);
			tempPlayer.push(highestValues);
			playersLocalPositionNearestToEdges=tempPlayer;
		}
		public function GetNearestPlayersToSides():void 
		{
			var lowestValues:Point = new Point(10000, 10000);
			var highestValues:Point = new Point(-10000, -10000);
			var tempPlayer:Vector.<Point> = new Vector.<Point>();
			var tempPlayerY:Vector.<Point> = new Vector.<Point>();
			for (var i:int = 0; i < playersLocalPositions.length; i++) 
			{
				if(playersGlobalPositions[i].x<lowestValues.x)
				{
					lowestValues.x=playersGlobalPositions[i].x;
				}
				if(playersGlobalPositions[i].x>highestValues.x)
				{
					highestValues.x=playersGlobalPositions[i].x;
				}
				if(playersGlobalPositions[i].y<lowestValues.y)
				{
					lowestValues.y=playersGlobalPositions[i].y;
				}
				if(playersGlobalPositions[i].y>highestValues.y)
				{
					highestValues.y=playersGlobalPositions[i].y;
				}
			}
			tempPlayer.push(lowestValues);
			tempPlayer.push(highestValues);
			playersGlobalPositionNearestToEdges=tempPlayer;
		}
		public function getPlayerPositionFromLocalToGlobal(player:Hero):void
		{
			var pLocal:Point = new Point(0, 0);
			var pGlobal:Point;
			
			pLocal= new Point(player.model.x, player.model.y);
			pGlobal = player.model.parent.localToGlobal(pLocal);
			playersLocalPositions.push(pLocal);
			playersGlobalPositions.push(pGlobal);
		}
		public function updatePlayerGlobalAndLocalPositions():void
		{
			var tempPLocal:Point;
			var tempPGlobal:Point;
			
			for (var i:int = 0; i < allPlayers.length; i++) 
			{
				tempPLocal= new Point(allPlayers[i].model.x, allPlayers[i].model.y);
				tempPGlobal = allPlayers[i].model.parent.localToGlobal(tempPLocal);
				playersLocalPositions[i]=tempPLocal;
				playersGlobalPositions[i]=tempPGlobal;
			}
		}
		
		public function checkCamera():void
		{
			mid2Players.x = (playersLocalPositionNearestToEdges[0].x + playersLocalPositionNearestToEdges[1].x)/2;
			mid2Players.y = (playersLocalPositionNearestToEdges[0].y + playersLocalPositionNearestToEdges[1].y)/2;
			if(playersGlobalPositionNearestToEdges[0].x<sideLimitsX)
			{
				zoomOut()
			}
			else if(playersGlobalPositionNearestToEdges[1].x>Locator.mainStage.stageWidth-sideLimitsX)
			{
				zoomOut()
			}
			else if(playersGlobalPositionNearestToEdges[0].y<100)
			{
				zoomOut()
			}
			else if(playersGlobalPositionNearestToEdges[1].y>Locator.mainStage.stageHeight-100)
			{
				zoomOut()
			}
			if(playersGlobalPositionNearestToEdges[0].x>200 && 
				playersGlobalPositionNearestToEdges[1].x<Locator.mainStage.stageWidth-200 &&
				playersGlobalPositionNearestToEdges[0].y>150 && 
				playersGlobalPositionNearestToEdges[1].y<Locator.mainStage.stageHeight-150)
			{
				zoomIn()
			}
			if(!fixCamera)
			{
				camLookAt.x=mid2Players.x;
				camLookAt.y=mid2Players.y;
			}
			else
			{
				if(camLookAt.x>=mid2Players.x+10)
				{
					camLookAt.x-=5;
				}
				else if(camLookAt.x<=mid2Players.x-10)
				{
					camLookAt.x+=5;
				}
				if(camLookAt.y>=mid2Players.y+10)
				{
					camLookAt.y-=5;
				}
				else if(camLookAt.y<=mid2Players.y-10)
				{
					camLookAt.y+=5;
				}
				fixCameraTimer-=1000/60;
				if(fixCameraTimer<=0)
				{
					fixCamera=false;
				}
			}
		}
		
		///////////////////////////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////////////////////////////////////////////////////
		public function allPlatformsToArrayLevel1():void
		{
			for (var i:int = 0; i < level.numChildren; i++) 
			{
				if(level.getChildAt(i).name=="mc_platform")
				{
					allPlatformsOfLevel1.push(level.getChildAt(i));
					level.getChildAt(i).alpha=0;
					
				}
				else if (level.getChildAt(i).name=="mc_platformbase")
				{
					allplatformsbase.push(level.getChildAt(i));
					level.getChildAt(i).alpha=0; 
				}
			}
		}
		public function allWallsToArrayLevel1():void
		{
			for (var i:int = 0; i < level.numChildren; i++) 
			{
				if(level.getChildAt(i).name=="mc_wall")
				{
					allWallsOfLevel1.push(level.getChildAt(i));
					level.getChildAt(i).alpha=0;
				}
			}
		}	
		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//****************************************** Colition Checks ***********************************************************//
		public function checkDeaths():void
		{
			for (var k:int = allPlayers.length-1; k >= 0; k--) 
			{
				if (allPlayers[k].model.MC_botHitBox.hitTestObject(deadline))
				{
					allPlayers[k].destroy();
					allPlayers.splice(k, 1);
					playersGlobalPositionNearestToEdges=new Vector.<Point>;
					playersLocalPositionNearestToEdges=new Vector.<Point>;
					playersGlobalPositions= new Vector.<Point>;
					playersLocalPositions= new Vector.<Point>;
					fixCamera=true;
					fixCameraTimer=2000;
				}
			}
		}
		public function checkPlayersColitions():void
		{
			for (var k:int =  allPlayers.length-1; k >= 0; k--) 
			{
				
				for (var i:int = 0; i < allPlatformsOfLevel1.length; i++) 
				{
					if(allPlayers[k].model.MC_botHitBox.hitTestObject(allPlatformsOfLevel1[i])&&allPlayers[k].framecontador>=6&&allPlayers[k].fallSpeed>0)
					{
						if (allPlayers[k].isjumping&&!allPlayers[k].block ||allPlayers[k].fallSpeed>8)
						{
							allPlayers[k].changeAnimation(allPlayers[k].ANIM_IDLE);
						}
						allPlayers[k].fallSpeed=0;
						allPlayers[k].model.y=allPlatformsOfLevel1[i].y-allPlatformsOfLevel1[i].height+5;
						allPlayers[k].JumpContador=0;
						
						allPlayers[k].isjumping=false;
					}				
				}
				for (var c:int = 0; c < allplatformsbase.length; c++) 
				{
					if(allPlayers[k].model.MC_botHitBox.hitTestObject(allplatformsbase[c])&&allPlayers[k].fallSpeed>0)
					{
						if (allPlayers[k].isjumping&&!allPlayers[k].block ||allPlayers[k].fallSpeed>8)
						{
							allPlayers[k].changeAnimation(allPlayers[k].ANIM_IDLE);
						}
						allPlayers[k].fallSpeed=0;
						allPlayers[k].model.y=allplatformsbase[c].y-allplatformsbase[c].height+5;
						allPlayers[k].JumpContador=0;
						
						allPlayers[k].isjumping=false;
					}				
				}
				for (var j:int = 0; j < allWallsOfLevel1.length; j++) 
				{
					if(allPlayers[k].model.MC_sideHitBox.hitTestObject(allWallsOfLevel1[j]))
					{
						allPlayers[k].canmove=false;
					}
				}
			}
		}
		
		
		public function granadeCollitions():void
		{
			for (var j:int = allPlayers.length-1; j >= 0; j--) 
			{
				for (var i:int = allPlayers[j].granades.length-1; i >= 0; i--) 
				{
					if(!allPlayers[j].granades[i].exploded)
					{
						for (var l:int = 0; l < allPlatformsOfLevel1.length; l++) 
						{
							if(allPlayers[j].granades[i].model.MC_botHitBox.hitTestObject(allPlatformsOfLevel1[l]) && allPlayers[j].granades[i].fallSpeed>10)
							{
								allPlayers[j].granades[i].fallen=true;
								allPlayers[j].granades[i].model.y=allPlatformsOfLevel1[l].y-allPlatformsOfLevel1[l].height;
								allPlayers[j].granades[i].fallSpeed=allPlayers[j].granades[i].fallSpeed/-3;
								allPlayers[j].granades[i].speed=allPlayers[j].granades[i].speed/1.5;
							}      
						}
						
						for (var c:int = 0; c < allplatformsbase.length; c++) 
						{
							if(allPlayers[j].granades[i].model.MC_botHitBox.hitTestObject(allplatformsbase[c]) && allPlayers[j].granades[i].fallSpeed>10)
							{
								allPlayers[j].granades[i].fallen=true;
								allPlayers[j].granades[i].model.y=allplatformsbase[c].y-allplatformsbase[c].height;
								allPlayers[j].granades[i].fallSpeed=allPlayers[j].granades[i].fallSpeed/-3;
								allPlayers[j].granades[i].speed=allPlayers[j].granades[i].speed/1.5;
							}      
						}
						for (var k:int= allPlayers.length-1; k >= 0; k--) 
						{
							if(k!=j && allPlayers[j].granades[i].model.hitTestObject(allPlayers[k].model) && allPlayers[j].granades[i].currentColdownToApplyForceOnPlayer<=0)
							{
								var direction:Point = new Point;
								var distance:Point = new Point;
								var radians:Number;
								var degrees:Number;
								
								distance.x = allPlayers[k].model.x- allPlayers[j].granades[i].model.x;
								distance.y = allPlayers[k].model.y- allPlayers[j].granades[i].model.y;
								radians = Math.atan2(distance.y, distance.x);
								
								direction.x = Math.cos(radians);
								direction.y = Math.sin(radians);
								allPlayers[j].granades[i].explode(level);
								allPlayers[k].gotHitByGranade=true;
								allPlayers[k].directionToFlyByGranade=direction;
								
								
								break;
							}  
							
						}
					}
					
				}
			}
		}
		
		/*public function destroyall():void
		{
			for (var k:int = 0; k < allPlatformsOfLevel1.length; k++) 
			{
				allPlatformsOfLevel1.splice(k,1);
			}
			
			for (var c:int = 0; c < allplatformsbase.length; c++) 
			{
				allplatformsbase.splice(c,1);
			}
			
			for (var j:int = 0; j < allWallsOfLevel1.length; j++) 
			{
				allWallsOfLevel1.splice(j,1);
			}
			for (var i:int = allPlayers.length-1; i >= 0; i--) 
			{
				allPlayers[i].destroy();
				allPlayers.splice(i,1);
			}
			cam.off();
			cam=new Camera
			Locator.mainStage.removeEventListener(Event.ENTER_FRAME, update)
			audio.stop();
			pause=null;
		}*/
	}
}