#Include "Totvs.ch"
#Include "FwMvcDef.ch"

Static cTitulo := "Configuração do PipeDrive"

//+-------------+---------+-------+-----------------------+------+-------------+
//|Programa:    |CSFATA02 |Autor: |David Alves dos Santos |Data: |24/05/2019   |
//|-------------+---------+-------+-----------------------+------+-------------|
//|Descricao:   |Rotina de cadastro de ciclos.                                 |
//|-------------+--------------------------------------------------------------|
//|Nomenclatura |CS   = Certisign.                                             |
//|do codigo    |FAT  = Modulo faturamento SIGAFAT.                            |
//|fonte.       |A    = Atualizações.                                          |
//|             |01   = Numero sequencial.                                     |
//|-------------+--------------------------------------------------------------|
//|Uso:         |Certisign - Certificadora Digital.                            |
//+-------------+--------------------------------------------------------------+
User Function CSFATA02()
	
	Local aArea := GetArea()
    
    Private oBrowse 
    Private aRotina := MenuDef()
    
    //-> Instânciando FWMBrowse - Somente com dicionário de dados
    oBrowse := FWMBrowse():New()
     
    //-> Setando a tabela de cadastro de Ciclo/ Itens de Ciclo.
    oBrowse:SetAlias("PBW")
 
    //-> Setando a descrição da rotina
    oBrowse:SetDescription( cTitulo )
     
    //-> Legendas
    //oBrowse:AddLegend( "PBW->PBW_STATUS == '1'" ,"GREEN" ,"Ativo" )
    //oBrowse:AddLegend( "PBW->PBW_STATUS == '0'" ,"RED"   ,"Inativo" )    
         
    //-> Ativa a Browse
    oBrowse:Activate()
    
    oBrowse:DeActivate()
	oBrowse:Destroy() 
    
    RestArea(aArea)
	
Return( Nil )


//+-------------+---------+-------+-----------------------+------+-------------+
//|Programa:    |MenuDef  |Autor: |David Alves dos Santos |Data: |02/04/2018   |
//|-------------+---------+-------+-----------------------+------+-------------|
//|Descricao:   |Função para Menu do Browse.                                   |
//|-------------+--------------------------------------------------------------|
//|Uso:         |Certisign - Certificadora Digital.                            |
//+-------------+--------------------------------------------------------------+
Static Function MenuDef()
	
	Local aRotina :=	{}
	
	//-> Opções do menu.
	ADD OPTION aRotina TITLE 'Pesquisar'  ACTION 'PesqBrw'       	OPERATION 1 ACCESS 0
	ADD OPTION aRotina TITLE 'Visualizar' ACTION 'VIEWDEF.CSFATA02'	OPERATION 2 ACCESS 0
	ADD OPTION aRotina TITLE 'Incluir'    ACTION 'VIEWDEF.CSFATA02' OPERATION 3 ACCESS 0
	ADD OPTION aRotina TITLE 'Alterar'    ACTION 'VIEWDEF.CSFATA02' OPERATION 4 ACCESS 0
	ADD OPTION aRotina TITLE 'Excluir'    ACTION 'VIEWDEF.CSFATA02' OPERATION 5 ACCESS 0
	
Return( aRotina )


//+-------------+---------+-------+-----------------------+------+-------------+
//|Programa:    |ModelDef |Autor: |David Alves dos Santos |Data: |02/04/2018   |
//|-------------+---------+-------+-----------------------+------+-------------|
//|Descricao:   |Função de Model de Dados, onde é definido a estrutura         |
//|             |de dados Regra de Negocio.                                    |
//|-------------+--------------------------------------------------------------|
//|Uso:         |Certisign - Certificadora Digital.                            |
//+-------------+--------------------------------------------------------------+
Static Function ModelDef()

	Local oModel	:= Nil
    Local oStPai	:= FWFormStruct(1, 'PBW')
    Local oStFilho	:= FWFormStruct(1, 'PBX')
    Local aZ17Rel	:= {}
    Local bPost		:= {|| CSFT02POST() }
    Local bCommit	:= {|| CSFT02GRV() }

    oModel := MPFormModel():New("zMVCMd3", , bPost, bCommit, )
    
    oModel:AddFields('PBWMASTER',/*cOwner*/,oStPai)
    oModel:AddGrid('PBXDETAIL','PBWMASTER',oStFilho,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)  //cOwner é para quem pertence
    
	oModel:SetDescription('Descrição')
	 
    //-> Fazendo o relacionamento entre o Pai e Filho
    aAdd(aZ17Rel, {'PBX_FILIAL',    'PBW_FILIAL'} )
    aAdd(aZ17Rel, {'PBX_COD',    'PBW_COD'})
     
    oModel:SetRelation('PBXDETAIL', aZ17Rel, PBX->(IndexKey(1))) //IndexKey -> quero a ordenação e depois filtrado
    oModel:GetModel('PBXDETAIL'):SetUniqueLine({"PBX_FILIAL","PBX_COD","PBX_ITEM"})    //Não repetir informações ou combinações {"CAMPO1","CAMPO2","CAMPOX"}
    oModel:SetPrimaryKey({})
    
    //-> Setando para utilizar aCOLS
    oModel:GetModel('PBXDETAIL'):lUseCols := .T. 

    //-> Setando as descrições
    oModel:SetDescription(cTitulo)
    oModel:GetModel('PBWMASTER'):SetDescription('Modelo Descrição')
    oModel:GetModel('PBXDETAIL'):SetDescription('Modelo Transferências')
    
