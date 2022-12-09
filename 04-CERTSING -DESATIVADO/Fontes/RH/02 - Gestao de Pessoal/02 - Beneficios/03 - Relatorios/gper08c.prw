#INCLUDE "PROTHEUS.CH"
#INCLUDE "GPER008.CH"

/*/
�������������������������������������������������������������������������������������������
�������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������Ŀ��
���Fun��o    	� GPER008    � Autor � Mauricio Takakura     	      � Data � 05/11/11 ���
���������������������������������������������������������������������������������������Ĵ��
���Descri��o 	� Relatorio de Conferencia do Calculo de Planos de Saude       			���
���������������������������������������������������������������������������������������Ĵ��
���Sintaxe   	� GPER008()                                                    			���
���������������������������������������������������������������������������������������Ĵ��
��� Uso      	� Generico ( DOS e Windows )                                   			���
���������������������������������������������������������������������������������������Ĵ��
���         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.               			���
���������������������������������������������������������������������������������������Ĵ��
���Programador  � Data     � FNC			�  Motivo da Alteracao                      ���
���������������������������������������������������������������������������������������Ĵ��
���Mauricio T.  �05/11/2011�                �Criacao novo fonte.                        ���
���Luis Ricardo �14/12/2011�00000032043/2011�Ajuste na query para incluir o campo Tp. 	���
���Cinalli		�		   �Chamado: TEDB33	�Fornec. na ordem e corrigir a sequencia de	���
���				�		   �				�impressao dos agregados no relatorio.		���
���				�19/12/2011�				�Ao trocar Origem limpa o Codigo Usuario	���
���				�		   �				�para forcar impressao do 1o nome.			���
���Luis Ricardo �03/01/2012�00000033643/2011�Ajuste para permitir a impressao de acordo	���
���Cinalli		�		   �Chamado: TEGFW4	�com a data de referencia, independente de	���
���				�		   �				�ser maior que o param MV_FOLMES.			���
���Mauricio T.  �09/01/2012�00000030820/2011�Tratamento para Periodos da Nova Folha de  ���
���             �		   �TECFVT	   	    �Pagamentos - Gestao Publica.               ���
����������������������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������������������
�������������������������������������������������������������������������������������������*/
User function GPER08C()

	Local aArea		:= SRA->(GetArea())
	Local aOrd    	:= {OemToAnsi(STR0004), OemToAnsi(STR0006), OemToAnsi(STR0007)	} // "Centro de Custo + Matricula"###"Matricula"###"Nome"

	Local cDesc1  	:= OemToAnsi( STR0001 ) // "Relatorio do Calculo de Planos de Saude"
	Local cDesc2  	:= OemToAnsi( STR0002 ) // "Sera impresso de acordo com os parametros solicitados "
	Local cDesc3  	:= OemToAnsi( STR0003 ) // "pelo usuario."
	Local cAliasSRA	:= "SRA"  				// Alias do arquivo principal (Base)
	
	Local cFolMes 	:= GetMv( "MV_FOLMES",,Space(08) ) 

	/*
	��������������������������������������������������������������Ŀ
	� Define Variaveis Private(Basicas)                            �
	����������������������������������������������������������������*/
	Private lGSP := If( GetMv( "MV_GSPUBL",, "1" ) == "1", .F., .T. ) // Gestao Publica 1=Nao; 2=Sim

	Private aReturn  := {"Zebrado",1,"Administracao",2,2,1,"",1 }	//"Zebrado"###"Administra��o"
	Private NomeProg := "GPER008"
	Private aLinha   := {}
	Private nLastKey := 0
	Private cPerg    := "GPER008"
	If lGSP
		cPerg    := "GPER008A"
	EndIf
	
	/*
	��������������������������������������������������������������Ŀ
	� Define Variaveis Private(Programa)                           �
	����������������������������������������������������������������*/
	Private aInfo     := {}
	
	/*
	��������������������������������������������������������������Ŀ
	� Variaveis Utilizadas na funcao IMPR                          �
	����������������������������������������������������������������*/
	Private Titulo
	Private AT_PRG   := "GPER008"
	
	Private wCabec0  := 1
	Private wCabec1  := OemToAnsi(STR0009) // "Tipo            Matr/Seq Nome                           Lancamento          Tp Fornec          Fornecedor               Tp Plano              Cod Plano         Vlr. Func        Vlr. Empresa    Total"
	Private Li       := 0
	Private nTamanho := "G"
	Private CONTFL	 := 1
	
	/*
	��������������������������������������������������������������Ŀ
	� Verifica as perguntas selecionadas                           �
	����������������������������������������������������������������*/
	Pergunte(cPerg,.F.)
	
	Titulo := OemToAnsi( STR0001 ) // "Relatorio do Calculo de Planos de Saude"
	
	/*
	��������������������������������������������������������������Ŀ
	� Envia controle para a funcao SETPRINT                        �
	����������������������������������������������������������������*/
	wnrel	:=	"GPER008"            //Nome Default do relatorio em Disco
	wnrel	:=	SetPrint(cAliasSRA, wnrel, cPerg, Titulo, cDesc1, cDesc2, cDesc3, .F., aOrd,,nTamanho)
	
	/*
	��������������������������������������������������������������Ŀ
	� Carregando variaveis mv_par?? para Variaveis do Sistema.     �
	����������������������������������������������������������������*/
	nOrdem     	:= aReturn[8]
	
	If !lGSP
		dDataRef	 :=	mv_par01	//	Data de Referencia - Competencia
		cAnoMes		 :=	Substr(DTOS( dDataRef ), 1, 6)
		cFilDe     	 := mv_par02 	// Filial De
		cFilAte    	 := mv_par03		// Filial Ate
		cMatDe     	 := mv_par04		// Matricula De
		cMatAte    	 := mv_par05		// Matricula Ate
		cNomeDe    	 := mv_par06		// Nome De
		cNomeAte   	 := mv_par07		// Nome Ate
		cCcDe      	 := mv_par08		// Centro de Custo De
		cCcAte     	 := mv_par09		// Centro de Custo Ate
		cCategoria 	 := mv_par10 	 // Categoria do Funcionario
		cSituacao  	 := mv_par11		// Situacao do Funcionario
		lAnalitico	 := If(mv_par12==1,.T.,.F.) // Se a impressao e analitica      
		nTipoFor_    := mv_par13               // Tipo Fornecedor: 1-Ass.Med 2-Ass.Odonto 3-Ambas  - mariella 
		lMovAberto 	 := .T.

		If cAnoMes < cFolMes
			lMovAberto := .F.
		EndIf

		Titulo += "    "  + OemToAnsi(STR0027) + Substr(cAnoMes,5,2) + " / " + Substr(cAnoMes,1,4)   // "Compet�ncia: "

	Else
		cProces		:= mv_par01		// Processo
		cRoteiro	:= mv_par02		// Roteiro
		cPeriodo	:= mv_par03 	// Periodo
		cNumPagto	:= mv_par04		// Numero de Pagamento
		cFilDe     	:= mv_par05 	// Filial De
		cFilAte    	:= mv_par06		// Filial Ate
		cMatDe     	:= mv_par07		// Matricula De
		cMatAte    	:= mv_par08		// Matricula Ate
		cNomeDe    	:= mv_par09		// Nome De
		cNomeAte   	:= mv_par10		// Nome Ate
		cCcDe      	:= mv_par11		// Centro de Custo De
		cCcAte     	:= mv_par12		// Centro de Custo Ate
		cCategoria 	:= mv_par13 	// Categoria do Funcionario
		cSituacao  	:= mv_par14		// Situacao do Funcionario
		lAnalitico	:= If(mv_par15==1,.T., .F.) // Se a impressao e analitica
		lMovAberto 	:= .T.
		
		// Validar o Periodo Selecionado
		DbSelectArea( "RCH" ) 
		DbSetOrder( RetOrdem( "RCH", "RCH_FILIAL+RCH_PROCES+RCH_PER+RCH_NUMPAG+RCH_ROTEIR" ) )
		DbSeek( xFilial( "RCH" ) + cProces + cPeriodo + cNumPagto + cRoteiro, .F. )
		If Eof()
			DbSeek( xFilial( "RCH" ) + cProces + cPeriodo + cNumPagto +  Space( GetSx3Cache("RCH_ROTEIR","X3_TAMANHO" )), .F. )
		EndIf
		If Eof()
			Help(,,'HELP',,OemToAnsi(STR0031),1,0)	//"Periodo Informado nao Cadastrado! "
			Return
		EndIf
		
		If !Empty(RCH->RCH_DTFECH)
			lMovAberto 	:= .F.
		EndIf
		
		Titulo += "    "  + OemToAnsi(STR0032) + cPeriodo + " / " + cNumPagto + "  / " + cRoteiro //"Periodo: "

	EndIf
	
	If nLastKey = 27
		Return
	Endif
	
	SetDefault(aReturn,cAliasSRA)
	
	If nLastKey = 27
		Return
	Endif

	RptStatus({|lEnd| ProcImp(@lEnd,wnRel,cAliasSRA)},Titulo)
	
	RestArea(aArea)

