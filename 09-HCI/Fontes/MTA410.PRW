#INCLUDE "Protheus.ch"
#INCLUDE "TopConn.ch" 
#INCLUDE "Rwmake.CH" 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º Programa    ³ MTA410   ³ Ponto de entrada para tratar se tudo esta ok                 º±±
±±º             ³          ³ caso nao exista.                                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Solicitante ³ 20.03.07 ³ Robson                                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Autor       ³ 20.03.07 ³ Osmil Squarcine                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Produção    ³ ??.??.?? ³ Ignorado                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Parâmetros  ³ Nil                                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Retorno     ³ Nil                                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Observações ³ 1. Validar se o almoxarifado existe, caso nao exista ele cria o sb2     º±±
±±º             ³                                                                         º±±
±±º             ³                                                                         º±±
±±º             ³                                                                         º±±
±±º             ³                                                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Alterações  ³ ??.??.?? - Nome - Descrição                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MTA410()
Local aSaveArea := GetArea()
Local aHeadC6:=aclone(aHeader)
Local nUsado := Len(aHeadC6)
Local lRetorno := .T.
Local cLoja:=""
Local lConPadOk := .F.
Local nEndereco		:= 0
Local nTotAnt:=0
Local X:=0
Local nTotAtu:=0
Local nSaldo:=0 
Local lMotivo1:=.f.
Local lmotivo2:=.f.
Local lmotivo3:=.f.
Local lmotivo4:=.f.
Local lmotivo5:=.t.
Local lGeraRC:=.f.
LOCAL lProcesso:=.f.
Local cTes
lOCAL nRegistro:=0
Local nCasado:=0
Local cPedHCI
Local cItHCI
Local cControle
Local cProcItem
Local cItProc
Local nColun
Local cCfop 
Local cEstado   := SuperGetMv("MV_ESTADO")
// rotina de avaliacao de credito do cliente
Local lPode:=GETMV("MV_BLOVEND")
Local lBarrou:=.F.
nColun:=1
//EXTRAINDO DO SISTEMA O VALOR ATUAL DO PROCESSO 
For nCntFor := 1 To nUsado
	IF  AllTrim(aHeadC6[nCntFor,2]) == "C6_VALOR"
		  nColun:=nCntFor
	ENDIF
Next nCntFor
 
nCntFor:=1
FOR X:=1 TO LEN(ACOLS)
  if Posicione("SF4",1,xFilial("SF4")+ACOLS[X,4],"F4_DUPLIC")="S"
    nTotAtu:=nTotAtu+acols[x,nColun]
  ENDIF
NEXT
M->C5_TOTAL:=nTotAtu
If cPaisLoc == "BRA"
//EXTRAINDO DO SISTEMA O VALOR ANTERIOR DO PROCESSO
DbSelectArea("SC6")
dbSetOrder(1)
IF MsSeek(xfilial("SC6")+M->C5_NUM)
WHILE (SC6->C6_NUM=M->C5_NUM)
  if Posicione("SF4",1,xFilial("SF4")+SC6->C6_TES,"F4_DUPLIC")="S"
    nTotAnt:=nTotAnt+SC6->C6_VALOR
  ENDIF
  DBSKIP()
ENDDO
endif
DbSelectArea("SC6")
dbSetOrder(1)
MsSeek(xfilial("SC6")+M->C5_NUM)
if nTotAtu+nTotAnt>0 
  DBSELECTAREA("SA1")
  DBSETORDER(1)
  IF MsSeek(xfilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI)
    //DESCOBRINDO O LIMITE UTILIZADO
    nSaldo:=SA1->A1_LC
    nSaldo:=nSaldo-SA1->A1_SALDUP
    nSaldo:=nSaldo-SA1->A1_SALPEDL
    nSaldo:=nSaldo-SA1->A1_SALPED
    nSaldo:=nSaldo+nTotant
    if nSaldo<nTotatu 
      Aviso("Restricao por Limite de Credito","Cliente com limite de credito inferior ao valor do pedido: Limite R$"+TRANSFORM(nSaldo,"@E 999999999.99") ,{"Ok"},,"Limite de Credito:")
      lBarrou:=.T.
      lMotivo1:=.t.
    endif
    if SA1->A1_VENCLC<DATE()
      Aviso("Restricao por Credito Vencido","Cliente com Validade de Credito Vencida",{"Ok"},,"Validade do Cred. Vencida:")
      lBarrou:=.T.
      lMotivo2:=.t.
    endif
    if M->C5_CONDPAG="ANT" 
      Aviso("Restricao por Pag. Antecipado","Pedido emitido para pagamento antecipado",{"Ok"},,"Autorizacao Individual:")
      lBarrou:=.T.
      lMotivo4:=.t. 
    ENDIF   
  endif  
  IF lbarrou=.T. .AND. lPode=.T.
     Aviso("Restricao de Credito","O pedido <<<NAO SERA SALVO>>>. Solicite a liberacao de credito para posteriormente salvar o pedido",{"Ok"},,"Restricao de Credito:")
     lRetorno:=.f.
  endif 
  IF LBARROU=.T.
    //if MsgYesNo("Deseja Gerar Solicitacao de Liberacao de Credito?","Automacao de Processo")
       U_HCTE001(TRANSFORM(nTOTATU,"@E 999999999.99"),lMotivo1,lMotivo2,lMotivo3,lMotivo4)    
    //ENDIF
  ENDIF
