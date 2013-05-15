Import browser
Import lemongames
Class WelcomePage Extends Screen


	Field timer:Int = 10
	
	Method New(nextScreen:Screen)
		Self.NextScreen = nextScreen
	End
	
	Method Load:Bool()
				
	End
	
	Method Update:Int(browser:Browser)
		
		If browser.FadingStatus = eFadingStatus.NONE Then timer -= 1
		If timer <= 0 Then Return eScreenStatus.LOADNEXT
		Return eScreenStatus.EXECUTING
	End
	
	Method Render:Void()
		Cls(0, 0, 0)
		'DrawText("Loading...", 0, 0)
		
	End
	
	Method Unload:Bool()
			
	End
End