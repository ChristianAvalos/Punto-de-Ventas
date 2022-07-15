object DMUsuario: TDMUsuario
  Height = 573
  Width = 899
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
    object MSUsuarioOcultarMenuSinAcceso: TBooleanField
      FieldName = 'OcultarMenuSinAcceso'
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
      'DECLARE @IdUsuario INT = :IdUsuario,'
      '        @Modulo VARCHAR(30) = :Modulo,'
      '        @ObjetoComponente VARCHAR(250) = :ObjetoComponente;'
      ''
      ''
      ''
      'SELECT TOP (1) *'
      '  FROM (   SELECT IdPermiso,'
      '                  IdUsuario,'
      '                  Modulo,'
      '                  ObjetoComponente,'
      '                  TipoComponente,'
      '                  TipoAcceso,'
      '                  UrevFechaHora,'
      '                  UrevUsuario,'
      '                  UrevCalc'
      '             FROM Usuario.Permiso'
      '            WHERE IdUsuario = @IdUsuario'
      '                  AND Modulo = @Modulo'
      '                  AND ObjetoComponente = @ObjetoComponente'
      '           UNION ALL'
      '           SELECT IdPermiso = 0,'
      '                  u.IdUsuario,'
      '                  m.Descripcion,'
      '                  o.ObjetoComponente,'
      '                  o.TipoComponente,'
      '                  NULL,'
      '                  m.UrevFechaHora,'
      '                  m.UrevUsuario,'
      '                  m.UrevCalc'
      '             FROM Usuario.Usuario u'
      
        '             JOIN Usuario.UsuarioRol ur ON ur.IdUsuario = u.IdUs' +
        'uario'
      '             JOIN Usuario.Rol r ON r.IdRol = ur.IdRol'
      '             JOIN Usuario.RolOperacion ro ON ro.IdRol = r.IdRol'
      
        '             JOIN Usuario.Operacion o ON o.IdOperacion = ro.IdOp' +
        'eracion'
      '             JOIN Usuario.Modulo m ON m.IdModulo = o.IdModulo'
      '            WHERE m.Descripcion = @Modulo'
      '                  AND o.ObjetoComponente = @ObjetoComponente'
      '                  AND u.IdUsuario = @IdUsuario) AS t;')
    BeforeOpen = MSVerificarPermisoBeforeOpen
    BeforePost = MSVerificarPermisoBeforePost
    OnNewRecord = MSVerificarPermisoNewRecord
    Left = 249
    Top = 39
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'IdUsuario'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'Modulo'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'ObjetoComponente'
        Value = nil
      end>
    object MSVerificarPermisoIdPermiso: TIntegerField
      FieldName = 'IdPermiso'
      ReadOnly = True
    end
    object MSVerificarPermisoIdUsuario: TIntegerField
      FieldName = 'IdUsuario'
    end
    object MSVerificarPermisoModulo: TStringField
      FieldName = 'Modulo'
      Size = 30
    end
    object MSVerificarPermisoObjetoComponente: TStringField
      FieldName = 'ObjetoComponente'
      Size = 250
    end
    object MSVerificarPermisoTipoComponente: TStringField
      FieldName = 'TipoComponente'
      Size = 30
    end
    object MSVerificarPermisoTipoAcceso: TStringField
      FieldName = 'TipoAcceso'
      Size = 30
    end
    object MSVerificarPermisoUrevFechaHora: TDateTimeField
      FieldName = 'UrevFechaHora'
    end
    object MSVerificarPermisoUrevUsuario: TStringField
      FieldName = 'UrevUsuario'
      Size = 50
    end
    object MSVerificarPermisoUrevCalc: TWideStringField
      FieldName = 'UrevCalc'
      ReadOnly = True
      Size = 4000
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
  object DSPermisosDisponibles: TDataSource
    DataSet = MSPermisosDisponibles
    Left = 389
    Top = 172
  end
  object MSPermisosDisponibles: TMSQuery
    SQLInsert.Strings = (
      'INSERT INTO Usuario.Permiso'
      
        '  (IdUsuario, Modulo, ObjetoComponente, TipoComponente, TipoAcce' +
        'so, UrevFechaHora, UrevUsuario)'
      'VALUES'
      
        '  (:IdUsuario, :Modulo, :ObjetoComponente, :TipoComponente, :Tip' +
        'oAcceso, :UrevFechaHora, :UrevUsuario)'
      'SET :IdPermiso = SCOPE_IDENTITY()')
    SQLDelete.Strings = (
      'DELETE FROM Usuario.Permiso'
      'WHERE'
      '  IdPermiso = :Old_IdPermiso')
    SQLUpdate.Strings = (
      'UPDATE Usuario.Permiso'
      'SET'
      
        '  IdUsuario = :IdUsuario, Modulo = :Modulo, ObjetoComponente = :' +
        'ObjetoComponente, TipoComponente = :TipoComponente, TipoAcceso =' +
        ' :TipoAcceso, UrevFechaHora = :UrevFechaHora, UrevUsuario = :Ure' +
        'vUsuario'
      'WHERE'
      '  IdPermiso = :Old_IdPermiso')
    SQLRefresh.Strings = (
      
        'SELECT IdUsuario, Modulo, ObjetoComponente, TipoComponente, Tipo' +
        'Acceso, UrevFechaHora, UrevUsuario FROM Usuario.Permiso'
      'WHERE'
      '  IdPermiso = :IdPermiso')
    SQLLock.Strings = (
      'SELECT * FROM Usuario.Permiso'
      'WITH (UPDLOCK, ROWLOCK, HOLDLOCK)'
      'WHERE'
      '  IdPermiso = :Old_IdPermiso')
    SQLRecCount.Strings = (
      'SET :PCOUNT = (SELECT COUNT(*) FROM Usuario.Permiso'
      ')')
    Connection = DMPrincipal.MSConnection
    SQL.Strings = (
      'SELECT * FROM Usuario.Permiso'
      'WHERE IdUsuario = :IdUsuario AND '
      'Modulo = :Modulo AND'
      'TipoComponente IN (:TipoComponente)')
    BeforePost = MSPermisosDisponiblesBeforePost
    IndexFieldNames = 'ObjetoComponente'
    Left = 389
    Top = 117
    ParamData = <
      item
        DataType = ftInteger
        Name = 'IdUsuario'
        Value = nil
      end
      item
        DataType = ftString
        Name = 'Modulo'
        Value = nil
      end
      item
        DataType = ftString
        Name = 'TipoComponente'
        Value = nil
      end>
    object MSPermisosDisponiblesIdPermiso: TIntegerField
      AutoGenerateValue = arAutoInc
      FieldName = 'IdPermiso'
      ReadOnly = True
    end
    object MSPermisosDisponiblesIdUsuario: TIntegerField
      FieldName = 'IdUsuario'
    end
    object MSPermisosDisponiblesModulo: TStringField
      FieldName = 'Modulo'
      Size = 30
    end
    object MSPermisosDisponiblesObjetoComponente: TStringField
      FieldName = 'ObjetoComponente'
      Size = 250
    end
    object MSPermisosDisponiblesTipoComponente: TStringField
      FieldName = 'TipoComponente'
      Size = 30
    end
    object MSPermisosDisponiblesTipoAcceso: TStringField
      FieldName = 'TipoAcceso'
      Size = 30
    end
    object MSPermisosDisponiblesUrevFechaHora: TDateTimeField
      FieldName = 'UrevFechaHora'
    end
    object MSPermisosDisponiblesUrevUsuario: TStringField
      FieldName = 'UrevUsuario'
      Size = 50
    end
    object MSPermisosDisponiblesUrevCalc: TWideStringField
      FieldName = 'UrevCalc'
      ReadOnly = True
      Size = 4000
    end
  end
  object MSInsertarOperacion: TMSQuery
    Connection = DMPrincipal.MSConnection
    SQL.Strings = (
      'DECLARE @Modulo VARCHAR(30) = :Modulo ,'
      '        @ObjetoComponente VARCHAR(250) = :ObjetoComponente ,'
      '        @TipoComponente VARCHAR(30) = :TipoComponente,'
      '@Caption VARCHAR(120) = :Caption'
      ''
      ''
      ''
      ''
      
        'IF NOT EXISTS (SELECT * FROM Usuario.Modulo WHERE Descripcion = ' +
        '@Modulo)'
      'BEGIN'
      #9'IF @Modulo IS NOT NULL '
      #9'begin'
      #9#9'INSERT INTO Usuario.Modulo (Descripcion,'
      #9#9#9#9#9#9#9#9#9'UrevUsuario,'
      #9#9#9#9#9#9#9#9#9'UrevFechaHora)'
      #9#9'VALUES (@Modulo, -- Descripcion - varchar(50)'
      #9#9#9#9#39'Sistema'#39', -- UrevUsuario - varchar(50)'
      #9#9#9#9'GETDATE() -- UrevFechaHora - datetime'
      #9#9#9');'
      #9'END'
      ''
      'END;'
      ''
      
        'IF NOT EXISTS (SELECT * FROM Usuario.Operacion WHERE Modulo = @M' +
        'odulo AND ObjetoComponente = @ObjetoComponente AND TipoComponent' +
        'e = @TipoComponente)'
      'BEGIN'
      ''
      ''
      ''
      '    INSERT INTO Usuario.Operacion (IdModulo,'
      '                                   Modulo,'
      '                                   ObjetoComponente,'
      '                                   TipoComponente,'
      '                                   UrevFechaHora,'
      #9#9#9#9#9#9#9#9'   Caption)'
      '    SELECT IdModulo,'
      '           Descripcion,'
      '           @ObjetoComponente,'
      '           @TipoComponente,'
      '           GETDATE(),'
      #9#9'   @Caption'
      '      FROM Usuario.Modulo'
      '     WHERE Descripcion = @Modulo;'
      ''
      ''
      ''
      ''
      'END;'
      '')
    Left = 574
    Top = 171
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'Modulo'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'ObjetoComponente'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'TipoComponente'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'Caption'
        Value = nil
      end>
  end
  object MSBorrarPermiso: TMSSQL
    Connection = DMPrincipal.MSConnection
    SQL.Strings = (
      'DELETE  FROM  Usuario.Permiso'
      'WHERE  IdUsuario = :IdUsuario AND '
      'Modulo = :Modulo AND'
      'ObjetoComponente = ISNULL(:ObjetoComponente,ObjetoComponente )'
      '')
    Left = 226
    Top = 251
    ParamData = <
      item
        DataType = ftInteger
        Name = 'IdUsuario'
        Value = nil
      end
      item
        DataType = ftString
        Name = 'Modulo'
        Value = nil
      end
      item
        DataType = ftString
        Name = 'ObjetoComponente'
        Value = nil
      end>
  end
  object MSRol: TMSQuery
    SQLInsert.Strings = (
      'INSERT INTO Usuario.Rol'
      '  (Descripcion, UrevUsuario, UrevFechaHora)'
      'VALUES'
      '  (:Descripcion, :UrevUsuario, :UrevFechaHora)'
      'SET :IdRol = SCOPE_IDENTITY()')
    SQLDelete.Strings = (
      'DELETE FROM Usuario.Rol'
      'WHERE'
      '  IdRol = :Old_IdRol')
    SQLUpdate.Strings = (
      'UPDATE Usuario.Rol'
      'SET'
      
        '  Descripcion = :Descripcion, UrevUsuario = :UrevUsuario, UrevFe' +
        'chaHora = :UrevFechaHora'
      'WHERE'
      '  IdRol = :Old_IdRol')
    SQLRefresh.Strings = (
      'SELECT Descripcion, UrevUsuario, UrevFechaHora FROM Usuario.Rol'
      'WHERE'
      '  IdRol = :IdRol')
    SQLLock.Strings = (
      'SELECT * FROM Usuario.Rol'
      'WITH (UPDLOCK, ROWLOCK, HOLDLOCK)'
      'WHERE'
      '  IdRol = :Old_IdRol')
    SQLRecCount.Strings = (
      'SET :PCOUNT = (SELECT COUNT(*) FROM Usuario.Rol'
      ')')
    Connection = DMPrincipal.MSConnection
    SQL.Strings = (
      'SELECT * FROM Usuario.Rol')
    Left = 389
    Top = 242
    object MSRolIdRol: TIntegerField
      FieldName = 'IdRol'
      ReadOnly = True
    end
    object MSRolDescripcion: TStringField
      FieldName = 'Descripcion'
      Size = 50
    end
    object MSRolUrevUsuario: TStringField
      FieldName = 'UrevUsuario'
      Size = 50
    end
    object MSRolUrevFechaHora: TDateTimeField
      FieldName = 'UrevFechaHora'
    end
    object MSRolUrevCalc: TWideStringField
      FieldName = 'UrevCalc'
      ReadOnly = True
      Size = 4000
    end
  end
  object DSRol: TDataSource
    DataSet = MSRol
    Left = 389
    Top = 294
  end
  object MSRolOperacion: TMSQuery
    SQLInsert.Strings = (
      'INSERT INTO Usuario.RolOperacion'
      '  (IdRol, IdOperacion, UrevUsuario, UrevFechaHora)'
      'VALUES'
      '  (:IdRol, :IdOperacion, :UrevUsuario, :UrevFechaHora)'
      'SET :IdRolOperacion = SCOPE_IDENTITY()')
    SQLDelete.Strings = (
      'DELETE FROM Usuario.RolOperacion'
      'WHERE'
      '  IdRolOperacion = :Old_IdRolOperacion')
    SQLUpdate.Strings = (
      'UPDATE Usuario.RolOperacion'
      'SET'
      
        '  IdRol = :IdRol, IdOperacion = :IdOperacion, UrevUsuario = :Ure' +
        'vUsuario, UrevFechaHora = :UrevFechaHora'
      'WHERE'
      '  IdRolOperacion = :Old_IdRolOperacion')
    SQLRefresh.Strings = (
      'SELECT ro.*,'
      '       o.ObjetoComponente,'
      '       o.TipoComponente,'
      '       o.Caption,'
      '       m.IdModulo'
      '  FROM Usuario.RolOperacion ro'
      '  JOIN Usuario.Rol r ON r.IdRol = ro.IdRol'
      '  JOIN Usuario.Operacion o ON o.IdOperacion = ro.IdOperacion'
      '  JOIN Usuario.Modulo m ON m.IdModulo = o.IdModulo'
      ''
      'WHERE'
      '  ro.IdRolOperacion = :IdRolOperacion')
    SQLLock.Strings = (
      'SELECT * FROM Usuario.RolOperacion'
      'WITH (UPDLOCK, ROWLOCK, HOLDLOCK)'
      'WHERE'
      '  IdRolOperacion = :Old_IdRolOperacion')
    SQLRecCount.Strings = (
      'SET :PCOUNT = (SELECT COUNT(*) FROM Usuario.RolOperacion'
      ')')
    Connection = DMPrincipal.MSConnection
    SQL.Strings = (
      'SELECT ro.*,'
      '       o.ObjetoComponente,'
      '       o.TipoComponente,'
      '       o.Caption,'
      '       m.IdModulo'
      '  FROM Usuario.RolOperacion ro'
      '  JOIN Usuario.Rol r ON r.IdRol = ro.IdRol'
      '  JOIN Usuario.Operacion o ON o.IdOperacion = ro.IdOperacion'
      '  JOIN Usuario.Modulo m ON m.IdModulo = o.IdModulo'
      ' WHERE r.IdRol = :IdRol'
      'and m.Descripcion = :Modulo'
      '')
    BeforeOpen = MSRolOperacionBeforeOpen
    BeforePost = MSPermisosDisponiblesBeforePost
    OnNewRecord = MSRolOperacionNewRecord
    Left = 461
    Top = 243
    ParamData = <
      item
        DataType = ftInteger
        Name = 'IdRol'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'Modulo'
        Value = nil
      end>
    object MSRolOperacionIdRolOperacion: TIntegerField
      FieldName = 'IdRolOperacion'
      ReadOnly = True
    end
    object MSRolOperacionIdRol: TIntegerField
      FieldName = 'IdRol'
    end
    object MSRolOperacionIdOperacion: TIntegerField
      FieldName = 'IdOperacion'
    end
    object MSRolOperacionUrevUsuario: TStringField
      FieldName = 'UrevUsuario'
      Size = 50
    end
    object MSRolOperacionUrevFechaHora: TDateTimeField
      FieldName = 'UrevFechaHora'
    end
    object MSRolOperacionUrevCalc: TWideStringField
      FieldName = 'UrevCalc'
      ReadOnly = True
      Size = 4000
    end
    object MSRolOperacionIdModulo: TIntegerField
      FieldName = 'IdModulo'
      ReadOnly = True
    end
    object MSRolOperacionObjetoComponente: TStringField
      FieldName = 'ObjetoComponente'
      ReadOnly = True
      Size = 250
    end
    object MSRolOperacionTipoComponente: TStringField
      FieldName = 'TipoComponente'
      ReadOnly = True
      Size = 30
    end
    object MSRolOperacionCaption: TStringField
      FieldName = 'Caption'
      ReadOnly = True
      Size = 120
    end
  end
  object DSRolOperacion: TDataSource
    DataSet = MSRolOperacion
    Left = 461
    Top = 294
  end
  object MSInsertarRolOperacion: TMSQuery
    Connection = DMPrincipal.MSConnection
    SQL.Strings = (
      'DECLARE @IdRol INT = :IdRol,'
      '        @IdOperacion INT,'
      '        @UrevUsuario VARCHAR(50) = :UrevUsuario,'
      '        @ObjetoComponente VARCHAR(250) = :ObjetoComponente,'
      '        @TipoComponente VARCHAR(30) = :TipoComponente,'
      '        @Modulo VARCHAR(30) = :Modulo;'
      ''
      ''
      'SELECT @IdOperacion = o.IdOperacion'
      '  FROM Usuario.Operacion o'
      '  JOIN Usuario.Modulo m ON m.IdModulo = o.IdModulo'
      ' WHERE m.Descripcion = @Modulo'
      '       AND o.ObjetoComponente = @ObjetoComponente'
      '       AND o.TipoComponente = @TipoComponente;'
      ''
      'INSERT INTO Usuario.RolOperacion (IdRol,'
      '                                  IdOperacion,'
      '                                  UrevUsuario,'
      '                                  UrevFechaHora)'
      'VALUES (@IdRol, @IdOperacion, @UrevUsuario, GETDATE());'
      ''
      '')
    BeforeOpen = MSInsertarRolOperacionBeforeOpen
    Left = 585
    Top = 243
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'IdRol'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'UrevUsuario'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'ObjetoComponente'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'TipoComponente'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'Modulo'
        Value = nil
      end>
  end
  object MSVerificarOperacion: TMSQuery
    Connection = DMPrincipal.MSConnection
    SQL.Strings = (
      'DECLARE @IdRol INT = :IdRol,'
      '        @IdOperacion INT,'
      '        @UrevUsuario VARCHAR(50) = :UrevUsuario,'
      '        @ObjetoComponente VARCHAR(250) = :ObjetoComponente,'
      '        @TipoComponente VARCHAR(30) = :TipoComponente,'
      '        @Modulo VARCHAR(30) = :Modulo;'
      ''
      ''
      ''
      'SELECT o.*'
      '  FROM Usuario.Operacion o'
      '  JOIN Usuario.Modulo m ON m.IdModulo = o.IdModulo'
      '  JOIN Usuario.RolOperacion ro ON ro.IdOperacion = o.IdOperacion'
      '  JOIN Usuario.Rol r ON r.IdRol = ro.IdRol'
      ' WHERE m.Descripcion = @Modulo'
      '       AND o.ObjetoComponente = @ObjetoComponente'
      '       AND r.IdRol = @IdRol;')
    BeforeOpen = MSVerificarOperacionBeforeOpen
    Left = 589
    Top = 304
    ParamData = <
      item
        DataType = ftInteger
        Name = 'IdRol'
        Value = nil
      end
      item
        DataType = ftString
        Name = 'UrevUsuario'
        Value = nil
      end
      item
        DataType = ftString
        Name = 'ObjetoComponente'
        Value = nil
      end
      item
        DataType = ftString
        Name = 'TipoComponente'
        Value = nil
      end
      item
        DataType = ftString
        Name = 'Modulo'
        Value = nil
      end>
  end
  object MSBorrarOperacion: TMSQuery
    Connection = DMPrincipal.MSConnection
    SQL.Strings = (
      'DECLARE @IdRol INT = :IdRol,'
      '        @IdOperacion INT,'
      '        @UrevUsuario VARCHAR(50) = :UrevUsuario,'
      '        @ObjetoComponente VARCHAR(250) = :ObjetoComponente,'
      '        @TipoComponente VARCHAR(30) = :TipoComponente,'
      '        @Modulo VARCHAR(30) = :Modulo;'
      ''
      ''
      'SELECT @IdOperacion = o.IdOperacion'
      '  FROM Usuario.Operacion o'
      '  JOIN Usuario.Modulo m ON m.IdModulo = o.IdModulo'
      ' WHERE m.Descripcion = @Modulo'
      '       AND o.ObjetoComponente = @ObjetoComponente'
      ''
      ''
      'DELETE FROM Usuario.RolOperacion'
      ' WHERE IdRol = @IdRol'
      '       AND IdOperacion = @IdOperacion;')
    Left = 392
    Top = 352
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'IdRol'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'UrevUsuario'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'ObjetoComponente'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'TipoComponente'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'Modulo'
        Value = nil
      end>
  end
end
