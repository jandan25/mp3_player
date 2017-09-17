program mp3player;

uses
  Vcl.Forms,
  mp3 in 'mp3.pas' {Form_player},
  bass in 'bass.pas',
  vis in 'vis.pas',
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Cobalt XEMedia');
  Application.CreateForm(TForm_player, Form_player);
  Application.Run;
end.
