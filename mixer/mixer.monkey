Import lemongames
Global AudioMixer:Mixer
Class Mixer

	Method New()
		If running Then Error("Only one mixer allowed!")
		running = True
	End

	'summary: el volumen general de la app
 	Method MainVolume:Void(value:Float) Property
		If value > 1 Then value = 1
		If value < 0 Then value = 0
		mainVolume = value
		RefreshVolume()
	End
	
	Method MainVolume:Float() Property
		Return mainVolume
	End
	
	Method MusicVolume:Void(value:Float) Property
		If value > 1 Then value = 1
		If value < 0 Then value = 0
		musicVolume = value
		RefreshVolume()
	End
	
	Method MusicVolume:Float() Property
		Return musicVolume
	End
	
	'summary: Disparar un sonido
	
	'summary: Poner música en el canal de fondo
	Method PlayMusic(path:String, flags = Mixer.MUSIC_LOOP)
		audio.PlayMusic(path, flags)
	End
	
	Method StopMusic()
		audio.StopMusic()
	End
	
	'summary: Gets or sets the global FxVolume
	Method FxVolume:Void(value:Float) Property
		If value > 1 Then value = 1
		If value < 0 Then value = 0
		fxVolume = value
		RefreshVolume()
	End
	
	Method FxVolume:Float() Property
		Return fxVolume
	End
	
	Method MusicFader:Void(value:Float) Property
		musicFader = value
	End
	
	Method MusicFader:Float() Property
		Return musicFader
	End
	
	'summary: Disparar un sonido
	Method ShotSound(sound:Sound, volume:Float = 1, pitch:Float = 1)
		If sound = Null Then Return
		If ChannelState(currentChannel) <> 0 Then
			StopChannel(currentChannel)
		EndIf
		
		SetChannelVolume(currentChannel, mainVolume * fxVolume * volume)
		SetChannelRate(currentChannel, pitch)
		soundVolume[currentChannel] = volume
		PlaySound(sound, currentChannel)
		currentChannel += 1
		If currentChannel >= MAXCHANNELS Then currentChannel = 0
	End
	
	Method StopAllSounds()
		For Local i:Int = 0 Until MAXCHANNELS
			StopChannel(i)
		Next
	End
	
	
	Const MUSIC_LOOP:Int = 1
	Const MUSIC_ONCE:Int = 0
	
	Private
	
	Method RefreshVolume()
		audio.SetMusicVolume(musicVolume * mainVolume * musicFader)
		For Local i:Int = 0 Until MAXCHANNELS
			audio.SetChannelVolume(i, mainVolume * soundVolume[i] * fxVolume)
		Next
	End
	Field mainVolume:Float = 1
	Field musicVolume:Float = 1
	Field musicFader:Float = 1
	Field currentChannel:Int = 1
	Field fxVolume:Float = 1
	Const MAXCHANNELS:Int = 32
	Field soundVolume:Float[] = New Float[MAXCHANNELS]
	Field running:Bool = False
End

