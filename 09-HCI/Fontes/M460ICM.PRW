/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M460ICM   ºAutor  ³Microsiga           º Data ³  03/02/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function M460ICM()
  
  If MV_PAR28 == 1
  //If MsgYesNo("Atencao, Deseja Processar Ponto de Entrada para Recalculo do ICMS proprio?","Verificacao") 
    if SC5->C5_TIPO="I"
      _BASEICM:=_VALICM/(_ALIQICM/100)
    Endif
    // TRATAMENTO PARA TODAS AS FILIAIS
    IF SC5->C5_TIPO="N"
       IF SC5->C5_TIPOPV="1" .OR. SC5->C5_TIPOPV="2" .OR. SC5->C5_TIPOPV="3"
          IF SC5->C5_TIPOCLI="R" .AND. Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_EST")<>SM0->M0_ESTENT
            _ALIQICM:=4
            _VALICM:=_BASEICM*(_ALIQICM/100)
          ENDIF
          IF SC5->C5_TIPOCLI="F" .AND. Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_EST")<>SM0->M0_ESTENT
            _ALIQICM:=4
            _VALICM:=_BASEICM*(_ALIQICM/100)
          ENDIF 
          IF SC5->C5_TIPOCLI="S".AND.  Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_EST")<>SM0->M0_ESTENT
            _ALIQICM:=4
            _VALICM:=_BASEICM*(_ALIQICM/100)
          ENDIF
       ELSE
         IF SC5->C5_TIPOCLI="R" .AND. Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_EST")<>SM0->M0_ESTENT
           _ALIQICM:=Posicione("SF7",4,xFilial("SF7")+"005   "+Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_EST")+"R"+Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_EST"),"F7_ALIQEXT")
           _VALICM:=_BASEICM*(_ALIQICM/100)
         ENDIF
         IF SC5->C5_TIPOCLI="F" .AND. Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_EST")<>SM0->M0_ESTENT
           _ALIQICM:=Posicione("SF7",4,xFilial("SF7")+"005   "+Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_EST")+"R"+Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_EST"),"F7_ALIQEXT")
           _VALICM:=_BASEICM*(_ALIQICM/100)
         ENDIF 
         IF SC5->C5_TIPOCLI="S" .AND.  Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_EST")<>SM0->M0_ESTENT
           _ALIQICM:=Posicione("SF7",4,xFilial("SF7")+"005   "+Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_EST")+"R"+Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_EST"),"F7_ALIQEXT")
           _VALICM:=_BASEICM*(_ALIQICM/100)
         ENDIF
       ENDIF  
    ENDIF
    IF SC5->C5_TIPO='C'
        _VALICM:=_BASEICM
        _BASEICM:=_VALICM/(_ALIQICM/100)
    ENDIF
  endif
Return()
	