package com.nbilyk.stratus.events {
	import flash.events.Event;
	import flash.net.NetStream;

	public class StratusEvent extends Event {
		public static const CONNECT_SUCCESS:String = "connectSuccess";
		public static const CONNECT_FAIL:String = "connectFail";
		public static const PUBLISH_START:String = "publishStart";
		public static const SUBSCRIBER_CONNECTED:String = "subscriberConnected";
		public static const SUBSCRIBER_DISCONNECTED:String = "subscriberDisconnected";
		public static const SUBSCRIBING_SUCCESS:String = "subscribingSuccess";
		public static const SUBSCRIBING_FAIL:String = "subscribingFail";
		
		public var stream:NetStream;
		
		public function StratusEvent(type:String, streamVal:NetStream = null, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
			stream = streamVal;
		}
		
	}
}