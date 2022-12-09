#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MT120LOK º Autor ³  Daniel   Gondran  º Data ³  28/04/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Ponto de Entrada para validar as licenças do produto na    º±±
±±º          ³ emissao do PC (Min.Exerc/PF/PC/                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Específico MAKENI                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function MT120LOK()
	Local _aArea 	 	:= GetArea()
	Local nPosProd	 	:= Ascan(aHeader,{|x| AllTrim(x[2]) == "C7_PRODUTO"})
	Local _lRet 		:= .T.
	Local _nDias		:= GetMv( "MV_AVISOLI" )
	Local _lExercito 	:= .F.
	Local _lPolFed		:= .F.
	Local _lPolCiv		:= .F.
	Local _lProdAc		:= .F.
	Local _ngrpHom	:= GetMv( "ES_GRPHML" )
	Local cCContab	:= Alltrim(aCols[n,GDFIELDPOS("C7_CONTA")])
	Local cCCusto	:= Alltrim(aCols[n,GDFIELDPOS("C7_CC")])
	Local cRateio	:= Alltrim(aCols[n,GDFIELDPOS("C7_RATEIO")])
	Local cItemCTA	:= Alltrim(aCols[n,GDFIELDPOS("C7_ITEMCTA")])
	Local cxItemCTA	:= Alltrim(aCols[n,GDFIELDPOS("C7_XITEMCT")])
	Local cCodProd	:= Alltrim(aCols[n,GDFIELDPOS("C7_PRODUTO")])
	Local _lExibeMsg	:= .T.
	Local cMsgMin	:=	""

/*BEGINDOC
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Validação do Centor de Custo e Conta Contabil³
//³Junior carvalho - TOTVS 01/07/2014           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	if !aCols[n] [len(aCols[n])]
		IF cRateio == "2"
			IF Empty(cCContab)
			Aviso("MT120LOK","Conta Contabil é obrigatório ",{"Voltar"},1)
			_lRet := .F.
			Else
			dbSelectArea("CT1")
			dbSetOrder(1)
			
				If MSSEEK(xFilial("CT1")+cCContab,.T.)
					If (CT1->CT1_CCOBRG == "1" .OR. SUBSTR(cCcontab,1,1)$'3567')
						If Empty(cCCusto)
						Aviso("PE1-MT120LOK","Centro de custo obrigatório para está conta contabil ",{"Voltar"},1)
						_lRet := .F.
						EndIf
						IF !(cEmpAnt $ '02|04')
							If  Empty(cItemCTA)
							Aviso("PE2-MT120LOK","Item Contabil é obrigatório. ",{"Voltar"},1)
							_lRet := .F.
							Endif
						
						//If (substr(cCContab,1,1) <>'1' .OR. substr(cCContab,1,1) <> '2') .AND. !Empty(cXItemCta)
							If !substr(cCContab,1,1) $'12' .AND. !Empty(cXItemCta)
							Aviso("PE3-MT120LOK","Campo Item Cont AF nao deve ser preenchido para produtos diferente de tipo AI - Ativo Fixo",{"Voltar"},1)
							_lRet := .F.
							Endif
						ENDIF
					elseIf !(cEmpAnt $ '02|04')
						if substr(cCContab,1,1) $'12' .AND. (!Empty(cCCusto)  .OR. !Empty(cItemCta))  // ALTERADO EM 160516 POR SANDRA NISHIDA, trava para item contabil.
					Aviso("PE4-MT120LOK","CCusto ou Item Cont nao pode ser preenchido para esta conta contabil ",{"Voltar"},1)
					_lRet := .F.
					// ALTERADO EM 03.05.16 POR SANDRA NISHIDA - INCLUIDO VALIDACAO PARA ITEM CONTABIL PARA ATIVO FIXO.
						ElseIf substr(cCContab,1,1) $'12' .AND. Empty(cXItemCta) .and. substr(cCodProd,1,2)$'AI'
					Aviso("PE5-MT120LOK","Campo Item Cont AF deve ser preenchido para produtos tipo AI - Ativo Fixo",{"Voltar"},1)
					_lRet := .F.
						ElseIf !substr(cCContab,1,1) $'12' .AND. !Empty(cXItemCta)
					Aviso("PE6-MT120LOK","Campo Item Cont AF nao deve ser preenchido para produtos diferente de tipo AI - Ativo Fixo",{"Voltar"},1)
					_lRet := .F.
						Endif
					Endif
				EndIf
			CT1->(dbCloseArea())
			Endif
		EndIf
	EndIf
/*ENDDOC*/


	if SB1->( dbSeek( xFilial("SB1") + aCols[n, nPosProd] ) )
		if SB1->B1_MINEXEC == "S"
		_lExercito := .T.
		endif
		if SB1->B1_POLFED == "S"
		_lPolFed := .T.
		endif
		if SB1->B1_POLCIV == "S"
		_lPolCiv := .T.
		endif
		if SB1->B1_TIPO == "PA"
		_lProdAc := .T.
		endif
	
	Endif

dbselectarea( "SA2" )

	if SA2->( dbSeek( xFilial( "SA2" ) + CA120FORN + CA120LOJ ) )
	
		If SA2->A2_XSITHOM == "N" .OR. EMPTY(SA2->A2_XSITHOM)
			if SB1->B1_TIPO == "MR"
			Aviso("MT120LOK","Fornecedor "+alltrim(SA2->A2_NREDUZ)+" não esta homologado para o Produto!",{"Voltar"},1)
			_lRet := .f.
			Endif
		
			if SB1->B1_TIPO == "SV" .AND. SB1->B1_COD $ _ngrpHom
			Aviso("MT120LOK","Fornecedor "+alltrim(SA2->A2_NREDUZ)+" não esta homologado para o Produto!",{"Voltar"},1)
			_lRet := .f.
			Endif
		
		Elseif SA2->A2_XSITHOM == "C" .AND. SA2->A2_XDTSITH < ddatabase
			if SB1->B1_TIPO == "MR"
			Aviso("MT120LOK","Fornecedor "+alltrim(SA2->A2_NREDUZ)+" não esta homologado para o Produto!",{"Voltar"},1)
			_lRet := .f.
			Endif
		
			if SB1->B1_TIPO == "SV" .AND. SB1->B1_COD $ _ngrpHom
			Aviso("MT120LOK","Fornecedor "+alltrim(SA2->A2_NREDUZ)+" não esta homologado para o Produto!",{"Voltar"},1)
			_lRet := .f.
			Endif
		
		Endif
		If Left(SA2->A2_EST,2) <> "EX"
			if _lExercito
			
			cMsgMin := iif( cEmpAnt == '02',"CRT !","Licença do Ministério do Exercito!" )
				if SA2->A2_MINEXE != "S"
				U_Exibir( "Fornecedor "+alltrim(SA2->A2_NREDUZ)+" não possui "+cMsgMin , _lExibeMsg )
				_lRet := .f.
				else
					if empty( SA2->A2_MELIC )
					U_Exibir( cMsgMin + " não esta preenchida para o Fornecedor "+alltrim(SA2->A2_NREDUZ)+"!", _lExibeMsg )
					_lRet := .f.
					else
						if SA2->A2_MEVALID < dDataBase
							if empty(SA2->A2_MEPROT)
							U_Exibir( cMsgMin + " do fornecedor "+alltrim(SA2->A2_NREDUZ) + " venceu dia "+dtoc(SA2->A2_MEVALID)+"!", _lExibeMsg )
							_lRet := .f.
							else
								if SA2->A2_MEVALPR < dDataBase
								U_Exibir( "Protocolo do "+cMsgMin+" do fornecedor "+;
								alltrim(SA2->A2_NREDUZ)+" venceu dia "+dtoc(SA2->A2_MEVALPR)+"!", _lExibeMsg )
								_lRet := .f.
								endif
							endif
						else
							if SA2->A2_MEVALID <= (dDataBase + _nDias)
							U_Exibir( "Data de validade da Licença do "+cMsgMin+" do fornecedor "+;
							alltrim(SA2->A2_NREDUZ)+" vencerá dia "+dtoc(SA2->A2_MEVALID)+"!", _lExibeMsg )
							endif
						endif
					endif
				endif
			endif
		
			if _lPolFed
				if SA2->A2_POLFED != "S"
				U_Exibir( "fornecedor "+alltrim(SA2->A2_NREDUZ)+" não possui Licença da Policia Federal!", _lExibeMsg )
				_lRet := .f.
				else
					if empty( SA2->A2_PFLIC )
					U_Exibir( "Licença da Policia Federal não esta preenchida para o fornecedor "+alltrim(SA2->A2_NREDUZ)+"!", _lExibeMsg )
					_lRet := .f.
					else
						if SA2->A2_PFVALID < dDataBase
							if empty(SA2->A2_PFPROT)
							U_Exibir( "Licença da Policia Federal do fornecedor "+;
							alltrim(SA2->A2_NREDUZ)+" venceu dia "+dtoc(SA2->A2_PFVALID)+"!", _lExibeMsg )
							_lRet := .f.
							else
								if SA2->A2_PFVALPR < dDataBase
								U_Exibir( "Protocolo da Policia Federal do fornecedor "+;
								alltrim(SA2->A2_NREDUZ)+" venceu dia "+dtoc(SA2->A2_PFVALPR)+"!", _lExibeMsg )
								_lRet := .f.
								endif
							endif
						else
							if SA2->A2_PFVALID <= (dDataBase + _nDias)
							U_Exibir( "Data de validade da Licença da Policia Federal do fornecedor "+;
							alltrim(SA2->A2_NREDUZ)+" vencerá dia "+dtoc(SA2->A2_PFVALID)+"!", _lExibeMsg )
							endif
						endif
					endif
				// Verificar amarracao cli x prod control by Daniel em 19/11/10----------------------------------
					if !( cEmpAnt == '02')
						If _lRet  .AND. ddatabase > getmv("MV_DTLIC") // Se passou pelo teste da licenca vai verificar a tabela de amarracao ZX6
						dbSelectArea("ZX6")
						ZX6->(dbSetOrder(1))
							If dbSeek(xFilial("ZX6") + SA2->A2_COD + SA2->A2_LOJA)  // Soh eventualmente bloqueia se o fornecedor estiver na tabela...
								If !dbSeek(xFilial("ZX6") + SA2->A2_COD + SA2->A2_LOJA + SB1->B1_POSIPI)       // E o NCM do produto nao esta!
								U_Exibir( "Licença da Policia Federal do Fornecedor " + AllTrim(SA2->A2_NREDUZ) + " OK, mas o NCM do produto " + AllTrim(SB1->B1_DESC) +;
								"(" + AllTrim(SB1->B1_POSIPI) + ") não consta na tabela de amarração Fornecedor x Produtos Controlados!", _lExibeMsg )
								_lRet := .F.
								Else					// Na validacao completa, se o fornecedor nao estiver cadastrado na tabela, nao deixa liberar
								ExibirMsg( "Licença da Policia Federal do Fornecedor " + AllTrim(SA2->A2_NREDUZ) + " OK, mas o mesmo não consta na tabela de amarração Fornecedor x Produtos Controlados!", _lExibeMsg )
								_lRet := .F.
								Endif
							Endif
						Endif
					Endif
				//-----------------------------------------------------------------------------------------------
				endif
			endif
		
			if _lPolCiv
				if SA2->A2_POLCIV != "S"
				U_Exibir( "fornecedor "+alltrim(SA2->A2_NREDUZ)+" não possui Licença da Policia Civil!", _lExibeMsg )
				_lRet := .f.
				else
					if empty( SA2->A2_PCLIC )
					U_Exibir( "Licença da Policia Civil não esta preenchida para o fornecedor "+alltrim(SA2->A2_NREDUZ)+"!", _lExibeMsg )
					_lRet := .f.
					else
						if SA2->A2_PCVALID < dDataBase
							if empty(SA2->A2_PCPROT)
							U_Exibir( "Licença da Policia Civil do fornecedor "+;
							alltrim(SA2->A2_NREDUZ)+" venceu dia "+dtoc(SA2->A2_PCVALID)+"!", _lExibeMsg )
							_lRet := .f.
							else
								if SA2->A2_PCVALPR < dDataBase
								U_Exibir( "Protocolo da Policia Civil do fornecedor "+;
								alltrim(SA2->A2_NREDUZ)+" venceu dia "+dtoc(SA2->A2_PCVALPR)+"!", _lExibeMsg )
								_lRet := .f.
								endif
							endif
						else
							if SA2->A2_PCVALID <= (dDataBase + _nDias)
							U_Exibir( "Data de validade da Licença da Policia Civil do fornecedor"+;
							alltrim(SA2->A2_NREDUZ)+" vencerá dia "+dtoc(SA2->A2_PCVALID)+"!", _lExibeMsg )
							endif
						endif
					endif
				endif
			endif
		
			if _lProdAc
			
				if SA2->A2_VISALF == "S"
					if empty( SA2->A2_VLFLIC )
					U_Exibir( "Licença VISA LF não esta preenchida para o fornecedor "+alltrim(SA2->A2_NREDUZ)+"!", _lExibeMsg )
					_lRet := .f.
					else
						if SA2->A2_VLFVLD < dDataBase
							if empty(SA2->A2_VLFPROT)
							U_Exibir( "Licença VISA LF do fornecedor "+;
							alltrim(SA2->A2_NREDUZ)+" venceu dia "+dtoc(SA2->A2_VLFVLD)+"!", _lExibeMsg )
							_lRet := .f.
							else
								if SA2->A2_VLFVALP < dDataBase
								U_Exibir( "Protocolo VISA LF do fornecedor "+;
								alltrim(SA2->A2_NREDUZ)+" venceu dia "+dtoc(SA2->A2_VLFVALP)+"!", _lExibeMsg )
								_lRet := .f.
								endif
							endif
						else
							if SA2->A2_VLFVLD <= (dDataBase + _nDias)
							U_Exibir( "Data de validade da Licença VISA LF do fornecedor "+;
							alltrim(SA2->A2_NREDUZ)+" vencerá dia "+dtoc(SA2->A2_VLFVLD)+"!", _lExibeMsg )
							endif
						endif
					endif
				endif
			
				if SA2->A2_ANVISA1 == "S"
					if empty( SA2->A2_AFELIC )
					U_Exibir( "Licença ANVISA AFE não esta preenchida para o fornecedor "+alltrim(SA2->A2_NREDUZ)+"!", _lExibeMsg )
					_lRet := .f.
					else
						if SA2->A2_AFEVLD < dDataBase
							if empty(SA2->A2_AFEPROT)
							U_Exibir( "Licença ANVISA AFE do fornecedor "+;
							alltrim(SA2->A2_NREDUZ)+" venceu dia "+dtoc(SA2->A2_AFEVLD)+"!", _lExibeMsg )
							_lRet := .f.
							else
								if SA2->A2_AFEVALP < dDataBase
								U_Exibir( "Protocolo ANVISA AFE do fornecedor "+;
								alltrim(SA2->A2_NREDUZ)+" venceu dia "+dtoc(SA2->A2_AFEVALP)+"!", _lExibeMsg )
								_lRet := .f.
								endif
							endif
						else
							if SA2->A2_AFEVLD <= (dDataBase + _nDias)
							U_Exibir( "Data de validade da Licença ANVISA AFE do fornecedor "+;
							alltrim(SA2->A2_NREDUZ)+" vencerá dia "+dtoc(SA2->A2_AFEVLD)+"!", _lExibeMsg )
							endif
						endif
					endif
				endif
			
				if SA2->A2_ANVISA2 == "S"
					if empty( SA2->A2_AELIC )
					U_Exibir( "Licença ANVISA AE não esta preenchida para o fornecedor "+alltrim(SA2->A2_NREDUZ)+"!", _lExibeMsg )
					_lRet := .f.
					else
						if SA2->A2_AEVLD < dDataBase
							if empty(SA2->A2_AEPROT)
							U_Exibir( "Licença ANVISA AE do fornecedor "+;
							alltrim(SA2->A2_NREDUZ)+" venceu dia "+dtoc(SA2->A2_AEVLD)+"!", _lExibeMsg )
							_lRet := .f.
							else
								if SA2->A2_AEVALPR < dDataBase
								U_Exibir( "Protocolo ANVISA AE "+;
								alltrim(SA2->A2_NREDUZ)+" venceu dia "+dtoc(SA2->A2_AEVALPR)+"!", _lExibeMsg )
								_lRet := .f.
								endif
							endif
						else
							if SA2->A2_AEVLD <= (dDataBase + _nDias)
							U_Exibir( "Data de validade da Licença ANVISA AE do fornecedor "+;
							alltrim(SA2->A2_NREDUZ)+" vencerá dia "+dtoc(SA2->A2_AEVLD)+"!", _lExibeMsg )
							endif
						endif
					endif
				endif
			
				if SA2->A2_MAPA == "S"
					if empty( SA2->A2_MAPALIC )
					U_Exibir( "Licença MAPA não esta preenchido para o fornecedor "+alltrim(SA2->A2_NREDUZ)+"!", _lExibeMsg )
					_lRet := .f.
					else
						if SA2->A2_MAPAVLD < dDataBase
							if empty(SA2->A2_MAPAPRO)
							U_Exibir( "Licença MAPA do fornecedor "+;
							alltrim(SA2->A2_NREDUZ)+" venceu dia "+dtoc(SA2->A2_MAPAVLD)+"!", _lExibeMsg )
							_lRet := .f.
							else
								if SA2->A2_MAPAVLP < dDataBase
								U_Exibir( "Protocolo MAPA do fornecedor "+;
								alltrim(SA2->A2_NREDUZ)+" venceu dia "+dtoc(SA2->A2_MAPAVLP)+"!", _lExibeMsg )
								_lRet := .f.
								endif
							endif
						else
							if SA2->A2_MAPAVLD <= (dDataBase + _nDias)
							U_Exibir( "Data de validade da Licença MAPA do fornecedor "+;
							alltrim(SA2->A2_NREDUZ)+" vencerá dia "+dtoc(SA2->A2_MAPAVLD)+"!", _lExibeMsg )
							endif
						endif
					endif
				endif
			endif
		endif
	
	/*
		If ! U_IsSintegra()
	Return .t.
		Endif
	*/
		//Se o Estado do Fornecedor for "EX", nao validar em nenhuma consulta Periodica
		If Left(SA2->A2_EST,2) == "EX"
			_lRet:= .T.
		ElseIF _lRet
			_lRet := U_VLDLICFOR(CA120FORN, CA120LOJ) // VALIDA LICENCAS FORNECEDOR
		Endif
	Endif

	RestArea(_aArea)
Return(_lRet)


User Function Exibir( _cMsg, _lExibe )

	if _lExibe
		MessageBox(_cMsg,"Atenção",48)
	endif

return( .T. )
