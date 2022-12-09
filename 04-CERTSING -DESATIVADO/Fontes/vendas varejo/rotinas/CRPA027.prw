#INCLUDE "Totvs.ch"
#include "fileio.ch"
#INCLUDE "TBICONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCRPA027   บ Autor ณ Renato Ruy	     บ Data ณ  21/05/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Programa para importa็ใo de dados que serใo usado para     บฑฑ
ฑฑบ          ณ calculo do remunera็ใo de parceiros.                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function CRPA027


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

//Local oDlg
//Local nOpc		:= 0								// 1 = Ok, 2 = Cancela
//Local cFileIn	:= Space(256)
//Local cFileOut	:= Space(256)
Local cDirIn	:= Space(256)
//Local aDirIn	:= {}
//Local nI		:= 0
//Local cSaida	:= cFileOut
//Local cAux		:= ""
//Local nHandle	:= -1
//Local lRet		:= .F.

Private nLogProc := 0

logProc(4,"=========================================================================")
logProc(4,"#==============      Rotina para importa็ใo de pedidos.    ==============")
logProc(4,"=========================================================================")

logProc(4,"Carregando ambiente")
RpcClearEnv()
RpcSetType(3)
RpcSetEnv("01","02")
logProc(4,"Ambiente carregado")

//Adiciono a pasta de destino.
cDirIn := "\pedidosfaturados\GAR\Rel_Hist_Carga_ERP_Eventos"+DtoS(dDataBase)+".csv"

logProc(1)

//Chamo a rotina para ler o TXT
If File(cDirIn)
	logProc(4,"Iniciando abertura do arquivo " + cDirIn)
	OkLeTxt(cDirIn)
Else
	logProc(4,"Arquivo nใo encontrado " + cDirIn)
	logProc(2,"Arquivo nใo encontrado: " + cDirIn)
EndIf 

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณ OKLETXT  บ Autor ณ AP6 IDE            บ Data ณ  12/12/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao chamada pelo botao OK na tela inicial de processamenบฑฑ
ฑฑบ          ณ to. Executa a leitura do arquivo texto.                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function OkLeTxt(cDirIn)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Abertura do arquivo texto                                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Private cArqTxt := ""
Private nHdl    := ""

Private cEOL    := "CHR(13)+CHR(10)"
If Empty(cEOL)
	cEOL := CHR(13)+CHR(10)
Else
	cEOL := Trim(cEOL)
	cEOL := &cEOL
Endif

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Inicializa a regua de processamento                                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

cArqTxt := cDirIn
nHdl    := fOpen(cArqTxt,68)

If !File(cArqTxt) .Or. nHdl == -1
	logProc(4,"O Arquivo "+cArqTxt+" nใo pode ser aberto. O processamento nใo serแ executado.")
	logProc(2,"O Arquivo "+cArqTxt+" nใo pode ser aberto. O processamento nใo serแ executado.")
	Return
EndIf

logProc(4,"Iniciando processamento do arquivo.")
logProc(2,"Iniciando processamento do arquivo.")

RunCont()

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณ RUNCONT  บ Autor ณ AP5 IDE            บ Data ณ  12/12/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela PROCESSA.  A funcao PROCESSA  บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function RUNCONT

Local nContador := 0
Local aPedidos  := {}
Local aPedido2 	:= {}
Local nTotRec	:= 0
Local nThread	:= 0
Local nPerCCR 	:= 0
Local cArqLog 	:= "\pedidosfaturados\GAR\log"+DtoS(dDataBase)+".csv"
Local nHdlLog  	:= fCreate(cArqLog)
Local cEOL    	:= "CHR(13)+CHR(10)"
Local cPedido	:= ""
Local cCodRD	:= ""
//Local nTamLin	
Local cLin
//Local cCpo

If Empty(cEOL)
	cEOL := CHR(13)+CHR(10)
Else
	cEOL := Trim(cEOL)
	cEOL := &cEOL
Endif

logProc(4,"Iniciando rotina RUNCONT")

If nHdlLog != -1
	cLin := "Data Importa็ใo;Pedido Gar;Pedido Protheus;Produto Gar;C๓digo Voucher;Tipo Voucher;Log Importa็ใo;Validado;Verificado;Emitido"+cEOL
	logProc(4,"Gravando cabe็alho")
	fWrite(nHdlLog,cLin)
Endif

//ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
//บ Lay-Out do arquivo Texto gerado:                                บ
//ฬออออออออออออออออัออออออออัอออออออออออออออออออออออออออออออออออออออน
//บCampo           ณ Inicio ณ Tamanho                               บ
//วฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถ
//บ ??_FILIAL     ณ 01     ณ 02                                    บ
//ศออออออออออออออออฯออออออออฯอออออออออออออออออออออออออออออออออออออออผ

FT_FUSE(cArqTxt)

nTotRec := FT_FLASTREC()

FT_FGOTOP()

logProc(2,"Iniciando leitura do arquivo")

logProc(4,"Iniciando loop RUNCONT")

While !FT_FEOF()

	logProc(2,"Carregando Threads")
	logProc(4,"Carregando Threads")
	//Faz distribui็ใo e monitora a quantidade de thread em execu็ใo
	nThread := 0
	aUsers 	:= Getuserinfoarray(.F.)
	aEval(aUsers,{|x| IIF( ALLTRIM(UPPER(x[5])) == "U_CRPA027B",nThread++,nil )  })

	//Limita a quantidade de Threads.
	If nThread < 10

		nContador := 0
		aPedidos  := {}

		logProc(4,"Iniciando processamento dos registros")

		//Envio para processamento de 10 em 10 pedidos.
		While !FT_FEOF() .And. nContador < 80
			//Leio a linha e gero array com os dados
			xBuff	:= StrTran(FT_FREADLN(),";","; ")
			aLin 	:= StrTokArr2(xBuff,";",.T.)
			
			If Len(aLin) == 2
				AADD(aLin," ")
			ElseIf Len(aLin) < 3
				FT_FSKIP()
				Loop
			Endif

			//Adiciono o conte๚do em uma variavel para enviar para o array
			cPedido := iif(RTrim(aLin[2])!="RVD",FormatPd(aLin[1]),"")
			/*nPerCCR := iif(Len(aLin)>2,Val(aLin[3]),0)
			cCodRD	:= iif(Len(aLin)>3,aLin[4],"")*/
			nPerCCR := Iif(!Empty(aLin[3]),Val(aLin[3]),0)
			nCodRD	:= Iif(!Empty(aLin[4]),AllTrim(aLin[4]),"")
			
			logProc(2,"Dados carregados: cPedido [" + cPedido + "] nPerCCR [" + cValToChar(nPerCCR) + "] cCodRd [" + AllTrim(cCodRD) + "]" )
			logProc(4,"Dados carregados: cPedido [" + cPedido + "] nPerCCR [" + cValToChar(nPerCCR) + "] cCodRd [" + AllTrim(cCodRD) + "]" )
			//CRP027LOG(cPedido,"Dados carregados: cPedido [" + cPedido + "] nPerCCR [" + cValToChar(nPerCCR) + "] cCodRd [" + AllTrim(cCodRD) + "]",ProcLine())
			
			//Se nใo estiver vazio adiciono no array
			If !Empty(cPedido)
				Aadd(aPedidos,{cPedido,nPerCCR,cCodRD})
				nContador += 1
			EndIf
			
			If AllTrim(aLin[2]) == "RVD"
				//Armazeno no array e processo quando ja tem mais de 100 pedidos armazenados.
				Aadd(aPedido2,{FormatPd(aLin[1]),nPerCCR,cCodRD})
				//TODO RD
			EndIf

			//Pulo para a pr๓xima linha.
			FT_FSKIP()
		EndDo

		//Envio o conte๚do para Thread se o array for maior que um
		If Len(aPedidos) > 0
			logProc(2, "Chamando StartJob para processamento dos pedidos U_CRPA027B")
			logProc(4,"Chamando StartJob para processamento dos pedidos U_CRPA027B")
			StartJob("U_CRPA027B",GetEnvServer(),.F.,'01','02',aPedidos,"1")
			//U_CRPA027B('01','02',aPedidos,"1") //Fazer Debug
			nThread += 1
			aPedidos := {}
		EndIf

		If Len(aPedido2) >= 80
			logProc(2, "Chamando StartJob para processamento dos pedidos U_CRPA027C")
			logProc(4,"Chamando StartJob para processamento dos pedidos U_CRPA027C")
			StartJob("U_CRPA027C",GetEnvServer(),.F.,'01','02',aPedido2)
			//U_CRPA027C('01','02',aPedido2)
			aPedido2 := {}
		EndIf

	EndIf

	//Gerou erro ao fazer varias vezes a consulta da thread - Getuserinfoarray.
	If nThread > 9
		Sleep( 50000 )
		DelClassIntf()
		nThread := 0
	EndIf

Enddo

//Se ainda tem pedido revalidado nao processado, envia para rotina.
If Len(aPedido2) > 0
	logProc(4,"Chamando StartJob para processamento dos pedidos U_CRPA027C fora do loop")
	StartJob("U_CRPA027C",GetEnvServer(),.F.,'01','02',aPedido2)
	//U_CRPA027C('01','02',aPedido2)
	aPedido2 := {}
EndIf

FT_FUSE()

fClose(nHdl)

logProc(4,"Iniciando query para enviar e-mail")
//Verifico tabela do log de importacao
BeginSql Alias "QCRPA027"
	SELECT SUBSTR(ZZ3_DTIMP,7,2)||'/'||SUBSTR(ZZ3_DTIMP,5,2)||'/'||SUBSTR(ZZ3_DTIMP,1,4) ZZ3_DTIMP,
		   ZZ3_PEDGAR,
		   ZZ3_LOG,
		   C5_NUM,
		   Z5_PRODGAR,
		   Z5_CODVOU,
		   ZF_DESTIPO
	FROM %Table:ZZ3% ZZ3
	//GERAR INFORMAวรO DE VOUCHER E PRODUTO.
	LEFT JOIN %Table:SC5% SC5 ON C5_FILIAL = %xFilial:SC5% AND TRIM(C5_CHVBPAG) = TRIM(ZZ3_PEDGAR) AND SC5.D_E_L_E_T_ = ' '
	LEFT JOIN %Table:SZ5% SZ5 ON Z5_FILIAL = %xFilial:SZ5% AND Z5_PEDGAR = ZZ3_PEDGAR AND Z5_PEDGAR > ' ' AND SZ5.D_E_L_E_T_ = ' '
	LEFT JOIN %Table:SZF% SZF ON ZF_FILIAL = %xFilial:SZF% AND ZF_COD = Z5_CODVOU AND ZF_SALDO = 0 AND SZF.D_E_L_E_T_ = ' '
	WHERE
	ZZ3.D_E_L_E_T_ = ' '
	AND ZZ3_FILIAL = %xFilial:ZZ3%
	AND ZZ3_DTIMP = %Exp:DtoS(dDataBase)%
EndSql

DbSelectArea("QCRPA027")
QCRPA027->(DbGoTop())

logProc(2, "Query executada: " + GetLastQuery()[2])
logProc(2, "QCRPA027 EOF? " + cValToChar(QCRPA027->(EOF())))
logProc(4, "Query executada: " + GetLastQuery()[2])
logProc(4, "QCRPA027 EOF? " + cValToChar(QCRPA027->(EOF())))

//Gravo dados no log
While QCRPA027->(!EOF())
	If nHdlLog != -1
		cLin := QCRPA027->ZZ3_DTIMP +";"
		cLin += QCRPA027->ZZ3_PEDGAR+";"
		cLin += QCRPA027->C5_NUM+";"
		cLin += QCRPA027->Z5_PRODGAR+";"
		cLin += QCRPA027->Z5_CODVOU+";"
		cLin += QCRPA027->ZF_DESTIPO+";"
		cLin += QCRPA027->ZZ3_LOG+";"
		cLin += Iif("VALIDACAO" $ QCRPA027->ZZ3_LOG, "X", "")+";"
		cLin += Iif("VERIFICACAO" $ QCRPA027->ZZ3_LOG, "X", "")+";"
		cLin += Iif("EMISSAO" $ QCRPA027->ZZ3_LOG, "X", "")+";"
		cLin += cEOL

		fWrite(nHdlLog,cLin)
		
		logProc(2, cLin)
	Endif
	QCRPA027->(DbSkip())
EndDo

//Fecho arquivo de log
fClose(nHdlLog)

logProc(2, "Abrindo envio de e-mail")
logProc(4,"Abrindo envio de e-mail")

//Mando e-mail de com o log para o usuario
If MandEmail("Arquivo de Log de importa็๕es do dia " + DtoC(dDataBase),;
		   AllTrim(GetMV("MV_XLOGIMP")),;
		   "Log Importa็ใo Gar",;
		   cArqLog,"", "", "")

		   logProc(2, "E-mail enviado com sucesso")
		   logProc(4,"E-mail enviado com sucesso")
Else
	logProc(2, "Houve uma falha no disparo do e-mail")
	logProc(4,"Houve uma falha no disparo do e-mail")
EndIf

logProc(2, "Antiga chamada do CRPA027W foi transportada para Job")
logProc(4,"Antiga chamada do CRPA027W foi transportada para Job")
//Renato Ruy - 25/04/2016
//Processa calculo diario online e atualiza dados para o controle de faixas.
//U_CRPA027W()

