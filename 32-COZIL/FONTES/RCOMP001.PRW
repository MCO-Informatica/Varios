/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPEDIDO_DOTบAutor  William Luiz Antunes Gurzoni   09/12/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFaz a impressใo do pedido de compra utilizando um arquivo   บฑฑ
ฑฑบ          ณmodelo (.dot)                                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Pedido de compra                                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

#include "RWMAKE.CH"
#include "MSOLE.CH"
User Function RCOMP0001()

	//ณInicia variaveis locais     
	Local aSays    := {}
	Local aButtons := {}
	Local nOpca    := {}
	Local aRegs    := {}
	Local cTitoDlg := "Impressใo - Pedido de Compra"
	Local cperg    := "RCOM001"
	Local I, J 

/*
	//ณVerifica as perguntas
	DbSelectArea("SX1")
	DbSetOrder(1)
	//DbGoTop()
	If !DbSeek( cPerg )
		aAdd(aRegs,{cPerg,"01","Pedido"		,"","","mv_ch1","C",9,00,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","",""})
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
*/	
	//ณMonta interface para o usuarioณ
	
	aAdd( aSays, "Esta rotina tem como objetivo gerar a impressใo de Pedidos de acordo" )
	aAdd( aSays, "com os paramentros informados pelo usuแrio. Utiliza documento .DOT como" )
	aAdd( aSays, "padrใo." )
	
	aAdd( aButtons, {5, .T., { |o| Pergunte( cPerg, .T. ) } } )
	aAdd( aButtons, {1, .T., { |o| nOpca := 1, FechaBatch() } } )
	aAdd( aButtons, {2, .T., { |o| nOpca := 2, FechaBatch() } } )
    
	
	FormBatch( cTitoDlg, aSays, aButtons )
	If nOpca == 1
		Pergunte( cPerg, .F. )
		Processa( {|| COMP0002( "Processando pedido. Aguarde..." ) } )
	EndIf
	Return()
	
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPEDIDO_DOTบAutor  William Luiz Antunes Gurzoni   12/03/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ    Gera o relatorio                                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Pedido de compra                                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
	
Static Function COMP0002()

//DADOS DO CABECALHO DO PEDIDO
	Local	cNum			:= ""
	Local	dEmissao		:= ""
	Local 	cCodFornece		:= ""
	Local 	cNomFornece		:= ""
	Local 	cEndFornece		:= ""
	Local 	cBairroFornece	:= ""
	Local 	cMunFornece		:= ""    
	Local	cUFFornece		:= "" 
	Local 	cDDDFornece		:= ""
	Local 	cTelFornece		:= ""
	Local	cFaxFornece		:= ""
	Local 	cCEPFornece		:= ""
	Local	cContatoFornece	:= ""
	Local 	cCgcFornece		:= ""
	Local 	cInscrFornece	:= ""
	Local 	dEmissao		:= ""
	Local  	cCondPagto  	:= ""
	Local	cTipoFrete		:= ""
	Local	nValFre			:= 0   
	Local	cComprador	:= ""
		                     
//VARIAVEIS DOS ITENS
	Local nCont 	:= 1 //Conta o numero na linha atual
	Local aItem		:= {}
	Local aCodProd	:= {}
	Local aUn		:= {}
	Local aDescri	:= {}
	Local aQuant	:= {}
	Local aPreco	:= {}
	Local aTotal	:= {}
	Local aDatPrf	:= {}
	Local aICMS		:= {}
	Local aIPI		:= {}
	Local aValIPI	:= {}
	Local aValFre	:= {}
	Local aTotDesc	:= {}    //Desconto p/ item 
	Local aICMSRet	:= {}	 //ICMS Retido
	
//OBSERVACOES
	Local aObs		:= {}
	
//VARIAVEIS DAS TOTALIZACOES
	Local nTotalGeral 	:= 0
	Local nTotalICMS	:= 0
	Local nValIPI		:= 0
	Local nTotalCImp	:= 0
	Local nTotDesc		:= 0
	Local nICMSRet		:= 0

//VARIAVEIS DO DOCUMENTO
	Local oWord   	:= Nil
	Local nItens	:= 0
	Local cPatch	:= ""       
	
