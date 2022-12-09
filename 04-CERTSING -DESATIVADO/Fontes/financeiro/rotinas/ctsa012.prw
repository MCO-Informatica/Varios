#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.ch"
#INCLUDE "tbiconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบAtualiz.  ณ Tratamento cartoes Redcard            บData ณ   09/09/11   บฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCTSA012   บAutor  ณOPVSCA (David)      บ Data ณ  14/07/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRealiza a leitura do arquivo CIELO realizar as baixas       บฑฑ
ฑฑบ          ณbancarias                                                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function CTSA012()

Local oDlg											// Dialog para escolha da Lista
Local nOpc		:= 0								// 1 = Ok, 2 = Cancela
Local cFileIn	:= Space(256)
Local cFileOut	:= Space(256)
Local cDirIn	:= Space(256)
Local aDirIn	:= {}  
Local aDirInAux := {}  
Local nI		:= 0
Local cSaida	:= cFileOut
Local cAux		:= ""
Local nHandle	:= -1
Local lRet		:= .F.
Local cTexto	:= ""
Local cArqLog	:= "LOG_ERRO_"+Dtos(DdataBase)+"_"+StrTran(Substr(time(),1,5),":","")+".txt"
Local nContb	:= 0
Local nContOn	:= 0
Local cSomLog	:= ""

DEFINE MSDIALOG oDlg FROM  36,1 TO 160,550 TITLE "Importa็ใo do arquivo de Cart๕es de Cr้dito" PIXEL

@ 10,10 SAY "Dir. Arq. de entrada" OF oDlg PIXEL
@ 10,70 MSGET cDirIn SIZE 200,5 OF oDlg PIXEL

@ 025,10 SAY "Somente LOG" OF oDlg PIXEL
@ 025,70 COMBOBOX oCbox var cSomLog ITEMS {"0=Nใo","1=Sim"} SIZE 40,5 OF oDlg PIXEL 

@ 45,010 BUTTON "File"		SIZE 40,13 OF oDlg PIXEL ACTION CTS012GetDir(@aDirIn,@cDirIn)
@ 45,060 BUTTON "OK"		SIZE 40,13 OF oDlg PIXEL ACTION (nOpc := 1,oDlg:End())
@ 45,230 BUTTON "Cancel"	SIZE 40,13 OF oDlg PIXEL ACTION (nOpc := 2,oDlg:End())

ACTIVATE MSDIALOG oDlg CENTERED

If !nOpc == 1 .or. Empty(cDirIn)
	Return(.F.)
EndIf

If len(aDirIn) = 0 
	MsgAlert("Nใo Foram encontrados Arquivos para processamento!")
	Return(.F.)
EndIf

If !File(cDirIn+cArqLog)
	nHandlog := FCREATE(cDirIn+cArqLog,1)
EndIf

aEval(aDirIn,{|x| aadd(aDirInAux,{x[1],SubStr(x[1],12,2)+SubStr(x[1],10,2)+SubStr(x[1],8,2)+SubStr(x[1],13,3)}) })

Asort( aDirInAux,,, { |x,y| x[2]<y[2] } )

For nI:= 1 to len(aDirInAux)
	cFileIn	:= cDirIn+aDirInAux[nI,1]
	cFileOut:= cFileIn

	CTS012GetFile(@cFileIn,@cFileOut)
	
	If !File(cFileOut)
		nHandle := FCREATE(cFileOut,1)
	Else
		While FERASE(cFileOut)==-1
		End
		nHandle := FCREATE(cFileOut,1)
	Endif
	
	// Esta funcao executa em blinde, pois serแ rodada pelo Schedule
	Processa( { || lRet := CTS012Proc(cFileIn, nHandle, nHandlog, cSomLog) } )
		
	FClose(nHandle)
	
	If !lRet
		cTexto += cFileIn+"- Nใo foi prossํvel processar o arquivo. Verifique log em "+cFileOut+CHR(13)+CHR(10)
	Else
		cTexto += cFileIn+"- Arquivo processado com sucesso. Verifique log em "+cFileOut+CHR(13)+CHR(10)
	Endif
Next