logProc(2, "Antiga chamada do CRPA027Y foi transportada para Job")
logProc(4,"Antiga chamada do CRPA027Y foi transportada para Job")
//Renato Ruy - 05/05/2016
//Remove os pedidos de renova็ใo rejeitados e sem voucher.
//U_CRPA027Y()

logProc(4,"Encerrando rotina")
logProc(3)

RpcClearEnv()

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณ CRPA027B บ Autor ณ AP5 IDE            บ Data ณ  12/12/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Faz o processo em Thread.								  บฑฑ
ฑฑบ          ณ 												              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function CRPA027B(cEmpP,cFilP,aPedidos,cForca)

//Local nTamFile
//Local nTamLin
//Local cBuffer
//Local nBtLidos
//Local xBuff
//Local aLin
//Local cTipLin
//Local nValSoft 		:= 0
//Local nValHard 		:= 0
//Local nValTotHW		:= 0
//Local nValTotSW		:= 0
//Local nValTot		:= 0  
//Local cPeriodo      := ""
//Local cTabela		:= ""
//Local cCodCombo		:= ""
Local cCategoSFW	:= ""
Local cCategoHRD	:= ""
//Local lTipVou		:= .T.
Local lImporta		:= .T.
Local lHardFix		:= .F.
//Local cVouAnt		:= ""
//Local cProduto		:= ""
//Local cPosto		:= ""
Local nRecno		:= 0
//Local cPedAnt		:= ""
//Local cCodSoft 		:= ""
//Local cCodHard 		:= ""
//Local lNaoPagou		:= .T.
//Local lPedsite		:= .T.
Local cEOL    		:= "CHR(13)+CHR(10)"
//Local nTamLin
//Local cLin
//Local cCpo
Local cUptSZ5		:= ""
//Local nRecUPDSZ5	:= 0
Local nX
Local cCodRD		:= ""

Default cForca := "1"

If Empty(cEOL)
	cEOL := CHR(13)+CHR(10)
Else
	cEOL := Trim(cEOL)
	cEOL := &cEOL
Endif

//Abre a conexใo com a empresa
RpcSetType(3)
RpcSetEnv(cEmpP,cFilP)


cCategoSFW	:= GetNewPar("MV_GARSFT", "2")
cCategoHRD	:= GetNewPar("MV_GARHRD", "1")
cUptSZ5	:= GetNewPar("MV_XUPDSZ5", "0")

For nX:= 1 to Len(aPedidos)

	ConOut("CRPA027B - Pedido: "+aPedidos[nX,1])
	logProc(4,"CRPA027B - Pedido: "+aPedidos[nX,1])

	lHardFix:= .F.

	If ValType(aPedidos[nX,1]) <> "U"

		// Verifico para se o conte๚do nใo ้ Texto.
		If Val(aPedidos[nX,1]) > 0
			
			//CRP027LOG(aPedidos[nX,1],"Iniciando processamento do pedido",ProcLine())

			//Revisado por David em 03/03/2016
			//Solicitante: Bianca
			//Motivo: DbSeek no SZ5 estava sendo feito com 7 posi็๕es sendo que pedido gar ja esta com 8 posi็๕es
			If cUptSZ5 == "1"
				DbSelectArea("SZ5")
				DbSetOrder(1)

				/*If DbSeek( xFilial("SZ5") + PADR(AllTrim(StrTran(aPedidos[nX,1],"-"," ")),7," ") )
					ConOut("CRPA027B - O Pedido: "+PADR(AllTrim(StrTran(aPedidos[nX,1],"-"," ")),7," ")  + " foi atualizado com 7 posi็๕es (Update SZ5 ativo)")
					CRPA027B(PADR(AllTrim(StrTran(aPedidos[nX,1],"-"," ")),7," "),.F.)
				EndIf*/

				lImporta := !DbSeek( xFilial("SZ5") + PADR(AllTrim(StrTran(aPedidos[nX,1],"-"," ")),10," ") )

				If !lImporta
					logProc(4,"Registro criado em branco na SZ5: " + AllTrim(StrTran(aPedidos[nX,1],"-"," ")))
					//CRP027LOG(aPedidos[Nx,1],"Registro criado em branco na SZ5",ProcLine()) 
					SZ5->(RecLock("SZ5",.F.))
					//Limpeza de dados foi retirada pois caso os dados da mensagem estiverem diferentes do Web Service do Gar
					//pode ter diferen็a entras os sistemas.
					/*
						SZ5->Z5_CODVOU	:= ""
						SZ5->Z5_TIPVOU	:= ""
						SZ5->Z5_PEDGANT	:= ""
						SZ5->Z5_PRODGAR := ""
						SZ5->Z5_PRODUTO := ""
						SZ5->Z5_DESPRO	:= ""
						SZ5->Z5_CNPJ 	:= ""
						SZ5->Z5_CNPJCER	:= ""
						SZ5->Z5_CODPAR	:= ""
						SZ5->Z5_STATUS 	:= ""
						SZ5->Z5_BLQVEN	:= ""
						SZ5->Z5_NOMPAR	:= ""
						SZ5->Z5_DESCAC	:= ""
						SZ5->Z5_DESCARP	:= ""
						SZ5->Z5_CODARP	:= ""
						SZ5->Z5_DESCAR	:= ""
						SZ5->Z5_CODAR	:= ""
						SZ5->Z5_DATPED 	:= StoD("")
						SZ5->Z5_DATVAL	:= StoD("")
						SZ5->Z5_DATVER	:= StoD("")
						SZ5->Z5_DATEMIS	:= StoD("")
						SZ5->Z5_GRUPO	:= ""
						SZ5->Z5_DESGRU	:= ""
						SZ5->Z5_DESPOS	:= ""
						SZ5->Z5_CODPOS	:= ""
						SZ5->Z5_POSVER	:= ""
						SZ5->Z5_REDE	:= ""
						SZ5->Z5_CODVEND	:= ""
						SZ5->Z5_NOMVEND	:= ""
						SZ5->Z5_COMHW 	:= 0
						SZ5->Z5_COMSW 	:= 0
						SZ5->Z5_DESREDE	:= ""
						SZ5->Z5_CPFAGE	:= ""
						SZ5->Z5_CPFT 	:= ""
						SZ5->Z5_EMAIL	:= ""
						SZ5->Z5_NOMAGE	:= ""
						SZ5->Z5_NOAGVER	:= ""
						SZ5->Z5_NTITULA	:= ""
						SZ5->Z5_RSVALID	:= ""
						SZ5->Z5_FLAGA	:= ""
						SZ5->Z5_TIPO	:= ""
						*/
						SZ5->Z5_ROTINA	:= "CRPA027B"
					SZ5->(MsUnLock())
				EndIf

			Else
				DbSelectArea("SZ5")
				DbSetOrder(1)
				lImporta := !DbSeek( xFilial("SZ5") + PADR(AllTrim(StrTran(aPedidos[nX,1],"-"," ")),10," ") )
			Endif

			If Len(aPedidos[Nx]) > 2
				cCodRd := aPedidos[Nx][3]
			EndIf

			If lImporta
				//Caso nใo encontrei, vou gerar o novo registro
				CRPA027B(AllTrim(aPedidos[nX,1]),.T.,aPedidos[nX,2],cCodRD)
				//ConOut("CRPA027B - O Pedido: "+aPedidos[nX,1] + " foi criado novo registro")
				logProc(4,"CRPA027B - O Pedido: "+aPedidos[nX,1] + " foi criado novo registro")
				//CRP027LOG(aPedidos[nX,1],"Criado novo registro",ProcLine())
				//U_VNDA740(aPedidos[nX,1]) //Remo็ใo solicitada na OTRS 2020040110002781 - e-mails remote ID enviados pelo CRPA027 - VNDA740
			Else
				//ConOut("CRPA027B - O Pedido: "+aPedidos[nX,1] + " foi atualizado")
				logProc(4,"CRPA027B - O Pedido: "+aPedidos[nX,1] + " foi atualizado")
				//CRP027LOG(aPedidos[nX,1],"Registro atualizado",ProcLine())
				CRPA027B(AllTrim(aPedidos[nX,1]),.F.,aPedidos[nX,2],cCodRD)
			Endif

			//Renato Ruy - 15/09/16
			//Atualiza valores da SZ5
			//Funcao unificada no AtuValZ5 para unificar manuten็ใo com o GARA130.
			logProc(4,"For็ando atualiza็ใo do valor da SZ5 pela fun็ใo ATUVALZ5 no pedido " + AllTrim(aPedidos[Nx,1]))
			//CRP027LOG(aPedidos[nX,1],"Chamando fun็ใo AtuValZ5",ProcLine())
			U_AtuValZ5(PADR(AllTrim(StrTran(aPedidos[nX,1],"-"," ")),10," "), cForca)

			//Atualiza Pedido anterior para tratar caso de renovacao
			If !Empty(SZ5->Z5_PEDGANT)

				nRecno := SZ5->(Recno())

				DbSelectArea("SZ5")
				DbSetOrder(1)
				If DbSeek(xFilial("SZ5")+SZ5->Z5_PEDGANT)

					//Chamo a fun็ใo para atualizar dados do GAR.
					CRPA027B(SZ5->Z5_PEDGAR,.F.,cCodRD)
					//ConOut("CRPA027B - O Pedido: "+SZ5->Z5_PEDGAR + " foi atualizado")
					logProc(4,"CRPA027B - O Pedido: "+SZ5->Z5_PEDGAR + " foi atualizado")
					SZ5->(DbGoTo(nRecno))
					
				EndIf
			EndIf

		EndIf
	EndIf

Next

RpcClearEnv()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCTSA01   บAutor  ณMicrosiga           บ Data ณ  01/05/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
/*Static Function CRPA027A(aDirIn,cDirIn)
Local cAux := ""

cDirIn := IIF(!Empty(cAux:=(cGetFile("\", "Diret๓rios", 1,"X:\" ,.F. , GETF_RETDIRECTORY+GETF_LOCALHARD ))),cAux,cDirIn)

aDirIn := Directory(cDirIn+"*.TXT")

Return(.T.)
*/

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCRPA027B  บAutor  ณMicrosiga           บ Data ณ  01/05/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo para alimentar dados atrav้s do gar na SZ5.         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
//CRPA027B(AllTrim(aPedidos[nX,1]),.F.,aPedidos[nX,2],aPedidos[nX,3])
Static Function CRPA027B(cCodPed,lNovo,nPerCCR,cCodRD)

Local cLog 		:= ""
//Local nTam 		:= 500
Local lTemCamp	:= " "
Local lRecalc	:= .F.
//Local oObj

Default nPerCCR := 0
Default cCodRD	:= ""

//Renato Ruy - 21/03/17
//Criacao de semaforo para evitar a duplicidade 
sleep(Randomize( 1, 1000 ))

If !LockByName("CRPA027B"+cCodPed)
	//Conout("[CRPA027B] - Pedido: "+ cCodPed +" ja esta em processamento!")
	logProc(4,"[CRPA027B] - Pedido: "+ cCodPed +" ja esta em processamento!")
	//CRP027LOG(cCodPed,"Pedido ja esta em processamento!",ProcLine())
	return
Endif

//Renato Ruy
//07/10/15 - tratamento para geracao de logs.

If ValType(nPerCCR) <> "N"
	nPerCCR := Val(nPerCCR)
EndIf

