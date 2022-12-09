#Include "RWMAKE.CH"

/* 
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Fun��o    � FA050INC � Autor � Mauro Nagata          � Data � 12/05/2011 ���
���������������������������������������������������������������������������Ĵ��
���Descri��o � PE inclusao do titulo a pagar (consistencia)                 ���
���������������������������������������������������������������������������Ĵ��
��� Uso      � Lisonda www.actualtrend.com.br                               ���
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
*/                                                    
           
User Function FA050INC()
Local lRet := .T.
        
If Alltrim(M->E2_XCC) = "3000"
   If Empty(AllTrim(M->E2_XMNTOBR))
      MsgBox("Este t�tulo foi lan�ado como da obra 3000 [Manuten��o de Obra]. Preencha o campo Manut.Obra","Manuten��o de Obra","ALERT")
      lRet := .F.
   EndIf    
ElseIf !Empty(M->E2_XMNTOBR).And.M->E2_XCC != "3000"
       MsgBox("Neste t�tulo o campo Manuten��o de Obra est� preenhido, mas a Obra est� diferente de 3000","Manuten��o de Obra","ALERT")
       lRet := .F.         
EndIf      
  
If AllTrim(M->E2_XMNTOBR) <> ""
	DbSelectArea("CTT")
	DbsetOrder(1)
	If DbSeek(xFilial("CTT")+M->E2_XMNTOBR)
		If CTT->CTT_MSBLQL = "2"
			MsgAlert("O campo Manut.Obra aceita somente obras bloqueadas.")
			lRet := .F.
		EndIf	  
 	else
 		MsgAlert("Obra do campo Manut.Obra n�o existe.")  
 		lRet := .F.
 	EndIf	  
EndIf	          
	          
Return lRet