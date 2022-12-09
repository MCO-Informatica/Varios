#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.ch"
#INCLUDE "TopConn.ch"
#INCLUDE "AP5MAIL.CH"

#DEFINE XML_NOTAS	001
#DEFINE XML_SERIE	002
#DEFINE XML_CNPJE	003
#DEFINE XML_NOMES	004
#DEFINE XML_TIPOS	005
#DEFINE XML_TOTAL	006
#DEFINE XML_TPDOC	007
#DEFINE XML_DATAS	008
#DEFINE XML_HORAS	009
#DEFINE XML_ESTAD	010
#DEFINE XML_CHVNF	011
#DEFINE XML_CNPJD	012
#DEFINE XML_FILES	013
#DEFINE XML_ARQUI	014


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ PRENOTAº Autor ³ Luiz Alberto º Data ³ 29/10/10 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Leitura e Importacao Arquivo XML para geração de Pre-Nota  º±±
±±º          ³                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±\\ fonte
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

//-- Ponto de Entrada para incluir botão na Pré-Nota de Entrada


/* ATENCAO PARA QUE A ROTINA FUNCIONE CORRETAMENTE
EXISTE A NECESSIDADE DE CRIAÇÃO DE DOIS INDICES

TABELA SA5
CHAVE: FILIAL + FORNECEDOR + LOJA + CODIGO PRODUTO NO FORNECEDOR

A5_FILIAL + A5_FORNECE + A5_LOJA + A5_CODPRF

NICK NAME - > FORPROD

TABELA SA7
CHAVE: FILIAL + CLIENTE + LOJA + CODIGO PRODUTO CLIENTE

A7_FILIAL + A7_CLIENTE + A7_LOJA + A7_CODCLI

NICK NAME -> CLIPROD

**Cleber Orati** :
  * Caso banco de dados não for compatível excluir cláusula WITH (NOLOCK) da 
  query que consulta pedidos, esta cláusula impede que registros bloqueados (em transaction) bloqueiem a consulta
    

*/
User Function ImpXML()
Local aTipo			:={'N','B','D'}
Local cAuxMail,lBloqueado,nX,nIpi,lMarcou,lAchou,_nx
Private CPERG   	:="NOTAXML"
Private _cMarca   := GetMark()
Private aFields   := {}
Private cArq,nHdl
Private aFields2  := {}
Private cArq2,cProds,cCodBar
Private oAux,oICM,oNF,oNFChv,oEmitente,oIdent,oDestino,oTotal,oTransp,oDet,cChvNfe  
Private oFatura,cEdit1,_DESCdigit,_NCMdigit,lOut,lOk,_oPT00005
Private lMsErroAuto,lMsHelpAuto
Private lPcNfe		:= GETMV("MV_PCNFE")
Private aSa7Aux    :={}
Private cArquivo 		:= ""
Private oArquivo
Private MV_PAR01	:= 1
Private aXmls		:= {}
Private aArqXmls		:= {}
Private oArqsImp
Private _oPT00005
PRIVATE oFntLBox := TFont():New("Arial Narrow",,018,,.F.,,,,,.F.,.F.)


// Efetua leitura da Caixa Postal e Baixa os XML´s

//Processa( {|| LerEmail()   },"Efetuando Leitura dos XML´s por Email Aguarde..." )

PutMV("MV_PCNFE",.f.)


	DEFINE MSDIALOG _oPT00005 TITLE 'Busca de XML de Notas Fiscais de Entrada' FROM 000, 000  TO 500, 1000 COLORS 0, 16777215 PIXEL 

	@ 003, 005 LISTBOX oArqsImp Fields HEADER 'Nota','Série','CNPJ','Razão Social','Tipo Nota','Valor Total','Tipo DOC','Data','Hora','UF','Chave','CNPJ Destinatário','Arquivo' SIZE 490, 220 OF _oPT00005 FONT oFntLBox PIXEL ColSizes 50,50

	// Efetua leitura DA pASTA

	Processa( {|| LerDir(@aArqXmls)   },"Efetuando Leitura dos XML´s Na Pasta..." )


	oArqsImp:bHeaderClick := {|| nColPos :=oArqsImp:ColPos,lSortOrd := !lSortOrd, aSort(aArqXmls,,,{|x,y| Iif(lSortOrd,x[nColPos] > y[nColPos],x[nColPos] < y[nColPos]) }),oArqsImp:Refresh()} 

	@ 230,005 Button OemToAnsi("Gera Pré-Nota")  Size 060,016 	ACTION (MsAguarde({||ImpXml(aArqXmls[oArqsImp:nAt,XML_FILES],aArqXmls[oArqsImp:nAt,XML_TIPOS])},'Processando XML...'), Processa( {|| LerDir(@aArqXmls)   },"Efetuando Leitura dos XML´s Na Pasta..." ))
	@ 230,105 Button OemToAnsi("Abrir XML")  Size 060,016 		ACTION MsAguarde({|| VerXml(aArqXmls[oArqsImp:nAt,XML_FILES],aArqXmls[oArqsImp:nAt,XML_ARQUI]) },"Aguarde","Abrindo Arquivo XML...",.F.)
	@ 230,205 Button OemToAnsi("Excluir XML")  Size 060,016 	ACTION (ExcXml(aArqXmls[oArqsImp:nAt,XML_FILES]), Processa( {|| LerDir(@aArqXmls)   },"Efetuando Leitura dos XML´s Na Pasta..." ))
	@ 230,305 Button OemToAnsi("Ler Email")  Size 060,016 		ACTION (Processa( {|| LerEmail()   },"Efetuando Leitura dos XML´s por Email Aguarde..." ),Processa( {|| LerDir(@aArqXmls)   },"Efetuando Leitura dos XML´s Na Pasta..." ))
	@ 230,405 Button OemToAnsi("Sair")   Size 060,016 			Action (Close(_oPT00005)) //Fecha()
	
	Activate Dialog _oPT00005 CENTERED
	
Return Nil


Static Function ImpXml(cArquivo,cTipo)	
Local nX
Local ni

	//cArquivo := cCodBar
	
	If empty(cArquivo) .or. (!Empty(cArquivo) .and. !File(cArquivo))
		MsgAlert("Arquivo Não Encontrado no Local de Origem Indicado!")
		Return .f.
	Endif
	

	If !MsgYesNo ("Confirma a Geração da Pré-Nota ?")
		Return .F.
	Endif

	nHdl    := fOpen(cArquivo,0)

	aCamposPE:={}
	
	If nHdl == -1
		If !Empty(cArquivo)
			MsgAlert("O arquivo de nome "+cArquivo+" nao pode ser aberto! Verifique os parametros.","Atencao!")
		Endif
		PutMV("MV_PCNFE",lPcNfe)
		Return
	Endif
	nTamFile := fSeek(nHdl,0,2)
	fSeek(nHdl,0,0)
	cBuffer  := Space(nTamFile)                // Variavel para criacao da linha do registro para leitura
	nBtLidos := fRead(nHdl,@cBuffer,nTamFile)  // Leitura  do arquivo XML
	fClose(nHdl)
	
	cAviso := ""
	cErro  := ""
	oNfe := XmlParser(cBuffer,"_",@cAviso,@cErro)
	
	If Type("oNFe:_NfeProc")<> "U"
		oNF := oNFe:_NFeProc:_NFe
	Else   
		if Type("oNFe:_NFe") <> "U"
			oNF := oNFe:_NFe
		ELSE  
			MsgAlert("Não foi possível abrir o arquivo XML, provavel falha em sua estrutura. Por favor substitua o arquivo","Atencao!")
		ENDIF 
	Endif
	
//	oNFChv := oNFe:_NFeProc:_protNFe
	oNFChv := oNF
	
	oEmitente  := oNF:_InfNfe:_Emit
	oIdent     := oNF:_InfNfe:_IDE
	oDestino   := oNF:_InfNfe:_Dest
	oTotal     := oNF:_InfNfe:_Total
	oTransp    := oNF:_InfNfe:_Transp
	oDet       := oNF:_InfNfe:_Det
	cChvNfe    := Substr(oNFChv:_InfNfe:_ID:TEXT,4,44)				
//	cChvNfe    := oNFChv:_INFPROT:_CHNFE:TEXT
	//rodolfo
