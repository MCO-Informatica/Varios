#INCLUDE "PROTHEUS.CH"
#include "fileio.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CRPA050  º Autor ³ Tatiana Pontes     º Data ³  03/10/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Saldo Mensal Certificados Vendidos                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Certisign                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CRPA050()

Local aRotAdic := {}

aadd(aRotAdic,{ "Calcular Saldo"	, "U_CRP050Calc"	, 0 , 3 })
aadd(aRotAdic,{ "Relatório Saldos"	, "U_CRPR030"		, 0 , 4 })
aadd(aRotAdic,{ "Camp.Incentivo"	, "U_CRPA050F"		, 0 , 5 })

AxCadastro("SZV","Saldo Mensal Certificados Verificados",,"u_CRP050Ok()",aRotAdic)

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ C04SAcum  ºAutor  ³Tatiana Pontes     º Data ³  03/10/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Atualiza campo de saldo acumulado                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Certisign                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function C04SAcum()

Local nSaldoAcum	:=	0

nSaldoAcum	:=	nSaldoAcum + M->ZV_QTDJAN
nSaldoAcum	:=	nSaldoAcum + M->ZV_QTDFEV
nSaldoAcum	:=	nSaldoAcum + M->ZV_QTDMAR
nSaldoAcum	:=	nSaldoAcum + M->ZV_QTDABR
nSaldoAcum	:=	nSaldoAcum + M->ZV_QTDMAI
nSaldoAcum	:=	nSaldoAcum + M->ZV_QTDJUN
nSaldoAcum	:=	nSaldoAcum + M->ZV_QTDJUL
nSaldoAcum	:=	nSaldoAcum + M->ZV_QTDAGO
nSaldoAcum	:=	nSaldoAcum + M->ZV_QTDSET
nSaldoAcum	:=	nSaldoAcum + M->ZV_QTDOUT
nSaldoAcum	:=	nSaldoAcum + M->ZV_QTDNOV
nSaldoAcum	:=	nSaldoAcum + M->ZV_QTDDEZ

M->ZV_SALACU := nSAldoAcum

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CRP050Ok   º Autor ³ Tatiana Pontes 	   º Data ³ 10/07/12  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Grava usuario que alterou o registro        				  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Certisign                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CRP050Ok()

If !Empty(SZV->ZV_LOGALT)
	M->ZV_LOGALT := Alltrim(cUserName)+" - "+DtoC(dDataBase)+" - "+Time()+" - ALTERADO"
Endif

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CRP050Calc  º Autor ³ Tatiana Pontes    º Data ³ 10/07/12  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao de calculo da quantidade de certificados vendidos   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Certisign                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CRP050Calc(cAlias,nReg,nOpc)

Local cPerg		:= "CRP050"
Local aSays		:= {}
Local aButtons	:= {}

Private lErro	:= .F.

Aadd( aSays, "CÁLCULO DA QUANTIDADE DE CERTIFICADOS VERIFICADOS" )
Aadd( aSays, "" )
Aadd( aSays, "Será apurado as quantidades de certificados verificados" )
Aadd( aSays, "mensalmente por cada entidade." )
Aadd( aSays, "" )
Aadd( aSays, "Defina os parâmetros para seleção dos registros que serão processados." )

AjustaSX1(cPerg)
Pergunte(cPerg, .F. )

Aadd(aButtons, { 5,.T.,{|| Pergunte(cPerg, .T. ) } } )
Aadd(aButtons, { 1,.T.,{|| Processa( {|| CRP050PROC() }, "Processando a contagem..."), IIF(!lErro,FechaBatch(),"") }} )
Aadd(aButtons, { 2,.T.,{|| FechaBatch() }} )

FormBatch( cCadastro, aSays, aButtons )

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CRP050PROC º Autor ³ Tatiana Pontes 	   º Data ³ 10/07/12  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Calcula quantidade de certificados vendidos 				  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Certisign                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function CRP050PROC()

Local lFindSZV := .F.
Local cPeriodo := ""
Local cEntidade:= ""
Local cDescEnt := ""
Local nAcumula := 0
Local nMesAtual:= 0
Local nQtdMes  := 0
Local nValCom  := 0
Local nQtdCampMes := 0
Local lTemZ4   := .F.
Local lTemAR   := .F.
Local lTemFx   := .F.
//Dados para geração do log de calculo de faixas
Local aCabPed  := {}
Local aItemPed := {}
Local aPedidos := {}
Local aPedCamp := {}
Local lSemCamp := .T. 
Local cPerAtu  := AllTrim(GetMv("MV_REMMES"))
Local cEntCamp := ""

dbSelectArea("SX5")
SX5->(dbSetOrder(1))

//Renato Ruy - 22/03/2018
//Bloqueio de recalculo de faixa quando existe planilha ativa
ZZG->(DbSetOrder(2)) // Filial + Periodo + Entidade + (1-Ativo ou 2-Inativo)

//Cabeçalho dos pedidos
Aadd(aCabPed,"PERIODO")		// 1 PERIODO DE CALCULO
Aadd(aCabPed,"PEDIDO") 		// 2 CODIGO DO PEDIDO
Aadd(aCabPed,"STATUS")		// 3 STATUS DO PEDIDO ATUAL
Aadd(aCabPed,"DATA") 		// 4 DATA DO PEDIDO EMISSAO PARA RENOVACAO E VERIFICACAO PARA DEMAIS
Aadd(aCabPed,"CONTAGEM")	// 5 COMO O PEDIDO E CONTADO
Aadd(aCabPed,"PRODUTO")		// 6 CODIGO DO PRODUTO
Aadd(aCabPed,"CARTORIO")	// 7 RETORNA SE TEM OU NAO CARTORIO
Aadd(aCabPed,"FAIXA")		// 8 FAIXA DE PAGAMENTO
 

If Len(Alltrim(mv_par01)) <> 6 .Or. Len(Alltrim(mv_par02)) <> 6
	MsgStop("Preencha o Ano/mês com seis digitos digitos (AAAAMM).")
	lErro := .T.
	Return(.F.)
Endif

cQuery	:= " SELECT  Z6_PERIODO PERIODO, "
cQuery	+= "         Z6_PEDGAR PEDIDO, "
cQuery	+= "         DECODE(Z6_PEDORI,'          ',MAX(Z6_VERIFIC),MAX(Z6_DTEMISS)) DATA, "
cQuery	+= "         Z6_TIPO TIPO, "
cQuery	+= "         Z6_PRODUTO PRODUTO, "
cQuery	+= "         Z6_DESCRPR DESC_PROD, "
cQuery	+= "         Z6_BASECOM VALOR_BASE, "
cQuery	+= "         Z6_VALCOM VALOR_COMISSAO, "
cQuery	+= "         round((CASE WHEN Z6_BASECOM > 0 THEN Z6_VALCOM/Z6_BASECOM ELSE 0 END)*100,0) PERCENTUAL_CALCULADO, "
cQuery	+= "         Z6_CODENT CODIGO_ENTIDADE, "
cQuery	+= "         Z6_DESENT DESCR_ENTIDADE, "
cQuery	+= "         Z6_CODAR CODIGO_AR, "
cQuery	+= "         MAX(SZ6.R_E_C_N_O_) RECNOZ6, ""
cQuery	+= "         PA8_PRDCON CONECTIV, "
cQuery	+= "         COUNT(*) CONTADOR  "
cQuery	+= " FROM SZ6010 SZ6 "
cQuery	+= " JOIN PA8010 PA8 ON PA8_FILIAL = ' ' AND PA8_CODBPG = Z6_PRODUTO AND PA8.D_E_L_E_T_ = ' ' "
cQuery	+= " WHERE "
cQuery	+= " Z6_FILIAL = ' ' "
cQuery	+= " AND Z6_PERIODO BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
cQuery	+= " AND Z6_CATPROD = '2' "
cQuery	+= " AND SubStr(Z6_CODENT,1,4) = '"+MV_PAR03+"' "
cQuery	+= " AND Z6_TPENTID IN ('2','5') "
If AllTrim(MV_PAR03) $ "BR/SIN/SINR"
	cQuery	+= " AND (Z6_PRODUTO LIKE '%REG%' OR Z6_PRODUTO LIKE '%SIN%') "
Elseif AllTrim(MV_PAR03) $ "FENCR"
	cQuery	+= " AND PA8_CATPRO IN ('31','32','33') "
