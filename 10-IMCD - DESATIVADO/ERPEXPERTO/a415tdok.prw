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

	IF !IsInCallStack("U_IMPQUOTE")

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
			cAssunto := "Orçamento "+ M->CJ_NUM + " - "+cEmpresa
			cTextoEmail :="O Cliente "+M->CJ_CLIENTE+" "+M->CJ_LOJA+" "+ALLTRIM(SA1->A1_NOME)
			cTextoEmail +=CRLF + "Não compra há mais de 1 ano"
			//aAttach := {}
			//U_ENVMAILIMCD(cEmail," "," ",cAssunto,cTextoEmail,aAttach,.t.)
			MsgInfo(cTextoEmail, cAssunto)
		ENDIF
/*
		IF M->CJ_CONDPAG <> SA1->A1_COND
			lExibMsg := .T.

			U_VALIDCONDPAG( M->CJ_NUM, M->CJ_CONDPAG ,SA1->A1_COND , lExibMsg)

		ENDIF
*/
	ENDIF

	RestArea(aAreaTmp1)

Return(lRet)

User function VALIDCONDPAG(cNum,cCondInf,cCondCli , lMsg)

	Local lValid := .F.
	Local cTipoInf := "0"
	Local cDescInf := ""
	Local cCondPagI := ""

	Local nMediaInf := 0
	Local cTipoCli := "0"
	Local cDescCli := ""
	Local cCondPagC := ""

	Local nMediaCli := 0
	Local cMsg1 := ""
	Local cMsg2 := ""
	Local cRot := "Pedido "
	Local lGravLog := .F.

	DEFAULT lMsg := .T.
	DEFAULT cCondInf := ""
	DEFAULT cCondCli := ""
	DEFAULT cEmpresa := Alltrim(SM0->M0_CODIGO)+"/"+Alltrim(SM0->M0_CODFIL)+" - "+ALLTRIM(SM0->M0_NOME)+" - "+ALLTRIM(SM0->M0_FILIAL )	

	IF FUNNAME() == "MATA415"
		cRot := "Orçamento "
	ELSEIF FUNNAME() == "MATA410"
		cRot := "Pedido "
		lGravLog := .T.
	ENDIF

	cAssunto := cRot + cNum

	cTextoEmail := ""

	dbSelectArea("SE4")
	SE4->(dbSetOrder(1))

	if SE4->(dbSeek(xFilial("SE4")+cCondInf))
		cTipoInf := ALLTRIM(SE4->E4_TIPO)
		cDescInf := ALLTRIM(SE4->E4_DESCRI)
		cCondPagI := ALLTRIM(SE4->E4_COND)
	endif

	if SE4->(dbSeek(xFilial("SE4")+ cCondCli ))
		cTipoCli := ALLTRIM(SE4->E4_TIPO)
		cDescCli := ALLTRIM(SE4->E4_DESCRI)
		cCondPagC := ALLTRIM(SE4->E4_COND)
	endif

	IF cTipoInf == '1' .AND. cTipoCli == '1'

		nMediaInf := CALCCONDPAG(cCondPagI,"," ) //Orçamento / Pedido

		nMediaCli := CALCCONDPAG(cCondPagC,"," ) //Cadastro Cliente

		lValid := nMediaInf >= nMediaCli

		cMsg1 := ", Média de "+cValToChar(nMediaInf)+" dias"
		cMsg2 := ", Média de "+cValToChar(nMediaCli)+" dias"

	ENDIF

	if !lValid

		cMensagem := '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" '
		cMensagem += '"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">'
		cMensagem += '<html xmlns="http://www.w3.org/1999/xhtml">'
		cMensagem += '<head>'

		cMensagem += '<title>'+cAssunto+'</title>'
		cMensagem += '<body><p>'

		cTextoEmail := "A Condição de Pagamento do "+cRot+" é diferente do Cadastro do Cliente<br>"
		cTextoEmail += "No "+cRot + cCondInf + cMsg1 + "<br>"
		cTextoEmail += "No Cadastro do Cliente " +cCondCli + cMsg2 + "<br>"

		IF lMsg
			MSGINFO( cTextoEmail, cAssunto )
		ENDIF

		IF lGravLog
			U_GrvLogPd(M->C5_NUM,M->C5_CLIENTE,M->C5_LOJACLI,"Cond Pagto.",cAssunto, ' ' ,cTextoEmail)
		ENDIF

		cMensagem += cTextoEmail+'</p>'
		cMensagem += '</body> '
		cMensagem += '</html>'

		cAssunto+= " - "+cEmpresa
		cEmail := "junior.gardel@gmail.com;"
		aAttach := {}

		IF FUNNAME() == "MATA410"
			U_ENVMAILIMCD(cEmail," "," ",cAssunto,cMensagem,aAttach,.t.)
		ENDIF

	ENDIF

RETURN lValid

Static function CALCCONDPAG(cCondicao, cSEPARADOR )
	Local nX := 0
	Local aDias :={}
	Local nMedia := 0
	DEFAULT cCondicao :={}
	DEFAULT cSEPARADOR := ","

	aDias := StrToArray( cCondicao, cSEPARADOR)

	nTam := Len(aDias)

	For nX:= 1 TO nTam

		nMedia += val(aDias[nX])

	Next nX

	nMedia := nMedia / nTam

RETURN nMedia
