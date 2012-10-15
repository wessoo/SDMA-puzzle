/** 
 * colibri
 * <br>2010, Lorenzo Buosi
 * <br>chrometaphore.com
 * <br>http://www.chrometaphore.com
 * <br>info@chrometaphore.com
 *
 * <br>Released under Creative Commons Attribution-Noncommercial 2.5
 * <br>http://creativecommons.org/licenses/by-nc/2.5/it/deed.en_US
 *
 * <br>Please read carefully
 * <br>---------------------------------------------------------------
 * <br>THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * <br>EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * <br>OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * <br>NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * <br>HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * <br>WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * <br>FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * <br>OTHER DEALINGS IN THE SOFTWARE.
 */
package com.chrometaphore.display.video.colibri
{
	import flash.text.*;
	import flash.display.*;
	import flash.events.*;
	import com.chrometaphore.display.video.colibri.ProgressBar;
	import com.chrometaphore.display.video.colibri.events.SeekBarEvent;
	import caurina.transitions.Tweener;
	
	public class Bar extends Sprite
	{
		
		//Sprites
		public var seekbar:ProgressBar;
		public var bufferbar:ProgressBar;
		public var seekArrow:Sprite;
		public var background:Sprite;
		
		private var __w:Number;
		private var __h:Number;
		
		private var __status:String = "closed";
		
		
		//PUBLIC
		//___________________________________________________________________________________
		
	
		/** 
		 * constructor.
		 *
		 * @param         w          width
		 * @param         h          height
		 * @return        void
		 */
		public function Bar( w:Number,
						     h:Number ):void 
		{
			//Set vars
			//-------------------------
			__w = w;
			__h = h;
			
			//draw
			//-------------------------
			this.drawBar();
			
			//listeners
			//-------------------------
			seekbar.addEventListener( MouseEvent.CLICK, onSeekBarClick );
			
		}
		
		public function open():void
		{
			if ( __status == "closed" )
			{
				 __status = "open";
				Tweener.addTween( seekbar, { alpha:1, time:2.5, transition:"easeOut" } ); 
			}
		}
		
		public function close():void
		{
			if ( __status == "open" )
			{
				__status = "closed";
				Tweener.addTween( seekbar, { alpha:0, time:2.5, transition:"easeOut" } );
			}
		}
		
		public function updateStatus( streamTime, streamDuration, bufferTime, bufferLength ):void
		{
			if ( streamDuration != -1 )
			{
				seekbar.progress( streamTime, streamDuration );
			}
		}
		
		public function set w( myWidth:Number ):void
		{
			__w               = myWidth;
			seekbar.w         = __w;
		}
		
		public function set h( myHeight:Number ):void
		{
			__h                = myHeight;
			seekbar.h          = __h;
			//background.height  = __h;
			//bar.height         = ( __h - __padding * 2 );
		}
		
		public function reset():void
		{
			seekbar.reset();
		}
		
		public function over( hVal:Number ):void
		{
			Tweener.addTween( seekbar, { y:-(hVal - __h), time:1, transition:"easeOut" } );
			Tweener.addTween( seekbar.background, { height:hVal, time:1, transition:"easeOut" } );
			Tweener.addTween( seekbar.bar, { height:hVal, time:1, transition:"easeOut" } );
		}
		
		public function out():void
		{
			Tweener.addTween( seekbar, { y:0, time:1, transition:"easeOut" } );
			Tweener.addTween( seekbar.background, { height:__h, time:1, transition:"easeOut" } );
			Tweener.addTween( seekbar.bar, { height:__h, time:1, transition:"easeOut" } );
		}
		
		
		//PRIVATE
		//___________________________________________________________________________________
		
		
		private function drawBar():void 
		{ 
			
			seekbar = new ProgressBar( __w, __h );
			
			//hidden at startup!
			seekbar.alpha = 0;
			
			addChild(seekbar);
		}
		
		private function onSeekBarClick( e:MouseEvent ):void 
		{
			var ratio:Number = Math.round( this.mouseX / seekbar.width * 100 );
			dispatchEvent( new SeekBarEvent( SeekBarEvent.SEEK, { ratioPoint:ratio } ) );
		}
	}
}