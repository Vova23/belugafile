package com.nbilyk.belugafile.events {
	import flash.events.Event;

	public class FileClientEvent extends Event {
		public static const DOWNLOAD_CANCEL:String = "downloadCancel";
		public static const UPLOAD_CANCEL:String = "uploadCancel";
		
		public function FileClientEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
		}

	}
}