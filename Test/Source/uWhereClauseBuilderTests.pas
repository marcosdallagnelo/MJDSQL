unit uWhereClauseBuilderTests;

interface

uses TestFramework, uWhereClauseBuilder, uCriteria, System.Rtti;

type
  TWhereClauseBuilderTests = class(TTestCase)
  published
    procedure Adiciona_Criterio_Where_SQL_Sem_Where;
    procedure Adiciona_Criteria_Where_SQL_Sem_Where;
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
    procedure Volta_SQL_Original;
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

procedure TWhereClauseBuilderTests.Adiciona_Criteria_Where_SQL_Sem_Where;
var
  WhereClause: TWhereClauseBuilder;
  Value: TValue;
const
  SQL_SELECT_ATUAL = 'select pes_bairro, pes_celular, pes_cep, pes_cid_id, ' +
    'pes_cnpj, pes_cpf, pes_id, pes_inscricao_estadual, pes_inscricao_municipal, ' +
    'pes_lixeira, pes_logradouro, pes_nome, pes_numero, pes_razao_social, ' +
    'pes_telefone, pes_tipo from pessoa_pes';
  SQL_SELECT_ESPERADO = 'select pes_bairro, pes_celular, pes_cep, pes_cid_id, ' +
    'pes_cnpj, pes_cpf, pes_id, pes_inscricao_estadual, pes_inscricao_municipal, ' +
    'pes_lixeira, pes_logradouro, pes_nome, pes_numero, pes_razao_social, ' +
    'pes_telefone, pes_tipo from pessoa_pes WHERE pes_lixeira = 1';
begin
  WhereClause := TWhereClauseBuilder.Create(SQL_SELECT_ATUAL);
  Value := 1;
  WhereClause.AddWhere(NewCriteria('pes_lixeira', coEqual, Value).ToString());

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

procedure TWhereClauseBuilderTests.Volta_SQL_Original;
var
  WhereClause: TWhereClauseBuilder;
  Value: TValue;
const
  SQL_SELECT_ATUAL = 'SELECT campo1, campo2 FROM tabela_qualquer';
begin
  WhereClause := TWhereClauseBuilder.Create(SQL_SELECT_ATUAL);
  Value := 1;
  WhereClause.AddWhere(NewCriteria('campo1', coEqual, Value).ToString());
  WhereClause.Clear;

  CheckEqualsString(SQL_SELECT_ATUAL, WhereClause.SQL);
end;

initialization
  TestFramework.RegisterTest(TWhereClauseBuilderTests.Suite);

end.
