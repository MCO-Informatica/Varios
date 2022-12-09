#INCLUDE "PROTHEUS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MT410TOK ºAutor  ³  Daniel   Gondran    Data ³  09/11/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada executado no botao ok do pedido de vendas º±±
±±º          ³ para, caso não seja permitido para o cliente (A1_LOTEUNI=2)º±±
±±º          ³ nao deixar entrar pedido com produto igual e lote dIFerenteº±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MATA410                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MT410TOK()

	Local aArea 	:= GetArea()
	Local aAreaDC3 	:= GetArea("DC3")
	Local cCliLoja  := M->C5_CLIENTE + M->C5_LOJACLI
	Local lRet		:= .T.
	Local nX		:= 0
	Local aProd		:= {}
	Local aLote		:= {}
	Local aPrLo		:= {}
	Local aPrdMrgBlq := {}
	Local cParamInd  := "01"
	Local aAuxMgPar  := {}
	Local cAuxMgPar  := ""
	Local nPercMrgBlq := superGetMv("ES_PRCGMBQ",  .f., 0)
	Local lPrdExcpt  := .F.
	Local lTemOnu	:= .F.
	Local lMovEst	:= .F.
	Local cTesCons  := AllTrim(GetMv("MV_VENCONS"))
	Local nOpc		:= Paramixb[1]
	Local _nElem := 0
	Local cCC    := ""
	Local cEmail    := ""
	Local lDevBenef := M->C5_TIPO$'D|B|C|I|P|'
	Local lEmail    := .F.
	Local lDispMail := superGetMv("ES_DISMAIL", .F., .T.)
	Local lManRisk := .T.
	Local aAttach := {}
	Local _nPosEnd := aScan(aHeader,{|x| AllTrim(x[2]) == "C6_LOCALIZ"} )
	Local _nPosLote := aScan(aHeader,{|x| AllTrim(x[2]) == "C6_LOTECTL"} )

	Local nTotalMarg := 0
	Local lVldRisco := .T.

	Local _nPosCFOP := aScan(aHeader,{|x| AllTrim(x[2]) == "C6_CF"} )
	Local cCFOP := ""
	Local lCons := .F.

	Private nEuro := 0
	Private nTotalEUR := 0
	Private nTotalValor := 0

	Private nPosCod		:= aScan(aHeader,{|x| AllTrim(x[2]) == "C6_PRODUTO"})
	Private nPosLote	:= aScan(aHeader,{|x| AllTrim(x[2]) == "C6_LOTECTL"})
	Private nPosValid	:= aScan(aHeader,{|x| AllTrim(x[2]) == "C6_DTVALID"})
	Private nPosArm		:= aScan(aHeader,{|x| AllTrim(x[2]) == "C6_LOCAL"})
	Private nPosEnd		:= aScan(aHeader,{|x| AllTrim(x[2]) == "C6_LOCALIZ"})
	Private nPosTes		:= aScan(aHeader,{|x| AllTrim(x[2]) == "C6_TES"})
	Private nPOSQVEN	:= aScan(aHeader,{|x| AllTrim(x[2]) == "C6_QTDVEN"} )
	Private nPOSPVEN	:= aScan(aHeader,{|x| AllTrim(x[2]) == "C6_PRCVEN"} )
	Private _nPosServ	:= aScan(aHeader,{|x| AllTrim(x[2]) == "C6_SERVIC"} )
	Private _nClasFis	:= aScan(aHeader,{|x| AllTrim(x[2]) == "C6_CLASFIS"} )
	Private _nPosMarg	:= aScan(aHeader,{|x| AllTrim(x[2]) == "C6_XVRMARG"} )
	Private _nPosVtot	:= aScan(aHeader,{|x| AllTrim(x[2]) == "C6_VALOR"} )
	Private _nPosMoeda	:= aScan(aHeader,{|x| AllTrim(x[2]) == "C6_XMOEDA"} )
	Private cEmpresa := Alltrim(SM0->M0_CODIGO)+"/"+Alltrim(SM0->M0_CODFIL)+" - "+ALLTRIM(SM0->M0_NOME)+" - "+ALLTRIM(SM0->M0_FILIAL )

	IF IsInCallStack("MATA311")
		RestArea(aAreaDC3)
		RestArea(aArea)
		RETURN(.T.)
	ENDIF

	//------------------------------------------------
	//Resgata dinamicamente o conteudo dos parâmetros
	// ES_PRDGM sequencial de 01 a 99
	// Exemplo: ES_PRDGM01, ES_PRDGM02
	// E adiciona no array aPrdMrgBlq
	//------------------------------------------------
	cParamMg := "ES_PRDGM"+cParamInd

	while FWSX6Util():ExistsParam( cParamMg )
		cAuxMgPar := superGetMv(cParamMg, .F., "")
		aAuxMgPar := strTokArr2(cAuxMgPar, "/", .F.)

		aEval(aAuxMgPar, {|cParMg| aadd(aPrdMrgBlq, cParMg)})
		cParamInd := soma1(cParamInd)
		cParamMg := "ES_PRDGM"+cParamInd
	enddo

	IF (LEN(ALLTRIM(M->C5_GRPVEN))<6 ) .AND. !(M->C5_TIPO$'D|B')

		ALERT("Grupo de Venda Incorreto!")
		lRet := .F.

	ENDIF

	M->C5_PVC := " "
	M->C5_TPCARGA := "1"

	FOR nX := 1 to len(aCols)

		IF !GDDeleted(nX)

			IF !Empty(Posicione("SB1",1,xFilial("SB1") + aCols[nX,nPosCod],"B1__CODONU"))     	// VerIFica se o produto tem código ONU
				lTemOnu := .T.
			ENDIF

			IF aCols[nX,nPosTes] $ cTesCons // Marca como pedido de venda de consignacao para permitir controle na tela de informacao coleta PV

				M->C5_PVC := "S"

			ELSEIF aCols[nX,nPosTes] $ '641' .AND. aCols[nX,nPosArm] <> "CS"

				//lRet := ValidaTRF(nX)

			ENDIF

			IF Posicione("SF4",1,xFilial("SF4") + aCols[nX,nPosTes],"F4_ESTOQUE") == "S"       // VerIFica se pelo menos um item movimenta estoque
				lMovEst := .T.
			ENDIF

			nTotalMarg += aCols[nX,_nPosMarg]

			nTotalvalor += aCols[nX,_nPosVtot]

			nMoeda := aCols[nX,_nPosMoeda]

			cCFOP:= aCols[nX,_nPosCFOP]

			IF SUBSTR(cCFOP,2,3) == '917'
				lCons := .T.
			ENDIF

		ENDIF

	NEXT

	IF lTemOnu .AND. cEmpAnt <> '04'
		IF !("ENVELOPE" $ M->C5_MENNOTA)
			M->C5_MENNOTA := ALLTRIM(M->C5_MENNOTA) + " ENVELOPE E FICHA DE EMERGENCIA ENTREGUES AO MOTORISTA"
		ENDIF
	ENDIF

	IF !(M->C5_CONDPAG == "100") .and. lMovEst

		nTxMoeda := 1

		dbselectarea("SM2")
		DbSetOrder(1)
		IF DbSeek(M->C5_EMISSAO)
			Do Case
			Case nMoeda == 2
				nTxMoeda := SM2->M2_MOEDA2
			Case nMoeda == 4
				nTxMoeda := SM2->M2_MOEDA4
			Case nMoeda == 5
				nTxMoeda := SM2->M2_MOEDA5
			Case nMoeda == 6
				nTxMoeda := SM2->M2_MOEDA6
			EndCase
			nEuro := SM2->M2_MOEDA4
		ENDIF
		M->C5_XVRMARG := nTotalMarg

		IF cEmpAnt $ '02'
			M->C5_TPCARGA := "2" // na montagem de carga - 26/05/11
		ELSE

			IF lMovEst					// Elaine solicitou que se o pedido não movimenta estoque, não apareça
				M->C5_TPCARGA := "1"	// na montagem de carga - 26/05/11
			ELSE
				M->C5_TPCARGA := "2"
			ENDIF

		ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Processo de Analise se é copia de um pedido                                                                      ³
