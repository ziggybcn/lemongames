#Rem monkeydoc Module lemongames.collections.twodimarray
	This module contains the TwoDimArray class, that is a class that allows the creation of 2 dimensional arrays
#END

#REM monkeydoc
	This is a two dimensional array.
#END
Class TwoDimArray<T> Final
	#REM monkeydoc
		This method allows the 2 dimensions array to be initialized at a given width and height.
		When a 2 dimensions array is dimensioned using this method, any previous contents it had is derefenced.
	#END	
	Method Dim:Void(width, height) Final
		Self.width = width
		Self.height = height
		data = New T[width * height]
		
	End


	#REM monkeydoc
		This method allows the 2 dimensions array to be set to a given width and height, keeping its previous contents when possible.
		Use it like this:
		myArray.ReDim(10,40)
		When a 2 dimensions array is dimensioned using this method, any previous contents it has is not dereferenced unles it gets out of bounds.
		Keep in mind that data is still stored sequentialy, so indexed may change!
	#END
	Method ReDim:Void(width, height) Final
		Self.width = width
		Self.height = height
		data = data.Resize(width * height)
	End
	#rem monkeydoc
		This method returns the current width of the 2 dimensions array
	#END
	Method GetWidth() Final
		Return width
	End
	
	#rem monkeydoc
		This method returns the current height of the 2 dimensions array
	#END
	Method GetHeight() Final
		Return height
	End
	
	#REM monkeydoc
		This method will return the number of items contained by the array.
	#END
	Method Length() Final
		Return data.Length
	End
	
	#REM monkeydoc
		This method will return the item at the given offset. That's a o(1) operation that does not generate garbage, so it is FAST.
	#END
	Method GetItemByOffset:T(item:Int) Final
		Return data[item]
	End
	
	#REM monkeydoc
		This method allows you to set the value of a given item at the given offset. That's a o(1) operation that does not generate garbage, so it is FAST.
		This method returns the value being set.
	#END
	Method SetItemByOffset:T(offset:Int, value:T) Final
		'Local val:Int = CalculateIndex(index) 'y * width + x
		data[offset] = value
		Return T
	End

	#rem monkeydoc
		This method will return the item at the given X, Y position
	#END
	Method Get:T(x:Int, y:Int) Final
		Local val:Int = y * width + x
		Return data[val]
	End
	
	#rem monkeydoc
		This method allows you to set the value of the item at the given X, Y position
		This method returns the value being set
	#END
	Method Set:T(x:Int, y:Int, value:T) Final
		Local val:Int = y * width + x
		data[val] = value
		Return T
	End
	
	'Summary:This is internaly used to allow EachIn iterations<br> This generates one object for the garbage collector, use index iteration instead of ForEach when possible.
	Method ObjectEnumerator:TwoDimArrayEnumerator<T>() Final
		Local mae:= New TwoDimArrayEnumerator<T>
		mae.InitEnumerator(data)
		Return mae
	End
	

	Private
	
	Field data:T[]
	Field width:Int = 0, height:Int = 0
End

Class TwoDimArrayEnumerator<T> Final
	Method InitEnumerator(data:T[]) Final
		index = 0
		Self.data = data
	End
	Method HasNext:Bool() Final
		Return index < data.Length
	End
	Method NextObject:T() Final
		index += 1
		Return data[index - 1]
	End
	Private
	Field data:T[]
	Field index:Int = 0
End