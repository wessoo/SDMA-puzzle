package  com.chrometaphore.display.preloaders
{
	import flash.display.*;
	import flash.events.*;
	import flash.filters.*;
	import caurina.transitions.Tweener;
	import flash.utils.Timer;
	import com.chrometaphore.display.DisplayItem;
	
	public class Twirl extends DisplayItem 
	{
		public var graphic:Sprite;
		public var total:Number = 120;
		public var track:Sprite;
		
		private var __radius:Number = 25;
		private var t:Timer;
		private var count:int = 0;
		private var targetAlpha:Number = 1;
		
		public function Twirl() 
		{
			graphic = new Sprite();
			addChild( graphic );
			track = new Sprite();
			track.graphics.lineStyle( 4, 0xFFFFFF, 0.25 );
			track.graphics.drawCircle( 0, 0, __radius );
			graphic.addChild(track);
			
			for ( var i:int = 0; i < total; i++ )
			{
				createCircle( i );
			}
		}
		
		public function loop():void
		{
			t = new Timer( 1 );
			t.addEventListener( TimerEvent.TIMER, onTimer );
			t.start();
		}
		
		private function onTimer( e:TimerEvent ):void
		{
			
			if ( t.currentCount >= total)
			{
				if ( targetAlpha == 1 )
				{
					targetAlpha  = 0;
				}
				else
				{
					targetAlpha  = 1;
				}
				t.stop();
				t.reset();
				t.start();
			}
			
			Tweener.addTween( graphic.getChildByName( "s_" + (t.currentCount - 1) ), { alpha:targetAlpha, time: 1.75, transition:"easeOut" } );
		}
	
		
		private function createCircle( ID:int ):void
		{
			var singleSliceDegr:Number = 360 / total;
			var itemDegr:Number = ID * singleSliceDegr;
			var s:Sprite = new Sprite();
			s.name = "s_" + ID;
			s.graphics.beginFill(0xFFFFFF,1);
			s.graphics.drawCircle( 0, 0, 2 );
			s.cacheAsBitmap = true;
			s.x = __radius * ( Math.cos( ( itemDegr ) * Math.PI / 180 ) );
			s.y = __radius * ( Math.sin( ( itemDegr ) * Math.PI / 180 ) );
			s.alpha = 0;
			var glow:GlowFilter = new GlowFilter( 0xFFFFFF, 0.25, 10, 10, 4, 1 );
			var blur:BlurFilter = new BlurFilter( 3, 3, 1 );
			s.filters = [glow, blur];
			graphic.addChild(s);
		}
	}
}
