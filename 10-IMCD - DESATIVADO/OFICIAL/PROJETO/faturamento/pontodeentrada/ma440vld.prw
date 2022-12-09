#INCLUDE "PROTHEUS.CH"
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³MA440VLD  ³ Autor ³ Eneovaldo Roveri Juni ³ Data ³19/11/2009³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Validar liberação de pedido                                 ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MA440VLD()
	Local aArea := GetArea()
	Local _lRet := .T.
	Local _aVal := {}
	Local _cMot := ""
	Local _i    := 0
	local lExcept := cEmpAnt == '02'

//oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "MA440VLD" , __cUserID )

	If ALLTRIM(SC5->C5_CONTRA) == "XX" .OR. ALLTRIM(SC5->C5_CONTRA) == "Y" .OR. (lExcept .and. ALLTRIM(SC5->C5_CONTRA) == "X" )
		_lRet := .F.
		MSGBOX("Pedido Não Liberado pelo motivo de BLOQUEIO DE MARGEM, solicitar liberação.","ERRO","STOP")
	Elseif  ALLTRIM(SC5->C5_CONTRA) == "MFR"
		_lRet := .F.
		MSGBOX("Pedido Não Liberado pelo motivo de Regras de Risco de Fraude, solicitar liberação.","ERRO","STOP")

	Elseif  ALLTRIM(SC5->C5_CONTRA) == "CONS"
		_lRet := .F.
		MsgStop("Pedido consignado precisa de liberação. Consulte o Historico do Pedido", "Pedido Não Liberado")
	Else
		if !(SC5->C5_TIPO $ "DB" )
			_aVal := U_A440CKPD( SC5->C5_NUM, .T. )
			/*
			_aVal
			Celulas
			1,1 - Condição de pagamento
			2,1 - Margem de Venda
			3,1 - Licença de Cliente
			4,1 - Licença de Transportadora
			5,1 - Estoque
			n,2 - .T. Liberado        - .F. Não Liberado
			n,3 - .T. Trava liberação - .F. Permite o usuário forçar a Liberação
			*/
			For _i := 1 to len( _aVal )
				if .not. _aVal[ _i, 2 ]
					_cMot += ( iif( empty( _cMot ), "",", " )+_aVal[ _i, 1 ] )
					if _aVal[ _i, 3 ] // .or. CNIVEL < 6 //Se é obrigado a travar (licenças) ou o usuário for menor que master
						_lRet := .f.
					endif
				endif
			Next _i

// retirado em 020218 por sandra -- para 	que o departamento fiscal libere

			IF !EMPTY( _cMot )
				MSGBOX("Pedido Não Liberado pelo(s) motivo(s) de "+_cMot,"ERRO","STOP")
				_lRet := .F.
			endif
		Endif

	Endif

	if _lRet
		_lRet := validaGM()
	endif

	RestArea(aArea)
Return( _lRet )

