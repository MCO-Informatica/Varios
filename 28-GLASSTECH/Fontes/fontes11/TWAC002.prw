#Include "Protheus.ch"
#Include "TopConn.ch"

/**
* Metodo : New()
* Descric:
* Param  : Nenhum
* Retorno: Nil
*/
Class TWAC002

	Data nOpc 				as Numeric

	Data cPvDe 			as String
	Data cPvAte 			as String
	Data cEmpDest 		as String
	Data cFilDest 		as String
	Data cArqSc2			as String
	Data cProcessEmp		as String
	Data cProcessFil		as String
	Data cPedido			as String
	Data cEmpOri			as String
	Data cFilOri			as String
	Data cNota				as String
	Data cSerie			as String
	Data cNFOrigem		as String
	Data cNFDestino		as String
	Data cDocSerori		as String
	Data cEof 				as String
	Data cNivel			as String
	Data cNfsNfe			as String
	Data cAux				as String
	Data cTesEnt			as String
	Data cTesDv			as String
	Data cSerOri			as String
	Data cDoc			as String
	Data aAliasPreserv 	as Array
	Data aPvSel			as Array
	Data aDataCabec		as Array
	Data aDataItem		as Array
	Data aArrayPre		as Array
	Data aArrayNfe		as Array
	Data aArrayPv			as Array
	Data aArrayNfeBn		as Array
	Data aArrayPvBn		as Array
	Data aEmpFilBn		as Array

	Data lFatura			as Logical
	Data lNfeBn			as Logical

	Data oFont16 			as Object

	&&Construtor
	Method New() Constructor

	&&Methods Comuns entre as Classes
	Method reOpenDictionary()
	Method changeEmpFil()
	Method retNumNota()
	Method GerPreNota()
	Method prepAuto(oObj,aCampos)
	Method verificaPV(cPedido)
	Method retVerNf()
	Method GerNFE()
	Method retEfCli()
	Method retNivel()
	Method retArrayPre()
	Method retANfe()
	Method retArrayNfeBn()
	Method retArrayPvBn()
	Method retAPv()
	Method retDadosNf()
	Method ExcluiPend()
	Method retArrayFormatado()
	Method RotExcluir()
	Method RetArrayExcluir()
	Method TrocaProd(cProd)
	Method setTesBn()
	Method retCgcDestino()
	Method retIdentD1()
	Method VerificaBenefic()
	Method retTipoNfe(cPedido)
	Method retSB6()

	&& Methods ROTINAS
	Method TWM001()
	Method TWM002()
	Method TWM003()
	Method TWM004()
	Method TWM005()

	&&Methods Auxiliares do TWM001
	Method PRTWM001()
	Method FatNfTW001()

	&&Metodos Auxiliares do TWM002
	Method PRTWM002()

	&&Metodos Auxiliares do TWM003
	Method PRTWM003()

	&&Methods Auxiliares do METHOD TWM005
	Method PRTWM005()
	Method PesqTWM05()
	Method GerPvTWM05()
	Method GrvNFTWM05()
	Method retArrayTw5()
EndClass

/**
* Metodo : New()
* Descric: Metodo Construtor. Instancia a classe TWAC002()
* Param  : Nenhum
* Retorno: Nil
*/
Method New() Class TWAC002
	::nOpc				:= 0
	::oFont16 			:= TFont():New("Ternimal",09,016,.T.,.F.,05,.T.,05,.T.,.F.)
	::cPvDe 			:= SPACE(6)
	::cPvAte 			:= SPACE(6)
	::cProcessEmp		:= ""
	::cProcessFil		:= ""
	::cPedido			:= ""
	::cEmpOri			:= ""
	::cFilOri			:= ""
	::cSerie			:= ""
	::cNota			:= ""
	::cNFOrigem		:= ""
	::cNFDestino		:= ""
	::cDocSerori		:= ""
	::cNivel			:= ""
	::cNfsNfe			:= ""
	::cAux				:= ""
	::cTesEnt			:= ""
	::cTesDv			:= ""
	::cSerOri			:= ""
	::cDoc				:= ""
	::cEof				:= CHR(13)+CHR(10)
	::cEmpDest 		:= SPACE(2)
	::cFilDest 		:= SPACE(2)
	::aAliasPreserv	:= {}
	::aPvSel			:= {}
	::aDataCabec		:= {}
	::aDataItem		:= {}
	::aArrayPre		:= {}
	::aArrayNfe		:= {}
	::aArrayPv			:= {}
	::aArrayNfeBn		:= {}
	::aArrayPvBn		:= {}
	::aEmpFilBn		:= {}

	::lFatura			:= .F.
	::lNfeBn			:= .F.

	Return

/**
* Metodo : TWM001()
* Descric:
* Param  : Nenhum
* Retorno: Nil
*/
Method TWM001(cEmpDest,cFilDest) Class TWAC002
	Local lRet			:= .F.

	lRet := ::PRTWM001(cEmpDest,cFilDest)

	Return(lRet)

/**
* Metodo : PRTWM001()
* Descric:
* Param  : Nenhum
* Retorno: Nil
*/
Method PRTWM001(cEmpDest,cFilDest) Class TWAC002
	Local aTmp			:= {}
	Local aData		:= {}
	Local aM140c 		:= {}
	Local aM140i		:= {}
	Local lRet			:= .T.
	Local lContinua	:= .T.
	Local lNfGerada	:= .F.
	Local cDadosNf	:= ""
	Local nPre			:= 0

	cDadosNf := Alltrim(SF2->F2_ZZFAT)
	::cDocSerori 	:= SF2->F2_DOC+SF2->F2_SERIE
	::cEmpOri 		:= cEmpAnt
	::cFilOri 		:= cFilAnt

	aDadosNf := ::retDadosNf(cDadosNf)

	If Len(aDadosNf) > 0
		nPre		:= Ascan(aDadosNf,{|x| AllTrim(Upper(x[1])) == "PRE"})
	EndIf

	If !Empty(cDadosNf) .and. nPre > 0
		lContinua := .T.
		::cNfsNfe := cDadosNf
	Else
		::cNfsNfe += "TP:1/"
		::cNfsNfe += "EMP.FIL:"+cFilDest+"/"

		&&Armazena os dados da NF de Saida, para ser usado para gerar uma Pré Nota.
		aDataCabec	:= {}
		aDataItem	:= {}

		&&Seta qual empresa que irá ser faturado a NOTA.
		::cProcessEmp	:= cEmpDest
		::cProcessFil	:= cFilDest
		::changeEmpFil()

		&&Executa a rotina automatica para gerar a Pre-Nota
		If lContinua

			For nX := 1 to Len(::aArrayPre)

				if nX == 1
					::cNfsNfe += "PRE:"
				EndIf

				::aDataCabec	:= {}
				::aDataItem	:= {}
				::aDataCabec := aClone(::aArrayPre[nX][1])
				::aDataItem  := aClone(::aArrayPre[nX][2])
				lContinua := ::GerPreNota()

				if lContinua
					::cNfsNfe += SF1->F1_DOC+SF1->F1_SERIE+"-"
				EndIf

			Next nX

		EndIf
		::cProcessEmp	:= ::cEmpOri
		::cProcessFil	:= ::cFilOri
		::changeEmpFil()

	EndIf

	if lContinua
		cQuery := "UPDATE "+RetSqlName("SF2")+" SET "
		cQuery += "  F2_ZZFAT = '"+::cNfsNfe+"'"
		cQuery += " WHERE F2_DOC+F2_SERIE = '"+::cDocSerori+"'"
		cQuery += "  AND  F2_FILIAL = '"+::cFilOri+"'"

		If (TCSQLExec(cQuery) < 0)
			MsgStop("TCSQLError() " + TCSQLError())
		Endif
	EndIf

	&& Reseta as Variaveis.
	::cPedido 		:= ""
	::cProcessEmp	:= ""
	::cProcessFil	:= ""
	::cEmpOri		:= ""
	::cFilOri		:= ""

	Return(lRet)

/***********************************************************************************************************
Rotinas relacionados a rotina TWM002.
************************************************************************************************************/
/**
* Metodo : TWM002()
* Descric:
* Param  : Nenhum
* Retorno: Nil
*/
Method TWM002(cEmpDest,cFilDest) Class TWAC002
	Local lRet			:= .F.

	lRet := ::PRTWM002(cEmpDest,cFilDest)

	Return(lRet)

/**
* Metodo : TWM005()
* Descric:
* Param  : Nenhum
* Retorno: Nil
*/
Method PRTWM002(cEmpDest,cFilDest) Class TWAC002
	Local aTmp			:= {}
	Local aData		:= {}
	Local aM140c 		:= {}
	Local aM140i		:= {}
	Local lRet			:= .T.
	Local lContinua	:= .T.
	Local lNfGerada	:= .F.
	Local cDadosNf	:= ""
	Local nNfe			:= 0
	Local nPv			:= 0
	Local aNumIdenB6  := {}
	
	cDadosNf := Alltrim(SF2->F2_ZZFAT)
	::cDocSerori 	:= SF2->F2_DOC+SF2->F2_SERIE
	::cEmpOri 		:= cEmpAnt
	::cFilOri 		:= cFilAnt

	aDadosNf := ::retDadosNf(cDadosNf)

	If Len(aDadosNf) > 0
		nNfe	:= Ascan(aDadosNf,{|x| AllTrim(Upper(x[1])) == "NFE"})
		nPv		:= Ascan(aDadosNf,{|x| AllTrim(Upper(x[1])) == "PV"})
	EndIf

	If !Empty(cDadosNf) .and. nNfe > 0 .and. nPv > 0
		lContinua := .F.
		::cNfsNfe := cDadosNf
	Else
		If Empty(cDadosNf)
			::cNfsNfe += "TP:2/"
			::cNfsNfe += "EMP.FIL:"+cFilDest+"/"
		Else
			::cNfsNfe := cDadosNf
		EndIf

		&&Armazena os dados da NF de Saida, para ser usado para gerar uma Pré Nota.
		aDataCabec	:= {}
		aDataItem	:= {}

		&&Seta qual empresa que irá ser faturado a NOTA.
		::cProcessEmp	:= cEmpDest
		::cProcessFil	:= cFilDest
		::changeEmpFil()

		&&Executa a rotina automatica para gerar a Pre-Nota
		If lContinua

			if nNfe == 0
				For nX := 1 to Len(::aArrayNfeBn)

					if nX == 1
						::cNfsNfe += "NFE:"
					EndIf

					::aDataCabec := ::aArrayNfeBn[nX][1]
					::aDataItem  := ::aArrayNfeBn[nX][2]
					lContinua := ::GerNFE()

					if lContinua
						::cNfsNfe += SF1->F1_DOC+SF1->F1_SERIE+"-"
					EndIf
					lDocEnt := lContinua
				Next nX
			Else
				lDocEnt := .f.
			EndIf

			&&Gera Pedido de venda de beneficiamento na empresa destino.
			If nPv == 0
				lContinua := .T.
				if lContinua
					cAux1 		:= ""
					cAux2 		:= ""
					aData		:= ::aArrayNfeBn[1][1]
					cDoc   	:= aData[Ascan(aData,{|x| AllTrim(Upper(x[1])) == "F1_DOC"})][2]
					cSerie 	:= aData[Ascan(aData,{|x| AllTrim(Upper(x[1])) == "F1_SERIE"})][2]

					For nX := 1 to Len(::aArrayPvBn)

						if nX == 1
							::cNfsNfe += "/PV:"
						EndIf

						::aDataCabec 	:= ::aArrayPvBn[nX][1]
						::aDataItem  	:= ::aArrayPvBn[nX][2]

						&&Grava o CAMPO C6_IDENTB6, para conseguir fazer o PV de Beneficiamento.
						For nN := 1 to Len(::aDataItem)
							aData 		:= ::aDataItem[nN]
							cItem		:= ::aDataItem[nN][Ascan(aData,{|x| AllTrim(Upper(x[1])) == "C6_ITEM"})][2]
							nIdentB6	:= Ascan(aData,{|x| AllTrim(Upper(x[1])) == "C6_IDENTB6"})
							nItemOri	:= Ascan(aData,{|x| AllTrim(Upper(x[1])) == "C6_ITEMORI"})

							CNumIdenB6	:= ::retIdentD1(cDoc,cSerie,cItem,cFilDest)
							
							If !Empty(cNumIdenB6)
								::aDataItem[nN][nIdentB6][2] := cNumIdenB6
							EndIf
						Next nN

						&&Troca para o numero de PV correto.
						cAux1 := GetSx8Num("SC5","C5_NUM")
						ConfirmSX8()
						::aDataCabec[1][2] := cAux1
						lContinua := ::GerPvTWM05()

					Next nX

					If !Empty(::cAux)
						::cNfsNfe	+= "/NFS:"+::cAux+"/"
						lDocSaida := lContinua
					Else
						lDocSaida := .F.
					EndIf

				EndIf
			EndIf

		EndIf
		::cProcessEmp	:= ::cEmpOri
		::cProcessFil	:= ::cFilOri
		::changeEmpFil()