logProc(4,"Iniciando consulta no GAR pedido " + cCodPed)
//CRP027LOG(cCodPed,"Iniciando consulta no GAR",ProcLine())
Begin Sequence
// Busca os dados do pedido de GAR para atualizar o movimento
oWSObj := WSIntegracaoGARERPImplService():New()
IF oWSObj:findDadosPedido("erp","password123",Val(cCodPed))

	If SZ5->(Reclock("SZ5",lNovo))

		//Se o pedido ้ novo, gravo codigo do pedido gar
		If lNovo
			SZ5->Z5_PEDGAR := cCodPed
			cLog := "| PEDIDO INCLUIDO "
		EndIf
		
		If Empty(SZ5->Z5_ROTINA)
			SZ5->Z5_ROTINA	:= "CRPA027"
		EndIf

		//Pedido GAR Anterior
		SZ5->Z5_PEDGANT	:= Iif(ValType(oWSObj:OWSDADOSPEDIDO:NPEDIDOANTIGO) <> "U",AllTrim(Str(oWSObj:OWSDADOSPEDIDO:NPEDIDOANTIGO)),"")

		//Certificado
		If ValType(oWSObj:OWSDADOSPEDIDO:CPRODUTO) <> "U"
			lRecalc := AllTrim(SZ5->Z5_PRODGAR) <> AllTrim(oWSObj:OWSDADOSPEDIDO:CPRODUTO)
			SZ5->Z5_PRODGAR := AllTrim(oWSObj:OWSDADOSPEDIDO:CPRODUTO)
			SZ5->Z5_PRODUTO := Iif(Empty(SZ5->Z5_PRODUTO),GetAdvFval('PA8','PA8_CODMP8',XFILIAL('PA8')+ALLTRIM(SZ5->Z5_PRODGAR), 1,''), SZ5->Z5_PRODUTO)
		EndIf

		//DECRICAO do Certificado
		If ValType(oWSObj:OWSDADOSPEDIDO:CPRODUTODESC) <> "U"
			SZ5->Z5_DESPRO := AllTrim(oWSObj:OWSDADOSPEDIDO:CPRODUTODESC)
		EndIf

		//CNPJ do Certificado
		If ValType(oWSObj:OWSDADOSPEDIDO:NCNPJCERT) <> "U"
			SZ5->Z5_CNPJ := AllTrim(Str(oWSObj:OWSDADOSPEDIDO:NCNPJCERT))
			SZ5->Z5_CNPJCER := AllTrim(Str(oWSObj:OWSDADOSPEDIDO:NCNPJCERT))
			SZ5->Z5_CNPJV	:= oWSObj:OWSDADOSPEDIDO:NCNPJCERT
		EndIf

		//Codigo do Parceiro
		If ValType(oWSObj:OWSDADOSPEDIDO:NCODIGOPARCEIRO) <> "U"
			lRecalc := SZ5->Z5_CODPAR <> AllTrim(Str(oWSObj:OWSDADOSPEDIDO:NCODIGOPARCEIRO))
			SZ5->Z5_CODPAR := AllTrim(Str(oWSObj:OWSDADOSPEDIDO:NCODIGOPARCEIRO))
		EndIf

		If ValType(oWSObj:OWSDADOSPEDIDO:cStatus) <> "U"
			SZ5->Z5_STATUS := AllTrim(oWSObj:OWSDADOSPEDIDO:cStatus)
		EndIf

		If ValType(oWSObj:OWSDADOSPEDIDO:nstatusRevendedor) <> "U"
			SZ5->Z5_BLQVEN := AllTrim(Str(oWSObj:OWSDADOSPEDIDO:nstatusRevendedor))
		EndIf

		//Codigo do Parceiro
		If ValType(oWSObj:OWSDADOSPEDIDO:CDESCRICAOPARCEIRO) <> "U"
			lRecalc := AllTrim(SZ5->Z5_NOMPAR) <> AllTrim(oWSObj:OWSDADOSPEDIDO:CDESCRICAOPARCEIRO)
			SZ5->Z5_NOMPAR := AllTrim(oWSObj:OWSDADOSPEDIDO:CDESCRICAOPARCEIRO)
		EndIf

		//Descricao AC do Pedido
		If ValType(oWSObj:OWSDADOSPEDIDO:CACDESC) <> "U"
			SZ5->Z5_DESCAC	:= AllTrim(oWSObj:OWSDADOSPEDIDO:CACDESC)
		EndIf

		//Descricao AR de Pedido
		If ValType(oWSObj:OWSDADOSPEDIDO:CARDESC) <> "U"
			SZ5->Z5_DESCARP	:= AllTrim(oWSObj:OWSDADOSPEDIDO:CARDESC)
		EndIf

		//Codigo AR de Pedido
		If ValType(oWSObj:OWSDADOSPEDIDO:CARID) <> "U"
			SZ5->Z5_CODARP := AllTrim(oWSObj:OWSDADOSPEDIDO:CARID)
		EndIf

		//Deve ser a AR de VERIFICACAO
		//Descricao AR de Validacao
		If ValType(oWSObj:OWSDADOSPEDIDO:CARVALIDACAODESC) <> "U"
			SZ5->Z5_DESCAR	:= AllTrim(oWSObj:OWSDADOSPEDIDO:CARVALIDACAODESC)
		EndIf

		//Deve ser a AR de VERIFICACAO
		//Codigo AR de Validacao
		If ValType(oWSObj:OWSDADOSPEDIDO:CARVALIDACAO) <> "U"
			SZ5->Z5_CODAR := AllTrim(oWSObj:OWSDADOSPEDIDO:CARVALIDACAO)
		EndIf

		//Data de Emissao do Pedido GAR
		If ValType(oWSObj:OWSDADOSPEDIDO:CDATAPEDIDO) <> "U"
			lRecalc  := Empty(SZ5->Z5_DATPED)
			//SZ5->Z5_DATPED := CtoD(SubStr(AllTrim(oWSObj:OWSDADOSPEDIDO:CDATAPEDIDO),1,10))
			SZ5->Z5_DATPED := Iif(Empty(SZ5->Z5_DATPED),CtoD(SubStr(AllTrim(oWSObj:OWSDADOSPEDIDO:CDATAPEDIDO),1,10)),SZ5->Z5_DATPED)
		Else
			If ZZ3->(Reclock("ZZ3",.T.))
				ZZ3->ZZ3_FILIAL 	:= xFilial("ZZ3")
				ZZ3->ZZ3_DTIMP 		:= dDataBase
				ZZ3->ZZ3_PEDGAR 	:= cCodPed
				ZZ3->ZZ3_LOG    	:= "CRPA027 - Pedido sem Data no WebService."
				ZZ3->(MsUnlock())
				//CRP027LOG(cCodPed,"Pedido sem data no WebService",ProcLine())
			EndIf
		EndIf

		//Grupo
		If ValType(oWSObj:OWSDADOSPEDIDO:CGRUPO) <> "U"
			SZ5->Z5_GRUPO := AllTrim(oWSObj:OWSDADOSPEDIDO:CGRUPO)
		EndIf

		//Descricao do Grupo
		If ValType(oWSObj:OWSDADOSPEDIDO:CGRUPODESCRICAO) <> "U"
			SZ5->Z5_DESGRU := AllTrim(oWSObj:OWSDADOSPEDIDO:CGRUPODESCRICAO)
		EndIf

		//Deve ser o Posto de VERIFICACAO
		//Descricao do Posto de Valida๏ฟฝ๏ฟฝo
		If ValType(oWSObj:OWSDADOSPEDIDO:CPOSTOVALIDACAODESC) <> "U"
			SZ5->Z5_DESPOS	:= Iif(Empty(SZ5->Z5_DESPOS),AllTrim(oWSObj:OWSDADOSPEDIDO:CPOSTOVALIDACAODESC),SZ5->Z5_DESPOS)
		EndIf

		//If ValType(oWSObj:OWSDADOSPEDIDO:CPOSTOVERIFICACAODESC) <> "U"
		//	SZ5->Z5_DESPOS	:= Iif(Empty(SZ5->Z5_DESPOS),AllTrim(oWSObj:OWSDADOSPEDIDO:CPOSTOVERIFICACAODESC),SZ5->Z5_DESPOS)
		//EndIf

		//Deve ser o Posto de VERIFICACAO
		//Codigo do posto de validacao
		If ValType(oWSObj:OWSDADOSPEDIDO:NPOSTOVALIDACAOID) <> "U"
			//SZ5->Z5_CODPOS	:= AllTrim(Str(oWSObj:OWSDADOSPEDIDO:NPOSTOVALIDACAOID))
			SZ5->Z5_CODPOS	:= Iif(Empty(SZ5->Z5_CODPOS) .Or. Empty(SZ5->Z5_DATVER),AllTrim(Str(oWSObj:OWSDADOSPEDIDO:NPOSTOVALIDACAOID)),SZ5->Z5_CODPOS)
		EndIf

		If ValType(oWSObj:OWSDADOSPEDIDO:NPOSTOVERIFICACAOID) <> "U"
			SZ5->Z5_POSVER	:= Iif(Empty(SZ5->Z5_DATVER),AllTrim(Str(oWSObj:OWSDADOSPEDIDO:NPOSTOVERIFICACAOID)),SZ5->Z5_POSVER)
		EndIf
		
		//Data de Emissao do Pedido GAR
		If ValType(oWSObj:OWSDADOSPEDIDO:CDATAEMISSAO) <> "U"
			cLog += Iif(empty(SZ5->Z5_DATEMIS),"| EMISSAO ","")
			SZ5->Z5_DATEMIS := CtoD(SubStr(AllTrim(oWSObj:OWSDADOSPEDIDO:CDATAEMISSAO),1,10))
		EndIf

		//Data de Expira็ใo do Pedido GAR
		If ValType(oWSObj:OWSDADOSPEDIDO:CDATAEXPIRACAO) <> "U"
			SZ5->Z5_VLDCERT := CtoD(SubStr(AllTrim(oWSObj:OWSDADOSPEDIDO:CDATAEXPIRACAO),1,10))
		EndIf
				
		//Data da Validacao
		If ValType(oWSObj:OWSDADOSPEDIDO:CDATAVALIDACAO) <> "U" .And. (Empty(SZ5->Z5_PEDGANT) .OR. !Empty(SZ5->Z5_DATEMIS))
			If !Empty(SZ5->Z5_DATEMIS) .OR. EMPTY(SZ5->Z5_PEDGANT)
				cLog += Iif(empty(SZ5->Z5_DATVAL),"| VALIDACAO ","")
				SZ5->Z5_DATVAL := Iif(Empty(SZ5->Z5_DATVAL),CtoD(SubStr(AllTrim(oWSObj:OWSDADOSPEDIDO:CDATAVALIDACAO),1,10)),SZ5->Z5_DATVAL)
			Endif
		EndIf

		//
		If ValType(oWSObj:OWSDADOSPEDIDO:CDATAVERIFICACAO) <> "U" .And. (Empty(SZ5->Z5_PEDGANT) .OR. !Empty(SZ5->Z5_DATEMIS))
			If !Empty(SZ5->Z5_DATEMIS) .OR. EMPTY(SZ5->Z5_PEDGANT)
				cLog += Iif(empty(SZ5->Z5_DATVER),"| VERIFICACAO ","")
				SZ5->Z5_DATVER := Iif(Empty(SZ5->Z5_DATVER),CtoD(SubStr(AllTrim(oWSObj:OWSDADOSPEDIDO:CDATAVERIFICACAO),1,10)),SZ5->Z5_DATVER)
			Endif
		EndIf

		//Rede
		If ValType(oWSObj:OWSDADOSPEDIDO:CREDE) <> "U"
			SZ5->Z5_REDE	:= Iif(Empty(SZ5->Z5_REDE),AllTrim(oWSObj:OWSDADOSPEDIDO:CREDE),SZ5->Z5_REDE)
		EndIf

		//Codigo do Revendedor
		If ValType(oWSObj:OWSDADOSPEDIDO:NCODIGOREVENDEDOR) <> "U"
			lRecalc := AllTrim(SZ5->Z5_CODVEND) <> AllTrim(Str(oWSObj:OWSDADOSPEDIDO:NCODIGOREVENDEDOR))
			SZ5->Z5_CODVEND := AllTrim(Str(oWSObj:OWSDADOSPEDIDO:NCODIGOREVENDEDOR))
		EndIf

		//Nome do revendedor
		If ValType(oWSObj:OWSDADOSPEDIDO:CDESCRICAOREVENDEDOR) <> "U" 
			lRecalc := AllTrim(SZ5->Z5_NOMVEND) <> AllTrim(oWSObj:OWSDADOSPEDIDO:CDESCRICAOREVENDEDOR)
			SZ5->Z5_NOMVEND := AllTrim(oWSObj:OWSDADOSPEDIDO:CDESCRICAOREVENDEDOR)
		EndIf

		//Comissใo hardware do parceiro
		If ValType(oWSObj:OWSDADOSPEDIDO:NCOMISSAOPARCEIROHW) <> "U"
			SZ5->Z5_COMHW := oWSObj:OWSDADOSPEDIDO:NCOMISSAOPARCEIROHW
		EndIf

		//Comissใo software do parceiro
		If ValType(oWSObj:OWSDADOSPEDIDO:NCOMISSAOPARCEIROSW) <> "U"
			If ValType(oWSObj:OWSDADOSPEDIDO:NCOMISSAOPARCEIROSW) <> "N"
				lRecalc := Val(oWSObj:OWSDADOSPEDIDO:NCOMISSAOPARCEIROSW) <> SZ5->Z5_COMSW .And. SZ5->Z5_PROCRET != "M"
			Else
				lRecalc := oWSObj:OWSDADOSPEDIDO:NCOMISSAOPARCEIROSW <> SZ5->Z5_COMSW .And. SZ5->Z5_PROCRET != "M"
			EndIf
			SZ5->Z5_COMSW := Iif(SZ5->Z5_PROCRET != "M",oWSObj:OWSDADOSPEDIDO:NCOMISSAOPARCEIROSW, SZ5->Z5_COMSW)
			SZ5->Z5_COMSW := Iif(SZ5->Z5_COMSW==0 .And. nPerCCR > 0,nPerCCR,SZ5->Z5_COMSW)
		EndIf

		//Descri็ใo da Rede do Parceiro e se faz parte de campanha.
		If ValType(oWSObj:OWSDADOSPEDIDO:cdescricaoRedeParceiro) <> "U"
			lRecalc := AllTrim(oWSObj:OWSDADOSPEDIDO:cdescricaoRedeParceiro) <> AllTrim(SZ5->Z5_DESREDE)
			SZ5->Z5_DESREDE := AllTrim(oWSObj:OWSDADOSPEDIDO:cdescricaoRedeParceiro)
		Else
			If ZZ3->(Reclock("ZZ3",.T.))
				ZZ3->ZZ3_FILIAL 	:= xFilial("ZZ3")
				ZZ3->ZZ3_DTIMP 		:= dDataBase
				ZZ3->ZZ3_PEDGAR 	:= cCodPed
				ZZ3->ZZ3_LOG    	:= "CRPA027 - Pedido sem Campanha no WebService."
				ZZ3->(MsUnlock())
				//CRP027LOG(cCodPed,"Pedido sem campanha no WebService",ProcLine())
			EndIf
		EndIf

		//Definicao do tipo de movimento de remuneracao de parceiros

		//Mudara para agende de verifica็ใo
		//CPF do Agente de Validacao
		If ValType(oWSObj:OWSDADOSPEDIDO:NCPFAGENTEVALIDACAO) <> "U"
			SZ5->Z5_CPFAGE	:= AllTrim(Str(oWSObj:OWSDADOSPEDIDO:NCPFAGENTEVALIDACAO))
		EndIf

		If ValType(oWSObj:OWSDADOSPEDIDO:NCPFAGENTEVERIFICACAO) <> "U"
			SZ5->Z5_AGVER	:= AllTrim(Str(oWSObj:OWSDADOSPEDIDO:NCPFAGENTEVERIFICACAO))
		EndIf

		//CPF do Titular do Certificado
		If ValType(oWSObj:OWSDADOSPEDIDO:NCPFTITULAR) <> "U"
			SZ5->Z5_CPFT := AllTrim(Str(oWSObj:OWSDADOSPEDIDO:NCPFTITULAR))
		EndIf

		//Email do titular
		If ValType(oWSObj:OWSDADOSPEDIDO:CEMAILTITULAR) <> "U"
			SZ5->Z5_EMAIL := AllTrim(oWSObj:OWSDADOSPEDIDO:CEMAILTITULAR)
		EndIf

		//Nome do Agente de Valida๏ฟฝ๏ฟฝo
		If ValType(oWSObj:OWSDADOSPEDIDO:CNOMEAGENTEVALIDACAO) <> "U"
			SZ5->Z5_NOMAGE	:= AllTrim(oWSObj:OWSDADOSPEDIDO:CNOMEAGENTEVALIDACAO)
		EndIf

		If ValType(oWSObj:OWSDADOSPEDIDO:CNOMEAGENTEVERIFICACAO) <> "U"
			SZ5->Z5_NOAGVER	:= AllTrim(oWSObj:OWSDADOSPEDIDO:CNOMEAGENTEVERIFICACAO)
		EndIf

		//Nome do Titular do Certificado
		If ValType(oWSObj:OWSDADOSPEDIDO:CNOMETITULAR) <> "U"
			SZ5->Z5_NTITULA	:= AllTrim(oWSObj:OWSDADOSPEDIDO:CNOMETITULAR)
		EndIf

		If ValType(oWSObj:OWSDADOSPEDIDO:CRAZAOSOCIALCERT) <> "U"
			SZ5->Z5_RSVALID	:= AllTrim(oWSObj:OWSDADOSPEDIDO:CRAZAOSOCIALCERT)
		EndIf

		If !EMPTY(SZ5->Z5_DATEMIS)
			SZ5->Z5_FLAGA := "E"
		ElseIf !EMPTY(SZ5->Z5_DATVER)
			SZ5->Z5_FLAGA := "A"
		EndIf
		
		SZ5->Z5_COMISS := Iif(lRecalc, " ", SZ5->Z5_COMISS)

		If !EMPTY(SZ5->Z5_DATEMIS) .And. !Empty(SZ5->Z5_PEDGANT)
			SZ5->Z5_TIPO = "EMISSA"
		ElseIf !EMPTY(SZ5->Z5_DATVER) .And. Empty(SZ5->Z5_PEDGANT)
			SZ5->Z5_TIPO = "VERIFI"
		ElseIf EMPTY(SZ5->Z5_PEDGAR)
			SZ5->Z5_TIPO = "ENTHAR"
		Else
			SZ5->Z5_TIPO = "VALIDA"
		EndIf
		
		//Renato Ruy - 19/08/16
		//Cria regra para zerar o controle de faixas
		If SZ5->Z5_BLQVEN = '1' .And. SZ5->Z5_COMSW > 0 .And. !Empty(SZ5->Z5_DESCST) .And. ("CAMPANHA" $ Upper(SZ5->Z5_DESREDE) .Or. "CLUBE" $ Upper(SZ5->Z5_DESREDE))
			
			lTemCamp := CRPA027F()
			ConOut("== Apaga controle de faixas -- > " + SZ5->Z5_PEDGAR + " ==")
			//CRP027LOG(cCodPed,"Apaga controle de faixas",ProcLine())
			
			//Zera para nใo contar e solicita uma nova contagem.
			SZ5->Z5_DESCST := If (lTemCamp, " ", SZ5->Z5_DESCST)
			SZ5->Z5_COMISS := If (lTemCamp, " ", SZ5->Z5_DESCST)
		Endif
		
		//Yuri Volpe - 07/01/2019
		//OTRS 2018050410002001 - Inclusใo campo RD na Campanha do Contador
		If FieldPos("Z5_CODRD") > 0
			If !Empty(cCodRD)
				If SZ5->(FieldPos("Z5_CODRD")) > 0
					SZ5->Z5_CODRD := AllTrim(cCodRD)
				EndIf
			EndIf
		EndIf
		
		SZ5->(MsUnlock())

		//Gravo Log
		//Parametros MSMM
		// 1 = Grava
		// 2 = Exclui
		// 3 = Faz leitura

		If !Empty(cLog)
			ZZ3->(DbSetOrder(1))
			If !ZZ3->(DbSeek(xFilial("ZZ3")+DtoC(dDataBase)+cCodPed))
				If ZZ3->(Reclock("ZZ3",.T.))
					ZZ3->ZZ3_FILIAL 	:= xFilial("ZZ3")
					ZZ3->ZZ3_DTIMP 	:= dDataBase
					ZZ3->ZZ3_PEDGAR 	:= cCodPed
					ZZ3->ZZ3_LOG    	:= SubStr(cLog,1,80)
					ZZ3->(MsUnlock())
				EndIf
			Else
				If ZZ3->(Reclock("ZZ3",.F.))
					ZZ3->ZZ3_LOG    	:= SubStr(AllTrim(ZZ3->ZZ3_LOG)+cLog,1,80)
					ZZ3->(MsUnlock())
				EndIf
			EndIf
			//CRP027LOG(cCodPed,cLog,ProcLine())
		EndIf

	EndIf

	//conout("Pedido GAR "+Alltrim(SZ5->Z5_PEDGAR)+" atualizado com sucesso")

