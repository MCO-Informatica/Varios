#INCLUDE "PROTHEUS.CH"

//+------------+---------------+----------------------------------------------------------------------------------+--------+----------+
//| Data       | Desenvolvedor | Descricao                                                                        | Versao | Jira     |
//+------------+---------------+----------------------------------------------------------------------------------+--------+----------+
//| 18/06/2020 | Bruno Nunes   | Nota fiscal não disponível                                                       | 1.00   | PROT-263 |
//|            |               | Neste card será necessário a correção das rotinas que tratam a exceção do envio  |        |          |
//|            |               | das notas fiscais ao Checkout,  (forçam o envio do espelho da nota ao Checkout). |        |          |
//|            |               | Hoje a nossa rotina que deveria enviar os espelhos das notas ao Checkout,        |        |          |
//|            |               | precisa ser corrigida, porém na Sprint 14 iniciaremos a correção das rotinas     |        |          |
//|            |               | de tratamento de exceção.                                                        |        |          |
//|            |               | Rotinas a serem verificadas: Cerfat e CSFT120JOB.                                |        |          |
//+------------+---------------+----------------------------------------------------------------------------------+--------+----------+

#DEFINE SERVICO "RP2"
#DEFINE PRODUTO "2  \3  "

/*/{Protheus.doc} CSFT120Job
Funcao para reprocessar espelho da nota fiscal
@type function 
@author Yuri Volpe
@since 09/10/2020
@version P12  17.3.0.8
@build 7.00.170117A-20190627
/*/
User Function CSFT120Job(aParam)

	Local cJobEmp	:= Iif( aParam == NIL, "01" , aParam[1] )
	Local cJobFil	:= Iif( aParam == NIL, "02" , aParam[2] )
	Local dDataMin	:= CTOD("")	
	Local aPedidos	:= {}
	Local cSerie	:= ""
    Local cOrigem   := "" 
    Local nMaxRows  := 0
    
    Private lPrint  := Iif( aParam == Nil, .T., aParam[3] )
	Private lJob	:= ( Select( "SX6" ) == 0 )
	
	//Se não for Job, chama a rotina com interface visual
	//Senão, prepara o ambiente para execução
	If !lJob
		Conout("[CSFT120JOB] Rotina não está rodando em Job. Processo abortado.")
		Return
	Else
		RpcSetType( 3 )
		RpcSetEnv( cJobEmp, cJobFil )
		Conout("[CSFT120JOB] Ambiente carregado.")
	EndIf

	//Data a partir da qual deverão ser consideradas
    //as notas para análise
	dDataMin := GetNewPar("MV_XDTESPE",dDataBase)
    nMaxRows := GetNewPar("MV_XMAXROW",1000)
	
    //Origem dos pedidos C5_XORIGPV
    cOrigem   := "%" + Formatin(StrTran(GetMV("CS_XORIGPV"),"'"),'/')  + "%" 

	//Para filial 02, usa série 2 (São Paulo)
	//Para filial 01, usa série 3 (Rio de Janeiro)
	If cJobFil == "02"
		cSerie := Padr("2",TamSX3("C6_SERIE")[1])
	ElseIf cJobFil == "01"
		cSerie := Padr("3",TamSX3("C6_SERIE")[1])
	Else
		Conout("[CSFT120JOB] Parâmetro de filial incorreto.")
		Return
	EndIf
	
	If Select("TMPESPELHO") > 0
		TMPESPELHO->(dbCloseArea())
	EndIf

	//Busca Itens do Pedidos de Venda com NF emitida e Flag de Envio ao checkout vazio.
    //limitar a 100 where parametro de dias 
	BeginSql Alias "TMPESPELHO"

       SELECT SC6.R_E_C_N_O_ FROM %Table:SC6% SC6
                INNER JOIN %Table:SC5% SC5
                    ON C5_FILIAL = C6_FILIAL
                    AND C5_NUM = C6_NUM
                WHERE C6_XFLAGHW = ' ' 
                AND C6_FILIAL = ' ' 
                AND C6_NOTA != ' ' 
                AND C5_EMISSAO >= %Exp:DtoS(dDataMin)%
                AND C5_XORIGPV IN %Exp:cOrigem%
                AND C6_SERIE = %Exp:cSerie%
                AND (
                        (C6_XNFHRD = ' ' AND C6_XOPER = ANY('52','62')) 
                        OR 
                        (C6_XNFHRE = ' ' AND C6_XOPER = ANY('53')))
                AND C6_XFLAGHW NOT IN ('E','S')
                AND SC6.%NotDel%
                AND SC5.%NotDel%
                AND ROWNUM <= %Exp:nMaxRows%
                

            UNION 
                SELECT SC6.R_E_C_N_O_ FROM %Table:SC6% SC6 
                INNER JOIN %Table:SC5% SC5
                    ON C5_FILIAL = C6_FILIAL
                    AND C5_NUM = C6_NUM
                WHERE C6_XFLAGSF = ' '
                AND C5_EMISSAO >= %Exp:DtoS(dDataMin)%
                AND C6_FILIAL = ' ' 
                AND C6_NOTA != ' ' 
                AND C5_XORIGPV IN %Exp:cOrigem%
                AND C6_SERIE = 'RP2'
                AND (C6_XNFSFW = ' ' OR C6_LINKNFS = ' ' )
                AND C6_XOPER = ANY('51','61')
                AND C6_XFLAGSF NOT IN ('E','S')
                AND SC6.%NotDel%
                AND SC5.%NotDel%
                AND ROWNUM <= %Exp:nMaxRows%
               
	EndSql
        

	Conout("[CSFT120JOB] " + getLastQuery()[2])
	
	//Captura os pedidos para um array
	While TMPESPELHO->(!EoF())
		aAdd(aPedidos, TMPESPELHO->R_E_C_N_O_)
		Conout("[CSFT120JOB] Pedido RECNO: " + cValToChar(TMPESPELHO->R_E_C_N_O_))
		TMPESPELHO->(dbSkip())
	EndDo
	
    TMPESPELHO->(dbCloseArea())

	If Len(aPedidos) > 0
		
		Conout("[CSFT120JOB] Chamando rotina para disparo das mensagerias.")
	
		//Rotina estática de processamento
		CSFT120Run(aPedidos)
	Else
		gravaLog("Sem registros para processamento.")
		Conout("[CSFT120JOB] Não há registros para processamento. Encerrando rotina.")
	EndIf

