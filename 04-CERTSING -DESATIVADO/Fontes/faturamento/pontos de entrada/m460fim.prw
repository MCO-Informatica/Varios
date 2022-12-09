#Include 'Protheus.ch'
#include "Totvs.ch"
#Include "topconn.ch"
#Include "TbiConn.ch"

/*{Protheus.doc} M460FIM

Ponto de entrada executado após a criação de Nota Fiscal. Desta forma ponto de entrada é utilizado complementar informações de titulos a receber e tabela de movimentação para comissões (SZ5)

@author Totvs SM - David
@since 01/08/2011

@ Incluida achamada para gravacao de tabela SF6 - Projeto GNRE Prox - 21/08/14
@ Confirmação Rafael Beghini - 31/03/2015

*/

User Function M460FIM()                 

Local aArea 	:= GetArea()		//Salva a area atual
Local aAreaSE1	:= SE1->(GetArea())	//Salva a area atual da tabela SE1
Local aAreaSD2	:= SD2->(GetArea())	//Salva a area atual da tabela SD2
Local aAreaSF2	:= SF2->(GetArea())	//Salva a area atual da tabela SF2
Local aAreaSC5	:= SC5->(GetArea())	//Salva a area atual da tabela SC5
Local aAreaSC6	:= SC6->(GetArea())	//Salva a area atual da tabela SC5
Local aAreaSZ6  := SZ6->(GetArea())	//Salva a area atual da tabela SZ6
Local aAreaSZ5	:= SZ5->(GetArea())	//Salva a area atual da tabela SZ5
Local aAreaSZ3	:= SZ3->(GetArea())	//Salva a area atual da tabela SZ3
Local cQrySD2	:= ""
//Local cQrySE1	:= ""
//Local cQrySC5	:= ""
//Local cPrefix	:= GetNewPar("MV_XPREFHD", "VDI")
//Local cTipPr	:= GetNewPar("MV_XTIPPRO", "NCC")
//Local cNossoNum	:= ""
//Local cXNPSITE	:= ""
Local cPedido	:= ""
//Local cTipMov	:= ""
Local cOperVenS	:= GetNewPar("MV_XOPEVDS", "51")
//Local cOperVenH	:= GetNewPar("MV_XOPEVDH", "52")
Local cOperEntH	:= GetNewPar("MV_XOPENTH", "53")
Local aAnalysis := {}

//Pega o numero do pedido referente a nota posicionada
cQrySD2 := "SELECT D2_PEDIDO, D2_ITEMPV, D2_FILIAL"
cQrySD2 += "FROM " + RetSqlName("SD2") + " "
cQrySD2 += "WHERE D2_FILIAL = '" + xFilial("SD2") + "' "
cQrySD2 += "  AND D2_DOC = '" + SF2->F2_DOC + "' "
cQrySD2 += "  AND D2_SERIE = '" + SF2->F2_SERIE + "' "
cQrySD2 += "  AND D_E_L_E_T_ = ' ' "

cQrySD2 := ChangeQuery(cQrySD2)

If Select("cQrySD2") > 0
	DbSelectArea("cQrySD2")
	DbCloseArea()   //DbCloseArea("cQrySD2")
End If

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQrySD2),"QRYSD2",.F.,.T.)


