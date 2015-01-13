/**
 *
 */
package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import nape.geom.Vec2;
	import nape.space.Broadphase;

	import nape.space.Space;
	import nape.util.ShapeDebug;

	/**
	 */
	public class InitNape extends Sprite
	{
		//
		private var _space:Space;
		private var _timeStep:Number = 1/30.0;
		private var _velocityIterations:int = 10;
		private var _positionIterations:int = 10;

		private var _appWidth:int = 800;
		private var _appHeight:int = 600;

		private var _debug:ShapeDebug;

		/**
		 */
		public function InitNape(appWidth:int = 800, appHeight:int = 600, timeStep:Number = 30, iterations:int = 10)
		{
			_appWidth = appWidth;
			_appHeight = appHeight;
			_timeStep = 1/timeStep;
			_velocityIterations = _positionIterations = iterations;

			init();
			
		}

		/**
		 */
		private function init(event:Event = null):void
		{
			_space = new Space(new Vec2(0, 400), Broadphase.SWEEP_AND_PRUNE);
			//initDebugDraw();

			addEventListener(Event.ENTER_FRAME, enterFrameHandler)
		}

		/**
		 */
		private function initDebugDraw():void
		{
			_debug = new ShapeDebug(_appWidth, _appHeight, 0xdddddd);
			_debug.thickness = 2;
			_debug.drawCollisionArbiters = true;
			addChild(_debug.display);
		}

		/**
		 */
		private function enterFrameHandler(event:Event):void
		{
			_space.step(_timeStep, _velocityIterations, _positionIterations);

			//_debug.clear();
			//_debug.draw(_space);
			//_debug.flush();
		}

		/**
		 */
		public function space():Space
		{
			return _space;
		}

		public function clear():void
		{
			_space.clear();
		}
	}
}
