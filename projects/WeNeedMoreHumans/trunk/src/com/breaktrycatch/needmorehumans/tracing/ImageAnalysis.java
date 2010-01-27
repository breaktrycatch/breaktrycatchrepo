package com.breaktrycatch.needmorehumans.tracing;

import java.util.ArrayList;

import org.jbox2d.collision.PolygonDef;
import org.jbox2d.common.Vec2;
import org.jbox2d.p5.Physics;

import processing.core.PApplet;
import processing.core.PGraphics;
import processing.core.PImage;
import processing.core.PVector;

import com.breaktrycatch.needmorehumans.tracing.algorithms.BetterRelevancy;
import com.breaktrycatch.needmorehumans.tracing.polyTool.PolyTool;
import com.breaktrycatch.needmorehumans.utils.LogRepository;
import com.breaktrycatch.needmorehumans.utils.TileImageDrawer;

public class ImageAnalysis
{

	private PImage __originalImage;
	private PApplet app;

	private ArrayList<PixelVO> pixelOutline;
	private ArrayList<PixelVO> orderedPixelOutline;
	private ArrayList<PixelVO> culledSimplePixelOutline;

	private ArrayList<EdgeVO> edges;
	private ArrayList<EdgeVO> culledEdges;
	private ArrayList<EdgeVO> innerCulledEdges;

	private ArrayList<PixelVO> culledPoints;

	ArrayList<ArrayList<PixelVO>> finalPoints;

	ArrayList<PolygonDef> polyDefs;

	private PolyTool polyTool;

	private int bodyCount;

	private final int START_FOUND = 0;
	private final int PIXEL_VALID = 1;
	private final int PIXEL_INVALID = 2;
	private Physics __physWorld;
	private int __pixelCount;
	private TileImageDrawer _debugDrawer;


	public ImageAnalysis(PApplet _app, Physics _physWorld)
	{
		// TODO Auto-generated constructor stub
		app = _app;
		__physWorld = _physWorld;
		bodyCount = 0;
	}

	private void debugDrawPoints(ArrayList<PixelVO> points, int color)
	{
		PGraphics debugCanvas = app.createGraphics(__originalImage.width, __originalImage.height, PApplet.P2D);
		debugCanvas.beginDraw();
		debugCanvas.stroke(color);
		for (int i = 0; i < points.size(); i++)
		{
			debugCanvas.point(points.get(i).x, points.get(i).y);
		}
		_debugDrawer.drawImage(debugCanvas);
	}

	private void debugDrawEdges(ArrayList<EdgeVO> edges, int color)
	{
		PGraphics debugCanvas = app.createGraphics(__originalImage.width, __originalImage.height, PApplet.P2D);
		debugCanvas.beginDraw();
		debugCanvas.stroke(color);
		for (int i = 0; i < edges.size(); i++)
		{
			debugCanvas.line(edges.get(i).p1.x, edges.get(i).p1.y, edges.get(i).p2.x, edges.get(i).p2.y);
		}
		_debugDrawer.drawImage(debugCanvas);
	}

	public void draw()
	{
		debugDrawPoints(pixelOutline, 0xffff0000);
		debugDrawPoints(orderedPixelOutline, 0xff00ff00);
		debugDrawPoints(culledSimplePixelOutline, 0xff0000ff);
		debugDrawEdges(edges, 0x0000ff);

		PGraphics debugCanvas = app.createGraphics(__originalImage.width, __originalImage.height, PApplet.P2D);
		debugCanvas.beginDraw();
		debugCanvas.stroke(0xff00ffff);
		for (int i = 0; i < culledEdges.size(); i++)
		{
			if (i % 2 == 0)
			{
				debugCanvas.stroke(0, 0, 255);
			} else
			{
				debugCanvas.stroke(255, 0, 0);
			}
			if (culledEdges.get(i).holdBecauseOfAngle == true)
			{
				// LogRepository.getInstance().getJonsLogger().info("BLACK");
				debugCanvas.stroke(0, 0, 0);
			}
			debugCanvas.line(culledEdges.get(i).p1.x, culledEdges.get(i).p1.y, culledEdges.get(i).p2.x, culledEdges.get(i).p2.y);
		}
		_debugDrawer.drawImage(debugCanvas);

		// Draw the culled edges
		debugCanvas = app.createGraphics(__originalImage.width, __originalImage.height, PApplet.P2D);
		debugCanvas.beginDraw();
		debugCanvas.stroke(0xff7700ff);
		for (int i = 0; i < finalPoints.size(); i++)
		{
			for (int j = 0; j < finalPoints.get(i).size(); j++)
			{
				int index = j + 1;
				if (j + 1 >= finalPoints.get(i).size())
				{
					index = 0;
				}
				debugCanvas.line(finalPoints.get(i).get(j).x, finalPoints.get(i).get(j).y, finalPoints.get(i).get(index).x, finalPoints.get(i).get(index).y);
			}
		}
		_debugDrawer.drawImage(debugCanvas);
	}

