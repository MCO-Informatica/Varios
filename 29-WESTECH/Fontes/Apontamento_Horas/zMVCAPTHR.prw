#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

Static cTitulo := "Apontamento de Horas"
 
User Function zMVCAPTHR()
    Local aArea   := GetArea()
    Local oBrowse
     
    //Instânciando FWMBrowse - Somente com dicionário de dados
    oBrowse := FWMBrowse():New()
     
    //Setando a descrição da rotina
    oBrowse:SetAlias("SZ4")
    //oBrowse:SetFilterDefault( "SUBSTR(CTD_ITEM,9,2) >= '15' .AND. CTD_ITEM<>'ADMINISTRACAO' .AND. CTD_ITEM <> 'PROPOSTA' .AND. CTD_ITEM <> 'QUALIDADE' .AND. CTD_ITEM <> 'ATIVO' .AND. CTD_ITEM <> 'ENGENHARIA' .AND. CTD_ITEM <> 'ZZZZZZZZZZZZZ' .AND. CTD_ITEM <> 'XXXXXX'  "  ) //.AND. CTD_DTEXSF = '' .OR. CTD_DTEXSF >= dDatabase
    DbSetOrder(1)
    
    //Setando a descrição da rotina
    oBrowse:SetDescription(cTitulo)
    
    //oBrowse:AddLegend( "CTD->CTD_DTEXSF < Date()", "GRAY", "Fechado" )
    //oBrowse:AddLegend( "CTD->CTD_DTEXSF >= Date()", "GREEN",   "Aberto" )
  
    //Ativa a Browse
    oBrowse:Activate()
     
    RestArea(aArea)
Return Nil
 
/////////////////////////////////////////////////////////////////////////////
 
Static Function MenuDef()
    Local aRot := {}
     
    //Adicionando opções
    ADD OPTION aRot TITLE 'Visualizar' ACTION 'VIEWDEF.zMVCAPTHR' OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 1
    //ADD OPTION aRot TITLE 'Legenda'    ACTION 'MPFormModel'     OPERATION 6                      ACCESS 0 //OPERATION X
    ADD OPTION aRot TITLE 'Incluir'    ACTION 'VIEWDEF.zMVCAPTHR' OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
    ADD OPTION aRot TITLE 'Alterar'    ACTION 'VIEWDEF.zMVCAPTHR' OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4
    ADD OPTION aRot TITLE 'Excluir'    ACTION 'VIEWDEF.zMVCAPTHR' OPERATION MODEL_OPERATION_DELETE ACCESS 0 //OPERATION 5
 
Return aRot
 
//////////////////////////////////////////////////////////////////////////////
 
Static Function ModelDef()
    Local oModel        := Nil
    Local oStPai        := FWFormStruct(1, 'SZ4')
    Local oStFilho1  	:= FWFormStruct(1, 'SZ4')
    
    
    Local aSZZRel       := {}
           
    //Criando o modelo e os relacionamentos
     //oModel := MPFormModel():New('zMVCMdXM',  , { |oMdl| COMP011POS( oMdl ) })
     oModel := MPFormModel():New('zMVCAPTHR2', { |oMdl| COMP021BUT( oMdl ) } , { |oMdl| COMP011POS( oMdl ) })
    	
       
    oModel:AddFields('CTDMASTER',/*cOwner*/,oStPai)
    
 
	oModel:AddGrid('SZ4DETAIL','CTDMASTER',oStFilho1,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)  //cOwner é para quem pertence
	oModel:SetRelation('SZ4DETAIL', { { 'Z4_IDAPTHR', 'Z4_IDAPTHR' } }, SZ4->(IndexKey(1)) )

    aAdd(aSZZRel, {'Z4_FILIAL', 'Z4_FILIAL'} )
    aAdd(aSZZRel, {'Z4_IDAPTHR',  'Z4_IDAPTHR'})
    
    oModel:GetModel('SZ4DETAIL'):SetOptional( .T. )
       
  
    //Setando as descrições
    oModel:SetDescription("Apontamento de Horas")
    oModel:GetModel('CTDMASTER'):SetDescription('Colaborador')
    oModel:GetModel('SZ4DETAIL'):SetDescription('Destalhes')
   

