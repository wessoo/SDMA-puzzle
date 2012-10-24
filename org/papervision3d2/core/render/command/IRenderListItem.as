package org.papervision3d2.core.render.command
{
	
	/**
	 * @Author Ralph Hauwert
	 */
	 
	import flash.display.Graphics;
	
	import org.papervision3d2.core.render.data.RenderSessionData;
	
	public interface IRenderListItem
	{
		function render(renderSessionData:RenderSessionData, graphics:Graphics):void;
	}
}