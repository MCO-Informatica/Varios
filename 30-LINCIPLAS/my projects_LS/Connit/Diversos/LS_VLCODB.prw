#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'TOPCONN.ch'
#INCLUDE 'RWMAKE.ch'

//���������������������������������������������������������������������������������������������������������t�
//�Fun��o para valida��o de c�digo de barras (N�mero) j� cadastrado. Por Rodrigo Alexandre. 02/12/2012�
//���������������������������������������������������������������������������������������������������������t�

User Function LS_VLCODB()

Local _aArea := GetArea()
Local _lRet  := .t. , _cQuery

_cQuery := " SELECT B1_CODBAR, B1_COD, B1_DESC "
_cQuery += " FROM " + RetSqlName("SB1") + " SB1 WITH(NOLOCK) " 
_cQuery += " WHERE ISNUMERIC(B1_CODBAR) = 1" 
_cQuery += " AND B1_CODBAR <> '' " 
_cQuery += " AND convert(NUMERIC(20,0),B1_CODBAR) = convert(NUMERIC(20,0),'" + AllTrim(M->B1_CODBAR) + "')"
_cQuery += " AND D_E_L_E_T_ = ''"

DbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), 'TMP', .F., .T.)
	
If !Empty(TMP->B1_CODBAR)
	MsgBox("C�digo de barras j� cadastrado para o produto " + alltrim(TMP->B1_COD) + " - " + alltrim(TMP->B1_DESC) + ".","C�d Duplicado!!!","ALERT")
	_lRet := .f.
EndIf        

DbCloseArea()       

RestArea(_aArea)
	
Return(_lRet)