//Bibliotecas
#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
 
//Variáveis Estáticas
Static cTitulo := "Manutenção do CTR"
 
/*/{Protheus.doc} ManCtr
Função de exemplo de Modelo X (Pai, Filho e Neto), com as tabelas CN9,CNA E CNB
@author Acouto
@since 24/01/21
@version 1.0
    @return Nil, Função não tem retorno
    @example
    u_ManCtr()
/*/
 
User Function ManCtr()
    Local aArea   := GetArea()
    Local oBrowse

	// Faz a carga do vetor com todos os usuarios do sistema para a validacao do código do usuario
//aRet := AllUsers() 

//DEF_TRAALT "039"
//lContinua := CN240VldUsr(CN9->CN9_NUMERO,"039",.T.)//Visualiza Contrato

//If	!lContinua
//	Return
//EndIf
     
    //Instânciando FWMBrowse - Somente com dicionário de dados
    oBrowse := FWMBrowse():New()
     
    //Setando a tabela de Contratos
    oBrowse:SetAlias("CN9")
	
	//Legendas
	oBrowse:AddLegend( "CN9->CN9_SITUAC == '05'", "GREEN",	"Vigente" )
	
	//Somente contratos vigentes
	oBrowse:SetFilterDefault("CN9_SITUAC == '05'")
	 
    //Setando a descrição da rotina
    oBrowse:SetDescription(cTitulo)

    //Ativa a Browse
    oBrowse:Activate()
     
    RestArea(aArea)
Return Nil
 
/*---------------------------------------------------------------------*
 | Func:  MenuDef                                                      |
 | Autor: Alcouto                                                      |
 | Data:  24/01/21                                                     |
 | Desc:  Criação do menu MVC                                          |
 *---------------------------------------------------------------------*/
 
Static Function MenuDef()
    Local aRot := {}
     
    //Adicionando opções
    ADD OPTION aRot TITLE 'Visualizar' ACTION 'VIEWDEF.ManCtr' OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 1
    ADD OPTION aRot TITLE 'Alterar'    ACTION 'VIEWDEF.ManCtr' OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4
	//ADD OPTION aRot TITLE 'Excluir'    ACTION 'VIEWDEF.ManCtr' OPERATION MODEL_OPERATION_DELETE ACCESS 0 //OPERATION 5
/*
1- pesquisar
2- visualizar
3- incluir
4- alterar
5- excluir
6- outras funções
7- copiar
*/ 

Return aRot
 
/*---------------------------------------------------------------------*
 | Func:  ModelDef                                                     |
 | Autor: Alcouto                                                      |
 | Data:  24/01/21                                                     |
 | Desc:  Criação do modelo de dados MVC                               |
 *---------------------------------------------------------------------*/
 