Return( oModel )


//+-------------+---------+-------+-----------------------+------+-------------+
//|Programa:    |ViewDef  |Autor: |David Alves dos Santos |Data: |02/04/2018   |
//|-------------+---------+-------+-----------------------+------+-------------|
//|Descricao:   |Função de visualização, onde é definido a visualização        |
//|             |da Regra de Negocio.                                          |
//|-------------+--------------------------------------------------------------|
//|Uso:         |Certisign - Certificadora Digital.                            |
//+-------------+--------------------------------------------------------------+
Static Function ViewDef()
	
	Local oView    := Nil
    Local oModel   := FWLoadModel('CSFATA02')
    Local oStPai   := FWFormStruct(2, 'PBW')
    Local oStFilho := FWFormStruct(2, 'PBX')
     
    //-> Criando a View
    oView := FWFormView():New()
    oView:SetModel(oModel)
     
    //-> Adicionando os campos do cabeçalho e o grid dos filhos
    oView:AddField('VIEW_PBW',oStPai,'PBWMASTER')
    oView:AddGrid('VIEW_PBX',oStFilho,'PBXDETAIL')
     
    //-> Setando o dimensionamento de tamanho
    oView:CreateHorizontalBox('CABEC',50)
    oView:CreateHorizontalBox('GRID',50)
     
    //-> Amarrando a view com as box
    oView:SetOwnerView('VIEW_PBW','CABEC')
    oView:SetOwnerView('VIEW_PBX','GRID')
     
    //-> Habilitando título
    oView:EnableTitleView('VIEW_PBW','Pipeline')
    oView:EnableTitleView('VIEW_PBX','Estagios')
    
    //-> Copia a linha do GRID
    oView:SetViewProperty( 'VIEW_PBX', "ENABLEDCOPYLINE",  {VK_F12} )
    
    //-> Campos incrementais
    oView:AddIncrementField('VIEW_PBX','PBX_ITEM')

    //-> Remove campos da GRID
    oStFilho:RemoveField("PBX_FILIAL")
    oStFilho:RemoveField("PBX_CDCICL")

Return( oView ) 


//+-------------+-----------+-------+-----------------------+------+-----------+
//|Programa:    |CSFT02POST |Autor: |David Alves dos Santos |Data: |10/04/2018 |
//|-------------+-----------+-------+-----------------------+------+-----------|
//|Descricao:   |Função chamada na validação do botão confirmar.               |
//|-------------+--------------------------------------------------------------|
//|Uso:         |Certisign - Certificadora Digital.                            |
//+-------------+--------------------------------------------------------------+
Static Function CSFT02POST()
	
	Local aArea     := GetArea() 
	Local oModelDad := FWModelActive()
	//Local cStatus   := oModelDad:GetValue('PBWMASTER', 'PBW_STATUS')
	Local lRet      := .T.
	
	//lRet := U_CSFTA02A()
		
	RestArea(aArea)
	
Return( lRet )


