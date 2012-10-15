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
	import flash.net.*;
	import flash.events.*;
	import flash.media.*;
	import com.chrometaphore.display.video.colibri.events.MyVideoEvent;
	import caurina.transitions.*;
	import caurina.transitions.properties.*;
	
	public class MyVideo extends Video
	{
		private var __originalVideoWidth:Number;
		private var __originalVideoHeight:Number;
		
		private var __connection:NetConnection;
		private var __stream:NetStream;
		private var __streamURL:String;
		
		private var __duration:Number = -1;
		
		private var __w:Number;
		private var __h:Number;
		
		//private var __looping:Boolean = false;
		
		//CONSTRUCTORS
		//___________________________________________________________________________________
		
		public function MyVideo( w:Number, h:Number, streamURL:String ):void
		{
			super( w, h );
			
			//stream URL
			__streamURL = streamURL;
			
			// first let's create the NetConnection
			__connection = new NetConnection();
			
			// let set it to HTTP "streaming" mode, the null is to specify we are NOT connecting to a media server
			__connection.connect(null);
			
			// now let's create the NetStream
			__stream = new NetStream(__connection);
			
			// the set it's client to receive certain events
			__stream.client = this;
			
			//set smooth mode on
			super.smoothing = true;
			
			// attach the NetStream to the video object
			super.attachNetStream(__stream);
			
			// let's set the default buffer time to 1 second
			__stream.bufferTime = 1;
			
			// tell the stream to receive the audio
			__stream.receiveAudio(true);
			
			// tell the stream to receive the video
			__stream.receiveVideo(true);
		}
	
		
		//PUBLIC
		//___________________________________________________________________________________
		
		public function play():void 
		{
			__stream.play(__streamURL);
		}
		
		public function resume():void 
		{
			__stream.resume();
		}
		
		public function pause():void 
		{
			__stream.pause();
		}
		
		/*
		 * Object GC
		 * @return    void
		 */
		public function destroy():void
		{
			//unlock and close the stream object
			__stream.close();
			
			//delete connection object
			__connection = null;
		}
		
		public function resize( w:Number, h:Number ):void 
		{
			this.width  = w;
			this.height = h;
		}
		
		public function onXMPData(infoObject:Object):void {}
		
		public function onMetaData( meta:Object ):void
		{
			__duration            = meta.duration;
			__originalVideoWidth  = meta.width;
			__originalVideoHeight = meta.height;
			dispatchEvent( new MyVideoEvent( MyVideoEvent.ON_META_DATA ) );
		}
		
		public function onPlayStatus(infoObject:Object):void
		{
			//trace( "*" + infoObject.code );
		}
		
		//PRIVATE
		//___________________________________________________________________________________
		
		//PROTECTED
		//___________________________________________________________________________________
		
		//GETTERS
		//___________________________________________________________________________________
		
		public function get stream():NetStream
		{
			return __stream;
		}
		
		public function get duration():Number
		{
			return __duration;
		}
		
		public function get originalVideoWidth():Number
		{
			return __originalVideoWidth;
		}
		
		public function get originalVideoHeight():Number
		{
			return __originalVideoHeight;
		}
		
		//SETTERS
		//___________________________________________________________________________________
		
		//EVENT HANDLERS
		//___________________________________________________________________________________
		
	}
}