#include "RwMake.ch"
#Include "Protheus.ch"
#Include "TopConn.ch"

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+---------------------+-------------------------------+------------------+||
||| Programa: CFMVERSO  | Autor: Celso Ferrone Martins  | Data: 17/09/2014 |||
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

User function CFMVERSO(cProd)

Local aAreaSb1 := SB1->(GetArea())

DbSelectArea("SB1") ; DbSetOrder(1)

SB1->(DbSeek(xFilial("SB1")+cProd))

If SB1->B1_TIPO != "MP"
	MsgAlert("Tipo de Produto diferente de MP","Atencao!!!")
Else
	If SB1->B1_VQ_VERS != "S"
		MsgAlert("Campo 'MP Versolve?' diferente de Sim.","Atencao!!!")
	Else
		fVersolve(cProd)
	EndIf
EndIf

SB1->(RestArea(aAreaSb1))

Return()

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+---------------------+-------------------------------+------------------+||
||| Programa: fVersolve | Autor: Celso Ferrone Martins  | Data: 17/09/2014 |||
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

Static Function fVersolve(cProd)

Local aAreaSb1  := SB1->(GetArea())
Local aAreaSg1  := SG1->(GetArea())
Local _cUsrLib     := GetMv("VQ_COMPVER")

Private nQtdBase  := 200

Private cCfmMpCod  := SB1->B1_COD
Private cCfmMpDesc := SB1->B1_DESC
Private cCfmMpConv := SB1->B1_CONV
Private nPercMp    := 0
Private nCfmMpQtde := SB1->B1_QB

Private cCfmCod  := Space(15)
Private cCfmDesc := Space(30)
Private nCfmConv := 0
Private nCfmPerc := 0
Private nCfmQtde := 0
Private lAtuaVer := .F.

Private lAltera  := .F.

Private aSg1Exc  := {}

If Select("CFM") > 0
	CFM->(DbCloseArea())
EndIf

aCampos := {}
Aadd(aCampos, {"CFM_COD"  ,"C", 15, 00 })
Aadd(aCampos, {"CFM_DESC" ,"C", 30, 00 })
Aadd(aCampos, {"CFM_CONV" ,"N", 15, 06 })
Aadd(aCampos, {"CFM_PERC" ,"N", 06, 02 })
Aadd(aCampos, {"CFM_QTDE" ,"N", 18, 06 })
Aadd(aCampos, {"CFM_TIPO" ,"C", 01, 00 })

cNomeCFM := CriaTrab(aCampos, .T.)          // Arquivo Temporario
DbUseArea(.T.,, cNomeCFM, "CFM", .F., .F.)
cIndCFM := CriaTrab(NIL,.F.)
IndRegua("CFM",cIndCFM,"CFM_COD",,,"Selecionando Registros...")

aHadTab := {}
Aadd(aHadTab, {"CFM_COD"  ,, "Produto"      , "@!"})
Aadd(aHadTab, {"CFM_DESC" ,, "Descricao"    , "@!"})
Aadd(aHadTab, {"CFM_CONV" ,, "Densidade"    , "@E 999,999.999999"})
Aadd(aHadTab, {"CFM_PERC" ,, "%Composicao " , "@E 999.99"})
Aadd(aHadTab, {"CFM_QTDE" ,, "Quantidade"   , "@E 999,999,999.999999"})

DbSelectArea("SB1") ; DbSetOrder(1)
DbSelectArea("SG1") ; DbSetOrder(1)

If SG1->(DbSeek(xFilial("SG1")+cProd))
	While !SG1->(Eof()) .And. SG1->(G1_FILIAL+G1_COD) == xFilial("SG1")+cProd
		SB1->(DbSeek(xFilial("SB1")+SG1->G1_COMP))
		RecLock("CFM",.T.)
		CFM->CFM_COD  := SB1->B1_COD
		CFM->CFM_DESC := SB1->B1_DESC
		CFM->CFM_CONV := SB1->B1_CONV
		CFM->CFM_PERC := SG1->G1_VQ_PVER
		CFM->CFM_QTDE := SG1->G1_QUANT
		CFM->CFM_TIPO := "A"
		MsUnLock()
		nPercMp	+= SG1->G1_VQ_PVER
		SG1->(DbSkip())
	EndDo
