#include "protheus.ch"

User Function GQREENTR()
Local om_Obs
Local cm_Obs := ""
Local lOk := .f.
Local aButtons	:= {}
Local aD1	:= {}
Local aF1	:= {}
Local aD2	:= {}
Local aF2	:= {}
Local aD7	:= {}
Local cKey :=""
Local lXHORA := .F.
Private oDlg				// Dialog Principal

DEFINE MSDIALOG oDlg TITLE "Observações da NFe" FROM 0,0 TO 195,400 PIXEL

// Cria as Groups do Sistema
@ 35,5 TO 100,195 LABEL " Observações: (máximo 200)" PIXEL OF oDlg

// Cria Componentes Padroes do Sistema
@ 45,10 GET om_Obs Var cm_Obs MEMO Size 180,50 PIXEL OF oDlg

ACTIVATE MSDIALOG oDlg CENTERED  ON INIT EnchoiceBar(oDlg, {|| if( ValObs(cm_Obs),(lOk := .t., oDlg:End()),nil) },{|| lOk := .f.,oDlg:End()},,aButtons)

if ( lOk )
	RecLock("SF1", .f.)
	SF1->F1_OBSNFE := cm_Obs
	SF1->(MsUnlock())
endIf

//Grava a hora da inclusao da NF conforme solicitado pelo Carlao
RecLock("SF1",.F.)
SF1->F1_HORA := Time()
SF1->( msUnlock() )

//Grava a obs da NF no Histórico do título. Implementado em 12/09/11 por Daniel a pedido de Wilson (PGN 1981)
dbSelectArea("SE2")
dbSetOrder(6)
If dbSeek(  xFilial("SE2") + SF1->(F1_FORNECE + F1_LOJA + F1_PREFIXO + F1_DUPL)  )
	do While !Eof() .and. SE2->(E2_FILIAL + E2_FORNECE + E2_LOJA + E2_PREFIXO + E2_NUM) == xFilial("SE2") + SF1->(F1_FORNECE + F1_LOJA + F1_PREFIXO + F1_DUPL)
		RecLock("SE2",.F.)
		SE2->E2_HIST := SF1->F1_OBSNFE
		msUnlock()
		dbSkip()
	Enddo
Endif
//Grava data de fabricação na tabela de endereçamento by leandro duarte 29/08/2013
aD1 := SD1->(GETAREA())
aF1	:= SF1->(GETAREA())
aD2 := SD2->(GETAREA())
aF2	:= SF2->(GETAREA())
aD7	:= SD7->(GETAREA())
cKey := xFilial("SD1")+SF1->(F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA)
dbSelectArea("SD7")
SD7->(dbSetOrder(2))
SD1->(DBSETORDER(1))
SD1->(DBSEEK(cKey))
If FieldPos("D7_XHORA") > 0
		lXHORA := .T.
EndIf

WHILE cKey == xFilial("SD1")+SD1->(D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA)
	IF SD7->(dbSeek(xFilial("SD7") + SD1->D1_NUMCQ + SD1->D1_COD + SD1->D1_LOCAL + SD1->D1_NUMSEQ))
		If SD7->D7_LOTECTL == SD1->D1_LOTECTL .and. SD7->D7_FORNECE = SF1->F1_FORNECE .and. SD7->D7_LOJA =  SF1->F1_LOJA .and. SD7->D7_SERIE = SF1->F1_SERIE .and. SD7->D7_DOC = SF1->F1_DOC .and. SD7->D7_NUMLOTE = SD1->D1_NUMLOTE
			RecLock("SD7",.F.)
			SD7->D7_DTFABRI := SD1->D1_DFABRIC
			if lXHORA
				SD7->D7_XHORA	:=  IIF(empty(SF1->F1_HORA),LEFT(TIME(),5), LEFT(SF1->F1_HORA,5) )
			endIf
			msUnlock()
		Endif
	ENDIF
	SD1->(DBSKIP())
END
RestArea(aD1)
RestArea(aF1)
RestArea(aD2)
RestArea(aF2)
RestArea(aD7)
//Altera Local para 01 quando for NF complementar (Implementado em 09/12/11 por Daniel a pedido de Anderson (PGN 2678 / 2474)
//If SF1->F1_TIPO == "C" .or. SF1->F1_TIPO == "I" .or. SF1->F1_TIPO == "P"

If SF1->F1_TIPO == "I" .or. SF1->F1_TIPO == "P"
	dbSelectArea("SD1")
	dBSetOrder(1)
	dbSeek( xFilial("SD1") + SF1->(F1_DOC + F1_SERIE + F1_FORNECE + F1_LOJA) )
	do While !Eof() .and. SD1->D1_FILIAL == xFilial("SD1") .and. SD1->(D1_DOC + D1_SERIE + D1_FORNECE + D1_LOJA) == SF1->(F1_DOC + F1_SERIE + F1_FORNECE + F1_LOJA)
		RecLock("SD1",.F.)
		SD1->D1_LOCAL := "01"
		msUnlock()
		SD1->(dbSkip())
	Enddo
	
ELSEIf SF1->F1_TIPO == "C"
	if cEmpAnt == '01'
		dbSelectArea("SD1")
		dBSetOrder(1)
		dbSeek( xFilial("SD1") + SF1->(F1_DOC + F1_SERIE + F1_FORNECE + F1_LOJA) )
		do While !Eof() .and. SD1->D1_FILIAL == xFilial("SD1") .and. SD1->(D1_DOC + D1_SERIE + D1_FORNECE + D1_LOJA) == SF1->(F1_DOC + F1_SERIE + F1_FORNECE + F1_LOJA)
			RecLock("SD1",.F.)
			SD1->D1_LOCAL := "98"
			msUnlock()
			SD1->(dbSkip())
		Enddo
	Endif	
Endif

If Alltrim(CESPECIE) $ 'CTE|CTR' .AND. CTIPO == "C"
	cChaveSD1 := xFilial("SD1")+cNFiscal+cSerie+cA100For+cLoja
	cChaveSFT := xFilial("SD1")+"E"+cSerie+cNFiscal+cA100For+cLoja
	cCFOPS := '1353|2353'
	
	dbSelectArea("SD1")
	dBSetOrder(1)
	If SD1->(MsSeek(cChaveSD1))
		While !SD1->(Eof()).and. cChaveSD1 == SD1->D1_FILIAL+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA
			IF Alltrim(SD1->D1_CF) $ cCFOPS
				RecLock("SD1",.F.)
				SD1->D1_CLASFIS := '000'
				msUnlock()
				SD1->(dbSkip())
			Endif
		EndDo
	Endif
	
	DBSELECTAREA("SFT")
	dBSetOrder(1)
	If SFT->(MsSeek(cChaveSFT))
		While !SFT->(Eof()) .and. cChaveSFT == SFT->FT_FILIAL+"E"+SFT->FT_SERIE+SFT->FT_NFISCAL+SFT->FT_CLIEFOR+SFT->FT_LOJA
			If Alltrim(SFT->FT_CFOP) $ cCFOPS
				RecLock("SFT",.F.)
				SFT->FT_CLASFIS := '000'
				MsUnLock()
				SFT->(dbSkip())
			Endif
		EndDo
	Endif
Endif

Return(.T.)


static function ValObs( cObs )
if len( cObs ) > 200
	msgAlert( "O conteúdo da observação deverá conter no máximo 200 caracterers. Você digitou até o momento " + alltrim(str(len(cObs))) + " caracteres.","Atencao")
	return .f.
endIf
Return .t.
