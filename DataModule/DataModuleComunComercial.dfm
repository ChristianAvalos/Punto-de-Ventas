object DMComunComercial: TDMComunComercial
  Height = 480
  Width = 640
  object MSPrecio: TMSQuery
    Connection = DMPrincipal.MSConnection
    SQL.Strings = (
      'SELECT'
      'IdPrecio,'
      'Descripcion'
      'FROM'
      'Definicion.Precio'
      'WHERE'
      'IdOrganizacion = :IdOrganizacion AND'
      'IdPrecio <> -1')
    IndexFieldNames = 'IdPrecio'
    Left = 36
    Top = 18
    ParamData = <
      item
        DataType = ftInteger
        Name = 'IdOrganizacion'
        Value = nil
      end>
    object MSPrecioIdPrecio: TIntegerField
      AutoGenerateValue = arAutoInc
      FieldName = 'IdPrecio'
      ReadOnly = True
    end
    object MSPrecioDescripcion: TStringField
      FieldName = 'Descripcion'
      Size = 25
    end
  end
  object DSPrecio: TDataSource
    DataSet = MSPrecio
    Left = 37
    Top = 88
  end
end
