#INCLUDE 'Protheus.ch'
#INCLUDE 'TOPConn.ch'
#INCLUDE "FWMVCDEF.CH"         
#INCLUDE "FWCOMMAND.CH"         
#include "TbiConn.ch"
#include "TbiCode.ch"
#INCLUDE "FILEIO.CH"
#INCLUDE 'TOPConn.ch'
#INCLUDE 'Rwmake.ch'

#DEFINE ENTER Chr(13)+Chr(10)
#DEFINE DIRXML  "XMLNFE\"
#DEFINE DIRALER "NEW\"
#DEFINE DIRLIDO "OLD\"
#DEFINE DIRERRO "ERR\" 


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ACOMR07    ºAutor ³Felipi Marques      º Data ³  06/25/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Importa arquivo xml para tabelas SDS/SDT                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function ACOMR07(cFile,lJob,oXmlNFe,cXML,aErros,cTipoRet) 

Local cProduto	    := " "
Local cXML          := ""
Local cError        := ""
Local cWarning      := ""
Local cTipoNF       := ""
Local cTabEmit      := ""
Local cDoc	        := ""
Local cSerie        := ""
Local cSerXML       := ""
Local cCodigo       := ""
Local cCampo1       := ""
Local cCampo2       := ""
Local cCampo3       := ""
Local cCampo4       := ""
Local cCampo5       := ""
Local cQuery        := ""
Local cNFECFAP      := SuperGetMV("MV_NFECFAP",.F.,"")
Local lFound        := .F.
Local lProces       := .T.
Local lCFOPEsp      := .T.
Local nX		    := 0
Local nY	    	:= 0
Local oFullXML      := NIL
Local aItens        := {}
Local aHeadSDS      := {}
Local aItemSDT      := {}
Local oDlg
Local lStatus       := .F.
Local cProduto2     := " "
Local lXmlCliFor    := (SuperGetMv("MV_XMLCADF" ,,.T. ))
Local cStatus       := ""
Local lNumX5        := .F.
Local nQuant	    := 0
Local nPrecUni	    := 0
Local nVrCalc	    := 0
Local cCNPJTran     := ""
Local cCodTransp    := ""
Local cPlacaTran    := ""
Local nPesoLiq      := 0
Local nPesoBruto    := 0
Local cTipoFrete    := ""
Local aQtdVol	    := {}
Local aEspVol	    := {}
Local lA140ICFOP    := ExistBlock("A140ICFOP")
Local cPedido	    := Space(TamSx3("DT_PEDIDO")[1])
Local cItemPed	    := Space(TamSx3("DT_ITEMPC")[1])
Local cNFECFAP      := SuperGetMV("MV_XMLCFPC",.F.,"")
Local cNFECFBN      := SuperGetMV("MV_XMLCFBN",.F.,"")
Local cNFECFDV      := SuperGetMV("MV_XMLCFDV",.F.,"")
Local cNFECFND      := SuperGetMV("MV_XMLCFND",.F.,"")
Local lProXFor      := SuperGetMV("MV_XMLPXF" ,.F.,.T.)
Local lForDupli     := .F.
Local lCOM10PC	    := .F.
Local _nContProd    := 0 
Local a140VPed	:= {}
Local a140PedAux	:= {}
Local nTotItPed		:= 0
Local cChaveNFe     := ""
Local cDescErro     := ""

Static lConvAsc	    := FindFunction("ConvAsc")

Private cCGC	    := CriaVar("A1_CGC")
Private cEmailAdm 	:= GETMV("MV_WFADMIN")
Private cEmailErro  := "user@suaempresa.com.br"
Private oAuxXML     := NIL
Private oXML	    := NIL
Private lMsErroAuto := .F.
Private cA100For	:= ""
Private cLoja		:= ""
Private aCols       := {}
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Determina a execucao via job                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private lJob		:= IsBlind()   
Private aProc  	    := {}
Private aErros      := {}
Private aErroERP	:= {}
Private lNfeCompl	:= .F.
Private cXmlOri	    := ""
Private cStartLido	:= Trim(DIRXML)+DIRLIDO
Private c2StartPath	:= Trim(cStartLido)+AllTrim(Str(Year(Date())))+"\"
Private c3StartPath	:= Trim(c2StartPath)+AllTrim(Str(Month(Date())))+"\"	//MES
Private cEmpBkp     := cEmpAnt
Private cFilBkp     := cFilAnt
Private lImport     := .F.
Private aCom10PC	:= {} // Array livre para uso no PE COM10PC - MH 17/08/2018

If !ExistDir(DIRXML)
	MakeDir(DIRXML)
	MakeDir(DIRXML +DIRALER)
	MakeDir(DIRXML +DIRLIDO)
	MakeDir(DIRXML +DIRERRO)
EndIf

If .NOT. ExistDir(c2StartPath) // MH - 06/05/2019
	nMake := MakeDir(c2StartPath)
	if nMake != 0
		conOut( "Não foi possível criar o diretório. Erro: " + cValToChar( FError() ) )
	endIf	
Else
	nMake := 0
EndIf
	
If .NOT. ExistDir(c3StartPath) // MH - 06/05/2019
	nMake := MakeDir(c3StartPath)
	if nMake != 0
		conOut( "Não foi possível criar o diretório. Erro: " + cValToChar( FError() ) )
	endIf	
Else
	nMake := 0
Endif
	
If !File(DIRXML+DIRALER +cFile)
	If lJob
		ConOut(Replicate("=",80))
		ConOut("ACOMR07 Error:")
		ConOut("Arquivo: " +cFile)
		ConOut("Ocorrencia: Arquivo inexistente.")
		ConOut(Replicate("=",80))
	Else
		Aviso("Error","Arquivo " +cFile +" inexistente.",{"OK"},2,"ACOMR07")
	EndIf
	lProces := .F.
Else
	cXMLOri := FsLoadTXT(DIRXML+DIRALER + cFile) //MemoRead(DIRXML+DIRALER +cFile  ) //"XMLNFE\"+"NEW\"+cFile 
Endif

If !Empty(cXMLOri)
	If SubStr(cXMLOri,1,1) != "<"
		nPosPesq := At("<",cXMLOri)
		cXMLOri  := SubStr(cXMLOri,nPosPesq,Len(cXMLOri))	// Remove caracteres estranhos antes da abertura da tag inicial do arquivo
	EndIf
	cXML := DecodeUTF8(cXMLOri)
	
	If Empty(cXML)
		cXML := cXMLOri
	EndIf
	
	If lConvAsc
		cXML := ConvAsc(cXML) //remove acentuação
	EndIf
	
	cXML := A140IRemASC(cXML)	//remove caracteres especiais não aceitos pelo encode
	
	cXML := EncodeUtf8(cXML)
	
	If Empty(cXML)
		cXML := cXMLOri
	EndIf
EndIf

//-- Nao processa conhecimentos de transporte
If !("</NFE>" $ Upper(cXML))
	lProces 	:= .F.
EndIf

If "</CTE>" $ Upper(cXML)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Nota de transporte³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oFullXML := XmlParserFile(DIRXML+DIRALER + cFile,"_",@cError,@cWarning)
	U_XMLCTe(cFile,lJob,@aProc,@aErros,oFullXML:_CTEPROC:_CTe) 
	lProces := .F.
EndIf

