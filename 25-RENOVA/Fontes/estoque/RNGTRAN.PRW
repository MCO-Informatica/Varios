#INCLUDE "PROTHEUS.CH"

/*
|================================================================|
|Programa.: 	RNGTRAN                									  |
|Autor....:	Alcouto												           |
|Data.....: 14/05/2022										              |
|Descricao: Utilizado p/ gatilhar as entidades projeto e camada  |
|Uso......: 	Renova Energia									           |
|================================================================|
*/

User Function RNGTRAN(cNNTFilDes)

	Local aAreaAnt := getarea()
	local cEmp  := '00'
	local cFil  := ""
	Local cRet  := ""

	cFil:= cEmp+cNNTFilDes

	dbSelectArea("SZ3")
	dbSetOrder(1)//Z3_FILIAL+Z3_EMP+Z3_ITEM
	If SZ3->(DbSeek(xFilial("SZ3")+ cFil))
		IF !empty(cNNTFilDes)
			cRet  := alltrim(SZ3->Z3_ITEM)
			//NNT_XITEMD := cRet
		ENDIF
	endif
	RestArea(aAreaAnt)
RETURN(cRet)
