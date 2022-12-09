#include "totvs.ch"

// #########################################################################################
// Projeto: Integração Protheus x Checkout x Sage
// Modulo : Remuneração de Parceiros
// Fonte  : CRPA047
// ---------+-------------------+-----------------------------------------------------------
// Data     | Autor             | Descricao
// ---------+-------------------+-----------------------------------------------------------
// 16/01/18 | Renato Ruy			 | Tratamento de Pagamentos da Sage
// ---------+-------------------+-----------------------------------------------------------

user function CRPA047()
	
	//Variáveis
	local aCampos := {}
	local aCamposT:= {}
	local cFiltro	:= "GT_TYPE = 'G'"
	local cRemMes := AllTrim(GetMv("MV_REMMES"))
	local aCores	:= {{ 	'GTLEGADO->GT_DTREF<="'+cRemMes+'" Or ' , 'ENABLE'  },;    // Ativo
						{ 	'GTLEGADO->GT_DTREF>="'+cRemMes+'" Or GTLEGADO->GT_TXPAGO == GTLEGADO->GT_TXPARC' , 'DISABLE' }}    // Inativo
	
	//Indica a permissão ou não para a operação (pode-se utilizar 'ExecBlock')
	local cVldAlt := ".T." // Operacao: ALTERACAO
	local cVldExc := ".T." // Operacao: EXCLUSAO
	
	//trabalho/apoio
	local cTabela	:= "GTLEGADO"
	local cIndex	:= "GTLEGADO01"
	
	//Título a ser utilizado nas operações
	private cCadastro := "Controle Sage"
	
	//Rotinas da MBrowse
	private aRotina := {	{ "Visualizar"	, "U_CRPA047V(.F.)"	, 0, 6},;
							{ "Gera Medicao"	, "U_CRPA047C"		, 0, 7}}
	
	//Campos da MBrowse
	//[n][1]  -->  Descrição do campo
	//[n][2]  -->  Nome do campo
	//[n][3]  -->  Tipo do dado: “C” (caracter), “N” (numérico), “D” (data), etc.
	//[n][4]  -->  Tamanho
	//[n][5]  -->  Número de casas decimais
	//[n][6]  -->  Picture (formatação dos dados)
	
	aCampos := {	{"Tipo" 		, {|| GTLEGADO->GT_TYPE}		,"C", 1},;
					{"Pedido Gar"	, {|| GTLEGADO->GT_PEDGAR}	,"C", 10},;
					{"Pedido Site", {|| GTLEGADO->GT_PEDSITE}	,"C", 10},;
					{"Data Pedido", {|| GTLEGADO->GT_DATA}		,"D", 8},;
					{"Data Pagto.", {|| GTLEGADO->GT_DTREF}	,"D", 8},;
					{"Val.Produto", {|| GTLEGADO->GT_VLRPRD}	,"N", 12, 2},;
					{"Produto"		, {|| GTLEGADO->GT_PRODUTO}	,"C", 15},;
					{"Taxa"		, {|| GTLEGADO->GT_TXMANUT}	,"N", 12, 2},;
					{"Parcela Pg.", {|| GTLEGADO->GT_TXPAGO}	,"N", 2, 0},;
					{"Parcela Rec", {|| GTLEGADO->GT_TXRECEB}	,"N", 2, 0},;
					{"Total Parc.", {|| GTLEGADO->GT_TXPARC}	,"N", 2, 0} }
						
	//GERA TABELA TEMPORARIA
	If select("GTLEGADO") <= 0
		USE GTLEGADO ALIAS GTLEGADO SHARED NEW VIA "TOPCONN"
		If NetErr()
			UserException("Falha ao abrir GTLEGADO - SHARED" )
		Endif
		DbSetIndex("GTLEGADO01")
		DbSetOrder(1)
	Endif	
	
	dbSelectArea(cTabela)
	mBrowse( 6, 1, 22, 75, cTabela, aCampos,,,,,,,,,,,,,cFiltro)
	
	
return

//Renato Ruy - 16/01/2018
//Gera tela de visualização
User Function CRPA047V(lAlt)