//	If Type("oNFe:_NfeProc")<> "U"
//		cChvNfe    := oNFChv:_INFPROT:_CHNFE:TEXT	
//		cChvNfe    := Substr(oNFChv:_InfNfe:TEXT,4,44)	
//	Elseif Type("oNFe:_NFe") <> "U"
//		cChvNfe    := Substr(oNFChv:_InfNfe:_ID:TEXT,4,44)				
//	Endif
	
	//	<chNFe>41101108365527000121550050000014611623309134</chNFe>
	If Type("oNF:_InfNfe:_ICMS")<> "U"
		oICM := oNF:_InfNfe:_ICMS
	Else
		oICM := nil
	Endif 
	
	oFatura    := IIf(Type("oNF:_InfNfe:_Cobr")=="U",Nil,oNF:_InfNfe:_Cobr)
	cEdit1	   := Space(15)
	_DESCdigit :=space(55)
	_NCMdigit  :=space(8)
	
	
	oDet := IIf(ValType(oDet)=="O",{oDet},oDet)
	// Validações -------------------------------
	// -- CNPJ da NOTA = CNPJ do CLIENTE ? oEmitente:_CNPJ
	// CNPJ ou CPF
	
	cCgc := AllTrim(IIf(Type("oDestino:_CPF")=="U",oDestino:_CNPJ:TEXT,oDestino:_CPF:TEXT)) 

	lAchou  := .f.
	xFilAnt := cFilAnt
	nReg	:= SM0->(Recno())
	SM0->(dbGoTop())
	While SM0->(!Eof())
		If AllTrim(cCGC) == alltrim(SM0->M0_CGC)
			lAchou := .t.
			Exit
		Endif
		
		SM0->(dbSkip(1))
	Enddo
	
	If lAchou
		cFilAnt := SM0->M0_CODFIL
	Else
		SM0->(dbGoTo(nReg))
	Endif

	if !(cCgc == alltrim(SM0->M0_CGC))
		MsgAlert("Nota Fiscal pertencente a OUTRA EMPRESA ou FILIAL. Por favor efetuar login no seguinte CNPJ: " + cCgc + " Empresa: " + SM0->M0_COD + " Filial: " + SM0->M0_CODFIL)
		Return .f.
	Endif
		

	cCgc := AllTrim(IIf(Type("oEmitente:_CPF")=="U",oEmitente:_CNPJ:TEXT,oEmitente:_CPF:TEXT))
	

	lAchou := .f.                                   
	// Considerar situação em que registro está bloqueado
	If cTipo $ 'N/C' // Nota Normal Fornecedor                     
		dbselectarea("SA2")
		dbSetOrder(3)
		dbSeek(xFilial("SA2")+cCgc)
		do while !lAchou .and. !eof() .and. (xFilial("SA2") = SA2->A2_FILIAL) .AND. (TRIM(SA2->A2_CGC) == cCgc)
			IF FieldPos("A2_MSBLQL") > 0
				IF !(SA2->A2_MSBLQL == "1")
					lAchou := .t.          
					EXIT
				endif
			else
				lAchou := .t.  
				EXIT 
			endif
			dbselectarea('SA2')
			dbskip()
		enddo 
	Else
		dbselectarea("SA1")
		dbSetOrder(3)
		dbSeek(xFilial("SA1")+cCgc)
		do while !lAchou .and. !eof() .and. (xFilial("SA1") = SA1->A1_FILIAL) .AND. (TRIM(SA1->A1_CGC) == cCgc)
			IF FieldPos("A1_MSBLQL") > 0
				IF !(SA1->A1_MSBLQL == "1")
					lAchou := .t.
					EXIT 
				endif
			else
				lAchou := .t.    
				EXIT 
			endif
			dbselectarea('SA1')
			dbskip()
		enddo 
	Endif
	If !lAchou
		MsgAlert("CNPJ Origem Não Localizado - Verifique " + cCgc)
		PutMV("MV_PCNFE",lPcNfe)
		Return
	Endif
	
	// -- Nota Fiscal já existe na base ?
	If SF1->(DbSeek(XFilial("SF1")+Right("000000000"+Alltrim(OIdent:_nNF:TEXT),9)+Padr(OIdent:_serie:TEXT,3)+SA2->A2_COD+SA2->A2_LOJA))
		IF cTipo $ 'N/C'
			MsgAlert("Nota No.: "+Right("000000000"+Alltrim(OIdent:_nNF:TEXT),9)+"/"+OIdent:_serie:TEXT+" do Fornec. "+SA2->A2_COD+"/"+SA2->A2_LOJA+" Ja Existe. A Importacao sera interrompida")
		Else
			MsgAlert("Nota No.: "+Right("000000000"+Alltrim(OIdent:_nNF:TEXT),9)+"/"+OIdent:_serie:TEXT+" do Cliente "+SA1->A1_COD+"/"+SA1->A1_LOJA+" Ja Existe. A Importacao sera interrompida")
		Endif
		PutMV("MV_PCNFE",lPcNfe)
		Return Nil
	EndIf
	
	
	cCGC	:= If(cTipo$'N/C',SA2->A2_CGC,SA1->A1_CGC)
	
	aCabec := {}
	aItens := {}
	If Type("OIdent:_dhEmi:TEXT") <> "U"	// Data da Emissao Versao NFE 3.10
		dData:=StoD(StrTran(Left(Alltrim(OIdent:_dhEmi:TEXT),10),'-',''))
	ElseIf Type("OIdent:_dEmi:TEXT") <> "U"
		cData:=Alltrim(OIdent:_dEmi:TEXT)	// Data da Emissao Versao NFE 2.0
		dData:=CTOD(Right(cData,2)+'/'+Substr(cData,6,2)+'/'+Left(cData,4))
	Endif

	aadd(aCabec,{"F1_FILIAL" ,xFilial("SF1"),Nil,Nil})
	aadd(aCabec,{"F1_TIPO"   ,cTipo,Nil,Nil})
	aadd(aCabec,{"F1_FORMUL" ,"N",Nil,Nil})
	aadd(aCabec,{"F1_DOC"    ,Right("000000000"+Alltrim(OIdent:_nNF:TEXT),9),Nil,Nil})
	aadd(aCabec,{"F1_SERIE"  ,StrZero(Val(OIdent:_serie:TEXT),3),Nil,Nil})
	aadd(aCabec,{"F1_EMISSAO",dData,Nil,Nil})
	aadd(aCabec,{"F1_FORNECE",If(cTipo$'N/C',SA2->A2_COD,SA1->A1_COD),Nil,Nil})
	aadd(aCabec,{"F1_LOJA"   ,If(cTipo$'N/C',SA2->A2_LOJA,SA1->A1_LOJA),Nil,Nil})
	aadd(aCabec,{"F1_ESPECIE","SPED ",Nil,Nil})
	aAdd(aCabec,{"F1_DTDIGIT"     ,ddatabase 	    		,Nil})
	aadd(aCabec,{"F1_CHVNFE",cChvNfe,Nil,Nil})
	aAdd(aCabec,{"F1_EST"         ,If(cTipo$'N/C',SA2->A2_EST,SA1->A1_EST)				,Nil})
	aAdd(aCabec,{"F1_HORA"        ,SubStr(Time(),1,5)		,Nil})
	
	cProds := ''
	aPedIte:={}
	
	For nX := 1 To Len(oDet)
		cEdit1 := Space(15)
		_DESCdigit :=space(55)
		_NCMdigit  :=space(8)
		
		If cTipo$'N/C'
			cProduto:=PadR(AllTrim(oDet[nX]:_Prod:_cProd:TEXT),TamSx3("A5_CODPRF")[1])
			xProduto:=cProduto
			
			oAux := oDet[nX]
			cNCM:=IIF(Type("oAux:_Prod:_NCM")=="U",space(12),oAux:_Prod:_NCM:TEXT)
			cCFOP:=IIF(Type("oAux:_Prod:_CFOP")=="U",space(04),oAux:_Prod:_CFOP:TEXT)

			Chkproc=.F.
			
			If !SA5->(DbSetOrder(14),dbSeek(xFilial("SA5")+SA2->A2_COD+SA2->A2_LOJA+cProduto))
				If !MsgYesNo ("Produto Cod.: "+cProduto+" Nao Encontrado. Digita Codigo de Substituicao?")
					PutMV("MV_PCNFE",lPcNfe)
					Return Nil
				Endif
				DEFINE MSDIALOG _oDlg TITLE "Dig.Cod.Substituicao - Item: " + Str(nX,4) + ' de ' + Str(Len(oDet),4) FROM C(177),C(192) TO C(409),C(659) PIXEL
				
				// Cria as Groups do Sistema
				@ C(002),C(003) TO C(101),C(186) LABEL "Dig.Cod.Substituicao " PIXEL OF _oDlg
				
				// Cria Componentes Padroes do Sistema
				@ C(012),C(027) Say "Produto: "+cProduto+" - NCM: "+cNCM Size C(150),C(008) COLOR CLR_HBLUE PIXEL OF _oDlg
				@ C(020),C(027) Say "Descricao: "+oDet[nX]:_Prod:_xProd:TEXT Size C(150),C(12) COLOR CLR_HBLUE PIXEL OF _oDlg
				@ C(058),C(027) Say "Código: " Size C(50),C(008) COLOR CLR_HBLUE PIXEL OF _oDlg
