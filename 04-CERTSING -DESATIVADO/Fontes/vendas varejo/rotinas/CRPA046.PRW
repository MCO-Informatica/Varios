#Include "totvs.ch"

//Renato Ruy - 15/01/2018
//Job para geração dos pedidos para cobranca e pagamento

User Function CRPA046

Local cParSage := ""
Local cDataIni := ""
Local cDataFim := ""

//Abre a empresa sem uso de licencao
RpcSetType(3)
RpcSetEnv("01","02")

//GERA TABELA TEMPORARIA
If select("GTLEGADO") <= 0
	USE GTLEGADO ALIAS GTLEGADO SHARED NEW VIA "TOPCONN"
	If NetErr()
		UserException("Falha ao abrir GTLEGADO - SHARED" )
	Endif
	DbSetIndex("GTLEGADO01")
	DbSetOrder(1)
Endif

DbSelectArea("GTLEGADO")

cParSage := "% " + FormatIn(AllTrim(GetNewPar("MV_XPRDSAGE","SRFA1PJEMISSORSAGEHV5")),",") + " %"
cDataIni := DtoS(dDataBase-60)
cDataFim := AllTrim(getmv("MV_REMMES"))+"31"

//Busca Pedidos da Sage para gerar na GTLEGADO
Beginsql Alias "TMPSAG"
	
	SELECT Z5_PEDGAR, Z5_DATEMIS FROM %Table:SZ5%
	WHERE
	Z5_FILIAL = ' ' AND
	Z5_DATEMIS BETWEEN %Exp:cDataIni% AND %Exp:cDataFim% AND
	Z5_PRODGAR in %Exp:cParSage% AND
	%Notdel%
	
Endsql

SC5->(DbOrderNickName("NUMPEDGAR"))

While !TMPSAG->(EOF())
	
	//Busca na GTLEGADO para verificar a existência
	Beginsql Alias "TMPEXT"
	
		Column C5_EMISSAO	As Date
		
		SELECT C5_EMISSAO,
				C5_CHVBPAG, 
				C5_XNPSITE, 
				C5_CTRSAGE,
				C6_PRODUTO,
				C6_PRCVEN, 
				ZJ_TXMANU, 
				ZJ_TXPARC 
		FROM %Table:SC5% SC5
		JOIN %Table:SC6% SC6 
			ON C6_FILIAL = C5_FILIAL AND C6_NUM = C5_NUM AND SC6.%NOTDEL%
		JOIN SZJ010 SZJ 
			ON ZJ_FILIAL = %xFilial:SZJ% AND ZJ_COMBO = C6_XCDPRCO AND ZJ_CODPROD = C6_PRODUTO AND ZJ_TXMANU > 0 AND SZJ.%NOTDEL%
		LEFT JOIN GTLEGADO GT 
			ON GT_PEDGAR = C5_CHVBPAG AND GT.D_E_L_E_T_ = ' '
		WHERE
		C5_FILIAL = %xFilial:SC5% AND
		C5_CHVBPAG = %Exp:TMPSAG->Z5_PEDGAR% AND
		GT_PEDGAR IS NULL AND
		SC6.%NOTDEL%
		
	Endsql
	
	If !Empty(C5_CHVBPAG)
	
		GTLEGADO->( RecLock("GTLEGADO",.T.) )

			GTLEGADO->GT_TYPE		:= "G" 				 //TIPO SAGE
			GTLEGADO->GT_PEDGAR 	:= TMPEXT->C5_CHVBPAG //PEDIDO GAR
			GTLEGADO->GT_PEDSITE	:= TMPEXT->C5_XNPSITE //PEDIDO SITE
			GTLEGADO->GT_DATA		:= TMPEXT->C5_EMISSAO //DATA GRAVACAO
			GTLEGADO->GT_VLRPRD	:= TMPEXT->C6_PRCVEN	 //VALOR EMISSOR
			GTLEGADO->GT_PRODUTO	:= TMPEXT->C6_PRODUTO //PRODUTO EMISSOR	
			GTLEGADO->GT_TXMANUT	:= TMPEXT->ZJ_TXMANU	 //VALOR TAXA DE MANUTENCAO
			GTLEGADO->GT_TXPAGO	:= 0					 //PARCELAS PAGA
			GTLEGADO->GT_TXRECEB	:= 0					 //VALOR A RECEBER
			GTLEGADO->GT_TXPARC  := 12/TMPEXT->ZJ_TXPARC  //QUANTIDADE DE PARCELAS A PAGAR
	
		GTLEGADO->( MsUnlock() )
		
	Endif
	
	TMPEXT->(DbCloseArea()) //Fecha o arquivo gerado
	TMPSAG->(DbSkip())
Enddo

TMPSAG->(DbCloseArea()) //Fecha o arquivo gerado

Return