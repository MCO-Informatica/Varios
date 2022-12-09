#Include "totvs.ch"
#Include "Protheus.Ch"
//---------------------------------------------------------------
// Rotina | CSGCT030 | Autor | Rafael Beghini | Data | 20/01/2016 
//---------------------------------------------------------------
// Descr. | Rotina específica para alterar a data do vencimento 
//        | da parcela na inclusão do Cronograma Financeiro.
//---------------------------------------------------------------
// Update | Alteração no método conforme nova rotina em MVC
//		  | Rotina chamada no PE U_CNTA300.PRW
//		  | Rafael Beghini - 19/03/2018
//---------------------------------------------------------------
// Uso    | Certisign Certificadora Digital.
//---------------------------------------------------------------
User Function CSGCT030( oModel )
	Local aArea		:= GetArea()
	Local oView		:= FWViewActive()
	Local oModel	:= FWModelActive()
	Local oModelCNF := oModel:GetModel("CNFDETAIL")
	Local nCount	:= 0
	Local aRET 		:= {}
	Local aParambox	:= {}
	Local dData 	:= Ctod(Space(8))

	IF Empty(oModelCNF:GetValue("CNF_COMPET"))
		MsgInfo('Opção não disponível','[CSGCT030]')
		Return NIL
	EndIF
	
	aAdd(aParamBox,{9,"Informe a nova data de vencimento",150,7,.T.})
	aAdd(aParamBox,{1,"Data"  ,Ctod(Space(8)),"","","","",20,.T.})
	
	IF ParamBox(aParamBox,"Vencimento Cronograma",@aRET)
		dData := aRET[2]
		For nCount := 1 to oModelCNF:Length()
			oModelCNF:GoLine(nCount)
		
			IF !oModelCNF:IsDeleted() .And. !Empty(oModelCNF:GetValue("CNF_COMPET"))
	    		oModelCNF:SetValue("CNF_DTVENC",dData)
			EndIf
			dData := MonthSum( dData , 1 ) //Soma Meses em Uma Data
		Next nCount
		MsgInfo('Processo executado com sucesso.','[CSGCT030]')
	EndIF
	
	RestArea(aArea)
Return NIL