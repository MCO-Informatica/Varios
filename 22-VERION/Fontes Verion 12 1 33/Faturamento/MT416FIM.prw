#INCLUDE "rwmake.ch"
/*
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNOVO2     บ Autor ณ AP6 IDE            บ Data ณ  03/10/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Codigo gerado pelo AP6 IDE.                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
*/
User Function MT416FIM()
_cVrPedido     := SC5->C5_NUM
_lFez          := .F.
_aSC5 := _aSC6 := ""

dbSelectArea("SC5")
_aSC5:= GetArea()

dbSelectArea("SC5")
Reclock("SC5",.F.)
 SC5->C5_NOMCLI  := POSICIONE("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_NOME")
// SC5->C5_VROBSPV := SCJ->CJ_VROBSPV
 SC5->C5_VRORIPV := SCJ->CJ_VRORIPV
MSUNLOCK("SC5")

dbSelectArea("SC6")
_aSC6:= GetArea()

If DBSEEK(XFILIAL("SC6")+_cVrPedido)
   While !EOF() .AND. _cVrPedido == SC6->C6_NUM
	    _nSldAtual := 0

		DbSelectArea("SB2")
		DbSetOrder(1)
		If DbSeek(Xfilial("SB2")+SC6->C6_PRODUTO+SC6->C6_LOCAL)
		   _nSldAtual := (SB2->B2_QATU-(SB2->B2_QEMP)) 
		Endif

		DbSelectArea("SC6")
	    Reclock("SC6",.F.)
          SC6->C6_DESCONT := 0
          SC6->C6_VALDESC := 0  
          SC6->C6_OP      := "02"

		  If SC6->C6_QTDVEN > _nSldAtual  // qtdade Pv > SB2
			 SC6->C6_QTDEMP := _nSldAtual
			 _lFez          := .T.
		  ElseIf SC6->C6_QTDVEN < _nSldAtual // Qtdade PV < SB2
			 SC6->C6_QTDEMP := SC6->C6_QTDVEN
			 _lFez          := .T.
	      ElseIf SC6->C6_QTDVEN = _nSldAtual // QTdade PV = SB2
			 SC6->C6_QTDEMP := SC6->C6_QTDVEN
	      Endif
        MsUnlock("SC6")
        DBSKIP()
   End
Endif                       

dbSelectArea("SC6")
RestArea(_aSC6)

dbSelectArea("SC5")
RestArea(_aSC5)

If _lFez 
   dbSelectArea("SC5")
   Reclock("SC5",.F.)
    SC5->C5_LIBEROK := "S"
   MSUNLOCK("SC5")
Endif

Return
