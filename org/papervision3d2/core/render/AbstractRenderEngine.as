package org.papervision3d2.core.render
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import org.papervision3d2.core.proto.CameraObject3D;
	import org.papervision3d2.core.proto.SceneObject3D;
	import org.papervision3d2.core.render.command.IRenderListItem;
	import org.papervision3d2.core.render.command.RenderableListItem;
	import org.papervision3d2.core.render.data.RenderStatistics;
	import org.papervision3d2.view.Viewport3D;

	public class AbstractRenderEngine extends EventDispatcher implements IRenderEngine
	{
		public function AbstractRenderEngine(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		public function renderScene(scene:SceneObject3D, camera:CameraObject3D, viewPort:Viewport3D):RenderStatistics
		{
			return null;
		}
		
		public function addToRenderList(renderCommand:RenderableListItem):int
		{
			return 0;
		}
		
		public function removeFromRenderList(renderCommand:IRenderListItem):int
		{
			return 0;
		}
		
	}
}