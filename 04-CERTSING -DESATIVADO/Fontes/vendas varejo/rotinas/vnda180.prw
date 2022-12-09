#INCLUDE "rwmake.ch"
#INCLUDE "Protheus.ch"
#INCLUDE "FWMVCDEF.CH"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVNDA180 บAutor  ณMicrosiga           บ Data ณ  11/08/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFonte criado para implementar a geracao de voucher por fluxoบฑฑ
ฑฑบ          ณou seja, para um fluxo conter varios vouchers.              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Opvs x Certisign                                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function VNDA180()

Local oBrowse	:= FWMBrowse():New()

oBrowse:SetAlias("SZF")
oBrowse:SetDescription('Gera Banco')

oBrowse:Activate()                                      	

Return NIL

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณModelDef   บ Autor ณ                   บ Data ณ  10/10/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Modelo de dados para Gera็ใo de Banco de Voucher           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Opvs / Certisign                                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function ModelDef()
Local oStruCab := FWFormStruct(1,"SZF")
//Local oStruItem := FWFormStruct(1,"SZF")
Local oModel

//oStruItem:SetProperty( '*' , MODEL_FIELD_INIT,{|| Nil})
//oStruCab:AddField("Qtd Vouchers","Quantidade de Vouchers","ZF_QBANCO","N",8,0,,,,.T.,,,,.T.)

oModel:= MPFormModel():New('GerBanco', {|| .T. }, ;
                                       { |oModel| GerBanTOK( oModel ) }, ;
                                       { |oModel| A180Commit( oModel ) } )

oModel:AddFields('SZFMASTER',/*owner*/,oStruCab)
//oModel:AddGrid('SZFDETAIL','SZFMASTER',oStruItem)

//oModel:GetModel('SZFMASTER'):SetOnlyQuery(.T.)
//oModel:GetModel('SZFDETAIL'):SetMaxLine(999999)

// Faz relacionamento entre os componentes do model
//oModel:SetRelation( 'SZFDETAIL', { { 'SZF_FILIAL', 'xFilial( "SZF" )' }, { 'ZF_CODFLU', 'ZF_CODFLU' } }, SZF->( IndexKey( 1 ) ) )

oModel:SetDescription('Cadastro de Banco de Voucher')
oModel:GetModel('SZFMASTER'):SetDescription('Cadastro de Banco de Voucher')
//oModel:GetModel('SZFDETAIL'):SetDescription( 'Vouchers do Banco' )
oModel:SetPrimaryKey( { "ZF_FILIAL", "ZF_COD" } )

Return oModel

/*
*******************************************************************************
** Rotina    : A180Commit.
** Autor     : Robson Luiz - Rleg.
** Data      : 26.09.2013
** Descri็ใo : Rotina auxiliar para contemplar o retorno da MPFormModel.
** Uso       : Certisign Certificadora Digital S.A.
*******************************************************************************
*/
Static Function A180Commit( oModel )
	Local lRet := .T.
	FWMsgRun(, {|oSay| lRet := GerBanGRV( oModel, oSay ) }, , 'Aguarde, gerando voucher ')
Return( lRet )

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณViewDef   บ Autor ณ                   บ Data ณ  10/10/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Interface para Gera็ใo de Banco de Vouchers                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Opvs / Certisign                                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function ViewDef()
Local oModel := FWLoadModel('VNDA180')
//Local oCab := oModel:GetModel('SZFMASTER')
//Local oGrid := oModel:GetModel('SZFDETAIL')

Local oStruCab := FWFormStruct(2,"SZF")
//Local oStruItem := FWFormStruct(2,"SZF")
Local oView

//oStruItem:RemoveField("ZF_QTDFLUX")
//oStruItem:SetProperty( '*' , MVC_VIEW_CANCHANGE,.F.)

oView:= FWFormView():New()
oView:SetModel(oModel)
oView:SetCloseOnOk({|| .T. })
oView:AddField( 'VIEW_CAB', oStruCab, 'SZFMASTER' )
//oView:AddGrid( 'VIEW_ITEM', oStruItem, 'SZFDETAIL' )
//oView:AddUserButton( 'Gerar', 'DBG06', {|oView| Gerar(@oGrid,oCab,@oView),oGrid:Goline(1)} )

