package com.breaktrycatch.needmorehumans.utils;

import java.awt.Color;
import java.awt.Rectangle;
import java.util.ArrayList;

import processing.core.PApplet;
import processing.core.PImage;

public class ImageUtils
{
	public static PImage cloneImage(PImage target)
	{
		PImage cloned = null;
		try
		{
			cloned = (PImage) target.clone();
		} catch (CloneNotSupportedException e)
		{
			e.printStackTrace();
		}
		return cloned;

	}

	public static Color averageColor(PImage target)
	{
		return averageColor(target, new Rectangle(0, 0, target.width, target.height));
	}

	public static Color averageColor(PImage target, Rectangle rect)
	{
		int sumR = 0;
		int sumG = 0;
		int sumB = 0;
		for (int y = rect.y; y < rect.y + rect.height; y++)
		{
			for (int x = rect.x; x < rect.x + rect.width; x++)
			{
				int col = target.pixels[y + target.width + x];
				int r = (col >> 16) & 0xFF;
				int g = (col >> 8) & 0xFF;
				int b = col & 0xFF;

				sumR += r;
				sumG += g;
				sumB += b;
			}
		}

		int area = rect.width * rect.height;
		return new Color(sumR / area, sumG / area, sumB / area);
	}

	public static double luminosityVariance(PImage target, Rectangle rect)
	{
		float sum = 0;

		double low = 1;
		double high = 0;

		for (int y = rect.y; y < rect.y + rect.height; y++)
		{
			for (int x = rect.x; x < rect.x + rect.width; x++)
			{
				int col = target.pixels[y * target.width + x];

				float[] HSL = new float[3];
				ImageUtils.RGBtoHSL((col >> 16) & 0xFF, (col >> 8) & 0xFF, col & 0xFF, HSL);
				sum += Math.pow(HSL[2], 2);

				if (HSL[2] > high)
				{
					high = HSL[2];
				}
				if (HSL[2] < low)
				{
					low = HSL[2];
				}
			}
		}

		int area = rect.width * rect.height;
		double mean = sum / area;
		double varSum = 0;
		for (int y = rect.y; y < rect.y + rect.height; y++)
		{
			for (int x = rect.x; x < rect.x + rect.width; x++)
			{
				int col = target.pixels[y * target.width + x];
				float[] HSL = new float[3];
				ImageUtils.RGBtoHSL((col >> 16) & 0xFF, (col >> 8) & 0xFF, col & 0xFF, HSL);

				varSum += Math.pow(HSL[2] - mean, 2);
			}
		}

		double variance = varSum / area;

		// PApplet.println("Variance: " + variance + " : DIFF: " + (high -
		// low));

		return variance;// high - low;
	}

	public static void averageImages(PImage target, ArrayList<PImage> images)
	{
		// float totalStdDevR = 0;
		// float totalStdDevG = 0;
		// float totalStdDevB = 0;

		int numPixels = target.pixels.length;
		int numBackgrounds = images.size();
		for (int i = 0; i < numPixels; i++)
		{
			int sumR = 0;
			int sumG = 0;
			int sumB = 0;

			for (PImage background : images)
			{
				int col = background.pixels[i];
				int r = (col >> 16) & 0xFF;
				int g = (col >> 8) & 0xFF;
				int b = col & 0xFF;

				sumR += r;
				sumG += g;
				sumB += b;
			}

			sumR /= numBackgrounds;
			sumG /= numBackgrounds;
			sumB /= numBackgrounds;

			// float rDevSum = 0;
			// float gDevSum = 0;
			// float bDevSum = 0;
			//
			// for (PImage background : images)
			// {
			// int col = background.pixels[i];
			// int r = (col >> 16) & 0xFF;
			// int g = (col >> 8) & 0xFF;
			// int b = col & 0xFF;
			//
			// rDevSum += Math.pow((float)r - (float)sumR, 2);
			// gDevSum += Math.pow((float)g - (float)sumG, 2);
			// bDevSum += Math.pow((float)b - (float)sumB, 2);
			// }
			//
			//
			// totalStdDevR += (sumR > 0) ? (Math.sqrt(rDevSum / sumR)) : (0);
			// totalStdDevG += (sumG > 0) ? (Math.sqrt(gDevSum / sumG)) : (0);
			// totalStdDevB += (sumB > 0) ? (Math.sqrt(bDevSum / sumB)) : (0);
			//			
			// PApplet.println("R: " +totalStdDevR);

			target.pixels[i] = (255 << 24 | sumR << 16 | sumG << 8 | sumB);
		}

		// float avgStdDevR = totalStdDevR / (float)numPixels;
		// float avgStdDevG = totalStdDevG / numPixels;
		// float avgStdDevB = totalStdDevB / numPixels;
		//
		// PApplet.println("R: " + totalStdDevR + " G: " + totalStdDevG + " B: "
		// + totalStdDevB);
		// PApplet.println("R: " + avgStdDevR * avgStdDevR + " G: " + avgStdDevG
		// + " B: " + avgStdDevB);
	}

