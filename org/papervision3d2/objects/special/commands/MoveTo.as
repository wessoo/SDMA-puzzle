package org.papervision3d2.objects.special.commands {	import flash.display.Graphics;			import org.papervision3d2.core.geom.renderables.Vertex3D;			/**	 * @author Mark Barcinski	 */	public class MoveTo implements IVectorShape{		public var vertex : Vertex3D;		public function MoveTo(vertex : Vertex3D) {			this.vertex = vertex;			}		public function draw(graphics : Graphics , prevDrawn : Boolean) : Boolean {			if(vertex.vertex3DInstance.visible){				graphics.moveTo(vertex.vertex3DInstance.x , vertex.vertex3DInstance.y);								return true;				}						return false;		}	}}