package com.sequencer.manager {
	import com.sequencer.element.Node;
	
	/**
	 * @author fuel
	 */
	public class NodeFactory {
	
		private static const PI_2:Number = 2 * Math.PI;
		public static const NODE_SIZE:Number = 25;
		
		public static function createLine(x:Number, y:Number, rise:int, run:int, nodeLength:int):Node
		{
			var nodes:Array = new Array();
			
			for(var i:int = 0; i < nodeLength; i++)
			{
				var node:Node = new Node();
				node.linkDisplay();
				node.x = x + (NODE_SIZE * i * run);
				node.y = y + (NODE_SIZE * i * rise);
				
				nodes.push(node);
			}
			
			linkNodes(nodes);
			
			return nodes[0];
		}
		
		public static function createCircle(x:Number, y:Number, radius:int):Node
		{
			// c = 2PIr
			var angleStep:Number = PI_2 / ((PI_2 * radius)/(NODE_SIZE + 10));
//			var angleStep:Number = (PI_2 * radius * NODE_SIZE)/PI_2;
			var nodes:Array = new Array();
			
			for(var angle:Number = 0; angle < PI_2; angle += angleStep)
			{
				var node:Node = new Node();
				node.linkDisplay();
				node.x = radius * Math.cos(angle) + x;
				node.y = radius * Math.sin(angle) + y;
				
				nodes.push(node);
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