cTexto := "Log do Processamento de Arquivos "+CHR(13)+CHR(10)+cTexto
__cFileLog := MemoWrite(Criatrab(,.f.)+".LOG",cTexto)
DEFINE FONT oFont NAME "Mono AS" SIZE 5,12   //6,15
DEFINE MSDIALOG oDlg TITLE "Processamento Concluํdo" From 3,0 to 340,417 PIXEL
@ 5,5 GET oMemo  VAR cTexto MEMO SIZE 200,145 OF oDlg PIXEL 
oMemo:bRClicked := {||AllwaysTrue()}
oMemo:oFont:=oFont

DEFINE SBUTTON  FROM 153,175 TYPE 1 ACTION oDlg:End() ENABLE OF oDlg PIXEL //Apaga
DEFINE SBUTTON  FROM 153,145 TYPE 13 ACTION (cFile:=cGetFile(cMask,""),If(cFile="",.T.,MemoWrite(cFile,cTexto))) ENABLE OF oDlg PIXEL 

ACTIVATE MSDIALOG oDlg CENTER

Return(.T.)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCTSA01   บAutor  ณMicrosiga           บ Data ณ  01/05/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Obt้m o arquivo.                                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CTS012GetFile(cFileIn, cFileOut)

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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCTSA01   บAutor  ณMicrosiga           บ Data ณ  01/05/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณObt้m o diret๓rio                                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CTS012GetDir(aDirIn,cDirIn)
Local cAux := ""

