package uk.co.samatkins.ld25.game 
{
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	import net.flashpunk.graphics.Stamp;
	import net.flashpunk.tweens.misc.Alarm;
	
	/**
	 * ...
	 * @author Samuel Atkins
	 */
	public class Building extends Entity 
	{
		[Embed(source = "../../../../../../assets/hovel.png")] public static const HOVEL_PNG:Class;
		[Embed(source = "../../../../../../assets/pit.png")] public static const PIT_PNG:Class;
		[Embed(source = "../../../../../../assets/paddock.png")] public static const PADDOCK_PNG:Class;
		[Embed(source = "../../../../../../assets/butcher.png")] public static const BUTCHER_PNG:Class;
		[Embed(source = "../../../../../../assets/campfire.png")] public static const CAMPFIRE_PNG:Class;
		
		public static const TYPES:Object = {
			campfire:{w:3, h:3, image:CAMPFIRE_PNG, stone:0, employees:0, workPointsRequired:0 },
			hovel: 	{ w:1, h:1, image:HOVEL_PNG,	stone:3, employees:0, workPointsRequired:0 },
			pit: 	{ w:5, h:5, image:PIT_PNG,		stone:0, employees:4, workPointsRequired:300 },
			paddock:{ w:3, h:3, image:PADDOCK_PNG,	stone:5, employees:1, workPointsRequired:250 },
			butcher:{ w:2, h:2, image:BUTCHER_PNG,	stone:4, employees:1, workPointsRequired:200 }
		};
		
		public var buildingType:String;
		private var game:GameWorld;
		public var workersNeeded:uint;
		private var workProgress:int;
		private var workDone:Function;
		
		public var workers:Vector.<Goblin>;
		
		public function Building(x:uint, y:uint, name:String) 
		{
			buildingType = name;
			
			super(x * GameWorld.TILE_SIZE, y * GameWorld.TILE_SIZE);
			setHitbox(TYPES[name].w * GameWorld.TILE_SIZE, TYPES[name].h * GameWorld.TILE_SIZE);
			graphic = new Stamp(TYPES[name].image);
			
			workersNeeded = TYPES[name].employees;
			
			type = "building";
			
			if (name == "campfire") {
				this.name = "campfire";
			}
			
			trace("Creating building: ", name, x, y, width, height);
			
			workers = new Vector.<Goblin>;
		}
		
		override public function added():void 
		{
			super.added();
			game = world as GameWorld;
			
			switch (buildingType) {
				case "pit":
					workDone = function():void {
						game.stone++;
						game.emitter.emit("stone", x + halfWidth-8, y + halfHeight);
					}
					break;
				case "hovel":
					var g:Goblin = new Goblin(centerX, y + GameWorld.TILE_SIZE);
					g.setHome(this);
					world.add(g);
					break;
				case "paddock":
					workDone = function():void {
						// Add new goat!
						game.add(new Goat(this));
						game.emitter.emit("goat", x + halfWidth - 8, y + halfHeight);
					};
					break;
				case "butcher":
					workDone = function():void {
						workers.forEach(function(g:Goblin, i:int, vector:*):void {
							g.changeState("gotogoat");
							game.goats--;
							game.emitter.emit("food", x + halfWidth - 8, y + halfHeight);
							game.food += 5;
						});
					};
					break;
			}
		}
		
		public function performWork():void {
			workProgress += 1;
			if (workProgress >= TYPES[buildingType].workPointsRequired) {
				workProgress -= TYPES[buildingType].workPointsRequired;
				workDone();
			}
		}
		
	}

}