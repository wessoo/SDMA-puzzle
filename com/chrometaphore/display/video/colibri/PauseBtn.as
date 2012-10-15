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
	
	public class PauseBtn extends OverlayBtn
	{
		//sprites
		public var pauseIcon:Sprite;
		
		public function PauseBtn( w:Number, h:Number )
		{
			super( w, h );
			
			pauseIcon = new Sprite();
			pauseIcon.graphics.beginFill( 0xFFFFFF, 0.5 );
			pauseIcon.graphics.drawRect(0,0,2,8);
			pauseIcon.graphics.drawRect(4,0,2,8);
			pauseIcon.graphics.endFill();
			pauseIcon.filters.push(__glowIn);
			
			pauseIcon.width  = __w * 0.3;
			pauseIcon.scaleY = pauseIcon.scaleX;
			
			iconArea.addChild(pauseIcon);
			iconArea.x = 0 - iconArea.width / 2;
			iconArea.y = 0 - iconArea.height / 2;
		}
		
	}
}