#include "protheus.ch

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+--------------------+--------------------------------+------------------+||
||| Programa: CfmAxZ04 | Autor: Celso Ferrone Martins   | Data: 03/06/2014 |||
||+-----------+--------+--------------------------------+------------------+||
||| Descricao | AxInclui para a tabela Z04                                 |||
||+-----------+------------------------------------------------------------+||
||| Alteracao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Uso       |                                                            |||
||+-----------+------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==============================================================================
*/
User Function CfmAxZ04()

Local cFiltroMes := ""
Local cFilRet    := ""

CfmSx6Inc()

cFiltroMes := dTos(GetMv("VQ_DCULMES"))

cFilRet := "dTos(Z04_EMISSAO)>'"+cFiltroMes+"'"
DbSelectArea("Z04")
Set Filter To &cFilRet

fAxCadZ04()

DbSelectArea("Z04")
Set Filter To

Return()

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+---------------------+-------------------------------+------------------+||
||| Programa: fAxCadZ04 | Autor: Celso Ferrone Martins  | Data: 03/06/2014 |||
||+-----------+---------+-------------------------------+------------------+||
||| Descricao | AxInclui para a tabela Z04                                 |||
||+-----------+------------------------------------------------------------+||
||| Alteracao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Uso       |                                                            |||
||+-----------+------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==============================================================================
*/
Static Function fAxCadZ04()

Local cAlias := "Z04"
Local aCores := {}
//Local cFiltra := "dTos(Z04_EMISSAO)>'"+dTos(GetMv("VQ_DCULMES"))+"'"
Private cCadastro := "Debito e Credito Vendedores"
Private aRotina   := {}

//+-----------------------------------------
// opções de filtro utilizando a FilBrowse
//+-----------------------------------------
//Private aIndexZ04 := {}
//Private bFiltraBrw:= { || FilBrowse(cAlias,@aIndexZ04,@cFiltra) }
//+-----------------------------------------

aAdd(aRotina,{"Pesquisar"	,"AxPesqui"      ,0,1,0,nil})
//+-----------------------------------------
// quando a função FilBrowse for utilizada a função de pesquisa deverá ser a PesqBrw ao invés da AxPesqui
//+-----------------------------------------
//AADD(aRotina,{"Pesquisar" ,"PesqBrw" ,0,1})
//+-----------------------------------------
aAdd(aRotina,{"Visualizar"	,"AxVisual"      ,0,2,0,nil})
aAdd(aRotina,{"Incluir"     ,"U_CfmZ04Cad(3)",0,3,0,nil})
aAdd(aRotina,{"Alterar"     ,"U_CfmZ04Cad(4)",0,4,0,nil})
aAdd(aRotina,{"Excluir"     ,"U_CfmZ04Cad(5)",0,5,0,nil})
aAdd(aRotina,{"Legenda"     ,"U_CfmZ04Lg()"  ,0,6,0,nil})

aAdd(aCores,{"Z04_TIPODC=='C'"  ,"BR_VERDE"  })
aAdd(aCores,{"Z04_TIPODC=='D'"  ,"BR_VERMELHO"})

DbSelectArea(cAlias) ; DbSetOrder(1)

//+-----------------------------------------
// opções de filtro utilizando a FilBrowse
// Cria o filtro na MBrowse utilizando a função FilBrowse
//+-----------------------------------------
//Eval(bFiltraBrw)
//dbSelectArea(cAlias)
//dbGoTop()
//+-----------------------------------------

mBrowse( 6, 1, 22, 75, cAlias,,,,,,aCores)

//+-----------------------------------------
// opções de filtro utilizando a FilBrowse
// Deleta o filtro utilizado na função FilBrowse
//+-----------------------------------------
//EndFilBrw(cAlias,aIndexSA2)
//+-----------------------------------------

Return()

/*
==================================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+---------------------+-----------------------------------+------------------+||
||| Programa: CfmZ04Lg  | Autor: Celso Ferrone Martins      | Data: 19/05/2014 |||
||+------------+--------+-----------------------------------+------------------+||
||| Descricao: | Legenda                                                       |||
||+------------+---------------------------------------------------------------+||
||| Alteracao: |                                                               |||
||+------------+---------------------------------------------------------------+||
||| Uso:       |                                                               |||
||+------------+---------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==================================================================================
*/
User Function CfmZ04Lg()

Local cStrx01 := "Debito e Credito Vendedores"
Local cStrx02 := "Legenda"
Local aCores  := {}

Aadd(aCores,{"BR_VERDE"   ,"Credito"})
Aadd(aCores,{"BR_VERMELHO","Debito"})

