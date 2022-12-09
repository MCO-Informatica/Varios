#Include "Rwmake.ch"
#Include "Protheus.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �FtObra    � Autor �Sergio Silveira       � Data �06/12/2000 ���
�������������������������������������������������������������������������Ĵ��
���Descricao �Amarracao entidades x Obras                                 ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � Nenhum                                                     ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpC1 -> Entidade                                          ���
���          � ExpN1 -> Registro                                          ���
���          � ExpN2 -> Opcao                                             ���
���          � ExpX1 -> Sem Funcao                                        ���
���          � ExpN3 -> Tipo de Operacao                                  ���
�������������������������������������������������������������������������Ĵ��
���           Atualiza�oes sofridas desde a constru�ao inicial            ���
�������������������������������������������������������������������������Ĵ��
���Programador �Data      �Motivo da Altera�ao                            ���
�������������������������������������������������������������������������Ĵ��
���Cosme da    |05/08/2008|Personalizacao para tratar entidade especifica ���
���Silva Nunes |          |                                               ���
���            |          |                                               ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function FtObra( cAlias, nReg, nOpc, xVar, nOper )

Local aArea        := GetArea()
Local aPosObj      := {}
Local aObjects     := {}
Local aSize        := MsAdvSize( .F. )
Local aGet         := {}
Local aTravas      := {}
Local aEntidade    := {}
Local aRecZA5      := {}
Local aChave       := {}

Local cCodEnt      := ""
Local cNomEnt      := ""
Local cSeekZA5     := ""
Local cEntidade    := ""

Local lGravou      := .F.
Local lTravas      := .T.

Local nCntFor      := 0
Local nUsado       := 0
Local nPosItem     := 0
Local nOpcA        := 0
Local nScan        := 0

Local oDlg
Local oGetD
Local oGet
Local oGet2

PRIVATE aCols      := {}
PRIVATE aHeader    := {}

Private nOper      := 1

//������������������������������������������������������������������������Ŀ
//� Posiciona a entidade                                                   �
//��������������������������������������������������������������������������
cEntidade := cAlias
dbSelectArea( cEntidade )
MsGoto( nReg )

//������������������������������������������������������������������������Ŀ
//� Informa a chave de relacionamento de cada entidade e o campo descricao �
//��������������������������������������������������������������������������
aEntidade := MsRelation()

