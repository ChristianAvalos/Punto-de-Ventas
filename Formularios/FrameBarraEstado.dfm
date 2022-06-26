object FmeBarraEstado: TFmeBarraEstado
  Left = 0
  Top = 0
  Width = 900
  Height = 25
  OnCreate = UniFrameCreate
  TabOrder = 0
  ParentRTL = False
  PixelsPerInch = 96
  object UniStatusBar: TUniStatusBar
    Left = 0
    Top = 0
    Width = 900
    Height = 25
    Hint = ''
    Panels = <
      item
        Text = 'Texto'
        Width = 50
      end>
    SizeGrip = True
    Align = alTop
    ParentColor = False
    Color = clBtnFace
  end
end