//VERIFICA EMPRESA DE ORIGEM

	Do Case 
		Case xEmpresa() == "01"
			cDoc := "PEDIDO_COMPRA_EQUIPAMENTOS_2012_09.DOT"
		Case xEmpresa() == "02"
			cDoc := "PEDIDO_COMPRA_COZINHAS_2012_09.DOT"
		Case xEmpresa() == "03"
			cDoc := "PEDIDO_COMPRA_COZILANDIA_2012_09.DOT"
	End Case
   	
//ATRIBUI LOCAL DO DOCUMENTO
	cPatch		:= "C:\msiga\modword\" + cDoc	
	
//BUSCA PEDIDO
	DbSelectArea("SC7")
	DbSetOrder(1)
	//DbGoTop()  
	If !DbSeek(xFilial() + mv_par01)                               
		Aviso( "Erro", "Pedido nใo encontrado.", { "Ok" }, 2 )
		//DbSelectArea( cAlias )
		Return
	EndIf  
	
//GERA DADOS DO CABECALHO DO PEDIDO
	cNum 		:= SC7->C7_NUM 
	cCodFornece	:= SC7->C7_FORNECE  
	dEmissao	:= SC7->C7_EMISSAO
	cCondPagto	:= SC7->C7_COND
	cTipoFrete	:= SC7->C7_TPFRETE
	cComprador	:= AllTrim(SC7->C7_XCOMPRA)
	
//BUSCA DADOS DO FORNECEDOR
	DbSelectArea("SA2")
	DbSetOrder(1)
	//DbGoTop()
	If !DbSeek( xFilial("SA2") + cCodFornece ) 
		  alert("Fornecedor nใo Encontrado.")
		  return()
	EndIf
	
	cNomFornece 	:= cCodFornece + " - " + SA2->A2_NOME 
 	cEndFornece		:= SA2->A2_END
 	cBairroFornece	:= SA2->A2_BAIRRO
 	cMunFornece		:= SA2->A2_MUN
 	cUFFornece		:= SA2->A2_EST
 	cCEPFornece		:= SA2->A2_CEP
 	cContatoFornece	:= SA2->A2_CONTATO
 	cDDDFornece		:= SA2->A2_DDD
 	cTelFornece		:= SA2->A2_TEL
 	cFaxFornece		:= SA2->A2_FAX
 	cCgcFornece		:= SA2->A2_CGC
 	cInscrFornece		:= SA2->A2_INSCR    
 	
//FORMATA CEP
	cCEPFornece		:= SUBSTR(cCEPFornece, 1, 5) + "-" + SUBSTR(cCEPFornece, 6, 3)	 	
//FORMATA TELEFONE                 
	cTelFornece		:= SUBSTR(cTelFornece, 1, 4) + "-" + SUBSTR(cTelFornece, 5, 4)	
//CRIA MASCARA PARA CPF / CNPJ 
	If (SA2->A2_TIPO == 'F')	
		cCgcFornece 	:=  SUBSTR(cCgcFornece, 1, 3) + "." + SUBSTR(cCgcFornece, 4, 3) + "." + SUBSTR(cCgcFornece, 7, 3) + "-" + SUBSTR(cCgcFornece, 10, 2)  
	End If
	If (SA2->A2_TIPO == 'J')	      
	   	cCgcFornece 	:=  SUBSTR(cCgcFornece, 1, 2) + "." + SUBSTR(cCgcFornece, 3, 3) + "." + SUBSTR(cCgcFornece, 6, 3) + "/" + SUBSTR(cCgcFornece, 9, 4) + "-" +  SUBSTR(cCgcFornece, 13, 2)
	End If	
	
	 	
 //BUSCA CONDICAO DE PAGAMENTO
 	DbSelectArea("SE4")
 	DbSetOrder(1)
 	//DbGoTop()
 	If !DbSeek(xFilial() + cCondPagto)
 		Alert("Condi็ใo de Pagamento nใo encontrada")
 		return()
 	EndIf 
 	cCondPagto = SE4->E4_DESCRI
		        	
//PREENCHE ARRAY DOS ITENS
	dbSelectArea("SC7")
	DbSetOrder(1)      //20
	//DbGoTop()  
	If !DbSeek(xFilial() + mv_par01)
		Alert("Itens do pedido nao encontrados")
		return()
	EndIf
	nCont := 1 
		
