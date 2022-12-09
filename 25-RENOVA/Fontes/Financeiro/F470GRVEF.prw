#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜ±±ºUso       ³ Renova                                                     º±±±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function F470GRVEF()

Local _cAlias := Paramixb[1]                    // TMP
Local _EC05DB := SPACE(11) // Entidade 05 Debito - Tabela CV0
Local _EC05CR := SPACE(11) // Entidade 05 Credito - Tabela CV0
Local _oDlg4
Local _aAreat := GetArea()
Local _nRecno := TRB->(Recno())


If mv_par11 == 1  // Só executa PE se for flagado no parametro para mostrar tela de efetivação.
	
	DEFINE MSDIALOG _oDlg4 FROM  69,70 TO 267,400 TITLE "Classe Orcamentaria" PIXEL	//Classe"
	@ 0, 2 TO 97, 133 OF _oDlg4 PIXEL //CTB050SXB
	
	@07, 80 MSGET _EC05DB F3 "CTHESP" VALID (!Empty(_EC05DB) .or. CTB105EntC(,_EC05DB,,'05')) SIZE 50, 10 OF _oDlg4 PIXEL //HASBUTTON
	@07, 08 SAY  "Classe Orc. Deb."  SIZE 80, 7 OF _oDlg4 PIXEL  //"Classe Valor Deb."
	@28, 80 MSGET _EC05CR F3 "CTHESP" VALID (!Empty(_EC05CR) .or. CTB105EntC(,_EC05CR,,'05')) SIZE 50, 10 OF _oDlg4 PIXEL //HASBUTTON
	@28, 08 SAY "Classe Orc. Cred."  SIZE 80, 7 OF _oDlg4 PIXEL  //"Classe Valor Cred."
	@060, 30 BUTTON "Ok"	SIZE 30, 15 PIXEL OF _oDlg4 ACTION {||_oDlg4:End(), lEnc := .T. }
	@060, 90 BUTTON "Cancelar"	SIZE 30, 15 PIXEL ACTION _oDlg4:End()
	
	ACTIVATE MSDIALOG _oDlg4 CENTERED
	
	
	Dbgoto(_nRecno)                //VAI PARA O REGISTRO DA TRB POSICIONADO
	RecLock(_cAlias,.F.)
		(_cAlias)->E5_EC05DB := _EC05DB
		(_cAlias)->E5_EC05CR := _EC05CR
	MsUnlock()//MSUNLOCK() 
	
Endif
RestArea(_aAreat)
/*
//	MsgAlert("Entrei no Pe")

DbSelectArea('CT0')
DbSetOrder(1)    // Filial + ID
CT0->(DbSeek(xFilial('CT0')+'05'))
// Validacao
If CT0->CT0_ALIAS == 'CV0'
DbSelectArea('CV0')
DbSetOrder(1)    //              CV0_FILIAL+CV0_PLANO
// Gravacao das entidades adicionadas criadas pelo CTBWIZENT
RecLock(cAlias,.T.)
If CV0->(DbSeek(xFilial("CV0")+"05"+cCtEnt05DB)) // Filial + Plano + Codigo
(cAlias)->E5_EC05DB := CV0->CV0_CODIGO
EndIf
If CV0->(DbSeek(xFilial("CV0")+"05"+cCtEnt05CR))
(cAlias)->E5_EC05CR := CV0->CV0_CODIGO
EndIf
MsUnlock()
EndIf
cAlias->(RestArea)
Endif
*/

Return Nil