Return oModel

Static Function COMP011POS( oModel )
	//Local nOperation 	:= oModel:GetOperation() 

	
		
		 //Help( ,, 'Help',, 'Registro salvo com sucesso.', 2, 0 ) 
Return lRet


/*---------------------------------------------------------------------*
 | Func:  ViewDef                                                      |
 | Autor: Daniel Atilio                                                |
 | Data:  17/08/2015                                                   |
 | Desc:  Criação da visão MVC                                         |
 | Obs.:  /                                                            |
 *---------------------------------------------------------------------*/
 
Static Function ViewDef()
    Local oView     := Nil
    Local oModel        := FWLoadModel('zMVCAPTHR')
    Local oStPai        := FWFormStruct(2, 'SZ4')
   
    Local oStFilho1  	:= FWFormStruct(2, 'SZ4')
    
    //Local oStTot        := FWCalcStruct(oModel:GetModel('TOT_SALDO'))
    //Estruturas das tabelas e campos a serem considerados
    Local aStruSZ4  := SZ4->(DbStruct())
    Local aStruSZ4B  := SZ4->(DbStruct())
   
    Local cConsSZ4  := "Z4_IDAPTHR;Z4_IDCOLAB;Z4_COLAB;;Z4_DATA"
    Local cConsSZ4B  := "Z4_ITEM"
  
    Local nAtual        := 0
     
     
     
    //Criando a View
    oView := FWFormView():New()
    oView:SetModel(oModel)
      
    //Adicionando os campos do cabeçalho e o grid dos filhos
     
    
    oView:AddField('VIEW_SZ4',oStPai,'CTDMASTER')
    oView:AddGrid('VIEW_SZ4B',oStFilho1,'SZ4DETAIL')

    //Setando o dimensionamento de tamanho
     
    oView:CreateFolder( 'FOLDER1')
    
   	oView:AddSheet('FOLDER1','SHEET1','Apontamento horas ')
  
   
   	//oView:AddSheet('FOLDER1','SHEET13','Faturamento / Recebimento Realizado')
	
	oView:CreateHorizontalBox('CABEC',30, /*owner*/, /*lUsePixel*/, 'FOLDER1', 'SHEET1')	// Detalhes Contrato - Resumo	
	oView:CreateVerticalBox('GRID1',70, 'GRID11', /*lUsePixel*/, 'FOLDER1', 'SHEET1')	// Outros Custos Planejado
	
	
    //Amarrando a view com as box
        
    oView:SetOwnerView('VIEW_SZ4','CABEC')
    oView:SetOwnerView('VIEW_SZ4B','GRID1')
    
	//oView:EnableTitleView('formCalcSD2' , 'Total' )
	//oView:EnableTitleView('formCalcSZQ' , 'Total' )
	
	oView:AddIncrementField('VIEW_SZ4B' , 'Z4_ITEM' ) 
	
		
	oView:SetViewProperty('VIEW_SZ4' , 'ONLYVIEW' )
	
	
    //Habilitando título
    //oView:EnableTitleView('VIEW_SZ4','Cola')
   
  
    //Percorrendo a estrutura da CTD
    For nAtual := 1 To Len(aStruSZ4)
        //Se o campo atual não estiver nos que forem considerados
        If ! Alltrim(aStruSZ4[nAtual][01]) $ cConsSZ4
            oStPai:RemoveField(aStruSZ4[nAtual][01])
        EndIf
    Next
    
        //Percorrendo a estrutura da SZZ
    For nAtual := 1 To Len(aStruSZ4B)
        //Se o campo atual não estiver nos que forem considerados
        If ! Alltrim(aStruSZ4[nAtual][01]) $ cConsSZ4
            oStFilho1:RemoveField(aStruSZ4B[nAtual][01])
        EndIf
    Next
    
   
	
Return oView
//-------------------------------------------------------------------

