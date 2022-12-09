#Include "Protheus.ch"
#Include "Rwmake.ch"

//-----------------------------------------------------------------------------------
// Rotina    | RFIS001 | Autor | Rene Lopes     | Data | 06/04/2010
//-----------------------------------------------------------------------------------
// Descr.    | Relatório Resumo Fiscal
//-----------------------------------------------------------------------------------
// Melhorias | Alteração na busca do cliente quando o pedido utilizar fornecedor.
//           | Reescrito o fonte para gerar direto no excel para melhorar desempenho. 
//           | Autor   | Rafael Beghini | Data | 05/05/2015
//           ------------------------------------------------------------------------
//           | Alteração no metodo da query para melhorar o desempenho.
//           | Acesso a tabela da SPED para mostrar erro do Schema. 
//           | Autor   | Rafael Beghini | Data | 18/06/2015
//           ------------------------------------------------------------------------
//           | Inclusão de operação de ENTRADA
//           | Autor   | Rafael Beghini | Data | 09/05/2019
//-----------------------------------------------------------------------------------
// Uso       | Certisign Certificadora Digital
//-----------------------------------------------------------------------------------
User Function RFIS001()
	Private cCadastro := "Relatório Resumo Fiscal - CertiSign"
	Private cPerg     := "RFIS01"
	Private nOpc      := 0
	Private aSay      := {}
	Private aButton   := {}
	Private _aDados   := {}
	
	Pergunte( cPerg, .F. )
	
	aAdd( aSay, "Esta rotina irá imprimir o relatorio de Resumo Fiscal conforme parâmetros")
	aAdd( aSay, "informados pelo usuário." )
	aAdd( aSay, "")
	aAdd( aSay, "Ao final do processamento, é gerado uma planilha com as informações.")
	
	Aadd( aButton, { 5,.T.,{|| Pergunte(cPerg, .T. ) } } )
	aAdd( aButton, { 1,.T.,{|| nOpc := 1,FechaBatch()}})
	aAdd( aButton, { 2,.T.,{|| FechaBatch() }} )
	
	FormBatch( cCadastro, aSay, aButton )
	
	If nOpc == 1
		FWMsgRun(,{|| RunReport()} , cCadastro, 'Aguarde, gerando relatório...')		
	Endif
Return

