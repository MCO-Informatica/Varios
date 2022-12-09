#Include "PROTHEUS.Ch"

#define STR0001 "Contabilizacao da politica de garantia de Hradware"
#define STR0002 "O  objetivo  deste programa  é  o  de  gerar  lancamentos  contabeis"
#define STR0003 "a partir dos pedidos com Hardware e não validados nos ultimos 180 dias "
#define STR0004 " "

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CFSA510   º Autor ³Giovanni A Rodriguesº Data ³  17/11/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Processar integração contábil da política de Garantia      º±±
±±º          ³ Tabela GTLEGADO Registros do tipo P                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Política de Garantia Certisign    			              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function CFSA510G( aParSch, cC5_NUM )


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


Local aSays 	:= {}
Local aButtons	:= {}
Local dDataSalv := nil
Local nOpca 	:= 0

Private cCadastro :="Integração contábil da Política de Garantia de Hardware"
Private cString := "GTLEGADO"

Default aParSch := {}
Default cC5_NUM := ''

// Abre empresa para Faturamento retirar comentário para processamento em JOB


RpcSetType( 3 )
RpcSetEnv( '01', '02' )

If !empty(aParSch)
	dDataBase:=CtoD(aParSch[1])
Endif

dDataSalv := dDataBase
/*
Pergunte("CFSA510",.f.)

AADD(aSays,OemToAnsi( STR0002 ) )
AADD(aSays,OemToAnsi( STR0003 ) )
AADD(aSays,OemToAnsi( STR0004 ) )

AADD(aButtons, { 5,.T.,{|| Pergunte("CFSA510",.T. ) } } )
AADD(aButtons, { 1,.T.,{|| nOpca:= 1, If( CTBOk(), FechaBatch(), nOpca:=0 ) }} )
AADD(aButtons, { 2,.T.,{|| FechaBatch() }} )

FormBatch( cCadastro, aSays, aButtons )
*/	                              
	
	
	//Trata as validações
	If FindFunction("CTBSERIALI")
		While !CTBSerialI("CTBPROC","ON")
		EndDo
	EndIf
	Processa({|lEnd| CFSA510Proc("LANCTBPRD", cC5_NUM)})
	If FindFunction("CTBSERIALI")
		CTBSerialF("CTBPROC","ON")
	EndIf
    
    dDataBase := dDataSalv
	
	//Trata as validações
	If FindFunction("CTBSERIALI")
		While !CTBSerialI("CTBPROC","ON")
		EndDo
	EndIf
	Processa({|lEnd| CFSA510Proc("REVLANCTBPRD", cC5_NUM)})
	If FindFunction("CTBSERIALI")
		CTBSerialF("CTBPROC","ON")
	EndIf



	dDataBase := dDataSalv

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³CFSA510Proc³ Autor ³                     ³ Data ³ 17/11/14  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Processamento do lancamento contabil SZ5                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CFSA510Proc()                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function CFSA510Proc(cTipo, cXpedido)

