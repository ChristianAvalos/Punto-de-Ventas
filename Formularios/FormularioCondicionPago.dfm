inherited FrmCondiciondePago: TFrmCondiciondePago
  ClientHeight = 146
  ClientWidth = 597
  Caption = 'Condici'#243'n de pago'
  Color = clWhite
  BorderStyle = bsNone
  Layout = 'vbox'
  ExplicitWidth = 597
  ExplicitHeight = 146
  TextHeight = 15
  inherited FmeBarraInformacionOrganizacionUsuario: TFmeBarraInformacionOrganizacionUsuario
    Width = 597
    ParentAlignmentControl = False
    AlignmentControl = uniAlignmentClient
    ExplicitWidth = 597
    inherited lblEtiquetaOrganizacion: TUniLabel
      TabOrder = 1
    end
    inherited lblEtiquetaUsuario: TUniLabel
      TabOrder = 3
    end
    inherited lblOrganizacion: TUniDBText
      DataSource = DMOrganizacion.DSOrganizacion
    end
    inherited lblUsuario: TUniDBText
      Width = 53
    end
  end
  inherited FmeBarraNavegacionPrincipal: TFmeBarraNavegacionPrincipal
    Width = 597
    ParentAlignmentControl = False
    AlignmentControl = uniAlignmentClient
    ExplicitWidth = 597
    inherited UniDBNavigator: TUniDBNavigator
      DataSource = DMCondiciondePago.DSCondicionPago
      ScreenMask.Target = Owner
    end
    inherited tbtnBuscar: TUniButton
      ScreenMask.Target = Owner
    end
  end
  inline FmeBarraUltimaRevision: TFmeBarraUltimaRevision [2]
    Left = 0
    Top = 60
    Width = 594
    Height = 20
    TabOrder = 9
    ParentRTL = False
    Background.Picture.Data = {00}
    ExplicitTop = 60
    ExplicitWidth = 594
    inherited txtUrev: TUniDBText
      DataField = 'UrevCalc'
      DataSource = DMCondiciondePago.DSCondicionPago
    end
  end
  object txtCodigo: TUniDBEdit [3]
    Left = 54
    Top = 84
    Width = 45
    Height = 22
    Hint = ''
    DataField = 'IdCondicionPago'
    DataSource = DMCondiciondePago.DSCondicionPago
    TabOrder = 2
    Color = clMenu
    ReadOnly = True
  end
  object txtDescripcion: TUniDBEdit [4]
    Left = 346
    Top = 86
    Width = 204
    Height = 22
    Hint = ''
    DataField = 'Descripcion'
    DataSource = DMCondiciondePago.DSCondicionPago
    TabOrder = 4
  end
  object txtTipoPago: TUniDBEdit [5]
    Left = 138
    Top = 86
    Width = 132
    Height = 22
    Hint = ''
    DataField = 'TipoPago'
    DataSource = DMCondiciondePago.DSCondicionPago
    TabOrder = 3
  end
  object lblCodigo: TUniLabel [6]
    Left = 8
    Top = 90
    Width = 38
    Height = 13
    Hint = ''
    Caption = 'C'#243'digo'
    TabOrder = 5
  end
  object lblTipo: TUniLabel [7]
    Left = 107
    Top = 90
    Width = 23
    Height = 13
    Hint = ''
    Caption = 'Tipo'
    TabOrder = 6
  end
  object lblDescripcion: TUniLabel [8]
    Left = 278
    Top = 90
    Width = 60
    Height = 13
    Hint = ''
    Caption = 'Descripci'#243'n'
    TabOrder = 7
  end
  inherited UniStatusBar: TUniStatusBar [9]
    Top = 121
    Width = 597
    ExplicitTop = 121
    ExplicitWidth = 597
  end
  inherited uNativeImg: TUniNativeImageList
    Left = 520
    Top = 17
  end
end
