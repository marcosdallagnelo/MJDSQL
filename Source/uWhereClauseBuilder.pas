unit uWhereClauseBuilder;

interface

uses System.SysUtils, System.StrUtils;

type
  TClause = (tcFrom = 1, tcWhere, tcGroupBy, tcHaving, tcOrderBy);

const
  WHERE_CLAUSE = 'WHERE';
  ORDERBY_CLAUSE = 'ORDER BY';
  HAVING_CLAUSE = 'HAVING';
  GROUPBY_CLAUSE = 'GROUP BY';
  FROM_CLAUSE = 'FROM';
  LOGIC_OPERATOR_AND = 'AND';

  TClauseStrings: array [TClause] of string =
    (FROM_CLAUSE, WHERE_CLAUSE, GROUPBY_CLAUSE, HAVING_CLAUSE, ORDERBY_CLAUSE);

type
  TWhereClauseBuilder = class
  private
    FSQL: string;
    FSQLOriginal: string;
    function GetClause(AClause: TClause): string;
    function GetEndPositionClause(AClause: TClause): Integer;
    function GetWhereClause: string;
  public
    constructor Create(SQL: String);
    procedure AddWhere(Where: String);
    function GetAliasFromClause: string;
  published
    property SQL: string read FSQL;
    property SQLOriginal: string read FSQLOriginal;
    property Where: string read GetWhereClause;
    procedure Clear;
  end;

implementation

{ TWhereClause }

procedure TWhereClauseBuilder.AddWhere(Where: String);
var PosInsert: Integer;
  PriorClause: string;
begin
  PriorClause := GetWhereClause();
  if (PriorClause = '') then
  begin
    PriorClause := GetClause(tcFrom);

    Where := Trim(StringReplace(Where, LOGIC_OPERATOR_AND, '', []));
    Where := Format('%s %s', [WHERE_CLAUSE, Where]);
  end;

  Where := Trim(Where);
  Where := Format('%s ', [Where]);

  FSQL := Trim(FSQL) + ' ';

  PosInsert := Pos(PriorClause, FSQL) + Length(PriorClause) + 1;

  Insert(Where, FSQL, PosInsert);

  FSQL := Trim(FSQL);
end;

procedure TWhereClauseBuilder.Clear;
begin
  FSQL := FSQLOriginal;
end;

constructor TWhereClauseBuilder.Create(SQL: String);
begin
  FSQL := SQL;
  FSQLOriginal := SQL;
end;

function TWhereClauseBuilder.GetAliasFromClause: string;
var FromClause: string;
begin
  FromClause := GetClause(tcFrom);
  FromClause := ReverseString(FromClause);
  FromClause := Copy(FromClause, 1, Pos(' ', FromClause) - 1);
  FromClause := ReverseString(FromClause);

  Result := FromClause;
end;

function TWhereClauseBuilder.GetWhereClause: string;
begin
  Result := GetClause(tcWhere);
end;

function TWhereClauseBuilder.GetClause(AClause: TClause): string;
var
  PosClause, PosClauseEnd: Integer;
begin
  PosClause := Pos(TClauseStrings[AClause], UpperCase(FSQL));

  if (PosClause > 0) then
  begin
    PosClauseEnd := GetEndPositionClause(AClause);

    Result := Trim(Copy(FSQL, PosClause, PosClauseEnd - PosClause));
  end
  else
    Result := EmptyStr;
end;

function TWhereClauseBuilder.GetEndPositionClause(AClause: TClause): Integer;
var
  NextClause, ForClause: TClause;
begin
  if (AClause = High(TClause)) then
    NextClause := AClause
  else
  begin
    NextClause := AClause;
    for ForClause := TClause(Ord(AClause) + 1) to High(TClause) do
      if (AnsiContainsText(AnsiUpperCase(FSQL), AnsiUpperCase(TCLauseStrings[ForClause]))) then
      Begin
        NextClause := ForClause;
        Break;
      End;
  end;

  if (NextClause = AClause) then
    Result := Length(FSQL) + 1
  else
    Result := Pos(TCLauseStrings[NextClause], FSQL);
end;

end.