Return

/*                                	
�����������������������������������������������������������������������Ŀ
�Fun��o    � ProcImp		�Autor� Mauricio Takakura � Data �05/11/2011�
�����������������������������������������������������������������������Ĵ
�Descri��o �Impressao do Relatorio                                      �
�����������������������������������������������������������������������Ĵ
�Sintaxe   �< Vide Parametros Formais >									�
�����������������������������������������������������������������������Ĵ
� Uso      �ALL			                                                �
�����������������������������������������������������������������������Ĵ
� Retorno  �aRotina														�
�����������������������������������������������������������������������Ĵ
�Parametros�< Vide Parametros Formais >									�
�������������������������������������������������������������������������*/
Static Function ProcImp(lEnd, WnRel, cAliasSRA)

	/*
	��������������������������������������������������������������Ŀ
	� Define Variaveis Locais (Programa)                           �
	����������������������������������������������������������������*/
	Local cQuery	 	:= ""
	Local cOrder	 	:= ""
	Local cInicio  		:= ""
	Local cFim     		:= ""
	
	Private cAliasQ		:= "SRA"
	Private cFilialAnt 	:= "  "
	Private cCcAnt     	:= Space(20)
	Private cMatAnt    	:= space(08)
	Private cTpOrigem	:= "" 
	Private cCodUsu		:= ""
	Private cAntMat 	:= ""
	Private lExeQry 	:= .F.

	Private aCC			:= {}
	Private aFil		:= {}
	Private aEmp		:= {}
	Private cAliasMov 	:= "RHR" // Tabela-Calculo do plano de sa�de

	If !lMovAberto
		cAliasMov := "RHS"  //Tabela-HIST. CALC. PLANO DE SAUDE    
	EndIf
	
	#IFDEF TOP
		lExeQry		:= 	!ExeInAs400()
	#ENDIF
    
    DbSelectArea( "SRA" )
	If !lExeQry
		If nOrdem == 1	//"Centro de Custo + Matricula"
			DbSetOrder( RetOrdem( "SRA", "RA_FILIAL+RA_CC+RA_MAT") )
			DbSeek( cFilDe + cCcDe + cMatDe, .T. )
			cInicio  := "SRA->RA_FILIAL + SRA->RA_CC + SRA->RA_MAT"
			cFim     := cFilAte + cCcAte + cMatAte
		ElseIf nOrdem == 2	// Matricula 
			DbSetOrder( RetOrdem( "SRA", "RA_FILIAL+RA_MAT") )
			DbSeek( cFilDe + cMatDe, .T. )
			cInicio  := "SRA->RA_FILIAL + SRA->RA_MAT"
			cFim     := cFilAte + cMatAte
		ElseIf nOrdem == 3	// Nome
			DbSetOrder( RetOrdem( "SRA", "RA_FILIAL+RA_NOME+RA_MAT") )
			DbSeek( cFilDe + cMatDe, .T. )
			cInicio  := "SRA->RA_FILIAL + SRA->RA_NOME + SRA->RA_MAT"
			cFim     := cFilAte + cNomeAte + cMatAte
		EndIf
	Else
		cAliasQ		:= "QSRA"
		If nOrdem == 1
			cOrder	:= "1, 4, 2, 8, 9, 10"
		ElseIf nOrdem == 2
			cOrder	:= "1, 2, 8, 9, 10"
		ElseIf nOrdem == 3
			cOrder	:= "1, 3, 8, 9, 10"
		Endif
		
		// Converter string en condicao de IN (Query)
		cSituacao  	:= fSqlIN( cSituacao, 1 )	// Situacao do Funcionario
		cCategoria 	:= fSqlIN( cCategoria, 1 ) 	// Categoria do Funcionario

		//-- Monta query de selecao da informacao
		cQuery	:= "SELECT SRA.RA_FILIAL, SRA.RA_MAT, SRA.RA_NOME, SRA.RA_CC, SRA.RA_ADMISSA,  "
		cQuery	+= "CTT.CTT_CUSTO, CTT.CTT_DESC01 CTT_DESC01, MOV." + cAliasMov + "_ORIGEM ORIGEM, " 
		cQuery  += "MOV." + cAliasMov + "_CODIGO CODIGO, MOV." + cAliasMov + "_TPFORN TPFORN, MOV.* "
		cQuery	+= "FROM "+RetSqlName(cAliasMov)+" MOV "
		cQuery  += "INNER JOIN " + RetSqlName("SRA") + " SRA "
		cQuery  += "ON MOV." + cAliasMov + "_FILIAL = SRA.RA_FILIAL "
		cQuery  += "AND MOV." + cAliasMov + "_MAT = SRA.RA_MAT "
		cQuery  += "LEFT JOIN " + RetSqlName("CTT") + " CTT "
		If !Empty(xFilial("CTT"))
			cQuery  += "ON SRA.RA_FILIAL = CTT.CTT_FILIAL AND "
		Else
			cQuery	+= "ON "
		EndIf
		cQuery	+= "SRA.RA_CC = CTT.CTT_CUSTO "
		cQuery	+= "WHERE "
		cQuery	+= "SRA.RA_FILIAL BETWEEN '"+cFilDe+"' AND '"+cFilAte+"' "
		cQuery	+= "AND SRA.RA_MAT BETWEEN '"+cMatDe+"' AND '"+cMatAte+"' "
		cQuery	+= "AND SRA.RA_NOME BETWEEN '"+cNomeDe+"' AND '"+cNomeAte+"' "
		cQuery	+= "AND SRA.RA_CC BETWEEN '"+cCcDe+"' AND '"+cCcAte+"' "
		cQuery	+= "AND SRA.RA_SITFOLH IN("+cSituacao+") "
		cQuery	+= "AND SRA.RA_CATFUNC IN("+cCategoria+") "
		If !lGSP
			
	    cQuery  += "AND MOV." + cAliasMov + "_COMPPG = '" + cAnoMes + "' "
		Else
			cQuery	+= "AND MOV." + cAliasMov + "_PROCES = '" + cProces + "' "
			cQuery	+= "AND MOV." + cAliasMov + "_ROTEIR = '" + cRoteiro + "' "
			cQuery	+= "AND MOV." + cAliasMov + "_PERIOD = '" + cPeriodo + "' "
			cQuery	+= "AND MOV." + cAliasMov + "_NUMPAG = '" + cNumPagto + "' "
		EndIf    
		If nTipoFor_ == 1
	   		cQuery	+= "AND MOV." + cAliasMov + "_TPFORN = 1 "  //mariella	  
	   	EndIf 
	 	If nTipoFor_ == 2 
	   		cQuery	+= "AND MOV." + cAliasMov + "_TPFORN = 2 "  //mariella    
	  	EndIf     
	  	If nTipoFor_ == 3
	  		cQuery	+= "AND (MOV." + cAliasMov + "_TPFORN = 1 OR " + cAliasMov + "_TPFORN = 2) "  //mariella 
		EndIf
		cQuery	+= "AND MOV.D_E_L_E_T_ = ' ' "
		cQuery	+= "AND SRA.D_E_L_E_T_ = ' ' "
		cQuery	+= "AND CTT.D_E_L_E_T_ = ' ' "
		cQuery	+= "ORDER BY "+cOrder

		cQuery	:= ChangeQuery( cQuery )
		dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasQ, .F., .T.)
	EndIf

	dbSelectArea( cAliasQ )
	SetRegua((cAliasQ)->(RecCount()))
	
	cAntMat := ""
                              
	While !(cAliasQ)->(Eof()) .And. If( lExeQry, .T., &cInicio <= cFim )
	
		/*
		��������������������������������������������������������������Ŀ
		� Movimenta Regua Processamento                                �
		����������������������������������������������������������������*/
		IncRegua()
	
		/*
		��������������������������������������������������������������Ŀ
		� Cancela Impres�o ao se pressionar <ALT> + <A>                �
		����������������������������������������������������������������*/
		If lEnd
			@Prow()+1,0 PSAY cCancel
			Exit
		EndIf
		
		If cAntMat <> ( cAliasQ )->RA_FILIAL + ( cAliasQ )->RA_MAT
			cAntMat := ( cAliasQ )->RA_FILIAL + ( cAliasQ )->RA_MAT
			cCodUsu		:= ""
			cTpOrigem	:= "" 
		EndIf
	
		If !lExeQry 
			/*
			��������������������������������������������������������������Ŀ
			� Consiste Parametrizacao do Intervalo de Impressao            �
			����������������������������������������������������������������*/
			If ( ( cAliasQ )->RA_NOME < cNomeDe )  .Or. ( ( cAliasQ )->RA_NOME > cNomeAte ) .Or. ;
				( ( cAliasQ )->RA_MAT < cMatDe )   .Or. ( ( cAliasQ )->RA_MAT > cMatAte ) .Or. ;
				( ( cAliasQ )->RA_CC < cCcDe )   .Or. ( ( cAliasQ )->RA_CC > cCcAte ) .Or. ;
				!( ( cAliasQ )->RA_SITFOLH $ cSituacao ) .Or. ;
				!( ( cAliasQ )->RA_CATFUNC $ cCategoria )

				dbSelectArea( cAliasQ )
				fTestaTotal()
				Loop
			EndIf
			
			DbSelectArea( cAliasMov )
			DbSetOrder( 1 )
			If !lGSP 
				DbSeek( ( cAliasQ )->RA_FILIAL + ( cAliasQ )->RA_MAT + cAnoMes, .F. )
			Else
				DbSeek( ( cAliasQ )->RA_FILIAL + ( cAliasQ )->RA_MAT + cProces + cRoteiro + cPeriodo + cNumPagto, .F. )			
			EndIf
			If Eof()
				dbSelectArea( cAliasQ )
				fTestaTotal()
				Loop
			EndIf
			While !Eof() .and. (cAliasMov)->( &(cAliasMov + "_FILIAL") + &(cAliasMov + "_MAT"))  == ( cAliasQ )->RA_FILIAL + ( cAliasQ )->RA_MAT
				
				If (!lGSP .and. &(cAliasMov + "_COMPPG") <>  cAnoMes ) .Or. ( lGSP .and. &(cAliasMov + "_PROCES") + &(cAliasMov + "_ROTEIR") + &(cAliasMov + "_PERIOD") + &(cAliasMov + "_NUMPAG") <>  cProces + cRoteiro + cPeriodo + cNumPagto )
					Exit
				EndIf
				
				/*
				��������������������������������������������������������������Ŀ
				� Impressao do Funcionario                                     �
				����������������������������������������������������������������*/
				fImpFun()
				DbSelectArea( cAliasMov )
				DbSkip()
	
			EndDo
			fTestaTotal()
		Else
			/*
			��������������������������������������������������������������Ŀ
			� Impressao do Funcionario                                     �
			����������������������������������������������������������������*/
			fImpFun()
			
			fTestaTotal()
		
		EndIf

	EndDo
	
	/*
	��������������������������������������������������������������Ŀ
	� Termino do Relatorio                                         �
	����������������������������������������������������������������*/
	If lExeQry 
		(cAliasQ)->(dbclosearea())
	EndIf
	dbSelectArea("SRA")
	Set Filter to
	dbSetOrder(1)
	Set Device To Screen
	If aReturn[5] = 1
		Set Printer To
		Commit
		ourspool(wnrel)
	EndIf
	MS_FLUSH()

