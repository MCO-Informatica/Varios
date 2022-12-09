#INCLUDE 'Protheus.ch'
#INCLUDE 'Topconn.ch'
#INCLUDE 'FWMVCDEF.CH' // Obrigatorio esse include para MVC

#DEFINE TYPE_MODEL	1
#DEFINE TYPE_VIEW  	2

Static cAliasT		:= ''

//---------------------------------------------------------------------------------
// Rotina | CSFA742     | Autor | Rafael Beghini              | Data | 05.12.2018
//---------------------------------------------------------------------------------
// Descr. | Movimentação financeira (EEFI)
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
User Function CSFA742()
    Local oBrowse := FwmBrowse():NEW() 
	Private cCadastro := 'Movimentação financeira'
	    
    oBrowse:SetAlias("PBT")
    oBrowse:SetDescription(cCadastro)
    oBrowse:Activate()
	
Return( NIL )

//---------------------------------------------------------------------------------------------
Static Function MenuDef()
	Local aBotao := {}
	aAdd(aBotao,{ "Análise", "VIEWDEF.CSFA742", 0, 2, 0, NIL } )	
Return aBotao

//---------------------------------------------------------------------------------------------
Static Function ModelDef()
    Local oModel    := NIL
    Local oStruCab  := NIL
    Local oStruCre  := NIL
    Local oStruDeb  := NIL
	Local bPost		:= {|| .T. }
	Local bCommit	:= {|| .T. }
    Local bCredito	:= {|oMdl| cAliasT := GetNextAlias(), A742Resumo('C') 		, A742LdGrd(oMdl) }
    Local bDebito	:= {|oMdl| cAliasT := GetNextAlias(), A742Resumo('D') 		, A742LdGrd(oMdl) }

    //-- Cria a primeira estrutura - Resumo Venda
    oStruCab    := FWFormStruct(1,'PBT')

    //-- Cria a segunda estrutura (Grid) Base conciliação
    oStruCre    := A742StrGd(TYPE_MODEL,'C')
    oStruDeb    := A742StrGd(TYPE_MODEL,'D')

	oModel		:= MPFormModel():New( 'MOVFI', /*bPre*/ , bPost, bCommit, /*bCancel*/ )

    //-- Adiciona Objetos Criados à Model
	oModel:AddFields('MdFieldCab',,oStruCab)
	
	//-- Sintaxe:
	//--  :AddGrid(< cId >    , < cOwner > , < oModelStruct >, < bLinePre >, < bLinePost >, < bPre >, < bLinePost >, < bLoad >)
	oModel:AddGrid('MdGridCre','MdFieldCab', oStruCre        ,             ,              ,         ,              , bCredito )
	oModel:AddGrid('MdGridDeb','MdFieldCab', oStruDeb        ,             ,              ,         ,              , bDebito )

    //-- Seta Descrição Para Cada Divisão Da Model
	oModel:GetModel('MdFieldCab' ):SetDescription('STR0004')
	oModel:GetModel('MdGridCre'):SetDescription('STR0005')
	oModel:GetModel('MdGridDeb'):SetDescription('STR0006')
	oModel:SetDescription('Movimento financeiro')
	
	//-- Adiciona Restrições Aos Objetos Da Model
	oModel:GetModel( 'MdGridCre' ):SetNoInsertLine( .T. )
	oModel:GetModel( 'MdGridCre' ):SetNoDeleteLine( .T. )
	oModel:GetModel( 'MdGridCre' ):SetOptional( .T. )

    //-- Adiciona Restrições Aos Objetos Da Model
	oModel:GetModel( 'MdGridDeb' ):SetNoInsertLine( .T. )
	oModel:GetModel( 'MdGridDeb' ):SetNoDeleteLine( .T. )
	oModel:GetModel( 'MdGridDeb' ):SetOptional( .T. )
	
	//-- Seta Chave Primária Da Model
	oModel:SetPrimaryKey({'PBR_FILIAL','PBR_PVMAT','PBR_PV','PBR_RV','PBR_DATA'})  

    oModel:SetRelation('MdGridCre', { {'PBS_FILIAL',"xFilial('PBS')"}, {'PBS_PVMAT','PBR_PVMAT'}, {'PBS_PV','PBR_PV'},;
                                        {'PBS_RV','PBR_RV'}, {'PBS_DATA','PBR_DATA'} }, PBS->(IndexKey(1)) )
    
    oModel:AddCalc( 'FNUCALC', 'MdFieldCab', 'MdGridCre', 'PBS_VALOR' , 'PBS_VALOR' , 'SUM', /*bCondition*/, /*bInitValue*/,'Valor Bruto'      /*cTitle*/, /*bFormula*/)
    oModel:AddCalc( 'FNUCALC', 'MdFieldCab', 'MdGridCre', 'PBS_VLDESC', 'PBS_VLDESC', 'SUM', /*bCondition*/, /*bInitValue*/,'Valor Desconto (taxas)'   /*cTitle*/, /*bFormula*/)
    oModel:AddCalc( 'FNUCALC', 'MdFieldCab', 'MdGridDeb', 'PBT_VALOR' , 'PBT_VALOR' , 'SUM', /*bCondition*/, /*bInitValue*/,'Valor Estorno'    /*cTitle*/, /*bFormula*/)
    oModel:AddCalc( 'FNUCALC', 'MdFieldCab', 'MdGridCre', 'PBS_VALLIQ', 'PBS_VALLIQ', 'SUM', /*bCondition*/, /*bInitValue*/,'Valor Líquido'    /*cTitle*/, /*bFormula*/)
    
	//-- Ativação Da Model
	oModel:SetActivate( )	

