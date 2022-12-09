#Include "RWMAKE.CH"      
#Include "TOPCONN.CH"
#Include "Protheus.Ch"
#include "TbiConn.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TK271END  º Autor ³Mateus Hengle       º Data ³ 23/10/2013  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³PE que grava campos customizados DEPOIS da geracao do PV    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³ 													          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function TK271END() 
Local aAreaSC5	:= SC5->(GetArea())
Local aAreaSC6 	:= SC6->(GetArea())
//Local nOpc 	:= ParamIXB[1]
Local _lRet 	:= .T.
Local _nPosTotal:= aScan(aHeader,{|x| AllTrim(x[2])=="UB_VLRITEM"})
Local _nPosUnit := aScan(aHeader,{|x| AllTrim(x[2])=="UB_VRUNIT"})
Local _nPosProd := aScan(aHeader,{|x| AllTrim(x[2])=="UB_PRODUTO"})
Local _nPosDesc := aScan(aHeader,{|x| AllTrim(x[2])=="UB_DESC"})
Local _nPosVlDes:= aScan(aHeader,{|x| AllTrim(x[2])=="UB_VALDESC"})
Local _nPosQtdVe:= aScan(aHeader,{|x| AllTrim(x[2])=="UB_QUANT"})
Local _nPosOpcio:= aScan(aHeader,{|x| AllTrim(x[2])=="UB_OPC"})
Local _nPosTES  := aScan(aHeader,{|x| AllTrim(x[2])=="UB_TES"})
Local nPosDel	:= Len(aHeader)+1
Local _N        := N //Guarda posicao atual da GetDados
Local cOper     := M->UA_OPER 
Private cNumAT  := M->UA_NUM 
Private cNumber := M->UA_NUMSC5 // Se estiver VAZIO esta ALTERANDO PARA UM PEDIDO, Se estiver PREENCHIDO JA E UM PEDIDO  
Private nPedCli := 1   
Private cFCICOD := ""
      
If Empty(_nPosUnit)
	Return .t.
Endif

U_GravaObs(cOper)

/*If FindFunction("U_RFATG01")
	lSenha := .t.
	For nI := 1 to Len(aCols)
		n := nI
		If !aCols[nI][nPosDel]
			nPrcVen	:= aCols[nI][_nPosUnit]    
			cOpcion := aCols[nI][_nPosOpcio]
			cTes	:= aCols[nI][_nPosTES]
			
			// Se a Tes Não Gerar Duplicata então Ignora Informação da Tabela
		
			If SF4->(dbSetOrder(1), dbSeek(xFilial("SF4")+cTES))
				If SF4->F4_DUPLIC <> 'S'
					Loop
				Endif
			Endif
			
			nPrcRet := U_RFATG01(2,.f.,.f.,.t.) // Igual a 1 Retorna Quantidade, Igual a 2 Retorna Valor Unitario, Posicionar
			
			If nPrcVen < nPrcRet .And. lSenha // Se Valor Unitario For Menor que o Valor Calculado Então Irá Solicitar senha de Supervisor para Liberacao
											 	// e ainda nao pediu senha então solicita senha
				If MsgYesNo("Atenção, Linha " + Str(nI,3) + " Valor Divergente Encontrado, Para Valor Abaixo do Calculado na Tabela de Quantidades Informar a Senha do Supervisor",Capital(SM0->M0_NOMECOM))
					If AllTrim(u_PassLib()) == AllTrim(SuperGetmv("MV_PASSLIB",.F.,'mtl1234@'))
						_lRet := .t.
						lSenha := .f.
			
						aCols[nI,_nPosUnit]	:=	nPrcVen
	//					aCols[nI,aScan(aHeader,{|x| Alltrim(x[2])== "C6_PRCVEN"})]	:=	FtDescCab(nPrcVen,{M->C5_DESC1,M->C5_DESC2,M->C5_DESC3,M->C5_DESC4})
						aCols[nI,_nPosTotal]	:=	A410Arred(aCols[nI,_nPosQtdVe] * aCols[nI,_nPosUnit],"UB_VLRITEM")
					Else
						Alert("Senha incorreta!!!")
						_lRet := .f.
					EndIf 
				Else
					_lRet := .f.
				EndIf 		
			Endif
	    Endif
	Next		
	n := _N
	If !_lRet
		MsgInfo("Houve Problemas na Digitação dos Valores ou Senha do Supervisor Informada Incorretamente",;
			"Gravação Bloqueada!")
		
	EndIf
Endif */
RestArea(aAreaSC5)
RestArea(aAreaSC6)

dEntCab := CtoD('')
If SUA->(dbSetOrder(1), dbSeek(xFilial("SUA")+cNumAT))
	dEntCab := SUA->UA_FECENT
Endif

// Iguala Preco de Tabela ao Valor Unitario do Item
// 3L Systems - 15-07-2014 - Luiz Alberto
	
If SUB->(dbSetOrder(1), dbSeek(xFilial("SUB")+cNumAT))
	While SUB->(!Eof()) .And. SUB->UB_FILIAL == xFilial("SUB") .And. SUB->UB_NUM == cNumAT
		If SUB->UB_DTENTRE > dEntCab
			dEntCab := SUB->UB_DTENTRE
		Endif	
	
		If SUB->UB_PRCTAB <> SUB->UB_VRUNIT
			If RecLock("SUB",.f.)
				SUB->UB_PRCTAB := SUB->UB_VRUNIT
				SUB->(MsUnlock())
			Endif
		Endif
			
		SUB->(dbSkip(1))
	Enddo
Endif

// Ajusta data de Entrega do Cabecalho

If RecLock("SUA",.F.)
	SUA->UA_FECENT := dEntCab
	SUA->(MsUnlock())
Endif

IF cOper == '1' .AND. (INCLUI .OR. EMPTY(cNumber)) 	  // SO VAI GRAVAR SE FOR FATURAMENTO E (SE FOR INCLUSAO OU SE ESTIVER ALTERANDO PARA PEDIDO)

	U_NumLacre() 		//  INCLUSAO DE PEDIDO 
	
ELSEIF cOper == '1' .AND. !EMPTY(cNumber)  // SO SE FOR FATURAMENTO, E SE FOR ALTERACAO, E SE JA FOR UM PEDIDO

	U_AlteraPV()  // SE FOR ALTERACAO ELE GRAVA OS CAMPOS CUSTOMIZADOS, LIBERA O PV E GERA C9 NOVAMENTE 
	
ELSEIF cOper <> '1'  // SE FOR ORCAMENTO OU ATENDIMENTO GRAVA O FRETE

	
	DBSELECTAREA("SUA")
	DBSETORDER(1)
	IF DBSEEK(XFILIAL("SUA") + cNumAT)
   		RecLock("SUA",.F.)
  		SUA->UA_FRETE   := M->UA_FRETE 
		SUA->UA_DTLIM   := M->UA_DTLIM 
		If cEmpAnt == '01'	// Apenas Metalacre
			SUA->UA_TBMTL  	:= GetMV("MV_TBQPAD")
		Endif
   		MsUnlock()
	ENDIF                              

ENDIF

If cOper == '1' // Gerou Pedido de Venda e Já Esta Posicionado
	// Analisa se Orçamento em Questão, o Cliente possui Contrato de Parceria e se o Vendedor deseja associar o pedido ao contrato
	
	// Alimenta Empenho no Contrato de Parceria
	// Pausado conforme solicitação do Divino

