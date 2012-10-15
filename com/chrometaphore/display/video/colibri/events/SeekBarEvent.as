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
package com.chrometaphore.display.video.colibri.events 
{
	
	import flash.events.Event;

	public class SeekBarEvent extends Event 
	{
		//events
		public static const SEEK:String = "seek";
		
		//event data
		public var data:Object = {};
		
		//PUBLIC
		//______________________________________________________________________________________________________
	
		public function SeekBarEvent( type:String,
									  mydata:Object = null,
									  bubbles:Boolean = false,
									  cancelable:Boolean = false
									  ) 
		{
			if ( ! mydata ) {
				data = new Object();
			}
			else {
				data = mydata;
			}
			
			super(type, bubbles, cancelable);
		}
		
		public override function clone():Event {
			return new SeekBarEvent(type, bubbles, cancelable);
		}
		
		public override function toString():String {
			return formatToString("SeekBarEvent", "type", "mydata", "bubbles", "cancelable", "eventPhase");
		}
		
		//PRIVATE
		//______________________________________________________________________________________________________
		
	}
}