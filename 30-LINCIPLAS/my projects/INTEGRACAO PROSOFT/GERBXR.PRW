#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 10/02/02
#IFNDEF WINDOWS
	#DEFINE PSAY SAY
#ENDIF

User Function GERBXR()        // incluido pelo assistente de conversao do AP6 IDE em 10/02/02

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("ACAMPOS,CSTRING,ALINHA,CPERG,CSAVSCR1,CSAVCUR1")
SetPrvt("CSAVROW1,CSAVCOL1,CSAVCOR1,CNOME,CDATA,CNOMEARQ")
SetPrvt("NTREGS,CSAV7,XDEBITO,XCREDITO,XHIST01,XHIST02")
SetPrvt("XHIST03,NTAMANHO,CINTEIRO,CTAMVLR,CDECIMAL,NCONT")
SetPrvt("CANO,CMES,CDIA,XREGISTRO,_SALIAS,AREGS")
SetPrvt("I,J,cCTA_DEB,NPOSE5")

#IFNDEF WINDOWS
	// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 10/02/02 ==> 	#DEFINE PSAY SAY
#ENDIF

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ GERINT    ³ Autor ³                       ³ Data ³ 27.02.03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³  GERA ARQUIVO DE IMPORTACAO PARA PROSOFT - BAIXAS A RECEBER ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CONCRECON                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aCampos:={}
cString:="SE5"
aLinha := {}
cPerg  :="GERBXR"
ValidPerg()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Salva a Integridade dos dados de Entrada                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