Local cLote		:= CriaVar("CT2_LOTE")
Local cArquivo
Local cPadrao
Local lHead		:= .F.					// Ja montou o cabecalho?
Local lPadrao
Local lAglut
Local nTotal	:=0
Local nHdlPrv	:=0
Local nBytes	:=0
Local nHdlImp
Local nTamArq
Local nTamLinha := 1 //Iif(Empty(mv_par06),512,mv_par06)
Local cQuery    :="" 
Local cAliasTRB := GetNextAlias()
Local aFlagCTB:={}
Local aSe1Nf:={}
Local aSe1Ncc:={}
//Local dDataRef:=dDataBase - 181
//Local dDataAnt:=dDataBase
Local aLog    :={}
Private aRotina := MenuDef()
Private Inclui := .T.							



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica o N£mero do Lote                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ctipo=="LANCTBPRD"

	cLote := "008823"

	cQuery:=" SELECT "
	cQuery+=" * "
    cQuery+="FROM "
	cQuery+="PROTHEUS.GTLEGADO GT "
	cQuery+="WHERE "
	cQuery+="GT.GT_TYPE='P' "
	cQuery+="AND GT.GT_DTREF<='"+DtoS(dDataBase)+"' "
	cQuery+="AND GT.GT_DATA <='"+DtoS(dDataBase)+"' "
	cQuery+="AND GT.GT_LANCTBPRD=' ' "
	cQuery+="AND GT.D_E_L_E_T_=' ' "
	IF .NOT. Empty( cXpedido )
		cQuery+="AND GT.GT_PEDVENDA = '" + cXpedido + "' "
	EndIF
	CQuery+=" ORDER BY GT.GT_PEDGAR, GT.GT_TYPE, GT.GT_PRODUTO"

	
	
	cQuery := ChangeQuery(cQuery)
	
	nRecnos:= 1 //Contar registros resultante da consulta
	
	cCount :=' SELECT COUNT(*) COUNT FROM ( ' + cQuery + ' ) QUERY '
	
	If At('ORDER  BY', Upper(cCount)) > 0
		cCount := SubStr(cCount,1,At('ORDER  BY',cCount)-1) + SubStr(cCount,RAt(')',cCount))
	Endif
	 
	DbUseArea( .T., 'TOPCONN', TCGENQRY(,,cCount),cAliasTRB,.F.,.T.)
	nRecnos := (cAliasTRB)->COUNT
	(cAliasTRB)->(DbCloseArea())
	
	IF !(nRecnos==0)
	
		cAliasTRB := GetNextAlias()
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasTRB,.T.,.T.)
		                              
		
		cLpLanCtb := "223"
		lLpLanCtb := VerPadrao(cLpLanCtb)
		
		nRecGtLed :=0
		
		If select("GTLEGADO") <= 0
			USE GTLEGADO ALIAS GTLEGADO SHARED NEW VIA "TOPCONN"
			If NetErr()
				UserException("Falha ao abrir GTLEGADO - SHARED" )
			Endif
			DbSetIndex("GTLEGADO02")
			DbSetOrder(1)
		Endif                            
		
		aFlagCTB:={}
		
		IF lLpLanCtb
		
			ProcRegua(nRecnos)
			nHdlPrv := HeadProva(cLote,"CFSA510G",Substr(cUsuario,7,6),@cArquivo)
			
			While !(cAliasTRB)->(Eof())
			    
			    IncProc("Política de Garantia. Passo 1 - Contabilização") //Atualiza o contador da Regua de progresso
		        //Mantem o registro posicionado no cadastro de Validações do Pedido GAR SZ5
		        //Atualiza a data base para contabilização
		    	DbSelectArea('GTLEGADO')
			    GTLEGADO->(DBGOTO((cAliasTRB)->R_E_C_N_O_))    
				aAdd(aFlagCTB,{"GT_LANCTBPRD",dDataBase,"GTLEGADO",(cAliasTRB)->R_E_C_N_O_,0,0,0})
				nTotal += DetProva(nHdlPrv,cLpLanCtb,"CFSA510G",cLote,,,,,,,,@aFlagCTB)
			    //Vai para o próximo Registro de processamento                                
		   	    (cAliasTRB)->(DbSkip()) 
		     EndDo   
		     //Gera o Rodapé do lançamento
		     RodaProva(nHdlPrv,nTotal)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Envia para Lan‡amento Cont bil                      ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			lDigita	:=.F.
			lAglut 	:=.F.
			cA100Incl(cArquivo,nHdlPrv,3,cLote,lDigita,lAglut,,,,@aFlagCTB)
			nTotal  := 0
				
		
		EndIf
	
		(cAliasTRB)->(DbCloseArea())
	
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica os Pedidos contabilizados sem baixa de NCC          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	cQuery    :="" 
	cAliasTRB := GetNextAlias()
	
	
	cQuery:=" SELECT "
	cQuery+=" * "
    cQuery+="FROM "
	cQuery+="PROTHEUS.GTLEGADO GT "
	cQuery+="WHERE "
	cQuery+="GT.GT_TYPE='P' "
	cQuery+="AND GT.GT_DTREF<='"+DtoS(dDataBase)+"' "
	cQuery+="AND GT.GT_DATA <='"+DtoS(dDataBase)+"' "
	cQuery+="AND GT.GT_LANCTBPRD<>' ' "
	cQuery+="AND GT.GT_DTBAIXA=' ' "
	cQuery+="AND GT.D_E_L_E_T_=' ' "
	IF .NOT. Empty( cXpedido )
		cQuery+="AND GT.GT_PEDVENDA = '" + cXpedido + "' "
	EndIF
	CQuery+=" ORDER BY GT.GT_PEDGAR, GT.GT_TYPE, GT.GT_PRODUTO"

	
	cQuery := ChangeQuery(cQuery)
	
	nRecnos:= 1 //Contar registros resultante da consulta
	
	cCount :=' SELECT COUNT(*) COUNT FROM ( ' + cQuery + ' ) QUERY '
	
	If At('ORDER  BY', Upper(cCount)) > 0
		cCount := SubStr(cCount,1,At('ORDER  BY',cCount)-1) + SubStr(cCount,RAt(')',cCount))
	Endif
	 
	DbUseArea( .T., 'TOPCONN', TCGENQRY(,,cCount),cAliasTRB,.F.,.T.)
	nRecnos := (cAliasTRB)->COUNT
	(cAliasTRB)->(DbCloseArea())
	
	IF !(nRecnos==0)
		
		aLog:={}            
		aRet:={}                           
		
		cAliasTRB := GetNextAlias()
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasTRB,.T.,.T.)
		
		nRecGtLed :=0
		
		If select("GTLEGADO") <= 0
			USE GTLEGADO ALIAS GTLEGADO SHARED NEW VIA "TOPCONN"
			If NetErr()
				UserException("Falha ao abrir GTLEGADO - SHARED" )
			Endif
			DbSetIndex("GTLEGADO02")
			DbSetOrder(1)
		Endif                            
		
		ProcRegua(nRecnos)
		
		// [1]-Contabiliza on-line.
		// [2]-Agluitna lançamentos contábeis.
		// [3]-Digita lançamento contábeis.
		// [4]-Juros para comissão.
		// [5]-Desconto para comissão.
		// [6]-Calcula comissão para NCC .
		aParam := {.F.,.F.,.F.,.F.,.F.,.F.}
		
		
		While !(cAliasTRB)->(Eof())
			
			IncProc("Política de Garantia. Passo 2 - Baixa das NCCs") 
		    
		    dDataCredito:=stod((cAliasTRB)->GT_LANCTBPRD)
			nVlrPrd		:=(cAliasTRB)->GT_VLRPRD
		  	
		  	DbSelectArea("SE1")
			DbSetOrder(1)
			DbSeek(xFilial('SE1')+'RCP'+(cAliasTRB)->GT_PEDVENDA)
		  		
		  	While !Eof().and. nVlrPrd>0 .AND. ALLTRIM(SE1->(E1_FILIAL+E1_PREFIXO+E1_NUM))==ALLTRIM((xFilial('SE1')+'RCP'+(cAliasTRB)->GT_PEDVENDA))
		  	    
		  		If SE1->E1_TIPO<>"NCC"
				  	SE1->(DbSkip())	
			  		Loop
		  		EndIf
		  	
		  		nRecSe1:=SE1->(Recno())
		  	
		  		If SE1->E1_SALDO>0
		 
			    	cBco      	:='' 
					cAge	  	:=''
				    cCta	  	:='' 
				    nSalE1	  	:= IIf(SE1->E1_SALDO>nVlrPrd,nVlrPrd,SE1->E1_SALDO)
				    nVlrPrd     := nVlrPrd-SE1->E1_SALDO
				   	aSE1Dados 	:= {}
				  	aRet        := {}
			   		aBaixa 		:= { "PLT", nSalE1, cBco,cAge,cCta, dDataCredito, dDataCredito }
			        aFaVlAtuCR 	:= FaVlAtuCr("SE1",dDataCredito)                           
		        	
			   		AAdd( aSE1Dados, { nRecSe1, "Bx PLT GAR PED "+ (cAliasTRB)->GT_PEDVENDA , AClone( aFaVlAtuCR ) } )
		                 
		    	    aRet := U_CSFA530( 1, {nRecSe1}, aBaixa, /*aNCC_RA*/, /*aLiquidacao*/, aParam, /*bBlock*/, /*aEstorno*/, aSE1Dados, /*aNewSE1*/ )
              	   	
              	   	SE5->(MSUNLOCK())
			  	   	SE1->(MSUNLOCK())
		  		   	SA1->(MSUNLOCK())  

		  	        
        			//Atualiza campo de controle de contabilização para que no estorno seja criado um novo registro no E5. 
		 			//Por padrão este campo fica fazio se o motivo o baixa for não gerar movimento bancário. Porem, para efeito de posição de 
					//títulos a receber se faz necessário conhecer a data da baixa e a data de cancelamento da baixa. 
		  	        IF SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA)==SE1->(E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+E1_CLIENTE+E1_LOJA)
			  	        Reclock("SE5",.F.)
		  	     		SE5->E5_LOTE:='8850'
		  	         	MSUNLOCK()
	                Endif
		      	Endif
		
		        If Len( aRet )>0 
					AAdd( aLog, aClone( aRet ) )
					aRet := {}
				Endif
		        SE1->(DbGoTo(nRecSe1) )
		        SE1->(Dbskip())
		  	EndDo                           
		        
		    DbSelectArea("GTLEGADO")
			DbGoTo((cAliasTRB)->R_E_C_N_O_)   
			
			RecLock("GTLEGADO",.F.) 
				GTLEGADO->GT_DTBAIXA:=dDataCredito
			MsUnlock()
		
		    (cAliasTRB)->(DbSkip())
		Enddo        
	
		(cAliasTRB)->(DbCloseArea())
	
	Endif
	
	
	If Len( aLog ) > 0
	//	DlgToExcel( {{'ARRAY',"TESTE",{},aLog}})
	Endif
	
