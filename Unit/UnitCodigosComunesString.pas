

unit UnitCodigosComunesString;

{$INCLUDE 'compilador.inc'}

interface

uses
  System.Variants, System.Math, System.RegularExpressions, System.Types, Data.DB,

  {$IFDEF WEB}
    UniListBox, UniDBGrid,
  {$ENDIF}
   System.StrUtils, System.Classes, System.SysUtils;

type
  TBooleanWordType = (bwTrue, bwYes, bwOn, bwEnabled, bwSuccessful, bwOK, bwBinary, bwSi);
  TCharSet = set of Char;

  TByteStringFormat = (bsfDefault, bsfBytes, bsfKB, bsfMB, bsfGB, bsfTB);

const
  ColorRequerido = $009BFFFF;
  ComillaSimple = Char(39);

const
  OneKB = 1024;
  OneMB = OneKB * OneKB;
  OneGB = OneKB * OneMB;
  OneTB = OneKB * OneMB; //--> se debe poner un tipo de dato mayor


function ExisteInt(Texto: String): Boolean;
function ExisteNumero(Texto: String): Boolean;
function ExisteDate(Texto: String): Boolean;
function ExisteDateTime(Texto: String): Boolean;
function Stripped(stripchar: char; str: string): string;
function Capitalize(str: string): string;
function QuitarFormatoNumerico(str: string): string;
function SacarEspacioFinal(Cadena: string): string;
function AddLeadingZeroes(const aNumber, Length: integer): string;
function QuitarSaltosLinea(Strs: TStrings): String; overload
function QuitarSaltosLinea(Strs: string): String;  overload;
function QuitarEspeciales(const Cad: string): string;
function StripNonConforming(const S: string; const ValidChars: TCharSet): string;
function StripNonNumeric(const S: string): string;
function HasDigit(const value: string): Boolean;
function FormatByteString(Bytes: UInt64; Format: TByteStringFormat = bsfDefault): string;
function StringToDateTime(const Value: String): TDateTime;

function BuscarIndexTStrings(Strs: TStrings; TextBuscar: string): Integer;
function ExtractAlpha(const S: String): String;
function ContarOcurrencias(const Cadena, Texto: String): Integer;
function StrippedOfNonAscii(const s: string): string;
function ExtractNumberInString(sChaine: String): String;
function Rspace(Atext:string; Long:integer; Spac:char = ' '): String;
function CompletarEspacio(Campo: TField; Tipo: string = 'inicio'): string;

{$IFDEF MSWINDOWS}
function OStripAccents(const aStr: String): String;
function String2Hex(const Buffer: Ansistring): string;
{$ENDIF}

procedure BorrarElementoArray(var A: TStringDynArray; const Index: Cardinal);
function StrInArray(Value: String; ArrayOfString: TArray<string>): Boolean;
function StrInList(Value: String; StringList: TStringList): Boolean;

{$IFDEF WEB}
function StrInListBox(Value: String; StringList: TUniListBox): Boolean;
{$ENDIF}
function QuitarComaFinal(str: string): string;
function AgregarComillasEntreComas(str: string): string;
function AgregarComillasyPorcentajeEntreComas(str: string): string;
function CadenaAleatoria(Largo: integer): string;
function TextoAleatorio(Largo: integer): string;
function GenerateRandomNumber(leng: Integer): Integer;

function ObtenerFecha: string;
function CalcularEdad(FechaNacimiento, FechaActual: TDate): Integer;

function ValueIn(Value: Integer; const Values: array of Integer): Boolean;
function IfNull(const Value, Default : OleVariant ): OleVariant;
function IfNullStr(const Value, Default : OleVariant ): OleVariant;

function BoolToStr(AValue: boolean; ABooleanWordType: TBooleanWordType = bwTrue): string;
function CaracteresASCIIEstandar(s: string): Boolean;
function NumeroTextoOrden(Numero: integer): string;
function NumberToString(number: Integer): String;

function ObtenerCalificacion(Puntaje: Integer): Integer;

function OleVariantToString(const Value: OleVariant): string;
function ExtractText(const Str: string; const Delim1, Delim2: string): string;
function ExtraerPesoVolumen(const s: string): string;
function EditDistance(s, t: string): integer;
function StripHTML(S: string): string;


implementation


const
   BooleanWord: array [boolean, TBooleanWordType] of string =
      (
       ('False', 'No',  'Off', 'Disabled', 'Failed',     'Cancel', '0', 'No'),
       ('True',  'Yes', 'On',  'Enabled',  'Successful', 'OK',     '1', 'S?')
      );


