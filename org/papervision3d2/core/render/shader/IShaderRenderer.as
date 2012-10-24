package org.papervision3d2.core.render.shader
{
	import flash.display.Sprite;
	
	import org.papervision3d2.core.render.data.RenderSessionData;
	import org.papervision3d2.materials.shaders.Shader;
	
	public interface IShaderRenderer
	{
		function render(renderSessionData:RenderSessionData):void;
		function clear():void;
		function getLayerForShader(shader:Shader):Sprite;
		function destroy():void;
	}
}