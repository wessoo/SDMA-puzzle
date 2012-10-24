package org.papervision3d2.core.geom.renderables
{
	/**
	 * @Author Ralph Hauwert
	 */
	 
	import org.papervision3d2.core.render.command.IRenderListItem;
	
	public interface IRenderable
	{
		function getRenderListItem():IRenderListItem;
	}
}