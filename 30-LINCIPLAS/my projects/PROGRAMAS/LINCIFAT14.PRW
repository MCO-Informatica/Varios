#include "rwmake.ch"
#include "topconn.ch"
#IFNDEF WINDOWS
	#DEFINE PSAY SAY
#ENDIF
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LINCFAT14 º Autor ³ RODRIGO DEMETRIOS  º Data ³  13/04/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ RELATORIO METAS X REALIZADO                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Financeiro                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function LIFAT14()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cDesc1       := "Este Programa Tem Como Objetivo Imprimir Relatório "
cDesc2       := "De Acordo Com os Parametros Informados Pelo Usuario."
cDesc3       := "METAS X REALIZADO"
cPict        := ""
titulo       := "METAS X REALIZADO"
nLin         := 80
imprime      := .T.
lEnd         := .F.
lAbortPrint  := .F.
CbTxt        := ""
limite       := 132
tamanho      := "M"
nomeprog     := "LIFAT14"
nTipo        := 15
aReturn      := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
nLastKey     := 0
_cPerg       := "LIFA14"
cbtxt        := Space(10)
cbcont       := 00
CONTFL       := 01
m_pag        := 01
wnrel        := "LIFAT14"
cString      := "SD2"
_nTotNcc     := 0
_nTotal      := 0
nOrdem       := 1
CABEC1       := "NATUREZA        DESCRICAO               INDICE         META            REALIZADO         A REALIZAR      REALIZADO +     STATUS"
CABEC2       := "                                                                                                         A REALIZAR"

dbSelectArea("SD2")
dbSetOrder(1)

ValidPerg() // Valida as Perguntas