//				@ C(020),C(027) Say "Descricao: "+oDet[nX]:_infAdProd:TEXT Size C(150),C(12) COLOR CLR_HBLUE PIXEL OF _oDlg
				@ C(058),C(070) MsGet oEdit1 Var cEdit1 F3 "SB1" Valid(ValProd(cTipo)) Size C(060),C(009) COLOR CLR_HBLUE PIXEL OF _oDlg
				@ C(070),C(027) Say "Produto digitado: "+cEdit1+" - NCM: "+_NCMdigit + " - CFOP: " + cCFOP Size C(150),C(008) COLOR CLR_HBLUE PIXEL OF _oDlg
				@ C(078),C(027) Say "Descricao: "+_DESCdigit Size C(150),C(008) COLOR CLR_HBLUE PIXEL OF _oDlg
				@ C(004),C(194) Button "Processar" Size C(037),C(012) PIXEL OF _oDlg Action(Troca())
				@ C(025),C(194) Button "Cancelar" Size C(037),C(012) PIXEL OF _oDlg Action(_oDlg:End())
				oEdit1:SetFocus()
				
				ACTIVATE MSDIALOG _oDlg CENTERED
				If !Chkproc
					MsgAlert("Produto Cod.: "+cProduto+" Nao Encontrado. A Importacao sera interrompida")
					PutMV("MV_PCNFE",lPcNfe)
					Return Nil
				Else
					If SA5->(DbSetOrder(14),dbSeek(xFilial("SA5")+SA2->A2_COD+SA2->A2_LOJA+cProduto))
						RecLock("SA5",.f.)
					Else
						Reclock("SA5",.t.)
					Endif
					
					SA5->A5_FILIAL := xFilial("SA5")
					SA5->A5_FORNECE := SA2->A2_COD
					SA5->A5_LOJA 	:= SA2->A2_LOJA
					SA5->A5_NOMEFOR := SA2->A2_NOME
					SA5->A5_PRODUTO := cEdit1 //SB1->B1_COD
					SA5->A5_NOMPROD := SB1->B1_DESC //oDet[nX]:_Prod:_xProd:TEXT
					SA5->A5_CODPRF  := xProduto
					SA5->(MsUnlock())
				EndIf
			endif 
			SB1->(dbSetOrder(1), dbSeek(xFilial("SB1")+SA5->A5_PRODUTO))
			If !Empty(cNCM) .and. cNCM != '00000000' .And. empty(SB1->B1_POSIPI) //SB1->B1_POSIPI <> cNCM
				If RecLock("SB1",.F.)
					SB1->B1_POSIPI  := cNCM
					SB1->(MsUnlock())
				Endif
			Endif
		Else
			cProduto:=PadR(AllTrim(oDet[nX]:_Prod:_cProd:TEXT),TamSx3("A7_CODCLI")[1])
			xProduto:=cProduto
			oAux := oDet[nX]			
			cNCM:=IIF(Type("oAux:_Prod:_NCM")=="U",space(12),oAux:_Prod:_NCM:TEXT)
			cCFOP:=IIF(Type("oAux:_Prod:_CFOP")=="U",space(04),oAux:_Prod:_CFOP:TEXT)
			Chkproc=.F.
			
			SA7->(dbSetOrder(3))	//DbOrderNickName("CLIPROD"))   // FILIAL + FORNECEDOR + LOJA + CODIGO PRODUTO NO FORNECEDOR
			
			If !SA7->(dbSeek(xFilial("SA7")+SA1->A1_COD+SA1->A1_LOJA+cProduto))
				If !MsgYesNo ("Produto Cod.: "+cProduto+" Nao Encontrado. Digita Codigo de Substituicao?")
					PutMV("MV_PCNFE",lPcNfe)
					Return Nil
				Endif
				DEFINE MSDIALOG _oDlg TITLE "Dig.Cod.Substituicao - Item: " + Str(nX,4) + ' de ' + Str(Len(oDet),4) FROM C(177),C(192) TO C(409),C(659) PIXEL
				
				// Cria as Groups do Sistema
				@ C(002),C(003) TO C(071),C(186) LABEL "Dig.Cod.Substituicao " PIXEL OF _oDlg
				
				// Cria Componentes Padroes do Sistema
				@ C(012),C(027) Say "Produto: "+cProduto+" - NCM: "+cNCM Size C(150),C(008) COLOR CLR_HBLUE PIXEL OF _oDlg
				@ C(020),C(027) Say "Descricao: "+oDet[nX]:_Prod:_xProd:TEXT Size C(150),C(008) COLOR CLR_HBLUE PIXEL OF _oDlg
				@ C(028),C(027) Say "Código: " Size C(50),C(008) COLOR CLR_HBLUE PIXEL OF _oDlg
				@ C(028),C(070) MsGet oEdit1 Var cEdit1 F3 "SB1" Valid(ValProd(cTipo)) Size C(060),C(009) COLOR CLR_HBLUE PIXEL OF _oDlg
				@ C(040),C(027) Say "Produto digitado: "+cEdit1+" - NCM: "+_NCMdigit Size C(150),C(008) COLOR CLR_HBLUE PIXEL OF _oDlg
				@ C(048),C(027) Say "Descricao: "+_DESCdigit Size C(150),C(008) COLOR CLR_HBLUE PIXEL OF _oDlg
				@ C(004),C(194) Button "Processar" Size C(037),C(012) PIXEL OF _oDlg Action(Troca())
				@ C(025),C(194) Button "Cancelar" Size C(037),C(012) PIXEL OF _oDlg Action(_oDlg:End())
				oEdit1:SetFocus()
				
				ACTIVATE MSDIALOG _oDlg CENTERED
				If !Chkproc
					MsgAlert("Produto Cod.: "+cProduto+" Nao Encontrado. A Importacao sera interrompida")
					PutMV("MV_PCNFE",lPcNfe)
					Return Nil
				Else
					If !SA7->(dbSetOrder(1), dbSeek(xFilial("SA7")+SA1->A1_COD+SA1->A1_LOJA+cEdit1))
						Reclock("SA7",.t.)
					
						SA7->A7_FILIAL := xFilial("SA7")
						SA7->A7_CLIENTE := SA1->A1_COD
						SA7->A7_LOJA 	:= SA1->A1_LOJA
						SA7->A7_DESCCLI := SB1->B1_DESC //oDet[nX]:_Prod:_xProd:TEXT
						SA7->A7_PRODUTO := cEdit1 //SB1->B1_COD
						SA7->A7_CODCLI  := xProduto
						SA7->(MsUnlock())
					Endif
					
				EndIf
			endif 
			SB1->(dbSetOrder(1), dbSeek(xFilial("SB1")+SA7->A7_PRODUTO))
			If !Empty(cNCM) .and. cNCM != '00000000' .And. empty(SB1->B1_POSIPI) //SB1->B1_POSIPI <> cNCM
				If RecLock("SB1",.F.)
					SB1->B1_POSIPI  := cNCM
					SB1->(MsUnlock())
				Endif
			Endif
		Endif
		SB1->(dbSetOrder(1))
		
		cProds += ALLTRIM(SB1->B1_COD)+'/'
		
		AAdd(aPedIte,{SB1->B1_COD,Val(oDet[nX]:_Prod:_qTrib:TEXT),Round(Val(oDet[nX]:_Prod:_vProd:TEXT)/Val(oDet[nX]:_Prod:_qCom:TEXT),6),Val(oDet[nX]:_Prod:_vProd:TEXT)})
		
	Next nX
	
	// Retira a Ultima "/" da Variavel cProds
	
	cProds := Left(cProds,Len(cProds)-1)
	
	aCampos := {}
	aCampos2:= {}
	
	AADD(aCampos,{'T9_OK'			,'#','@!','2','0'})
	AADD(aCampos,{'T9_PEDIDO'		,'Pedido','@!','6','0'})
	AADD(aCampos,{'T9_ITEM'			,'Item','@!','3','0'})
	AADD(aCampos,{'T9_PRODUTO'		,'PRODUTO','@!','15','0'})
	AADD(aCampos,{'T9_DESC'			,'Descrição','@!','40','0'})
	AADD(aCampos,{'T9_UM'			,'Un','@!','02','0'})
	AADD(aCampos,{'T9_QTDE'			,'Qtde','@EZ 999,999.9999','10','4'})
	AADD(aCampos,{'T9_UNIT'			,'Unitario','@EZ 9,999,999.99','12','2'})
	AADD(aCampos,{'T9_TOTAL'		,'Total','@EZ 99,999,999.99','14','2'})
	AADD(aCampos,{'T9_DTPRV'		,'Dt.Prev','','10','0'})
	AADD(aCampos,{'T9_ALMOX'		,'Alm','','2','0'})
	AADD(aCampos,{'T9_OBSERV'		,'Observação','@!','30','0'})
	AADD(aCampos,{'T9_CCUSTO'		,'C.Custo','@!','6','0'})
	AADD(aCampos,{'T9_TES'			,'TES','999','3','0'})
	
	AADD(aCampos2,{'T8_NOTA'			,'N.Fiscal','@!','9','0'})
	AADD(aCampos2,{'T8_SERIE'		,'Serie','@!','3','0'})
	AADD(aCampos2,{'T8_PRODUTO'		,'PRODUTO','@!','15','0'})
	AADD(aCampos2,{'T8_DESC'			,'Descrição','@!','40','0'})
	AADD(aCampos2,{'T8_UM'			,'Un','@!','02','0'})
	AADD(aCampos2,{'T8_QTDE'			,'Qtde','@EZ 999,999.9999','10','4'})
	AADD(aCampos2,{'T8_UNIT'			,'Unitario','@EZ 9,999,999.99','12','2'})
	AADD(aCampos2,{'T8_TOTAL'		,'Total','@EZ 99,999,999.99','14','2'})
	
	Cria_TC9()
	
	For ni := 1 To Len(aPedIte)
		RecLock("TC8",.t.)
		TC8->T8_NOTA 	:= Right("000000000"+Alltrim(OIdent:_nNF:TEXT),9)
		TC8->T8_SERIE 	:= OIdent:_serie:TEXT
		TC8->T8_PRODUTO := aPedIte[nI,1]
		TC8->T8_DESC	:= Posicione("SB1",1,xFilial("SB1")+aPedIte[nI,1],"B1_DESC")
		TC8->T8_UM		:= SB1->B1_UM
		TC8->T8_QTDE	:= aPedIte[nI,2]
		TC8->T8_UNIT	:= aPedIte[nI,3]
		TC8->T8_TOTAL	:= aPedIte[nI,4]
		TC8->(msUnlock())
	Next
	TC8->(dbGoTop())
	
	Monta_TC9()
	
	lOk := .f.
	lOut := .f.	//POLIESTER
	If !Empty(TC9->(RecCount()))
		
		
		DbSelectArea('TC9')
		@ 100,005 TO 500,750 DIALOG oDlgPedidos TITLE "Pedidos de Compras Associados ao XML selecionado!"	//Poliester
		
		
		@ 006,005 TO 100,325 BROWSE "TC9" MARK "T9_OK" FIELDS aCampos Object _oBrwPed
		
		@ 066,330 BUTTON "Marcar"         SIZE 40,15 ACTION MsAguarde({||MarcarTudo()},'Marcando Registros...')
		@ 086,330 BUTTON "Desmarcar"      SIZE 40,15 ACTION MsAguarde({||DesMarcaTudo()},'Desmarcando Registros...')
		@ 106,330 BUTTON "Processar"	  SIZE 40,15 ACTION MsAguarde({|| lOk := .t. , Close(oDlgPedidos)},'Gerando e Enviando Arquivo...')
		@ 183,330 BUTTON "Sair"			  SIZE 40,15 ACTION MsAguarde({|| lOut := .t., Close(oDlgPedidos)},'Saindo do Sistema')	//POLIESTER
//		@ 183,330 BUTTON "Sair"           SIZE 40,15 ACTION Close(oDlgPedidos)
		
//		Processa({||  } ,"Selecionando Informacoes de Pedidos de Compras...")
		
		DbSelectArea('TC8')
		
		@ 100,005 TO 190,325 BROWSE "TC8" FIELDS aCampos2 Object _oBrwPed2
		
		DbSelectArea('TC9')
		
		_oBrwPed:bMark := {|| Marcar()}
		
		ACTIVATE DIALOG oDlgPedidos CENTERED
		
	Endif

