unit mwajpgpe;
{$K+,B-,X+,I-,T-,R-,Q-}
{$IFNDEF VER80}
{$H+,J+}
{$ENDIF}
(*-------------------------------------------------------------------------------------*)
(*                                                                                     *)
(*               Unit: mwajpgpe                                                         *)
(*                                                                                     *)
(*               Copyright McCallum Whyman Associates Ltd 2001          *)
(*                                                                                     *)
(*               Version 1.9                                                           *)
(*                                                                                     *)
(*               Author: Tony Whyman                                                   *)
(*                                                                                     *)
(*               Description: This unit provide a property editor for the DataField    *)
(*                            in a TQRDBJEPGIMAGE which avoids an error message in the *)
(*                            Delphi 6 IDE.                                            *)
(*-------------------------------------------------------------------------------------*)

{$IFNDEF VER80} {$IFNDEF VER90} {$IFNDEF VER93}
{$DEFINE DELPHI3ORLATER}
{$DEFINE QREPORT2}
{$IFNDEF VER100} {$IFNDEF VER110} {$IFNDEF VER120} {$IFNDEF VER125}
{$DEFINE DELPHI5ORLATER}
{$IFNDEF VER130}
{$DEFINE DELPHI6ORLATER}
{$ENDIF}
{$ENDIF}{$ENDIF}{$ENDIF} {$ENDIF}
{$ENDIF}{$ENDIF}{$ENDIF}

interface

uses Classes
  {$IFDEF DELPHI6ORLATER} ,DesignEditors, DesignIntf {$ENDIF}
  {$IFNDEF DELPHI6ORLATER}, DsgnIntf
  {$IFDEF DELPHI5ORLATER},dsgnwnds{$ENDIF} {$ENDIF};

type
  TJPEGDataFieldProperty = class(TStringProperty)
  public
    function GetDataSetPropName : string;
    function GetAttributes : TPropertyAttributes; override;
    procedure GetValueList(List : TStrings);
    procedure GetValues(Proc : TGetStrProc); override;
  end;

implementation

uses typinfo, DB;

{ TJPEGDataFieldProperty }

function TJPEGDataFieldProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paValueList, paSortList, paMultiSelect];
end;

function TJPEGDataFieldProperty.GetDataSetPropName: string;
begin
  Result := 'DataSet';
end;

procedure TJPEGDataFieldProperty.GetValueList(List: TStrings);
var
  Instance: TComponent;
  PropInfo: PPropInfo;
  DataSet: TDataSet;
begin
  Instance := TComponent(GetComponent(0));
  PropInfo := TypInfo.GetPropInfo(Instance.ClassInfo, GetDataSetPropName);
  if (PropInfo <> nil) and (PropInfo^.PropType^.Kind = tkClass) then
  begin
    DataSet := TObject(GetOrdProp(Instance, PropInfo)) as TDataSet;
    if (DataSet <> nil) then
      DataSet.GetFieldNames(List);
  end;
end;

procedure TJPEGDataFieldProperty.GetValues(Proc: TGetStrProc);
var
  I: Integer;
  Values: TStringList;
begin
  Values := TStringList.Create;
  try
    GetValueList(Values);
    for I := 0 to Values.Count - 1 do Proc(Values[I]);
  finally
    Values.Free;
  end;
end;

end.
