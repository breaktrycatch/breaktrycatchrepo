package com.valkryie.actor.events {
	import com.valkryie.actor.AbstractActor;

	import flash.events.Event;

	/**
	 * @author jkeon
	 */
	public class ActorEvent extends Event {
		
		public static const ACTOR_SELECTED:String = "actor_selected";
		
		private var __actor:AbstractActor;
		
		public function ActorEvent(type : String, _actor:AbstractActor, bubbles : Boolean = true, cancelable : Boolean = false) {
			super(type, bubbles, cancelable);
			__actor = _actor;
		}
		
		public function get actor() : AbstractActor {
			return __actor;
		}
	}
}
