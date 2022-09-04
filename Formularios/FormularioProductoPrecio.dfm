inherited FrmProductoPrecio: TFrmProductoPrecio
  ClientHeight = 139
  ClientWidth = 183
  Caption = 'Agregar precio'
  ExplicitWidth = 199
  ExplicitHeight = 178
  TextHeight = 15
  inherited UniPanelBotonesVertical: TUniPanel
    Top = 94
    Width = 183
    TabOrder = 6
    ExplicitTop = 94
    ExplicitWidth = 183
    inherited UniPanelBotonesHorizontal: TUniPanel
      Left = -4
      TabOrder = 0
      ExplicitLeft = -4
      inherited btnAceptar: TUniBitBtn
        TabOrder = 0
        ScreenMask.Target = Owner
        OnClick = btnAceptarClick
      end
      inherited btnCancelar: TUniBitBtn
        TabOrder = 1
        ScreenMask.Target = Owner
        OnClick = btnCancelarClick
      end
    end
  end
  object cboPrecio: TUniDBLookupComboBox [1]
    Left = 51
    Top = 11
    Width = 124
    Height = 23
    Hint = ''
    ListField = 'Descripcion'
    ListSource = DMComunComercial.DSPrecio
    KeyField = 'IdPrecio'
    ListFieldIndex = 0
    DataField = 'IdPrecio'
    DataSource = DMProductos.DSProductoPrecios
    TabOrder = 0
    Color = clWindow
    ClientEvents.ExtEvents.Strings = (
      
        'render=function render(sender, eOpts)'#13#10'{'#13#10'    sender.editable=tr' +
        'ue;'#13#10'}')
  end
  object lblPrecio: TUniLabel [2]
    Left = 8
    Top = 15
    Width = 31
    Height = 13
    Hint = ''
    Caption = 'Precio'
    TabOrder = 1
  end
  object UniLabel2: TUniLabel [3]
    Left = 8
    Top = 68
    Width = 35
    Height = 13
    Hint = ''
    Caption = 'Monto'
    TabOrder = 5
  end
  object cboMoneda: TUniDBLookupComboBox [4]
    Left = 51
    Top = 37
    Width = 124
    Height = 23
    Hint = ''
    ListField = 'Descripcion'
    ListSource = DMComunGlobal.DSMoneda
    KeyField = 'IdMoneda'
    ListFieldIndex = 0
    DataField = 'IdMoneda'
    DataSource = DMProductos.DSProductoPrecios
    TabOrder = 2
    Color = clWindow
    ClientEvents.ExtEvents.Strings = (
      
        'render=function render(sender, eOpts)'#13#10'{'#13#10'    sender.editable=tr' +
        'ue;'#13#10'}')
  end
  object lblMoneda: TUniLabel [5]
    Left = 8
    Top = 42
    Width = 43
    Height = 13
    Hint = ''
    Caption = 'Moneda'
    TabOrder = 3
  end
  object txtMonto: TUniDBFormattedNumberEdit [6]
    Left = 51
    Top = 63
    Width = 124
    Height = 22
    Hint = ''
    BodyRTL = False
    InputRTL = False
    DataField = 'Monto'
    DataSource = DMProductos.DSProductoPrecios
    TabOrder = 4
    ClientEvents.ExtEvents.Strings = (
      
        'OnBeforerender=function OnBeforerender(sender)'#13#10'{'#13#10'  sender.mask' +
        'Re=/[+\-\,0-9]/'#13#10'}')
    DecimalSeparator = ','
    ThousandSeparator = '.'
  end
end
