package com.nbilyk.belugafile.client {
	import com.nbilyk.belugafile.events.FileClientEvent;
	import com.nbilyk.belugafile.events.FileReceiveEvent;
	import com.nbilyk.belugafile.events.FileRequestEvent;
	import com.nbilyk.belugafile.vo.FileInfo;
	import com.nbilyk.stratus.StratusClient;
	
	import flash.events.Event;
	import flash.net.registerClassAlias;
	import flash.utils.ByteArray;
	
	import mx.collections.ArrayCollection;

	[Bindable]
	[Event(name="fileRequest", type="com.nbilyk.belugafile.events.FileRequestEvent")]
	[Event(name="dataReceived", type="com.nbilyk.belugafile.events.FileReceiveEvent")]
	[Event(name="cancelDownload", type="com.nbilyk.belugafile.events.FileClientEvent")]
	[Event(name="cancelUpload", type="com.nbilyk.belugafile.events.FileClientEvent")]
	public class BelugaFileClient extends StratusClient {

		[ArrayElementType("com.nbilyk.belugafile.vo.FileInfo")]
		public var fileInfos:ArrayCollection;

		public function BelugaFileClient() {
			super();
			registerClassAlias("mx.collections.ArrayCollection", ArrayCollection);
			registerClassAlias("com.nbilyk.belugafile.vo.FileInfo", FileInfo);
		}
		public function updateFileInfos(value:ArrayCollection):void {
			fileInfos = value;
		}
		public function requestFile(fileInfo:FileInfo, offset:uint = 0):void {
			if (offset > fileInfo.size) throw new Error("offset cannot be greater than the file size");
			dispatchEvent(new FileRequestEvent(FileRequestEvent.FILE_REQUEST, fileInfo, offset));
		}
		public function receiveFile(inputBuffer:ByteArray, offset:uint):void {
			dispatchEvent(new FileReceiveEvent(FileReceiveEvent.DATA_RECEIVED, inputBuffer, offset));
		}
		/**
		 * Call to cancel a file upload
		 */
		public function cancelUpload():void {
			dispatchEvent(new FileClientEvent(FileClientEvent.CANCEL_UPLOAD));
		}
		/**
		 * Call to cancel a file download
		 */
		public function cancelDownload():void {
			dispatchEvent(new FileClientEvent(FileClientEvent.CANCEL_DOWNLOAD));
		}
	}
}