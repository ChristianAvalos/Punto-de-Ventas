object FrmFicheroArticulos: TFrmFicheroArticulos
  Left = 0
  Top = 0
  ClientHeight = 810
  ClientWidth = 775
  Caption = 'Fichero de Articulos'
  Color = clWhite
  BorderStyle = bsNone
  Position = poDefault
  OldCreateOrder = False
  MonitoredKeys.Keys = <>
  AlignmentControl = uniAlignmentClient
  ClientEvents.UniEvents.Strings = (
    
      'window.beforeInit=function window.beforeInit(sender, config)'#13#10'{'#13 +
      #10'  sender.cls='#39'gray_borders'#39';'#13#10#13#10'}')
  Layout = 'vbox'
  LayoutConfig.Flex = 20
  LayoutConfig.Width = '100%'
  TextHeight = 15
  object UniDBNavigator1: TUniDBNavigator
    Left = 2
    Top = 1
    Width = 241
    Height = 25
    Hint = ''
    TabOrder = 1
  end
  object UniLabel1: TUniLabel
    Left = 63
    Top = 121
    Width = 111
    Height = 13
    Hint = ''
    Caption = 'Prueba de Formulario'
    TabOrder = 0
  end
end