/*	lAchouCtr := .f.                      
	lAssociou := .f.                                      
	cCliente	:=	Space(06)
	cLoja		:=	Space(02)
	If ADA->(dbSetOrder(2), dbSeek(xFilial("ADA")+SUA->UA_CLIENTE+SUA->UA_LOJA))
		cCliente	:=	ADA->ADA_CODCLI
		cLoja       :=  ADA->ADA_LOJCLI
		
		lAchouCtr := .t.
	Else
		If ADA->(dbSetOrder(2), dbSeek(xFilial("ADA")+SUA->UA_CLIENTE))
			cCliente	:=	ADA->ADA_CODCLI
			cLoja       :=  ''
			lAchouCtr := .t.
		Endif
	Endif

	If lAchouCtr
		If MsgYesNo("Atenção Este Cliente Possui Contrato de Parceria, Deseja Amarrar o Pedido Gerado para Baixa do Contrato ?") 
			If SC6->(dbSetOrder(1), dbSeek(xFilial("SC6")+SC5->C5_NUM))
				While SC6->(!Eof()) .And. SC6->C6_FILIAL == xFilial("SC6") .And. SC6->C6_NUM == SC5->C5_NUM
					If ADB->(dbSetOrder(2), dbSeek(xFilial("ADB")+ADA->ADA_CODCLI+Iif(!Empty(cLoja),cLoja,ADA->ADA_LOJCLI)+SC6->C6_PRODUTO))
						cItem := ''
						While ADB->(!Eof()) .And. ADB->ADB_FILIAL == xFilial("ADB") .And. ADB->ADB_NUMCTR == ADA->ADA_NUMCTR .And. ADB->ADB_CODPRO == SC6->C6_PRODUTO
							If (ADB->ADB_QUANT-(ADB->ADB_QTDEMP + ADB->ADB_QTDENT)) >= SC6->C6_QTDVEN
								cItem := ADB->ADB_ITEM
								Exit
							Endif
							ADB->(dbSkip(1))
						Enddo
						
						If !Empty(cItem)
							lAssociou := .t.
							If RecLock("SC6",.f.)
								SC6->C6_CONTRAT	:= ADB->ADB_NUMCTR
								SC6->C6_ITEMCON	:= cItem
								SC6->(MsUnlock())
							Endif                    
							
                        	// Empenha Material no Contrato de Parceria
						
							If RecLock("ADB",.f.)
								ADB->ADB_QTDEMP	:=	SC6->C6_QTDVEN
								ADB->(MsUnlock())
							Endif
							
						Endif
					Endif
					
					SC6->(dbSkip(1))
				Enddo
			Endif

			// Registra Associacao no Orcamento e No Pedido de Vendas

			If SUA->(FieldPos("UA_NUMCTR")) > 0 .And. SC5->(FieldPos("C5_CONTRA")) > 0
			    If RecLock("SUA",.f.)
			    	SUA->UA_NUMCTR	:=	ADA->ADA_NUMCTR
			    	SUA->(MsUnlock())
			    Endif
			    
			    If RecLock("SC5",.f.)
			    	SC5->C5_CONTRA	:=	ADA->ADA_NUMCTR
			    	SC5->(MsUnlock())
			    Endif
			Endif
			
			If !lAssociou
				MsgStop("Atenção, Não Houve Associação com Contrato, Talvez por Itens Não Coincidirem ou Falta de Saldo Para Remessa ! - Contrato No.: " + ADA->ADA_NUMCTR + " Verifique !")
			Else                                                                                                                                                                            
				MsgInfo("Associação com o Contrato No.: " + ADA->ADA_NUMCTR + " Efetuada Com Sucesso !")
			Endif			
		Endif
	Endif

	*/

	// Tratamento de Vendedores - 3L Systems -- 31-07-2014
	
	If !Empty(SC5->C5_NOTA)
		Return
	Endif

	// Atualização Campo EMAIL1 (Financeiro) Cadastro de Cliente
	
	If Empty(SA1->A1_EMAIL1)
		U_AtuMailCli()
	Endif
	
	// Atualiza o campo PedCli
	
	U_GrvPedCli()
	
	cVend1 := SC5->C5_VEND1
	nComi1 := SC5->C5_COMIS1
	cVend2 := SC5->C5_VEND2
	nComi2 := SC5->C5_COMIS2
	cVend3 := SC5->C5_VEND3
	nComi3 := SC5->C5_COMIS3
	
	If SC5->C5_TIPO == 'N' //.And. //!SC5->C5_CLIENTE+SC5->C5_LOJACLI$GetNewPar("MV_MTLCVN",'00132001*01140401')	// Clientes que Não Entram na Condicao
		If SC5->(FieldPos("C5_PEDWEB")) > 0
			If Empty(SC5->C5_PEDWEB)	// Se O Pedido Não For Sealbag
				nSa1Rec := SA1->(Recno())
/*				
				// Se o Cliente For MetalSeal ou MPM Entao Trata Vendedor

				If SC5->C5_CLIENTE+SC5->C5_LOJACLI$GetNewPar("MV_MTLCVN",'00132001*01140401') .And. !Empty(SC5->C5_CLIMTS)
					SA1->(dbSetOrder(1), dbSeek(xFilial("SA1")+SC5->C5_CLIMTS+SC5->C5_LOJMTS))
					If !Empty(SA1->A1_VEND) .And. SA1->A1_VEND <> cVend1 // Prioridade Vendedor no Cliente
						cVend1 := SA1->A1_VEND
					Endif                        
				Endif
	*/			
				SA1->(dbGoTo(nSa1Rec))

				If SA3->(dbSetOrder(1), dbSeek(xFilial("SA3")+cVend1))
					If SA1->A1_COD=='001320'	// MetalSeal
						nComi1 := Iif(!Empty(SA3->A3_XCOMIS2),SA3->A3_XCOMIS2,SA3->A3_COMIS)
					ElseIf SA1->A1_COD=='011404'	// MPM
						nComi1 := Iif(SA3->(FieldPos("A3_XCOMIS3"))>0 .And. !Empty(SA3->A3_XCOMIS3),SA3->A3_XCOMIS3,SA3->A3_COMIS)
					Else 
						nComi1 := SA3->A3_COMIS
					Endif
					//nComi1 := Iif(SA1->A1_COD+SA1->A1_LOJA$GetNewPar("MV_MTLCVN",'00132001*01140401') .And. !Empty(SA3->A3_XCOMIS2),SA3->A3_XCOMIS2,SA3->A3_COMIS)
					cVend2 := SA3->A3_SUPER
					cVend3 := SA3->A3_GEREN
				Endif
				
				If !Empty(cVend2)
					If SA3->(dbSetOrder(1), dbSeek(xFilial("SA3")+cVend2))
						If SA1->A1_COD=='001320'	// MetalSeal
							nComi2 := Iif(!Empty(SA3->A3_XCOMIS2),SA3->A3_XCOMIS2,SA3->A3_COMIS)
						ElseIf SA1->A1_COD=='011404'	// MPM
							nComi2 := Iif(SA3->(FieldPos("A3_XCOMIS3"))>0 .And. !Empty(SA3->A3_XCOMIS3),SA3->A3_XCOMIS3,SA3->A3_COMIS)
						Else 
							nComi2 := SA3->A3_COMIS
						Endif
//						nComi2 := Iif(SA1->A1_COD+SA1->A1_LOJA$GetNewPar("MV_MTLCVN",'00132001*01140401') .And. !Empty(SA3->A3_XCOMIS2),SA3->A3_XCOMIS2,SA3->A3_COMIS)
					Endif
				Endif
				If !Empty(cVend3)
					If SA3->(dbSetOrder(1), dbSeek(xFilial("SA3")+cVend3))
						If SA1->A1_COD=='001320'	// MetalSeal
							nComi3 := Iif(!Empty(SA3->A3_XCOMIS2),SA3->A3_XCOMIS2,SA3->A3_COMIS)
						ElseIf SA1->A1_COD=='011404'	// MPM
							nComi3 := Iif(SA3->(FieldPos("A3_XCOMIS3"))>0 .And. !Empty(SA3->A3_XCOMIS3),SA3->A3_XCOMIS3,SA3->A3_COMIS)
						Else 
							nComi3 := SA3->A3_COMIS
						Endif
//						nComi3 := Iif(SA1->A1_COD+SA1->A1_LOJA$GetNewPar("MV_MTLCVN",'00132001*01140401') .And. !Empty(SA3->A3_XCOMIS2),SA3->A3_XCOMIS2,SA3->A3_COMIS)
					Endif
				Endif
								
				If RecLock("SC5",.f.)
					SC5->C5_XOPCCOM :=	Iif(SA1->A1_COD+SA1->A1_LOJA$GetNewPar("MV_MTLCVN",'00132001*01140401'),'S','N')
					SC5->C5_VEND1 := cVend1
					SC5->C5_COMIS1:= nComi1
					SC5->C5_VEND2 := cVend2
					SC5->C5_COMIS2:= nComi2
					SC5->C5_VEND3 := cVend3
					SC5->C5_COMIS3:= nComi3
					SC5->(MsUnlock())
				Endif
			Else 			// pedido sealbag, limpar supervisor e gerente
				cVend1	:= GetNewPar("MV_MLVEND",'000020')		
				If SA3->(dbSetOrder(1), dbSeek(xFilial("SA3")+cVend1))
					nComi1 := SA3->A3_COMIS
				Endif
				If RecLock("SC5",.f.)
					SC5->C5_VEND1 := cVend1
					SC5->C5_COMIS1:= nComi1
					SC5->C5_VEND2 := ''
					SC5->C5_COMIS2:= 0
					SC5->C5_VEND3 := ''
					SC5->C5_COMIS3:= 0
					SC5->(MsUnlock())
				Endif
			Endif
		Endif

	/*	cVend1 := SC5->C5_VEND1
		nComi1 := SC5->C5_COMIS1
		cVend2 := SC5->C5_VEND2
		nComi2 := SC5->C5_COMIS2
		cVend3 := SC5->C5_VEND3
		nComi3 := SC5->C5_COMIS3

		If RecLock("SUA",.f.)
			SUA->UA_VEND  := cVend1
			SUA->UA_COMIS := nComi1
			SUA->UA_VEND2 := cVend2
			SUA->UA_COMIS2:= nComi2
			SUA->UA_VEND3 := cVend3
			SUA->UA_COMIS3:= nComi3
			SUA->(MsUnlock())
		Endif		*/
	Endif		

	// Gera Pedidos em Outras Empresas Caso Esteja Parametrizado

	If GetEnvServer()$"VALIDACAO*HOMOLOGACAO"

		//IncPed()

	Endif
	
	////////////////////////////////////////////////////
Endif

Return 

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ NumLacre º Autor ³Mateus Hengle       º Data ³ 21/10/2013  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Funcao que Grava alguns campos customizados via RECLOCK	  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³ INCLUSAO				          							  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function NumLacre()
Local aArea := GetArea()
Local cMostra  := 0 
Private cNum   := SC5->C5_NUM // NESTE MOMENTO O PEDIDO JA FOI GERADO, E POR ISSO PEGA O NUM DO PV POSICIONADO 


