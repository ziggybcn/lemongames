'Import brl.datastream
Class Serializer
	Method New()
	End
End

Class DataItem Extends Serializable
	Method Name:String() Property
		Return name
	End
	Method Name:Void(name:String) Property
		Self.name = name
	End
	
	Method Value:String() Property
		Return value
	End
	
	Method Value:Void(data:String) Property
		Self.value = data
	End
	
	Method SerializeString:String()
		Return name.Length + "," + name + value.Length + "," + value
	End
	
	Method Deserialize(data:String, index:Int)
		readIndex = index
		Local nameLength:Int = ReadNum(data, readIndex)
		Name = data[readIndex .. readIndex + nameLength]
		readIndex += nameLength
		Local valueLength = ReadNum(data, readIndex)
		Value = data[readIndex .. readIndex + valueLength]
		readIndex += valueLength
		Print "INDEX=" + readIndex		
	End
	
	Private
	Field name:String = ""
	Field value:String = ""	
End


Class Serializable
	Private
	Field readIndex:Int
	Method ReadNum:Int(data:String, index:Int)
		Local done:Bool = False, init:Int = index
		While readIndex < data.Length And Not done
			Select data[readIndex]
				Case "0"[0], "1"[0], "2"[0], "3"[0], "4"[0], "5"[0], "6"[0], "7"[0], "8"[0], "9"[0]
					readIndex += 1
				Case ","[0]
					readIndex += 1
					done = True
				Default
					'NOTE: TODO: Raise Execption
					done = True
			End
		Wend
		Return Int("0" + data[init .. readIndex]) 'In case it is an empty string
	End

End

Class DataNode Extends Serializable
	Method Name:String() Property
		Return name
	End
	
	Method Name:Void(value:String) Property
		name = value
	End
	
	Method Contents:List<DataItem>() Property
		Return contents
	End
	
	Method SerializeString:String()
		Local data:String = ""
		data = name.Length + "," + name + contents.Count() + ","
		For Local di:DataItem = EachIn contents
			data = data + di.SerializeString
		Next
		Return data
	End
	
	Method Deserialize(data:String, index:Int, KeepContents:Bool = False)
		readIndex = index
		If Not KeepContents Then contents.Clear()
		
		'We read the node name:
		Local nameLength:Int = ReadNum(data, readIndex)
		Name = data[readIndex .. readIndex + nameLength]
		readIndex += nameLength
		
		'We read the number of items in contents:
		Local itemsCount:Int = ReadNum(data, readIndex)
		
		For Local i:Int = 0 Until itemsCount
			Local di:= New DataItem
			di.Deserialize(data, readIndex)
			readIndex = di.readIndex
			contents.AddLast(di)
		Next
	
	End
	

	Private
	Field contents:= New List<DataItem>
	Field name:String = ""
End

'note: TODO: dataIndex has to be a filed in VirtualIndexedFile, and not a field on each item and node.

Class VirtalIndexedFile Extends Serializable
	
End