//³NOTA FISCAL NF-e         ³
If lProces
	
	oFullXML := XmlParserFile(DIRXML+DIRALER + cFile,"_",@cError,@cWarning)
	//-- Erro na sintaxe do XML
	If Empty(oFullXML) .Or. !Empty(cError)
		If lJob
			aAdd(aErros,{cFile,"Erro de sintaxe no arquivo XML: "+cError,"Entre em contato com o emissor do documento e comunique a ocorrência."}) 
		Else
			Aviso("Entre em contato com o emissor do documento e comunique a ocorrência.",cError,{"OK"},2,"ImpXML_NFe") 
		EndIf			
		lProces := .F.
	Else			
		oXML    := oFullXML
		oAuxXML := oXML			
		//-- Resgata o no inicial da NF-e
		If	lNfeCompl
			oXML := oFullXML:_INVOIC_NFE_COMPL:_NFE_SEFAZ:_NFE
		Else
			While !lFound
				oAuxXML := XmlChildEx(oAuxXML,"_NFE")
				If !(lFound := oAuxXML # NIL)
					For nX := 1 To XmlChildCount(oXML)
						oAuxXML  := XmlChildEx(XmlGetchild(oXML,nX),"_NFE")
						lFound := oAuxXML:_InfNfe# Nil
						If lFound
							oXML := oAuxXML
							Exit
						EndIf
					Next nX
				EndIf				
				If lFound
					oXML := oAuxXML
					Exit
				EndIf
			EndDo			
		EndIf
	EndIf	
	
	oAuxXml := XmlChildEx(oXml,"_INFNFE")
	
	oXmlNFe := oXML 
	
	//-- Erro na sintaxe do XML
	If Empty(oAuxXml) .Or. !Empty(cError)
		If lJob
			ConOut(Replicate("=",80))
			ConOut("ACOMR07 Error:")
			ConOut("Arquivo: " +cFile)
			ConOut("Ocorrencia: " +cError)
			ConOut(Replicate("=",80))
		Else
			Aviso("Erro",cError,{"OK"},2,"ACOMR07")
		EndIf
		
		//-- Move arquivo para pasta dos erros
		cArqTXT     := DIRXML+DIRALER+cFile
		//copia o arquivo antes da transacao
		cNomNovArq  := DIRERRO+cFile
		If MsErase(cNomNovArq)
			__CopyFile(cArqTXT,cNomNovArq)
			FErase(DIRXML+DIRALER+cFile)
		EndIf
		lProces := .F.
	Else
		
		lFound := .F. // Voltar variavel inicial para continuar validaçoes.
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³TRATAMENTO PARA NOTA DE IMPORTAÇÃO³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cNOME   := oXML:_INFNFE:_DEST:_XNOME:TEXT
		cEstado := oXML:_INFNFE:_DEST:_ENDERDEST:_UF:TEXT
		
		If cEstado=="EX"
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Emitente				   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If XmlChildEx(oAuxXml:_EMIT,"_CNPJ") # NIL
				cCGCDes := oAuxXml:_EMIT:_CNPJ:TEXT
			Else
				cCGCDes := oAuxXml:_EMIT:_CPF:TEXT
			EndIf
			If XmlChildEx(oAuxXml:_EMIT,"_IE") # NIL
				cInsDes := oAuxXml:_EMIT:_IE:TEXT
			EndIf
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Destinatario			   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cCGC := ""
		Else
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Emitente				   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If XmlChildEx(oAuxXml:_EMIT,"_CNPJ") # NIL
				cCGC := oAuxXml:_EMIT:_CNPJ:TEXT
			Else
				cCGC := oAuxXml:_EMIT:_CPF:TEXT
			EndIf
			If XmlChildEx(oAuxXml:_EMIT,"_IE") # NIL
				cInsc := oAuxXml:_EMIT:_IE:TEXT
			EndIf
			
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Destinatario			   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If XmlChildEx(oAuxXml:_DEST,"_CNPJ") # NIL
				cCGCDes := oAuxXml:_DEST:_CNPJ:TEXT
			Else
				cCGCDes := oAuxXml:_DEST:_CPF:TEXT
			EndIf
			If XmlChildEx(oAuxXml:_DEST,"_IE") # NIL
				cInsDes := oAuxXml:_DEST:_IE:TEXT
			EndIf
			
		EndIF 
		lFound := .T. // VALIDAÇÃO DE EMPRESA. ESTA TUDO LIBERADO				
		/* If cEmpAnt <> '99'
			//If "05068889000162" $ cCGCDes
				lFound := .T.
			//EndIf		
		Else
			lFound := .T.
		EndIf	*/	
       
		If !lFound
	   		If lJob
					cEmailErro :="Error:"+ENTER
					cEmailErro +="Arquivo: " +cFile+ENTER+ENTER
					cEmailErro +="OFICINA  1" +cFile+ENTER
					cEmailErro +="Ocorrencia: Empresa/Filial sem liberação para importação."+ENTER 
					cEmailErro +="              CNPJ: "+cCGCDes+ENTER+ENTER  
					cEmailErro +="FAVOR ENTRAR EM CONTATO:"+ENTER
					cEmailErro +="Tel: (011) 3031-2002"+ENTER
					cEmailErro +="E-mail: contato@oficina1.com.br"+ENTER
					ConOut(cEmailErro)
					Return
			Else
					cEmailErro :="Error:"+ENTER
					cEmailErro +="Arquivo: " +cFile+ENTER
					cEmailErro +="Ocorrencia: Empresa/Filial sem liberação para importação."+ENTER 
					cEmailErro +="              CNPJ: "+cCGCDes+ENTER+ENTER  
					cEmailErro +="FAVOR ENTRAR EM CONTATO:"+ENTER
					cEmailErro +="Tel: (011) 3031-2002"+ENTER
					cEmailErro +="E-mail: contato@oficina1.com.br"+ENTER
					ConOut(cEmailErro)
				    MsgStop(cEmailErro,"Atenção")
					Return
			EndIf		
		 EndIf
		
		
	    If cEmpAnt <> '99'
			dbSelectArea("SM0")
			dbSetOrder(1)
			dbGoTop()
			While !Eof()
				If M0_CGC == cCGCDes
					cFilAnt := M0_CODFIL
					cEmpAnt := M0_CODIGO
					lFound  := .T.
					Exit
				EndIf
				dbSkip()
			End
		Else
			lFound := .T.
		EndIf

		If !lFound
			If lJob
				cEmailErro :="ReadXML Error:"+ENTER
				cEmailErro +="Arquivo: " +cFile+ENTER
				cEmailErro +="Ocorrencia: Não encontado a Empresa/Filial do XML. CNPJ: "+cCGCDes+ENTER

				ConOut(Replicate("=",80))
				ConOut("ReadXML Error:")
				ConOut("Arquivo: " +cFile)
				ConOut("Erro: " +cEmailErro)
				Return
			Else
				cEmailErro :="ReadXML Error:"+ENTER
				cEmailErro +="Arquivo: " +cFile+ENTER
				
				cEmailErro +="Ocorrencia: Não encontado a Empresa/Filial do XML. CNPJ: "+cCGCDes+ENTER
				
				Aviso("Erro",cEmailErro,{"OK"},2,"ReadXML")
				Return
			EndIf
		EndIf


		lFound := .F. // Voltar variavel inicial para continuar validaçoes.
		
		//-- Se tag _InfNfe:_Det valida
		//-- Extrai CGC do fornecedor/cliente
		If lProces
			aItens := IIF(ValType(oXML:_InfNfe:_Det) == "O",{oXML:_InfNfe:_Det},oXML:_InfNfe:_Det)
			If AllTrim(oXML:_InfNfe:_Ide:_finNFe:Text) == "1"
				cTipoNF := "N"
				If lA140ICFOP		// Ponto de entrada para identificar o tipo da nota através do CFOP quando não for possível identificar através dos parâmetros MV_XMLCFPC/MV_XMLCFBN/MV_XMLCFDV
					cTpNfPE := ExecBlock("A140ICFOP",.F.,.F.,{oXML})
					If ValType(cTpNfPE) == "C" .And. cTpNfPE $ "O#B#D"
						cTipoNF := cTpNfPE
					EndIf
				Else
					//-- Valida o tipo da nf
					For nX := 1 To Len(aItens)
						If aItens[nX]:_PROD:_CFOP:TEXT $ cNFECFAP
							cTipoNF := "O"
						ElseIf aItens[nX]:_PROD:_CFOP:TEXT $ cNFECFBN
							cTipoNF := "B"
						ElseIf aItens[nX]:_PROD:_CFOP:TEXT $ cNFECFDV
							cTipoNF := "D"
						EndIf
						If cTipoNF <> "N"
							Exit
						EndIf
					Next nX
				EndIf
			ElseIf AllTrim(oXML:_InfNfe:_Ide:_finNFe:Text) == "2" .And. SDS->(FieldPos("DS_VALMERC")) > 0
				cTipoNF := "C"
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Verifica se a NF eh compl. de preco ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If Val(oXML:_InfNFe:_TOTAL:_ICMSTOT:_VPROD:Text) == 0  .And.;
					(Val(oXML:_InfNFe:_TOTAL:_ICMSTOT:_VICMS:Text) > 0 .Or. Val(oXML:_InfNFe:_TOTAL:_ICMSTOT:_VIPI:Text) > 0)
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Apaga arquivo XML de Compl. de Preco ICMS/IPI ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					aAdd(aErros,{cFile,"Documento complemento de preço icms/ipi não é tratado pela rotina de importação.","Gere o documento complementeo de preço icms/ipi de forma manual através da rotina documento de entrada."})
					aAdd(aErroErp,{cFile,"COM003"})
					lProces	:= .F.
				EndIf
			ElseIf AllTrim(oXML:_InfNfe:_Ide:_finNFe:Text) == "4"
				cTipoNF := "D" 	
			Else
				cTipoNf := "A" // MH 08/01/2019
				aAdd(aErros,{cFile,"Tipo NF-e de ajustes não será tratado pela rotina de importação.","Gere o documento de ajustes de forma manual através da rotina documento de entrada."})
				aAdd(aErroErp,{cFile,"COM004"})
				lProces	:= .F.
			EndIf
		EndIf
		
		// Retornar o tipo da Nota - MH 08/01/2019
		cTipoRet := cTipoNf 
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³BUSCA TIPO DA NOTA       ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cTabEmit := If(cTipoNF $ "NC","SA2","SA1") // CDS 14/08/2017 - Chamado 8868
		If !cEstado=="EX"
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³BUSCA DOC PELA CHAVE DA NOTA ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			DbSelectArea("SDS")
			SDS->(DbSetOrder(2))
			lFound := SDS->(DbSeek(xFilial("SDS")+Right(AllTrim(oXML:_InfNfe:_Id:Text),44)))//Filial + Chave de acessondIf
			cDoc   := StrZero(Val(AllTrim(oXML:_InfNfe:_Ide:_nNF:Text)),TamSx3("F1_DOC")[1])
			cSerie := PadR(oXML:_InfNfe:_Ide:_Serie:Text,TamSX3("F1_SERIE")[1])
		Else
			(cTabEmit)->(DBSETORDER(2))
			IF (cTabEmit)->(dbSeek(xFilial(cTabEmit)+SUBSTR(cNOME+space(40),1,40)))
				cCodigo := (cTabEmit)->&(Substr(cTabEmit,2,2)+"_COD")
				cA100For:= (cTabEmit)->&(Substr(cTabEmit,2,2)+"_COD")
				cLoja   := (cTabEmit)->&(Substr(cTabEmit,2,2)+"_LOJA")
				cStatus := "I"
			EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³BUSCA DOC E SERIE DA NOTA³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cFormul := "S"
			cDocXML:= StrZero(Val(AllTrim(oXML:_InfNfe:_Ide:_nNF:Text)),TamSx3("F1_DOC")[1])
			cSerXML:= PadR(oXML:_InfNfe:_Ide:_Serie:Text,TamSX3("F1_SERIE")[1])
			If !lJob
				NfeNextDoc(@cDoc,@cSerie,.T.)
			Else
				cSerie := PadR(oXML:_InfNfe:_Ide:_Serie:Text,TamSX3("F1_SERIE")[1])
				cDoc   := NxtSX5Nota(PadR(cSerie,3),.T.,"1")
			EndIf
			If Empty(cDoc)
				Return()
			EndIf
			
			DbSelectArea("SDS")
			SDS->(DbSetOrder(3))
			If (SDS->(DbSeek(xFilial("SDS")+cDocXML+cSerXML+cCodigo+cLoja)))
				lFound	 := .T.
			EndIf
			
		EndIf
		
		
		//VERIFICA O STATUS NA RECEITA FEDERAL E EM CASO DE REJEICAO NAO IMPORTA
		// cFilAnt / oXML:_INFNFE:_EMIT:_CNPJ:TEXT / oXML:_INFNFE:_EMIT:_XNOME:TEXT / cSerie / cDoc / Val(oXML:_INFNFE:_TOTAL:_ICMSTOT:_VNF:TEXT) / Retorno Pesquisa
        cChaveNFe    := Right(AllTrim(oXML:_InfNfe:_Id:Text),44)
		// Array de retorno: Código Retorno / Mensagem / Mensagem Erro
        // 1 - branco - 100         - 101        - 236
        // 2 - branco - Autorizado  - Canc Homol - Rejeição (chave aceso invalido)
        // 3 - ERRO   - branco	    - Branco     - branco

//        Alert(cChaveNFe)
		aRetPesquisa := PesqChv(cChaveNFe)
//		Alert("Retorno: "+aRetPesquisa[1][1])
		
        if AllTrim(aRetPesquisa[1][1]) <> "100"
		   lStatus := .T.
           if AllTrim(aRetPesquisa[1][1]) = "101"
              cDescErro := "Nota Fiscal Cancelada - Retorno Sefaz 101"
           else 
              if Empty(AllTrim(aRetPesquisa[1][1]))
                 cDescErro := aRetPesquisa[1][3]
              else
                 cDescErro := AllTrim(aRetPesquisa[1][1]) + " - " + AllTrim(aRetPesquisa[1][2])
              endif
           endif
           
		   Aadd(aErroXML,{cFilAnt,;
		                  oXML:_INFNFE:_EMIT:_CNPJ:TEXT,;
		                  oXML:_INFNFE:_EMIT:_XNOME:TEXT,;
		                  cSerie+"/"+cDoc,;
		                  Val(oXML:_INFNFE:_TOTAL:_ICMSTOT:_VNF:TEXT),;
		                  cDescErro})
        endif

		If lStatus
			If !lJob     // Right(AllTrim(oXML:_InfNfe:_Id:Text),44)   oXML
				//MsgStop("NFe com problemas, rotina Cancelada!","Atenção")
				Return(.F.)
			Else
				ConOut("NFe com problemas, rotina Cancelada!")
				Return(.F.)
			EndIf
		EndIf
		
		If lFound
			If lJob
				cEmailErro :="ACOMR07 Error:"+ENTER
				cEmailErro +="Arquivo: " +cFile+ENTER
				cEmailErro +="Ocorrencia: ID de NFe ja registrado na NF " +SDS->(DS_DOC+"/"+DS_SERIE)+" do fornecedor " +SDS->(DS_FORNEC+"/"+DS_LOJA) +"."+ENTER
				
				ConOut(Replicate("=",80))
				ConOut("ACOMR07 Error:")
				ConOut("Arquivo: " +cFile)
				ConOut("Ocorrencia: ID de NFe ja registrado na NF " +SDS->(DS_DOC+"/"+DS_SERIE);
				+" do fornecedor " +SDS->(DS_FORNEC+"/"+DS_LOJA) +".")
				ConOut(Replicate("=",80))
			Else
				Aviso("Erro","Arquivo: "+cFile+ENTER+"ID de NFe ja registrado na NF " +SDS->(DS_DOC+"/"+DS_SERIE);
				+" do fornecedor " +SDS->(DS_FORNEC+"/"+DS_LOJA) +".",{"OK"},2,"ACOMR07")
			EndIf
			
			//-- Move arquivo para pasta dos erros
			cArqTXT := DIRXML+DIRALER+cFile
			//copia o arquivo antes da transacao
			cNomNovArq  := DIRERRO+cFile
			If MsErase(cNomNovArq)
				__CopyFile(cArqTXT,cNomNovArq)
				FErase(DIRXML+DIRALER+cFile)
			EndIf
			
			lProces := .F.
		EndIf
		
		//-- Se ID valido
		If lProces
			If ValType(oXML:_InfNfe:_Det) == "O"
				aItens := {oXML:_InfNfe:_Det}
			ElseIf ValType(oXML:_InfNfe:_Det) == "U"
				If lJob
					cEmailErro :="ACOMR07 Error:"+ENTER
					cEmailErro +="Arquivo: " +cFile+ENTER
					cEmailErro +="Ocorrencia: tag _InfNfe:_Det nao localizada."+ENTER
					
					ConOut(Replicate("=",80))
					ConOut("ACOMR07 Error:")
					ConOut("Arquivo: " +cFile)
					ConOut("Ocorrencia: tag _InfNfe:_Det nao localizada.")
					ConOut(Replicate("=",80))
				Else
					Aviso("Erro","Tag _InfNfe:_Det nao localizada.",{"OK"},2,"ACOMR07")
				EndIf
				
				//-- Move arquivo para pasta dos erros
				cArqTXT := DIRXML+DIRALER+cFile
				//copia o arquivo antes da transacao
				cNomNovArq  := DIRERRO+cFile
				If MsErase(cNomNovArq)
					__CopyFile(cArqTXT,cNomNovArq)
					FErase(DIRXML+DIRALER+cFile)
				EndIf
				
				lProces := .F.
			Else
				aItens := oXML:_InfNfe:_Det
			EndIf
		EndIf
		lAchouForn :=.F.
		If lProces
			//Busca de Fornededor
			lForDupli := fornece_dupli(cCGC,cEstado)
			If !lForDupli
				If !cEstado=="EX"
					//-- Busca fornecedor/cliente na base
					lAchouForn :=.F.
					cTabEmit := If (Empty(cTabEmit),If(cTipoNF $ "DB","SA1","SA2"),cTabEmit)
					dbSelectArea(cTabEmit)
					(cTabEmit)->(dbSetOrder(3))
					If (cTabEmit)->(dbSeek(xFilial(cTabEmit)+cCGC))
						While !(cTabEmit)->(EOF()) .And. cCGC $ (cTabEmit)->&(Substr(cTabEmit,2,2)+"_CGC")
							If (cTabEmit)->&(Substr(cTabEmit,2,2)+"_MSBLQL") <> "1"
								lAchouForn := .T.
								Exit
							Else
								(cTabEmit)->(dbSkip())
							EndIf
						EndDo
					EndIf
				Else
					cTabEmit := If (Empty(cTabEmit),If(cTipoNF $ "DB","SA1","SA2"),cTabEmit)
					dbSelectArea(cTabEmit)
					(cTabEmit)->(DBSETORDER(2))
					If (cTabEmit)->(dbSeek(xFilial(cTabEmit)+SUBSTR(cNOME+space(40),1,40)))
						lAchouForn := .T.
					Else
						lAchouForn := .F.
					Endif
				EndIf
			EndIf
			
			If lAchouForn //Achou
				cCodigo := (cTabEmit)->&(Substr(cTabEmit,2,2)+"_COD")
				cLoja   := (cTabEmit)->&(Substr(cTabEmit,2,2)+"_LOJA")
				cNomeFor := (cTabEmit)->&(Substr(cTabEmit,2,2)+"_NOME")
			ElseIf lForDupli //Cliente com cnpj duplicado
				If !lJob
					// CDS 14/08/2017 - Chamado 8868
					If SimNao(If(cTipoNF $ "NC","Fornecedor","Cliente") +" de CNJP/CPF numero " +cCGC +" duplicado na base. selecionar o fornecedor correto ?") == "S"
						aCliLj := BuscaCLI(cCGC)
						If empty(aCliLj)
							lProces := .F.
						Else
							cCodigo:= aCliLj[1][1]
							cLoja  := aCliLj[1][2]
						EndIf
					Else
						lProces := .F.
					EndIf
				EndIf	
			Else
				If lJob
					If cTipoNF $ "NC" // CDS 14/08/2017 - Chamado 8868
						lProces := Inclui_fornecedor(cEstado)
						If !cEstado=="EX"
							(cTabEmit)->(dbSetOrder(3))
							(cTabEmit)->(dbSeek(xFilial(cTabEmit)+cCGC))
							cCodigo := (cTabEmit)->&(Substr(cTabEmit,2,2)+"_COD")
							cLoja   := (cTabEmit)->&(Substr(cTabEmit,2,2)+"_LOJA")
						Else
							(cTabEmit)->(dbSeek(xFilial(cTabEmit)+SUBSTR(cNOME+space(40),1,40)))
							cCodigo := (cTabEmit)->&(Substr(cTabEmit,2,2)+"_COD")
							cLoja   := (cTabEmit)->&(Substr(cTabEmit,2,2)+"_LOJA")
						EndIf
					Else
						lProces := inclui_cliente()
						If !cEstado=="EX"
							(cTabEmit)->(dbSetOrder(3))
							(cTabEmit)->(dbSeek(xFilial(cTabEmit)+cCGC))
							cCodigo := (cTabEmit)->&(Substr(cTabEmit,2,2)+"_COD")
							cLoja   := (cTabEmit)->&(Substr(cTabEmit,2,2)+"_LOJA")
						Else
							(cTabEmit)->(dbSeek(xFilial(cTabEmit)+SUBSTR(cNOME+space(40),1,40)))
							cCodigo := (cTabEmit)->&(Substr(cTabEmit,2,2)+"_COD")
							cLoja   := (cTabEmit)->&(Substr(cTabEmit,2,2)+"_LOJA")
						EndIf
					EndIf
				Else
					// CDS 14/08/2017 - Chamado 8868
					If SimNao(If(cTipoNF $ "NC","Fornecedor","Cliente") +" de CNJP/CPF numero " +cCGC +" inexistente na base. Deseja cadastrar automaticamente ?") == "S"
						If cTipoNF $ "NC" // CDS 14/08/2017 - Chamado 8868
							lProces := inclui_fornecedor(cEstado)
							If !cEstado=="EX"
								(cTabEmit)->(dbSetOrder(3))
								(cTabEmit)->(dbSeek(xFilial(cTabEmit)+cCGC))
								cCodigo := (cTabEmit)->&(Substr(cTabEmit,2,2)+"_COD")
								cLoja   := (cTabEmit)->&(Substr(cTabEmit,2,2)+"_LOJA")
							Else
								(cTabEmit)->(dbSeek(xFilial(cTabEmit)+SUBSTR(cNOME+space(40),1,40)))
								cCodigo := (cTabEmit)->&(Substr(cTabEmit,2,2)+"_COD")
								cLoja   := (cTabEmit)->&(Substr(cTabEmit,2,2)+"_LOJA")
							EndIf
						Else
							lProces := inclui_cliente()
							If !cEstado=="EX"
								(cTabEmit)->(dbSetOrder(3))
								(cTabEmit)->(dbSeek(xFilial(cTabEmit)+cCGC))
								cCodigo := (cTabEmit)->&(Substr(cTabEmit,2,2)+"_COD")
								cLoja   := (cTabEmit)->&(Substr(cTabEmit,2,2)+"_LOJA")
							Else
								(cTabEmit)->(dbSeek(xFilial(cTabEmit)+SUBSTR(cNOME+space(40),1,40)))
								cCodigo := (cTabEmit)->&(Substr(cTabEmit,2,2)+"_COD")
								cLoja   := (cTabEmit)->&(Substr(cTabEmit,2,2)+"_LOJA")
							EndIf
						EndIf
					Else
						If lJob
							cEmailErro :="ACOMR07 Error:"+ENTER
							cEmailErro +="Arquivo: " +cFile+ENTER
							// CDS 14/08/2017 - Chamado 8868
							cEmailErro +="Ocorrencia: " +If(cTipoNF $ "NC","fornecedor","cliente") +" de CNJP/CPF numero " +cCGC +" inexistente na base."+ENTER
							
							ConOut(Replicate("=",80))
							ConOut("ACOMR07 Error:")
							ConOut("Arquivo: " +cFile)
							// CDS 14/08/2017 - Chamado 8868
							ConOut("Ocorrencia: " +If(cTipoNF $ "NC","fornecedor","cliente") +" de CNJP/CPF numero " +cCGC +" inexistente na base.")
							ConOut(Replicate("=",80))
						Else
							// CDS 14/08/2017 - Chamado 8868
							Aviso("Erro",If(cTipoNF $ "NC","Fornecedor","Cliente") +" de CNJP/CPF numero " +cCGC +" inexistente na base.",{"OK"},2,"ACOMR07") // cadastrar o fornecedor ou cliente
						EndIf
						
						//-- Move arquivo para pasta dos erros
						cArqTXT := DIRXML+DIRALER+cFile
						//copia o arquivo antes da transacao
						cNomNovArq  := DIRERRO+cFile
						If MsErase(cNomNovArq)
							__CopyFile(cArqTXT,cNomNovArq)
							FErase(DIRXML+DIRALER+cFile)
						EndIf
						
						lProces := .F.
					EndIf
				EndIf
			EndIf
		EndIf
		
		//-- Se fornecedor/cliente validado
		//-- Processa cabeçalho e itens
		If lProces
			// CDS 14/08/2017 - Chamado 8868
			cCampo1 := If(!cTipoNF $ "NC","A7_PRODUTO","A5_PRODUTO")
			cCampo2 := If(!cTipoNF $ "NC","A7_FILIAL","A5_FILIAL")
			cCampo3 := If(!cTipoNF $ "NC","A7_CLIENTE","A5_FORNECE")
			cCampo4 := If(!cTipoNF $ "NC","A7_LOJA","A5_LOJA")
			cCampo5 := If(!cTipoNF $ "NC","A7_CODCLI","A5_CODPRF")
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Grava os Dados da DANFE ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cCNPJTran  := ""
			cCodTransp := ""
			cPlacaTran := ""
			nVolume    := 0
			cEspecie   := ""
			nPesoLiq   := 0
			nPesoBruto := 0
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Prepara o Array aEspVol para gravar os campos Vol/Esp ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			aAdd(aEspVol,{"DS_ESPECI1",""})
			aAdd(aEspVol,{"DS_ESPECI2",""})
			aAdd(aEspVol,{"DS_ESPECI3",""})
			aAdd(aEspVol,{"DS_ESPECI4",""})
			aAdd(aEspVol,{"DS_VOLUME1",0})
			aAdd(aEspVol,{"DS_VOLUME2",0})
			aAdd(aEspVol,{"DS_VOLUME3",0})
			aAdd(aEspVol,{"DS_VOLUME4",0})
			If ValType(XmlChildEx(oXML:_InfNFe,"_TRANSP")) == "O"
				If ValType(XmlChildEx(oXML:_InfNFe:_Transp,"_TRANSPORTA")) == "O"
					If ValType(XmlChildEx(oXML:_InfNFe:_Transp:_Transporta,"_CPF")) == "O"
						cCNPJTran := oXML:_InfNfe:_Transp:_Transporta:_CPF:Text
					ElseIf ValType(XmlChildEx(oXML:_InfNFe:_Transp:_Transporta,"_CNPJ")) == "O"
						cCNPJTran := oXML:_InfNfe:_Transp:_Transporta:_CNPJ:Text
					EndIf
					SA4->(dbSetOrder(3))
					If SA4->(dbSeek(xFilial("SA4")+cCNPJTran))
						cCodTransp := SA4->A4_COD
					EndIf
				EndIf
				If ValType(XmlChildEx(oXML:_InfNFe:_Transp,"_VEICTRANSP")) == "O"
					If ValType(XmlChildEx(oXML:_InfNFe:_Transp:_VeicTransp,"_PLACA")) == "O"
						cPlacaTran := oXML:_InfNFe:_Transp:_VeicTransp:_Placa:Text
					EndIf
				EndIf
				If ValType(XmlChildEx(oXML:_InfNFe:_Transp,"_VOL")) == "O"
					aQtdVol := {oXML:_InfNfe:_Transp:_Vol}
				ElseIf ValType(XmlChildEx(oXML:_InfNFe:_Transp,"_VOL")) == "A"
					aQtdVol := oXML:_InfNfe:_Transp:_Vol
				EndIf
				For nX := 1 To Len(aQtdVol)
					If ValType(XmlChildEx(aQtdVol[nX],"_PESOB")) == "O"
						nPesoBruto += Val(aQtdVol[nX]:_PESOB:TEXT)
					EndIf
					If ValType(XmlChildEx(aQtdVol[nX],"_PESOL")) == "O"
						nPesoLiq += Val(aQtdVol[nX]:_PESOL:TEXT)
					EndIf
					If nX <= 4
						If ValType(XmlChildEx(aQtdVol[nX],"_ESP")) == "O"
							aEspVol[nX][2] := aQtdVol[nX]:_Esp:TEXT
						EndIf
						If ValType(XmlChildEx(aQtdVol[nX],"_QVOL")) == "O"
							aEspVol[nX+4][2] := Val(aQtdVol[nX]:_QVol:TEXT)
						EndIf
					EndIf
				Next nX
			EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Valida tag da data de emissao      ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If ValType(XmlChildEx(oXML:_InfNfe:_Ide,"_DEMI")) == "O"
				dEmis := StoD(StrTran(AllTrim(oXML:_InfNfe:_Ide:_DEmi:Text),"-",""))
			ElseIf ValType(XmlChildEx(oXML:_InfNfe:_Ide,"_DHEMI")) == "O"
				dEmis := StoD(StrTran(Substr((oXML:_InfNfe:_Ide:_DhEmi:Text),1,10),"-",""))
			EndIf
			nSisTot := Val(oXML:_INFNFE:_TOTAL:_ICMSTOT:_vSeg:TEXT)+Val(oXML:_INFNFE:_TOTAL:_ICMSTOT:_vSeg:TEXT)+Val(oXML:_INFNFE:_TOTAL:_ICMSTOT:_vOutro:TEXT)
	
			// Verifica se mesma raiz de CNPJ, se sim trata-se de uma transferencia | Dilson (23-10-2018)
			IF SUBS(SM0->M0_CGC,1,8) == SUBS(cCGC,1,8)
				cSerie := STRZERO(VAL(cSerie),TamSX3("DS_SERIE")[1]) //	Adiciona zeros na serie 
			ENDIF
	
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Grava os Dados do Cabecalho - SDS  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			DbSelectArea("SDS")
			AADD(aHeadSDS,{ {"DS_FILIAL"	,xFilial("SDS")																     	},; //Filial
			{"DS_CNPJ"		,cCGC																				},; //CGC
			{"DS_DOC"		,cDoc 																				},; //Numero do Documento
			{"DS_SERIE"		,cSerie 																			},; //Serie
			{"DS_FORNEC"	,cCodigo																			},; //Fornecedor
			{"DS_LOJA"		,cLoja 																				},; //Loja do Fornecedor
			{"DS_EMISSA"	,Iif(!cEstado=="EX", dEmis, dDataBase)   											},; //Data de Emissão
			{"DS_EST"		,oXML:_INFNFE:_EMIT:_ENDEREMIT:_UF:TEXT												},; //Estado de emissao da NF
			{"DS_TIPO"		,cTipoNF													 						},; //Tipo da Nota
			{"DS_FORMUL"	,Iif(!cEstado=="EX", "N", "S")												 		},; //Formulario proprio
			{"DS_ESPECI"	,"SPED"																		  		},; //Especie
			{"DS_ARQUIVO"	,AllTrim(cFile)																   		},; //Arquivo importado
			{"DS_STATUS"	,If(cTipoNF <> "N" .or. cEstado=="EX" ,IIf(cEstado=="EX",cStatus,cTipoNF) ," ")		},; //Status
			{"DS_CHAVENF"	,Right(AllTrim(oXML:_InfNfe:_Id:Text),44)											},; //Chave de Acesso da NF
			{"DS_VERSAO"	,oXML:_InfNfe:_versao:text 															},; //Versão
			{"DS_USERIMP"	,IIf(!lJob,cUserName,"Job" )														},; //Usuario na importacao
			{"DS_DATAIMP"	,dDataBase																			},; //Data importacao do XML
			{"DS_STAPED"	,"1"	    																		},; //Status pedido
			{"DS_HORAIMP"	,SubStr(Time(),1,5)																	},; //Hora importacao XML
			{"DS_FRETE"		,Val(oXML:_INFNFE:_TOTAL:_ICMSTOT:_vFrete:TEXT)									    },; //Valor Frete
			{"DS_SEGURO"	,Val(oXML:_INFNFE:_TOTAL:_ICMSTOT:_vSeg:TEXT)										},; //Valor Seguro
			{"DS_DESPESA"	,Val(oXML:_INFNFE:_TOTAL:_ICMSTOT:_vOutro:TEXT)								     	},; //Valor Desconto
			{"DS_DESCONTO"	,Val(oXML:_INFNFE:_TOTAL:_ICMSTOT:_vDesc:TEXT)										},; //Valor Desconto
			{"DS_VALMERC"	,Val(oXML:_INFNFE:_TOTAL:_ICMSTOT:_vProd:TEXT)										},; //Valor Mercadoria
			{"DS_TPFRETE"	,cTipoFrete																			},; //Tipo de Frete
			{"DS_TRANSP"	,cCodTransp																			},; //Codigo da Transportadora
			{"DS_PLACA"		,cPlacaTran																			},; //Placa
			{"DS_PLIQUI"	,nPesoLiq																			},; //Peso Liquido
			{"DS_PBRUTO"	,nPesoBruto																			},; //Peso Bruto
			{"DS_ESPECI1"	,cValToChar(aEspVol[1][2])															},; //Especie1
			{"DS_VOLUME1"	,aEspVol[5][2]																		},; //Volume1
			{"DS_ESPECI2"	,cValToChar(aEspVol[2][2])															},; //Especie2
			{"DS_VOLUME2"	,aEspVol[6][2]																		},; //Volume2
			{"DS_ESPECI3"	,cValToChar(aEspVol[3][2])															},; //Especie3
			{"DS_VOLUME3"	,aEspVol[7][2]																		},; //Volume3
			{"DS_ESPECI4"	,cValToChar(aEspVol[4][2])															},; //Especie4
			{"DS_XMLDOC"	,Iif(!cEstado=="EX", "", cDocXML)													},; //Doc do XML de importação
			{"DS_XMLSER"	,Iif(!cEstado=="EX", "", cSerie)													},; //Serie do XML de importação
			{"DS_NFXML"     ,cXML                              													},; //XML
			{"DS_VOLUME4"	,aEspVol[8][2]																		}}) //Volume4
			
			
			For nX := 1 To Len(aItens)
				cProduto  := AllTrim(aItens[nX]:_Prod:_cProd:Text)
				cProduto2 := ""
				
				cAliasQry := CriaTrab( , .F. )
				// CDS 14/08/2017 - Chamado 8868
				cQuery := "SELECT " +cCampo1 +" FROM " +RetSqlName(If(!cTipoNF $ "NC","SA7","SA5"))
				cQuery += " WHERE D_E_L_E_T_ <> '*' AND "
				// CDS 14/08/2017 - Chamado 8868
				cQuery += cCampo2 +" = '" +xFilial(If(!cTipoNF $ "NC","SA7","SA5")) +"' AND "
				cQuery += cCampo3 +" = '" +cCodigo +"' AND "
				cQuery += cCampo4 +" = '" +cLoja +"' AND "
				cQuery += cCampo5 +" = '" +cProduto +"'"
				
				If Select(cAliasQry) > 0
					(cAliasQry)->(dbCloseArea())
				EndIf
				
				DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),cAliasQry,.F.,.T.)
				DbSelectArea(cAliasQry)
				
				If !(cAliasQry)->(EOF())
					cProduto2 := (cAliasQry)->(&cCampo1)
				Else
					If lJob
						_nContProd++
						ConOut(Replicate("=",80))
						ConOut("ACOMR07 Error:")
						ConOut("Arquivo: " +cFile)
						// CDS 14/08/2017 - Chamado 8868
						ConOut("Ocorrencia: " +If(!cTipoNF $ "NC","fornecedor ","cliente ") +cCodigo +"/" +cLoja;
						+" sem cadastro de Produto X " +If(cTipoNF $ "NC","Fornecedor","Cliente");
						+" para o codigo " +cProduto +".")
						ConOut(Replicate("=",80))
					Else
						If _nContProd == 0
							If lProXFor
								_nContProd++
							Else
								//-- Move arquivo para pasta dos erros
								cArqTXT := DIRXML+DIRALER+cFile
								//copia o arquivo antes da transacao
								cNomNovArq  := DIRERRO+cFile
								If MsErase(cNomNovArq)
									__CopyFile(cArqTXT,cNomNovArq)
									FErase(DIRXML+DIRALER+cFile)
								EndIf
								lProces := .F.
								Exit
							EndIf
						EndIf
					EndIf
				EndIf
				
				(cAliasQry)->(dbCloseArea())
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Verifica se existe a Tag para os valores de frete/seguro/despesa³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				nFretItem  := 0
				nDespItem  := 0
				nSegItem   := 0
				nDescItem  := 0
				If ValType(XmlChildEx(aItens[nX]:_Prod,"_VFRETE")) == "O"
					nFretItem := Val(aItens[nX]:_Prod:_vFrete:Text)
				EndIf
				If ValType(XmlChildEx(aItens[nX]:_Prod,"_VOUTRO")) == "O"
					nDespItem := Val(aItens[nX]:_Prod:_vOutro:Text)
				EndIf
				If ValType(XmlChildEx(aItens[nX]:_Prod,"_VSEG")) == "O"
					nSegItem := Val(aItens[nX]:_Prod:_vSeg:Text)
				EndIf
				If ValType(XmlChildEx(aItens[nX]:_Prod,"_VDESC")) == "O"
					nDescItem := Val(aItens[nX]:_Prod:_vDesc:Text)
				EndIf
				
				nSiscomex := nFretItem+nSegItem+nDescItem
				
				nQuant := Val(aItens[nX]:_Prod:_qCom:Text)
				If (nPrecUni := Val(aItens[nX]:_Prod:_vUnCom:Text)) == 0
					If lJob
						aAdd(aErros,{cFile,"Nota fiscal possui itens com valor zerado","Verifique a nota recebida do fornecedor."})	// ./
					ElseIf !lMensExib
						Aviso("Erro",cFile + " " + "Nota fiscal possui itens com valor zerado",{"OK"},2,"ImpXML_NFe")
						lMensExib := .T.
					EndIf
					lProces := .F.
				EndIf
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Ponto de entrada para validar o pedido de compra do XML         ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				/*
				If lProces .And. ExistBlock("COM10PC") .And. cTipoNF $ "NC"
					lCOM10PC := ExecBlock("COM10PC",.F.,.F.,{aItens[nX]})
					If lCOM10PC
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Verifica se existe a Tag para pedido de compra                  ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If ValType(XmlChildEx(aItens[nX]:_Prod,"_XPED")) == "O"
							cPedido := aItens[nX]:_Prod:_xPed:Text
							If Len(cPedido) > TamSx3("DT_PEDIDO")[1]
								cPedido := RIGHT(cPedido,TamSx3("DT_PEDIDO")[1])
							Else
								cPedido := PADR(cPedido,TamSx3("DT_PEDIDO")[1])
							EndIf
						EndIf
						If ValType(XmlChildEx(aItens[nX]:_Prod,"_NITEMPED")) == "O"
							cItemPed:= aItens[nX]:_Prod:_nItemPed:Text
							If Len(cItemPed) > TamSx3("DT_ITEMPC")[1]
								cItemPed := RIGHT(cItemPed,TamSx3("DT_ITEMPC")[1])
							Else
								cItemPed := PADL(cItemPed,TamSx3("DT_ITEMPC")[1],"0")
							EndIf
						EndIf
						If !Empty(cPedido) .And. !Empty(cItemPed)
							DbSelectArea("SC7")
							DbSetOrder(1)
							If MsSeek(xFilial("SC7")+cPedido+cItemPed)
								If	SC7->C7_FORNECE == cCodigo .And. SC7->C7_LOJA == cLoja .And.;
									SC7->C7_PRODUTO == cProduto .And.;
									(SC7->C7_QUANT - SC7->C7_QUJE - SC7->C7_QTDACLA) > 0 .And.;
									SC7->C7_ENCER != "E" .And. SC7->C7_RESIDUO != "S"
									lProces := .T.
								Else
									cPedido := Space(TamSx3("DT_PEDIDO")[1])
									cItemPed:= Space(TamSx3("DT_ITEMPC")[1])
								EndIf
							Else
								If lJob
									aAdd(aErros,{cFile,"Não foi identificado nenhum pedido de compra referente ao item " + cPedido + "-" +cItemPed,"COM10PC"})
								Else
									If !lMensExib
										Aviso("Erro","Não foi identificado nenhum pedido de compra referente ao item " + cPedido + "-" +cItemPed +".",{"OK"},2,"ImpXML_NFe")
										lMensExib := .T.
									EndIf
								EndIf
								lProces := .F.
							EndIf
						Else
							cPedido := Space(TamSx3("DT_PEDIDO")[1])
							cItemPed:= Space(TamSx3("DT_ITEMPC")[1])
						EndIf
					EndIf
				EndIf
				*/
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Verifica se existe a Tag para pedido de compra                  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If ValType(XmlChildEx(aItens[nX]:_Prod,"_XPED")) == "O"
					cPedido := aItens[nX]:_Prod:_xPed:Text
					If Len(cPedido) > TamSx3("DT_PEDIDO")[1]
						cPedido := RIGHT(cPedido,TamSx3("DT_PEDIDO")[1])
					Else
						cPedido := PADR(cPedido,TamSx3("DT_PEDIDO")[1])
					EndIf
				EndIf
				If ValType(XmlChildEx(aItens[nX]:_Prod,"_NITEMPED")) == "O"
					cItemPed:= aItens[nX]:_Prod:_nItemPed:Text
					If Len(cItemPed) > TamSx3("DT_ITEMPC")[1]
						cItemPed := RIGHT(cItemPed,TamSx3("DT_ITEMPC")[1])
					Else
						cItemPed := PADL(cItemPed,TamSx3("DT_ITEMPC")[1],"0")
					EndIf
				EndIf
				
				If ExistBlock("COM10PC")
					l140VPed := .F.
					a140VPed := ExecBlock("COM10PC",.F.,.F.,{cCodigo,cLoja,cProduto,cProduto2,nQuant,nPrecUni,aCom10PC})
					If ValType(a140VPed) == "A" .And. Len(a140VPed) > 0 .And. Len(a140VPed[1]) >= 3
						
						If Len(a140PedAux) == 0
							For nI := 1 To Len(a140VPed)
								aAdd(a140PedAux,{a140VPed[nI,1],a140VPed[nI,2],a140VPed[nI,3],a140VPed[nI,4],a140VPed[nI,5]})
							Next nI
						Else
							For nI := 1 To Len(a140PedAux)
								nPos140Ped := aScan(a140VPed,{|x| AllTrim(x[1]) + AllTrim(x[2]) == AllTrim(a140PedAux[nI,1]) + AllTrim(a140PedAux[nI,2])})
								If nPos140Ped > 0
									aDel(a140VPed,nPos140Ped)
									aSize(a140VPed,Len(a140VPed)-1)
								Endif
							Next nI
						Endif
						
						If Len(a140VPed) == 1
							nQtdVPed := 0
							For nI := 1 To Len(a140VPed)
								nQtdVPed += a140VPed[nI,3]
								
								lValQtd := Iif(Len(a140VPed[nI]) > 3, a140VPed[nI,4], .T.) // Verifica se valida a quantidade do pedido de compra.
							Next nI
							
							If nQtdVPed > nQuant .And. lValQtd
								If lJob
									aAdd(aErros,{cFile,"COMR07 - " + "Quantidade nos Pedidos (COM10PC) é maior que a quantidade do XML","Verificar problema"})
								ElseIf !lMensExib
									Aviso("",cFile + " " + "Quantidade nos Pedidos (COM10PC) é maior que a quantidade do XML",{"Verificar problema"},2,"ImpXML_NFe")
									lMensExib := .T.
								EndIf
								aAdd(aErroErp,{cFile,"COMR07"})
								lProces := .F.
							Elseif nQtdVPed < nQuant
								aAdd(a140VPed,{"","",nQuant-nQtdVPed})
							Else
								cPedido	    := a140VPed[1,1]
								cItemPed	:= a140VPed[1,2]
								If Empty(cProduto2)
									cProduto2   := a140VPed[1,5]
								EndIf	
							Endif
							l140VPed := .T.
						Elseif Len(a140VPed) > 1
							nQtdVPed := 0
							For nI := 1 To Len(a140VPed)
								nQtdVPed += a140VPed[nI,3]
								
								lValQtd := Iif(Len(a140VPed[nI]) > 3, a140VPed[nI,4], .T.) // Verifica se valida a quantidade do pedido de compra.
							Next nI
							
							If nQtdVPed > nQuant .And. lValQtd
								If lJob
									aAdd(aErros,{cFile,"COMR07 - " + "Quantidade nos Pedidos (COM10PC) é maior que a quantidade do XML",}) 
								ElseIf !lMensExib
									Aviso("",cFile + " " + "Quantidade nos Pedidos (COM10PC) é maior que a quantidade do XML",{"Verificar problema"},2,"ImpXML_NFe") 
									lMensExib := .T.
								EndIf
								aAdd(aErroErp,{cFile,"COMR07"})
								lProces := .F.
							Elseif nQtdVPed < nQuant
								aAdd(a140VPed,{"","",nQuant-nQtdVPed})
							Endif
							l140VPed := .T.
						Endif
						
					Endif
				EndIf
				
				If !Empty(cPedido) .And. !Empty(cItemPed)
					DbSelectArea("SC7")
					DbSetOrder(1)
					If MsSeek(xFilial("SC7")+cPedido+cItemPed)
						If	SC7->C7_FORNECE == cCodigo .And. SC7->C7_LOJA == cLoja .And.;
							SC7->C7_PRODUTO == If(.NOT.Empty(cProduto2),cProduto2,cProduto) .And.; //MH 
							(SC7->C7_QUANT - SC7->C7_QUJE - SC7->C7_QTDACLA) > 0 .And.;
							SC7->C7_ENCER != "E" .And. SC7->C7_RESIDUO != "S"
							lProces := .T.
						Else
							cPedido := Space(TamSx3("DT_PEDIDO")[1])
							cItemPed:= Space(TamSx3("DT_ITEMPC")[1])
						EndIf
					Else
						cPedido := Space(TamSx3("DT_PEDIDO")[1])
						cItemPed:= Space(TamSx3("DT_ITEMPC")[1])
					EndIf
				Else
					cPedido := Space(TamSx3("DT_PEDIDO")[1])
					cItemPed:= Space(TamSx3("DT_ITEMPC")[1])
				EndIf
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Verifica se Unid. Medida foi preenchida na relacao Prod. x Forn. ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				// CDS 14/08/2017 - Chamado 8868
				If cTipoNF $ "NC"
					If SA5->(DbSeek(xFilial("SA5")+cCodigo+cLoja+cProduto)) .And. SA5->A5_UMNFE == "2"
						nQuant := ConvUM(cProduto,Val(aItens[nX]:_Prod:_qCom:Text),Val(aItens[nX]:_Prod:_qCom:Text),1)
						SB1->(dbSetOrder(1))
						If SB1->(dbSeek(xFilial("SB1")+cProduto))
							nPrecUni := If(SB1->B1_TIPCONV == "M", (nPrecUni*SB1->B1_CONV), (nPrecUni/SB1->B1_CONV))
						EndIf
					EndIf
				ElseIf cTipoNF $ "B*D"
					If SA7->(DbSeek(xFilial("SA7")+cCodigo+cLoja+cProduto)) .And. SA7->A7_UMNFE == "2"
						nQuant := ConvUM(cProduto,Val(aItens[nX]:_Prod:_qCom:Text),Val(aItens[nX]:_Prod:_qCom:Text),1)
						SB1->(dbSetOrder(1))
						If SB1->(dbSeek(xFilial("SB1")+cProduto))
							nPrecUni := If(SB1->B1_TIPCONV == "M", (nPrecUni*SB1->B1_CONV), (nPrecUni/SB1->B1_CONV))
						EndIf
					EndIf
				EndIf
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Dados dos Itens - SDT	   ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				DbSelectArea("SDT")
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³  DADOS DO PRODUTO      ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				AADD(aItemSDT,{ {"DT_FILIAL" 	,xFilial("SDT")														},; //Filial
				{"DT_CNPJ"		,cCGC																},; //CGC
				{"DT_COD"		,cProduto2		                     								},; //Codigo do produto
				{"DT_PRODFOR"	,aItens[nX]:_PROD:_CPROD:TEXT										},; //Cdgo do pduto do Fornecedor
				{"DT_DESCFOR"   ,aItens[nX]:_PROD:_XPROD:TEXT										},; //Dcao do pduto do Fornecedor
				{"DT_ITEM"   	,PadL(aItens[nX]:_nItem:Text,TamSX3("D1_ITEM")[1],"0")				},; //Item
				{"DT_QUANT"  	,IIF(cTipoNF == "C",0,nQuant)    									},; //Qtde
				{"DT_VUNIT"		,IIF(cTipoNF == "C",Val(aItens[nX]:_Prod:_vProd:Text),nPrecUni)	    },; //Vlor Unitário
				{"DT_FORNEC"	,cCodigo															},; //Forncedor
				{"DT_LOJA"   	,cLoja																},; //Lja
				{"DT_DOC"    	,cDoc																},; //DocmTo
				{"DT_SERIE"		,cSerie							   									},; //Serie
				{"DT_VALFRE"	,Iif(cEstado=="EX",nSiscomex,nFretItem)								},; //Valor Frete
				{"DT_DESPESA"	, Iif(cEstado=="EX",0,nDespItem)									},; //Valor Despesa
				{"DT_SEGURO"	,nSegItem								  							},; //Valor Seguro
				{"DT_VALDESC"	,nDescItem															},; //Valor Desconto
				{"DT_TOTAL"		,IIF(cTipoNF == "C",Val(aItens[nX]:_Prod:_vProd:Text),(nQuant * nPrecUni))},; //Vlor Total
				{"DT_TPIMP"		,Iif(cEstado=="EX",oXML:_INFNFE:_IDE:_TPIMP:TEXT,"")                                          },;//0=Declaraçao de importaçao;1=Declaraçao simplificada de importaçao
				{"DT_NDI"		,Iif(cEstado=="EX",aItens[nX]:_PROD:_DI:_NDI:TEXT,"")                                         },;//No. da DI/DA
				{"DT_BSPIS"		,Iif(cEstado=="EX",Val(aItens[nX]:_IMPOSTO:_PIS:_PISALIQ:_VBC:TEXT),0)                        },;//Base PIS importação
				{"DT_ALPIS"		,Iif(cEstado=="EX",Val(aItens[nX]:_IMPOSTO:_PIS:_PISALIQ:_PPIS:TEXT),0)                       },;//Alíquota PIS importação
				{"DT_VLPIS"		,Iif(cEstado=="EX",Val(aItens[nX]:_IMPOSTO:_PIS:_PISALIQ:_VPIS:TEXT),0)                       },;//Valor PIS importação
				{"DT_BSCOF"		,Iif(cEstado=="EX",Val(aItens[nX]:_IMPOSTO:_COFINS:_COFINSALIQ:_VBC:TEXT),0)                  },;//Base Cofins importação
				{"DT_ALCOF"		,Iif(cEstado=="EX",Val(aItens[nX]:_IMPOSTO:_COFINS:_COFINSALIQ:_PCOFINS:TEXT),0)              },;//Alíquota Cofins importa.
				{"DT_VLCOF"		,Iif(cEstado=="EX",Val(aItens[nX]:_IMPOSTO:_COFINS:_COFINSALIQ:_VCOFINS:TEXT),0)              },;//Valor Cofins importação
				{"DT_LOCDES"	,Iif(cEstado=="EX",SubStr(aItens[nX]:_PROD:_DI:_XLOCDESEMB:TEXT,1,TamSX3("DT_LOCDES")[1]),"") },;//Descricao do Local
				{"DT_UFDES"		,Iif(cEstado=="EX",aItens[nX]:_PROD:_DI:_UFDESEMB:TEXT,"")                                    },;//UF Desembara
				{"DT_DTDI"		,Iif(cEstado=="EX",StoD(LEFT(aItens[nX]:_PROD:_DI:_DDI:TEXT,4)+SubStr(aItens[nX]:_PROD:_DI:_DDI:TEXT,6,2)+Right(aItens[nX]:_PROD:_DI:_DDI:TEXT,2)),StoD("")) },;//Registro D.I.
				{"DT_DTDES"		,Iif(cEstado=="EX",StoD(LEFT(aItens[nX]:_PROD:_DI:_DDI:TEXT,4)+SubStr(aItens[nX]:_PROD:_DI:_DDI:TEXT,6,2)+Right(aItens[nX]:_PROD:_DI:_DDI:TEXT,2)),StoD("")) },;//Dt Desembar.
				{"DT_CODEXP"	,Iif(cEstado=="EX",aItens[nX]:_PROD:_DI:_CEXPORTADOR:TEXT,"")                                 },;//Exportador
				{"DT_NADIC"		,Iif(cEstado=="EX",aItens[nX]:_PROD:_DI:_ADI:_NADICAO:TEXT,"")                                },;//Adicao
				{"DT_SQADIC"	,Iif(cEstado=="EX",aItens[nX]:_PROD:_DI:_ADI:_NSEQADIC:TEXT,"")                               },;//Seq Adicao
				{"DT_BCIMP"		,Iif(cEstado=="EX",Val(aItens[nX]:_IMPOSTO:_II:_VBC:TEXT),0)                                  },;//Vlr BC Importacao
				{"DT_DSPAD"		,Iif(cEstado=="EX",Val(aItens[nX]:_IMPOSTO:_II:_VDESPADU:TEXT),0)                             },;//Vlr Desp.Aduaneira
				{"DT_VLRII"		,Iif(cEstado=="EX",Val(aItens[nX]:_IMPOSTO:_II:_VII:TEXT),0)                                  },;//Vlr Imp.Importacao
				{"DT_PEDIDO"	,cPedido                                                                                      },;//Pedido de Compra MH
				{"DT_ITEMPC"	,cItemPed                                                                                      }})//Item do Pedido de Compra MH
			Next nX
			
			If !Empty(aItemSDT) .And. !Empty(aHeadSDS)
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Grava os dados do cabeçalho e itens da nota importada do XML³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				Begin Transaction
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Caso contenha alguma nota com produto em branco DT_COD modificar DS_STATUS X Atualizar produto         ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				//--Grava Itens
				nTotItPed := 0
				For nX:=1 To Len(aItemSDT)
					RecLock("SDT",.T.)
					For nY:=1 To Len(aItemSDT[nX])
						If nY == 3
							If Empty(aItemSDT[nX][nY][2])
								cStatus := 'X'
							EndIf
						EndIf
						// Status com pedido associado
						If aItemSDT[nX,nY,1] == 'DT_PEDIDO'
							If .NOT. Empty(aITEMSDT[nX,nY,2])
								nTotItPed++
							Endif
						Endif
						SDT->&(aItemSDT[nX][nY][1]):= aItemSDT[nX][nY][2]
					Next
					dbCommit()
					MsUnlock()
				Next
				
				//--Grava cabeçalho
				aHeadSDS:=aHeadSDS[1]
				RecLock("SDS",.T.)
				For nX:=1	To Len(aHeadSDS)
					If aHeadSDS[nX][1] == 'DS_STATUS'
						If cStatus == 'X' 
							aHeadSDS[nX][2] := cStatus
						EndIf
					EndIF
					// Status com pedido associado se todos os itens tiverem pedido - MH
					If aHeadSDS[nX][1] == 'DS_STAPED'
						If nTotItPed = Len(aItemSDT)
							aHeadSDS[nX][2] := "2"
						Endif	
					Endif
					SDS->&(aHeadSDS[nX][1]):= aHeadSDS[nX][2]
				Next
				dbCommit()
				MsUnlock()
				
				cArqTXT := DIRXML+DIRALER+cFile
				//copia o arquivo antes da transacao
				cNomNovArq  := c3StartPath+cFile
				If MsErase(cNomNovArq)
					__CopyFile(cArqTXT,cNomNovArq)
					FErase(DIRXML+DIRALER+cFile)
				EndIf
				lImport := .T.
				End Transaction
				
			Else
				//-- Move arquivo para pasta dos erros
				cArqTXT := DIRXML+DIRALER+cFile
				//copia o arquivo antes da transacao
				cNomNovArq  := DIRERRO+cFile
				If MsErase(cNomNovArq)
					__CopyFile(cArqTXT,cNomNovArq)
					FErase(DIRXML+DIRALER+cFile)
				EndIf
			EndIf
			
		Else
			//-- Move arquivo para pasta dos erros
			cArqTXT := DIRXML+DIRALER+cFile
			//copia o arquivo antes da transacao
			cNomNovArq  := DIRERRO+cFile
			If MsErase(cNomNovArq)
				__CopyFile(cArqTXT,cNomNovArq)
				FErase(DIRXML+DIRALER+cFile)
			EndIf
		EndIf
	EndIf
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³RETORNA FILIAL DE ORIGEM³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cEmpAnt := cEmpBkp  
cFilAnt := cFilBkp

