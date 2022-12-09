#Include 'Protheus.ch'
/* Preparar as tranferencias em array para mandar para a funÁ„o renp100 */
User Function renp090(aTrans,cMens)

	Local lRet := .t.
	Local aLinha := {}
	Local aAuto := {}
	Local nP := 0

	Local cMaterial := ""
	Local nQtdTrf := 0
	Local cLocOri := ""
	Local cEndOri := ""
	Local cLocDes := ""
	Local cEndDes := ""

	sb1->(dbSetOrder(1))

	//atrans - filial,Material,qtd tranferencia,LocOri,EndOri,LocDes,EndDes

	aadd(aAuto,{"",dDataBase}) //Cabecalho

	for nP := 1 to len(atrans)

		cMaterial := atrans[nP,1]
		nQtdTrf := atrans[nP,2]
		cLocOri := atrans[nP,3]
		cEndOri := atrans[nP,4]
		cLocDes := atrans[nP,5]
		cEndDes := atrans[nP,6]

		sb1->(DbSeek(xFilial()+cMaterial))

        aLinha := {}

		aadd(aLinha,{"ITEM",'00'+cvaltochar(nP),Nil})
		//Origem
		aadd(aLinha,{"D3_COD", sb1->b1_cod, Nil}) //Cod Produto origem
		aadd(aLinha,{"D3_DESCRI", sb1->b1_desc, Nil}) //descr produto origem
		aadd(aLinha,{"D3_UM", sb1->b1_um, Nil}) //unidade medida origem
		aadd(aLinha,{"D3_LOCAL", cLocOri, Nil}) //armazem origem
		aadd(aLinha,{"D3_LOCALIZ", cEndOri,Nil}) //Informar endere√ßo origem
		//Destino
		aadd(aLinha,{"D3_COD", sb1->b1_cod, Nil}) //cod produto destino
		aadd(aLinha,{"D3_DESCRI", sb1->b1_desc, Nil}) //descr produto destino
		aadd(aLinha,{"D3_UM", sb1->b1_um, Nil}) //unidade medida destino
		aadd(aLinha,{"D3_LOCAL", cLocDes, Nil}) //armazem destino
		aadd(aLinha,{"D3_LOCALIZ", cEndDes,Nil}) //Informar endere√ßo destino

		aadd(aLinha,{"D3_NUMSERI", "", Nil}) //Numero serie
		aadd(aLinha,{"D3_LOTECTL", "", Nil}) //Lote Origem
		aadd(aLinha,{"D3_NUMLOTE", "", Nil}) //sublote origem
		aadd(aLinha,{"D3_DTVALID", '', Nil}) //data validade
		aadd(aLinha,{"D3_POTENCI", 0, Nil}) // Potencia
		aadd(aLinha,{"D3_QUANT", nqtdTrf, Nil}) //Quantidade
		aadd(aLinha,{"D3_QTSEGUM", 0, Nil}) //Seg unidade medida
		aadd(aLinha,{"D3_ESTORNO", "", Nil}) //Estorno
		aadd(aLinha,{"D3_NUMSEQ", "", Nil}) // Numero sequencia D3_NUMSEQ

		aadd(aLinha,{"D3_LOTECTL", "", Nil}) //Lote destino
		aadd(aLinha,{"D3_NUMLOTE", "", Nil}) //sublote destino
		aadd(aLinha,{"D3_DTVALID", '', Nil}) //validade lote destino
		aadd(aLinha,{"D3_ITEMGRD", "", Nil}) //Item Grade
		//aadd(aLinha,{"D3_CODLAN", "", Nil}) //cat83 prod origem
		//aadd(aLinha,{"D3_CODLAN", "", Nil}) //cat83 prod destino
		aAdd(aAuto,aLinha)
	next

	lRet := u_renp100(aAuto,3,@cMens)	//3 - Inclusao

return lRet
