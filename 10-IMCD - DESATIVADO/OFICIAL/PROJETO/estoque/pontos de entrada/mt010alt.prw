#include "protheus.ch"
#include "parmtype.ch"

/*/{Protheus.doc} ITEM
Ponto de entrada MVC do MATA010 (produtos)
@type function
@version 
@author junior/marcio.katsumata
@since 17/03/2020
@return any, retorno
/*/
User Function ITEM()

Local aParam := PARAMIXB
Local xRet := .T.
Local oObj := ""
Local cIdPonto := ""
Local cIdModel := ""
Local lIsGrid := .F.
local cCota   := ""
local nQtdCota := 0

If aParam <> NIL
	oObj := aParam[1]
	cIdPonto := aParam[2]
	cIdModel := aParam[3]
	lIsGrid := (Len(aParam) > 3)
	
	If cIdPonto == "MODELCOMMITTTS"
		Reclock("SB1",.F.)
		SB1->B1_DTPRE := DDATABASE
		MSUnlock()

	endif
	if cIdPonto == "FORMCOMMITTTSPRE"

		if superGetMv("ES_ANVCMP", .F. , .F.)
			//--------------------------------
			//Verifica os campos Cota Anvisa 
			//e Qtd Liberada
			//--------------------------------
			oModelProd  := FWModelActive()
	    	oModSB1 := oModelProd:GetModel('SB1MASTER')

			cCota := oModSB1:getValue("B1_XCOTA")
			nQtdCota:= oModSB1:getValue("B1_XQTDCOT")
			cCodProd:= oModSB1:getValue("B1_COD")

			if SB1->B1_XCOTA <> cCota 
				gravaLog("B1_XCOTA", SB1->B1_XCOTA, cCota,cCodProd)
			endif

			if SB1->B1_XQTDCOT <> nQtdCota
				gravaLog("B1_XQTDCOT", alltrim(cValToChar(SB1->B1_XQTDCOT)), alltrim(cValToChar(nQtdCota)),cCodProd)
			endif
			
		endif

	EndIf



EndIf


Return xRet

/*/{Protheus.doc} gravaLog
grava log de alteração dos campos na tabela ZAO
@type function
@version 1.0
@author marcio.katsumata
@since 17/03/2020
@param cCampo, character, nome do campo
@param cVlrAnt, character, valor anterior
@param cVlrNew, character, valor novo
@return nil, nil
/*/
static function gravaLog(cCampo, cVlrAnt, cVlrNew,cCodProd)

	default cCodProd := SB1->B1_COD

	dbSelectArea("ZAO")

	reclock("ZAO",.T.)
	ZAO->ZAO_COD    := cCodProd
	ZAO->ZAO_CAMPO  := cCampo
	ZAO->ZAO_VLRANT := cVlrAnt
	ZAO->ZAO_VLRNEW := cVlrNew
	ZAO->ZAO_CODUSU := __cUserId
	ZAO->ZAO_NOMUSU := UsrFullName(__cUserId)
	ZAO->ZAO_DATA   := date()
	ZAO->ZAO_HORA   := time()
	ZAO->(msUnlock())


return