DbSelectArea("QRYSD2")
QRYSD2->(DbGoTop())
If QRYSD2->(!Eof())
	
	cPedido	:= QRYSD2->D2_PEDIDO
	
	/* - Retirado por Giovanni em 25/11/2016
	//Esta regra de negócios nãoé valida. Não mas são Gerados tipo PR para vendas boleto de delivery (e1_prefixo = "VDI" e e1_tipo= "PR")
	
	//Pega o recno e o nosso numero, do titulo do tipo provisorio, que foi incluido pelo site pela forma de pagamento boleto
	cQrySE1 := "SELECT R_E_C_N_O_ NRECE1, E1_NUMBCO "
	cQrySE1 += "FROM " + RetSqlName("SE1") + " "
	cQrySE1 += "WHERE E1_FILIAL = '" + xFilial("SE1") + "' "
	cQrySE1 += "  AND E1_PREFIXO = '" + cPrefix + "' "
	cQrySE1 += "  AND E1_NUM = '" + QRYSD2->D2_PEDIDO + "' "
	cQrySE1 += "  AND E1_TIPO = 'PR ' "
	cQrySE1 += "  AND D_E_L_E_T_ = ' ' "
	
	cQrySE1 := ChangeQuery(cQrySE1)
	
	If Select("QRYSE1") > 0
	DbSelectArea("QRYSE1")
	DbCloseArea("QRYSE1")
	End If
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQrySE1),"QRYSE1",.F.,.T.)
	
	DbSelectArea("QRYSE1")
	If QRYSE1->(!Eof())
	cNossoNum := AllTrim(QRYSE1->E1_NUMBCO)
	
	DbSelectArea("SE1")
	SE1->(DbGoto(QRYSE1->NRECE1))
	
	//Excluo o titulo provisorio
	RecLock("SE1", .F.)
	SE1->(DbDelete())
	SE1->(MsUnLock())
	
	//Pego o numero do pedido que foi gerado pelo site
	cQrySC5 := "SELECT C5_XNPSITE "
	cQrySC5 += "FROM " + RetSqlName("SC5") + " "
	cQrySC5 += "WHERE C5_FILIAL = '" + xFilial("SC5") + "' "
	cQrySC5 += "  AND C5_NUM = '" + QRYSD2->D2_PEDIDO + "' "
	cQrySC5 += "  AND D_E_L_E_T_ = ' ' "
	
	cQrySC5 := ChangeQuery(cQrySC5)
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQrySC5),"QRYSC5",.F.,.T.)
	
	DbSelectArea("QRYSC5")
	QRYSC5->(DbGoTop())
	
	If QRYSC5->(!Eof())
	cXNPSITE := AllTrim(QRYSC5->C5_XNPSITE)
	EndIf
	
	//Posiciono no novo titulo gerado pelo faturamento, e gavo nele o nosso numero e o numero do pedido gerado pelo site
	DbSelectArea("SE1")
	DbSetOrder(1)	//E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
	If MsSeek(xFilial("SE1") + SF2->F2_PREFIXO + SF2->F2_DUPL)
	RecLock("SE1", .F.)
	Replace SE1->E1_NUMBCO With cNossoNum
	Replace SE1->E1_XNPSITE With cXNPSITE
	SE1->(MsUnLock())
	EndIf
	
	DbSelectArea("QRYSC5")
	QRYSC5->(DbCloseArea())
	
	EndIf
	
	DbSelectArea("QRYSE1")
	QRYSE1->(DbCloseArea())
	*/
	
	//##################################################################
	//Gera Movimento de Remuneracao de Parceiros e Movimento de Voucher#
	//##################################################################
	DbSelectArea("QRYSD2")
	While QRYSD2->(!Eof())
		
		SC5->(DbSetOrder(1))
		If SC5->(DbSeek(xFilial("SC5") + QRYSD2->D2_PEDIDO))
			
			SC6->(DbselectArea("SC6"))
			SC6->(DbSetOrder(1))
			
			If SC6->(DbSeek(xFilial("SC6") + QRYSD2->D2_PEDIDO + QRYSD2->D2_ITEMPV))
				
				//< início ---------------------------------------------------------------
				// <---- Robson Gonçalves - 20/03/2017 - Dado para Tracker de Pedido ---->
				// Tratamento para grava o código da filial onde gerou o documento fiscal.
				//------------------------------------------------------------------------
				SC6->( RecLock( 'SC6', .F. ) )
				SC6->C6_LOJDED := QRYSD2->D2_FILIAL
				SC6->( MsUnLock() )
				//------------------------------------------------------------------- Fim >
			
				SZG->(DbselectArea("SZG"))
				SZG->(DbSetOrder(3))
				/*  Atenção:
				Indice (1) = ZG_FILIAL+ZG_NUMPED+ZG_ITEMPED+ZG_NUMVOUC
				onde ZG_NUMPED é o número do PEDIDO GAR e não número do pedio protheus
				Indice (3) = ZG_FILIAL+Z6_PEDSITE
				*/
				
				//Tento Atualiza Movimento de Voucher pelo número do PEDIDO GAR
				IF !Empty(SC6->C6_XNUMVOU) .And. SZG->(DbSeek(xFilial("SZG") + SC5->C5_XNPSITE)) 
					
					SZG->( RecLock("SZG",.F.) )
					
					SZG->ZG_NUMVOUC := SC6->C6_XNUMVOU
					SZG->ZG_NUMPED  := SC6->C6_PEDGAR
					SZG->ZG_ITEMPED := SC6->C6_ITEM
					SZG->ZG_QTDSAI  := SC6->C6_XQTDVOU
					SZG->ZG_PEDIDO  := SC6->C6_NUM
					SZG->ZG_CODFLU  := SC5->C5_XFLUVOU 
					
					IF SC6->C6_XOPER == cOperVenS //PRODUTO
						SZG->ZG_NFPROD  :=	SD2->D2_DOC
					ELSEIF SC6->C6_XOPER == cOperVenS //SERVICO
						SZG->ZG_NFSER   := SD2->D2_DOC
					ELSEIF SC6->C6_XOPER == cOperEntH //ENTREGA
						SZG->ZG_NFENT   := SD2->D2_DOC
					ENDIF
					SZG->ZG_DATAMOV := SF2->F2_EMISSAO
					SZG->ZG_ROTINA  := "M460FIM"
					SZG->ZG_GRPROJ  := SC6->C6_NROPOR
					SZG->(MsUnlock())
				
				Endif
				
				If (SC6->C6_XOPER == "61")
					//update de contingencia para atualizar tabela de
					//de controle de garantia caso ela exista
					cUpdGaran := "UPDATE GTLEGADO SET GT_INPROC = 'T' WHERE GT_TYPE = 'S' AND GT_PEDVENDA = '"+Alltrim(SC6->C6_NUM)+"' AND GT_INPROC = 'F' AND TRIM(GT_PRODUTO)='"+ALLTRIM(SC6->C6_PRODUTO)+"'"
					TcSqlExec(cUpdGaran)					
				Endif
				//GAR20130917
				//Atualiza SZ5 apenas para mídias avulsas pois os demais casos serão tratados no GARA130
				//If SC6->C6_XOPER == "53" .AND. Empty(SC6->C6_PEDGAR) .AND. !Empty(SC5->C5_XNPSITE)//Venda Avulsa
				If (SC6->C6_XOPER == "53" .OR. SC6->C6_XOPER == "62") .AND. !Empty(SC5->C5_XPOSTO) .AND. Empty(SC6->C6_PEDGAR) .AND. !Empty(SC5->C5_XNPSITE)//Venda Avulsa
					
					//Campos adicionados para a gravação de informações perinentes a midia avulsa
					SZ5->(DbselectArea("SZ5"))
					
					Reclock('SZ5',.T.)
					SZ5->Z5_EMISSAO := SF2->F2_EMISSAO
					SZ5->Z5_VALOR   := SC6->C6_VALOR
					SZ5->Z5_PRODUTO := SC6->C6_PRODUTO
					SZ5->Z5_DESPRO  := SC6->C6_DESCRI
					SZ5->Z5_CODVOU  := SC6->C6_XNUMVOU
					SZ5->Z5_PRODGAR := SC6->C6_PROGAR
					SZ5->Z5_TIPO    := "ENTHAR"                           //REMUNERA O POSTO/AR PELA ENTREGA DA MÍDIA
					SZ5->Z5_TIPODES := "ENTREGA HARDWARE AVULSO"
					SZ5->Z5_VALORHW := SC6->C6_VALOR
					SZ5->Z5_PEDIDO  := SC6->C6_NUM
					SZ5->Z5_ITEMPV  := SC6->C6_ITEM
					SZ5->Z5_ROTINA  := "M460FIM"
					SZ5->Z5_CODPOS  := SC5->C5_XPOSTO
					SZ5->Z5_TIPMOV  := SC5->C5_TIPMOV
					SZ5->Z5_TABELA  := SC5->C5_TABELA
					SZ5->Z5_PEDSITE := SC5->C5_XNPSITE
					
					SZ3->(DbSetOrder(6))
					If SZ3->(DbSeek(xFilial("SZ3") + "4" + SZ5->Z5_CODPOS))
						SZ5->Z5_DESPOS	:= SZ3->Z3_DESENT
						SZ5->Z5_REDE    := SZ3->Z3_REDE
						SZ5->Z5_DESCAR	:= SZ3->Z3_DESAR
					EndIf
					
					SZ5->(MsUnlock())
				EndIf
				
			Endif
		Endif
		DbSelectArea("QRYSD2")
		QRYSD2->(DbSkip())
		
	Enddo
	
	//Verifica se Faturamento se Origina de Montagem de Carga e Transmite e Imprime o Danfe
	If FunName() == "MATA460B"
		TrnsCarg(SF2->(Recno()),cPedido)
		
	EndIF