/*
&&Gera Nota Fiscal de Entrada na empresa origem.
if lContinua
For nX := 1 to Len(::aArrayNfeBn)

if nX == 1
::cNfsNfe += "NFE:"
EndIf

::aDataCabec := ::aArrayPreBn[nX][1]
::aDataItem  := ::aArrayPreBn[nX][2]
lContinua := ::GerNFE()

if lContinua
::cNfsNfe += SF1->F1_DOC+SF1->F1_SERIE+"-"
EndIf

Next nX
EndIf
*/


		&&Grava as informações no campo de controle.
		if lContinua
			cQuery := "UPDATE "+RetSqlName("SF2")+" SET "
			cQuery += "  F2_ZZFAT = '"+::cNfsNfe+"'"
			cQuery += " WHERE F2_DOC+F2_SERIE = '"+::cDocSerori+"'"
			cQuery += "  AND  F2_FILIAL = '"+::cFilOri+"'"

			If (TCSQLExec(cQuery) < 0)
				MsgStop("TCSQLError() " + TCSQLError())
			Endif
		EndIf

	EndIf

	&& Reseta as Variaveis.
	::cPedido 		:= ""
	::cProcessEmp	:= ""
	::cProcessFil	:= ""
	::cEmpOri		:= ""
	::cFilOri		:= ""
	Return(lRet)

/***********************************************************************************************************
Rotinas relacionados a rotina TWM003.
************************************************************************************************************/
/**
* Metodo : TWM003()
* Descric:
* Param  : Nenhum
* Retorno: Nil
*/
Method TWM003(cEmpDest,cFilDest) Class TWAC002
	Local cQry 		:= ""
	Local nRecSC2 	:= 0
	Local lRet			:= .F.

	lRet := ::PRTWM003(cEmpDest,cFilDest)

	Return(lRet)

/**
* Metodo : PRTWM003()
* Descric: Faturamento entre empresas.
* Param  : Nenhum
* Retorno: Nil
*/
Method PRTWM003(cEmpDest,cFilDest) Class TWAC002
	Local aTmp			:= {}
	Local aDadosNf	:= {}
	Local lRet			:= .F.
	Local cNfDes		:= ""
	Local lContinua 	:= .T.
	Local cDadosNf	:= ""
	Local nPre			:= 0
	Local nNfe 		:= 0
	Local nPv			:= 0
	Local nNfs			:= 0

	&&Armazena os dados da empresa e filial origem, para fazer a troca de empresa para faturar.
	::cEmpOri 	:= cEmpAnt
	::cFilOri 	:= cFilAnt
	::aPvSel 	:= aTmp
	::cNfsNfe += "TP:3/"
	::cNfsNfe += "EMP.FIL:"+cFilDest+"/"
	::cDocSerori := SF2->F2_DOC+SF2->F2_SERIE
	cDadosNf := Alltrim(SF2->F2_ZZFAT)
	aDadosNf := ::retDadosNf(cDadosNf)

	If Len(aDadosNf) > 0
		nPre		:= Ascan(aDadosNf,{|x| AllTrim(Upper(x[1])) == "PRE"})
		nNfe 		:= Ascan(aDadosNf,{|x| AllTrim(Upper(x[1])) == "NFE"})
		nPv			:= Ascan(aDadosNf,{|x| AllTrim(Upper(x[1])) == "PV"})
		nNfs		:= Ascan(aDadosNf,{|x| AllTrim(Upper(x[1])) == "NFS"})
	EndIf

	&&Seta qual empresa que irá ser faturado a NOTA.
	::cProcessEmp	:= cEmpDest
	::cProcessFil	:= cFilDest
	::changeEmpFil()

	If !Empty(cDadosNf) .and. nPre > 0
		lContinua := .T.
		::cNfsNfe := cDadosNf
	Else
		&&Executa a rotina automatica para gerar Documento de Entrada.
		nX := 0
		For nX := 1 to Len(::aArrayPre)
			if nX == 1
//::cNfsNfe += "NFE:"
				::cNfsNfe += "PRE:"
			EndIf
			::aDataCabec := ::aArrayPre[nX][1]
			::aDataItem  := ::aArrayPre[nX][2]
			&&Gera Documento de Entrada
//lContinua := ::GerNFE()

			&&Gera a Pre nota.
			lContinua := ::GerPreNota()		&&Gera uma Pré Nota

			if lContinua
				::cNfsNfe += SF1->F1_DOC+SF1->F1_SERIE+"-"
			EndIf
		Next nX

	EndIf

	::cProcessEmp	:= ::cEmpOri
	::cProcessFil	:= ::cFilOri
	::changeEmpFil()

	If lContinua
		cQuery := "UPDATE "+RetSqlName("SF2")+" SET "
		cQuery += "  F2_ZZFAT = '"+::cNfsNfe+"'"
		cQuery += " WHERE F2_DOC+F2_SERIE = '"+::cDocSerori+"'"
		cQuery += "  AND  F2_FILIAL = '"+xFilial("SF2")+"'"

		If (TCSQLExec(cQuery) < 0)
			MsgStop("TCSQLError() " + TCSQLError())
		Endif
	EndIf

	Return(lRet)


/***********************************************************************************************************
Rotinas relacionados a rotina TWM005.
************************************************************************************************************/
/**
* Metodo : TWM005()
* Descric:
* Param  : Nenhum
* Retorno: Nil
*/
Method TWM005(cEmpDest,cFilDest) Class TWAC002
	Local cQry 		:= ""
	Local nRecSC2 	:= 0
	Local lRet			:= .F.

	lRet := ::PRTWM005(cEmpDest,cFilDest)

	Return(lRet)

/**
* Metodo : PRTWM005()
* Descric: Pedido de venda em uma empresa e o faturamento em outra empesa.
* Param  : Nenhum
* Retorno: Nil
*/
Method PRTWM005(cEmpDest,cFilDest) Class TWAC002
	Local aTmp			:= {}
	Local aDadosNf	:= {}
	Local lRet			:= .F.
	Local cNfDes		:= ""
	Local lContinua 	:= .T.
	Local cDadosNf	:= ""
	Local nPre			:= 0
	Local nNfe 		:= 0
	Local nPv			:= 0
	Local nNfs			:= 0

	&&Armazena os dados da empresa e filial origem, para fazer a troca de empresa para faturar.
	::cEmpOri 	:= cEmpAnt
	::cFilOri 	:= cFilAnt
	::aPvSel 	:= aTmp
	::cNfsNfe += "TP:5/"
	::cNfsNfe += "EMP.FIL:"+cFilDest+"/"
	::cDocSerori := SF2->F2_DOC+SF2->F2_SERIE
	cDadosNf := Alltrim(SF2->F2_ZZFAT)
	aDadosNf := ::retDadosNf(cDadosNf)

	If Len(aDadosNf) > 0
		nPre		:= Ascan(aDadosNf,{|x| AllTrim(Upper(x[1])) == "PRE"})
		nNfe 		:= Ascan(aDadosNf,{|x| AllTrim(Upper(x[1])) == "NFE"})
		nPv			:= Ascan(aDadosNf,{|x| AllTrim(Upper(x[1])) == "PV"})
		nNfs		:= Ascan(aDadosNf,{|x| AllTrim(Upper(x[1])) == "NFS"})
	EndIf

	&&Seta qual empresa que irá ser faturado a NOTA.
	::cProcessEmp	:= cEmpDest
	::cProcessFil	:= cFilDest
	::changeEmpFil()

	If !Empty(cDadosNf) .and. nNfe > 0
		lContinua := .T.
		::cNfsNfe := cDadosNf
	Else
		&&Executa a rotina automatica para gerar Documento de Entrada.
		nX 		:= 0
		cAux1 	:= ""
		For nX := 1 to Len(::aArrayNfe)
			if nX == 1
				::cNfsNfe += "NFE:"
			EndIf
			::aDataCabec := ::aArrayNfe[nX][1]
			::aDataItem  := ::aArrayNfe[nX][2]

			lContinua := ::GerNFE()

			if lContinua
				::cNfsNfe += SF1->F1_DOC+SF1->F1_SERIE+"-"
			EndIf
		Next nX
		cAux1 := ""

		if lContinua
			cQuery := "UPDATE "+RetSqlName("SF2")+" SET "
			cQuery += "  F2_ZZFAT = '"+::cNfsNfe+"'"
			cQuery += " WHERE F2_DOC+F2_SERIE = '"+::cDocSerori+"'"
			cQuery += "  AND  F2_FILIAL = '"+::cFilOri+"'"

			If (TCSQLExec(cQuery) < 0)
				MsgStop("TCSQLError() " + TCSQLError())
			Endif
		EndIf

	EndIf

	if lContinua

		cAux1 := ""
		cAux2 := ""
		For nX := 1 to Len(::aArrayPv)

			if nX == 1
				::cNfsNfe += "/PV:"
			EndIf

			::aDataCabec := ::aArrayPv[nX][1]
			::aDataItem  := ::aArrayPv[nX][2]

			&&Troca para o numero de PV correto.
			If Empty(cAux1)
				cAux1 := GetSx8Num("SC5","C5_NUM")
				ConfirmSX8()
				::aDataCabec[1][2] := cAux1
			Endif

			lContinua := ::GerPvTWM05()
		Next nX

		If !Empty(::cAux)
			::cNfsNfe	+= "/NFS:"+::cAux+"/"
		EndIf

		if lContinua
			cQuery := "UPDATE "+RetSqlName("SF2")+" SET "
			cQuery += "  F2_ZZFAT = '"+::cNfsNfe+"'"
			cQuery += " WHERE F2_DOC+F2_SERIE = '"+::cDocSerori+"'"
			cQuery += "  AND  F2_FILIAL = '"+::cFilOri+"'"

			If (TCSQLExec(cQuery) < 0)
				MsgStop("TCSQLError() " + TCSQLError())
			Endif
		Else

		EndIf

	EndIf

	::cProcessEmp	:= ::cEmpOri
	::cProcessFil	:= ::cFilOri
	::changeEmpFil()

	Alert(::cNfsNfe)

	If lContinua
		cQuery := "UPDATE "+RetSqlName("SF2")+" SET "
		cQuery += "  F2_ZZFAT = '"+::cNfsNfe+"'"
		cQuery += " WHERE F2_DOC+F2_SERIE = '"+::cDocSerori+"'"
		cQuery += "  AND  F2_FILIAL = '"+xFilial("SF2")+"'"

		If (TCSQLExec(cQuery) < 0)
			MsgStop("TCSQLError() " + TCSQLError())
		Endif


		ZZD->(DbSetOrder(1))
		If ZZD->(dBSeek('0701'+ ::cDoc +'X  '))
			If Reclock('ZZD',.F.)
				ZZD->ZZD_RETORN := ::cNfsNfe
				MsUnlock()
			EndIf
		EndIF
	EndIf

	Return(lRet)

/**
* Metodo : GerPvTWM05()
* Descric: Inclui Pedido de venda
* Param  : Nenhum
* Retorno: Nil
*/
Method GerPvTWM05() Class TWAC002
	Local cNumPed := ""
	Local cQuery	:= ""
	Local aCabPV 	:= {}
	Local aItemPV := {}
	Local cNota	:= ""

	Private lMsErroAuto := .F.
	Private lMsHelpAuto := .T.

	MSExecAuto({|x,y,z|Mata410(x,y,z)},::aDataCabec,::aDataItem,3)

	If lMsErroAuto
		DisarmTransaction()
		MostraErro()
		lRet := .F.
		RollBackSx8()
	Else
		ConfirmSX8()
		lRet := .T.
		::cNfsNfe += SC5->C5_NUM+"-"

		If ::lFatura
			lRet := ::GrvNFTWM05(::aDataCabec[1][2],"","1  ")
		EndIf
	EndIf

	Return(lRet)


