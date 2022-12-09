#Include "Totvs.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma: |CRPR190  	ºAutor  ³Renato Ruy Bernardo º Data ³  12/08/2015 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Relatório de Rastreamento de voucher.				      º±±
±±º          ³ Emissão x Consumo de Voucher.                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Certisign                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CRPR190()

Local aPergs	:= {}
Local aPedidos 	:= {}
Local cDir		:= GetTempPath()+"\Vouchers.XML"
Local cPeriodo	:= AllTrim(GetMv("MV_REMMES"))

Private aRet	:= {}
Private cPedIn	:= ""
Private cPerg   := "CRP190"

//Perguntas do parambox
aAdd( aPergs ,{1 ,"Periodo " 	 	,cPeriodo	,"","","","",50,.F.})
aAdd( aPergs ,{6 ,"Gravar arquivo" 	,cDir		,"","","",50,.F.,"Arquivos .XML |*.XML"})
aAdd( aPergs ,{2 ,"Tipo" 	 		,"SINTETICO",{"SINTETICO","ANALITICO"}	, 100,'.T.',.T.})
aAdd( aPergs ,{2 ,"Origem" 	 		,"CONSUMIDO",{"CONSUMIDO","GERADO"}		, 100,'.T.',.T.})

If !ParamBox(aPergs ,"Parametros ",aRet)
	Alert("O relatório foi cancelado!")
	Return
EndIf

Processa( {|| GerReg() }, "Selecionando registros...")

Return

//Processamento do relatório

Static Function GerReg

Local oExcel 		:= FWMSEXCEL():New()
Local cAcAnt		:= ""
Local cNomArq		:= ""
Local cCcrAnt		:= ""
Local cTipEnt		:= ""
Local cTipVou		:= ""
Local cMotivo		:= ""
Local nValSW		:= 0
Local nValHW		:= 0
Local nQuant		:= 0
Local nSaldo		:= 0
Local nQtd			:= 0
Local aValor		:= {}

If Select("QCRPR190") > 0
	QCRPR190->(DbCloseArea())
EndIf 

IncProc( "Consultando a base de dados..")
ProcessMessage()

If aRet[4] == "GERADO"
	Beginsql Alias "QCRPR190"
		SELECT 	ZF_COD, 
				ZF_TIPOVOU, 
				ZF_VALORSW, 
				ZF_VALORHW,
				ZF_VALOR, 
				ZF_PEDIDO, 
				ZF_PEDSITE, 
				ZF_CODORIG,
				ZF_SALDO
		FROM %Table:SZF%
		WHERE
		ZF_FILIAL = %xFilial:SZF% AND
		ZF_DATCRI BETWEEN %Exp:aRet[1]+"01"% AND %Exp:aRet[1]+"31"% AND
		%Notdel%
		ORDER BY ZF_TIPOVOU
	Endsql
Else
	Beginsql Alias "QCRPR190"
		SELECT 	ZF_COD, 
				ZF_TIPOVOU, 
				ZF_VALORSW, 
				ZF_VALORHW,
				ZF_VALOR, 
				ZF_PEDIDO, 
				ZF_PEDSITE, 
				ZF_CODORIG,
				ZF_SALDO 
		FROM %Table:SZG% SZG
		JOIN %Table:SZF% SZF ON ZG_FILIAL = %xFilial:SZG% AND ZF_COD = ZG_NUMVOUC AND SZF.%Notdel%
		WHERE
		ZG_FILIAL = %xFilial:SZG% AND
		ZG_DATAMOV BETWEEN %Exp:aRet[1]+"01"% AND %Exp:aRet[1]+"31"% AND
		SZG.%Notdel%
		ORDER BY ZF_TIPOVOU
	Endsql
Endif

DbSelectArea("QCRPR190")
QCRPR190->(DbGoTop())

//Cria nova aba
oExcel:AddworkSheet("VOUCHER")

//Cria Cabecalho da tabela
oExcel:AddTable ("VOUCHER","VOUCHER")

//Adiciona cabecalho dos itens 
If aRet[3] == "ANALITICO"
	oExcel:AddColumn("VOUCHER","VOUCHER","VOUCHER"  		, 2,1)
	oExcel:AddColumn("VOUCHER","VOUCHER","COD.TIPO VOUCHER"	, 2,1)
	oExcel:AddColumn("VOUCHER","VOUCHER","TIPO VOUCHER"		, 2,1)
	oExcel:AddColumn("VOUCHER","VOUCHER","VALOR SW"	   		, 2,1)
	oExcel:AddColumn("VOUCHER","VOUCHER","VALOR HW"			, 2,1)
	oExcel:AddColumn("VOUCHER","VOUCHER","SALDO"			, 2,1)
	oExcel:AddColumn("VOUCHER","VOUCHER","MOTIVO"			, 2,1)
