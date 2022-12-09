#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05
#IFNDEF WINDOWS
	#DEFINE PSAY SAY
#ENDIF

User Function Dvconflt()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CBTXT,CSTRING,CBCONT,WNREL,TITULO,CDESC1")
SetPrvt("CDESC2,CDESC3,TAMANHO,LIMITE,CGRTXT,ARETURN")
SetPrvt("NOMEPROG,NORDEM,NTIPO,ALINHA,NLASTKEY,CPERG")
SetPrvt("LI,M_PAG,LEND,_APERGUNTAS,_NLACO,AORD")
SetPrvt("_ACAMPOS,_CARQTMP,_NSALDOLOTE,_LZERO,_PRODLOC,_NTOTLOTE")
SetPrvt("_NTOTB2,CABEC1,CABEC2,_NUMPAG,_CPRODUTO,_CCODIGO")
SetPrvt("_CLOCAL,")

#IFNDEF WINDOWS
	// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 12/02/05 ==>     #DEFINE PSAY SAY
#ENDIF

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ DVCONFLT ³ Autor ³  Luciano Lorenzetti   ³ Data ³ 15/01/99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Efetua a conferencia entre os Saldos dos Lotes (SB8) e o   ³±±
±±³          ³ Saldo Atual (SB2).                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga - DENVER                ³±±
±±³          ³ Excuta a verificacao das divergencias entre SB2 e SB8, im- ³±±
±±³          ³ primindo todos os lotes e saldos dos produtos apontados.   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
CbTxt    := ""
cString  := "SB2"
CbCont   := ""
wnrel    := ""
titulo   := "Relacao Saldo de Lotes X Saldo Atual"
cDesc1   := "Emissao relacao de divergencias de Saldo de Lotes X Saldo Atual."
cDesc2   := "Nao possui parametros  -  Expecifico Denver Resinas"
cDesc3   := ""
tamanho  := "P"
limite   := 80
cGrtxt   := SPACE(11)
aReturn  := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1}
nomeprog := "DVCONFLT"
nOrdem   := aReturn[8]
nTipo    := IIF(aReturn[4]==1,15,18)
aLinha   := { }
nLastKey := 0
cPerg    :="DVCFLT"
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbtxt    := SPACE(10)
cbcont   := 00
li       := 80
m_pag    := 01
lEnd     := .F.

***TR><*** Verifica divergencia de saldos
_aPerguntas:= {}
//                  1       2          3                 4       5  6  7 8  9  10     11       12      13 14     15    16 17    18   19 20 21 22 23 24 25  26
AADD(_aPerguntas,{"DVCFLT    ","01","Tipo de Relatorio  ?","mv_ch1","N",01,0,0,"C","","mv_par01","Analitico","","","Sintetico","","","","","","","","","","","",})
dbSelectArea("SX1")

If dbSeek(_aPerguntas[1,1]+_aPerguntas[1,2])
	Do While SX1->X1_GRUPO == cPerg
		RecLock("SX1",.F.)
		DELETE
		MsUnLock()
		dbSkip()
	EndDo
EndIf

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
pergunte(cPerg,.F.)

wnrel:="DVCONFLT"            //Nome Default do relatorio em Disco
aOrd :={}
wnrel:=SetPrint(cString,wnrel,cPerg,titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,,Tamanho)

If nLastKey==27
	Set Filter to
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey==27
	Set Filter to
	Return
Endif

Processa({|| FILTRALOTE()},"Filtrando...")// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Processa({|| Execute(FILTRALOTE)},"Filtrando...")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Imprime o relat¢rios de inconsistˆncia.  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Processa({|| IMPRIME()},"Imprimindo...")// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Processa({|| Execute(IMPRIME)},"Imprimindo...")


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Apaga arquivos tempor rios                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectarea("TRB")
dbCloseArea()
Ferase(_cArqTmp+".DBF")
Ferase(_cArqTmp+OrdBagExt())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Apresenta relatorio na tela                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Set Device To Screen
If aReturn[5] == 1
	Set Printer TO
	dbcommitAll()
	ourspool(wnRel)
EndIf
MS_FLUSH()

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> __Return()
Return()                        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

***><*** Gera vetor de trabalho
// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function FILTRALOTE
Static Function FILTRALOTE()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria Arquivo de Trabalho                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_aCampos:={ {"CODIGO"  ,"C",15,0},;
{"LOCAL"   ,"C",02,0},;
{"SALDOB2" ,"N",14,4},;
{"SALDOLOT","N",14,4},;
{"LOTE"    ,"C",12,0}}
_cArqTmp := CriaTrab( _aCampos )
dbUseArea( .T.,, _cArqTmp, "TRB",.F.,.F.)
IndRegua ( "TRB",_cArqTmp,"CODIGO+LOCAL+LOTE",,,"Selecionando Registros...")