EndIf

CFM->(DbGoTop())

SB1->(DbSeek(xFilial("SB1")+cProd))

aSize := MsAdvSize()

aObjects := {}
AAdd( aObjects, { 100, 100, .t., .t. } )
AAdd( aObjects, { 100, 100, .t., .t. } )
AAdd( aObjects, { 100, 020, .t., .f. } )

aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
aPosObj := MsObjSize( aInfo, aObjects )
aPosGet := MsObjGetPos(aSize[3]-aSize[1],315,{{003,033,160,200,240,263}} )

Define Dialog oDlgVer Title "Composicao de Produtos" From 1,1 To 403,980 OF oMainWnd PIXEL

oDlgVer:lEscClose  := .F. //Nao permite sair ao se pressionar a tecla ESC.
//oDlgVer:lMaximized := .T.

@ 001,001 To 028,442 Label "Materia Prima" Pixel Of oDlgVer
@ 007,003 Say U_CfmFHtml("Codigo"     ,"Navy","8","L")   Size 060,010 Pixel OF oDlgVer Html
@ 007,065 Say U_CfmFHtml("Descricao"  ,"Navy","8","L")   Size 060,010 Pixel OF oDlgVer Html
@ 007,178 Say U_CfmFHtml("Densidade"  ,"Navy","8","L")   Size 060,010 Pixel OF oDlgVer Html
@ 007,240 Say U_CfmFHtml("%Composicao","Navy","8","L")   Size 060,010 Pixel OF oDlgVer Html
@ 007,302 Say U_CfmFHtml("Quantidade" ,"Navy","8","L")   Size 060,010 Pixel OF oDlgVer Html
@ 007,380 Say U_CfmFHtml("Qtde Base"  ,"Navy","8","L")   Size 060,010 Pixel OF oDlgVer Html

@ 015,003 Get cCfmMpCod  Picture "@!"                Size 060,010 When .F. Object oCfmMpCod
@ 015,065 Get cCfmMpDesc Picture "@!"                Size 110,010 When .F. Object oCfmMpDesc
@ 015,178 Get cCfmMpConv Picture "@E 999,999.999999" Size 060,010 When .F. Object oCfmMpConv
@ 015,240 Get nPercMp    Picture "@E 999.99"         Size 060,010 When .F. Object oPercMp
@ 015,302 Get nCfmMpQtde Picture "@E 999,999.999999" Size 060,010 When .F. Object oCfmMpQtde
@ 015,380 Get nQtdBase   Picture "@E 999,999.999999" Size 060,010 When .F. Object oQtdBase

@ 030,001 To 057,442 Label "Dados da Composicao" Pixel Of oDlgVer

@ 036,003 Say U_CfmFHtml("Codigo"     ,"Navy","8","L")   Size 060,010 Pixel OF oDlgVer Html
@ 036,065 Say U_CfmFHtml("Descricao"  ,"Navy","8","L")   Size 060,010 Pixel OF oDlgVer Html
@ 036,178 Say U_CfmFHtml("Densidade"  ,"Navy","8","L")   Size 060,010 Pixel OF oDlgVer Html
@ 036,240 Say U_CfmFHtml("%Composicao","Navy","8","L")   Size 060,010 Pixel OF oDlgVer Html
@ 036,302 Say U_CfmFHtml("Quantidade" ,"Navy","8","L")   Size 060,010 Pixel OF oDlgVer Html