//If AllTrim(Upper(GetEnvServer()))$'VALIDACAO'

	// 3lSystems - Teste de Antecipação de Pagamento - 08-05-2014
	
	SE4->(dbSetOrder(1), dbSeek(xFilial("SE4")+SC5->C5_CONDPAG))
	
	If A410UsaAdi( SC5->C5_CONDPAG ) .And. SE4->E4_CTRADT=='1'	// Condição de Pagamento Aceita Adiantamento
		cNumPedido:= SC5->C5_NUM
		nRecSC6   := SC6->(Recno())

		// Busca Total do Pedido de Venda
		
		SC6->(dbSetOrder(1), dbSeek(xFilial("SC6")+cNumPedido))
		cTes	  := SC6->C6_TES
		nTotalPed := 0
		nItem     := 1          
		While SC6->(!EOF()) .And. SC6->C6_NUM == cNumPedido
     		nTotalPed += SC6->C6_VALOR                     
     		nItem++
     		
     		SC6->(dbSkip(1))
  		Enddo
  		SC6->(dbGoTo(nRecSC6))

		aRecnoSE1 := {}
		cCodCli	  := SC5->C5_CLIENTE
		cCodLoja  := SC5->C5_LOJACLI
		lGravaRelacao := .t.
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Chamada da tela de Recebimento do Financeiro.³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ   	
		aRecnoSE1 := FPEDADT("R", SC5->C5_NUM, nTotalPed, aRecnoSE1, cCodCli, cCodLoja, cTes, nItem)	
		If Len(aRecnoSE1) > 0 .AND. lGravaRelacao
			// Grava quando é proveniente da Nota.
			FPedAdtGrv( "R", 1, cNumPedido, aRecnoSE1 )
		EndIf	
	EndIf                   
	RestArea(aArea)
//Endif

DBSELECTAREA("SUA")
DBSETORDER(8)
IF DBSEEK(XFILIAL("SUA") + cNum) // POSICIONA NO REGISTRO QUE ACABOU DE SER GRAVADO   - GRAVA CABECALHO
	RecLock("SC5",.F.)
	SC5->C5_ESPECI1  := SUA->UA_ESPECI1     // GRAVA CAMPOS NA SC5
	SC5->C5_FECENT   := SUA->UA_FECENT     
	SC5->C5_NOMECLI  := SUA->UA_NOMECLI 
	SC5->C5_XOPCCOM	 := SUA->UA_XOPCCOM 
	
	SC5->C5_VEND1	 := SUA->UA_VEND 
	SC5->C5_COMIS1	 := SUA->UA_COMIS
	SC5->C5_VEND2    := SUA->UA_VEND2 
	SC5->C5_COMIS2   := SUA->UA_COMIS2
	SC5->C5_VEND3    := SUA->UA_VEND3 
	SC5->C5_COMIS3   := SUA->UA_COMIS3
		
	If SC5->(FieldPos("C5_XOBSCPL")) > 0
		SC5->C5_XOBSCPL	 :=	SUA->UA_XOBSCPL
	Endif
	SC5->C5_CLIMTS	 :=	SUA->UA_CLIMTS
	SC5->C5_LOJMTS	 :=	SUA->UA_LOJMTS
	SC5->C5_XOBSFAT	 :=	SUA->UA_XOBSFAT
	SC5->C5_OBSCLI	 :=	SUA->UA_OBSCLI
	SC5->C5_OBSOP	 :=	SUA->UA_OBSOP
	SC5->C5_TEMOP	 :=	SUA->UA_TEMOP
	SC5->C5_PESOL	 :=	SUA->UA_PESOL
	SC5->C5_PBRUTO	 :=	SUA->UA_PBRUTO
	SC5->C5_VOLUME1	 :=	SUA->UA_VOLUME1
	SC5->C5_MENPAD	 :=	SUA->UA_MENPAD
	SC5->C5_MENNOTA	 :=	SUA->UA_XMENNOT
	SC5->C5_CLIENT	 :=	SUA->UA_XCLIENT
	SC5->C5_LOJAENT	 :=	SUA->UA_XLOJAEN
	SC5->C5_FRETE	 :=	SUA->UA_FRETE
	SC5->C5_TPFRETE	 := SUA->UA_TPFRETE 
	SC5->C5_LIBEROK  := 'S'   		// CAMPO QUE MUDA A COR DA LEGENDA PARA LIBERADO( DE VERDE PARA AMARELO)
	SC5->C5_NUMAT    := cNumAt
	MsUnlock()
ENDIF

DBSELECTAREA("SUA")
DBSETORDER(8)
IF DBSEEK(XFILIAL("SUA") + cNum) // POSICIONA NO REGISTRO QUE ACABOU DE SER GRAVADO   - GRAVA CABECALHO
	RecLock("SUA",.F.)
	SUA->UA_LIBERA  := 'S'   		// CAMPO QUE MUDA A COR DA LEGENDA PARA LIBERADO( DE VERDE PARA AMARELO)
//	SUA->UA_FRETE   := M->UA_FRETE 
//	SUA->UA_DTLIM   := M->UA_DTLIM 
	If cEmpAnt == '01'	// Apenas Metalacre
		SUA->UA_TBMTL  	:= GetMV("MV_TBQPAD")
	Endif
	MsUnlock()
ENDIF
  
// QUERY QUE TRAZ OS ITENS DA SC6 PARA SER GRAVADO OS ITENS
cQry:= " SELECT *"
cQry+= " FROM "+RETSQLNAME("SC6")+" SC6"
cQry+= " WHERE C6_NUM = '"+cNum+"' "
cQry+= " AND SC6.D_E_L_E_T_='' "
cQry+= " ORDER BY C6_ITEM"

If Select("TRF") > 0
	TRF->(dbCloseArea())
EndIf

// Tratamento de Lotes, Caixas - 10-07-2014 - 3L Systems

lCxLote := (SC6->(FieldPos("C6_XQTLOT")) > 0) // Se o Campo Estiver Criado Entao Faz o Tratamento

nLoteIni	:= 1
nCaixas		:= 0

TCQUERY cQry New Alias "TRF"    // LACO PARA GRAVAR NOS CAMPOS DE TODOS OS ITENS DO PEDIDO
While TRF->(!EOF())
	
	cNumX := TRF->C6_NUM
	cItem := TRF->C6_ITEM
	cProd := ALLTRIM(TRF->C6_PRODUTO)
	nQtde := TRF->C6_QTDVEN 
	
	//cPed  := TRF->C6_PEDCLI
	//cPedCli := ALLTRIM(SUBSTR(cPed, 4, 6))
	
	DBSELECTAREA("SUB")
	DBSETORDER(4)
	IF DBSEEK(XFILIAL("SUB") + cNumX + cItem + cProd)     // POSICIONA NO ITEM DO ATENDIMENTO
	
		SB1->(dbSetOrder(1), dbSeek(xFilial("SB1")+cProd))
	
		cLacre  := UB_XLACRE
		cEmbala := UB_XEMBALA 
		cCodApl := UB_XAPLIC
		cAplica := UB_XAPLICA 
		cVolume := UB_XVOLITE
		nPrcTab := Iif(SUB->(FieldPos("UB_XTAB"))>0,SUB->UB_XTAB,0)
		cItemAT := UB_ITEM
		cStand  := UB_XSTAND
		cPesoB  := UB_XPBITEM 
		cPesoL  := UB_XPLITEM
		cITcli  := UB_ITEMCLI 
		xLacreX := UB_XINIC
		xLacreZ := UB_XFIM
		cOpc    := UB_OPC
		cPedcli := SUB->UB_PEDCLI
		cDescri := Iif(!Empty(SUB->UB_XDESCR),SUB->UB_XDESCR,SB1->B1_DESC)
		
		cNumOP  := UB_NUMOP   // PEGA O NUMERO DA OP - AJUSTE EM 07/04/14
		cItemOP := UB_ITEMOP     
		cFCICOD := UB_FCICOD
	
	ENDIF  
	
	DBSELECTAREA("SUA")
	DBSETORDER(8)
	IF DBSEEK(XFILIAL("SUA") + cNum) 
		IF cStand == '1'
   	   		RecLock("SUA",.F.)
   	   		SUA->UA_TEMOP  := 'S'   		// CAMPO QUE MUDA A COR DA LEGENDA PARA LIBERADO( DE VERDE PARA AMARELO)
			If cEmpAnt == '01'	// Apenas Metalacre
	   	   		SUA->UA_TBMTL  	:= GetMV("MV_TBQPAD")
	 		Endif
   	  		MsUnlock()
   	  	ENDIF	
	ENDIF
		
	DBSELECTAREA("SC6")   // Ajuste feito em 14-01-14
	DBSETORDER(1)
	IF DBSEEK(XFILIAL("SC6") + cNumX + cItem + cProd)  

		RecLock("SC6",.F.)   // GRAVA CAMPOS NA TABELA SC6
   		SC6->C6_XLACRE  := cLacre
   		SC6->C6_XEMBALA := cEmbala
   		SC6->C6_XAPLC   := cCodApl
   		SC6->C6_XAPLICA := cAplica
   		SC6->C6_XVOLITE := cVolume
   		SC6->C6_XSTAND  := cStand 
		SC6->C6_XPBITEM := cPesoB
   		SC6->C6_XPLITEM := cPesoL
   		SC6->C6_QTDLIB  := nQtde
		SC6->C6_QTDLIB2 := nQtde
		SC6->C6_PRUNIT	:= SC6->C6_PRCVEN		// IGUALA PRECO DE TABELA AO PRECO VENDIDO
		SC6->C6_PEDCLI  := cPedCli
		If SC6->(FieldPos("C6_XTAB")) > 0
			SC6->C6_XTAB	:=	nPrcTab
		Endif
   		SC6->C6_XINIC:= xLacreX
		SC6->C6_XFIM := xLacreZ  // MATEUS - AJUSTE FEITO EM 02/04/14 PRA GRAVAR O LACRE QUANDO O PEDIDO EH STAND BY
   		
   		SC6->C6_ITEMCLI := cITcli 
   		SC6->C6_OPC     := cOpc
   		
   		SC6->C6_NUMOP  := cNumOP	// GRAVA O NUMERO DA OP QUANDO FOR STAND BY - AJUSTE EM 07/04/14
		SC6->C6_ITEMOP := cItemOP   
		SC6->C6_FCICOD := cFCICOD
		SC6->C6_DESCRI := cDescri
   		
		If lCxLote	// Tratamento de Numeracao Caixas e Lotes
			Z06->(dbSetOrder(1), dbSeek(xFilial("Z06")+SC6->C6_XEMBALA))
			Z01->(dbSetOrder(1), dbSeek(xFilial("Z01")+SC6->C6_XLACRE+SC6->C6_NUM+SC6->C6_ITEM))

			nVlLote	:= Iif(Empty(SC6->C6_XQTLOT),100,SC6->C6_XQTLOT)
			nSaldo  := SC6->C6_QTDVEN
		    nQtLote := Int(Min(nSaldo,Z06->Z06_QTDMAX)/nVlLote)

		    For nEtiq := 1 To SC6->C6_XVOLITE
		    	++nCaixas
		    	If nEtiq == 1
		    		SC6->C6_XCXDE	:= nCaixas
		    		SC6->C6_XLOTI 	:= nLoteIni
		    	Endif
		    	
		    	nLoteIni	+= 	CEILING(Min(nSaldo,Z06->Z06_QTDMAX)/nVlLote)
				nSaldo		-=	Min(SC6->C6_QTDVEN,Z06->Z06_QTDMAX)
			Next                                      
    		SC6->C6_XCXAT	:= nCaixas
    		SC6->C6_XLOTF 	:= (nLoteIni-1)
	    Endif

		MsUnlock() 

		aAreaSC5	:= SC5->(GetArea())
		aAreaSC6	:= SC6->(GetArea())
		aAreaSC9	:= SC9->(GetArea())
		aAreaSA1	:= SA1->(GetArea())
		
		If cEmpAnt == '01'
			If Empty(SC5->C5_PEDWEB)
				U_CargaPed(SC6->C6_NUM,SC6->C6_ITEM,SC6->C6_PRODUTO) // Ajusta Saldo Carga Fabrica
			Endif
		Endif
											
		RestArea(aAreaSC5)
		RestArea(aAreaSC6)
		RestArea(aAreaSC9)
		RestArea(aAreaSA1)


	ENDIF
	
	MaLibdoFat(SC6->(RECNO()),nQtde,,,.T.,.T.,.F.,.F.) // FUNCAO QUE GERA A SC9 DOS ITENS PARA LIBERACAO DO PEDIDO
	
	IF xLacreX == 0 .AND. xLacreZ == 0   // VERIFICA SE JA EH UM PV, SE SIM NAO CALCULA O LACRE 
			cMostra := 1
			U_CalcLacre(cNumX, cItem, cProd, nQtde, cLacre, cNumAT, cItemAT) // FUNCAO QUE CALCULA A NUMERACAO DOS LACRES 
	ENDIF 
	
	IF cStand == '1'    // SE FOR PV STAND BY NAO CALCULA O LACRE, SO GRAVA OQUE BUSCOU NA TABELA
		cMostra := 1
	    U_Standby(cNumX, cItem, cProd, nQtde, cLacre, cNumAT, cItemAT, xLacreX, xLacreZ) // SE FOR STAND BY 
 	ENDIF
	

	TRF->(DbSkip())
