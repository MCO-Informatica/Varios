#Include 'Protheus.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VNDA170    ºAutor  ³Opvs (Darcio)       º Data ³  05/12/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Fonte criado para trazer as informacoes do tipo de voucher  º±±
±±º          ³para a aba Regras de Movimentacao.                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Opvs x Certisign                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function VNDA170(cCampo)

Local aArea	:= GetArea()
Local cRet	:= ""

//ZF_EMNTVEN - ZF_TESS    - ZF_TESP  - ZF_ALBIVE - ZF_EMNTENT - ZF_TESE   - ZF_ARQEST - ZF_TPMOVIM
//ZH_EMNTVEN - ZH_TPOPSER - ZH_TPOPP - ZH_ALBIVE - ZH_EMNTENT - ZH_TPOENT - ZH_ARQEST - ZH_TPMOVIM

If "ZF_EMNTVEN" $ cCampo
	cRet := Posicione("SZH",1,xFilial("SZH") + M->ZF_TIPOVOU, "ZH_EMNTVEN")
ElseIf "ZF_TPOPSER" $ cCampo
	cRet := Posicione("SZH",1,xFilial("SZH") + M->ZF_TIPOVOU, "ZH_TPOPSER")
ElseIf "ZF_TPOPP" $ cCampo
	cRet := Posicione("SZH",1,xFilial("SZH") + M->ZF_TIPOVOU, "ZH_TPOPP")
ElseIf "ZF_ALBIVE" $ cCampo
	cRet := Posicione("SZH",1,xFilial("SZH") + M->ZF_TIPOVOU, "ZH_ALBIVE")
ElseIf "ZF_EMNTENT" $ cCampo
	cRet := Posicione("SZH",1,xFilial("SZH") + M->ZF_TIPOVOU, "ZH_EMNTENT")
ElseIf "ZF_TPOPENT" $ cCampo
	cRet := Posicione("SZH",1,xFilial("SZH") + M->ZF_TIPOVOU, "ZH_TPOPENT")
ElseIf "ZF_ARQEST" $ cCampo
	cRet := Posicione("SZH",1,xFilial("SZH") + M->ZF_TIPOVOU, "ZH_ARQEST")
ElseIf "ZF_TPMOVIM" $ cCampo
	cRet := Posicione("SZH",1,xFilial("SZH") + M->ZF_TIPOVOU, "ZF_TPMOVIM")
EndIf

RestArea(aArea)
Return(cRet)