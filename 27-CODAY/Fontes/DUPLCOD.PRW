#include "rwmake.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ DUPLCOD  ³ Autor ³  Rosane Rodrigues     ³ Data ³ 23/07/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Duplicata da empresa CODAY                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function Duplcod()       // incluido pelo assistente de conversao do AP5 IDE em 24/07/02

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("WNREL,TAMANHO,LIMITE,TITULO,CDESC1,CDESC2,CDESC3")
SetPrvt("CSTRING,LCONTINUA,NLASTKEY,ARETURN,NOMEPROG,CPERG,NLIN")
SetPrvt("NLINOT,EXTENSO,NVAL,")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

NVAL := 0
cabec1    := ""
cabec2    := ""
cabec3    := ""
tamanho   := "G"
limite    := 220
titulo    := "Duplicata Coday"
cDesc1    := "Este programa ira emitir a Duplicata da CODAY"
cDesc2    := ""
cDesc3    := ""
cString   := "SE1"
lContinua := .T.
nLastKey  := 0
aReturn   := { "Especial", 1,"Administracao", 2, 2, 1, "",1 }
nomeprog  := "DUPLCOD"
wnrel     := "DUPLCOD"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

nLin     := -39
nLiNot   := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas, busca o padrao da NFSAI  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cPerg := "DUPLIC    "
validperg()
Pergunte(cPerg, .F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01             // Da Nota                              ³
//³ mv_par02             // Ate a Nota                           ³
//³ mv_par03             // Serie                                ³
//³ mv_par04             // Da Parcela                           ³
//³ mv_par05             // Ate Parcela                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel:=SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.F.,"")

If LastKey() == 27 .or. nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If LastKey() == 27 .OR. nLastKey == 27
	Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Salva posicoes para movimento da regua de processamento      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

RptStatus({|| RptDetail()})// Substituido pelo assistente de conversao do AP5 IDE em 24/07/02 ==>    RptStatus({|| Execute(RptDetail)})
Return

//
Static Function RptDetail()

SetRegua(RecCount())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Posiciona o SE1 para buscar os dados da duplicata             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

dbSelectArea("SE1")
dbSetOrder(1)
Set Softseek On
dbSeek(xFilial("SE1")+mv_par03+mv_par01)
Set Softseek off
SetPrc(0,0)

//@ 00, 000 PSAY Chr(18)               // Descompressao de Impressao
@ 00, 000 PSAY Chr(27)+"M"            // Compressao Impressao A 12 CPP.
XCONDPAG="  "
While !eof() .and. SE1->E1_FILIAL == xFilial() .and. SE1->E1_NUM <= mv_par02
	
	If SE1->E1_PREFIXO # mv_par03
		dbSkip()
		Loop
	Endif
	
	If SE1->E1_PARCELA < mv_par04 .OR. SE1->E1_PARCELA > mv_par05
		dbSkip()
		Loop
	Endif
	
	nLin   := nLin + 39
	nLiNot := 15
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se houve interrup‡„o pelo operador      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	#IFNDEF WINDOWS
		IF LastKey()==286
			@ 00,01 PSAY "** CANCELADO PELO OPERADOR **"
			lContinua := .F.
			Exit
		Endif
	#ELSE
		IF lAbortPrint
			@nLin+nLiNot,001 Say "** CANCELADO PELO OPERADOR **"
			lContinua := .F.
			Exit
		Endif
	#ENDIF
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualiza barra de Status                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	IncRegua()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Posiciona o SA1(Cliente) para buscar os Dados                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	dbSelectArea("SA1")
	dbSetOrder(1)
	dbSeek(xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA)

	dbSelectArea("SE1")
	nLiNot := 08
	@ nLin+nLiNot,065 PSAY Chr(18)     // Adicionado para teste - 23/9/2004
	@ nLin+nLiNot,065 PSAY SE1->E1_EMISSAO
	nLiNot := 12
	@nLin+nLiNot,014 PSAY SE1->E1_NUM + Iif(SE1->E1_PARCELA#'',"/" + SE1->E1_PARCELA,"")
	@nLin+nLiNot,030 PSAY SE1->E1_VALOR   PICTURE "@E@Z 99,999,999.99"
	@nLin+nLiNot,050 PSAY SE1->E1_NUM + Iif(SE1->E1_PARCELA#'',"/" + SE1->E1_PARCELA,"")
	Dbselectarea("SF2")
	Dbsetorder(1)
	Dbseek(Xfilial("SF2")+SE1->E1_NUM+SE1->E1_PREFIXO)
	xCONDPAG:=SF2->F2_COND
	If XCONDPAG="002"
		@nLin+nLiNot,069 PSAY "C. APRES."
	Else
		@nLin+nLiNot,069 PSAY SE1->E1_VENCREA
	Endif
	nLiNot:=17
	
	@nLin+nLiNot,027 PSAY SA1->A1_NOME
	@nLin+nLiNot,070 PSAY SA1->A1_COD
	nLiNot:=19
	@nLin+nLiNot,027 PSAY SA1->A1_END
	@nLin+nLiNot,072 PSAY SA1->A1_CEP PICTURE "@R 99999-999"
	nLiNot:=21
	@nLin+nLiNot,027 PSAY SA1->A1_MUN
	@nLin+nLiNot,072 PSAY SA1->A1_EST
	nLiNot:=23
	@nLin+nLiNot,027 PSAY SA1->A1_ENDCOB + " " + SUBSTR(SA1->A1_CEPC,1,5) + "-" + SUBSTR(SA1->A1_CEPC,6,3)
	nLiNot:=24
	@nLin+nLiNot,027 PSAY SA1->A1_MUNC+" "+SA1->A1_ESTC
	nLiNot:=25
	@nLin+nLiNot,027 PSAY SA1->A1_CGC PICTURE "@R 99.999.999/9999-99"
	@nLin+nLiNot,070 PSAY SA1->A1_INSCR
	nLiNot:=27
	EXTENSO:=EXTENSO(SE1->E1_VALOR,.F.,SE1->E1_MOEDA)
	@nLin+nLiNot,027 PSAY SUBS(EXTENSO,1,60)+REPLI("*",60-LEN(TRIM(SUBSTR(EXTENSO,1,60))))
	nLiNot:=28
	@nLin+nLiNot,027 PSAY SUBS(EXTENSO,61,60)+REPLI("*",60-LEN(TRIM(SUBSTR(EXTENSO,61,60))))
	
	dbSelectArea("SE1")
	dbSkip()
EndDo

//@ prow()+9,000 PSAY chr(18)   // Descompressao de Impressao
//@ prow()+9,000 say " "

@ 00, 000 PSAY CHR(64)  // Reset na impressora
@ 00, 000 PSay " "
SetPrc(0,0)             // (Zera o Formulario)

dbSelectArea("SE1")
dbSetOrder(1)
Set Device To Screen
If aReturn[5] == 1
	Set Printer TO
	dbcommitAll()
	ourspool(wnrel)
Endif

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±
±³Funcao    ³VALIDPERG³ Autor ³ Rosane Rodrigues ³ Data ³ 23.07.02 ³±
±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±
±³Descricao ³ Verifica perguntas, incluindo-as caso nao existam    ³±
±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±
±³Uso       ³ SX1                                                  ³±
±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/
Static Function VALIDPERG
ssAlias      := Alias()
cPerg        := PADR(cPerg,10)
aRegs        := {}
dbSelectArea("SX1")
dbSetOrder(1)
AADD(aRegs,{cPerg,"01","Da Nota       ?"," "," ","mv_ch1","C",06,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"02","Ate a Nota    ?"," "," ","mv_ch2","C",06,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"03","Serie         ?"," "," ","mv_ch3","C",03,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"04","Da Parcela    ?"," "," ","mv_ch4","C",01,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"05","Ate a Parcela ?"," "," ","mv_ch5","C",01,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","",""})

For i := 1 to Len(aRegs)
	If !DbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j := 1 to FCount()
			FieldPut(j,aRegs[i,j])
		Next
		MsUnlock()
	Endif
Next
DbSelectArea(ssAlias)
Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³      FIM DO PROGRAMA                                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
