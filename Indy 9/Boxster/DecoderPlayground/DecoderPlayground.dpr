{ $HDR$}
{**********************************************************************}
{ Unit archived using Team Coherence                                   }
{ Team Coherence is Copyright 2002 by Quality Software Components      }
{                                                                      }
{ For further information / comments, visit our WEB site at            }
{ http://www.TeamCoherence.com                                         }
{**********************************************************************}
{}
{ $Log:  20157: DecoderPlayground.dpr 
{
{   Rev 1.0    2003.06.12 1:01:36 PM  czhower
{ Recheckin
}
program DecoderPlayground;

uses
  Forms,
  Main in 'Main.pas' {formMain},
  IdCoderHeader in '..\..\IdCoderHeader.pas',
  DecoderBox in '..\DecoderBox.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TformMain, formMain);
  Application.Run;
end.
