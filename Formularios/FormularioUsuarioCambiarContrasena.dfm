object FrmUsuarioCambiarContrasena: TFrmUsuarioCambiarContrasena
  Left = 0
  Top = 0
  ClientHeight = 193
  ClientWidth = 233
  Caption = 'Cambiar contrase'#241'a'
  BorderStyle = bsDialog
  OldCreateOrder = False
  MonitoredKeys.Keys = <>
  PixelsPerInch = 96
  TextHeight = 15
  object txtPassword: TUniEdit
    Left = 78
    Top = 39
    Width = 140
    Hint = ''
    PasswordChar = '*'
    Text = ''
    TabOrder = 0
    EmptyText = 'Nueva Contrase'#241'a'
    OnChange = txtPasswordChange
  end
  object txtPasswordRepetir: TUniEdit
    Left = 78
    Top = 68
    Width = 140
    Hint = ''
    PasswordChar = '*'
    Text = ''
    TabOrder = 2
    EmptyText = 'Confirmar Contrase'#241'a'
  end
  object lblContrasena: TUniLabel
    Left = 12
    Top = 44
    Width = 59
    Height = 13
    Hint = ''
    Caption = 'Contrase'#241'a'
    TabOrder = 1
  end
  object lblConfirmar: TUniLabel
    Left = 13
    Top = 74
    Width = 51
    Height = 13
    Hint = ''
    Caption = 'Confirmar'
    TabOrder = 3
  end
  object lnkGenerarContrasenaAleatoria: TUniLabel
    Left = 13
    Top = 11
    Width = 149
    Height = 13
    Cursor = crHandPoint
    Hint = ''
    Caption = 'Generar contrase'#241'a aleatoria'
    ParentFont = False
    Font.Color = clBlue
    TabOrder = 4
    ScreenMask.Enabled = True
    ScreenMask.Message = 'Aguarde un momento'
    ScreenMask.Target = Owner
    OnClick = lnkGenerarContrasenaAleatoriaClick
  end
  object btnAceptar: TUniBitBtn
    Left = 28
    Top = 155
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
    TabOrder = 5
    ScreenMask.Enabled = True
    ScreenMask.Message = 'Aguarde un momento...'
    ScreenMask.Target = Owner
    OnClick = btnAceptarClick
  end
  object btnCancelar: TUniBitBtn
    Left = 114
    Top = 154
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
    TabOrder = 6
    ScreenMask.Enabled = True
    ScreenMask.Message = 'Aguarde un momento...'
    ScreenMask.Target = Owner
    OnClick = btnCancelarClick
  end
  object lblFortalezaContrasena: TUniLabel
    Left = 13
    Top = 98
    Width = 205
    Height = 13
    Hint = ''
    Alignment = taCenter
    AutoSize = False
    Caption = ''
    ParentFont = False
    Font.Style = [fsBold]
    TabOrder = 7
  end
  object lblAlertaContrasenha: TUniLabel
    Left = 13
    Top = 98
    Width = 205
    Height = 13
    Hint = ''
    Alignment = taCenter
    AutoSize = False
    Caption = ''
    ParentFont = False
    Font.Color = clRed
    TabOrder = 8
  end
  object chkNotificar: TUniCheckBox
    Left = 48
    Top = 127
    Width = 137
    Height = 17
    Hint = ''
    Caption = 'Notificar por email'
    TabOrder = 9
  end
end
