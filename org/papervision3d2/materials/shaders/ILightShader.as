package org.papervision3d2.materials.shaders
{
	import org.papervision3d2.core.render.data.RenderSessionData;
	import org.papervision3d2.core.render.shader.ShaderObjectData;
	
	public interface ILightShader
	{
		function updateLightMatrix(sod:ShaderObjectData,renderSessionData:RenderSessionData):void;
	}
}