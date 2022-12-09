//----------------------------------------------------------------------------
// Rotina | MT096SCR     | Autor | Robson Gon�alves - Rleg | Data | 09/01/2016
//----------------------------------------------------------------------------
// Descr. | Ponto de entrada que disponibiliza objeto da dialog no grupo de 
//        | aprovadores.
//----------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//----------------------------------------------------------------------------
// Passagem de par�metros - 1� Par�metro ->  PARAMIXB[1] -> Op��o que foi 
// ----------------------                    chamada a rotina (INC.EXC.VIS.ALT)
//                          2� Par�metro ->  PARAMIXB[2] -> Objeto oDlg que 
//                                           cont�m a MsDialog da atualiza��o do 
//                                           grupo de compras.
//----------------------------------------------------------------------------
#Include 'Protheus.ch'
User Function MT096SCR()
	Local aParam := {}
	Local cLinhaOK := ''
	Local cClassName := ''
	Local lChange := .F.
	Local lControls := .F.
	//---------------------------------------------------------------
	// Capturar os dados passados pelo par�metro do ponto de entrada.
	aParam := AClone( ParamIXB )
	//--------------------------------------------------
	// Se for a funcionalidade de Incluir ou de Alterar.
	If ( aParam[ 1 ] == 3 .OR. aParam[ 1 ] == 4 )
		//---------------------------------------------------------------------
		// Habilitar a consulta da situa��o de f�rias/afastamento do aprovador.
		If aParam[ 1 ] == 4
			SetKey( VK_F11 , {|| U_A610CSU() } ) //C=consulta S=situa��o U=usu�rio
		Endif
		//-------------------------------------------------------
		// Verificar se a estrutura do objeto export�veis existe.
		lControls := ( aParam[ 2 ]:aControls <> NIL )      .AND. ;
		             ( Len( aParam[ 2 ]:aControls ) >= 5 ) .AND. ;
		             ( aParam[ 2 ]:aControls[ 5 ]:ClassName() == 'MSBRGETDBASE' )
		If lControls 
			//------------------------------------------------------------------
			// Capturar o conte�do conforme as vari�veis de objetos export�veis.
			cClassName := RTrim( Upper( aParam[ 2 ]:aControls[ 5 ]:oMother:cClassName ) )
			cLinhaOK   := RTrim( Upper( aParam[ 2 ]:aControls[ 5 ]:oMother:cLinhaOK   ) )
			//------------------------------------------------------------------------
			// Verficar se o retorno do type � caractere e se o conte�do � o esperado.
			If lChange := ( ValType( cClassName ) == 'C' .AND. ;
			                ValType( cLinhaOK )   == 'C' .AND. ;
				             cClassName == 'MSGETDADOS'   .AND. ;
				             cLinhaOK   == 'A096LINOK' )
				//---------------------------------------------------------
				// Modificar o conte�do da instru��o LinhaOK da MsGetDados.
				aParam[ 2 ]:aControls[ 5 ]:oMother:cLinhaOK := 'U_A096LOK'
				//------------------------------
				// Atualizar o objeto principal.
				aParam[ 2 ]:Refresh()
			Endif
		Endif
	Endif
	
	If lChange
		A096ChkX3()
	Endif
Return

//----------------------------------------------------------------------------
// Rotina | A096ChkX3    | Autor | Robson Gon�alves - Rleg | Data | 09/01/2016
//----------------------------------------------------------------------------
// Descr. | Rotina respons�vel em retirar a valida��o do aprovador do campo
//        | no dicion�rio de dados (SX3).
//----------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//----------------------------------------------------------------------------
Static Function A096ChkX3()
	Local aArea := {}
	aArea := { SX3->( GetArea() ), SAL->( GetArea() ) }
	SX3->( dbSetOrder( 2 ) )
	SX3->( dbSeek( 'AL_APROV' ) )
	If 'A096APROV' $ Upper( RTrim( SX3->X3_VALID ) )
		SX3->( RecLock( 'SX3', .F. ) )
		SX3->X3_VALID := 'ExistCpo("SAK",M->AL_APROV)'
		SX3->( MsUnLock() )
	Endif
	AEval( aArea, {|xArea| RestArea( xArea ) } )
Return