//-----------------------------------------------------------------------
// Rotina | RunReport | Autor | Rafael Beghini     | Data | 05/05/2015
//-----------------------------------------------------------------------
// Descr. | Rotina processar o relatório. 
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function RunReport()
	Local cCODIGO    := ''																															
	Local cLOJA      := '' 																															
	Local cNOME      := ''
	Local cTPCLIEN   := ''
	Local cCNPJ      := ''																																
	Local cIE        := ''
	Local cTIPO      := ''
	Local cXOPER     := ''
	Local cPEDGAR    := ''
	Local cPEDGARAnt := ''
	Local cCODRET    := ''
	Local cDESRET    := ''
	Local cCODSEG    := ''
	Local cTES       := ''
	Local cPEDIDO    := ''
	Local cDESCRICAO := ''
	Local cITEMPV    := ''
	Local cMSGNOTA   := ''
	Local cDESCMSG   := ''
	Local cORIGPV    := ''
	Local cVOUORI    := ''
	Local cTIPVOU    := ''
	Local cINCISS    := ''
	Local xCanal     := ''
	Local cGrupo	 := ''
	Local cDescGrp	 := ''
	Local cPEDSITE	 := ''
	Local dDtEmissa  := cToD(Space(8))
	Local dDtValida  := cToD(Space(8))
	Local cAliasA    := GetNextAlias()
	Local nALIQUOTA  := 0
	Local nALIQCOMP  := 0
	Local nRecSFT    := 0
	Local nHdl       := 0
	Local nPos       := 0
	Local lRet       := .F.
	
	Local cPath      := GetTempPath() //Função que retorna o caminho da pasta temp do usuário logado, exemplo: %temp%
	Local cDir       := Curdir()
	Local cNameFile  := 'ResumoFiscal_' + iIF(MV_PAR07==1,'Entrada_','Saida_')  + dTos(Mv_par01) + '_a_' + dTos(Mv_par02) + '.CSV'
	Local cDado      := ''
	Local cCabec     := ' '
	
	Private cC5xFil  := ''
	Private cC6xFil  := ''
	Private cA1xFil  := ''
	Private cA2xFil  := ''
	Private cB1xFil  := ''
	Private cD1xFil  := ''
	Private cD2xFil  := ''
	Private cZ1xFil  := ''
	Private cX5xFil  := ''
	Private cZ5xFil  := ''
	Private cZFxFil  := ''
	Private cZHxFil  := ''
	Private xZ2xFil  := ''
	Private aCombo   := {}
	
	IF MV_PAR07==1 //Operação ENTRADA
		cCabec := 	"DATA" + ';' + "SERIE" + ';' + "NOTA" + ';' + "ITEM" + ';' + "CODIGO" + ';' + "LOJA" + ';' + "NOME" + ';' + "CNPJ" + ';' + "IE" + ';' +;
					"ESTADO" + ';' + "TES" + ';' + "CFOP" + ';' + "VALOR" + ';' + "BASE ICM" + ';' + "VALOR ICM" + ';' + "BASE IPI" + ';' + "VALOR IPI" + ';' +;
					"PRODUTO" + ';' + "DESCRICAO" + ';' + "OBSERVACAO" + ';' + "CHAVE NFE" + ';'
	Else
		cCabec :=	"DATA" + ';' + "SERIE" + ';' + "NOTA" + ';' + "VENDEDOR" + ';' + "NOME VENDEDOR" + ';' + "CANAL VENDAS" + ';' + "CODIGO" + ';' + "TIPO CLIENTE" + ';' +; 
					"NOME" + ';' + "CNPJ"+ ';' + "IE" + ';' + "ESTADO" + ';' + "TES" + ';' + "CFOP" + ';' + "VALOR" + ';' + "BASE ICMS" + ';' + "ALIQUOTA" + ';' +;
					"VALOR ICMS" + ';' + "ALIQUOTA ICMS INTERNA" + ';' + "ICMS RETIDO" + ';' + "DIFAL ORIGEM" + ';' + "DIFAL DESTINO" + ';' + "SEG.PROD." + ';' +;
					"PRODUTO" + ';' + "DESC. PRODUTO" + ';' + "OBSERVACAO" + ';' + "ORIGEM PEDIDO" + ";" + "PEDIDO" + ';' + "PEDGAR" + ';' + "PEDGAR_ANT" + ';' +;
					'NUM_VOU_ORI' + ';' + 'Tipo Voucher' + ';' + "EMISSÃO" + ';' + "VALIDACAÇÃO" + ';' + "CHAVE NFE" + ';' + "COD SEFAZ" +';' + "DESCR.SEFAZ" + ';' +; 
					"OPERAÇÃO" + ';' + "COD MSG NOTA" + ';' + "DESCRICAO MENSAGEM" + ';' + "ISS INCLUSO" + ';' + "GRUPO" + ';' + "DESC. GRUPO" + ';' + "PED SITE" + ';'
	EndIF

	IF MontaQry(cAliasA, @nRecSFT)
		
		IF File( cDir + cNameFile )
			Ferase( cDir + cNameFile)
		EndIF
		
		IF File( cPath + cNameFile )
			Ferase( cPath + cNameFile)
		EndIF
		
		nHdl := FCreate( cNameFile )
		FWrite( nHdl, cCabec + CRLF )
		
		Opentb() //Abre as tabelas para consulta
		
		//DbSelectArea(cAliasA)
		(cAliasA)->(dbGoTop())                 

		IF MV_PAR07==1 //Operação ENTRADA
			While (cAliasA)->(!EoF())
				cCODIGO := (cAliasA)->CODIGO
				cLOJA   := (cAliasA)->LOJA
				
				IF SA2->(MsSeek(cA2xFil+cCODIGO+cLOJA))
					cNome    := Iif(SA2->A2_TIPO == "F", "", Alltrim( STRTRAN( STRTRAN(SA2->A2_NOME, ';', ''), '.', '' ) ))
					cCNPJ    := Iif(SA2->A2_TIPO == "F", "" ,SA2->A2_CGC  )
					cIE      := rTrim( SA2->A2_INSCR )
				EndIF

				IF SD1->(MsSeek(cD1xFil+(cAliasA)->NOTA+(cAliasA)->SERIE+cCODIGO+cLOJA+(cAliasA)->PRODUTO+(cAliasA)->ITEM))
					cTES := SD1->D1_TES
				EndIF

				If SB1->(MsSeek(cB1xFil+(cAliasA)->PRODUTO))
					cDESCRICAO := rTrim(SB1->B1_DESC)
				EndIf

				cDado := dToc(sTod((cAliasA)->EMISSAO)) + ';' + (cAliasA)->SERIE + ';' + CHR(160)+(cAliasA)->NOTA + ';' + (cAliasA)->ITEM + ';' +; 
						CHR(160)+cCODIGO + ';' + CHR(160)+cLOJA + ';' + cNOME + ';' + CHR(160)+cCNPJ + ';' + CHR(160)+cIE + ';' + (cAliasA)->ESTADO + ';' + cTES + ';' +;
						(cAliasA)->CFOP + ';' + lTrim(TransForm((cAliasA)->VALOR,"@E 99,999,999.99")) + ';' +; 
						lTrim(TransForm((cAliasA)->BASEICM,"@E 99,999,999.99")) + ';' +;
						lTrim(TransForm((cAliasA)->VALICM,"@E 99,999,999.99")) + ';' +;
						lTrim(TransForm((cAliasA)->BASEIPI,"@E 99,999,999.99")) + ';' +;
						lTrim(TransForm((cAliasA)->VALIPI,"@E 99,999,999.99")) + ';' +;
						CHR(160)+(cAliasA)->PRODUTO + ';' + cDESCRICAO + ';' +; 
						(cAliasA)->OBSERV + ';' + lTrim( CHR(160) + cValToChar((cAliasA)->CHVNFE) ) + ';'

				FWrite( nHdl, cDado + CRLF )
				
				(cAliasA)->(dbSkip())
			EndDo
		Else
			While (cAliasA)->(!EoF())
				cCODIGO := (cAliasA)->CODIGO
				cLOJA   := (cAliasA)->LOJA
				cCODRET := (cAliasA)->CODSEF
				
				IF Empty( cCODRET )
					cDESRET := ''
				ElseIF SX5->(MsSeek(cX5xFil+'ZP'+cCODRET))
					cDESRET := Alltrim(SX5->X5_DESCRI)	
				Else 
					cDESRET := 'Código não encontrado na SX5, tabela ZP - Verifique com Sistemas'
				EndIF
				
				IF .NOT. Empty( (cAliasA)->CANCELADA )
					IF SA1->(MsSeek(cA1xFil+cCODIGO+cLOJA))
						cNOME    := Iif(SA1->A1_PESSOA == "F", "", Alltrim( STRTRAN( STRTRAN(SA1->A1_NOME, ';', ''), '.', '' ) ))
						cTPCLIEN := SA1->A1_PESSOA 
						cCNPJ    := Iif(SA1->A1_PESSOA == "F", "", SA1->A1_CGC)  
						cIE      := rTrim( SA1->A1_INSCR )
					ElseIF SA2->(MsSeek(cA2xFil+cCODIGO+cLOJA))
						cNome    := Iif(SA2->A2_TIPO == "F", "", Alltrim( STRTRAN( STRTRAN(SA2->A2_NOME, ';', ''), '.', '' ) ))
						cTPCLIEN := SA2->A2_TIPO
						cCNPJ    := Iif(SA2->A2_TIPO == "F", "", SA2->A2_CGC)  
						cIE      := rTrim( SA2->A2_INSCR )
					Else
						cNOME    := ""
						cTPCLIEN := ""  
						cCNPJ    := ""  
						cIE      := ""  
					EndIF
					//D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM
				ElseIF SD2->(MsSeek(cD2xFil+(cAliasA)->NOTA+(cAliasA)->SERIE+cCODIGO+cLOJA+(cAliasA)->PRODUTO+(cAliasA)->ITEM))
					nALIQUOTA := SD2->D2_PICM
					cTES		 := SD2->D2_TES
					cPEDIDO   := SD2->D2_PEDIDO
					cITEMPV   := SD2->D2_ITEMPV
					nALIQCOMP := SD2->D2_ALIQCMP
				
					If SC6->( MsSeek(cC6xFil + cPEDIDO + cITEMPV) )
						cXOPER  := SC6->C6_XOPER
						
						If SC5->( MsSeek(cC5xFil + cPEDIDO) )
							nPos := AScan( aCombo, {|x| Left(x,1) == SC5->C5_XORIGPV  } )
							cORIGPV  := IIF( nPos > 0,aCombo[nPos], '')
							cPEDGAR  := SC5->C5_CHVBPAG
							cPEDSITE := SC5->C5_XNPSITE
							cTIPO    := Alltrim(SC5->C5_TIPO)
							cMSGNOTA := AllTrim(SC5->C5_XMENSUG)
							cDESCMSG := IIF( .NOT. Empty(cMSGNOTA), rTrim( Posicione("SM4",1,xFilial('SM4') + cMSGNOTA ,"M4_DESCR") ), '' )
							cINCISS  := IIF( Empty(SC5->C5_INCISS), '', ( IIF( SC5->C5_INCISS=='S','Sim','Não') ) )
							If !( cTIPO $ 'B/D' )
								//Cliente
								SA1->(MsSeek(cA1xFil+cCODIGO+cLOJA))
								
								cNOME    := Iif(SA1->A1_PESSOA == "F","", Alltrim( STRTRAN( STRTRAN(SA1->A1_NOME, ';', ''), '.', '' ) ))  	
								cTPCLIEN := SA1->A1_PESSOA 
								cCNPJ    := Iif(SA1->A1_PESSOA == "F","", SA1->A1_CGC)  
								cIE      := rTrim( SA1->A1_INSCR )  
							Else
								//Fornecedor
								SA2->(MsSeek(cA2xFil+cCODIGO+cLOJA))
								
								cNome    := Iif(SA2->A2_TIPO == "F","", Alltrim( STRTRAN( STRTRAN(SA2->A2_NOME, ';', ''), '.', '' ) ))
								cTPCLIEN := SA2->A2_TIPO
								cCNPJ    := Iif(SA2->A2_TIPO == "F","",SA2->A2_CGC)  
								cIE      := rTrim( SA2->A2_INSCR )
							EndIf
							IF .NOT. Empty( cPEDGAR )
								IF SZ5->( MsSeek(cZ5xFil + cPEDGAR) )
									dDtEmissa  := SZ5->Z5_DATEMIS
									dDtValida  := SZ5->Z5_DATVAL
									cPEDGARAnt := SZ5->Z5_PEDGANT
									cGrupo	   := SZ5->Z5_GRUPO
									cDescGrp   := SZ5->Z5_DESGRU
								EndIF
								IF SZF->( MsSeek(cZFxFil + cPEDGAR) )
									cVOUORI := SZF->ZF_COD
									cTIPVOU := Posicione('SZH',1,xFilial('SZH') + SZF->ZF_TIPOVOU,"ZH_DESCRI" )
								Else
									cVOUORI := ''
									cTIPVOU := ''
								EndIF
							Else
								dDtEmissa  := cToD(Space(8))
								dDtValida  := cToD(Space(8))
								cPEDGARAnt := ''
								cVOUORI    := ''
								cTIPVOU    := ''
								cGrupo	   := ''
								cDescGrp   := ''
							EndIF
						Else
							cNOME    := ""
							cTPCLIEN := ""  
							cCNPJ    := ""  
							cIE      := ""
							cPEDGAR  := ""
							cTIPO    := ""
							cMSGNOTA := ""
							cDESCMSG := ""
						EndIf
					Else
						cXOPER  := ""	
					EndIf	
				Else
					nALIQUOTA 	:= 0
					nALIQCOMP 	:= 0
					cPEDIDO   	:= ""
					cTES		:= ""
				EndIf
				
				If SB1->(MsSeek(cB1xFil+(cAliasA)->PRODUTO))
					cDESCRICAO := rTrim(SB1->B1_DESC)
					cCODSEG    := rTrim( Posicione("SZ1",1,cZ1xFil+SB1->B1_XSEG,"Z1_DESCSEG") )
				Else
					cDESCRICAO := ''	
					cCODSEG    := ''	
				EndIf
				
				//Busca erro na tabela do Sped 050
				IF Empty(cCODRET) .And. Alltrim((cAliasA)->SERIE) == '2'
					cCODRET := RFISRet((cAliasA)->NOTA,(cAliasA)->SERIE)
					If cCODRET == '3'
						cCODRET := 'Sped: ' + cCODRET
						cDESRET := 'NFe com falha no schema XML'
					Else
						cCODRET := ''
					EndIf
				EndIF
				
				IF SZ2->( MsSeek( xZ2xFil + (cAliasA)->CANALVEND ) )
					xCanal := rTrim( SZ2->Z2_CANAL ) 
				Else
					xCanal := 'Não informado'
				EndIF
				
				cDado := dToc(sTod((cAliasA)->EMISSAO)) + ';' + (cAliasA)->SERIE + ';' + CHR(160)+(cAliasA)->NOTA + ';' + (cAliasA)->VENDEDOR + ';' +; 
						rTrim( (cAliasA)->NOMEVEND ) + ';' + xCanal + ';' + CHR(160)+cCODIGO + ';' + cTPCLIEN + ';' + cNOME + ';' + CHR(160)+cCNPJ + ';' +; 
						CHR(160)+cIE + ';' + (cAliasA)->ESTADO + ';' + cTES + ';' + (cAliasA)->CFOP + ';' + lTrim(TransForm((cAliasA)->VALOR,"@E 99,999,999.99")) + ';' +; 
						lTrim(TransForm((cAliasA)->BASEICM,"@E 99,999,999.99")) + ';' + lTrim(TransForm(nALIQUOTA,"@E 99,999,999.99")) + ';' +;
						lTrim(TransForm((cAliasA)->VALICM,"@E 99,999,999.99")) + ';' +; 
						lTrim(TransForm(nALIQCOMP,"@E 99,999,999.99")) + ';' +; 
						lTrim(TransForm((cAliasA)->ICMSRET,"@E 99,999,999.99")) + ';' +; 
						lTrim(TransForm((cAliasA)->ICMSCOMP,"@E 99,999,999.99")) + ';' +;
						lTrim(TransForm((cAliasA)->ICMSDEST,"@E 99,999,999.99")) + ';' +;
						cCODSEG + ';' + CHR(160)+(cAliasA)->PRODUTO + ';' + cDESCRICAO + ';' +; 
						(cAliasA)->OBSERV + ';' + cORIGPV + ';' + cPEDIDO + ';' + cPEDGAR + ';' + cPEDGARAnt + ';' + CHR(160)+cVOUORI + ';' + cTIPVOU + ';' + dToc(dDtEmissa) + ';' +; 
						dToc(dDtValida) + ';' + lTrim( CHR(160) + cValToChar((cAliasA)->CHVNFE) ) + ';' + cCODRET + ';' + cDESRET + ';' +; 
						cXOPER + ';' + cMSGNOTA + ';' + cDESCMSG + ';' + cINCISS + ';' + cGrupo + ';' + cDescGrp + ';' + cPEDSITE + ';'
				
				FWrite( nHdl, cDado + CRLF )
				
				(cAliasA)->(dbSkip())
				
				cCODIGO    := ''
				cLOJA      := ''
				cCODRET    := ''
				cDESRET    := ''
				cPEDIDO    := ''
				cXOPER     := ''
				cPEDGAR    := ''
				cTIPO      := ''
				cNOME      := ''
				cTPCLIEN   := ''
				cCNPJ      := ''
				cIE        := ''
				nALIQUOTA  := 0
				nALIQCOMP  := 0
				cTES       := ''
				cDESCRICAO := ''
				cCODSEG    := ''
				cDado      := ''
				cMSGNOTA   := ''
				cDESCMSG   := ''
				cINCISS    := ''
				xCanal     := ''
				dDtEmissa  := cToD(Space(8))
				dDtValida  := cToD(Space(8))
				cGrupo	   := ''
				cDescGrp   := ''			
				cPEDSITE   := ''			
				
			EndDo
		EndIF
		(cAliasA)->( dbCloseArea())
		
		Sleep(500)
		
		FClose( nHdl )
				
		lRet := __CopyFile( cNameFile, cPath + cNameFile )
		
		IF lRet
			Sleep(500)
			
			Ferase( cDir + cNameFile)
			
			IF ! ApOleClient("MsExcel") 
				MsgAlert("MsExcel não instalado. Para abrir o arquivo, localize-o na pasta %temp% ;","Resumo Fiscal")
				Return
			Else
				ShellExecute( "Open", cPath + cNameFile , '', '', 1 )
			EndIF
		Else
			MsgAlert('Não foi possível copiar o arquivo para a pasta %temp%, verifique.','Resumo Fiscal')
		EndIF
	Else
		MsgInfo('Não há dados para gerar o relatório, verifique os parâmetros informados.','Resumo Fiscal')
	EndIf
