package com.fuelindustries.view
{
	import com.fuelindustries.core.FuelUI;
	import com.fuelindustries.events.ViewEvent;

	/**
	 * Dispatched when the view should change section.
	 * 
     * @eventType com.fuelindustries.events.ViewEvent.CHANGE
     * 
	 */
	[Event(name="changeSection", type="com.fuelindustries.events.ViewEvent")]
	
	/**
	 * Dispatched when the view has completed it's out transition and is ready to be removed by the View manager
	 * 
     * @eventType com.fuelindustries.events.ViewEvent.OUT_COMPLETE
     * 
	 */
	[Event(name="outComplete", type="com.fuelindustries.events.ViewEvent")]
    
    
    /**
    * Abstract View Class 
    * Always subclassed - therefore an abstract class, never used directly.
    */
	public class AbstractView extends FuelUI 
	{
		
		public function AbstractView()
		{
			super();
		}
		
		/**
		* Gets called when attached from it's ViewManager with an initObject. This method should be overwritten in 
		* subclasses. This method is called just before it is added to the stage but after linkDisplay is called.
		* @param initObject an object with properties that tell the view how to initialize when attached
		**/
		public function initialize( initObject:Object ):void
		{
					
		}
		
		/**
		 * This method is called by the ViewManager to start the out transition of the view
		 */
		public function playOut():void
		{
			this.gotoAndPlay("out");
		}
		
		/**
		 * This method is called when you want to change sections. 
		 * 
		 * @param section The new section you want to go to.
		 * 
		 */
		public function changeSection( section:String, initObject:Object ):void
		{
			var event:ViewEvent = new ViewEvent(ViewEvent.CHANGE,section, initObject);
			dispatchEvent(event);
		}
		
		/**
		 * This method is called when the out transition has completed
		 */
		public function outComplete():void
		{
			var event:ViewEvent = new ViewEvent(ViewEvent.OUT_COMPLETE);
			dispatchEvent(event);
		}
	}
}