#include 'protheus.ch'
#include 'parmtype.ch'

#DEFINE CRLF CHR(13) + CHR(10)
//Função que valida se o vendedor pode visualizar esse cliente efetivamente e notifica as observações no cadastro do mesmo
//Correção Bug.1: Isso visa corrigir os casos em que os vendedores chutam códigos e assim conseguem inputar os dados dele sem autorização.
user function DBVLNOT()
private lVisAll := __cUserId $ GetMv("VQ_VISUCLI")
private lVldNot := .F.

if lVisAll
	notifica()
else
	cCodVend 	:= POSICIONE("SA3",1,XFILIAL("SA3")+M->UA_VEND, "A3_COD")
	cVAutor		:= POSICIONE("SA1",1,XFILIAL("SA1")+M->UA_CLIENTE+M->UA_LOJA, "A1_VQ_VEND")
	if AllTrim(cCodVend) $ AllTrim(cVAutor)
		notifica()
	else
		Alert("Cliente informado não é válido", "Código Cliente")
		lVldNot := .F.
	endif
endif


return lVldNot

Static function notifica()
local cMsg 		:=  ""

if !empty(SA1->A1_VQ_OBSG)
	cMsg +=  CRLF + " Observação Geral: " + SA1->A1_VQ_OBSG + CRLF + CRLF
endif
if !empty(SA1->A1_VQ_OBSO)
	cMsg += CRLF + " Observação Operacional: " + SA1->A1_VQ_OBSO + CRLF
	lMsg := .T.
endif
if !empty(cMsg)
		Define Font oFont Name "Mono AS" Size 0, 15
		If !Empty(Alltrim(cMsg))
			Define MsDialog oDlg Title "OBSERVAÇÕES NO CADASTRO DO CLIENTE" From 3, 0 to 440, 417 Pixel
				@ 5, 5 Get oMemo Var cMsg Memo Size 200, 195 Of oDlg Pixel
				oMemo:bRClicked := { || AllwaysTrue() }
				oMemo:oFont     := oFont
				Define SButton From 205, 175 Type  1 Action oDlg:End() Enable Of oDlg Pixel // Apaga
			Activate MsDialog oDlg Center
		EndIf	
endif

lVldNot := .T.

Return
