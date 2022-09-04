object DMComunGlobal: TDMComunGlobal
  Height = 480
  Width = 640
  object MSMoneda: TMSQuery
    SQLRefresh.Strings = (
      
        'SELECT IdMoneda, Descripcion, Simbolo, ISO4217 FROM Sistema.Mone' +
        'da'
      'WHERE'
      '  IdMoneda = :IdMoneda')
    Connection = DMPrincipal.MSConnection
    SQL.Strings = (
      'SELECT * '
      'FROM Sistema.Moneda'
      'ORDER BY Descripcion')
    IndexFieldNames = 'IdMoneda'
    Left = 113
    Top = 21
    object MSMonedaIdMoneda: TIntegerField
      FieldName = 'IdMoneda'
    end
    object MSMonedaDescripcion: TStringField
      FieldName = 'Descripcion'
      Size = 30
    end
    object MSMonedaSimbolo: TStringField
      FieldName = 'Simbolo'
      Size = 3
    end
    object MSMonedaISO4217: TStringField
      FieldName = 'ISO4217'
      Size = 3
    end
  end
  object DSMoneda: TDataSource
    DataSet = MSMoneda
    Left = 114
    Top = 72
  end
end
