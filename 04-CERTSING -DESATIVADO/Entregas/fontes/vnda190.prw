#Include 'Protheus.ch'

/*/{Protheus.doc} VNDA190
Rotina personalizada para gerar o faturamento automatico
@author Totvs SM - David
@since 20/07/2011\l
@version P11
/*/
User Function VNDA190( cGtId , aParamFun )
Local aArea			:= GetArea()
Local nQtdLib 		:= 0
Local nQtdVen		:= 0
Local cMensagem		:= ""
Local cCategoSFW	:= GetNewPar("MV_GARSFT", "2")
Local cCategoHRD	:= GetNewPar("MV_GARHRD", "1")
Local cQueryHrd		:= ""
Local cQuerySfw		:= ""
Local cNotaHrd		:= ""
Local cNotaSfw		:= ""
Local nRecSF2Sfw	:= 0
Local nRecSF2Hrd	:= 0
Local aRetTrans		:= {}
Local aRetEspelho	:= {}
Local nTime			:= 0
Local cRandom		:= ""
Local nWait			:= 0
Local nRecC6		:= 0
Local lRet			:= .T.
Local cPosto		:= ""
Local cCliente		:= ""
Local cLojaCli		:= ""
Local cCorpo		:= ""
Local lLog          := .F.
Local cNpSite		:= ""
Local cMsgH			:= ""
Local cTime			:= StrTran(Time(),":","")
Local cDate			:= StrTran(DtoC(Date()),"/","")
Local cID			:= cDate + cTime
Local cXnpSite		:= ""
Local cPrefix		:= GetNewPar("MV_XPREFHD", "VDI")
Local cNaturez		:= GetNewPar("MV_XNATCLI", "FT010010")
Local cTipPr		:= GetNewPar("MV_XTIPPRO", "NCC")
Local cNfHrdLog		:= ""
Local cNfSfwLog		:= ""
Local cBcoCnab		:= ""
Local cAgenCnab		:= GetNewPar("MV_XAGCNB", "00000")
Local cCtaCnab		:= ""
Local cOperNPF		:= GetNewPar("MV_XOPENPF", "61,62")
Local nSlp			:= 0

Local cPedido		:= nil
Local nIdJob		:= nil
Local lFat			:= nil
Local cNsNum		:= nil
Local lServ			:= nil
Local lProd			:= nil
Local nQtdFat		:= nil
Local cOpVen		:= nil
Local cOpEnt		:= nil
Local cOpSer		:= nil
Local cPedLog		:= nil
Local dCredCnab		:= nil
Local lRecPgto		:= nil
Local lGerTitRecb	:= nil
Local cTipTitRecb 	:= nil
Local lEnt			:= nil
Local bVldCtd		:= {|a,b,c| IIf( Len(a) >= b .and. a[b] <> nil .and. iif(Valtype(a[b]) == "L" , .T.  , !Empty(a[b]) )  , a[b] , c ) }
Local lDeneg 		:= .F.
Local lFatFil		:= .F.
Local cEmpOld		:= ""
Local cFilOld		:= ""
Local cPedGarIt		:= ""
Local nRecSF2 		:= 0 
Local aRecSF2Hrd	:= {}

Local lMV_FAT 	:= IIF( Empty( GetMv('MV_190FAT' ) ), .T., !( Date() > GetMv('MV_190FAT' ) ) )
Local lMV_SERV 	:= IIF( Empty( GetMv('MV_190SERV') ), .T., !( Date() > GetMv('MV_190SERV') ) )
Local lMV_PROD	:= IIF( Empty( GetMv('MV_190PROD') ), .T., !( Date() > GetMv('MV_190PROD') ) )
Local lMV_ENT	:= IIF( Empty( GetMv('MV_190ENT' ) ), .T., !( Date() > GetMv('MV_190ENT' ) ) )
Local lMV_REC	:= IIF( Empty( GetMv('MV_190REC' ) ), .T., !( Date() > GetMv('MV_190REC' ) ) )

Local lGeraVDI	:= GetNewPar("MV_GERAVDI", .F.)

Default aParamFun	:= Array(19)
Default cGtId       := ""
 
cPedido		:= Eval(bVldCtd, aParamFun, 1	,"")
nIdJob		:= Eval(bVldCtd, aParamFun, 2	,1)
lFat		:= Eval(bVldCtd, aParamFun, 3	,.T.)
cNsNum		:= Eval(bVldCtd, aParamFun, 4	,"")
lServ		:= Eval(bVldCtd, aParamFun, 5	,.T.)
lProd		:= Eval(bVldCtd, aParamFun, 6	,.T.)
nQtdFat		:= Eval(bVldCtd, aParamFun, 7	,0)
cOpVen		:= Eval(bVldCtd, aParamFun, 8	,GetNewPar("MV_XOPEVDH", "62"))
cOpEnt		:= Eval(bVldCtd, aParamFun, 9	,GetNewPar("MV_XOPENTH", "53"))
cOpSer		:= Eval(bVldCtd, aParamFun, 10	,GetNewPar("MV_XOPEVDS", "61"))
cPedLog		:= Eval(bVldCtd, aParamFun, 11	,Alltrim(Str(nIdJob)))
dCredCnab	:= Eval(bVldCtd, aParamFun, 12	,dDataBase)
lRecPgto	:= Eval(bVldCtd, aParamFun, 13	,.F.)
lGerTitRecb	:= Eval(bVldCtd, aParamFun, 14	,.T.)
cTipTitRecb := Eval(bVldCtd, aParamFun, 15	,"")
lEnt		:= Eval(bVldCtd, aParamFun, 16	,!lFat)
nVlrTitRecb := Eval(bVldCtd, aParamFun, 17	,0)
cBcoCnab	:= Eval(bVldCtd, aParamFun, 18	,'341')
cPedGarIt	:= Eval(bVldCtd, aParamFun, 19	,'')

varinfo("Paramvnd190",aParamFun)

cNpSite		:= IIF( nIdJob == 1, cPedido, Alltrim(Str(nIdJob)) )
cXnpSite	:= IIF( nIdJob == 1, cPedido, Alltrim(Str(nIdJob)) )
cPedLog		:= IIF( nIdJob == 1, cPedido, Alltrim(Str(nIdJob)) )

IF .NOT. lMV_FAT
	Conout('[VNDA190] - MV_190FAT está FALSO, bloqueia o faturamento')
EndIF
IF .NOT. lMV_SERV
	Conout('[VNDA190] - MV_190SERV está FALSO, bloqueia o faturamento de serviço')
EndIF
IF .NOT. lMV_PROD
	Conout('[VNDA190] - MV_190PROD está FALSO, bloqueia o faturamento de produto')
EndIF
IF .NOT. lMV_ENT
	Conout('[VNDA190] - MV_190ENT está FALSO, bloqueia o faturamento de entrega')
EndIF
IF .NOT. lMV_REC
	Conout('[VNDA190] - MV_190REC está FALSO, bloqueia a geração de recibo')
EndIF

IF !Empty(cGtId)
	cId:=cGtId
Else
	cId+=cNpSite
Endif

nSlp :=  Randomize(1,1000)

Sleep(nSlp)

