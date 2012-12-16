package uk.co.samatkins.ld25.game 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.FP;
	
	/**
	 * ...
	 * @author Samuel Atkins
	 */
	public class Paused extends Entity 
	{
		
		public function Paused() 
		{
			super(0, 0);
			
			addGraphic(Image.createRect(FP.width, FP.height, 0x0, 0.5));
			addGraphic(new Text("GAME PAUSED", 0, FP.halfHeight - 16, {
				align: "center",
				color: 0xffffff,
				size: 32,
				width: FP.width
			}));
			
			graphic.scrollX = 0;
			graphic.scrollY = 0;
			
			visible = false;
			layer = -99999;
		}
		
	}

}