Local aSize 	:= {}
Local bOk 		:= {|| oDialog:End()}
Local bCancel	:= {|| oDialog:End()}
Local cTipo	:= GTLEGADO->GT_TYPE
Local cPedGar	:= GTLEGADO->GT_PEDGAR
Local cPedSite:= GTLEGADO->GT_PEDSITE
Local dDatPed := StoD(GTLEGADO->GT_DATA)
Local dDatPag	:= StoD(GTLEGADO->GT_DTREF)
Local nValProd:= GTLEGADO->GT_VLRPRD
Local cProduto:= GTLEGADO->GT_PRODUTO
Local nTaxa	:= GTLEGADO->GT_TXMANUT
Local nParcPag:= GTLEGADO->GT_TXPAGO
Local nParcRec:= GTLEGADO->GT_TXRECEB
Local nParcTot:= GTLEGADO->GT_TXPARC
aSize := MsAdvSize(.F.)

Define MsDialog oDialog TITLE "Consulta Pedidos Sage" STYLE DS_MODALFRAME From aSize[7],0 To aSize[6],aSize[5] OF oMainWnd PIXEL
//oDialog:lMaximized := .T. //Maximiza a janela
//Usando o estilo STYLE DS_MODALFRAME, remove o botão X

@ 40,10 SAY "Pedido Gar" OF oDialog PIXEL
@ 40,70 MSGET cPedGar SIZE 50,5 OF oDialog  When lAlt PIXEL

@ 40,140 SAY "Pedido Site" OF oDialog PIXEL
@ 40,200 MSGET cPedSite SIZE 50,5 OF oDialog When lAlt PIXEL

@ 55,10 SAY "Data Pedido" OF oDialog PIXEL
@ 55,70 MSGET dDatPed SIZE 50,5 OF oDialog When lAlt PIXEL

@ 55,140 SAY "Dt.Ult.Medição" OF oDialog PIXEL
@ 55,200 MSGET dDatPag SIZE 50,5 OF oDialog When lAlt PIXEL

@ 70,10 SAY "Val.Produto" OF oDialog PIXEL
@ 70,70 MSGET nValProd SIZE 50,5 Picture "@E 99,999,999.99" OF oDialog When lAlt PIXEL

@ 70,140 SAY "Produto" OF oDialog PIXEL
@ 70,200 MSGET cProduto SIZE 50,5 OF oDialog When lAlt PIXEL

@ 85,10 SAY "Valor Taxa" OF oDialog PIXEL
@ 85,70 MSGET nTaxa SIZE 50,5 Picture "@E 999.99" OF oDialog When lAlt PIXEL

@ 85,140 SAY "Parcelas Pg." OF oDialog PIXEL
@ 85,200 MSGET nParcPag SIZE 50,5 Picture "@E 99" OF oDialog When lAlt PIXEL

@ 100,10 SAY "Parcelas Rec" OF oDialog PIXEL
@ 100,70 MSGET nParcRec SIZE 50,5 Picture "@E 99" OF oDialog When lAlt PIXEL

@ 100,140 SAY "Parcelas Pg." OF oDialog PIXEL
@ 100,200 MSGET nParcTot SIZE 50,5 Picture "@E 99" OF oDialog When lAlt PIXEL

ACTIVATE MSDIALOG oDialog ON INIT EnchoiceBar(oDialog, bOk , bCancel) CENTERED

Return

//Renato Ruy - 17/01/2018
//Rotina para calculo, gera medição e relatório com pedidos
User Function CRPA047C()

Local aRet 		:= {}
Local bValid  	:= {|| .T. }

Private aPar 	:= {}

//Utilizo parambox para fazer as perguntas
aAdd( aPar,{ 1  ,"Periodo " 	 	,Space(06),"","",""   ,"",50,.F.})
aAdd( aPar,{ 1  ,"Fornecedor " 	 	,Space(06),"","","SA2","",50,.F.})
aAdd( aPar,{ 1  ,"Produto " 	 	,Space(15),"","","SB1","",50,.F.})
aAdd( aPar,{ 1  ,"Condição " 	 	,Space(03),"","","SE4","",50,.F.})

