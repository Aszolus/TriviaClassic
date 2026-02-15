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

  -- Timer bar colors (RGB tuples)
  timerGreen   = {0.2, 0.8, 0.2},
  timerOrange  = {0.95, 0.7, 0.2},
  timerRed     = {0.9, 0.2, 0.2},
  timerExpired = {0.7, 0.1, 0.1},

  -- Text color codes for inline WoW markup
  colorError     = "|cffff5050",
  colorSuccess   = "|cff20ff20",
  colorHighlight = "|cffffff00",
  colorClose     = "|r",

  -- Spacing system
  spacingXS = 4,
  spacingSM = 6,
  spacingMD = 8,
  spacingLG = 12,
  spacingXL = 20,

  -- Button sizes
  btnHeightSM = 22,
  btnHeightMD = 26,
  btnWidthSM  = 60,
  btnWidthMD  = 90,
  btnWidthLG  = 120,
}

function TriviaClassic_UI_GetConstants()
  return C
end
