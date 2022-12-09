#INCLUDE "PROTHEUS.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MA030ROT �Autor  �  Daniel   Gondran    Data �  25/11/09   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada para adicionar botao ENTREGA no cadastro  ���
���          � de clientes para efetuar a amarra��o Cliente Fatura x      ���
���          � Cliente Entrega                                            ���
�������������������������������������������������������������������������͹��
���Uso       � MATA030                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MA030ROT()
	Local aRet := {}

	//oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "MA030ROT" , __cUserID )

	aAdd( aRet, { "Entrega", "U_FATENT", 0, 4 } )
	aAdd( aRet, { "Log Integ. SF", "U_SFLOGSHW", 0, 4 } )
	aAdd( aRet, { "Log Auditoria", "U_LOGAUDSHW", 0, 4 } )
Return aRet


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � FATENT   �Autor  �  Daniel   Gondran    Data �  25/11/09   ���
�������������������������������������������������������������������������͹��
���Desc.     � Amarracao Cliente Fatura x Cliente Entrega                 ���
���          �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � MATA030                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function FatEnt()
	Local aArea        := GetArea()
	Local aPosObj      := {}
	Local aObjects     := {}
	Local aSize        := MsAdvSize( .F. )
	Local aGet         := {}
	Local aTravas      := {}
	Local aEntidade    := {}
	Local aRecSZ5      := {}
	Local aChave       := {}

	Local cCodEnt      := ""
	Local cNomEnt      := ""
	Local cEntidade    := ""
	Local cUnico       := "" 
	Local nReg		   := SA1->(Recno())

	Local lGravou      := .F.
	Local lTravas      := .T.
	Local lAchou       := .F. 

	Local nCntFor      := 0
	Local nOpcA        := 3
	Local nScan        := 0
	Local nOpc		   := 4

	Local oDlg
	Local oGetD
	Local oGet
	Local oGet2

	Local	cSeek     := ""
	Local	cWhile    := ""
	Local aNoFields := {"Z5_ENTIDA","Z5_CLIF","Z5_LOJAF"}		
	Local bCond     := {|| .T.}	
	Local bAction1  := {|| U_VERSZ5(@aRecSZ5,@aTravas,@lTravas) }
	Local bAction2  := {|| .T.}	

	PRIVATE aCols      := {}
	PRIVATE aHeader    := {}

	PRIVATE nOper      := 1
	//������������������������������������������������������������������������Ŀ
	//� Posiciona a entidade                                                   �
	//��������������������������������������������������������������������������
	cEntidade := "SA1"
	dbSelectArea( cEntidade )
	MsGoto( nReg )
	//������������������������������������������������������������������������Ŀ
	//� Informa a chave de relacionamento de cada entidade e o campo descricao �
	//��������������������������������������������������������������������������
	/*
	aEntidade := MsRelation()

	nScan := AScan( aEntidade, { |x| x[1] == cEntidade } )

	lAchou := .F. 

	If Empty( nScan ) 

	//������������������������������������������������������������������������Ŀ
	//� Localiza a chave unica pelo SX2                                        �
	//��������������������������������������������������������������������������  
	SX2->( dbSetOrder( 1 ) ) 
	If SX2->( dbSeek( cEntidade ) )  

	If !Empty( SX2->X2_UNICO )       

	//������������������������������������������������������������������������Ŀ
	//� Macro executa a chave unica                                            �
	//��������������������������������������������������������������������������  
	cUnico   := SX2->X2_UNICO 
	cCodEnt  := &cUnico 
	cCodDesc := Substr( AllTrim( cCodEnt ), Len( SA1->A1_FILIAL ) + 1 )  
	lAchou   := .T. 

	EndIf 					

	EndIf 	   

	Else 

	aChave   := aEntidade[ nScan, 2 ]
	cCodEnt  := MaBuildKey( cEntidade, aChave ) 

	cCodDesc := AllTrim( cCodEnt ) + "-" + Capital( Eval( aEntidade[ nScan, 3 ] ) )    

	lAchou := .T. 

	EndIf 
	*/
	lAchou := .T.
	cCodEnt := SA1->A1_COD + SA1->A1_LOJA	
	cCodDesc := SA1->A1_NOME
	If lAchou 	

		//	cCodEnt  := PadR( cCodEnt, Len( AC8->AC8_CODENT ) )	

		If nOper <> 3

			//SX2->( dbSetOrder( 1 ) )
			//SX2->( DbSeek( cEntidade ) )

			FWSX2Util():GetFile( cEntidade ) 

			cNomEnt := X2NOME()

			//������������������������������������������������������������������������Ŀ
			//�Montagem do Array do Cabecalho                                          �
			//��������������������������������������������������������������������������
			//dbSelectArea("SX3")
			//dbSetOrder(2)
			//dbSeek("AA2_CODTEC")
			
			//aadd(aGet,{X3Titulo(),SX3->X3_PICTURE,SX3->X3_F3})

			//�������������������������������������������������������Ŀ
			//� Montagem do aHeader e aCols                           �
			//���������������������������������������������������������    
			//������������������������������������������������������������������������������������������������������������Ŀ
			//�FillGetDados( nOpcx, cAlias, nOrder, cSeekKey, bSeekWhile, uSeekFor, aNoFields, aYesFields, lOnlyYes,			�
			//�				  cQuery, bMountFile, lInclui )																			  			�
			//�nOpcx			- Opcao (inclusao, exclusao, etc). 																	     			�
			//�cAlias		- Alias da tabela referente aos itens																     			�
			//�nOrder		- Ordem do SINDEX																								  			�
			//�cSeekKey		- Chave de pesquisa																							  			�
			//�bSeekWhile	- Loop na tabela cAlias																						  			�
			//�uSeekFor		- Valida cada registro da tabela cAlias (retornar .T. para considerar e .F. para desconsiderar 	�
			//�				  o registro)																										     	�
			//�aNoFields	- Array com nome dos campos que serao excluidos na montagem do aHeader							     	�
			//�aYesFields	- Array com nome dos campos que serao incluidos na montagem do aHeader									�
			//�lOnlyYes		- Flag indicando se considera somente os campos declarados no aYesFields + campos do usuario		�
			//�cQuery		- Query para filtro da tabela cAlias (se for TOP e cQuery estiver preenchido, desconsidera      �
			//�	           parametros cSeekKey e bSeekWhiele) 																		      �
			//�bMountFile	- Preenchimento do aCols pelo usuario (aHeader e aCols ja estarao criados)								�
			//�lInclui		- Se inclusao passar .T. para qua aCols seja incializada com 1 linha em branco						�
			//�aHeaderAux	-																																�
			//�aColsAux		-																																�
			//�bAfterCols	- Bloco executado apos inclusao de cada linha no aCols														�
			//�bBeforeCols	- Bloco executado antes da inclusao de cada linha no aCols													�
			//��������������������������������������������������������������������������������������������������������������
			dbSelectArea("SZ5")
			cSeek  := xFilial( "SZ5" ) + cEntidade + cCodEnt
			cWhile := "SZ5->Z5_FILIAL + SZ5->Z5_ENTIDA + SZ5->Z5_CLIF + SZ5->Z5_LOJAF"
			FillGetDados(nOpc,"SZ5",2,cSeek,{|| &cWhile },{{bCond,bAction1,bAction2}},aNoFields,/*aYesFields*/,/*lOnlyYes*/,/*cQuery*/,/*bMontCols*/,/*Inclui*/,/*aHeaderAux*/,/*aColsAux*/,/*bAfterCols*/,/*bBeforeCols*/)

			If ( lTravas )

				INCLUI := .T.

				AAdd( aObjects, { 100,  44, .T., .F. } )
				AAdd( aObjects, { 100, 100, .T., .T. } )

				aInfo   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 2 }
				aPosObj := MsObjSize( aInfo, aObjects )

				DEFINE MSDIALOG oDlg TITLE cCadastro FROM aSize[7],00 TO aSize[6],aSize[5] OF oMainWnd PIXEL

				@ 019,005 SAY OemToAnsi("Cliente") SIZE 040,009 OF oDlg PIXEL 
				@ 018,050 GET oGet  VAR cNomEnt SIZE 120,009 OF oDlg PIXEL WHEN .F.

				@ 032,005 SAY OemToAnsi("Nome") SIZE 040,009 OF oDlg PIXEL 
				@ 031,050 GET oGet2 VAR cCodDesc SIZE 120,009 OF oDlg PIXEL WHEN .F.

				oGetd:=MsGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4], nOpc,"U_CliEOK","AlwaysTrue",,.T.,NIL,NIL,NIL,500,)			
				ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||nOpcA:=1,If(oGetd:TudoOk(),oDlg:End(),nOpcA:=0)},{||oDlg:End()})

				If nOpca == 1 
					Begin Transaction
						lGravou := U_GrvCliE( cEntidade, cCodEnt, aRecSZ5 )
						If ( lGravou )
							EvalTrigger()
							If ( __lSx8 )
								ConfirmSx8()
							EndIf
						EndIf
					End Transaction
				Endif
			EndIf
			If ( __lSx8 )
				RollBackSx8()
			EndIf
			For nCntFor := 1 To Len(aTravas)
				dbSelectArea(aTravas[nCntFor][1])
				dbGoto(aTravas[nCntFor][2])
				MsUnLock()
			Next nCntFor

		Else
			FtContGrv( cEntidade, cCodEnt, , .T. )
		EndIf

	Else

		//������������������������������������������������������������������������Ŀ
		//� Se nao for exclusao, permite a exibicao de mensagens em tela           �
		//��������������������������������������������������������������������������
		If nOper <> 3
			Aviso( "Atencao !", "Nao existe chave de relacionamento definida para o alias " + cAlias, { "Ok" } ) 	 //######
		EndIf
	EndIf 	

	RestArea( aArea )

