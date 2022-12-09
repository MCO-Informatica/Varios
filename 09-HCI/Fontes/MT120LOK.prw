#INCLUDE "Protheus.ch"
#INCLUDE "TopConn.ch"
/*
���������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������
�����������������������������������������������������������������������������������������ͻ��
��� Programa    � MT120LOK � Ponto de entrada para complementar a inicializa��o do item da���
���             �          � nota fiscal via pedido de compra.                            ���
�����������������������������������������������������������������������������������������͹��
��� Autor       � 23.11.10 � ROBSON BUENO DA SILVA                                        ���
�����������������������������������������������������������������������������������������͹��
��� Produ��o    � ??.??.?? � Ignorado                                                     ���
�����������������������������������������������������������������������������������������͹��
��� Par�metros  � PARAMIXB = array com o item que esta sendo processado.                  ���
�����������������������������������������������������������������������������������������͹��
��� Retorno     � Nil.                                                                    ���
�����������������������������������������������������������������������������������������͹��
��� Observa��es � 																	      ���
���             � Uso Exclusivo da HCI                                                    ���
���             �                                                                         ���
���             �                                                                         ���
�����������������������������������������������������������������������������������������ͼ��
���������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������
*/
User Function MT120LOK()

Local aAreaAtu	:= GetArea()
Local nIt    	:= aScan(aHeader,{|x| Trim(x[2]) == "C7_ITEM"} ) 
Local LRET:=.T.
cOc:=cA120Num
dbselectarea("SC7") 
SC7->(DbSetOrder(1))
if SC7->(DbSeek(xFilial("SC7")+cOc+ACOLS[N,nIt]))
  cOc:=SC7->C7_NUM   
endif
cCodForn:=SC7->C7_FORNECE
cLoja   :=SC7->C7_LOJA
IF ACOLS[N,LEN(ACOLS[N])]=.T.
  dbSelectArea("SZK")
  DbSetOrder(4)
  IF MsSeek(xFilial("SZK")+"OC"+cOc+substring(aCols[n, nIt],2,3))
    MsgInfo("Exclusao de Item de Pedido nao permitido... Itens amarrados com OC/OS existentes. Elimine a Amarra��o para solucao do problema")
    LRET:=.F.
  ENDIF
ENDIF
/*

dbSelectArea("PC2")
  DbSetOrder(1)
  IF MsSeek(xFilial("SZK")+"PV"+M->C5_NUM+aCols[n, nItem])
    MsgInfo("Exclusao de Item de Pedido nao permitido... Itens amarrados com OC/OS existentes. Contate compras para solucao do problema")
    LRET:=.F.
  ENDIF
  dbSelectArea("PC2")
  DbSetOrder(4)
  MsSeek(xFilial("PC2")+M->C5_NUM+aCols[n, nItem]+"000002")
  WHILE (!Eof() .AND. PC2->PC2_NUM=M->C5_NUM .AND. PC2->PC2_ITEM=aCols[n, nItem] .AND. PC2->PC2_SEQ="000002".and. lRet=.T.)
    if PC2->PC2_QTD >0
      MsgInfo("Exclusao de Item de Pedido nao permitido... O pedido tem Controle de Processo e Somente o Departamento de Diligenciamento Pode Liberar o Pedido")
      LRET:=.F. 
    ENDIF
    DBSKIP()
  EndDo  
ENDIF
*/
RestArea(aAreaAtu)

Return(lRet)