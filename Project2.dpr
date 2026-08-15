program Project2;

uses
  Vcl.Forms,
  System.SysUtils,
  Unit2 in 'Unit2.pas' {Form2},
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

const
isni:array[0..4] of string=('mail.ru', 'www.gismeteo.ru','www.google.com','www.gazprombank.ru', 'lesta.ru');
begin
  Randomize;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Auric');
  Application.CreateForm(TForm2, Form2);
  zapret:=form2.label1.Caption;
  form2.label3.Caption:=extractfilepath(paramstr(0))+'Strategies\Strategies.txt';
  form2.label4.Caption:=extractfilepath(paramstr(0))+'Sites\FAST.txt';
  form2.Edit1.Text:=Trim(isni[Random(5)]);
  Application.Run;
end.
