#INCLUDE "PROTHEUS.CH"
#Include "TOTVS.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RELFIS001  º Autor ³Junior Carvalho     º Data ³  11/04/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Relatorio Notas de Entrada e Saida                           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function RELFIS001()

	Local oSay := NIL // CAIXA DE DIÁLOGO GERADA
	Local aPergs := {}
	Local cTitulo := "Relatorio Notas de Entrada e Saida  "
	Private lRet := .F.
	Private aItExcel := {}
	Private aRet := {}

	aAdd( aPergs ,{1,"Filial De    ",Space(02),"@!",'.T.',"XM0",'.T.',60,.F.})
	aAdd( aPergs ,{1,"Filial Ate   ",Space(02),"@!",'.T.',"XM0",'.T.',60,.T.})
	Aadd( aPergs ,{1,"Emissão De     ",FirstDate(dDatabase) ,"@E 99/99/9999","","","",100,.F.})
	Aadd( aPergs ,{1,"Emissão Ate  ",LastDate(dDatabase)  ,"@E 99/99/9999","","","",100,.T.})

	If ParamBox(aPergs ," Parametros - "+cTitulo,aRet)

		FwMsgRun(NIL, {|oSay| GeraItens(oSay)}, "Processando "+cTitulo, "Selecionando os Registros... ")

		if lRet
			FwMsgRun(NIL, {|oSay| GERAEXCEL(oSay)}, "Processando "+cTitulo, "Exportando os Registros para o Excel... ")
		Else
			Aviso( cTitulo,"Nenhum dado gerado! Verifique os parametros utilizados.",{"OK"},3)
		Endif

	Else
		Aviso(cTitulo,"Pressionado Cancela",{"OK"},1)
	EndIf

Return()

