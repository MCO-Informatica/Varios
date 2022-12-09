#Include "totvs.ch"
#DEFINE XML_VERSION 		'<?xml version="1.0" encoding="ISO-8859-1" standalone="yes"?>'
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CSTA110   º Autor ³ RENATO RUY BERNARDOº Data ³  17/04/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ ROTINA PARA CARGA DA TABELA DE PREÇO                       º±±
±±º          ³                                                            º±±
±±º          ³ PROCESSO:                                                  º±±
±±º          ³ 1) ATUALIZA PRODUTO                                        º±±
±±º          ³ 2) ATUALIZA PRODUTO ORIGEM                                 º±±
±±º          ³ 3) ATUALIZA GRUPO                                          º±±
±±º          ³ 4) ATUALIZA TABELA DE PRECO                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CERTISIGN                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User function CSTA110()
	Local bValid  	:= {|| .T. }
	Local aProg  	:= {}
	Local aLimpa  	:= {}

	Private aRet 	:= {}
	Private aItens 	:= {}
	Private aRet 	:= {}
	Private aPar 	:= {}
	Private cGrava	:= AllTrim(GetNewPar("MV_XGRVTAB","N"))
	
	//Adiciona itens da rotina
	AADD(aProg,"1=Atualiza Produto")
	AADD(aProg,"2=Atualiza Produto Origem")
	AADD(aProg,"3=Atualiza Tabela Preço")
	AADD(aProg,"4=Atualiza Grupo")
	AADD(aProg,"5=Atualiza Combo")

	AADD(aLimpa,"1=Sim")
	AADD(aLimpa,"2=Não")

	//Utilizo parambox para selecionar a rotina
	aAdd( aPar,{ 2  ,"Rotina" 	 	,"1" ,aProg , 100,'.T.',.T.})
	aAdd( aPar,{ 2  ,"Limpa Tabela"	,"2" ,aLimpa, 100,'.T.',.T.})
	aAdd( aPar,{ 1	,"Produto específico",Space(30),"","","","",60,.F.})
	
	If ParamBox( aPar, 'Parâmetros', @aRet, bValid, , , , , ,"CSTA110" , .T., .F. )
		MsAguarde( {|| xprocess() },"MONTA CARGA HUB" )
	Else
		Alert("Rotina cancelada!")
	Endif
Return 

//Renato Ruy - 17/04/2017
//Envio de cargas Gar x Tipo de mensagem
static Function xprocess()
	Private cFilter	:= IIF( Empty( aRET[3] ), "%%", "%AND PA8_CODBPG = '" + Alltrim(aRET[3]) + "'%")

	//Tratamento para gerar mensagem Atualiza Produto Protheus
	If aRet[1] == "1"
		MsProcTxt("Comunicando HUB - ATUALIZA-PRODUTO")
		CSTA110A()
	Endif

	//Tratamento para gerar mensagem Atualiza Produto Origem
	If aRet[1] == "2"
		MsProcTxt("Comunicando HUB - ATUALIZA-PRODUTO-ORIGEM")
		CSTA110B()
	Endif

	//Tratamento para gerar mensagem Atualiza Tabela preço
	If aRet[1] == "3"
		MsProcTxt("Comunicando HUB - ATUALIZA-TABELA-PRECO")
		CSTA110C()
	Endif

	//Tratamento para gerar mensagem Atualiza Grupo
	If aRet[1] == "4"
		MsProcTxt("Comunicando HUB - ATUALIZA-GRUPO")
		CSTA110D()
	Endif

	//Tratamento para gerar mensagem Atualiza Combo
	If aRet[1] $ "4,5"
		MsProcTxt("Comunicando HUB - ATUALIZA-COMBO")
		U_VNDA750( ,'CSTA110')
	Endif

Return

Static Function GeraLog(cOrigem)
	Local aHead := {}

	Default cOrigem := "Item"

	//Cabeçalho do Log
	Aadd(aHead,cOrigem)
	Aadd(aHead,"DESCRICAO")

	//Exporta arquivo com os dados do Log de Pedidos em Lote.
	MsgRun("Favor Aguardar.....", "Exportando os Registros para o Excel",;
								{||DlgToExcel({{"ARRAY",;
								"Log da comunicação do Atualiza Produto x Hub",;
								aHead,aItens}})})