Return

/*/{Protheus.doc} CSFT120Run
Funcao auxiliar para reprocessar espelho da nota fiscal
@type function 
@author Yuri Volpe
@since 09/10/2020
@version P12  17.3.0.8
@build 7.00.170117A-20190627
/*/
Static Function CSFT120Run(aPedidos)

    Local Ni := 1
    Local aLog := {}
    
    dbSelectArea("SC5")
    SC5->(dbSetOrder(1))

    dbSelectArea("SC6")

    For Ni := 1 To Len(aPedidos)

        Conout("[CSFT120JOB] Processando pedido Recno: " + cValToChar(aPedidos[Ni]))

        SC6->(dbGoTo(aPedidos[Ni]))

        If SC5->(dbSeek(xFilial("SC5") + SC6->C6_NUM))
            
            Conout("[CSFT120JOB] Carregando impressão Pedido: " + cValToChar(aPedidos[Ni]) + " C6_NUM: " + SC6->C6_NUM)

            If CSFT120Print()
                
                Conout("[CSFT120JOB] Carregando Notificação do Checkout: " + cValToChar(aPedidos[Ni]) + " C6_NUM: " + SC6->C6_NUM)
                NotificaCheckout()
        
                aAdd(aLog,"Processado Pedido: " + SC6->C6_NUM + " Nota: " + SC6->C6_NOTA + "/" + SC6->C6_SERIE)

            EndIf

        EndIf
    Next

    If Len(aLog) > 1
        gravaLog(aLog)
    EndIf

    Conout("[CSFT120JOB] Processamento encerrado.")

Return