Else
	Conout("CRPA027B - Erro ao conectar com WS IntegracaoERP. Pedido GAR " + Alltrim(SZ5->Z5_PEDGAR) + " nใo atualizado")
	If ZZ3->(Reclock("ZZ3",.T.))
		ZZ3->ZZ3_FILIAL 	:= xFilial("ZZ3")
		ZZ3->ZZ3_DTIMP 		:= dDataBase
		ZZ3->ZZ3_PEDGAR 	:= SZ5->Z5_PEDGAR
		ZZ3->ZZ3_LOG    	:= "CRPA027 - Erro ao conectar com WS IntegracaoERP."
		ZZ3->(MsUnlock())
	EndIf
	//CRP027LOG(SZ5->Z5_PEDGAR,"Erro ao conectar com WS IntegracaoERP",ProcLine())
Endif

DelClassIntF()
End Sequence

logProc(4,"Encerramento da rotina CRPA027B - UnlockByName")
UnLockByName("CRPA027B"+cCodPed)

Return

/*
Rotina para envio de email de notifica็ใo de status da libera็ใo do pedido de compras
*/
Static Function MandEmail(xCorpo, xDest, xAssunto, xAnexo, xCC, xBCC, xAcc)

Local   cAccount  := AllTrim(GetNewPar("MV_RELACNT"," "))
Local   cPassword := AllTrim(GetNewPar("MV_RELPSW" ," "))
Local   cServer   := AllTrim(GetNewPar("MV_RELSERV"," "))
Local   cUserAut  := Alltrim(GetMv("MV_RELAUSR",,"")) //Usuแrio para Autentica็ใo no Servidor de Email
Local   cPassAut  := Alltrim(GetMv("MV_RELAPSW",,""))//Senha para Autentica็ใo no Servidor de Email
Local   nTimeOut    := GetMv("MV_RELTIME",,120) //Tempo de Espera antes de abortar a Conexใo
Local   lAutentica  := GetMv("MV_RELAUTH",,.F.) //Determina se o Servidor de Email necessita de Autentica็ใo
Local   lRet      := .T.

Default xDest     := ""
Default xCC		  := ""
Default xBCC      := ""
Default xCorpo	  := ""
Default xAnexo    := ""
Default xAssunto  := xAssunto

If Empty(xDest+xCC+xBCC)
	Return(lRet)
EndIf

_cMsg := "Conectando a " + cServer + CRLF +;
"Conta: " + cAccount + CRLF +;
"Senha: " + cPassword

CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword TIMEOUT nTimeOut Result lOk

If ( lOk )

    // Realiza autenticacao caso o servidor seja autenticado.
	If lAutentica
		If !MailAuth(cUserAut,cPassAut)
			DISCONNECT SMTP SERVER RESULT lOk
			IF !lOk
				GET MAIL ERROR cErrorMsg
			ENDIF
			Return .F.
		EndIf
	EndIf

	SEND MAIL FROM cAccount TO xDest CC xCC BCC xBCC SUBJECT xAssunto BODY xCorpo ATTACHMENT xAnexo RESULT lOk

	If !lOk
		GET MAIL ERROR cErro
		cErro := "Erro durante o envio - destinatแrio: " + xDest + CRLF + CRLF + cErro
		lRet:= .F.
	Endif

	DISCONNECT SMTP SERVER RESULT lOk
	If !lOk
		GET MAIL ERROR cErro
	Endif
Else
	GET MAIL ERROR cErro
	lRet:= .F.
EndIf

If !lRet
	logProc(4,"Falha no envio de e-mail:" + cErro)
EndIf

Return(lRet)

//Renato Ruy - 17/12/2015
//Programa para tratamento da trilha de auditoria.

User Function CRPA027C(cEmpP,cFilP,aPedido2)

Local dDatVal := CtoD("  /  /  ")
Local dDatVer := CtoD("  /  /  ")
Local dDatEmi := CtoD("  /  /  ")
Local nX 	  := 0
Local nZ 	  := 0
Local nCont	  := 0
Local oObj

Default cEmpP := "01"
Default cFilP := "02"

//Abre a conexใo com a empresa
RpcSetType(3)
RpcSetEnv(cEmpP,cFilP)

For nZ := 1 to Len(aPedido2)

	dDatVer := CtoD("  /  /  ")
	dDatEmi := CtoD("  /  /  ")
	nCont	:= 0

	oWSObj := WSIntegracaoGARERPImplService():New()
	IF oWSObj:listarTrilhasDeAuditoriaParaIdPedido( eVal({|| oObj:=loginUserPassword():get('USERERPGAR'), oObj:cReturn }),;
													eVal({|| oObj:=loginUserPassword():get('PASSERPGAR'), oObj:cReturn }),;
													Val( aPedido2[nZ,1] ) )

		//A็ใo
		//RRG - VALIDAR
		//REM - VERIFICAR
		//EMI - EMISSAO
		//RVD - REVALIDAR

	    //Analiso todas as linhas da trilha e gravo.
		For nX := 1 to Len(oWSObj:oWSauditoriaInfo)


			If ValType(oWSObj:oWSauditoriaInfo[nX]:cacao) <> "U"

				//Armazeno somente a primeira data, para nao gerar remunera็ใo duplicada.
				If AllTrim(oWSObj:oWSauditoriaInfo[nX]:cacao) == "RRG" .And. Empty(dDatVal)
					dDatVal := CtoD(SubStr(AllTrim(oWSObj:OWSAUDITORIAINFO[nX]:CDATA),4,3)+SubStr(AllTrim(oWSObj:OWSAUDITORIAINFO[nX]:CDATA),1,3)+SubStr(AllTrim(oWSObj:OWSAUDITORIAINFO[nX]:CDATA),7,4))
					nCont += 1
				ElseIf AllTrim(oWSObj:oWSauditoriaInfo[nX]:cacao) == "REM" .And. Empty(dDatVer)
					dDatVer := CtoD(SubStr(AllTrim(oWSObj:OWSAUDITORIAINFO[nX]:CDATA),4,3)+SubStr(AllTrim(oWSObj:OWSAUDITORIAINFO[nX]:CDATA),1,3)+SubStr(AllTrim(oWSObj:OWSAUDITORIAINFO[nX]:CDATA),7,4))
					nCont += 1
				EndIf

				//Se eu ja tenho a informacao necessaria, finalizo loop.
				If nCont >= 2
					nX := Len(oWSObj:oWSauditoriaInfo)
				EndIf
			EndIf

		Next

	    //Se o sistema encontrou valores, tenta gravar a data antiga do pedido.
		If nCont >= 1
			SZ5->(DbSetOrder(1))
			If SZ5->(DbSeek(xFilial("SZ5")+SubStr(AllTrim(aPedido2[nZ,1]),1,10)))

				If !Empty(dDatVal)
					If SZ5->(RecLock("SZ5",.F.))
						SZ5->Z5_DATVAL := dDatVal
						SZ5->(MsUnlock())
					EndIf
				EndIf

				If !Empty(dDatVer)
					If SZ5->(RecLock("SZ5",.F.))
						SZ5->Z5_DATVER := dDatVer
						SZ5->(MsUnlock())
					EndIf
				EndIf

			EndIf
		EndIf

	Else
		ConOut("Nใo foi possํvel encontrar a trilha ou problema de conexใo!")
	Endif

Next

RpcClearEnv()

Return

//Fun็ใo para retirar caracteres especiais dos pedidos gerados no txt.
Static Function FormatPd(cPedido)

Local cRet	:=	""
Local nI	:=	1

For nI:=1 To Len(cPedido)
	If Isdigit(Subs(cPedido,nI,1)) .Or. IsAlpha(Subs(cPedido,nI,1))
		cRet+=Substr(cPedido,nI,1)
	Endif
Next

cRet := AllTrim(cRet)

Return(cRet)

User Function CRPA027x()