/*/{Protheus.doc} validaGM
Realiza validação de margem
@type function
@version 1.0
@author marcio.katsumata
@since 31/08/2020
@return logical, .T.
/*/
static function validaGM()

	local nLin  as numeric
	Local _nPosMarg as numeric
	Local _nPosVtot as numeric
	Local cCliLoja  as character
	local vPerm     as numeric
	local cEmail    as character
	local cMsg      as character
	local lEmail    as logical
	local cTextoEmail  as character
	local cAssunto  as character
	local cCC       as character
	local lRet      as logical
	local lValidGM  as logical
	local nTotalMarg as numeric
	local nTotalvalor as numeric
	Local aAttach := {}

	nTotalMarg := 0
	nTotalvalor := 0
	lRet      := .T.
	lValidGM  := superGetMv("ES_VLGM440", .F., .F.)
	cCC       := ""
	cCliLoja  := M->C5_CLIENTE + M->C5_LOJACLI
	_nPosMarg := aScan(aHeader,{|x| AllTrim(x[2]) == "C6_XVRMARG"} )
	_nPosVtot := aScan(aHeader,{|x| AllTrim(x[2]) == "C6_VALOR"} )
	nPosCod   := aScan(aHeader,{|x| AllTrim(x[2]) == "C6_PRODUTO"} )
	nTotalLin := len(aCols)

	//--------------------------------------------------------------
	//Realiza validação de margem na liberação do pedido de venda
	//--------------------------------------------------------------
	if lValidGM

		DbSelectArea("SA1")
		SA1->(dbSeek(xFilial("SA1") + cCliLoja))


		for nLin := 1 to nTotalLin
			RunTrigger(2,nLin,nil,,'C6_XTAXA')
			RunTrigger(2,nLin,nil,,'C6_XVLRINF')

			nTotalMarg += aCols[nLin,_nPosMarg]
			nTotalvalor += aCols[nLin,_nPosVtot]

		next nLin

		M->C5_XVRMARG := nTotalMarg


		IF !(SA1->A1_XINTERC == 'S')

			If Posicione("SB1",1,xFilial("SB1") + aCols[1,nPosCod],"B1_TIPO")== 'MR'
				If lRet
					vPerm := 0
					vPerm := (( M->C5_XVRMARG / nTotalvalor )*100)

					If vPerm < 0

						M->C5_CONTRA := "X"

						DbSelectArea("DA0")
						DbSetOrder(1)
						DbSeek(xfilial("DA0")+M->C5_TABELA)

						cEmail :=ALLTRIM(USRRETMAIL(DA0->DA0_X_HEAD))+";"

						//Envia e-mail ao gerente da BU.
						IF !empty(DA0->DA0_X_MGR)
							cEmail += ALLTRIM(USRRETMAIL(DA0->DA0_X_MGR))+";"
						ENDIF

						IF DA0->(fieldPos("DA0_X_CEO")) > 0
							IF !empty(DA0->DA0_X_CEO)
								cCC := ALLTRIM(USRRETMAIL(DA0->DA0_X_CEO))+";"
							ENDIF
						ENDIF
						cCC += ALLTRIM(USRRETMAIL(__cUserId))+";"
						cCC += ALLTRIM(POSICIONE("SA3",1,xFilial("SA3")+M->C5_VEND1,"A3_EMAIL"))

						cAssunto := "Bloqueio por Margem Pedido " + ALLTRIM(M->C5_NUM)
						cTextoEmail := CORPOEMAIL()

						cLog := "Enviado email para "+CRLF+cEmail+CRLF+cCC+CRLF+dtoC(date())+" "+strtran(time(),":","")

						lEmail := U_ENVMAILIMCD(cEmail,cCC," ",cAssunto,cTextoEmail,aAttach)

						If lEmail
							ALERT('Bloqueio de Margem. Solicitação enviada por E-mail')
							U_GrvLogPd(M->C5_NUM,M->C5_CLIENTE,M->CJ_LOJACLI,"Bloqueio","Pedido bloqueado na Margem - E-mail Enviado")
						else
							cMsg := ( dtoc( Date() )+" "+Time()+" Working Thread  - Não foi possivel enviar o e-mail do bloqueio." )
							FWLogMsg("INFO", "", "BusinessObject", "MT440VLD" , "", "", cMsg, 0, 0)
						Endif
					Else
						M->C5_CONTRA := ''
					Endif

					M->C5_LIBCRED := ''

				Endif
			Endif
		Endif
	endif

return lRet


