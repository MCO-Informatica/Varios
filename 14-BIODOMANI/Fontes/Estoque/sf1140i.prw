
/*/{Protheus.doc} SF1140I
@description Ao Adicionar uma Pre Documento de Entrada o vai chamar o Relatorio MTR170
e Imprimir o Boletim de Entrada
@type User function
@version 1.0 
@build 12.1.33
@author Anderson Martins
@since 8/2/2022
@return Return
@see https://tdn.totvs.com/pages/releaseview.action?pageId=6085617
/*/


User Function SF1140I()
	Local lInclui   := PARAMIXB[1]
	Local lAltera   := PARAMIXB[2]
	Local _aResult  := {}
	Local aAreaSD1  := SD1->(GetArea())
	Local nIdNotaG  := 0
	Local cPerg     := "MTR170    "
    Local aAreaX1   := {}
	Private cMsg    := ""

	IF Alltrim(SF1->F1_ESPECIE) != " "

					aAreaX1 := sx1->(getarea())
					SX1->(DbsetOrder(1))
					SX1->(Dbseek(cPerg+"01"))
					SX1->(Reclock("SX1",.F.))
					SX1->X1_CNT01:=DTOS(SF1->F1_DTDIGIT)
					SX1->(MsUnlock())
					SX1->(Dbseek(cPerg+"02"))
					SX1->(Reclock("SX1",.F.))
					SX1->X1_CNT01:=DTOS(SF1->F1_DTDIGIT)
					SX1->(MsUnlock())
					SX1->(Dbseek(cPerg+"03"))
					SX1->(Reclock("SX1",.F.))
					SX1->X1_CNT01:=SF1->F1_DOC
					SX1->(MsUnlock())
					SX1->(Dbseek(cPerg+"04"))
					SX1->(Reclock("SX1",.F.))
					SX1->X1_CNT01:=SF1->F1_DOC
					SX1->(MsUnlock())
					Pergunte(cPerg,.F.)				
					
					u_docgrf(SF1->F1_DOC,SF1->F1_SERIE,SF1->F1_FORNECE,SF1->F1_LOJA)
					
					Restarea(aAreaX1)
				ENDIF
RETURN
