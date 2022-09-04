object DMProductos: TDMProductos
  Height = 480
  Width = 640
  object MSProducto: TMSQuery
    SQLInsert.Strings = (
      'INSERT INTO Almacen.Producto'
      
        '  (IdOrganizacion, IdTipoProducto, IdGrupoProducto, Descripcion,' +
        ' CodigoBarra, Serie, Lote, Memo, IVA_Porcentaje, IdUnidadMedida,' +
        ' SeriePrefijo, UrevUsuario, UrevFechaHora, CodigoAGenerar)'
      'VALUES'
      
        '  (:IdOrganizacion, :IdTipoProducto, :IdGrupoProducto, :Descripc' +
        'ion, :CodigoBarra, :Serie, :Lote, :Memo, :IVA_Porcentaje, :IdUni' +
        'dadMedida, :SeriePrefijo, :UrevUsuario, :UrevFechaHora, :CodigoA' +
        'Generar)'
      'SET :IdProducto = SCOPE_IDENTITY()')
    SQLDelete.Strings = (
      'DELETE FROM Almacen.Producto'
      'WHERE'
      '  IdProducto = :Old_IdProducto')
    SQLUpdate.Strings = (
      'UPDATE Almacen.Producto'
      'SET'
      
        '  IdOrganizacion = :IdOrganizacion, IdTipoProducto = :IdTipoProd' +
        'ucto, IdGrupoProducto = :IdGrupoProducto, Descripcion = :Descrip' +
        'cion, CodigoBarra = :CodigoBarra, Serie = :Serie, Lote = :Lote, ' +
        'Memo = :Memo, IVA_Porcentaje = :IVA_Porcentaje, IdUnidadMedida =' +
        ' :IdUnidadMedida, SeriePrefijo = :SeriePrefijo, UrevUsuario = :U' +
        'revUsuario, UrevFechaHora = :UrevFechaHora, CodigoAGenerar = :Co' +
        'digoAGenerar'
      'WHERE'
      '  IdProducto = :Old_IdProducto')
    SQLRefresh.Strings = (
      
        'SELECT IdOrganizacion, IdTipoProducto, IdGrupoProducto, Descripc' +
        'ion, CodigoBarra, Serie, Lote, Memo, IVA_Porcentaje, IdUnidadMed' +
        'ida, SeriePrefijo, UrevUsuario, UrevFechaHora, CodigoAGenerar FR' +
        'OM Almacen.Producto'
      'WHERE'
      '  IdProducto = :IdProducto')
    SQLLock.Strings = (
      'SELECT * FROM Almacen.Producto'
      'WITH (UPDLOCK, ROWLOCK, HOLDLOCK)'
      'WHERE'
      '  IdProducto = :Old_IdProducto')
    SQLRecCount.Strings = (
      'SET :PCOUNT = (SELECT COUNT(*) FROM Almacen.Producto'
      ')')
    Connection = DMPrincipal.MSConnection
    SQL.Strings = (
      
        'SELECT p.*,fp.Descripcion AS FamiliaDescripcion FROM Almacen.Pro' +
        'ducto p '
      
        'LEFT JOIN Almacen.GrupoProducto gp ON gp.IdGrupoProducto = p.IdG' +
        'rupoProducto'
      
        'LEFT JOIN Almacen.FamiliaProducto fp ON fp.IdFamiliaProducto = g' +
        'p.IdFamiliaProducto'
      '')
    BeforeUpdateExecute = MSProductoBeforeUpdateExecute
    BeforeOpen = MSProductoBeforeOpen
    BeforeInsert = MSProductoBeforeInsert
    BeforeEdit = MSProductoBeforeEdit
    BeforePost = MSProductoBeforePost
    AfterPost = MSProductoAfterPost
    AfterCancel = MSProductoAfterCancel
    BeforeDelete = MSProductoBeforeDelete
    AfterScroll = MSProductoAfterScroll
    OnNewRecord = MSProductoNewRecord
    OnPostError = MSProductoPostError
    Left = 48
    Top = 40
    object MSProductoIdProducto: TIntegerField
      FieldName = 'IdProducto'
      ReadOnly = True
    end
    object MSProductoIdOrganizacion: TIntegerField
      FieldName = 'IdOrganizacion'
    end
    object MSProductoIdTipoProducto: TIntegerField
      FieldName = 'IdTipoProducto'
    end
    object MSProductoIdGrupoProducto: TIntegerField
      FieldName = 'IdGrupoProducto'
    end
    object MSProductoDescripcion: TStringField
      FieldName = 'Descripcion'
      Size = 100
    end
    object MSProductoCodigoBarra: TStringField
      FieldName = 'CodigoBarra'
      Size = 30
    end
    object MSProductoSerie: TBooleanField
      FieldName = 'Serie'
    end
    object MSProductoLote: TBooleanField
      FieldName = 'Lote'
    end
    object MSProductoMemo: TStringField
      FieldName = 'Memo'
      Size = 250
    end
    object MSProductoIVA_Porcentaje: TFloatField
      FieldName = 'IVA_Porcentaje'
    end
    object MSProductoIdUnidadMedida: TIntegerField
      FieldName = 'IdUnidadMedida'
    end
    object MSProductoSeriePrefijo: TStringField
      FieldName = 'SeriePrefijo'
      Size = 10
    end
    object MSProductoUrevUsuario: TStringField
      FieldName = 'UrevUsuario'
      Size = 50
    end
    object MSProductoUrevFechaHora: TDateTimeField
      FieldName = 'UrevFechaHora'
    end
    object MSProductoCodigoAGenerar: TIntegerField
      FieldName = 'CodigoAGenerar'
    end
    object MSProductoUrevCalc: TWideStringField
      FieldName = 'UrevCalc'
      ReadOnly = True
      Size = 4000
    end
    object MSProductoFamiliaDescripcion: TStringField
      FieldName = 'FamiliaDescripcion'
      ReadOnly = True
      Size = 50
    end
  end
  object DSProducto: TDataSource
    DataSet = MSProducto
    Left = 48
    Top = 112
  end
  object MSProductoPrecios: TMSQuery
    SQLInsert.Strings = (
      'INSERT INTO Almacen.ProductoPrecio'
      
        '  (IdProducto, IdPrecio, IdMoneda, Monto, UrevUsuario, UrevFecha' +
        'Hora)'
      'VALUES'
      
        '  (:IdProducto, :IdPrecio, :IdMoneda, :Monto, :UrevUsuario, :Ure' +
        'vFechaHora)'
      'SET :IdProductoPrecio = SCOPE_IDENTITY()')
    SQLDelete.Strings = (
      'DELETE FROM Almacen.ProductoPrecio'
      'WHERE'
      '  IdProductoPrecio = :Old_IdProductoPrecio')
    SQLUpdate.Strings = (
      'UPDATE Almacen.ProductoPrecio'
      'SET'
      
        '  IdProducto = :IdProducto, IdPrecio = :IdPrecio, IdMoneda = :Id' +
        'Moneda, Monto = :Monto, UrevUsuario = :UrevUsuario, UrevFechaHor' +
        'a = :UrevFechaHora'
      'WHERE'
      '  IdProductoPrecio = :Old_IdProductoPrecio')
    SQLRefresh.Strings = (
      
        'SELECT IdProducto, IdPrecio, IdMoneda, Monto, UrevUsuario, UrevF' +
        'echaHora FROM Almacen.ProductoPrecio'
      'WHERE'
      '  IdProductoPrecio = :IdProductoPrecio')
    SQLLock.Strings = (
      'SELECT * FROM Almacen.ProductoPrecio'
      'WITH (UPDLOCK, ROWLOCK, HOLDLOCK)'
      'WHERE'
      '  IdProductoPrecio = :Old_IdProductoPrecio')
    SQLRecCount.Strings = (
      'SET :PCOUNT = (SELECT COUNT(*) FROM Almacen.ProductoPrecio'
      ')')
    Connection = DMPrincipal.MSConnection
    SQL.Strings = (
      'SELECT pp.*,m.Descripcion AS Moneda,p.Descripcion AS Precio'
      'FROM Almacen.ProductoPrecio pp '
      'LEFT JOIN Sistema.Moneda m ON m.IdMoneda = pp.IdMoneda'
      'LEFT JOIN Definicion.Precio p ON p.IdPrecio = pp.IdPrecio'
      'WHERE pp.IdProducto = :IdProducto')
    BeforeUpdateExecute = MSProductoPreciosBeforeUpdateExecute
    BeforeOpen = MSProductoPreciosBeforeOpen
    BeforePost = MSProductoPreciosBeforePost
    OnNewRecord = MSProductoPreciosNewRecord
    OnPostError = MSProductoPreciosPostError
    Left = 144
    Top = 40
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'IdProducto'
        Value = nil
      end>
    object MSProductoPreciosIdProductoPrecio: TIntegerField
      FieldName = 'IdProductoPrecio'
      ReadOnly = True
    end
    object MSProductoPreciosIdProducto: TIntegerField
      FieldName = 'IdProducto'
    end
    object MSProductoPreciosIdPrecio: TIntegerField
      FieldName = 'IdPrecio'
    end
    object MSProductoPreciosIdMoneda: TIntegerField
      FieldName = 'IdMoneda'
    end
    object MSProductoPreciosMonto: TCurrencyField
      FieldName = 'Monto'
    end
    object MSProductoPreciosUrevUsuario: TStringField
      FieldName = 'UrevUsuario'
      Size = 30
    end
    object MSProductoPreciosUrevFechaHora: TDateTimeField
      FieldName = 'UrevFechaHora'
    end
    object MSProductoPreciosUrevCalc: TWideStringField
      FieldName = 'UrevCalc'
      ReadOnly = True
      Size = 4000
    end
    object MSProductoPreciosMoneda: TStringField
      FieldName = 'Moneda'
      ReadOnly = True
      Size = 30
    end
    object MSProductoPreciosPrecio: TStringField
      FieldName = 'Precio'
      ReadOnly = True
      Size = 25
    end
  end
  object DSProductoPrecios: TDataSource
    DataSet = MSProductoPrecios
    Left = 136
    Top = 112
  end
end