ENDDO

	U_GrvPedCli() 	
	
	IF cMostra == 1
		MsgInfo("O Pedido de venda numero:  "+cNum+" foi GERADO com sucesso  !","","")
    ENDIF  

	// Grava Total no Pedido de Vendas
	
//	U_TotPed(cNum)
    
	lCredito := .f.
	If SC9->(dbSetOrder(1), dbSeek(xFilial("SC9")+cNum))
		While SC9->(!Eof()) .And. SC9->C9_FILIAL == xFilial("SC9") .And. SC9->C9_PEDIDO == cNum
			If SC9->C9_BLCRED $ '01*02*04*05*06'
				lCredito	:=	.t.
			Endif
			
			SC9->(dbSkip(1))
		Enddo
	Endif
		
	SC5->(dbSetOrder(1), dbSeek(xFilial("SC5")+cNum))

	// Se For a Tela de Atendimento Telemarketing então não é orçamento retorna verdadeiro
	If lCredito .And. SC5->C5_TIPO == 'N' // Apenas Pedidos Normais
		U_PrcWrkFin(SC5->C5_NUM)
	Endif

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CalcLacre º Autor ³Mateus Hengle       º Data ³ 21/10/2013  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Funcao que Calcula o Lacre Inicial e Final				  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³ 													          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function CalcLacre(cNumX, cItem, cProd, cQtde, cLacre, cNumAT, cItemAT)

Private Z00LACRE   := ""
Private Z00LACREXX := "" 
Private xLacreIni  := ""
Private xLacreFim  := ""

IF !EMPTY(cLacre) // SE O CAMPO LACRE ESTIVER VAZIO ELE NAO CALCULA A NUMERACAO
	
	DbSelectArea("Z00")
	Z00LACRE := Posicione("Z00",1,xFilial("Z00")+cLacre,"Z00_LACRE")	
//	Z00LACRE := GETADVFVAL("Z00","Z00_LACRE",xFilial("Z00")+ cLacre, 1, "") //SE FOR LACRE NOVO PEGA O NUMERO NA Z00 - AJUSTE FEITO EM 26-03-14 
	
	DbSelectArea("Z01")
	Z01->(DBGOTOP())
	
	RecLock("Z01",.T.)
	Z01->Z01_FILIAL	:= xFilial("Z01") // INCLUI UMA LINHA DE REGISTRO COM A NUMERACAO DO LACRE QUE FOI GERADA
	Z01->Z01_COD	:= cLacre
	Z01->Z01_PV		:= cNumX
	Z01->Z01_ITEMPV	:= cItem
	Z01->Z01_STAT	:= "1"
	Z01->Z01_PROD	:= cProd
	Z01->Z01_INIC	:= Z00LACRE
	Z01->Z01_FIM	:= Z00LACRE + nQtde -1
	Z01->Z01_NUMAT  := cNumAT  // CRIAR ESTE CAMPO NA BASE PRODUCAO
	Z01->Z01_NUMERO := SOMA1(U_GETSOMA('Z01','Z01_NUMERO',,'Z01_FILIAL',XFILIAL("Z01"),,,,, 'M'))
	If Z01->(FieldPos("Z01_LOGINT")) > 0
		Z01->Z01_LOGINT := UsrFullName(__cUserId)+' em '+DtoC(dDataBase)+' as '+Left(Time(),5)
	Endif
	Z01->(MsUnlock())
	
	Z00LACREXX := Z00LACRE + nQtde -1
	
	DbSelectArea("Z00")
	DbSetOrder(1)
	IF DbSeek(xFilial("Z00")+ cLacre)
		RecLock("Z00",.F.)
		Z00->Z00_LACRE := Z00LACREXX +1  // GRAVA O PROXIMO NUMERO DO LACRE A SER GRAVADO
		Z00->(MsUnlock())
	ENDIF
		
//	U_ChkLacre(Z00->Z00_COD)

	xLacreIni := Z00LACRE
	xLacreFim := Z00LACREXX
	
	DBSELECTAREA("SUB")
	DBSETORDER(1)
	IF DBSEEK(XFILIAL("SUB") + cNumAT + cItemAT )
		RecLock("SUB",.F.)
		SUB->UB_XINIC:= xLacreIni
		SUB->UB_XFIM := xLacreFim  // GRAVA O LACRE INICIAL E FINAL NOS ITENS DA TABELA SUB
		SUB->(MsUnlock())
		
	ENDIF
	
	DBSELECTAREA("SC6")
	DBSETORDER(1)
	IF DBSEEK(XFILIAL("SC6") + cNumX + cItem )
		RecLock("SC6",.F.)   			//  GRAVA O LACRE INICIAL E FINAL NOS ITENS DA TABELA SC6
		SC6->C6_XINIC  := xLacreIni
		SC6->C6_XFIM   := xLacreFim
		SC6->(MsUnlock())
	ENDIF
	
	U_TamLacre(cNumX, cItem, cProd, cLacre, xLacreFim) // VERIFICA SE ESTOUROU A QTDE DO CAMPO LACRE
	
ENDIF

Return   

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AlteraPV  º Autor ³Mateus Hengle       º Data ³ 21/01/2014  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Grava campos customizados nas tabelas SC5 e SC6 e tambem	  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³ Gera a tabela SC9									      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function AlteraPV()
local SC2T := GETNEXTALIAS()   
Local cNum    := SC5->C5_NUM // NESTE MOMENTO O PEDIDO JA FOI GERADO, E POR ISSO PEGA O NUM DO PV POSICIONADO 
Local cLibeXX := SC5->C5_LIBEROK 

