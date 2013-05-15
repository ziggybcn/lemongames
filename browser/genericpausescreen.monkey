Import browser
Class GenericPauseScreen Extends Screen
	Method Load:Bool()
		Return True
	End
	
	Method Unload:Bool()
		Return True
	End
	Method Render:Void()
		'Cls(0, 0, 0)
		SetColor(0, 0, 0)
		SetAlpha(0.6)
		DrawRect(0, 0, Browser.LogicalResolution.x, Browser.LogicalResolution.y)
		SetAlpha(1)
		SetColor(255, 255, 255)
		Local text:String = "PAUSE~nTouch screen to continue..."
		If Resources.BigFont <> Null Then
			Local height:Int = Resources.BigFont.GetTxtHeight(text)
			Resources.BigFont.DrawText(text, Browser.LogicalResolution.x / 2, Browser.LogicalResolution.y / 2 - height / 2, eDrawAlign.CENTER)
		Else
			DrawText(text, 0, 0)
		EndIf
	End
	Method Update:Int(browser:Browser)
		If KeyHit(KEY_ENTER) or TouchHit(0) Then
			Return eScreenStatus.EXECUTING
		Else
			Return eScreenStatus.PAUSE
			
		EndIf
	End
End