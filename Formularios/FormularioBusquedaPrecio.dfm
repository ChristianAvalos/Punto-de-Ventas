inherited FrmBusquedaPrecio: TFrmBusquedaPrecio
  Caption = 'B'#250'squeda - Lista de Precio'
  MonitoredKeys.Keys = <
    item
      KeyStart = 27
      KeyEnd = 27
    end>
  TextHeight = 15
  inherited GridResultado: TUniDBGrid
    DataSource = DMPrecios.DSBuscadorPrecio
    Columns = <
      item
        FieldName = 'IdPrecio'
        Title.Alignment = taCenter
        Title.Caption = 'C'#243'digo'
        Width = 56
        ReadOnly = True
      end
      item
        FieldName = 'Descripcion'
        Title.Alignment = taCenter
        Title.Caption = 'Descripci'#243'n'
        Width = 314
      end>
  end
  inherited cboParametros: TUniComboBox
    Items.Strings = (
      'C'#243'digo'
      'Descripci'#243'n')
  end
  inherited btnBuscar: TUniBitBtn
    ScreenMask.Target = Owner
  end
  inherited btnCerrar: TUniBitBtn
    ScreenMask.Target = Owner
  end
  inherited btnIraRegistro: TUniMenuButton
    ScreenMask.Target = Owner
  end
  inherited mnuBtnMenu: TUniPopupMenu
    ScreenMask.Target = Owner
  end
end
