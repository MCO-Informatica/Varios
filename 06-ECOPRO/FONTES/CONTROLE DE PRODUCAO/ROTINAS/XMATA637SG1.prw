#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'MATA637.CH'
#DEFINE DS_MODALFRAME 128

/*
Substituir a função MATA637SG1()
Função de consulta padrão SG1GF2
*/

User Function XMATA637SG1()
Local oDlg, oLbx
Local aCpos  := {}
Local aRet   := {}
Local cQuery := ""
Local cAlias := GetNextAlias()
Local lRet   := .F.
Local aArea  := GetArea()

cQuery := " SELECT DISTINCT SG1.G1_TRT, SG1.G1_COMP, SG1.G1_QUANT, SB1.B1_DESC "
cQuery +=   " FROM " + RetSqlName("SG1") + " SG1 "
/*Alteração: colocar descrição do produto*/
cQuery +=   "INNER JOIN "+RetSqlName("SB1")+" SB1 ON B1_FILIAL = '"+xFilial("SB1")+"' "
cQuery +=   "AND SB1.B1_COD = SG1.G1_COMP AND SB1.D_E_L_E_T_ = ' ' "
/*Alteração: colocar descrição do produto*/
cQuery +=  " WHERE SG1.D_E_L_E_T_ = ' ' "
cQuery +=    " AND SG1.G1_FILIAL  = '" + xFilial("SG1") + "' "
If !Empty(M->GF_PRODUTO)
	cQuery += " AND SG1.G1_COD = '" + M->GF_PRODUTO + "' "
EndIf
cQuery += " ORDER BY 2, 1 "

cQuery := ChangeQuery(cQuery)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

While (cAlias)->(!Eof())
	Aadd(aCpos,{(cAlias)->(G1_TRT), (cAlias)->(G1_COMP), (cAlias)->(B1_DESC), (cAlias)->(G1_QUANT)})
	(cAlias)->(dbSkip())
End

(cAlias)->(dbCloseArea())

If Len(aCpos) < 1
	aAdd(aCpos,{" "," ","",0})
EndIf

DEFINE MSDIALOG oDlg TITLE STR0034 /*"Estrutura de produto"*/ FROM 0,0 TO 240,600 PIXEL

@ 10,10 LISTBOX oLbx FIELDS HEADER STR0035 /*"Sequência"*/, STR0023 /*"Produto"*/, "Descrição", STR0036 /*"Quantidade"*/ SIZE 285,95 OF oDlg PIXEL

oLbx:SetArray( aCpos )
oLbx:bLine := {|| {aCpos[oLbx:nAt,1], aCpos[oLbx:nAt,2], aCpos[oLbx:nAt,3], aCpos[oLbx:nAt,4]}}
oLbx:bLDblClick := {|| {oDlg:End(), lRet:=.T., aRet := {oLbx:aArray[oLbx:nAt,1],oLbx:aArray[oLbx:nAt,2],oLbx:aArray[oLbx:nAt,3],oLbx:aArray[oLbx:nAt,4]}}}

DEFINE SBUTTON FROM 107,265 TYPE 1 ACTION (oDlg:End(), lRet:= .T., aRet := {oLbx:aArray[oLbx:nAt,1],oLbx:aArray[oLbx:nAt,2],oLbx:aArray[oLbx:nAt,3],oLbx:aArray[oLbx:nAt,4]}) ENABLE OF oDlg
ACTIVATE MSDIALOG oDlg CENTER

If Len(aRet) > 0 .And. lRet
	If Empty(aRet[2])
    	lRet := .F.
    Else
    	SG1->(dbSetOrder(1))
        SG1->(dbSeek(xFilial("SG1")+M->GF_PRODUTO+aRet[2]+aRet[1]))
    EndIf
EndIf

RestArea(aArea)

Return lRet