ParamBox( aPar, 'Parâmetros', @aRet, bValid, , , , , ,"CRPA047" , .T., .F. )
If Len(aRet) > 0
	Processa( {|| CRPA47C(aRet) }, "Processando...")
Else
	Alert("Rotina Cancelada!")
EndIf

Return

//Renato Ruy - 17/01/2018
Static Function CRPA47C(aRet)

Local nTotal 		:= 0
Local nContador	:= 0
Local aLog			:= {}

IncProc( "Buscando Contrato para o Fornecedor: " + aRet[2])
ProcessMessage()  

//Busco os dados do contrato.
Beginsql Alias "TMPMED"
	SELECT CNC_NUMERO CONTRATO, MAX(CNC_REVISA) REVISAO FROM %Table:CNC%  CNC
	JOIN %Table:CN9% CN9 ON CN9_FILIAL = %xFilial:CN9% AND CN9_NUMERO = CNC_NUMERO AND CN9_SITUAC = '05' AND CN9.%NotDel% 
	WHERE
	CNC_FILIAL = %xFilial:CNC% AND
	CNC_CODIGO = %Exp:aRet[2]% AND
	CNC_LOJA = '01' AND
	CNC.%NotDel%
	GROUP BY CNC_NUMERO
Endsql

If Empty(TMPMED->CONTRATO)
	Alert("Não Existe Contrato Ativo para Este Fornecedor!")
	Return
Endif

IncProc( "Buscando Pedidos da Sage para o período: " + aRet[1])
ProcessMessage()  

Beginsql Alias "TMPREF"
	SELECT  C5_CTRSAGE,
	        A1_NOME,
	        GT.R_E_C_N_O_ GTRECNO
	FROM GTLEGADO GT
	LEFT JOIN SC5010 SC5 
		ON C5_FILIAL = %xFilial:SC5% AND C5_CHVBPAG = GT_PEDGAR AND SC5.%NOTDEL%
	LEFT JOIN SA1010 SA1 
		ON A1_FILIAL = ' ' AND A1_COD = SC5.C5_CLIENT AND A1_LOJA = SC5.C5_LOJACLI AND SA1.%NOTDEL%
	WHERE
	GT_TYPE = 'G' AND
	SUBSTR(GT_DTREF,1,6) <= %Exp:aRet[1]% AND
	GT_TXPARC > GT_TXPAGO AND
	GT.%NOTDEL%
Endsql

IncProc( "Processando Pedidos da Sage para o período: " + aRet[1])
ProcessMessage()

While !TMPREF->(EOF())
	
	GTLEGADO->(DbGoTo(TMPREF->GTRECNO))
	
	//Se o pedido
	If aRet[1] > SubStr(GTLEGADO->GT_DTREF,1,6) 
		RecLock("GTLEGADO",.F.)
			GTLEGADO->GT_DTREF := aRet[1]+"01"
			GTLEGADO->GT_TXPAGO+= 1
		GTLEGADO->(MsUnlock())
	Endif
	
	//Alimenta Array para gerar o relatório
	AADD(aLog,{AllTrim(TMPREF->A1_NOME),;
				GTLEGADO->GT_PEDSITE,;
				GTLEGADO->GT_PEDGAR,;
        		TMPREF->C5_CTRSAGE,;
        		SubStr(GTLEGADO->GT_DTREF,1,6),;
        		GTLEGADO->GT_TXMANUT,;
        		GTLEGADO->GT_TXPAGO,;
        		GTLEGADO->GT_TXPARC})
	
	nTotal   += GTLEGADO->GT_TXMANUT
	nContador++
	
	TMPREF->(DbSkip())
Enddo

//Renato Ruy - 17/01/2018
//Gera Log para controle
IncProc( "Gerando relatório com o pedidos do período")
ProcessMessage()
CRPA47L(aLog)

//Renato Ruy - 18/01/2018
//Gera medição de compra do serviço
CRPA047M(aRet,nTotal)