/*/{Protheus.doc} CSFT120Print
Funcao validar e chamar as funcoes de geracao do espelho de nota
@type function 
@author Yuri Volpe
@since 09/10/2020
@version P12  17.3.0.8
@build 7.00.170117A-20190627
/*/
Static Function CSFT120Print()
    Local lRet 		:= .T.
    Local aAreaSC5  := SC5->(GetArea())
    Local aAreaSC6  := SC6->(GetArea())

    dbSelectArea("SF2")
    SF2->(dbSetOrder(1))    //F2_FILIAL + F2_DOC + F2_SERIE ...
    If SF2->(dbSeek(xFilial("SF2") + SC6->C6_NOTA + SC6->C6_SERIE))
        //Verifica se a NFE foi validado
        If validaNFE()
            If AllTrim(SC6->C6_SERIE) == "2"  .Or. AllTrim(SC6->C6_SERIE) == "3"
                
                Conout("[CSFT120JOB] Carregando impressão PRODUTO: " + cValToChar(SC6->(Recno())) + " Pedido/Item: " + SC6->C6_NUM + SC6->C6_ITEM)
                aRet := U_GARR010({.T.})
                lRet := aRet[1]
                Conout("[CSFT120JOB] Impressão PRODUTO: (" + cValToChar(lRet) + ") " + cValToChar(SC6->(Recno())) + " Pedido/Item: " + SC6->C6_NUM + SC6->C6_ITEM)

                If !lRet
                    Conout("[CSFT120JOB] Impressão PRODUTO: (" + cValToChar(lRet) + ") " + cValToChar(SC6->(Recno())) + " Pedido/Item: " + SC6->C6_NUM + SC6->C6_ITEM + aRet[2] + "/" + aRet[3] + "/" + aRet[4])
                EndIf

            ElseIf AllTrim(SC6->C6_SERIE) == "RP2"
                
                Conout("[CSFT120JOB] Carregando impressão SOFTWARE: " + cValToChar(SC6->(Recno())) + " Pedido/Item: " + SC6->C6_NUM + SC6->C6_ITEM)
                lRet := U_GARR020({.T.},.T.)[1]
                Conout("[CSFT120JOB] Impressão SOFTWARE: (" + cValToChar(lRet) + ") " + cValToChar(SC6->(Recno())) + " Pedido/Item: " + SC6->C6_NUM + SC6->C6_ITEM)

            EndIf
        EndIf

    EndIf

    RestArea(aAreaSC5)
    RestArea(aAreaSC6)

Return lRet

/*/{Protheus.doc} NotificaCheckout
Funcao gerar mensagem do processamentos
@type function 
@author Yuri Volpe
@since 09/10/2020
@version P12  17.3.0.8
@build 7.00.170117A-20190627
/*/
Static Function NotificaCheckout()

    Local cJson     := ""
    Local cTipo     := ""
    Local cDataGer  := ""
    Local cLink     := ""
    Local oWsObj    := Nil
    Local oWsRes    := Nil
    Local cError    := ""
    Local cWarning  := ""
    Local lSoftware := .F.
    Local lHardware := .F.
    Local cDataFat  := DTOS(SC6->C6_DATFAT)

    oWsObj := WSVVHubServiceService():New()

    cDataGer := Left(cDataFat, 4) + '-' + SubStr(cDataFat, 5, 2) + '-' + Right(cDataFat,2)

    Do Case
        Case SC6->C6_SERIE == SERVICO
            cLink := Alltrim(SC6->C6_XNFSFW)
            cTipo := "SERVICO"
            lSoftware := .T.
        Case SC6->C6_SERIE $ PRODUTO
            cLink := Alltrim(SC6->C6_XNFHRD)
            cTipo := "PRODUTO"
            lHardware := .T.
    EndCase

    cJson := '{"pedido":' + SC5->C5_XNPSITE + ',' +;
                IIF( !Empty(SC6->C6_XIDPED),;
                    '"pedidoItem":'+SC6->C6_XIDPED + ',',;
                    '') +;
				'"tipo":"' + cTipo + '",'+;
                '"serie":"' + SC6->C6_SERIE + '",'+;
                '"numeroNF":"' + SC6->C6_NOTA + '",'+;
                '"dataGeracao":"' + cDataGer + 'T00:00:00.000Z",'+;
                '"link":"' + cLink + '"}'

    Conout("[CSFT120JOB] Mensagem a ser enviada: " + cJson)

    lOk	:= oWsObj:SendMessage( "NOTIFICA-NF", cJson )

    cSvcError   := GetWSCError()  //-- Resumo do erro
    cSoapFCode  := GetWSCError(2) //-- Soap Fault Code
    cSoapFDescr := GetWSCError(3) //-- Soap Fault Description

    lOk := Empty( cSvcError ) .OR. Empty( cSoapFCode )

    IF lOk
        oWsRes := XmlParser( oWsObj:CSENDMESSAGERESPONSE, "_", @cError, @cWarning )
        IF "confirmaType" $ oWSObj:CSENDMESSAGERESPONSE
            IF oWsRes:_CONFIRMATYPE:_CODE:TEXT == "1"
                
                RecLock("SC6", .F.)
                    IF lSoftware
                        SC6->C6_XFLAGSF := "X"
                    ElseIF lHardware
                        SC6->C6_XFLAGHW := "X"
                    EndIF
                SC6->(MsUnLock())					
            End				
        EndIF
    Else
        Conout("[CSFT120JOB] Mensagem JSON não enviada: " + cJson)
    EndIF        