Return

/*                                	
�����������������������������������������������������������������������Ŀ
�Fun��o    � fImpFun		�Autor� Mauricio Takakura � Data �05/11/2011�
�����������������������������������������������������������������������Ĵ
�Descri��o �Impressao do Funcionario                                    �
�����������������������������������������������������������������������Ĵ
�Sintaxe   �< Vide Parametros Formais >									�
�����������������������������������������������������������������������Ĵ
� Uso      �ALL			                                                �
�����������������������������������������������������������������������Ĵ
� Retorno  �aRotina														�
�����������������������������������������������������������������������Ĵ
�Parametros�< Vide Parametros Formais >									�
�������������������������������������������������������������������������*/
Static Function fImpFun()
	Local cCcDesc
	Local cAux 
	Local cAliasImp
	Local cAtCodUsu 
	Local cNome		:= "" 
	Local cTab 		:= "S008"
	Local nCol 		:= 13

	Local lHasDep

	//Tipo			Matr/Seq Nome							Lancamento  		Tp Fornec		  Fornecedor 			   Tp Plano              Cod Plano  	   Vlr. Func		Vlr. Empresa
	//1-Titular		xxxxxx - xxxxxxxxxxxxxxxxxxxxxxxxxxxxx  1-Co-participacao   1-Ass. Odontol.   xx-xxxxxxxxxxxxxxxxxxxx  x-Vlr Fixo por vida   xx-xxxxxxxxxxxxX  999,999,999.99   999,999,999.99
	//2-Dependente
	//3-Agregado

	If lExeQry
		cAliasImp := cAliasQ
	Else
		cAliasImp := cAliasMov
	EndIf

	//-- Imprime o cabecalho inicial do primeiro registro a ser impresso.
	If Empty(cMatAnt) .And. Empty(cFilialAnt) .And. Empty(cCcAnt)
		fCabec(1,(cAliasQ)->RA_FILIAL)	//-- Filial
		If nOrdem == 1
			If lExeQry
				cCcDesc := (cAliasQ)->CTT_DESC01
			Else
				cCcDesc := fDesc("CTT",(cAliasQ)->RA_CC,"CTT->CTT_DESC01",30)
			EndIf
			fCabec(2,(cAliasQ)->RA_CC,cCcDesc)	//-- Centro de custo
		EndIf
	EndIf
	
	cMatAnt	:= (cAliasQ)->RA_FILIAL + (cAliasQ)->RA_MAT
	If lAnalitico
		cDet := "" 
		
		// Impressao do Tipo
		If cTpOrigem <> (cAliasImp)->( &(cAliasMov + "_ORIGEM" ) )
			cTpOrigem	:= (cAliasImp)->( &(cAliasMov + "_ORIGEM" ) )
			cCodUsu		:= ""	// Ao trocar Origem limpa o Cod. Usuario para forcar impressao do 1o nome
			
			If cTpOrigem == "1" 
				cDet += cTpOrigem + "-" + OemToAnsi(STR0012) //"Titular"
			ElseIf cTpOrigem == "2" 
				cDet += cTpOrigem + "-" + OemToAnsi(STR0013) //"Dependente"
			Else
				cDet += cTpOrigem + "-" + OemToAnsi(STR0014) //"Agregado"
			EndIf
			cDet := If( Len(cDet) > 12, Substr(cDet,1,12), cDet+Space(12-Len(cDet)))
		Else
			cDet := Space(12)
		EndIf
		cDet += "  "

		// Impressao da matricula/Sequencia + Nome
		If cTpOrigem == "1" //Titular
			cAtCodUsu := (cAliasQ)->RA_MAT
		Else
			cAtCodUsu := (cAliasImp)->( &(cAliasMov + "_CODIGO" ) )
		EndIf

		If cCodUsu <> cAtCodUsu
			cCodUsu 	:= cAtCodUsu
			If cTpOrigem == "1" //Titular
				cNome := (cAliasQ)->RA_NOME
			ElseIf cTpOrigem == "2" //Dependente
				DbSelectArea( "SRB" )
				DbSetOrder( RetOrdem( "SRB", "RB_FILIAL+RB_MAT" ) )
				DbSeek( (cAliasQ)->RA_FILIAL + (cAliasQ)->RA_MAT, .F. )
				lHasDep := .F.
				While SRB->( !EOF() ) .and. SRB->RB_FILIAL + SRB->RB_MAT == (cAliasQ)->RA_FILIAL + (cAliasQ)->RA_MAT
					If SRB->RB_COD == cCodUsu
						lHasDep := .T.
						Exit
					EndIf
					SRB->( DbSkip() )
				EndDo
                cNome := SRB->RB_NOME
			Else
				DbSelectArea( "RHM" ) 
				DbSetOrder( RetOrdem( "RHM", "RHM_FILIAL+RHM_MAT+RHM_TPFORN+RHM_CODFOR+RHM_CODIGO"))
				DbSeek( (cAliasQ)->RA_FILIAL + (cAliasQ)->RA_MAT + (cAliasImp)->(&(cAliasMov + "_TPFORN")) + (cAliasImp)->(&(cAliasMov + "_CODFOR")) + (cAliasImp)->(&(cAliasMov + "_CODIGO")), .F.)
				If !Eof()
					cNome := RHM->RHM_NOME
				EndIf
			EndIf
			cAux := cCodUsu + "-" + cNome
			If Len(cAux) > 39
				cAux := Substr( cAux, 1, 39 )
			Else
				cAux := cAux + Space( 39 - Len(cAux) )
			EndIf
			cDet += cAux
		Else 
			cDet += Space(39)
		EndIf
		cDet += "  "
		
		// Impressao do Tipo de Lancamentos 
		If (cAliasImp)->( &(cAliasMov + "_TPLAN")) == "1"
			cAux := (cAliasImp)->( &(cAliasMov + "_TPLAN")) + "-" + OemToAnsi(STR0015) //Planos
		ElseIf (cAliasImp)->( &(cAliasMov + "_TPLAN")) == "2"
			cAux := (cAliasImp)->( &(cAliasMov + "_TPLAN")) + "-" + OemToAnsi(STR0016) //Co-Participacao
		Else
			cAux := (cAliasImp)->( &(cAliasMov + "_TPLAN")) + "-" + OemToAnsi(STR0017) //Reembolso
		EndIf
		If Len(cAux) > 17
			cAux := Substr(cAux, 1, 17)
		Else
			cAux := cAux + Space( 17-Len(cAux) )
		EndIf
		cDet += cAux + "   "
		
		// Impressao do Tipo do Fornecedor
		If (cAliasImp)->( &(cAliasMov + "_TPFORN")) == "1"
			cAux := (cAliasImp)->( &(cAliasMov + "_TPFORN")) + "-" + OemToAnsi(STR0018) //"Ass. Medica"
		Else
			cAux := (cAliasImp)->( &(cAliasMov + "_TPFORN")) + "-" + OemToAnsi(STR0019) //"Ass. Odontol."
		EndIf
		If Len(cAux) > 15
			cAux := Substr(cAux, 1, 15)
		Else
			cAux := cAux + Space( 15-Len(cAux) )
		EndIf
		cDet += cAux + "   "
		
		// Impressao do Fornecedor 
		If (cAliasImp)->( &(cAliasMov + "_TPFORN")) == "1" 
			If ( cAux := fPosTab( "S016", (cAliasImp)->( &(cAliasMov + "_CODFOR")),"=", 4 ) ) > 0
				cAux := fTabela("S016",cAux,5)
			Else 
				cAux := " " 
			EndIf
		Else
			If ( cAux := fPosTab( "S017" , (cAliasImp)->( &(cAliasMov + "_CODFOR")),"=", 4 ) ) > 0
				cAux := fTabela("S017",cAux,5)
			Else 
				cAux := " " 
			EndIf
		EndIf
		cAux := (cAliasImp)->( &(cAliasMov + "_CODFOR")) + "-" + cAux 
		If Len( cAux ) > 23
			cAux := Substr(cAux, 1, 23 )
		Else
			cAux := cAux + Space( 23 - Len(cAux) )
		EndIf
		cDet += cAux + "  "
                        
		// Impressao do Tipo do Plano
		If (cAliasImp)->( &(cAliasMov + "_TPPLAN")) == "1"
			cAux := (cAliasImp)->( &(cAliasMov + "_TPFORN")) + "-" + OemToAnsi(STR0020) //"Faixa Salarial" 
		ElseIf (cAliasImp)->( &(cAliasMov + "_TPPLAN")) == "2"
			cAux := (cAliasImp)->( &(cAliasMov + "_TPFORN")) + "-" + OemToAnsi(STR0021) //"Faixa Etaria" 
		ElseIf (cAliasImp)->( &(cAliasMov + "_TPPLAN")) == "3"
			cAux := (cAliasImp)->( &(cAliasMov + "_TPFORN")) + "-" + OemToAnsi(STR0022) //"Vlr Fixo por vida" 
		Else
			cAux := (cAliasImp)->( &(cAliasMov + "_TPFORN")) + "-" + OemToAnsi(STR0023) //"% Sobre salario" 
		EndIf
		If Len(cAux) > 20
			cAux := Substr(cAux, 1, 20)
		Else
			cAux := cAux + Space( 20-Len(cAux) )
		EndIf
		cDet += cAux + "   "
		
		// Impressao do Plano
		If (cAliasImp)->( &(cAliasMov + "_TPFORN")) == "1" 
			If (cAliasImp)->( &(cAliasMov + "_TPPLAN")) == "1" 
				cTab := "S008"
				nCol := 13
			ElseIf (cAliasImp)->( &(cAliasMov + "_TPPLAN")) == "2" 
				cTab := "S009"
				nCol := 13
			ElseIf (cAliasImp)->( &(cAliasMov + "_TPPLAN")) == "3" 
				cTab := "S028" 
				nCol := 12
			ElseIf (cAliasImp)->( &(cAliasMov + "_TPPLAN")) == "4" 
				cTab := "S029" 
				nCol := 15
			EndIf
		ElseIf (cAliasImp)->( &(cAliasMov + "_TPFORN")) == "2"
			If (cAliasImp)->( &(cAliasMov + "_TPPLAN")) == "1" 
				cTab := "S013" 
				nCol := 13
			ElseIf (cAliasImp)->( &(cAliasMov + "_TPPLAN")) == "2" 
				cTab := "S014" 
				nCol := 13
			ElseIf (cAliasImp)->( &(cAliasMov + "_TPPLAN")) == "3" 
				cTab := "S030" 
				nCol := 12
			ElseIf (cAliasImp)->( &(cAliasMov + "_TPPLAN")) == "4" 
				cTab := "S031" 
				nCol := 15
			EndIf
		EndIf

		If ( cAux := fPosTab( cTab, (cAliasImp)->( &(cAliasMov + "_CODFOR")),"=", nCol, (cAliasImp)->( &(cAliasMov + "_PLANO")),"=", 4 ) ) > 0
			cAux := fTabela(cTab,cAux,5)
		Else 
			cAux := " " 
		EndIf

		cAux := (cAliasImp)->( &(cAliasMov + "_PLANO")) + "-" + cAux 
		If Len( cAux ) > 16
			cAux := Substr(cAux, 1, 16 )
		Else
			cAux := cAux + Space( 16 - Len(cAux) )
		EndIf
		cDet += cAux + "  "

		cDet += Str( (cAliasImp)->( &(cAliasMov + "_VLRFUN")) , 12,2) + Space(3) 
		cDet += Str( (cAliasImp)->( &(cAliasMov + "_VLREMP")) , 12,2) + Space(4)
		
		cDet += Str( (cAliasImp)->( &(cAliasMov + "_VLRFUN")) + (cAliasImp)->( &(cAliasMov + "_VLREMP")), 12,2)
		
		Impr(cDet,"C")
	EndIf
	
	//-- Acumula Centro de custo / filial / empresa
	If ( nPos := Ascan(aCC,{|x| x[1] == (cAliasQ)->RA_CC}) ) > 0
		aCC[nPos,2]		+= 1
		aCC[nPos,3]		+= (cAliasImp)->( &(cAliasMov + "_VLRFUN"))
		aCC[nPos,4]		+= (cAliasImp)->( &(cAliasMov + "_VLREMP"))
	Else
		Aadd(aCC,{(cAliasQ)->RA_CC, 1, (cAliasImp)->( &(cAliasMov + "_VLRFUN")), (cAliasImp)->( &(cAliasMov + "_VLREMP"))})
	EndIf

	If ( nPos	:= Ascan(aFil,{|x| x[1] == (cAliasQ)->RA_FILIAL}) ) > 0
		aFil[nPos,2]	+= 1
		aFil[nPos,3]	+= (cAliasImp)->( &(cAliasMov + "_VLRFUN"))
		aFil[nPos,4]	+= (cAliasImp)->( &(cAliasMov + "_VLREMP"))
	Else
		Aadd(aFil,{(cAliasQ)->RA_FILIAL, 1, (cAliasImp)->( &(cAliasMov + "_VLRFUN")), (cAliasImp)->( &(cAliasMov + "_VLREMP"))})
	EndIf

	If ( nPos	:= Ascan(aEmp,{|X| X[1] == cEmpAnt}) ) > 0
		aEmp[nPos,2]	+= 1
		aEmp[nPos,3]	+= (cAliasImp)->( &(cAliasMov + "_VLRFUN"))
		aEmp[nPos,4]	+= (cAliasImp)->( &(cAliasMov + "_VLREMP"))
	Else
		Aadd(aEmp,{cEmpAnt, 1, (cAliasImp)->( &(cAliasMov + "_VLRFUN")), (cAliasImp)->( &(cAliasMov + "_VLREMP"))})
	EndIf

