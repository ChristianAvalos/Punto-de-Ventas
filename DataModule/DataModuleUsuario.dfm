object DMUsuario: TDMUsuario
  Height = 480
  Width = 640
  object MSExisteUsuarios: TMSQuery
    Connection = DMPrincipal.MSConnection
    SQL.Strings = (
      
        'SELECT ISNULL(COUNT(*), 0) AS CantidadUsuarios FROM Usuario.Usua' +
        'rio')
    Left = 120
    Top = 40
    object MSExisteUsuariosCantidadUsuarios: TIntegerField
      FieldName = 'CantidadUsuarios'
      ReadOnly = True
    end
  end
  object MSUsuario: TMSQuery
    SQLInsert.Strings = (
      'INSERT INTO Usuario.Usuario'
      
        '  (IdOrganizacion, NombreUsuario, Contrasena, Email, Activo, Nom' +
        'bresApellidos, Foto, DocumentoNro, Observacion, UrevUsuario, Ure' +
        'vFechaHora, Template)'
      'VALUES'
      
        '  (:IdOrganizacion, :NombreUsuario, :Contrasena, :Email, :Activo' +
        ', :NombresApellidos, :Foto, :DocumentoNro, :Observacion, :UrevUs' +
        'uario, :UrevFechaHora, :Template)'
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
        'vUsuario, UrevFechaHora = :UrevFechaHora, Template = :Template'
      'WHERE'
      '  IdUsuario = :Old_IdUsuario')
    SQLRefresh.Strings = (
      
        'SELECT IdOrganizacion, NombreUsuario, Contrasena, Email, Activo,' +
        ' NombresApellidos, Foto, DocumentoNro, Observacion, UrevUsuario,' +
        ' UrevFechaHora, Template FROM Usuario.Usuario'
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
    Connection = DMPrincipal.MSConnection
    SQL.Strings = (
      'SELECT * FROM Usuario.Usuario'
      'ORDER BY  IdUsuario ;')
    BeforeUpdateExecute = MSUsuarioBeforeUpdateExecute
    AfterUpdateExecute = MSUsuarioAfterUpdateExecute
    BeforeInsert = MSUsuarioBeforeInsert
    BeforeEdit = MSUsuarioBeforeEdit
    BeforePost = MSUsuarioBeforePost
    AfterPost = MSUsuarioAfterPost
    AfterCancel = MSUsuarioAfterCancel
    BeforeDelete = MSUsuarioBeforeDelete
    AfterDelete = MSUsuarioAfterDelete
    OnCalcFields = MSUsuarioCalcFields
    OnNewRecord = MSUsuarioNewRecord
    OnPostError = MSUsuarioPostError
    Left = 32
    Top = 40
    object MSUsuarioIdUsuario: TIntegerField
      AutoGenerateValue = arAutoInc
      FieldName = 'IdUsuario'
      ReadOnly = True
    end
    object MSUsuarioIdOrganizacion: TIntegerField
      FieldName = 'IdOrganizacion'
    end
    object MSUsuarioNombreUsuario: TStringField
      FieldName = 'NombreUsuario'
    end
    object MSUsuarioContrasena: TStringField
      FieldName = 'Contrasena'
      Size = 200
    end
    object MSUsuarioEmail: TStringField
      FieldName = 'Email'
      Size = 100
    end
    object MSUsuarioActivo: TBooleanField
      FieldName = 'Activo'
    end
    object MSUsuarioNombresApellidos: TStringField
      FieldName = 'NombresApellidos'
      Size = 50
    end
    object MSUsuarioFoto: TBlobField
      FieldName = 'Foto'
    end
    object MSUsuarioDocumentoNro: TStringField
      FieldName = 'DocumentoNro'
      Size = 30
    end
    object MSUsuarioObservacion: TStringField
      FieldName = 'Observacion'
      Size = 500
    end
    object MSUsuarioUrevUsuario: TStringField
      FieldName = 'UrevUsuario'
      Size = 50
    end
    object MSUsuarioUrevFechaHora: TDateTimeField
      FieldName = 'UrevFechaHora'
    end
    object MSUsuarioUrevCalc: TWideStringField
      FieldName = 'UrevCalc'
      ReadOnly = True
      Size = 4000
    end
    object MSUsuarioPasswordStatus: TStringField
      FieldKind = fkCalculated
      FieldName = 'PasswordStatus'
      Size = 15
      Calculated = True
    end
    object MSUsuarioTemplate: TBlobField
      FieldName = 'Template'
    end
  end
  object DSUsuario: TDataSource
    DataSet = MSUsuario
    Left = 29
    Top = 108
  end
  object MSVerificarPermiso: TMSQuery
    Connection = DMPrincipal.MSConnection
    SQL.Strings = (
      
        'SELECT ISNULL(COUNT(*), 0) AS CantidadUsuarios FROM Usuario.Usua' +
        'rio')
    Left = 248
    Top = 40
    object IntegerField2: TIntegerField
      FieldName = 'CantidadUsuarios'
      ReadOnly = True
    end
  end
  object DSVerificarPermiso: TDataSource
    DataSet = MSVerificarPermiso
    Left = 257
    Top = 114
  end
  object MSScriptCrearUsuario: TMSScript
    SQL.Strings = (
      'IF DATABASE_PRINCIPAL_ID(&UsuarioVerificacion) IS NULL'
      'BEGIN'
      '    CREATE LOGIN &Usuario'
      '    WITH PASSWORD = N&Contrasena,'
      '         DEFAULT_DATABASE = &BD,'
      '         CHECK_EXPIRATION = OFF,'
      '         CHECK_POLICY = OFF;'
      '    ALTER SERVER ROLE [sysadmin] ADD MEMBER &Usuario;'
      '    USE &BD;'
      '    CREATE USER &Usuario FOR LOGIN &Usuario;'
      '    USE &BD;'
      '    ALTER ROLE [db_datareader] ADD MEMBER &Usuario;'
      '    ALTER ROLE [db_datawriter] ADD MEMBER &Usuario;'
      'END'
      'ELSE'
      '    ALTER LOGIN &Usuario WITH PASSWORD = N&Contrasena'
      'GO'
      '&Estado'
      'GO')
    Connection = DMPrincipal.MSConnection
    Left = 392
    Top = 40
    MacroData = <
      item
        Name = 'UsuarioVerificacion'
      end
      item
        Name = 'Usuario'
      end
      item
        Name = 'Contrasena'
      end
      item
        Name = 'BD'
      end
      item
        Name = 'Estado'
      end>
  end
  object MSScriptBorrarUsuario: TMSScript
    SQL.Strings = (
      'IF DATABASE_PRINCIPAL_ID(&UsuarioVerificacion) IS NOT NULL'
      'BEGIN'
      ''
      'DECLARE @Procesos INTEGER'
      ''
      'SELECT @Procesos = COUNT(session_id)'
      'FROM sys.dm_exec_sessions'
      'WHERE login_name = &UsuarioVerificacion'
      ''
      'IF @Procesos > 0 '
      'BEGIN '
      ''
      'DECLARE @loginNameToDrop sysname'
      'SET @loginNameToDrop = &UsuarioVerificacion;'
      ''
      'DECLARE sessionsToKill CURSOR FAST_FORWARD FOR'
      '    SELECT session_id'
      '    FROM sys.dm_exec_sessions'
      '    WHERE login_name = @loginNameToDrop'
      'OPEN sessionsToKill'
      ''
      'DECLARE @sessionId INT'
      'DECLARE @statement NVARCHAR(200)'
      ''
      'FETCH NEXT FROM sessionsToKill INTO @sessionId'
      ''
      'WHILE @@FETCH_STATUS = 0'
      'BEGIN'
      
        '    PRINT '#39'Killing session '#39' + CAST(@sessionId AS NVARCHAR(20)) ' +
        '+ '#39' for login '#39' + @loginNameToDrop'
      ''
      '    SET @statement = '#39'KILL '#39' + CAST(@sessionId AS NVARCHAR(20))'
      '    EXEC sp_executesql @statement'
      ''
      '    FETCH NEXT FROM sessionsToKill INTO @sessionId'
      'END'
      ''
      'CLOSE sessionsToKill'
      'DEALLOCATE sessionsToKill'
      ''
      'PRINT '#39'Dropping login '#39' + @loginNameToDrop'
      'SET @statement = '#39'DROP LOGIN ['#39' + @loginNameToDrop + '#39']'#39
      'EXEC sp_executesql @statement'
      ''
      'END'
      ''
      'USE &BD'
      'DROP USER &Usuario'
      'DROP LOGIN &Usuario'
      'END'
      ''
      'GO')
    Connection = DMPrincipal.MSConnection
    Left = 512
    Top = 40
    MacroData = <
      item
        Name = 'UsuarioVerificacion'
        Value = #39'rgimenez'#39
      end
      item
        Name = 'BD'
        Value = '[AFD.vtg]'
      end
      item
        Name = 'Usuario'
        Value = '[rgimenez]'
      end>
  end
  object MSCambiarMiContrasena: TMSQuery
    Connection = DMPrincipal.MSConnection
    SQL.Strings = (
      'UPDATE Usuario.Usuario SET Contrasena = :Contrasena'
      'WHERE IdUsuario = :IdUsuario')
    Left = 126
    Top = 120
    ParamData = <
      item
        DataType = ftString
        Name = 'Contrasena'
        Value = nil
      end
      item
        DataType = ftInteger
        Name = 'IdUsuario'
        Value = nil
      end>
  end
end