/**
* Metodo : InsereNF()
* Descric: GERACAO DA NOTA FISCAL - APOS LIBERAÇÃO DO PEDIDO
* Param  : Nenhum
* Retorno: Nil
*/
Method GrvNFTWM05(cPed, cNota, cSerie) Class TWAC002
	Local aPvlNfs		:= {}
	Local lRet			:= .F.
	Local aSerNf		:= {}
	Public cNotaA  	:= cNota
	Public cSerieA 	:= cSerie


	SC5->(dbSetOrder(1)) //Posicionando o primeiro registro na tabela SC5 -> Cabeçalho do Pedido de Venda.
	SC6->(dbSetOrder(1)) //Posicionando o primeiro registro na tabela SC6 -> Itens do Pedido de Venda.
	SC9->(dbSetOrder(1)) //Posicionando o primeiro registro na tabela SC9 -> Pedidos Liberados.
	SE4->(dbSetOrder(1)) //Posicionando o primeiro registro na tabela SE4 -> Condição de Pagamento.
	SB1->(dbSetOrder(1)) //Posicionando o primeiro registro na tabela SB1 -> Cadastro de Produtos.
	SB2->(dbSetOrder(1)) //Posicionando o primeiro registro na tabela SB2 -> Saldos Físico e Financeiro.
	SF4->(dbSetOrder(1)) //Posicionando o primeiro registro na tabela SF4 -> Tipos de Entrada e Saída.

	SC5->(dbSeek(xFilial("SC5")+cPed))
	SE4->(dbSeek(xFilial("SE4")+SC5->C5_CONDPAG))

	SC9->(dbSeek(xFilial("SC9")+cPed))

	Do While !SC9->(EOF()) .and. SC9->C9_FILIAL == xFilial("SC9") .and. SC9->C9_PEDIDO == cPed
		If !Empty(SC9->C9_NFISCAL) //.or. AllTrim(SC9->C9_BLEST) <> "" .or. AllTrim(SC9->C9_BLCRED) <> ""
			SC9->(dbSkip())
			Loop
		Endif

		SC6->(dbSeek(xFilial("SC6")+SC9->(C9_PEDIDO+C9_ITEM)))
		SB1->(dbSeek(xFilial("SB1")+SC9->C9_PRODUTO))
		SB2->(dbSeek(xFilial("SB2")+SC9->(C9_PRODUTO+C9_LOCAL)))

		Aadd(aPvlNfs, {	SC9->C9_PEDIDO,;	&& 01- No. Pedido
		SC9->C9_ITEM  ,;	&& 02- Item Pedido
		SC9->C9_SEQUEN,;	&& 03- Sequencia Liberação
		SC9->C9_QTDLIB,;	&& 04- Qtde. Liberada
		SC6->C6_PRCVEN,;	&& 05- Preço de Venda
		SC9->C9_PRODUTO,;	&& 06- Cód. do Produto
		.F.,;				&& 07- Valor Lógico
		SC9->(RecNo()),;	&& 08- Posição do Arquivo de Pedidos Liberados
		SC5->(RecNo()),;	&& 09- Posição do Arquivo de Pedidos de Venda
		SC6->(RecNo()),;	&& 10- Posição do Arquivo de Itens dos Pedidos de Venda
		SE4->(RecNo()),;	&& 11- Posição do Arquivo de Condição de Pagamento
		SB1->(RecNo()),;	&& 12- Posição do Arquivo de Produtos
		SB2->(RecNo()),;	&& 13- Posição do Arquivo de Saldo em Estoque
		SF4->(RecNo())})	&& 14- Posição do Arquivo de TES

		SC9->(dbSkip())
	Enddo

	&& Alterado Zabotto
	If ::cNivel $ '46X'
		cSerie:= 'X'
	EndIf

	If Len(aPvlNfs) > 0
		&& Chama Rotina/Função de Inclusão da NF de Saída
		::cDoc := MaPvlNfs(aPvlNfs,cSerie,.F.,.F.,.F.,.T.,.F.,0,0,.T.,.F.)
	EndIf

	If Empty(::cDoc )
		Alert("Erro na Geração da Nota Fiscal de Saida !!!")
		DisarmTransaction()
	EndIf

	If Empty(::cDoc )
		lRet := .F.
	ElseIf !Empty(::cDoc )
		::cAux += SF2->F2_DOC+SF2->F2_SERIE+"-"
		lRet := .T.
	Endif

	&& Função para anular as variáveis criadas na NF Saída
//MaNfsEnd()

//Após declarar as variáveis como public, temos que passar elas no final da rotina como Nulas
	cNotaA := Nil
	cSeriA := Nil

	Return(lRet)


/***********************************************************************************************************
Rotinas Comuns entre a classe
************************************************************************************************************/

/**
* Metodo : changeEmpFil()
* Descric: Troca a empresa e/ou filial caso necessario
* Param  : Nenhum
* Retorno: Nil
*/
Method changeEmpFil() Class TWAC002
	&& Altera a empresa caso necessario
//If	cEmpAnt != 	::cProcessEmp
	If	SubStr(cFilAnt,1,2) != 	SubStr(::cProcessFil,1,2)
		RollBackSx8()
		cEmpAnt	:=	::cProcessEmp
		cFilAnt	:= 	::cProcessFil
		::reOpenDictionary()
	Endif

	&& Altera a filial caso necessario
	If	SubStr(cFilAnt,3,2) != SubStr(::cProcessFil,3,2)
		cFilAnt	:= ::cProcessFil
	Endif

	Return

/**
* Metodo : reOpenDictionary()
* Descric: Abre os arquivos do dicionario da empresa logada
* Param  : Nenhum
* Retorno: Nil
*/
Method reOpenDictionary() Class TWAC002

	Local nI		:= 0
	Local nMaxArea	:= 0

	aSX8 := {}

	If Empty(::aAliasPreserv)
		dbCloseAll()
	Else
		dbSelectArea(0)
		nMaxArea := Select()
		For nI := 1 to nMaxArea
			Select(nI)
			If aScan( ::aAliasPreserv, Alias() ) == 0
				dbCloseArea()
			Endif
		Next nI
	Endif

	OpenSM0( cEmpAnt + cFilAnt )
	OpenFile( cEmpAnt + cFilAnt )

	Return

/**
* Metodo : reOpenDictionary()
* Descric: Abre os arquivos do dicionario da empresa logada
* Param  : Nenhum
* Retorno: Nil
*/
Method retNumNota() Class TWAC002
	Local cSerie	:= ""
	Local cNota	:= ""
	Local lRet 	:= .f.
	Local aRet		:= {}

	lRet := Sx5NumNota(@::cSerie)

	if lRet

		cQuery := "SELECT * FROM "+RetSqlTab("SX5")+" WHERE X5_TABELA = '01' AND X5_CHAVE = '"+::cSerie+"'"
		dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TrbSX5", .F., .T.)
		DbSelectArea("TrbSX5")

		if !TrbSX5->(Eof())
			::cNota := SubStr(TrbSX5->X5_DESCRI,1,9)
		Else
			::cNota := ""
		EndIf

	EndIf

	Return

/**
* Metodo : FatNfTW001()
* Descric:
* Param  : Nenhum
* Retorno: Nil
*/
Method FatNfTW001() Class TWAC002
	Local lRet 	:= .F.
	Local cPed 	:= ""
	Local cNota 	:= ""
	Local cSerie	:= ""

	::retNumNota()
	cPed	:=	::cPedido
	cSerie	:=	::cSerie
	lRet 	:= 	::GrvNFTWM05(cPed, cNota, cSerie)

	Return(lRet)

/**
* Funcao		:	prepAuto()
* Autor		:	Twinglass
* Data			: 	16/09/10
* Descricao	:	Método auxiliar utilizado para preparar o array para a rotina automática
* Parâmetros	:	oXML2   - Objeto XML
*					cAlias  - Alias da tabela
*					aCampos - Array com os campos a serem tratados
* Retorno		: 	aRet    - Array com os campos tratados para a rotina automática
*/
Method prepAuto(cAlias,aCampos) Class TWAC002

	Local aArea := Lj7GetArea({"SX3"})
	Local oSX3  := SX3Order():New()
	Local aRet  := {}
	Local nI    := 0
	Local nJ    := 0
	Local aTmp  := {}
	Local uVar  := Nil

	For nI := 1 to Len(aCampos)
		SX3->(dbSetOrder(2))
		If SX3->(dbSeek(aCampos[nI,1]))
			&& converte o conteudo do campo de acordo com o tipo de dados
			If SX3->X3_TIPO == "N" .and. ValType(aCampos[nI,2]) <> "N"
				uVar := Val(aCampos[nI,2])
			ElseIf SX3->X3_TIPO == "D" .and. ValType(aCampos[nI,2]) <> "D"
				uVar := CtoD(aCampos[nI,2])
			ElseIf SX3->X3_TIPO == "C"
				uVar := Upper(PadR(aCampos[nI,2],SX3->X3_TAMANHO))
			Else
				uVar := aCampos[nI,2]
			Endif

			aAdd(aRet,{aCampos[nI,1], uVar, Nil})
		Endif
	Next nI

	&& reordena array da rotina automatica de acordo com a ordem do SX3
	aRet := oSX3:Reorder(cAlias,aRet)

	Lj7RestArea(aArea)

	Return(aRet)

/**
* Metodo : retVerNf()
* Descric: Verifica se a NF informada existe.
* Param  : Nenhum
* Retorno: Nil
*/
Method retVerNf(cTexto) Class TWAC002
	Local lRet		:= .F.
	Local cQuery 	:= ""
	Local cNf		:= ""
	Local cSerie	:= ""
	Local cEmp		:= ""
	Local cFil		:= ""

	cNf		:= SubStr(cTexto,3,9)
	cSerie	:= SubStr(cTexto,12,3)
	cEmp	:= "SF1"+SubStr(cTexto,16,2)+"0"
	cFil	:= SubStr(cTexto,18,2)

/*
1-NNNNNNNNNSSS/EEFF
*/

	cQuery := "SELECT COUNT(*) AS NUMERO"
	cQuery += " FROM "+ cEmp +" SF1"
	cQuery += " WHERE SF1.D_E_L_E_T_ = ''"
	cQuery += "  AND   SF1.F1_FILIAL  = '"+ cFil +"'"
	cQuery += "  AND   SF1.F1_DOC	 = '"+ cNf +"'"
	cQuery += "  AND   SF1.F1_SERIE	 = '"+ cSerie +"'"

	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"qTmpNF", .F., .T.)
	DbSelectArea("qTmpNF")

	If qTmpNF->NUMERO == 0
		lRet := .F.
	Else
		lRet := .T.
	EndIf

	qTmpNF->(dbclosearea())
	Return(lRet)


/**
* Method: retEfCli
* Descricao: retorna a empresa/filial a ser faturado do cliente.
*
**/
Method retEfCli(cCliente,cLoja,cTipo) Class TWAC002
	Local aRet := {}

	If Alltrim(cTipo) <> "B"
		cQuery := "SELECT SA1.A1_ZZEMP,SA1.A1_ZZFIL"
		cQuery += " FROM "+RetSqlTab("SA1")+ " "
		cQuery += " WHERE SA1.D_E_L_E_T_ = ''"
		cQuery += " AND SA1.A1_COD = '"+cCliente+"'"
		cQuery += " AND SA1.A1_LOJA = '"+cLoja+"'"
		cQuery += " AND SA1.A1_FILIAL = '"+xFilial("SA1")+"'"

		dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"qTmpSA1", .F., .T.)
		DbSelectArea("qTmpSA1")

		If !qTmpSA1->(Eof())
			aAdd(aRet, qTmpSA1->A1_ZZEMP)
			aAdd(aRet, qTmpSA1->A1_ZZFIL)
		EndIf
		qTmpSA1->(dbclosearea())
	Else
		cQuery := "SELECT SA2.A2_ZZEMP,SA2.A2_ZZFIL"
		cQuery += " FROM "+RetSqlTab("SA2")+ " "
		cQuery += " WHERE SA2.D_E_L_E_T_ = ''"
		cQuery += " AND SA2.A2_COD = '"+cCliente+"'"
		cQuery += " AND SA2.A2_LOJA = '"+cLoja+"'"
		cQuery += " AND SA2.A2_FILIAL = '"+xFilial("SA2")+"'"

		dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"qTmpSA2", .F., .T.)
		DbSelectArea("qTmpSA2")

		If !qTmpSA2->(Eof())
			aAdd(aRet, qTmpSA2->A2_ZZEMP)
			aAdd(aRet, qTmpSA2->A2_ZZFIL)
		EndIf
		qTmpSA2->(dbclosearea())
	EndIf

	&&Seta o array com valores em branco caso nao tenha informação.
	If Len(aRet) == 0
		aAdd(aRet, "")
		aAdd(aRet, "")
	EndIf

	Return(aRet)

