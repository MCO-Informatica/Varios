#Include "Protheus.CH"
#Include "RwMake.CH"
#Include "TopConn.CH"
#INCLUDE "TCBROWSE.CH"
#INCLUDE "COLORS.CH"

User Function HCIDA012()

	Local _cFiltroTop	:= U_HCIDM010("CLIENTE")
	
	Private cCadastro	:= "Contas a Receber"
	PRIVATE aRotina 	:= MenuDef()	

	If !Empty(_cFiltroTop)
		_cFiltroTop	:= "E1_CLIENTE||E1_LOJA IN (" + _cFiltroTop + ") "
	EndIf
	
	DbSelectarea("SE1")
	MBrowse(			,			,			,			,"SE1"	,			,			,			,			,				,Fa040Legenda("SE1")		,			,			,			,				,					,			,			,_cFiltroTop)
//	MBrowse ( [ nLin1 ] [ nCol1 ] 	[ nLin2 ] 	[ nCol2 ]	cAlias 	[ aFixe ] 	[ cCpo ] 	[ nPar08 ] 	[ cFun ] 	[ nClickDef ] 	[ aColors ] [ cTopFun ] [ cBotFun ] [ nPar14 ] 	[ bInitBloc ] 	,[ lNoMnuFilter ]	[ lSeeAll ] [ lChgAll ] [ cExprFilTop ] [ nInterval ] [ bTimerAction ] [ uPar22 ] [ uPar23 ] )
	
Return()

Static Function MenuDef()
Local aRotina	:= {{"Pesquisar", "AxPesqui"    , 0 , 1}, ;  //"Pesquisar"
					{"Consulta"	, "Fc040Con"    , 0 , 2}, ;  // "Consulta "
					{"Legenda"	, "FA040Legenda", 0 , 6, ,.F.}}    // "Legenda"
Return(aRotina)