#Include 'Totvs.ch'
#Include 'FWMVCDef.ch'
 
//Variáveis Estáticas
Static cTitulo := "Integração Portal da Rede"
 
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CRPA049		º Autor ³ Renato Ruy     º Data ³  09/03/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Rotina de encerramento do lançamentos mensais e integração º±±
±±º          ³ com o Portal da Rede                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Remuneração de Parceiros                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
 
User Function CRPA049()
    Local aArea   := GetArea()
    Local oBrowse
     
    //Instânciando FWMBrowse - Somente com dicionário de dados
    oBrowse := FWMBrowse():New()
     
    //Setando a tabela de cadastro de Autor/Interprete
    oBrowse:SetAlias("ZZG")
 
    //Setando a descrição da rotina
    oBrowse:SetDescription(cTitulo)
    
    //Cria filtro
    oBrowse:SetFilterDefault( "ZZG_ATIVO == '1'" )
     
    //Ativa a Browse
    oBrowse:Activate()
     
    RestArea(aArea)
Return Nil
 
/*---------------------------------------------------------------------*
 | Func:  MenuDef                                                      |
 | Autor: Renato Ruy															 |
 | Data:  09/03/2017                                                   |
 | Desc:  Criação da visão MVC                                         |
 | Obs.:  /                                                            |
 *---------------------------------------------------------------------*/
 
Static Function MenuDef()
	Private aRotina2 := {}
	ADD OPTION aRotina2 Title 'Visualizar'		Action 'VIEWDEF.CRPA049' 	OPERATION 2 ACCESS 0
//	ADD OPTION aRotina2 Title 'Incluir' 		Action 'VIEWDEF.CRPA049' 	OPERATION 3 ACCESS 0
//	ADD OPTION aRotina2 Title 'Alterar' 		Action 'VIEWDEF.CRPA049' 	OPERATION 4 ACCESS 0
//	ADD OPTION aRotina2 Title 'Excluir' 		Action 'VIEWDEF.CRPA049' 	OPERATION 5 ACCESS 0
//	ADD OPTION aRotina2 Title 'Imprimir' 		Action 'VIEWDEF.CRPA049' 	OPERATION 8 ACCESS 0
	ADD OPTION aRotina2 Title 'Integrar' 		Action 'U_CRPA049I'			OPERATION 3 ACCESS 0
	ADD OPTION aRotina2 Title 'Abrir Arquivo' Action 'U_CRPA049O'			OPERATION 6 ACCESS 0
	ADD OPTION aRotina2 Title 'Desativar' 		Action 'U_CRPA049D'			OPERATION 7 ACCESS 0
 
Return aRotina2
 
/*---------------------------------------------------------------------*
 | Func:  ModelDef                                                     |
 | Autor: Renato Ruy															 |
 | Data:  09/03/2017                                                   |
 | Desc:  Criação da visão MVC                                         |
 | Obs.:  /                                                            |
 *---------------------------------------------------------------------*/
 
Static Function ModelDef()
    //Criação do objeto do modelo de dados
    Local oModel := Nil
     
    //Criação da estrutura de dados utilizada na interface
    Local oStZZG := FWFormStruct(1, "ZZG")
     
    //Instanciando o modelo, não é recomendado colocar nome da user function (por causa do u_), respeitando 10 caracteres
    oModel := MPFormModel():New("CRPA049M",/*bPre*/, /*bPos*/,/*bCommit*/,/*bCancel*/)
     
    //Atribuindo formulários para o modelo
    oModel:AddFields("FORMZZG",/*cOwner*/,oStZZG)
     
    //Setando a chave primária da rotina
    oModel:SetPrimaryKey({'ZZG_FILIAL','ZZG_PERIOD','ZZG_CODENT','ZZG_FILHO','ZZG_VERSAO'})
     
    //Adicionando descrição ao modelo
    oModel:SetDescription(cTitulo)
     
    //Setando a descrição do formulário
    oModel:GetModel("FORMZZG"):SetDescription("Formulário do "+cTitulo)
Return oModel
 
/*---------------------------------------------------------------------*
 | Func:  ViewDef                                                      |
 | Autor: Renato Ruy															 |
 | Data:  09/03/2017                                                   |
 | Desc:  Criação da visão MVC                                         |
 | Obs.:  /                                                            |
 *---------------------------------------------------------------------*/
 
