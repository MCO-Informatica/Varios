//------------------------------------------------------------------------
// Rotina | MT120FIM | Robson Gon�alves                | Data | 15/09/2015
//------------------------------------------------------------------------
// Descr. | Ponto de entrada executado no final da grava��o do pedido de 
//        | compras. 
//------------------------------------------------------------------------
// Param  | Passagem: ParamIXB[1] - N�mero da op��o do menu da MBrowse.
//        |           ParamIXB[2] - N�mero do pedido de compras.
//        |           ParamIXB[3] - N�mero da op��o clicado pelo usu�rio.
//        | Retorno.: Nenhum retorno esperado pelo ponto de entrada.
//------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//------------------------------------------------------------------------
STATIC __cC7_FILENT__ := '' // Vari�vel encapsulada para ser usada no MT120FIM.
STATIC lNewCP610 := IIf( FindFunction( 'U_NewCP610' ) , U_NewCP610() , .F. )

User Function MT120FIM()
	Local cFilEnt := ''
	Local aArea := {}
	Local aParam := {}
	Local l_PDF_WF := .F.
	Local lIsBlind := IsBlind()
	Local cTRB := ''
	Local cAlias := Alias()
	Local cCR_NUM := PadR( SC7->C7_NUM, Len( SCR->CR_NUM ), ' ' )
		
	aParam := AClone( ParamIXB )
	
	// Caso seja MsExecauto for�ar o OK no par�metro.
	aParam[ 3 ] := Iif( lIsBlind .AND. ( aParam[ 3 ] == 0 ), 1, aParam[ 3 ] )
	
	// Armazenar filial + pedido para serem capturados posteriormente na execu��o da A610NGestor.
	If IsBlind()
		//[1]-Op��o da aRotina.
		//[2]-N� Pedido compras.
		//[3]-1=OK; 0=Cancel.
		U_A610SvPC( { aParam[ 1 ], aParam[ 2 ], aParam[ 3 ] } )
	Endif
	
	// Nova capa de despesa habilidata?
	If lNewCP610
		//------------------------------------------
		// Verificar se foi confirmado pelo usu�rio.
		If aParam[ 3 ] == 1
			//--------------------------------------------------------------------------------------
			// Gerar o documento f�sico da capa de despesa e anexar no Pedido de Compras em quest�o.
			If ( IsInCallStack( 'CNTA120' ) .OR. ;
			     IsInCallStack( 'MATA161' ) .OR. ;
			     IsInCallStack( 'MATA120' ) )
				//-----------------------------------------------------
				// Se for inclus�o ou altera��o/c�pia e foi confirmado.
				If aParam[ 1 ] >= 3 .AND. aParam[ 1 ] <= 4
					//------------------------------------------------
					// Se for altera��o do PC gerar o PDF, reenviar o WF e gerar SCR se n�o existir.
					cTRB := GetNextAlias()
					BEGINSQL ALIAS cTRB
						SELECT COUNT(*) AS SCR_COUNT
						FROM   %Table:SCR% SCR
						WHERE  CR_FILIAL = %xFilial:SC7%
						       AND CR_NUM = %Exp:cCR_NUM%
						       AND CR_TIPO = '#2' 
						       AND CR_STATUS = '02'
						       AND CR_DATALIB = ' '  
						       AND SCR.%NotDel%
					ENDSQL
					l_PDF_WF := ((cTRB)->SCR_COUNT > 0)
					(cTRB)->( dbCloseArea()) 
					
					dbSelectArea( cAlias )
				   //---------------------------------------------------------
				   // Se for funcionalidade MsExecAuto executar sem interface.
					If lIsBlind
						U_A610PDF( aParam[ 2 ], ,l_PDF_WF )
					Else
					   //-------------------------------------------------------------
					   // Se n�o for funcionalidade MsExecAuto executar com interface.
						MsAguarde( {|| U_A610PDF( aParam[ 2 ], ,l_PDF_WF ) }, 'Capa de despesa','Criar PDF e enviar workfow, aguarde...', .F. )
					Endif
				Else
					//-----------------------
					// Se for exclus�o do PC.
					If aParam[ 1 ] == 5
						U_A610DelPC( aParam[ 2 ] )
					Endif
				Endif
			Endif	
		Endif
	Else
		//----------------------------------------------------------------------------------------------------------------------
		// Primeiro objetivo: Fazer a grava��o da filial de entrega conforme selecionado no encerramento da medi��o do contrato.
		//----------------------------------------------------------------------------------------------------------------------
		// A rotina foi executada pela medi��o de contrato?
		If IsInCallStack('CNTA120')
			// A op��o de manuten��o da rotina MATA120 � INCLUIR e foi clicado em OK.
			If aParam[1]==3 .AND. aParam[3]==1
				aArea := SC7->( GetArea() )
				// Buscar o c�digo da filial de entrega informado.
				cFilEnt := U_R1FILENT()
				// Para todos os itens gravar a filial de entrega conforme informado.
				SC7->( dbSetOrder( 1 ) )
				SC7->( dbSeek( xFilial( 'SC7' ) + aParam[2] ) )
				While SC7->( .NOT. EOF() ) .AND. SC7->C7_FILIAL == xFilial( 'SC7' ) .AND. SC7->C7_NUM == aParam[2]
					SC7->( RecLock( 'SC7', .F. ) )
					SC7->C7_FILENT := cFilEnt
					SC7->( MsUnLock() )
					SC7->( dbSkip() )
				End
				RestArea( aArea )
			Endif
		Endif	
	Endif
	//------------------------------------------
	// Verificar se foi confirmado pelo usu�rio.
	If aParam[ 3 ] == 1
		//-----------------------------------------------
		// Se 3-Incluir ou 4-Alterar/Copiar ou 5-Excluir.
		If ( aParam[ 1 ] == 3 ) .OR. ( aParam[ 1 ] == 4 ) //.OR. ( aParam[ 1 ] == 5 )
			If .NOT. lIsBlind
				ProcessaDoc( {|| U_A610NGestor( aParam, lIsBlind ) }, 'Lan�amento de despesa' ,'Notificar o gestor.' )
			Endif
		Endif
	Endif

	//-- Replicar documentos 
	//-- Solicita��o/Cota��o/Medi��o > Pedido
	IF aParam[ 3 ] == 1 .And. aParam[ 1 ] == 3
		IF IsInCallStack( 'MATA120' )
			GetDocReplica( aParam[2], 'SOL' )
		EndIF
	EndIF