function ObtenerFecha: String;
var
  anho, mes, dia, hora, minuto, segundo, ms: word;
begin
  // Mover esto a codigos comunes
  DecodeDate(Now, anho, mes, dia);
  DecodeTime(Now, hora, minuto, segundo, ms);
  Result := IntToStr(anho) + FormatFloat('00', mes) + FormatFloat('00', dia) + '-' + FormatFloat('00', hora) + FormatFloat('00', minuto) + FormatFloat('00', segundo);
end;


function CalcularEdad(FechaNacimiento, FechaActual: TDate): Integer;
var
  Month, Day, Year, CurrentYear, CurrentMonth, CurrentDay: Word;
begin
  DecodeDate(FechaNacimiento, Year, Month, Day);
  DecodeDate(FechaActual, CurrentYear, CurrentMonth, CurrentDay);
  if (Year = CurrentYear) and (Month = CurrentMonth) and (Day = CurrentDay) then
  begin
    Result := 0;
  end
  else
    begin
      Result := CurrentYear - Year;
      if (Month > CurrentMonth) then
        Dec(Result)
      else
      begin
        if Month = CurrentMonth then
          if (Day > CurrentDay) then
            Dec(Result);
      end;
    end;
end;


{$IFDEF WEB}
function StrInListBox(Value: String; StringList: TUniListBox): Boolean;
var
 Loop : String;
begin
  for Loop in StringList.Items do
  begin
    if Value = Loop then
    begin
       Exit(true);
    end;
  end;
  result := false;
end;
{$ENDIF}


function StrInList(Value: String; StringList: TStringList): Boolean;
var
 Loop : String;
begin
  for Loop in StringList do
  begin
    if Value = Loop then
    begin
       Exit(true);
    end;
  end;
  result := false;
end;


function StrInArray(Value: String; ArrayOfString: TArray<string>): Boolean;
var
 Loop : String;
begin
  for Loop in ArrayOfString do
  begin
    if Value = Loop then
    begin
       Exit(true);
    end;
  end;
  result := false;
end;


procedure BorrarElementoArray(var A: TStringDynArray; const Index: Cardinal);
var
  ALength: Cardinal;
  TailElements: Cardinal;
begin
  ALength := Length(A);
  Assert(ALength > 0);
  Assert(Index < ALength);
  Finalize(A[Index]);
  TailElements := ALength - Index;
  if TailElements > 0 then
    Move(A[Index + 1], A[Index], SizeOf(string) * TailElements);
  Initialize(A[ALength - 1]);
  SetLength(A, ALength - 1);
end;


function ExtractAlpha(const S: String): String;
const
  Digits = ['A' .. 'Z', 'a' .. 'z'];
var
  i: integer;
begin
  Result := '';
  for i := 1 to Length(S) do
    if S[i] in Digits then
      Result := Result + S[i];
end;


function ExisteInt(Texto: String): Boolean;
{ Testa se em uma string existe um numero inteiro valido ou n?o }
var
  i: integer;
begin
  try
    i := StrToInt(Texto);
    Result := True;
  except
    Result := False;
  end;
end;


function ExisteNumero(Texto: String): Boolean;
{ Testa se em uma string existe um numero inteiro valido ou n?o }
var
  i: Double;
begin
  try
    i := StrToFloat(Texto);
    Result := True;
  except
    Result := False;
  end;
end;


function ExisteDate(Texto: String): Boolean;
{ Testa se em uma string existe um numero inteiro valido ou n?o }
var
  i: TDate;
begin
  try
    i := StrToDate(Texto);
    Result := True;
  except
    Result := False;
  end;
end;


function ExisteDateTime(Texto: String): Boolean;
{ Testa se em uma string existe um numero inteiro valido ou n?o }
var
  i: TDateTime;
begin
  try
    i := StrToDateTime(Texto);
    Result := True;
  except
    Result := False;
  end;
end;


function Stripped(stripchar: char; str: string): string;
var
  tmpstr: string;
begin
  // Esta funcion elminina un careacter de un string determinado
  tmpstr := str;
  while pos(stripchar, tmpstr) > 0 do
    Delete(tmpstr, pos(stripchar, tmpstr), 1);
  Stripped := tmpstr;
end;


function Capitalize(str: string): string;
var
  Index: Cardinal;
