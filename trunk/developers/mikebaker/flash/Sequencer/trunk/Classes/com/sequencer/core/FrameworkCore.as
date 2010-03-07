package com.sequencer.core {
	import flash.events.Event;

	import com.fuelindustries.AbstractMain;
	import com.sequencer.element.Node;
	import com.sequencer.manager.NodeFactory;

	/**
	 * @author fuel
	 */
	 
	 
	public class FrameworkCore extends AbstractMain{
		protected var _currentNode:Node;

		override protected function onAdded(e : Event) : void {
			super.onAdded(e);
			
			_currentNode = NodeFactory.createLine(50, 50, 2, 5);
			
			addLinkedNodes(_currentNode);
		}

		
		protected function addLinkedNodes(thisNode:Node):void
		{
			addChild(thisNode.display);
			dtrace("AddingNode:", thisNode.x, thisNode.y);
			
			for each (var node : Node in thisNode.childNodes) {
				addLinkedNodes(node);
			}
		}
	}
	
	
	
}
