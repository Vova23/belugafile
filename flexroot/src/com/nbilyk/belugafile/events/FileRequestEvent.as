package com.nbilyk.belugafile.events {
	import com.nbilyk.belugafile.vo.FileInfo;

	import flash.events.Event;

	public class FileRequestEvent extends Event {
		public static const FILE_REQUEST:String = "fileRequest";

		public var fileInfo:FileInfo;
		public var offset:uint = 0;

		public function FileRequestEvent(type:String, fileInfoVal:FileInfo, offsetVal:uint = 0, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
			fileInfo = fileInfoVal;
			offset = offsetVal;
		}

	}
}