//Verifica se o usuário clicou no botão para sair, anteriormente se ele clicasse para sair o sistema ainda fazia a inserçao dos dados, agora não. - Poliester
	If lOut
		Return
	Endif
	
	
	// Verifica se o usuario selecionou algum pedido de compra
	
	dbSelectArea("TC9")
	dbGoTop()
	ProcRegua(Reccount())
	
	lMarcou := .f.
	
	While !Eof() .And. lOk
		IncProc()
		If TC9->T9_OK  <> _cMarca
			dbSelectArea("TC9")
			TC9->(dbSkip(1));Loop
		Else
			lMarcou := .t.
			Exit
		Endif
		
		TC9->(dbSkip(1))
	Enddo

	_xOcItem3:= ''
	
	For nX := 1 To Len(oDet)
		aLinha := {}
		cProduto:=PADR(AllTrim(oDet[nX]:_Prod:_cProd:TEXT),TamSX3( "A5_CODPRF" )[1])
		xProduto:=cProduto
		
		oAux := oDet[nX]
		cNCM:=IIF(Type("oAux:_Prod:_NCM")=="U",space(12),oAux:_Prod:_NCM:TEXT)
		cCFOP:=IIF(Type("oAux:_Prod:_CFOP")=="U",space(04),oAux:_Prod:_CFOP:TEXT)
		Chkproc=.F.
			
		If cTipo$'N/C'
			If !SA5->(DbSetOrder(14), dbSeek(xFilial("SA5")+SA2->A2_COD+SA2->A2_LOJA+cProduto))
				Alert("Atenção, Produto x Fornecedor Não Localizado, Verifique !!!")
				Return .f.
			Endif
			SB1->(dbSetOrder(1) , dbSeek(xFilial("SB1")+SA5->A5_PRODUTO))  
		Else
			SA7->(dbSetOrder(3))
			
			If SA7->(dbSeek(xFilial("SA7")+SA1->A1_COD+SA1->A1_LOJA+cProduto))
				SB1->(dbSetOrder(1) , dbSeek(xFilial("SB1")+SA7->A7_PRODUTO))
			Else
				Alert("Produto Nao Encontrado No Cadastro de Cliente x Produto !")
				Return .f.
			Endif
		Endif

		If SB1->(Eof())
			Alert("Falha No Produto, Verifique !!!")
			Return .f.
		Endif

		aadd(aLinha,{"D1_FILIAL",xFilial("SD1"),Nil,Nil}) //3L Systems
		aadd(aLinha,{"D1_ITEM",StrZero(nX,4),Nil,Nil}) //3L Systems
		aadd(aLinha,{"D1_COD",SB1->B1_COD,Nil,Nil}) //3L Systems
		aadd(aLinha,{"D1_UM",SB1->B1_UM,Nil,Nil}) //3L Systems
		If Val(oDet[nX]:_Prod:_qTrib:TEXT) != 0
			aadd(aLinha,{"D1_QUANT",Val(oDet[nX]:_Prod:_qTrib:TEXT),Nil,Nil})
			aadd(aLinha,{"D1_VUNIT",Round(Val(oDet[nX]:_Prod:_vProd:TEXT)/Val(oDet[nX]:_Prod:_qTrib:TEXT),6),Nil,Nil})
			nQuant := Val(oDet[nX]:_Prod:_qTrib:TEXT)
			nTotal  := Val(oDet[nX]:_Prod:_vProd:TEXT)
		Else
			aadd(aLinha,{"D1_QUANT",Val(oDet[nX]:_Prod:_qCom:TEXT),Nil,Nil})
			aadd(aLinha,{"D1_VUNIT",Round(Val(oDet[nX]:_Prod:_vProd:TEXT)/Val(oDet[nX]:_Prod:_qCom:TEXT),6),Nil,Nil})
			nQuant := Val(oDet[nX]:_Prod:_qCom:TEXT)
			nTotal  := Val(oDet[nX]:_Prod:_vProd:TEXT)
		Endif
		aadd(aLinha,{"D1_TOTAL",Val(oDet[nX]:_Prod:_vProd:TEXT),Nil,Nil})
		_cfop:=oDet[nX]:_Prod:_CFOP:TEXT
		If Left(Alltrim(_cfop),1)="5"
			_cfop:=Stuff(_cfop,1,1,"1")
		Else
			_cfop:=Stuff(_cfop,1,1,"2")
		Endif
		aAdd(aLinha,{"D1_CF"  	   , _cfop          ,NIL})
		aAdd(aLinha,{"D1_FORNECE"  , If(cTipo$'N/C',SA2->A2_COD,SA1->A1_COD)          ,NIL})
		aAdd(aLinha,{"D1_LOJA"     , If(cTipo$'N/C',SA2->A2_LOJA,SA1->A1_LOJA)            ,NIL})
		aAdd(aLinha,{"D1_DOC"      , Right("000000000"+Alltrim(OIdent:_nNF:TEXT),9)             ,NIL})
		aAdd(aLinha,{"D1_EMISSAO"  , dData          ,NIL})
		aAdd(aLinha,{"D1_DTDIGIT"  , dDatabase		          ,NIL})
		aAdd(aLinha,{"D1_SERIE"    , OIdent:_serie:TEXT           ,NIL})
	
		oAux := oDet[nX]
		If Type("oAux:_Prod:_vDesc") <> "U"
            aadd(aLinha,{"D1_VALDESC",Val(oDet[nX]:_Prod:_vDesc:TEXT),Nil,Nil})
        Else 
            aadd(aLinha,{"D1_VALDESC",0,Nil,Nil})            
        Endif
		Do Case
			Case Type("oAux:_Imposto:_ICMS:_ICMS00") <> "U"
				oICM:=oAux:_Imposto:_ICMS:_ICMS00
			Case Type("oAux:_Imposto:_ICMS:_ICMS10") <> "U"
				oICM:=oAux:_Imposto:_ICMS:_ICMS10
			Case Type("oAux:_Imposto:_ICMS:_ICMS20") <> "U"
				oICM:=oAux:_Imposto:_ICMS:_ICMS20
			Case Type("oAux:_Imposto:_ICMS:_ICMS30") <> "U"
				oICM:=oAux:_Imposto:_ICMS:_ICMS30
			Case Type("oAux:_Imposto:_ICMS:_ICMS40") <> "U"
				oICM:=oAux:_Imposto:_ICMS:_ICMS40
			Case Type("oAux:_Imposto:_ICMS:_ICMS51") <> "U"
				oICM:=oAux:_Imposto:_ICMS:_ICMS51
			Case Type("oAux:_Imposto:_ICMS:_ICMS60") <> "U"
				oICM:=oAux:_Imposto:_ICMS:_ICMS60
			Case Type("oAux:_Imposto:_ICMS:_ICMS70") <> "U"
				oICM:=oAux:_Imposto:_ICMS:_ICMS70
			Case Type("oAux:_Imposto:_ICMS:_ICMS90") <> "U"
				oICM:=oAux:_Imposto:_ICMS:_ICMS90
		EndCase
		If (Type("oICM:_orig:TEXT") <> "U") .And. (Type("oICM:_CST:TEXT") <> "U")
			CST_Aux:=Alltrim(oICM:_orig:TEXT)+Alltrim(oICM:_CST:TEXT)
			aadd(aLinha,{"D1_CLASFIS",CST_Aux,Nil,Nil})
		ELSE
			aadd(aLinha,{"D1_CLASFIS",'',Nil,Nil})
		Endif
		
		aadd(aLinha,{"D1_DTVALID",dDataBase+2,Nil,Nil})
		aadd(aLinha,{"D1_LOCAL",SB1->B1_LOCPAD,Nil,Nil})
		aadd(aLinha,{"D1_GRUPO",SB1->B1_GRUPO,Nil,Nil})
		aadd(aLinha,{"D1_TP",SB1->B1_TIPO,Nil,Nil})
		
		If lMarcou
			dbSelectArea("TC9")
			dbGoTop()
			ProcRegua(Reccount())
			
			While !Eof() .And. lOk
				IncProc()
				If TC9->T9_OK  <> _cMarca
					dbSelectArea("TC9")
					TC9->(dbSkip(1));Loop
				Endif
				
				If TC9->T9_PRODUTO == SB1->B1_COD .And. TC9->T9_QTDE > 0
					aadd(aLinha,{"D1_PEDIDO",TC9->T9_PEDIDO,nil,Nil})
					aadd(aLinha,{"D1_ITEMPC",TC9->T9_ITEM,nil,Nil})
					If RecLock('TC9',.f.)
						If (TC9->T9_QTDE-nQuant) < 0
							TC9->T9_QTDE := 0
						Else
							TC9->T9_QTDE := (TC9->T9_QTDE - nQuant)
						Endif
						TC9->(MsUnlock())
					Endif
				Endif
				TC9->(dbSkip(1))
			Enddo
		Endif

		aadd(aItens,aLinha)
	Next nX
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//| Teste de Inclusao                                            |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Len(aItens) > 0 
	
		lMsErroAuto := .f.
		lMsHelpAuto := .f.
		
		SB1->( dbSetOrder(1) )
		SA2->( dbSetOrder(1) )
		
		nModulo := 2  //COMPRAS
		dbselectarea("SD1")
		dbsetorder(1)
		dbselectarea("SF1")
		dbsetorder(1)             
		
		MsgRun("Aguarde gerando Pré-Nota de Entrada...",,{|| MSExecAuto({|x,y,z| MATA140(x,y,z)},aCabec,aItens,3 )})
		
		IF lMsErroAuto
			MostraErro()

			MsgInfo("Gerando Pre-Nota em Outro Formato !!!")

			Begin Transaction
			If RecLock("SF1",.T.)
				SF1->F1_FILIAL		:= xFilial("SF1")
				SF1->F1_TIPO		:= cTipo
				SF1->F1_FORMUL		:= 'N'
				SF1->F1_DOC			:= Right("000000000"+Alltrim(OIdent:_nNF:TEXT),9)
				SF1->F1_SERIE		:= StrZero(Val(OIdent:_serie:TEXT),3)
				SF1->F1_EMISSAO		:= dData
				SF1->F1_FORNECE 	:= If(cTipo$'N/C',SA2->A2_COD,SA1->A1_COD)
				SF1->F1_LOJA		:= If(cTipo$'N/C',SA2->A2_LOJA,SA1->A1_LOJA)
				SF1->F1_ESPECIE		:= "SPED "
				SF1->F1_DTDIGIT		:= ddatabase
				SF1->F1_RECBMTO		:= ddatabase
                If SF1->(FieldPos("F1_NOMFOR")) > 0
                    If cTipo$'N/C'
                        SF1->F1_NOMFOR		:= SA2->A2_NOME
                    Else
                        SF1->F1_NOMFOR		:= SA1->A1_NOME
                    Endif
                Endif
				SF1->F1_CHVNFE		:= cChvNfe
				SF1->F1_EST			:= If(cTipo$'N/C',SA2->A2_EST,SA1->A1_EST)
				SF1->F1_HORA		:= SubStr(Time(),1,5)
				SF1->(MSUNLOCK())
			Endif
			
			_xOcItem3:= ''
	
			For nX := 1 To Len(oDet)
				aLinha := {}
				cProduto:=PADR(AllTrim(oDet[nX]:_Prod:_cProd:TEXT),TamSX3( "A5_CODPRF" )[1])
				xProduto:=cProduto
				
				oAux := oDet[nX]
				cNCM:=IIF(Type("oAux:_Prod:_NCM")=="U",space(12),oAux:_Prod:_NCM:TEXT)
				cCFOP:=IIF(Type("oAux:_Prod:_CFOP")=="U",space(04),oAux:_Prod:_CFOP:TEXT)
				Chkproc=.F.
					
				If cTipo$'N/C'
					If !SA5->(DbSetOrder(14), dbSeek(xFilial("SA5")+SA2->A2_COD+SA2->A2_LOJA+cProduto))
						Alert("Atenção, Produto x Fornecedor Não Localizado, Verifique !!!")
						Return .f.
					Endif
					SB1->(dbSetOrder(1) , dbSeek(xFilial("SB1")+SA5->A5_PRODUTO))  
				Else
					SA7->(dbSetOrder(3))
					
					If SA7->(dbSeek(xFilial("SA7")+SA1->A1_COD+SA1->A1_LOJA+cProduto))
						SB1->(dbSetOrder(1) , dbSeek(xFilial("SB1")+SA7->A7_PRODUTO))
					Else
						Alert("Produto Nao Encontrado No Cadastro de Cliente x Produto !")
						Return .f.
					Endif
				Endif

				If SB1->(Eof())
					Alert("Falha No Produto, Verifique !!!")
					Return .f.
				Endif
				Do Case
					Case Type("oAux:_Imposto:_ICMS:_ICMS00") <> "U"
						oICM:=oAux:_Imposto:_ICMS:_ICMS00
					Case Type("oAux:_Imposto:_ICMS:_ICMS10") <> "U"
						oICM:=oAux:_Imposto:_ICMS:_ICMS10
					Case Type("oAux:_Imposto:_ICMS:_ICMS20") <> "U"
						oICM:=oAux:_Imposto:_ICMS:_ICMS20
					Case Type("oAux:_Imposto:_ICMS:_ICMS30") <> "U"
						oICM:=oAux:_Imposto:_ICMS:_ICMS30
					Case Type("oAux:_Imposto:_ICMS:_ICMS40") <> "U"
						oICM:=oAux:_Imposto:_ICMS:_ICMS40
					Case Type("oAux:_Imposto:_ICMS:_ICMS51") <> "U"
						oICM:=oAux:_Imposto:_ICMS:_ICMS51
					Case Type("oAux:_Imposto:_ICMS:_ICMS60") <> "U"
						oICM:=oAux:_Imposto:_ICMS:_ICMS60
					Case Type("oAux:_Imposto:_ICMS:_ICMS70") <> "U"
						oICM:=oAux:_Imposto:_ICMS:_ICMS70
					Case Type("oAux:_Imposto:_ICMS:_ICMS90") <> "U"
						oICM:=oAux:_Imposto:_ICMS:_ICMS90
				EndCase
				If (Type("oICM:_orig:TEXT") <> "U") .And. (Type("oICM:_CST:TEXT") <> "U")
					CST_Aux:=Alltrim(oICM:_orig:TEXT)+Alltrim(oICM:_CST:TEXT)
				ELSE
					CST_Aux:=''
				Endif

				If RecLock("SD1",.T.)
					SD1->D1_FILIAL	:=	xFilial("SD1")
					SD1->D1_ITEM	:=	StrZero(nX,4)
					SD1->D1_COD		:=	SB1->B1_COD
					SD1->D1_UM		:=	SB1->B1_UM
					SD1->D1_CLASFIS :=	CST_Aux
					
					nQuant := 0
					nUnit  := 0
					If Val(oDet[nX]:_Prod:_qTrib:TEXT) != 0
						SD1->D1_QUANT	:=	Val(oDet[nX]:_Prod:_qTrib:TEXT)
						SD1->D1_VUNIT	:=	Round(Val(oDet[nX]:_Prod:_vProd:TEXT)/Val(oDet[nX]:_Prod:_qTrib:TEXT),6)
						
						nQuant := Val(oDet[nX]:_Prod:_qTrib:TEXT)
						nUnit  := Round(Val(oDet[nX]:_Prod:_vProd:TEXT)/Val(oDet[nX]:_Prod:_qTrib:TEXT),6)
					Else
						SD1->D1_QUANT	:=	Val(oDet[nX]:_Prod:_qCom:TEXT)
						SD1->D1_VUNIT	:=	Round(Val(oDet[nX]:_Prod:_vProd:TEXT)/Val(oDet[nX]:_Prod:_qCom:TEXT),6)

						nQuant := Val(oDet[nX]:_Prod:_qCom:TEXT)
						nUnit  := Round(Val(oDet[nX]:_Prod:_vProd:TEXT)/Val(oDet[nX]:_Prod:_qCom:TEXT),6)
					Endif
					_cfop:=oDet[nX]:_Prod:_CFOP:TEXT
					If Left(Alltrim(_cfop),1)="5"
						_cfop:=Stuff(_cfop,1,1,"1")
					Else
						_cfop:=Stuff(_cfop,1,1,"2")
					Endif
					SD1->D1_CF		:=  _cfop
					SD1->D1_TOTAL	:=	Val(oDet[nX]:_Prod:_vProd:TEXT)
					SD1->D1_FORNECE	:=	SF1->F1_FORNECE
					SD1->D1_LOJA	:=	SF1->F1_LOJA
					SD1->D1_TIPO	:=	SF1->F1_TIPO
					SD1->D1_DOC		:=	SF1->F1_DOC
					SD1->D1_SERIE	:=	SF1->F1_SERIE
					SD1->D1_EMISSAO	:=	SF1->F1_EMISSAO
					SD1->D1_DTDIGIT	:=	dDataBase
					SD1->D1_LOCAL   :=  Alltrim(SB1->B1_LOCPAD)
					SD1->D1_GRUPO   :=  Alltrim(SB1->B1_GRUPO)
					SD1->D1_TP      :=  Alltrim(SB1->B1_TIPO)

					If lMarcou
						
						dbSelectArea("TC9")
						dbGoTop()
						ProcRegua(Reccount())
						
						While !Eof() .And. lOk
							IncProc()
							If TC9->T9_OK  <> _cMarca
								dbSelectArea("TC9")
								TC9->(dbSkip(1));Loop
							Endif
							
							If TC9->T9_PRODUTO == SB1->B1_COD .And. TC9->T9_QTDE > 0
								SD1->D1_PEDIDO := TC9->T9_PEDIDO
								SD1->D1_ITEMPC := TC9->T9_ITEM
							
								If RecLock('TC9',.f.)
									If (TC9->T9_QTDE-nQuant) < 0
										TC9->T9_QTDE := 0
									Else
										TC9->T9_QTDE := (TC9->T9_QTDE - nQuant)
									Endif
									TC9->(MsUnlock())
								Endif
							Endif
							TC9->(dbSkip(1))
						Enddo
					Endif
					SD1->(MsUnlock())
				Endif
			Next nX
			End Transaction
			
			TC8->(dbCloseArea())
			TC9->(dbCloseArea())


			cAno  := StrZero(Year(dDataBase),4)
			cMes  := StrZero(Month(dDataBase),2)

			cDirDest := Upper("\SYSTEM\XMLNFE\PROCESSADOS\"+cAno+"\"+cMes+"\")

			//Caso nao exista, cria o diretorio no servidor
			MontaDir(cDirDest)

			xFile := STRTRAN(Upper(cArquivo),"\SYSTEM\XMLNFE\", cDirDest)

			lRet := __CopyFile(cArquivo, xFile,,,.F.)
			If lRet
				lDelOk := .F.
				While !lDelOk
					fErase(cArquivo)
					lDelOk := !File(cArquivo)
					If !lDelOk
						Alert("O XML está aberto, feche o mesmo para que ele seja movido de pasta!")
					EndIf
				End
			EndIf

			MsgInfo(Alltrim(aCabec[4,2])+' / '+Alltrim(aCabec[5,2])+" - Pré Nota Gerada Com Sucesso! - NA FILIAL - " + SM0->M0_CODFIL + ' - ' + SM0->M0_NOMECOM+" - Arquivo Copiado Para "+xFile)

			cAssunto := 'Geração da pre nota '+Alltrim(aCabec[4,2])+' Serie '+Alltrim(aCabec[5,2])
			cTexto   := 'A pre nota '+Alltrim(aCabec[4,2])+' Serie: '+Alltrim(aCabec[5,2]) +' do tipo '+Alltrim(aCabec[2,2]) + ' do fornecedor '+ Alltrim(aCabec[7,2])+' loja ' + Alltrim(aCabec[8,2]) + ' foi gerada com sucesso. Por gentileza Classifique a Pré-Nota na rotina DOC.ENTRADA.'
			cAuxMail := alltrim(UsrRetMail(RetCodUsr()))
			cPara    := UsrRetMail(__cUserId)
			cCC      := ''
			cArquivo := xFile

			U_EnvMail(cAssunto,cTexto,cPara,cCC,cArquivo) //para que seja enviado um arquivo em anexo o arquivo deve estar dentro da pasta protheus_data
		Else
			If SF1->F1_DOC == Right("000000000"+Alltrim(OIdent:_nNF:TEXT),9)
				ConfirmSX8()
				
				If RecLock("SF1",.F.)
					If cTipo$'N/C'
						SF1->F1_NOMFOR		:= SA2->A2_NOME
					Else
						SF1->F1_NOMFOR		:= SA1->A1_NOME
					Endif
					SF1->(MsUnlock())
				Endif
		
				cAno  := StrZero(Year(dDataBase),4)
				cMes  := StrZero(Month(dDataBase),2)

				cDirDest := Upper("\SYSTEM\XMLNFE\PROCESSADOS\"+cAno+"\"+cMes+"\")

				//Caso nao exista, cria o diretorio no servidor
				MontaDir(cDirDest)

				xFile := STRTRAN(Upper(cArquivo),"\SYSTEM\XMLNFE\", cDirDest)

				lRet := __CopyFile(cArquivo, xFile,,,.F.)
				If lRet
					lDelOk := .F.
					While !lDelOk
						fErase(cArquivo)
						lDelOk := !File(cArquivo)
						If !lDelOk
							Alert("O XML está aberto, feche o mesmo para que ele seja movido de pasta!")
						EndIf
					End
				EndIf
				
				MsgInfo(Alltrim(aCabec[4,2])+' / '+Alltrim(aCabec[5,2])+" - Pré Nota Gerada Com Sucesso! - NA FILIAL - " + SM0->M0_CODFIL + ' - ' + SM0->M0_NOMECOM+" - Arquivo Copiado Para "+xFile)

				cAssunto := 'Geração da pre nota '+Alltrim(aCabec[4,2])+' Serie '+Alltrim(aCabec[5,2])
				cTexto   := 'A pre nota '+Alltrim(aCabec[4,2])+' Serie: '+Alltrim(aCabec[5,2]) +' do tipo '+Alltrim(aCabec[2,2]) + ' do fornecedor '+ Alltrim(aCabec[7,2])+' loja ' + Alltrim(aCabec[8,2]) + ' foi gerada com sucesso. Por gentileza Classifique a Pré-Nota na rotina DOC.ENTRADA.'
				cAuxMail := alltrim(UsrRetMail(RetCodUsr()))
				cPara    := UsrRetMail(__cUserId)+';lalberto@3lsystems.com.br' //GetNewPar("ES_EMAXML",'fabricio.lima@cellep.com')
				cCC      := ''
				cArquivo := xFile

				U_EnvMail(cAssunto,cTexto,cPara,cCC,cArquivo) //para que seja enviado um arquivo em anexo o arquivo deve estar dentro da pasta protheus_data
			Else
				MSGALERT(Alltrim(aCabec[4,2])+' / '+Alltrim(aCabec[5,2])+" - Pré Nota Não Gerada - Tente Novamente !")
			EndIf
		EndIf
	Endif

PutMV("MV_PCNFE",lPcNfe)
Return




Static Function C(nTam)
Local nHRes	:=	oMainWnd:nClientWidth	// Resolucao horizontal do monitor
If nHRes == 640	// Resolucao 640x480 (soh o Ocean e o Classic aceitam 640)
	nTam *= 0.8
ElseIf (nHRes == 798).Or.(nHRes == 800)	// Resolucao 800x600
	nTam *= 1
Else	// Resolucao 1024x768 e acima
	nTam *= 1.28
EndIf

//³Tratamento para tema "Flat"³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If "MP8" $ oApp:cVersion
	If (Alltrim(GetTheme()) == "FLAT") .Or. SetMdiChild()
		nTam *= 0.90
	EndIf
EndIf
Return Int(nTam)

Static Function ValProd(cTipo)
If cTipo$'N/C'	// Notal Entrada Fornecedor
	If !SB1->(dbSetOrder(1), dbSeek(xFilial("SB1")+cEdit1))
		MsgStop("Produto Não Localizado !")
		Return .f.
	Else 
		If SA5->(dbSetOrder(14), dbSeek(xFilial("SA5")+SA2->A2_COD+SA2->A2_LOJA+cEdit1))
			MsgStop("Atenção Este Produto Já Foi Referenciado Para Este Fornecedor, Referência do Fornecedor " + SA5->A5_CODPRF)
			Return .f.
		Endif
		_DESCdigit=AllTrim(SB1->B1_DESC)
		_NCMdigit=SB1->B1_POSIPI
	Endif    
Else	// Devolucao ou Beneficiamento
	If !SB1->(dbSetOrder(1), dbSeek(xFilial("SB1")+cEdit1))
		MsgStop("Produto Não Localizado !")
		Return .f.
	Else 
		If SA7->(dbSetOrder(1), dbSeek(xFilial("SA7")+SA1->A1_COD+SA1->A1_LOJA+cEdit1))
			MsgStop("Atenção Este Produto Já Foi Referenciado Para Este Cliente, Referência do Cliente " + SA7->A7_CODCLI)
			Return .f.
		Endif
		_DESCdigit=AllTrim(SB1->B1_DESC)
		_NCMdigit=SB1->B1_POSIPI
	Endif    
Endif
Return(ExistCpo("SB1"))

Static Function Troca()  
Local lBloqueado,nIpi
Chkproc=.T.
cProduto=cEdit1
_oDlg:End()
Return(.t.)



******************************************
Static Function MarcarTudo()
DbSelectArea('TC9')
dbGoTop()
While !Eof()
	MsProcTxt('Aguarde...')
	RecLock('TC9',.F.)
	TC9->T9_OK := _cMarca
	MsUnlock()
	DbSkip()
EndDo
DbGoTop()
DlgRefresh(oDlgPedidos)
SysRefresh()
Return(.T.)

******************************************
Static Function DesmarcaTudo()
DbSelectArea('TC9')
dbGoTop()
While !Eof()
	MsProcTxt('Aguarde...')
	RecLock('TC9',.F.)
	TC9->T9_OK := ThisMark()
	MsUnlock()
	DbSkip()
EndDo
DbGoTop()
DlgRefresh(oDlgPedidos)
SysRefresh()
Return(.T.)


******************************************
Static Function Marcar()
DbSelectArea('TC9')
RecLock('TC9',.F.)
If Empty(TC9->T9_OK)
	TC9->T9_OK := _cMarca
Endif
MsUnlock()
SysRefresh()
Return(.T.)

******************************************************
Static FUNCTION Cria_TC9()

If Select("TC9") <> 0
	TC9->(dbCloseArea())
Endif
If Select("TC8") <> 0
	TC8->(dbCloseArea())
Endif


aFields   := {}
AADD(aFields,{"T9_OK"     ,"C",02,0})
AADD(aFields,{"T9_PEDIDO" ,"C",06,0})
AADD(aFields,{"T9_ITEM"   ,"C",04,0})
AADD(aFields,{"T9_PRODUTO","C",15,0})
AADD(aFields,{"T9_DESC"   ,"C",40,0})
AADD(aFields,{"T9_UM"     ,"C",02,0})
AADD(aFields,{"T9_QTDE"   ,"N",6,0})
AADD(aFields,{"T9_UNIT"   ,"N",12,2})
AADD(aFields,{"T9_TOTAL"  ,"N",14,2})
AADD(aFields,{"T9_DTPRV"  ,"D",08,0})
AADD(aFields,{"T9_ALMOX"  ,"C",02,0})
AADD(aFields,{"T9_OBSERV" ,"C",30,0})
AADD(aFields,{"T9_CCUSTO" ,"C",06,0})
AADD(aFields,{"T9_TES" ,"C",3,0})
AADD(aFields,{"T9_REG" ,"N",10,0})
cArq:=Criatrab(aFields,.T.)
DBUSEAREA(.t.,,cArq,"TC9")

aFields2   := {}
AADD(aFields2,{"T8_NOTA" ,"C",09,0})
AADD(aFields2,{"T8_SERIE"   ,"C",03,0})
AADD(aFields2,{"T8_PRODUTO","C",15,0})
AADD(aFields2,{"T8_DESC"   ,"C",40,0})
AADD(aFields2,{"T8_UM"     ,"C",02,0})
AADD(aFields2,{"T8_QTDE"   ,"N",6,0})
AADD(aFields2,{"T8_UNIT"   ,"N",12,2})
AADD(aFields2,{"T8_TOTAL"  ,"N",14,2})
cArq2:=Criatrab(aFields2,.T.)
DBUSEAREA(.t.,,cArq2,"TC8")
Return


********************************************
Static Function Monta_TC9()
Local _nX
// Irá efetuar a checagem de pedidos de compras
// em aberto para este fornecedor e os itens desta nota fiscal a ser importa
// será demonstrado ao usuário se o pedido de compra deverá ser associado
// a entrada desta nota fiscal

cQuery := ""
cQuery += " SELECT  C7_NUM T9_PEDIDO,     "
cQuery += " 		C7_ITEM T9_ITEM,    "
cQuery += " 	    C7_PRODUTO T9_PRODUTO, "
cQuery += " 		B1_DESC T9_DESC,    "
cQuery += " 		B1_UM T9_UM,		"
cQuery += " 		C7_QUANT T9_QTDE,   "
cQuery += " 		C7_PRECO T9_UNIT,   "
cQuery += " 		C7_TOTAL T9_TOTAL,   "
cQuery += " 		C7_DATPRF T9_DTPRV,  "
cQuery += " 		C7_LOCAL T9_ALMOX, "
cQuery += " 		C7_OBS T9_OBSERV, "
cQuery += " 		C7_CC T9_CCUSTO, "
cQuery += " 		C7_TES T9_TES, "
cQuery += " 		SC7.R_E_C_N_O_ T9_REG "
cQuery += " FROM " + RetSqlName("SC7") + " SC7 WITH (NOLOCK) " + ;
"LEFT OUTER JOIN "+RetSqlName("SB1") + " SB1 WITH (NOLOCK) ON (SB1.D_E_L_E_T_ <> '*') AND (SB1.B1_FILIAL = '"+xFilial("SB1")+"') AND (C7_PRODUTO = B1_COD) "
cQuery += " WHERE (C7_FILENT = '" + xFilial("SC7") + "') "
cQuery += " AND (SC7.D_E_L_E_T_ <> '*') "
cQuery += " AND (C7_QUANT > C7_QUJE)  "
cQuery += " AND C7_QTDACLA < (C7_QUANT - C7_QUJE)  "
cQuery += " AND (C7_RESIDUO = '')  "
cQuery += " AND (C7_CONAPRO <> 'B')  "
cQuery += " AND (C7_ENCER = '') "
cQuery += " AND (C7_FORNECE = '" + SA2->A2_COD + "') "
cQuery += " AND (C7_LOJA = '" + SA2->A2_LOJA + "') "
cQuery += " AND C7_PRODUTO IN" + FormatIn( cProds, "/")
If MV_PAR01 <> 1
	cQuery += " AND 1 > 1 "
Endif
cQuery += " ORDER BY C7_NUM, C7_ITEM, C7_PRODUTO "
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"CAD",.T.,.T.)
TcSetField("CAD","T9_DTPRV","D",8,0)

Dbselectarea("CAD")

While CAD->(!EOF())
	RecLock("TC9",.T.)
	For _nX := 1 To Len(aFields)
		If !(aFields[_nX,1] $ 'T9_OK')
			If aFields[_nX,2] = 'C'
				_cX := 'TC9->'+aFields[_nX,1]+' := Alltrim(CAD->'+aFields[_nX,1]+')'
			Else
				_cX := 'TC9->'+aFields[_nX,1]+' := CAD->'+aFields[_nX,1]
			Endif
			_cX := &_cX
		Endif
	Next
	TC9->T9_OK := _cMarca //ThisMark()
	MsUnLock()
	
	DbSelectArea('CAD')
	CAD->(dBSkip())
EndDo

Dbselectarea("CAD")
DbCloseArea()
Dbselectarea("TC9")
DbGoTop()

_cIndex:=Criatrab(Nil,.F.)
_cChave:="T9_PEDIDO"
Indregua("TC9",_cIndex,_cChave,,,"Ordenando registros selecionados...")
DbSetIndex(_cIndex+ordbagext())
SysRefresh()
Return


StatiC Function Fecha()
Close(_oPT00005)     
lOut := .t.
Return

// Funcao de ENvio de Email de Aviso de PRe Nota


// Funcao de ENvio de Email de Aviso de PRe Nota

User Function EnvMail(_cSubject, _cBody, _cMailTo, _cCC, _cAnexo, _cConta, _cSenha)
Local _cMailS		:= GetMv("MV_RELSERV")
Local _cAccount		:= GetMV("MV_RELACNT")
Local _cPass		:= GetMV("MV_RELFROM")
Local _cSenha2		:= GetMV("MV_RELPSW")
Local _cUsuario2	:= GetMV("MV_RELACNT")
Local lAuth			:= GetMv("MV_RELAUTH",,.F.)

Connect Smtp Server _cMailS Account _cAccount Password _cPass RESULT lResult

If lAuth		// Autenticacao da conta de e-mail
	lResult := MailAuth(_cUsuario2, _cSenha2)
	If !lResult
		Alert("Não foi possivel autenticar a conta - " + _cUsuario2)	//É melhor a mensagem aparecer para o usuário do que no console ou no log.txt - Poliester
		Return()
	EndIf
EndIf

lResult := .T.


	If !Empty(_cAnexo)
		Send Mail From _cAccount To _cMailTo CC _cCC Subject _cSubject Body _cBody ATTACHMENT _cAnexo RESULT lResult
	Else
		Send Mail From _cAccount To _cMailTo CC _cCC Subject _cSubject Body _cBody RESULT lResult
	Endif
	
	if !lResult
		Get Mail Error cErrorMsg
		Alert("Erro Envio Email: " + cErrorMsg)
	EndIf             
Return


Static function LerEmail()
	local cAttach := ""
	local oServer  := TMailManager():New()
	local oMessage := Nil
	local cKey   :=  ""//SuperGetMv("FS_AMKEY ", NIL, "@G3615704")
	local cSmtp  := ""//SuperGetMv("FS_ASMTP ", NIL,  "smtp.gmail.com")
	local cPop    := ""//SuperGetMv("FS_APOP ", NIL, "pop.gmail.com")
	local cEmail  :="" //superGetMv("FS_AMAIL ", NIL, "integracao.ariba@gmail.com",)
	local cUser  := "" // SuperGetMv("FS_AUSER ", NIL, "integracao.ariba")
	local uSaveXmL  := ""//SuperGetMv("FS_ASVXML ", NIL, "E:\TOTVS\Pedidos_ariba")
//	local nPort  := 587
	local nMessages := 0
	local x := y := 0
//	local nPortPop := 0
	local nRet   := 0
	local nAttach := 0
	local lRun   := .T.
	local aInfo := {}
	local lRet  := .f.
	Local ni

	Conout("Efetuando a Leitura dos Emails - " + Time() + " - " + DtoC(Date()) + " - Empresa: " + cEmpAnt + " Filial: " + cFilAnt + " Aguarde...")

	cKey   :=  SuperGetMv("FS_AMKEY ", NIL		, "mig@definitivo@")
	cSmtp  := SuperGetMv("FS_ASMTP ", NIL		, "email-ssl.com.br")
	cPop    := SuperGetMv("FS_APOP ", NIL		, "email-ssl.com.br")
	cEmail  := superGetMv("FS_AMAIL ", NIL		, "faturamento@luguez.com.br",)
	cUser  := SuperGetMv("FS_AUSER ", NIL		, "faturamento@luguez.com.br")
	uSaveXmL  := SuperGetMv("FS_ASVXML ", NIL	, GetNewPar("MV_XMLPATH","\SYSTEM\XMLNFE\"))
	oServer:Setusetls(.F.)
	oServer:SetuseSSL(.F.)

	nPortaPop := 110
	nPortaSmt := 587

	BEGIN SEQUENCE
		nRet := oServer:Init(cPop ,cSmtp, cEmail , cKey, nPortaPop,nPortaSmt )
		IF(  nRet #  0 )
			Conout( "Error Ao Inicia O Server " )
			BREAK
		EndIF

		nRet := oServer:PopConnect()

		IF(  nRet #  0 )
			Conout( "Error Ao Conectar com o Pop " )
			BREAK
		EndIF

		IF(  oServer:SetSmtpTimeOut(60)  #  0 )
			Conout( "Falha ao setar o time out" )
			BREAK
		EndIf

		IF(  oServer:SmtpConnect() # 0 )
			conout( "Falha ao conectar" )
			BREAK
		EndIf

		If(oServer:SMTPAuth(cUser ,cKey)  # 0  )
			Conout( "Falha ao autenticar" )
			oServer:SMTPDisconnect()
			oServer:POPDisconnect()
			BREAK
		EndIf

		oServer:GetNumMsgs( @nMessages )
		oMessage := TMailMessage():New()
		oMessage:Clear()
		conout( "Receiving newest message" )

		nRet := oMessage:Receive( oServer, nMessages )

		if(  nRet #  0 )
			conout( "Could not get message " + cValToChar( nMessages ) + ": " + oServer:GetErrorString( nRet ) )
			BREAK
		endif

		y := nMessages // oMessage:GetAttachCount()
		ProcRegua(y)
		for x := 1 to y
			IncProc("Efetuando Leitura Email " + AllTrim(Str(x)) + ' de ' + AllTrim(Str(y)))

			cAttach := ""
			oMessage:Clear()
			oMessage:Receive( oServer, x )
			
			nAttach := oMessage:GetAttachCount()
		  	for nI := 1 to nAttach
			    aInfo := oMessage:GetAttachInfo( nI )

				IF (alltrim( aInfo[2]) $ "text/xml" .Or. alltrim( aInfo[2]) $ "application/xml" )
					cAttach := oMessage:GetAttach( nI )
					cNomArq := aInfo[1] 
					If Empty(cNomArq)   
						cNomArq := aInfo[4] 
					Endif					
					If !File(uSaveXmL+cNomArq)
						lRet := oMessage:SaveAttach( nI, uSaveXmL+cNomArq  )
						IF  lRet == .f.
							cAttach := oMessage:GetAttach( nI )
							MemoWrite( uSaveXmL+cNomArq , cAttach )
						EndIF
						Conout(uSaveXmL+cNomArq + " Salvo Com Sucesso !")
					Else
						Conout(uSaveXmL+cNomArq + " Ja Existe Na Pasta !")
					Endif
				EndIF
            Next nI
		   	oServer:DeleteMsg( x )
		next x

	END SEQUENCE

	oServer:POPDisconnect()
	oServer:SMTPDisconnect()

Return ( Nil )



Static Function LerDir(aArqXmls)
Local cDiretorio := GetNewPar("MV_XMLPATH","\SYSTEM\XMLNFE\")
Local nXml
Private cAviso := ''
Private cErro := ''

aArqXmls := {}

aXmls := Directory( cDiretorio + "*.XML") 

If Empty(Len(aXmls))
				AAdd(aArqXmls,{'',;
								'',;
								'',;
								'',;
								'',;
								'',;
								'',;
								'',;
								'',;
								'',;
								'',;
								'',;
								'',;
								''})

Endif
ProcRegua(Len(aXmls))

For nXml := 1 To Len(aXmls)
	IncProc("Aguarde, Lendo Arquivo " + cValToChar(nXml) + " de " + cValToChar(Len(aXmls)))
	
	cFile := AllTrim(aXmls[nXml][1])  //nome arquivo

	oXML  := XmlParserFile( cDiretorio+cFile ,"_" , @cAviso,@cErro )

	If !Empty(cAviso) .Or. !Empty(cErro)
		FErase(cDiretorio+cFile)
		DelClassIntf() // Libera memoria
		Loop
	Endif

	cTagTax := varinfo("Array",oXML)
	If !"_NFEPROC"$cTagTax //XmlChildEx(oXmlAriba:_CXML:_REQUEST:_ORDERREQUEST:_ITEMOUT:_TAX, "_TAXDETAIL[1]") <> Nil
		FErase(cDiretorio+cFile)
		DelClassIntf() // Libera memoria
		Loop
	Endif


	// Se o CNPJ Emitente for Igual CNPJ Destinatario Nao Importa Arquivo e Exclui na pasta Pendentes

	cCnpjEmit	:=	''
	cCnpjDest	:=	''

	// CNPJ Emitente
	
	If XmlChildEx(oXML:_NFEPROC:_NFE:_INFNFE:_EMIT, "_CNPJ") <> Nil
		cCnpjEmit	:=	AllTrim(oXML:_NFEPROC:_NFE:_INFNFE:_EMIT:_CNPJ:TEXT)
	Endif
	                
	// CNPJ Destinatario
	
	If XmlChildEx(oXML:_NFEPROC:_NFE:_INFNFE:_DEST, "_CNPJ") <> Nil
		cCnpjDest	:=	AllTrim(oXML:_NFEPROC:_NFE:_INFNFE:_DEST:_CNPJ:TEXT)
	Endif
	
	// Apaga o XML de Arquivos Com CNPJ Emitente e Destinatario Iguais e Pula Para o Proximo Arquivo
	
	If !Empty(cCnpjEmit) .And. !Empty(cCnpjDest)
		If cCnpjEmit == cCnpjDest
			FErase(cDiretorio+cFile)
			DelClassIntf() // Libera memoria
			Loop
		Endif
	Endif

	If Empty(cAviso) .AND. Empty(cErro)
		
		Do Case
			Case Type('oXML:_NFEPROC') <> "U" .And. Type('oXML:_NFEPROC:_PROTNFE') <> "U"
				cTipo    := "NFE"
				cChNFE   := &('oXML:_NFEPROC:_PROTNFE:_INFPROT:_CHNFE:TEXT'         )
				cVersao  := &('oXML:_NFEPROC:_NFE:_INFNFE:_VERSAO:TEXT'             )
				cCnpjE   := &('oXML:_NFEPROC:_NFE:_INFNFE:_EMIT:_CNPJ:TEXT'         )
				cNomeE   := &('oXML:_NFEPROC:_NFE:_INFNFE:_EMIT:_XNOME:TEXT'        )

				// Pessoa Fisica Pula
				
				If Type('oXML:_NFEPROC:_NFE:_INFNFE:_DEST:_CNPJ:TEXT') <> 'U'
					cCnpjD   := &('oXML:_NFEPROC:_NFE:_INFNFE:_DEST:_CNPJ:TEXT'         )
				Else
					cCnpjD:='RECUSADO'
				Endif
				cNomeD   := &('oXML:_NFEPROC:_NFE:_INFNFE:_DEST:_XNOME:TEXT'        )
				cNF      := &('oXML:_NFEPROC:_NFE:_INFNFE:_IDE:_NNF:TEXT'           )
				cSerie   := &('oXML:_NFEPROC:_NFE:_INFNFE:_IDE:_SERIE:TEXT'         )
				cTotal   := &('oXML:_NFEPROC:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VNF:TEXT')
				cTipoDoc := fVTipoDoc(oXML,cTipo)
				If Type('oXML:_NFEPROC:_NFE:_INFNFE:_IDE:_DEMI:TEXT') <> "U"
					cData    := &('oXML:_NFEPROC:_NFE:_INFNFE:_IDE:_DEMI:TEXT'       )
				Else
					cData    := &('oXML:_NFEPROC:_NFE:_INFNFE:_IDE:_DHEMI:TEXT'      )
				EndIf
				cProtoc  := ""
				cTexto   := ""

				cUF      := oXML:_NFEPROC:_NFE:_INFNFE:_EMIT:_ENDEREMIT:_UF:TEXT
				cCid     := oXML:_NFEPROC:_NFE:_INFNFE:_EMIT:_ENDEREMIT:_XMUN:TEXT
				If Type('oXML:_NFEPROC:_PROTNFE:_INFPROT:_DHRECBTO:TEXT') <> "U"
					cHora    := oXML:_NFEPROC:_PROTNFE:_INFPROT:_DHRECBTO:TEXT
					cHora    := SubStr(cHora,12)
				Else
					cHora    := oXML:_NFEPROC:_NFE:_INFNFE:_IDE:_DHEMI:TEXT
					cHora    := SubStr(cHora,12)
				EndIf

				
			Case Type('oXML:_CTEPROC') <> "U"
				cTipo    := "CTE"
				cChNFE   := &('oXML:_CTEPROC:_PROTCTE:_INFPROT:_CHCTE:TEXT'         )
				cVersao  := &('oXML:_CTEPROC:_CTE:_INFCTE:_VERSAO:TEXT'             )
				cCnpjE   := &('oXML:_CTEPROC:_CTE:_INFCTE:_EMIT:_CNPJ:TEXT'         )
				cNomeE   := &('oXML:_CTEPROC:_CTE:_INFCTE:_EMIT:_XNOME:TEXT'        )
				cCnpjD   := &('oXML:_CTEPROC:_CTE:_INFCTE:_DEST:_CNPJ:TEXT'         )
				cNomeD   := &('oXML:_CTEPROC:_CTE:_INFCTE:_DEST:_XNOME:TEXT'        )
				cNF      := &('oXML:_CTEPROC:_CTE:_INFCTE:_IDE:_NCT:TEXT'           )
				cSerie   := &('oXML:_CTEPROC:_CTE:_INFCTE:_IDE:_SERIE:TEXT'         )
				cTotal   := &('oXML:_CTEPROC:_CTE:_INFCTE:_VPREST:_VTPREST:TEXT'    )
				cTipoDoc := fVTipoDoc(oXML,cTipo)
				cData    := &('oXML:_CTEPROC:_CTE:_INFCTE:_IDE:_DHEMI:TEXT'         )
				cProtoc  := ""
				cTexto   := ""

				cUF      := oXML:_CTEPROC:_CTE:_INFCTE:_EMIT:_ENDEREMIT:_UF:TEXT
				cCid     := oXML:_CTEPROC:_CTE:_INFCTE:_EMIT:_ENDEREMIT:_XMUN:TEXT
				cHora    := oXML:_CTEPROC:_PROTCTE:_INFPROT:_DHRECBTO:TEXT
				cHora    := SubStr(cHora,12)            ¡

				
			Case Type('oXML:_PROCCANCNFE') <> "U"
				cTipo := "CAN"
				cChNFE   := &('oXML:_PROCCANCNFE:_CANCNFE:_INFCANC:_CHNFE:TEXT'     )
				cVersao  := &('oXML:_PROCCANCNFE:_CANCNFE:_VERSAO:TEXT'             )
				cCnpjE   := SubStr(cChNFE,07,14)
				cNomeE   := ""
				cCnpjD   := ""
				cNomeD   := ""
				cNF      := ""
				cSerie   := ""
				cTotal   := ""
				cTipoDoc := ""
				cData    := &('oXML:_PROCCANCNFE:_RETCANCNFE:_INFCANC:_DHRECBTO:TEXT')
				cProtoc  := &('oXML:_PROCCANCNFE:_CANCNFE:_INFCANC:_NPROT:TEXT'      )
				cTexto   := &('oXML:_PROCCANCNFE:_RETCANCNFE:_INFCANC:_XMOTIVO:TEXT' )
				cTexto   += "-"
				cTexto   += &('oXML:_PROCCANCNFE:_CANCNFE:_INFCANC:_XJUST:TEXT'      )
				cUF      := ""
				cCid     := ""
				cHora    := ""

			Case Type('oXML:_PROCEVENTONFE') <> "U"
				cTipo    := "CCE"

				oEvento  := Nil  
				oRetEven := Nil

				If Type('oXML:_PROCEVENTONFE:_EVENTO:_ENVEVENTO:_EVENTO') != "U"
					oEvento  := oXML:_PROCEVENTONFE:_EVENTO:_ENVEVENTO:_EVENTO
					oRetEven := oXML:_PROCEVENTONFE:_RETEVENTO:_RETENVEVENTO:_RETEVENTO
				Else
					oEvento  := oXML:_PROCEVENTONFE:_EVENTO
					oRetEven := oXML:_PROCEVENTONFE:_RETEVENTO
				EndIf

				cChNFE   := oEvento:_INFEVENTO:_CHNFE:TEXT
				cVersao  := oXML:_PROCEVENTONFE:_VERSAO:TEXT
				cCnpjE   := SubStr(cChNFE,07,14)
				cNomeE   := ""
				cCnpjD   := ""
				cNomeD   := ""
				cNF      := ""
				cSerie   := ""
				cTotal   := ""
				cTipoDoc := ""
				cData    := oEvento:_INFEVENTO:_DHEVENTO:TEXT
				cProtoc  := oRetEven:_INFEVENTO:_NPROT:TEXT
				
				If Type('oEvento:_INFEVENTO:_DETEVENTO:_XJUST') <> "U"
					cTexto   := &('oEvento:_INFEVENTO:_DETEVENTO:_DESCEVENTO:TEXT')
					If "CANCELAMENTO" $ Upper(cTexto)
						cTipo := "CAN"
					EndIf
					cTexto   += "-"
					cTexto   += &('oEvento:_INFEVENTO:_DETEVENTO:_XJUST:TEXT')
				Else
					cTexto   := &('oEvento:_INFEVENTO:_DETEVENTO:_XCORRECAO:TEXT')
				EndIf
				cUF      := ""
				cCid     := ""
				cHora    := ""

			Otherwise
				cTipo := "XXX"

		EndCase
	
		If !AllTrim(SM0->M0_CGC)$AllTrim(cCnpjD)
			DelClassIntf() // Libera memoria
			Loop
		Endif

		cData  := StrTran(Substr(cData,1,10),"-","")
		cMes   := Substr(cData,5,2)
		cAno   := Substr(cData,1,4)

		//Grava registro na tabela principal apenas se for NF ou CT
		//Demais XML deve ser localizado a chave principal e gravar em mensagens do XML principal (Cancelamento, Carta de Correção e duplicidades de XML)
		Do Case

			//Grava em Mensagens - Extrutura do XML não identificado
			Case cTipo == "XXX"
				FErase(cDiretorio+cFile)
				DelClassIntf() // Libera memoria
				Loop

			//Grava em Mensagens - Carta de Correção ou Cancelamento
			Case cTipo $ "/CCE/CAN/"
				FErase(cDiretorio+cFile)
				DelClassIntf() // Libera memoria
				Loop

			//Grava Chave Principal
			Case cTipo $ "/NFE/CTE/"

				If cTipoDoc $ 'N/C'
					If !SA2->(dbSetOrder(3), dbSeek(xFilial("SA2")+cCnpjE))
						Loop
					Endif
					cCodCliFor := SA2->A2_COD
					cLojCliFor := SA2->A2_LOJA
					cNomCliFor := SA2->A2_NOME
					cCndCliFor := SA2->A2_COND
				ElseIf cTipoDoc$'D/B'
					If !SA1->(dbSetOrder(3), dbSeek(xFilial("SA1")+cCnpjE))
						Loop
					Endif
					cCodCliFor := SA1->A1_COD
					cLojCliFor := SA1->A1_LOJA
					cNomCliFor := SA1->A1_NOME
					cCndCliFor := SA1->A1_COND
				Else
					FErase(cDiretorio+cFile)
					DelClassIntf() // Libera memoria
					Loop
				Endif

				//F1_FILIAL, F1_DOC, F1_SERIE, F1_FORNECE, F1_LOJA, F1_FORMUL, R_E_C_D_E_L_

				If SF1->(dbSetOrder(1), dbSeek(xFilial("SF1")+StrZero(Val(cNF   ),9)+StrZero(Val(cSerie),3)+cCodCliFor+cLojCliFor))
					FErase(cDiretorio+cFile)
					DelClassIntf() // Libera memoria
					Loop
				Endif

				AAdd(aArqXmls,{StrZero(Val(cNF   ),9),;
								StrZero(Val(cSerie),3),;
								cCnpjE,;
								cNomCliFor,;
								cTipoDoc,;
								TransForm(Val(cTotal),'@E 9,999,999,999.99'),;
								cTipo,;
								DtoC(StoD(cData)),;
								cHora,;
								cUf,;
								cChNFE,;
								cCnpjD,;
								cDiretorio+cFile,;
								cFile})
		EndCase
		cAviso := ""
		cErro  := ""
	EndIf
	DelClassIntf() // Libera memoria
Next 

oArqsImp:SetArray(aArqXmls)
oArqsImp:bLine := {|| {	aArqXmls[oArqsImp:nAt,XML_NOTAS],;
							aArqXmls[oArqsImp:nAt,XML_SERIE],;
							aArqXmls[oArqsImp:nAt,XML_CNPJE],;
							aArqXmls[oArqsImp:nAt,XML_NOMES],;
							aArqXmls[oArqsImp:nAt,XML_TIPOS],;
							aArqXmls[oArqsImp:nAt,XML_TOTAL],;
							aArqXmls[oArqsImp:nAt,XML_TPDOC],;
							aArqXmls[oArqsImp:nAt,XML_DATAS],;
							aArqXmls[oArqsImp:nAt,XML_HORAS],;
							aArqXmls[oArqsImp:nAt,XML_ESTAD],;
							aArqXmls[oArqsImp:nAt,XML_CHVNF],;
							aArqXmls[oArqsImp:nAt,XML_CNPJD],;
							aArqXmls[oArqsImp:nAt,XML_FILES]}}
oArqsImp:nAt := 1
oArqsImp:Refresh()

Return


//+-----------------------------------------------------------------------------------//
//|Funcao....: fVTipoDoc()
//|Autor.....: Felipe Aurélio de Melo - felipeamelo@gmail.com
//|Data......: janeiro/fevereiro/março de 2014, 09:00
//|Descricao.: Gerenciador dos XML's das NFe da Entrada
//|Observação: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------------------------*
Static Function fVTipoDoc(oXML,cTipoXML)
*-----------------------------------------------------------*
Local cRet    := ""
Local oDet    := Nil
Local oIde    := Nil
Local lDetOk  := .F.
Local lIdeOk  := .F.
Local cCFOP_B := AllTrim(SuperGetMV( "MV_FMNFBEN", , "" )) //Beneficiamento
Local cCFOP_D := AllTrim(SuperGetMV( "MV_FMNFDEV", , "" )) //Devolução
Local cCFOP_C := AllTrim(SuperGetMV( "MV_FMNFCOM", , "" )) //Complemento
Local cXXCF_B := "901/920"                                                    //Beneficiamento
Local cXXCF_D := "201/202"                                                    //Devolução
Local cCFOP_A := AllTrim(SuperGetMV( "MV_FMNFAUT", , "" )) //Nf Auto Entrada CLIFOR  
Local cRefNf  :=	''
Local nRecRef := 0
Local x
Local y

  
//finNFe Finalidade de emissão da NF-e
//1=Normal(N); 
//2=Complementar(C); 
//3=Ajuste(A); 
//4=Devolução(D)/Beneficiamento(B)

//tpCTe Finalidade de emissão da CT-e
//0=Normal(N)
//1=Complemento(C)
//2=Anulação(U)
//3=Substituição(S)

Private oNF  := oXML

Do Case
	Case cTipoXML == "CTE"
		lIdeOk := .F.

		If !lIdeOk .And. Type("oNF:_CTeProc:_CTe:_InfCTe:_IDE:_TpCTe") != "U"
			oIde := oNF:_CTeProc:_CTe:_InfCTe:_IDE:_TpCTe
			lIdeOk := .T.
		EndIf

		//Normal
		If Empty(cRet) .And. lIdeOk .And. AllTrim(oIde:Text) == "0"
			cRet := "N"
		EndIf		

		//Complementar
		If Empty(cRet) .And. lIdeOk .And. AllTrim(oIde:Text) == "1"
			cRet := "C"
		EndIf		

		//Anulação
		If Empty(cRet) .And. lIdeOk .And. AllTrim(oIde:Text) == "2"
			cRet := "U"
		EndIf		

		//Substituição
		If Empty(cRet) .And. lIdeOk .And. AllTrim(oIde:Text) == "3"
			cRet := "S"
		EndIf		

		If Empty(cRet)
			cRet := "X"
		EndIf
		
	Case cTipoXML == "NFE"
		lIdeOk := .F.
		lDetOk := .F.

		If !lIdeOk .And. Type("oNF:_NfeProc:_Nfe:_InfNfe:_IDE:_finNFe") != "U"
			oIde := oNF:_NfeProc:_Nfe:_InfNfe:_Ide:_finNFe
			lIdeOk := .T.
		EndIf

		If !lDetOk .And. Type("oNF:_NfeProc:_Nfe:_InfNfe:_Det") == "A"
			oDet := oNF:_NfeProc:_Nfe:_InfNfe:_Det
			lDetOk := .T.
		EndIf

		If !lDetOk .And. Type("oNF:_NfeProc:_Nfe:_InfNfe:_Det") == "O"
			oDet := {oNF:_NfeProc:_Nfe:_InfNfe:_Det}
			lDetOk := .T.
		EndIf

		//Verifica CFOP caso parametro preenchido
		If Empty(cRet) .And. lDetOk
			//Verifica o tipo da nota fiscal
			For x:=1 To Len(oDet)

				//Beneficiamento
				If Empty(cRet) .And. AllTrim(oDet[x]:_Prod:_CFOP:TEXT) $ cCFOP_B .And. !Empty(cCFOP_B) .And. AllTrim(oIde:Text) <> "2"
					cRet := "B"
					x := Len(oDet)
				EndIf
				
				//Devolução
				If Empty(cRet) .And. AllTrim(oDet[x]:_Prod:_CFOP:TEXT) $ cCFOP_D .And. !Empty(cCFOP_D)
					cRet := "D"
					x := Len(oDet)
				EndIf

				//Complemento
				If Empty(cRet) .And. AllTrim(oDet[x]:_Prod:_CFOP:TEXT) $ cCFOP_C .And. !Empty(cCFOP_C) .And. AllTrim(oIde:Text) == "2"
					cRet := "C"
					x := Len(oDet)
				EndIf

			Next x
		EndIf

		//Devolução / Beneficiamento
		If Empty(cRet) .And. lDetOk //.And. lIdeOk .And. AllTrim(oIde:Text) $ " 4" 

			//Verifica o tipo da nota fiscal
			For x:=1 To Len(oDet)
				//Beneficiamento
				If Empty(cRet) .And. SubStr(AllTrim(oDet[x]:_Prod:_CFOP:TEXT),2,3) $ cXXCF_B
					cRet := "B"
					x := Len(oDet)
				EndIf
				
				//Devolução
				If Empty(cRet) .And. SubStr(AllTrim(oDet[x]:_Prod:_CFOP:TEXT),2,3) $ cXXCF_D
					cRet := "D"
					x := Len(oDet)
				EndIf
			Next x

		EndIf		

		//Normal
		If Empty(cRet) .And. lIdeOk .And. AllTrim(oIde:Text) == "1"
			cRet := "N"
		EndIf		

		//Complementar
		If Empty(cRet) .And. lIdeOk .And. AllTrim(oIde:Text) == "2"
			cRet := "C"
		EndIf		

		//Ajuste
		If Empty(cRet) .And. lIdeOk .And. AllTrim(oIde:Text) == "3"
			cRet := "A"
		EndIf		

		//Normal
		If Empty(cRet) .And. lIdeOk .And. !Empty(oIde:Text)
			cRet := "N"
		EndIf		

		If Empty(cRet)
			cRet := "X"
		EndIf
		
	Otherwise
		
EndCase

Return(cRet)


Static Function VerXml(cArqOri,cArquivo)
Local cPathTmp := AllTrim(GetTempPath())

If File(cPathTmp+AllTrim(cArquivo))
	fErase(cPathTmp+AllTrim(cArquivo))
EndIf

CpyS2T(cArqOri,cPathTmp)

ShellExecute("open",cPathTmp+AllTrim(cArquivo),"","", 5 )

Return

Static Function ExcXml(cArquivo)

If !MsgYesNo ("Confirma a Exclusão do Arquivo XML -> "+cArquivo+" ?")
	Return .F.
Endif

lDelOk := .F.
While !lDelOk
	fErase(cArquivo)
	lDelOk := !File(cArquivo)
	If !lDelOk
		Alert("O XML está aberto, feche o mesmo para que ele seja Excluido!")
	EndIf
End

Return .T.