cDirIn := IIF(!Empty(cAux:=(cGetFile("\", "Diret๓rios", 1,"X:\" ,.F. , GETF_RETDIRECTORY+GETF_LOCALHARD ))),cAux,cDirIn)

aDirIn := Directory(cDirIn+"*.RET")

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCTSA011   บAutor  ณMicrosiga           บ Data ณ  12/10/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Processa a leitura do arquivo.                             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CTS012Proc(cArquivo, nHandle, nHandlog, cSomLog)

Local aCampos		:= {}
Local cArqTmp		:= ""
Local nI			:= 0
Local nRecAtu		:= 0
Local cSql			:= ""
Local cMsgLog		:= ""
Local cCart 		:= ""
Local cAutC 		:= ""
Local cVlrP 		:= ""
Local cParc 		:= ""
Local cProxPrc		:= ""
Local nSaldo		:= 0
Local cDtCpr		:= ""
Local cPv			:= ""
Local cTID			:= ""
Local cStatus		:= ""
Local cDoc          := ""
Local cPedSite      := ""
Default	cArquivo	:= ""

//FWrite(nHandlog, "ERROS DO ARQUIVO  --> " + cArquivo + CRLF )

If !File(cArquivo)
	cMsgLog := alltrim(cArquivo)+";Arquivo de entrada nใo localizado " + CRLF
	FWrite(nHandle, cMsgLog )
	FWrite(nHandlog, cMsgLog )
	Return(.F.)
Endif

If cSomLog = "1"
	cMsgLog := alltrim(cArquivo)+";*** ROTINA PROCESSADA APENAS PARA SIMPLES CONFERENCIA DE LOG. NENHUM DADO FOI ALTERADO ***"  + CRLF
	FWrite(nHandle, cMsgLog )
	FWrite(nHandlog, cMsgLog )
Endif

ProcRegua( 0 )
Incproc( "Abrindo arquivo:... "+AllTrim(cArquivo) )
ProcessMessage()

Aadd( aCampos, {"TMP_VISA",	"C", 400, 0} )
cArqTmp := CriaTrab(aCampos,.T.)
dbUseArea( .T.,,cArqTmp, "TMPVISA", .F., .F. )
APPEND FROM &(cArquivo) SDF
DbGoTop()

If TMPVISA->( Eof() )
	TMPVISA->( DbCloseArea() )
	cMsgLog := alltrim(cArquivo)+"Arquivo invalido ou vazio..." + CRLF
	FWrite(nHandle, cMsgLog )
	FWrite(nHandlog, cMsgLog )
	Return(.F.)
Endif

ProcRegua( TMPVISA->( RecCount() ) )

//Begin Transaction
cBanco  :=''
cAgencia:=''
cConta  :='' //Serแ passado em branco para que a fun็ใo CCBAIFIN identifique a conta de acordo com a faixa de n๚mera็ใo e cart๕es.

While TMPVISA->( !Eof() )
	
	Incproc( "Importando Registro "+AllTrim(Str(nRecAtu++))+" Arquivo:... "+AllTrim(cArquivo) )
	
	ProcessMessage()
	
	If Empty(TMPVISA->TMP_VISA)
		cMsgLog :=  alltrim(cArquivo)+";"+AllTrim(Str(nRecAtu))+";Linha do arquivo em branco." + CRLF
		FWrite(nHandle, cMsgLog  )
		FWrite(nHandlog, cMsgLog )
		TMPVISA->( DbSkip() )
		Loop                		
	Endif
	
	If SubStr(TMPVISA->TMP_VISA,1,1) == "0"
	    
		//Verifica a bandeira do cartao.
		If SubStr(TMPVISA->TMP_VISA,150,3)=='   ' //3 espa็os em branco, bandeira VISA
		
				MsgAlert("A posi็ใo 150 da primeira linha do arquivo estแ vazia. Verifique se ้ um arquivo de Baixa Cielo. Nesta posi็ใo deve existir o c๓digo 001 para visa ou 999 para outras bandeiras")
				TMPVISA->( DbCloseArea() )
				cMsgLog := alltrim(cArquivo)+" Layout de arquivo invแlido..." + CRLF
				FWrite(nHandle, cMsgLog )
				FWrite(nHandlog, cMsgLog )
				Return(.F.)
		EndIf
		cConta:=IIF( SubStr(TMPVISA->TMP_VISA,150,3)=='001', "VISA","REDECARD")		
		 
	ElseIf SubStr(TMPVISA->TMP_VISA,1,1) == "1"
	
		cDtBx 	:= "20"+SubStr(TMPVISA->TMP_VISA,45,6)	   //Data prevista de pagamento
		cStatus	:= SubStr(TMPVISA->TMP_VISA,150,1)	       //Status de opera็ใo, "C" indica uma opera็ใo de cartใo de cr้dito.
	
	ElseIf SubStr(TMPVISA->TMP_VISA,1,1) == "2"
				
		cPv		:= SubStr(TMPVISA->TMP_VISA,2,10)   //numero do estabelecimento de venda
		cCart 	:= SubStr(TMPVISA->TMP_VISA,19,16)  //numero do cartao, se for compra e-commerce ้ uma string de zeros.
		cDtCpr	:= SubStr(TMPVISA->TMP_VISA,38,8)   //data da compra
		cTipReg	:= iif(SubStr(TMPVISA->TMP_VISA,46,1)== "-" ,'C','B')   //identificador do tipo de baixa. C (-) por cancelamento, B (+) 
		cVlrP 	:= SubStr(TMPVISA->TMP_VISA,47,13)  //valor de compra, se parcelado, valor da parcela
		cParc 	:= SubStr(TMPVISA->TMP_VISA,60,2)   // o numero da parcela atual, zero ้ venda a vista
		cProxPrc:= SubStr(TMPVISA->TMP_VISA,62,2)   // Total de parcelas, zero ้ venda a vista
		cAutC 	:= SubStr(TMPVISA->TMP_VISA,94,6)  	//Codigo de autenticacao
		cTID	:= SubStr(TMPVISA->TMP_VISA,100,20) //ID da transacao para compras e-commerce.
		cDoc    := iif(SubStr(TMPVISA->TMP_VISA,46,1)== "-" ,' ',SubStr(TMPVISA->TMP_VISA,140,6))//Numero do documento//Nใo tem numero de documento para Cancelamentos. Apenas codigo de autoriza็ใo
		nSaldo	:= Val(cVlrP) / 100
		
		If cStatus == "C"					
			lRet := U_CCBAIFIN(cCart,cAutC,cVlrP,cParc,cDtCpr,nSaldo,cDtBx,cTipReg,nHandle,nHandlog,nil,nRecAtu,cSomLog,alltrim(cArquivo),cPv,cTID,nil,cConta,cDoc,cPedSite)
		Else
			//Tratar outros tipos de venda, por exemplo Cartใo de D้bito.
			cMsgLog :=  alltrim(cArquivo)+";"+AllTrim(Str(nRecAtu))+";Linha do arquivo nใo se refere a Cr้dito" + CRLF
			FWrite(nHandle, cMsgLog  )
			FWrite(nHandlog, cMsgLog )			
		EndIf			   	 	
	EndIf
	
	TMPVISA->( DbSkip() )
End

TMPVISA->( DbCloseArea() )

//End Transaction

Return(.T.)