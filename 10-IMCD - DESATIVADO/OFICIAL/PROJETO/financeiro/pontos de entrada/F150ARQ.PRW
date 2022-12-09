#Include "Totvs.ch"

/*/{Protheus.doc} F150ARQ
@description 	Ponto de entrada para alterar o nome da variável cArqSaida

@author 		Junior Carvalho
@version		1.0
@param			Nil
@return			cArq Nome do Arquivo
@type 			User Function
/*/

User Function F150ARQ()
/*
So, for payment (sispag 240) files you should use T008MMDDHHMMSS.REM
	For cobrança files (cnab 400) files you should use T001MMDDHHMMSS.REM
*/
Local cArq := PARAMIXB

if cempant <> '04'

	IF IsInCallStack("FINA150")
		cLocal := SuperGetMV("MV_LOCENV")  //   \STCP_move\STCP_Send\
		cData := SUBSTR(Dtos(MSDate()),5,4)+StrTran(Time(),":","")
		cArq := cLocal+"I001"+cData+"."+TRIM(SEE->EE_EXTEN)
		public cFA150ARQ  := cArq
	Endif

Endif

Return cArq
