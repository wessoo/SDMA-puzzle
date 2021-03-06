package org.papervision3d2.core.view
{
	import org.papervision3d2.core.render.data.RenderSessionData;
	
	/**
	 * @Author Ralph Hauwert
	 */
	public interface IViewport3D
	{
		function updateBeforeRender(renderSessionData:RenderSessionData):void;
		function updateAfterRender(renderSessionData:RenderSessionData):void;
	}
}