If !Empty( nScan := AScan( aEntidade, { |x| x[1] == cEntidade } ) )

	aChave   := aEntidade[ nScan, 2 ]
	cCodEnt  := MaBuildKey( cEntidade, aChave ) 
	
	cCodEnt  := PadR( cCodEnt, Len( ZA5->ZA5_CODENT ) )	
	cCodDesc := AllTrim( cCodEnt ) + "-" + Capital( Eval( aEntidade[ nScan, 3 ] ) ) 	

	If nOper <> 3

		SX2->( dbSetOrder( 1 ) )
		SX2->( dbSeek( cEntidade ) )

		cNomEnt := X2NOME()

		//������������������������������������������������������������������������Ŀ
		//�Montagem do Array do Cabecalho                                          �
		//��������������������������������������������������������������������������
		dbSelectArea("SX3")
		dbSetOrder(2)
		dbSeek("CTD_ITEM")
		aadd(aGet,{X3Titulo(),SX3->X3_PICTURE,SX3->X3_F3})

		//������������������������������������������������������������������������Ŀ
		//�Montagem do aHeader                                                     �
		//��������������������������������������������������������������������������
		dbSelectArea("SX3")
		dbSetOrder(1)
		dbSeek("ZA5")
		While ( !SX3->( Eof() ) .And. SX3->X3_ARQUIVO=="ZA5" )
			If ( X3Uso(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL .And. ;
					!AllTrim(SX3->X3_CAMPO)$"ZA5_ENTIDA|ZA5_CODENT" )
				nUsado++
				aadd(aHeader,{ AllTrim(X3Titulo()),;
					SX3->X3_CAMPO,;
					SX3->X3_PICTURE,;
					SX3->X3_TAMANHO,;
					SX3->X3_DECIMAL,;
					SX3->X3_VALID,;
					SX3->X3_USADO,;
					SX3->X3_TIPO,;
					SX3->X3_ARQUIVO,;
					SX3->X3_CONTEXT } )
/*				If ( AllTrim(SX3->X3_CAMPO)=="AA2_ITEM" )
					nPosItem := nUsado
				Endif
*/
			EndIf

			SX3->( dbSkip() )
		EndDo

		//������������������������������������������������������������������������Ŀ
		//�Montagem do aCols                                                       �
		//��������������������������������������������������������������������������
		dbSelectArea("ZA5")
		dbSetOrder(1)

		cSeekZA5 := xFilial( "ZA5" ) + cEntidade + xFilial( cEntidade ) + cCodEnt

		ZA5->( dbSetOrder( 2 ) )
		If ZA5->( MsSeek( cSeekZA5 ) )
			While ( !Eof() .And. cSeekZA5 == ZA5->ZA5_FILIAL + ZA5->ZA5_ENTIDA + ZA5->ZA5_FILENT + ZA5->ZA5_CODENT )

				If ( SoftLock("ZA5" ) )
					AAdd(aTravas,{ Alias() , RecNo() })
					AAdd(aCols,Array(nUsado+1))
					AAdd(aRecZA5, ZA5->( Recno() ) )
					For nCntFor := 1 To nUsado
						If ( aHeader[nCntFor][10] != "V" )
							aCols[Len(aCols)][nCntFor] := ZA5->(FieldGet(FieldPos(aHeader[nCntFor][2])))
						Else
							aCols[Len(aCols)][nCntFor] := CriaVar(aHeader[nCntFor,2])
						EndIf
					Next
					aCols[Len(aCols)][nUsado+1] := .F.
				Else
					lTravas := .F.
				EndIf
				ZA5->( dbSkip()   )
			EndDo
		EndIf

		If Empty( aCols )
			AAdd(aCols,Array(nUsado+1))
			For nCntFor := 1 To nUsado
				aCols[1,nCntFor] := CriaVar(aHeader[nCntFor,2], .F. )
			Next nCntFor
			aCols[1][nUsado+1] := .F.
		EndIf

		If ( lTravas )

			INCLUI := .T.

			AAdd( aObjects, { 100,  44, .T., .F. } )
			AAdd( aObjects, { 100, 100, .T., .T. } )

			aInfo   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 2 }
			aPosObj := MsObjSize( aInfo, aObjects )

			DEFINE MSDIALOG oDlg TITLE cCadastro FROM aSize[7],00 TO aSize[6],aSize[5] OF oMainWnd PIXEL

			@ 019,005 SAY OemToAnsi("Entidade") SIZE 040,009 OF oDlg PIXEL // "Entidade"
			@ 018,050 GET oGet  VAR cNomEnt SIZE 120,009 OF oDlg PIXEL WHEN .F.

			@ 032,005 SAY OemToAnsi("Identificacao") SIZE 040,009 OF oDlg PIXEL // "Identificacao"
			@ 031,050 GET oGet2 VAR cCodDesc SIZE 120,009 OF oDlg PIXEL WHEN .F.

			oGetd:=MsGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4], nOpc,"U_FtContLOK()","AlwaysTrue",,.T.,NIL,NIL,NIL,500)			
			ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||nOpcA:=1,If(oGetd:TudoOk(),oDlg:End(),nOpcA:=0)},{||oDlg:End()})

			If ( nOpcA == 1 )
				Begin Transaction
					lGravou := U_FtContGrv( cEntidade, cCodEnt, aRecZA5 )
					If ( lGravou )
						EvalTrigger()
						If ( __lSx8 )
							ConfirmSx8()
						EndIf
					EndIf
				End Transaction
			EndIf
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
		U_FtContGrv( cEntidade, cCodEnt, , .T. )
	EndIf