	private boolean verifyOutline()
	{
		// Bug CHECK - If we have less than 90% of the points, something went
		// wrong
		if (orderedPixelOutline.size() < (pixelOutline.size() - (pixelOutline.size() * 0.1)))
		{
			for (int i = 0; i < pixelOutline.size(); i++)
			{
				pixelOutline.get(i).marked = false;
				pixelOutline.get(i).rendered = false;
				pixelOutline.get(i).saveFromSimpleCulling = false;
				pixelOutline.get(i).next = null;
				pixelOutline.get(i).prev = null;
			}

			LogRepository.getInstance().getJonsLogger().info("LESS THAN 90%  Starting with " + (pixelOutline.size() / 2));
			__pixelCount++;
			return false;
		}
		return true;
	}

	public ArrayList<PolygonDef> analyzeImage(PImage _image)
	{

		__originalImage = _image;

		determinePixelOutline();
		LogRepository.getInstance().getJonsLogger().info("NUMBER OF PIXELS IN OUTLINE " + pixelOutline.size());

		__pixelCount = 0;
		orderPixels(__pixelCount);
		while (!verifyOutline())
		{
			orderPixels(__pixelCount);
		}

		LogRepository.getInstance().getJonsLogger().info("NUMBER OF PIXELS IN ORDERED OUTLINE " + orderedPixelOutline.size());
		cullSimple();
		LogRepository.getInstance().getJonsLogger().info("NUMBER OF PIXELS IN CULLED ORDERED OUTLINE " + culledSimplePixelOutline.size());
		constructEdges();
		LogRepository.getInstance().getJonsLogger().info("NUMBER OF EDGES " + edges.size());
		culledEdges = new ArrayList<EdgeVO>();
		// Do Relevancy Check
		cullEdges(edges, false, true);
		LogRepository.getInstance().getJonsLogger().info("NUMBER OF CULLED EDGES RELEVANCY " + culledEdges.size());
		innerCulledEdges = (ArrayList<EdgeVO>) culledEdges.clone();
		culledEdges = new ArrayList<EdgeVO>();
		// Do Length Check
		cullEdges(innerCulledEdges, true, false);
		LogRepository.getInstance().getJonsLogger().info("NUMBER OF CULLED EDGES LENGTH " + culledEdges.size());

		// for (int i=1; i<3; i++) {
		// innerCulledEdges = (ArrayList<EdgeVO>) culledEdges.clone();
		// culledEdges = new ArrayList<EdgeVO>();
		// cullEdges(innerCulledEdges, true);
		// LogRepository.getInstance().getJonsLogger().info("NUMBER OF CULLED EDGES "
		// + i + " " + culledEdges.size());
		// }
		convertToPoints();
		LogRepository.getInstance().getJonsLogger().info("NUMBER OF CULLED POINTS " + culledPoints.size());
		convertToPolys();
		LogRepository.getInstance().getJonsLogger().info("BODIES CREATED " + bodyCount);
		LogRepository.getInstance().getJonsLogger().info("POLYGONS CREATED " + polyDefs.size());

		return polyDefs;
	}

	private void determinePixelOutline()
	{
		// Index in the pixels array of the image
		int index;
		// Whether we are in negative or positive space
		boolean negativeSpace = true;

		// Constructs the pixelOutline array list
		pixelOutline = new ArrayList<PixelVO>();

		for (int y = 0; y < __originalImage.height; y++)
		{
			negativeSpace = true;
			for (int x = 0; x < __originalImage.width; x++)
			{
				index = y * __originalImage.width + x;
				// get the pixel
				int pixel = __originalImage.pixels[index];
				// If the alpha is real
				if (app.alpha(pixel) > 0xEE)
				{
					if (negativeSpace == true)
					{
						negativeSpace = false;
						addPixelToList(pixelOutline, x, y, index);
					}
				} else
				{
					if (negativeSpace == false)
					{
						negativeSpace = true;
						addPixelToList(pixelOutline, x - 1, y, index);
					}
				}
			}
		}

		for (int x = 0; x < __originalImage.width; x++)
		{
			negativeSpace = true;
			for (int y = 0; y < __originalImage.height; y++)
			{
				index = y * __originalImage.width + x;
				// get the pixel
				int pixel = __originalImage.pixels[index];
				// If the alpha is real
				if (app.alpha(pixel) > 0xEE)
				{
					if (negativeSpace == true)
					{
						negativeSpace = false;
						addPixelToList(pixelOutline, x, y, index);
					}
				} else
				{
					if (negativeSpace == false)
					{
						negativeSpace = true;
						addPixelToList(pixelOutline, x, y - 1, index);
					}
				}
			}
		}
	}