If LockByName("VNDA190"+cPedido+Alltrim(cPedGarIt))

	If cOpVen == "01"
		U_GTPutIN(cID,"D",cPedLog,.F.,{"U_VNDA190",cPedLog,"Inicio Faturamento delivery "+cPedido},cNpSite)
	EndIf
    
	SC5->( DbSetOrder(1) )		// C5_FILIAL+C5_NUM
	SC5->( MsSeek( xFilial("SC5")+cPedido ) )
	
	//Se a origem for Cursos, impede o faturamento até que a equipe fiscal realize a análise do pedido e mude status do campo c5_XlibFAt para "S"    
    IF SC5->C5_XORIGPV=='8' .AND. SC5->C5_XLIBFAT $ ("N|P")
       lFat:=.F.
       lEnt:=.F.
    Endif
		

	If lFat .And. lMV_FAT

		SZQ->(DbSelectArea("SZQ"))
		SZQ->(DbSetOrder(2))
		lLog := SZQ->(DbSeek(xFilial("SZQ")+Alltrim(Str(nIdJob))))
	    If !lLog .AND. !Empty(cPedLog) .and. cNpSite <> cPedLog
	    	lLog := SZQ->(DbSeek(xFilial("SZQ")+cPedLog))
	    EndIf

		If lLog
			SZQ->(Reclock("SZQ"))
			SZQ->ZQ_STATUS := "7"
			SZQ->ZQ_OCORREN := "Em Processamento "+Alltrim(GETSRVINFO()[1])+":"+Alltrim(GetPvProfString(GetPvProfString("DRIVERS","ACTIVE","TCP",GetADV97()),"PORT","0",GetADV97()))
			SZQ->ZQ_DATA := ddatabase
			SZQ->ZQ_HORA:=time()
			SZQ->(MsUnlock())
			U_GTPutIN(cID,"N",cPedLog,.F.,{"U_VNDA190",cPedLog,"Atualizando registro no controle de cnab "+cPedido},cNpSite)
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Faturamento de Hardware - NOTA FISCAL DE PRODUTO - SEFAZ                   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cQueryHrd:=	" SELECT  SC6.R_E_C_N_O_ RECHRD "
		cQueryHrd+=	" FROM    " + RetSQLName("SC6") + " SC6, " + RetSQLName("SB1") + " SB1 "
		cQueryHrd+=	" WHERE   SC6.C6_FILIAL = '" + xFilial("SC6") + "' AND "
		cQueryHrd+=	"         SC6.C6_NUM = '" + cPedido + "' AND "
		If !cOpVen $ cOperNPF
			cQueryHrd+=	"         SC6.C6_XOPER = '"+cOpVen+"' AND "
		EndIF

		If nQtdFat <= 0
			cQueryHrd+=	"         SC6.C6_NOTA = ' ' AND "
			cQueryHrd+=	"         SC6.C6_SERIE = ' ' AND "
		EndIf
		If !Empty(cPedGarIt)
			cQueryHrd+=	"         SC6.C6_PEDGAR = '"+cPedGarIt+"' AND "
		EndIf
		cQueryHrd+=	"         SC6.D_E_L_E_T_ = ' ' AND "
		cQueryHrd+=	"         SB1.B1_FILIAL = '" + xFilial("SB1") + "' AND "
		cQueryHrd+=	"         SB1.B1_COD = SC6.C6_PRODUTO AND "
		cQueryHrd+=	"         SB1.B1_CATEGO = '" + cCategoHRD + "' AND "
		cQueryHrd+=	"         SB1.D_E_L_E_T_ = ' ' "

		PLSQuery( cQueryHrd, "QRYHRD" )

		Conout("Query Hardware: " + cQueryHrd)
		
		//verifica se deve alterar a filial de faturamento
		cEmpOld := cEmpAnt
		cFilOld := cFilAnt
		lFatFil := FatFil(cPedido)
		
		If QRYHRD->(!Eof()) .and. lProd .And. lMV_PROD
			
			U_GTPutIN(cID,"N",cPedLog,.F.,{"U_VNDA190",cPedLog,"Faturamento da Venda de Produtos do Pedido "+cPedido},cNpSite)

			SC5->( DbSetOrder(1) )		// C5_FILIAL+C5_NUM
			SC5->( MsSeek( xFilial("SC5")+cPedido ) )

			DbSelectArea("SC6")
			DbSetOrder(1)

			If SC6->(DbSeek(xFilial("SC6")+cPedido))
				While !SC6->(EoF()) .and. SC6->C6_FILIAL = xFilial("SC6") .and. SC6->C6_NUM = cPedido
		        	If Empty(SC6->C6_NOTA) .and. SC6->C6_QTDEMP > 0 .AND. (Empty(cPedGarIt) .or. (!Empty(cPedGarIt) .and. Alltrim(SC6->C6_PEDGAR) == Alltrim(cPedGarIt) ) )
		        		MaAvalSC6("SC6",4,"SC5")
		        	EndIf
		        	SC6->(DbSkip())
		    	EndDo
		    EndIf

			nRecC6 := QRYHRD->RECHRD
			
			SB1->( dbSetOrder(1) )
			SB2->( dbSetOrder(1) )
			
			While QRYHRD->(!EOF())

				SC6->(DbGoto(QRYHRD->RECHRD))
				//Verifica se o pedido tem itens liberados e não faturados
				
				SB1->( dbSeek( xFilial('SB1') + SC6->C6_PRODUTO ) )
				SB2->( dbSeek( xFilial('SB2') + SB1->(B1_COD + B1_LOCPAD) ) )
				
				RecLock("SC6")
				Begin Transaction
					nQtdFat	:= iif(nQtdFat > 0, nQtdFat, SC6->C6_QTDVEN )
					nQtdLib := MaLibDoFat(SC6->(RecNo()),nQtdFat,.T.,.T.,.F.,.F.,.F.,.F.)
					nQtdVen := nQtdFat
				End Transaction
				SC6->(MsUnLock())

				Begin Transaction
					SC6->(MaLiberOk({cPedido},.F.))
				End Transaction

				QRYHRD->(dbskip())

			End

			If SC5->C5_TPCARGA <> "1"  //Vendas normais

				/*
				Parâmetro: MV_GARSHRD
				Descrição: Define a Série da Nota Fiscal de Venda e Entrega de Hardwares
				Opvs(warleson) 21/05/12
				*/

				aRet := u_FatNfCer("1",cPedido,nIdJob)

				If !aRet[1]
					cMensagem := aRet[2]
					U_GTPutOUT(cID,"N",cPedLog,{"VNDA190",{.F.,"E00012",cPedLog,cMensagem},"Faturamento da Venda de Produtos do Pedido "+cPedido},cXnpSite)

					If !Empty(cNsNum)
						cSql := " SELECT "
						cSql += "   COUNT(*) NREG "
		 				cSql += " FROM "
						cSql += "   GTOUT "
						cSql += " WHERE "
		 				cSql += "   GT_XNPSITE = '"+cXnpSite+"' AND "
						cSql += "   GT_CODMSG = 'E00012' "

						dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),"QRY",.F.,.T.)

	                    If QRY->NREG >=0 .AND. QRY->NREG <= 10
							U_VNDA300(cXnpSite,cNsNum)
						EndIf

						QRY->(DbCloseArea())
					EndIf

					If lLog
						SZQ->(Reclock("SZQ"))
						SZQ->ZQ_STATUS := "5"
						SZQ->ZQ_OCORREN := "Inconsistência Faturamento"
						SZQ->ZQ_DATA := ddatabase
						SZQ->ZQ_HORA:=time()
						SZQ->(MsUnlock())
					Endif
					
					UnLockByName("VNDA190"+cPedido+Alltrim(cPedGarIt))
					Return({.F.,cMensagem})
				EndIf

				// Reposiciono no pedido que acabou de ser faturado para pegar o numero da nota
				DbSelectArea("SC6")
				DbSetOrder(1)
				SC6->(DbGoTo(nRecC6))

				If lLog .AND. !Empty(Alltrim(SC6->C6_SERIE+SC6->C6_NOTA))
					SZQ->(Reclock("SZQ"))
					SZQ->ZQ_STATUS := "3"
					SZQ->ZQ_NF1 := Alltrim(SC6->C6_SERIE+SC6->C6_NOTA)
					SZQ->ZQ_OCORREN := "Faturado e NF não transmitida."
					SZQ->ZQ_DATA := ddatabase
					SZQ->ZQ_HORA:=time()
					SZQ->(MsUnlock())
				Endif

				DbSelectArea("SF2")
				DbSetOrder(1)
				If DbSeek(xFilial("SF2") + SC6->C6_NOTA + SC6->C6_SERIE)

					nRecSF2Hrd := SF2->(Recno())

					If nRecSF2Hrd > 0

						// Se chegou nota de hardware, transmite e gera espelho tb

						SF2->( DbGoto(nRecSF2Hrd) )

						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³Posiciono no novo titulo gerado pelo faturamento, e gavo nele o nosso numero e o numero do pedido gerado pelo site³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						DbSelectArea("SE1")
						DbSetOrder(1)	//E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
						If MsSeek(xFilial("SE1") + SF2->F2_PREFIXO + SF2->F2_DUPL)
							RecLock("SE1", .F.)
								Replace SE1->E1_NUMBCO	With cNsNum
								Replace SE1->E1_XNPSITE	With alltrim(Str(nIdJob))
							SE1->(MsUnLock())
						EndIf

						// Transmite a nota eletronica para o SEFAZ e aguarda a resposta da efetivacao
						aRetTrans := U_Transmitenfe(SF2->F2_DOC,SF2->F2_SERIE,cPedido)

						// 000132 - Codigo referente a dados com erro, naum adiante tentar retransmitir.
						// os demais codigos sao referentes a falhas na comunicacao.
						If aRetTrans[1]

							// Se nao transmitiu, envio para o JOB de retransmissao
							//U_RetranNFE(aRetTrans,SF2->F2_DOC,SF2->F2_SERIE)

							// TESTE - REMOVER DEPOIS...
							// Espera um minuto
							// WaitTime(60)
							// TESTE - REMOVER DEPOIS...

							nTime := Seconds()
							//Conout("ESPELHO -- Iniciando ...")

							While .T.

								// Gera o arquivo espelho da nota fiscal
								SF2->( DbGoto(nRecSF2Hrd) )

								SC6->( DbSetOrder(4) )		// C6_FILIAL+C6_NOTA+C6_SERIE
								SC6->( MsSeek( xFilial("SC6")+SF2->(F2_DOC+F2_SERIE) ) )

								SC5->( DbSetOrder(1) )		// C5_FILIAL+C5_NUM
								SC5->( MsSeek( xFilial("SC5")+SC6->C6_NUM ) )

								If aRetTrans[2] == "000169"
							        lDeneg := .T.
									U_NFDENG02()


									//IMPRIME A DANFE COM A INFORMAÇÃO DE NOTA DENEGADA
									//SUBSTITUIDO A CHAMADA U_NFDENG03(aRetTrans,@cRandom)
									aRetEspelho := U_GARR010(aRetTrans,@cRandom, lDeneg)

								else
	                                lDeneg := .F.
									aRetEspelho := U_GARR010(aRetTrans,@cRandom)

								EndIf

								If Len(aRetEspelho) > 0 .AND. aRetEspelho[1]

									If aRetTrans[1] .AND. (!SF2->F2_FIMP $ "D")
										SF2->( DbGoto(nRecSF2Hrd) )
										SF2->( RecLock("SF2",.F.) )
										If lDeneg
											SF2->F2_FIMP := "D"
										Else
											SF2->F2_FIMP := "S"
										EndIf
										SF2->( MsUnLock() )
									EndIf

									// Enviou / Gerou certinho ? Pode sair
									U_VNDA320("ESPELHO -- saindo 001 - gerou o espelho : "+str(Seconds()-nTime))
									Exit
								Else
									//U_VNDA320("ESPELHO -- Tentou gerar o espelho e falhou : "+str(Seconds()-nTime))
								Endif

								If Len(aRetEspelho) > 1 .AND. aRetEspelho[2] == "000134"
									// Ocorrencia 000134, pode sair
									// ( Impressao fora de job , uso com remote por exemplo )
									U_VNDA320("ESPELHO -- saindo 002 - Impressao fora de job , uso com remote por exemplo : "+str(Seconds()-nTime))
									Exit
								Endif

								If !aRetTrans[1]
									// Se nao transmitiu nao adiante insistir na impressao do PDF, entao pode sair
									U_VNDA320("ESPELHO -- saindo 003 - nao transmitiu para o SEFAZ : "+str(Seconds()-nTime))
									Exit
								Endif

								// Verifica quanto tempo esta tentando enviar ...
								// Se passou da 00:00, recalcula tempo
								nWait := Seconds()-nTime
								If nWait < 0
									nWait += 86400
								Endif

								If nWait > GetNewPar("MV_TIMESP", 120 )
									// Passou de 2 minutos tentando ? Desiste !
									U_VNDA320("ESPELHO -- saindo 004 - time out : "+str(Seconds()-nTime))
									EXIT
								Endif

								// Espera um pouco ( 5 segundos ) para tentar novamente

								Sleep(5000)
								//U_VNDA320("ESPELHO -- aguardando 5 segundos... : "+str(Seconds()-nTime))

							EndDo
							//U_VNDA320("ESPELHO -- fora do loop  : "+str(Seconds()-nTime))

							If Len(aRetEspelho) > 0 .AND. aRetEspelho[1]
							
								cNotaHrd := aRetEspelho[4]
								If lLog
									SZQ->(Reclock("SZQ"))
									SZQ->ZQ_STATUS  := "3"
									SZQ->ZQ_NF1     :=  SF2->F2_SERIE+SF2->F2_DOC
									SZQ->ZQ_OCORREN := "NF Transmitida com sucesso."
									SZQ->ZQ_DATA    := ddatabase
									SZQ->ZQ_HORA    := time()
									SZQ->(MsUnlock())
								Endif
							Else
								lRet := .f.
			    				cMensagem += "Inconsistência ao Gerar Danfe de Produto "
			    				If lLog
									SZQ->(Reclock("SZQ"))
									SZQ->ZQ_STATUS := "5"
									SZQ->ZQ_OCORREN := "Inconsistencia ao Gerar Danfe de Produto"
									SZQ->ZQ_DATA := ddatabase
									SZQ->ZQ_HORA:=time()
									SZQ->(MsUnlock())
								Endif

							Endif
							U_GTPutOUT(cID,"N",cPedLog,{"NF_PRODUTO_VENDA",aRetEspelho,"Faturamento da Venda de Produtos do Pedido "+cPedido},cNpSite)
						Else
							U_GTPutOUT(cID,"N",cPedLog,{"NF_PRODUTO_VENDA",aRetTrans,"Faturamento da Venda de Produtos do Pedido "+cPedido},cNpSite)
						Endif
					Endif
			    Else
			    	lRet := .f.
			    	cMensagem += "Inconsistência ao Gerar Nota de Produto do Pedido "+cPedido+". Necessário Realizar Processo manualmente. "
			    	U_GTPutOUT(cID,"N",cPedLog,{"NF_PRODUTO_VENDA",{.F.,"E00009",cPedLog,cMensagem}},cNpSite)
			    	If lLog
						SZQ->(Reclock("SZQ"))
						SZQ->ZQ_STATUS := "5"
						SZQ->ZQ_OCORREN := "Inconsistencia ao Gerar Nota de Produto"
						SZQ->ZQ_DATA := ddatabase
						SZQ->ZQ_HORA:=time()
						SZQ->(MsUnlock())
					Endif
			    EndIf
			Else  //Delivery

				If lLog
					SZQ->(Reclock("SZQ"))
					SZQ->ZQ_STATUS  := '5'
					SZQ->ZQ_OCORREN := "Não faturado, depende de montagem de carga."
					SZQ->ZQ_DATA := ddatabase
					SZQ->ZQ_HORA:=time()
					SZQ->(MsUnlock())
				Endif
				DbSelectArea('SA1')
				DbSetOrder(1)	//A1_FILIAL+A1_CGC
				If DbSeek(xFilial('SA1') + SC5->(C5_CLIENTE+C5_LOJACLI))
					cCorpo	:= "Prezado " + ALLTRIM(SA1->A1_NOME) + ", " + CRLF + CRLF
					cCorpo	+= "Esta é uma mensagem automática, referente à confirmação da identificação do pagamento da compra realizada no Portal de Vendas Certisign" + CRLF + CRLF
					cCorpo	+= "Os dados do Pedido são: " + CRLF
					cCorpo	+= "Código - " + SC5->C5_XNPSITE + CRLF
					cCorpo	+= "Data da Compra -  " + DtoC(SC5->C5_EMISSAO) + CRLF + CRLF + CRLF + CRLF
					cCorpo	+= "Com isso, seu Pedido foi encaminhado para área de logística, para entrega no endereço informado." + CRLF + CRLF
					cCorpo	+= "Agradecemos sua atenção," + CRLF
					cCorpo	+= "Equipe Certisign" + CRLF
					// Envio e-mail para o contato com a alteração dos dados cadastrais
					U_VNDA290(cCorpo, SA1->A1_EMAIL, "Confirmação Pagamento - Portal de Vendas Certisign")
	        	EndIf

	        	SE1->(DbSetOrder(2))
                //Gera NCC no processamento de CNAB de Delivery
	        	If lGeraVDI .And. SC5->C5_TIPMOV == "1" .and. !SE1->(DbSeek(xFilial("SE1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI+PadR(cPrefix,TamSX3("E1_PREFIXO")[1])+PadR("",TamSX3("E1_PARCELA")[1])+cTipPr))
					nOpcRotina 		:= 3
					cCodCondPagto	:= SC5->C5_CONDPAG
					nValor			:= SC5->C5_TOTPED+SC5->C5_FRETE
					aSE1			:= {	cPrefix,;
											SC5->C5_NUM,;
											cTipPr,;
											cNaturez,;
											SC5->C5_CLIENTE,;
											SC5->C5_LOJACLI,;
											dCredCnab,;
											SC5->C5_NUM,;
											SC5->C5_XNPSITE,;
											SC5->C5_XNPSITE,;
											SC5->C5_TIPMOV,;
											SC5->C5_CHVBPAG,;
											SC5->C5_NUM}
					lFIE			:= .T.
					lSE5			:= .T.
					dDataCredito	:= dCredCnab

					//identifica banco de controle de processamento de cnab
					If !Empty(SC5->C5_XLINDIG)
						SA6->(DbSetOrder(1))
						cBcoCnab	:= Left(Alltrim(SC5->C5_XLINDIG),3)
						If SA6->(DbSeek(xFilial("SA6")+cBcoCnab+cAgenCnab))
							cCtaCnab	:= SA6->A6_NUMCON
						Else
							cCtaCnab	:= ""
						EndIf
					Else
						cBcoCnab	:= ""
						cAgenCnab	:= ""
						cCtaCnab	:= ""
					EndIf
					aBanco			:= {cBcoCnab,cAgenCnab,cCtaCnab}
					cHistSE5		:= "Identificação Pagamento Pedido "+cPedido

					lRet := U_CSFA500( nOpcRotina, cCodCondPagto, nValor ,aSE1, lFIE, lSE5, dDataCredito, aBanco, cHistSE5, cID )
					SE5->(MSUNLOCK())
			  	   	SE1->(MSUNLOCK())
			  	   	SA1->(MSUNLOCK())             

	        	EndIf

	        	U_GTPutOUT(cID,"D",cPedLog,{"NF_PRODUTO_VENDA",{.T.,"M00001",cPedLog,"Pedido com Entega em domicilio, a NF deve ser gerada pela Rotina de Cargas "}},cNpSite)

	        	lRet := .T.

			EndIF
		
		Elseif lProd .And. lMV_PROD //Força transmissçao e geração do PDF da DANFE

			cMsgH := "Não foram encontrados itens de Venda de Hardware ou itens faturados anteriormente para o Pedido "+cPedido+". Tentativa e transmissao da nota."
			U_GTPutOUT(cID,"N",cPedLog,{"VNDA190",{.T.,"M00001",cPedLog,cMsgH}},cXnpSite)

			SC5->( DbSetOrder(1) )		// C5_FILIAL+C5_NUM
			SC5->( MsSeek( xFilial("SC5")+cPedido) )

			SC6->( DbSetOrder(1) )
			SC6->( MsSeek( xFilial("SC6")+cPedido) )

			nRecSF2Hrd:=0

			While SC6->(!Eof()) .And. SC6->C6_FILIAL+SC6->C6_NUM==xFilial("SC6")+cPedido

				If SC6->C6_XOPER == cOpVen .And. !Empty(SC6->C6_NOTA) .And. Empty(SC6->C6_XNFHRD)//.AND. (Empty(cPedGarIt) .or. (!Empty(cPedGarIt) .and. Alltrim(SC6->C6_PEDGAR) == Alltrim(cPedGarIt) ) )
					cNfHrdLog := Alltrim(SC6->C6_SERIE+SC6->C6_NOTA)
					DbSelectArea("SF2")
					DbSetOrder(1)
					If DbSeek(xFilial("SF2") + SC6->C6_NOTA + SC6->C6_SERIE)
						aAdd(aRecSF2Hrd, SF2->(Recno()))
						//nRecSF2Hrd:=Recno()
						//Exit
					Endif
				Endif
				SC6->(DbSkip())
			EndDo

			//If nRecSF2Hrd > 0 .and. Empty(SC5->C5_XNFHRD)
			If Len(aRecSF2Hrd) > 0

				For nRecSF2 := 1 To Len(aRecSF2Hrd)

					// Se chegou nota de hardware, transmite e gera espelho tb
					
					nRecSF2Hrd := aRecSF2Hrd[nRecSF2]
	
					SF2->( DbGoto(nRecSF2Hrd) )
	
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Posiciono no novo titulo gerado pelo faturamento, e gavo nele o nosso numero e o numero do pedido gerado pelo site³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					DbSelectArea("SE1")
					DbSetOrder(1)	//E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
					If MsSeek(xFilial("SE1") + SF2->F2_PREFIXO + SF2->F2_DUPL)
						RecLock("SE1", .F.)
						Replace SE1->E1_NUMBCO	With cNsNum
						Replace SE1->E1_XNPSITE	With alltrim(Str(nIdJob))
						SE1->(MsUnLock())
					EndIf
	
					// Transmite a nota eletronica para o SEFAZ e aguarda a resposta da efetivacao
					aRetTrans := U_Transmitenfe(SF2->F2_DOC,SF2->F2_SERIE,cPedido)
	
					// 000132 - Codigo referente a dados com erro, naum adiante tentar retransmitir.
					// os demais codigos sao referentes a falhas na comunicacao.
					If aRetTrans[1]
	
						// Se nao transmitiu, envio para o JOB de retransmissao
						//U_RetranNFE(aRetTrans,SF2->F2_DOC,SF2->F2_SERIE)
	
						// TESTE - REMOVER DEPOIS...
						// Espera um minuto
						// WaitTime(60)
						// TESTE - REMOVER DEPOIS...
	
						nTime := Seconds()
						//Conout("ESPELHO -- Iniciando ...")
	
						While .T.
	
							// Gera o arquivo espelho da nota fiscal
							SF2->( DbGoto(nRecSF2Hrd) )
	
							SC6->( DbSetOrder(4) )		// C6_FILIAL+C6_NOTA+C6_SERIE
							SC6->( MsSeek( xFilial("SC6")+SF2->(F2_DOC+F2_SERIE) ) )
	
							SC5->( DbSetOrder(1) )		// C5_FILIAL+C5_NUM
							SC5->( MsSeek( xFilial("SC5")+SC6->C6_NUM ) )
	
							If aRetTrans[2] == "000169"
								lDeneg := .T.
								U_NFDENG02()
	
								//IMPRIME A DANFE COM A INFORMAÇÃO DE NOTA DENEGADA
								//SUBSTITUIDO A CHAMADA U_NFDENG03(aRetTrans,@cRandom)
								aRetEspelho := U_GARR010(aRetTrans,@cRandom, lDeneg)
	
							else
								lDeneg := .F.
								aRetEspelho := U_GARR010(aRetTrans,@cRandom)
	
							EndIf
	
							If Len(aRetEspelho) > 0 .AND. aRetEspelho[1]
	
								If aRetTrans[1] .AND. (!SF2->F2_FIMP $ "D")
									SF2->( DbGoto(nRecSF2Hrd) )
									SF2->( RecLock("SF2",.F.) )
									If lDeneg
										SF2->F2_FIMP := "D"
									Else
										SF2->F2_FIMP := "S"
									EndIf
									SF2->( MsUnLock() )
								EndIf
	
								// Enviou / Gerou certinho ? Pode sair
								U_VNDA320("ESPELHO -- saindo 001 - gerou o espelho : "+str(Seconds()-nTime))
								Exit
							Else
								//U_VNDA320("ESPELHO -- Tentou gerar o espelho e falhou : "+str(Seconds()-nTime))
							Endif
	
							If Len(aRetEspelho) > 1 .AND. aRetEspelho[2] == "000134"
								// Ocorrencia 000134, pode sair
								// ( Impressao fora de job , uso com remote por exemplo )
								U_VNDA320("ESPELHO -- saindo 002 - Impressao fora de job , uso com remote por exemplo : "+str(Seconds()-nTime))
								Exit
							Endif
	
							If !aRetTrans[1]
								// Se nao transmitiu nao adiante insistir na impressao do PDF, entao pode sair
								U_VNDA320("ESPELHO -- saindo 003 - nao transmitiu para o SEFAZ : "+str(Seconds()-nTime))
								Exit
							Endif
	
							// Verifica quanto tempo esta tentando enviar ...
							// Se passou da 00:00, recalcula tempo
							nWait := Seconds()-nTime
							If nWait < 0
								nWait += 86400
							Endif
	
							If nWait > 60
								// Passou de 2 minutos tentando ? Desiste !
								U_VNDA320("ESPELHO -- saindo 004 - time out : "+str(Seconds()-nTime))
								EXIT
							Endif
	
							// Espera um pouco ( 5 segundos ) para tentar novamente
	
							Sleep(5000)
							//U_VNDA320("ESPELHO -- aguardando 5 segundos... : "+str(Seconds()-nTime))
	
						EndDo
						//U_VNDA320("ESPELHO -- fora do loop  : "+str(Seconds()-nTime))
	
						If Len(aRetEspelho) > 0 .AND. aRetEspelho[1]
							// Se gerou espelho, recupera URI do espelho
							cNotaHrd := aRetEspelho[4]
							If lLog
								SZQ->(Reclock("SZQ"))
								SZQ->ZQ_STATUS := "3"
								SZQ->ZQ_NF1 := SF2->F2_SERIE+SF2->F2_DOC
								SZQ->ZQ_OCORREN := "NF Transmitida com sucesso."
								SZQ->ZQ_DATA := ddatabase
								SZQ->ZQ_HORA:=time()
								SZQ->(MsUnlock())
							Endif
						Else
							lRet := .f.
							cMensagem += "Inconsistência ao Gerar Danfe de Produto "
							If lLog
								SZQ->(Reclock("SZQ"))
								SZQ->ZQ_STATUS := "5"
								SZQ->ZQ_OCORREN := "Inconsistencia ao Gerar Danfe de Produto"
								SZQ->ZQ_DATA := ddatabase
								SZQ->ZQ_HORA:=time()
								SZQ->(MsUnlock())
							Endif
	
						Endif
						U_GTPutOUT(cID,"N",cPedLog,{"NF_PRODUTO_VENDA",aRetEspelho,"Faturamento da Venda de Produtos do Pedido "+cPedido},cNpSite)
					Else
						U_GTPutOUT(cID,"N",cPedLog,{"NF_PRODUTO_VENDA",aRetTrans,"Faturamento da Venda de Produtos do Pedido "+cPedido},cNpSite)
					Endif
				Next
				
			ElseIf nRecSF2Hrd > 0
				If lLog
					SZQ->(Reclock("SZQ"))
					If !Empty(cNfHrdLog)
						SZQ->ZQ_STATUS := "3"
						SZQ->ZQ_NF1 := cNfHrdLog
						SZQ->ZQ_OCORREN := "Faturado e NF transmitida."
					Else
						SZQ->ZQ_STATUS := "5"
						SZQ->ZQ_OCORREN := "Inconsistencia ao Gerar Nota de Produto"
					EndIf
					SZQ->ZQ_DATA := ddatabase
					SZQ->ZQ_HORA:=time()
					SZQ->(MsUnlock())
				Endif
			Else
				U_GTPutOUT(cID,"N",cPedLog,{"VNDA190",{.F.,"E00012",cPedLog,"InconsistÃªncia no faturamento do pedido "+cPedido}},cXnpSite)
			EndIf
		EndIf
		
		//retorna para empresa e filial antes da aletação
		If lFatFil
			FatFil(nil,cFilOld)
		Endif
		
		// Fecha query de faturamento de hardware
		DbSelectArea("QRYHRD")
		DbCloseArea()

		//Conout("Nota Fiscal Hardware: " + cNotaHrd)

		//O espelho é gravado pela rotina GARR010.
		//Na SC5 permanecera gravado o espelho do primeiro item, por legado.
		If !Empty(cNotaHrd)
		
			//If Empty(cPedGarIt)
			SC5->( DbSetOrder(1) )		// C5_FILIAL+C5_NUM

			SC5->( MsSeek( xFilial("SC5")+cPedido ) )
			RecLock("SC5", .F.)
				Replace SC5->C5_XNFHRD With cNotaHrd
				Replace SC5->C5_XFLAGEN With Space(TamSX3("C5_XFLAGEN")[1])
			SC5->(MsUnLock())
		EndIf
			/*Else
				DbSelectArea("SC6")
				DbOrderNickName("NUMPEDGAR")
							
				If SC6->(DbSeeK( xFilial("SC6")+cPedGarIt ) )
					While !SC6->(eof()) .and. SC6->C6_FILIAL+Alltrim(SC6->C6_PEDGAR) == xFilial("SC6")+Alltrim(cPedGarIt)
						RecLock("SC6", .F.)
							Replace SC6->C6_XNFHRD With cNotaHrd
							Replace SC6->C6_XFLAGEN With Space(TamSX3("C6_XFLAGEN")[1])
						SC6->(MsUnLock())
						SC6->(DbSkip())
					End
				EndIf
			Endif
		EndIf*/

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Faturamento de Software - NOTA FISCAL DE SERVICO - PREFEITURA DE SAO PAULO ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cQuerySfw:=	" SELECT  SC6.R_E_C_N_O_ RECSFW "
		cQuerySfw+=	" FROM    " + RetSQLName("SC6") + " SC6, " + RetSQLName("SB1") + " SB1 "
		cQuerySfw+=	" WHERE   SC6.C6_FILIAL = '" + xFilial("SC6") + "' AND "
		cQuerySfw+=	"         SC6.C6_NUM = '" + cPedido + "' AND "
		cQuerySfw+=	"         SC6.C6_XOPER = '"+cOpSer+"' AND "
		If nQtdFat <= 0
			cQuerySfw+=	"         SC6.C6_NOTA = ' ' AND "
			cQuerySfw+=	"         SC6.C6_SERIE = ' ' AND "
		EndIf
		If !Empty(cPedGarIt)
			cQuerySfw+=	"         SC6.C6_PEDGAR = '"+cPedGarIt+"' AND "
		EndIf
		cQuerySfw+=	"         SC6.D_E_L_E_T_ = ' ' AND "
		cQuerySfw+=	"         SB1.B1_FILIAL = '" + xFilial("SB1") + "' AND "
		cQuerySfw+=	"         SB1.B1_COD = SC6.C6_PRODUTO AND "
		cQuerySfw+=	"         SB1.B1_CATEGO = '" + cCategoSFW + "' AND "
		cQuerySfw+=	"         SB1.D_E_L_E_T_ = ' ' "

		PLSQuery( cQuerySfw, "QRYSFW" )

		Conout("Query Software: " + cQuerySfw)
		
		If QRYSFW->(!Eof()) .and. lServ .And. lMV_SERV
			U_GTPutIN(cID,"S",cPedLog,.F.,{"U_VNDA190",cPedLog,"Faturamento dos Serviços do Pedido "+cPedido},cNpSite)

			DbSelectArea("SC6")
			DbSetOrder(1)

			SC5->( DbSetOrder(1) )		// C5_FILIAL+C5_NUM
			SC5->( MsSeek( xFilial("SC5")+cPedido ) )

			If SC6->(DbSeek(xFilial("SC6")+cPedido))
				While !SC6->(EoF()) .and. SC6->C6_FILIAL = xFilial("SC6") .and. SC6->C6_NUM = cPedido
		        	If Empty(SC6->C6_NOTA) .and. SC6->C6_QTDEMP > 0 .AND. (Empty(cPedGarIt) .or. (!Empty(cPedGarIt) .and. Alltrim(SC6->C6_PEDGAR) == Alltrim(cPedGarIt) ) )
		        		MaAvalSC6("SC6",4,"SC5")
		        	EndIf
		        	SC6->(DbSkip())
		    	EndDo
		    EndIf

			nRecC6 := QRYSFW->RECSFW
			
			SB1->( dbSetOrder(1) )
			SB2->( dbSetOrder(1) )
			
			While QRYSFW->(!EOF())

				SC6->(DbGoTo(QRYSFW->RECSFW))
				
				SB1->( dbSeek( xFilial('SB1') + SC6->C6_PRODUTO ) )
				SB2->( dbSeek( xFilial('SB2') + SB1->(B1_COD + B1_LOCPAD) ) )
				
				RecLock("SC6")
				Begin Transaction
					nQtdFat	:= iif(nQtdFat > 0, nQtdFat, SC6->C6_QTDVEN )
					nQtdLib := MaLibDoFat(SC6->(RecNo()),nQtdFat,.T.,.T.,.F.,.F.,.F.,.F.)
					nQtdVen := nQtdFat
				End Transaction
				SC6->(MsUnLock())

				Begin Transaction
					SC6->(MaLiberOk({cPedido},.F.))
				End Transaction

				QRYSFW->(dbskip())

			End

			SC5->( DbSetOrder(1) )		// C5_FILIAL+C5_NUM
			SC5->( MsSeek( xFilial("SC5")+cPedido ) )

			aRet := u_FatNfCer("2",cPedido,nIdJob)

			If !aRet[1]
				cMensagem := aRet[2]
				U_GTPutOUT(cID,"S",cPedLog,{"VNDA190",{.F.,"E00012",cPedLog,cMensagem},"Faturamento da Venda de Serviço do Pedido "+cPedido},cXnpSite)

				If !Empty(cNsNum)
					cSql := " SELECT "
					cSql += "   COUNT(*) NREG "
	 				cSql += " FROM "
					cSql += "   GTOUT "
					cSql += " WHERE "
	 				cSql += "   GT_XNPSITE = '"+cXnpSite+"' AND "
					cSql += "   GT_CODMSG = 'E00012' "

					dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),"QRY",.F.,.T.)

	                    If QRY->NREG >=0 .AND. QRY->NREG <= 10
						U_VNDA300(cXnpSite,cNsNum)
					EndIf

					QRY->(DbCloseArea())
				EndIf

				If lLog
					SZQ->(Reclock("SZQ"))
					SZQ->ZQ_STATUS := "5"
					SZQ->ZQ_OCORREN := "Inconsistência Faturamento"
					SZQ->ZQ_DATA := ddatabase
					SZQ->ZQ_HORA:=time()
					SZQ->(MsUnlock())
				Endif
				
				UnLockByName("VNDA190"+cPedido+Alltrim(cPedGarIt))
				Return({.F.,cMensagem})
			EndIf

			// Reposiciono no pedido que acabou de ser faturado para pegar o numero da nota
			DbSelectArea("SC6")
			DbSetOrder(1)
			SC6->(DbGoTo(nRecC6))
			If lLog .AND. !Empty(Alltrim(SC6->C6_SERIE+SC6->C6_NOTA))
				SZQ->(Reclock("SZQ"))
				SZQ->ZQ_STATUS := "3"
				SZQ->ZQ_NF2 := Alltrim(SC6->C6_SERIE+SC6->C6_NOTA)
				SZQ->ZQ_OCORREN := "Faturado e NF não transmitida."
				SZQ->ZQ_DATA := ddatabase
				SZQ->ZQ_HORA:=time()
				SZQ->(MsUnlock())
			Endif

			DbSelectArea("SF2")
			DbSetOrder(1)
			If DbSeek(xFilial("SF2") + SC6->C6_NOTA + SC6->C6_SERIE)

				nRecSF2Sfw := SF2->(Recno())

				If nRecSF2Sfw > 0

					// Se chegou uma nota de serviÃ§o executa a transmissao para a PMSP

					SF2->( DbGoto(nRecSF2Sfw) )

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Posiciono no novo titulo gerado pelo faturamento, e gavo nele o nosso numero e o numero do pedido gerado pelo site³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					DbSelectArea("SE1")
					DbSetOrder(1)	//E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
					If MsSeek(xFilial("SE1") + SF2->F2_PREFIXO + SF2->F2_DUPL)
						RecLock("SE1", .F.)
							Replace SE1->E1_NUMBCO	With cNsNum
							Replace SE1->E1_XNPSITE	With alltrim(Str(nIdJob))
						SE1->(MsUnLock())
					EndIf

					// A Totvs nao disponibilizou a transmição da RPS para a prefeitura via WEBSERVICES.
					// Esta funcao sempre vai retornar TRUE ateh que a funcao da tranmissão seja criada
					aRetTraPMSP := U_TransPMSP(SF2->F2_DOC,SF2->F2_SERIE,alltrim(Str(nIdJob)))

					If !aRetTraPMSP[1]
						// Se nao transmitiu, envio para o JOB de retransmissao
						U_RetranPMSP(aRetTraPMSP,SF2->F2_DOC,SF2->F2_SERIE,alltrim(Str(nIdJob)))
					Endif

					// Gera o arquivo espelho da nota de servico
					aRetEspPMSP := U_GARR020(aRetTraPMSP)

					If ValType(aRetEspPMSP)== "A" .and. aRetEspPMSP[1]
						// Se o espelho foi gerado, recupera URI do espelho
						cNotaSfw := aRetEspPMSP[4]
						If lLog
							SZQ->(Reclock("SZQ"))
							SZQ->ZQ_STATUS := "3"
 //							SZQ->ZQ_NF2 := Alltrim(cNotaSfw)
							SZQ->ZQ_OCORREN := "NF transmitida com sucesso."
							SZQ->ZQ_DATA := ddatabase
							SZQ->ZQ_HORA:=time()
							SZQ->(MsUnlock())
						Endif
						U_GTPutOUT(cID,"S",cPedLog,{"NF_SERVICO_VENDA",aRetEspPMSP,"Faturamento da Venda de Serviço do Pedido "+cPedido},cNpSite)
					Else
						lRet := .f.
						cMensagem += "Inconsistência ao Gerar RPS de Serviço "
						If lLog
							SZQ->(Reclock("SZQ"))
							SZQ->ZQ_STATUS := "5"
							SZQ->ZQ_OCORREN := "Inconsistencia ao gerar RPS de Servico"
							SZQ->ZQ_DATA := ddatabase
							SZQ->ZQ_HORA:=time()
							SZQ->(MsUnlock())
						Endif
						U_GTPutOUT(cID,"S",cPedLog,{"NF_SERVICO_VENDA",aRetEspPMSP,"Faturamento da Venda de Serviço do Pedido "+cPedido},cNpSite)
					Endif

				Endif
			Else
				lRet := .F.
				cMensagem += "Inconsistência ao Gerar Nota de Serviço do Pedido "+cPedido+". Necessário Realizar Processo manualmente. "
		    	U_GTPutOUT(cID,"S",cPedLog,{"NF_SERVICO_VENDA",{.F.,"E00010",cPedLog,cMensagem}},cNpSite)
				If lLog
					SZQ->(Reclock("SZQ"))
					SZQ->ZQ_STATUS := "5"
					SZQ->ZQ_OCORREN := "Inconsistencia ao gerar Nota de Servico"
					SZQ->ZQ_DATA := ddatabase
					SZQ->ZQ_HORA:=time()
					SZQ->(MsUnlock())
				Endif
		    EndIf
		ElseIf lServ .And. lMV_SERV
			SC5->( DbSetOrder(1) )		// C5_FILIAL+C5_NUM
			SC5->( MsSeek( xFilial("SC5")+cPedido) )

			SC6->( DbSetOrder(1) )
			SC6->( MsSeek( xFilial("SC6")+cPedido) )

			nRecSF2Sfw := 0

			While SC6->(!Eof()) .And. SC6->C6_FILIAL+SC6->C6_NUM==xFilial("SC6")+cPedido

				If SC6->C6_XOPER == cOpSer .And. !Empty(SC6->C6_NOTA) .AND. (Empty(cPedGarIt) .or. (!Empty(cPedGarIt) .and. Alltrim(SC6->C6_PEDGAR) == Alltrim(cPedGarIt) ) )
					cNfSfwLog := Alltrim(SC6->C6_SERIE+SC6->C6_NOTA)
					DbSelectArea("SF2")
					DbSetOrder(1)
					If DbSeek(xFilial("SF2") + SC6->C6_NOTA + SC6->C6_SERIE)
						nRecSF2Sfw:=Recno()
						Exit
					Endif
				Endif
				SC6->(DbSkip())
			EndDo

			If nRecSF2Sfw > 0 .and. Empty(SC5->C5_XNFSFW)

				// Se chegou uma nota de serviço executa a transmissao para a PMSP

				SF2->( DbGoto(nRecSF2Sfw) )

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Posiciono no novo titulo gerado pelo faturamento, e gavo nele o nosso numero e o numero do pedido gerado pelo site³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				DbSelectArea("SE1")
				DbSetOrder(1)	//E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
				If MsSeek(xFilial("SE1") + SF2->F2_PREFIXO + SF2->F2_DUPL)
					RecLock("SE1", .F.)
						Replace SE1->E1_NUMBCO	With cNsNum
						Replace SE1->E1_XNPSITE	With alltrim(Str(nIdJob))
					SE1->(MsUnLock())
				EndIf

				SC6->( DbSetOrder(4) )		// C6_FILIAL+C6_NOTA+C6_SERIE
				SC6->( MsSeek( xFilial("SC6")+SF2->(F2_DOC+F2_SERIE) ) )

				// A Totvs nao disponibilizou a transmição da RPS para a prefeitura via WEBSERVICES.
				// Esta funcao sempre vai retornar TRUE ateh que a funcao da tranmissão seja criada
				aRetTraPMSP := U_TransPMSP(SF2->F2_DOC,SF2->F2_SERIE,alltrim(Str(nIdJob)))

				If !aRetTraPMSP[1]
					// Se nao transmitiu, envio para o JOB de retransmissao
					U_RetranPMSP(aRetTraPMSP,SF2->F2_DOC,SF2->F2_SERIE,alltrim(Str(nIdJob)))
				Endif

				// Gera o arquivo espelho da nota de servico
				aRetEspPMSP := U_GARR020(aRetTraPMSP)

				If ValType(aRetEspPMSP)== "A" .and. aRetEspPMSP[1]
					// Se o espelho foi gerado, recupera URI do espelho
					cNotaSfw := aRetEspPMSP[4]
					If lLog
						SZQ->(Reclock("SZQ"))
						SZQ->ZQ_STATUS := "3"
						SZQ->ZQ_NF2 := cNotaSfw
						SZQ->ZQ_OCORREN := "NF transmitida com sucesso."
						SZQ->ZQ_DATA := ddatabase
						SZQ->ZQ_HORA:=time()
						SZQ->(MsUnlock())
					Endif
					U_GTPutOUT(cID,"S",cPedLog,{"NF_SERVICO_VENDA",aRetEspPMSP,"Faturamento da Venda de Serviço do Pedido "+cPedido},cNpSite)
				Else
					lRet := .f.
					cMensagem += "Inconsistência ao Gerar RPS de Serviço "
					If lLog
						SZQ->(Reclock("SZQ"))
						SZQ->ZQ_STATUS := "5"
						SZQ->ZQ_OCORREN := "Inconsistencia ao gerar RPS de Servico"
						SZQ->ZQ_DATA := ddatabase
						SZQ->ZQ_HORA:=time()
						SZQ->(MsUnlock())
					Endif
					U_GTPutOUT(cID,"S",cPedLog,{"NF_SERVICO_VENDA",aRetEspPMSP,"Faturamento da Venda de Serviço do Pedido "+cPedido},cNpSite)
				Endif
			ElseIf nRecSF2Sfw > 0
				If lLog
					SZQ->(Reclock("SZQ"))
					//SZQ->ZQ_STATUS := "5"
					If !Empty(cNfSfwLog)
						SZQ->ZQ_STATUS := "3"
						SZQ->ZQ_NF2 := cNfSfwLog
						SZQ->ZQ_OCORREN := "Faturado e NF transmitida."
					Else
						SZQ->ZQ_STATUS := "5"
						SZQ->ZQ_OCORREN := "Inconsistencia ao Gerar Nota de Servico"
					EndIf
					SZQ->ZQ_DATA := ddatabase
					SZQ->ZQ_HORA:=time()
					SZQ->(MsUnlock())
				Endif
			Endif
		EndIf

		//Conout("Nota Fiscal Software: " + cNotaSfw)

		If !Empty(cNotaSfw)
			If Empty(cPedGarIt)
				SC5->( DbSetOrder(1) )		// C5_FILIAL+C5_NUM
				SC5->( MsSeek( xFilial("SC5")+cPedido ) )
				RecLock("SC5", .F.)
					Replace SC5->C5_XNFSFW With cNotaSfw
					Replace SC5->C5_XFLAGEN With Space(TamSX3("C5_XFLAGEN")[1])
				SC5->(MsUnLock())
			Else
				DbSelectArea("SC6")
				DbOrderNickName("NUMPEDGAR")
							
				If SC6->(DbSeeK( xFilial("SC6")+cPedGarIt ) )
					While !SC6->(eof()) .and. SC6->C6_FILIAL+Alltrim(SC6->C6_PEDGAR) == xFilial("SC6")+Alltrim(cPedGarIt)
						RecLock("SC6", .F.)
							Replace SC6->C6_XNFSFW With cNotaSfw
							Replace SC6->C6_XFLAGEN With Space(TamSX3("C6_XFLAGEN")[1])
						SC6->(MsUnLock())
						SC6->(DbSkip())
					End
				EndIf
			Endif
		EndIf

		// Fecha query de faturamento de software
		DbSelectArea("QRYSFW")
		DbCloseArea()

	Endif

	SC5->( DbSetOrder(1) )		// C5_FILIAL+C5_NUM
	SC5->( MsSeek( xFilial("SC5")+cPedido ) )

	//Gera Recibo de Pagamento apenas para pedidos com C5_TIPMOV diferente de 6=voucher
	If (lRecPgto .or. lGerTitRecb) .And. lMV_REC
		GerRecbPg(cPedido, cPedLog, cNpSite, nIdJob, dCredCnab, lGerTitRecb, cTipTitRecb, nVlrTitRecb, lRecPgto, cBcoCnab)
		If !Empty(SC5->C5_CHVBPAG) .and. lRecPgto
			U_VNDA481({SC5->(Recno())},nil,"Liberação de Pagamento Automatica ao Gerar Recibo de Pagamento")
		EndIf
	Endif

	//Nota Fiscal de entrega
	If lEnt .And. lMV_ENT

		DbSelectArea("SC5")
		SC5->( DbSetOrder(1) )		// C5_FILIAL+C5_NUM
		SC5->( MsSeek( xFilial("SC5") + cPedido ) )

		cPosto := SC5->C5_XPOSTO

		DbSelectArea("SZ3")
		SZ3->( DbSetOrder(4) )
		SZ3->( DbSeek(xFilial("SZ3") + cPosto) )

		cCliente := SZ3->Z3_CLIENTE
		cLojaCli := SZ3->Z3_LOJACLI

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Faturamento de Hardware - NOTA FISCAL DE PRODUTO - SEFAZ - ENTREGA         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cQueryHrd:=	" SELECT  SC6.R_E_C_N_O_ RECHRD "
		cQueryHrd+=	" FROM    " + RetSQLName("SC6") + " SC6, " + RetSQLName("SB1") + " SB1 "
		cQueryHrd+=	" WHERE   SC6.C6_FILIAL = '" + xFilial("SC6") + "' AND "
		cQueryHrd+=	"         SC6.C6_NUM = '" + cPedido + "' AND "
		cQueryHrd+=	"         SC6.C6_XOPER = '"+cOpEnt+"' AND "
		If nQtdFat <= 0
			cQueryHrd+=	"         SC6.C6_NOTA = ' ' AND "
			cQueryHrd+=	"         SC6.C6_SERIE = ' ' AND "
		EndIf
		If !Empty(cPedGarIt)
			cQueryHrd+=	"         SC6.C6_PEDGAR = '"+cPedGarIt+"' AND "
		EndIf
		cQueryHrd+=	"         SC6.D_E_L_E_T_ = ' ' AND "
		cQueryHrd+=	"         SB1.B1_FILIAL = '" + xFilial("SB1") + "' AND "
		cQueryHrd+=	"         SB1.B1_COD = SC6.C6_PRODUTO AND "
		cQueryHrd+=	"         SB1.B1_CATEGO = '" + cCategoHRD + "' AND "
		cQueryHrd+=	"         SB1.D_E_L_E_T_ = ' ' "

		PLSQuery( cQueryHrd, "QRYHRD" )

		Conout("Query Hardware: " + cQueryHrd)
		
		//verifica se deve alterar a filial de faturamento
		cEmpOld := cEmpAnt
		cFilOld := cFilAnt
		lFatFil := FatFil(cPedido)
	
		If QRYHRD->(!Eof())
	  		U_GTPutIN(cID,"E",cPedLog,.F.,{"U_VNDA190",cPedLog,"Faturamento da Entrega de Produtos do Pedido "+cPedido},cNpSite) //U_GTPutIN(cID,"E",cPedLog,.F.,{"U_VNDA190",cPedLog,"Faturamento da Venda de Produtos do Pedido "+cPedido},cNpSite)

			DbSelectArea("SC6")
			SC6->(DbSetOrder(1))

			If SC6->(DbSeek(xFilial("SC6")+cPedido))
				While !SC6->(EoF()) .and. SC6->C6_FILIAL = xFilial("SC6") .and. SC6->C6_NUM = cPedido
		        	If Empty(SC6->C6_NOTA) .and. SC6->C6_QTDEMP > 0 .AND. (Empty(cPedGarIt) .or. (!Empty(cPedGarIt) .and. Alltrim(SC6->C6_PEDGAR) == Alltrim(cPedGarIt) ) )
		        		MaAvalSC6("SC6",4,"SC5")
		        	EndIf
		        	SC6->(DbSkip())
		    	EndDo
		    EndIf

			nRecC6 := QRYHRD->RECHRD
			
			SB1->( dbSetOrder(1) )
			SB2->( dbSetOrder(1) )
			
			While QRYHRD->(!EOF())

				DbSelectArea("SC6")
				DbSetOrder(1)
				SC6->(DbGoto(QRYHRD->RECHRD))
				
				SB1->( dbSeek( xFilial('SB1') + SC6->C6_PRODUTO ) )
				SB2->( dbSeek( xFilial('SB2') + SB1->(B1_COD + B1_LOCPAD) ) )
				
				RecLock("SC6")
				Begin Transaction
					nQtdFat	:= iif(nQtdFat > 0, nQtdFat, SC6->C6_QTDVEN )
					nQtdLib := MaLibDoFat(SC6->(RecNo()),nQtdFat,.T.,.T.,.F.,.F.,.F.,.F.)
					nQtdVen := nQtdFat
				End Transaction
				SC6->(MsUnLock())

				Begin Transaction
					SC6->(MaLiberOk({cPedido},.F.))
				End Transaction

				QRYHRD->(dbskip())

			End

			SC5->( DbSetOrder(1) )		// C5_FILIAL+C5_NUM
			SC5->( MsSeek( xFilial("SC5")+cPedido ) )

			aRet := u_FatNfCer("1",cPedido,nIdJob)

			If !aRet[1]
				cMensagem := aRet[2]
				U_GTPutOUT(cID,"E",cPedLog,{"VNDA190",{.F.,"E00012",cPedLog,cMensagem},"Faturamento da Entrega de Produtos do Pedido "+cPedido},cXnpSite)

				If !Empty(cNsNum)
					cSql := " SELECT "
					cSql += "   COUNT(*) NREG "
	 				cSql += " FROM "
					cSql += "   GTOUT "
					cSql += " WHERE "
	 				cSql += "   GT_XNPSITE = '"+cXnpSite+"' AND "
					cSql += "   GT_CODMSG = 'E00012' "

					dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),"QRY",.F.,.T.)

					If QRY->NREG >=0 .AND. QRY->NREG <= 10
						U_VNDA300(cXnpSite,cNsNum)
					EndIf

					QRY->(DbCloseArea())
				EndIf

				If lLog
					SZQ->(Reclock("SZQ"))
					SZQ->ZQ_STATUS := "5"
					SZQ->ZQ_OCORREN := "Inconsistência Faturamento"
					SZQ->ZQ_DATA := ddatabase
					SZQ->ZQ_HORA:=time()
					SZQ->(MsUnlock())
				Endif
				
				UnLockByName("VNDA190"+cPedido+Alltrim(cPedGarIt))
				Return({.F.,cMensagem})
			EndIf

			// Reposiciono no pedido que acabou de ser faturado para pegar o numero da nota
			DbSelectArea("SC6")
			DbSetOrder(1)
			SC6->(DbGoTo(nRecC6))

			DbSelectArea("SF2")
			DbSetOrder(1)
			If DbSeek(xFilial("SF2") + SC6->C6_NOTA + SC6->C6_SERIE)

				nRecSF2Hrd := SF2->(Recno())

				If nRecSF2Hrd > 0

					// Se chegou nota de hardware, transmite e gera espelho tb

					SF2->( DbGoto(nRecSF2Hrd) )

					// Transmite a nota eletronica para o SEFAZ e aguarda a resposta da efetivacao
					aRetTrans := U_Transmitenfe(SF2->F2_DOC,SF2->F2_SERIE,cPedido)
					varinfo("aRetTrans -- ", aRetTrans)
					// 000132 - Codigo referente a dados com erro, naum adiante tentar retransmitir.
					// os demais codigos sao referentes a falhas na comunicacao.
					If aRetTrans[1]

						// Se nao transmitiu, envio para o JOB de retransmissao
						//U_RetranNFE(aRetTrans,SF2->F2_DOC,SF2->F2_SERIE)

						// TESTE - REMOVER DEPOIS...
						// Espera um minuto
						// WaitTime(60)
						// TESTE - REMOVER DEPOIS...

						nTime := Seconds()
						//Conout("ESPELHO -- Iniciando ...")

						While .T.

							// Gera o arquivo espelho da nota fiscal
							SF2->( DbGoto(nRecSF2Hrd) )

							SC6->( DbSetOrder(4) )		// C6_FILIAL+C6_NOTA+C6_SERIE
							SC6->( MsSeek( xFilial("SC6")+SF2->(F2_DOC+F2_SERIE) ) )

							SC5->( DbSetOrder(1) )		// C5_FILIAL+C5_NUM
							SC5->( MsSeek( xFilial("SC5")+SC6->C6_NUM ) )

							If aRetTrans[2] == "000169"
							    lDeneg := .T.
								U_NFDENG02()

								//IMPRIME A DANFE COM A INFORMAÇÃO DE NOTA DENEGADA
								//SUBSTITUIDO A CHAMADA U_NFDENG03(aRetTrans,@cRandom)
								aRetEspelho := U_GARR010(aRetTrans,@cRandom, lDeneg)

							else
	                            lDeneg := .F.
								aRetEspelho := U_GARR010(aRetTrans,@cRandom)

							EndIF

							If Len(aRetEspelho) > 0 .AND. aRetEspelho[1]

								If aRetTrans[1] .AND. (!SF2->F2_FIMP $ "D")
									SF2->( DbGoto(nRecSF2Hrd) )
									SF2->( RecLock("SF2",.F.) )
									If lDeneg
										SF2->F2_FIMP := "D"
									Else
										SF2->F2_FIMP := "S"
									EndIf
									SF2->( MsUnLock() )
								EndIf

								// Enviou / Gerou certinho ? Pode sair
								U_VNDA320("ESPELHO -- saindo 001 - gerou o espelho : "+str(Seconds()-nTime))
								Exit
							Else
								//U_VNDA320("ESPELHO -- Tentou gerar o espelho e falhou : "+str(Seconds()-nTime))
							Endif

							If Len(aRetEspelho) > 1 .AND. aRetEspelho[2] == "000134"
								// Ocorrencia 000134, pode sair
								// ( Impressao fora de job , uso com remote por exemplo )
								U_VNDA320("ESPELHO -- saindo 002 - Impressao fora de job , uso com remote por exemplo : "+str(Seconds()-nTime))
								Exit
							Endif

							If !aRetTrans[1]
								// Se nao transmitiu nao adiante insistir na impressao do PDF, entao pode sair
								U_VNDA320("ESPELHO -- saindo 003 - nao transmitiu para o SEFAZ : "+str(Seconds()-nTime))
								Exit
							Endif

							// Verifica quanto tempo esta tentando enviar ...
							// Se passou da 00:00, recalcula tempo
							nWait := Seconds()-nTime
							If nWait < 0
								nWait += 86400
							Endif

							If nWait > GetNewPar("MV_TIMESP", 120 )
								// Passou de 2 minutos tentando ? Desiste !
								U_VNDA320("ESPELHO -- saindo 004 - time out : "+str(Seconds()-nTime))
								EXIT
							Endif

							// Espera um pouco ( 5 segundos ) para tentar novamente

							Sleep(5000)
							//U_VNDA320("ESPELHO -- dormindo 5 segundos... zzzzz...  : "+str(Seconds()-nTime))

						EndDo
						//U_VNDA320("ESPELHO -- fora do loop  : "+str(Seconds()-nTime))

						If Len(aRetEspelho) > 0 .AND. aRetEspelho[1]
							// Se gerou espelho, recupera URI do espelho
							cNotaHrd := aRetEspelho[4]
						Else
							lRet := .f.
		    				cMensagem += "Inconsistência ao Gerar Danfe de Produto "
						Endif
						U_GTPutOUT(cID,"E",cPedLog,{"NF_PRODUTO_ENTREGA",aRetEspelho,"Faturamento da Entrega de Produtos do Pedido "+cPedido},cNpSite)
					Else
						U_GTPutOUT(cID,"E",cPedLog,{"NF_PRODUTO_ENTREGA",aRetTrans,"Faturamento da Entrega de Produtos do Pedido "+cPedido},cNpSite)
					Endif
				Endif
		    Else
		    	lRet := .f.
		    	cMensagem += "Inconsistência ao Gerar Nota de Entrega do Pedido "+cPedido+". Necessário Realizar Processo manualmente. "
		    	U_GTPutOUT(cID,"E",cPedLog,{"NF_PRODUTO_ENTREGA",{.F.,"E00011",cPedLog,cMensagem}},cNpSite)

		    EndIf
		Else     //Força transmissao e geração do PDF da DANFE

			cMsgH := "Não Foram Encontrados Itens de Entrega de Hardware para o Pedido "+cPedido

			SC5->( DbSetOrder(1) )		// C5_FILIAL+C5_NUM
			SC5->( MsSeek( xFilial("SC5")+cPedido) )

			SC6->( DbSetOrder(1) )
			SC6->( MsSeek( xFilial("SC6")+cPedido) )

			nRecSF2Hrd:=0

			While SC6->(!Eof()) .And. SC6->C6_FILIAL+SC6->C6_NUM==xFilial("SC6")+cPedido

				If SC6->C6_XOPER == cOpEnt .And. !Empty(SC6->C6_NOTA)
					cNfHrdLog := Alltrim(SC6->C6_SERIE+SC6->C6_NOTA)
					DbSelectArea("SF2")
					DbSetOrder(1)
					If SF2->(DbSeek(xFilial("SF2") + SC6->C6_NOTA + SC6->C6_SERIE))
						nRecSF2Hrd:=SF2->(Recno())
						Exit
					Endif
				Endif
				SC6->(DbSkip())
			EndDo

			If nRecSF2Hrd > 0 .and. Empty(SC5->C5_XNFHRE)

				// Se chegou nota de hardware, transmite e gera espelho tb

				SF2->( DbGoto(nRecSF2Hrd) )

				// Transmite a nota eletronica para o SEFAZ e aguarda a resposta da efetivacao
				aRetTrans := U_Transmitenfe(SF2->F2_DOC,SF2->F2_SERIE,cPedido)

				// 000132 - Codigo referente a dados com erro, naum adiante tentar retransmitir.
				// os demais codigos sao referentes a falhas na comunicacao.
				If aRetTrans[1]

					// Se nao transmitiu, envio para o JOB de retransmissao
					//U_RetranNFE(aRetTrans,SF2->F2_DOC,SF2->F2_SERIE)

					// TESTE - REMOVER DEPOIS...
					// Espera um minuto
					// WaitTime(60)
					// TESTE - REMOVER DEPOIS...

					nTime := Seconds()
					//Conout("ESPELHO -- Iniciando ...")

					While .T.

						// Gera o arquivo espelho da nota fiscal
						SF2->( DbGoto(nRecSF2Hrd) )

						SC6->( DbSetOrder(4) )		// C6_FILIAL+C6_NOTA+C6_SERIE
						SC6->( MsSeek( xFilial("SC6")+SF2->(F2_DOC+F2_SERIE) ) )

						SC5->( DbSetOrder(1) )		// C5_FILIAL+C5_NUM
						SC5->( MsSeek( xFilial("SC5")+SC6->C6_NUM ) )

						If aRetTrans[2] == "000169"
							lDeneg := .T.
							U_NFDENG02()

							//IMPRIME A DANFE COM A INFORMAÇÃO DE NOTA DENEGADA
							//SUBSTITUIDO A CHAMADA U_NFDENG03(aRetTrans,@cRandom)
							aRetEspelho := U_GARR010(aRetTrans,@cRandom, lDeneg)

						else
							lDeneg := .F.
							aRetEspelho := U_GARR010(aRetTrans,@cRandom)

						EndIf

						If Len(aRetEspelho) > 0 .AND. aRetEspelho[1]

							If aRetTrans[1] .AND. (!SF2->F2_FIMP $ "D")
								SF2->( DbGoto(nRecSF2Hrd) )
								SF2->( RecLock("SF2",.F.) )
								If lDeneg
									SF2->F2_FIMP := "D"
								Else
									SF2->F2_FIMP := "S"
								EndIf
								SF2->( MsUnLock() )
							EndIf

							// Enviou / Gerou certinho ? Pode sair
							U_VNDA320("ESPELHO -- saindo 001 - gerou o espelho : "+str(Seconds()-nTime))
							Exit
						Else
							//U_VNDA320("ESPELHO -- Tentou gerar o espelho e falhou : "+str(Seconds()-nTime))
						Endif

						If Len(aRetEspelho) > 1 .AND. aRetEspelho[2] == "000134"
							// Ocorrencia 000134, pode sair
							// ( Impressao fora de job , uso com remote por exemplo )
							U_VNDA320("ESPELHO -- saindo 002 - Impressao fora de job , uso com remote por exemplo : "+str(Seconds()-nTime))
							Exit
						Endif

						If !aRetTrans[1]
							// Se nao transmitiu nao adiante insistir na impressao do PDF, entao pode sair
							U_VNDA320("ESPELHO -- saindo 003 - nao transmitiu para o SEFAZ : "+str(Seconds()-nTime))
							Exit
						Endif

						// Verifica quanto tempo esta tentando enviar ...
						// Se passou da 00:00, recalcula tempo
						nWait := Seconds()-nTime
						If nWait < 0
							nWait += 86400
						Endif

						If nWait > 60
							// Passou de 2 minutos tentando ? Desiste !
							U_VNDA320("ESPELHO -- saindo 004 - time out : "+str(Seconds()-nTime))
							EXIT
						Endif

						// Espera um pouco ( 5 segundos ) para tentar novamente

						Sleep(5000)
						//U_VNDA320("ESPELHO -- aguardando 5 segundos... : "+str(Seconds()-nTime))

					EndDo
					//U_VNDA320("ESPELHO -- fora do loop  : "+str(Seconds()-nTime))

					If Len(aRetEspelho) > 0 .AND. aRetEspelho[1]
						// Se gerou espelho, recupera URI do espelho
						cNotaHrd := aRetEspelho[4]
					Else
						lRet := .f.
						cMensagem += "Inconsistência ao Gerar Danfe de Produto "
					Endif
					U_GTPutOUT(cID,"E",cPedLog,{"NF_PRODUTO_ENTREGA",aRetEspelho,"Faturamento da Entrega de Produtos do Pedido "+cPedido},cNpSite)
				Else
					U_GTPutOUT(cID,"E",cPedLog,{"NF_PRODUTO_ENTREGA",aRetTrans,"Faturamento da Entrega de Produtos do Pedido "+cPedido},cNpSite)
				Endif
			EndIf
		EndIf
        
        //retorna para empresa e filial antes da aletação
		If lFatFil
			FatFil(nil,cFilOld)
		Endif
		
		//Conout("Nota Fiscal Entrega: " + cNotaHrd)

		If !Empty(cNotaHrd)
			If Empty(cPedGarIt)
				SC5->( DbSetOrder(1) )		// C5_FILIAL+C5_NUM
				SC5->( MsSeek( xFilial("SC5") + cPedido ) )
				RecLock("SC5", .F.)
					Replace SC5->C5_XNFHRE With cNotaHrd
					Replace SC5->C5_STENTR With "1"
					Replace SC5->C5_XFLAGEN With Space(TamSX3("C5_XFLAGEN")[1])
				SC5->(MsUnLock())
			Else
				DbSelectArea("SC6")
				DbOrderNickName("NUMPEDGAR")
							
				If SC6->(DbSeeK( xFilial("SC6")+cPedGarIt ) )
					While !SC6->(eof()) .and. SC6->C6_FILIAL+Alltrim(SC6->C6_PEDGAR) == xFilial("SC6")+Alltrim(cPedGarIt)
						RecLock("SC6", .F.)
							Replace SC6->C6_XNFHRE With cNotaHrd
							Replace SC6->C6_XFLAGEN With Space(TamSX3("C6_XFLAGEN")[1])
						SC6->(MsUnLock())
						SC6->(DbSkip())
					End
				EndIf
			EndIf
		EndIf

		// Fecha query de faturamento de hardware
		DbSelectArea("QRYHRD")
		DbCloseArea()

	EndIf
	
	UnLockByName("VNDA190"+cPedido+Alltrim(cPedGarIt))
