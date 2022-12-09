#Include 'Protheus.ch'
#include "ap5mail.ch"

/*/{Protheus.doc} CSFA520

Rotina de impressão de Recibo de Pagamento de acordo layout html

@author Totvs SM - David
@since 20/11/2014
@version P11

/*/

User Function csfa520(cPedido,cTip)
	Local aArea		:= GetArea()
	Local aRet			:= {.F.,""}
	Local cSaveFile	:= ""
	Local cRootPath	:= GetSrvProfString("RootPath","")
	Local cPath		:= GetNewPar("MV_PATHNF","\espelhonf\")
	Local cPathLoc	:= GetNewPar("MV_PATHNFL","\\hera\Protheus_Data10$")
	Local cCompart	:= GetNewPar("MV_COMPNF","http://192.168.16.30/espelhonf/") + DtoS(Date()) + "/"
	Local cFileHTML  := ""
	Local cHTMRec 	:= GetNewPar("MV_XHTMRPG","CSFA520.HTM")
	Local cHTMLib 	:= GetNewPar("MV_XHTMLIB","CSFA520L.HTM")
	Local cProtocolo := ""
	Local cCorpo     := ""
	Local cDestino   := ""
	Local cAssunto   := ""
	Local cBody      := ""
	Local cSubjRec   := Alltrim(GetMv("MV_A520REC",,""))
	Local cSubjLib   := Alltrim(GetMv("MV_A520LIB",,""))
	Local cDescProd	 := ""
	Local cNumPedEcom:= ""
	
	Default	cTip	:= "R"

	If cTip == "R"
		cFileHTML := cHTMRec
	ElseIf cTip == "L"
		cFileHTML := cHTMLib
	Else
		cFileHTML := cHTMRec
	Endif

	Conout("Iniciando processo para envio do comprovante de pagamento.")

	SC5->( DbSetOrder(1) )		// C5_FILIAL+C5_NUM
	SA1->( DbSetOrder(1) )
	If SC5->( MsSeek( xFilial("SC5") + cPedido ) )
	
		dbSelectArea("SC6")
		SC6->(dbSetOrder(1))
		SC6->(dbSeek(xFilial("SC6") + SC5->C5_NUM))
		
		cNumPedEcom := SC6->C6_XNPECOM

		MakeDir( cRootPath+cPath + DtoS(Date()) + "\", 1 )

		If File(cFileHTML)
			SA1->(DbSeek(xFilial("SA1")+SC5->(C5_CLIENTE+C5_LOJACLI)))

			cProtocolo := lower(MD5( DtoS(Date())+StrTran(Left(Time(),5),":","")+cPedido, 2 ))

			oHTML := TWFHTML():New( cFileHTML )

			oHTML:ValByName( 'nome_cliente'		    , Alltrim(SA1->A1_NOME) )
			oHTML:ValByName( 'valor_compra'		    , Alltrim(Transform(SC5->C5_TOTPED,  "@E 9,999,999,999.99")) )
			oHTML:ValByName( 'pedido_site'			, IIF(!Empty(SC6->C6_XNPECOM),SC6->C6_XNPECOM, SC6->C6_PEDGAR ) )
			
			cCodProd := ""
			
			Conout("Laço para produtos.")
			
			While SC6->(!EoF()) .And. SC6->C6_NUM == SC5->C5_NUM

				If cCodProd != SC6->C6_XSKU
					If !Empty(SC6->C6_XSKU)
						cDescProd := AllTrim(GetAdvFVal("PA8", "PA8_DESBPG", xFilial("PA8") + SC6->C6_XSKU, 1, ""))
						cCodProd  := SC6->C6_XSKU
					Else
						cDescProd := AllTrim(GetAdvFVal("PA8", "PA8_DESBPG", xFilial("PA8") + SC6->C6_PROGAR, 1, ""))
						cCodProd  := SC6->C6_PROGAR
					EndIf
					aAdd( (oHTML:ValByName( 'it.desc_produto'))	, cDescProd)
					Conout("Produto: " + cDescProd)
				EndIf
				
				SC6->(dbSkip())
			EndDo

			cSaveFile := cProtocolo + '.htm'
			Conout(cSaveFile)

			oHTML:SaveFile( cPath + DtoS(Date()) + "\" + cSaveFile )
			cPath := cPath + DtoS(Date()) + "\" + cSaveFile
			
			Sleep(1500)
			
			// ler o arquivo HTML para formar o corpo do e-mail.
			If File( cPath )
				FT_FUSE( cPath )
				FT_FGOTOP()
				While .NOT. FT_FEOF()
					cBody += FT_FREADLN()
					FT_FSKIP()
				End
				FT_FUSE()
			Endif
			
			cCorpo   := DecodeUTF8(cBody) //MemoRead(cPath+ DtoS(Date()) + "\"+cSaveFile)
			cDestino := Alltrim(SA1->A1_EMAIL)

			Conout(cCorpo)
			Conout(cDestino)

			If cTip == "R"
				cAssunto:= cSubjRec + ' ' + IIF(!Empty(cNumPedEcom),cNumPedEcom, SC5->C5_XNPSITE ) 
			ElseIf cTip == "L"
				cAssunto:= cSubjLib + ' ' + IIF(!Empty(cNumPedEcom),cNumPedEcom, SC5->C5_XNPSITE ) 
			Endif
			
			Conout(cAssunto)

			Conout("Vai enviar o e-mail")
			//If !Empty(cCorpo) .and. !Empty(cDestino)
				Conout("Antes de chamar MandEmail")
				//If MandEmail(cCorpo, cDestino, cAssunto)
					Conout("Não envia mais o e-mail, mas retorna True")
					aRet := {.T., cCompart+cSaveFile}
				//Else
				//	aRet := {.F.,"Erro ao enviar email de recibo de pagamento"}
				//EndIf
			//Else
			//	aRet := {.F.,"Corpo ou endeço de email em branco para envio do recibo"}
			//EndIf
		Else
			aRet := {.F.,"Arquivo "+cFileHTML+" de modelo de recibo não encontrado"}
		Endif

		//cs520Not(cPedido,cTip,@aRet)
	Else
		aRet := {.F.,"Pedido não encontrado"}

	EndIf

	RestArea(aArea)
Return(aRet)

/*
Rotina para envio de email de recibo de pagamento
*/

Static Function MandEmail(xCorpo, xDest, xAssunto, xAnexo, xCC, xBCC, xAcc)

Local   cAccount  := AllTrim(GetNewPar("MV_RELACNT"," "))
Local   cFrom	  := AllTrim(GetNewPar("MV_RELFROM"," "))
Local   cPassword := AllTrim(GetNewPar("MV_RELPSW" ," "))
Local   cServer   := AllTrim(GetNewPar("MV_RELSERV"," "))
Local   cUserAut  := Alltrim(GetMv("MV_RELAUSR",,"")) //Usuário para Autenticação no Servidor de Email
Local   cPassAut  := Alltrim(GetMv("MV_RELAPSW",,""))//Senha para Autenticação no Servidor de Email
Local   nTimeOut    := GetMv("MV_RELTIME",,120) //Tempo de Espera antes de abortar a Conexão
Local   lAutentica  := GetMv("MV_RELAUTH",,.F.) //Determina se o Servidor de Email necessita de Autenticação
Local   lRet      := .T.

Default xDest     := ""
Default xCC		  := ""
Default xBCC      := ""
Default xCorpo	  := ""
Default xAnexo    := ""
Default xAssunto  := "<< Mensagem sem assunto >>"

If Empty(xDest+xCC+xBCC)
	Return(lRet)
EndIf

_cMsg := "Conectando a " + cServer + CRLF +;
"Conta: " + cAccount + CRLF +;
"Senha: " + cPassword

CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword TIMEOUT nTimeOut Result lOk

If ( lOk )

    // Realiza autenticacao caso o servidor seja autenticado.
	If lAutentica
		If !MailAuth(cUserAut,cPassAut)
			DISCONNECT SMTP SERVER RESULT lOk
			IF !lOk
				GET MAIL ERROR cErrorMsg
			ENDIF
			Return .F.
		EndIf
	EndIf

	SEND MAIL FROM cFrom TO xDest CC xCC BCC xBCC SUBJECT xAssunto BODY xCorpo ATTACHMENT xAnexo RESULT lOk

	If !lOk
		GET MAIL ERROR cErro
		cErro := "Erro durante o envio - destinatário: " + xDest + CRLF + CRLF + cErro
		lRet:= .F.
	Endif

	DISCONNECT SMTP SERVER RESULT lOk
	If !lOk
		GET MAIL ERROR cErro
	Endif
Else
	GET MAIL ERROR cErro
	lRet:= .F.
EndIf

Return(lRet)

/*
Rotina para notificação de pagamento além do cliente
*/
Static Function cs520Not(cPedido,cTip,aRet)
Local   cTpNot  := AllTrim(GetNewPar("MV_XNOTPGT","0=PTMOVEL.HTML"))
Local   aTpNot  := StrTokArr(cTpNot,',')
Local   cMailNot:= AllTrim(GetNewPar("MV_XMAIPGT","0=erica.louza@certisign.com.br;rogerio@ok2go.com.br"))
Local 	aMailNot:= StrTokArr(cMailNot,',')
Local	cDestino:= ""
Local 	cHtml	:= ""
Local 	nPos	:= 0
Local	nPosAt	:= 0
Local	aCBoxPg:= RetSX3Box(Posicione("SX3",2,"C5_TIPMOV","X3CBox()"),,,1)

SC5->( DbSetOrder(1) )		// C5_FILIAL+C5_NUM
SC6->( DbSetOrder(1) )
If SC5->( DbSeek( xFilial("SC5") + cPedido ) ) .and. SC6->(DbSeek(xFilial("SC6")+SC5->C5_NUM))

	nPos := ascan(aTpNot,{|x| SubStr(alltrim(x),1,1) == Alltrim(SC5->C5_XORIGPV) })
	If nPos > 0
		nPosAt := At("=",aTpNot[nPos])
	    If nPosAt > 0
	    	cHtml := SubStr( aTpNot[nPos],nPosAt+1,Len(aTpNot[nPos]) )
	    Else
	    	cHtml := ""
	    EndIf
	Else
		cHtml := ""
	EndIf

	nPos := ascan(aMailNot,{|x| SubStr(alltrim(x),1,1) == Alltrim(SC5->C5_XORIGPV) })
	If nPos > 0
		nPosAt := At("=",aMailNot[nPos])
	    If nPosAt > 0
	    	cDestino := SubStr( aMailNot[nPos],nPosAt+1,Len(aMailNot[nPos]) )
	    Else
	    	cDestino := ""
	    EndIf
	Else
		cDestino := ""
	EndIf

	If !Empty(cHtml) .and. !Empty(cDestino) .and. File(cHtml)

		SA1->(DbSeek(xFilial("SA1")+SC5->(C5_CLIENTE+C5_LOJACLI)))

		oHTML := TWFHTML():New( cHtml )

		oHTML:ValByName( 'nome_cliente'			, Alltrim(SA1->A1_NOME) )
		oHTML:ValByName( 'cpf_cnpj_cliente'		, Alltrim(Transform(SA1->A1_CGC,  IIF(SA1->A1_PESSOA = 'J',"@R 99.999.999/9999-99","@R 999.999.999-99") )) )
		oHTML:ValByName( 'valor_compra'			, Alltrim(Transform(SC5->C5_TOTPED,  "@E 9,999,999,999.99")) )
		oHTML:ValByName( 'extenso_valor_compra'	, Alltrim(Extenso(SC5->C5_TOTPED)) )
		oHTML:ValByName( 'pedido_site'			, IIF(!Empty(SC5->C5_CHVBPAG),SC5->C5_CHVBPAG, SC5->C5_XNPSITE ) )
		oHTML:ValByName( 'dia'					, Alltrim(Str(DAY(Date()))) )
		oHTML:ValByName( 'mes'					, Alltrim(mesextenso(Date())) )
		oHTML:ValByName( 'ano'					, Alltrim(Str(YEAR(Date()))) )
		oHTML:ValByName( 'email'				, Alltrim(SA1->A1_EMAIL) )
		oHTML:ValByName( 'ddd'					, Alltrim(SA1->A1_DDD) )
		oHTML:ValByName( 'telefone'				, Alltrim(SA1->A1_TEL) )
		oHTML:ValByName( 'forma_pg' 			, Alltrim(SC5->C5_TIPMOV) )
		oHTML:ValByName( 'forma_pg_desc' 		, aCBoxPg[Ascan(aCBoxPg,{|x| x[2] == SC5->C5_TIPMOV }),1])

		While !SC6->(EoF()) .and. SC6->C6_FILIAL = xFilial("SC6") .AND. SC6->C6_NUM = SC5->C5_NUM
			AAdd( ( oHTML:ValByName('it.cod_produto'))	,  SC6->C6_PRODUTO 	)
			AAdd( ( oHTML:ValByName('it.desc_produto'))	,  Alltrim(Posicione("SB1",1,xFilial("SB1")+SC6->C6_PRODUTO,"B1_DESC")) 	)
			AAdd( ( oHTML:ValByName('it.qtd'))			,  Alltrim( Transform( SC6->C6_QTDVEN, "@E 999999.99" ) ) )
			AAdd( ( oHTML:ValByName('it.valor_uni'))	,  Alltrim( Transform( SC6->C6_PRCVEN, "@E 9,999,999,999.99" ) ) )
			AAdd( ( oHTML:ValByName('it.tot_prod'))		,  Alltrim( Transform( SC6->C6_VALOR , "@E 9,999,999,999.99" ) ) )

			SC6->( DbSkip() )
		EndDo

		cSaveFile := "notpg_" + Alltrim(SC5->C5_XNPSITE) + "_" + StrTran(Time(),":","") + '.htm'

		oHTML:SaveFile( "\SPOOL\"+cSaveFile )

		cCorpo 	:= MemoRead("\SPOOL\"+cSaveFile)

		If cTip == "R"
			cAssunto:= "Confirmação de pagamento Pedido "+IIF(!Empty(SC5->C5_CHVBPAG),SC5->C5_CHVBPAG, SC5->C5_XNPSITE )
		ElseIf cTip == "L"
			cAssunto:= "Liberação do Pedido "+IIF(!Empty(SC5->C5_CHVBPAG),SC5->C5_CHVBPAG, SC5->C5_XNPSITE )
		Endif

		If !Empty(cCorpo) .and. !Empty(cDestino) //.and. MandEmail(cCorpo, cDestino, cAssunto)
			aRet[2] += " E-mail enviado com notificação de pagamento para "+cDestino
		Else
			aRet[2] += " E-mail não enviado com notificação de pagamento para "+cDestino
		EndIf

	EndIf

EndIf

Return()
