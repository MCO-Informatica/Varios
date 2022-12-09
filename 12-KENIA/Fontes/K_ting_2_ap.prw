#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05
#INCLUDE "TOPCONN.ch"

User Function K_ting_2()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("_CALIAS,_NORDEM,_NRECNO,TAMANHO,LIMITE,CDESC1")
SetPrvt("CDESC2,CDESC3,ARETURN,NOMEPROG,NLASTKEY,CSTRING")
SetPrvt("LCONTINUA,WNREL,CNOMEPRG,TITULO,AORD,ADRIVER")
SetPrvt("CPERG,LEND,CBCONT,CBTXT,_APERGUNTAS,_NLACO")
SetPrvt("_AARQUIVO,_CORDEM,_CARQTRB,_NQUANT,I,_NLIN")
SetPrvt("_NPAG,_NTIPO,M_PAG,_NQUANT1,_NQUANT2,_CTIPOANT")
SetPrvt("_CTIPOATU,_NOCOR,_CTIT,CQUERY,")

// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 12/02/05 ==> #INCLUDE "TOPCONN.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao	 ³ K_TINGIM ³ Autor ³ Luciano Lorenzetti	³ Data ³ 18.09.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relatorio de ORDENS DE PRODUCAO ABERTAS					  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Guarda Ambiente                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_cAlias  := ALIAS()
_nOrdem  := INDEXORD()
_nRecno  := RECNO()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa Variaveis                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
tamanho  := "P"
limite	 := 080
cDesc1   := PADC("Relacao de Tingimento/Reprocesso",74)
cDesc2   := PADC("Kenia Industrias Texteis Ltda",74)
cDesc3	 := ""
aReturn  := {"Zebrado", 1,"Administracao", 2, 2, 1,"",0 }
nomeprog := "K_TING_2"
nLastkey := 0
cString  := "SC2"
lContinua:= .F.
wnrel	 := "K_TING_2"
cNomePrg := "K_TING_2"
titulo   := "Relacao de Tingimento/Reprocesso"

aOrd     := {}
aDriver  := ReadDriver()
cPerg	 := "K_TG_2    "
lEnd     := .F.

cbCont   := 00
Cbtxt    := Space( 10 )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01			   Da Data								 ³
//³ mv_par02			   Ate a Data							 ³
//³ mv_par03			   imprime formato						 ³
//ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
//³ O trecho de programa abaixo verifica se o arquivo SX1 esta   ³
//³ atualizado. Caso nao, deve ser inserido o grupo de perguntas ³
//³ que sera utilizado.                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_aPerguntas:= {}
//                   1       2          3                 4       5  6  7 8  9   10     11      12         13 14    15        16 17 18 19 20 21 22 23 24 25   26

AADD(_aPerguntas,{cPerg,"01","Da Data             ?" ,"mv_ch1","D",08,0,0,"G"," ","mv_par01","         ","","","         ","","","","","","","","","","","",})
AADD(_aPerguntas,{cPerg,"02","Ate Data            ?" ,"mv_ch2","D",08,0,0,"G"," ","mv_par02","         ","","","         ","","","","","","","","","","","",})
AADD(_aPerguntas,{cPerg,"03","Imprime formato     ?" ,"mv_ch3","N",01,0,0,"C"," ","mv_par03","Sintetico","","","Analitico","","","","","","","","","","","",})
AADD(_aPerguntas,{cPerg,"04","Do Tipo             ?" ,"mv_ch4","C",01,0,0,"G"," ","mv_par04","         ","","","         ","","","","","","","","","","","",})
AADD(_aPerguntas,{cPerg,"05","Ate o tipo          ?" ,"mv_ch5","C",01,0,0,"G"," ","mv_par05","         ","","","         ","","","","","","","","","","","",})

//dbSelectArea("SX1")
//dbSeek(cPerg)
//Do While cPerg == SX1->X1_GRUPO
//	 RecLock("SX1",.F.)
//	 dbDelete()
//	 MsUnlock()
//	 dbSkip()
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

*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿*
*³     Processa os dados no temporario para obter e calcular os valores ³*
*³     vindos das TABELAS de SQL                                        ³*
*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*
// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function CalcRel
Static Function CalcRel()


