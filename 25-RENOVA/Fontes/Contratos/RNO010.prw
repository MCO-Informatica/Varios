#include "protheus.ch"
#include "tbiconn.ch"
#include "RNO010.CH"
#INCLUDE 'FILEIO.CH'
 
//-------------------------------------------------------------------------------------------------------------------------
/*/{Protheus.doc} ADPIPCLI()
Função Responsavel na Importação de Contas a pagar Renova.
@author Bruno Melo
@since 08/03/2019
@version 1.0
@return NIL
/*/
//-------------------------------------------------------------------------------------------------------------------------
 
  
User Function RNO010()
	Local 		cArq 		:= cGetFile(STR0001+"CSV|*.CSV", OemToAnsi(STR0002),,,.T.)
	Private 	cPerg 		:= "RNO010"
	Private 	aErro		:= {}

//---------------------------------------------------------------------------------
//³ Cria os parametros de pergunta da rotina                            
//---------------------------------------------------------------------------------

//AtuSX1 RNO

	/*If !Pergunte(cPerg,.T.)
		Return
	Endif*/

	If !File(cArq)
		Aviso(STR0003,STR0004,{"OK"},2)
		Return NIL
	Else
		Processa({|| ProcArq(cArq) },STR0005)
	EndIf

Return NIL

Static Function ProcArq(cArq)
	Local cLine 	:= ""
	Local aCabec	:= {}
	Local nX		:= 0
	Local lInclui	:= .T.
	Local aDados	:= {}
	Local nInc		:= 0
	Local nOk     := 0
	Local nAtu		:= 0
	Local nNumDet  := 0
	Local nConta  := "1"
	Local aCompCab	:= {}
	Local lProc		:= .T.
	Local lProc2		:= .T.	
	Local nInd		:= 0
	Local nY		:= 0
	Local cMsg		:= ""
	Local nLinha	:= 1
	Local nCount  := 1
	Local nErro   := .F.
	Local aHeadSE2 := {}
	Local nOpcao   := 0
	Local cDetalhe := " "
	Local cMotivo  := " "
	Local lGrvGrp := .F.
	Local cArqTrb    := "IMPFIN"+DTOS(date())+"_"+StrTran(Time(),":","")
	Local cArqTrb1   := "PROC_"+DTOS(date())+"_"+StrTran(Time(),":","")
	Local lVisLog := .F.
	Local nHead := 0
	Local cLoja := " "
	Local cLojaCh := " "
	Local cFile := "\SYSTEM\"+cArqTrb+".LOG"
	Local lRet  := .T.
	Local nHdn := 0
	Local cCodFor	:= ""
	Local cNomArq	:= ''
	Local nFil := 0
	Local nA := 0
	Local aSm0 := {}
	Local cFilPg := ""
	Local nRec := 0
	Local cQrySE2	:= ""
	Local cAliSE2	:= "cAliSE2"
	Local nNum    := " "
	Local cCodFor	:= ""
	Local cLojFor	:= ""
	Local nErroC := .F.
	Local nErroL := .F.
	Local nPosCSV 	:= 0
	Local cArqR 		:= ""
	//Private l030Auto		:= .T.
	//Private lMsErroAuto		:= .F.
	//Private lMsHelpAuto 	:= .T.
	//Private lAutoErrNoFile	:= .T.
	Private   	nArqIpCli := fcreate(cFile)


	
	
	aCompCab:= {"CODIGO_DE_BARRAS","NUMERO_DANFE","CEDENTE","CNPJ_CEDENTE","SACADO","CNPJ_SACADO","VALOR_A_PAGAR"}
//id_usuario	CODIGO_DE_BARRAS	VENCIMENTO	 VALOR_A_PAGAR 	CNPJ_CEDENTE	CEDENTE	NUMERO_DANFE	DATA_DOCUMENTO	NRO_DOCUMENTO	CNPJ_SACADO	SACADO	BANCO	ORIGEM	CAMBOLETO	OBS	cod_pos	Ptime
	

	nHdn := FT_FUSE(cArq)
  	//nHdn := FOPEN(cArq) 
	ProcRegua(FT_FLASTREC())

	cLine	:= FT_FREADLN()
	cLine 	:= Upper(cLine)
	aCabec	:= StrToArray(upper(cLine),";")

