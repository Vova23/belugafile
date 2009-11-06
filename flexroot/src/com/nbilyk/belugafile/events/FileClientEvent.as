package com.nbilyk.belugafile.events {
	import flash.events.Event;

	public class FileClientEvent extends Event {
		public static const CANCEL_DOWNLOAD:String = "cancelDownload";
		public static const CANCEL_UPLOAD:String = "cancelUpload";
		
		public function FileClientEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
		}

	}
}