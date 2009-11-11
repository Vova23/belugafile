package com.nbilyk.belugafile.events {
	import flash.events.Event;
	import flash.utils.ByteArray;

	public class FileReceiveEvent extends Event {
		public static const DATA_RECEIVED:String = "dataReceived";

		public var autoRequestNext:Boolean = true;
		public var inputBuffer:ByteArray;
		public var offset:uint = 0;

		public function FileReceiveEvent(type:String, inputBufferVal:ByteArray, offsetVal:uint, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
			inputBuffer = inputBufferVal;
			offset = offsetVal;
		}

	}
}