Else

	//������������������������������������������������������������������������Ŀ
	//� Se nao for exclusao, permite a exibicao de mensagens em tela           �
	//��������������������������������������������������������������������������
	If nOper <> 3
		Aviso( "Atencao !", "Nao existe obra relacionada ao cliente selecionado" + cAlias, { "Ok" } ) 	 //"Atencao !"###"Nao existe obra relacionada ao cliente selecionado"###"Ok"
	EndIf
EndIf 	

RestArea( aArea )

Return(lGravou)


/*
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Program   � FtContGrv� Autor � Sergio Silveira       � Data �06/12/2000 ���
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

User Function FtContGrv( cEntidade, cCodEnt, aRecZA5, lExclui )


Local cSeekZA5  := ""
Local lGravou   := .F.
Local lContGrv  := ExistBlock("OBRAGRV")

Local nLoop     := 0
Local nLoop2    := 0

DEFAULT lExclui := .F.

If lExclui

	cSeekZA5 := xFilial( "ZA5" ) + cEntidade + xFilial( cEntidade ) + cCodEnt
	ZA5->( dbSetOrder( 2 ) )
	If ZA5->( MsSeek( cSeekZA5 ) )
		lGravou := .T.
		While !ZA5->( Eof() ) .And. cSeekZA5 == ZA5->ZA5_FILIAL + ZA5->ZA5_ENTIDA + ;
				ZA5->ZA5_FILENT + ZA5->ZA5_CODENT
			RecLock( "ZA5", .F. )
			ZA5->( dbDelete() )
			ZA5->( MsUnLock() )
			ZA5->( dbSkip() )
		EndDo
	EndIf
Else

	For nLoop := 1 To Len( aCols )
		lGravou := .T.
		If GDDeleted( nLoop )
			If nLoop <= Len( aRecZA5 )
				ZA5->( MsGoto( aRecZA5[ nLoop ] ) )
				RecLock( "ZA5", .F. )
				ZA5->( dbDelete() )
				ZA5->( MsUnlock() )
			EndIf
		Else
			If nLoop <= Len( aRecZA5 )
				ZA5->( MsGoto( aRecZA5[ nLoop ] ) )
				RecLock( "ZA5", .F. )
			Else
				//������������������������������������������������������������������������Ŀ
				//� Inclui e grava os campos chave                                         �
				//��������������������������������������������������������������������������
				RecLock( "ZA5", .T. )
				ZA5->ZA5_FILIAL := xFilial( "ZA5" )
				ZA5->ZA5_FILENT := xFilial( cEntidade )
				ZA5->ZA5_ENTIDA := cEntidade
				ZA5->ZA5_CODENT := cCodEnt
			EndIf

			//������������������������������������������������������������������������Ŀ
			//� Grava os demais campos                                                 �
			//��������������������������������������������������������������������������
			For nLoop2 := 1 To Len( aHeader )
				If ( aHeader[nLoop2,10] <> "V" ) .And. !( AllTrim( aHeader[nLoop2,2] ) $ "ZA5_FILENT|ZA5_ENTIDA|ZA5_CODENT" )
					ZA5->(FieldPut(FieldPos(aHeader[nLoop2,2]),aCols[nLoop,nLoop2]))
				EndIf
			Next nLoop2

			If ( lContGrv )
				ExecBlock("CONTGRV",.F.,.F.)
			EndIf

			ZA5->( MsUnlock() )

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

User Function FtContLOK()

Local lRet    := .T.
Local nPosCod := GDFieldPos( "ZA5_CODCON" )
Local nLoop   := 0

If !GDDeleted()

	If Empty( GDFieldGet( "ZA5_CODCON" ) )
		lRet := .F.
	EndIf

	If lRet
		For nLoop := 1 To Len( aCols )
			//������������������������������������������������������������������������Ŀ
			//� Verifica se existe codigo de contato duplicado                         �
			//��������������������������������������������������������������������������
			If nLoop <> n .And. !GDDeleted( nLoop )
				If aCols[ nLoop, nPosCod ] == GDFieldGet( "ZA5_CODCON" )
					lRet := .F.
					Help( "", 1, "FTOBRADUP" )
				EndIf
			EndIf
		Next nLoop
	EndIf

EndIf

Return( lRet )