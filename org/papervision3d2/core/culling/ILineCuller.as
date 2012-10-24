package org.papervision3d2.core.culling 
{
	import org.papervision3d2.core.geom.renderables.Line3D;	

	/**
	 * @author Seb Lee-Delisle
	 */
	
	public interface ILineCuller
	{
		function testLine(line : Line3D) : Boolean;
	}
}