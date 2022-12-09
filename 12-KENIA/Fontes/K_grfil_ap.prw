#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05
#INCLUDE "TOPCONN.ch"

User Function K_grfil()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("_CALIAS,_NORDEM,_NRECNO,TAMANHO,LIMITE,CDESC1")
SetPrvt("CDESC2,CDESC3,ARETURN,NLASTKEY,CSTRING,LCONTINUA")
SetPrvt("WNREL,CNOMEPRG,AORD,ADRIVER,CPERG,LEND")
SetPrvt("CBCONT,CBTXT,_APERGUNTAS,_LAPAGA,_NLACO,_AARQUIVO")
SetPrvt("_CARQTRB,_CORDEM,LI,_NPAG,_NTIPO,M_PAG")
SetPrvt("TITULO,CABEC1,CABEC2,_CDOC,_CSERIE,_CNOMECLI")
SetPrvt("_LCOPIA,_CNOMEARQ,_CVEND,_CCLIENTE,_CLOJA,_CCHVSE3")
SetPrvt("CQUERY,")

// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 12/02/05 ==> #INCLUDE "TOPCONN.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao	 ³ K_GRFIL	³ Autor ³						³ Data ³ 16.10.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relatorio de Notas fiscais geradas pela Matriz.			  ³±±
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
cDesc1	 := PADC("RELACAO DE NOTAS FISCAIS DE SAIDA - MATRIZ",74)
cDesc2   := PADC("Especifico Kenia Tecelagem",74)
cDesc3   :=""
aReturn  := { "Zebrado", 1,"Administracao", 2, 2, 1, "",0 }
nLastkey := 0
cString  := "SC2"
lContinua:= .F.
wnrel	 := "K_GRFIL"
cNomePrg := "K_GRFIL"
aOrd	 := {}
aDriver  := ReadDriver()
cPerg	 := "K_GRFI"
lEnd     := .F.
cbCont	 := 00
Cbtxt	 := Space(10)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
//³ O trecho de programa abaixo verifica se o arquivo SX1 esta   ³
//³ atualizado. Caso nao, deve ser inserido o grupo de perguntas ³
//³ que sera utilizado.                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_aPerguntas:= {}
//                   1       2          3                 4       5  6  7 8  9   10     11      12         13 14    15        16 17 18 19 20 21 22 23 24 25   26
AADD(_aPerguntas,{cPerg,"01","Da Data            ?" ,"mv_ch1","D",08,0,0,"G"," ","mv_par01","         ","","","         ","","","","","","","","","","","",})
AADD(_aPerguntas,{cPerg,"02","Ate Data           ?" ,"mv_ch2","D",08,0,0,"G"," ","mv_par02","         ","","","         ","","","","","","","","","","","",})

_lApaga := .F.
If _lApaga
   dbSelectArea("SX1")
   dbSeek(cPerg)
   Do While cPerg == SX1->X1_GRUPO
	  RecLock("SX1",.F.)
	  dbDelete()
	  MsUnlock()
	  dbSkip()
   EndDo
EndIf

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




/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ CalcRel   ³ Funcao que seleciona(SQL) e gera arquivo de trabalho.	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function CalcRel
Static Function CalcRel()

CriaSQL()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Estrutura de Arquivo DBF temporario para armazenar resultado ³
//³ da TCQUERY                                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_aArquivo:={}
AADD(_aArquivo,{"TP"        ,"C",01,0})
AADD(_aArquivo,{"DOC"       ,"C",06,0})
AADD(_aArquivo,{"SERIE"     ,"C",03,0})
AADD(_aArquivo,{"TIPO"      ,"C",01,0})
AADD(_aArquivo,{"EMISSAO"   ,"D",08,0})
AADD(_aArquivo,{"CLIENTE"   ,"C",06,0})
AADD(_aArquivo,{"LOJA"      ,"C",02,0})
AADD(_aArquivo,{"ITEM"      ,"C",02,0})
AADD(_aArquivo,{"COD"       ,"C",15,0})
AADD(_aArquivo,{"LOCAL"     ,"C",02,0})
AADD(_aArquivo,{"QUANT"     ,"N",14,2})
AADD(_aArquivo,{"PEDIDO"    ,"C",06,0})
AADD(_aArquivo,{"ITEMPV"    ,"C",02,0})
AADD(_aArquivo,{"LOTECTL"   ,"C",10,0})
AADD(_aArquivo,{"X_COPFL"   ,"D",08,0})