Return Nil

/*                                	
�����������������������������������������������������������������������Ŀ
�Fun��o    � fTestaTotal	�Autor� Mauricio Takakura � Data �05/11/2011�
�����������������������������������������������������������������������Ĵ
�Descri��o �Impressao do Totalizador                                    �
�����������������������������������������������������������������������Ĵ
�Sintaxe   �< Vide Parametros Formais >									�
�����������������������������������������������������������������������Ĵ
� Uso      �ALL			                                                �
�����������������������������������������������������������������������Ĵ
� Retorno  �aRotina														�
�����������������������������������������������������������������������Ĵ
�Parametros�< Vide Parametros Formais >									�
�������������������������������������������������������������������������*/
Static Function fTestaTotal()

	dbSelectArea( cAliasQ )
	cFilialAnt := (cAliasQ)->RA_FILIAL              // Iguala Variaveis
	cCcAnt     := (cAliasQ)->RA_CC
	dbSkip()
	
	If Eof()
		fImpCc(cCcAnt)
		fImpFil(cFilialAnt)
		fImpEmp()
	Elseif cFilialAnt # (cAliasQ)->RA_FILIAL
		fImpCc(cCcAnt)
		fImpFil(cFilialAnt)
	Elseif cCcAnt # (cAliasQ)->RA_CC
		fImpCc(cCcAnt)
	EndIf

