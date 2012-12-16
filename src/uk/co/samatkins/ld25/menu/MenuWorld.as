package uk.co.samatkins.ld25.menu 
{
	import net.flashpunk.graphics.Text;
	import net.flashpunk.World;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import uk.co.samatkins.ld25.game.GameWorld;
	import net.flashpunk.graphics.Image;
	
	/**
	 * ...
	 * @author Samuel Atkins
	 */
	public class MenuWorld extends World 
	{
		[Embed(source = "../../../../../../assets/menu.png")] public static const MENU_PNG:Class;
		
		override public function begin():void 
		{
			super.begin();
			
			addGraphic(new Image(MENU_PNG));
			
			addGraphic(new Text("Press space to begin!", 0, FP.height - 70, {
				align: "center",
				width: FP.width
			}));
			
			addGraphic(new Text("Made by Samuel \"AtkinsSJ\" Atkins for Ludum Dare 25", 0, FP.height - 20, {
				align: "center",
				size: 8,
				width: FP.width
			}));
		}
		
		override public function update():void 
		{
			super.update();
			
			if (Input.pressed(Key.SPACE)) {
				FP.world = new GameWorld();
			}
		}
		
	}

}