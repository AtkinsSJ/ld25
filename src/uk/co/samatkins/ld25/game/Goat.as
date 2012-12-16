package uk.co.samatkins.ld25.game 
{
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.Mask;
	import net.flashpunk.tweens.misc.Alarm;
	import net.flashpunk.FP;
	
	/**
	 * ...
	 * @author Samuel Atkins
	 */
	public class Goat extends Entity 
	{
		[Embed(source = "../../../../../../assets/goat.png")] public static const GOAT_PNG:Class;
		
		public static const MOVE_SPEED:Number = 0.1;
		public var moveVector:Point;
		
		public var home:Building;
		public var spritemap:Spritemap;
		public var game:GameWorld;
		
		public var state:String = "eat";
		public var alarm:Alarm;
		
		public function Goat(home:Building) 
		{
			this.home = home;
			x = this.home.centerX;
			y = this.home.centerY;
			setHitbox(4, 4, 2, 2);
			graphic = spritemap = new Spritemap(GOAT_PNG, 8, 8);
			graphic.x = -4;
			graphic.y = -8;
			
			spritemap.add("walk", [0, 1], 10);
			spritemap.add("eat", [2, 3], 10);
			spritemap.add("sleep", [4, 5], 10);
			
			alarm = new Alarm(2, doSomething);
			addTween(alarm);
			alarm.start();
			
			moveVector = new Point();
			
			spritemap.play("eat");
			
			type = "goat";
		}
		
		override public function added():void 
		{
			super.added();
			
			game = (world as GameWorld);
			game.goats++;
		}
		
		override public function update():void 
		{
			super.update();
			
			if (state == "walk") {
				// walk somewhere
				moveBy(moveVector.x, moveVector.y);
				clampHorizontal(home.left, home.right, 8);
				clampVertical(home.top, home.bottom, 8);
			}
		}
		
		private function doSomething():void {
			if (Math.random() < 0.3) {
				state = "walk";
				var moveDirection:Number = Math.random() * 360;
				FP.angleXY(moveVector, moveDirection, MOVE_SPEED);
				spritemap.flipped = (moveVector.x > 0);
				spritemap.play("walk");
			} else if (Math.random() < 0.5) {
				state = "eat";
				spritemap.play("eat");
			} else {
				state = "sleep";
				spritemap.play("sleep");
			}
			
			var r:Number = Math.random();
			if (r < 0.1) {
				game.playSound("goat1");
			} else if (r < 0.2) {
				game.playSound("goat2");
			} else if (r < 0.3) {
				game.playSound("goat3");
			}
			
			alarm.start();
		}
		
	}

}