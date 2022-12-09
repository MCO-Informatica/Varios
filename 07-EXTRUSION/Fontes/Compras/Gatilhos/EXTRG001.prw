#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} xRelat
@EXTRUSION
Gatilho - Numeração Automática Pedido de Compra
@author Rickson Oliveira
@since 29/09/2019
/*/

User Function EXTRG001()

	//Local cNumped := SUBSTR(cFilant, -1, 1)
	Local cCod := ""
	Local aSaveArea := GetArea()
	Local cRet := ""
	Local cQuery := ""

	If cFilant = '0101'
		cCod :="E"
	EndIf
	If cFilant = '0102'
		cCod :="J"
	EndIf
	If cFilant = '0103'
		cCod :="H"
	EndIf
	If cFilant = '0104'
		cCod := "U"
	EndIf

	cQuery  :=  "      Select ISNULL(Max(C7_NUM), ' ')  AS NUM  FROM SC7010 "
	cQuery  +=  "      WHERE D_E_L_E_T_ = ' '                               "
	cQuery  +=  "      AND SUBSTRING(C7_NUM,1,1) = '"+cCod+"'            "

	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TNUM", .F., .T.)
	dbSelectArea( "TNUM" )
	iF Empty(NUM)
		cRet := cCod + "00001" 
	Else
		cNum := Soma1(substr(num,2,6))
		cRet := cCod + cNum 
	EndIf

	DbCloseArea()

	RestArea(aSaveArea)

Return(cRet)   







