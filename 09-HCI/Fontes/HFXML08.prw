#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMVCDEF.CH"                 
#INCLUDE "FWADAPTEREAI.CH"

//Static Function MenuDef()
//Return StaticCall(MATXATU,MENUDEF)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ HFXML08  บ Autor ณ Eneovaldo Roveri Jrบ Data ณ  12/11/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Cadastro de Fornecedor Carregando Campos do XML.           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ IMPORTA XML                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function HFXML08()
Local lRet     := .T.
Local aArea    := GetArea()
Local cError   := ""
Local cWarning := ""
Local cFilSeek := ""
Private lSharedA2:= U_IsShared("SA2")
Private oXml, cTag, cCpo, xTag

If GetNewPar("XM_USACFOR","S") == "N"  //Para Capricornio
	U_MyAviso("ATENวรO","Cadastro Fornecedor Nใo Habilitado, Verifique Parโmetro XM_USACFOR",{"OK"},3)
	RestArea( aArea )
	Return( .F. )
EndIf

If ZBZ->ZBZ_TPDOC $ "D|B"
	U_MyAviso("TIPO "+iif(ZBZ->ZBZ_TPDOC=="D","DEVOLUวยO","BENEFICIAMENTO"),"Tipo do Documento utiliza Cliente",{"OK"},3)
	RestArea( aArea )
	Return( .F. )
EndIF

cFilSeek := Iif(lSharedA2,xFilial("SA2"),ZBZ->ZBZ_FILIAL )
DbSelectArea("SA2")
DbSetOrder(3)
If DbSeek(cFilSeek+ZBZ->ZBZ_CNPJ)
	Do While .not. SA2->( eof() ) .and. SA2->A2_FILIAL == cFilSeek .and.;
	               SA2->A2_CGC == ZBZ->ZBZ_CNPJ
		if SA2->A2_MSBLQL != "1"
			lRet := .F.
			exit
		endif
		SA2->( dbSkip() )
	EndDo
EndIf	

DbSelectArea("ZBZ")
if .Not. lRet
	if (ZBZ->ZBZ_CODFOR <> SA2->A2_COD .or. ZBZ->ZBZ_LOJFOR <> SA2->A2_LOJA) .And. ZBZ_PRENF == "B"
		RecLock("ZBZ",.F.)
		ZBZ->ZBZ_CODFOR := SA2->A2_COD
		ZBZ->ZBZ_LOJFOR := SA2->A2_LOJA
		ZBZ->ZBZ_FORNEC := SA2->A2_NOME
		ZBZ->(DbCommit())
		ZBZ->(MsUnlock())
	EndIf
	U_MyAviso("ATENวรO","Fornecedor Jแ Cadastrado",{"OK"},3)
	RestArea( aArea )
	Return( .F. )
EndIf

oXml := XmlParser(ZBZ->ZBZ_XML, "_", @cError, @cWarning )

If oXml == NIL .Or. !Empty(cError) //.Or. !Empty(cWarning)
	if empty(cError)
		cError := "XML Importado com erro. Verifique os dados importados e refa็a a importa็ใo."
	endif
	U_MyAviso("Erro XML",cError,{"OK"},3)
	RestArea( aArea )
	Return( .F. )
EndIf

lRet := U_HFXML08I()

RestArea( aArea )
Return( lRet )


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ HFXML08I บ Autor ณ Eneovaldo Roveri Jrบ Data ณ  12/11/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Fun็ใo de Inclusใo de Fornecedor.                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ IMPORTA XML                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function HFXML08I(aRotAuto,nOpcAuto)
Local nOpcA    := 0
Local aParam    := {{|| .T.},{|| .T.},{|| .T.},{|| .T.}}
Private lIntLox    := GetMV("MV_QALOGIX") == "1"

