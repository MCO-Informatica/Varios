#include "rwmake.ch"
#include "protheus.ch"
#include "topconn.ch"
/*
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????ͻ??
???Programa  ?A175GRV   ?Autor  ?RICARDO CAVALINI    ? Data ?  29/09/2016 ???
?????????????????????????????????????????????????????????????????????????͹??
???Desc.     ? Ponto de entrada para baixa do pedido de compras de        ???
???Desc.     ? importacao, visando o pedido indicado pela sra renata      ???
???Desc.     ? no processo que temos hoje na parte de estoque             ???
?????????????????????????????????????????????????????????????????????????͹??
???Uso       ? Verion                                                     ???
?????????????????????????????????????????????????????????????????????????ͼ??
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
*/
User Function A175GRV()
Local _aArea := GetArea()
Local _cNrNf := SD7->D7_DOC
Local _cSrNf := SD7->D7_SERIE                           

DBSELECTAREA("SD7")
DBSETORDER(4)
DBGOTOP()
IF DBSEEK(XFILIAL("SD7")+_cNrNf+_cSrNf)

   WHILE !EOF() .and. _cNrNf == SD7->D7_DOC .and. _cSrNf == SD7->D7_SERIE
   
         // SO FAZ SE ESTIVER LIBERADO 
         IF SD7->D7_TIPO = 0   
            DbSelectArea("SD7")
            DbSkip()
            Loop
         ENDIF   

         IF SD7->D7_TIPO > 1   
            DbSelectArea("SD7")
            DbSkip()
            Loop
         ENDIF   

         IF SD7->D7_ESTORNO == "S"
            DbSelectArea("SD7")
            DbSkip()
            Loop
         ENDIF   


         // SOMENTE OS ITENS Q AINDA NAO FORAM GERADOS
         IF !EMPTY(SD7->D7_ITEMSWN)
            DbSelectArea("SD7")
            DbSkip()
            Loop
         ENDIF   

         _CNRPC  := SD7->D7_V_NRPC 
         _CITPC  := SD7->D7_V_ITPC
         _CNRPR  := SD7->D7_PRODUTO
         _NQTCQ  := SD7->D7_QTDE

         IF EMPTY(_CITPC)
           __CCHVP := XFILIAL("SC7")+_CNRPR+_CNRPC                                                 
         ELSE
           __CCHVP := XFILIAL("SC7")+_CNRPR+_CNRPC+_CITPC                                                  
         ENDIF

         // AVISO EM TELA PARA USUARIO
         IF EMPTY(ALLTRIM(_CNRPC))    
            MSGALERT("O produto "+SD7->D7_PRODUTO+", da Nota "+SD7->(D7_DOC+D7_SERIE)+" nao tem pedido de compras amarrado... Favor verificar!!!")
         ELSE
	         // ACHA O PEDIDO DE COMPRAS
    	     DBSELECTAREA("SC7")
        	 DBSETORDER(4)
	         IF DBSEEK(__CCHVP)
                _CSLDPC := (SC7->C7_QUANT-SC7->C7_QUJE)
                
                IF _CSLDPC = 0
                   MSGALERT("O produto "+SD7->D7_PRODUTO+", da Nota "+SD7->(D7_DOC+D7_SERIE)+" nao tem saldo no pedido de compras... Favor verificar!!!")
                ELSE
                  IF _CSLDPC > _NQTCQ
                       // AJUSTA PEDIDO DE COMPRAS
 	                   DBSELECTAREA("SC7")
    	                 RECLOCK("SC7",.F.)
        	              SC7->C7_QUJE := SC7->C7_QUJE+_NQTCQ
            	          IF SC7->C7_QUJE > SC7->C7_QUANT
                	         SC7->C7_ENCER := "E"
                    	  ENDIF
                         MSUNLOCK("SC7")          
                         
                       // AJUSTA SALDO DO PEDIDO DE COMPRAS
 	                   DBSELECTAREA("SB2")
 	                   DBSETORDER(1)
 	                   IF DBSEEK(XFILIAL("SB2")+_CNRPR+"01")
 	                      DBSELECTAREA("SB2")
    	                  RECLOCK("SB2",.F.)
        	               SB2->B2_SALPEDI := SB2->B2_SALPEDI - _NQTCQ
                          MSUNLOCK("SB2")          
                       ENDIF

                  ELSE
                     
                     //  AJUSTA PEDIDO DE COMPRA
                     DBSELECTAREA("SC7")
                     RECLOCK("SC7",.F.)
                      SC7->C7_QUJE := SC7->C7_QUJE+_NQTCQ
                      IF SC7->C7_QUJE >= SC7->C7_QUANT
                         SC7->C7_ENCER := "E"
                      ENDIF
                     MSUNLOCK("SC7")              
                     
                     
                     // AJUSTA SALDO DO PEDIDO DE COMPRAS
	                   DBSELECTAREA("SB2")
 	                   DBSETORDER(1)
 	                   IF DBSEEK(XFILIAL("SB2")+_CNRPR+"01")
 	                      DBSELECTAREA("SB2")
    	                  RECLOCK("SB2",.F.)
        	               SB2->B2_SALPEDI := SB2->B2_SALPEDI - _NQTCQ
                          MSUNLOCK("SB2")          
                       ENDIF

                  ENDIF                
                ENDIF
    	     ENDIF

         	 // MARCA O FLAG DO REGISTRO
	         DbSelectArea("SD7")
    	     RECLOCK("SD7",.F.)
        	  SD7->D7_ITEMSWN := "0"
	         MSUNLOCK("SD7")
         ENDIF 
         
         DbSelectArea("SD7")
         DbSkip()
         Loop
   END
ENDIF

// +----------------------------+
// | Restaura Ambiente Original |
// +----------------------------+
RestArea(_aArea)
Return
