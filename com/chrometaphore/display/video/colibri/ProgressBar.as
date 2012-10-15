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
	
	public class ProgressBar extends MovieClip 
	{
		
		//Sprites
		public var background:Sprite;
		public var bar:Sprite;
		
		//Vars
		private var __padding:int = 0;
		
		private var __w:Number;
		private var __h:Number;
		
		
		//PUBLIC
		//___________________________________________________________________________________
		
	
		/** 
		 * constructor.
		 *
		 * @param         w          width
		 * @param         h          height
		 * @return        void
		 */
		public function ProgressBar( w:Number,
								     h:Number ):void 
		{
			//Set vars
			//-------------------------
			__w = w;
			__h = h;
			
			//draw
			//-------------------------
			this.drawProgressBar();
			
		}
		
		
		/**
		 * set object progress
		 * @param         loaded           progress:loaded
		 * @param         total            progress:total
		 * @return        void
		 */
		public function progress( loaded:Number, 
								  total:Number
								  ):void 
		{
			var perc:Number  = Math.round( loaded / total * 100 );
			bar.width        = ( loaded / total * __w ) - ( __padding * 2 );
		}
		
		public function set w( myWidth:Number ):void
		{
			__w               = myWidth;
			background.width  = __w;
		}
		
		public function set h( myHeight:Number ):void
		{
			__h                = myHeight;
			background.height  = __h;
			bar.height         = ( __h - __padding * 2 );
		}
		
		public function reset():void
		{
			bar.width = 0;
		}
		
		
		//PRIVATE
		//___________________________________________________________________________________
		
		
		private function drawProgressBar():void 
		{  
			background = new Sprite();
			background.graphics.beginFill( 0xFFFFFF );
			background.graphics.drawRect(0,0,10,10);
			background.width  = __w;
			background.height = __h;
			background.alpha  = 0.25;
			addChild(background);
			
			bar = new Sprite();
			bar.graphics.beginFill( 0xFFFFFF );
			bar.graphics.drawRect(0,0,10,10);
			bar.width         = 0;
			bar.x             = __padding;
			bar.y             = __padding;
			bar.height        = ( __h - __padding * 2 );
			bar.alpha         = 0.35;
			addChild(bar);
		}
	}
}