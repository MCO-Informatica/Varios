#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "topconn.ch"      
#INCLUDE "TBICONN.CH"  

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RENCFCGC º Autor ³ Adriano Oliveira   º Data ³  22/01/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Validacao do codigo do fornecedor e do cliente.            º±±
±±º          ³ Esta rotina verifica se ja existe o CNPJ digitado e cria   º±±
±±º          ³ automaticamente outra loja, caso contrario, gera um novo   º±±
±±º          ³ codigo automaticamente.                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GRUPO ABC                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function RENCFCGC(_nOpc)

_aArea := GetArea()
_cVar  := ReadVar()
_cRet  := ""

If "A1" $ _cVar // Cadastro de Clientes
    cCGC := Substr(M->A1_CGC,1,8)
   	_Cod := M->A1_COD
    _Loja:= M->A1_LOJA    
    
   	If INCLUI
		BeginSql alias "TRB"
			SELECT
				A1_FILIAL,
    			A1_COD,
		    	A1_LOJA
   			FROM %table:SA1% A1
    	   		WHERE A1.%notDel%              
    			AND A1_FILIAL = %Exp:xFilial("SA1")%
    			AND SUBSTRING(A1_CGC,1,8) = %Exp:cCGC% 	    		
    		ORDER BY A1_COD, A1_LOJA DESC
  EndSql 
  
		If !TRB->(Eof()) 
   	     	_Cod := TRB->A1_COD
		    _Loja:= Soma1(TRB->A1_LOJA)
		Endif
	Endif
Else
    cCGC := Substr(M->A2_CGC,1,8)
   	_Cod := M->A2_COD
    _Loja:= M->A2_LOJA

	If INCLUI
		BeginSql alias "TRB"
			SELECT  
    			A2_FILIAL,
    			A2_COD,
		    	A2_LOJA
   			FROM %table:SA2% A2
    	   		WHERE A2.%notDel%              
    			AND A2_FILIAL = %Exp:xFilial("SA2")%
    			AND SUBSTRING(A2_CGC,1,8) = %Exp:cCGC%
    		ORDER BY A2_COD, A2_LOJA DESC
  EndSql
		If !TRB->(Eof()) 
   	     	_Cod := TRB->A2_COD
		    _Loja:= Soma1(TRB->A2_LOJA)
		Endif
	Endif
Endif

If _nOpc == 1
	_cRet := _Cod
Else
	_cRet := _Loja
Endif

If Select("TRB") > 0
	TRB->(dbCloseArea())
Endif

RestArea(_aArea)
Return _cRet