cError    := ""
lFound    := .F.

Return lImport

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fornece_dupli ºAutor  ³Felipi Marques  º Data ³  06/25/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Analisa se exixte cnpj duplicado na base                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function  fornece_dupli(cCGC,cEstado)

Local nCount   := 1
Local lRet     := .F.
Local cQuery   := ""
Local cAlias1 := GetNextAlias()

// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// |  MONTA QUERY   |
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cQuery += " SELECT COUNT(*) TOTAL "
cQuery += " FROM " + RetSqlName("SA2") + " SA2 "
cQuery += " WHERE A2_CGC = '"+cCGC +"' AND D_E_L_E_T_ = ' ' AND A2_FILIAL = '"+xFilial("SA2")+"' AND A2_MSBLQL = '2' "  
cQuery := ChangeQuery(cQuery)
dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery),cAlias1, .T., .T.)   

(cAlias1)->(dbGoTop())
If !(cAlias1)->(Eof())
	If (cAlias1)->TOTAL > nCount 
		lRet := .T.
	EndIf
EndIf
(cAlias1)->(dbCloseArea())

Return(lRet)


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fMaqCid   ºAutor  ³Felipi Marques      º Data ³  06/27/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Selecionar ou Mostrar os Registros Selecionados           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function BuscaCLI(cCGC)

