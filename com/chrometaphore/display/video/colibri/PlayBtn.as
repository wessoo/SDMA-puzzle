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
	
	public class PlayBtn extends OverlayBtn
	{
		//sprites
		public var arrowIcon:Sprite;
		
		public function PlayBtn( w:Number, h:Number )
		{
			super( w, h );
			
			arrowIcon = new Sprite();
			arrowIcon.graphics.beginFill( 0xFFFFFF, 0.5 );
			arrowIcon.graphics.moveTo(0,0);
			arrowIcon.graphics.lineTo(7,4);
			arrowIcon.graphics.lineTo(0,8);
			arrowIcon.graphics.lineTo(0,0);
			arrowIcon.graphics.endFill();
			arrowIcon.filters.push(__glowIn);
			
			arrowIcon.width  = __w * 0.3;
			arrowIcon.scaleY = arrowIcon.scaleX;
			
			iconArea.addChild(arrowIcon);
			iconArea.x = 0 - iconArea.width / 2;
			iconArea.y = 0 - iconArea.height / 2;
		}
		
	}
}