//LOOPING DE ATRIBUIวรO DOS ITENS
	While !Eof() .and. SC7->C7_NUM == cNum
	dbSelectArea("SC7")
		AADD(aItem 		,SC7->C7_ITEM	)
		AADD(aDescri 	,SC7->C7_DESCRI	) 	
		AADD(aQuant 	,SC7->C7_QUANT	)
		AADD(aUn		,SC7->C7_UM		)
		AADD(aCodProd	,SC7->C7_PRODUTO)
		AADD(aPreco 	,SC7->C7_PRECO	)
		AADD(aTotal 	,SC7->C7_TOTAL	)
		AADD(aDatPrf 	,SC7->C7_DATPRF	)
		AADD(aObs		,SC7->C7_OBS	)
		AADD(aICMS		,SC7->C7_VALICM	)
		AADD(aIPI		,SC7->C7_IPI	)
		AADD(aValIPI	,SC7->C7_VALIPI	)
		AADD(aValFre	,SC7->C7_VALFRE	)
		AADD(aTotDesc	,SC7->C7_VLDESC	) 
		AADD(aICMSRet	,SC7->C7_ICMSRET)
		nCont++
		dbSkip()
	Enddo   	
	
//NUMERO DE ITENS
	nItens 	:= --nCont
  

//MONTA DIRETORIO DE TRABALHO
	MontaDir( "C:\MSIGA\MODWORD\" ) 
	'nCont := Str(nCont) 
	__CopyFile( "\SYSTEM\WORD\" + cDoc , cPatch )  	//Copia o arquivo para o diretorio local 
	
//CRIA CONEXAO COM WORD	
	OLE_CloseLink()
	oWord := OLE_CreateLink()
	OLE_NewFile( oWord, cPatch )

//ENVIA O CABECALHO PARA O WORD
	OLE_SetDocumentVar( oWord, "nItens"  		, nItens	 	   			)
	OLE_SetDocumentVar( oWord, "cNum"  			, cNum		 	   			)
	OLE_SetDocumentVar( oWord, "cNomFornece"	, cNomFornece		 		)
	OLE_SetDocumentVar( oWord, "cEndFornece"	, cEndFornece		 		)
	OLE_SetDocumentVar( oWord, "cBairroFornece"	, cBairroFornece		 	)
	OLE_SetDocumentVar( oWord, "cMunFornece"	, cMunFornece		 		)
	OLE_SetDocumentVar( oWord, "cUFFornece"		, cUFFornece		 		)
	OLE_SetDocumentVar( oWord, "cCEPFornece"	, cCEPFornece		 		)
	OLE_SetDocumentVar( oWord, "cContatoFornece", cContatoFornece	 		)
	OLE_SetDocumentVar( oWord, "cTelFornece"	, "(" + cDDDFornece + ") " + cTelFornece		 		)
	OLE_SetDocumentVar( oWord, "cFaxFornece"	, cFaxFornece		 		)
	OLE_SetDocumentVar( oWord, "cCgcFornece"	, cCgcFornece		 		)
	OLE_SetDocumentVar( oWord, "cInscrFornece"	, cInscrFornece		 		)
	OLE_SetDocumentVar( oWord, "dEmissao"  		, dEmissao			 		)
	OLE_SetDocumentVar( oWord, "cCondPagto"  	, cCondPagto		 		)
	OLE_SetDocumentVar( oWord, "cComprador"  	, cComprador		 		)	
			
//VERIFICA TIPO DE FRETE UTILIZADO
	
	Do Case 
		Case cTipoFrete == "C"
			OLE_SetDocumentVar( oWord, "cTipoFrete" 	, "CIF"	 )	
		Case cTipoFrete == "F"
			OLE_SetDocumentVar( oWord, "cTipoFrete" 	, "FOB"	 )
		Case cTipoFrete == "T"
			OLE_SetDocumentVar( oWord, "cTipoFrete" 	, "Terceiros"	 )
		Case cTipoFrete == "S"
			OLE_SetDocumentVar( oWord, "cTipoFrete" 	, "S/ Frete"	 )
		OTHERWISE
			OLE_SetDocumentVar( oWord, "cTipoFrete" 	, "-"	 )
	End Case	

//ACUMULA TOTAIS
	For nCont := 1 to nItens
    	nTotalGeral := nTotalGeral 	+ 	aTotal[nCont]
    	nTotalICMS	:= nTotalICMS 	+ 	aICMS[nCont]
    	nValIPI		:= nValIPI		+ 	aValIPI[nCont]
    	nValFre		:= nValFre		+	aValFre[nCont]
    	nTotDesc	:= nTotDesc		+	aTotDesc[nCont]
    	nICMSRet	:= nICMSRet		+	aICMSRet[nCont]
	Next  
	
//ENVIA OBSERVAวOES PARA WORD	
	For nCont := 1 to 7
		If nCont <= Len(aObs) 
				OLE_SetDocumentVar( oWord, "cObs"	+	AllTrim(Str(nCont))	, aObs[nCont]		 	)
		Else
			OLE_SetDocumentVar( oWord, "cObs"	+	AllTrim(Str(nCont))		, " "				 	)
		End If
	Next
	
//SOMA E ENVIA OS TOTAIS	
	nTotalCImp := nTotalGeral + nValIPI + nICMSRet + nValFre - nTotDesc
	OLE_SetDocumentVar( oWord, "nTotalGeral" 	, "R$" + transform(nTotalGeral		,	"@E 999,999,999.99"	 ))
	OLE_SetDocumentVar( oWord, "nTotalCImp"		, "R$" + transform(nTotalCImp  		,	"@E 999,999,999.99"	 ))
	OLE_SetDocumentVar( oWord, "nValFre" 		, "R$" + transform(nValFre			,	"@E 9999,999.99"	 ))
	OLE_SetDocumentVar( oWord, "nTotalICMS" 	, "R$" + transform(nTotalICMS		,	"@E 9999,999.99"	 ))
	OLE_SetDocumentVar( oWord, "nICMSRet" 		, "R$" + transform(nICMSRet			,	"@E 9999,999.99"	 ))
	OLE_SetDocumentVar( oWord, "nValIPI"	 	, "R$" + transform(nValIPI			,	"@E 9999,999.99"	 ))
	OLE_SetDocumentVar( oWord, "nTotDesc"	 	, "R$" + transform(nTotDesc			,	"@E 9999,999.99"	 ))

//FAZ UPDATE NAS VARIAVEIS DO WORD    	
 	OLE_UpDateFields(oWord )
 
//OBS - OS ITENS SรO ENVIADOS POR ฺLTIMO DEVIDO A GANHO DE PERFORMANCE 
//		POIS NรO ษ NECESSมRIO FAZER A ATUALIZAวรO (OLE_UPDATEFIELDS) NOS MESMOS
//		DEVIDO A CRIAวรO DINAMICA DAS VARIAVEIS NO WORD (MACRO)
 
  
//ENVIA ITENS AO WORD
	For nCont := 1 to nItens
		OLE_SetDocumentVar( oWord, "cItem" 		+ 	AllTrim(Str(nCont))		, aItem[nCont]	 		)
		OLE_SetDocumentVar( oWord, "cDescri"	+	AllTrim(Str(nCont))  	, aDescri[nCont] 		)
		OLE_SetDocumentVar( oWord, "cCodProd"	+ 	AllTrim(Str(nCont))		, aCodProd[nCont]  		)
		OLE_SetDocumentVar( oWord, "cUn"		+   AllTrim(Str(nCont))		, aUn[nCont] 			)
		OLE_SetDocumentVar( oWord, "cQuant"		+ 	AllTrim(Str(nCont))		, transform(aQuant[nCont],	"@E 99,999.99"	 ))
		OLE_SetDocumentVar( oWord, "cPreco"		+	AllTrim(Str(nCont))		, "R$" + transform(aPreco[nCont],	"@E 9999,999.9999"	 ))
		OLE_SetDocumentVar( oWord, "cTotal"		+ 	AllTrim(Str(nCont))		, "R$" + transform(aTotal[nCont],	"@E 9999,999.99"	 ))
		OLE_SetDocumentVar( oWord, "cIPI"		+	AllTrim(Str(nCont)) 	, transform(aIPI[nCont],	"@E 99.99"	 ))
		OLE_SetDocumentVar( oWord, "cDatPrf"	+ 	AllTrim(Str(nCont))		, aDatPrf[nCont] 		)
	Next		
		
//EXECUTA MACRO (CRIA LINHAS DOS ITENS)
	OLE_ExecuteMacro(oWord,"tabitens") 			
							
//OPวีES DO WORD
	//OLE_UpDateFields(oWord )
	//OLE_SetProperty	(oWord, '208', .T.)
	//OLE_PrintFile	(oWord ,"ALL",,,1)
	OLE_SaveFile 	(oWord, "\system\" + cDoc)
	OLE_CloseLink	(oWord )

Return