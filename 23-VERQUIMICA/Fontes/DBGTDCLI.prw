#include "rwmake.ch"       

User Function DBGTDCLI(cCodCli, cCodLoja, cTpDado)

cRetorno := ""
DO CASE                 
	CASE cTpDado == "LOGRADOURO"
		IF(!EMPTY(POSICIONE("SA1",1,xFilial("SA1")+cCodCli+cCodLoja,"A1_ENDCOB")))  
		   cRetorno := POSICIONE("SA1",1,xFilial("SA1")+cCodCli+cCodLoja,"A1_ENDCOB")
		ELSE 
		 	cRetorno := POSICIONE("SA1",1,xFilial("SA1")+cCodCli+cCodLoja,"A1_END")
		ENDIF	
	CASE cTpDado == "BAIRRO" 
		IF(!EMPTY(POSICIONE("SA1",1,xFilial("SA1")+cCodCli+cCodLoja,"A1_BAIRROC")))
			cRetorno := SUBSTR(POSICIONE("SA1",1,xFilial("SA1")+cCodCli+cCodLoja,"A1_BAIRROC"),1,10) 	
		ELSE 
			cRetorno := SUBSTR(POSICIONE("SA1",1,xFilial("SA1")+cCodCli+cCodLoja,"A1_BAIRRO"),1,10)
		ENDIF   		
	CASE cTpDado == "CEP"     
	 	IF(!EMPTY(POSICIONE("SA1",1,xFilial("SA1")+cCodCli+cCodLoja,"A1_CEPC")))
			cRetorno := POSICIONE("SA1",1,xFilial("SA1")+cCodCli+cCodLoja,"A1_CEPC") 	
		ELSE 
			cRetorno := POSICIONE("SA1",1,xFilial("SA1")+cCodCli+cCodLoja,"A1_CEP")
		ENDIF   
	CASE cTpDado == "MUNICIPIO"   
		IF(!EMPTY(POSICIONE("SA1",1,xFilial("SA1")+cCodCli+cCodLoja,"A1_MUNC")))
			cRetorno := SUBSTR(POSICIONE("SA1",1,xFilial("SA1")+cCodCli+cCodLoja,"A1_MUNC"),1,15) 	
		ELSE 
			cRetorno := SUBSTR(POSICIONE("SA1",1,xFilial("SA1")+cCodCli+cCodLoja,"A1_MUN"),1,15)
		ENDIF 
	CASE cTpDado == "ESTADO"
	 	IF(!EMPTY(POSICIONE("SA1",1,xFilial("SA1")+cCodCli+cCodLoja,"A1_ESTC")))
			cRetorno := POSICIONE("SA1",1,xFilial("SA1")+cCodCli+cCodLoja,"A1_ESTC") 	
		ELSE 
			cRetorno := POSICIONE("SA1",1,xFilial("SA1")+cCodCli+cCodLoja,"A1_EST")
		ENDIF 
ENDCASE

Return(cRetorno) 