Local nTam			:= TamSX3("A2_COD")[1]+TamSX3("A2_LOJA")[1]+1
Local aCat	      	:= {}
Local cMvRet		  	:= SPACE( TamSX3("A2_COD")[1] + TamSX3("A2_LOJA")[1]+1 )
Local MvPar			:= ""
Local cTitulo		:= "CODIGO/LOJA   -  NOME FORNECEDOR"
Local MvParDef  	:= ""
Local cVolta		:= ""
Local cF3           := ""
Local cQuery        := ""                                            
Local aCliLj        := {}

// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// |  MONTA QUERY   |
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cQuery += " SELECT A2_COD+'/'+A2_LOJA AS A2_COD , A2_NOME AS A2_NOME"
cQuery += " FROM " + RetSqlName("SA2") + " SA2 "
cQuery += " WHERE A2_CGC = '"+cCGC+"' AND D_E_L_E_T_ = ' ' AND A2_FILIAL = '"+xFilial("SA2")+"' AND A2_MSBLQL = '2' "
cQuery := ChangeQuery(cQuery)


if select("TRC")>0
	TRC->(dbCloseArea())
endif

TCQuery cQuery ALIAS "TRC" NEW

If TRC->(!EOF())
	while ! TRC->(EOF())
		aadd(aCat,ALLTRIM(UPPER(TRC->A2_COD))+" - "+AllTrim(TRC->A2_NOME))
		MvParDef += TRC->A2_COD
		TRC->(dbSkip())
	end
Else
		MsgInfo("TABELA AC NAO CADASTRADA!")
EndIf

//----------------------------------------------------------------------
// Executa f_Opcoes para Selecionar ou Mostrar os Registros Selecionados
//----------------------------------------------------------------------
f_Opcoes(       @MvPar      ,;    //Variavel de Retorno
				cTitulo     ,;    //Titulo da Coluna com as opcoes
				@aCat       ,;    //Opcoes de Escolha (Array de Opcoes)
				@MvParDef   ,;    //String de Opcoes para Retorno
				NIL         ,;    //Nao Utilizado
				NIL         ,;    //Nao Utilizado
				.T.         ,;    //Se a Selecao sera de apenas 1 Elemento por vez
				nTam        ,;    //Tamanho da Chave
				Len(aCat)   ,;    //No maximo de elementos na variavel de retorno
				.T.         ,;    //Inclui Botoes para Selecao de Multiplos Itens
				.F.         ,;    //Se as opcoes serao montadas a partir de ComboBox de Campo ( X3_CBOX )
				NIL         ,;    //Qual o Campo para a Montagem do aOpcoes
				.F.         ,;    //Nao Permite a Ordenacao
				.F.         ,;    //Nao Permite a Pesquisa
				.T.         ,;    //Forca o Retorno Como Array
				cF3         ;    //Consulta F3
)

//Carregar array
If Len(MvPar) <> 0
	For i:=1 to Len(MvPar)
		cCliente :=  SubStr(MvPar[1], 1, RAt("/", MvPar[1]))
		cLoja    := AllTrim(SubStr(MvPar[1], RAt("/", MvPar[1])+1, TamSX3("A2_LOJA")[1] )) 
		//Trata para tirar o ultimo caracter
		If !Empty(cCliente)
			cCliente := SubStr(cCliente,1,Len(cCliente)-1)
		EndIf
		aadd(aCliLj, { cCliente,cLoja} )
	Next
EndIf

Return(aCliLj) 
                                                             
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Inclui_fornecedor ºAutor  ³Felipi Marques º Data³ 08/11/14  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Inclui fornecedor                                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function Inclui_fornecedor()

Local cCepT 	:= ""
Local cRecpis	:= ""
Local cRecCof	:= ""
Local cRecCsl	:= ""
Local cCalcIR	:= ""
Local GRTRIB	:= ""
Local cEstado   := ""
Local cGRTRIB   := ""
Local CCOMPLEM  := ""
Local cPessoa   := ""
Local aDestFor  := {}
Local cCod      
/*
DbSelectarea('SA2')
SA2->(dbSetorder(3))
If SA2->(dbSeek(xFilial("SA2")+Substr(Alltrim(cCGC),1,8))) //Verifica se o forncecedor não é uma filial 
	cCod  := SA2->A2_COD
	If Substr(Alltrim(cCGC),9,5) <> Substr(SA2->A2_CGC,9,5)
		While SA2->(!Eof()) .and. SA2->A2_COD == cCod
			cLoja		:=	Soma1(SA2->A2_LOJA) //carrega loja novo cliente
			cCod		:=	SA2->A2_COD
			SA2->(dbSkip())
		Enddo 
		cLoja		:=	Soma1(SA2->A2_LOJA)
	EndIf
	
Else
	cCod := Getsxenum('SA2','A2_COD')
	cLoja:= '01'
EndIf
*/
cCod := Getsxenum('SA2','A2_COD')
cLoja:= '01'

cEstado := oXML:_INFNFE:_DEST:_ENDERDEST:_UF:TEXT	
If cEstado == "EX" 
	cCepT 		:= "00000000"
	cRecpis		:= "2"
	cRecCof   	:= "2"
	cRecCsl    	:= "2"
	cCalcIR    	:= "1"
	cGRTRIB    	:= "001"
	cCEP 	   	:= '' 
	cPessoa	   	:= "X"
	cNOME      	:= UPPER(oXML:_INFNFE:_DEST:_XNOME:TEXT)
	cNREDUZ    	:= UPPER(oXML:_INFNFE:_DEST:_XNOME:TEXT)
	cEND       	:= UPPER(oXML:_INFNFE:_DEST:_ENDERDEST:_XLGR:TEXT)
	cNUM       	:= UPPER(oXML:_INFNFE:_DEST:_ENDERDEST:_NRO:TEXT)
	cBAIRRO    	:= UPPER(oXML:_INFNFE:_DEST:_ENDERDEST:_XBAIRRO:TEXT)
	cMUN       	:= UPPER(oXML:_INFNFE:_DEST:_ENDERDEST:_XMUN:TEXT)
	cINSCR     	:= ""
	cCOD_MUN   	:= "99999"
	cCEP       	:= "99999999"
Else
	cNOME      	:= UPPER(oXML:_INFNFE:_EMIT:_XNOME:TEXT)
	cNREDUZ    	:= UPPER(oXML:_INFNFE:_EMIT:_XNOME:TEXT)
	cEND       	:= UPPER(oXML:_INFNFE:_EMIT:_ENDEREMIT:_XLGR:TEXT)
	cNUM       	:= UPPER(oXML:_INFNFE:_EMIT:_ENDEREMIT:_NRO:TEXT)
	cBAIRRO    	:= UPPER(oXML:_INFNFE:_EMIT:_ENDEREMIT:_XBAIRRO:TEXT)
	cMUN       	:= UPPER(oXML:_INFNFE:_EMIT:_ENDEREMIT:_XMUN:TEXT)
	cINSCR     	:= UPPER(oXML:_INFNFE:_EMIT:_IE:TEXT)
	cCOD_MUN   	:= SUBSTR(oXML:_INFNFE:_EMIT:_ENDEREMIT:_CMUN:TEXT,3,5)
	cCGC       	:= UPPER(oXML:_INFNFE:_EMIT:_CNPJ:TEXT) 
	cCEP       	:= UPPER(oXML:_INFNFE:_EMIT:_ENDEREMIT:_CEP:TEXT)
EndIf


if val(cNUM) # 0 // Se numero for valido, sera inserido no endereco, caso contrario sera inserido no complemento
	cEND := STRTRAN(cEND,",",".")
	cEND += ", "+cNUM
else
	cCOMPLEM := cNUM
endif

cTIPO      := IF(LEN(cCGC)=11,'F','J')

DbSelectarea('SA2')

