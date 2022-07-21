inherited FrmBusquedaCondicionPago: TFrmBusquedaCondicionPago
  Caption = 'B'#250'squeda - Condici'#243'n de Pago'
  TextHeight = 15
  inherited GridResultado: TUniDBGrid
    Top = 45
    DataSource = DMCondiciondePago.DSBuscadorCondicionPago
    ForceFit = False
    Columns = <
      item
        FieldName = 'IdCondicionPago'
        Title.Alignment = taCenter
        Title.Caption = 'C'#243'digo'
        Width = 79
        ReadOnly = True
      end
      item
        FieldName = 'TipoPago'
        Title.Alignment = taCenter
        Title.Caption = 'Tipo de pago'
        Width = 201
      end
      item
        FieldName = 'Descripcion'
        Title.Alignment = taCenter
        Title.Caption = 'Descripci'#243'n'
        Width = 313
      end>
  end
  inherited cboParametros: TUniComboBox
    Text = 'C'#243'digo'
    Items.Strings = (
      'C'#243'digo'
      'Descripci'#243'n'
      'Tipo')
    ItemIndex = 0
  end
  inherited btnBuscar: TUniBitBtn
    ScreenMask.Target = Owner
  end
  inherited btnCerrar: TUniBitBtn
    Top = 366
    ScreenMask.Target = Owner
    ExplicitTop = 366
  end
  inherited btnIraRegistro: TUniMenuButton
    ScreenMask.Target = Owner
  end
  inherited mnuBtnMenu: TUniPopupMenu
    ScreenMask.Target = Owner
  end
end