/**
* Method: retNivel
* Descricao: retorna o nivel que está cadastrado no pedido de venda.
**/
Method retNivel(cDoc,cSerie) Class TWAC002
	Local cRet := ""

	cQuery := "SELECT TOP 1 SC5.C5_ZZNIVEL FROM "+RetSqlTab("SC5")+" "+::cEof
	cQuery += "	INNER JOIN "+RetSqlTab("SF2")+" ON	SF2.F2_DOC			= SC5.C5_NOTA				AND	"+::cEof
	cQuery += "											SF2.F2_SERIE		= SC5.C5_SERIE			AND	"+::cEof
	cQuery += "											SF2.F2_CLIENTE	= SC5.C5_CLIENTE			AND	"+::cEof
	cQuery += "											SF2.F2_LOJA		= SC5.C5_LOJACLI			AND	"+::cEof
	cQuery += "											SF2.F2_FILIAL		= '"+xFilial("SF2")+"'	AND	"+::cEof
	cQuery += "											SF2.D_E_L_E_T_	= ''							"+::cEof
	cQuery += "	INNER JOIN "+RetSqlTab("SD2")+" ON	SD2.D2_DOC			= SF2.F2_DOC				AND	"+::cEof
	cQuery += "											SD2.D2_CLIENTE	= SF2.F2_CLIENTE			AND	"+::cEof
	cQuery += "											SD2.D2_LOJA		= SF2.F2_LOJA				AND	"+::cEof
	cQuery += "											SD2.D2_SERIE		= SF2.F2_SERIE			AND	"+::cEof
	cQuery += "											SD2.D2_FILIAL		= '"+xFilial("SD2")+"'	AND	"+::cEof
	cQuery += "											SD2.D_E_L_E_T_	= ''							"+::cEof
	cQuery += "	WHERE "+::cEof
	cQuery += "		SC5.C5_FILIAL	= '"+xFilial("SC5")+"'	AND"+::cEof
	cQuery += "		SC5.D_E_L_E_T_	= ''					AND"+::cEof
	cQuery += "		SF2.F2_DOC		= '"+cDoc+"'				AND"+::cEof
	cQuery += "		SF2.F2_SERIE	= '"+cSerie+"'"+::cEof

	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"qTmpN", .F., .T.)
	DbSelectArea("qTmpN")

	If !qTmpN->(Eof())
		cRet := qTmpN->C5_ZZNIVEL
	EndIf
	qTmpN->(dbclosearea())

	If Empty(cRet)
		SD2->(DbSetorder(3))
		If SD2->(DbSeek(xFilial("SD2")+cDoc+cSerie))
			SC5->(DbSetOrder(1))
			If SC5->(DbSeek(xFilial("SC5")+SD2->D2_PEDIDO))
				cRet := SC5->C5_ZZNIVEL
			EndIf
		EndIf
	EndIf

	Return(cRet)


/*
* MEtodo   : rerArrayPre
* Descricao: Retorna o array ja configura em relação ao nivel do cliente.
*
*
*/
Method retArrayPre(cNivel,cDoc,cSerie,cCliente,cForLoja,cEmpDes,cFilDest) Class TWAC002
	Local aDataCabec	:= {}
	Local aDataItem	:= {}
	Local aM140i		:= {}
	Local cEst			:= ""
	Local nX 			:= 0
	Local aRet			:= {}
	Local aAuxBusca	:= {}
	Local cProduto	:= ""

	If Len(::aEmpFilBn) > 0
		cCodFor 	:= ::aEmpFilBn[1]
		cLojaFor	:= ::aEmpFilBn[2]
		cEstado	:= ::aEmpFilBn[3]
	Else
		cCodFor 	:= ""
		cLojaFor	:= ""
		cEstado	:= ""
	EndIf

	AADD(aDataCabec,	{"F1_TIPO"		,"N"				,NIL})
	AADD(aDataCabec,	{"F1_FORMUL"	,"N"				,NIL})
	AADD(aDataCabec,	{"F1_EMISSAO"	,dDataBase			,NIL})
	AADD(aDataCabec,	{"F1_FORNECE"	,cCodFor			,NIL})
	AADD(aDataCabec,	{"F1_LOJA"		,cLojaFor			,NIL})
	AADD(aDataCabec,	{"F1_EST"		,cEstado			,NIL})
	AADD(aDataCabec,	{"F1_SERIE"	,SF2->F2_SERIE	,NIL})
	AADD(aDataCabec,	{"F1_DTDIGIT"	,dDataBase			,NIL})
	AADD(aDataCabec,	{"F1_ESPECIE"	,"SPED"			,NIL})
	AADD(aDataCabec,	{"F1_DOC"		,SF2->F2_DOC		,NIL})

	SD2->(DbSetOrder(3))
	If SD2->(DbSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA))
		nX := 1
		While 	SD2->D2_DOC     == SF2->F2_DOC		.AND. ;
				SD2->D2_SERIE   == SF2->F2_SERIE	.AND. ;
				SD2->D2_CLIENTE == SF2->F2_CLIENTE	.AND. ;
				SD2->D2_LOJA	  == SF2->F2_LOJA

			If ::lNfeBn == "B" .AND. SF2->F2_TIPO == "B"
				cProduto := ::TrocaProd(SD2->D2_COD,2)
			EndIf

			If ::lNfeBn == "B" .AND. SF2->F2_TIPO == "N"
				cProduto := ::TrocaProd(SD2->D2_COD,2)
			EndIf

			If ::lNfeBn == "N" .AND. SF2->F2_TIPO == "B"
				cProduto := SD2->D2_COD
			EndIf

			If ::lNfeBn == "N" .AND. SF2->F2_TIPO == "N"
				cProduto := SD2->D2_COD
			EndIf

			if Empty(::lNfeBn)
				cProduto := SD2->D2_COD
			EndIf

			AADD(aM140i,	{"D1_ITEM"   	,StrZero(nX,4)	,NIL})
			AADD(aM140i,	{"D1_COD"		,cProduto			,NIL})
			AADD(aM140i,	{"D1_UM"		,SB1->B1_UM		,NIL})
			AADD(aM140i,	{"D1_QUANT" 	,SD2->D2_QUANT	,NIL})
			AADD(aM140i,	{"D1_VUNIT" 	,SD2->D2_PRCVEN	,NIL})
			AADD(aM140i,	{"D1_TOTAL"  	,SD2->D2_TOTAL	,NIL})
			AADD(aM140i,	{"D1_LOCAL"  	,SD2->D2_LOCAL	,NIL})
			AADD(aM140i,	{"D1_CUSTO"  	,SD2->D2_CUSTO1	,NIL})

			If (::lNfeBn == "B" .AND. SF2->F2_TIPO == "N") .or. (::lNfeBn == "N" .AND. SF2->F2_TIPO == "B")
				cNumIdenB6 := ""
				cNumIdenB6	:= ::retSB6(SD2->D2_NFORI,SD2->D2_SERIORI,cProduto,cFilDest)
				AADD(aM140i,	{"D1_NFORI"	,SD2->D2_NFORI	,NIL})
				AADD(aM140i,	{"D1_SERIORI"	,SD2->D2_SERIORI	,NIL})
				AADD(aM140i,	{"D1_ITEMORI"	,SD2->D2_ITEMORI	,NIL})
				AADD(aM140i,	{"D1_IDENTB6"	,cNumIdenB6		,NIL})
			EndIf

			aAdd(aDataItem,aM140i)

			if Len(aAuxBusca) == 0
				aAuxBusca := aClone(aM140i)
			EndIf

			aM140i := {}
			nX		+= 1

			SD2->(DbSkip())
		EndDo
	EndIf

	nPosQtd := Ascan(aAuxBusca	,{|x| AllTrim(Upper(x[1])) == "D1_QUANT"})
	nPosVun := Ascan(aAuxBusca	,{|x| AllTrim(Upper(x[1])) == "D1_VUNIT"})
	nPosTot := Ascan(aAuxBusca	,{|x| AllTrim(Upper(x[1])) == "D1_TOTAL"})
	nPosDoc := Ascan(aDataCabec	,{|x| AllTrim(Upper(x[1])) == "F1_DOC"})
	nPosSer := Ascan(aDataCabec	,{|x| AllTrim(Upper(x[1])) == "F1_SERIE"})

	If cNivel == "1"
		aAdd(aRet, {aDataCabec,aDataItem})
	Endif

	Return(aRet)

/*
* MEtodo   : rerArrayNfe
* Descricao: Retorna o array ja configura em relação ao nivel do cliente.
*/
Method retANfe(cNivel,cDoc,cSerie,cCliente,cForLoja,cEmpDes,cFilDest) Class TWAC002
	Local aDataCabec	:= {}
	Local aDataItem	:= {}
	Local aM140i		:= {}
	Local cEst			:= ""
	Local nX 			:= 0
	Local aRet			:= {}
	Local aAuxBusca	:= {}

	SF2->(DbSetorder(1))
	If SF2->(DbSeek(xFilial("SF2")+cDoc+cSerie+cCliente+cForLoja))

		cCodFor 	:= ""
		cLojaFor	:= ""
		cEstado	:= ""

		cCodFor 	:= ::aEmpFilBn[1]
		cLojaFor	:= ::aEmpFilBn[2]
		cEstado	:= ::aEmpFilBn[3]

		AADD(aDataCabec,	{"F1_TIPO"		,"N"				,NIL})
		AADD(aDataCabec,	{"F1_FORMUL"	,"N"				,NIL})
		AADD(aDataCabec,	{"F1_EMISSAO"	,dDataBase			,NIL})
		AADD(aDataCabec,	{"F1_FORNECE"	,cCodFor			,NIL})
		AADD(aDataCabec,	{"F1_LOJA"		,cLojaFor			,NIL})
		AADD(aDataCabec,	{"F1_EST"		,cEstado			,NIL})
		AADD(aDataCabec,	{"F1_SERIE"	,::cSerOri			,NIL})
		AADD(aDataCabec,	{"F1_DTDIGIT"	,dDataBase			,NIL})
		AADD(aDataCabec,	{"F1_ESPECIE"	,"SPED"			,NIL})
		AADD(aDataCabec,	{"F1_DOC"		,SF2->F2_DOC		,NIL})
		AADD(aDataCabec,	{"F1_COND"		,"001"				,NIL})

		SD2->(DbSetOrder(3))
		If SD2->(DbSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA))
			nX := 1
			While 	SD2->D2_DOC     == SF2->F2_DOC		.AND. ;
					SD2->D2_SERIE   == SF2->F2_SERIE	.AND. ;
					SD2->D2_CLIENTE == SF2->F2_CLIENTE	.AND. ;
					SD2->D2_LOJA	  == SF2->F2_LOJA

				SB1->(DbSetOrder(1))
				SB1->(DbSeek(xFilial("SB1")+SD2->D2_COD))

				AADD(aM140i,	{"D1_ITEM"   	,StrZero(nX,4)	,NIL})
				AADD(aM140i,	{"D1_COD"		,SB1->B1_COD		,NIL})
				AADD(aM140i,	{"D1_QUANT" 	,SD2->D2_QUANT	,NIL})
				AADD(aM140i,	{"D1_VUNIT" 	,SD2->D2_PRCVEN	,NIL})
				AADD(aM140i,	{"D1_TOTAL"  	,SD2->D2_TOTAL	,NIL})
				AADD(aM140i,	{"D1_CUSTO"  	,SD2->D2_CUSTO1	,NIL})
				AADD(aM140i,	{"D1_TES"  	,"001"				,NIL})
				aAdd(aDataItem,aM140i)

				aM140i := {}
				nX		+= 1

				SD2->(DbSkip())
			EndDo
		EndIf

		nPosQtd := Ascan(aAuxBusca	,{|x| AllTrim(Upper(x[1])) == "D1_QUANT"})
		nPosVun := Ascan(aAuxBusca	,{|x| AllTrim(Upper(x[1])) == "D1_VUNIT"})
		nPosTot := Ascan(aAuxBusca	,{|x| AllTrim(Upper(x[1])) == "D1_TOTAL"})
		nPosDoc := Ascan(aDataCabec	,{|x| AllTrim(Upper(x[1])) == "F1_DOC"})
		nPosSer := Ascan(aDataCabec	,{|x| AllTrim(Upper(x[1])) == "F1_SERIE"})

		aAdd(aRet, {aDataCabec,aDataItem})
	Endif

	Return(aRet)


