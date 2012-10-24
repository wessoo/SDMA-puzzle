package org.papervision3d2.core.render.filter
{
	import org.papervision3d2.cameras.Camera3D;
	import org.papervision3d2.core.clipping.draw.Clipping;
	import org.papervision3d2.core.render.data.QuadTree;
	import org.papervision3d2.scenes.Scene3D;
	
	public class AbstractQuadrantFilter
	{
		public function AbstractQuadrantFilter()
		{
		}
		/**
		 * Runs a quadrant filter
		 */
		 public function filterTree(tree:QuadTree, scene:Scene3D, camera:Camera3D, clip:Clipping):void{
		 	
		 }

	}
}