Else
	U_GTPutOUT(cID,iif(lFat,IIF(lProd,"N","S"),"E"),cPedLog,{"U_VNDA190",{.F.,"E00002",cPedLog,"Não foi possivel realizar LockByName"},"Faturamento do Pedido "+cPedido},cNpSite)
EndIf

RestArea(aArea)
Return({lRet,cMensagem})

/*/{Protheus.doc} VNDA190P
Rotina personalizada para faturamento de pedidos manualmente
@author Totvs SM - David
@since 20/07/2011
@version P11
/*/
User Function VNDA190P(cEmpP,cFilP,nRecPed,lFat,lProd, lServ, lEnt,lRecPgto,lGerTitRecb,cTipTitRecb,nRecSc6)
Local aRVou := {}
Local cOperDeliv := ""
Local cOperVenS  := ""
Local cOperVenH  := ""
Local cOperEntH  := ""
Local cOperVen   := ""
Local cOperNPF   := ""
Local cID        := ""
Local cPedLog    := ""
Local cPedGarIt	 := ""
Default lFat        := .F.
Default lServ       := .F.
Default lProd       := .F.
Default lEnt        := .F.
Default lRecPgto    := .F.
Default lGerTitRecb := .F.
Default cTipTitRecb := ""
Default cEmpP 		:= "01"
Default cFilP 		:= "02"
Default nRecSc6     := 0

