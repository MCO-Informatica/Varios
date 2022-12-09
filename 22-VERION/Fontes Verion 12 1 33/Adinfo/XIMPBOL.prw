#INCLUDE "PROTHEUS.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "topconn.ch"
#INCLUDE "SHELL.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "rwmake.ch"
#INCLUDE "ap5mail.ch"
#INCLUDE "TbiCode.ch"

#DEFINE IMP_SPOOL 2
#DEFINE IMP_PDF 6
#DEFINE _CRLF             CHR(13) + CHR(10)

user function XRBOL001(cCliente, cLoja, cPrefixo, cTitulo, cParcela, cTipo, cChamada,_cFilSE1)
// IMPRIME BOLETO ITAU
	local _aArea  	 := GetArea()
	local _aAreaSE1  := SE1->(GetArea())
	local _aAreaSA1  := SA1->(GetArea())
	local _aAreaSA6  := SA6->(GetArea())
	local _aAreaSEE  := SEE->(GetArea())

	local nHeight	:= 15
	local lBold		:= .F.
	local lUnderLine:= .F.
	local lPixel	:= .T.
	local lPrint	:= .F.

	local oFont1 := TFont():New( "Arial",,12,,.f.,,,,,.f. )
	local oFont4 := TFont():New( "Arial",,16,,.t.,,,,,.f. )
	local oFont5 := TFont():New( "Arial",,13,,.t.,,,,.t.,.f. )
	local oFont6 := TFont():New( "Arial",,10,,.f.,,,,,.f. )
	local oFont7 := TFont():New( "Arial",,10,,.t.,,,,.t.,.f. )
	local oFont8 := TFont():New( "Arial",,10,,.f.,,,,,.f. )
	local nPag	:= 1
	local _cNomeCli := ""

	Local nLastKey		:= 0
	Local lFrmTMSPrt  	:= .T.
	Local nUsaPDF    	:= 6
	//Local nHeight		:= 15
	//Local lBold			:= .F.
	//Local lUnderLine  	:= .F.
	//Local lPixel		:= .T.
	//Local lPrint		:= .F.
	//Local _cFilial      := ""
	Local xx			:= 0
	Local cBoleto       := ''
	Local cEmail		:= ''
	Local cCopia 		:= SuperGetMv("MV_XMFIN" ,,'administracao@verion.com.br')
	Local cCondPg 		:= SuperGetMV("MV_XCONP",,'051,091,096,110')
	Local cAnexo		:= ''
	Local aTitulos		:= {}
	Local nMaxTit		:= 0
	Local cCorpo		:= ''
	Local cAssunto      := ''
	Local cQryVend		:= ''
	Local TMPVEND 		:= GetNextAlias()
	Local lImprime		:= .f.
	//Local _cArq       	:= ""
	//Local nLastKey    	:= 0
	Local _cRotina      := "XRBOL001"

	Local cFormPG  		:= ""
	Local cLinkPG  		:= ""

	private _nVlrMor  := 0//  0.133
	private _nCalc    := 0
	private _cDigCep  := ""
	Private _cTime	  := ""
	Private _nMulta	   := (SuperGetMv("MV_XMULTAP" ,,0.00)) // % de Multa Padrão 2%.
	Private _nValMult  := 0
	Private _nVezes    := 0
	Private cQtde      := (SuperGetMv("MV_XQTDEV" ,,''))
	default cCliente  := ""
	default cLoja     := ""
	default cPrefixo  := ""
	default cTitulo   := ""
	default cParcela  := ""
	default cTipo     := ""
	default cChamada  := ""
	default _cFilSE1  := xFilial("SE1")

	public _cArq         := ""
	public cPathInServer := "\PDF" //local padrao para o caso de Schedule
	cBoleto := Posicione("SA1",1,xFilial("SA1")+cCliente+cLoja,"A1_XEMIBOL ")
	If cBoleto $ " |N"  // .and. cChamada <> 'JOB'
		//msgbox('Não é permitido emitir boletos para o cliente: '+cCliente+" / " + cLoja +",verifique o cadastro de cliente." ,'XRBOL001','alert')
		Return
	EndIf
	aTitulos := {}
	IF EMPTY(cParcela)  .OR. EMPTY(cTipo) // VERIFICA EXISTENCIA DE TITULO
		SE1->(DbSetOrder(2))//E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
		if ! SE1->(msseek(_cFilSE1+cCliente+cLoja+cPrefixo+cTitulo))
			If cChamada $ 'JOBP'
				CONOUT('Não existe título para cliente: '+cCliente+" / " + cLoja + " NF: " + cTitulo + "/" + cPrefixo +  ",verifique ")
			ELSE
				//	msgbox('Não existe título para cliente: '+cCliente+" / " + cLoja + " NF: " + cTitulo + "/" + cPrefixo +  ",verifique " ,'XRBOL001','alert')
			ENDIF
			Return
		EndIf
		cTipo := SE1->E1_TIPO
	endif
	IF !EMPTY(cCondPg)
		cCondPg := StrTran(cCondPg, ",", "','")
		cCondPg := "('" + cCondPg + "')"
	EndIF

	cQryVend := " SELECT DISTINCT F2_VEND1,A3_NOME,A3_EMAIL "
	cQryVend += " FROM " + RETSQLNAME("SE1") + " SE1 (NOLOCK) "
	cQryVend += " INNER JOIN " + RETSQLNAME("SF2") + " SF2 (NOLOCK) ON SF2.D_E_L_E_T_ = '' AND SF2.F2_FILIAL = SE1.E1_FILIAL AND SF2.F2_DOC = SE1.E1_NUM AND SF2.F2_PREFIXO = SE1.E1_PREFIXO "
	cQryVend += " LEFT  JOIN " + RETSQLNAME("SA3") + " SA3 (NOLOCK) ON SA3.D_E_L_E_T_ = '' AND SA3.A3_COD = SF2.F2_VEND1 "
	cQryVend += " WHERE SE1.D_E_L_E_T_ = '' "
	cQryVend += " AND SE1.E1_NUM ='" + cTitulo + "' "
	cQryVend += " AND SE1.E1_PREFIXO = '" + cPrefixo + "' "
	cQryVend += " AND SE1.E1_FILIAL = '" + _cFilSE1 + "' "
	If !empty(cCondPg)
		cQryVend += "AND SF2.F2_COND IN " + cCondPg
	EndIF

	If Select(TMPVEND) > 0
		(TMPVEND)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQryVend),TMPVEND)
	(TMPVEND)->(DBGOTOP())

	If 	(TMPVEND)->(EOF())
		Return
	EndIF
	DO WHILE ! (TMPVEND)->(EOF())
		cCopia += ";" + alltrim((TMPVEND)->A3_EMAIL)
		(TMPVEND)->(DBSKIP())
		EXIT
	ENDDO

	If Select(TMPVEND) > 0
		(TMPVEND)->(dbCloseArea())
	EndIf

	IF EMPTY(SA1->A1_EMAIL)
		If cChamada $ 'JOBP'
			CONOUT('Não existe e-mail cadastrado para o cliente: '+cCliente+" / " + cLoja + " NF: " + cTitulo + "/" + cPrefixo +  ",verifique ")
		ELSE
			msgbox('Não existe e-mail cadastrado para o cliente: '+cCliente+" / " + cLoja + " NF: " + cTitulo + "/" + cPrefixo +  ",verifique " ,'XRBOL001','alert')
		ENDIF
	Else
		cEmail := SA1->A1_EMAIL
	ENDIF

	If cChamada $ 'JOBP'
		nMora:= SE1->E1_VALOR * (_nVlrMor/100)
		//_cArq  := "Itau" + AllTrim(SE1X->E1_CLIENTE) + AllTrim(SE1X->E1_LOJA)+ AllTrim(STRTRAN(SE1X->E1_NOMCLI,".","")) + AllTrim(SE1X->E1_TIPO) + AllTrim(SE1X->E1_NUM) +".rel"
		_cArq  := "Itau" + AllTrim(SE1->E1_CLIENTE) + AllTrim(SE1->E1_LOJA)+ AllTrim(STRTRAN(SE1->E1_NOMCLI,".","")) + AllTrim(SE1->E1_TIPO) + AllTrim(SE1->E1_NUM) +AllTrim(SE1->E1_PARCELA) +".rel"


	Else
		nMora:= SE1->E1_VALOR * (_nVlrMor/100)
		_cArq  := "Itau" + AllTrim(SE1->E1_CLIENTE) + AllTrim(SE1->E1_LOJA)+ AllTrim(STRTRAN(SE1->E1_NOMCLI,".","")) + AllTrim(SE1->E1_TIPO) + AllTrim(SE1->E1_NUM) +AllTrim(SE1->E1_PARCELA) +".rel"
	EndIf

	_cTime:=StrTran(AllTrim(Time()),":","")
	_carq:=STRTRAN(STRTRAN(STRTRAN(STRTRAN(STRTRAN(STRTRAN(STRTRAN(STRTRAN(STRTRAN(STRTRAN(_carq,"/",""),"\",""),"|",""),";",""),"*",""),"?",""),",",""),"<",""),">",""),'"',"")
	If cChamada $ "JOBP"  // .OR. cBoleto == 'E' //Schedule
		//_cArq  := "VERION_BOLETO"+_cTime + AllTrim(cTitulo) + AllTrim(cParcela) + AllTrim(STRTRAN(cCliente,".","")) + AllTrim(cLoja) +".rel"
		If !  File (cPathInServer + '\' +   strtran(_cArq , ".rel", ".pdf") )
			oPrn   := FWMSPrinter():New(_cArq,nUsaPDF,lFrmTMSPrt,cPathInServer,.T.,.F.,,"",.F.,.T.,.F.,.F.)//Fun¡?o para gera¡?o do relatorio em PDF sem exibir na tela
			lImprime := .T.
		EndIF

		conout("[ARQUIVO CRIADO PASTA PDF SERVIDOR PROTHEUS]" + _cArq + dtoc(dDatabase) + ' ' + time())
	ElseIf cChamada == "INTEGRA"  //Faz Integração em massa sem apresentar os boletos na tela.

		_cArq  := "VERION_BOLETO"+_cTime + AllTrim(cTitulo) + AllTrim(cParcela) + AllTrim(STRTRAN(cCliente,".","")) + AllTrim(cLoja) +".rel"
		oPrn   := FWMSPrinter():New(_cArq,nUsaPDF,lFrmTMSPrt,			  ,.T.,.F., ,"",.F.,.T.,.F.,.F.)//Fun¡?o para gera¡?o do relatorio em PDF sem exibir na tela
		lImprime := .t.

	Else
		If  File (cPathInServer + '\' +   strtran(_cArq , ".rel", ".pdf") )
			If MsgYesNo("Já foi enviado boleto para o cliente, envia novamente")
				lImprime := .t.
			EndIF
		else
			lImprime := .T.
		endif
		If lImprime
			oPrn   := FWMSPrinter():New(_cArq,nUsaPDF,lFrmTMSPrt,             ,.T.,.F.,  ,"",.F.,.T.,.F.,.T.)//Fun¡?o para gera¡?o do relatorio em PDF na tela
		Endif


	EndIf
	If ! ExistDir(cPathInServer)
		MakeDir( cPathInServer )
	EndIF

	If !Empty(SE1->E1_PEDIDO)

		DbSelectArea("SC5")
		SC5->(DbSetOrder(1))
		SC5->(DbGoTop())

		If SC5->(DbSeek(xFilial("SC5")+SE1->E1_NUM))
			cFormPG := SC5->C5_XFRMPGT
			cLinkPG := SC5->C5_XLINKPG
		EndIf

	EndIf

	If !Empty(cFormPG) .AND. !(cFormPG $ "2,3")
		//cLinkPG := SC5->C5_XLINKPG

		If Empty(cParcela)
			DbSelectArea("SE1")
			SE1->(DbSetOrder(2))//E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
			//if msseek(xFilial('SE1')+cCliente+cLoja+cPrefixo+cTitulo+cParcela+cTipo,.T.,.F.)
			if msseek(_cFilSE1+cCliente+cLoja+cPrefixo+cTitulo)
				_cNomcli := alltrim(posicione("SA1",1,xFilial("SA1")+SE1->(E1_CLIENTE+E1_LOJA),"A1_NOME"))
				If substr(SE1->E1_NUMBCO,1,3) =="115" // claudia verificar esse número de banco
					msgbox('Título emitido no processo anterior, emita o boleto via processo antigo!','XRBOL001','alert')
					Return
					//ElseIf SE1->E1_SALDO==0
					//	MsgAlert("O Título: "+ AllTrim(SE1->E1_PREFIXO) + AllTrim(SE1->E1_NUM) +AllTrim(SE1->E1_PARCELA) + " selecionado está baixado. Não é possível imprimir ou enviar e-mail de Boletos/Títulos quitados. ",_cRotina+" 001")
					//	Return
				EndIf

				while !(SE1->(eof())) .and. SE1->E1_PREFIXO == cPrefixo .and. SE1->E1_NUM == cTitulo
					//Trecho ajustado devido a ordem de títulos com numerações iguais porém com tipos diferentes, isso estava
					//gerando problemas ao ordenar e enviar via Job.
					If SE1->E1_TIPO <> cTipo .or. SE1->E1_SALDO==0
						SE1->(dbskip())
						Loop
					EndIf
					//valida se o titulo já está registrado para imprimir o boleto
					_nValMult := Round (SE1->E1_SALDO * _nMulta,2)
					if empty(SE1->E1_XDTPROC)
						if existblock("XGBOL001")
							If  cChamada == "INTEGRA" .or. cChamada $ "JOBP"
								if empty(SE1->E1_NUMBOR)
									// Faz a inclusao dos titulos no borderô
									_lRet := U_XGBOL005(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_TIPO)
									// Faz a transmissao do titulo no banco
									if _lRet
										_lRet := U_XGBOL001(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_TIPO,cChamada)
									endif
								else
									If cChamada == "INTEGRA"
										_lRet := U_XGBOL001(cPrefixo,cTitulo,cParcela,cTipo,cChamada)
									Else
										_lRet := U_XGBOL001(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_TIPO,cChamada)
									EndIf
								endif
							ElseIf msgbox('Esse titulo ainda nao foi registrado, deseja registrar?','XRBOL001','yesno')
								if empty(SE1->E1_NUMBOR)
									// Faz a inclusao dos titulos no borderô
									_lRet := U_XGBOL005(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_TIPO)
									// Faz a transmissao do titulo no banco
									if _lRet
										_lRet := U_XGBOL001(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_TIPO,cChamada)
									endif
								else
									_lRet := U_XGBOL001(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_TIPO,cChamada)
								endif
							Else
								_lRet := .F.
							EndIf
						endif
						if !(_lRet)
							msgbox('Nao foi possivel registrar o titulo ','XRBOL001','alert')
							return()
						endif
						//Else
						//	msgbox('Título já registrado,  boleto já enviado e gerado em  ' +  cPathInServer ,'XRBOL001','alert')
						//	return()
					endif
					If lImprime
						nLastKey	:= 0
						lFrmTMSPrt  := .T.
						nUsaPDF     := 6
						nHeight		:= 15
						lBold		:= .F.
						lUnderLine  := .F.
						lPixel		:= .T.
						lPrint		:= .F.
						//_cArq       := ""
						nLastKey    := 0
						_cCnpj	    := TRANSFORM(SM0->M0_CGC,"@R 99.999.999/9999-99") //SM0->M0_CGC = '10368321000105'

						nLastKey    := IIf(LastKey() == 27,27,nLastKey)
						If nLastKey == 27
							Return
						Endif

						npag:=1
						_nVezes  := 0
						_cNomeCli := AllTrim(STRTRAN(SE1->E1_NOMCLI,"/",""))

						cCart:= posicione('SEE',1,xFilial('SEE')+SE1->E1_PORTADO+SE1->E1_AGEDEP+SE1->E1_CONTA+'0','EE_CODCART')
						iF Empty(cCart)
							cCart := '109'
						EndIF
						oPrn:StartPage()
						_cAgenc := alltrim(SE1->(E1_AGEDEP))
						if '-' $ SE1->E1_CONTA
							cConta	 := substr(SE1->E1_CONTA,1,at('-',SE1->E1_CONTA)-1)
							cContaD	 := substr(SE1->E1_CONTA,at('-',SE1->E1_CONTA)+1,1)
						else
							cConta	 := Left(alltrim(SE1->E1_CONTA) , Len(alltrim(SE1->E1_CONTA))-1)
							cContaD	 := Right(alltrim(SE1->E1_CONTA),1)
						endif
						_cEnd    := alltrim(posicione("SA1",1,xFilial("SA1")+SE1->(E1_CLIENTE+E1_LOJA),"A1_END"))
						_cUF     := alltrim(posicione("SA1",1,xFilial("SA1")+SE1->(E1_CLIENTE+E1_LOJA),"A1_EST"))
						_cBairr  := alltrim(posicione("SA1",1,xFilial("SA1")+SE1->(E1_CLIENTE+E1_LOJA),"A1_BAIRRO"))
						_cMun    := alltrim(posicione("SA1",1,xFilial("SA1")+SE1->(E1_CLIENTE+E1_LOJA),"A1_MUN"))
						_cCompl  := alltrim(posicione("SA1",1,xFilial("SA1")+SE1->(E1_CLIENTE+E1_LOJA),"A1_COMPLEM"))
						_cCep    := alltrim(posicione("SA1",1,xFilial("SA1")+SE1->(E1_CLIENTE+E1_LOJA),"A1_CEP"))
						_cNomcli := alltrim(posicione("SA1",1,xFilial("SA1")+SE1->(E1_CLIENTE+E1_LOJA),"A1_NOME"))
						_cNumbco := U_XGBOL004(alltrim(SE1->E1_NUMBCO))
						_cNumero := substr(_cNumbco,4,8)
						_cVarDAC := substr(_cNumbco,len(_cNumbco),1)
						//_cNumero:= SubStr(SE1->E1_NUMBCO,1,8)
						//varDAC  := SubStr(SE1->E1_NUMBCO,9,1)
						cParcela:= (AT(SE1->E1_PARCELA,"ABCDEFGHIJKLMN"),1)
						sDigit := substr(SE1->(E1_XLNDIGT),1,5) + '.' + substr(SE1->(E1_XLNDIGT),6,5) + " ";
							+ substr(SE1->(E1_XLNDIGT),11,5)+ '.' + substr(SE1->(E1_XLNDIGT),16,6) + " ";
							+ substr(SE1->(E1_XLNDIGT),22,5)+ '.' + substr(SE1->(E1_XLNDIGT),27,6) + " ";
							+ substr(SE1->(E1_XLNDIGT),33,1)+ ' ' + substr(SE1->(E1_XLNDIGT),34,14)

						if nPag<>1	// Fim de Pagina
							oPrn:EndPage()
							oPrn:StartPage()
						endif
						oPrn:Say(090,0140,"Banco Itau S.A.",oFont5,100)
						_cBitMap := "Itau.BMP" // Logotipo
						oPrn:SayBitMap(0045,0010,_cBitMap,100,070)
						oPrn:Say(095,2020,"RECIBO DO PAGADOR",oFont5,100)
						oPrn:Say(095,0500,"341-7",oFont4,100)
						oPrn:Say(090,0800,sDigit,oFont4,100)

						oPrn:Box(050,0460,121,0462)														// divisao entre Banco e nº. banco
						oPrn:Box(050,0650,121,0652)														// divisao entre no. banco e sacado
						oPrn:Box(120,0010,121,2400)											   			// divisao entre numero digitavel e vencimento

						oPrn:Say(150,0015,"local de Pagamento",oFont1,100)
						oPrn:Box(140,1650,300,1651)														// Traco separador vencimento sacado
						oPrn:Say(150,1660,"Vencimento",oFont1,100)										// Vencimento Sacado

						oPrn:Say(190,0015,"ATE O VENCIMENTO PAGUE PREFERENCIALMENTE NO ITAU",oFont8,100)
						oPrn:Say(215,0015,"APOS O VENCIMENTO PAGUE SOMENTE NO ITAU",oFont8,100)
						oPrn:Say(200,2000,Substr(Dtoc(SE1->E1_VENCREA),1,6)+cValToChar(Year(SE1->E1_VENCREA)),oFont5,100,,,1)			// Vencimento Sacado

						oPrn:Box(250,0010,251,2400)														// Cedente
						oPrn:Box(250,1650,330,1651)														// Traco separador Agencia / Codigo do Cedente
						oPrn:Say(280,0015,"Beneficiário",oFont1,100)
						oPrn:Say(280,1660,"Agência/Código Beneficiário",oFont1,100)						// Agencia / Codigo Cedente
						oPrn:Say(320,1360,_cCnpj,oFont7,100)

						oPrn:Say(320,0015,SM0->M0_NOMECOM,oFont7,100)									// Cedente
						oPrn:Say(320,2000,ALLTRIM(_cAgenc) + "/" + cConta+"-"+cContaD ,oFont5,100,,,1)	// Agencia / Codigo Cedente

						oPrn:Say(360,0015,"Endereco Beneficiário",oFont1,100)
						_nCalc := len(SM0->M0_CEPENT)- 3
						_cDigCep := Right( SM0->M0_CEPENT,3)

						oPrn:Say(400,0015,ALLTRIM(SM0->M0_ENDCOB)+" "+ "-"+" "+alltrim(SM0->M0_CIDENT)+" - "+ SM0->M0_ESTENT+" "+"CEP"+" "+substr(SM0->M0_CEPENT,1,_nCalc)+"-"+_cDigCep ,oFont1,100)

						oPrn:Box(330,0010,331,2400)									 					// Data do Documento
						oPrn:Say(450,0015,"Data do Documento",oFont1,100)	// 330 	 					// Data do Documento

						oPrn:Box(430,0360,520,0361)// 330,420 													// Numero do Documento
						oPrn:Say(450,0370,"No.Documento",oFont1,100) //330									// Numero do Documento

						oPrn:Box(430,0700,510,0701) //330,420													// Especie Doc.
						oPrn:Say(450,0705,"Espécie Doc.",oFont1,100)   //330									// Especie Doc.

						oPrn:Box(430,1050,510,1051) 	 //330,420												// Aceite
						oPrn:Say(450,1060,"Aceite",oFont1,100) //330											// Aceite

						oPrn:Box(430,1250,520,1251) // 330,420													// Dia Processamento
						oPrn:Say(450,1260,"Data Processamento",oFont1,100)  //330								// Dia Processamento

						oPrn:Box(330,1650,420,1651) // 330,420								 					// Cart./Nosso numero
						oPrn:Say(360,1660,"Nosso Numero",oFont1,100)//330	 							// Cart./Nosso numero

						oPrn:Say(490,0015,Dtoc(SE1->E1_EMISSAO),oFont1,100) //360								// Data do Documento

						If !EMPTY(SE1->E1_PARCELA)
							//oPrn:Say(490,0415,SE1->E1_PREFIXO + " " + AllTrim(SE1->E1_NUM) + " " + SE1->E1_PARCELA,oFont1,100) //360			// Numero do Documento
							oPrn:Say(490,0415,AllTrim(SE1->E1_NUM) + " " + SE1->E1_PARCELA,oFont1,100) //360			// Numero do Documento
						Else
							//oPrn:Say(490,0415,SE1->E1_PREFIXO + " " + AllTrim(SE1->E1_NUM)  ,oFont1,100) 	//360								// Numero do Documento
							oPrn:Say(490,0415,AllTrim(SE1->E1_NUM)  ,oFont1,100) 	//360								// Numero do Documento
						EndIf

						oPrn:Say(490,0770,"DMI",oFont1,100) //360	 											// Especie Doc.
						oPrn:Say(490,1100,"N",oFont1,100) //360 												// Aceite
						oPrn:Say(490,1260,Dtoc(dDataBase),oFont1,100)//360 									// Dia Processamento

						oPrn:Say(400,2000,cCart + "/" + _cNumero + "-" + _cVarDAC,oFont5,100,,,1) //360	// Cart./Nosso numero

						oPrn:Box(420,0010,421,2400) // 420,421													// Uso do Banco
						oPrn:Say(540,0015,"Uso Banco",oFont1,100) //420										// Uso do Banco
						oPrn:Box(520,0360,597,0361)
						oPrn:Box(520,0360,510,0361)  // 420,510													// Carteira
						oPrn:Say(540,0370,"Carteira",oFont1,100) //420										// Carteira
						oPrn:Box(520,0549,597,0550)
						oPrn:Box(520,0550,510,0551) //420													// Especie Moeda
						oPrn:Say(540,0560,"Espécie",oFont1,100)//420 									// Especie Moeda
						oPrn:Box(520,0849,597,0849)
						oPrn:Box(520,0850,510,0851) //420													// Quantidade e Valor
						oPrn:Say(540,0860,"Quantidade",oFont1,100)//420 										// Quantidade

						oPrn:Box(520,1250,550,1251) //420,450													// Linha da Barra do X
						oPrn:Box(581,1250,600,1251) //481,510													// Linha para fechar Barra do X
						oPrn:Say(540,1270,"Valor",oFont1,100) //420											// Valor

						oPrn:Box(420,1650,560,1651)	// 420,560													// Valor do Documento
						oPrn:Say(450,1660,"(=) Valor do Documento",oFont1,100)//420 						// Valor do documento

						oPrn:Say(570,0410,cCart,oFont1,100)//450 											// Carteira
						oPrn:Say(570,0620,"R$",oFont1,100) //450		 										// Especie Moeda

						//oPrn:Say(490,2000,Transform(SE1->(E1_SALDO+E1_ACRESC),PesqPict("SE1","E1_SALDO")),oFont5,100,,,1)// 450 // Valor Documento
						oPrn:Say(490,2000,Transform(SE1->(E1_SALDO-E1_SDDECRE+E1_SDACRES),PesqPict("SE1","E1_SALDO")),oFont5,100,,,1)// 450 // Valor Documento

						oPrn:Box(510,0010,511,2400)												   		// (-)Desconto/Abatimento
						oPrn:Box(510,1650,910,1651)														// Instrucoes para o banco
						oPrn:Box(597,0010,598,1651)
						oPrn:Say(630,0010,"Instrucoes de responsabilidade do BENEFICIARIO. Qualquer duvida sobre esse boleto, contate o BENEFICIARIO.",oFont1,100) // Instrucoes para o banco
						oPrn:Say(540,1660,"(-) Desconto/Abatimento",oFont1,100)						// (-)Desconto/Abatimento

					/* RETIRADO CONF SOLICITADO PELA VANESSA
					If SE1->E1_PORCJUR <> 0  
						//_nValJur := round(SE1->(E1_SALDO+E1_ACRESC) * (SE1->E1_PORCJUR/30),2)
						_nValJur := round(SE1->(E1_SALDO-E1_SDDECRE+E1_SDACRES) * (SE1->E1_PORCJUR/30),2)
						oPrn:Say(690,0015,"Apos o vencimento, cobrar mora de R$" + TRANSFORM(_nValJur,"@e 999,999.99") + " ao dia."	,oFont5,100)
					EndIf
					*/
						//oPrn:Say(730,0015,"Caixa, nao receber apos 3 dias do vencimento."	,oFont5,100)
						iF ! EMPTY(cQtde)
							oPrn:Say(730,0015,"Boleto válido por " + alltrim(cQtde) + " dias, apos isso será cancelado."	,oFont5,100)
						endif

						iF _nValMult > 0
							oPrn:Say( 770,0015, "Apos o vencimento, cobrar multa  no valor de R$ "+ AllTrim(transf(_nValMult,"@E 999,999.99")) + "." ,oFont5,100)
						endIf


						oPrn:Box(590,1650,591,2400)														// (-)Outras Deducoes
						oPrn:Say(620,1660,"(-) Outras Deducoes",oFont1,100)							// (-)Outras Deducoes

						oPrn:Box(670,1650,671,2400)														// (+)Mora/Multa
						oPrn:Say(700,1660,"(+) Mora/Multa",oFont1,100)								// (+)Mora/Multa

						oPrn:Box(750,1650,751,2400)														// (+)Outros Acrescimos
						oPrn:Say(780,1660,"(+)Outros Acréscimos",oFont1,100)							// (+)Outros Acrescimos

						//oPrn:Say(890,0015,"APOS VCTO ACESSE WWW.ITAU.COM.BR/BOLETOS PARA ATUALIZAR SEU BOLETO"	,oFont5,100)
						oPrn:Say(890,0015,""	,oFont5,100)
						oPrn:Box(830,1650,831,2400)														// (=)Valor Cobrado
						oPrn:Say(860,1660,"(=) Valor Cobrado",oFont1,100)								// (=)Valor Cobrado

						oPrn:Box(910,0010,911,2400)														// Sacado
						oPrn:Say(940,0015,"Pagador:  "+ _cNomcli,oFont6,100)

						_cCodId := alltrim(posicione("SA1",1,xFilial("SA1")+SE1->(E1_CLIENTE+E1_LOJA),"A1_CGC"))
						If Len(_cCodId)==11
							oPrn:Say(940,1650,"CPF : " + Transform(_cCodId,"@R 999.999.999-99"),oFont6,100)
						Else
							oPrn:Say(940,1650,"CNPJ: " + Transform(_cCodId,"@R 99.999.999/9999-99"),oFont6,100)
						EndIf

						oPrn:Say(0970,0132,_cEnd+" - "+_cBairr,oFont6,100)
						oPrn:Say(1000,0132,Transform(_cCep,"@R 99999-999")+"   "+_cMun+" - "+_cUF,oFont6,100)

						oPrn:Say(1050,0015,"Pagador/Avalista",oFont1,100)
						oPrn:Say(1050,2000,"Autenticacao Mecanica",oFont1,100)

						oPrn:Box(1060,0010,1061,2400)													// Traco separador da Autenticao Mecanica

						// divisao entre o recibo do sacado e ficha de caixa
						oPrn:Say(1120,0010,"--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------",oFont1,100)

						oPrn:Say(1180,0140,"Banco Itau S.A.",oFont5,100)

						_cBitMap := "Itau.BMP"															// Logotipo
						oPrn:SayBitMap(1135,0010,_cBitMap,100,070)

						oPrn:Say(1185,0500,"341-7",oFont4,100)
						oPrn:Say(1180,0800,sDigit,oFont4,100)

						oPrn:Box(1140,0460,1211,0462) 														// divisao entre Banco e nº. banco
						oPrn:Box(1140,0650,1211,0652)														// divisao entre no. banco e sacado
						oPrn:Box(1210,0010,1211,2400)														// divisao entre numero digitavel e vencimentoa

						oPrn:Say(1240,0015,"local de Pagamento",oFont1,100)
						oPrn:Box(1210,1650,1350,1651)														// Traco separador vencimento sacado
						oPrn:Say(1240,1660,"Vencimento",oFont1,100)											// Vencimento Sacado

						oPrn:Say(1280,0015,"ATE O VENCIMENTO PAGUE PREFERENCIALMENTE NO ITAU",oFont8,100)
						oPrn:Say(1305,0015,"APOS O VENCIMENTO PAGUE SOMENTE NO ITAU",oFont8,100)
						oPrn:Say(1290,2000,Substr(Dtoc(SE1->E1_VENCREA),1,6)+cValToChar(Year(SE1->E1_VENCREA)),oFont5,100,,,1)			// Vencimento Sacado

						oPrn:Box(1350,0010,1351,2400)														// Cedente
						oPrn:Box(1350,1650,1420,1651)														// Traco separador Agencia / Codigo do Cedente
						oPrn:Say(1375,0015,"Beneficiário",oFont1,100)

						oPrn:Say(1400,1380,_cCnpj,oFont7,100)
						oPrn:Say(1375,1660,"Agência/Código Beneficiário",oFont1,100)								// Agencia / Codigo Cedente

						oPrn:Say(1400,0015,SM0->M0_NOMECOM,oFont7,100)										// Cedente
						oPrn:Say(1410,2000,ALLTRIM(_cAgenc) + "/" + cConta+"-"+cContaD ,oFont5,100,,,1)	// Agencia / Codigo Cedente

						oPrn:Box(1420,0010,1421,2400)									 					// Data do Documento
						oPrn:Say(1445,0015,"Data do Documento",oFont1,100)		 							// Data do Documento

						oPrn:Box(1420,0360,1490,0361) 														// Numero do Documento
						oPrn:Say(1445,0370,"No.Documento",oFont1,100) 										// Numero do Documento

						oPrn:Box(1420,0698,1480,0699) 														// Especie Doc.
						oPrn:Say(1445,0705,"Espécie Doc.",oFont1,100) 										// Especie Doc.

						oPrn:Box(1420,1047,1480,1048) 														// Aceite
						oPrn:Say(1445,1060,"Aceite",oFont1,100) 											// Aceite

						oPrn:Box(1420,1250,1490,1251) 														// Dia Processamento
						oPrn:Say(1445,1260,"Data Processamento",oFont1,100) 								// Dia Processamento

						oPrn:Box(1420,1650,1490,1651) 								 						// Cart./Nosso numero
						oPrn:Say(1445,1660,"Nosso Numero",oFont1,100)	 									// Cart./Nosso numero

						oPrn:Say(1480,0015,Dtoc(SE1->E1_EMISSAO),oFont1,100)								// Data do Documento

						If !EMPTY(SE1->E1_PARCELA)
							//oPrn:Say(1480,0415,SE1->E1_PREFIXO + " " + AllTrim(SE1->E1_NUM) + " " + SE1->E1_PARCELA,oFont1,100) //360			// Numero do Documento
							oPrn:Say(1480,0415,AllTrim(SE1->E1_NUM) + " " + SE1->E1_PARCELA,oFont1,100) //360			// Numero do Documento
						Else
							//oPrn:Say(1480,0415,SE1->E1_PREFIXO + " " + AllTrim(SE1->E1_NUM)  ,oFont1,100) 	//360								// Numero do Documento
							oPrn:Say(1480,0415,AllTrim(SE1->E1_NUM)  ,oFont1,100) 	//360								// Numero do Documento
						EndIf

						oPrn:Say(1480,0770,"DMI",oFont1,100)	 									      	// Especie Doc.
						oPrn:Say(1480,1100,"N",oFont1,100) 													// Aceite
						oPrn:Say(1480,1260,Dtoc(dDataBase),oFont1,100) 										// Dia Processamento
						oPrn:Say(1480,2000,cCart + "/" + _cNumero + "-" + _cVarDAC,oFont5,100,,,1)	// Cart./Nosso numero

						oPrn:Box(1490,0010,1491,2400) 														// Uso do Banco
						oPrn:Say(1515,0015,"Uso Banco",oFont1,100) 											// Uso do Banco

						oPrn:Box(1490,0360,1560,0361) 														// Carteira
						oPrn:Say(1515,0370,"Carteira",oFont1,100) 											// Carteira

						oPrn:Box(1490,0550,1560,0551) 														// Especie Moeda
						oPrn:Say(1515,0560,"Espécie ",oFont1,100) 										// Especie Moeda

						oPrn:Box(1490,0850,1560,0851) 														// Quantidade e Valor
						oPrn:Say(1515,0860,"Quantidade",oFont1,100) 										// Quantidade

						oPrn:Box(1490,1250,1510,1251) 														// Linha da Barra do X
						oPrn:Box(1541,1250,1560,1251) 														// Linha para fechar Barra do X

						oPrn:Say(1515,1270,"Valor",oFont1,100) 												// Valor

						oPrn:Box(1490,1650,1560,1651)														// Valor do Documento
						oPrn:Say(1515,1660,"(=) Valor do Documento",oFont1,100)							// Valor do documento

						oPrn:Say(1550,0410,cCart,oFont1,100) 												// Carteira
						oPrn:Say(1550,0620,"R$",oFont1,100) 												// Especie Moeda

						//oPrn:Say(1547,2000,Transform(SE1->(E1_SALDO+E1_ACRESC),PesqPict("SE1","E1_SALDO")),oFont5,100,,,1)// 450 // Valor Documento
						oPrn:Say(1547,2000,Transform(SE1->(E1_SALDO-E1_SDDECRE+E1_SDACRES),PesqPict("SE1","E1_SALDO")),oFont5,100,,,1)// 450 // Valor Documento

						oPrn:Box(1560,0010,1561,2400)														// (-)Desconto/Abatimento
						oPrn:Box(1560,1650,1910,1651)														// Instrucoes para o banco

						oPrn:Say(1585,0010,"Instrucoes de responsabilidade do BENEFICIARIO. Qualquer duvida sobre esse boleto, contate o BENEFICIARIO.",oFont1,100) // Instrucoes para o banco
						oPrn:Say(1585,1660,"(-) Desconto/Abatimento",oFont1,100)	// (-)Desconto/Abatimento
					/* RETIRADO COF. SOLCITACAO PELA VANESSA
					If SE1->E1_PORCJUR <> 0 
						//_nValJur := round(SE1->(E1_SALDO+E1_ACRESC) * (SE1->E1_PORCJUR/30),2)
						_nValJur := round(SE1->(E1_SALDO-E1_SDDECRE+E1_SDACRES) * (SE1->E1_PORCJUR/30),2)
						oPrn:Say(1640,0015,"Apos o vencimento, cobrar mora de R$" + TRANSFORM(_nValJur,"@e 999,999.99") + " ao dia."	,oFont5,100)
					EndIf
					*/
						//oPrn:Say(1670,0015,"Caixa, nao receber apos 15 dias do vencimento."	,oFont5,100)
						//oPrn:Say(1670,0015,"Caixa, nao receber apos 60 dias do vencimento."	,oFont5,100)
						If !Empty(cQtde)
							oPrn:Say(1670,0015,"Boleto válido por " + alltrim(cQtde) + "  dia, apos isso será cancelado."	,oFont5,100)
						Endif

						iF _nValMult > 0
							oPrn:Say( 1710,0015, "Apos o vencimento, cobrar multa  no valor de R$ "+ AllTrim(transf(_nValMult,"@E 999,999.99")) + "." ,oFont5,100)
						ENDIF


						oPrn:Box(1630,1650,1631,2400)														// (-)Outras Deducoes
						oPrn:Say(1655,1660,"(-) Outras Deducoes",oFont1,100)								// (-)Outras Deducoes

						oPrn:Box(1700,1650,1701,2400)														// (+)Mora/Multa
						oPrn:Say(1725,1660,"(+) Mora/Multa",oFont1,100)									// (+)Mora/Multa

						oPrn:Box(1770,1650,1771,2400)														// (+)Outros Acrescimos
						oPrn:Say(1795,1660,"(+)Outros Acréscimos",oFont1,100)								// (+)Outros Acrescimos

						//oPrn:Say(1860,0015,"APOS VCTO ACESSE WWW.ITAU.COM.BR/BOLETOS PARA ATUALIZAR SEU BOLETO ",oFont5,100)
						oPrn:Say(1860,0015,"",oFont5,100)
						oPrn:Box(1840,1650,1841,2400)														// (=)Valor Cobrado
						oPrn:Say(1865,1660,"(=) Valor Cobrado",oFont1,100)								// (=)Valor Cobrado

						oPrn:Box(1910,0010,1911,2400)														// Sacado
						oPrn:Say(1935,0015,"Pagador:  " + _cNomcli,oFont6,100)

						If Len(_cCodId)==11
							oPrn:Say(1935,1650,"CPF : "+Transform(_cCodId,"@R 999.999.999-99"),oFont6,100)
						Else
							oPrn:Say(1935,1650,"CNPJ: " + Transform(_cCodId,"@R 99.999.999/9999-99"),oFont6,100)
						EndIf

						oPrn:Say(1960,0132,_cEnd+" - "+_cBairr+","+_cCompl,oFont6,100)
						oPrn:Say(1990,0132,Transform(_cCep,"@R 99999-999")+"   "+_cEnd+' - '+_cUF,oFont6,100)

						oPrn:Say(2050,0015,"Pagador/Avalista",oFont1,100)
						oPrn:Say(2070,2000,"Ficha de Compensacao",oFont5,100)
						oPrn:Say(2100,2050,"Autenticacao Mecanica",oFont1,100)

						//oPrn:FWMSBAR("INT25",48.5,1.5,SE1->(E1_CODBAR),oPrn,.F.,,   ,      ,1.2,   ,.F.,NIL,NIL,.F.)
						oPrn:FWMSBAR("INT25",48.5,1.5,SE1->(E1_CODBAR),oPrn,.F.,,.T.,      ,1.2,NIL,NIL,NIL,.F.)
						//	 FWMSBAR("INT25",65.9,4.5,sBarra		  ,oPrn,.F.,,.T.,0.0164,1.0,NIL,NIL,NIL,.F.)
						nPag ++
						oPrn:EndPage()
					Endif
					// Guarda os títulos para enviar no corpo do e-mail
					aadd(aTitulos,{_cNomcli, SE1->E1_NUM + '/' + SE1->E1_PREFIXO , Dtoc(SE1->E1_VENCREA) , Transform(SE1->(E1_SALDO-E1_SDDECRE+E1_SDACRES),PesqPict("SE1","E1_SALDO")) })

					SE1->(dbskip())
				EndDo
			else
				alert('Nao foi possivel realizar a impressao de boleto')
			endif
		Else
			lImprime := .T.
			aTitulos := {}
			DbSelectArea("SE1")
			SE1->(DbSetOrder(2))//E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
			If msseek(_cFilSE1+cCliente+cLoja+cPrefixo+cTitulo+cParcela+cTipo)
				If substr(SE1->E1_NUMBCO,1,3) =="115"
					msgbox('Título emitido no processo anterior, emita o boleto via processo antigo!','XRBOL001','alert')
					Return
				ElseIf SE1->E1_SALDO==0
					MsgAlert("O Título: "+ AllTrim(SE1->E1_PREFIXO) + AllTrim(SE1->E1_NUM) +AllTrim(SE1->E1_PARCELA) + " selecionado está baixado. Não é possível imprimir ou enviar e-mail de Boletos/Títulos quitados. ",_cRotina+" 002")
					Return
				EndIf
				//valida se o titulo já está registrado para imprimir o boleto
				if empty(SE1->E1_XDTPROC)
					if existblock("XGBOL001")
						If cChamada == "DANFE" .OR. cChamada == "INTEGRA"
							if empty(SE1->E1_NUMBOR)
								// Faz a inclusao dos titulos no borderô
								_lRet := U_XGBOL005(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_TIPO)
								// Faz a transmissao do titulo no banco
								if _lRet
									_lRet := U_XGBOL001(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_TIPO,cChamada)
								endif
							else
								If cChamada == "INTEGRA"
									_lRet := U_XGBOL001(cPrefixo,cTitulo,cParcela,cTipo,cChamada)
								Else
									_lRet := U_XGBOL001(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_TIPO,cChamada)
								EndIf
							endif
						ElseIf msgbox('Esse titulo ainda nao foi registrado, deseja registrar?','XRBOL001','yesno')
							if empty(SE1->E1_NUMBOR)
								// Faz a inclusao dos titulos no borderô
								_lRet := U_XGBOL005(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_TIPO)
								// Faz a transmissao do titulo no banco
								if _lRet
									_lRet := U_XGBOL001(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_TIPO,cChamada)
								endif
							else
								_lRet := U_XGBOL001(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_TIPO,cChamada)
							endif
						Else
							_lRet := .F.
						EndIf
					endif
					if !(_lRet)
						msgbox('Nao foi possivel registrar o titulo','XRBOL001','alert')
						return()
					endif
				endif
				nLastKey	:= 0
				lFrmTMSPrt  := .T.
				nUsaPDF     := 6
				nHeight		:= 15
				lBold		:= .F.
				lUnderLine  := .F.
				lPixel		:= .T.
				lPrint		:= .F.
				//_cArq       := ""
				nLastKey    := 0

				_cCnpj	    := TRANSFORM(SuperGetMV('MV_XCGCBOL',,SM0->M0_CGC),"@R 99.999.999/9999-99")

				nLastKey    := IIf(LastKey() == 27,27,nLastKey)
				If nLastKey == 27
					Return
				Endif

				npag:=1
				_nVezes  := 0
				_cNomeCli := AllTrim(STRTRAN(SE1->E1_NOMCLI,"/",""))

				cCart:= posicione('SEE',1,xFilial('SEE')+SE1->E1_PORTADO+SE1->E1_AGEDEP+SE1->E1_CONTA+'000','EE_CODCART')
				iF Empty(cCart)
					cCart := '109'
				EndIF
				oPrn:StartPage()
				_cAgenc := alltrim(SE1->(E1_AGEDEP))
				if '-' $ SE1->E1_CONTA
					cConta	 := substr(SE1->E1_CONTA,1,at('-',SE1->E1_CONTA)-1)
					cContaD	 := substr(SE1->E1_CONTA,at('-',SE1->E1_CONTA)+1,1)
				else
					cConta	 := Left(alltrim(SE1->E1_CONTA) , Len(alltrim(SE1->E1_CONTA))-1)
					cContaD	 := Right(alltrim(SE1->E1_CONTA),1)
				endif
				_cEnd    := alltrim(posicione("SA1",1,xFilial("SA1")+SE1->(E1_CLIENTE+E1_LOJA),"A1_END"))
				_cUF     := alltrim(posicione("SA1",1,xFilial("SA1")+SE1->(E1_CLIENTE+E1_LOJA),"A1_EST"))
				_cBairr  := alltrim(posicione("SA1",1,xFilial("SA1")+SE1->(E1_CLIENTE+E1_LOJA),"A1_BAIRRO"))
				_cMun    := alltrim(posicione("SA1",1,xFilial("SA1")+SE1->(E1_CLIENTE+E1_LOJA),"A1_MUN"))
				_cCompl  := alltrim(posicione("SA1",1,xFilial("SA1")+SE1->(E1_CLIENTE+E1_LOJA),"A1_COMPLEM"))
				_cCep    := alltrim(posicione("SA1",1,xFilial("SA1")+SE1->(E1_CLIENTE+E1_LOJA),"A1_CEP"))
				_cNomcli := alltrim(posicione("SA1",1,xFilial("SA1")+SE1->(E1_CLIENTE+E1_LOJA),"A1_NOME"))
				_cNumbco := U_XGBOL004(alltrim(SE1->E1_NUMBCO))
				_cNumero := substr(_cNumbco,4,8)
				_cVarDAC := substr(_cNumbco,len(_cNumbco),1)
				//_cNumero:= SubStr(SE1->E1_NUMBCO,1,8)
				//varDAC  := SubStr(SE1->E1_NUMBCO,9,1)
				cParcela:= (AT(SE1->E1_PARCELA,"ABCDEFGHIJKLMN"),1)
				sDigit := substr(SE1->(E1_XLNDIGT),1,5) + '.' + substr(SE1->(E1_XLNDIGT),6,5) + " ";
					+ substr(SE1->(E1_XLNDIGT),11,5)+ '.' + substr(SE1->(E1_XLNDIGT),16,6) + " ";
					+ substr(SE1->(E1_XLNDIGT),22,5)+ '.' + substr(SE1->(E1_XLNDIGT),27,6) + " ";
					+ substr(SE1->(E1_XLNDIGT),33,1)+ ' ' + substr(SE1->(E1_XLNDIGT),34,14)

				if nPag<>1	// Fim de Pagina
					oPrn:EndPage()
					oPrn:StartPage()
				endif
				oPrn:Say(090,0140,"Banco Itau S.A.",oFont5,100)
				_cBitMap := "Itau.BMP" // Logotipo
				oPrn:SayBitMap(0045,0010,_cBitMap,100,070)
				oPrn:Say(095,2020,"RECIBO DO PAGADOR",oFont5,100)
				oPrn:Say(095,0500,"341-7",oFont4,100)
				oPrn:Say(090,0800,sDigit,oFont4,100)

				oPrn:Box(050,0460,121,0462)														// divisao entre Banco e nº. banco
				oPrn:Box(050,0650,121,0652)														// divisao entre no. banco e sacado
				oPrn:Box(120,0010,121,2400)											   			// divisao entre numero digitavel e vencimento

				oPrn:Say(150,0015,"local de Pagamento",oFont1,100)
				oPrn:Box(140,1650,300,1651)														// Traco separador vencimento sacado
				oPrn:Say(150,1660,"Vencimento",oFont1,100)										// Vencimento Sacado

				oPrn:Say(190,0015,"ATE O VENCIMENTO PAGUE PREFERENCIALMENTE NO ITAU",oFont8,100)
				oPrn:Say(215,0015,"APOS O VENCIMENTO PAGUE SOMENTE NO ITAU",oFont8,100)
				oPrn:Say(200,2000,Substr(Dtoc(SE1->E1_VENCREA),1,6)+cValToChar(Year(SE1->E1_VENCREA)),oFont5,100,,,1)			// Vencimento Sacado

				oPrn:Box(250,0010,251,2400)														// Cedente
				oPrn:Box(250,1650,330,1651)														// Traco separador Agencia / Codigo do Cedente
				oPrn:Say(280,0015,"Beneficiário",oFont1,100)
				oPrn:Say(280,1660,"Agência/Código Beneficiário",oFont1,100)						// Agencia / Codigo Cedente
				oPrn:Say(320,1360,_cCnpj,oFont7,100)

				oPrn:Say(320,0015,SM0->M0_NOMECOM,oFont7,100)									// Cedente
				oPrn:Say(320,2000,ALLTRIM(_cAgenc) + "/" + cConta+"-"+cContaD ,oFont5,100,,,1)	// Agencia / Codigo Cedente

				oPrn:Say(360,0015,"Endereco Beneficiário",oFont1,100)
				_nCalc := len(SM0->M0_CEPENT)- 3
				_cDigCep := Right( SM0->M0_CEPENT,3)

				oPrn:Say(400,0015,ALLTRIM(SM0->M0_ENDCOB)+" "+ "-"+" "+alltrim(SM0->M0_CIDENT)+" - "+ SM0->M0_ESTENT+" "+"CEP"+" "+substr(SM0->M0_CEPENT,1,_nCalc)+"-"+_cDigCep ,oFont1,100)

				oPrn:Box(330,0010,331,2400)									 					// Data do Documento
				oPrn:Say(450,0015,"Data do Documento",oFont1,100)	// 330 	 					// Data do Documento

				oPrn:Box(430,0360,520,0361)// 330,420 													// Numero do Documento
				oPrn:Say(450,0370,"No.Documento",oFont1,100) //330									// Numero do Documento

				oPrn:Box(430,0700,510,0701) //330,420													// Especie Doc.
				oPrn:Say(450,0705,"Espécie Doc.",oFont1,100)   //330									// Especie Doc.

				oPrn:Box(430,1050,510,1051) 	 //330,420												// Aceite
				oPrn:Say(450,1060,"Aceite",oFont1,100) //330											// Aceite

				oPrn:Box(430,1250,520,1251) // 330,420													// Dia Processamento
				oPrn:Say(450,1260,"Data Processamento",oFont1,100)  //330								// Dia Processamento

				oPrn:Box(330,1650,420,1651) // 330,420								 					// Cart./Nosso numero
				oPrn:Say(360,1660,"Nosso Numero",oFont1,100)//330	 							// Cart./Nosso numero

				oPrn:Say(490,0015,Dtoc(SE1->E1_EMISSAO),oFont1,100) //360								// Data do Documento

				If !EMPTY(SE1->E1_PARCELA)
					//oPrn:Say(490,0415,SE1->E1_PREFIXO + " " + AllTrim(SE1->E1_NUM) + " " + SE1->E1_PARCELA,oFont1,100) //360			// Numero do Documento
					oPrn:Say(490,0415,AllTrim(SE1->E1_NUM) + " " + SE1->E1_PARCELA,oFont1,100) //360			// Numero do Documento
				Else
					//oPrn:Say(490,0415,SE1->E1_PREFIXO + " " + AllTrim(SE1->E1_NUM)  ,oFont1,100) 	//360								// Numero do Documento
					oPrn:Say(490,0415,AllTrim(SE1->E1_NUM)  ,oFont1,100) 	//360								// Numero do Documento
				EndIf

				oPrn:Say(490,0770,"DMI",oFont1,100) //360	 											// Especie Doc.
				oPrn:Say(490,1100,"N",oFont1,100) //360 												// Aceite
				oPrn:Say(490,1260,Dtoc(dDataBase),oFont1,100)//360 									// Dia Processamento

				oPrn:Say(400,2000,cCart + "/" + _cNumero + "-" + _cVarDAC,oFont5,100,,,1) //360	// Cart./Nosso numero

				oPrn:Box(420,0010,421,2400) // 420,421													// Uso do Banco
				oPrn:Say(540,0015,"Uso Banco",oFont1,100) //420										// Uso do Banco
				oPrn:Box(520,0360,597,0361)
				oPrn:Box(520,0360,510,0361)  // 420,510													// Carteira
				oPrn:Say(540,0370,"Carteira",oFont1,100) //420										// Carteira
				oPrn:Box(520,0549,597,0550)
				oPrn:Box(520,0550,510,0551) //420													// Especie Moeda
				oPrn:Say(540,0560,"Espécie",oFont1,100)//420 									// Especie Moeda
				oPrn:Box(520,0849,597,0849)
				oPrn:Box(520,0850,510,0851) //420													// Quantidade e Valor
				oPrn:Say(540,0860,"Quantidade",oFont1,100)//420 										// Quantidade

				oPrn:Box(520,1250,550,1251) //420,450													// Linha da Barra do X
				oPrn:Box(581,1250,600,1251) //481,510													// Linha para fechar Barra do X
				oPrn:Say(540,1270,"Valor",oFont1,100) //420											// Valor

				oPrn:Box(420,1650,560,1651)	// 420,560													// Valor do Documento
				oPrn:Say(450,1660,"(=) Valor do Documento",oFont1,100)//420 						// Valor do documento

				oPrn:Say(570,0410,cCart,oFont1,100)//450 											// Carteira
				oPrn:Say(570,0620,"R$",oFont1,100) //450		 										// Especie Moeda

				//oPrn:Say(490,2000,Transform(SE1->(E1_SALDO+E1_ACRESC),PesqPict("SE1","E1_SALDO")),oFont5,100,,,1)// 450 // Valor Documento
				oPrn:Say(490,2000,Transform(SE1->(E1_SALDO-E1_SDDECRE+E1_SDACRES),PesqPict("SE1","E1_SALDO")),oFont5,100,,,1)// 450 // Valor Documento

				oPrn:Box(510,0010,511,2400)												   		// (-)Desconto/Abatimento
				oPrn:Box(510,1650,910,1651)														// Instrucoes para o banco
				oPrn:Box(597,0010,598,1651)
				oPrn:Say(630,0010,"Instrucoes de responsabilidade do BENEFICIARIO. Qualquer duvida sobre esse boleto, contate o BENEFICIARIO.",oFont1,100) // Instrucoes para o banco
				oPrn:Say(540,1660,"(-) Desconto/Abatimento",oFont1,100)						// (-)Desconto/Abatimento
			/* RETIRADO CONF. SOLICITADO PELA VANESSA
			If SE1->E1_PORCJUR <> 0
				//_nValJur := round(SE1->(E1_SALDO+E1_ACRESC) * (SE1->E1_PORCJUR/30),2)
				_nValJur := round(SE1->(E1_SALDO-E1_SDDECRE+E1_SDACRES) * (SE1->E1_PORCJUR/30),2)
				oPrn:Say(690,0015,"Apos o vencimento, cobrar mora de R$" + TRANSFORM(_nValJur,"@e 999,999.99") + " ao dia."	,oFont5,100)
			EndIf
			*/
				//oPrn:Say(730,0015,"Caixa, nao receber apos 15 dias do vencimento."	,oFont5,100)
				//oPrn:Say(730,0015,"Caixa, nao receber apos 60 dias do vencimento."	,oFont5,100)
				If !Empty(cQtde)
					oPrn:Say(730,0015,"Boleto válido por " + alltrim(cQtde) + " dias, apos isso será cancelado."	,oFont5,100)
				EndIf

				iF _nValMult > 0
					oPrn:Say( 740,0015, "Apos o vencimento, cobrar multa  no valor de R$ "+ AllTrim(transf(_nValMult,"@E 999,999.99")) + "." ,oFont5,100)
				ENDIF

				oPrn:Box(590,1650,591,2400)														// (-)Outras Deducoes
				oPrn:Say(620,1660,"(-) Outras Deducoes",oFont1,100)							// (-)Outras Deducoes

				oPrn:Box(670,1650,671,2400)														// (+)Mora/Multa
				oPrn:Say(700,1660,"(+) Mora/Multa",oFont1,100)								// (+)Mora/Multa

				oPrn:Box(750,1650,751,2400)														// (+)Outros Acrescimos
				oPrn:Say(780,1660,"(+)Outros Acréscimos",oFont1,100)							// (+)Outros Acrescimos

				//oPrn:Say(890,0015,"APOS VCTO ACESSE WWW.ITAU.COM.BR/BOLETOS PARA ATUALIZAR SEU BOLETO"	,oFont5,100)
				oPrn:Say(890,0015,""	,oFont5,100)
				oPrn:Box(830,1650,831,2400)														// (=)Valor Cobrado
				oPrn:Say(860,1660,"(=) Valor Cobrado",oFont1,100)								// (=)Valor Cobrado

				oPrn:Box(910,0010,911,2400)														// Sacado
				oPrn:Say(940,0015,"Pagador:  "+ _cNomcli,oFont6,100)

				_cCodId := alltrim(posicione("SA1",1,xFilial("SA1")+SE1->(E1_CLIENTE+E1_LOJA),"A1_CGC"))
				If Len(_cCodId)==11
					oPrn:Say(940,1650,"CPF : " + Transform(_cCodId,"@R 999.999.999-99"),oFont6,100)
				Else
					oPrn:Say(940,1650,"CNPJ: " + Transform(_cCodId,"@R 99.999.999/9999-99"),oFont6,100)
				EndIf

				oPrn:Say(0970,0132,_cEnd+" - "+_cBairr,oFont6,100)
				oPrn:Say(1000,0132,Transform(_cCep,"@R 99999-999")+"   "+_cMun+" - "+_cUF,oFont6,100)

				oPrn:Say(1050,0015,"Pagador/Avalista",oFont1,100)
				oPrn:Say(1050,2000,"Autenticacao Mecanica",oFont1,100)

				oPrn:Box(1060,0010,1061,2400)													// Traco separador da Autenticao Mecanica

				// divisao entre o recibo do sacado e ficha de caixa
				oPrn:Say(1120,0010,"--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------",oFont1,100)

				oPrn:Say(1180,0140,"Banco Itau S.A.",oFont5,100)

				_cBitMap := "Itau.BMP"															// Logotipo
				oPrn:SayBitMap(1135,0010,_cBitMap,100,070)

				oPrn:Say(1185,0500,"341-7",oFont4,100)
				oPrn:Say(1180,0800,sDigit,oFont4,100)

				oPrn:Box(1140,0460,1211,0462) 														// divisao entre Banco e nº. banco
				oPrn:Box(1140,0650,1211,0652)														// divisao entre no. banco e sacado
				oPrn:Box(1210,0010,1211,2400)														// divisao entre numero digitavel e vencimentoa

				oPrn:Say(1240,0015,"local de Pagamento",oFont1,100)
				oPrn:Box(1210,1650,1350,1651)														// Traco separador vencimento sacado
				oPrn:Say(1240,1660,"Vencimento",oFont1,100)											// Vencimento Sacado

				oPrn:Say(1280,0015,"ATE O VENCIMENTO PAGUE PREFERENCIALMENTE NO ITAU",oFont8,100)
				oPrn:Say(1305,0015,"APOS O VENCIMENTO PAGUE SOMENTE NO ITAU",oFont8,100)
				oPrn:Say(1290,2000,Substr(Dtoc(SE1->E1_VENCREA),1,6)+cValToChar(Year(SE1->E1_VENCREA)),oFont5,100,,,1)			// Vencimento Sacado

				oPrn:Box(1350,0010,1351,2400)														// Cedente
				oPrn:Box(1350,1650,1420,1651)														// Traco separador Agencia / Codigo do Cedente
				oPrn:Say(1375,0015,"Beneficiário",oFont1,100)

				oPrn:Say(1400,1380,_cCnpj,oFont7,100)
				oPrn:Say(1375,1660,"Agência/Código Beneficiário",oFont1,100)								// Agencia / Codigo Cedente

				oPrn:Say(1400,0015,SM0->M0_NOMECOM,oFont7,100)										// Cedente
				oPrn:Say(1410,2000,ALLTRIM(_cAgenc) + "/" + cConta+"-"+cContaD ,oFont5,100,,,1)	// Agencia / Codigo Cedente

				oPrn:Box(1420,0010,1421,2400)									 					// Data do Documento
				oPrn:Say(1445,0015,"Data do Documento",oFont1,100)		 							// Data do Documento

				oPrn:Box(1420,0360,1490,0361) 														// Numero do Documento
				oPrn:Say(1445,0370,"No.Documento",oFont1,100) 										// Numero do Documento

				oPrn:Box(1420,0698,1480,0699) 														// Especie Doc.
				oPrn:Say(1445,0705,"Espécie Doc.",oFont1,100) 										// Especie Doc.

				oPrn:Box(1420,1047,1480,1048) 														// Aceite
				oPrn:Say(1445,1060,"Aceite",oFont1,100) 											// Aceite

				oPrn:Box(1420,1250,1490,1251) 														// Dia Processamento
				oPrn:Say(1445,1260,"Data Processamento",oFont1,100) 								// Dia Processamento

				oPrn:Box(1420,1650,1490,1651) 								 						// Cart./Nosso numero
				oPrn:Say(1445,1660,"Nosso Numero",oFont1,100)	 									// Cart./Nosso numero

				oPrn:Say(1480,0015,Dtoc(SE1->E1_EMISSAO),oFont1,100)								// Data do Documento

				If !EMPTY(SE1->E1_PARCELA)
					//oPrn:Say(1480,0415,SE1->E1_PREFIXO + " " + AllTrim(SE1->E1_NUM) + " " + SE1->E1_PARCELA,oFont1,100) //360			// Numero do Documento
					oPrn:Say(1480,0415,AllTrim(SE1->E1_NUM) + " " + SE1->E1_PARCELA,oFont1,100) //360			// Numero do Documento
				Else
					//oPrn:Say(1480,0415,SE1->E1_PREFIXO + " " + AllTrim(SE1->E1_NUM)  ,oFont1,100) 	//360								// Numero do Documento
					oPrn:Say(1480,0415,AllTrim(SE1->E1_NUM)  ,oFont1,100) 	//360								// Numero do Documento
				EndIf

				oPrn:Say(1480,0770,"DMI",oFont1,100)	 									      	// Especie Doc.
				oPrn:Say(1480,1100,"N",oFont1,100) 													// Aceite
				oPrn:Say(1480,1260,Dtoc(dDataBase),oFont1,100) 										// Dia Processamento
				oPrn:Say(1480,2000,cCart + "/" + _cNumero + "-" + _cVarDAC,oFont5,100,,,1)	// Cart./Nosso numero

				oPrn:Box(1490,0010,1491,2400) 														// Uso do Banco
				oPrn:Say(1515,0015,"Uso Banco",oFont1,100) 											// Uso do Banco

				oPrn:Box(1490,0360,1560,0361) 														// Carteira
				oPrn:Say(1515,0370,"Carteira",oFont1,100) 											// Carteira

				oPrn:Box(1490,0550,1560,0551) 														// Especie Moeda
				oPrn:Say(1515,0560,"Espécie ",oFont1,100) 										// Especie Moeda

				oPrn:Box(1490,0850,1560,0851) 														// Quantidade e Valor
				oPrn:Say(1515,0860,"Quantidade",oFont1,100) 										// Quantidade

				oPrn:Box(1490,1250,1510,1251) 														// Linha da Barra do X
				oPrn:Box(1541,1250,1560,1251) 														// Linha para fechar Barra do X

				oPrn:Say(1515,1270,"Valor",oFont1,100) 												// Valor

				oPrn:Box(1490,1650,1560,1651)														// Valor do Documento
				oPrn:Say(1515,1660,"(=) Valor do Documento",oFont1,100)							// Valor do documento

				oPrn:Say(1550,0410,cCart,oFont1,100) 												// Carteira
				oPrn:Say(1550,0620,"R$",oFont1,100) 												// Especie Moeda

				//oPrn:Say(1547,2000,Transform(SE1->(E1_SALDO+E1_ACRESC),PesqPict("SE1","E1_SALDO")),oFont5,100,,,1)// 450 // Valor Documento
				oPrn:Say(1547,2000,Transform(SE1->(E1_SALDO-E1_SDDECRE+E1_SDACRES),PesqPict("SE1","E1_SALDO")),oFont5,100,,,1)// 450 // Valor Documento

				oPrn:Box(1560,0010,1561,2400)														// (-)Desconto/Abatimento
				oPrn:Box(1560,1650,1910,1651)														// Instrucoes para o banco

				oPrn:Say(1585,0010,"Instrucoes de responsabilidade do BENEFICIARIO. Qualquer duvida sobre esse boleto, contate o BENEFICIARIO.",oFont1,100) // Instrucoes para o banco
				oPrn:Say(1585,1660,"(-) Desconto/Abatimento",oFont1,100)	// (-)Desconto/Abatimento

			/* RETIRADO COMNF. SOLCITADO PELA VANESSA
			If SE1->E1_PORCJUR <> 0
				//_nValJur := round(SE1->(E1_SALDO+E1_ACRESC) * (SE1->E1_PORCJUR/30),2)
				_nValJur := round(SE1->(E1_SALDO-E1_SDDECRE+E1_SDACRES) * (SE1->E1_PORCJUR/30),2)
				oPrn:Say(1640,0015,"Apos o vencimento, cobrar mora de R$" + TRANSFORM(_nValJur,"@e 999,999.99") + " ao dia."	,oFont5,100)
			EndIf
			*/
				//oPrn:Say(1670,0015,"Caixa, nao receber apos 60 dias do vencimento."	,oFont5,100)
				if !Empty(cQtde)
					oPrn:Say(1670,0015,"Boleto válido por "  + alltrim(cQtde) + " dia, apos isso será cancelado."	,oFont5,100)
				EndIF
				iF _nValMult > 0
					oPrn:Say( 1710,0015, "Apos o vencimento, cobrar multa  no valor de R$ "+ AllTrim(transf(_nValMult,"@E 999,999.99")) + "." ,oFont5,100)
				endIF


				oPrn:Box(1630,1650,1631,2400)														// (-)Outras Deducoes
				oPrn:Say(1655,1660,"(-) Outras Deducoes",oFont1,100)								// (-)Outras Deducoes

				oPrn:Box(1700,1650,1701,2400)														// (+)Mora/Multa
				oPrn:Say(1725,1660,"(+) Mora/Multa",oFont1,100)									// (+)Mora/Multa

				oPrn:Box(1770,1650,1771,2400)														// (+)Outros Acrescimos
				oPrn:Say(1795,1660,"(+)Outros Acréscimos",oFont1,100)								// (+)Outros Acrescimos

				//oPrn:Say(1860,0015,"APOS VCTO ACESSE WWW.ITAU.COM.BR/BOLETOS PARA ATUALIZAR SEU BOLETO ",oFont5,100)
				oPrn:Say(1860,0015,"",oFont5,100)
				oPrn:Box(1840,1650,1841,2400)														// (=)Valor Cobrado
				oPrn:Say(1865,1660,"(=) Valor Cobrado",oFont1,100)								// (=)Valor Cobrado

				oPrn:Box(1910,0010,1911,2400)														// Sacado
				oPrn:Say(1935,0015,"Pagador:  " + _cNomcli,oFont6,100)

				If Len(_cCodId)==11
					oPrn:Say(1935,1650,"CPF : "+Transform(_cCodId,"@R 999.999.999-99"),oFont6,100)
				Else
					oPrn:Say(1935,1650,"CNPJ: " + Transform(_cCodId,"@R 99.999.999/9999-99"),oFont6,100)
				EndIf

				oPrn:Say(1960,0132,_cEnd+" - "+_cBairr+","+_cCompl,oFont6,100)
				oPrn:Say(1990,0132,Transform(_cCep,"@R 99999-999")+"   "+_cEnd+' - '+_cUF,oFont6,100)

				oPrn:Say(2050,0015,"Pagador/Avalista",oFont1,100)
				oPrn:Say(2070,2000,"Ficha de Compensacao",oFont5,100)
				oPrn:Say(2100,2050,"Autenticacao Mecanica",oFont1,100)

				//oPrn:FWMSBAR("INT25",48.5,1.5,SE1->(E1_CODBAR),oPrn,.F.,,   ,      ,1.2,   ,.F.,NIL,NIL,.F.)
				oPrn:FWMSBAR("INT25",48.5,1.5,SE1->(E1_CODBAR),oPrn,.F.,,.T.,      ,1.2,NIL,NIL,NIL,.F.)
				//	 FWMSBAR("INT25",65.9,4.5,sBarra		  ,oPrn,.F.,,.T.,0.0164,1.0,NIL,NIL,NIL,.F.)
				nPag ++
				oPrn:EndPage()

				// Guarda os títulos para enviar no corpo do e-mail
				aadd(aTitulos,{_cNomcli, SE1->E1_NUM + '/' + SE1->E1_PREFIXO , Dtoc(SE1->E1_VENCREA) , Transform(SE1->(E1_SALDO-E1_SDDECRE+E1_SDACRES),PesqPict("SE1","E1_SALDO")) })
			else
				alert('Nao foi possivel realizar a impressao de boleto')
			endif
		EndIf
		If _nVezes <> 0
			Alert ("Existe(m) " + Alltrim(Str(_nVezes)) + " Boleto(s) a vista, que nao sera(o) impresso(s)! Verifique")
		Endif
		If cBoleto $ 'S/I|E'  .AND. LEN(aTitulos) > 0
			If ! cChamada $ 'JOBP' .and. lImprime
				oPrn:Preview()
			Else
				If lImprime
					oPrn:Print()
				EndIF
			EndIF
			If lImprime
				FreeObj(oPrn)
				oPrn := Nil
			EndiF
			// ROTINA PARA ENVIAR EMAIL

			If File(GetTempPath()+"\totvsprinter\"+StrTran(_cArq,".rel",".pdf"))
				cAnexo := GetTempPath()+"\totvsprinter\"+StrTran(_cArq,".rel",".pdf")
				//If lImprime // iF ! File (cPathInServer + '\' +   strtran(_cArq , ".rel", ".pdf") )
				CpyT2S(cAnexo,cPathInServer,)
				//endIF
			EndIf

		EndIf

		IF ! cChamada  $ "JOBP" // BOLETO NORMAL
			cAssunto := IIf(cFormPG=='2',"LINK PARA",IIf(cFormPG=='3',"INFORMAÇÕES PARA","BOLETO DE"))+" PAGAMENTO  " +  aTitulos [1,2]
			cAnexo   := IIf(!(cFormPG $'2,3'),cPathInServer + '\' +   strtran(_cArq , ".rel", ".pdf"),"")

			cCorpo := ''
			cCorpo += '<html>'
			cCorpo += '<head>'
			cCorpo += '<meta content="text/html; charset=ISO-8859-1"'
			cCorpo += 'http-equiv="content-type">'
			cCorpo += '<title>teste</title>'
			cCorpo += '</head>'
			cCorpo += '<body>'
			cCorpo += '<img style="width: 275px; height: 80px;" alt=""'
			//src="file:///C:/Users/ADMIN/OneDrive%20-%20edy/Documentos/Verion/logoVerion.JPG">
			cCorpo += '<br>'
			cCorpo += '<br>'
			cCorpo += "<br>"
			cCorpo += 'Prezado(a), ' + aTitulos[1,1] +  '<br>'
			cCorpo += '<br>'

			If !(cFormPG $ '2,3')
				cCorpo += 'Estamos enviando boleto(s) a vencer nos próximos dias, referente '
				cCorpo += 'a&nbsp; sua compra NF: ' + aTitulos[1,2] + ', conforme abaixo:<b>'
				cCorpo += '<br>'
			/*
			ElseIf cFormPG == '2'
				cCorpo += 'Por favor efetue o pagamento pelo link: '+cLinkPG
				cCorpo += '<br>'
			ElseIf cFormPG == '3'
				cCorpo += 'Por favor efetue o pagamento pela chave pix: '+cLinkPG
				cCorpo += '<br>'
			*/
			EndIf

			cCorpo += '<table style="text-align: left; width: 522px; height: 69px;" border="1"'
			cCorpo += 'cellpadding="2" cellspacing="2">'
			cCorpo += '<tbody>'
			cCorpo += '<tr>'
			cCorpo += '<td	style="vertical-align: top; background-color: silver; font-weight: bold; text-align: center;">Vencimento<br>'
			cCorpo += "</td>"
			ccorpo += '<td	style="vertical-align: top; background-color: silver; font-weight: bold; text-align: center;">Valor'
			cCorpo += '<br>'
			cCorpo += '</td>'
			cCorpo += '</tr>'

			If !(cFormPG $ '2,3')

				nMaxTit := Len(aTitulos)

				For xx := 1  to nMaxTit
					cCorpo += '<tr>'
					cCorpo += '<td style="vertical-align: top; text-align: center;">'  + aTitulos[xx,3] + '<br>'
					cCorpo += '</td>'
					cCorpo += '<td style="vertical-align: top; text-align: right;">&nbsp;R$' + aTitulos[xx,4]
					cCorpo += '<br>'
					cCorpo += '</td>'
					cCorpo += '</tr>'
				Next

			ElseIf cFormPG == '2'
				cCorpo += '<td style="vertical-align: top; text-align: center;">Por favor efetue o pagamento de R$ '+Transform(SomaParc(aTitulos),"@E 999,999,999.99")+' pelo link: '+cLinkPG
				cCorpo += '<br>'
			ElseIf cFormPG == '3'
				cCorpo += '<td style="vertical-align: top; text-align: center;">Por favor efetue o pagamento de R$ '+Transform(SomaParc(aTitulos),"@E 999,999,999.99")+' entrando em contato com: '+cLinkPG
				cCorpo += '<br>'

			EndIf

			cCorpo += '</tbody>'
			cCorpo += '</table>'
			cCorpo += '<br>'
			cCorpo += '<br>'
			cCorpo += ' Caso haja alguma dúvida, solicitamos que entre em contato: Tel.: (55) 11 2100-7400.<small><small><small>'
			cCorpo += '<span style="color: rgb(51, 51, 51); font-family: Arimo,sans-serif; font-size: 14px; font-style: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; background-color: rgb(238, 238, 238); display: inline ! important; float: none;"><br>'
			ccorpo += '</span></small></small></small><br>'
			cCorpo += '<br><br><br><br>'
			cCorpo += '</body>'
			cCorpo += '</html>'
		ELSE // boletos não pagos
			cAssunto := IIf(cFormPG=='2',"LINK PARA",IIf(cFormPG=='3',"CHAVE PIX PARA","BOLETO DE"))+" PAGAMENTO  " +  aTitulos [1,2]
			cAnexo   := IIf(!(cFormPG $'2,3'),cPathInServer + '\' +   strtran(_cArq , ".rel", ".pdf"),"")

			cCorpo := ''
			cCorpo += '<html>'
			cCorpo += '<head>'
			cCorpo += '<meta content="text/html; charset=ISO-8859-1"'
			cCorpo += 'http-equiv="content-type">'
			cCorpo += '<title>teste</title>'
			cCorpo += '</head>'
			cCorpo += '<body>'
			cCorpo += '<img style="width: 275px; height: 80px;" alt=""'
			//src="file:///C:/Users/ADMIN/OneDrive%20-%20edy/Documentos/Verion/logoVerion.JPG">
			cCorpo += '<br>'
			cCorpo += '<br>'
			cCorpo += "<br>"
			cCorpo += 'Prezado(a), ' + aTitulos[1,1] +  '<br>'
			cCorpo += '<br>'
			cCorpo += ' Não identificamos em nosso sistema o pagamento'+Iif(!(cFormPG $'2,3'),' do boleto','')+' referente '
			cCorpo += 'a&nbsp; sua compra NF: ' + aTitulos[1,2] + ', conforme abaixo:<b>'
			cCorpo += '<br>'
			cCorpo += '<table style="text-align: left; width: 522px; height: 69px;" border="1"'
			cCorpo += 'cellpadding="2" cellspacing="2">'
			cCorpo += '<tbody>'
			cCorpo += '<tr>'
			cCorpo += '<td	style="vertical-align: top; background-color: silver; font-weight: bold; text-align: center;">Vencimento<br>'
			cCorpo += "</td>"
			ccorpo += '<td	style="vertical-align: top; background-color: silver; font-weight: bold; text-align: center;">Valor'
			cCorpo += '<br>'
			cCorpo += '</td>'
			cCorpo += '</tr>'

			If !(cFormPG $ '2,3')

				nMaxTit := Len(aTitulos)

				For xx := 1  to nMaxTit
					cCorpo += '<tr>'
					cCorpo += '<td style="vertical-align: top; text-align: center;">'  + aTitulos[xx,3] + '<br>'
					cCorpo += '</td>'
					cCorpo += '<td style="vertical-align: top; text-align: right;">&nbsp;R$' + aTitulos[xx,4]
					cCorpo += '<br>'
					cCorpo += '</td>'
					cCorpo += '</tr>'
				Next

			ElseIf cFormPG == '2'
				cCorpo += '<td style="vertical-align: top; text-align: center;">Por favor efetue o pagamento de R$ '+Transform(SomaParc(aTitulos),"@E 999,999,999.99")+' pelo link: '+cLinkPG
				cCorpo += '<br>'
			ElseIf cFormPG == '3'
				cCorpo += '<td style="vertical-align: top; text-align: center;">Por favor efetue o pagamento de R$ '+Transform(SomaParc(aTitulos),"@E 999,999,999.99")+' entrando em contato com: '+cLinkPG
				cCorpo += '<br>'
			EndIf

			cCorpo += '</tbody>'
			cCorpo += '</table>'
			cCorpo += '<br>'
			cCorpo += '<br>'
			cCorpo += ' Caso haja alguma dúvida, solicitamos que entre em contato: Tel.: (55) 11 2100-7400.<small><small><small>'
			cCorpo += '<span style="color: rgb(51, 51, 51); font-family: Arimo,sans-serif; font-size: 14px; font-style: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; background-color: rgb(238, 238, 238); display: inline ! important; float: none;"><br>'
			ccorpo += '</span></small></small></small><br>'
			cCorpo += '<br><br><br><br>'
			cCorpo += '</body>'
			cCorpo += '</html>'

			cCopia := ''
		ENDIF
		If cChamada $ "JOBP"
			lImprime := .T.
		EndIF
		If lImprime
			If upper(GetEnvServer()) =='HOMOLOG'
				cEmail := 'claudia.cabral@adinfoconsultoria.com.br'
				cCopia := ''
			ENDIF
			U_VerionMail(cEmail ,cCopia,, cAssunto , cCorpo, cAnexo)
		endIF

	endif
	RestArea(_aAreaSE1)
	RestArea(_aAreaSA1)
	RestArea(_aAreaSA6)
	RestArea(_aAreaSEE)
	RestArea(_aArea)

Return(.T.)



Static Function SomaParc(aTitulos)
	Local nValor := 0
	Local n := 0

	For n:=1 to Len(aTitulos)
		nValor += aTitulos[n,4]
	Next

Return nValor
