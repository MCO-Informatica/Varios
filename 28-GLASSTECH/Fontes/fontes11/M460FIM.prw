#Include 'Protheus.ch'
#INCLUDE "TOPCONN.CH"
#DEFINE cEOL CHR(13) + CHR(10)
/*
Verifica qual o tipo de faturamento que irá ser realizado.
1- Faturamento, transferencia entre empresas iguais e filiais diferentes
2- Faturamento, pedido tipo B=Utiliza Fornecedor
3- Faturamento, pedido de venda gerado em uma empresa e o faturamento irá sair por outra empresa
*/

User Function M460FIM()
	Local aArea		:= GetArea()
	Local cEmpDest	:= ""
	Local cFilDest	:= ""
	Local aEmpFil		:= {}
	Local oObj
	Local lContinua := .T.
	Local oTWFC001
	Local nDias     := SuperGetMV("ZZ_DPRLOJA", ,"5")
	Local lOk       := .T.
	Local cNfsNfe     := ''
	
	oObj05				:= TWAC002():New()
	aEmpFil 			:= oObj05:retEfCli(SF2->F2_CLIENTE,SF2->F2_LOJA,SF2->F2_TIPO)
	oObj05:cNivel	 	:= oObj05:retNivel(SF2->F2_DOC,SF2->F2_SERIE)
	oObj05:lNfeBn		:= oObj05:retTipoNfe(SF2->F2_DOC,SF2->F2_SERIE,SF2->F2_CLIENTE,SF2->F2_LOJA)

	oTWFC001  := TWFC001():New(SF2->F2_DOC,SF2->F2_SERIE,SF2->F2_CLIENTE,SF2->F2_LOJA,'I')

	If oObj05:cNivel == "4" .or. oObj05:cNivel == "6"
		cEmpDest	:= "01"
		cFilDest	:= "0701"
	Else
		cEmpDest	:= aEmpFil[1]
		cFilDest	:= aEmpFil[2]
	Endif

	If Alltrim(SF2->F2_SERIE) != "X" .And. !oObj05:cNivel $ '46X'
		TWGERVOL()

		If SF2->F2_TIPO == "N" .and. !Empty(cEmpDest) .and. !Empty(cFilDest) .and. !Empty(oObj05:cNivel)

			&& Tipo == 1 - Transferencia entre filiais.
			if SubStr(cFilAnt,1,2) == SubStr(cFilDest,1,2) .and. SubStr(cFilAnt,3,2) != SubStr(cFilDest,3,2) .and. oObj05:cNivel == "1"
				oObj05:aEmpFilBn	:= oObj05:retCgcDestino(SM0->M0_CGC,"SA2")
				oObj05:aArrayPre 	:= oObj05:retArrayPre(oObj05:cNivel,SF2->F2_DOC,SF2->F2_SERIE,SF2->F2_CLIENTE,SF2->F2_LOJA,cEmpDest,cFilDest)
				MsAguarde({|| oObj05:TWM001(cEmpDest,cFilDest) }, "Aguarde", "Gravando Dados....", .T.)
			EndIf

			&&Tipo == 3 - Transferencia entre empresas.
			if SubStr(cFilAnt,1,2) != SubStr(cFilDest,1,2) .and. oObj05:cNivel == "1"