begin
  for Index := 1 to Length(str) do
    if (Index = 1) or (str[Index - 1] = ' ') then
      if str[Index] in ['a' .. 'z', '?', '?', '?', '?', '?', '?','.'] then
        Dec(str[Index], 32)
      else
    else
      if str[Index] in ['A' .. 'Z', '?', '?', '?', '?', '?', '?','.'] then
      Inc(str[Index], 32);
  Result := str;
end;


function QuitarFormatoNumerico(str: string): string;
{var
  i: integer;
  aux, cad: string; }
begin
  Result := Stripped('.',str);
end;



function SacarEspacioFinal(Cadena: string): string;
begin
  Result := TrimRight(Cadena);
end;


function AddLeadingZeroes(const aNumber, Length: integer): string;
begin
  Result := Format('%.*d', [Length, aNumber]);
end;


function QuitarSaltosLinea(Strs: TStrings): String;
var
  str: string;
begin
  { :Elimina los saltos de l?nea (caracteres #10 y #13; salto de linea y salto de carro) de un TStrings. }
  str := AnsiReplaceStr(Strs.Text, #10, '');
  Result := AnsiReplaceStr(str, #13, ' ');
end;


function QuitarSaltosLinea(Strs: String): String;
var
  str: string;
begin
  { :Elimina los saltos de l?nea (caracteres #10 y #13; salto de linea y salto de carro) de un TStrings. }
  str := AnsiReplaceStr(Strs, #10, '');
  Result := AnsiReplaceStr(str, #13, ' ');
end;


function QuitarEspeciales(const Cad: string): string;
const
  VALIDOS = [' ', '-', '0' .. '9', 'A' .. 'Z', 'a' .. 'z', '?', '?', '?', '?', '?', '?', '?'];
var
  i: integer;
begin
  Result := '';
  for i := 1 to Length(Cad) do
    if Cad[i] in VALIDOS then
      Result := Result + Cad[i]
end;


function StripNonConforming(const S: string; const ValidChars: TCharSet): string;
var
  DestI: Integer;
  SourceI: Integer;
begin
  SetLength(Result, Length(S));
  DestI := 0;
  for SourceI := 1 to Length(S) do
    if S[SourceI] in ValidChars then
    begin
      Inc(DestI);
      Result[DestI] := S[SourceI]
    end;
  SetLength(Result, DestI)
end;


function HasDigit(const value: string): Boolean;
var
  i: integer;
begin
  for i := 1 to length(value) do begin
    if value[i] in ['0'..'9'] then begin
      Result := True;
      Exit;
    end;
  end;
  Result := False;
end;


function FormatByteString(Bytes: UInt64; Format: TByteStringFormat = bsfDefault): string;
begin
  if Format = bsfDefault then begin
    if Bytes < OneKB then begin
      Format := bsfBytes;
    end
    else if Bytes < OneMB then begin
      Format := bsfKB;
    end
    else if Bytes < OneGB then begin
      Format := bsfMB;
    end
    else if Bytes < OneTB then begin
      Format := bsfGB;
    end
    else begin
      Format := bsfTB;
    end;
  end;

  case Format of
  bsfBytes:
    Result := System.SysUtils.Format('%d bytes', [Bytes]);
  bsfKB:
    Result := System.SysUtils.Format('%.1n KB', [Bytes / OneKB]);
  bsfMB:
    Result := System.SysUtils.Format('%.1n MB', [Bytes / OneMB]);
  bsfGB:
    Result := System.SysUtils.Format('%.1n GB', [Bytes / OneGB]);
  bsfTB:
    Result := System.SysUtils.Format('%.1n TB', [Bytes / OneTB]);
  end;
end;


function StringToDateTime(const Value: String): TDateTime;
var
  FormatSettings: TFormatSettings;
begin
  FormatSettings.DateSeparator := '-';
  FormatSettings.TimeSeparator := ':';
  FormatSettings.ShortDateFormat := 'yyyy-mm-dd hh:nn:ss';
  Result := StrToDateTimeDef(Value, Now(), FormatSettings);
end;


function StripNonNumeric(const S: string): string;
begin
  Result := StripNonConforming(S, ['0'..'9'])
end;



function BuscarIndexTStrings(Strs: TStrings;TextBuscar: string): Integer;
var
i : Integer;
begin

  Result := -1;

  for i := 0 to Strs.Count-1 do
  begin
    if ContainsText(Strs[i],TextBuscar) then
      begin
        Result := i;
      Exit;
    end;
  end;

end;


function ContarOcurrencias(const Cadena, Texto: String): Integer;
var
  Posicion, Cuenta: Integer;
begin
  Cuenta := 0;
  Posicion := PosEx(Cadena, Texto, 1);
  while 0 < Posicion do
  begin
    Inc(Cuenta);
    Posicion := PosEx(Cadena, Texto, Posicion + Length(Cadena));
  end;

  ContarOcurrencias := Cuenta;
end;


function StrippedOfNonAscii(const s: string): string;
var
  i, Count: Integer;
begin
  SetLength(Result, Length(s));
  Count := 0;
  for i := 1 to Length(s) do begin
    if ((s[i] >= #32) and (s[i] <= #127)) or (s[i] in [#10, #13]) then begin
      inc(Count);
      Result[Count] := s[i];
    end;
  end;
  SetLength(Result, Count);
end;


{$IFDEF MSWINDOWS}
function OStripAccents(const aStr: String): String;
type
  USASCIIString = type AnsiString(20127);//20127 = us ascii
begin
  Result := String(USASCIIString(aStr));
end;
{$ENDIF}


function AgregarComillasEntreComas(str: string): string;
var
  Din: TArray<string>;
  i: Integer;
  Resultado: string;
begin
  Din := str.Split([',']);


  if High(Din)>=0 then
  begin
    for i := 0 to High(Din) do
      begin
        if i = High(Din) then
          begin
            Resultado := Resultado +char(39)+ Trim(Din[i]) +char(39);
          end
          else
          begin
            Resultado := Resultado +char(39)+ Trim(Din[i]) +char(39) + ', ';
          end;
      end;
  end;

  Result := Resultado;

end;


function AgregarComillasyPorcentajeEntreComas(str: string): string;
var
  Din: TArray<string>;
  i: Integer;
  Resultado: string;
begin
  Din := str.Split([',']);

  if High(Din)>0 then
    begin
      for i := 0 to High(Din) do
        begin
          if i = High(Din) then
          begin
            Resultado := Resultado +char(39)+'%'+ Trim(Din[i]) +'%'+char(39);
          end
          else
            begin
              Resultado := Resultado +char(39)+'%'+ Trim(Din[i]) +'%'+char(39) + ', ';
            end;
        end;
    end;

  Result := Resultado;

end;


function QuitarComaFinal(str: string): string;
var
  position: Integer;
begin
  str := Trim(str);
  str := ReverseString(str);
  if Copy(str,1,1) = ',' then
    begin
      position := ansipos(',', str);
      str := copy(str, position,Length(str));
      str := Copy(str,2,Length(str));
    end;
  str := ReverseString(str);

  result := str;
end;



function CadenaAleatoria(Largo: integer): string;
var
  i:integer;
begin
  randomize;
  result := '';
  for i := 0 to Largo - 1 do
    begin
      case Random (7) of
        0:       result := result + Chr (ord ('0')+ random (1 + ord('9')-ord('0')) );
        1,2:     result := result + Chr (ord ('A')+ random (1 + ord('Z')-ord('A')) );
        3,4,5,6: result := result + Chr (ord ('a')+ random (1 + ord('z')-ord('a')) );
      end;
    end;
end;


function TextoAleatorio(Largo: integer): string;
var
  i:integer;
begin
  randomize;
  result := '';
  for i := 0 to Largo - 1 do
    begin
      case Random (7) of
        0,1,2:     result := result + Chr (ord ('A')+ random (1 + ord('Z')-ord('A')) );
        3,4,5,6: result := result + Chr (ord ('a')+ random (1 + ord('z')-ord('a')) );
      end;
    end;
end;


function ExtractNumberInString(sChaine: String): String;
var
  i: Integer;
begin
  Result := '' ;

  for i := 1 to length( sChaine ) do
  begin
    if sChaine[ i ] in ['0'..'9'] then
      Result := Result + sChaine[ i ] ;
  end;
end;


function Rspace(Atext:string; Long:integer; Spac:char = ' '): String;
var
  X:integer;
begin
  Atext := trim(Atext);
  if long < 0 then
    long := 0;
  x := long - Length(AText);
  Result:= StringOfChar(Spac, X) + Atext;
end;


function CompletarEspacio(Campo: TField; Tipo: string = 'inicio'): string;
var
  incremento, i: Integer;
begin
  if not(Campo.IsNull) then
  begin
    // Devuelvo con espacios frente al campo
    if UpperCase(Tipo) = UpperCase('inicio') then
    begin
      incremento := Campo.Size - Length(Campo.Value);
      Result := DupeString(Char(32){Char(32)=Espacio}, incremento) + Campo.Value;
    end;

    if UpperCase(Tipo) = UpperCase('fin') then
    begin
      incremento := Campo.Size - Length(Campo.Value);
      Result := Campo.Value;
      for i := 0 to incremento do
      begin
        Result := Result + ' ';
      end;
    end;
  end;
end;


function GenerateRandomNumber(leng: Integer): Integer;
var i : integer; s : string;
begin
  s := Chr(Ord('1') + Random(9));
  for i := 2 to leng do s := s + Chr(Ord('0') + Random(10));
  Result := StrToInt(s);
end;


function ValueIn(Value: Integer; const Values: array of Integer): Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := Low(Values) to High(Values) do
    if Value = Values[I] then
    begin
      Result := True;
      Break;
    end;
end;


function IfNull(const Value, Default : OleVariant ): OleVariant;
begin
  if Value = NULL then
    Result := Default
  else
    Result := Value;
end;

function IfNullStr(const Value, Default : OleVariant ): OleVariant;
begin
  if Value = EmptyStr then
    Result := Default
  else
    Result := Value;
end;


{$IFDEF MSWINDOWS}
function String2Hex(const Buffer: Ansistring): string;
begin
  SetLength(result, 2*Length(Buffer));
  BinToHex(@Buffer[1], PWideChar(@result[1]), Length(Buffer));
end;
{$ENDIF}


function BoolToStr (AValue: boolean; ABooleanWordType: TBooleanWordType = bwTrue): string;
begin
  Result := BooleanWord [AValue, ABooleanWordType];
end;


function CaracteresASCIIEstandar(s: string): Boolean;
const
  Allowed = ['A' .. 'Z', 'a' .. 'z', '0' .. '9', '_'];
var
    i: Integer;
begin

  Result := Length(s) > 0;
  i := 1;

  while Result and (i <= Length(S)) do
  begin
      Result := Result AND (S[i] in Allowed);
      inc(i);
    end;
  if  Length(s) = 0 then Result := true;

end;


function NumeroTextoOrden(Numero: integer): string;
const
  z: array[1..36] of string = ('0','1','2','3','4','5','6','7','8','9','a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z');
begin
  Result := (z[Numero + 1]);
end;


function NumberToString(number: Integer): String;
begin
  Result := '';
  if (number < 1) or (number > 26) then
        Exit;

  Result := 'abcdefghijklmnopqrstuvwxyz'[number];
end;


function ObtenerCalificacion(Puntaje: Integer): Integer;
begin
  case Puntaje of
    23 .. 59:
    begin
      Result := 1;
    end;

    60 .. 70:
    begin
      Result := 2;
    end;

    71 .. 80:
    begin
      Result := 3;
    end;

    81 .. 90:
    begin
      Result := 4;
    end;

    91 .. 100:
    begin
      Result := 5;
    end;

    else
    begin
      Result := 0;
    end;

  end;
end;


function OleVariantToString(const Value: OleVariant): string;
var ss: TStringStream;
      Size: integer;
      Data: PByteArray;
begin
  Result:='';
  if Length(Value) = 0 then Exit;
  ss:=TStringStream.Create;
  try
    Size := VarArrayHighBound (Value, 1) - VarArrayLowBound(Value, 1) + 1;
    Data := VarArrayLock(Value);
    try
      ss.Position := 0;
      ss.WriteBuffer(Data^, Size);
      ss.Position := 0;
      Result:=ss.DataString;
    finally
      VarArrayUnlock(Value);
    end;
  finally
    ss.Free;
  end;
end;


function ExtractText(const Str: string; const Delim1, Delim2: string): string;
var
  pos1, pos2: integer;
begin
  result := '';
  pos1 := Pos(Delim1, Str);
  if pos1 > 0 then begin
    pos2 := PosEx(Delim2, Str, pos1+1);
    if pos2 > 0 then
      result := Copy(Str, pos1 + 1, pos2 - pos1 - 1);
  end;
end;


function ExtraerPesoVolumen(const s: string): string;
var
  regex, regex2: TRegEx;
  match, match2: TMatch;
  matches, matches2: TMatchCollection;
  i, x: Integer;
begin

  // Esto no se porque suecede, el result siempre debe estar vacio
  Result := '';

  i := 0;
  regex := TRegEx.Create('\d+');
  matches := regex.Matches(s);

  if matches.Count > 0 then
  begin

    if matches.Count = 1 then
    begin

      for match in matches do
      begin
        //Inc(i);
        Result := match.Value;
      end;

    end
    else
      begin
        x := 0;
        regex2 := TRegEx.Create('(\d+X\s?)?\d+\s?(LITRO|LTRS|LTR|LIT|GMS|LBS|KG|GM|GR|ML|CC|OZ|LB|G|L|K|MT|C.C.)(\d+X\s?)?');
        matches2 := regex2.Matches(UpperCase(s));

        if matches2.Count > 0 then
        begin

          for match2 in matches2 do
          begin
            Inc(x);
            Result := Result + ' ' + ExtractNumberInString(match2.Value);
          end;
        end;
      end;

  end;


  // Devuelvo el resultado
  Result := Trim(Result);
end;


function EditDistance(s, t: string): integer;
var
  d : array of array of integer;
  i,j,cost : integer;
begin
  {
  Compute the edit-distance between two strings.
  Algorithm and description may be found at either of these two links:
  http://en.wikipedia.org/wiki/Levenshtein_distance
  http://www.google.com/search?q=Levenshtein+distance
  }

  //initialize our cost array
  SetLength(d,Length(s)+1);
  for i := Low(d) to High(d) do begin
    SetLength(d[i],Length(t)+1);
  end;

  for i := Low(d) to High(d) do begin
    d[i,0] := i;
    for j := Low(d[i]) to High(d[i]) do begin
      d[0,j] := j;
    end;
  end;

  //store our costs in a 2-d grid
  for i := Low(d)+1 to High(d) do begin
    for j := Low(d[i])+1 to High(d[i]) do begin
      if s[i] = t[j] then begin
        cost := 0;
      end
      else begin
        cost := 1;
      end;

      //to use "Min", add "Math" to your uses clause!
      d[i,j] := Min(Min(
                 d[i-1,j]+1,      //deletion
                 d[i,j-1]+1),     //insertion
                 d[i-1,j-1]+cost  //substitution
                 );
    end;  //for j
  end;  //for i

  //now that we've stored the costs, return the final one
  Result := d[Length(s),Length(t)];

  //dynamic arrays are reference counted.
  //no need to deallocate them
end;


function StripHTML(S: string): string;
var
  TagBegin, TagEnd, TagLength: integer;
begin
  TagBegin := Pos( '<', S);  // search position of first <

  while (TagBegin > 0) do begin  // while there is a < in S
    TagEnd := Pos('>', S);  // find the matching >
    TagLength := TagEnd - TagBegin + 1;
    Delete(S, TagBegin, TagLength); // delete the tag
    TagBegin:= Pos( '<', S);        // search for next <
  end;

  {convert system characters}
  S := StringReplace(S, '&quot;', '"',  [rfReplaceAll]);
  S := StringReplace(S, '&apos;', '''', [rfReplaceAll]);
  S := StringReplace(S, '&gt;',   '>',  [rfReplaceAll]);
  S := StringReplace(S, '&lt;',   '<',  [rfReplaceAll]);
  S := StringReplace(S, '&amp;',  '&',  [rfReplaceAll]);

  // Acentos
  S := StringReplace(S, '&Aacute;',  '?',  [rfReplaceAll]);
  S := StringReplace(S, '&aacute;',  '?',  [rfReplaceAll]);

  S := StringReplace(S, '&Eacute;',  '?',  [rfReplaceAll]);
  S := StringReplace(S, '&eacute;',  '?',  [rfReplaceAll]);

  S := StringReplace(S, '&Iacute;',  '?',  [rfReplaceAll]);
  S := StringReplace(S, '&iacute;',  '?',  [rfReplaceAll]);

  S := StringReplace(S, '&Oacute;',  '?',  [rfReplaceAll]);
  S := StringReplace(S, '&oacute;',  '?',  [rfReplaceAll]);

  S := StringReplace(S, '&Uacute;',  '?',  [rfReplaceAll]);
  S := StringReplace(S, '&uacute;',  '?',  [rfReplaceAll]);

  S := StringReplace(S, '&Ntilde;',  '?',  [rfReplaceAll]);
  S := StringReplace(S, '&ntilde;',  '?',  [rfReplaceAll]);

  Result := S;
end;


end.
