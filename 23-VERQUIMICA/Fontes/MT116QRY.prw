#Include "Protheus.Ch"
#Include "Totvs.Ch"

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+---------------------+-------------------------------+------------------+||
||| Programa: MT116QRY  | Autor: Celso Ferrone Martins  | Data: 24/03/2015 |||
||+-----------+---------+-------------------------------+------------------+||
||| Descricao | PE para filtar NFs para as notas de conhecimento de frete  |||
||+-----------+------------------------------------------------------------+||
||| Alteracao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Uso       |                                                            |||
||+-----------+------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==============================================================================
*/
/*

	aParametros:= {	
	nCombo1      ,; // 01 Define a Rotina : 1-Inclusao / 2-Exclusao
	nCombo2      ,; // 02 Considerar Notas : 1 - Compra , 2 - Devolucao
	d116DataDe   ,; // 03 Data Inicial para Filtro das NF Originais
	d116DataAte  ,;	// 04 Data Final para Filtro das NF originais
	c116FornOri  ,;	// 05 Cod. Fornecedor para Filtro das NF Originais
	c116LojaOri  ,;	// 06 Loja Fornecedor para Fltro das NF Originais
	nCombo3      ,; // 07 Utiliza Formulario proprio ? 1-Sim,2-Nao
	c116NumNF    ,; // 08 Num. da NF de Conhecimento de Frete
	c116SerNF    ,; // 09 Serie da NF de COnhecimento de Frete
	c116Fornece  ,;	// 10 Codigo do Fornecedor da NF de FRETE
	c116Loja     ,; // 11 Loja do Fornecedor da NF de Frete
	c116Tes      ,; // 12 Tes utilizada na Classificacao da NF
	n116Valor    ,; // 13 Valor total do Frete sem Impostos
	c116UFOri    ,; // 14 Estado de Origem do Frete
	(nCombo4==1) ,; // 15 Aglutina Produtos : .T. , .F.
	n116BsIcmRet ,;	// 16 Base do Icms Retido
	n116VlrIcmRet,;	// 17 Valor do Icms Retido
	(nCombo5==2) ,; // 18 Filtra nota com conhecimento frete .F. , .T.
	c116Especie  ,; // 19 Especie da Nota Fiscal
	}
*/
User Function MT116QRY()

Local cRet       := ""
/*
Local aAreaSa1   := SA1->(GetArea())
Local aAreaSa4   := SA4->(GetArea())

Local cCodCliCte := aParametros[10]
Local cLojCliCte := aParametros[11]
Local cCgcCliCte := ""

Local cCodSa4    := ""

DbSelectArea("SA1") ; DbSetOrder(1)
DbSelectArea("SA4") ; DbSetOrder(1)

If DbSeek(xFilial("SA1")+cCodCliCte+cLojCliCte)

	cCgcCliCte := SA1->A1_CGC

	cQuery := ""
	cQuery += " SELECT * FROM " + RetSqlName("SA4") + " SA4 "
	cQuery += " WHERE "
	cQuery += "    SA4.D_E_L_E_T_ <> '*' "
	cQuery += "    AND A4_FILIAL = '"+xFilial("SA4")+"' "
	cQuery += "    AND SUBSTR(A4_CGC,1,8) = '"+SubStr(cCgcCliCte,1,8)+"' "
	
	If Select("TMPCTE") > 0
		TMPCTE->(DbCloseArea())
	EndIf
	
	TcQuery cQuery New Alias "TMPCTE"
	
	While !TMPCTE->(Eof())
		cCodSa4 += TMPCTE->A4_COD+"/" 
		TMPCTE->(DbSkip())
	EndIf
	
	If !Empty(cCodSa4)
		cRet := " .AND. (EMPTY(F1_TRANSP) .OR. F1_TRANSP $ '"+cCodSa4+"' )"
	EndIf
EndIf

SA1->(RestArea(aAreaSa1))
SA4->(RestArea(aAreaSa4))
*/
Return(cRet)