Return

//Renato Ruy - 17/01/2018
//Rotina para geração do log
Static Function CRPA47L(aLog)

Local aHead := {}

Aadd(aHead,"CLIENTE")	
Aadd(aHead,"PEDIDO GAR")
Aadd(aHead,"PEDIDO SITE")
Aadd(aHead,"CONTRATO SAGE")
Aadd(aHead,"DATA PAGAMENTO(ANO+MÊS)")
Aadd(aHead,"TAXA DE MANUTENÇÃO")
Aadd(aHead,"PARCELA ATUAL")
Aadd(aHead,"TOTAL DE PARCELAS")

//Exporta arquivo com os dados do Log de Pedidos em Lote.
MsgRun("Favor Aguardar.....", "Exportando os Registros para o Excel",;
								{||DlgToExcel({{"ARRAY",;
								"RELATÓRIO SAGE",;
								aHead,aLog}})})

Return

//Renato Ruy - 18/01/2018
//Rotina para gerar a medição de compra
Static Function CRPA047M(aRet,nTotal)

Local aCabec := {}
Local aLinha := {}
Local aItens := {}
Local cNumCND:= ""

//Renato Ruy - 18/01/2018
//Estorna pedidos se existir
Beginsql Alias "TMPPED"
	SELECT CND_CONTRA,
			CND_REVISA,
			CND_NUMERO,
			CND_PARCEL,
			CND_COMPET,
			CND_NUMMED,
			CND_FORNEC,
			CND_LJFORN,
			CND_PEDIDO,
			F1_DOC,
			CND.R_E_C_N_O_ RECNOCND
	FROM %Table:CND% CND
	LEFT JOIN %Table:SD1% SD1 ON D1_FILIAL = %xFilial:SD1% AND D1_PEDIDO > ' ' AND D1_PEDIDO = CND_PEDIDO AND SD1.%NOTDEL%
	LEFT JOIN %Table:SF1% SF1 ON F1_FILIAL = %xFilial:SF1% AND F1_DOC = D1_DOC AND F1_FORNECE = %Exp:aRet[2]% AND F1_TIPO = 'N' AND SF1.%NOTDEL%
	WHERE
	CND_FILIAL = %xFilial:CND% AND
	CND_COMPET = %Exp:aRet[1]% AND
	CND_FORNEC = %Exp:aRet[2]% AND
	UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(CND_OBS, 4,1)) = 'SAGE' AND
	CND.%NOTDEL%
Endsql

//Se existe medição que não foi encerrada e tem nota, informa o usuário
if !Empty(TMPPED->F1_DOC)
	Alert("Já existe Nota Fiscal para este período e não poderá ser recalculado!")
	Return
ElseIf !Empty(TMPPED->CND_NUMMED)
	CND->(DbGoTo(TMPPED->RECNOCND))
	aCabec := {}
	aAdd(aCabec,{"CND_CONTRA"	,TMPPED->CND_CONTRA		,NIL})
	aAdd(aCabec,{"CND_REVISA"	,TMPPED->CND_REVISA		,NIL})
	aAdd(aCabec,{"CND_NUMERO"	,TMPPED->CND_NUMERO		,NIL})
	aAdd(aCabec,{"CND_PARCEL"	,TMPPED->CND_PARCEL		,NIL})
	aAdd(aCabec,{"CND_COMPET"	,TMPPED->CND_COMPET		,NIL})
	aAdd(aCabec,{"CND_NUMMED"	,TMPPED->CND_NUMMED		,NIL})
	aAdd(aCabec,{"CND_FORNEC"	,TMPPED->CND_FORNEC		,NIL})
	aAdd(aCabec,{"CND_LJFORN"	,TMPPED->CND_LJFORN		,NIL})
	aAdd(aCabec,{"CND_PEDIDO"	,TMPPED->CND_PEDIDO		,NIL})
	
	//Caso não exista pedido, somente faço a exclusão.
	If Empty(CND->CND_PEDIDO)
		CNTA120(aCabec,aItens,5,.F.)
	//Quando existe pedido, faço estorno e faço a exclusão
	Else
		CNTA120(aCabec,aItens,7,.F.) //Estorno
		CNTA120(aCabec,aItens,5,.F.) //Exclui Medição
	EndIf	