Return

/*                                	
�����������������������������������������������������������������������Ŀ
�Fun��o    � fImpCc     	�Autor� Mauricio Takakura � Data �05/11/2011�
�����������������������������������������������������������������������Ĵ
�Descri��o �Impressao do Totalizador por Centro de Custo                �
�����������������������������������������������������������������������Ĵ
�Sintaxe   �< Vide Parametros Formais >									�
�����������������������������������������������������������������������Ĵ
� Uso      �ALL			                                                �
�����������������������������������������������������������������������Ĵ
� Retorno  �aRotina														�
�����������������������������������������������������������������������Ĵ
�Parametros�< Vide Parametros Formais >									�
�������������������������������������������������������������������������*/
Static Function fImpCc(cCcAnt)
	Local cDet		:= ""
	Local cCcDesc	:=""
	Local nPos		:= 0
	Local nPos1		:= 0
	Local nx		:= 0
	
	If nOrdem == 2 .Or. nOrdem == 3
		Return Nil
	EndIf
	
	If ( nPos	:= Ascan(aCC,{|X| X[1] == cCcAnt}) ) == 0
		Return Nil
	Endif
	
	cDet := Space(1)
	Impr(cDet,"C")
	
	cDet := OemToAnsi(STR0024)  //" T O T A L  C E N T R O  D E  C U S T O S" ## " Funcion�rio(s) "
	
	cDet += Space(119) + Transform(aCC[nPos,3],"@E 9,999,999.99") + " "
	cDet += Space(2) + Transform(aCC[nPos,4],"@E 9,999,999.99") + " "
	cDet += Space(3) + Transform(aCC[nPos,3]+aCC[nPos,4],"@E 9,999,999.99") + " "
	Impr(cDet,"C")
	
	cDet := Repl("-",220)
	Impr(cDet,"C")

	cDet := ""
	Impr(cDet,"C")
	Impr(cDet,"C")
	
	//-- Imprime cabecalho para o proximo centro de custos
	If lExeQry
		cCcDesc := (cAliasQ)->CTT_DESC01
	Else
		cCcDesc := fDesc("CTT",(cAliasQ)->RA_CC,"CTT->CTT_DESC01",30)
	EndIf
	
	fCabec(2,(cAliasQ)->RA_CC,cCcDesc)	//-- Centro de custo

