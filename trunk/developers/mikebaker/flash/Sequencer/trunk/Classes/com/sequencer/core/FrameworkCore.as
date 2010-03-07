package com.sequencer.core {
	import com.fuelindustries.AbstractMain;
	import com.fuelindustries.core.AssetProxy;
	import com.sequencer.element.Node;
	import com.sequencer.manager.NodeFactory;

	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * @author fuel
	 */
	 
	 
	public class FrameworkCore extends AbstractMain{
		protected var _currentNode:Node;

		override protected function onAdded(e : Event) : void {
			super.onAdded(e);
			
			_currentNode = NodeFactory.createLine(50, 50, 0, 2, 5);
//			_currentNode = NodeFactory.createCircle(50, 50, 5);
			
			addLinkedNodes(_currentNode);
			
			addEventListener(MouseEvent.CLICK, onClick);
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		protected function addLinkedNodes(thisNode:Node):void
		{
			dtrace("AddingNode:", thisNode.x, thisNode.y);
			addChild(thisNode.display);
			
			for each (var node : Node in thisNode.childNodes) {
				addLinkedNodes(node);
			}
		}

		
		private function onClick(e : MouseEvent) : void {
			if(e.target[AssetProxy.PROXYCODE] is Node)
			{
				var node:Node = e.target[AssetProxy.PROXYCODE] as Node;
				
				node.flipState();
			}
		}
		
		private function onEnterFrame(e : Event) : void {
			updateChildNodes(_currentNode);
		}
		
		protected function updateChildNodes(thisNode:Node, flipState:Boolean = false):void
		{
			
			for each (var node : Node in thisNode.childNodes) {
				
				updateChildNodes(node, thisNode.currentState == Node.STATE_ON);					
//					node.flipState();
			}
			
			
			if(flipState || thisNode.currentState == Node.STATE_ON) {
				thisNode.flipState();
			}
			
			
			
		}
		
	}
	
	
	
}