//+-------------+-----------+-------+-----------------------+------+-----------+
//|Programa:    |CSFT02GRV  |Autor: |David Alves dos Santos |Data: |10/04/2018 |
//|-------------+-----------+-------+-----------------------+------+-----------|
//|Descricao:   |Função chamada na validação do botão confirmar.               |
//|-------------+--------------------------------------------------------------|
//|Uso:         |Certisign - Certificadora Digital.                            |
//+-------------+--------------------------------------------------------------+
Static Function CSFT02GRV()

	Local aArea      := GetArea()
    Local lRet       := .T.
    Local oModelDad  := FWModelActive()
    Local cCodigo    := oModelDad:GetValue('PBWMASTER', 'PBW_COD')
    Local nOpc       := oModelDad:GetOperation()
    Local oModelGrid := oModelDad:GetModel('PBXDETAIL')
    Local aHeadAux   := oModelGrid:aHeader
    Local aCOLSAux   := oModelGrid:aCols
    Local nAtual     := 0
    Local lSeek      := .F.
    Local aTRF		 := {}
    Local aERROR	 := {}
    Local nLin		 := 0
    Local nPOS		 := 0
    Local nVlr		 := 0
    Local cTRB       := ''
    Local cSQL	     := ''
    Local cMSG1	     := ''
    Local cMSG2	     := ''
    Local isDeleted  := .F.
    
    //-> Se for Inclusão.
    If nOpc == 3
        
        //-> Cria o registro na tabela PBW (Cabeçalho).
        RecLock('PBW', .T.)
            PBW->PBW_FILIAL := xFilial('PBW')
			PBW->PBW_COD    := oModelDad:GetValue( 'PBWMASTER' ,'PBW_COD'    )
			PBW->PBW_CODPPL := oModelDad:GetValue( 'PBWMASTER' ,'PBW_CODPPL' )
			PBW->PBW_DESPPL := oModelDad:GetValue( 'PBWMASTER' ,'PBW_DESPPL' )
			PBW->PBW_CODMST := oModelDad:GetValue( 'PBWMASTER' ,'PBW_CODMST' )
			PBW->PBW_USRMST := oModelDad:GetValue( 'PBWMASTER' ,'PBW_USRMST' )
			PBW->PBW_DTINI  := oModelDad:GetValue( 'PBWMASTER' ,'PBW_DTINI'  )
			PBW->PBW_CDSTIN := oModelDad:GetValue( 'PBWMASTER' ,'PBW_CDSTIN' )
			PBW->PBW_STGINI := oModelDad:GetValue( 'PBWMASTER' ,'PBW_STGINI' )
        PBW->(MsUnlock())
        
        //-> Percorre as linhas da grid.
        For nAtual := 1 To Len(aColsAux)
        
            //-> Se a linha não estiver excluída, inclui o registro.
            If ! aColsAux[nAtual][Len(aHeadAux)+1]
                RecLock('PBX', .T.)
                    PBX->PBX_FILIAL := xFilial('PBW')
					PBX->PBX_COD    := oModelDad:GetValue('PBWMASTER', 'PBW_COD')
					PBX->PBX_ITEM   := aColsAux[nAtual,2]
					PBX->PBX_IDSTG  := aColsAux[nAtual,3]
					PBX->PBX_DSCSTG := aColsAux[nAtual,4]
                PBX->(MsUnlock())
            EndIf
            
        Next
         
    //-> Se for Alteração.
    ElseIf nOpc == 4
   
        //-> Se conseguir posicionar, altera a descrição digitada
        PBW->( dbSetOrder(1) )
        If PBW->( DbSeek( xFilial('PBW') + cCodigo ) )
            RecLock('PBW', .F.)
            	PBW->PBW_COD    := oModelDad:GetValue( 'PBWMASTER' ,'PBW_COD'    )
            	PBW->PBW_CODPPL := oModelDad:GetValue( 'PBWMASTER' ,'PBW_CODPPL' )
            	PBW->PBW_DESPPL := oModelDad:GetValue( 'PBWMASTER' ,'PBW_DESPPL' )
            	PBW->PBW_CODMST := oModelDad:GetValue( 'PBWMASTER' ,'PBW_CODMST' )
            	PBW->PBW_USRMST := oModelDad:GetValue( 'PBWMASTER' ,'PBW_USRMST' )
            	PBW->PBW_DTINI  := oModelDad:GetValue( 'PBWMASTER' ,'PBW_DTINI'  )
            	PBW->PBW_CDSTIN := oModelDad:GetValue( 'PBWMASTER' ,'PBW_CDSTIN' )
            	PBW->PBW_STGINI := oModelDad:GetValue( 'PBWMASTER' ,'PBW_STGINI' )
            PBW->(MsUnlock())
        EndIf
         
        PBX->( dbSetOrder(2) ) 
        
        //-> Percorre o aCols.
        For nAtual := 1 To Len(aColsAux)
            
            //-> Se a linha estiver excluída.
            If aColsAux[nAtual][Len(aHeadAux)+1]
            
                //-> Se conseguir posicionar, exclui o registro
                If PBX->( DbSeek( xFilial('PBW') + cCodigo + aColsAux[nAtual,2] ) )
                    RecLock('PBX', .F.)
                        DbDelete()
                    PBX->(MsUnlock())
                EndIf
                 
            Else
                //-> Se conseguir posicionar no registro, será alteração.
                lSeek := PBX->( DbSeek( xFilial('PBX') + cCodigo + aColsAux[nAtual,2]) )
                
                RecLock('PBX', !lSeek)
                	PBX->PBX_FILIAL := xFilial('PBW')
					PBX->PBX_COD    := oModelDad:GetValue('PBWMASTER', 'PBW_COD')
					PBX->PBX_ITEM   := aColsAux[nAtual,2]
					PBX->PBX_IDSTG  := aColsAux[nAtual,3]
					PBX->PBX_DSCSTG := aColsAux[nAtual,4]
                PBX->(MsUnlock())
            EndIf
        Next
         
    //-> Se for Exclusão.
    ElseIf nOpc == 5
        
        //->Se conseguir posicionar, exclui o registro.
        PBW->( dbSetOrder(1) )
        If PBW->( DbSeek( xFilial('PBW') + cCodigo ) )
            RecLock('PBW', .F.)
                DbDelete()
            PBW->(MsUnlock())
        EndIf
        
        PBX->( dbSetOrder(1) ) 
        //-> Percorre a grid.
        For nAtual := 1 To Len(aColsAux)
            //-> Se conseguir posicionar, exclui o registro.
            If PBX->( DbSeek( xFilial('PBW') + cCodigo + aColsAux[nAtual,3] ) )
                RecLock('PBX', .F.)
                    DbDelete()
                PBX->(MsUnlock())
            EndIf
        Next
    EndIf
    
    RestArea(aArea)
	