Return Nil

/*                                	
�����������������������������������������������������������������������Ŀ
�Fun��o    � fImpFil     	�Autor� Mauricio Takakura � Data �05/11/2011�
�����������������������������������������������������������������������Ĵ
�Descri��o �Impressao do Totalizador por Filial                         �
�����������������������������������������������������������������������Ĵ
�Sintaxe   �< Vide Parametros Formais >									�
�����������������������������������������������������������������������Ĵ
� Uso      �ALL			                                                �
�����������������������������������������������������������������������Ĵ
� Retorno  �aRotina														�
�����������������������������������������������������������������������Ĵ
�Parametros�< Vide Parametros Formais >									�
�������������������������������������������������������������������������*/
Static Function fImpFil(cFilialAnt)

	Local cDescFil
	Local cDet		:= ""
	Local nPos		:= 0
	Local aInfo		:= {}
	Local nx		:= 0
	
	If ( nPos	:= Ascan(aFil,{|x| x[1] == cFilialAnt}) ) == 0
		Return Nil
	EndIf
	fInfo(@aInfo,cFilialAnt)

	cDet := Space(1)
	Impr(cDet,"C")

	cDet := OemToAnsi(STR0010) + aFil[nPos,1] + " - " + aInfo[1] //"Filial : "
	Impr(cDet,"C")

	cDet := Space(1)
	Impr(cDet,"C")

	cDet :=  OemToAnsi(STR0026) //" T O T A L    D A    F I L I A L         " ### "Funcionarios: " 
	cDet += Space(119) + Transform(aFil[nPos,3],"@E 9,999,999.99") + " "
	cDet += Space(2) + Transform(aFil[nPos,4],"@E 9,999,999.99") + " "
	cDet += Space(3) + Transform(aFil[nPos,3]+aFil[nPos,4],"@E 9,999,999.99") + " "

	Impr(cDet,"C")

	cDet := Repl("-",220)
	Impr(cDet,"C")

	Impr("","P")

	//-- Imprime cabecalho da proxima filial
	fCabec(1,(cAliasQ)->RA_FILIAL)	//-- Filial

