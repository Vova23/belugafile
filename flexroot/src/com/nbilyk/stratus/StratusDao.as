package com.nbilyk.stratus {
	import __AS3__.vec.Vector;
	
	import com.nbilyk.stratus.events.StratusEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;
	
	[Event(name="connectSuccess", type="com.nbilyk.stratus.events.StratusEvent")]
	[Event(name="connectFail", type="com.nbilyk.stratus.events.StratusEvent")]
	[Event(name="publishStart", type="com.nbilyk.stratus.events.StratusEvent")]
	[Event(name="subscriberConnected", type="com.nbilyk.stratus.events.StratusEvent")]
	[Event(name="subscribingSuccess", type="com.nbilyk.stratus.events.StratusEvent")]
	[Event(name="subscribingFail", type="com.nbilyk.stratus.events.StratusEvent")]
	[Event(name="subscriberDisconnected", type="com.nbilyk.stratus.events.StratusEvent")]
	public class StratusDao extends EventDispatcher {
		public static const DATA:String = "data";
		
		public var connectTimeout:uint = 4000;
		public var peerConnectTimeout:uint = 2500;
		public var autoBiDirectional:Boolean = true;
		
		private static const STRATUS_ADDRESS:String = "rtmfp://stratus.adobe.com";
		
		public var connection:NetConnection;
		public var sendStream:NetStream;
		public var receiveStreams:Vector.<NetStream> = new Vector.<NetStream>();
		
		private var timeoutInterval:int;
		
		public var allowConnections:Boolean = true;
		
		public function StratusDao() {
		}
		public var clientFactory:Function = function():StratusClient {
			return new StratusClient();
		}
		
		public function connect(devKey:String):void {
			// Connect to stratus
			connection = new NetConnection();
			connection.addEventListener(NetStatusEvent.NET_STATUS, netConnectionHandler);
			connection.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			connection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			connection.connect(STRATUS_ADDRESS + "/" + devKey);
			timeoutInterval = setInterval(fail, connectTimeout);
		}
		private function netConnectionHandler(event:NetStatusEvent):void {
			switch (event.info.code) {
				case "NetConnection.Connect.Success" :
					// Stratus is now connected
					createSendStream();
					clearInterval(timeoutInterval);
					dispatchEvent(new StratusEvent(StratusEvent.CONNECT_SUCCESS));
					break;
				case "NetStream.Connect.Success" :
					break;
				case "NetStream.Publish.BadName" :
					fail();
					break;
				case "NetStream.Connect.Closed" :
					var stream:NetStream = NetStream(event.info.stream);
					disconnectFromPeer(stream.farID);
					dispatchEvent(new StratusEvent(StratusEvent.SUBSCRIBER_DISCONNECTED, stream));
					break;
			}
		}
		private function ioErrorHandler(event:IOErrorEvent):void {
			fail();
		}
		private function securityErrorHandler(event:SecurityError):void {
			fail();
		}
		private function fail():void {
			clearInterval(timeoutInterval);
			dispatchEvent(new StratusEvent(StratusEvent.CONNECT_FAIL));
		}
		private function createSendStream():void {
			sendStream = new NetStream(connection, NetStream.DIRECT_CONNECTIONS);
			sendStream.addEventListener(NetStatusEvent.NET_STATUS, sendStreamHandler);
			var o:Object = new Object();
			o.onPeerConnect = onPeerConnectHandler;
			sendStream.client = o;
			sendStream.publish(DATA);
		}
		private function onPeerConnectHandler(subscriber:NetStream):Boolean {
			if (!allowConnections) return false;
			subscriber.send("setListeningAcknowledged");
			if (autoBiDirectional) connectToPeer(subscriber.farID);
			dispatchEvent(new StratusEvent(StratusEvent.SUBSCRIBER_CONNECTED, subscriber));
			
			return true;
		}
		public function getIsPeerConnected(peerId:String):Boolean {
			for each (var existingStream:NetStream in receiveStreams) {
				// Already connected to this peer
				if (existingStream.farID == peerId) return true;
			}
			return false;
		}
		public function connectToPeer(peerId:String):NetStream {
			if (!peerId || peerId == connection.nearID) return null;
			if (getIsPeerConnected(peerId)) return null;
			
			var receiveStream:NetStream = new NetStream(connection, peerId);
			var stratusClient:StratusClient = clientFactory();
			if (!stratusClient) throw new Error("clientFactory must return a StratusClient object.");
			stratusClient.peerId = peerId;
			stratusClient.addEventListener(StratusClient.LISTENING_ACKNOWLEDGED, listeningAcknowledgedHandler, false, 0, true);
			receiveStream.client = stratusClient;
			receiveStream.addEventListener(NetStatusEvent.NET_STATUS, receiveStreamHandler);
			receiveStream.play(DATA);
			receiveStreams.push(receiveStream);
			setTimeout(peerConnectTimeoutHandler, peerConnectTimeout, receiveStream);
			return receiveStream;
		}
		private function listeningAcknowledgedHandler(event:Event):void {
			var stratusClient:StratusClient = StratusClient(event.currentTarget);
			var receiveStream:NetStream = getReceiveStreamById(stratusClient.peerId);
			dispatchEvent(new StratusEvent(StratusEvent.SUBSCRIBING_SUCCESS, receiveStream));
		}
		private function peerConnectTimeoutHandler(receiveStream:NetStream):void {
			if (!receiveStream.client) return;
			if (!StratusClient(receiveStream.client).listeningAcknowledged) {
				dispatchEvent(new StratusEvent(StratusEvent.SUBSCRIBING_FAIL, receiveStream));
			}
		}
		public function disconnectFromPeer(peerId:String):Boolean {
			var n:uint = receiveStreams.length;
			for (var i:uint = 0; i < n; i++) {
				var stream:NetStream = NetStream(receiveStreams[i]);
				if (stream.farID == peerId) {
					stream.close();
					receiveStreams.splice(i, 1);
					return true;
				}
			}
			return false;
		}
		private function sendStreamHandler(event:NetStatusEvent):void {
			switch (event.info.code) {
				case ("NetStream.Publish.Start") :
					dispatchEvent(new StratusEvent(StratusEvent.PUBLISH_START))
					break;
				case ("NetStream.Play.Reset") :
					break;
				case ("NetStream.Play.Start") :
					break;
			}
		}
		private function receiveStreamHandler(event:NetStatusEvent):void {
			switch (event.info.code) {
				case ("NetStream.Publish.Start") :
				case ("NetStream.Play.Reset") :
				case ("NetStream.Play.Start") :
					
					break;
			}
		}
		public function getPeerStreamById(id:String):NetStream {
			for each (var stream:NetStream in sendStream.peerStreams) {
				if (stream.farID == id) return stream;
			}
			return null;
		}
		public function getReceiveStreamById(id:String):NetStream {
			for each (var stream:NetStream in receiveStreams) {
				if (stream.farID == id) return stream;
			}
			return null;
		}
	}
}