Return( lRet )


//+-------------+---------+-------+-----------------------+------+-------------+
//|Programa:    |CSFTA02A |Autor: |David Alves dos Santos |Data: |09/04/2018   |
//|-------------+---------+-------+-----------------------+------+-------------|
//|Descricao:   |Função para validar se existe um ciclo ativo na tabela PBW.   |
//|-------------+--------------------------------------------------------------|
//|Uso:         |Certisign - Certificadora Digital.                            |
//+-------------+--------------------------------------------------------------+
User Function CSFTA02A()
	
	Local oModelDad := FWModelActive()
    Local cStatus   := oModelDad:GetValue('PBWMASTER', 'PBW_STATUS')
    Local cCdCicl   := oModelDad:GetValue('PBWMASTER', 'PBW_COD')
	Local cQuery    := ""
	Local cTmp      := GetNextAlias()
	Local cMsg      := ""
	Local lRet      := .T.
	
	//-> Verifica se esta ativo.
	If cStatus == "1"
		//-> Montagem da Query
		cQuery := " SELECT PBW_CDCICL, " 
		cQuery += "        PBW_DSCICL, "
		cQuery += "        Count(*) AS COUNT"
		cQuery += " FROM   PBW010 " 
		cQuery += " WHERE  PBW_STATUS = '1' " 
		cQuery += "        AND D_E_L_E_T_ = ' ' "
		cQuery += " GROUP BY PBW_CDCICL, "
		cQuery += "          PBW_DSCICL "
		
		//-> Verifica se a tabela esta aberta.
		If Select(cTmp) > 0
			(cTmp)->(DbCloseArea())				
		EndIf
		
		//-> Criação da tabela temporaria.
		cQuery := ChangeQuery( cQuery )
		dbUseArea( .T., "TOPCONN", TcGenQry( , , cQuery ), cTmp, .F., .T. ) 
	
	
		//-> Percorre a tabela temporária.
		While (cTmp)->( !Eof() )
		
			If (cTmp)->( !Eof() )
				If (cTmp)->COUNT >= 1 .And. cCdCicl <> (cTmp)->PBW_COD
					cMsg := "Não foi possivel realizar a ativação pois já existe um ciclo ativo." + Chr(13) + Chr(10)
					cMsg += "CICLO ATIVO: " + (cTmp)->PBW_COD + Chr(13) + Chr(10)
					cMsg += "DESCRIÇÃO: "   + (cTmp)->PBW_DSCICL
					
					lRet := .F.
					MsgStop( cMsg, cTitulo )
					Exit
				EndIf
			EndIf
		
			(cTmp)->(dbSkip())
		
		EndDo
	EndIf
	