Local aRet 		:= {}
Private aPergs 	:= {}

aAdd( aPergs ,{1,"Pedido Site: ",Space(10),"@!",'.T.',"",'.T.',40,.T.})

If !ParamBox(aPergs ,"Gera Lan็amento Pedido Site",aRet)
	Alert("A geracao do pedido foi cancelada!")
	Return
Elseif Empty(aRet[1])
	Alert("O pedido nใo foi preenchido e a rotina foi cancelada!")
	Return
EndIf

BeginSql Alias "QCRPA027D"

	SELECT
	  SC5.R_E_C_N_O_ RECC5,
	  SC6.R_E_C_N_O_ RECC6,
	  SC6.C6_DATFAT,
	  SC5.C5_EMISSAO,
	  SC5.C5_XNPSITE
	FROM
	  	%Table:SC5% SC5 
    	INNER JOIN %Table:SC6% SC6 ON
          C6_FILIAL = C5_FILIAL AND
          C6_NUM = C5_NUM AND
          C6_XOPER IN ('53','62') AND
          C6_SERIE > ' ' AND
          C6_NOTA > ' ' AND
          SC6.%NotDel%
	    LEFT JOIN %Table:SZ5% SZ5 
	    ON  Z5_FILIAL = %xFilial:SZ5%
		    AND SZ5.Z5_PEDIDO = SC5.C5_NUM
	      	AND SZ5.%NotDel%
	WHERE
	    C5_FILIAL = %xFilial:SC5% AND
	    C5_XNPSITE = %Exp:aRet[1]% AND
	    C5_XORIGPV = '3' AND
		Z5_EMISSAO IS NULL AND
	    SC5.%NotDel%
	  
EndSql

While !QCRPA027D->(EoF())
	SC5->(DbGoTo(QCRPA027D->RECC5))
	SC6->(DbGoTo(QCRPA027D->RECC6))
	
	If (SC6->C6_XOPER == "53" .OR. SC6->C6_XOPER == "62") .AND. !Empty(SC5->C5_XPOSTO) .AND. Empty(SC6->C6_PEDGAR) .AND. !Empty(SC5->C5_XNPSITE)//Venda Avulsa
	
		//Campos adicionados para a grava็ใo de informa็๕es perinentes a midia avulsa
					SZ5->(DbselectArea("SZ5"))

					Reclock('SZ5',.T.)
					SZ5->Z5_EMISSAO := SC6->C6_DATFAT
					SZ5->Z5_VALOR := SC6->C6_VALOR
					SZ5->Z5_PRODUTO := SC6->C6_PRODUTO
					SZ5->Z5_DESPRO  := SC6->C6_DESCRI
					SZ5->Z5_CODVOU  := SC6->C6_XNUMVOU
					SZ5->Z5_PRODGAR := SC6->C6_PROGAR
					SZ5->Z5_TIPO    := "ENTHAR"                           //REMUNERA O POSTO/AR PELA ENTREGA DA MอDIA
					SZ5->Z5_TIPODES := "ENTREGA HARDWARE AVULSO"
					SZ5->Z5_VALORHW := SC6->C6_VALOR
					SZ5->Z5_PEDIDO  := SC6->C6_NUM
					SZ5->Z5_ITEMPV  := SC6->C6_ITEM
					SZ5->Z5_ROTINA  := "M460FIM"
			    	SZ5->Z5_CODPOS 	:= SC5->C5_XPOSTO
			    	SZ5->Z5_TIPMOV	:= SC5->C5_TIPMOV
		    		SZ5->Z5_TABELA	:= SC5->C5_TABELA
			    	SZ5->Z5_PEDSITE	:= SC5->C5_XNPSITE

				    SZ3->(DbSetOrder(6))
				    If SZ3->(DbSeek(xFilial("SZ3") + "4" + SZ5->Z5_CODPOS))
				    	SZ5->Z5_DESPOS	:= SZ3->Z3_DESENT
				    	SZ5->Z5_REDE    := SZ3->Z3_REDE
				    	SZ5->Z5_DESCAR	:= SZ3->Z3_DESAR
				    EndIf

				SZ5->(MsUnlock())
	
	
	
	
	EndIF
		
	
	QCRPA027D->(DbSkip())
EndDo

QCRPA027D->(DbCloseArea())

Return

//Renato Ruy - 25/04/2016
//Executa calculo online.
User Function CRPA027W()

Local dDataIni := CtoD("  /  /  ")
Local dDataFim := CtoD("  /  /  ")
Local cFaixa   := ""
Local nThread  := 0
Local aUsers   := {}
Local cErrorMsg:= {}
Local cMensagem:= ""
Local cPeriodo := ""
Local nContador:= 0
Local aPedidos := {}
Local bOldBlock:= nil
Local nTotThread:= 0

//Abre a conexใo com a empresa
//If !IsInCallStack("U_CRPA027")
	RpcSetType(3)
	RpcSetEnv("01","02")
//EndIf

bOldBlock := ErrorBlock({|e| U_ProcError(e) })

//Parametro da quantidade de dias para calculo de remunera็ใo online.
dDataIni := dDataBase-Getmv("MV_XREMON")
dDataFim := dDataBase

//Renato Ruy - 22/08/2016
//Desmarca pedidos para serem recalculados
//Problema em casos de reembolso de Pedido e controle de faixa.
If Select("TMPREC") > 0
	DbSelectArea("TMPREC")
	TMPREC->(DbCloseArea())
EndIf

//Seta periodo em que serao gerado o desconto do reembolso.
cPeriodo := Iif(SubStr(getmv("MV_REMMES"),5,2)=="12",Soma1(SubStr(getmv("MV_REMMES"),1,4))+"01",Soma1(getmv("MV_REMMES")))

BeginSql Alias "TMPREC"
    //Para reembolso, considera mes anterior.
    %NOPARSER%
    
	SELECT ADE_PEDGAR PEDGAR, 'REEMBOLSO' TIPO FROM %Table:SE2% SE2
	JOIN PROTHEUS.ADE010 ADE ON ADE_FILIAL = %xFilial:ADE% AND ADE_PEDGAR = SUBSTR(E2_HIST,16,10) AND ADE.%NotDel%
	LEFT JOIN %Table:SUK% SUK ON UK_FILIAL = %xFilial:SUK% AND UK_CODATEN = ADE_CODIGO AND SUK.%NotDel%
	LEFT JOIN %Table:ACI% ACI ON ACI_FILIAL = %xFilial:ACI% AND ACI.ACI_CODIGO = SUK.UK_CODIGO AND ACI.%NotDel%
	LEFT JOIN %Table:SUP% SUP ON UP_FILIAL = %xFilial:SUP% AND UP_CODCAMP = ACI_CODSCR AND UP_CARGO = UK_CODRESP AND SUP.%NotDel%
	WHERE
	E2_FILIAL = %xFilial:SE2% AND
	E2_PREFIXO = 'REE' AND
	E2_TIPO = 'DEV' AND
	E2_EMISSAO BETWEEN %Exp:cPeriodo+"01"% AND %Exp:cPeriodo+"31"% AND
	(SELECT COUNT(*) FROM %TABLE:SZ6% WHERE Z6_FILIAL = %xFilial:SZ6% AND Z6_TIPO = 'REEMBO' AND Z6_PEDGAR = ADE_PEDGAR AND %NotDel%) = 0 AND
	SE2.%NotDel%
	GROUP BY ADE_PEDGAR
	UNION
	SELECT C5_CHVBPAG PEDGAR, 'REEMBOLSO' TIPO FROM %TABLE:SE5% SE5
	JOIN %TABLE:SC5% SC5 ON C5_FILIAL = %xFilial:SC5% AND C5_NUM = E5_NUMERO AND SC5.%NotDel%
	WHERE
	E5_FILIAL = %xFilial:SE5% AND
	E5_DATA BETWEEN %Exp:cPeriodo+"01"% AND %Exp:cPeriodo+"31"% AND
	E5_RECPAG = 'P' AND
	UPPER(E5_HISTOR) LIKE '%CHARGEBACK%' AND
	(SELECT SUM(Z6_VALCOM) FROM %TABLE:SZ6% WHERE Z6_FILIAL = %xFilial:SZ6% AND Z6_TIPO IN ('VERIFI','RENOVA') AND Z6_PEDGAR = C5_CHVBPAG AND %NotDel%) > 0 AND
	(SELECT COUNT(*) FROM %TABLE:SZ6% WHERE Z6_FILIAL = %xFilial:SZ6% AND Z6_TIPO = 'REEMBO' AND Z6_PEDGAR = C5_CHVBPAG AND %NotDel%) = 0 AND
	SE5.%NotDel%
	GROUP BY C5_CHVBPAG
	UNION
	SELECT Z5_PEDGAR PEDGAR, 'FAIXA' TIPO FROM %Table:SZ5%
	WHERE
	Z5_FILIAL = %xFilial:SZ5% AND
	SUBSTR(Z5_DATVER,1,6) = %Exp:cPeriodo% AND
	Z5_PEDGANT = ' ' AND
	Z5_DESCST > ' ' AND
	Z5_COMSW > 0 AND
	Z5_BLQVEN = '1' AND
	(UPPER(Z5_DESREDE) LIKE '%NOT%' OR UPPER(Z5_DESREDE) LIKE '%BR%') AND
	%Notdel%
	UNION
	SELECT Z5_PEDGAR PEDGAR, 'FAIXA' TIPO FROM %Table:SZ5%
	WHERE
	Z5_FILIAL = %xFilial:SZ5%  AND
	SUBSTR(Z5_DATEMIS,1,6) = %Exp:cPeriodo% AND
	Z5_PEDGANT > ' ' AND
	Z5_DESCST > ' ' AND
	Z5_COMSW > 0 AND
	Z5_BLQVEN = '1' AND
	(UPPER(Z5_DESREDE) LIKE '%NOT%' OR UPPER(Z5_DESREDE) LIKE '%BR%') AND
	%Notdel%

EndSql

DbSelectArea("TMPREC")
TMPREC->(DbGoTop())

While !TMPREC->(EOF())
    
	SZ5->(DbSetOrder(1))
	If SZ5->(DbSeek(xFilial("SZ5")+TMPREC->PEDGAR))
	
		If TMPREC->TIPO == "REEMBOLSO" //.And. SZ5->Z5_FLAGA != "R" 
			//adiciona dados para calculo
			Aadd(aPedidos,{SZ5->(Recno()),cPeriodo}) 
			//Faz o flag como reembolso cobrado.
			//SZ5->(RecLock("SZ5",.F.))
			//	SZ5->Z5_FLAGA := "R"
			//SZ5->(MsUnlock())
		Else
			SZ5->(RecLock("SZ5",.F.))
				SZ5->Z5_COMISS := " "
				SZ5->Z5_DESCST := " "
			SZ5->(MsUnlock())
		Endif
	Endif
	
	TMPREC->(DbSkip())
Enddo
//Se tem conteudo, faz a geracao do valor negativo.
If Len(aPedidos) > 0
	StartJob("U_CRPA020B",GetEnvServer(),.F.,'01','02',aPedidos,"CRPA020B","CRPA027R-REE")
	//U_CRPA020B('01','02',aPedidos,"CRPA020B","CRPA027R-REE")
	aPedidos := {} //Zera conteudo.
EndIf

//Fim da altera็ใo do recalculo.

If Select("TMPFX") > 0
	DbSelectArea("TMPFX")
	TMPFX->(DbCloseArea())
EndIf

