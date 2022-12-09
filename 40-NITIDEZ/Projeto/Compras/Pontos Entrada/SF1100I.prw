#INCLUDE "TOPCONN.CH"
#include 'Ap5Mail.ch'
#include "rwmake.ch"
/*
PONTO.......: SF1100I           PROGRAMA....: MATA103
DESCRIÇÄO...: APOS GRAVACAO DO SF1
UTILIZAÇÄO..: Executado apos gravacao do SF1
PARAMETROS..: Nenhum
RETORNO.....: Nenhum
*/
User Function SF1100I()
aAreaSF1    := SF1->(GetArea())         // salva área do arquio atual
aAreaSD1	:= SD1->(GetArea())

If SF1->(FieldPos("F1_NOMFOR")) > 0 //cEmpAnt == '01' .And. Empty(SF1->F1_NOMFOR)
	If SF1->F1_TIPO == 'N'
		Posicione("SA2",1,xFilial("SA2")+SF1->F1_FORNECE+SF1->F1_LOJA,"")
		If RecLock("SF1",.f.)
			SF1->F1_NOMFOR	:= SA2->A2_NOME
			SF1->(MsUnlock())
		Endif
	Else
		Posicione("SA1",1,xFilial("SA1")+SF1->F1_FORNECE+SF1->F1_LOJA,"")
		If RecLock("SF1",.f.)
			SF1->F1_NOMFOR	:= SA1->A1_NOME
			SF1->(MsUnlock())
		Endif                         
	Endif
Endif                    

RestArea(aAreaSF1)            // restaura área do arquivo atual
RestArea(aAreaSD1)            // restaura área do arquivo atual
Return
