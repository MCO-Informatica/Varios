#Include "Protheus.ch"

User Function FA070TIT()
Local aArea := GetArea()
Local cSql  := ""

cSql := "SELECT E1_XFORMPG AS FORMPG, SUM(E1_VALOR) AS VALOR FROM "+RetSqlName("SE1")
cSql += " WHERE E1_FILIAL = '"+xFilial("SE1")+"' AND D_E_L_E_T_<>'*' "
cSql += " AND E1_CLIENTE = '"+SE1->E1_CLIENTE+"' AND E1_LOJA = '"+SE1->E1_LOJA+"' "
cSql += " AND E1_TIPO = 'NF' AND E1_"
TcQuery ChangeQuery(cSql) New Alias "_QRY"

DbSelectArea("SA1")
SA1->(DbSetOrder(1))
SA1->(DbGoTop(1))

If SA1->(DbSeek(xFilial("SA1")->SE1->E1_CLIENTE+SE1->E1_LOJA))
    
    RecLock("SA1",.F.)
        SA1->A1_XATRASO := QRY->VALOR
    SA1->(MsUnlock())

EndIf

RestArea(aArea)

Return
