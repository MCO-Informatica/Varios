#Include 'Protheus.ch'
#INCLUDE 'FWMVCDEF.CH'

//Variáveis Estáticas
Static cTitulo := "Amarração Contrato x CCR"

//-----------------------------------------------------------------------------
// Rotina | CRPA057   | Autor | Joao Goncalves de Oliveira | Data | 19.01.2016
//-----------------------------------------------------------------------------
// Descr. | Rotina para cadastro de Exceções do PCO
//-----------------------------------------------------------------------------
// Update | Transformação da rotina para MVC - Rafael Beghini 28.08.2018
//-----------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------------
User Function CRPA057()
	Local oBrowse 
	Local aFields 	:= {}
	Local aSeek		:= {} 
	Private cAlias 	:= GetNextAlias()
	Private cArq	:= ""
	Private cArqIdx := ""
	
	MsAguarde({|| fLoadTable()},"Carregando dados de contratos","Contratos x CCR",.F.)
	
	/* Estrutura do aFields
	[n][01] Descrição do campo
	[n][02] Nome do campo
	[n][03] Tipo
	[n][04] Tamanho
	[n][05] Decimal
	[n][06] Picture*/
	
	aAdd(aFields,{"Contrato","TTMP->CN9_NUMERO","C",TamSX3("CN9_NUMERO")[1],0,"@!"})
	aAdd(aFields,{"Revisão","TTMP->CN9_REVISA","C",TamSX3("CN9_REVISA")[1],0,"@!"})
	aAdd(aFields,{"CCR","TTMP->CNC_XCCR","C",TamSX3("CNC_XCCR")[1],0,"@!"})	
	aAdd(aFields,{"Fornecedor","TTMP->CNC_CODIGO","C",TamSX3("CNC_CODIGO")[1],0,"@!"})
	aAdd(aFields,{"Loja Forne","TTMP->CNC_LOJA","C",TamSX3("CNC_LOJA")[1],0,"@!"})
	aAdd(aFields,{"Nome Forne","TTMP->A2_NOME","C",TamSX3("A2_NOME")[1],0,"@!"})
	
	/* Estrutura do aSeek
	[n,1] Título da pesquisa
	[n,2,1] LookUp
	[n,2,2] Tipo de dados
	[n,2,3] Tamanho
	[n,2,4] Decimal
	[n,2,5] Título do campo
	[n,2,6] Máscara
	[n,3] Ordem da pesquisa
	[n,4] Exibe na pesquisa*/
				
	//aAdd(aSeek,{{"Contrato",{"CN9_NUMERO","C",TamSX3("CNC_NUMERO")[1],0,"Num Contrato","@!"},1,.T.}})
	
	oBrowse := FwmBrowse():NEW() 
	oBrowse:SetAlias("TTMP")
	oBrowse:SetDescription(cTitulo)
	oBrowse:SetTemporary(.T.)
	oBrowse:SetFields(aFields)
	oBrowse:SetSeek(.T.,{})
	//oBrowse:SetFilterDefault("CNC_FILIAL == xFilial('CNC') .And. !Empty(CNC_CODIGO)")
	oBrowse:Activate() // Ativando a classe obrigatorio
	
	(cAlias)->(dbCloseArea())
	
	FErase(cArq)
	FErase(cArqIdx+OrdBagExt())
	
Return( NIL )

//-----------------------------------------------------------------------
// Rotina | CRPA057   | Autor | Rafael Beghini     | Data | 28.08.2018
//-----------------------------------------------------------------------
// Descr. | Monta as opções do browse
//-----------------------------------------------------------------------
Static Function MenuDef()
	Local aBotao := {}
	aAdd(aBotao,{ "Visualizar", "VIEWDEF.CRPA057", 0, 2, 0, NIL } )
	//aAdd(aBotao,{ "Incluir"   , "VIEWDEF.CRPA057", 0, 3, 0, NIL } )
	aAdd(aBotao,{ "Alterar"   , "VIEWDEF.CRPA057", 0, 4, 0, NIL } )
	//aAdd(aBotao,{ "Excluir"   , "VIEWDEF.CRPA057", 0, 5, 0, NIL } )
	aAdd(aBotao,{ "Imprimir"  , "VIEWDEF.CRPA057", 0, 8, 0, NIL } )
Return aBotao