Static Function COMP021BUT( oModel )

/*
	Local lRet 			:= .T.
	Local nLen			:= 0
	Local nI			:= 0
	Local nI2			:= 0
	Local oModelSZZ   	:= oModel:GetModel( 'SZZDETAIL' )
	Local nITEMCTA		:= oModel:GetValue( 'CTDMASTER', 'CTD_ITEM' )
	Local cDescPla 	:= ""
	Local cDescRev 	:= ""
	Local cDescRea 	:= ""
	Local cDescSal 	:= ""
	Local cItemIC1	:= ""
	Local cItemIC2	:= ""
	Local cItemIC3	:= ""
	Local cItemIC4	:= ""
	
	
	nLen := 0
	
	nLen 	:= oModelSZZ:Length(.T.) 
	cItemIC1 := Alltrim(oModel:GetValue( 'SZZDETAIL', 'ZZ_ITEMIC' ))
	
	//if nLen = 1  
	
		oModelSZZ:GoLine( 1 )
		
		//cItemIC1 := Alltrim(oModel:GetValue( 'SZZDETAIL', 'ZZ_ITEMIC' ))
		//if Empty(cItemIC1) 
			oModelSZZ:SetValue('ZZ_ITEMIC', nITEMCTA )
		//endif
	//endif 	
	

	
	if 	nLen < 2 	
		oModelSZZ:AddLine()
		nLen 	:= oModelSZZ:Length(.T.) 
		
		oModelSZZ:GoLine( nLen )
		
		cItemIC2 := Alltrim(oModel:GetValue( 'SZZDETAIL', 'ZZ_ITEMIC' ))
		if Empty(cItemIC2) 	
			oModelSZZ:SetValue('ZZ_ITEMIC', nITEMCTA )
		endif
	endif	
	
	if 	nLen < 3 
		oModelSZZ:AddLine()
		nLen 	:= oModelSZZ:Length(.T.) 
		oModelSZZ:GoLine( nLen )
		if  Empty(cItemIC3) 
			oModelSZZ:SetValue('ZZ_ITEMIC', nITEMCTA )
		endif
		
	endif	
	

	if 	nLen < 4 
		oModelSZZ:AddLine()
		nLen 	:= oModelSZZ:Length(.T.) 
		oModelSZZ:GoLine( nLen )
		
		cItemIC4 := Alltrim(oModel:GetValue( 'SZZDETAIL', 'ZZ_ITEMIC' ))
		if Empty(cItemIC4)  
			oModelSZZ:SetValue('ZZ_ITEMIC', nITEMCTA )
		endif
	endif	
	
	
	oModelSZZ:GoLine( 1)
	cDescPla 	:= Alltrim(oModel:GetValue( 'SZZDETAIL', 'ZZ_DESCRI' ))
	IF cDescPla <> 'PLANEJADO'
		oModelSZZ:SetValue('ZZ_DESCRI', "PLANEJADO" )
	ENDIF
	
	
	
	oModelSZZ:GoLine( 2)
	cDescRev 	:= Alltrim(oModel:GetValue( 'SZZDETAIL', 'ZZ_DESCRI' ))
	IF cDescRev <> 'REVISADO'
		oModelSZZ:SetValue('ZZ_DESCRI', "REVISADO" )
	ENDIF
	
	
	
	oModelSZZ:GoLine( 3)
	cDescRea 	:= Alltrim(oModel:GetValue( 'SZZDETAIL', 'ZZ_DESCRI' ))
	IF cDescRea <> 'REALIZADO'
		oModelSZZ:SetValue('ZZ_DESCRI', "REALIZADO" )
	ENDIF
	
	
	
	oModelSZZ:GoLine( 4)
	cDescSal 	:= Alltrim(oModel:GetValue( 'SZZDETAIL', 'ZZ_DESCRI' ))
	IF cDescSal <> 'SALDO'
		oModelSZZ:SetValue('ZZ_DESCRI', "SALDO" )
	ENDIF
	*/	
	
		
Return lRet