Else
	oExcel:AddColumn("VOUCHER","VOUCHER","COD.TIPO VOUCHER"	, 2,1)
	oExcel:AddColumn("VOUCHER","VOUCHER","TIPO VOUCHER"		, 2,1)
	oExcel:AddColumn("VOUCHER","VOUCHER","QUANTIDADE"  		, 2,1)
	oExcel:AddColumn("VOUCHER","VOUCHER","VALOR SW"	   		, 2,1)
	oExcel:AddColumn("VOUCHER","VOUCHER","VALOR HW"			, 2,1)
	oExcel:AddColumn("VOUCHER","VOUCHER","SALDO"			, 2,1)
	oExcel:AddColumn("VOUCHER","VOUCHER","UTILIZADO"		, 2,1)
	oExcel:AddColumn("VOUCHER","VOUCHER","MOTIVO"			, 2,1)
Endif

cTipVou := QCRPR190->ZF_TIPOVOU

While !QCRPR190->(EOF())
	
	nQtd += 1
	                                           
	IncProc( "Processo " + AllTrim(Str(nQtd)) + " --> Voucher: " + QCRPR190->ZF_COD)
	ProcessMessage()
	
	//Caso o pedido esteja sem valor, busca na estrutura do voucher.
	If "3" $ QCRPR190->ZF_TIPOVOU
		aValor := {QCRPR190->ZF_VALOR,0}
	Elseif QCRPR190->ZF_VALORSW+QCRPR190->ZF_VALORHW == 0
		aValor := CRPR190I(QCRPR190->ZF_COD,QCRPR190->ZF_TIPOVOU)
	Endif
	
	//Adiciona Itens
	If aRet[3] == "ANALITICO"
		cMotivo := CRPR190M(QCRPR190->ZF_TIPOVOU)
		oExcel:AddRow("VOUCHER","VOUCHER",{	QCRPR190->ZF_COD,;
											QCRPR190->ZF_TIPOVOU,;
											Posicione("SZH",1,xFilial("SZH")+QCRPR190->ZF_TIPOVOU,"ZH_DESCRI"),;
											Iif(Len(aValor)==0,QCRPR190->ZF_VALORSW,aValor[1]),;
											Iif(Len(aValor)==0,QCRPR190->ZF_VALORHW,aValor[2]),;
											QCRPR190->ZF_SALDO,;
											cMotivo})
	//se o voucher e do mesmo tipo somente soma o valor.
	Elseif cTipVou == QCRPR190->ZF_TIPOVOU
		nQuant	+= 1
		nSaldo	+= QCRPR190->ZF_SALDO
		nValSW	+= Iif(Len(aValor)==0,QCRPR190->ZF_VALORSW,aValor[1])
		nValHW	+= Iif(Len(aValor)==0,QCRPR190->ZF_VALORHW,aValor[2])
	Elseif cTipVou <> QCRPR190->ZF_TIPOVOU
		cMotivo := CRPR190M(cTipVou)	
		oExcel:AddRow("VOUCHER","VOUCHER",{cTipVou,;
											Posicione("SZH",1,xFilial("SZH")+cTipVou,"ZH_DESCRI"),;
											nQuant,;
											nValSW,;
											nValHW,;
											nSaldo,;
											nQuant-nSaldo,;
											cMotivo})
		//Inicia valores do proximo tipo de voucher.
		cTipVou := QCRPR190->ZF_TIPOVOU 
		nQuant	:= 1 
		nSaldo	:= QCRPR190->ZF_SALDO
		nValSW	:= Iif(Len(aValor)==0,QCRPR190->ZF_VALORSW,aValor[1])
		nValHW	:= Iif(Len(aValor)==0,QCRPR190->ZF_VALORHW,aValor[2])
	Endif
					
	aValor := {}
	
	QCRPR190->(DbSkip())
EndDo

//Grava o ultimo voucher que foi somado
If aRet[3] == "SINTETICO" 
	cMotivo := CRPR190M(cTipVou)	
	oExcel:AddRow("VOUCHER","VOUCHER",{cTipVou,;
										Posicione("SZH",1,xFilial("SZH")+cTipVou,"ZH_DESCRI"),;
										nQuant,;
										nValSW,;
										nValHW,;
										nSaldo,;
										nQuant-nSaldo,;
										cMotivo})
Endif

