package com.valkryie.data.vo.actor.brush {
	import com.valkryie.data.vo.actor.AbstractActorVO;
	import com.valkryie.editor.elements.editor_panel.properties.statics.PropertyStatics;
	import com.valkryie.editor.elements.editor_panel.properties.vo.PropertyVO;

	/**
	 * @author jkeon
	 */
	public class AbstractBrushVO extends AbstractActorVO {
		
		
		public function AbstractBrushVO() {
			super();
		}

		
		override public function set isoX(_isoX : int) : void {
			if (_isoX < 0) {
				_isoX = 0;
			}
			super.isoX = _isoX;
		}

		override public function set isoY(_isoY : int) : void {
			if (_isoY < 0) {
				_isoY = 0;
			}
			super.isoY = _isoY;
		}

		override public function set isoWidth(_isoWidth : int) : void {
			super.isoWidth = _isoWidth;
			subDivisionsXSize = isoWidth/subDivisionsX;
		}

		override public function set isoDepth(_isoDepth : int) : void {
			super.isoDepth = _isoDepth;
			subDivisionsYSize = isoDepth/subDivisionsY;
		}

		
		
		
		public function get subDivisionsX() : int {
			return get("subDivisionsX");
		}
		
		public function set subDivisionsX(_subDivisionsX : int) : void {
			if (_subDivisionsX < 1) {
				_subDivisionsX = 1;
			}
			subDivisionsXSize = isoWidth/_subDivisionsX;
			set("subDivisionsX", _subDivisionsX);
		}
		
		public function get subDivisionsY() : int {
			return get("subDivisionsY");
		}
		
		public function set subDivisionsY(_subDivisionsY : int) : void {
			if (_subDivisionsY < 1) {
				_subDivisionsY = 1;
			}
			subDivisionsYSize = isoDepth/_subDivisionsY;
			set("subDivisionsY", _subDivisionsY);
		}
		
		
		public function get subDivisionsXSize() : Number {
			return get("subDivisionsXSize");
		}
		
		public function set subDivisionsXSize(_subDivisionsXSize : Number) : void {
			set("subDivisionsXSize", _subDivisionsXSize);
		}
		
		public function get subDivisionsYSize() : Number {
			return get("subDivisionsYSize");
		}
		
		public function set subDivisionsYSize(_subDivisionsYSize : Number) : void {
			set("subDivisionsYSize", _subDivisionsYSize);
		}

		
		override protected function generateProperties() : void {
			__properties = [];
			
			for (var b in _props) {
				var pvo:PropertyVO = new PropertyVO();
				pvo.propertyName = b;
				pvo.dataVO = this;
				if (pvo.propertyName == "subDivisionsXSize" || pvo.propertyName == "subDivisionsYSize") {
					pvo.type = PropertyStatics.TYPE_READ_ONLY;
				} 
				else {
					pvo.type = determineType(_props[b]);
				}
				__properties.push(pvo);
			}
			
			__properties.sortOn("propertyName");
		}
	}
}