DBSELECTAREA("SUA")
DBSETORDER(8)
IF DBSEEK(XFILIAL("SUA") + cNum) // POSICIONA NO REGISTRO QUE ACABOU DE SER GRAVADO   - GRAVA CABECALHO
	RecLock("SC5",.F.)
	SC5->C5_ESPECI1  := SUA->UA_ESPECI1     // GRAVA CAMPOS NA SC5
	SC5->C5_FECENT   := SUA->UA_FECENT     
	SC5->C5_NOMECLI  := SUA->UA_NOMECLI 
	SC5->C5_XOPCCOM	 := SUA->UA_XOPCCOM 
	
	SC5->C5_CLIMTS	 := SUA->UA_CLIMTS
	SC5->C5_VEND1	 := SUA->UA_VEND 
	SC5->C5_COMIS1	 := SUA->UA_COMIS
	SC5->C5_VEND2    := SUA->UA_VEND2 
	SC5->C5_COMIS2   := SUA->UA_COMIS2
	SC5->C5_VEND3    := SUA->UA_VEND3 
	SC5->C5_COMIS3   := SUA->UA_COMIS3
		
	If SC5->(FieldPos("C5_XOBSCPL")) > 0
		SC5->C5_XOBSCPL	 :=	SUA->UA_XOBSCPL
	Endif
	SC5->C5_CLIMTS	 :=	SUA->UA_CLIMTS
	SC5->C5_LOJMTS	 :=	SUA->UA_LOJMTS
	SC5->C5_XOBSFAT	 :=	SUA->UA_XOBSFAT
	SC5->C5_OBSCLI	 :=	SUA->UA_OBSCLI
	SC5->C5_OBSOP	 :=	SUA->UA_OBSOP
	SC5->C5_TEMOP	 :=	SUA->UA_TEMOP
	SC5->C5_PESOL	 :=	SUA->UA_PESOL
	SC5->C5_PBRUTO	 :=	SUA->UA_PBRUTO
	SC5->C5_VOLUME1	 :=	SUA->UA_VOLUME1
	SC5->C5_MENPAD	 :=	SUA->UA_MENPAD
	SC5->C5_MENNOTA	 :=	SUA->UA_XMENNOT
	SC5->C5_CLIENT	 :=	SUA->UA_XCLIENT
	SC5->C5_LOJAENT	 :=	SUA->UA_XLOJAEN 
	SC5->C5_FRETE	 :=	SUA->UA_FRETE
	SC5->C5_TPFRETE	 := SUA->UA_TPFRETE
	SC5->C5_LIBEROK  := 'S'   		// CAMPO QUE MUDA A COR DA LEGENDA PARA LIBERADO( DE VERDE PARA AMARELO)
	SC5->C5_NUMAT    := cNumAt
	MsUnlock()
ENDIF   

DBSELECTAREA("SUA")
DBSETORDER(8)
IF DBSEEK(XFILIAL("SUA") + cNum) // POSICIONA NO REGISTRO QUE ACABOU DE SER GRAVADO   - GRAVA CABECALHO
	RecLock("SUA",.F.)
	SUA->UA_LIBERA  := 'S'   		// CAMPO QUE MUDA A COR DA LEGENDA PARA LIBERADO( DE VERDE PARA AMARELO) 
	SUA->UA_FRETE   := M->UA_FRETE               
	If cEmpAnt == '01'	// Apenas Metalacre
		SUA->UA_TBMTL  	:= GetMV("MV_TBQPAD")
	Endif
	MsUnlock()
ENDIF

// QUERY QUE TRAZ OS ITENS DA SC6 PARA SER GRAVADO OS ITENS
cQry:= " SELECT *"
cQry+= " FROM "+RETSQLNAME("SC6")+" SC6"
cQry+= " WHERE C6_NUM = '"+cNum+"' "
cQry+= " AND SC6.D_E_L_E_T_='' "
cQry+= " ORDER BY C6_ITEM"

If Select("TRF") > 0
	TRF->(dbCloseArea())
EndIf

// Tratamento de Lotes, Caixas - 10-07-2014 - 3L Systems

lCxLote := (SC6->(FieldPos("C6_XQTLOT")) > 0) // Se o Campo Estiver Criado Entao Faz o Tratamento

nLoteIni	:= 1
nCaixas		:= 0

TCQUERY cQry New Alias "TRF"    // LACO PARA GRAVAR NOS CAMPOS DE TODOS OS ITENS DO PEDIDO
While TRF->(!EOF())
	
	cNumX := TRF->C6_NUM
	cItem := TRF->C6_ITEM
	cProd := ALLTRIM(TRF->C6_PRODUTO)
	nQtde := TRF->C6_QTDVEN
	
	DBSELECTAREA("SUB")
	DBSETORDER(4)
	IF DBSEEK(XFILIAL("SUB") + cNumX + cItem + cProd)     // POSICIONA NO ITEM DO ATENDIMENTO
	
		SB1->(dbSetOrder(1), dbSeek(xFilial("SB1")+cProd))
	
		cLacre  := UB_XLACRE
		cEmbala := UB_XEMBALA 
		cAplica := UB_XAPLICA              	
		cVolume := UB_XVOLITE
		cItemAT := UB_ITEM
		cStand  := UB_XSTAND
		nPrcTab := Iif(SUB->(FieldPos("UB_XTAB"))>0,SUB->UB_XTAB,0)
		cPesoB  := UB_XPBITEM 
		cPesoL  := UB_XPLITEM
		cITcli  := UB_ITEMCLI 
		xLacreX := UB_XINIC
		xLacreZ := UB_XFIM
		cDescri := Iif(!Empty(SUB->UB_XDESCR),SUB->UB_XDESCR,SB1->B1_DESC) 
		cOpc    := UB_OPC
		cFCICOD := UB_FCICOD 
		cPedCli := SUB->UB_PEDCLI

	ENDIF  
	
	DBSELECTAREA("SUA")
	DBSETORDER(8)
	IF DBSEEK(XFILIAL("SUA") + cNum) 
		IF cStand == '1'
   	   		RecLock("SUA",.F.)
   	   		SUA->UA_TEMOP  := 'S'   		// CAMPO QUE MUDA A COR DA LEGENDA PARA LIBERADO( DE VERDE PARA AMARELO)
   	  		MsUnlock()
   	  	ENDIF	
	ENDIF
		
	DBSELECTAREA("SC6")   // Ajuste feito em 14-01-14
	DBSETORDER(1)
	IF DBSEEK(XFILIAL("SC6") + cNumX + cItem + cProd)  
		RecLock("SC6",.F.)   // GRAVA CAMPOS NA TABELA SC6
   		SC6->C6_XLACRE  := cLacre
   		SC6->C6_XEMBALA := cEmbala
   		SC6->C6_XAPLICA := cAplica
   		SC6->C6_XVOLITE := cVolume
   		SC6->C6_XSTAND  := cStand 
		SC6->C6_XPBITEM := cPesoB
   		SC6->C6_XPLITEM := cPesoL
   		SC6->C6_QTDLIB  := nQtde
		SC6->C6_QTDLIB2 := nQtde
   		SC6->C6_ITEMCLI := cITcli
   		SC6->C6_OPC     := cOpc
   		SC6->C6_DESCRI := cDescri
   		SC6->C6_FCICOD  := cFCICOD
		SC6->C6_PRUNIT	:= SC6->C6_PRCVEN		// IGUALA PRECO DE TABELA AO PRECO VENDIDO
		SC6->C6_XINIC  := xLacreX
		SC6->C6_XFIM   := xLacreZ
		SC6->C6_PEDCLI := cPedCli
		If SC6->(FieldPos("C6_XTAB")) > 0
			SC6->C6_XTAB	:=	nPrcTab
		Endif

		If lCxLote	// Tratamento de Numeracao Caixas e Lotes
			Z06->(dbSetOrder(1), dbSeek(xFilial("Z06")+SC6->C6_XEMBALA))
			Z01->(dbSetOrder(1), dbSeek(xFilial("Z01")+SC6->C6_XLACRE+SC6->C6_NUM+SC6->C6_ITEM))

			nVlLote	:= Iif(Empty(SC6->C6_XQTLOT),100,SC6->C6_XQTLOT)
			nSaldo  := SC6->C6_QTDVEN
		    nQtLote := Int(Min(nSaldo,Z06->Z06_QTDMAX)/nVlLote)

		    For nEtiq := 1 To SC6->C6_XVOLITE
		    	++nCaixas
		    	If nEtiq == 1
		    		SC6->C6_XCXDE	:= nCaixas
		    		SC6->C6_XLOTI 	:= nLoteIni
		    	Endif
		    	
		    	nLoteIni	+= 	CEILING(Min(nSaldo,Z06->Z06_QTDMAX)/nVlLote)
				nSaldo		-=	Min(SC6->C6_QTDVEN,Z06->Z06_QTDMAX)
			Next                                      
    		SC6->C6_XCXAT	:= nCaixas
    		SC6->C6_XLOTF 	:= (nLoteIni-1)
	    Endif
	    
		cQry:= " SELECT *"
		cQry+= " FROM "+RETSQLNAME("SD7")+" SD7"
		cQry+= " WHERE D7_LOTECTL = '"+SC6->C6_NUM+SC6->C6_ITEM+"' "
		cQry+= " AND SD7.D_E_L_E_T_='' "
		cQry+= " AND SD7.D7_TIPO = '1' "
		cQry+= " AND SD7.D7_PRODUTO = '" + SC6->C6_PRODUTO + "' "

		TCQUERY cQry New Alias "TMPIP"    // LACO PARA GRAVAR NOS CAMPOS DE TODOS OS ITENS DO PEDIDO
		
		Count To nReg
		
		If !Empty(nReg)
			SC6->C6_LOTECTL := SC6->C6_NUM+SC6->C6_ITEM
		Endif
		
		TMPIP->(dbCloseArea())


   		//SC6->C6_NUMOP   := cNumOP  
	   //SC6->C6_NUMOP   := cItemOP 
		MsUnlock() 

			
	ENDIF

	// TRATAMENTO NO CASO DE ALTERAÇÃO DE CODIGOS DE PEDIDOS ATRAVÉS DO CRM
	// NO CASO DOS LACRES

	cQuery := "SELECT Z01_COD, Z01_PROD, Z01_ITEMPV, R_E_C_N_O_ REG "
	cQuery += "FROM "+RetSqlName("Z01")+" Z01 "
	cQuery += "WHERE Z01.Z01_FILIAL='"+xFilial("SC6")+"' AND " //QUERY TRAZ O CODIGO DA PERSONALIZACAO DO PEDIDO POSICIONADO
	cQuery += "Z01.Z01_PV = '"+SC6->C6_NUM+"' AND "
	cQuery += "Z01.Z01_ITEMPV = '"+SC6->C6_ITEM+"' AND "
	cQuery += "Z01.D_E_L_E_T_<>'*' "
	dbUseArea( .T., "TOPCONN", TcGenQry( , , cQuery ), 'ZZZ01' )
	
	If !Empty(ZZZ01->Z01_PROD)
		If Alltrim(ZZZ01->Z01_PROD) <> AllTrim(SC6->C6_PRODUTO)	// Produto Foi Modificado
			Z01->(dbGoTo(ZZZ01->REG))
					
			If RecLock("Z01",.f.)
				Z01->Z01_PROD	:= SC6->C6_PRODUTO
				Z01->(MsUnlock())
			Endif
		Endif
    Endif

	ZZZ01->(dbCloseArea())
	// SE O LACRE ESTIVER PREECHIDO E O LACRE INICIAL ZERADO ELE CALCULA O LACRE
	IF !EMPTY(cLacre) .AND. xLacreX == 0
		
		U_CalcLacre(cNumX, cItem, cProd, nQtde, cLacre, cNumAT, cItemAT) 
	
	ENDIF
	
	MaLibdoFat(SC6->(RECNO()),nQtde,,,.T.,.T.,.F.,.F.) // FUNCAO QUE GERA A SC9 DOS ITENS PARA LIBERACAO DO PEDIDO
	
	TRF->(DbSkip())
