package com.valkryie.data.statics {
	import com.valkryie.editor.EditorView;
	import com.valkryie.modal.BlankModal;
	import com.valkryie.modal.CreateLevelModal;
	import com.valkryie.view.BlankView;
	import com.valkryie.view.ParticlesView;
	import com.valkryie.view.SandboxView;

	import flash.utils.getQualifiedClassName;

	/**
	 * @author jkeon
	 */
	public class UIStatics extends Object {
		
		public static const VIEW_SANDBOX:String = getQualifiedClassName(SandboxView);
		public static const VIEW_PARTICLES:String = getQualifiedClassName(ParticlesView);
		public static const VIEW_EDITOR:String = getQualifiedClassName(EditorView);
		public static const VIEW_BLANK:String = getQualifiedClassName(BlankView);
		
		public static const MODAL_CREATE_LEVEL:String = getQualifiedClassName(CreateLevelModal);
		public static const MODAL_BLANK:String = getQualifiedClassName(BlankModal);
		
		private static var __views:Array = [VIEW_PARTICLES,VIEW_EDITOR, VIEW_SANDBOX, VIEW_BLANK];
		private static var __modals:Array = [MODAL_BLANK, MODAL_CREATE_LEVEL];
		
		public function UIStatics() {
		}
		
		public static function isView(_candidate:String):Boolean {
			if (__views.indexOf(_candidate) != -1) {
				return true;	
			}
			return false;
		}
		
		public static function isModal(_candidate:String):Boolean {
			if (__modals.indexOf(_candidate) != -1) {
				return true;	
			}
			return false;
		}
	}
}