Endif
If AllTrim(MV_PAR03) == "NOT"
	cQuery	+= " AND (SELECT DISTINCT Z6_PEDGAR FROM SZ6010 WHERE Z6_FILIAL = ' ' AND Z6_PERIODO = SZ6.Z6_PERIODO AND Z6_PEDGAR = SZ6.Z6_PEDGAR AND Z6_CODAC = '"+ AllTrim(MV_PAR03) +"' AND Z6_TPENTID = '7' AND D_E_L_E_T_ = ' ') IS NULL "
	cQuery	+= " AND UPPER(Z6_DESCRPR) NOT LIKE '%SIMPLES CONECTIVIDADE%' "
Elseif AllTrim(MV_PAR03) == "BR" .Or. AllTrim(MV_PAR03) == "SINR"
	cQuery	+= " AND (SELECT DISTINCT Z6_PEDGAR FROM SZ6010 WHERE Z6_FILIAL = ' ' AND Z6_PERIODO = SZ6.Z6_PERIODO AND Z6_PEDGAR = SZ6.Z6_PEDGAR AND Z6_TPENTID = '7' AND D_E_L_E_T_ = ' ') IS NULL "
	cQuery	+= " AND (UPPER(Z6_DESCRPR) NOT LIKE '%SIMPLES CONECTIVIDADE%' OR PA8_PRDCON != 'S') "
EndIf
cQuery	+= " AND SZ6.D_E_L_E_T_ = ' ' "
cQuery	+= " GROUP BY Z6_PERIODO, Z6_PEDGAR, Z6_PEDORI, Z6_TIPO, Z6_BASECOM, Z6_VALCOM, Z6_PRODUTO, Z6_CODENT, Z6_DESENT, Z6_CODAR, PA8_PRDCON, Z6_DESCRPR "
cQuery	+= " ORDER BY Z6_PERIODO, DATA, Z6_PEDGAR "

If Select("SZVTMP") > 0
	SZVTMP->(DbCloseArea())
EndIf

PLSQuery( cQuery, "SZVTMP" )

cPeriodo := SZVTMP->PERIODO
cEntidade:= SZVTMP->CODIGO_ENTIDADE
cDescEnt := SZVTMP->DESCR_ENTIDADE
nMesAtual:= Val(SubStr(SZVTMP->PERIODO,5,2))
nAcumula := CRPA50AC(cEntidade,nMesAtual-1,cPeriodo,.F.)
nAcuCamp := CRPA50AC(cEntidade,nMesAtual-1,cPeriodo,.T.)

SZV->( DbSetOrder(1) ) // ZV_FILIAL+ZV_CODENT+ZV_SALANO