Return

//------------------------------------------------------------------------
// Rotina | R1FILENT | Robson Gon�alves                | Data | 04/02/2015
//------------------------------------------------------------------------
// Descr. | Rotina para devolver o conte�do da vari�vel STATIC no contexto 
//        | encapsulada, onde ser� utilizada no ponto de entrada MT120FIM.
//------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//------------------------------------------------------------------------
User Function R1FILENT()
Return(__cC7_FILENT__)

Static Function GetDocReplica( cPedido, cOrigem )
	Local cTRB	:= ''

	IF cOrigem == 'SOL'
		cTRB := GetNextAlias()
        BeginSQL Alias cTRB
			SELECT 	C7_NUMSC, C7_ITEM
			FROM %Table:SC7% SC7 
			WHERE  SC7.%NOTDEL%
				AND C7_FILIAL = %xFilial:SC7%
				AND C7_NUM = %Exp:cPedido%
				AND C7_NUMSC > ' ' 
			GROUP BY C7_NUMSC, C7_ITEM
		EndSQL

		While .NOT. (cTRB)->( EOF() )
        	U_CSReplica( 'SC1', 'SC7', (cTRB)->C7_NUMSC, xFilial('SC7') + cPedido + (cTRB)->C7_ITEM )
            (cTRB)->( dbSkip() )
        End
	ElseIF cOrigem == 'MED'
		cTRB := GetNextAlias()
        BeginSQL Alias cTRB
			SELECT C7_CONTRA,
				C7_CONTREV,
				C7_PLANILH,
				C7_MEDICAO
			FROM %Table:SC7% SC7
			WHERE SC7.%NOTDEL%
				AND C7_FILIAL = %xFilial:SC7%
				AND C7_NUM = %Exp:cPedido%
				AND C7_CONTRA > ' '
			GROUP BY C7_CONTRA,
					C7_CONTREV,
					C7_PLANILH,
					C7_MEDICAO
		EndSQL

		While .NOT. (cTRB)->( EOF() )
			U_CSReplica( 'CND', 'SC7', (cTRB)->(C7_CONTRA+C7_CONTREV+C7_PLANILH+C7_MEDICAO), xFilial('SC7') + cPedido + '0001' )
			(cTRB)->( dbSkip() )
        End
	EndIF
Return