CriaSQL()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Estrutura de Arquivo DBF temporario para armazenar resultado ³
//³ da TCQUERY                                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_aArquivo:={}
AADD(_aArquivo,{"TIPO"     ,"C",1,0})
AADD(_aArquivo,{"DESCR"    ,"C",12,0})
AADD(_aArquivo,{"OCORRE"   ,"N",6,0})
AADD(_aArquivo,{"QUANT"    ,"N",12,2})
AADD(_aArquivo,{"OP"       ,"C",11,0})
AADD(_aArquivo,{"PROD"     ,"C",15,0})
AADD(_aArquivo,{"QUANTSEG" ,"N",12,2})

If mv_par03 == 1
  _cOrdem := "TIPO"
Else
  _cOrdem := "TIPO+OP"
EndIf
_cArqTRB:=CriaTrab(_aArquivo,.T.)
dbUseArea( .T.,, _cArqTRB, "TRB",.F.,.F. )
IndRegua("TRB",_cArqTRB,_cOrdem,,,"Criando Indice ...")

_nQuant := 0
dbSelectArea("SQL")
dbGoTop()
Do While !Eof()
   DBSELECTAREA("TRB")
   If mv_par03 == 1
	  If !dbSeek(SQL->C2_TIPO)
		 RECLOCK( "TRB" , .t. )
		 TRB->TIPO	   := SQL->C2_TIPO
//		   TRB->OCORRE	 := 1
		 TRB->QUANT    := SQL->C2_QUANT
		 TRB->PROD	   := SQL->C2_PRODUTO
		 TRB->OP	   := SQL->C2_NUM + SQL->C2_ITEM + SQL->C2_SEQUEN
		 TRB->QUANTSEG := SQL->C2_QTSEGUM
	  Else
		 RECLOCK( "TRB" , .f. )
//		   TRB->OCORRE	 := TRB->OCORRE   + 1
		 TRB->QUANT    := TRB->QUANT	+ SQL->C2_QUANT
		 TRB->QUANTSEG := TRB->QUANTSEG + SQL->C2_QTSEGUM
	  EndIf
   Else
	  RECLOCK( "TRB" , .t. )
	  TRB->TIPO 	:= SQL->C2_TIPO
//		TRB->OCORRE   := 1
	  TRB->QUANT	:= SQL->C2_QUANT
	  TRB->PROD 	:= SQL->C2_PRODUTO
	  TRB->OP		:= SQL->C2_NUM + SQL->C2_ITEM + SQL->C2_SEQUEN
	  TRB->QUANTSEG := SQL->C2_QTSEGUM
   EndIf
   MSUNLOCK()
   DBSelectArea("SQL")
   DBSKIP()
EndDo

If mv_par03 == 1
   For i:=1 to 4
	  DBSELECTAREA("TRB")
	  If !dbSeek(STRZERO(i,1))
		 RECLOCK( "TRB" , .t. )
		 TRB->TIPO	   := STRZERO(i,1)
		  Do Case
			 Case i == 1
				  TRB->DESCR := "TINGIMENTO"
			 Case i == 2
				  TRB->DESCR := "RETINGIMENTO"
			 Case i == 3
				  TRB->DESCR := "REFERVIMENTO"
			 Case i == 4
				  TRB->DESCR := "REACABAMENTO"
		  EndCase
//			TRB->OCORRE   := 0
		  TRB->QUANT	:= 0
		  TRB->QUANTSEG := 0
		  MSUNLOCK()
	   Else
		  RECLOCK( "TRB" , .F. )
		  Do Case
			 Case i == 1
				  TRB->DESCR := "TINGIMENTO"
			 Case i == 2
				  TRB->DESCR := "RETINGIMENTO"
			 Case i == 3
				  TRB->DESCR := "REFERVIMENTO"
			 Case i == 4
				  TRB->DESCR := "REACABAMENTO"
		  EndCase
		  MSUNLOCK()
	  EndIf
   Next
EndIf

*******************************************************************************
*******************************************************************************
****                           IMPRESSAO DOS DADOS                        *****
*******************************************************************************
*******************************************************************************
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis para impressao                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_nLin      := 60
_nPag      := 0
_nTipo     := IIF(aReturn[4]==1,15,18)
m_pag      := 1
*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
*³ Imprime os dados do arquivo TRB                              ³
*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RptStatus({|| REL_KENIA() })// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> RptStatus({|| Execute(REL_KENIA) })
Return()

