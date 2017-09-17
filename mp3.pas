unit mp3;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls, bass, vis, themes, inifiles;

type
  TplayerMode = (Stop,Play,Paused);
  TForm_player = class(TForm)
    pb1: TPaintBox;
    ScrollBar1: TScrollBar;
    Label1: TLabel;
    Label2: TLabel;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    TrackBar1: TTrackBar;
    TrackBar2: TTrackBar;
    Label3: TLabel;
    Label4: TLabel;
    TrackBar3: TTrackBar;
    TrackBar4: TTrackBar;
    TrackBar5: TTrackBar;
    TrackBar6: TTrackBar;
    TrackBar7: TTrackBar;
    TrackBar8: TTrackBar;
    TrackBar9: TTrackBar;
    TrackBar10: TTrackBar;
    TrackBar11: TTrackBar;
    TrackBar12: TTrackBar;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Button4: TButton;
    Button5: TButton;
    ListBox1: TListBox;
    OpenDialog1: TOpenDialog;
    Timer1: TTimer;
    prev: TButton;
    next: TButton;
    RadioGroup1: TRadioGroup;
    RadioGroup2: TRadioGroup;
    ComboBox1: TComboBox;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    Button6: TButton;
    Button7: TButton;
    OpenDialog2: TOpenDialog;
    SaveDialog1: TSaveDialog;
    Button8: TButton;
    Button9: TButton;
    procedure Button4Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure player;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ScrollBar1Scroll(Sender: TObject; ScrollCode: TScrollCode;
      var ScrollPos: Integer);
    procedure Timer1Timer(Sender: TObject);
    procedure ListBox1DblClick(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure TrackBar3Change(Sender: TObject);
    procedure TrackBar4Change(Sender: TObject);
    procedure TrackBar5Change(Sender: TObject);
    procedure TrackBar6Change(Sender: TObject);
    procedure TrackBar7Change(Sender: TObject);
    procedure TrackBar8Change(Sender: TObject);
    procedure TrackBar9Change(Sender: TObject);
    procedure TrackBar10Change(Sender: TObject);
    procedure TrackBar11Change(Sender: TObject);
    procedure TrackBar12Change(Sender: TObject);
    procedure prevClick(Sender: TObject);
    procedure nextClick(Sender: TObject);
    procedure pb1Click(Sender: TObject);
    procedure RadioGroup2Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure SaveList(SaveFile: string);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
  private
    { Private declarations }
  public

  end;

var
  Form_player: TForm_player;
  i:integer; //номер проигрываемой песнит
  filename: string; //имя файла
  Channel: DWORD;   // дескрипотр канала
  Mode: TPlayerMode;  // play mode
  //переменные для настройки эквалайзера
  p: BASS_DX8_PARAMEQ;
  fx: array[1..10] of integer;
    //переменные визуализации
  FFTPeacks  : array [0..128] of Integer;
  FFTFallOff : array [0..128] of Integer;
  //переменная файла конфигурации
  IniFile: TIniFile;

implementation
{$R *.dfm}

function lentime(filename1:string):string;
  var
   TrackLen: Double;
   ValLen: Double;
  Channel1    : DWORD;
  begin
  //освобаждаем канал
  BASS_StreamFree(Channel1);
  //пытаемся загрузить файл и получить дескриптор канала
  Channel1 := BASS_StreamCreateFile(FALSE, PChar(FileName1), 0, 0, 0 {$IFDEF UNICODE} or BASS_UNICODE {$ENDIF});
  //получаем время воспроизведения
  TrackLen:=BASS_ChannelBytes2Seconds(Channel1,BASS_ChannelGetLength(Channel1,BASS_POS_BYTE));
  ValLen:=TrackLen / (24 * 3600);
   Lentime:=FormatDateTime('hh:mm:ss',ValLen);
  //освобаждаем канал
  BASS_StreamFree(Channel1);
  end;

function MinToSec(tim: string): string;
var n: integer;
     a: string;
begin
     n := 1;
     a := '';
     repeat
     a := a + tim[n];
     Inc(n);
     until tim[n] = ':';
     Delete(tim, 1, Length(a) + 1);
     result := IntToStr((StrToInt(a) * 60) + StrToInt(tim));
end;

procedure  TForm_player.SaveList(SaveFile: string);
var List: TStringList;
     i: integer;
     s: string;
     F:TextFile;
begin
Assignfile(F,SaveFile);
Rewrite(F);
Writeln(F,'#EXTM3U');
     for i := 0 to ListBox1.Items.Count - 1 do
     begin
     s:='';
     s:=copy(lentime(Listbox1.Items[i]),4,5);
     Writeln(F,'#EXTINF:' + MinToSec(s));
     Writeln(F,ListBox1.Items.Strings[i]);
     end;
Closefile(F);
end;

function LoadStyle(FileName: string): string; // загрузить скин и вернуть его имя
var
  sm: TStyleManager;
  si: TStyleInfo;
begin
  result := '';
  sm := TStyleManager.Create;
  try
    if TStyleManager.IsValidStyle(FileName, si) then // взять информацию о стиле в si
    begin
      result := si.Name;
      if sm.Style[result] = nil then
         sm.LoadFromFile(FileName);
    end;
  finally
    sm.Free;
  end;
end;

procedure TForm_player.pb1Click(Sender: TObject);
begin
if pb1.Width=481 then begin
pb1.Width:=240;
pb1.Left:=128;
Radiogroup1.Visible:=true;
Radiogroup2.Visible:=true;
end
else begin
pb1.Width:=481;
pb1.Left:=8;
Radiogroup1.Visible:=false;
Radiogroup2.Visible:=false;
end;
end;


procedure TForm_player.player;
begin
  //проверяем, если не пауза
  if mode<>paused then begin
  {то проверяем существует ли файл загружаемый из playlist
  если файл существует то выходим}
  if not FileExists(Filename) then begin showMessage('Файл не существует');exit;end;
  //останавливаем и освобождаем канал воспроизведения
  BASS_ChannelStop(Channel);BASS_StreamFree(Channel);
  //пытаемся загрузить файл и получить дескриптор канала
  Channel := BASS_StreamCreateFile(False, PChar(Filename), 0, 0, 0 {$ifdef unicode} or BASS_Unicode {$endif});
  //если дескриптор канал = 0 (файл по какой то причине не может быть загружен),
  //выдаем сообщение об ошибке и выходим
  if Channel=0 then begin ShowMessage('Ошибка загрузки Файла');exit;end;
end;

//настройка эквалайзера
    fx[1] := BASS_ChannelSetFX(channel, BASS_FX_DX8_PARAMEQ, 1);//первый канал эквалайзера
    fx[2] := BASS_ChannelSetFX(channel, BASS_FX_DX8_PARAMEQ, 1);//второй канал
    fx[3] := BASS_ChannelSetFX(channel, BASS_FX_DX8_PARAMEQ, 1);
    fx[4] := BASS_ChannelSetFX(channel, BASS_FX_DX8_PARAMEQ, 1);
    fx[5] := BASS_ChannelSetFX(channel, BASS_FX_DX8_PARAMEQ, 1);
    fx[6] := BASS_ChannelSetFX(channel, BASS_FX_DX8_PARAMEQ, 1);
    fx[7] := BASS_ChannelSetFX(channel, BASS_FX_DX8_PARAMEQ, 1);
    fx[8] := BASS_ChannelSetFX(channel, BASS_FX_DX8_PARAMEQ, 1);
    fx[9] := BASS_ChannelSetFX(channel, BASS_FX_DX8_PARAMEQ, 1);
    fx[10] := BASS_ChannelSetFX(channel, BASS_FX_DX8_PARAMEQ, 1);

    //настройка первого канала эквалайзера
    p.fGain :=15-trackbar3.Position; //усиление
    p.fBandwidth := 3; //ширина полосы пропускания
    p.fCenter := 80; //частота регулирования
    BASS_FXSetParameters(fx[1], @p);//применение заданных настроек

    //настройка второго канала эквалайзера
    p.fGain := 15-trackbar4.Position;
    p.fBandwidth := 3;
    p.fCenter := 170;
    BASS_FXSetParameters(fx[2], @p);
    //и т.д.

    p.fGain := 15-trackbar5.Position;
    p.fBandwidth := 3;
    p.fCenter := 310;
    BASS_FXSetParameters(fx[3], @p);

    p.fGain := 15-trackbar6.Position;
    p.fBandwidth := 3;
    p.fCenter := 600;
    BASS_FXSetParameters(fx[4], @p);

    p.fGain := 15-trackbar7.Position;
    p.fBandwidth := 3;
    p.fCenter := 1000;
    BASS_FXSetParameters(fx[5], @p);

    p.fGain := 15-trackbar8.Position;
    p.fBandwidth := 3;
    p.fCenter := 3000;
    BASS_FXSetParameters(fx[6], @p);

    p.fGain := 15-trackbar9.Position;
    p.fBandwidth := 3;
    p.fCenter := 6000;
    BASS_FXSetParameters(fx[7], @p);

    p.fGain := 15-trackbar10.Position;
    p.fBandwidth :=3;
    p.fCenter := 10000;
    BASS_FXSetParameters(fx[8], @p);

    p.fGain := 15-trackbar11.Position;
    p.fBandwidth := 3;
    p.fCenter := 12000;
    BASS_FXSetParameters(fx[9], @p);

    p.fGain := 15-trackbar12.Position;
    p.fBandwidth := 3;
    p.fCenter := 14000;
    BASS_FXSetParameters(fx[10], @p);

// командой BASS_ChannelPlay(Channel,False) пытаемся воспроизвести файл,
// если это невозможно, то выдаем сообщение об ошибке
if not BASS_ChannelPlay(Channel, False) then
  begin ShowMessage('Ошибка воспроизведения файла');exit;end;

//полоса проигрывания
    scrollbar1.Min:=0; //минимальное значение
    scrollbar1.Max:=bass_ChannelGEtLength(Channel, 0)-1;//максимальное значение

  //присваеваем заголовку формы имя проигрываемого файла
  Form_Player.Caption:=ExtractFileName(FileName);
  //устанавливаем playmode - play
  mode := play;
  end;


procedure TForm_player.ScrollBar1Scroll(Sender: TObject;
  ScrollCode: TScrollCode; var ScrollPos: Integer);
begin
//устанавливаем позицию воспроизведения трека в зависимости от положения scrollbar
 bass_ChannelSetPosition(Channel, scrollbar1.position, 0);
end;

procedure TForm_player.Timer1Timer(Sender: TObject);
var FFTFata : TFFTData; WaveData  : TWaveData;
TrackLen, TrackPos: Double;
ValPos: Double;
ValLen: Double;
begin
//проверяем режим воспроизведения, если не Play то выходим
if mode<>play then Exit;
//воспроизведение следующей песни
//если время проигрывания равно длине песни по времени,
if  BASS_ChannelGetPosition(channel, 0)=BASS_ChannelGetLength(channel, 0) then begin
//if  BASS_ChannelIsActive(channel)=BASS_ACTIVE_STOPPED   then begin
// в место  if  BASS_ChannelGetPosition(channel, 0)=BASS_ChannelGetLength(channel, 0) then
// можно сделать так: if  BASS_ChannelIsActive(channel)=BASS_ACTIVE_STOPPED   then
// Практика показывает, что второй вариант более предпочтительный,
// т.к. проверка по длине трека иногда приводит к ошибкам в работе плеера.
if Radiobutton1.checked then begin
if i<ListBox1.Items.Count-1 then begin
    inc(i);
 Filename:=ListBox1.Items.Strings[i];
 ListBox1.ItemIndex:=i;
    mode:=stop;
    player;
   end else begin
i:=0;
Filename:=ListBox1.Items.Strings[i];
 ListBox1.ItemIndex:=i;
    mode:=stop;
    player;
   end;
end;
if Radiobutton2.checked then begin
i:=random(ListBox1.Items.Count);
Filename:=ListBox1.Items.Strings[i];
 ListBox1.ItemIndex:=i;
    mode:=stop;
    player;
end else
if Radiobutton3.checked then begin
Filename:=ListBox1.Items.Strings[i];
 ListBox1.ItemIndex:=i;
    mode:=stop;
    player;
   end;
end;
//то выбираем следующую песню из плейлиста
   case RadioGroup1.ItemIndex of
  0 :
   begin
    BASS_ChannelGetData(Channel, @FFTFata, BASS_DATA_FFT1024);
    Spectrum.Draw (Pb1.Canvas.Handle, FFTFata, 0,-5);
   end;

  1 :
   begin
   BASS_ChannelGetData(Channel, @WaveData, 2048);
CircleScope.Draw (Pb1.Canvas.Handle, WaveData, random(pb1.width)+10, random(pb1.height)+5);
   end;

  2 :
   begin
BASS_ChannelGetData(Channel, @WaveData, 2048);
OcilloScope.Draw (Pb1.Canvas.Handle, WaveData, 0, 50);
   end;
   end;
//устанавливаем позицию scrollbar в зависимоти от позиции трека
scrollbar1.Position:=bass_channelGetPosition(channel,0);

//время проигрывания трека
//считаваем сколько секунд прошло от начала воспроизведения
TrackPos:=BASS_ChannelBytes2Seconds(Channel, BASS_ChannelGetPosition(Channel,0));
//считываем всю длину песню в секундах
TrackLen:=BASS_ChannelBytes2Seconds(Channel, BASS_ChannelGetLength(Channel,0));
//переводим секунды в часы
ValPos:=TrackPos / (24 * 3600);
ValLen:=TrackLen / (24 * 3600);
//Выводим данные о времени на форму в Label1 и Label2
Label1.Caption:=FormatDateTime('hh:mm:ss',ValPos);
Label2.Caption:=FormatDateTime('hh:mm:ss',ValLen);
//установка громкости звука
BASS_ChannelSetAttribute(Channel,BASS_ATTRIB_VOL, trackBar1.Position/10);
//установка баланса
BASS_ChannelSetAttribute(Channel,BASS_ATTRIB_PAN, Trackbar2.Position/5);

end;

procedure TForm_player.TrackBar10Change(Sender: TObject);
begin
BASS_FXGetParameters(fx[8], @p);//считываем параметры канала
p.fgain := 15-TrackBar10.position;//задаем усиление в зависимости от позиции TrackBar
BASS_FXSetParameters(fx[8], @p);//устанавливаем измененные параметры
end;

procedure TForm_player.TrackBar11Change(Sender: TObject);
begin
BASS_FXGetParameters(fx[9], @p);//считываем параметры канала
p.fgain := 15-TrackBar11.position;//задаем усиление в зависимости от позиции TrackBar
BASS_FXSetParameters(fx[9], @p);//устанавливаем измененные параметры
end;

procedure TForm_player.TrackBar12Change(Sender: TObject);
begin
BASS_FXGetParameters(fx[10], @p);//считываем параметры канала
p.fgain := 15-TrackBar12.position;//задаем усиление в зависимости от позиции TrackBar
BASS_FXSetParameters(fx[10], @p);//устанавливаем измененные параметры
end;

procedure TForm_player.TrackBar3Change(Sender: TObject);
begin
BASS_FXGetParameters(fx[1], @p);//считываем параметры канала
p.fgain := 15-TrackBar3.position;//задаем усиление в зависимости от позиции TrackBar
BASS_FXSetParameters(fx[1], @p);//устанавливаем измененные параметры
end;

procedure TForm_player.TrackBar4Change(Sender: TObject);
begin
BASS_FXGetParameters(fx[2], @p);//считываем параметры канала
p.fgain := 15-TrackBar4.position;//задаем усиление в зависимости от позиции TrackBar
BASS_FXSetParameters(fx[2], @p);//устанавливаем измененные параметры
end;

procedure TForm_player.TrackBar5Change(Sender: TObject);
begin
BASS_FXGetParameters(fx[3], @p);//считываем параметры канала
p.fgain := 15-TrackBar5.position;//задаем усиление в зависимости от позиции TrackBar
BASS_FXSetParameters(fx[3], @p);//устанавливаем измененные параметры
end;

procedure TForm_player.TrackBar6Change(Sender: TObject);
begin
BASS_FXGetParameters(fx[4], @p);//считываем параметры канала
p.fgain := 15-TrackBar6.position;//задаем усиление в зависимости от позиции TrackBar
BASS_FXSetParameters(fx[4], @p);//устанавливаем измененные параметры
end;

procedure TForm_player.TrackBar7Change(Sender: TObject);
begin
BASS_FXGetParameters(fx[5], @p);//считываем параметры канала
p.fgain := 15-TrackBar7.position;//задаем усиление в зависимости от позиции TrackBar
BASS_FXSetParameters(fx[5], @p);//устанавливаем измененные параметры
end;

procedure TForm_player.TrackBar8Change(Sender: TObject);
begin
BASS_FXGetParameters(fx[6], @p);//считываем параметры канала
p.fgain := 15-TrackBar8.position;//задаем усиление в зависимости от позиции TrackBar
BASS_FXSetParameters(fx[6], @p);//устанавливаем измененные параметры
end;

procedure TForm_player.TrackBar9Change(Sender: TObject);
begin
BASS_FXGetParameters(fx[7], @p);//считываем параметры канала
p.fgain := 15-TrackBar9.position;//задаем усиление в зависимости от позиции TrackBar
BASS_FXSetParameters(fx[7], @p);//устанавливаем измененные параметры
end;

procedure TForm_player.Button1Click(Sender: TObject);
begin
//проверяем есть ли уже воспроизведение
if mode=play then exit;
//запускаем процедуру проигрывания
player;
end;

procedure TForm_player.Button2Click(Sender: TObject);
begin
//проверяем идт ли произведение
if mode=play then
  begin
    BASS_ChannelPause(Channel);//останавливаем воспроизведение - пауза
  mode:= paused; //устанавливаем playmode -> пауза
  end;
end;

procedure TForm_player.Button3Click(Sender: TObject);
begin
 //установка громкости
    trackbar1.Min:=0;
    trackbar1.Max:=10;
    trackbar1.Position:=5;
  //установка баланса
    trackbar2.Min:=-5;
    trackbar2.Max:=5;
    trackbar2.Position:=0;
//проверяем идет ли воспроизвдение
if mode=play then
  begin
    BASS_ChannelStop(Channel);// останавливаем воспроизведение стоп
    mode:=stop; // устанавливаем playmode - стоп
  end;
end;

procedure TForm_player.Button4Click(Sender: TObject);
var j:integer;
begin
OpenDialog1.Title := 'Open Files';
OpenDialog1.Filter := 'mp3|*.mp3'; //фильтр для файлов
{проверяем если плейлист не пустой то запоминаем номер текущей песни
иначе устанавливаем номер песни в 0 (1 позиция в плей лист)}
if listbox1.Count<>0 then i:=Listbox1.ItemIndex else i:=0;
//диалог открытия окна
if not opendialog1.execute then exit;
begin
  for j := 0 to Opendialog1.Files.Count-1 do
    begin
      // заполняем плей лист
      listbox1.Items.Add(OpenDialog1.Files.Strings[j]); // ExtractFileName только названия файлов
    end;
end;
// запоминаем имя файла текущей песни в плейлисте
Filename:=Listbox1.Items.Strings[i];
//выделяем эту песню в плейлистt
Listbox1.itemindex:=i;
end;

procedure TForm_player.Button5Click(Sender: TObject);
begin
//очистка плейлиста
ListBox1.Clear;
end;

procedure TForm_player.Button6Click(Sender: TObject);
var
i: integer;
p: integer;
SL: TStringList;
begin
openDialog1.Title := 'Open Files';
openDialog1.Filter := 'm3u|*.m3u'; //фильтр для файлов
if OpenDialog1.Execute then begin
SL := TStringList.Create;
try
SL.LoadFromFile(OpenDialog1.FileName);
for i := 0 to SL.Count - 1 do begin
if (Pos('#EXTM3U', SL[i]) > 0) then Continue
else begin
p := pos('#EXTINF', SL[i]);
if p > 0 then p := Pos(',', SL[i]) + 1;
if byte(p > 0)= 0 then ListBox1.AddItem(Copy(SL[i], p, length(SL[i])), nil);
end;
end;
finally
SL.Destroy;
end; end; end;

procedure TForm_player.Button7Click(Sender: TObject);
begin
SaveDialog1.Title := 'Save Files';
SaveDialog1.Filter := 'm3u|*.m3u'; //фильтр для файлов
     if SaveDialog1.Execute then
     begin
     if ExtractFileExt(SaveDialog1.FileName) = '.m3u' then
     SaveList(SaveDialog1.FileName) else SaveList(SaveDialog1.FileName + '.m3u');
     end;
end;

procedure TForm_player.Button8Click(Sender: TObject);
begin
ListBox1.DeleteSelected;
if Listbox1.Items.Count > 0 then Listbox1.Selected[Listbox1.Items.Count-1]:= true
else begin showmessage('Плейлист пуст');exit;
end;  end;

procedure TForm_player.Button9Click(Sender: TObject);
var j:integer;
begin
OpenDialog1.Title := 'Open Files';
OpenDialog1.Filter := 'mp3|*.mp3'; //фильтр для файлов
{проверяем если плейлист не пустой то запоминаем номер текущей песни
иначе устанавливаем номер песни в 0 (1 позиция в плей лист)}
if listbox1.Count<>0 then i:=0;
//диалог открытия окна
if not opendialog1.execute then exit;
begin
//очистка плейлиста
ListBox1.Clear;
  for j := 0 to Opendialog1.Files.Count-1 do
    begin
      // заполняем плей лист
      listbox1.Items.Add(OpenDialog1.Files.Strings[j]); // ExtractFileName только названия файлов
    end;
end;
// запоминаем имя файла текущей песни в плейлисте
Filename:=Listbox1.Items.Strings[i];
//выделяем эту песню в плейлистt
Listbox1.itemindex:=i;
end;

procedure TForm_player.ComboBox1Change(Sender: TObject);
begin
TStyleManager.TrySetStyle(ComboBox1.Text, false);
if combobox1.ItemIndex = 0 then begin
  Spectrum.Pen:=clGray;
  Spectrum.BackColor:=clwhite;
  Spectrum.Peak:=clblack;
  OcilloScope.Pen:=clGray;
  OcilloScope.BackColor:=clwhite;
  CircleScope.Pen:=clGray;
  CircleScope.BackColor:=clwhite;
end;
if combobox1.ItemIndex = 1 then begin
  Spectrum.Pen:=clBlue;
  Spectrum.BackColor:=clwhite;
  Spectrum.Peak:=clNavy;
  OcilloScope.Pen:=clBlue;
  OcilloScope.BackColor:=clwhite;
  CircleScope.Pen:=clBlue;
  CircleScope.BackColor:=clwhite
end;
if combobox1.ItemIndex = 2 then begin
  Spectrum.Pen:=clYellow;
  Spectrum.BackColor:=clSilver;
  Spectrum.Peak:=	clWhite;
  OcilloScope.Pen:=clYellow;
  OcilloScope.BackColor:=clSilver;
  CircleScope.Pen:=clYellow;
  CircleScope.BackColor:=clSilver;
end;
if combobox1.ItemIndex = 3 then begin
  Spectrum.Pen:=clBlue;
  Spectrum.BackColor:=clblack;
  Spectrum.Peak:=clNavy;
  OcilloScope.Pen:=clBlue;
  OcilloScope.BackColor:=clblack;
  CircleScope.Pen:=clBlue;
  CircleScope.BackColor:=clblack;
end;
end;

procedure TForm_player.prevClick(Sender: TObject);
begin
if not FileExists(Filename) then begin showMessage('Файл не существует');exit;end;
if not ListBox1.ItemIndex >= 0 then begin showMessage('Файл не существует');exit;end;
Form_Player.Caption:=ExtractFileName(FileName);
    if i>0 then  begin
    dec(i);
 Filename:=ListBox1.Items.Strings[i];
 ListBox1.ItemIndex:=i;
    mode:=stop;
    player;
    end
    else   begin
     Filename:=ListBox1.Items.Strings[i];
 ListBox1.ItemIndex:=i;
    mode:=stop;
    player;
    end;
end;

procedure TForm_player.RadioGroup2Click(Sender: TObject);
begin
  CircleScope.Mode := Radiogroup2.ItemIndex;
  OcilloScope.Mode := Radiogroup2.ItemIndex;
  Spectrum.Mode := Radiogroup2.ItemIndex;
end;

procedure TForm_player.nextClick(Sender: TObject);
begin
if not FileExists(Filename) then begin showMessage('Файл не существует');exit;end;
if not ListBox1.ItemIndex >= 0 then begin showMessage('Файл не существует');exit;end;
Form_Player.Caption:=ExtractFileName(FileName);
  if i<listBox1.Items.Count-1 then begin
         inc(i);
 Filename:=ListBox1.Items.Strings[i];
 ListBox1.ItemIndex:=i;
    mode:=stop;
    player;
  end else begin
  Filename:=ListBox1.Items.Strings[i];
 ListBox1.ItemIndex:=i;
    mode:=stop;
    player;
  end;
end;

procedure TForm_player.FormClose(Sender: TObject; var Action: TCloseAction);
var n:integer;
begin
//сохраняем настройки в inifile
//форма
  IniFile.WriteInteger('Form info','Left',Left);
  IniFile.WriteInteger('Form info','Top',Top);
  IniFile.WriteInteger('Form info','Width',Width);
  IniFile.WriteInteger('Form info','Height',Height);
//громкость звука
  IniFile.WriteInteger('Volue','trackbar1.position',trackbar1.position);
//эквалайзер
  IniFile.WriteInteger('EQLayzer','trackbar3.position',trackbar3.position);
  IniFile.WriteInteger('EQLayzer','trackbar4.position',trackbar4.position);
  IniFile.WriteInteger('EQLayzer','trackbar5.position',trackbar5.position);
  IniFile.WriteInteger('EQLayzer','trackbar6.position',trackbar6.position);
  IniFile.WriteInteger('EQLayzer','trackbar7.position',trackbar7.position);
  IniFile.WriteInteger('EQLayzer','trackbar8.position',trackbar8.position);
  IniFile.WriteInteger('EQLayzer','trackbar9.position',trackbar9.position);
  IniFile.WriteInteger('EQLayzer','trackbar10.position',trackbar10.position);
  IniFile.WriteInteger('EQLayzer','trackbar11.position',trackbar11.position);
  IniFile.WriteInteger('EQLayzer','trackbar12.position',trackbar12.position);
//количество файлов в PlayList
  IniFile.WriteInteger('ItemsCount','Count',ListBox1.Items.Count);
//очистка секции PlayList
  IniFile.EraseSection('PlayList');
//выгрузка из PlayList
  for n := 0 to ListBox1.Items.Count - 1 do
  IniFile.WriteString('PlayList', 'file' + IntToStr(n+1), ListBox1.Items.Strings[n]);
//Время создания PlayList
  IniFile.WriteTime('Time','Write time',Time);
//Освобождаем объекты перед закрытием
  IniFile.Free;
//Освобождаем обьекты перед закрытием
BASS_Stop();
  BASS_StreamFree(channel);// освобождаем звуковой канал
  BASS_Free;// Освобождаем ресурсы используемые BAss
end;

procedure TForm_player.FormCreate(Sender: TObject);
var
  n, count:integer;
 sm: TStyleManager;
 i: integer;
begin
//проверяем корректности загруженной BASS.Dll
if (HIWORD(BASS_GetVersion) <> BASSVERSION) then
begin
    MessageBox(0, 'Не корректная версия BASS.DLL',nil,MB_ICONERROR);
    Halt;
end;
// Инициализация аудио - по умолчанию, 44100hz, stereo, 16 bits
if not BASS_Init(-1, 44100, 0, Handle, nil) then
begin
            MessageBox(0, 'Ошибка инициализации аудио',nil,MB_ICONERROR);
            halt;
end;
Spectrum    := TSpectrum.Create(PB1.Width, Pb1.Height);
CircleScope := TCircleScope.Create(PB1.Width, Pb1.Height);
OcilloScope := TOcilloScope.Create(PB1.Width, PB1.Height);
  Spectrum.Pen:=clBlue;
  Spectrum.BackColor:=clblack;
  Spectrum.Peak:=clNavy;
  OcilloScope.Pen:=clBlue;
  OcilloScope.BackColor:=clblack;
  CircleScope.Pen:=clBlue;
  CircleScope.BackColor:=clblack;
begin
  sm := TStyleManager.Create;
  for i := 0 to Length(sm.StyleNames)-1 do
    ComboBox1.Items.Add(sm.StyleNames[i]);
end;
//создание inifile  с именем Config.ini
IniFile:=TIniFile.Create(ExtractFilePath(Application.ExeName)+'Config.ini');
//загрузка настроек из inifile
//положение формы и размер
  form_player.Left:=IniFile.ReadInteger('Form info','Left',285);
  form_player.Top:=IniFile.ReadInteger('Form info','Top',168);
  form_player.Width:=IniFile.ReadInteger('Form info','Width',508);
  form_player.Height:=IniFile.ReadInteger('Form info','Height',544);
//громкость звука
  trackbar1.position:=IniFile.ReadInteger('Volue','trackbar1.position',5);
//настройки эквалайзера
  trackbar3.position:=IniFile.ReadInteger('EQLayzer','trackbar3.position',15);
  trackbar4.position:=IniFile.ReadInteger('EQLayzer','trackbar4.position',15);
  trackbar5.position:=IniFile.ReadInteger('EQLayzer','trackbar5.position',15);
  trackbar6.position:=IniFile.ReadInteger('EQLayzer','trackbar6.position',15);
  trackbar7.position:=IniFile.ReadInteger('EQLayzer','trackbar7.position',15);
  trackbar8.position:=IniFile.ReadInteger('EQLayzer','trackbar8.position',15);
  trackbar9.position:=IniFile.ReadInteger('EQLayzer','trackbar9.position',15);
  trackbar10.position:=IniFile.ReadInteger('EQLayzer','trackbar10.position',15);
  trackbar11.position:=IniFile.ReadInteger('EQLayzer','trackbar11.position',15);
  trackbar12.position:=IniFile.ReadInteger('EQLayzer','trackbar12.position',15);
//количество записей в плейлисте
  Count:=IniFile.ReadInteger('ItemsCount','Count',0);
//загрузка плейлиста
  if Count<>0 then
  begin
   for n := 0 to Count - 1 do
    ListBox1.Items.Add(IniFile.ReadString('PlayList', 'file' + IntToStr(n+1),'Ошибка чтения'));
//установка на первую запись плейлиста
    Filename:=ListBox1.Items.Strings[0];
    ListBox1.ItemIndex:=0;
  end;
end;

procedure TForm_player.ListBox1DblClick(Sender: TObject);
begin
 i:=ListBox1.Itemindex;
 Filename:=ListBox1.Items.Strings[i];
 mode:=stop;
 player;
end; end.
