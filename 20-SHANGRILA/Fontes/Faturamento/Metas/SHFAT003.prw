#INCLUDE "PROTHEUS.CH"
#INCLUDE 'FWMVCDEF.CH'

Static aIndSZ6
Static lCopia


User Function SHFAT003()

Local oBrowse	:= Nil
Private cCadastro := 'Cadastro Região'  &&"Meta de Venda"

&&AjustaHlp()

oBrowse := FWMBrowse():New()
oBrowse:SetAlias('SZ7')
oBrowse:SetDescription('Cadastro Região')  &&"Meta de Venda"
oBrowse:Activate()

Return(.T.)


Static Function ModelDef()

Local oModel
Local oStruCab := FWFormStruct(1,'SZ7')
Local oStruGrid := FWFormStruct(1,'SZ8')

Local bActivate     := {|oMdl|SHFT003ACT(oMdl)}
Local bPosValidacao := {||SHFT003Pos()}
Local bCommit		:= {|oMdl|SHFT003Cmt(oMdl)}
Local bCancel   	:= {|oMdl|SHFT003Can(oMdl)}
Local bLinePost 	:= {||SHFTLinOk()}
local aTrigger          := {}

oStruGrid:RemoveField('Z8_CODIGO')
oStruGrid:RemoveField('Z8_UF')

oModel := MPFormModel():New('SHFT003',/*bPreValidacao*/,/*bPosValidacao*/,/*bCommit*/,/*bCancel*/)

oModel:AddFields('SZ7CAB',/*cOwner*/,oStruCab,/*bPreValidacao*/,/*bPosValidacao*/,/*bCarga*/)
oModel:AddGrid( 'SZ8GRID','SZ7CAB',oStruGrid,/*bLinePre*/,bLinePost,/*bPreVal*/,/*bPosVal*/)

oModel:SetRelation("SZ8GRID",{{"Z8_FILIAL",'xFilial("SZ8")'},{"Z8_CODIGO","Z7_CODIGO"},{"Z8_UF","Z7_UF"}},SZ8->(IndexKey(1)))
oModel:SetPrimaryKey({'Z8_FILIAL','Z8_CODIGO'})

oModel:GetModel( 'SZ8GRID' ):SetUniqueLine( { 'Z8_CODMUN','Z8_CODBAIR' } )

oModel:SetActivate(bActivate)
oModel:SetDescription('Cadastro Região')

Return(oModel)

Static Function ViewDef()

Local oView

Local oModel     := FWLoadModel('SHFAT003')
Local oStruCab   := FWFormStruct(2,'SZ7')
Local oStruGrid  := FWFormStruct(2,'SZ8')
Local aCabExcel  := SHFT003Cab()  			&& Cria o cabecalho para utilizacao no Microsoft Excel
Local aUsrBut    := {}     					&& recebe o ponto de entrada
Local aButtons	 := {}                      && botoes da enchoicebar
Local nAuxFor    := 0                       && auxiliar do For , contador da Array aUsrBut
Local oMdlCab    := oModel:GetModel('SZ7CAB')
Local oMdlGrid   := oModel:GetModel('SZ8GRID')
Local aAux       := {}
Local oCalc1

oStruGrid:RemoveField('Z8_CODIGO')
oStruGrid:RemoveField('Z8_UF')


oView:= FWFormView():New()
oView:SetModel(oModel)

oView:AddField('VIEW_CABZ7',oStruCab,'SZ7CAB')
oView:AddGrid('VIEW_GRIDZ8',oStruGrid,'SZ8GRID' )


oView:AddIncrementField('VIEW_GRIDZ8','Z8_SEQUEN')

oView:CreateHorizontalBox('SUPERIOR',20)
oView:CreateHorizontalBox('INFERIOR',80)

REGTOMEMORY("SZ7",.T.)
REGTOMEMORY("SZ8",.T.)

oView:SetOwnerView( 'VIEW_CABZ7','SUPERIOR' )
oView:SetOwnerView( 'VIEW_GRIDZ8','INFERIOR' )



Return(oView)


Static Function MenuDef()
Local aRotina :={}
Local aUsrBut :={}
Local nX := 0

ADD OPTION aRotina TITLE 'Pesqusiar'  ACTION 'PesqBrw' 			OPERATION 1	ACCESS 0
ADD OPTION aRotina TITLE 'Visualizar' ACTION 'VIEWDEF.SHFAT003'	OPERATION 2	ACCESS 0
ADD OPTION aRotina TITLE 'Incluir'    ACTION 'VIEWDEF.SHFAT003'	OPERATION 3	ACCESS 0
ADD OPTION aRotina TITLE 'Alterar'    ACTION 'VIEWDEF.SHFAT003'	OPERATION 4	ACCESS 0
ADD OPTION aRotina TITLE 'Excluir'    ACTION 'VIEWDEF.SHFAT003'	OPERATION 5	ACCESS 0

