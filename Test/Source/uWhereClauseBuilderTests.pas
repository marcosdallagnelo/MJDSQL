unit uWhereClauseBuilderTests;

interface

uses TestFramework, uWhereClauseBuilder;

type
  TWhereClauseBuilderTests = class(TTestCase)
  published
    procedure Adiciona_Criterio_Where_SQL_Sem_Where;
    procedure Adiciona_Criterio_Where_SQL_Com_Where;
    procedure Adiciona_Criterio_Where_SQL_Sem_Where_Com_OrderBy;
    procedure Adiciona_Criterio_Where_SQL_Com_Where_Com_OrderBy;
    procedure Adiciona_Criterio_Where_SQL_Sem_Where_Com_GroupBy_Having_OrderBy;
    procedure Adiciona_Criterio_Where_SQL_Com_Where_GroupBy_Having_OrderBy;
    procedure Adiciona_Criterio_Where_SQL_Com_GroupBy_OrderBy;
    procedure Obtem_Alias_Tabela_do_From;
    procedure Obtem_Alias_Tabela_From_Sem_Alias;
    procedure Obtem_Alias_Tabela_do_From_Com_GroupBy_having_OrderBy;
    procedure Obtem_Alias_Tabela_From_Sem_Alias_Com_Where;
    procedure Obtem_Alias_Tabela_do_From_Com_GroupBy_Having;
    procedure Obter_Where_SQL_Sem_Where;
    procedure Obter_Where_SQL_Possui_Somente_Where;
    procedure Obter_Where_SQL_Possui_Where_GroupBy;
    procedure Obter_Where_SQL_Possui_Where_OrderBy;
    procedure Obter_Where_SQL_Possui_Where_GroupBy_OrderBy;
  end;

implementation

{ TClauseWhereTests }

procedure TWhereClauseBuilderTests.Adiciona_Criterio_Where_SQL_Com_Where;
var
  WhereClause: TWhereClauseBuilder;
const
  SQL_WHERE_CLAUSE = 'AND campo2 = 2';
  SQL_SELECT_ATUAL = 'SELECT campo1, campo2 FROM tabela_qualquer WHERE campo1 = 1';
  SQL_SELECT_ESPERADO = 'SELECT campo1, campo2 FROM tabela_qualquer WHERE campo1 = 1 AND campo2 = 2';
begin
  WhereClause := TWhereClauseBuilder.Create(SQL_SELECT_ATUAL);
  WhereClause.AddWhere(SQL_WHERE_CLAUSE);

  CheckEqualsString(SQL_SELECT_ESPERADO, WhereClause.SQL);
end;

procedure TWhereClauseBuilderTests.Adiciona_Criterio_Where_SQL_Sem_Where;
var
  WhereClause: TWhereClauseBuilder;
const
  SQL_WHERE_CLAUSE = 'AND campo1 = 1';
  SQL_SELECT_ATUAL = 'SELECT campo1, campo2 FROM tabela_qualquer';
  SQL_SELECT_ESPERADO = 'SELECT campo1, campo2 FROM tabela_qualquer WHERE campo1 = 1';
begin
  WhereClause := TWhereClauseBuilder.Create(SQL_SELECT_ATUAL);
  WhereClause.AddWhere(SQL_WHERE_CLAUSE);

  CheckEqualsString(SQL_SELECT_ESPERADO, WhereClause.SQL);
end;

procedure TWhereClauseBuilderTests.Adiciona_Criterio_Where_SQL_Sem_Where_Com_GroupBy_Having_OrderBy;
var
  WhereClause: TWhereClauseBuilder;
const
  SQL_WHERE_CLAUSE = 'AND campo1 = 1';
  SQL_SELECT_ATUAL = 'SELECT campo1, SUM(campo2) FROM tabela_qualquer ' +
    'GROUP BY campo1 HAVING SUM(campo2) > 0 ORDER BY campo1';
  SQL_SELECT_ESPERADO = 'SELECT campo1, SUM(campo2) FROM tabela_qualquer ' +
    'WHERE campo1 = 1 GROUP BY campo1 HAVING SUM(campo2) > 0 ORDER BY campo1';
begin
  WhereClause := TWhereClauseBuilder.Create(SQL_SELECT_ATUAL);
  WhereClause.AddWhere(SQL_WHERE_CLAUSE);

  CheckEqualsString(SQL_SELECT_ESPERADO, WhereClause.SQL);
end;

procedure TWhereClauseBuilderTests.Adiciona_Criterio_Where_SQL_Com_GroupBy_OrderBy;
var
  WhereClause: TWhereClauseBuilder;
