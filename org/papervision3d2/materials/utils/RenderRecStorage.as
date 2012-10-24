package org.papervision3d2.materials.utils
{
	import flash.geom.Matrix;
	
	import org.papervision3d2.core.geom.renderables.Vertex3DInstance;
	
	public class RenderRecStorage
	{
		public var v0:Vertex3DInstance = new Vertex3DInstance();
		public var v1:Vertex3DInstance = new Vertex3DInstance();
		public var v2:Vertex3DInstance = new Vertex3DInstance();
		public var mat:Matrix = new Matrix();
		
		public function RenderRecStorage()
		{
			
		}

	}
}