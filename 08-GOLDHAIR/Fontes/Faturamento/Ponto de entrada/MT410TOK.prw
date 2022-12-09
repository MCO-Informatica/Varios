#INCLUDE "PROTHEUS.CH"   
#INCLUDE "TOPCONN.CH"

/****************************************************************************
* Ponto de entrada para validação do pedido de venda no momento da gravação *
****************************************************************************/

/*****************************************************************************/
User Function MT410TOK
/*****************************************************************************/

Local cProd      := ""
Local cBoni      := ""
Local nTotPed    := 0 
Local nQtdIte    := 0
Local lRet       := .T.
Private cCodUser := Alltrim(UsrRetName(__CUSERID))           

/*** Verificar se as parcelas foram digitadas quando a condição de pagamento for manual ***/
IF M->C5_CONDPAG == "999" .and. M->C5_PARC1 <= 0
   MsgAlert("DIGITE O VALOR DA(S) PARCELA(S)!","Cond Pagto Manual")
   lRet := .F.
ENDIF          

/***** Acumular qtde de itens da NF *****/
nQtdIte := 0   
For nh:=1 to len(acols)
	nQtdIte += acols[nh][GDFIELDPOS("C6_QTDVEN")]
Next nh
M->C5_X_TOTQT := nQtdIte


/*** Rotina para verificar regras de bonificação dos pedidos de venda que podem gerar bonificação, com exceção dos usuários João Martins e Fabio ***/
/*
If (cCodUser != "Joao") .AND. (cCodUser != "Fabio")
   If M->C5_X_BON1 > 0 .OR. M->C5_X_BON2 > 0 
      DbselectArea("SB1")
	  SB1->(DbSetOrder(1)) // Filial + Produto
	  nTotped := 0
	  For nh:=1 to len(acols)
	     cProd := aCols[n][Ascan(aHeader,{|x| Trim(x[2]) == "C6_PRODUTO"})]
		 If SB1->(DbSeek(xFilial("SB1") + cProd))
	   		cBoni :=POSICIONE("SBM",1,xFilial("SBM")+SB1->B1_GRUPO,"BM_X_BONI")
	   		if cBoni == "1"
	      		nTotped += acols[nh][GDFIELDPOS("C6_VALOR")]
	   		Endif   
		 Endif    
	  Next nh  
	  If nTotped < GetMV("MV_X_PEDMI") .and. M->C5_X_BON1 > 0
   		Alert("Pedido com valor menor do que o permitido para bonificação, percentuais serão zerados!")
   		M->C5_X_BON1 := 0
   	  Endif
      If M->C5_X_PEDBO == "1"
         M->C5_X_TBO1 := 0
         M->C5_X_TBO2 := 0
      Else   
         M->C5_X_TBO1 := nTotped * (M->C5_X_BON1 / 100)
         M->C5_X_TBO2 := nTotped * (M->C5_X_BON2 / 100)
      End   
      If M->C5_X_BON2 > 0 .AND. Empty(M->C5_X_REPRE)
	     Alert("Campo Representante precisa ser preenchido!")
         lRet := .F.
      Endif
   Endif
Endif */
/*** cCoduser ***/  

/*** Validações de limite para pedidos que são de Bonificação, exceto para usuários João e Sue Ellen ***/
/*
If (cCodUser != "Joao") .AND. (cCodUser != "Fabio")
If M->C5_X_PEDBO == "1"
   If Empty(M->C5_X_PORIG)
      Alert("Campo Pedido Original precisa ser preenchido!")
      lRet := .F.
   Endif        
   nTotped := 0 
   For nh:=1 to len(acols)
       nTotped += acols[nh][GDFIELDPOS("C6_VALOR")]
	Next nh  

   If M->C5_X_TPBON == "C"
      If nTotped > M->C5_X_TBO1 
         Alert("Pedido com valor de "+STR(nTotped)+", maior do que o permitido para bonificação! "+STR(M->C5_X_TBO1))
         lRet := .F.
      Endif
   Else
      If M->C5_X_TPBON == "R"
         If nTotped > M->C5_X_TBO2 
            Alert("Pedido com valor de "+STR(nTotped)+ ", maior do que o permitido para bonificação! "+STR(M->C5_X_TBO2))
            lRet := .F.
         Endif
      Endif
   Endif
   M->C5_X_BON1 := 0
   M->c5_X_BON2 := 0
Endif
Endif /*** cCoduser ***/   
*/

//Anderson Goncalves
// Verifica se existe o numero de pedido de vendas 
/*
If INCLUI .and. M->C5_X_FPAGT == "B"
	cQuery := "SELECT COUNT(*) TOTAL FROM "+RetSqlName("SE1")+" (NOLOCK) "
	cQuery += "WHERE E1_FILIAL = '" + xFilial("SE1")+"' "
	cQuery += "AND E1_NUM = '" + M->C5_NUM + "' "
	cQuery += "AND E1_PREFIXO IN ('A  ','UNI') "
	cQuery += "AND D_E_L_E_T_ = ' ' "
	TcQuery cQuery New Alias "SE1NEW"
	
	dbSelectArea("SE1NEW")
	SE1NEW->(dbGoTop())
	If SE1NEW->TOTAL > 0
		Alert("Ja existe titulo no financeiro com este numero de pedido, ajuste o numero do pedido de vendas")
		lRet := .F.
	EndIf  
	
	SE1NEW->(dbCloseArea())
EndIf
*/
		

Return lRet