/*
* MEtodo   : rerArrayNfe
* Descricao: Retorna o array ja configura em relação ao nivel do cliente.
*/
Method retArrayNfeBn(cNivel,cDoc,cSerie,cCliente,cForLoja,cEmpDes,cFilDest) Class TWAC002
	Local aDataCabec	:= {}
	Local aDataItem	:= {}
	Local aM140i		:= {}
	Local cEst			:= ""
	Local nX 			:= 0
	Local aRet			:= {}
	Local aAuxBusca	:= {}

	SF2->(DbSetorder(1))
	If SF2->(DbSeek(xFilial("SF2")+cDoc+cSerie+cCliente+cForLoja))

		cCodFor 	:= ""
		cLojaFor	:= ""
		cEstado	:= ""
		aCgcForn 	:= ::retCgcDestino(SM0->M0_CGC, "SA1")
		cCodFor 	:= aCgcForn[1]
		cLojaFor	:= aCgcForn[2]
		cEstado	:= aCgcForn[3]

		AADD(aDataCabec,	{"F1_TIPO"		,"B"				,NIL})
		AADD(aDataCabec,	{"F1_FORMUL"	,"N"				,NIL})
		AADD(aDataCabec,	{"F1_EMISSAO"	,dDataBase			,NIL})
		AADD(aDataCabec,	{"F1_FORNECE"	,cCodFor			,NIL})
		AADD(aDataCabec,	{"F1_LOJA"		,cLojaFor			,NIL})
		AADD(aDataCabec,	{"F1_EST"		,cEstado			,NIL})
		AADD(aDataCabec,	{"F1_SERIE"	,SF2->F2_SERIE	,NIL})
		AADD(aDataCabec,	{"F1_DTDIGIT"	,dDataBase			,NIL})
		AADD(aDataCabec,	{"F1_ESPECIE"	,"SPED"			,NIL})
		AADD(aDataCabec,	{"F1_DOC"		,SF2->F2_DOC		,NIL})
		AADD(aDataCabec,	{"F1_COND"		,"001"				,NIL})

		SD2->(DbSetOrder(3))
		If SD2->(DbSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA))
		
			nX := 1
			While 	SD2->D2_DOC     == SF2->F2_DOC		.AND. ;
					SD2->D2_SERIE   == SF2->F2_SERIE	.AND. ;
					SD2->D2_CLIENTE == SF2->F2_CLIENTE	.AND. ;
					SD2->D2_LOJA	  == SF2->F2_LOJA

				cProduto := ::TrocaProd(SD2->D2_COD,1)
				AADD(aM140i,	{"D1_ITEM"   	,StrZero(Val(SD2->D2_ITEM),4)	,NIL})
				AADD(aM140i,	{"D1_COD"		,cProduto			,NIL})
				AADD(aM140i,	{"D1_QUANT" 	,SD2->D2_QUANT	,NIL})
				AADD(aM140i,	{"D1_VUNIT" 	,SD2->D2_PRCVEN	,NIL})
				AADD(aM140i,	{"D1_TOTAL"  	,SD2->D2_TOTAL	,NIL})
				AADD(aM140i,	{"D1_LOCAL"  	,SD2->D2_LOCAL	,NIL})
				AADD(aM140i,	{"D1_CUSTO"  	,SD2->D2_CUSTO1	,NIL})
				AADD(aM140i,	{"D1_TES"  	,::cTesEnt			,NIL})
				aAdd(aDataItem,aM140i)

				
				if Len(aAuxBusca) == 0
					aAuxBusca := aClone(aM140i)
				EndIf
				aM140i := {}
				nX		+= 1

				SD2->(DbSkip())
			EndDo
		EndIf
	
		aSort(aDataItem,,,{|X,Y| X[2] < Y[2] })
		
		aAdd(aRet, {aDataCabec,aDataItem})
	
	Endif

	Return(aRet)

/*
* MEtodo   : retArrayPv
* Descricao: Retorna o array ja configura em relação ao nivel do cliente.
*/
Method retAPv(cNivel,cDoc,cSerie,cCliente,cForLoja,cEmpDes,cFilDest) Class TWAC002
	Local aDataCabec	:= {}
	Local aDataItem	:= {}
	Local aM140i		:= {}
	Local cEst			:= ""
	Local nX 			:= 0
	Local aRet			:= {}
	Local aAuxBusca	:= {}
	Local cTes        := '50X'

	cQuery := "SELECT	SC5.C5_NUM, SC5.C5_CLIENTE, SC5.C5_LOJACLI, SC5.C5_CLIENT, SC5.C5_LOJAENT,SC5.C5_CONDPAG, SC5.C5_MOEDA,"+::cEof
	cQuery += "		SC9.C9_ITEM, SC9.C9_PRODUTO, SC9.C9_QTDLIB,SC9.C9_PRCVEN, SC9.C9_LOCAL, "+::cEof
	cQuery += "		SC6.C6_UM, SC6.C6_TES,SC6.C6_DESCRI"+::cEof
	cQuery += " FROM "+RetSqlTab("SC9")+" "+::cEof
	cQuery += "	INNER JOIN "+RetSqlTab("SD2")+" ON	SC9.C9_PEDIDO		= SD2.D2_PEDIDO 	AND"+::cEof
	cQuery += "											SC9.C9_ITEM		= SD2.D2_ITEM		AND"+::cEof
	cQuery += "											SC9.D_E_L_E_T_	= ''				AND"+::cEof
	cQuery += "											SC9.C9_FILIAL	   	= '"+xFilial("SC9")+"'"+::cEof
	cQuery += "	INNER JOIN "+RetSqlTab("SC5")+" ON	SC9.C9_PEDIDO   	= SC5.C5_NUM		AND"+::cEof
	cQuery += "											SC5.D_E_L_E_T_	= ''				AND"+::cEof
	cQuery += "											SC5.C5_FILIAL	   	= '"+xFilial("SC5")+"'"+::cEof
	cQuery += "	INNER JOIN "+RetSqlTab("SC6")+" ON	SC9.C9_PEDIDO   	= SC6.C6_NUM		AND"+::cEof
	cQuery += "											SC9.C9_ITEM		= SC6.C6_ITEM		AND"+::cEof
	cQuery += "											SC6.D_E_L_E_T_	= ''				AND"+::cEof
	cQuery += "											SC6.C6_FILIAL	   	= '"+xFilial("SC6")+"'"+::cEof
	cQuery += " WHERE"+::cEof
	cQuery += "	SD2.D_E_L_E_T_ = ''		AND"+::cEof
	cQuery += "	SD2.D2_FILIAL  = '"+xFilial("SF2")+"'	AND"+::cEof
	cQuery += "	SD2.D2_DOC	   	= '"+cDoc+"' AND"
	cQuery += "	SD2.D2_SERIE	= '"+cSerie+"'"

	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"qTmpPv", .F., .T.)
	DbSelectArea("qTmpPv")

	aCabPV		:= {}
	aItemPV 	:= {}
	While !qTmpPv->(Eof())

		If Len(aDataCabec) == 0
			lMsErroAuto := .F.

			aAdd(aDataCabec,{"C5_NUM"    	,qTmpPv->C5_NUM 		, Nil})
			aAdd(aDataCabec,{"C5_TIPO"   	,"N"            		, Nil})
			aAdd(aDataCabec,{"C5_CLIENTE"	,qTmpPv->C5_CLIENTE 	, Nil})
			aAdd(aDataCabec,{"C5_LOJACLI"	,qTmpPv->C5_LOJACLI	, Nil})
			aAdd(aDataCabec,{"C5_TIPOCLI"	,"F"            		, Nil})
			aAdd(aDataCabec,{"C5_ZZNIVEL"	,'X'             		, Nil})

		EndIf

		If ::cNivel $ '46'
			cTes := '50Z'
		EndIF

		aMata410i := {}
		AADD(aMata410i,	{"C6_ITEM"   	,qTmpPv->C9_ITEM								,NIL})
		AADD(aMata410i,	{"C6_PRODUTO"	,qTmpPv->C9_PRODUTO							,NIL})
		AADD(aMata410i,	{"C6_QTDVEN" 	,qTmpPv->C9_QTDLIB							,NIL})
		AADD(aMata410i,	{"C6_PRCVEN" 	,qTmpPv->C9_PRCVEN							,NIL})
		AADD(aMata410i,	{"C6_PRUNIT" 	,qTmpPv->C9_PRCVEN							,NIL})
		AADD(aMata410i,	{"C6_VALOR"  	,Round(qTmpPv->C9_QTDLIB * qTmpPv->C9_PRCVEN,2)	,NIL})
		AADD(aMata410i,	{"C6_QTDLIB" 	,qTmpPv->C9_QTDLIB							,NIL})
		AADD(aMata410i,	{"C6_TES"    	,cTes				   							,NIL})
		AADD(aDataItem, aMata410i)

		qTmpPv->(DbSkip())
	EndDo

	nPosQtd 	:= Ascan(aMata410i	,{|x| AllTrim(Upper(x[1])) == "C6_QTDVEN"})
	nPosVun 	:= Ascan(aMata410i	,{|x| AllTrim(Upper(x[1])) == "C6_PRCVEN"})
	nPosTot 	:= Ascan(aMata410i	,{|x| AllTrim(Upper(x[1])) == "C6_VALOR"})
	nPosQtdLib	:= Ascan(aMata410i	,{|x| AllTrim(Upper(x[1])) == "C6_QTDLIB"})
	nPosNum 	:= Ascan(aDataCabec	,{|x| AllTrim(Upper(x[1])) == "C5_NUM"})

	aAdd(aRet, {aDataCabec,aDataItem})

	qTmpPv->(DbCloseArea())
	Return(aRet)


