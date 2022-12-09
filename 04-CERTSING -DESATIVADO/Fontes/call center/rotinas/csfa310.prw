//---------------------------------------------------------------------
// Rotina | CSFA310    | Autor | Robson Luiz - Rleg | Data | 09/12/2013
//---------------------------------------------------------------------
// Descr. | Rotina para preparar os dados para o envio de e-mail quando 
//        | o apontamento da oportunidade for para o mesmo estágio.
//        | Rotina acionada pelo ponto de entrada FAT310GR.
//        | Rotina que interage com a geração de propostas conforme a 
//        | evolução do estágio.
//---------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------
#Include 'Protheus.ch'
STATIC cAD1_STAGE := ''
STATIC cAD1_PROVEN := ''
User Function CSFA310( nOpc )
	Local cTitulo := ''
	Local cMV_320DE := 'MV_320DE'
	Local cMV_320PARA := 'MV_320PARA'
	Local cMV_320PROP := 'MV_320PROP' 
	//-------------------------------------------------
	// Somente inclusão de apontamento de oportunidade.
	//-------------------------------------------------
	If nOpc == 1
		//---------------------------------------------------------------------------------
		// Chamada da rotina de impressão de propostas. Integração do Protheus com Ms-Word.
		//---------------------------------------------------------------------------------
		If FindFunction('U_A320PROP')
			If .NOT. SX6->( ExisteSX6( cMV_320DE ) )
				CriarSX6( cMV_320DE, 'C', 'Estagio anterior que encontra-se da oportunidade para gerar a proposta. CSFA320.prw', '004|003' )
			Endif
			If .NOT. SX6->( ExisteSX6( cMV_320PARA ) )
				CriarSX6( cMV_320PARA, 'C', 'Estagio atual que a oportunidade está avancando para gerar a proposta. CSFA320.prw', '005|004' )
			Endif
			If AD1->AD1_PROVEN=='000001'
				cMV_320DE   := SubStr( GetMv( cMV_320DE   ), 1, 3 )
				cMV_320PARA := SubStr( GetMv( cMV_320PARA ), 1, 3 )
			Elseif AD1->AD1_PROVEN=='000002'
				cMV_320DE   := SubStr( GetMv( cMV_320DE   ), 5, 3 )
				cMV_320PARA := SubStr( GetMv( cMV_320PARA ), 5, 3 )
			Endif 
			If .NOT. SX6->( ExisteSX6( cMV_320PROP ) )
				CriarSX6( cMV_320PROP, 'L', 'Habilita a rotina de gerar propostas integrado com Gestao de Oportunidades. CSFA320.prw', '.F.' )
			Endif
			//---------------------------------------
			// Está habilitada a chave de integração?
			//---------------------------------------
			If GetMv( cMV_320PROP )
				If /*cMV_320DE == Left( cAD1_STAGE, 3 ) .And.*/ Left( M->AD5_EVENTO, 3 ) >= cMV_320PARA
					cTitulo := 'CSFA310 - Gerar Proposta - Gestão de Oportunidades'
					If MsgYesNo('A Oportunidade '+M->AD5_NROPOR+' foi para o estágio que permite o sistema gerar propostas, quer gerar agora?',cTitulo)
						U_A320Prop( M->AD5_NROPOR )
					Else
						MsgInfo('Você pode gerar a proposta em outro momento por meio da rotina de Oportunidades opção Gerar Proposta',cTitulo)
					Endif
				Endif
			Endif
		Endif
	Endif
	//-------------------------------------------------------------------------
	// Limpar a variável STATIC para não haver reenvio de e-mail desnecessário.
	//-------------------------------------------------------------------------
	cAD1_STAGE := ''
Return
//---------------------------------------------------------------------
// Rotina | A310Arm    | Autor | Robson Luiz - Rleg | Data | 09/12/2013
//---------------------------------------------------------------------
// Descr. | Rotina acionada pelo ponto de entrada FT300ABR. O objetivo
//        | é armazenar o estágio atual antes da gravação de alteração 
//        | acionada pelo apontamento FATA310 p/ FATA300. A variável
//        | que está armazenando é STATIC por estar sendo acionada em 
//        | momentos distintos.
//---------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------
User Function A310Arm( cStage )
	cAD1_STAGE := cStage
Return