Static Function GeraItens( oSay )

	local cAlias := GetNextAlias()

	BEGINSQL ALIAS cAlias
	SELECT * FROM (

SELECT
             D1_FILIAL ,
	CASE WHEN FT_TIPOMOV IS NULL THEN 'E' ELSE FT_TIPOMOV END FT_TIPOMOV ,
             TO_CHAR(TO_DATE(D1_DTDIGIT,'YYYYMMDD'),'DD/MM/YYYY') D1_DTDIGIT,
             TO_CHAR(TO_DATE(D1_EMISSAO,'YYYYMMDD'),'DD/MM/YYYY') D1_EMISSAO,
			 D1_FORNECE, D1_LOJA, D1_COD, B1_DESC, D1_DOC, D1_SERIE, 
			 FT_ESTADO, D1_CF, FT_ALIQICM, FT_VALCONT, FT_BASEICM, 
			 FT_VALICM, FT_ISENICM, FT_OUTRICM, FT_BASEIPI, FT_VALIPI,
			 FT_ISENIPI, FT_OUTRIPI, FT_BASERET, FT_ICMSRET, FT_BASEPIS, 
			 FT_ALIQPIS, FT_VALPIS, FT_BASECOF, FT_ALIQCOF, FT_VALCOF, 
			 FT_OBSERV, FT_NFORI, FT_CODISS, FT_ESPECIE, FT_TIPO, 
			 FT_CLASFIS, FT_POSIPI, FT_CSTCOF, FT_CSTPIS, D1_CONHEC, 
			 D1_NFRENT, D1_SERENT, D1_NFRSAI, D1_SERSAI, D1_VALICM VALICM, 
			 D1_VALIPI   VALIPI, D1_VALIRR   VALIRR, D1_VALISS VALISS, 
			 D1_VALINS   VALINS, D1_VALPIS   VALPIS, D1_VALCOF VALCOF, 
			 D1_VALCSL   VALCSL, D1_TES, D1_QUANT, D1_TIPO TIPO, D1_TOTAL TOTAL
         FROM
             %table:SD1%  SD1
             LEFT JOIN %table:SFT%  SFT ON
             FT_TIPOMOV = 'E'
             AND FT_CLIEFOR = D1_FORNECE
             AND FT_LOJA = D1_LOJA
             AND FT_NFISCAL = D1_DOC
             AND FT_SERIE = D1_SERIE
             AND FT_ITEM = D1_ITEM     
             AND FT_FILIAL = D1_FILIAL             
             AND SFT.D_E_L_E_T_ = ' '
             
             LEFT JOIN %table:SB1%  SB1 ON 
             B1_FILIAL = '  '
             AND B1_COD = D1_COD
             AND SB1.D_E_L_E_T_ = ' '

             WHERE SD1.D_E_L_E_T_ = ' '
             AND D1_DTDIGIT BETWEEN  %exp:dtos(aRet[3])%   AND  %exp:dtos(aRet[4])% 
             AND D1_FILIAL BETWEEN %exp:aRet[1]%   AND  %exp:aRet[2]% 

		UNION ALL

			SELECT
			FT_FILIAL	,
			CASE WHEN FT_TIPOMOV IS NULL THEN 'S' ELSE FT_TIPOMOV END FT_TIPOMOV,
			to_char (to_date(FT_ENTRADA,'YYYYMMDD'), 'DD/MM/YYYY') FT_ENTRADA	,
			to_char (to_date(FT_EMISSAO,'YYYYMMDD'), 'DD/MM/YYYY') FT_EMISSAO	,
			FT_CLIEFOR,FT_LOJA,	FT_PRODUTO,B1_DESC,FT_NFISCAL,FT_SERIE,FT_ESTADO,FT_CFOP,FT_ALIQICM,
			FT_VALCONT, FT_BASEICM, FT_VALICM , FT_ISENICM,FT_OUTRICM ,FT_BASEIPI,FT_VALIPI,FT_ISENIPI,
			FT_OUTRIPI, FT_BASERET, FT_ICMSRET, FT_BASEPIS,FT_ALIQPIS ,FT_VALPIS ,FT_BASECOF,FT_ALIQCOF,
			FT_VALCOF, FT_OBSERV,FT_NFORI ,	FT_CODISS, FT_ESPECIE,FT_TIPO,FT_CLASFIS,FT_POSIPI	,FT_CSTCOF,FT_CSTPIS,
			' ' D1_CONHEC,' ' D1_NFRENT,' ' D1_SERENT ,' ' D1_NFRSAI ,' ' D1_SERSAI ,
			D2_VALICM VALICM, D2_VALIPI VALIPI, D2_VALIRRF VALIRR, D2_VALISS VALISS, D2_VALINS VALINS,
			D2_VALPIS VALPIS, D2_VALCOF VALCOF, D2_VALCSL VALCSL, D2_TES, D2_QUANT, D2_TIPO TIPO, D2_TOTAL TOTAL

			FROM %table:SFT%  SFT, %table:SB1%  SB1, %table:SD2%  SD2
			WHERE B1_FILIAL = %exp:xFilial("SB1")%   AND B1_COD = FT_PRODUTO AND SB1.D_E_L_E_T_ = ' '
			AND SD2.D_E_L_E_T_ = ' ' AND D2_FILIAL = FT_FILIAL AND D2_DOC = FT_NFISCAL 
			AND D2_SERIE = FT_SERIE AND D2_ITEM = FT_ITEM
			AND FT_CLIEFOR = D2_CLIENTE AND FT_LOJA = D2_LOJA
			AND FT_TIPOMOV = 'S'
			AND FT_ENTRADA BETWEEN   %exp:dtos(aRet[3])%   AND  %exp:dtos(aRet[4])% 
			AND FT_FILIAL BETWEEN   %exp:aRet[1]%   AND  %exp:aRet[2]% 
			AND SFT.D_E_L_E_T_ = ' '

		) ORDER BY 1,2

	ENDSQL
	//aresult := GetLastQuery()
	DbSelectArea(cAlias)

	(cAlias)->(DbGoTop())

	While !(cAlias)->(EOF())

		cNatureza := " "
		dVenc := stod(" ")

		oSay:SetText(" Nota Fiscal nº " + (cAlias)->D1_DOC + " . . .")
		ProcessMessage()

		IF (cAlias)->FT_TIPOMOV == 'E'
			If (cAlias)->TIPO $ "D|B"
				SA1->(dbSetOrder(1))
				SA1->(MsSeek( xFilial("SA1") + (cAlias)->D1_FORNECE + (cAlias)->D1_LOJA ))
				cTipo := 'CLIENTE'
				cCNPJ := SA1->A1_CGC
				cMun := SA1->A1_MUN
				cRazao := SA1->A1_NOME
			Else
				SA2->(dbSetOrder(1))
				SA2->(MsSeek( xFilial("SA2") + (cAlias)->D1_FORNECE + (cAlias)->D1_LOJA ))
				cTipo := 'FORNECEDOR'
				cCNPJ := SA2->A2_CGC
				cMun := SA2->A2_MUN
				cRazao := SA2->A2_NOME
			EndIf

			cquery := "SELECT E2_NATUREZ, E2_VENCTO "
			cQuery += "FROM " + RetSqlName("SE2")+ " SE2 "
			cQuery += "WHERE SE2.E2_FORNECE='" + (cAlias)->D1_FORNECE + "' AND "
			cQuery += "SE2.E2_LOJA='" +(cAlias)->D1_LOJA + "' AND "
			cQuery += "SE2.E2_NUM='" + (cAlias)->D1_DOC + "' AND "
			cQuery += "SE2.E2_PREFIXO='" + (cAlias)->D1_SERIE + "' AND "
			cQuery += "SE2.E2_TIPO='NF ' AND "
			cQuery += "SE2.E2_FILIAL= '" + (cAlias)->D1_FILIAL+ "' AND "
			cQuery += "SE2.D_E_L_E_T_ = ' ' "
			cQuery:= ChangeQuery(cQuery)

			DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRBSE2",.T.,.F.)

			cNatureza 		:= TRBSE2->E2_NATUREZ
			cDescNaturez	:= Posicione("SED",1,xFilial("SED")+cNatureza,"ED_DESCRIC")
			
			dVenc :=  STOD(TRBSE2->E2_VENCTO)

			TRBSE2->(dbCloseArea())

		ELSE

			If (cAlias)->TIPO $ "D|B"

				SA2->(dbSetOrder(1))
				SA2->(MsSeek( xFilial("SA2") + (cAlias)->D1_FORNECE + (cAlias)->D1_LOJA ))
				cTipo := 'FORNECEDOR'
				cCNPJ := SA2->A2_CGC
				cMun := SA2->A2_MUN
				cRazao := SA2->A2_NOME

			Else

				SA1->(dbSetOrder(1))
				SA1->(MsSeek( xFilial("SA1") + (cAlias)->D1_FORNECE + (cAlias)->D1_LOJA ))
				cTipo := 'CLIENTE'
				cCNPJ := SA1->A1_CGC
				cMun := SA1->A1_MUN
				cRazao := SA1->A1_NOME
			EndIf
		ENDIF

		DbSelectArea(cAlias)

		aAdd(aItExcel,{ (cAlias)->D1_FILIAL,  (cAlias)->FT_TIPOMOV,  (cAlias)->D1_DTDIGIT, (cAlias)->D1_EMISSAO, ;
			(cAlias)->D1_FORNECE, (cAlias)->D1_LOJA, cTipo, cRazao,cCNPJ, cMun,  (cAlias)->D1_COD,;
			(cAlias)->B1_DESC,  (cAlias)->D1_DOC, (cAlias)->D1_SERIE,  (cAlias)->FT_ESTADO, ;
			(cAlias)->D1_CF,  (cAlias)->FT_ALIQICM, (cAlias)->FT_VALCONT,  (cAlias)->FT_BASEICM,;
			(cAlias)->FT_VALICM,  (cAlias)->FT_ISENICM, (cAlias)->FT_OUTRICM,  (cAlias)->FT_BASEIPI, ;
			(cAlias)->FT_VALIPI, (cAlias)->FT_ISENIPI, (cAlias)->FT_OUTRIPI, (cAlias)->FT_BASERET,;
			(cAlias)->FT_ICMSRET, (cAlias)->FT_BASEPIS,(cAlias)->FT_ALIQPIS, (cAlias)->FT_VALPIS,;
			(cAlias)->FT_BASECOF, (cAlias)->FT_ALIQCOF, (cAlias)->FT_VALCOF, (cAlias)->FT_OBSERV,;
			(cAlias)->FT_NFORI, (cAlias)->D1_CONHEC,(cAlias)->D1_NFRENT, (cAlias)->D1_SERENT, ;
			(cAlias)->D1_NFRSAI, (cAlias)->D1_SERSAI, (cAlias)->FT_CODISS, (cAlias)->FT_ESPECIE,;
			(cAlias)->FT_TIPO, (cAlias)->FT_CLASFIS, (cAlias)->FT_POSIPI, (cAlias)->FT_CSTCOF,;
			(cAlias)->FT_CSTPIS,(cAlias)->VALICM, (cAlias)->VALIPI, (cAlias)->VALIRR, (cAlias)->VALISS,;
			(cAlias)->VALINS, (cAlias)->VALPIS, (cAlias)->VALCOF, (cAlias)->VALCSL, (cAlias)->D1_TES,;
			(cAlias)->D1_QUANT,(cAlias)->TOTAL, cNatureza ,cDescNaturez,dVenc })

		(cAlias)->(DbSkip())
		lRet := .T.

	ENDDO

	(cAlias)->(DbCloseArea())
	MsErase(cAlias)

