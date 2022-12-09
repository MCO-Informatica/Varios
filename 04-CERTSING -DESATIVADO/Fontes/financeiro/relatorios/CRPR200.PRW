#Include "totvs.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CRPR200  º Autor ³ RENATO RUY BERNARDO  º Data ³ 11/07/17  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Relatorio para vincular Pedidos x Tabela de Preco.		  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Certisign                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/ 
User Function CRPR200

Local aPergs	:= {}

Private aRet	:= {}
Private cPerg   := "CRP200"

//Perguntas do parambox
aAdd( aPergs ,{1 ,"Periodo " 	 	,RTrim(GetMv("MV_REMMES")),"","","","",50,.F.})
aAdd( aPergs ,{6 ,"Gravar arquivo" 	,Space(180)				  ,"","","",50,.F.,"Arquivos .CSV |*.CSV"})

If !ParamBox(aPergs ,"Parametros ",aRet)
	Alert("O relatório foi cancelado!")
	Return
EndIf

Processa( {|| CRPR200R() }, "Relatorio de Pedido x Tabela")

Return

//Renato Ruy - 11/07/2017
//Funcao que gera o relatorio em arquivo.
Static Function CRPR200R()

Local cArqLog := aRet[2]
Local cLog	  := ""
Local nCount  := 0

// Cria um novo arquivo.
nHandle := fCreate(cArqLog)

//Caso não encontre o arquivo o sistema cria
If nHandle == -1
	Alert("O arquivo não pode ser criado porque esta aberto ou sem acesso a gravação no diretório!")
	Return
Endif

IncProc( "Selecionando dados....." )
ProcessMessage() 

//Efetua Consulta no Banco
Beginsql Alias "TMP200"
	SELECT	DECODE(Z6_PEDGAR,'          ',Z6_PEDSITE,Z6_PEDGAR) PEDIDO,
			Z6_PRODUTO PRODUTO,
			Z6_GRUPO CODIGO_PROJETO,
			Z6_DESGRU DESCRICAO_PROJETO,
			Z6_CODVOU CODIGO_VOUCHER,
			ZH_DESCRI TIPO_VOUCHER,
			DA1_CODTAB CODIGO_TABELA,
			DA0_DESCRI DESCRICAO_TABELA
	FROM SZ6010 SZ6
			LEFT JOIN SZH010 SZH
			ON ZH_FILIAL       = ' '
			AND ZH_TIPO        = Z6_TIPVOU
			AND SZH.D_E_L_E_T_ = ' '
	LEFT JOIN SZ3010 SZ3
			ON Z3_FILIAL       = ' '
			AND Z3_CODGAR      = Z6_GRUPO
			AND Z3_TIPENT      = '5'
			AND SZ3.D_E_L_E_T_ = ' '
	LEFT JOIN DA0010 DA0
			ON DA0_FILIAL      = ' '
			AND (DA0_CODTAB    = SUBSTR(Z3_CODTAB,1,3)
			OR DA0_CODTAB      = SUBSTR(Z3_CODTAB,5,3)
			OR DA0_CODTAB      = SUBSTR(Z3_CODTAB,9,3)
			OR DA0_CODTAB      = SUBSTR(Z3_CODTAB,13,3)
			OR DA0_CODTAB      = SUBSTR(Z3_CODTAB,17,3)
			OR DA0_CODTAB      = SUBSTR(Z3_CODTAB,21,3)
			OR DA0_CODTAB      = SUBSTR(Z3_CODTAB,25,3)
			OR DA0_CODTAB      = SUBSTR(Z3_CODTAB,29,3)
			OR DA0_CODTAB      = SUBSTR(Z3_CODTAB,34,3)
			OR DA0_CODTAB      = SUBSTR(Z3_CODTAB,38,3)
			OR DA0_CODTAB      = SUBSTR(Z3_CODTAB,11,3)
			OR DA0_CODTAB      = SUBSTR(Z3_CODTAB,15,3))
			AND DA0.D_E_L_E_T_ = ' '
	JOIN DA1010 DA1
			ON DA1_FILIAL      = ' '
			AND DA1_CODTAB     = DA0_CODTAB
			AND DA1_CODGAR     = Z6_PRODUTO
			AND DA1_ATIVO      = '1'
			AND DA1.D_E_L_E_T_ = ' '
			WHERE 
			Z6_FILIAL    = ' '
			AND Z6_PERIODO     = %Exp:aRet[1]%
			AND Z6_TPENTID     = '4'
			AND Z6_CATPROD     = '2'
			AND SZ6.D_E_L_E_T_ = ' '
	UNION ALL
	SELECT DECODE(Z6_PEDGAR,'          ',Z6_PEDSITE,Z6_PEDGAR) PEDIDO,
			Z6_PRODUTO PRODUTO,
			Z6_GRUPO CODIGO_PROJETO,
			Z6_DESGRU DESCRICAO_PROJETO,
			Z6_CODVOU CODIGO_VOUCHER,
			ZH_DESCRI TIPO_VOUCHER,
			DA1_CODTAB CODIGO_TABELA,
			DA0_DESCRI DESCRICAO_TABELA
	FROM SZ6010 SZ6
			LEFT JOIN SZH010 SZH
			ON ZH_FILIAL       = ' '
			AND ZH_TIPO        = Z6_TIPVOU
			AND SZH.D_E_L_E_T_ = ' '
	LEFT JOIN SZ3010 SZ3
			ON Z3_FILIAL       = ' '
			AND Z3_CODGAR      = Z6_GRUPO
			AND Z3_TIPENT      = '5'
			AND SZ3.D_E_L_E_T_ = ' '
	LEFT JOIN DA0010 DA0
		ON 	DA0_FILIAL      = ' '
			AND (DA0_CODTAB    = SUBSTR(Z3_CODTAB,1,3)
			OR DA0_CODTAB      = SUBSTR(Z3_CODTAB,5,3)
			OR DA0_CODTAB      = SUBSTR(Z3_CODTAB,9,3)
			OR DA0_CODTAB      = SUBSTR(Z3_CODTAB,13,3)
			OR DA0_CODTAB      = SUBSTR(Z3_CODTAB,17,3)
			OR DA0_CODTAB      = SUBSTR(Z3_CODTAB,21,3)
			OR DA0_CODTAB      = SUBSTR(Z3_CODTAB,25,3)
			OR DA0_CODTAB      = SUBSTR(Z3_CODTAB,29,3)
			OR DA0_CODTAB      = SUBSTR(Z3_CODTAB,34,3)
			OR DA0_CODTAB      = SUBSTR(Z3_CODTAB,38,3)
			OR DA0_CODTAB      = SUBSTR(Z3_CODTAB,11,3)
			OR DA0_CODTAB      = SUBSTR(Z3_CODTAB,15,3))
			AND DA0.D_E_L_E_T_ = ' '
	LEFT JOIN DA1010 DA1
			ON DA1_FILIAL      = ' '
			AND DA1_CODTAB     = DA0_CODTAB
			AND DA1_CODGAR     = Z6_PRODUTO
			AND DA1_ATIVO      = '1'
			AND DA1.D_E_L_E_T_ = ' '
	WHERE 	
			Z6_FILIAL    = ' '
			AND Z6_PERIODO     = %Exp:aRet[1]%
			AND Z6_TPENTID     = '4'
			AND DA0_DESCRI IS NULL
			AND Z6_CATPROD     = '2'
			AND SZ6.D_E_L_E_T_ = ' '