	// TODO: Rare case where we have only 3 pixels. p1
	private void orderPixels(int _startPixelIndex)
	{
		PixelVO startPixel = pixelOutline.get(_startPixelIndex);
		PixelVO currentPixel = startPixel;
		PixelVO checkPixel;

		ArrayList<ModVO> mods = new ArrayList<ModVO>();
		// RIGHT
		mods.add(new ModVO(1, 0));
		// DOWN
		mods.add(new ModVO(0, 1));
		// DOWN-RIGHT
		mods.add(new ModVO(1, 1));
		// LEFT
		mods.add(new ModVO(-1, 0));
		// DOWN - LEFT
		mods.add(new ModVO(-1, 1));
		// UP
		mods.add(new ModVO(0, -1));
		// UP - LEFT
		mods.add(new ModVO(-1, -1));
		// UP - RIGHT
		mods.add(new ModVO(1, -1));

		boolean found = false;

		searchLoop: while (found == false)
		{

			for (int i = 0; i < mods.size(); i++)
			{
				checkPixel = getPixelByXY(pixelOutline, currentPixel.x + mods.get(i).modX, currentPixel.y + mods.get(i).modY);
				switch (validatePixel(startPixel, currentPixel, checkPixel))
				{
				case START_FOUND:
					found = true;
					break searchLoop;

				case PIXEL_VALID:
					currentPixel = checkPixel;
					continue searchLoop;

				}
			}

			// LogRepository.getInstance().getJonsLogger().info("NO PIXEL FOUND ALL AROUND!");
			currentPixel = currentPixel.prev;
		}

		orderedPixelOutline = new ArrayList<PixelVO>();

		currentPixel = startPixel;
		orderedPixelOutline.add(currentPixel);
		currentPixel.id = 0;
		found = false;
		int pid = 1;

		orderLoop: while (found == false)
		{
			checkPixel = currentPixel.next;
			if (checkPixel.x == startPixel.x && checkPixel.y == startPixel.y)
			{
				found = true;
				break orderLoop;
			}
			orderedPixelOutline.add(checkPixel);
			checkPixel.id = pid;
			pid++;
			currentPixel = checkPixel;
		}

	}

	private void cullSimple()
	{
		culledSimplePixelOutline = new ArrayList<PixelVO>();
		orderedPixelOutline.get(0).saveFromSimpleCulling = true;
		int skip = 5;
		// removes every
		for (int i = 1; i < orderedPixelOutline.size(); i++)
		{
			if (i % skip == 0)
			{
				// LogRepository.getInstance().getJonsLogger().info("MODDING OUT PIXEL "
				// + i + " " + skip);
				orderedPixelOutline.get(i).saveFromSimpleCulling = true;
			}
		}

		for (int i = 0; i < orderedPixelOutline.size(); i++)
		{
			if (orderedPixelOutline.get(i).saveFromSimpleCulling == true)
			{
				culledSimplePixelOutline.add(orderedPixelOutline.get(i));
			}
		}
	}

	private void constructEdges()
	{

		edges = new ArrayList<EdgeVO>();

		PixelVO startPixel = culledSimplePixelOutline.get(0);
		PixelVO currentPixel = startPixel;
		PixelVO nextPixel;

		int index;

		for (int i = 1; i < culledSimplePixelOutline.size(); i++)
		{
			index = i + 1;
			if (index >= culledSimplePixelOutline.size())
			{
				index = 0;
			}
			nextPixel = culledSimplePixelOutline.get(index);
			edges.add(new EdgeVO(currentPixel, nextPixel));
			currentPixel = nextPixel;
		}
	}