Return(aRotina)


Static Function SHFT003Act(oMdl)

Local nOperation := oMdl:GetOperation()
Local oMdlGrid := oMdl:GetModel('SZ8GRID')

Local nX := 0
Private oMdlCab	:= oMdl:GetModel('SZ7CAB')

if nOperation == 3
	For nX:= 1 to oMdlGrid:GetQtdLine()
		oMdlGrid:GoLine(nX)
		oMdlGrid:SetValue("Z8_SEQUEN",cValToChar(StrZero(nX,TamSx3("Z8_SEQUEN")[1])),.T.)
	Next nX
	lCopia := .F.
ElseIf nOperation == 4
	REGTOMEMORY("SZ7",.T.)
	REGTOMEMORY("SZ8",.T.)
EndIf

Return(.T.)

Static Function SHFT003CAL( oFW, lPar )
Local lRet := .T.

If lPar
	lRet := .T.
Else
	lRet := .F.
EndIf
Return lRet


Static Function SHFT003Pos()
Local lRet := .T.


Return(lRet)

Static Function SHFT003Cmt(oMdl)
Local nOperation := oMdl:GetOperation()

If nOperation == 3  .Or. nOperation == 5
	FWModelActive(oMdl)
	FWFormCommit(oMdl)
Endif

If nOperation == 4
	FWModelActive(oMdl)
	FWFormCommit(oMdl)
	SHFTGrvDesc(oMdl)
EndIf

Return(.T.)

Static Function SHFT003Can(oMdl)

Local nOperation:= oMdl:GetOperation()

If nOperation == 3
	RollBackSX8()
EndIf

Return(.T.)


Static Function SHFTGrvDesc(oMdl)


Return Nil

Static Function SHFT003Cab()

Local aCabec := {}

dbSelectArea("SX3")
dbSetOrder(2)
dbSeek("Z7_CODIGO")
aadd(aCabec,{OemToAnsi(X3Titulo()),SX3->X3_PICTURE,Nil})
dbSelectArea("SX3")
dbSetOrder(2)
dbSeek("Z7_DESCRIC")
aadd(aCabec,{OemToAnsi(X3Titulo()),SX3->X3_PICTURE,Nil})
dbSelectArea("SX3")
dbSetOrder(2)
dbSeek("Z7_UF")
aadd(aCabec,{OemToAnsi(X3Titulo()),SX3->X3_PICTURE,Nil})

Return(aCabec)

Static Function SHFTLinOk()

Local oMdl		:= FWModelActive()
Local oMdlCab	:= oMdl:GetModel('SZ7CAB')
Local oMdlGrid	:= oMdl:GetModel('SZ8GRID')
Local nPValor	:= 0
Local lRet      := .T.
Local aSaveLines  := FWSaveRows()


FWRestRows( aSaveLines )
Return(lRet)

Static Function SHTrigger(oModel)
Local aTrigger := {}
Local aAux     := {}

aAux := FwStruTrigger(;
'Z8_CODMUN'     ,;
'Z8_DESCMUN'    ,;
'CC2->CC2_MUN'		,;
.T.				,;
'CC2'			,;
1				,;
'xFilial("CC2") + M-Z7_UF  + M->Z8_CODMUN')

AaDd(aTrigger,aAux)

Return aTrigger

User Function SHFTCL003( )

Local oModel := FWModelActive()
Local aArea  := GetArea()
Local aAreaSB1 := SB1->( GetArea() )
local nQuant := 0
Local nValor := 0
Local nValPmv:= 0
Local nTotalPmv := 0
Local nQuantPmv := 0
Local aRetVen   := {}
Local aRetVenQ  := {}
Local aRetDev  	:= {}
Local cCodBair  := ''
Local cDescric   := oModel:GetValue( 'SZ7CAB', 'Z7_DESCRIC' )
Local cCodReg   := oModel:GetValue( 'SZ7CAB', 'Z7_CODREG' )
Local cCodZon   := oModel:GetValue( 'SZ7CAB', 'Z7_CODZONA' )
Local cCodEst   := oModel:GetValue( 'SZ7CAB', 'Z7_UF' )
Local cDescReg  := POSICIONE('SZ9',1,xFilial('SZ9') + cCodReg ,'Z9_DESCRIC')
Local cCodMun   := ''
Local cCodNew   := ''
Local cDescBair := ''
Local cDescMun  := ''
Local lClear    := .F.
Local cEst      := ''
Local lCidade   := SuperGetMv("ZZ_SHCIDAD",,.F.)
Local lBairro   := SuperGetMv("ZZ_SHBAIRR",,.F.)