nOpcA := AxInclui("SA2",1,Nil,/*aAcho*/,"U_HFXML08D",/*aCpos*/,"A020TudoOk()",.T.,/*cTransact*/,/*aButtons*/,;
		          aParam,/*aAuto*/,/*lVirtual*/,/*lMaximized*/,/*cTela*/,/*lPanelFin*/,/*oFather*/,/*aDim*/,/*uArea*/)

DbSelectArea("ZBZ")
if nOpcA == 1
	RecLock("ZBZ",.F.)
		ZBZ->ZBZ_CODFOR := SA2->A2_COD
		ZBZ->ZBZ_LOJFOR := SA2->A2_LOJA
		ZBZ->ZBZ_FORNEC := SA2->A2_NOME
	ZBZ->(DbCommit())
	ZBZ->(MsUnlock())
EndIf

Return( (nOpcA==1) )



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ HFXML08D บ Autor ณ Eneovaldo Roveri Jrบ Data ณ  12/11/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Carregar variแveis com campos das TAGs do XML <Emitente>   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ IMPORTA XML                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function HFXML08D()

If ZBZ->ZBZ_MODELO == "57"
	xTag := "CTE"
Else
	xTag := "NFE"
EndIf

cTag := "oXml:_"+xTAG+"PROC:_"+xTAG+":_INF"+xTAG+":_EMIT:_CNPJ:TEXT"
if Type(cTag) <> "U"
	cCpo := &cTag
	M->A2_CGC  := cCpo
	M->A2_TIPO := iif(len(AllTrim(cCpo))==14,"J","F")
endif

cTag := "oXml:_"+xTAG+"PROC:_"+xTAG+":_INF"+xTAG+":_EMIT:_XNOME:TEXT"
if Type(cTag) <> "U"
	cCpo := &cTag
	M->A2_NOME := cCpo
	M->A2_NREDUZ := cCpo
endif

cTag := "oXml:_"+xTAG+"PROC:_"+xTAG+":_INF"+xTAG+":_EMIT:_XFANT:TEXT"
if Type(cTag) <> "U"
	cCpo := &cTag
	M->A2_NREDUZ := cCpo
endif

cTag := "oXml:_"+xTAG+"PROC:_"+xTAG+":_INF"+xTAG+":_EMIT:_IE:TEXT"
if Type(cTag) <> "U"
	cCpo := &cTag
	M->A2_INSCR := cCpo
endif

cTag := "oXml:_"+xTAG+"PROC:_"+xTAG+":_INF"+xTAG+":_EMIT:_ENDEREMIT:_XLGR:TEXT"
if Type(cTag) <> "U"
	cCpo := &cTag
	M->A2_END := cCpo
endif

cTag := "oXml:_"+xTAG+"PROC:_"+xTAG+":_INF"+xTAG+":_EMIT:_ENDEREMIT:_NRO:TEXT"
if Type(cTag) <> "U"
	cCpo := &cTag
	M->A2_NR_END := cCpo
endif

cTag := "oXml:_"+xTAG+"PROC:_"+xTAG+":_INF"+xTAG+":_EMIT:_ENDEREMIT:_XCPL:TEXT"
if Type(cTag) <> "U"
	cCpo := &cTag
	M->A2_ENDCOMP := cCpo
endif

cTag := "oXml:_"+xTAG+"PROC:_"+xTAG+":_INF"+xTAG+":_EMIT:_ENDEREMIT:_XBAIRRO:TEXT"
if Type(cTag) <> "U"
	cCpo := &cTag
	M->A2_BAIRRO := cCpo
endif

cTag := "oXml:_"+xTAG+"PROC:_"+xTAG+":_INF"+xTAG+":_EMIT:_ENDEREMIT:_UF:TEXT"
if Type(cTag) <> "U"
	cCpo := &cTag
	M->A2_EST := cCpo
endif

cTag := "oXml:_"+xTAG+"PROC:_"+xTAG+":_INF"+xTAG+":_EMIT:_ENDEREMIT:_CMUN:TEXT"
if Type(cTag) <> "U"
	cCpo := &cTag
	M->A2_COD_MUN := Substr(cCpo,3,5)
