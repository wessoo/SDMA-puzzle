package org.papervision3d2.render {
	import org.papervision3d2.core.proto.CameraObject3D;
	import org.papervision3d2.core.render.IRenderEngine;
	import org.papervision3d2.core.render.data.RenderStatistics;
	import org.papervision3d2.scenes.Scene3D;
	import org.papervision3d2.view.Viewport3D;	

	/**
	 * @Author Ralph Hauwert
	 */
	public class LazyRenderEngine extends BasicRenderEngine implements IRenderEngine
	{
		
		protected var _camera:CameraObject3D;
		protected var _scene:Scene3D;
		protected var _viewport:Viewport3D;
		
		public function LazyRenderEngine(scene:Scene3D, camera:CameraObject3D, viewport:Viewport3D)
		{
			super();
			this.scene = scene;
			this.camera = camera;
			this.viewport = viewport;
		}
		
		public function render():RenderStatistics
		{
			return renderScene(scene,camera,viewport);	
		}
		
		public function set camera(camera:CameraObject3D):void
		{
			_camera = camera;
		}
		
		public function get camera():CameraObject3D
		{
			return _camera;	
		}
		
		public function set scene(scene:Scene3D):void
		{
			_scene = scene;		
		}
		
		public function get scene():Scene3D
		{
			return _scene;
		}
		
		public function set viewport(viewport:Viewport3D):void
		{
			_viewport = viewport;
		}
		
		public function get viewport():Viewport3D
		{
			return _viewport;
		}
	
	}
}