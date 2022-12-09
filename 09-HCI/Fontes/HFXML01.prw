#INCLUDE "PROTHEUS.CH"
#INCLUDE "XMLXFUN.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณHFXML01   บAutor  ณMicrosiga           บ Data ณ  04/26/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Inicializador do Ambiente do Importa Xml.                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Importa Xml                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function HFXML01()

MsgRun("Carregando configura็oes...",,{|| CursorWait(),LoadEmp(),CursorArrow()})

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  |LoadEmp   บAutor  ณRoberto Souza       บ Data ณ  01/11/2011 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Verifica o carregamento de licen็as de uso.                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Importa Xml                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function LoadEmp()
Local lValidEmp := .F. 
Local lUso      := .F.
Local lEnv      := .F.
Private cFile := ""
  
cPerg := "IMPXML"

    dVencLic := Stod(Space(8))
 	lUsoOk := U_HFXML00X("HF000001","101",SM0->M0_CGC,@dVencLic)  
//lUsoOk := U_HFXML00X("HF000001","101",SM0->M0_CGC)

If !lUsoOk
	Return(.T.)
EndIf

lEnv := EnvOk() 
If lEnv		
	U_HFXML02("HF351058875875878XSSD7XVXVUETVEIIIQPQNZZ6574883AJJANI00983881FFDHSEJJSNW",.T.)
EndIf

Return(.T.)  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  | EnvOk    บAutor  ณRoberto Souza       บ Data ณ  03/05/2012 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Verifica o ambiente para uso.                              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Importa Xml                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function EnvOk()
Local lRet   := .T.
Local lTable := .F.
Local lIndex := .F.
Local cErro  := ""

If !AliasInDic("ZBZ") .Or. !AliasInDic("ZB5")  
	cErro += "As tabelas ZBZ e ZB5 nใo estใo devidamente criadas."+CRLF		
EndIf

If ZBZ->(FieldPos("ZBZ_XMLCAN")) <= 0 ;
	.Or. ZBZ->(FieldPos("ZBZ_PROTC")) <= 0 ; 
	.Or. ZBZ->(FieldPos("ZBZ_DTHCAN")) <= 0 ; 
	.Or. ZBZ->(FieldPos("ZBZ_MAIL")) <= 0  
	cErro += "Existem campos a serem criados."+CRLF
EndIf

If !Empty(cErro)
	cErro := "Existem imcompatibilidades no dicionแrio de dados."+CRLF+ cErro +CRLF+"Execute o compatibilizador 'U_UPDIF001' antes de continuar."    
    U_MyAviso("Aten็ใo", cErro, {"Ok"},3)
    lRet   := .F.
EndIf
Return(lRet)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณACOM001XMLบAutor  ณMicrosiga           บ Data ณ  04/28/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


STATIC FUNCTION ImportaXML(cFile)

Local aVetor	:= {}
Local aPedaco	:= {}
Local cError   := ""
Local cWarning := ""
Local oXml := NIL

// Variaveis para mata116 -- Conhecimento de Transporte
Local aLinha := {}
Local nX     := 0
Local nY     := 0
Local cDoc   := ""
Local lOk    := .T.

Private lMsErroAuto	:= .F.
Private lMsHelpAuto	:= .T.
Private aCabec := {}
Private aItens := {}
Private lNossoCod := .F.

lNossoCod := MSGYESNO("Utiliza Nosso Codigo ?",{'Sim','Nao'})

//Gera o Objeto XML
oXml := XmlParserFile( cFile, "_", @cError, @cWarning )

aXmlInfo := XmlToArr(oXml)

if alltrim(aXmlInfo [1][1]) <> '_NFEPROC'
	MsgSTOP("XML Invalido ou Nใo Encontrado, a Importa็ใo Nใo foi Efetuada !!!")
	Return
EndIf

If oXml == NIL
	MsgSTOP("XML Invalido ou Nใo Encontrado, a Importa็ใo Nใo foi Efetuada !!!")
	Return
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Consulta a NF-e.              ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
lValidNfe := .F.                             
nValidCons := MV_PAR02

If ExistBlock("XConsNfe") .And. nValidCons <> 3 
	MsgRun("Consultando a NF-e...",,{|| CursorWait(),U_XConsNfe(oXml,,@lValidNfe),CursorArrow()})
Else
	lValidNfe := .T.
EndIf



If !lValidNfe          
	MsgSTOP("XML Invalido ou Nใo Encontrado, a Importa็ใo Nใo foi Efetuada !!!")
	Return
EndIf

