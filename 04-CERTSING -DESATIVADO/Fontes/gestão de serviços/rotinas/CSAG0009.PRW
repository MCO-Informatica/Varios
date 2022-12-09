#include "Protheus.Ch"
#include "MSOle.Ch"
#include "OLE.CH"
#include "fileio.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCSAG0009   บAutor Claudio H. Corr๊a    บ Data ณ  08/01/2016 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณImpressใo OS em PDF                                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ3
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CERTISIGN                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

#define OLECREATELINK  400
#define OLECLOSELINK   401
#define OLEOPENFILE    403
#define OLESAVEASFILE  405
#define OLECLOSEFILE   406
#define OLESETPROPERTY 412
#define OLEWDVISIBLE   "206"
#define WDFORMATTEXT   "2"
#define oleWdFormatDocument "0"
#define oleWdFormatHTML "102"
#define oleWdFormatPDF "17"

User Function CSAG0009()
	Local nOpc := 0

	Private cCadastro := "Gera็ใo de Ordem de Servi็o"
	Private aSay := {}
	Private aButton := {}

	aAdd( aSay, "Gerar a Ordem de Servi็o referente ao atendimento externo." )

	aAdd( aButton, { 1,.T.,{|| nOpc := 1,FechaBatch()}})
	aAdd( aButton, { 2,.T.,{|| FechaBatch() }} )

	FormBatch( cCadastro, aSay, aButton )

	If nOpc == 1
		Processa( {|| ImpWord() }, cCadastro, "Processando..." )
	Endif
Return .T.