While SZVTMP->( !Eof() )
	
	SZV->( DbGoTop() )
	
	IncProc("Processando Pedidos: "+SZVTMP->PEDIDO)
	ProcessMessage()	
	
	//Adiciona dados  do pedido atual no log
	aItemPed := Array(Len(aCabPed))
	aItemPed[1] := cPeriodo					// Periodo	
	aItemPed[2] := SZVTMP->PEDIDO			// Numero Pedido	
	aItemPed[3] := SZVTMP->TIPO				// Status Pedido
	aItemPed[4] := DtoC(StoD(SZVTMP->DATA))	// Data de Emissao para renovacao ou verificação para demais
	aItemPed[6] := SZVTMP->PRODUTO
	aItemPed[8] := ""

	/*If AllTrim(SZVTMP->PEDIDO) $  "16104689|16071736|14439817|16076475|16110996|15103448|16101401"
		Alert("")
	EndIf*/
	
	//Grava Quantidade dos pedidos que sao considerados
	//Os pedidos com status /PAGANT/NAOPAG/ não entrarão na contagem.
	//Renato Ruy - 02/01/2018
	//OTRS: 2017121410001231 - Paga percentual de campanha para BR, quando tem origem do revendedor
	lSemCamp := .T.
	SZ5->(DbSetOrder(1))
	SZ5->(DbSeek(xFilial("SZ5")+SZVTMP->PEDIDO))
	If "REG"$SZVTMP->PRODUTO .And. "REVENDEDOR" $ UPPER(SZ5->Z5_DESREDE) .And. SZ5->Z5_COMSW > 0 .And. SZ5->Z5_BLQVEN != "0"
		aItemPed[3] := "Clube do Revendedor"
		aItemPed[5] := 0
	ElseIf "SIN"$SZVTMP->PRODUTO .And. ("REVENDEDOR" $ UPPER(SZ5->Z5_DESREDE) .OR. "CAMPANHA" $ UPPER(SZ5->Z5_DESREDE) .OR. "ENTIDADE DE CLASSE" $ UPPER(SZ5->Z5_DESREDE)) .And.;
			SZ5->Z5_COMSW > 0 .And. SZ5->Z5_BLQVEN != "0" .And. SZVTMP->TIPO $ "/VERIFI/RENOVA/REEMBO"
		nQtdMes++
		
		aAreaSZ6 := SZ6->(GetArea())
		dbSelectArea("SZ6")
		SZ6->(dbSetOrder(1)) 
		If SZ6->(dbSeek(xFilial("SZ6") + SZVTMP->PEDIDO))
			While SZ6->(!EoF()) .And. AllTrim(SZ6->Z6_PEDGAR) == AllTrim(SZVTMP->PEDIDO) 
				If AllTrim(SZ6->Z6_TPENTID) == "7" .And. SZ6->Z6_PERIODO == cPeriodo
					If SZ6->Z6_TIPO $ "/NAOPAG/PAGANT/"
						aItemPed[3] := IIF("REVENDEDOR" $ UPPER(SZ5->Z5_DESREDE),"CLUBE DO REVENDEDOR","CAMPANHA DO CONTADOR")
						aItemPed[5] := 0
						lSemCamp	:= .T.
					ElseIf SZ6->Z6_TIPO $ "/REEMBO/"
						aItemPed[3] := IIF("REVENDEDOR" $ UPPER(SZ5->Z5_DESREDE),"CLUBE DO REVENDEDOR","CAMPANHA DO CONTADOR")
						aItemPed[5] := -1
						lSemCamp	:= .T.
						aItemPed[8] := "REEMBOLSO"
					Else
						aItemPed[3] := IIF("REVENDEDOR" $ UPPER(SZ5->Z5_DESREDE),"CLUBE DO REVENDEDOR","CAMPANHA DO CONTADOR")
						aItemPed[5] := 1
						lSemCamp	:= .F.
					EndIf
					Exit
				EndIf
				SZ6->(dbSkip())
			EndDo
		EndIf
		RestArea(aAreaSZ6)
				
	Elseif SZVTMP->TIPO $ "/VERIFI/RENOVA/"
		nQtdMes++
		aItemPed[5] := 1	// Contagem de Pedidos
	Elseif SZVTMP->TIPO $ "/REEMBO/" .And. SZVTMP->VALOR_BASE < 0
		nQtdMes -= 1
		aItemPed[5] := -1	// Contagem de Pedidos
	Else
		aItemPed[5] := 0	// Contagem de Pedidos
	Endif
	
	//Soma Campanha para Faixa de Campanha
	If aItemPed[3] == "CAMPANHA DO CONTADOR" .And. SZVTMP->TIPO $ "/VERIFI/RENOVA/"
		nQtdCampMes++
		AADD(aPedCamp,aItemPed)
	ElseIf aItemPed[3] == "CAMPANHA DO CONTADOR" .And. SZVTMP->TIPO $ "/REEMBO/"
		nQtdCampMes--
		AADD(aPedCamp,aItemPed)		
	EndIf	
	
	//Busca nos percentuais da entidade sobre o controle de faixa
	lTemFx := .F.
	lTemZ4 := .F.
	SZ4->( DbSetOrder(1) )
	If SZ4->( MsSeek( xFilial("SZ4")+cEntidade ) )
		
		While SZ4->( !Eof() ) .AND. cEntidade == SZ4->Z4_CODENT 
			If SZ4->Z4_CATPROD $ "F1F2F3F4F5F6" .And. ("REG" $ SZVTMP->PRODUTO .Or. "NOT" $ SZVTMP->PRODUTO .Or. "SIN" $ SZVTMP->PRODUTO) .And.;
			 !("SIMPLES CONECTIVIDADE" $ SZVTMP->DESC_PROD .AND. SZVTMP->CONECTIV == "S") .And. SZVTMP->TIPO != "REEMBO"
				//Se entrou na faixa calcula.
				lTemFx := .T.
				If aItemPed[3] == "CAMPANHA DO CONTADOR"
					If nAcuCamp+nQtdCampMes >= SZ4->Z4_QTDMIN .AND. nAcuCamp+nQtdCampMes <= SZ4->Z4_QTDMAX
						
						//Tratamento para não buscar a categoria atual no calculo
						lTemZ4 := .T.
						
						//Gravo para utilizar novamente em caso de recalculo.
						SZ5->(DbSetOrder(1))
						If SZ5->(DbSeek(xFilial("SZ5")+SZVTMP->PEDIDO))
							SZ5->( RecLock("SZ5",.F.) )
								SZ5->Z5_DESCST := SZ4->Z4_CATPROD
							SZ5->( MsUnLock() )
							aItemPed[8] := SZ5->Z5_DESCST
						Endif
						
						//Sai do laco ja que encontrou valor da faixa
						Exit
						
					Endif
				Else
					If nAcumula+nQtdMes >= SZ4->Z4_QTDMIN .AND. nAcumula+nQtdMes <= SZ4->Z4_QTDMAX
						
						//Tratamento para não buscar a categoria atual no calculo
						lTemZ4 := .T.
						
						//Gravo para utilizar novamente em caso de recalculo.
						SZ5->(DbSetOrder(1))
						If SZ5->(DbSeek(xFilial("SZ5")+SZVTMP->PEDIDO))
							SZ5->( RecLock("SZ5",.F.) )
								SZ5->Z5_DESCST := SZ4->Z4_CATPROD
							SZ5->( MsUnLock() )
							aItemPed[8] := SZ5->Z5_DESCST
						Endif
						
						//Sai do laco ja que encontrou valor da faixa
						Exit
						
					Endif
				EndIf
			Endif
			SZ4->( DbSkip() )
		End
	Endif
	
	//Se não tem faixa atualmente, gera o através da categoria do produto.
	If !lTemZ4 .And. SZVTMP->TIPO != "REEMBO"
	
		SZ5->( RecLock("SZ5",.F.) )
			SZ5->Z5_DESCST := " "
		SZ5->( MsUnLock() )
	
		PA8->(DbSetOrder(1))
		If PA8->(DbSeek(xFilial("PA8")+SZVTMP->PRODUTO))
		
			If SZ4->(DbSeek(xFilial("SZ4")+cEntidade+PA8->PA8_CATPRO))
				lTemZ4 := .T.
			Endif
			
		Endif
		
	Endif
	
	AADD(aPedidos,aItemPed)
	
	//Verifica se não tem lancamento de AR
	//Para pedido de AR Paga 3 porcento
	lTemAR := .F.
	SZ6->(DbSetOrder(2))
	If SZ6->(DbSeek(xFilial("SZ6")+SZVTMP->CODIGO_AR+SZVTMP->PEDIDO)) .And. SZ6->Z6_PERIODO == cPeriodo
		lTemAR := .T.
		aItemPed[7] := "SIM"
	Else
		aItemPed[7] := "NAO"
	Endif
	
	//Se o valor estiver incorreto, efetua ajuste no lancamento
	SZ6->(DbGoTo(SZVTMP->RECNOZ6))
	If SZ6->Z6_PEDGAR == SZVTMP->PEDIDO .And. !lTemAR .And. lTemFx .And. SZ6->Z6_PERIODO >= cPerAtu .And.;
	   !ZZG->(DbSeek(xFilial("ZZG")+MV_PAR02+PadR(MV_PAR03,6," ")+"1"))
		//Compara com valor atual
		If aItemPed[3] == "CAMPANHA DO CONTADOR"
			nValCom := Round(SZ6->Z6_BASECOM * (SZ4->Z4_PARSW/100),2)
		Else
			nValCom := Round(SZ6->Z6_BASECOM * (SZ4->Z4_PORSOFT/100),2)
		EndIf
		If SZ6->Z6_VALCOM != nValCom
			SZ6->(RecLock("SZ6",.F.))
				SZ6->Z6_VALCOM := nValCom
			SZ6->(MsUnlock())
			//Renato Ruy - 31/08/2018
			//Refaz o calculo do canal
			CRPA050C(SZVTMP->PERIODO, SZVTMP->PEDIDO) 
		Endif
	Elseif lTemAR .And. SZ6->Z6_PERIODO >= cPerAtu .And. !ZZG->(DbSeek(xFilial("ZZG")+MV_PAR02+PadR(MV_PAR03,6," ")+"1"))
		//Compara com valor atual
		nValCom := Round(SZ6->Z6_BASECOM * 0.03,2)
		If SZ6->Z6_VALCOM != nValCom
			SZ6->(RecLock("SZ6",.F.))
				SZ6->Z6_VALCOM := nValCom
			SZ6->(MsUnlock())
			//Renato Ruy - 31/08/2018
			//Refaz o calculo do canal
			CRPA050C(SZVTMP->PERIODO, SZVTMP->PEDIDO)
		Endif
	Elseif lTemZ4 .And. !ZZG->(DbSeek(xFilial("ZZG")+MV_PAR02+PadR(MV_PAR03,6," ")+"1")) .And.;
			!("CAMPANHA" $ aItemPed[3] .Or. "CLUBE" $ aItemPed[3])
		//Compara com valor atual
		nValCom := Round(SZ6->Z6_BASECOM * (SZ4->Z4_PORSOFT/100),2)
		If SZ6->Z6_VALCOM != nValCom
			SZ6->(RecLock("SZ6",.F.))
				SZ6->Z6_VALCOM := nValCom
			SZ6->(MsUnlock()) 
			//Renato Ruy - 31/08/2018
			//Refaz o calculo do canal
			CRPA050C(SZVTMP->PERIODO, SZVTMP->PEDIDO)
		Endif
	Elseif ("CAMPANHA" $ aItemPed[3] .Or. "CLUBE" $ aItemPed[3]) .And. SZVTMP->TIPO != "REEMBO"
		If lTemZ4
			nValCom := Round(SZ6->Z6_BASECOM * (SZ4->Z4_PARSW/100),2)
		Else
			nValCom := Round(SZ6->Z6_BASECOM * 0.03,2)
		EndIf
		If SZ6->Z6_VALCOM != nValCom
			SZ6->(RecLock("SZ6",.F.))
				SZ6->Z6_VALCOM := nValCom
			SZ6->(MsUnlock())
			//Renato Ruy - 31/08/2018
			//Refaz o calculo do canal
			CRPA050C(SZVTMP->PERIODO, SZVTMP->PEDIDO)
		Endif		
	Endif
	
	//Faz o skip na tabela temporaria antes da comparacao para gerar quando tem apenas uma entidade.
	SZVTMP->(DbSkip())
	
	//Renato Ruy - 21/11/2017
	//Alterado para efetuar o Ajuste de Saldo X Pedido
	If cPeriodo <> SZVTMP->PERIODO .Or. SZVTMP->(Eof())
		
		//Se encontrou atualiza
		If SZV->( DbSeek( xFilial("SZV") + cEntidade + SubStr(cPeriodo,1,4) ) )
			lFindSZV := .F.
		Else
			lFindSZV := .T.
		Endif
		
		SZV->( RecLock("SZV",lFindSZV) )
			SZV->ZV_FILIAL 	:= xFilial("SZV")
			SZV->ZV_SALANO	:= SubStr(cPeriodo,1,4)  
			SZV->ZV_CODENT 	:= cEntidade
			SZV->ZV_DESENT	:= cDescEnt
			SZV->ZV_QTDJAN	:= IIF(nMesAtual == 1,  nQtdMes, SZV->ZV_QTDJAN)
			SZV->ZV_CAMPJAN := IIF(nMesAtual == 1,  nQtdCampMes, SZV->ZV_CAMPJAN)
			SZV->ZV_QTDFEV	:= IIF(nMesAtual == 2,  nQtdMes, SZV->ZV_QTDFEV)
			SZV->ZV_CAMPFEV := IIF(nMesAtual == 2,  nQtdCampMes, SZV->ZV_CAMPFEV)
			SZV->ZV_QTDMAR	:= IIF(nMesAtual == 3,  nQtdMes, SZV->ZV_QTDMAR)
			SZV->ZV_CAMPMAR := IIF(nMesAtual == 3,  nQtdCampMes, SZV->ZV_CAMPMAR)
			SZV->ZV_QTDABR	:= IIF(nMesAtual == 4,  nQtdMes, SZV->ZV_QTDABR)
			SZV->ZV_CAMPABR := IIF(nMesAtual == 4,  nQtdCampMes, SZV->ZV_CAMPABR)
			SZV->ZV_QTDMAI	:= IIF(nMesAtual == 5,  nQtdMes, SZV->ZV_QTDMAI)
			SZV->ZV_CAMPMAI := IIF(nMesAtual == 5,  nQtdCampMes, SZV->ZV_CAMPMAI)
			SZV->ZV_QTDJUN	:= IIF(nMesAtual == 6,  nQtdMes, SZV->ZV_QTDJUN)
			SZV->ZV_CAMPJUN := IIF(nMesAtual == 6,  nQtdCampMes, SZV->ZV_CAMPJUN)
			SZV->ZV_QTDJUL	:= IIF(nMesAtual == 7,  nQtdMes, SZV->ZV_QTDJUL)
			SZV->ZV_CAMPJUL := IIF(nMesAtual == 7,  nQtdCampMes, SZV->ZV_CAMPJUL)
			SZV->ZV_QTDAGO	:= IIF(nMesAtual == 8,  nQtdMes, SZV->ZV_QTDAGO)
			SZV->ZV_CAMPAGO := IIF(nMesAtual == 8,  nQtdCampMes, SZV->ZV_CAMPAGO)
			SZV->ZV_QTDSET	:= IIF(nMesAtual == 9,  nQtdMes, SZV->ZV_QTDSET)
			SZV->ZV_CAMPSET := IIF(nMesAtual == 9,  nQtdCampMes, SZV->ZV_CAMPSET)
			SZV->ZV_QTDOUT 	:= IIF(nMesAtual == 10, nQtdMes, SZV->ZV_QTDOUT)
			SZV->ZV_CAMPOUT := IIF(nMesAtual == 10,  nQtdCampMes, SZV->ZV_CAMPOUT)
			SZV->ZV_QTDNOV	:= IIF(nMesAtual == 11, nQtdMes, SZV->ZV_QTDNOV)
			SZV->ZV_CAMPNOV := IIF(nMesAtual == 11,  nQtdCampMes, SZV->ZV_CAMPNOV)
			SZV->ZV_QTDDEZ	:= IIF(nMesAtual == 12, nQtdMes, SZV->ZV_QTDDEZ)
			SZV->ZV_CAMPDEZ := IIF(nMesAtual == 12,  nQtdCampMes, SZV->ZV_CAMPDEZ)
			SZV->ZV_SALACU 	:= 	SZV->ZV_QTDJAN + SZV->ZV_QTDFEV + SZV->ZV_QTDMAR +;
								SZV->ZV_QTDABR + SZV->ZV_QTDMAI + SZV->ZV_QTDJUN +;
								SZV->ZV_QTDJUL + SZV->ZV_QTDAGO + SZV->ZV_QTDSET +;
								SZV->ZV_QTDOUT + SZV->ZV_QTDNOV + SZV->ZV_QTDDEZ
			SZV->ZV_ACUCAMP := 	SZV->ZV_CAMPJAN + SZV->ZV_CAMPFEV + SZV->ZV_CAMPMAR +;
								SZV->ZV_CAMPABR + SZV->ZV_CAMPMAI + SZV->ZV_CAMPJUN +;
								SZV->ZV_CAMPJUL + SZV->ZV_CAMPAGO + SZV->ZV_CAMPSET +;
								SZV->ZV_CAMPOUT + SZV->ZV_CAMPNOV + SZV->ZV_CAMPDEZ
			SZV->ZV_LOGALT	:= "Automática (CRPA050) - "+DtoC(dDataBase)+" - "+Time()+" - INCLUIDO"
		SZV->( MsUnLock() )
				
		//Exporta arquivo com os dados do Log dos pedidos considerados na contagem.
		MsgRun("Favor Aguardar.....", "Exportando os Registros para o Excel",;
										{||DlgToExcel({{"ARRAY",;
										"Log do Calculo de Faixa",;
										aCabPed,aPedidos}})})

		MsgRun("Favor Aguardar.....", "Exportando os Registros para o Excel",;
										{||DlgToExcel({{"ARRAY",;
										"Log do Calculo de Faixa Campanha",;
										aCabPed,aPedCamp}})})
										
		//Busca o acumulado para o outro periodo e zera contador
		aPedidos := {}
		nQtdMes	 := 0
		nQtdCampMes := 0
		cEntCamp := ""
		cPeriodo := SZVTMP->PERIODO
		cEntidade:= SZVTMP->CODIGO_ENTIDADE
		cDescEnt := SZVTMP->DESCR_ENTIDADE
		nMesAtual:= Val(SubStr(SZVTMP->PERIODO,5,2))
		nAcumula := CRPA50AC(SZVTMP->CODIGO_ENTIDADE,nMesAtual-1)
		
	Endif
	