_cArqTRB := CriaTrab(_aArquivo,.T.)
_cOrdem  := "TP+DOC+SERIE+ITEM"
dbUseArea( .T.,, _cArqTRB, "TRB", if(.F. .OR. .F., !.F., NIL), .F. )
IndRegua("TRB",_cArqTRB,_cOrdem,,,"Criando Indice ...")

dbSelectArea("SQL")
dbGoTop()
ProcRegua(RecCount())
Do While !Eof()
   IncProc( OemToAnsi("Aguarde, processando Matriz....") )
   DBSELECTAREA("TRB")
   RECLOCK( "TRB" , .t. )
   TRB->TP		  := "A"
   TRB->DOC 	  := SQL->DOC
   TRB->SERIE	  := SQL->SERIE
   TRB->TIPO	  := SQL->TIPO
   TRB->EMISSAO   := CTOD(SUBSTR(SQL->EMISSAO,7,2)+"/"+SUBSTR(SQL->EMISSAO,5,2)+"/"+SUBSTR(SQL->EMISSAO,3,2))
   TRB->CLIENTE   := SQL->CLIENTE
   TRB->LOJA	  := SQL->LOJA
   TRB->ITEM	  := SQL->ITEM
   TRB->COD 	  := SQL->COD
   TRB->LOCAL	  := SQL->LOCAL
   TRB->QUANT	  := SQL->QUANT
   TRB->PEDIDO	  := SQL->PEDIDO
   TRB->ITEMPV	  := SQL->ITEMPV
   TRB->LOTECTL   := SQL->LOTECTL
   TRB->X_COPFL   := CTOD(SUBSTR(SQL->X_COPFL,7,2)+"/"+SUBSTR(SQL->X_COPFL,5,2)+"/"+SUBSTR(SQL->X_COPFL,3,2))
   MSUNLOCK()
   DBSelectArea("SQL")
   DBSKIP()
EndDo
/////////////// TRATA DEVOLUCOES:
//CriaDEV()
//
//dbSelectArea("DEV")
//dbGoTop()
//ProcRegua(RecCount())
//Do While !Eof()
//	 IncProc( OemToAnsi("Aguarde, processando Matriz....") )
//	 DBSELECTAREA("TRB")
//	 RECLOCK( "TRB" , .t. )
//	 TRB->TP		:= "B"
//	 TRB->DOC		:= DEV->DOC
//	 TRB->SERIE 	:= DEV->SERIE
//	 TRB->TIPO		:= DEV->TIPO
//	 TRB->EMISSAO	:= CTOD(SUBSTR(DEV->EMISSAO,7,2)+"/"+SUBSTR(DEV->EMISSAO,5,2)+"/"+SUBSTR(DEV->EMISSAO,3,2))
//	 TRB->CLIENTE	:= DEV->CLIENTE
//	 TRB->LOJA		:= DEV->LOJA
//	 TRB->ITEM		:= DEV->ITEM
//	 TRB->COD		:= DEV->COD
//	 TRB->LOCAL 	:= DEV->LOCAL
//	 TRB->QUANT 	:= DEV->QUANT
//	 MSUNLOCK()
//	 DBSelectArea("DEV")
//	 DBSKIP()
//EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Imprime os dados do arquivo TRB 							 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RptStatus({|| REL_KENIA() })// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> RptStatus({|| Execute(REL_KENIA) })
__RetProc()


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ REL_KENIA ³ Funcao que imprime o relatorio. 						  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function REL_KENIA
Static Function REL_KENIA()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis para impressao                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Li		 := 60
_nPag	 := 0
_nTipo	 := IIF(aReturn[4]==1,15,18)
m_pag	 := 1
titulo	 := "RELACAO DE NOTAS FISCAIS DE SAIDA"
//			 0		   1		 2		   3		 4		   5		 6		   7		 8		   9		10		  11		12		  13
//			 01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
//			 999999 999   X  XXXXXX-XX	XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX	XX/XX/XX	 XX/XX/XX
cabec1	 := "NF     SER  TP  CLIENTE    NOME                            EMISSAO      COPIADA  "
//			 0		   1		 2		   3		 4		   5		 6		   7		 8		   9		10		  11		12		  13
//			 01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
//				 XX    XXXXXXXXXXXXXXX	XX	   999,999.99  XXXXXX-XX  X    XXXXXXXXXX
cabec2	 := "    ITEM  PRODUTO          LOCAL  QUANTIDADE  PEDIDO IT  PAP  LOTE"

