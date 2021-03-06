object DMPrecios: TDMPrecios
  Height = 480
  Width = 640
  object MSPrecio: TMSQuery
    SQLInsert.Strings = (
      'INSERT INTO Definicion.Precio'
      
        '  (IdOrganizacion, Moneda, Descripcion, UrevUsuario, UrevFechaHo' +
        'ra)'
      'VALUES'
      
        '  (:IdOrganizacion, :Moneda, :Descripcion, :UrevUsuario, :UrevFe' +
        'chaHora)'
      'SET :IdPrecio = SCOPE_IDENTITY()')
    SQLDelete.Strings = (
      'DELETE FROM Definicion.Precio'
      'WHERE'
      '  IdPrecio = :Old_IdPrecio')
    SQLUpdate.Strings = (
      'UPDATE Definicion.Precio'
      'SET'
      
        '  IdOrganizacion = :IdOrganizacion, Moneda = :Moneda, Descripcio' +
        'n = :Descripcion, UrevUsuario = :UrevUsuario, UrevFechaHora = :U' +
        'revFechaHora'
      'WHERE'
      '  IdPrecio = :Old_IdPrecio')
    SQLRefresh.Strings = (
      
        'SELECT IdOrganizacion, Moneda, Descripcion, UrevUsuario, UrevFec' +
        'haHora FROM Definicion.Precio'
      'WHERE'
      '  IdPrecio = :IdPrecio')
    SQLLock.Strings = (
      'SELECT * FROM Definicion.Precio'
      'WITH (UPDLOCK, ROWLOCK, HOLDLOCK)'
      'WHERE'
      '  IdPrecio = :Old_IdPrecio')
    SQLRecCount.Strings = (
      'SET :PCOUNT = (SELECT COUNT(*) FROM Definicion.Precio'
      ')')
    Connection = DMPrincipal.MSConnection
    SQL.Strings = (
      'SELECT * FROM Definicion.Precio')
    BeforeUpdateExecute = MSPrecioBeforeUpdateExecute
    RefreshOptions = [roAfterInsert, roAfterUpdate, roBeforeEdit]
    BeforeOpen = MSPrecioBeforeOpen
    BeforeInsert = MSPrecioBeforeInsert
    BeforeEdit = MSPrecioBeforeEdit
    BeforePost = MSPrecioBeforePost
    AfterPost = MSPrecioAfterPost
    AfterCancel = MSPrecioAfterCancel
    BeforeDelete = MSPrecioBeforeDelete
    OnNewRecord = MSPrecioNewRecord
    OnPostError = MSPrecioPostError
    Options.FullRefresh = True
    Options.ReturnParams = True
    Left = 226
    Top = 120
    object MSPrecioIdPrecio: TIntegerField
      FieldName = 'IdPrecio'
      ReadOnly = True
    end
    object MSPrecioIdOrganizacion: TIntegerField
      FieldName = 'IdOrganizacion'
    end
    object MSPrecioMoneda: TStringField
      FieldName = 'Moneda'
      Size = 100
    end
    object MSPrecioDescripcion: TStringField
      FieldName = 'Descripcion'
      Size = 25
    end
    object MSPrecioUrevUsuario: TStringField
      FieldName = 'UrevUsuario'
      Size = 50
    end
    object MSPrecioUrevFechaHora: TDateTimeField
      FieldName = 'UrevFechaHora'
    end
    object MSPrecioUrevCalc: TWideStringField
      FieldName = 'UrevCalc'
      ReadOnly = True
      Size = 4000
    end
  end
  object DSPrecio: TDataSource
    DataSet = MSPrecio
    Left = 225
    Top = 200
  end
end
