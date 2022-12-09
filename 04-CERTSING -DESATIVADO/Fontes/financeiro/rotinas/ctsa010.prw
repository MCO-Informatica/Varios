#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCTSA010   บAutor  ณArmando M. Tessaroliบ Data ณ  04/02/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRealiza a leitura do arquivo CNAB para conciliar as baixas  บฑฑ
ฑฑบ          ณbancarias com as validacoes enviadas pelo GAR.              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function CTSA010()

Local oDlg											// Dialog para escolha da Lista
Local nOpc		:= 0								// 1 = Ok, 2 = Cancela
Local cFileIn	:= Space(256)
Local cFileOut	:= Space(256)
Local nI		:= 0
Local cSaida	:= cFileOut
Local cAux		:= ""
Local nHandle	:= -1
Local lRet		:= .F.

DEFINE MSDIALOG oDlg FROM  36,1 TO 160,550 TITLE "Importa็ใo do arquivo CNAB de retorno ITAU para concilia็ใo bancแria." PIXEL

@ 10,10 SAY "Arquivo de entrada" OF oDlg PIXEL
@ 10,70 MSGET cFileIn SIZE 200,5 OF oDlg PIXEL

@ 25,10 SAY "Arquivo de saํda " OF oDlg PIXEL
@ 25,70 MSGET cFileOut SIZE 200,5 OF oDlg PIXEL READONLY

@ 45,010 BUTTON "File"		SIZE 40,13 OF oDlg PIXEL ACTION CTS010GetFile(@cFileIn,@cFileOut)
@ 45,060 BUTTON "OK"		SIZE 40,13 OF oDlg PIXEL ACTION (nOpc := 1,oDlg:End())
@ 45,230 BUTTON "Cancel"	SIZE 40,13 OF oDlg PIXEL ACTION (nOpc := 2,oDlg:End())

ACTIVATE MSDIALOG oDlg CENTERED

If !nOpc == 1
	Return(.F.)
EndIf

If !File(cFileOut)
	nHandle := FCREATE(cFileOut,1)
Else
	While FERASE(cFileOut)==-1
	End
	nHandle := FCREATE(cFileOut,1)
Endif

// Esta funcao executa em blinde, pois serแ rodada pelo Schedule
Processa( { || lRet := CTS010Proc(cFileIn, nHandle) } )

FClose(nHandle)

If !lRet
	MsgStop("Nใo foi prossํvel processar o arquivo." + CRLF + "Verifique log em "+cFileOut)
Else
	MsgStop("Arquivo processado com sucesso." + CRLF + "Verifique log em "+cFileOut)
Endif

Return(.T.)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCTSA010   บAutor  ณMicrosiga           บ Data ณ  01/05/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CTS010GetFile(cFileIn, cFileOut)

Local cAux := ""