/*
* MEtodo   : retArrayPv
* Descricao: Retorna o array ja configura em relação ao nivel do cliente.
*/
Method retArrayTw5(cDoc,cSerie,nTipo) Class TWAC002
	Local aDataCabec	:= {}
	Local aDataItem	:= {}
	Local aM140i		:= {}
	Local cEst			:= ""
	Local nX 			:= 0
	Local aRet			:= {}
	Local aAuxBusca	:= {}

	cQuery := "SELECT	SC5.C5_NUM, SC5.C5_CLIENTE, SC5.C5_LOJACLI, SC5.C5_CLIENT, SC5.C5_LOJAENT,SC5.C5_CONDPAG, SC5.C5_MOEDA,"+::cEof
	cQuery += "		SC9.C9_ITEM, SC9.C9_PRODUTO, SC9.C9_QTDLIB,SC9.C9_PRCVEN, SC9.C9_LOCAL, "+::cEof
	cQuery += "		SC6.C6_UM, SC6.C6_TES,SC6.C6_DESCRI"+::cEof
	cQuery += " FROM "+RetSqlTab("SC9")+" "+::cEof
	cQuery += "	INNER JOIN "+RetSqlTab("SD2")+" ON	SC9.C9_PEDIDO		= SD2.D2_PEDIDO 	AND"+::cEof
	cQuery += "											SC9.C9_ITEM		= SD2.D2_ITEM		AND"+::cEof
	cQuery += "											SC9.D_E_L_E_T_	= ''				AND"+::cEof
	cQuery += "											SC9.C9_FILIAL	   	= '"+xFilial("SC9")+"'"+::cEof
	cQuery += "	INNER JOIN "+RetSqlTab("SC5")+" ON	SC9.C9_PEDIDO   	= SC5.C5_NUM		AND"+::cEof
	cQuery += "											SC5.D_E_L_E_T_	= ''				AND"+::cEof
	cQuery += "											SC5.C5_FILIAL	   	= '"+xFilial("SC5")+"'"+::cEof
	cQuery += "	INNER JOIN "+RetSqlTab("SC6")+" ON	SC9.C9_PEDIDO   	= SC6.C6_NUM		AND"+::cEof
	cQuery += "											SC9.C9_ITEM		= SC6.C6_ITEM		AND"+::cEof
	cQuery += "											SC6.D_E_L_E_T_	= ''				AND"+::cEof
	cQuery += "											SC6.C6_FILIAL	   	= '"+xFilial("SC6")+"'"+::cEof
	cQuery += " WHERE"+::cEof
	cQuery += "	SD2.D_E_L_E_T_ = ''		AND"+::cEof
	cQuery += "	SD2.D2_FILIAL  = '"+xFilial("SF2")+"'	AND"+::cEof
	cQuery += "	SD2.D2_DOC	   	= '"+cDoc+"' AND"
	cQuery += "	SD2.D2_SERIE	= '"+cSerie+"'"

	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"qTmpPv", .F., .T.)
	DbSelectArea("qTmpPv")

	aCabPV		:= {}
	aItemPV 	:= {}
	While !qTmpPv->(Eof())

		If Len(aDataCabec) == 0
			lMsErroAuto := .F.

			aAdd(aDataCabec,{"C5_NUM"    	,qTmpPv->C5_NUM 		, Nil})
			aAdd(aDataCabec,{"C5_TIPO"   	,"N"            		, Nil})
			aAdd(aDataCabec,{"C5_CLIENTE"	,qTmpPv->C5_CLIENTE 	, Nil})
			aAdd(aDataCabec,{"C5_LOJACLI"	,qTmpPv->C5_LOJACLI	, Nil})
			aAdd(aDataCabec,{"C5_TIPOCLI"	,"F"            		, Nil})
			aAdd(aDataCabec,{"C5_ZZNIVEL"	,::cNivel             		, Nil})

		EndIf

		aMata410i := {}
		AADD(aMata410i,	{"C6_ITEM"   	,qTmpPv->C9_ITEM								,NIL})
		AADD(aMata410i,	{"C6_PRODUTO"	,qTmpPv->C9_PRODUTO							,NIL})
		AADD(aMata410i,	{"C6_QTDVEN" 	,qTmpPv->C9_QTDLIB							,NIL})
		AADD(aMata410i,	{"C6_PRCVEN" 	,qTmpPv->C9_PRCVEN							,NIL})
		AADD(aMata410i,	{"C6_PRUNIT" 	,qTmpPv->C9_PRCVEN							,NIL})
		AADD(aMata410i,	{"C6_VALOR"  	,Round(qTmpPv->C9_QTDLIB * qTmpPv->C9_PRCVEN,2)	,NIL})
		AADD(aMata410i,	{"C6_QTDLIB" 	,qTmpPv->C9_QTDLIB							,NIL})
		AADD(aMata410i,	{"C6_TES"    	,"50X"				   							,NIL})
		AADD(aDataItem, aMata410i)

		qTmpPv->(DbSkip())
	EndDo

	aAdd(aRet, {aDataCabec,aDataItem})

	qTmpPv->(DbCloseArea())
	Return(aRet)


/*
* MEtodo   : retArrayPv
* Descricao: Retorna o array ja configura em relação ao nivel do cliente.
*/
Method retArrayPvBn(cNivel,cDoc,cSerie,cCliente,cForLoja,cEmpDes,cFilDest) Class TWAC002
	Local aDataCabec	:= {}
	Local aDataItem	:= {}
	Local aM140i		:= {}
	Local cEst			:= ""
	Local nX 			:= 0
	Local aRet			:= {}
	Local aAuxBusca	:= {}

	cQuery := "SELECT	SC5.C5_NUM, SC5.C5_CLIENTE, SC5.C5_LOJACLI, SC5.C5_CLIENT, SC5.C5_LOJAENT,SC5.C5_CONDPAG, SC5.C5_MOEDA,"+::cEof
	cQuery += "		SC9.C9_ITEM, SC9.C9_PRODUTO, SC9.C9_QTDLIB,SC9.C9_PRCVEN, SC9.C9_LOCAL,SC9.C9_NFISCAL,SC9.C9_SERIENF, "+::cEof
	cQuery += "		SC6.C6_UM, SC6.C6_TES,SC6.C6_DESCRI"+::cEof
	cQuery += " FROM "+RetSqlTab("SC9")+" "+::cEof
	cQuery += "	INNER JOIN "+RetSqlTab("SD2")+" ON	SC9.C9_PEDIDO		= SD2.D2_PEDIDO 		AND"+::cEof
	cQuery += "											SC9.C9_ITEM		= SD2.D2_ITEM			AND"+::cEof
	cQuery += "											SC9.D_E_L_E_T_	= ''					AND"+::cEof
	cQuery += "											SC9.C9_NFISCAL	= '"+cDoc+"'	  		AND"+::cEof
	cQuery += "											SC9.C9_SERIENF	= '"+cSerie+"'  		AND"+::cEof
	cQuery += "											SC9.C9_FILIAL	   	= '"+xFilial("SC9")+"'"+::cEof
	cQuery += "	INNER JOIN "+RetSqlTab("SC5")+" ON	SC9.C9_PEDIDO   	= SC5.C5_NUM		AND"+::cEof
	cQuery += "											SC5.D_E_L_E_T_	= ''				AND"+::cEof
	cQuery += "											SC5.C5_FILIAL	   	= '"+xFilial("SC5")+"'"+::cEof
	cQuery += "	INNER JOIN "+RetSqlTab("SC6")+" ON	SC9.C9_PEDIDO   	= SC6.C6_NUM		AND"+::cEof
	cQuery += "											SC9.C9_ITEM		= SC6.C6_ITEM		AND"+::cEof
	cQuery += "											SC6.D_E_L_E_T_	= ''				AND"+::cEof
	cQuery += "											SC6.C6_FILIAL	   	= '"+xFilial("SC6")+"'"+::cEof
	cQuery += " WHERE"+::cEof
	cQuery += "	SD2.D_E_L_E_T_ = ''		AND"+::cEof
	cQuery += "	SD2.D2_FILIAL  = '"+xFilial("SF2")+"'	AND"+::cEof
	cQuery += "	SD2.D2_DOC	   	= '"+cDoc+"' AND"
	cQuery += "	SD2.D2_SERIE	= '"+cSerie+"'"
	cQuery += "	ORDER BY D2_ITEM"

	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"qTmpPvBn", .F., .T.)
	DbSelectArea("qTmpPvBn")

	aCabPV		:= {}
	aItemPV 	:= {}
	While !qTmpPvBn->(Eof())

		If Len(aDataCabec) == 0
			lMsErroAuto := .F.

			aAdd(aDataCabec,{"C5_NUM"    	,qTmpPvBn->C5_NUM	, Nil})
			aAdd(aDataCabec,{"C5_TIPO"   	,"N"            	, Nil})
			aAdd(aDataCabec,{"C5_CLIENTE"	,::aEmpFilBn[1] 	, Nil})
			aAdd(aDataCabec,{"C5_LOJACLI"	,::aEmpFilBn[2]	, Nil})
			aAdd(aDataCabec,{"C5_TIPOCLI"	,"F"            	, Nil})
		EndIf

		aMata410i 	:= {}
		cProduto 	:= ::TrocaProd(qTmpPvBn->C9_PRODUTO,1)

		AADD(aMata410i,	{"C6_ITEM"   	,qTmpPvBn->C9_ITEM								,NIL})
		AADD(aMata410i,	{"C6_PRODUTO"	,cProduto											,NIL})

		AADD(aMata410i,	{"C6_IDENTB6" ,""													,NIL})
		AADD(aMata410i,	{"C6_NFORI"  	,qTmpPvBn->C9_NFISCAL							,NIL})
		AADD(aMata410i,	{"C6_SERIORI"	,qTmpPvBn->C9_SERIENF							,NIL})
		AADD(aMata410i,	{"C6_ITEMORI" ,StrZero(Val(qTmpPvBn->C9_ITEM),4)				,NIL})

		AADD(aMata410i,	{"C6_QTDVEN" 	,qTmpPvBn->C9_QTDLIB								,NIL})
		AADD(aMata410i,	{"C6_PRCVEN" 	,qTmpPvBn->C9_PRCVEN							,NIL})
		AADD(aMata410i,	{"C6_PRUNIT" 	,qTmpPvBn->C9_PRCVEN							,NIL})
		AADD(aMata410i,	{"C6_VALOR"  	,Round(qTmpPvBn->C9_QTDLIB * qTmpPvBn->C9_PRCVEN,2)	,NIL})

		AADD(aMata410i,	{"C6_TES"    	,::cTesDv			   								,NIL})
		AADD(aMata410i,	{"C6_QTDLIB" 	,qTmpPvBn->C9_QTDLIB								,NIL})

		AADD(aDataItem, aMata410i)

		qTmpPvBn->(DbSkip())
	EndDo

	aAdd(aRet, {aDataCabec,aDataItem})
	qTmpPvBn->(DbCloseArea())

	Return(aRet)

/*
* Metodos: TrocaProd
* Descricao: troca o produto por produto de beneficiamento, para gerar o pedido de retorno.
*
*/
Method TrocaProd(cCodProd,nTipo,cCodTipo) Class TWAC002
	Local cRet 		:= ""
	Local cQuery		:= ""
	Local cCatalogo	:= ""

/*
SB1->(DbSetOrder(1))
If SB1->(DbSeek(xFilial("SB1")+cCodProd))
cCatalogo := SB1->B1_ZZCATAL
EndIf

If !Empty(cCatalogo)
cQuery := "SELECT SB1.B1_COD"
cQuery += " FROM "+RetSqlTab("SB1")
cQuery += " WHERE SB1.D_E_L_E_T_ = ''"
If nTipo == 1
cQuery += " AND   SB1.B1_TIPO = 'BN'"
Else
//cQuery += " AND   SB1.B1_TIPO = 'MP'"
cQuery += " AND   SB1.B1_TIPO IN ('MP','PI')"
EndIf
cQuery += " AND   SB1.B1_ZZCATAL = '"+cCatalogo+"'"
cQuery += " AND   SB1.B1_FILIAL = '"+xFilial("SB1")+"'"

dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"qTmpTP", .F., .T.)
DbSelectArea("qTmpTP")

if !qTmpTP->(Eof())
cRet := qTmpTP->B1_COD
EndIf
qTmpTP->(DbCloseArea())
Endif
*/

	cQuery := "SELECT *"
	cQuery += " FROM "+RetSqlTab("ZZF")
	cQuery += " WHERE ZZF.D_E_L_E_T_ = ''"
	cQuery += " AND   ZZF.ZZF_FILIAL = '"+xFilial("ZZF")+"'"

	If nTipo == 1 &&codigo do produto de beneficiamento.
		cQuery += " AND   ZZF.ZZF_CODPRO = '"+cCodProd+"'"
	Else &&Codigo produto normal.
		cQuery += " AND   ZZF.ZZF_CODBN = '"+cCodProd+"'"
	EndIf

	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"qTmpTP", .F., .T.)
	DbSelectArea("qTmpTP")

	if !qTmpTP->(Eof())

		If nTipo == 1
			cRet := qTmpTP->ZZF_CODBN
		Else
			cRet := qTmpTP->ZZF_CODPRO
		EndIf
	EndIf
	qTmpTP->(DbCloseArea())

	Return(cRet)

/*
* Metodos: retDadosNf
* Descricao: retorna os dados formatados do campo F2_ZZFAT, campo onde grava quais notas foram gerados no destino.
*
*/
Method retDadosNf(cTexto) Class TWAC002
	Local aRet 	:= {}
	Local aAux		:= {}
	Local aAux1	:= {}
	Local aAux2	:= {}
	Local aAux3	:= {}
	Local cAux 	:= ""

