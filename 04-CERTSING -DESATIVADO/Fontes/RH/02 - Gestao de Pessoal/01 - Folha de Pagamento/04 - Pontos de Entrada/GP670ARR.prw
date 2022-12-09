User Function GP670ARR()
/*+----------------------------+------------------------------------------------------+
  | Programa.....: GP670ARR    | PE de passagem dos campos de usu�rio � rotina padr�o.|
  | Dta. Criacao.: 27/11/2015  | Autor.: Alexandre Alves - OPVS.                      |
  +----------------------------+------------------------------------------------------+
  | Objetivo.:                                                                        |
  | Ponto de Entrada acionado atraves da rotina GPEM670, responsavel pela integra��o  |
  | dos tiutlos gerados no modulo de Gest�o de Pessoal, com o modulo Financeiro       |
  | (Contas a Pagar).                                                                 |
  | Esse ponto de entrada passa para a rotina padr�o, os campos personalizados criados|
  | na tabela RC1 - Movimentacoes de Titulos.                                         |
  | Nesse caso est�o sendo passados os campos RC1_ACRESC e RC1_DECRES, responsaveis   |
  | pelo acrescimo ou descrescimo, respectivamente, ao valor original do titulo.      |
  | Os valores de acrescimo ou decrescimo s�o informados manualmente pelo usu�rio.    |
  +------------+-------------------+--------------------------------------------------+
  | Altera��es | Data.: 04/05/2016 | Autor.: Alexandre Alves - OPVS.                  |
  +------------+-------------------+--------------------------------------------------+
  | Objetivo:  A partir dessa data a rotina passa a ajustar o campo RC1_VALOR, com os |
  |            valores constantes nos campos RC1_ACRESC e RC1_DECRES.                 |
  |            Esse ajuste contempla acao do departamento Financeiro em nao permitir  |
  |            valores registrados nos campos de Acrescimo e Decrescimo, pois esses   |
  |            campos s�o reservados para juros e outros abatimentos.                 |
  +-----------------------------------------------------------------------------------+
*/
Local aFiledsX := {}

Aadd(aFiledsX,{"E2_VALOR", RC1->((RC1_VALOR+RC1_ACRESC)-RC1_DECRES), NIL})

Return(aFiledsX)