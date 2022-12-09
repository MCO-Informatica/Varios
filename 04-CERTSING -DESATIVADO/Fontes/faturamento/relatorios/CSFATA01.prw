#Include "Totvs.ch"
#Include "FwMvcDef.ch"

Static cTitulo := "Cadastro de Ciclos"

//+-------------+---------+-------+-----------------------+------+-------------+
//|Programa:    |CSFATA01 |Autor: |David Alves dos Santos |Data: |02/04/2018   |
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
User Function CSFATA01()
	
	Local aArea := GetArea()
    
    Private oBrowse 
    Private aRotina := MenuDef()
    
    //-> Instânciando FWMBrowse - Somente com dicionário de dados
    oBrowse := FWMBrowse():New()
     
    //-> Setando a tabela de cadastro de Ciclo/ Itens de Ciclo.
    oBrowse:SetAlias("ZZD")
 
    //-> Setando a descrição da rotina
    oBrowse:SetDescription( cTitulo )
     
    //-> Legendas
    oBrowse:AddLegend( "ZZD->ZZD_STATUS == '1'" ,"GREEN" ,"Ativo" )
    oBrowse:AddLegend( "ZZD->ZZD_STATUS == '0'" ,"RED"   ,"Inativo" )    
         
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
	ADD OPTION aRotina TITLE 'Visualizar' ACTION 'VIEWDEF.CSFATA01'	OPERATION 2 ACCESS 0
	ADD OPTION aRotina TITLE 'Incluir'    ACTION 'VIEWDEF.CSFATA01' OPERATION 3 ACCESS 0
	ADD OPTION aRotina TITLE 'Alterar'    ACTION 'VIEWDEF.CSFATA01' OPERATION 4 ACCESS 0
	ADD OPTION aRotina TITLE 'Excluir'    ACTION 'VIEWDEF.CSFATA01' OPERATION 5 ACCESS 0
	
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
    Local oStPai	:= FWFormStruct(1, 'ZZD')
    Local oStFilho	:= FWFormStruct(1, 'ZZH')
    Local aZ17Rel	:= {}
    Local bPost		:= {|| CSFT01POST() }
    Local bCommit	:= {|| CSFT01GRV() }

    oModel := MPFormModel():New("zMVCMd3", , bPost, bCommit, )
    
    oModel:AddFields('ZZDMASTER',/*cOwner*/,oStPai)
    oModel:AddGrid('ZZHDETAIL','ZZDMASTER',oStFilho,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)  //cOwner é para quem pertence
    
	oModel:SetDescription('Descrição')
	 
    //-> Fazendo o relacionamento entre o Pai e Filho
    aAdd(aZ17Rel, {'ZZH_FILIAL',    'ZZD_FILIAL'} )
    aAdd(aZ17Rel, {'ZZH_CDCICL',    'ZZD_CDCICL'})
     
    oModel:SetRelation('ZZHDETAIL', aZ17Rel, ZZH->(IndexKey(1))) //IndexKey -> quero a ordenação e depois filtrado
    oModel:GetModel('ZZHDETAIL'):SetUniqueLine({"ZZH_FILIAL","ZZH_CDCICL","ZZH_ITEM"})    //Não repetir informações ou combinações {"CAMPO1","CAMPO2","CAMPOX"}
    oModel:SetPrimaryKey({})
    
    //-> Setando para utilizar aCOLS
    oModel:GetModel('ZZHDETAIL'):lUseCols := .T. 

    //-> Setando as descrições
    oModel:SetDescription(cTitulo)
    oModel:GetModel('ZZDMASTER'):SetDescription('Modelo Descrição')
    oModel:GetModel('ZZHDETAIL'):SetDescription('Modelo Transferências')
    
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
    Local oModel   := FWLoadModel('CSFATA01')
    Local oStPai   := FWFormStruct(2, 'ZZD')
    Local oStFilho := FWFormStruct(2, 'ZZH')
     
    //-> Criando a View
    oView := FWFormView():New()
    oView:SetModel(oModel)
     
    //-> Adicionando os campos do cabeçalho e o grid dos filhos
    oView:AddField('VIEW_ZZD',oStPai,'ZZDMASTER')
    oView:AddGrid('VIEW_ZZH',oStFilho,'ZZHDETAIL')
     
    //-> Setando o dimensionamento de tamanho
    oView:CreateHorizontalBox('CABEC',30)
    oView:CreateHorizontalBox('GRID',70)
     
    //-> Amarrando a view com as box
    oView:SetOwnerView('VIEW_ZZD','CABEC')
    oView:SetOwnerView('VIEW_ZZH','GRID')
     
    //-> Habilitando título
    oView:EnableTitleView('VIEW_ZZD','Ciclo')
    oView:EnableTitleView('VIEW_ZZH','Periodos')
    
    //-> Copia a linha do GRID
    oView:SetViewProperty( 'VIEW_ZZH', "ENABLEDCOPYLINE",  {VK_F12} )
    
    //-> Campos incrementais
    oView:AddIncrementField('VIEW_ZZH','ZZH_ITEM')

    //-> Remove campos da GRID
    oStFilho:RemoveField("ZZH_FILIAL")
    oStFilho:RemoveField("ZZH_CDCICL")

