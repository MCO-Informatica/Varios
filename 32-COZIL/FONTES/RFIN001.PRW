/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRFIN001   บAutor  ณCarlos Eduardo      บ Data ณ  26/11/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณServe para imprimir as duplicatas de venda mercantil de acorบฑฑ
ฑฑบ          ณcom o layout definido do arquivo Duplicata.Dot              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Cozil                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
#include "RWMAKE.CH"
#include "MSOLE.CH"
User Function RFIN001()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณInicia variaveis locaisณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local aSays    := {}
Local aButtons := {}
Local nOpca    := {}
Local aRegs    := {}
Local cTitoDlg := "Impressใo de Duplicatas"
Local cperg    := "RFIN01"
Local I, J

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVerifica as perguntasณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
DbSelectArea("SX1")
DbSetOrder(1)
DbGoTop()
If !DbSeek( cPerg )
	aAdd(aRegs,{cPerg,"01","Prefixo da Duplicata"	,"","","mv_ch1","C",3,00,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"02","Numero"		,"","","mv_ch2","C",9,00,0,"G","","MV_PAR02","","","","","","","","","","","","","","","","","","","","SE1","","","","",""})

	For I := 1 To Len( aRegs )
		If !DbSeek( cPerg + aRegs[ I, 2 ] )
			RecLock( "SX1", .T. )
			For J := 1 To FCount()
				If J <= Len( aRegs[ I ] )
					FieldPut( J, aRegs[ I, J ] )
				EndIf
			Next
			MsUnLock()
		EndIf
	Next
Endif


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณMonta interface para o usuarioณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
aAdd( aSays, "Esta rotina tem como objetivo gerar a impressใo de Duplicatas de acordo" )
aAdd( aSays, "com os paramentros informados pelo usuแrio. Utiliza documento .DOT como" )
aAdd( aSays, "padrใo." )

aAdd( aButtons, {5, .T., { |o| Pergunte( cPerg, .T. ) } } )
aAdd( aButtons, {1, .T., { |o| nOpca := 1, FechaBatch() } } )
aAdd( aButtons, {2, .T., { |o| nOpca := 2, FechaBatch() } } )

FormBatch( cTitoDlg, aSays, aButtons )
If nOpca == 1
	Pergunte( cPerg, .F. )
	Processa( {|| RFIN001OK( "Processando Tํtulos do Financeiro. Aguarde..." ) } )
EndIf
Return()

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ RFIN001OKบAutor  ณCarlos Eduardo      บ Data ณ  26/11/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Efetua a geracao do relatorio.                             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Cozil                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function RFIN001OK()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณInicia variaveis locaisณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local cPatch  := ""
Local cQuery  := ""
Local cAlias  := Alias()
Local oWord   := Nil

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณInicia as variaveis utilizadas na integracao com o MS-WORDณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local	dEmissao	:= ""
Local	cNumDoc		:= ""
Local	cSaldo 		:= ""
Local	cParcela	:= ""
Local	cVencREa	:= ""
Local	cNomEmp 	:= ""
Local	cEndEmp 	:= ""
Local	cMunici		:= ""
Local	cEstado		:= ""
Local	cTel		:= ""
Local	cFax		:= ""
Local	cBairro		:= ""
Local	cCarteira	:= ""
Local 	cBancoAGCTA	:= ""
Local	cCNPJ		:= ""
Local	cInscEst	:= ""
Local	cExtenso	:= ""
Local	cCounter	:= 0
Local	aDados		:= {}

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณMonta diretorio de trabalhoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

//VERIFICA EMPRESA DE ORIGEM

	Do Case 
		Case xEmpresa() == "01"
			cPatch := "DUPLICATA_COZIL_EQUIPAMENTOS.dot"
		Case xEmpresa() == "02"
			cPatch := "DUPLICATA_COZIL_COZINHAS.dot"
		Case xEmpresa() == "03"
			cPatch := "DUPLICATA_COZILANDIA.dot"
	End Case

alert(cPatch)

