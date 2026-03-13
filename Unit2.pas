unit Unit2;

interface

uses
  Winapi.Windows, System.SysUtils, System.Classes, System.SyncObjs, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, System.IOUtils, ComObj, ActiveX, ShlObj,
  httpsend, ssl_openssl, OtlParallel, OtlCommon, System.Generics.Collections;

type
  TForm2 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    FileOpenDialog1: TFileOpenDialog;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Button6: TButton;
    Edit1: TEdit;
    Label5: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

const httptimeout=200;

var
  Form2: TForm2;
  zapret: string;
  work: boolean=True;
  CPUCORES: integer = 4;

implementation

{$R *.dfm}

function StrCmpLogicalW(sz1, sz2: PWideChar): Integer; stdcall; external 'shlwapi.dll' name 'StrCmpLogicalW'; inline;


function MyCompare(List: TStringList; Index1, Index2: Integer): Integer; inline;
begin
Result := StrCmpLogicalW(PWideChar(List[Index2]), PWideChar(List[Index1]));
end;

function Sort(const FileName: string):string; inline;
var
List: TStringList;
begin
List:=TStringList.Create;
List.LoadFromFile(FileName);
List.CustomSort(MyCompare);
List.SaveToFile(FileName);
Result:=Copy(List[0], Pos(':', List[0]) + 1, Length(List[0]));
List.Free;
end;

procedure CreateLink(const FPath, FPathLink, Param: string);
var
  IObject: IUnknown;
  SLink: IShellLink;
  PFile: IPersistFile;
begin
  CoInitialize(nil);
  IObject := CreateComObject(CLSID_ShellLink);
  SLink := IObject as IShellLink;
  PFile := IObject as IPersistFile;
  with SLink do
  begin
    SetArguments(PChar(Param));
    SetPath(PChar(FPath));
    //SetWorkingDirectory(PChar(TPath.GetDirectoryName(FPath)));
  end;
  PFile.Save(PWChar(WideString(FPathLink+'\Zapret.lnk')), FALSE);
  CoUninitialize;
end;


function checksites(const urls:TStringList):integer;
var
Event : TCountdownEvent;
counter: IOmniCounter;
begin
Result:=0;
counter := CreateCounter(0);
Event := TCountdownEvent.Create(urls.Count);
Parallel.For(0, urls.Count - 1).NoWait.NumTasks(CPUCORES).Execute(
procedure(idx: Integer)
begin
TThread.CreateAnonymousThread(
procedure
var
http:THttpSend;
begin
try
http:=THttpSend.Create;
http.UserAgent:='Mozilla / 5.0 (Macintosh; Intel Mac OS X 10_15_3) AppleWebKit / 537.36 (KHTML, как Gecko) Chrome / 80.0.3987.163 Safari / 537.36';
http.KeepAlive:=False;
http.Sock.HTTPTunnelTimeout:=httptimeout;
http.Sock.ConnectionTimeout:=httptimeout;
http.Sock.SocksTimeout:=httptimeout;
//http.Sock.SetSendTimeout(httptimeout);
//http.Sock.SetRecvTimeout(httptimeout);
http.Sock.SetTimeout(httptimeout);
http.Timeout:=httptimeout;
http.HTTPMethod('HEAD', Trim(urls[idx]));
if http.ResultCode=200 then
counter.Increment;
finally
//http.Abort;
http.Sock.CloseSocket;
FreeAndNil(http);
Event.Signal;
end;
end).Start;
end);
Event.WaitFor(INFINITE);
FreeAndNil(Event);
Application.ProcessMessages; //Иначе утечка памяти в OmniThreadLibrary
Result := counter.Value;
end;

procedure TForm2.Button1Click(Sender: TObject);
begin
//FileOpenDialog1.Options:=[fdoPickFolders, fdoPathMustExist, fdoForceFileSystem];
if FileOpenDialog1.Execute then
label1.Caption:=FileOpenDialog1.FileName;
label2.Caption:=TPath.GetFullPath(ExtractFilePath(FileOpenDialog1.FileName) + '..\..\files\fake\quic_initial_www_google_com.bin');
end;