//-----------------------------------------------------------------------
// Rotina | CRPA057   | Autor | Rafael Beghini     | Data | 28.08.2018
//-----------------------------------------------------------------------
// Descr. | Definição do modelo de Dados
//-----------------------------------------------------------------------
Static Function ModelDef()
	Local oModel
	Local bPost		:= {|| .T. }
	Local bCommit	:= {|| fGrava(oModel) }
	Local bFields	:= {|x| AllTrim(x) $ "CNC_NUMERO|CNC_CODIGO|CNC_LOJA|CNC_NOME|CNC_REVISA|CNC_XCCR" }
	Local bLoad		:= {|oMdl| CRPA57Ld(oMdl)}
	Local oStruct	:= fModelCtr()
	//Local oStruCNC	:= FWFormStruct(1,'CNC', bFields)

	oModel := MPFormModel():New("MODELCNC", /*bPre*/  , bPost, bCommit, /*bCancel*/ )
	
	oModel:AddFields('CNCCUSTOM',/*cOwner*/, oStruct ,/*bPre*/,bPost,bLoad)

	oModel:SetPrimaryKey({"CNC_NUMERO"})
    	     
    //Setando as descrições
    oModel:SetDescription(cTitulo)
    oModel:GetModel('CNCCUSTOM'):SetDescription('Contratos x CCR')
    oModel:SetActivate()
Return oModel

//-----------------------------------------------------------------------
// Rotina | CRPA057  | Autor | Rafael Beghini     | Data | 28.08.2018
//-----------------------------------------------------------------------
// Descr. | Definição da visualização dos dados
//-----------------------------------------------------------------------
Static Function ViewDef()
	Local oView
	Local oModel 	:= ModelDef() //FWLoadModel('CRPA057')
	//Local bFields	:= {|x| AllTrim(x) $ "CNC_NUMERO|CNC_CODIGO|CNC_LOJA|CNC_NOME|CNC_REVISA|CNC_XCCR" }
	//Local oStruCNC	:= FWFormStruct(2, 'CNC', bFields)
	//Local oModel	:= ModelDef()
	Local oStruCNC	:= fViewCtr()
	oView := FWFormView():New()

	oView:SetModel(oModel)
     
    oStruCNC:SetProperty( 'CNC_XCCR' , MVC_VIEW_CANCHANGE,.T.)    
    
    //Adicionando os campos do cabeçalho e o grid dos filhos
    oView:AddField('VIEW_CNC',oStruCNC,'CNCCUSTOM')
     
    //Setando o dimensionamento de tamanho
    oView:CreateHorizontalBox('TELA',100)
     
    //Amarrando a view com as box
    oView:SetOwnerView('VIEW_CNC','TELA')
     
    //Habilitando título
    oView:EnableTitleView('VIEW_CNC',cTitulo)
    
Return oView
//-----------------------------------------------------------------------
// Rotina | CRPA057  | Autor | Rafael Beghini     | Data | 28.08.2018
//-----------------------------------------------------------------------
// Descr. | Função para o Commit
//-----------------------------------------------------------------------
Static Function fGrava(oModel)
	
	Local lRet := .T.
	Local nRecno := TTMP->R_E_C_N_O_
	
	Begin Transaction
		If FwFormCommit(oModel)
			If oModel:GetOperation() == MODEL_OPERATION_UPDATE // MODEL_OPERATION_UPDATE | MODEL_OPERATION_DELETE | MODEL_OPERATION_INSERT
				//nRecno := oModel:GetValue( 'CNCCUSTOM' , 'RECNO' )
				CNC->( dbGoto(nRecno) )
	
				//-- Verifico se foi marcado o título
				If !Empty(oModel:GetValue( 'CNCCUSTOM' , 'CNC_XCCR' ))
					CNC->( RecLock('CNC',.F.) )
						CNC->CNC_XCCR	:= oModel:GetValue( 'CNCCUSTOM' , 'CNC_XCCR'  )
					CNC->(MsUnLock())
					RecLock("TTMP",.F.)
						TTMP->CNC_XCCR 	:= oModel:GetValue( 'CNCCUSTOM' , 'CNC_XCCR'  )
					TTMP->(MsUnlock())
				EndIf
			EndIf
		Else
			If oModel:GetOperation() == MODEL_OPERATION_UPDATE //MODEL_OPERATION_INSERT | MODEL_OPERATION_UPDATE | MODEL_OPERATION_DELETE
				RollBackSX8()
			EndIf
			Help(,,"Atenção !!!",,"Problema na gravação dos dados",1,0)
			lRet := .F.
			DisarmTransaction()
		EndIf
	End Transaction 
Return lRet