aDestFor  := {      {"A2_FILIAL"     ,xFilial("SA2")    ,Nil},;
					{"A2_COD"       ,cCod    			,Nil},;
					{"A2_LOJA"      ,cLoja   			,Nil},;
					{"A2_TPESSOA"	,cPessoa 			,Nil},;
					{"A2_CGC"       ,cCGC    			,Nil},;
					{"A2_CEP"       ,cCEP    			,Nil},;
					{"A2_EST"       ,cESTADO 			,Nil},;
					{"A2_END"       ,cEND    			,Nil},;
					{"A2_BAIRRO"    ,cBAIRRO 			,Nil},;
					{"A2_COD_MUN"   ,cCOD_MUN 			,Nil},;
					{"A2_MUN"       ,cMUN    			,Nil},;
					{"A2_COMPLEM"   ,cCOMPLEM			,Nil},;
					{"A2_INSCR"     ,cINSCR  			,Nil},;
					{"A2_NOME"      ,cNOME   			,Nil},;
					{"A2_NREDUZ"    ,cNREDUZ 			,Nil},;
					{"A2_TIPO"      ,cTIPO   			,Nil}}


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Grava cadastro do fornecedor.                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RecLock("SA2",.T.)
For nX := 1 To Len(aDestFor)	
	SA2->&(aDestFor[nX,1])	:= aDestFor[nX,2]	
Next
MsUnLock() 
ConfirmSX8()

Return .T.

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³inclui_cliente ºAutor  ³Felipi Marques º Data ³  08/11/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Inclusao de cliente                                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static function inclui_cliente() 
                   
Local cCepT 	:= ""
Local cRecpis	:= ""
Local cRecCof	:= ""
Local cRecCsl	:= ""
Local cCalcIR	:= ""
Local GRTRIB	:= ""
Local cEstado   := ""
Local cGRTRIB   := ""
Local CCOMPLEM  := ""
Local cPessoa   := ""
Local aDestFor  := {}
Local cCod      

DbSelectarea('SA1')
SA1->(dbSetorder(3))
If SA1->(dbSeek(xFilial("SA1")+Substr(Alltrim(cCGC),1,8))) //Verifica se o forncecedor não é uma filial 
	cCod  := SA1->A1_COD
	If Substr(Alltrim(cCGC),9,5) <> Substr(SA1->A1_CGC,9,5)
		While SA1->(!Eof()) .and. SA1->A1_COD == cCod
			cLoja		:=	Soma1(SA1->A1_LOJA) //carrega loja novo cliente
			cCod		:=	SA1->A1_COD
			SA1->(dbSkip())
		Enddo
	EndIf
	
Else
	cCod := Getsxenum('SA1','A1_COD')
	cLoja:= '01'
EndIf

cEstado := oXML:_INFNFE:_DEST:_ENDERDEST:_UF:TEXT	
If cEstado == "EX" 
	cCepT 		:= "00000000"
	cRecpis		:= "2"
	cRecCof   	:= "2"
	cRecCsl    	:= "2"
	cCalcIR    	:= "1"
	cGRTRIB    	:= "001"
	cCEP 	   	:= '' 
	cPessoa	   	:= "X"
	cNOME      	:= UPPER(oXML:_INFNFE:_DEST:_XNOME:TEXT)
	cNREDUZ    	:= UPPER(oXML:_INFNFE:_DEST:_XNOME:TEXT)
	cEND       	:= UPPER(oXML:_INFNFE:_DEST:_ENDERDEST:_XLGR:TEXT)
	cNUM       	:= UPPER(oXML:_INFNFE:_DEST:_ENDERDEST:_NRO:TEXT)
	cBAIRRO    	:= UPPER(oXML:_INFNFE:_DEST:_ENDERDEST:_XBAIRRO:TEXT)
	cMUN       	:= UPPER(oXML:_INFNFE:_DEST:_ENDERDEST:_XMUN:TEXT)
	cINSCR     	:= ""
	cCOD_MUN   	:= "99999"
	cCEP       	:= "99999999"
Else
	cNOME      	:= UPPER(oXML:_INFNFE:_EMIT:_XNOME:TEXT)
	cNREDUZ    	:= UPPER(oXML:_INFNFE:_EMIT:_XNOME:TEXT)
	cEND       	:= UPPER(oXML:_INFNFE:_EMIT:_ENDEREMIT:_XLGR:TEXT)
	cNUM       	:= UPPER(oXML:_INFNFE:_EMIT:_ENDEREMIT:_NRO:TEXT)
	cBAIRRO    	:= UPPER(oXML:_INFNFE:_EMIT:_ENDEREMIT:_XBAIRRO:TEXT)
	cMUN       	:= UPPER(oXML:_INFNFE:_EMIT:_ENDEREMIT:_XMUN:TEXT)
	cINSCR     	:= UPPER(oXML:_INFNFE:_EMIT:_IE:TEXT)
	cCOD_MUN   	:= SUBSTR(oXML:_INFNFE:_EMIT:_ENDEREMIT:_CMUN:TEXT,3,5)
	cCGC       	:= UPPER(oXML:_INFNFE:_EMIT:_CNPJ:TEXT) 
	cCEP       	:= UPPER(oXML:_INFNFE:_EMIT:_ENDEREMIT:_CEP:TEXT)
EndIf


if val(cNUM) # 0 // Se numero for valido, sera inserido no endereco, caso contrario sera inserido no complemento
	cEND := STRTRAN(cEND,",",".")
	cEND += ", "+cNUM
else
	cCOMPLEM := cNUM
endif

cTIPO      := IF(LEN(cCGC)=11,'F','J')

DbSelectarea('SA1')

aDestFor  := {      {"A1_FILIAL"     ,xFilial("SA2")    ,Nil},;
					{"A1_COD"       ,cCod    			,Nil},;
					{"A1_LOJA"      ,cLoja   			,Nil},;
					{"A1_TPESSOA"	,cPessoa 			,Nil},;
					{"A1_CGC"       ,cCGC    			,Nil},;
					{"A1_CEP"       ,cCEP    			,Nil},;
					{"A1_EST"       ,cESTADO 			,Nil},;
					{"A1_END"       ,cEND    			,Nil},;
					{"A1_BAIRRO"    ,cBAIRRO 			,Nil},;
					{"A1_COD_MUN"   ,cCOD_MUN 			,Nil},;
					{"A1_MUN"       ,cMUN    			,Nil},;
					{"A1_COMPLEM"   ,cCOMPLEM			,Nil},;
					{"A1_INSCR"     ,cINSCR  			,Nil},;
					{"A1_NOME"      ,cNOME   			,Nil},;
					{"A1_NREDUZ"    ,cNREDUZ 			,Nil},;
					{"A1_TIPO"      ,cTIPO   			,Nil}}


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Grava cadastro do cliente.                                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RecLock("SA1",.T.)
For nX := 1 To Len(aDestFor)	
	SA1->&(aDestFor[nX,1])	:= aDestFor[nX,2]	
Next
MsUnLock()
ConfirmSX8()

Return .T.


/*
Local cEstado   := ""
Local aDestFornecedor := {}
Local cNOME := UPPER(IIF(UPPER(oAuxXML:REALNAME)=="NFEPROC",oXML:_NFEPROC,IIF(UPPER(oAuxXML:REALNAME)=="NFE",oXML,)):_INFNFE:_DEST:_XNOME:TEXT)
Local cEstado:=IIF(UPPER(oAuxXML:REALNAME)=="NFEPROC",oXML:_NFEPROC,IIF(UPPER(oAuxXML:REALNAME)=="NFE",oXML,)):_INFNFE:_DEST:_ENDERDEST:_UF:TEXT

		aDestCliente := {}
		
		lMsErroAuto := .F.
		
		DbSelectarea('SA1')
    	DBSETORDER(3)
        cCod := ""
		cNOME := UPPER(IIF(UPPER(oAuxXML:REALNAME)=="NFEPROC",oXML:_NFEPROC,IIF(UPPER(oAuxXML:REALNAME)=="NFE",oXML,)):_INFNFE:_DEST:_XNOME:TEXT)
		cEstado:=IIF(UPPER(oAuxXML:REALNAME)=="NFEPROC",oXML:_NFEPROC,IIF(UPPER(oAuxXML:REALNAME)=="NFE",oXML,)):_INFNFE:_DEST:_ENDERDEST:_UF:TEXT
		
		IF !(EMPTY(IIf(cEstado=="EX",cCGCDes,cCGC)))
	 		If !(dbSeek(xFilial("SA1")+IIf(cEstado=="EX",cCGCDes,cCGC)))		
				nOpc := 3 //Incluir 		
				cCod := Getsxenum('SA1','A1_COD')
				cLoja:= '01'
			Else
				nOpc:=4 //Altera
				cCod := SA1->A1_COD
				cLoja:= SA1->A1_LOJA
	 		Endif
		ELSE
			DBSETORDER(2)

			If !dbSeek(xFilial("SA1")+SUBSTR(cNOME+SPACE(40),1,40)+'01')
				nOpc := 3 //Incluir 		
				cCod := Getsxenum('SA1','A1_COD')
				cLoja:= '01'
			Else
				nOpc:=4 //Altera
				cCod := SA1->A1_COD
				cLoja:= SA1->A1_LOJA
	 		Endif
		Endif

		//Obs.:Importar tabela de municipios
        dbselectarea('CC2')
        dbsetorder(2)
    	
    	if dbseek(xfilial('CC2')+SUBSTR( IIF(UPPER(oAuxXML:REALNAME)=="NFEPROC",oXML:_NFEPROC,IIF(UPPER(oAuxXML:REALNAME)=="NFE",oXML,)):_INFNFE:_DEST:_ENDERDEST:_CMUN:TEXT,3,5))
			cCOd_Mun:= SUBSTR( IIF(UPPER(oAuxXML:REALNAME)=="NFEPROC",oXML:_NFEPROC,IIF(UPPER(oAuxXML:REALNAME)=="NFE",oXML,)):_INFNFE:_DEST:_ENDERDEST:_CMUN:TEXT,3,5)		
		Else
			cCOd_Mun:= ""
		Endif

		cINSCR := IIF(UPPER(oAuxXML:REALNAME)=="NFEPROC",oXML:_NFEPROC,IIF(UPPER(oAuxXML:REALNAME)=="NFE",oXML,)):_INFNFE:_DEST:_IE:TEXT 

		IF UPPER( IIF(UPPER(oAuxXML:REALNAME)=="NFEPROC",oXML:_NFEPROC,IIF(UPPER(oAuxXML:REALNAME)=="NFE",oXML,)):_INFNFE:_DEST:_ENDERDEST:_UF:TEXT)=="RO" 
			cINSCR := STRZERO(val(cINSCR),14)
		ENDIF
		        
        dbselectarea('CC2')
		dbCloseArea()
                                   
  		cPessoa :=""
		if len(alltrim(IIf(cEstado=="EX",cCGCDes,cCGC)))==11
		   cPessoa="F"
		Else   
		   cPessoa:="J"
		endif
        
        if cEstado == "EX"
			cPessoa := "J"
			cCepT   := "99999999"
		else
			cCepT   := IIF(UPPER(oAuxXML:REALNAME)=="NFEPROC",oXML:_NFEPROC,IIF(UPPER(oAuxXML:REALNAME)=="NFE",oXML,)):_INFNFE:_DEST:_ENDERDEST:_CEP:TEXT
		endif

		aDestCliente:={{"A1_COD"		,cCod        ,Nil},;  
						{"A1_LOJA"		,UPPER(cLoja),Nil},;
     					{"A1_CGC"		,IIf(cEstado=="EX",cCGCDes,cCGC)     ,Nil},;
     					{"A1_PESSOA"	,cPessoa     ,Nil},;
						{"A1_CEP"		,cCepT,Nil},;
						{"A1_END"		,UPPER( IIF(UPPER(oAuxXML:REALNAME)=="NFEPROC",oXML:_NFEPROC,IIF(UPPER(oAuxXML:REALNAME)=="NFE",oXML,)):_INFNFE:_DEST:_ENDERDEST:_XLGR:TEXT),Nil},;
						{"A1_EST"		,UPPER( IIF(UPPER(oAuxXML:REALNAME)=="NFEPROC",oXML:_NFEPROC,IIF(UPPER(oAuxXML:REALNAME)=="NFE",oXML,)):_INFNFE:_DEST:_ENDERDEST:_UF:TEXT),Nil},;
						{"A1_BAIRRO"	,UPPER( IIF(UPPER(oAuxXML:REALNAME)=="NFEPROC",oXML:_NFEPROC,IIF(UPPER(oAuxXML:REALNAME)=="NFE",oXML,)):_INFNFE:_DEST:_ENDERDEST:_XBAIRRO:TEXT),Nil},;
						{"A1_COMPLEM"	,UPPER( IIF(UPPER(oAuxXML:REALNAME)=="NFEPROC",oXML:_NFEPROC,IIF(UPPER(oAuxXML:REALNAME)=="NFE",oXML,)):_INFNFE:_DEST:_ENDERDEST:_XLGR:TEXT+", "+STRTRAN( IIF(UPPER(oAuxXML:REALNAME)=="NFEPROC",oXML:_NFEPROC,IIF(UPPER(oAuxXML:REALNAME)=="NFE",oXML,)):_INFNFE:_DEST:_ENDERDEST:_NRO:TEXT,",",".")),Nil},; 
						{"A1_MUN"		,UPPER( IIF(UPPER(oAuxXML:REALNAME)=="NFEPROC",oXML:_NFEPROC,IIF(UPPER(oAuxXML:REALNAME)=="NFE",oXML,)):_INFNFE:_DEST:_ENDERDEST:_XMUN:TEXT),Nil},;
						{"A1_INSCR"		,IIF(UPPER(oAuxXML:REALNAME)=="NFEPROC",oXML:_NFEPROC,IIF(UPPER(oAuxXML:REALNAME)=="NFE",oXML,)):_INFNFE:_DEST:_IE:TEXT,Nil},; 
						{"A1_NOME"		,UPPER( IIF(UPPER(oAuxXML:REALNAME)=="NFEPROC",oXML:_NFEPROC,IIF(UPPER(oAuxXML:REALNAME)=="NFE",oXML,)):_INFNFE:_DEST:_XNOME:TEXT),Nil},;
						{"A1_NREDUZ"	,UPPER( IIF(UPPER(oAuxXML:REALNAME)=="NFEPROC",oXML:_NFEPROC,IIF(UPPER(oAuxXML:REALNAME)=="NFE",oXML,)):_INFNFE:_DEST:_XNOME:TEXT),Nil},;
						{"A1_GRPTRIB"	,'002',Nil},;
						{"A1_TIPO"	    ,'S',Nil}}  

        IF LEN(cCod_mun) # 0
			AADD(aDestCliente,{"A1_COD_MUN",cCOd_Mun,Nil})
		ENDIF

      	if !(nopc==4)
 			MSExecAuto({|x,y| Mata030(x,y)},aDestCliente,nOpc)
		Endif
		
		If lMsErroAuto
			Mostraerro()
		Else
		   ConfirmSx8()
		Endif

Return  
*/		

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FsLoadTXT ºAutor  ³Felipi Marques      º Data ³  05/18/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao de leitura de arquivo texto para anexar ao XML      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function FsLoadTXT(cFileXml)

Local cTexto     := ""
Local nHandle    := 0
Local nTamanho   := 0
nHandle := FOpen(cFileXml)
If nHandle > 0
	nTamanho := Fseek(nHandle,0,FS_END)
	FSeek(nHandle,0,FS_SET)
	FRead(nHandle,@cTexto,nTamanho)
	FClose(nHandle)
EndIf   

Return(cTexto) 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ACOMR07   ºAutor  ³Felipi Marques      º Data ³  10/17/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function XMLCTe(cFile,lJob,aProc,aErros,oXml,aErroErp,oXMLCanc)
Local cPrdFrete  := ""
Local lRet       := .T.
Local lRemet 	 := .F.
Local lToma3Dest := .F.
Local lCliente	 := .F.
Local lDevSemSF1 := .F.
Local lToma4	 := .F.
Local nX		 := 0
Local nPesoBruto := 0
Local nPesoLiqui := 0    
Local nY		 := 0
Local nCount	 := 0
Local nPos			:= 0
Local cError     := ""
Local cCNPJ_CF	 := ""
Local cFornCTe   := ""
Local cLojaCTe   := ""
Local cNomeCTe   := ""
Local cCodiRem   := ""
Local cLojaRem   := ""
Local cChaveNF   := ""
Local cTES_CT 	 := ""
Local cCPag_CT 	 := ""
Local cTipoFrete := ""
Local cTagDest := ""
local cTagRem		:= ""
Local cQuery	 := ""
Local cTabRem	 := ""
Local cRetPrd	 := ""
Local cMotivo		:= ""
Local aDadosAux  := {}
Local aDadosFor  := Array(2) //-- 1- Codigo; 2-Loja
Local aDadosCli  := Array(2) //-- 1- Codigo; 2-Loja
Local aCabec116	 := {}
Local aItens116	 := {}
Local aAux		 := {}
Local aEspecVol  := {}
Local aAux1		 := {}
Local aAuxCliFor	 := {}
Local aParamPE	 := {}
Local aChave	:= {}
//Local lMt116XmlCt:= ExistBlock("MR07XMLCT")
//Local LMR07XMLCt := ExistBlock("MR07XMLCt")
//Local LMR07CHV	:= ExistBlock("MR07CHV")
//Local lMR07COMP	:= ExistBlock("MR07COMP")
Local cVersao	:= oXML:_InfCte:_Versao:Text
Local nTamFil	:= 0
Local lComp	:= .F. // Indica se CTe é do tipo complementar
Local lFornExt	:= .F.
Local lDevBen	:= .F. // Devolução ou Beneficiamento
Local cSerie	:= ""
Local aA116IDOC	:= {}
Local lCliForDup	:= .F.
Local cChvNFOr	:= ""
Local nDevOri	:= 0
Local nNorOri	:= 0
Local lFornOri := .T.
Local aFornChv	:= {}
Local nPFornChv	:= 0
Local aExcStat 	:= {"100","102","103","104","105","106","107","108","109","110","111","112","113","114","134","135","136","301"}
Local cHrEmis		:= ""
Local lVlrFrtZero	:= .F.
Local nVlrFrt		:= 0
//Local cCFBN		:= SuperGetMv("MV_XMLCFBN",.F.,"")
//Local lRateiaDev	:= SuperGetMv("MV_XMLRATD",.F.,.T.)

Local lPreNota := .T. // (Não Classificado), lPreNota = .F. (Classificado)
//MV_CTECLAS = .F. (Não Classificado), MV_CTECLAS = .T. (Classificado)
//Local lPreNota	:= !SuperGetMV("MV_CTECLAS",.F.,.F.) 