//Abre empresa para Faturamento
RpcSetType(3)
RpcSetEnv(cEmpP,cFilP)

cOperDeliv		:= GetNewPar("MV_XOPDELI", "01")
cOperVenS		:= GetNewPar("MV_XOPEVDS", "61")
cOperVenH		:= GetNewPar("MV_XOPEVDH", "62")
cOperEntH		:= GetNewPar("MV_XOPENTH", "53")
cOperNPF		:= GetNewPar("MV_XOPENPF", "61,62")

//Posiciona no Pedido
DbSelectArea("SC5")
SC5->(DbSetOrder(1))
SC5->(DbGoTo(nRecPed))

DbSelectArea("SC6")
SC6->(DbSetOrder(1))
SC6->(DbSeek(xFilial("SC6")+SC5->C5_NUM))

if nRecSc6 > 0
	sc6->(DbGoTo(nRecSc6))
	cPedGarIt	:= SC6->C6_PEDGAR
endif

//Processa Faturamento
If !Empty(SC5->C5_XNUMVOU)
	cID      := DTOS(DATE())+SC5->C5_XNPSITE
	cPedSite := SC5->C5_XNPSITE
	cPedLog  := IIF(EMPTY(SC5->C5_CHVBPAG), SC5->C5_XNPSITE,SC5->C5_CHVBPAG)
	oVoucher := getVoucher( cPedSite, cPedLog  )
	if empty(oVoucher)  //conout("[VNDA190-VOUCHER] O pedido Erp "+sc5->c5_num+" não foi faturado.")
	   U_GTPutOUT(cID,"V",cPedLog,{"VNDA190",{.F.,"E00012",cPedLog,"O pedido Erp "+sc5->c5_num+" não foi faturado."},"Faturamento da Venda de Produtos do Pedido "+cPedLog},cPedSite)
       return
    else
		aRVou    := U_VNDA430( oVoucher )
	endif
	
	aParamFun := {SC5->C5_NUM,;
				Val(SC5->C5_XNPSITE),;
				lFat,;
				nil,;
				aRVou[4],;
				aRVou[5],;
				nil,;
				iif(!Empty(aRVou[7]),aRVou[7],nil),;
				iif(!Empty(aRVou[8]),aRVou[8],nil),;
				iif(!Empty(aRVou[6]),aRVou[6],nil),;
				nil,;
				nil,;
				lRecPgto,;
				lGerTitRecb,;
				cTipTitRecb,;
				lEnt,;
				nil,;
				nil,;
				cPedGarIt}
