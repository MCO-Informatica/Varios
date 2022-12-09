#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#Include "topconn.ch"

#DEFINE CRLF 	chr(13)+chr(10)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษอออออออออออัออออออออออออออออออออออออออออออออออออออออหออออออัออออออออออออปฑฑ
ฑฑ?Programa  ?IMPARIB                                  ?Data ? 03/11/2018 
บฑ?
ฑฑฬอออออออออออุออออออออออออออออออออออออออออออออออออออออสออออออฯออออออออออออ
นฑฑฑฑ?Autor    Luiz Alberto (3L Systems)
บฑ?
ฑฑฬอออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑ?Descricao ?Rotina para a importa??o do Planilha ARIBA Embraer
ฑฑฬอออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑ?Sintaxe   ?IMPARIB()                                                
บฑ?
ฑฑฬอออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑ?Retorno   ?nil                                                        
บฑ?
ฑฑฬอออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑ?Uso       ?ALLTEC                                                     
บฑ?
ฑฑศอออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function IMPATIV()
Local oGroup
Local oRadio
Local nRadio    := 1
Local aRet		:= {}                                
Local aArea		:= GetArea()
Local cArq      := ""
Local lConv     := .F.
Private aErros  := {}
Private aLog    := {}
Private cArquivo := Space(150)
Private lOk      := .F.
Private bOk      := { || If(ValidaDir(cArquivo), (lOk:=.T.,oDlg:End()) ,) }
Private bCancel  := { || lOk:=.F.,oDlg:End() }
Private lEnd     := .F.

Define MsDialog oDlg Title "Importa็ใo Ativo" From 08,10 To 20,120 Of GetWndDefault()
      
@ 50,16  Say 	"Diretorio:" 	Size 050,10 Of oDlg Pixel
@ 50,40  MsGet 	cArquivo 		Size 230,08 Of oDlg Pixel
@ 50,275 Button "..." 			Size 010,10 Action Eval({|| cArquivo:=SelectFile() }) Of oDlg Pixel

Activate MsDialog oDlg Centered On Init (EnchoiceBar(oDlg,bOk,bCancel))

If lOk
	Processa({|lEnd|U_ImpAti(cArquivo,@lEnd)})
EndIf

RestArea(aArea)

Return 

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษอออออออออออัออออออออออออออออออออออออออออออออออออออออหออออออัออออออออออออปฑฑ
ฑฑ?Programa  ?ImpAti                                 ?Data ?03/11/2018 บฑ?
ฑฑฬอออออออออออุออออออออออออออออออออออออออออออออออออออออสออออออฯออออออออออออนฑฑ
ฑฑ?Autor     ?Luiz Alberto                                               บฑ?
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function ImpAti(cArq, lEnd)
Local aArea		:= GetArea()
Local aTables	:= {}
Local aVetor    := {}
Local aDados    := {}

Local cLinha
Local lGrava    := .T.
Local nTot      := 0
Local nCont     := 1
Local nAtual    := 0
Local nTimeIni  := 0
Local nLinTit   := 2  // Total de linhas do Cabe็alho

Local aCampos 	:= {} 
Local aCoors 	:= MsAdvSize()

Private cCampo   := ""
Private lObrigat := .T.
Private cTipo    := ""
Private nTamanho := 0
Private nDecimal := 0
Private cValida  := ""
Private aValida  := {}
Private aDados   := {}
Private aErro    := {}
Private aErroRpt := {}

If (nHandle := FT_FUse(AllTrim(cArq)))== -1
	Help(" ",1,"NOFILEIMPOR")
	RestArea(aArea)
	Return .F.
EndIf

nTot := FT_FLASTREC()

FT_FGOTOP()

ProcRegua(nTot)
// Tratamento do cabe็alho

