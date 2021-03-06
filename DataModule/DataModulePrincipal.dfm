object DMPrincipal: TDMPrincipal
  Height = 707
  Width = 814
  object MSConnection: TMSConnection
    Database = 'PuntoVenta'
    IsolationLevel = ilReadUnCommitted
    ConnectionTimeout = 30
    Options.Provider = prNativeClient
    Username = 'sa'
    Server = 'localhost'
    Connected = True
    BeforeConnect = MSConnectionBeforeConnect
    LoginPrompt = False
    Left = 66
    Top = 31
    EncryptedPassword = 'DCFF8FFF9EFF8CFF8CFF88FF90FF8DFF9BFFDCFF'
  end
  object MSQuerySQL: TMSQuery
    Connection = MSConnection
    Left = 79
    Top = 88
  end
  object DSQuery: TDataSource
    DataSet = MSQuerySQL
    Left = 80
    Top = 144
  end
  object MSVerificarUsuario: TMSQuery
    SQLInsert.Strings = (
      'INSERT INTO Usuario.Usuario'
      
        '  (IdOrganizacion, NombreUsuario, Contrasena, Email, Activo, Nom' +
        'bresApellidos, Foto, DocumentoNro, Observacion, UrevUsuario, Ure' +
        'vFechaHora)'
      'VALUES'
      
        '  (:IdOrganizacion, :NombreUsuario, :Contrasena, :Email, :Activo' +
        ', :NombresApellidos, :Foto, :DocumentoNro, :Observacion, :UrevUs' +
        'uario, :UrevFechaHora)'
      'SET :IdUsuario = SCOPE_IDENTITY()')
    SQLDelete.Strings = (
      'DELETE FROM Usuario.Usuario'
      'WHERE'
      '  IdUsuario = :Old_IdUsuario')
    SQLUpdate.Strings = (
      'UPDATE Usuario.Usuario'
      'SET'
      
        '  IdOrganizacion = :IdOrganizacion, NombreUsuario = :NombreUsuar' +
        'io, Contrasena = :Contrasena, Email = :Email, Activo = :Activo, ' +
        'NombresApellidos = :NombresApellidos, Foto = :Foto, DocumentoNro' +
        ' = :DocumentoNro, Observacion = :Observacion, UrevUsuario = :Ure' +
        'vUsuario, UrevFechaHora = :UrevFechaHora'
      'WHERE'
      '  IdUsuario = :Old_IdUsuario')
    SQLRefresh.Strings = (
      
        'SELECT IdOrganizacion, NombreUsuario, Contrasena, Email, Activo,' +
        ' NombresApellidos, Foto, DocumentoNro, Observacion, UrevUsuario,' +
        ' UrevFechaHora FROM Usuario.Usuario'
      'WHERE'
      '  IdUsuario = :IdUsuario')
    SQLLock.Strings = (
      'SELECT * FROM Usuario.Usuario'
      'WITH (UPDLOCK, ROWLOCK, HOLDLOCK)'
      'WHERE'
      '  IdUsuario = :Old_IdUsuario')
    SQLRecCount.Strings = (
      'SET :PCOUNT = (SELECT COUNT(*) FROM Usuario.Usuario'
      ')')
    Connection = MSConnection
    SQL.Strings = (
      'SELECT      *'
      '  FROM       Usuario.Usuario u'
      
        'WHERE   NombreUsuario = ISNULL(:NombreUsuario, u.NombreUsuario) ' +
        'AND'
      '  ISNULL(Email, '#39#39') = ISNULL(:Email, ISNULL(u.Email, '#39#39')) AND'
      '  u.Activo = 1')
    Left = 232
    Top = 33
    ParamData = <
      item
        DataType = ftString
        Name = 'NombreUsuario'
        Size = 5
        Value = Null
      end
      item
        DataType = ftUnknown
        Name = 'Email'
        Value = Null
      end>
    object MSVerificarUsuarioIdUsuario: TIntegerField
      FieldName = 'IdUsuario'
      ReadOnly = True
    end
    object MSVerificarUsuarioIdOrganizacion: TIntegerField
      FieldName = 'IdOrganizacion'
    end
    object MSVerificarUsuarioNombreUsuario: TStringField
      FieldName = 'NombreUsuario'
    end
    object MSVerificarUsuarioContrasena: TStringField
      FieldName = 'Contrasena'
      Size = 200
    end
    object MSVerificarUsuarioEmail: TStringField
      FieldName = 'Email'
      Size = 100
    end
    object MSVerificarUsuarioActivo: TBooleanField
      FieldName = 'Activo'
    end
    object MSVerificarUsuarioNombresApellidos: TStringField
      FieldName = 'NombresApellidos'
      Size = 50
    end
    object MSVerificarUsuarioFoto: TBlobField
      FieldName = 'Foto'
    end
    object MSVerificarUsuarioDocumentoNro: TStringField
      FieldName = 'DocumentoNro'
      Size = 30
    end
    object MSVerificarUsuarioObservacion: TStringField
      FieldName = 'Observacion'
      Size = 500
    end
    object MSVerificarUsuarioUrevUsuario: TStringField
      FieldName = 'UrevUsuario'
      Size = 50
    end
    object MSVerificarUsuarioUrevFechaHora: TDateTimeField
      FieldName = 'UrevFechaHora'
    end
    object MSVerificarUsuarioUrevCalc: TWideStringField
      FieldName = 'UrevCalc'
      ReadOnly = True
      Size = 4000
    end
    object MSVerificarUsuarioTemplate: TBlobField
      FieldName = 'Template'
    end
    object MSVerificarUsuarioOcultarMenuSinAcceso: TBooleanField
      FieldName = 'OcultarMenuSinAcceso'
    end
  end
  object DSVerificarUsuario: TDataSource
    DataSet = MSVerificarUsuario
    Left = 234
    Top = 95
  end
  object frxUsuario: TfrxDBDataset
    UserName = 'frxUsuario'
    CloseDataSource = False
    FieldAliases.Strings = (
      'IdUsuario=IdUsuario'
      'NombreUsuario=NombreUsuario'
      'Contrasena=Contrasena'
      'NombresApellidos=NombresApellidos'
      'Email=Email'
      'ModoInicioPatrimonio=ModoInicioPatrimonio'
      'IdPersonal=IdPersonal'
      'IdMedico=IdMedico'
      'IdPersona=IdPersona'
      'Foto=Foto'
      'OcultarMenuSinAcceso=OcultarMenuSinAcceso'
      'AdministradorPortal=AdministradorPortal'
      'AdministradorRHMini=AdministradorRHMini'
      'Evaluador=Evaluador'
      'LDAP=LDAP'
      'DocumentoNroConLetra=DocumentoNroConLetra'
      'AdministradorMiddleware=AdministradorMiddleware')
    DataSet = MSVerificarUsuario
    BCDToCurrency = False
    DataSetOptions = []
    Left = 233
    Top = 168
  end
  object MSObtenerProximoId: TMSQuery
    Connection = MSConnection
    SQL.Strings = (
      'select MAX(IdSocio) as Id from Asociado.Socio')
    Left = 356
    Top = 33
    object MSObtenerProximoIdId: TIntegerField
      FieldName = 'Id'
      ReadOnly = True
    end
  end
  object MSObtenerIdentificarPK: TMSQuery
    Connection = MSConnection
    SQL.Strings = (
      'select t.table_schema, t.table_name, c.column_name'
      'from'
      'information_schema.table_constraints t'
      'inner join information_schema.key_column_usage c'
      'on t.constraint_name = c.constraint_name'
      
        'where (t.constraint_type = '#39'primary key'#39') and (t.table_schema = ' +
        ':Esquema) and (t.table_name = :Tabla)')
    Left = 356
    Top = 98
    ParamData = <
      item
        DataType = ftString
        Name = 'Esquema'
        Value = nil
      end
      item
        DataType = ftString
        Name = 'Tabla'
        Value = nil
      end>
    object MSObtenerIdentificarPKtable_schema: TWideStringField
      FieldName = 'table_schema'
      ReadOnly = True
      Size = 128
    end
    object MSObtenerIdentificarPKtable_name: TWideStringField
      FieldName = 'table_name'
      Size = 128
    end
    object MSObtenerIdentificarPKcolumn_name: TWideStringField
      FieldName = 'column_name'
      ReadOnly = True
      Size = 128
    end
  end
  object MSSQL: TMSSQL
    Connection = MSConnection
    Left = 366
    Top = 173
  end
  object msqlmntr1: TMSSQLMonitor
    DBMonitorOptions.Host = '127.0.0.1'
    TraceFlags = [tfQPrepare, tfQExecute, tfError, tfConnect, tfTransact, tfService, tfMisc, tfParams]
    Left = 140
    Top = 33
  end
end
