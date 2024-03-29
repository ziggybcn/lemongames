'summary: This is just an integer vector class
Class DrawingPointInt Final
	'summary: The X pos of the vector
	Field x:Int
	'summary: The Y pos of the vector
	Field y:Int
	'summary: Set both values of the vector at the same time
	Method Set(x:Int, y:Int)
		Self.x = x;
		Self.y = y;
	End
	
	Method Copy(drawingPoint:DrawingPointInt)
		x = drawingPoint.x
		y = drawingPoint.y
	End
	'summary: Creates a new instance of this vector, getting default values at creation time:
	Method New(x:Int, y:Int)
		Self.x = x; Self.y = y;
	End
	Method ToString:String()
		Return "(" + x + ", " + y + ")"
	End
	
	Method Clone:DrawingPointInt()
		Local dp:= New DrawingPointInt(x, y)
		Return dp
	End
End
