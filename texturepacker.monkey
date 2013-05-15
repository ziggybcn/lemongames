Import mojo
Private
Import xmlloader
Public

Class TexturePackerLoader
	Field images:StringMap<Image>

	Method New(path:String, filename:String)
		Local error:= New XMLError
		path = path.Replace("\", "/")
		If path.EndsWith("/") = False Then path += "/"
		Local buffer:String = LoadString(path + filename)

		Local doc:= ParseXML(buffer, error)
		If error.error = True Then Error Error(error.ToString)
		
		texture = LoadImage(path + doc.GetAttribute("imagePath"))
		If images = Null Then
			images = New StringMap<Image>
		Else
			images.Clear()
		EndIf
		For Local child:XMLNode = EachIn doc.GetChildren("subtexture")

			Local posX:Int = Int(child.attributes.ValueForKey("x").value)
			Local posY:Int = Int(child.attributes.ValueForKey("y").value)
			Local height:Int = Int(child.attributes.ValueForKey("height").value)
			Local width:Int = Int(child.attributes.ValueForKey("width").value)
			Local name:String = child.attributes.ValueForKey("name").value
			Local image:Image = texture.GrabImage(posX, posY, width, height)
			images.Add(name, image)
			'For Local sm:String = EachIn child.attributes.Keys
			'	Local attribute:XMLAttribute = child.attributes.ValueForKey(sm)
			'	Print "  -> " + sm + " = " + attribute.value
			'Next
		Next		
	End
	
	Field texture:Image
	
	Method Unload()
		If images <> Null Then
			For Local i:Image = EachIn images.Values
				i.Discard()
			Next
		EndIf
		If texture <> Null Then texture.Discard
	End
	
End