Return

//-----------------------------------------------------------------------
// Rotina | MontaQry | Autor | Rafael Beghini     | Data | 18/06/2015
//-----------------------------------------------------------------------
// Descr. | Executa query para processamento 
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function MontaQry(cAliasA, nRecSFT)
	Local cSQL	:= ''
	Local lRetorno := .F.

	cSQL += "SELECT /*+ parallel(12) */ " + CRLF
	cSQL += "       FT_EMISSAO AS EMISSAO, " + CRLF
	cSQL += "       FT_ITEM    AS ITEM, " + CRLF
	cSQL += "       FT_SERIE   AS SERIE, " + CRLF
	cSQL += "       FT_NFISCAL AS NOTA, " + CRLF
	cSQL += "       FT_CLIEFOR AS CODIGO, " + CRLF
	cSQL += "       FT_LOJA    AS LOJA, " + CRLF
	cSQL += "       FT_ESTADO  AS ESTADO, " + CRLF
	cSQL += "       FT_CFOP    AS CFOP, " + CRLF
	cSQL += "       FT_VALCONT AS VALOR, " + CRLF
	cSQL += "       FT_BASEICM AS BASEICM, " + CRLF
	cSQL += "       FT_VALICM  AS VALICM, " + CRLF
	cSQL += "       FT_PRODUTO AS PRODUTO, " + CRLF
	cSQL += "       FT_OBSERV  AS OBSERV, " + CRLF
	cSQL += "       F3_CHVNFE  AS CHVNFE, " + CRLF

	IF MV_PAR07==1 //Notas de Entrada
		cSQL += "       FT_BASEIPI AS BASEIPI, " + CRLF
		cSQL += "       FT_VALIPI  AS VALIPI " + CRLF	
	Else
		cSQL += "       F2_VEND1   AS VENDEDOR, " + CRLF
		cSQL += "       A3_NOME    AS NOMEVEND, " + CRLF
		cSQL += "       A3_XCANAL  AS CANALVEND, " + CRLF
		cSQL += "       F3_CODRSEF AS CODSEF, " + CRLF
		cSQL += "       F3_DTCANC  AS CANCELADA, " + CRLF
		cSQL += "       FT_ICMSCOM AS ICMSCOMP, " + CRLF
		cSQL += "       FT_DIFAL   AS ICMSDEST, " + CRLF
		cSQL += "       FT_ICMSRET AS ICMSRET " + CRLF'
	EndIF
	cSQL += "FROM   " + RetSqlName('SF3') + " SF3 " + CRLF
	cSQL += "       INNER JOIN " + RetSqlName('SFT') + " SFT " + CRLF
	cSQL += "               ON SFT.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "                  AND FT_FILIAL = F3_FILIAL " + CRLF
	cSQL += "                  AND FT_NFISCAL = F3_NFISCAL " + CRLF
	cSQL += "                  AND FT_SERIE = F3_SERIE " + CRLF
	cSQL += "                  AND FT_CLIEFOR = F3_CLIEFOR " + CRLF
	cSQL += "                  AND FT_LOJA = F3_LOJA " + CRLF
	cSQL += "                  AND FT_ALIQICM = F3_ALIQICM " + CRLF
	cSQL += "                  AND FT_IDENTF3 = F3_IDENTFT " + CRLF
	IF MV_PAR07==1 //Notas de Entrada
		cSQL += "              AND FT_TIPOMOV = 'E' " + CRLF
	Else
		cSQL += "              AND FT_TIPOMOV = 'S' " + CRLF
	
		cSQL += "       LEFT OUTER JOIN " + RetSqlName('SF2') + " SF2 " + CRLF
		cSQL += "                    ON SF2.D_E_L_E_T_ = ' ' " + CRLF
		cSQL += "                       AND F2_FILIAL = FT_FILIAL " + CRLF
		cSQL += "                       AND F2_DOC = FT_NFISCAL " + CRLF
		cSQL += "                       AND F2_SERIE = FT_SERIE " + CRLF
		cSQL += "                       AND F2_CLIENTE = FT_CLIEFOR " + CRLF
		cSQL += "                       AND F2_LOJA = FT_LOJA " + CRLF
	
		cSQL += "       LEFT OUTER JOIN " + RetSqlName('SA3') + " SA3 " + CRLF
		cSQL += "                    ON SA3.D_E_L_E_T_ = ' ' " + CRLF
		cSQL += "                       AND A3_FILIAL = '" + xFilial('SA3') + "' " + CRLF
		cSQL += "                       AND A3_COD = F2_VEND1 " + CRLF
	EndIF
	cSQL += "WHERE  SF3.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "       AND F3_FILIAL 	 = '" + xFilial('SF3') + "' " + CRLF
	cSQL += "       AND F3_EMISSAO 	>= '" + dTos(Mv_par01) + "' " + CRLF
	cSQL += "       AND F3_EMISSAO 	<= '" + dTos(Mv_par02) + "' " + CRLF
	cSQL += "       AND F3_ESTADO 	>= '" + Mv_par05 + "' " + CRLF
	cSQL += "       AND F3_ESTADO 	<= '" + Mv_par06 + "' " + CRLF
	cSQL += "       AND F3_SERIE 	>= '" + Mv_par03 + "' " + CRLF
	cSQL += "       AND F3_SERIE 	<= '" + Mv_par04 + "' " + CRLF

	dbUseArea(.T., "TOPCONN", TCGenQry(,,cSQL), cAliasA, .F., .T.) 
		
	Count To nRecSFT
	
	//Verifica se dados na tabela temporaria
	If nRecSFT > 0
		lRetorno := .T.   
	EndIf