dbSelectArea("TRB")
DBGOTOP()
SetRegua(RecCount())
While !EOF()
   _cDoc	:= TRB->DOC
   _cSerie	:= TRB->SERIE
   IncRegua()
   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Verifica se o usuario interrompeu o relatorio				³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   If lAbortPrint
	 @Prow()+1,001 PSAY "CANCELADO PELO OPERADOR"
	 Exit
   Endif

   If Li >= 56
	  Cabec(Titulo,cabec1,cabec2,cNomePrg,Tamanho,_nTipo)
   EndIf

   ////////////////////////////////////////////////////////
   // Verificando CLIENTE/FORNECEDOR
   ////////////////////////////////////////////////////////
   If TRB->TIPO $ "DB" .AND. TRB->TP=="A"
	  dbSelectArea("SA2")
	  dbSeek(xFilial("SA2")+TRB->CLIENTE+TRB->LOJA)
	  _cNomeCli := Substr(SA2->A2_NOME,1,30)
   Else
	  dbSelectArea("SA1")
	  dbSeek(xFilial("SA1")+TRB->CLIENTE+TRB->LOJA)
	  _cNomeCli := Substr(SA1->A1_NOME,1,30)
   EndIF
   ////////////////////////////////////////////////////////
   // Verificando Pedido
   ////////////////////////////////////////////////////////
   dbSelectArea("SC5")
   dbSeek(xFilial("SC5")+TRB->PEDIDO)
   ////////////////////////////////////////////////////////
   dbSelectArea("TRB")

   _lCopia := .F.

   @ li,000  PSAY TRB->DOC
   @ li,007  PSAY TRB->SERIE
   @ li,013  PSAY TRB->TIPO
   @ li,016  PSAY TRB->CLIENTE
   @ li,022  PSAY "-"
   @ li,023  PSAY TRB->LOJA
   @ li,026  PSAY _cNomeCli
   @ li,059  PSAY DTOC(TRB->EMISSAO)
   _cNomeArq  := "SF2030"
   dbUseArea(.T.,"TOPCONN",_cNomeArq,_cNomeArq,.t.,.f.)
   dbSelectArea(_cNomeArq)
   dbSetOrder(1)
   If SC5->C5_PAPELETA $"SO"
	  //////////////////////////////////////
	  // Copia SF1 ou SF2 para Filial
	  //////////////////////////////////////
	  _lCopia := .T.
	  If dbSeek("00"+TRB->DOC+TRB->SERIE+TRB->CLIENTE+TRB->LOJA)
		 @ li,075  PSAY "Ok"
	  Else
		 @ li,075  PSAY "Erro"
	  EndIf
   Else
	  If dbSeek("00"+TRB->DOC+TRB->SERIE+TRB->CLIENTE+TRB->LOJA)
		 @ li,075  PSAY "Erro"
	  Else
		 @ li,075  PSAY "-"
	  EndIf
   EndIf
   dbCloseArea()
   dbSelectArea("TRB")
   IF TRB->TP=="B"
	  @ li,085	PSAY "DEV"
   EndIF
   LI := LI + 1
   Do While (TRB->DOC==_cDoc) .and. (TRB->SERIE==_cSerie)
	  IncRegua()
	  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	  //³ Verifica se o usuario interrompeu o relatorio 			   ³
	  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	  If lAbortPrint
		@Prow()+1,001 PSAY "CANCELADO PELO OPERADOR"
		Exit
	  Endif

	  If Li >= 56
		 Cabec(Titulo,cabec1,cabec2,cNomePrg,Tamanho,_nTipo)
	  EndIf
	  @ li,004	PSAY TRB->ITEM
	  @ li,010	PSAY TRB->COD
	  @ li,027	PSAY TRB->LOCAL
	  @ li,034	PSAY TRB->QUANT 	  PICTURE "@E 999,999.99"
	  @ li,046	PSAY TRB->PEDIDO
	  @ li,052	PSAY "-"
	  @ li,053	PSAY TRB->ITEMPV
	  @ li,057	PSAY SC5->C5_PAPELETA
	  @ li,062	PSAY TRB->LOTECTL
	  _cNomeArq  := "SD2030"
	  dbUseArea(.T.,"TOPCONN",_cNomeArq,_cNomeArq,.t.,.f.)
	  dbSelectArea(_cNomeArq)
	  dbSetOrder(3)
	  If SC5->C5_PAPELETA $"SO"
		 //////////////////////////////////////
		 // Copia SF1 ou SF2 para Filial
		 //////////////////////////////////////
		 If dbSeek("00"+TRB->DOC+TRB->SERIE+TRB->CLIENTE+TRB->LOJA)
			@ li,075  PSAY "Ok"
		 Else
			@ li,075  PSAY "Erro"
		 EndIf
	  Else
		 If dbSeek("00"+TRB->DOC+TRB->SERIE+TRB->CLIENTE+TRB->LOJA)
			@ li,075  PSAY "Erro"
		 Else
			@ li,075  PSAY "-"
		 EndIf
	  EndIf
	  dbCloseArea()
	  dbSelectArea("TRB")
      LI := LI + 1
	  _cDoc    := TRB->DOC
	  _cSerie  := TRB->SERIE
	  _cVend   := SC5->C5_VEND1
	  _cCliente:= TRB->CLIENTE
	  _cLoja   := TRB->Loja
	  DBSKIP()
   EndDo
   ////////////////////////////////////////////////////////
   // Verificando Titulos no Financeiro
   ////////////////////////////////////////////////////////
   _cChvSE3 := ""
   If TRB->TIPO $ "DB" .AND. TRB->TP=="A"
	  dbSelectArea("SE2")
	  dbSetOrder(6)
	  If dbSeek(xFilial("SE2")+_cCLIENTE+_cLOJA+_cSERIE+_cDOC)
		 @ li,002  PSAY "Financeiro:"
		 LI := LI + 1
		 Do While (_cCLIENTE+_cLOJA+_cSERIE+_cDOC)==(SE2->E2_FORNECE+SE2->E2_LOJA+SE2->E2_PREFIXO+SE2->E2_NUM)
			@ li,004  PSAY SE2->E2_PREFIXO
			@ li,010  PSAY SE2->E2_NUM
			@ li,018  PSAY SE2->E2_PARCELA
			@ li,021  PSAY SE2->E2_TIPO
			@ li,026  PSAY SE2->E2_VALOR			 PICTURE "@E 999,999.99"
			@ li,038  PSAY DTOC(SE1->E2_VENCREA)
			_cNomeArq  := "SE2030"
			dbUseArea(.T.,"TOPCONN",_cNomeArq,_cNomeArq,.t.,.f.)
			dbSelectArea(_cNomeArq)
			dbSetOrder(1)
			If _lCopia
			   //////////////////////////////////////
			   // Copia SE2 para Filial
			   //////////////////////////////////////
			   If dbSeek("00"+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO+SE2->E2_FORNECE+SE2->E2_LOJA)
				  @ li,075	PSAY "Ok"
			   Else
				  @ li,075	PSAY "Erro"
			   EndIf
			Else
			   If dbSeek("00"+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO+SE2->E2_FORNECE+SE2->E2_LOJA)
				  @ li,075	PSAY "Erro"
			   Else
				  @ li,075	PSAY "-"
			   EndIf
			EndIf
			dbCloseArea()
			dbSelectArea("SE2")
			LI := LI + 1
			_cChvSE3 := SE2->E2_PREFIXO+SE2->E2_NUM  //+SE2->E2_PARCELA
			dbSkip()
		 EndDo
	  EndIf
   Else
	  dbSelectArea("SE1")
	  dbSetOrder(2)
	  If dbSeek(xFilial("SE1")+_cCLIENTE+_cLOJA+_cSERIE+_cDOC)
		 @ li,002  PSAY "Financeiro:"
		 LI := LI + 1
		 Do While (_cCLIENTE+_cLOJA+_cSERIE+_cDOC)==(SE1->E1_CLIENTE+SE1->E1_LOJA+SE1->E1_PREFIXO+SE1->E1_NUM)
			@ li,004  PSAY SE1->E1_PREFIXO
			@ li,010  PSAY SE1->E1_NUM
			@ li,018  PSAY SE1->E1_PARCELA
			@ li,021  PSAY SE1->E1_TIPO
			@ li,026  PSAY SE1->E1_VALOR			 PICTURE "@E 999,999.99"
			@ li,038  PSAY DTOC(SE1->E1_VENCREA)
			_cNomeArq  := "SE1030"
			dbUseArea(.T.,"TOPCONN",_cNomeArq,_cNomeArq,.t.,.f.)
			dbSelectArea(_cNomeArq)
			dbSetOrder(1)
			If _lCopia
			   //////////////////////////////////////
			   // Copia SE1 para Filial
			   //////////////////////////////////////
			   If dbSeek("00"+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO+SE1->E1_CLIENTE+SE1->E1_LOJA)
				  @ li,075	PSAY "Ok"
			   Else
				  @ li,075	PSAY "Erro"
			   EndIf
			Else
			   If dbSeek("00"+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO+SE1->E1_CLIENTE+SE1->E1_LOJA)
				  @ li,075	PSAY "Erro"
			   Else
				  @ li,075	PSAY "-"
			   EndIf
			EndIf
			dbCloseArea()
			dbSelectArea("SE1")
			LI := LI + 1
			_cChvSE3 := SE1->E1_PREFIXO+SE1->E1_NUM  //+SE1->E1_PARCELA
			dbSkip()
		 EndDo
	  EndIf
   EndIF
   If !Empty(_cChvSE3)
	  dbSelectArea("SE3")
	  dbSetOrder(1)
	  If dbSeek(xFilial("SE3")+_cChvSE3)
		  @ li,002	PSAY "Comissao:"
		 LI := LI + 1
		 Do While (_cChvSE3==SE3->E3_PREFIXO+SE3->E3_NUM)
			@ li,004  PSAY SE3->E3_PREFIXO
			@ li,010  PSAY SE3->E3_NUM
			@ li,018  PSAY SE3->E3_PARCELA
			@ li,021  PSAY SE3->E3_VEND
			@ li,030  PSAY SE3->E3_BASE 			PICTURE "@E 999,999.99"
			@ li,042  PSAY SE3->E3_PORC 			PICTURE "@E 999,999.99"
			@ li,054  PSAY SE3->E3_COMIS			PICTURE "@E 999,999.99"
			_cNomeArq  := "SE3030"
			dbUseArea(.T.,"TOPCONN",_cNomeArq,_cNomeArq,.t.,.f.)
			dbSelectArea(_cNomeArq)
			dbSetOrder(1)
			If _lCopia
			   //////////////////////////////////////
			   // Copia SE3 para Filial
			   //////////////////////////////////////
			   If dbSeek("00"+SE3->E3_PREFIXO+SE3->E3_NUM)
				  @ li,075	PSAY "Ok"
			   Else
				  @ li,075	PSAY "Erro"
			   EndIf
			Else
			   If dbSeek("00"+SE3->E3_PREFIXO+SE3->E3_NUM)
				  @ li,075	PSAY "Erro"
			   Else
				  @ li,075	PSAY "-"
			   EndIf
			EndIf
			dbCloseArea()
			dbSelectArea("SE1")
			LI := LI + 1
			_cChvSE3 := SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA
			dbSkip()
		 EndDo
	  EndIf
   EndIf
   @ li,000  PSAY REPLICATE("-",80)
   LI := LI + 1
   dbSelectArea("TRB")
   LI := LI + 1