@ 044,003 Get cCfmCod  Picture "@!"                Size 060,010 When .F.      Object oCfmCod
@ 044,065 Get cCfmDesc Picture "@!"                Size 110,010 When .F.      Object oCfmDesc
@ 044,178 Get nCfmConv Picture "@E 999,999.999999" Size 060,010 When .F.      Object oCfmConv
@ 044,240 Get nCfmPerc Picture "@E 999.99"         Size 060,010 When lAtuaVer Valid fValPerc() Object oCfmPerc
@ 044,302 Get nCfmQtde Picture "@E 999,999.999999" Size 060,010 When .F.      Object oCfmQtde

@ 044,398 Button "Atualiza" SIZE 040,010 ACTION fCfmAtual() Pixel OF oDlgVer //Html

oMarkVer := MsSelect():New("CFM", "", "", aHadTab, , ,{059, 001, 200, 442})
oMarkVer:oBrowse:Refresh()
oMarkVer:oBrowse:bLDblClick:={|| fGetVersol(CFM->CFM_COD)}
oMarkVer:oBrowse:cToolTip := "[ duplo click ]"

If __cUserID $ _cUsrLib
	@ 015,445 Button "Incluir"  SIZE 040,010 ACTION fCfmInclu("SB1MP","B1_COD") Pixel OF oDlgVer
	@ 026,445 Button "Alterar"  SIZE 040,010 ACTION fCfmAlter()                 Pixel OF oDlgVer
	@ 037,445 Button "Excluir"  SIZE 040,010 ACTION fCfmExclu()                 Pixel OF oDlgVer
	
	@ 098,445 Button "Gravar"   SIZE 040,010 ACTION fCfmGrava()                 Pixel OF oDlgVer
EndIf
@ 120,445 Button "Encerrar" SIZE 040,010 ACTION fCfmClose()                 Pixel OF oDlgVer

Activate Dialog oDlgVer Centered

SB1->(RestArea(aAreaSb1))
SG1->(RestArea(aAreaSg1))

Return()

/*
===============================================================================
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+---------------------+--------------------------------+------------------+||
||| Programa: fCfmAtual | Autor: Celso Ferrone Martins   | Data: 25/04/2014 |||
||+-----------+---------+--------------------------------+------------------+||
||| Descricao | Atualiza composicao do versolve                             |||
||+-----------+-------------------------------------------------------------+||
||| Alteracao |                                                             |||
||+-----------+-------------------------------------------------------------+||
||| Uso       |                                                             |||
||+-----------+-------------------------------------------------------------+||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
===============================================================================
*/

Static Function fCfmAtual()

Local nPercVal := 0

If lAtuaVer

	nPercVal := fPercAltera()

	If nPercVal + nCfmPerc > 100
		MsgAlert("Composicao nao pode ultrapassar 100%","Atencao!!!")
	Else
		CFM->(DbSeek(cCfmCod))
		RecLock("CFM",.F.)
		CFM->CFM_PERC := nCfmPerc
		MsUnLock()
		CFM->(DbGoTop())
		lAtuaVer := .F.
		nPercMp := nPercVal + nCfmPerc
	EndIf

	CfmAjsDens()
	oPercMp:Refresh()

EndIf


Return()

/*
================================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+----------------------+--------------------------------+------------------+||
||| Programa: fCfmConPad | Autor: Celso Ferrone Martins   | Data: 24/05/2014 |||
||+-----------+----------+--------------------------------+------------------+||
||| Descricao |                                                              |||
||+-----------+--------------------------------------------------------------+||
||| Alteracao |                                                              |||
||+-----------+--------------------------------------------------------------+||
||| Uso       |                                                              |||
||+-----------+--------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
================================================================================
*/
Static Function fCfmInclu(cConSxb,cConCpo)

Local lRet := .F.
Local cAlias := AliasCpo(cConCpo)
Local uRetF3

If lAtuaVer
	MsgAlert("Anter de incluir atualize a edicao. ","Atencao!!")
