{***************************************************************************}
{                                                                           }
unit uCriteriaTests;

interface

uses TestFramework, uCriteria, System.Rtti, System.StrUtils, System.SysUtils;

type
  TCriteriaItemTests = class(TTestCase)
  private
    Criteria: TCriteria;
    CriteriaItem: TCriteriaItem;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure Cria_1Criterio_Pesquisa_Campo_Igual_String;
    procedure Cria_1Criterio_Pesquisa_Campo_Diferente_String;
    procedure Cria_1Criterio_Pesquisa_Campo_Like_String;
    procedure Cria_1Criterio_Pesquisa_Campo_LikeIniciaCom_String;
    procedure Cria_1Criterio_Pesquisa_Campo_LikeTerminaCom_String;
    procedure Cria_1Criterio_Pesquisa_Campo_LikeIniciaTerminaCom_String;
    procedure Cria_1Criterio_Pesquisa_Campo_MaiorQue_Integer;
    procedure Cria_1Criterio_Pesquisa_Campo_MenorQue_Integer;
    procedure Cria_1Criterio_Pesquisa_Campo_MaiorIgualQue_Integer;
    procedure Cria_1Criterio_Pesquisa_Campo_MenorIgualQue_Integer;
    procedure Cria_1Criterio_Pesquisa_Campo_Igual_Integer;
    procedure Cria_1Criterio_Pesquisa_2Campo_Igual_String;
    procedure Cria_2Criterio_Pesquisa_Or_2Campo_Igual_String;
    procedure Cria_1Criterio_Pesquisa_Campo_Igual_Date;
    procedure Cria_1Criterio_Pesquisa_Campo_Igual_DateTime;
    procedure Cria_1Criterio_Pesquisa_Campo_Igual_Float;
  end;

implementation

procedure TCriteriaItemTests.SetUp;
begin
  Criteria := TCriteria.Create;
  CriteriaItem := TCriteriaItem.Create;
end;

procedure TCriteriaItemTests.TearDown;
begin
  Criteria.Free;
  CriteriaItem.Free;
end;

procedure TCriteriaItemTests.Cria_1Criterio_Pesquisa_2Campo_Igual_String;
const
  VALOR_CAMPO1 = 'campo1';
  VALOR_CAMPO2 = 'campo2';
  VALOR_ESPERADO = VALOR_CAMPO1 + ' = ''1'' AND ' + VALOR_CAMPO2 + ' = ''1''';
begin
  CheckEqualsString(VALOR_ESPERADO, TCriteria.Create().
    NewCriteria(VALOR_CAMPO1, coEqual, '1').
    _And(VALOR_CAMPO2, coEqual, '1').ToString());

  CheckEqualsString(VALOR_ESPERADO,
     NewCriteria(VALOR_CAMPO1, coEqual, '1').
    _And(VALOR_CAMPO2, coEqual, '1').ToString());
end;

procedure TCriteriaItemTests.Cria_1Criterio_Pesquisa_Campo_Diferente_String;
const
  VALOR_CAMPO = 'campo1';
  VALOR_ESPERADO = VALOR_CAMPO + ' =! ''1''';
begin
  CriteriaItem.Clear;
  CriteriaItem.Attribute := VALOR_CAMPO;
  CriteriaItem.CompareOperator := coNotEqual;
  CriteriaItem.Value := '1';

  CheckEqualsString(VALOR_ESPERADO, CriteriaItem.ToString());
end;

procedure TCriteriaItemTests.Cria_1Criterio_Pesquisa_Campo_Igual_Date;
var
  Data: TCriteriaDateTime;
  DValue: TValue;
const
  VALOR_CAMPO = 'campo1';
  VALOR_ESPERADO = VALOR_CAMPO + ' = ''2012-03-10''';
begin
  CriteriaItem.Clear;
  CriteriaItem.Attribute := VALOR_CAMPO;
  CriteriaItem.CompareOperator := coEqual;
  Data := TCriteriaDateTime.Get(StrToDate('10/03/2012'));
  TValue.Make(
    @Data,
    TypeInfo(TCriteriaDateTime),
    DValue);
  CriteriaItem.Value := DValue;

  CheckEqualsString(VALOR_ESPERADO, CriteriaItem.ToString());
end;

