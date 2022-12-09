#INCLUDE "PROTHEUS.CH"

/*
|================================================================|
|Programa.: 	RNGTRANOR   								|
|Autor....:	Alcouto									|
|Data.....: 14/05/2022									|
|Descricao: Utilizado p/ gatilhar as entidades projeto e camada  |
|Uso......: 	Renova Energia								|
|================================================================|
*/

User Function RNGTRANOR(cCampo,cNNTProd)

	Local aArea := GetArea()
	local cEmp  := '00'
	local cFil  := ""
	Local cRet  := ""
	Local cDiam := '1330001'
	Default cCampo := ""

	cCampo := AllTrim(cCampo)
	if !cCampo $ "NNT_XITEMC;NNT_XCLVC;NNT_XCCC;NNT_XCTAC;NNT_XEC0CR;NNT_XCCC"
		return(cRet)
	endif

	cFil:= cEmp+cDiam

	dbSelectArea("SZ3")
	dbSetOrder(1)//Z3_FILIAL+Z3_EMP+Z3_ITEM
	If SZ3->(DbSeek(xFilial("SZ3")+ cFil))
		IF !EMPTY(cNNTProd)
			IF cDiam = cFilAnt
				do case
				case cCampo = "NNT_XITEMC"
					cRet  := alltrim(SZ3->Z3_ITEM)

				case cCampo = "NNT_XCLVC"
					cRet := Substr(SZ3->Z3_ITEM,1,2)

				case cCampo = "NNT_XCCC"
					cRet := '34100'

				case cCampo = "NNT_XCTAC"
					cRet := '1107204010101'

				case cCampo = "NNT_XEC0CR"
					cRet := '02380010001'
				endcase
			endif
		ENDIF
	ENDIF
	RestArea(aArea)

Return(cRet)