//Salva o Arquivo
oExcel:Activate()
oExcel:GetXMLFile(AllTrim(aRet[2]))

//Abre o excel com os dados
oExcelApp := MsExcel():New()
oExcelApp:WorkBooks:Open(aRet[2])
oExcelApp:SetVisible(.T.)

Return

Static Function CRPR190I(cVoucher, cTipo)

Local cPedGar 	:= ""
Local cPedSite	:= ""
Local cVouAnt 	:= ""
Local lPosicao	:= .F.
Local lHardFix	:= .T.
Local nValTotSW	:= 0
Local nValTotHW	:= 0
Local nValTot	:= 0

//Voucher que tem origem em pedido ou através de outro voucher.
If cTipo$"2/A/B/H"

	SZF->(DbSetOrder(2))
	SZF->(DbSeek(xFilial("SZF")+cVoucher))

	cPedGar  := Iif(Val(SZF->ZF_PEDIDO)>0,AllTrim(Str(Val(SZF->ZF_PEDIDO)))," ")
	cPedSite := Iif(Val(SZF->ZF_PEDSITE)>0,AllTrim(Str(Val(SZF->ZF_PEDSITE)))," ")
	cVouAnt  := SZF->ZF_CODORIG 
	
	While (!Empty(cPedGar) .Or. !Empty(cPedSite) .Or. !Empty(cVouAnt)) .And. nValTotSw+nValTotHw == 0
		
		If !Empty(cPedGar)
			//Indice - Filial + Pedido Gar
			SZG->(DbSetOrder(1))
			lPosicao := SZG->(DbSeek(xFilial("SZG")+cPedGar))
                    
			If lPosicao
				//Indice - Filial + Voucher
				SZF->(DbSetOrder(2))
				lPosicao := SZF->(DbSeek(xFilial("SZF")+SZG->ZG_NUMVOUC))
				nValTotSW := SZF->ZF_VALORSW
				nValTotHW := SZF->ZF_VALORHW
			Endif
			
		Elseif !Empty(cPedSite)
			//Indice - Filial + Pedido Site 
			SZG->(DbSetOrder(3))
			lPosicao := SZG->(DbSeek(xFilial("SZG")+cPedSite))	
			
			If lPosicao
				//Indice - Filial + Voucher
				SZF->(DbSetOrder(2))
				lPosicao := SZF->(DbSeek(xFilial("SZF")+SZG->ZG_NUMVOUC))
				nValTotSW := SZF->ZF_VALORSW
				nValTotHW := SZF->ZF_VALORHW
			Endif			
		Elseif !Empty(cVouAnt)
			//Indice - Filial + Voucher
			SZF->(DbSetOrder(2))
			lPosicao := SZF->(DbSeek(xFilial("SZF")+cVouAnt))
			nValTotSW := SZF->ZF_VALORSW
			nValTotHW := SZF->ZF_VALORHW
		Endif
		
		If !lPosicao
			
			If !Empty(cPedGar)
				//Indice - Filial + Pedido Gar
				SC5->(DbSetOrder(5))
				lPosicao := SC5->(DbSeek(xFilial("SC5")+cPedGar))
													
			Elseif !Empty(cPedSite)
				//Indice - Filial + Pedido Site
				SC5->(DbSetOrder(8))
				lPosicao := SC5->(DbSeek(xFilial("SC5")+cPedSite))
			Endif
			
			If lPosicao
				nValTotSw := 0
				nValTotHw := 0
				
				DbSelectArea("SC6")
				DbSetOrder(1)
				If DbSeek( xFilial("SC6") + SC5->C5_NUM )
					
					lHardFix:=.F.
					While SC6->C6_FILIAL == SC5->C5_FILIAL .And. SC6->C6_NUM == SC5->C5_NUM
						
						DbSelectArea("SB1")
						DbSetOrder(1)
						If DbSeek( xFilial("SB1") + SC6->C6_PRODUTO )
							
							If SB1->B1_CATEGO == "2" .And. SC6->C6_XOPER != "53" //.And. lHardFix
								nValTotSw += SC6->C6_PRCVEN
								nValTot   += SC6->C6_PRCVEN
								
							ElseIf SB1->B1_CATEGO == "1" .And. SC6->C6_XOPER != "53" .And. SZ5->Z5_TIPVOU != "H"
								
								SB5->(DbSetOrder(1))
								If SB5->(DbSeek( xFilial("SB5") + SB1->B1_COD )) .And. GetMv("MV_XREMFIX")
									
									// Solicitante: Priscila Kuhn - 08/04/2016
									// Não desmembra o valor se o total é igual valor fixo.
									If SC5->C5_TOTPED > SB5->B5_PRV7
										nValTotHw += Iif(SB5->B5_PRV7+nValTotHw > SC5->C5_TOTPED .And. SC5->C5_TOTPED > 0, SC5->C5_TOTPED,SB5->B5_PRV7)
										nValTot   += SC6->C6_PRCVEN
										// Priscila Kuhn - Geração de valores superiores, faço o controle através da variavel
										lHardFix := .T.
										//ElseIf AllTrim(SB1->B1_COD) $ cCodHard
									Else
										nValTotHw += SC6->C6_PRCVEN
										nValTot   += SC6->C6_PRCVEN
									EndIf
									
								Else
									nValTotHw += SC6->C6_PRCVEN
									nValTot   += SC6->C6_PRCVEN
								EndIf
								
							EndIf
							
						EndIf
						DbSelectArea("SC6")
						SC6->(DbSkip())
					EndDo
					
					if lHardFix
						
						nValTotSw:=IIF(nValTot-nValTotHw>0,nValTot-nValTotHw,0)
						
					endif
					
				EndIf
			Endif
				
		EndIf
		
		If (!lPosicao .And. nValTotSw+nValTotHw == 0) .Or. nValTotSw+nValTotHw > 0
			cPedGar  := " "
			cPedSite := " "
			cVouAnt  := " "
		Elseif nValTotSw+nValTotHw == 0 
			cPedGar  := Iif(Val(SZF->ZF_PEDIDO)>0 .And. AllTrim(SZF->ZF_PEDIDO) <> AllTrim(cPedGar),AllTrim(Str(Val(SZF->ZF_PEDIDO)))," ")
			cPedSite := Iif(Val(SZF->ZF_PEDSITE)>0 .And. AllTrim(SZF->ZF_PEDSITE) <> AllTrim(cPedSite),AllTrim(Str(Val(SZF->ZF_PEDSITE)))," ")
			cVouAnt  := Iif(AllTrim(SZF->ZF_CODORIG) <> AllTrim(cVouAnt),SZF->ZF_CODORIG," ")
		Endif
		
		lPosicao := .F.		
	Enddo
				
