#Include "Protheus.ch"

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+---------------------+-------------------------------+------------------+||
||| Programa: MT120TEL  | Autor: Celso Ferrone Martins  | Data: 31/10/2014 |||
||+-----------+---------+-------------------------------+------------------+||
||| Descricao | Inclui campos na tela de Pedido de Compras                 |||
||+-----------+------------------------------------------------------------+||
||| Alteracao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Uso       |                                                            |||
||+-----------+------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+------------------------------------------------------------------------+||
|||                            Parametros                                  |||
||+-------------+-----------+----------------------------------------------+||
||| Nome        | Tipo      | Descrição                                    |||
||+-------------+-----------+----------------------------------------------+||
||| ParamIxb[1] | Objeto    | Objeto da Dialog do Pedido de Compras        |||
|||             |           |                                              |||
||| ParamIxb[2] | Vetor     | Array contendo a posição dos gets do pedido  |||
|||             |           | de compras                                   |||
|||             |           |                                              |||
||| ParamIxb[3] | Vetor     | Array contendo os objetos relacionados aos   |||
|||             |           | campos dos folders do Pedido de Compras      |||
|||             |           |                                              |||
||| ParamIxb[4] | Numérico  | Opção Selecionada no Pedido de Compras       |||
|||             |           | (inclusão, alteração, exclusão, etc ..)      |||
|||             |           |                                              |||
||| ParamIxb[5] | Numérico  | Número do recno do registro do pedido de     |||
|||             |           | compras selecionado.                         |||
||+-------------+-----------+----------------------------------------------+||
||| ExecBlock("MT120TEL",.F.,.F.,{@oDlg, aPosGet, aObj, nOpcx, nReg} )     |||
||+------------------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==============================================================================
*/

User Function MT120TEL()

Local oNewDialog   := ParamIxb[1]
Local aPosGet      := ParamIxb[2]
Local aObj         := ParamIxb[3]
Local nOpcx        := ParamIxb[4]
Local nReg         := ParamIxb[5]
Local lWhen        := .T.
Local cFretDes     := ""
Local oFretDes

Public cCfmFretVer := CriaVar("C7_VQ_TRAN")//Space(6)
Public nCfmFretVer := CriaVar("C7_VQ_VFRE")//0

Public oCfmTpFretV
Public cCfmTpFretV := CriaVar("C7_VQ_TFRE")
Public aCfmTpFretV := {}

Public oA120Cc
Public cA120Cc     := CriaVar("C7_CC")

Aadd(aCfmTpFretV,"")
Aadd(aCfmTpFretV,"F=Frete Fechado")
Aadd(aCfmTpFretV,"T=Frete por tonelada")

DbSelectArea("SC7") ; DbSetOrder(1)
DbSelectArea("SA4") ; DbSetOrder()

If nOpcx != 3
	cCfmFretVer := SC7->C7_VQ_TRAN
	nCfmFretVer := SC7->C7_VQ_VFRE
	cA120Cc     := SC7->C7_CC
	cCfmTpFretV := SC7->C7_VQ_TFRE
	If SA4->(DbSeek(xFilial("SA4")+cCfmFretVer))
		cFretDes := SA4->A4_NOME
	EndIf
	If nOpcx != 4 .And. nOpcx != 6
		lWhen := .F.
	Endif
Endif

xx := 535 //320
yy := 180 //380

@ 038,135 Say  "C.Custo" Of oNewDialog Pixel SIZE 036,006
@ 038,158 MsGet oA120Cc VAR cA120Cc Picture PesqPict('SC7','C7_CC' ) WHEN lWhen F3 CpoRetF3('C7_CC') VALID ExistCpo("CTT").Or.Vazio() OF oNewDialog PIXEL SIZE 036,006 HASBUTTON

@ 050,560 Say  "Tp Frete" Of oNewDialog Pixel SIZE 036,006
@ 050,aPosGet[2,6]+75 MSCOMBOBOX oCfmTpFretV Var cCfmTpFretV Items aCfmTpFretV When lWhen OF oNewDialog PIXEL  Size 070,006 //HASBUTTON  

@ 062,400 Say Alltrim(RetTitle("C7_VQ_VFRE")) Of oNewDialog Pixel SIZE 070,006
@ 062,aPosGet[2,4]+120 MsGet nCfmFretVer Picture PesqPict('SC7',"C7_VQ_VFRE") Valid fValTranp(2,@cFretDes,@oFretDes) When lWhen Of oNewDialog Pixel Size 074,006 HASBUTTON

@ 062,aPosGet[2,1]+500 Say "Verq Transp" Of oNewDialog Pixel SIZE 35,006
@ 062,aPosGet[2,2]+480 MsGet cCfmFretVer  Picture "@!" F3 "SA4" Valid fValTranp(1,@cFretDes,@oFretDes) When lWhen Of oNewDialog Pixel Size 035,006 HASBUTTON
@ 062,aPosGet[2,7]+470 MsGet oFretDes Var cFretDes Picture "@!"  When .F.   Of oNewDialog Pixel Size 100,006

