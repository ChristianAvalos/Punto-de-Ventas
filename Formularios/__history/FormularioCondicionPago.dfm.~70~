inherited FrmCondiciondePago: TFrmCondiciondePago
  ClientHeight = 139
  ClientWidth = 552
  Caption = 'Condici'#243'n de pago'
  Color = clWhite
  BorderStyle = bsNone
  Position = poDefault
  AlignmentControl = uniAlignmentClient
  ExplicitWidth = 552
  ExplicitHeight = 139
  TextHeight = 15
  inherited FmeBarraInformacionOrganizacionUsuario: TFmeBarraInformacionOrganizacionUsuario
    Width = 552
    ParentAlignmentControl = False
    AlignmentControl = uniAlignmentClient
    inherited lblEtiquetaOrganizacion: TUniLabel
      Left = 2
      Top = 11
      TabOrder = 1
      ExplicitLeft = 2
      ExplicitTop = 11
    end
    inherited lblEtiquetaUsuario: TUniLabel
      TabOrder = 3
    end
    inherited lblOrganizacion: TUniDBText
      DataSource = DMOrganizacion.DSOrganizacion
    end
    inherited lblUsuario: TUniDBText
      Width = 53
      ExplicitWidth = 53
    end
  end
  inherited FmeBarraNavegacionPrincipal: TFmeBarraNavegacionPrincipal
    Width = 552
    ParentAlignmentControl = False
    AlignmentControl = uniAlignmentClient
    inherited UniDBNavigator: TUniDBNavigator
      DataSource = DMCondiciondePago.DSCondicionPago
      ScreenMask.Target = Owner
    end
    inherited tbtnBuscar: TUniButton
      ScreenMask.Target = Owner
    end
    inherited UniImageList: TUniImageList
      Left = 480
      Top = 4
    end
  end
  object Panel: TUniPanel [2]
    Left = 0
    Top = 57
    Width = 552
    Height = 55
    Hint = ''
    Align = alTop
    TabOrder = 3
    BorderStyle = ubsNone
    ShowCaption = False
    Caption = 'Panel'
    Color = clWhite
    ParentAlignmentControl = False
    Layout = 'vbox'
    LayoutAttribs.Align = 'middle'
    LayoutConfig.Flex = 100
    LayoutConfig.Width = '100%'
    object lblCodigo: TUniLabel
      Left = -1
      Top = 25
      Width = 38
      Height = 13
      Hint = ''
      Caption = 'C'#243'digo'
      TabOrder = 1
    end
    object txtCodigo: TUniDBEdit
      Left = 45
      Top = 22
      Width = 45
      Height = 22
      Hint = ''
      DataField = 'IdCondicionPago'
      DataSource = DMCondiciondePago.DSCondicionPago
      TabOrder = 2
      Color = clMenu
      ReadOnly = True
    end
    object lblTipo: TUniLabel
      Left = 98
      Top = 26
      Width = 23
      Height = 13
      Hint = ''
      Caption = 'Tipo'
      TabOrder = 3
    end
    object txtTipoPago: TUniDBEdit
      Left = 123
      Top = 22
      Width = 132
      Height = 22
      Hint = ''
      DataField = 'TipoPago'
      DataSource = DMCondiciondePago.DSCondicionPago
      TabOrder = 4
    end
    object lblDescripcion: TUniLabel
      Left = 269
      Top = 26
      Width = 60
      Height = 13
      Hint = ''
      Caption = 'Descripci'#243'n'
      TabOrder = 5
    end
    object txtDescripcion: TUniDBEdit
      Left = 333
      Top = 22
      Width = 204
      Height = 22
      Hint = ''
      DataField = 'Descripcion'
      DataSource = DMCondiciondePago.DSCondicionPago
      TabOrder = 6
    end
    inline FmeBarraUltimaRevision: TFmeBarraUltimaRevision
      Left = 0
      Top = 0
      Width = 552
      Height = 20
      ParentAlignmentControl = False
      AlignmentControl = uniAlignmentClient
      Align = alTop
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 7
      ParentRTL = False
      Background.Picture.Data = {00}
      ExplicitWidth = 806
      inherited txtUrev: TUniDBText
        Width = 36
        DataField = 'UrevCalc'
        DataSource = DMCondiciondePago.DSCondicionPago
        ExplicitWidth = 36
      end
    end
  end
  inherited UniStatusBar: TUniStatusBar
    Top = 114
    Width = 552
  end
  inherited uNativeImg: TUniNativeImageList
    Left = 386
    Top = 25
  end
end