If MV_PAR01 == 1
	cCnpjEmi  := oXml:_NFEPROC:_NFE:_INFNFE:_EMIT:_CNPJ:TEXT
	cCodEmit  := Posicione("SA2",3,xFilial("SA2")+cCnpjEmi,"A2_COD")
	cLojaEmit := Posicione("SA2",3,xFilial("SA2")+cCnpjEmi,"A2_LOJA")
	DbSelectArea("SA2")
	DbSetOrder(3)
	DbSeek(xFilial("SA2")+cCnpjEmi)
	cCodEmit  := SA2->A2_COD
	cLojaEmit := SA2->A2_LOJA
Else
	cCnpjEmi  := oXml:_NFEPROC:_NFE:_INFNFE:_EMIT:_CNPJ:TEXT
	cCodEmit  := Posicione("SA1",3,xFilial("SA1")+cCnpjEmi,"A1_COD")
	cLojaEmit := Posicione("SA1",3,xFilial("SA1")+cCnpjEmi,"A1_LOJA")
	DbSelectArea("SA1")
	DbSetOrder(3)
	DbSeek(xFilial("SA1")+cCnpjEmi)
	cCodEmit  := SA1->A1_COD
	cLojaEmit := SA1->A1_LOJA
EndiF


dDataEntr := stod(substr(oXml:_NFEPROC:_NFE:_INFNFE:_IDE:_DEMI:TEXT,1,4)+;
substr(oXml:_NFEPROC:_NFE:_INFNFE:_IDE:_DEMI:TEXT,6,2)+;
substr(oXml:_NFEPROC:_NFE:_INFNFE:_IDE:_DEMI:TEXT,9,2))

If MV_PAR01 == 1
	aadd(aCabec,{"F1_TIPO"   ,"N"}) // normal
ElseIf MV_PAR01 == 2
	aadd(aCabec,{"F1_TIPO"   ,"B"}) // Beneficiamento
ElseIf MV_PAR01 == 4
	aadd(aCabec,{"F1_TIPO"   ,"D"}) // Devolucao
EndIf

aadd(aCabec,{"F1_FORMUL" ,"N"})
aadd(aCabec,{"F1_DOC"    ,STRZERO(VAL(oXml:_NFEPROC:_NFE:_INFNFE:_IDE:_NNF:TEXT),6)})
aadd(aCabec,{"F1_SERIE"  ,oXml:_NFEPROC:_NFE:_INFNFE:_IDE:_SERIE:TEXT})
aadd(aCabec,{"F1_EMISSAO",dDataEntr})
aadd(aCabec,{"F1_FORNECE",cCodEmit})
aadd(aCabec,{"F1_LOJA"   ,cLojaEmit})
aadd(aCabec,{"F1_ESPECIE","NFE"})

aLinha  := {}
If Valtype(oXml:_NFEPROC:_NFE:_INFNFE:_DET) == "A"
	For i := 1 To len(oXml:_NFEPROC:_NFE:_INFNFE:_DET)
		If !lNossoCod
			If MV_PAR01 == 1
				DbSelectArea("ZB5")
				DbSetOrder(1)
				// Filial + CNPJ FORNECEDOR + Codigo do Produto do Fornecedor
				If DbSeek(xFilial("ZB5")+PADR(cCnpjEmi,14)+oXml:_NFEPROC:_NFE:_INFNFE:_DET[i]:_PROD:_CPROD:TEXT)
					cProduto := ZB5->ZB5_PRODFI
					lRetorno := .T.
				Else
					MsgStop("Produto "+ oXml:_NFEPROC:_NFE:_INFNFE:_DET[i]:_PROD:_CPROD:TEXT + " Nใo Cadastrado ... " + CHR(10)+CHR(13) +;
					"A Importa็ใo do XML serแ Interrompida ... " +CHR(10)+CHR(13) +;
					"Fa็a a Amarra็ใo do Produto do Fornecedor com o Nosso Codigo !")
					lRetorno := .F.
					Exit
				EndIf
			Else // MV_PAR01 <> 1
				DbSelectArea("ZB5")
				DbSetOrder(2)
				// Filial + CNPJ CLIENTE + Codigo do Produto do Fornecedor
				If DbSeek(xFilial("ZB5")+PADR(cCnpjEmi,14)+oXml:_NFEPROC:_NFE:_INFNFE:_DET[i]:_PROD:_CPROD:TEXT)
					cProduto := ZB5->ZB5_PRODFI
					lRetorno := .T.
				Else
					MsgStop("Produto "+ oXml:_NFEPROC:_NFE:_INFNFE:_DET[i]:_PROD:_CPROD:TEXT + " Nใo Cadastrado ... " + CHR(10)+CHR(13) +;
					"A Importa็ใo do XML serแ Interrompida ... " +CHR(10)+CHR(13) +;
					"Fa็a a Amarra็ใo do Produto do Fornecedor com o Nosso Codigo !")
					lRetorno := .F.
					Exit
				EndIf
			EndIF
		Else
			DbSelectArea("SB1")
			DbSetOrder(1)
			If DbSeek(xFilial("SB1")+oXml:_NFEPROC:_NFE:_INFNFE:_DET[i]:_PROD:_CPROD:TEXT)
				cProduto := Substr(oXml:_NFEPROC:_NFE:_INFNFE:_DET[i]:_PROD:_CPROD:TEXT,1,15)
			Else
				MsgStop("Produto "+ oXml:_NFEPROC:_NFE:_INFNFE:_DET[i]:_PROD:_CPROD:TEXT + " Nใo Cadastrado ... " + CHR(10)+CHR(13) +;
				"A Importa็ใo do XML serแ Interrompida ... " +CHR(10)+CHR(13) +;
				"Fa็a a Amarra็ใo do Produto do Fornecedor com o Nosso Codigo !")
				lRetorno := .F.
				Exit
			EndIF
		EndIf
		aadd(aLinha,{"D1_COD"  ,cProduto ,Nil})
		SET DECIMALS TO 4
		aadd(aLinha,{"D1_QUANT",VAL(oXml:_NFEPROC:_NFE:_INFNFE:_DET[i]:_PROD:_QCOM:TEXT)  ,Nil})
		aadd(aLinha,{"D1_VUNIT",VAL(oXml:_NFEPROC:_NFE:_INFNFE:_DET[i]:_PROD:_VUNCOM:TEXT) ,Nil})
		SET DECIMALS TO 2
		aadd(aLinha,{"D1_TOTAL",VAL(oXml:_NFEPROC:_NFE:_INFNFE:_DET[i]:_PROD:_VPROD:TEXT),Nil})
		aadd(aItens,aLinha)
		aLinha := {}
	Next i
