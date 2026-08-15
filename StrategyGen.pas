unit StrategyGen;

interface

uses
  System.SysUtils, System.Generics.Collections;

function GenerateStrategies(const Count: Integer): TList<string>;

implementation

var
  // Расширенный список базовых режимов --dpi-desync=...
  // (собран из исходного файла + официальной документации bol-van/zapret)
  Modes: array[0..38] of string = (
    'fake', 'split', 'split2', 'disorder', 'disorder2',
    'fakedsplit', 'multisplit', 'multidisorder', 'fakeddisorder',
    'hostfakesplit', 'syndata', 'ipfrag2',
    'fakeknown', 'rst', 'rstack', 'synack',
    'hopbyhop', 'destopt', 'ipfrag1', 'tamper', 'udplen',
    'fake,split', 'fake,split2', 'fake,disorder', 'fake,disorder2',
    'fake,fakedsplit', 'fake,multisplit', 'fake,multidisorder',
    'fake,fakeddisorder', 'fake,tamper', 'fake,udplen',
    'fake,ipfrag2', 'fake,hostfakesplit',
    'fake,hopbyhop', 'fake,destopt',
    'syndata,multisplit', 'syndata,fakeddisorder', 'syndata,multidisorder',
    'fakeknown,multisplit');

  // Расширенный список "хвостов" - дополнительных параметров.
  // Некоторые с %d - для них подставляется случайное число.
  Tails: array[0..36] of string = (
    '--dpi-desync-ttl=%d',
    '--dpi-desync-autottl=%d',
    '--dpi-desync-autottl',
    '--dpi-desync-fooling=badseq',
    '--dpi-desync-fooling=badsum',
    '--dpi-desync-fooling=datanoack',
    '--dpi-desync-fooling=md5sig',
    '--dpi-desync-fooling=ts',
    '--dpi-desync-fooling=hopbyhop2',
    '--dpi-desync-split-pos=1',
    '--dpi-desync-split-pos=midsld',
    '--dpi-desync-split-pos=sld+1',
    '--dpi-desync-split-pos=sld-1',
    '--dpi-desync-split-pos=midsld-1',
    '--dpi-desync-split-pos=midsld+1',
    '--dpi-desync-split-pos=method+2',
    '--dpi-desync-fake-tls=0x00000000',
    '--dpi-desync-fake-tls=PAYLOAD',
    '--dpi-desync-fake-tls=0x0F0F0F0F',
    '--dpi-desync-fake-tls-mod=rnd,dupsid,rndsni,padencap',
    '--dpi-desync-fake-tls-mod=rnd,dupsid,sni=SNI',
    '--wssize=1:6',
    '--dpi-desync-repeats=%d',
    '--dpi-desync-cutoff=n3',
    '--dpi-desync-cutoff=d3',
    '--dpi-desync-any-protocol=1',
    '--dpi-desync-fake-quic=PAYLOAD',
    '--dpi-desync-split-seqovl=%d',
    '--dpi-desync-fake-syndata=PAYLOAD',
    '--dpi-desync-fake-http=PAYLOAD',
    '--dpi-desync-fake-unknown-udp=PAYLOAD',
    '--dpi-desync-fake-wireguard=PAYLOAD',
    '--dpi-desync-fake-dht=PAYLOAD',
    '--dpi-desync-udplen-increment=%d',
    '--dpi-desync-badseq-increment=%d',
    '--dup=%d',
    '--dpi-desync-fake-tcp-mod=seq');

function RandLine: string; inline;
var
  i: Integer;
  Tail: string;
begin
  Result := '--dpi-desync=' + Modes[Random(Length(Modes))];
  for i := 1 to Random(6) do
  begin
    Tail := Tails[Random(Length(Tails))];
    if Pos('%d', Tail) > 0 then
      Tail := Format(Tail, [Random(20) + 1]);
    Result := Result + ' ' + Tail;
  end;
end;

function GenerateStrategies(const Count: Integer): TList<string>;
var
  Str: string;
begin
  Result := TList<string>.Create;
  repeat
    Str := RandLine;
    if not Result.Contains(Str) then
      Result.Add(Str);
  until Result.Count = Count;
  // Result.Free;
end;

initialization
  Randomize;

end.