// Variaveis para apuracao do ICMS
Local oICMS
Local oICMSTipo
Local oICMSNode
Local nZ		:= 0
Local nBaseICMS := 0
Local nValICMS	:= 0
Local nAliqICMS	:= 0
Local lBaseICMS := .F.
Local lValICMS	:= .F.
Local lAliqICMS	:= .F.
Local lT4DifDest	:= .F.
Local lT3Exped	:= .F.
Local lT3Remet	:= .F.

Private cCNPJ_CT	 := ""
Private cDoc		:= ""

Default lJob    := .T.
Default aProc   := {}
Default aErros  := {} 
Default aErroERP := {} 


//-- Verifica se o arquivo pertence a filial corrente
lRet := CTe_VldEmp(oXML,SM0->M0_CGC,@lToma3Dest,@lToma4,lJob,cFile,,,@lT4DifDest,@lT3Exped,@lT3Remet,@aErros,@aErroERP)

//Verifica se XML é Cancelado ou Rejeitado.
If lRet .And. ValType(oXMLCanc) <> "U"
	If Valtype(XmlChildEx(oXMLCanc:_infProt,"_CSTAT")) <> "U"
		//Chave CT-e
		cChaveCte	:= Right(AllTrim(oXML:_InfCte:_Id:Text),44)
		
		//Motivo rejeição
		If Valtype(XmlChildEx(oXMLCanc:_infProt,"_XMOTIVO")) <> "U"
			cMotivo := ConvASC(oXMLCanc:_infProt:_xMotivo:Text)  
		Endif
		
		//Busca status
		nPos := aScan(aExcStat,AllTrim(oXMLCanc:_infProt:_cStat:Text))
		
		//Status de cancelado ou rejeitado
		If nPos == 0
			If AllTrim(oXMLCanc:_infProt:_cStat:Text) == "101" //Cancelado
				If !lJob
					Aviso("Erro","CT-e cancelado: " + cChaveCte,{"OK"},2,"ImpXML_CTe")//#"CT-e cancelado
				EndIf
				
				aAdd(aErros,{cFile,"COM036 - CT-e cancelado: " + cChaveCte,""})
				aAdd(aErroErp,{cFile,"COM036"})
				
				lRet := .F.
			Else //Rejeitado
				If !lJob
					Aviso("Erro","CT-e rejeitado: " + cChaveCte + " - Motivo: " + cMotivo,{"OK"},2,"ImpXML_CTe")//"Erro"#"CT-e cancelado
				EndIf
				
				aAdd(aErros,{cFile,"COM037 - CT-e rejeitado: " + cChaveCte + " - Motivo: " + cMotivo,""})
				aAdd(aErroErp,{cFile,"COM037"})
				lRet := .F.
			Endif	
		Endif
	Endif
	
	If Valtype(XmlChildEx(oXMLCanc:_infProt,"_DHRECBTO")) <> "U"
		cHrEmis := Substr(oXMLCanc:_infProt:_DhRecbto:Text,12)
	Endif
Endif

dbSelectArea("SB1")
                                      
//-- Verifica se o ID ja foi processado
If lRet
	SDS->(dbSetOrder(2))
	If lRet .And. SDS->(dbSeek(xFilial("SDS")+Right(AllTrim(oXML:_InfCte:_Id:Text),44)))
		If lJob
			aAdd(aErros,{cFile,"COM019 - " + "ID de CT-e já registrado na NF " +SDS->(DS_DOC+"/"+SerieNfId('SDS',2,'DS_SERIE')); 
							 + "do Fornecedor/Cliente " + " (" +SDS->(DS_FORNEC +"/" +DS_LOJA)+ ").","Exclua o documento registrado na ocorrência."}) 
		Else 
			Aviso("Erro","ID de CT-e já registrado na NF " +SDS->(DS_DOC+"/"+SerieNfId('SDS',2,'DS_SERIE'));
								 + "do Fornecedor/Cliente " + SDS->(DS_FORNEC+"/"+DS_LOJA) +".",{"OK"},2,"ImpXML_CTe")
		EndIf
		aAdd(aErroErp,{cFile,"COM019"})
		lRet := .F.
	EndIf
EndIf

//-- Verifica se CTe é do tipo complementar
If lRet .And. Valtype(XmlChildEx(oXml:_InfCte,"_INFCTECOMP")) != "U"
	lComp := .T.
EndIf

//-- Verifica se o fornecedor do conhecimento esta cadastrado no sistema.
If lRet
	If ValType(XmlChildEx(oXML:_InfCte:_Emit,"_CNPJ")) <> "U"
		cCNPJ_CT := AllTrim(oXML:_InfCte:_Emit:_CNPJ:Text)
	Else
		cCNPJ_CT := AllTrim(oXML:_InfCte:_Emit:_CPF:Text)
	EndIf
	
	// Envio das letras E, D ou R pela funcao A116ICLIFOR. E = Emitente, D = Destinatario e R = Remetente.
	// Essa informacao sera utilizada no P.E. A116IFOR.
	aDadosAux := A116ICLIFOR(cCNPJ_CT,AllTrim(oXML:_InfCte:_Emit:_IE:Text),"SA2",,oXML,'E')
	
	If Len(aDadosAux) == 0
		If lJob
			aAdd(aErros,{cFile,"COM007 - " + "Fornecedor" + oXML:_InfCte:_Emit:_Xnome:Text +" [" + Transform(cCNPJ_CT,"@R 99.999.999/9999-99") +"] "+ "inexistente na base.","Gere cadastro para este fornecedor."})
		Else
			Aviso("Erro","Fornecedor" + oXML:_InfCte:_Emit:_Xnome:Text +" [" + Transform(cCNPJ_CT,"@R 99.999.999/9999-99") +"] "+ "Fornecedor inexistente na base.","Gere cadastro para este fornecedor.",2,"ImpXML_CTe") 
		EndIF		
		aAdd(aErroErp,{cFile,"COM007"})			
		lRet := .F.
	Elseif !aDadosAux[1,1]
		If lJob
			aAdd(aErros,{cFile,"COM028 - " + "Fornecedor" + Transform(cCNPJ_CT,"@R 99.999.999/9999-99") + "Fornecedor inexistente na base.", ""})
		Else
			Aviso("Erro","Fornecedor" + Transform(cCNPJ_CT,"@R 99.999.999/9999-99") + "Fornecedor inexistente na base." ,{"OK"},2,"ImpXML_CTe")
		EndIf
		aAdd(aErroErp,{cFile,"COM028"})
		lRet := .F.
	Else
		cFornCTe := aDadosAux[1,2]
		cLojaCTe := aDadosAux[1,3]
		cNomeCTe := Posicione("SA2",1,xFilial("SA2") + cFornCTe + cLojaCTe,"A2_NOME")
	Endif
EndIf

//Identifica se a empresa foi remetente das notas fiscais contidas no conhecimento:

//Se sim, significa que as notas contidas no conhecimento sao notas de saida, podendo ser
//notas de venda, devolucao de compras ou devolucao de remessa para beneficiamento.

//Se nao, significa que as notas contidas no conhecimento sao notas de entrada, podendo ser
//notas de compra, devolucao de vendas ou remessa para beneficiamento.
/*
If lRet
	aDadosAux := {}
	cTagRem := If(ValType(XmlChildEx(oXML:_InfCte,"_REM")) == "O",If(ValType(XmlChildEx(oXML:_InfCte:_Rem,"_CNPJ")) == "O","_CNPJ","_CPF"),"")
	If ( lRemet := (SM0->M0_CGC == If(!Empty(cTagRem),(AllTrim(XmlChildEx(oXML:_InfCte:_Rem,cTagRem):Text)),"")) .And. !lToma3Dest )
		cTagDest := If(ValType(XmlChildEx(oXML:_InfCte:_Dest,"_CNPJ")) == "O","_CNPJ","_CPF")
		cIEDestT4:= If(ValType(XmlChildEx(oXML:_InfCte:_Dest,"_IE")) == "O",AllTrim(oXML:_InfCte:_Dest:_IE:Text),"")
		cCNPJ_CF := AllTrim(XmlChildEx(oXML:_InfCte:_Dest,cTagDest):Text) //-- Armazena o CNPJ do destinatario das notas contidas no conhecimento
		cTipoFrete := "F"
		
		If !Empty(cCNPJ_CF) 
			//Fornecedor
			aAuxCliFor := A116ICLIFOR(cCNPJ_CF,cIEDestT4,"SA2",,oXML,'D')
			
			If Len(aAuxCliFor) == 0
				aAdd(aDadosAux,{.T.,"","",.F.,.F.,"F"})
			Else
				aAdd(aDadosAux,aAuxCliFor[1])
			Endif
		EndIf
		
		// Verifica a TAG <TpCte> para analisar se a nota eh complementar.
		cTpCte := If(ValType(XmlChildEx(oXML:_InfCte,"_IDE")) == "O",AllTrim(oXML:_InfCte:_Ide:_tpCTe:Text),"") //-- Armazena o tipo do CT-e.
		
		// Opcoes para <TpCte>:
		// 0 - CT-e Normal;
		// 1 - CT-e de Complemento de Valores;
		// 2 - CT-e de Anulação de Valores;
		// 3 - CT-e Substituto.
		
		If cTpCte == '1' // CT-e de Complemento de Valores
			lRemet := .F.
		EndIf
		
		cTagMsg := '_Dest'
	Endif
		
	If lComp
		aAux1 := If(ValType(oXML:_InfCte:_InfCTeComp) == "O",{oXML:_InfCte:_InfCTeComp},oXML:_InfCte:_InfCTeComp)
	ElseIf cVersao >= "2.00"
		If ValType(XmlChildEx(oXML:_InfCte:_InfCTeNorm,"_INFDOC")) != "U" .And. ValType(XmlChildEx(oXML:_InfCte:_InfCTeNorm:_InfDoc,"_INFNF")) != "U"
			aAux := If(ValType(oXML:_InfCte:_InfCTeNorm:_InfDoc:_INFNF) == "O",{oXML:_InfCte:_InfCTeNorm:_InfDoc:_INFNF},oXML:_InfCte:_InfCTeNorm:_InfDoc:_INFNF)
		ElseIf ValType(XmlChildEx(oXML:_InfCte:_InfCTeNorm,"_INFDOC")) != "U" .And. ValType(XmlChildEx(oXML:_InfCte:_InfCTeNorm:_InfDoc,"_INFNFE")) != "U"
			aAux1 := If(ValType(oXML:_InfCte:_InfCTeNorm:_InfDoc:_INFNFE) == "O",{oXML:_InfCte:_InfCTeNorm:_InfDoc:_INFNFE},oXML:_InfCte:_InfCTeNorm:_InfDoc:_INFNFE)
		EndIf
	Else
		If ValType(XmlChildEx(oXML:_InfCte:_Rem,"_INFNF")) != "U"
			aAux := If(ValType(oXML:_InfCte:_Rem:_INFNF) == "O",{oXML:_InfCte:_Rem:_INFNF},oXML:_InfCte:_Rem:_INFNF)
		ElseIf ValType(XmlChildEx(oXML:_InfCte:_Rem,"_INFNFE")) != "U"
			aAux1 := If(ValType(oXML:_InfCte:_Rem:_INFNFE) == "O",{oXML:_InfCte:_Rem:_INFNFE},oXML:_InfCte:_Rem:_INFNFE)
		EndIf
	EndIf
	
	If Len(aAux) > 0 .Or. (Len(aAux) == 0 .And. Len(aAux1) == 0)
		If Len(aAux) > 0
			cCodiRem 		:= CriaVar("A2_COD",.F.)
			cLojaRem 		:= CriaVar("A2_LOJA",.F.)
			aDadosFor[1]	:= CriaVar("A2_COD",.F.)
			aDadosFor[2]	:= CriaVar("A2_LOJA",.F.)
			aDadosCli[1]	:= CriaVar("A1_COD",.F.)
			aDadosCli[2]	:= CriaVar("A1_LOJA",.F.)
		Endif
		
		If lRet //Validou fornecedor ou cliente
			
			SF2->(dbClearFilter())
			SF2->(dbSetOrder(1))
			
			SF1->(dbClearFilter())
			SF1->(dbSetOrder(1))
			
			For nX := 1 To Len(aAux)
				//Verifica CFOP para saber se documento origem é Beneficamento
				lNFOriBen	:= aAux[nX]:_nCFOP:Text $ cCFBN
				
				cChaveNF :=	PadL(AllTrim(aAux[nX]:_nDoc:Text),TamSX3("F1_DOC")[1], "0") +;
								PadR(AllTrim(aAux[nX]:_Serie:Text),TamSX3("F1_SERIE")[1])
					
				//Ponto de entrada para manipulaça da chave(nº do doc + serie) do doc de origem
				If lMR07CHV
					aChave := ExecBlock("MR07CHV",.F.,.F.,{AllTrim(aAux[nX]:_nDoc:Text),AllTrim(aAux[nX]:_Serie:Text)})
					If ValType(aChave) == "A" .And. Len(aChave) >= 2
						cChaveNF :=	Padr(AllTrim(aChave[1]),TamSX3("F1_DOC")[1],) +;
										Padr(AllTrim(aChave[2]),TamSX3("F1_SERIE")[1])   
					EndIf
				EndIf
					
				If lNFOriBen
					//Busca documento de origem (beneficiamento)
					aDadosCli := A116IFOCL(aDadosAux,"C")
					
					If aDadosCli[1] .And. !Empty(aDadosCli[2])
						If SF1->(dbSeek(xFilial("SF1")+cChaveNF+aDadosCli[2]+aDadosCli[3]))
							cCodiRem := aDadosCli[2]
							cLojaRem := aDadosCli[3]
						Else
							lRet := .F.
						EndIf
					Else
						lRet := .F.
					Endif
				Else
					//Não sabe o tipo do documento, busca pelo fornecedor e/ou cliente
					aDadosFor := A116IFOCL(aDadosAux,"F")
					
					If aDadosFor[1] .And. !Empty(aDadosFor[2])
						If SF1->(dbSeek(xFilial("SF1")+cChaveNF+aDadosFor[2]+aDadosFor[3]))
							cCodiRem := aDadosFor[2]
							cLojaRem := aDadosFor[3]
						Else
							lRet := .F.
						EndIf
					Else
						lRet := .F.
					Endif
					
					If !lRet
						aDadosCli := A116IFOCL(aDadosAux,"C")
					
						If aDadosCli[1] .And. !Empty(aDadosCli[2])
							If SF1->(dbSeek(xFilial("SF1")+cChaveNF+aDadosCli[2]+aDadosCli[3]))
								cCodiRem := aDadosCli[2]
								cLojaRem := aDadosCli[3]
								lRet := .T.
							Else
								lRet := .F.
							EndIf
						Else
							lRet := .F.
						Endif
					Endif
				Endif
				
				If !lRet
					// Tratamento para CTe de devolucao quando o cliente nao aceitou receber a mercadoria
					// Neste caso a transportadora emite um novo CTe referenciando as notas de venda, as notas estarao em SF2 e nao SF1
					cChaveNF :=	AllTrim(aAux[nX]:_nDoc:Text) +;
									AllTrim(aAux[nX]:_Serie:Text)
									
					aDadosCli := A116IFOCL(aDadosAux,"C") 
					
					If aDadosCli[1] .And. !Empty(aDadosCli[2])
						If SF2->(dbSeek(xFilial("SF2")+cChaveNF+aDadosCli[2]+aDadosCli[3]))
							cCodiRem := aDadosCli[2]
							cLojaRem := aDadosCli[3]
						
							aErros	:= {}
							cTipoFrete := "F"
							lDevSemSF1 := .T.
						EndIf
					Else
						lRet := .F.
					Endif
				Endif
				
				//-- Registra notas que farao parte do conhecimento
				If lRet
					nTamFil := Len(xFilial("SF1"))
					cChvNFOr := SF1->F1_CHVNFE
					aAdd(aItens116,{{"PRIMARYKEY",SubStr(SF1->&(IndexKey()),nTamFil+1), cCodiRem, cLojaRem}})
					
					lDevBen	:= SF1->F1_TIPO $ "D*B"
					
					If lDevBen
						nDevOri++
					Else
						nNorOri++
					Endif
					
					If nDevOri > 0 .And. nNorOri > 0
						lFornOri := .F.
					Endif
				Else
					If lT3Exped .Or. lT4DifDest .Or. lT3Remet .Or. lDevSemSF1
						lRet := .T.
					Else
						If lJob
							aAdd(aErros,{cFile,"COM020 - " + "Documento de entrada inexistente na base." + cChaveNF + "Processe o recebimento deste documento de entrada.",""}) // 
						Else
							Aviso("Erro","Documento de entrada inexistente na base." + cChaveNF + "Processe o recebimento deste documento de entrada." + "",2,"ImpXML_CTe") //"Documento de entrada inexistente na base. Processe o recebimento deste documento de entrada."
						EndIf
						aAdd(aErroErp,{cFile,"COM020"})
						Exit
					Endif
				EndIf
			Next nX
		Endif
	Endif
	
	If lRet .And. Len(aAux1) > 0
		For nX := 1 To Len(aAux1)

			SF1->(dbSetOrder(8))
			
			If ValType(XmlChildEx(aAux1[nX],"_CHAVE")) == "O"
				cChaveNF := AllTrim(aAux1[nX]:_chave:Text)
			ElseIf ValType(XmlChildEx(aAux1[nX],"_CHCTE")) == "O"
				cChaveNF := AllTrim(aAux1[nX]:_chCTE:Text)
			EndIf
			
			//Verifica existência da nota
			If SF1->(dbSeek(xFilial("SF1")+cChaveNF)) .And. !Empty(cChaveNF) //Se nota existir, preenche informações do Remetente com dados da nota
				cCodiRem 	:= SF1->F1_FORNECE
				cLojaRem 	:= SF1->F1_LOJA
				lDevBen	:= SF1->F1_TIPO $ "D*B"
				
				If lDevBen
					nDevOri++
				Else
					nNorOri++
				Endif
				
				//Se as chaves nfe pertencem a mais de 1 fornecedor, ao incluir o documento de frente
				//não deve ser filtrado pelo fornecedor.
				nPFornChv := aScan(aFornChv,{|x| x == cCodiRem+cLojaRem})
				If nPFornChv == 0
					aAdd(aFornChv,cCodiRem+cLojaRem)
				Endif
				
				If (nDevOri > 0 .And. nNorOri > 0) .Or. Len(aFornChv) > 1
					lFornOri := .F.
				Endif
				
				//-- Registra notas que farao parte do conhecimento
				SF1->(dbSetOrder(1))
				nTamFil := Len(xFilial("SF1"))
				cChvNFOr := SF1->F1_CHVNFE
				aAdd(aItens116,{{"PRIMARYKEY",SubStr(SF1->&(IndexKey()),nTamFil+1), cCodiRem, cLojaRem}})
			Else
				SF2->(dbClearFilter())
				SF2->(dbSetOrder(1))
				
				cQuery := " SELECT R_E_C_N_O_ AS RECNO "
				cQuery += " FROM " + RetSqlName("SF2") + " SF2 "
				cQuery += " WHERE D_E_L_E_T_ = ' ' AND"
				cQuery += " F2_CHVNFE = '" + cChaveNF + "' AND"
				cQuery += " F2_FILIAL = '" + xFilial("SF2") + "'" 	
				cQuery := ChangeQuery(cQuery)
				
				dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery),"TMP", .T., .T.)
				TMP->(dbGoTop())
				If TMP->(!Eof())
					aErros	:= {}
					cTipoFrete := "F"
					lDevSemSF1 := .T.
				EndIf
				TMP->(dbCloseArea())
			EndIf			
		Next nX
	Endif

	If lDevBen .And. !lRateiaDev
		aItens116 := {}
	EndIf

	If lToma4 .And. Len(aItens116) == 0 
		lToma4NFOri := .F.
	Endif

	If (Len(aAux1) == 0 .And. Len(aAux) == 0) .Or. lDevSemSF1 .Or. Len(aItens116) == 0

	Endif
	
	//-- Obtem TES e cond. pagto para utilizacao no CT-e
	CTe_RetTES(oXML,@cTES_CT,@cCPag_CT,1)
	
	//-- Valida existencia da TES a utilizar no CTe
	If lRet .And. !lPreNota .And. (Empty(cTES_CT) .Or. !SF4->(dbSeek(xFilial("SF4")+cTES_CT))) 
 		If lJob
			aAdd(aErros,{cFile,"COM021 - " + "TES não informada no parâmetro MV_XMLTECT ou inexistente no cadastro correspondente.",""}) //
		Else
			Aviso("Erro","TES não informada no parâmetro MV_XMLTECT ou inexistente no cadastro correspondente.",2,"ImpXML_CTe")
		EndIf
		aAdd(aErroErp,{cFile,"COM021"})
		lRet := .F.
	EndIf
	
	//-- Valida se o TES esta desbloqueado.
	If lRet
		If SF4->F4_MSBLQL == '1' .And. !lPreNota // TES bloqueado.
	 		If lJob
				aAdd(aErros,{cFile,"COM029 - " + "TES bloqueado. Codigo: " + SF4->F4_CODIGO,"Verifique a configuração do cadastro."}) //#
			Else
				Aviso("Erro","TES bloqueado. Codigo: " + SF4->F4_CODIGO + Space(1) + "Verifique a configuração do cadastro.",2,"ImpXML_CTe")
			EndIf
			aAdd(aErroErp,{cFile,"COM029"})
			lRet := .F.
		EndIf
	EndIf
	
	//-- Se TES gera dup., valida existencia da cond. pgto a utilizar no CTe
Endif
*/

