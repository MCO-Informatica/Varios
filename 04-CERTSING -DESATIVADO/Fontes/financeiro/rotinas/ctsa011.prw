#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CTSA011   �Autor  �David de Oliveira   � Data �  13/07/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �Realiza a leitura do arquivo CNAB para conciliar as baixas  ���
���          �bancarias com as validacoes enviadas pelo GAR.              ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function CTSA011()

Local oDlg											// Dialog para escolha da Lista
Local nOpc		:= 0								// 1 = Ok, 2 = Cancela
Local cFileIn	:= Space(256)
Local cFileOut	:= Space(256)
Local cDirIn	:= Space(256)
Local aDirIn	:= {}
Local nI		:= 0
Local cSaida	:= cFileOut
Local cAux		:= ""
Local nHandle	:= -1
Local lRet		:= .F.
Local cTexto	:= ""
Local cArqLog	:= "LOG_ERRO_"+Dtos(DdataBase)+StrTran(Substr(time(),1,5),":","_")+".txt"

DEFINE MSDIALOG oDlg FROM  36,1 TO 160,550 TITLE "Importa��o do arquivo CNAB de retorno ITAU para concilia��o banc�ria." PIXEL

@ 10,10 SAY "Dir. Arq. de entrada" OF oDlg PIXEL
@ 10,70 MSGET cDirIn SIZE 200,5 OF oDlg PIXEL

@ 45,010 BUTTON "File"		SIZE 40,13 OF oDlg PIXEL ACTION CTS011GetDir(@aDirIn,@cDirIn)
@ 45,060 BUTTON "OK"		SIZE 40,13 OF oDlg PIXEL ACTION (nOpc := 1,oDlg:End())
@ 45,230 BUTTON "Cancel"	SIZE 40,13 OF oDlg PIXEL ACTION (nOpc := 2,oDlg:End())

ACTIVATE MSDIALOG oDlg CENTERED

If !nOpc == 1 
	Return(.F.)
EndIf

If len(aDirIn) = 0 
	MsgAlert("N�o Foram encontrados Arquivos para processamento!")
	Return(.F.)
EndIf

If !File(cDirIn+cArqLog)
	nHandlog := FCREATE(cDirIn+cArqLog,1)
EndIf

For nI:= 1 to len(aDirIn)
	cFileIn	:= cDirIn+aDirin[nI,1]
	cFileOut:= cFileIn

	CTS011GetFile(@cFileIn,@cFileOut)
	
	If !File(cFileOut)
		nHandle := FCREATE(cFileOut,1)
	Else
		While FERASE(cFileOut)==-1
		End
		nHandle := FCREATE(cFileOut,1)
	Endif
	
	// Esta funcao executa em blinde, pois ser� rodada pelo Schedule
	Processa( { || lRet := CTS011Proc(cFileIn, nHandle, nHandlog) } )
		
	FClose(nHandle)
	
	If !lRet
		cTexto += cFileIn+"- N�o foi pross�vel processar o arquivo. Verifique log em "+cFileOut+CHR(13)+CHR(10)
	Else
		cTexto += cFileIn+"- Arquivo processado com sucesso. Verifique log em "+cFileOut+CHR(13)+CHR(10)
	Endif
Next

cTexto := "Log do Processamento de Arquivos "+CHR(13)+CHR(10)+cTexto
__cFileLog := MemoWrite(Criatrab(,.f.)+".LOG",cTexto)
DEFINE FONT oFont NAME "Mono AS" SIZE 5,12   //6,15
DEFINE MSDIALOG oDlg TITLE "Processamento Conclu�do" From 3,0 to 340,417 PIXEL
@ 5,5 GET oMemo  VAR cTexto MEMO SIZE 200,145 OF oDlg PIXEL 
oMemo:bRClicked := {||AllwaysTrue()}
oMemo:oFont:=oFont

DEFINE SBUTTON  FROM 153,175 TYPE 1 ACTION oDlg:End() ENABLE OF oDlg PIXEL //Apaga
DEFINE SBUTTON  FROM 153,145 TYPE 13 ACTION (cFile:=cGetFile(cMask,""),If(cFile="",.T.,MemoWrite(cFile,cTexto))) ENABLE OF oDlg PIXEL 


ACTIVATE MSDIALOG oDlg CENTER

Return(.T.)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CTSA01   �Autor  �Microsiga           � Data �  01/05/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function CTS011GetFile(cFileIn, cFileOut)

Local cAux := ""

cFileIn := Lower(AllTrim(cFileIn))

If Upper(SubStr(cFileIn,Len(cFileIn)-2,3)) <> "RET"
	cFileIn  := Space(256)
	cFileOut := Space(256)
	Return(.F.)
Endif

