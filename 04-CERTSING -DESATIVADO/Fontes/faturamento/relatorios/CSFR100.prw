#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} CSFR100
//Rotina para geração dos pedidos a serem enviados para a Haiecon, mediante gravação na
//tabela temporária GTMKT
@author yuri.volpe
@since 20/02/2019
@version 1.0
@return Nil

@type function
/*/
user function CSFR100()
	
Local aParam	:= {}
Local aRet		:= {}
Local cTitle 	:= "Ano base"

Private lJob	:= .F.

aAdd(aParam,{1,@cTitle,Space(4),"@!","","","",40,.T.})

//---------------------------------------------------------------
// Chama parambox para definição do período
//---------------------------------------------------------------	
If Parambox(aParam,"Relatório Pedidos Pagos Sem Emissão",@aRet,,,.T.)
	Processa({|x| CFA900Proc(aRet)},"Gerando relatório...")
EndIf
	
Return

/*/{Protheus.doc} CFA900Proc
//Processamento dos dados para geração dos registros na tabela GTMKT
//Gera também arquivo CSV de saída e logs CSV.
@author yuri.volpe
@since 20/02/2019
@version 1.0
@return Nil
@param aRet, array, Período a ser processado
@type function
/*/
Static Function CFA900Proc(aRet)

Local cQuery 		:= ""
Local cAno	 		:= aRet[1]
Local cDataAno 		:= cAno + "0101"
Local cAlias		:= GetNextAlias()
Local cAliasCnt		:= GetNextAlias()
Local cLinha		:= ""
Local cLinhaLog		:= ""
Local cLinOutput	:= ""
Local cCPFTit		:= ""
Local cTel			:= ""
Local cCel			:= ""
Local cArquivo		:= "\temp\NotIssued_" + DTOS(Date()) + "_" + StrTran(Time(),":","") + ".csv"
Local cArqLog		:= "\temp\NotIssued_Log_" + DTOS(Date()) + "_" + StrTran(Time(),":","") + ".csv"
Local cArqFull		:= "\temp\NotIssued_Report_" + DTOS(Date()) + "_" + StrTran(Time(),":","") + ".csv"
Local cDataValida	:= ""
Local cDataEmissao	:= ""
Local cDataRevoga	:= ""
Local cDirIn		:= ""
Local aRetFone		:= {}
Local nHdl			:= 0
Local nHdlLog		:= 0
Local nHdlOutput	:= 0
Local cPerfil		:= ""
Local cDescPerfil	:= ""
Local cPedSite		:= ""
Local cPedGar		:= ""
Local cPedOld		:= ""

If lJob
	LogWrite("Process","Query","Iniciando processamento da Query")
EndIf

//----------------------------------------------------------------------------------------
// Query para captura dos Pedidos de Backlog não emitidos
//----------------------------------------------------------------------------------------
cQuery += "SELECT * " + CRLF
cQuery += "	FROM " + CRLF
cQuery += "	(" + CRLF
cQuery += "	 SELECT" + CRLF
cQuery += "	      C5_NUM PEDIDO,"+ CRLF
cQuery += "	      C5_EMISSAO EMISSAO_PED," + CRLF
cQuery += "	      C5_XNPSITE PEDSITE," + CRLF
cQuery += "	      C5_CHVBPAG PEDGAR," + CRLF
cQuery += "	      (SELECT MAX (SZ5.Z5_DATPED)  FROM " + RetSqlName("SZ5") + " SZ5 WHERE Z5_FILIAL = '  ' AND Z5_PEDGAR = C5_CHVBPAG AND C5_CHVBPAG > ' ' AND SZ5.D_E_L_E_T_ = ' ') AS DATPED," + CRLF
cQuery += "	      (SELECT MAX (SZ5.Z5_EMISSAO) FROM " + RetSqlName("SZ5") + " SZ5 WHERE Z5_FILIAL = '  ' AND Z5_PEDGAR = C5_CHVBPAG AND C5_CHVBPAG > ' ' AND SZ5.D_E_L_E_T_ = ' ') AS DATSOL," + CRLF
cQuery += "	      (SELECT MAX (SZ5.Z5_DATVAL)  FROM " + RetSqlName("SZ5") + " SZ5 WHERE Z5_FILIAL = '  ' AND Z5_PEDGAR = C5_CHVBPAG AND C5_CHVBPAG > ' ' AND SZ5.D_E_L_E_T_ = ' ') AS DATVAL," + CRLF
cQuery += "	      (SELECT MAX (SZ5.Z5_DATEMIS) FROM " + RetSqlName("SZ5") + " SZ5 WHERE Z5_FILIAL = '  ' AND Z5_PEDGAR = C5_CHVBPAG AND C5_CHVBPAG > ' ' AND SZ5.D_E_L_E_T_ = ' ') AS DATEMIS," + CRLF
cQuery += "       (SELECT MAX (SZ5.Z5_PEDGANT) FROM " + RetSqlName("SZ5") + " SZ5 WHERE Z5_FILIAL = '  ' AND Z5_PEDGAR = C5_CHVBPAG AND C5_CHVBPAG > ' ' AND SZ5.D_E_L_E_T_ = ' ') AS PEDGANT," + CRLF
cQuery += "       (SELECT MAX (SZ5.Z5_REVOGA) FROM " + RetSqlName("SZ5") + " SZ5 WHERE Z5_FILIAL = '  ' AND Z5_PEDGAR = C5_CHVBPAG AND C5_CHVBPAG > ' ' AND SZ5.D_E_L_E_T_ = ' ') AS DATREVOGA," + CRLF
cQuery += "	      C5_TIPMOV TIPMOV," + CRLF
cQuery += "	      C5_TIPVOU TIPVOU," + CRLF
cQuery += "	      C5_XNATURE NATUREZA," + CRLF
cQuery += "	      (SELECT MIN (SE1.E1_EMISSAO) FROM " + RetSqlName("SE1") + " SE1 WHERE E1_FILIAL = '  ' AND E1_PEDIDO = C5_NUM AND SE1.D_E_L_E_T_ = ' ' AND SE1.E1_TIPO = 'PR')  AS EMIS_PR," + CRLF
cQuery += "	      (SELECT MIN (SE1.E1_EMISSAO) FROM " + RetSqlName("SE1") + " SE1 WHERE E1_FILIAL = '  ' AND E1_PEDIDO = C5_NUM AND SE1.D_E_L_E_T_ = ' ' AND SE1.E1_TIPO = 'NCC') AS EMIS_NCC," + CRLF  
cQuery += "	      (SELECT SUM(E1_VALOR)        FROM " + RetSqlName("SE1") + " SE1 WHERE E1_FILIAL = '  ' AND E1_PEDIDO = C5_NUM AND SE1.D_E_L_E_T_ = ' ' AND SE1.E1_TIPO = 'PR')  AS VALOR_PR," + CRLF
cQuery += "	      (SELECT SUM(E1_VALOR)        FROM " + RetSqlName("SE1") + " SE1 WHERE E1_FILIAL = '  ' AND E1_PEDIDO = C5_NUM AND SE1.D_E_L_E_T_ = ' ' AND SE1.E1_TIPO = 'NCC') AS VALOR_NCC," + CRLF
cQuery += "	      (SELECT SUM(E1_SALDO)        FROM " + RetSqlName("SE1") + " SE1 WHERE E1_FILIAL = '  ' AND E1_PEDIDO = C5_NUM AND SE1.D_E_L_E_T_ = ' ' AND SE1.E1_TIPO = 'PR')  AS SALDO_PR," + CRLF
cQuery += "	      (SELECT SUM(E1_SALDO)        FROM " + RetSqlName("SE1") + " SE1 WHERE E1_FILIAL = '  ' AND E1_PEDIDO = C5_NUM AND SE1.D_E_L_E_T_ = ' ' AND SE1.E1_TIPO = 'NCC') AS SALDO_NCC," + CRLF
cQuery += "	      C5_XCARTAO CARTAO," + CRLF
cQuery += "	      C5_XCODAUT CODAUT," + CRLF
cQuery += "	      C5_XNPARCE PARCELA," + CRLF
cQuery += "	      C5_XLINDIG LINHA_DIG," + CRLF
cQuery += "	      C5_XNUMVOU NUMVOU," + CRLF
cQuery += "	      C5_XRECPG RECIBO," + CRLF
cQuery += "	      C5_XNFHRD NF_HRD," + CRLF
cQuery += "	      C5_XNFSFW NF_SFW," + CRLF
cQuery += "	      C5_TOTPED TOTPED," + CRLF 
cQuery += "	      C5_NOTA   NOTA" + CRLF   
cQuery += "	FROM" + CRLF
cQuery += "	      " + RetSqlName("SC5") + " SC5" + CRLF
cQuery += "	WHERE" + CRLF
cQuery += "	      C5_FILIAL = ' '" + CRLF
cQuery += "	      AND C5_EMISSAO >= '" + cDataAno + "'" + CRLF
cQuery += "	      AND C5_XORIGPV = ANY('2', 'A') " + CRLF
cQuery += "	      AND SC5.D_E_L_E_T_ = ' ' " + CRLF 
cQuery += "       AND C5_XRECPG > ' ' " + CRLF 
cQuery += "	      AND C5_NOTA = ' ' " + CRLF    
cQuery += "	) " + CRLF
cQuery += "	WHERE " + CRLF
cQuery += "	(" + CRLF
cQuery += "	 ( " + CRLF 

//Autorizações de pagamentos por cartão de pedidos GAR que não foram validados ou emitidos há mais de 30 dias.
cQuery += "	   (EMIS_PR >= '" + cDataAno + "' AND EMIS_PR<= '" + DtoS(dDataBase-30) + "' AND ( SALDO_PR > 0 OR SALDO_NCC > 0))" + CRLF
cQuery += "	   OR " + CRLF

//Recebimentos de pedidos GAR (Cartão ou Boleto) que não foram validados ou não foram emitidos há mais de 30 dias.
cQuery += "	   (EMIS_NCC >= '" + cDataAno + "' AND EMIS_NCC <= '" + DtoS(dDataBase-30) + "' AND SALDO_NCC > 0 )" + CRLF
cQuery += "	 )" + CRLF

//Pedidos que não foram emitidos
cQuery += "	 AND (DATEMIS = ' ' OR DATEMIS IS NULL)" + CRLF

//Exclui o saldo residual de compensação de títulos - Serão tratados na rotina FCOMPSUB()
cQuery += "	 AND VALOR_NCC > 0.02" + CRLF

cQuery += "    )" + CRLF

MemoWrite("C:\DATA\wow\csfr100.sql",cQuery)

//Contador
cQueryCount := "SELECT COUNT(*) COUNT FROM (" + cQuery + ") "

//----------------------------------------------
// Limpeza das tabelas abertas
//----------------------------------------------
If Select(cAlias) > 0
	(cAlias)->(dbCloseArea())
EndIf

If Select(cAliasCnt) > 0
	(cAliasCnt)->(dbCloseArea())
EndIf

//Trunca tabela temporária
TcSqlExec("TRUNCATE TABLE PROTHEUS.GTMKT")

//----------------------------------------------
// Executa Query com mensagem na tela
//----------------------------------------------
If lJob
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)
	LogWrite("Process","Query Exec","Processamento da Query encerrado.")
Else	
	MsAguarde({||dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.),dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQueryCount),cAliasCnt,.T.,.T.)},"Realizando Consulta","Executando query...",.F.)
	
	nCount := (cAliasCnt)->COUNT
	ProcRegua(nCount)
	
	(cAliasCnt)->(dbCloseArea())
	(cAlias)->(dbGoTop())
EndIf

//----------------------------------------------
// Abre tabelas para processamento
//----------------------------------------------
dbSelectArea("SZ5")
SZ5->(dbSetOrder(1))

dbSelectArea("SA1")
SA1->(dbSetOrder(1))

dbSelectArea("SC5")
SC5->(dbSetOrder(1))

dbSelectArea("SE1")
SE1->(dbSetOrder(1))

dbSelectArea("SZF")
SZF->(dbSetOrder(2))

If lJob
	LogWrite("Process","File Create","Iniciando gravação dos arquivos")
EndIf

//----------------------------------------------
// Cabeçalho do arquivo principal
//----------------------------------------------
cLinha := "PERFIL;CPF;NOME;PEDIDO_GAR;PEDIDO_SITE;DATA_VAL;DATA_EMISS;TEL_FIXO;CELULAR;EMAIL" + CRLF

//Cria o arquivo principal
nHdl := FCreate(cArquivo)

If nHdl > 0
	FWrite(nHdl, cLinha)
Else
	If lJob
		LogWrite("Process","File Create","Não foi possível criar o arquivo de saída.")
	Else
		Alert("Não foi possível criar o arquivo de saída.")
	EndIf
	
	Return .F.
EndIf

//----------------------------------------------
// Cria o arquivo de Log
//----------------------------------------------
cLinhaLog := "NUM_PEDIDO;OBSERVACAO" + CRLF

nHdlLog := FCreate(cArqLog)

If nHdlLog > 0
	FWrite(nHdlLog, cLinhaLog)
Else
	If lJob
		LogWrite("Process","File Create","Não foi possível criar o arquivo de log. O processamento não será logado.")
	Else
		Alert("Não foi possível criar o arquivo de log. O processamento não será logado.")
	EndIf
EndIf

//----------------------------------------------
// Cria o arquivo de extração full
//----------------------------------------------
cLinOutput := "PERFIL;PEDIDO;EMISSAO_PED;PEDSITE;PEDGAR;DATPED;DATSOL;DATVAL;DATEMIS;PEDGANT;TIPMOV;TIPVOU;NATUREZA;EMIS_PR;EMIS_NCC;VALOR_PR;VALOR_NCC;SALDO_PR;SALDO_NCC;CARTAO;CODAUT;PARCELA;LINHA_DIG;NUMVOU;RECIBO;NF_HRD;NF_SFW;TOTPED;NOTA;STATUS" + CRLF

nHdlOutput := FCreate(cArqFull)

If nHdlOutput > 0
	FWrite(nHdlOutput, cLinOutput)
Else
	If lJob
		LogWrite("Process","File Create","Não foi possível criar o arquivo de extração geral.")
	Else
		If !MsgYesNo("Não foi possível criar o arquivo geral. A extração final não será gerada. Deseja continuar?")
			Return
		EndIf
	EndIf
EndIf

//----------------------------------------------
// Processa os dados retornados da query
//----------------------------------------------
While (cAlias)->(!EoF())
	
	If !lJob
		IncProc()
		ProcessMessage()
	EndIf
	
	cNomCli 	 := ""
	cNumPed 	 := ""
	cPedGar		 := ""
	cPedSite	 := ""
	cEmail		 := ""
	cPerfil 	 := ""
	cDataValida  := ""
	cDataEmissao := ""
	
	//----------------------------------------------
	// Posiciona SZ5 com Pedido GAR
	//----------------------------------------------
	If SZ5->(dbSeek(xFilial("SZ5")+(cAlias)->PEDGAR))
		cCPFTit := SZ5->Z5_CPFT
		
		//----------------------------------------------
		// Caso contenha voucher, ignora o pedido
		//----------------------------------------------
		If !Empty(SZ5->Z5_CODVOU) .And. SZF->(dbSeek(xFilial("SZF") + SZ5->Z5_CODVOU))
		
			cLinhaLog := AllTrim((cAlias)->PEDGAR) + ";" + "Pedido contem Voucher. Pedido Ignorado"
			fWrite(nHdlLog,cLinhaLog)
			 
			cLinOutput := 	AllTrim((cAlias)->PEDIDO) 		+";"+;
							AllTrim((cAlias)->EMISSAO_PED) 	+";"+;
							AllTrim((cAlias)->PEDSITE) 		+";"+;
							AllTrim((cAlias)->PEDGAR)		+";"+;
							AllTrim((cAlias)->DATPED) 		+";"+;
							AllTrim((cAlias)->DATSOL) 		+";"+;
							AllTrim((cAlias)->DATVAL) 		+";"+;
							AllTrim((cAlias)->DATEMIS) 		+";"+;
							AllTrim((cAlias)->PEDGANT) 		+";"+;
							AllTrim((cAlias)->TIPMOV) 		+";"+;
							AllTrim((cAlias)->TIPVOU) 		+";"+;
							AllTrim((cAlias)->NATUREZA) 	+";"+;
							AllTrim((cAlias)->EMIS_PR) 		+";"+;
							AllTrim((cAlias)->EMIS_NCC) 	+";"+;
							AllTrim(Transform((cAlias)->VALOR_PR,"@E 99,999,999.99")) 	+";"+;
							AllTrim(Transform((cAlias)->VALOR_NCC,"@E 99,999,999.99")) 	+";"+;
							AllTrim(Transform((cAlias)->SALDO_PR,"@E 99,999,999.99")) 	+";"+;
							AllTrim(Transform((cAlias)->SALDO_NCC,"@E 99,999,999.99")) 	+";"+;
							AllTrim((cAlias)->CARTAO) 		+";"+;
							AllTrim((cAlias)->CODAUT) 		+";"+;
							AllTrim((cAlias)->PARCELA) 		+";"+;
							AllTrim((cAlias)->LINHA_DIG) 	+";"+;
							AllTrim((cAlias)->NUMVOU) 		+";"+;
							AllTrim((cAlias)->RECIBO) 		+";"+;
							AllTrim((cAlias)->NF_HRD) 		+";"+;
							AllTrim((cAlias)->NF_SFW) 		+";"+;
							AllTrim(Transform((cAlias)->TOTPED,"@E 99,999,999.99")) +";"+;
							AllTrim((cAlias)->NOTA) 		+";"+;
							"X" + CRLF
			
			fWrite(nHdlOutput,cLinOutput)
			 
			(cAlias)->(dbSkip())
			Loop
		EndIf
	EndIf

	//----------------------------------------------//----------------------------------------------
	// Identifica a situação do pedido e carrega a descrição e código de perfil
	//----------------------------------------------//----------------------------------------------
	If !Empty((cAlias)->PEDGAR) .And. !Empty((cAlias)->PEDSITE) .And. Empty((cAlias)->DATEMIS) .And. Empty((cAlias)->DATVAL)
		cPerfil := "1"
		cDescPerfil := "Pedido pago, solicitado, mas não validado e não emitido"
	EndIf
	
	If !Empty((cAlias)->PEDGAR) .And. !Empty((cAlias)->PEDSITE) .And. Empty((cAlias)->DATEMIS) .And. !Empty((cAlias)->DATVAL)
		cPerfil := "2"
		cDescPerfil := "Pedido pago, solicitado, validado, mas não emitido."
	EndIf
	
	If Empty((cAlias)->PEDGAR) .And. !Empty((cAlias)->PEDSITE) .And. Empty((cAlias)->DATEMIS) .And. Empty((cAlias)->DATVAL)
		cPerfil := "3"
		cDescPerfil := "Pedido apenas pago, sem solicitação, sem validação e sem emissão."
	EndIf
	
	//----------------------------------------------
	// Posiciona no Pedido para capturar dados
	//----------------------------------------------
	If SC5->(dbSeek(xFilial("SC5") + (cAlias)->PEDIDO ))
	
		If SA1->(dbSeek(xFilial("SA1") + SC5->C5_CLIENTE + SC5->C5_LOJACLI))
			
			//Recupera CPF	
			If Empty(cCPFTit)
				cCPFTit := SA1->A1_CGC				
			EndIf
			
			//Recupera telefone do cliente
			If Empty(SA1->A1_TEL) .And. !Empty(SA1->A1_FAX)
				cTel := SA1->A1_DDD + SA1->A1_FAX
			ElseIf Empty(cTel) .And. !Empty(SA1->A1_TELEX)
				cTel := SA1->A1_DDD + SA1->A1_TELEX
			Else
				cTel:= SA1->A1_DDD + SA1->A1_TEL
			EndIf
		Else
			cLinhaLog := SC5->C5_NUM + ";" + "O cliente não foi encontrado."
			fWrite(nHdlLog, cLinhaLog)
		EndIf

		//Tratamento para retornar telefone celular
		If !Empty(cTel)
			aRetFone := u_csValidTel(cTel)
			
			If Upper(AllTrim(aRetFone[3])) == "FIXO"
				cTel := AllTrim(aRetFone[1]) + AllTrim(aRetFone[2])
			ElseIf Upper(AllTrim(aRetFone[3])) == "CELULAR"
				cCel := AllTrim(aRetFone[1]) + AllTrim(aRetFone[2])
			EndIf
		Else
			cLinhaLog := SC5->C5_NUM + ";" + "Nao foram encontrados telefones para o cliente do pedido."
			fWrite(nHdlLog, cLinhaLog)
		EndIf
		
		//----------------------------------------------
		// Carga inicial das variáveis
		//----------------------------------------------
		cNomCli 	 := Iif(!Empty(SZ5->Z5_NTITULA),SZ5->Z5_NTITULA,SA1->A1_NOME)
		cNumPed 	 := SC5->C5_NUM
		cPedGar		 := (cAlias)->PEDGAR
		cPedSite	 := (cAlias)->PEDSITE
		cPedOld		 := (cAlias)->PEDGANT
		cEmail		 := SZ5->Z5_EMAIL //SA1->A1_EMAIL
		cDataEmissao := (cAlias)->DATEMIS
		cDataValida	 := (cAlias)->DATVAL
		cDataRevoga	 := (cAlias)->DATREVOGA

		//---------------------------------------------------------------
		// Alimenta linha do arquivo principal de extração
		//---------------------------------------------------------------
		cLinha := cPerfil + ";" + AllTrim(cCPFTit) + ";" + AllTrim(cNomCli) + ";" + AllTrim(cPedGar) + ";" + AllTrim(cPedSite) + ";" +;
		 			AllTrim(DTOC(STOD(cDataValida))) +";" + AllTrim(DTOC(STOD(cDataEmissao))) + ";" + AllTrim(cTel) + ";" + AllTrim(cCel) + ";" + AllTrim(cEmail) + CRLF
		cLinhaLog := AllTrim(cNumPed) + ";" + "Pedido gravado com sucesso"
		
		//---------------------------------------------------------------
		// Grava registro na tabela GTMKT
		//---------------------------------------------------------------		
		cInsert := "INSERT INTO PROTHEUS.GTMKT " //('GT_PERFIL', 'GT_DESPER', 'GT_CPF', 'GT_NOMECLI', 'GT_PEDIDO', 'GT_PEDSITE', 'GT_EXPIRA', 'GT_SOLICITA', 'GT_TEL', 'GT_CEL', 'GT_EMAIL', 'GT_LASTUPD')"
		cInsert += " VALUES ("
		cInsert +=  	"'" + cPerfil + "',"
		cInsert += 		"'" + cDescPerfil + "',"
		cInsert += 		"'" + AllTrim(cNomCli) + "',"
		cInsert += 		Iif(Empty(AllTrim(cPedSite)),"0",AllTrim(cPedSite)) + ","
		cInsert += 		Iif(Empty(AllTrim(cPedGar)),"0",AllTrim(cPedGar)) + ","
		cInsert += 		Iif(Empty(AllTrim(cPedOld)),"0",AllTrim(cPedOld)) + "," 
		cInsert += 		Iif(Empty(AllTrim(cCPFTit)),"0",AllTrim(cCPFTit)) + "," 
		cInsert += 		Iif(Empty(AllTrim(cTel)),"0",StrTran(AllTrim(cTel)," ","")) + ","
		cInsert += 		Iif(Empty(AllTrim(cCel)),"0",StrTran(AllTrim(cCel)," ","")) + ","
		cInsert += 		"'" + AllTrim(cEmail) + "',"
		cInsert += 		Iif(Empty(AllTrim(cDataEmissao)),"null","'"+cDataEmissao+"'") + "," 	
		cInsert += 		Iif(Empty(AllTrim(cDataValida)),"null","'"+cDataValida+"'") + "," 
		cInsert += 		Iif(Empty(AllTrim(cDataRevoga)),"null","'"+cDataRevoga+"'") + ","
		cInsert += 		"'"+DTOS(Date())+"')"
		
		//Executa comando SQL e captura retorno
		nStatus := TcSqlExec(cInsert)
		
		If nStatus < 0
			cLinhaLog := AllTrim(cNumPed) + ";" + "Ocorreu um erro na gravação do banco: " + TcSqlError()
			fWrite(nHdlLog, cLinhaLog)
		EndIf
		
		FWrite(nHdl, cLinha)
	EndIf 

	//---------------------------------------------------------------
	// Alimenta linha do arquivo principal de extração
	//---------------------------------------------------------------	
	cLinOutput := 	cPerfil +";"+;
					AllTrim((cAlias)->PEDIDO) 		+";"+;
					AllTrim((cAlias)->EMISSAO_PED) 	+";"+;
					AllTrim((cAlias)->PEDSITE) 		+";"+;
					AllTrim((cAlias)->PEDGAR)		+";"+;
					AllTrim((cAlias)->DATPED) 		+";"+;
					AllTrim((cAlias)->DATSOL) 		+";"+;
					AllTrim((cAlias)->DATVAL) 		+";"+;
					AllTrim((cAlias)->DATEMIS) 		+";"+;
					AllTrim((cAlias)->PEDGANT) 		+";"+;
					AllTrim((cAlias)->TIPMOV) 		+";"+;
					AllTrim((cAlias)->TIPVOU) 		+";"+;
					AllTrim((cAlias)->NATUREZA) 	+";"+;
					AllTrim((cAlias)->EMIS_PR) 		+";"+;
					AllTrim((cAlias)->EMIS_NCC) 	+";"+;
					AllTrim(Transform((cAlias)->VALOR_PR,"@E 99,999,999.99")) +";"+;
					AllTrim(Transform((cAlias)->VALOR_NCC,"@E 99,999,999.99")) +";"+;
					AllTrim(Transform((cAlias)->SALDO_PR,"@E 99,999,999.99")) +";"+;
					AllTrim(Transform((cAlias)->SALDO_NCC,"@E 99,999,999.99")) +";"+;
					AllTrim((cAlias)->CARTAO) 		+";"+;
					AllTrim((cAlias)->CODAUT) 		+";"+;
					AllTrim((cAlias)->PARCELA) 		+";"+;
					AllTrim((cAlias)->LINHA_DIG) 	+";"+;
					AllTrim((cAlias)->NUMVOU) 		+";"+;
					AllTrim((cAlias)->RECIBO) 		+";"+;
					AllTrim((cAlias)->NF_HRD) 		+";"+;
					AllTrim((cAlias)->NF_SFW) 		+";"+;
					AllTrim(Transform((cAlias)->TOTPED,"@E 99,999,999.99")) +";"+;
					AllTrim((cAlias)->NOTA) 		+";"+;
					"OK" + CRLF
	
	fWrite(nHdlOutput,cLinOutput)
		
	(cAlias)->(dbSkip())
EndDo
	
(cAlias)->(dbCloseArea())
	
FClose(nHdl)
FClose(nHdlLog)
FClose(nHdlOutput)

If lJob
	LogWrite("EndProc","Finish","Processamento encerrado.")
EndIf

//---------------------------------------------------------------
// Copia arquivos para pasta a ser identificada pelo usuário
//---------------------------------------------------------------
If !lJob
	If MsgYesNo("Deseja copiar os arquivos para a máquina local?")
		cDirIn := cGetFile("\", "Diretórios", 1,"X:\" ,.F. , GETF_RETDIRECTORY+GETF_LOCALHARD )
		
		If !CpyS2T(cArquivo,cDirIn)
			Alert("Falha na cópia do arquivo principal.")
		EndIf
		
		If !CpyS2T(cArqLog,cDirIn)
			Alert("Falha na cópia do log.")
		EndIf
		
		If !CpyS2T(cArqFull,cDirIn)
			Alert("Falha na cópia do arquivo completo.")
		EndIf
		
	EndIf	
EndIf
	
Return


User Function CSJOB010(aParam)

Local aRet		:= {}

Private nHdlLog	:= 0
Private lJob	:= .T.

LogInit()

//---------------------------------------------------
// Definição dos Parâmetros esperados pela rotina:
// aParam[1] - Empresa
// aParam[2] - Filial
// aParam[3] - Ano de Processamento
//---------------------------------------------------

If Len(aParam) == 0
	LogWrite("Start Process","Param Check","Não foram fornecidos parâmetros para execução.")
	LogEnd()
	Return .F.
EndIf

If Val(aParam[3]) <= 2017 
 	LogWrite("Start Process","Param Check","O processamento anterior a 2017 não pode ser realizado.")
 	LogEnd()
 	Return .F.
EndIf

If Val(aParam[3]) > Year(Date())
	LogWrite("Start Process","Param Check","Foi definido um ano superior ao ano corrente. A execução será abortada.")
	LogEnd()
	Return .F.
EndIf

If Len(aParam) == 3 .And. (Val(aParam[3]) >= 2018 .And. Val(aParam[3]) <= Year(Date()))
	csPrepAmb()
	CFA900Proc({aParam[3]})
Else
	LogWrite("Start Process","Param Check","Há algum erro nos parâmetros informados. O processo será interrompido.")
	LogEnd()
	Return .F.
EndIf

Return

//-----------------------------------------------------------------------
/*/{Protheus.doc} csPrepAmb()
Funcao para preparar o ambiente

