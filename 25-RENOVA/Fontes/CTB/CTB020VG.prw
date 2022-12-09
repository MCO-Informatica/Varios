#INCLUDE "PROTHEUS.CH"

User Function CT020TOK()

Local aArea	 := GetArea()
Local lRet	 := .T.                                      
Local _nT 	 := 0
Private cTConta := M->CT1_CLASSE // 1-Sintética / 2-Analítica
Private cCtaRef := aCols[n,2]  //CVD_CODPLA Plano referencial
if cTConta =  '2'
	For _nT := 1 to len(aCols)
		if Empty(cCtaRef)
			ShowHelpDlg("CTB020VG",{"Quando a Conta for analítica, a conta referencial deve ser inforrmada",""},3,;
			{"Informe a conta referencial",""},3)
			lRet := .F.
			exit
		Endif
	Next _nT
Endif
RestArea(aArea)
Return(lRet)
