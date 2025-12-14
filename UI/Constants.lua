local C = {
  -- More compact host panel sizing
  frameWidth = 640,
  frameHeight = 480,
  padding = 12,
  -- Column widths tuned for the narrower frame
  leftWidth = 420,
  rightWidth = 180,
  setHeight = 200,
  controlGap = 8,
}

function TriviaClassic_UI_GetConstants()
  return C
end
