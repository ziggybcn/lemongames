#Rem monkeydoc Module lemongames.collections.multiarray
	This module contains the MultiArray class, that is a class that allows the creation of multiple dimensions arrays
#END
#REM monkeydoc
	This is a multidimensional array.
#END
Class MultiArray<T> Final

	#REM monkeydoc
		This method allows the multidimensional array to be set to a given dimensions and sizes.
		Use it like this:
		myArray.Dim([3,10,7])
		This will make this array to be of 3 dimensions, being the first one of 3 items, the second one of 10 items, and the last one of 7 items.
		When a multidimensional array is dimensioned using this method, any previous contents it had is derefenced.
		This method returns the number of items this multidimensional array contains after the Dim operation
	#END
	Method Dim(dimensions:Int[]) Final
		Self.dimensions = dimensions
		Local size:Int = dimensions[0]
		For Local i:Int = 1 Until dimensions.Length
			size *= dimensions[i]
		Next
		data = New T[size]
		PrecalculateOffsets
		Return size
	End

	#REM monkeydoc
		This method allows the multidimensional array to be set to a given dimensions and sizes, and keep its previous contents when possible.
		Use it like this:
		myArray.ReDim([3,10,7])
		This will make this array to be of 3 dimensions, being the first one of 3 items, the second one of 10 items, and the last one of 7 items.
		When a multidimensional array is dimensioned using this method, any previous contents it has is not dereferenced unles it gets out of bounds.
		This method returns the number of items this multidimensional array contains after the resize
	#END
	Method ReDim(dimensions:Int[]) Final
		Self.dimensions = dimensions
		
		Local size:Int = dimensions[0]
		For Local i:Int = 1 Until dimensions.Length
			size *= dimensions[i]
		Next
		data = data.Resize(size)
		PrecalculateOffsets
		Return size
	End
	#REM monkeydoc
		This method will return the size of the indexed dimension
	#END
	Method GetDimensionSize(index:Int) Final
		Return dimensions[index]
	End
	
	#REM monkeydoc
		This method will return the number of dimensions the array has at this moment.
	#END
	Method GetNumberOfDimensions:Int() Final
		Return dimensions.Length
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
		This method will return the item at the given position. That's a o(dimensions-1) operation that does not generate garbage, so it is FAST.
		Use it like this:
		myArray.Get([3,5,8]) 
		so you get the item at (3,5,8) in your 3 dimensional array
	#END
	Method Get:T(index:Int[]) Final
		Local val:Int = CalculateIndex(index) 'y * width + x
		Return data[val]
	End
	
	#REM monkeydoc
		This method will set a given value at the given position. That's a o(dimensions-1) operation that does not generate garbage, so it is FAST.
		Use it like this:
		myArray.Set([3,5,8], MyNewValue) 
		so you the item at (3,5,8) in your 3 dimensional array gets the value MyNewValue.
	#END
	Method Set:Void(index:Int[], value:T) Final
		Local val:Int = CalculateIndex(index) 'y * width + x
		data[val] = value
	End

	#REM monkeydoc
		This method will allow you to set a value to an item at a give offset. That's a o(1) operation that does not generate garbage, so it is FAST.
		It returns the value being set
	#END
	Method SetItemByOffset:T(offset:Int, value:T) Final
		'Local val:Int = CalculateIndex(index) 'y * width + x
		data[offset] = value
		Return value
	End

	#REM monkeydoc
		This method will return the absolute offset of a item at a given position.
	#End
	Method GetOffsetForIndex(index:Int[]) Final
		Return CalculateIndex(index)
	End
	
	'Summary:This is internaly used to allow EachIn iterations<br> This generates one object for the garbage collector, use index iteration instead of ForEach when possible.
	Method ObjectEnumerator:MultiArrayEnumerator<T>() Final
		Local mae:= New MultiArrayEnumerator<T>
		mae.InitEnumerator(data)
		Return mae
	End
	
	Private
	Field data:T[]
	Field dimensions:Int[]
	Field preCalc:Int[]

	'This gets a given vector (x,y,x or whatever) and returns the corresponding index into the linear one dimensional array.
	'Despite having a loop, it has as many iterations as dimensions - 1, so it may be usualy no iterations for 2 dimensional arrays, or 1 iteration at 3 dimensional arrays.
	Method CalculateIndex(position:Int[]) Final
		#if CONFIG="debug"
			If position.Length <> dimensions.Length Then
				Error("Wrong number of dimensions, Expecting " + dimensions.Length + " but got " + position.Length)
			EndIf
		#End
		Local val = position[0]
		For Local i:Int = 1 Until preCalc.Length
			val += preCalc[i - 1] * position[i]
		Next
		Return val
	End
	
	'This makes some pre-calculation to speed up index resultion.
	Method PrecalculateOffsets() Final
		Self.preCalc = New Int[dimensions.Length]
		preCalc[0] = dimensions[0]
		For Local i:Int = 1 Until dimensions.Length
			preCalc[i] = preCalc[i - 1] * dimensions[i]
		Next
	End
End

Class MultiArrayEnumerator<T> Final
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
