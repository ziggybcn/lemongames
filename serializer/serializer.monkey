'Import brl.datastream
Class Serializer
	Method New()
	End
End

Class DataItem

	Method New(name:String, value:String)
		Name = name
		Value = value
	End

	Method Name:String() Property
		Return name
	End
	Method Name:Void(name:String) Property
		Self.name = name.ToLower()
	End
	
	Method Value:String() Property
		Return value
	End
	
	Method Value:Void(data:String) Property
		Self.value = data
	End
	
	Method SerializationString:String()
		Return name.Length + "|" + name + value.Length + "|" + value
	End
	
	Method Parent:DataNode()
		Return dataNode
	End
	
	Private
	
	Method Deserialize()		
		
		Name = dataNode.document.ReadString()
		
		Value = dataNode.document.ReadString()
				
	End
	
	Field name:String = ""
	Field value:String = ""
	
	Field dataNode:DataNode
End



Class DataNode
	
	Method Name:String() Property
		Return name
	End
	
	Method Name:Void(value:String) Property
	
		name = value.ToLower 
	End
	
	Method ContentsList:List<DataItem>() Property
		Return contents
	End

	Method AddItem(item:DataItem)
		item.dataNode = Self
		contents.AddLast(item)
		count += 1
	End
	
	Method RemoveItem(item:DataItem)
		contents.Remove(item)
		item.dataNode = Null
		count -= 1
	End
	
	Method GetValue:String(name:String, defaultValue:String)
		name = name.ToLower()
		For Local di:DataItem = EachIn contents
			If di.name = name Then
				 Return di.value
			EndIf
		Next
		Return defaultValue
	End
	
	Method SetValue(name:String, value:String)
		name = name.ToLower()
		For Local di:DataItem = EachIn contents
			If di.name = name Then
				 di.value = value
				 Return
			EndIf
		Next
		Local di:= New DataItem(name, value)
		AddItem(di)
	End
	
	Method Clear()
		For Local di:DataItem = EachIn contents
			di.dataNode = Null
		Next
		contents.Clear()
		count = 0
	End
	
	Method Count()
		Return count
	End
	
	Method RefreshCountIndex()
		count = contents.Count()
	End
	
	Method Parent:VirtualIndexedFile()
		Return document
	End
	
	Private
	
	Field document:VirtualIndexedFile
	
	Method SerializationString:String()
		Local data:String = ""
		data = name.Length + "|" + name + contents.Count() + "|"
		For Local di:DataItem = EachIn contents
			data = data + di.SerializationString
		Next
		Return data
	End
	
	Method Deserialize()
		contents.Clear()
		
		'We read the node name:
		Name = document.ReadString()
		
		'We read the number of items in contents:
		Local itemsCount:Int = document.ReadNum()
		
		For Local i:Int = 0 Until itemsCount
			Local di:= New DataItem
			AddItem(di)
			di.Deserialize()
		Next
	
	End
	
	Field contents:= New List<DataItem>
	Field name:String = ""
	Field count:Int = 0
End

Class VirtualIndexedFile

	Method SerializationString:String()
		Local str:String = ""
		str = count + "|"
		For Local dn:DataNode = EachIn contents
			str = str + dn.SerializationString
		Next
		Return str
	End


	Method Deserialize(data:String, index:Int = 0)
		readIndex = index
		Self.data = data
		Local cuenta:Int = ReadNum()
		For Local i:Int = 0 Until cuenta
			Local dn:= New DataNode
			AddNode(dn)
			dn.Deserialize()
		Next
	End

	Method CurrentDataDeserializationIndex:Int()
		Return readIndex
	End
	
	Method ContentsList:List<DataNode>()
		Return contents
	End

	Method AddNode(item:DataNode)
		If item.document <> Null And item.document <> Self Then
			item.document.RemoveItem(item)
		EndIf
		item.document = Self
		contents.AddLast(item)
		count += 1
	End
	
	Method AddNewNode:DataNode(name:String)
		Local dn:= New DataNode
		dn.Name = name
		AddNode(dn)
		Return dn
	End
	
	Method RemoveItem(item:DataNode)
		contents.Remove(item)
		item.document = Null
		count -= 1
	End
	
	Method RemoveItem(itemName:String)
		Local item:= Self.Get(itemName)
		If item <> Null Then
			RemoveItem item
		EndIf
	End
	
	Method Get:DataNode(name:String)
		name = name.ToLower()
		For Local di:DataNode = EachIn contents
			If di.name = name Then
				 Return di
			EndIf
		Next
		Return Null
	End
		
	Method Clear()
		For Local di:DataNode = EachIn contents
			di.document = Null
		Next
		contents.Clear()
		count = 0
	End
	
	Method Count()
		Return count
	End
	
	Method RefreshCountIndex()
		count = contents.Count()
	End

	
	Private
	Field contents:= New List<DataNode>
	Field count:Int = 0
	
	Field readIndex:Int
	Field data:String
	
	Method ReadString:String()'data:String, index:Int)
		'We read the node name:
		Local strLength:Int = ReadNum()
		Local result:= data[readIndex .. readIndex + strLength]
		readIndex += strLength
		Return result
	End
	
	Method ReadNum:Int()
		Local done:Bool = False, init:Int = readIndex
		While readIndex < data.Length And Not done
			Select data[readIndex]
				Case "0"[0], "1"[0], "2"[0], "3"[0], "4"[0], "5"[0], "6"[0], "7"[0], "8"[0], "9"[0]
					readIndex += 1
				Case "|"[0]
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