End

MsgInfo("Processamento finalizado com sucesso.")


Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CRPA050  º Autor ³ Tatiana Pontes 	   º Data ³ 10/07/12  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Cria grupo de perguntas									  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Certisign                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function AjustaSX1(cPerg)

Local cKey 		:= ""
Local aRegs		:= {}
Local aHelpEng 	:= {}
Local aHelpPor 	:= {}
Local aHelpSpa 	:= {}

//SX1 CERTISIGN
//PutSx1(cGrupo,cOrdem,cPergunt,cPerSpa,cPerEng,cVariavl,cTipo,nTamanho,nDecimal,nPresel,cGSC,cValid,cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01,cVar02,cDef02,cDefSpa2,cDefEng2,cCnt02,cVar03,cDef03,cDefSpa3,cDefEng3,cCnt03,cVar04,cDef04,cDefSpa4,cDefEng4,cCnt04,cVar05,cDef05,cDefSpa5,cDefEng5,cCnt05,cF3,cPyme,cGrpSxg,cHelp,cPicture,cIdfil)

Aadd(aRegs,{cPerg,"01","Per.Inicial (AAAAMM) ?"	,"","","MV_CH1","C",6,0,0,"G","","Mv_Par01","","","","","","","","","","","","","","","","","","","","","","","","",""	,"","","","",""})
Aadd(aRegs,{cPerg,"02","Per.Final (AAAAMM) ?"	,"","","MV_CH2","C",6,0,0,"G","","Mv_Par02","","","","","","","","","","","","","","","","","","","","","","","","",""	,"","","","",""})
Aadd(aRegs,{cPerg,"03","Grupo Entidade ?"		,"","","MV_CH3","C",4,0,0,"G","","Mv_Par03","","","","","","","","","","","","","","","","","","","","","","","","","SZA"	,"","","","",""})

If Len(aRegs) > 0
	PlsVldPerg( aRegs )
Endif

cKey     := "P.CRP05001."
aHelpEng := {}
aHelpPor := {}
aHelpSpa := {}
aAdd(aHelpEng,"")
aAdd(aHelpEng,"")
aAdd(aHelpPor,"Informe o Ano/Mes")
aAdd(aHelpPor,"inicial")
aAdd(aHelpSpa,"")
aAdd(aHelpSpa,"")
PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

cKey     := "P.CRP05002."
aHelpEng := {}
aHelpPor := {}
aHelpSpa := {}
aAdd(aHelpEng,"")
aAdd(aHelpEng,"")
aAdd(aHelpPor,"Informe o Ano/Mes")
aAdd(aHelpPor,"final")
aAdd(aHelpSpa,"")
aAdd(aHelpSpa,"")
PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

cKey     := "P.CRP05003."
aHelpEng := {}
aHelpPor := {}
aHelpSpa := {}
aAdd(aHelpEng,"")
aAdd(aHelpEng,"")
aAdd(aHelpPor,"Informe o Grupo/Rede")
aAdd(aHelpPor,"")
aAdd(aHelpSpa,"")
aAdd(aHelpSpa,"")
PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CRPA050F º Autor ³ RENATO RUY BERNARDO  º Data ³ 22/06/17  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ ROTINA PARA CONTROLE DA CAMPANHA DE INCENTIVO.			  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Certisign                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CRPA050F()

Local bValid  	:= {|| .T. }
Local aPar 		:= {}

Private aRet	:= {}

//Utilizo parambox para fazer as perguntas
aAdd( aPar,{ 1  ,"Periodo " 	 	,AllTrim(GetMV("MV_REMMES")),"","",""   ,"",50,.F.})
aAdd( aPar,{ 1  ,"Entidade"	 	 	,Space(6)					,"","","SZ3","",50,.F.})
aAdd( aPar,{ 2  ,"Tipo Ent." 	 	,"9" ,{"9=Posto","7=Revendedor"}, 100,'.T.',.T.})
If !ParamBox( aPar, 'Parâmetros', @aRet, bValid, , , , , ,"CRPA031" , .T., .F. )
	Alert("Processo Cancelado!")
	Return
Endif

//Renato Ruy - 28/03/2018
//Campanha de incentivo
If aRet[3] == "9"
	Processa( {|| CRPA050G() }, "Selecionando registros...")
//Controle de faixas para revendedores
Elseif aRet[3] == "7"
	Processa( {|| CRPA050R() }, "Selecionando registros...")
Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CRPA050F º Autor ³ RENATO RUY BERNARDO  º Data ³ 22/06/17  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ ROTINA PARA CONTROLE DA CAMPANHA DE INCENTIVO.			  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Certisign                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CRPA050G()