DbSelectArea("SB2")
DBSETORDER(1)
dbGoTop()
ProcRegua(RECCOUNT())
Do While !Eof() .and. SB2->B2_FILIAL == xFilial()
	_nSaldoLote := 0
	If GETADVFVAL("SB1","B1_RASTRO",xFilial("SB1")+SB2->B2_COD,1,"")<>"L"
		IncProc(OEMtoAnsi('Produto: '+SB2->B2_COD))
		dbSkip()
		Loop
	EndIf
	IncProc(OEMtoAnsi('Produto: '+SB2->B2_COD))
	dbSelectArea("SB8")
	dbseek(xFilial("SB8")+SB2->B2_COD+SB2->B2_LOCAL)
	If Found()
		Do While (SB8->B8_PRODUTO+SB8->B8_LOCAL == SB2->B2_COD+SB2->B2_LOCAL)
			_nSaldoLote := _nSaldoLote + (SB8->B8_SALDO) - SB8->B8_EMPENHO
			dbSkip()
		EndDo
		IF Round(_nSaldoLote,4) != Round(SB2->B2_QATU,4)
			dbseek(xFilial("SB8")+SB2->B2_COD+SB2->B2_LOCAL)
			_lZero := .T.
			Do While (SB8->B8_PRODUTO+SB8->B8_LOCAL == SB2->B2_COD+SB2->B2_LOCAL) .and. _lZero
				//		 If _nSaldoLote<>0 .and. SB8->B8_SALDO==0
				//			 dbSkip()
				//			 Loop
				//		  EndIf
				dbSelectArea("TRB")
				RecLock("TRB",.T.)
				TRB->CODIGO   := SB2->B2_COD
				TRB->LOCAL    := SB2->B2_LOCAL
				TRB->SALDOB2  := SB2->B2_QATU
				If _nSaldoLote == 0
					TRB->SALDOLOT := 0
					TRB->LOTE     := "Nao ha"
					_lZero := .F.
				Else
					TRB->SALDOLOT := SB8->B8_SALDO //_nSaldoLote
					TRB->LOTE     := SB8->B8_LOTECTL
				EndIf
				MsUnLock()
				DBSELECTAREA("SB8")
				dbSkip()
			EndDo
		EndIf
	EndIf
	dbSelectArea("SB2")
	dbSkip()
EndDo

Return


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Gera Relatorio de Controle de inconsistencias.   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function Imprime
Static Function Imprime()

_ProdLoc := " "
_nTotLote := 0
_nTotB2   := 0

If mv_par01 == 1
	cabec1   := "*                                                                              *"
Else
	cabec1   := "Codigo:          Local:      Saldo Fisico:         Saldo de Lotes:"
EndIf
cabec2   := " "

dbSelectArea("TRB")
dbGoTop()
ProcRegua(RECCOUNT())
li      := 60
_numpag := 0
Do While !EOF()
	
	IncProc(OEMtoAnsi('Produto: '+TRB->CODIGO))
	
	If li > 50
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
	Endif
	If mv_par01==1
		If _ProdLoc <> TRB->CODIGO+TRB->LOCAL
			_cProduto := GETADVFVAL("SB1","B1_DESC",xFILIAL("SB1")+TRB->CODIGO ,1,"")
			@ li,01 PSAY "Produto: " + AllTrim(TRB->CODIGO) + " - " + _cProduto
			li := li + 1
			@ li,01 PSAY "Local: "+TRB->LOCAL
		EndIf
		@ li,44 PSAY "Lote:"
		@ li,50 PSAY TRB->LOTE
		@ li,66 PSAY Str(TRB->SALDOLOT,14,4)
		li := li + 1
	EndIf
	_cCodigo  := TRB->CODIGO
	_cLocal   := TRB->LOCAL
	_nTotLote := _nTotLote + TRB->SALDOLOT
	_nTotB2   := TRB->SALDOB2
	_ProdLoc  := TRB->CODIGO+TRB->LOCAL
	dbSkip()
	If li > 50
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
	Endif
	If _ProdLoc <> TRB->CODIGO+TRB->LOCAL
		If mv_par01==1
			@ li,44 PSAY REPLICATE("-",37)
			li := li + 1
			@ li,02 PSAY "Total do Estoque:"
			@ li,20 PSAY Str(_nTotB2,14,4)
			@ li,51 PSAY "Total de Lotes:"
			@ li,67 PSAY Str(_nTotLote,14,4)
			li := li + 1
			@ li,00 PSAY REPLICATE("-",80)
		Else
			@ li,03 PSAY _cCodigo
			@ li,20 PSAY _cLocal
			@ li,28 PSAY Str(_nTotB2,14,4)
			@ li,52 PSAY Str(_nTotLote,14,4)
		EndIf
		_nTotLote := 0
		_nTotB2   := 0
		li := li + 1
		If li > 50
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
		Endif
	EndIf
EndDo
roda(cbcont,cbtxt,tamanho)
return

