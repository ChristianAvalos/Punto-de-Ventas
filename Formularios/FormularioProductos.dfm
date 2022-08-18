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
    inherited lblUsuario: TUniDBText
      Width = 53
      ExplicitWidth = 53
    end
  end
  inherited FmeBarraNavegacionPrincipal: TFmeBarraNavegacionPrincipal
    Width = 822
    ParentAlignmentControl = False
    AlignmentControl = uniAlignmentClient
    inherited UniDBNavigator: TUniDBNavigator
      ScreenMask.Target = Owner
    end
    inherited tbtnBuscar: TUniButton
      ScreenMask.Target = Owner
    end
  end
  inherited UniStatusBar: TUniStatusBar
    Top = 582
    Width = 822
  end
end
