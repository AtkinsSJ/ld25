package uk.co.samatkins.ld25.game 
{
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.Mask;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	/**
	 * ...
	 * @author Samuel Atkins
	 */
	public class UI extends Entity 
	{
		private static const MOUSE_EDGE_BUFFER:uint = 10;
		private static const SCROLL_SPEED:Number = 2;
		
		public var cursor:Cursor;
		public var thingToBuild:String;
		public var game:GameWorld;
		
		private var stoneLabel:Text;
		private var popLabel:Text;
		private var goatLabel:Text;
		private var foodLabel:Text;
		
		public function UI() 
		{
			super(0, 0);
		}
		
		override public function added():void 
		{
			super.added();
			setHitbox(100, FP.height);
			
			game = world as GameWorld;
			
			addGraphic(Image.createRect(width, height, 0x0));
			graphic.scrollX = 0;
			graphic.scrollY = 0;
			
			addGraphic(new Text("Goblin Fortress", 0, 0, {
				width: width,
				align: "center",
				size: 8
			}));
			
			stoneLabel = new Text("Stone: 0", 8, 16, {
				width: width,
				size: 8
			});
			addGraphic(stoneLabel);
			
			foodLabel = new Text("Food: 0", 8, 24, {
				width: width,
				size: 8
			});
			addGraphic(foodLabel);
			
			popLabel = new Text("Goblins: 0", 8, 32, {
				width: width,
				size: 8
			});
			addGraphic(popLabel);
			
			goatLabel = new Text("Goats: 0", 8, 40, {
				width: width,
				size: 8
			});
			addGraphic(goatLabel);
			
			addGraphic(new Text(
				"Buildings:\n" +
				"h - Hovel\n    (3 stone)\n" +
				"p - Pit\n    (0 stone)\n" +
				"g - Goat Paddock\n    (5 stone)\n" +
				"b - Butcher's Shop\n    (4 stone)\n",
				8, 64, {
				width: width,
				size: 8
			}));
			
			cursor = new Cursor;
			FP.world.add(cursor);
		}
		
		override public function update():void 
		{
			super.update();
			
			// Key presses?
			if (Input.pressed(Key.H)) { // H for Hovel
				thingToBuild = "hovel";
				cursor.setSize(Building.TYPES.hovel.w, Building.TYPES.hovel.h);
			}
			else if (Input.pressed(Key.P)) { // P for Pit
				thingToBuild = "pit";
				cursor.setSize(Building.TYPES.pit.w, Building.TYPES.pit.h);
			}
			else if (Input.pressed(Key.G)) { // G for Goat Paddock
				thingToBuild = "paddock";
				cursor.setSize(Building.TYPES.paddock.w, Building.TYPES.paddock.h);
			}
			else if (Input.pressed(Key.B)) { // B for Butcher
				thingToBuild = "butcher";
				cursor.setSize(Building.TYPES.butcher.w, Building.TYPES.butcher.h);
			} else if (Input.pressed(Key.ESCAPE)) { // Escape clears current action
				thingToBuild = null;
				cursor.setSize(0, 0);
			} else if (Input.pressed(Key.INSERT)) {
				game.stone = 100;
			}
			
			// Clicking?
			if (Input.mousePressed) {
				if (thingToBuild != null) {
				
					build(thingToBuild,
						Math.floor((Input.mouseX + world.camera.x) / GameWorld.TILE_SIZE),
						Math.floor((Input.mouseY + world.camera.y) / GameWorld.TILE_SIZE));
				}
			}
			
			// Mouse at edge of screen?
			if (Input.mouseX < width + MOUSE_EDGE_BUFFER) {
				world.camera.offset( -SCROLL_SPEED, 0);
			} else if (Input.mouseX > (FP.width - MOUSE_EDGE_BUFFER)) {
				world.camera.offset( SCROLL_SPEED, 0);
			}
			
			if (Input.mouseY < MOUSE_EDGE_BUFFER) {
				world.camera.offset(0,  -SCROLL_SPEED);
			} else if (Input.mouseY > (FP.height - MOUSE_EDGE_BUFFER)) {
				world.camera.offset( 0, SCROLL_SPEED );
			}
			
			FP.clampInRect(world.camera, -width, 0, game.WORLD_WIDTH - (FP.width - width), game.WORLD_HEIGHT - FP.height);
			
			// Update resource labels
			stoneLabel.text = "Stone: " + game.stone;
			foodLabel.text = "Food: " + game.food;
			popLabel.text = "Goblins: " + game.population;
			goatLabel.text = "Goats: " + game.goats;
		}
		
		/**
		 * Build a thing! Returns whether successful
		 * @param	type
		 * @param	x
		 * @param	y
		 * @return
		 */
		public function build(type:String, x:uint, y:uint):Boolean {
			if (cursor.collideTypes(["building"], cursor.x, cursor.y)) {
				return false;
			}
			
			// Do we have the resources?
			if (Building.TYPES[type].stone > game.stone) {
				return false;
				// TODO: Message "Not enough stone"
			}
					
			game.playSound("build");
			
			game.stone -= Building.TYPES[type].stone;
			FP.world.add(new Building(x, y, type));
			
			return true;
		}
	}

}