//---------------------------------------------------------------------------------
// Rotina | A441Trigger | Autor | Rafael Beghini               | Data | 17.09.2018
//---------------------------------------------------------------------------------
// Descr. | Gatilho no preenchimento do campo E1_VENCTO
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Static Function fModelCtr()

Local oStruct := FwFormModelStruct():New()

//AddField(<cTitulo >, <cTooltip >, <cIdField >, <cTipo >, <nTamanho >, [ nDecimal ], [ bValid ], [ bWhen ], [ aValues ], [ lObrigat ], [ bInit ], <lKey >, [ lNoUpd ], [ lVirtual ], [ cValid ])

oStruct:AddField('Contrato'	, 'Contrato'		 , 'CN9_NUMERO'	,'C',TamSX3('CN9_NUMERO')[1],0,,{|| .F.},{},.F.,,.F.,.F.,.F.,"")
oStruct:AddField('Revisão'	, 'Revisão'			 , 'CN9_REVISA'	,'C',TamSX3('CN9_REVISA')[1],0,,{|| .F.},{},.F.,,.F.,.F.,.F.,"")
oStruct:AddField('Cod Forn'	, 'Código Fornecedor', 'CNC_CODIGO'	,'C',TamSX3('CNC_CODIGO')[1],0,,{|| .F.},{},.F.,,.F.,.F.,.F.,"")
oStruct:AddField('Loja Forn', 'Loja Fornecedor'	 , 'CNC_LOJA'  	,'C',TamSX3('CN9_NUMERO')[1],0,,{|| .F.},{},.F.,,.F.,.F.,.F.,"")
oStruct:AddField('Nome Forn', 'Nome Fornecedor'	 , 'A2_NOME'	,'C',TamSX3('A2_NOME')[1]	,0,,{|| .F.},{},.F.,,.F.,.F.,.F.,"")
oStruct:AddField('CCR'		, 'CCR'		 		 , 'CNC_XCCR'	,'C',TamSX3('CNC_XCCR')[1]	,0,,{|| .T.},{},.F.,,.F.,.F.,.F.,"")
oStruct:AddField('Descr.CCR', 'Descrição CCR'	 , 'CNC_XCCRDE'	,'C',TamSX3('Z3_DESENT ')[1],0,,{|| .T.},{},.F.,,.F.,.F.,.T.,"")

oStruct:AddTrigger( 'CNC_XCCR', 'CNC_XCCRDE', {|| .T. }, {|| CA57Trigger() } )

Return oStruct

//---------------------------------------------------------------------------------
// Rotina | A441Trigger | Autor | Rafael Beghini               | Data | 17.09.2018
//---------------------------------------------------------------------------------
// Descr. | Gatilho no preenchimento do campo E1_VENCTO
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Static Function fViewCtr()

Local oStruct := FwFormViewStruct():New()

//AddField(<cIdField >, <cOrdem >, <cTitulo >, <cDescric >, <aHelp >, <cType >, <cPicture >, <b	PictVar >, <cLookUp >, <lCanChange >, <cFolder >, <cGroup >, [ aComboValues ], [ nMaxLenCombo ], <cIniBrow >, <lVirtual >, <cPictVar >, [ lInsertLine ], [ nWidth ])