//Renato Ruy - 04/10/16
//Atualiza contador de faixa.
//Separa pedidos da AC para gera็ใo da faixa.
BeginSql Alias "TMPFX"

	SELECT * FROM
	(SELECT  Z5_PEDGAR PEDGAR,
	        Z5_DATVER DATA,
	        Z5_PRODGAR PRODUTO,
	        Z5_COMSW,
	        Z5_BLQVEN,
	        Z5_DESREDE,
	        CASE
	        WHEN Z5_PRODGAR LIKE '%REG%' THEN 'BR'
	        WHEN Z5_PRODGAR LIKE '%SINRJ%' THEN 'SINRJ'
	        WHEN Z5_PRODGAR LIKE '%SIN%' THEN 'SIN'
	        WHEN Z5_PRODGAR LIKE '%FENACOR%' THEN 'FENCR'
	        END REDE,
	        R_E_C_N_O_ RECNOZ5
	 FROM %Table:SZ5% SZ5 
	 WHERE 
	 Z5_FILIAL = %xFilial:SZ5% 
	 AND Z5_DATVER BETWEEN %Exp:cPeriodo+"01"% AND %Exp:dDataFim% 
	 AND (Z5_PRODGAR LIKE '%REG%' OR Z5_PRODGAR LIKE '%SIN%' OR Z5_PRODGAR LIKE '%FENANCOR%') 
	 AND Z5_PRODGAR NOT LIKE '%18%'
	 AND Z5_PRODGAR NOT LIKE '%SERVER%'
	 AND (Z5_COMSW <= 0 Or Z5_BLQVEN = '0' Or 
	 	  (UPPER(Z5_DESREDE) NOT LIKE '%BR%' AND 
	 	   UPPER(Z5_DESREDE) NOT LIKE '%NOT%' AND 
	  	   UPPER(Z5_DESREDE) NOT LIKE '%BR CRED%') 
	 	  OR Z5_DESREDE LIKE '%CLUBE DO REVENDEDOR%')
	 AND Z5_PEDGANT = ' '
	 AND SZ5.%NotDel%
	 UNION
	 SELECT  Z5_PEDGAR PEDGAR,
	        Z5_DATEMIS DATA,
	        Z5_PRODGAR PRODUTO,
	        Z5_COMSW,
	        Z5_BLQVEN,
	        Z5_DESREDE,
	        CASE
	        WHEN Z5_PRODGAR LIKE '%REG%' THEN 'BR'
	        WHEN Z5_PRODGAR LIKE '%SINRJ%' THEN 'SINRJ'
	        WHEN Z5_PRODGAR LIKE '%SIN%' THEN 'SIN'
	        WHEN Z5_PRODGAR LIKE '%FENACOR%' THEN 'FENCR'
	        END REDE,
	        R_E_C_N_O_ RECNOZ5
	 FROM %Table:SZ5% SZ5 
	 WHERE 
	 Z5_FILIAL = %xFilial:SZ5% 
	 AND Z5_DATEMIS BETWEEN %Exp:cPeriodo+"01"% AND %Exp:dDataFim% 
	 AND Z5_COMISS != '2' 
	 AND (Z5_PRODGAR LIKE '%REG%' OR Z5_PRODGAR LIKE '%SIN%' OR Z5_PRODGAR LIKE '%FENANCOR%') 
	 AND Z5_PRODGAR NOT LIKE '%18%'
	 AND Z5_PRODGAR NOT LIKE '%SERVER%'
	 AND (Z5_COMSW <= 0 Or Z5_BLQVEN = '0' Or 
	 	  (UPPER(Z5_DESREDE) NOT LIKE '%BR%' AND 
	 	   UPPER(Z5_DESREDE) NOT LIKE '%NOT%' AND 
	  	   UPPER(Z5_DESREDE) NOT LIKE '%BR CRED%') 
	 	  OR Z5_DESREDE LIKE '%CLUBE DO REVENDEDOR%')
	 AND Z5_PEDGANT > ' '
	 AND SZ5.%NotDel%
	 UNION
	 SELECT  Z5_PEDGAR PEDGAR,
	        Z5_DATVER DATA,
	        Z5_PRODGAR PRODUTO,
	        Z5_COMSW,
	        Z5_BLQVEN,
	        Z5_DESREDE,
	        CASE
	        WHEN Z5_PRODGAR LIKE '%NOT%' THEN 'NOT'
          WHEN Z3_CODAC = 'NOT' THEN 'NOT'
	        END REDE,
	        SZ5.R_E_C_N_O_ RECNOZ5
	 FROM %Table:SZ5% SZ5
	 LEFT JOIN %Table:SZ3%  SZ3 ON SZ3.Z3_FILIAL = ' ' AND SZ5.Z5_CODPOS = SZ3.Z3_CODGAR  AND Z3_TIPENT='4' AND SZ3.%NotDel%
	 WHERE 
	 Z5_FILIAL = %xFilial:SZ5% 
	 AND Z5_DATVER BETWEEN %Exp:cPeriodo+"01"% AND %Exp:dDataFim% 
	 AND Z5_COMISS != '2' 
	 AND (Z5_PRODGAR LIKE '%NOT%' OR Z3_CODAC = 'NOT')
	 AND Z5_PRODGAR NOT LIKE '%18%'
	 AND Z5_PRODGAR NOT LIKE '%SERVER%'
	 AND (Z5_COMSW <= 0 Or Z5_BLQVEN = '0')
	 AND (Z5_DESREDE NOT LIKE '%NOT%' OR Z5_DESREDE LIKE '%CLUBE DO REVENDEDOR%')
	 AND Z5_PEDGANT = ' '
	 AND SZ5.%NotDel%
	 UNION
	 SELECT  Z5_PEDGAR PEDGAR,
	        Z5_DATEMIS DATA,
	        Z5_PRODGAR PRODUTO,
	        Z5_COMSW,
	        Z5_BLQVEN,
	        Z5_DESREDE,
	        CASE
	        WHEN Z5_PRODGAR LIKE '%NOT%' THEN 'NOT'
          WHEN Z3_CODAC = 'NOT' THEN 'NOT'
	        END REDE,
	        SZ5.R_E_C_N_O_ RECNOZ5
	FROM %Table:SZ5% SZ5 
	LEFT JOIN %Table:SZ3%  SZ3 ON SZ3.Z3_FILIAL = ' ' AND SZ5.Z5_CODPOS = SZ3.Z3_CODGAR  AND Z3_TIPENT='4' AND SZ3.%NotDel%
	WHERE 
	Z5_FILIAL = %xFilial:SZ5% 
	AND Z5_DATEMIS BETWEEN %Exp:cPeriodo+"01"% AND %Exp:dDataFim% 
	AND Z5_COMISS != '2' 
	AND (Z5_PRODGAR LIKE '%NOT%' OR Z3_CODAC = 'NOT')
	AND Z5_PRODGAR NOT LIKE '%18%'
	AND Z5_PRODGAR NOT LIKE '%SERVER%'
	AND (Z5_COMSW <= 0 Or Z5_BLQVEN = '0')
	AND (Z5_DESREDE NOT LIKE '%NOT%' OR Z5_DESREDE LIKE '%CLUBE DO REVENDEDOR%')
	AND Z5_PEDGANT > ' '
	AND SZ5.%NotDel%
   	)
	 ORDER BY DATA, PEDGAR
	 
 EndSql
 
DbSelectArea("TMPFX")
TMPFX->(DbGoTop())

While !TMPFX->(EOF())
	
	DbSelectArea("SZ5")
	SZ5->(DbGoTo(TMPFX->RECNOZ5))
	
	//Reinicia a variavel.
	cFaixa := ""
	
	//Verifica se ja tem cadastro de faixa.
	SZV->(DbSetOrder(1))
	If !SZV->(DbSeek( xFilial("SZV")+ PadR(TMPFX->REDE,6," ") + SubStr(TMPFX->DATA,1,4) ))
		//Gravo a faixa para iniciar gera็ใo de dados.
		SZV->(RecLock("SZV",.T.))
		SZV->ZV_CODENT := PadR(TMPFX->REDE,6," ")
		SZV->ZV_SALANO := SubStr(TMPFX->DATA,1,4)
		SZV->(MsUnlock())
	EndIf
	
	//Alimento a faixa durante o calculo se ainda nใo foi calculado.
	If Empty(SZ5->Z5_DESCST)
		SZV->( RecLock("SZV",.F.) )
		SZV->ZV_SALACU += 1
		//Fa็o valida็ใo do m๊s que serแ alimentado.
		If SubStr(TMPFX->DATA,5,2)     == "01"
			SZV->ZV_QTDJAN += 1
		Elseif SubStr(TMPFX->DATA,5,2) == "02"
			SZV->ZV_QTDFEV += 1
		Elseif SubStr(TMPFX->DATA,5,2) == "03"
			SZV->ZV_QTDMAR += 1
		Elseif SubStr(TMPFX->DATA,5,2) == "04"
			SZV->ZV_QTDABR += 1
		Elseif SubStr(TMPFX->DATA,5,2) == "05"
			SZV->ZV_QTDMAI += 1
		Elseif SubStr(TMPFX->DATA,5,2) == "06"
			SZV->ZV_QTDJUN += 1
		Elseif SubStr(TMPFX->DATA,5,2) == "07"
			SZV->ZV_QTDJUL += 1
		Elseif SubStr(TMPFX->DATA,5,2) == "08"
			SZV->ZV_QTDAGO += 1
		Elseif SubStr(TMPFX->DATA,5,2) == "09"
			SZV->ZV_QTDSET += 1
		Elseif SubStr(TMPFX->DATA,5,2) == "10"
			SZV->ZV_QTDOUT += 1
		Elseif SubStr(TMPFX->DATA,5,2) == "11"
			SZV->ZV_QTDNOV += 1
		Elseif SubStr(TMPFX->DATA,5,2) == "12"
			SZV->ZV_QTDDEZ += 1
		EndIf
		ConOut("Gravou no contador: " + SZ5->Z5_PEDGAR )
		SZV->( MsUnLock() )
		
		//Busca nos percentuais da entidades
		SZ4->( DbSetOrder(1) )
		If SZ4->( MsSeek( xFilial("SZ4")+PadR(TMPFX->REDE,6," ") ) )
			
			While SZ4->( !Eof() ) .AND. (PadR(TMPFX->REDE,6," ") == SZ4->Z4_CODENT)
				If SZ4->Z4_CATPROD $ "F1F2F3" .And. ("REG" $ SZ5->Z5_PRODGAR .Or. "NOT" $ SZ5->Z5_PRODGAR .Or. "SIN" $ SZ5->Z5_PRODGAR)
					If SZV->ZV_SALACU >= SZ4->Z4_QTDMIN .AND. SZV->ZV_SALACU <= SZ4->Z4_QTDMAX
						
						//Gravo para utilizar novamente em caso de recalculo.
						SZ5->( RecLock("SZ5",.F.) )
							SZ5->Z5_DESCST := SZ4->Z4_CATPROD
						SZ5->( MsUnLock() )
						
						cFaixa := SZ4->Z4_CATPROD
						
					Endif
				Endif
				SZ4->( DbSkip() )
			End
		Endif
		
		If Empty(SZ5->Z5_DESCST) .Or. Empty(cFaixa)
			//Gravo para utilizar novamente em caso de recalculo.
			SZ5->( RecLock("SZ5",.F.) )
				SZ5->Z5_DESCST := "F0" //Quando ainda nใo entra para calculo nas faixas.
			SZ5->( MsUnLock() ) 
			
			cFaixa := ""
		EndIf
	EndIf
	
	TMPFX->(DbSkip())
EndDo
//Encerra novo controle de faixas

// Renato Ruy - 04/10/2016
// Atualizar dados da contagem da faixa.
CRPA027Z(cPeriodo)

//Inicia prepara็ใo para calculo
BeginSql Alias "TMPCAL"

	SELECT * FROM (
	SELECT 	SZ5.R_E_C_N_O_, 
			SZ5.Z5_PEDSITE PEDIDO_SITE, 
			SZ5.Z5_PEDGAR PEDIDO_GAR, 
			SZ5.Z5_PRODGAR PROD_GAR, 
			CASE WHEN Z5_PEDSITE > ' ' THEN Z5_EMISSAO WHEN Z5_PEDGANT = ' ' THEN Z5_DATVER ELSE Z5_DATEMIS END DATA_PEDIDO , 
			'ENTHAR'  AS TIPO
	FROM %Table:SZ5% SZ5 
	LEFT JOIN %Table:SZ3% SZ3 
	ON SZ3.Z3_FILIAL = %xFilial:SZ3% AND SZ5.Z5_CODPOS = SZ3.Z3_CODGAR  AND Z3_TIPENT='4' AND SZ3.%NotDel%
	WHERE  
	SZ5.Z5_FILIAL = %xFilial:SZ5%  
	AND SZ5.Z5_EMISSAO BETWEEN %Exp:dDataIni% AND %Exp:dDataFim% 
	AND Z5_TIPO='ENTHAR'  
	AND SZ5.Z5_COMISS != '2' 
	AND SZ5.%NotDel%
	UNION 
	SELECT 	SZ5.R_E_C_N_O_, 
			SZ5.Z5_PEDSITE PEDIDO_SITE, 
			SZ5.Z5_PEDGAR PEDIDO_GAR,
			SZ5.Z5_PRODGAR PROD_GAR, 
			CASE WHEN Z5_PEDSITE > ' ' THEN Z5_EMISSAO WHEN Z5_PEDGANT = ' ' THEN Z5_DATVER ELSE Z5_DATEMIS END DATA_PEDIDO , 
			'VERIFI'  AS TIPO
	FROM %Table:SZ5% SZ5                                     
	LEFT JOIN %Table:SZ3% SZ3 
	ON SZ3.Z3_FILIAL = %xFilial:SZ3% AND SZ5.Z5_CODPOS = SZ3.Z3_CODGAR  AND Z3_TIPENT='4' AND SZ3.%NotDel%
	WHERE 
	SZ5.Z5_FILIAL = %xFilial:SZ5%
	AND SZ5.Z5_DATVER  BETWEEN %Exp:dDataIni% AND %Exp:dDataFim%  
	AND SZ5.z5_tipo in (' ','VALIDA','VERIFI','EMISSA')
	AND SZ5.Z5_COMISS != '2'  
	AND SZ5.Z5_PEDGANT=' '  
	AND SZ5.%NotDel% 
	UNION 
	SELECT 	SZ5.R_E_C_N_O_, 
			SZ5.Z5_PEDSITE PEDIDO_SITE, 
			SZ5.Z5_PEDGAR PEDIDO_GAR, 
			SZ5.Z5_PRODGAR PROD_GAR,
			CASE WHEN Z5_PEDSITE > ' ' THEN Z5_EMISSAO WHEN Z5_PEDGANT = ' ' THEN Z5_DATVER ELSE Z5_DATEMIS END DATA_PEDIDO , 
			'RENOVA'  AS TIPO
	FROM %Table:SZ5% SZ5 
	LEFT JOIN %Table:SZ3% SZ3 
	ON SZ3.Z3_FILIAL = %xFilial:SZ3% AND SZ5.Z5_CODPOS = SZ3.Z3_CODGAR  AND Z3_TIPENT='4' AND SZ3.%NotDel% 
	WHERE 
	SZ5.Z5_FILIAL = %xFilial:SZ5% 
	AND SZ5.Z5_DATEMIS  BETWEEN %Exp:dDataIni% AND %Exp:dDataFim% 
	AND SZ5.Z5_TIPO = 'EMISSA' 
	AND SZ5.Z5_COMISS != '2' 
	AND SZ5.Z5_PEDGANT>'0' 
	AND SZ5.%NotDel%
	) ORDER BY DATA_PEDIDO