//³Se o pedido ja tiver sido coletado deve limpar os registros para não ocorrer a copia da coleto do pedido Original³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		IF nOpc == 3
			M->C5_HRCOLR 	:= space(tamsx3("C5_HRCOLR")[1])
			M->C5_DTCOLR 	:= stod(" ")
			M->C5_DTCOL   	:= stod(" ")
			M->C5_COLETA  	:= space(tamsx3("C5_COLETA")[1])
			M->C5_SOLCOL 	:= space(tamsx3("C5_SOLCOL")[1])
			//	M->C5_LIBCRED	:= " "
			M->C5_LIBEROK	:= " "
			M->C5_NOTA		:= " "
			M->C5_BLQ		:= " "
			//	M->C5_XVRMARG	:= 0   --COMENTADO PELO LUIZ PARA ANALISE REFERENTE A COPIA DE PEDIDO PARA SEGUNDA NOTA - 31/01/19
		ENDIF

		//IF l410Auto //nao passar por este ponto de entrada, caso a chamada seja do execauto do PE.(TMKVOK.PRW)
		IF !lDevBenef .and. Posicione("SA1",1,xFilial("SA1") + cCliLoja,"A1_LOTEUNI") == "2"
			FOR nX := 1 To Len(aCols)
				IF !GDDeleted(nX)

					IF aScan (aPrLo,aCols[nX,nPosCod] + aCols[nX,nPosLote])==0
						aAdd (aPrLo,aCols[nX,nPosCod] + aCols[nX,nPosLote])
						aAdd (aProd,aCols[nX,nPosCod])
						aAdd (aLote,aCols[nX,nPosLote])
					ENDIF

				ENDIF
			NEXT

			FOR nX := 2 to Len(aPrLo)
				IF aProd[nX] == aProd[nX-1]
					IF aLote[nX] <> aLote[nX-1]
						lRet := .F.
						Alert("Cliente não permite lotes dIFerentes para um mesmo produto! VerIFique. Produto: " + AllTrim(aProd[nX]))
						Exit
					ENDIF
				ENDIF
			NEXT
		ENDIF