Return(oModel)

//-------------------------------------------------------------------
Static Function ViewDef()
    Local oView   	:= NIL		// Recebe o objeto da View
	Local oModel  	:= NIL		// Objeto do Model
	Local oStruCab 	:= NIL   	// Recebe a Estrutura cabecalho
	Local oStruCre 	:= NIL  	// Recebe a Estrutura
	Local oStruDeb 	:= NIL  	// Recebe a Estrutura
	
    oModel  := ModelDef()

    //-- Cria Primeira Estrutura (Field) Na Parte Superior Da Tela
    oStruCab := FWFormStruct(2, 'PBT')

    //-- Cria Segunda Estrutura (Grid) Na Parte inferior Da Tela
	oStruCre := A742StrGd(TYPE_VIEW,'C')
	oStruDeb := A742StrGd(TYPE_VIEW,'D')

	//-- Cria o objeto de View
	oView := FwFormView():New()

    // Cria o objeto de Estrutura
    oCalc1 := FWCalcStruct( oModel:GetModel('FNUCALC') )
    
    //Adiciona no nosso View um controle do tipo FormGrid(antiga newgetdados)
    oView:AddField( 'VIEW_CALC', oCalc1, 'FNUCALC' )

    //-- Define qual o Modelo de dados será utilizado na View
	oView:SetModel(oModel)

    //-- Alteração de propriedades do campo
	oStruCre:SetProperty( '*', MVC_VIEW_CANCHANGE,.F.) //-- Bloqueia Todos Os Campos Da Grid
	oStruDeb:SetProperty( '*', MVC_VIEW_CANCHANGE,.F.) //-- Bloqueia Todos Os Campos Da Grid
	
    //-- Adiciona botões
    oView:AddUserButton( 'Pesquisar (F10)'			,'PESQUISA'	, {	|oView| Pesquisar(oModel) }	, , 121 ) //-- VK_F10
    
    //-- Adiciona Os Objetos Criados à View
	oView:AddField('VwFieldCab', oStruCab , 'MdFieldCab') 
	oView:AddGrid('VwGridCre'  , oStruCre , 'MdGridCre' )
	oView:AddGrid('VwGridDeb'  , oStruDeb , 'MdGridDeb' )
		
	//-- Dimensiona a Tela Da View
	oView:CreateHorizontalBox('CABECALHO' ,48)
	oView:CreateHorizontalBox('GRID'	  ,38)
	oView:CreateHorizontalBox('TOTALIZA'  ,14)

    oView:CreateFolder( 'FOLDER1', 'GRID')
    oView:AddSheet('FOLDER1','SHEET1','Ordem crédito')
    oView:AddSheet('FOLDER1','SHEET2','Ordem débito/Charge/Cancelamento')

    oView:CreateHorizontalBox( 'TELACREDITO', 100, /*owner*/, /*lUsePixel*/, 'FOLDER1', 'SHEET1')
    oView:CreateHorizontalBox( 'TELADEBITO' , 100, /*owner*/, /*lUsePixel*/, 'FOLDER1', 'SHEET2')
    
    oView:CreateVerticalBox( 'TOTAL', 100,'TOTALIZA')
	
    //-- Seta Os Objetos para Cada Dimensão Criada
    oView:SetOwnerView('VwFieldCab' ,'CABECALHO'    )
    oView:SetOwnerView('VwGridCre'  ,'TELACREDITO'  )
    oView:SetOwnerView('VwGridDeb'  ,'TELADEBITO'   )
    oView:SetOwnerView('VIEW_CALC'  ,'TOTAL'        )
    
    oView:EnableTitleView( 'VIEW_CALC', 'Totais' )
    
	//-- Não Permite Abertura Da Tela De "Salvar Dados Do Formulário"
	oView:SetViewAction("ASKONCANCELSHOW",{||.F.})

    //-- Remove campos da Grid
    oStruCab:RemoveField("PBT_TIPO"  )
    oStruCab:RemoveField("PBT_TIPORE")
    oStruCab:RemoveField("PBT_TPAJUS")
    oStruCab:RemoveField("PBT_DESCAJ")
    oStruCab:RemoveField("PBT_CARTAO")
    oStruCab:RemoveField("PBT_NSU"   )
    oStruCab:RemoveField("PBT_CODAUT")
    oStruCab:RemoveField("PBT_TIPODB")