Endif
         
// incia o tratamento de compençação de títulos.
//Atualiza e identifica todos os registros de títulos de notas fiscais que serão utiizados no processo de compenção de títulos
QRYSD2->(DbGoTop())
If QRYSD2->(!Eof())
	DbSelectArea("SC5")
	DbSetOrder(1)
	IF DbSeek(xfilial('SC5')+QRYSD2->D2_PEDIDO)
		DbSelectArea("SE1")
		DbSetOrder(1)	//E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
		If MsSeek(xFilial("SE1") + SF2->F2_PREFIXO + SF2->F2_DUPL)
		   While !eof().and. SE1->E1_FILIAL+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_CLIENTE+SE1->E1_LOJA == (xFilial("SE1") + SF2->F2_PREFIXO + SF2->F2_DUPL+SF2->F2_CLIENTE+SF2->F2_LOJA)
		         //.And. .NOT. Empty( SE1->E1_PEDIDO ) *Condição retirada para tratamento de compensação de titulos com PCC
		         
		         /* Ajuste feito por Claudio Corrêa 20/01/2017
		         
		         	Criada condição para tratar compensação de titulos com PCC
		         	
		         */
		         
		         If ALLTRIM(QRYSD2->D2_PEDIDO) == ALLTRIM(SE1->E1_PEDIDO)
		         
				   	/*
				   	rleg
				   	estes títulos são os definitivos, capturar os dados recnos.
				   	capturar o pedido da chave seek acima
				   	com o número do pedido verificar se o título dele é PR ou NCC
				   	Sendo PR fazer substituição
				   	Sendo NCC fazer a compensação.
				   	*/
	                
					//Guarda todos os rencos dos títulos gerados pela nota fiscal
			   		AAdd( aAnalysis, { QRYSD2->D2_PEDIDO, SE1->( RecNo()) } )
	
			   	    //Atualiza dados do pedido no Financeiro
					RecLock("SE1", .F.)
					SE1->E1_TIPMOV  := SC5->C5_TIPMOV
					SE1->E1_PEDGAR  := SC5->C5_CHVBPAG
					SE1->E1_XNPSITE := SC5->C5_XNPSITE
					SE1->E1_XNUMVOU := AllTrim(SC5->C5_XNUMVOU)
					SE1->E1_XFLUVOU := SC5->C5_XFLUVOU
					MsUnLock()
					
				End If	
				SE1->(DbSkip())
			Enddo
		EndIf                                    
		//Esta rotina não é mais utilizada.
		//Rotina de compensação de ncc caso exista
		//U_GAR130Fin(QRYSD2->D2_PEDIDO,nil,cPrefix,QRYSD2->D2_PEDIDO,nil,cTipPr)
	EndIf
Endif



//Realiza as compenções e substituições
DbSelectArea("QRYSD2")
QRYSD2->(DbGoTop())
If QRYSD2->(!Eof())

	//Valida Recibo de Pagamento visando substituir ou compensar titulos dependendo do tipo do mesmo
	If Len( aAnalysis ) > 0 //.and. !IsInCallStack("U_VNDA190")
		
		//Tratammento para vendas varejo
		CONOUT('Inicio M460FIM - GERACAO DE RECIBO')
		U_VldRecPg( aAnalysis,.F.)
		CONOUT('Fim M460FIM - GERACAO DE RECIBO')
		
	Endif
Endif

DbSelectArea("QRYSD2")
QRYSD2->(DbCloseArea())

//Renato Ruy - Data: 31/10/13 - Customização para gravar a conta contábil e classe de valor na nota.
DbSelectArea("SD2")
DbSetOrder(3)
If DbSeek( xFilial("SD2") + SF2->F2_DOC+ SF2->F2_SERIE )

	While SF2->F2_FILIAL == SD2->D2_FILIAL .AND. ;
	      SF2->F2_DOC == SD2->D2_DOC .AND. ;
	      SF2->F2_SERIE == SD2->D2_SERIE .AND. ;
	      SF2->F2_CLIENTE == SD2->D2_CLIENTE .AND. ;
	      SF2->F2_LOJA == SD2->D2_LOJA

    	DbSelectArea("SC5")
    	DbSetOrder(1)
    	If DbSeek( xFilial("SC5") + SD2->D2_PEDIDO )

    		RecLock("SD2",.F.)
    			SD2->D2_CLVL 	:= SC5->C5_CLVL
    			SD2->D2_ITEMCC	:= SC5->C5_ITEMCT
    		SD2->(MsUnlock())

    	EndIf

    	DbSelectArea("SD2")
    	DbSkip()

    EndDo

EndIf

//Renato Ruy - Fim da Alteração.
RestArea(aAreaSZ3)  //Restaura a area da tabela SZ3
RestArea(aAreaSZ5)	//Restaura a area da tabela SZ6
RestArea(aAreaSZ6)	//Restaura a area da tabela SZ5
RestArea(aAreaSC6)	//Restaura a area da tabela SC6
RestArea(aAreaSC5)	//Restaura a area da tabela SC5
RestArea(aAreaSF2)	//Restaura a area da tabela SF2
RestArea(aAreaSD2)	//Restaura a area da tabela SD2
RestArea(aAreaSE1)	//Restaura a area da tabela SE1
RestArea(aArea)		//Restaura a area

