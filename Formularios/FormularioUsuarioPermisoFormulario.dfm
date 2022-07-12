inherited FrmUsuarioPermisoFormulario: TFrmUsuarioPermisoFormulario
  ClientHeight = 491
  ClientWidth = 452
  Caption = 'Permisos sobre controles'
  OnShow = UniFormShow
  OnClose = UniFormClose
  ExplicitWidth = 468
  ExplicitHeight = 530
  TextHeight = 15
  inherited UniPanelBotonesVertical: TUniPanel
    Top = 444
    Width = 452
    ExplicitTop = 444
    ExplicitWidth = 452
    inherited UniPanelBotonesHorizontal: TUniPanel
      Left = 267
      ExplicitLeft = 267
      inherited btnCerrar: TUniBitBtn
        ScreenMask.Target = Owner
      end
    end
  end
  object UniDBGridControl: TUniDBGrid [1]
    Left = 10
    Top = 29
    Width = 432
    Height = 405
    Hint = ''
    ClientEvents.UniEvents.Strings = (
      
        'pagingBar.beforeInit=function pagingBar.beforeInit(sender, confi' +
        'g)'#13#10'{'#13#10'    sender.displayMsg = '#39'Items(s) {2}'#39';// defaultvalue = ' +
        #39'Displaying {0} - {1} of {2}'#13#10'  sender.displayInfo = true;'#13#10'}')
    DataSource = DMComunUsuario.DSControl
    WebOptions.Paged = False
    LoadMask.WaitData = True
    LoadMask.Message = 'Aguarde un momento...'
    LoadMask.Target = Owner
    ForceFit = True
    TabOrder = 1
    Columns = <
      item
        FieldName = 'ObjetoComponente'
        Title.Alignment = taCenter
        Title.Caption = 'Objeto'
        Width = 359
        ReadOnly = True
      end
      item
        FieldName = 'Permitido'
        Title.Alignment = taCenter
        Title.Caption = 'Permitido'
        Width = 55
        Alignment = taCenter
      end>
  end
  object lnkSeleccionarTodos: TUniLabel [2]
    Left = 10
    Top = 9
    Width = 91
    Height = 13
    Cursor = crHandPoint
    Hint = ''
    Caption = 'Seleccionar todos'
    ParentFont = False
    Font.Color = clBlue
    TabOrder = 2
    ScreenMask.Enabled = True
    ScreenMask.WaitData = True
    ScreenMask.Message = 'Aguarde un momento...'
    ScreenMask.Target = Owner
    OnClick = lnkSeleccionarTodosClick
  end
  object lnkDesmarcarTodos: TUniLabel [3]
    Left = 120
    Top = 9
    Width = 86
    Height = 13
    Cursor = crHandPoint
    Hint = ''
    Caption = 'Desmarcar todos'
    ParentFont = False
    Font.Color = clBlue
    TabOrder = 3
    ScreenMask.Enabled = True
    ScreenMask.WaitData = True
    ScreenMask.Message = 'Aguarde un momento...'
    ScreenMask.Target = Owner
    OnClick = lnkDesmarcarTodosClick
  end
end