	private void cullEdges(ArrayList<EdgeVO> _from, boolean _lengthCheck, boolean _relevancyCheck)
	{

		EdgeVO nextEdge;
		EdgeVO currentEdge;
		EdgeVO linkedEdge = null;
		EdgeVO addedEdge;
		int index = 0;

		for (int i = 0; i < _from.size(); i++)
		{
			currentEdge = _from.get(i);
			index = i + 1;
			if (index >= _from.size())
			{
				index = 0;
			}
			nextEdge = _from.get(index);

			// We want to hold edges that are vertical or horizontal and larger
			// than 7 pixels

			PVector horizontalVector = new PVector(1, 0);

			PVector edgeVector = new PVector(currentEdge.p2.x - currentEdge.p1.x, currentEdge.p2.y - currentEdge.p1.y);

			float angle = PApplet.degrees(PVector.angleBetween(horizontalVector, edgeVector));
			float epsilon = 5;

			currentEdge.updateLength();

			// Vertical Line
			// if (angle < (90+epsilon) && (angle > (90-epsilon))) {
			// //LogRepository.getInstance().getJonsLogger().info("V ANGLE 90 "
			// + angle);
			// currentEdge.holdBecauseOfAngle = true;
			// }
			// if (angle < (270+epsilon) && (angle > (270-epsilon))) {
			// //LogRepository.getInstance().getJonsLogger().info("V ANGLE 270 "
			// + angle);
			// currentEdge.holdBecauseOfAngle = true;
			// }
			if (angle < (0 + epsilon) && (angle > (0 - epsilon)))
			{
				// LogRepository.getInstance().getJonsLogger().info("H ANGLE 0 "
				// + angle);
				currentEdge.holdBecauseOfAngle = true;
			}
			if (angle < (180 + epsilon) && (angle > (180 - epsilon)))
			{
				// LogRepository.getInstance().getJonsLogger().info("H ANGLE 180 "
				// + angle);
				currentEdge.holdBecauseOfAngle = true;
			}

			// LogRepository.getInstance().getJonsLogger().info("ANGLE " +
			// angle);

			if (_relevancyCheck)
			{
				double relevancy = BetterRelevancy.calculate(currentEdge, nextEdge);

				if (relevancy < 30)
				{
					if (currentEdge.holdBecauseOfAngle == false)
					{
						currentEdge.markForCulling = true;
					}
				}
			}

			if (_lengthCheck)
			{

				// LogRepository.getInstance().getJonsLogger().info("LENGTH: " +
				// currentEdge.length);

				if (currentEdge.length < 10)
				{
					if (currentEdge.holdBecauseOfAngle == false)
					{
						currentEdge.markForCulling = true;
					}
				}
			}

		}

		for (int i = 0; i < _from.size(); i++)
		{
			currentEdge = _from.get(i);
			if (currentEdge.markForCulling == false)
			{
				addedEdge = new EdgeVO(currentEdge.p1, currentEdge.p2);
				addedEdge.holdBecauseOfAngle = currentEdge.holdBecauseOfAngle;
				culledEdges.add(addedEdge);
				if (linkedEdge == null)
				{
					linkedEdge = addedEdge;
				} else
				{
					linkedEdge.p2 = addedEdge.p1;
					addedEdge.p1 = linkedEdge.p2;
					linkedEdge = addedEdge;
				}
			}
		}
	}

	private void convertToPoints()
	{
		culledPoints = new ArrayList<PixelVO>();
		for (int i = 0; i < culledEdges.size(); i++)
		{
			culledPoints.add(culledEdges.get(i).p1);
		}
	}

	private void convertToPolys()
	{
		polyDefs = new ArrayList<PolygonDef>();
		polyTool = new PolyTool();

		// if (culledPoints.size() > 8) {
		makeComplexBody(culledPoints);
		// }

		// EarClipping earClipping = new EarClipping();
		// float x[] = new float[culledEdges.size()];
		// float y[] = new float[culledEdges.size()];
		// for (int i = culledEdges.size() - 1; i >= 0; i--) {
		// x[i] = culledEdges.get(i).p1.x;
		// y[i] = culledEdges.get(i).p1.y;
		// }
		//		
		// Triangle[] tArray = earClipping.createTriangles(x, y,
		// culledEdges.size());
		//		
		//		
		// if (tArray != null) {
		// triangles = new ArrayList<Triangle>();
		// for (int i = 0; i < tArray.length; i++) {
		// triangles.add(tArray[i]);
		// }
		//			
		//			
		// Polygon[] pArray = earClipping.createPolys(tArray);
		//			
		// if (pArray != null) {
		// polygons = new ArrayList<Polygon>();
		// for (int i = 0; i < pArray.length; i++) {
		// polygons.add(pArray[i]);
		// }
		// }
		// else {
		// LogRepository.getInstance().getJonsLogger().info("PARRAY IS NULL!");
		// }
		//			
		// }
		// else {
		// LogRepository.getInstance().getJonsLogger().info("TARRAY IS NULL!");
		// }

	}

	// HELPERS