oStruct:AddField('CN9_NUMERO','1','Numero'		 ,'Numero do Contrato'	,/*aHelp*/,'Get','@!',/*bPictVar*/,/*cLookUp*/,.F.,/*cFolder*/,/*cGroup*/,/*aComboValues*/,/*nMaxLenCombo*/,/*cIniBrow*/,/*lVirtual*/,/*cPictVar*/,/*lInsertLine*/,/*nWidth*/)
oStruct:AddField('CN9_REVISA','2','Revisao'		 ,'Revisao do Contrato'	,/*aHelp*/,'Get','@!',/*bPictVar*/,/*cLookUp*/,.F.,/*cFolder*/,/*cGroup*/,/*aComboValues*/,/*nMaxLenCombo*/,/*cIniBrow*/,/*lVirtual*/,/*cPictVar*/,/*lInsertLine*/,/*nWidth*/)
oStruct:AddField('CNC_CODIGO','3','Cod Forn'	 ,'Codigo do Fornecedor',/*aHelp*/,'Get','@!',/*bPictVar*/,/*cLookUp*/,.F.,/*cFolder*/,/*cGroup*/,/*aComboValues*/,/*nMaxLenCombo*/,/*cIniBrow*/,/*lVirtual*/,/*cPictVar*/,/*lInsertLine*/,/*nWidth*/)
oStruct:AddField('CNC_LOJA'	 ,'4','Loja Forn'	 ,'Loja do Fornecedor'	,/*aHelp*/,'Get','@!',/*bPictVar*/,/*cLookUp*/,.F.,/*cFolder*/,/*cGroup*/,/*aComboValues*/,/*nMaxLenCombo*/,/*cIniBrow*/,/*lVirtual*/,/*cPictVar*/,/*lInsertLine*/,/*nWidth*/)
oStruct:AddField('A2_NOME'	 ,'5','Nome Forn'    ,'Nome do Fornecedor'	,/*aHelp*/,'Get','@!',/*bPictVar*/,/*cLookUp*/,.F.,/*cFolder*/,/*cGroup*/,/*aComboValues*/,/*nMaxLenCombo*/,/*cIniBrow*/,/*lVirtual*/,/*cPictVar*/,/*lInsertLine*/,/*nWidth*/)
oStruct:AddField('CNC_XCCR'	 ,'6','CCR'			 ,'Codigo do CCR'		,/*aHelp*/,'Get','@!',/*bPictVar*/,'SZ3CCR'   ,.T.,/*cFolder*/,/*cGroup*/,/*aComboValues*/,/*nMaxLenCombo*/,/*cIniBrow*/,/*lVirtual*/,/*cPictVar*/,/*lInsertLine*/,/*nWidth*/)
oStruct:AddField('CNC_XCCRDE','7','Descrição CCR','Descrição CCR'		,/*aHelp*/,'Get','@!',/*bPictVar*/,/*cLookUp*/,.F.,/*cFolder*/,/*cGroup*/,/*aComboValues*/,/*nMaxLenCombo*/,/*cIniBrow*/,.T.		 ,/*cPictVar*/,/*lInsertLine*/,/*nWidth*/)

Return oStruct

//---------------------------------------------------------------------------------
// Rotina | A441Trigger | Autor | Rafael Beghini               | Data | 17.09.2018
//---------------------------------------------------------------------------------
// Descr. | Gatilho no preenchimento do campo E1_VENCTO
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Static Function fLoadTable()

Local aLastQuery := {}
Local cLastQuery := ""
Local aStrut 	 := {}

If Select(cAlias) > 0
	(cAlias)->(dbCloseArea())
EndIf

aAdd(aStrut,{"CN9_NUMERO","C",TamSX3("CN9_NUMERO")[1],0})
aAdd(aStrut,{"CN9_REVISA","C",TamSX3("CN9_REVISA")[1],0})
aAdd(aStrut,{"CNC_CODIGO","C",TamSX3("CNC_CODIGO")[1],0})
aAdd(aStrut,{"CNC_LOJA","C",TamSX3("CNC_LOJA")[1],0})
aAdd(aStrut,{"A2_NOME","C",TamSX3("A2_NOME")[1],0})
aAdd(aStrut,{"CNC_XCCR","C",TamSX3("CNC_XCCR")[1],0})
aAdd(aStrut,{"R_E_C_N_O_","N",15,0})

cArq 	:= CriaTrab(aStrut,.T.)
cArqIdx := CriaTrab(,.F.)

If Select("TTMP") > 0
	TTMP->(dbCloseArea())
EndIf

dbUseArea(.T.,,cArq,"TTMP")
IndRegua("TTMP",cArqIdx,"CN9_NUMERO")

BeginSQL Alias cAlias
	SELECT CN9_NUMERO,CN9_REVISA,CNC_CODIGO,CNC_LOJA,A2_NOME,CNC_XCCR,CNC.R_E_C_N_O_
	FROM %Table:CN9% CN9 
	JOIN %Table:CNC% CNC
		ON 	CNC_FILIAL = CN9_FILIAL
		AND CNC_NUMERO = CN9_NUMERO
		AND CNC_REVISA = CN9_REVISA
	JOIN %Table:SA2% SA2
		ON 	A2_COD = CNC_CODIGO
		AND A2_LOJA = CNC_LOJA
	WHERE CN9_FILIAL = %xFilial:CN9% 
		AND CN9_SITUAC = '05' 
		AND CNC_CODIGO != '      '
		AND CNC.%NOTDEL%
		AND SA2.%NOTDEL%
		AND CN9.%NOTDEL%
	ORDER BY CN9_NUMERO
EndSQL

aLastQuery    := GetLastQuery()
cLastQuery    := aLastQuery[2]

MemoWrite("C:\Data\CRPA057.sql",cLastQuery)

