object Form_player: TForm_player
  Left = 0
  Top = 0
  Anchors = []
  BorderStyle = bsSingle
  Caption = 'mp3player'
  ClientHeight = 654
  ClientWidth = 497
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object pb1: TPaintBox
    Left = 8
    Top = 8
    Width = 481
    Height = 105
    Align = alCustom
    OnClick = pb1Click
  end
  object Label1: TLabel
    Left = 8
    Top = 142
    Width = 30
    Height = 13
    Caption = #1042#1088#1077#1084#1103
  end
  object Label2: TLabel
    Left = 440
    Top = 142
    Width = 30
    Height = 13
    Caption = #1042#1088#1077#1084#1103
  end
  object Label3: TLabel
    Left = 256
    Top = 148
    Width = 53
    Height = 13
    Caption = #1043#1088#1086#1084#1082#1086#1089#1090#1100
  end
  object Label4: TLabel
    Left = 376
    Top = 148
    Width = 35
    Height = 13
    Caption = #1041#1072#1083#1072#1085#1089
  end
  object Label5: TLabel
    Left = 18
    Top = 352
    Width = 27
    Height = 13
    Caption = '80 '#1043#1094
  end
  object Label6: TLabel
    Left = 63
    Top = 352
    Width = 33
    Height = 13
    Caption = '170 '#1043#1094
  end
  object Label7: TLabel
    Left = 108
    Top = 352
    Width = 33
    Height = 13
    Caption = '310 '#1043#1094
  end
  object Label8: TLabel
    Left = 155
    Top = 352
    Width = 33
    Height = 13
    Caption = '600 '#1043#1094
  end
  object Label9: TLabel
    Left = 206
    Top = 352
    Width = 27
    Height = 13
    Caption = '1 '#1082#1043#1094
  end
  object Label10: TLabel
    Left = 253
    Top = 352
    Width = 27
    Height = 13
    Caption = '3 '#1082#1043#1094
  end
  object Label11: TLabel
    Left = 301
    Top = 352
    Width = 27
    Height = 13
    Caption = '6 '#1082#1043#1094
  end
  object Label12: TLabel
    Left = 347
    Top = 352
    Width = 33
    Height = 13
    Caption = '10 '#1082#1043#1094
  end
  object Label13: TLabel
    Left = 395
    Top = 352
    Width = 33
    Height = 13
    Caption = '12 '#1082#1043#1094
  end
  object Label14: TLabel
    Left = 443
    Top = 352
    Width = 33
    Height = 13
    Caption = '14 '#1082#1043#1094
  end
  object ScrollBar1: TScrollBar
    Left = 8
    Top = 119
    Width = 481
    Height = 17
    PageSize = 0
    TabOrder = 0
    OnScroll = ScrollBar1Scroll
  end
  object Button1: TButton
    Left = 55
    Top = 167
    Width = 40
    Height = 25
    Caption = 'play'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 101
    Top = 167
    Width = 40
    Height = 25
    Caption = 'pause'
    TabOrder = 2
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 147
    Top = 167
    Width = 40
    Height = 25
    Caption = 'stop'
    TabOrder = 3
    OnClick = Button3Click
  end
  object TrackBar1: TTrackBar
    Left = 251
    Top = 167
    Width = 113
    Height = 31
    Position = 5
    TabOrder = 4
  end
  object TrackBar2: TTrackBar
    Left = 376
    Top = 167
    Width = 113
    Height = 31
    Max = 5
    Min = -5
    TabOrder = 5
  end
  object TrackBar3: TTrackBar
    Left = 12
    Top = 196
    Width = 45
    Height = 150
    Max = 30
    Orientation = trVertical
    Position = 15
    TabOrder = 6
    TickMarks = tmBoth
    OnChange = TrackBar3Change
  end
  object TrackBar4: TTrackBar
    Left = 59
    Top = 196
    Width = 45
    Height = 150
    Max = 30
    Orientation = trVertical
    Position = 15
    TabOrder = 7
    TickMarks = tmBoth
    OnChange = TrackBar4Change
  end
  object TrackBar5: TTrackBar
    Left = 104
    Top = 196
    Width = 45
    Height = 150
    Max = 30
    Orientation = trVertical
    Position = 15
    TabOrder = 8
    TickMarks = tmBoth
    OnChange = TrackBar5Change
  end
  object TrackBar6: TTrackBar
    Left = 152
    Top = 196
    Width = 45
    Height = 150
    Max = 30
    Orientation = trVertical
    Position = 15
    TabOrder = 9
    TickMarks = tmBoth
    OnChange = TrackBar6Change
  end
  object TrackBar7: TTrackBar
    Left = 200
    Top = 196
    Width = 45
    Height = 150
    Max = 30
    Orientation = trVertical
    Position = 15
    TabOrder = 10
    TickMarks = tmBoth
    OnChange = TrackBar7Change
  end
  object TrackBar8: TTrackBar
    Left = 248
    Top = 196
    Width = 45
    Height = 150
    Max = 30
    Orientation = trVertical
    Position = 15
    TabOrder = 11
    TickMarks = tmBoth
    OnChange = TrackBar8Change
  end
  object TrackBar9: TTrackBar
    Left = 296
    Top = 196
    Width = 45
    Height = 150
    Max = 30
    Orientation = trVertical
    Position = 15
    TabOrder = 12
    TickMarks = tmBoth
    OnChange = TrackBar9Change
  end
  object TrackBar10: TTrackBar
    Left = 344
    Top = 196
    Width = 45
    Height = 150
    Max = 30
    Orientation = trVertical
    Position = 15
    TabOrder = 13
    TickMarks = tmBoth
    OnChange = TrackBar10Change
  end
  object TrackBar11: TTrackBar
    Left = 392
    Top = 196
    Width = 45
    Height = 150
    Max = 30
    Orientation = trVertical
    Position = 15
    TabOrder = 14
    TickMarks = tmBoth
    OnChange = TrackBar11Change
  end
  object TrackBar12: TTrackBar
    Left = 440
    Top = 196
    Width = 45
    Height = 150
    Max = 30
    Orientation = trVertical
    Position = 15
    TabOrder = 15
    TickMarks = tmBoth
    OnChange = TrackBar12Change
  end
  object Button4: TButton
    Left = 55
    Top = 375
    Width = 41
    Height = 25
    Caption = 'Add(f)'
    TabOrder = 16
    OnClick = Button4Click
  end
  object Button5: TButton
    Left = 102
    Top = 375
    Width = 41
    Height = 25
    Caption = 'Clear(f)'
    TabOrder = 17
    OnClick = Button5Click
  end
  object ListBox1: TListBox
    Left = 8
    Top = 406
    Width = 481
    Height = 99
    ItemHeight = 13
    TabOrder = 18
    OnDblClick = ListBox1DblClick
  end
  object prev: TButton
    Left = 9
    Top = 167
    Width = 40
    Height = 25
    Caption = 'prev'
    TabOrder = 19
    OnClick = prevClick
  end
  object next: TButton
    Left = 193
    Top = 167
    Width = 40
    Height = 25
    Caption = 'next'
    TabOrder = 20
    OnClick = nextClick
  end
  object RadioGroup1: TRadioGroup
    Left = 8
    Top = 8
    Width = 118
    Height = 105
    Align = alCustom
    Caption = #1042#1080#1079#1091#1072#1083#1080#1079#1072#1094#1080#1103
    ItemIndex = 2
    Items.Strings = (
      #1057#1087#1077#1082#1090#1088
      #1050#1088#1091#1075
      #1051#1080#1085#1080#1103)
    TabOrder = 21
    Visible = False
  end
  object RadioGroup2: TRadioGroup
    Left = 371
    Top = 8
    Width = 118
    Height = 105
    Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099
    ItemIndex = 0
    Items.Strings = (
      #1051#1080#1085#1080#1103
      #1055#1086#1083#1085#1099#1081
      #1055#1080#1082#1089#1077#1083)
    TabOrder = 22
    Visible = False
    OnClick = RadioGroup2Click
  end
  object ComboBox1: TComboBox
    Left = 312
    Top = 379
    Width = 177
    Height = 21
    Style = csDropDownList
    TabOrder = 23
    OnChange = ComboBox1Change
  end
  object RadioButton1: TRadioButton
    Left = 59
    Top = 144
    Width = 51
    Height = 17
    Caption = #1054#1073#1099#1095'.'
    Checked = True
    TabOrder = 24
    TabStop = True
  end
  object RadioButton2: TRadioButton
    Left = 119
    Top = 144
    Width = 48
    Height = 17
    Caption = #1057#1083#1091#1095'.'
    TabOrder = 25
  end
  object RadioButton3: TRadioButton
    Left = 180
    Top = 144
    Width = 56
    Height = 17
    Caption = #1055#1086#1074#1090#1086#1088
    TabOrder = 26
  end
  object Button6: TButton
    Left = 196
    Top = 375
    Width = 40
    Height = 25
    Caption = 'Load'
    TabOrder = 27
    OnClick = Button6Click
  end
  object Button7: TButton
    Left = 242
    Top = 375
    Width = 41
    Height = 25
    Caption = 'Save'
    TabOrder = 28
    OnClick = Button7Click
  end
  object Button8: TButton
    Left = 150
    Top = 375
    Width = 40
    Height = 25
    Caption = 'del(f)'
    TabOrder = 29
    OnClick = Button8Click
  end
  object Button9: TButton
    Left = 8
    Top = 375
    Width = 41
    Height = 25
    Caption = 'file'
    TabOrder = 30
    OnClick = Button9Click
  end
  object OpenDialog1: TOpenDialog
    Options = [ofHideReadOnly, ofAllowMultiSelect, ofEnableSizing]
    Left = 24
    Top = 519
  end
  object Timer1: TTimer
    Interval = 30
    OnTimer = Timer1Timer
    Left = 168
    Top = 527
  end
  object OpenDialog2: TOpenDialog
    Left = 96
    Top = 520
  end
  object SaveDialog1: TSaveDialog
    Left = 272
    Top = 544
  end
end