Return( lRet )


//+-------------+---------+-------+-----------------------+------+-------------+
//|Programa:    |CSFTA02B |Autor: |David Alves dos Santos |Data: |10/04/2018   |
//|-------------+---------+-------+-----------------------+------+-------------|
//|Descricao:   |Função para validar se existe periodo ativo na tabela PBX.    |
//|-------------+--------------------------------------------------------------|
//|Uso:         |Certisign - Certificadora Digital.                            |
//+-------------+--------------------------------------------------------------+
User Function CSFTA02B()
	
	Local aArea      := GetArea()
    Local lRet       := .T.
    Local oModelDad  := FWModelActive()
    Local nOpc       := oModelDad:GetOperation()
    Local oModelGrid := oModelDad:GetModel('PBXDETAIL')
    Local aHeadAux   := oModelGrid:aHeader
    Local aCOLSAux   := oModelGrid:aCols
    Local nAtual     := 0
    Local nCntAtv    := 0
    
    //-> Faz a validação se o usuário setou o campo como Ativo igual a Sim.
    If oModelDad:GetModel('PBXDETAIL'):GetValue('PBX_ATIVO') == "S"
    	//-> Percorre as linhas da grid.
    	For nAtual := 1 To Len(aColsAux)
        
    		//-> Se a linha não estiver excluída, inclui o registro.
    		If ! aColsAux[nAtual][Len(aHeadAux)+1]
    			If aColsAux[nAtual,4] == "S"
    				nCntAtv += 1
    			EndIf
    		EndIf
            
    	Next
    
    	//-> Se encontrou algum registro ativo apresenta mensagem de erro.
    	If nCntAtv > 1 
    		lRet := .F.
    		MsgStop("Erro ao realizar a ativação. Verifique se já existe algum periodo ativo.")
    	EndIf
	EndIf
	
	RestArea(aArea)
	
Return( lRet )



//+-------------+---------+-------+-----------------------+------+-------------+
//|Programa:    |CSFTA02C |Autor: |David Alves dos Santos |Data: |13/04/2018   |
//|-------------+---------+-------+-----------------------+------+-------------|
//|Descricao:   |Função para validar os campos Data de e Data Ate.             |
//|-------------+--------------------------------------------------------------|
//|Uso:         |Certisign - Certificadora Digital.                            |
//+-------------+--------------------------------------------------------------+
User Function CSFTA02C()
	
	Local aArea      := GetArea()
    Local lRet       := .T.
    Local oModelDad  := FWModelActive()
    Local nOpc       := oModelDad:GetOperation()
    Local oModelGrid := oModelDad:GetModel('PBXDETAIL')
    Local aHeadAux   := oModelGrid:aHeader
    Local aCOLSAux   := oModelGrid:aCols
    Local nAtual     := 0
    Local nCntAtv    := 0
    
    //-> Data inicial e final do CICLO.
    Local dDtIni := oModelDad:GetValue('PBWMASTER', 'PBW_DTINI')
    Local dDtFim := oModelDad:GetValue('PBWMASTER', 'PBW_DTFIM')
    
    //-> Data inicial e final do PERIODO.
    Local dDtDe  := oModelDad:GetModel('PBXDETAIL'):GetValue('PBX_DTDE')
    Local dDtAte := oModelDad:GetModel('PBXDETAIL'):GetValue('PBX_DTATE')
    
    //-> Validações dos campos do tipo data.
    If !Empty(dDtDe) .And. !Empty(dDtIni)
    	If dDtDe < dDtIni
    		lRet := .F.
    		MsgStop("A campo [Data De] não pode ser menor que o campo [Dt. Inicio].",cTitulo)
    	EndIf
    EndIf
    
    If !Empty(dDtAte) .And. !Empty(dDtFim)
    	If dDtAte > dDtFim
    		lRet := .F.
    		MsgStop("A campo [Data Ate] não pode ser maior que o campo [Dt. Fim].",cTitulo)
    	EndIf
    EndIf
    
    If !Empty(dDtDe) .And. !Empty(dDtAte)
    	IF dDtDe > dDtAte
    		lRet := .F.
    		MsgStop("A campo [Data De] não pode ser maior que o campo [Data Até].",cTitulo)
    	EndIf
    EndIf
	
	RestArea(aArea)
	
Return( lRet )