//-- Ponto de entrada para mudar o produto frete
If ExistBlock("A116PRDF")
	cPrdFrete := ExecBlock("A116PRDF",.F.,.F.,{oXML})
	If ValType(cPrdFrete) <> "C" .Or. !SB1->(dbSeek(xFilial("SB1")+cPrdFrete))
		cPrdFrete := SuperGetMV("MV_XMLPFCT",.F.,"")
		If At(";",cPrdFrete) > 0
			cPrdFrete := SubStr(cPrdFrete,1,(At(";",cPrdFrete)-1))
		EndIf
		cPrdFrete := cPrdFrete
	EndIf
Else
	cPrdFrete := SuperGetMV("MV_XMLPFCT",.F.,"")
	If At(";",cPrdFrete) > 0
		cPrdFrete := SubStr(cPrdFrete,1,(At(";",cPrdFrete)-1))
	EndIf
	cPrdFrete := cPrdFrete
EndIf

dbSelectArea("SB1")
SB1->(dbSetOrder(1))
SB1->(dbGoTop())
If Empty(cPrdFrete)
	If lJob
		aAdd(aErros,{cFile,"COM023 - " + "Produto frete não informado no parâmetro MV_XMLPFCT ou inexistente no cadastro correspondente.","Verifique a configuração do parâmetro."})
	Else
		Aviso("Erro","Produto frete não informado no parâmetro MV_XMLPFCT ou inexistente no cadastro correspondente."+"Verifique a configuração do parâmetro.",2,"ImpXML_CTe")
	EndIf
	aAdd(aErroErp,{cFile,"COM023"})
	lRet := .F.
Else
	cTipoFrete := "F"
	lRemet := .T.
EndIf


// Verifica existência de documento com mesma numeração.
If lRet	
	cDoc	:= StrZero(Val(AllTrim(oXML:_InfCte:_Ide:_nCt:Text)),TamSx3("F1_DOC")[1]) 
	cSerie	:= oXML:_InfCte:_Ide:_Serie:Text

	dbSelectArea("SDS")
	dbSetorder(1)
	If msSeek(xFilial("SDS")+cDoc+cSerie+cFornCTe+cLojaCTe)
		If lJob
			aAdd(aErros,{cFile,"COM025 - " + "Documento "+" "+cDoc+", serie "+cSerie+" , já cadastrado. verifique se o documento já foi importado para o ERP. ",""}) //cdoc,  cSerie, 
		Else
			Aviso("Erro","COM025 - " + "Documento "+" "+cDoc+", serie "+cSerie+" , já cadastrado. verifique se o documento já foi importado para o ERP. ",2,"ImpXML_CTe")
		EndIf
		aAdd(aErroErp,{cFile,"COM025"})
		lRet := .F.
	EndIf
EndIf

If lRet
	//-- Separa secao que contem as notas do conhecimento para laco
	If ValType(XmlChildEx(oXML:_InfCte,"_INFCTENORM")) <> "U"
	 	aAux := If(ValType(oXML:_InfCte:_InfCteNorm:_InfCarga:_InfQ) == "O",{oXML:_InfCte:_InfCteNorm:_InfCarga:_InfQ},oXML:_InfCte:_InfCteNorm:_InfCarga:_InfQ)
	EndIf
 	For nX := 1 To Len(aAux)
		If Upper(AllTrim(aAux[nX]:_TPMED:Text)) == "PESO BRUTO"
			nPesoBruto := Val(aAux[nX]:_QCARGA:Text)
		EndIf
		If Upper(AllTrim(aAux[nX]:_TPMED:Text)) == "PESO LíQUIDO"
			nPesoLiqui := Val(aAux[nX]:_QCARGA:Text)
		EndIf
		If !("PESO" $ Upper(aAux[nX]:_TPMED:Text)) .And. Len(aEspecVol) < 5
			aAdd(aEspecVol,{AllTrim(aAux[nX]:_TPMED:Text),Val(aAux[nX]:_QCARGA:Text)})
		EndIf
	Next nX
	
	// Apuracao do ICMS para as diversas situacoes tributarias
	If ValType(XmlChildEx(oXML:_InfCte:_imp,"_ICMS")) <> "U"
		If ( oICMS := oXML:_INFCTE:_IMP:_ICMS ) != Nil
			If ( oICMSTipo := XmlGetChild( oICMS, 1 )) != Nil
				For nZ := 1 To 5	// O nivel maximo para descer dentro da tag que define o tipo do ICMS para obter tanto base quanto valor é 5, conforme manual de orientacao do CTe
					If ( oICMSNode := XmlGetChild( oICMSTipo, nZ )) != Nil
						If "vBC" $ oICMSNode:REALNAME
							nBaseICMS := Val(oICMSNode:TEXT)
							lBaseICMS := .T.
						ElseIf "vICMS" $ oICMSNode:REALNAME
							nValICMS := Val(oICMSNode:TEXT)
							lValICMS := .T.
						ElseIf "pICMS" $ oICMSNode:REALNAME
							nAliqICMS := Val(oICMSNode:TEXT)
							lAliqICMS := .T.
						EndIf
						If lBaseICMS .And. lValICMS .And. lAliqICMS
							Exit
						EndIf
					EndIf
				Next nZ
			EndIf
		EndIf
	EndIf
Endif

//Valor do frete
If lRet .And. ValType(XmlChildEx(oXML:_InfCte,"_VPREST")) <> "U"
	If ValType(XmlChildEx(oXML:_InfCte:_vPrest,"_VREC")) <> "U" .And. ValType(XmlChildEx(oXML:_InfCte:_vPrest,"_VTPREST")) <> "U"
		If Val(oXML:_InfCte:_VPrest:_VRec:Text) == 0 .And. Val(oXML:_InfCte:_VPrest:_vTPrest:Text) == 0
			lVlrFrtZero := .T.
		Elseif Val(oXML:_InfCte:_VPrest:_VRec:Text) == 0 .And. Val(oXML:_InfCte:_VPrest:_vTPrest:Text) > 0
			nVlrFrt := Val(oXML:_InfCte:_VPrest:_vTPrest:Text)
			lVlrFrtZero := .T.
		Else
			nVlrFrt := Val(oXML:_InfCte:_VPrest:_VRec:Text)
		Endif
	Endif
Endif

If lRet	
	Begin Transaction

	//-- Grava cabeca do conhecimento de transporte
	RecLock("SDS",.T.)
	SDS->DS_FILIAL	:= xFilial("SDS")																			// Filial			
    SDS->DS_CNPJ		:= cCNPJ_CT																				// CGC
    SDS->DS_DOC		:= cDoc																						// Numero do Documento
    SDS->DS_FORNEC	:= cFornCTe																					// Fornecedor do Conhecimento de transporte
    SDS->DS_LOJA		:= cLojaCTe																				// Loja do Fornecedor do Conhecimento de transporte
    SDS->DS_EMISSA	:= StoD(StrTran(AllTrim(oXML:_InfCte:_Ide:_Dhemi:Text),"-",""))		    					// Data de Emissão
    SDS->DS_EST		:= Posicione("SA2",1,xFilial("SA2")+cFornCTe+cLojaCTe,"A2_EST")	    						// Estado de emissao da NF
    SDS->DS_TIPO		:= "T"													 								// Tipo da Nota
    SDS->DS_FORMUL	:= "N" 																						// Formulario proprio
    SDS->DS_ESPECI	:= "CTE"																					// Especie
    SDS->DS_ARQUIVO	:= AllTrim(cFile)																			// Arquivo importado
    SDS->DS_CHAVENF	:= Right(AllTrim(oXML:_InfCte:_Id:Text),44)													// Chave de Acesso da NF
    SDS->DS_VERSAO	:= AllTrim(oXML:_InfCte:_Versao:Text) 														// Versão
    SDS->DS_USERIMP	:= If(!lJob,cUserName,"TOTVS")          													// Usuario na importacao
    SDS->DS_DATAIMP	:= dDataBase																				// Data importacao do XML
    SDS->DS_HORAIMP	:= SubStr(Time(),1,5)																		// Hora importacao XML
    SDS->DS_VALMERC	:= nVlrFrt																	  				// Valor Mercadoria
    SDS->DS_TPFRETE	:= cTipoFrete																				// Tipo de Frete
    SDS->DS_PBRUTO	:= nPesoBruto																				// Peso Bruto
    SDS->DS_PLIQUI	:= nPesoLiqui																				// Peso Liquido
    
    For nX := 1 To Len(aEspecVol)
    	If SDS->(ColumnPos("DS_ESPECI" +Str(nX,1))) > 0
		    SDS->&("DS_ESPECI" +Str(nX,1)) := aEspecVol[nX,1]							 							// Especie
			SDS->&("DS_VOLUME" +Str(nX,1)) := aEspecVol[nX,2]							 							// Volume
		EndIf
	Next nX
	
	If SDS->(ColumnPos("DS_BASEICM")) > 0 .And. lBaseICMS
		SDS->DS_BASEICM := nBaseICMS
	EndIf
	
	If SDS->(ColumnPos("DS_VALICM")) > 0 .And. lValICMS
		SDS->DS_VALICM := nValICMS
	EndIf
	
	If SDS->(ColumnPos('DS_TPCTE')) > 0
		SDS->DS_TPCTE := TIPOCTE116(oXML:_InfCte:_Ide:_tpCTe:Text)
	EndIf
	
	//Chave da Nota de Origem
    If SDS->(ColumnPos("DS_CHVNFOR")) > 0
    	SDS->DS_CHVNFOR		:= cChvNFOr
    Endif
    
   	If !Empty(cHrEmis)
		SDS->DS_HORNFE := cHrEmis
	Endif
	
	//Valor a pagar igual a 0
	If lVlrFrtZero
		SDS->DS_FRETE := Iif(nVlrFrt==0,1,nVlrFrt)
	Endif
	
	If ValType(XmlChildEx(oXML:_InfCte:_Ide,"_MODAL")) <> "U" .And. SDS->(ColumnPos("DS_MODAL")) > 0
		SDS->DS_MODAL := AllTrim(oXML:_InfCte:_Ide:_modal:Text)
	Endif
	
	SerieNfId("SDS",1,"DS_SERIE",SDS->DS_EMISSA,SDS->DS_ESPECI,cSerie) 
	
	SDS->(MsUnlock())
	
	//Se for remetente mas a notas de origem existem no sistema
	If (lRemet .And. !lToma4) .And. Len(aItens116) > 0
		lRemet := .F.
	Endif
	
			RecLock("SDT",.T.)
			SDT->DT_FILIAL	   		:= xFilial("SDT")											// Filial
			SDT->DT_ITEM			:= StrZero(1,TamSX3("DT_ITEM")[1])							// Item
			SDT->DT_COD				:= cPrdFrete												// Codigo do produto
			SDT->DT_FORNEC			:= cFornCTe													// Forncedor
			SDT->DT_LOJA			:= cLojaCTe													// Loja
			SDT->DT_DOC				:= cDoc														// Docto
			SDT->DT_SERIE			:= cSerie 					   								// Serie
			SDT->DT_CNPJ			:= SDS->DS_CNPJ												// Cnpj do Fornecedor
			SDT->DT_QUANT			:= 1														// Quantidade
			SDT->DT_VUNIT			:= Val(oXML:_InfCte:_VPrest:_VRec:Text)						// Valor Unitário 			
			SDT->DT_TOTAL			:= Val(oXML:_InfCte:_VPrest:_VRec:Text)				   		// Vlor Total 			 	

			If SDT->(FieldPos("DT_PICM")) > 0 .And. lAliqICMS
				SDT->DT_PICM := nAliqICMS
			EndIf

			SDT->(MsUnlock())
	End Transaction
EndIf

If lRet
	aAdd(aProc,{	oXML:_InfCte:_Ide:_nCt:Text,;
					oXML:_InfCte:_Ide:_Serie:Text,;
					cNomeCTe })
Endif

oXML := Nil
DelClassIntf()

DisarmTran()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³RETORNA FILIAL DE ORIGEM³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cEmpAnt := cEmpBkp  
cFilAnt := cFilBkp

Return lRet

/*/{Protheus.doc}CTe_VldEmp
Verifica se o XML deve ser processado pela empresa.

@param	oXml: XML do arquivo CTe.
@param	cCNPJ_CPF: CNPJ/CPF da empresa que ira processar.

@return lRet: indica se o arquivo deve ser processado.

@author Andre Anjos
@since  08/06/12
/*/

STATIC Function CTe_VldEmp(oXML,cCNPJ_CPF,lToma3Dest,lToma4,lJob,cFile,aErros,aErroErp,lT4DifDest,lT3Exped,lT3Remet,aErros,aErroErp)
Local lRet 	   := .T.
Local cTagRem  := If(ValType(XmlChildEx(oXML:_InfCte,"_REM")) == "O", If(ValType(XmlChildEx(oXML:_InfCte:_Rem,"_CNPJ")) == "O","_CNPJ","_CPF"),"")
Local cTagDest := If(ValType(XmlChildEx(oXML:_InfCte,"_DEST")) == "O",If(ValType(XmlChildEx(oXML:_InfCte:_Dest,"_CNPJ")) == "O","_CNPJ","_CPF"),"")
Local cIERem   := If(ValType(XmlChildEx(oXML:_InfCte,"_REM")) == "O", If(ValType(XmlChildEx(oXML:_InfCte:_Rem,"_IE")) == "O","_IE",""),"")
Local cIEDest  := If(ValType(XmlChildEx(oXML:_InfCte,"_DEST")) == "O",If(ValType(XmlChildEx(oXML:_InfCte:_Dest,"_IE")) == "O","_IE",""),"")
Local cTagToma4:= ""
Local cTagRec	:= ""
Local cTagExp	:= ""
Local nX		 := 0
Local nQtdCNPJ := 0
Local nQtdINSC	:= 0
Local aDirFilial:= {}
Local cTag	:= ""
Local cIE	:= ""
Local cT4DstCNPJ	:= ""
Local cT4DstIE	:= ""
Local cTagToma3	:= ""
Local cTgTom3		:= ""

DEFAULT lToma3Dest:= .F.
DEFAULT lToma4	 := .F.
DEFAULT aErros:= {}
DEFAULT aErroErp:= {}

If ValType(oXML) == "U"
	lRet := .F.
Endif

If lRet
	If ValType(XmlChildEx(oXML:_InfCte:_Ide,"_TOMA03")) <> "U"
		cTagToma3	:= AllTrim(oXML:_InfCte:_Ide:_Toma03:_TOMA:Text)
		cTgTom3	:= "_TOMA03"
	Elseif ValType(XmlChildEx(oXML:_InfCte:_Ide,"_TOMA3")) <> "U"
		cTagToma3	:= AllTrim(oXML:_InfCte:_Ide:_Toma3:_TOMA:Text)
		cTgTom3	:= "_TOMA3"
	Endif
Endif

