package 
{
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Matrix;
	import flash.filters.BlurFilter;
	
	import nape.dynamics.Arbiter;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.phys.Material;
	import nape.shape.Polygon;
	import nape.shape.Circle;

	public class Slime extends Sprite
	{
		static public const APP_WIDTH:int = 640;
		static public const APP_HEIGHT:int = 480;
		static public const FRAMERATE:Number = 41.0;
		static public const TIMESTEP:Number = 1 / FRAMERATE;
		
		private var	core:InitNape;

		private var frame:BitmapData;
		private var pdata:BitmapData;
		private var balls:Array = [];
		private var waterMatrix:Matrix = new Matrix();
		private var waterBlur:BlurFilter = new BlurFilter(15,15,3);

		public function Slime()
		{
			core = new InitNape(APP_WIDTH,APP_HEIGHT,FRAMERATE,20);
			addChild(core);

			createPlatform();

			frame = new BitmapData(640,480,true,0);
			addChild(new Bitmap(frame));

			//SWFProfiler.init(stage, this);
                        
			addEventListener(Event.ENTER_FRAME, update);
		}

		private function createShape(radius:int, color):Shape
		{
			var child = new Shape();
			child.graphics.beginFill(color);
			child.graphics.lineStyle(1, color);
			child.graphics.drawCircle(0, 0, radius);
			child.graphics.endFill();
			return child;
		}

		private function createPlatform():void
		{
			var platfrom:Body = new Body(BodyType.STATIC, new Vec2(APP_WIDTH/2, APP_HEIGHT-250));
			platfrom.shapes.add(new Polygon(Polygon.box(APP_WIDTH, 50)));
			platfrom.space = core.space();

		}
		private function createBall(x:Number, y:Number, radius:int, color):void
		{
			var waterBody:Body = new Body(BodyType.DYNAMIC,new Vec2(x,y));
			waterBody.shapes.add(new Circle(radius));
			waterBody.space = core.space();
			balls.push(new Array(waterBody, radius, color));
		}

		private function updateGraphic(body:Body):void
		{
			body.graphic.x = body.position.x;
			body.graphic.y = body.position.y;
			body.graphic.rotation = (body.rotation * 180/Math.PI) % 360;
		}
		private function update(e:Event):void
		{
			
			createBall(APP_WIDTH/2+1-Math.random()*2, 0, 5, 0x0000FF);

			frame.lock();
			frame.fillRect(frame.rect, 0);
			var i:int = balls.length;
			while(i--)
			{
				var ball:Body = balls[i][0];
				var radius:int = balls[i][1];
				var color = balls[i][2];
				if (balls.length > 200 || ball.position.x > APP_WIDTH || ball.position.x < 0 || ball.position.y < 0 || ball.position.y > APP_HEIGHT && balls.length > 0)
				{
					balls[i] = null;
					balls.splice(i, 1);
					ball.space = null;
				}
				else
				{
					waterMatrix.tx = ball.position.x;
					waterMatrix.ty = ball.position.y;
					frame.draw(createShape(radius, color), waterMatrix);
				}
			}
			frame.applyFilter(frame,frame.rect,new Point(0,0),waterBlur);
			frame.threshold(frame,frame.rect,new Point(0,0),">",0X11444444,0x88FF00FF,0xFFFFFFFF, true);
			frame.unlock();

		}

	}
}