Return( oView ) 


//+-------------+-----------+-------+-----------------------+------+-----------+
//|Programa:    |CSFT01POST |Autor: |David Alves dos Santos |Data: |10/04/2018 |
//|-------------+-----------+-------+-----------------------+------+-----------|
//|Descricao:   |Função chamada na validação do botão confirmar.               |
//|-------------+--------------------------------------------------------------|
//|Uso:         |Certisign - Certificadora Digital.                            |
//+-------------+--------------------------------------------------------------+
Static Function CSFT01POST()
	
	Local aArea     := GetArea() 
	Local oModelDad := FWModelActive()
	Local cStatus   := oModelDad:GetValue('ZZDMASTER', 'ZZD_STATUS')
	Local lRet      := .T.
	
	lRet := U_CSFTA01A()
		
	RestArea(aArea)
	
Return( lRet )


//+-------------+-----------+-------+-----------------------+------+-----------+
//|Programa:    |CSFT01GRV  |Autor: |David Alves dos Santos |Data: |10/04/2018 |
//|-------------+-----------+-------+-----------------------+------+-----------|
//|Descricao:   |Função chamada na validação do botão confirmar.               |
//|-------------+--------------------------------------------------------------|
//|Uso:         |Certisign - Certificadora Digital.                            |
//+-------------+--------------------------------------------------------------+
Static Function CSFT01GRV()

	Local aArea      := GetArea()
    Local lRet       := .T.
    Local oModelDad  := FWModelActive()
    Local cCodigo    := oModelDad:GetValue('ZZDMASTER', 'ZZD_CDCICL')
    Local nOpc       := oModelDad:GetOperation()
    Local oModelGrid := oModelDad:GetModel('ZZHDETAIL')
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
        
        //-> Cria o registro na tabela ZZD (Cabeçalho).
        RecLock('ZZD', .T.)
            ZZD->ZZD_FILIAL := xFilial('ZZD')
			ZZD->ZZD_CDCICL := oModelDad:GetValue( 'ZZDMASTER' ,'ZZD_CDCICL' )
			ZZD->ZZD_DSCICL := oModelDad:GetValue( 'ZZDMASTER' ,'ZZD_DSCICL' )
			ZZD->ZZD_STATUS := oModelDad:GetValue( 'ZZDMASTER' ,'ZZD_STATUS' )
			ZZD->ZZD_DTINI  := oModelDad:GetValue( 'ZZDMASTER' ,'ZZD_DTINI'  )
			ZZD->ZZD_DTFIM  := oModelDad:GetValue( 'ZZDMASTER' ,'ZZD_DTFIM'  )
        ZZD->(MsUnlock())
        
        //-> Percorre as linhas da grid.
        For nAtual := 1 To Len(aColsAux)
        
            //-> Se a linha não estiver excluída, inclui o registro.
            If ! aColsAux[nAtual][Len(aHeadAux)+1]
                RecLock('ZZH', .T.)
                    ZZH->ZZH_FILIAL := xFilial('ZZD')
					ZZH->ZZH_CDCICL := oModelDad:GetValue('ZZDMASTER', 'ZZD_CDCICL')
					ZZH->ZZH_ITEM   := aColsAux[nAtual,3]
					ZZH->ZZH_ATIVO  := aColsAux[nAtual,4]
					ZZH->ZZH_DTDE   := aColsAux[nAtual,5]
					ZZH->ZZH_DTATE  := aColsAux[nAtual,6]
					ZZH->ZZH_USER   := aColsAux[nAtual,7]
					ZZH->ZZH_DTUALT := Date()
					ZZH->ZZH_HRUALT := Time()
                ZZH->(MsUnlock())
            EndIf
            
        Next
         
    //-> Se for Alteração.
    ElseIf nOpc == 4
   
        //-> Se conseguir posicionar, altera a descrição digitada
        ZZD->( dbSetOrder(1) )
        If ZZD->( DbSeek( xFilial('ZZD') + cCodigo ) )
            RecLock('ZZD', .F.)
            	ZZD->ZZD_CDCICL := oModelDad:GetValue('ZZDMASTER', 'ZZD_CDCICL' )
            	ZZD->ZZD_DSCICL := oModelDad:GetValue('ZZDMASTER', 'ZZD_DSCICL' )
            	ZZD->ZZD_STATUS := oModelDad:GetValue('ZZDMASTER', 'ZZD_STATUS' )
            	ZZD->ZZD_DTINI  := oModelDad:GetValue('ZZDMASTER', 'ZZD_DTINI'  )
            	ZZD->ZZD_DTFIM  := oModelDad:GetValue('ZZDMASTER', 'ZZD_DTFIM'  )
            ZZD->(MsUnlock())
        EndIf
         
        ZZH->( dbSetOrder(2) ) 
        
        //-> Percorre o aCols.
        For nAtual := 1 To Len(aColsAux)
            
            //-> Se a linha estiver excluída.
            If aColsAux[nAtual][Len(aHeadAux)+1]
            
                //-> Se conseguir posicionar, exclui o registro
                If ZZH->( DbSeek( xFilial('ZZD') + cCodigo + aColsAux[nAtual,3] ) )
                    RecLock('ZZH', .F.)
                        DbDelete()
                    ZZH->(MsUnlock())
                EndIf
                 
            Else
                //-> Se conseguir posicionar no registro, será alteração.
                lSeek := ZZH->( DbSeek( xFilial('ZZD') + cCodigo + aColsAux[nAtual,3] ) )
                
                RecLock('ZZH', !lSeek)
                 	ZZH->ZZH_FILIAL := xFilial('ZZD')
					ZZH->ZZH_CDCICL := oModelDad:GetValue('ZZDMASTER', 'ZZD_CDCICL')
					ZZH->ZZH_ITEM   := aColsAux[nAtual,3]
					ZZH->ZZH_ATIVO  := aColsAux[nAtual,4]
					ZZH->ZZH_DTDE   := aColsAux[nAtual,5]
					ZZH->ZZH_DTATE  := aColsAux[nAtual,6]
					ZZH->ZZH_USER   := aColsAux[nAtual,7]
					ZZH->ZZH_DTUALT := Date()
					ZZH->ZZH_HRUALT := Time()
                ZZH->(MsUnlock())
            EndIf
        Next
         
    //-> Se for Exclusão.
    ElseIf nOpc == 5
        
        //->Se conseguir posicionar, exclui o registro.
        ZZD->( dbSetOrder(1) )
        If ZZD->( DbSeek( xFilial('ZZD') + cCodigo ) )
            RecLock('ZZD', .F.)
                DbDelete()
            ZZD->(MsUnlock())
        EndIf
        
        ZZH->( dbSetOrder(1) ) 
        //-> Percorre a grid.
        For nAtual := 1 To Len(aColsAux)
            //-> Se conseguir posicionar, exclui o registro.
            If ZZH->( DbSeek( xFilial('ZZD') + cCodigo + aColsAux[nAtual,3] ) )
                RecLock('ZZH', .F.)
                    DbDelete()
                ZZH->(MsUnlock())
            EndIf
        Next
    EndIf
    
    RestArea(aArea)
	
