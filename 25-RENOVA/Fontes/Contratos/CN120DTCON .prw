#Include "Protheus.ch"


User Function CN120DTCON()

Local lRet  := .T.
Local cEmpLogada := SubStr(cNumEmp,3,7)
Local cEmpPosic  := cFilAnt 
Local cQuery := ""
Local cAliasQry := ""
Local cMsg  := "" 
Local aArea := GetArea()

// Verifica se há adiantamento com saldo para o contrato
cAliasQry := GetNextAlias()
cQuery := "SELECT CNX_NUMERO, CNX_VLADT,CNX_SALDO "
cQuery += "  FROM "+RetSqlName("CNX")+" CNX "
cQuery += "  WHERE CNX_CONTRA ='"+cContra+ "'"
cQuery += "  AND CNX_SALDO > 0 "
cQuery += "  AND CNX.D_E_L_E_T_=' ' "

cQuery := ChangeQuery( cQuery )
dbUseArea( .T., "TOPCONN", TcGenQry( ,, cQuery ), cAliasQry, .F., .T. )
(cAliasQry)->(DbGoTop())

if !EOF()

    cMsg  := "Atenção: Esse contrato tem Adiantamento(s) e Empresa Logada diferente da Empresa Escolhida para Medição"+chr(10)+chr(13)+chr(10)
    cMsg  += "Para incluir Medição nessa Empresa, favor 'logar' nessa Empresa na tela inicial do Sistema!" 

    if cEmpLogada <> cEmpPosic
       MessageBox(cMsg,"Empresa Indevida",16)
       lRet := .F.
    endif

Endif

RestArea(aArea)

Return lRet
