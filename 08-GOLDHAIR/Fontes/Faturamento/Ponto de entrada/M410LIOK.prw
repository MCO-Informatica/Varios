#INCLUDE "Protheus.ch"


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  M410LIOK     �Autor  �Guilherme Giuliano Data �  04/09/12    ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada para somar quantidade total de produtos no ��
���          � campo C5_X_TOTQT    ���
�������������������������������������������������������������������������͹��
���Uso       � Gold Hair                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

*****************************************************************************
User function M410LIOK
*****************************************************************************
Local lRet     := .T.
Local nQtdTOT  := 0                 
Local nQtditem := 0
Local nSaldo   := 0
Local aArea := GetArea()


Local cProduto := aCols[n][Ascan(aHeader,{|x| Trim(x[2]) == "C6_PRODUTO"})]
Local nQtdVen   := aCols[n][Ascan(aHeader,{|x| Trim(x[2]) == "C6_QTDVEN"})]

If !l410Auto
  If !aCols[n][len(aHeader)+1]
     dbselectarea("SB2")
     dbsetorder(1)      
     If dbseek(xFilial("SB2")+cProduto)
       nSaldo := 0
       lRet := .T.
       While !SB2->(EOF()) .AND. SB2->B2_COD == cProduto
          nSaldo := nSaldo + (SB2->B2_QATU - SB2->B2_RESERVA - SB2->B2_QPEDVEN)
          SB2->(Dbskip())                            
       Enddo                           
       If nSaldo < nQtdVen
         Alert("Produto sem saldo suficiente !"+" SALDO DISPONIVEL: "+STR(nSaldo))
//         lRet := .F.
       Endif
     Else
       Alert("Produto sem registro de estoque!")
//       lRet := .F.
     Endif                                                            
  Endif
Endif

RestArea(aArea)
return(.T.)