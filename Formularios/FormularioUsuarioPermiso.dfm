object FrmUsuarioPermiso: TFrmUsuarioPermiso
  Left = 0
  Top = 0
  ClientHeight = 641
  ClientWidth = 565
  Caption = 'Permisos de Usuarios'
  OnShow = UniFormShow
  BorderStyle = bsDialog
  OldCreateOrder = False
  OnClose = UniFormClose
  MonitoredKeys.Keys = <>
  OnAjaxEvent = UniFormAjaxEvent
  OnCreate = UniFormCreate
  TextHeight = 15
  object tgridMenu: TUniDBTreeGrid
    Left = 8
    Top = 28
    Width = 549
    Height = 514
    Hint = ''
    DataSource = DMComunUsuario.DSMenu
    ClientEvents.UniEvents.Strings = (
      
        'beforeInit=function beforeInit(sender, config)'#13#10'{'#13#10'    config.fo' +
        'rceFit = true;'#13#10'}'
      
        'pagingBar.beforeInit=function pagingBar.beforeInit(sender, confi' +
        'g)'#13#10'{'#13#10'    sender.displayMsg = '#39'Items(s) {2}'#39';// defaultvalue = ' +
        #39'Displaying {0} - {1} of {2}'#13#10'  sender.displayInfo = true;'#13#10'}')
    TabOrder = 2
    LoadMask.WaitData = True
    LoadMask.Message = 'Aguarde un momento...'
    LoadMask.Target = Owner
    IdParentField = 'IdMenuPadre'
    IdField = 'IdMenu'
    OnDrawColumnCell = tgridMenuDrawColumnCell
    OnCellContextClick = tgridMenuCellContextClick
    OnDblClick = tgridMenuDblClick
    OnFieldImage = tgridMenuFieldImage
    Columns = <
      item
        FieldName = 'Caption'
        Filtering.Enabled = True
        Title.Alignment = taCenter
        Title.Caption = 'Men'#250
        Width = 335
        ReadOnly = True
      end
      item
        FieldName = 'Permitido'
        Title.Alignment = taCenter
        Title.Caption = 'Permitido'
        Width = 70
        Alignment = taCenter
        GroupHeader = 'Acceso'
      end
      item
        FieldName = 'TipoAcceso'
        Title.Alignment = taCenter
        Title.Caption = 'Tipo de acceso'
        Width = 100
        ReadOnly = True
        GroupHeader = 'Acceso'
      end
      item
        FieldName = 'Icono'
        Title.Caption = '  '
        Width = 30
        Alignment = taCenter
        ReadOnly = True
        ImageOptions.Visible = True
        ImageOptions.Width = 16
        ImageOptions.Height = 16
      end>
  end
  object lnkSeleccionarTodos: TUniLabel
    Left = 8
    Top = 9
    Width = 91
    Height = 13
    Cursor = crHandPoint
    Hint = ''
    Caption = 'Seleccionar todos'
    ParentFont = False
    Font.Color = clBlue
    TabOrder = 0
    ScreenMask.Enabled = True
    ScreenMask.WaitData = True
    ScreenMask.Message = 'Aguarde un momento...'
    ScreenMask.Target = Owner
    OnClick = lnkSeleccionarTodosClick
  end
  object lnkDesmarcarTodos: TUniLabel
    Left = 102
    Top = 9
    Width = 86
    Height = 13
    Cursor = crHandPoint
    Hint = ''
    Caption = 'Desmarcar todos'
    ParentFont = False
    Font.Color = clBlue
    TabOrder = 1
    ScreenMask.Enabled = True
    ScreenMask.WaitData = True
    ScreenMask.Message = 'Aguarde un momento...'
    ScreenMask.Target = Owner
    OnClick = lnkDesmarcarTodosClick
  end
  object btnCopiarPermisoDeOtroUsuario: TUniBitBtn
    Left = 8
    Top = 550
    Width = 207
    Height = 36
    Hint = ''
    Glyph.Data = {
      F6060000424DF606000000000000360000002800000018000000180000000100
      180000000000C0060000C30E0000C30E00000000000000000000FF00FFFF00FF
      FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
      FFFF00FFFF00FFFF00FFFF00FFFF00FFAF7134FF00FFFF00FFFF00FFFF00FFFF
      00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
      FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFAF7134AF7134B07338FF00
      FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
      00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFAF7134AF7134
      AF7134AF7134AF7134FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
      FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFAF
      7134AF7134AF7134AF7134AF7134AF7134AF7134FF00FFFF00FFFF00FFBD8854
      B17335AF6F2FAF6F2FAF6F2FAF6F2FAF6F2FAF6F2FAF6F2FAF6F2FAF6F2FBC8B
      5BFF00FFAF7134AF7134AF7134AF7134AF7134AF7134AF7134AF7134AF7134FF
      00FFAC6D2EAC6D2EAC6D2FAC6D2FAC6D2FAC6D2FAD6E2FAD6E2FAD6E2FAC6D2F
      AC6D2FAC6D2FFF00FFAF7134AF7134AF7134AF7134AF7134AF7134AF7134AF71
      34AF7134AF7134AF7134AE7133AD6E2FAD6E2FAD6E2FAD6E2FAD6E2FAC6D2EA6
      611DAC6D2FAD6E2FAD6E2FAD6E2FFF00FFAF7134AF7134AF7134FF00FFAF7134
      AF7134AF7134FF00FFAF7134AF7134AF7134B6834FAD6E2FAD6E2FAD6E2FAD6E
      2FAC6E2F9F560ED8BA9B9E550CAC6E2FAD6E2FAD6E2FFF00FFAF7134AF7134FF
      00FFFF00FFAF7134AF7134AF7134FF00FFFF00FFAF7134AF7134BE956CAD6E2F
      AD6E2FAD6E2FAD6F2F9B4C03F4EEE4FFFFFFF1E5DB9C5004AD6F31AD6E2FFF00
      FFAF7134FF00FFFF00FFFF00FFAF7134AF7134AF7134FF00FFC6D2B5FF00FFAF
      7134FF00FFAC6D2EAC6D2FAD6E2FA7621FC79D74FFFFFFFFFFFFFFFFFFC4976C
      A76320AD6E2FFF00FFFF00FFFF00FF9ABB73FF00FFAF7134AF7134AF7134FF00
      FF7AA53CFF00FFFF00FFFF00FFFF00FFC8AA8BAB6D2E9D5409FFFFFFEFE2D7C7
      9B73F9F5F1FFFFFF9C5004B46B34FF00FFFF00FFF4F4F462981DFF00FFAF7134
      AF7134AF7134FF00FF7BA53CFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
      FFD5B89D9C4F03D5B597934300E1D1C3FF00FFFF00FFB5C79B96C270FFFFFFA0
      BE74FF00FFAF7134AF7134AF7134FF00FF88AD52FF00FFFF00FFFF00FFFF00FF
      FF00FFFF00FFFF00FF9F580FFFFFFFFFFFFFFFFFFF9B4800FF00FF70AF3C6297
      19F0F4ECFFFFFFF2F4EDFF00FFFF00FFFF00FFFF00FFFF00FFA0BD76FF00FFFF
      00FFFF00FFFF00FFFF00FFFF00FFB07941ECDDCFFFFFFFFFFFFFFFFFFFDEC2AC
      C29D79BECBA781AD4AFFFFFFFFFFFFFFFFFF83AC4876A2367CA73D7CA63D7BA6
      3CFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF9C530AFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFA04904FF00FFFFFFFFF4F9EFADC688FDFFFEFFFFFF5F9213
      7BA53CB1C694FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFAF76
      3CFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFA0560FFF00FFD1E7C44D8600A5C47C4B
      8500DCE5D0FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
      FF00FFFF00FFA96929FFFFFFFDFCFCF5EFEBFEFFFFFFFFFFA4550FFF00FF5394
      0CFFFFFFFFFFFFFFFFFF528C02FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
      00FFFF00FFFF00FFFF00FFFF00FFAA692AA6611C9E540B9F57109E530BA5601C
      AD6629FF00FFC3DFAEFFFFFFFFFFFFFFFFFFC1D4A29DBA76FF00FFFF00FFFF00
      FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFB88A5CAB6C2DAD6E30AD
      6E30AD6E30AC6C2DC8A487FF00FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF64971B
      FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
      FFD6C3B1C69D73C19366C69E76FF00FFFF00FF72A837FFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFF6B9A24FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
      FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF719E2DF7FB
      F6FFFFFFFBFAF7CFDFB9C0D4A575A235FF00FFFF00FFFF00FFFF00FFFF00FFFF
      00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
      FF00FF77A43974A03185AE4D6396186C9C27709D2A7AA53CFF00FFFF00FFFF00
      FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
      00FFFF00FFFF00FFFF00FF7BA53C7AA53A77A2377DA73E7CA73D7CA73D7DA63F
      FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
      FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF98B66B7DA8407CA73D7F
      A8429CB973FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF}
    Caption = 'Copiar permisos de otro usuario'
    TabOrder = 5
    ScreenMask.Enabled = True
    ScreenMask.Message = 'Aguarde un momento...'
    ScreenMask.Target = Owner
    OnClick = btnCopiarPermisoDeOtroUsuarioClick
  end
  object chkOcultarMenuSinAcceso: TUniDBCheckBox
    Left = 371
    Top = 548
    Width = 161
    Height = 17
    Hint = ''
    DataField = 'OcultarMenuSinAcceso'
    DataSource = DMUsuario.DSUsuario
    Caption = 'Ocultar men'#250's sin acceso'
    TabOrder = 3
    ParentColor = False
    Color = clBtnFace
  end
  object UniImageControles: TUniImage
    Left = 199
    Top = 6
    Width = 16
    Height = 16
    Hint = ''
    Visible = False
    AutoSize = True
    Picture.Data = {
      07544269746D617036030000424D360300000000000036000000280000001000
      000010000000010018000000000000030000C30E0000C30E0000000000000000
      0000FF00FFFF00FFFF00FFFF00FFFF00FF8F8F8F6767675757575858586D6D6D
      959595FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF8282825353
      53888888C1C1C1DBDBDBD9D9D9BCBCBC7D7D7D555555919191FF00FFFF00FFFF
      00FFFF00FFFF00FF686868696969EAEAEAFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFDEDEDE5F5F5F767676FF00FFFF00FFFF00FF7E7E7E6A6A6AFFFFFFFFFF
      FFF4F4F4E0E0E0D7D7D7D8D8D8E1E1E1F6F6F6FFFFFFF9F9F95E5E5E949494FF
      00FFFF00FF545454EEEEEEFFFFFFE8E8E8D6D6D6D9D9D9D9D9D9D9D9D9D9D9D9
      D6D6D6EEEEEEFFFFFFD7D7D7555555FF00FF8888888F8F8FFFFFFFF2F2F2D7D7
      D7DADADADADADADADADADADADADADADADADADAD6D6D6F8F8F8FFFFFF7878789B
      9B9B5F5F5FCBCBCBFFFFFFDEDEDED9D9D9DADADADADADADADADADADADADADADA
      DADADAD9D9D9E4E4E4FFFFFFB4B4B4727272575757E7E7E7FFFFFFD6D6D6DADA
      DADADADADADADADADADADADADADADADADADADAD9D9D9DBDBDBFFFFFFD0D0D05E
      5E5E575757E7E7E7FFFFFFD6D6D6DADADADADADADADADADADADADADADADADADA
      DADADAD9D9D9DBDBDBFFFFFFD0D0D05E5E5E5F5F5FCBCBCBFFFFFFDFDFDFD9D9
      D9DADADADADADADADADADADADADADADADADADAD9D9D9E4E4E4FFFFFFB4B4B472
      72728787878F8F8FFFFFFFF2F2F2D6D6D6DADADADADADADADADADADADADADADA
      DADADAD6D6D6F9F9F9FFFFFF7777779B9B9BFF00FF545454EEEEEEFFFFFFE9E9
      E9D6D6D6D9D9D9D9D9D9D9D9D9D9D9D9D6D6D6EEEEEEFFFFFFD7D7D7555555FF
      00FFFF00FF7E7E7E6A6A6AFFFFFFFFFFFFF4F4F4E0E0E0D8D8D8D8D8D8E3E3E3
      F8F8F8FFFFFFF9F9F95E5E5E949494FF00FFFF00FFFF00FF686868696969EAEA
      EAFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFDEDEDE5F5F5F767676FF00FFFF
      00FFFF00FFFF00FFFF00FF828282535353888888C1C1C1DADADAD9D9D9BCBCBC
      7D7D7D555555909090FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
      FF8E8E8E6767675757575858586D6D6D949494FF00FFFF00FFFF00FFFF00FFFF
      00FF}
    Transparent = True
  end
  object btnAccesoControles: TUniBitBtn
    Left = 219
    Top = 550
    Width = 146
    Height = 36
    Hint = ''
    Glyph.Data = {
      F6060000424DF606000000000000360000002800000018000000180000000100
      180000000000C0060000C30E0000C30E00000000000000000000FF00FFFF00FF
      FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
      FFFF00FFFF00FFC69C73B67B40B67A3FB3783EB3783EB67A3FB77E45C7A079FF
      00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
      FF00FFFF00FFFF00FFFF00FFB3783EB3783EB3783EB3783EB3783EB3783EB378
      3EB3783EB3783EB3783E68686867676767676767676767676767676767676767
      6767676767676767676767676767848484FF00FFB3783EB3783EB3783EB3783E
      B3783EB3783EB3783EB3783EB3783EB3783E676767FFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF9F9F9FF00FFA76523B3
      783EB3783EB3783EB3783EB3783EB3783EB3783EB3783EBA8A5A676767FFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFE
      FEFF00FFCEBBA8B3783EB3783EB3783EB3783EB3783EB3783EB3783EB3783EFF
      00FF676767FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFF0F0F0FF00FFC3A385A6611DC5A280FF00FFFF00FFC39E
      79A6611DCCB6A1FF00FF676767FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFEFEEBEBEBFF00FFFF00FFFF00FF
      C7A686C8A889FF00FFFF00FFFF00FFFF00FF676767FFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFAFAFAFF
      00FFC4A587B3783EB3783EB3783EB3783ECAB39CFF00FFFF00FF676767FFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFEEEEEEFF00FFB3783EB3783EB3783EB3783EB3783EB3783EFF00FFFF
      00FF676767FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFE9E9E9CEB8A3B3783EB3783EB3783EB3783EB378
      3EB3783EFF00FFFF00FF686868FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFECECECFF00FFB3783EB3783E
      B3783EB3783EB3783EB3783EFF00FFFF00FF686868FFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF6F6F6FF
      00FFB3783EB3783EB3783EB3783EB3783EAA6A2BFF00FFFF00FF686868FFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFEDEDEDFF00FFBA8A5AB3783EB3783EBD8F61ABABABFF00FFFF
      00FF88AC5588AC5588AC5588AC5588AC5588AC5588AC5588AC5588AC5588AC55
      88AC5588AC5588AC5588AC5588AC5588AC55A8BF87FF00FFFF00FFE9E9E9F4F4
      F4676767FF00FFFF00FF88AC5588AC5588AC5588AC5588AC5588AC5588AC5588
      AC5588AC5588AC5588AC5588AC5588AC5588AC5588AC5588AC5588AC55FF00FF
      FFFFFFFFFFFFFFFFFF676767FF00FFFF00FF88AC5588AC5588AC5588AC5588AC
      5588AC5588AC5588AC5588AC5588AC5588AC5588AC5588AC5588AC5588AC5588
      AC5588AC55FF00FFFFFFFFFFFFFFFFFFFF676767FF00FFFF00FF88AC5588AC55
      88AC5588AC5588AC5588AC5588AC5588AC5588AC5588AC5588AC5588AC5588AC
      5588AC5588AC5588AC5588AC55FF00FFFFFFFFFFFFFFFFFFFF676767FF00FFFF
      00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
      FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFFFFFFFFFFFFFFFF
      FF676767FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF686868FFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFF676767FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
      FF686868FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF676767FF00FFFF00FFFF00FFFF00FF
      FF00FFFF00FFFF00FF88AC5588AC5588AC5588AC5588AC5588AC5588AC5588AC
      5588AC5588AC5588AC5588AC5588AC5588AC5588AC5588AC5588AC55FF00FFFF
      00FFFF00FFFF00FFFF00FFFF00FFFF00FF88AC5588AC5588AC5588AC5588AC55
      88AC5588AC5588AC5588AC5588AC5588AC5588AC5588AC5588AC5588AC5588AC
      5588AC55FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF88AC5588AC5588
      AC5588AC5588AC5588AC5588AC5588AC5588AC5588AC5588AC5588AC5588AC55
      88AC5588AC5588AC5588AC55FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
      FF88AC5588AC5588AC5588AC5588AC5588AC5588AC5588AC5588AC5588AC5588
      AC5588AC5588AC5588AC5588AC5588AC5588AC55FF00FFFF00FF}
    Caption = 'Acceso a controles'
    TabOrder = 7
    ScreenMask.Enabled = True
    ScreenMask.WaitData = True
    ScreenMask.Message = 'Aguarde un momento...'
    ScreenMask.Target = Owner
    OnClick = btnAccesoControlesClick
  end
  object UniImageControlesPermitidos: TUniImage
    Left = 221
    Top = 6
    Width = 16
    Height = 16
    Hint = ''
    Visible = False
    AutoSize = True
    Picture.Data = {
      07544269746D617036030000424D360300000000000036000000280000001000
      000010000000010018000000000000030000C30E0000C30E0000000000000000
      0000FF00FFFF00FFFF00FFFF00FFFF00FF8F8F8F6767675757575858586D6D6D
      959595FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF8282825353
      53888888C1C1C1DBDBDBD9D9D9BCBCBC7D7D7D555555919191FF00FFFF00FFFF
      00FFFF00FFFF00FF686868696969EAEAEAFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFDEDEDE5F5F5F767676FF00FFFF00FFFF00FF7E7E7E6A6A6AFFFFFFFFFF
      FFCEE7F77AC0EB57B0E85AB1E882C3ECDEEFFAFFFFFFF9F9F95E5E5E949494FF
      00FFFF00FF545454EEEEEEFFFFFF9CCFF050ACE75CB2E85EB3E85EB3E85BB2E8
      4DABE6B8DEF5FFFFFFD7D7D7555555FF00FF8888888F8F8FFFFFFFCAE6F750AC
      E75FB4E95FB4E95FB4E95FB4E95FB4E95FB4E94DABE6E4F1FBFFFFFF7878789B
      9B9B5F5F5FCBCBCBFFFFFF73BCEB5CB2E85FB4E95FB4E95FB4E95FB4E95FB4E9
      5FB4E95AB2E88BC8EFFFFFFFB4B4B4727272575757E7E7E7FFFFFF50ACE75EB4
      E95FB4E95FB4E95FB4E95FB4E95FB4E95FB4E95DB3E865B7E9FFFFFFD0D0D05E
      5E5E575757E7E7E7FFFFFF50ACE75EB4E95FB4E95FB4E95FB4E95FB4E95FB4E9
      5FB4E95DB3E865B7E9FFFFFFD0D0D05E5E5E5F5F5FCBCBCBFFFFFF72BCEB5CB2
      E85FB4E95FB4E95FB4E95FB4E95FB4E95FB4E95AB2E88CC9EFFFFFFFB4B4B472
      72728787878F8F8FFFFFFFCCE7F750ACE75FB4E95FB4E95FB4E95FB4E95FB4E9
      5EB4E94EABE6E5F2FBFFFFFF7777779B9B9BFF00FF545454EEEEEEFFFFFFA0D2
      F14FACE75BB2E85EB3E85EB3E85BB2E84DABE6BCDFF5FFFFFFD7D7D7555555FF
      00FFFF00FF7E7E7E6A6A6AFFFFFFFFFFFFD1E9F87DC1EC5AB1E85CB2E885C6ED
      E2F0FAFFFFFFF9F9F95E5E5E949494FF00FFFF00FFFF00FF686868696969EAEA
      EAFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFDEDEDE5F5F5F767676FF00FFFF
      00FFFF00FFFF00FFFF00FF828282535353888888C1C1C1DADADAD9D9D9BCBCBC
      7D7D7D555555909090FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
      FF8E8E8E6767675757575858586D6D6D949494FF00FFFF00FFFF00FFFF00FFFF
      00FF}
    Transparent = True
  end
  object UniPanelBotonesVertical: TUniPanel
    Left = 0
    Top = 596
    Width = 565
    Height = 45
    Hint = ''
    Align = alBottom
    TabOrder = 8
    BorderStyle = ubsNone
    Caption = ''
    object UniPanelBotonesHorizontal: TUniPanel
      Left = 280
      Top = 0
      Width = 285
      Height = 45
      Hint = ''
      Align = alRight
      TabOrder = 0
      BorderStyle = ubsNone
      Caption = ''
      object btnAceptar: TUniBitBtn
        Left = 113
        Top = 1
        Width = 80
        Height = 30
        Hint = ''
        Glyph.Data = {
          36030000424D3603000000000000360000002800000010000000100000000100
          18000000000000030000C30E0000C30E00000000000000000000FF00FFFF00FF
          FF00FFFF00FFFF00FFB0C49597B56E8BAE5B8BAE5C98B670B1C597FF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFB0C49583A94E81A84B81A84B81
          A84B81A84B81A84B81A84B84A94FB3C599FF00FFFF00FFFF00FFFF00FFFF00FF
          A0BA7B81A84B81A84B81A84B81A84B81A84B81A84B81A84B81A84B81A84B81A8
          4BA3BC81FF00FFFF00FFFF00FFAFC39381A84B81A84B81A84B81A84BA6C180AE
          C68B81A84B81A84B81A84B81A84B81A84B81A84BB3C599FF00FFFF00FF83A94E
          81A84B81A84B81A84BA6C181FCFCFAFDFDFCACC58881A84B81A84B81A84B81A8
          4B81A84B84AA50FF00FFAEC39281A84B81A84B81A84BA8C281FCFDFAFFFFFFFF
          FFFFFDFDFCACC58981A84B81A84B81A84B81A84B81A84BB2C59895B46A81A84B
          81A84BA8C282FCFDFBFFFFFFEDF2E5EFF3E8FFFFFFFDFDFCADC58981A84B81A8
          4B81A84B81A84B99B67088AC5781A84B8BAE59F9FBF6FFFFFFEDF2E58FB15E90
          B260EEF3E8FFFFFFFDFDFCADC58A81A84B81A84B81A84B8CAE5D88AC5681A84B
          81A84BA6C181EAF0E18FB15F81A84B81A84B90B160EEF3E8FFFFFFFDFDFCAEC6
          8B81A84B81A84B8CAE5C94B36981A84B81A84B81A84B82A94D81A84B81A84B81
          A84B81A84B90B160EEF3E6FFFFFFFDFEFDADC58981A84B97B56EACC18F81A84B
          81A84B81A84B81A84B81A84B81A84B81A84B81A84B81A84B8FB160EEF3E6F6F9
          F39AB96E81A84BB0C394FF00FF82A84C81A84B81A84B81A84B81A84B81A84B81
          A84B81A84B81A84B81A84B8FB15F9BB96F81A84B83A94EFF00FFFF00FFABC18D
          81A84B81A84B81A84B81A84B81A84B81A84B81A84B81A84B81A84B81A84B81A8
          4B81A84BAFC393FF00FFFF00FFFF00FF9AB77381A84B81A84B81A84B81A84B81
          A84B81A84B81A84B81A84B81A84B81A84B9EB978FF00FFFF00FFFF00FFFF00FF
          FF00FFA9C08A81A84C81A84B81A84B81A84B81A84B81A84B81A84B82A84CACC1
          8EFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFAAC08B90B16385
          AA5185AA5291B164ABC18DFF00FFFF00FFFF00FFFF00FFFF00FF}
        Caption = 'Aceptar'
        TabOrder = 0
        ScreenMask.Enabled = True
        ScreenMask.Message = 'Aguarde un momento...'
        ScreenMask.Target = Owner
        OnClick = btnAceptarClick
      end
      object btnCancelar: TUniBitBtn
        Left = 195
        Top = 1
        Width = 80
        Height = 30
        Hint = ''
        Glyph.Data = {
          36030000424D3603000000000000360000002800000010000000100000000100
          18000000000000030000C30E0000C30E00000000000000000000FF00FFFF00FF
          FF00FFFF00FFFF00FF8996D65C6FD1465CCE465CCE5D70D18B97D6FF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF8895D6374FCC334CCC334CCC33
          4CCC334CCC334CCC334CCC3850CC8E9AD7FF00FFFF00FFFF00FFFF00FFFF00FF
          6B7CD2334CCC334CCC334CCC334CCC334CCC334CCC334CCC334CCC334CCC334C
          CC7181D3FF00FFFF00FFFF00FF8794D6334CCC334CCC334CCC334CCC334CCC33
          4CCC334CCC334CCC354ECC334CCC334CCC334CCC8E9AD7FF00FFFF00FF374FCC
          334CCC334CCC7586DCFFFFFF3D55CE334CCC334CCC3E56CEFFFFFF8594E0334C
          CC334CCC3951CCFF00FF8693D6334CCC334CCC344DCCFFFFFFFFFFFFFFFFFF3D
          55CE3E56CEFFFFFFFFFFFFFFFFFF364FCC334CCC334CCC8D99D6576BD0334CCC
          334CCC334CCC4159CFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF4058CF334C
          CC334CCC334CCC5E71D14158CD334CCC334CCC334CCC334CCC4159CFFFFFFFFF
          FFFFFFFFFFFFFFFF4058CF334CCC334CCC334CCC334CCC485ECE4057CD334CCC
          334CCC334CCC334CCC3E56CEFFFFFFFFFFFFFFFFFFFFFFFF3D55CE334CCC334C
          CC334CCC334CCC475DCE5569D0334CCC334CCC334CCC3E56CEFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFF3D55CE334CCC334CCC334CCC5B6FD0828FD5334CCC
          334CCC344DCCFFFFFFFFFFFFFFFFFF4158CF4158CFFFFFFFFFFFFFFFFFFF354D
          CC334CCC334CCC8895D6FF00FF354DCC334CCC334CCC7A8ADDFFFFFF4158CF33
          4CCC334CCC4158CFFFFFFF8291DF334CCC334CCC374FCCFF00FFFF00FF808ED5
          334CCC334CCC334CCC354DCC334CCC334CCC334CCC334CCC364ECC334CCC334C
          CC334CCC8693D6FF00FFFF00FFFF00FF6274D1334CCC334CCC334CCC334CCC33
          4CCC334CCC334CCC334CCC334CCC334CCC6879D2FF00FFFF00FFFF00FFFF00FF
          FF00FF7C8BD4344DCC334CCC334CCC334CCC334CCC334CCC334CCC354DCC818F
          D5FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF7D8BD44F64CF3A
          52CC3B53CC5165CF808ED5FF00FFFF00FFFF00FFFF00FFFF00FF}
        Caption = 'Cancelar'
        ParentFont = False
        TabOrder = 1
        ScreenMask.Enabled = True
        ScreenMask.Message = 'Aguarde un momento...'
        ScreenMask.Target = Owner
        OnClick = btnCancelarClick
      end
    end
  end
  object txtBusqueda: TUniEdit
    Left = 296
    Top = 3
    Width = 261
    Hint = ''
    Text = ''
    TabOrder = 9
    EmptyText = 'Buscar....'
    CheckChangeDelay = 500
    ClearButton = True
    OnChange = txtBusquedaChange
  end
  object cboModoPermiso: TUniComboBox
    Left = 371
    Top = 566
    Width = 145
    Hint = ''
    Style = csDropDownList
    Text = ''
    Items.Strings = (
      'A'#241'adir Permiso'
      'Sobrescribir Permiso')
    TabOrder = 10
    IconItems = <>
  end
  object mnuPopupTipoPermiso: TUniPopupMenu
    Left = 467
    Top = 75
    object mnuPopupTipoPermisoSoloLectura: TUniMenuItem
      Caption = 'S'#243'lo lectura'
      OnClick = mnuPopupTipoPermisoSoloLecturaClick
    end
    object mnuPopupTipoPermisoCompleto: TUniMenuItem
      Caption = 'Completo'
      OnClick = mnuPopupTipoPermisoCompletoClick
    end
  end
end