//ENDIF

// Comentado a pedido do Estevam para não afetar a liberação de estoque do pedido de vendas
		FOR _nElem := 1 to Len(acols)

			IF !GDDeleted(_nElem)
				//Carrega os dados da Tabela SC6
				_cProduto	:= aCols[_nElem,nPosCod]
				_cTes		:= aCols[_nElem,nPosTes]
				_nQTDVEN	:= aCols[_nElem,nPOSQVEN]
				_nPRCVEN	:= aCols[_nElem,nPOSPVEN]
				_cLote 		:= aCols[_nElem,_nPosLote]
				_cEndDest:= aCols[_nElem,_nPosEnd]

				IF LEN(alltrim(aCols[_nElem,_nClasFis])) < 3
					lRet := .F.
					alert('ClassIFicação fiscal do produto '+alltrim(_cProduto)+' Esta errada, por favor altere ou Redigite o produto ou O Tipo da operação/TES desse registro')
				ENDIF

				//INCLUIDO LUIZ PARA VALIDAÇÃO DE PRODUTOS Q DEVEM CRIAR SERVIÇO ONDE COMPLEMENTO DE PRODUTO CADASTRADO O SERVIÇO DE SAIDA
				IF !lDevBenef
					IF !Empty(_cProduto)
						dbSelectArea("SB5")
						dbSetOrder(1)
						dbSeek(xFilial("SB5")+ _cProduto )

						dbSelectArea("DC3")
						(dbSetOrder(1))
						IF (dbSeek(xFilial("DC3")+ _cProduto ,.F.)) .and. !Empty(SB5->B5_SERVSAI)
							aCols[_nElem,_nPosServ]  := SB5->B5_SERVSAI
						ELSE
							aCols[_nElem,_nPosServ]  := "001"
						ENDIF

					ENDIF
				ENDIF

			ENDIF

		NEXT _nElem

		IF !lDevBenef .and. !(SA1->A1_XINTERC == 'S')

			IF INCLUI
				M->C5_CONTRA := ' '
				M->C5_USUAPR1 := ' '
				M->C5_USUAPR2 := ' '
			ENDIF

			IF Posicione("SB1",1,xFilial("SB1") + aCols[1,nPosCod],"B1_TIPO")== 'MR'
				nVlrRisco := SUPERGETMV("ES_VLRMFR" , .T., 25000)
				nTotalEUR := round((nTotalvalor  /  nEuro ) ,2)

				IF( cEmpant == '04' .AND. SA1->A1_DTCAD <= STOD("20210201")  )
					lVldRisco := .F.
				ENDIF

				IF nTotalEUR > nVlrRisco .AND. lVldRisco

					lManRisk := U_MANRISK(M->C5_CLIENTE,M->C5_LOJACLI, nTotalEUR)

				ENDIF

				IF lRet .and. lManRisk
					vPerm := 0
					nAliqIMP	:= GDFieldGet("C6_XICMEST",N) + GDFieldGet("C6_XPISCOF",N)
					nAliqIMP := IIF(nAliqIMP > 0, nAliqImp / 100, 0)

					vPerm := round((( M->C5_XVRMARG / ( nTotalvalor  * (1- nAliqImp) ) )*100),0)

					lPrdExcpt := aScan(aPrdMrgBlq, {|cPrdMrgBlq| cPrdMrgBlq == SB1->B1_COD}) > 0

					IF vPerm < 0 .OR. (lPrdExcpt .and. vPerm < nPercMrgBlq)

						//----------------------------------------------
						//Produtos que estão parametrizados para serem
						//bloqueados por margem abaixo do percentual
						//parametrizado
						//----------------------------------------------
						IF lPrdExcpt .and. vPerm < nPercMrgBlq
							M->C5_CONTRA := "Y"
						ELSE
							M->C5_CONTRA := "X"
						ENDIF

						DbSelectArea("DA0")
						DbSetOrder(1)
						DbSeek(xfilial("DA0")+M->C5_TABELA)

						cEmail :=alltrim(UsrRetMail(DA0->DA0_X_HEAD))+";"+alltrim(UsrRetMail(__cUserId))

						IF DA0->(fieldPos("DA0_X_CEO")) > 0
							IF  !empty(DA0->DA0_X_CEO)
								cCC += alltrim(UsrRetMail(DA0->DA0_X_CEO))+";"
							ENDIF
						ENDIF
						//Envia e-mail ao gerente da BU.
						IF !empty(DA0->DA0_X_MGR)
							cEmail +=";"+alltrim(UsrRetMail(DA0->DA0_X_MGR))
						ENDIF

						cAssunto := "Bloqueio Margem"
						cArq := " "
						cTextoEmail := CORPOEMAIL()

						IF lDispMail

							IF !EMPTY(SC5->C5_VEND1)
								IF SA3->(DbSeek( xFilial("SA3") + SC5->C5_VEND1 ))
									cCC += ALLTRIM(SA3->A3_EMAIL)+";"
								ENDIF
							ENDIF

							cAssunto := "Bloqueio por Margem Pedido " + ALLTRIM(M->C5_NUM)
							cLog := "Enviado email para "+CRLF+cEmail+ " CC "+cCC+CRLF+DTOS(DATE())+TIME()

							lEmail := U_ENVMAILIMCD(cEmail,cCC," ",cAssunto,cTextoEmail,aAttach,.t.)

							IF !lEmail
								cMsg := ( dtoc( Date() )+" "+Time()+" Working Thread  - Não foi possivel enviar o e-mail do bloqueio." )
								FWLogMsg("INFO", "", "BusinessObject", "MT410TOK" , "", "", cMsg, 0, 0)
							ELSE
								alert('Bloqueio de Margem. Solicitação enviada por E-mail')
								U_GrvLogPd(M->C5_NUM,M->C5_CLIENTE,M->C5_LOJACLI,"Bloqueio",cAssunto, ' ' ,cLog)
							ENDIF
						ELSE
							U_GrvLogPd(M->C5_NUM,M->C5_CLIENTE,M->C5_LOJACLI,"Bloqueio","Pedido bloqueado na Margem - E-mail Não enviado - DESLIGADO")
						ENDIF
					ELSE
						M->C5_CONTRA := ''
					ENDIF

					M->C5_LIBCRED := ''
				ENDIF

			ENDIF

		ENDIF

		IF  !lDevBenef .and. lRet

			lRet := U_MKFAT001()

			IF !( U_VALULTCOMP(M->C5_CLIENTE,M->C5_LOJACLI) )
				//cEmail := "junior.gardel@gmail.com"
				cAssunto := "PEDIDO "+ M->C5_NUM + " - "+cEmpresa
				cTextoEmail :="O Cliente "+M->C5_CLIENTE+" "+M->C5_LOJACLI+" "+ALLTRIM(SA1->A1_NOME)
				cTextoEmail +="Não compra há mais de 1 ano"
				//aAttach := {}
				//U_ENVMAILIMCD(cEmail," "," ",cAssunto,cTextoEmail,aAttach,.t.)
				MsgInfo(cTextoEmail, cAssunto)
			ENDIF

			/*
			if M->C5_CONDPAG <> SA1->A1_COND
				lExibMsg := .T.
				U_VALIDCONDPAG(M->C5_NUM,M->C5_CONDPAG, SA1->A1_COND, lExibMsg )
			ENDIF
			*/

		ENDIF

	ENDIF

	IF lCons .AND. lRet
		U_BLQCONSIG()
	ENDIF

	RestArea(aAreaDC3)
	RestArea(aArea)

