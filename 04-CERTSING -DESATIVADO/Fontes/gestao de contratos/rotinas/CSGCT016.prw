#Include "Totvs.ch"

User Function CSGCT016()

Local _nOpc		:= 0
Local dDataParc := CNF->CNF_PRUMED	
	
DEFINE MSDIALOG oDlg TITLE "Informe a Data da Parcela :" FROM 0,0 TO 100,230 OF oMainWnd PIXEL FONT oMainWnd:oFont

@008,05 Say " Data : " 	PIXEL SIZE 40,07 OF oDlg
@007,45 MsGet dDataParc	VALID NaoVazio(dDataParc) PIXEL SIZE 65,09 OF oDlg

DEFINE SBUTTON FROM 35,35 TYPE  1 ENABLE OF oDlg ACTION (_nOpc := 1, oDlg:End())
DEFINE SBUTTON FROM 35,65 TYPE  2 ENABLE OF oDlg ACTION (_nOpc := 2, oDlg:End())

ACTIVATE MSDIALOG oDlg CENTERED

If _nOpc == 1

	If MsgYesNo("Você deseja alterar a data da parcela de " + DtoC(CNF->CNF_PRUMED) + " para " + DtoC(dDataParc) + "? ")
		RecLock("CNF",.F.)
			CNF->CNF_PRUMED := dDataParc
		CNF->(MsUnlock())
	EndIf

EndIf

Return