Return

//Renato Ruy - 17/04/2017
//Atualiza-Produto
//Gera Log se ocorrer erro e não envia as demais mensagens.
Static function CSTA110A
	Local aItem   := {}
	Local lRet    := .F.

	If SELECT("TMPPRD") > 0
		DbSelectArea("TMPPRD")
		TMPPRD->(DbCloseArea())
	Endif

	//Busca todos os produtos Protheus que podem ser utilizado na tabela de preco.
	Beginsql Alias "TMPPRD"

		SELECT PA8_CODMP8 PRODUTO FROM %TABLE:PA8%
		WHERE
		%NOTDEL%
		%Exp:cFilter%
		GROUP BY PA8_CODMP8

	Endsql

	While !TMPPRD->(EOF())

		lRet := .T.
		aItem := {}
		
		If SubStr(TMPPRD->PRODUTO,1,1) == " "
			AADD(aItem,TMPPRD->PRODUTO)
			AADD(aItem,"O código do produto não pode começar com espaço!")
			AADD(aItens,aItem)
			
			lRet := .F.
		Endif
		
		//verifica atraves do parametro se pode se comunicar com o HUB
		If cGrava == "S" .And. lRet
			lRet := U_CSTA080(TMPPRD->PRODUTO)
		Endif
		
		If !lRet .And. Len(aItem) == 0
			aItem := {}
			AADD(aItem,TMPPRD->PRODUTO)
			AADD(aItem,"Não foi possivel integrar com o Hub!")
			AADD(aItens,aItem)	
		Endif

		TMPPRD->(DbSkip())
	Enddo

	//No final da integracao, emite o log
	If len(aItens) > 0
		GeraLog("PRODUTO")
	Endif

Return

//Renato Ruy - 18/04/2017
//Atualiza-Produto-Origem
//Gera Log se ocorrer erro e não envia as demais mensagens.
Static function CSTA110B
	Local aItem   := {}
	Local lRet    := .F.

	If SELECT("TMPORI") > 0
		DbSelectArea("TMPORI")
		TMPORI->(DbCloseArea())
	Endif

	//Busca todos os produtos Protheus que podem ser utilizado na tabela de preco.
	Beginsql Alias "TMPORI"

		SELECT 	PA8_CODMP8 PRODUTO,
				PA8_CODBPG CODGAR,
				PA8_DESBPG DESGAR,
				PA8_JPGPEQ,
				PA8_JPGMED,
				PA8_JPGGRA,
				R_E_C_N_O_
		FROM %TABLE:PA8%
		WHERE %NOTDEL%
		%Exp:cFilter%

	Endsql

	While !TMPORI->(EOF())

		lRet := .T.
		aItem := {}
		
		If SELECT("TMPDUP") > 0
			DbSelectArea("TMPDUP")
			TMPDUP->(DbCloseArea())
		Endif
		Beginsql Alias "TMPDUP"

			SELECT Count(*) CONTAGEM
			FROM %TABLE:PA8%
			WHERE
			PA8_CODBPG = %Exp:TMPORI->CODGAR% AND
			%NOTDEL%
			
		Endsql
		
		
		If TMPDUP->CONTAGEM > 1
			AADD(aItem,TMPORI->CODGAR + " + " + TMPORI->PRODUTO)
			AADD(aItem,"O produto Gar esta duplicado na De-Para e não será comunicado com o HUB!")
			AADD(aItens,aItem)
		Elseif SubStr(TMPORI->PRODUTO,1,1) == " "
			AADD(aItem,TMPORI->CODGAR + " + " + TMPORI->PRODUTO)
			AADD(aItem,"O código do produto protheus não pode começar com espaço!")
			AADD(aItens,aItem)
		Endif
		
		//verifica atraves do parametro se pode se comunicar com o HUB
		If cGrava == "S" .And. Len(aItem) == 0
			lRet := U_CSTA060(TMPORI->PRODUTO,TMPORI->CODGAR,"A",TMPORI->DESGAR,.F., TMPORI->PA8_JPGPEQ, TMPORI->PA8_JPGMED, TMPORI->PA8_JPGGRA, TMPORI->R_E_C_N_O_, .F., .F.)
		Endif
		
		If !lRet .And. Len(aItem) == 0
			aItem := {}
			AADD(aItem,TMPORI->CODGAR + " + " + TMPORI->PRODUTO)
			AADD(aItem,"Não foi possivel integrar com o Hub!")
			AADD(aItens,aItem)	
		Endif

		TMPORI->(DbSkip())
	Enddo

	//No final da integracao, emite o log
	If len(aItens) > 0
		GeraLog("PRODUTO ORIGEM")
	Endif