const
  SQL_WHERE_CLAUSE = 'AND campo1 = 1';
  SQL_SELECT_ATUAL = 'SELECT campo1, SUM(campo2) FROM tabela_qualquer ' +
    'GROUP BY campo1 ORDER BY campo1';
  SQL_SELECT_ESPERADO = 'SELECT campo1, SUM(campo2) FROM tabela_qualquer ' +
    'WHERE campo1 = 1 GROUP BY campo1 ORDER BY campo1';
begin
  WhereClause := TWhereClauseBuilder.Create(SQL_SELECT_ATUAL);
  WhereClause.AddWhere(SQL_WHERE_CLAUSE);

  CheckEqualsString(SQL_SELECT_ESPERADO, WhereClause.SQL);
end;

procedure TWhereClauseBuilderTests.Adiciona_Criterio_Where_SQL_Sem_Where_Com_OrderBy;
var
  WhereClause: TWhereClauseBuilder;
const
  SQL_WHERE_CLAUSE = 'AND campo1 = 1';
  SQL_SELECT_ATUAL = 'SELECT campo1, campo2 FROM tabela_qualquer ORDER BY campo1';
  SQL_SELECT_ESPERADO = 'SELECT campo1, campo2 FROM tabela_qualquer ' +
    'WHERE campo1 = 1 ORDER BY campo1';
begin
  WhereClause := TWhereClauseBuilder.Create(SQL_SELECT_ATUAL);
  WhereClause.AddWhere(SQL_WHERE_CLAUSE);

  CheckEqualsString(SQL_SELECT_ESPERADO, WhereClause.SQL);
end;

procedure TWhereClauseBuilderTests.Adiciona_Criterio_Where_SQL_Com_Where_Com_OrderBy;
var
  WhereClause: TWhereClauseBuilder;
const
  SQL_WHERE_CLAUSE = 'AND campo2 = 2';
  SQL_SELECT_ATUAL = 'SELECT campo1, campo2 FROM tabela_qualquer WHERE campo1 = 1 ORDER BY campo1';
  SQL_SELECT_ESPERADO = 'SELECT campo1, campo2 FROM tabela_qualquer ' +
    'WHERE campo1 = 1 AND campo2 = 2 ORDER BY campo1';
begin
  WhereClause := TWhereClauseBuilder.Create(SQL_SELECT_ATUAL);
  WhereClause.AddWhere(SQL_WHERE_CLAUSE);

  CheckEqualsString(SQL_SELECT_ESPERADO, WhereClause.SQL);
end;

procedure TWhereClauseBuilderTests.Adiciona_Criterio_Where_SQL_Com_Where_GroupBy_Having_OrderBy;
var
  WhereClause: TWhereClauseBuilder;
const
  SQL_WHERE_CLAUSE = 'AND campo2 = 2';
  SQL_SELECT_ATUAL = 'SELECT campo1, SUM(campo2) FROM tabela_qualquer WHERE campo1 = 1 ' +
    'GROUP BY campo1 HAVING SUM(campo2) > 0 ORDER BY campo1';
  SQL_SELECT_ESPERADO = 'SELECT campo1, SUM(campo2) FROM tabela_qualquer ' +
    'WHERE campo1 = 1 AND campo2 = 2 ' +
    'GROUP BY campo1 HAVING SUM(campo2) > 0 ORDER BY campo1';
begin
  WhereClause := TWhereClauseBuilder.Create(SQL_SELECT_ATUAL);
  WhereClause.AddWhere(SQL_WHERE_CLAUSE);

  CheckEqualsString(SQL_SELECT_ESPERADO, WhereClause.SQL);

end;

procedure TWhereClauseBuilderTests.Obtem_Alias_Tabela_do_From;
var
  WhereClause: TWhereClauseBuilder;
const
  SQL_SELECT_ATUAL = 'SELECT campo1, campo2 FROM tabela_qualquer tq';
  SQL_ALIAS_ESPERADO = 'tq';
begin
  WhereClause := TWhereClauseBuilder.Create(SQL_SELECT_ATUAL);

  CheckEqualsString(SQL_ALIAS_ESPERADO, WhereClause.GetAliasFromClause());
end;

procedure TWhereClauseBuilderTests.Obtem_Alias_Tabela_do_From_Com_GroupBy_having_OrderBy;
var
  WhereClause: TWhereClauseBuilder;
const
  SQL_SELECT_ATUAL = 'SELECT campo1, SUM(campo2) FROM tabela_qualquer tq ' +
    'GROUP BY campo1 HAVING SUM(campo2) > 0 ORDER BY campo1';
  SQL_ALIAS_ESPERADO = 'tq';
begin
  WhereClause := TWhereClauseBuilder.Create(SQL_SELECT_ATUAL);

  CheckEqualsString(SQL_ALIAS_ESPERADO, WhereClause.GetAliasFromClause());
end;

procedure TWhereClauseBuilderTests.Obtem_Alias_Tabela_do_From_Com_GroupBy_Having;
var
  WhereClause: TWhereClauseBuilder;
