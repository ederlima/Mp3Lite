package 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	import br.ederlima.Mp3Lite;
	import br.ederlima.Mp3Event;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author ...
	 */
	public class  Example extends MovieClip
	{
		private var player:Mp3Lite;
		private var myForm:TextFormat;
		
		private var n:Number = 1;
		private var tempVol:Number = 1;
				
		public function Example():void
		{
			configurePlayer();
			configureEvents();
			configureControls();
		}
		
		private function configurePlayer():void
		{
			myForm = new TextFormat;
			myForm.color = 0x94BA1F;
			myForm.font = "Arial";
			myForm.size = 11;
			down.volume = Number(-0.2);
			up.volume = Number(0.2);
			player = new Mp3Lite();
			player.setProgress(progresso, seekbar, bg);
			player.setID3Info(artista, musica, "No id3 Information");
			player.setTimeInfo(estado, atual, total);
			player.setPlaylist(pl, 280, myForm);
			//player.setXMLList("http://www.ederlima.com.br/arquivos/flash/001/orkutMP3List.xml");
			player.setXMLList("MP3List.xml");
			
			player.start();
		}
		private function configureEvents():void
		{
			// Events 
			player.addEventListener(Mp3Event.ON_START, function (e) { trace("started") } );
			player.addEventListener(Mp3Event.ON_PROGRESS, function (e){trace("progress")})
			player.addEventListener(Mp3Event.ON_PAUSE, function(e) { trace("paused") } );
			player.addEventListener(Mp3Event.ON_RESUME, function(e) { trace("resumed") } );
			player.addEventListener(Mp3Event.ON_STOP, function(e) { trace("stoped") } );
			player.addEventListener(Mp3Event.ON_NEXT, function(e) { trace("next song") } );
			player.addEventListener(Mp3Event.ON_PREVIOUS, function(e) { trace("previous song") } );
			player.addEventListener(Mp3Event.ON_REPEAT, function(e) { trace("repeating song") } );
			player.addEventListener(Mp3Event.ON_SHUFFLE, function(e) { trace("shuffling song") } );
			player.addEventListener(Mp3Event.ON_COMPLETE, function(e) { trace("song complete") } );
			player.addEventListener(Mp3Event.ON_PLAYLIST, function(e) { trace("playlist loaded") } );
			player.addEventListener(Mp3Event.ON_SEEK, function(e) { trace("seek") } );
			player.addEventListener(Mp3Event.ON_FIRST, function (e) { trace("first") } );
			player.addEventListener(Mp3Event.ON_LAST, function (e) { trace("last") } );
			player.addEventListener(Mp3Event.ON_CHANGE, function (e) { trace("change")} );
			// Events
		}
		
		private function configureControls():void
		{
			btplay.addEventListener(MouseEvent.CLICK, playSound);
			tr.addEventListener(MouseEvent.CLICK, repeatOrNot);
			ts.addEventListener(MouseEvent.CLICK, shuffleOrNot);
			up.addEventListener(MouseEvent.CLICK, go);
			down.addEventListener(MouseEvent.CLICK, go);
			btpause.addEventListener(MouseEvent.CLICK, pauseSound);
			btstop.addEventListener(MouseEvent.CLICK, stopSound);
			btprev.addEventListener(MouseEvent.CLICK, prevSound);
			btnext.addEventListener(MouseEvent.CLICK, nextSound);
			btlast.addEventListener(MouseEvent.CLICK, lastSound);
			btfirst.addEventListener(MouseEvent.CLICK, firstSound);
		}
		private function firstSound(e:MouseEvent):void
		{
			player.first();
		}
		private function lastSound(e:MouseEvent):void
		{
			player.last();
		}
		private function repeatOrNot(e:MouseEvent):void
		{
			player.toggleRepeating();
		}
		private function shuffleOrNot(e:MouseEvent):void
		{
			player.toggleShuffling();
		}
		private function playSound(e:MouseEvent):void
		{
			player.play()
		}
			
		private function pauseSound(e:MouseEvent):void
		{
			player.pause()
		}
			
		private function stopSound(e:MouseEvent):void
		{
			player.stop()
		}
			
		private function prevSound(e:MouseEvent):void
		{
			player.previous()
		}
			
		private function nextSound(e:MouseEvent):void
		{
			player.next()
		}
		private function go(e:MouseEvent):void 
		{
		tempVol += Number(e.currentTarget.volume);
			if (tempVol <= 0) 
			{
				tempVol = 0;
				} else if (tempVol >=2) {
					tempVol = 2;
				}
				player.setVolume(tempVol);
		}
	}
	
}