While (cAlias)->(!EoF())
	RecLock("TTMP",.T.)
		TTMP->CN9_NUMERO := (cAlias)->CN9_NUMERO
		TTMP->CN9_REVISA := (cAlias)->CN9_REVISA
		TTMP->CNC_CODIGO := (cAlias)->CNC_CODIGO
		TTMP->CNC_LOJA 	 := (cAlias)->CNC_LOJA
		TTMP->A2_NOME 	 := (cAlias)->A2_NOME
		TTMP->CNC_XCCR 	 := (cAlias)->CNC_XCCR
		TTMP->R_E_C_N_O_ := (cAlias)->R_E_C_N_O_
	TTMP->(MsUnlock())
	(cAlias)->(dbSkip())
EndDo

dbSelectArea(cAlias)
(cAlias)->(dbGoTop())

Return

//---------------------------------------------------------------------------------
// Rotina | A441Trigger | Autor | Rafael Beghini               | Data | 17.09.2018
//---------------------------------------------------------------------------------
// Descr. | Gatilho no preenchimento do campo E1_VENCTO
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Static Function CRPA57Ld(oModel)

Local aRet := {}
Local cNewAlias := GetNextAlias()
Local cContrato := ""
Local cRevisao	:= ""
Local cCodForn	:= ""
Local cLojaFor	:= ""
Local cNomeFor	:= ""
Local cCCR		:= ""

DEFAULT oModel := FwLoadModel("CRPA057")

cContrato	:= TTMP->CN9_NUMERO 
cRevisao	:= TTMP->CN9_REVISA 
cCodForn	:= TTMP->CNC_CODIGO 
cLojaFor	:= TTMP->CNC_LOJA 	 
cNomeFor	:= TTMP->A2_NOME 	 
cCCR		:= TTMP->CNC_XCCR 	 

If Select(cNewAlias) > 0
	(cNewAlias)->(dbCloseArea())
EndIf

BeginSQL Alias cNewAlias
	SELECT CNC_NUMERO,CNC_REVISA,CNC_CODIGO,CNC_LOJA,A2_NOME,CNC_XCCR,'' CNC_XCCRDE,CNC.R_E_C_N_O_
	FROM %Table:CNC% CNC
	JOIN %Table:SA2% SA2
	 	ON  A2_COD = CNC_CODIGO
	 	AND A2_LOJA = CNC_LOJA
	 	AND A2_FILIAL = %xFilial:SA2%
	WHERE CNC_FILIAL = %xFilial:CNC% 
		AND CNC_NUMERO = %Exp:cContrato%
		AND CNC_REVISA = %Exp:cRevisao%
		AND CNC_CODIGO = %Exp:cCodForn%
		AND CNC_LOJA   = %Exp:cLojaFor%
		AND CNC.%NOTDEL%
EndSQL

aAdd(aRet,{(cNewAlias)->CNC_NUMERO, (cNewAlias)->CNC_REVISA, (cNewAlias)->CNC_CODIGO, (cNewAlias)->CNC_LOJA, (cNewAlias)->A2_NOME, (cNewAlias)->CNC_XCCR, ''})
aAdd(aRet,(cNewAlias)->R_E_C_N_O_) 

Return aRet

//---------------------------------------------------------------------------------
// Rotina | A441Trigger | Autor | Rafael Beghini               | Data | 17.09.2018
//---------------------------------------------------------------------------------
// Descr. | Gatilho no preenchimento do campo E1_VENCTO
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Static Function CA57Trigger()
	Local oModel	 	:= FWModelActive()	//-- Captura Model Ativa
	Local oModelEnch	:= oModel:GetModel( 'CNCCUSTOM' )
	Local cCCR	 		:= oModelEnch:GetValue( 'CNC_XCCR' )
	Local cNomeCCR		:= ""
	Local cTmp			:= GetNextAlias()

If Select(cTmp) > 0
	(cTmp)->(dbCloseArea())
EndIf

BeginSQL Alias cTmp
SELECT Z3_DESENT DESCRICAO
FROM %Table:SZ3% SZ3
WHERE Z3_FILIAL = %xFilial:SZ3% 
	AND Z3_CODENT = %Exp:cCCR%
	AND Z3_TIPENT = '9'
	AND SZ3.%NOTDEL%
EndSQL
	
cNomeCCR := (cTmp)->DESCRICAO
	
oModelEnch:SetValue('CNC_XCCRDE',cNomeCCR)

Return cNomeCCR 