Static Function ModelDef()
    Local oModel         := Nil
    Local oStPai         := FWFormStruct(1, 'CN9')
    Local oStFilho     	 := FWFormStruct(1, 'CNA')
    Local oStNeto     	 := FWFormStruct(1, 'CNB')
    Local aCNARel        := {}
    Local aCNBRel        := {}
     
    //Criando o modelo e os relacionamentos
    oModel := MPFormModel():New('ManCtrM')
    oModel:AddFields('CN9MASTER',/*cOwner*/,oStPai)//,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)  //cOwner é para quem pertence
    oModel:AddGrid('CNADETAIL','CN9MASTER',oStFilho,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)  //cOwner é para quem pertence
    oModel:AddGrid('CNBDETAIL','CNADETAIL',oStNeto,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)  //cOwner é para quem pertence
    
    //Impedir que novas linhas sejam enseridas no grid
    oModel:GetModel('CNADETAIL'):SetNoInsertLine( .T. )
    oModel:GetModel('CNBDETAIL'):SetNoInsertLine( .T. )

    //Fazendo o relacionamento entre o Pai e Filho
    aAdd(aCNARel, {'CNA_FILIAL',    'CN9_FILIAL'})
    aAdd(aCNARel, {'CNA_CONTRA',    'CN9_NUMERO'})
	aAdd(aCNARel, {'CNA_REVISA',    'CN9_REVISA'})
     
    //Fazendo o relacionamento entre o Filho e Neto
    aAdd(aCNBRel, {'CNB_FILIAL',    'CNA_FILIAL'} )
    aAdd(aCNBRel, {'CNB_CONTRA',    'CNA_CONTRA'})
    aAdd(aCNBRel, {'CNB_REVISA',    'CNA_REVISA'}) 
     
    oModel:SetRelation('CNADETAIL', aCNARel, CNA->(IndexKey(1))) //IndexKey -> quero a ordenação e depois filtrado
    oModel:GetModel('CNADETAIL'):SetUniqueLine({"CNA_NUMERO"})    //Não repetir informações ou combinações {"CAMPO1","CAMPO2","CAMPOX"}
    //oModel:SetPrimaryKey({})
     
    oModel:SetRelation('CNBDETAIL', aCNBRel, CNB->(IndexKey(1))) //IndexKey -> quero a ordenação e depois filtrado
    oModel:GetModel('CNBDETAIL'):SetUniqueLine({"CNB_ITEM"})    //Não repetir informações ou combinações {"CAMPO1","CAMPO2","CAMPOX"}
    //oModel:SetPrimaryKey({})
     
    //Setando as descrições
    oModel:SetDescription("Manutenção especial de Contratos")
    oModel:GetModel('CN9MASTER'):SetDescription('Dados Contratuais')
    oModel:GetModel('CNADETAIL'):SetDescription('Planilha do Contrato')
    oModel:GetModel('CNBDETAIL'):SetDescription('Itens da Planilha')

    //Definições dos campos CN9	
	
	                            
	oStPai:SetProperty('CN9_TPCTO',     MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.F.')) 
	oStPai:SetProperty('CN9_FLGCAU',    MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.F.')) 
	oStPai:SetProperty('CN9_TIPREV',    MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.F.')) 
	oStPai:SetProperty('CN9_DTREV',     MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.F.'))  
	oStPai:SetProperty('CN9_VLREAJ',    MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.F.'))    
	oStPai:SetProperty('CN9_VLADIT',    MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.F.'))     
	oStPai:SetProperty('CN9_NUMTIT',    MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.F.'))          
	oStPai:SetProperty('CN9_VLMEAC',    MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.F.')) 
	oStPai:SetProperty('CN9_TXADM',     MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.F.'))              
	oStPai:SetProperty('CN9_FORMA',     MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.F.'))
	oStPai:SetProperty('CN9_DTENTR',    MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.F.'))
	oStPai:SetProperty('CN9_DESFIN',    MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.F.'))
	oStPai:SetProperty('CN9_CONTFI',    MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.F.'))
	oStPai:SetProperty('CN9_DTINPR',    MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.F.'))
	oStPai:SetProperty('CN9_PERPRO',    MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.F.'))
	oStPai:SetProperty('CN9_UNIPRO',    MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.F.'))
	oStPai:SetProperty('CN9_VLRPRO',    MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.F.'))
	oStPai:SetProperty('CN9_DTPROP',    MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.F.'))
	oStPai:SetProperty('CN9_DTINCP',    MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.F.'))
	oStPai:SetProperty('CN9_VLDCTR',    MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.F.'))
	oStPai:SetProperty('CN9_VIGE',      MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.F.'))
	oStPai:SetProperty('CN9_UNVIGE',    MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.F.'))
	//oStPai:SetProperty('CN9_XPERAD',    MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.F.'))
	//oStPai:SetProperty('CN9_XAPFOL',    MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.F.'))
	oStPai:SetProperty('CN9_XDTASS',    MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.T.')) 
	oStPai:SetProperty('CN9_ASSINA',    MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.F.'))
	oStPai:SetProperty('CN9_GRPAPR',    MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.F.'))
	oStPai:SetProperty('CN9_APROV',     MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.F.'))

	//Definições dos campos CNA.
	oStFilho:SetProperty('CNA_NUMERO',    MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.F.'))
	oStFilho:SetProperty('CNA_FORNEC',    MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.F.'))  
	oStFilho:SetProperty('CNA_LJFORN',    MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.F.'))  
	oStFilho:SetProperty('CNA_DTINI',     MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.F.'))
	oStFilho:SetProperty('CNA_VLTOT',     MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.F.'))
	oStFilho:SetProperty('CNA_SALDO',     MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.F.'))
	oStFilho:SetProperty('CNA_DTFIM',     MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.F.'))
	oStFilho:SetProperty('CNA_TIPPLA',    MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.F.'))
	oStFilho:SetProperty('CNA_INDICE',    MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.T.'))
	oStFilho:SetProperty('CNA_PERI',   	  MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.T.'))
	oStFilho:SetProperty('CNA_UNPERI',    MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.T.'))
	oStFilho:SetProperty('CNA_MODORJ',    MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.T.'))
	oStFilho:SetProperty('CNA_PROXRJ',    MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.T.'))
	oStFilho:SetProperty('CNA_DTREAJ',    MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.T.'))
	
	//Definições dos campos CNB.
	  
	oStNeto:SetProperty('CNB_ITEM',       MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.F.'))
	oStNeto:SetProperty('CNB_NUMERO',     MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.F.'))  
	oStNeto:SetProperty('CNB_CONTRA',     MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.F.'))  
	oStNeto:SetProperty('CNB_REALI',      MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.F.'))
	oStNeto:SetProperty('CNB_PRODUT',     MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.F.'))
	oStNeto:SetProperty('CNB_DESCRI',     MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.F.'))
	oStNeto:SetProperty('CNB_UM',   	  MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.F.'))
	oStNeto:SetProperty('CNB_QUANT',   	  MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.F.'))
	oStNeto:SetProperty('CNB_DTREAL',     MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.F.'))
	oStNeto:SetProperty('CNB_VLTOTR',     MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.F.'))
	oStNeto:SetProperty('CNB_VLUNIT',     MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.F.'))
	oStNeto:SetProperty('CNB_VLTOT',   	  MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.F.'))
	oStNeto:SetProperty('CNB_DESC',   	  MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.F.'))
	oStNeto:SetProperty('CNB_VLDESC',     MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.F.'))
	oStNeto:SetProperty('CNB_ATIVO',   	  MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.F.'))
	oStNeto:SetProperty('CNB_ARREND',   	 MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.F.'))
	oStNeto:SetProperty('CNB_REVISA',   	 MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.F.'))
	oStNeto:SetProperty('CNB_CC',    		 MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.T.'))
	oStNeto:SetProperty('CNB_CLVL',   	 	 MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.T.'))
	oStNeto:SetProperty('CNB_CONTA',    	 MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.T.'))                            
	/*oStFilho:SetProperty('CNB_EC05CR',     MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.T.'))                            
	oStFilho:SetProperty('CNB_EC05DB',    	 MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.T.'))                            
	oStFilho:SetProperty('CNB_EC06CR',    	 MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.T.'))                             
	oStFilho:SetProperty('CNB_EC06DB',   	 MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.T.'))
  	oStFilho:SetProperty('CNB_EC07CR',   	 MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.T.'))
	oStFilho:SetProperty('CNB_EC07DB',   	 MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.T.'))
	*/
	oStNeto:SetProperty('CNB_ITEMCT',   	 MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.T.'))
	oStNeto:SetProperty('CNB_FLREAJ',       MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.T.'))  
	oStNeto:SetProperty('CNB_INDICE',       MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.T.'))   
	
     
    //Adicionando totalizadores
    //oModel:AddCalc('TOTAIS', 'CN9MASTER', 'CNADETAIL', 'CNA_PRECO',  'XX_VALOR', 'SUM',   , , "Valor Total:" )
    //oModel:AddCalc('TOTAIS', 'CNADETAIL', 'CNBDETAIL', 'CNB_CODMUS', 'XX_TOTAL', 'COUNT', , , "Total Musicas:" )
	
Return oModel
 
/*---------------------------------------------------------------------*
 | Func:  ViewDef                                                      |
 | Autor: Alcouto                                                      |
 | Data:  24/01/2021                                                   |
 | Desc:  Criação da visão MVC                                         |
 | Obs.:  /                                                            |
 *---------------------------------------------------------------------*/
 
Static Function ViewDef()
    Local oView         := Nil
    Local oModel        := FWLoadModel('ManCtr')
    Local oStPai        := FWFormStruct(2, 'CN9')
    Local oStFilho      := FWFormStruct(2, 'CNA')
    Local oStNeto       := FWFormStruct(2, 'CNB')
    //Local oStTot        := FWCalcStruct(oModel:GetModel('TOTAIS'))
     
    //Criando a View
    oView := FWFormView():New()
    oView:SetModel(oModel)
     
    //Adicionando os campos do cabeçalho e o grid dos filhos
    oView:AddField('VIEW_CN9', oStPai,   'CN9MASTER')
    oView:AddGrid('VIEW_CNA',  oStFilho, 'CNADETAIL')
    oView:AddGrid('VIEW_CNB',  oStNeto,  'CNBDETAIL')
    //oView:AddField('VIEW_TOT', oStTot,   'TOTAIS')
     
    //Setando o dimensionamento de tamanho
    oView:CreateHorizontalBox('CABEC', 38)
    oView:CreateHorizontalBox('GRID',  22)
    oView:CreateHorizontalBox('GRID2', 40)
    //oView:CreateHorizontalBox('TOTAL', 13)
     
    //Amarrando a view com as box
    oView:SetOwnerView('VIEW_CN9', 'CABEC')
    oView:SetOwnerView('VIEW_CNA', 'GRID')
    oView:SetOwnerView('VIEW_CNB', 'GRID2')
    //oView:SetOwnerView('VIEW_TOT', 'TOTAL')
     
    //Habilitando título
    oView:EnableTitleView('VIEW_CN9','Dados Contrato')
    oView:EnableTitleView('VIEW_CNA','Dados Planilha')
    oView:EnableTitleView('VIEW_CNB','Dados Itens da Planilha')
     
    //Removendo campos da CNA
    oStFilho:RemoveField('CNA_CLIENT')
    oStFilho:RemoveField('CNA_LOJACL')
    oStFilho:RemoveField('CNA_CONTRA')
    oStFilho:RemoveField('CNA_NUMERO')
    oStFilho:RemoveField('CNA_REVISA')
    oStFilho:RemoveField('CNA_CRONOG')
	oStFilho:RemoveField('CNA_ESPEL')
	oStFilho:RemoveField('CNA_DTMXMD')
	oStFilho:RemoveField('CNA_CRONCT')
	oStFilho:RemoveField('CNA_VLCOMS')
	oStFilho:RemoveField('CNA_SADIST')
	oStFilho:RemoveField('CNA_SADISC')
	oStFilho:RemoveField('CNA_PERREC')
	oStFilho:RemoveField('CNA_QTDREC')
	oStFilho:RemoveField('CNA_DIASEM')
	oStFilho:RemoveField('CNA_DIAMES')
	oStFilho:RemoveField('CNA_PROMED')
	oStFilho:RemoveField('CNA_ULTMED')
	oStFilho:RemoveField('CNA_MEDEFE')
	oStFilho:RemoveField('CNA_RECMED')
	oStFilho:RemoveField('CNA_PRORAT')
	//oStFilho:RemoveField('CNA_DTREAJ')
	//oStFilho:RemoveField('CNA_PROXRJ')
	oStFilho:RemoveField('CNA_RPGANT')
	oStFilho:RemoveField('CNA_DTMXMD')
	oStFilho:RemoveField('CNA_CRONOG')
	oStFilho:RemoveField('CNA_ESPEL ')
	oStFilho:RemoveField('CNA_VLCOMS')
	oStFilho:RemoveField('CNA_SADIST')
	oStFilho:RemoveField('CNA_SADISC')
	oStFilho:RemoveField('CNA_PERIOD')
	oStFilho:RemoveField('CNA_PERREC')
	oStFilho:RemoveField('CNA_QTDREC')
	oStFilho:RemoveField('CNA_DIASEM')
	oStFilho:RemoveField('CNA_DIAMES')
	oStFilho:RemoveField('CNA_PROMED')
	oStFilho:RemoveField('CNA_ULTMED')
	oStFilho:RemoveField('CNA_MEDEFE')
	//oStFilho:RemoveField('CNA_UNPERI')
	oStFilho:RemoveField('CNA_PROPAR')
	oStFilho:RemoveField('CNA_PRORAT')
	oStFilho:RemoveField('CNA_RPGANT')
	//oStFilho:RemoveField('CNA_PROMED')
	//oStFilho:RemoveField('CNA_PROMED')


   // oStNeto:RemoveField('CNB_CODART')
   // oStNeto:RemoveField('CNB_CODCD')

   //Removendo campos da CN9
    oStPai:RemoveField('CN9_XTIPO')
	oStPai:RemoveField('CN9_XCODGE')
	oStPai:RemoveField('CN9_XGRPRE')
	oStPai:RemoveField('CN9_XGESTO')
	oStPai:RemoveField('CN9_XPERAD')  


   //Removendo campos da CNB
	oStNeto:RemoveField('CNB_NATURE')
	oStNeto:RemoveField('CNB_DTANIV')
	oStNeto:RemoveField('CNB_CONORC')
	oStNeto:RemoveField('CNB_DTCAD')
	oStNeto:RemoveField('CNB_DTPREV')
	oStNeto:RemoveField('CNB_QTDMED')
	oStNeto:RemoveField('CNB_PERC')
	oStNeto:RemoveField('CNB_RATEIO')
	oStNeto:RemoveField('CNB_TIPO')
	oStNeto:RemoveField('CNB_ITSOMA')
	oStNeto:RemoveField('CNB_PRCORI')
	oStNeto:RemoveField('CNB_QTDORI')
	oStNeto:RemoveField('CNB_QTRDAC')
	oStNeto:RemoveField('CNB_QTRDRZ')
	oStNeto:RemoveField('CNB_QTREAD')
	oStNeto:RemoveField('CNB_VLREAD')
	oStNeto:RemoveField('CNB_VLRDGL')
	oStNeto:RemoveField('CNB_PERCAL')
	oStNeto:RemoveField('CNB_FILHO')
	oStNeto:RemoveField('CNB_SLDMED')
	oStNeto:RemoveField('CNB_NUMSC')
	oStNeto:RemoveField('CNB_ITEMSC')
	oStNeto:RemoveField('CNB_QTDSOL')
	oStNeto:RemoveField('CNB_TE')
	oStNeto:RemoveField('CNB_TS')
	oStNeto:RemoveField('CNB_SLDREC')
	oStNeto:RemoveField('CNB_FLGCMS')
	oStNeto:RemoveField('CNB_ITMDST')
	oStNeto:RemoveField('CNB_TABPRC')
	oStNeto:RemoveField('CNB_GCPIT')
	oStNeto:RemoveField('CNB_GCPLT')
	oStNeto:RemoveField('CNB_ULTAVA')
	oStNeto:RemoveField('CNB_PROXAV')
	oStNeto:RemoveField('CNB_FILORI')
	oStNeto:RemoveField('CNB_PEDTIT')
	oStNeto:RemoveField('CNB_VLRDGL')
	oStNeto:RemoveField('CNB_IDENT')
	oStNeto:RemoveField('CNB_CODNE')
	oStNeto:RemoveField('CNB_ITEMNE')
	oStNeto:RemoveField('CNB_BASINS')
	oStNeto:RemoveField('CNB_GERBIN')
	oStNeto:RemoveField('CNB_PROITN')
	oStNeto:RemoveField('CNB_PROPOS')
	oStNeto:RemoveField('CNB_PROREV')
	oStNeto:RemoveField('CNB_PROXRJ')
	oStNeto:RemoveField('CNB_DTREAJ')
	oStNeto:RemoveField('CNB_IDPED')
	oStNeto:RemoveField('CNB_MODORJ')
	oStNeto:RemoveField('CNB_RJRTO')
	oStNeto:RemoveField('CNB_PRODSV')
	oStNeto:RemoveField('CNB_PERI')
	oStNeto:RemoveField('CNB_UNPERI')
	oStNeto:RemoveField('CNB_REVISA')
	//oStNeto:RemoveField('CNB_ITEM')
	oStNeto:RemoveField('CNB_REALI ')
	oStNeto:RemoveField('CNB_DTREAL')
	oStNeto:RemoveField('CNB_VLTOTR')
	oStNeto:RemoveField('CNB_VLDESC')
	oStNeto:RemoveField('CNB_DESC  ')
	oStNeto:RemoveField('CNB_CONORC')
	oStNeto:RemoveField('CNB_DTCAD ')
	oStNeto:RemoveField('CNB_DTPREV')
	oStNeto:RemoveField('CNB_QTDMED')
	oStNeto:RemoveField('CNB_PERC  ')
	oStNeto:RemoveField('CNB_RATEIO')
	oStNeto:RemoveField('CNB_TIPO')
	oStNeto:RemoveField('CNB_XCOEME')
	oStNeto:RemoveField('CNB_XFOESP')
	oStNeto:RemoveField('CNB_XFILIA')
	oStNeto:RemoveField('CNB_X2CC  ')
	oStNeto:RemoveField('CNB_RJRTO ')
	oStNeto:RemoveField('CNB_EC06CR')
	oStNeto:RemoveField('CNB_ARREND')
	oStNeto:RemoveField('CNB_PARPRO')
	oStNeto:RemoveField('CNB_EC07CR')
	oStNeto:RemoveField('CNB_EC07DB')
	oStNeto:RemoveField('CNB_EC08CR')
	oStNeto:RemoveField('CNB_EC08DB')
	//oStNeto:RemoveField('CNB_TIPO')
	//oStNeto:RemoveField('CNB_TIPO')
	//oStNeto:RemoveField('CNB_TIPO')
	//oStNeto:RemoveField('CNB_TIPO')
	//oStNeto:RemoveField('CNB_TIPO')
	//oStNeto:RemoveField('CNB_TIPO')
	//oStNeto:RemoveField('CNB_TIPO')
	
	
	
   
   // Forçar fechamento da janela na confirmação
	oView:SetCloseOnOK({||.T.})
	
Return oView