Return(oView)

//--------------------------------------------------------------------------------------------------------
Static Function A742StrGd(nType,cModo)

	Local oStruct   := Nil
	Local nX        := 0
	Local aDadosCpo := {}
	Local aCampos   := {}

	Default nType   := TYPE_MODEL  // 1=Tipo Model / 2= Tipo View
	
	IF cModo == 'C'
        aAdd( aCampos, 'PBS_PSITE'  )
        aAdd( aCampos, 'PBS_CARTAO' )
        aAdd( aCampos, 'PBS_NSU'    )
        aAdd( aCampos, 'PBS_CODAUT' )
        aAdd( aCampos, 'PBS_TID'    )
        aAdd( aCampos, 'PBS_VALOR'  )
        aAdd( aCampos, 'PBS_VLDESC' )
        aAdd( aCampos, 'PBS_VALLIQ' )
        aAdd( aCampos, 'PBS_DTLCTO' )
    Else 
        aAdd( aCampos, 'PBT_CARTAO' )
        aAdd( aCampos, 'PBT_NSU'    )
        aAdd( aCampos, 'PBT_CODAUT' )
        aAdd( aCampos, 'PBT_VALOR'  )
        aAdd( aCampos, 'PBT_DATARV' )
        aAdd( aCampos, 'PBT_TIPORE' )
        aAdd( aCampos, 'PBT_TPAJUS' )
        aAdd( aCampos, 'PBT_DESCAJ' )
    EndIF

	IF nType == TYPE_MODEL
		//-- Executa o Método Construtor Da Classe.
		oStruct := FWFormModelStruct():New()

		//-- Inclui Campos Constantes Na Query Principal ( Somente Campos Existentes No Dicionário ).
		For nX := 1 To Len(aCampos)
			If SubStr(aCampos[nX],1,3) <> 'RECNO'

				aDadosCpo:= TMSX3Cpo( aCampos[nX] )
				If Empty(aDadosCpo) .Or. Len(aDadosCpo) < 6
					ConOut( FunName() + "Erro No Campo: " + aCampos[nX] )
				Else
					oStruct:AddField(aDadosCpo[1],aDadosCpo[2],aCampos[nX],aDadosCpo[6],aDadosCpo[3],aDadosCpo[4])
				EndIf	
			EndIf
		Next nX
	Else
		oStruct := FWFormViewStruct():New()

		For nX := 1 To Len(aCampos)
			If SubStr(aCampos[nX],1,3) <> 'REC'
				
				aDadosCpo:= TMSX3Cpo( aCampos[nX] )
				If Empty(aDadosCpo) .Or. Len(aDadosCpo) < 4
					ConOut( FunName() + " Erro No Campo: " + aCampos[nX] )
				Else
					oStruct:AddField(aCampos[nX],StrZero((nX + 2 ),2),aDadosCpo[1],aDadosCpo[2],{""},aDadosCpo[6],aDadosCpo[5],Nil,Nil,.F.,Nil)					
				EndIf						
			EndIf		
		Next nX
	EndIF

