Import screen
Import guiscreen
Import initscreen 
Import lemongames
Import genericpausescreen
 
'#IF TARGET="glfw" 
'Import os
'#END
#REM
	summary: This class is the Screen browser.
	This class is like an internet browser. It will be displaying Screens as they're needed by the experiment.
	Any interactive part of an experiment is a Screen. each Screen is handles:
	[list] 
	[*]Its own information (collecting informatino)
	[*]Its own loop
	[*]The resulting Flow on the operation (wich Screen comes next)
	[/list]
	The browser will handle all this, and deal with any Screen.
	Doing it this way, we ensure that each cohesive unit of the program is self-evaluating and absolutely encapsulated.
	That gives for a very nice schema that grants code reusability, and easy of development and maintenance.
	All in all, this would reduce a lot development (and maitenance) costs.
#END
Class Browser extends App

	#REM
	summary: This is the real good constructor. When creating a new Browser object, a StartScreen has to be provided.
	#END	
	Method New()
		CurrentScreen = New InitScreen
	End
	Global drawBars:Bool = True

	#REM
		summary:Returns the integer vector containing the default logical resolution for this browser. 
	#END
	Function LogicalResolution:DrawingPointInt()
		Return logicalResolution
	End
	
	Method OnCreate()
		SetUpdateRate(60)
		If AudioMixer = Null Then AudioMixer = New Mixer
	End
	
	#REM
		summary:Returns the current scale factor that can be used to calculate conversions between logical points and device pixels.
		There are helper functions for this too, in case you need it.
	#END 
	Method GetCurrentScaleFactor:Float()
		Return scalefactor
	End

	Method OnRender()
		'Scale(DeviceWidth() / Float(LogicalResolution.x), DeviceHeight() / Float(LogicalResolution.y))
		PushMatrix()
		Scale(scalefactor, scalefactor)
		
		Translate(barras.x, barras.y)
		Cls(255, 255, 255)
		
		Select fadingStatus
			Case eFadingStatus.FADE_OUT
				If fadingoutScreen <> Null Then
					fadingoutScreen.Render()
					Local value:Float = 1 - Self.faderCounter / float(fadingoutScreen.fadeOut)
					If value < 0 Then value = 0
					If value > 1 Then value = 1
					SetAlpha(value)
					SetColor(fadeRed, fadeGreen, fadeBlue)
					'DrawRect(-1, -1, logicalResolution.x + 2, logicalResolution.y + 2)
					DrawRect(-barras.x - 1, -barras.y - 1, logicalResolution.x + 2 + barras.x * 2, logicalResolution.y + 2 + barras.y * 2)
					SetColor(255, 255, 255)
					SetAlpha(1)
				EndIf
			Case eFadingStatus.FADE_IN
					If currentScreen <> Null Then currentScreen.Render()
					Local value:Float = Self.faderCounter / float(currentScreen.fadeIn)
					If value < 0 Then value = 0
					If value > 1 Then value = 1

					SetAlpha(value)
					SetColor(fadeRed, fadeGreen, fadeBlue)
					'DrawRect(-1, -1, logicalResolution.x + 2, logicalResolution.y + 2)
					DrawRect(-barras.x - 1, -barras.y - 1, logicalResolution.x + 2 + barras.x * 2, logicalResolution.y + 2 + barras.y * 2)
					SetColor(255, 255, 255)
					SetAlpha(1)
			
			Case eFadingStatus.NONE
				Select internalStatus
					Case eScreenStatus.EXECUTING
						If currentScreen <> Null Then currentScreen.Render()
					Case eScreenStatus.PAUSE
						If currentScreen <> Null and currentScreen.RenderOnPause Then currentScreen.Render()
						If pauseScreen <> Null Then pauseScreen.Render()
				End			
			End
		If drawBars
			SetColor(0, 0, 0)
			DrawRect(-barras.x, 0, barras.x, logicalResolution.y)
			DrawRect(logicalResolution.x, 0, barras.x, logicalResolution.y)
	
			DrawRect(0, -barras.y, logicalResolution.x, barras.y)
			DrawRect(0, logicalResolution.y, logicalResolution.x, barras.y)
		EndIf

		PopMatrix()
		'SetColor(255, 255, 255)
		'If Resources.BigFont <> Null Then Resources.BigFont.DrawText("Scale factor: " + scalefactor, 0, 0)
	End
	
	Method OnLoading()

	End
	
	
	Method OnBack()
		CurrentScreen.OnBack()
	End
	
	Method OnClose()
		CurrentScreen.OnClose()
	End
	
	Method OnUpdate()
		CalculateScaleFactor()
		Select fadingStatus
			Case eFadingStatus.FADE_OUT
				If faderCounter < 0 Then
					faderCounter = 0
					EndFadeOut()
					fadingStatus = eFadingStatus.FADE_IN
					faderCounter = CurrentScreen.fadeIn
				EndIf
				faderCounter -= 1
				Return
			Case eFadingStatus.FADE_IN
				faderCounter -= 1
				If faderCounter <= 0 Then fadingStatus = eFadingStatus.NONE
			Case eFadingStatus.NONE
			
			Default
				Error("Unknown fading status")
		End
	
		Select internalStatus
			Case eScreenStatus.EXECUTING
				Select currentScreen.Update(Self)
					Case 0
						Error("Screen did not return a valid status upon execution.")
					Case eScreenStatus.EXECUTING 
						'We do nothing, current Screen is still executing 
					Case eScreenStatus.EXITBROWSER 
						'We close application. Don't know how to do thi on all Monkey targets... It's ok by now...
						Error("")
					Case eScreenStatus.LOADNEXT
						CurrentScreen = CurrentScreen.NextScreen
					Case eScreenStatus.PAUSE
						internalStatus = eScreenStatus.PAUSE
				End
			Case eScreenStatus.PAUSE
				If Self.pauseScreen = Null Then Self.pauseScreen = New GenericPauseScreen
				Select Self.pauseScreen.Update(Self)
					Case 0
						Error("Screen did not return a valid status upon execution.")
					Case eScreenStatus.EXECUTING 
						'We do nothing, current Screen is still executing
						internalStatus = eScreenStatus.EXECUTING
					Case eScreenStatus.EXITBROWSER 
						'We close application. Don't know how to do thi on all Monkey targets... It's ok by now...
						Error("")
					Case eScreenStatus.LOADNEXT
						CurrentScreen = CurrentScreen.NextScreen
					Case eScreenStatus.PAUSE
						internalStatus = eScreenStatus.PAUSE
				End
			
		End
	End
	
	Method OnSuspend()
		
	End
	
	Method OnResume()
		
	End
	
	#REM
		summary:This method allows you to set the screen that will be displayed when current screen returns eScreenStatus.LOADNEXT as the result of its execute method.
	#END
	
	Method PrepareScreen(screen:Screen)
		CurrentScreen.NextScreen = screen
	End
	
	#REM
		summary: This method returns the current fading status of the browser.
		The available values are defined in the class eFadingStatus, the they are:
		[list]
		[*]	[b]eFadingStatus.FADE_IN[/b] This means that the browser is making a Fade In of current screen.
		[*] [b]eFadingStatus.FADE_OUT[/b] This means that the browser is making a Fade Out of current screen
		[*] [b]eFadingStatus.NONE [/b]This means there are no fade actions being performed
		[/list]
	#END
	Method FadingStatus:Int()
		Return Self.fadingStatus
	End
	
	#Rem
		summary: This property is available to Get and Set the currently active Screen. By doing this, the browser will internally call the appropriate callbacks into the screen objects.
	#END
	Method CurrentScreen:Screen() Property
		Return currentScreen
	End
	
	#Rem
		summary: This property allows you to get or set the screen that's being currently displayed by the browser.
	#END
	Method CurrentScreen:Void(value:Screen) Property

		'we're changing current screen, so time for some nice events:
		'if currentScreen <> null then currentScreen.Unload()
		If currentScreen <> Null Then
			fadingoutScreen = currentScreen ' .Unload()
			faderCounter = fadingoutScreen.fadeOut
			fadingStatus = eFadingStatus.FADE_OUT
		EndIf
		
		'We activate the new screen:
		currentScreen = value
	
		If currentScreen <> Null And currentScreen.LoadOnPreviousScreen Then currentScreen.Load()
			
		'We notify the new screen it's being loaded, so it gets ready to be displayed:
		'if currentScreen <> null then currentScreen.Load()
		
	End

	#Rem
		summary: This property allows you to get and set the current browser status.
		Possible values are:
		[list]
		[*]eBrowserStaths.PAUSED The browser is running the Pause screen
		[*]eBrowserStaths.RUNNING The browser is running the current screen
		[/list]
	#END
		Method BrowserStatus:Int() Property
		Return browserStatus
	End

	Method BrowserStatus:Void(value:int) Property
		browserStatus = value
	End
	
	#Rem
		summary: This method allows you to get/set the desired pause screen. This screen will be renderer over currentscreen while the browser is paused.
	#END
	Method PauseScreen:Screen() Property
		Return pauseScreen
	End
	
	Method PauseScreen:Void(value:Screen) Property
		If pauseScreen <> Null Then pauseScreen.Unload()
		
		pauseScreen = value
		if pauseScreen <> null then pauseScreen.Load()
	End

	'summary: Gets a logical X coordinate and returns the readl phisical device coordinate.
	Function DeviceX:Int(logicalX:Float)
		'Return logicalX / Float(LogicalResolution.x) * DeviceWidth()
		Return (logicalX + barras.x) * ScaleFactor + 0.5
	End
	
	'summary: Gets a logical Y coordinate and returns the readl phisical device coordinate.
	Function DeviceY:Int(logicalY:Float)
		'Return logicalY / Float(LogicalResolution.y) * DeviceHeight()
		Return (logicalY + barras.y) * ScaleFactor + 0.5
	End
	
	'summary: Gets a phisical X coordinate and returns its logical coordinate on the browser screen.
	Function LogicalX:Float(DeviceX:Int)
		'Return DeviceX * Float(LogicalResolution.x) / DeviceWidth()
		Return DeviceX / scalefactor - barras.x
	End


	'summary: Gets a phisical Y coordinate and returns its logical coordinate on the browser screen.
	Function LogicalY:Float(DeviceY:Int)
		'Return DeviceY * Float(LogicalResolution.y) / DeviceHeight()
		Return DeviceY / scalefactor - barras.y 'scalefactor
	End

	'summary: Gets a logical point and returns a new instance of a DrawingPoint containing its phisical device location vector
	Function DevicePos:DrawingPoint(logicalPos:DrawingPoint)
		Return New DrawingPoint(DeviceX(logicalPos.x), DeviceY(logicalPos.y))
	End

	'summary: Gets a logical point and returns a new instance of a DrawingPoint containing its phisical device location vector
	Function DevicePos:DrawingPointInt(logicalPos:DrawingPoint)
		Return New DrawingPointInt(DeviceX(logicalPos.x), DeviceY(logicalPos.y))
	End

	Method BlackBarsSize:DrawingPoint()
		Return barras
	End
	
	Method FadeRed:Int() Property
		Return fadeRed
	End
	
	Method FadeRed:Void(red:Int) Property
		#IF CONFIG="debug"
		If red < 0 or red > 255 Then Error("Fade color out of bounds.")
		#END
		fadeRed = red
	End
	
	Method FadeGreen:Int() Property
		Return fadeGreen
	End
	
	Method FadeGreen:Void(green:Int) Property
		#IF CONFIG="debug"
		If green < 0 or green > 255 Then Error("Fade color out of bounds.")
		#END
		fadeGreen = green
	End
	
	Method FadeBlue:Int() Property
		Return fadeBlue
	End
	
	Method FadeBlue:Void(blue:Int) Property
		#IF CONFIG="debug"
		If blue < 0 or blue > 255 Then Error("Fade color out of bounds.")
		#END
		fadeBlue = blue
	End
	
	
	Private
	Field currentScreen:Screen
	Field browserStatus:Int
	Field pauseScreen:Screen
	Field internalStatus:Int = eScreenStatus.EXECUTING
	
	Field fadeRed:Int, fadeGreen:Int, fadeBlue:Int
	
	'Field hasFaded:Bool = False
	
	Field fadingoutScreen:Screen
	Field fadingStatus:Int = eFadingStatus.NONE
	Field faderCounter:Int = 0
	Global barras:= New DrawingPoint'(0, 0)
	Global scalefactor:Float = 1
	Global logicalResolution:= New DrawingPointInt(1280, 720)
	Function CalculateScaleFactor:Float()
			scalefactor = Float(DeviceWidth()) / logicalResolution.x '* DeviceWidth()
			
			If logicalResolution.y * scalefactor > DeviceHeight() Then
				'Barras verticales
				scalefactor = Float(DeviceHeight()) / logicalResolution.y
				Local MaxCoord:Float = DeviceWidth() / scalefactor
				barras.Set( (MaxCoord - logicalResolution.x) / 2.0, 0)
				Return scalefactor
			Else
				'Barras horizontales
				Local MaxCoord:Float = DeviceHeight() / scalefactor
				barras.Set(0, (MaxCoord - logicalResolution.y) / 2.0)
				Return scalefactor
			EndIf			
	End
	Global scaleFactor:Float = 1
	
	Method EndFadeOut()
		If fadingoutScreen <> Null Then
			fadingoutScreen.Unload()
			fadingoutScreen = Null
		End
		If currentScreen <> Null and currentScreen.LoadOnPreviousScreen = False Then
			currentScreen.Load()
		EndIf
	End
End

#REM
	summary: This abstrat class contains all possible browser status
#END
Class eBrowserStaths Abstract

	'summary: The browser is running properly
	Const RUNNING:Int = 1

	'summary: The browser is in PAUSE status
	Const PAUSED:Int = 2
	
End

#Rem
	summary: This class contains all possible fading status of a Browser
#END
Class eFadingStatus

	'summary: There are no fading actions being performed
	Const NONE:Int = 0
	
	'summary: Current screen is fading in
	Const FADE_IN:Int = 1
	
	'summary: Current screen has been stopped and it is fading out
	Const FADE_OUT:Int = 2
End
