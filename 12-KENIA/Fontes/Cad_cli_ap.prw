#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function Cad_cli()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
//? Declaracao de variaveis utilizadas no programa atraves da funcao    ?
//? SetPrvt, que criara somente as variaveis definidas pelo usuario,    ?
//? identificando as variaveis publicas do sistema utilizadas no codigo ?
//? Incluido pelo assistente de conversao do AP6 IDE                    ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?

SetPrvt("_CALIAS,_NORDEM,_NRECNO,CCADASTRO,AROTINA,")

/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽?
굇쿑uncao    ? CAD_CLI  ? Autor ? Luciano Lorenzetti    ? Data ? 29/05/00 낢?
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙?
굇쿏escricao ? Esta rotina tem como objetivo permitir a manutencao do ar- 낢?
굇?          ? quivo de CLIENTES                                          낢?
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙?
굇? Uso      ? RdMake - Especifico da KENIA.                              낢?
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽?
/*/

// Guarda ambiente
_cAlias := ALIAS()
_nOrdem := INDEXORD()
_nRecno := RECNO()

dbSelectArea("SA1")
dbGoTop()

cCADASTRO := "Cadastro de Clientes."
aRotina   := {{ "Pesquisar"    ,"AxPesqui"                  , 0, 1},;
              { "Visualizar"   ,"AxVisual"                  , 0, 2},;
              { "Incluir"      ,"AxInclui"                  , 0, 3},;
              { "Alterar"      ,"AxAltera"                  , 0, 4},;
              { "Excluir"      ,'AxDeleta'                  , 0, 5},;
              { "Observa寤es"  ,'ExecBlock("OBS_CLI",.T.) ' , 0, 1},;
              { "Serasa"       ,'ExecBlock("SERASA",.T.) '  , 0, 1}}

MBrowse( 6,1,22,75,"SA1")

// Devolve ambiente
dbSelectArea(_cAlias)
dbSetOrder(_nOrdem)
dbGoto(_nRecno)

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> __Return(.t.)
Return(.t.)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

