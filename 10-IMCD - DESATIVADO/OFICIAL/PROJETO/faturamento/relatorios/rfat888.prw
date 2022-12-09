#include "TopConn.Ch"
#INCLUDE "Protheus.ch"
#INCLUDE "Vkey.ch"
#INCLUDE "TBICONN.ch"
#INCLUDE "BENEFARQ.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRFAT888   บAutor  ณMicrosiga           บ Data ณ  02/07/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RFAT888()

	Local cPerg := "PRFAT888"
	Private lRet := .F.
	Private aRet := {}
	PRIVATE cTitulo := "RELATORIO DE ACOMPANHAMENTO DE PEDIDO DE VENDA"

	IF PERGUNTE(cPerg,.T.)
		cPedDe	:= MV_PAR01
		cPedAte	:= MV_PAR02
		cData1	:= MV_PAR03
		cData2	:= MV_PAR04
		cEntrDe	:= MV_PAR05
		cEntrAte	:= MV_PAR06

		MsgRun("Favor Aguardar.....", "Selecionando os Registros... "+cTitulo,;
			{||  GERAEXCEL(cPedDe, cPedAte, cData1, cData2,cEntrDe,cEntrAte)  })
		if !lRet
			Aviso( cTitulo,"Nenhum dado gerado! Verifique os parametros utilizados.",{"OK"},3)
		Endif
	ELSE

		ALERT(STR0014) // "Processamento cancelado pelo usuario!"
	ENDIF
Return