Return Nil

/*                                	
�����������������������������������������������������������������������Ŀ
�Fun��o    � fImpEmp    	�Autor� Mauricio Takakura � Data �05/11/2011�
�����������������������������������������������������������������������Ĵ
�Descri��o �Impressao do Totalizador por Empresa                        �
�����������������������������������������������������������������������Ĵ
�Sintaxe   �< Vide Parametros Formais >									�
�����������������������������������������������������������������������Ĵ
� Uso      �ALL			                                                �
�����������������������������������������������������������������������Ĵ
� Retorno  �aRotina														�
�����������������������������������������������������������������������Ĵ
�Parametros�< Vide Parametros Formais >									�
�������������������������������������������������������������������������*/
Static Function fImpEmp()

	Local cDet	:= ""
	Local nPos	:= 0
	Local aInfo	:= {}
	Local nx	:= 0

	If ( nPos	:= Ascan(aEmp,{|X| X[1] == cEmpAnt}) ) == 0
		Return Nil
	EndIf
	fInfo(@aInfo,aFil[len(aFil),1])

	cDet := Space(1)
	Impr(cDet,"C")

	cDet := OemToAnsi(STR0005)+aEmp[nPos,1]+" - "+aInfo[2] //"Empresa: "
	Impr(cDet,"C")

	cDet := Space(1)
	Impr(cDet,"C")

	cDet := OemToAnsi(STR0025)  //" T O T A L    D A    E M P R E S A       " ### "Funcionarios" 
	cDet += Space(119) + Transform(aEmp[nPos,3],"@E 9,999,999.99") + " "
	cDet += Space(2) + Transform(aEmp[nPos,4],"@E 9,999,999.99") + " "
	cDet += Space(3) + Transform(aEmp[nPos,3]+aEmp[nPos,4],"@E 9,999,999.99") + " "
	Impr(cDet,"C")

	cDet := Repl("-",220)
	Impr(cDet,"C")

	Impr("","F")

