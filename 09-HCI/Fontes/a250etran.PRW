

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³A250ETRAN ºAutor  ³Robson bueno        º Data ³  08/03/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Baixa a Ordem de Servico se OP OK                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function A250ETRAN()
  Local aArea      := (GetArea())  
  local cOp        :=substr(SD3->D3_OP,1,6)
 // SD3->(dbSkip(-1))
  cOp:=substr(SD3->D3_OP,1,6)
  dbSelectArea("AB7")
  DbSetOrder(1)
  if MsSeek(xFilial("AB7")+CoP)
    Reclock("AB7",.F.)
    AB7->AB7_TIPO:="5"
    MSUnlock()
  endif
  dbSelectArea("AB6")
  DbSetOrder(1)
  if MsSeek(xFilial("AB6")+CoP)
    Reclock("AB6",.F.)
    AB6->AB6_STATUS:="E"
    MSUnlock()
  ENDIF
  dbSelectArea("SZK")
  DbSetOrder(1)
  if MsSeek(xFilial("SZK")+"OS"+CoP)
    Reclock("SZK",.F.)
    SZK->ZK_DT_BX  :=DATE()
    IF SZK->ZK_QTS<=SD3->D3_QUANT
      SZK->ZK_QTS    := 0
      SZK->ZK_STATUS :="4"
    ELSE
      SZK->ZK_QTS    :=SZK->ZK_QTS-SD3->D3_QUANT 
      SZK->ZK_STATUS :="2"
    ENDIF
    MSUnlock()
  ENDIF 
  dbSelectArea("SZK")
  DbSetOrder(4)
  if MsSeek(xFilial("SZK")+"OS"+CoP)
    Reclock("SZK",.F.)
    SZK->ZK_DT_BX  :=DATE()
    IF SZK->ZK_QTS<=SD3->D3_QUANT
      SZK->ZK_QTS    := 0
      SZK->ZK_STATUS :="4"
    ELSE
      SZK->ZK_QTS    :=SZK->ZK_QTS-SD3->D3_QUANT 
      SZK->ZK_STATUS :="2"
    ENDIF
    MSUnlock()
  ENDIF
  SD3->(dbSkip())
  RestArea(aArea)   
RETURN .T.  