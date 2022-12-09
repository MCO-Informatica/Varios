#INCLUDE "PROTHEUS.CH"
#INCLUDE "JPEG.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MA410MNU  ºAutor  ³ROBSON BUENO        º Data ³  20/10/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de Entrada para Criar opcoes na Mbrowse               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MA410MNU()             
   Aadd(aRotina,{"Tr. Filial","U_HC410MNU()", 0 , 3, 0 ,NIL})
   Aadd(aRotina,{"Dividir PV","U_HC410DVP()", 0 , 4, 0 ,NIL})
   
Return()

                
USER FUNCTION HC410MNU()
  Local lContinua:=.T.
  Local cMotivo:=""
  Private cFilAtual := AllTrim(SM0->M0_CODFIL)
  Private cFilAnt	 := SC5->C5_FILIAL
  Private cNumero   := SC5->C5_NUM
  
  DbSelectArea("SC6")
  dbSetOrder(1)
  IF MsSeek(xfilial("SC6")+cNumero)
  		While ( !Eof() .And. SC6->C6_FILIAL == xFilial("SC6") .And. SC6->C6_NUM == SC5->C5_NUM .And. lContinua )
    	    // VERIFICA SE TEM ITEM LIBERADO
	    	If ( SC6->C6_QTDEMP > 0 )
		    	lLiber := .T.
		    	lContinua:=.F.
		    	cMotivo:="Tem pelo menos 1 item ja liberado, entre alterando o pedido para depois exclui-lo"
		    EndIf
		    // VERIFICA SE TEM ITEM FATURADO
	   		If ( SC6->C6_QTDENT > 0 ) .Or. ( SC5->C5_TIPO $ "CIP" .And. !Empty(SC6->C6_NOTA) )
		    	lFaturado  :=  .T.
		    	lContinua:=.F.
		    	cMotivo:="Tem pelo menos 1 item ja faturado. Não sera possivel transferir"
	     	EndIf

		dbSelectArea("SC6")
		dbSkip()
	EndDo
  ELSE
    lContinua:=.F.
    cMotivo:="Pedido Nao encontrado"
  ENDIF  
  if lContinua=.F.
    MsgInfo("Nao e possivel realizar operacao... Motivo: "+cMotivo, "Acesso Indevido")  
  else  
    If MsgYesNo("Deseja Realmente Transferir Pedido da Filial:-->"+ cFilant + "   Para a Filial:-->" + cFilAtual)
  	    RecLock("SC5",.F.)
		SC5->C5_FILIAL := cFilAtual
		MsUnLock()
        DbSelectArea("SC6")
        dbSetOrder(1)
        IF MsSeek(xfilial("SC6")+cNumero)
          WHILE (SC6->C6_NUM=cNumero)
            RecLock("SC6",.F.)
	      	SC6->C6_FILIAL := cFilAtual
		    MsUnLock()
            dbSelectArea("SB2")
            dbSetOrder(1)
            If !MsSeek(cFilAtual+SC6->C6_PRODUTO+SC6->C6_LOCAL)
              CriaSB2(SC6->C6_PRODUTO,SC6->C6_LOCAL,cFilAtual)
	        EndIf
            DbSelectArea("SC6")
            dbSetOrder(1)
            DBSeek(xfilial("SC6")+cNumero)
          ENDDO
        ENDIF
    EndIf
  endif
RETURN () 
// DESMEMBRAMENTO DE PEDIDOS DE VENDA 

USER FUNCTION HC410DVP()
  Local lContinua:=.T.
  Local cMotivo:=""
  Private cNumero   := SC5->C5_NUM
  
  DbSelectArea("SC6")
  dbSetOrder(1)
  IF MsSeek(xfilial("SC6")+cNumero)
  		While ( !Eof() .And. SC6->C6_FILIAL == xFilial("SC6") .And. SC6->C6_NUM == SC5->C5_NUM .And. lContinua )
    	    // VERIFICA SE TEM ITEM LIBERADO
	    	If ( SC6->C6_QTDEMP > 0 )
		    	lLiber := .T.
		    	lContinua:=.F.
		    	cMotivo:="Tem pelo menos 1 item ja liberado, entre alterando o pedido para depois exclui-lo"
		    EndIf
		    // VERIFICA SE TEM ITEM FATURADO
	   		If ( SC6->C6_QTDENT > 0 ) .Or. ( SC5->C5_TIPO $ "CIP" .And. !Empty(SC6->C6_NOTA) )
		    	lFaturado  :=  .T.
		    	lContinua:=.F.
		    	cMotivo:="Tem pelo menos 1 item ja faturado. Não sera possivel transferir"
	     	EndIf
		dbSelectArea("SC6")
		dbSkip()
	EndDo
  ELSE
    lContinua:=.F.
    cMotivo:="Pedido Nao encontrado"
  ENDIF  
  if lContinua=.F.
    MsgInfo("Nao e possivel realizar operacao... Motivo: "+cMotivo, "Acesso Indevido")  
  else  
    If MsgYesNo("Deseja TRANSFERIR DADOS DESTE PEDIDO PARA PEDIDOS FILHOS INFORMADOS NO CAMPO C6_NUMFI ?")
  	    RecLock("SC5",.F.)
		SC5->C5_FILIAL := cFilAtual
		MsUnLock()
        DbSelectArea("SC6")
        dbSetOrder(1)
        IF MsSeek(xfilial("SC6")+cNumero)
          WHILE (SC6->C6_NUM=cNumero)
            RecLock("SC6",.F.)
	        SC6->C6_NUMMAE:=SC6->C6_NUM
	      	SC6->C6_NUM   :=SC6->C6_NUMFI
	      	SC6->C6_NUMFI="      "
	      	MsUnLock()
            // VERIFICA SE EXISTE CABECALHO PARA A TABELA SC5 PARA ESTE NOVO PEDIDO
            DbSelectArea("SC5")
            dbSetOrder(1)
            DBSeek(xfilial("SC5")+cNumero)
            
            DBSKIP()
          ENDDO
        ENDIF
    EndIf
  endif
RETURN () 




// VALIDACAO DE CONTATOS
USER FUNCTION HCVLCON()
Local lRet:=.T.
  IF M->C5_TIPO="D" .OR. M->C5_TIPO="F"
    lRet:=IF(POSICIONE("AC8",1,"  "+TRIM(M->C5_CONTATO)+"SA2  "+M->C5_CLIENTE+M->C5_LOJACLI,"AC8_CODCON")=TRIM(M->C5_CONTATO),.T.,.F.)    
  ELSE
    lRet:=IF(POSICIONE("AC8",1,"  "+TRIM(M->C5_CONTATO)+"SA1  "+M->C5_CLIENTE+M->C5_LOJACLI,"AC8_CODCON")=TRIM(M->C5_CONTATO),.T.,.F.)    
  ENDIF
RETURN (lRet)
// PREENCHIMENTO DA CONSULTA F3 DOS CONTATOS DA VENDA DE ACORDO COM OS CRITERIOS (CLIENTE / FORNECEDOR)