const
  SQL_SELECT_ATUAL = 'SELECT campo1, SUM(campo2) FROM tabela_qualquer ' +
    'GROUP BY campo1 HAVING SUM(campo2) > 0 ORDER BY campo1';
  SQL_ALIAS_ESPERADO = 'tabela_qualquer';
begin
  WhereClause := TWhereClauseBuilder.Create(SQL_SELECT_ATUAL);

  CheckEqualsString(SQL_ALIAS_ESPERADO, WhereClause.GetAliasFromClause());
end;

procedure TWhereClauseBuilderTests.Obtem_Alias_Tabela_From_Sem_Alias;
var
  WhereClause: TWhereClauseBuilder;
const
  SQL_SELECT_ATUAL = 'SELECT campo1, campo2 FROM tabela_qualquer';
  SQL_ALIAS_ESPERADO = 'tabela_qualquer';
begin
  WhereClause := TWhereClauseBuilder.Create(SQL_SELECT_ATUAL);

  CheckEqualsString(SQL_ALIAS_ESPERADO, WhereClause.GetAliasFromClause());
end;

procedure TWhereClauseBuilderTests.Obtem_Alias_Tabela_From_Sem_Alias_Com_Where;
var
  WhereClause: TWhereClauseBuilder;
const
  SQL_SELECT_ATUAL = 'SELECT campo1, campo2 FROM tabela_qualquer WHERE campo1 = 1';
  SQL_ALIAS_ESPERADO = 'tabela_qualquer';
begin
  WhereClause := TWhereClauseBuilder.Create(SQL_SELECT_ATUAL);

  CheckEqualsString(SQL_ALIAS_ESPERADO, WhereClause.GetAliasFromClause());
end;

procedure TWhereClauseBuilderTests.Obter_Where_SQL_Possui_Somente_Where;
var
  WhereClause: TWhereClauseBuilder;
const
  SQL_SELECT_ATUAL = 'SELECT campo1, campo2 FROM tabela_qualquer WHERE campo1 = 1';
  SQL_WHERE_ESPERADO = 'WHERE campo1 = 1';
begin
  WhereClause := TWhereClauseBuilder.Create(SQL_SELECT_ATUAL);

  CheckEqualsString(SQL_WHERE_ESPERADO, WhereClause.Where);
end;

procedure TWhereClauseBuilderTests.Obter_Where_SQL_Possui_Where_GroupBy;
var
  WhereClause: TWhereClauseBuilder;
const
  SQL_SELECT_ATUAL = 'SELECT campo1, campo2 FROM tabela_qualquer '+
    'WHERE campo1 = 1 GROUP BY campo1';
  SQL_WHERE_ESPERADO = 'WHERE campo1 = 1';
begin
  WhereClause := TWhereClauseBuilder.Create(SQL_SELECT_ATUAL);

  CheckEqualsString(SQL_WHERE_ESPERADO, WhereClause.Where);
end;

procedure TWhereClauseBuilderTests.Obter_Where_SQL_Possui_Where_GroupBy_OrderBy;
var
  WhereClause: TWhereClauseBuilder;
const
  SQL_SELECT_ATUAL = 'SELECT campo1, campo2 FROM tabela_qualquer '+
    'WHERE campo1 = 1 GROUP BY campo1 ORDER BY campo1';
  SQL_WHERE_ESPERADO = 'WHERE campo1 = 1';
begin
  WhereClause := TWhereClauseBuilder.Create(SQL_SELECT_ATUAL);

  CheckEqualsString(SQL_WHERE_ESPERADO, WhereClause.Where);
end;

procedure TWhereClauseBuilderTests.Obter_Where_SQL_Possui_Where_OrderBy;
var
  WhereClause: TWhereClauseBuilder;
const
  SQL_SELECT_ATUAL = 'SELECT campo1, campo2 FROM tabela_qualquer '+
    'WHERE campo1 = 1 ORDER BY campo1';
  SQL_WHERE_ESPERADO = 'WHERE campo1 = 1';
begin
  WhereClause := TWhereClauseBuilder.Create(SQL_SELECT_ATUAL);

  CheckEqualsString(SQL_WHERE_ESPERADO, WhereClause.Where);
end;

procedure TWhereClauseBuilderTests.Obter_Where_SQL_Sem_Where;
var
  WhereClause: TWhereClauseBuilder;
const
  SQL_SELECT_ATUAL = 'SELECT campo1, campo2 FROM tabela_qualquer';
begin
  WhereClause := TWhereClauseBuilder.Create(SQL_SELECT_ATUAL);

  CheckEqualsString('', WhereClause.Where);
end;

initialization
  TestFramework.RegisterTest(TWhereClauseBuilderTests.Suite);

end.