// Valida cabeçalho da planilha quanto às colunas 
	For nInd := 1 To Len(aCompCab)
		If aScan(aCabec,aCompCab[nInd]) = 0
			//cMsg := STR0032+STR0006+aCompCab[nInd]+STR0007
			cMsg := STR0035
			lProc := .F.
			Exit
		Endif
	Next

If lProc
		FT_FSKIP()



		While !FT_FEof()
			cLine 	:= FT_FREADLN()

			nLinha++
			
			IncProc(STR0033+"-"+(nConta))
			
			
			nConta:= Val(nConta)//nConta linha posicionada.
			nConta++
			nConta:= CvaltoChar(nConta)
			aDados 	:= SEPARA(cLine,";",.T.)
			cMotivo :=" "
			nErro := .F.
			nErroC := .F.
		For nY := 1 To Len(aDados)
			If empty(aDados[nY]) 
				//cMsg := STR0006+"/"+aCompCab[nY]+space(1)+STR0029+Space(1)+nConta+space(1)+STR0028
				aDados[NY]:=" " 
				//cMotivo += cMsg
				//cMotivo += cMsg+ Chr(13)+Chr(10)
				//cMsg:= " " 
				//nErro := .T.
			Endif
		Next nY
	

						nInc++
						nOk++
						nOpcao := 1

		                  
					For nX := 1 to LEN(aCabec)

							If (aCabec[nX] == "CODIGO_DE_BARRAS" )
								Aadd(aHeadSE2,{"CODIGO_DE_BARRAS"     	, 	 ALLTRIM(aDados[nX]) , 																					Nil 	})
								Loop
							EndIf
							If aCabec[nX] == "NUMERO_DANFE" 
								Aadd(aHeadSE2,{"NUMERO_DANFE"  , 	ALLTRIM(aDados[nX]) , 																		Nil 	})
		
								Loop
							EndIf
							     				    					 					
							If aCabec[nX] == "CEDENTE" 
								Aadd(aHeadSE2,{"CEDENTE"      , 	ALLTRIM(aDados[nX]) , 																		Nil 	})
								Loop
							EndIf
							 
							If aCabec[nX] == "CNPJ_CEDENTE" 
								Aadd(aHeadSE2,{"CNPJ_CEDENTE"      , 	ALLTRIM(aDados[nX]) ,	 																	Nil 	})
								Loop
							EndIf	
							
							If aCabec[nX] == "SACADO"
								Aadd(aHeadSE2,{"SACADO" , 	ALLTRIM(aDados[nX]) , 																			Nil 	})
								Loop
							EndIf	
		
							If aCabec[nX] == "CNPJ_SACADO"
								Aadd(aHeadSE2,{"CNPJ_SACADO" , 	ALLTRIM(aDados[nX]) , 																			Nil 	})
								Loop
							EndIf			

							If aCabec[nX] == "VALOR_A_PAGAR"
								Aadd(aHeadSE2,{"VALOR_A_PAGAR" , 	ALLTRIM(aDados[nX]) , 																			Nil 	})
								Loop
							EndIf	
												

		
                   Next nX                                                     
				If !empty(aHeadSE2) //.AND. nErro == .F.//
					If lProc2	== .T.
						nColsCh	:= aScan( aHeadSE2, { |x| AllTrim(x[1]) == "CODIGO_DE_BARRAS"			})
						nColsNft	:= aScan( aHeadSE2, { |x| AllTrim(x[1]) == "NUMERO_DANFE"  		})
						nColsEmi	:= aScan( aHeadSE2, { |x| AllTrim(x[1]) == "CEDENTE" 			})
						nColsCem	:= aScan( aHeadSE2, { |x| AllTrim(x[1]) == "CNPJ_CEDENTE"     })
						nColsNpg	:= aScan( aHeadSE2, { |x| AllTrim(x[1]) == "SACADO"  })//FORNECEDOR
						nColsCpg	:= aScan( aHeadSE2, { |x| AllTrim(x[1]) == "CNPJ_SACADO" })//EMPRESA FILIAL PAGADORA
						nColsVal	:= aScan( aHeadSE2, { |x| AllTrim(x[1]) == "VALOR_A_PAGAR" 	})
	
						

                                      
						aImport:=   {}
			           
						aImport:=   {            {"CODIGO_DE_BARRAS"       ,ALLTRIM(U_Limp(aHeadSE2[nColsCh][2]))				,Nil},;
							{"NUMERO_DANFE" ,aHeadSE2[nColsNft][2]														,Nil},;
							{"CEDENTE"      ,aHeadSE2[nColsEmi][2]													,Nil},;
							{"CNPJ_CEDENTE"   ,aHeadSE2[nColsCem][2]													,Nil},;
							{"SACADO"    ,aHeadSE2[nColsNpg][2]												,Nil},;
							{"CNPJ_SACADO"     ,aHeadSE2[nColsCpg][2]											,Nil},;
							{"VALOR_A_PAGAR"   ,aHeadSE2[nColsVal][2]												,Nil}}
						
						aHeadSE2 := {}
					   //ABRE SIGAMAT(SM0) E VERIFICA A FILIAL PAGADORA ATRAVÉS DO CNPJ 
						   aSm0 := FWLoadSM0()
						 	For nFil := 1 To Len(aSm0)
								If aSm0[nFil][18] = aImport[6][2]
									cFilPg := aSm0[nFil][2]
								Endif
	                    	Next nFil
	                    	
	                    	//Verifica se algum dos campos Não esta preenchido
	                    	For nA := 1 To Len(aImport)
								If aImport[nA][2] ==" " .OR. Empty(aImport[nA][2])
									nErroC := .T.
									nErro  := .T.
									nErroL := .T.
									cMotivo := STR0031+aImport[nA][1]+' /'+STR0029+' - '+nConta//
									GravaErro(.T.,.T.,.T.,cMotivo)
									cMotivo :=""
									//U_RNOLOG(aImport[2][2],cCodFor,cLojFor,1,cArqTrb,aImport[nA][1])
								Endif
	                    	Next nFil
	                    	
	                    	
					  //CONSULTA O TITULO E RETORNA COM O RECNO CASO O MESMO EXISTA.
							nRec := U_SE2CONS(aImport[1][2],aImport[2][2],aImport[4][2],aImport[6][2],cFilPg)	
							
							cCodFor	:= POSICIONE("SA2",3,XFILIAL("SA2")+ALLTRIM(aImport[4][2]),"A2_COD")
							cLojFor	:= POSICIONE("SA2",3,XFILIAL("SA2")+ALLTRIM(aImport[4][2]),"A2_LOJA")
							
					  //POSICIONA A GRAVAÇÃO CASO EXISTA O TITULO. 
							If nRec <> 0 .AND. nErro == .F.
								SE2->(DbGoTo(nRec))
								//If !empty(SE2->E2_CODBAR)
									RecLock("SE2",.F.)
									SE2->E2_XLINDIG  := ALLTRIM(aImport[1][2])
									SE2->E2_CODBAR   := ConvLD(ALLTRIM(aImport[1][2]))
									SE2->(MsUnlock())
									U_RNOLOG(aImport[2][2],cCodFor,cLojFor,1,cArqTrb,cFilPg)
								//Else
								 // JA EXISTE CODIGO DE BARRAS PARA ESSE TITULO.
								//	U_RNOLOG(aImport[2][2],cCodFor,cLojFor,3,cArqTrb,cFilPg)
								//EndIf
							Else
							//Gera Log.Não Foi possivel EncontraFr o Titulo
								If 	nErroC == .F.
									cMotivo := STR0034+aImport[2][2]+'/Fornecedor'+cCodFor+'/CNPJ'+ALLTRIM(aImport[4][2])
									GravaErro(.T.,.T.,.T.,cMotivo)
									cMotivo :=""
									nErroL := .T.
									nErro := .T.
									U_RNOLOG(aImport[2][2],cCodFor,cLojFor,2,cArqTrb,cFilPg)
								EndIf	
							EndIf
						FT_FSKIP()	
					EndIF//lProc2			
				//Else
				//GravaErro(.T.,.T.,.T.,cMotivo)
					
				EndIf//!empty(aHeadSE2)		
		 //Passa para Proxima linha do arquivo.					
		Enddo