//oObj05:aArrayNfe 	:= oObj05:retArrayNfe(oObj05:cNivel,SF2->F2_DOC,SF2->F2_SERIE,SF2->F2_CLIENTE,SF2->F2_LOJA,cEmpDest,cFilDest) && Gera um Documento de entrada
				oObj05:aEmpFilBn		:= oObj05:retCgcDestino(SM0->M0_CGC,"SA2")
				oObj05:aArrayPre 		:= oObj05:retArrayPre(oObj05:cNivel,SF2->F2_DOC,SF2->F2_SERIE,SF2->F2_CLIENTE,SF2->F2_LOJA,cEmpDest,cFilDest) && Gera uma Pre nota de entrada
				MsAguarde({|| oObj05:TWM003(cEmpDest,cFilDest) }, "Aguarde", "Gravando Dados....", .T.)
			EndIf

			If oObj05:cNivel	== '2' .Or. oObj05:cNivel == '3'
				MsAguarde({|| oTWFC001:TWGRVPDV() }, "Aguarde", "Gravando Dados....", .T.)
			EndIf

			&&Tipo == 2 - beneficiamento
		Elseif SF2->F2_TIPO == "B" .and. !Empty(cEmpDest) .and. !Empty(cFilDest) .and. !Empty(oObj05:cNivel)

			If Empty(oObj05:lNfeBn)
				if SubStr(cFilAnt,1,2) != SubStr(cFilDest,1,2)
					&&Seta a Tes de Entrada e seta a TES de Venda
					oObj05:setTesBn("261")
					oObj05:aEmpFilBn		:= oObj05:retCgcDestino(SM0->M0_CGC,"SA1")
					oObj05:aArrayNfeBn 	:= oObj05:retArrayNfeBn("1",SF2->F2_DOC,SF2->F2_SERIE,SF2->F2_CLIENTE,SF2->F2_LOJA,cEmpDest,cFilDest)
					oObj05:aArrayPvBn		:= oObj05:retArrayPvBn("1",SF2->F2_DOC,SF2->F2_SERIE,SF2->F2_CLIENTE,SF2->F2_LOJA,cEmpDest,cFilDest)
					oObj05:lFatura := .F.
					MsAguarde({|| oObj05:TWM002(cEmpAnt,cFilDest) }, "Aguarde", "Gravando Dados....", .T.)
				Endif

			ElseIf oObj05:lNfeBn == "N" .or. oObj05:lNfeBn == "B"
				&&Remessa para beneficiamento
				oObj05:aEmpFilBn	:= oObj05:retCgcDestino(SM0->M0_CGC,"SA2")
				oObj05:aArrayPre 	:= oObj05:retArrayPre(oObj05:cNivel,SF2->F2_DOC,SF2->F2_SERIE,SF2->F2_CLIENTE,SF2->F2_LOJA,cEmpDest,cFilDest)
				MsAguarde({|| oObj05:TWM001(cEmpDest,cFilDest) }, "Aguarde", "Gravando Dados....", .T.)
			EndIf
		EndIf

	ElseIf Alltrim(SF2->F2_SERIE) == "X"  .And. oObj05:cNivel $ '46'

		lOk := TWSATCLI()

		If lOk
			If oObj05:cNivel == "4" .OR. oObj05:cNivel == "6"

				oObj05:cSerOri	:= "X"+SubStr(cFilAnt,2,1)+SubStr(cFilAnt,4,1)
				oObj05:aEmpFilBn	:= oObj05:retCgcDestino(SM0->M0_CGC,"SA2")
				oObj05:aArrayNfe 	:= oObj05:retANfe(oObj05:cNivel,SF2->F2_DOC,SF2->F2_SERIE,SF2->F2_CLIENTE,SF2->F2_LOJA,cEmpDest,cFilDest)
				oObj05:aArrayPv 	:= oObj05:retAPv(oObj05:cNivel,SF2->F2_DOC,SF2->F2_SERIE,SF2->F2_CLIENTE,SF2->F2_LOJA,cEmpDest,cFilDest)
				oObj05:lFatura 	:= .T.
				MsAguarde({|| oObj05:TWM005(cEmpDest,cFilDest) }, "Aguarde", "Gravando Dados....", .T.)

			Endif
		Else
			TWDELNF()
			Aviso('Satisfação','Retorno Satisfação do Cliente pendente',{'OK'})
		EndIF
	EndIf

	If Alltrim(SF2->F2_SERIE) == "X"  .And. oObj05:cNivel $ '4X' .And. cFilAnt == '0701' .And. lOk
		ZZD->(DbSetOrder(1))
		If Reclock('ZZD', .T.)
			ZZD->ZZD_FILIAL := '0701'
			ZZD->ZZD_DOC    := SF2->F2_DOC
			ZZD->ZZD_SERIE  := SF2->F2_SERIE
			ZZD->ZZD_EMISSA := SF2->F2_EMISSAO
			ZZD->ZZD_VCTO   := SF2->F2_EMISSAO + nDias
			ZZD->ZZD_CLIENT := SF2->F2_CLIENTE
			ZZD->ZZD_LOJA   := SF2->F2_LOJA
			ZZD->ZZD_VEND   := SF2->F2_VEND1
			ZZD->ZZD_VALOR  := SF2->F2_VALBRUT
			ZZD->ZZD_FILORI := oObj05:cFilOri
			MsUnlock()
		EndIf
	EndIF

	RestArea(aArea)
	Return