@param	aParam		Parametros empresa e filial

@author	Douglas Parreja
@since	10/07/2015
@version	11.8
/*/
//-----------------------------------------------------------------------
static function csPrepAmb( aParam )
	
	local cEmp		:= ""
	local cFil		:= ""
	Local aTables	:= {'SX5','SX6','SIX','SA1','AC8','SC5','SU5','SZX','SZG','SZF','ZZQ','SZ5'}
	
	//U_AutoMsg( cExec, , "Preparando Ambiente")
	
	cEmp := IIf( aParam == NIL, '01' /*FWGrpCompany() 	'01'*/, aParam[ 1 ] )
	cFil := IIf( aParam == NIL, '02' /*FWCodFil() 		'02'*/, aParam[ 2 ] )
	
	If lJob
		RpcSetType( 3 )
		RpcSetEnv(cEmp, cFil,,, "FAT",, aTables)		
		
		//U_AutoMsg( cExec, , "Ambiente preparado para Empresa: " +cEmp+ " - Filial: " +cFil)
	EndIf
		
return	

/*/{Protheus.doc} LogInit
//TODO Descrição auto-gerada.
@author yuri.volpe
@since 20/02/2019
@version 1.0
@return lLogInit, indica se o log foi criado com sucesso

@type function
/*/
Static Function LogInit()

