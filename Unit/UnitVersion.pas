unit UnitVersion;
{$INCLUDE 'compilador.inc'}
interface

uses
  Winapi.Windows, System.SysUtils;
 function ObtenerVersionApp(): string;
implementation
function ObtenerVersionApp(): string;
{$IFDEF MSWINDOWS}
var
  Exe: string;
  Size, Handle: DWORD;
  Buffer: TBytes;
  FixedPtr: PVSFixedFileInfo;
{$ENDIF}
  begin
    // Para todos los otros casos
       Exe := ParamStr(0);
       Size := GetFileVersionInfoSize(PChar(Exe), Handle);

        if Size = 0 then
          RaiseLastOSError;
        SetLength(Buffer, Size);

        if not GetFileVersionInfo(PChar(Exe), Handle, Size, Buffer) then
          RaiseLastOSError;

        if not VerQueryValue(Buffer, '\', Pointer(FixedPtr), Size) then
          RaiseLastOSError;

        Result := Format('%d.%d.%d',
          [LongRec(FixedPtr.dwFileVersionMS).Hi,  //major
           LongRec(FixedPtr.dwFileVersionMS).Lo,  //minor
           LongRec(FixedPtr.dwFileVersionLS).Hi]);  //release
  end;

end.