Static Function GERAEXCEL(cPedDe, cPedAte, cData1, cData2,cEntrDe,cEntrAte)

	Local _cAlias		:=GetNextAlias()
	Local cQuery     	:=""
	Local _cPed			:=""
	Local _cProd		:=""
	Local cArq := ""
	Local cPlanilha := "Pedidos de Venda"

	Local cDirTmp := GetTempPath()
	Local oExcel := FWMSEXCEL():New()

	Private aCabec	:= {}
	Private aDados	:= {}

	cQuery := " SELECT "
	cQuery += " SC6.C6_PEDCLI, SB1.B1_EMB, SZ2.Z2_DESC, SC5.C5_TRANSP, SA4.A4_NOME,SC6.C6_NOTA,SC6.C6_SERIE,SC6.C6_DATFAT, SC5.C5_NUM, SC5.C5_TPFRETE,SC5.C5_PESOL,SC5.C5_PBRUTO, SC5.C5_GRPVEN, "
	cQuery += " SC6.C6_QTDVEN,SC6.C6_ENTREG,SC6.C6_VALOR,SC6.C6_PRODUTO,SX5.X5_DESCRI, "
	cQuery += " SB1.B1_DESC, SB1.B1__CODONU, SB1.B1_CLARIS, SB1.B1_NUMRIS, SB1.B1_TIPCAR, SB1.B1_UM, SA1.A1_COD, "
	cQuery += " SA1.A1_NOME, SA1.A1_END, SA1.A1_BAIRRO, SA1.A1_MUN, SA1.A1_EST, SA1.A1_CEP, SA1.A1_GRPTRIB, A1_XOBSMTG, "
	cQuery += " ACY.ACY_DESCRI, A3_NREDUZ , C5_USERLGI, C6_EMBRET, C5_XTRASEC , C5_REDESP, REDESP.A4_NOME REDESP_NOME"
	cQuery += " FROM " + RetSqlName("SC5") + " SC5 "
	cQuery += " INNER JOIN " + RetSqlName("SC6") + " SC6 "
	cQuery += " ON SC6.C6_FILIAL = SC5.C5_FILIAL AND SC6.C6_NUM = SC5.C5_NUM "
	cQuery += " AND C6_ENTREG BETWEEN '" + DTOS(cEntrDe) + "' AND '"+ DTOS(cEntrAte) + "' "
	cQuery += " AND SC6.D_E_L_E_T_ <> '*' "
	cQuery += " INNER JOIN "+ RetSqlName("SB1") + " SB1 "
	cQuery += " ON  SB1.B1_FILIAL = '" + xFilial("SB1") +"' "
	cQuery += " AND SB1.B1_COD = SC6.C6_PRODUTO "
	cQuery += " AND SB1.D_E_L_E_T_ <> '*' "
	cQuery += " INNER JOIN "+ RetSqlName("SA1") + " SA1 "
	cQuery += " ON  SA1.A1_FILIAL = '" + xFilial("SA1") +"' "
	cQuery += " AND SA1.A1_COD = SC5.C5_CLIENTE "
	cQuery += " AND SA1.A1_LOJA = SC5.C5_LOJACLI "
	cQuery += " AND SA1.D_E_L_E_T_ <> '*' "
	cQuery += " LEFT JOIN "+ RetSqlName("ACY") + " ACY "
	cQuery += " ON  ACY.ACY_FILIAL = '" + xFilial("ACY") +"' "
	cQuery += " AND ACY.ACY_GRPVEN = SC5.C5_GRPVEN "
	cQuery += " AND ACY.D_E_L_E_T_ <> '*' "

	cQuery += "  LEFT JOIN "+ RetSqlName("SX5") + " SX5 ON SC6.C6_XOPER = SX5.X5_CHAVE "
	cQuery += "  AND SX5.X5_FILIAL = '" + xFilial("SX5") +"'AND SX5.X5_TABELA  = 'DJ' AND SX5.D_E_L_E_T_ <> '*' "

	cQuery += " LEFT  JOIN "+ RetSqlName("SA4") + " SA4  ON  SA4.A4_COD = SC5.C5_TRANSP "
	cQuery += " AND SA4.A4_FILIAL = '" + xFilial("SA4") +"' AND SA4.D_E_L_E_T_ <> '*' "

	cQuery += " LEFT  JOIN "+ RetSqlName("SA4") + " REDESP  ON  REDESP.A4_COD = SC5.C5_REDESP "
	cQuery += " AND REDESP.A4_FILIAL = '" + xFilial("SA4") +"' AND REDESP.D_E_L_E_T_ <> '*' "

	cQuery += " LEFT  JOIN "+ RetSqlName("SZ2") + " SZ2 ON  SZ2.Z2_COD = SB1.B1_EMB "
	cQuery += " AND SZ2.Z2_FILIAL = '" + xFilial("SZ2") +"' AND SZ2.D_E_L_E_T_ <> '*' "

	cQuery += " LEFT JOIN " + RetSqlName("SA3") + " SA3 ON SA3.A3_COD = SC5.C5_VEND1 "
	cQuery += " AND SA3.A3_FILIAL = '" + xFilial("SA3") + "' AND SA3.D_E_L_E_T_ = ' ' "

	cQuery += " WHERE "
	cQuery += " SC5.C5_FILIAL = '"		+xFilial("SC5")	+ "' "
	cQuery += " AND SC5.C5_NUM >='"		+cPedDe			+ "' "
	cQuery += " AND SC5.C5_NUM <='"		+cPedAte 		+ "' "
	cQuery += " AND SC5.C5_EMISSAO BETWEEN '" 		+ DTOS(cData1) + "' AND '"+ DTOS(cData2) + "' "
	cQuery += " AND SC5.D_E_L_E_T_ <> '*' "

	TCQUERY cQuery NEW ALIAS ( _cAlias )

	TCSetField( _cAlias,"C6_ENTREG","D",08,0 )



	DbSelectArea( _cAlias )
	(_cAlias)->( DbGoTop() )
	ProcRegua(RecCount())


	oExcel:AddworkSheet(cPlanilha)
	oExcel:AddTable (cPlanilha,cTitulo)
	oExcel:AddColumn(cPlanilha,cTitulo, "Pedido",1,1)
	oExcel:AddColumn(cPlanilha,cTitulo, "Data de insercao do Pedido",2,4)
	oExcel:AddColumn(cPlanilha,cTitulo, "Horario de insercao do Pedido",1,1)
	oExcel:AddColumn(cPlanilha,cTitulo, "Status Liberacao",1,1)
	oExcel:AddColumn(cPlanilha,cTitulo, "Tipo de Opera็ใo",1,1)
	oExcel:AddColumn(cPlanilha,cTitulo, "Grupo de Vendas",1,1)
	oExcel:AddColumn(cPlanilha,cTitulo, "Descricao do Grupo",1,1)
	oExcel:AddColumn(cPlanilha,cTitulo, "Vendedor",1,1)
	oExcel:AddColumn(cPlanilha,cTitulo, "Pedido Gerado Por",1,1)
	oExcel:AddColumn(cPlanilha,cTitulo, "Cod Produto",1,1)
	oExcel:AddColumn(cPlanilha,cTitulo, "Descricao",1,1)
	oExcel:AddColumn(cPlanilha,cTitulo, "Ordem de Producao",1,1)
	oExcel:AddColumn(cPlanilha,cTitulo, "Cod. Onu",1,1)
	oExcel:AddColumn(cPlanilha,cTitulo, "Clasf. Risco",1,1)
	oExcel:AddColumn(cPlanilha,cTitulo, "Num. Risco",1,1)
	oExcel:AddColumn(cPlanilha,cTitulo, "Tipo Carga",1,1)
	oExcel:AddColumn(cPlanilha,cTitulo, "Cod Cliente",1,1)
	oExcel:AddColumn(cPlanilha,cTitulo, "Cliente",1,1)
	oExcel:AddColumn(cPlanilha,cTitulo, "Endereco",1,1)
	oExcel:AddColumn(cPlanilha,cTitulo, "Bairro",1,1)
	oExcel:AddColumn(cPlanilha,cTitulo, "Cidade",1,1)
	oExcel:AddColumn(cPlanilha,cTitulo, "UF",1,1)
	oExcel:AddColumn(cPlanilha,cTitulo, "CEP",1,1)
	oExcel:AddColumn(cPlanilha,cTitulo, "Quantidade",3,2)
	oExcel:AddColumn(cPlanilha,cTitulo, "UM",1,1)
	oExcel:AddColumn(cPlanilha,cTitulo, "Tipo Frete",1,1)
	oExcel:AddColumn(cPlanilha,cTitulo, "Entrega",2,4)
	oExcel:AddColumn(cPlanilha,cTitulo, "Peso Liquido",3,2)
	oExcel:AddColumn(cPlanilha,cTitulo, "Peso Bruto",3,2)
	oExcel:AddColumn(cPlanilha,cTitulo, "Valor Total",3,2)
	oExcel:AddColumn(cPlanilha,cTitulo, "Obs. Cliente",1,1)
	oExcel:AddColumn(cPlanilha,cTitulo, "Nota Fiscal",1,1)
	oExcel:AddColumn(cPlanilha,cTitulo, "Serie da NF",1,1)
	oExcel:AddColumn(cPlanilha,cTitulo, "Data Fatur",2,4)
	oExcel:AddColumn(cPlanilha,cTitulo, "Cod Transport",1,1)
	oExcel:AddColumn(cPlanilha,cTitulo, "Nome Transport",1,1)
	oExcel:AddColumn(cPlanilha,cTitulo, "Tipo Emb",1,1)
	oExcel:AddColumn(cPlanilha,cTitulo, "Descr Tipo Emb",1,1)
	oExcel:AddColumn(cPlanilha,cTitulo, "Pedido Cliente",1,1)
	oExcel:AddColumn(cPlanilha,cTitulo, "Status da Embalagem",1,1)
	oExcel:AddColumn(cPlanilha,cTitulo, "Transporte seccionado?",1,1)
	oExcel:AddColumn(cPlanilha,cTitulo, "Cod. Transp Redespacho",1,1)
	oExcel:AddColumn(cPlanilha,cTitulo, "Nome Transp Redespacho",1,1)

	ProcRegua((_cAlias)->(RecCount()))

	While (_cAlias)->(!Eof())

		If _cPed <> (_cAlias)->C5_NUM
			//------------------------------------------------------------------------------
			//Busca na SZ4 Horario de insercao do Pedido,  Status Libera็ใo (trazer legenda)
			//------------------------------------------------------------------------------
			_cDtInc		:= ""
			_cStatLib	:= ""
			_cHora		:= ""
			_cProd		:= ""
			_nEst		:= 0
			_nEstTer	:= 0
			_PesqZ4((_cAlias)->C5_NUM,@_cDtInc, @_cStatLib, @_cHora)

		Endif


		cNomeEmi  := UsrRetName( SubStr( Embaralha( (_cAlias)->C5_USERLGI, 1 ), 3, 6 ) )
		cEmbala   := ""

		If (_cAlias)->C6_EMBRET = '1'
			cEmbala := 'SIM'
		ELSE
			cEmbala := 'NAO'
		ENDIF

		lRet := .T.
		IncProc("Aguarde o Processamento...")

		oExcel:AddRow(cPlanilha,cTitulo,{	(_cAlias)->C5_NUM		,;
			_cDtInc					,;
			_cHora					,;
			_cStatLib				,;
			(_cAlias)->X5_DESCRI    ,;
			(_cAlias)->C5_GRPVEN	,;
			(_cAlias)->ACY_DESCRI	,;
			Capital((_cAlias)->A3_NREDUZ)	,;
			cNomeEmi	,;
			(_cAlias)->C6_PRODUTO	,;
			(_cAlias)->B1_DESC		,;
			""						,;	//Ordem de Producao
		(_cAlias)->B1__CODONU	,;
			(_cAlias)->B1_CLARIS	,;
			(_cAlias)->B1_NUMRIS	,;
			(_cAlias)->B1_TIPCAR	,;
			(_cAlias)->A1_COD		,;
			(_cAlias)->A1_NOME		,;
			(_cAlias)->A1_END		,;
			(_cAlias)->A1_BAIRRO	,;
			(_cAlias)->A1_MUN		,;
			(_cAlias)->A1_EST		,;
			(_cAlias)->A1_CEP		,;
			(_cAlias)->C6_QTDVEN	,;
			(_cAlias)->B1_UM		,;
			(_cAlias)->C5_TPFRETE	,;
			(_cAlias)->C6_ENTREG	,;
			(_cAlias)->C5_PESOL		,;
			(_cAlias)->C5_PBRUTO	,;
			(_cAlias)->C6_VALOR 	,;
			(_cAlias)->A1_XOBSMTG 	,;
			(_cAlias)->C6_NOTA	 	,;
			(_cAlias)->C6_SERIE 	,;
			Stod((_cAlias)->C6_DATFAT) 	,;
			(_cAlias)->C5_TRANSP 	,;
			(_cAlias)->A4_NOME	 	,;
			(_cAlias)->B1_EMB	 	,;
			(_cAlias)->Z2_DESC	 	,;
			(_cAlias)->C6_PEDCLI	,;
			cEmbala					,;
			iif((_cAlias)->C5_XTRASEC=='S', "Sim", "Nใo"),;
			(_cAlias)->C5_REDESP ,;
			(_cAlias)->REDESP_NOME })

		DbSelectArea( _cAlias )
		(_cAlias)->(dbskip())
	ENDDO

	(_cAlias)->(DbCloseArea())
	MsErase(_cAlias)
	
	IF lRet
		oExcel:Activate()
		cArq :=  "REL_PEDIDO_DE_VENDA_"+DTOS(DATE())+STRTRAN(TIME(),':','')+".xml"

		LjMsgRun( "Gerando o arquivo, aguarde...", cPlanilha, {|| oExcel:GetXMLFile( cArq ) } )

		If __CopyFile( cArq, cDirTmp + cArq )
			IF (ApOleClient("MsExcel"))
				oExcelApp := MsExcel():New()
				oExcelApp:WorkBooks:Open( cDirTmp + cArq )
				oExcelApp:SetVisible(.T.)
			Else
				MsgInfo("MsExcel nใo instalado/OU NรO ENCONTRADO NO PATH")
			EndIf
			MsgInfo( "Arquivo " + cArq + " gerado com sucesso no diret๓rio " + cDirTmp )
		Else
			MsgInfo( "Arquivo nใo copiado para temporแrio do usuแrio." )
		Endif
		FERASE(cArq)
	ENDIF

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNOVO7     บAutor  ณMicrosiga           บ Data ณ  02/07/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function _PesqZ4(xNumPed,_cDtInc, _cStatLib, _cHora)
	Local lPvez	:=.T.

	DbSelectArea("SZ4")
	DbSetOrder(1)
	If DbSeek(xFilial("SZ4")+xNumPed)

		While SZ4->(!EOF()) .AND. SZ4->Z4_FILIAL == xFilial("SZ4") .AND. SZ4->Z4_PEDIDO == xNumPed
			If !( "Rotina Automatica" $ SZ4->Z4_MOTIVO )
				If lPvez
					_cDtInc		:= SZ4->Z4_DATA
					_cHora		:= SZ4->Z4_HORA
					lPvez:=.F.
				Else
					_cStatLib	:= SZ4->Z4_EVENTO
				Endif
			Endif
			SZ4->(DbSkip())
		End
	Endif

Return
