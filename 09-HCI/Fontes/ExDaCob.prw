#Include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � ExDaCob  �       � ROBSON BUENO       � Data �  22/06/07   ���
�������������������������������������������������������������������������͹��
���Desc.     � Validacao do Endereco do Sacado                            ���
�������������������������������������������������������������������������͹��
���Uso       � Compras / Fiscal                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function ExDaCob(cCampo)
Local cRetorno

IF Ccampo=="CEP"
  IF SA1->A1_CEPC=SPACE(8) .OR. SA1->A1_CEPC=SA1->A1_CEP 
     cRetorno:=SA1->A1_CEP
  ELSE 
     cRetorno:=SA1->A1_CEPC
  ENDIF        
ELSEIF Ccampo=="END"
  IF SA1->A1_CEPC=SPACE(8) .OR. SA1->A1_CEPC=SA1->A1_CEP  
     cRetorno:=SA1->A1_END
  ELSE 
     cRetorno:=SA1->A1_ENDCOB
  ENDIF       
ELSEIF Ccampo=="BAIRRO"
  IF SA1->A1_CEPC=SPACE(8) .OR. SA1->A1_CEPC=SA1->A1_CEP  
     cRetorno:=SA1->A1_BAIRRO
  ELSE 
     cRetorno:=SA1->A1_BAIRROC
  ENDIF        
ELSEIF Ccampo=="MUN"
  IF SA1->A1_CEPC=SPACE(8) .OR. SA1->A1_CEPC=SA1->A1_CEP 
     cRetorno:=SA1->A1_MUN
  ELSE 
     cRetorno:=SA1->A1_MUNC
  ENDIF    
ELSEIF Ccampo=="EST"
  IF SA1->A1_CEPC=SPACE(8) .OR. SA1->A1_CEPC=SA1->A1_CEP  
     cRetorno:=SA1->A1_EST
  ELSE 
     cRetorno:=SA1->A1_ESTC
  ENDIF
ENDIF      
  
RETURN(cRetorno)
