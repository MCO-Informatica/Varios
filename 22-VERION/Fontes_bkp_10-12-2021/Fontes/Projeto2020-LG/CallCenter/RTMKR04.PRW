#Include "Protheus.ch"
#Include "Rwmake.ch"
#INCLUDE "TOPCONN.CH"

User Function RTMKR04()

	Local oReport
	Local cPerg		:= Padr( "TMK004", LEN( SX1->X1_GRUPO ) )
	Local cAlias 	:= "SUA"

	Private aGrupos := {}
	Private lAdm    := .F.

	Private nTotPed := 0
	Private nTotNF  := 0
	Private nTotICM := 0
	Private nTotST  := 0
	Private nTotISS := 0
	Private nTotLiq := 0

	Private cAux 	 := ""
	Private cCodVend := ""
	Private cNomVend := ""
	Private cCodOper := ""
	Private cNomOper := ""

	aGrupos := UsrRetGrp(PswChave(RetCodUsr()),RetCodUsr())

	lAdm := aScan(aGrupos,{|x| AllTrim(x) $ "000000" }) > 0

	Pergunte(cPerg,.T. )

	oReport := reportDef(cAlias, cPerg)
	oReport:printDialog()

return


//+-----------------------------------------------------------------------------------------------+
//! Função para criação da estrutura do relatório.                                                !
//+-----------------------------------------------------------------------------------------------+
Static Function ReportDef(cAlias,cPerg)

	local cTitle  := "RELACAO DE VENDAS POR VENDEDOR/OPERADOR"
	local cHelp   := "RELACAO DE VENDAS POR VENDEDOR/OPERADOR"
	local oReport
	local oSection1

	oReport := TReport():New('RTMKR04',cTitle,cPerg,{|oReport|ReportPrint(oReport,cAlias)},cHelp)
	oReport:SetPortrait()
	oReport:SetTotalInLine(.F.)

	//Primeira seção
	oSection1 := TRSection():New(oReport,"VENDEDOR",{"TMPSUA","SUA"})


	IF MV_PAR05 == 2

		TRCell():New(oSection1,"ORIG"		            , "TMPSUA", "ORIG"		            ,"@!"						,06		)
		TRCell():New(oSection1,"CODVEND"		        , "TMPSUA", "CODVEND"		        ,"@!"						,08		)
		TRCell():New(oSection1,"NOMEVEND"		        , "TMPSUA", "NOMEVEND"		        ,"@!"						,32		)
		TRCell():New(oSection1,"CODOPER"			    , "TMPSUA", "CODOPER"				,"@!"						,08		)
		TRCell():New(oSection1,"NOMEOPER"		    	, "TMPSUA", "NOMEOPER"				,"@!"						,22		)
		TRCell():New(oSection1,"PEDIDO"		            , "TMPSUA", "PEDIDO"		        ,"@!"						,08		)
		TRCell():New(oSection1,"EMISSPV"		        , "TMPSUA", "EMISSPV"			    ,"@!"						,12		)
		TRCell():New(oSection1,"NOTA"		            , "TMPSUA", "NOTA"         			,"@!"						,12		)
		TRCell():New(oSection1,"SERIE"			        , "TMPSUA", "SERIE"	        		,"@!"				        ,06		)
		TRCell():New(oSection1,"EMISSNF"			    , "TMPSUA", "EMISSNF"       		,"@!"			            ,12		)
		TRCell():New(oSection1,"CODCLI"		        	, "TMPSUA", "CODCLI"			    ,"@!"		                ,08		)
		TRCell():New(oSection1,"LOJA"       			, "TMPSUA", "LOJA"     				,"@!"						,04	    )
		TRCell():New(oSection1,"CLIENTE"    			, "TMPSUA", "CLIENTE"		        ,"@!"						,22	    )
		TRCell():New(oSection1,"CIDADE"				    , "TMPSUA", "CIDADE"    			,"@!"						,22		)
		TRCell():New(oSection1,"UF"	    			    , "TMPSUA", "UF"        			,"@!"						,04		)
		TRCell():New(oSection1,"CEP"				    , "TMPSUA", "CEP"	   			    ,"@!"						,10		)

	Else

		TRCell():New(oSection1,"CODVEND"		        , "TMPSUA", "CODVEND"		        ,"@!"						,08		)
		TRCell():New(oSection1,"NOMEVEND"		        , "TMPSUA", "NOMEVEND"		        ,"@!"						,32		)
		TRCell():New(oSection1,"CODOPER"			    , "TMPSUA", "CODOPER"				,"@!"						,08		)
		TRCell():New(oSection1,"NOMEOPER"		    	, "TMPSUA", "NOMEOPER"				,"@!"						,22		)

	EndIf

	If lAdm
		TRCell():New(oSection1,"VALORPV"			    , "TMPSUA", "VALORPV"    			,"@E 999,999,999.99"		,15		)
		TRCell():New(oSection1,"VALORNF"			    , "TMPSUA", "VALORNF"    			,"@E 999,999,999.99"		,15		)
		TRCell():New(oSection1,"VLRISS"			        , "TMPSUA", "VLRISS"    			,"@E 999,999,999.99"		,15		)
		TRCell():New(oSection1,"VLRICMS"			    , "TMPSUA", "VLRICMS"    			,"@E 999,999,999.99"		,15		)
		TRCell():New(oSection1,"VLRST"			        , "TMPSUA", "VLRST"    			    ,"@E 999,999,999.99"		,15		)
	EndIf

	TRCell():New(oSection1,"VALORLIQ"			    , "TMPSUA", "VALORLIQ"    			,"@E 999,999,999.99"		,22	)

	oSection1:SetTotalInLine(.f.)

	oReport:SetTotalInLine(.F.)

	oSection1:SetPageBreak(.T.)
	oSection1:SetTotalText(" ")

