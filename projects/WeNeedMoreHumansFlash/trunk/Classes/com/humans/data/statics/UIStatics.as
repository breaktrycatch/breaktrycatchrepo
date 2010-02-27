package com.humans.data.statics {
	import com.humans.ui.view.TowerGalleryView;
	import com.humans.ui.modal.BlankModal;
	import com.humans.ui.view.BlankView;
	import com.humans.ui.view.GalleryView;

	import flash.utils.getQualifiedClassName;

	/**
	 * @author jkeon
	 */
	public class UIStatics extends Object {
		
		
		public static const VIEW_BLANK:String = getQualifiedClassName(BlankView);
		public static const VIEW_GALLERY:String = getQualifiedClassName(GalleryView);
		public static const VIEW_TOWERGALLERY:String = getQualifiedClassName(TowerGalleryView);
		
		public static const MODAL_BLANK:String = getQualifiedClassName(BlankModal);
		
		private static var __views:Array = [VIEW_BLANK, VIEW_GALLERY, VIEW_TOWERGALLERY];
		private static var __modals:Array = [MODAL_BLANK];
		
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
