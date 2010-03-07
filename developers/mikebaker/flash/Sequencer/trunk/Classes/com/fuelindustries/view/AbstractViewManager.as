package com.fuelindustries.view
{
	import com.fuelindustries.core.FuelUI;
	import com.fuelindustries.events.ViewEvent;

	import flash.utils.*;

	/**
	 * An Abstract View Manager. This class should always be subclassed and never used as is.
	 * It provides helper functions to change sections and animate views between each other
	 * 
	 */
	public class AbstractViewManager extends FuelUI
	{
		public var currentView:AbstractView;
		protected var __currentSection:String;
		protected var __initObject:Object; 
		
		public function AbstractViewManager()
		{
			super();
		}
		
		/**
	 	 * Public setter to set the current section 
		 * @ param section String name of the class formatted like 'com.fuelindustries_assetproxy.view.HomeView'
		 * @return	void
		 */
		public function get currentSection():String
		{
			return(__currentSection);
		}
		
		public function set currentSection(section:String):void
		{
			__currentSection = section;
		}
		
		/**
	 	 * Public method to change the section. 
		 * @param section String String name of the class formatted like 'com.fuelindustries.view.HomeView'
		 * @param initObject An initialization object to be passed into the View.initialize method before being atttached
		 * @return	void
		 */
		public function changeSection(section:String, initObject:Object = null):void
		{
		  currentSection = section;
		  __initObject = initObject;
		  if(section != null)
		  {
		  	if( currentView == null )
		  	{
		  		attachSection(section);
		  	}
		  	else
		  	{
		  		currentView.playOut();
		  	}
		  }
		}
		
		/**
	 	 * Method to attach the section. Uses the getDefinitionByName, which requires that you have all view 
	 	 * classes imported so it can do the lookup.
		 * @param section String String name of the class formatted like 'com.fuelindustries_assetproxy.view.HomeView
		 * @return	void
		 */
		protected function attachSection( p_section:String ):void
		{
			var classRef:Class = flash.utils.getDefinitionByName( p_section ) as Class;
            var instance:AbstractView = new classRef();
			instance.linkDisplay();

			currentView = instance as AbstractView;
            currentView.addEventListener(ViewEvent.OUT_COMPLETE,onOutComplete);
            currentView.addEventListener(ViewEvent.CHANGE,onSectionChange);
            
            if( __initObject != null )
            {
            	currentView.initialize(__initObject);
            	__initObject = null;	
            }
            addChild(currentView.display);
		}
		
		/**
	 	 * Callback for a view event CHANGE event. 
		 * @param event ViewEvent Object that 
		 * @return	void
		 */
		protected function onSectionChange(event:ViewEvent):void
		{
			var section:String = event.section;
			// If the current section is the section requested - might not be needed
			if(section != __currentSection)
			{
			   changeSection(section, event.initObject );
			}
			
		}
		
		/**
	 	 * Callback for the outComplete Removes the currentView.
		 * @param event ViewEvent Object that 
		 * @return	void
		 */
		protected function onOutComplete(event:ViewEvent):void
		{	
			currentView.removeEventListener(ViewEvent.OUT_COMPLETE,onOutComplete);
			currentView.removeEventListener(ViewEvent.CHANGE,onSectionChange);
			removeChild(currentView.display);
			currentView.destroy();
			attachSection(__currentSection);
			
		}
	}
}