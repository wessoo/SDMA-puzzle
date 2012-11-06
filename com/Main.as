package com {
	import flash.events.*;
	import flash.display.*;
	import flash.net.*;
	import flash.filters.*;
	import flash.media.Sound;
	import flash.utils.Timer;
	import flash.utils.Dictionary;
	import flash.text.TextField;
	import flash.media.SoundTransform;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import flash.geom.Point;
	import flash.geom.Matrix;

	import org.papervision3d.scenes.*;
	import org.papervision3d.cameras.*;
	import org.papervision3d.objects.*;
	import org.papervision3d.materials.*;

	import org.papervision3d2.cameras.Camera3D;
	import org.papervision3d2.render.BasicRenderEngine;
	import org.papervision3d2.scenes.Scene3D;
	import org.papervision3d2.view.Viewport3D;
	import org.papervision3d2.objects.primitives.Plane;
	import org.papervision3d2.materials.*;
	import org.papervision3d2.events.InteractiveScene3DEvent;
	import org.papervision3d2.objects.DisplayObject3D;

	import com.chrometaphore.display.video.colibri.Colibri;
	import com.chrometaphore.display.video.colibri.ColibriEvent;

	import caurina.transitions.*;

	public class Main extends MovieClip {
			private var puzzlePicker:Number;
		    private var frameStr:String;
			
		    //img_list.xml setting strings
			private var mouseOrTouch:String;
		    private var loadingScreen:String;
			private var videoRatio:Number;	    
		    private var container:Sprite;
		    private var scene:org.papervision3d.scenes.MovieScene3D;
		    private var cam:org.papervision3d.cameras.Camera3D;
			private var timer:Timer;
			private var idleTimer:Timer;
			private var countDown:Timer;
		    private var p_dict:Dictionary;		    
		    private var pa:Array;
		    private var filename_list:Array;
			private var title_list:Array;
		    private var description_list:Array;
		    private var selectedPic:int;
		    private var i:int; 
		    private var numTiles:int;
		    private var metadata_xml:XML;
		    private var pic_loader:Loader;
		    private var xml_loader:URLLoader;

		    private var numImg: int = 25;
		    private var awayStageR: int = stage.stageWidth*2;
			private var awayStageL: int = -stage.stageWidth*2;
		    private var container_x:int = 400;
		    private var container_y:int = stage.stageHeight * 0.5 + 400;
			private var folder:String = "photos/"; //change to FOLDER_PATH

			private var logos:Boolean = false; //turn on & off welcome screen
			private var began:Boolean = false; //prevent tiles to get generated more than once
			private var finishedPuzzle:Boolean = false;
			private var cardFacingFront:Boolean = true;
			private var imgLoader:Loader;
			private var bitmap:Bitmap;
			private var imgCard:org.papervision3d2.objects.DisplayObject3D;
			private var vidPlaying:Boolean = false;
			private var card:Card = new Card();
			private var back_material:org.papervision3d2.materials.MovieMaterial;
			private var back_plane:org.papervision3d2.objects.primitives.Plane;
			private var front_material:org.papervision3d2.materials.BitmapMaterial;
			private var front_plane:org.papervision3d2.objects.primitives.Plane;

			private var myCard:Card = new Card();
			private var viewport:org.papervision3d2.view.Viewport3D = new org.papervision3d2.view.Viewport3D(1920,1080,false,true);
			private var sceneCard:org.papervision3d2.scenes.Scene3D = new org.papervision3d2.scenes.Scene3D();
			private var camera:org.papervision3d2.cameras.Camera3D = new org.papervision3d2.cameras.Camera3D();
			private var renderer:org.papervision3d2.render.BasicRenderEngine = new org.papervision3d2.render.BasicRenderEngine();

			public function Main() {
				gotoAndStop(2);
				//stage.scaleMode = StageScaleMode.EXACT_FIT;
				stage.displayState = StageDisplayState.FULL_SCREEN;
				stage.scaleMode = StageScaleMode.SHOW_ALL;
				stage.align = StageAlign.TOP_LEFT;
				Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;

				imgCard = new org.papervision3d2.objects.DisplayObject3D();

				if( logos )
				{
					stop();
					timer = new Timer(18000, 1);
					timer.addEventListener(TimerEvent.TIMER_COMPLETE, timerHandler);
					timer.start();
				}

				bg_woodtexture.visible = false;

				//Set up thumbnail environment
				container = new Sprite();
				container.x = container_x;
		    	container.y = container_y;
		    	addChild(container);
				scene = new org.papervision3d.scenes.MovieScene3D(container);
				cam = new org.papervision3d.cameras.Camera3D();
		    	cam.zoom = 10;
			    addEventListener(Event.ENTER_FRAME, render);

				//Image loader
				imgLoader = new Loader();
				imgLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, imageLoaded );
				//imgLoader.load(new URLRequest("images/1925-1.jpg"));

				//Set up card environment
				back_material = new org.papervision3d2.materials.MovieMaterial(myCard);
				back_plane = new org.papervision3d2.objects.primitives.Plane(back_material,1600,800,10,20);
				back_plane.rotationY = 180;
				//addChildAt(viewport, getChildIndex(container) + 1); //DON'T SHOW CARD
				camera.focus = 100;
				camera.zoom = 10;
				addEventListener(Event.ENTER_FRAME, renderCard);
				
				//videos
				mv_nevelson.addEventListener(MouseEvent.MOUSE_UP, calder_up)

				p_dict = new Dictionary();
				pa = new Array();
				filename_list = new Array();
				title_list = new Array();
				description_list = new Array();

			    metadata_xml = new XML();
			    pic_loader = new Loader();
			    xml_loader = new URLLoader();
			    xml_loader.load( new URLRequest("25works_metadata.xml") );
		    	xml_loader.addEventListener(Event.COMPLETE, create_thumbnail);

		    	mv_nevelson.video.fullScreenTakeOver = mv_bougeureau.video.fullScreenTakeOver = false;
		    	removeChild(backBtn);
		}
		
		function render(e:Event):void
		{
			for(var i:uint; i < pa.length; i++)
			{
				if( check_distance(pa[i].pl) )
					Tweener.addTween(pa[i].pl, {rotationY:0, rotationZ:0, z:0, time:0.5});
				else
					Tweener.addTween(pa[i].pl, {rotationY:pa[i].rotY, rotationZ:pa[i].rotZ, z:pa[i].z, time:2});
			}
			//cam.x = ( 800 - stage.mouseX ) * 0.1;
			//cam.y = ( 480 - stage.mouseY ) * 0.1;

			scene.renderCamera(cam);
		}

		public function renderCard(e:Event) {			
			renderer.renderScene(sceneCard, camera, viewport);
		}

		public function imageLoaded(e:Event):void {
			//card back. Load XML.
			myCard.txt_title.text = metadata_xml.Content.Work[selectedPic].title;
			
			myCard.txt_metadata.text = "";
			if(metadata_xml.Content.Work[selectedPic].artist != "") {
				myCard.txt_metadata.text += metadata_xml.Content.Work[selectedPic].artist;
			}
			if(metadata_xml.Content.Work[selectedPic].artist != "" && metadata_xml.Content.Work[selectedPic].life != "") {
				myCard.txt_metadata.text += ", " + metadata_xml.Content.Work[selectedPic].life;
			} else {
				myCard.txt_metadata.text += metadata_xml.Content.Work[selectedPic].life;
			}
			if(metadata_xml.Content.Work[selectedPic].date != "") {
				myCard.txt_metadata.text += "\n" + metadata_xml.Content.Work[selectedPic].date;
			}

			myCard.txt_metadata.text += "\n" + metadata_xml.Content.Work[selectedPic].size + 
				"\n" + metadata_xml.Content.Work[selectedPic].credit;

			/*myCard.txt_metadata.text = metadata_xml.Content.Work[selectedPic].artist + ", " + 
				metadata_xml.Content.Work[selectedPic].life + "\n" + 
				metadata_xml.Content.Work[selectedPic].date + "\n" +
				metadata_xml.Content.Work[selectedPic].size + "\n" +
				metadata_xml.Content.Work[selectedPic].credit;*/
			myCard.txt_desc.text = metadata_xml.Content.Work[selectedPic].description;
			back_material = new org.papervision3d2.materials.MovieMaterial(myCard);
			back_plane = new org.papervision3d2.objects.primitives.Plane(back_material,1600,800,10,20);
			back_plane.rotationY = 180;
			back_material.interactive = true;
			back_plane.addEventListener(InteractiveScene3DEvent.OBJECT_PRESS, flipCard);

			//card front
			var bmp:Bitmap = imgLoader.content as Bitmap;
			var front_material:org.papervision3d2.materials.BitmapMaterial = new org.papervision3d2.materials.BitmapMaterial(bmp.bitmapData);
			front_plane = new org.papervision3d2.objects.primitives.Plane(front_material,fullImg.width,fullImg.height,4,5);
			front_material.interactive = true;
			front_plane.addEventListener(InteractiveScene3DEvent.OBJECT_PRESS, flipCard);

			imgCard.addChild(front_plane);
			imgCard.addChild(back_plane);
			sceneCard.addChild(imgCard);
		}

		public function loadCard():void {

		}

		public function flipCard(e:InteractiveScene3DEvent) {
			//rotate from front
			trace("flip");
			if(cardFacingFront) {
				trace("facing back");
				cardFacingFront = false;
				imgCard.rotationY = 0;
				Tweener.addTween(imgCard, {rotationY: 180, time: 1, onComplete: function() {
					addChildAt(mv_nevelson, getChildIndex(viewport) + 1);
					mv_nevelson.y = 263;
				}});
			} else {
				trace("facing front");
				cardFacingFront = true;
				imgCard.rotationY = 180;
				Tweener.addTween(imgCard, {rotationY: 360, time: 1});
				removeChild(mv_nevelson);
			}
			//Tweener.addTween(back_plane, {rotationZ: 180, time: 1});
		}

		public function calder_up(e:MouseEvent):void {
			//trace("clicked!");
			if(!vidPlaying) {
				vidPlaying = true;
				mv_nevelson.video.play();
				Tweener.addTween(mv_nevelson.graphic_play, {alpha: 0, time: 1});
				Tweener.addTween(mv_nevelson.graphic_videoblack, {alpha: 0, time: 1});
			} else {
				vidPlaying = false;
				mv_nevelson.video.pause();
				Tweener.addTween(mv_nevelson.graphic_play, {alpha: 1, time: 1});
				Tweener.addTween(mv_nevelson.graphic_videoblack, {alpha: 0.5, time: 1});
			}
		}

		function create_thumbnail(e:Event):void
		{
			var thumbSize: int = 200;
			var thumbGap: int = 20;

			metadata_xml = XML(e.target.data);

		    //read settings from xml
		    mouseOrTouch = metadata_xml.input;
		    //loadingScreen = metadata_xml.loadingscreen[0].@enable.toString();
			//videoRatio = metadata_xml.videoRatio[0].@ratio.toString();
			
			numTiles = metadata_xml.Content.Work.length();
			for( i = 0; i < numTiles; i++ )
			{
		        var index;

		        if( i+1 > numImg )
		            index = i - numImg;
		        else
		            index = i;
		   
				//filename_list.push( metadata_xml.Content.Work[index].url );
				title_list.push( metadata_xml.Content.Work[index].title );
				description_list.push( metadata_xml.Content.Work[index].description );

				var bfm:BitmapFileMaterial = new BitmapFileMaterial(metadata_xml.Content.Work[index].thumburl);
				
				bfm.oneSide = false;
				bfm.smooth = true;
				var p:org.papervision3d.objects.Plane = new org.papervision3d.objects.Plane(bfm, thumbSize, thumbSize, 2, 2);
				scene.addChild(p);
				var p_container:Sprite = p.container;
				p_container.name = "flashmo_" + i;
				p_dict[p_container] = p;
				p_container.buttonMode = true;
				p_container.alpha = 0.5
				p_container.addEventListener( MouseEvent.ROLL_OVER, p_rollover );
				p_container.addEventListener( MouseEvent.ROLL_OUT, p_rollout );
				p_container.addEventListener( MouseEvent.CLICK, p_click );
				
				pa.push({pl:p, rotY:Math.random() * 360, rotZ:Math.random() * 360, z:Math.random() * 4000 + 1500});
				p.rotationY = pa[i].rotY;
				p.rotationZ = pa[i].rotZ;
				p.x = i % 5 * ( thumbSize + thumbGap + 60 );
				p.y = Math.floor(i / 5) * ( thumbSize + thumbGap );
				p.z = pa[i].z;
			}//for
		}//create thumbnail

		function p_rollover(me:MouseEvent) 
		{
			var sp:Sprite = me.target as Sprite;
			Tweener.addTween( sp, {alpha: 1, time: 0.6} );
		}

		function p_rollout(me:MouseEvent) 
		{
			var sp:Sprite = me.target as Sprite;
			Tweener.addTween( sp, {alpha: 0.5, time: 0.6} );
		}

		function p_click(me:MouseEvent) 
		{
			//trace("p_click() called");
			var sp:Sprite = me.target as Sprite;
			Tweener.addTween(container, {scaleX: 3, scaleY: 3, alpha: 0, time: 1, delay: 0.2, onComplete: function() {
				container.scaleX = container.scaleY = container.alpha = 1;
				removeChild(container);
			}});

			var s_no:Number = parseInt(sp.name.slice(8,10)); //this is the ID of the work (based on order of 1-25 on website)

			//tn_title.text = title_list[s_no];
			//tn_desc.text = description_list[s_no];

			//move away tiles container
			//Tweener.addTween( container, { x: 1920, time: 0.6, transition:"easeInExpo" } );

			fileRequest = new URLRequest(metadata_xml.Content.Work[s_no].url);
			selectedPic = s_no;
			/*var timer:Timer = new Timer(1000,1);
	        timer.addEventListener(TimerEvent.TIMER_COMPLETE, function(){
								   
   	            timer.removeEventListener(TimerEvent.TIMER_COMPLETE,timerHandler);

		        //gotoAndStop( 3 );
		        createPuzzle();
	        });
			timer.start();*/

			Tweener.addTween(this, {delay: 1, onComplete: function() {
				trace("Calling createPuzzle()");
				createPuzzle();
			}});

		}

		function timerHandler(e:TimerEvent):void
	    {
	    	timer.removeEventListener(TimerEvent.TIMER_COMPLETE,timerHandler);
	    	gotoAndStop(2);
	    }

		/**
		 * check if the mouse is close to the image, if so, show the img
		 */
		function check_distance(p:org.papervision3d.objects.Plane):Boolean
		{
			var p1:Point = new Point(p.x, p.y);
			var p2:Point = new Point(container.mouseX + 150, -container.mouseY + 80);
			
			if( Point.distance(p1, p2) < 250 )
			{
				return true;
			}
			else return false;
		}

		function showBackBtn(): void
		{
		    addChildAt( backBtn, getChildIndex(bg_woodtexture) + 1 );
		    backBtn.alpha = 0;
			Tweener.addTween( backBtn, { alpha: 1, delay: 1, time: 1 } );
			backBtn.addEventListener(MouseEvent.CLICK, returnMainBtnHandler );
		}

		function hideBackBtn():void
		{
			Tweener.addTween( backBtn, { y: stage.stageHeight, time: 1 } );
			backBtn.removeEventListener(MouseEvent.CLICK, returnMainBtnHandler );
		}

		/////////////////////////////////////////////////////////////////////
		//////////				PUZZLE				/////////////////////////
		/////////////////////////////////////////////////////////////////////
		var fullImgLoader:Loader = new Loader();
		var fullImg:MovieClip = new MovieClip();
		var fileRequest:URLRequest;

		var infoShown:Boolean = false; //check if info is shown after puzzle completion

		var imgArr:Array = new Array();

		var xpos:Number;
		var ypos:Number;

		var numDone,j:int;
		var numPieces:int;
		var numLoaded:int = 0;
		var imgX:Number;
		var dif:int = 40; //how close do they have to drag the piece

		//createPuzzle() -> loadFullImage() -> setUpPuzzle()-> loadPuzzlePieces -> scramble()
		function createPuzzle(): void
		{
			loadFullImage();
		}

		/**
		 * load and hide full image
		 * start loading puzzle pieces after loading full image
		 */
		function loadFullImage():void
		{
			//trace("loadFullImage() called. fileRequest: " + fileRequest);
			fullImgLoader.load( fileRequest );
			fullImgLoader.contentLoaderInfo.addEventListener( Event.COMPLETE, loaderReady );

		    function loaderReady(e:Event) 
			{
				//trace("loaderReady() called");
				imgLoader.load( fileRequest );
				fullImg.addChild( fullImgLoader );

		        var resizePercent: Number;
				
		        var newW:Number;
				var newH:Number;

				if( fullImg.width > fullImg.height ) 
				{
					resizePercent = ( stage.stageWidth/1.4 - 50 ) / fullImg.width;
					newH = fullImg.height * resizePercent;
					if( newH + 50 > stage.stageHeight ) 
						resizePercent = ( stage.stageHeight - 50 ) / fullImg.height;
				}
				else // height > width
				{
					resizePercent = ( stage.stageHeight - 50 ) / fullImg.height;
					newW = fullImg.width * resizePercent;
					if( newW + 50 > stage.stageWidth/1.2 )
					    resizePercent = ( stage.stageWidth/1.2 - 50 ) / fullImg.width;
				}
				
				//resize img
				fullImg.width *= resizePercent;
				fullImg.height *= resizePercent;

				//center the img to the left side
				xpos = fullImg.x = ( stage.stageWidth/2 - fullImg.width/2 );
				ypos = fullImg.y = ( stage.stageHeight - fullImg.height ) / 2;

		        fullImg.alpha = 0;

		        addChild( fullImg );
				setUpPuzzle();
		    }
		}

		/**
		 * set up puzzle pieces by calling loadPuzzlePieces()
		 * set up frame
		 */
		function setUpPuzzle(): void 
		{
			//trace("setUpPuzzle() called");
			var pieceNum:int;
		    puzzlePicker = Math.random();

		    var puzzleStr:String;

		    if( puzzlePicker < 0.5 ) {
		        numPieces = 8;
		        puzzleStr = "pa";
		        frameStr = "frame";
		    } else {
		        numPieces = 9;
		        puzzleStr = "pb";
		        frameStr = "frame";
		    }

		    for( pieceNum = 1; pieceNum <= numPieces; pieceNum++ ) {
		        this[puzzleStr + pieceNum].alpha = 0;
		        this[puzzleStr + pieceNum].width = fullImg.width;
		        this[puzzleStr + pieceNum].height = fullImg.height;
		        this[puzzleStr + pieceNum].x = 0;
		        this[puzzleStr + pieceNum].y = 0;
		        addChild( this[puzzleStr + pieceNum] );

		        //mask each piece with new image loader
		        //trace("calling loadPuzzlePieces()");
		        loadPuzzlePieces( this[puzzleStr + pieceNum] );
		    }
		    //trace("This is the image array: " + imgArr);

		    //wood texture
		    bg_woodtexture.visible = true;
			bg_woodtexture.scaleX = bg_woodtexture.scaleY = 0.7;
			bg_woodtexture.alpha = 0;
			addChild(bg_woodtexture);
			Tweener.addTween(bg_woodtexture, {scaleX: 1, scaleY: 1, alpha: 1, delay: 0.8, time: 3});

			//frame ADD THIS TO bg_woodtexture
		    bg_woodtexture.addChild(this[frameStr]);
		    this[frameStr].width = fullImg.width*1.02;
		    this[frameStr].height = fullImg.height*1.02;
		    this[frameStr].x = xpos - stage.stageWidth/2;
		    this[frameStr].y = ypos - stage.stageHeight/2;
		}//setUpPuzzle

		/**
		 * load individual piece
		 * call scramble() when last piece is loaded
		 */
		function loadPuzzlePieces( msk:MovieClip ):void
		{
			//trace("loadPuzzlePieces() called. fileRequest: " + fileRequest);
			var imgLoader:Loader = new Loader();
			imgLoader.load( fileRequest );
			imgLoader.contentLoaderInfo.addEventListener( Event.COMPLETE, loadPuzPieceRdy );

			function loadPuzPieceRdy(e:Event) 
			{
				//trace("loadPuzPieceRdy() called");
				imgLoader.width = fullImg.width;
				imgLoader.height = fullImg.height;
				imgLoader.x = 0;
				imgLoader.y = 0;
				
				msk.alpha = 1;
				msk.cacheAsBitmap = true;
				
				imgLoader.mask = msk;
				
				var img: MovieClip = new MovieClip();

				img.addChild( imgLoader );
				img.addChild( msk );

				if( mouseOrTouch == "0" ) 
				{
					img.addEventListener( MouseEvent.MOUSE_DOWN, onMouse );
					img.addEventListener( MouseEvent.MOUSE_UP,   onMouse );
				} 
				else if( mouseOrTouch == "1" ) 
				{
					img.addEventListener( TouchEvent.TOUCH_BEGIN, onTouch );
					img.addEventListener( TouchEvent.TOUCH_END,   onTouch );
				}

				img.cacheAsBitmap = true;
				img.mouseChildren = false;
				
				img.x = xpos;
				img.y = ypos;
				img.alpha = 0;
				
				imgArr.push( img ); //update img array
				
				var dropShdw:DropShadowFilter = new DropShadowFilter();
				dropShdw.alpha = 0.7;
				dropShdw.quality = 3;
				dropShdw.distance = 20;
				dropShdw.color = 0x000000;
				dropShdw.blurX = dropShdw.blurY = 10;
				//img.filters = [dropShdw];
				imgLoader.filters = [dropShdw];
				//msk.filters = [dropShdw];
				addChild( img );
				//addOutline( img, 0xbbbbbb, 3 ); //(target, color, thickness )

				numLoaded++;
				//trace("numLoaded: " + numLoaded);

				if( numLoaded == numPieces )
				{
					//trace("imgArr after numLoaded complete:" + imgArr);
					// loading images cause lags, so delay for smoother animation
					var delayTimer:Timer = new Timer( 1000, 1 );
					delayTimer.addEventListener( TimerEvent.TIMER_COMPLETE, function() {
					    showBackBtn();
		                scramble();
					    //idleHandler(); //TEMP? Maybe.
					});
					delayTimer.start();
				}
			}//loadPuzRdy
		}

		function addOutline(obj:*, color:uint, thickness:Number):void 
		{
		    var outline:GlowFilter = new GlowFilter();
		    outline.blurX = outline.blurY = thickness;
		    outline.color = color;
		    outline.quality = BitmapFilterQuality.HIGH;
		    outline.strength = 5;
			outline.alpha = 0.5;
		    var filterArray:Array = new Array();
		    filterArray.push(outline);
		    obj.filters = filterArray;
		}

		function addBlur(obj:*, thickness:Number):void 
		{
		    var outline:BlurFilter = new BlurFilter();
		    outline.blurX = outline.blurY = thickness;
		    outline.quality = BitmapFilterQuality.HIGH;
		    var filterArray:Array = new Array();
		    filterArray.push(outline);
		    obj.filters = filterArray;
		}

		/* SCRAMBLE PUZZLE */
		function scramble(): void
		{
			for(j = 0; j < numPieces; j++)
			{
				var randoX:int = Math.floor(Math.random() * (1 + (stage.stageWidth - 1200) - 0)) + 0;
				var randoY:int = Math.floor(Math.random() * (1 + (stage.stageHeight - 1000) - 0)) + 0;
				
				//drop it in a random place off screen
				var randoBoolX:Boolean = (Math.random() > .5) ? true : false;
				var randoBoolY:Boolean = (Math.random() > .5) ? true : false;
				
				if(randoBoolX) { //right of stage
					imgArr[j].x = Math.floor(Math.random() * (1 + 2500 - 1920)) + 1920;	
				} else { //left of stage
					imgArr[j].x = Math.floor(Math.random() * (1 + -1000 - -2500)) + -2500;
				}

				if(randoBoolY) { //above stage
					imgArr[j].y = Math.floor(Math.random() * (1 + 2500 - 1080)) + 1080;	;
				} else { //below stage
					imgArr[j].y = Math.floor(Math.random() * (1 + -1080 - -2500)) + -2500;
				}

		        imgArr[j].alpha = 0.99;

				Tweener.addTween( imgArr[j], { x: randoX, y: randoY, time: 1.5, delay: j*0.1 } ); //move onto the screen at intervals

			}//for each piece

			numDone=0;
		}



		/***************
		 * TOUCH EVENT *
		 ***************/
		function onTouch( e:TouchEvent ):void
		{
			if( e.target.alpha < 1 )
			{
				//var pt_pivot:Point = new Point(xpos + 900, ypos + 800);
				var glowFilt:GlowFilter = new GlowFilter();
				glowFilt.alpha = 0.5;
				glowFilt.blurX = glowFilt.blurY = 50;
				glowFilt.color = 0xffffff;
				if( e.type == "touchBegin" )
				{	

		            Tweener.addTween(e.target, {scaleX: 1.01, scaleY: 1.01, time: 0.5});
			        
			        e.target.filters = [glowFilt];
			        e.target.startTouchDrag( e.touchPointID );
				    e.target.parent.addChild( e.target ); //bring foward
		            //addChild( backBtn );
				}
				else //touchEnd
				{
					Tweener.addTween(e.target, {scaleX: 1, scaleY: 1, time: 0.5});
					//scaleFromCenter(e.target, 0.95, 0.95, pt_pivot);
					e.target.filters = [];
					e.target.stopTouchDrag( e.touchPointID );
		        	checkProgress( MovieClip( e.target ) );
				}
			}
		}

		/***************
		 * MOUSE EVENT *
		 ***************/
		function onMouse( e:MouseEvent ):void
		{
			if( e.target.alpha < 1 )
			{
				//var pt_pivot:Point = new Point(ypos + 900, ypos + 800);
				var glowFilt:GlowFilter = new GlowFilter();
				glowFilt.alpha = 0.5;
				glowFilt.blurX = glowFilt.blurY = 50;
				glowFilt.color = 0xffffff;
				if( e.type == "mouseDown" )
				{
					Tweener.addTween(e.target, {scaleX: 1.01, scaleY: 1.01, time: 0.5});
					//scaleFromCenter(e.target, 1.05, 1.05, pt_pivot);
					e.target.filters = [glowFilt];
					e.target.startDrag();
					e.target.parent.addChild(e.target); //bring foward
		        	//addChild( backBtn );
				}
				else //mouseUp
				{
					Tweener.addTween(e.target, {scaleX: 1, scaleY: 1, time: 0.5});
					//scaleFromCenter(e.target, 0.95, 0.95, pt_pivot);
					e.target.filters = [];
					e.target.stopDrag();
		        	checkProgress( MovieClip( e.target ) );
				}
			}
		}

		function checkProgress( target:MovieClip ):void
		{
		    //figure out which piece it is
		    var piece:int = 0;
		    while(target != imgArr[piece]){
		        piece++;
		    }

		    //current x,y
		    var curX:int = imgArr[piece].x;
		    var curY:int = imgArr[piece].y;
				
		    //close enough
		    if( curX <= xpos + dif && curX >= xpos - dif && 
		        curY <= ypos + dif && curY >= ypos - dif ) {
		        
		        addChildAt(imgArr[piece], getChildIndex(bg_woodtexture) + 1);
		        
		        Tweener.addTween(imgArr[piece], {x: xpos, y: ypos, alpha: 1, delay: 0.3, time: 0.5});
		        imgArr[piece].removeEventListener(MouseEvent.MOUSE_DOWN, onMouse);
				imgArr[piece].removeEventListener( MouseEvent.MOUSE_UP,   onMouse );
				imgArr[piece].removeEventListener( TouchEvent.TOUCH_BEGIN, onTouch );
				imgArr[piece].removeEventListener( TouchEvent.TOUCH_END,   onTouch );

		        //imgArr[piece].imgLoader.filters = [];
		        imgArr[piece].getChildAt(0).filters = [];
				imgArr[piece].filters = [];
		        numDone++;

		        if( numDone >= numPieces ) 
				{ //puzzle finished
		            playSound("win.mp3");
		            puzzleComplete();
		        }
		        else 
				{ //puzzle not finished yet
		            playSound("ok.mp3");
		        }
		    } //if close enough
		}



		/* PLAY SOUND */
		function playSound(file:String): void 
		{
			var sound:Sound=new Sound();
			sound.load(new URLRequest(file));
			sound.play();
		}



		/* RETURN TO MAIN TILE INTERFACE */
		function returnMainBtnHandler(e:MouseEvent):void
		{
			returnMain();
		}

		function returnMain():void
		{
			if( finishedPuzzle )
			{
				Tweener.addTween(viewport, {alpha: 0, time: 1, onComplete: function() {
					removeChild(viewport);
				}});

				mv_nevelson.y = 1200;
			}
			else
			{
				for( var k=0; k<numPieces; k++ ) {
					if( imgArr[k].alpha == 1 ) { //fade out puzzles in place
						Tweener.addTween( imgArr[k], { alpha: 0, time: 1 , onComplete: function(){ /*imgArr[k].dispose(); imgArr[k] = null;*/ }} );
					} else {
						//Tweener.addTween( imgArr[k], { scaleX: 3, scaleY: 3, alpha: 0, time: 2 } );
						//drop it in a random place off screen
						var randoBoolX:Boolean = (Math.random() > .5) ? true : false;
						var randoBoolY:Boolean = (Math.random() > .5) ? true : false;
						var randoX:int;
						var randoY:int;
						if(randoBoolX) { //right of stage
							randoX = Math.floor(Math.random() * (1 + 2500 - 1920)) + 1920;	
						} else { //left of stage
							randoX = Math.floor(Math.random() * (1 + -1000 - -2500)) + -2500;
						}

						if(randoBoolY) { //above stage
							randoY = Math.floor(Math.random() * (1 + 2500 - 1080)) + 1080;	;
						} else { //baelow stage
							randoY = Math.floor(Math.random() * (1 + -1080 - -2500)) + -2500;
						}

						Tweener.addTween( imgArr[k], { x: randoX, y: randoY, time: 1, delay: k*0.1, onComplete: function(){ /*imgArr[k].dispose(); imgArr[k] = null;*/ }} );
					}
				}
			}

			imgArr.splice(0);

			//remove bg and back
			Tweener.addTween(bg_woodtexture, {scaleX: 0.7, scaleY: 0.7, alpha: 0, time: 2, delay: 1.5, onComplete: function(){ removeChild(bg_woodtexture); }});
			Tweener.addTween(backBtn, {alpha: 0, time: 1, onComplete: function() { removeChild(backBtn); }})
			
			//scale back thumbs
			container.scaleX = container.scaleY = 3;
			container.alpha = 0;
			addChild(container);
			Tweener.addTween(container, {scaleX: 1, scaleY: 1, alpha: 1, time: 1, delay: 2 });

			//reset
			numLoaded = 0;
			fileRequest = null;
			fullImg = null;
			front_plane = null;
			back_plane = null;
			Tweener.addTween(this, {delay: 1, onComplete: function() { 
				sceneCard.removeChild(imgCard);
				imgCard = new org.papervision3d2.objects.DisplayObject3D();
			}});
			//sceneCard.removeChild(imgCard);
			/*var timer:Timer = new Timer(1000,1);
	        timer.addEventListener(TimerEvent.TIMER_COMPLETE, function(){
	        	sceneCard.removeChild(imgCard);
	        });
			timer.start();*/
			//imgCard = new org.papervision3d2.objects.DisplayObject3D();
			fullImg = new MovieClip();
			fullImgLoader = null;
			fullImgLoader = new Loader();
		}



		function puzzleComplete():void
		{	
			finishedPuzzle = true;

		    var k;
		    for( k=0; k<numPieces; k++ )
			{
		        
		        removeChild(imgArr[k]);
		        /*Tweener.addTween(imgArr[k], {alpha: 0, time: 1, delay: 1, onComplete: function() { 
		        	imgArr[k].removeEventListener( MouseEvent.MOUSE_DOWN, onMouse );
		        	imgArr[k].removeEventListener( MouseEvent.MOUSE_UP, onMouse );
					imgArr[k].removeEventListener( TouchEvent.TOUCH_BEGIN, onTouch );
					imgArr[k].removeEventListener( TouchEvent.TOUCH_END, onTouch );
					removeChild(imgArr[k]);
		        }});*/
		        //imgArr[k].x = awayStageL;
		    }

		    viewport.alpha = 0;
		    
		    addChildAt(viewport, getChildIndex(bg_woodtexture) + 1);
		    Tweener.addTween(viewport, {alpha: 1, delay: 1.5, time: 1});
		}	
	}
}