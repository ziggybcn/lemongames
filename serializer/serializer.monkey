#Rem monkeydoc Module lemongames.serializer
	Documentation for my.module goes here...
#End


#Rem monkeydoc
	This class represents a serialized item. It has name and value atributes.
#END
Class DataItem

	#rem  monkeydoc
		Used to create a new DateItem with a given Name and Value
	#END
	Method New(name:String, value:String)
		Name = name
		Value = value
	End

	#Rem  monkeydoc
		This is the Name of the DataItem. This name can be used later to look for this data item value into a DataNode.
	#END
	Method Name:String() Property
		Return name
	End

	#Rem  monkeydoc
		This is the Name of the DataItem. This name can be used later to look for this data item value into a DataNode.
	#END
	Method Name:Void(name:String) Property
		Self.name = name.ToLower()
	End
	
	#Rem  monkeydoc
		This is the Value of the DataItem. 
	#END
	Method Value:String() Property
		Return value
	End
	
	#Rem monkeydoc
		This is the Value of the DataItem. 
	#END
	Method Value:Void(data:String) Property
		Self.value = data
	End
	
	#Rem monkeydoc
		This method returns a string that represent the serialization of this DataItem
	#END
	Method SerializationString:String()
		Return name.Length + "|" + name + value.Length + "|" + value
	End
	
	#Rem  monkeydoc
		This method returns the DataNode where this DataItem is currently stored
	#END
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



	#Rem monkeydoc
		This class is a DataNode. It acts like a folder where DataItems are stored.
	#END
Class DataNode
	#Rem monkeydoc
		This property is the name of the DataNode. This name can be used to locate the DataNode into the VirtualIndexedFile
	#END
	Method Name:String() Property
		Return name
	End
	
	#Rem monkeydoc
		This property is the name of the DataNode. This name can be used to locate the DataNode into the VirtualIndexedFile
	#END
	Method Name:Void(value:String) Property
	
		name = value.ToLower 
	End
	
	#Rem monkeydoc
		This method returns the list internaly used to store all the DataItems.
		NOTE: If you modify this list directly, be sure to call the RefreshCountIndex when you've finished modified the list contents.
	#END
	Method ContentsList:List<DataItem>() Property
		Return contents
	End

	#Rem monkeydoc
		This method allows you to add an existing DataItem to the DataNode.
	#END
	Method AddItem(item:DataItem)
		If item.dataNode <> Null And item.dataNode <> Self Then item.dataNode.RemoveItem(item)
		item.dataNode = Self
		contents.AddLast(item)
		count += 1
	End
	
	#Rem monkeydoc
		This method allows you to remove an existing DataItem to the DataNode.
	#END
	Method RemoveItem(item:DataItem)
		contents.Remove(item)
		item.dataNode = Null
		count -= 1
	End
	
	#Rem monkeydoc
		This method allows you to get the value of a given DataItem by its name.
		Notice that if the DataItem does not exists, the defaultValue will be returned instead.
	#END
	Method GetValue:String(name:String, defaultValue:String)
		name = name.ToLower()
		For Local di:DataItem = EachIn contents
			If di.name = name Then
				 Return di.value
			EndIf
		Next
		Return defaultValue
	End
	
	#Rem monkeydoc
		This method allows you to set the value of a given DataItem by its name.
		Notice that if the DataItem does not exists, it will be created and added to the DataNode on the fly
	#END
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
	
	#Rem monkeydoc
		This method removes all DataItem(s) from this DataNode.
	#END
	Method Clear()
		For Local di:DataItem = EachIn contents
			di.dataNode = Null
		Next
		contents.Clear()
		count = 0
	End
	
	#Rem monkeydoc
		This method returns the estimated number of contained items in this DataNode.
		If you manually modify the internal List of DataItems, this number is not reliable untill you call RefreshCountIndex.
	#END
	Method Count()
		Return count
	End
	
	#Rem monkeydoc
		Use this method to manually refresh the count of DataIndex into this DataNode.
		You only need to call this method if you have modified the contents of the internal DataItem list.
	#END
	Method RefreshCountIndex()
		count = contents.Count()
	End
	
	#Rem monkeydoc
		This method will return the VirtualIndexedFile where this DataNode is stored.
	#END
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

#rem monkeydoc
	This class represents a virtual indexed file that can be serialized and deserialized in the form of a String.
#END
Class VirtualIndexedFile

	#rem monkeydoc
		This method returns the Serialization string that can be used to thinkgs like storing the VirtualIndexedFile contents to disk, or sending it to a server
	#END
	Method SerializationString:String()
		Local str:String = ""
		str = count + "|"
		For Local dn:DataNode = EachIn contents
			str = str + dn.SerializationString
		Next
		Return str
	End


	#rem monkeydoc
		This method reads the contents of a SerializationString and recreates the VirtualIndexedFile contents
	#END
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

	#rem monkeydoc
		This method returns the character into the string where the last deserialization operation ended. 
		This can be used to chain diferent VirtualIndexedFile(s) into a single string.
	#END
	Method CurrentDataDeserializationIndex:Int()
		Return readIndex
	End
	#rem monkeydoc
		This method returns the list internaly used to store all the internally contained DataNodes.
	#END	
	Method ContentsList:List<DataNode>()
		Return contents
	End

	#rem monkeydoc
		This method can be used to add an existing DataNode to the VirtualIndexedFile.
	#END	
	Method AddNode(item:DataNode)
		If item.document <> Null And item.document <> Self Then
			item.document.RemoveItem(item)
		EndIf
		item.document = Self
		contents.AddLast(item)
		count += 1
	End
	
	#rem monkeydoc
		This method can be used to create a new DataNode with a given name, and add it to the VirtualIndexedFile.
	#END	
	Method AddNewNode:DataNode(name:String)
		Local dn:= New DataNode
		dn.Name = name
		AddNode(dn)
		Return dn
	End
	
	#rem monkeydoc
		This method can be used to remove an existing DataNode from this VirtualIndexedFile.
	#END	
	Method RemoveItem(item:DataNode)
		contents.Remove(item)
		item.document = Null
		count -= 1
	End
	
	#rem monkeydoc
		This method can be used to remove an existing DataNode from this VirtualIndexedFile, by its name.
	#END	
	Method RemoveItem(itemName:String)
		Local item:= Self.Get(itemName)
		If item <> Null Then
			RemoveItem item
		EndIf
	End
	
	#rem monkeydoc
		This method can be used to get an existing DataNode by its name.
	#END	
	Method Get:DataNode(name:String)
		name = name.ToLower()
		For Local di:DataNode = EachIn contents
			If di.name = name Then
				 Return di
			EndIf
		Next
		Return Null
	End
		
	#rem monkeydoc
		This method can be used to clear all the VirtualIndexedFile contents.
	#END	
	Method Clear()
		For Local di:DataNode = EachIn contents
			di.document = Null
		Next
		contents.Clear()
		count = 0
	End
	
	#rem monkeydoc
		This method will return the count of contained DataNodes.
		If the internal list has been manually modified, be sure to call RefreshCountIndex to get accurate results.
	#END	
	Method Count()
		Return count
	End
	
	#Rem monkeydoc
		Use this method to manually refresh the count of DataNode(s) into this VirtualIndexedFile.
		You only need to call this method if you have modified the contents of the internal DataNode list.
	#END
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
		Return Int("0" + data[init .. readIndex - 1]) 'In case it is an empty string
	End
	
End