//---------------------------------------------------------------------
// Rotina | A310Regra  | Autor | Robson Luiz - Rleg | Data | 21/01/2014
//---------------------------------------------------------------------
// Descr. | Rotina acionada pelo X3_VLDUSER do campo AD5_EVENTO.
//        | O objetivo é permitir a oportunidade avançar ou retrocer 
//        | somente os estágio estabelecidos. Caso o processo de venda
//        | não possua regra, a rotina não será executada na íntegra.
//        | O função pode ser habilitada/desabilitada por parâmetro.
//---------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------
User Function A310Regra()
	Local lRet := .T.
	Local nACZ_OPER := 0
	Local cMV_310REGR := 'MV_310REGR'
	//--------------------------------------------------------------------
	// Se o estágio a ser mudado for diferente do estágio atual, seguir...
	//--------------------------------------------------------------------
	If Left( M->AD5_EVENTO, 3 ) <> Left( AD1->AD1_STAGE, 3 )
		//-----------------------------------
		// Se não existir o parâmetro, criar.
		//-----------------------------------
		If .NOT. SX6->( ExisteSX6( cMV_310REGR ) )
			CriarSX6( cMV_310REGR, 'L', 'HABILITAR OU DESABILITAR O USO DE REGRA NO APONTAMENTO DA OPORTUNIDADE. CSFA310.prw', '.T.' )
		Endif
		//------------------------------------------
		// Verificar se o parâmetro está habilitado.
		//------------------------------------------
		If GetMv( cMV_310REGR )
			nACZ_OPER := Iif( INCLUI, 1, Iif( ALTERA, 2, 3 ) )
			//---------------------------------------
			// Poscionar no registro da oportunidade.
			//---------------------------------------
			AD1->( dbSetOrder( 1 ) )
			If AD1->( dbSeek( xFilial( 'AD1' ) + M->AD5_NROPOR ) )
				//-----------------------------------------------------------------------------------------------------------
				// Posicionar na tabela Regras do Processo de Venda (ACZ) para saber qual estágio pode avançar ou retroceder.
				//-----------------------------------------------------------------------------------------------------------
				ACZ->( dbSetOrder( 2 ) )
				If ACZ->( dbSeek( xFilial( 'ACZ' ) + AD1->AD1_PROVEN + LTrim( Str( nACZ_OPER ) ) + AD1->AD1_STAGE ) )
					//---------------------------------------------
					// Capturar a regra para avançar ou retroceder.
					//---------------------------------------------
					cACZ_REGRA := RTrim( ACZ->ACZ_REGRA )
					//---------------------------
					// Se houver regra, seguir...
					//---------------------------
					If .NOT. Empty( cACZ_REGRA )
						//-----------------------------------------------------------------------------
						// Se o prefixo do estágio a ser mudado não estiver contido na regra, seguir...
						//-----------------------------------------------------------------------------
						If ( .NOT. ( Left( M->AD5_EVENTO, 3 ) $ cACZ_REGRA) )
							MsgAlert('O estágio atual da Oportunidade é '+Left( AD1->AD1_STAGE, 3 )+;
							' e a regra permite que o movimento do apontamento vá para o(s) estágio(s): '+cACZ_REGRA+;
							', por isso não será possível concluir esta operação.','A310Regra | Regra de Apontamento')
							lRet := .F.
						Endif
					Endif
				Endif
	      Endif
		Endif
	Endif
Return( lRet )