Else//lProc
		//Aviso("Problema","Problema na leitura do arquivo "+cArq+Chr(13)+Chr(10)+;
		//Chr(13)+Chr(10)+cMsg,{"Ok"},2)
		
			cMotivo += STR0023+cArq+Chr(13)+Chr(10)+Chr(13)+Chr(10)+cMsg
			nErroL := .T.
	   //fclose(nHdn)
		FT_FUSE()
	
		If nErroL == .T.
	  	
	    	GravaErro(.T.,.T.,.T.,cMotivo)
	    	cMotivo :=""
	    	nErro := .T.
	    	nErroL := .T.
		Else
	   /*
		Aviso("Aviso","Processo concluído com sucesso."+Chr(13)+Chr(10)+;
		Chr(13)+Chr(10)+"Foram Incluídos "+AllTrim(Str(nInc))+" Clientes novos."+Chr(13)+Chr(10)+;
		Chr(13)+Chr(10)+"Foram Atualizados "+AllTrim(Str(nAtu))+" Clientes.",{"Ok"},2)*/
			Aviso("Aviso","Processo Ok "+cArq+Chr(13)+Chr(10)+;
			Chr(13)+Chr(10)+cMsg,{"Ok"},2)
		
		EndIf


	
	
EndIf//lProc


	If nErroL == .T.
    	fclose(nArqIpCli) //Rotina para gerar o arquivo txt 
    	logview(cFile)
    	cMotivo:= ""

   EndIf
   FT_FUSE()
   If nOk <> 0
	    lVisLog	:= MsgYesNo(STR0021, STR0020)
	    nPosCSV 	:=AT(".csv",cArq)
	    cArqR 		:= Substr(carq,1,nPosCSV-1)
		frename(cArq , cArqR+cArqTrb1+".CSV" )
   EndIf
	If lVisLog
	    
		U_RNOCLOGV(cArqTrb)
	EndIf