Static Function ViewDef()
    //Criação do objeto do modelo de dados da Interface do Cadastro de Autor/Interprete
    Local oModel := FWLoadModel("CRPA049")
     
    //Criação da estrutura de dados utilizada na interface do cadastro de Autor
    Local oStZZG := FWFormStruct(2, "ZZG")  //pode se usar um terceiro parâmetro para filtrar os campos exibidos { |cCampo| cCampo $ 'ZZG_NOME|ZZG_DTAFAL|'}
     
    //Criando oView como nulo
    Local oView := Nil
 
    //Criando a view que será o retorno da função e setando o modelo da rotina
    oView := FWFormView():New()
    oView:SetModel(oModel)
     
    //Atribuindo formulários para interface
    oView:AddField("VIEW_ZZG", oStZZG, "FORMZZG")
     
    //Criando um container com nome tela com 100%
    oView:CreateHorizontalBox("TELA",100)
     
    //Colocando título do formulário
    oView:EnableTitleView('VIEW_ZZG', 'Dados do Grupo de Produtos' ) 
     
    //Força o fechamento da janela na confirmação
    oView:SetCloseOnOk({||.T.})
     
    //O formulário da interface será colocado dentro do container
    oView:SetOwnerView("VIEW_ZZG","TELA")
Return oView

//Perguntas para iniciar o processamento e geracao dos relatorios
User Function CRPA049I
	Local bValid  	:= {|| .T. }
	Local aPar 	:= {}
	
	Private aRet := {}
	Private oProcess
	
	//Utilizo parambox para fazer as perguntas
	aAdd( aPar,{ 1  ,"Periodo " 	 	,Space(6),"","","","",50,.F.})
	aAdd( aPar,{ 1  ,"Entidade De"	 	,Space(6),"","","","",50,.F.})
	aAdd( aPar,{ 1  ,"Entidade Ate"		,Space(6),"","","","",50,.F.})
	aAdd( aPar,{ 2  ,"Tipo Ent." 	 	,"TODAS" ,{"TODAS","POSTO","AC/CANAL","REVENDEDOR"}, 100,'.T.',.T.})
	aAdd( aPar,{ 1  ,"AC De"	 			,Space(6),"","","","",50,.F.})
	aAdd( aPar,{ 1  ,"AC Ate"			,Space(6),"","","","",50,.F.})
	
	If ParamBox( aPar, 'Parâmetros', @aRet, bValid, , , , , ,"CRPA049I" , .T., .F. )
		oProcess := MsNewProcess():New( { || CRPA49I() } , "Efetuando Integração com o Portal da Rede" , "Aguarde..." , .F. )
		oProcess:Activate()
	Else
		Alert("Rotina Cancelada!")
	EndIf
Return

//Rotina para separar as rotinas de processamento
Static Function CRPA49I()
	
	//Posto ou Todas
	If aRet[4] $ "POSTO/TODAS"
		CRPA049P()
	Endif
	
	// AC, Canal ou Todas
	If aRet[4] $ "AC/CANAL/TODAS"
		CRPA049A()		
	Endif
	
	//Revendedores ou Todas
	If aRet[4] $ "REVENDEDOR/TODAS"
		CRPA049R()
	Endif
	
Return

