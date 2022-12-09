#Include "Protheus.CH"
#Include "RwMake.CH"
#Include "TopConn.CH"
#INCLUDE "TCBROWSE.CH"
#INCLUDE "COLORS.CH"
//#INCLUDE "TMKA341.CH"
#INCLUDE 'FWMVCDEF.CH'

User Function HCIDA004()

	Local _aCores		:= {{"VAL(ACH->ACH_STATUS) == 0", "BR_BRANCO"   },;	// Mailing
							{"VAL(ACH->ACH_STATUS) == 1", "BR_MARROM"   },; // Classificado
		   					{"VAL(ACH->ACH_STATUS) == 2", "BR_VERMELHO" },; // Desenvolvimento
		   					{"VAL(ACH->ACH_STATUS) == 3", "BR_AZUL"     },; // Gerente
							{"VAL(ACH->ACH_STATUS) == 4", "BR_AMARELO"  },; // Standy by
							{"VAL(ACH->ACH_STATUS) == 5", "BR_PRETO"    },; // Cancelado
							{"VAL(ACH->ACH_STATUS) == 6", "BR_VERDE"    },;	// Prospect
							{"Empty(ACH->ACH_STATUS)"	, "BR_BRANCO"   }} 	// Maling (sem status)

	Local lTMKMAIL		:= FindFunction("U_TMKMAIL")							// Rdmake padrao para validar a estrutura de importcao
	Local lTMKGRVAC		:= FindFunction("U_TMKGRVAC") 						// Rdmake padrao para validar a importacao de mailing
	
	Local lTK341MEMO	:= FindFunction("U_TK341MEMO")						// P.E  Para capturar os campos memo do usuario para serem atualizados no cadastro de suspects
	Local _aFiltro		:= u_HCIDM010("SUSPEC")
	Local _cFiltroTop	:= ""
	
	Private cCadastro	:= "Atualizacao de Suspect"
	Private aMemos		:= {}			// Campos MEMO do usuario
	Private aRotina		:= MenuDef()    
	
	Static lR7	:= (GetRpoRelease() >= "R7")
	
	If ValType(_aFiltro)=="A"
		_cFiltroTop	:= Iif(!Empty(_aFiltro[1])," ACH_VEND IN (" + SubStr(_aFiltro[1],1,Len(_aFiltro[1])-1) + ")","")
//		_cFiltroTop	:= Iif(!Empty(_cFiltroTop)," AND ","") + Iif(!Empty(_aFiltro[2])," ACH_CODIGO||ACH_LOJA IN (" + _aFiltro[2] + ")","")
	EndIf
/*
	If lTK341MEMO
		aMemos := U_TK341MEMO()
		If (ValType(aMemos) <> "A")
			aMemos := {}
		Endif 
	Endif
/*
	If (nOpc == NIL)
		nOpc := 3
	Else
		nOpc := nOpc
	Endif

	If !lTMKMAIL
		Help(" ",1,"NO_IX",,"TMKMAIL",3,5)
		Return(.F.)
	Endif
	
	If !lTMKGRVAC
		Help(" ",1,"NO_IX",,"TMKGRVAC",3,5)
		Return(.F.)
	Endif
*/	
	DbSelectarea("ACH")
	MBrowse(			,			,			,			,"ACH"	,			,			,			,			,				,_aCores		,			,			,			,				,					,			,			,_cFiltroTop)
//	MBrowse ( [ nLin1 ] [ nCol1 ] 	[ nLin2 ] 	[ nCol2 ]	cAlias 	[ aFixe ] 	[ cCpo ] 	[ nPar08 ] 	[ cFun ] 	[ nClickDef ] 	[ aColors ] [ cTopFun ] [ cBotFun ] [ nPar14 ] 	[ bInitBloc ] 	,[ lNoMnuFilter ]	[ lSeeAll ] [ lChgAll ] [ cExprFilTop ] [ nInterval ] [ bTimerAction ] [ uPar22 ] [ uPar23 ] )

Return (.T.)

Static Function MenuDef()

	Local aRotina	:= {}
	Local aArea		  := GetArea()
	Local aAreaSA3	  := {}
	Local aRotAdic	  := {}															// Retorno do P.E. TK341ROT para entrada automatica
	Local lTk341Rot   := FindFunction("U_TK341ROT")	
	
	If Select("SA3") > 0
		aAreaSA3	:= SA3->(GetArea())
	EndIf
	
	If IsInCallStack("FATA320") .AND. FindFunction("FT060Permi")
		aPermissoes := FT060Permi(__cUserId, "ACA_ACSUSP")
	Else
		aPermissoes := {.T.,.T.,.T.,.T.}
	EndIf
	
	If aPermissoes[4]
		aAdd( aRotina, { "Visualizar" 	,"Tk341Vis" 		, 0 , 2 , , .T.} )		//
	EndIf
	If aPermissoes[1]
		aAdd( aRotina, { "Incluir" 		,"Tk341Inc" 		, 0 , 3	, , .T.} )		//
	EndIf
	If aPermissoes[2]
		aAdd( aRotina, { "Alterar" 		,"Tk341Alt" 		, 0 , 4, 82 , .T.} ) 	// 	//Alterar Cadastros         
	EndIf
	If aPermissoes[3]
		aAdd( aRotina, { "Excluir" 		,"Tk341Del" 		, 0 , 5, 56 , .T.} ) 	// 	//Excluir Tabelas           
	EndIf
	aAdd( aRotina, { "Importar" 		,"Tk341Importa" 	, 0 , 3 , , .T.} )			//
	aAdd( aRotina, { "Contatos" 		,"FtContato"      	, 0 , 4	, , .T.} )			//
	aAdd( aRotina, { "Prospect" 		,"Tk341Prospect"	, 0 , 4 , , .T.} )			//
	aAdd( aRotina, { "Conhecimento" 	,"MsDocument"		, 0 , 4 , , .T.} )			//						
	aAdd( aRotina, { "Legenda" 			,"Tk341Legenda"		, 0 , 2 , , .T.} )			//						

	If Len(aAreaSA3) > 0
		RestArea(aAreaSA3)
	EndIf
	
	RestArea(aArea)
	
Return(aRotina)