MontaDir( "C:\MSIGA\" )  												//Cria na estacao local diretorio de trabalho
__CopyFile( "\SYSTEM\WORD\" + cPatch, "C:\MSIGA\" + cPatch )  		//Copia o arquivo para o diretorio local

//PREENCHE COM CAMINHO COMPLETO
cPatch := "C:\MSIGA\" + cPatch

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณEfetua busca do primeiro tํtuloณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
DbSelectArea("SE1")
DbSetOrder(1)
DbGoTop()
If !DbSeek( xFilial("SE1") + MV_PAR01 + MV_PAR02, .F. )
	Aviso( "Duplicata", "Duplicata nใo localizada. Rever parametros", { "Ok" }, 2 )
	DbSelectArea( cAlias )
	Return
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณLoop de processamento( Cabecalho da NF )ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If DbSeek( xFilial("SE1") + MV_PAR01 + MV_PAR02, .F. )
	DbSelectArea("SA1")
	DbSetOrder(1)
	DbGoTop()
	DbSeek( xFilial("SA1") + SE1->( E1_CLIENTE + E1_LOJA ), .F. )
	
	//Inclui Mascara para o Numero do CNPJ
	If	SA1->A1_TIPO == "J"
		cMCNPJ 		:= Transform(SA1->A1_CGC , "@E 99.999.999/9999-99" )
	Else
		cMCNPJ 		:= Transform(SA1->A1_CGC , " @R 99.999.999-99" )
	Endif
	
	//Inclui Mascara para o numero da Inscricao Estadual
	If Alltrim(SA1->A1_INSCR) <> 'ISENTO' .Or. Alltrim(SA1->A1_INSCR) <> ''
		cMInsc	:= Transform(SA1->A1_INSCR, "@E 999.999.999")
	Else
		cMInsc	:= "ISENTO"
	Endif
	
	//Carrega variaveis de integracao com o MS-WORD
	dEmissao	:= Dtoc(SE1->E1_EMISSAO)
	cNumDoc		:= SE1->E1_NUM
	cSaldo 		:= "R$ " + Alltrim(Transform( SE1->E1_VALOR, "@E 999,999,999,999.99"))
	cParcela	:= SE1->E1_PARCELA
	cVencREa	:= Dtoc(SE1->E1_VENCREA)
	cNomEmp 	:= SA1->A1_NOME
	cEndEmp 	:= Alltrim( SA1->A1_END ) + " - " + Alltrim( SA1->A1_BAIRRO )
	cMunici		:= Alltrim( SA1->A1_MUN )
	cEstado		:= SA1->A1_EST
	cCEP		:= Transform(SA1->A1_CEP , " @R 9999.999" )
	cTel		:= "(" + SA1->A1_DDD + ")" + Transform(SA1->A1_TEL , " @R 9999.9999" )
	cBairro		:= SA1->A1_BAIRRO
	cFax		:= "(" + SA1->A1_DDD + ")" + Transform(SA1->A1_FAX , " @R 9999.9999" )
	cCNPJ		:= cMCNPJ
	cInscEst	:= cMInsc
	cExtenso	:= "( "+ Extenso(SE1->E1_VALOR,.F.,1) + " )"
	cHistorico	:= SE1->E1_HIST
	
	// Defino o Tipo de Carteira do Tํtulo
	If SE1->E1_PORTADO = "   "
		cCarteira 	:= "Duplicata em Carteira"
		cBancoAGCTA	:= " "
	Else
		cCarteira	:= "Cobran็a Bancแria"
		cBancoAGCTA := "Boleto Bancแrio. Banco " + SE1->E1_PORTADO + " Agencia "+ SE1->E1_AGEDEP + " Conta " + SE1->E1_CONTA
	Endif
	
	DbSelectArea("SE1")
Endif

//Efetua geracao do Documento
OLE_CloseLink()
oWord := OLE_CreateLink()
OLE_NewFile( oWord, cPatch )


// Gera Impressใo com dados do tํtulo
OLE_SetDocumentVar( oWord, "EMISSAO"	, dEmissao 		)
OLE_SetDocumentVar( oWord, "FATURA"		, cNumDoc 		)
OLE_SetDocumentVar( oWord, "SALDO" 		, cSaldo		)
OLE_SetDocumentVar( oWord, "DUPLIC"		, cParcela		)
OLE_SetDocumentVar( oWord, "VENCREA"	, cVencRea		)

//Gera Impressใo com dados do Sacado
OLE_SetDocumentVar( oWord, "NOMEMP"		, cNomEmp		)
OLE_SetDocumentVar( oWord, "ENDEMP"		, cEndEmp 		)
OLE_SetDocumentVar( oWord, "CEP"		, cCEP	 		)
OLE_SetDocumentVar( oWord, "TEL"		, cTel	 		)
OLE_SetDocumentVar( oWord, "BAIRRO"		, cBairro 		)
OLE_SetDocumentVar( oWord, "FAX"		, cFax	 		)
OLE_SetDocumentVar( oWord, "MUNICI"		, cMunici 		)
OLE_SetDocumentVar( oWord, "ESTADO"		, cEstado 		)
OLE_SetDocumentVar( oWord, "CARTEIRA"	, cCarteira		)
OLE_SetDocumentVar( oWord, "BANCO"		, cBancoAGCTA	)
OLE_SetDocumentVar( oWord, "CARTEIRA"	, cCarteira		)
OLE_SetDocumentVar( oWord, "CNPJ"		, cCNPJ			)
OLE_SetDocumentVar( oWord, "INSCEST"	, cMInsc		)
OLE_SetDocumentVar( oWord, "EXTENSO"	, cExtenso		)
OLE_SetDocumentVar( oWord, "HISTORICO"	, cHistorico	)


OLE_UpDateFields(oWord )
OLE_SetProperty	(oWord, '208', .T.)
//OLE_PrintFile	(oWord ,"ALL",,,1)
//OLE_SaveFile 	(oWord, "\system\Duplicata.doc")
//OLE_CloseLink	(oWord )

DbSelectArea( cAlias )
Return