Return(lRetorno)

//------------------------------------------------------------------------
// Rotina | RFISRet | Autor | Rafael Beghini     | Data | 18/06/2015
//------------------------------------------------------------------------
// Descr. | Faz conexão no banco do SPED para retornar o codigo de retorno 
//------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//------------------------------------------------------------------------
Static Function RFISRet(cNota, cSerie)

	//Local nHErp   := AdvConnection()
	//Local cDBOra  := "ORACLE/SPED"
	//Local cSrvOra := "192.168.16.131" 
	//Local cSrvOra := "10.130.3.133"
	//Local nHndOra := 0
	Local cQuery  := ''
	Local cTRB    := ''
	Local cStatus := ''
	Local cNfeId  := ''
	Local cIdEnt  := '000002'
	Local aArea   := {}
	
	aArea := GetArea()
	
	cNfeId := Alltrim(cSerie) + '  ' + Rtrim(cNota)   //'2  003978960'
	
	//Renato Ruy - 15/12/16
	//A tabela apenas esta em outro schema, por isso já informo na consulta.
	
	// Cria uma conexão com um outro banco , outro DBAcces
	//nHndOra := TcLink(cDbOra,cSrvOra,7895)
	
	//If nHndOra < 0
	//	UserException("Falha ao conectar com "+cDbOra+" em "+cSrvOra)
	//Else
		cQuery := "SELECT S050.ID_ENT, S050.NFE_ID, S050.STATUS "
		cQuery += "FROM SPED.SPED050 S050 "
		cQuery += "WHERE S050.NFE_ID = '" + cNfeId + "' "
		cQuery += "AND S050.ID_ENT = '" + cIdEnt + "' "
		cQuery += "AND S050.D_E_L_E_T_= ' ' "
		
		cQuery := ChangeQuery( cQuery )
		cTRB := GetNextAlias()
		dbUseArea( .T., 'TOPCONN', TCGENQRY( , , cQuery ), cTRB, .F., .T. )
		
		If  (cTRB)->( .NOT. EOF() )
			While (cTRB)->( .NOT. EOF() )
				cStatus := (cTRB)->STATUS
				(cTRB)->( dbSkip() )
			End
		EndIF
		(cTRB)->( dbCloseArea() )
		FErase( cTRB + GetDBExtension() )
	//EndIF
	
	RestArea( aArea )
		
	// Volta para conexão ERP
	//TcSetConn(nHErp)
	
	// Fecha a conexão com o Oracle
	//TcUnlink(nHndOra)
	