EndIf

Return {nValTotSW,nValTotHW}

//Renato Ruy - 22/03/2017
//Solicitado pelo Giovanni Rodrigues, para adicionar o objetivo de cada tipo de voucher.
Static Function CRPR190M(cTipVou)

Local cMotivo := ""

If "A" $ cTipVou
	cMotivo := "Ocorrencia de erro durante o periodo de validade do certificado"
Elseif "B" $ cTipVou
	cMotivo := "Emitimos um voucher com erro e foi necessario gerar um novo voucher"
Elseif "C" $ cTipVou
	cMotivo := "Voucher emitido na venda para o governo pelo departamento SAV"
Elseif "D" $ cTipVou
	cMotivo := "Voucher emitido na venda para clientes pelo departamento de Vendas Diretas"
Elseif "E" $ cTipVou
	cMotivo := "Voucher emitido na venda para clientes pelo departamento de Canais"                 
Elseif "F" $ cTipVou
	cMotivo := "Venda em lote geralmente em licitacao e gerado para o cliente que utilizara o voucher"
Elseif "G" $ cTipVou
	cMotivo := "Voucher gerado para funcionario de parceiros"
Elseif "H" $ cTipVou
	cMotivo := "Voucher gerado quando expira o prazo de emissao do certificado na renovacao"
Elseif "I" $ cTipVou
	cMotivo := "Perda da chave privada do certificado ou login incorreto na solicitacao"    
Elseif "I" $ cTipVou
	cMotivo := "Voucher gerado inicialmente para sorteio em campanha"                          
Elseif "2" $ cTipVou
	cMotivo := "Houve um erro na emissao do pedido e foi necessario gerar um voucher"    
Elseif "3" $ cTipVou
	cMotivo := "Voucher gerado como brinde para o clientes"                     
Elseif "4" $ cTipVou
	cMotivo := "Voucher gerado para venda em lote"
Elseif "5" $ cTipVou
	cMotivo := "Voucher gerado para licitacao do governo"                
Elseif "6" $ cTipVou
	cMotivo := "Voucher gerado pela infraestrutura para o funcionario emitir o certificado"                   
Elseif "7" $ cTipVou
	cMotivo := "Voucher utilizado em testes para validacao de processo"                        
Elseif "8" $ cTipVou
	cMotivo := "Voucher utilizado para validacao de processo em auditoria"                    
Elseif "9" $ cTipVou
	cMotivo := "Venda em lote para pagamento postecipado"        
Endif

Return cMotivo