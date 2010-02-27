package com.sequencer.manager {
	import com.sequencer.element.Node;
	
	/**
	 * @author fuel
	 */
	public class NodeFactory {
	
		private static const NODE_SIZE:Number = 25;
		
		public static function createLine(x:Number, y:Number, slope:Number, nodeLength:int):Node
		{
			var nodes:Array = new Array();
			
			for(var i:int = 0; i < nodeLength; i++)
			{
				var node:Node = new Node();
				node.linkDisplay();
				node.x = x + (NODE_SIZE * i * (1/slope));
				node.y = y + (NODE_SIZE * i * slope);
			}
			
			linkNodes(nodes);
			
			return nodes[0];
		}
		
		private static function linkNodes(nodes:Array) : void{
			for(var i:int = 1; i < nodes.length; i++)
			{
				(nodes[i - 1] as Node).childNodes.push(nodes[i]);
			}
		}
	}
}
