package Core
{
	
	
	import Engine.Locator;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.media.Sound;
	
	public class Granade
	{
		public var currentLVL:MovieClip;
		public var canDelete:Boolean;
		
		public var model:MovieClip;
		public var explosion:MovieClip;
		public var speed:Number = 30;
		public var degrees:Number;		
		public var radians:Number;
		public var direction:Point = new Point();
		public var distance:Point = new Point();
		public var force:int=10;
		public var fallSpeed:Number = 1;
		public var grav:int = 1;
		
		public var timeToExplode:int=1000;
		public var currentTimeToExplode:Number=timeToExplode;
		
		public var currentColdownToApplyForceOnPlayer:Number = 0;
		
		public var fallen:Boolean=false;
		
		
		public var exploded:Boolean=false;
		
		
		public var audioSelection:SoundController;

		
		public function Granade(posX:Number, posY:Number, rotation:Number, scaleX:int, level:MovieClip)
		{
			var gfilter:GlowFilter = new GlowFilter;
			model = Locator.assetsManager.getMovieClip("MCGranade");
			model.filters =[gfilter]
			explosion = Locator.assetsManager.getMovieClip("MC_Explosion");
			level.addChild(model);
			model.x=posX;
			model.y=posY;
			radians = rotation * Math.PI / 180;
			degrees = rotation;
			direction.x = Math.cos(radians);
			direction.y = Math.sin(radians);
			model.MC_botHitBox.alpha=0;
			model.MC_topHitBox.alpha=0;
			currentLVL=level;
			
			var lanzamientosound:Sound=Locator.assetsManager.getSound("bombalanzamiento")
			audioSelection=new SoundController (lanzamientosound)
			audioSelection.play(0);
		}
		public function fall():void
		{
			model.y+=fallSpeed;
			fallSpeed+=grav;
			
		}
		public function update():void
		{
			fall();
			model.x += direction.x * speed;
			if(!fallen)
			{
				model.y += direction.y * speed;
			}
			currentColdownToApplyForceOnPlayer-=1000/60;
			if(currentColdownToApplyForceOnPlayer<=0)
			{
				force=50;
			}
			else
			{
				force=0;
			}
		}
		public function destroy(level:MovieClip):void
		{
			if(level.contains(model))
			{
				level.removeChild(model);
			}
		}
		public function explode(level:MovieClip):void
		{
			if(!exploded)
			{
				var explosionsound:Sound=Locator.assetsManager.getSound("explosion")
				audioSelection=new SoundController (explosionsound);
				audioSelection.play(0);
				level.addChild(explosion);
				explosion.x=model.x;
				explosion.y=model.y;
				destroy(level);
				exploded=true;
				model.addEventListener(Event.ENTER_FRAME, updateExplosion);
			}
		}
		protected function updateExplosion(event:Event):void
		{
			if(explosion.currentFrame==20)
			{
				currentLVL.removeChild(explosion);
				canDelete=true;
				model.removeEventListener(Event.ENTER_FRAME, updateExplosion);
			}
		}
		
	}
}