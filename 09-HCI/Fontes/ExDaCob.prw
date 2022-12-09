#Include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ExDaCob  º       ³ ROBSON BUENO       º Data ³  22/06/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Validacao do Endereco do Sacado                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Compras / Fiscal                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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
