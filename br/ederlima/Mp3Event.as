package br.ederlima
{
	import flash.events.Event;
	
	/**
	 * Mp3Event 1.0
	 * @author Eder Lima
	 */
	public class Mp3Event extends Event 
	{
		public static const ON_START:String = "start";
		public static const ON_PROGRESS:String = "progress";
		public static const ON_COMPLETE:String = "complete";
		public static const ON_PAUSE:String = "pause";
		public static const ON_RESUME:String = "resume";
		public static const ON_STOP:String = "stop";
		public static const ON_NEXT:String = "next";
		public static const ON_PREVIOUS:String = "previous";
		public static const ON_PLAYLIST:String = "playlist";
		public static const ON_REPEAT:String = "repeat";
		public static const ON_SHUFFLE:String  = "shuffle";
		public static const ON_SEEK:String = "seek";
		public static const ON_ID3:String = "id3";
		public static const ON_LAST:String = "last";
		public static const ON_FIRST:String = "first";
		public static const ON_CHANGE:String = "change";
		public static const ON_XML:String = "xml";
		
		
		public var data:Object;
		
		public function Mp3Event(type:String, params:Object = null, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
			data = params;
		}
		
		public override function clone():Event
		{
			return new Mp3Event(this.type, data, this.bubbles, this.cancelable);
		}
		
		public override function toString():String
        {
            return formatToString("Mp3Event", "data", "type", "bubbles", "cancelable");
        }
	}
	
}