Else
	
	lRet := ConPad1(,,,cConSxb,cConCpo,,.F.)
	
	If lRet
		cRetF3	:= ( cAlias )->( FieldGet( FieldPos( cConCpo ) ) )
		RecLock("CFM",.T.)
		CFM->CFM_COD  := SB1->B1_COD
		CFM->CFM_DESC := SB1->B1_DESC
		CFM->CFM_CONV := SB1->B1_CONV
		CFM->CFM_TIPO := "I"
		MsUnLock()
	EndIf
	
	CfmAjsDens()
	
EndIf

Return()

/*
===============================================================================
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+---------------------+--------------------------------+------------------+||
||| Programa: fCfmAlter | Autor: Celso Ferrone Martins   | Data: 25/04/2014 |||
||+-----------+---------+--------------------------------+------------------+||
||| Descricao | Altera item selecionado do versolve                         |||
||+-----------+-------------------------------------------------------------+||
||| Alteracao |                                                             |||
||+-----------+-------------------------------------------------------------+||
||| Uso       |                                                             |||
||+-----------+-------------------------------------------------------------+||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
===============================================================================
*/

Static Function fCfmAlter()

If Empty(cCfmCod)
	MsgAlert("Selecione um item para alterar","Atencao!!!")
Else
	lAtuaVer := .T.
	lAltera  := .T.
EndIf

oCfmPerc:Refresh()

Return()

/*
===============================================================================
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+---------------------+--------------------------------+------------------+||
||| Programa: fCfmExclu | Autor: Celso Ferrone Martins   | Data: 25/04/2014 |||
||+-----------+---------+--------------------------------+------------------+||
||| Descricao | Exclui item da composicao                                   |||
||+-----------+-------------------------------------------------------------+||
||| Alteracao |                                                             |||
||+-----------+-------------------------------------------------------------+||
||| Uso       |                                                             |||
||+-----------+-------------------------------------------------------------+||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
===============================================================================
*/

Static Function fCfmExclu()

If Empty(cCfmCod)
	MsgAlert("Selecione o item que deseja excluir","Atencao!!!")
Else
	If lAtuaVer
		MsgAlert("Anter de excluir atualize a edicao. ","Atencao!!")
	Else
		If MsgYesNo("Deseja excluir item "+Alltrim(cCfmCod)+"-"+AllTrim(cCfmDesc)+" ?","Atencao!!!")
			
			CFM->(DbSeek(cCfmCod))
			If CFM->CFM_TIPO == "A"
				aAdd(aSg1Exc,CFM->CFM_COD)
			EndIf
			
			nPercMp -= nCfmPerc
			
			RecLock("CFM",.F.)
			CFM->(DbDelete())
			MsUnLock()
			
			CFM->(DbGoTop())
			
			cCfmCod  := Space(15)
			cCfmDesc := Space(30)
			nCfmConv := 0
			nCfmPerc := 0
			nCfmQtde := 0
			
		EndIf
	EndIf
EndIf

oPercMp:Refresh()

CfmAjsDens()

Return()

/*
===============================================================================
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+---------------------+--------------------------------+------------------+||
||| Programa: fCfmGrava | Autor: Celso Ferrone Martins   | Data: 25/04/2014 |||
||+-----------+---------+--------------------------------+------------------+||
||| Descricao | Grava alteracao do versolve                                 |||
||+-----------+-------------------------------------------------------------+||
||| Alteracao |                                                             |||
||+-----------+-------------------------------------------------------------+||
||| Uso       |                                                             |||
||+-----------+-------------------------------------------------------------+||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
===============================================================================
*/
Static Function fCfmGrava ()

Local lGrava := .F.

If lAtuaVer
	MsgAlert("Anter de gravar atualize a edicao. ","Atencao!!")
Else
	If lAltera
		If MsgYesNo("Deseja gravar as alteracoes efetuadas ?","Gravar ?")
			lGrava := .T.
			lAltera := .F.
		EndIf
	EndIf
EndIf

If lGrava
	Processa({|| CfmExAuto()},"Gravando Alteracao...")
	fCfmClose()