Return( lRet )


//+-------------+---------+-------+-----------------------+------+-------------+
//|Programa:    |CSFTA01A |Autor: |David Alves dos Santos |Data: |09/04/2018   |
//|-------------+---------+-------+-----------------------+------+-------------|
//|Descricao:   |Função para validar se existe um ciclo ativo na tabela ZZD.   |
//|-------------+--------------------------------------------------------------|
//|Uso:         |Certisign - Certificadora Digital.                            |
//+-------------+--------------------------------------------------------------+
User Function CSFTA01A()
	
	Local oModelDad := FWModelActive()
    Local cStatus   := oModelDad:GetValue('ZZDMASTER', 'ZZD_STATUS')
    Local cCdCicl   := oModelDad:GetValue('ZZDMASTER', 'ZZD_CDCICL')
	Local cQuery    := ""
	Local cTmp      := GetNextAlias()
	Local cMsg      := ""
	Local lRet      := .T.
	
	//-> Verifica se esta ativo.
	If cStatus == "1"
		//-> Montagem da Query
		cQuery := " SELECT ZZD_CDCICL, " 
		cQuery += "        ZZD_DSCICL, "
		cQuery += "        Count(*) AS COUNT"
		cQuery += " FROM   ZZD010 " 
		cQuery += " WHERE  ZZD_STATUS = '1' " 
		cQuery += "        AND D_E_L_E_T_ = ' ' "
		cQuery += " GROUP BY ZZD_CDCICL, "
		cQuery += "          ZZD_DSCICL "
		
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
				If (cTmp)->COUNT >= 1 .And. cCdCicl <> (cTmp)->ZZD_CDCICL
					cMsg := "Não foi possivel realizar a ativação pois já existe um ciclo ativo." + Chr(13) + Chr(10)
					cMsg += "CICLO ATIVO: " + (cTmp)->ZZD_CDCICL + Chr(13) + Chr(10)
					cMsg += "DESCRIÇÃO: "   + (cTmp)->ZZD_DSCICL
					
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
//|Programa:    |CSFTA01B |Autor: |David Alves dos Santos |Data: |10/04/2018   |
//|-------------+---------+-------+-----------------------+------+-------------|
//|Descricao:   |Função para validar se existe periodo ativo na tabela ZZH.    |
//|-------------+--------------------------------------------------------------|
//|Uso:         |Certisign - Certificadora Digital.                            |
//+-------------+--------------------------------------------------------------+
User Function CSFTA01B()
	
	Local aArea      := GetArea()
    Local lRet       := .T.
    Local oModelDad  := FWModelActive()
    Local nOpc       := oModelDad:GetOperation()
    Local oModelGrid := oModelDad:GetModel('ZZHDETAIL')
    Local aHeadAux   := oModelGrid:aHeader
    Local aCOLSAux   := oModelGrid:aCols
    Local nAtual     := 0
    Local nCntAtv    := 0
    
    //-> Faz a validação se o usuário setou o campo como Ativo igual a Sim.
    If oModelDad:GetModel('ZZHDETAIL'):GetValue('ZZH_ATIVO') == "S"
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
//|Programa:    |CSFTA01C |Autor: |David Alves dos Santos |Data: |13/04/2018   |
//|-------------+---------+-------+-----------------------+------+-------------|
//|Descricao:   |Função para validar os campos Data de e Data Ate.             |
//|-------------+--------------------------------------------------------------|
//|Uso:         |Certisign - Certificadora Digital.                            |
//+-------------+--------------------------------------------------------------+
User Function CSFTA01C()
	
	Local aArea      := GetArea()
    Local lRet       := .T.
    Local oModelDad  := FWModelActive()
    Local nOpc       := oModelDad:GetOperation()
    Local oModelGrid := oModelDad:GetModel('ZZHDETAIL')
    Local aHeadAux   := oModelGrid:aHeader
    Local aCOLSAux   := oModelGrid:aCols
    Local nAtual     := 0
    Local nCntAtv    := 0
    
    //-> Data inicial e final do CICLO.
    Local dDtIni := oModelDad:GetValue('ZZDMASTER', 'ZZD_DTINI')
    Local dDtFim := oModelDad:GetValue('ZZDMASTER', 'ZZD_DTFIM')
    
    //-> Data inicial e final do PERIODO.
    Local dDtDe  := oModelDad:GetModel('ZZHDETAIL'):GetValue('ZZH_DTDE')
    Local dDtAte := oModelDad:GetModel('ZZHDETAIL'):GetValue('ZZH_DTATE')
    
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