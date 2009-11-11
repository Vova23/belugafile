package com.nbilyk.belugafile.vo {
	import com.nbilyk.sharedobject.AbstractPersistantData;

	public class Preferences extends AbstractPersistantData {
		public var lastUploadDirectory:String;
		public var lastDownloadDirectory:String;
		
		public function Preferences(autoFetch:Boolean = false) {
			super("preferences", autoFetch);
		}

	}
}