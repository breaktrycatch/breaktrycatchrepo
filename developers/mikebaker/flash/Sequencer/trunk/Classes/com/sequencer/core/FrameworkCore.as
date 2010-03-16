package com.sequencer.core {
	import com.fuelindustries.utils.IntervalManager;
	import com.fuelindustries.utils.IntervalCall;
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
		protected const INTERVAL_UPDATE:int = 200;
		
		protected var _currentNode:Node;
		protected var _updateIntervalID:int = IntervalManager.setInterval(onUpdateInterval, 200);
		protected var _lastUpdate : Number;

		
		override protected function onAdded(e : Event) : void {
			super.onAdded(e);
			
			_currentNode = NodeFactory.createLine(50, 50, 0, 2, 5);

//			_currentNode = NodeFactory.createCircle(100, 100, 50);
//			var lastNode:Node = getEndNode(_currentNode);
			addLinkedNodes(_currentNode);
//			lastNode.childNodes.push(_currentNode);
			
			addEventListener(MouseEvent.CLICK, onClick);
		}
		
		protected function getEndNode(startNode:Node):Node
		{
			var node:Node;
			for(node = startNode.childNodes[0]; node != null; node.childNodes[0]){}
			
			return node;
		}
		
		protected function addLinkedNodes(thisNode:Node):void
		{
			if(thisNode.parent == null)
			{
				dtrace("AddingNode:", thisNode.x, thisNode.y);
				addChild(thisNode.display);
				
				for each (var node : Node in thisNode.childNodes) {
					addLinkedNodes(node);
				}
			}
		}

		
		private function onClick(e : MouseEvent) : void {
			if(e.target[AssetProxy.PROXYCODE] is Node)
			{
				var node:Node = e.target[AssetProxy.PROXYCODE] as Node;
				
				node.flipState();
			}
		}
		
		private function onUpdateInterval(...args) : void {
			_lastUpdate = new Date().time;
			updateChildNodes(_currentNode);
		}
		
		protected function updateChildNodes(thisNode:Node, flipState:Boolean = false):void
		{
			thisNode.lastUpdate = _lastUpdate;
			
			for each (var node : Node in thisNode.childNodes) {
				if(node.lastUpdate < _lastUpdate)
				{
					updateChildNodes(node, thisNode.currentState == Node.STATE_ON);
				}
			}
			
			
			if(flipState || thisNode.currentState == Node.STATE_ON) {
				thisNode.flipState();
			}
			
		}
		
	}
	
	
	
}
