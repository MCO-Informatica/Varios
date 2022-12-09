/* $HDR$*/
/*$Log:  20812: MATF001.prw 
/*
/*   Rev 1.0    25/05/2012 10:57:16  austinfelipe
/* Adicionado para controle de versão
*/
#include 'Protheus.ch'  
    
//Params:                                                     
//   IN 										               
//   OUT - cValorInicial - Retorna o valor inicial de G1_QUANT
user function MATF001()
	     
	local cValorInicial := 1         
	local aChaveRetorno := {}
	            
	RpcSetType(3)
	RpcSetEnv("01", "01")	            
	                 
	//Alert(SG1->G1_COMP) 
	DbSelectArea("SB1")              
	SB1->(DbGoTop())        
	
	do while SB1->(!eof())  
		aAdd(aChaveRetorno, {SB1->B1_COD, SB1->B1_TIPO, SB1->B1_DESC})   
		
		SB1->(DbSkip())
	enddo
	
	SB1->(DbCloseArea())   
	  
	//Select("SG1")                      
	//DBSelectArea("SG1")
	//SG1->G1_QUANT      
	
	RpcClearEnv()     

return (aChaveRetorno)          

user function CONNEMP(cEmpresa, cCodFilial)
	RpcSetType(3)      
return RpcSetEnv(cEmpresa, cCodFilial)

user function Disconnect()
return RpcClearEnv()   

user function ExecQuery(cEmpresa, cCodFilial, cQuery)  
	local aReturn := {}     
	//local cQuery  := ""  
	
	local nLinha  := 1
	
	RpcSetType(3) 
	RpcSetEnv(cEmpresa, cCodFilial)  
	
	TcQuery cQuery new alias "CUSTOM_QUERY" 
	
	CUSTOM_QUERY->(DbGoTop())   
	
	do while CUSTOM_QUERY->(!Eof())   
		//for nLinha := 1 to Len(
		aAdd(aReturn, {CUSTOM_QUERY})
		
		CUSTOM_QUERY->(DbSkip())
	enddo    
	
	CUSTOM_QUERY->(DbCloseArea())
	
	RpcClearEnv()
return aReturn
