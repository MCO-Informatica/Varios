#INCLUDE "PROTHEUS.CH"


User Function EICGI400()

Local cParam:= ""

Local xRet := .T.

IF Type("ParamIXB") == "C"
	cParam:= upper(PARAMIXB)
Else
	cParam:= upper(PARAMIXB[1])
Endif

if  cParam == 'ANTESMAALCDOC'
	//-----------------------------------------------------
	//Ponto de entrada antes do acionamento do controle de
	//alçadas do SIGAEIC
	//-----------------------------------------------------
	
	lValidAlc := .F.
	
Endif


IF CEMPANT == '02'
	
	if cParam == "VALIDA_PLI"
		
		xRet := U_LISTAWORK()
		
	Endif
	
Endif

Return xRet


User Function LISTAWORK()
Local lRet := .T.
Local aWorkPE := GetArea()

WORK->(dbGoTop())
While WORK->(!Eof())
	
	cNumAI 	:= Posicione( "SB1", 1, xFilial( "SB1" ) + WORK->WKCOD_I , "B1_XAIMP" )
	
	IF cNumAI == '1'
		
		IF EMPTY(M->W4_XNUMAI) .or. EMPTY(M->W4_XDTAI)
			
			cMSGT := "Autorizaçã de Importação - EICGI400"
			
			cMSG := "O Produto "+WORK->WKCOD_i+" exige o numero da Autorização de Importação."+CRLF
			cMSG += 	"Prencher os campos [Dt Autor Imp] e [Data Aut IMP], na Capa da PLI antes de prosseguir."
			
			MsgInfo(cMSG,cMSGT)
			
			lRet := .F.
			
		ENDIF
		
	ENDIF
	
	WORK->(dbSkip())
EndDo

Restarea(aWorkPE)

Return(lRet)