Else
	If !lNossoCod
		DbSelectArea("ZB5")
		DbSetOrder(1)
		// Filial + CGC + Codigo do Produto do Fornecedor
		If DbSeek(xFilial("ZB5")+PADR(cCnpjEmi,14)+oXml:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_CPROD:TEXT)
			cProduto := ZB5->ZB5_PRODFI
			lRetorno := .T.
		Else
			MsgStop("Produto "+ oXml:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_CPROD:TEXT + " Nใo Cadastrado ... " + CHR(10)+CHR(13) +;
			"A Importa็ใo do XML serแ Interrompida ... " +CHR(10)+CHR(13) +;
			"Fa็a a Amarra็ใo do Produto do Fornecedor com o Nosso Codigo !")
			lRetorno := .F.
		EndIF
	Else
		DbSelectArea("SB1")
		DbSetOrder(1)
		If DbSeek(xFilial("SB1")+oXml:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_CPROD:TEXT)
			cProduto := Substr(oXml:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_CPROD:TEXT,1,15)
		Else
			MsgStop("Produto "+ oXml:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_CPROD:TEXT + " Nใo Cadastrado ... " + CHR(10)+CHR(13) +;
			"A Importa็ใo do XML serแ Interrompida ... " +CHR(10)+CHR(13) +;
			"Fa็a a Amarra็ใo do Produto do Fornecedor com o Nosso Codigo !")
			lRetorno := .F.
		EndIF
	EndIf
	If lRetorno
		aadd(aLinha,{"D1_COD"  ,cProduto ,Nil})
		SET DECIMALS TO 4
		aadd(aLinha,{"D1_QUANT",VAL(oXml:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_QCOM:TEXT)  ,Nil})
		aadd(aLinha,{"D1_VUNIT",VAL(oXml:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_VUNCOM:TEXT) ,Nil})
		SET DECIMALS TO 2
		aadd(aLinha,{"D1_TOTAL",VAL(oXml:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_VPROD:TEXT),Nil})
		aadd(aItens,aLinha)
	EndIf
EndIf

cChaveF1 :=	PADR(STRZERO(VAL(oXml:_NFEPROC:_NFE:_INFNFE:_IDE:_NNF:TEXT),6),9)+;
PADR(oXml:_NFEPROC:_NFE:_INFNFE:_IDE:_SERIE:TEXT,3)+cCodEmit+cLojaEmit+"N"

DbSelectArea("SF1")
DbSetOrder(1)
If DbSeek(xFilial("SF1")+cChaveF1)
	MsgSTOP("Esta NFE jแ foi importada para a Base !!!")
	lRetorno := .F.
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//| Inicio da Inclusao                                            |
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