Return(oStruct)

//-------------------------------------------------------------------
/*/{Protheus.doc} A742Resumo
Função Para Execução da Query Que Será Enviada Para o Grid Da Tela Por
Meio da Função FWLoadByAlias
@author Rafael Beghini
@since  Setembro/2019
@version P12
/*/
//-------------------------------------------------------------------
Static Function A742Resumo(cModo)
	Local aArea      := GetArea()
	Local bQuery     := {||}
	Local aStruQry   := {}
	Local nLinha     := 0
    Local cSQL := ''
	Local cTRB := ''

    bQuery := {|| Iif( Select(cAliasT) > 0, (cAliasT)->( dbCloseArea() ), Nil ) ,;
					dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSQL),cAliasT,.F.,.T.) ,;
					dbSelectArea(cAliasT) ,;
					(cAliasT)->( dbGoTop() ) }

    //-- Lista os créditos da ordem    
    IF cModo == 'C'
        cSQL := "SELECT   "
        cSQL += "         PBS.R_E_C_N_O_ AS RECNO, "
        cSQL += "         PBS_PSITE, "
        cSQL += "         PBS_CARTAO, "
        cSQL += "         PBS_NSU, "
        cSQL += "         PBS_CODAUT, "
        cSQL += "         PBS_TID, "
        cSQL += "         PBS_VALOR, "
        cSQL += "         PBS_VLDESC, "
        cSQL += "         PBS_VALLIQ, "
        cSQL += "         PBS_DTLCTO "
        cSQL += "FROM   " + RetSqlName( 'PBS' ) + " PBS "
        cSQL += "WHERE    PBS.D_E_L_E_T_= ' ' "
        cSQL += " AND PBS_FILIAL = '" + FwxFilial("PBS") + "' "
        cSQL += " AND PBS_PV = '" + PBT->PBT_PV + "' "
        cSQL += " AND PBS_RV = '" + PBT->PBT_RV + "' "
        cSQL += " AND PBS_NUMDOC = '" + PBT->PBT_NUMDOC + "' "
    //-- Lista os débitos da ordem    
    Else
        cSQL := "SELECT   "
        cSQL += "         PBT.R_E_C_N_O_ AS RECNO, "
        cSQL += "         PBT_CARTAO, "
        cSQL += "         PBT_NSU, "
        cSQL += "         PBT_CODAUT, "
        cSQL += "         PBT_VALOR, "
        cSQL += "         PBT_DATARV, "
        cSQL += "         PBT_TIPORE, "
        cSQL += "         PBT_TPAJUS, "
        cSQL += "         PBT_DESCAJ "
        cSQL += "FROM   " + RetSqlName( 'PBT' ) + " PBT "
        cSQL += "WHERE    PBT.D_E_L_E_T_= ' ' "
        cSQL += " AND PBT_FILIAL = '" + FwxFilial("PBS") + "' "
        cSQL += " AND PBT_PV = '" + PBT->PBT_PV + "' "
        cSQL += " AND PBT_RV = '" + PBT->PBT_RV + "' "
        cSQL += " AND PBT_TIPO = 'D' "
    EndIF
	
	cSQL := ChangeQuery( cSQL )
	
	FwMsgRun(, {|| Eval(bQuery) }, , 'Aguarde, consultando os dados...')
	
	//-- Formata Campos Da Query
	aStruQry := (cAliasT)->(DbStruct())
	
	For nLinha := 1 To Len(aStruQry)
		DbSelectArea('SX3')
		DbSetOrder(2)
		If MsSeek(aStruQry[nLinha][1],.f.)
		If SX3->X3_TIPO == "D" .Or. SX3->X3_TIPO == "N"
			TCSetField( cAliasT , aStruQry[nLinha][1], SX3->X3_TIPO , SX3->X3_TAMANHO , SX3->X3_DECIMAL )
		Endif
		EndIf
	Next nLinha	

	RestArea(aArea)

