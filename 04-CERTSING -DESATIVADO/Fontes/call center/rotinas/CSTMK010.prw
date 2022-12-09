#Include "totvs.ch"
#Include "fwmvcdef.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMBROWSE.CH"
#INCLUDE "FWMVCDEF.CH"

//-----------------------------------------------------------------------
// Rotina | CSTMK010    | Autor | Rafael Beghini     | Data  | 08/07/2015
//-----------------------------------------------------------------------
// Descr. | ® Call Center (Monta Browse do televendas com filtro)
//        | Utiliza rotinas do padrão TMKA271
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function CSTMK010()
	Local oBrw
	Local aCores2   := {}
	Local aRet      := {}
	Local aParamBox := {}
	Local cOperador := '0'
	
	Private aRotina   := TMK10Menu()
	Private cAliasA   := "SUA"
	Private cCadastro 	:= "Atendimento"
	
	AAdd(aParamBox,{9,"Para acessar a rotina, filtre por Status de Atendimento",200,7,.T.})
	AAdd(aParamBox,{3,"Status",6,{"Faturamento - Verde","Faturado - Vermelho","Orçamento - Azul","Atendimento - Marron","Cancelado - Preto","Todos"},100,"",.T.})
	
	IF ParamBox(aParamBox,'',@aRet)
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
		
		//Instaciamento
		oBrw := FWMBrowse():New()
		
		//Tabela que será utilizada
		oBrw:SetAlias( cAliasA )
		
		//Titulo
		oBrw:SetDescription( "Call Center" )
		
		//Filtro
		oBrw:SetFilterDefault( cFiltro )
		
		//Legenda
		oBrw:AddLegend( "(EMPTY(SUA->UA_CODCANC) .AND. VAL(SUA->UA_OPER) == 1 .AND. Empty(SUA->UA_DOC))" , "BR_VERDE"   , "Faturamento" )
		oBrw:AddLegend( "(EMPTY(SUA->UA_CODCANC) .AND. VAL(SUA->UA_OPER) == 1 .AND. !Empty(SUA->UA_DOC))", "BR_VERMELHO", "Faturado"    )
		oBrw:AddLegend( "(EMPTY(SUA->UA_CODCANC) .AND. VAL(SUA->UA_OPER) == 2)"                          , "BR_AZUL"    , "Orçamento"   )
		oBrw:AddLegend( "(EMPTY(SUA->UA_CODCANC) .AND. VAL(SUA->UA_OPER) == 3)"                          , "BR_MARRON"  , "Atendimento" )
		oBrw:AddLegend( "(!EMPTY(SUA->UA_CODCANC))"                                                      , "BR_PRETO"   , "Cancelado"   )
		
		//Ativa
		oBrw:Activate()
	EndIF
Return

//-----------------------------------------------------------------------
// Rotina | TMK10Menu    | Autor | Rafael Beghini     | Data | 08/07/2015
//-----------------------------------------------------------------------
// Descr. | ® Call Center (Monta o aRotina)
//        | Utiliza rotinas do padrão TMKA271
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function TMK10Menu()
	Local aRotina := {}
	Local nI := 0
	
	Local aRot := {}
	Local aSubRot := {}
	Local aFunc := {}
	Local cOrigem := ''
		
	//------------------------------------------------------------------------
	// Ponto de entrada para atender somente Telemarketing e Agenda Certisign.
	//------------------------------------------------------------------------
	aFunc := {'U_CSFA030','TMKA271'}
	
	//---------------------------------
	// A chamada é da Agenda Certisign?
	//---------------------------------
	If FunName()=='CSFA110'
		For nI := 1 To Len( aFunc )
			If IsInCallStack( aFunc[ nI ] )
				cOrigem := Right( aFunc[ nI ], 7 ) // Capturar somente os 7 últimos caractere no nome: exemplo: U_CSFA030 -> CSFA030.
				Exit
			Endif
		Next nI 
	Else
		cOrigem := FunName()
	Endif
	
	AAdd( aSubRot, { "Conhecimento"   , "MSDOCUMENT"  , 0, 4 } )
	AAdd( aSubRot, { "Oportunidade"   , "U_CSFA220('"+cOrigem+"', NIL )"  , 0, 4 } )
	AAdd( aSubRot, { "Gerar Propostas", "U_A321IPro()",  0, 4 } )
	AAdd( aSubRot, { "Autorizar"      , "U_A321Check()", 0, 4 } )
	AAdd( aSubRot, { "Filtrar Status" , "U_CSTMK020()", 0, 4})
	
	Add Option aRotina TITLE 'Pesquisar'   Action "AxPesqui"       Operation 1 Access 0
	Add Option aRotina TITLE 'Visualizar' Action "TK271CallCenter" Operation 2 Access 0
	Add Option aRotina TITLE 'Incluir'    Action "U_CSTMK10I" 	   Operation 3 Access 0
	Add Option aRotina TITLE 'Alterar'    Action "TK271CallCenter" Operation 4 Access 0
	Add Option aRotina TITLE 'Legenda'    Action "TK271Legenda"    Operation 2 Access 0
	Add Option aRotina TITLE 'Copia'      Action "TK271Copia"      Operation 6 Access 0
	Add Option aRotina TITLE 'Mais...'    Action aSubRot           Operation 4 Access 0
	
Return(aRotina)

//Renato Ruy - 05/08/16
//Validar a inclusao de televendas
User Function CSTMK10I

If Upper(AllTrim(cUserName)) $ Upper(GetMV("MV_XAGETLV"))
	TK271CallCenter('SUA',SUA->(RecNo()),3)
Else
	MsgInfo("Usuário sem acesso a incluir Televendas pela rotina, utilize a agenda!")
Endif