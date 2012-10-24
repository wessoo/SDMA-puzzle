package org.papervision3d2.core.render.draw
{
	
	/**
	 * @Author Ralph Hauwert
	 */
	 
	import flash.display.Graphics;
	
	import org.papervision3d2.core.render.command.RenderLine;
	import org.papervision3d2.core.render.data.RenderSessionData;
	
	public interface ILineDrawer
	{
		function drawLine(line:RenderLine, graphics:Graphics, renderSessionData:RenderSessionData):void;
	}
}