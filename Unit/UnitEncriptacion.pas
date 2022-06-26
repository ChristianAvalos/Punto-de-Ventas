
unit UnitEncriptacion;

interface

uses StrUtils, Windows, System.Classes, SysUtils;

const
  Contrasena = '#password#';
  CKEY1 = 53761;
  CKEY2 = 32618;

  function Encriptar(const S :WideString; Key: Word = 100): String;
  function Desencriptar(const S: String; Key: Word = 100): String;


implementation


function Encriptar(const S: WideString; Key: Word = 100): String;
var
  i: Integer;
  RStr: RawByteString;
  RStrB: TBytes Absolute RStr;
begin
  Result:= '';

  RStr:= UTF8Encode(S);

  for i := 0 to Length(RStr)-1 do begin
    RStrB[i] := RStrB[i] xor (Key shr 8);
    Key := (RStrB[i] + Key) * CKEY1 + CKEY2;
  end;

  for i := 0 to Length(RStr)-1 do begin
    Result:= Result + IntToHex(RStrB[i], 2);
  end;
end;


function Desencriptar(const S: String; Key: Word = 100): String;
var
  i, tmpKey: Integer;
  RStr: RawByteString;
  RStrB: TBytes Absolute RStr;
  tmpStr: string;
begin
  tmpStr:= UpperCase(S);
  SetLength(RStr, Length(tmpStr) div 2);

  i:= 1;

  try
    while (i < Length(tmpStr)) do begin
      RStrB[i div 2]:= StrToInt('$' + tmpStr[i] + tmpStr[i+1]);
      Inc(i, 2);
    end;
  except
    Result:= '';
    Exit;
  end;

  for i := 0 to Length(RStr)-1 do begin
    tmpKey:= RStrB[i];
    RStrB[i] := RStrB[i] xor (Key shr 8);
    Key := (tmpKey + Key) * CKEY1 + CKEY2;
  end;

  Result:= UTF8Decode(RStr);
end;


end.