Endif	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ FAz a reversão do lançamento de produto                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ctipo=="REVLANCTBPRD"
	cLote		:= CriaVar("CT2_LOTE")
	cArquivo	:=Nil
	cPadrao		:=Nil
	lHead		:= .F.					// Ja montou o cabecalho?
	lPadrao		:=Nil
	lAglut		:=Nil
	nTotal		:=0
	nHdlPrv		:=0
	nBytes		:=0
	nHdlImp		:=Nil
	nTamArq		:=Nil
	nTamLinha 	:= 1 //Iif(Empty(mv_par06),512,mv_par06)
	cQuery    	:="" 
	cAliasTRB 	:= GetNextAlias()
	aFlagCTB	:={}
	aSe1Nf:={}
	aSe1Ncc:={}
					
	cLote := "008824"
	
	cQuery := ''
	cQuery += "SELECT D2_EMISSAO, " + CRLF
	cQuery += "       D2_PEDIDO, " + CRLF
	cQuery += "       D2_SERIE, " + CRLF
	cQuery += "       D2_DOC, " + CRLF
	cQuery += "       D2_COD, " + CRLF
	cQuery += "       GT.* " + CRLF
	cQuery += "FROM   " + RetSqlName('SD2') + " SD2 " + CRLF
	
	cQuery += "       INNER JOIN " + RetSqlName('SC6') + " SC6 " + CRLF
	cQuery += "               ON SC6.D_E_L_E_T_ = ' ' " + CRLF
	cQuery += "                  AND C6_FILIAL 	= '" + xFilial('SC6') + "' " + CRLF
	cQuery += "                  AND C6_NUM 	= D2_PEDIDO " + CRLF
	cQuery += "                  AND C6_ITEM 	= D2_ITEMPV " + CRLF
	
	cQuery += "       INNER JOIN " + RetSqlName('SC5') + " SC5 " + CRLF
	cQuery += "               ON SC5.D_E_L_E_T_ = ' ' " + CRLF
	cQuery += "                  AND C5_FILIAL 	= C6_FILIAL " + CRLF
	cQuery += "                  AND C5_NUM 	= C6_NUM " + CRLF
	cQuery += "                  AND C5_XORIGPV = ANY ( '2', 'A', 'B' ) " + CRLF
	IF .NOT. Empty( cXpedido )
		cQuery += "       AND C5_NUM = '" + cXpedido + "' " + CRLF
	EndIF
	
	cQuery += "       INNER JOIN PROTHEUS.GTLEGADO GT " + CRLF
	cQuery += "               ON GT.D_E_L_E_T_ = ' ' " + CRLF
	cQuery += "                  AND GT.GT_TYPE = 'P' " + CRLF
	cQuery += "                  AND GT.GT_PEDVENDA = C6_NUM " + CRLF
	cQuery += "                  AND GT.GT_PRODUTO 	= C6_PRODUTO " + CRLF
	cQuery += "                  AND GT.GT_LANCTBPRD > ' ' " + CRLF
	cQuery += "                  AND GT.GT_REVCTBPRD = ' ' " + CRLF
	
	cQuery += "WHERE  SD2.D_E_L_E_T_ = ' ' " + CRLF
	cQuery += "       AND D2_FILIAL <= '02' " + CRLF
	cQuery += "       AND D2_EMISSAO <= '" + dToS(dDataBase) + "' " + CRLF
	cQuery += "ORDER  BY D2_EMISSAO" + CRLF

	cQuery := ChangeQuery(cQuery)
	
	nRecnos:= 1 //Contar registros resultante da consulta
	
	cCount :=' SELECT COUNT(*) COUNT FROM ( ' + cQuery + ' ) QUERY '
	
	If At('ORDER  BY', Upper(cCount)) > 0
		cCount := SubStr(cCount,1,At('ORDER  BY',cCount)-1) + SubStr(cCount,RAt(')',cCount))
	Endif
	 
	DbUseArea( .T., 'TOPCONN', TCGENQRY(,,cCount),cAliasTRB,.F.,.T.)
	nRecnos := (cAliasTRB)->COUNT
	(cAliasTRB)->(DbCloseArea())
	
	IF !(nRecnos==0)
	
		cAliasTRB := GetNextAlias()
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasTRB,.T.,.T.)
		
		cLpRevCtb := "224"
		lLpRevCtb := VerPadrao(cLpRevCtb)
		
		nRecGtLed :=0
		
		If select("GTLEGADO") <= 0
			USE GTLEGADO ALIAS GTLEGADO SHARED NEW VIA "TOPCONN"
			If NetErr()
				UserException("Falha ao abrir GTLEGADO - SHARED" )
			Endif
			DbSetIndex("GTLEGADO02")
			DbSetOrder(1)
		Endif                            
		
		aFlagCTB:={}
		
		IF lLpRevCtb 
		
			ProcRegua(nRecnos)
			
			//dDataAnt:=dDataBase
			While !(cAliasTRB)->(Eof())
			    
				nHdlPrv := HeadProva(cLote,"CFSA510G",Substr(cUsuario,7,6),@cArquivo)
			    //dDataBase:= STOD((cAliasTRB)->D2_EMISSAO)
			                                             
			    While !(cAliasTRB)->(Eof()) //.and. (cAliasTRB)->D2_EMISSAO==dtos(dDatabase)    
			    
				    IncProc("Política de Garantia. Passo 1 - Reversão da Contabilização") //Atualiza o contador da Regua de progresso
			        //Mantem o registro posicionado no cadastro de Validações do Pedido GAR SZ5
			        //Atualiza a data base para contabilização
			    	DbSelectArea('GTLEGADO')
				    GTLEGADO->(DBGOTO((cAliasTRB)->R_E_C_N_O_))    
					aAdd(aFlagCTB,{"GT_REVCTBPRD",dDataBase,"GTLEGADO",(cAliasTRB)->R_E_C_N_O_,0,0,0})
					nTotal += DetProva(nHdlPrv,cLpRevCtb,"CFSA510G",cLote,,,,,,,,@aFlagCTB)
				    //Vai para o próximo Registro de processamento                                
			   	    (cAliasTRB)->(DbSkip()) 
			    Enddo
			     //Gera o Rodapé do lançamento
			     RodaProva(nHdlPrv,nTotal)
				 //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				 //³ Envia para Lan‡amento Cont bil                      ³
				 //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				 lDigita	:=.F.
				 lAglut 	:=.F.
				 cA100Incl(cArquivo,nHdlPrv,3,cLote,lDigita,lAglut,,,,@aFlagCTB)
				 nTotal  := 0
		     
		    EndDo   
	       // dDataBase:=dDataAnt
		
		EndIf
	
		(cAliasTRB)->(DbCloseArea())
	
	Endif


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica os Pedidos contabilizados sem baixa de NCC          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	cQuery    :="" 
	cAliasTRB := GetNextAlias()
	
	cQuery := ''
	cQuery += "SELECT D2_EMISSAO, " + CRLF
	cQuery += "       D2_PEDIDO, " + CRLF
	cQuery += "       D2_SERIE, " + CRLF
	cQuery += "       D2_DOC, " + CRLF
	cQuery += "       D2_COD, " + CRLF
	cQuery += "       GT.* " + CRLF
	cQuery += "FROM   " + RetSqlName('SD2') + " SD2 " + CRLF
	
	cQuery += "       INNER JOIN " + RetSqlName('SC6') + " SC6 " + CRLF
	cQuery += "               ON SC6.D_E_L_E_T_ = ' ' " + CRLF
	cQuery += "                  AND C6_FILIAL 	= '" + xFilial('SC6') + "' " + CRLF
	cQuery += "                  AND C6_NUM 	= D2_PEDIDO " + CRLF
	cQuery += "                  AND C6_ITEM 	= D2_ITEMPV " + CRLF
	
	cQuery += "       INNER JOIN " + RetSqlName('SC5') + " SC5 " + CRLF
	cQuery += "               ON SC5.D_E_L_E_T_ = ' ' " + CRLF
	cQuery += "                  AND C5_FILIAL 	= C6_FILIAL " + CRLF
	cQuery += "                  AND C5_NUM 	= C6_NUM " + CRLF
	cQuery += "                  AND C5_XORIGPV = ANY ( '2', 'A', 'B' ) " + CRLF
	IF .NOT. Empty( cXpedido )
		cQuery += "       AND C5_NUM = '" + cXpedido + "' " + CRLF
	EndIF
	
	cQuery += "       INNER JOIN PROTHEUS.GTLEGADO GT " + CRLF
	cQuery += "               ON GT.D_E_L_E_T_ = ' ' " + CRLF
	cQuery += "                  AND GT.GT_TYPE = 'P' " + CRLF
	cQuery += "                  AND GT.GT_PEDVENDA = C6_NUM " + CRLF
	cQuery += "                  AND GT.GT_PRODUTO = C6_PRODUTO " + CRLF
	cQuery += "                  AND GT.GT_DTBAIXA > ' ' " + CRLF
	cQuery += "                  AND GT.GT_DTESTBAIXA = ' ' " + CRLF
	
	cQuery += "WHERE  SD2.D_E_L_E_T_ = ' ' " + CRLF
	cQuery += "       AND D2_FILIAL <= '02' " + CRLF
	cQuery += "       AND D2_EMISSAO <= '" + dToS(dDataBase) + "' " + CRLF
	cQuery += "ORDER  BY D2_EMISSAO" + CRLF
	
	cQuery := ChangeQuery(cQuery)
	
	nRecnos:= 1 //Contar registros resultante da consulta
	
	cCount :=' SELECT COUNT(*) COUNT FROM ( ' + cQuery + ' ) QUERY '
	
	If At('ORDER  BY', Upper(cCount)) > 0
		cCount := SubStr(cCount,1,At('ORDER  BY',cCount)-1) + SubStr(cCount,RAt(')',cCount))
	Endif
	 
	DbUseArea( .T., 'TOPCONN', TCGENQRY(,,cCount),cAliasTRB,.F.,.T.)
	nRecnos := (cAliasTRB)->COUNT
	(cAliasTRB)->(DbCloseArea())
	
	IF !(nRecnos==0)
		aLog:={}            
		aRet:={}
		cAliasTRB := GetNextAlias()
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasTRB,.T.,.T.)
		
		
		If select("GTLEGADO") <= 0
			USE GTLEGADO ALIAS GTLEGADO SHARED NEW VIA "TOPCONN"
			If NetErr()
				UserException("Falha ao abrir GTLEGADO - SHARED" )
			Endif
			DbSetIndex("GTLEGADO02")
			DbSetOrder(1)
		Endif                            
		
		ProcRegua(nRecnos)
		
		While !(cAliasTRB)->(Eof())
			
			IncProc("Política de Garantia. Passo 2 - Reversão das Baixas de NCCs") 
			cPedido:=(cAliasTRB)->GT_PEDVENDA
			aSe1Nf :={}
			aSe1Ncc:={}
			
			//dDataAnt:=dDataBase
			While !(cAliasTRB)->(Eof()) .and. (cAliasTRB)->GT_PEDVENDA==cPedido
				
			    //dDataBase:=stod((cAliasTRB)->D2_EMISSAO)
	            //Identifica os títulos da nota fiscal do pedido
				DbSelectArea("SF2")
				DbSetOrder(1)
				IF DbSeek(xfilial('SF2')+(cAliasTRB)->D2_DOC+(cAliasTRB)->D2_SERIE)
					DbSelectArea("SE1")
					DbSetOrder(1)	//E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
					If MsSeek(xFilial("SE1") + SF2->F2_PREFIXO + SF2->F2_DUPL)
					   While !eof().and. SE1->E1_FILIAL+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_CLIENTE+SE1->E1_LOJA == (xFilial("SE1") + SF2->F2_PREFIXO + SF2->F2_DUPL+SF2->F2_CLIENTE+SF2->F2_LOJA);
					         .And. .NOT. Empty( SE1->E1_PEDIDO )

							nScan := aScan(aSe1Nf,SE1->( RecNo()))
					   	    if nScan <=0
					   	    	AAdd( aSe1Nf,  SE1->( RecNo()) )
                            Endif
							SE1->(DbSkip())
						Enddo
					EndIf
				EndIf
	            //Identifica as NCC´s Baixas por PLT
			  	DbSelectArea("SE5")
				DbSetOrder(7)
				DbSeek(xFilial('SE5')+'RCP'+(cAliasTRB)->GT_PEDVENDA)
			  		
			  	While !Eof() .and. ALLTRIM(SE5->(E5_FILIAL+E5_PREFIXO+E5_NUMERO))==ALLTRIM((xFilial('SE5')+'RCP'+(cAliasTRB)->GT_PEDVENDA))
			  	    
			  		If SE5->E5_TIPO<>"NCC"
					  	SE5->(DbSkip())	
				  		Loop
			  		EndIf
			  	    
			  		If SE5->E5_MOTBX<>"PLT"
					  	SE5->(DbSkip())	
				  		Loop
			  		EndIf
			  		  		
			  		If SE5->E5_SITUACA=='C'
					  	SE5->(DbSkip())	
				  		Loop
			  		EndIf
	
			  		nRecSe5:=SE5->(Recno())
			  	    cEstorno:=SE5->E5_SEQ
			  	    lTemEstorno:=.F.
					cChave  :=SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO+SE5->E5_CLIFOR+SE5->E5_LOJA+cEstorno
			  	    DbSelectArea("SE5")
					DbSetOrder(7)
					DbSeek(xFilial('SE5')+cChave)
			  	    
			  	    While !Eof() .and. SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO+SE5->E5_CLIFOR+SE5->E5_LOJA+SE5->E5_SEQ==cChave
			  	    	IF ALLTRIM(SE5->E5_TIPODOC)=='ES'
			  	    	  lTemEstorno:=.T.
			  	    	Endif
			  	    	SE5->(DbSkip())	
			  	    Enddo
   			  	   	SE5->(DbGoTo(nRecSe5) )
                    
					If !lTemEstorno
				  	    //Estorna a baixa do título
				  	   	DbSelectArea("SE1")
						DbSetOrder(1)
						IF DbSeek(xFilial('SE1')+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO+SE5->E5_CLIFOR+SE5->E5_LOJA)
			
					   	    	nScan := aScan(aSe1Ncc,SE1->( RecNo()))
						   	    if nScan <=0
							   	    AAdd( aSe1Ncc,  SE1->( RecNo())  )
	                            Endif                     
                                    
			        			//Atualiza campo de controle de contabilização para que no estorno seja criado um novo registro no E5. 
					 			//Por padrão este campo fica fazio se o motivo o baixa for não gerar movimento bancário. Porem, para efeito de posição de 
								//títulos a receber se faz necessário conhecer a data da baixa e a data de cancelamento da baixa. 
					  	        IF EMPTY(SE5->E5_LOTE) .AND. SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA)==SE1->(E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+E1_CLIENTE+E1_LOJA)
							  	        Reclock("SE5",.F.)
						  	     		SE5->E5_LOTE:='8850'
						  	         	MSUNLOCK()
					            Endif
						
			   			  	   	FaBaixaCR(	{0,0,0}, {},.F.,.F., .F.,cEstorno,.F.)
						  	    
						  	   	SE5->(MSUNLOCK())
						  	   	SE1->(MSUNLOCK())
					  		   	SA1->(MSUNLOCK())  
					   			
					   	Endif
					Endif	
			  	   	SE5->(DbGoTo(nRecSe5) )
			        SE5->(Dbskip())
			  	EndDo                           
			    //Atualiza a data de baixa mesmo que não tenha título no Financeiro. 
			    //Nestes casos aconteceu apenas a contabilização    
			    DbSelectArea("GTLEGADO")
				DbGoTo((cAliasTRB)->R_E_C_N_O_)   
				
				RecLock("GTLEGADO",.F.) 
					GTLEGADO->GT_DTESTBAIXA:=dDataBase
					GTLEGADO->GT_INPROC    :=.T.
				MsUnlock()
			                             
			    (cAliasTRB)->(DbSkip())
	        
	    	Enddo
			//Executa a compensação das NF com as NCCs Canceladas
			fCmpNcc(aSe1Nf,aSe1Ncc,cPedido )
	  	   	SE5->(MSUNLOCK())
	  	   	SE1->(MSUNLOCK())
	  	   	SA1->(MSUNLOCK())

	        //dDataBase:=dDataAnt
   	
		Enddo
		(cAliasTRB)->(DbCloseArea())
	
	Endif
	
	
