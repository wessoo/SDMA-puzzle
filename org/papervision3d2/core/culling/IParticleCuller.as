package org.papervision3d2.core.culling
{
	import org.papervision3d2.core.geom.renderables.Particle;
	
	public interface IParticleCuller
	{
		function testParticle(particle:Particle):Boolean;
	}
}