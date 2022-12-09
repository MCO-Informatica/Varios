#include "rwmake.ch"
//
// Programa		MT103FIM
// Autor		Carlos Nemesio Puerta
// Data			02/02/2018
// Descricao    Ponto de entrada para permiir ou não a exclusao da Nota Fiscal de Entrada.
// Uso          Ponto de entrada na NFE.
// 				Especifico LINCIPLAS
// TDN			http://tdn.totvs.com/pages/releaseview.action?pageId=6085406
//
//
//     NAO VAI SERVIR. ESTA DEPOIS DA EXCLUSAO, PRECISO DE UM PONTO PARA PERMITIR OU NAO A EXCLUSAO, ANTES DE EXCLUIR.
//
//
/*/
User Function MT103FIM()
Local _aArea   := GetArea()
Local _cDoc    := SF1->F1_DOC
Local _cSerie  := SF1->F1_SERIE
Local _cFornec := SF1->F1_FORNECE
Local _cLojFor := SF1->F1_LOJA
Local _nOpcao  := PARAMIXB[1]              // Opção Escolhida pelo usuario no aRotina (5 = Excluir)
Local _nOk     := PARAMIXB[2]              // Se o usuario confirmou a operação de gravação da NFE (Se confirmou = 1, se cancelou = 0)
Local _nX      := 0

If _nOpcao == 5
	If _nOk == 1
		dbSelectArea("SD1")
		_aAreaD1 := GetArea()
		dbSetOrder(1)                      // D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM
		dbSeek(xFilial("SD1")+_cDoc+_cSerie+_cFornec+_cLojFor,.T.)
		Do While !Eof() .And. xFilial("SD1") == SD1->D1_FILIAL .And. _cDoc+_cSerie+_cFornec+_cLojFor == SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA
	        dbSelectArea("SZC")
		    dbSetOrder(1)          // ZC_FILIAL+ZC_SERNFE+ZC_DOCNFE+ZC_FORNFE+ZC_LOJANFE+ZC_ITEMNFE
		    If dbSeek(xFilial("SZC")+SD1->D1_SERIE+SD1->D1_DOC+SD1->D1_FORNECE+SD1->D1_LOJA+SD1->D1_ITEM)
	            If SZC->ZC_STATUS <> "01"
                    
*************************
*************************




			dbSelectArea("SD1")
			dbSkip()
		EndDo
		RestArea(_aAreaD1)
	EndIf
EndIf

RestArea(_aArea)
Return
/*/