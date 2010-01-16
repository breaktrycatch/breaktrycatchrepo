package com.breaktrycatch.needmorehumans.util.math.kernels;

public class TruncatedNormalKernel extends Kernel
{
	/** Constant */
	private static double CO = Math.sqrt(2 * Math.PI);

	public double normalKernel(double x)
	{
		return Math.exp(-(x * x) / 2) / CO;
	}
	
	public double truncatedNormalKernel(double x)
	{
		double expression = normalKernel(x);
		return expression > 1 ? 0.0d : expression;
	}
	
}