EndSql

TMPCAL->(DbGoTop())

//envia para processamento
While TMPCAL->( !Eof() )
	
	
	//Faz distribui็ใo e monitora a quantidade de thread em execu็ใo
	BEGIN SEQUENCE 
	
	nThread := 0
	aUsers 	:= Getuserinfoarray()
	aEval(aUsers,{|x| IIF( ALLTRIM(UPPER(x[5])) == "U_CRPA020B",nThread++,nil )  })
	
	END SEQUENCE
	
	ErrorBlock(bOldBlock)

	cErrorMsg := U_GetProcError()
	If !empty(cErrorMsg)
	  cMensagem := "Inconsist๊ncia no Processamento: "+CRLF+cErrorMsg
      conout(cMensagem + " "+TIme()+" Pedido ")
	EndIf

	
	//Limita a quantidade de Threads.
	If nThread <= 10
		
		nContador := 0
		aPedidos  := {}
		
		//Envio para processamento de 10 em 10 pedidos.
		While TMPCAL->( !Eof() ) .And. nContador <= 100

			//Se nใo estiver vazio adiciono no array
			//Renato Ruy - 14/09/16
			//Somente Calcula ou Recalcula pedidos de Periodos Futuros - Superior ao parametro MV_REMMES.
			If !Empty(TMPCAL->R_E_C_N_O_) .And. CRPA020Y(TMPCAL->PROD_GAR) .And. TMPCAL->DATA_PEDIDO > getmv("MV_REMMES")
				Aadd(aPedidos,{TMPCAL->R_E_C_N_O_,SubStr(TMPCAL->DATA_PEDIDO,1,6)})
				nContador += 1
			EndIf
			
			//Pulo para a pr๓xima linha.
			TMPCAL->(DbSkip())
		EndDo
		
		//Envio o conte๚do para Thread se o array for maior que um
		If Len(aPedidos) > 0
			nTotThread += 1
			StartJob("U_CRPA020B",GetEnvServer(),.F.,'01','02',aPedidos,"CRPA020B","CRPA027W-JOB")
			aPedidos := {}
//			U_CRPA020B('01','02',aPedidos,"CRPA020B","CRPA027W-JOB")
		EndIf
	Else
	
		While nThread>=9
  			sleep(50000)
			cErrorMsg := ""
			bOldBlock := ErrorBlock({|e| U_ProcError(e) })
			BEGIN SEQUENCE      
			
			nThread := 0
			aUsers 	:= Getuserinfoarray()
			aEval(aUsers,{|x| IIF( ALLTRIM(UPPER(x[5])) == "U_CRPA020B",nThread++,nil )  })
					
			END SEQUENCE
			ErrorBlock(bOldBlock)
			cErrorMsg := U_GetProcError()
			If !empty(cErrorMsg)
	    	  cMensagem := "Inconsist๊ncia no Faturamento: "+CRLF+cErrorMsg
	          conout(cMensagem + " "+TIme()+" Pedido ")
			EndIf
		EndDo
		
	EndIf
	
	If nTotThread > 10                           
		conout( "[CERFATPED] " + "[" + DtoC( Date() ) + " " + Time() + "] - Processou 10 threads - Libera memoria" )
		DelClassIntf()
		nTotThread := 0
	EndIf
	
EndDo

TMPCAL->( DbCloseArea() )

//Renato Ruy - 14/03/17
//Calcular os pedidos apos atualizacao de valores
CRPA027I(cPeriodo)

Return

//Renato Ruy - 06/05/2016
//Fun็ใo para excluir pedido de renova็ใo rejeitado.
User Function CRPA027Y()

//Abre a conexใo com a empresa
RpcSetType(3)
RpcSetEnv("01","02")

If Select("TMPREN") > 0
	DbSelectArea("TMPREN")
	TMPREN->(DbCloseArea())
EndIf

BeginSql Alias "TMPREN"

	SELECT Z5_PEDGAR, SZ5.R_E_C_N_O_ RECNOZ5
	FROM %Table:SZ5% SZ5
	LEFT JOIN %Table:SZF% SZF 
	ON ZF_FILIAL = %xFilial:SZF% AND ZF_PEDIDO = Z5_PEDGAR AND SZF.%NotDel%
	WHERE
	Z5_FILIAL = %xFilial:SZ5% AND
	Z5_DATEMIS = ' ' AND
	Z5_PEDGANT > ' ' AND
	Z5_STATUS = '4' AND
	ZF_COD IS NULL AND
	SZ5.%NotDel%

EndSql

DbSelectArea("TMPREN")
TMPREN->(DbGoTop())

While !TMPREN->(EOF())

	SZ5->(DbGoTo(TMPREN->RECNOZ5))
    
    If AllTrim(SZ5->Z5_PEDGAR) == AllTrim(TMPREN->Z5_PEDGAR)
    	RecLock("SZ5",.F.) // Define que serแ realizada uma altera็ใo no registro posicionado
			DbDelete() // Efetua a exclusใo l๓gica do registro posicionado.
		SZ5->(MsUnLock()) // Confirma e finaliza a opera็ใo
    EndIf
	
	TMPREN->(DbSkip())

EndDo

Return

//Renato Ruy - 06/05/2016
//Funcao para validar produtos pagos ou nao pagos.
//Pedidos que tem categoria preenchida na PA8, serao pagos.
Static Function CRPA020Y(cProduto)

Local lPosicao := .F.
Local cCategor := ""
Local lProPago := .T.

PA8->(DbSetOrder(1))
lPosicao := PA8->(DbSeek(xFilial("PA8")+PadR(AllTrim(cProduto),32," ") ))

cCategor := Iif(lPosicao,PA8->PA8_CATPRO,"")

If SubStr(cProduto,1,3) $ "PRD/SPB/CSI" .And. (Empty(cCategor) .Or. !lPosicao)
	lProPago := .F.
Elseif SubStr(cProduto,1,4) $ "CERT/IMES" .And. (Empty(cCategor) .Or. !lPosicao)
	lProPago := .F.
Elseif SubStr(cProduto,1,5) == "CLASS" .And. (Empty(cCategor) .Or. !lPosicao)
	lProPago := .F. 
Elseif  "BB" $ cProduto .And. (Empty(cCategor) .Or. !lPosicao)
	lProPago := .F.
EndIf

Return(lProPago) 

//Renato Ruy - 19/08/2016
//Funcao para validar se e de campanha e apagar controle de faixas
Static Function CRPA027F()

Local lValCamp := .F.
Local cCodigo  := ""
Local cCodPer  := ""

//Quando o pedido tem percentual e o vendedor esta ativo.
If SZ5->Z5_COMSW > 0 .And. SZ5->Z5_BLQVEN != "0"

	//Seta como verdadeiro para apagar o campo Z5_DESCST
	lValCamp := .T. 
	
	//Seta a rede que serแ incrementado o calculo.
	If "BR" $ Upper(SZ5->Z5_DESREDE)
		cCodigo := "BR"
	ElseIf "NOT" $ Upper(SZ5->Z5_DESREDE)
		cCodigo := "NOT"
	ElseIf "SINRJ" $ Upper(SZ5->Z5_DESREDE)
		cCodigo := "SINRJ"
	ElseIf "SIN" $ Upper(SZ5->Z5_DESREDE)
		cCodigo := "SIN"
	EndIf 
	
	//Armazena periodo.
	cCodPer := Iif(Empty(SZ5->Z5_PEDGANT),SZ5->Z5_DATVER,SZ5->Z5_DATEMIS)
	
	//Subtrai o valor do contador, para nao ficar errado.
	//Isto e necessario porque no primeiro calculo o pedido foi marcado para contagem.
	SZV->( DbSetOrder(1) ) // ZV_FILIAL+ZV_CODENT+ZV_SALANO
	If SZV->( DbSeek( xFilial("SZV") + PadR(cCodigo,6,"0") + SubStr(DtoS(cCodPer),1,4) ) )
		
		SZV->(Reclock("SZV",.F.))
			SZV->ZV_QTDJAN	:= IIF(Val(SubStr(cCodPer,5,2)) == 1, SZV->ZV_QTDJAN - 1, 0)
			SZV->ZV_QTDFEV	:= IIF(Val(SubStr(cCodPer,5,2)) == 2, SZV->ZV_QTDFEV - 1, 0)
			SZV->ZV_QTDMAR	:= IIF(Val(SubStr(cCodPer,5,2)) == 3, SZV->ZV_QTDMAR - 1, 0)
			SZV->ZV_QTDABR	:= IIF(Val(SubStr(cCodPer,5,2)) == 4, SZV->ZV_QTDABR - 1, 0)
			SZV->ZV_QTDMAI	:= IIF(Val(SubStr(cCodPer,5,2)) == 5, SZV->ZV_QTDMAI - 1, 0)
			SZV->ZV_QTDJUN	:= IIF(Val(SubStr(cCodPer,5,2)) == 6, SZV->ZV_QTDJUN - 1, 0)
			SZV->ZV_QTDJUL	:= IIF(Val(SubStr(cCodPer,5,2)) == 7, SZV->ZV_QTDJUL - 1, 0)
			SZV->ZV_QTDAGO	:= IIF(Val(SubStr(cCodPer,5,2)) == 8, SZV->ZV_QTDAGO - 1, 0)
			SZV->ZV_QTDSET	:= IIF(Val(SubStr(cCodPer,5,2)) == 9, SZV->ZV_QTDSET - 1, 0)
			SZV->ZV_QTDOUT 	:= IIF(Val(SubStr(cCodPer,5,2)) == 10,SZV->ZV_QTDOUT - 1, 0)
			SZV->ZV_QTDNOV	:= IIF(Val(SubStr(cCodPer,5,2)) == 11,SZV->ZV_QTDNOV - 1, 0)
			SZV->ZV_QTDDEZ	:= IIF(Val(SubStr(cCodPer,5,2)) == 12,SZV->ZV_QTDDEZ - 1, 0)
		SZV->(MsUnlock())
		
	Endif   
	
EndIf

Return lValCamp

// Renato Ruy - 04/10/2016
// Por problemas de integra็ใo de dados, sera necessario ajustar o contador.
Static Function CRPA027Z(cPeriodo)

//Local lNovo 	:= .F.
Local cCampo	:= ""
Local cCodFx	:= ""
Local nTotal	:= 0
Local nContBR 	:= 0
Local nConNOT 	:= 0
Local nConSIN 	:= 0
Local nConSINR 	:= 0

RpcSetType(3)
RpcSetEnv("01","02")

If Select("TMPDAT") > 0
	DbSelectArea("TMPDAT")
	TMPDAT->(DbCloseArea())
EndIf

//Busca Pedidos sem data
Beginsql Alias "TMPDAT"

	SELECT Z6_PEDGAR FROM SZ6010
	WHERE
	Z6_FILIAL = ' ' AND
	Z6_PERIODO = %Exp:cPeriodo% AND
	Z6_TPENTID IN ('2','5') AND
	Z6_PEDGAR > ' ' AND
	Z6_DTPEDI = ' ' AND
	%NotDel%
	GROUP BY Z6_PEDGAR

EndSql

SZ5->(DbSetOrder(1))

While !TMPDAT->(EOF())

	CRPA027B(TMPDAT->Z6_PEDGAR,.F.)
	
	SZ5->(DbSetOrder(1))
	If SZ5->(DbSeek(xFilial("SZ5")+TMPDAT->Z6_PEDGAR))
	 
		SZ5->(Reclock("SZ5",.F.))
			SZ5->Z5_COMISS := " "
		SZ5->(MsUnlock())
			
	Endif

	TMPDAT->(Dbskip())
Enddo

If Select("TMPREC") > 0
	DbSelectArea("TMPREC")
	TMPREC->(DbCloseArea())
EndIf

BeginSql Alias "TMPREC"

	SELECT * FROM
	(SELECT  Z5_DATPED,
	        Z5_PEDGAR,
	        Z5_PRODGAR,
	        Z5_DESCST,
	        CASE
	                      WHEN Z5_PRODGAR LIKE '%REG%' THEN 'BR'
	                      WHEN Z5_PRODGAR LIKE '%SINRJ%' THEN 'SINRJ'
	                      WHEN Z5_PRODGAR LIKE '%SIN%' THEN 'SIN'
	                      WHEN Z5_PRODGAR LIKE '%FENACOR%' THEN 'FENCR'
	        ELSE 'NOT'
	                      END REDE
	FROM SZ5010
	WHERE
	Z5_FILIAL = ' ' AND
	Z5_DATVER BETWEEN %Exp:cPeriodo+"01"% AND %Exp:cPeriodo+"31"% AND
	Z5_PEDGANT = ' ' AND
	Z5_DESCST IN ('F0','F1','F2','F3','F4','F5','F6') AND
	D_E_L_E_T_ = ' '
	UNION
	SELECT  Z5_DATPED,
	        Z5_PEDGAR, 
	        Z5_PRODGAR,
	        Z5_DESCST,
	        CASE
	                      WHEN Z5_PRODGAR LIKE '%REG%' THEN 'BR'
	                      WHEN Z5_PRODGAR LIKE '%SINRJ%' THEN 'SINRJ'
	                      WHEN Z5_PRODGAR LIKE '%SIN%' THEN 'SIN'
	                      WHEN Z5_PRODGAR LIKE '%FENACOR%' THEN 'FENCR'
	        ELSE 'NOT'
	                      END REDE 
	FROM SZ5010
	WHERE
	Z5_FILIAL = ' ' AND
	Z5_DATEMIS BETWEEN %Exp:cPeriodo+"01"% AND %Exp:cPeriodo+"31"% AND
	Z5_PEDGANT > ' ' AND
	Z5_DESCST IN ('F0','F1','F2','F3','F4','F5','F6') AND
	D_E_L_E_T_ = ' ')
	ORDER BY REDE,Z5_DATPED

