package org.papervision3d2.core.culling
{
	import org.papervision3d2.core.geom.renderables.Particle;

	public class DefaultParticleCuller implements IParticleCuller
	{
		
		public function DefaultParticleCuller()
		{
			
		}
		
		public function testParticle(particle:Particle):Boolean
		{
			if(particle.material.invisible == false){
				if(particle.vertex3D.vertex3DInstance.visible == true){
					return true;
				}
			}
			return false;
		}
		
	}
}