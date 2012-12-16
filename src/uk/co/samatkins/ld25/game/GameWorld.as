package uk.co.samatkins.ld25.game 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Particle;
	import net.flashpunk.graphics.ParticleType;
	import net.flashpunk.graphics.Tilemap;
	import net.flashpunk.Sfx;
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
		
		[Embed(source = "../../../../../../assets/goat1.mp3")] public static const GOAT1_MP3:Class;
		[Embed(source = "../../../../../../assets/goat2.mp3")] public static const GOAT2_MP3:Class;
		[Embed(source = "../../../../../../assets/goat3.mp3")] public static const GOAT3_MP3:Class;
		[Embed(source="../../../../../../assets/goatgrab.mp3")] public static const GOATGRAB_MP3:Class;
		[Embed(source = "../../../../../../assets/goatdeath.mp3")] public static const GOATDEATH_MP3:Class;
		[Embed(source = "../../../../../../assets/eat1.mp3")] public static const EAT1_MP3:Class;
		[Embed(source = "../../../../../../assets/eat2.mp3")] public static const EAT2_MP3:Class;
		[Embed(source = "../../../../../../assets/eat3.mp3")] public static const EAT3_MP3:Class;
		[Embed(source = "../../../../../../assets/sleep.mp3")] public static const SLEEP_MP3:Class;
		[Embed(source = "../../../../../../assets/build.mp3")] public static const BUILD_MP3:Class;
		[Embed(source = "../../../../../../assets/mine1.mp3")] public static const MINE1_MP3:Class;
		[Embed(source = "../../../../../../assets/mine2.mp3")] public static const MINE2_MP3:Class;
		[Embed(source = "../../../../../../assets/mine3.mp3")] public static const MINE3_MP3:Class;
		
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
		
		public var sfx:Object = { };
		
		override public function begin():void 
		{
			super.begin();
			
			// Sounds
			sfx["goat1"] = new Sfx(GOAT1_MP3);
			sfx["goat2"] = new Sfx(GOAT2_MP3);
			sfx["goat3"] = new Sfx(GOAT3_MP3);
			sfx["goatgrab"] = new Sfx(GOATGRAB_MP3);
			sfx["goatdeath"] = new Sfx(GOATDEATH_MP3);
			sfx["eat1"] = new Sfx(EAT1_MP3);
			sfx["eat2"] = new Sfx(EAT2_MP3);
			sfx["eat3"] = new Sfx(EAT3_MP3);
			sfx["sleep"] = new Sfx(SLEEP_MP3);
			sfx["build"] = new Sfx(BUILD_MP3);
			sfx["mine1"] = new Sfx(MINE1_MP3);
			sfx["mine2"] = new Sfx(MINE2_MP3);
			sfx["mine3"] = new Sfx(MINE3_MP3);
			
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
		
		public function playSound(sound:String):void {
			if (sound in sfx) {
				sfx[sound].play();
			}
		}
	}

}