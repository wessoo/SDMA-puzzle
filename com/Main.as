package com {
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.display.Graphics;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.events.MouseEvent;
	import flash.media.SoundTransform;

	import org.papervision3d.scenes.*;
	import org.papervision3d.cameras.*;
	import org.papervision3d.objects.*;
	import org.papervision3d.materials.*;

	import com.chrometaphore.display.video.colibri.Colibri;
	import com.chrometaphore.display.video.colibri.ColibriEvent;

	import caurina.transitions.*;

	public class Main extends Application {
		
		public function Main() {
			stage.scaleMode=StageScaleMode.EXACT_FIT;
			stage.displayState=StageDisplayState.FULL_SCREEN;
			stage.align = StageAlign.TOP_LEFT;
			
		}
	}
}