/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ROMANEIO  �Autor  William Luiz Antunes Gurzoni   25/07/11   ���
�������������������������������������������������������������������������͹��
���Desc.     �Faz a impress�o do ROMANEIO utilizando um arquivo   		  ���
���          �modelo (.dot)                                               ���
�������������������������������������������������������������������������͹��
���Uso       � ROMANEIO		                                              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

#include "RWMAKE.CH"
#include "MSOLE.CH"
User Function RFAT002()

	//�Inicia variaveis locais
	Local aSays    := {}
	Local aButtons := {}
	Local nOpca    := {}
	Local aRegs    := {}
	Local cTitoDlg := "Impress�o - Romaneio"
	Local cPerg    := "RFAT001"
	Local I, J 


	//���������������������Ŀ
	//�Verifica as perguntas�
	//�����������������������
	DbSelectArea("SX1")
	DbSetOrder(1)
	DbGoTop()
	If !DbSeek( cPerg )
		aAdd(aRegs,{cPerg,"01","Serie NF"	,"","","mv_ch1","C",3,00,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","",""})
		aAdd(aRegs,{cPerg,"02","Numero NF"		,"","","mv_ch2","C",6,00,0,"G","","MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","",""})
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

	//�Monta interface para o usuario�
	
	aAdd( aSays, "Esta rotina tem como objetivo gerar a impress�o do romaneio de acordo" )
	aAdd( aSays, "com os paramentros informados pelo usu�rio. Utiliza documento .DOT como" )
	aAdd( aSays, "padr�o." )
	
	aAdd( aButtons, {5, .T., { |o| Pergunte( cPerg, .T. ) } } )
	aAdd( aButtons, {1, .T., { |o| nOpca := 1, FechaBatch() } } )
	aAdd( aButtons, {2, .T., { |o| nOpca := 2, FechaBatch() } } )
    
	
	FormBatch( cTitoDlg, aSays, aButtons )
	If nOpca == 1
		Pergunte( cPerg, .F. )
		Processa( {|| RFAT0022( "Processando pedido. Aguarde..." ) } )
	EndIf
	Return()
	
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ROMANEIO	�Autor  William Luiz Antunes Gurzoni   25/07/2011 ���
�������������������������������������������������������������������������͹��
���Desc.     �    Gera o relatorio                                        ���
�������������������������������������������������������������������������͹��
���Uso       � Romaneio			                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
	
Static Function RFAT0022()

//DADOS DO CABECALHO DO ROMANEIO
	Local cNota		:= ""
	Local cSerie	:= ""
	Local cCliente	:= ""
	Local cEnd		:= ""
	Local cBairro	:= ""
	Local cCidade 	:= ""  
	Local cUF		:= ""
	Local cTel		:= ""
	Local cContato	:= ""
	Local cCEP		:= ""
		                     
//VARIAVEIS DOS ITENS
	Local nCont 	:= 1 //Conta o numero na linha atual  
	Local aPedido	:= {}
	Local aItem		:= {}
	Local aCodProd	:= {}
	Local aDescri	:= {}
	Local aQuant	:= {}
	
//VARIAVEIS DO DOCUMENTO
	Local oWord   	:= Nil
	Local nItens	:= 0
	Local cPatch	:= "C:\msiga\modword\romaneio.dot"
	
//BUSCA PEDIDO
	DbSelectArea("SC9")
	DbSetOrder(6)
	If !DbSeek(xFilial() + MV_PAR01 + MV_PAR02) 
		Aviso( "Erro", "Nota n�o encontrado.", { "Ok" }, 2 )
		//Return
	EndIf  

//�����������������������
//�SELECIONA CLIENTE	�
//�����������������������

	dbSelectArea("SA1")
	dbSetOrder(1)
	DbSeek(xFilial() + SC9->C9_CLIENTE + SC9->C9_LOJA)
	
//GERA DADOS DO CABECALHO DO PEDIDO
	cNota		:= SC9->C9_NFISCAL
	cSerie		:= SC9->C9_SERIENF
	cCliente	:= SA1->A1_COD + " - " + SA1->A1_NOME
	cTel		:= "(" + SA1->A1_DDD + ") " + SA1->A1_TEL
	cContato	:= SA1->A1_CONTATO               
	
	//VERIFICA SE O ENDERECO DE ENTREGA EH O MESMO
	If (AllTrim(SA1->A1_ENDENT) = "")
		cEnd		:= SA1->A1_END
		cBairro		:= SA1->A1_BAIRRO
		cCidade 	:= SA1->A1_MUN
		cUF			:= SA1->A1_EST 
		cCEP		:= SA1->A1_CEP
	Else 
		cEnd		:= SA1->A1_ENDENT
		cBairro		:= SA1->A1_BAIRROE
		cCidade 	:= SA1->A1_MUNE
		cUF			:= SA1->A1_ESTE
		cCEP		:= SA1->A1_CEPE
	EndIf
	       	
//PREENCHE ARRAY DOS ITENS
	DbSelectArea("SC9")
	DbSetOrder(6)
	If !DbSeek(xFilial() + MV_PAR01 + MV_PAR02) 
		Aviso( "Erro", "Nota n�o encontrado.", { "Ok" }, 2 )
		Return
	EndIf  
	
	nCont := 1 
		
//LOOPING DE ATRIBUI��O DOS ITENS
	While !Eof() .and. SC9->C9_NFISCAL = MV_PAR02 .And. SC9->C9_SERIENF = MV_PAR01
	dbSelectArea("SC9")
		AADD(aPedido	,SC9->C9_PEDIDO	)                    
		AADD(aItem 		,SC9->C9_ITEM	)
		AADD(aDescri 	,SubStr(Posicione("SB1",1,xFilial("SB1") + SC9->C9_PRODUTO,"B1_DESC"), 1,70)	) 	
		AADD(aQuant 	,SC9->C9_QTDLIB	)
		AADD(aCodProd	,SC9->C9_PRODUTO)
		nCont++
		dbSkip()
	Enddo   	
	
//NUMERO DE ITENS
	nItens 	:= --nCont
  

//MONTA DIRETORIO DE TRABALHO
	MontaDir( "C:\MSIGA\MODWORD\" ) 
	'nCont := Str(nCont) 
	__CopyFile( "\SYSTEM\WORD\ROMANEIO.dot" , cPatch )  	//Copia o arquivo para o diretorio local 
	
//CRIA CONEXAO COM WORD	
	OLE_CloseLink()
	oWord := OLE_CreateLink()
	OLE_NewFile( oWord, cPatch )

//ENVIA O CABECALHO PARA O WORD
	OLE_SetDocumentVar( oWord, "nItens"  		, nItens	 	   			)
	OLE_SetDocumentVar( oWord, "cNota"  		, cNota		 	   			)
	OLE_SetDocumentVar( oWord, "cSerie"			, cSerie			 		)
	OLE_SetDocumentVar( oWord, "cCliente"		, cCliente			 		)
	OLE_SetDocumentVar( oWord, "cEnd" 			, cEnd					 	)
	OLE_SetDocumentVar( oWord, "cBairro" 		, cBairro			 		)
	OLE_SetDocumentVar( oWord, "cCidade"		, cCidade			 		)
	OLE_SetDocumentVar( oWord, "cUF"   			, cUF				 		)
	OLE_SetDocumentVar( oWord, "cTel"			, cTel				 		)
	OLE_SetDocumentVar( oWord, "cContato"		, cContato					)
	OLE_SetDocumentVar( oWord, "cCEP"			, cCEP						)
		
//VERIFICA TIPO DE FRETE UTILIZADO
/*	If (cTipoFrete == 'C')
		OLE_SetDocumentVar( oWord, "cTipoFrete" 	, "CIF"	 )
	Else
		If (cTipoFrete == 'F')
			OLE_SetDocumentVar( oWord, "cTipoFrete" 	, "FOB"	 )
		End If
	End If			
*/

//FAZ UPDATE NAS VARIAVEIS DO WORD    	
 	OLE_UpDateFields(oWord )
 
//OBS - OS ITENS S�O ENVIADOS POR �LTIMO DEVIDO A GANHO DE PERFORMANCE 
//		POIS N�O � NECESS�RIO FAZER A ATUALIZA��O (OLE_UPDATEFIELDS) NOS MESMOS
//		DEVIDO A CRIA��O DINAMICA DAS VARIAVEIS NO WORD (MACRO)
 
  
//ENVIA ITENS AO WORD
	For nCont := 1 to nItens 
		OLE_SetDocumentVar( oWord, "cPedido"	+ 	AllTrim(Str(nCont))		, aPedido[nCont] 		)
		OLE_SetDocumentVar( oWord, "cItem" 		+ 	AllTrim(Str(nCont))		, aItem[nCont]	 		)
		OLE_SetDocumentVar( oWord, "cDescri"	+	AllTrim(Str(nCont))  	, aDescri[nCont] 		)
		OLE_SetDocumentVar( oWord, "cCodProd"	+ 	AllTrim(Str(nCont))		, aCodProd[nCont]  		)
		OLE_SetDocumentVar( oWord, "cQuant"		+ 	AllTrim(Str(nCont))		, transform(aQuant[nCont],	"@E 99,999.99"	 ))
	Next		
		
//EXECUTA MACRO (CRIA LINHAS DOS ITENS)
	OLE_ExecuteMacro(oWord,"TabItensRomaneio") 			
							
//OP��ES DO WORD
	//OLE_UpDateFields(oWord )
	//OLE_SetProperty	(oWord, '208', .T.)
	//OLE_PrintFile	(oWord ,"ALL",,,1)
	OLE_SaveFile 	(oWord, "\system\romaneio.Doc")
	OLE_CloseLink	(oWord )

Return