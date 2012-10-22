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

	import org.papervision3d.scenes.*;
	import org.papervision3d.cameras.*;
	import org.papervision3d.objects.*;
	import org.papervision3d.materials.*;

	import com.chrometaphore.display.video.colibri.Colibri;
	import com.chrometaphore.display.video.colibri.ColibriEvent;

	import caurina.transitions.*;

	public class Main extends MovieClip {
			var puzzlePicker:Number;
		    var frameStr:String;
			
		    //img_list.xml setting strings
			var mouseOrTouch:String;
		    var loadingScreen:String;
			var videoRatio:Number;
			
		    var numImg: int = 25;

		    var awayStageR: int = stage.stageWidth*2;
			var awayStageL: int = -stage.stageWidth*2;
		    var container_x:int = 350;
		    var container_y:int = stage.stageHeight * 0.5 + 350;
		    
		    var container:Sprite;
		    var scene:Scene3D;
		    var cam:Camera3D;

		    var container2:Sprite;
		    var scene2:Scene3D;
		    var cam2:Camera3D;

		    var p_dict:Dictionary;		    
		    var pa:Array;
		    var filename_list:Array;
			var title_list:Array;
		    var description_list:Array;

		    var selectedPic: int;

		    var i:int; 
		    var numTiles:int;
		    var img_xml:XML;
		    var pic_loader:Loader;
		    var xml_loader:URLLoader;
			
			var timer:Timer;
			var idleTimer:Timer; 
			var countDown:Timer;

			var folder:String = "photos/"; //change to FOLDER_PATH

			var logos:Boolean = false; //turn on & off welcome screen
			var began:Boolean = false; //prevent tiles to get generated more than once
			var finishedPuzzle:Boolean = false;
			public var imgLoader:Loader;
			public var bitmap:Bitmap;
			public var imgCard:DisplayObject3D;
			private var cardFacingFront:Boolean = true;
			private var vidPlaying:Boolean = false;
			public var card:Card = new Card();
			public var back_material:MovieMaterial;
			public var back_plane:Plane;

			public function Main() {
				gotoAndStop(2);
				//stage.scaleMode = StageScaleMode.EXACT_FIT;
				stage.displayState = StageDisplayState.FULL_SCREEN;
				stage.align = StageAlign.TOP_LEFT;
				Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;

				/*imgLoader = new Loader();
				imgLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, imageLoaded )
				imgLoader.load(new URLRequest("images/1925-1.jpg"));*/
				//addChild(imgLoader);

				//imgCard = new DisplayObject3D();

				if( logos )
				{
					stop();
					timer = new Timer(18000, 1);
					timer.addEventListener(TimerEvent.TIMER_COMPLETE, timerHandler);
					timer.start();
				}

				tn_title.alpha = 0;
				txtBg.alpha = 0;

				container = new Sprite();
				container.x = container_x;
		    	container.y = container_y;
		    	addChild(container);
				scene = new MovieScene3D(container)
				cam = new Camera3D();
		    	cam.zoom = 10;

			    addEventListener(Event.ENTER_FRAME, render);

		    	/*container2 = new Sprite();
				container2.x = container_x;
		    	container2.y = container_y;
		    	addChild(container2);
				scene2 = new MovieScene3D(container2)
				cam2 = new Camera3D();
				cam2.zoom = 10;
				back_material = new MovieMaterial(card);
				back_plane = new Plane(back_material,1700,1030,10,20);
				scene2.addChild(back_plane);
				addEventListener(Event.ENTER_FRAME, render2);*/

				p_dict = new Dictionary();
				pa = new Array();
				filename_list = new Array();
				title_list = new Array();
				description_list = new Array();


			    img_xml = new XML();
			    pic_loader = new Loader();
			    xml_loader = new URLLoader();
			    xml_loader.load( new URLRequest("img_list.xml") );
		    	xml_loader.addEventListener(Event.COMPLETE, create_thumbnail);

				idleTimer = new Timer(180*1000); //3minutes, 180 seconds
				countDown = new Timer( 10 *1000 ); //10 seconds count down for pop up

		}

		function create_thumbnail(e:Event):void
		{
			var thumbSize: int = 160;
			var thumbGap: int = 8;

			img_xml = XML(e.target.data);

		    //read settings from xml
		    mouseOrTouch = img_xml.inputmethod[0].@input.toString();
		    loadingScreen = img_xml.loadingscreen[0].@enable.toString();
			videoRatio = img_xml.videoRatio[0].@ratio.toString();
			
			numTiles = 45;//img_xml.thumbnail.length();
			for( i = 0; i < numTiles; i++ )
			{
		        var index;

		        if( i+1 > numImg ) {
		            index = i - numImg;
		        } else {
		            index = i;
		        }

				filename_list.push( img_xml.thumbnail[index].@filename.toString() );

				title_list.push( img_xml.thumbnail[index].@title.toString() );
				description_list.push( img_xml.thumbnail[index].@description.toString() );

				var bfm:BitmapFileMaterial = new BitmapFileMaterial(
					folder + "s_" + img_xml.thumbnail[index].@filename.toString());
				
				bfm.oneSide = false;
				bfm.smooth = true;
				var p:Plane = new Plane(bfm, thumbSize, thumbSize, 2, 2);
				scene.addChild(p);
				var p_container:Sprite = p.container;
				p_container.name = "flashmo_" + i;
				p_dict[p_container] = p;
				p_container.buttonMode = true;
				p_container.addEventListener( MouseEvent.ROLL_OVER, p_rollover );
				p_container.addEventListener( MouseEvent.ROLL_OUT, p_rollout );
				p_container.addEventListener( MouseEvent.CLICK, p_click );
				
				pa.push({pl:p, rotY:Math.random() * 360, rotZ:Math.random() * 360, z:Math.random() * 4000 + 1500});
				p.rotationY = pa[i].rotY;
				p.rotationZ = pa[i].rotZ;
				p.x = i % 9 * ( thumbSize + thumbGap );
				p.y = Math.floor(i / 9) * ( thumbSize + thumbGap );
				p.z = pa[i].z;
			}//for
		}//create thumbnail

		function p_rollover(me:MouseEvent) 
		{
			var sp:Sprite = me.target as Sprite;
			Tweener.addTween( sp, {alpha: 0.5, time: 0.6} );
		}

		function p_rollout(me:MouseEvent) 
		{
			var sp:Sprite = me.target as Sprite;
			Tweener.addTween( sp, {alpha: 1, time: 0.6} );
		}

		function p_click(me:MouseEvent) 
		{
			var sp:Sprite = me.target as Sprite;
			var s_no:Number = parseInt(sp.name.slice(8,10));

			tn_title.text = title_list[s_no];
			tn_desc.text = description_list[s_no];

			//move away tiles container
			Tweener.addTween( container, { x: 1500, time: 0.6, transition:"easeInExpo" } );

			/* see which picture is selected */
			var k:int = 0;
			var j:int;
			for(j=1; j<=numTiles; ++j)
			{
				if( j > numImg )
					k = j - numImg;
				else
					k = j;

				var s:String = "img" + k + ".jpg";

		        if( s == filename_list[s_no] ) 
				{
					fileRequest = new URLRequest("photos/img" +  k + ".jpg");
					
					selectedPic = k;
					
					var timer:Timer = new Timer(1000,1);
			        timer.addEventListener(TimerEvent.TIMER_COMPLETE, function(){
										   
		   	            timer.removeEventListener(TimerEvent.TIMER_COMPLETE,timerHandler);

				        gotoAndStop( 3 );
			        });
					timer.start();
				}
			}//for
		}

		function timerHandler(e:TimerEvent):void
	    {
	    	timer.removeEventListener(TimerEvent.TIMER_COMPLETE,timerHandler);
	    	gotoAndStop(2);
	    }

	    public function imageLoaded(e:Event):void {
			trace("loaded!");
			/*var bmp:Bitmap = imgLoader.content as Bitmap;
			var front_material:BitmapMaterial = new BitmapMaterial(bmp.bitmapData);
			front_material.interactive = true;
			//bitmap = new Bitmap(bmp.bitmapData);

			front_plane = new Plane(front_material,474,1030,4,5);
			//scene.addChild(front_plane);
			front_plane.addEventListener(InteractiveScene3DEvent.OBJECT_PRESS,on_plane_clicked);

			imgCard.addChild(front_plane);
			imgCard.addChild(back_plane);
			scene.addChild(imgCard);*/
			
			//var bitmapHolder:Sprite = new Sprite();
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
			cam.x = ( 800 - stage.mouseX ) * 0.1;
			cam.y = ( 480 - stage.mouseY ) * 0.1;
			scene.renderCamera(cam);
		}

		function render2(e:Event):void
		{
			scene.renderCamera(cam);
		}

		/**
		 * check if the mouse is close to the image, if so, show the img
		 */
		function check_distance(p:Plane):Boolean
		{
			var p1:Point = new Point(p.x, p.y);
			var p2:Point = new Point(container.mouseX + 150, -container.mouseY + 80);
			
			if( Point.distance(p1, p2) < 250 )
			{
				return true;
			}
			else return false;
		}

		function showVidBtn():void
		{
		    addChild( vidBtn );
			Tweener.addTween( vidBtn, { y: stage.stageHeight - vidBtn.height, time: 1 } );
			vidBtn.addEventListener( MouseEvent.CLICK, initVid );
		}

		function hideVidBtn():void
		{
			Tweener.addTween( vidBtn, {y: stage.stageHeight, time: 1 } );
			vidBtn.removeEventListener( MouseEvent.CLICK, initVid );
		}

		function showBackBtn(): void
		{
		    addChild( backBtn );
			Tweener.addTween( backBtn, { y: stage.stageHeight - backBtn.height, time: 1 } );
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
		var imgX:Number;
		var dif:int = 10; //how close do they have to drag the piece

		//createPuzzle() -> loadFullImage() -> setUpPuzzle()-> loadPuzzlePieces -> scramble()
		function createPuzzle(): void
		{
			idlePopUp.alpha = 0;
			showLoading();
			loadFullImage();
		}

		function showLoading():void
		{
		    if( loadingScreen == "1" )
		        loading.y = ( stage.stageHeight - loading.height ) / 2 ;
		}

		function hideLoading():void
		{
		    if( loadingScreen == "1" )
		        loading.y = -100;
		}

		/**
		 * load and hide full image
		 * start loading puzzle pieces after loading full image
		 */
		function loadFullImage(): void
		{
			fullImgLoader.load( fileRequest );
			fullImgLoader.contentLoaderInfo.addEventListener( Event.COMPLETE, loaderReady );

		    function loaderReady(e:Event) 
			{
				fullImg.addChild( fullImgLoader );

		        var resizePercent: Number;
				
		        var newW:Number;
				var newH:Number;

				if( fullImg.width > fullImg.height ) 
				{
					resizePercent = ( stage.stageWidth/2 - 50 ) / fullImg.width;
					newH = fullImg.height * resizePercent;
					if( newH + 50 > stage.stageHeight ) 
						resizePercent = ( stage.stageHeight - 50 ) / fullImg.height;
				}
				else // height > width
				{
					resizePercent = ( stage.stageHeight - 50 ) / fullImg.height;
					newW = fullImg.width * resizePercent;
					if( newW + 50 > stage.stageWidth/2 )
					    resizePercent = ( stage.stageWidth/2 - 50 ) / fullImg.width;
				}
				
				//resize img
				fullImg.width *= resizePercent;
				fullImg.height *= resizePercent;

				//center the img to the left side
				xpos = fullImg.x = ( stage.stageWidth/2 - fullImg.width ) / 2;
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
			var pieceNum:int;
		    puzzlePicker = Math.random();

		    var puzzleStr:String;

		    if( puzzlePicker < 0.5 ) {
		        numPieces = 8;
		        puzzleStr = "pa";
		        frameStr = "frameA";
		    } else {
		        numPieces = 9;
		        puzzleStr = "pb";
		        frameStr = "frameB";
		    }

		    for( pieceNum = 1; pieceNum<=numPieces; pieceNum++ )
		    {
		        this[puzzleStr + pieceNum].alpha = 0;
		        this[puzzleStr + pieceNum].width = fullImg.width;
		        this[puzzleStr + pieceNum].height = fullImg.height;
		        this[puzzleStr + pieceNum].x = 0;
		        this[puzzleStr + pieceNum].y = 0;
		        addChild( this[puzzleStr + pieceNum] ); 

		        //mask each piece with new image loader
		        loadPuzzlePieces( this[puzzleStr + pieceNum], imgArr );
		    }

		    this[frameStr].width = fullImg.width;
		    this[frameStr].height = fullImg.height;
		    this[frameStr].x = awayStageL;
		    this[frameStr].y = ypos;
		}//setUpPuzzle

		/**
		 * load individual piece
		 * call scramble() when last piece is loaded
		 */
		var numLoaded:int = 0;
		function loadPuzzlePieces( msk:MovieClip, imgArr:Array ):void
		{
			var imgLoader: Loader = new Loader();
			imgLoader.load( fileRequest );
			imgLoader.contentLoaderInfo.addEventListener( Event.COMPLETE, loadPuzPieceRdy );
			
			function loadPuzPieceRdy(e:Event) 
			{
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
				
				addChild( img );
				addOutline( img, 0xbbbbbb, 3 ); //(target, color, thickness )

				numLoaded++;

				if( numLoaded == numPieces )
				{
					// loading images cause lags, so delay for smoother animation
					var delayTimer:Timer = new Timer( 1000, 1 );
					delayTimer.addEventListener( TimerEvent.TIMER_COMPLETE, function() {
					    hideLoading();
					    showBackBtn();
		                scramble();
					    idleHandler();
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
			for(j=0;j<numPieces;j++)
			{
				var pieceX: int = stage.stageWidth/2 + Math.random()*100;
				
				imgArr[j].x = stage.stageWidth*2;
		        imgArr[j].alpha = 0.9;
				
		        var pieceName:String = imgArr[j].getChildAt(1).name;
				var c:String = pieceName.charAt( 2 );

		        //each piece's center is the same, but the position is different; so need to cal y differently
				if( c == "1" || c == "2" || pieceName == "pb3" )
		            imgArr[j].y = 10;
				else if( c == "3" || c == "4" )
		            imgArr[j].y = -fullImg.height/4;
				else                            
		            imgArr[j].y = -fullImg.height/4*2;

				imgArr[j].y += Math.random()*(stage.stageHeight-300);
				
				//pieces moving in from the rihgt
				Tweener.addTween( imgArr[j], { x: pieceX, time: 1.5 } );
			}//for each piece

		    addBlur( this[frameStr], 1.1 );
			Tweener.addTween( this[frameStr], { x: xpos, time: 1 } );

			numDone=0;
		}



		/***************
		 * TOUCH EVENT *
		 ***************/
		function onTouch( e:TouchEvent ):void
		{
			if( e.target.alpha < 1 )
			{
				if( e.type == "touchBegin" )
				{
			        e.target.startTouchDrag( e.touchPointID );
				    e.target.parent.addChild( e.target ); //bring foward
		            addChild( backBtn );
				}
				else //touchEnd
				{
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
				if( e.type == "mouseDown" )
				{
					e.target.startDrag();
					e.target.parent.addChild(e.target); //bring foward
		        	addChild( backBtn );
				}
				else //mouseUp
				{
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
		        curY <= ypos + dif && curY >= ypos - dif )
		    {
		        addChildAt(imgArr[piece], 0)
		        imgArr[piece].x = xpos;
		        imgArr[piece].y = ypos;
		        imgArr[piece].alpha = 1;
				imgArr[piece].filters = null;
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
			resetTimers();
			returnMain();
		}

		function returnMain():void
		{
			if( finishedPuzzle )
			{
				fadeOutText();
		        moveOutText();
			}
			else
			{
				Tweener.addTween( this[frameStr], { x: awayStageL, time: 3 } );

				var k:int;
				for( k=0; k<numPieces; k++ )
				{
					if( imgArr[k].alpha != 1 ) {
						Tweener.addTween( imgArr[k], { x: awayStageR, time: 3 } );
					} else {
						Tweener.addTween( imgArr[k], { x: awayStageL, time: 3 } );
					}
				}
				imgArr = new Array();
			}

			fullImg.x = awayStageL;
			fullImg.removeEventListener( MouseEvent.CLICK, showInfo );

			Tweener.addTween( container, { x: container_x, time: 1.5, delay: 1, transition:"easeOutExpo"} );

			hideVidBtn();
			hideBackBtn();

			numLoaded = 0;

			var timer:Timer = new Timer(300,1);
			timer.addEventListener( TimerEvent.TIMER_COMPLETE, function(){ gotoAndStop( 2 );} );
			timer.start();
		}



		function puzzleComplete():void
		{	
			finishedPuzzle = true;

		    var k;
		    for( k=0; k<numPieces; k++ )
			{
		        imgArr[k].alpha = 0;
		        imgArr[k].x = awayStageL;
		    }

			this[frameStr].alpha = 0;
			this[frameStr].x = awayStageL;
			this[frameStr].alpha = 1;

			hideBackBtn();

			/** 
			 * Calculate Img Size 
			 */
			var proportion: Number;
			var imgW:Number;
			var imgH:Number;
			
			if( fullImg.width > fullImg.height )
			{
				proportion = (stage.stageWidth - 50)/fullImg.width;
				imgH = fullImg.height * proportion;
				if( imgH + 50 > stage.stageHeight )
					proportion = (stage.stageHeight - 50)/fullImg.height;
			}
			else
			{
				proportion = (stage.stageHeight - 50)/fullImg.height;
				imgW = fullImg.width * proportion;
				if( imgH + 50 > stage.stageWidth/2 )
					proportion = (stage.stageWidth - 50)/fullImg.width;
			}
			
			imgW = fullImg.width * proportion;
			imgH = fullImg.height * proportion;

			/** 
			 * Animate Img to enlarge and move to the center
			 */
			fullImg.alpha = 1;

		    var imgX:Number = ( stage.stageWidth - imgW )/2;
		    var imgY:Number = ( stage.stageHeight - imgH )/2;

			Tweener.addTween( fullImg, { width: imgW, height: imgH, y: imgY ,x: imgX , time: 1.5 } );
			
			fullImg.addEventListener( MouseEvent.CLICK, showInfo );

			//resize txt
		    tn_title.width = imgW;
		    tn_desc.width = imgW;
		    tn_desc.height = imgH;
		    txtBg.width = imgW;
		    txtBg.height = imgH;

		    //hide text
		    tn_title.alpha = 0;
		    tn_desc.alpha = 0;
		    txtBg.alpha = 0;
		    moveInText();
		}

		function showInfo( e: MouseEvent ):void
		{
			if( !infoShown ) 
			{
				Tweener.addTween( fullImg, { alpha: 0, time: 1.5 } );
			    showBackBtn();
			    showVidBtn();
			    fadeInText();
			    infoShown = true;
			}
			else
			{
				Tweener.addTween( fullImg, { alpha: 1, time: 1.5 } );
			    hideBackBtn();
			    hideVidBtn();
			    fadeOutText();
			    infoShown = false;
			}
		}

		function moveInText():void
		{
			//text position
			tn_title.x = ( stage.stageWidth - txtBg.width )/2; + 1;
			tn_title.y = ( stage.stageHeight - txtBg.height )/2 + 1;
			
			tn_desc.x = tn_title.x;
			tn_desc.y = tn_title.y + tn_title.height;

			txtBg.x = tn_title.x - 1;
			txtBg.y = tn_title.y - 1;
		}

		function moveOutText():void
		{
		    //1 sec for txt to fade out
		    var txtTimer: Timer = new Timer( 1000, 1 );
			txtTimer.addEventListener( TimerEvent.TIMER_COMPLETE, function(){
				tn_title.x = awayStageR;
				tn_desc.x = awayStageR;
				txtBg.x = awayStageR;
			});
			txtTimer.start();
		}

		function fadeInText():void
		{
			//fade in text
			Tweener.addTween( tn_title, { alpha: 1, time: 1 } );
			Tweener.addTween( tn_desc,  { alpha: 1, time: 1 } );
			Tweener.addTween( txtBg,  { alpha: 1, time: 1 } );
		}

		function fadeOutText(): void
		{
		    //fade out text
			Tweener.addTween( tn_title, { alpha: 0, time: 1 } );
			Tweener.addTween( tn_desc,  { alpha: 0, time: 1 } );
			Tweener.addTween( txtBg,  { alpha: 0, time: 1 } );
		}



		/****************/
		/* IDLE HANDLER */
		/****************/
		function idleHandler():void
		{
			resetTimers();

			stage.addEventListener(MouseEvent.MOUSE_DOWN, timerResetHandler );
			
		    idleTimer.addEventListener(TimerEvent.TIMER, idleTimerHandler);
		    idleTimer.start();
		}//idleHandler

		/**
		 * @user has not played for over 3 minutes, prompt user with countdown window
		 */
		function idleTimerHandler(e:TimerEvent):void 
		{
			var temp:Number = ( stage.stageHeight - idlePopUp.height )/2;
			idlePopUp.y = temp;

			addChild( idlePopUp );
			Tweener.addTween( idlePopUp, { alpha: 1, time: 1 } );
			
			idlePopUp.gotoAndPlay(1);

			var txtCountDown:Timer = new Timer( 1000, 9 );

		    sec.y = 463.3;
			addChild( sec );
			sec.text = "10";
			i = 9;
			txtCountDown.addEventListener( TimerEvent.TIMER, function(){
				sec.text = " " + i--;
			} );
			txtCountDown.start();

			countDown.addEventListener(TimerEvent.TIMER, countDownHandler );
			countDown.start();
		}//inactivePopUp

		/*
		 * @return to main screen after count down
		 */
		function countDownHandler( e:TimerEvent ): void
		{
			Tweener.addTween( idlePopUp, { alpha: 0, time: 1 } );
			idlePopUp.y = -130;
			sec.y = -130;

			resetTimers();
			removeTimerListeners();

			returnMain();
		}

		/**
		 * @reset timer when user is actively playing
		 */
		function timerResetHandler(e:MouseEvent):void 
		{
			Tweener.addTween( idlePopUp, { alpha: 0, time: 1 } );
			idlePopUp.y = -130;
		    sec.y = -130;
				
			resetTimers();

		    idleTimer.start();
		}

		function resetTimers():void
		{
			countDown.reset();
		    idleTimer.reset();
			idlePopUp.stop();
		}

		function removeTimerListeners(): void
		{
			idleTimer.removeEventListener(TimerEvent.TIMER, idleTimerHandler);
			countDown.removeEventListener(TimerEvent.TIMER, countDownHandler );
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, timerResetHandler );
		}
		/*********************/
		/* IDLE HANDLER ENDS */
		/*********************/



		/*********/
		/* VIDEO */
		/*********/
		function initVid(e:MouseEvent): void
		{
			resetTimers();

			var vidFolder:String 		= "videos/";

			/* VIDEO PROPERTIES */
			var videoURL:String         = vidFolder + "vid" + selectedPic + ".flv";
			var videoWidth:Number       = stage.stageWidth*videoRatio;
			var videoHeight:Number      = stage.stageHeight*videoRatio;
			var autoPlayVideo:Boolean   = true;
			
			//create a video player instance using the vars we just created
			var player:Colibri = new Colibri( videoWidth,
										      videoHeight,
											  videoURL,
											  autoPlayVideo );

			player.video.stream.bufferTime = 2;
			
			//player position..
			player.x = ( stage.stageWidth  - videoWidth  )/2;
			player.y = ( stage.stageHeight - videoHeight )/2;
			
			/* REMOVE frame, img, backBtn, vidBtn, text */
			imgX = fullImg.x;
			fullImg.x = awayStageL;
			hideBackBtn();
			hideVidBtn();
			fadeOutText();

			/* set player opacity to 0 for fade in effect */
			player.alpha = 0;

			/* delay player time to allow tween motion */
			var timer:Timer = new Timer(500,1);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, function(){addChild(player);});
			timer.start();

			/* fade in player */
			Tweener.addTween( player, { alpha: 1, time : 3 } );
			
			/* set 0, mute */
			var st:SoundTransform = new SoundTransform();
			st.volume = 1;
			player.video.stream.soundTransform = st;
			
			/* go back after player is finished */
		    player.addEventListener( ColibriEvent.ON_FINISHED, function() 
			{
				/* fade out player */
				Tweener.addTween( player, { alpha: 0, time : 1 } );
					
				/* kill player after player fades out */
				var afterFade:Timer = new Timer( 1000, 1 );
				afterFade.addEventListener( TimerEvent.TIMER_COMPLETE, function() 
				{ 
				    player.x = awayStageL; 
					player.destroy(); 
					player = null;
				} );
				afterFade.start();
					
				/* BRING BACK frame, img, backBtn, vidBtn, text */
				fullImg.x = imgX;
				showBackBtn();
				showVidBtn();
				fadeInText();
					
				idleHandler();
			} );
		} //end initVide
	}
}