Static function TWGERVOL()
	Local oTMsg  := FswTemplMsg():TemplMsg("S",SF2->F2_DOC,SF2->F2_SERIE,SF2->F2_CLIENTE,SF2->F2_LOJA)
	Local nPLiqui:= 0
	Local lSepara:= .F.
	Local nVolume:= 0
	Local nPBruto:= 0
	Local aPesEmb:= {}
	Local cEspecie := ' '
	Local lCb6 := .T.
	Local aAlterEnch := {}  //Vetor com nome dos campos que poderao ser editados
	Local aCpoEnch   := {}

	&& inicio calculo do peso liquido
	SD2->(dbSetOrder(3))
	SD2->(dbSeek(xFilial("SD2")+SF2->(F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA)))
	Do While !SD2->(EOF()) .and. SD2->D2_FILIAL == xFilial("SD2") .and. SD2->(D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA) == SF2->(F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA)
		nPLiqui += SD2->D2_QUANT * Posicione("SB1",1,xFilial("SB1")+SD2->D2_COD,"B1_PESO")
		CB6->(DbSetOrder(2))
		If CB6->( DbSeek(xFilial('CB6') + SD2->D2_PEDIDO))
			While !CB6->( EOF() ) .And. CB6->CB6_PEDIDO == SD2->D2_PEDIDO .And. CB6->CB6_STATUS == '1' .And. lCb6
				nVolume ++
				CB3->(DbSetOrder(1))
				If CB3->( DbSeek(xFilial('CB3') + CB6->CB6_TIPVOL))
					AaDd(aPesEmb,{CB6->CB6_TIPVOL, CB3->CB3_DESCRI,CB3->CB3_PESO,Alltrim(CB3->CB3_ZZESPE) })
				EndIf
				CB6->(DbSkip())
			EndDo
			lCb6 := .F.
			lSepara:= .T.
		EndIf
		SD2->(dbSkip())
	Enddo

	For nX := 1 to Len(aPesEmb)
		nPBruto += aPesEmb[nX,3]
		If !Alltrim(aPesEmb[nX,4]) $ cEspecie
			cEspecie+=  IF(Empty(cEspecie),aPesEmb[nX,4],'/' + aPesEmb[nX,4])
		EndIf
		aAdd(oTMsg:aMsg,{aPesEmb[nX,1],aPesEmb[nX,2]})
	Next nX
	&& fim

	&& inicio template mensagens da NF
	SD2->(dbSetOrder(3))
	SD2->(dbSeek(xFilial("SD2")+SF2->(F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA)))

	SC5->(dbSetOrder(1))
	SC5->(dbSeek(xFilial("SC5")+SD2->D2_PEDIDO))

	nPBruto += IIF(!Empty(SC5->C5_PESOL),SC5->C5_PESOL,nPLiqui)

	aAdd(oTMsg:aCampos,{"F2_TRANSP" ,SC5->C5_TRANSP})
	aAdd(oTMsg:aCampos,{"F2_REDESP" ,SC5->C5_REDESP})
	aAdd(oTMsg:aCampos,{"F2_PLIQUI" ,IIF(!Empty(SC5->C5_PESOL),SC5->C5_PESOL,nPLiqui)})

	If lSepara
		aAdd(oTMsg:aCampos,{"F2_PBRUTO" ,nPBruto})
		aAdd(oTMsg:aCampos,{"F2_VOLUME1",nVolume})
		aAdd(oTMsg:aCampos,{"F2_ESPECI1",cEspecie})
		&&aAdd(oTMsg:aCampos,{"F2_ZZPLACA",CriaVar("F2_ZZPLACA")})
		&&aAdd(oTMsg:aCampos,{"F2_ZZUFPLA",CriaVar("F2_ZZUFPLA")})
		&&aAdd(oTMsg:aCampos,{"F2_ZZDTSAI",dDatabase})
		&&aAdd(oTMsg:aCampos,{"F2_ZZHRSAI",Time()})
		&&aAdd(oTMsg:aCampos,{"F2_ZZMARCA",CriaVar("F2_ZZMARCA")})
		&&aAdd(oTMsg:aCampos,{"F2_ZZNUMER",CriaVar("F2_ZZNUMER")})
		aEval(oTMsg:aCampos,{|x| &("M->"+x[1]) := x[2] })
		oTMsg:grvDadosNF()
		oTMsg:grvMsg()

	Else
		aAdd(oTMsg:aCampos,{"F2_PBRUTO" ,IIF(!Empty(SC5->C5_PESOL),SC5->C5_PESOL,nPLiqui)})
		aAdd(oTMsg:aCampos,{"F2_VOLUME1",SF2->F2_VOLUME1})
		aAdd(oTMsg:aCampos,{"F2_ESPECI1",SC5->C5_ESPECI1})
		&&aAdd(oTMsg:aCampos,{"F2_ZZPLACA",CriaVar("F2_ZZPLACA")})
		&&aAdd(oTMsg:aCampos,{"F2_ZZUFPLA",CriaVar("F2_ZZUFPLA")})
		&&aAdd(oTMsg:aCampos,{"F2_ZZDTSAI",dDatabase})
		&&aAdd(oTMsg:aCampos,{"F2_ZZHRSAI",Time()})
		&&aAdd(oTMsg:aCampos,{"F2_ZZMARCA",CriaVar("F2_ZZMARCA")})
		&&aAdd(oTMsg:aCampos,{"F2_ZZNUMER",CriaVar("F2_ZZNUMER")})

		oTMsg:Processa()

		If RecLock("SC5",.F.)
			SC5->C5_TRANSP := SF2->F2_TRANSP
			SC5->C5_REDESP := SF2->F2_REDESP
			MsUnlock()
		EndIf
	EndIf
	&& fim template mensagens da NF

	Return