Static Function ImpWord()
	Local oWord := Nil
	Local cFileOpen := ""
	Local cFileSave := ""
	Local cPedido := ""
	Local cCond := ""
	Local cPICTURE := "@E 99,999,999.99"
	Local aPARAM := {}
	Local aRET := {}
	Local aPA1 := {}
	Local aPa1Total := {}
	Local nTOTAL := 0
	Local nI := 0
	Local nSaida := 0
	Local aSaida := {'1-Imprimir','2-Salvar formato PDF'}
	Local cMainPath 
	
	Local cOrigem := 'system\agendamento\os.dot'
	Local cTempPath := GetTempPath()
	Local cTemplate := ''
	Local lCopy := .F.
	Local nCheck := 0
	
	AAdd( aPARAM, { 2, "Qual saํda", 1, aSaida, 80, "", .F. } )
	
	If ParamBox(aPARAM,"Parโmetros",@aRET)
	
		nSaida := Iif( ValType( aRet[ 1 ] ) == 'N', aRet[ 1 ], AScan( aSaida, {|e| e==aRet[ 1 ] } ) )
		
	Endif
	
	//------------------------------------------------
	// Capturar o arquivo no seu armazenamento padrใo.
	If .NOT. File( cOrigem )
		MsgAlert('Nใo serแ possํvel continuar, nใo foi localizado o arquivo modelo (template).',cCadastro)
		Return
	Endif
	//----------------------------------------------------------------------
	// Copiar o arquivo do servidor para o temporแrio do usuแrio do windows.
	CpyS2T( cOrigem, cTempPath, .T.)
	Sleep(500)	
	//--------------------------------------------------------------------------------
	// Formar o endere็o para onde foi copiado template word no temporแrio do usuแrio.
	cTemplate := cTempPath + SubStr( cOrigem, RAt( '\',cOrigem )+1 )
	//----------------------------------------------------
	// Verifcar at้ cinco vezes se o template foi copiado.
	While ((.NOT. lCopy) .And. (nCheck <= 5))
		If File( cTemplate )
			lCopy := .T.
		Else
			nCheck++
			CpyS2T( cOrigem, cTempPath, .T. )
			Sleep(500)
		Endif
	End
	//-------------------------------------------------------------------	
	// Se nใo conseguiu copiar o arquivo, nใo seguir com o processamento.
	If .NOT. lCopy
		MsgAlert('Nใo foi possํvel compiar o arquivo modelo (template) para o diret๓rio temporแrio da esta็ใo/usuแrio.', cCadastro )
		Return
	Endif
	//-------------------------------------------------------------------------------------------
	// Atribuir o endere็o a variแvel que jแ estแ sendo utilizada nos demais trechos do programa.
	cFileOpen := cTemplate
	
	/*
	cStartPath := GetSrvProfString("Rootpath","")
	cFileOpen := cStartPath+"\system\agendamento\Os.dot"
	cMainPath := cStartPath+"\system\agendamento\"
	If !File(cFileOpen)
		MsgInfo("Arquivo nใo localizado",cCadastro)
		Return
	Endif
	FT_FUse("cFileOpen")
	*/
	
	cPedido := PA0->PA0_OS

	dbSelectArea("PA0")
	dbSetOrder(1)
	If !dbSeek( xFilial("PA0") + cPedido )
		MsgInfo("OS nใo encontrada",cCadastro)
		Return
	Endif

	dbSelectArea("PA1")
	dbSetOrder(1)
	dbSeek( xFilial("PA1") + PA0->PA0_OS )

	While !EOF() .And. PA1->( PA1_FILIAL + PA1_OS ) == xFilial("PA0") + PA0->PA0_OS 
	
		IF PA1->PA1_FATURA == "F"
		
			aAdd( aPA1, { 	PA1_ITEM, ;
								Posicione("SB1",1,xFilial("SB1")+PA1_PRODUT,"B1_DESC"), ;
								LTrim(TransForm(PA1_QUANT,cPICTURE)), ;
								LTrim(TransForm(PA1_PRCUNI,cPICTURE)), ;
								LTrim(TransForm(PA1_VALOR,cPICTURE)), ;
								Ltrim(TransForm(PA1_CNPJ, iif(len(PA1_CNPJ)==12,"@R 999.999.999.999","@R 99.999.999/9999-99"))), ;
								PA1_PEDIDO,;
								PA1_PRODUT } )
								
		ELSE
		
			nTOTAL += PA1->PA1_VALOR
			
		End If
			
		dbSkip()
	End

	If Len( aPA1 ) == 0
		MsgInfo("Nใo foi possํvel ler os itens da OS",cCadastro)
		Return
	Endif

	// Criar o link do Protheus com o Word.
	oWord := OLE_CreateLink()

	// Cria um novo baseado no modelo.
	OLE_NewFile( oWord, cFileOpen )

	// Exibe ou oculta a janela da aplicacao Word no momento em que estiver descarregando os valores.
	OLE_SetProperty( oWord, oleWdVisible, .F. )

	// Exibe ou oculta a aplicacao Word.
	OLE_SetProperty( oWord, oleWdPrintBack, .T. )

	// Atribui os valores as variแveis.
	OLE_SetDocumentVar( oWord, 'w_PA0_CLLCNO'    , PA0->PA0_CLLCNO  )
	OLE_SetDocumentVar( oWord, 'w_PA0_NMCONT', POSICIONE("SU5", 1,xFilial("SU5")+PA0->PA0_CONTAT,"U5_CONTAT" ))
	OLE_SetDocumentVar( oWord, 'w_PA0_OS', PA0->PA0_OS )
	OLE_SetDocumentVar( oWord, 'w_PA0_END', PA0->PA0_END )
	OLE_SetDocumentVar( oWord, 'w_PA0_COMPLE', PA0->PA0_COMPLE )
	OLE_SetDocumentVar( oWord, 'w_PA0_BAIRRO', PA0->PA0_BAIRRO )
	OLE_SetDocumentVar( oWord, 'w_PA0_CEP', PA0->PA0_CEP )
	OLE_SetDocumentVar( oWord, 'w_PA0_CIDADE', PA0->PA0_CIDADE )
	OLE_SetDocumentVar( oWord, 'w_PA0_ESTADO', PA0->PA0_ESTADO )
	OLE_SetDocumentVar( oWord, 'w_PA0_DDD', PA0->PA0_DDD )
	OLE_SetDocumentVar( oWord, 'w_PA0_TEL', PA0->PA0_TEL )
	OLE_SetDocumentVar( oWord, 'w_PA0_DTAGEN', dtoc(PA0->PA0_DTAGEN))
	OLE_SetDocumentVar( oWord, 'w_PA0_HRAGEN'  , PA0->PA0_HRAGEN )
	OLE_SetDocumentVar( oWord, 'w_PA0_CONAGE'  , PA0->PA0_CONAGE )
	OLE_SetDocumentVar( oWord, 'w_PA0_PREVAL'  , PA0->PA0_PREVAL )
	OLE_SetDocumentVar( oWord, 'w_TOTAL'  , STR(nTOTAL, 7, 2))
	OLE_SetDocumentVar( oWord, 'w_NumItens'  , LTrim( Str( Len( aPA1 ) ) ) )
	OLE_SetDocumentVar( oWord, 'w_PA0_OBS'  , PA0->PA0_OBS )

	For nI := 1 To Len( aPA1 )
		OLE_SetDocumentVar( oWord, 'w_PA1_PEDIDO'   + LTrim(Str(nI)), aPA1[nI,7] )
		OLE_SetDocumentVar( oWord, 'w_PA1_PRODUT'	+ LTrim(Str(nI)), aPA1[nI,8] )
		OLE_SetDocumentVar( oWord, 'w_PA1_DESCRI'   + LTrim(Str(nI)), aPA1[nI,2] )
		OLE_SetDocumentVar( oWord, 'w_PA1_CNPJ' 	+ LTrim(Str(nI)), aPA1[nI,6] )
	Next nI

	// Executa a macro do Word.
	OLE_ExecuteMacro( oWord , "tabitens" )

	// Atualiza todos os campos.
	OLE_UpDateFields( oWord )
	
	If nSaida <> 4
	
		cFileSave := cTempPath
		
		If nSaida == 1
			// 1-Imprimir
			// Ativa ou desativa impressao em segundo plano. (opcional)
			OLE_SetProperty( oWord, oleWdPrintBack, .T. )
			//Caso fosse parcial a impressใo informar o intervalo e trocar ALL por PART.
			OLE_PrintFile( oWord, 'ALL', /*pag_inicial*/, /*pag_final*/, /*Num_Vias*/ )
			// Esperar 2 segundos para imprimir.
			Sleep( 2000 )
		Else
			If nSaida == 2
				// 3-Salvar formato PDF
				OLE_SaveAsFile( oWord, cFileSave+"\"+PA0->PA0_OS+".pdf",'','',.F.,oleWdFormatPDF )
				shellExecute( "Open", cFileSave+"\"+PA0->PA0_OS+".pdf", " /k dir","C:\" , 1 )
				//shellExecute( "Open", 'PA0->PA0_OS'+".pdf", " /k dir", , 1 )		
				Sleep(1000)
			Endif
			// Fecha o documento.
			OLE_CloseFile( oWord )
		Endif
	Endif
	// Fechar o link com a aplica็ใo.
	OLE_CloseLink( oWord ) 
	
	// Apagar o arquivo modelo (template) do diret๓rio temporแrio da esta็ใo/usuแrio.
	If File( cTemplate )
		FERASE(cFileSave+PA0->PA0_OS+".doc")
		FERASE(cFileSave+PA0->PA0_OS+".pdf")
		FERASE(cFileSave+PA0->PA0_OS+".htm")
		FERASE(cFileSave+"os"+".dot")
		Sleep( 1000 )
	Endif
Return