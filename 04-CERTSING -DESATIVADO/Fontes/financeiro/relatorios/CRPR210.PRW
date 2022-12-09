#Include "totvs.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CRPR210  º Autor ³ RENATO RUY BERNARDO  º Data ³ 11/07/17  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Relatorio de .		  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Certisign                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/ 
User Function CRPR210

Local aPergs	:= {}

Private aRet	:= {}

//Perguntas do parambox
aAdd( aPergs ,{1 ,"Periodo " 	 	,RTrim(GetMv("MV_REMMES")),"","","","",50,.F.})
aAdd( aPergs ,{6 ,"Gravar arquivo" 	,Space(180)				  ,"","","",50,.F.,"Arquivos .CSV |*.CSV"})

If !ParamBox(aPergs ,"Parametros ",aRet)
	Alert("O relatório foi cancelado!")
	Return
EndIf

Processa( {|| CRPR210R() }, "Relatorio de Reembolsos")

Return

//Renato Ruy - 11/07/2017
//Funcao que gera o relatorio em arquivo.
Static Function CRPR210R()

Local cArqLog := aRet[2]
Local cLog	  := ""
Local nCount  := 0
Local cStatus := ""
Local nPeriodo:= 0
Local nPerUser:= 0

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
Beginsql Alias "TMP210"
	Column DT_REEMBOLSO	As Date
	
	%NOPARSER%
	
	SELECT ADE_PEDGAR PEDIDO, E2_EMISSAO DT_REEMBOLSO FROM %Table:SE2% SE2
	JOIN %Table:ADE% ADE ON ADE_FILIAL = %xFilial:ADE% AND ADE_PEDGAR = SUBSTR(E2_HIST,16,10) AND ADE.%NOTDEL%
	LEFT JOIN %Table:SUK% SUK ON UK_FILIAL = %xFilial:SUK% AND UK_CODATEN = ADE_CODIGO AND SUK.%NOTDEL%
	LEFT JOIN %Table:ACI% ACI ON ACI_FILIAL = %xFilial:ACI% AND ACI.ACI_CODIGO = SUK.UK_CODIGO AND ACI.%NOTDEL%
	LEFT JOIN %Table:SUP% SUP ON UP_FILIAL = %xFilial:SUP% AND UP_CODCAMP = ACI_CODSCR AND UP_CARGO = UK_CODRESP AND SUP.%NOTDEL%
	WHERE
	E2_FILIAL = %xFilial:SE2% AND
	E2_PREFIXO = 'REE' AND
	E2_TIPO = 'DEV' AND
	E2_EMISSAO BETWEEN %Exp:aRet[1]+'01'% AND %Exp:aRet[1]+'31'% AND
	(SELECT SUM(Z6_VALCOM) FROM %Table:SZ6% WHERE Z6_FILIAL = %xFilial:SZ6% AND Z6_TIPO IN ('VERIFI','RENOVA','REEMBO') AND Z6_PEDGAR = ADE_PEDGAR AND %NOTDEL%) IS NOT NULL AND
	SE2.%NOTDEL%
	GROUP BY ADE_PEDGAR, E2_EMISSAO
	UNION
	SELECT C5_CHVBPAG PEDIDO, MIN(E5_DATA) DT_REEMBOLSO FROM %Table:SC5% SC5
	JOIN %Table:SE5% SE5 
	ON E5_FILIAL = %xFilial:SE5% AND E5_NUMERO = C5_NUM AND E5_PREFIXO = 'RCP' AND E5_RECPAG = 'P' AND UPPER(E5_HISTOR) LIKE '%CHARGEBACK%' AND SE5.%NOTDEL%
	WHERE
	C5_FILIAL = %xFilial:SC5% AND
	C5_CHVBPAG IN ( SELECT Z6_PEDGAR FROM %Table:SZ6% SZ6
	                WHERE
	                Z6_FILIAL = %xFilial:SZ6% AND
	                Z6_PERIODO = %Exp:aRet[1]% AND
	                Z6_TPENTID = '4' AND
	                Z6_CATPROD = '2' AND
	                %NOTDEL%
	                GROUP BY Z6_PEDGAR) AND
	SC5.%NOTDEL%
	GROUP BY C5_CHVBPAG
Endsql 
    
//Cria Cabecalho do relatorio
cLog := "PEDIDO;DATA REEMBOLSO;STATUS"
FWrite(nHandle, cLog + CHR(13)+CHR(10)) // Insere texto no arquivo

cLog 	  := ""
nPerUser := Val(Substr(aRet[1],5,2))

IncProc( "Gravando Pedidos....." )
ProcessMessage()
While !TMP210->(EOF())
	
	nPeriodo := Val(Substr(DtoS(TMP210->DT_REEMBOLSO),5,2))
	
	If nPerUser > nPeriodo
		cStatus := "Desconto de Período anterior"
	Elseif  nPerUser < nPeriodo
		cStatus := "Pago no período informado e será descontado no próximo calculo"
	Else
		cStatus := "O pedido será zerado pois foi reembolsado no período"
	Endif
		
	cLog += TMP210->PEDIDO+";"
	cLog += DtoC(TMP210->DT_REEMBOLSO)+";"
	cLog += cStatus+ CHR(13)+CHR(10)
	
	nCount++

	TMP210->(DbSkip())
	If nCount == 500 .Or. TMP210->(EOF())
		FWrite(nHandle, cLog) // Insere texto no arquivo
		//Zera contador gravado e o texto gravado
		nCount := 0
		cLog   := ""
	Endif
	
Enddo


fclose(nHandle)           // Fecha arquivo 
TMP210->(DbCloseArea())

IncProc( "Abre o excel com os dados" )
ProcessMessage()

oExcelApp := MsExcel():New()
oExcelApp:WorkBooks:Open(cArqLog)
oExcelApp:SetVisible(.T.)

Return