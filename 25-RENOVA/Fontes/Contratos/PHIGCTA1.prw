#INCLUDE "PROTHEUS.CH"    
#INCLUDE 'TOPCONN.CH'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ PHIGCTA1 º Autor                       º Data ³  Set/2008  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescr.    ³ Alteracoes na tabela CN9.                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Renova                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function PHIGCTA1()

Local _cAlias    := "CN9"
Local _cAlias2    := "CNB"
Local _nReg      := Recno()
Local _nOpc      := 4                              
Local _aCpos     := {}
Local _aCpoAlt   := {"CMB_CC","CNB_CONTA","CNB_ITEMCT"}
Local _aCpoAlt   := {"CN9_OBJCTO","CN9_CONDPG","CN9_INDICE","CN9_FLGREJ","CN9_XTPCO","CN9_XCODGE","CN9_XGRPRE","CN9_XGESTO","CN9_XPERAD","CN9_XCODUS","CN9_XUNIDR","CN9_APROV"}    
Local _lOk       := .F.
Local _aSize     := MsAdvSize()
Local _aPosObj   := {}
Local _aObjects  := {}
Local _cCadastro := "Manutencao de Contratos"
Local _aTela     := {}
Local _aGets     := {}
Local _oDlg
Local _nOpcA     := 0
Local _aCpoN     := {"CN9_JUSTIF","CN9_DESSTA","CN9_TIPREV","CN9_MOTPAR","CN9_DTFIMP","CN9_DTREIN","CN9_DTREAJ","CN9_VLREAJ","CN9_NUMTIT","CN9_ALTCLA","CN9_VLMEAC","CN9_TXADM","CN9_FORMA","CN9_DTENTR","CN9_LOCENT","CN9_CODENT","CN9_DESLOC","CN9_DESFIN","CN9_CONTFI","CN9_DTINPR","CN9_PERPRO","CN9_UNIPRO","CN9_VLRPRO","CN9_DTINCP","CN9_CLIENT","CN9_LOJACL"}
Local aTela[0][0]
Local aGets[0]
Local _nCntFor := 0
Local _nPosCpo := 0


_lOk := CN240VldUsr(CN9->CN9_NUMERO,"001",.T.)
If !_lOk
	Return
EndIf

dbSelectArea("SX3")
MsSeek("CN9")
		
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Seleciona os campos do cabecalho dos contratos     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
While !Eof() .And. SX3->X3_ARQUIVO == "CN9"
			
	If X3Uso(X3_USADO) .And. cNivel >= SX3->X3_NIVEL .And. Ascan(_aCpoN,{|x| x == alltrim(SX3->X3_CAMPO)}) == 0
		Aadd(_aCpos, SX3->X3_CAMPO )
	EndIF
			
	If	( SX3->X3_CONTEXT == "V" )
		M->&(SX3->X3_CAMPO) := CriaVar(SX3->X3_CAMPO)
	Else
		M->&(SX3->X3_CAMPO) := CN9->(FieldGet(FieldPos(SX3->X3_CAMPO)))
	EndIf
			
	dbSelectArea("SX3")
	dbSkip()
EndDo
	
DEFINE MSDIALOG _oDlg TITLE _cCadastro From _aSize[7],00 To _aSize[6],_aSize[5] OF oMainWnd PIXEL
//	_aPosEnch := {,,(_oDlg:nClientHeight - 4)/2,}  // ocupa todo o espaco da janela - QUE JÁ ESTAVA NO FONTE
	 //{Coluna Inicial, Linha Inicial, Linha Final, Coluna Final} - em mega pixel
	_aPosEnch := { 1,  1,_oDlg:nClientHeight /3 + 65, 655 }
	EnChoice( _cAlias, _nReg, _nOpc, , , ,_aCpos,_aPosEnch, _aCpoAlt , , , , , , , .F.)
ACTIVATE MSDIALOG _oDlg ON INIT (EnchoiceBar(_oDlg,{||If(Obrigatorio(aGets,aTela) /*.And. CN100TudOk()*/ ,(_nOpcA:=1,_oDlg:End()),_nOpcA:=0)},{||(_nOpcA:=2,_oDlg:End())},,))

If _nOpcA == 1
	Reclock("CN9",.F.)
		For _nCntFor := 1 To FCount()
			For nY := 1 to Len(_aCpoAlt)
				If FieldName(_nCntFor) == _aCpoAlt[nY]
					FieldPut(_nCntFor,M->&(FieldName(_nCntFor)))
				EndIf
			Next nY
		Next _nCntFor
	MsUnlock()
		
	MSMM(M->CN9_CODOBJ,,,M->CN9_OBJCTO,1,,,"CN9","CN9_CODOBJ")
EndIf

Return
