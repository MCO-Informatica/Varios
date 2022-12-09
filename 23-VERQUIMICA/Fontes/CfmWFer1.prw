#Include "Protheus.Ch"
#Include "TopConn.Ch"
#Include "RwMake.Ch"
#include "TbiConn.Ch"
#include "TbiCode.Ch"

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+---------------------+-------------------------------+------------------+||
||| Programa: CfmWFer1  | Autor: Celso Ferrone Martins  | Data: 10/01/2015 |||
||+-----------+---------+-------------------------------+------------------+||
||| Descricao | Workflow de envio de Ferias a Vencer                       |||
||+-----------+------------------------------------------------------------+||
||| Alteracao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Uso       |                                                            |||
||+-----------+------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==============================================================================
*/

User Function CfmWFer1()

Local dDtLimite := cTod("")
Local MsgMail   := ""
Local lTemSrf   := .F.
Local cAssunto  := "Funcionarios com Ferias a Vencer"
Local cPara     := ""
Local cEol      := CHR(13)+CHR(10)

If FindFunction('WFPREPENV')
	WfPrepEnv( "01", "01")
Else
	Prepare Environment Empresa "01" Filial "01" Tables "SRA,SRF,CTT"
	lAuto := .T.
EndIf

ConOut('Iniciando Workflow de Ferias - CfmWFer1. '+Dtoc(Date())+' - '+Time())

AjustaSx6()

dDtLimite := dDataBase - GetMv("CM_DTLIMFE")
cPara     := GetMv("CM_CFMFER1")

cQuery := " SELECT * FROM " + RetSqlName("SRF") + " SRF    " + cEol
cQuery += "    INNER JOIN " + RetSqlName("SRA") + " SRA ON " + cEol
cQuery += "       SRA.D_E_L_E_T_ <> '*'                    " + cEol
cQuery += "       AND RA_FILIAL = '" + xFilial("SRA") + "' " + cEol
cQuery += "       AND RA_MAT    = RF_MAT                   " + cEol
cQuery += " WHERE                                          " + cEol
cQuery += "    SRF.D_E_L_E_T_ <> '*'                       " + cEol
cQuery += "    AND RF_FILIAL = '" + xFilial("SRF") + "'    " + cEol
cQuery += "    AND RF_DATABAS <= '" + dTos(dDtLimite) + "' " + cEol
cQuery += " ORDER BY RF_DATABAS, RF_MAT                    " + cEol

cQuery := ChangeQuery(cQuery)

If Select("TMPSRF") > 0
	TMPSRF->(DbCloseArea())
EndIf

TcQuery cQuery New Alias "TMPSRF"

While !TMPSRF->(Eof())

	If !lTemSrf
		MsgMail := "<Table Border='1' CellPadding='0' CellSpacing='0'>" + cEol
		MsgMail += "  <Tr>" + cEol
		MsgMail += "    <Td Width='100' Align='Center'>" + cEol
		MsgMail += "      <Font Face='Verdana' Size='3'>" + cEol
		MsgMail += "        <B>" + cEol
		MsgMail += "          Matricula" + cEol
		MsgMail += "        </B>" + cEol
		MsgMail += "      </Font>" + cEol
		MsgMail += "    </Td>" + cEol
		MsgMail += "    <Td Width='500'>" + cEol
		MsgMail += "      <Font Face='Verdana' Size='3'>" + cEol
		MsgMail += "        <B>" + cEol
		MsgMail += "          &nbsp;Nome" + cEol
		MsgMail += "        </B>" + cEol
		MsgMail += "      </Font>" + cEol
		MsgMail += "    </Td>" + cEol
		MsgMail += "    <Td Width='120' Align='Center'>" + cEol
		MsgMail += "      <Font Face='Verdana' Size='3'>" + cEol
		MsgMail += "        <B>" + cEol
		MsgMail += "          Data Base" + cEol
		MsgMail += "        </B>" + cEol
		MsgMail += "      </Font>" + cEol
		MsgMail += "    </Td>" + cEol
		MsgMail += "  </Tr>" + cEol
		lTemSrf := .T.
	EndIf

	MsgMail += "  <Tr>" + cEol
	MsgMail += "    <Td Align='Center'>" + cEol
	MsgMail += "      <Font Face='Verdana' Size='2'>" + cEol
	MsgMail +=          "&nbsp;" + TMPSRF->RA_MAT + "&nbsp;" + cEol
	MsgMail += "      </Font>" + cEol
	MsgMail += "    </Td>" + cEol
	MsgMail += "    <Td>" + cEol
	MsgMail += "      <Font Face='Verdana' Size='2'>" + cEol
	MsgMail +=          "&nbsp;" + TMPSRF->RA_NOME+"&nbsp;" + cEol
	MsgMail += "      </Font>" + cEol
	MsgMail += "    </Td>" + cEol
	MsgMail += "    <Td Align='Center'>" + cEol
	MsgMail += "      <Font Face='Verdana' Size='2'>" + cEol
	MsgMail +=          "&nbsp;" + dToc(sTod(TMPSRF->RF_DATABAS))+"&nbsp;" + cEol
	MsgMail += "      </Font>" + cEol
	MsgMail += "    </Td>" + cEol
	MsgMail += "  </Tr>" + cEol

	TMPSRF->(DbSkip())
