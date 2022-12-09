#include "protheus.ch"
#include "topconn.ch"

User Function M460MARK()

    Local _lRet 	:= .T.
    Local _cQuery	:= ""
    Local _cAlias 	:= CriaTrab(Nil,.F.)

    If Alltrim(FunName()) $"MATA460A"

        cQuery := "SELECT DISTINCT "
        cQuery += " C9_PEDIDO, C9_X_EMPFA, C9_DF "
        cQuery += " FROM "
        cQuery += " SC9010 "
        cQuery += " WHERE "
        cQuery += " C9_FILIAL = '' "
        cQuery += " AND D_E_L_E_T_ = '' "
        cQuery += " AND C9_NFISCAL = '' "
        cQuery += " AND C9_SERIENF = '' "
        If MV_PAR19 == 1
            cQuery += " AND C9_DF = 'S' "
        Else
            cQuery += " AND C9_DF = 'N' "
        EndIf
        cQuery += " AND C9_X_EMPFA = '"+cFilAnt+"' "
        cQuery += " AND C9_OK = '"+PARAMIXB[1]+"' "

        TCQuery cQuery NEW ALIAS (_cAlias)

        (_cAlias)->(dbGoTop())

        While !(_cAlias)->(Eof())

            If (_cAlias)->C9_X_EMPFA <> cFilAnt
                MsgStop("Pedido "+(_cAlias)->C9_PEDIDO+" não pode ser faturado nesta empresa. Favor verificar.","Empresa Faturamento")
                _lRet := .F.
            EndIf


            (_cAlias)->(dbSkip())

        EndDo

    EndIf

    (_cAlias)->(dbCloseArea())

Return(_lRet)