BrwLegenda(cStrx01,cStrx02,aCores)

Return()

/*
==================================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+---------------------+-----------------------------------+------------------+||
||| Programa: CfmSx6Inc | Autor: Celso Ferrone Martins      | Data: 02/06/2014 |||
||+------------+--------+-----------------------------------+------------------+||
||| Descricao: |                                                               |||
||+------------+---------------------------------------------------------------+||
||| Alteracao: |                                                               |||
||+------------+---------------------------------------------------------------+||
||| Uso:       |                                                               |||
||+------------+---------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==================================================================================
*/
Static Function CfmSx6Inc()

Local aSx6     := {}
Local aAreaSx6 := SX6->(GetArea())

cX6Var   := "VQ_DCULMES"
cX6Tipo  := "D"
cX6Desc1 := "Data de fechamento do Debito/Credito dos Vendedore"
cX6Desc2 := "s Verquimica.                                     "
cX6Desc3 := "Programa CFMAXZ04.PRW                             "
cX6Cont  := "20140101"
aAdd(aSx6,{cX6Var,cX6Tipo,cX6Desc1,cX6Desc2,cX6Desc3,cX6Cont})

DbSelectArea("SX6") ; DbSetOrder(1)

For nX := 1 To Len(aSx6)
	If !SX6->(DbSeek(Space(2) + aSx6[nX][1]))
		If !SX6->(DbSeek( cFilAnt + aSx6[nX][1]))
			RecLock("SX6",.T.)
			SX6->X6_FIL     := cFilAnt
			SX6->X6_VAR     := aSx6[nX][1]
			SX6->X6_TIPO    := aSx6[nX][2]
			SX6->X6_DESCRIC := aSx6[nX][3]
			SX6->X6_DSCSPA  := aSx6[nX][3]
			SX6->X6_DSCENG  := aSx6[nX][3]
			SX6->X6_DESC1   := aSx6[nX][4]
			SX6->X6_DSCSPA1 := aSx6[nX][4]
			SX6->X6_DSCENG1 := aSx6[nX][4]
			SX6->X6_DESC2   := aSx6[nX][5]
			SX6->X6_DSCSPA2 := aSx6[nX][5]
			SX6->X6_DSCENG2 := aSx6[nX][5]
			SX6->X6_CONTEUD := aSx6[nX][6]
			SX6->X6_PROPRI  := "U"
			SX6->X6_PYME    := "N"
			MsUnlock()
		EndIf
	EndIf
Next nX

SX6->(RestArea(aAreaSx6))

Return()

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+---------------------+-------------------------------+------------------+||
||| Programa: CfmZ04Cad | Autor: Celso Ferrone Martins  | Data: 03/06/2014 |||
||+-----------+---------+-------------------------------+------------------+||
||| Descricao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Alteracao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Uso       |                                                            |||
||+-----------+------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==============================================================================
*/
User Function CfmZ04Cad(nOpc)

Local aCpoZ04 := {"Z04_VENDED","Z04_DOC","Z04_TIPODC","Z04_VALOR","Z04_OBSERV"}

//AxInclui(cAlias,nReg,nOpc,aAcho,cFunc,aCpos,cTudoOk,lF3,cTransact,aButtons,aParam,aAuto,lVirtual,lMaximized,cTela,lPanelFin,oFather,aDim,uArea, lFlat )
//AxAltera(cAlias,nReg,nOpc,aAcho,aCpos,nColMens,cMensagem,cTudoOk,cTransact,cFunc,	aButtons,aParam,aAuto,lVirtual,lMaximized,cTela,lPanelFin,oFather,aDim,uArea,lFlat)
//AxDeleta(cAlias,nReg,nOpc,cTransact,aCpos,aButtons,aParam,aAuto,lMaximized,cTela,aAcho,lPanelFin,oFather,aDim, lFlat)

If nOpc == 3 // Incluir
	AxInclui("Z04",,nOpc,,,aCpoZ04,,,,,,)
ElseIf nOpc == 4 // Alterar
	If Z04->Z04_STATUS != "M"
		MsgAlert("Alteracao permitida somente para documentos manuais","Atencao!")
	Else
		AxAltera("Z04",Z04->(RecNo()),nOpc,,aCpoZ04,,,,,,)
	EndIf
ElseIf nOpc == 5 // Excluir
	If Z04->Z04_STATUS != "M"
		MsgAlert("Exclusao permitida somente para documentos manuais","Atencao!")
	Else
		AxDeleta("Z04",Z04->(RecNo()),nOpc,,,,,,,,)
	EndIf
EndIf

Return()