cFileIn := IIF(!Empty(cAux:=(cGetFile("*.RET", "Arquivos", 1, "X:\", .F., GETF_LOCALHARD))),cAux,cFileIn)

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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCTSA010   บAutor  ณMicrosiga           บ Data ณ  12/10/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CTS010Proc(cArquivo, nHandle)

Local aCampos		:= {}
Local cArqTmp		:= ""
Local nI			:= 0
Local nRecAtu		:= 0
Local cPedGar		:= ""
Local dDatMov		:= CtoD("//")
Local nValCred		:= 0
Local nValDesc		:= 0

Default	cArquivo	:= ""

If !File(cArquivo)
	FWrite(nHandle, "Arquivo de entrada nใo localizado --> " + cArquivo + CRLF )
	Return(.F.)
Endif

ProcRegua( 0 )
Incproc( "Abrindo arquivo..." )
ProcessMessage()

Aadd( aCampos, {"TMP_CNAB",	"C", 400, 0} )
cArqTmp := CriaTrab(aCampos,.T.)
dbUseArea( .T.,,cArqTmp, "TMP", .F., .F. )
APPEND FROM &(cArquivo) SDF
DbGoTop()

If TMP->( Eof() )
	TMP->( DbCloseArea() )
	FWrite(nHandle, "Arquivo invalido ou vazio..." + CRLF )
	Return(.F.)
Endif

ProcRegua( TMP->( RecCount() ) )

While TMP->( !Eof() )
	
	Incproc( "Importando Registro "+AllTrim(Str(nRecAtu++)) )
	ProcessMessage()
	
	If Empty(TMP->TMP_CNAB)
		FWrite(nHandle, AllTrim(Str(nRecAtu))+" ---> Linha do arquivo em branco." + CRLF )
		TMP->( DbSkip() )
		Loop
	Endif
	
	If !Empty(SubStr(TMP->TMP_CNAB,117,9))
		FWrite(nHandle, AllTrim(Str(nRecAtu))+" ---> Posi็ใo da linha de 117 a 125 nใo vazia " + SubStr(TMP->TMP_CNAB,117,9) + CRLF )
		TMP->( DbSkip() )
		Loop
	Endif
	
	cPedGar := Padr(SubStr(TMP->TMP_CNAB,129,6),10)
	
	If Empty(cPedGar)
		FWrite(nHandle, AllTrim(Str(nRecAtu))+" ---> Pedido do GAR nใo informado no arquivo de retorno" + CRLF )
		TMP->( DbSkip() )
		Loop
	Endif
	
	//SE1->( DbSetOrder(23) )
	SE1->(DbOrderNickName("SE1_23"))//Alterado por LMS em 03-01-2013 para virada
	If SE1->( !MsSeek( xFilial("SE1")+cPedGar+"RA" ) )
		FWrite(nHandle, AllTrim(Str(nRecAtu))+" ---> Tํtulo no SE1 nใo localizado para o pedido GAR " + cPedGar + CRLF )
		TMP->( DbSkip() )
		Loop
	Endif
	
	SE5->( DbSetOrder(7) )		// E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ
	If SE5->( !MsSeek( xFilial("SE5")+SE1->(E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO) ) )
		FWrite(nHandle, AllTrim(Str(nRecAtu))+" ---> Movimento bancแrio no SE5 nใo localizado para o pedido GAR " + cPedGar + CRLF )
		TMP->( DbSkip() )
		Loop
	Endif
	
	dDatMov		:= CtoD( SubStr(TMP->TMP_CNAB,111,2)+"/"+SubStr(TMP->TMP_CNAB,113,2)+"/"+SubStr(TMP->TMP_CNAB,115,2) )
	nValCred	:= Val( SubStr(TMP->TMP_CNAB,254,13) ) / 100
	nValDesc	:= Val( SubStr(TMP->TMP_CNAB,176,13) ) / 100
	
	If Empty(dDatMov)
		FWrite(nHandle, AllTrim(Str(nRecAtu))+" ---> Data do movimento bancแrio nใo informado" + CRLF )
		TMP->( DbSkip() )
		Loop
	Endif
	
	If nValCred == 0
		FWrite(nHandle, AllTrim(Str(nRecAtu))+" ---> Valor do cr้dito no movimento bancแrio nใo informado" + CRLF )
		TMP->( DbSkip() )
		Loop
	Endif
	
	If SE5->E5_VALOR <> nValCred+nValDesc
		FWrite(nHandle, AllTrim(Str(nRecAtu))+" ---> Valor do sistema (" + AllTrim(Str(SE5->E5_VALOR)) + ") diferente do valor do banco (" + AllTrim(Str(nValCred+nValDesc)) + ")" + CRLF )
		TMP->( DbSkip() )
		Loop
	Endif
	
	FWrite(nHandle,	"ORIGINAL --->" +;
					"     TITULO " + SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO) +;
					"     E5_DTDISPO " + DtoC(SE5->E5_DTDISPO) +;
					"     E5_RECONC " + SE5->E5_RECONC +;
					CRLF )
	
	SE5->( RecLock("SE5", .F.) )
	SE5->E5_DTDISPO	:= dDatMov
	SE5->E5_RECONC	:= "x"
	SE5->( MsUnLock( ) )
	
	FWrite(nHandle,	"ALTERADO --->" +;
					"     TITULO " + SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO) +;
					"     E5_DTDISPO " + DtoC(SE5->E5_DTDISPO) +;
					"     E5_RECONC " + SE5->E5_RECONC +;
					CRLF )
	
	TMP->( DbSkip() )
End
TMP->( DbCloseArea() )

Return(.T.)
