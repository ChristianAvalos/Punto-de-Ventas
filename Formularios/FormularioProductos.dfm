inherited FrmProductos: TFrmProductos
  ClientHeight = 607
  ClientWidth = 822
  Caption = 'Productos'
  BorderStyle = bsNone
  AlignmentControl = uniAlignmentClient
  Layout = 'vbox'
  TextHeight = 15
  inherited FmeBarraInformacionOrganizacionUsuario: TFmeBarraInformacionOrganizacionUsuario
    Width = 822
    ParentAlignmentControl = False
    AlignmentControl = uniAlignmentClient
    ExplicitWidth = 822
    inherited lblUsuario: TUniDBText
      Width = 53
      ExplicitWidth = 53
    end
  end
  inherited FmeBarraNavegacionPrincipal: TFmeBarraNavegacionPrincipal
    Width = 822
    ParentAlignmentControl = False
    AlignmentControl = uniAlignmentClient
    ExplicitWidth = 822
    inherited UniDBNavigator: TUniDBNavigator
      ScreenMask.Target = Owner
    end
    inherited tbtnBuscar: TUniButton
      ScreenMask.Target = Owner
    end
    inherited UniImageList: TUniImageList
      Left = 610
      Top = 3
    end
  end
  inherited UniStatusBar: TUniStatusBar
    Top = 582
    Width = 822
    ExplicitTop = 582
    ExplicitWidth = 822
  end
  inherited uNativeImg: TUniNativeImageList
    Left = 549
    Top = 21
  end
end
