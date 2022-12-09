#Include "RWMAKE.CH"

/* 
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Fun��o    � MT140TOK � Autor � Mauro Nagata          � Data � 09/05/2011 ���
���������������������������������������������������������������������������Ĵ��
���Descri��o � PE qdo.confirmado a entrada da pre nota                      ���
���������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                     ���
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
*/                                                    
           
User Function MT140TOK()
Local lRet := .T.
Local nI

If !paramixb[1]
   Return
EndIf   

nPosPed := aScan(aHeader,{|x|Alltrim(x[2])=="D1_PEDIDO"}) //pedido de compras
If cTipo = "N".And.cFormul = "N"  //tipo de entrada e formulario proprio
   For nI := 1 To Len(aCols)       //linhas de itens do documento de entrada
       If Empty(aCols[nI][nPosPed])    
          lRet := .F.                 
          nI := Len(aCols)
       EndIf
   Next      
EndIf
If !lRet
   MsgBox("Para realizar a entrada deste documento necessitar� do respectivo Pedido de Compras. Contactar o depto.de Suprimentos","Pr�-Nota","ALERT")
EndIf

Return lRet