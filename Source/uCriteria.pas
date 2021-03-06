{           DORM - Delphi ORM                                               }
{                                                                           }
{           Copyright 2010-2013 Daniele Teti                                }
{                                                                           }
{           https://code.google.com/p/delphi-orm/                           }
{                                                                           }
{                                                                           }
{***************************************************************************}
{                                                                           }
{  Licensed under the Apache License, Version 2.0 (the "License");          }
{  you may not use this file except in compliance with the License.         }
{  You may obtain a copy of the License at                                  }
{                                                                           }
{      http://www.apache.org/licenses/LICENSE-2.0                           }
{                                                                           }
{  Unless required by applicable law or agreed to in writing, software      }
{  distributed under the License is distributed on an "AS IS" BASIS,        }
{  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. }
{  See the License for the specific language governing permissions and      }
{  limitations under the License.                                           }
{                                                                           }
{***************************************************************************}
{  WARNING!!! THIS VERSION IS A PATCHED VERSION BY MARCOS JOS� DALLAGNELO    }
{  (dallagnelo@yahoo.com.br)                                                  }

unit uCriteria;

interface

uses System.Rtti, System.Generics.Collections, System.SysUtils, System.TypInfo,
  System.Variants, System.StrUtils;

type
  TCriteriaDateTime = record
  private
    FDateTime: TDateTime;
    procedure SetDateTime(const Value: TDateTime);
  public
    property DateTime: TDateTime read FDateTime write SetDateTime;
    class function Get(Value: TDateTime): TCriteriaDateTime; static;
  end;

  TdormCompareOperator = (coEqual, coGreaterThan, coLowerThan, coGreaterOrEqual,
    coLowerOrEqual, coNotEqual, coLike);
  TMJDCompareOperatorSet = set of TdormCompareOperator;
  TdormLogicRelation = (lrAnd, lrOr);

  ICriteriaItem = interface;

  ICriteriaItem = interface(IInterface)
    ['{3329869B-79A1-4194-95B1-DEE40696EE80}']
    procedure SetAttribute(const Value: string);
    procedure SetCompareOperator(const Value: TdormCompareOperator);
    procedure SetValue(const Value: TValue);
    procedure SetLogicRelation(const Value: TdormLogicRelation);
    function GetLogicRelation: TdormLogicRelation;
    function GetCompareOperator: TdormCompareOperator;
    function GetValue: TValue;
    function GetAttribute: String;
    function ToString: string;
  end;

  ICriteria = interface(ICriteriaItem)
    ['{3329869B-79A1-4194-95B1-DEE40696EE80}']
    procedure Clear;
    function _Or(Criteria: ICriteria): ICriteria; overload;
    function _And(Criteria: ICriteria): ICriteria; overload;
    function _Or(const Attribute: string; CompareOperator: TdormCompareOperator; Value: TValue)
      : ICriteria; overload;
    function _And(const Attribute: string; CompareOperator: TdormCompareOperator; Value: TValue)
      : ICriteria; overload;
    function Count: Integer;
    function GetCriteria(const index: Integer): ICriteria;
    function ToString: string;
  end;

  TCriteria = class(TInterfacedObject, ICriteria)
  private
    FAttribute: String;
    FLogicRelation: TdormLogicRelation;
    FValue: TValue;
    FCompareOperator: TdormCompareOperator;
    FItems: TList<ICriteria>;
    function Add(Criteria: ICriteria; LogicRelation: TdormLogicRelation)
      : ICriteria; overload;
    function Add(const Attribute: string; CompareOperator: TdormCompareOperator; Value: TValue;
      LogicRelation: TdormLogicRelation = lrAnd): ICriteria; overload;
  public
    constructor Create; overload; virtual;
    constructor Create(const Attribute: string; CompareOperator: TdormCompareOperator;
      Value: TValue); overload; virtual;
    constructor Create(Criteria: ICriteria); overload; virtual;
    destructor Destroy; override;
    { ICriteria }
    procedure Clear;
    function _Or(Criteria: ICriteria): ICriteria; overload;
    function _And(Criteria: ICriteria): ICriteria; overload;
    function _Or(const Attribute: string; CompareOperator: TdormCompareOperator; Value: TValue)
      : ICriteria; overload;
    function _And(const Attribute: string; CompareOperator: TdormCompareOperator; Value: TValue)
      : ICriteria; overload;
    function Count: Integer;
    function GetCriteria(const index: Integer): ICriteria;
    class function NewCriteria(const Attribute: string; CompareOperator: TdormCompareOperator;
      Value: TValue): ICriteria; overload;
    class function NewCriteria(Criteria: ICriteria): ICriteria; overload;
    { ICriteriaItem }
    procedure SetAttribute(const Value: string);
    procedure SetCompareOperator(const Value: TdormCompareOperator);
    procedure SetValue(const Value: TValue);
    procedure SetLogicRelation(const Value: TdormLogicRelation);
    function GetLogicRelation: TdormLogicRelation;
    function GetCompareOperator: TdormCompareOperator;
    function GetValue: TValue;
    function GetAttribute: string;
    function ToString: string; override;
  end;

  TCriteriaItem = class(TCriteria, ICriteria, ICriteriaItem)
  private
    FCompareOperator: TdormCompareOperator;
    FAttribute: string;
    FValue: TValue;
    FLogicRelation: TdormLogicRelation;
  protected
    procedure SetAttribute(const Value: string);
    procedure SetCompareOperator(const Value: TdormCompareOperator);
    procedure SetValue(const Value: TValue);
    procedure SetLogicRelation(const Value: TdormLogicRelation);
    function GetLogicRelation: TdormLogicRelation;
    function GetAttribute: string;
    function GetCompareOperator: TdormCompareOperator;
    function GetValue: TValue;
  public
    constructor Create(const Attribute: string; CompareOperator: TdormCompareOperator;
      Value: TValue); override;
    property Attribute: string read FAttribute write SetAttribute;
    property CompareOperator: TdormCompareOperator read FCompareOperator
      write SetCompareOperator;
    property Value: TValue read FValue write SetValue;
    property LogicRelation: TdormLogicRelation read FLogicRelation
      write SetLogicRelation;
    function ToString: string; override;
  end;


function NewCriteria(Criteria: ICriteria): ICriteria; overload;
function NewCriteria(const Attribute: string; CompareOperator: TdormCompareOperator;
  Value: TValue)
  : ICriteria; overload;

function EscapeDate(const Value: TDate): string;
function EscapeDateTime(const Value: TDateTime): string;
function EscapeFloat(const Value: Extended): string;
function EscapeString(const Value: string): string;

const
  CO_EQUAL = '=';
  CO_GREATER_THAN = '>';
  CO_LOWER_THAN = '<';
  CO_GREATER_OR_EQUAL = '>=';
  CO_LOWER_OR_EQUAL = '<=';
  CO_NOT_EQUAL = '!=';
  CO_LIKE = 'LIKE';

  LR_AND = 'AND';
  LR_OR = 'OR';

  WILDCARD = '%';
  ASTERISK = '*';

  TMJDCompareOperatorString: array[TdormCompareOperator] of string = (CO_EQUAL,
    CO_GREATER_THAN, CO_LOWER_THAN, CO_GREATER_OR_EQUAL, CO_LOWER_OR_EQUAL,
    CO_NOT_EQUAL, CO_LIKE);
  TMJDLogicRelationString: array[TdormLogicRelation] of string = (LR_AND, LR_OR);

implementation

function NewCriteria(Criteria: ICriteria): ICriteria;
begin
  Result := TCriteria.NewCriteria(Criteria);
end;

function NewCriteria(const Attribute: string; CompareOperator: TdormCompareOperator;
  Value: TValue): ICriteria;
begin
  Result := TCriteria.NewCriteria(Attribute, CompareOperator, Value);
end;

function EscapeDate(const Value: TDate): string;
begin
  Result := FormatDateTime('YYYY-MM-DD', Value);
end;

function EscapeDateTime(const Value: TDateTime): string;
begin
  Result := FormatDateTime('YYYY-MM-DD HH:NN:SS', Value);
end;

function EscapeFloat(const Value: Extended): string;
begin
  Result := FloatToStr(Value);
  Result := StringReplace(Result, '.', '', [rfReplaceAll]);
  Result := StringReplace(Result, ',', '.', [rfReplaceAll]);
end;

function EscapeString(const Value: string): string;
begin
  Result := StringReplace(Value, '''', '''''', [rfReplaceAll]);
end;

{ TdormCriteria }

function TCriteria.Add(const Attribute: string; CompareOperator: TdormCompareOperator;
  Value: TValue; LogicRelation: TdormLogicRelation): ICriteria;

var
  Item: TCriteriaItem;
begin
  Item := TCriteriaItem.Create;
  Item.Attribute := Attribute;
  Item.CompareOperator := CompareOperator;
  Item.Value := Value;
  Item.LogicRelation := LogicRelation;
  FItems.Add(Item);
  Result := Self;
end;

function TCriteria.Add(Criteria: ICriteria; LogicRelation: TdormLogicRelation)
  : ICriteria;

var
  Item: ICriteria;
begin
  Item := Criteria;
  Item.SetLogicRelation(LogicRelation);
  FItems.Add(Item);
  Result := Self;
end;

procedure TCriteria.Clear;
begin
  FItems.Clear;
end;

function TCriteria.Count: Integer;
begin
  Result := FItems.Count;
end;

constructor TCriteria.Create(Criteria: ICriteria);
begin
  Create;
  Add(Criteria, lrAnd);
end;

constructor TCriteria.Create(const Attribute: string; CompareOperator: TdormCompareOperator;
  Value: TValue);
begin
  Create;
  Add(Attribute, CompareOperator, Value);
end;

constructor TCriteria.Create;
begin
  inherited;
  FItems := TList<ICriteria>.Create;
end;

destructor TCriteria.Destroy;
begin
  FItems.Free;
  inherited;
end;

function TCriteria.GetAttribute: string;
begin
  Result := FAttribute;
end;

function TCriteria.GetCompareOperator: TdormCompareOperator;
begin
  Result := FCompareOperator;
end;

function TCriteria.GetCriteria(const index: Integer): ICriteria;
begin
  Result := FItems[index];
end;

function TCriteria.GetLogicRelation: TdormLogicRelation;
begin
  Result := FLogicRelation;
end;

function TCriteria.GetValue: TValue;
begin
  Result := FValue;
end;

class function TCriteria.NewCriteria(Criteria: ICriteria): ICriteria;
begin
  Result := TCriteria.Create;
  Result._And(Criteria);
end;

procedure TCriteria.SetAttribute(const Value: string);
begin
  FAttribute := Value;
end;

procedure TCriteria.SetCompareOperator(const Value: TdormCompareOperator);
begin
  FCompareOperator := Value;
end;

procedure TCriteria.SetLogicRelation(const Value: TdormLogicRelation);
begin
  FLogicRelation := Value;
end;

procedure TCriteria.SetValue(const Value: TValue);
begin
  FValue := Value;
end;

function TCriteria.ToString: string;
var
  I: Integer;
  SQL: String;
  CritItem: ICriteriaItem;
  Crit: ICriteria;
begin
  if Self.Count > 0 then
    for I := 0 to Self.Count - 1 do
    begin
      CritItem := Self.GetCriteria(I);
      if I > 0 then
        SQL := SQL + ' ' + TMJDLogicRelationString[CritItem.GetLogicRelation] + ' ';

      if TInterfacedObject(CritItem).GetInterface(ICriteria, Crit) then
      begin
        if Crit.Count > 0 then
          SQL := SQL + ' (' + Crit.ToString + ') '
        else
          SQL := SQL + CritItem.ToString;
      end
      else
        SQL := SQL + CritItem.ToString;
    end
  else
  begin
    if Self.GetAttribute = '' then
      SQL := ''
    else
    begin
      CritItem := TCriteriaItem.Create(Self.GetAttribute,
        Self.GetCompareOperator, Self.GetValue);
      SQL := CritItem.ToString;
    end;
  end;
  Result := SQL;
end;

function TCriteria._And(Criteria: ICriteria): ICriteria;
begin
  Result := Add(Criteria, lrAnd);
end;

function TCriteria._Or(Criteria: ICriteria): ICriteria;
begin
  Result := Add(Criteria, lrOr);
end;

class function TCriteria.NewCriteria(const Attribute: string;
  CompareOperator: TdormCompareOperator; Value: TValue): ICriteria;
begin
  Result := TCriteria.Create;
  Result._And(Attribute, CompareOperator, Value);
end;

function TCriteria._And(const Attribute: string; CompareOperator: TdormCompareOperator;
  Value: TValue): ICriteria;
begin
  Result := Add(Attribute, CompareOperator, Value, lrAnd);
end;

function TCriteria._Or(const Attribute: string; CompareOperator: TdormCompareOperator;
  Value: TValue): ICriteria;
begin
  Result := Add(Attribute, CompareOperator, Value, lrOr);
end;

{ TdormSearch }

constructor TCriteriaItem.Create(const Attribute: string; CompareOperator: TdormCompareOperator;
  Value: TValue);
begin
  Create;
  FAttribute := Attribute;
  FCompareOperator := CompareOperator;
  FValue := Value;
end;

function TCriteriaItem.GetAttribute: string;
begin
  Result := FAttribute;
end;

function TCriteriaItem.GetCompareOperator: TdormCompareOperator;
begin
  Result := FCompareOperator;
end;

function TCriteriaItem.GetLogicRelation: TdormLogicRelation;
begin
  Result := FLogicRelation;
end;

function TCriteriaItem.GetValue: TValue;
begin
  Result := FValue;
end;

procedure TCriteriaItem.SetAttribute(const Value: string);
begin
  FAttribute := Value;
end;

procedure TCriteriaItem.SetCompareOperator(const Value
  : TdormCompareOperator);
begin
  FCompareOperator := Value;
end;

procedure TCriteriaItem.SetLogicRelation(const Value: TdormLogicRelation);
begin
  FLogicRelation := Value;
end;

procedure TCriteriaItem.SetValue(const Value: TValue);
begin
  FValue := Value;
end;

function TCriteriaItem.ToString: string;
var SValue: string;
    Hora, Minuto, Segundo, Milisegundo: Word;
    Data: TDateTime;
const
  SQL_FORMAT = '%s %s %s';
begin
  case Value.Kind of
    tkRecord:
    begin
      if Value.IsType<TCriteriaDateTime> then
      begin
        Data := Value.AsType<TCriteriaDateTime>().DateTime;
        DecodeTime(Data, Hora, Minuto, Segundo, Milisegundo);

        if (Hora + Minuto + Segundo) > 0 then
          SValue := QuotedStr(EscapeDateTime(Data))
        else
          SValue := QuotedStr(EscapeDate(Data));
      end;
    end;
    tkFloat: SValue := EscapeFloat(Value.AsExtended);
    tkInteger: SValue := IntToStr(Value.AsInteger);
    tkString, tkUString:
    begin
      SValue := EscapeString(Value.AsString);

      if (CompareOperator = coLike) then
      begin
        if RightStr(SValue, 1) = ASTERISK then
          SValue := LeftStr(SValue, Length(SValue) - 1) + WILDCARD;

        if LeftStr(SValue, 1) = ASTERISK then
          SValue := WILDCARD + RightStr(SValue, Length(SValue) - 1);
      end;

      SValue := QuotedStr( SValue );
    end;
  end;

  Result := Format(SQL_FORMAT, [Attribute,
    TMJDCompareOperatorString[CompareOperator], SValue]);
end;

{ TCriteriaDateTime }

class function TCriteriaDateTime.Get(Value: TDateTime): TCriteriaDateTime;
begin
  Result.DateTime := Value;
end;

procedure TCriteriaDateTime.SetDateTime(const Value: TDateTime);
begin
  FDateTime := Value;
end;

end.
