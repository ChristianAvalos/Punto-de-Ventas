
unit UnitSoporte;

{$INCLUDE 'compilador.inc'}

interface

uses
  Winapi.Windows, System.Classes, Vcl.Forms, System.TypInfo, Vcl.Controls,
  Vcl.Graphics, System.StrUtils, System.IOUtils, System.Math, Data.DB,
  System.DateUtils, System.Generics.Defaults, System.Generics.Collections,

  {$IFDEF WEB}
  MainModule, ServerModule, UniGuiApplication, Main, uniFileUpload,
  uniGUIForm, uniDBMemo,uniDBGrid, uniDBCheckBox, uniLabel, uniMenuButton,
  uniGUITypes, uniGUIAbstractClasses, uniGUIClasses, uniGUICoreInterfaces,
  {$ENDIF}

  Rtti, System.SysUtils;

type
  TObjeto = record
    Formulario: TUniForm;
    Dataset: TDataSet;
  end;

  // El diccionario de Formulario / Dataset
  var Diccionario: TDictionary<string, TObjeto>;

  procedure EventoAjax(Sender: TObject; Formulario: TUniForm; EventName: string; Params: TUniStrings);
  procedure AgregarBotonSoporte(Formulario: TUniForm);
  procedure AgregarObjeto(Formulario: TUniForm; Dataset: TDataSet);

implementation

//uses
//  FormularioJiraReportarIncidencia, DataModuleReporte, DataModuleExportacionDatos, UnitCodigosComunes;


procedure EventoAjax(Sender: TObject; Formulario: TUniForm; EventName: string; Params: TUniStrings);
var
  i: integer;
  ArregloDataset: TArray<TDataset>;
  AuxDataset: TDataset;
  Indice: Integer;
  AuxObjeto: TObjeto;
begin
  if SameText(EventName,'soporte') then
  begin
    // Ejecuto el boton
    UniSession.AddJS(Formulario.WebForm.JSWindow.JSName+'.unmask();');

    // Ejecuto el comando de screen via javascript
    with Formulario.WebForm do
    begin
      JSInterface.JSCode('html2canvas(document.querySelector("#' + JSId +'")).then(function(canvas) {ajaxRequest('#1', "getData", ["base64Data="+canvas.toDataURL()])});');
    end;

    // Envio archivos adjuntos
    for i := 0 to Formulario.ComponentCount - 1 do
    begin

      // En caso que soporte databinding
      if Supports(Formulario.Components[i], IUniDBControl) then
      begin

        // Si esta asignado el datasource
        if Assigned((Formulario.Components[i] as IUniDBControl).DataSource) = True then
        begin
          // Guardo un dataset auxiliar
          AuxDataset := (Formulario.Components[i] as IUniDBControl).DataSource.Dataset;

          // Busco en el arreglo, si hay no existe continuo
          if TArray.BinarySearch<TDataset>(ArregloDataset, AuxDataset, Indice) = False then
          begin

            // Solo el si dataset esta activo
            if AuxDataset.Active = True then
            begin
              SetLength(ArregloDataset, Length(ArregloDataset) + 1);
              ArregloDataset[High(ArregloDataset)] := AuxDataset;
            end;

          end;

        end;

      end
      else
        begin

          // Dependiendo del tipo de componente
          case IndexStr(Formulario.Components[i].ClassName, [TUniFileUpload.ClassName, TUniDBGrid.ClassName]) of

            0: //TUniFileUpload
            begin
              // En caso sea agregado con exito el upload del archivo
              if TUniFileUpload(Formulario.Components[i]).Files[0].Success = True then
              begin
                // Agrego el archivo
//                FrmJiraReportarIncidencia.AgregatAdjunto(TUniFileUpload(Formulario.Components[i]).Files[0].OriginalFileName,
//                                                         TUniFileUpload(Formulario.Components[i]).Files[0].CacheFile);
              end;
            end;

            1: // TUniDBGrid
            begin
              // Si esta asignado el datasource del componente
              if Assigned(TUniDBGrid(Formulario.Components[i]).DataSource) = True then
              begin

                // En caso que el dataset se encuentre activo
                if TUniDBGrid(Formulario.Components[i]).DataSource.DataSet.Active = True then
                begin
                  // Agrego al arreglo del dataset
                  SetLength(ArregloDataset, Length(ArregloDataset) + 1);
                  ArregloDataset[High(ArregloDataset)] := TUniDBGrid(Formulario.Components[i]).DataSource.DataSet;
                end;

              end;
            end;

          end;

        end;

    end;

    // En caso que el enviado se haya hecho de la vista previa
    if Formulario.Name = 'FrmVistaPrevia' then
    begin
//      FrmJiraReportarIncidencia.AgregatAdjunto(
//        Trim(DMExportacionDatos.ReporteExportar.ReportOptions.Name) + '-' + ObtenerFecha + '.pdf',
//        DMReporte.frxPDFExport.FileName);

      // En caso que haya dataset para exportar
//      if DMExportacionDatos.DatasetExportar <> nil then
//      begin
//        FrmJiraReportarIncidencia.AgregarDataset(DMExportacionDatos.DatasetExportar);
//      end;
    end;


    // si el diccionario tiene datos
    if Diccionario <> nil then
    begin {adan le puse mientras,by Dario}
      if Diccionario.Count > 0 then
      begin

        // Recorro la lista
        for AuxObjeto in Diccionario.Values do
        begin

          // Si coincide con el formulario
          if AuxObjeto.Formulario = Formulario then
          begin
            // Inserto en el arreglo, que luego sera enviado al reporteador de jira
            Insert(AuxObjeto.Dataset, ArregloDataset, High(ArregloDataset));
          end;
        end;

      end;
    end;

    // Envio los dataset de controles
   // FrmJiraReportarIncidencia.AgregarDataset(ArregloDataset);

    // Muestro la pantalla de reportar a jira
//    FrmJiraReportarIncidencia.EnviadoDesdeFrm := Formulario.Name;
//    FrmJiraReportarIncidencia.ShowModal();
  end;

  // Obtengo el screen capturado
  if EventName = 'getData' then
  begin
  //  FrmJiraReportarIncidencia.Screenshot := Params.Values['base64Data'];
  end;

end;


procedure AgregarBotonSoporte(Formulario: TUniForm);
var
  EventoJs: string;
begin
  // Creo el evento para el javascript
  EventoJs := 'function window.afterCreate(sender){sender.addTool([{'+
       'xtype: ''button'','+
       'text: ''Soporte'','+
       'icon: ''files/Support.png'','+
       'iconCls: ''myicon'','+
       'handler:function(){'+
       'this.up(''window'').mask(''Aguarde...'');'+
       'ajaxRequest(this.up(''window''),''soporte'',[]);'+
       '}}]);}';

  // Agrego al formulario
  Formulario.ClientEvents.UniEvents.Values['window.afterCreate'] := EventoJs;
end;


procedure AgregarObjeto(Formulario: TUniForm; Dataset: TDataSet);
var
  AuxObjeto: TObjeto;
begin
  // Creo el diccionario
  //if Diccionario <> nil then
  begin
    Diccionario := TDictionary<string, TObjeto>.Create;
  end;

  // Asigno los valores al AuxObjeto
  AuxObjeto.Formulario := Formulario;
  AuxObjeto.Dataset := Dataset;

  // Siempre y cuando este objeto no se encuentre aun
  if Diccionario.ContainsValue(AuxObjeto) = False then
  begin
    // Agrego al diccionario
    Diccionario.Add(Dataset.Owner.Name + '.' + Dataset.Name, AuxObjeto);
  end;

end;

end.
