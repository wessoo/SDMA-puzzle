package org.papervision3d2.core.render.material
{
	import org.papervision3d2.core.render.data.RenderSessionData;
	
	public interface IUpdateAfterMaterial
	{
		function updateAfterRender(renderSessionData:RenderSessionData):void;
	}
}