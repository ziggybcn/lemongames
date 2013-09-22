Import browser 
#Rem
	summary: This is the base class for any Screen on an interactive experiment.
#END
Class Screen Abstract

	Global GlobalResources:Resources
	
	Method RenderOnPause:Bool() Property
		Return renderonpause
	End
	
	Method RenderOnPause:Void(value:Bool) Property
		renderonpause = value
	End
	
	
	Method LoadOnPreviousScreen:Bool() Property
		Return loadOnPreviousScreen
	End
	
	Method LoadOnPreviousScreen:Void(value:Bool) Property
		loadOnPreviousScreen = value
	End
	
	#Rem
		summary: This method will be automatically called by the browser when the Screen is going to be shown.
	#END
	Method Load:Bool() abstract
	Method Unload:Bool() abstract
	#Rem
		summary: This method is called usually in every loop. It has to return a value of kind eScreenStatus.
	#END
	Method Update:Int(browser:Browser) Abstract

	#Rem
		summary: This method will be automatically called by the browser when this screen needs to be rendered.
	#END
	Method Render:Void() abstract
	
	#Rem
		summary: This property should contain an instance of the next screen to be shown, when the return status of an Update method is set to eScreenStatus.LOADNEXT
	#END
	Method NextScreen:Screen() property
		Return nextScreen	
	End
	
	Method NextScreen:Void(value:Screen) property
		nextScreen=value
	End

	Method OnBack()
		EndApp()
	End
	
	Method OnClose()
		EndApp()
	End
	
	Field fadeIn:Int = 20
	Field fadeOut:Int = 30
	Private
	Field nextScreen:Screen
	Field renderonpause:Bool = True
	
	Field loadOnPreviousScreen:Bool = False
	
End

#REM
	summary: This is an abstract class that contains all possible values that can be returned by a Screen update process.
#END
Class eScreenStatus abstract
	'summary: When a Screen update process returns EXECUTING, that means that the Screen is being executed, and it should be kept in the browser.
	Const EXECUTING:Int = 1

	'summary: When a Screen update process returns LOADNEXT, that means that the Screen has to be unloaded and next Screen has to be loaded instead.
	Const LOADNEXT:Int = 2

	'summary: When a Screen update process returns EXITBROWSER, that means that the Screen has to be unloaded and the browser has to end its execution.
	Const EXITBROWSER:Int = 3

	'summary: When a Screen update process returns PAUSE, that means that the browser has to enter PAUSE mode.
	Const PAUSE:Int = 4
End