Return(lRet)


Static Function CORPOEMAIL()
	Local nX := 0
	Local cMensagem := ' '
	Local cLogo := GETMV("MV_ENDLOGO")
	Local lExcept := cEmpAnt == '02'

	cMensagem := '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">'
	cMensagem += '<html xmlns="http://www.w3.org/1999/xhtml">'
	cMensagem += '<head>'
	cMensagem += '<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />'
	cMensagem += '<title>PEDIDO DE VENDA '+M->C5_NUM+'</title>'
	cMensagem += '</head>'
	cMensagem += '<body>'
	cMensagem += '<img alt="IMCD LOGO" class="img__src img__cover" src="'+cLogo+'" width="658" height="191"><br/><br/>'

	IF !lExcept
		cMensagem += '<h2><span style="color: #ff0000;"><strong>O pedido de vendas abaixo foi Gerado e/ou Alterado com margem NEGATIVA.</strong></span></h2>'
		cMensagem += '<h2>Este Pedido poderá ser faturado, mas caso não esteja de acordo, favor reprovar o Pedido.</h2>'
	ELSE
		cMensagem += '<h2><span style="color: #ff0000;"><strong>O pedido de vendas abaixo foi gerado/alterado com bloqueio por margem.</strong></span></h2>'
		cMensagem += '<h2>Favor efetuar a liberação do pedido.</h2>'
	ENDIF

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

	FOR nX := 1 To Len(aCOLS)

		IF !GDDeleted(nX)
			cMensagem += '<tr>'
			cMensagem += '<td style="width: 150px;">'+aCOLS[nX , GDFieldPos( 'C6_PRODUTO', aHeader)]+'</td>'
			cMensagem += '<td style="width: 250px;">'+ALLTRIM(	aCOLS[nX , GDFieldPos( 'C6_DESCRI', aHeader)] ) +'</td>'
			cMensagem += '<td style="width: 075px;">'+TRANSFORM(aCOLS[nX , GDFieldPos( 'C6_QTDVEN', aHeader)] 	,"@E 9,999,999.9999")+'</td>'
			cMensagem += '<td style="width: 100px;">'+TRANSFORM(aCOLS[nX , GDFieldPos( 'C6_PRCVEN', aHeader)] 	,"@E 9,999,999.9999")+'</td>'
			cMensagem += '<td style="width: 150px;">'+TRANSFORM(aCOLS[nX , GDFieldPos( 'C6_VALOR' , aHeader)] 	,"@E 9,999,999.9999")+'</td>'
			cMensagem += '<td style="width: 075px;">'+TRANSFORM(aCOLS[nX , GDFieldPos( 'C6_XVRMARG', aHeader)]  ,"@E 9,999,999.9999")+'</td>'
			cMensagem += '</tr>'
		ENDIF

	NEXT nX

	cMensagem += '</tbody>'
	cMensagem += '</table>'
	cMensagem += '</BR>•<p>EMPRESA :<strong>'+ cEmpresa + '</strong></p>'
	cMensagem += '</body> '
	cMensagem += '</html>'

Return(cMensagem)

