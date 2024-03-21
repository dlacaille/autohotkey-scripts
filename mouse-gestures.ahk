#Include "HotGestures/HotGestures.ahk"

upSlide := HotGestures.Gesture("↑:0,-10|0,-10|0,-10|0,-10|0,-10|0,-10|0,-10|0,-10|0,-10|0,-10|0,-10|0,-10|0,-10|0,-10|0,-10|0,-10|0,-10|0,-10|0,-10|0,-10")
downSlide := HotGestures.Gesture("↓:0,10|0,10|0,10|0,10|0,10|0,10|0,10|0,10|0,10|0,10|0,10|0,10|0,10|0,10|0,10|0,10|0,10|0,10|0,10|0,10")
leftSlide := HotGestures.Gesture("←:-10,0|-10,0|-10,0|-10,0|-10,0|-10,0|-10,0|-10,0|-10,0|-10,0|-10,0|-10,0|-10,0|-10,0|-10,0|-10,0|-10,0|-10,0|-10,0|-10,0")
rightSlide := HotGestures.Gesture("→:10,0|10,0|10,0|10,0|10,0|10,0|10,0|10,0|10,0|10,0|10,0|10,0|10,0|10,0|10,0|10,0|10,0|10,0|10,0|10,0")

hgs := HotGestures()
hgs.Register(upSlide, "Play/Pause", _ => Send("{Media_Play_Pause}"))
hgs.Register(leftSlide, "Previous", _ => Send("{Media_Prev}"))
hgs.Register(rightSlide, "Next", _ => Send("{Media_Next}"))
hgs.Register(downSlide, "Stop", _ => Send("{Media_Stop}"))

hgs.Hotkey("MButton") ; set MButton as the trigger