Else



	If SC5->C5_TPCARGA <> "1"
		cOperVen	:= cOperVenH
		If ! SC6->C6_XOPER $ cOperNPF //Verifica se Ã© nova operaÃ§Ã£o
			cOperVen :='52'
			cOperEntH:='53'
			cOperVenS:='51'
	  	Endif
	Else
		cOperVen	:= cOperDeliv
	EndIf



	aParamFun :=  {SC5->C5_NUM,;
				Val(SC5->C5_XNPSITE),;
				lFat,;
				nil,;
				lServ,;
				lProd,;
				nil,;
				cOperVen,;
				cOperEntH,;
				cOperVenS,;
				nil,;
				nil,;
				lRecPgto,;
				lGerTitRecb,;
				cTipTitRecb,;
				lEnt,;
				nil,;
				nil,;
				cPedGarIt}
EndIf

U_VNDA190( SC5->C5_XNPSITE ,aParamFun	)

Return


/*/{Protheus.doc} FatNfCer
Rotina personalizada de faturamento de itens do pedido de venda
@author Totvs SM - David
@since 20/07/2011
@version P11
/*/
User Function FatNfCer(cTip,cPedido,nIdJob)
Local lRet 		:= .t.
Local cMensagem := ""
Local bOldBlock	:= nil
Local cErrorMsg	:= ""