ENDDO

	U_GrvPedCli() 
	
// VERIFICA OS LIBERADOS
CQRY := ""
CQRY += " SELECT C6_NUM, C6_PRODUTO, C6_ITEM FROM "
CQRY += RETSQLNAME("SC6") + " C6 "
CQRY += ", " + RETSQLNAME("SC9") + " C9 " 
CQRY += " WHERE C9.D_E_L_E_T_ = ''  AND C6.D_E_L_E_T_ = '' "
CQRY += " AND C6_NUM = C9_PEDIDO AND C6_PRODUTO = C9_PRODUTO  "
CQRY += " AND C9_ITEM = C6_ITEM  AND C9_NFISCAL = '' AND C6_LIBERAD = ''  "
//CQRY += " AND C9_BLEST = '' AND C9_BLCRED = '' "  // APENAS PEDIDOS LIBERADOS NO ESTOQUE E NO CREDITO
CQRY += " AND C9_FILIAL = '" + XFILIAL("SC9") + "' " 
CQRY += " AND C6_FILIAL = '" + XFILIAL("SC6") + "' "
DbUseArea( .t.		, "TOPCONN"		, TcGenQry(,, cQry), SC2T )   

DBSELECTAREA(SC2T)
DBGOTOP()
DO WHILE !EOF()
	lCredito := .f.
	
	If SC9->(dbSetOrder(1), dbSeek(xFilial("SC9")+(SC2T)->C6_NUM))
		While SC9->(!Eof()) .And. SC9->C9_FILIAL == xFilial("SC9") .And. SC9->C9_PEDIDO == (SC2T)->C6_NUM
			If !Empty(SC9->C9_BLCRED)
				lCredito := .t.
			Endif
			                   
			SC9->(dbSkip(1))
		Enddo     
	Else                       
		lCredito := .t.
	Endif
	
	SC5->(dbSetOrder(1), dbSeek(xFilial("SC5")+(SC2T)->C6_NUM))
		
	If lCredito
		//U_UPDCAMPO('SC6','C6_LIBERAD', "C6_NUM", (SC2T)->C6_NUM, ' ', "C6_PRODUTO", (SC2T)->C6_PRODUTO, "C6_ITEM", (SC2T)->C6_ITEM)
		
		If SC6->(FieldPos("C6_ULTACAO")) > 0
			If SC6->(dbSetOrder(1), dbSeek(xFilial("SC6")+(SC2T)->C6_NUM+(SC2T)->C6_ITEM+(SC2T)->C6_PRODUTO))
				If RecLock("SC6",.f.)
					SC6->C6_LIBERAD := ''
					SC6->C6_ULTACAO := 'Bloqueado Credito ' + DtoC(Date()) + ' as ' + Left(Time(),5)
					SC6->(MsUnlock())
				Endif

				aAreaSC5	:= SC5->(GetArea())
				aAreaSC6	:= SC6->(GetArea())
				aAreaSC9	:= SC9->(GetArea())
				aAreaSA1	:= SA1->(GetArea())
		
				If cEmpAnt == '01'
					If Empty(SC5->C5_PEDWEB)
						U_CargaPed(SC6->C6_NUM,SC6->C6_ITEM,SC6->C6_PRODUTO) // Ajusta Saldo Carga Fabrica
					Endif
				Endif
											
				RestArea(aAreaSC5)
				RestArea(aAreaSC6)
				RestArea(aAreaSC9)
				RestArea(aAreaSA1)
		
			Endif
		Endif
	Else
		//U_UPDCAMPO('SC6','C6_LIBERAD', "C6_NUM", (SC2T)->C6_NUM, 'S', "C6_PRODUTO", (SC2T)->C6_PRODUTO, "C6_ITEM", (SC2T)->C6_ITEM)
		If SC6->(FieldPos("C6_ULTACAO")) > 0
			If SC6->(dbSetOrder(1), dbSeek(xFilial("SC6")+(SC2T)->C6_NUM+(SC2T)->C6_ITEM+(SC2T)->C6_PRODUTO))
				If RecLock("SC6",.f.)
					SC6->C6_LIBERAD := 'S'
					SC6->C6_ULTACAO := 'Liberado Credito ' + DtoC(Date()) + ' as ' + Left(Time(),5)
					SC6->(MsUnlock())
				Endif

				aAreaSC5	:= SC5->(GetArea())
				aAreaSC6	:= SC6->(GetArea())
				aAreaSC9	:= SC9->(GetArea())
				aAreaSA1	:= SA1->(GetArea())
		
				If cEmpAnt == '01'
					If Empty(SC5->C5_PEDWEB)
						U_CargaPed(SC6->C6_NUM,SC6->C6_ITEM,SC6->C6_PRODUTO) // Ajusta Saldo Carga Fabrica
					Endif
				Endif
											
				RestArea(aAreaSC5)
				RestArea(aAreaSC6)
				RestArea(aAreaSC9)
				RestArea(aAreaSA1)
		
			Endif
		Endif
	Endif
	DBSELECTAREA(SC2T)
	DBSKIP()
ENDDO   

IF SELECT(SC2T) <> 0
	(SC2T)->(DBCLOSEAREA())
ENDIF  
Return  

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GrvPedCli º Autor ³Mateus Hengle       º Data ³ 07/02/2014  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Grava o campo Ped Cliente e replica para os outros itens   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³ 														      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function GrvPedCli()  
Local aAreaSC5 := SC5->(GetArea())
Local aAreaSC6 := SC6->(GetArea())
Local cNum     := SC5->C5_NUM 		// NESTE MOMENTO O PEDIDO JA FOI GERADO, E POR ISSO PEGA O NUM DO PV POSICIONADO 
Local cPVCliYZ := ""  

If SC6->(dbSetOrder(1), dbSeek(xFilial("SC6")+cNum))
	While SC6->(!Eof()) .And. SC6->C6_FILIAL == xFilial("SC6") .And. SC6->C6_NUM == cNum
		If SUB->(dbSetOrder(4), dbSeek(xFilial("SUB")+SC6->C6_NUM+SC6->C6_ITEM))
			If RecLock("SC6",.f.)
				SC6->C6_PEDCLI := SUB->UB_PEDCLI
				SC6->(MsUnlock())
			Endif
		Endif
	
		SC6->(dbSkip(1))
	Enddo
Endif
RestArea(aAreaSC5)
RestArea(aAreaSC6)
Return .t.
/*



cQry6:= " SELECT TOP 1 UB_PEDCLI, UB_NUMPV"  // QUERY QUE TRAZ APENAS O PRIMEIRO REGISTRO OQUE O USUARIO DIGITOU NO CAMPO UB_PEDCLI
cQry6+= " FROM "+RETSQLNAME("SUB")+" SUB"
cQry6+= " WHERE UB_NUMPV = '"+cNum+"' "
cQry6+= " AND UB_PEDCLI <> '' "
cQry6+= " AND SUB.D_E_L_E_T_='' "

If Select("TRJ") > 0
	TRJ->(dbCloseArea())
EndIf  

TCQUERY cQry6 New Alias "TRJ" 

cPvCliYZ := TRJ->UB_PEDCLI
 
//IF !EMPTY(cPvCliYZ) // SE O CAMPO ESTIVER VAZIO NAO FAZ NADA
	
cQry5:= " SELECT C6_NUM, C6_ITEM"
cQry5+= " FROM "+RETSQLNAME("SC6")+" SC6"
cQry5+= " WHERE C6_NUM = '"+cNum+"' "
cQry5+= " AND SC6.D_E_L_E_T_='' "

If Select("TRG") > 0
	TRG->(dbCloseArea())
EndIf

TCQUERY cQry5 New Alias "TRG"
While TRG->(!EOF())
	
	cNumYZ  := TRF->C6_NUM
	cItemYZ := TRF->C6_ITEM
	
	DBSELECTAREA("SUB")
	DBSETORDER(4)
	IF DBSEEK(XFILIAL("SUB") + cNumYZ + cItemYZ )  // GRAVA EM TODOS OS ITENS NA SUB OQUE FOI DIGITADO NO PRIMEIRO ITEM
		RecLock("SUB",.F.)
		IF !EMPTY(cPvCliYZ)
			SUB->UB_PEDCLI  := cPVcliYZ
		ELSE
			SUB->UB_PEDCLI  := ""
		ENDIF
		MsUnlock()
	ENDIF
	
	DBSELECTAREA("SC6")
	DBSETORDER(1)
	IF DBSEEK(XFILIAL("SC6") + cNumYZ + cItemYZ )	// GRAVA EM TODOS OS ITENS NA SC6 OQUE FOI DIGITADO NO PRIMEIRO ITEM DA SUB
		RecLock("SC6",.F.)
		IF !EMPTY(cPvCliYZ)
			SC6->C6_PEDCLI  := cPVcliYZ
		ELSE
			SC6->C6_PEDCLI  := ""
		ENDIF
		MsUnlock()
	ENDIF
	
	TRG->(DbSkip())
ENDDO

//ENDIF


Return   
  */
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GravaObs  º Autor ³Mateus Hengle       º Data ³ 09/03/2014  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Grava o campo OBS										  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³ 														      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function GravaObs(cOper)  