oView:CreateHorizontalBox( 'SUPERIOR', 100 )
//oView:CreateHorizontalBox( 'INFERIOR', 50 )

oView:SetOwnerView( 'VIEW_CAB', 'SUPERIOR' )
//oView:SetOwnerView( 'VIEW_ITEM', 'INFERIOR' )

Return oView

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMenuDef   บ Autor ณ                   บ Data ณ  10/10/11    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Menu para o Gera็ใo de Banco de Vouchers                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Opvs / Certisign                                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function MenuDef()

Local aRotina := {}

ADD OPTION aRotina Title 'Incluir' Action 'VIEWDEF.VNDA180' OPERATION 3 ACCESS 0

Return aRotina

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGerBanGRV   บ Autor ณ                   บ Data ณ  10/10/11  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Realiza a grava็ใo do modelo no banco.                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Opvs / Certisign                                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function GerBanGRV(oModel,oSay)

Local nQtd 		:= oModel:GetValue("SZFMASTER","ZF_QTDFLUX")
Local count 	:= 1
Local nOperation := oModel:GetOperation()
Local cNumFlu 	:= oModel:GetValue("SZFMASTER","ZF_CODFLU")
Local oModAux
Local oStruct	
Local aAux		:= {} 
Local oAux
Local nI		:= 0
Local cCpoSZF	:= "" 
Local lRet		:= .T.
Local cQtd := LTrim(Str(nQtd))

For Count :=1 to nQtd
	oSay:cCaption := ('Aguarde, gerando voucher ' + LTrim(Str(Count))+'/'+cQtd)
	ProcessMessages()
	
	If count > 1
		oModAux := FWLoadModel('VNDA060') 
		oModAux:DeActivate()
		oModAux:SetOperation( 3 )         
		oModAux:Activate()
		
		oAux := oModAux:GetModel( "SZFMASTER" )
		
		oStruct := oAux:GetStruct()
		aAux 	:= oStruct:GetFields()
		
		oModAux:LoadValue("SZFMASTER","ZF_CODFLU", cNumFlu) 

		For nI := 1 to Len(aAux)
			cCpoSZF := Alltrim(aAux[nI,3])
			If  "ZF_COD" <> cCpoSZF .and. "ZF_CODFLU" <> cCpoSZF
				If !oModAux:SetValue("SZFMASTER",cCpoSZF,oModel:GetValue("SZFMASTER",cCpoSZF) )
					lRet := .F.
					Exit
				EndIf
			EndIf	
		Next

		If oModAux:VldData()  
			oModAux:CommitData()
		Else
			lRet := .F.
		EndIf

		If !lRet		
			aErro := oModAux:GetErrorMessage()
			// A estrutura do vetor com erro ้:
			// [1] identificador (ID) do formulแrio de origem
			// [2] identificador (ID) do campo de origem
			// [3] identificador (ID) do formulแrio de erro
			// [4] identificador (ID) do campo de erro
			// [5] identificador (ID) do erro
			// [6] mensagem do erro
			// [7] mensagem da solu็ใo
			// [8] Valor atribuํdo
			// [9] Valor anterior
			
			AutoGrLog( "Id do formulแrio de origem:" + ' [' + AllToChar( aErro[1] ) + ']' )
			AutoGrLog( "Id do campo de origem: " + ' [' + AllToChar( aErro[2] ) + ']' )
			AutoGrLog( "Id do formulแrio de erro: " + ' [' + AllToChar( aErro[3] ) + ']' )
			AutoGrLog( "Id do campo de erro: " + ' [' + AllToChar( aErro[4] ) + ']' )
			AutoGrLog( "Id do erro: " + ' [' + AllToChar( aErro[5] ) + ']' )
			AutoGrLog( "Mensagem do erro: " + ' [' + AllToChar( aErro[6] ) + ']' )
			AutoGrLog( "Mensagem da solu็ใo: " + ' [' + AllToChar( aErro[7] ) + ']' )
			AutoGrLog( "Valor atribuํdo: " + ' [' + AllToChar( aErro[8] ) + ']' )
			AutoGrLog( "Valor anterior: " + ' [' + AllToChar( aErro[9] ) + ']' )
			MostraErro()
			Exit
	    EndIf  
		oModAux:DeActivate()
	Else
		FWFormCommit(oModel)
	EndIf
	SZF->(CONFIRMSX8())
