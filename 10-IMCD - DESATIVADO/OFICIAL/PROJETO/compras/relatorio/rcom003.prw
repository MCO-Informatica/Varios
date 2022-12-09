#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RCOM003  º Autor ³  Daniel   Gondran  º Data ³  28/09/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatorio de Aprovadores de Pedidos de Compra              º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function RCOM003()
	Local cPerg := 'RCOM03'    
	Local aConf := {}

	//oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "RCOM003" , __cUserID )

	
	Pergunte(cPerg, .T.) 

	MsgRun("Processando Relatório Aprovadores de Pedidos de Compra","",{|| U_ImpR03() })

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ IMPR03   º Autor ³  Daniel   Gondran  º Data ³  28/09/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatorio de Aprovadores de Pedidos de Compra              º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function IMPR03()
	Local cAlias, lQuery, cQuery
	Local aCabec := {}
	Local aDados := {}     
	Local aStat  := {"Nivel bloqueado","Aguardando liberação","Pedido aprovado","","Nivel liberado"}

	DbSelectArea("SCR")
	DbSetOrder(1)

	cAlias:= "XSCR"  

	cQuery := "SELECT "
	cQuery += "  CR_NUM, CR_USER, CR_NIVEL, CR_DATALIB, CR_TOTAL, CR_USERLIB, CR_LIBAPRO, CR_MOEDA, CR_TXMOEDA, CR_STATUS, "
	cQuery += "  C7_FORNECE, C7_LOJA, C7_APROV, C7_USER, C7_DESCRI, C7_EMISSAO, C7_TOTAL, C1_EMISSAO, C1_SOLICIT "
	cQuery += "FROM " + RetSqlName("SCR") + " SCR "     
	cQuery += "JOIN " + RetSqlName("SC7") + " SC7 ON "    
	cQuery += "     SC7.C7_FILIAL = SCR.CR_FILIAL AND "
	cQuery += "     SC7.C7_NUM = SUBSTR(SCR.CR_NUM,1,6)   AND "
	cQuery += "     SC7.D_E_L_E_T_ = ' ' " 
	cQuery += "JOIN " + RetSqlName("SC1") + " SC1 ON "    
	cQuery += "     SC1.C1_FILIAL = SC7.C7_FILIAL AND "
	cQuery += "     SC1.C1_NUM = SC7.C7_NUMSC AND "
	cQuery += "     SC1.C1_ITEM = SC7.C7_ITEMSC AND "
	cQuery += "     SC1.D_E_L_E_T_ = ' ' " 
	cQuery += "WHERE "
	cQuery += "  SCR.CR_FILIAL = '" + xFilial("SCR") + "' "
	cQuery += "  AND SCR.CR_NUM >= '" + MV_PAR03 +"' AND SCR.CR_NUM <= '" + MV_PAR04 + "' "
	cQuery += "  AND SCR.CR_TIPO = 'PC' "
	If MV_PAR05 == 1
		cQuery += "  AND SCR.CR_DATALIB >= '" + DTOS(MV_PAR01) + "' AND SCR.CR_DATALIB <= '" + DTOS(MV_PAR02) + "' "
		cQuery += "  AND SCR.CR_STATUS = '03' "
	Else	
		cQuery += "  AND ((SCR.CR_DATALIB >= '" + DTOS(MV_PAR01) + "' AND SCR.CR_DATALIB <= '" + DTOS(MV_PAR02) + "') OR (SCR.CR_DATALIB = '')) "
		cQuery += "  AND SCR.CR_STATUS <= '03' "
	Endif
	cQuery += "  AND SCR.D_E_L_E_T_ = ' ' "
	cQuery += "ORDER BY SCR.CR_NUM "

	cQuery := ChangeQuery(cQuery)  

	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),cAlias,.T.,.F.)

	dbSelectArea(cAlias)

	aadd(aCabec, "Pedido"  )
	aadd(aCabec, "Solicitante"  )    
	aadd(aCabec, "Produto"  )              
	aadd(aCabec, "Emissão Solicitacao"  )              
	aadd(aCabec, "Emissao Pedido"  )              
	aadd(aCabec, "Comprador"  )                                                                                              µ
	aadd(aCabec, "Fornecedor"  )
	aadd(aCabec, "Grupo de Aprovacao"  )
	aadd(aCabec, "Nivel" )
	aadd(aCabec, "Data Liberacao" )
	aadd(aCabec, "Aprovador" ) 
	aadd(aCabec, "Valor" )  
	aadd(aCabec, "Moeda" )               
	aadd(aCabec, "Status" )


	dbGoTop()
	While !EOF()          
		aadd(aDados,;
		{AllTrim((cAlias)->CR_NUM),;                                                                                                    	// Num PC
		((cAlias)->C1_SOLICIT),;                                                                                                       	// Solicitante
		AllTrim((cAlias)->C7_DESCRI),;                                                                                                 	// Produto
		Substr((cAlias)->C1_EMISSAO,7,2) + "/" + Substr((cAlias)->C1_EMISSAO,5,2) + "/" + Substr((cAlias)->C1_EMISSAO,1,4),;        	// Emissao SC
		Substr((cAlias)->C7_EMISSAO,7,2) + "/" + Substr((cAlias)->C7_EMISSAO,5,2) + "/" + Substr((cAlias)->C7_EMISSAO,1,4),;        	// Emissao PC
		UsrRetName((cAlias)->C7_USER),;                                                                                                	// Comprador
		Posicione("SA2",1,xFilial("SA2") + (cAlias)->C7_FORNECE + (cAlias)->C7_LOJA,"A2_NREDUZ"),;                                   	// Fornecedor
		Posicione("SAL",1,xFilial("SAL") + (cAlias)->C7_APROV,"AL_DESC"),;                                                           		// Grupo Aprov
		(cAlias)->CR_NIVEL,;                                                                                                          		// Nivel
		Substr((cAlias)->CR_DATALIB,7,2) + "/" + Substr((cAlias)->CR_DATALIB,5,2) + "/" + Substr((cAlias)->CR_DATALIB,1,4),;       		// Data Liber
		UsrRetName((cAlias)->CR_USERLIB),;                                                                                              	// Aprovador
		Transform(Int((cAlias)->C7_TOTAL), "@E 9999999999"),;                                                                          	// Valor
		Iif((cAlias)->CR_MOEDA == 1,"Real","Dolar"),;                                                                                  	// Moeda
		aStat[Val((cAlias)->CR_STATUS)] } )                                                                                            	// Status
		dbSkip()   
	EndDo   

	//		 Posicione("SAK",1,xFilial("SAK") + (cAlias)->CR_LIBAPRO,"AK_NOME"),;
	//		 UsrRetName((cAlias)->CR_USER),;


	DbCloseArea(cAlias)                                     


	If len(aDados) == 0            
		MsgInfo("Não existem dados a serem impressos, de acordo com os parâmetros informados!","Atenção")
	Else  
		DlgToExcel({ {"ARRAY", "Relatorio de Aprovadores de Pedidos de Compra", aCabec, aDados} }) 
	Endif

Return()