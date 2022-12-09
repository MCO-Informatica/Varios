#Include "rwmake.ch" 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MTA120G2 ºAutor  ³ ROBSON BUENO       º Data ³  22/06/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Incluindo Processos a Partir da OC   .                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Compras / Fiscal                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MTA120G2()
	Local lOk := .T.
	lok := U_MT120G2(.T.)
	  ESPCOM()
Return lOk

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MT120CC  ºAutor  ³ ROBSON BUENO       º Data ³  22/06/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ INCLUINDO OC CASADA                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Compras / Fiscal                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

USER FUNCTION MT120G2(lOkOP)

	local cProcura
	Local aArea		:= (GetArea())  
	Local cRegistro   
	Local xQtVend:=0
	// desabilitadas as linhas abaixo pois estah provocando erro no PE (11/02/2020)              
	// reposicionando sc7 (nao sei o porque esta se perdendo)
	//dbselectarea("SC7")   
    //SC7->(DbSetOrder(1))
    //SC7->(DbSeek(xFilial("SC7")+cA120Num+GDFieldGet('C7_ITEM')))
			
	PUBLIC cXPI	:=	AllTrim(SC7->C7_XPI)
	// VERIFICA E GRAVA O CRITERIO DE INSPECAO DO FORNECEDOR NA COMPRA
	// GRAVA AMARRACAO OCXPV
	// RETIRADA DA CONDICIONAL AFIM DE TESTAR A INTEGRIDADE DA SZK
	IF SC7->C7_XPI="      "   
	
	ELSE
	  xQtVend:=Posicione("SC6",1,xFilial("SC6")+SC7->C7_XPI+SUBSTR(SC7->C7_XITPI,1,2),"C6_QTDVEN")
	  dbSelectArea("SZK")
	  DbSetOrder(4)
	  IF MsSeek(xFilial("SZK")+"OC"+SC7->C7_NUM+SUBSTR(SC7->C7_ITEM,2,3)+"PV"+SC7->C7_XPI+SC7->C7_XITPI)
	    Reclock("SZK",.F.)
	  ELSE
	    Reclock("SZK",.T.)
	  ENDIF
	  SZK->ZK_FILIAL :=xfilial("SZK") 
	  SZK->ZK_TIPO   :="PV"                        						// TIPO 
	  SZK->ZK_REF    :=SC7->C7_XPI                 						// PEDIDO
	  SZK->ZK_REFITEM:=SC7->C7_XITPI               						// ITEM PEDIDO
	  SZK->ZK_NOME   :=SC7->C7_XNREDCL             						// CLIENTE
	  SZK->ZK_COD    :=SC7->C7_PRODUTO             						// CODIGO PRODUTO
	  SZK->ZK_DESCRI :=SC7->C7_DESCRI            						// DESCRICAO
	  
	  IF xQtVend >SC7->C7_QUANT 
	         SZK->ZK_QTD    :=SC7->C7_QUANT               						// QUANTIDADE VENDA
	  ELSE
	         SZK->ZK_QTD    :=xQtVend               						// QUANTIDADE VENDA
	  ENDIF
	  SZK->ZK_PRAZO  :=SC7->C7_XPZVDA              						// PRAZO VENDA
	  SZK->ZK_TIPO2  :="OC"                       						// TIPO2 
	  SZK->ZK_OC     :=SC7->C7_NUM	            						// NUMERO OS
	  SZK->ZK_ITEM   :=SUBSTR(SC7->C7_ITEM,2,3)   						// ITEM OS
	  SZK->ZK_FORN   :=POSICIONE("SA2",1,XFILIAL("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA,"SA2->A2_NREDUZ")// FORNECEDOR
	  SZK->ZK_QTC    :=xQtVend                  						// QUANTIDADE CASADA
	  SZK->ZK_PRAZOC :=SC7->C7_DATPRF             						// PRAZO ENTRADA
	  IF SC7->C7_QUANT<>SC7->C7_QUJE 	
	       SZK->ZK_QTS    :=xQtVend-If(SC7->C7_QUJE>xQtVend,xQtVend,SC7->C7_QUJE)// QUANTIDADE PENDENTE
           SZK->ZK_DT_BX  :=If(SC7->C7_QUJE>xQtVend,DATE(),CTOD(""))
           SZK->ZK_STATUS :=If(SC7->C7_QUJE>xQtVend,"4","1")					// STATUS DA OS
	  ELSE
	       SZK->ZK_QTS    :=0                      	// QUANTIDADE PENDENTE
	       SZK->ZK_DT_BX  :=DATE()
	       SZK->ZK_STATUS :="4"							// STATUS DA OS
	  ENDIF
	  SZK->ZK_DT_VINC:=SC7->C7_EMISSAO    								// DATA DA VINCULACAO
	  SZK->ZK_CONTROL:="AOC"	
	  MsUnLock()
	  // TRATA CONTROLE DE PROCESSO
	  dbselectarea("PC2")
	  dbSetOrder(4)
	  MsSeek(xfilial("PC2")+SZK->ZK_REF+SUBSTRING(SZK->ZK_REFITEM,1,2)+"000005")
	  if PC2->PC2_QTDORI-PC2->PC2_QTD>0 .and. PC2->PC2_NUM=SZK->ZK_REF .AND. SUBSTRING(SZK->ZK_REFITEM,1,2)=PC2->PC2_ITEM .AND. PC2->PC2_SEQ="000005"
	       cRegistro:=PC2->PC2_CTR
	       // 1 BAIXA SOLICITACAO DE COMPRA E POR EM ORDEM DE COMPRA 
	        U_HCICTPR(SZK->ZK_REF,SUBSTRING(SZK->ZK_REFITEM,1,2),"000005","000007",SZK->ZK_QTC,"Aguardando Amarracao","","","Ok Disposto Comprar",cRegistro) 
	       MsSeek(xfilial("PC2")+SZK->ZK_REF+SUBSTRING(SZK->ZK_REFITEM,1,2)+"000007")
	       cRegistro:=PC2->PC2_CTR
	       // 2 BAIXA ORDEM DE COMPRA E POE EM AGUARDANDO RECEBIMENTO
	        U_HCICTPR(SZK->ZK_REF,SUBSTRING(SZK->ZK_REFITEM,1,2),"000007","000010",SZK->ZK_QTC,"Aguardando Recebimento","","","OC:"+SC7->C7_NUM+" - "+SC7->C7_ITEM+" - "+SA2->A2_NREDUZ,cRegistro,SZK->ZK_PRAZO) 
	  endif  
	  // FIM DE TRATAMENTO 
	  dbSelectArea("SZK")
	  RestArea(aArea)
	ENDIF
Return lOkOP

/*
PROGRAMA: ESPCOM
DESCRICAO: FINALIDADE DE GRAVAR OS CAMPOS DO FOLDER CUSTOMIZADO NO PEDIDO DE COMPRA
*/

STATIC FUNCTION ESPCOM() 

 if FUNNAME()<>"EICPO400"
	DbSelectArea("SC7")
	RecLock("SC7",.F.)
   	SC7->C7_XPI		:= cXPI
	SC7->C7_XNUMPO	:= 	__cNumPO
	SC7->C7_XNUMCOT	:= 	__cNumCOT
	SC7->C7_XTPEMBA	:= 	__cTPEmba 
	SC7->C7_XTPFRET	:= 	__cTPFreteHCI
	if SC7->C7_MOEDA<>1 
	  SC7->C7_FOB_MO:=SC7->C7_MOEDA
	  SC7->C7_FOB_VL:=SC7->C7_PRECO
	  SC7->C7_FOB_FOR:=POSICIONE("SA2",1,XFILIAL("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA,"SA2->A2_NREDUZ")// FORNECEDOR
	endif  
	MsUnlock()     
 endif
 
RETURN
	