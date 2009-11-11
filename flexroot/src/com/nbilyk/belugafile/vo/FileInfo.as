package com.nbilyk.belugafile.vo {
	import com.nbilyk.utils.MathUtils;
	
	import flash.events.EventDispatcher;
	import flash.filesystem.File;

	[Bindable]
	public class FileInfo extends EventDispatcher {
		private static const MIN_READ_AHEAD:Number = 32 * 1024; // 32K
		private static const MAX_READ_AHEAD:Number = 1 * 1024 * 1024; // 1M
		
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
		public function getReadAhead():Number {
			return MathUtils.clamp(size / 100, MIN_READ_AHEAD, MAX_READ_AHEAD);
		}

	}
}