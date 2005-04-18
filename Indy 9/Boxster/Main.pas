{ $HDR$}
{**********************************************************************}
{ Unit archived using Team Coherence                                   }
{ Team Coherence is Copyright 2002 by Quality Software Components      }
{                                                                      }
{ For further information / comments, visit our WEB site at            }
{ http://www.TeamCoherence.com                                         }
{**********************************************************************}
{}
{ $Log:  20159: Main.pas 
{
{   Rev 1.0    2003.06.12 1:01:36 PM  czhower
{ Recheckin
}
unit Main;

interface

uses
  DecoderBox,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, Menus, ActnList, ImgList, ToolWin, ExtCtrls, StdCtrls;

type
  TformMain = class(TForm)
    lboxMessages: TListBox;
    Splitter1: TSplitter;
    alstMain: TActionList;
    MainMenu1: TMainMenu;
    PopupMenu1: TPopupMenu;
    ToolBar1: TToolBar;
    ImageList1: TImageList;
    actnFile_Exit: TAction;
    actnTest_Test: TAction;
    File1: TMenuItem;
    actnFileTest1: TMenuItem;
    Exit1: TMenuItem;
    ToolButton1: TToolButton;
    Panel2: TPanel;
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    lablFilename: TLabel;
    lablAttachments: TLabel;
    lablTextParts: TLabel;
    pctlMessage: TPageControl;
    tshtBody: TTabSheet;
    memoBody: TMemo;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    lboxAttachments: TListBox;
    lboxTextParts: TListBox;
    Splitter2: TSplitter;
    Splitter3: TSplitter;
    actnTest_Emit: TAction;
    Exit2: TMenuItem;
    Emit1: TMenuItem;
    Emit2: TMenuItem;
    TabSheet1: TTabSheet;
    memoRaw: TMemo;
    actnTest_Verify: TAction;
    estandVerify1: TMenuItem;
    estandVerify2: TMenuItem;
    eset1: TMenuItem;
    Panel3: TPanel;
    memoTextPart: TMemo;
    memoTextPartHeader: TMemo;
    Splitter4: TSplitter;
    Panel4: TPanel;
    Splitter5: TSplitter;
    memoAttachment: TMemo;
    memoAttachmentHeader: TMemo;
    Label4: TLabel;
    lablErrors: TLabel;
    N1: TMenuItem;
    actnTest_VerifyAll: TAction;
    VerifyAll1: TMenuItem;
    procedure actnFile_ExitExecute(Sender: TObject);
    procedure actnTest_TestExecute(Sender: TObject);
    procedure alstMainUpdate(Action: TBasicAction; var Handled: Boolean);
    procedure lboxMessagesDblClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lboxTextPartsDblClick(Sender: TObject);
    procedure lboxAttachmentsDblClick(Sender: TObject);
    procedure actnTest_VerifyAllExecute(Sender: TObject);
  private
  protected
    FDataPath: string;
    FDecoderBox: TDecoderBox;
  public
  end;

var
  formMain: TformMain;

implementation
{$R *.dfm}

uses
  IdGlobal, IdMessage;

procedure TformMain.actnFile_ExitExecute(Sender: TObject);
begin
  Close;
end;

procedure TformMain.actnTest_TestExecute(Sender: TObject);
var
  i: Integer;
  LFilename: string;
begin
  Screen.Cursor := crHourglass; try
    try
      if Assigned(FDecoderBox) then begin
        FreeAndNil(FDecoderBox);
      end;
      lablErrors.Caption := '';
      LFilename := Copy(lboxMessages.Items[lboxMessages.ItemIndex], 3, MaxInt);
      FDecoderBox := TDecoderBox.Create(Self);
      memoRaw.Lines.LoadFromFile(FDataPath + LFilename);
      with FDecoderBox do begin
        TestMessage(FDataPath + LFilename, Sender = actnTest_Verify, Sender = actnTest_Emit);
        //
        lablFilename.Caption := LFilename;
        lablAttachments.Caption := IntToStr(AttCount) + ' / ' + IntToStr(AttCountExpected);
        lablTextParts.Caption := IntToStr(TextCount) + ' / ' + IntToStr(TextCountExpected);;
        memoBody.Lines.Assign(Msg.Body);
        //
        lboxAttachments.Clear;
        memoAttachment.Clear;
        lboxTextParts.Clear;
        memoTextPart.Clear;
        for i := 0 to Msg.MessageParts.Count - 1 do begin
          if Msg.MessageParts[i] is TIdText then begin
            lboxTextParts.Items.AddObject(IntToStr(i), TIdText(Msg.MessageParts[i]));
          end else if Msg.MessageParts[i] is TIdAttachment then begin
            lboxAttachments.Items.AddObject(TIdAttachment(
             Msg.MessageParts[i]).Filename, Msg.MessageParts[i]);
          end else begin
            raise Exception.Create('Unknown message part type.');
          end;
        end;
      end;
      lboxMessages.Items[lboxMessages.ItemIndex] := '+'
       + Copy(lboxMessages.Items[lboxMessages.ItemIndex], 2, MaxInt);
    except
      on E: Exception do begin
        lablErrors.Caption := E.Message;
        lboxMessages.Items[lboxMessages.ItemIndex] := '-'
         + Copy(lboxMessages.Items[lboxMessages.ItemIndex], 2, MaxInt);
      end;
    end;
  finally Screen.Cursor := crDefault; end;
end;

procedure TformMain.alstMainUpdate(Action: TBasicAction; var Handled: Boolean);
begin
  actnTest_Test.Enabled := lboxMessages.ItemIndex > -1;
  Handled := True;
end;

procedure TformMain.lboxMessagesDblClick(Sender: TObject);
begin
  // Here instead of linked at design because of .Enabled
  actnTest_Verify.Execute;
end;

procedure TformMain.FormCreate(Sender: TObject);
var
  i: integer;
  LRec: TSearchRec;
begin
  pctlMessage.ActivePage := tshtBody;
  FDataPath := ExtractFilePath(ParamStr(0)) + 'DecoderBox' + GPathDelim;
  i := FindFirst(FDataPath +  '*.msg', faAnyFile, LRec); try
    while i = 0 do begin
      lboxMessages.Items.Add('  ' + LRec.Name);
      i := FindNext(LRec);
    end;
  finally FindClose(LRec); end;
end;

procedure TformMain.lboxTextPartsDblClick(Sender: TObject);
var
  LText: TIdText;
begin
  if lboxTextParts.ItemIndex > -1 then begin
    LText := TIdText(lboxTextParts.Items.Objects[lboxTextParts.ItemIndex]);
    memoTextPartHeader.Lines.Assign(LText.Headers);
    memoTextPart.Lines.Assign(LText.Body);
  end;
end;

procedure TformMain.lboxAttachmentsDblClick(Sender: TObject);
var
  LAttachment: TIdAttachment;
begin
  if lboxAttachments.ItemIndex > -1 then begin
    LAttachment := TIdAttachment(lboxAttachments.Items.Objects[lboxAttachments.ItemIndex]);
    memoAttachmentHeader.Lines.Assign(LAttachment.Headers);
    memoAttachment.Lines.LoadFromFile(LAttachment.StoredPathname);
  end;
end;

procedure TformMain.actnTest_VerifyAllExecute(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to lboxMessages.Items.Count - 1 do begin
    lboxMessages.ItemIndex := i;
    actnTest_Verify.Execute;
  end;
end;

end.
