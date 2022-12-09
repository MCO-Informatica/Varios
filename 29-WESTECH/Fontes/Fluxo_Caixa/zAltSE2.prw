#include 'protheus.ch'
#include 'parmtype.ch'

User function zAltSE2()

Local oButton1
Local oButton2
Local oGet1
Local cGet1 := SE2->E2_NUM
Local oGet2
Local cGet2 := Posicione("SA2",1,xFilial("SA2") + SE2->E2_FORNECE + SE2->E2_LOJA, "A2_NREDUZ")
Local oGet3
Local dVencto := SE2->E2_VENCTO
Local oGet4
Local nValor := SE2->E2_VALOR
Local oPanel1
Local oPanel2
Local oSay1
Local oSay2
Local oSay3
Local oSay4

Local _nOpc := 0
Static _oDlg

  DEFINE MSDIALOG _oDlg TITLE "Altera Título" FROM 000, 000  TO 200, 400 COLORS 0, 16777215 PIXEL

    @ 006, 008 MSPANEL oPanel1 PROMPT "" SIZE 184, 088 OF _oDlg COLORS 0, 16777215 RAISED
    @ 000, 002 MSPANEL oPanel2 SIZE 179, 086 OF oPanel1 COLORS 0, 16777215 LOWERED
    @ 007, 006 SAY oSay1 PROMPT "Titulo" SIZE 020, 007 OF oPanel2 COLORS 0, 16777215 PIXEL
    @ 007, 063 SAY oSay2 PROMPT "Fornecedor" SIZE 032, 007 OF oPanel2 COLORS 0, 16777215 PIXEL
    @ 038, 006 SAY oSay3 PROMPT "Vencimento" SIZE 030, 007 OF oPanel2 COLORS 0, 16777215 PIXEL
    @ 038, 063 SAY oSay4 PROMPT "Valor" SIZE 018, 007 OF oPanel2 COLORS 0, 16777215 PIXEL
    @ 016, 004 MSGET oGet1 VAR cGet1 When .F. SIZE 042, 010 OF oPanel2 COLORS 0, 16777215 PIXEL
    @ 016, 061 MSGET oGet2 VAR cGet2 When .F. SIZE 113, 010 OF oPanel2 COLORS 0, 16777215 PIXEL
    @ 049, 004 MSGET oGet3 VAR dVencto SIZE 044, 010 OF oPanel2 COLORS 0, 16777215 PIXEL
    @ 049, 061 MSGET oGet4 VAR nValor PICTURE PesqPict("SE2","E2_VALOR") SIZE 060, 010 OF oPanel2 COLORS 0, 16777215 PIXEL
    @ 073, 049 BUTTON oButton1 PROMPT "Cancelar" Action( _oDlg:End() ) SIZE 034, 010 OF oPanel2 PIXEL
    @ 073, 097 BUTTON oButton2 PROMPT "OK" Action( _nOpc := 1, _oDlg:End() ) SIZE 034, 010 OF oPanel2 PIXEL

  ACTIVATE MSDIALOG _oDlg CENTERED

  If _nOpc = 1
  	Reclock("SE2",.F.)
  	SE2->E2_VENCTO 	:= dVencto
  	SE2->E2_VENCREA := DataValida(dVencto,.T.) //Proximo dia útil
  	SE2->E2_VALOR	:= nValor
  	SE2->E2_SALDO	:= nValor
  	MsUnlock()
  Endif
  
	Reclock("TRB1",.F.)
	TRB1->DATAMOV := dVencto
	TRB1->VALOR := -nValor
	MsUnlock()
  
Return _nOpc