Local aProd		:= {}
Local cWhere	:= "" 
Local cFaixa	:= "" 
Local cLog		:= ""
Local cNomeArq	:= ""
Local cCabec	:= ""
Local nPorcFx	:= 0
Local nPorcPrd	:= 0
Local nTotPrd	:= 0
Local nTotal	:= 0
Local cPosto	:= "%  %"
Local lPosSZV	:= .F.
Local lPosSZ6E	:= .F.
Local lPosSZ6D	:= .F.
Local Ni, Nf

If !Empty(aRet[2])
	cPosto := "% Z3_CODENT = '"+ aRet[2] +"' AND %"
Endif

//Busca somente entidades que tem controle de faixa
Beginsql Alias "TMPINC"
	SELECT Z3_CODENT, Z3_DESENT, Z3_CODAC, Z3_PRODFX, Z3_TIPENT
	FROM %Table:SZ3%
	WHERE
	Z3_FILIAL = %xFilial:SZ3% AND
	%Exp:cPosto%
	Z3_FAIXA = '1' AND
	Z3_TIPENT = %Exp:aRet[3]% AND
	%Notdel%
Endsql

//Posiciona na tabela de contagem de entidade x faixas
SZV->(DbSetOrder(1)) //Filial + Entidade + Ano

//Posiciona na tabela de cadastro de percentual x entidade
SZ4->(DbSetOrder(1))

//Se Posiciona na SZ6 para buscar se a campanha ja existe
SZ6->(DbSetOrder(1)) // Filial + Pedido Gar + Entidade