*************************************************************************************************************
&& Funcao de gravacao do GNRE: Data de Vencimento e Protocolo
&& Criar os parametros antes de testar
*************************************************************************************************************
Conout("Inicio GNRE - Chamada Funcao de Ajuste: DATA e PROTOCOLO" )
U_CSGNRE01()

*************************************************************************************************************

Return

//------------------------------------------------------------------------------------------
// Rotina | VldRecPg  | Autor | Robson Gonçalves                         | Data | 28.11.2014
//------------------------------------------------------------------------------------------
// Descr. | Esta rotina tem por objetivo em analisar se o pedido de venda que originou a
//        | operação possui título PR ou NCC, havendo, o título deverá ser baixado.
//------------------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//------------------------------------------------------------------------------------------
//caso ele seja um PR ou compensando caso seja uma NCC.

// Ajustada por Giovanni para tratar separadamente PR e NCC. 
// Transformada em User function para utilização em outros programas
//  aadd (aAnalysis, {Pedido de venda, Recno do título NF}) 



//Atenção este programa é utilizado em vários lugares. Muito cuidado com as alterações
User Function VldRecPg( aAnalysis,lVldData,lVldSldRes, lVldSldPR )
	Local aBaixa      := {}
	Local cPrefixo    := GetNewPar('MV_XPREFRP', 'RCP')
	Local cA6_COD     := Space( Len( SA6->A6_COD ) )
	Local cA6_AGENCIA := Space( Len( SA6->A6_AGENCIA ) )
	Local cA6_NUMCON  := Space( Len( SA6->A6_NUMCON ) )
	Local aParam      := {}
	Local aFaVlAtuCR  := {}
	Local aDadosBaixa := {}
	Local aLog        := {}
	Local aRet        := {}
	Local cHistory    := ''
	Local nDefinitivo := 0
	Local nI, nX	  := 0
	Local aAuxSE1	  := {}
	Local nBaixa	  := 0 
	Local cPedido     :=''
	Local cParcela    :=''
	Local aSe1NF	  :={}
	Local aSe1NCC	  :={}
	Local cSQL 		  := ''
	Local lContinua   :={}                                            
	Local dDataAnt    :=dDataBase
	Private cTrbSql   :=''
    default lVldData  :=.F. //Valida database para movimentação financeira, default (.f.) Database, Se .T. Será considerada a maior data de emissao para movimentação entre (NF e NCC), (NF e PR) e (NCC e PR)
    default lVldSldRes:=.T. //Valida apenas saldo residual de 0.02, defult(.t.).,  Se .f. vai compesar todos os valores em aberto para NCC e NF. 
    default lVldSldPR :=.T. //Valida saldo e parcela de PR. Para os casos onde a parcela do PR é diferente da parcela da NF
	// [1]-Contabiliza on-line.
	// [2]-Agluitna lançamentos contábeis.
	// [3]-Digita lançamento contábeis.
	// [4]-Juros para comissão.
	// [5]-Desconto para comissão.
	// [6]-Calcula comissão para NCC .
	aParam := {.F.,.F.,.F.,.F.,.F.,.F.}
    
    //Realiza Substituição dos Títulos Provisórios
	For nI := 1 To Len( aAnalysis )
		// Localizar o título definitivo NF para capturar o valor a ser baixado no PR.
		SE1->( dbGoTo( aAnalysis[ nI, 2 ]) )
		nDefinitivo := SE1->E1_VALOR
		cHistory 	:= SE1->( E1_PREFIXO + E1_NUM + E1_PARCELA + E1_TIPO ) + 'SUB'
		cPedido		:= aAnalysis[ nI, 1 ]
		cParcela    := SE1->E1_PARCELA
		dDataNf		:= SE1->E1_EMISSAO
		// Localizar o pedido de venda para encontrar o título PR.
		SC5->( dbSetOrder( 1 ) )
		If SC5->( dbSeek( xFilial( 'SC5' ) + cPedido) )

            //MUDA PREFIXO PARA VENDAS DE OPERAÇÃO 51 2 52 ANTERIORES AO PONTO DE FATURAMENTO
			SC6->( DbSetOrder(1) )		// C5_FILIAL+C5_NUM
			SC6->( MsSeek( xFilial("SC6") + cPedido ) )
			WHILE !SC6->(EOF()) .and.  (xFilial("SC6") + cPedido == SC6->C6_FILIAL + SC6->C6_NUM)
			    IF SC6->C6_XOPER $ "51/52" 
			    	cPrefixo:='RCO'
			    ENDIF
				SC6->(DbSkip())
			Enddo
			
			cSql := "SELECT R_E_C_N_O_ RECE1 "
			cSql += " FROM "+RetSqlName("SE1")
			cSql += " WHERE E1_FILIAL = '"+xFilial("SE1")+"' AND "
			cSql += " E1_TIPO ='PR' AND "
			cSql += " E1_PEDIDO = '"+cPedido+"'  AND "
			if  lVldSldPR   
				cSql += " E1_PARCELA = '"+cParcela+"' AND "
				cSql += " E1_SALDO > 0 AND "
			Endif
			cSql += " D_E_L_E_T_ = ' ' "

			cTrbSql:=GetNextAlias()
			PLSQuery( cSql, cTrbSql )

			aAuxSE1		:= {}
			While !(cTrbSql)->(Eof())
				AAdd( aAuxSE1, { SC5->C5_NUM, (cTrbSql)->RECE1 } )
				(cTrbSql)->(DbSkip())
			End
			(cTrbSql)->(DbCloseArea())
			FErase( cTrbSql + GetDBExtension() )

			aRet := {}
			For nX:=1 to Len(aAuxSE1)
				//Posiciona o registro para identificar o valor atual da PR
				SE1->( dbGoTo( aAuxSE1[ nX, 2 ]) )
                SE5->(dbSetOrder(7))
                SE5->(dBSeek(Xfilial('SE5')+ SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO+SE1->E1_CLIENTE+SE1->E1_LOJA))
                lContinua:=.T.                                          
		   		dDataRF	:=SE1->E1_EMISSAO
				WHILE ! SE5->(EOF()) .AND. (XFILIAL("SE5")+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO+SE1->E1_CLIENTE+SE1->E1_LOJA)==(SE5->E5_FILIAL+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO+SE5->E5_CLIFOR+SE5->E5_LOJA)
				    IF ALLTRIM(SE5->E5_HISTOR)==(ALLTRIM(cHistory)) 
				         lContinua:=.F.                                          
				    ENDIF 
					SE5->(DbSkip())
				EndDo
				
				If (lContinua .or. !lVldSldPR ) .And. SE1->E1_SALDO>0
					if lVldData
					   dDataBase:=iif( dtos(ddataNF)>dtoS(dDataRF) , dDataNF , DdataRF )
					Endif
					aFaVlAtuCR := FaVlAtuCr('SE1', dDataBase)
					AAdd( aDadosBaixa, { SE1->( RecNo() ), cHistory, AClone( aFaVlAtuCR ) } )
					//Verifica se PR conta com mais saldo que titulo que ira substituir
					//pois caso positivo baixa saldo todo do PR
					If (nDefinitivo - SE1->E1_SALDO) > 0
						nBaixa := SE1->E1_SALDO
					Else
						nBaixa := nDefinitivo
					Endif
					//Baixa por substituição
					
					
					aBaixa := { 'SUB', nBaixa, cA6_COD, cA6_AGENCIA, cA6_NUMCON, dDataBase, dDataBase }
					aRet := U_CSFA530( 1, { aAuxSE1[ nX, 2 ] }, aBaixa, /*aNCC_RA*/, /*aLiquidacao*/, aParam, /*bBlock*/, /*aEstorno*/, aDadosBaixa, /*aNewSE1*/ )
					SE5->(MSUNLOCK())
			  	   	SE1->(MSUNLOCK())
	  			   	SA1->(MSUNLOCK())
					Conout("EXECUÇÃO PILHA => "+ProcName(0)+" -> "+ProcName(1)+" -> U_CSFA530 - m460fim lin 506")
			        
					aFaVlAtuCR := {}
					aDadosBaixa := {}
					aBaixa := {}
			
					// Caso haja consistência de retorno, armazenar no array aLOG.
					If Len( aRet )>0
						AAdd( aLog, { AClone( aRet ) } )
						aRet := {}
					Endif
				Endif
			Next nX
		
			//Identifica a Ncc da Parcela para fazer a baixa
			
			cSql := "SELECT R_E_C_N_O_ RECE1 FROM "+RetSqlName("SE1")+" WHERE E1_FILIAL = '"+xFilial("SE1")+"' AND "
			cSql += "E1_TIPO ='NCC' AND "
			cSql += "E1_PREFIXO ='"+cPrefixo+"' AND "
			cSql += "E1_PEDIDO = '"+cPedido+"'  AND "
			cSql += "E1_PARCELA = '"+cParcela+"' AND "
			cSql += "E1_SALDO > 0 AND "
			cSql += "D_E_L_E_T_ = ' ' "

			cSql := ChangeQuery(cSql)
			cTrbSql := GetNextAlias()
			PLSQuery( cSql, cTrbSql )

			aAuxSE1:={}
			While !(cTrbSql)->(Eof())
				AAdd( aAuxSE1, { SC5->C5_NUM, (cTrbSql)->RECE1 } )
				(cTrbSql)->(DbSkip())
			End
			(cTrbSql)->(DbCloseArea())
			FErase( cTrbSql + GetDBExtension() )
            
       		aRet := {}

			For nX:=1 to Len(aAuxSE1)
				SE1->( dbGoTo( aAuxSE1[ nX, 2 ]) )
                dDataRF	:=SE1->E1_EMISSAO
		    	if lVldData
					   dDataBase:=iif( dtos(ddataNF)>dtoS(dDataRF) , dDataNF , DdataRF )
				Endif
		    	
		    
		    	aRet := U_CSFA530( 3, { aAnalysis[ nI, 2]  }, /*aBaixa*/, {aAuxSE1[ nX, 2 ]}, /*aLiquidacao*/, aParam, /*bBlock*/, /*aEstorno*/, /*aDadosBaixa*/, /*aNewSE1*/ )
				SE5->(MSUNLOCK())
	  	   		SE1->(MSUNLOCK())
	  	   		SA1->(MSUNLOCK())             
				Conout("EXECUÇÃO PILHA => "+ProcName(0)+" -> "+ProcName(1)+" -> U_CSFA530 - m460fim lin 556")
				
				// Caso haja consistência de retorno, armazenar no array aLOG.
				If Len( aRet )>0
					AAdd( aLog, { AClone( aRet ) } )
					aRet := {}
				Endif
			Next nX
		
		Endif
	Next nI
	
	//Identificar todas as NF e NCC com resíduo para compensação
	//Se faz necessário porque a ERP trata diferença de dízima na primeira parcela e a Operadora de cartão na ultima
	If Len( aAnalysis ) > 0 .AND. !Empty(cPedido)
		
		dDataBlq := stod("")
		aSe1Nf :={}
		aSe1Emi := {}
		aSe1Ncc:={}
		aRet := {}
		For nI := 1 To Len( aAnalysis )
			
			aSe1Nf :={}
			aSe1Emi := {}
			aSe1Ncc:={}
			Aadd( aSe1Nf, aAnalysis[ nI, 2 ] )
			
			SE1->( dbGoTo( aAnalysis[ nI, 2 ]) )
			SC5->(Dbseek(Xfilial()+cPedido))

			lSoResidual := lVldSldRes
			if se1->e1_tipo == 'NF ' .and. se1->e1_parcela = ' '
				cSql := "SELECT count(*) totparc "
				cSql += " FROM "+RetSqlName("SE1")
				cSql += " WHERE E1_FILIAL = '"+xFilial("SE1")+"' AND "
				cSql += " E1_TIPO = 'NCC' AND"
				cSql += " E1_PARCELA != ' ' AND"
				cSql += " E1_PEDIDO = '"+cPedido+"' AND "
				cSql += " D_E_L_E_T_ = ' ' "
				cTrbSql:=GetNextAlias()
				PLSQuery( cSql, CTrbSql )
				if !(cTrbSql)->(Eof()) .and. (cTrbSql)->totparc > 0
					lSoResidual := .f.
				endif
				(cTrbSql)->(DbCloseArea())
				FErase( cTrbSql + GetDBExtension() )
			endif
			cSql := "SELECT R_E_C_N_O_ RECE1,E1_EMISSAO "
			cSql += " FROM "+RetSqlName("SE1")
			cSql += " WHERE E1_FILIAL = '"+xFilial("SE1")+"' AND "
			cSql += " E1_TIPO ='NCC' AND"
			cSql += " E1_PEDIDO = '"+cPedido+"' AND "
			if lVldSldRes .and. lSoResidual // Trata somente saldo residual de 0,02 Default (.t.)
				cSql += " E1_SALDO > 0 AND E1_SALDO <= 0.02  AND "
			ELSE
				cSql += " E1_SALDO > 0 AND " // Neste caso está forçando a compensação dos saldos em aberto.
			Endif
			cSql += " D_E_L_E_T_ = ' ' "
	        
			cTrbSql:=GetNextAlias()
			PLSQuery( cSql, CTrbSql )
	
			While !(cTrbSql)->(Eof())
				AAdd( aSe1Ncc, (cTrbSql)->RECE1 )
				AAdd( aSe1Emi, (cTrbSql)->E1_EMISSAO )
				(cTrbSql)->(DbSkip())
			End
			(cTrbSql)->(DbCloseArea())
			FErase( cTrbSql + GetDBExtension() )
	          
	        if Len(aSe1Ncc)>0
			    dDataBlq := GetMV("MV_DATAFIN") 
				dDataNf	:= SE1->E1_EMISSAO
				for nX := 1 to Len(aSe1Ncc)
				  dDataRF := aSe1Emi[nX]
				  if lVldData
				     dDataBase := iif( dtos(ddataNF)>dtoS(dDataRF) , dDataNF , DdataRF )
				  	 if dtos(dDataBlq) >= dtos(dDataBase)
				      	dDatabase := dDataAnt
				  	 endif
				  endif
				  aRet := U_CSFA530( 3, aSe1NF, /*aBaixa*/, { aSe1NCC[nX] }, /*aLiquidacao*/, aParam, /*bBlock*/, /*aEstorno*/, /*aDadosBaixa*/, /*aNewSE1*/ )
				  SE5->(MSUNLOCK())
		  	   	  SE1->(MSUNLOCK())
		  	   	  SA1->(MSUNLOCK())             
				next
				Conout("EXECUÇÃO PILHA => "+ProcName(0)+" -> "+ProcName(1)+" -> U_CSFA530 - m460fim lin 633")
	   		endif
	   		
	   		// Caso haja consistência de retorno, armazenar no array aLOG.
			If Len( aRet )>0
				AAdd( aLog, { AClone( aRet ) } )
				aRet := {}
			Endif
		
		Next

	Endif

	//Tratamento para Agendamento Externo                               
	//Claudio Henrique Corrêa - 15/05/2015 - Personalização para fazer a compensação da NCC de Atendimento gerada no CNAB

	/* Retirado por giovanni e compatibilizado para as rotinas de varejo
	DbSelectArea("SC5")
	DbSetOrder(1)
	IF DbSeek(xfilial('SC5')+QRYSD2->D2_PEDIDO)
			
		nTaxaCM  := 0
		aTxMoeda := {}
		
		nRecnoNDF := 0
		nRecnoE1  := 0
		
		lRetOK    := .T.
		
		cPedos 	:= SC5->C5_NUMATEX
		cPedido := SC5->C5_NUM
		
		dbSelectArea("SE1")
		dbSetOrder(30)
		dbSeek(XFILIAL("SE1")+cPedido)
		
		If SE1->(Found())  //IDENTIFICA O TITULO GERADO PELO PEDIDO
			
			cPeditit := SE1->E1_PEDIDO
			
			nRecnoE1 := RECNO()
			
		End If
		
		dbSelectArea("SE1")
		DbOrderNickName("ORD_SERV")
		dbSeek(XFILIAL("SE1")+ALLTRIM(cPedos))
		
		If SE1->(Found()) // IDENTIFICA O TITULO GERADO PELO ATENDIMENTO
			
			nOs := cValToChar(SE1->E1_OS)
			
			cNumTit := SE1->E1_NUM
			
			nRecnoRA := RECNO()  // RECNO TITULO A SER BAIXADO
			
			cAgconta := GETNEWPAR("MV_CSGBOL2","9999;99999-0")
			cAgencia := SubStr(cAgconta,1,4)
			cConta := SubStr(cAgconta,7,5)
			cDigito := SubStr(cAgconta,13,1)
			cNumbanco := GETNEWPAR("MV_CSGBOL1","341")
			cCarteira := GETNEWPAR("MV_CSGBOL3","175")
			cPrefixo := GETNEWPAR("MV_CSBOL5","OS")
			cTitulo := GETNEWPAR("MV_CSGBOL6","NCC")
			
			PERGUNTE("AFI340",.F.)
			lContabiliza  := MV_PAR11 == 1
			lAglutina   := MV_PAR08 == 1
			lDigita   := MV_PAR09 == 1
			
			nTaxaCM := RecMoeda(dDataBase,SE1->E1_MOEDA)
			
			aAdd(aTxMoeda, {1, 1} )
			
			aAdd(aTxMoeda, {2, nTaxaCM} )
			
			SE1->(dbSetOrder(1)) //E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+E1_FORNECE+E1_LOJA
			
			aRecRA := { nRecnoRA }
			aRecSE1 := { nRecnoE1 }
			
			If !MaIntBxCR(3,aRecSE1,,aRecRA,,{lContabiliza,lAglutina,lDigita,.F.,.F.,.F.},,,,,dDatabase )
				
				Help("XAFCMPAD",1,"HELP","XAFCMPAD","Não foi possível a compensação"+CRLF+" do titulo do adiantamento",1,0)
				lRet := .F.
				
			ENDIF
		ENDIF
	Endif
    */
	//Novo tratamento para compensação de agendamento externo.
	If Len( aAnalysis ) >0 
		
		aSe1Nf :={}
		aSe1Ncc:={}
		aRet := {}
		For nI := 1 To Len( aAnalysis )
			
			cPedido		:= aAnalysis[ nI, 1 ]
			
			aSe1Nf :={}
			aSe1Ncc:={}
			
			Aadd( aSe1Nf, aAnalysis[ nI, 2 ] )
			
			SE1->( dbGoTo( aAnalysis[ nI, 2 ]) )
			SC5->(Dbseek(Xfilial()+cPedido))
			
			OrdServ	:= SC5->C5_NUMATEX
			
			if !empty (OrdServ)
				cSql := "SELECT R_E_C_N_O_ RECE1 "
				cSql += " FROM "+RetSqlName("SE1")
				cSql += " WHERE E1_FILIAL = '"+xFilial("SE1")+"' AND "
				cSql += " E1_OS = '"+OrdServ+"' AND "
				cSql += " E1_TIPO ='NCC' AND"
				cSql += " E1_SALDO > 0 AND " 
				cSql += " D_E_L_E_T_ = ' ' "
		    Endif
			cTrbSql:=GetNextAlias()
			PLSQuery( cSql, CTrbSql )
	
			While !(cTrbSql)->(Eof())
				AAdd( aSe1Ncc, (cTrbSql)->RECE1 )
				(cTrbSql)->(DbSkip())
			End
			(cTrbSql)->(DbCloseArea())
			FErase( cTrbSql + GetDBExtension() )
	          
	        If Len(aSe1Ncc)>0
			
			    aRet := U_CSFA530( 3, aSe1NF, /*aBaixa*/, aSe1NCC, /*aLiquidacao*/, aParam, /*bBlock*/, /*aEstorno*/, /*aDadosBaixa*/, /*aNewSE1*/ )
				SE5->(MSUNLOCK())
		  	   	SE1->(MSUNLOCK())
		  	   	SA1->(MSUNLOCK())             
		  	   	Conout("EXECUÇÃO PILHA => "+ProcName(0)+" -> "+ProcName(1)+" -> U_CSFA530 - m460fim lin 763")
	   		Endif
	   		
	   		// Caso haja consistência de retorno, armazenar no array aLOG.
			If Len( aRet )>0
				AAdd( aLog, { AClone( aRet ) } )
				aRet := {}
			Endif
		
		Next

	Endif
	
	dDatabase:=dDataAnt

	MntVenNat(aAnalysis)