Return (cValToChar(cStatus))

//-------------------------------------------------------------------
// Rotina | Opentb | Autor | Rafael Beghini     | Data | 18/06/2015
//-------------------------------------------------------------------
// Descr. | Abre as tabelas para o SEEK 
//-------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-------------------------------------------------------------------
Static Function Opentb() 
	dbSelectArea("SC5")
	SC5->(dbSetOrder(1))
	cC5xFil := xFilial("SC5")
	
	dbSelectArea("SC6")
	SC6->(DbSetOrder(1)) 
	cC6xFil := xFilial("SC6")
	
	dbSelectArea("SA1")
	SA1->(dbSetOrder(1))
	cA1xFil := xFilial("SA1")
	
	dbSelectArea("SA2")
	SA2->(dbSetOrder(1))
	cA2xFil := xFilial("SA2")
	
	dbSelectArea("SB1")
	SB1->(DbSetOrder(1)) //B1_FILIAL+B1_COD
	cB1xFil := xFilial("SB1")
	
	dbSelectArea("SD1")
	SD1->(DbSetOrder(1)) //D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM
	cD1xFil := xFilial("SD1")

	dbSelectArea("SD2")
	SD2->(DbSetOrder(3)) //D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM
	cD2xFil := xFilial("SD2")
	
	dbSelectArea("SZ1")
	SZ1->(DbSetOrder(1))
	cZ1xFil := xFilial("SZ1")
	
	dbSelectArea("SX5")
	SX5->(DbSetOrder(1))
	cX5xFil := xFilial("SX5")
	
	dbSelectArea("SZ5")
	SZ5->(DbSetOrder(1))
	cZ5xFil := xFilial("SZ5")
	
	dbSelectArea("SZF")
	SZF->(DbSetOrder(3))
	cZFxFil := xFilial("SZF")
	
	dbSelectArea("SZH")
	SZH->(DbSetOrder(1))
	cZHxFil := xFilial("SZH")
	
	dbSelectArea("SX3")
	SX3->(dbSetOrder(2))
	IF dbSeek( 'C5_XORIGPV' )   
		aCombo := StrToKarr( U_CSC5XBOX(), ';' )
	EndIF

	dbSelectArea("SZ2")
	SZ2->(DbSetOrder(1))
	xZ2xFil := xFilial("SZ2")
Return