procedure TCriteriaItemTests.Cria_1Criterio_Pesquisa_Campo_Igual_DateTime;
var
  Data: TCriteriaDateTime;
  DValue: TValue;
const
  VALOR_CAMPO = 'campo1';
  VALOR_ESPERADO = VALOR_CAMPO + ' = ''2012-03-10 13:27:55''';
begin
  CriteriaItem.Clear;
  CriteriaItem.Attribute := VALOR_CAMPO;
  CriteriaItem.CompareOperator := coEqual;
  Data.DateTime := StrToDateTime('10/03/2012 13:27:55');
  TValue.Make(@Data, TypeInfo(TCriteriaDateTime), DValue);
  CriteriaItem.Value := DValue;

  CheckEqualsString(VALOR_ESPERADO, CriteriaItem.ToString());
end;

procedure TCriteriaItemTests.Cria_1Criterio_Pesquisa_Campo_Igual_Float;
const
  VALOR_CAMPO = 'campo1';
  VALOR_ESPERADO = VALOR_CAMPO + ' = 10099.958';
begin
  CriteriaItem.Clear;
  CriteriaItem.Attribute := VALOR_CAMPO;
  CriteriaItem.CompareOperator := coEqual;
  CriteriaItem.Value := TValue.From<Extended>(10099.958);

  CheckEqualsString(VALOR_ESPERADO, CriteriaItem.ToString());
end;

procedure TCriteriaItemTests.Cria_1Criterio_Pesquisa_Campo_Igual_Integer;
const
  VALOR_CAMPO = 'campo1';
  VALOR_ESPERADO = VALOR_CAMPO + ' = 10';
begin
  CriteriaItem.Clear;
  CriteriaItem.Attribute := VALOR_CAMPO;
  CriteriaItem.CompareOperator := coEqual;
  CriteriaItem.Value := 10;

  CheckEqualsString(VALOR_ESPERADO, CriteriaItem.ToString());
end;

procedure TCriteriaItemTests.Cria_1Criterio_Pesquisa_Campo_Igual_String;
const
  VALOR_CAMPO = 'campo1';
  VALOR_ESPERADO = VALOR_CAMPO + ' = ''1''';
begin
  CriteriaItem.Clear;
  CriteriaItem.Attribute := VALOR_CAMPO;
  CriteriaItem.CompareOperator := coEqual;
  CriteriaItem.Value := '1';

  CheckEqualsString(VALOR_ESPERADO, CriteriaItem.ToString());

  CheckEqualsString(VALOR_ESPERADO, NewCriteria(VALOR_CAMPO, coEqual,
    TValue.FromVariant('1')).ToString());

  CheckEqualsString(VALOR_ESPERADO, CriteriaItem.NewCriteria(VALOR_CAMPO, coEqual,
    '1').ToString());

  Criteria.Clear;
  Criteria.SetAttribute(VALOR_CAMPO);
  Criteria.SetCompareOperator(coEqual);
  Criteria.SetValue('1');
  CheckEqualsString(VALOR_ESPERADO, Criteria.ToString());
end;

procedure TCriteriaItemTests.Cria_1Criterio_Pesquisa_Campo_LikeIniciaCom_String;
const
  VALOR_CAMPO = 'campo1';
  VALOR_ESPERADO = VALOR_CAMPO + ' LIKE ''10%''';
begin
  CriteriaItem.Clear;
  CriteriaItem.Attribute := VALOR_CAMPO;
  CriteriaItem.CompareOperator := coLike;
  CriteriaItem.Value := '10*';

  CheckEqualsString(VALOR_ESPERADO, CriteriaItem.ToString());
end;

procedure TCriteriaItemTests.Cria_1Criterio_Pesquisa_Campo_LikeIniciaTerminaCom_String;
const
  VALOR_CAMPO = 'campo1';
  VALOR_ESPERADO = VALOR_CAMPO + ' LIKE ''%Ant%''';
begin
  CriteriaItem.Clear;
  CriteriaItem.Attribute := VALOR_CAMPO;
  CriteriaItem.CompareOperator := coLike;
  CriteriaItem.Value := '*Ant*';

  CheckEqualsString(VALOR_ESPERADO, CriteriaItem.ToString());
end;

procedure TCriteriaItemTests.Cria_1Criterio_Pesquisa_Campo_LikeTerminaCom_String;
const
  VALOR_CAMPO = 'campo1';
  VALOR_ESPERADO = VALOR_CAMPO + ' LIKE ''%Abcd''';
