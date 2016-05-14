package langameclasses
{
	import Core.Hero;
	
	import Engine.Locator;
	
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	import flash.ui.Mouse;
	
	public class PlayerBrain
	{
		public var controlled:Hero;
		
		
		
		public var up:Boolean;
		public var down:Boolean;
		public var left:Boolean;
		public var right:Boolean;
		public var space:Boolean;
		public var atk1:Boolean;
		public var moviendoce:Boolean;
		public var doublePressingRightDown:Boolean;
		public var doublePressingRightUp:Boolean;
		
		public function PlayerBrain(objectControlled:Hero)
		{
			this.controlled = objectControlled;
			
			Locator.mainStage.addEventListener(KeyboardEvent.KEY_UP, evKeyUp);
			Locator.mainStage.addEventListener(KeyboardEvent.KEY_DOWN, evKeyDown);
			
		}
		
		protected function keyDown(e:KeyboardEvent):void
		{
			switch(e.keyCode)
			{
				case upKey:
				{
					doublePressingRightDown=false;
					doublePressingRightUp=false;
					up=true;
					break;
				}
				case downKey:
				{
					doublePressingRightDown=false;
					doublePressingRightUp=false;
					down=true;
					break;
				}
				case leftKey:
				{
					doublePressingRightDown=false;
					doublePressingRightUp=false;
					left=true;
					break;
				}
				case rightKey:
				{
					doublePressingRightDown=false;
					doublePressingRightUp=false;
					right=true;
					break;
				}
				case atk1Key:
				{
					if(!holding&&Level.pauseboolean==false&&!block)
					{
						holding=true;
						arrowForThrowingGranade();
						throwingGranade=true;
					}
					else if (!granadebool&&Level.pauseboolean==false&&!block)
					{
						granadebool=true
						blockeodeanimacion=true;
						
						if (isjumping)
						{
							throwGranade();
							blockeodeanimacion=false;
						}
						else
						{
							changeAnimation(ANIM_SHOTANIM);
						}
						deleteArrowForThrowingGranade();
						holding=false;
						
					}
					break;
				}
			}
		}
		protected function keyUp(e:KeyboardEvent):void
		{
			
			switch(e.keyCode)
			{
				case upKey:
				{
					up=false;
					canJump=true;
					break;
				}
				case downKey:
				{
					down=false;
					break;
				}
				case leftKey:
				{
					left=false;
					moviendoce=false;
					trace(blockeodeanimacion);
					if (!isjumping && !Level.gameEnded&&!blockeodeanimacion)
					{
						trace("idle")
						changeAnimation(ANIM_IDLE);
					}
					break;
				}
				case rightKey:
				{
					right=false;
					moviendoce=false;
					trace(blockeodeanimacion);
					if (!isjumping && !Level.gameEnded&&!blockeodeanimacion)
					{
						trace("idle")
						changeAnimation(ANIM_IDLE);
					}
					break;
				}
					
				case atk1Key:
				{
					
					granadebool= false;
					break;
					
				}
			}
		}
		
		public function update():void
		{
			checkKeys();
		}
		public function checkKeys():void
		{
			if (!controlled.block)
			{
				
				if(!controlled.throwingGranade)
				{
					
					
					if (up&&canJump&&JumpContador<2) 
					{
						fallSpeed=-18;
						canJump = false;
						JumpContador++;
						if(JumpContador==0)
						{
							changeAnimation(ANIM_JUMPSTART);
						}
						if(JumpContador==1)
						{
							changeAnimation(ANIM_JUMPIDLE);
						}
						isjumping=true;
						jumpSound=Locator.assetsManager.getSound("jumpsound");
						audioSelection = new SoundController(jumpSound);
						
						audioSelection.play(0);
						audioSelection.volume=0.1;
					}
					if (down&&canmove) 
					{
						framecontador=0;
					}
					if (left) 
					{
						move(-1)
					}
					if (right) 
					{
						move(1)
					}
				}
				else
				{
					if(up && right)
					{
						pointingArrow.model.rotation=-45;
					}
					else if(right && down)
					{
						pointingArrow.model.rotation=45;
					}
					else if(left && up)
					{
						pointingArrow.model.rotation=-135;
					}
					else if(left && down)
					{
						pointingArrow.model.rotation=135;
					}
					else
					{
						if(up)
						{
							pointingArrow.model.rotation=-90;
						}
						if(down) 
						{
							pointingArrow.model.rotation=90;
						}
						if(left) 
						{
							pointingArrow.model.rotation=180;
						}
						if(right) 
						{
							pointingArrow.model.rotation=0;
						}
					}
				}
			}
			
		}
	}
}