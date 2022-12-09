#INCLUDE "TOTVS.CH"
#INCLUDE 'RWMAKE.CH'
//21/11/2017 - Alterações junior virada P12
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AFAT008   º Autor ³ Giane - ADV Brasil º Data ³  04/01/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Rotina para montar a impressao do orcamento e enviar por   º±±
±±º          ³ email ao cliente.                                          º±±
±±º          ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Específico MAKENI / orcamento - callcenter                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
//Chamada da rotina pelo botão
User Function AFAT008()
Local aArea    := GetArea()
Local nomef		:= STRTRAN(SUBSTR(posicione("SA1",1,XFILIAL("SA1")+SCJ->CJ_CLIENTE+SCJ->CJ_LOJA,"ALLTRIM(A1_NREDUZ)"),1,14),' ','_')
Private LIMP :=  !IsInCallStack("A415IMPRI")

IF LIMP
	if MsgYesNo( "Enviar email do Orçamento "+SCJ->CJ_NUM+"?","AFAT008" )
		cEmail := Alltrim(SCJ->CJ_XMAILCO)
		if empty(cEmail)
			MSGBOX( "Orçamento não possui email do contato do Cliente! Email não enviado." )
			return
		endif
		
		if MsgYesNo( "Deseja abrir o Serviço de Email?","AFAT008" )
			//EMAILORC(SUA->UA_NUM, .F. ,nomef)
			EMAILORC(SCJ->CJ_NUM, .F. ,nomef,cEmail)
		else
			if !EMAILORC( SCJ->CJ_NUM, .T.,nomef,cEmail )
				MSGBOX( "O Sistema não conseguiu enviar o email. Verifique as configurações ou utilize o Serviço de Email?" )
			endif
		endif
	endif
else
	EMAILORC(SCJ->CJ_NUM, .F. ,nomef, '')
endif

RestArea(aArea)
Return

//Efetivar o envio para o outlook
Static Function EmailOrc( cNumOrc, lAutomatico,cNomeF,cEmail )
Local aArea    := GetArea()
Local lRet     := .T.
Local cDirDoc  := "c:\temp\"
Local cNomeArq := "Orc-" + cNumOrc+"-"+cNomeF+ ".pdf"
Local cFile    := cDirDoc + cNomeArq //"c:\temp\Orc-" + cNumOrc+"-"+cNomeF+ ".pdf"
Local aAttach := {}
Local cAssunto := ""

Private lBlind := .F.

if lAutomatico == NIL
	lAutomatico := .F.
endif

MsgRun("Processando orçamento no word, aguarde...","",{|| U_RFAT040(cNumOrc ,.t., cNomeF) })

If .not. (File (cFile))
	//Copy File TERMO.DOC to ( cAnex )
	MSGBOX( "Erro na geracao do documento word! Email não enviado." )
	return .f.
Endif

if LIMP
	
	if lAutomatico //Só envia a mensagem

        cAssunto := 'Emissão de Orçamento - '+cNumOrc
        cTextoEmail := 'Segue anexo o Orçamento Nr. ' + cNumOrc 

		cFolder := 'word\temp'

        CpyT2S( cDirDoc+cNomeArq, cFolder )
        
        cFolder +="\"+cNomeArq

		Aadd(aAttach,cFolder)

	    lRet := U_ENVMAILIMCD(cEmail," "," ",cAssunto,cTextoEmail,aAttach)

	Else //utiliza-se do outlook
		
		U_ABRENOTES( cEmail+Chr(59) , {cFile}, "", "Orçamento%20-%20"+SM0->M0_NOMECOM )
		
	endif
else
	nRet := ShellExecute("open", cNomeArq , "", cDirDoc, 1)
	
	//Se houver algum erro
	If nRet <= 32
		MsgStop("Não foi possível abrir o arquivo " +cDirDoc+cNomeArq+ "!", "Atenção")
	EndIf
EndIf
RestArea(aArea)
Return( lRet )
