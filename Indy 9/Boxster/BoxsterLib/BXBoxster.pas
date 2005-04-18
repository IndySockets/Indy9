{ $HDR$}
{**********************************************************************}
{ Unit archived using Team Coherence                                   }
{ Team Coherence is Copyright 2002 by Quality Software Components      }
{                                                                      }
{ For further information / comments, visit our WEB site at            }
{ http://www.TeamCoherence.com                                         }
{**********************************************************************}
{}
{ $Log:  19913: BXBoxster.pas 
{
{   Rev 1.0    2003.06.12 12:58:06 PM  czhower
{ Recheckin
}
unit BXBoxster;

interface

uses
  Classes,
  SysUtils;

const
  {$IFDEF Linux}
  GPathSep = '/';
  {$ELSE}
  GPathSep = '\';
  {$ENDIF}

type
  TOnStatusMessage = procedure(ASender: TObject; const AMsg: string) of object;
  EBXCheck = class(Exception);
  TBXBoxster = class;
  TBXBoxterClass = class of TBXBoxster;

  TBXBoxster = class(TComponent)
  public
    OnStatusMessage: TOnStatusMessage;
    //
    class procedure Check(const ATest: boolean; const AMsg: string);
    class function GlobalParamValue(const AParamName: string): string;
    class procedure RegisterBox(ABoxClass: TBXBoxterClass; const AName: string;
     const ACategory: string = '<Uncategorized>');
    procedure Status(const AMsg: string);
    procedure Test; virtual; abstract;
  end;

  TBXBoxInfo = class
  public
    BoxClass: TBXBoxterClass;
    Category: string;
    Name: string;
    Status: string;
    StatusMessage: string;
    //
    procedure PerformTest(AOnStatusMessage: TOnStatusMessage);
  end;

var
  GBXBoxes: TList = nil;
  GBXCategories: TStringList = nil;
  GBXGlobalParams: TStringList = nil;

implementation

{ TBXBoxster }

class procedure TBXBoxster.Check(const ATest: boolean; const AMsg: string);
begin
  if not ATest then begin
    raise EBXCheck.Create(AMsg);
  end;
end;

class function TBXBoxster.GlobalParamValue(const AParamName: string): string;
begin
  Result := GBXGlobalParams.Values[AParamName];
  if Length(Result) = 0 then begin
    GBXGlobalParams.Values[AParamName] := 'Unspecified';
  end;
end;

class procedure TBXBoxster.RegisterBox(ABoxClass: TBXBoxterClass; const AName: string;
 const ACategory: string = '<Uncategorized>');
var
  LBoxInfo: TBXBoxInfo;
begin
  if GBXBoxes = nil then begin
    GBXBoxes := TList.Create;
    //
    GBXCategories := TStringList.Create;
    GBXCategories.Sorted := True;
    GBXCategories.Duplicates := dupIgnore;
    //
    GBXGlobalParams := TStringList.Create;
  end;

  GBXCategories.Add(ACategory);

  LBoxInfo := TBXBoxInfo.Create;
  with LBoxInfo do begin
    BoxClass := ABoxClass;
    Category := ACategory;
    Name := AName;
  end;
  GBXBoxes.Add(LBoxInfo);
end;

procedure TBXBoxster.Status(const AMsg: string);
begin
  if Assigned(OnStatusMessage) then begin
    OnStatusMessage(Self, AMsg);
  end;
end;

{ TBXBoxInfo }

procedure TBXBoxInfo.PerformTest(AOnStatusMessage: TOnStatusMessage);
begin
  Status := '';
  StatusMessage := '';
  try
    with BoxClass.Create(nil) do try
      OnStatusMessage := AOnStatusMessage;
      Test;
    finally Free; end;
    Status := 'Passed';
  except
    on E: Exception do begin
      Status := 'Failed';
      StatusMessage := E.Message;
    end;
  end;
end;

initialization
finalization
  if GBXBoxes <> nil then begin
    while GBXBoxes.Count > 0 do begin
      TBXBoxInfo(GBXBoxes[0]).Free;
      GBXBoxes.Delete(0);
    end;
    FreeAndNil(GBXBoxes);
  end;
  FreeAndNil(GBXCategories);
  FreeAndNil(GBXGlobalParams);
end.
