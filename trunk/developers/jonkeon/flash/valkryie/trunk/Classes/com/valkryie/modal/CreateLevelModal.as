package com.valkryie.modal {
	import com.fuelindustries.controls.BaseList;
	import com.fuelindustries.controls.Label;
	import com.fuelindustries.controls.buttons.EaseButton;
	import com.fuelindustries.events.ViewEvent;
	import com.valkryie.data.statics.UIStatics;
	import com.valkryie.data.vo.level.CameraVO;
	import com.valkryie.data.vo.level.LevelVO;
	import com.valkryie.editor.elements.editor_panel.properties.controls.PropertyCellRenderer;
	import com.valkryie.manager.game.GameStateManager;

	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	/**
	 * @author jkeon
	 */
	public class CreateLevelModal extends BaseModal {
		
		public var title_mc:Label;
		public var levelTitle_mc:Label;
		public var cameraTitle_mc:Label;
		
		public var okButton_mc:EaseButton;
		
		public var levelPropList:MovieClip;
		protected var __levelPropList:BaseList;
		
		public var cameraPropList:MovieClip;
		protected var __cameraPropList:BaseList;
		
		
		protected var __levelVO:LevelVO;
		protected var __cameraVO:CameraVO;
		
		
		public function CreateLevelModal() {
			super();
			linkage = "Modal_CreateLevel";
		}

		override protected function completeConstruction() : void {
			super.completeConstruction();
			
			__levelVO = new LevelVO();
			__cameraVO = new CameraVO();
			
			
			//Level
			__levelPropList = new BaseList(PropertyCellRenderer);
			__levelPropList.setDisplayByClip(this.levelPropList);
			__levelPropList.dataProvider = __levelVO.properties;
			
			//Camera
			__cameraPropList = new BaseList(PropertyCellRenderer);
			__cameraPropList.setDisplayByClip(this.cameraPropList);
			__cameraPropList.dataProvider = __cameraVO.properties;
			
			okButton_mc.addEventListener(MouseEvent.CLICK, onOK);
			
		}
		
		protected function onOK(e:MouseEvent):void {
			okButton_mc.removeEventListener(MouseEvent.CLICK, onOK);
			dtrace("Let's make the level now");
			__levelVO.cameraData = __cameraVO;
			GameStateManager.getInstance().activeLevelVO = __levelVO;
			
			//dtrace("__levelVO " + JSON.encode(__levelVO.serialize()));
			//dtrace("__cameraVO " + JSON.encode(__cameraVO.serialize()));
			
			this.dispatchEvent(new ViewEvent(ViewEvent.CHANGE, UIStatics.VIEW_EDITOR));
			this.dispatchEvent(new ViewEvent(ViewEvent.CHANGE, UIStatics.MODAL_BLANK));
		}

		override public function destroy() : void {
			
			title_mc.destroy();
			title_mc = null;
			
			levelTitle_mc.destroy();
			levelTitle_mc = null;
			
			cameraTitle_mc.destroy();
			cameraTitle_mc = null;
			
			okButton_mc.removeEventListener(MouseEvent.CLICK, onOK);
			okButton_mc.destroy();
			okButton_mc = null;
			
			__levelPropList.destroy();
			__levelPropList = null;
			levelPropList = null;
			
			__cameraPropList.destroy();
			__cameraPropList = null;
			cameraPropList = null;
			
			
			__levelVO = null;
			__cameraVO = null;
			

			super.destroy();
		}
	}
}
