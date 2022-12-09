#INCLUDE "PROTHEUS.CH"
#INCLUDE "JPEG.CH"
#INCLUDE "Rwmake.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MC090MNU  ºAutor  ³ROBSON BUENO        º Data ³  01/02/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³PONTO DE ENTRADA PARA REGISTRAR CANHOTO A PARTIR DA CONSULTAº±±
±±º          ³NF                                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MC090MNU()             
Aadd(aRotina,{"R.Embarque","U_MC090H1("+STR(3)+")", 0 , 3, 0 ,NIL})
Aadd(aRotina,{"R.Canhoto","U_MC090H1("+STR(4)+")", 0 , 4, 0 ,NIL})

Return()

                
USER FUNCTION MC090H1(nOpc)
  Local aAreaAtu	:= GetArea()												// Salva a area atual  
  Local lRet		:= .T.
  LOCAL dInicio  :=ctod("  /  /  ")
  Local oDlgL 
  Local cTitulo :="Registra Canhoto"
  Local cNota :=SF2->F2_DOC   
  IF nOpc=3 
    cTitulo:="Registra Embarque"
    @ 000,000 To 180,400 Dialog Odlg1 Title OemToAnsi("Rotina P/ Registro de Proc Embarque")
  else
    cTitulo:="Registra Canhoto"
    @ 000,000 To 180,400 Dialog Odlg1 Title OemToAnsi("Rotina P/ Registro de Proc Canhoto")
  endif    
  @ 003,008 To 85,200 Title OemToAnsi("Digite a data da acao")
  @ 015,015 Say OemToAnsi("Data:") OF Odlgl PIXEL
  @ 015,045 msget dInicio  SIZE 60,10 OF OdlgL PIXEL
  @ 055,030 BMPBUTTON TYPE 1 ACTION 	Processa({|| OkProc(odlg1,dInicio,cNota,nOpc)},cTitulo,"Atualizando dados, aguarde...")
  @ 055,060 BMPBUTTON TYPE 2 ACTION Finaliza(odlg1)
  Activate Dialog Odlg1 CENTER

RETURN 
// Finalizacao do Processo
Static Function Finaliza(Odlg1)
  Close(Odlg1)
Return
// Processamento
Static Function OkProc(Odlg1,dInicio,cNota,nOpc)
  Local cRegistro
  if nOpc=4 
    dbSelectArea("SF2")
    dbSetOrder(1)
    If MsSeek(xFilial("SF2")+cNota)
    	RecLock("SF2",.F.)
    	SF2->F2_CANHOTO:=dInicio
        MsUnLock()
    ENDIF
    if dInicio<>ctod("  /  /  ") 
      dbSelectArea("SD2")
      dbSetOrder(10)
      MsSeek(xFilial("SF2")+cNota+SF2->F2_SERIE)
      DO WHILE (!EOF() .AND. SF2->F2_DOC=SD2->D2_DOC .AND. SF2->F2_SERIE=SD2->D2_SERIE)
    	dbselectarea("PC2")
        dbSetOrder(4)
        MsSeek(xfilial("PC2")+SD2->D2_PEDIDO+SD2->D2_ITEMPV+"000027")
        if PC2->PC2_QTDORI-PC2->PC2_QTD>0 .and. PC2->PC2_NUM=SD2->D2_PEDIDO .AND. SD2->D2_ITEMPV=PC2->PC2_ITEM .AND. PC2->PC2_SEQ="000027"
          cRegistro:=PC2->PC2_CTR
         // 2 BAIXA O FATURAMENTO OS E POE EM AGUARDANDO RECEBIMENTO
          U_HCICTPR(SD2->D2_PEDIDO,SD2->S2_ITEMPV,"000027",,SD2->D2_QUANT,"Entregue","","","NF/Item: "+SD2->D2_DOC+SD2->D2_ITEM+"-Ok Entregue em:"+dtos(dInicio),cRegistro) 
        endif
        DBSELECTAREA("SD2")
        DBSKIP()
      ENDDO
    else
       // Verifica controle de processo antes de excluir
       dbselectarea("PC2")
       dbSetOrder(6)
       MsSeek(xfilial("PC2")+SD2->D2_PEDIDO+SD2->D2_ITEMPV+"NF/Item: "+SD2->D2_DOC+SD2->D2_ITEM+"-Ok")
       IF SUBSTRING(PC2->PC2_INF,1,20)="NF/Item: "+SD2->D2_DOC+SD2->D2_ITEM+"-Ok"
         // Primeiramente Verifica se tem processo posterior registrado
         IF U_HCIPDPR(PC2->PC2_NUM,PC2->PC2_ITEM,PC2->PC2_CTR)=.T.  // PEDIDO - ITEM - CONTROLE
           U_HCIEXPR(PC2->PC2_NUM,PC2->PC2_ITEM,PC2->PC2_CTR) 
         ELSE
           lOkOP:=.F.
         ENDIF  
       ENDIF
    endif
  else
    dbSelectArea("SF2")
    dbSetOrder(1)
    If MsSeek(xFilial("SF2")+cNota)
    	RecLock("SF2",.F.)
    	SF2->F2_DTDIGIT:=dInicio
        MsUnLock()
    ENDIF
    if dInicio<>ctod("  /  /  ") 
      dbSelectArea("SD2")
      dbSetOrder(10)
      MsSeek(xFilial("SF2")+cNota+SF2->F2_SERIE)
      DO WHILE (!EOF() .AND. SF2->F2_DOC=SD2->D2_DOC .AND. SF2->F2_SERIE=SD2->D2_SERIE)
    	dbselectarea("PC2")
        dbSetOrder(4)
        MsSeek(xfilial("PC2")+SD2->D2_PEDIDO+SD2->D2_ITEMPV+"000026")
        if PC2->PC2_QTDORI-PC2->PC2_QTD>0 .and. PC2->PC2_NUM=SD2->D2_PEDIDO .AND. SD2->D2_ITEMPV=PC2->PC2_ITEM .AND. PC2->PC2_SEQ="000026"
          cRegistro:=PC2->PC2_CTR
         // 2 BAIXA O FATURAMENTO OS E POE EM AGUARDANDO RECEBIMENTO
          U_HCICTPR(SD2->D2_PEDIDO,SD2->S2_ITEMPV,"000026","000027",SD2->D2_QUANT,"Aguardando entrega","","","NF/Item:"+SD2->D2_DOC+SD2->D2_ITEM+"-Ok Embarcado em:"+dtos(dInicio),cRegistro) 
        endif
        DBSELECTAREA("SD2")
        DBSKIP()
      ENDDO
    else
      // Verifica controle de processo antes de excluir
      dbselectarea("PC2")
      dbSetOrder(6)
      MsSeek(xfilial("PC2")+SD2->D2_PEDIDO+SD2->D2_ITEMPV+"NF/Item:"+SD2->D2_DOC+SD2->D2_ITEM+"-Ok")
      IF SUBSTRING(PC2->PC2_INF,1,19)="NF/Item:"+SD2->D2_DOC+SD2->D2_ITEM+"-Ok"
        // Primeiramente Verifica se tem processo posterior registrado
        IF U_HCIPDPR(PC2->PC2_NUM,PC2->PC2_ITEM,PC2->PC2_CTR)=.T.  // PEDIDO - ITEM - CONTROLE
          U_HCIEXPR(PC2->PC2_NUM,PC2->PC2_ITEM,PC2->PC2_CTR) 
        ELSE
          lOkOP:=.F.
        ENDIF  
      ENDIF
    endif
  endif
  
  Close(Odlg1)
Return