EndDo

If Select("TMPSRF") > 0
	TMPSRF->(DbCloseArea())
EndIf

If lTemSrf
	MsgMail += "</Table>"
//	U_CfmEMail(cAssunto,MsgMail,,cPara) // Envia E-mail
EndIf

Return()

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+---------------------+-------------------------------+------------------+||
||| Programa: AjustaSx6 | Autor: Celso Ferrone Martins  | Data: 30/07/2014 |||
||+-----------+---------+-------------------------------+------------------+||
||| Descricao | Ajuste de Parametros SX6                                   |||
||+-----------+------------------------------------------------------------+||
||| Alteracao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Uso       |                                                            |||
||+-----------+------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==============================================================================
*/

Static Function AjustaSx6()

Local cX6Var    := ""
Local cX6Desc1  := ""
Local cX6Desc2  := ""
Local cX6Desc3  := ""
Local cX6Tipo   := ""
Local cConteud  := ""

cX6Var   := "CM_DTLIMFE"
cX6Desc1 := "Data Limite para calculo de ferias.               "
cX6Desc2 := "                                                  "
cX6Desc3 := "CFMWFER1.PRW                                      "
cX6Tipo  := "N" 
cConteud := "300"

DbSelectArea("SX6") ; DbSetOrder(1)

If !SX6->(DbSeek(Space(2) + cX6Var))
	If !SX6->(DbSeek(cFilAnt + cX6Var))
		RecLock("SX6",.T.)
		SX6->X6_FIL     := cFilAnt
		SX6->X6_VAR     := cX6Var
		SX6->X6_TIPO    := cX6Tipo
		SX6->X6_DESCRIC := cX6Desc1
		SX6->X6_DSCSPA  := cX6Desc1
		SX6->X6_DSCENG  := cX6Desc1
		SX6->X6_DESC1   := cX6Desc2
		SX6->X6_DSCSPA1 := cX6Desc2
		SX6->X6_DSCENG1 := cX6Desc2
		SX6->X6_DESC2   := cX6Desc3
		SX6->X6_DSCSPA2 := cX6Desc3
		SX6->X6_DSCENG2 := cX6Desc3
		SX6->X6_CONTEUD := cConteud
		SX6->X6_PROPRI  := "U"
		SX6->X6_PYME    := "N"
		MsUnlock()
	EndIf
EndIf

cX6Var   := "CM_CFMFER1"
cX6Desc1 := "e-mail que receberao Workflow de ferias a vencer  "
cX6Desc2 := "                                                  "
cX6Desc3 := "CFMWFER1.PRW                                      "
cX6Tipo  := "C" 
cConteud := "celso@armi.com.br"

If !SX6->(DbSeek(Space(2) + cX6Var))
	If !SX6->(DbSeek(cFilAnt + cX6Var))
		RecLock("SX6",.T.)
		SX6->X6_FIL     := cFilAnt
		SX6->X6_VAR     := cX6Var
		SX6->X6_TIPO    := cX6Tipo
		SX6->X6_DESCRIC := cX6Desc1
		SX6->X6_DSCSPA  := cX6Desc1
		SX6->X6_DSCENG  := cX6Desc1
		SX6->X6_DESC1   := cX6Desc2
		SX6->X6_DSCSPA1 := cX6Desc2
		SX6->X6_DSCENG1 := cX6Desc2
		SX6->X6_DESC2   := cX6Desc3
		SX6->X6_DSCSPA2 := cX6Desc3
		SX6->X6_DSCENG2 := cX6Desc3
		SX6->X6_CONTEUD := cConteud
		SX6->X6_PROPRI  := "U"
		SX6->X6_PYME    := "N"
		MsUnlock()
	EndIf
EndIf

Return()