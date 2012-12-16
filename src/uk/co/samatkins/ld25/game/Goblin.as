package uk.co.samatkins.ld25.game 
{
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.FP;
	
	/**
	 * ...
	 * @author Samuel Atkins
	 */
	public class Goblin extends Entity 
	{
		[Embed(source = "../../../../../../assets/goblin.png")] public static const GOBLIN_PNG:Class;
		
		public static const MOVE_SPEED:Number = 2;
		
		public var spritemap:Spritemap;
		
		public var state:String = "idle";
		/* STATES:
		 * idle - no job, no urgent needs
		 * gotowork - travel to workplace
		 * work - stay at a building, contributing work points to it
		 * gotoeat - travel to a place that has food
		 * eat - Consume food, replenish hunger
		 * gotosleep - travel to home
		 * sleep - Stay in home, replenish energy
		 * 
		 * BUTCHERING:
			 * gotogoat - Head to nearest goat
			 * carrygoat - pick up goat, take it to butcher's
			 * butchergoat - stay in butcher's for a while, and produce food
		 */
		
		public var workplace:Building = null;
		public var home:Building = null;
		public var campfire:Building = null;
		
		public var hunger:Number = 1500;
		public var energy:Number = 2000;
		
		public function Goblin(x:int, y:int) 
		{
			super(x, y);
			setHitbox(4, 4, 2, 2);
			
			graphic = spritemap = new Spritemap(GOBLIN_PNG, 8, 8);
			graphic.x = -4;
			graphic.y = -8;
			
			spritemap.add("hidden", [1]);
			spritemap.add("idle", [0]);
			spritemap.add("mine", [4, 5], 10);
			spritemap.add("walk", [8, 9], 10);
			spritemap.add("sleep", [12, 13, 14, 15, 1, 1, 1], 10);
			
			type = "unit";
		}
		
		override public function added():void 
		{
			super.added();
			
			(world as GameWorld).population++;
			
			campfire = (world as GameWorld).getInstance("campfire");
		}
		
		override public function update():void 
		{
			super.update();
			hunger--;
			energy--;
			
			switch (state) {
				case "idle": // Try to find work
					if (checkHungerAndEnergy()) { return; }
					
					var buildings:Array = [];
					world.getType("building", buildings);
					buildings = buildings.filter(function(b:Building, index:int, array:Array):Boolean {
						return b.workersNeeded > 0;
					});
					
					if (buildings.length > 0) {
						giveJob(buildings[Math.floor(Math.random() * buildings.length)]);
					} else {
						moveTowards(campfire.centerX, campfire.centerY, MOVE_SPEED);
					}
					break;
					
				case "gotowork":
					if (workplace == null) {
						changeState("idle");
					}
					
					if (checkHungerAndEnergy()) { return; }
					// TODO: Does workplace exist?
					
					// Go to work
					this.moveTowards(workplace.centerX, workplace.centerY, MOVE_SPEED);
					if (collideWith(workplace, x, y)) {
						changeState("work");
					}
					break;
					
				case "work":
					if (checkHungerAndEnergy()) { return; }
					
					energy -= 2; // Work makes you very tired
					hunger -= 2; // Also, more hungry.
					workplace.performWork();
					break;
					
				case "gotoeat":
					moveTowards(campfire.centerX, campfire.centerY, MOVE_SPEED);
					if (collideWith(campfire, x, y)) {
						changeState("eat");
					}
					break;
					
				case "eat":
					hunger += 8;
					if (hunger >= 1000) {
						changeState("gotowork");
						(world as GameWorld).food -= 1;
					}
					break;
					
				case "gotosleep":
					this.moveTowards(home.centerX, home.centerY, MOVE_SPEED);
					if (collideWith(home, x, y)) {
						changeState("sleep");
					}
					break;
					
				case "sleep":
					energy += 8;
					if (energy >= 1000) {
						y += 16;
						changeState("gotowork");
					}
					break;
					
				case "gotogoat":
					if (checkHungerAndEnergy()) { return; }
					
					var e:Entity = world.nearestToEntity("goat", this);
					if (e == null) {
						trace("No goats! No idea what to do here. :(");
						return;
					} else {
						moveTowards(e.x, e.y, MOVE_SPEED);
						if (collideWith(e, x, y)) {
							world.remove(e);
							changeState("carrygoat");
						}
					}
					break;
				
				case "carrygoat":
					if (workplace == null) {
						changeState("idle");
					}
					
					// Go to work
					this.moveTowards(workplace.centerX, workplace.centerY, MOVE_SPEED);
					if (collideWith(workplace, x, y)) {
						changeState("butchergoat");
					}
					break;
				
				case "butchergoat":
					workplace.performWork();
					break;
				
				default:
					trace("SECESSION ERROR: Unknown goblin state!");
					break;
			}
		}
		
		public function giveJob(workplace:Building):void {
			workplace.workersNeeded--;
			this.workplace = workplace;
			workplace.workers.push(this);
			changeState("gotowork");
			trace("GOBLIN: I have a job!");
		}
		
		public function setHome(home:Building):void {
			this.home = home;
		}
		
		public function changeState(newState:String):void {
			trace("State is now: ", newState);
			state = newState;
			var v:Point;
			switch (state) {
				case "idle":
					spritemap.play("idle");
					break;
					
				case "gotowork":
					
					v = new Point;
					FP.angleXY(v, FP.angle(x, y, workplace.centerX, workplace.centerY));
					spritemap.flipped = (v.x > 0);
					
					spritemap.play("walk");
					break;
					
				case "work":
					switch (workplace.buildingType) {
						case "pit":
							spritemap.play("mine");
							break;
						case "butcher":
							changeState("gotogoat");
							break;
						case "paddock":
							moveTo(workplace.centerX, workplace.centerY);
							spritemap.play("idle");
							break;
					}
					break;
					
				case "gotoeat":
					spritemap.play("walk");
					v = new Point;
					FP.angleXY(v, FP.angle(x, y, campfire.centerX, campfire.centerY));
					spritemap.flipped = (v.x > 0);
					break;
					
				case "eat":
					spritemap.play("idle");
					break;
					
				case "gotosleep":
					
					v = new Point;
					FP.angleXY(v, FP.angle(x, y, home.centerX, home.centerY));
					spritemap.flipped = (v.x > 0);
					
					spritemap.play("walk");
					break;
					
				case "sleep":
					moveTo(home.centerX, home.centerY);
					spritemap.play("sleep");
					spritemap.flipped = false;
					break;
				
				case "gotogoat":
					spritemap.play("walk");
					var e:Entity = world.nearestToEntity("goat", this);
					if (e == null) {
						trace("No goats! No idea what to do here. :(");
						return;
					}
					v = new Point;
					FP.angleXY(v, FP.angle(x, y, e.centerX, e.centerY));
					spritemap.flipped = (v.x > 0);
					break;
				
				case "carrygoat":
					v = new Point;
					FP.angleXY(v, FP.angle(x, y, workplace.centerX, workplace.centerY));
					spritemap.flipped = (v.x > 0);
					break;
				
				case "butchergoat":
					moveTo(workplace.centerX, workplace.centerY);
					spritemap.play("idle");
					break;
					
			}
		}
		
		/**
		 * Checks if Goblin should go eat/sleep. Returns true if doing so, false if not.
		 * @return
		 */
		private function checkHungerAndEnergy():Boolean {
			if (energy < 100) {
				changeState("gotosleep");
				return true;
			} else if (hunger < 100) {
				changeState("gotoeat");
				return true;
			}
			
			return false;
		}
		
	}

}