	private void makeComplexBody(ArrayList<PixelVO> p_vertices)
	{
		ArrayList<PixelVO> vertArray = (ArrayList<PixelVO>) p_vertices.clone();
		if (!polyTool.isPolyClockwise(vertArray))
		{
			vertArray = polyTool.reverseArrayList(vertArray);
		}
		ArrayList<ArrayList<PixelVO>> polys = polyTool.earClip(vertArray);
		
		float maxX = -999.0f;
		float maxY = -999.0f;
		float minX = 999.0f;
		float minY = 999.0f;
		
		
		if(polys != null) {
			
			finalPoints = polys;

			for (int i = 0; i < polys.size(); i++)
			{
				if (polys.get(i) != null)
				{

					PolygonDef polyDef;
					polyDef = new PolygonDef();
					polyDef.friction = 0.7f;
					polyDef.restitution = 0.3f;
					polyDef.density = 1.0f;
					// if(p_static)
					// polyDef.density = 0.0;
					// else
					// polyDef.density = 1.0;

					// Might not need?
					// polyDef.vertexCount = polys.get(i).size();

					Vec2 v;
					// for (int j = 0; j < polys.get(i).size(); j++) {

					for (int j = polys.get(i).size() - 1; j >= 0; j--)
					{
						// polyDef.vertices.add(j, new
						// Vec2(polys.get(i).get(j).x/30,
						// polys.get(i).get(j).y/30));
						v = new Vec2(polys.get(i).get(j).x, polys.get(i).get(j).y);

						if (__physWorld != null)
						{
							v = __physWorld.screenToWorld(v);
						}
						polyDef.addVertex(v);
						//polyDef.vertices.add(v);
						
						
						//Record the extremes of the polygon collection
						if(v.x > maxX)
						{
							maxX = v.x;
						}
						
						if(v.x < minX)
						{
							minX = v.x;
						}
						
						if(v.y > maxY)
						{
							maxY = v.y;
						}
						
						if(v.y < minY)
						{
							minY = v.y;
						}
					}

					polyDefs.add(polyDef);

					// p_body.createShape(polyDef);
				}
			}
			
			LogRepository.getInstance().getMikesLogger().info("MIN X,Y: " + minX + ", " + minY);
			LogRepository.getInstance().getMikesLogger().info("MAX X,Y: " + maxX + ", " + maxY);
			
			//TODO: JON - see if this can be done before points are placed? how does the image get reffed like this? 
			//Shift the polygonal collection to be relative to a center reference
			float shiftX = (maxX + ((minX-maxX)/2.0f));
			float shiftY = (maxY + ((minY-maxY)/2.0f));
			
			for(int k = 0; k < polyDefs.size(); k++)
			{
				Vec2[] verticies = polyDefs.get(k).getVertexArray();
				
				for(int l = 0; l < verticies.length; l++)
				{
					verticies[l].x -= shiftX;
					verticies[l].y -= shiftY;
				}
			}
			
			
			//p_body.setMassFromShapes();
			bodyCount++;

		} else
		{
			makeComplexBody(polyTool.getConvexPoly(p_vertices));
		}
	}

	private PixelVO getPixelByXY(ArrayList<PixelVO> _list, float _x, float _y)
	{
		for (int i = 0; i < _list.size(); i++)
		{
			if (_list.get(i).x == _x && _list.get(i).y == _y)
			{
				return _list.get(i);
			}
		}
		return null;
	}

	private int validatePixel(PixelVO _start, PixelVO _current, PixelVO _check)
	{
		if (_check != null)
		{
			if (_check.marked == false)
			{
				_check.marked = true;
				_current.next = _check;
				_check.prev = _current;
				_current = _check;
				if (_current.x == _start.x && _current.y == _start.y)
				{
					LogRepository.getInstance().getJonsLogger().info("FOUND START RIGHT");
					return START_FOUND;
				}
				return PIXEL_VALID;
			}
			return PIXEL_INVALID;
		}
		return PIXEL_INVALID;
	}

	protected void addPixelToList(ArrayList<PixelVO> _list, int _x, int _y, int _index)
	{
		if (isDuplicatePixel(_list, _x, _y) == false)
		{
			_list.add(new PixelVO(_x, _y, _index));
		}
	}

	protected boolean isDuplicatePixel(ArrayList<PixelVO> _list, int _x, int _y)
	{
		for (int i = 0; i < _list.size(); i++)
		{
			if (_list.get(i).x == _x && _list.get(i).y == _y)
			{
				return true;
			}
		}
		return false;
	}

	public void setDebugDrawer(TileImageDrawer debugDrawer)
	{
		_debugDrawer = debugDrawer;

	}

}