Return



//-------------------------------------------------------------------------------------------------------------------------
/*/{Protheus.doc} ADPIPCLI()
Limpa Caracteres.
@author Bruno Melo
@since 08/03/2019
@version 1.0
@return NIL
/*/
//-------------------------------------------------------------------------------------------------------------------------
 
User Function LimpCarct(cString)

	
Local cString2                    := Replace(FwNoAccent(cString),";",",")
Local cSTRLimpa                              := ""
Local nASCIICode            := 0
Local nC                                              := 0
Local nMax                                        := Len(cString2)
                
For nC := 1 to nMax
nASCIICode := ASC(Substr(cString2,nC,1)) 
	If (nASCIICode >= 33 .and. nASCIICode <= 43) .or. ;
	   (nASCIICode >= 45 .and. nASCIICode <= 46     ) .or. ;
	   (nASCIICode >= 58 .and. nASCIICode <= 64) .or. ;
	   (nASCIICode >= 91 .and. nASCIICode <= 96) .or. ;
		nASCIICode <= 31 .or. ;
	   	nASCIICode >= 123 
	                      
	   cSTRLimpa += ""
	Else
	   cSTRLialhampa += Substr(cString2,nC,1)
	Endif
Next nC

Return cSTRLimpa



	
Return(lGrpGrOk)

							
User Function SE2CONS(cLinD,cNum,cCnpEmi,cCnpjPg,cFilPg)
	Local cQrySE2	:= ""
	Local cAliSE2	:= "cAliSE2"
	Local nNum    := " "
	Local cCodFor	:= POSICIONE("SA2",3,XFILIAL("SA2")+ALLTRIM(cCnpEmi),"A2_COD")
	Local cLojFor	:= POSICIONE("SA2",3,XFILIAL("SA2")+ALLTRIM(cCnpEmi),"A2_LOJA")

	cQrySE2 := "	SELECT * FROM " + RetSqlName( "SE2" ) + " SE2" "
	cQrySE2 += "	WHERE E2_NUM LIKE '%" +cNum+ "%' "
	cQrySE2 += "  AND E2_FILIAL='"+cFilPg+"' "
	cQrySE2 += "  AND E2_FORNECE='"+cCodFor+"'	"
	cQrySE2 += "  AND E2_LOJA='"+cLojFor+"'"	
	cQrySE2 += "	AND D_E_L_E_T_ = ' '"
	
	If SELECT( cAliSE2 ) > 0
		( cAliSE2 )->( DbCloseArea() )
	EndIf

	DbUseArea(.T., "TOPCONN", TcGenQry(,,cQrySE2),cAliSE2,.T.,.F.)
		
	cNum := (cAliSE2)->R_E_C_N_O_

