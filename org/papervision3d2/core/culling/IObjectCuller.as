package org.papervision3d2.core.culling 
{
	import org.papervision3d2.objects.DisplayObject3D;
	
	/**
	 * @author Tim Knip 
	 */
	public interface IObjectCuller 
	{
		function testObject( object:DisplayObject3D ):int;
	}	
}
