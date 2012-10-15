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
	import flash.display.*;
	import flash.events.*;
	import flash.filters.GlowFilter;
	
	import caurina.transitions.*;
	import caurina.transitions.properties.*;
	
	public class OverlayBtn extends Sprite
	{
		//sprites
		public var background:Sprite;
		public var iconArea:Sprite;
		public var clickArea:Sprite;
		
		protected var __w:Number;
		protected var __h:Number;
		
		//filters
	    protected var __glowIn:GlowFilter;  
		protected var __glowOut:GlowFilter;
		
		public var overFxValue:Number = 15;
		
		public function OverlayBtn( w:Number, h:Number )
		{
			__w = w;
			__h = h;
			
			background = new Sprite();
			background.graphics.beginFill( 0xFFFFFF, 0.25 );
			background.graphics.drawCircle( 0, 0, 10 );
			background.graphics.endFill();
			
			background.width  = __w;
			background.height = __h;
			
			iconArea = new Sprite();
			
			clickArea = new Sprite();
			clickArea.graphics.beginFill( 0xFF0000, 0 );
			clickArea.graphics.drawRect( -5, -5, 10, 10 );
			clickArea.graphics.endFill();
			clickArea.width  = __w;
			clickArea.height = __h;
			
			addChild(background);
			addChild(iconArea);
			addChild(clickArea);
		}
		
		public function activate()
		{
			FilterShortcuts.init();
			ColorShortcuts.init();
			
			__glowIn  = new GlowFilter(0xFFFFFF,0.8,10,10,2,2);
			__glowOut = new GlowFilter(0xFFFFFF,0,10,10,2,2);
			
			clickArea.addEventListener( MouseEvent.MOUSE_OVER, onOver );
			clickArea.addEventListener( MouseEvent.MOUSE_OUT,  onOut );
		}
		
		protected function onOver( e:MouseEvent ):void
		{
			Tweener.addTween( background, {  _filter:__glowIn, width:__w + overFxValue, height:__h + overFxValue, time:0.5, transition:"easeOut" } );
		}
		protected function onOut( e:MouseEvent ):void
		{
			Tweener.addTween( background, {  _filter:__glowOut, width:__w, height:__h, time:0.5, transition:"easeOut" } );
		}
		
	}
}