pergunte("GERBXR",.T.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                        ³
//³ mv_par01            // Da Data de Emissao                   ³
//³ mv_par02            // Ate Data de Emissao                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Processa( {|| RunProc() },"Aguarde, Selecionando Registros..." )// Substituido pelo assistente de conversao do AP6 IDE em 10/02/02 ==> Processa( {|| Execute(RunProc) } )

dbcommitAll()

dbSelectArea("cNomeArq")
dbGotop()
cNome := "F:\CTBMOV04\CTBIMPOR.001"
cData := DTOS(MV_PAR01)
COPY TO &cNome SDF
dbCloseArea("cNomeArq") //Fecha
Return

// Substituido pelo assistente de conversao do AP6 IDE em 10/02/02 ==> Function RunProc
Static Function RunProc()

aCampos:={ {"REGISTRO" ,"C", 133,0}}
cNomeArq:=CriaTrab(aCampos)
Use &cNomeArq Alias cNomeArq New

dbSelectArea("SE5")
dbSetOrder(1)
Set Softseek On
dbSeek(xFilial()+DTOS(mv_par01))

Set Softseek Off

nTregs:= Reccount()
ProcRegua(nTregs)

xDebito := space(05)
xCredito:= space(05)
xHist01 := space(30)
xHist02 := space(30)
xHist03 := space(30)
nTamanho:=0
cInteiro:=""
cTamvlr :=0
cDecimal:=""
nCont   :=1

While !EOF() .and. SE5->E5_DATA <= mv_par02
	
	IncProc()
	
	dbSelectArea("SE1")
	dbSetOrder(1)
	dbSeek(xFilial()+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA)
	
	If Found()
		If SE1->E1_SITUACA=="2"
			dbSkip()
			Loop
		Endif
	Endif
	
	dbSelectArea("SE5")
	
	If SE5->E5_BANCO>"AAA"
		dbSkip()
		Loop
	Endif
	
	If SE5->E5_MOTBX=="CMP"
		dbSkip()
		Loop
	Endif
	
	If SE5->E5_RECPAG=="P"
		dbSkip()
		Loop
	Endif
	
	If SE5->E5_SITUACA=="C"
		DbSkip()
		Loop
	Endif
	
	If SE5->E5_TIPODOC=="DC"
		CTB_DESC()
		Loop
	Endif
	
	If SE5->E5_TIPODOC=="JR" .OR. SE5->E5_TIPODOC=="MT"
		CTB_JUROS()
		Loop
	Endif
	
	nPOSE5 := Recno()
	
	dbSelectArea("SA6")
	dbSetOrder(1)
	dbSeek(xFilial()+SE5->E5_BANCO+SE5->E5_AGENCIA+SE5->E5_CONTA)
	cCTA_DEB := SA6->A6_NUMBCO
	xDebito:=AllTrim(cCTA_DEB)
	
	dbSelectArea("SE5")
	dbSetOrder(1)
	dbGoTo(nPOSE5)
	
	xCredito:=SUBSTR(SE5->E5_CLIFOR,1,5)
	xHist01 := "NOSSA NF N. : " + SE5->E5_NUMERO + SPACE(10)
	cInteiro:=STRZERO(INT(SE5->E5_VALOR),11)
	cDecimal:=SUBSTR(STRZERO(SE5->E5_VALOR*100,14),13,2)
	cAno:=SUBSTR(STR(YEAR(SE5->E5_DATA)),17,2)
	cMes:=STRZERO(month(SE5->E5_DATA),2)
	cDia:=STRZERO(day(SE5->E5_DATA),2)
	xRegistro :=cAno+cMes+cDia+substr(SE5->E5_NUMERO,1,6)+xDebito+xCredito
	xRegistro :=xRegistro+xHist01+xHist02+xHist03+cInteiro+"."+cDecimal+Strzero(ncont,6)
	
	dbSelectArea("cNomeArq")
	reclock("cNomeArq",.T.)
	cNomeArq->REGISTRO := xRegistro
	
	dbSelectArea("SE5")
	dbSkip()
	nCont:=nCont+1
	
EndDo


Return

// Substituido pelo assistente de conversao do AP6 IDE em 10/02/02 ==> Function ValidPerg
Static Function ValidPerg()
_sAlias := Alias()
dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,10)
aRegs:={}

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
AADD(aRegs,{cPerg,"01","Data Inicial das Baixas ","","","mv_ch1","D",8,0,0,"G","","mv_par01","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"02","Data Final das Baixas","","","mv_ch2","D",8,0,0,"G","","mv_par02","","","","","","","","","","","","","","",""})

For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next

dbSelectArea(_sAlias)

Return

//******************************************************************************
//CONTABILIZA OS DESCONTOS
//******************************************************************************

Static Function CTB_DESC()
xDebito:="54264"
xCredito:=SUBSTR(SE5->E5_CLIFOR,1,5)
xHist01 := "DESCONTO S/NF N. : " + SE5->E5_NUMERO + "     "
cInteiro:=STRZERO(INT(SE5->E5_VALOR),11)
cDecimal:=SUBSTR(STRZERO(SE5->E5_VALOR*100,14),13,2)
cAno:=SUBSTR(STR(YEAR(SE5->E5_DATA)),17,2)
cMes:=STRZERO(month(SE5->E5_DATA),2)
cDia:=STRZERO(day(SE5->E5_DATA),2)
xRegistro :=cAno+cMes+cDia+substr(SE5->E5_NUMERO,1,6)+xDebito+xCredito
xRegistro :=xRegistro+xHist01+xHist02+xHist03+cInteiro+"."+cDecimal+Strzero(ncont,6)

dbSelectArea("cNomeArq")
reclock("cNomeArq",.T.)
cNomeArq->REGISTRO := xRegistro

dbSelectArea("SE5")
dbSkip()
nCont:=nCont+1

Return

//******************************************************************************
//CONTABILIZA OS JUROS
//******************************************************************************

Static Function CTB_JUROS()
dbSelectArea("SA6")
dbSetOrder(1)
dbSeek(xFilial()+SE5->E5_BANCO+SE5->E5_AGENCIA+SE5->E5_CONTA)
cCTA_DEB := SA6->A6_NUMBCO
xDebito:=AllTrim(cCTA_DEB)
dbSelectArea("SE5")

xCredito:="65112"
xHist01 := "JUROS RECEB. S/NF N. : " + SE5->E5_NUMERO + " "
cInteiro:=STRZERO(INT(SE5->E5_VALOR),11)
cDecimal:=SUBSTR(STRZERO(SE5->E5_VALOR*100,14),13,2)
cAno:=SUBSTR(STR(YEAR(SE5->E5_DATA)),17,2)
cMes:=STRZERO(month(SE5->E5_DATA),2)
cDia:=STRZERO(day(SE5->E5_DATA),2)
xRegistro :=cAno+cMes+cDia+substr(SE5->E5_NUMERO,1,6)+xDebito+xCredito
xRegistro :=xRegistro+xHist01+xHist02+xHist03+cInteiro+"."+cDecimal+Strzero(ncont,6)

dbSelectArea("cNomeArq")
reclock("cNomeArq",.T.)
cNomeArq->REGISTRO := xRegistro

dbSelectArea("SE5")
dbSkip()
nCont:=nCont+1

Return