//TRATAMENTO PARA ERRO FATAL NA THREAD
cErrorMsg := ""
bOldBlock := ErrorBlock({|e| U_ProcError(e) })

BEGIN SEQUENCE

If cTip == "1"
	conout("Inicio Faturamento "+TIme()+" Pedido "+cPedido)
	Pergunte("MT460A",.F.)
	FtJobNFs("SC9",GetNewPar("MV_GARSHRD","2  "),.F.,.F.,.F.,.F.,.F.,0,0,0,.F.,.F.,cPedido,nIdJob)
	conout("FIm Faturamento "+TIme()+" Pedido "+cPedido)
EndIf

If cTip == "2"
	Pergunte("MT460A",.F.)
	FtJobNFs("SC9",GetNewPar("MV_GARSSFW","RP2"),.F.,.F.,.F.,.F.,.F.,0,0,0,.F.,.F.,cPedido,nIdJob)
EndIf

END SEQUENCE

ErrorBlock(bOldBlock)

cErrorMsg := U_GetProcError()

If !empty(cErrorMsg)
	lRet := .f.
	cMensagem := "Inconsistência no Faturamento: "+CRLF+cErrorMsg
EndIf

Return({lRet,cMensagem})


/*/{Protheus.doc} GerRecbPg

Função personalizada para geração de Recibo de Pagamento mediante pedido de vendas

@author Totvs SM - David
@since 20/07/2011
@version P11

/*/

