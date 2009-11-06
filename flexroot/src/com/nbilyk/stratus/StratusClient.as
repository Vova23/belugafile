package com.nbilyk.stratus {
	import flash.events.Event;
	import flash.events.EventDispatcher;

	[Event(name="listeningAcknowledged", type="flash.events.Event")]
	public dynamic class StratusClient extends EventDispatcher {
		public static const LISTENING_ACKNOWLEDGED:String = "listeningAcknowledged";
		
		public var peerId:String;
		
		public var listeningAcknowledged:Boolean;
		
		public function StratusClient() {
			super();
		}
		public function setListeningAcknowledged():void {
			listeningAcknowledged = true;
			dispatchEvent(new Event(LISTENING_ACKNOWLEDGED));
		}
	}
}