Return cAliasT

//-------------------------------------------------------------------
/*/{Protheus.doc} A742Resumo
Função Para Execução da Query Que Será Enviada Para o Grid Da Tela Por
Meio da Função FWLoadByAlias
@author Rafael Beghini
@since  Setembro/2019
@version P12
/*/
//-------------------------------------------------------------------
Static Function A742LdGrd( oMdl )
	Local aRet := {}

	Default oMdl := FwLoadModel('MOVFI')	
		
	// Como tem o campo R_E_C_N_O_, nao é preciso informar qual o campo contem o Recno() real
	FwMsgRun(, {|| aRet := FWLoadByAlias( oMdl , cAliasT , 'PBT' , Nil , Nil , .t. )  }, , 'Aguarde, montando dados...')

	//-- Fecha Arquivo Temporário
	If Select(cAliasT) > 0
		(cAliasT)->(DbCloseArea())
		FErase( cAliasT + GetDBExtension() )
	EndIf	

Return( aRet )

//---------------------------------------------------------------------------------
// Rotina | Pesquisar    | Autor | Rafael Beghini     | Data | 05.12.2018
//---------------------------------------------------------------------------------
// Descr. | Função para pesquisar o conteúdo na GRID
//---------------------------------------------------------------------------------
Static Function Pesquisar(oModel)
	Local cField	:= ''
	Local cOpc1		:= ''
	Local cOpc2		:= ''
	Local aPAR		:= {}
	Local aRET		:= {}
	Local aOPC1		:= {"1.Ordem crédito","2.Ordem débito"}
	Local aOPC2		:= {"1.Pedido Site","2.Num Cartão"}

    aAdd( aPAR, {2,	"Localizar em",	1,	aOPC1,80,"",.F.})
	aAdd( aPAR, {2,	"Opção"	      ,	1,	aOPC2,80,"",.F.})
    aAdd( aPAR, {1, "Conteúdo"    , Space(40), "","",""   ,"",60,.T.})

	IF ParamBox(aPAR,'Pesquisa',@aRET)
		cOpc1 := IIf( ValType( aRET[1] ) == 'C', Subs(aRET[1],1,1), LTrim( Str( aRET[1], 1, 0 ) ) )
		cOpc2 := IIf( ValType( aRET[2] ) == 'C', Subs(aRET[2],1,1), LTrim( Str( aRET[2], 1, 0 ) ) )
		IF cOpc1 == '1'
            IF cOpc2 == '1'
                cField := 'PBS_PSITE'
            Else
                cField := 'PBS_CARTAO'
            EndIF
            oModel:GetModel('MdGridCre'):SeekLine( { { cField, Alltrim( aRET[ 3 ] ) } } )
        Else
            IF cOpc2 == '1'
                MsgAlert('Utilize a opção "2.Num cartão" para realizar a busca.','CSFA742')
            Else
                cField := 'PBT_CARTAO'
                oModel:GetModel('MdGridDeb'):SeekLine( { { cField, Alltrim( aRET[ 3 ] ) } } )
            EndIF
        EndIF
    EndIF
Return