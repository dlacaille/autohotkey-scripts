XStart := 0
YStart := 0

GestureAction(Action, Text)
{
  Send(Action)
}

OnGesture(Gesture)
{
  switch Gesture
  {
  case "left":
    GestureAction("{Media_Prev}", "Previous")
  case "right":
    GestureAction("{Media_Next}", "Next")
  case "up":
    GestureAction("{Media_Play_Pause}", "Play/Pause")
  case "down":
    GestureAction("{Media_Stop}", "Stop")
  }
}

MButtonDown()
{
  global XStart
  global YStart

  ; Remember mouse position start
  CoordMode "Mouse", "Screen"
  MouseGetPos &XStart, &YStart
}

MButtonUp()
{
  global XStart
  global YStart

  ; Check where we ended up
  CoordMode "Mouse", "Screen"
  MouseGetPos &XPos, &YPos
  XDelta := XPos - XStart
  YDelta := YPos - YStart
  
  ; Detect the gesture
  MinDelta := 50
  XDeltaAbs := Abs(XDelta)
  YDeltaAbs := Abs(YDelta)
  IsHoriz := XDeltaAbs > MinDelta && XDeltaAbs > YDeltaAbs
  IsVert := YDeltaAbs > MinDelta && XDeltaAbs < YDeltaAbs
  if (IsHoriz)
    OnGesture(XDelta < 0 ? "left" : "right")
  else if (IsVert)
    OnGesture(YDelta < 0 ? "up" : "down")
  else ; Middle click
    Send("{MButton}")
}

MButton::MButtonDown()
MButton Up::MButtonUp()