/*
TP:5/EMP.FIL:0101/NFE:000213   1  -X00213   X00-/PV:000100-X00100-/NFS:000046   1  -000047   1  -
*/
	if !Empty(cTexto)
		For nX := 1 to Len(cTexto)

			if SubStr(cTexto,nX,1) != "/"
				cAux += SubStr(cTexto,nX,1)

				If nX == Len(cTexto) .AND. !Empty(cAux)
					if At(":",cAux) > 0 .and. At("-",cAux) > 0
						aAux2 := ::retArrayFormatado(cAux,":")

						if Len(aAux2) > 1
							if !Empty(aAux2[2])
								aAux3 := ::retArrayFormatado(aAux2[2],"-")
							Endif
						Endif

						For nM := 1 to len(aAux3)
							aAdd(aAux, {aAux2[1],aAux3[nM]})
						Next nM
						cAux 	:= ""
						aAux2	:= {}
						aAux3 	:= {}
					Else

						aAux2 := ::retArrayFormatado(cAux,":")
						aAdd(aAux, {aAux2[1], aAux2[2]})
						cAux 	:= ""
						aAux2	:= {}
						aAux3 	:= {}
					Endif
				EndIf
			Else
				if At(":",cAux) > 0 .and. At("-",cAux) > 0
					aAux2 := ::retArrayFormatado(cAux,":")

					if Len(aAux2) > 1
						if !Empty(aAux2[2])
							aAux3 := ::retArrayFormatado(aAux2[2],"-")
						Endif
					Endif

					For nM := 1 to len(aAux3)
						aAdd(aAux, {aAux2[1],aAux3[nM]})
					Next nM
					cAux 	:= ""
					aAux2	:= {}
					aAux3 	:= {}
				Else
					aAux2 := ::retArrayFormatado(cAux,":")
					aAdd(aAux, {aAux2[1], aAux2[2]})
					cAux 	:= ""
					aAux2	:= {}
					aAux3 	:= {}
				Endif
			EndIf

		Next


		if Len(aAux) > 0
			aRet := aClone(aAux)
		Endif
	EndIf

	Return(aRet)

/*
* Metodos  : retArrayFormatado
* Descricao:
*/
Method retArrayFormatado(cTexto,cCaracter) Class TWAC002
	Local nX 		:= 0
	Local cAux 	:= ""
	Local aAux 	:= {}
	Local aRet		:= {}

	For nX := 1 to Len(cTexto)
		if SubStr(cTexto,nX,1) != cCaracter
			cAux += SubStr(cTexto,nX,1)
			if nX == Len(cTexto)
				aAdd(aAux, cAux)
			EndIf
		Else
			aAdd(aAux, cAux)
			cAux := ""
		EndIf
	Next

	if Len(aAux) > 0
		aRet := aClone(aAux)
	Endif

	Return(aRet)

/*
Metodo   : RotExcluir
Descrição:
*/
Method RotExcluir(cTipo) Class TWAC002
	Local lEstorno 		:= .F.
	Local aRegSD2			:= {}
	Local aRegSE1 		:= {}
	Local aRegSE2			:= {}

	Private lMsErroAuto 	:= .F.
	Private lMsHelpAuto 	:= .T.

	If cTipo == "PRE"

		MSExecAuto({|x,y,z|MATA140(x,y,z)},::aDataCabec,::aDataItem,5)

	ElseIf cTipo == "NFE"

		MSExecAuto({|x,y,z|MATA103(x,y,z)},::aDataCabec,::aDataItem,5)

	ElseIf cTipo == "PV"

		MSExecAuto({|x,y,z|MATA410(x,y,z)},::aDataCabec,::aDataItem,5)

	ElseIf cTipo == "NFS"

		lEstorno := MaCanDelF2("SF2",SF2->(RecNo()),@aRegSD2,@aRegSE1,@aRegSE2)
		If lEstorno
			lEstorno := SF2->(MaDelNFS(aRegSD2,aRegSE1,aRegSE2))
		EndIf

	EndIf

	If lMsErroAuto
		DisarmTransaction()
		MostraErro()
	EndIf
	::aDataCabec 	:= {}
	::aDataItem	:= {}

	Return


/*

*/
Method RetArrayExcluir(cTipo,cIndex) Class TWAC002

	&&Seta os Arrays em branco.
	::aDataCabec		:= {}
	::aDataItem		:= {}

	If cTipo == "SF1"
		SF1->(DbSetorder(1))
		If SF1->(DbSeek(xFilial("SF1")+cIndex))

			AADD(::aDataCabec,	{"F1_TIPO"		,SF1->F1_TIPO		,NIL})
			AADD(::aDataCabec,	{"F1_FORMUL"	,SF1->F1_FORMUL	,NIL})
			AADD(::aDataCabec,	{"F1_EMISSAO"	,SF1->F1_EMISSAO	,NIL})
			AADD(::aDataCabec,	{"F1_FORNECE"	,SF1->F1_FORNECE	,NIL})
			AADD(::aDataCabec,	{"F1_LOJA"		,SF1->F1_LOJA		,NIL})
			AADD(::aDataCabec,	{"F1_EST"		,SF1->F1_EST		,NIL})
			AADD(::aDataCabec,	{"F1_SERIE"	,SF1->F1_SERIE	,NIL})
			AADD(::aDataCabec,	{"F1_DTDIGIT"	,SF1->F1_DTDIGIT	,NIL})
			AADD(::aDataCabec,	{"F1_ESPECIE"	,SF1->F1_ESPECIE	,NIL})
			AADD(::aDataCabec,	{"F1_DOC"		,SF1->F1_DOC		,NIL})

			aItem := {}
			SD1->(DbSetOrder(1))
			If SD1->(DbSeek(xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA))

				While 	SD1->D1_DOC     == SF1->F1_DOC		.AND. ;
						SD1->D1_SERIE   == SF1->F1_SERIE	.AND. ;
						SD1->D1_FORNECE == SF1->F1_FORNECE	.AND. ;
						SD1->D1_LOJA	  == SF1->F1_LOJA

					AADD(aItem,	{"D1_ITEM"   	,SD1->D1_ITEM		,NIL})
					AADD(aItem,	{"D1_COD"		,SD1->D1_COD		,NIL})
					AADD(aItem,	{"D1_UM"		,SD1->D1_UM		,NIL})
					AADD(aItem,	{"D1_QUANT" 	,SD1->D1_QUANT	,NIL})
					AADD(aItem,	{"D1_VUNIT" 	,SD1->D1_VUNIT	,NIL})
					AADD(aItem,	{"D1_TOTAL"  	,SD1->D1_TOTAL	,NIL})
					AADD(aItem,	{"D1_LOCAL"  	,SD1->D1_LOCAL	,NIL})
					AADD(aItem,	{"D1_CUSTO"  	,SD1->D1_CUSTO	,NIL})
					aAdd(::aDataItem,aItem)
					aItem := {}

					SD1->(DbSkip())
				EndDo
			EndIf
		EndIf

	ElseIf cTipo == "SC5"

		&&Seta os Arrays em branco.
		::aDataCabec		:= {}
		::aDataItem		:= {}

		SC5->(DbSetorder(1))
		If SC5->(DbSeek(xFilial("SC5")+cIndex))
			aAdd(::aDataCabec,{"C5_NUM"    	,SC5->C5_NUM 		, Nil})
			aAdd(::aDataCabec,{"C5_TIPO"   	,SC5->C5_TIPO		, Nil})
			aAdd(::aDataCabec,{"C5_CLIENTE"	,SC5->C5_CLIENTE 	, Nil})
			aAdd(::aDataCabec,{"C5_LOJACLI"	,SC5->C5_LOJACLI	, Nil})
			aAdd(::aDataCabec,{"C5_CLIENT" 	,SC5->C5_CLIENT  	, Nil})
			aAdd(::aDataCabec,{"C5_LOJAENT"	,SC5->C5_LOJAENT 	, Nil})
			aAdd(::aDataCabec,{"C5_TIPOCLI"	,SC5->C5_TIPOCLI 	, Nil})
			aAdd(::aDataCabec,{"C5_CONDPAG"	,SC5->C5_CONDPAG	, Nil})
			aAdd(::aDataCabec,{"C5_EMISSAO"	,SC5->C5_EMISSAO	, Nil})
			aAdd(::aDataCabec,{"C5_MOEDA"  	,SC5->C5_MOEDA	, Nil})

			SC6->(DbSetOrder(1))
			If SC6->(DbSeek(xFilial("SC6")+cIndex))
				While !SC6->(Eof()) .and. SC6->C6_NUM == cIndex
					aMata410i := {}
					AADD(aMata410i,	{"C6_ITEM"   	,SC6->C6_ITEM		,NIL})
					AADD(aMata410i,	{"C6_PRODUTO"	,SC6->C6_PRODUTO	,NIL})
					AADD(aMata410i,	{"C6_UM"     	,SC6->C6_UM		,NIL})
					AADD(aMata410i,	{"C6_QTDVEN" 	,SC6->C6_QTDVEN	,NIL})
					AADD(aMata410i,	{"C6_PRCVEN" 	,Round(SC6->C6_PRCVEN,2)	,NIL})
					AADD(aMata410i,	{"C6_PRUNIT" 	,Round(SC6->C6_PRCVEN,2)	,NIL})
					AADD(aMata410i,	{"C6_VALOR"  	,Round(SC6->C6_PRCVEN * SC6->C6_QTDVEN,2)	,NIL})
					AADD(aMata410i,	{"C6_QTDLIB" 	,SC6->C6_QTDLIB	,NIL})
					AADD(aMata410i,	{"C6_TES"    	,SC6->C6_TES		,NIL})
					AADD(aMata410i,	{"C6_LOCAL"   ,SC6->C6_LOCAL	,NIL})
					AADD(aMata410i,	{"C6_DESCRI"  ,SC6->C6_DESCRI	,NIL})
					AADD(::aDataItem, aMata410i)
					SC6->(DbSkip())
				End
			EndIf

		EndIf
	ElseIf cTipo == "SF2"

		SF2->(DbSetorder(1))
		If SF2->(DbSeek(xFilial("SF2")+cIndex))

			AADD(::aDataCabec,	{"F2_TIPO"		,SF2->F2_TIPO		,NIL})
			AADD(::aDataCabec,	{"F2_EMISSAO"	,SF2->F2_EMISSAO	,NIL})
			AADD(::aDataCabec,	{"F2_CLIENTE"	,SF2->F2_CLIENTE	,NIL})
			AADD(::aDataCabec,	{"F2_LOJA"		,SF2->F2_LOJA		,NIL})
			AADD(::aDataCabec,	{"F2_EST"		,SF2->F2_EST		,NIL})
			AADD(::aDataCabec,	{"F2_SERIE"	,SF2->F2_SERIE	,NIL})
			AADD(::aDataCabec,	{"F2_DOC"		,SF2->F2_DOC		,NIL})

			aItem := {}
			SD2->(DbSetOrder(3))
			If SD2->(DbSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA))

				While 	SD2->D2_DOC     == SF2->F2_DOC		.AND. ;
						SD2->D2_SERIE   == SF2->F2_SERIE	.AND. ;
						SD2->D2_CLIENTE == SF2->F2_CLIENTE	.AND. ;
						SD2->D2_LOJA	  == SF2->F2_LOJA

					AADD(aItem,	{"D2_ITEM"   	,SD2->D2_ITEM		,NIL})
					AADD(aItem,	{"D2_COD"		,SD2->D2_COD		,NIL})
					AADD(aItem,	{"D2_UM"		,SD2->D2_UM		,NIL})
					AADD(aItem,	{"D2_QUANT" 	,SD2->D2_QUANT	,NIL})
					AADD(aItem,	{"D2_PRCVEN" 	,SD2->D2_PRCVEN	,NIL})
					AADD(aItem,	{"D2_TOTAL"  	,SD2->D2_TOTAL	,NIL})
					aAdd(::aDataItem,aItem)
					aItem := {}

					SD2->(DbSkip())
				EndDo
			EndIf
		EndIf

	EndIf

	Return()

