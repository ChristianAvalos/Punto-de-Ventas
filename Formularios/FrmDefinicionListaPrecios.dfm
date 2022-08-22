inherited FrmDefinicionPrecio: TFrmDefinicionPrecio
  ClientHeight = 141
  ClientWidth = 809
  Caption = 'Definici'#243'n lista de precios'
  BorderStyle = bsNone
  Position = poDefault
  AlignmentControl = uniAlignmentClient
  ExplicitWidth = 809
  ExplicitHeight = 141
  TextHeight = 15
  inherited FmeBarraInformacionOrganizacionUsuario: TFmeBarraInformacionOrganizacionUsuario
    Width = 809
    ParentAlignmentControl = False
    AlignmentControl = uniAlignmentClient
    ExplicitWidth = 430
    inherited lblEtiquetaUsuario: TUniLabel
      Left = 265
      Top = 8
      TabOrder = 3
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
    Width = 809
    ParentAlignmentControl = False
    AlignmentControl = uniAlignmentClient
    ExplicitWidth = 430
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
    Top = 57
    Width = 809
    Height = 20
    ParentAlignmentControl = False
    AlignmentControl = uniAlignmentClient
    Align = alTop
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 2
    ParentRTL = False
    Background.Picture.Data = {00}
    ExplicitTop = 57
    ExplicitWidth = 430
    inherited txtUrev: TUniDBText
      Width = 36
      DataField = 'UrevCalc'
      DataSource = DMPrecios.DSPrecio
      ExplicitWidth = 36
    end
  end
  inherited UniStatusBar: TUniStatusBar [3]
    Top = 116
    Width = 809
    ExplicitTop = 194
    ExplicitWidth = 430
  end
  object UniPanel: TUniContainerPanel
    Left = 0
    Top = 77
    Width = 809
    Height = 40
    Hint = ''
    ParentColor = False
    Color = clWhite
    Align = alTop
    TabOrder = 4
    object txtCodigo: TUniDBEdit
      Tag = 1
      Left = 56
      Top = 5
      Width = 52
      Height = 22
      Hint = ''
      DataField = 'IdPrecio'
      DataSource = DMPrecios.DSPrecio
      TabOrder = 1
      Color = clMenu
      ReadOnly = True
    end
    object txtMoneda: TUniDBEdit
      Left = 167
      Top = 5
      Width = 201
      Height = 22
      Hint = ''
      DataField = 'Moneda'
      DataSource = DMPrecios.DSPrecio
      TabOrder = 2
    end
    object UniLabel1: TUniLabel
      Left = 10
      Top = 9
      Width = 38
      Height = 13
      Hint = ''
      Caption = 'C'#243'digo'
      TabOrder = 3
    end
    object UniLabel3: TUniLabel
      Left = 116
      Top = 9
      Width = 43
      Height = 13
      Hint = ''
      Caption = 'Moneda'
      TabOrder = 4
    end
    object txtDescripcion: TUniDBEdit
      Left = 444
      Top = 5
      Width = 323
      Height = 22
      Hint = ''
      DataField = 'Descripcion'
      DataSource = DMPrecios.DSPrecio
      TabOrder = 5
    end
    object UniLabel2: TUniLabel
      Left = 376
      Top = 9
      Width = 60
      Height = 13
      Hint = ''
      Caption = 'Descripci'#243'n'
      TabOrder = 6
    end
  end
  inherited uNativeImg: TUniNativeImageList
    Left = 713
    Top = 78
  end
end
