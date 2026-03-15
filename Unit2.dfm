object Form2: TForm2
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'bol-van/Zapret Strategies Checker v3.1 by Uefi1(triblekill)'
  ClientHeight = 459
  ClientWidth = 514
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 71
    Width = 397
    Height = 16
    Caption = 'C:\Program Files\zapret-v72.12\binaries\windows-x86_64\winws.exe'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Label3: TLabel
    Left = 16
    Top = 231
    Width = 224
    Height = 16
    Caption = 'zapretchecker\Strategies\Strategies.txt'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Label4: TLabel
    Left = 16
    Top = 311
    Width = 194
    Height = 16
    Caption = 'zapretchecker\Sites\checksites.txt'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Label2: TLabel
    Left = 16
    Top = 151
    Width = 437
    Height = 16
    Caption = 
      'C:\Program Files\zapret-v72.12\files\fake\quic_initial_www_googl' +
      'e_com.bin'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Label5: TLabel
    Left = 16
    Top = 344
    Width = 25
    Height = 16
    Caption = 'SNI:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Button1: TButton
    Left = 16
    Top = 16
    Width = 121
    Height = 41
    Caption = 'Zapret'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button3: TButton
    Left = 16
    Top = 184
    Width = 121
    Height = 33
    Caption = 'Strategies'
    TabOrder = 1
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 16
    Top = 264
    Width = 121
    Height = 33
    Caption = 'Sites'
    TabOrder = 2
    OnClick = Button4Click
  end
  object Button5: TButton
    Left = 16
    Top = 384
    Width = 121
    Height = 41
    Caption = 'Start'
    TabOrder = 3
    OnClick = Button5Click
  end
  object Button2: TButton
    Left = 16
    Top = 104
    Width = 121
    Height = 33
    Caption = 'Quic/Tls/BIN'
    TabOrder = 4
    OnClick = Button2Click
  end
  object Button6: TButton
    Left = 277
    Top = 384
    Width = 129
    Height = 41
    Caption = 'Stop'
    TabOrder = 5
    OnClick = Button6Click
  end
  object Edit1: TEdit
    Left = 47
    Top = 343
    Width = 163
    Height = 21
    TabOrder = 6
    Text = 'www.google.com'
  end
  object FileOpenDialog1: TFileOpenDialog
    FavoriteLinks = <>
    FileTypes = <>
    Options = []
    Left = 376
    Top = 8
  end
end