*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿*
*ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´*
*ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄFUNCAO DE IMPRESSAO RELATORIOÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´*
*ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´*
*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*
// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function REL_KENIA
Static Function REL_KENIA()
dbSelectArea("TRB")
DBGOTOP()
SetRegua(RecCount())
_nQuant  := 0
_nQuant1 := 0
_nQuant2 := 0
While !EOF()
  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Verifica se o usuario interrompeu o relatorio                ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  If lAbortPrint
    @Prow()+1,001 PSAY "CANCELADO PELO OPERADOR"
    Exit
  Endif

  If _nLin >= 57
	 IMPCABEC()
	 @ _nLin,000  PSAY _cTit
	 _nLin := _nLin + 2
  EndIf
  
  /////////////////////////////
  // *** imprime DETALHE *** //
  /////////////////////////////
  If mv_par03 == 1
	 DETALHE1()
  Else
	 DETALHE2()
  EndIf

  //////////////////////////////////////////////////
  // vai pro proximo e verifica se imprime totais //
  //////////////////////////////////////////////////
  _nQuant1	:= _nQuant1 + TRB->QUANTSEG
  _nQuant2	:= _nQuant2 + TRB->QUANT
  _cTipoAnt := TRB->TIPO

  DBSKIP()
  If mv_par03 == 2
	If Eof() .OR. _cTipoAnt <> TRB->TIPO
		_cTipoAtu := _cTipoAnt
		ContaTipo()
		dbSelectArea("CNT")
		_nOcor := 0
		Do While !Eof()
		   _nOcor := _nOcor + 1
		   dbSkip()
		EndDo
		dbCloseArea()
		dbSelectArea("TRB")
//		  @ _nLin,030  PSAY "----------"
//		  @ _nLin,045  PSAY "----------"
//		  @ _nLin,060  PSAY "----------"
//		  _nLin := _nLin + 1
		@ _nLin,000  PSAY "T O T A L "
		@ _nLin,034  PSAY _nOcor	 PICTURE "@E 999,999"
		@ _nLin,045  PSAY _nQuant1	 PICTURE "@E 999,999.99"
		@ _nLin,060  PSAY _nQuant2	 PICTURE "@E 999,999.99"
		_nLin := _nLin + 2
	   _nQuant1 := 0
	   _nQuant2 := 0
	EndIf
  EndIf

EndDo

roda(cbcont,cbtxt,"P")


// Fecha e apaga os arquivos temporarios
dbSelectarea("TRB")
dbCloseArea()
Ferase(_cArqTRB+".DBF")
Ferase(_cArqTRB+OrdBagExt())

dbSelectarea("SQL")
dbCloseArea()

// retorna a area anterior
DbSelectArea(_cAlias)
DbSetOrder(_nOrdem)
DbGoto(_nRecno)

Set device to Screen
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se em disco, desvia para Spool                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If aReturn[5] == 1    // Se Saida para disco, ativa SPOOL
   Set Printer TO
   Set Device to Screen
   DbCommitAll()
   ourspool(wnrel)
Endif
MS_FLUSH()
Return()

//*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿*
//*ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´*
//*ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ CABECALHOS E LINHAS DE DETALHE DO RELATORIO ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´*
//*ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´*
//*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*
// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function ImpCabec
Static Function ImpCabec()
*****************
Titulo   := "Relacao de Tingimento/Reprocesso"
_cTit    := "RELACAO DE TINGIMENTO/REPROCESSO "+DTOC(MV_PAR01) +" e "+ DTOC(MV_PAR02)
_nPag    := _nPag + 1
Cabec(Titulo," "," ",cNomePrg,Tamanho,_nTipo)
@ 004,000 PSAY REPLICATE("-",LIMITE)
If mv_par03 == 1
   @ 005,000 PSAY "                     OCORRENCIAS         PESO     METRAGEM "
Else
   @ 005,000 PSAY "Num. OP             Produto             Tipo       PESO       METRAGEM"
