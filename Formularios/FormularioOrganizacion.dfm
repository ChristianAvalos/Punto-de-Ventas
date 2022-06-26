object FrmOrganizacion: TFrmOrganizacion
  Left = 0
  Top = 0
  ClientHeight = 319
  ClientWidth = 624
  Caption = 'Configuraci'#243'n de Organizaci'#243'n'
  OnShow = UniFormShow
  BorderStyle = bsDialog
  OldCreateOrder = False
  BorderIcons = [biSystemMenu]
  MonitoredKeys.Keys = <>
  OnCreate = UniFormCreate
  TextHeight = 15
  inline FmeTitulo: TFmeTitulo
    Left = 0
    Top = 0
    Width = 624
    Height = 50
    Color = clGradientInactiveCaption
    Align = alTop
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 0
    ParentColor = False
    ParentBackground = False
    ParentRTL = False
    Background.Picture.Data = {00}
    ExplicitWidth = 624
    inherited lblTituloPrincipal: TUniLabel
      Width = 231
      Caption = 'Configuraci'#243'n de la Organizaci'#243'n'
      ExplicitWidth = 231
    end
    inherited ImagenTitular: TUniImage
      Picture.Data = {
        0954506E67496D61676589504E470D0A1A0A0000000D49484452000000200000
        00200806000000737A7AF4000000097048597300000EC400000EC401952B0E1B
        0000009B4944415478DAEDD7CF0A40401007E059E4B5942B2F24677921AECA6B
        F937A65C58561B536B35BF929AB5E6ABD9CB2A44043D49D1C4F48A812F033D63
        5FE7A766CA00409BBFDA861A2BD39A006E01B451AF431828E8AAEC504FCB16E6
        052FBF17C02B0057FC05381F8100B8E22FC0F90804C0157F01CE472000AE0880
        15A0CF79B747003F00701F3E1BC8E700116CD7F2E0618FE1666D21C0A417575C
        BB7FD001FD086C0000000049454E44AE426082}
    end
  end
  object btnEliminarFoto: TUniButton
    Left = 425
    Top = 282
    Width = 85
    Height = 26
    Hint = ''
    Caption = 'Eliminar logo'
    TabOrder = 1
    OnClick = btnEliminarFotoClick
  end
  object btnSubirFoto: TUniButton
    Left = 512
    Top = 282
    Width = 88
    Height = 26
    Hint = ''
    Caption = 'Subir logo(.jpg)'
    TabOrder = 2
    OnClick = btnSubirFotoClick
  end
  object cboPais: TUniDBLookupComboBox
    Left = 271
    Top = 166
    Width = 145
    Height = 26
    Hint = ''
    ListField = 'Nombre'
    ListSource = DMOrganizacion.DSPais
    KeyField = 'IdPais'
    ListFieldIndex = 0
    DataField = 'IdPais'
    DataSource = DMOrganizacion.DSOrganizacion
    TabOrder = 3
    Color = clWindow
  end
  object lblCiudad: TUniLabel
    Left = 8
    Top = 172
    Width = 37
    Height = 13
    Hint = ''
    Caption = 'Ciudad'
    TabOrder = 4
  end
  object lblDireccion: TUniLabel
    Left = 8
    Top = 119
    Width = 48
    Height = 13
    Hint = ''
    Caption = 'Direcci'#243'n'
    TabOrder = 5
  end
  object lblEmail: TUniLabel
    Left = 8
    Top = 259
    Width = 27
    Height = 13
    Hint = ''
    Caption = 'Email'
    TabOrder = 6
  end
  object lblFax: TUniLabel
    Left = 32
    Top = 229
    Width = 28
    Height = 13
    Hint = ''
    Caption = 'Fax(s)'
    TabOrder = 7
  end
  object lblPais: TUniLabel
    Left = 243
    Top = 172
    Width = 20
    Height = 13
    Hint = ''
    Caption = 'Pa'#237's'
    TabOrder = 8
  end
  object lblRazonSocial: TUniLabel
    Left = 8
    Top = 92
    Width = 65
    Height = 13
    Hint = ''
    Caption = 'Raz'#243'n Social'
    TabOrder = 9
  end
  object lblSitioWeb: TUniLabel
    Left = 8
    Top = 288
    Width = 50
    Height = 13
    Hint = ''
    Caption = 'Sitio Web'
    TabOrder = 10
  end
  object lblTelefono: TUniLabel
    Left = 8
    Top = 200
    Width = 56
    Height = 13
    Hint = ''
    Caption = 'Tel'#233'fono(s)'
    TabOrder = 11
  end
  object PanelFoto: TUniPanel
    Left = 425
    Top = 105
    Width = 174
    Height = 173
    Hint = ''
    TabOrder = 12
    BorderStyle = ubsSolid
    Caption = ''
    Color = clWhite
    object BlobFoto: TUniDBImage
      Left = -3
      Top = -16
      Width = 172
      Height = 186
      Hint = ''
      DataField = 'LogoBMP'
      DataSource = DMOrganizacion.DSOrganizacionLogo
      Center = False
      Stretch = True
    end
  end
  object txtCiudad: TUniDBEdit
    Left = 45
    Top = 168
    Width = 186
    Height = 22
    Hint = ''
    DataField = 'Ciudad'
    DataSource = DMOrganizacion.DSOrganizacion
    TabOrder = 13
  end
  object txtDireccion: TUniDBMemo
    Left = 61
    Top = 118
    Width = 358
    Height = 44
    Hint = ''
    DataField = 'Direccion'
    DataSource = DMOrganizacion.DSOrganizacion
    TabOrder = 14
  end
  object txtEmail: TUniDBEdit
    Left = 44
    Top = 255
    Width = 376
    Height = 22
    Hint = ''
    DataField = 'Email'
    DataSource = DMOrganizacion.DSOrganizacion
    TabOrder = 15
  end
  object txtFax1: TUniDBEdit
    Left = 68
    Top = 225
    Width = 140
    Height = 22
    Hint = ''
    DataField = 'Fax1'
    DataSource = DMOrganizacion.DSOrganizacion
    TabOrder = 16
  end
  object txtFax2: TUniDBEdit
    Left = 214
    Top = 224
    Width = 145
    Height = 22
    Hint = ''
    DataField = 'Fax2'
    DataSource = DMOrganizacion.DSOrganizacion
    TabOrder = 17
  end
  object txtRazonSocial: TUniDBEdit
    Left = 73
    Top = 90
    Width = 242
    Height = 22
    Hint = ''
    DataField = 'RazonSocial'
    DataSource = DMOrganizacion.DSOrganizacion
    TabOrder = 18
  end
  object txtSitioWeb: TUniDBEdit
    Left = 59
    Top = 284
    Width = 355
    Height = 22
    Hint = ''
    DataField = 'Website'
    DataSource = DMOrganizacion.DSOrganizacion
    TabOrder = 19
  end
  object txtTelefono1: TUniDBEdit
    Left = 68
    Top = 196
    Width = 140
    Height = 22
    Hint = ''
    DataField = 'Telefono1'
    DataSource = DMOrganizacion.DSOrganizacion
    TabOrder = 20
  end
  object txtTelefono2: TUniDBEdit
    Left = 213
    Top = 196
    Width = 145
    Height = 22
    Hint = ''
    DataField = 'Telefono2'
    DataSource = DMOrganizacion.DSOrganizacion
    TabOrder = 21
  end
  object UniDBNavigator: TUniDBNavigator
    Left = 456
    Top = 80
    Width = 104
    Height = 25
    Hint = ''
    DataSource = DMOrganizacion.DSOrganizacion
    VisibleButtons = [nbEdit, nbPost, nbCancel, nbRefresh]
    TabOrder = 22
  end
  object lblRuc: TUniLabel
    Left = 321
    Top = 92
    Width = 22
    Height = 13
    Hint = ''
    Caption = 'RUC'
    TabOrder = 23
  end
  object txtRuc: TUniDBEdit
    Left = 349
    Top = 89
    Width = 68
    Height = 22
    Hint = ''
    DataField = 'RUC'
    DataSource = DMOrganizacion.DSOrganizacion
    TabOrder = 24
  end
  inline FmeBarraInformacionOrganizacionUsuario: TFmeBarraInformacionOrganizacionUsuario
    Left = 0
    Top = 50
    Width = 624
    Height = 23
    Color = clWhite
    Align = alTop
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 25
    ParentColor = False
    ParentBackground = False
    ParentRTL = False
    Background.Picture.Data = {00}
    ExplicitTop = 50
    ExplicitWidth = 624
    inherited lblOrganizacion: TUniDBText
      Width = 300
      DataSource = DMOrganizacion.DSOrganizacion
      AutoSize = False
      ExplicitWidth = 300
    end
    inherited lblUsuario: TUniDBText
      Width = 53
      ExplicitWidth = 53
    end
  end
  object UniFileUpload: TUniFileUpload
    Filter = '*.jpg'
    Title = 'Cargar logotipo'
    Messages.Uploading = 'Cargando...'
    Messages.PleaseWait = 'Por favor aguarde'
    Messages.Cancel = 'Cancelar'
    Messages.Processing = 'Procesando...'
    Messages.UploadError = 'Error al cargar'
    Messages.Upload = 'Cargar'
    Messages.NoFileError = 'Seleccione un archivo'
    Messages.BrowseText = 'Abrir...'
    Messages.UploadTimeout = 'Timeout occurred...'
    Messages.MaxSizeError = 'File is bigger than maximum allowed size'
    Messages.MaxFilesError = 'You can upload maximum %d files.'
    OnCompleted = UniFileUploadCompleted
    Left = 381
    Top = 193
  end
end
