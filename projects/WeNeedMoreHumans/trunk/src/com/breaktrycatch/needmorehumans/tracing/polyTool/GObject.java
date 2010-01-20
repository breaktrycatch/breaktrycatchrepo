package com.breaktrycatch.needmorehumans.tracing.polyTool;

import com.breaktrycatch.needmorehumans.tracing.PixelVO;

public class GObject implements Comparable<GObject> {
	
	public PixelVO point;
	public float cotangent;
	
	public GObject(PixelVO _point, float _cotangent)  {
		// TODO Auto-generated constructor stub
		point = _point;
		cotangent = _cotangent;
	}

	@Override
	public int compareTo(GObject arg0) {
		return (int)(cotangent - arg0.cotangent);
	}

}
