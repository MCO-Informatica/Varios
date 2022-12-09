#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "AP5MAIL.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  |LJOB001   ºAutor  ³Bruno S. Parreira   º Data ³  20/09/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina para executar FMAILJOB como JOB.                     º±±
±±º          ³Remodelado em 20180809 [Mauro Nagata, Actual Trend]         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Actual Trend                                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function LJOB001()

Local lRet
Local cParametr
Private aEmpres := {}
 
/* 
AADD(aEmpres,{'01','02'})
AADD(aEmpres,{'01','03'})    COMENTADO PARA TRATAR A NOVA FILIAL 01 E NAO TRATAR A 04
AADD(aEmpres,{'01','04'})    
*/
AADD(aEmpres,{'01','01'})                                                                                                	
AADD(aEmpres,{'01','02'})
AADD(aEmpres,{'01','03'})
           
RpcSetType(3)              	                                 
RpcSetEnv( aEmpres[1,1] , aEmpres[1,2],,,'PMS')                                                             

cParametr  := GetMV('MV_XHRMLJB')
lRet       := .F.
    
cPrimParam := SubStr(cParametr,1,(At(';',cParametr)-1))//Hora para iniciar a JOB 	
cHoraCerta := Replace(cPrimParam , '.', ':')
cHoraCerta := Transform(SomaHoras(cHoraCerta,"00:00"), "@RE 99.99") 
    
dDtUltExec := Ctod(SubStr(cParametr,(At(';',cParametr)+1),8))  //ultima data executada

cHorAtual  := Time()	       
cHorAtual  := Transform(SomaHoras(cHorAtual,"00:00"), "@RE 99.99") 

If cHorAtual >= cHoraCerta .And.Date() > dDtUltExec
	lRet := .T.
EndIf	  
                                                                                          
If .T. //lRet  
	For nCount := 1 To Len(aEmpres)
	 	RpcSetType(3)              	                                 
		If RpcSetEnv(aEmpres[nCount,1] , aEmpres[nCount,2],,,'PMS') 
			U_UPDFASE()
		 
			U_FMAILJOB(aEmpres[nCount,2])  //followup
			
   	  	U_FMAILPVD(aEmpres[nCount,2]) 
	   	  	
	  	  	//U_FMAILVEND()
	  	  	
		Else 
//			Conout('Não foi possivel abrir a empresa: ' + aEmpres[nCount,1] + " filial " + aEmpres[nCount,2]) 
		EndIF
		RpcClearEnv()
	Next 
	
	Return
	
	 	
	If SX6->(DbSeek(xFilial("SX6")+"MV_XHRMLJB"))
  		RecLock("SX6",.F.)
  		SX6->X6_CONTEUD := cPrimParam+";"+Dtoc(Date())
  		SX6->(MsUnLock())
  	EndIf
EndIf

RpcSetType(3)              	                                 
RpcSetEnv( aEmpres[1,1] , aEmpres[1,2],,,'PMS') 
cParametr  := GetMV('MV_XHRVERS') // hora de execusao do update nas versoes abertas  LH  ACTUAL - 18/01/2017
lRet       := .F.
RpcClearEnv()

cPrimParam := SubStr(cParametr,1,(At(';',cParametr)-1))//Hora para iniciar a JOB 	
cHoraCerta := Replace(cPrimParam , '.', ':')
cHoraCerta := Transform(SomaHoras(cHoraCerta,"00:00"), "@RE 99.99") 
    
dDtUltExec := Ctod(SubStr(cParametr,(At(';',cParametr)+1),8))  //ultima data executada

cHorAtual  := Time()	       
cHorAtual  := Transform(SomaHoras(cHorAtual,"00:00"), "@RE 99.99") 

If cHorAtual >= cHoraCerta .And.Date() > dDtUltExec
	lRet := .T.
EndIf
  	
If lRet
  	U_UPDVERSAO()   
  	  	                                          
  	RpcSetType(3)              	                                 
	RpcSetEnv( aEmpres[1,1] , aEmpres[1,2],,,'PMS') 

  	If SX6->(DbSeek(xFilial("SX6")+"MV_XHRVERS"))
  		RecLock("SX6",.F.)
  		SX6->X6_CONTEUD := cPrimParam+";"+Dtoc(Date())
  		SX6->(MsUnLock())
  	EndIf     
  	RpcClearEnv()                                             	
EndIf

RpcSetType(3)              	                                 
RpcSetEnv( aEmpres[1,1] , aEmpres[1,2],,,'PMS')    
cParametr  := GetMV('LP_HJMADR')  //Hora da execucao do Job na MADRugada   
lRet       := .F.                                                          
lRetDXC    := .F.
RpcClearEnv()
    
cPrimParam := SubStr(cParametr,1,(At(';',cParametr)-1))//Hora para iniciar a JOB 	
cHoraCerta := Replace(cPrimParam , '.', ':')
cHoraCerta := Transform(SomaHoras(cHoraCerta,"00:00"), "@RE 99.99") 
    
dDtUltExec := Ctod(SubStr(cParametr,(At(';',cParametr)+1),8))  //ultima data executada

cHorAtual  := Time()	       
cHorAtual  := Transform(SomaHoras(cHorAtual,"00:00"), "@RE 99.99") 

If cHorAtual >= cHoraCerta .And.Date() > dDtUltExec
	If Dow(dDataBase) = 2
      lRet := .T.
   EndIf
   lRetDXC := .F.  //desabilitado
EndIf		                    
          
If lRet.and..f.    
  	For nCount := 1 To Len(aEmpres)
	 	RpcSetType(3)              	                                 
		If RpcSetEnv(aEmpres[nCount,1] , aEmpres[nCount,2],,,'PMS') 
	   	U_MAILROC(aEmpres[nCount,2])  //e-mail resumo da obra sobre custo  291014
			U_MAILDXC(aEmpres[nCount,2])  //e-mail Gasto x caixa 
		Else 
//			Conout('Não foi possivel abrir a Empresa: ' + aEmpres[nCount,1] + " Filial " + aEmpres[nCount,2]) 
		EndIf
		RpcClearEnv()
	Next nCount                                        
	
	RpcSetType(3)              	                                 
	RpcSetEnv( aEmpres[1,1] , aEmpres[1,2],,,'PMS')    
	If SX6->(DbSeek(xFilial("SX6")+"LP_HJMADR"))
  		RecLock("SX6",.F.)
  		SX6->X6_CONTEUD := cPrimParam+";"+Dtoc(Date())
  		SX6->(MsUnLock())
  	EndIf           
  	RpcClearEnv()
EndIf

IF lRetDXC      
	For nCount := 1 To Len(aEmpres)
	 	RpcSetType(3)              	                                 
		IF RpcSetEnv(aEmpres[nCount,1] , aEmpres[nCount,2],,,'PMS') 
			U_MAILDXC(aEmpres[nCount,2])  //e-mail gasto x caixa
		Else 
//			Conout('Não foi possivel abrir a Empresa: ' + aEmpres[nCount,1] + " Filial " + aEmpres[nCount,2]) 
		EndIf
		RpcClearEnv()
  	Next nCount 	   
  	RpcSetType(3)              	                                 
	RpcSetEnv( aEmpres[1,1] , aEmpres[1,2],,,'PMS')    
	If SX6->(DbSeek(xFilial("SX6")+"LP_HJMADR"))
  		RecLock("SX6",.F.)
  		SX6->X6_CONTEUD := cPrimParam+";"+Dtoc(Date())
  		SX6->(MsUnLock())
  	EndIf        
  	RpcClearEnv()
EndIf 		
Return nil 
