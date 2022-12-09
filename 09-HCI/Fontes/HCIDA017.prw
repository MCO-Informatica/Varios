#Include "Protheus.CH"
#Include "RwMake.CH"
#Include "TopConn.CH"

User Function HCIDA017()

	Local aArea			:= GetArea()
	Local cFiltro 		:= ""
	Local cUsrFilt		:= "" 
	Local oBrowse		:= Nil
	Local _aVend		:= U_HCIDM010("SUSPEC")
	Local _cFiltroTop	:= ""
	Local aCores		:= {{ "AD1->AD1_STATUS=='1'" , "BR_VERDE"	, "Em Aberto" 	},; 	//Em Aberto
							{ "AD1->AD1_STATUS=='2'" , "BR_PRETO"	, "Perdido"		},;	//Perdido
							{ "AD1->AD1_STATUS=='3'" , "BR_AMARELO"	, "Suspenso"	},;	//Suspenso
							{ "AD1->AD1_STATUS=='9'" , "BR_VERMELHO", "Encerrado"	}}		//Encerrado
							
	PRIVATE aRotina 	:= MenuDef()
	PRIVATE CCADASTRO	:= "Cadastro de Projetos"

	If ValType(_aVend) == "A"
		_cFiltroTop	:= "AD1_VEND IN (" +  SubStr(_aVend[1],1,Len(_aVend[1])-1)  + ")"
	EndIf
	
	DbSelectarea("AD1")
	MBrowse(			,			,			,			,"AD1"	,			,			,			,			,				,aCores		,			,			,			,				,					,			,			,_cFiltroTop)


RestArea(aArea)

Return()


Static Function MenuDef()
     
	Private aRotina := {	{ "Pesquisar"		,"AxPesqui"  	,0,1,0	,.F.},;		// "Pesquisar"
							{ "Visual"			,"Ft300Alter"	,0,2,	,.T.},;		// "Visual"
							{ "Incluir"			,"Ft300Alter"	,0,3,	,.T.},;		// "Incluir"
							{ "Alterar"			,"Ft300Alter"	,0,4,	,.T.},;		// "Alterar"
							{ "Exclusao"		,"Ft300Alter"	,0,5,	,.T.},;		// "Exclusao"
							{ "Comparar"		,"Ft300Rev"		,0,2,0	,.T.},;		// "Comparar"
							{ "Legenda"			,"Ft300Leg"		,0,2,0	,.F.},;		// "Legenda"
                            { "Conhecimento"	,"MsDocument"  	,0,4,0	,.F.}}     // "Conhecimento"      
	                                 
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Adiciona Solicitacao de Vistoria Técnica ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ( nModulo == 28 .AND. IIF(Type("__lPyme") <> "U",__lPyme,.F.) == .F. )
		AAdd( aRotina, {"Solicitação Vist. Técnica","TECA290()",0,4,0,.F.} ) // "Solicitação Vist. Técnica"
	EndIf
	                                                       
	If ExistBlock("FT300MNU")
		ExecBlock("FT300MNU",.F.,.F.)
	EndIf
	
Return(aRotina)