EndDo

roda(cbcont,cbtxt,"G")


// Fecha e apaga os arquivos temporarios
dbSelectarea("TRB")
dbCloseArea()
Ferase(_cArqTRB+".DBF")
Ferase(_cArqTRB+OrdBagExt())

dbSelectarea("SQL")
dbCloseArea()

dbSelectarea("DEV")
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
__RetProc()


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ CRIASQL   ³ Funcao executa o SELECT.								  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function CriaSQL
Static Function CriaSQL()

cQuery := ''
cQuery :=		   "  SELECT   SF2.F2_DOC       DOC, "
cQuery := cQuery + "           SF2.F2_SERIE     SERIE, "
cQuery := cQuery + "           SF2.F2_TIPO      TIPO, "
cQuery := cQuery + "           SF2.F2_EMISSAO   EMISSAO, "
cQuery := cQuery + "           SF2.F2_CLIENTE   CLIENTE,  "
cQuery := cQuery + "           SF2.F2_LOJA      LOJA,  "
cQuery := cQuery + "           SF2.F2_X_COPFL   X_COPFL,  "
cQuery := cQuery + "           SD2.D2_ITEM      ITEM,  "
cQuery := cQuery + "           SD2.D2_COD       COD,  "
cQuery := cQuery + "           SD2.D2_LOCAL     LOCAL,  "
cQuery := cQuery + "           SD2.D2_QUANT     QUANT,  "
cQuery := cQuery + "           SD2.D2_PEDIDO    PEDIDO,  "
cQuery := cQuery + "           SD2.D2_LOTECTL   LOTECTL, "
cQuery := cQuery + "           SD2.D2_ITEMPV    ITEMPV "
cQuery := cQuery + "  FROM  SF2010 SF2, SD2010 SD2"
cQuery := cQuery + "  WHERE SF2.F2_FILIAL = '"+xfilial("SF2")+"' AND "
cQuery := cQuery + "        SD2.D2_FILIAL = '"+xfilial("SD2")+"' AND "
cQuery := cQuery + "        SF2.F2_DOC    =  SD2.D2_DOC     AND "
cQuery := cQuery + "        SF2.F2_SERIE  =  SD2.D2_SERIE   AND "
cQuery := cQuery + "        SF2.F2_EMISSAO BETWEEN '" +DTOS(MV_PAR01)+"' AND  '" +DTOS(MV_PAR02)+"' AND "
cQuery := cQuery + "        SF2.D_E_L_E_T_ <> '*'  "