EndIf

Return()

/*
===============================================================================
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+---------------------+--------------------------------+------------------+||
||| Programa: fCfmClose | Autor: Celso Ferrone Martins   | Data: 25/04/2014 |||
||+-----------+---------+--------------------------------+------------------+||
||| Descricao | Encerra rotina de formacao de Preco                         |||
||+-----------+-------------------------------------------------------------+||
||| Alteracao |                                                             |||
||+-----------+-------------------------------------------------------------+||
||| Uso       |                                                             |||
||+-----------+-------------------------------------------------------------+||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
===============================================================================
*/
Static Function fCfmClose()

Local lEncerra := .T.

If lAltera
	lEncerra := .F.
	If MsgYesNo("Composicao nao foi salva. Deseja encerrar programa?","Atencao!!!")
		lEncerra := .T.
	EndIf
EndIf

If lEncerra
	If Select("CFM") > 0
		CFM->(DbCloseArea())
	EndIf
	
	Close(oDlgVer)
EndIf

Return()

/*
===============================================================================
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+---------------------+--------------------------------+------------------+||
||| Programa: fGetVersol| Autor: Celso Ferrone Martins   | Data: 25/04/2014 |||
||+-----------+---------+--------------------------------+------------------+||
||| Descricao | Seleciona item do versolve                                  |||
||+-----------+-------------------------------------------------------------+||
||| Alteracao |                                                             |||
||+-----------+-------------------------------------------------------------+||
||| Uso       |                                                             |||
||+-----------+-------------------------------------------------------------+||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
===============================================================================
*/

Static Function fGetVersol(_cCfmCod)

lAtuaVer := .F.

cCfmCod  := CFM->CFM_COD
cCfmDesc := CFM->CFM_DESC
nCfmConv := CFM->CFM_CONV
nCfmPerc := CFM->CFM_PERC
nCfmQtde := CFM->CFM_QTDE

oCfmCod:Refresh()
oCfmDesc:Refresh()
oCfmConv:Refresh()
oCfmPerc:Refresh()
oCfmQtde:Refresh()

Return()

/*
===============================================================================
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+---------------------+--------------------------------+------------------+||
||| Programa: fValPerc  | Autor: Celso Ferrone Martins   | Data: 25/04/2014 |||
||+-----------+---------+--------------------------------+------------------+||
||| Descricao | Validacao do campo de %                                     |||
||+-----------+-------------------------------------------------------------+||
||| Alteracao |                                                             |||
||+-----------+-------------------------------------------------------------+||
||| Uso       |                                                             |||
||+-----------+-------------------------------------------------------------+||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
===============================================================================
*/
Static Function fValPerc()

Local lRet     := .T.
Local nPercVal := fPercAltera()

If nPercVal + nCfmPerc > 100
	MsgAlert("Composicao nao pode ultrapassar 100%!","Atencao!!!")
	lRet := .F.
EndIf

Return(lRet)

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+----------------------+------------------------------+------------------+||
||| Programa: CfmAjsDens | Autor: Celso Ferrone Martins | Data: 18/09/2014 |||
||+-----------+----------+------------------------------+------------------+||
||| Descricao | Atualiza a quantidade e densidade do produto               |||
||+-----------+------------------------------------------------------------+||
||| Alteracao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Uso       |                                                            |||
||+-----------+------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==============================================================================
*/

Static Function CfmAjsDens()

cCfmMpConv := 0
nCfmMpQtde := 0

CFM->(DbGoTop())
While !CFM->(Eof())
	
	cCfmMpConv += (CFM->CFM_CONV/100)*CFM->CFM_PERC
	RecLock("CFM",.F.)
	CFM->CFM_QTDE := ((nQtdBase/100)*CFM->CFM_PERC)*CFM->CFM_CONV
	MsUnLock()
	
	nCfmMpQtde += CFM->CFM_QTDE
	
	CFM->(DbSkip())
EndDo