If ReadVar() $ 'M->Z8_CODMUN'
	CC2->(DbSetOrder(1))
	If CC2->(DbSeek(xFilial('CC2') + cCodEst + M->Z8_CODMUN))
		oModel:LoadValue( 'SZ8GRID', 'Z8_DESCMUN',CC2->CC2_MUN )
	Else
		lClear := .T.
		oModel:ClearField( 'SZ8GRID', 'Z8_DESCMUN' )
		oModel:ClearField( 'SZ8GRID', 'Z8_CODBAIR' )
		oModel:ClearField( 'SZ8GRID', 'Z8_DESCBAI' )
		oModel:ClearField( 'SZ8GRID', 'Z8_DESCMUN' )
		oModel:ClearField( 'SZ8GRID', 'Z8_CODNEW' )
		oModel:ClearField( 'SZ8GRID', 'Z8_DESCNEW' )
	EndIf
EndIf

If cCodEst == 'SP'
	cEst := '01'
ElseIf cCodEst == 'RJ'
	cEst := '02'
ElseIf cCodEst == 'MG'
	cEst := '03'
ElseIf cCodEst == 'ES'
	cEst := '04'
ElseIf cCodEst == 'PR'
	cEst := '05'
ElseIf cCodEst == 'SC'
	cEst := '06'
ElseIf cCodEst == 'RS'
	cEst := '07'
ElseIf cCodEst == 'BA'
	cEst := '08'
ElseIf cCodEst == 'SE'
	cEst := '09'
ElseIf cCodEst == 'AL'
	cEst := '10'
ElseIf cCodEst == 'PE'
	cEst := '11'
ElseIf cCodEst == 'PB'
	cEst := '12'
ElseIf cCodEst == 'RN'
	cEst := '13'
ElseIf cCodEst == 'CE'
	cEst := '14'
ElseIf cCodEst == 'PI'
	cEst := '15'
ElseIf cCodEst == 'MA'
	cEst := '16'
ElseIf cCodEst == 'PA'
	cEst := '17'
ElseIf cCodEst == 'AP'
	cEst := '18'
ElseIf cCodEst == 'AM'
	cEst := '19'
ElseIf cCodEst == 'RR'
	cEst := '20'
ElseIf cCodEst == 'MT'
	cEst := '21'
ElseIf cCodEst == 'MS'
	cEst := '22'
ElseIf cCodEst == 'GO'
	cEst := '23'
ElseIf cCodEst == 'DF'
	cEst := '24'
ElseIf cCodEst == 'TO'
	cEst := '25'
ElseIf cCodEst == 'RO'
	cEst := '26'
ElseIf cCodEst == 'AC'
	cEst := '27'
EndIf

If !lClear
	If !Empty(cDescReg)
		oModel:LoadValue( 'SZ7CAB', 'Z7_DESCREG' ,Alltrim(cDescReg))
	EndIF
	If !Empty(cEst)
		cCodNew := cEst + cCodZon
		oModel:LoadValue( 'SZ8GRID', 'Z8_CODNEW' ,Alltrim(cCodNew))
	EndIF
	If !Empty(cCodReg)
		cCodNew := cEst + cCodZon + cCodReg
		oModel:LoadValue( 'SZ8GRID', 'Z8_CODNEW' ,Alltrim(cCodNew))
	EndIF
	If lCidade
		cCodMun := oModel:GetValue( 'SZ8GRID', 'Z8_CODMUN' )
		If !Empty(cCodMun)
			cCodNew := cEst + cCodZon + cCodReg + cCodMun
			oModel:LoadValue( 'SZ8GRID', 'Z8_CODNEW' ,Alltrim(cCodNew))
		EndIF
		cDescMun  := oModel:GetValue( 'SZ8GRID', 'Z8_DESCMUN')
	EndIF
	If lCidade .And. lBairro
		cCodBair := oModel:GetValue( 'SZ8GRID', 'Z8_CODBAIR' )
		If !Empty(cCodBair)
			cCodNew := cEst + cCodZon + cCodReg + cCodMun + cCodBair
			oModel:LoadValue( 'SZ8GRID', 'Z8_CODNEW' ,Alltrim(cCodNew))
		EndIF
		cDescBair := oModel:GetValue( 'SZ8GRID', 'Z8_DESCBAI')
	EndIF
	
	oModel:LoadValue( 'SZ8GRID', 'Z8_DESCNEW' ,Alltrim(cDescric) + If(!Empty(cDescReg),' - ' + Alltrim(cDescReg), '') + If(!Empty(cDescMun),' - ' + Alltrim(cDescMun),'') + If(!Empty(cDescBair),' - ' + Alltrim(cDescBair),''))
EndIf
SHFTLinOk()

RestArea(aAreaSB1)
RestArea(aArea)

Return .T.

