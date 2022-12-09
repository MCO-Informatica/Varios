#include "rwmake.ch"
#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "PRTOPDEF.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.CH"
#INCLUDE "DBSTRUCT.CH"
#INCLUDE "COMMON.CH"
#include "ap5mail.ch"
#Include "tbicode.ch"

User Function GERBOL()
	Local _cRotina  := "RFINR002"
	Local cPerg     := _cRotina
	Local aSe1   	:= {}
	Local aSee		:= {}
	Local cQuery	:= GetNextAlias()
	Local lEmail	:= .F.
	Local nZ,nY

	If !Pergunte(cPerg,.T.)
		Return
	Endif

	//Configuração Itaú
	cCart 	:= '109'
	AaDD(aSee, {MV_PAR08,;
		MV_PAR09,;
		MV_PAR10,;
		MV_PAR11})

	DbSelectArea("SE1")
	SE1->(DbSetOrder(1))

	BeginSQL Alias cQuery
		SELECT
			E1_TIPO,
			E1_PREFIXO,
			E1_NUM,
			E1_PARCELA,
			E1_CLIENTE,
			E1_LOJA,
			E1_TIPO,
			E1_EMISSAO EMIS,
			E1_VENCREA VENCREA,
			REPLACE(
				CONVERT(VARCHAR, CONVERT(DATE, E1_EMISSAO, 103), 103),
				'/',
				'/'
			) E1_EMISSAO,
			REPLACE(
				CONVERT(VARCHAR, CONVERT(DATE, E1_VENCREA, 103), 103),
				'/',
				'/'
			) E1_VENCREA,
			E1_VALOR,
			E1_CLIENTE,
			E1_NUMBCO,
			E1_DECRESC,
			E1_ACRESC,
			E1_VLCRUZ,
			E1_JUROS,
			E1_DESCONT,
			E1_ACRESC
		FROM
			%Table:SE1% SE1
		INNER JOIN %Table:FRV% FRV
		ON FRV.FRV_FILIAL = %xFilial:FRV%
			AND FRV.FRV_CODIGO = SE1.E1_SITUACA
			AND FRV.FRV_YGERBO != '2'
			AND FRV.D_E_L_E_T_ = ' '
		WHERE
			E1_FILIAL = %xFilial:SE1% 
			AND E1_PREFIXO BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
			AND E1_NUM BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
			AND E1_NUMBOR BETWEEN %Exp:MV_PAR05% AND %Exp:MV_PAR06%
			AND E1_SALDO > 0
			AND E1_TIPO <> 'CH'
			AND E1_PORTADO = %Exp:MV_PAR08%
			AND (
				E1_AGEDEP = ''
				OR E1_AGEDEP = %Exp:MV_PAR09%
			)
			AND (
				E1_CONTA = ''
				OR E1_CONTA = %Exp:MV_PAR10%
			)
			AND SE1.D_E_L_E_T_ = ''
		ORDER BY
			E1_NUM,
			E1_PARCELA
	EndSQL

	(cQuery)->(DBGoTop())
	While (cQuery)->(!EOF())
		AaDD(aSe1, {(cQuery)->(E1_PREFIXO)	,;
			(cQuery)->(E1_NUM)     	,;
			(cQuery)->(E1_PARCELA)	,;
			(cQuery)->(E1_TIPO)    	})
		(cQuery)->(dbSkip())
	EndDo

	If Select("cQuery") > 0
		DbSelectArea("cQuery")
		DbCloseArea()
	EndIf

	IF LEN(aSE1) >=1
		If MsgYesNo('Deseja enviar boletos por email para os clientes?','Envio de Boletos')
			lEmail	:= .T.
			cDirPDF			:= "/BOL_ITAU/"
		else
			cDirPDF			:= "C:\Temp\BOL_ITAU\"
		EndIf

		If ExistDir(cDirPDF)
			aFiles := Directory(cDirPDF + "*.*")
			For nY := 1 to Len(aFiles)
				Ferase(cDirPDF + aFiles[nY][1])
			Next nY
		Else
			Makedir(cDirPDF)
		Endif

		For nZ := 1 to Len(aSe1)
			MsgRun("Gerando boleto " + Alltrim(Str(nZ)) + " de " + Alltrim(Str(Len(aSe1))) + ".","Gera Boletos",{|| U_BOLITAU(aSe1[nZ],aSee,cCart,cDirPDF) })
		Next nZ

		If lEmail
			U_ENVBOL()
		else
			MsgInfo('Boleto(s) gerado(s) na pasta ' + cDirPdf,"Gera Boletos")
		EndIf

		//Limpa arquivos .rel
		aFiles := Directory(cDirPDF + "*.rel")
		For nY := 1 to Len(aFiles)
?			Ferase(cDirPDF + aFiles[nY][1])
		Next nY
	Else
		MsgAlert("Atenção... Não foram encontrados títulos com o filtro selecionado." , "Alerta" )
	ENDIF
Return()