Endif	
    	
Return
            
Static Function fCmpNcc(aSe1Nf,aSe1Ncc,cPedido )

DEFAULT	aSe1Nf :={}
DEFAULT	aSe1Ncc:={}
DEFAULT cPedido:=' ' 

// [1]-Contabiliza on-line.
// [2]-Agluitna lançamentos contábeis.
// [3]-Digita lançamento contábeis.
// [4]-Juros para comissão.
// [5]-Desconto para comissão.
// [6]-Calcula comissão para NCC .
aParam := {.F.,.F.,.F.,.F.,.F.,.F.}


	If Len(	aSe1Nf) > 0 .AND. Len(aSe1Ncc)>0 .and. !Empty(cPedido)
      
    
    	U_CSFA530( 3, aSe1NF, /*aBaixa*/, aSe1NCC, /*aLiquidacao*/, aParam, /*bBlock*/, /*aEstorno*/, /*aDadosBaixa*/, /*aNewSE1*/ )
	  
	Endif

Return



/*/   
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³MenuDef   ³ Autor ³ Ana Paula N. Silva     ³ Data ³01/12/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Utilizacao de menu Funcional                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Array com opcoes da rotina.                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Parametros do array a Rotina:                               ³±±
±±³          ³1. Nome a aparecer no cabecalho                             ³±±
±±³          ³2. Nome da Rotina associada                                 ³±±
±±³          ³3. Reservado                                                ³±±
±±³          ³4. Tipo de Transa‡„o a ser efetuada:                        ³±±
±±³          ³		1 - Pesquisa e Posiciona em um Banco de Dados     ³±±
±±³          ³    2 - Simplesmente Mostra os Campos                       ³±±
±±³          ³    3 - Inclui registros no Bancos de Dados                 ³±±
±±³          ³    4 - Altera o registro corrente                          ³±±
±±³          ³    5 - Remove o registro corrente do Banco de Dados        ³±±
±±³          ³5. Nivel de acesso                                          ³±±
±±³          ³6. Habilita Menu Funcional                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function MenuDef()
Local aRotina := {	{ "","" , 0 , 1},;
						{ "","" , 0 , 2 },;
						{ "","" , 0 , 3 },;
						{ "","" , 0 , 4 } }
Return(aRotina)