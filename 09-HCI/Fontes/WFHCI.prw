#include "Protheus.ch"
#include "Topconn.ch"
#include "TbiConn.ch"
#include "TbiCode.ch"

                                                           
/*                                                                        	
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณWFAC      บAutor  ณJoao Tavares S JuniorบData ณ             บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณWorkflow HCI                                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ HCI                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function AC(aParam)  // Agendamento U_AC("01',1)

If aParam == Nil .OR. VALTYPE(aParam) == "U"
	U_CONSOLE("Parametros nao recebidos => PV()")
	RETURN
EndIf

Prepare Environment Empresa aParam[1][1] Filial aParam[1][2]
//RpcSetEnv(aParam[1],'01',,'FAT')
	U_CONSOLE("Parametros recebidos => AC()")
CHKFILE("SM0")

DBSelectArea("SM0")
DBSetOrder(1)
DBSeek(aParam[1][1],.F.)

U_CONSOLE('AC() /' + aParam[1][1] )

WHILE !SM0->(EOF()) .AND. SM0->M0_CODIGO == aParam[1][1]
	cFilAnt	:= SM0->M0_CODFIL
	
	U_CONSOLE('AC() /' + aParam[1][1] + cFilAnt)
	U_CONSOLE('Paramentro Recebido /' + StrZero(aParam[1][3],2))
	U_WFAC(aParam[1][3])
	SM0->(DBSkip())
END
RETURN

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณWFAC      บAutor  ณMicrosiga           บ Data ณ  08/15/02   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ 1 - ENVIO DE EMAIL PARA APROVADORES                        บฑฑ
ฑฑบ          ณ 2 - RETORNO DE EMAIL COM RESPOSTA DE APROVADORES           บฑฑ
ฑฑบ          ณ 3 - ENVIO de Email - Pedido Reprovado					  บฑฑ
ฑฑบ          ณ 4 - ENVIO de Email - Pedido Aprovado						  บฑฑ
ฑฑบ          ณ 5 - ENVIO de Email - NOTIFICACAO DE PRAZO DE VALIDADE	  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function WFAC(_nOpc, oProcess)

Local _lProcesso 	:= .F.
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ{ฟ
//ณDeclaracao de variaveis                                                         ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ{ู
Local _aWF	 		:= {}
Local cObs 			:= ""
Local nTotal    	:= 0
Local lLiberou		:= .F.
Local cAlias1		:= ""
Local cAlias2		:= ""

DO CASE
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ1 - Prepara os DADOS a serem enviados para aprovacao	 ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	CASE _nOpc == 1
		U_CONSOLE("1 - Prepara registros Aprovacao de Credito")
		
		CHKFile("SCR")  // Documentos com al็adas
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Seleciona os registros do SCR - DBF / INDREGUA                         ณ
		//ณ Abre um novo Alias para evitar problemas com filtros ja existentes.    ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		_cQuery := ""
		_cQuery += " SELECT"
		_cQuery += " CR_FILIAL,"
		_cQuery += " CR_TIPO,"
		_cQuery += " CR_NUM,"
		_cQuery += " CR_NIVEL,"
		_cQuery += " CR_TOTAL,"
		_cQuery += " CR_USER,"
		_cQuery += " R_E_C_N_O_, "
		_cQuery += " CR_APROV"
		_cQuery += " FROM " + RetSqlName("SCR") + " SCR"
		_cQuery += " WHERE SCR.D_E_L_E_T_ <> '*'"
		_cQuery += " AND CR_FILIAL = '" + xFilial("SCR") + "'"
		_cQuery += " AND CR_TIPO IN ('01','02') "
		_cQuery += " AND CR_STATUS = '02'"  								// Em aprovacao
		_cQuery += " AND CR_WF = ' '"
		_cQuery += " ORDER BY"
		_cQuery += " CR_FILIAL,"
		_cQuery += " CR_NUM,"
		_cQuery += " CR_NIVEL,"
		_cQuery += " CR_USER"
		
		TcQuery _cQuery New Alias "TMP"
		
		dbSelectArea("TMP")
		dbGotop()
		While !TMP->(Eof()) 
			If TMP->CR_TIPO == "01"
				cAlias1:="SCJ->CJ"
				cAlias2:="SCK->CK"
				_aWF	 	:= EnviaAC(TMP->CR_FILIAL, TMP->CR_NUM, TMP->CR_USER , TMP->CR_APROV, TMP->(CR_FILIAL+CR_NUM+CR_TIPO),TMP->CR_TOTAL,"\WORKFLOW\HTML\ORCAMENTO.HTM",cAlias1,cAlias2,TMP->CR_TIPO)
			ElseIf TMP->CR_TIPO == "02"
				cAlias1:="SC5->C5"
				cAlias2:="SC6->C6"
				_aWF	 	:= EnviaAC(TMP->CR_FILIAL, TMP->CR_NUM, TMP->CR_USER , TMP->CR_APROV, TMP->(CR_FILIAL+CR_NUM+CR_TIPO),TMP->CR_TOTAL,"\WORKFLOW\HTML\PEDIDO.HTM",cAlias1,cAlias2,TMP->CR_TIPO)
				Else
		   		_lProcesso 	:= .F.				
			EndIf
			_lProcesso 	:= .T.
			dbSelectArea("SCR")
			dbGoTo(TMP->R_E_C_N_O_)
			If Empty(SCR->CR_WFID) .And. Empty(SCR->CR_WF)
				Reclock("SCR",.F.)
				SCR->CR_WF	 := IIF(EMPTY(_aWF[1])," ","1")  	// Status 1 - envio para aprovadores / branco-nao houve envio
				SCR->CR_WFID := _aWF[1]		// Rastreabilidade
				MSUnlock()
			EndIf
			dbSelectArea("TMP")
			DBSkip()
		EndDo
		
		dbSelectArea("TMP")
		dbCloseArea()
	CASE _nOpc	== 2
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ2 - Processa O RETORNO DO EMAIL                       ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		//	U_CONSOLE("2 - nOpc: "+_nOpc)
		U_CONSOLE("2 - Processa O RETORNO DO EMAIL")
		U_CONSOLE("2 - Semaforo Vermelho" )
		
		nWFAC2 := U_Semaforo("WFAC2")
		
		ChkFile("SCR")
		ChkFile("SAL")
		ChkFile("SC9")
		ChkFile("SCS")
		ChkFile("SAK")
		ChkFile("SM2")
		
		IF oProcess <> NIL
			cFilAnt		:= alltrim(oProcess:oHtml:RetByName("CFILANT"))
			cChaveSCR	:= alltrim(oProcess:oHtml:RetByName("CHAVE"))
			cOpc     	:= alltrim(oProcess:oHtml:RetByName("OPC"))
			//ctip     	:= alltrim(oProcess:oHtml:RetByName("CTIP"))
			cWFID     	:= alltrim(oProcess:oHtml:RetByName("WFID"))
			
			oProcess:Finish() // FINALIZA O PROCESSO
			
			U_CONSOLE("2 - Chave :" + cChaveSCR)
			U_CONSOLE("2 - Filial :" + SubStr(cChaveSCR,1,2))
			U_CONSOLE("2 - Num :" + SubStr(cChaveSCR,3,8))
			U_CONSOLE("2 - Tipo :" + alltrim(SubStr(cChaveSCR,9,54)) )
			U_CONSOLE("2 - Opc   :" + cOpc)
		ENDIF
		U_CONSOLE("2 - Start aprovacao: "+ cWFID)
		IF cOpc $ "S|N"  // Aprovacao S-Sim N-Nao
			U_CONSOLE("Liberacao Status tipo 1 " + cWFID+" - "+cChaveSCR)
			
			CHKFile("SCR")  // Documentos com al็adas
			
			_cQuery := ""
			_cQuery += " SELECT"
			_cQuery += " CR_FILIAL,"
			_cQuery += " CR_TIPO,"
			_cQuery += " CR_NUM,"
			_cQuery += " CR_NIVEL,"
			_cQuery += " CR_TOTAL,"
			_cQuery += " CR_USER,"
			_cQuery += " CR_WFID,"
			_cQuery += " R_E_C_N_O_, "
			_cQuery += " CR_APROV"
			_cQuery += " FROM " + RetSqlName("SCR") + " SCR"
			_cQuery += " WHERE CR_FILIAL  = '" + SubStr(cChaveSCR,1,2) + "'"
			_cQuery += " AND CR_NUM  = '" + SubStr(cChaveSCR,3,8) + "'"
			_cQuery += " AND CR_TIPO = '" + alltrim(SubStr(cChaveSCR,9,54)) + "'"
			_cQuery += " AND CR_STATUS = '03'"  								// Em aprovacao
			_cQuery += " AND CR_WF <> '2'"
			_cQuery += " AND SCR.D_E_L_E_T_ <> '*'"
			_cQuery += " ORDER BY"
			_cQuery += " CR_FILIAL,"
			_cQuery += " CR_NUM,"
			_cQuery += " CR_NIVEL,"
			_cQuery += " CR_USER"
			
			TcQuery _cQuery New Alias "TMP"
			
			dbSelectArea("TMP")
			dbGotop()
			While !TMP->(Eof())
				dbSelectArea("SCR")
				dbGoTo(TMP->R_E_C_N_O_)
				U_CONSOLE("X - Processo ja respondido via Sistema:" +SCR->CR_WFID+" - "+cChaveSCR)
				U_CONSOLE("X - Semaforo Verde" )
				WFKillProcess(SCR->CR_WFID)
				dbSelectArea("TMP")
				dbSkip()
			End
			
			U_CONSOLE("Liberacao Status tipo 2 " + cWFID+" - "+cChaveSCR)
			dbSelectArea("TMP")
			dbCloseArea()
			
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Seleciona os registros do SCR - DBF / INDREGUA                         ณ
			//ณ Abre um novo Alias para evitar problemas com filtros ja existentes.    ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			_cQuery := ""
			_cQuery += " SELECT"
			_cQuery += " CR_FILIAL,"
			_cQuery += " CR_TIPO,"
			_cQuery += " CR_NUM,"
			_cQuery += " CR_NIVEL,"
			_cQuery += " CR_TOTAL,"
			_cQuery += " CR_USER,"
			_cQuery += " CR_WFID,"
			_cQuery += " R_E_C_N_O_, "
			_cQuery += " CR_APROV"
			_cQuery += " FROM " + RetSqlName("SCR") + " SCR"
			_cQuery += " WHERE CR_FILIAL  = '" + SubStr(cChaveSCR,1,2) + "'"
			_cQuery += " AND CR_NUM  = '" + SubStr(cChaveSCR,3,8) + "'"
			_cQuery += " AND CR_TIPO = '" + alltrim(SubStr(cChaveSCR,9,54)) + "'"
			_cQuery += " AND CR_STATUS = '02'"  								// Em aprovacao
			_cQuery += " AND CR_WF <> '2'"
			_cQuery += " AND SCR.D_E_L_E_T_ <> '*'"
			_cQuery += " ORDER BY"
			_cQuery += " CR_FILIAL,"
			_cQuery += " CR_NUM,"
			_cQuery += " CR_NIVEL,"
			_cQuery += " CR_USER"
			
			TcQuery _cQuery New Alias "TMP"
			
			dbSelectArea("TMP")
			dbGotop()
			If EOF()
				U_CONSOLE("Y - Processo ja respondido via Sistema: - "+cChaveSCR)
				U_CONSOLE("Y - Semaforo Verde" )
				Return .T.
			Endif
			dbSelectArea("TMP")
			dbGotop()
			While !TMP->(Eof())
				If TRIM(TMP->CR_WFID) <> TRIM(cWFID)
					U_CONSOLE("Ponto 1" )
					//"Este processo nao foi encontrado e portanto deve ser descartado
					// abre uma notificacao a pessoa que respondeu
					U_CONSOLE("2 - Processo nao encontrado :" + cWFID + " Processo atual :" + TMP->CR_WFID)
					U_CONSOLE("2 - Semaforo Verde" )
					U_Semaforo(nWFAC2)
					//	Return .T.
				Else
					U_CONSOLE("Ponto 2" )
					dbSelectArea("SCR")
					dbGoTo(TMP->R_E_C_N_O_)
					Reclock("SCR",.F.)
					SCR->CR_WF		:= "2"			// Status 2 - respondido
					MSUnlock()
					U_CONSOLE("Mudei o CR_WF para 2")
					Exit
				EndIf
				dbSkip()
			EndDo
			
			dbSelectArea("SCR")
			dbGoTo(TMP->R_E_C_N_O_)
			If !Empty(SCR->CR_DATALIB) .And. SCR->CR_STATUS$"03#04#05"
				U_CONSOLE("2 - Processo ja respondido :" + cWFID+" - "+cChaveSCR)
				U_CONSOLE("2 - Semaforo Verde" )
				U_Semaforo(nWFAC2)
				Return .T.
			EndIf
			
			//If LEFT(SCR->CR_TIPO,1) == "R"
			U_CONSOLE("Liberacao bloqueio Orcamento:" + cWFID)
			// Verifica se o pedido esta aprovado por credito
			// Se estiver, finaliza o processo
			_lCredito := .T.
			dbSelectArea("SCJ")
			DBSetOrder(1)
			dbGotop()
			If dbSeek(xFilial("SCJ")+Alltrim(SCR->CR_NUM),.T.)
				
				_lCredito 	:= IIF(SCJ->CJ_STSBLQ =='1' .And. SCJ->CJ_STATUS =='E', .T., .F.)
				
			EndIf
			
			U_CONSOLE("Ponto 3" )
			
			IF ! _lCredito  // NAO ESTIVER BLOQUEADO
				U_CONSOLE("3 - Processo ja respondido via sistema :" + cWFID)
				U_CONSOLE("3 - Semaforo Verde" )
				U_Semaforo(nWFAC2)
				U_CONSOLE(" Forcei a passagem")
				//Return .T.
			ENDIF
			                    
			nTotal 		:= SCR->CR_TOTAL
			_lProcesso 	:= .T.
			
			lLiberou := U_AlcDoc2({SCR->CR_NUM,SCR->CR_TIPO,SCR->CR_TOTAL,SCR->CR_APROV,,,,,,,cObs},dDataBase,If(cOpc=="S",4,6),,,)
				
			U_CONSOLE("3 - Liberado :" + IIF(lLiberou, "Sim", "Nao"))
			
			If lLiberou
				U_CONSOLE(" U_A450Grava")
				//	U_A450Grava(Alltrim(SCR->CR_NUM),SCR->CR_TIPO)
			EndIf
		EndIf
		U_CONSOLE("3 - Semaforo Verde" )
		U_Semaforo(nWFAC2)
END CASE

IF 	_lProcesso
	U_CONSOLE(" Mensagem processada " )
ELSE
	U_CONSOLE(" Nao houve processamento ")
ENDIF

RETURN



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณEnviaAC   บAutor  ณMicrosiga           บ Data ณ  10/22/02   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ _cWF ' ' - Envia email para aprovador                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function EnviaAC(_cFilial,_cNum, _cUser, _cAprov, _cChave, _nTotal, cHtml,cAlias1,cAlias2,_cTip)
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDeclaracao de variaveis                                                         ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local _aReturn 		:= {}
Local _aViewPV 		:= {}

Local _nLin 		:= 0
//Local nSomaPed 		:= 0
//Local lInfoChefe    := .F.
Local aArea			:= GetArea()
Local aAreaSC5		:= SC5->(GetArea())
Local aAreaSC9		:= SC9->(GetArea())
Local aAreaSCJ		:= SCJ->(GetArea())
Local aAreaSCK		:= SCK->(GetArea())
Local aAreaSC6		:= SC6->(GetArea())
Local aAreaSA1		:= SA1->(GetArea())
Local aAreaSA3		:= SA3->(GetArea())




//If At("ACINFOCHEFE.HTM",Upper(cHtml)) > 0
//	lInfoChefe := .T.
//Endif

_cNum 	:= TRIM(_cNum)

ChkFile("SC9")
ChkFile("SE1")
ChkFile("SE4")
ChkFile("SE5")
ChkFile("SC5")
ChkFile("SC6")
ChkFile("SA1")
ChkFile("SCJ")
ChkFile("SCK")
ChkFile("SA3")
ChkFile("SB1")
ChkFile("SBM")
ChkFile("SX5")
ChkFile("ACY")
ChkFile("SX5")
ChkFile("SM0")
DBSelectArea("SX5")

DBSelectArea(SubStr(cAlias1,1,3))
DBSetOrder(1)
DBSeek(_cFilial+_cNum)

DBSelectArea("SM0")
DBSetOrder(1)
DBSeek(cEmpAnt+cFilAnt)

DBSelectArea("SA3")
DBSetOrder(1)
If SubStr(cAlias1,1,3) == "SCJ"
	DBSeek(_cFilial+&(cAlias1+"_VEND"))
Else
	DBSeek(_cFilial+&(cAlias1+"_VEND1"))
EndIf

DBSelectArea("SA1")
DBSetOrder(1)
If SubStr(cAlias1,1,3) == "SCJ"
	DBSeek(xFilial("SA1")+&(cAlias1+"_CLIENTE")+&(cAlias1+"_LOJA"))
Else
	DBSeek(xFilial("SA1")+&(cAlias1+"_CLIENTE")+&(cAlias1+"_LOJACLI"))
EndIf
DBSelectArea("SE4")
DBSetOrder(1)
DBSeek(xFilial("SE4")+&(cAlias1+"_CONDPAG"))

DBSelectArea(SubStr(cAlias2,1,3))
DBSetOrder(1)
DBSeek(_cFilial+_cNum,.F.)

nValMerc := 0
nValTotal:= 0
nDesconto:= 0
nPerDes  := 0

While ! (SubStr(cAlias2,1,3))->(EOF()) .AND. &(cAlias2+"_FILIAL") == _cFilial .AND. &(cAlias2+"_NUM") == _cNum
	
	nValMerc	+= &(cAlias2+"_QTDVEN") * &(cAlias2+"_PRCVEN")
	nValTotal 	+= &(cAlias2+"_VALOR")
	nDesconto   += &(cAlias2+"_VALDESC")
	
	(SubStr(cAlias2,1,3))->(DBskip())
EndDo

nPerDes := (1 - (nValTotal/nValMerc)) * 100

_cTo	:= UsrRetMail(_cUser)

//-------------------------------------VALIDACAO-------------------
_lError := .F.


if Empty(_cTo)
	cTitle  := "Administrador do Workflow : NOTIFICAวรO"
	cBody	:= REPLICATE('*',80) + CHR(10) + CHR(13)
	cBody	+= Dtoc(MSDate()) + " - " + Time() + ' * Ocorreu um ERRO no envio da mensagem :' + CHR(10) + CHR(13)
	If _cTip = "01"
		cBody	+= "Or็amento Numero : " + _cNum + " Filial : " + cFilAnt + " Usuแrio : " + UsrRetName(_cUser) + CHR(10) + CHR(13)
	Else
		cBody	+= "Pedido Numero : " + _cNum + " Filial : " + cFilAnt + " Usuแrio : " + UsrRetName(_cUser) + CHR(10) + CHR(13)
	EndIf
	cBody	+= "Campo EMAIL do cadastro de usuแrio NAO PREENCHIDO" + CHR(10) + CHR(13)
	cBody	+= REPLICATE('*',80)
	
	_lError := .T.
Endif
//---- MONTA ITENS DO PEDIDO DO ORCAMENTO
_aViewPV	:= MontaItemPV(&(cAlias1+"_FILIAL"),&(cAlias1+"_NUM"),cAlias2)
_cBLCRED	:= ""

//---------------------
//OPROCESS  - WORKFLOW
If _cTip = "01"
	oProcess  := TWFProcess():New( "000001", "Envio Aprovacao de Orcamento :" + SM0->M0_NOME + "/" +  TRIM(_cNum) )
	oProcess:NewTask( "Envio AC : "+_cFilial + _cNum, "\WORKFLOW\HTML\ORCAMENTO.HTM" )
	oProcess:cSubject 	:= "Aprovacao de Orcamento :" + _cFilial + "/" +  _cNum
Else
	oProcess  := TWFProcess():New( "000001", "Envio Aprovacao de Pedido :" + SM0->M0_NOME + "/" +  TRIM(_cNum) )
	oProcess:NewTask( "Envio AC : "+_cFilial + _cNum, "\WORKFLOW\HTML\PEDIDO.HTM" )
	oProcess:cSubject 	:= "Aprovacao de Pedido :" + _cFilial + "/" +  _cNum
EndIf
oProcess:bReturn  	:= "U_WFAC(2)"
oProcess:cTo      	:= _cTo
oProcess:NewVersion(.T.)
oHtml := oProcess:oHTML

// Hidden Fields
U_CONSOLE("Pontos Ocultos "+ cHtml )
oHtml:ValByName( "CTIP"		, _cTip)
oHtml:ValByName( "CHAVE"	, _cChave)
oHtml:ValByName( "CFILANT"	, cFilAnt)
oHtml:ValByName( "WFID"		, oProcess:fProcessId)


//Cabe็alho
//DADOS DO PEDIDO
oHtml:ValByName( "C9_FILIAL"	, SM0->M0_NOME )
oHtml:ValByName( "C9_PEDIDO"	, _cNum)
oHtml:ValByName( "E4_DESCRI"    , SE4->E4_DESCRI )//+" // "+ StrZero(u_PrzMedio(SCJ->CJ_CONDPAG),3))
oHtml:ValByName( "nValMerc"		, TRANSFORM(nValMerc,'@E 999,999,999.99'))
oHtml:ValByName( "nDesconto"	, TRANSFORM(nDesconto,'@E 999,999,999.99'))
oHtml:ValByName( "nPerDes"	    , TRANSFORM(nPerDes,'@E 9,999.99'))
oHtml:ValByName( "A3_NOME"		, SA3->A3_NOME )
oHtml:ValByName( "CR_TOTAL"		, TRANSFORM(nValTotal,'@E 999,999,999.99'))


//DADOS DO CLIENTE
oHtml:ValByName( "A1_NOME"		, SA1->A1_NOME + " " + SA1->A1_COD + "-"+ SA1->A1_LOJA )
If Len(Alltrim(SA1->A1_CGC))== 11
	oHtml:ValByName( "A1_CGC"		, TRANSFORM(SA1->A1_CGC,'@R 999.999.999-99'))
else
	oHtml:ValByName( "A1_CGC"		, TRANSFORM(SA1->A1_CGC,'@R 99.999.999/9999-99'))
EndIf
oHtml:ValByName( "A1_TEL"		, SA1->A1_TEL )



// ITENS DO PEDIDO
IF Len(_aViewPV) > 0
	FOR _nLin := 1 TO Len(_aViewPV)
		AAdd( (oHtml:ValByName( "t4.1" )), _aViewPV[_nLin][1])
		AAdd( (oHtml:ValByName( "t4.2" )), _aViewPV[_nLin][2])
		AAdd( (oHtml:ValByName( "t4.3" )), _aViewPV[_nLin][3])
		AAdd( (oHtml:ValByName( "t4.4" )), _aViewPV[_nLin][4])
		AAdd( (oHtml:ValByName( "t4.5" )), Transform(_aViewPV[_nLin][5],"@E 9,999"))
		AAdd( (oHtml:ValByName( "t4.6" )), Transform(_aViewPV[_nLin][6],"@E 999,999,999,999.99"))
		AAdd( (oHtml:ValByName( "t4.7" )), Transform(_aViewPV[_nLin][7],"@E 999,999,999,999.99"))
		AAdd( (oHtml:ValByName( "t4.8" )), Transform(_aViewPV[_nLin][8],"@E 9,999.99"))
		AAdd( (oHtml:ValByName( "t4.9" )), Transform(_aViewPV[_nLin][9],"@E 999.99"))
		
	NEXT
ELSE
	AAdd( (oHtml:ValByName( "t4.1" )), " ")
	AAdd( (oHtml:ValByName( "t4.2" )), " ")
	AAdd( (oHtml:ValByName( "t4.3" )), "")
	AAdd( (oHtml:ValByName( "t4.4" )), "")
	AAdd( (oHtml:ValByName( "t4.5" )), " 0 ")
	AAdd( (oHtml:ValByName( "t4.6" )), " 0,00 ")
	AAdd( (oHtml:ValByName( "t4.7" )), " 0,00")
	AAdd( (oHtml:ValByName( "t4.8" )), " 0,00 ")
	AAdd( (oHtml:ValByName( "t4.9" )), " 0,00")
	
ENDIF



//-------------------------------------------------------------
// ALIMENTA A TELA DE PROCESSO DE APROVAวรO DE PEDIDO DE VENDAS
//-------------------------------------------------------------
DBSelectarea("SCR")
DBSetOrder(2)
If SubStr(cAlias1,1,3) == "SCJ"
	DBSeek(xFilial("SCR")+"01"+_cNum)
Else 
	DBSeek(xFilial("SCR")+"02"+_cNum)
EndIf
WHILE !SCR->(EOF()) .AND. Rtrim(SCR->(CR_FILIAL+CR_NUM)) == Rtrim(xFilial("SCR")+_cNum)
	
	cSituaca := ""
	Do Case
		Case SCR->CR_STATUS == "01"
			cSituaca := "Aguardando"
		Case SCR->CR_STATUS == "02"
			cSituaca := "Em Aprovacao"
		Case SCR->CR_STATUS == "03"
			cSituaca := "Aprovado"
		Case SCR->CR_STATUS == "04"
			cSituaca := "Bloqueado"
			lBloq := .T.
		Case SCR->CR_STATUS == "05"
			cSituaca := "Nivel Liberado"
	EndCase
	
	_cT4 := UsrRetName(SCR->CR_USERLIB)
	//	_cT6 := SCR->CR_OBS
	
	AAdd( (oHtml:ValByName( "t3.2"    )), UsrFullName(SCR->CR_USER))
	AAdd( (oHtml:ValByName( "t3.3"    )), cSituaca    )
	AAdd( (oHtml:ValByName( "t3.5"    )), DTOC(SCR->CR_DATALIB))
	
	SCR->(DBSkip())
ENDDO
DBSetOrder(1)
// ARRAY DE RETORNO
AADD(_aReturn, oProcess:fProcessId+oProcess:fTaskId)
oProcess:Start()

RestArea(aAreaSC5)
RestArea(aAreaSC6)
RestArea(aAreaSCJ)
RestArea(aAreaSCK)
RestArea(aAreaSC9)
RestArea(aAreaSA1)
RestArea(aAreaSA3)

RestArea(aArea)
return _aReturn


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMontaItemPVบAutor  ณMicrosiga           บ Data ณ  08/15/02   บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                             บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6                                                         บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function MontaItemPV(_cFilial,_cPedido,cAlias2)
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDeclaracao de variaveis                                                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local aReturn 		:= {}
Local _nC9_TOTAL 	:= 0

DBSelectArea(substr(cAlias2,1,3))
DBSetOrder(1)
DBSeek(_cFilial+_cPedido)
While ! (substr(cAlias2,1,3))->(EOF()) .AND. &(cAlias2+"_FILIAL") == _cFilial .AND. &(cAlias2+"_NUM") == _cPedido
	DBSELECTAREA("SB1")
	DBSetOrder(1)
	DBSeek(xFilial()+&(cAlias2+"_PRODUTO"))
	
	DBSELECTAREA("SB2")
	DBSetOrder(1)
	DBSeek(xFilial()+&(cAlias2+"_PRODUTO")+&(cAlias2+"_LOCAL"))
	
	
	nValor1 := &(cAlias2+"_PRCVEN")
	
	nDescperped := Round((100*(1-(nValor1/&(cAlias2+"_PRCVEN")))),3)
	nDescPed  	:= Round((&(cAlias2+"_PRCVEN")-nValor1)*&(cAlias2+"_QTDVEN"),3)
	_nC9_TOTAL	:= &(cAlias2+"_QTDVEN") * &(cAlias2+"_PRCVEN")
	
	AADD(aReturn,{&(cAlias2+"_ITEM"),&(cAlias2+"_PRODUTO"),SB1->B1_DESC,SB1->B1_UM,&(cAlias2+"_QTDVEN"),&(cAlias2+"_PRCVEN"),_nC9_TOTAL,nDescPed,nDescperped})
	(substr(cAlias2,1,3))->(DBskip())
EndDo
Return(aReturn)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณ MAAlcDoc Autor ณ Aline Correa do Vale   ณ  Data ณ07.08.2001ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Controla a alcada dos documentos (SCS-Saldos/SCR-Bloqueios)ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณSintaxe   ณ WFAlcDoc(ExpA1,ExpD1,ExpN1,ExpC1)                     	  ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณParametrosณ ExpA1 = Array com informacoes do documento                 ณฑฑ
ฑฑณ          ณ       [1] Numero do documento                              ณฑฑ
ฑฑณ          ณ       [2] Tipo de Documento                                ณฑฑ
ฑฑณ          ณ       [3] Valor do Documento                               ณฑฑ
ฑฑณ          ณ       [4] Codigo do Aprovador                              ณฑฑ
ฑฑณ          ณ       [5] Codigo do Usuario                                ณฑฑ
ฑฑณ          ณ       [6] Grupo do Aprovador                               ณฑฑ
ฑฑณ          ณ       [7] Aprovador Superior                               ณฑฑ
ฑฑณ          ณ       [8] Moeda do Documento                               ณฑฑ
ฑฑณ          ณ       [9] Taxa da Moeda                                    ณฑฑ
ฑฑณ          ณ      [10] Data de Emissao do Documento                     ณฑฑ
ฑฑณ          ณ      [11] Grupo de Compras                                 ณฑฑ
ฑฑณ          ณ ExpD1 = Data de referencia para o saldo                    ณฑฑ
ฑฑณ          ณ ExpN1 = Operacao a ser executada                           ณฑฑ
ฑฑณ          ณ       1 = Inclusao do documento                            ณฑฑ
ฑฑณ          ณ       2 = Estorno do documento                             ณฑฑ
ฑฑณ          ณ       3 = Exclusao do documento                            ณฑฑ
ฑฑณ          ณ       4 = Aprovacao do documento                           ณฑฑ
ฑฑณ          ณ       5 = Estorno da Aprovacao                             ณฑฑ
ฑฑณ          ณ       6 = Bloqueio Manual da Aprovacao                     ณฑฑ
ฑฑณ          ณ ExpC1 = Respondido a 1 Vez ou a 2						  ณฑฑ
ฑฑณ          ณ ExpB1 = Chamado via Menu do Sistema .T. or .F.             ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso      ณ Generico                                                   ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function AlcDoc2(aDocto,dDataRef,nOper, cWF, lMENU)
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDeclaracao de variaveis                                                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local cDocto	:= aDocto[1]
Local cTipoDoc	:= aDocto[2]
Local cAprov	:= If(aDocto[4]==Nil,"",aDocto[4])
Local cUsuario	:= If(aDocto[5]==Nil,"",aDocto[5])
Local aArea		:= GetArea()
Local aAreaSCR  := SCR->(GetArea())
Local cAuxNivel	:= ""
Local nRec		:= 0
Local lRetorno	:= .T.

dDataRef 	:= dDataBase
cDocto 		:= cDocto+Space(Len(SCR->CR_NUM)-Len(cDocto))
cWF	   		:= IIF(cWF==Nil,  "", cWF)
lMENU  		:= IIF(lMENU==Nil, .F., lMENU)  // SE .T. UTILIZADA VIA MENU DO SISTEMA

IF !lMENU
	CHKFile("SAK")
	CHKFile("SC5")
	CHKFile("SCR")
	CHKFile("SAL")
	CHKFile("SCJ")
	CHKFile("SC6")
	CHKFile("SCK")
ENDIF  

If cTipoDoc == "01"
	cAlias1 := "SCJ->CJ"
ElseIf cTipoDoc == "02"
	cAlias1 := "SC5->C5"
Else         
	Return(.F.)
EndIf	


If nOper == 1  //Inclusao do Documento
EndIf

If nOper == 3  //exclusao do documento
EndIf

If nOper == 4 //Aprovacao do documento
	U_CONSOLE(" 4 -Aprovacao ")
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Libera o pedido pelo aprovador.                     ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	dbSelectArea("SCR")
	cAuxNivel := CR_NIVEL
	
	// SE OPCAO FOR PELO MENU - EXECUTA KILLPROCESS PARA O WF
	IF !EMPTY(SCR->CR_WFID) .AND. lMENU
		WFKillProcess(SCR->CR_WFID)
	ENDIF
	
	U_CONSOLE(" 4 -Aprovacao - CR STATUS = 03")
	
	Reclock("SCR",.F.)
	CR_STATUS	:= "03"
	CR_OBS		:= If(Len(aDocto)>10,aDocto[11],"")
	CR_DATALIB	:= dDataBase
	CR_USERLIB	:= cUsuario
	CR_LIBAPRO	:= cAprov
	//			CR_VALLIB	:= nValDcto
	//			CR_TIPOLIM	:= SAK->AK_TIPO
	MsUnlock()
	
	dbSelectArea("SCR")
	dbSetOrder(1)
	dbSeek(xFilial("SCR")+cTipoDoc+cDocto)
	
	DbSelectArea(subStr(cAlias1,1,3))
	DbSetOrder(1)
	If DbSeek(xFilial(subStr(cAlias1,1,3))+Alltrim(SCR->CR_NUM),.f.)
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณMuda a legenda no pedido de venda                                       ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		DbSelectArea(subStr(cAlias1,1,3))
		RecLock(subStr(cAlias1,1,3),.F.)
		If subStr(cAlias1,1,3) == "SCJ"
			SCJ->CJ_STATUS := "A" 
			SCJ->CJ_STSBLQ := "1"        
		Else
		    SC5->C5_LIBEROK := "S"
		    SC5->C5_STSBLQ := "1"
		EndIf                                   	                                	
		
		MsUnlock()
	EndIf	
	dbSelectArea("SCR") 
	dbSetOrder(1)
	dbSeek(xFilial("SCR")+cTipoDoc+cDocto)
	nRec := RecNo()
	While !Eof() .And. xFilial("SCR")+cDocto== CR_FILIAL+CR_NUM
		If (SCR->CR_TIPO) <> (cTipoDoc)
			dbSkip()
			Loop
		EndIf
		
		U_CONSOLE(" 4 -Aprovacao - LOOP SCR " + CR_FILIAL+CR_NUM+CR_TIPO + CR_NIVEL + CR_STATUS )
		
		If CR_STATUS != "03"
			Reclock("SCR",.F.)
			CR_STATUS := "02"
			MsUnlock()
			Exit
		Endif
		dbSkip()
	EndDo
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Reposiciona e verifica se ja esta totalmente liberado.       ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	U_CONSOLE(" 4 -Aprovacao - Reposiciona e verifica se ja esta totalmente liberado. ")
	
	dbSelectArea("SCR")
	dbGoto(nRec)
	While !Eof() .And. xFilial("SCR")+cDocto == CR_FILIAL+CR_NUM
		If SCR->CR_TIPO <> cTipoDoc
			dbSkip()
			Loop
		EndIf
		
		If CR_STATUS != "03" .And. CR_STATUS != "05"
			lRetorno := .F.
			Exit
		EndIf
		dbSkip()
	EndDo
EndIf

If nOper == 5  //Estorno da Aprovacao
EndIf

If nOper == 6  //Bloqueio manual
	U_CONSOLE("  6  - Bloqueio")
	
	dbSelectArea("SCR")
	cAuxNivel := CR_NIVEL
	
	// SE OPCAO FOR PELO MENU - EXECUTA KILLPROCESS PARA O WF
	IF !EMPTY(SCR->CR_WFID) .AND. lMENU
		WFKillProcess(SCR->CR_WFID)
	ENDIF
	
	U_CONSOLE("  6  - Bloqueio - 04 -STATUS")
	
	Reclock("SCR",.F.)
	CR_STATUS   := "04"
	CR_OBS	    := If(Len(aDocto)>10,aDocto[11],"Reprova็ao manual")
	CR_DATALIB  := dDataBase
	CR_USERLIB	:= SAK->AK_USER
	CR_LIBAPRO	:= SAK->AK_COD
	MsUnlock()
	cNome		:= UsrRetName(SAK->AK_USER)
	
	dbSelectArea("SCR")
	dbSetOrder(1)
	dbSeek(xFilial("SCR")+cTipoDoc+cDocto)
	
	nRec := RecNo()
	While !Eof() .And. xFilial("SCR")+cDocto == CR_FILIAL+CR_NUM
		If SCR->CR_TIPO <> cTipoDoc
			dbSkip()
			Loop
		EndIf
		
		U_CONSOLE(" 6 - Bloqueio - LOOP SCR " + CR_FILIAL+CR_NUM+CR_TIPO + CR_NIVEL + CR_STATUS )
		
		If  CR_STATUS != "04"
			Reclock("SCR",.F.)
			CR_STATUS	:= "04"
			CR_DATALIB	:= dDataBase
			CR_USERLIB	:= SAK->AK_USER
			CR_OBS		:= "Reprovado por " + ALLTRIM(cNome)
			MsUnlock()
			
			// SE OPCAO FOR PELO MENU - EXECUTA KILLPROCESS PARA O WF
			IF !EMPTY(SCR->CR_WFID) .AND. lMENU
				WFKillProcess(SCR->CR_WFID)
			ENDIF
		EndIf
		dbSkip()
	EndDo
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Envia email informando a rejeicao da aprovacao               ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	DbSelectArea("SCR")
	DbSetOrder(1)
	DbSeek(xFilial("SCR")+cTipoDoc+cDocto)
	
	DbSelectArea(subStr(cAlias1,1,3))
	DbSetOrder(1)
	If DbSeek(xFilial(subStr(cAlias1,1,3))+Alltrim(SCR->CR_NUM),.f.)
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณMuda a legenda no orcamento                                     ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		
		DbSelectArea(subStr(cAlias1,1,3))
		RecLock(subStr(cAlias1,1,3),.F.)
		If subStr(cAlias1,1,3) == "SCJ"
			SCJ->CJ_STATUS := "D"                                            	                                	
			SCJ->CJ_STSBLQ := "3"      
		Else
			SC5->C5_LIBEROK := " "                                            	                                	
			SC5->C5_STSBLQ  := "3"
		EndIf                                   	                                	
		MsUnlock()
	
	Endif
	lRetorno := .F.
EndIf

dbSelectArea("SCR")
RestArea(aAreaSCR)
RestArea(aArea)

Return(lRetorno)
                  
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCONSOLE   บAutor  ณMicrosiga           บ Data ณ  08/15/02   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ 
ฑฑบ          ณ 
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function Console(_ctxt)
//local _ctxt

if _ctxt == NIL
	_ctxt := 'nulo'
endif

CONOUT(_cTXT)

nHdl2:= FOPEN("conout.log",2)
IIF(nHdl2 > 0,,nHdl2:=MSFCREATE("conout.log",0))
fseek(nHdl2,0,2)

_cLogBody := ''
_cLogBody += DTOC(DATE()) +" @ "+ TIME() +" "+ _cTxt + chr(13) + chr(10)
Fwrite(nHdl2,_cLogBody,len(_cLogBody))

_cLogBody := replicate('-',80) + chr(13) + chr(10)
Fwrite(nHdl2,_cLogBody,len(_cLogBody))

FCLOSE(nHdl2)
Return



USER FUNCTION SEMAFORO(cArq, nOpc)
Local nHdl, _nCtd
Local cDataTime := Space(30)

IF cArq == Nil .OR. nOpc == Nil
	//    	U_CONSOLE("SEMAFORO - Sem parametros")
	RETURN
ENDIF

IF nOpc == 1	// CRIA
	While .T.
		
		IF !FILE(cArq)
			nHdl:=MSFCREATE(cArq,0)
			cDataTime := DTOC(DATE()) + " " + TIME()
			fWRITE(nHdl,cDataTime,Len(cDataTime))
			FCLOSE(nHdl)
			EXIT
		ENDIF
		
		For _nCtd := 1 TO 1000000
		Next
	END
ENDIF
IF nOpc == 2	// REMOVE
	IF File(cArq)
		fErase(cArq)
	ENDIF
ENDIF
	RETURN 	

