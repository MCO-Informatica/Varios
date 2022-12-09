#include "TOPCONN.CH"
#include "Protheus.Ch"  
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  XVLDCPROD  ºAutor  ³Romay Oliveira      º Data ³  13/01/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Valida campos produto para nao permitir informar produtos  º±±
±±º          ³ com b1_xproant = 1		                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ RENOVA                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function XVLDCPROD()
Local lRet 			:= .F.  
Local cFunName		:= AllTrim( FunName() )
Local cProduto		:= ""
Local lEntra		:= .F.
   
   //Solicitacao de Compras
   If cFunName 		== 'MATA110'         
   
   		lEntra		:= .T.
		cProduto 	:= M->C1_PRODUTO
   
   //Pedido de Compras		
   ElseIf cFunName 	== 'MATA121' 	
   
   		lEntra		:= .T.	
   		cProduto 	:= M->C7_PRODUTO 
   
   //Pedido de Vendas		
   ElseIf cFunName 	== 'MATA410'		
   
   		lEntra		:= .T.	
   		cProduto 	:= M->C6_PRODUTO
      
   //Contrato de Planilha
   ElseIf cFunName 	== 'CNTA100'		
   
   		lEntra		:= .T.	
   		cProduto 	:= M->CNB_PRODUT
 /*  
  Não pode ter essa validação na medição, pois os contratos antigos que foram cadastrados com os produos antigos, tem que ser encerrados.
 		                     
   //Medição de Contrato
   ElseIf cFunName 	== 'CNTA120'		
   
   		lEntra		:= .T.	
   		cProduto 	:= M->CNB_PRODUT
 */  		
   //Planilha de Contratos
   ElseIf cFunName 	== 'CNTA200'		
   
   		lEntra		:= .T.	
   		cProduto 	:= M->CNB_PRODUT
   		                     
   //Pre Nota de Entrada
   ElseIf cFunName 	== 'MATA140'
   
   		lEntra		:= .T.	
   		cProduto 	:= M->D1_COD
  
   //Nota de Entrada
   ElseIf cFunName 	== 'MATA103'
   
   		lEntra		:= .T.	
   		cProduto 	:= M->D1_COD
   
   EndIf
   
	If lEntra
	
			If Select("Qry2") > 0//Verifica se ja existe alias criado
				Qry2->( dbCloseArea() )
			EndIf        
			
			cQuery := "	SELECT  "
			cQuery += "	B1_XPROANT "
			cQuery += "	FROM "
			cQuery += RetSqlName("SB1") + " SB1 "
			cQuery += "	WHERE "
			cQuery += "		B1_FILIAL 		= '" + xFilial('SB1') + "' "
			cQuery += " 	AND SB1.D_E_L_E_T_ <> '*' "
			cQuery += "		AND B1_COD = '"+ cProduto +"'    " 
			cQuery += "		AND B1_XPROANT = '1'    " 
			                        		
			DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQuery)),"Qry2",.T.,.T.) 
			
			If Qry2->( !EOF() )
				                			
		   		Alert('Produto antigo não pode ser utilizado. Favor selecionar um produto novo! Dúvidas, acionar a área de compras!!!')
		 	
		 	Else
		 	
				lRet := .T.        
	
			EndIf
	Else
		lRet := .T.
	EndIf

Return(lRet)