//----------------------------------------------------------------------------
// Rotina | A096LOK      | Autor | Robson Gon�alves - Rleg | Data | 09/01/2016
//----------------------------------------------------------------------------
// Descr. | Esta rotina � uma c�pia da A096LinOK do padr�o MATA096. O objetivo
//        | � substituir a valida��o do campo AK_USER.
//----------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//----------------------------------------------------------------------------
User Function A096LOK()
	Local aArea		:= GetArea()
	Local nPosAprov := aScan(aHeader,{|x| AllTrim(x[2]) == "AL_APROV"})
	Local nPosNivel := aScan(aHeader,{|x| AllTrim(x[2]) == "AL_NIVEL"})
	Local nPosUser  := aScan(aHeader,{|x| AllTrim(x[2]) == "AL_USER"})
	Local cAprov    := aCols[n][nPosAprov]
	Local nX        := 0
	Local lRet      := .T.
	Local lDeleted  := .F.
	Local cAlias    := ''
	Local cIndex    := ''
	Local cFiltro   := ''
	Local lMT096DEL := ExistBlock("MT096DEL")
	Local lRetDel
	
	If Empty(aCols[n][nPosAprov]) .And. Empty(aCols[n][nPosNivel]) .And. n == 1
		lRet := .T.
	EndIf
	
	If ValType(aCols[n,Len(aCols[n])]) == "L"   // Verifico se posso Deletar
		lDeleted := aCols[n,Len(aCols[n])]      // Se esta Deletado
	EndIf
	
	If !lDeleted
		If Empty(aCols[n][nPosAprov]) .And. lRet
			Help(" ",1,"A096ABRANC")
			lRet := .F.
		Endif
		If Empty(aCols[n][nPosNivel]) .And. lRet
			Help(" ",1,"A096NIVEL")
			lRet := .F.
		Endif
	EndIf
	
	/*
	If lRet .And. !lDeleted
		SAK->(dbSetOrder(1))
		SAK->(MsSeek(xFilial("SAK")+cAprov))
		For nX := 1 to Len(aCols)
			If (cAprov == aCols[nX][nPosAprov] .Or. SAK->AK_USER == aCols[nX][nPosUser]).And. n != nX .And. !aCols[nX][Len(aCols[nX])]
				Help(" ",1,"JAGRAVADO")
				lRet := .F.
				Exit
			EndIf
		Next
	Endif
	*/
	  
	//�������������������������������������������������������������-Ŀ
	//� Nao permite excluir o aprovador do GRUPO DE APROVACAO, se    �
	//�                    houver pedido pendente para ser aprovado  �
	//������������������������������������������������������������-���                      
	If lRet .And. lDeleted
		SC7->(dbSetOrder(12))
		If SC7->(dbSeek(xFilial("SC7")+SAL->AL_COD))
			cAlias := "SCR"
			cIndex := CriaTrab(nil,.F.)
			cFiltro := "CR_FILIAL == '"+xFilial("SCR")+"' .AND. CR_TIPO='PC' .AND. CR_APROV='"+cAprov+"'"
		    IndRegua("SCR",cIndex,"CR_TIPO+CR_APROV",,cFiltro,'')
		    SC7->(dbSetOrder(1))
		   	While !SCR->(Eof())
				If SC7->(dbSeek(xFilial("SC7")+Padr(SCR->CR_NUM,Len(SC7->C7_NUM))))
					// Bloqueado aguardando outros niveis ou aguardando liberacao do proprio usuario
					If SC7->C7_APROV == SAL->AL_COD .And. SCR->CR_STATUS $ '01|02'
						If lMT096DEL
							lRetDel :=	ExecBlock("MT096DEL",.F.,.F.,)
							If ValType(lRetDel) == "L" .And. lRetDel
								MaAlcDoc({CR_NUM, CR_TIPO, CR_TOTAL,cAprov,,,,,,},,5)
								lRet := .T.
							Else 
								lRet := .F.
								Exit
							EndIf
						Else
							Help(" ",1,"A096APROV")
							lRet := .F.
							Exit
						EndIf
					EndIf
				Endif
				SCR->(dbSkip())
			Enddo
		    Ferase(cIndex+OrdBagExt())
		    RetIndex("SCR") 
	    EndIf
	Endif
	
	RestArea(aArea)
Return lRet