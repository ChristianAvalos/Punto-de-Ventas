unit UnitRecursoString;
{$INCLUDE 'compilador.inc'}
interface
resourcestring
  // =============================================================================//
  // INICIO DE SESION
  // Operaciones con usuarios (Login y Validaciones)
  EEscribaNombreUsuario = 'Escriba un nombre de usuario';
  EEscribaTextoCaptcha = 'Escriba el texto del captcha';
  ETextoCaptchaIncorrecto = 'El texto del captcha es incorrecto';

  EEscribaPIN = 'Escriba su PIN';
  EEscribaPINActual = 'Escriba su PIN actual';
  EEscribaPINRepetir = 'Escriba su PIN nuevo';
  EPINNOCoincide = 'PIN no coincide';
  EPINActualIncorrecto = 'PIN actual incorrecto';

  EEscribaContrasena = 'Escriba una contrase?a';
  EPasswordNoCoincide = 'Las contrase?as no coinciden';
  EPasswordActualNoCoincide = 'La contrase?a actual es incorrecta';
  EPasswordCambiadoExito = 'Contrase?a cambiado con ?xito';

  EContrasenaoUsuarioIncorrecta = 'Usuario o Contrase?a incorrecta';
  EContrasenaMedianteLDAP = 'La contrase?a debe cambiarse mediante LDAP / AD';
  EAutoservicioMedianteLDAP = 'El autoservicio se autentica mediante LDAP / AD';
  ESoloPuedeCambiarContrasenaUsuarioActivo = 'S?lo se puede cambiar contrase?a de usuarios activos';
  ENoExistenUsuariosDefinidos = 'No existen usuarios definidos. Valores predeterminados fueron insertados.';
  EFuncionalidadNoAdmitePermisos = 'Esta funcionalidad no admite permisos';
  ESeleccioneUsuario = 'Seleccione un usuario';
  EUsuarioCreado = 'Se creo correctamente el usuario';
  EUsuarioBorrado = 'Se elimino correctamente el usuario';
  EIPNovalido = 'Escriba una IP v?lida';
  ENoPuedeAccederAlmacen = 'No posee acceso a este almac?n';
  EUsuarioInvalidoNoExiste = 'No existe Usuario o es inv?lido';
  EExistenPermisosDeseaSobreescribirlos = 'Existen permisos existentes, ?Desea sobre escribirlos?';
  EUsuarioYaExiste = 'El usuario ya existe';
  EExistePersonalDocumento = 'Ya existe un personal con ese N?mero de Documento';
  EExistePersonalLegajoNro = 'Ya existe un personal con ese N?mero de Legajo';
  EUsuarioCaracterInvalido = 'El nombre de usuario no puede tener caracteres especiales';
  ESeleccioneRol = 'Seleccione el Rol del usuario';
  ESeleccioneModulo = 'Seleccione el m?dulo';
  EEscribaPass = 'Escriba la contrase?a';
  ESeleccioneFecha = 'Seleccione Fecha';
  EDeseaCancelarOperacion = 'Desea cancelar la operaci?n';
  EErrorEliminarDatosRelacionados ='Eliminar datos relacionados';
  ENoExistenDatos = 'No existen datos';
  ETransaccionAnulado = 'Transaccion anulada';
  ETransaccionFiniquitada = 'Transaccion finiquitada';
  EErrorFormatoNumeroDocumento = 'Error formato de documento';
  EExcepcion = 'Excepci?n';
  EErrorAsignarCampoIdOrganizacionDataset = 'Erro al asignar IdOrganizacion';
  EEscribaRazonSocial = 'Escriba la razon social';
  ESeleccionePais = 'Seleccione pais';
  EModoNoEidicion = 'No encuentra en modo de Edici?n';
  EBorrarRegistro = 'Borrar Registro';
  ESeleccioneTipoCondicionPago = 'Seleccione el tipo de pago';
  EEscribaDescripcion = 'Escriba la descripci?n';
  ERegistroEdicion = 'Registro editado';
  ERegistroGuardado = 'Registro guardado';
  EEscribaParametroBusqueda = 'Escriba par?metro de b?squeda';
  EExcepcionSoloAceptaNumeros = 'Este par?metro solo acepta n?meros enteros';
  EExcepcionParametroInvalido = 'Par?metro inv?lido';
  ENoExistenRegistrosBusqueda = 'No existe registro en la b?squeda';
  EDataSetEdicion = 'El DataSet se encuentra en edici?n';
  ENoHayRegistroSeleccionadoBusqueda = 'No hay registro seleccionado en la b?squeda';
  ESeleccioneMoneda = 'Escriba el tipo de moneda';

    // MIME
  EMimeTIFF = 'image/tiff';
  EMimePDF = 'application/pdf';
  EMimeDOC = 'application/msword';
  EMimeDOCX = 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
  EMimeXLS = 'application/vnd.ms-excel';
  EMimeXLSX = 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';
  EMimeJPG = 'image/jpeg';
  EMimeDBF = 'application/dbf';
  EMimePFX = 'application/x-pkcs12';
  EMimeCRT = 'application/x-x509-user-cert';
  EMimeKEY = 'application/pkcs8';


implementation

end.