Next

If lRet
	If nOperation == MODEL_OPERATION_INSERT .OR. nOperation == MODEL_OPERATION_UPDATE
		IF MSgYesNo("Exportar o fluxo de voucher para Ms-Excel?", "Exporta็ใo de dados")
			U_VNDA470(cNumFlu)
		Endif
	Endif
EndIf

Return(lRet)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGerBanTOK   บ Autor ณ                   บ Data ณ  10/10/11  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Realiza p๓s-valida็ใo, comparando o cabe็alho com os       บฑฑ
ฑฑบ          ณ Vouchers gerados.                                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Opvs / Certisign                                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function GerBanTOK(oModel)
Local lRet 		:= .T.
Local cPedido	:= oModel:GetValue("SZFMASTER","ZF_PEDIDOV") 
Local cProd		:= oModel:GetValue("SZFMASTER","ZF_PRODEST")  
Local nQtd 		:= oModel:GetValue("SZFMASTER","ZF_QTDFLUX")
Local cMV_QMAXVOU := 'MV_QMAXVOU'
Local nMV_QMAXVOU := 0

If .NOT. ExisteSX6( cMV_QMAXVOU )
	CriarSX6(cMV_QMAXVOU,'N','QUANTIDADE MAXIMA POR LOTE PARA GERAR VOUCHER - VNDA180.PRW','200')
Endif

nMV_QMAXVOU := GetMv( cMV_QMAXVOU )

If nQtd <= nMV_QMAXVOU
	If !Empty(cPedido)
		SG1->(DbSetOrder(1)) //G1_FILIAL+G1_COD+G1_COMP+G1_TRT
		SC5->(DbSetOrder(1)) //C5_FILIAL+C5_NUM
		SC6->(DbSetOrder(2)) //C6_FILIAL+C6_PRODUTO+C6_NUM+C6_ITEM   

		If SC5->(DbSeek(xFilial("SC5")+cPedido)) 
			If SG1->(DbSeek(xFilial("SG1")+cProd))
				While !SG1->(EoF()) .and. SG1->(G1_FILIAL+G1_COD) == xFilial("SG1")+cProd

					If SC6->(DbSeek(xFilial("SC6")+SG1->G1_COMP+cPedido))
						If nQtd <> SC6->C6_QTDVEN .AND. !SC5->C5_XORIGPV $ "1,4,5,6"
							Help( , , 'GerBanTOK', , "Quantidade informada no Pedido diferente da Quantidade do Fluxo considerando Kit. Por favor, verifique os produtos da estrutura junto ao Pedido.", 1, 0)
							 lRet := .F.
						EndIf
					ElseIf SC5->C5_EMISSAO > StoD('20130410')
						Help( , , 'GerBanTOK', , "Nใo foi Encontrado Pedido+Produto informado no Voucher considerando Kit. Por favor, verifique os produtos da estrutura junto ao Pedido.", 1, 0)
						 lRet := .F.
					EndIf
					SG1->(DbSkip())		 	
				EndDo
			 Else	     
				 If SC6->(DbSeek(xFilial("SC6")+cProd+cPedido))
					If nQtd <> SC6->C6_QTDVEN .AND. !SC5->C5_XORIGPV $ "1,4,5,6"
						Help( , , 'GerBanTOK', , "Quantidade informada no Pedido diferente da Quantidade do Fluxo", 1, 0)
						 lRet := .F.
					EndIf
				 Else
					Help( , , 'GerBanTOK', , "Nใo foi Encontrado Pedido+Produto informado no Voucher. Por favor, verifique", 1, 0)
					 lRet := .F.
				 EndIf
			EndIf
		Else
			Help( , , 'GerBanTOK', , "Nใo foi Encontrado Pedido informado no Voucher. Por favor, verifique", 1, 0)
			 lRet := .F.		
		EndIf
	EndIf
Else
	lRet := .F.
	Help( , , 'GerBanTOK', , 'A quantidade de Voucher informado deve ser menor ou igual a ' + LTrim( Str( nMV_QMAXVOU ) )+'.', 1, 0)
Endif

Return lRet