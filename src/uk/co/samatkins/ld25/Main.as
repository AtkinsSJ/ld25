package uk.co.samatkins.ld25
{
	import net.flashpunk.Engine;
	import net.flashpunk.FP;
	import uk.co.samatkins.ld25.game.GameWorld;
	import uk.co.samatkins.ld25.menu.MenuWorld;
	import net.flashpunk.utils.Key;

	/**
	 * ...
	 * @author Samuel Atkins
	 */
	public class Main extends Engine 
	{
		public function Main():void 
		{
			super(400, 300, 30, false);
			FP.screen.scale = 2;
			FP.screen.color = 0xffffff;
			trace("RUNNING!");
			
			FP.world = new GameWorld;
			FP.volume = 0.5;
			
			//FP.console.enable();
			FP.console.toggleKey = Key.F1;
		}
	}

}