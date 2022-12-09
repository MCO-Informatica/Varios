#include "protheus.ch"

User Function ZICALIQI()
 Local aSize := {}
 Local bOk := {|| }
 Local bCancel:= {|| }
 Local cAliq	:= ""
 Local cAliq1	:= ""
 Local cAliq2	:= ""
 Local oGet1     := NIL
 Local oGet2     := NIL
 Local oGet3     := NIL
 
If Select("SM0")<=0
	RpcSetType(3)
	RpcSetEnv("01", "0101")
EndIf

cAliq 	:= PADR(GetMv("MV_ALIQICM"), 249, " ")
cAliq1	:= padr(GetMv("MV_ALIQIC1"), 249, " ")
cAliq2	:= padr(SuperGetMv("MV_ALIQIC2", , ""), 249, SPACE(249))

Define MsDialog oDialog TITLE "Liberação de Aliq ICMS" From 3, 0 to 300, 600 Pixel //OF oMainWnd PIXEL
@ 010, 10 Say  	oSay 	Prompt 	"Parametro 1 - MV_ALIQICM" 	Size  100, 08 Of oDialog Pixel
@ 020, 10 Get 	oGet1 	Var 	cAliq 		Size 250, 10 Of oDialog Pixel
Define SButton From 020, 265 Type  1 Action GravaPar("MV_ALIQICM", cAliq) Enable Of oDialog Pixel // Apaga

@ 050, 10 Say  	oSay 	Prompt 	"Parametro 2 - MV_ALIQIC1" 	Size  100, 08 Of oDialog Pixel
@ 060, 10 Get 	oGet2 	Var cAliq1 							Size 250, 10 Of oDialog Pixel
Define SButton From 060, 265 Type  1 Action GravaPar("MV_ALIQIC1", cAliq1) Enable Of oDialog Pixel // Apaga

@ 090, 10 Say  	oSay 	Prompt 	"Parametro 2 - MV_ALIQIC2" 	Size  100, 08 Of oDialog Pixel
@ 100, 10 Get 	oGet3 	Var cAliq2 							Size 250, 10 Of oDialog Pixel
Define SButton From 100, 265 Type  1 Action GravaPar("MV_ALIQIC2", cAliq2) Enable Of oDialog Pixel // Apaga

@ 115, 10 Say  	oSay 	Prompt 	'Importante:' 												Size  500, 08 Of oDialog Pixel
@ 120, 40 Say  	oSay 	Prompt 	'- As aliquotas devem ser separadas por "/".'				Size  500, 08 Of oDialog Pixel
@ 130, 40 Say  	oSay 	Prompt 	'- Utilizar o caractere "." como separador de casas decimais.' 	Size  500, 08 Of oDialog Pixel

ACTIVATE MSDIALOG oDialog CENTERED//ON INIT EnchoiceBar(oDialog, bOk , bCancel) CENTERED
Return


Static Function GravaPar(cPar, cCont)

If MsgYesNo("Confirma a atualização do parametro "+Alltrim(cPar)+" com o conteúdo informado?")
	If PutMV(cPar, cCont)
		MsgInfo( 'Ok', 'Parametro atualizado com sucesso.' )
	Else
		Alert("Falha ao atualizar o parametro, verifique.")
	EndIf
EndIf

Return