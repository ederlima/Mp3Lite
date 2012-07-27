package br.ederlima
{
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundLoaderContext;
	import flash.media.SoundMixer;
	import flash.media.ID3Info;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.AntiAliasType;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import br.ederlima.Mp3Event;
	/**
	 *	<h1>Mp3Lite Class - Release 2.0 </h1>
	 * 	<br />by Eder Lima & Leo Cavalcante
	 * 	<br />Release 2.0
	 * 	<br />02/22/2009
	 * 	<br /><a href="http://www.ederlima.com.br/blog/mp3lite">http://www.ederlima.com.br/blog/mp3lite</a>
	 * 	<br />Free for use, not for redistribute
	 * 	<br />Don't host this file, please use links to refer to author's website
	 * 	<br />Thank you for choosing Mp3Lite!
	 * 	<br />Our special thanks to Rafael Lima (http://www.rafael-lima.com/) for calculate totallength of streamming songs.
	 * 	<br />Eder Lima & Leo Cavalcante
	 * 	<br /><strong>English Documentation at http://www.ederlima.com.br/blog/mp3lite2/#english (Soon)</strong>
	 *	<br />Documentação em Português http://www.ederlima.com.br/blog/mp3lite2
	 * 	<br />
	 * 	<h2>Como utilizar:</h2>
	 * 	<span style="color:#0000FF"><br />import Mp3Lite;
	 * 	<br />import Mp3Event;
	 * 	<br />var myplayer:Mp3Lite = new Mp3Lite();
	 * 	<br />myplayer.setXMLList("playlist.xml");
	 * 	<br />myplayer.addEventListener(Mp3Event.ON_START, function(e) {trace("Let's rock!"});
	 * 	<br />myplayer.start();</span>
	 * 	<br />
	 * 	<h2>Confira abaixo os métodos e propriedades da Mp3Lite</h2>
	 * 
	*/
	public class Mp3Lite extends EventDispatcher
	{
		
		private var audio:Sound = new Sound();
		private var audioX:SoundChannel = new SoundChannel();
		private var openStream:Sound;
		private var closedStream:Sound = null;
		private var context:SoundLoaderContext;
		private var psd:Boolean = false;
		private var stp:Boolean = false;
		private var pos:Number;
		private var hasMP3:Boolean = false;
		private var loopMP3:Boolean = false;
		private var shuffleMP3:Boolean = false;
		private var xmlMP3:XML;
		private var xmlMP3List:XMLList;
		private var xmlMP3Total:int;
		private var defaulturl:String = null;
		private var xmlLoader:URLLoader = new URLLoader();
		private var isunique:Boolean = false;
		private var idMP3:int = 0;
		private var tTime:int = 0;
		private var min:int;
		private var seg:int;
		private var nmin:int;
		private var nseg:int;
		private var nameMusic:String = "";
		private var aName:TextField;
		private var sName:TextField;
		private var bSeek:*;
		private var bProgress:*;
		private var bgSeek:*;
		private var tempProgress:Number = 0;
		private var tempSeek:Number = 0;
		private var menuList:MovieClip;
		private var id3Msg:String;
		private var bufferInfo:TextField;
		private var totalInfo:TextField;
		private var actualInfo:TextField;
		private var musicName:TextField;
		private var format:TextFormat = null;
		private var tempFormat:TextFormat;
		private var soundVolume:SoundTransform = new SoundTransform(1, 0);
		private var mute:Boolean = false;
		private var tempVol:Number = 1;
		private var musicUrlArray:Array = new Array();
		private var musicNameArray:Array = new Array();
		private var useProgress:Boolean = false;
		private var useID3Info:Boolean = false;
		private var useTimeInfo:Boolean = false;
		private var usePlayList:Boolean = false;
		private var playListItemWidth:Number;
		private var status:String = "waiting...";
		private var _onStart:Mp3Event;
		private var _onProgress:Mp3Event;
		private var _onComplete:Mp3Event;
		private var _onPause:Mp3Event;
		private var _onResume:Mp3Event;
		private var _onStop:Mp3Event;
		private var _onNext:Mp3Event;
		private var _onPrevious:Mp3Event;
		private var _onPlaylist:Mp3Event;
		private var _onRepeat:Mp3Event;
		private var _onShuffle:Mp3Event;
		private var _onSeek:Mp3Event;
		private var _onId3:Mp3Event;
		private var _onLast:Mp3Event;
		private var _onFirst:Mp3Event;
		private var _onChange:Mp3Event;
		private var _onXml:Mp3Event;
		private var calculating:Sprite = new Sprite();
		private var timerobject:Timer;
		private var loadpercentage:int = 0;
		private var executionpercentage:int = 0;
		private var actualtimestring:String = null;
		private var totaltimestring:String = null;
		private var atime:int;
		private var artistname:String = null;
		private var songname:String = null;
		
		//---------- class constructor ----------//
		/**
		 *	Construtor da Classe 
		*/
		public function Mp3Lite()
		{
			
		}
		//---------- public functions ----------//
		/**
		 * Inicia a execução da classe
		 * @param	SongId Número que corresponde ao id da música da qual quer iniciar a reprodução (Default = 0, primeira)
		 */
		public function start(SongId:int = 0, buffertime:Number = 1000):void
		{
			initDispacther();
			setTimer();
			idMP3 = SongId;
			context = new SoundLoaderContext(buffertime, false);
			if (SongId == 0 && isunique) 
			{
					loadMP3(defaulturl, loopMP3);
			}
			else if(SongId == 0 && !isunique)
			{
				xmlLoader.load(new URLRequest(defaulturl));
			}
			else if(SongId !=0 && !isunique)
			{
				xmlLoader.load(new URLRequest(defaulturl));
			}
		}
		/**
		 * Toca uma única música
		 * @param	song O endereço da Música
		 * @param	loop Define se usa loop ou não (Boolean)
		 */
		public function uniqueSound(song:String, loop:Boolean = false):void
		{
			loopMP3 = loop;
			isunique = true;
			defaulturl = song;
		}
		/**
		 * Inicia a reprodução a partir da música informada como índice
		 * @param	SongNumber Id da música (numérico)
		 * @param	loop Define se usa loop ou não (Boolean)
		 */
		public function playFrom(SongNumber:int = 0, loop:Boolean = false):void
		{
			stop();
			loadMP3(String(musicUrlArray[SongNumber]));
		}
		/**
		 * Configura a Lista XML que portará as músicas
		 * @param	xmlURL URL do xml
		 */
		public function setXMLList(xmlURL:String):void
		{
			isunique = false;
			defaulturl = xmlURL;
			xmlLoader.addEventListener(Event.COMPLETE, xmlMP3Ok, false, 0, true);
		}
		/**
		 * Configura/Desconfigura o player para repetir a música atual
		 */
		public function toggleRepeating():void
		{
			!loopMP3 ? loopMP3 = true : loopMP3 = false;
		}
		/**
		 * Configura/Desconfigura o player para tocar aleatoriamente
		 */
		public function toggleShuffling():void
		{
			!shuffleMP3 ? shuffleMP3 = true : shuffleMP3 = false;
		}
		/**
		 * Inicia Reprodução da Música
		 */
		public function play():void
		{
			if (stp)
			{
				pos = 0;
			}
			if (!hasMP3) 
			{
				!psd ? toPlay() : toResume() ;
				psd = false;
				hasMP3 = true;
				stp = false;
				addAllListeners();
			}
			setVolume(tempVol);
		}
		/**
		 * Para a reprodução permitindo reinício a partir do ponto onde parou
		 */
		public function pause():void
		{
			useTimeInfo ? bufferInfo.text = "paused..." : void;
			status = "paused...";
			if (stp) 
			{
				pos = 0;
			} 
			else if(!psd)
			{
			pos = audioX.position;
			psd = true;
			audioX.stop();
			hasMP3 = false;
			stp = false;
			this.dispatchEvent(_onPause);
			removeAllListeners();
			}
			else if (psd)
			{
				audioX = openStream.play(pos)
				psd = false;
				hasMP3 = true;
				stp = false;
				addAllListeners()
				this.dispatchEvent(_onResume);
			}
			setVolume(tempVol);
		}
		/**
		 * Para a reprodução
		 */
		public function stop():void
		{
			useTimeInfo ? bufferInfo.text = "stopped..." : void;
			status = "stopped..."
			pos = 0;
			hasMP3 = false;
			stp = true;
			psd = false;
			audioX.stop();
			removeAllListeners();
			this.dispatchEvent(_onStop);
		}
		/**
		 * Avança para a próxima música na playlist
		 */
		public function next():void
		{
			if (!isunique)
			{
			psd ? pos = 0 : void;
			audioX.stop();
			hasMP3 = false;
			shuffleMP3 ? shuffle() : toNext();			
			loadMP3(musicUrlArray[idMP3]);
			}
		}
		/**
		 * Retrocede uma música na playlist
		 */
		public function previous():void
		{
			if (!isunique)
			{
			psd ? pos = 0 : void;
			audioX.stop();
			hasMP3 = false;
			shuffleMP3 ? shuffle() : toPrevious();			
			loadMP3(musicUrlArray[idMP3]);
			}
		}
		/**
		 * Toca a primeira música da playlist 
		*/
		public function first():void
		{
			if (!isunique)
			{
			psd ? pos = 0 : void;
			audioX.stop();
			hasMP3 = false;
			loadMP3(musicUrlArray[0]);
			this.dispatchEvent(_onFirst);
			}
		}
		/**
		 * Toca a última música da playlist 
		 */
		public function last():void
		{
			if (!isunique)
			{
			psd ? pos = 0 : void;
			audioX.stop();
			hasMP3 = false;
			loadMP3(musicUrlArray[(musicUrlArray.length - 1)]);
			this.dispatchEvent(_onLast);
			}
		}
		/**
		 * Configura as caixas de texto que irão receber a informação do artista e nome da música
		 * @param	artistName Campo de texto dinâmico para receber o nome do artista
		 * @param	soundName Campo de texto dinâmico para receber o nome da música
		 * @param	noID3msg Mensagem padrão para informação não encontrada (String)
		 */
		public function setID3Info(artistName:TextField, soundName:TextField, noID3msg:String = "No ID3 Information"):void 
		{
			useID3Info = true;
			aName = artistName;
			sName = soundName;
			id3Msg = noID3msg;
		}
		/**
		 * Define 3 objetos para representarem a barra de progresso, barra de procura (seek), 
		 * barra de fundo (usado no cálculo) e uso ou não do buttonMode
		 * @param	progress MovieClip para representar a barra de progresso
		 * @param	seek MovieClip para representar a barra de procura
		 * @param	bg MovieClip de fundo (essencial para o cálculo preciso)
		 * @param	btnMode Define se usa HandCursor (Boolean)
		 */
		public function setProgress(progress:MovieClip, seek:MovieClip, bg:MovieClip, btnMode:Boolean = true):void
		{
			useProgress = true;
			bProgress = progress;
			bProgress.buttonMode = btnMode;
			bgSeek = bg;
			bSeek = seek;
			bSeek.buttonMode = btnMode;
			bSeek.scaleX = 0;
		}
		/**
		 * Define 3 caixas de texto para informar o status da reprodução, o tempo atual e o tempo total da música
		 * @param	buff Campo de texto dinâmico para receber o status do buffer
		 * @param	actual Campo de texto dinâmico para receber o tempo atual
		 * @param	total Campo de texto dinâmico para receber o tempo total
		 */
		public function setTimeInfo(buff:TextField, actual:TextField, total:TextField):void
		{
			useTimeInfo = true;
			bufferInfo = buff;
			totalInfo = total;
			actualInfo = actual;
		}
		/**
		 * Configura uma playlist informando onde será inserida, largura e o formato(TextFormat)
		 * Para usar este método informando uma variável do tipo TextFormat 
		 * é necessário inserir a fonte usada na Biblioteca
		 * @param	obj MovieClip que receberá a Playlist
		 * @param	listWidth Largura da playlist
		 * @param	customFormat Objeto TextFormat contendo a formatação da Playlist (Obrigatório a inclusão da fonte na biblioteca)
		 */
		public function setPlaylist(obj:MovieClip, listWidth:Number, customFormat:TextFormat = null):void
		{
			usePlayList = true;
			menuList = obj;
			playListItemWidth = listWidth;
			tempFormat = new TextFormat();
			tempFormat.font = "Arial";
			tempFormat.size = 11;
			tempFormat.color = 0x333333;
			customFormat == null ? format = tempFormat : format = customFormat;				
		}
		/**
		 * Configura o volume da reprodução (valor entre 0 e 2)
		 * @param	volume	Valor inteiro de 0 a 2 (0% a 200%, Default = 1)
		 */
		public function setVolume(volume:Number = 1):void
		{
			tempVol = volume;
			if (tempVol <= 0) 
			{ 
				tempVol = 0;
			}
			else if (tempVol >= 2)
			{
				tempVol = 2;
			}
			soundVolume = new SoundTransform(tempVol);
			audioX.soundTransform = soundVolume;
		}
		/**
		 * Reduz o volume para 0 ou retorna para o volume anterior
		 */
		public function toggleMute():void
		{
			if (!mute)
			{
				mute = true;
				setVolume(0);
			}
			else
			{
				mute = false;
				setVolume(tempVol);
			}
		}
		/**
		 * Salta a reprodução para o tempo informado
		 * @param	time Valor inteiro em segundos. Exemplo: 1:30  = (90)
		 */
		public function seekToTime(time:int):void
		{
			if (!psd)
			{
			audioX.stop();
			audioX = openStream.play(time);
			audioX.addEventListener(Event.SOUND_COMPLETE, onCompleteSound);
			this.dispatchEvent(_onSeek);
			}
			setVolume(tempVol);
		}
		/**
		 * Salta a reprodução para o percentual informado
		 * @param	percentual Valor inteiro de 0 a 100
		 */
		public function seekToPercent(percentual:int):void
		{
			if (!psd)
			{
			audioX.stop();
			pos = percentual *(tTime*10);
			audioX = openStream.play(pos);
			audioX.addEventListener(Event.SOUND_COMPLETE, onCompleteSound);
			this.dispatchEvent(_onSeek);
			}
			setVolume(tempVol);
		}
		//---------- private functions ----------//
		/**
		 * Função executada no 'complete' do XML, ela inicia a reprodução
		 * @param	e
		 */
		private function xmlMP3Ok(e:Event):void
		{
			xmlMP3 = XML(e.target.data);
			xmlMP3List = xmlMP3.songs.song;
			xmlMP3Total = xmlMP3List.length();
			for (var mp3Count:int = 0; mp3Count < xmlMP3Total; mp3Count++) 
			{
				musicUrlArray.push(xmlMP3List[mp3Count].@url);
				musicNameArray.push(xmlMP3List[mp3Count].@name);
			}
			this.dispatchEvent(_onXml);
			loadMP3(musicUrlArray[idMP3]);
			createList();
		}
		/**
		 * Carrega cada música e configura listeners
		 * @param	url
		 * @param	time
		 * @param	loopMP3
		 */
		private function loadMP3(url:String, loopMP3:Boolean = false):void
		{
			if (closedStream != null)
			{
				//closedStream.close();
				closedStream = null;
			}
			audio = new Sound();
			openStream = audio;
			closedStream = openStream;
			audioX = new SoundChannel();
			openStream.addEventListener(Event.ID3, infoID3);
			openStream.load(new URLRequest(url), context);
			loopMP3 = this.loopMP3;
			useProgress ? bProgress.scaleX = 0 : void;
			play();
			soundVolume = new SoundTransform(tempVol);
			audioX.soundTransform = soundVolume;
			if (useProgress)
				{
					bSeek.addEventListener(Event.ENTER_FRAME, seekThis);
				}
		}
		/**
		 * Função que cria o evento Timer, ele dispara o evento _onProgress
		 */
		private function setTimer():void
		{
			timerobject = new Timer(100);
			timerobject.addEventListener(TimerEvent.TIMER, timeProgress);
		}
		/**
		 * Função que adiciona todos os listeners ao início de cada reprodução
		 */
		private function addAllListeners():void
		{
			calculating.addEventListener(Event.ENTER_FRAME, infoTime);
			if (useProgress)
				{
					bProgress.addEventListener(Event.ENTER_FRAME, scaleThis);
					bProgress.addEventListener(MouseEvent.CLICK, seekThisOut);
					bSeek.addEventListener(MouseEvent.CLICK, seekThisOut);
				}
			audioX.addEventListener(Event.SOUND_COMPLETE, onCompleteSound);
			calculating.addEventListener(Event.ENTER_FRAME, calculateTime);	
			timerobject.start();
		}
		/**
		 * Remove os listeners adicionado a cada evento da Classe
		 */
		private function removeAllListeners():void
		{
			timerobject.stop();
			if (useProgress)
			{
			bSeek.removeEventListener(Event.ENTER_FRAME, seekThisOut);
			bProgress.removeEventListener(MouseEvent.CLICK, seekThisOut);
			bProgress.removeEventListener(Event.ENTER_FRAME, scaleThis);
			if (stp)
				{
				bProgress.scaleX = 0;
				}
			}
			if (useTimeInfo)
			{
				!psd ? actualInfo.text = "00:00" : void;
			}
			calculating.removeEventListener(Event.ENTER_FRAME, infoTime);
			calculating.removeEventListener(Event.ENTER_FRAME, calculateTime);
			audioX.removeEventListener(Event.SOUND_COMPLETE, onCompleteSound);
		}
		/**
		 * Calcula o tempo total e informa funções sobre esse tempo
		 * @param	e
		 */
		private function calculateTime(e:Event):void
		{
			pos = audioX.position;
			tTime = (openStream.bytesTotal / (openStream.bytesLoaded / openStream.length)) * 0.001;
			min = int((tTime) / 60);
			seg = int((tTime) % 60);
			nmin = int((pos*0.001)/60);
			nseg = int((pos * 0.001) % 60);
			atime = int(pos * 0.001);
			loadpercentage = int(openStream.bytesLoaded / openStream.bytesTotal * 100);
			executionpercentage = int(((pos * 0.001) / tTime) * 100);
			actualtimestring = String(convertDigits(nmin) + ":" + convertDigits(nseg));
			totaltimestring = String(convertDigits(min) + ":" + convertDigits(seg));			
		}
		/**
		 * Função que dispara o evento _onProgress a cada 1 segundo
		 */
		private function timeProgress(e:TimerEvent):void
		{
			this.dispatchEvent(_onProgress);
		}
		/**
		 * Função que inicia a reprodução se não existir pause
		 */
		private function toPlay():void
		{
			audioX = openStream.play()
			this.dispatchEvent(_onStart);
		}
		/**
		 * Função que inicia a reprodução se existir pause
		 */
		private function toResume():void
		{
			audioX = openStream.play(pos)
			this.dispatchEvent(_onResume);
		}
		/**
		 * Função que define a reprodução aleatório como true
		 */
		private function shuffle():void
		{
			idMP3 = Math.floor(Math.random() * xmlMP3Total)
			this.dispatchEvent(_onShuffle);
		}
		/**
		 * Repete a música atual caso loopMP3 = true
		 */
		private function repeat():void
		{
			if (!isunique)
			{
			playFrom(idMP3);
			this.dispatchEvent(_onRepeat);
			}
			else
			{
			 audioX = openStream.play(0);
			}
		}
		/**
		 * Função que ao fim da execução de cada música testa o booleano loopMP3
		 * @param	e
		 */
		private function onCompleteSound(e:Event):void
		{
			if (!isunique)
			{
			pos = 0;
			!loopMP3 ? next() : repeat() ;
			this.dispatchEvent(_onComplete);
			}
			else
			{
				loopMP3 ? repeat() : removeAllListeners();
			}
		}
		/**
		 * Função que toca a próxima música da playlist caso não exista shuffle ou repeat
		 */		
		private function toNext():void
		{
			idMP3 == (xmlMP3Total - 1) ? idMP3 = 0 : idMP3++;
			this.dispatchEvent(_onNext);
		}
		/**
		 * Função que toca a música anterior da playlist caso não exista shuffle ou repeat
		 */
		private function toPrevious():void
		{
			idMP3 == 0 ? idMP3 = (xmlMP3Total - 1) : idMP3--;
			this.dispatchEvent(_onPrevious);
		}
		/**
		 * Executada ao ler a Id3 de cada som.
		 * Informa a posição da música, o artista e o nome da música
		 * @param	e
		 */
		private function infoID3(e:Event):void 
		{
			artistname = String(openStream.id3.artist);
			songname = String(openStream.id3.songName);
			if (useID3Info) 
			{
			openStream.id3.artist == "" ? aName.htmlText = id3Msg : aName.htmlText = openStream.id3.artist;
			openStream.id3.songName == "" ? sName.htmlText = id3Msg : sName.htmlText = openStream.id3.songName;
			}
			this.dispatchEvent(_onId3);
		}
		/**
		 * Função que responde a um ENTER_FRAME e atualiza a escala da barra de progresso
		 * Evento acionado em play se useProgress = true
		 * @param	e
		 */
		private function scaleThis(e:Event):void
		{
			if (stp)
				{
					bProgress.scaleX = 0;
					bSeek.scaleX = 0;
				}
				else
				{
					tempProgress = (pos / tTime)*0.001;
					isNaN(tempProgress) ? bProgress.scaleX = 0 : bProgress.scaleX = tempProgress;
				}
		}
		/**
		 * Função que informa a quantidade de dados de cada música já carregados.
		 * ENTER_FRAME acionado no play é responsável pela escala da barra de procura (seek)
		 * @param	e
		 */
		private function seekThis(e:Event):void 
		{
			if (useProgress)
			{
			tempSeek = openStream.bytesLoaded / openStream.bytesTotal;
			isNaN(tempSeek) ? bSeek.scaleX = 0 : bSeek.scaleX = openStream.bytesLoaded / openStream.bytesTotal;
			}
		}
		/**
		 * Função que responde ao clique sobre a barra de procura e avança a música para aquele ponto
		 * ENTER_FRAME acionado no play
		 * @param	e
		 */
		private function seekThisOut(e:MouseEvent):void 
		{
			if (!psd)
			{
			audioX.stop();
			pos = bgSeek.mouseX / (bgSeek.width *0.01) *(tTime*10);
			audioX = openStream.play(pos);
			audioX.addEventListener(Event.SOUND_COMPLETE, onCompleteSound);
			this.dispatchEvent(_onSeek);
			}
			setVolume(tempVol);
		}
		/**
		 * Função que transforma 9 em 09
		 * @param	convertTo
		 * @return	String
		 */
		private function convertDigits(convertTo:Number):String
		{
			var string:String = null;
			convertTo < 10 ? string = String("0" + convertTo) : string = String(convertTo);
			return string;
		}
		/**
		 * Função que informa o tempo atual e total da reprodução bem como o status
		 * @param	e
		 */
		private function infoTime(e:Event):void
		{
			if (useTimeInfo) 
			{
				openStream.isBuffering == true ? bufferInfo.text = "buffering..." : bufferInfo.text = "playing...";
				openStream.isBuffering == true ? status = "buffering..." : status = "playing...";
				totalInfo.text = String(convertDigits(min) + ":" + convertDigits(seg));
				actualInfo.text = String(convertDigits(nmin) + ":" + convertDigits(nseg));
			}
		}
		/**
		 * Função que cria uma playlist padrão usando os dados informados em setPlaylist
		 */
		private function createList():void
		{	
			if (usePlayList)
			{
				for (var number:int = 0; number < xmlMP3Total; number ++) 
				{
				musicName = new TextField();
				musicName.height = 20;
				musicName.width = playListItemWidth;
				musicName.embedFonts = true;
				musicName.antiAliasType = AntiAliasType.ADVANCED;
				musicName.selectable = false;
				nameMusic = String(convertDigits((number + 1)) + " - " + musicNameArray[number]);
				musicName.defaultTextFormat = format;
				musicName.text = nameMusic;
				musicName.y = number * (20 + 2);
				var item:MovieClip = new MovieClip();
				item.buttonMode = true;
				item.mouseChildren = false;
				item.cod = number;
				item.addChild(musicName);
				item.addEventListener(MouseEvent.CLICK, playByClick);
				item.addEventListener(MouseEvent.ROLL_OVER, alphaOn);
				item.addEventListener(MouseEvent.ROLL_OUT, alphaOut);
				menuList.addChild(item);
				}
				this.dispatchEvent(_onPlaylist);
			}
		}
		/**
		 * Over da playlist
		 * @param	e
		 */
		private function alphaOn(e:MouseEvent):void
		{
			e.target.alpha = 0.5;
		}
		/**
		 * Out da playlist
		 * @param	e
		 */
		private function alphaOut(e:MouseEvent):void
		{
			e.target.alpha = 1;
		}
		/**
		 * Função que inicia a reprodução a partir de uma música selecionada na playlist
		 * @param	e
		 */
		private function playByClick(e:MouseEvent):void
		{
			var tempCod:int = e.currentTarget.cod;
			idMP3 = tempCod;
			stop();
			loadMP3(String(musicUrlArray[tempCod]));
			this.dispatchEvent(_onChange);
		}
		/**
		 * Função que inicia a máquina que dispara os eventos
		 */
		private function initDispacther():void
		{
			_onStart = new Mp3Event(Mp3Event.ON_START);
			_onProgress = new Mp3Event(Mp3Event.ON_PROGRESS);
			_onComplete = new Mp3Event(Mp3Event.ON_COMPLETE);
			_onPause = new Mp3Event(Mp3Event.ON_PAUSE);
			_onResume =	new Mp3Event(Mp3Event.ON_RESUME);
			_onStop = new Mp3Event(Mp3Event.ON_STOP);
			_onNext = new Mp3Event(Mp3Event.ON_NEXT);
			_onPrevious = new Mp3Event(Mp3Event.ON_PREVIOUS);	
			_onPlaylist = new Mp3Event(Mp3Event.ON_PLAYLIST);
			_onShuffle = new Mp3Event(Mp3Event.ON_SHUFFLE);
			_onRepeat = new Mp3Event(Mp3Event.ON_REPEAT);
			_onSeek = new Mp3Event(Mp3Event.ON_SEEK);
			_onId3 = new Mp3Event(Mp3Event.ON_ID3);
			_onLast = new Mp3Event(Mp3Event.ON_LAST);
			_onFirst = new Mp3Event(Mp3Event.ON_FIRST);
			_onChange = new Mp3Event(Mp3Event.ON_CHANGE);
			_onXml = new Mp3Event(Mp3Event.ON_XML);
		}
		//------ getters -------------//
		/**
		 * Retorna o volume atual
		 */
		public function get volume():Number
		{
			return tempVol;
		}
		/**
		 * Retorna os bytes carregados
		*/
		public function get getBytesLoaded():Number
		{
			return openStream.bytesLoaded;
		}
		/**
		 * Retorna o total de bytes de cada música
		*/
		public function get getBytesTotal():Number
		{
			return openStream.bytesTotal;
		}
		/**
		 * Retorna o percentual carregado de cada música
		 */
		public function get getLoadedPercentage():int
		{
			return loadpercentage;
		}
		/**
		 * Retorna o percentual da execução de cada música
		 */
		public function get getExecutionPercentage():int
		{
			return executionpercentage;
		}
		/**
		 * Retorna a String do tempo atual no formato 00:00
		 */
		public function get getActualTimeString():String
		{
			return actualtimestring;
		}
		/**
		 * Retorna a String do tempo total no formato 00:00
		 */
		public function get getTotalTimeString():String
		{
			return totaltimestring;
		}
		/**
		 * Retorna o tempo total em Int
		 */
		public function get getTotalTimeNumber():int
		{
			return tTime;
		}
		/**
		 * Retorna o tempo atual em Int
		 */
		public function get getActualTimeNumber():int
		{
			return atime;
		}
		/**
		 * Retorna o nome do artista
		 */
		public function get getArtistName():String
		{
			return artistname;
		}
		/**
		 * Retorna o nome da música
		 */
		public function get getSongName():String
		{
			return songname;
		}
		/**
		 * Retorna o id atual da música na playlist
		 */
		public function get getSongId():int
		{
			return idMP3;
		}
		/**
		 * Retorna a quantidade de músicas
		 */
		public function get getSongTotal():int
		{
			return xmlMP3Total;
		}
		/**
		 * Retorna a posição da música na playlist
		 */
		public function get getSongPosition():int
		{
			return idMP3;
		}
		/**
		 * Retorna o status da reprodução
		 */
		public function get getStatus():String
		{
			return status;
		}
		//------ setters -------------//
		/**
		 * Configura o novo volume
		 */
		public function set volume(value:Number):void
		{
			tempVol = value;
			setVolume(tempVol);
		}
	}
}