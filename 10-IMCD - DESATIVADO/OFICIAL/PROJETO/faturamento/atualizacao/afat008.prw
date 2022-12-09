#INCLUDE "TOTVS.CH"
#INCLUDE 'RWMAKE.CH'
//21/11/2017 - Altera��es junior virada P12
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �AFAT008   � Autor � Giane - ADV Brasil � Data �  04/01/10   ���
�������������������������������������������������������������������������͹��
���Descricao � Rotina para montar a impressao do orcamento e enviar por   ���
���          � email ao cliente.                                          ���
���          �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Espec�fico MAKENI / orcamento - callcenter                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
//Chamada da rotina pelo bot�o
User Function AFAT008()
Local aArea    := GetArea()
Local nomef		:= STRTRAN(SUBSTR(posicione("SA1",1,XFILIAL("SA1")+SCJ->CJ_CLIENTE+SCJ->CJ_LOJA,"ALLTRIM(A1_NREDUZ)"),1,14),' ','_')
Private LIMP :=  !IsInCallStack("A415IMPRI")

IF LIMP
	if MsgYesNo( "Enviar email do Or�amento "+SCJ->CJ_NUM+"?","AFAT008" )
		cEmail := Alltrim(SCJ->CJ_XMAILCO)
		if empty(cEmail)
			MSGBOX( "Or�amento n�o possui email do contato do Cliente! Email n�o enviado." )
			return
		endif
		
		if MsgYesNo( "Deseja abrir o Servi�o de Email?","AFAT008" )
			//EMAILORC(SUA->UA_NUM, .F. ,nomef)
			EMAILORC(SCJ->CJ_NUM, .F. ,nomef,cEmail)
		else
			if !EMAILORC( SCJ->CJ_NUM, .T.,nomef,cEmail )
				MSGBOX( "O Sistema n�o conseguiu enviar o email. Verifique as configura��es ou utilize o Servi�o de Email?" )
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

MsgRun("Processando or�amento no word, aguarde...","",{|| U_RFAT040(cNumOrc ,.t., cNomeF) })

If .not. (File (cFile))
	//Copy File TERMO.DOC to ( cAnex )
	MSGBOX( "Erro na geracao do documento word! Email n�o enviado." )
	return .f.
Endif

if LIMP
	
	if lAutomatico //S� envia a mensagem

        cAssunto := 'Emiss�o de Or�amento - '+cNumOrc
        cTextoEmail := 'Segue anexo o Or�amento Nr. ' + cNumOrc 

		cFolder := 'word\temp'

        CpyT2S( cDirDoc+cNomeArq, cFolder )
        
        cFolder +="\"+cNomeArq

		Aadd(aAttach,cFolder)

	    lRet := U_ENVMAILIMCD(cEmail," "," ",cAssunto,cTextoEmail,aAttach)

	Else //utiliza-se do outlook
		
		U_ABRENOTES( cEmail+Chr(59) , {cFile}, "", "Or�amento%20-%20"+SM0->M0_NOMECOM )
		
	endif
else
	nRet := ShellExecute("open", cNomeArq , "", cDirDoc, 1)
	
	//Se houver algum erro
	If nRet <= 32
		MsgStop("N�o foi poss�vel abrir o arquivo " +cDirDoc+cNomeArq+ "!", "Aten��o")
	EndIf
EndIf
RestArea(aArea)
Return( lRet )
