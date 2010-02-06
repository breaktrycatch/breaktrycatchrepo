package com.breaktrycatch.needmorehumans.utils;

import org.jbox2d.common.Vec2;

public class PhysicsUtils {
	
	public static Vec2 genericTransform(Vec2 vect, float scale, Vec2 offset, Vec2 axisTransform, boolean affectVect)
	{
		Vec2 result = (affectVect) ? vect : vect.clone(); 
		result.subLocal(offset).mulLocal(scale);
		result.x *= axisTransform.x;
		result.y *= axisTransform.y;
		
		return result;
	}
	
}
