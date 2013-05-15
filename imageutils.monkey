Import mojo
'Import junglegui

Function MidHandleImage:Void(image:Image)
	If image = Null Then Return
	image.SetHandle(image.Width / 2, image.Height / 2)
End


Function DrawBox(x:Float, y:Float, width:Float, height:Float)
	DrawRect(x,y,width-1,1) '---
	DrawRect(x, y, 1, height - 1) '|--
	DrawRect(x + width - 1, y, 1, height - 1)'--|
	DrawRect(x, y + height - 1, width, 1) '___				
End