pergunte(_cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint(cString,NomeProg,_cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif


RptStatus({|| RFAT14() },Titulo)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RFAT14    º Autor ³ RODRIGO CORREA     º Data ³  13/04/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RFAT14()


_dFATDe  := mv_par01
_dFATAte := mv_par02
_dPAGde  := mv_par03
_dPAGate := mv_par04
_dVENde  := mv_par05
_dVENate := mv_par06



//	Cria arq. de trabalho

aCampos := {}
Aadd(aCampos,{"TRB_NATURE"		, "C",10, 0})
Aadd(aCampos,{"TRB_VALOR"		, "N",14, 2})
Aadd(aCampos,{"TRB_IMP"		    , "C",01, 0})

_cArqTmp := CriaTrab(aCampos,.T.) 	//arquivo temporario sc
DbCreate(_cArqTMP,aCampos)
DbUseArea( .T.,,_cArqTmp,"TRB",Nil,.F.)

cNomArq1 := CriaTrab(nil,.f.)

Indregua("TRB",cNomArq1,"TRB_NATURE",,,"Selecionando Registros...")


dbSelectArea("SE2")
cFilTrab   := CriaTrab("",.F.)
cCondicao  := " Dtos(E2_VENCREA)>='"+Dtos(MV_PAR05)+"' .And. Dtos(E2_VENCREA)<='"+Dtos(MV_PAR06)+"' .AND. E2_SALDO > 0 .AND. E2_TIPO <> 'NDF'"
IndRegua("SE2",cFilTrab,"E2_FILIAL+E2_NATUREZ",,cCondicao,"Filtrando")    // "Selecionando Registros..."
dbSelectArea("SE2")
DbGoTop()
SetRegua(RecCount())

While !Eof()
	IncRegua()
	
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	NDIAS  := 0
	NVALOR := 0
	NVALCORRECAO := 0
	_cNATUREZ := SE2->E2_NATUREZ
	_DATAATU  := DDATABASE
	
	While !Eof()  .AND. _cNATUREZ == SE2->E2_NATUREZ
		IncRegua()
		
		NDIAS  += _DATAATU - SE2->E2_VENCREA
		
		IF NDIAS > 0
			NVALCORRECAO := NDIAS * SE2->E2_VALJUR
		ENDIF
		
		NVALOR += SE2->E2_SALDO + NVALCORRECAO
		
		NDIAS  := 0
		NVALCORRECAO := 0
		
		
		dbSelectArea("SE2")	 			                                                 //BUSCA VALOR DO IPI NO PRODUTO....
		dbSkip()             // Avanca o ponteiro do registro no arquivo
	End
	
	dbSelectArea("TRB")
	Reclock("TRB",.T.)
	Replace TRB_NATURE     With   _cNATUREZ
	Replace TRB_VALOR      With   NVALOR
	Msunlock()
	
	dbSelectArea("SE2")
End

dbSelectArea("SE2")
retindex()

// daqui para baixo ok
dbSelectArea("SD2")
dbSetOrder(5)
dbGoTop()
cArqSD2 := CriaTrab( NIL,.F. )
cFilSD2 := "DTOS(D2_EMISSAO)>='"+DTOS(mv_par01)+"'.And.DTOS(D2_EMISSAO)<='"+DTOS(mv_par02)+"'"
cFilSD2 += ".And.(D2_TES $'501/502/504/506/507/528/534/535/536/541/542/543/545/547/552/554/555/557/559/561/562/564')"
IndRegua("SD2",cArqSD2,"D2_FILIAL+DTOS(D2_EMISSAO)",,cFilSD2,"Processando")
dbGoTop()

_nTotal  := 0
_nTotGer := 0
SetRegua(RecCount())
While !Eof()
	IncRegua()
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica o cancelamento pelo usuario...                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Impressao do cabecalho do relatorio. . .                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 10
	Endif
	
	_nTotger  += SD2->D2_TOTAL + SD2->D2_VALIPI
	dbSelectArea("SD2")
	dbSkip()             // Avanca o ponteiro do registro no arquivo
End

//
// Impreime Total Geral
//

nLin := nLin + 2   // Avanca a linha de impressao
@nLin,00 PSAY "TOTAL FATURADO: "

_nTotger := mv_par07
@nLin,30 PSAY _nTotger  PICTURE "@E 99,999,999.99"
nLin := nLin + 2   // Avanca a linha de impressao

dbSelectArea("SD2")
retindex()



//          1         2         3         4         5         6         7         8         9         0         11        12        13
//0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
//NATUREZA        DESCRICAO               INDICE         META            REALIZADO         A REALIZAR      REALIZADO +     STATUS
//9999999999      XXXXXXXXXXXXXXXXXXXX    999,99     99,999,999.99     99,999,999.99     99,999,999.99     A REALIZAR      XXXXXXXXXXXX
//99,999,999.99



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Filtra o Arquivo utilizando um Select                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


dbSelectArea("SE5")
dbSetOrder(1)

cFilTrab   := CriaTrab(NIL,.F.)
cCondicao  := "(E5_TIPODOC != 'DC'.AND. E5_TIPODOC != 'JR' .AND. E5_TIPODOC != 'MT' .AND. E5_TIPODOC != 'CH' .AND. E5_TIPODOC != 'TR' .AND. E5_TIPODOC != 'ES') .AND. E5_SITUACA != 'C' .AND. E5_RECPAG = 'P' .AND. "
cCondicao  += "(E5_NATUREZ != '12010709  ' .AND. E5_NATUREZ != '22010708  ' .AND. E5_NATUREZ != 'DESCONT   ') .AND. "
cCondicao  += " DTOS(E5_DATA) >= '" +DTOS(MV_PAR03)+ "'.And.DTOS(E5_DATA) <= '"+DTOS(MV_PAR04)+ "'    .AND. E5_MOTBX != 'DAC' .AND. E5_MOTBX != 'FAT' .AND. E5_MOTBX != 'CMP'"
cChave := "E5_FILIAL+E5_NATUREZ"
IndRegua("SE5",cFilTrab,cChave,,cCondicao,"Filtrando")    // "Selecionando Registros..."
dbSelectArea("SE5")
DbGoTop()
SetRegua(RecCount())
_NTOTGERPAG := 0
_NTOTGERVEN := 0
_NTOTGERGER := 0

While !Eof()
	IncRegua()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica o cancelamento pelo usuario...                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	
	_cNatureza := SE5->E5_NATUREZ
	
	_nTotalPAG := 0
	_nTotalVEN := 0
	_nTotalGER := 0
	_META      := 0
	
	DBSELECTAREA("SED")
	DBSETORDER(1)
	DBSEEK(XFILIAL("SED")+_cNatureza)
	cDescric := sed->ed_descric
	nindice  := sed->ed_indice
	
	DBSELECTAREA("SE5")
	
	While !Eof() .AND. SE5->E5_NATUREZ == _cNatureza
		IncRegua()
		
		If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 10
		Endif
		
		_nTotalPAG  += SE5->E5_VALOR
		
		dbSelectArea("SE5")
		dbSkip()
	EndDo
	
	@nLin,000 PSAY SUBSTR(_cNATUREZA,1,10) + "      " +  substr(cDESCRIC,1,20) //NATUREZA/DESCRICAO
	
	@nLin,040 PSAY nindice  PICTURE "@E 99.9999" //INDICE
	_META := (nindice * _nTotger) / 100
	@nLin,051   PSAY _META  PICTURE   "@E 9,999,999.99"  //META
	@nLin,069 PSAY _nTotalPAG PICTURE "@E 9,999,999.99"  //REALIZADO
	
	DBSELECTAREA("TRB")
	DBSETORDER(1)
	IF DBSEEK(_cNatureza)
		
		@nLin,087 PSAY TRB_VALOR PICTURE "@E 9,999,999.99"  //A REALIZAR
		@nLin,104 PSAY TRB_VALOR + _nTotalPAG PICTURE "@E 9,999,999.99"  //REALIZADO + A REALIZAR
		
		Reclock("TRB",.F.)
		Replace TRB_IMP With "X"
		Msunlock()
	ELSE
		@nLin,094 PSAY "00,00"  //A REALIZAR
		@nLin,104 PSAY _nTotalPAG PICTURE "@E 9,999,999.99"  //REALIZADO 
		
	ENDIF
	
	_nTotalVEN  += TRB_VALOR
	_nTotalGER  += TRB_VALOR + _nTotalPAG
	
	DBSELECTAREA("SE5")
	nLin := nLin + 1
	_nTotGERPAG  +=  _NTOTALPAG
	_nTotGERVEN  +=  _NTOTALVEN
	_nTotGERGER  +=  _NTOTALGER
	
ENdDo

DBSELECTAREA("TRB")
DBGOTOP()
_nTotVEN := 0
While !Eof()
_META    := 0
	
	IF TRB_IMP <> "X"
		IncRegua()
		
		If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 10
		Endif

		_cNaturez := TRB_NATUREZ
	
	
		DBSELECTAREA("SED")
		DBSETORDER(1)
		DBSEEK(XFILIAL("SED")+_cNaturez)
		cDescric := sed->ed_descric
		nindice  := sed->ed_indice
		
		DBSELECTAREA("TRB")

		@nLin,000 PSAY SUBSTR(_cNATUREZ,1,10) + "      " +  substr(cDESCRIC,1,20) //NATUREZA/DESCRICAO
		@nLin,040 PSAY nindice  PICTURE "@E 99.9999" //INDICE
		_META := (nindice * _nTotger) / 100
		@nLin,051   PSAY _META  PICTURE   "@E 9,999,999.99"  //META
		@nLin,076 PSAY "00,00"  
 		@nLin,087 PSAY TRB_VALOR PICTURE "@E 9,999,999.99"  //A REALIZAR
		@nLin,104 PSAY TRB_VALOR PICTURE "@E 9,999,999.99"  //A REALIZAR
		
		_nTotVEN += TRB_VALOR
		nLin := nLin + 1
		
	ENDIF
	dbSelectArea("TRB")
	dbSkip()
EndDo


nLin := nLin + 1
nLin := nLin + 1

@nLin,000 PSAY "TOTAL GERAL" + " --------------------------------------------------> "
@nLin,069 PSAY _nTotGERPAG PICTURE "@E 9,999,999.99"
@nLin,087 PSAY _nTotGERVEN + _nTotVEN PICTURE "@E 9,999,999.99"
@nLin,104 PSAY _nTotGERGER + _nTotVEN PICTURE "@E 9,999,999.99"

dbSelectArea("SE5")
retindex()

nLin := nLin + 1
nLin := nLin + 1

dbSelectArea("TRB")
dbclosearea()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SET DEVICE TO SCREEN

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em disco, chama o gerenciador de impressao...          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SET PRINTER TO
OurSpool(wnrel)

MS_FLUSH()

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ ValidPerg ³ Autor ³ Denilson Correa      ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Valida se existe as Perguntas no SX1                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ValidPerg()

_cAlias := Alias()
DbSelectArea("SX1")
DbSetOrder(1) 
_cPerg := PADR(_cPerg,10)
aRegs :={}

Aadd(aRegs,{_cPerg,"01","Data Faturamento de   ?","","","mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{_cPerg,"02","Data Faturamento Ate  ?","","","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{_cPerg,"03","Data Pagamento de     ?","","","mv_ch3","D",08,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{_cPerg,"04","Data Pagamento Ate    ?","","","mv_ch4","D",08,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{_cPerg,"05","Dt. a Vencer  de      ?","","","mv_ch5","D",08,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{_cPerg,"06","Dt. a Vencer ate      ?","","","mv_ch6","D",08,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{_cPerg,"07","Estimativa Faturamento?","","","mv_ch7","N",14,2,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","",""})

For i:=1 to Len(aRegs)
	If !dbSeek(_cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			EndIf
		Next
		MsUnlock()
	EndIf
Next
DbSelectArea(_cAlias)
Return

