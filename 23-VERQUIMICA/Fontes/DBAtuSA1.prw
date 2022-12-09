#include "Protheus.ch"
#include "rwmake.ch"  
#include "TopConn.ch"   

#DEFINE CRLF CHR(13)+CHR(10)

User Function DBAtuSA1()                                                                                                                       
Local _cMsg := "Rotina de atualização da SA1: " + CRLF
_cMsg += "Essa rotina é responsável por atualizar o campo A1_VQ_VEND dentro do cadastro de clientes." + CRLF
_cMsg += "Peça para os usuários fecharem o cadastro de clientes para que o processo seja executado sem problemas de RECLOCK SA1" + CRLF
	If MsgYesNo(_cMsg)
		Processa({||dbvqatusa1()}, "Atualizando A1_VQ_VEND na SA1")
	EndIf
Return()

Static function dbvqatusa1()
Local _cRet 	:= ""
Local _cQuery 	:= ""      
Local _cTimeIni := ""
Local _cTimeFim	:= ""
Local _cVends := ""

_cTimeIni := TIME()
                          
_cQuery 	:= "SELECT 			 "+ CRLF
_cQuery 	+= " SA1.A1_COD, 	 "+ CRLF
_cQuery 	+= " SA1.A1_LOJA, 	 "+ CRLF
_cQuery 	+= " SA1.A1_NREDUZ,  "+ CRLF
_cQuery 	+= " SA1.A1_REGIAO,	 "+ CRLF
_cQuery 	+= " SA1.A1_GRPVEN 	 "+ CRLF
_cQuery 	+= " 	FROM "+ CRLF
_cQuery 	+= " 	" + RetSqlName("SA1")  + " SA1  "+ CRLF
_cQuery 	+= " 	WHERE  "+ CRLF
_cQuery 	+= " 	SA1.D_E_L_E_T_ <> '*' "+ CRLF
_cQuery 	+= " 	AND (SA1.A1_REGIAO <> '   ' OR SA1.A1_GRPVEN <> '      ') " + CRLF
_cQuery 	+= " ORDER BY A1_COD, A1_LOJA "+ CRLF

If Select("TMPSA1U") > 0
	TMPSA1U->(DbCloseArea())	
EndIf
                        
TcQuery _cQuery New Alias "TMPSA1U"  

ProcRegua(Contar("TMPSA1U","!Eof()")   )
Dbselectarea("TMPSA1U")  
TMPSA1U->(DbGoTop()) 
   	
While !TMPSA1U->(Eof()) 
	IncProc("Lendo Cliente: "+ TMPSA1U->A1_COD +" - Loja: " + TMPSA1U->A1_LOJA)			
	 _cVends := ""
	DbSelectArea("SA1"); DbSetOrder(1)
	If SA1->(DbSeek(xFilial("SA1")+TMPSA1U->(A1_COD+A1_LOJA)))
		 _cVends := U_vAtuCliZ12(TMPSA1U->A1_COD,TMPSA1U->A1_LOJA,TMPSA1U->A1_REGIAO,TMPSA1U->A1_GRPVEN)
		 If(!Empty(_cVends))
              RecLock("SA1", .F.)
              	SA1->A1_VQ_VEND = _cVends
              MsUnlock()
		 EndIf                   		 
	EndIf
	TMPSA1U->(DbSkip())    
EndDo			                                                                                                         
TMPSA1U->(MsUnlock())  

_cTimeFim := TIME()
MsgInfo("Inicio: " + _cTimeIni + " ::: Fim: " + _cTimeFim)

Return(_cRet)