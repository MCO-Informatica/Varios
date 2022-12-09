#INCLUDE "PROTHEUS.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³A415TDOK  º Autor ³ junior Carvalho    º Data ³ 30/11/2017  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function A415TDOK()
	Local lRet := .T.
	Local aAreaTmp1:= TMP1->(GetArea())
	Local nTotalOrc := 0
	Private cEmpresa := Alltrim(SM0->M0_CODIGO)+"/"+Alltrim(SM0->M0_CODFIL)+" - "+ALLTRIM(SM0->M0_NOME)+" - "+ALLTRIM(SM0->M0_FILIAL )

	dbSelectArea("TMP1")
	dbGotop()
	While ( !Eof() )
		If ( !TMP1->CK_FLAG )
			nTotalOrc += TMP1->CK_XVRMARG
		endif
		dbSkip()
	EndDo

	M->CJ_XVRMARG := nTotalOrc
	//Alert("Total do Orçamento R$ " + TransForm(nTotalOrc,PesqPict("SCJ","CJ_XVRMARG")) )

	IF !( U_VALULTCOMP(M->CJ_CLIENTE,M->CJ_LOJA) )
		//cEmail := "junior.gardel@gmail.com"
		cAssunto := "PEDIDO "+ M->CJ_NUM + " - "+cEmpresa
		cTextoEmail :="O Cliente "+M->CJ_CLIENTE+" "+M->CJ_LOJA+" "+ALLTRIM(SA1->A1_NOME)
		cTextoEmail +=CRLF + "Não compra há mais de 1 ano"
		//aAttach := {}
		//U_ENVMAILIMCD(cEmail," "," ",cAssunto,cTextoEmail,aAttach,.t.)
		MsgInfo(cTextoEmail, cAssunto)
	ENDIF

	IF M->CJ_CONDPAG <> SA1->A1_COND

		//cEmail := "junior.gardel@gmail.com"
		cAssunto := "PEDIDO "+ M->CJ_NUM + " - "+cEmpresa
		cTextoEmail:= "A Condição de Pagmento informada no Pedido de Venda é diferente do Cadastro<BR>"
		cTextoEmail +=CRLF + "Informada No Pedido de Venda "+M->CJ_CONDPAG + "<BR> Cadastro do Cliente " + SA1->A1_COND
		//aAttach := {}
		//U_ENVMAILIMCD(cEmail," "," ",cAssunto,cTextoEmail,aAttach,.t.)
		MSGINFO( cTextoEmail, cAssunto )
	ENDIF
	RestArea(aAreaTmp1)
Return(lRet)
