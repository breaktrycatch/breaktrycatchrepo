package com.breaktrycatch.needmorehumans.util.math.kernels;

public class Kernel
{
	/** Calculates the inner product of the given vectors. */
	public double innerProduct(double[] x1, double[] x2)
	{
		double result = 0.0d;
		for (int i = 0; i < x1.length; i++)
		{
			result += x1[i] * x2[i];
		}
		return result;
	}

	/** Calculates the L2-norm, i.e. ||x-y||^2. */
	public double norm2(double[] x1, double[] x2)
	{
		double result = 0;
		for (int i = 0; i < x1.length; i++)
		{
			double factor = x1[i] - x2[i];
			result += factor * factor;
		}
		return result;
	}
}
