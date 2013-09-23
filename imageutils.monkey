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

Function FillRoundRect(x, y, width, height, radius)
	
	DrawOval(x, y, radius * 2, radius * 2) ' ARRIBA IZQUIERDA
	DrawOval(x + width - radius * 2, y, radius * 2, radius * 2) ' ARRIBA DERECHA
	DrawOval(x, y + height - radius * 2, radius * 2, radius * 2) ' ABAJO IZQUIERDA
	DrawOval(x + width - radius * 2, y + height - radius * 2, radius * 2, radius * 2) ' ABAJO DERECHA

	DrawRect(x + radius, y, width - radius * 2, radius * 2 + 2)
	DrawRect(x + radius, y + height - radius - 2, width - radius * 2, radius + 2)
	DrawRect(x, y + radius, width, height - radius * 2)
		
End
