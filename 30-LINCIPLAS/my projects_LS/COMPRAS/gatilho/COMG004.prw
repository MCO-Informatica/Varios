#Include "Protheus.ch"

/*
+=========================================================+
|Programa: COMG004 |Autor: Vanilson Souza |Data: 09/12/10 |
+=========================================================+
|Descrição: Gatilho responsavel pelo preenchimento do TES |
|a ser utilizado na operação de pedido de compra entre    |
|empresas Laselva (laselva, coligadas e fornecedores).    |
|Utilizado no campo C7_PRODUTO. atualiza TES e CFOP       |
+=========================================================+
|Uso: Especifico: Laselva                                 |
+=========================================================+
*/

User Function COMG004()

Local nPosCod  := ""
Local nPosTes  := ""
Local cTipoEmp := ""
Local nPosCf   := ""
Local _cRet    := ''
cEstado := SA2->A2_EST

If FunName() $ 'MATA120/MATA121' .and. right(cCondicao,1) == 'X'  // se for papel de pao
	
	nPosCod	:= aScan(aHeader,{|x| AllTrim(x[2])=="C7_PRODUTO"})
	nPosTes	:= aScan(aHeader,{|x| AllTrim(x[2])=="C7_TES"})
	cTes	:= GetMv('LS_PPECONS')   // PAPEL DE PAO, ENTRADA DE CONSIGNAÇÃO - 415
	_cRet 	:= cTes           
	aCols[n,nPosTes] := cTes

Else
	If SA2->A2_LOJA $ "01/55"
		cTipoEmp := "M"
	ElseIf left(SM0->M0_CGC,8) == left(SA2->A2_CGC,8)
		cTipoEmp := "F"
	Else
		cTipoEmp := "C"
	EndIf
	
	If FunName() = "MATA103"
		nPosCod	:= aScan(aHeader,{|x| AllTrim(x[2])=="D1_COD"})
		nPosTes	:= aScan(aHeader,{|x| AllTrim(x[2])=="D1_TES"})
		nPosCf	:= aScan(aHeader,{|x| AllTrim(x[2])=="D1_CF"})
	Else
		nPosCod	:= aScan(aHeader,{|x| AllTrim(x[2])=="C7_PRODUTO"})
		nPosTes	:= aScan(aHeader,{|x| AllTrim(x[2])=="C7_TES"})
	EndIf
	
	If AllTrim(SM0->M0_CODFIL) $ "01/55"
		cTipoEmp := "M"
	ElseIf Substr(SM0->M0_CGC,1,8) $ GetMv("MV_LSVCNPJ")
		cTipoEmp := "F"
	Else
		cTipoEmp := "C"
	EndIf
	
	If Substr(SA2->A2_CGC,1,8) $ GetMv("MV_LSVCNPJ") .or. left(SM0->M0_CGC,8) == left(SA2->A2_CGC,8)
		cTes	:= Posicione("SBZ",1,SM0->M0_CODFIL+aCols[n,nPosCod],"BZ_TE")
		cCf		:= Posicione("SF4",1,xFilial("SF4")+cTes,"F4_CF")
	ElseIf Substr(SA2->A2_CGC,1,8) $ GetMv("MV_CNPJLSV") .AND. cTipoEmp = "M"
		cTes	:= Posicione("SBZ",1,SM0->M0_CODFIL+aCols[n,nPosCod],"BZ_TEC")
		cCf		:= Posicione("SF4",1,xFilial("SF4")+cTes,"F4_CF")
	Else
		cTes	:= Posicione("SBZ",1,SM0->M0_CODFIL+aCols[n,nPosCod],"BZ_TE_FORN")
		cCf		:= Posicione("SF4",1,xFilial("SF4")+cTes,"F4_CF")
	EndIf
	
	If SM0->M0_ESTENT <> cEstado .AND. !Empty(cTes)
		cCf := "2"+Substr(cCf,2,3)
	EndIf
	
	If FunName() == "MATA103"
		If l103Class .And. !Empty(SD1->D1_PEDIDO) .And. !Empty(SD1->D1_TES)
			cTes := SD1->D1_TES
		EndIf
	EndIf
	
	If FunName() = "MATA103"
		aCols[n,nPosTes] := cTes
		aCols[n,nPosCf]	 := cCf
	ElseIf FunName() $ "MATA120/MATA121"
		aCols[n,nPosTes] := cTes
	EndIf
	_cRet := aCols[n,nPosTes]
EndIf     

GdFieldPut('C7_TES',_cRet,n)

Return(_cRet)
