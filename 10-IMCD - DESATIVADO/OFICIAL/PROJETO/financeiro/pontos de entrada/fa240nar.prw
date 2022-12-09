#Include "Totvs.ch"

/*/{Protheus.doc} FA240NAR
@description 	Ponto de entrada para alterar o nome da variável cArqSaida

@author 		Junior Carvalho
@version		1.0
@param			Nil
@return			cArq Nome do Arquivo
@type 			User Function
/*/

User Function FA240NAR()
/*
So, for payment (sispag 240) files you should use T008MMDDHHMMSS.REM
For cobrança files (cnab 400) files you should use T001MMDDHHMMSS.REM
*/
Local cArq := PARAMIXB

IF IsInCallStack("FINA300")
	cLocal := SuperGetMV("MV_LOCENV") 
	cData := SUBSTR(Dtos(MSDate()),5,4)+StrTran(Time(),":","")
	cArq := cLocal+"I008"+cData+"."+TRIM(SEE->EE_EXTEN)
	public cFA240NAR  := cArq
Endif

Return cArq