Local cXXObs   := M->UA_XXOBS 		
Local dDataxx  := DATE()
Local cTime    := TIME()
Local cUser    := CUSERNAME
Local cTexto   := ""
Local cOper1   := ""

IF cOper == '1'
	cOper1 := "Pedido"
ELSEIF cOper == '2'
	cOper1 := "Orcamento"
ELSEIF cOper == '3'		
	cOper1 := "Atendimento"
ENDIF	

cTextoEX := Iif(SUA->(FieldPos("UA_OBS"))>0,SUA->UA_OBS  ,'')

IF EMPTY(cTextoEX)
	cTexto   := "** "+cOper1+" ** "+DTOC(dDataxx)+" ** "+cTime+" ** "+cUser+Chr(13)+Chr(10)
ELSE
	cTexto   := Chr(13)+Chr(10)+Chr(13)+Chr(10)+" ** "+cOper1+" ** "+DTOC(dDataxx)+" ** "+cTime+" ** "+cUser+Chr(13)+Chr(10)
ENDIF

RecLock("SUA",.F.)
If SUA->(FieldPos("UA_OBS")) > 0
	SUA->UA_OBS   := cTextoEX + cTexto + cXXObs
Endif
SUA->UA_XXOBS := ""                  
If cEmpAnt == '01'	// Apenas Metalacre
	SUA->UA_TBMTL  	:= GetMV("MV_TBQPAD")
Endif
MsUnlock()            

If SUA->UA_CLIPROS	== '1'	// Cliente Apenas
	// Grava informações no Historico do Ciclo de Vendas
	If SZ4->(dbSetOrder(1), dbSeek(xFilial("SZ4")+SUA->UA_XCLIENT+SUA->UA_XLOJAEN)) //.And. cOper$'1*2'
		cMemo := 'Geração de ' + cOper1 + ' Numero: ' + Iif(cOper=='1',SUA->UA_NUMSC5,SUA->UA_NUM) + ' em ' + DtoC(dDataBase) + ' as ' + Time() + ' Por ' + cUser + ' Contato: ' + AllTrim(SUA->UA_DESCNT) + ' Email: ' + Posicione("SU5",1,xFilial("SU5")+SUA->UA_CODCONT,"U5_EMAIL") 
		If RecLock("SZ3",.t.)
			SZ3->Z3_FILIAL	:= xFilial("SZ3")  
			SZ3->Z3_CLIENTE	:=	SUA->UA_XCLIENT
			SZ3->Z3_LOJA	:=	SUA->UA_XLOJAEN
			SZ3->Z3_DATA	:=	dDataBase
			SZ3->Z3_HORA	:=	Time()
			SZ3->Z3_HISTM	:=	cMemo
			SZ3->Z3_INICIO	:=  cMemo
			SZ3->Z3_USER	:=	__cUserId
			SZ3->Z3_NMUSER	:=	Capital(USRRETNAME(__cUserId))
			SZ3->(MsUnlock())
		Endif
	
		If SA1->(dbSetOrder(1), dbSeek(xFilial("SA1")+SUA->UA_XCLIENT+SUA->UA_XLOJAEN))
			// Grava Ultima Ação do Cliente
			If RecLock("SA1",.f.)
				SA1->A1_ULTACAO	:= 'Histórico: ' + cMemo
				SA1->(MsUnlock())
			Endif             
		Endif
	Endif
Endif
Return 

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Standby  º Autor ³Mateus Hengle       º Data ³ 02/04/2014  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Quando for pedido stand by 								  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³ 														      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function Standby(cNumX, cItem, cProd, cQtde, cLacre, cNumAT, cItemAT, xLacrex, xLacreZ)

Private Z00LACRE   := ""
Private Z00LACREXX := "" 
Private xLacreIni  := ""
Private xLacreFim  := ""
	
DbSelectArea("Z01")
Z01->(DBGOTOP())
	
RecLock("Z01",.T.)
Z01->Z01_FILIAL	:= xFilial("Z01") // INCLUI UMA LINHA DE REGISTRO COM A NUMERACAO DO LACRE QUE FOI GERADA
Z01->Z01_COD	:= cLacre
Z01->Z01_PV		:= cNumX
Z01->Z01_ITEMPV	:= cItem
Z01->Z01_STAT	:= "1"
Z01->Z01_PROD	:= cProd
Z01->Z01_INIC	:= xLacreX
Z01->Z01_FIM	:= xLacreZ
Z01->Z01_NUMAT  := cNumAT  // CRIAR ESTE CAMPO NA BASE PRODUCAO
Z01->Z01_NUMERO := SOMA1(U_GETSOMA('Z01','Z01_NUMERO',,'Z01_FILIAL',XFILIAL("Z01"),,,,, 'M'))
If Z01->(FieldPos("Z01_LOGINT")) > 0
	Z01->Z01_LOGINT := UsrFullName(__cUserId)+' em '+DtoC(dDataBase)+' as '+Left(Time(),5)
Endif
Z01->(MsUnlock())
	
xLacreIni := xLacreX
xLacreFim := xLacreZ
	
//U_ChkLacre(cLacre)

DBSELECTAREA("SUB")
DBSETORDER(1)
IF DBSEEK(XFILIAL("SUB") + cNumAT + cItemAT )
	RecLock("SUB",.F.)
	SUB->UB_XINIC:= xLacreIni
	SUB->UB_XFIM := xLacreFim  // GRAVA O LACRE INICIAL E FINAL NOS ITENS DA TABELA SUB
	SUB->(MsUnlock())
		
ENDIF
	
DBSELECTAREA("SC6")
DBSETORDER(1)
IF DBSEEK(XFILIAL("SC6") + cNumX + cItem )
	RecLock("SC6",.F.)   			//  GRAVA O LACRE INICIAL E FINAL NOS ITENS DA TABELA SC6
	SC6->C6_XINIC  := xLacreIni
	SC6->C6_XFIM   := xLacreFim
	SC6->(MsUnlock())
ENDIF 

DBSELECTAREA("SUA")
DBSETORDER(8)
IF DBSEEK(XFILIAL("SUA") + cNumX) 
	RecLock("SUA",.F.)
   	SUA->UA_TEMOP  := 'S'   		// CAMPO QUE MUDA A COR DA LEGENDA PARA OP GERADA PINK
	If cEmpAnt == '01'	// Apenas Metalacre
	   	SUA->UA_TBMTL  	:= GetMV("MV_TBQPAD")
	Endif
   	MsUnlock()
ENDIF 

DBSELECTAREA("SC5")
DBSETORDER(1)
IF DBSEEK(XFILIAL("SC5") + cNumX) 
   	RecLock("SC5",.F.)
   	SC5->C5_TEMOP  := 'S'   		// CAMPO QUE MUDA A COR DA LEGENDA PARA OP GERADA PINK
   	MsUnlock()
ENDIF

Return  

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TamLacre  º Autor ³Mateus Hengle       º Data ³ 03/04/2014  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Manda mensagem pro usuário alterar tamanho do campo lacre  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³ 														      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function TamLacre(cNumX, cItem, cProd, cLacre, xLacreFim)

DbSelectArea("SUB")
DbSeek ( xFilial("SUB") + cNumX + cItem)
	
// NOVO ITEM: QDO ATINGIR OS CARACTERES PRE-CONFIGURADOS MANDA UMA MENSAGEM NA TELA.
DBSELECTAREA("Z00")
DBSETORDER(1) 
IF DBSEEK(XFILIAL("Z00") + cLacre)
	IF Z00->Z00_PDINME == 'S'
		IF LEN(ALLTRIM(STR(xLacreFim))) > 6  .OR. xLacreFim > 999999
			MSGALERT("A numeração do lacre do item " + cProd + " atingiu o numero de caracteres configurado na tabela de personalização.")
			MSGALERT("Favor incluir uma NOVA personalização para o cliente " + ALLTRIM(SUA->UA_CLIENTE)  + ", LOJA " + SUA->UA_LOJA + ".") 
		ENDIF	
   	ELSE
		IF LEN(ALLTRIM(STR(xLacreFim ))) > Z00->Z00_TMLACRE
			MSGALERT("A numeração do lacre do item " + cProd + " atingiu o numero de caracteres configurado na tabela de personalização.")
			MSGALERT("Favor verificar a personalização " + cLacre + " e aumente o numero do campo Tamanho do lacre.")
		ENDIF
			
	ENDIF
ENDIF
	
Return	 






/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ PassLib º Autor ³ Luiz Alberto V Alvesº Data ³  19/02/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina para Liberacao de Senha de Supervisor				  º±±
±±º          ³ 																º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ESPECIFICO Metalacre                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function PassLib()
Local oGet1
Local cGet1 := Space(20)
Local oSay1
Static oDlg

  DEFINE MSDIALOG oDlg TITLE "Liberação" FROM 000, 000  TO 050, 400 COLORS 0, 16777215 PIXEL

    @ 006, 068 MSGET oGet1 VAR cGet1 Valid !Empty(cGet1) SIZE 056, 010 OF oDlg COLORS 0, 16777215 PIXEL PASSWORD
    @ 007, 006 SAY oSay1 PROMPT "Digite a Senha:" SIZE 051, 011 OF oDlg COLORS 0, 16777215 PIXEL
    DEFINE SBUTTON oSButton1 FROM 006, 149 TYPE 01 OF oDlg ENABLE ACTION oDlg:End()
    
  ACTIVATE MSDIALOG oDlg CENTERED