//Gera dados de integracao do posto
Static Function CRPA049P()

	Local Cabec1         := ""
	Local Cabec2         := ""
	Local titulo         := "Relatório de Lançamentos de Remuneração"
	Local nLin				:= 1
	Local aRetorno		:= {}
	Local nVersao			:= 1
	Local aCodRev			:= {}
	Local cNomArq			:= ""
	Local nStatus			:= 0
	Local nContador		:= 0
	Local Ni
	
	MakeDir( "remuneracao" ) //Pasta criada na raiz
	MakeDir( "\remuneracao\" +  aRet[1]) //Cria pasta para armazenar por periodo
	
	Beginsql Alias "TMPPOS"
		SELECT Z3_CODENT,
        		Z3_CODPAR,
        		Z3_CODPAR2,
        		Z3_DESENT
		FROM ZZ6010 ZZ6
		JOIN SZ3010 SZ3 
		ON Z3_FILIAL = ' ' AND ZZ6_CODENT = Z3_CODENT AND Z3_TIPENT = '9' AND SZ3.%Notdel%
		WHERE
		ZZ6_FILIAL = %xFilial:ZZ6% AND
		ZZ6_PERIOD = %Exp:aRet[1]% AND
		ZZ6_CODENT BETWEEN %Exp:aRet[2]% AND %Exp:aRet[3]% AND
		ZZ6_CODAC BETWEEN %Exp:aRet[5]% AND %Exp:aRet[6]% AND
		ZZ6.%Notdel%
	Endsql
	
	Beginsql Alias "CONPOS"
		SELECT COUNT(*) CONTADOR
		FROM ZZ6010 ZZ6
		JOIN SZ3010 SZ3 
		ON Z3_FILIAL = ' ' AND ZZ6_CODENT = Z3_CODENT AND Z3_TIPENT = '9' AND SZ3.%Notdel%
		WHERE
		ZZ6_FILIAL = %xFilial:ZZ6% AND
		ZZ6_PERIOD = %Exp:aRet[1]% AND
		ZZ6_CODENT BETWEEN %Exp:aRet[2]% AND %Exp:aRet[3]% AND
		ZZ6_CODAC BETWEEN %Exp:aRet[5]% AND %Exp:aRet[6]% AND
		ZZ6.%Notdel%
	Endsql
	
	//Seta contagem da regua
	 oProcess:SetRegua1( CONPOS->CONTADOR ) //Alimenta a primeira barra de progresso
	//Fecha area aberta
	CONPOS->(DbCloseArea())
	
	While !TMPPOS->(EOF())
	
		oProcess:IncRegua1( "Relatório do posto : " + TMPPOS->Z3_DESENT )
		
		nVersao  		:= 1 //Se nao existir, o sistema permanecera na primeira versao
		aCodRev	:= {}//Deixa sem conteudo para buscar novamente
		
		//Gera respostas das perguntas
		Perg101(aRet[1], , , , , 1, TMPPOS->Z3_CODENT, TMPPOS->Z3_CODENT)
		
		//Chama relatorio
		aRetorno := STATICCALL( CRPR101, RunReport, Cabec1, Cabec2, Titulo, nLin )
		
		If RTrim(aRetorno[2]) == "-" .Or. Empty(aRetorno[2])
			loop
		Endif
		
		CpyT2S(aRetorno[1], "\remuneracao\" +aRet[1]+"\",.F.) //Copia da maquina do usuário para o servidor
		
		//Se ja existe, desativa e armazena versao
		ZZG->(DbSetOrder(1))
		If ZZG->(DbSeek(xFilial("ZZG")+aRet[1]+TMPPOS->Z3_CODENT+TMPPOS->Z3_CODENT+"1"))
			nVersao := ZZG->ZZG_VERSAO + 1
			
			RecLock("ZZG")
				ZZG->ZZG_ATIVO := "2"
			ZZG->(MsUnlock())	
		
		//Renato Ruy - 22/03/2018
		//Quando usuario desativa todas as versoes, nao reiniciar contagem
		Elseif ZZG->(DbSeek(xFilial("ZZG")+aRet[1]+TMPPOS->Z3_CODENT+TMPPOS->Z3_CODENT))
			nVersao := 2
			While !ZZG->(EOF()) .And. ZZG->ZZG_PERIOD == aRet[1] .And.;
				   ZZG->ZZG_CODENT == TMPPOS->Z3_CODENT
				If ZZG->ZZG_VERSAO >= nVersao
					nVersao := ZZG->ZZG_VERSAO + 1
				Endif
				ZZG->(DbSkip())   
			Enddo			
		Endif
		
		//Renomeia arquivo
		cNomArq := StrTran(Encode64(DtoS(Date())+StrTran(Time(),":","")+"remuneracao"+Ltrim(Str(Randomize(1,34000)))),"=","")+".xls"
		nStatus := FRename( "\remuneracao\" +aRet[1]+"\"+aRetorno[2], "\remuneracao\" +aRet[1]+"\"+cNomArq)
		
		nContador := 0
		While nStatus == -1 .And. nContador <= 5 
			sleep(1000)
			cNomArq := StrTran(Encode64(DtoS(Date())+StrTran(Time(),":","")+"remuneracao"+Ltrim(Str(Randomize(1,34000)))),"=","")+".xls"
			nStatus := FRename( "\remuneracao\" +aRet[1]+"\"+aRetorno[2], "\remuneracao\" +aRet[1]+"\"+cNomArq)	
			nContador++		
		Enddo
		
		//		PERIODO, ENTIDADE PAI	  , ENTIDADE FILHO	, TIPO,ARQUIVO	 , VERSAO , TOTAL
		CriaZZG(aRet[1], TMPPOS->Z3_CODENT, TMPPOS->Z3_CODENT, "4", cNomArq, nVersao, aRetorno[3])
		
		//Gera relatorio dos revendedores
		If !Empty(TMPPOS->Z3_CODPAR)
			
			//Gera Array com os revendedores
			aCodRev := StrToArray(TMPPOS->Z3_CODPAR + Iif(!Empty(TMPPOS->Z3_CODPAR2),","+AllTrim(TMPPOS->Z3_CODPAR2),""),",")
			oProcess:SetRegua2( Len(aCodRev) )
			
			For nI := 1 To Len(aCodRev)
			
				 oProcess:IncRegua2("Gerando relatorio do Revendedor: "+aCodRev[nI])
			
				nVersao  		:= 1 //Se nao existir, o sistema permanecera na primeira versao
				
				//Gera respostas das perguntas
				Perg111(aRet[1],,,aCodRev[nI], aCodRev[nI], 1,,1 )
				
				//Chama relatorio
				aRetorno := STATICCALL( CRPR111, RunReport, Cabec1, Cabec2, Titulo, nLin )
				
				If RTrim(aRetorno[2]) == "CCR CAMPANHA -  -       .xls" .Or. Empty(aRetorno[2])
					loop
				Endif
				
				CpyT2S(aRetorno[1], "\remuneracao\" +aRet[1]+"\",.F.) //Copia da maquina do usuário para o servidor
				
				//Se ja existe, desativa e armazena versao
				ZZG->(DbSetOrder(1))
				If ZZG->(DbSeek(xFilial("ZZG")+aRet[1]+TMPPOS->Z3_CODENT+PadR(aCodRev[nI],6," ")+"1"))
					nVersao := ZZG->ZZG_VERSAO + 1
					
					RecLock("ZZG")
						ZZG->ZZG_ATIVO := "2"
					ZZG->(MsUnlock())	
				
				//Renato Ruy - 22/03/2018
				//Quando usuario desativa todas as versoes, nao reiniciar contagem
				Elseif ZZG->(DbSeek(xFilial("ZZG")+aRet[1]+TMPPOS->Z3_CODENT+PadR(aCodRev[nI],6," ")))
					nVersao := 2
					While !ZZG->(EOF()) .And. ZZG->ZZG_PERIOD == aRet[1] .And.;
						   ZZG->ZZG_CODENT == TMPPOS->Z3_CODENT .And.;
						   ZZG->ZZG_FILHO == PadR(aCodRev[nI],6," ")
						If ZZG->ZZG_VERSAO >= nVersao
							nVersao := ZZG->ZZG_VERSAO + 1
						Endif
						ZZG->(DbSkip())   
					Enddo		
					
				Endif
				
				//Renomeia arquivo
				cNomArq := StrTran(Encode64(DtoS(Date())+StrTran(Time(),":","")+"remuneracao"+Ltrim(Str(Randomize(1,34000)))),"=","")+".xls"
				nStatus := FRename( "\remuneracao\" +aRet[1]+"\"+aRetorno[2], "\remuneracao\" +aRet[1]+"\"+cNomArq)
				
				nContador := 0
				While nStatus == -1 .And. nContador <= 5 
					sleep(500)
					cNomArq := StrTran(Encode64(DtoS(Date())+StrTran(Time(),":","")+"remuneracao"+Ltrim(Str(Randomize(1,34000)))),"=","")+".xls"
					nStatus := FRename( "\remuneracao\" +aRet[1]+"\"+aRetorno[2], "\remuneracao\" +aRet[1]+"\"+cNomArq)	
					nContador++		
				Enddo
				
				//		PERIODO, ENTIDADE PAI	  , ENTIDADE FILHO	, TIPO,ARQUIVO	 , VERSAO , TOTAL
				CriaZZG(aRet[1], TMPPOS->Z3_CODENT, aCodRev[nI], "7", cNomArq, nVersao, aRetorno[3])
			
			Next
			
		Endif
		
		
		
		//Pula registro
		TMPPOS->(DbSkip())
		
	Enddo
	
	TMPPOS->(DbCloseArea())
	
Return

//Gera dados de integracao da AC e Canal
Static Function CRPA049A()

	Local Cabec1         := ""
	Local Cabec2         := ""
	Local titulo         := "Relatório de Lançamentos de Remuneração"
	Local nLin				:= 1
	Local aRetorno		:= {}
	Local nVersao			:= 1
	Local aCodRev			:= {}
	Local cNomArq			:= ""
	Local nStatus			:= 0
	Local nContador		:= 0
	
	MakeDir( "remuneracao" ) //Pasta criada na raiz
	MakeDir( "\remuneracao\" +  aRet[1]) //Cria pasta para armazenar por periodo
	
	Beginsql Alias "TMPAC"
		SELECT Z3_CODENT,
        		Z3_TIPENT,
        		Z3_DESENT
		FROM ZZ6010 ZZ6
		JOIN SZ3010 SZ3 
		ON Z3_FILIAL = ' ' AND ZZ6_CODENT = Z3_CODENT AND Z3_TIPENT IN ('1','2') AND SZ3.%Notdel%
		WHERE
		ZZ6_FILIAL = %xFilial:ZZ6% AND
		ZZ6_PERIOD = %Exp:aRet[1]% AND
		ZZ6_CODENT BETWEEN %Exp:aRet[2]% AND %Exp:aRet[3]% AND
		ZZ6.%Notdel%
	Endsql
	
	Beginsql Alias "CONAC"
		SELECT COUNT(*) CONTADOR
		FROM ZZ6010 ZZ6
		JOIN SZ3010 SZ3 
		ON Z3_FILIAL = ' ' AND ZZ6_CODENT = Z3_CODENT AND Z3_TIPENT IN ('1','2') AND SZ3.%Notdel%
		WHERE
		ZZ6_FILIAL = %xFilial:ZZ6% AND
		ZZ6_PERIOD = %Exp:aRet[1]% AND
		ZZ6_CODENT BETWEEN %Exp:aRet[2]% AND %Exp:aRet[3]% AND
		ZZ6.%Notdel%
	Endsql
	
	//Seta contagem da regua
	oProcess:SetRegua1( CONAC->CONTADOR )
	//Fecha area aberta
	CONAC->(DbCloseArea())
	
	While !TMPAC->(EOF())
	
		oProcess:IncRegua1( "Relatório da AC : " + TMPAC->Z3_DESENT )
		
		nVersao  		:= 1 //Se nao existir, o sistema permanecera na primeira versao
		aCodRev	:= {}//Deixa sem conteudo para buscar novamente
		
		//Gera respostas das perguntas
		Perg101(aRet[1], , ,TMPAC->Z3_CODENT ,TMPAC->Z3_CODENT , Iif(TMPAC->Z3_TIPENT=="1",3,2),,)
		
		//Chama relatorio
		aRetorno := STATICCALL( CRPR101, RunReport, Cabec1, Cabec2, Titulo, nLin )
		
		If RTrim(aRetorno[2]) == "-" .Or. Empty(aRetorno[2])
			loop
		Endif
		
		CpyT2S(aRetorno[1], "\remuneracao\" +aRet[1]+"\",.F.) //Copia da maquina do usuário para o servidor
		
		//Se ja existe, desativa e armazena versao
		ZZG->(DbSetOrder(1))
		If ZZG->(DbSeek(xFilial("ZZG")+aRet[1]+TMPAC->Z3_CODENT+TMPAC->Z3_CODENT+"1"))
			nVersao := ZZG->ZZG_VERSAO + 1
			
			RecLock("ZZG")
				ZZG->ZZG_ATIVO := "2"
			ZZG->(MsUnlock())
		//Renato Ruy - 22/03/2018
		//Quando usuario desativa todas as versoes, nao reiniciar contagem
		Elseif ZZG->(DbSeek(xFilial("ZZG")+aRet[1]+TMPAC->Z3_CODENT+TMPAC->Z3_CODENT))
			nVersao := 2
			While !ZZG->(EOF()) .And. ZZG->ZZG_PERIOD == aRet[1] .And.;
				   ZZG->ZZG_CODENT == TMPAC->Z3_CODENT
				If ZZG->ZZG_VERSAO >= nVersao
					nVersao := ZZG->ZZG_VERSAO + 1
				Endif
				ZZG->(DbSkip())   
			Enddo			
		Endif
		
		//Renomeia arquivo
		cNomArq := StrTran(Encode64(DtoS(Date())+StrTran(Time(),":","")+"remuneracao"+Ltrim(Str(Randomize(1,34000)))),"=","")+".xls"
		nStatus := FRename( "\remuneracao\" +aRet[1]+"\"+aRetorno[2], "\remuneracao\" +aRet[1]+"\"+cNomArq)
		
		nContador := 0
		While nStatus == -1 .And. nContador <= 5 
			sleep(500)
			cNomArq := StrTran(Encode64(DtoS(Date())+StrTran(Time(),":","")+"remuneracao"+Ltrim(Str(Randomize(1,34000)))),"=","")+".xls"
			nStatus := FRename( "\remuneracao\" +aRet[1]+"\"+aRetorno[2], "\remuneracao\" +aRet[1]+"\"+cNomArq)	
			nContador++		
		Enddo
		
		//		PERIODO, ENTIDADE PAI	  , ENTIDADE FILHO	, TIPO,ARQUIVO	 , VERSAO , TOTAL
		CriaZZG(aRet[1], TMPAC->Z3_CODENT, TMPAC->Z3_CODENT, TMPAC->Z3_TIPENT, cNomArq, nVersao, aRetorno[3])
		
		//Pula registro
		TMPAC->(DbSkip())
		
	Enddo
	
	TMPAC->(DbCloseArea())
	
Return

//Gera integração dos revendedores
Static Function CRPA049R()

	Local Cabec1         := ""
	Local Cabec2         := ""
	Local titulo         := "Relatório de Lançamentos de Remuneração"
	Local nLin				:= 1
	Local aRetorno		:= {}
	Local nVersao			:= 1
	Local aCodRev			:= {}
	Local cNomArq			:= ""
	Local nStatus			:= 0
	Local nContador		:= 0
	Local Ni
	
	MakeDir( "remuneracao" ) //Pasta criada na raiz
	MakeDir( "\remuneracao\" +  aRet[1]) //Cria pasta para armazenar por periodo
	
	Beginsql Alias "TMPREV"
		SELECT ZZ6_CODENT,
        		ZZ6_DESENT,
        		Z3_DESENT
		FROM ZZ6010 ZZ6
		JOIN SZ3010 SZ3 
		ON Z3_FILIAL = ' ' AND ZZ6_CODENT = Z3_CODENT AND Z3_TIPENT = '7' AND SZ3.%Notdel%
		WHERE
		ZZ6_FILIAL = %xFilial:ZZ6% AND
		ZZ6_PERIOD = %Exp:aRet[1]% AND
		ZZ6_CODENT BETWEEN %Exp:aRet[2]% AND %Exp:aRet[3]% AND
		ZZ6.%Notdel%
		ORDER BY Z3_CODENT,Z3_CODPAR
	Endsql
	
	Beginsql Alias "CONREV"
		SELECT COUNT(*) CONTADOR
		FROM ZZ6010 ZZ6
		JOIN SZ3010 SZ3 
		ON Z3_FILIAL = ' ' AND ZZ6_CODENT = Z3_CODENT AND Z3_TIPENT = '7' AND SZ3.%Notdel%
		WHERE
		ZZ6_FILIAL = %xFilial:ZZ6% AND
		ZZ6_PERIOD = %Exp:aRet[1]% AND
		ZZ6_CODENT BETWEEN %Exp:aRet[2]% AND %Exp:aRet[3]% AND
		ZZ6.%Notdel%
	Endsql
	
	//Seta contagem da regua
	oProcess:SetRegua1(CONREV->CONTADOR)
	//Fecha area aberta
	CONREV->(DbCloseArea())
	
	While !TMPREV->(EOF())
	
		oProcess:IncRegua1( "Relatório do Revendedor : " + TMPREV->Z3_DESENT )
		ProcessMessage()
		
		nVersao  		:= 1 //Se nao existir, o sistema permanecera na primeira versao
				
		If RTrim(TMPREV->ZZ6_CODENT) == "46"
			aCodRev := {'156','2274','46'}
			
			For nI := 1 To Len(aCodRev)
				nVersao  	:= 1 //Se nao existir, o sistema permanecera na primeira versao
				
				//Gera respostas das perguntas
				Perg111(aRet[1],,,aCodRev[nI], aCodRev[nI], 1,,1 )
				
				//Chama relatorio
				aRetorno := STATICCALL( CRPR111, RunReport, Cabec1, Cabec2, Titulo, nLin )
				
				If RTrim(aRetorno[2]) == "CLUBE -  -" .Or. Empty(aRetorno[2])
					loop
				Endif
				
				CpyT2S(aRetorno[1], "\remuneracao\" +aRet[1]+"\",.F.) //Copia da maquina do usuário para o servidor
				
				//Se ja existe, desativa e armazena versao
				ZZG->(DbSetOrder(1))
				If ZZG->(DbSeek(xFilial("ZZG")+aRet[1]+TMPREV->ZZ6_CODENT+PadR(aCodRev[nI],6," ")+"1"))
					nVersao := ZZG->ZZG_VERSAO + 1
					
					RecLock("ZZG")
						ZZG->ZZG_ATIVO := "2"
					ZZG->(MsUnlock())
				
				//Renato Ruy - 22/03/2018
				//Quando usuario desativa todas as versoes, nao reiniciar contagem
				Elseif ZZG->(DbSeek(xFilial("ZZG")+aRet[1]+TMPREV->ZZ6_CODENT+PadR(aCodRev[nI],6," ")))
					nVersao := 2
					While !ZZG->(EOF()) .And. ZZG->ZZG_PERIOD == aRet[1] .And.;
						   ZZG->ZZG_CODENT == TMPREV->ZZ6_CODENT .And.;
						   ZZG->ZZG_FILHO == PadR(aCodRev[nI],6," ")
						If ZZG->ZZG_VERSAO >= nVersao
							nVersao := ZZG->ZZG_VERSAO + 1
						Endif
						ZZG->(DbSkip())   
					Enddo						
				Endif
				
				//Renomeia arquivo
				cNomArq := StrTran(Encode64(DtoS(Date())+StrTran(Time(),":","")+"remuneracao"+Ltrim(Str(Randomize(1,34000)))),"=","")+".xls"
				nStatus := FRename( "\remuneracao\" +aRet[1]+"\"+aRetorno[2], "\remuneracao\" +aRet[1]+"\"+cNomArq)
				
				nContador := 0
				While nStatus == -1 .And. nContador <= 5 
					sleep(500)
					cNomArq := StrTran(Encode64(DtoS(Date())+StrTran(Time(),":","")+"remuneracao"+Ltrim(Str(Randomize(1,34000)))),"=","")+".xls"
					nStatus := FRename( "\remuneracao\" +aRet[1]+"\"+aRetorno[2], "\remuneracao\" +aRet[1]+"\"+cNomArq)	
					nContador++		
				Enddo
				
				//		PERIODO, ENTIDADE PAI	  , ENTIDADE FILHO	, TIPO,ARQUIVO	 , VERSAO , TOTAL
				CriaZZG(aRet[1], TMPREV->ZZ6_CODENT, aCodRev[nI], "10", cNomArq, nVersao, aRetorno[3])
			Next
		Else
			//Gera respostas das perguntas
			Perg111(aRet[1],,,TMPREV->ZZ6_CODENT, TMPREV->ZZ6_CODENT, 2,,1 )
			
			//Chama relatorio
			aRetorno := STATICCALL( CRPR111, RunReport, Cabec1, Cabec2, Titulo, nLin )
			
			If RTrim(aRetorno[2]) == "CLUBE -  -" .Or. Empty(aRetorno[2])
				loop
			Endif
			
			CpyT2S(aRetorno[1], "\remuneracao\" +aRet[1]+"\",.F.) //Copia da maquina do usuário para o servidor
			
			//Se ja existe, desativa e armazena versao
			ZZG->(DbSetOrder(1))
			If ZZG->(DbSeek(xFilial("ZZG")+aRet[1]+TMPREV->ZZ6_CODENT+TMPREV->ZZ6_CODENT+"1"))
				nVersao := ZZG->ZZG_VERSAO + 1
				
				RecLock("ZZG")
					ZZG->ZZG_ATIVO := "2"
				ZZG->(MsUnlock())	
			//Renato Ruy - 22/03/2018
			//Quando usuario desativa todas as versoes, nao reiniciar contagem
			Elseif ZZG->(DbSeek(xFilial("ZZG")+aRet[1]+TMPREV->ZZ6_CODENT+TMPREV->ZZ6_CODENT))
				nVersao := 2
				While !ZZG->(EOF()) .And. ZZG->ZZG_PERIOD == aRet[1] .And.;
					   ZZG->ZZG_CODENT == TMPPOS->Z3_CODENT .And.;
					   ZZG->ZZG_FILHO == PadR(aCodRev[nI],6," ")
					If ZZG->ZZG_VERSAO >= nVersao
						nVersao := ZZG->ZZG_VERSAO + 1
					Endif
					ZZG->(DbSkip())   
				Enddo			
				
			Endif
			
			//Renomeia arquivo
			cNomArq := StrTran(Encode64(DtoS(Date())+StrTran(Time(),":","")+"remuneracao"+Ltrim(Str(Randomize(1,34000)))),"=","")+".xls"
			nStatus := FRename( "\remuneracao\" +aRet[1]+"\"+aRetorno[2], "\remuneracao\" +aRet[1]+"\"+cNomArq)
			
			nContador := 0
			While nStatus == -1 .And. nContador <= 5 
				sleep(500)
				cNomArq := StrTran(Encode64(DtoS(Date())+StrTran(Time(),":","")+"remuneracao"+Ltrim(Str(Randomize(1,34000)))),"=","")+".xls"
				nStatus := FRename( "\remuneracao\" +aRet[1]+"\"+aRetorno[2], "\remuneracao\" +aRet[1]+"\"+cNomArq)	
				nContador++		
			Enddo
			
			//		PERIODO, ENTIDADE PAI	  , ENTIDADE FILHO	, TIPO,ARQUIVO	 , VERSAO , TOTAL
			CriaZZG(aRet[1], TMPREV->ZZ6_CODENT, TMPREV->ZZ6_CODENT, "10", cNomArq, nVersao, aRetorno[3])
		Endif
		
		TMPREV->(DbSkip())
	Enddo

TMPREV->(DbCloseArea())

Return

//Cria registro de integracao
Static Function CriaZZG(cPeriodo, cCodEnt, cFilho, cTipo, cFile, nVersao, nTotal)

	//Efetua Gravacao do registro na ZZG
		RecLock("ZZG", .T.)
			ZZG->ZZG_PERIOD := cPeriodo  
			ZZG->ZZG_CODENT := cCodEnt
			ZZG->ZZG_FILHO  := cFilho
			ZZG->ZZG_TIPO   := cTipo
			ZZG->ZZG_NOMARQ := cFile
			ZZG->ZZG_VERSAO := nVersao   
			ZZG->ZZG_ATIVO  := "1"
			ZZG->ZZG_TOTAL  := nTotal 
		ZZG->(MsUnlock())
		
Return

//Pergunta AC, Canal, Federação e Posto
Static Function Perg101(cPeriodo, cAcD, cAcA, cEntD, cEntA, nTipo, cCcrD, cCcrA)
	
	Default cPeriodo	:= "201802" 	//Periodo 
	Default cAcD		:= " "			// AC De?
	Default cAcA		:= "ZZZZZZ"	// AC Ate?
	Default cEntD		:= " "			// Entidade De?
	Default cEntA		:= "ZZZZZZ"	// Entidade Ate?
	Default nTipo		:= 1			// Tipo de Entidade - 1: Posto, 2: AC, 3: Canal e 4: Federação
	Default cCcrD		:= " "			// AC De?
	Default cCcrA		:= "ZZZZZZ"	// AC Ate?
	
	//Gera respostas das perguntas
	MV_PAR01 := cPeriodo
	MV_PAR02 := cAcD
	MV_PAR03 := cAcA
	MV_PAR04 := cEntD
	MV_PAR05 := cEntA
	MV_PAR06 := nTipo
	MV_PAR07 := cCcrD
	MV_PAR08 := cCcrA
	MV_PAR09 := 1
	MV_PAR10 := GetTempPath()
	MV_PAR11 := 1
	MV_PAR12 := 2
Return

//Pergunta Campanha e Revendedor
Static Function Perg111(cPeriodo, cAcD, cAcA, cEntD, cEntA, nTipo,nLink,nEntid,nDescri)

	Default cPeriodo	:= "201802" 	//Periodo 
	Default cAcD		:= " "			// AC De?
	Default cAcA		:= "ZZZZZZ"	// AC Ate?
	Default cEntD		:= " "			// Entidade De?
	Default cEntA		:= "ZZZZZZ"	// Entidade Ate?
	Default nTipo		:= 1			// Tipo de Entidade - 1: Campanha, 2: Revendedor
	Default nLink		:= 2			// Ordena Por Link - 1: Sim ou 2: Não
	Default nEntid	:= 1			// Ordena Por Entidade - 1: Sim ou 2: Não
	Default nDescri	:= 2			// Ordena Por Descrição - 1: Sim ou 2: Não
	
	//Gera respostas das perguntas
	MV_PAR01 := cPeriodo
	MV_PAR02 := cAcD
	MV_PAR03 := cAcA
	MV_PAR04 := cEntD
	MV_PAR05 := cEntA
	MV_PAR06 := nTipo
	MV_PAR07 := nLink
	MV_PAR08 := GetTempPath()
	MV_PAR09 := nEntid
	MV_PAR10 := nDescri

Return

//Roll back da integração Protheus x Portal da Rede
//Desativa versão atual para o serviço não responder a planilha
User Function CRPA049D
	Local bValid  	:= {|| .T. }
	Local aPar 	:= {}
	
	Private aRet := {}
	
	//Utilizo parambox para fazer as perguntas
	aAdd( aPar,{ 1  ,"Periodo " 	 	,Space(6),"","","","",50,.F.})
	aAdd( aPar,{ 1  ,"Entidade De"	 	,Space(6),"","","","",50,.F.})
	aAdd( aPar,{ 1  ,"Entidade Ate"		,Space(6),"","","","",50,.F.})
	
	If ParamBox( aPar, 'Parâmetros', @aRet, bValid, , , , , ,"CRPA049D" , .T., .F. )
		Processa( {|| CRPA49D() }, "Desativando Integração com Portal da Rede...")
	Else
		Alert("Rotina Cancelada!")
	EndIf
Return

//Efetua procedimento para desativar planilhas
Static Function CRPA49D()

	Beginsql Alias "TMPDES"
	
		SELECT R_E_C_N_O_ RECNOZZG FROM %Table:ZZG%
		WHERE
		ZZG_FILIAL = ' ' AND
		ZZG_PERIOD = %Exp:aRet[1]% AND
		ZZG_CODENT BETWEEN %Exp:aRet[2]% AND %Exp:aRet[3]% AND
		ZZG_ATIVO = '1' AND
		%NOTDEL%	
	
	Endsql
	
	If TMPDES->(EOF())
		alert("Não foi possível encontrar informações com os parâmetros informados!")
		TMPDES->(DbCloseArea())
		Return
	Endif
	
	
	While !TMPDES->(EOF())
		
		ZZG->(DbGoTo(TMPDES->RECNOZZG))
		
		RecLock("ZZG")
			ZZG->ZZG_ATIVO := "2"
		ZZG->(MsUnlock())	
		
		TMPDES->(DbSkip())
	Enddo
	
	MsgInfo("A Integração foi desativada!")
	
	TMPDES->(DbCloseArea())
Return

//Abrir arquivos
User Function CRPA049O

Local cDir := GetTempPath()

//Copia do servidor para maquina local
CpyS2T("\remuneracao\"+ZZG->ZZG_PERIOD+"\"+AllTrim(ZZG->ZZG_NOMARQ), cDir,.F.)

// Exemplo de uso para Windows
shellExecute("Open", cDir+AllTrim(ZZG->ZZG_NOMARQ), " /k dir", "C:\", 1 )

Return