//Busca os pedidos 
While !TMPINC->(EOF())

	IncProc( "Processando a Campanha de Incentivo da Entidade: " +  TMPINC->Z3_DESENT)
	ProcessMessage() 
    
    //Adiciona os produtos em um array para adicionar na consulta
    aProd := StrToArray(AllTrim(TMPINC->Z3_PRODFX),";")
    cWhere:= "% ("
    For nI := 1 To Len(aProd)
    	cWhere += Iif(nI==1,"","OR ")+ "Z6_PRODUTO Like '%"+aProd[nI]+"%' "
    Next
    cWhere+= ") AND"
    
    //Efetua tratamento do tipo de entidade informado para campanha de incentivo.
    If TMPINC->Z3_TIPENT == "9"
    	cWhere+= " Z6_CODCCR = '"+TMPINC->Z3_CODENT+"' AND %"
    Else
    	cWhere+= " Z6_CODENT = '"+TMPINC->Z3_CODENT+"' AND %"
    Endif 
    
    //Busca a quantidade de pedidos para determinar a faixa
	BeginSql Alias "TMPSUM"
		SELECT SUM(CONTADOR) CONTADOR FROM (
			SELECT 	CASE WHEN Z6_VALCOM > 0 THEN 1 ELSE -1 END CONTADOR
			FROM %Table:SZ6%
			WHERE
			Z6_FILIAL = %xFilial:SZ6% AND
			Z6_TIPO IN ('VERIFI','RENOVA', 'REEMBO') AND
			Z6_PERIODO = %Exp:aRet[1]% AND
			Z6_TPENTID = '4' AND
			Z6_CATPROD = '2' AND
			UPPER(Z6_DESCRPR) NOT LIKE '%SIMPLES CONECTIVIDADE%' AND
			Z6_VALCOM != 0 AND
			%Exp:cWhere%
			%Notdel%)
	Endsql
	
	//Procura a faixa do atual do parceiro
	For nF := 1 To 3
		cFaixa := " "
		nPorcFx:= 0
		If SZ4->(DbSeek(xFilial("SZ4")+TMPINC->Z3_CODENT+"F"+Transform(nF,"@E 9"))) .And.;
		   SZ4->Z4_QTDMIN <= TMPSUM->CONTADOR .And. SZ4->Z4_QTDMAX >= TMPSUM->CONTADOR
			cFaixa  := SZ4->Z4_CATPROD
			nPorcFx := SZ4->Z4_PORSOFT
			Exit
		EndIf
	Next
	
	lPosSZV := !SZV->(DbSeek(xFilial("SZV")+TMPINC->Z3_CODENT+SubStr(aRet[1],1,4)))
	
	//Grava o registro no periodo da contagem.
	SZV->( RecLock("SZV",lPosSZV) )
		SZV->ZV_SALANO	:= SubStr(aRet[1],1,4)
		SZV->ZV_CODENT	:= TMPINC->Z3_CODENT
		SZV->ZV_DESENT	:= TMPINC->Z3_DESENT
		SZV->ZV_DESENT	:= TMPINC->Z3_DESENT
		SZV->ZV_CATPROD := cFaixa
		SZV->ZV_CATDESC := Iif(Empty(cFaixa)," ",SZ4->Z4_CATDESC)
		SZV->ZV_QTDJAN	:= IIF(Val(SubStr(aRet[1],5,2)) == 1, TMPSUM->CONTADOR, SZV->ZV_QTDJAN)
		SZV->ZV_QTDFEV	:= IIF(Val(SubStr(aRet[1],5,2)) == 2, TMPSUM->CONTADOR, SZV->ZV_QTDFEV)
		SZV->ZV_QTDMAR	:= IIF(Val(SubStr(aRet[1],5,2)) == 3, TMPSUM->CONTADOR, SZV->ZV_QTDMAR)
		SZV->ZV_QTDABR	:= IIF(Val(SubStr(aRet[1],5,2)) == 4, TMPSUM->CONTADOR, SZV->ZV_QTDABR)
		SZV->ZV_QTDMAI	:= IIF(Val(SubStr(aRet[1],5,2)) == 5, TMPSUM->CONTADOR, SZV->ZV_QTDMAI)
		SZV->ZV_QTDJUN	:= IIF(Val(SubStr(aRet[1],5,2)) == 6, TMPSUM->CONTADOR, SZV->ZV_QTDJUN)
		SZV->ZV_QTDJUL	:= IIF(Val(SubStr(aRet[1],5,2)) == 7, TMPSUM->CONTADOR, SZV->ZV_QTDJUL)
		SZV->ZV_QTDAGO	:= IIF(Val(SubStr(aRet[1],5,2)) == 8, TMPSUM->CONTADOR, SZV->ZV_QTDAGO)
		SZV->ZV_QTDSET	:= IIF(Val(SubStr(aRet[1],5,2)) == 9, TMPSUM->CONTADOR, SZV->ZV_QTDSET)
		SZV->ZV_QTDOUT 	:= IIF(Val(SubStr(aRet[1],5,2)) == 10,TMPSUM->CONTADOR, SZV->ZV_QTDOUT)
		SZV->ZV_QTDNOV	:= IIF(Val(SubStr(aRet[1],5,2)) == 11,TMPSUM->CONTADOR, SZV->ZV_QTDNOV)
		SZV->ZV_QTDDEZ	:= IIF(Val(SubStr(aRet[1],5,2)) == 12,TMPSUM->CONTADOR, SZV->ZV_QTDDEZ)
		SZV->ZV_SALACU 	:= 	SZV->ZV_QTDJAN + SZV->ZV_QTDFEV + SZV->ZV_QTDMAR +;
							SZV->ZV_QTDABR + SZV->ZV_QTDMAI + SZV->ZV_QTDJUN +;
							SZV->ZV_QTDJUL + SZV->ZV_QTDAGO + SZV->ZV_QTDSET +;
							SZV->ZV_QTDOUT + SZV->ZV_QTDNOV + SZV->ZV_QTDDEZ
	SZV->( MsUnLock() )
	
	//Busca a quantidade de pedidos para determinar a faixa
	BeginSql Alias "TMPSZ6"
		SELECT 	Z6_CODENT,
				Z6_DESENT,
				Z6_PEDGAR,
				Z6_PRODUTO,
				Z6_DESCRPR,
				Z6_VLRPROD,
				Z6_BASECOM,
				Z6_VALCOM
		FROM %Table:SZ6%
		WHERE
		Z6_FILIAL = %xFilial:SZ6% AND
		Z6_TIPO IN ('VERIFI','RENOVA', 'REEMBO') AND
		Z6_PERIODO = %Exp:aRet[1]% AND
		Z6_TPENTID = '4' AND
		Z6_CATPROD = '2' AND
		UPPER(Z6_DESCRPR) NOT LIKE '%SIMPLES CONECTIVIDADE%' AND
		Z6_VALCOM != 0 AND
		%Exp:cWhere%
		%Notdel%
	Endsql
	
	//Zera os totalizadores e Log
	nPorcPrd := 0
	nTotPrd  := 0
	nTotal   := 0
	cLog 	 := ""
	cNomeArq := AllTrim(TMPINC->Z3_DESENT)+"-"+TMPINC->Z3_CODENT+"-"+DtoS(dDatabase)+StrTran(time(),":","")+".csv"
	
	While !TMPSZ6->(EOF())
	    
	    //Se tem faixa efetua calculo.
		If nPorcFx > 0
			//Busca o percentual pago pelo produto
			nPorcPrd := Round((nPorcFx/100) - (TMPSZ6->Z6_VALCOM/TMPSZ6->Z6_BASECOM),2)
			nTotPrd  := Round(TMPSZ6->Z6_BASECOM * nPorcPrd,2)
			
			//Alimenta o totalizador
			//If nTotPrd < 0
			//	nTotal := nTotal-1
			//Else
				nTotal += nTotPrd
			//Endif
		Endif
		
		cLog += RTrim(TMPSZ6->Z6_PEDGAR) + ";"
		cLog += RTrim(TMPSZ6->Z6_PRODUTO) + ";"
		cLog += RTrim(TMPSZ6->Z6_DESCRPR) + ";"
		cLog += LTrim(Transform(TMPSZ6->Z6_VLRPROD,"@E 999,999,999.99")) + ";"
		cLog += LTrim(Transform(TMPSZ6->Z6_BASECOM,"@E 999,999,999.99")) + ";"
		cLog += LTrim(Transform((TMPSZ6->Z6_VALCOM/TMPSZ6->Z6_BASECOM)*100,"@E 99.99")) + ";"
		cLog += LTrim(Transform(TMPSZ6->Z6_VALCOM,"@E 999,999,999.99")) + ";"
		cLog += LTrim(Transform(nPorcFx,"@E 99.99")) + ";"
		cLog += LTrim(Transform(nPorcPrd*100,"@E 99.99")) + ";"
		cLog += LTrim(Transform(nTotPrd,"@E 999,999,999.99"))
		cLog += CHR(13)+CHR(10)
		
		TMPSZ6->(DbSkip())
	Enddo
	
	cLog += "--;"
	cLog += "TOTAL GERAL;"
	cLog += "--;"
	cLog += "--;"
	cLog += "--;"
	cLog += "--;"
	cLog += "--;"
	cLog += "--;"
	cLog += "--;"
	cLog += LTrim(Transform(nTotal,"@E 999,999,999.99"))
	cLog += CHR(13)+CHR(10)
	
	//Grava os valores extra e desconto gerado para AC.
	/* MODELO DE REGISTRO DA IMPORTACAO DO ARQUIVO
	Reclock("SZ6",.T.)
		SZ6->Z6_PERIODO := cPeriodo
		SZ6->Z6_TIPO	:= Iif(AllTrim(aLin[3])=="E","EXTRA","DESCON")
		SZ6->Z6_PEDGAR  := Iif(AllTrim(aLin[3])=="E","EXTRA","DESCONTO")
		SZ6->Z6_PRODUTO := Iif(AllTrim(aLin[3])=="E","EXTRA","DESCONTO")
		SZ6->Z6_DESCRPR := Iif(AllTrim(aLin[3])=="E","VALOR EXTRA AR","DESCONTO VALOR EXTRA AR")
		SZ6->Z6_PEDGAR  := Iif(AllTrim(aLin[3])=="E","EXTRA","DESCONTO")
		SZ6->Z6_CODAC   := cCodAC
		SZ6->Z6_CODCCR  := cCodEnt
		SZ6->Z6_CODENT  := cCodEnt
		SZ6->Z6_DESENT  := Posicione("SZ3",1,xFilial("SZ3")+cCodEnt,"Z3_DESENT")
		SZ6->Z6_TPENTID := Iif(AllTrim(aLin[3])=="E","4","2")
		SZ6->Z6_CATPROD := "2"
		SZ6->Z6_VALCOM	:= nValCTot
	SZ6->(MsUnlock())
	*/
	
	//Gera valor Extra para Entidade se tem percentual
	If nPorcFx > 0
		
		//Gera o log do processamento x entidade.
		cCabec := "Pedido;Produto;Descrição;Valor Bruto;Valor Base;Percentual Pago Comissão;Valor Comissão;Percentual Incentivo;Percentual Pago Incentivo;Valor Comissão Incentivo"+CHR(13)+CHR(10)
		ExpCalc(cNomeArq,cLog,cCabec)
		
		//Se não encontra, cria um registro novo
		lPosSZ6E	:= .T.
		lPosSZ6D	:= .T.
		
		//Procura se ja existe para o CCR a campanha de incentivo criada
		If SZ6->(DbSeek(xFilial("SZ6")+PadR("EXTRA",10," ")+TMPINC->Z3_CODENT))
			While !SZ6->(EOF()) .And. TMPINC->Z3_CODENT == SZ6->Z6_CODENT .And. PadR("EXTRA",10," ") == SZ6->Z6_PEDGAR
				//Se ja existe o registro apenas marca para atualizacao e sai
				If aRet[1] == SZ6->Z6_PERIODO
					lPosSZ6E := .F.
					Exit
				Endif
				SZ6->(DbSkip())
			EndDo
		Endif
		
		//Gera ou Atualiza registro para o CCR.
		Reclock("SZ6",lPosSZ6E)
			SZ6->Z6_PERIODO := aRet[1]
			SZ6->Z6_TIPO	:= "EXTRA"
			SZ6->Z6_PEDGAR  := "EXTRA"
			SZ6->Z6_PRODUTO := "EXTRA"
			SZ6->Z6_DESCRPR := "VALOR EXTRA AR"
			SZ6->Z6_PEDGAR  := "EXTRA"
			SZ6->Z6_CODAC   := TMPINC->Z3_CODAC
			SZ6->Z6_CODCCR  := TMPINC->Z3_CODENT
			SZ6->Z6_CODENT  := TMPINC->Z3_CODENT
			SZ6->Z6_DESENT  := TMPINC->Z3_DESENT
			SZ6->Z6_TPENTID := "4"
			SZ6->Z6_CATPROD := "2"
			SZ6->Z6_VALCOM	:= nTotal
			SZ6->Z6_DESGRU	:= "CAMPANHA DE INCENTIVO"
		SZ6->(MsUnlock())
		
		//Procura se ja existe para a AC o desconto da campanha de incentivo
		If SZ6->(DbSeek(xFilial("SZ6")+PadR("DESCONTO",10," ")+TMPINC->Z3_CODAC))
			While !SZ6->(EOF()) .And. TMPINC->Z3_CODAC == SZ6->Z6_CODENT .And. PadR("DESCONTO",10," ") == SZ6->Z6_PEDGAR
				//Se ja existe o registro apenas marca para atualizacao e sai
				If aRet[1] == SZ6->Z6_PERIODO .And. SZ6->Z6_CODCCR == TMPINC->Z3_CODENT
					lPosSZ6D := .F.
					Exit
				Endif
				SZ6->(DbSkip())
			EndDo
		Endif
		
		Reclock("SZ6",lPosSZ6D)
			SZ6->Z6_PERIODO := aRet[1]
			SZ6->Z6_TIPO	:= "DESCON"
			SZ6->Z6_PEDGAR  := "DESCONTO"
			SZ6->Z6_PRODUTO := "DESCONTO"
			SZ6->Z6_DESCRPR := "DESCONTO VALOR EXTRA AR"
			SZ6->Z6_PEDGAR  := "DESCONTO"
			SZ6->Z6_CODAC   := TMPINC->Z3_CODAC
			SZ6->Z6_CODCCR  := TMPINC->Z3_CODENT
			SZ6->Z6_CODENT  := TMPINC->Z3_CODAC
			SZ6->Z6_DESENT  := Posicione("SZ3",1,xFilial("SZ3")+TMPINC->Z3_CODAC,"Z3_DESENT")
			SZ6->Z6_TPENTID := "2"
			SZ6->Z6_CATPROD := "2"
			SZ6->Z6_VALCOM	:= 0-nTotal
			SZ6->Z6_DESGRU	:= "CAMPANHA DE INCENTIVO"
		SZ6->(MsUnlock())
		
		
	Endif
	
	TMPSZ6->(DbCloseArea())
	TMPSUM->(DbCloseArea())
	TMPINC->(DbSkip())
Enddo

TMPINC->(DbCloseArea())

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ExpCalc  º Autor ³ RENATO RUY BERNARDO  º Data ³ 22/06/17  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ ROTINA PARA CONTROLE DA CAMPANHA DE INCENTIVO.			  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Certisign                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/ 
Static Function ExpCalc(cNomeArq, cLog, cCabec)

