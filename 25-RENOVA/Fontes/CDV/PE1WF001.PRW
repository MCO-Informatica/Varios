#Include "Topconn.ch"
#Include "Protheus.ch"

User Function PE1WF001()   
	
	Local aRet := {}
	Local aParamBox := {}
	                                       
	aAdd(aParamBox,{3,"Selecione o e-mail de destino",Iif(Set(_SET_DELETED),1,2),{AllTrim(GetMV("MV_WFAGTUR")),GetNewPar("MV_WFUSRAG", "agtur02@workflow.com")},180,"",.F.})
	// Tipo 3 -> Radio
	//           [2]-Descricao
	//           [3]-Numerico contendo a opcao inicial do Radio
	//           [4]-Array contendo as opcoes do Radio
	//           [5]-Tamanho do Radio
	//           [6]-Validacao
	//           [7]-Flag .T./.F. Parametro Obrigatorio ?
	//	Return "agtur02@workflow.com"     
	If ParamBox(aParamBox,"Viagens",@aRet)
	   For i:=1 To Len(aRet)
	      _cDestino := Iif(aRet[i] == 1 ,AllTrim(GetMV("MV_WFAGTUR")),GetMV("MV_WFUSRAG"))
	   Next 
	Endif
    Return _cDestino		