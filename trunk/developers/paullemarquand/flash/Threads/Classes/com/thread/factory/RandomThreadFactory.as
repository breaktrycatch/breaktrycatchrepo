package com.thread.factory
{

	import com.thread.transform.MirrorTransform;
	import com.breaktrycatch.collection.util.ArrayExtensions;
	import com.thread.Thread;
	import com.thread.ai.FollowAgent;
	import com.thread.ai.IAgent;
	import com.thread.bounds.IBoundsChecker;
	import com.thread.bounds.RandomAngleBoundsChecker;
	import com.thread.color.GradientColorSupplier;
	import com.thread.color.IColorSupplier;
	import com.thread.draw.IDrawer;
	import com.thread.draw.RibbonDrawer;
	import com.thread.line.IDrawStyle;
	import com.thread.line.SimpleLine;
	import com.thread.transform.IDrawTransform;
	import com.thread.transform.SimpleTransform;
	import com.thread.vo.ILineStyleable;
	import com.thread.vo.IMotionable;
	import com.thread.vo.ThreadDataVO;
	import org.swiftsuspenders.Injector;

	/**	 * @author plemarquand	 */
	public class RandomThreadFactory
	{
		private var _agents : Array = [ FollowAgent ]; // [FollowAgent];//[RightAngleFollowAgent];//[UniqueLeaderFollowAgent];//[SimpleAgent, CurvyAgent, FollowAgent, GroupFollowAgent, RightAngleAgent];
		private var _colours : Array = [ GradientColorSupplier ]; // [GradientColorSupplier, IncrementalStartKulerColorSupplier, KulerColorSupplier, RandomKulerColorSupplier];//[SimpleColorSupplier, GradientColorSupplier, IncrementalStartKulerColorSupplier, KulerColorSupplier, RandomKulerColorSupplier];
		private var _drawers : Array = [ RibbonDrawer ]; // , CircleDrawer, PolyDrawer, ProximityPolyDrawer, SquareDrawer];
		// private var _drawers : Array = [SimpleDrawer];//, CircleDrawer, PolyDrawer, ProximityPolyDrawer, SquareDrawer];
		private var _transformers : Array = [ MirrorTransform ]; // [FourWayTransform, MirrorRibbonTransform, MirrorTransform, RibbonTransform, SimpleTransform];//[FourWayIntermittentTransform, FourWayRibbonTransform, FourWayTransform, KaleidoscopeTransform, MirrorRibbonTransform, MirrorTransform, RibbonTransform, SimpleTransform];
		private var _bounds : Array = [ RandomAngleBoundsChecker ]; // [BounceBoundsChecker, ContinuationBoundsChecker, RandomAngleBoundsChecker];
		// private var _styles : Array = [SimpleLine];//[AlphaLine, FaintLine, FillShapeStyle, SimpleLine, SizedAlphaLine, SizedLine];
		private var _styles : Array = [ SimpleLine ]; // [AlphaLine, FaintLine, FillShapeStyle, SimpleLine, SizedAlphaLine, SizedLine];

		public function randomize() : void
		{
		}

		public function getThread() : Thread
		{
			var vo : ThreadDataVO = new ThreadDataVO();
			var injector : Injector = new Injector();
			injector.mapClass( Thread, Thread );
			injector.mapClass( IAgent, ArrayExtensions.randomElement( _agents ) );
			injector.mapClass( IColorSupplier, ArrayExtensions.randomElement( _colours ) );
			injector.mapClass( IDrawer, ArrayExtensions.randomElement( _drawers ) );
			injector.mapClass( IDrawTransform, ArrayExtensions.randomElement( _transformers ) );
			injector.mapClass( IBoundsChecker, ArrayExtensions.randomElement( _bounds ) );
			injector.mapClass( IDrawStyle, ArrayExtensions.randomElement( _styles ) );
			injector.mapValue( IMotionable, vo );
			injector.mapValue( ILineStyleable, vo );
			injector.mapValue( ThreadDataVO, vo );

			var thread : Thread = injector.getInstance( Thread );
			
			// so so so slow!
//			ArrayExtensions.executeCallbackOnArray( ReflectionUtils.getAllObjectsOfType( thread, IRandomizable, true ), 'randomize' );
			return thread;
		}
	}
}
