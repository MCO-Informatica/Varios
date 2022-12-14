/*???????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????ͻ??
???Programa  ?RFIN001   ?Autor  ?Carlos Eduardo      ? Data ?  26/11/10   ???
?????????????????????????????????????????????????????????????????????????͹??
???Desc.     ?Serve para imprimir as duplicatas de venda mercantil de acor???
???          ?com o layout definido do arquivo Duplicata.Dot              ???
?????????????????????????????????????????????????????????????????????????͹??
???Uso       ? Cozil                                                      ???
?????????????????????????????????????????????????????????????????????????ͼ??
?????????????????????????????????????????????????????????????????????????????
???????????????????????????????????????????????????????????????????????????*/
#include "RWMAKE.CH"
#include "MSOLE.CH"
User Function RFIN001()

//???????????????????????Ŀ
//?Inicia variaveis locais?
//?????????????????????????
Local aSays    := {}
Local aButtons := {}
Local nOpca    := {}
Local aRegs    := {}
Local cTitoDlg := "Impress?o de Duplicatas"
Local cperg    := "RFIN01"
Local I, J

//?????????????????????Ŀ
//?Verifica as perguntas?
//???????????????????????
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


//??????????????????????????????Ŀ
//?Monta interface para o usuario?
//????????????????????????????????
aAdd( aSays, "Esta rotina tem como objetivo gerar a impress?o de Duplicatas de acordo" )
aAdd( aSays, "com os paramentros informados pelo usu?rio. Utiliza documento .DOT como" )
aAdd( aSays, "padr?o." )

aAdd( aButtons, {5, .T., { |o| Pergunte( cPerg, .T. ) } } )
aAdd( aButtons, {1, .T., { |o| nOpca := 1, FechaBatch() } } )
aAdd( aButtons, {2, .T., { |o| nOpca := 2, FechaBatch() } } )

FormBatch( cTitoDlg, aSays, aButtons )
If nOpca == 1
	Pergunte( cPerg, .F. )
	Processa( {|| RFIN001OK( "Processando T?tulos do Financeiro. Aguarde..." ) } )
EndIf
Return()

/*???????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????ͻ??
???Programa  ? RFIN001OK?Autor  ?Carlos Eduardo      ? Data ?  26/11/10   ???
?????????????????????????????????????????????????????????????????????????͹??
???Desc.     ? Efetua a geracao do relatorio.                             ???
???          ?                                                            ???
?????????????????????????????????????????????????????????????????????????͹??
???Uso       ? Cozil                                                      ???
?????????????????????????????????????????????????????????????????????????ͼ??
?????????????????????????????????????????????????????????????????????????????
???????????????????????????????????????????????????????????????????????????*/
Static Function RFIN001OK()

//???????????????????????Ŀ
//?Inicia variaveis locais?
//?????????????????????????
Local cPatch  := ""
Local cQuery  := ""
Local cAlias  := Alias()
Local oWord   := Nil

//??????????????????????????????????????????????????????????Ŀ
//?Inicia as variaveis utilizadas na integracao com o MS-WORD?
//????????????????????????????????????????????????????????????
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

//?????????????????????????????
//?Monta diretorio de trabalho?
//?????????????????????????????

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

//???????????????????????????????Ŀ
//?Efetua busca do primeiro t?tulo?
//?????????????????????????????????
DbSelectArea("SE1")
DbSetOrder(1)
DbGoTop()
If !DbSeek( xFilial("SE1") + MV_PAR01 + MV_PAR02, .F. )
	Aviso( "Duplicata", "Duplicata n?o localizada. Rever parametros", { "Ok" }, 2 )
	DbSelectArea( cAlias )
	Return
EndIf

//????????????????????????????????????????Ŀ
//?Loop de processamento( Cabecalho da NF )?
//??????????????????????????????????????????
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
	
	// Defino o Tipo de Carteira do T?tulo
	If SE1->E1_PORTADO = "   "
		cCarteira 	:= "Duplicata em Carteira"
		cBancoAGCTA	:= " "
	Else
		cCarteira	:= "Cobran?a Banc?ria"
		cBancoAGCTA := "Boleto Banc?rio. Banco " + SE1->E1_PORTADO + " Agencia "+ SE1->E1_AGEDEP + " Conta " + SE1->E1_CONTA
	Endif
	
	DbSelectArea("SE1")
Endif

//Efetua geracao do Documento
OLE_CloseLink()
oWord := OLE_CreateLink()
OLE_NewFile( oWord, cPatch )


// Gera Impress?o com dados do t?tulo
OLE_SetDocumentVar( oWord, "EMISSAO"	, dEmissao 		)
OLE_SetDocumentVar( oWord, "FATURA"		, cNumDoc 		)
OLE_SetDocumentVar( oWord, "SALDO" 		, cSaldo		)
OLE_SetDocumentVar( oWord, "DUPLIC"		, cParcela		)
OLE_SetDocumentVar( oWord, "VENCREA"	, cVencRea		)

//Gera Impress?o com dados do Sacado
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
