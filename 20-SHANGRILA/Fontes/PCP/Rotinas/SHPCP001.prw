#Include 'Protheus.ch'

/**
*
* @author: Bruno Ricardo de Oliveira
* @since: 18/07/2014 - 11:17:31
* @description: Rotina para inclusão dos dados das tabelas ZRM(Resumo de Metas) e SX5. 
*/ 
User Function SHPCP001()

	Private aRotina	:= {} 
	Private cCadastro	:= "Resumo de Metas" 

	Aadd(aRotina,{"Pesquisar"  , "AxPesqui"   , 0 ,1 })
	Aadd(aRotina,{"Visualizar" , 'U_SHPCP002("ZRM",RecNo(),2)' , 0 ,2 })
	Aadd(aRotina,{"Incluir"    , 'U_SHPCP002("ZRM",RecNo(),3)' , 0 ,3 })
	Aadd(aRotina,{"Alterar"    , 'U_SHPCP002("ZRM",RecNo(),4)' , 0 ,4 })
	Aadd(aRotina,{"Excluir"    , 'U_SHPCP002("ZRM",RecNo(),5)' , 0 ,5 })

	MBrowse(,,,,"ZRM")
	//MBrowse(,,,,"SA1")	
Return