Local cArqLog := GetTempPath()+cNomeArq

// Abre o arquivo
nHandle := fopen(cArqLog , FO_READWRITE + FO_SHARED )

//Caso não encontre o arquivo o sistema cria
If nHandle == -1
	nHandle := fCreate(cArqLog)
	FWrite(nHandle, cCabec)
//Quando encontra se posiciona na última linha para gravar.
Else
	FSeek(nHandle, 0, FS_END)         // Posiciona no fim do arquivo
Endif

FWrite(nHandle, cLog + CHR(13)+CHR(10)) // Insere texto no arquivo

fclose(nHandle)           // Fecha arquivo

//Abre o excel com os dados
oExcelApp := MsExcel():New()
oExcelApp:WorkBooks:Open(cArqLog)
oExcelApp:SetVisible(.T.)

Return

//Renato Ruy - 22/11/2017
//Retorna os valores acumulados dos meses anteriores
Static Function CRPA50AC(cEntidade, nMesAtual, cPeriodo, lCampanha)

Local cAcumula := Iif(!lCampanha,"SZV->ZV_QTDJAN","SZV->ZV_CAMPJAN")
Local nAcumula := 0
Local Ni

If !lCampanha
	
	//Busca os valores acumulados anteriormente
	For nI := 1 To nMesAtual
		If nI == 2
			cAcumula += "+SZV->ZV_QTDFEV"
		Elseif nI == 3
			cAcumula += "+SZV->ZV_QTDMAR"
		Elseif nI == 4
			cAcumula += "+SZV->ZV_QTDABR"
		Elseif nI == 5
			cAcumula += "+SZV->ZV_QTDMAI"
		Elseif nI == 6
			cAcumula += "+SZV->ZV_QTDJUN"
		Elseif nI == 7
			cAcumula += "+SZV->ZV_QTDJUL"
		Elseif nI == 8
			cAcumula += "+SZV->ZV_QTDAGO"
		Elseif nI == 9
			cAcumula += "+SZV->ZV_QTDSET"
		Elseif nI == 10
			cAcumula += "+SZV->ZV_QTDOUT"
		Elseif nI == 11
			cAcumula += "+SZV->ZV_QTDNOV"
		Endif
	Next

Else

	//Busca os valores acumulados anteriormente
	For nI := 1 To nMesAtual
		If nI == 2
			cAcumula += "+SZV->ZV_CAMPFEV"
		Elseif nI == 3
			cAcumula += "+SZV->ZV_CAMPMAR"
		Elseif nI == 4
			cAcumula += "+SZV->ZV_CAMPABR"
		Elseif nI == 5
			cAcumula += "+SZV->ZV_CAMPMAI"
		Elseif nI == 6
			cAcumula += "+SZV->ZV_CAMPJUN"
		Elseif nI == 7
			cAcumula += "+SZV->ZV_CAMPJUL"
		Elseif nI == 8
			cAcumula += "+SZV->ZV_CAMPAGO"
		Elseif nI == 9
			cAcumula += "+SZV->ZV_CAMPSET"
		Elseif nI == 10
			cAcumula += "+SZV->ZV_CAMPOUT"
		Elseif nI == 11
			cAcumula += "+SZV->ZV_CAMPNOV"
		Endif
	Next

EndIf
//Se encontrou atualiza
If cPeriodo != nil
	If SZV->( DbSeek( xFilial("SZV") + cEntidade + SubStr(cPeriodo,1,4) ) )
		nAcumula := &(cAcumula)
	Endif
Endif

Return nAcumula

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CRPA050F º Autor ³ RENATO RUY BERNARDO  º Data ³ 22/06/17  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ ROTINA PARA CONTROLE DA CAMPANHA DE INCENTIVO.			  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Certisign                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CRPA050R()

Local cPosto		:= "%  %"
Local cCabLog		:= ""
Local cIteLog		:= ""
Local cNomeArq 	:= ""
Local nContagem	:= 0
Local cCodEnt		:= ""
Local cDescEnt	:= ""
Local cFaixa 		:= " "
Local nPorcFx		:= 0
Local lFindSZV	:= .F.
Local nTotal		:= 0
Local Ni, Nf

//Cabecalho do log
cCabLog += "Pedido Gar;"
cCabLog += "Codigo Entidade;"
cCabLog += "Descrição Entidade;"
cCabLog += "Data;"
cCabLog += "Faixa;"
cCabLog += "Percentual da Faixa;"
cCabLog += "Valor Base Pedido;"
cCabLog += "Total Comissão"+CHR(13)+CHR(10)


If !Empty(aRet[2])
	cPosto := "% AND Z3_CODENT = '"+ aRet[2] +"' %"
Endif

//Busca somente entidades que tem controle de faixa
Beginsql Alias "TMPINC"
	SELECT  Z3_CODENT CODENT,
	        Z3_DESENT DESENT,
	        Z6_PEDGAR PEDGAR,
	        CASE WHEN Z6_TIPO = 'RENOVA' THEN Z6_DTEMISS ELSE Z6_VERIFIC END DATA
	FROM SZ3010 SZ3
	JOIN SZ6010 SZ6 
	ON  Z6_FILIAL = %xFilial:SZ6% AND 
	    Z6_PERIODO = %Exp:aRet[1]% AND 
	    Z6_TPENTID = '10' AND 
	    Z6_CATPROD = '2' AND 
	    Z6_CODENT = Z3_CODENT AND 
	    SZ6.%Notdel%
	WHERE Z3_FILIAL = %xFilial:SZ3%
	AND Z3_FAIXA    = '1'
	AND Z3_TIPENT   = %Exp:aRet[3]%
	AND SZ3.%Notdel%
	%Exp:cPosto%
	ORDER BY Z3_CODENT, DATA, Z6_PEDGAR
Endsql

//Posiciona na tabela de contagem de entidade x faixas
SZV->(DbSetOrder(1)) //Filial + Entidade + Ano

//Posiciona na tabela de cadastro de percentual x entidade
SZ4->(DbSetOrder(1))

//Se Posiciona na SZ6 para buscar se a campanha ja existe
SZ6->(DbSetOrder(1)) // Filial + Pedido Gar + Entidade

//Se Posiciona na SZ5 para atualizar o percentual da campanha
SZ5->(DbSetOrder(1)) // Filial + Pedido Gar

cCodEnt := TMPINC->CODENT
cDescEnt:= TMPINC->DESENT

