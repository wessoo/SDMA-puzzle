package org.papervision3d2.objects.special.commands {	import org.papervision3d2.objects.special.commands.IVectorShape;	import flash.display.Graphics;			/**	 * @author Mark Barcinski	 */	public class BeginFill implements IVectorShape {		public var fillColor:uint;		public var fillAlpha:Number;					public function BeginFill(fillColor:uint = 0x000000, fillAlpha:Number = 1):void		{			this.fillColor = fillColor;			this.fillAlpha = fillAlpha;		}		public function draw(graphics : Graphics , prevDrawn : Boolean) : Boolean {			graphics.beginFill(fillColor , fillAlpha);						return true;		}	}}