endif
// rotina de atualizacao do registro de entrada
DbSelectArea("SZQ")
dbSetOrder(1)
IF MsSeek(xfilial("SZQ")+M->C5_NUM)
  RecLock("SZQ",.F.)
  SZQ->ZQ_CLIENTE	:=M->C5_CLIENTE
  SZQ->ZQ_LOJA	:=M->C5_LOJACLI
  SZQ->ZQ_NOME	:=SA1->A1_NREDUZ
  SZQ->ZQ_CNPJ	:=SA1->A1_CGC
  SZQ->ZQ_REFCLI	:=M->C5_NUMCOT
  SZQ->ZQ_NEGOCIA	:=POSICIONE("SA3",1,XFILIAL("SA3")+M->C5_AGINT,"A3_NREDUZ") 
  SZQ->ZQ_RESULT	:="1"
  IF nTotAtu>0
    SZQ->ZQ_VLALFR:=nTotAtu
  else  
    SZQ->ZQ_VLALFR:=nTotAnt
  endif
  SZQ->ZQ_D_DIGIT :=M->C5_EMISSAO
  SZQ->ZQ_STATUS	:="05"
  SZQ->ZQ_TIPO	:="1"
  MSUNLOCK()
ENDIF
/*
DbSelectArea("SC6")
dbSetOrder(1)
IF MsSeek(xfilial("SC6")+M->C5_NUM)
WHILE (SC6->C6_NUM=M->C5_NUM)
  if SC6->C6_QTDLOC2>0 
    lGeraRc:=.t.
  ENDIF
  DBSKIP()
ENDDO
ENDIF
if lGeraRc=.t.
  If MsgYesNo("Prezado Usuario, Seu pedido tem quantidades para compra imediata. Deseja enviar Solicitacao?","Automacao de Processo") 
    	U_WFHC002()
  endif
endif
*/	
// >>>>>>CONTROLE DE PROCESSO DE ENTREGA<<<<<<<<<

// 1 passo verifica se o cliente esta cadastrado para a funcao
DbSelectArea("SA1")
dbSetOrder(1)
IF MsSeek(xfilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI)                                                              
  IF SA1->A1_PORTAL="S" 
    lProcesso:=.T.
  ENDIF
ENDIF    
FOR X:=1 TO LEN(ACOLS)
  if Posicione("SF4",1,xFilial("SF4")+ACOLS[X,4],"F4_MSBLQL")="1"
       lRetorno:=.F.
       lMotivo5:=.f.
  ENDIF
NEXT 
FOR AE:=1 TO LEN(ACOLS)
   IncProc("Atualizando CFOP's dos Pedidos...")
     A410MultT("C6_TES",ACols[AE,aScan(aHeader,{|x| AllTrim(x[2])=="C6_TES"})])  
NEXT  
FOR AE:=1 TO LEN(ACOLS)
   cCFOP:=Posicione("SF4",1,xFilial("SF4")+ACols[AE,aScan(aHeader,{|x| AllTrim(x[2])=="C6_TES"})],"F4_CF")
   IF cEstado<>M->C5_ESTENT
       if M->C5_ESTENT="EX" 
         cCfop:="7"+SUBSTRING(cCfop,2,3)
       else  
         cCfop:="6"+SUBSTRING(cCfop,2,3)
       endif
   endif    
   ACols[AE][aScan(aHeader,{|x| AllTrim(x[2])=="C6_CF"})] := cCFOP                                                                                                                     
   //A410ZERA()
   ACols[AE][aScan(aHeader,{|x| AllTrim(x[2])=="C6_CLASFIS"})] :=IIF(M->C5_TIPOPV=" ","0"+SF4->F4_SITTRIB,M->C5_TIPOPV+SF4->F4_SITTRIB)  
NEXT
IF lMotivo5=.F.
  Aviso("Bloqueio de Operação","O pedido <<<NAO SERA SALVO>>>. Existe algum item com tes Bloqueada",{"Ok"},,"Bloqueio de operacao")