cCfmMpConv := Round(cCfmMpConv,6)

CFM->(DbGoTop())

oCfmMpConv:Refresh()
oCfmMpQtde:Refresh()

Return()

/*
===============================================================================
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+---------------------+--------------------------------+------------------+||
||| Programa: fCfmGrava | Autor: Celso Ferrone Martins   | Data: 25/04/2014 |||
||+-----------+---------+--------------------------------+------------------+||
||| Descricao | Grava alteracao do versolve                                 |||
||+-----------+-------------------------------------------------------------+||
||| Alteracao |                                                             |||
||+-----------+-------------------------------------------------------------+||
||| Uso       |                                                             |||
||+-----------+-------------------------------------------------------------+||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
===============================================================================
*/
Static Function fPercAltera()

Local nRet := 0
Local nPerAtu := 0

CFM->(DbSeek(cCfmCod))
nPerAtu := CFM->CFM_PERC

CFM->(DbGoTop())
While !CFM->(Eof())
	nRet += CFM->CFM_PERC
	CFM->(DbSkip())
EndDo

nRet -= nPerAtu

CFM->(DbGoTop())

Return(nRet)

/*
===============================================================================
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+---------------------+--------------------------------+------------------+||
||| Programa: CfmExAuto | Autor: Celso Ferrone Martins   | Data: 25/04/2014 |||
||+-----------+---------+--------------------------------+------------------+||
||| Descricao | Grava alteracao do versolve utilizando execauto             |||
||+-----------+-------------------------------------------------------------+||
||| Alteracao |                                                             |||
||+-----------+-------------------------------------------------------------+||
||| Uso       |                                                             |||
||+-----------+-------------------------------------------------------------+||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
===============================================================================
*/
Static Function CfmExAuto()

Local aCab     := {}
Local aItem    := {}
Local aDetalhe := {}
Local nOpcAuto := 0
Local aAreaSg1 := SG1->(GetArea())
Local aAreaSg5 := SG5->(GetArea())
Local aAreaSb1 := SB1->(GetArea())

DbSelectArea("SG1") ; DbSetOrder(1)
DbSelectArea("SG5") ; DbSetOrder(1)
DbSelectArea("SB1") ; DbSetOrder(1)

SB1->(DbSeek(xFilial("SB1")+cCfmMpCod))
/*
aCab := {	{"G1_COD"   , cCfmMpCod  , NIL},;
			{"G1_QUANT" , nCfmMpQtde , NIL},;
			{"ATUREVSB1", "S"        , NIL},;
			{"NIVALT"   , "S"        , NIL}}

CFM->(DbGoTop())
While !CFM->(Eof())

	aDetalhe := {}
	Aadd(aDetalhe, {"G1_COD"    , cCfmMpCod        , NIL})
	Aadd(aDetalhe, {"G1_COMP"   , CFM->CFM_COD     , NIL})
	Aadd(aDetalhe, {"G1_QUANT"  , CFM->CFM_QTDE    , NIL})
	Aadd(aDetalhe, {"G1_FIXVAR" , "V"              , NIL})
	Aadd(aDetalhe, {"G1_REVFIM" , "ZZZ"            , NIL})
	Aadd(aDetalhe, {"G1_NIV"    , "01"             , NIL})
	Aadd(aDetalhe, {"G1_NIVINV" , "99"             , NIL})
	Aadd(aDetalhe, {"G1_INI"    , dDataBase        , NIL})
	Aadd(aDetalhe, {"G1_FIM"    , cTod("31/12/49") , NIL})
//	Aadd(aDetalhe, {"G1_VQ_PVER", CFM->CFM_PERC    , NIL})
//	Aadd(aDetalhe, {"G1_TRT"    , ""               , NIL})
	aadd(aItem,aDetalhe)

	CFM->(DbSkip())

EndDo
CFM->(DbGoTop())
	
lMsErroAuto := .F.

If SG1->(DbSeek(xFilial('SG1')+aCab[1][2]))
	MSExecAuto({|x,y,z| mata200(x,y,z)},aCab,aItem,4)
Else
	MSExecAuto({|x,y,z| mata200(x,y,z)},aCab,aItem,3)
EndIf

If lMsErroAuto
	MsgStop("Nao foi possivel gerar a estrutura")
	MostraErro()
	lRet := .F.
	DisarmTransaction()
	Break
EndIf

*/

