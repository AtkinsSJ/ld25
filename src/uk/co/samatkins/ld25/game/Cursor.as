package uk.co.samatkins.ld25.game 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Input;
	
	/**
	 * ...
	 * @author Samuel Atkins
	 */
	public class Cursor extends Entity 
	{
		private var image:Image;
		
		public function Cursor() 
		{
			graphic = image = Image.createRect(1, 1, 0xffffff, 0.5);
			image.scaleX = 0;
			image.scaleY = 0;
		}
		
		public function setSize(w:uint, h:uint):void {
			setHitbox(w * GameWorld.TILE_SIZE, h * GameWorld.TILE_SIZE);
			image.scaleX = width;
			image.scaleY = height;
		}
		
		override public function update():void 
		{
			super.update();
			
			this.x = Math.floor((Input.mouseX + world.camera.x) / GameWorld.TILE_SIZE) * GameWorld.TILE_SIZE;
			this.y = Math.floor((Input.mouseY + world.camera.y) / GameWorld.TILE_SIZE) * GameWorld.TILE_SIZE;
			
			if (collideTypes(["building"], x, y)) {
				image.color = 0xff0000;
			} else {
				image.color = 0x00ff00;
			}
		}
		
	}

}