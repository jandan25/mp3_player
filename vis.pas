unit vis;
{ Circle Visualyzation by Alessandro Cappellozza
  version 0.5 05/2002
  http://digilander.iol.it/Kappe/audioobject
}

interface
  uses Windows, Dialogs, Graphics, SysUtils, Classes;

 type

 TWaveData = array [ 0..2048] of DWORD;
 Type TFFTData  = array [0..512] of Single;
 TOcilloScope = Class(TObject)
    private
      VisBuff : TBitmap;
      BackBmp : TBitmap;

      BkgColor : TColor;
      ScopeOff : Integer;
      PenColor : TColor;
      DrawType : Integer;
      DrawRes  : Integer;
      FrmClear : Boolean;
      UseBkg   : Boolean;

    public
     Constructor Create (Width, Height : Integer);
     procedure Draw(HWND : THandle; WaveData : TWaveData; X, Y : Integer);
     procedure SetBackGround (Active : Boolean; BkgCanvas : TGraphic);

     property BackColor : TColor read BkgColor write BkgColor;
     property Offset : Integer read ScopeOff write ScopeOff;
     property Pen  : TColor read PenColor write PenColor;
     property Mode : Integer read DrawType write DrawType;
     property Res  : Integer read DrawRes write DrawRes;
     property FrameClear : Boolean read FrmClear write FrmClear;
  end;

 TCircleScope = Class(TObject)
    private
      VisBuff : TBitmap;
      BackBmp : TBitmap;

      BkgColor : TColor;
      ScopeRad : Integer;
      ScopeOff : Integer;
      PenColor : TColor;
      DrawType : Integer;
      DrawRes  : Integer;
      FrmClear : Boolean;
      UseBkg   : Boolean;

    public
     Constructor Create (Width, Height : Integer);
     procedure Draw(HWND : THandle; WaveData : TWaveData; X, Y : Integer);

     property BackColor : TColor read BkgColor write BkgColor;
     property Radius : Integer read ScopeRad write ScopeRad;
     property Offset : Integer read ScopeOff write ScopeOff;
     property Pen  : TColor read PenColor write PenColor;
     property Mode : Integer read DrawType write DrawType;
     property Res  : Integer read DrawRes write DrawRes;
     property FrameClear : Boolean read FrmClear write FrmClear;
 End;
     TSpectrum = Class(TObject)
    private
      VisBuff : TBitmap;
      BackBmp : TBitmap;

      BkgColor : TColor;
      SpecHeight : Integer;
      PenColor : TColor;
      PeakColor: TColor;
      DrawType : Integer;
      DrawRes  : Integer;
      FrmClear : Boolean;
      UseBkg   : Boolean;
      PeakFall : Integer;
      LineFall : Integer;
      ColWidth : Integer;
      ShowPeak : Boolean;

       FFTPeacks  : array [0..512] of Integer;
       FFTFallOff : array [0..512] of Integer;

    public
     Constructor Create (Width, Height : Integer);
     procedure Draw(HWND : THandle; FFTData : TFFTData; X, Y : Integer);

     property BackColor : TColor read BkgColor write BkgColor;
     property Height : Integer read SpecHeight write SpecHeight;
     property Width  : Integer read ColWidth write ColWidth;
     property Pen  : TColor read PenColor write PenColor;
     property Peak : TColor read PeakColor write PeakColor;
     property Mode : Integer read DrawType write DrawType;
     property Res  : Integer read DrawRes write DrawRes;
     property FrameClear : Boolean read FrmClear write FrmClear;
     property PeakFallOff: Integer read PeakFall write PeakFall;
     property LineFallOff: Integer read LineFall write LineFall;
     property DrawPeak   : Boolean read ShowPeak write ShowPeak;
  end;

 var CircleScope : TCircleScope;
  OcilloScope : TOcilloScope;
  Spectrum : TSpectrum;

implementation

     Constructor TCircleScope.Create(Width, Height : Integer);
      begin
        VisBuff := TBitmap.Create;
        BackBmp := TBitmap.Create;

          VisBuff.Width := Width;
          VisBuff.Height := Height;
          BackBmp.Width := Width;
          BackBmp.Height := Height;

          BkgColor := clBlack;
          ScopeRad := 30;
          ScopeOff := 30;
          PenColor := clWhite;
          DrawType := 0;
          DrawRes  := 2;
          FrmClear := True;
          UseBkg := False;
      end;