//-----------------------------------------------------------------------
// Rotina | UPDA310 | Autor | Robson Gonçalves        | Data | 21.01.2014
//-----------------------------------------------------------------------
// Descr. | Rotina de update.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function UPDA310()
	Local cX3_VLDUSER := ''
	Local cOperador := ' .And. '
	Local nP := 0
	Local aDADOS := {}
	If ACZ->( FieldPos( 'ACZ_REGRA' ) ) > 0
		If MsgYesNo('Confirma a manutenção no dicionário de dados?','UPDA310')
			SX3->( dbSetOrder( 2 ) )
			If SX3->( dbSeek( 'AD5_EVENTO' ) )
				If .NOT. ('A310REGRA' $ Upper( RTrim( SX3->X3_VLDUSER ) ) )
					cX3_VLDUSER := RTrim( SX3->X3_VLDUSER )
					SX3->( RecLock( 'SX3', .F. ) )
					SX3->X3_VLDUSER := cX3_VLDUSER + Iif( Empty( cX3_VLDUSER ), '', cOperador ) + 'U_A310Regra()'
					SX3->( MsUnLock() )
					MsgInfo('Operação realizada com sucesso!','UPDA310')
				Else
					MsgInfo('Função já aplicada no dicionário de dados X3_VLDUSER campo AD5_EVENTO.','UPDA310')
				Endif
			Endif
		Endif	
		
		// [1]-ACZ_PROVEN
		// [2]-ACZ_EVENTO
		// [3]-ACZ_STAGE
		// [4]-ACZ_REGRA
		AAdd(aDADOS,{"000001","000PRO","000PRO","001"})
		AAdd(aDADOS,{"000001","001IDE","001IDE","002"})
		AAdd(aDADOS,{"000001","002AED","002AED","003,001,004,007"})
		AAdd(aDADOS,{"000001","002CUR","002CUR","003,001,004,007"})
		AAdd(aDADOS,{"000001","002DNP","002DNP","003,001,004,007"})
		AAdd(aDADOS,{"000001","002QUA","002QUA","003,001,004,007"})
		AAdd(aDADOS,{"000001","002QUR","002QUR","003,001,004,007"})
		AAdd(aDADOS,{"000001","002VDS","003VDS","004,002"})
		AAdd(aDADOS,{"000001","003ANA","003ANA","004,002"})
		AAdd(aDADOS,{"000001","003DNP","003DNP","004,002"})
		AAdd(aDADOS,{"000001","003EAL","003EAL","004,002"})
		AAdd(aDADOS,{"000001","003ECL","003ECL","004,002"})
		AAdd(aDADOS,{"000001","003EPR","003EPR","004,002"})
		AAdd(aDADOS,{"000001","003FIR","003FIR","004,002"})
		AAdd(aDADOS,{"000001","003GOV","003GOV","004,002"})
		AAdd(aDADOS,{"000001","003ORC","003ORC","004,002"})
		AAdd(aDADOS,{"000001","003POC","003POC","004,002"})
		AAdd(aDADOS,{"000001","003PSA","003PSA","004,002"})
		AAdd(aDADOS,{"000001","003TER","003TER","004,002"})
		AAdd(aDADOS,{"000001","003VDS","003VDS","004,002"})
		AAdd(aDADOS,{"000001","004AFI","004AFI","005,003"})
		AAdd(aDADOS,{"000001","004AJU","004AJU","005,003"})
		AAdd(aDADOS,{"000001","004APR","004APR","005,003"})
		AAdd(aDADOS,{"000001","004CUR","004CUR","005,003"})
		AAdd(aDADOS,{"000001","004CUR","008CUR","005,003"})
		AAdd(aDADOS,{"000001","004DNP","004DNP","005,003"})
		AAdd(aDADOS,{"000001","004EAL","004EAL","005,003"})
		AAdd(aDADOS,{"000001","004FIR","004FIR","005,003"})
		AAdd(aDADOS,{"000001","004GOV","004GOV","005,003"})
		AAdd(aDADOS,{"000001","004INF","004INF","005,003"})
		AAdd(aDADOS,{"000001","004ORC","004ORC","005,003"})
		AAdd(aDADOS,{"000001","004TER","004TER","005,003"})
		AAdd(aDADOS,{"000001","004VDS","004VDS","005,003"})
		
		ACZ->( dbSetOrder( 1 ) )
		ACZ->( dbSeek( xFilial( 'ACZ' ) + '000001' ) )
		While .NOT. ACZ->( EOF() ) .And. ACZ->ACZ_FILIAL == xFilial( 'ACZ' ) .And. ACZ->ACZ_PROVEN == '000001'
			nP := AScan( aDADOS, {|p| p[ 1 ]==ACZ->ACZ_PROVEN .And. p[ 2 ]==ACZ->ACZ_EVENTO .And. p[ 3 ]==ACZ->ACZ_STAGE } )
			If nP > 0
				If Empty( ACZ->ACZ_REGRA )
					ACZ->( RecLock( 'ACZ', .F. ) )
					ACZ->ACZ_REGRA := aDADOS[ nP, 4 ]
					ACZ->( MsUnLock() )
				Endif
			Endif
			ACZ->( dbSkip() )
		End
		MsgInfo('Processamento finalizado com sucesso','UPDA310')
	Else
		MsgInfo('ATENÇÃO! O campo ACZ_REGRA não existe.','UPDA310')
	Endif	
Return

//-----------------------------------------------------------------------
// Rotina | UPD310     | Autor | Robson Gonçalves     | Data | 21.01.2014
//-----------------------------------------------------------------------
// Descr. | Rotina de update.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function UPD310()
	Local cModulo := 'FAT'
	Local bPrepar := {|| U_U310Ini() }
	Local nVersao := 01
	
	NGCriaUpd(cModulo,bPrepar,nVersao)
Return

//-----------------------------------------------------------------------
// Rotina | U310Ini    | Autor | Robson Gonçalves     | Data | 21.01.2014
//-----------------------------------------------------------------------
// Descr. | Rotina auxiliar do update.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function U310Ini()
	aSIX := {}
	aSX3 := {}
	aHelp := {}

	AAdd(aSX3,{'ACZ',NIL,'ACZ_REGRA','C',80,0,;                                                       //Alias,NIL,Campo,Tipo,Tamanho,Decimais
					'Regras','Regras','Regras',;                                                          //Tit. Port.,Tit.Esp.,Tit.Ing.
					'Estagios p/ avan ou retro','Estagios p/ avan ou retro','Estagios p/ avan ou retro',; //Desc. Port.,Desc.Esp.,Desc.Ing.
					'@!',;                                                                                //Picture
					'',;                                                                                  //Valid
					'€€€€€€€€€€€€€€ ',;                                                                   //Usado
					'',;                                                                                  //Relacao
					'',1,'þA','','',;                                                                     //F3,Nivel,Reserv,Check,Trigger
					'U','N','A','R',' ',;                                                                 //Propri,Browse,Visual,Context,Obrigat
					'',;	                                                                                //VldUser
					'','','',;                                                                            //Box Port.,Box Esp.,Box Ing.
					'','','','','',;                                                                      //PictVar,When,Ini BRW,GRP SXG,Folder
					'N','',''})                                                                           //Pyme,CondSQL,ChkSQL

	AAdd(aHelp,{'ACZ_REGRA', 'Regras para avançar e retroceder os estágios. Caso precise destabilitar a regra vá ao parâmetro MV_340REGR.'})
Return