RETURN()

Static Function GERAEXCEL(oSay)

	Local ni := 0
	Local nj := 0
	local aCabec := {}
	Local cPlan := "Arquivo"
	Local cTab := 'Periodo de '+DTOC(aRet[3])+" ate "+DTOC(aRet[4])
	PRIVATE oExcel := FWMSEXCEL():New()

	aAdd( aCabec, { "Filial", "C","@!" })
	aAdd( aCabec, { "Tipo Mov",  "C","@!" })
	aAdd( aCabec, { "Data Entrada", "C","@!"})
	aAdd( aCabec, { "Data emissão", "C","@!"})
	aAdd( aCabec, { "Cliente / Fornecedor",  "C","@!" })
	aAdd( aCabec, { "Loja ", "C","@!" })
	aAdd( aCabec, { "Conta ", "C","@!" })
	aAdd( aCabec, { "Razão SOcial", "C","@!" })
	aAdd( aCabec, { "CNPJ", "C","@!" })
	aAdd( aCabec, { "Municipio", "C","@!" })

	aAdd( aCabec, { "Cod. Produto" , "C","@!" })
	aAdd( aCabec, { "Descrição" , "C","@!" })
	aAdd( aCabec, { "Nota Fiscal" , "C","@!" })
	aAdd( aCabec, { "Serie" , "C","@!" })
	aAdd( aCabec, { "Estado" , "C","@!" })
	aAdd( aCabec, { "CFOP" , "C","@!" })

	aAdd( aCabec, { "Aliq. ICMS", "N","@E 999.99"})
	aAdd( aCabec, { "Valor Contabil", "N","@E 999,999,999.99"})
	aAdd( aCabec, { "Base ICMS", "N","@E 999,999,999.99"})
	aAdd( aCabec, { "Valor ICMS", "N","@E 999,999,999.99"})

	aAdd( aCabec, { "Vlr Isen ICM", "N","@E 999,999.99"})
	aAdd( aCabec, { "Vlr Out ICMS", "N","@E 999,999,999.99"})

	aAdd( aCabec, { "Base IPI", "N","@E 999,999,999.99"})
	aAdd( aCabec, { "Valor IPI", "N","@E 999,999,999.99"})
	aAdd( aCabec, { "Vlr Isen IPI", "N","@E 999,999.99"})
	aAdd( aCabec, { "Vlr Out IPI", "N","@E 999,999,999.99"})

	aAdd( aCabec, { "Vlr Base Ret", "N","@E 999,999,999.99"})
	aAdd( aCabec, { "Vlr ICMS Ret", "N","@E 999,999,999.99"})

	aAdd( aCabec, { "Base PIS", "N","@E 999,999,999.99"})
	aAdd( aCabec, { "Aliq. PIS", "N","@E 999,999,999.99"})
	aAdd( aCabec, { "Valor PIS", "N","@E 999,999,999.99"})

	aAdd( aCabec, { "Base COFINS", "N","@E 999,999,999.99"})
	aAdd( aCabec, { "Aliq. COFINS", "N","@E 999,999,999.99"})
	aAdd( aCabec, { "Valor COFINS", "N","@E 999,999,999.99"})

	aAdd( aCabec, { "Observação" , "C","@!" })
	aAdd( aCabec, { "HAWB" , "C","@!" })
	aAdd( aCabec, { "Nota Origem" , "C","@!" })
	aAdd( aCabec, { "Nota de Entrada" , "C","@!" })
	aAdd( aCabec, { "Serie Nf Entrada" , "C","@!" })
	aAdd( aCabec, { "Nota de Saida" , "C","@!" })
	aAdd( aCabec, { "Serie Nf Saida" , "C","@!" })

	aAdd( aCabec, { "Cod. ISS" , "C","@!" })
	aAdd( aCabec, { "Especie" , "C","@!" })
	aAdd( aCabec, { "Tipo" , "C","@!" })
	aAdd( aCabec, { "Classif. Fiscal" , "C","@!" })
	aAdd( aCabec, { "NCM" , "C","@!" })
	aAdd( aCabec, { "CST COF" , "C","@!" })
	aAdd( aCabec, { "CST Pis" , "C","@!" })

	aAdd( aCabec, { "Valor ICMS DOC" , "N","@E 999,999,999.99"})
	aAdd( aCabec, { "Valor IPI DOC" , "N","@E 999,999,999.99"})

	aAdd( aCabec, { "Valor IRRF" , "N","@E 999,999,999.99"})
	aAdd( aCabec, { "Valor do ISS" , "N","@E 999,999,999.99"})
	aAdd( aCabec, { "Vlr. do INSS" , "N","@E 999,999,999.99"})
	aAdd( aCabec, { "Valor Pis " , "N", "@E 999,999,999.99"})
	aAdd( aCabec, { "Valor Cofins" , "N","@E 999,999,999.99"})
	aAdd( aCabec, { "Valor CSLL " , "N","@E 999,999,999.99"})
	aAdd( aCabec, { "Tipo Entrada" , "C","@!" })
	aAdd( aCabec, { "Quantidade" , "N","@E 999,999,999.99"})
	aAdd( aCabec, { "Total" , "N","@E 999,999,999.99"})
	
	aAdd( aCabec, { "Natureza" , "C","@!" })
	aAdd( aCabec, { "Desc Natureza" , "C","@!" })
	aAdd( aCabec, { "Vencimento" , "D"," "})

	oExcel:AddworkSheet(cPlan)
	oExcel:AddTable(cPlan,cTab)
	aCab := ACLONE(aCabec)
	aItens := ACLONE(aItExcel)

	For ni := 1 to len(aCab)
		nAl := 1 // Alinha: Esquerda
		nTp := 1 // Tipo: Normal
		If aCab[ni,2] == "D"
			nAl := 2 // Alinha: Centralizado
			nTp := 4 // Tipo: Data
		ElseIf aCab[ni,2] == "L"
			nAl := 2 // Alinha: Centralizado
			nTp := 1 // Tipo: Normal
		ElseIf aCab[ni,2] == "N"
			nAl := 3 // Alinha: Direita
			nTp := 2 // Tipo: Numero
		EndIf
		oExcel:AddColumn(cPlan,cTab,aCab[ni,1],nAl,nTp)
	Next

	For ni := 1 to len(aItens)

		oSay:SetText("Gerando Excel Linha - " + StrZero(ni, 6))
		ProcessMessage()

		aColunas := {}
		For nj := 1 to len(aItens[ni])
			If aCab[nj,2] == "C"
				aAdd(aColunas,Transform(aItens[ni,nj],aCab[nj,3]))
			ElseIf aCab[nj,2] $ "N/D"
				aAdd(aColunas,aItens[ni,nj])
			ElseIf aCab[nj,2] == "L"
				aAdd(aColunas,IIf(aItens[ni,nj],".T.",".F."))
			EndIf
		Next

		If len(aColunas) > 0
			oExcel:AddRow(cPlan,cTab,aColunas)
		EndIf

	Next

	oExcel:Activate()
	cPathCli := GetTempPath(.T.)
	//cArq := &("cGetFile( '*.xml' , '*.xml' , 1 , 'SERVIDOR' , .F. , "+str(nOR( GETF_LOCALHARD , GETF_LOCALFLOPPY , GETF_RETDIRECTORY ))+" , .T. , .T. )")
	cArqXml := cPathCli+"Relatorio_Fiscal_"+Dtos(MSDate())+"_"+StrTran(Time(),":","")+".XML"

	If !Empty(cArqXml)
		oExcel:GetXMLFile(cArqXml)
		If !ApOleClient("MsExcel")
			MsgStop("Microsoft Excel não instalado!","Atencao")
			Return
		EndIf

		oExcelVer:= MsExcel():New()
		oExcelVer:WorkBooks:Open(cArqXml)
		MsgAlert("Arquivo gerado com sucesso!"+CHR(13)+CHR(10)+CHR(13)+CHR(10)+cArqXml,"RELFIS001")
		Sleep(100)
		oExcelVer:SetVisible(.T.)

	EndIf

Return()