//Busca os pedidos 
While !TMPINC->(EOF())
	
	//Soma o contador
	nContagem++
	//Zera soma do pedido
	nTotal := 0
	
	//Procura a faixa do atual do parceiro
	For nF := 1 To 6
		cFaixa := " "
		nPorcFx:= 0
		If SZ4->(DbSeek(xFilial("SZ4")+TMPINC->CODENT+"F"+Transform(nF,"@E 9"))) .And.;
		   SZ4->Z4_QTDMIN <= nContagem .And. SZ4->Z4_QTDMAX >= nContagem
			cFaixa  := SZ4->Z4_CATPROD
			nPorcFx := SZ4->Z4_PORSOFT
			Exit
		EndIf
	Next
	
	//Se posiciona no registro do revendedor
	If SZ6->(DbSeek(xFilial("SZ6")+TMPINC->PEDGAR+TMPINC->CODENT))
		While !SZ6->(EOF()) .And. TMPINC->PEDGAR == SZ6->Z6_PEDGAR .And. SZ6->Z6_CODENT == TMPINC->CODENT
		
			RecLock("SZ6",.F.)
				SZ6->Z6_VALCOM := SZ6->Z6_BASECOM * (nPorcFx/100)
			SZ6->(MsUnlock())
			
			If SZ5->(DbSeek(xFilial("SZ5")+TMPINC->PEDGAR))
				RecLock("SZ5",.F.)
					SZ5->Z5_COMSW 	:= nPorcFx
					SZ5->Z5_PROCRET	:= "M"
				SZ5->(MsUnlock())
			Endif
			
			nTotal += SZ6->Z6_BASECOM 
			
			SZ6->(DbSkip())
		Enddo 
	Endif	
	
	//Armazena log dos itens
	cIteLog += TMPINC->PEDGAR + ";"
	cIteLog += TMPINC->CODENT + ";"
	cIteLog += TMPINC->DESENT + ";"
	cIteLog += DtoC(StoD(TMPINC->DATA)) + ";"
	cIteLog += cFaixa + ";"
	cIteLog += Transform(nPorcFx,"@E 999.99") + ";"
	cIteLog += Transform(nTotal,"@E 999,999,999.99") + ";"
	cIteLog += Transform(nTotal * (nPorcFx/100),"@E 999,999,999.99")+CHR(13)+CHR(10)
	
	TMPINC->(DbSkip())
	
	//Se mudou a entidade, zera contador
	If cCodEnt <> TMPINC->CODENT .Or. TMPINC->(EOF())
	
		//Se encontrou atualiza
		If SZV->( DbSeek( xFilial("SZV") + cCodEnt + SubStr(aRet[1],1,4) ) )
			lFindSZV := .F.
		Else
			lFindSZV := .T.
		Endif
		
		//Grava o acumulado para consulta
		SZV->( RecLock("SZV",lFindSZV) )
			SZV->ZV_FILIAL 	:= xFilial("SZV")
			SZV->ZV_SALANO	:= SubStr(aRet[1],1,4)  
			SZV->ZV_CODENT 	:= cCodEnt
			SZV->ZV_DESENT	:= cDescEnt
			SZV->ZV_CATPROD	:= cFaixa
			SZV->ZV_CATDESC	:= Iif(Empty(cFaixa)," ",SZ4->Z4_CATDESC)
			SZV->ZV_QTDJAN	:= IIF(Val(SubStr(aRet[1],5,2)) == 1, nContagem, SZV->ZV_QTDJAN)
			SZV->ZV_QTDFEV	:= IIF(Val(SubStr(aRet[1],5,2)) == 2, nContagem, SZV->ZV_QTDFEV)
			SZV->ZV_QTDMAR	:= IIF(Val(SubStr(aRet[1],5,2)) == 3, nContagem, SZV->ZV_QTDMAR)
			SZV->ZV_QTDABR	:= IIF(Val(SubStr(aRet[1],5,2)) == 4, nContagem, SZV->ZV_QTDABR)
			SZV->ZV_QTDMAI	:= IIF(Val(SubStr(aRet[1],5,2)) == 5, nContagem, SZV->ZV_QTDMAI)
			SZV->ZV_QTDJUN	:= IIF(Val(SubStr(aRet[1],5,2)) == 6, nContagem, SZV->ZV_QTDJUN)
			SZV->ZV_QTDJUL	:= IIF(Val(SubStr(aRet[1],5,2)) == 7, nContagem, SZV->ZV_QTDJUL)
			SZV->ZV_QTDAGO	:= IIF(Val(SubStr(aRet[1],5,2)) == 8, nContagem, SZV->ZV_QTDAGO)
			SZV->ZV_QTDSET	:= IIF(Val(SubStr(aRet[1],5,2)) == 9, nContagem, SZV->ZV_QTDSET)
			SZV->ZV_QTDOUT 	:= IIF(Val(SubStr(aRet[1],5,2)) == 10,nContagem, SZV->ZV_QTDOUT)
			SZV->ZV_QTDNOV	:= IIF(Val(SubStr(aRet[1],5,2)) == 11,nContagem, SZV->ZV_QTDNOV)
			SZV->ZV_QTDDEZ	:= IIF(Val(SubStr(aRet[1],5,2)) == 12,nContagem, SZV->ZV_QTDDEZ)
			SZV->ZV_SALACU 	:= 	SZV->ZV_QTDJAN + SZV->ZV_QTDFEV + SZV->ZV_QTDMAR +;
									SZV->ZV_QTDABR + SZV->ZV_QTDMAI + SZV->ZV_QTDJUN +;
									SZV->ZV_QTDJUL + SZV->ZV_QTDAGO + SZV->ZV_QTDSET +;
									SZV->ZV_QTDOUT + SZV->ZV_QTDNOV + SZV->ZV_QTDDEZ
		SZV->( MsUnLock() )
		
		//Gera nome para o relatorio
		cNomeArq := AllTrim(cDescEnt)+"-"+cCodEnt+"-"+DtoS(dDatabase)+StrTran(time(),":","")+".csv"
		
		//Envia para rotina de export
		ExpCalc(cNomeArq,cIteLog,cCabLog)
		
		cCodEnt 	:= TMPINC->CODENT
		cDescEnt	:= TMPINC->DESENT
		cIteLog	:= ""
		nContagem	:= 0
	Endif
	
Enddo

TMPINC->(DbCloseArea())


Return

//Renato Ruy - 31/08/2018
//Refaz o abatimento e recalcula Canal
Static Function CRPA050C(cPeriodo, cPedido)

Local aAreaSZ6 := SZ6->(GetArea())
Local nAbtAR   := 0
Local nAbtCart := 0
Local nAbtAC   := 0
Local nAbtCamS := 0
Local nAbtImp  := 0
Local nRCanal	 := 0
Local lBiometr := .F.

//Se posiciona no pedido
SZ6->(DbSetOrder(1))
If SZ6->(DbSeek(xFilial("SZ6")+cPedido))
	
	//Busca o percentual para calculo do abatimento
	While !SZ6->(EOF()) .And. SZ6->Z6_PEDGAR == cPedido
		
		If SZ6->Z6_PERIODO == cPeriodo .And. SZ6->Z6_CATPROD == "2" .And. SZ6->Z6_VALCOM != 0
		
			If "4" $ SZ6->Z6_TPENTID
				If SZ6->Z6_BASECOM+10 == SZ6->Z6_VLRPROD .Or. SZ6->Z6_BASECOM-10 == SZ6->Z6_VLRPROD
					lBiometr := .T.
				Endif
				nAbtAR := Round(SZ6->Z6_VALCOM / SZ6->Z6_BASECOM,2)
			Elseif AllTrim(SZ6->Z6_TPENTID) $ "2/5"
				nAbtAC := Round(SZ6->Z6_VALCOM / SZ6->Z6_BASECOM,2)
			Elseif "3" $ SZ6->Z6_TPENTID
				nAbtCart := Round(SZ6->Z6_VALCOM / SZ6->Z6_BASECOM,2)
			Elseif AllTrim(SZ6->Z6_TPENTID) == "7" .OR. AllTrim(SZ6->Z6_TPENTID) == "10"
				nAbtCamS := Round(SZ6->Z6_VALCOM / SZ6->Z6_BASECOM,2)
			Elseif "1" $ SZ6->Z6_TPENTID
				nRCanal := SZ6->(Recno())
			Endif			
		
		Endif
		SZ6->(DbSkip())
	Enddo
	
	//Se encontrou calculo para o canal
	If nRCanal > 0
	
		SZ6->(DbGoTo(nRCanal))
		
		//Se nao encontrar o produto
		PA8->(DbSetOrder(1))
		If !PA8->(MsSeek(xFilial("PA8")+SZ6->Z6_PRODUTO))
			Return
		Endif
		
		//Se nao encontrar o percentual
		SZ4->( DbSetOrder(1) )	// Z4_FILIAL+Z4_CODENT+Z4_CATPROD
		If SZ4->( !MsSeek( xFilial("SZ4") + SZ6->Z6_CODENT + PA8->PA8_CATPRO ) )
			Return
		EndIf
		
		If lBiometr
			nAbtCart:= (Iif(SZ6->Z6_VLRPROD > 0,SZ6->Z6_VLRPROD - 10,SZ6->Z6_VLRPROD + 10)) * nAbtCart
			nAbtAR  := (Iif(SZ6->Z6_VLRPROD > 0,SZ6->Z6_VLRPROD - 10,SZ6->Z6_VLRPROD + 10)) * nAbtAR
			nAbtAC  := (Iif(SZ6->Z6_VLRPROD > 0,SZ6->Z6_VLRPROD - 10,SZ6->Z6_VLRPROD + 10)) * nAbtAC
			
			cTiped	:= "BIOMETRIA"
		Else
			nAbtCart:= SZ6->Z6_VLRPROD * nAbtCart
			nAbtAR  := SZ6->Z6_VLRPROD * nAbtAR
			nAbtAC  := SZ6->Z6_VLRPROD * nAbtAC
		EndIf
		nAbtCamS:= SZ6->Z6_VLRPROD * nAbtCamS
		nAbtImp := SZ6->Z6_VLRPROD * (SZ4->Z4_IMPSOFT / 100)
		nBaseSw := SZ6->Z6_VLRPROD - nAbtAC- nAbtAR - nAbtCart - nAbtImp - nAbtCamS
		
		SZ6->(RecLock("SZ6",.F.))
			SZ6->Z6_BASECOM:= nBaseSw
			SZ6->Z6_VALCOM := nBaseSw * (SZ4->Z4_PORSOFT / 100)
			SZ6->Z6_VLRABT := nAbtAR + nAbtAC + nAbtImp + nAbtCart + nAbtCamS
		SZ6->(MsUnlock())
	
	Endif
	
Endif

RestArea(aAreaSZ6)

Return