If lRetorno
	MSExecAuto({|x,y,z| mata140(x,y,z)},aCabec,aItens,3)
	If lMsErroAuto
		MOSTRAERRO()
		MsgSTOP("Ocorreu um Erro, a Importa็ใo Nใo foi Efetuada !!!")
		cFile1 := alltrim(GETMV("MV_XMLREJE"))
		cFile2 := cFile1 + cCnpjEmi + "\" + substr(cfile,18,len(cfile))
		cLocalPath := GetSrvProfString("RootPath", "\undefined") + '\'+ Alltrim(GETMV("MV_XMLEXTR")) +'\'+ Substr(cFile1,1,10)
		IF !lIsDir( cLocalPath + '\' + cCnpjEmi)
			DIRXMLCGC(cFile2,cCnpjEmi)
			__CopyFile(cFile,"\"+Upper(Alltrim(GETMV("MV_XMLEXTR")))+'\'+cFile1 + '\'+ cCnpjEmi + '\' + substr(cfile,18,len(cfile))) //-> Copia o arquivo para o diretorio criado
		Else
			__CopyFile(cFile,"\"+Upper(Alltrim(GETMV("MV_XMLEXTR")))+'\'+ cFile2) //-> Copia o arquivo para o diretorio criado
		EndIF
		FClose(cFile)
		FErase(cFile)
		lRetorno := .F.
	Else
		MsgAlert("Importa็ใo da Pr้-Nota Efetuada com Sucesso !!!"+CHR(13)+CHR(10)+CHR(13)+CHR(10)+" Utilize a op็ใo "+CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
		"Movimento -> Pre-Nota Entrada "+CHR(13)+CHR(10)+CHR(13)+CHR(10)+" para Verificar a Integridade dos Dados.")
		dbSelectArea("SF1")
		dbCloseArea("SF1")
		cFile1 := alltrim(GETMV("MV_XMLIMPO"))
		cFile2 := cFile1 + '\' + cCnpjEmi + substr(cfile,18,len(cfile))
		cLocalPath := GetSrvProfString("RootPath", "\undefined") + '\'+ Alltrim(GETMV("MV_XMLEXTR")) +'\'+ Substr(cFile1,1,10)
		IF !lIsDir( cLocalPath + '\' + cCnpjEmi)
			DIRXMLCGC(cFile2,cCnpjEmi)
			__CopyFile(cFile,"\"+Upper(Alltrim(GETMV("MV_XMLEXTR")))+'\'+cFile1 + '\'+ cCnpjEmi + '\' + substr(cfile,18,len(cfile))) //-> Copia o arquivo para o diretorio criado
		Else
			__CopyFile(cFile,"\"+Upper(Alltrim(GETMV("MV_XMLEXTR")))+'\'+ cFile2) //-> Copia o arquivo para o diretorio criado
		EndIF
		FClose(cFile)
		FErase(cFile)
		lRetorno := .T.
	EndIf
Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCOMP0003  บAutor  ณMarcos Favaro       บ Data ณ  05/05/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function DIRXMLCGC(cFile1,cCnpjEmi)

IF !lIsDir( cLocalPath + '\' + cCnpjEmi)
	MakeDir( cLocalPath + '\' + cCnpjEmi)
	IF !lIsDir( cLocalPath + '\' + cCnpjEmi )
		MSGSTOP( "Impossํvel Criar o Diret๓rio: " + cCnpjEmi )
		MSGALERT( "O XML serแ movido para a Pasta RAIZ !!! ")
		cFile2 := cLocalPath + '\'
	Else
		cFile2 := cLocalPath + '\' + cCnpjEmi + '\'
	EndIF
Else
	cFile2 := cLocalPath + '\' + cCnpjEmi + '\'
EndIF
Return(cFile2)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCOMPBAIXA บAutor  ณMicrosiga           บ Data ณ  03/29/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ValidPerg()

_sAlias := Alias()

dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR("IMPXML",LEN(SX1->X1_GRUPO))
aRegs:={}

aAdd(aRegs,{cPerg,"01","Informe Tipo da Nota ?","","","MV_CH1","N",1,0,1,"C","","MV_PAR01","N-Normal","","","","","B-Beneficiamento","","","","","D-Devolucao","","","","","","","","","",})
aAdd(aRegs,{cPerg,"02","Consulta NF-e ?"       ,"","","MV_CH2","N",1,0,1,"C","","MV_PAR02","Aceita Vใlidas","","","","","Aceita todas","","","","","Nใo Consulta","","","","","","","","","",})

For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				If j <= Len(aRegs[i])
					FieldPut(j,aRegs[i,j])
				Endif
			Endif
		Next
		MsUnlock()
	Endif
Next

dbSelectArea(_sAlias)

Return


Static Function __Dummy(lRecursa) //warning W0010 Static Function <?> never called
    lRecursa := .F.
    IF (lRecursa)
        __Dummy(.F.)
        U_HFXML01()
	EndIF
Return(lRecursa)