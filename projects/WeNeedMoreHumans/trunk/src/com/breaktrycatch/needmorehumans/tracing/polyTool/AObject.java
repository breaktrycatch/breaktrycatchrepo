package com.breaktrycatch.needmorehumans.tracing.polyTool;

public class AObject implements Comparable<AObject> {

	
	public float f;
	
	public AObject(float _f) {
		f = _f;
	}
	
	@Override
	public int compareTo(AObject arg0) {
		if(f>arg0.f)
			return 1;
		else if(arg0.f>f)
			return -1;
		else
			return 0;
	}

}
