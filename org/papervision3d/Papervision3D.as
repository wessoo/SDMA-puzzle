﻿// _______________________________________________________________________ PAPERVISION3D

package org.papervision3d
{
	import org.papervision3d.core.culling.DefaultTriangleCuller;
	import org.papervision3d.core.culling.ITriangleCuller;

	

/**
* The Papervision3D class contains global properties and settings.
*/
public class Papervision3D
{
	// ___________________________________________________________________ SETTINGS

	/**
	* Indicates if the angles are expressed in degrees (true) or radians (false). The default value is true, degrees.
	*/
	static public var useDEGREES  :Boolean = true;

	/**
	* Indicates if the scales are expressed in percent (true) or from zero to one (false). The default value is false, i.e. units.
	*/
	static public var usePERCENT  :Boolean = false;


	// ___________________________________________________________________ STATIC

	/**
	* Enables engine name to be retrieved at runtime or when reviewing a decompiled swf.
	*/
	static public var NAME     :String = 'Papervision3D';

	/**
	* Enables version to be retrieved at runtime or when reviewing a decompiled swf.
	*/
	static public var VERSION  :String = 'Beta RC1.1';

	/**
	* Enables version date to be retrieved at runtime or when reviewing a decompiled swf.
	*/
	static public var DATE     :String = '18.06.07';

	/**
	* Enables copyright information to be retrieved at runtime or when reviewing a decompiled swf.
	*/
	static public var AUTHOR   :String = '(c) 2006-2007 Copyright by Carlos Ulloa | papervision3d.org | carlos@papervision3d.org';

	/**
	* Determines whether debug printout is enabled. It also prints version information at startup.
	*/
	static public var VERBOSE  :Boolean = true;
	
	// ___________________________________________________________________ LOG

	/**
	* Sends debug information to the Output panel.
	*
	* @param	message		A String value to send to Output.
	*/
	static public function log( message :String ):void
	{
		if( Papervision3D.VERBOSE )
			trace( message );
	}
}
}