endif

cTag := "oXml:_"+xTAG+"PROC:_"+xTAG+":_INF"+xTAG+":_EMIT:_ENDEREMIT:_XMUN:TEXT"
if Type(cTag) <> "U"
	cCpo := &cTag
	M->A2_MUN := cCpo
endif

cTag := "oXml:_"+xTAG+"PROC:_"+xTAG+":_INF"+xTAG+":_EMIT:_ENDEREMIT:_CEP:TEXT"
if Type(cTag) <> "U"
	cCpo := &cTag
	M->A2_CEP := cCpo
endif

cTag := "oXml:_"+xTAG+"PROC:_"+xTAG+":_INF"+xTAG+":_EMIT:_ENDEREMIT:_CPAIS:TEXT"
if Type(cTag) <> "U"
	cCpo := &cTag
	M->A2_PAIS := cCpo
endif

cTag := "oXml:_"+xTAG+"PROC:_"+xTAG+":_INF"+xTAG+":_EMIT:_ENDEREMIT:_FONE:TEXT"
if Type(cTag) <> "U"
	cCpo := &cTag
	if len(cCpo) > 9
		M->A2_DDD := Substr(cCpo,1,2)
		M->A2_TEL := Substr(cCpo,2,len(cCpo))
	else
		M->A2_TEL := cCpo
	endif
endif

cTag := "oXml:_"+xTAG+"PROC:_"+xTAG+":_INF"+xTAG+":_EMIT:_CNAE:TEXT"
if Type(cTag) <> "U"
	cCpo := &cTag
	M->A2_CNAE := cCpo
endif

cTag := "oXml:_"+xTAG+"PROC:_"+xTAG+":_INF"+xTAG+":_EMIT:_IM:TEXT"
if Type(cTag) <> "U"
	cCpo := &cTag
	M->A2_INSCRM := cCpo
endif

Return( .T. )



//Local cCadastro   := OemtoAnsi("Fornecedores")  //"Fornecedores"
//Local cFiltraSA2  := " "
//Local aIndexSA2	  := {}
//Local bFiltraBrw  := " "
//Local aMemUser := {}
//Local aRotina  := {{OemToAnsi("Contatos"),"FtContato", 0 , 4}}  //"Contatos"
//Local aACS     := {Nil,Nil,81,82,3,Nil}
//Local aButtons := {}
//Local aUsrBut  := {}
//Local aRotAdic := {}
//Local lPyme    := Iif(Type("__lPyme") <> "U",__lPyme,.F.)
//Local lTMSOPdg := AliasInDic('DEG') .And. SuperGetMV('MV_TMSOPDG',,'0') == '2' 
//-- Variavel usada para verificar se o disparo da funcao IntegDef() pode ser feita manualmente
//Local lIntegDef:=  FindFunction("GETROTINTEG") .And. FindFunction("FWHASEAI") .And. FWHasEAI("MATA020",.T.,,.T.)  

//Local nPosFor  :=0
//Local nPosLoja :=0  
//Local nPosMun  :=0

//Private aMemos     := {}
//Private aCpoAltSA2 := {} // vetor usado na gravacao do historico de alteracoes   
//Private lCGCValido := .F. // Variavel usada na validacao do CNPJ/CPF (utilizando o Mashup)
//Private aCmps      := {}
//Private aPreCols:= {}
//Private aCols 	:= {}
//Private aHeader	:= {}	
//PRIVATE cCodFor	:= ""
//PRIVATE cCodLoj	:= ""    
//PRIVATE l020Auto  := ( valType(aRotAuto) == "A" )
//STATIC lHistFiscal := IIf(FindFunction("HistFiscal"),HistFiscal(), .F.)


Static Function __Dummy(lRecursa) //warning W0010 Static Function <?> never called
    lRecursa := .F.
    IF (lRecursa)
        __Dummy(.F.)
        U_HFXML08()
        U_HFXML08D()
        U_HFXML08I()
	EndIF
Return(lRecursa)