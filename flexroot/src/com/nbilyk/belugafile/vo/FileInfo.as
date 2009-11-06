package com.nbilyk.belugafile.vo {
	import flash.events.EventDispatcher;
	import flash.filesystem.File;

	[Bindable]
	public class FileInfo extends EventDispatcher {
		public var path:String;
		public var name:String;
		public var size:Number;

		public function FileInfo(file:File = null) {
			super();
			if (file) {
				path = file.nativePath;
				name = file.name;
				size = file.size;
			}
		}

	}
}