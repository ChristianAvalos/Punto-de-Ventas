object DMComunUsuario: TDMComunUsuario
  Height = 356
  Width = 594
  object VTMenu: TVirtualTable
    FilterOptions = [foCaseInsensitive]
    IndexFieldNames = 'IdMenuPadre, IdMenu'
    FieldDefs = <
      item
        Name = 'Permitido'
        DataType = ftBoolean
      end
      item
        Name = 'IdMenu'
        DataType = ftString
        Size = 5
      end
      item
        Name = 'IdMenuPadre'
        DataType = ftString
        Size = 5
      end
      item
        Name = 'ObjetoComponente'
        DataType = ftString
        Size = 250
      end
      item
        Name = 'Caption'
        DataType = ftString
        Size = 250
      end
      item
        Name = 'SoportaTipoAcceso'
        DataType = ftBoolean
      end
      item
        Name = 'TipoAcceso'
        DataType = ftString
        Size = 30
      end
      item
        Name = 'TipoComponente'
        DataType = ftString
        Size = 30
      end
      item
        Name = 'ObjetosHijos'
        DataType = ftInteger
      end
      item
        Name = 'Nivel'
        DataType = ftInteger
      end
      item
        Name = 'Control'
        DataType = ftBoolean
      end
      item
        Name = 'ControlesHijos'
        DataType = ftInteger
      end
      item
        Name = 'ControlesHijosPermitido'
        DataType = ftInteger
      end>
    AfterPost = VTMenuAfterPost
    OnCalcFields = VTMenuCalcFields
    Left = 39
    Top = 31
    Data = {
      04000D0009005065726D697469646F0500000000000000060049644D656E7501
      000500000000000B0049644D656E755061647265010005000000000010004F62
      6A65746F436F6D706F6E656E74650100FA0000000000070043617074696F6E01
      00FA00000000001100536F706F7274615469706F41636365736F050000000000
      00000A005469706F41636365736F01001E00000000000E005469706F436F6D70
      6F6E656E746501001E00000000000C004F626A65746F7348696A6F7303000000
      0000000005004E6976656C03000000000000000700436F6E74726F6C05000000
      000000000E00436F6E74726F6C657348696A6F7303000000000000001700436F
      6E74726F6C657348696A6F735065726D697469646F0300000000000000000000
      000000}
    object VTMenuPermitido: TBooleanField
      FieldName = 'Permitido'
    end
    object VTMenuIdMenu: TStringField
      FieldName = 'IdMenu'
      Size = 5
    end
    object VTMenuIdMenuPadre: TStringField
      FieldName = 'IdMenuPadre'
      Size = 5
    end
    object VTMenuObjetoComponente: TStringField
      FieldName = 'ObjetoComponente'
      Size = 250
    end
    object VTMenuCaption: TStringField
      FieldName = 'Caption'
      Size = 250
    end
    object VTMenuSoportaTipoAcceso: TBooleanField
      FieldName = 'SoportaTipoAcceso'
    end
    object VTMenuTipoAcceso: TStringField
      FieldName = 'TipoAcceso'
      Size = 30
    end
    object VTMenuTipoComponente: TStringField
      FieldName = 'TipoComponente'
      Size = 30
    end
    object VTMenuObjetosHijos: TIntegerField
      FieldName = 'ObjetosHijos'
    end
    object VTMenuNivel: TIntegerField
      FieldName = 'Nivel'
    end
    object VTMenuControl: TBooleanField
      FieldName = 'Control'
    end
    object VTMenuControlesHijos: TIntegerField
      FieldName = 'ControlesHijos'
    end
    object VTMenuControlesHijosPermitido: TIntegerField
      FieldName = 'ControlesHijosPermitido'
    end
    object VTMenuIcono: TStringField
      FieldKind = fkCalculated
      FieldName = 'Icono'
      Size = 1
      Calculated = True
    end
  end
  object DSMenu: TDataSource
    DataSet = VTMenu
    Left = 41
    Top = 87
  end
  object VTAux: TVirtualTable
    Left = 119
    Top = 30
    Data = {04000000000000000000}
  end
  object VTControl: TVirtualTable
    FieldDefs = <
      item
        Name = 'ObjetoComponente'
        DataType = ftString
        Size = 250
      end
      item
        Name = 'Permitido'
        DataType = ftBoolean
      end
      item
        Name = 'TipoComponente'
        DataType = ftString
        Size = 30
      end>
    AfterPost = VTControlAfterPost
    OnCalcFields = VTControlCalcFields
    Left = 189
    Top = 30
    Data = {
      0400030010004F626A65746F436F6D706F6E656E74650100FA00000000000900
      5065726D697469646F05000000000000000E005469706F436F6D706F6E656E74
      6501001E0000000000000000000000}
    object VTControlObjetoComponente: TStringField
      FieldName = 'ObjetoComponente'
      Size = 250
    end
    object VTControlPermitido: TBooleanField
      FieldName = 'Permitido'
    end
    object VTControlTipoComponente: TStringField
      FieldName = 'TipoComponente'
      Size = 30
    end
    object VTControlObjetosHijos: TIntegerField
      FieldKind = fkCalculated
      FieldName = 'ObjetosHijos'
      Calculated = True
    end
    object VTControlIdMenuPadre: TStringField
      FieldKind = fkCalculated
      FieldName = 'IdMenuPadre'
      Size = 5
      Calculated = True
    end
    object VTControlTipoAcceso: TStringField
      FieldKind = fkCalculated
      FieldName = 'TipoAcceso'
      Size = 30
      Calculated = True
    end
  end
  object DSControl: TDataSource
    DataSet = VTControl
    Left = 189
    Top = 81
  end
  object VTUsuario: TVirtualTable
    Left = 452
    Top = 27
    Data = {04000000000000000000}
    object VTUsuarioIdUsuario: TIntegerField
      FieldName = 'IdUsuario'
    end
  end
  object VTBotonAux: TVirtualTable
    AutoCalcFields = False
    FieldDefs = <
      item
        Name = 'ObjetoComponente'
        DataType = ftString
        Size = 250
      end
      item
        Name = 'Permitido'
        DataType = ftBoolean
      end
      item
        Name = 'TipoComponente'
        DataType = ftString
        Size = 30
      end>
    AfterPost = VTControlAfterPost
    OnCalcFields = VTControlCalcFields
    Left = 290
    Top = 29
    Data = {
      0400030010004F626A65746F436F6D706F6E656E74650100FA00000000000900
      5065726D697469646F05000000000000000E005469706F436F6D706F6E656E74
      6501001E0000000000000000000000}
    object VTBotonAuxObjetoComponente: TStringField
      FieldName = 'ObjetoComponente'
      Size = 250
    end
    object VTBotonAuxPermitido: TBooleanField
      FieldName = 'Permitido'
    end
    object VTBotonAuxTipoComponente: TStringField
      FieldName = 'TipoComponente'
      Size = 30
    end
    object VTBotonAuxObjetosHijos: TIntegerField
      FieldName = 'ObjetosHijos'
    end
    object VTBotonAuxIdMenuPadre: TStringField
      FieldName = 'IdMenuPadre'
      Size = 5
    end
    object VTBotonAuxTipoAcceso: TStringField
      FieldName = 'TipoAcceso'
      Size = 30
    end
  end
  object DSRol: TDataSource
    DataSet = MSRol
    Left = 48
    Top = 248
  end
  object MSRol: TMSQuery
    Connection = DMPrincipal.MSConnection
    SQL.Strings = (
      'SELECT IdRol,'
      '       Descripcion'
      '  FROM Usuario.Rol;')
    Left = 48
    Top = 200
    object MSRolIdRol: TIntegerField
      FieldName = 'IdRol'
      ReadOnly = True
    end
    object MSRolDescripcion: TStringField
      FieldName = 'Descripcion'
      Size = 50
    end
  end
  object MSUsuario: TMSQuery
    Connection = DMPrincipal.MSConnection
    SQL.Strings = (
      'SELECT IdUsuario,'
      '       NombreUsuario'
      '  FROM Usuario.Usuario'
      ' WHERE IdOrganizacion = :IdOrganizacion')
    BeforeOpen = MSUsuarioBeforeOpen
    Left = 112
    Top = 208
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'IdOrganizacion'
        Value = nil
      end>
    object MSUsuarioIdUsuario: TIntegerField
      FieldName = 'IdUsuario'
      ReadOnly = True
    end
    object MSUsuarioNombreUsuario: TStringField
      FieldName = 'NombreUsuario'
    end
  end
  object MSModulo: TMSQuery
    Connection = DMPrincipal.MSConnection
    SQL.Strings = (
      'SELECT IdModulo,'
      '       Descripcion'
      '  FROM Usuario.Modulo;')
    Left = 176
    Top = 208
    object MSModuloIdModulo: TIntegerField
      FieldName = 'IdModulo'
      ReadOnly = True
    end
    object MSModuloDescripcion: TStringField
      FieldName = 'Descripcion'
      Size = 50
    end
  end
  object DSUsuario: TDataSource
    DataSet = MSUsuario
    Left = 112
    Top = 264
  end
  object DSModulo: TDataSource
    DataSet = MSModulo
    Left = 176
    Top = 264
  end
end
