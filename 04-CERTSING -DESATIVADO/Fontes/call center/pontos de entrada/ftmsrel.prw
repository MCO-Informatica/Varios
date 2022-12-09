//------------------------------------------------------------------
// Rotina | FTMSREL | Autor | Robson Luiz - Rleg | Data | 07/08/2012
//------------------------------------------------------------------
// Descr. | Ponto de entrada acionado na rotina MsRelation p/ devolver
//        | a chave única do relacionamento de cada entidade.
//------------------------------------------------------------------
// Uso    | Certisign
//------------------------------------------------------------------
User Function FTMSREL()
	Local aEntidade := {}
	AAdd( aEntidade, { "SZT", { "ZT_CODIGO"  },{ || SZT->ZT_EMPRESA } } )
	AAdd( aEntidade, { "SZX", { "ZX_CODIGO"  },{ || SZX->ZX_DSRAZAO } } )
	AAdd( aEntidade, { "PAB", { "PAB_CODIGO" },{ || PAB->PAB_CODIGO } } )	
	AAdd( aEntidade, { "PAD", { "PAD_NUMERO" },{ || Posicione( 'RD0', 1, xFilial( 'RD0' ) + PAD->PAD_SOLICI, 'RD0_NOME' ) } } )
	AAdd( aEntidade, { "PAI", { "PAI_ID"     },{ || 'Documento '+PAI->PAI_DOC+' Sequencia '+PAI->PAI_NUMSEQ+' Data '+Dtoc(PAI->PAI_EMISSA)+' Hora '+PAI->PAI_HORA } } )
	AAdd( aEntidade, { "PA0", { "PA0_OS"     },{ || "OS "} }  )
	//Renato Ruy - 11/02/2016
	//Adiciona tabela ZZ6 na listagem de conhecimento
	AAdd( aEntidade, { "ZZ6", { "ZZ6_PERIOD","ZZ6_CODENT" },{ || ZZ6->ZZ6_DESENT } } )
	AAdd( aEntidade, { "SUC", { "UC_FILIAL" ,"UC_CODIGO"  },{ || SUC->UC_FILIAL + SUC->UC_CODIGO } } )
	
	AAdd( aEntidade, { "U00", { "U00_FILIAL" ,"U00_CODHRD"  },{ || U00->U00_FILIAL + U00->U00_CODHRD } } )
	AAdd( aEntidade, { "U04", { "U04_FILIAL" ,"U04_CODSFT"  },{ || U04->U04_FILIAL + U04->U04_CODSFT } } )
	
Return( aEntidade )