cFileIn  := PadR(Upper(cFileIn),256)
cFileOut := PadR(StrTran(cFileIn,"RET","LOG"),256)

Return(.T.)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CTSA01   �Autor  �Microsiga           � Data �  01/05/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function CTS011GetDir(aDirIn,cDirIn)
Local cAux := ""

cDirIn := IIF(!Empty(cAux:=(cGetFile("\", "Diret�rios", 1,"X:\" ,.F. , GETF_RETDIRECTORY+GETF_LOCALHARD ))),cAux,cDirIn)

aDirIn := Directory(cDirIn+"*.RET")

Return(.T.)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CTSA011   �Autor  �Microsiga           � Data �  12/10/09   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function CTS011Proc(cArquivo, nHandle, nHandlog)

Local aCampos		:= {}
Local cArqTmp		:= ""
Local nI			:= 0
Local nRecAtu		:= 0
Local cPedGar		:= ""
Local dDatMov		:= CtoD("//")
Local nValCred		:= 0
Local nValDesc		:= 0
Local cSql			:= ""
Local cMsgLog		:= ""

Default	cArquivo	:= ""

FWrite(nHandlog, "ERROS DO ARQUIVO  --> " + cArquivo + CRLF )

If !File(cArquivo)
	cMsgLog := "Arquivo de entrada n�o localizado --> " + cArquivo + CRLF
	FWrite(nHandle, cMsgLog )
	FWrite(nHandlog, cMsgLog )
	Return(.F.)
Endif

ProcRegua( 0 )
Incproc( "Abrindo arquivo:... "+AllTrim(cArquivo) )
ProcessMessage()

Aadd( aCampos, {"TMP_CNAB",	"C", 400, 0} )
cArqTmp := CriaTrab(aCampos,.T.)
dbUseArea( .T.,,cArqTmp, "TMP", .F., .F. )
APPEND FROM &(cArquivo) SDF
DbGoTop()

If TMP->( Eof() )
	TMP->( DbCloseArea() )
	cMsgLog := "Arquivo invalido ou vazio..." + CRLF
	FWrite(nHandle, cMsgLog )
	FWrite(nHandlog, cMsgLog )
	Return(.F.)
Endif

ProcRegua( TMP->( RecCount() ) )

While TMP->( !Eof() )
	
	Incproc( "Importando Registro "+AllTrim(Str(nRecAtu++))+" Arquivo:... "+AllTrim(cArquivo) )
	ProcessMessage()
	
	If Empty(TMP->TMP_CNAB)
		cMsgLog :=  AllTrim(Str(nRecAtu))+" ---> Linha do arquivo em branco." + CRLF
		FWrite(nHandle, cMsgLog  )
		FWrite(nHandlog, cMsgLog )
		TMP->( DbSkip() )
		Loop
	Endif
	
	If !Empty(SubStr(TMP->TMP_CNAB,117,9))
		cMsgLog := AllTrim(Str(nRecAtu))+" ---> Posi��o da linha de 117 a 125 n�o vazia " + SubStr(TMP->TMP_CNAB,117,9) + CRLF
		FWrite(nHandle,cMsgLog )
		FWrite(nHandlog, cMsgLog )
		TMP->( DbSkip() )
		Loop
	Endif
	
	cPedGar := Padr(SubStr(TMP->TMP_CNAB,129,6),10)
	
	If SubStr(TMP->TMP_CNAB,1,1) = "1" .AND. !SubStr(TMP->TMP_CNAB,109,2) $ "06,07,08"
		cMsgLog := AllTrim(Str(nRecAtu))+" ---> Ocorr�ncia CNAB diferente de Liquida��o. PEDGAR "+cPedGar+ CRLF
		FWrite(nHandle, cMsgLog )
		FWrite(nHandlog, cMsgLog )
		TMP->( DbSkip() )
		Loop	
	EndIf
	
	If Empty(cPedGar)
		cMsgLog := AllTrim(Str(nRecAtu))+" ---> Pedido do GAR n�o informado no arquivo de retorno" + CRLF
		FWrite(nHandle, cMsgLog )
		FWrite(nHandlog, cMsgLog )
		TMP->( DbSkip() )
		Loop
	Endif
	
	//SE1->( DbSetOrder(23) )
	SE1->(DbOrderNickName("SE1_23"))//Alterado por LMS em 03-01-2013 para virada
	If SE1->( !MsSeek( xFilial("SE1")+cPedGar+"RA" ) )
		cMsgLog := AllTrim(Str(nRecAtu))+" ---> T�tulo no SE1 n�o localizado para o pedido GAR " + cPedGar + CRLF
		FWrite(nHandle, cMsgLog )
		FWrite(nHandlog, cMsgLog )
		TMP->( DbSkip() )
		Loop
	Endif
	
	cSql := " SELECT R_E_C_N_O_ RECTAB "
	cSql += " FROM "+RetSqlName("SE5")+" "
	cSql += " WHERE E5_FILIAL =  '"+xFilial("SE5")+"' AND "	
	cSql += " E5_PREFIXO = '"+SE1->E1_PREFIXO+"' AND "
	cSql += " E5_NUMERO = '"+SE1->E1_NUM+"' AND "
	cSql += " E5_PARCELA = '"+SE1->E1_PARCELA+"' AND "
	cSql += " E5_TIPO = '"+SE1->E1_TIPO+"' AND "
	cSql += " E5_TIPODOC = 'RA' AND "	
	cSql += " E5_MOTBX = 'NOR' AND "	
	cSql += " D_E_L_E_T_ = ' ' "	

	If select("TMPE5") > 0
		TMPE5->(DbCloseArea())				
	EndIf

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),"TMPE5",.F.,.T.)	

	If TMPE5->(Eof()) 
		cMsgLog := AllTrim(Str(nRecAtu))+" ---> Movimento banc�rio no SE5 n�o localizado para o pedido GAR " + cPedGar + CRLF
		FWrite(nHandle, cMsgLog ) 
		FWrite(nHandlog, cMsgLog )
		TMP->( DbSkip() )
		Loop
	Else
		SE5->(DbGoTo(TMPE5->RECTAB))
	Endif

	dDatMov		:= CtoD( SubStr(TMP->TMP_CNAB,111,2)+"/"+SubStr(TMP->TMP_CNAB,113,2)+"/"+SubStr(TMP->TMP_CNAB,115,2) )
	nValCred	:= Val( SubStr(TMP->TMP_CNAB,254,13) ) / 100
	nValDesc	:= Val( SubStr(TMP->TMP_CNAB,176,13) ) / 100
	
	If Empty(dDatMov)
		cMsgLog := AllTrim(Str(nRecAtu))+" ---> Data do movimento banc�rio n�o informado" + CRLF
		FWrite(nHandle, cMsgLog )
		FWrite(nHandlog, cMsgLog )
		TMP->( DbSkip() )
		Loop
	Endif
	
	If SubStr(SE5->E5_HISTOR,1,9) = "(DTDISPO-" .OR. SE5->E5_DTDISPO = dDatMov
		cMsgLog := AllTrim(Str(nRecAtu))+" ---> Titulo "+SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO)+" ja Processado na data "+DtoC(SE5->E5_DTDISPO)+" PEDGAR "+cPedGar+ CRLF
		FWrite(nHandle, cMsgLog )
		FWrite(nHandlog, cMsgLog )
		TMP->( DbSkip() )
		Loop	
	EndIF	
	
	If nValCred == 0
		cMsgLog := AllTrim(Str(nRecAtu))+" ---> Valor do cr�dito no movimento banc�rio n�o informado" + CRLF
		FWrite(nHandle, cMsgLog )
		FWrite(nHandlog, cMsgLog )
		TMP->( DbSkip() )
		Loop
	Endif
	
	If SE5->E5_VALOR <> nValCred+nValDesc
		cMsgLog := " Valor do sistema (" + AllTrim(Str(SE5->E5_VALOR)) + ") diferente do valor do banco (" + AllTrim(Str(nValCred+nValDesc)) + ") para o t�tulo " +SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO)+ ". Mas o processo de ajuste realizado."  +CRLF
		FWrite(nHandle, cMsgLog )
	Endif
	
	FWrite(nHandle,	"ORIGINAL --->" +;
					"     TITULO " + SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO) +;
					"     HISTORICO "+AllTrim(SE5->E5_HISTOR) +;
					"     E5_DTDISPO " + DtoC(SE5->E5_DTDISPO) +;
					"     E5_RECONC " + SE5->E5_RECONC +;
					"     PEDGAR " + cPedGar +;
					CRLF )
	
	SE5->( RecLock("SE5", .F.) )
	SE5->E5_HISTOR	:= "(DTDISPO-"+DtoC(SE5->E5_DTDISPO)+")"+SE5->E5_HISTOR
	SE5->E5_DTDISPO	:= dDatMov
	SE5->E5_RECONC	:= "x"
	SE5->( MsUnLock( ) )
	
	FWrite(nHandle,	"ALTERADO --->" +;
					"     TITULO " + SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO) +;
					"     HISTORICO "+AllTrim(SE5->E5_HISTOR) +;					
					"     E5_DTDISPO " + DtoC(SE5->E5_DTDISPO) +;
					"     E5_RECONC " + SE5->E5_RECONC +;
					"     PEDGAR " + cPedGar +;
					CRLF )
	
	TMP->( DbSkip() )
End
TMP->( DbCloseArea() )

Return(.T.)