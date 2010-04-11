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
		protected const INTERVAL_UPDATE:int = 50;
		
		protected var _currentNode:Node;
		protected var _updateIntervalID:int = IntervalManager.setInterval(onUpdateInterval, INTERVAL_UPDATE);
		protected var _lastUpdate : Number;

		
		override protected function onAdded(e : Event) : void {
			super.onAdded(e);
			
			var line:Node = NodeFactory.createLine(350 - NodeFactory.NODE_SIZE, 200, 0, -2, 6);
			
			_currentNode = NodeFactory.createCircle(200, 200, 150);
			//connect the circle
			var lastNode:Node = getEndNode(_currentNode);
			lastNode.childNodes.push(_currentNode);
			
			//connect first node of line to circle
			_currentNode.childNodes.push(line);
			
			
			//connect last node of line to halfway through the circle
			lastNode = getEndNode(line);
			var searchNode: Node = _currentNode.childNodes[0];
			while(searchNode.x > lastNode.x || searchNode.y > lastNode.y)
			{
				searchNode = searchNode.childNodes[0];
			}
			lastNode.childNodes.push(searchNode);
			
			
			//Add the nodes to the stage 
			addLinkedNodes(_currentNode);
			
			addEventListener(MouseEvent.CLICK, onClick);
		}
		
		protected function getEndNode(startNode:Node):Node
		{
			var node:Node;
			for(node = startNode.childNodes[0]; node.childNodes.length > 0; node = node.childNodes[0]){}
			
			return node;
		}
		
		protected function addLinkedNodes(thisNode:Node):void
		{
			if(thisNode.parent == null)
			{
				dtrace("AddingNode:", thisNode.x, thisNode.y);
				addChild(thisNode.display);
				
				for each (var node : Node in thisNode.childNodes) {
					if(node.parent == null)
					{
						addLinkedNodes(node);
					}
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
			update();
//			updateChildNodes(_currentNode);
		}
		
		protected function update():void
		{
			var onNodes:Array = findOnNodes(_currentNode);
//			dtrace("ON NODES:", onNodes.length);
			for each (var onNode : Node in onNodes) {
				onNode.flipState();
				
				for each (var node : Node in onNode.childNodes) {
					node.flipState();
				}
			}
		}
		
		private function findOnNodes(searchNode:Node):Array 
		{
			searchNode.lastUpdate = _lastUpdate;
			
			var onNodes:Array = new Array();
			
			if(searchNode.currentState == Node.STATE_ON)
			{
				onNodes.push(searchNode);
//				dtrace("FOUND ON NODE");
			}
			
			for each (var node : Node in searchNode.childNodes) 
			{
				if(node.lastUpdate < _lastUpdate)
				{
					onNodes = onNodes.concat(findOnNodes(node));
				}
			}
			
			return onNodes;
		}

//		protected function updateChildNodes(thisNode:Node, flipState:Boolean = false):void
//		{
//			thisNode.lastUpdate = _lastUpdate;
//			
//			for each (var node : Node in thisNode.childNodes) {
//				if(node.lastUpdate < _lastUpdate)
//				{
//					updateChildNodes(node, thisNode.currentState == Node.STATE_ON);
//				}
//			}
//			
//			
//			if(flipState || thisNode.currentState == Node.STATE_ON) {
//				thisNode.flipState();
//			}
//			
//		}
		
	}
	
	
	
}
