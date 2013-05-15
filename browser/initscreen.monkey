Import browser

Class InitScreen extends Screen
	Method New(screen:Screen)
		NextScreen = screen
		Init()
	End
	Method New()
		Init()
	End
	method Load:Bool()
		
	End
	Method Unload:Bool()
		
	End
	Method Render:Void()
		Cls(0, 0, 0)
		running-=1	
	End
	Method Update:Int(browser:Browser)
		if running > 0 Then Return eScreenStatus.EXECUTING Else Return eScreenStatus.LOADNEXT
	End
	Private
	field running:Int = 2	'2 frames para asegurarse que el Device está en marcha siempre...
	Method Init()
		fadeIn = 1
		fadeOut = 1
	End
End
