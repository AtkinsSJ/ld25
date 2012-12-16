package uk.co.samatkins.ld25.game 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Particle;
	import net.flashpunk.graphics.ParticleType;
	import net.flashpunk.graphics.Tilemap;
	import net.flashpunk.World;
	import net.flashpunk.graphics.Emitter;
	import net.flashpunk.FP;
	
	/**
	 * ...
	 * @author Samuel Atkins
	 */
	public class GameWorld extends World 
	{
		[Embed(source = "../../../../../../assets/tiles.png")] public static const TILES_PNG:Class;
		[Embed(source = "../../../../../../assets/icons.png")] public static const ICONS_PNG:Class;
		
		public static const TILE_SIZE:uint = 16;
		
		public var emitter:Emitter;
		
		public var stone:uint = 10;
		public var population:uint = 0;
		public var goats:uint = 0;
		public var food:uint = 25;
		
		public var paused:Boolean = false;
		private var pauseMsg:Paused;
		
		public const MAP_WIDTH:uint = 100;
		public const MAP_HEIGHT:uint = 100;
		public const WORLD_WIDTH:uint = MAP_WIDTH * TILE_SIZE;
		public const WORLD_HEIGHT:uint = MAP_HEIGHT * TILE_SIZE;
		
		override public function begin():void 
		{
			super.begin();
			
			var t:Tilemap = new Tilemap(TILES_PNG, MAP_WIDTH * TILE_SIZE, MAP_HEIGHT * TILE_SIZE, TILE_SIZE, TILE_SIZE);
			t.setRect(0, 0, MAP_WIDTH, MAP_HEIGHT, 0);
			addGraphic(t);
			
			add(new UI).layer = -9999;
			
			emitter = new Emitter(ICONS_PNG, 16, 8);
			var s:ParticleType = emitter.newType("stone", [0]);
				s.setMotion(90, 30, 1);
			var g:ParticleType = emitter.newType("goblin", [1]);
				g.setMotion(90, 30, 1);
			var gt:ParticleType = emitter.newType("goat", [2]);
				gt.setMotion(90, 30, 1);
			var f:ParticleType = emitter.newType("food", [3]);
				f.setMotion(90, 30, 1);
			addGraphic(emitter).layer = -1000;
			
			var b:Building = new Building(MAP_WIDTH / 2, MAP_HEIGHT / 2, "campfire");
			add(b);
			camera.x = b.centerX - FP.halfWidth;
			camera.y = b.centerY - FP.halfHeight;
			
			pauseMsg = new Paused();
			add(pauseMsg);
		}
		
		override public function focusGained():void 
		{
			super.focusGained();
			paused = false;
			pauseMsg.visible = false;
		}
		
		override public function focusLost():void 
		{
			super.focusLost();
			paused = true;
			pauseMsg.visible = true;
		}
		
		override public function update():void 
		{
			if (!paused) super.update();
		}
	}

}