Return

/*/{Protheus.doc} TRNSCARG

Rotina especifica para transmissão de nota fiscal referente a pedidos de vendas com entrega em domicilio

@author Totvs SM - David
@since 14/12/2011

/*/

Static Function TrnsCarg(nRecSF2Hrd,cPedido)
//Local aRetTrans		:= {}
//Local aRetEspelho	:= {}
//Local nTime			:= 0
//Local cRandom		:= ""
//Local nWait			:= 0
//Local nRecC6		:= 0
//Local cMensagem		:= ""
//Local cNotaHrd		:= ""
//Local lRet			:= .T.
//Local cGtId			:= cUserName

SC5->(DbSetOrder(1))

If nRecSF2Hrd > 0 .and. SC5->(DbSeek(xFilial("SC5")+cPedido))

	// Se chegou nota de hardware, transmite e gera espelho tb
	SF2->( DbGoto(nRecSF2Hrd) )

	lFat		:= .T.  //Na liberação manual apenas fatura
	lServ 		:= .T.
	lProd		:= .T.
	lEnt		:= .F.
	lRecPgto	:= .F.  //Na liberação manual Não gera recibo no VNDA190
	lGerTitRecb	:= .F.  //Na liberação manual Não gera título para recibo no VNDA190

	// Transmite a nota eletronica para o SEFAZ
	MsgRun("Transmitindo para Sefaz Pedido "+cPedido,"",{|| StartJob("U_VNDA190P",GetEnvServer(),.F.,cEmpAnt,cFilAnt,SC5->(Recno()),lfat,lServ,lProd,lEnt,lRecPgto,lGerTitRecb)})