EndIf
//				  xxxxxxxxxxxx			 999,999   999,999.99	999,999.99
/*
						  1 		2		  3 		4		  5 		6		  7 		8		  9 	   10		 11 	   12		 13 	   14		 15 	   16		 17 	   18		 19 	   20		 21 	   22
				01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
*/
@ 006,001 PSAY REPLICATE("-",LIMITE)
_nLin := 7
Return()

*ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*

Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function Detalhe1
Static Function Detalhe1()

	_cTipoAtu := TRB->TIPO
	ContaTipo()
	dbSelectArea("CNT")
	_nOcor := 0
	Do While !Eof()
	   _nOcor := _nOcor + 1
	   dbSkip()
	EndDo
	dbCloseArea()
	dbSelectArea("TRB")

	_nQuant := _nQuant + 1
	@ _nLin,000  PSAY TRB->TIPO+"-"
	@ _nLin,002  PSAY TRB->DESCR
//	  @ _nLin,025  PSAY TRB->OCORRE 	PICTURE "@E 999,999"
	@ _nLin,025  PSAY _nOcor		  PICTURE "@E 999,999"
	@ _nLin,035  PSAY TRB->QUANTSEG   PICTURE "@E 999,999.99"
	@ _nLin,048  PSAY TRB->QUANT	  PICTURE "@E 999,999.99"
_nlin:=_nlin+1

Return()



Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function Detalhe2
Static Function Detalhe2()
	@ _nLin,000  PSAY TRB->OP
	@ _nLin,020  PSAY TRB->PROD
	@ _nLin,040  PSAY TRB->TIPO
	@ _nLin,045  PSAY TRB->QUANTSEG   PICTURE "@E 999,999.99"
	@ _nLin,060  PSAY TRB->QUANT	  PICTURE "@E 999,999.99"
_nlin:=_nlin+1

Return()

*******************************************************************************
*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿*
*³ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿³*
*³ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ  QUERY's do SQL ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´³*
*³ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ³*
*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*
*******************************************************************************
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Funcao para retornar arquivo de trabalho atraves de QUERY    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function CriaSQL
Static Function CriaSQL()

dbSelectArea("SC2")
cQuery := ''
cQuery :="  SELECT C2_EMISSAO, C2_QUANT, C2_QTSEGUM , C2_UM, C2_SEGUM, "
cQuery := cQuery + "  C2_PRODUTO, C2_NUM, C2_ITEM, C2_SEQUEN , C2_TIPO "
cQuery := cQuery + "  FROM  "+ RetSQLName("SC2")
cQuery := cQuery + "  WHERE C2_FILIAL = '"+xfilial("SC2")+"' AND "
cQuery := cQuery + "        C2_TIPO   IN ('1','2','3','4') AND "
cQuery := cQuery + "        C2_EMISSAO >= '"+DTOS(MV_PAR01) +"' AND "
cQuery := cQuery + "        C2_EMISSAO <= '"+DTOS(MV_PAR02) +"' AND "
cQuery := cQuery + "        C2_TIPO >= '"+MV_PAR04 +"' AND "
cQuery := cQuery + "        C2_TIPO <= '"+MV_PAR05 +"' AND "
cQuery := cQuery + "        D_E_L_E_T_ <> '*' "
MEMOWRIT("C:\SQL.txt",cQuery)
cQuery := ChangeQuery(cQuery)
dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"SQL", .F., .T.)
Return()



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Funcao para retornar arquivo de trabalho atraves de QUERY    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function ContaTipo
Static Function ContaTipo()

dbSelectArea("SC2")
cQuery := ''
cQuery :="  SELECT C2_NUM  AS OCOR  "
cQuery := cQuery + "  FROM  "+RetSQLName("SC2")
cQuery := cQuery + "  WHERE C2_FILIAL = '"+xfilial("SC2")+"' AND "
cQuery := cQuery + "        C2_TIPO    = '"+ _cTipoAtu +"' AND "
cQuery := cQuery + "        C2_EMISSAO >= '"+DTOS(MV_PAR01) +"' AND "
cQuery := cQuery + "        C2_EMISSAO <= '"+DTOS(MV_PAR02) +"' AND "
cQuery := cQuery + "        D_E_L_E_T_ <> '*' "

cQuery := ChangeQuery(cQuery)
dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"CNT", .F., .T.)
Return()


Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