Return cGet1   







/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ IncPed º Autor ³ Luiz Alberto V Alvesº Data ³  19/02/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Inclusao Automatica Pedidos MetalSeal e MPM		  º±±
±±º          ³ 																º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ESPECIFICO Metalacre                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function IncPed()
Local aArea := GetArea()
Local xEmpAnt := cEmpAnt
Local xFilAnt := cFilAnt

If SC5->C5_CLIENTE+SC5->C5_LOJACLI$GetNewPar("MV_MTLCVN",'00132001*01140401')	// Clientes que Não Entram na Condicao
	If SUA->UA_CLIENTE=='001320'	// MetalSeal
		cEmpNova := '02'
	ElseIf SUA->UA_CLIENTE=='011404'	// MPM
		cEmpNova := '04'
	Endif                
	
	cTes	:=	U_SelTes(cEmpNova)
	
	If Empty(cTes)
		Return .F.
	Endif

	MsgInfo("Atenção o Pedido " + SC5->C5_NUM + " Será Replicado na Empresa - " + Iif(cEmpNova='02','MetalSeal','MPM'))

	//MONTA O CABECALHO DO PEDIDO PARA A EXCLUSAO
			
	Begin Transaction
	

				
	aCabec	:=	{}
	aItens	:=	{}
				
	aAdd(aCabec, { "C5_TIPO"                  , SC5->C5_TIPO       			, Nil } )
	aAdd(aCabec, { "C5_CLIENTE"               , SC5->C5_CLIMTS				, Nil } )
	aAdd(aCabec, { "C5_LOJACLI"               , SC5->C5_LOJMTS				, Nil } )
	aAdd(aCabec, { "C5_TRANSP"                , SC5->C5_TRANSP				, Nil } )
	aAdd(aCabec, { "C5_TIPOCLI"               , SC5->C5_TIPOCLI				, Nil } )
	aAdd(aCabec, { "C5_CONDPAG"               , SC5->C5_CONDPAG				, Nil } )
	aAdd(aCabec, { "C5_TABELA"                , SC5->C5_TABELA         		, Nil } )
	aAdd(aCabec, { "C5_VEND1"                 , SC5->C5_VEND1				, Nil } )
	aAdd(aCabec, { "C5_VEND2"                 , SC5->C5_VEND2				, Nil } )
	aAdd(aCabec, { "C5_VEND3"                 , SC5->C5_VEND3				, Nil } )
	aAdd(aCabec, { "C5_COMIS1"                , SC5->C5_COMIS1	  			, Nil } )
	aAdd(aCabec, { "C5_COMIS2"                , SC5->C5_COMIS2	  			, Nil } )
	aAdd(aCabec, { "C5_COMIS3"                , SC5->C5_COMIS3	  			, Nil } )
	aAdd(aCabec, { "C5_EMISSAO"               , SC5->C5_EMISSAO        		, Nil } )//Rodolfo 04/02/16
	aAdd(aCabec, { "C5_MOEDA"                 , 1                   		, Nil } )
	aAdd(aCabec, { "C5_TIPLIB"                , "2"                 		, Nil } )//Rodolfo 13/01/16
	aAdd(aCabec, { "C5_TXMOEDA"               , 1                   		, Nil } )
	aAdd(aCabec, { "C5_TPCARGA"               , "2"                 		, Nil } )
	aAdd(aCabec, { "C5_GERAWMS"               , "1"                 		, Nil } )
	aAdd(aCabec, { "C5_TPFRETE"               , Iif(Empty(SC5->C5_TPFRETE),'F',SC5->C5_TPFRETE)		, Nil } )
	aAdd(aCabec, { "C5_MENPAD"                , SC5->C5_MENPAD        		, Nil } )
	aAdd(aCabec, { "C5_MENNOTA"               , SC5->C5_MENNOTA        		, Nil } )
	aAdd(aCabec, { "C5_REDESP"                , SC5->C5_REDESP        		, Nil } )
	aAdd(aCabec, { "C5_TPFRETE"               , SC5->C5_TPFRETE        		, Nil } )
	aAdd(aCabec, { "C5_NATUREZ"               , SC5->C5_NATUREZ        		, Nil } )
	aAdd(aCabec, { "C5_ESPECI1"               , SC5->C5_ESPECI1        		, Nil } )
	aAdd(aCabec, { "C5_FECENT"                , SC5->C5_FECENT        		, Nil } )
	aAdd(aCabec, { "C5_XOPCCOM"               , SC5->C5_XOPCCOM        		, Nil } )
	aAdd(aCabec, { "C5_XOBSCPL"               , SC5->C5_XOBSCPL        		, Nil } )
	aAdd(aCabec, { "C5_XOBSFAT"               , SC5->C5_XOBSFAT        		, Nil } )
	aAdd(aCabec, { "C5_OBSCLI"                , SC5->C5_OBSCLI        		, Nil } )
	aAdd(aCabec, { "C5_OBSOP"                 , SC5->C5_OBSOP        		, Nil } )
	aAdd(aCabec, { "C5_PESOL"                 , SC5->C5_PESOL        		, Nil } )
	aAdd(aCabec, { "C5_PBRUTO"                , SC5->C5_PBRUTO        		, Nil } )
	aAdd(aCabec, { "C5_VOLUME1"               , SC5->C5_VOLUME1        		, Nil } )
	aAdd(aCabec, { "C5_FRETE"                 , SC5->C5_FRETE        		, Nil } )
	
				
	SC6->(dbSetOrder(1), dbSeek(xFilial("SC5")+SC5->C5_NUM))
	While SC6->(!Eof()) .And. SC6->C6_FILIAL == xFilial("SC6") .And. SC6->C6_NUM == SC5->C5_NUM
		aLinha := {}
		aadd(aLinha,{"C6_PRODUTO"     	,SC6->C6_PRODUTO     ,Nil})
		aadd(aLinha,{"C6_DESCRI"     	,SC6->C6_DESCRI          ,Nil})
		aadd(aLinha,{"C6_UM"          	,SC6->C6_UM               ,NIL})
		aadd(aLinha,{"C6_QTDVEN"     	,SC6->C6_QTDVEN       ,Nil})
		aadd(aLinha,{"C6_PRCVEN"     	,SC6->C6_PRCVEN          ,Nil})
		aadd(aLinha,{"C6_VALOR"         ,SC6->C6_VALOR         ,Nil})
		aadd(aLinha,{"C6_QTDLIB"     	,SC6->C6_QTDLIB        ,Nil})
		aadd(aLinha,{"C6_TES"          	,cTes          ,Nil})
		aadd(aLinha,{"C6_LOCAL"         ,SC6->C6_LOCAL          ,NIL})
		aadd(aLinha,{"C6_PEDCLI"     	,SC6->C6_PEDCLI          ,NIL})
		aadd(aLinha,{"C6_PRUNIT"     	,SC6->C6_PRUNIT          ,Nil})
		aadd(aLinha,{"C6_ENTREG"     	,SC6->C6_ENTREG          ,NIL})
		aadd(aLinha,{"C6_SUGENTR"     	,SC6->C6_SUGENTR         ,NIL})
		aadd(aLinha,{"C6_XLACRE"     	,SC6->C6_XLACRE         ,NIL})
		aadd(aLinha,{"C6_XEMBALA"     	,SC6->C6_XEMBALA         ,NIL})
		aadd(aLinha,{"C6_XAPLC"     	,SC6->C6_XAPLC         ,NIL})
		aadd(aLinha,{"C6_XAPLICA"     	,SC6->C6_XAPLICA         ,NIL})
		aadd(aLinha,{"C6_XVOLITE"     	,SC6->C6_XVOLITE         ,NIL})
		aadd(aLinha,{"C6_XSTAND"     	,SC6->C6_XSTAND         ,NIL})
		aadd(aLinha,{"C6_XPBITEM"     	,SC6->C6_XPBITEM         ,NIL})
		aadd(aLinha,{"C6_XPLITEM"     	,SC6->C6_XPLITEM         ,NIL})
		aadd(aLinha,{"C6_XINIC"     	,SC6->C6_XINIC         ,NIL})
		aadd(aLinha,{"C6_XFIM"     	    ,SC6->C6_XFIM         ,NIL})
		aadd(aLinha,{"C6_OPC"     		,SC6->C6_OPC         ,NIL})
		aadd(aLinha,{"C6_ITEMCLI"     	,SC6->C6_ITEMCLI         ,NIL})
		aadd(aLinha,{"C6_FCICOD"     	,SC6->C6_FCICOD         ,NIL})
					
		aadd(aItens,aLinha)
		
		SC6->(dbSkip(1))
	Enddo
	
	cEmpAnt	:=	cEmpNova
						
	// Inicia Estorno
				
	lMsErroAuto := .F.
	MSExecAuto({|x,y,z|Mata410(x,y,z)},aCabec,aItens,3)
	If lMsErroAuto
		MsgInfo("Problema Inclusão do Pedido ! ")
		DisarmTransaction()
		MostraErro()
		
		cEmpAnt := xEmpAnt
		Return .f.
	Else
		MsgInfo("Pedido Número " + SC5->C5_NUM + " Gerado com Sucesso, Verifique !!!")
	EndIf
	End Transaction       
	
	cEmpAnt := xEmpAnt
Endif

RestArea(aArea)
Return .T.

