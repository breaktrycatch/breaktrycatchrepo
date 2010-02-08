package com.breaktrycatch.needmorehumans.tracing.callback;

import com.breaktrycatch.needmorehumans.model.BodyVO;

public interface IThreadedImageAnalysisCallback
{
	public void execute(BodyVO analyzedBody);
}