Static Function GerRecbPg(cPedido, cPedLog, cNpSite, nIdJob, dCredCnab, lGerTitRecb, cTipTitRecb, nVlrTitRecb,lRecPgto, cBanco )
Local lRet 			:= .T.
Local cRecPgto 		:= ""
Local lLog			:= .F.
Local nOpcRotina	:= 0
Local cCodCondPagto := ""
Local nValor		:= 0
Local aSE1			:= {}
Local lFIE			:= .F.
Local lSE5			:= .F.
Local dDataCredito	:= dDataBase
Local cBcoCnab		:= ""
Local cAgenCnab		:= GetNewPar("MV_XAGCNB", "00000")
Local cCtaCnab		:= ""
Local cBcoDAITAU	:= GetNewPar("MV_XBCDAI", "341")
Local cAgenDAITAU	:= GetNewPar("MV_XAGDAI", "00000")
Local cCtaDAITAU	:= GetNewPar("MV_XCTDAI", "COBITAU")
Local cBcoDABB		:= GetNewPar("MV_XBCDAB", "001")
Local cAgenDABB		:= GetNewPar("MV_XAGDAB", "00000")
Local cCtaDABB		:= GetNewPar("MV_XCTDAB", "COBBRAS")
Local aBanco		:= {}
Local cHistSE5		:= ""
Local cPrefRP		:= GetNewPar("MV_XPREFRP", "RCP")
Local cTipMov		:= ""
Local aRet			:= {}
Local cDate			:= StrTran(DtoC(Date()),"/","")
Local cTime			:= StrTran(Time(),":","")
Local cID			:= cDate + cTime
Local nI            := 0
Local nX            := 0
default dCredCnab   := dDatabase
default cBanco 		:= ""

cBcoCnab := cBanco
	SC5->( DbSetOrder(1) )		// C5_FILIAL+C5_NUM
	SC5->( MsSeek( xFilial("SC5") + cPedido ) )
	
	//Se a origem for Cursos, Muda status do campo para Pendente. Assim a equipe fiscal pode analisar situação do pedido quanto a tributação
	IF SC5->C5_XORIGPV=='8' .AND. !SC5->C5_XLIBFAT =='S'//Pedidos de Cursos ainda não liberados pelo Fiscal
		RecLock("SC5", .F.)
		SC5->C5_XLIBFAT:= "P" //Muda status para pendente de análise fiscal
		SC5->(MsUnlock())
    End
	
	SC6->( DbSetOrder(1) )		// C5_FILIAL+C5_NUM
	SC6->( MsSeek( xFilial("SC6") + cPedido ) )
	WHILE !SC6->(EOF()) .and.  (xFilial("SC6") + cPedido == SC6->C6_FILIAL + SC6->C6_NUM)
	    IF SC6->C6_XOPER $ "51/52" 
	    	cPrefRP:='RCO'
	    ENDIF
		SC6->(DbSkip())
	Enddo
	
	If !Empty(cTipTitRecb)
		cTipMov := cTipTitRecb
	Else
		cTipMov := iif(Alltrim(SC5->C5_TIPMOV) $ "2,3,5","PR","NCC")
	EndIf

	U_GTPutIN(cID,"R",cPedLog,.T.,{"RECIBO_PAGAMENTO",cPedLog,"Inicio do processamento tipo "+cTipMov+" Pedido "+ cPedido},cNpSite)


	SE1->(DbSetOrder(2))//E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO

	/*
	// 06/03/17 (David) - retirada a atualização do pedido na tabela SZQ, pois não é necessário
	alterar o status para 7-em processamento caso seja impressão de recibo. Alinhado com ZILA
	
	SZQ->(DbSelectArea("SZQ"))
	SZQ->(DbSetOrder(2))
	lLog := SZQ->(DbSeek(xFilial("SZQ")+Alltrim(Str(nIdJob))))
    If !lLog .AND. !Empty(cPedLog) .and. cNpSite <> cPedLog
    	lLog := SZQ->(DbSeek(xFilial("SZQ")+cPedLog))
    EndIf

	If lLog
		SZQ->(Reclock("SZQ"))
		SZQ->ZQ_STATUS := "7"
		SZQ->ZQ_OCORREN := "Em Processamento "+Alltrim(GETSRVINFO()[1])+":"+Alltrim(GetPvProfString(GetPvProfString("DRIVERS","ACTIVE","TCP",GetADV97()),"PORT","0",GetADV97()))
		SZQ->ZQ_DATA := ddatabase
		SZQ->ZQ_HORA:=time()
		SZQ->(MsUnlock())
		U_GTPutIN(cID,"N",cPedLog,.F.,{"U_VNDA190",cPedLog,"Atualizando registro no controle de cnab"+cPedido},cNpSite)
	EndIf
	*/
	
	nOpcRotina 		:= 3
	cCodCondPagto	:= SC5->C5_CONDPAG
	If nVlrTitRecb > 0
		nValor			:= nVlrTitRecb
	Else
		nValor			:= SC5->C5_TOTPED+SC5->C5_FRETE
	EndIf
	lFIE			:= .T.
	lSE5			:= iif(cTipMov == "NCC",.T.,.F.)
	dDataCredito	:= dCredCnab

	aSE1			:= {	cPrefRP,;
							cPedido,;
							cTipMov,;
							SC5->C5_XNATURE,;
							SC5->C5_CLIENTE,;
							SC5->C5_LOJACLI,;
							iif(lSE5,dDataCredito,DATE()),;
							cPedido,;
							SC5->C5_XNPSITE,;
							cPedido,;
							SC5->C5_TIPMOV,;
							SC5->C5_CHVBPAG,;
							cPedido }

	//identifica banco de controle de processamento de cnab
	If SC5->C5_TIPMOV == "1"
		SA6->(DbSetOrder(1))
		If SA6->(DbSeek(xFilial("SA6")+cBcoCnab+cAgenCnab))
			cCtaCnab	:= SA6->A6_NUMCON
		Else
			cCtaCnab	:= ""
		EndIf
	ElseIf SC5->C5_TIPMOV == "7"  
	    cBcoCnab	:= cBcoDAITAU
		cAgenCnab	:= cAgenDAITAU
		cCtaCnab	:= cCtaDAITAU
	ElseIf SC5->C5_TIPMOV == "4"
		cBcoCnab	:= cBcoDABB
		cAgenCnab	:= cAgenDABB
		cCtaCnab	:= cCtaDABB 
	Elseif  SC5->C5_TIPMOV == "6"
		lGerTitRecb:=.F.
	EndIf
	aBanco			:= {cBcoCnab,cAgenCnab,cCtaCnab}
	cHistSE5		:= "Ped Site "+Alltrim(SC5->C5_XNPSITE)+iIf( !Empty(SC5->C5_CHVBPAG) , " Ped GAR "+Alltrim(SC5->C5_CHVBPAG) , iif( !Empty(SC5->C5_XPEDORI) , " Ped Ori "+Alltrim(SC5->C5_XPEDORI) , "" ) )

	// Verifica se existe título gerado para este pedido.
	cSql := "SELECT R_E_C_N_O_ RECE1 "
	cSql += " FROM "+RetSqlName("SE1")
	cSql += " WHERE E1_FILIAL = '"+xFilial("SE1")+"' AND "
	cSql += " E1_PREFIXO ='"+cPrefRP+"' AND"
	cSql += " E1_TIPO ='"+cTipMov+"' AND"
	cSql += " E1_PEDIDO = '"+cPedido+"' AND "
	cSql += " D_E_L_E_T_ = ' ' "
        
	cTrbSql:=GetNextAlias()
	PLSQuery( cSql, CTrbSql )
    
    aSe1TipMov:={}
	
	While !(cTrbSql)->(Eof())
		AAdd( aSe1TipMov, (cTrbSql)->RECE1 )
		(cTrbSql)->(DbSkip())
	End

	(cTrbSql)->(DbCloseArea())
      
	If Len(aSe1TipMov)=0

		U_GTPutOUT(cID,"R",cPedLog,{"RECIBO_PAGAMENTO",{.T.,"M00001",cPedLog,"Chamada da Funcao Inicio do processamento CSFA500 para tipo "+cTipMov+ " Pedido "+cPedido+" Pagamento "+Alltrim(SC5->C5_TIPMOV)}},cNpSite)
	
		If lGerTitRecb

		   /**Verifica necessidade de debloquear vendedor para realizar a inclusão do título**/
		   lVenBloq := .f.
		   if !empty(sc5->c5_vend1)
		      lVenBloq := BqlDblqVen("1",sc5->c5_vend1)
		   endif
		   /*************/

			lRet := U_CSFA500( nOpcRotina, cCodCondPagto, nValor ,aSE1, lFIE, lSE5, dDataCredito, aBanco, cHistSE5, cID )
			SE5->(MSUNLOCK())
	  	   	SE1->(MSUNLOCK())
  		   	SA1->(MSUNLOCK())

		   /**Caso o vendedor tenha sido desbloqueado, bloquear novamente pois o título já foi incluido**/
		   if lVenBloq
		      lVenBloq := BqlDblqVen("2",sc5->c5_vend1)
		   endif
		   /**********/

		Else
			lRet := .T.
		Endif
	
		//geração de recibo
		If lRet  .And. lRecPgto
	
			//geração de recibo de pagamento
			aRet := U_CSFA520(cPedido)
			//grava link e prepara registro para envio para hub
			If aRet[1]
				cRecPgto	:= aRet[2]
				//gravação do link do recibo
				If !Empty(cRecPgto)
					If lLog
						SZQ->(Reclock("SZQ"))
						SZQ->ZQ_STATUS := "3"
						SZQ->ZQ_NF1 := ""
						SZQ->ZQ_OCORREN := "Recibo gerado com sucesso."
						SZQ->ZQ_DATA := ddatabase
						SZQ->ZQ_HORA:=time()
						SZQ->(MsUnlock())
					Endif
	
					RecLock("SC5", .F.)
					Replace SC5->C5_XRECPG With cRecPgto
					Replace SC5->C5_XFLAGEN With Space(TamSX3("C5_XFLAGEN")[1])
					//Se a origem for Cursos, impede o faturamento até que a equipe fiscal realize a análise do pedido e mude status do campo c5_XlibFAt para "S"    
					//IF SC5->C5_XORIGPV=='8' .AND. SC5->C5_XLIBFAT $ ("N|P")
					//	Replace SC5->C5_XLIBFAT With "S"
					//Endif
				    SC5->(MsUnLock())
	
					U_GTPutOUT(cID,"R",cPedLog,{"RECIBO_PAGAMENTO",{.T.,"M00001",cPedLog,"Geração do Recibo com sucesso para tipo "+cTipMov+ " Pedido "+cPedido+" Pagamento "+Alltrim(SC5->C5_TIPMOV)}},cNpSite)
				Else
					If lLog
						SZQ->(Reclock("SZQ"))
						SZQ->ZQ_STATUS := "5"
						SZQ->ZQ_OCORREN := "Inconsistencia ao gerar recibo"
						SZQ->ZQ_DATA := ddatabase
						SZQ->ZQ_HORA:=time()
						SZQ->(MsUnlock())
					Endif
					U_GTPutOUT(cID,"R",cPedLog,{"RECIBO_PAGAMENTO",{.F.,"E00001",cPedLog,"Inconsistência na geração do recibo para tipo " +cTipMov+ " Pedido "+cPedido+" Pagamento "+Alltrim(SC5->C5_TIPMOV)}},cNpSite)
				EndIf
			Else
				U_GTPutOUT(cID,"R",cPedLog,{"RECIBO_PAGAMENTO",{.F.,"E00001",cPedLog,"Inconsistência na geração do recibo para tipo "+cTipMov+ " Pedido "+cPedido+" Pagamento "+Alltrim(SC5->C5_TIPMOV)}},cNpSite)
			EndIf
		Else
			U_GTPutOUT(cID,"R",cPedLog,{"RECIBO_PAGAMENTO",{.F.,"E00001",cPedLog,"Inconsistência na geração do título referente recibo para tipo "+cTipMov+ " Pedido "+cPedido+" Pagamento "+Alltrim(SC5->C5_TIPMOV)}},cNpSite)
		EndIf
	Else
	
		U_GTPutOUT(cID,"R",cPedLog,{"RECIBO_PAGAMENTO",{.T.,"M00001",cPedLog,"Já existe Recibo "+cTipMov+" para o Pedido "+cPedido+" Pagamento "+Alltrim(SC5->C5_TIPMOV)}},cNpSite)
    
    EndiF    
	
	//Sempre verifica se exitem pendencias de compensação ou substuição
	
	// Localiza as NFs do pedido para Substituição dos PR ou Compensação das NCCs
	cSql := "SELECT R_E_C_N_O_ RECE1 "
	cSql += " FROM "+RetSqlName("SE1")
	cSql += " WHERE E1_FILIAL = '"+xFilial("SE1")+"' AND "
	cSql += " E1_TIPO ='NF' AND"
	cSql += " E1_PEDIDO = '"+cPedido+"' AND "
	cSql += " E1_SALDO > 0 AND "
	cSql += " D_E_L_E_T_ = ' ' "
        
	cTrbSql:=GetNextAlias()
	PLSQuery( cSql, CTrbSql )
    
    aSe1NF:={}
	
	While !(cTrbSql)->(Eof())
		AAdd( aSe1Nf, {cPedido,(cTrbSql)->RECE1} )
		(cTrbSql)->(DbSkip())
	End

	(cTrbSql)->(DbCloseArea())
      
	If Len(aSe1Nf)>0
	
		//verifica se deve substituir as PR e Compensar as NCC
		//User funtion do M460fin
		U_VldRecPg( aSe1Nf,.T. )
    Endif
     
	
	// Localiza as NCCs do pedido para Substituição dos PR
	cSql := "SELECT R_E_C_N_O_ RECE1 , E1_PARCELA PARCELA, E1_EMISSAO EMISSAO "
	cSql += " FROM "+RetSqlName("SE1")
	cSql += " WHERE E1_FILIAL = '"+xFilial("SE1")+"' AND "
	cSql += " E1_TIPO ='NCC' AND"
	cSql += " E1_PREFIXO ='RCP' AND"
	cSql += " E1_PEDIDO = '"+cPedido+"' AND "
	cSql += " E1_SALDO > 0 AND "
	cSql += " D_E_L_E_T_ = ' ' "
        
	cTrbSql:=GetNextAlias()
	PLSQuery( cSql, CTrbSql )
    
    aSe1NCC:={}
	
	While !(cTrbSql)->(Eof())
		AAdd( aSe1NCC, { (cTrbSql)->RECE1 , (cTrbSql)->PARCELA,(cTrbSql)->EMISSAO } )
		(cTrbSql)->(DbSkip())
	End

	(cTrbSql)->(DbCloseArea())
      
	If Len(aSe1NCC)>0 
		For nx:= 1 to Len(aSe1NCC)	
			// Localiza os PR para substituição
			cSql := "SELECT R_E_C_N_O_ RECE1 , E1_PARCELA PARCELA"
			cSql += " FROM "+RetSqlName("SE1")
			cSql += " WHERE E1_FILIAL = '"+xFilial("SE1")+"' AND "
			cSql += " E1_TIPO ='PR' AND"
			cSql += " E1_PREFIXO ='RCP' AND"
			cSql += " E1_PARCELA ='"+aSe1NCC[NX][2] +"' AND"
			cSql += " E1_PEDIDO = '"+cPedido+"' AND "
			cSql += " E1_SALDO >0 AND "
			cSql += " D_E_L_E_T_ = ' ' "
		        
			cTrbSql:=GetNextAlias()
			PLSQuery( cSql, CTrbSql )
		    
		    aSe1PR:={}
			
			While !(cTrbSql)->(Eof())
				AAdd( aSe1PR, { (cTrbSql)->RECE1 , (cTrbSql)->PARCELA } )
				(cTrbSql)->(DbSkip())
			End
		
			(cTrbSql)->(DbCloseArea())
		    
	    	dBxRcb 		:= aSe1NCC[NX][3]
		      
			If Len(aSe1PR)>0 
			    
			    For ni:=1 to len(aSe1PR)
				    
					SE1->(DbGoTo(aSe1PR[ni][1]))
	
					aFaVlAtuCR 	:= {}
					aDadosBaixa := {}
					aBaixa 		:= {}
	
					cHistory 	:= SE1->( E1_PREFIXO + E1_NUM + E1_PARCELA + E1_TIPO ) + 'SUB'
	
					aFaVlAtuCR := FaVlAtuCr('SE1', dBxRcb)
	
					AAdd( aDadosBaixa, { SE1->(Recno()) , cHistory, AClone( aFaVlAtuCR ) } )
	
					//Verifica se PR conta com mais saldo que titulo que ira substituli
					//pois caso positivo baixa saldo todo do PR
					nBaixa	:= SE1->E1_SALDO
					aParam 	:= {.F.,.F.,.F.,.F.,.F.,.F.}
	
					aBaixa := { 'SUB', nBaixa, aBanco[1], aBanco[2], aBanco[3], dBxRcb, dBxRcb }
					aRet := U_CSFA530( 1, { SE1->(Recno()) }, aBaixa, /*aNCC_RA*/, /*aLiquidacao*/, aParam, /*bBlock*/, /*aEstorno*/, aDadosBaixa, /*aNewSE1*/ )
					SE5->(MSUNLOCK())
			  	   	SE1->(MSUNLOCK())
	  	   			SA1->(MSUNLOCK())
				Next
			
		    Endif
	
	    Next
    
    Endif
	

