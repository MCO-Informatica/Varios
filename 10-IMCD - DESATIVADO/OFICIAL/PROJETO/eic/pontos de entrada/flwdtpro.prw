#INCLUDE "Rwmake.ch"
#INCLUDE "Average.ch"
#INCLUDE "TOPCONN.CH"
                  
//Gatilho de valida��o de data de follow-Up ZE1_DT_PRO Pharma
User Function FLWDTPRO()
Local vData := Ctod("  /  /    ")
	Alert("Data n�o permitida")
Return(vData)