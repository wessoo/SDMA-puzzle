package org.papervision3d2.core.render.draw
{
	
	/**
	 * @Author Ralph Hauwert
	 */
	 
	import flash.display.Graphics;
	
	import org.papervision3d2.core.geom.renderables.Particle;
	import org.papervision3d2.core.render.data.RenderSessionData;
	
	public interface IParticleDrawer
	{
		function drawParticle(particle:Particle, graphics:Graphics, renderSessionData:RenderSessionData):void;
		function updateRenderRect(particle:Particle):void;  

	}
}