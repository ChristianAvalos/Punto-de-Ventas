inherited FrmDefinicionPrecio: TFrmDefinicionPrecio
  ClientHeight = 219
  ClientWidth = 430
  Caption = 'Definici'#243'n lista de precios'
  BorderStyle = bsNone
  Layout = 'vbox'
  ExplicitWidth = 430
  ExplicitHeight = 219
  TextHeight = 15
  inherited FmeBarraInformacionOrganizacionUsuario: TFmeBarraInformacionOrganizacionUsuario
    Width = 430
    ExplicitWidth = 506
    inherited lblEtiquetaUsuario: TUniLabel
      Left = 265
      Top = 8
      ExplicitLeft = 265
      ExplicitTop = 8
    end
    inherited lblOrganizacion: TUniDBText
      Width = 183
      ExplicitWidth = 183
    end
    inherited lblUsuario: TUniDBText
      Left = 311
      Top = 7
      Width = 53
      ExplicitLeft = 311
      ExplicitTop = 7
      ExplicitWidth = 53
    end
  end
  inherited FmeBarraNavegacionPrincipal: TFmeBarraNavegacionPrincipal
    Width = 430
    inherited UniDBNavigator: TUniDBNavigator
      DataSource = DMPrecios.DSPrecio
      ScreenMask.Target = Owner
    end
    inherited tbtnBuscar: TUniButton
      ScreenMask.Target = Owner
    end
  end
  inline FmeBarraUltimaRevision: TFmeBarraUltimaRevision [2]
    Left = 0
    Top = 56
    Width = 419
    Height = 20
    TabOrder = 9
    ParentRTL = False
    Background.Picture.Data = {00}
    ExplicitTop = 56
    ExplicitWidth = 419
    inherited txtUrev: TUniDBText
      DataField = 'UrevCalc'
      DataSource = DMPrecios.DSPrecio
    end
  end
  object txtMoneda: TUniDBEdit [3]
    Left = 202
    Top = 87
    Width = 201
    Height = 22
    Hint = ''
    DataField = 'Moneda'
    DataSource = DMPrecios.DSPrecio
    TabOrder = 8
  end
  object txtCodigo: TUniDBEdit [4]
    Tag = 1
    Left = 60
    Top = 87
    Width = 52
    Height = 22
    Hint = ''
    DataField = 'IdPrecio'
    DataSource = DMPrecios.DSPrecio
    TabOrder = 4
    Color = clMenu
    ReadOnly = True
  end
  object UniLabel3: TUniLabel [5]
    Left = 155
    Top = 92
    Width = 43
    Height = 13
    Hint = ''
    Caption = 'Moneda'
    TabOrder = 5
  end
  object UniLabel1: TUniLabel [6]
    Left = 12
    Top = 92
    Width = 38
    Height = 13
    Hint = ''
    Caption = 'C'#243'digo'
    TabOrder = 3
  end
  object txtDescripcion: TUniDBEdit [7]
    Left = 79
    Top = 115
    Width = 323
    Height = 22
    Hint = ''
    DataField = 'Descripcion'
    DataSource = DMPrecios.DSPrecio
    TabOrder = 6
  end
  object UniLabel2: TUniLabel [8]
    Left = 13
    Top = 121
    Width = 60
    Height = 13
    Hint = ''
    Caption = 'Descripci'#243'n'
    TabOrder = 7
  end
  inherited UniStatusBar: TUniStatusBar [9]
    Top = 194
    Width = 430
  end
  inherited uNativeImg: TUniNativeImageList
    Left = 713
    Top = 78
  end
end