procedure TForm2.Button2Click(Sender: TObject);
begin
//FileOpenDialog1.Options := [];
if FileOpenDialog1.Execute then
label2.Caption:=FileOpenDialog1.FileName;
end;

procedure TForm2.Button3Click(Sender: TObject);
begin
//FileOpenDialog1.Options := [];
if FileOpenDialog1.Execute then
label3.Caption:=FileOpenDialog1.FileName;
end;

procedure TForm2.Button4Click(Sender: TObject);
begin
//FileOpenDialog1.Options := [];
if FileOpenDialog1.Execute then
label4.Caption:=FileOpenDialog1.FileName;
end;

procedure TForm2.Button5Click(Sender: TObject);
var
StartTime: TDateTime;
writer:TStreamWriter;
sitelist: TStringlist;
stratalist:TList<string>;
sni, bin, FSavePath:string;
begin
Randomize;
StartTime := Now;
Button5.Enabled:=False;
work:=True;
CPUCORES:=TThread.ProcessorCount;
ForceDirectories(Extractfilepath(paramstr(0))+'Results');
ForceDirectories(Extractfilepath(paramstr(0))+'Results\BestConfig');
FSavePath:=Extractfilepath(paramstr(0))+'Results\Found_'+FormatDateTime('DD.MM.YYYY_hh.mm', Now)+'.txt';
Writer:=TstreamWriter.Create(FSavePath, True, TEncoding.Ansi, 65535);
zapret:=Trim(label1.Caption);
bin:='"'+Trim(label2.Caption)+'"';
sni:=Trim(Edit1.Text);
stratalist:= Tlist<string>.Create;
stratalist.AddRange(TFile.ReadAllLines(Trim(label3.Caption)));
sitelist:= TStringlist.Create;
sitelist.LoadFromFile(Trim(label4.Caption));
TThread.CreateAnonymousThread(
procedure
var
SI: TStartupInfo;
PI: TProcessInformation;
str:string;
i, Last:integer;
begin
for i:= 0 to stratalist.Count-1 do begin
try
FillChar(SI, SizeOf(SI), 0);
SI.cb := SizeOf(SI);
Si.dwFlags := STARTF_USESHOWWINDOW;
Si.wShowWindow := SW_SHOWMINNOACTIVE; // Свернуть без активации
str:=StringReplace(Trim(stratalist.Items[i]), '=PAYLOAD', '='+bin, [rfReplaceAll]);
str:=StringReplace(str, 'sni=SNI', 'sni='+sni, [rfReplaceAll]);
//str:=Trim(stratalist.Items[i]);
CreateProcess(nil, PChar(zapret+' --wf-tcp=80,443 '+ str), nil, nil, False, 0, nil, nil, Si, Pi);
Last:=checksites(sitelist);
Writer.WriteLine(Format('%d/%d:--wf-tcp=80,443 %s', [Last, sitelist.Count-1, str]));
finally
TerminateProcess(PI.hProcess, 0);
CloseHandle(PI.hProcess);
CloseHandle(PI.hThread);
//lock.Acquire;
Form2.Caption := Format('Checked: %d/%d Last: %d/%d Elapsed Time: %s', [i + 1, stratalist.Count-1, Last, sitelist.Count-1 ,FormatDateTime('hh:nn:ss', Now - StartTime)]);
//lock.Release;
end;
if work=False then
break;
end;
Writer.Close;
Writer.Free;
sitelist.Free;
stratalist.Free;
CreateLink(zapret, Extractfilepath(paramstr(0))+'Results\BestConfig', '@Config.cfg');
TFile.WriteAllText(Extractfilepath(paramstr(0))+'Results\BestConfig\Config.cfg', Sort(FSavePath));
MessageBox(Handle, 'Check Completed', 'OK', MB_ICONINFORMATION);
Form2.Button5.Enabled:=True;
Form2.Button6.Enabled:=True;
end).Start;
end;

procedure TForm2.Button6Click(Sender: TObject);
begin
Work:=False;
Button6.Enabled:=False;
end;

end.