lPrimeira := .t.
cError	:=	''
aRet := {'',''}
nPosLinha := 0
While !FT_FEOF()
	IncProc('Aguarde Processando Arquivo...')
	
	nPosLinha++

   	cLinha := FT_FREADLN()  
   	cLinha += ';'
	aCampos := SEPARA(UPPER(cLinha),";",.T.)
	
	If lPrimeira .Or. Empty(aCampos[1])
		lPrimeira := .f.
		Ft_FSkip()
		Loop
	Endif
	
	cCodBem	:=	AllTrim(aCampos[1])

	// Tratamento Campos
	
	aCampos[1]	:=	aCampos[1]	// Codigo Bem
	aCampos[2]	:=	aCampos[2]	// Plaqueta
	aCampos[3]	:=	Upper(aCampos[3])	// Descricao
	aCampos[4]	:=	aCampos[4]	// Grupo
	aCampos[5]	:=	aCampos[5]	// Descricao Sintetica
	aCampos[6]	:=	aCampos[6]	// Depto
	aCampos[7]	:=	Val(aCampos[7])	// Quantidade
	aCampos[8]	:=	StrZero(Val(aCampos[8]),9)	// Nota
	aCampos[9]	:=	PadR(aCampos[9],3)	// Serie
	aCampos[10]	:=	Val(aCampos[10])	// Valor
	aCampos[11]	:=	aCampos[11]	// C.Custo
	aCampos[12]	:=	CtoD(aCampos[12])	// Inicio Depreciacao - Inicio Aquisicao
	aCampos[13]	:=	aCampos[13]	// Conta Contabil
	aCampos[14]	:=	aCampos[14]	// Conta Despesa
	aCampos[15]	:=	Val(aCampos[15])	// Taxa Depreciacao
	aCampos[16]	:=	Val(aCampos[16])	// Tempo
	aCampos[17]	:=	aCampos[17]	// Tipo Conta

	AAdd(aDados,{aCampos[1],;
					aCampos[2],;
					aCampos[3],;
					aCampos[4],;
					aCampos[5],;
					aCampos[6],;
					aCampos[7],;
					aCampos[8],;
					aCampos[9],;
					aCampos[10],;
					aCampos[11],;
					aCampos[12],;
					aCampos[13],;
					aCampos[14],;
					aCampos[15],;
					aCampos[16],;
					aCampos[17]})

	If lEnd
		MsgInfo("Importa็ใo cancelada!","Fim")
		Return .F.
	Endif
	
	Ft_FSkip()
EndDo
FT_FUSE()

If !MsgYesNo("Foram Identificados " + Str(Len(aDados),6) + " a Serem Imporados, Confirma ? ","Aten็ใo")
	RestArea(aArea)
	Return .F.
Endif

//Begin Transaction

ProcRegua(Len(aDados))
For nI := 1 To Len(aDados)
	IncProc("Aguarde Gravando os Dados...")
	
	cCodBem		:=	aDados[nI,1]
	cPlaqueta	:=	aDados[nI,2]	// Plaqueta
	cDescric	:=	Upper(aDados[nI,3])	// Descricao
	cGrupo		:=	aDados[nI,4]	// Grupo
	cDescSint	:=	aDados[nI,5]	// Descricao Sintetica
	cDepto		:=	aDados[nI,6]	// Depto
	nQuantidade	:=	aDados[nI,7]	// Quantidade
	cNota		:=	StrZero(Val(aDados[nI,8]),9)	// Nota
	cSerie		:=	PadR(aDados[nI,9],3)	// Serie
	nValor		:=	aDados[nI,10]	// Valor
	cCusto		:=	aDados[nI,11]	// C.Custo
	dInicio		:=	aDados[nI,12]	// Inicio Depreciacao - Inicio Aquisicao
	cConta		:=	aDados[nI,13]	// Conta Contabil
	cContaD		:=	aDados[nI,14]	// Conta Despesa
	nTaxa		:=	aDados[nI,15]	// Taxa Depreciacao
	nTempo		:=	aDados[nI,16]	// Tempo
	cTipo		:=	aDados[nI,17]	// Tipo Conta


	lInclui := .t.
	If SN1->(dbSetOrder(1), dbSeek(xFilial("SN1")+cCodBem))                                    
		lInclui := .F.
	Endif
	
	If RecLock("SN1",lInclui)
		SN1->N1_FILIAL	:=	xFilial("SN1")
		SN1->N1_CBASE	:=	cCodBem
		SN1->N1_ITEM	:=	'0001'
		SN1->N1_AQUISIC	:=	dInicio
		SN1->N1_DESCRIC	:=	cDescric
		SN1->N1_QUANTD	:=	nQuantidade
		SN1->N1_CHAPA	:=	cPlaqueta
		SN1->N1_NSERIE	:=	cSerie
		SN1->N1_NFISCAL	:=	cNota
		SN1->N1_GRUPO	:=	cGrupo
		SN1->N1_STATUS	:=	'1'
		SN1->N1_INIAVP	:=	dInicio
		SN1->N1_TPAVP	:=	'1'               
		SN1->N1_PATRIM	:=	'N'
		SN1->(MsUnlock())
	Endif
		
	SN3->(dbSetOrder(1), dbSeek(xFilial("SN3")+SN1->N1_CBASE+SN1->N1_ITEM))

	If RecLock("SN3",lInclui)
		SN3->N3_FILIAL	:=	xFilial("SN3")
		SN3->N3_FILORIG	:=	xFilial("SN3")
		SN3->N3_CBASE	:=	cCodBem
		SN3->N3_ITEM	:=	'0001'   
		SN3->N3_SEQ		:=	'001'
		SN3->N3_TIPO	:=	'01'
		SN3->N3_HISTOR	:=	Iif(lInclui,"INCLUSAO",'Alteracao')
		SN3->N3_AQUISIC	:=	dInicio  
		SN3->N3_TPSALDO	:=	'1'
		SN3->N3_TPDEPR	:=	'1'
		SN3->N3_VORIG1	:=	nValor
		SN3->N3_VORIG2	:=	nValor
		SN3->N3_VORIG3	:=	nValor
		SN3->N3_PERDEPR	:=	nTempo
		SN3->N3_TXDEPR1	:=	nTaxa
		SN3->N3_DINDEPR	:=	dInicio
		SN3->N3_CCONTAB	:=	cConta
		SN3->N3_CUSTBEM	:=	cCusto     
		SN3->N3_CCUSTO	:=	cCusto     
		SN3->N3_CDEPREC	:=	cContaD
		SN3->N3_BAIXA	:=	'0'
		SN3->(MsUnlock())
	Endif