EndIf

SB1->(DbSetOrder(1))
SB1->(DbSeek(xFilial("SB1")+aRet[3]))

dbSelectArea("CN9")
dbSetOrder(1)
If !dbSeek(xFilial("CN9")+TMPMED->CONTRATO+TMPMED->REVISAO)
	MsgInfo("Não foi possível encontrar o contrato: "+TMPMED->CONTRATO+" Revisão: "+TMPMED->REVISAO)
EndIf

CN1->(dbSetOrder(1))
CN1->(dbseek(xFilial("CN1")+CN9->CN9_TPCTO))

aCabec := {}
cNumCND	:= CriaVar("CND_NUMMED")
aAdd(aCabec,{"CND_CONTRA"	,TMPMED->CONTRATO								,NIL})
aAdd(aCabec,{"CND_REVISA"	,TMPMED->REVISAO								,NIL})
aAdd(aCabec,{"CND_NUMERO"	,"000001"										,NIL})
aAdd(aCabec,{"CND_PARCEL"	," "											,NIL})
aAdd(aCabec,{"CND_COMPET"	,aRet[1]										,NIL})
aAdd(aCabec,{"CND_NUMMED"	,cNumCND										,NIL})
aAdd(aCabec,{"CND_FORNEC"	,aRet[2]										,NIL})
aAdd(aCabec,{"CND_LJFORN"	,"01"											,NIL})
aAdd(aCabec,{"CND_CONDPG"	,aRet[4]										,NIL})
aAdd(aCabec,{"CND_VLTOT"		,nTotal										,NIL})
aAdd(aCabec,{"CND_APROV"		,Posicione('CTT',1, xFilial('CTT')+"80000000",'CTT_GARVAR'),NIL})
aAdd(aCabec,{"CND_MOEDA"		,"1"											,NIL})
aAdd(aCabec,{"CND_OBS"		,"SAGE"										,NIL})

aLinha := {}
aadd(aLinha,{"CNE_ITEM" 		,"001"											,NIL})
aadd(aLinha,{"CNE_PRODUT" 	,aRet[3]										,NIL})
aadd(aLinha,{"CNE_QUANT" 	,1 												,NIL})
aadd(aLinha,{"CNE_VLUNIT" 	,nTotal										,NIL})
aadd(aLinha,{"CNE_VLTOT" 	,nTotal										,NIL})
aadd(aLinha,{"CNE_TE" 		,"101"											,NIL})
aadd(aLinha,{"CNE_DTENT"		,dDatabase										,NIL})
aadd(aLinha,{"CNE_CC" 		,"80000000"					   				,NIL})
aadd(aLinha,{"CNE_CONTA"		,SB1->B1_CONTA								,NIL})
//CC: 80000000
aadd(aItens,aLinha)

//Executa rotina automatica para gerar as medicoes
CNTA120(aCabec,aItens,3,.F.)

CND->(DbSetOrder(4))
If !CND->(DbSeek(xFilial("CND")+cNumCND))
	MsgInfo("Não foi possível gerar a medição!")
	TTRB->(DbSkip())
Else
	//Encerra medição
	CNTA120(aCabec,aItens,6)
EndIf

//Me posiciono para verificar se foi encerradaad a medição.
CND->(DbSetOrder(4))
CND->(DbSeek(xFilial("CND")+cNumCND))

//Se não encerrou, exclui.
If Empty(CND->CND_PEDIDO)
	//Exclui a medição caso tenha problema no encerramento.
	CND->(RecLock("CND",.F.))
		CND->(DbDelete())
	CND->(MsUnLock())
	
	CNE->(DbSetOrder(4))
	If CNE->(DbSeek(xFilial("CNE")+cNumCND))
		CNE->(RecLock("CNE",.F.))
			CNE->(DbDelete())
		CNE->(MsUnLock())
	Endif
Endif

Return