Return

//Renato Ruy - 18/04/2017
//Atualiza-Tabela-Preco
//Gera Log se ocorrer erro e não envia as demais mensagens.
Static function CSTA110C
	Local aItem   := {}
	Local lRet    := .F.

	IF .NOT. GetMv( 'MV_LJECOMM' )
		HS_MsgInf("Para este processo habilitar o parâmetro MV_LJECOMM" + CRLF + "Processo cancelado",;
					"Atenção","[CSTA110] Atualiza-Tabela-Preco")
		Return
	EndIF

	If SELECT("TMPTAB") > 0
		DbSelectArea("TMPTAB")
		TMPTAB->(DbCloseArea())
	Endif

	//Busca todas tabelas de preco que sao enviadas para o Site.
	Beginsql Alias "TMPTAB"

		SELECT DA0_CODTAB CODTAB FROM %Table:DA0%
		WHERE
		DA0_FILIAL = %xFilial:DA0% AND
		DA0_ECFLAG = '1' AND
		%NOTDEL%
		
	Endsql

	//verifica atraves do parametro se pode se comunicar com o HUB
	//Envia sem as informacoes para apagar as tabelas de preço.
	If cGrava == "S" .And. aRet[2] == "1"
		While !TMPTAB->(EOF())
			
			cXml := XML_VERSION + CRLF
			cXml += '<TabelaPrecoType xmlns:ns2="http://www.opvs.com.br/certisign/HardwareAvulsoSchema/">' + CRLF
			cXml += '   <code>1</code>' + CRLF //1=sucesso na operação; 0=erro
			cXml += '   <msg>Solicitacao das informacoes do(s) produto(s) ok.</msg>' + CRLF
			cXml += '   <exception></exception>' + CRLF
			cXml += '	<codigo>' + AllTrim(TMPTAB->CODTAB) + '</codigo>' + CRLF
			cXml += '</TabelaPrecoType>' + CRLF
		
			MsAguarde({|| lRet := U_VNDA030(cXml,TMPTAB->CODTAB)},"Comunicando com o HUB")
				
			TMPTAB->(DbSkip())
		Enddo
		
		TMPTAB->(DbGoTop())
		
	Endif 

	While !TMPTAB->(EOF())

		lRet  := .T.
		aItem := {}
		
		//Primeiro levanta todos os produtos duplicados na tabela atual e ativo
		If Select("TMPDUP") > 0
			DbSelectArea("TMPDUP")
			TMPDUP->(DbCloseArea())
		Endif
		
		BeginSql Alias "TMPDUP"
			
			%NoParser%
			
			SELECT COUNT(*) CONTA FROM (
			SELECT DA1_CODGAR, DA1_QTDLOT FROM %Table:DA1%
			WHERE
			DA1_FILIAL = ' ' AND
			DA1_CODTAB = %Exp:TMPTAB->CODTAB% AND
			DA1_ATIVO = '1' AND
			%Notdel%
			GROUP BY DA1_CODGAR, DA1_QTDLOT
			HAVING COUNT(*) > 1
			ORDER BY DA1_CODGAR)
			
			
		Endsql
		
		
		//Levanta se tem produto em branco e ativo.
		If Select("TMPBLA") > 0
			DbSelectArea("TMPBLA")
			TMPBLA->(DbCloseArea())
		Endif
		
		BeginSql Alias "TMPBLA"
			
			%NoParser%
			
			SELECT COUNT(*) CONTA FROM %Table:DA1%
			WHERE
			DA1_FILIAL = ' ' AND
			DA1_CODTAB = %Exp:TMPTAB->CODTAB% AND
			DA1_CODGAR = ' ' AND
			DA1_ATIVO = '1' AND
			%Notdel%		
			
		Endsql
		
		If !Empty(TMPDUP->CONTA)
			AADD(aItem,TMPTAB->CODTAB)
			AADD(aItem,"Existem produtos ativos que estão duplicados!")
			AADD(aItens,aItem)
		Elseif !Empty(TMPBLA->CONTA)
			AADD(aItem,TMPTAB->CODTAB)
			AADD(aItem,"Existem Produtos Gar não preenchido na tabela!")
			AADD(aItens,aItem)		
		Endif
		
		//verifica atraves do parametro se pode se comunicar com o HUB
		If cGrava == "S" .And. Len(aItem) == 0
			lRet := U_VNDA020(TMPTAB->CODTAB)
		Endif
		
		If !lRet .And. Len(aItem) == 0
			aItem := {}
			AADD(aItem,TMPTAB->CODTAB)
			AADD(aItem,"Não foi possivel integrar com o Hub!")
			AADD(aItens,aItem)	
		Endif

		TMPTAB->(DbSkip())
	Enddo

	//No final da integracao, emite o log
	If len(aItens) > 0
		GeraLog("TABELA DE PRECO")
	Endif