Constructor TOcilloScope.Create(Width, Height : Integer);
      begin
        VisBuff := TBitmap.Create;
        BackBmp := TBitmap.Create;

          VisBuff.Width := Width;
          VisBuff.Height := Height;
          BackBmp.Width := Width;
          BackBmp.Height := Height;

          BkgColor := clBlack;
          ScopeOff := 50;
          PenColor := clWhite;
          DrawType := 0;
          DrawRes  := 1;
          FrmClear := True;
          UseBkg := False;
      end;
Constructor TSpectrum.Create(Width, Height : Integer);
      begin
        VisBuff := TBitmap.Create;
        BackBmp := TBitmap.Create;

          VisBuff.Width := Width;
          VisBuff.Height := Height;
          BackBmp.Width := Width;
          BackBmp.Height := Height;

          BkgColor := clBlack;
          SpecHeight := 100;
          PenColor := clWhite;
          PeakColor := clYellow;
          DrawType := 0;
          DrawRes  := 1;
          FrmClear := True;
          UseBkg := False;
          PeakFall := 1;
          LineFall := 3;
          ColWidth := 5;
          ShowPeak := True;
      end;

     procedure TCircleScope.Draw(HWND : THandle; WaveData : TWaveData; X, Y : Integer);

        var i, Rd : Integer; Angle : Single; R, L : SmallInt;
       begin
       if FrmClear then begin
        VisBuff.Canvas.Pen.Color := BkgColor;
        VisBuff.Canvas.Brush.Color := BkgColor;
        VisBuff.Canvas.Rectangle(0, 0, VisBuff.Width, VisBuff.Height);
         if UseBkg then VisBuff.Canvas.CopyRect(Rect(0, 0, BackBmp.Width, BackBmp.Height), BackBmp.Canvas, Rect(0, 0, BackBmp.Width, BackBmp.Height));
       end;

        VisBuff.Canvas.Pen.Color := PenColor;
              R := LOWORD(WaveData[0]);
              L := HIWORD(WaveData[0]);
              Rd := Trunc(((R + L) / (2 * 65535)) * ScopeOff) + ScopeRad;
              VisBuff.Canvas.MoveTo(X, Y + Rd);

         for i := 1 to 256 do begin
             Angle := (i /256) * (6.28);
              R := LOWORD(WaveData[i * DrawRes]);
              L := HIWORD(WaveData[i * DrawRes]);
              Rd := Trunc(((R + L) / (2 * 65535)) * ScopeOff) + ScopeRad;

              case DrawType of
                0 : VisBuff.Canvas.lineto(X + Trunc(sin(Angle) * Rd), Y + Trunc(cos(Angle) * Rd));

                1 : begin
                      VisBuff.Canvas.MoveTo(X, Y);
                      VisBuff.Canvas.lineto(X + Trunc(sin(Angle) * Rd), Y + Trunc(cos(Angle) * Rd));
                    end;

                2 : VisBuff.Canvas.Pixels[X + Trunc(sin(Angle) * Rd), Y + Trunc(cos(Angle) * Rd)] := PenColor;
              end;
         end;

              R := LOWORD(WaveData[0]);
              L := HIWORD(WaveData[0]);
              Rd := Trunc(((R + L) / (2 * 65535)) * ScopeOff) + ScopeRad;
              VisBuff.Canvas.lineto(X, Y + Rd);

          BitBlt(HWND, 0, 0, VisBuff.Width, VisBuff.Height, VisBuff.Canvas.Handle, 0, 0, srccopy)
       end;

    procedure TOcilloScope.SetBackGround (Active : Boolean; BkgCanvas : TGraphic);
      begin
        UseBkg := Active;
        BackBmp.Canvas.Draw(0, 0, BkgCanvas);
      end;

     procedure TOcilloScope.Draw(HWND : THandle; WaveData : TWaveData; X, Y : Integer);
        var i, YPos : LongInt; R, L : SmallInt;
       begin
       if FrmClear then begin
         VisBuff.Canvas.Pen.Color := BkgColor;
         VisBuff.Canvas.Brush.Color := BkgColor;
         if UseBkg then
           BitBlt(VisBuff.Canvas.Handle,         // Destination
                  0, 0,                          // X, Y (target pos)
                  VisBuff.Width, VisBuff.Height, // Size to copy
                  BackBmp.Canvas.handle,         // Source
                  0, 0,                          // X, Y (source pos)
                  SrcCopy)                       // plain copy
         else
           VisBuff.Canvas.Rectangle(0, 0, VisBuff.Width, VisBuff.Height) // only if no background
       end;

        VisBuff.Canvas.Pen.Color := PenColor;
            R :=  SmallInt(LOWORD(WaveData[0]));
            L := SmallInt(HIWORD(WaveData[0]));
            YPos := Trunc(((R + L) / (2 * 65535)) * ScopeOff) ;
            VisBuff.Canvas.MoveTo(X , Y + YPos);

         for i := 1 to 512 do begin
            R := SmallInt(Loword(WaveData[i * DrawRes]));
            L := SmallInt(HIword(WaveData[i * DrawRes]));
            YPos := Trunc(((R + L) / (2 * 65535)) * ScopeOff) ;

              case DrawType of
                0 : VisBuff.Canvas.lineto(X + i, Y + YPos);

                1 : begin
                      VisBuff.Canvas.MoveTo(X + i, Y);
                      VisBuff.Canvas.lineto(X + i, Y + YPos);
                    end;

                2 : VisBuff.Canvas.Pixels[X + i,  Y + YPos] := PenColor;
              end;
         end;

          BitBlt(HWND, 0, 0, VisBuff.Width, VisBuff.Height, VisBuff.Canvas.Handle, 0, 0, srccopy)
       end;

     procedure TSpectrum.Draw(HWND : THandle; FFTData : TFFTData; X, Y : Integer);
        var i, YPos : LongInt; YVal : Single;
       begin

       if FrmClear then begin
          VisBuff.Canvas.Pen.Color := BkgColor;
          VisBuff.Canvas.Brush.Color := BkgColor;
          VisBuff.Canvas.Rectangle(0, 0, VisBuff.Width, VisBuff.Height);
           if UseBkg then VisBuff.Canvas.CopyRect(Rect(0, 0, BackBmp.Width, BackBmp.Height), BackBmp.Canvas, Rect(0, 0, BackBmp.Width, BackBmp.Height));
       end;

        VisBuff.Canvas.Pen.Color := PenColor;
         for i := 0 to 256 do begin
           YVal := Abs(FFTData[(i * DrawRes) + 5]);
           YPos := Trunc((YVal) * 500);
           if YPos > Height then YPos := SpecHeight;

           if YPos >= FFTPeacks[i] then FFTPeacks[i] := YPos
              else FFTPeacks[i] := FFTPeacks[i] - PeakFall;

           if YPos >= FFTFallOff[i] then FFTFallOff[i] := YPos
              else FFTFallOff[i] := FFTFallOff[i] - LineFall;

              if (VisBuff.Height - FFTPeacks[i]) > VisBuff.Height then FFTPeacks[i] := 0;
              if (VisBuff.Height - FFTFallOff[i]) > VisBuff.Height then FFTFallOff[i] := 0;

              case DrawType of
                0 : begin
                       VisBuff.Canvas.MoveTo(X + i, Y + VisBuff.Height);
                       VisBuff.Canvas.LineTo(X + i, Y + VisBuff.Height - FFTFallOff[i]);
                       if ShowPeak then VisBuff.Canvas.Pixels[X + i, Y + VisBuff.Height - FFTPeacks[i]] := Pen;
                    end;

                1 : begin
                     if ShowPeak then VisBuff.Canvas.Pen.Color := PeakColor;
                     if ShowPeak then VisBuff.Canvas.MoveTo(X + i * (ColWidth + 1), Y + VisBuff.Height - FFTPeacks[i]);
                     if ShowPeak then VisBuff.Canvas.LineTo(X + i * (ColWidth + 1) + ColWidth, Y + VisBuff.Height - FFTPeacks[i]);

                     VisBuff.Canvas.Pen.Color := PenColor;
                     VisBuff.Canvas.Brush.Color := PenColor;
                     VisBuff.Canvas.Rectangle(X + i * (ColWidth + 1), Y + VisBuff.Height - FFTFallOff[i], X + i * (ColWidth + 1) + ColWidth, Y + VisBuff.Height);
                    end;
              end;
         end;

          BitBlt(HWND, 0, 0, VisBuff.Width, VisBuff.Height, VisBuff.Canvas.Handle, 0, 0, srccopy)
       end;

       end.

