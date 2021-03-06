object DMOrganizacion: TDMOrganizacion
  Height = 480
  Width = 640
  PixelsPerInch = 96
  object MSOrganizacion: TMSQuery
    SQLInsert.Strings = (
      'INSERT INTO Sistema.Organizacion'
      
        '  (IdOrganizacion, RazonSocial, Direccion, Ciudad, IdPais, Telef' +
        'ono1, Telefono2, Fax1, Fax2, Email, Website, Logotipo, MetodoCos' +
        'teo, RepresentanteContrato, RUC)'
      'VALUES'
      
        '  (:IdOrganizacion, :RazonSocial, :Direccion, :Ciudad, :IdPais, ' +
        ':Telefono1, :Telefono2, :Fax1, :Fax2, :Email, :Website, :Logotip' +
        'o, :MetodoCosteo, :RepresentanteContrato, :RUC)')
    SQLDelete.Strings = (
      'DELETE FROM Sistema.Organizacion'
      'WHERE'
      '  IdOrganizacion = :Old_IdOrganizacion')
    SQLUpdate.Strings = (
      'UPDATE Sistema.Organizacion'
      'SET'
      
        '  IdOrganizacion = :IdOrganizacion, RazonSocial = :RazonSocial, ' +
        'Direccion = :Direccion, Ciudad = :Ciudad, IdPais = :IdPais, Tele' +
        'fono1 = :Telefono1, Telefono2 = :Telefono2, Fax1 = :Fax1, Fax2 =' +
        ' :Fax2, Email = :Email, Website = :Website, Logotipo = :Logotipo' +
        ', MetodoCosteo = :MetodoCosteo, RepresentanteContrato = :Represe' +
        'ntanteContrato, RUC = :RUC'
      'WHERE'
      '  IdOrganizacion = :Old_IdOrganizacion')
    SQLRefresh.Strings = (
      
        'SELECT IdOrganizacion, RazonSocial, Direccion, Ciudad, IdPais, T' +
        'elefono1, Telefono2, Fax1, Fax2, Email, Website, Logotipo, Metod' +
        'oCosteo, RepresentanteContrato, RUC FROM Sistema.Organizacion'
      'WHERE'
      '  IdOrganizacion = :IdOrganizacion')
    SQLLock.Strings = (
      'SELECT * FROM Sistema.Organizacion'
      'WITH (UPDLOCK, ROWLOCK, HOLDLOCK)'
      'WHERE'
      '  IdOrganizacion = :Old_IdOrganizacion')
    SQLRecCount.Strings = (
      'SET :PCOUNT = (SELECT COUNT(*) FROM Sistema.Organizacion'
      ')')
    Connection = DMPrincipal.MSConnection
    SQL.Strings = (
      '  SELECT * FROM Sistema.Organizacion'
      'WHERE'
      'IdOrganizacion = 1')
    AfterOpen = MSOrganizacionAfterOpen
    BeforeInsert = MSOrganizacionBeforeInsert
    BeforeEdit = MSOrganizacionBeforeEdit
    BeforePost = MSOrganizacionBeforePost
    AfterPost = MSOrganizacionAfterPost
    AfterCancel = MSOrganizacionAfterCancel
    Left = 48
    Top = 24
    object MSOrganizacionIdOrganizacion: TIntegerField
      FieldName = 'IdOrganizacion'
    end
    object MSOrganizacionRazonSocial: TStringField
      FieldName = 'RazonSocial'
      Size = 100
    end
    object MSOrganizacionDireccion: TStringField
      FieldName = 'Direccion'
      Size = 200
    end
    object MSOrganizacionCiudad: TStringField
      FieldName = 'Ciudad'
      Size = 50
    end
    object MSOrganizacionIdPais: TIntegerField
      FieldName = 'IdPais'
    end
    object MSOrganizacionTelefono1: TStringField
      FieldName = 'Telefono1'
    end
    object MSOrganizacionTelefono2: TStringField
      FieldName = 'Telefono2'
    end
    object MSOrganizacionFax1: TStringField
      FieldName = 'Fax1'
    end
    object MSOrganizacionFax2: TStringField
      FieldName = 'Fax2'
    end
    object MSOrganizacionEmail: TStringField
      FieldName = 'Email'
      Size = 50
    end
    object MSOrganizacionWebsite: TStringField
      FieldName = 'Website'
      Size = 50
    end
    object MSOrganizacionLogotipo: TBlobField
      FieldName = 'Logotipo'
    end
    object MSOrganizacionMetodoCosteo: TSmallintField
      FieldName = 'MetodoCosteo'
    end
    object MSOrganizacionRepresentanteContrato: TStringField
      FieldName = 'RepresentanteContrato'
      Size = 50
    end
    object MSOrganizacionRUC: TStringField
      FieldName = 'RUC'
      Size = 30
    end
  end
  object DSOrganizacion: TDataSource
    DataSet = MSOrganizacion
    Left = 48
    Top = 76
  end
  object DSPais: TDataSource
    DataSet = MSPais
    Left = 146
    Top = 90
  end
  object MSPais: TMSQuery
    SQLRefresh.Strings = (
      'SELECT IdPais, Nombre FROM Sistema.Pais'
      'WHERE'
      '  IdPais = :IdPais')
    Connection = DMPrincipal.MSConnection
    SQL.Strings = (
      'SELECT'
      'IdPais,'
      'Nombre,'
      'Gentilicio = ISNULL(GentilicioMasculino, Nombre)'
      'FROM '
      'Sistema.Pais'
      'ORDER BY Nombre')
    IndexFieldNames = 'Nombre'
    Left = 147
    Top = 36
    object MSPaisIdPais: TIntegerField
      FieldName = 'IdPais'
    end
    object MSPaisNombre: TStringField
      FieldName = 'Nombre'
      Size = 30
    end
    object MSPaisGentilicio: TStringField
      FieldName = 'Gentilicio'
      ReadOnly = True
      Size = 50
    end
  end
  object VTOrganizacionLogo: TVirtualTable
    FieldDefs = <
      item
        Name = 'LogoBMP'
        DataType = ftBlob
      end>
    Left = 67
    Top = 222
    Data = {0400010007004C6F676F424D500F00000000000000000000000000}
    object VTOrganizacionLogoLogoBMP: TBlobField
      FieldName = 'LogoBMP'
    end
  end
  object DSOrganizacionLogo: TDataSource
    DataSet = VTOrganizacionLogo
    Left = 67
    Top = 278
  end
  object MSOrganizacionLogo: TMSQuery
    SQLInsert.Strings = (
      'INSERT INTO Sistema.Organizacion'
      '  (IdOrganizacion, Logotipo)'
      'VALUES'
      '  (:IdOrganizacion, :Logotipo)')
    SQLDelete.Strings = (
      'DELETE FROM Sistema.Organizacion'
      'WHERE'
      '  IdOrganizacion = :Old_IdOrganizacion')
    SQLUpdate.Strings = (
      'UPDATE Sistema.Organizacion'
      'SET'
      '  IdOrganizacion = :IdOrganizacion, Logotipo = :Logotipo'
      'WHERE'
      '  IdOrganizacion = :Old_IdOrganizacion')
    SQLRefresh.Strings = (
      'SELECT IdOrganizacion, Logotipo FROM Sistema.Organizacion'
      'WHERE'
      '  IdOrganizacion = :IdOrganizacion')
    SQLLock.Strings = (
      'SELECT * FROM Sistema.Organizacion'
      'WITH (UPDLOCK, ROWLOCK, HOLDLOCK)'
      'WHERE'
      '  IdOrganizacion = :Old_IdOrganizacion')
    SQLRecCount.Strings = (
      'SET :PCOUNT = (SELECT COUNT(*) FROM Sistema.Organizacion'
      ')')
    Connection = DMPrincipal.MSConnection
    SQL.Strings = (
      'SELECT '
      'Logotipo '
      'FROM Sistema.Organizacion'
      'WHERE'
      'IdOrganizacion = :IdOrganizacion ')
    AfterPost = MSOrganizacionLogoAfterPost
    Left = 68
    Top = 168
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'IdOrganizacion'
        Value = nil
      end>
    object MSOrganizacionLogoLogotipo: TBlobField
      FieldName = 'Logotipo'
    end
  end
end