Return

//Renato Ruy - 18/04/2017
//Atualiza-Grupo
//Gera Log se ocorrer erro e não envia as demais mensagens.
Static function CSTA110D
	Local aItem   := {}
	Local lRet    := .F.
	Local cTabin  := " "

	If SELECT("TMPGRU") > 0
		DbSelectArea("TMPGRU")
		TMPGRU->(DbCloseArea())
	Endif

	//Busca todos os Grupos que tem tabela de preco vinculado.
	Beginsql Alias "TMPGRU"

		SELECT  Z3_CODGAR CODENT,
				Z3_DESENT DESENT,
				Z3_CODTAB CODTAB,
				Z3_ESTADO ESTADO
		FROM %Table:SZ3%
		WHERE
		Z3_FILIAL = %xFilial:SZ3% AND
		Z3_TIPENT = '5' AND
		%NOTDEL%

	Endsql

	While !TMPGRU->(EOF())

		lRet  := .T.
		aItem := {}
		cTabin:= "% " + FormatIn(AllTrim(TMPGRU->CODTAB),",") + " %"
		
		//Validacao para duplicidade entre tabelas
		//Primeiro levanta todos os produtos duplicados
		If Select("TMPDUP") > 0
			DbSelectArea("TMPDUP")
			TMPDUP->(DbCloseArea())
		Endif
		
		BeginSql Alias "TMPDUP"
			
			%NoParser%
			
			SELECT DA1_CODGAR FROM (
			SELECT DA1_CODTAB, DA1_CODGAR FROM %Table:DA1%
			WHERE
			DA1_FILIAL = %xFilial:DA1% AND
			DA1_CODTAB IN %Exp:cTabin% AND
			DA1_ATIVO = '1' AND
			%NOTDEL%
			GROUP BY DA1_CODTAB, DA1_CODGAR)
			GROUP BY DA1_CODGAR
			HAVING COUNT(*) > 1
			ORDER BY DA1_CODGAR
			
		Endsql
		
		
		If !Empty(TMPDUP->DA1_CODGAR)
			AADD(aItem,TMPGRU->CODENT)
			AADD(aItem,"Existem duplicidades de produtos nas tabelas de preço: " + AllTrim(TMPGRU->CODTAB))
			AADD(aItens,aItem)
		Endif
		
		//verifica atraves do parametro se pode se comunicar com o HUB
		If cGrava == "S" .And. Len(aItem) == 0
			lRet := U_CSTA070(TMPGRU->CODENT," ",TMPGRU->CODTAB,.F.,TMPGRU->ESTADO)
		Endif
		
		If !lRet .And. Len(aItem) == 0
			aItem := {}
			AADD(aItem,TMPGRU->CODENT)
			AADD(aItem,"Não foi possivel integrar com o Hub!")
			AADD(aItens,aItem)	
		Endif

		TMPGRU->(DbSkip())
	Enddo

	//No final da integracao, emite o log
	If len(aItens) > 0
		GeraLog("GRUPO")
	Endif
Return