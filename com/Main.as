package com {
	import flash.events.*;
	import flash.display.*;
	import flash.net.*;
	import fl.video.VideoEvent;
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
	import id.core.*;
	import gl.events.*

	/*import org.papervision3d.scenes.*;
	import org.papervision3d.cameras.*;
	import org.papervision3d.objects.*;
	import org.papervision3d.materials.*;*/

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

	public class Main extends Application {
			private var puzzlePicker:Number;
		    private var frameStr:String;
			
		    //img_list.xml setting strings
			private var mouseOrTouch:String;
		    private var loadingScreen:String;
			private var videoRatio:Number;	    
		    private var container:Sprite;
		    //private var scene:org.papervision3d.scenes.MovieScene3D;
		    //private var cam:org.papervision3d.cameras.Camera3D;
			private var timer:Timer;
			private var idleTimer:Timer;
			private var countDown:Timer;
		    private var p_dict:Dictionary;		    
		    private var pa:Array;
		    private var video_list:Array;
		    private var thumblist:Array;
		    private var puzList:Array;
		    private var selectedPic:int; //current image
		    private var i:int; 
		    private var numTiles:int;
		    private var metadata_xml:XML;
		    private var pic_loader:Loader;
		    private var imgThumb:Loader = new Loader(); //thumb to appear on back of card
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

			var cont_henri:TouchSprite, cont_zuijin:TouchSprite, cont_sorolla:TouchSprite, cont_bougeureau:TouchSprite, cont_greco:TouchSprite, 
			cont_guanyin:TouchSprite, cont_tamayo:TouchSprite, cont_skullrack:TouchSprite, cont_giorgione:TouchSprite, cont_matisse:TouchSprite, 
			cont_shiva:TouchSprite, cont_zhang:TouchSprite, cont_eakins:TouchSprite, cont_rivera:TouchSprite, cont_meiping:TouchSprite, 
			cont_nevelson:TouchSprite, cont_stella:TouchSprite, cont_dix:TouchSprite, cont_mitchell:TouchSprite, cont_okeefe:TouchSprite, 
			cont_johnson:TouchSprite, cont_durand:TouchSprite, cont_goya:TouchSprite, cont_ruknuddin:TouchSprite, cont_cotan:TouchSprite; 
			
			var cont_henri_vid:TouchSprite, cont_zuijin_vid:TouchSprite, cont_sorolla_vid:TouchSprite, cont_bougeureau_vid:TouchSprite, 
			cont_greco_vid:TouchSprite, cont_guanyin_vid:TouchSprite, cont_tamayo_vid:TouchSprite, cont_skullrack_vid:TouchSprite, 
			cont_giorgione_vid:TouchSprite, cont_matisse_vid:TouchSprite, cont_shiva_vid:TouchSprite, cont_zhang_vid:TouchSprite, 
			cont_eakins_vid:TouchSprite, cont_rivera_vid:TouchSprite, cont_meiping_vid:TouchSprite, cont_nevelson_vid:TouchSprite, 
			cont_stella_vid:TouchSprite, cont_dix_vid:TouchSprite, cont_mitchell_vid:TouchSprite, cont_okeefe_vid:TouchSprite, 
			cont_johnson_vid:TouchSprite, cont_durand_vid:TouchSprite, cont_goya_vid:TouchSprite, cont_ruknuddin_vid:TouchSprite, 
			cont_cotan_vid:TouchSprite; 
			
			var cont_info:TouchSprite;
			var cont_home:TouchSprite;
			var cont_blocker:TouchSprite;
			var cont_puz1:TouchSprite, cont_puz2:TouchSprite, cont_puz3:TouchSprite, cont_puz4:TouchSprite, cont_puz5:TouchSprite, 
			cont_puz6:TouchSprite, cont_puz7:TouchSprite, cont_puz8:TouchSprite, cont_puz9:TouchSprite;

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
				/*container = new Sprite();
				container.x = container_x;
		    	container.y = container_y;
		    	addChild(container);
				scene = new org.papervision3d.scenes.MovieScene3D(container);
				cam = new org.papervision3d.cameras.Camera3D();
		    	cam.zoom = 10;
			    addEventListener(Event.ENTER_FRAME, render);*/

			    //Build thumb array
			    cont_henri = new TouchSprite();
			    cont_henri.addChild(mc_henri);
			    cont_henri.name = "0";
			    addChild(cont_henri);
			    cont_zuijin = new TouchSprite();
			    cont_zuijin.addChild(mc_zuijin);
			    cont_zuijin.name = "1";
			    addChild(cont_zuijin);
			    cont_sorolla = new TouchSprite();
			    cont_sorolla.addChild(mc_sorolla);
			    cont_sorolla.name = "2";
			    addChild(cont_sorolla);
			    cont_bougeureau = new TouchSprite();
			    cont_bougeureau.addChild(mc_bougeureau);
			    cont_bougeureau.name = "3";
			    addChild(cont_bougeureau);
			    cont_greco = new TouchSprite();
			    cont_greco.addChild(mc_greco);
			    cont_greco.name = "4";
			    addChild(cont_greco);
			    cont_guanyin = new TouchSprite();
			    cont_guanyin.addChild(mc_guanyin);
			    cont_guanyin.name = "5";
			    addChild(cont_guanyin);
			    cont_tamayo = new TouchSprite();
			    cont_tamayo.addChild(mc_tamayo);
			    cont_tamayo.name = "6";
			    addChild(cont_tamayo);
			    cont_skullrack = new TouchSprite();
			    cont_skullrack.addChild(mc_skullrack);
			    cont_skullrack.name = "7";
			    addChild(cont_skullrack);
			    cont_giorgione = new TouchSprite();
			    cont_giorgione.addChild(mc_giorgione);
			    cont_giorgione.name = "8";
			    addChild(cont_giorgione);
			    cont_matisse = new TouchSprite();
			    cont_matisse.addChild(mc_matisse);
			    cont_matisse.name = "9";
			    addChild(cont_matisse);
			    cont_shiva = new TouchSprite();
			    cont_shiva.addChild(mc_shiva);
			    cont_shiva.name = "10";
			    addChild(cont_shiva);
			    cont_zhang = new TouchSprite();
			    cont_zhang.addChild(mc_zhang);
			    cont_zhang.name = "11";
			    addChild(cont_zhang);
			    cont_eakins = new TouchSprite();
			    cont_eakins.addChild(mc_eakins);
			    cont_eakins.name = "12";
			    addChild(cont_eakins);
			    cont_rivera = new TouchSprite();
			    cont_rivera.addChild(mc_rivera);
			    cont_rivera.name = "13";
			    addChild(cont_rivera);
			    cont_meiping = new TouchSprite();
			    cont_meiping.addChild(mc_meiping);
			    cont_meiping.name = "14";
			    addChild(cont_meiping);
			    cont_nevelson = new TouchSprite();
			    cont_nevelson.addChild(mc_nevelson);
			    cont_nevelson.name = "15";
			    addChild(cont_nevelson);
			    cont_stella = new TouchSprite();
			    cont_stella.addChild(mc_stella);
			    cont_stella.name = "16";
			    addChild(cont_stella);
			    cont_dix = new TouchSprite();
			    cont_dix.addChild(mc_dix);
			    cont_dix.name = "17";
			    addChild(cont_dix);
			    cont_mitchell = new TouchSprite();
			    cont_mitchell.addChild(mc_mitchell);
			    cont_mitchell.name = "18";
			    addChild(cont_mitchell);
			    cont_okeefe = new TouchSprite();
			    cont_okeefe.addChild(mc_okeefe);
			    cont_okeefe.name = "19";
			    addChild(cont_okeefe);
			    cont_johnson = new TouchSprite();
			    cont_johnson.addChild(mc_johnson);
			    cont_johnson.name = "20";
			    addChild(cont_johnson);
			    cont_durand = new TouchSprite();
			    cont_durand.addChild(mc_durand);
			    cont_durand.name = "21";
			    addChild(cont_durand);
			    cont_goya = new TouchSprite();
			    cont_goya.addChild(mc_goya);
			    cont_goya.name = "22";
			    addChild(cont_goya);
			    cont_ruknuddin = new TouchSprite();
			    cont_ruknuddin.addChild(mc_ruknuddin);
			    cont_ruknuddin.name = "23";
			    addChild(cont_ruknuddin);
			    cont_cotan = new TouchSprite();
			    cont_cotan.addChild(mc_cotan);
			    cont_cotan.name = "24";
			    addChild(cont_cotan);

			    //Build array of thumbnails
			    thumblist = new Array();
			    thumblist.push(cont_henri);
			    thumblist.push(cont_zuijin);
			    thumblist.push(cont_sorolla);
			    thumblist.push(cont_bougeureau);
			    thumblist.push(cont_greco);
			    thumblist.push(cont_guanyin);
			    thumblist.push(cont_tamayo);
			    thumblist.push(cont_skullrack);
			    thumblist.push(cont_giorgione);
			    thumblist.push(cont_matisse);
			    thumblist.push(cont_shiva);
			    thumblist.push(cont_zhang);
			    thumblist.push(cont_eakins);
			    thumblist.push(cont_rivera);
			    thumblist.push(cont_meiping);
			    thumblist.push(cont_nevelson);
			    thumblist.push(cont_stella);
			    thumblist.push(cont_dix);
			    thumblist.push(cont_mitchell);
			    thumblist.push(cont_okeefe);
			    thumblist.push(cont_johnson);
			    thumblist.push(cont_durand);
			    thumblist.push(cont_goya);
			    thumblist.push(cont_ruknuddin);
			    thumblist.push(cont_cotan);
			    //Make them tapable
			    for(var i = 0; i < thumblist.length; i++) {
			    	thumblist[i].addEventListener(gl.events.TouchEvent.TOUCH_UP, thumbUp, false, 0, true);
			    	thumblist[i].addEventListener(gl.events.TouchEvent.TOUCH_DOWN, thumbDwn, false, 0, true);
			    	//thumblist[i].addEventListener(GestureEvent.GESTURE_DRAG, dragEvent);
			    }

			    //Build array of puzzle pieces
			    puzList = new Array();
			    cont_puz1 = new TouchSprite(); cont_puz2 = new TouchSprite(); cont_puz3 = new TouchSprite(); cont_puz4 = new TouchSprite();
			    cont_puz5 = new TouchSprite(); cont_puz6 = new TouchSprite(); cont_puz7 = new TouchSprite(); cont_puz8 = new TouchSprite();
			    cont_puz9 = new TouchSprite();
			    puzList.push(cont_puz1);
			    puzList.push(cont_puz2);
			    puzList.push(cont_puz3);
			    puzList.push(cont_puz4);
			    puzList.push(cont_puz5);
			    puzList.push(cont_puz6);
			    puzList.push(cont_puz7);
			    puzList.push(cont_puz8);
			    puzList.push(cont_puz9);

				//Image loader
				imgLoader = new Loader();
				imgLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, imageLoaded );

				//Set up card environment
				back_material = new org.papervision3d2.materials.MovieMaterial(myCard);
				back_plane = new org.papervision3d2.objects.primitives.Plane(back_material,1600,800,10,20);
				back_plane.rotationY = 180;
				camera.focus = 100;
				camera.zoom = 10;
				addEventListener(Event.ENTER_FRAME, renderCard);
				
				//videos
				mv_henri.addEventListener(MouseEvent.MOUSE_UP, vid_click);
				mv_henri.video.addEventListener(fl.video.VideoEvent.COMPLETE, vid_complete);
				mv_sorolla.addEventListener(MouseEvent.MOUSE_UP, vid_click);
				mv_sorolla.video.addEventListener(fl.video.VideoEvent.COMPLETE, vid_complete);
				mv_bougeureau.addEventListener(MouseEvent.MOUSE_UP, vid_click);
				mv_bougeureau.video.addEventListener(fl.video.VideoEvent.COMPLETE, vid_complete);
				mv_greco.addEventListener(MouseEvent.MOUSE_UP, vid_click);
				mv_greco.video.addEventListener(fl.video.VideoEvent.COMPLETE, vid_complete);
				mv_guanyin.addEventListener(MouseEvent.MOUSE_UP, vid_click);
				mv_guanyin.video.addEventListener(fl.video.VideoEvent.COMPLETE, vid_complete);
				mv_tamayo.addEventListener(MouseEvent.MOUSE_UP, vid_click);
				mv_tamayo.video.addEventListener(fl.video.VideoEvent.COMPLETE, vid_complete);
				mv_skullrack.addEventListener(MouseEvent.MOUSE_UP, vid_click);
				mv_skullrack.video.addEventListener(fl.video.VideoEvent.COMPLETE, vid_complete);
				mv_giorgione.addEventListener(MouseEvent.MOUSE_UP, vid_click);
				mv_giorgione.video.addEventListener(fl.video.VideoEvent.COMPLETE, vid_complete);
				mv_matisse.addEventListener(MouseEvent.MOUSE_UP, vid_click);
				mv_matisse.video.addEventListener(fl.video.VideoEvent.COMPLETE, vid_complete);
				mv_shiva.addEventListener(MouseEvent.MOUSE_UP, vid_click);
				mv_shiva.video.addEventListener(fl.video.VideoEvent.COMPLETE, vid_complete);
				mv_eakins.addEventListener(MouseEvent.MOUSE_UP, vid_click);
				mv_eakins.video.addEventListener(fl.video.VideoEvent.COMPLETE, vid_complete);
				mv_rivera.addEventListener(MouseEvent.MOUSE_UP, vid_click);
				mv_rivera.video.addEventListener(fl.video.VideoEvent.COMPLETE, vid_complete);
				mv_nevelson.addEventListener(MouseEvent.MOUSE_UP, vid_click);
				mv_nevelson.video.addEventListener(fl.video.VideoEvent.COMPLETE, vid_complete);
				mv_stella.addEventListener(MouseEvent.MOUSE_UP, vid_click);
				mv_stella.video.addEventListener(fl.video.VideoEvent.COMPLETE, vid_complete);
				mv_mitchell.addEventListener(MouseEvent.MOUSE_UP, vid_click);
				mv_mitchell.video.addEventListener(fl.video.VideoEvent.COMPLETE, vid_complete);
				mv_okeefe.addEventListener(MouseEvent.MOUSE_UP, vid_click);
				mv_okeefe.video.addEventListener(fl.video.VideoEvent.COMPLETE, vid_complete);
				mv_johnson.addEventListener(MouseEvent.MOUSE_UP, vid_click);
				mv_johnson.video.addEventListener(fl.video.VideoEvent.COMPLETE, vid_complete);
				mv_durand.addEventListener(MouseEvent.MOUSE_UP, vid_click);
				mv_durand.video.addEventListener(fl.video.VideoEvent.COMPLETE, vid_complete);
				mv_goya.addEventListener(MouseEvent.MOUSE_UP, vid_click);
				mv_goya.video.addEventListener(fl.video.VideoEvent.COMPLETE, vid_complete);
				mv_ruknuddin.addEventListener(MouseEvent.MOUSE_UP, vid_click);
				mv_ruknuddin.video.addEventListener(fl.video.VideoEvent.COMPLETE, vid_complete);
				mv_cotan.addEventListener(MouseEvent.MOUSE_UP, vid_click);
				mv_cotan.video.addEventListener(fl.video.VideoEvent.COMPLETE, vid_complete);
				mv_henri.video.autoRewind = mv_sorolla.video.autoRewind = mv_bougeureau.video.autoRewind = mv_greco.video.autoRewind = 
				mv_guanyin.video.autoRewind = mv_tamayo.video.autoRewind = mv_skullrack.video.autoRewind = mv_giorgione.video.autoRewind = 
				mv_matisse.video.autoRewind = mv_shiva.video.autoRewind = mv_eakins.video.autoRewind = mv_rivera.video.autoRewind = 
				mv_nevelson.video.autoRewind = mv_stella.video.autoRewind = mv_mitchell.video.autoRewind = mv_okeefe.video.autoRewind = 
				mv_johnson.video.autoRewind = mv_durand.video.autoRewind =  mv_goya.video.autoRewind =  mv_ruknuddin.video.autoRewind = 
				mv_cotan.video.autoRewind = true;
		    	mv_henri.video.fullScreenTakeOver = mv_sorolla.video.fullScreenTakeOver = mv_bougeureau.video.fullScreenTakeOver = 
		    	mv_greco.video.fullScreenTakeOver = mv_guanyin.video.fullScreenTakeOver = mv_tamayo.video.fullScreenTakeOver = 
		    	mv_skullrack.video.fullScreenTakeOver = mv_giorgione.video.fullScreenTakeOver = mv_matisse.video.fullScreenTakeOver = 
		    	mv_shiva.video.fullScreenTakeOver = mv_eakins.video.fullScreenTakeOver = mv_rivera.video.fullScreenTakeOver = 
		    	mv_nevelson.video.fullScreenTakeOver = mv_stella.video.fullScreenTakeOver = mv_mitchell.video.fullScreenTakeOver = 
		    	mv_okeefe.video.fullScreenTakeOver = mv_johnson.video.fullScreenTakeOver = mv_durand.video.fullScreenTakeOver = 
		    	mv_goya.video.fullScreenTakeOver = mv_ruknuddin.video.fullScreenTakeOver = mv_cotan.video.fullScreenTakeOver = false;
		    	removeChild(vid_time);
				video_list = new Array();


				p_dict = new Dictionary();
				pa = new Array();

			    metadata_xml = new XML();
			    pic_loader = new Loader();
			    xml_loader = new URLLoader();
			    xml_loader.load( new URLRequest("25works_metadata.xml") );
		    	xml_loader.addEventListener(Event.COMPLETE, xmlLoaded);

		    	//button prep
		    	removeChild(backBtn);
		    	removeChild(window_credits);
		    	removeChild(effect_glow);
		    	graphic_flipme.alpha = 0;

		    	//blocker
		    	cont_blocker = new TouchSprite();
		    	cont_blocker.addChild(blocker);
		    	
		    	button_info.visible = false;
		    	cont_info = new TouchSprite();
		    	cont_info.addChild(button_info);
		    	cont_info.addEventListener(gl.events.TouchEvent.TOUCH_DOWN, info_dwn);
		    	cont_info.addEventListener(gl.events.TouchEvent.TOUCH_UP, info_up);

		    	backBtn.visible = false;
		    	cont_home = new TouchSprite();
		    	cont_home.addChild(backBtn);

		    	graphic_flipme.addEventListener(MouseEvent.CLICK, flipme);
		}
		
		/*function render(e:Event):void
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
		}*/

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
			myCard.txt_desc.text = metadata_xml.Content.Work[selectedPic].description;
			
			//card front
			var bmp:Bitmap = imgLoader.content as Bitmap;
			var front_material:org.papervision3d2.materials.BitmapMaterial = new org.papervision3d2.materials.BitmapMaterial(bmp.bitmapData);
			front_plane = new org.papervision3d2.objects.primitives.Plane(front_material,fullImg.width,fullImg.height,4,5);
			front_material.interactive = true;
			front_plane.addEventListener(InteractiveScene3DEvent.OBJECT_PRESS, flipCard);

			//video holder
			if(video_list[selectedPic] == null) { //no video
				myCard.graphic_videoblack.visible = myCard.graphic_play.visible = false;

				//place artwork on card
				imgThumb.load( fileRequest );
				imgThumb.contentLoaderInfo.addEventListener( Event.COMPLETE, imgThumb_ready );
			} else {	//has video
				myCard.graphic_videoblack.visible = myCard.graphic_play.visible = true;
				
				back_material = new org.papervision3d2.materials.MovieMaterial(myCard);
				back_plane = new org.papervision3d2.objects.primitives.Plane(back_material,1600,800,10,20);
				back_plane.rotationY = 180;
				back_material.interactive = true;
				back_plane.addEventListener(InteractiveScene3DEvent.OBJECT_PRESS, flipCard);

				imgCard.addChild(back_plane);
				imgCard.addChild(front_plane);
				sceneCard.addChild(imgCard);
			}			
			
			function imgThumb_ready(e:Event) {
				var resizeRatio:Number;
				if(imgThumb.width > imgThumb.height) {
					resizeRatio = (800 - 80) / imgThumb.width;
				} else {
					resizeRatio = (800 - 180) / imgThumb.height;
				}

				imgThumb.width = imgThumb.width * resizeRatio;
				imgThumb.height = imgThumb.height * resizeRatio;
				imgThumb.x = (1200 - imgThumb.width/2) - 20;
				imgThumb.y = (400 - imgThumb.height/2) + 30;

				myCard.addChild(imgThumb);

				back_material = new org.papervision3d2.materials.MovieMaterial(myCard);
				back_plane = new org.papervision3d2.objects.primitives.Plane(back_material,1600,800,10,20);
				back_plane.rotationY = 180;
				back_material.interactive = true;
				back_plane.addEventListener(InteractiveScene3DEvent.OBJECT_PRESS, flipCard);
				
				imgCard.addChild(front_plane);
				imgCard.addChild(back_plane);
				sceneCard.addChild(imgCard);
			}
		}

		public function flipCard(e:InteractiveScene3DEvent) {
			playSound("audio/page_turn.mp3");
			//rotate from front
			if(cardFacingFront) {
				//trace("flip to back");
				cardFacingFront = false;
				imgCard.rotationY = 0;
				cont_home.removeEventListener(gl.events.TouchEvent.TOUCH_DOWN, home_dwn );
				cont_home.removeEventListener(gl.events.TouchEvent.TOUCH_UP, home_up );
				Tweener.addTween(imgCard, {rotationY: 180, time: 1, onComplete: function() {
					//get video if has video
					if(video_list[selectedPic] != null) {
						getVideo();
					}
					cont_home.addEventListener(gl.events.TouchEvent.TOUCH_DOWN, home_dwn );
					cont_home.addEventListener(gl.events.TouchEvent.TOUCH_UP, home_up );
				}});

				//turn off guidance
				if(graphic_flipme.alpha == 1) {
					Tweener.addTween(graphic_flipme, {alpha: 0, time: 0.5});
				}
			} else {
				//trace("flip to front");
				cardFacingFront = true;
				imgCard.rotationY = 180;
				cont_home.removeEventListener(gl.events.TouchEvent.TOUCH_DOWN, home_dwn );
				cont_home.removeEventListener(gl.events.TouchEvent.TOUCH_UP, home_up );
				Tweener.addTween(imgCard, {rotationY: 360, time: 1, onComplete: function() {
					cont_home.addEventListener(gl.events.TouchEvent.TOUCH_DOWN, home_dwn );
					cont_home.addEventListener(gl.events.TouchEvent.TOUCH_UP, home_up );} 
				});

				if(video_list[selectedPic] != null) {
					hideVideo();
					if(vidPlaying) {
						pauseVideo();
						vidPlaying = false;
					}
				}

			}
		}

		public function flipme(e:MouseEvent) {
			playSound("audio/page_turn.mp3");
			//rotate from front
			
			//trace("flip to back");
			cardFacingFront = false;
			imgCard.rotationY = 0;
			cont_home.removeEventListener(gl.events.TouchEvent.TOUCH_DOWN, home_dwn );
			cont_home.removeEventListener(gl.events.TouchEvent.TOUCH_UP, home_up );
			Tweener.addTween(imgCard, {rotationY: 180, time: 1, onComplete: function() {
				//get video if has video
				if(video_list[selectedPic] != null) {
					getVideo();
				}
				
				cont_home.addEventListener(gl.events.TouchEvent.TOUCH_DOWN, home_dwn );
				cont_home.addEventListener(gl.events.TouchEvent.TOUCH_UP, home_up );} 
			});

			//turn off guidance
			if(graphic_flipme.alpha == 1) {
				Tweener.addTween(graphic_flipme, {alpha: 0, time: 0.5});
			}			
		}

		public function vid_click(e:MouseEvent):void {
			//trace("clicked!");
			if(!vidPlaying) {
				playVideo();
				vidPlaying = true;
			} else {
				pauseVideo();
				vidPlaying = false;				
			}
		}
		private function vid_complete(e:fl.video.VideoEvent):void {
			if(video_list[selectedPic] != null) {
				video_list[selectedPic].video.stop();
				Tweener.addTween(video_list[selectedPic].graphic_videoblack, {alpha: 1, time: 1});
				Tweener.addTween(video_list[selectedPic].graphic_play, {alpha: 1, time: 1});
				removeEventListener(Event.ENTER_FRAME, updateTime);
				vid_time.text = "00:00"
				vidPlaying = false;
			}
		}

		private function updateTime(e:Event):void {
			//trace("updateTime() called!");
			if(video_list[selectedPic] != null) {
				vid_time.text = convertToHHMMSS(video_list[selectedPic].video.totalTime - video_list[selectedPic].video.playheadTime);
			}
		}

		private function getVideo():void {
			if(video_list[selectedPic] != null) {
				video_list[selectedPic].alpha = vid_time.alpha = 0;
				video_list[selectedPic].y = 263;
				addChildAt(video_list[selectedPic], getChildIndex(viewport) + 1);
				addChildAt(vid_time, getChildIndex(viewport) + 1);

				Tweener.addTween(video_list[selectedPic], {alpha: 1, time: 1});
				Tweener.addTween(vid_time, {alpha: 1, time: 1});

			}
		}

		private function hideVideo():void {
			if(video_list[selectedPic] != null) {
				removeChild(video_list[selectedPic]);
				video_list[selectedPic].y = 1200;

				removeChild(vid_time);
			}
		}

		private function playVideo():void {
			if(video_list[selectedPic] != null) {
				video_list[selectedPic].video.play();
				Tweener.addTween(video_list[selectedPic].graphic_play, {alpha: 0, time: 1});
				Tweener.addTween(video_list[selectedPic].graphic_videoblack, {alpha: 0, time: 1});

				addEventListener(Event.ENTER_FRAME, updateTime);
			}
		}

		private function pauseVideo():void {
			if(video_list[selectedPic] != null) {
				video_list[selectedPic].video.pause();
				Tweener.addTween(video_list[selectedPic].graphic_play, {alpha: 1, time: 1});
				Tweener.addTween(video_list[selectedPic].graphic_videoblack, {alpha: 0.5, time: 1});

				removeEventListener(Event.ENTER_FRAME, updateTime);
			}
		}

		private function stopVideo():void {
			if(video_list[selectedPic] != null) {
				vidPlaying = false;
				video_list[selectedPic].video.stop();
				video_list[selectedPic].graphic_play.alpha = video_list[selectedPic].graphic_videoblack.alpha = 1;
			}
		}

		function convertToHHMMSS($seconds:Number):String {
		    var s:Number = $seconds % 60;
		    var m:Number = Math.floor(($seconds % 3600 ) / 60);
		    var h:Number = Math.floor($seconds / (60 * 60));
		     
		    var hourStr:String = (h == 0) ? "" : doubleDigitFormat(h) + ":";
		    var minuteStr:String = doubleDigitFormat(m) + ":";
		    var secondsStr:String = doubleDigitFormat(s);
		     
		    return hourStr + minuteStr + secondsStr;
		}
		 
		function doubleDigitFormat($num:uint):String {
		    if ($num < 10) 
		    {
		        return ("0" + $num);
		    }
		    return String($num);
		}

		public function info_dwn(e:gl.events.TouchEvent):void {

		}

		public function info_up(e:gl.events.TouchEvent):void {
			window_credits.alpha = 0;
			window_credits.scaleX = window_credits.scaleY = 0.8;
			addChild(window_credits);

			Tweener.addTween(window_credits, {scaleX: 1, scaleY: 1, time: 1, transition: "easeOutElastic"});
			Tweener.addTween(window_credits, {alpha: 1, time: 1});

			addChild(cont_blocker);
			cont_blocker.addEventListener(gl.events.TouchEvent.TOUCH_UP, exit_info);
		}

		private function exit_info(e:gl.events.TouchEvent):void {
			cont_blocker.removeEventListener(gl.events.TouchEvent.TOUCH_UP, exit_info);
			Tweener.addTween(window_credits, {alpha: 0, scaleX: 0.8, scaleY: 0.8, time: 1, onComplete: function() {
				removeChild(window_credits);
			}});

			Tweener.addTween(this, {delay: 1, onComplete: function(){ 
				removeChild(cont_blocker); 
			}});
		}

		function xmlLoaded(e:Event):void
		{
			/*var thumbSize: int = 200;
			var thumbGap: int = 20;*/

			metadata_xml = XML(e.target.data);

		    //read settings from xml
		    mouseOrTouch = metadata_xml.input;
			
			//numTiles = metadata_xml.Content.Work.length();
			
			/*for( i = 0; i < numTiles; i++ )
			{
		        var index;
		        if( i+1 > numImg )
		            index = i - numImg;
		        else
		            index = i;

				var bfm:BitmapFileMaterial = new BitmapFileMaterial(metadata_xml.Content.Work[index].thumburl);

				//prep videos
				var vid_name:String = metadata_xml.Content.Work[index].video;
				if(vid_name == "none") {
					video_list.push(null);
				} else {
					video_list.push(this[vid_name]);
				}
				
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
				
				pa.push({pl:p, rotY:Math.random() * 360, rotZ:Math.random() * 360, z:Math.random() * 1500 + 500});
				p.rotationY = pa[i].rotY;
				p.rotationZ = pa[i].rotZ;
				p.x = i % 5 * ( thumbSize + thumbGap + 60 );
				p.y = Math.floor(i / 5) * ( thumbSize + thumbGap );
				p.z = pa[i].z;
			}*///for

		}//create thumbnail

		private function thumbDwn(e:gl.events.TouchEvent):void {
			//e.target.startTouchDrag(0);
			trace("down");
			//TODO: block other thumbs
		}

		private function thumbUp(e:gl.events.TouchEvent):void {
			//e.target.stopTouchDrag(0);
			trace("up");
			//TODO: if only clicked and NOT dragged

			playSound("audio/select.mp3");
			Tweener.addTween(e.target.getChildAt(0), {scaleX: 2, scaleY: 2, time: 1, onComplete: function() { e.target.getChildAt(0).scaleX = 1; e.target.getChildAt(0).scaleY = 1; }} );

			//Fade out thumbnails
			for (var i:int = 0; i < thumblist.length; i++) {
				Tweener.addTween(thumblist[i], {alpha: 0, time: 1, onComplete: function() { /*removeChild(thumblist[i]);*/ }});
			}
			Tweener.addTween(button_info, {delay: 1, onComplete: function(){ button_info.gotoAndStop("wooden"); button_info.visible = true; }})

			var s_no:Number = parseInt(e.target.name); //this is the ID of the work (based on order of 1-25 on website)
			fileRequest = new URLRequest(metadata_xml.Content.Work[s_no].url);
			selectedPic = s_no;

			if(video_list[selectedPic] != null) {
				video_list[selectedPic].video.stop();
			}

			Tweener.addTween(this, {delay: 1, onComplete: function() {
				createPuzzle();
			}});

			blockerOn();
			Tweener.addTween(this, {delay: 6, onComplete: blockerOff});
		}

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
			playSound("audio/select.mp3");

			var sp:Sprite = me.target as Sprite;

			Tweener.addTween(container, {scaleX: 3, scaleY: 3, alpha: 0, time: 1, delay: 0.2, onComplete: function() {
				container.scaleX = container.scaleY = container.alpha = 1;
				removeChild(container);
			}});
			Tweener.addTween(button_info, {alpha: 0, time: 1, onComplete: function(){ button_info.gotoAndStop("wooden"); button_info.visible = true; }})

			var s_no:Number = parseInt(sp.name.slice(8,10)); //this is the ID of the work (based on order of 1-25 on website)

			fileRequest = new URLRequest(metadata_xml.Content.Work[s_no].url);
			selectedPic = s_no;

			if(video_list[selectedPic] != null) {
				video_list[selectedPic].video.stop();
			}

			Tweener.addTween(this, {delay: 1, onComplete: function() {
				createPuzzle();
			}});

			blockerOn();
			Tweener.addTween(this, {delay: 6, onComplete: blockerOff});
		}

		function timerHandler(e:TimerEvent):void
	    {
	    	timer.removeEventListener(TimerEvent.TIMER_COMPLETE,timerHandler);
	    	gotoAndStop(2);
	    }

		/**
		 * check if the mouse is close to the image, if so, show the img
		 */
		/*function check_distance(p:org.papervision3d.objects.Plane):Boolean
		{
			var p1:Point = new Point(p.x, p.y);
			var p2:Point = new Point(container.mouseX + 150, -container.mouseY + 80);
			
			if( Point.distance(p1, p2) < 250 )
			{
				return true;
			}
			else return false;
		}*/

		function showBackBtn(): void
		{
		    addChildAt(cont_home, getChildIndex(bg_woodtexture) + 1);
		    backBtn.alpha = 0;
		    backBtn.visible = true;
			Tweener.addTween( backBtn, { alpha: 1, delay: 1, time: 1 } );
			cont_home.addEventListener(gl.events.TouchEvent.TOUCH_DOWN, home_dwn);
		    cont_home.addEventListener(gl.events.TouchEvent.TOUCH_UP, home_up);
		}

		function hideBackBtn():void
		{
			Tweener.addTween( backBtn, { y: stage.stageHeight, time: 1 } );
			cont_home.removeEventListener(gl.events.TouchEvent.TOUCH_DOWN, home_dwn );
			cont_home.removeEventListener(gl.events.TouchEvent.TOUCH_UP, home_up );
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
				imgLoader.load( fileRequest );		//3D card image
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

				//center the img
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
		        loadPuzzlePieces( this[puzzleStr + pieceNum], pieceNum );
		    }

		    //wood texture
		    bg_woodtexture.visible = true;
			bg_woodtexture.scaleX = bg_woodtexture.scaleY = 0.7;
			bg_woodtexture.alpha = 0;
			addChild(bg_woodtexture);
			addChild(cont_blocker);
			Tweener.addTween(bg_woodtexture, {scaleX: 1, scaleY: 1, alpha: 1, delay: 0.4, time: 3});

			//frame ADD THIS TO bg_woodtexture
		    bg_woodtexture.addChild(this[frameStr]);
		    this[frameStr].width = effect_glow.width = fullImg.width*1.02;
		    this[frameStr].height = effect_glow.height = fullImg.height*1.02;
		    this[frameStr].x = xpos - stage.stageWidth/2;
		    this[frameStr].y = ypos - stage.stageHeight/2;

		    //place flipme
		    //graphic_flipme.x = xpos + this[frameStr].width + 135;
		}//setUpPuzzle

		/**
		 * load individual piece
		 * call scramble() when last piece is loaded
		 */
		function loadPuzzlePieces(msk:MovieClip, pieceNum:int):void
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
					//img.addEventListener( TouchEvent.TOUCH_BEGIN, onTouch );
					//img.addEventListener( TouchEvent.TOUCH_END,   onTouch );
				}

				//Make container draggable
				/*puzList[pieceNum].addChild(img);
				addChild(puzList[pieceNum]);*/
				//TODO: finish placing in container

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
				imgLoader.filters = [dropShdw];
				addChild( img );
				addChild(cont_blocker);

				numLoaded++;
				//trace("numLoaded: " + numLoaded);

				if( numLoaded == numPieces )
				{
					//trace("imgArr after numLoaded complete:" + imgArr);
					// loading images cause lags, so delay for smoother animation
					var delayTimer:Timer = new Timer( 1500, 1 );
					delayTimer.addEventListener( TimerEvent.TIMER_COMPLETE, function() {
					    addChildAt(cont_home, getChildIndex(bg_woodtexture) + 1);
					    showBackBtn();
		                scramble();
					    addChildAt(cont_info, getChildIndex(bg_woodtexture) + 1);
					    Tweener.addTween(button_info, {alpha: 1, time: 1, delay: 1});
					});
					delayTimer.start();
				}
			}//loadPuzRdy
		}

		/* SCRAMBLE PUZZLE */
		function scramble(): void
		{
			for(j = 0; j < numPieces; j++)
			{
				//Math.floor(Math.random()*(1+High-Low))+Low. High was stageWidth - 1200 and stageHeight - 1000 
				var randoX:int = Math.floor(Math.random() * (1 + (stage.stageWidth - 900) - -200)) + -200;
				var randoY:int = Math.floor(Math.random() * (1 + (stage.stageHeight - 800) - -200)) + -200;
				
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
		function onTouch( e:flash.events.TouchEvent ):void
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
				//imgArr[piece].removeEventListener( TouchEvent.TOUCH_BEGIN, onTouch );
				//imgArr[piece].removeEventListener( TouchEvent.TOUCH_END,   onTouch );

		        //imgArr[piece].imgLoader.filters = [];
		        imgArr[piece].getChildAt(0).filters = [];
				imgArr[piece].filters = [];
		        numDone++;

		        if( numDone >= numPieces ) { //puzzle finished
		            addChildAt(effect_glow, numChildren - 1);
		            Tweener.addTween(this, {delay: 0.8, onComplete: function() {
		            	playSound("audio/success.mp3");
		            	effect_glow.gotoAndPlay("play");
		            }});

		            Tweener.addTween(this, {delay: 1, onComplete: function() {
		            	puzzleComplete();
		            }});

		            Tweener.addTween(this, {delay: 2, onComplete: function(){ removeChild(effect_glow); }});
		        }
		        else 
				{ //puzzle not finished yet
		            playSound("audio/tock.mp3");
		        }
		    } //if close enough
		}

		function puzzleComplete():void
		{	
			finishedPuzzle = true;

		    var k;
		    for( k=0; k<numPieces; k++ ) {
		        removeChild(imgArr[k]);
		    }

		    
		    graphic_flipme.visible = true;
		    Tweener.addTween(graphic_flipme, {alpha: 1, time: 0.5});
		    viewport.alpha = 1;		    
		    addChildAt(viewport, getChildIndex(bg_woodtexture) + 1);
		    addChildAt(graphic_flipme, getChildIndex(viewport) + 1);
		}	

		/* PLAY SOUND */
		function playSound(file:String): void 
		{
			var sound:Sound=new Sound();
			sound.load(new URLRequest(file));
			sound.play();
		}

		/* RETURN TO MAIN TILE INTERFACE */
		function home_dwn(e:gl.events.TouchEvent):void
		{

		}

		function home_up(e:gl.events.TouchEvent):void
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

				if(video_list[selectedPic] != null && !cardFacingFront) {
					stopVideo();
					hideVideo();
				} 
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

						trace(imgArr[k]);
						Tweener.addTween( imgArr[k], { x: randoX, y: randoY, time: 1, delay: k*0.1, onComplete: function(){ /*imgArr[k].dispose(); imgArr[k] = null;*/ }} );

						//TODO: Figure out how to free up memory properly
					}
				}
			}

			imgArr.splice(0);

			//remove bg and back
			Tweener.addTween(bg_woodtexture, {scaleX: 0.7, scaleY: 0.7, alpha: 0, time: 2, delay: 1.1, onComplete: function(){ removeChild(bg_woodtexture); }});
			Tweener.addTween(backBtn, {alpha: 0, time: 1, onComplete: function() { removeChild(cont_home); }})
			Tweener.addTween(button_info, {alpha: 0, time: 1, onComplete: function() { /*button_info.gotoAndStop("white");*/ button_info.visible = false; } });
			//Tweener.addTween(button_info, {alpha: 1, time: 1, delay: 3.5});
			Tweener.addTween(graphic_flipme, {alpha: 0, time: 1, onComplete: function() { graphic_flipme.visible = false; }});
			
			//scale back thumbs
			/*container.scaleX = container.scaleY = 3;
			container.alpha = 0;
			addChild(container);
			Tweener.addTween(container, {scaleX: 1, scaleY: 1, alpha: 1, time: 1, delay: 2 });*/

			//Show thumbs
			for (var i:int = 0; i < thumblist.length; i++) {
				addChild(thumblist[i]);
				Tweener.addTween(thumblist[i], {alpha: 1, time: 1, delay: 2});
			}

			//reset
			if(video_list[selectedPic] == null) {
				myCard.removeChild(imgThumb);
			}
			numLoaded = 0;
			fileRequest = null;
			fullImg = null;
			front_plane = null;
			back_plane = null;
			cardFacingFront = true;
			finishedPuzzle = false;
			Tweener.addTween(this, {delay: 1, onComplete: function() { 
				sceneCard.removeChild(imgCard);
				imgCard = new org.papervision3d2.objects.DisplayObject3D();
			}});

			//TODO: reset TouchSprite puzzle piece containers

			fullImg = new MovieClip();
			fullImgLoader = null;
			fullImgLoader = new Loader();
			imgThumb = new Loader();

			blockerOn();
			Tweener.addTween(this, {delay: 3.5, onComplete: blockerOff});
		}

		public function blockerOn():void {
			//trace("blocker ON");
			addChild(cont_blocker);
			setChildIndex(cont_blocker, numChildren - 1);
		}

		public function blockerOff():void {
			removeChild(cont_blocker);
		}
	}
}