Return Nil

/*                                	
�����������������������������������������������������������������������Ŀ
�Fun��o    � fCabec			�Autor� Mauricio Takakura � Data �05/11/2011�
�����������������������������������������������������������������������Ĵ
�Descri��o �Impressao do Cabecalho                                      �
�����������������������������������������������������������������������Ĵ
�Sintaxe   �< Vide Parametros Formais >									�
�����������������������������������������������������������������������Ĵ
� Uso      �ALL			                                                �
�����������������������������������������������������������������������Ĵ
� Retorno  �aRotina														�
�����������������������������������������������������������������������Ĵ
�Parametros�< Vide Parametros Formais >									�
�������������������������������������������������������������������������*/
Static Function	fCabec(nTipo, cCod, cDesc)

	Local cDet	:= ""
	Local aInfo	:= {}

	If Empty(cCod)
		Return
	EndIf

	If nTipo == 1
		fInfo(@aInfo, cCod)
		cDet := OemToAnsi(STR0010) + cCod + " - " + aInfo[1] // " Filial : "
		Impr(cDet,"C")
		cDet := Space(1)
		Impr(cDet,"C")
	ElseIf nTipo == 2
		cDet := OemToAnsi(STR0011) + cCod + " - " + cDesc //"C.Custo: "
		Impr(cDet,"C")
		cDet := Space(1)
		Impr(cDet,"C")
	EndIf

Return
