{ ============================================
  Software Name : 	SMC
  ============================================ }
{ ******************************************** }
{ Written By WalWalWalides }
{ CopyRight � 2019 }
{ Email : WalWalWalides@gmail.com }
{ GitHub :https://github.com/walwalwalides }
{ ******************************************** }
unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, CPort, CPortCtl, Vcl.Samples.Spin, Vcl.Buttons, Vcl.ComCtrls, UOLEDControls, UOLEDPanel, Vcl.WinXCtrls, System.Actions, Vcl.ActnList,
  Vcl.Menus;

const
  iniSetting = 'ConnectionSetting.ini';

type
  TModeControle = (MdNormal, MdTimer);

type
  TfrmMain = class(TForm)
    ComPort: TComPort;
    Memo: TMemo;
    chkBoucle: TCheckBox;
    spedtSeg: TSpinEdit;
    Button_Open: TBitBtn;
    Button_Settings: TBitBtn;
    Bt_Store: TBitBtn;
    Bt_Load: TBitBtn;
    GrBoxIniFile: TGroupBox;
    GrBoxControle: TGroupBox;
    bvlbottom: TBevel;
    tmr7Seg: TTimer;
    BitBtnTimer: TBitBtn;
    TrackBarSpeed: TTrackBar;
    lblValue1: TLabel;
    lblValue2: TLabel;
    OLEDPanel1: TOLEDPanel;
    SMCPotentiometer1: TOLEDPotentiometer;
    OLEDPanel2: TOLEDPanel;
    SMCPotentiometer2: TOLEDPotentiometer;
    bvlVertical: TBevel;
    BitBtnRotation: TBitBtn;
    ToggleSwitchRot: TToggleSwitch;
    MMMain: TMainMenu;
    File1: TMenuItem;
    Exit1: TMenuItem;
    N1: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N3: TMenuItem;
    T1: TMenuItem;
    N11: TMenuItem;
    N21: TMenuItem;
    N51: TMenuItem;
    N12: TMenuItem;
    A2: TMenuItem;
    actAbout1: TMenuItem;
    N2: TMenuItem;
    ActionList1: TActionList;
    actOpenFile: TAction;
    actShowInExplorer: TAction;
    actOpenFolder: TAction;
    actExit: TAction;
    actOption: TAction;
    actAbout: TAction;
    acDisChart: TAction;
    acDisLogging: TAction;
    procedure Button_OpenClick(Sender: TObject);
    procedure Button_SettingsClick(Sender: TObject);
    procedure ComPortOpen(Sender: TObject);
    procedure ComPortClose(Sender: TObject);
    procedure ComPortRxChar(Sender: TObject; Count: Integer);
    procedure Bt_LoadClick(Sender: TObject);
    procedure Bt_StoreClick(Sender: TObject);
    procedure spedtSegChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure chkBoucleClick(Sender: TObject);
    procedure tmr7SegTimer(Sender: TObject);
    procedure BitBtnTimerClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure TrackBarSpeedChange(Sender: TObject);
    procedure SMCPotentiometer2Changed(Sender: TObject; index, value: Integer);
    procedure SMCPotentiometer1Changed(Sender: TObject; index, value: Integer);
    procedure BitBtnRotationClick(Sender: TObject);
    procedure ToggleSwitchRotClick(Sender: TObject);
    procedure actAboutExecute(Sender: TObject);
    procedure actExitExecute(Sender: TObject);
  private
    procedure SendValuetoSMC(AIndex: Integer);
    procedure SerialConnection;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

uses About;

{$R *.DFM}

var
  Str: string;
  ModeCon: TModeControle;
  MainPath: string;

  arr: array [0 .. 9] of string = (
    '0#',
    '1#',
    '2#',
    '3#',
    '4#',
    '5#',
    '6#',
    '7#',
    '8#',
    '9#'
  );
  kpos: Byte = 0;

procedure TfrmMain.Button_OpenClick(Sender: TObject);
begin
  if (tmr7Seg.Enabled) then
    tmr7Seg.Enabled := False;
  if ComPort.Connected then
    ComPort.Close
  else
    ComPort.Open;
end;

procedure TfrmMain.Button_SettingsClick(Sender: TObject);
begin
  ComPort.ShowSetupDialog;
  ComPort.StoreSettings(stIniFile, MainPath);
end;

procedure TfrmMain.chkBoucleClick(Sender: TObject);
begin
  //
end;

procedure TfrmMain.SendValuetoSMC(AIndex: Integer);
begin
  Str := '';
  if (ToggleSwitchRot.State = tssOff) and (AIndex = 1) then
  begin
    Str := IntToStr(SMCPotentiometer1.value);
    Str := Str + '-'+sLineBreak;
    // Str := Str + AnsiString(#13#10);
  end;
  if (ToggleSwitchRot.State = tssOn) and (AIndex = 2) then
  begin
    Str := IntToStr(SMCPotentiometer2.value);
    Str := Str + '+'+sLineBreak;
  end;
end;

procedure TfrmMain.SerialConnection;
begin
  if ComPort.Connected then
    ComPort.Close
  else
    ComPort.Open;
end;

procedure TfrmMain.ComPortOpen(Sender: TObject);
begin
  Button_Open.Caption := 'Not Connect';

end;

procedure TfrmMain.ComPortClose(Sender: TObject);
begin
  if Button_Open <> nil then
    Button_Open.Caption := 'Connect';
end;

procedure TfrmMain.ComPortRxChar(Sender: TObject; Count: Integer);
var
  Str: String;
begin
  ComPort.ReadStr(Str, Count);

  if (ModeCon = MdTimer) then
  begin
    Memo.Text := Memo.Text + Str;
    Memo.Lines.Delete(Memo.Lines.Count - 2);
  end;

  if (ModeCon = MdNormal) then
  begin
    Memo.Text := Memo.Text + Str;
  end;

end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if (tmr7Seg.Enabled) then
  begin
    tmr7Seg.Enabled := False;
  end;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  // initial spinedit
  spedtSeg.MinValue := 0;
  spedtSeg.maxValue := 9;
  spedtSeg.EditorEnabled := False;
  // frmMain.WindowState := wsMaximized;
  ComPort.BaudRate := br115200; // Set Default BaudRate
  // ------------------------------------- //
  TrackBarSpeed.Min := 0;
  TrackBarSpeed.Max := 100;

  MainPath := ExtractFilePath(Application.exename) + iniSetting;
  ModeCon := MdNormal;

  OLEDPanel1.font.Size := 21;
  SMCPotentiometer1.Margins.Top := 15;
  SMCPotentiometer1.Margins.Left := 15;
  SMCPotentiometer1.Margins.Right := 15;
  SMCPotentiometer1.Margins.Bottom := 15;
  // ---------------------------------------------  //
  SMCPotentiometer2.Margins.Top := 15;
  SMCPotentiometer2.Margins.Left := 15;
  SMCPotentiometer2.Margins.Right := 15;
  SMCPotentiometer2.Margins.Bottom := 15;
  TrackBarSpeed.Position:=0;
end;

procedure TfrmMain.FormShow(Sender: TObject);
begin

  // Check iniFile Exist
  if FileExists(MainPath) then
  begin
    ComPort.LoadSettings(stIniFile, MainPath);
    SerialConnection;
  end
  else
  begin
    ComPort.ShowSetupDialog;
    ComPort.StoreSettings(stIniFile, MainPath);
    SerialConnection;
  end;

end;

procedure TfrmMain.SMCPotentiometer1Changed(Sender: TObject; index, value: Integer);
begin
  //
  OLEDPanel1.Caption := value.ToString;
  SendValuetoSMC(1);
end;

procedure TfrmMain.SMCPotentiometer2Changed(Sender: TObject; index, value: Integer);
begin
  OLEDPanel2.Caption := value.ToString;
  SendValuetoSMC(2);
end;

procedure TfrmMain.spedtSegChange(Sender: TObject);
begin
  //
end;

procedure TfrmMain.tmr7SegTimer(Sender: TObject);
begin
  ComPort.WriteStr(arr[kpos]);
  if (kpos = 9) then
    kpos := 0
  else
    inc(kpos, 1);
end;

procedure TfrmMain.ToggleSwitchRotClick(Sender: TObject);
begin

  if (ToggleSwitchRot.State = tssOff) then
  begin
    SendValuetoSMC(1);
  end;

  if (ToggleSwitchRot.State = tssOn) then
  begin
    SendValuetoSMC(2);
  end;

end;

procedure TfrmMain.TrackBarSpeedChange(Sender: TObject);
//var
//intPosition:integer;
begin
 //

// intPosition:=TrackBarSpeed.value;
//
// lblSpeed.Caption:=intPosition.ToString;
end;

procedure TfrmMain.actAboutExecute(Sender: TObject);
var
  F: TfrmAbout;
begin

  inherited;
  if not Assigned(F) then
    Application.CreateForm(TfrmAbout, F);
  F.Position := poMainFormCenter;
  try
    F.ShowModal;
  finally
    FreeAndNil(F);
  end;

end;

procedure TfrmMain.actExitExecute(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TfrmMain.BitBtnRotationClick(Sender: TObject);
begin

  if (Str <> '') then
  begin
    if (ToggleSwitchRot.State = tssOff) then
    begin
      if (pos('-', Str) > 0) then
      begin
         ComPort.WriteStr(Str);
         Str:='';
      end;
    end;

    if (ToggleSwitchRot.State = tssOn) then
    begin
      if (pos('+', Str) > 0) then
      begin
        ComPort.WriteStr(Str);
        Str:='';
      end;
    end;

  end
  else
  begin

     if (ToggleSwitchRot.State = tssOff) then
    begin
      if (TrackBarSpeed.Position > 0) then
      begin
         if (chkBoucle.Checked) then
        begin
         Str:=TrackBarSpeed.Position.ToString+'T-'+sLineBreak;
        end;

        ComPort.WriteStr(Str);
        Str:='';
      end;
    end;

    if (ToggleSwitchRot.State = tssOn) then
    begin
      if (TrackBarSpeed.Position > 0) then
      begin
         if (chkBoucle.Checked) then
         begin
          Str:=TrackBarSpeed.Position.ToString+'T+'+sLineBreak;
         end;
        ComPort.WriteStr(Str);
        Str:='';
      end;
    end;



  end;
end;

procedure TfrmMain.BitBtnTimerClick(Sender: TObject);
begin
    Memo.Clear;
    Memo.Lines[0] := 'Motor Speed -> '+TrackBarSpeed.Position.ToString;;
    Str:='';
    Str:='S'+TrackBarSpeed.Position.ToString+sLineBreak;
    ComPort.WriteStr(Str);

end;

procedure TfrmMain.Bt_LoadClick(Sender: TObject);
begin
  ComPort.LoadSettings(stIniFile, MainPath);
end;

procedure TfrmMain.Bt_StoreClick(Sender: TObject);
begin
  ComPort.StoreSettings(stIniFile, MainPath);
end;

end.
