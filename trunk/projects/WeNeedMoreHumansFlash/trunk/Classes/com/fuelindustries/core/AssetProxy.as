package com.fuelindustries.core 
{
	import flash.accessibility.AccessibilityImplementation;
	import flash.accessibility.AccessibilityProperties;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.Scene;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Transform;
	import flash.media.SoundTransform;
	import flash.text.TextSnapshot;
	import flash.ui.ContextMenu;
	import flash.utils.Dictionary;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getQualifiedSuperclassName;

	/**
	 * AssetProxy is a class that should be the base class of all your Asset based classes, if you want to separate code from the actual asset. 
	 * For example, if your class was going to extend MovieClip, it should extend AssetProxy instead.
	 * 
	 * @author jkeon
	 */
	public class AssetProxy extends Object {
		
		//Static linkage for a Blank MovieClip. AssetProxy will construct a blank movieclip if it see's this as the linkage.
		public static const BLANK_MOVIECLIP:String = "assetproxy_blank_movieclip";
		//Dynamic variable attached to the Display if the Display should contain a link back to the class
		public static const PROXYCODE:String = "proxycode";
		
		//The Linkage to the Asset in the library for dynamically generated assets
		private var __linkage:String;
		
		//The Movieclip Asset in the Library
		protected var __display:MovieClip;	
		
		//Cache's existing types so we save the call time -- No weak keys because this is the only place it is referenced
		private static var __xmlCache:Dictionary = new Dictionary();
		
		//Should the Display maintain a linkage to the class? (For resolving event.target calls or iterating through the display list)
		private var __maintainClassReference:Boolean = false;
		
		//Dictionary of overridden variables
		private var __overriddenVariables:Dictionary;
		
		/**
		 * AssetProxy Constructor. Actually Split into Two Parts.
		 * 
		 * @see completeConstruction
		 */
		public function AssetProxy() {
			super();
		}
		
		////////////////////////////////////////////////////////////////////////////////////
		// AssetProxy Functions ////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Returns the Display of the class which is the actual asset in the FLA library.
		 * 
		 * @return The Asset
		 * @throws Error if the Display was not linked.
		 * @see linkDisplay
		 */
		public function get display():MovieClip {
			if (__display != null) {
				return __display;
			}
			else {
				throw new Error("AssetProxy " + this + " does not have a display linked. Link using linkDisplay() before trying to access it");
			}
				
		}
		
		/**
		 * Sets the linkage of the display. Should usually be done in the Constructor.
		 * 
		 * @param _linkage The String Value of the linkage in the library. 
		 */
		protected function set linkage(_linkage:String):void {
			__linkage = _linkage;
		}
		
		
		
		/**
		 * Sets whether or not to link the Class to the Display object.
		 * 
		 * @param _bool Boolean for whether to maintain a Class reference or not. True to keep reference, False to ignore.
		 * @see destroy
		 */
		public function set maintainClassReference(_bool:Boolean):void {
			__maintainClassReference = _bool;
		}
		
		public function get maintainClassReference():Boolean {
			return( __maintainClassReference );
		}
		
		/**
		 * Links the Class to the Display. Should be called in your Constructor.
		 * 
		 * @throws Error if Linkage is invalid.
		 */
		public function linkDisplay():void {
			
			if (__display == null) {
				if (__linkage != null && __linkage != "") {
				
					//Only Instantiate if added dynamically (not already on the stage)
					setDisplayByLinkage(__linkage);
				}
				else {
					throw new Error("Invalid linkage! AssetProxy Class: " + this);
				}
			}
			else {
				throw new Error("Class " + this + " already has a display set!");
			}
		}
		
		/**
		 * Generates the Asset and handles any nested AssetProxy classes or nested MovieClip inside. 
		 * This function will recursively comb the class definition and cache the results for a faster lookup time in the future.
		 * 
		 */
		private function generateAsset():void {
			
			var objDescriptor : XML;
			//Get this class name
			var qualifiedClassName:String = getQualifiedClassName(this);
			//Check and see if we have it already in the cache
			if (__xmlCache[qualifiedClassName] is XML) {
				objDescriptor = __xmlCache[qualifiedClassName];
			}
			//Otherwise, do a describe type and cache the results
			else {
				objDescriptor = describeType(this);
				__xmlCache[qualifiedClassName] = objDescriptor;
			}
			
			var property : XML;
			
			//Get the public variables
			for each ( property in objDescriptor..*)
			{
				if (property.name() == "variable") 
				{
					var name : String = property.@name;
					var type : String = property.@type;
					var clazz : Class;
				
					//Check For any overrides
					if (__overriddenVariables && __overriddenVariables[name]) 
					{
						clazz = __overriddenVariables[name];
					}
					else 
					{
						//See what Class type the Public properties are
						clazz = getDefinitionByName(type) as Class;
					}
				
					//See if it extends AssetProxy
					if(inheritsFrom(clazz, AssetProxy))
					{
						//If the display has a instance name of the same type
						if (__display[name] != null ) 
						{
							
							var inst:*;
							
							if( this[ name ] == null )
							{
								inst = new clazz();
							}
							else
							{
								inst = this[ name ];	
							}
							
							//And set the display to be the already existing Movieclip on the stage
							AssetProxy(inst).setDisplayByClip(__display[name]);
							
							try
							{
								//Assign the public variable to be this new class
								this[name] = inst;
							}
							catch(e:Error)
							{
								throw new Error( "Inheritance error on " + name + ". " + inst + " doesn't extend " + type );
							}
						}
			
					}
					//If the class is a generic MovieClip or Textfield
					else if (type == "flash.display::MovieClip" || type == "flash.text::TextField" || type == "flash.media::Video") 
					{
						//Simply assign the public variable in the class to the clip
						this[name] = __display[name];
					}
				}
			}
			
			//Only Link the Class to the display if explicitly asked to
			if (__maintainClassReference) {
				//Assign the dynamic property to the MovieClip. Remember to destroy the class when finished with it.
				__display[PROXYCODE] = this;
			}
			//Finish the Construction
			completeConstruction();
		}
		
		/**
		 * This is the second part of the constructor. Override in your own classes and put any code that affects the display here.
		 */
		protected function completeConstruction():void {
			//DOES NOTHING, MUST OVERRIDE
		}
		
		/**
		 * Function courtesy of Colin Moock that determines what a class extends from.
		 * 
		 * @param descendant The Class you are testing
		 * @param ancestor The Class you are testing against
		 * @return Boolean of whether the descendant is an actual descendant of the ancestor
		 */
		public function inheritsFrom (descendant:Class, ancestor:Class):Boolean { 
  			var superName:String;
  			var ancestorClassName:String = getQualifiedClassName(ancestor);
  			while (superName != "Object") {
    			superName = getQualifiedSuperclassName(descendant);
    			
    			if( superName == null ) return false;
    			
    			if (superName == ancestorClassName) {
      				return true;
    			}
    			descendant = Class(getDefinitionByName(superName));
  			}
  			return false;
		}
		
		/**
		 * Allows you to override variables for construction at runtime.
		 * 
		 * @param _variableName The String name of the public variable you wish to override
		 * @param _variableClass The class you wish to override with. Technically should subclass the existing type but I suppose it doesn't have to.
		 */
		protected function overrideVariable(_variableName:String, _variableClass:Class):void {
			if (__overriddenVariables == null) {
				__overriddenVariables = new Dictionary();
			}
			//Will override any previous associations. Only the top level override counts.
			__overriddenVariables[_variableName] = _variableClass;
		}
		
		
		/**
		 * Set the Asset by Typing in the String Name of the Asset in the Library. The Asset should extend MovieClip
		 * 
		 * @param _linkage The String linkage in the library
		 * @throws ArgumentError if the Linkage is not valid and not display was set.
		 */
		public function setDisplayByLinkage(_linkage:String):void {
			//If the linkage is the static for a Blank Movieclip
			if (_linkage == BLANK_MOVIECLIP) {
				//Create a new Blank Movieclip
				__display = new MovieClip();
			}
			else {
				//Otherwise, pull the MovieClip out of the library
				var clazz:Class = Class(getDefinitionByName(_linkage));
				__display = new clazz() as MovieClip;
			}
			
			if(!__display)
			{
				throw new ArgumentError("Invalid linkage! Linkage Attempted:" + _linkage + " AssetProxy Class: " + this);
			}
			generateAsset();
		}
		
		/**
		 * Set the Asset by passing in an existing movieclip.
		 * 
		 * @param _clip A Movieclip to serve as the display for the class
		 * @throws ArgumentError if the clip is not a valid movieclip.
		 */
		public function setDisplayByClip(_clip:MovieClip):void {
			__display = _clip;
			if(!__display)
			{
				throw new ArgumentError("Invalid display object! Clip Attempted:" + _clip + " AssetProxy Class: " + this);
			}
			generateAsset();
		}
		
		/**
		 * Cleans the Asset for reuse. Override for your specific needs.
		 */
		public function clean():void {
			
		}
		/**
		 * Destroys the Asset for Garbage Collection. Calls clean() first.
		 */
		public function destroy():void {
			clean();
			if (__display != null) 
			{
				__display.stop();
				__display[PROXYCODE] = null;	
				__display = null;
			}
			if (__overriddenVariables) {
				for (var b:String in __overriddenVariables) {
					__overriddenVariables[b] = null;
				}
				__overriddenVariables = null;
			}
			
		}
		
		////////////////////////////////////////////////////////////////////////////////////
		// MovieClip Functions /////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////
		
		public function get currentLabels() : Array {
			return __display.currentLabels;
		}

		public function stop() : void {
			__display.stop();
		}

		public function get currentLabel() : String {
			return __display.currentLabel;
		}

		public function get totalFrames() : int {
			return __display.totalFrames;
		}

		public function prevScene() : void {
			__display.prevScene();
		}

		public function play() : void {
			__display.play();
		}

		public function addFrameScript(...args) : void {
			__display.addFrameScript.apply(__display, args);
		}

		public function nextFrame() : void {
			__display.nextFrame();
		}

		public function get enabled() : Boolean {
			return __display.enabled;
		}

		public function get framesLoaded() : int {
			return __display.framesLoaded;
		}

		public function get scenes() : Array {
			return __display.scenes;
		}

		public function nextScene() : void {
			__display.nextScene();
		}

		public function get currentFrame() : int {
			return __display.currentFrame;
		}

		public function set enabled(value : Boolean) : void {
			__display.enabled = value;
		}

		public function gotoAndStop(frame : Object, scene : String = null) : void {
			if (frame is int) {
				if (this.currentFrame != frame) {
					__display.gotoAndStop(frame, scene);
				}
			}
			else if (frame is String) {
				if (this.currentLabel != frame) {
					__display.gotoAndStop(frame, scene);	
				}	
			}
		}

		public function get currentScene() : Scene {
			return __display.currentScene;
		}

		public function set trackAsMenu(value : Boolean) : void {
			__display.trackAsMenu = value;
		}

		public function gotoAndPlay(frame : Object, scene : String = null) : void {
			__display.gotoAndPlay(frame, scene);
		}

		public function get trackAsMenu() : Boolean {
			return __display.trackAsMenu;
		}

		public function prevFrame() : void {
			__display.prevFrame();
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////
		// Sprite Functions ////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////
		
		public function get soundTransform() : SoundTransform {
			return __display.soundTransform;
		}

		public function set useHandCursor(value : Boolean) : void {
			__display.useHandCursor = value;
		}

		public function set soundTransform(sndTransform : SoundTransform) : void {
			__display.soundTransform = sndTransform;
		}

		public function stopDrag() : void {
			__display.stopDrag();
		}

		public function get dropTarget() : DisplayObject {
			return __display.dropTarget;
		}

		public function set hitArea(value : Sprite) : void {
			__display.hitArea = value;
		}

		public function get graphics() : Graphics {
			return __display.graphics;
		}

		public function get useHandCursor() : Boolean {
			return __display.useHandCursor;
		}

		public function startDrag(lockCenter : Boolean = false, bounds : Rectangle = null) : void {
			__display.startDrag(lockCenter, bounds);
		}

		public function get hitArea() : Sprite {
			return __display.hitArea;
		}

		public function set buttonMode(value : Boolean) : void {
			__display.buttonMode = value;
		}

		public function get buttonMode() : Boolean {
			return __display.buttonMode;
		}
		
		////////////////////////////////////////////////////////////////////////////////////
		// Display Object Container Functions //////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////
		
		public function addChild(child : DisplayObject) : DisplayObject {
			return __display.addChild(child);
		}

		public function getChildByName(name : String) : DisplayObject {
			return __display.getChildByName(name);
		}

		public function get textSnapshot() : TextSnapshot {
			return __display.textSnapshot;
		}

		public function getChildIndex(child : DisplayObject) : int {
			return __display.getChildIndex(child);
		}

		public function set mouseChildren(enable : Boolean) : void {
			__display.mouseChildren = enable;
		}

		public function setChildIndex(child : DisplayObject, index : int) : void {
			__display.setChildIndex(child, index);
		}

		public function addChildAt(child : DisplayObject, index : int) : DisplayObject {
			return __display.addChildAt(child, index);
		}

		public function contains(child : DisplayObject) : Boolean {
			return __display.contains(child);
		}

		public function get numChildren() : int {
			return __display.numChildren;
		}

		public function swapChildrenAt(index1 : int, index2 : int) : void {
			__display.swapChildrenAt(index1, index2);
		}

		public function get tabChildren() : Boolean {
			return __display.tabChildren;
		}

		public function getChildAt(index : int) : DisplayObject {
			return __display.getChildAt(index);
		}

		public function swapChildren(child1 : DisplayObject, child2 : DisplayObject) : void {
			__display.swapChildren(child1, child2);
		}

		public function getObjectsUnderPoint(point : Point) : Array {
			return __display.getObjectsUnderPoint(point);
		}

		public function get mouseChildren() : Boolean {
			return __display.mouseChildren;
		}

		public function removeChildAt(index : int) : DisplayObject {
			return __display.removeChildAt(index);
		}

		public function set tabChildren(enable : Boolean) : void {
			__display.tabChildren = enable;
		}

		public function areInaccessibleObjectsUnderPoint(point : Point) : Boolean {
			return __display.areInaccessibleObjectsUnderPoint(point);
		}

		public function removeChild(child : DisplayObject) : DisplayObject {
			return __display.removeChild(child);
		}
		
		////////////////////////////////////////////////////////////////////////////////////
		// Interactive Object Functions ////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////
		
		public function get tabEnabled() : Boolean {
			return __display.tabEnabled;
		}

		public function get doubleClickEnabled() : Boolean {
			return __display.doubleClickEnabled;
		}

		public function set contextMenu(cm : ContextMenu) : void {
			__display.contextMenu = cm;
		}

		public function get accessibilityImplementation() : AccessibilityImplementation {
			return __display.accessibilityImplementation;
		}

		public function set doubleClickEnabled(enabled : Boolean) : void {
			__display.doubleClickEnabled = enabled;
		}

		public function get contextMenu() : ContextMenu {
			return __display.contextMenu;
		}

		public function get mouseEnabled() : Boolean {
			return __display.mouseEnabled;
		}

		public function set focusRect(focusRect : Object) : void {
			__display.focusRect = focusRect;
		}

		public function get tabIndex() : int {
			return __display.tabIndex;
		}

		public function set mouseEnabled(enabled : Boolean) : void {
			__display.mouseEnabled = enabled;
		}

		public function get focusRect() : Object {
			return __display.focusRect;
		}

		public function set tabEnabled(enabled : Boolean) : void {
			__display.tabEnabled = enabled;
		}

		public function set accessibilityImplementation(value : AccessibilityImplementation) : void {
			__display.accessibilityImplementation = value;
		}

		public function set tabIndex(index : int) : void {
			__display.tabIndex = index;
		}
		
		////////////////////////////////////////////////////////////////////////////////////
		// Display Object Functions ////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////
		
		public function get y() : Number {
			return __display.y;
		}

		public function get transform() : Transform {
			return __display.transform;
		}

		public function get stage() : Stage {
			return __display.stage;
		}

		public function localToGlobal(point : Point) : Point {
			return __display.localToGlobal(point);
		}

		public function get name() : String {
			return __display.name;
		}

		public function set width(value : Number) : void {
			__display.width = value;
		}

		public function get blendMode() : String {
			return __display.blendMode;
		}

		public function get scale9Grid() : Rectangle {
			return __display.scale9Grid;
		}

		public function set name(value : String) : void {
			__display.name = value;
		}

		public function set scaleX(value : Number) : void {
			__display.scaleX = value;
		}

		public function set scaleY(value : Number) : void {
			__display.scaleY = value;
		}

		public function get accessibilityProperties() : AccessibilityProperties {
			return __display.accessibilityProperties;
		}

		public function set scrollRect(value : Rectangle) : void {
			__display.scrollRect = value;
		}

		public function get cacheAsBitmap() : Boolean {
			return __display.cacheAsBitmap;
		}

		public function globalToLocal(point : Point) : Point {
			return __display.globalToLocal(point);
		}

		public function get height() : Number {
			return __display.height;
		}

		public function set blendMode(value : String) : void {
			__display.blendMode = value;
		}

		public function get parent() : DisplayObjectContainer {
			return __display.parent;
		}

		public function getBounds(targetCoordinateSpace : DisplayObject) : Rectangle {
			return __display.getBounds(targetCoordinateSpace);
		}

		public function get opaqueBackground() : Object {
			return __display.opaqueBackground;
		}

		public function set scale9Grid(innerRectangle : Rectangle) : void {
			__display.scale9Grid = innerRectangle;
		}

		public function set alpha(value : Number) : void {
			__display.alpha = value;
		}

		public function set accessibilityProperties(value : AccessibilityProperties) : void {
			__display.accessibilityProperties = value;
		}

		public function get width() : Number {
			return __display.width;
		}

		public function hitTestPoint(x : Number, y : Number, shapeFlag : Boolean = false) : Boolean {
			return __display.hitTestPoint(x, y, shapeFlag);
		}

		public function get scaleX() : Number {
			return __display.scaleX;
		}

		public function get scaleY() : Number {
			return __display.scaleY;
		}

		public function get mouseX() : Number {
			return __display.mouseX;
		}

		public function set height(value : Number) : void {
			__display.height = value;
		}

		public function set mask(value : DisplayObject) : void {
			__display.mask = value;
		}

		public function getRect(targetCoordinateSpace : DisplayObject) : Rectangle {
			return __display.getRect(targetCoordinateSpace);
		}

		public function get mouseY() : Number {
			return __display.mouseY;
		}

		public function get alpha() : Number {
			return __display.alpha;
		}

		public function set transform(value : Transform) : void {
			__display.transform = value;
		}

		public function get scrollRect() : Rectangle {
			return __display.scrollRect;
		}

		public function get loaderInfo() : LoaderInfo {
			return __display.loaderInfo;
		}

		public function get root() : DisplayObject {
			return __display.root;
		}

		public function set visible(value : Boolean) : void {
			__display.visible = value;
		}

		public function set opaqueBackground(value : Object) : void {
			__display.opaqueBackground = value;
		}

		public function set cacheAsBitmap(value : Boolean) : void {
			__display.cacheAsBitmap = value;
		}

		public function hitTestObject(obj : DisplayObject) : Boolean {
			return __display.hitTestObject(obj);
		}

		public function set x(value : Number) : void {
			__display.x = value;
		}

		public function set y(value : Number) : void {
			__display.y = value;
		}

		public function get mask() : DisplayObject {
			return __display.mask;
		}

		public function set filters(value : Array) : void {
			__display.filters = value;
		}

		public function get x() : Number {
			return __display.x;
		}

		public function get visible() : Boolean {
			return __display.visible;
		}

		public function get filters() : Array {
			return __display.filters;
		}

		public function set rotation(value : Number) : void {
			__display.rotation = value;
		}

		public function get rotation() : Number {
			return __display.rotation;
		}
		
		////////////////////////////////////////////////////////////////////////////////////
		// Event Dispatcher Functions //////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////
		
		public function dispatchEvent(event : Event) : Boolean {

			return __display.dispatchEvent(event);
		}

		public function willTrigger(type : String) : Boolean {
			return __display.willTrigger(type);
		}

//		public function toString() : String {
//			return __display.toString();
//		}

		public function removeEventListener(type : String, listener : Function, useCapture : Boolean = false) : void {
			__display.removeEventListener(type, listener, useCapture);
		}

		public function hasEventListener(type : String) : Boolean {
			return __display.hasEventListener(type);
		}

		public function addEventListener(type : String, listener : Function, useCapture : Boolean = false, priority : int = 0, useWeakReference : Boolean = true) : void {
			__display.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
	}
}