/*
COMENTADO POR LUCAS BAÍA - UPDUO 20/02/2022

@ 038,aPosGet[2,5]-340 Say  "C.Custo" Of oNewDialog Pixel SIZE 036,006
@ 038,aPosGet[2,6]-400 MsGet oA120Cc VAR cA120Cc Picture PesqPict('SC7','C7_CC' ) WHEN lWhen F3 CpoRetF3('C7_CC') VALID ExistCpo("CTT").Or.Vazio() OF oNewDialog PIXEL SIZE 036,006 HASBUTTON

@ 050,aPosGet[2,5]+140 Say  "Tp Frete" Of oNewDialog Pixel SIZE 036,006
@ 050,aPosGet[2,6]+75 MSCOMBOBOX oCfmTpFretV Var cCfmTpFretV Items aCfmTpFretV When lWhen OF oNewDialog PIXEL  Size 070,006 //HASBUTTON  

@ 062,aPosGet[2,3]+125 Say Alltrim(RetTitle("C7_VQ_VFRE")) Of oNewDialog Pixel SIZE 070,006
@ 062,aPosGet[2,4]+120 MsGet nCfmFretVer Picture PesqPict('SC7',"C7_VQ_VFRE") Valid fValTranp(2,@cFretDes,@oFretDes) When lWhen Of oNewDialog Pixel Size 074,006 HASBUTTON

@ 062,aPosGet[2,1]+540 Say "Verq Transp" Of oNewDialog Pixel SIZE 35,006
@ 062,aPosGet[2,2]+495 MsGet cCfmFretVer  Picture "@!" F3 "SA4" Valid fValTranp(1,@cFretDes,@oFretDes) When lWhen Of oNewDialog Pixel Size 035,006 HASBUTTON
@ 062,aPosGet[2,7]+505 MsGet oFretDes Var cFretDes Picture "@!"  When .F.   Of oNewDialog Pixel Size 100,006
*/

//@ 062,aPosGet[2,1]+xx+60 Say "Frete Verquimica Transp." Of oNewDialog Pixel SIZE 070,006
//@ 062,aPosGet[2,2]+yy+60 MsGet cCfmFretVer              Picture "@!"       F3 "SA4" Valid fValTranp(1,@cFretDes,@oFretDes) When lWhen Of oNewDialog Pixel Size 031,006 HASBUTTON
//@ 062,aPosGet[2,7]+yy+70 MsGet oFretDes    Var cFretDes Picture "@!"                                                       When .F.   Of oNewDialog Pixel Size 055,006

/*
@ 032,aPosGet[2,5]-11 Say  Alltrim(RetTitle("C1_CC"))+":" Of oNewDialog Pixel SIZE 036,006
@ 031,aPosGet[2,6]-25 MsGet oA120Cc VAR cA120Cc      Picture PesqPict('SC7','C7_CC'     ) WHEN lWhen F3 CpoRetF3('C7_CC') VALID ExistCpo("CTT").Or.Vazio() OF oNewDialog PIXEL SIZE 050,006 HASBUTTON

@ 044,aPosGet[2,1] Say "Frete Verquimica Transp." Of oNewDialog Pixel SIZE 070,006
@ 043,aPosGet[2,2] MsGet cCfmFretVer              Picture "@!"       F3 "SA4" Valid fValTranp(1,@cFretDes,@oFretDes) When lWhen Of oNewDialog Pixel Size 031,006 HASBUTTON
@ 043,aPosGet[2,7] MsGet oFretDes    Var cFretDes Picture "@!"                                                       When .F.   Of oNewDialog Pixel Size 055,006

@ 044,aPosGet[2,3] Say Alltrim(RetTitle("C7_VQ_VFRE"))+":" Of oNewDialog Pixel SIZE 050,006
@ 043,aPosGet[2,4] MsGet nCfmFretVer              Picture PesqPict('SC7',"C7_VQ_VFRE") Valid fValTranp(2,@cFretDes,@oFretDes) When lWhen Of oNewDialog Pixel Size 074,006 HASBUTTON

@ 044,aPosGet[2,5]-11 Say  Alltrim(RetTitle("C7_VQ_TFRE"))+":" Of oNewDialog Pixel SIZE 036,006
@ 043,aPosGet[2,6]-25 MSCOMBOBOX oCfmTpFretV Var cCfmTpFretV Items aCfmTpFretV When lWhen OF oNewDialog PIXEL  Size 100,006 //HASBUTTON  
*/

Return()

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+---------------------+-------------------------------+------------------+||
||| Programa: fValTranp | Autor: Celso Ferrone Martins  | Data: 03/11/2014 |||
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
Static Function fValTranp(nOpcFret,cFretDes,oFretDes)

Local lRet := .T.
Local aAreaSa4 := SA4->(GetArea())

If nOpcFret == 1
	If !Empty(cCfmFretVer)
		DbSelectArea("SA4") ; DbSetOrder(1)
		If SA4->(DbSeek(xFilial("SA4")+cCfmFretVer))
			cFretDes := SA4->A4_NOME
		Else
			lRet     := .F.
			nCfmFretVer := 0
			cFretDes := ""
			MsgAlert("Transportadora nao encontrada.","Atencao!!!")
		EndIf
	EndIf
ElseIf nOpcFret == 2
	If !Empty(cCfmFretVer) .And. nCfmFretVer == 0
		lRet := .F.
		MsgAlert("Preencha o Valor do Frete.","Atencao!!!")
	ElseIf Empty(cCfmFretVer) .And. nCfmFretVer != 0
		lRet := .F.
		nCfmFretVer := 0
		MsgAlert("Transportadora nao encontrada.","Atencao!!!")
	EndIf
EndIf

SA4->(RestArea(aAreaSa4))
oFretDes:Refresh()

Return(lRet)