Return(lRet)

/*/{Protheus.doc} FATFIL
Rotina personalizada para alterar a filial de faturamento de acordo o estado do cliente
@author Totvs SM - David
@since 06/12/2016
@version P11
/*/
Static Function FatFil(cPedido,cFilFat)
	Local cEstFilFat:= GetNewPar("MV_XFILFAT", "")
	Local nPos		:= 0
	Local nTamFil	:= FWSizeFilial()
	Local lRet		:= .F.
	
	Default cPedido	:= ""
	Default cFilFat	:= ""
	
	SC5->(DbSetOrder(1))
	SC6->(DbSetOrder(1))
	SA1->(DbSetOrder(1))
	
	//////////////////////////////////////////
	If Empty(cEstFilFat)
		conout("[FATFIL] Não há definição para tratamento de faturamento por filiais.")
		Return(.F.)
	Endif
	//////////////////////////////////////////
	
	If !Empty(cPedido)
		If 	!Empty(cEstFilFat) .and.;
			SC5->(DbSeek(xFilial("SC5")+cPedido)) .and.;
			SA1->(DbSeek(xFilial("SA1")+SC5->(C5_CLIENTE+C5_LOJACLI))) 
			
			nPos := At(Alltrim(SA1->A1_EST),cEstFilFat)	
			If nPos > 0
				cFilFat := SubStr(cEstFilFat,nPos+3,nTamFil)
			Else
				conout("[FATFIL] Filial do cliente não encontrada "+cEstFilFat+" "+cPedido+" "+Alltrim(SA1->A1_EST))
			EndIf
		EndIf
	EndIf
	
	dbSelectArea( 'SM0' )
	SM0->( dbSetOrder( 1 ) )
				
	If !Empty(cFilFat) .and. SM0->( dbSeek( cEmpAnt + cFilFat, .T. ) )
		cFilAnt := cFilFat
		lRet 	:= .T.
	Else
		conout("[FATFIL] Filfat em branco ou sm0 não encontrado "+cEmpAnt + cFilFat+" "+cFilAnt)
	EndIf
Return(lRet)

//-----------------------------------------------------------------------
// Rotina | VN190_MV    | Autor | Rafael Beghini    | Data | 31.10.2018
//-----------------------------------------------------------------------
// Descr. | Cria os parâmetro de controle do faturamento
//-----------------------------------------------------------------------
// Origem | Conforme OTRS: 2018103110002566
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function VN190_MV()
	Local cMSG	:= ''
	If .NOT. SX6->( ExisteSX6( 'MV_190FAT' ) )
		CriarSX6( 'MV_190FAT', 'D', 'DATA LIMITE PARA PROCESSAR O FATURAMENTO ALL. DD/MM/AA VNDA190.prw', '' )
		cMSG += 'MV_190FAT  - conteúdo: " "' + CRLF
	Endif

	If .NOT. SX6->( ExisteSX6( 'MV_190SERV' ) )
		CriarSX6( 'MV_190SERV', 'D', 'DATA LIMITE PARA PROCESSAR O FATURAMENTO-(SERVICO). DD/MM/AA VNDA190.prw', '' )
		cMSG += 'MV_190SERV - conteúdo: " "' + CRLF
	Endif

	If .NOT. SX6->( ExisteSX6( 'MV_190PROD' ) )
		CriarSX6( 'MV_190PROD', 'D', 'DATA LIMITE PARA PROCESSAR O FATURAMENTO-(PRODUTO). DD/MM/AA VNDA190.prw', '31/10/18' )
		cMSG += 'MV_190PROD - conteúdo: "31/10/18"' + CRLF
	Endif

	If .NOT. SX6->( ExisteSX6( 'MV_190ENT' ) )
		CriarSX6( 'MV_190ENT', 'D', 'DATA LIMITE PARA PROCESSAR O FATURAMENTO-(ENTREGA). DD/MM/AA VNDA190.prw', '31/10/18' )
		cMSG += 'MV_190ENT  - conteúdo: "31/10/18"' + CRLF
	Endif

	If .NOT. SX6->( ExisteSX6( 'MV_190REC' ) )
		CriarSX6( 'MV_190REC', 'D', 'DATA LIMITE PARA PROCESSAR O FATURAMENTO-(RECIBO PAGTO). DD/MM/AA VNDA190.prw', '' )
		cMSG += 'MV_190REC  - conteúdo: " "' + CRLF
	Endif
	MsgInfo('Parâmetros de faturamento criados com sucesso conforme: ' + CRLF + cMSG,'VN190_MV')
Return

static function getVoucher(  cPedSite, cPedLog  )
	local oVoucher := nil
	local oPedido  := nil
	local cError   := ""
	local cWarning := ""
	local nPed     := 0
	local cID      := ""
	
	default cPedSite := ""
	
	if !empty( cPedSite ) 
	
		//Retorna o ID da GTIN pelo pedido SITE
		cID := getIdGtIn( cPedSite )

		if !empty( cID )
			//Monto XML do pedido
			oPedido  := montarXML( cID, cPedLog, cPedSite, @cError, @cWarning, @nPed )
			if empty(oPedido)  //conout("[VNDA190-VOUCHER] Arquivo xml ref pedido Site "+alltrim(cPedSite)+") não encontrado.")
			   U_GTPutOUT(cID,"V",cPedLog,{"VNDA190",{.F.,"E00012",cPedLog,"Arquivo xml ref pedido Site "+alltrim(cPedSite)+") com problemas"},"Faturamento da Venda de Produtos do Pedido "+cPedLog},cPedSite)
            else
				//Carrego dados do Voucher
				oVoucher := CSVoucherPV():New( cID, cPedSite, cPedLog, oPedido:_LISTPEDIDOFULLTYPE:_PEDIDO[ nPed ] )
			endif
		endif
	endif
return oVoucher

static function montarXML( cID, cPedLog, cPedSite, cError, cWarning, nPed )
	Local cRootPath		:= ""
	Local cArquivo		:= ""
	local oXml := nil
	
	default cID      := ""
	default cError   := ""
	default cWarning := ""
	default nPed     := 0 

	//Monta caminho do arquivo
	cRootPath	:= "\" + CurDir()	//Pega o diretorio do RootPath
	cRootPath	+= "vendas_site\"
	If Len( cID ) <= 18
		cArquivo	:= "Pedidos_" + Left(cID,12) + ".XML"
	Else
		cArquivo	:= "Pedidos_" + Left(cID,17) + ".XML"
	EndIf
	cArquivo	:= cRootPath + cArquivo

	//Monta xml com base em arquivo fisico gravado no servidor
	oXml := XmlParserFile( cArquivo, "_", @cError, @cWarning )
	
	if empty( cError)
		If Valtype(oXml:_LISTPEDIDOFULLTYPE:_PEDIDO) <> "A"
			XmlNode2Arr( oXml:_LISTPEDIDOFULLTYPE:_PEDIDO, "_PEDIDO" )
		EndIf

		nPed := Val( Right( alltrim( cID ), 6 ) )
	else  //conout("[VNDA190-VOUCHER] Arquivo xml não foi encontrado. Error: "+cError)
	    U_GTPutOUT(cID,"V",cPedLog,{"VNDA190",{.F.,"E00012",cPedLog,"Arquivo xml Error: "+cError},"Faturamento da Venda de Produtos do Pedido "+cPedLog},cPedSite)
	endif
return oXml

static function getIdGtIn( cPedSite )
	local cQuery := ""
	local cAlias := ""
	local oQuery := nil

	cQuery := "SELECT GT_ID, GT_PEDGAR "
	cQuery += "FROM GTIN "
	cQuery += "WHERE GT_TYPE = 'F' "
	cQuery += "		AND D_E_L_E_T_ = ' ' "	
	cQuery += "		AND GT_XNPSITE IN ('"+ alltrim( cPedSite )+ "')"
		
	oQuery := CSQuerySQL():New()
	if oQuery:Consultar( cQuery )
		cAlias  := oQuery:GetAlias() //Alias da tabela temporaria
		cID := AllTrim( (cAlias)->GT_ID )
		( cAlias )->( dbCloseArea() )
	endif			
return cID

/* 
Data criação 11/06/2021
função para bloquear e desbloquear vendedor
Parametros: cBloqDblq - 1 desbloqueia 
                        2 - Bloqueia
			cVend 	- Codigo do vendedor a bloquear ou desbloquear
*/
Static Function BqlDblqVen(cBloqDblq,cVend)
Local lRet	:= .f.
Local aAreaTTT := GetArea()
Local aAreaSA3 := sa3->(GetArea())

   sa3->(DbSetOrder(1))
   if sa3->(DbSeek(xFilial()+cVend)) .and. sa3->a3_msblql == cBloqDblq
	  sa3->( RecLock( 'SA3',.F.) )
	  sa3->a3_msblql := iif(cBloqDblq=='1','2','1')
	  sa3->( MsUnlock() )
	  lRet := .t.
   endIf

  RestArea(aAreaSA3)
  RestArea(aAreaTTT)
Return lRet