MEMOWRIT("C:\SQL.txt",cQuery)
cQuery := ChangeQuery(cQuery)
dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"SQL", .F., .T.)
__RetProc()


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ CRIASQL   ³ Funcao executa o SELECT.								  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function CriaDEV
Static Function CriaDEV()

cQuery := ''
cQuery :=		   "  SELECT   SF1.F1_DOC       DOC, "
cQuery := cQuery + "           SF1.F1_SERIE     SERIE, "
cQuery := cQuery + "           SF1.F1_TIPO      TIPO, "
cQuery := cQuery + "           SF1.F1_DTDIGIT   EMISSAO, "
cQuery := cQuery + "           SF1.F1_FORNECE   CLIENTE,  "
cQuery := cQuery + "           SF1.F1_LOJA      LOJA,  "
cQuery := cQuery + "           SD1.D1_ITEM      ITEM,  "
cQuery := cQuery + "           SD1.D1_COD       COD,  "
cQuery := cQuery + "           SD1.D1_LOCAL     LOCAL,  "
cQuery := cQuery + "           SD1.D1_QUANT     QUANT  "
cQuery := cQuery + "  FROM  SF1010 SF1, SD1010 SD1"
cQuery := cQuery + "  WHERE SF1.F1_FILIAL = '"+xfilial("SF1")+"' AND "
cQuery := cQuery + "        SD1.D1_FILIAL = '"+xfilial("SD1")+"' AND "
cQuery := cQuery + "        SF1.F1_DOC    =  SD1.D1_DOC     AND "
cQuery := cQuery + "        SF1.F1_SERIE  =  SD1.D1_SERIE   AND "
cQuery := cQuery + "        SF1.F1_TIPO   =  'D'  AND "
cQuery := cQuery + "        SF1.F1_DTDIGIT BETWEEN '" +DTOS(MV_PAR01)+"' AND  '" +DTOS(MV_PAR02)+"' AND "
cQuery := cQuery + "        SF1.D_E_L_E_T_ <> '*'  "

MEMOWRIT("C:\SQLDEV.txt",cQuery)
cQuery := ChangeQuery(cQuery)
dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"DEV", .F., .T.)
__RetProc()



Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

