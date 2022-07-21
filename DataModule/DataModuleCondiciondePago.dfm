object DMCondiciondePago: TDMCondiciondePago
  Height = 480
  Width = 640
  object MSCondicionPago: TMSQuery
    SQLInsert.Strings = (
      'INSERT INTO Definicion.CondicionPago'
      
        '  (IdOrganizacion, Descripcion, UrevUsuario, UrevFechaHora, Tipo' +
        'Pago)'
      'VALUES'
      
        '  (:IdOrganizacion, :Descripcion, :UrevUsuario, :UrevFechaHora, ' +
        ':TipoPago)'
      'SET :IdCondicionPago = SCOPE_IDENTITY()')
    SQLDelete.Strings = (
      'DELETE FROM Definicion.CondicionPago'
      'WHERE'
      '  IdCondicionPago = :Old_IdCondicionPago')
    SQLUpdate.Strings = (
      'UPDATE Definicion.CondicionPago'
      'SET'
      
        '  IdOrganizacion = :IdOrganizacion, Descripcion = :Descripcion, ' +
        'UrevUsuario = :UrevUsuario, UrevFechaHora = :UrevFechaHora, Tipo' +
        'Pago = :TipoPago'
      'WHERE'
      '  IdCondicionPago = :Old_IdCondicionPago')
    SQLRefresh.Strings = (
      
        'SELECT IdOrganizacion, Descripcion, UrevUsuario, UrevFechaHora, ' +
        'TipoPago FROM Definicion.CondicionPago'
      'WHERE'
      '  IdCondicionPago = :IdCondicionPago')
    SQLLock.Strings = (
      'SELECT * FROM Definicion.CondicionPago'
      'WITH (UPDLOCK, ROWLOCK, HOLDLOCK)'
      'WHERE'
      '  IdCondicionPago = :Old_IdCondicionPago')
    SQLRecCount.Strings = (
      'SET :PCOUNT = (SELECT COUNT(*) FROM Definicion.CondicionPago'
      ')')
    Connection = DMPrincipal.MSConnection
    SQL.Strings = (
      'SELECT * FROM Definicion.CondicionPago')
    BeforeOpen = MSCondicionPagoBeforeOpen
    BeforeInsert = MSCondicionPagoBeforeInsert
    BeforeEdit = MSCondicionPagoBeforeEdit
    BeforePost = MSCondicionPagoBeforePost
    AfterPost = MSCondicionPagoAfterPost
    AfterCancel = MSCondicionPagoAfterCancel
    BeforeDelete = MSCondicionPagoBeforeDelete
    OnNewRecord = MSCondicionPagoNewRecord
    OnPostError = MSCondicionPagoPostError
    Left = 39
    Top = 36
    object MSCondicionPagoIdCondicionPago: TIntegerField
      FieldName = 'IdCondicionPago'
      ReadOnly = True
    end
    object MSCondicionPagoIdOrganizacion: TIntegerField
      FieldName = 'IdOrganizacion'
    end
    object MSCondicionPagoDescripcion: TStringField
      FieldName = 'Descripcion'
      Size = 40
    end
    object MSCondicionPagoUrevUsuario: TStringField
      FieldName = 'UrevUsuario'
      Size = 50
    end
    object MSCondicionPagoUrevFechaHora: TDateTimeField
      FieldName = 'UrevFechaHora'
    end
    object MSCondicionPagoUrevCalc: TWideStringField
      FieldName = 'UrevCalc'
      ReadOnly = True
      Size = 4000
    end
    object MSCondicionPagoTipoPago: TStringField
      FieldName = 'TipoPago'
      Size = 100
    end
  end
  object DSCondicionPago: TDataSource
    DataSet = MSCondicionPago
    Left = 40
    Top = 98
  end
  object DSBuscadorCondicionPago: TDataSource
    DataSet = MSBuscadorCondicionPago
    Left = 236
    Top = 113
  end
  object MSBuscadorCondicionPago: TMSQuery
    SQLInsert.Strings = (
      'INSERT INTO Definicion.CondicionPago'
      '  (Descripcion, TipoPago)'
      'VALUES'
      '  (:Descripcion, :TipoPago)'
      'SET :IdCondicionPago = SCOPE_IDENTITY()')
    SQLDelete.Strings = (
      'DELETE FROM Definicion.CondicionPago'
      'WHERE'
      '  IdCondicionPago = :Old_IdCondicionPago')
    SQLUpdate.Strings = (
      'UPDATE Definicion.CondicionPago'
      'SET'
      '  Descripcion = :Descripcion, TipoPago = :TipoPago'
      'WHERE'
      '  IdCondicionPago = :Old_IdCondicionPago')
    SQLRefresh.Strings = (
      'SELECT Descripcion, TipoPago FROM Definicion.CondicionPago'
      'WHERE'
      '  IdCondicionPago = :IdCondicionPago')
    SQLLock.Strings = (
      'SELECT * FROM Definicion.CondicionPago'
      'WITH (UPDLOCK, ROWLOCK, HOLDLOCK)'
      'WHERE'
      '  IdCondicionPago = :Old_IdCondicionPago')
    SQLRecCount.Strings = (
      'SET :PCOUNT = (SELECT COUNT(*) FROM Definicion.CondicionPago'
      ')')
    Connection = DMPrincipal.MSConnection
    SQL.Strings = (
      'SELECT '
      'cp.IdCondicionPago,'
      'cp.Descripcion,'
      'cp.TipoPago'
      'FROM'
      'Definicion.CondicionPago cp'
      'WHERE'
      'cp.IdOrganizacion = 1 '
      
        'AND cp.IdCondicionPago = ISNULL(:IdCondicionPago,cp.IdCondicionP' +
        'ago)'
      
        'AND cp.TipoPago like ISNULL(:TipoCondicionPago, cp.TipoPago) COL' +
        'LATE Modern_Spanish_CI_AI  '
      
        'AND cp.Descripcion LIKE ISNULL(:Descripcion, cp.Descripcion) COL' +
        'LATE Modern_Spanish_CI_AI  '
      'ORDER BY'
      'cp.Descripcion')
    Left = 234
    Top = 23
    ParamData = <
      item
        DataType = ftInteger
        Name = 'IdCondicionPago'
        Value = nil
      end
      item
        DataType = ftString
        Name = 'TipoCondicionPago'
        Value = nil
      end
      item
        DataType = ftString
        Name = 'Descripcion'
        Size = 8
        Value = 'efectivo'
      end>
    object MSBuscadorCondicionPagoIdCondicionPago: TIntegerField
      FieldName = 'IdCondicionPago'
      ReadOnly = True
    end
    object MSBuscadorCondicionPagoDescripcion: TStringField
      FieldName = 'Descripcion'
      Size = 40
    end
    object MSBuscadorCondicionPagoTipoPago: TStringField
      FieldName = 'TipoPago'
      Size = 100
    end
  end
end
