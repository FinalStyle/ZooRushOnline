package Characters
{
	import Core.Hero;
	
	import Engine.Locator;
	
	import flash.display.MovieClip;
	import flash.ui.Keyboard;

	public class RedPanda extends Hero
	{
		public function RedPanda(name:String, up:int, down:int, right:int, left:int, shoot:int, atk1:int)
		{
			model = Locator.assetsManager.getMovieClip("MC_RedPanda");
			super(up, down, right, left, shoot, atk1, name)
		}
		
	}
}