Next

// Se Houver Erro Entao Nao Processa
	
If Len(aErro) > 0
	cTxt := ''
	For nErro := 1 To Len(aErro)
		cTxt += aErro[nErro]+CRLF
	Next

	Aviso("Error Log","Erros Encontrados Durante o Processamento: "+CRLF+cTxt,{"Ok"},3)	
	
	MemoWrite('c:\temp\error.log',cTxt)

	If MsgYesNo("[SIM] Cancela a Opera็ใo Com Base nas Diverg๊ncias Apresentadas ou [NรO] Importo Parcialmente, Confirma ? ","Aten็ใo")
		DisarmTransaction()

		RestArea(aArea)
		Return .F.
	Endif
Endif

//End Transaction

If Len(aErro) > 0
	Aviso("Finalizado","Leitura do arquivo realizada com sucesso, Grava็ใo Parcial, Arquivo GERADO em C:\TEMP\ERROR.LOG ",{"Fechar"})
	If MsgYesNo("Deseja Imprimir Log de Erro ? ","Aten็ใo")
		U_ImpErr(aErroRpt)
	Endif
Else
	Aviso("Finalizado","Leitura do arquivo realizada com sucesso ",{"Fechar"})
Endif


RestArea(aArea)
Return .T.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษอออออออออออัออออออออออออออออออออออออออออออออออออออออหออออออัออออออออออออปฑฑ
ฑฑ?Programa  ?SELECTFILE                             ?Data ?10/07/2015 บฑ?
ฑฑฬอออออออออออุออออออออออออออออออออออออออออออออออออออออสออออออฯออออออออออออนฑฑ
ฑฑ?Autor     ?Microsiga                                                  บฑ?
ฑฑฬอออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑ?Descricao ?Rotina para selecao de arquivos CSV para importacao        บฑ?
ฑฑ?          ?                                                           บฑ?
ฑฑฬอออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑ?Sintaxe   ?SELECTFILE()                                               บฑ?
ฑฑฬอออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑ?Retorno   ?cArquivo                                                   บฑ?
ฑฑฬอออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑ?Uso       ?Rede Dor Sใo Luiz                                          บฑ?
ฑฑศอออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function SelectFile()
Local cMaskDir := "Arquivos .CSV (*.CSV) |*.CSV|"
Local cTitTela := "Arquivo para a integracao"
Local lInfoOpen := .T.
Local lDirServidor := .T.
Local cOldFile := cArquivo

cArquivo := cGetFile(cMaskDir,cTitTela,,cArquivo,lInfoOpen, (GETF_LOCALHARD+GETF_NETWORKDRIVE) ,lDirServidor)

If !File(cArquivo)
	MsgStop("Arquivo Nao Existe!")
	cArquivo := cOldFile
Return .F.
EndIf

Return cArquivo

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษอออออออออออัออออออออออออออออออออออออออออออออออออออออหออออออัออออออออออออปฑฑ
ฑฑ?Programa  ?VALIDADIR                              ?Data ?10/07/2015 บฑ?
ฑฑฬอออออออออออุออออออออออออออออออออออออออออออออออออออออสออออออฯออออออออออออนฑฑ
ฑฑ?Autor     ?Microsiga                                                  บฑ?
ฑฑฬอออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑ?Descricao ?Rotina para validacao do diretorio do arquivos CSV a ser   บฑ?
ฑฑ?          ?importado.                                                 บฑ?
ฑฑฬอออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑ?Sintaxe   ?VALIDADIR(cArquivo)                                        บฑ?
ฑฑฬอออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑ?Retorno   ?Logico                                                     บฑ?
ฑฑฬอออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑ?Uso       ?Rede Dor Sใo Luiz                                          บฑ?
ฑฑศอออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ValidaDir(cArquivo)
Local lRet := .T.

If Empty(cArquivo)
	MsgStop("Selecione um arquivo","Aten็ใo")
	lRet := .F.
ElseIf !File(cArquivo)
	MsgStop("Selecione um arquivo vแlido!","Aten็ใo")
	lRet := .F.
EndIf

Return lRet
