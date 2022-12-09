#INCLUDE "PROTHEUS.CH"
#Include "totvs.ch"

//-----------------------------------------------------------------------
// Rotina | CSTMK020    | Autor | Rafael Beghini     | Data | 08/07/2015
//-----------------------------------------------------------------------
// Descr. | Filtro customizado na chamada em Ações relacionadas CSTMK010
//        | Utiliza rotinas do padrão TMKA271
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function CSTMK020()
	Local _cFiltro  := ""
	Local _cRetFil  := ""
	Local cFiltro   := ""
	Local cOperador := ""
	Local aRet      := {}
	Local aParamBox := {}
	Local oBrowse   := GetMBrowse()
		
	aAdd(aParamBox,{9,"Selecione uma das opções abaixo para filtrar.",150,7,.T.})
	AAdd(aParamBox,{3,"Status",6,{"Faturamento - Verde","Faturado - Vermelho","Orçamento - Azul","Atendimento - Marron","Cancelado - Preto","Todos"},100,"",.T.})
	
	IF ParamBox(aParamBox,"Call Center",@aRet)
		
		SU7->(DbSetOrder(4))
		IF SU7->(MsSeek(xFilial("SU7")+__cUserId)) .AND. SU7->U7_TIPO <> "2"
			_cRetFil  := "UA_OPERADO = '"+SU7->U7_COD+"' "
			cOperador := SU7->U7_TIPO
		Else
			_cRetFil := " "
		EndIF
		
		IF aRet[2] == 1
			_cFiltro	:= "UA_FILIAL = "+ValToSql(xFilial("SUA"))+" .AND. Empty(UA_CODCANC) .AND. Val(UA_OPER) == 1 .AND. Empty(UA_DOC)"	//Faturamento
		ElseIF aRet[2] == 2
			_cFiltro	:= "UA_FILIAL = "+ValToSql(xFilial("SUA"))+" .AND. Empty(UA_CODCANC) .AND. Val(UA_OPER) == 1 .AND. !Empty(UA_DOC)"	//Faturado
		ElseIF aRet[2] == 3	
			_cFiltro	:= "UA_FILIAL = "+ValToSql(xFilial("SUA"))+" .AND. Empty(UA_CODCANC) .AND. Val(UA_OPER) == 2" //Orcamento
		ElseIF aRet[2] == 4
			_cFiltro	:= "UA_FILIAL = "+ValToSql(xFilial("SUA"))+" .AND. Empty(UA_CODCANC) .AND. Val(UA_OPER) == 3" //Atendimento
		ElseIF aRet[2] == 5
			_cFiltro	:= "!Empty(UA_CODCANC)" //Cancelado
		EndIF
		
		IF aRet[2] < 6
		
			IF cOperador == '1'
				cFiltro := _cFiltro + " .AND. " + _cRetFil
			Else
				cFiltro := _cFiltro
			EndIF
		Else
			IF cOperador == '1' //Operador
				cFiltro := "UA_FILIAL = "+ValToSql(xFilial("SUA"))+" .AND. " + _cRetFil
			Else //Supervisor
				cFiltro := "UA_FILIAL = "+ValToSql(xFilial("SUA"))+" "
			EndIF				
		EndIF
		oBrowse:CleanExFilter()
		oBrowse:SetFilterDefault(cFiltro)
	EndIF
Return