Local cLogName 	:= "csjob010_"+DToS(Date())+StrTran(Time(),":","")+".log"
Local cFullLog	:= "\integracao_tww\log\" + cLogName

nHdlLog := FCreate(cFullLog)

If nHdlLog == -1
	CONOUT("[ CSJOB010 - Log Creation - " + Dtoc( date() ) + " - " + time() + " ] Log file creation failure.")
Else
	CONOUT("[ CSJOB010 - Log Creation - " + Dtoc( date() ) + " - " + time() + " ] Log file creation successful.")
EndIf

Return nHdlLog > -1

/*/{Protheus.doc} LogWrite
//TODO Descrição auto-gerada.
@author yuri.volpe
@since 20/02/2019
@version 1.0
@return ${return}, ${return_description}
@param cExec, characters, descricao
@param cProcesso, characters, descricao
@param cMessage, characters, descricao
@type function
/*/
Static Function LogWrite(cExec, cProcesso, cMessage )
	
	Default cExec	:= ""		// De qual processo esta sendo executado (nome do Job, Rotina, etc)
	Default cProcesso	:= ""		// A qual processo refere-se (Ex: 1-Transmissao,2-Monitoramento)
	Default cMessage := ""	// Mensagem enviada a ser exibida no Conout
	
	//---------------------------------------------------------------------------------
	// Realizado essa funcao para caso estiver outra userfunction, podera ser chamada 
	// essa funcao somente precisara acrescentar o nProcesso e Descricao.
	//---------------------------------------------------------------------------------
	If LogStatus()
		FWrite(nHdlLog, "[ CSJOB010 - " + Iif(!Empty(cProcesso),cProcesso+" - ","")  + Dtoc( date() ) + " - " + time() + " ] " + Iif(!Empty(cMessage),AllTrim(cMessage),"") + CRLF)
	EndIf
		
	CONOUT( "[ "+ Iif(!Empty(cExec),cExec,"") + " - " + Iif(!Empty(cProcesso),cProcesso+" - ","")  + Dtoc( date() ) + " - " + time() + " ] " + Iif(!Empty(cMessage),AllTrim(cMessage),"") )

Return

/*/{Protheus.doc} LogEnd
//TODO Descrição auto-gerada.
@author yuri.volpe
@since 20/02/2019
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
Static Function LogEnd()

If nHdlLog > -1
	FClose(nHdlLog)
	CONOUT("[ CSJOB010 - Log Closure - " + Dtoc( date() ) + " - " + time() + " ] Log file closed.")
EndIf

Return

/*/{Protheus.doc} LogStatus
//TODO Descrição auto-gerada.
@author yuri.volpe
@since 20/02/2019
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
Static Function LogStatus()
Return (nHdlLog > -1)