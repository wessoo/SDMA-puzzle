package org.papervision3d2.core.render.project.basic
{
	import org.papervision3d2.core.render.data.RenderSessionData;
	
	public interface IProjector
	{
		function project(renderSessionData:RenderSessionData):void;
	}
}