/*/{Protheus.doc} CORPOEMAIL
Realiza  montagem do body do e-mail para pedido liberado
com margem negativa. 
@type function
@version 1.0
@author marcio.katsumata
@since 03/09/2020
@return return_type, return_description
/*/
Static Function CORPOEMAIL()
	Local nX := 0
	Local cMensagem := ' '
	Local cLogo := GETMV("MV_ENDLOGO")
	Local cEmpresa := SM0->M0_CODIGO+"/"+SM0->M0_CODFIL+" - "+ALLTRIM(SM0->M0_NOME)+" - "+ALLTRIM(SM0->M0_FILIAL )

	cMensagem := '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">'
	cMensagem += '<html xmlns="http://www.w3.org/1999/xhtml">'
	cMensagem += '<head>'
	cMensagem += '<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />'
	cMensagem += '<title>PEDIDO DE VENDA '+M->C5_NUM+'</title>'
	cMensagem += '</head>'
	cMensagem += '<body>'
	cMensagem += '<img alt="IMCD LOGO" class="img__src img__cover" src="'+cLogo+'" width="658" height="191"><br/><br/>'

	cMensagem += '<h2><span style="color: #ff0000;"><strong>O pedido de vendas abaixo foi Liberado com margem NEGATIVA.</strong></span></h2>'
	cMensagem += '<h2>Este Pedido será liberado, mas caso não esteja de acordo, favor reprovar o Pedido.</h2>'

	cMensagem += '<p>Pedido :<strong>'+ ALLTRIM(M->C5_NUM) + '</strong></p>'
	cMensagem += '<p>Cliente :<strong>'+ ALLTRIM(SA1->A1_NOME) + '</strong></p></br>'

	cMensagem += '<table border="2">'
	cMensagem += '<tbody>'
	cMensagem += '<tr>'
	cMensagem += '<td style="width: 150px;"><span style="color: #0000ff;"><strong>Produto</strong></span></td>'
	cMensagem += '<td style="width: 250px;"><span style="color: #0000ff;"><strong>Descri&ccedil;&atilde;o</strong></span></td>'
	cMensagem += '<td style="width: 075px;"><span style="color: #0000ff;"><strong>Qtd</strong></span></td>'
	cMensagem += '<td style="width: 100px;"><span style="color: #0000ff;"><strong>Preço Unit</strong></span></td>'
	cMensagem += '<td style="width: 150px;"><span style="color: #0000ff;"><strong>Total</strong></span></td>'
	cMensagem += '<td style="width: 075px;"><span style="color: #0000ff;"><strong>Margem</strong></span></td>'
	cMensagem += '</tr>'

	For nX := 1 To Len(aCOLS)
		cMensagem += '<tr>'
		cMensagem += '<td style="width: 150px;">'+aCOLS[nX , GDFieldPos( 'C6_PRODUTO', aHeader)]+'</td>'
		cMensagem += '<td style="width: 250px;">'+ALLTRIM(	aCOLS[nX , GDFieldPos( 'C6_DESCRI', aHeader)] ) +'</td>'
		cMensagem += '<td style="width: 075px;">'+TRANSFORM(aCOLS[nX , GDFieldPos( 'C6_QTDVEN', aHeader)] 	,"@E 9,999,999.9999")+'</td>'
		cMensagem += '<td style="width: 100px;">'+TRANSFORM(aCOLS[nX , GDFieldPos( 'C6_PRCVEN', aHeader)] 	,"@E 9,999,999.9999")+'</td>'
		cMensagem += '<td style="width: 150px;">'+TRANSFORM(aCOLS[nX , GDFieldPos( 'C6_VALOR' , aHeader)] 	,"@E 9,999,999.9999")+'</td>'
		cMensagem += '<td style="width: 075px;">'+TRANSFORM(aCOLS[nX , GDFieldPos( 'C6_XVRMARG', aHeader)]  ,"@E 9,999,999.9999")+'</td>'
		cMensagem += '</tr>'
	Next nX

	cMensagem += '</tbody>'
	cMensagem += '</table>'
	cMensagem += '</BR>•<p>EMPRESA :<strong>'+ cEmpresa + '</strong></p>'
	cMensagem += '</body> '
	cMensagem += '</html>'

Return(cMensagem)

user function teste123()
	Local cRet := &(READVAR())
	Local cCampo := 'C6_OPER'
	RunTrigger(2,n,nil,,cCampo)
return cRet