Return(lGravou)




/*
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Program   � gtContGrv� Autor � Sergio Silveira       � Data �06/12/2000 ���
���������������������������������������������������������������������������Ĵ��
���Descri��o � Gravacao / Exclusao da amarracao                               ���
���������������������������������������������������������������������������Ĵ��
���Sintaxe   � ExpL1 := FtContGrv( ExpC1, ExpC2, ExpA1, [ExpL2] )             ���
���������������������������������������������������������������������������Ĵ��
���Retorno   � ExpL1 -> Indica se gravou                                      ���
���������������������������������������������������������������������������Ĵ��
���Parametros� ExpC1 -> Entidade                                              ���
���          � ExpC2 -> Codigo entidade                                    ���
���          � ExpA1 -> Array de registros                                    ���
���          � ExpL2 -> Indica se e exclusao                                  ���
���������������������������������������������������������������������������Ĵ��
��� ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                      ���
���������������������������������������������������������������������������Ĵ��
��� PROGRAMADOR  � DATA   � BOPS �  MOTIVO DA ALTERACAO                    ���
���������������������������������������������������������������������������Ĵ��
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
*/

User Function GrvCliE( cEntidade, cCodEnt, aRecSZ5, lExclui )


	Local cSeekSZ5  := ""
	Local lGravou   := .F.
	Local lContGrv  := ExistBlock("CONTGRV")

	Local nLoop     := 0
	Local nLoop2    := 0

	DEFAULT lExclui := .F.

	If lExclui

		cSeekSZ5 := xFilial( "SZ5" ) + cEntidade + cCodEnt
		SZ5->( dbSetOrder( 2 ) )
		If SZ5->( MsSeek( cSeekSZ5 ) )
			lGravou := .T.
			While !SZ5->( Eof() ) .And. cSeekSZ5 == SZ5->Z5_FILIAL + SZ5->Z5_ENTIDA + ;
			SZ5->Z5_CLIF + SZ5->Z5_LOJAF  
				RecLock( "SZ5", .F. )
				SZ5->( dbDelete() )
				SZ5->( MsUnLock() )
				SZ5->( dbSkip() )
			EndDo
		EndIf
	Else

		For nLoop := 1 To Len( aCols )
			lGravou := .T.
			If GDDeleted( nLoop )
				If nLoop <= Len( aRecSZ5 )
					SZ5->( MsGoto( aRecSZ5[ nLoop ] ) )
					RecLock( "SZ5", .F. )
					SZ5->( dbDelete() )
					SZ5->( MsUnlock() )
				EndIf
			Else
				If nLoop <= Len( aRecSZ5 )
					SZ5->( MsGoto( aRecSZ5[ nLoop ] ) )
					RecLock( "SZ5", .F. )
				Else
					//������������������������������������������������������������������������Ŀ
					//� Inclui e grava os campos chave                                         �
					//��������������������������������������������������������������������������
					RecLock( "SZ5", .T. )
					SZ5->Z5_FILIAL 	:= xFilial( "SZ5" )
					SZ5->Z5_ENTIDA 	:= cEntidade
					SZ5->Z5_CLIF   	:= Substr(cCodEnt,1,6)
					SZ5->Z5_LOJAF  	:= Substr(cCodEnt,7,2)
					SZ5->Z5_CLIE	:= aCols[nLoop,1]
					SZ5->Z5_LOJAE	:= aCols[nLoop,2]
				EndIf

				//������������������������������������������������������������������������Ŀ
				//� Grava os demais campos                                                 �
				//��������������������������������������������������������������������������
				For nLoop2 := 1 To Len( aHeader )
					If ( aHeader[nLoop2,10] <> "V" ) .And. !( AllTrim( aHeader[nLoop2,2] ) $ "Z5_ENTIDA|Z5_CLIF|Z5_LOJAF" )
						SZ5->(FieldPut(FieldPos(aHeader[nLoop2,2]),aCols[nLoop,nLoop2]))
					EndIf
				Next nLoop2

				SZ5->( MsUnlock() )

			EndIf

		Next nLoop

	EndIf