EndIf

Return

//ROGERIO BISPO (UPDUO) - 30/3/2021
//Altera vencimentos e natureza dos titulos
Static Function MntVenNat(aAnalysis)

Local aAreaSE1	:= SE1->(GetArea())	//Salva a area atual da tabela SE1
Local nI := 0
Local cSql := ""
Local cTrbSql := ""
Local cTrb1Sql := ""
Local cTmpSql := ""
Local cNaturez := ""
Local cVenRea  := ""

If Len( aAnalysis ) > 0

	For nI := 1 To Len( aAnalysis )

		SE1->( dbGoTo( aAnalysis[ nI, 2 ]) )
		if !empty(aAnalysis[ nI, 1 ])  .and. aAnalysis[ nI, 1 ] == se1->e1_pedido .and. ;
			se1->e1_tipo == 'NF ' .and. se1->e1_parcela = ' '

			cNaturez := ""
			cVenRea  := ""

			cTrbSql := GetNextAlias()

			cSql := "SELECT max(E1_VENCREA) MaxVencRea,max(E1_NATUREZ) MaxNaturez"
			cSql += " FROM "+RetSqlName("SE1")
			cSql += " WHERE E1_FILIAL = '"+xFilial("SE1")+"' AND "
			cSql += " E1_PEDIDO = '"+aAnalysis[ nI, 1 ]+"' AND E1_TIPO='NCC' AND"
			cSql += " D_E_L_E_T_ = ' ' "
			PLSQuery( cSql, cTrbSql )
			if !(cTrbSql)->(Eof())
			   cVenRea  := (cTrbSql)->MaxVencRea
			   cNaturez := (cTrbSql)->MaxNaturez
			endif
			(cTrbSql)->(DbCloseArea())
			FErase( cTrbSql + GetDBExtension() )

			cSql := "SELECT max(E1_VENCREA) MaxVencRea,max(E1_NATUREZ) MaxNaturez"
			cSql += " FROM "+RetSqlName("SE1")
			cSql += " WHERE E1_FILIAL = '"+xFilial("SE1")+"' AND "
			cSql += " E1_PEDIDO = '"+aAnalysis[ nI, 1 ]+"' AND E1_TIPO='PR' AND"
			cSql += " D_E_L_E_T_ = ' ' "
			PLSQuery( cSql, cTrbSql )
			if !(cTrbSql)->(Eof()) 
			   cVenRea  := (cTrbSql)->MaxVencRea
			   if empty(cNaturez)
			      cNaturez := (cTrbSql)->MaxNaturez
			   endif
			endif
			(cTrbSql)->(DbCloseArea())
			FErase( cTrbSql + GetDBExtension() )

			if !empty(cNaturez) .and. !empty(cVenRea) .and. ;
			   ( cNaturez != se1->e1_naturez .or. cVenRea != dtos(se1->e1_vencrea) )
				   
			   SE1->( RecLock( "SE1", .F. ) )
			   SE1->E1_VENCTO  := StoD(cVenRea)
			   SE1->E1_VENCREA := StoD(cVenRea)
			   SE1->E1_NATUREZ := cNaturez
			   SE1->(MsUnLock())

			   /*
			   cSql := "UPDATE "+RetSqlName("SE5")+" E5 SET E5_NATUREZ = '"+SE1->E1_NATUREZ+"' "
			   cSql += "WHERE E5_FILIAL = '"+SE1->E1_FILIAL+"' AND E5_PREFIXO = '"+SE1->E1_PREFIXO+"' "
			   cSql += "AND E5_NUMERO = '"+SE1->E1_NUM+"' AND E5_PARCELA = '"+SE1->E1_PARCELA+"' "
			   cSql += "AND E5_TIPO = '"+SE1->E1_TIPO+"' AND E5_CLIFOR = '"+SE1->E1_CLIENTE+"' "
			   cSql += "AND E5_LOJA = '"+SE1->E1_LOJA+"' AND E5.D_E_L_E_T_ = ' ' "
			   cSql += "AND E5_NATUREZ != '"+SE1->E1_NATUREZ+"'"
			   if TCSqlExec(cSql) < 0
			      conout("TCSQLError() " + TCSQLError())
			   endif
			   */

			   cSql := "SELECT E5.R_E_C_N_O_ RECSE5 FROM "+RetSqlName("SE5")+" E5 "
			   cSql += "WHERE E5_FILIAL = '"+SE1->E1_FILIAL+"' AND E5_PREFIXO = '"+SE1->E1_PREFIXO+"' "
			   cSql += "AND E5_NUMERO = '"+SE1->E1_NUM+"' AND E5_PARCELA = '"+SE1->E1_PARCELA+"' "
			   cSql += "AND E5_TIPO = '"+SE1->E1_TIPO+"' AND E5_CLIFOR = '"+SE1->E1_CLIENTE+"' "
			   cSql += "AND E5_LOJA = '"+SE1->E1_LOJA+"' AND E5.D_E_L_E_T_ = ' ' "
			   cSql += "AND ( E5_NATUREZ != '"+SE1->E1_NATUREZ+"' OR E5_VENCTO != '"+DtoS(SE1->E1_VENCTO)+"' )"
			   cTrb1Sql := GetNextAlias()
			   PLSQuery( cSql, cTrb1Sql )
			   while !(cTrb1Sql)->(Eof()) 

			     SE5->( dbGoTo( (cTrb1Sql)->recse5 ) )
					
				 SE5->( RecLock( "SE5", .F. ) )
				 SE5->E5_NATUREZ := SE1->E1_NATUREZ
				 SE5->E5_VENCTO  := SE1->E1_VENCTO
				 SE5->(MsUnLock())
					
				 if SE5->E5_TABORI == "FK1"
				    cSql := "SELECT R_E_C_N_O_ RECFK1 FROM "+RetSqlName("FK1")+" WHERE FK1_FILIAL = '"+xFilial("FK1")+"' "
				    cSql += "AND FK1_IDFK1 = '"+SE5->E5_IDORIG+"' AND D_E_L_E_T_ = ' ' "
				    cTmpSql := GetNextAlias()
				    PLSQuery( cSql, cTmpSql )
				    if !(cTmpSql)->( Eof() )

				 	   FK1->( dbGoTo( (cTmpSql)->recfk1 ) )

					   FK1->( RecLock( "FK1", .F. ) )
					   FK1->FK1_NATURE := SE1->E1_NATUREZ
					   FK1->FK1_VENCTO := SE1->E1_VENCTO
					   FK1->(MsUnLock())
					endif
					(cTmpSql)->( dbCloseArea() )
					FErase( cTmpSql + GetDBExtension() )
				 elseif SE5->E5_TABORI == "FK5"
				    cSql := "SELECT R_E_C_N_O_ RECFK5 FROM "+RetSqlName("FK5")+" WHERE FK5_FILIAL = '"+xFilial("FK5")+"' "
				    cSql += "AND FK5_IDMOV = '"+SE5->E5_IDORIG+"' AND D_E_L_E_T_ = ' ' "
				    cTrbSql := GetNextAlias()
				    PLSQuery( cSql, cTmpSql )
				    if !(cTmpSql)->( Eof() )
					   
				       FK5->( dbGoTo( (cTmpSql)->recfk5 ) )
						  
				  	   FK5->( RecLock( "FK5", .F. ) )
					   FK5->FK5_NATURE := SE1->E1_NATUREZ
					   FK5->(MsUnLock())
					endif
					(cTmpSql)->( dbCloseArea() )
					FErase( cTmpSql + GetDBExtension() )
				 endif
				 (cTrb1Sql)->( dbSkip() )
			   end
			   (cTrb1Sql)->(DbCloseArea())
			   FErase( cTrb1Sql + GetDBExtension() )
			   Conout("EXECUÇÃO PILHA => "+ProcName(0)+" -> "+ProcName(1)+" -> m460fim lin 882")
			endif
  		endif
	
	Next
endif
RestArea(aAreaSE1)	//Restaura a area da tabela SE1
Return