begin
  CriteriaItem.Clear;
  CriteriaItem.Attribute := VALOR_CAMPO;
  CriteriaItem.CompareOperator := coLike;
  CriteriaItem.Value := '*Abcd';

  CheckEqualsString(VALOR_ESPERADO, CriteriaItem.ToString());
end;

procedure TCriteriaItemTests.Cria_1Criterio_Pesquisa_Campo_Like_String;
const
  VALOR_CAMPO = 'campo1';
  VALOR_ESPERADO = VALOR_CAMPO + ' LIKE ''10''';
begin
  CriteriaItem.Clear;
  CriteriaItem.Attribute := VALOR_CAMPO;
  CriteriaItem.CompareOperator := coLike;
  CriteriaItem.Value := '10';

  CheckEqualsString(VALOR_ESPERADO, CriteriaItem.ToString());
end;

procedure TCriteriaItemTests.Cria_1Criterio_Pesquisa_Campo_MaiorIgualQue_Integer;
const
  VALOR_CAMPO = 'campo1';
  VALOR_ESPERADO = VALOR_CAMPO + ' >= 100';
begin
  CriteriaItem.Clear;
  CriteriaItem.Attribute := VALOR_CAMPO;
  CriteriaItem.CompareOperator := coGreaterOrEqual;
  CriteriaItem.Value := 100;

  CheckEqualsString(VALOR_ESPERADO, CriteriaItem.ToString());

end;

procedure TCriteriaItemTests.Cria_1Criterio_Pesquisa_Campo_MaiorQue_Integer;
const
  VALOR_CAMPO = 'campo1';
  VALOR_ESPERADO = VALOR_CAMPO + ' > 100';
begin
  CriteriaItem.Clear;
  CriteriaItem.Attribute := VALOR_CAMPO;
  CriteriaItem.CompareOperator := coGreaterThan;
  CriteriaItem.Value := 100;

  CheckEqualsString(VALOR_ESPERADO, CriteriaItem.ToString());
end;

procedure TCriteriaItemTests.Cria_1Criterio_Pesquisa_Campo_MenorIgualQue_Integer;
const
  VALOR_CAMPO = 'campo1';
  VALOR_ESPERADO = VALOR_CAMPO + ' <= 100';
begin
  CriteriaItem.Clear;
  CriteriaItem.Attribute := VALOR_CAMPO;
  CriteriaItem.CompareOperator := coLowerOrEqual;
  CriteriaItem.Value := 100;

  CheckEqualsString(VALOR_ESPERADO, CriteriaItem.ToString());
end;

procedure TCriteriaItemTests.Cria_1Criterio_Pesquisa_Campo_MenorQue_Integer;
const
  VALOR_CAMPO = 'campo1';
  VALOR_ESPERADO = VALOR_CAMPO + ' < 100';
begin
  CriteriaItem.Clear;
  CriteriaItem.Attribute := VALOR_CAMPO;
  CriteriaItem.CompareOperator := coLowerThan;
  CriteriaItem.Value := 100;

  CheckEqualsString(VALOR_ESPERADO, CriteriaItem.ToString());
end;

procedure TCriteriaItemTests.Cria_2Criterio_Pesquisa_Or_2Campo_Igual_String;
var
  Value: TValue;
const
  VALOR_CAMPO1 = 'campo1';
  VALOR_CAMPO2 = 'campo2';
  VALOR_COMPARE = coEqual;
  VALOR_PESQUISA = ' (' + VALOR_CAMPO1 + ' = ''1'' AND ' + VALOR_CAMPO2 + ' = ''1'') ';
  VALOR_ESPERADO =  VALOR_PESQUISA + ' OR ' + VALOR_PESQUISA;
begin
  Value := '1';

  CheckEqualsString(VALOR_ESPERADO,
    NewCriteria(NewCriteria(VALOR_CAMPO1, VALOR_COMPARE, Value).
      _And(VALOR_CAMPO2, VALOR_COMPARE, Value)).
        _Or(NewCriteria(VALOR_CAMPO1, VALOR_COMPARE, Value).
          _And(VALOR_CAMPO2, VALOR_COMPARE, Value)).ToString());
end;

initialization
  TestFramework.RegisterTest(TCriteriaItemTests.Suite);

end.