Return(oReport)


//+-----------------------------------------------------------------------------------------------+
//! Rotina para montagem dos dados do relatório.                                  !
//+-----------------------------------------------------------------------------------------------+
Static Function ReportPrint(oReport,cAlias)
	Local nCount := 0
	Local nY     := 0


	Local oSection1 	:= oReport:Section(1)
	Local cQuery			:= ""
	Local cTitulo		:= oReport:Title()

	Local cAliasNew		:= "TMPSUA"
	Local aStruSUA 		:= SUA->(dbStruct())
	Local nX

	cQuery := ""

	cQuery+="	SELECT 'FAT' AS 'ORIG', "
	cQuery+="        C5_VEND1 'CODVEND',  "
	cQuery+="        (SELECT TOP 1 A3_NOME FROM SA3010 SA3 WHERE A3_COD = C5_VEND1 AND SA3.D_E_L_E_T_='' ) 'NOMEVEND',  "
	cQuery+="		UA_OPERADO 'CODOPER', "
	cQuery+="		(SELECT TOP 1 U7_NOME FROM SU7010 SU7 WHERE U7_COD = UA_OPERADO AND SU7.D_E_L_E_T_='' ) 'NOMEOPER', "
	cQuery+="       C5_NUM 'PEDIDO',  "
	cQuery+="        SUBSTRING(C5_EMISSAO,7,2)+'/'+SUBSTRING(C5_EMISSAO,5,2)+'/'+SUBSTRING(C5_EMISSAO,1,4) 'EMISSPV',  "
	cQuery+="        C5_NOTA 'NOTA', "
	cQuery+="		C5_SERIE 'SERIE',  "
	cQuery+="        (SELECT TOP 1 SUBSTRING(D2_EMISSAO,7,2)+'/'+SUBSTRING(D2_EMISSAO,5,2)+'/'+SUBSTRING(D2_EMISSAO,1,4) FROM SD2010 SD2 WHERE D2_SERIE = C5_SERIE AND D2_DOC = C5_NOTA AND SD2.D_E_L_E_T_='' ) 'EMISSNF', "
	cQuery+="        C5_CLIENTE 'CODCLI',  "
	cQuery+="        C5_LOJACLI 'LOJA',  "
	cQuery+="       A1_NOME 'CLIENTE',  "
	cQuery+="        A1_MUN 'CIDADE',  "
	cQuery+="        A1_EST 'UF',  "
	cQuery+="        A1_CEP 'CEP',  "

	//If lAdm
	cQuery+="        SUM(C6_VALOR) 'VALORPV', "
	cQuery+="		(SELECT SUM(D2_TOTAL+D2_VALIPI+D2_ICMSRET) FROM SD2010 SD2 WHERE D2_SERIE = C5_SERIE AND D2_DOC = C5_NOTA AND SD2.D_E_L_E_T_='' ) 'VALORNF', "
	cQuery+="        (SELECT SUM(D2_VALICM) FROM SD2010 SD2 WHERE D2_SERIE = C5_SERIE AND D2_DOC = C5_NOTA AND SD2.D_E_L_E_T_='' ) 'VLRICMS', "
	cQuery+="        (SELECT SUM(D2_ICMSRET) FROM SD2010 SD2 WHERE D2_SERIE = C5_SERIE AND D2_DOC = C5_NOTA AND SD2.D_E_L_E_T_='' ) 'VLRST', "
	cQuery+="        (SELECT SUM(D2_VALISS) FROM SD2010 SD2 WHERE D2_SERIE = C5_SERIE AND D2_DOC = C5_NOTA AND SD2.D_E_L_E_T_='' ) 'VLRISS', "
	//EndIf

	cQuery+="		((SELECT SUM(D2_TOTAL+D2_VALIPI+D2_ICMSRET) FROM SD2010 SD2 WHERE D2_SERIE = C5_SERIE AND D2_DOC = C5_NOTA AND SD2.D_E_L_E_T_='' ) - (SELECT SUM(D2_VALICM) FROM SD2010 SD2 WHERE D2_SERIE = C5_SERIE AND D2_DOC = C5_NOTA AND SD2.D_E_L_E_T_='' ) - (SELECT SUM(D2_ICMSRET) FROM SD2010 SD2 WHERE D2_SERIE = C5_SERIE AND D2_DOC = C5_NOTA AND SD2.D_E_L_E_T_='' ) - (SELECT SUM(D2_VALISS) FROM SD2010 SD2 WHERE D2_SERIE = C5_SERIE AND D2_DOC = C5_NOTA AND SD2.D_E_L_E_T_='' )) 'VALORLIQ' "

	cQuery+="        FROM  "
	cQuery+="        SC5010 SC5  "
	cQuery+="        INNER JOIN SC6010 SC6 ON  "
	cQuery+="        C6_NUM = C5_NUM  "
	cQuery+="        AND C6_CLI = C5_CLIENTE  "
	cQuery+="        AND C6_LOJA = C5_LOJACLI  "
	cQuery+="        AND SC6.D_E_L_E_T_=''  "
	cQuery+="        INNER JOIN SF4010 SF4 ON  "
	cQuery+="        F4_CODIGO = C6_TES  "
	cQuery+="        AND F4_DUPLIC = 'S'  "
	cQuery+="        AND SF4.D_E_L_E_T_=''  "
	cQuery+="        INNER JOIN SA1010 SA1 ON  "
	cQuery+="        A1_COD = C5_CLIENTE   "
	cQuery+="        AND A1_LOJA = C5_LOJACLI  "
	cQuery+="		 JOIN SUA010 SUA ON " //TIREI O LEFT JOIN PORQUE TRAZIA MUITO PEDIDO QUE NÃO PERTENCIA AO FILTRO
	cQuery+="		UA_NUMSC5 = C5_NUM  "
	cQuery+="		AND SUA.D_E_L_E_T_='' "

	If lAdm
		cQuery+="        AND UA_VEND BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'  " //ERA O CAMPO C5_VEND1 a Elisangela disse que deveria ser o Operador UA_VEND
		cQuery+="        AND UA_OPERADO BETWEEN '"+MV_PAR06+"' AND '"+MV_PAR07+"'  "
	Else
		//cQuery+="        AND (C5_VEND1 = '"+Posicione("SU7",4,xFilial("SU7")+RetCodUsr(),"U7_CODVEN")+"'  "
		cQuery+="        AND (UA_VEND = '"+Posicione("SU7",4,xFilial("SU7")+RetCodUsr(),"U7_CODVEN")+"'  "
		cQuery+="        OR UA_OPERADO = '"+Posicione("SU7",4,xFilial("SU7")+RetCodUsr(),"U7_COD")+"')  "
		cQuery+="        AND C5_NOTA <> ' '  "
	EndIf

	cQuery+="        WHERE SC5.D_E_L_E_T_=''  "
	cQuery+="        AND C5_EMISSAO BETWEEN '"+DTOS(MV_PAR03)+"' AND '"+DTOS(MV_PAR04)+"'  "

	If MV_PAR08 == 1
		cQuery+="        AND C5_NOTA = ' '  "
	ElseIf MV_PAR08 == 2
		cQuery+="        AND C5_NOTA <> ' '  "
	EndIf

	//cQuery+="        AND C5_VEND1 BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'  "

	cQuery+="		GROUP BY C5_VEND1, UA_OPERADO ,C5_NUM, C5_NOTA, C5_SERIE, C5_EMISSAO, A1_NOME, A1_MUN, A1_EST, A1_CEP, C5_CLIENTE, C5_LOJACLI "

	If MV_PAR08 <> 1

		cQuery+="		UNION ALL "

		cQuery+="	    SELECT 'DEV' AS 'ORIG', "
		cQuery+="        C5_VEND1 'CODVEND',  "
		cQuery+="        (SELECT TOP 1 A3_NOME FROM SA3010 SA3 WHERE A3_COD = C5_VEND1 AND SA3.D_E_L_E_T_='' ) 'NOMEVEND',  "
		cQuery+="		UA_OPERADO 'CODOPER', "
		cQuery+="		(SELECT TOP 1 U7_NOME FROM SU7010 SU7 WHERE U7_COD = UA_OPERADO AND SU7.D_E_L_E_T_='' ) 'NOMEOPER', "
		cQuery+="        C5_NUM 'PEDIDO',  "
		cQuery+="        SUBSTRING(C5_EMISSAO,7,2)+'/'+SUBSTRING(C5_EMISSAO,5,2)+'/'+SUBSTRING(C5_EMISSAO,1,4) 'EMISSPV',  "
		cQuery+="        C5_NOTA 'NOTA', "
		cQuery+="		C5_SERIE 'SERIE',  "
		cQuery+="        max(SUBSTRING(D1_DTDIGIT,7,2)+'/'+SUBSTRING(D1_DTDIGIT,5,2)+'/'+SUBSTRING(D1_DTDIGIT,1,4)) 'EMISSNF', "
		cQuery+="        C5_CLIENTE 'CODCLI',  "
		cQuery+="        C5_LOJACLI 'LOJA',  "
		cQuery+="        A1_NOME 'CLIENTE',  "
		cQuery+="        A1_MUN 'CIDADE',  "
		cQuery+="        A1_EST 'UF',  "
		cQuery+="        A1_CEP 'CEP',  "

		//If lAdm
		cQuery+="        SUM(D1_TOTAL*(-1)) 'VALORPV', "
		cQuery+="		SUM(D1_TOTAL*(-1))'VALORNF', "
		cQuery+="        SUM(D1_VALICM*(-1)) 'VLRICMS', "
		cQuery+="        SUM(D1_ICMSRET*(-1)) 'VLRST', "
		cQuery+="        SUM(D1_VALISS*(-1)) 'VLRISS', "
		//EndIf

		cQuery+="		((SUM(D1_TOTAL) - SUM(D1_VALICM) - SUM(D1_ICMSRET) - SUM(D1_VALISS) )*(-1)) 'VALORLIQ' "

		cQuery+="		from SD1010 SD1 "
		cQuery+="		INNER JOIN SF4010 SF4 ON F4_CODIGO = D1_TES AND F4_DUPLIC = 'S' AND SF4.D_E_L_E_T_=''  "
		cQuery+="		INNER JOIN SA1010 SA1 ON A1_COD = D1_FORNECE AND A1_LOJA = D1_LOJA AND SA1.D_E_L_E_T_='' "
		cQuery+="		INNER JOIN SC6010 SC6 on C6_FILIAL = D1_FILIAL and C6_NOTA = D1_NFORI and C6_SERIE = D1_SERIORI AND C6_PRODUTO = D1_COD AND SC6.D_E_L_E_T_= ' ' AND D1_ITEMORI = C6_ITEM "
		cQuery+="		INNER JOIN SD2010 SD2 ON D2_FILIAL = D1_FILIAL AND D2_DOC = D1_NFORI AND D2_SERIE = D1_SERIORI AND D2_ITEM = D1_ITEMORI AND SD2.D_E_L_E_T_= ' ' "
		cQuery+="		INNER JOIN SC5010 SC5 ON C5_FILIAL = C6_FILIAL AND C5_NUM = C6_NUM AND SC5.D_E_L_E_T_ = '' "

		//AND C5_VEND1 BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
		cQuery+="		INNER JOIN SUA010 SUA ON UA_FILIAL = C5_FILIAL AND UA_NUMSC5 = C5_NUM AND SUA.D_E_L_E_T_='' "

		If lAdm
			cQuery+="        AND UA_VEND BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'  " //ERA O CAMPO C5_VEND1 a Elisangela disse que deveria ser o Operador UA_VEND
			cQuery+="        AND UA_OPERADO BETWEEN '"+MV_PAR06+"' AND '"+MV_PAR07+"'  "
		Else
			//cQuery+="        AND (C5_VEND1 = '"+Posicione("SU7",4,xFilial("SU7")+RetCodUsr(),"U7_CODVEN")+"'  "
			cQuery+="        AND (UA_VEND = '"+Posicione("SU7",4,xFilial("SU7")+RetCodUsr(),"U7_CODVEN")+"'  "
			cQuery+="        OR UA_OPERADO = '"+Posicione("SU7",4,xFilial("SU7")+RetCodUsr(),"U7_COD")+"')  "
		EndIf

		cQuery+="		WHERE D1_DTDIGIT >= '"+DTOS(MV_PAR03)+"' and D1_DTDIGIT <= '"+DTOS(MV_PAR04)+"' and SD1.D_E_L_E_T_ = ' ' and D1_TIPO in ('B','D') "
		cQuery+="		GROUP BY C5_VEND1, UA_OPERADO ,C5_NUM, C5_NOTA, C5_SERIE, C5_EMISSAO, A1_NOME, A1_MUN, A1_EST, A1_CEP, C5_CLIENTE, C5_LOJACLI "

	EndIf

	//cQuery+="		ORDER BY [CODVEND], [CODOPER], [PEDIDO], [NOTA], [SERIE], [EMISSNF], [CLIENTE], [CIDADE], [CEP], [CODCLI], [LOJA] "
	cQuery+= " ORDER BY 2,3,4,5 "

	cQuery := ChangeQuery(cQuery)
	MemoWrite("C:\temp\RTMKR04.txt",cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasNew,.T.,.T.)

	Count to nCount

	For nX := 1 To Len(aStruSUA)
		If aStruSUA[nX][2] <> "C" .and.  FieldPos(aStruSUA[nX][1]) > 0
			TcSetField(cAliasNew,aStruSUA[nX][1],aStruSUA[nX][2],aStruSUA[nX][3],aStruSUA[nX][4])
		EndIf
	Next nX

	oReport:SetMeter((cAliasNew)->(LastRec()))

	oReport:SetTitle(cTitulo)

	(cAliasNew)->(dbGoTop())
	While (cAliasNew)->(!Eof())

		If oReport:Cancel()
			Exit
		EndIf

		//inicializo a primeira seção
		oSection1:Init()

		oReport:IncMeter()

		nY++

		IncProc("Imprimindo Relatorio")

		If MV_PAR05 == 2
			oSection1:Cell("ORIG"):SetValue((cAliasNew)->ORIG)
			oSection1:Cell("CODVEND"):SetValue((cAliasNew)->CODVEND)
			oSection1:Cell("NOMEVEND"):SetValue((cAliasNew)->NOMEVEND)
			oSection1:Cell("CODOPER"):SetValue((cAliasNew)->CODOPER)
			oSection1:Cell("NOMEOPER"):SetValue((cAliasNew)->NOMEOPER)
			oSection1:Cell("PEDIDO"):SetValue((cAliasNew)->PEDIDO)
			oSection1:Cell("EMISSPV"):SetValue((cAliasNew)->EMISSPV)
			oSection1:Cell("NOTA"):SetValue((cAliasNew)->NOTA)
			oSection1:Cell("SERIE"):SetValue((cAliasNew)->SERIE)
			oSection1:Cell("EMISSNF"):SetValue((cAliasNew)->EMISSNF)
			oSection1:Cell("CODCLI"):SetValue((cAliasNew)->CODCLI)
			oSection1:Cell("LOJA"):SetValue((cAliasNew)->LOJA)
			oSection1:Cell("CLIENTE"):SetValue((cAliasNew)->CLIENTE)
			oSection1:Cell("CIDADE"):SetValue((cAliasNew)->CIDADE)
			oSection1:Cell("UF"):SetValue((cAliasNew)->UF)
			oSection1:Cell("CEP"):SetValue((cAliasNew)->CEP)

			If lAdm
				oSection1:Cell("VALORPV"):SetValue((cAliasNew)->VALORPV)
				oSection1:Cell("VALORNF"):SetValue((cAliasNew)->VALORNF)
				oSection1:Cell("VLRISS"):SetValue((cAliasNew)->VLRISS)
				oSection1:Cell("VLRICMS"):SetValue((cAliasNew)->VLRICMS)
				oSection1:Cell("VLRST"):SetValue((cAliasNew)->VLRST)

			EndIf

			oSection1:Cell("VALORLIQ"):SetValue((cAliasNew)->VALORLIQ)

			oSection1:Printline()

		Else

			If Empty(cAux)
				cAux := ( (cAliasNew)->CODVEND + (cAliasNew)->NOMEVEND + (cAliasNew)->CODOPER + (cAliasNew)->NOMEOPER )

				cCodVend := (cAliasNew)->CODVEND
				cNomVend := (cAliasNew)->NOMEVEND
				cCodOper := (cAliasNew)->CODOPER
				cNomOper := (cAliasNew)->NOMEOPER

			EndIf

			If cAux <> ( (cAliasNew)->CODVEND + (cAliasNew)->NOMEVEND + (cAliasNew)->CODOPER + (cAliasNew)->NOMEOPER ) .OR. nY == nCount
				cAux := ( (cAliasNew)->CODVEND + (cAliasNew)->NOMEVEND + (cAliasNew)->CODOPER + (cAliasNew)->NOMEOPER )

				If nY == nCount
					nTotPed += (cAliasNew)->VALORPV
					nTotNF  += (cAliasNew)->VALORNF
					nTotICM += (cAliasNew)->VLRICMS
					nTotST  += (cAliasNew)->VLRST
					nTotIss += (cAliasNew)->VLRISS
				EndIf

				oSection1:Cell("CODVEND"):SetValue(cCodVend)
				oSection1:Cell("NOMEVEND"):SetValue(cNomVend)
				oSection1:Cell("CODOPER"):SetValue(cCodOper)
				oSection1:Cell("NOMEOPER"):SetValue(cNomOper)


				If lAdm
					oSection1:Cell("VALORPV"):SetValue(nTotPed)
					oSection1:Cell("VALORNF"):SetValue(nTotNF)
					oSection1:Cell("VLRISS"):SetValue(nTotIss)
					oSection1:Cell("VLRICMS"):SetValue(nTotICM)
					oSection1:Cell("VLRST"):SetValue(nTotST)
				EndIf

				nTotLiq := nTotNF - nTotICM - nTotST - nTotIss

				oSection1:Cell("VALORLIQ"):SetValue(nTotLiq)

				nTotPed := 0
				nTotNF  := 0
				nTotICM := 0
				nTotST  := 0
				nTotIss := 0
				nTotLiq := 0

				cCodVend := (cAliasNew)->CODVEND
				cNomVend := (cAliasNew)->NOMEVEND
				cCodOper := (cAliasNew)->CODOPER
				cNomOper := (cAliasNew)->NOMEOPER

				oSection1:Printline()


			EndIf


			nTotPed += (cAliasNew)->VALORPV
			nTotNF  += (cAliasNew)->VALORNF
			nTotICM += (cAliasNew)->VLRICMS
			nTotST  += (cAliasNew)->VLRST
			nTotIss += (cAliasNew)->VLRISS



		EndIf


		DbSelectArea(cAliasNew)
		(cAliasNew)->(dbSkip())

	EndDo

	oReport:ThinLine()

//finalizo a primeira seção
	oSection1:Finish()

	IF Select(cAliasNew) <> 0
		DbSelectArea(cAliasNew)
		DbCloseArea()
	ENDIF


return