/*
* Metodo   : ExcluiPend
* Descricao: Exclui todas as pre-notas, Nfe, Pv e Nfs que foram gerados apartir dessa Nota Fiscal
*/
Method ExcluiPend(aDados) Class TWAC002
	Local lRet		:= .F.
	Local nX 		:= 0
	Local aDataC 	:= {}
	Local aDataI 	:= {}
	Local aItem  	:= {}
	Local nEmpFil	:= 0
	Local nPre		:= 0
	Local nNfe 	:= 0
	Local nPv		:= 0
	Local nNfs		:= 0
	Local lTroco	:= .F.

	Private lMsErroAuto := .F.
	Private lMsHelpAuto := .T.

	nEmpFil	:= Ascan(aDados,{|x| AllTrim(Upper(x[1])) == "EMP.FIL"})
	nPre		:= Ascan(aDados,{|x| AllTrim(Upper(x[1])) == "PRE"})
	nNfe 		:= Ascan(aDados,{|x| AllTrim(Upper(x[1])) == "NFE"})
	nPv			:= Ascan(aDados,{|x| AllTrim(Upper(x[1])) == "PV"})
	nNfs		:= Ascan(aDados,{|x| AllTrim(Upper(x[1])) == "NFS"})

	If nEmpFil > 0
		::cEmpOri 	:= cEmpAnt
		::cFilOri 	:= cFilAnt

		&&Seta qual empresa que irá ser faturado a NOTA.
		::cProcessEmp	:= cEmpAnt
		::cProcessFil	:= aDados[nEmpFil][2]
		::changeEmpFil()
		lTroco := .T.
	Endif

	&&Exclui Nota Fiscal de saida
	If nNfs > 0

		if ::cNivel $ "1,4,6"
			::RetArrayExcluir("SF2",aDados[nNfs][2])
			::RotExcluir("NFS",aDados[nNfs][2])
		ElseIf ::cNivel $ "2,3"

			For nX := nNfs to nNfs+1
				::RetArrayExcluir("SF2",aDados[nX][2])
				::RotExcluir("NFS",aDados[nX][2])
			Next nX
		EndIf

	EndIf

	&&Exclui Pedido de venda.
	If nNfs > 0 .AND. nPv > 0

		if ::cNivel $ "1,4,6"
			::RetArrayExcluir("SC5",aDados[nPv][2])
			::RotExcluir("PV",aDados[nPv][2])
		ElseIf ::cNivel $ "2,3"

			nX := 0
			For nX := nPv to nPv+1
				::RetArrayExcluir("SC5",aDados[nX][2])
				::RotExcluir("PV",aDados[nX][2])
			Next nX
		EndIf

	EndIf

	&&Exclui Nota Fiscal de entrada
	If nNfs > 0 .AND. nNfe > 0

		if ::cNivel $ "1,4,6"
			::RetArrayExcluir("SF1",aDados[nNfe][2])
			::RotExcluir("NFE",aDados[nNfe][2])
		ElseIf ::cNivel $ "2,3"

			nX := 0
			For nX := nNfe to nNfe+1
				::RetArrayExcluir("SF1",aDados[nX][2])
				::RotExcluir("NFE",aDados[nX][2])
			Next nX
		EndIf

	EndIf

	&&Exclui a Pre nota.
	If nPre > 0 .And. nNfs == 0

		if ::cNivel $ "1,4,6"
			::RetArrayExcluir("SF1",aDados[nPre][2])
			::RotExcluir("PRE",aDados[nPre][2])
		ElseIf ::cNivel $ "2,3"

			nX := 0
			For nX := nPre to nPre+1
				::RetArrayExcluir("SF1",aDados[nX][2])
				::RotExcluir("PRE",aDados[nX][2])
			Next nX
		EndIf

	EndIf

	&&Volta para a empresa original
	If lTroco
		::cProcessEmp	:= ::cEmpOri
		::cProcessFil	:= ::cFilOri
		::changeEmpFil()
	EndIf

	Return(lRet)

/**
* Metodo : GerPreNota()
* Descric:
* Param  : Nenhum
* Retorno: Nil
*/
Method GerPreNota() Class TWAC002
	Local aItemPre 	:= {}
	Local aCabecPre	:= {}
	Local nX			:= 0
	Local aAux			:= {}

	Private lMsErroAuto := .F.
	Private lMsHelpAuto := .F.

	MSExecAuto({|x,y,z|MATA140(x,y,z)},::aDataCabec,::adataItem,3)

	If lMsErroAuto
		DisarmTransaction()
		MostraErro()
		lRet := .F.
	Else
		lRet := .T.
	EndIf

	Return(lRet)

/**
* Metodo : GerNFE()
* Descric:
* Param  : Nenhum
* Retorno: Nil
*/
Method GerNFE(aDataCabec,aDataItem) Class TWAC002
	Local aItemPre 	:= {}
	Local nX			:= 0
	Local aM140c		:= {}
	Local aM140i		:= {}

	Private lMsErroAuto := .F.
	Private lMsHelpAuto := .F.

	MaFisSave()
	MaFisEnd()

	MaFisIni(	::aDataCabec[4][2],;		&& 1-Codigo Cliente/Fornecedor
	::aDataCabec[5][2],;    	&& 2-Loja do Cliente/Fornecedor
	"C",;                  	&& 3-C:Cliente , F:Fornecedor
	"N",;                  	&& 4-Tipo da NF
	"F",;         		&& 5-Tipo do Cliente/Fornecedor
	Nil,;
		Nil,;
		Nil,;
		Nil,;
		"MATA103")

	MSExecAuto({|x,y,z|MATA103(x,y,z)},::aDataCabec,::aDataItem,3)

	If lMsErroAuto
		DisarmTransaction()
		MostraErro()
		lRet := .F.
	Else
		lRet := .T.
	EndIf

	Return(lRet)


/**
* Metodo : GerNFE()
* Descric:
* Param  : Nenhum
* Retorno: Nil
*/
Method setTesBn(cTes) Class TWAC002
	Local cQuery := ""

//cQuery := "SELECT F4_TESDV FROM "+RetSqlTab("SF4")+" WHERE SF4.D_E_L_E_T_ = '' AND SF4.F4_CODIGO = '"+cTes+"' AND SF4.F4_FILIAL = '"+xFilial("SF4")+"'"

//dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"qTmpTDV", .F., .T.)
//DbSelectArea("qTmpTDV")


	SF4->(DbSetOrder(1))
	If SF4->(DbSeek(xFilial("SF4")+cTes))
//if !qTmpTDV->(Eof())
		::cTesEnt	:= cTes
		::cTesDv	:= SF4->F4_TESDV
	EndIf
//qTmpTDV->(DbCloseArea())
	Return


/**
* Metodo : retCgcDestino()
* Descric:
* Param  : Nenhum
* Retorno: Nil
*/
Method retCgcDestino(cCgcAtu,cTipo) Class TWAC002
	Local aRet 	:= {}
	Local cQuery 	:= ""


	If cTipo == "SA1"
		cQuery := "SELECT * FROM "+RetSqlTab("SA1")+" WHERE SA1.D_E_L_E_T_ = '' AND SA1.A1_CGC = '"+cCgcAtu+"'"
		dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"qCgcBn", .F., .T.)
		DbSelectArea("qCgcBn")

		if !qCgcBn->(Eof())
			aAdd(aRet, qCgcBn->A1_COD)
			aAdd(aRet, qCgcBn->A1_LOJA)
			aAdd(aRet, qCgcBn->A1_EST)
		EndIf
		qCgcBn->(DbCloseArea())
	Else
		cQuery := "SELECT * FROM "+RetSqlTab("SA2")+" WHERE SA2.D_E_L_E_T_ = '' AND SA2.A2_CGC = '"+cCgcAtu+"'"
		dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"qCgcBn", .F., .T.)
		DbSelectArea("qCgcBn")

		if !qCgcBn->(Eof())
			aAdd(aRet, qCgcBn->A2_COD)
			aAdd(aRet, qCgcBn->A2_LOJA)
			aAdd(aRet, qCgcBn->A2_EST)
		EndIf
		qCgcBn->(DbCloseArea())
	Endif


	Return(aRet)

/**
* Metodo : ()
* Descric:
* Param  : Nenhum
* Retorno: Nil
*/
Method retIdentD1(cDoc,cSerie,cItem,cFilDest) Class TWAC002
	Local cRet := ""

	cQuery := "SELECT SD1.D1_IDENTB6 FROM "+RetSqlTab("SD1")+" WHERE SD1.D_E_L_E_T_ = ''"
	cQuery += " AND SD1.D1_ITEM = '"+StrZero(Val(cItem),4)+"' "
	cQuery += " AND SD1.D1_DOC = '"+cDoc+"'"
	cQuery += " AND SD1.D1_SERIE = '"+cSerie+"'"
	cQuery += " AND SD1.D1_FILIAL = '"+cFilDest+"'"
	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"qIdenB6", .F., .T.)
	DbSelectArea("qIdenB6")

	if !qIdenB6->(Eof())
		cRet := qIdenB6->D1_IDENTB6
	EndIf
	qIdenB6->(DbCloseArea())

	Return(cRet)

/**
* Metodo : retIdentD1()
* Descric:
* Param  : Nenhum
* Retorno: Nil
*/
Method retSB6(cDoc,cSerie,cProduto,cFilDest) Class TWAC002
	Local cRet := ""

	cQuery := "SELECT SB6.B6_IDENT FROM "+RetSqlTab("SB6")+" WHERE SB6.D_E_L_E_T_ = ''"
	cQuery += " AND SB6.B6_DOC = '"+cDoc+"' "
	cQuery += " AND SB6.B6_SERIE = '"+cSerie+"'"
	cQuery += " AND SB6.B6_PRODUTO = '"+cProduto+"'"
	cQuery += " AND SB6.B6_FILIAL = '"+cFilDest+"'"
	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"qIdenB6", .F., .T.)
	DbSelectArea("qIdenB6")

	if !qIdenB6->(Eof())
		cRet := qIdenB6->B6_IDENT
	EndIf
	qIdenB6->(DbCloseArea())

	Return(cRet)


Method VerificaBenefic(cDoc, cSerie) Class TWAC002
	Local lRet 	:= .T.
	Local cQuery	:= ""

	cQuery := "SELECT * "
	cQuery += " FROM "+RetSqlTab("SD2")+" "
	cQuery += ""

	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"qIdenB6", .F., .T.)
	DbSelectArea("qIdenB6")

	if !qIdenB6->(Eof())
		cRet := qIdenB6->D1_IDENTB6
	EndIf
	qIdenB6->(DbCloseArea())

	Return(lRet)


/**
* Metodo : retTipoNfe()
* Descric:
* Param  : Nenhum
* Retorno: Nil
*/
Method retTipoNfe(cDoc,cSerie,cFornece,cLoja) Class TWAC002
	Local lRet 	:= .T.
	Local cQuery	:= ""
	Local cRet		:= ""
	Local cEof		:= chr(13) + chr(10)

	cQuery := "SELECT TOP 1 SF1.F1_TIPO"+cEof
	cQuery += " FROM "+RetSqlTab("SF2")+" "+cEof
	cQuery += "   INNER JOIN "+RetSqlTab("SD2")+" ON	SF2.F2_DOC         	= SD2.D2_DOC				"+cEof
	cQuery += " 											AND	SF2.F2_SERIE		= SD2.D2_SERIE			"+cEof
	cQuery += " 											AND	SF2.F2_CLIENTE 	= SD2.D2_CLIENTE			"+cEof
	cQuery += " 											AND SF2.F2_LOJA    	= SD2.D2_LOJA				"+cEof
	cQuery += " 											AND SF2.F2_FILIAL  	= '"+xFilial("SF2")+"'	"+cEof
	cQuery += " 											AND SF2.D_E_L_E_T_ 	= ''						"+cEof
	cQuery += " 	INNER JOIN "+RetSqlTab("SF1")+"  ON	SD2.D2_NFORI   	= SF1.F1_DOC				"+cEof
	cQuery += " 											AND SD2.D2_SERIORI 	= SF1.F1_SERIE			"+cEof
	cQuery += " 											AND SF1.F1_FILIAL  	= '"+xFilial("SF1")+"'	"+cEof
	cQuery += " 											AND	SF1.D_E_L_E_T_ 	= ''						"+cEof
	cQuery += " 	WHERE	SF2.F2_DOC     = '"+cDoc+"'"+cEof
	cQuery += " 	AND		SF2.F2_SERIE   = '"+cSerie+"'"+cEof
	cQuery += " 	AND		SF2.F2_CLIENTE = '"+cFornece+"'"+cEof
	cQuery += " 	AND		SF2.F2_LOJA    = '"+cLoja+"'	"

	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"qTipoNfe", .F., .T.)
	DbSelectArea("qTipoNfe")

/*
if !qTipoNfe->(Eof())
cTipo := qTipoNfe->F1_TIPO

If cTipo == "B"
lRet := .T.
Else
lRet := .F.
EndIf

Else
lRet := .T.
EndIf
*/

	if !qTipoNfe->(Eof())
		cRet := qTipoNfe->F1_TIPO
	Else
		cRet := ""
	EndIf

	qTipoNfe->(DbCloseArea())

	Return(cRet)