ENDIF
IF lProcesso=.T. 
  // 2   Passo verifica se ja existe processo em andamento para o pedido
  // 2.1 Verifica se existe controle de processo para o pedido
  DbSelectArea("PC2")
  dbSetOrder(1)
  IF MsSeek(xfilial("PC2")+M->C5_NUM+acols[1,1])         
    // 2.2 Se encontrado compara valores importantes do processo que pode impactar no controle e impede salvar sem eliminar processos abertos.
    FOR x:=1 TO LEN(ACOLS)
      DbSelectArea("SC6")
      dbSetOrder(1)
      IF MsSeek(xfilial("SC6")+M->C5_NUM+acols[x,1])
        For nCntFor := 1 To nUsado
			Do Case
				Case ( AllTrim(aHeadC6[nCntFor,2]) == "C6_PRODUTO" )
				  IF aCols[x,nCntFor] <> SC6->C6_PRODUTO
				    lRetorno:=.F.
				  ENDIF
				Case ( AllTrim(aHeadC6[nCntFor,2]) == "C6_DESCRI" )
				  IF aCols[x,nCntFor] <> SC6->C6_DESCRI
				    lRetorno:=.F.
				  ENDIF
				Case ( AllTrim(aHeadC6[nCntFor,2]) == "C6_QTDVEN" )
				  IF aCols[x,nCntFor] <> SC6->C6_QTDVEN
				    lRetorno:=.F.
				  ENDIF
				Case ( AllTrim(aHeadC6[nCntFor,2]) == "C6_ENTREG" )
                  IF aCols[x,nCntFor] <> SC6->C6_ENTREG
				    lRetorno:=.F.
				  ENDIF
			EndCase
  		Next nCntFor                                               
      endif
      // VERIFICANDO ITENS DO CABECALHO
      IF M->C5_CLIENTE<>SC6->C6_CLI
        lRetorno:=.F.
	  ENDIF  
	  IF M->C5_LOJACLI<>SC6->C6_LOJA
	    lRetorno:=.F. 
	  endif  
    next
    
    if lRetorno=.F.
      Aviso("Restricao de Processo","O pedido <<<NAO SERA SALVO>>>. Campos Importantes na rotina de processo foram alterados, exclua o processo para depois alterar o pedido",{"Ok"},,"Bloqueio de processo")
    else
      If MsgYesNo("Este cliente tem Controle de Processo, Deseja ALTERAR Pedido no Controle?"  ) 
      	// ve se pode excluir e depois incluir novamente
      	FOR x:=1 TO LEN(ACOLS)
      	  For nCntFor := 1 To nUsado
		   	 Do Case
				Case ( AllTrim(aHeadC6[nCntFor,2]) == "C6_ITEM" )
				  cItProc:=aCols[x,nCntFor]             
      	        Case ( AllTrim(aHeadC6[nCntFor,2]) == "C6_QTDLOC2" ) 
				  nCasado:=aCols[x,nCntFor]   
				Case ( AllTrim(aHeadC6[nCntFor,2]) == "C6_QTDLOC3" )
		          nCasado:=nCasado+aCols[x,nCntFor]   
      	        endcase
      	  next nCntFor
      	  if nCasado=0
      	    cProcItem:="000002"
      	  ELSE 
      	    cProcItem:="000005"
      	  endif    
      	  dbSelectArea("PC2")
          dbSetOrder(4)
          dbSeek(xFilial("PC2")+M->C5_NUM+cItProc+cProcItem)
      	  if (!EOF() .AND. PC2->PC2_NUM=M->C5_NUM .AND. PC2->PC2_ITEM=cItProc .AND. PC2->PC2_SEQ=cProcItem .and. lretorno=.T.)
      	    //U_HCIPDPR(M->C5_NUM,cItProc,PC2->PC2_CTR)  // PEDIDO - ITEM - CONTROLE
      	    IF PC2->PC2_QTD>0 
      	      LRETORNO:=.F.
      	    ELSE
      	      lretorno:=.T.
      	    ENDIF
      	  ENDIF
      	Next
      	if lretorno==.T.      	
      	  // LIMPANDO PROCESSOS EXISTENTES
          dbSelectArea("PC2")
          dbSetOrder(1)
          dbSeek(xFilial("PC2")+M->C5_NUM)
          While !Eof() .And. PC2->PC2_FILIAL == xFilial("PC2") .And. PC2->PC2_Num == M->C5_NUM .and. lRetorno==.T.
	        RecLock("PC2",.F.)
	        dbDelete()
	        MsUnLock()
            dbSkip()
          ENDDO
        
          // INCLUINDO PROCESSO 000001 (PEDIDO EMITIDO)
          dbselectarea("PC1")
          dbSetOrder(1)
          MsSeek(xfilial("PC1")+"PV0001"+"000001")
          FOR x:=1 TO LEN(ACOLS)
        	DbSelectArea("PC2")
            RecLock("PC2",.T.)
          	// CAMPOS PADROES DO PEDIDO
          	PC2->PC2_FILIAL:=xfilial("PC2")
          	PC2->PC2_NUM	 :=M->C5_NUM
      	  	PC2->PC2_CLI	 :=M->C5_CLIENTE
      		PC2->PC2_LOJA	 :=M->C5_LOJACLI
      		PC2->PC2_PEDCLI:=M->C5_COTCLI
      		PC2->PC2_ROTINA:="PV0001"
      		PC2->PC2_SEQ   :="000001"
      		PC2->PC2_SEQP1 :=PC1->PC1_PRACA1 
      		PC2->PC2_SEQP2 :=PC1->PC1_PRACA2
      		PC2->PC2_SEQP3 :=PC1->PC1_PRACA3
      		PC2->PC2_SEQP4 :=PC1->PC1_PRACA4
      		PC2->PC2_SEQP5 :=PC1->PC1_PRACA5
      		PC2->PC2_RESP  :=PC1->PC1_RESPPD
      		PC2->PC2_EMAIL :=PC1->PC1_EMAIL
      		PC2->PC2_PORTAL:=PC1->PC1_PORTAL
      		PC2->PC2_DREG  :=DATE()
      		PC2->PC2_DPREV:=DATE()+PC1->PC1_TPMED1
      		PC2->PC2_DTINI :=DATE()
      		PC2->PC2_DTFIM :=DATE()
      		PC2->PC2_RACAOE :="Processo.Autom." 
      		PC2->PC2_NOMERED:=M->C5_XNREDUZ
      		PC2->PC2_CTR	  :=RTRIM(TRANSFORM(PC2->(recno()),"@E 999999"))
      		PC2->PC2_INF:="Analise de Contrato OK"
      		// DETALHES DO ITEM
      		For nCntFor := 1 To nUsado
		   	 Do Case
				Case ( AllTrim(aHeadC6[nCntFor,2]) == "C6_ITEM" )
				  PC2->PC2_ITEM:=aCols[x,nCntFor]             
				Case ( AllTrim(aHeadC6[nCntFor,2]) == "C6_PRODUTO" )
				  PC2->PC2_COD:=aCols[x,nCntFor]
				Case ( AllTrim(aHeadC6[nCntFor,2]) == "C6_DESCRI" )
				  PC2->PC2_DESCRI:=aCols[x,nCntFor]
				Case ( AllTrim(aHeadC6[nCntFor,2]) == "C6_QTDVEN" )
				  PC2->PC2_QTDORI:=aCols[x,nCntFor]
				  PC2->PC2_QTD	 :=aCols[x,nCntFor]
				Case ( AllTrim(aHeadC6[nCntFor,2]) == "C6_NUMREF" )
				  PC2->PC2_CODCLI:=aCols[x,nCntFor]
				Case ( AllTrim(aHeadC6[nCntFor,2]) == "C6_ITEMCLI" )
				  PC2->PC2_ITCLI:=aCols[x,nCntFor]
				Case ( AllTrim(aHeadC6[nCntFor,2]) == "C6_ENTREG" )
				  PC2->PC2_PRAZO:=aCols[x,nCntFor]  
			 EndCase
  	  		Next nCntFor                                                     
      		MSUNLOCK()
    	  next
    	  // INCLUINDO PROCESSO 000002 (PEDIDO EM ANALISE DE LOTES)
    	  dbselectarea("PC1")
    	  dbSetOrder(1)
    	  MsSeek(xfilial("PC1")+"PV0001"+"000002")
   		  FOR x:=1 TO LEN(ACOLS)
     		dbselectarea("PC2")
      		dbSetOrder(4)
      		if MsSeek(xfilial("PC2")+M->C5_NUM+aCols[x,1]+"000001")
        		cControle:=PC2->PC2_CTR
     		endif
      		DbSelectArea("PC2")
      		nRegistro:=PC2->(recno())
      		RecLock("PC2",.T.)
      		// CAMPOS PADROES DO PEDIDO
      		PC2->PC2_FILIAL:=xfilial("PC2")
      		PC2->PC2_NUM	 :=M->C5_NUM
      		cPedHCI      	 :=M->C5_NUM
      		PC2->PC2_CLI	 :=M->C5_CLIENTE
      		PC2->PC2_LOJA	 :=M->C5_LOJACLI
      		PC2->PC2_PEDCLI:=M->C5_COTCLI
      		PC2->PC2_ROTINA:="PV0001"
      		PC2->PC2_SEQ   :="000002"
      		PC2->PC2_SEQA	 :="000001"
      		PC2->PC2_SEQP1 :=PC1->PC1_PRACA1 
      		PC2->PC2_SEQP2 :=PC1->PC1_PRACA2
      		PC2->PC2_SEQP3 :=PC1->PC1_PRACA3
      		PC2->PC2_SEQP4 :=PC1->PC1_PRACA4
      		PC2->PC2_SEQP5 :=PC1->PC1_PRACA5
      		PC2->PC2_RESP  :=PC1->PC1_RESPPD
      		PC2->PC2_EMAIL :=PC1->PC1_EMAIL
      		PC2->PC2_PORTAL:=PC1->PC1_PORTAL
      		PC2->PC2_NOMERED:=M->C5_XNREDUZ
      		PC2->PC2_CTR	  :=RTRIM(TRANSFORM(PC2->(recno()),"@E 999999"))
      		PC2->PC2_CTRORI=cControle
      		cControle:=PC2->PC2_CTR
      		PC2->PC2_DREG  :=DATE()
      		PC2->PC2_DPREV:=DATE()+PC1->PC1_TPMED1
      		// DETALHES DO ITEM
      		For nCntFor := 1 To nUsado
			   Do Case
				Case ( AllTrim(aHeadC6[nCntFor,2]) == "C6_ITEM" )
				  PC2->PC2_ITEM:=aCols[x,nCntFor]
				  cItHCI:=aCols[x,nCntFor]             
				Case ( AllTrim(aHeadC6[nCntFor,2]) == "C6_PRODUTO" )
				  PC2->PC2_COD:=aCols[x,nCntFor]
				Case ( AllTrim(aHeadC6[nCntFor,2]) == "C6_DESCRI" )
				  PC2->PC2_DESCRI:=aCols[x,nCntFor]
				Case ( AllTrim(aHeadC6[nCntFor,2]) == "C6_QTDVEN" )
				  PC2->PC2_QTDORI:=aCols[x,nCntFor]
				Case ( AllTrim(aHeadC6[nCntFor,2]) == "C6_NUMREF" )
				  PC2->PC2_CODCLI:=aCols[x,nCntFor]
				Case ( AllTrim(aHeadC6[nCntFor,2]) == "C6_ITEMCLI" )
				  PC2->PC2_ITCLI:=aCols[x,nCntFor]
				Case ( AllTrim(aHeadC6[nCntFor,2]) == "C6_ENTREG" )
				  PC2->PC2_PRAZO:=aCols[x,nCntFor]  
				Case ( AllTrim(aHeadC6[nCntFor,2]) == "C6_QTDLOC2" ) 
				  nCasado:=aCols[x,nCntFor]   
				Case ( AllTrim(aHeadC6[nCntFor,2]) == "C6_QTDLOC3" )
		          nCasado:=nCasado+aCols[x,nCntFor]   
			   EndCase
  	  		Next nCntFor                                                     
      		MSUNLOCK()
      		if nCasado>0 
        		// INCLUINDO PROCESSO 000005 (Solicitacao de Compra Casada)
        		// fase 1 atualizando o processo 000002
       	        dbselectarea("PC2")
        		dbSetOrder(4)
        		if MsSeek(xfilial("PC2")+cPedHCI+cItHCI+"000002")
          			RecLock("PC2",.F.)
          			PC2->PC2_DTINI :=DATE()
          			PC2->PC2_QTD   :=nCasado
          			IF nCasado=PC2->PC2_QTDORI
            			PC2->PC2_DTFIM :=DATE()
            			PC2->PC2_RACAOE :="Processo.Autom." 
            			PC2->PC2_INF:="Solic. de Compra Gerada por:"+Substr(cUsuario,7,15)
            			MSUNLOCK()
         			 endif 
        		ENDIF
        		// INCLUINDO PROCESSO 000005 (Solicitacao de Compra Casada)
        		dbselectarea("PC1")
        		dbSetOrder(1)
        		MsSeek(xfilial("PC1")+"PV0001"+"000005")
        		DbSelectArea("PC2")
        		dbSetOrder(4)
        		nRegistro:=PC2->(recno())
        		RecLock("PC2",.T.)
        		// CAMPOS PADROES DO PEDIDO
        		PC2->PC2_FILIAL:=xfilial("PC2")
        		PC2->PC2_NUM	 :=M->C5_NUM
        		PC2->PC2_CLI	 :=M->C5_CLIENTE
        		PC2->PC2_LOJA	 :=M->C5_LOJACLI
        		PC2->PC2_PEDCLI:=M->C5_COTCLI
        		PC2->PC2_ROTINA:="PV0001"
       	  		PC2->PC2_SEQ   :="000005"
        		PC2->PC2_SEQA	 :="000002"
        		PC2->PC2_SEQP1 :=PC1->PC1_PRACA1 
        		PC2->PC2_SEQP2 :=PC1->PC1_PRACA2
        		PC2->PC2_SEQP3 :=PC1->PC1_PRACA3
        		PC2->PC2_SEQP4 :=PC1->PC1_PRACA4
        		PC2->PC2_SEQP5 :=PC1->PC1_PRACA5
        		PC2->PC2_RESP  :=PC1->PC1_RESPPD
        		PC2->PC2_EMAIL :=PC1->PC1_EMAIL
        		PC2->PC2_PORTAL:=PC1->PC1_PORTAL
        		PC2->PC2_NOMERED:=M->C5_XNREDUZ
        		PC2->PC2_CTR  :=RTRIM(TRANSFORM(PC2->(recno()),"@E 999999"))
        		PC2->PC2_CTRORI=cControle
        		cControle:=PC2->PC2_CTR
        		PC2->PC2_DREG  :=DATE()
        		PC2->PC2_DPREV:=DATE()+PC1->PC1_TPMED1
        		// DETALHES DO ITEM
        		For nCntFor := 1 To nUsado
		    		Do Case
						Case ( AllTrim(aHeadC6[nCntFor,2]) == "C6_ITEM" )
							PC2->PC2_ITEM:=aCols[x,nCntFor]             
						Case ( AllTrim(aHeadC6[nCntFor,2]) == "C6_PRODUTO" )
				  	    	PC2->PC2_COD:=aCols[x,nCntFor]
						Case ( AllTrim(aHeadC6[nCntFor,2]) == "C6_DESCRI" )
				 			PC2->PC2_DESCRI:=aCols[x,nCntFor]
						Case ( AllTrim(aHeadC6[nCntFor,2]) == "C6_QTDVEN" )
				  			PC2->PC2_QTDORI:=aCols[x,nCntFor]
						Case ( AllTrim(aHeadC6[nCntFor,2]) == "C6_NUMREF" )
				  			PC2->PC2_CODCLI:=aCols[x,nCntFor]
						Case ( AllTrim(aHeadC6[nCntFor,2]) == "C6_ITEMCLI" )
				  			PC2->PC2_ITCLI:=aCols[x,nCntFor]
						Case ( AllTrim(aHeadC6[nCntFor,2]) == "C6_ENTREG" )
				  			PC2->PC2_PRAZO:=aCols[x,nCntFor]  
					EndCase
  	    		Next nCntFor                                                     
        		MSUNLOCK()  
      		endif  
     	  next
     	else
     	  Aviso("Restricao de Processo","O pedido <<<NAO SERA SALVO>>>. Campos Importantes na rotina de processo foram alterados, exclua o processo para depois alterar o pedido",{"Ok"},,"Bloqueio de processo")
        endif
      ENDIF
    endif
  else
    // 3 passo inclui dados no controle do processo de entrega se nao existe
   If MsgYesNo("Este cliente tem Controle de Processo, Deseja incluir Pedido no Controle?"  ) 
    // INCLUINDO PROCESSO 000001 (PEDIDO EMITIDO)
    dbselectarea("PC1")
    dbSetOrder(1)
    MsSeek(xfilial("PC1")+"PV0001"+"000001")
    FOR x:=1 TO LEN(ACOLS)
      DbSelectArea("PC2")
      RecLock("PC2",.T.)
      // CAMPOS PADROES DO PEDIDO
      PC2->PC2_FILIAL:=xfilial("PC2")
      PC2->PC2_NUM	 :=M->C5_NUM
      PC2->PC2_CLI	 :=M->C5_CLIENTE
      PC2->PC2_LOJA	 :=M->C5_LOJACLI
      PC2->PC2_PEDCLI:=M->C5_COTCLI
      PC2->PC2_ROTINA:="PV0001"
      PC2->PC2_SEQ   :="000001"
      PC2->PC2_SEQP1 :=PC1->PC1_PRACA1 
      PC2->PC2_SEQP2 :=PC1->PC1_PRACA2
      PC2->PC2_SEQP3 :=PC1->PC1_PRACA3
      PC2->PC2_SEQP4 :=PC1->PC1_PRACA4
      PC2->PC2_SEQP5 :=PC1->PC1_PRACA5
      PC2->PC2_RESP  :=PC1->PC1_RESPPD
      PC2->PC2_EMAIL :=PC1->PC1_EMAIL
      PC2->PC2_PORTAL:=PC1->PC1_PORTAL
      PC2->PC2_DREG  :=DATE()
      PC2->PC2_DPREV:=DATE()+PC1->PC1_TPMED1
      PC2->PC2_DTINI :=DATE()
      PC2->PC2_DTFIM :=DATE()
      PC2->PC2_RACAOE :="Processo.Autom." 
      PC2->PC2_NOMERED:=M->C5_XNREDUZ
      PC2->PC2_CTR	  :=RTRIM(TRANSFORM(PC2->(recno()),"@E 999999"))
      PC2->PC2_INF:="Analise de Contrato OK"
      // DETALHES DO ITEM
      For nCntFor := 1 To nUsado
		    Do Case
				Case ( AllTrim(aHeadC6[nCntFor,2]) == "C6_ITEM" )
				  PC2->PC2_ITEM:=aCols[x,nCntFor]             
				Case ( AllTrim(aHeadC6[nCntFor,2]) == "C6_PRODUTO" )
				  PC2->PC2_COD:=aCols[x,nCntFor]
				Case ( AllTrim(aHeadC6[nCntFor,2]) == "C6_DESCRI" )
				  PC2->PC2_DESCRI:=aCols[x,nCntFor]
				Case ( AllTrim(aHeadC6[nCntFor,2]) == "C6_QTDVEN" )
				  PC2->PC2_QTDORI:=aCols[x,nCntFor]
				  PC2->PC2_QTD	 :=aCols[x,nCntFor]
				Case ( AllTrim(aHeadC6[nCntFor,2]) == "C6_NUMREF" )
				  PC2->PC2_CODCLI:=aCols[x,nCntFor]
				Case ( AllTrim(aHeadC6[nCntFor,2]) == "C6_ITEMCLI" )
				  PC2->PC2_ITCLI:=aCols[x,nCntFor]
				Case ( AllTrim(aHeadC6[nCntFor,2]) == "C6_ENTREG" )
				  PC2->PC2_PRAZO:=aCols[x,nCntFor]  
			EndCase
  	  Next nCntFor                                                     
      MSUNLOCK()
    next
    // INCLUINDO PROCESSO 000002 (PEDIDO EM ANALISE DE LOTES)
    dbselectarea("PC1")
    dbSetOrder(1)
    MsSeek(xfilial("PC1")+"PV0001"+"000002")
    FOR x:=1 TO LEN(ACOLS)
      dbselectarea("PC2")
      dbSetOrder(4)
      if MsSeek(xfilial("PC2")+M->C5_NUM+aCols[x,1]+"000001")
        cControle:=PC2->PC2_CTR
      endif
      DbSelectArea("PC2")
      nRegistro:=PC2->(recno())
      RecLock("PC2",.T.)
      // CAMPOS PADROES DO PEDIDO
      PC2->PC2_FILIAL:=xfilial("PC2")
      PC2->PC2_NUM	 :=M->C5_NUM
      cPedHCI      	 :=M->C5_NUM
      PC2->PC2_CLI	 :=M->C5_CLIENTE
      PC2->PC2_LOJA	 :=M->C5_LOJACLI
      PC2->PC2_PEDCLI:=M->C5_COTCLI
      PC2->PC2_ROTINA:="PV0001"
      PC2->PC2_SEQ   :="000002"
      PC2->PC2_SEQA	 :="000001"
      PC2->PC2_SEQP1 :=PC1->PC1_PRACA1 
      PC2->PC2_SEQP2 :=PC1->PC1_PRACA2
      PC2->PC2_SEQP3 :=PC1->PC1_PRACA3
      PC2->PC2_SEQP4 :=PC1->PC1_PRACA4
      PC2->PC2_SEQP5 :=PC1->PC1_PRACA5
      PC2->PC2_RESP  :=PC1->PC1_RESPPD
      PC2->PC2_EMAIL :=PC1->PC1_EMAIL
      PC2->PC2_PORTAL:=PC1->PC1_PORTAL
      PC2->PC2_NOMERED:=M->C5_XNREDUZ
      PC2->PC2_CTR	  :=RTRIM(TRANSFORM(PC2->(recno()),"@E 999999"))
      PC2->PC2_CTRORI=cControle
      cControle:=PC2->PC2_CTR
      PC2->PC2_DREG  :=DATE()
      PC2->PC2_DPREV:=DATE()+PC1->PC1_TPMED1
      // DETALHES DO ITEM
      For nCntFor := 1 To nUsado
		    Do Case
				Case ( AllTrim(aHeadC6[nCntFor,2]) == "C6_ITEM" )
				  PC2->PC2_ITEM:=aCols[x,nCntFor]
				  cItHCI:=aCols[x,nCntFor]             
				Case ( AllTrim(aHeadC6[nCntFor,2]) == "C6_PRODUTO" )
				  PC2->PC2_COD:=aCols[x,nCntFor]
				Case ( AllTrim(aHeadC6[nCntFor,2]) == "C6_DESCRI" )
				  PC2->PC2_DESCRI:=aCols[x,nCntFor]
				Case ( AllTrim(aHeadC6[nCntFor,2]) == "C6_QTDVEN" )
				  PC2->PC2_QTDORI:=aCols[x,nCntFor]
				Case ( AllTrim(aHeadC6[nCntFor,2]) == "C6_NUMREF" )
				  PC2->PC2_CODCLI:=aCols[x,nCntFor]
				Case ( AllTrim(aHeadC6[nCntFor,2]) == "C6_ITEMCLI" )
				  PC2->PC2_ITCLI:=aCols[x,nCntFor]
				Case ( AllTrim(aHeadC6[nCntFor,2]) == "C6_ENTREG" )
				  PC2->PC2_PRAZO:=aCols[x,nCntFor]  
				Case ( AllTrim(aHeadC6[nCntFor,2]) == "C6_QTDLOC2" ) 
				  nCasado:=aCols[x,nCntFor]   
				Case ( AllTrim(aHeadC6[nCntFor,2]) == "C6_QTDLOC3" )
		          nCasado:=nCasado+aCols[x,nCntFor]   
			EndCase
  	  Next nCntFor                                                     
      MSUNLOCK()
      if nCasado>0 
        // INCLUINDO PROCESSO 000005 (Solicitacao de Compra Casada)
        // fase 1 atualizando o processo 000002
        dbselectarea("PC2")
        dbSetOrder(4)
        if MsSeek(xfilial("PC2")+cPedHCI+cItHCI+"000002")
          RecLock("PC2",.F.)
          PC2->PC2_DTINI :=DATE()
          PC2->PC2_QTD   :=nCasado
          IF nCasado=PC2->PC2_QTDORI
            PC2->PC2_DTFIM :=DATE()
            PC2->PC2_RACAOE :="Processo.Autom." 
            PC2->PC2_INF:="Solic. de Compra Gerada por:"+Substr(cUsuario,7,15)
            MSUNLOCK()
          endif 
        ENDIF
        // INCLUINDO PROCESSO 000005 (Solicitacao de Compra Casada)
        dbselectarea("PC1")
        dbSetOrder(1)
        MsSeek(xfilial("PC1")+"PV0001"+"000005")
        DbSelectArea("PC2")
        dbSetOrder(4)
        nRegistro:=PC2->(recno())
        RecLock("PC2",.T.)
        // CAMPOS PADROES DO PEDIDO
        PC2->PC2_FILIAL:=xfilial("PC2")
        PC2->PC2_NUM	 :=M->C5_NUM
        PC2->PC2_CLI	 :=M->C5_CLIENTE
        PC2->PC2_LOJA	 :=M->C5_LOJACLI
        PC2->PC2_PEDCLI:=M->C5_COTCLI
        PC2->PC2_ROTINA:="PV0001"
        PC2->PC2_SEQ   :="000005"
        PC2->PC2_SEQA	 :="000002"
        PC2->PC2_SEQP1 :=PC1->PC1_PRACA1 
        PC2->PC2_SEQP2 :=PC1->PC1_PRACA2
        PC2->PC2_SEQP3 :=PC1->PC1_PRACA3
        PC2->PC2_SEQP4 :=PC1->PC1_PRACA4
        PC2->PC2_SEQP5 :=PC1->PC1_PRACA5
        PC2->PC2_RESP  :=PC1->PC1_RESPPD
        PC2->PC2_EMAIL :=PC1->PC1_EMAIL
        PC2->PC2_PORTAL:=PC1->PC1_PORTAL
        PC2->PC2_NOMERED:=M->C5_XNREDUZ
        PC2->PC2_CTR  :=RTRIM(TRANSFORM(PC2->(recno()),"@E 999999"))
        PC2->PC2_CTRORI=cControle
        cControle:=PC2->PC2_CTR
        PC2->PC2_DREG  :=DATE()
        PC2->PC2_DPREV:=DATE()+PC1->PC1_TPMED1
        // DETALHES DO ITEM
        For nCntFor := 1 To nUsado
		    Do Case
				Case ( AllTrim(aHeadC6[nCntFor,2]) == "C6_ITEM" )
				  PC2->PC2_ITEM:=aCols[x,nCntFor]             
				Case ( AllTrim(aHeadC6[nCntFor,2]) == "C6_PRODUTO" )
				  PC2->PC2_COD:=aCols[x,nCntFor]
				Case ( AllTrim(aHeadC6[nCntFor,2]) == "C6_DESCRI" )
				  PC2->PC2_DESCRI:=aCols[x,nCntFor]
				Case ( AllTrim(aHeadC6[nCntFor,2]) == "C6_QTDVEN" )
				  PC2->PC2_QTDORI:=aCols[x,nCntFor]
				Case ( AllTrim(aHeadC6[nCntFor,2]) == "C6_NUMREF" )
				  PC2->PC2_CODCLI:=aCols[x,nCntFor]
				Case ( AllTrim(aHeadC6[nCntFor,2]) == "C6_ITEMCLI" )
				  PC2->PC2_ITCLI:=aCols[x,nCntFor]
				Case ( AllTrim(aHeadC6[nCntFor,2]) == "C6_ENTREG" )
				  PC2->PC2_PRAZO:=aCols[x,nCntFor]  
			EndCase
  	    Next nCntFor                                                     
        MSUNLOCK()  
      endif  
    next
   endif
  ENDIF
ENDIF 
ENDIF
RestArea(aSaveArea)
Return ( lRetorno )


