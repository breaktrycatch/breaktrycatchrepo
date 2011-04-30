package com.thread.factory 
{

	import com.thread.transform.SimpleTransform;
	import com.breaktrycatch.collection.util.ArrayExtensions;
	import com.thread.Thread;
	import com.thread.ai.FollowAgent;
	import com.thread.bounds.RandomAngleBoundsChecker;
	import com.thread.color.GradientColorSupplier;
	import com.thread.draw.SimpleDrawer;
	import com.thread.line.SizedLine;
	import com.thread.transform.FourWayTransform;
	import com.thread.vo.IRandomizable;
	import com.thread.vo.ThreadDataVO;
	import org.as3commons.lang.ClassUtils;

	/**	 * @author plemarquand	 */	public class RandomThreadFactory 
	{
		private var _threadVO : Array = [ThreadDataVO];
		private var _agents : Array = [FollowAgent];//[FollowAgent];//[RightAngleFollowAgent];//[UniqueLeaderFollowAgent];//[SimpleAgent, CurvyAgent, FollowAgent, GroupFollowAgent, RightAngleAgent];
		private var _colours : Array = [GradientColorSupplier];//[GradientColorSupplier, IncrementalStartKulerColorSupplier, KulerColorSupplier, RandomKulerColorSupplier];//[SimpleColorSupplier, GradientColorSupplier, IncrementalStartKulerColorSupplier, KulerColorSupplier, RandomKulerColorSupplier];
		private var _drawers : Array = [SimpleDrawer];//, CircleDrawer, PolyDrawer, ProximityPolyDrawer, SquareDrawer];
		private var _transformers : Array = [SimpleTransform];//[FourWayTransform, MirrorRibbonTransform, MirrorTransform, RibbonTransform, SimpleTransform];//[FourWayIntermittentTransform, FourWayRibbonTransform, FourWayTransform, KaleidoscopeTransform, MirrorRibbonTransform, MirrorTransform, RibbonTransform, SimpleTransform];
		private var _bounds : Array = [RandomAngleBoundsChecker];//[BounceBoundsChecker, ContinuationBoundsChecker, RandomAngleBoundsChecker];
		private var _styles : Array = [SizedLine];//[AlphaLine, FaintLine, FillShapeStyle, SimpleLine, SizedAlphaLine, SizedLine];

		private var _randomized : Boolean;
		private var _parameterLists : Vector.<ParameterList>;

		public function randomize() : void
		{
			_parameterLists = new Vector.<ParameterList>( );
			// this must match the order of the Thread constructor for now.
			var items : Array = [_threadVO, _bounds, _colours, _transformers, _drawers, _styles, _agents];
			for (var i : String in items) 
			{
				var rnd : Class = ArrayExtensions.randomElement( items[i] );
				var list : ParameterList = new ParameterList( rnd );
				_parameterLists.push( list );
//				trace("Using: " + rnd);
			}
			_randomized = true;
		}

		public function getThread() : Thread
		{
			if(!_randomized)
			{
				randomize( );
			}
			
			var threadArgInstances : Array = [];
			var instantiationArgumentList : Array = [];
			for (var i : Number = 0; i < _parameterLists.length ; i++) 
			{
				var list : ParameterList = _parameterLists[i];
				list.initializationObjects = instantiationArgumentList;
				
				var obj : * = list.generateObject( );
				if(obj is IRandomizable)
				{
					IRandomizable( obj ).randomize( );
				}
				instantiationArgumentList.push( obj );
				threadArgInstances.push( obj );
			}
			
			return ClassUtils.newInstance( Thread, threadArgInstances );
		}	}}

import com.breaktrycatch.collection.util.ArrayExtensions;
import org.as3commons.lang.ClassUtils;
import org.as3commons.reflect.Parameter;
import org.as3commons.reflect.Type;

internal class ParameterList
{
	private var _clazz : Class;
	private var _initObjects : Array;

	public function ParameterList(clazz : Class, initializationObjects : Array = null) 
	{
		_clazz = clazz;
		_initObjects = (initializationObjects == null) ? ([]) : (initializationObjects);
	}

	public function set initializationObjects(arr : Array) : void
	{
		_initObjects = arr;
	}

	public function generateObject() : Object
	{
		var type : Type = Type.forClass( _clazz );
		var constructorParams : Array = type.constructor.parameters;
		var constructorArgs : Array = [];
		for (var i : Number = 0; i < constructorParams.length ; i++) 
		{
			var param : Parameter = constructorParams[i];
			if(!param.isOptional)
			{
				var initObj : * = findAppropriateType( param.type, _initObjects );
				constructorArgs.push( initObj );
			}
		}
		
		return ClassUtils.newInstance( _clazz, constructorArgs );
	}

	private function findAppropriateType(type : Type, list : Array) : *
	{
		return ArrayExtensions.first( list, function(item : *, ... args) : Boolean
		{
			return item is type.clazz;
		} );	
	}}