Static Function TWDELNF()
	Local lEstorno := .F.
	Local aReSD2:= {}
	Local aReSE1:= {}
	Local aReSE2:= {}

	lEstorno := MaCanDelF2("SF2",SF2->(Recno()),@aReSD2,@aReSE1,@aReSE2)
	If lEstorno
		lEstorno := SF2->(MaDelNFS(aReSD2,aReSE1,aReSE2))
	EndIf

	Return

Static Function TWSATCLI()
	Local lOk := .T.
	Local cAlias := GetNextAlias()
	Local cFilial:= '0701'
	Local cQuery := ''


	cQuery :=  "SELECT COUNT(*) CONT " + cEOL
	cQuery +=  "FROM " + cEOL
	cQuery +=  RetSQLTAB("ZZD") + " " + cEOL
	cQuery +=  "WHERE ZZD_CLIENT = '" + Alltrim(SF2->F2_CLIENTE) + "' " + cEOL
	cQuery +=  "AND   ZZD_LOJA   = '" + Alltrim(SF2->F2_LOJA) + "' " + cEOL
	cQuery +=  "AND   ZZD_EMISSA BETWEEN '" + DTOS(SF2->F2_EMISSAO) + "' AND '" + DTOS(SF2->F2_EMISSAO) + "'" + cEOL
	cQuery +=  "AND   ZZD_STATUS IN('','3','4') " + cEOL
	cQuery +=  "AND   D_E_L_E_T_ = ' ' " + cEOL

	TcQuery cQuery new alias &cAlias


	If (cAlias)->CONT > 0
		lOk:= .F.
	EndIF

	Return lOK