For nX := 1 To Len(aSg1Exc)
	IncProc()
	If SG1->(DbSeek(xFilial('SG1')+cCfmMpCod+aSg1Exc[nX]))
		RecLock("SG1",.F.)
		SG1->(DbDelete())
		MsUnLock()
	EndIf
Next nX

CFM->(DbGoTop())
While !CFM->(Eof())
	IncProc()
	If CFM->CFM_TIPO == "I"
		RecLock("SG1",.T.)
		SG1->G1_FILIAL  := xFilial("SG1")
		SG1->G1_COD     := cCfmMpCod
		SG1->G1_COMP    := CFM->CFM_COD
		SG1->G1_FIXVAR  := "V"
		SG1->G1_REVFIM  := "ZZZ"
		SG1->G1_NIV     := "01"
		SG1->G1_NIVINV  := "99"
		SG1->G1_INI     := dDataBase
		SG1->G1_FIM     := cTod("31/12/49")
		SG1->G1_VLCOMPE := "N"
	Else
		SG1->(DbSeek(xFilial('SG1')+cCfmMpCod+CFM->CFM_COD))
		RecLock("SG1",.F.)
	EndIf

	SG1->G1_QUANT   := CFM->CFM_QTDE
	SG1->G1_VQ_PVER := CFM->CFM_PERC
	
	MsUnLock()

	CFM->(DbSkip())

EndDo
CFM->(DbGoTop())

cRev := "000"
If SG5->(DbSeek(xFilial("SG5")+cCfmMpCod))
	While !SG5->(Eof()) .And. SG5->(G5_FILIAL+G5_PRODUTO) == xFilial("SG5")+cCfmMpCod
		IncProc()
		If cRev < SG5->G5_REVISAO
			cRev := SG5->G5_REVISAO
		EndIf
		SG5->(DbSkip())
	EndDo
EndIf

cRev := Soma1(cRev)

RecLock("SG5",.T.)
SG5->G5_FILIAL  := xFilial("SG5")
SG5->G5_PRODUTO := cCfmMpCod
SG5->G5_REVISAO := cRev
SG5->G5_DATAREV := dDataBase
SG5->G5_USER    := __cUserId
MsUnLock()

RecLock("SB1",.F.)
SB1->B1_CONV   := cCfmMpConv
SB1->B1_QB     := nCfmMpQtde
SB1->B1_REVATU := cRev
MsUnLock()

cQuery := " SELECT * FROM " + RetSqlName("SB1")
cQuery += " WHERE "
cQuery += "    D_E_L_E_T_ <> '*' "
cQuery += "    AND B1_FILIAL = '"+xFilial("SB1")+"' "
cQuery += "    AND B1_VQ_MP  = '"+cCfmMpCod+"' "

cQuery := ChangeQuery(cQuery)

If Select("TRBB1MP") > 0
	TRBB1MP->(DbCloseArea())
EndIf

TcQuery cQuery New Alias "TRBB1MP"

While !TRBB1MP->(Eof())
	If SB1->(DbSeek(xFilial("SB1")+TRBB1MP->B1_COD))
		RecLock("SB1",.F.)
		SB1->B1_CONV   := cCfmMpConv
		MsUnLock()
	EndIf

	TRBB1MP->(DbSkip())
EndDo

If Select("TRBB1MP") > 0
	TRBB1MP->(DbCloseArea())
EndIf

SG1->(RestArea(aAreaSg1))
SG5->(RestArea(aAreaSg5))
SB1->(RestArea(aAreaSb1))

Return()