Endsql

//Obtem saldo das ACs
If Substr(cPeriodo,5,2) == "01"
	cCampo := "ZV_QTDJAN"
Elseif Substr(cPeriodo,5,2) == "02"
	cCampo := "ZV_QTDFEV"
Elseif Substr(cPeriodo,5,2) == "03"
	cCampo := "ZV_QTDMAR"
Elseif Substr(cPeriodo,5,2) == "04"
	cCampo := "ZV_QTDABR"
Elseif Substr(cPeriodo,5,2) == "05"
	cCampo := "ZV_QTDMAI"
Elseif Substr(cPeriodo,5,2) == "06"
	cCampo := "ZV_QTDJUN"
Elseif Substr(cPeriodo,5,2) == "07"
	cCampo := "ZV_QTDJUL"
Elseif Substr(cPeriodo,5,2) == "08"
	cCampo := "ZV_QTDAGO"
Elseif Substr(cPeriodo,5,2) == "09"
	cCampo := "ZV_QTDSET"
Elseif Substr(cPeriodo,5,2) == "10"
	cCampo := "ZV_QTDOUT"
Elseif Substr(cPeriodo,5,2) == "11"
	cCampo := "ZV_QTDNOV"
Elseif Substr(cPeriodo,5,2) == "12"
	cCampo := "ZV_QTDDEZ"
Endif

nContBR 	:= Posicione("SZV",1,xFilial("SZV")+"BR    "+Substr(cPeriodo,1,4),"ZV_SALACU") - Posicione("SZV",1,xFilial("SZV")+"BR    "+Substr(cPeriodo,1,4),cCampo)
nConNOT 	:= Posicione("SZV",1,xFilial("SZV")+"NOT   "+Substr(cPeriodo,1,4),"ZV_SALACU") - Posicione("SZV",1,xFilial("SZV")+"NOT   "+Substr(cPeriodo,1,4),cCampo)
nConSIN 	:= Posicione("SZV",1,xFilial("SZV")+"SIN   "+Substr(cPeriodo,1,4),"ZV_SALACU") - Posicione("SZV",1,xFilial("SZV")+"SIN   "+Substr(cPeriodo,1,4),cCampo)
nConSINR 	:= Posicione("SZV",1,xFilial("SZV")+"SINRJ "+Substr(cPeriodo,1,4),"ZV_SALACU") - Posicione("SZV",1,xFilial("SZV")+"SINRJ "+Substr(cPeriodo,1,4),cCampo)

While !TMPREC->(EOF())

	nContBR 	+= Iif("BR"$TMPREC->REDE,1,0)
	nConNOT 	+= Iif("NOT"$TMPREC->REDE,1,0)
	nConSIN 	+= Iif("SIN"$TMPREC->REDE,1,0)
	nConSINR 	+= Iif("SINRJ"$TMPREC->REDE,1,0)
	
	//Retorna acumulado atual
	If "BR"$TMPREC->REDE
		nTotal	:= nContBR
	ElseIf "NOT"$TMPREC->REDE
		nTotal	:= nConNOT
	ElseIf "SIN"$TMPREC->REDE
		nTotal	:= nConSIN
	ElseIf "SINRJ"$TMPREC->REDE
		nTotal	:= nConSINR
	Endif
	
	//Retorna Faixa atual para gravacao
	cCodFx := SetFaixa(TMPREC->REDE,nTotal,TMPREC->Z5_PRODGAR)
	
	If AllTrim(TMPREC->Z5_DESCST) != cCodFx
	
		SZ5->(DbSetOrder(1))
		If SZ5->(DbSeek(xFilial("SZ5")+TMPREC->Z5_PEDGAR))
		 
			SZ5->(Reclock("SZ5",.F.))
				SZ5->Z5_DESCST := cCodFx
				SZ5->Z5_COMISS := " "
			SZ5->(MsUnlock())
				
		Endif
	
	Endif
	
	TMPREC->(DbSkip())
Enddo

Return

//Buscar faixa atual
Static Function SetFaixa(cEntidade,nTotal,cProduto)

Local cCodFx := ""

//Busca nos percentuais da entidades
SZ4->( DbSetOrder(1) )
If SZ4->( MsSeek( xFilial("SZ4")+cEntidade ) )
	While SZ4->( !Eof() ) .AND. Padr(cEntidade,6," ") == SZ4->Z4_CODENT
		If SZ4->Z4_CATPROD $ "F1F2F3" .And. ("REG" $ cProduto .Or. "NOT" $ cProduto .Or. "SIN" $ cProduto)
			If nTotal >= SZ4->Z4_QTDMIN .AND. nTotal <= SZ4->Z4_QTDMAX
				
				cCodFx := SZ4->Z4_CATPROD
				
			Endif
		Endif
		SZ4->( DbSkip() )
	Enddo
Endif

cCodFx := Iif(Empty(cCodFx),"F0",cCodFx)


Return cCodFx

//Renato Ruy - 14/03/2017
//Atualizar pedido e marcar para ser recalculado.
Static Function CRPA027I(cPeriodo)

Local lAtu := .T.

If Select("TMPZER") > 0
	DbSelectArea("TMPZER")
	TMPZER->(DbCloseArea())
Endif

Beginsql Alias "TMPZER"
	SELECT Z6_PEDGAR FROM %Table:SZ6%
	WHERE
	Z6_FILIAL = %xFilial:SZ6% AND
	Z6_PERIODO = %Exp:cPeriodo% AND
	Z6_CATPROD = '2' AND
	Z6_VLRPROD = 0 AND
	Z6_VALCOM = 0 AND
	Z6_TIPO IN ('VERIFI','RENOVA') AND
	%Notdel%
	GROUP BY Z6_PEDGAR
Endsql

While !TMPZER->(EOF())

	SZ5->(DbSetOrder(1))
	If SZ5->(DbSeek(xFilial("SZ5") + TMPZER->Z6_PEDGAR))
		If SZ5->Z5_VALORSW + SZ5->Z5_VALORHW == 0
			U_AtuValZ5(TMPZER->Z6_PEDGAR, "1")
		Else
			lAtu := .F.
		Endif
	Endif
	
	If SZ5->Z5_VALORSW + SZ5->Z5_VALORHW > 0 .And. lAtu
		SZ5->(Reclock("SZ5",.F.))
			SZ5->Z5_COMISS := "1"
		SZ5->(MsUnlock())
	Endif

	TMPZER->(DbSkip())

Enddo

Return


Static Function logProc(nOpc,cTexto)

Local cEOL    := "CHR(13)+CHR(10)"

Default cTexto := ""

If Empty(cEOL)
	cEOL := CHR(13)+CHR(10)
Else
	cEOL := Trim(cEOL)
	cEOL := &cEOL
Endif

Do Case 
	Case nOpc == 1
		If !ExistDir("\pedidosfaturados\GAR\log")
			MakeDir("\pedidosfaturados\GAR\log")
		EndIf
	
		If !File("\pedidosfaturados\GAR\log\Import_GAR_" + DtoS(dDataBase) + ".csv")
			nLogProc := fCreate("\pedidosfaturados\GAR\log\Import_GAR_" + DtoS(dDataBase) + StrTran(Time(),":","") + ".csv")
		EndIf
	Case nOpc == 2
		If nLogProc != -1
			fWrite(nLogProc, DTOS(dDataBase) + " - " + Time() + ": " + cTexto + cEOL)
		Else
			conout("O arquivo de log nใo foi criado.")
		EndIf
	Case nOpc == 3
		fClose(nLogProc)
		
	Case nOpc == 4
		conout("[CRPA027] " + DTOC(Date()) + " - " + Time() + ": " + cTexto)
EndCase

Return

User Function CRPA027Log(cDataLog)

Processa({|| LogRun(cDataLog)},"Processando Log","Log Manual em Execu็ใo...",.F.)

Return

Static Function LogRun(cDataLog)

Local cArqLog 	:= "\pedidosfaturados\GAR\log_manual_"+DtoS(dDataBase)+".csv"
Local nHdlLog  	:= fCreate(cArqLog)
Local dDataLog	:= Iif("/" $ cDataLog,CTOD(cDataLog),STOD(cDataLog))
Local cLin		:= ""
Local cEOL    	:= "CHR(13)+CHR(10)"

If Empty(cEOL)
	cEOL := CHR(13)+CHR(10)
Else
	cEOL := Trim(cEOL)
	cEOL := &cEOL
Endif

//Verifico tabela do log de importacao
BeginSql Alias "QCRPA027"
	SELECT SUBSTR(ZZ3_DTIMP,7,2)||'/'||SUBSTR(ZZ3_DTIMP,5,2)||'/'||SUBSTR(ZZ3_DTIMP,1,4) ZZ3_DTIMP,
		   ZZ3_PEDGAR,
		   ZZ3_LOG,
		   C5_NUM,
		   Z5_PRODGAR,
		   Z5_CODVOU,
		   ZF_DESTIPO
	FROM %Table:ZZ3% ZZ3
	//GERAR INFORMAวรO DE VOUCHER E PRODUTO.
	LEFT JOIN %Table:SC5% SC5 ON C5_FILIAL = %Exp:xFilial("SC5")% AND TRIM(C5_CHVBPAG) = TRIM(ZZ3_PEDGAR) AND SC5.D_E_L_E_T_ = ' '
	LEFT JOIN %Table:SZ5% SZ5 ON Z5_FILIAL = %Exp:xFilial("SZ5")% AND Z5_PEDGAR = ZZ3_PEDGAR AND Z5_PEDGAR > ' ' AND SZ5.D_E_L_E_T_ = ' '
	LEFT JOIN %Table:SZF% SZF ON ZF_FILIAL = %Exp:xFilial("SZF")% AND ZF_COD = Z5_CODVOU AND ZF_SALDO = 0 AND SZF.D_E_L_E_T_ = ' '
	WHERE
	ZZ3.D_E_L_E_T_ = ' '
	AND ZZ3_FILIAL = %Exp:xFilial("ZZ3")%
	AND ZZ3_DTIMP = %Exp:DtoS(dDataLog)%
EndSql

DbSelectArea("QCRPA027")
QCRPA027->(DbGoTop())

If nHdlLog != -1
	cLin := "Data Importa็ใo;Pedido Gar;Pedido Protheus;Produto Gar;C๓digo Voucher;Tipo Voucher;Log Importa็ใo;Validado;Verificado;Emitido"+cEOL
	fWrite(nHdlLog, cLin)
EndIf

//Gravo dados no log
While QCRPA027->(!EOF())
	If nHdlLog != -1
		cLin := QCRPA027->ZZ3_DTIMP +";"
		cLin += QCRPA027->ZZ3_PEDGAR+";"
		cLin += QCRPA027->C5_NUM+";"
		cLin += QCRPA027->Z5_PRODGAR+";"
		cLin += QCRPA027->Z5_CODVOU+";"
		cLin += QCRPA027->ZF_DESTIPO+";"
		cLin += QCRPA027->ZZ3_LOG+";"
		cLin += Iif("VALIDACAO" $ QCRPA027->ZZ3_LOG, "X", "")+";"
		cLin += Iif("VERIFICACAO" $ QCRPA027->ZZ3_LOG, "X", "")+";"
		cLin += Iif("EMISSAO" $ QCRPA027->ZZ3_LOG, "X", "")+";"
		cLin += cEOL

		fWrite(nHdlLog,cLin)
	Endif
	QCRPA027->(DbSkip())
	lProcessou := .T.
EndDo

If lProcessou
	//Mando e-mail de com o log para o usuario
	MandEmail("Arquivo de Log de importa็๕es do dia " + DtoC(dDataLog),;
			   AllTrim(GetMV("MV_XLOGIMP")),;
			   "Log Importa็ใo Gar [Manual]",;
			   cArqLog,"", "", "")
Else
	Alert("Nใo hแ registros gerados na tabela ZZ3 para o dia " + DTOC(dDataLog))
EndIf

Return

/*
*/
User Function CRPA27Im()

Local cDirIn 	:= ""
Local aDirIn 	:= {}
Local cAux		:= ""

cDirIn := IIF(!Empty(cAux:=(cGetFile("\", "Diret๓rios", 1,"X:\" ,.F. , GETF_RETDIRECTORY+GETF_LOCALHARD ))),cAux,cDirIn)

aDirIn := Directory(cDirIn+"*.CSV")

Processa({|| CopyImps(cDirIn,aDirIn)}, "Copiando Arquivos")
Return

Static Function CopyImps(cDirIn,aDirIn)

Local nSize := Len(aDirIn)
Local Ni	:= 0

ProcRegua(nSize)

For Ni := 1 To nSize
	If !CPYT2S(cDirIn+aDirIn[Ni][1],"\pedidosfaturados\GAR\")
		Alert("Erro ao copiar arquivo " + aDirIn[Ni][1])
	Else
		FErase(cDirIn+aDirIn[Ni][1])
	EndIf
	IncProc()
Next

Return