If lRet
	If ValType(XmlChildEx(oXML:_InfCte:_Ide,cTgTom3)) <> "U" 
		If cTagToma3 == "0" //Remetente
			If ValType(XmlChildEx(oXML:_InfCte:_Rem,cTagRem)) == "O"
				cTag 	:= AllTrim(XmlChildEx(oXML:_InfCte:_Rem,cTagRem):Text)
			EndIf
			
			If ValType(XmlChildEx(oXML:_InfCte:_Rem,cIERem)) == "O"
				cIE 	:= AllTrim(XmlChildEx(oXML:_InfCte:_Rem,cIERem):Text)
			EndIf
			lT3Remet := .T.
		ElseIf cTagToma3 == "1" //Expedidor
			cTagExp := If(ValType(XmlChildEx(oXML:_InfCte:_Exped,"_CNPJ")) == "O","_CNPJ","_CPF")
			
			If ValType(XmlChildEx(oXML:_InfCte:_Exped,cTagExp)) == "O"
				cTag 	:= AllTrim(XmlChildEx(oXML:_InfCte:_Exped,cTagExp):Text)
			EndIf
			
			If ValType(XmlChildEx(oXML:_InfCte:_Exped,"_IE")) == "O"
				cIE 	:= AllTrim(XmlChildEx(oXML:_InfCte:_Exped,"_IE"):Text)
			EndIf
			lT3Exped := .T.
		ElseIf cTagToma3 == "2" //Recebedor
			cTagRec := If(ValType(XmlChildEx(oXML:_InfCte:_Receb,"_CNPJ")) == "O","_CNPJ","_CPF")
			
			If ValType(XmlChildEx(oXML:_InfCte:_Receb,cTagRec)) == "O"
				cTag 	:= AllTrim(XmlChildEx(oXML:_InfCte:_Receb,cTagRec):Text)
			EndIf
			
			If ValType(XmlChildEx(oXML:_InfCte:_Receb,"_IE")) == "O"
				cIE 	:= AllTrim(XmlChildEx(oXML:_InfCte:_Receb,"_IE"):Text)
			EndIf
		ElseIf cTagToma3 == "3" //Destinatario
			lToma3Dest := .T.	// Destinatario da nota no processo de transferencia entre filiais
			
			If ValType(XmlChildEx(oXML:_InfCte:_Dest,cTagDest)) == "O"
				cTag 	:= AllTrim(XmlChildEx(oXML:_InfCte:_Dest,cTagDest):Text)
			EndIF
			
			If ValType(XmlChildEx(oXML:_InfCte:_Dest,cIEDest)) == "O"
				cIE 	:= AllTrim(XmlChildEx(oXML:_InfCte:_Dest,cIEDest):Text)			
			EndIF
		EndIf
	ElseIf ValType(XmlChildEx(oXML:_InfCte:_Ide,"_TOMA4")) <> "U"
		If AllTrim(oXML:_InfCte:_Ide:_Toma4:_TOMA:Text) == "4"
			cTagToma4 := If(ValType(XmlChildEx(oXML:_InfCte:_Ide:_Toma4,"_CNPJ")) == "O","_CNPJ","_CPF")
			lToma4 := .T.
			
			If ValType(XmlChildEx(oXML:_InfCte:_Ide:_Toma4,cTagToma4)) == "O"
				cTag 	:= AllTrim(XmlChildEx(oXML:_InfCte:_Ide:_Toma4,cTagToma4):Text)
			EndIf
			
			If ValType(XmlChildEx(oXML:_InfCte:_Ide:_Toma4,"_IE")) == "O"
				cIE 	:= AllTrim(XmlChildEx(oXML:_InfCte:_Ide:_Toma4,"_IE"):Text)
			EndIf
			
			//Valida se Toma4 é igual a Destinatario
			If ValType(XmlChildEx(oXML:_InfCte,"_DEST")) == "O" .And. ValType(XmlChildEx(oXML:_InfCte:_Dest,cTagDest)) == "O"
				cT4DstCNPJ	:= AllTrim(XmlChildEx(oXML:_InfCte:_Dest,cTagDest):Text)
			EndIF
			
			If ValType(XmlChildEx(oXML:_InfCte,"_DEST")) == "O" .And. ValType(XmlChildEx(oXML:_InfCte:_Dest,cIEDest)) == "O"
				cT4DstIE 	:= AllTrim(XmlChildEx(oXML:_InfCte:_Dest,cIEDest):Text)			
			EndIF
			
			If !Empty(cT4DstCNPJ) .And. !Empty(cT4DstIE)
				If cTag <> cT4DstCNPJ .Or. cIE <> cT4DstIE
					lT4DifDest := .T.
				Endif
			Endif
		EndIf
	Else //Se o xml não possui as tags Toma3 e Toma4, o documento será processado na filial do destinatario
		If ValType(XmlChildEx(oXML:_InfCte,"_DEST")) == "O" .And. ValType(XmlChildEx(oXML:_InfCte:_Dest,cTagDest)) == "O"
			cTag 	:= AllTrim(XmlChildEx(oXML:_InfCte:_Dest,cTagDest):Text)
		EndIF
		
		If ValType(XmlChildEx(oXML:_InfCte,"_DEST")) == "O" .And. ValType(XmlChildEx(oXML:_InfCte:_Dest,cIEDest)) == "O"
			cIE 	:= AllTrim(XmlChildEx(oXML:_InfCte:_Dest,cIEDest):Text)			
		EndIF
	EndIf

Endif


//Valida se o CT-e deve ser importado na filial remetente ou na filial destinataria
//para o caso de ser uma operacao de transferencia entre filiais

//Validacao efetuada pela tag TOMA03 conforme Manual do Conhecimento de Transporte Eletronico
//Versao 1.0.4c - Abril/2012, que identifica quem e o tomador do servico, sendo:
//0-Remetente
//1-Expedidor
//2-Recebedor
//3-Destinatario

If ValType(oXML) == "U"
	lRet := .F.
Endif
If lRet
	If ValType(XmlChildEx(oXML:_InfCte:_Ide,cTgTom3)) <> "U"
		If cTagToma3 == "0"
			If cEmpAnt <> '99'
				dbSelectArea("SM0")
				dbSetOrder(1)
				dbGoTop()
				While !Eof()
					If M0_CGC == AllTrim(XmlChildEx(oXML:_InfCte:_Rem,cTagRem):Text)
						cFilAnt := M0_CODFIL
						cEmpAnt := M0_CODIGO
						lRet := .T.
						Exit
					EndIf
					dbSkip()
				End
			Else
				lRet := .F.
			EndIf
			
		ElseIf cTagToma3 == "1"
			cTagExp := If(ValType(XmlChildEx(oXML:_InfCte:_Exped,"_CNPJ")) == "O","_CNPJ","_CPF")
			If cEmpAnt <> '99'
				dbSelectArea("SM0")
				dbSetOrder(1)
				dbGoTop()
				While !Eof()
					If M0_CGC == AllTrim(XmlChildEx(oXML:_InfCte:_Exped,cTagExp):Text)
						cFilAnt := M0_CODFIL
						cEmpAnt := M0_CODIGO
						lRet := .T.
						Exit
					EndIf
					dbSkip()
				End
			Else
				lRet := .F.
			EndIf
		ElseIf cTagToma3 == "2"
			cTagRec := If(ValType(XmlChildEx(oXML:_InfCte:_Receb,"_CNPJ")) == "O","_CNPJ","_CPF")

			If cEmpAnt <> '99'
				dbSelectArea("SM0")
				dbSetOrder(1)
				dbGoTop()
				While !Eof()
					If M0_CGC == AllTrim(XmlChildEx(oXML:_InfCte:_Receb,cTagRec):Text) 
						cFilAnt := M0_CODFIL
						cEmpAnt := M0_CODIGO
						lRet := .T.
						Exit
					EndIf
					dbSkip()
				End
			Else
				lRet := .F.
			EndIf
		ElseIf cTagToma3 == "3"
			lToma3Dest := .T.					// Destinatario da nota no processo de transferencia entre filiais
			If AllTrim(XmlChildEx(oXML:_InfCte:_Dest,cTagDest):Text) != AllTrim(cCNPJ_CPF)
				lRet := .F.
			EndIf
		EndIf
	EndIf
	
	//Validacao para tag TOMA4 quando a empresa nao e Remetente, Expedidor, Recebedor nem
	//Destinatario
	If ValType(XmlChildEx(oXML:_InfCte:_Ide,"_TOMA4")) <> "U"
		If AllTrim(oXML:_InfCte:_Ide:_Toma4:_TOMA:Text) == "4"
			cTagToma4 := If(ValType(XmlChildEx(oXML:_InfCte:_Ide:_Toma4,"_CNPJ")) == "O","_CNPJ","_CPF")
			lToma4 := .T.
			If cEmpAnt <> '99'
				dbSelectArea("SM0")
				dbSetOrder(1)
				dbGoTop()
				While !Eof()
					If M0_CGC == AllTrim(XmlChildEx(oXML:_InfCte:_Ide:_Toma4,cTagToma4):Text)
						cFilAnt := M0_CODFIL
						cEmpAnt := M0_CODIGO
						lRet := .T.
						Exit
					EndIf
					dbSkip()
				End
			Else
				lRet := .F.
			EndIf
		EndIf
	EndIf
	
	If !lRet
		If cEmpAnt <> '99'
		If !lJob
			Aviso("Erro","Este XML pertence a outra empresa/filial e não podera ser processado na empresa/filial corrente.",{"OK"},2,"ImpXML_CTe")
		EndIf
		aAdd(aErros,{cFile,"COM002 - " + "Este XML pertence a outra empresa/filial e não podera ser processado na empresa/filial corrente.",""})
		aAdd(aErroErp,{cFile,"COM002"})
		Else
			lRet := .T.
		EndIf	
	Endif

Endif

Return lRet

/*/{Protheus.doc}CTe_RetTES
Funcao que retorna TES e cond. pagto para utilizacao no CTe

@param	oXml: objeto com o XML do CTe
@param	cTES_CT: variavel que recebera o codigo da TES (referencia)
@param	cCPag_CT: variavel que recebera o codigo da cond pagto.

@author Andre Anjos
@since  06/08/12
/*/

Static Function CTe_RetTES(oXML,cTES_CT,cCPag_CT)
Local aAux 	   := {}
Local cError   := ""
Local cWarning := ""

Default oXML   	 := NIL 
Default cTES_CT  := ""
Default cCPag_CT := ""

cTES_CT  := SuperGetMV("MV_XMLTECT",.F.,"")
cCPag_CT := SuperGetMV("MV_XMLCPCT",.F.,"")

SF4->(dbSetOrder(1))
SDS->(dbSetOrder(2))

//-- Ponto de entrada para alterar a TES a utilizar no CTe
If ExistBlock("A116TECT")
	aAux := ExecBlock("A116TECT",.F.,.F.,{oXML})
	If ValType(aAux[1]) == "C" .And. !Empty(aAux[1]) .And. SF4->(dbSeek(xFilial("SF4")+aAux[1]))
		cTES_CT := aAux[1]
	EndIf
	If ValType(aAux[2]) == "C" .And. !Empty(aAux[2]) .And. SE4->(dbSeek(xFilial("SE4")+aAux[2]))
		cCPag_CT := aAux[2]
	EndIf
EndIf

Return 

/*/{Protheus.doc}A116ICLIFOR
Verifica o fornecedor do conhecimento de frete

@param	c116CNPJ: CNPJ
@param	c116INSC: IE
@param	c116Alias: Alias (SA2 ou SA1)
@param	aFilDest: Filiais destino
@param	oXML: oXML do CT-e
@param	cBusca116: CNPJ/CPF da empresa que ira processar.

@author Andre Anjos
@since  08/06/12
/*/

Static Function A116ICLIFOR(c116CNPJ,c116INSC,c116Alias,aFilDest,oXML,cBusca116)

Local aRet			:= {}
Local aAuxFor		:= {}
Local aArea		:= {}
Local c116Fil		:= xFilial(c116Alias)
Local cCodigo		:= ""
Local cLoja		:= ""
Local cNomeFor	:= ""
Local nQCNPJ		:= 0
Local nQINSC		:= 0
Local lAchoCliFor	:= .F.
Local lCliente	:= .F.
Local nBloq		:= 0
Local lBloq      := .F.
Local cCodBlq		:= ""
Local cLojBlq		:= ""
Local cNomFBlq	:= ""
Local cCliFor		:= ""

Default cBusca116 := ''

aArea := GetArea()

c116Alias := "SA2"

DbSelectArea(c116Alias)
(c116Alias)->(DbSetOrder(3))
If (c116Alias)->(DbSeek(xFilial("SA2") +  c116CNPJ))
		cCodigo 	:= (c116Alias)->&(Substr(c116Alias,2,2)+"_COD")
		cLoja   	:= (c116Alias)->&(Substr(c116Alias,2,2)+"_LOJA")
		cNomeFor 	:= (c116Alias)->&(Substr(c116Alias,2,2)+"_NOME")
		nQCNPJ++
		nQINSC++
		lAchoCliFor := .T.
Else
	cCepT 	:= ""
	cRecpis	:= ""
	cRecCof	:= ""
	cRecCsl	:= ""
	cCalcIR	:= ""
	GRTRIB	:= ""
	cEstado   := ""
	cGRTRIB   := ""
	CCOMPLEM  := ""
	cPessoa   := ""
	aDestFor  := {}
	cCod      := "" 
	
	DbSelectarea('SA2')
	SA2->(dbSetorder(3))
	If SA2->(dbSeek(xFilial("SA2")+Substr(Alltrim(c116CNPJ),1,8))) .And.  !Empty(c116CNPJ)//Verifica se o forncecedor não é uma filial 
		cCod  := SA2->A2_COD
		If Substr(Alltrim(c116CNPJ),9,5) <> Substr(SA2->A2_CGC,9,5)
			While SA2->(!Eof()) .and. SA2->A2_COD == cCod
				cLoja		:=	Soma1(SA2->A2_LOJA) //carrega loja novo cliente
				cCod		:=	SA2->A2_COD
				SA2->(dbSkip())
			Enddo
		EndIf
		
	Else
		cCod := Getsxenum('SA2','A2_COD')
		cLoja:= '01'
	EndIf
	
	cEstado     := oXml:_INFCTE:_DEST:_ENDERDEST:_UF:TEXT	
	cNOME      	:= UPPER(oXml:_INFCTE:_EMIT:_XNOME:TEXT)
	cNREDUZ    	:= UPPER(oXml:_INFCTE:_EMIT:_XNOME:TEXT)
	cEND       	:= UPPER(oXml:_INFCTE:_EMIT:_ENDEREMIT:_XLGR:TEXT)
	cNUM       	:= UPPER(oXml:_INFCTE:_EMIT:_ENDEREMIT:_NRO:TEXT)
	cBAIRRO    	:= UPPER(oXml:_INFCTE:_EMIT:_ENDEREMIT:_XBAIRRO:TEXT)
	cMUN       	:= UPPER(oXml:_INFCTE:_EMIT:_ENDEREMIT:_XMUN:TEXT)
	cINSCR     	:= UPPER(oXml:_INFCTE:_EMIT:_IE:TEXT)
	cCOD_MUN   	:= SUBSTR(oXml:_INFCTE:_EMIT:_ENDEREMIT:_CMUN:TEXT,3,5)
	cCGC       	:= c116CNPJ //UPPER(oXml:_INFCTE:_EMIT:_CNPJ:TEXT) 
	cCEP       	:= UPPER(oXml:_INFCTE:_EMIT:_ENDEREMIT:_CEP:TEXT)
	
	if val(cNUM) # 0 // Se numero for valido, sera inserido no endereco, caso contrario sera inserido no complemento
		cEND := STRTRAN(cEND,",",".")
		cEND += ", "+cNUM
	else
		cCOMPLEM := cNUM
	endif
	
	cTIPO      := IF(LEN(cCGC)=11,'F','J')
	
	DbSelectarea('SA2')
	
	aDestFor  := {      {"A2_FILIAL"     ,xFilial("SA2")    ,Nil},;
						{"A2_COD"       ,cCod    			,Nil},;
						{"A2_LOJA"      ,cLoja   			,Nil},;
						{"A2_TPESSOA"	,cPessoa 			,Nil},;
						{"A2_CGC"       ,cCGC    			,Nil},;
						{"A2_CEP"       ,cCEP    			,Nil},;
						{"A2_EST"       ,cESTADO 			,Nil},;
						{"A2_END"       ,cEND    			,Nil},;
						{"A2_BAIRRO"    ,cBAIRRO 			,Nil},;
						{"A2_COD_MUN"   ,cCOD_MUN 			,Nil},;
						{"A2_MUN"       ,cMUN    			,Nil},;
						{"A2_COMPLEM"   ,cCOMPLEM			,Nil},;
						{"A2_INSCR"     ,cINSCR  			,Nil},;
						{"A2_NOME"      ,cNOME   			,Nil},;
						{"A2_NREDUZ"    ,cNREDUZ 			,Nil},;
						{"A2_TIPO"      ,cTIPO   			,Nil}}
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Grava cadastro do fornecedor.                                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	RecLock("SA2",.T.)
	For nX := 1 To Len(aDestFor)	
		SA2->&(aDestFor[nX,1])	:= aDestFor[nX,2]	
	Next
	MsUnLock() 
	ConfirmSX8() 

// grava variaves padrao
cCodigo		:= SA2->A2_COD
cLoja		:= SA2->A2_LOJA
lCliente	:= .T.
nQCNPJ 		:= 1
nQINSC 		:= 1
lAchoCliFor	:= .T.

EndIf

If (nQCNPJ > 1 .And. nQINSC <> 1) .Or. lBloq
	aAdd(aRet,{.F.,cCodigo,cLoja,lCliente,lBloq,cCliFor})
ElseIf lAchoCliFor
	aAdd(aRet,{.T.,cCodigo,cLoja,lCliente,lBloq,cCliFor})
EndIf

RestArea(aArea)

Return aRet

/*/{Protheus.doc}TIPOCTE116
Converte as opcoes do campo F1_TPCTE em relacao ao XML do CT-e

@author Ciro Pedreira Data
@since  16/05/2016
/*/

Static Function TIPOCTE116(cTpCte)

Local cRet := ''
Local aOpc := {}
Local nPos := 0

// Neste momento é realizado um De/Para das opcoes, pois o XML da Fazenda trabalha com numeros
// e o Protheus com letras no campo F1_TPCTE.
AAdd(aOpc, {'0', 'N'})
AAdd(aOpc, {'1', 'C'})
AAdd(aOpc, {'2', 'A'})

nPos := AScan(aOpc, {|o| o[1] == AllTrim(cTpCte) })

If nPos > 0
	
	cRet := aOpc[nPos][2]
	
EndIf 

Return cRet

/*/{Protheus.doc}A116IFOCL
Busca pelo fornecedor/cliente da nf origem.

@param	aDadosAux: Array com os dados do fornecedor/cliente
@param	cTipo: "F" - Fornecedor, "C" - Cliente

@return aRet: array com os dados do fornecedor ou cliente

@author Rodrigo Pontes
@since  16/05/17
/*/

Static Function A116IFOCL(aDadosAux,cTipo)

Local aRet	:= {}
Local nPos	:= 0

nPos := aScan(aDadosAux,{|x| x[6] == cTipo})
If nPos > 0
	aRet := aDadosAux[nPos]
Endif

Return aRet