#INCLUDE "Rwmake.ch"
#INCLUDE "Average.ch"
#INCLUDE "TOPCONN.CH"
                  
//Gatilho de validação de data de follow-Up ZE1_DT_PRO Pharma
User Function FLWDTPRO()
Local vData := Ctod("  /  /    ")
	Alert("Data não permitida")
Return(vData)