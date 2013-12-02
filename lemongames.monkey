#rem monkeydoc Module lemongames
	This is the lemongames module
#END
'This file was edited with Jungle IDE
Import mojo
Import browser
Import drawingpointint
Import fontmachine
Import imageutils
Import welcomepage
Import texturepacker
#IF CONFIG="debug"
Import reflection
#END
Import mixer
Import serializer

Class Resources Abstract
	Global SystemFont:BitmapFont
	Global BigFont:BitmapFont
	Method Load() Abstract
	Method Unload() Abstract
End

Function MouseVX:Float()
	Return Browser.LogicalX(MouseX())
End

Function MouseVY:Float()
	Return Browser.LogicalY(MouseY())
End

Function TouchVX:Float(index:Int)
	Return Browser.LogicalX(TouchX(index))
End

Function TouchVY:Float(index:Int)
	Return Browser.LogicalY(TouchY(index))
End

Function DumpClasses()
#IF CONFIG="debug"
		For Local cinfo:= EachIn GetClasses()
			Local exts$
			If cinfo.SuperClass exts+=" Extends "+cinfo.SuperClass.Name
			DebugLog "Class " + cinfo.Name + Attribs(cinfo.Attributes()) +exts
			For Local info:=Eachin cinfo.GetConstructors()
				DebugLog "  Method New"+Args( info.ParameterTypes )+Attribs( info.Attributes() )
			Next
			For Local info:=Eachin cinfo.GetConsts( False )
				DebugLog "  Const "+info.Name+Ret( info.Type )+Attribs( info.Attributes() )
			Next
			For Local info:=Eachin cinfo.GetGlobals( False )
				DebugLog "  Global "+info.Name+Ret( info.Type )+Attribs( info.Attributes() )
			Next
			For Local info:=Eachin cinfo.GetFields( False )
				DebugLog "  Field "+info.Name+Ret( info.Type )+Attribs( info.Attributes() )
			Next
			For Local info:=Eachin cinfo.GetMethods( False )
				DebugLog "  Method "+info.Name+Ret( info.ReturnType )+Args( info.ParameterTypes )+Attribs( info.Attributes() )
			Next
			For Local info:=Eachin cinfo.GetFunctions( False )
				DebugLog "  Method "+info.Name+Ret( info.ReturnType )+Args( info.ParameterTypes )+Attribs( info.Attributes() )
			Next
		Next
#ELSE
	'Print "Dump Classes unavailable on release mode."
#END
	End

Function Attribs:String(attrs)
	Local t$
	If attrs & ATTRIBUTE_EXTERN t+=" Extern"
	If attrs & ATTRIBUTE_PRIVATE t+=" Private"
	If attrs & ATTRIBUTE_ABSTRACT t+=" Abstract"
	If attrs & ATTRIBUTE_FINAL t+=" Final"
	If attrs & ATTRIBUTE_INTERFACE t+=" Interface"
	Return t
End

Function Ret$( t:ClassInfo )
	If t Return ":"+t.Name
	Return ":Void"
End

Function Args$( t:ClassInfo[] )
	Local p:=""
	For Local c:=Eachin t
		If p p += ","
		p+=c.Name
	Next
	Return "(" + p + ")"
	
End

Function AppDecls()
	For Local info:=Eachin GetConsts()
		DebugLog "Const "+info.Name+Ret( info.Type )+Attribs( info.Attributes() )
	Next
	For Local info:=Eachin GetGlobals()
		DebugLog "Global "+info.Name+Ret( info.Type )+Attribs( info.Attributes() )
	Next
	For Local info:=Eachin GetFunctions()
		DebugLog "Function "+info.Name+Ret( info.ReturnType )+Args( info.ParameterTypes )+Attribs( info.Attributes() )
	Next
	For Local cinfo:=Eachin GetClasses()
		Local exts$
		If cinfo.SuperClass exts+=" Extends "+cinfo.SuperClass.Name
		DebugLog "Class "+cinfo.Name+Attribs( cinfo.Attributes() )+exts
		For Local info:=Eachin cinfo.GetConstructors()
			DebugLog "  Method New"+Args( info.ParameterTypes )+Attribs( info.Attributes() )
		Next
		For Local info:=Eachin cinfo.GetConsts( False )
			DebugLog "  Const "+info.Name+Ret( info.Type )+Attribs( info.Attributes() )
		Next
		For Local info:=Eachin cinfo.GetGlobals( False )
			DebugLog "  Global "+info.Name+Ret( info.Type )+Attribs( info.Attributes() )
		Next
		For Local info:=Eachin cinfo.GetFields( False )
			DebugLog "  Field "+info.Name+Ret( info.Type )+Attribs( info.Attributes() )
		Next
		For Local info:=Eachin cinfo.GetMethods( False )
			DebugLog "  Method "+info.Name+Ret( info.ReturnType )+Args( info.ParameterTypes )+Attribs( info.Attributes() )
		Next
		For Local info:=Eachin cinfo.GetFunctions( False )
			DebugLog "  Method "+info.Name+Ret( info.ReturnType )+Args( info.ParameterTypes )+Attribs( info.Attributes() )
		Next
		
	Next
End


