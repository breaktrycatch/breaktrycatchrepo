package com.breaktrycatch.needmorehumans.view;

import java.util.ArrayList;

import processing.core.PApplet;
import processing.core.PImage;
import processing.core.PVector;

import com.breaktrycatch.lib.view.AbstractView;
import com.breaktrycatch.needmorehumans.tracing.EdgeVO;
import com.breaktrycatch.needmorehumans.tracing.ImageAnalysis;
import com.breaktrycatch.needmorehumans.tracing.PixelVO;
import com.breaktrycatch.needmorehumans.tracing.algorithms.BetterRelevancy;
import com.breaktrycatch.needmorehumans.utils.LogRepository;

public class TracingDebugView extends AbstractView
{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private PImage __originalImage;
	private PImage __debugImage;
	private PImage __linkedImage;
	
	private PixelVO pTop;
	private PixelVO pBottom;
	private PixelVO pLeft;
	private PixelVO pRight;
	private PixelVO pCenter;
	
	private PixelVO preciseCenter;
	
	private PixelVO farthestPixel;
	private PixelVO nearestPixel;
	private PixelVO tempPixelFar;
	private PixelVO tempPixelNear;
	
	private ArrayList<PixelVO> farPixels;
	private ArrayList<PixelVO> nearPixels;
	
	private ArrayList<PixelVO> outline;
	private ArrayList<EdgeVO> edges;
	
	private PixelVO startingNode;
	private PixelVO currentNode;
	private PixelVO tempNode;
	private PixelVO nextNode;
	private int nodeCount;
	
	
	private ImageAnalysis __imageAnalysis;
	
	public TracingDebugView()
	{
		// all PApplet related commands should be made in setup().
	}
	
	@Override
	public void initialize(PApplet app)
	{
		super.initialize(app);
		
		String t1 = "TestPerson_png.png";
		String t2 = "Cube.png";
		String p1 = "RealPerson_1.png";
		String p2 = "RealPerson_2.png";
		String p3 = "RealPerson_3.png";
		String p4 = "RealPerson_4.png";
		String p5 = "RealPerson_5.png";
		
		__imageAnalysis = new ImageAnalysis(app);
		__imageAnalysis.analyzeImage(p2);
		
	}
	    
	    
	    
	    

	@Override
	public void draw() {
		__imageAnalysis.draw();

	}
}