Return( lGravou )

/*
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Program   �FtContLOK � Autor � Sergio Silveira       � Data �08/12/2000 ���
���������������������������������������������������������������������������Ĵ��
���Descri��o � Validacao da linha da amarracao.                            ���
���������������������������������������������������������������������������Ĵ��
���Sintaxe   � ExpL1 := FtContLOK()                                           ���
���������������������������������������������������������������������������Ĵ��
���Retorno   � ExpL1 -> Validacao                                             ���
���������������������������������������������������������������������������Ĵ��
���Parametros� Nenhum                                                         ���
���������������������������������������������������������������������������Ĵ��
��� ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                      ���
���������������������������������������������������������������������������Ĵ��
��� PROGRAMADOR  � DATA   � BOPS �  MOTIVO DA ALTERACAO                    ���
���������������������������������������������������������������������������Ĵ��
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
*/

User Function CliEOK()
Return .T.

/*
Local lRet    := .T.
Local nPosCod := GDFieldPos( "AC8_CODCON" )
Local nLoop   := 0

If !GDDeleted()

If Empty( GDFieldGet( "AC8_CODCON" ) )
lRet := .F.
EndIf

If lRet
For nLoop := 1 To Len( aCols )
//������������������������������������������������������������������������Ŀ
//� Verifica se existe codigo de contato duplicado                         �
//��������������������������������������������������������������������������
If nLoop <> n .And. !GDDeleted( nLoop )
If aCols[ nLoop, nPosCod ] == GDFieldGet( "AC8_CODCON" )
lRet := .F.
Help( "", 1, "FTCONTDUP" )
EndIf
EndIf
Next nLoop
EndIf

EndIf

Return( lRet )
*/


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �FtVerAC8  � Autor � Marco Bianchi         � Data �02/01/2007���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Funcao disparada para validar cada registro da tabela      ���
���          � AC8, adicionar recno no array aRecAC8 utilizado na gravacao���
���          � cao da tabela AC8 e verificar se conseguiu travar AC8.     ���
���          � Se retornar .T. considera o registro.                      ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Logico                                                      ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpA1: Array com numero dos registros da tabela AC8         ���
���          �ExpA2: Array coim registros travados do AC8                 ���
���          �ExpL3: .T. se conseguiu travar AC8                          ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function VerSZ5(aRecSZ5,aTravas,lTravas)

	If ( SoftLock("SZ5" ) )
		AAdd(aTravas,{ Alias() , RecNo() })
		AAdd(aRecSZ5, SZ5->( Recno() ) )
	Else
		lTravas := .F.
	EndIf

Return(.T.)