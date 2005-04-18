{ $HDR$}
{**********************************************************************}
{ Unit archived using Team Coherence                                   }
{ Team Coherence is Copyright 2002 by Quality Software Components      }
{                                                                      }
{ For further information / comments, visit our WEB site at            }
{ http://www.TeamCoherence.com                                         }
{**********************************************************************}
{}
{ $Log:  19915: BXMain.pas 
{
{   Rev 1.0    2003.06.12 12:58:06 PM  czhower
{ Recheckin
}
unit BXMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ExtCtrls, ActnList,
  INIFiles;

type
  TForm1 = class(TForm)
    ActionList1: TActionList;
    actnTestSelected: TAction;
    pctlMain: TPageControl;
    tshtTests: TTabSheet;
    Panel1: TPanel;
    butnTestCategory: TButton;
    butnTestSelected: TButton;
    butnTestAll: TButton;
    Panel2: TPanel;
    Splitter2: TSplitter;
    lstvTests: TListView;
    lboxCategories: TListBox;
    Panel3: TPanel;
    Splitter3: TSplitter;
    memoMessages: TMemo;
    Memo1: TMemo;
    Splitter1: TSplitter;
    tshtGlobalParams: TTabSheet;
    memoGlobalParams: TMemo;
    procedure butnTestCategoryClick(Sender: TObject);
    procedure actnTestSelectedExecute(Sender: TObject);
    procedure actnTestSelectedUpdate(Sender: TObject);
    procedure lboxCategoriesClick(Sender: TObject);
    procedure butnTestAllClick(Sender: TObject);
  private
    procedure StatusMessage(ASender: TObject; const AMsg: string);
  protected
    FINIFile: TIniFile;
    //
    procedure PerformTest(AItem: TListItem);
    procedure RefreshTestItem(AItem: TListItem);
    procedure TestsBegin;
    procedure TestsEnd;
    procedure UpdateBoxList;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

var
  Form1: TForm1;

implementation
{$R *.DFM}

uses
  BXBoxster;
  
procedure TForm1.butnTestCategoryClick(Sender: TObject);
var
  i: Integer;
begin
  TestsBegin; try
    for i := 0 to lstvTests.Items.Count - 1 do begin
      PerformTest(lstvTests.Items[i]);
    end;
  finally TestsEnd; end;
end;

procedure TForm1.actnTestSelectedExecute(Sender: TObject);
begin
  TestsBegin; try
    PerformTest(lstvTests.Selected);
  finally TestsEnd; end;
end;

procedure TForm1.PerformTest(AItem: TListItem);
var
  LBox: TBXBoxInfo;
begin
  try
    AItem.SubItems[0] := 'Running';
    lstvTests.Refresh;
    StatusMessage(Self, '------------ ' + AItem.Caption + ' ------------');
    LBox := TBXBoxInfo(AItem.Data);
    LBox.PerformTest(StatusMessage);
    RefreshTestItem(AItem);
  finally StatusMessage(Self, '--------------------------'); end;
end;

procedure TForm1.actnTestSelectedUpdate(Sender: TObject);
begin
  actnTestSelected.Enabled := lstvTests.Selected <> nil;
end;

procedure TForm1.StatusMessage(ASender: TObject; const AMsg: string);
begin
  memoMessages.Lines.Add(AMsg);
end;

constructor TForm1.Create(AOwner: TComponent);
var
  i: integer;
  LNeedParams: boolean;
begin
  inherited;
  FINIFile := TIniFile.Create(ChangeFileExt(ParamStr(0), '.ini'));

  lboxCategories.ItemIndex := lboxCategories.Items.Add('All');
  lboxCategories.Items.AddStrings(GBXCategories);

  lboxCategories.ItemIndex := FINIFile.ReadInteger('Misc', 'Category', lboxCategories.ItemIndex);
  UpdateBoxList;
  with FINIFile do begin
    i := ReadInteger('Misc', 'Selected', -1);
    if i > -1 then begin
      lstvTests.ItemFocused := lstvTests.Items[i];
      lstvTests.Selected := lstvTests.ItemFocused;
    end;
  end;

  if FileExists(ExtractFilePath(ParamStr(0)) + 'GlobalParams.dat') then begin
    GBXGlobalParams.LoadFromFile(ExtractFilePath(ParamStr(0)) + 'GlobalParams.dat');
  end;
  memoGlobalParams.Lines.Assign(GBXGlobalParams);
  LNeedParams := False;
  for i := 0 to GBXGlobalParams.Count - 1 do begin
    if SameText(Copy(GBXGlobalParams[i], Length(GBXGlobalParams[i]) - 11, MaxInt), '=Unspecified')
     then begin
      LNeedParams := True;
      Break;
    end;
  end;
  if LNeedParams then begin
    ShowMessage('There are global parameters that require values that have not been specified.');
    pctlMain.ActivePage := tshtGlobalParams;
    ActiveControl := memoGlobalParams;
  end else begin
    pctlMain.ActivePage := tshtTests;
    ActiveControl := lstvTests;
  end;
end;

destructor TForm1.Destroy;
begin
  memoGlobalParams.Lines.SaveToFile(ExtractFilePath(ParamStr(0)) + 'GlobalParams.dat');
  with FINIFile do begin
    WriteInteger('Misc', 'Category', lboxCategories.ItemIndex);
    if lstvTests.Selected <> nil then begin
      WriteInteger('Misc', 'Selected', lstvTests.Selected.Index);
    end;
  end;
  FreeAndNil(FINIFile);
  inherited;
end;

procedure TForm1.UpdateBoxList;
var
  i: integer;
  LBox: TBXBoxInfo;
  LCategory: string;
  LItem: TListItem;
begin
  LCategory := lboxCategories.Items[lboxCategories.ItemIndex];
  lstvTests.Items.BeginUpdate; try
    lstvTests.Items.Clear;
    for i := 0 to GBXBoxes.Count - 1 do begin
      LBox := TBXBoxInfo(GBXBoxes[i]);
      if SameText(LCategory, LBox.Category) or SameText(LCategory, 'All') then begin
        LItem := lstvTests.Items.Add;
        with LItem do begin
          Data := LBox;
          if SameText(LCategory, 'All') then begin
            Caption := LBox.Category + ' : ' + LBox.Name;
          end else begin
            Caption := LBox.Name;
          end;
          SubItems.Add('');
          SubItems.Add('');
        end;
        RefreshTestItem(LItem);
      end;
    end;
  finally lstvTests.Items.EndUpdate; end;
end;

procedure TForm1.lboxCategoriesClick(Sender: TObject);
begin
  UpdateBoxList;
end;

procedure TForm1.TestsBegin;
begin
  memoMessages.Clear;
  GBXGlobalParams.Assign(memoGlobalParams.Lines);
end;

procedure TForm1.TestsEnd;
begin

end;

procedure TForm1.butnTestAllClick(Sender: TObject);
begin
  lboxCategories.ItemIndex := lboxCategories.Items.IndexOf('All');
  lboxCategoriesClick(Sender);
  butnTestCategoryClick(Sender);
end;

procedure TForm1.RefreshTestItem(AItem: TListItem);
begin
  with TBXBoxInfo(AItem.Data) do begin
    AItem.SubItems[0] := Status;
    AItem.SubItems[1] := StatusMessage;
  end;
  lstvTests.Refresh;
end;

end.
