package com.breaktrycatch.needmorehumans.core;

import hypermedia.video.OpenCV;
import processing.core.PApplet;
import processing.core.PImage;
import processing.video.Capture;

import com.breaktrycatch.needmorehumans.control.webcam.ImageSubstractionController;

public class WeNeedMoreHumansMain extends PApplet
{
	/**
	 * Default serial version id to appease the Eclipse gods.
	 */
	private static final long serialVersionUID = 1L;

	/**
	 * Main entry point for the application.
	 * 
	 * @param args
	 *            Command line arguments.
	 */
	public static void main(String args[])
	{
		PApplet.main(new String[] { "--present", "com.breaktrycatch.needmorehumans.core.WeNeedMoreHumansMain" });
	}

	private Capture _webcam;
	private PImage _background;
	private ImageSubstractionController _subtractor;
	private OpenCV _opencv;
	private int w;
	private int h;
	private float threshold = 80;

	public WeNeedMoreHumansMain()
	{
		// all PApplet related commands should be made in setup().
	}

	@Override
	public void setup()
	{
		super.setup();

		frameRate(60);

		_background = loadImage("sunset-beach.jpg");
		size(_background.width, _background.height, P2D);
		_webcam = new Capture(this, _background.width, _background.height, 30);
		_subtractor = new ImageSubstractionController(this, createImage(_background.width, _background.height, ARGB));
		
		// cant get the damn opencv library to link!
//	    _opencv = new OpenCV( this );
//	    _opencv.capture(width, height);
//	    
//	    w = width / 2;
//	    h = height / 2;
		
	}

	public void keyPressed()
	{
		// saves an image is spacebar is hit
		if (key == ' ')
		{
			_subtractor.setBackgroundImage(_webcam.get());
		}
		else if(key == ENTER)
		{
			println("Building primitives");
		}
	}

	public void draw()
	{
		if (_webcam.available())
		{
			_webcam.read();
			_webcam.loadPixels();

			PImage frame = _webcam.get(0, 0, _webcam.width, _webcam.height);
			PImage diffed = _subtractor.createDifferenceMask(_webcam.get());
			
			println("Activity level: " + _subtractor.getActivityLevel());
			
//			if(_subtractor.getActivityLevel() < 10f)
//			{
//				_subtractor.setBackgroundImage(_webcam.get());
//			}

			// image(frame,0,0);
			image(_background,0,0);
			image(diffed, 0, 0);

//			 image(_subtractor.getBackgroundImage(),0,0);
		}

		// draw some stuff!
		
		/*
		_opencv.read();
	    //_opencv.flip( OpenCV.FLIP_HORIZONTAL );

	    image( _opencv.image(), 10, 10 );	            // RGB image
	    image( _opencv.image(OpenCV.GRAY), 20+w, 10 );   // GRAY image
	    image( _opencv.image(OpenCV.MEMORY), 10, 20+h ); // image in memory

	    _opencv.absDiff();
	    _opencv.threshold(threshold);
	    image( _opencv.image(OpenCV.GRAY), 20+w, 20+h ); // absolute difference image


	    // working with blobs
	    Blob[] blobs = _opencv.blobs( 100, w*h/3, 20, true );

	    noFill();

	    pushMatrix();
	    translate(20+w,20+h);
	    
	    for( int i=0; i<blobs.length; i++ ) {

	        Rectangle bounding_rect	= blobs[i].rectangle;
	        float area = blobs[i].area;
	        float circumference = blobs[i].length;
	        Point centroid = blobs[i].centroid;
	        Point[] points = blobs[i].points;

	        // rectangle
	        noFill();
	        stroke( blobs[i].isHole ? 128 : 64 );
	        rect( bounding_rect.x, bounding_rect.y, bounding_rect.width, bounding_rect.height );


	        // centroid
	        stroke(0,0,255);
	        line( centroid.x-5, centroid.y, centroid.x+5, centroid.y );
	        line( centroid.x, centroid.y-5, centroid.x, centroid.y+5 );
	        noStroke();
	        fill(0,0,255);
	        text( area,centroid.x+5, centroid.y+5 );


	        fill(255,0,255,64);
	        stroke(255,0,255);
	        if ( points.length>0 ) {
	            beginShape();
	            for( int j=0; j<points.length; j++ ) {
	                vertex( points[j].x, points[j].y );
	            }
	            endShape(CLOSE);
	        }

	        noStroke();
	        fill(255,0,255);
	        text( circumference, centroid.x+5, centroid.y+15 );

	    }
	    popMatrix();
	    */
	}

}
