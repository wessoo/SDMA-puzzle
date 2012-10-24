package org.papervision3d2.core.render.command {
	import org.papervision3d2.core.geom.renderables.AbstractRenderable;
	import org.papervision3d2.core.render.data.RenderSessionData;
	import org.papervision3d2.materials.special.FogMaterial;
	import org.papervision3d2.objects.DisplayObject3D;
	
	import flash.display.Graphics;	

	public class RenderFog extends RenderableListItem
	{

		public var alpha:Number;
		public var material:FogMaterial;
		
		public function RenderFog(material:FogMaterial, alpha:Number = 0.5, depth:Number=0, do3d:DisplayObject3D = null)
		{
			super();
			this.alpha= alpha;
			this.screenZ = depth;
			this.material = material;
			if(do3d){
				this.renderableInstance = new AbstractRenderable();
				this.renderableInstance.instance = do3d;
			}				
		}
		
		public override function render(renderSessionData:RenderSessionData, graphics:Graphics):void{
			
			material.draw(renderSessionData, graphics, alpha);
			
		}
		
	}
}