package org.papervision3d2.objects.special.commands {	import org.papervision3d2.objects.special.commands.IVectorShape;	import flash.display.Graphics;			/**	 * @author Mark Barcinski	 */	public class EndFill implements IVectorShape {		public function draw(graphics : Graphics, prevDrawn : Boolean) : Boolean {			return prevDrawn;		}	}}