Endsql 
    
//Cria Cabecalho do relatorio
cLog := "PEDIDO;"
cLog += "PRODUTO;"
cLog += "CODIGO DO PROJETO;"
cLog += "DESCRICAO DO PROJETO;"
cLog += "CODIGO DO VOUCHER;"
cLog += "TIPO DO VOUCHER;"
cLog += "CODIGO DO TABELA;"
cLog += "DESCRICAO DO TABELA"
FWrite(nHandle, cLog + CHR(13)+CHR(10)) // Insere texto no arquivo

cLog := ""

IncProc( "Gravando Pedidos....." )
ProcessMessage()
While !TMP200->(EOF())

	cLog += TMP200->PEDIDO+";"
	cLog += TMP200->PRODUTO+";"
	cLog += TMP200->CODIGO_PROJETO+";"
	cLog += TMP200->DESCRICAO_PROJETO+";"
	cLog += TMP200->CODIGO_VOUCHER+";"
	cLog += TMP200->TIPO_VOUCHER+";"
	cLog += TMP200->CODIGO_TABELA+";"
	cLog += TMP200->DESCRICAO_TABELA+ CHR(13)+CHR(10)
	
	nCount++

	TMP200->(DbSkip())
	If nCount == 500 .Or. TMP200->(EOF())
		FWrite(nHandle, cLog) // Insere texto no arquivo
		//Zera contador gravado e o texto gravado
		nCount := 0
		cLog   := ""
	Endif
	
Enddo


fclose(nHandle)           // Fecha arquivo 
TMP200->(DbCloseArea())

IncProc( "Abre o excel com os dados" )
ProcessMessage()

oExcelApp := MsExcel():New()
oExcelApp:WorkBooks:Open(cArqLog)
oExcelApp:SetVisible(.T.)

Return