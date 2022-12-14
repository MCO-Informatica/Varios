#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05
#INCLUDE "TOPCONN.ch"

User Function K_divlot()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
//? Declaracao de variaveis utilizadas no programa atraves da funcao    ?
//? SetPrvt, que criara somente as variaveis definidas pelo usuario,    ?
//? identificando as variaveis publicas do sistema utilizadas no codigo ?
//? Incluido pelo assistente de conversao do AP6 IDE                    ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?

SetPrvt("_CALIAS,_NORDEM,_NRECNO,TAMANHO,LIMITE,CDESC1")
SetPrvt("CDESC2,CDESC3,ARETURN,NOMEPROG,NLASTKEY,CSTRING")
SetPrvt("LCONTINUA,WNREL,CNOMEPRG,TITULO,AORD,ADRIVER")
SetPrvt("CPERG,LEND,CBCONT,CBTXT,_APERGUNTAS,_NLACO")
SetPrvt("_AARQUIVO,_CARQTRB,_CORDEM,LI,_NPAG,_NTIPO")
SetPrvt("M_PAG,CQUERY,")

// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 12/02/05 ==> #INCLUDE "TOPCONN.ch"
/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽?
굇쿑un놹o        ? K_DIVLOT ? Autor ? Luciano Lorenzetti        ? Data ? 02.10.00 낢?
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙?
굇쿏escri뇚o ? Relatorio de Divergencia de Lotes.                                                 낢?
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽?
/*/
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//? Guarda Ambiente                                              ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
_cAlias  := ALIAS()
_nOrdem  := INDEXORD()
_nRecno  := RECNO()
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//? Inicializa Variaveis                                         ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
tamanho  := "P"
limite   := 080
cDesc1   := PADC("RELACAO DE DIVERGENCIA DE LOTES",74)
cDesc2   := PADC("Especifico Kenia Tecelagem",74)
cDesc3   :=""
aReturn  := { "Zebrado", 1,"Administracao", 2, 2, 1, "",0 }
nomeprog :="K_DIVLOT"
nLastkey := 0
cString  := "SC2"
lContinua:= .F.
wnrel    := "K_DIVLOT"
cNomePrg := "K_DIVLOT"
titulo   := "RELACAO DE DIVERGENCIA DE LOTES"

aOrd     := {}
aDriver  := ReadDriver()
cPerg    := "K_DIVL"
lEnd     := .F.

cbCont   := 00
Cbtxt    := Space( 10 )

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//? Variaveis utilizadas para parametros                         ?
//쳐컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴캑
//? O trecho de programa abaixo verifica se o arquivo SX1 esta   ?
//? atualizado. Caso nao, deve ser inserido o grupo de perguntas ?
//? que sera utilizado.                                          ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
_aPerguntas:= {}
//                   1       2          3                 4       5  6  7 8  9   10     11      12         13 14    15        16 17 18 19 20 21 22 23 24 25   26

AADD(_aPerguntas,{cPerg,"01","Local              ?" ,"mv_ch1","C",02,0,0,"G"," ","mv_par01","         ","","","         ","","","","","","","","","","","",})

//dbSelectArea("SX1")
//dbSeek(cPerg)
//Do While cPerg == SX1->X1_GRUPO
//       RecLock("SX1",.F.)
//       dbDelete()
//       MsUnlock()
//       dbSkip()
//EndDo


dbSelectArea("SX1")
FOR _nLaco:=1 to LEN(_aPerguntas)
   If !dbSeek(_aPerguntas[_nLaco,1]+_aPerguntas[_nLaco,2])
     RecLock("SX1",.T.)
     SX1->X1_Grupo     := _aPerguntas[_nLaco,01]
     SX1->X1_Ordem     := _aPerguntas[_nLaco,02]
     SX1->X1_Pergunt   := _aPerguntas[_nLaco,03]
     SX1->X1_Variavl   := _aPerguntas[_nLaco,04]
     SX1->X1_Tipo      := _aPerguntas[_nLaco,05]
     SX1->X1_Tamanho   := _aPerguntas[_nLaco,06]
     SX1->X1_Decimal   := _aPerguntas[_nLaco,07]
     SX1->X1_Presel    := _aPerguntas[_nLaco,08]
     SX1->X1_Gsc       := _aPerguntas[_nLaco,09]
     SX1->X1_Valid     := _aPerguntas[_nLaco,10]
     SX1->X1_Var01     := _aPerguntas[_nLaco,11]
     SX1->X1_Def01     := _aPerguntas[_nLaco,12]
     SX1->X1_Cnt01     := _aPerguntas[_nLaco,13]
     SX1->X1_Var02     := _aPerguntas[_nLaco,14]
     SX1->X1_Def02     := _aPerguntas[_nLaco,15]
     SX1->X1_Cnt02     := _aPerguntas[_nLaco,16]
     SX1->X1_Var03     := _aPerguntas[_nLaco,17]
     SX1->X1_Def03     := _aPerguntas[_nLaco,18]
     SX1->X1_Cnt03     := _aPerguntas[_nLaco,19]
     SX1->X1_Var04     := _aPerguntas[_nLaco,20]
     SX1->X1_Def04     := _aPerguntas[_nLaco,21]
     SX1->X1_Cnt04     := _aPerguntas[_nLaco,22]
     SX1->X1_Var05     := _aPerguntas[_nLaco,23]
     SX1->X1_Def05     := _aPerguntas[_nLaco,24]
     SX1->X1_Cnt05     := _aPerguntas[_nLaco,25]
     SX1->X1_F3        := _aPerguntas[_nLaco,26]
     MsUnLock()
  EndIf
NEXT

PERGUNTE(cPerg,.F.)

wnrel:=SetPrint(cString,wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.,"",,,,.F.)

If nLastKey == 27
     Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
     Return
Endif

Processa({||CalcRel()})// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Processa({||Execute(CalcRel)})

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> __Return(.T.)
Return(.T.)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

*旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커*
*?     Processa os dados no temporario para obter e calcular os valores ?*
*?     vindos das TABELAS de SQL                                        ?*
*읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸*
// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function CalcRel
Static Function CalcRel()

CriaSQL()

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//? Estrutura de Arquivo DBF temporario para armazenar resultado ?
//? da TCQUERY                                                   ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
_aArquivo:={}
AADD(_aArquivo,{"COD"     ,"C",15,0})
AADD(_aArquivo,{"LOTE"    ,"C",10,0})
AADD(_aArquivo,{"LOCAL"   ,"C",2,0})
AADD(_aArquivo,{"QUANT"   ,"N",12,2})
_cArqTRB := CriaTrab(_aArquivo,.T.)
_cOrdem  := "COD+LOTE+LOCAL"
dbUseArea( .T.,, _cArqTRB, "TRB", if(.F. .OR. .F., !.F., NIL), .F. )
IndRegua("TRB",_cArqTRB,_cOrdem,,,"Criando Indice ...")

dbSelectArea("SQLD2")
dbGoTop()
ProcRegua(RecCount())
Do While !Eof()
   IncProc( OemToAnsi("Aguarde, processando Matriz....") )
   DBSELECTAREA("TRB")
   RECLOCK( "TRB" , .t. )
   TRB->COD    := SQLD2->COD
   TRB->QUANT  := SQLD2->QUANT
   TRB->LOCAL  := SQLD2->LOCAL
   TRB->LOTE   := SQLD2->LOTECTL
   MSUNLOCK()
   DBSelectArea("SQLD2")
   DBSKIP()
EndDo

*******************************************************************************
*******************************************************************************
****                           IMPRESSAO DOS DADOS                        *****
*******************************************************************************
*******************************************************************************
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//? Variaveis para impressao                                     ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
Li                 := 60
_nPag      := 0
_nTipo     := IIF(aReturn[4]==1,15,18)
m_pag      := 1
*旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
*? Imprime os dados do arquivo TRB                              ?
*읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
RptStatus({|| REL_KENIA() })// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> RptStatus({|| Execute(REL_KENIA) })
__RetProc()

*旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?*
*쳐컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?*
*쳐컴컴컴컴컴컴컴컴컴컴FUNCAO DE IMPRESSAO RELATORIO컴컴컴컴컴컴컴컴컴컴컴컴캑*
*쳐컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?*
*읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?*
// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function REL_KENIA
Static Function REL_KENIA()
dbSelectArea("TRB")
DBGOTOP()
SetRegua(RecCount())
While !EOF()
   IncRegua()
   //旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
   //? Verifica se o usuario interrompeu o relatorio                            ?
   //읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
   If lAbortPrint
	 @Prow()+1,001 PSAY "CANCELADO PELO OPERADOR"
	 Exit
   Endif

   If Li >= 56
	  Cabec(Titulo,"TESTE"," ",cNomePrg,Tamanho,_nTipo)
   EndIf

   @ li,000  PSAY TRB->COD
   @ li,020  PSAY TRB->LOTE
   @ li,040  PSAY TRB->LOCAL
   @ li,060  PSAY TRB->QUANT       PICTURE "@E 999,999.99"

   LI := LI + 1

   DBSKIP()

EndDo

roda(cbcont,cbtxt,"G")


// Fecha e apaga os arquivos temporarios
dbSelectarea("TRB")
dbCloseArea()
Ferase(_cArqTRB+".DBF")
Ferase(_cArqTRB+OrdBagExt())

dbSelectarea("SQLD2")
dbCloseArea()

// retorna a area anterior
DbSelectArea(_cAlias)
DbSetOrder(_nOrdem)
DbGoto(_nRecno)

Set device to Screen
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//? Se em disco, desvia para Spool                               ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
If aReturn[5] == 1    // Se Saida para disco, ativa SPOOL
   Set Printer TO
   Set Device to Screen
   DbCommitAll()
   ourspool(wnrel)
Endif
MS_FLUSH()
__RetProc()


*******************************************************************************
*旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?*
*넬컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커?*
*냉컴컴컴컴컴컴컴컴컴컴컴컴?  QUERY's do SQL 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴캑?*
*냅컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸?*
*읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?*
*******************************************************************************
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//? Funcao para retornar arquivo de trabalho atraves de QUERY    ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function CriaSQL
Static Function CriaSQL()

dbSelectArea("SD2")
cQuery := ''
cQuery :=                  "  SELECT   SD2.D2_QUANT     QUANT,    "
cQuery := cQuery + "           SD2.D2_COD       COD,      "
cQuery := cQuery + "           SD2.D2_LOTECTL   LOTECTL,  "
cQuery := cQuery + "           SD2.D2_LOCAL     LOCAL     "
cQuery := cQuery + "  FROM  SD2010 SD2, SF4010 SF4"
cQuery := cQuery + "  WHERE SD2.D2_FILIAL = '"+xfilial("SD2")+"' AND "
cQuery := cQuery + "        SF4.F4_FILIAL = '"+xfilial("SF4")+"' AND "
cQuery := cQuery + "        SD2.D2_TES = SF4.F4_CODIGO AND "
cQuery := cQuery + "        SF4.F4_ESTOQUE = 'S' AND "
cQuery := cQuery + "        SD2.D2_EMISSAO >= '20000803' AND "
cQuery := cQuery + "        SD2.D2_EMISSAO <= '20000930' AND "
cQuery := cQuery + "        SD2.D2_LOTECTL <> '' AND "
cQuery := cQuery + "        SD2.D_E_L_E_T_ <> '*' AND "
cQuery := cQuery + "        SF4.D_E_L_E_T_ <> '*' "
MEMOWRIT("C:\SQL.txt",cQuery)
cQuery := ChangeQuery(cQuery)
dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"SQLD2", .F., .T.)
__RetProc()


Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

