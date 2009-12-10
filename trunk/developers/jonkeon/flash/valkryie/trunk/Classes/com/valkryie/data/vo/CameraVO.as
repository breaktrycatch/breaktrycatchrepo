package com.valkryie.data.vo {
	import com.valkryie.data.enum.Enum;
	import com.valkryie.editor.elements.editor_panel.properties.statics.PropertyStatics;
	import com.valkryie.editor.elements.editor_panel.properties.vo.PropertyVO;

	/**
	 * @author jkeon
	 */
	public class CameraVO extends AbstractDataVO {
		
		public static const LOC_NORTH:int = 2;
		public static const LOC_EAST:int = 3;
		public static const LOC_SOUTH:int = 0;
		public static const LOC_WEST:int = 1;
		protected var __cameraLocationEnum:Enum;
		
		public function CameraVO() {
			
			//Setup Enums for Camera Locations
			__cameraLocationEnum = new Enum();
			__cameraLocationEnum.addEnum("SOUTH", LOC_SOUTH);
			__cameraLocationEnum.addEnum("WEST", LOC_WEST);
			__cameraLocationEnum.addEnum("NORTH", LOC_NORTH);
			__cameraLocationEnum.addEnum("EAST", LOC_EAST);
			super();
			//Defaults of -1 will cause the Camera to Center in the middle of the Level
			cameraStartIsoX = -1;
			cameraStartIsoY = -1;
			cameraViewSpaceX = 0;
			cameraViewSpaceY = 0;
			cameraViewSpaceWidth = 760;
			cameraViewSpaceHeight = 500;
			cameraLocation = LOC_SOUTH;
		}
		
		protected override function generateProperties():void {
			__properties = [];
			
			for (var b in _props) {
				var pvo:PropertyVO = new PropertyVO();
				pvo.propertyName = b;
				pvo.dataVO = this;
				if (pvo.propertyName == "cameraLocation") {
					pvo.type = PropertyStatics.TYPE_ENUM;
					pvo.enum = __cameraLocationEnum;
				} else {
					pvo.type = determineType(_props[b]);
				}
				__properties.push(pvo);
			}
			
			__properties.sortOn("propertyName");
			
		}
		
		
		public function get cameraViewSpaceX() : int {
			return get("cameraViewSpaceX");
		}
		
		public function set cameraViewSpaceX(_cameraViewSpaceX:int) : void {
			set("cameraViewSpaceX", _cameraViewSpaceX);
		}
		
		public function get cameraViewSpaceY() : int {
			return get("cameraViewSpaceY");
		}
		
		public function set cameraViewSpaceY(_cameraViewSpaceY:int) : void {
			set("cameraViewSpaceY", _cameraViewSpaceY);
		}
		
		public function get cameraViewSpaceWidth() : int {
			return get("cameraViewSpaceWidth");
		}
		
		
		public function set cameraViewSpaceWidth(_cameraViewSpaceWidth:int) : void {
			if (_cameraViewSpaceWidth < 1) {
				_cameraViewSpaceWidth = 1;
			}
			set("cameraViewSpaceWidth", _cameraViewSpaceWidth);
		}
		
		public function get cameraViewSpaceHeight() : int {
			return get("cameraViewSpaceHeight");
		}
		
		
		public function set cameraViewSpaceHeight(_cameraViewSpaceHeight:int) : void {
			if (_cameraViewSpaceHeight < 1) {
				_cameraViewSpaceHeight = 1;
			}
			set("cameraViewSpaceHeight", _cameraViewSpaceHeight);
		}
		
		
		
		public function get cameraLocation() : int {
			return get("cameraLocation");
		}
		
		public function set cameraLocation(_cameraLocation:int) : void {
			_cameraLocation = __cameraLocationEnum.validate(_cameraLocation);
			set("cameraLocation", _cameraLocation);
		}
		
		
	
		public function get cameraStartIsoX() : int {
			return get("cameraStartIsoX");
		}
		
		public function set cameraStartIsoX(_cameraStartIsoX:int) : void {
			if (_cameraStartIsoX < -1) {
				_cameraStartIsoX = -1;
			}
			set("cameraStartIsoX", _cameraStartIsoX);
		}
		
		public function get cameraStartIsoY() : int {
			return get("cameraStartIsoY");
		}
		
		public function set cameraStartIsoY(_cameraStartIsoY:int) : void {
			if (_cameraStartIsoY < -1) {
				_cameraStartIsoY = -1;
			}
			set("cameraStartIsoY", _cameraStartIsoY);
		}
		
	}
}