Return(cNum)



Static Function GravaErro(cCod,cLoja,cNome,cMsg)


 
AADD(aErro,{cCod,cLoja,cNome,cMsg})

fwrite(nArqIpCli, chr(13) + chr(10))//ESPACO      
fwrite(nArqIpCli,cmsg+ chr(13) + chr(10))

//If  fwrite(nArquivo,cmsg+ chr(13) + chr(10)) = -1


//EndIf

    
Return


Static Function LogView( cFile )

                Local oDlg         := Nil
                Local oFont        := Nil
                Local cMemo        := ""
                Local cBloco       := ""
                Local cMask        := "Arquivo de LOG (*.LOG)"
                Local cFile2       := ""
                Local nMaxRead     := 1048476
                Local nLength    	:= 0
                Local cFileCli     := AllTrim( GetTempPath() )+AllTrim( Substr( cFile, RAT("\",cFile)+1, Len(cFile) ) )
                Local nHandleLog 	:= fopen( cFile, FO_READWRITE + FO_SHARED )
    
                If nHandleLog <> -1
                               
                               // Sempre exibir pelo NOTEPAD
                               If CpyS2T( cFile, AllTrim( GetTempPath() ), .T.)
                                               WinExec('NOTEPAD '+cFileCli,1)
                               Endif
                
                               fClose(nHandleLog)
                Endif
Return

User Function Limp(cConteudo)

	Local nTamOrig    := Len(cConteudo)

     
    //Retirando caracteres
	cConteudo := StrTran(cConteudo, "'", "")
	cConteudo := StrTran(cConteudo, "_", "")
	cConteudo := StrTran(cConteudo, "/", "")
	cConteudo := StrTran(cConteudo, "?", "")
	cConteudo := StrTran(cConteudo, ".", "")
	cConteudo := StrTran(cConteudo, "\", "")
	cConteudo := StrTran(cConteudo, "|", "")
	cConteudo := StrTran(cConteudo, ":", "")
	cConteudo := StrTran(cConteudo, ";", "")
	cConteudo := StrTran(cConteudo, '"', '')
	cConteudo := StrTran(cConteudo, '°', '')
	cConteudo := StrTran(cConteudo, "-", "")

	


     
    //Definindo o conteúdo do campo
   // &(cCampo+" := '"+cConteudo+"' ")
     

Return(cConteudo)



 


Static FUNCTION ConvLD(XLINDIG )
SETPRVT("_cStr")

_cStr := LTRIM(RTRIM(XLINDIG))

IF VALTYPE(XLINDIG) == NIL .OR. EMPTY(XLINDIG)
	// Se o Campo está em Branco não Converte nada.
	_cStr := ""
ELSE
	// Se o Tamanho do String for menor que 44, completa com zeros até 47 dígitos. Isso é
	// necessário para Bloquetos que NÂO têm o vencimento e/ou o valor informados na LD.
	_cStr := IF(LEN(_cStr)<44,_cStr+REPL("0",47-LEN(_cStr)),_cStr)
ENDIF

DO CASE
CASE LEN(_cStr) == 47
	_cStr := SUBSTR(_cStr,1,4)+SUBSTR(_cStr,33,15)+SUBSTR(_cStr,5,5)+SUBSTR(_cStr,11,10)+SUBSTR(_cStr,22,10)
CASE LEN(_cStr) == 48
   _cStr := SUBSTR(_cStr,1,11)+SUBSTR(_cStr,13,11)+SUBSTR(_cStr,25,11)+SUBSTR(_cStr,37,11)
OTHERWISE
	_cStr := _cStr+SPACE(48-LEN(_cStr))
ENDCASE

RETURN(_cStr)