	public static void RGBtoHSL(int r, int g, int b, float hsl[])
	{
		float var_R = (r / 255f);
		float var_G = (g / 255f);
		float var_B = (b / 255f);

		float var_Min; // Min. value of RGB
		float var_Max; // Max. value of RGB
		float del_Max; // Delta RGB value

		if (var_R > var_G)
		{
			var_Min = var_G;
			var_Max = var_R;
		} else
		{
			var_Min = var_R;
			var_Max = var_G;
		}

		if (var_B > var_Max)
			var_Max = var_B;
		if (var_B < var_Min)
			var_Min = var_B;

		del_Max = var_Max - var_Min;

		float H = 0, S, L;
		L = (var_Max + var_Min) / 2f;

		if (del_Max == 0)
		{
			H = 0;
			S = 0;
		} // gray
		else
		{ // Chroma
			if (L < 0.5)
				S = del_Max / (var_Max + var_Min);
			else
				S = del_Max / (2 - var_Max - var_Min);

			float del_R = (((var_Max - var_R) / 6f) + (del_Max / 2f)) / del_Max;
			float del_G = (((var_Max - var_G) / 6f) + (del_Max / 2f)) / del_Max;
			float del_B = (((var_Max - var_B) / 6f) + (del_Max / 2f)) / del_Max;

			if (var_R == var_Max)
				H = del_B - del_G;
			else if (var_G == var_Max)
				H = (1 / 3f) + del_R - del_B;
			else if (var_B == var_Max)
				H = (2 / 3f) + del_G - del_R;
			if (H < 0)
				H += 1;
			if (H > 1)
				H -= 1;
		}

		hsl[0] = H;
		hsl[1] = S;
		hsl[2] = L;
	}

	public static void tint(PImage masked, int tint, float amt)
	{
		int rt = (tint >> 16) & 0xFF;
		int gt = (tint >> 8) & 0xFF;
		int bt = tint & 0xFF;
		int numPixels = masked.pixels.length;
		for (int i = 0; i < numPixels; i++)
		{
			int col = masked.pixels[i];
			int a = (col >> 24) & 0xFF;
			int r = (col >> 16) & 0xFF;
			int g = (col >> 8) & 0xFF;
			int b = col & 0xFF;
			
			r = (int)(r * (amt - 1) + rt * (amt));
			g = (int)(g * (amt - 1) + gt * (amt));
			b = (int)(b * (amt - 1) + bt * (amt));
			
			masked.pixels[i] = (a << 24 | r << 16 | g << 8 | b);
		}
	}
	
	public static PImage trimTransparency(PImage source)
	{
		// treat the w and h of the rect as the far right left/right points.
		Rectangle clipRect = new Rectangle(source.width, source.height, 0, 0);
		int i = 0;
		for (int y = 0; y < source.height; y++)
		{
			for (int x = 0; x < source.width; x++)
			{
				int alpha = (source.pixels[i] >> 24) & 0xFF;
				if (alpha > 0)
				{
					if (x < clipRect.x)
					{
						clipRect.x = x;
					}
					if (y < clipRect.y)
					{
						clipRect.y = y;
					}

					if (x > clipRect.width)
					{
						clipRect.width = x;
					}

					if (y > clipRect.height)
					{
						clipRect.height = y;
					}
				}
				i++;
			}
		}

		int padding = 3;
		int width = clipRect.width - clipRect.x;
		int height = clipRect.height - clipRect.y;

		// holds the image with a 3 pixel border of transparent pixels.
		PImage borderedImage = new PImage(width + padding * 2, height + padding * 2, PApplet.ARGB);
		PImage newImage = new PImage(width, height, PApplet.ARGB);

		for (int y = clipRect.y; y < clipRect.y + height; y++)
		{
			for (int x = clipRect.x; x < clipRect.x + width; x++)
			{
				int pt = y * source.width + x;
				newImage.pixels[(y - clipRect.y) * width + (x - clipRect.x)] = source.pixels[pt];
			}
		}
		borderedImage.copy(newImage, 0, 0, newImage.width, newImage.height, padding, padding, newImage.width, newImage.height);
		return borderedImage;
	}
}
