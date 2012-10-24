package org.papervision3d2.materials
{
	import org.papervision3d2.core.render.draw.ITriangleDrawer;
	import org.papervision3d2.view.BitmapViewport3D;

	public class BitmapViewportMaterial extends BitmapMaterial implements ITriangleDrawer
	{
		public function BitmapViewportMaterial(bitmapViewport:BitmapViewport3D, precise:Boolean=false)
		{
			super(bitmapViewport.bitmapData, precise);
		}
		
	}
}