Return

/*/{Protheus.doc} gravaLog
Rotina auxiliar para gravação de LOG em arquivo e envio 
por e-mail (JOB) ou apresentação no Notepad do usuário
@type function 
@author Yuri Volpe
@since 27/07/2020
@version P12  17.3.0.8
@build 7.00.170117A-20190627
/*/
Static Function gravaLog(aLog)

	Local nHdl 		:= 0
	Local cFileLog	:= "CSFT120_" + StrTran(DtoS(Date()),"/","") + StrTran(Time(),":","") + ".log"
	Local cPath		:= ""
	Local Ni		:= 0
	Local cTempPath := Iif(!lJob,GetTempPath(),"")
    Local cLinha    := ""
	
	Conout("[CSFAT120] Tentando gravar arquivo: " + cPath + cFileLog)
	
	nHdl := fCreate(cPath + cFileLog)
	
	If nHdl == -1
		Conout("[CSFAT120] Não foi possível gravar o arquivo de log.")
		Return
	EndIf
	 
	For Ni := 1 To Len(aLog)
        cLinha := aLog[Ni]
		fWrite(nHdl, cLinha + CHR(13) + CHR(10))
	Next
	
	fClose(nHdl)
	
	Conout("[CSFAT120] Arquivo de log gravado.")
	
	If !lJob
		CpyS2T(cPath + cFileLog, cTempPath)
		ShellExecute("Open","%WINDIR%\notepad.exe", cTempPath + cFileLog, "C:\",1)
	Else
		Conout("[CSFAT120] Disparando e-mail.")
		FSSendMail( "sistemascorporativos@certisign.com.br", "Log de Processamento - Espelho da Nota", "Anexo pedidos processados no dia " + DTOC(dDataBase), GetSrvProfString('Startpath','') + cFileLog )
	EndIf
	
	FErase(cFileLog)
	
Return

/*/{Protheus.doc} validaNFE
Funcao para validar se deve ou nao reprocessar o espelho da nota fiscal
@type function 
@author Yuri Volpe
@since 27/07/2020
@version P12  17.3.0.8
@build 7.00.170117A-20190627
/*/
static function validaNFE()
	local lValido := .T.
       
    Conout("[CSFT120JOB] A Nota Fiscal não foi aprovada: " + SF2->F2_DOC + "/" + SF2->F2_SERIE + ": " + AllTrim(SF2->F2_ARET))
	If ( AllTrim(SC6->C6_SERIE) == "2"  .Or. AllTrim(SC6->C6_SERIE) == "3" ) .and. empty( SF2->F2_CHVNFE )// complementar se a chave da danfe nao esta vazia na sf2
		RecLock("SC6",.F.)	     
	    SC6->C6_XFLAGHW := "E"
	    SC6->(MsUnlock())
	    lValido := .F.
	ElseIf AllTrim(SC6->C6_SERIE) == "RP2" .and. empty( SF2->F2_CODNFE )
	    RecLock("SC6",.F.)
	    SC6->C6_XFLAGSF := "E"
	    SC6->(MsUnlock())
	    lValido := .F.
	EndIf
	Conout("[CSFT120JOB] Flag atualizado com código de Erro. " + SC6->C6_NUM + "/" + SC6->C6_ITEM)

return lValido 
