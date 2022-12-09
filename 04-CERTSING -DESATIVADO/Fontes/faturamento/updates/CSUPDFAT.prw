#Include "Protheus.ch"
#Include "FileIO.ch"

#Define DETALHE 4
Static cCSUpdCtl := "CSFTUPDCTL"

//+-------------+---------+-------+-----------------------+------+-------------+
//|Programa:    |CSUPDFAT |Autor: |David Alves dos Santos |Data: |07/03/2016   |
//|-------------+---------+-------+-----------------------+------+-------------|
//|Descricao:   |Gerenciador de updates faturamento - SIGAFAT.                 |
//|-------------+--------------------------------------------------------------|
//|Nomenclatura |CS  = Certisign.                                              |
//|do codigo    |UPD = Update.                                                 |
//|fonte.       |FAT = Modulo faturamento SIGAFAT.                             |
//|-------------+--------------------------------------------------------------|
//|Uso:         |Certisign - Certificadora Digital.                            |
//+-------------+--------------------------------------------------------------+
User Function CSUPDFAT()

	Local oDlgUpd
	Local oChkUpd
	Local oListUpd
	Local oGetHlp
	Local aTitulos   := {'X','Update','Descrição','Detalhes',' ','Status','Chamado/OTRS','Autor','Usuário','Máquina','Data','Hora'}
	Local aColSize   := {8,35,170,50,8,35,55,50,80,80,40,40}
	Local oOk        := LoadBitMap(GetResources(),"LBOK")
	Local oNo        := LoadBitMap(GetResources(),"LBNO")
	Local oExOK      := LoadBitMap(GetResources(),"ok_15")			//-- "checked_15")	
	Local oExNo      := LoadBitMap(GetResources(),"cancel_15")		//-- "nochecked_15")
	Local oPq        := LoadBitMap(GetResources(),"fwstd_lookup")	//-- "btpesq_mdi.bmp")
	Local cGetHlp    := ''
	Local aEmpresas  := {}
	Local lMarcaItem := .T.
	Local lEmpty     := .F.
	Local lOk        := .F.
	Local lLoadAtu   := .F.
	Local bUpdLine   := Nil
	
	Local cTitulo    := "ATUALIZAÇÃO DE DICIONÁRIOS E TABELAS"
	Local aSay       := { "Esta rotina tem como função fazer a atualização dos dicionários do sistema ( SX?/SIX )",;
                     	  "Este processo deve ser executado em modo EXCLUSIVO, ou seja não podem haver outros",;
                     	  "usuários ou jobs utilizando o sistema. É EXTREMAMENTE recomendavél que se faça um",;
                     	  "BACKUP dos DICIONÁRIOS e da BASE DE DADOS antes desta atualização, para que caso ",;
                     	  "ocorram eventuais falhas, esse backup possa ser restaurado." }
	
	Local aButton    := {{ 1, .T., { || lOk := .T., FechaBatch() }},;
                     	{ 2, .T., { || lOk := .F., FechaBatch() }}}
	
	Private oMainWnd := NIL
	Private oProcess := Nil
	Private aListUpd := {}

	Set Century On
	SetStyle(7)
	FormBatch(cTitulo,aSay,aButton)

	If (!lOK)
   		Final("Atualização não realizada.")
	EndIf

	If ( lOpen := MyOpenSm0Ex() )

   		//-- Obtem as Empresas para processamento...
   		SM0->(DbGoTop())
   		While !SM0->(Eof())
      		If AScan(aEmpresas,{ |x| x[2] == SM0->M0_CODIGO}) == 0 //-- So adiciona no array se a empresa for diferente
         		AAdd(aEmpresas,{.T.,SM0->M0_CODIGO,FWGETCODFILIAL,SM0->M0_FILIAL,Recno()})
      		EndIf	
      		SM0->(DbSkip())
   		EndDo

		SM0->(DbGoTop())
   		RpcSetType(3)
   		RpcSetEnv(SM0->M0_CODIGO, FWGETCODFILIAL)
   		nModulo := 05 //-- SIGAFAT
   		lMsFinalAuto := .F.

   		If !CriaTabUpd()
      		Final("Não foi possível criar/abrir a tabela de controle dos updates.")
   		EndIf
	
   		//-- Obtem a lista de Updates disponiveis para execucao:
   		GetListUpd(lLoadAtu,@lEmpty)
   		bUpdLine := {|| { Iif(aListUpd[oListUpd:nAt,1], oOk, oNo),;
                           		aListUpd[oListUpd:nAT,2],;
                           		aListUpd[oListUpd:nAT,3],;
                           		oPq ,; //-- Detalhes
                           		Iif(aListUpd[oListUpd:nAt,5], oExOK, oExNo),;
                           		Iif(aListUpd[oListUpd:nAt,5], 'Executado', 'Pendente'),;
                           		aListUpd[oListUpd:nAT,6],;
                           		aListUpd[oListUpd:nAT,7],;
                           		aListUpd[oListUpd:nAT,8],;
                           		aListUpd[oListUpd:nAT,9],;
                           		aListUpd[oListUpd:nAT,10],;
                           		aListUpd[oListUpd:nAT,11];
                           		} }

   		DEFINE MSDIALOG oDlgUpd;
   		TITLE 'Gerenciador de Updates SIGAFAT - Protheus | Especifico Certisign' FROM 00,00 TO 410,760 PIXEL
		
   			oChkUpd := TCheckBox():New(05,05,'Listar updates já processados?',{||lLoadAtu},oDlgUpd,100,25,,;
                           			{||lLoadAtu:=!lLoadAtu,;
	                              		GetListUpd(lLoadAtu,@lEmpty),;
                              			oListUpd:SetArray(aListUpd),;
                              			oListUpd:lReadOnly := lEmpty,;
                              			oListUpd:bLine := bUpdLine,;
                              			oListUpd:Refresh()},,,,,,.T.)
   			oGetHlp := TGet():New(1,1,{|u|Iif(PCount() > 0,cGetHlp:=u,cGetHlp)},oDlgUpd,1,1)
   			oListUpd := TWBrowse():New(20,05,370,160,,aTitulos,aColSize,oDlgUpd,,,,,,,,,,,,,"ARRAY",.T.)
   			oListUpd:bLDblClick := {|oBrw,nCol,aDim|Iif(!lEmpty,BrwDblClick(aListUpd,oDlgUpd,oGetHlp,oListUpd,nCol,oListUpd:nAt),{||.T.})}
   			oListUpd:SetArray(aListUpd)
   			oListUpd:lReadOnly  := lEmpty
   			oListUpd:bLine      := bUpdLine
   			oListUpd:bHeaderClick := {|oBrw,nCol,aDim|;
                             			Iif((nCol==1 .And. !lEmpty),;
                             			(AEval(aListUpd,{|aElem| aElem[1] := lMarcaItem}),;
                              			lMarcaItem := !lMarcaItem,;
                              			oListUpd:Refresh()),;
                             			/*Else*/)}
	
   			TButton():New( 190,005, 'Selecionar Empresas', oDlgUpd,;
               			{|| Iif(lEmpty,.T., aEmpresas := CSSelectSM0(@aEmpresas))},;
               			060,012,,,,.T.,,,,,,)
			
   			TButton():New( 190,294, 'Processar...', oDlgUpd,;
               			{|| ProcClick( aListUpd, aEmpresas, oDlgUpd ) },;
               			038,012,,,,.T.,,,,,,)
			
   			TButton():New( 190,337, 'Cancelar', oDlgUpd,;
               			{|| RpcClearEnv(), oDlgUpd:End()},;
               			038,012,,,,.T.,,,,,,)
			
		ACTIVATE MSDIALOG oDlgUpd CENTERED

	EndIf

Return


//+-------------+------------+-------+-----------------------+------+-------------+
//|Programa:    |BrwDblClick |Autor: |David Alves dos Santos |Data: |07/03/2016   |
//|-------------+------------+-------+-----------------------+------+-------------|
//|Descricao:   |Ao dar um duplo clique sobre a coluna de HELP                    |
//|-------------+-----------------------------------------------------------------|
//|Uso:         |Certisign - Certificadora Digital.                               |
//+-------------+-----------------------------------------------------------------+
Static Function BrwDblClick(aListUpd, oDlgUpd, oGetHlp, oBrw, nCol, nRow)
	
	Local oRect      := TRect():New(0,0,0,0)
	Local nBordaEsq  := 0
	Local nBordaSup  := 0
	Local nCelHeight := 0

   	If nCol==DETALHE
		oDlgUpd:CoorsUpdate()
      	nBordaEsq := (oDlgUpd:nWidth - oDlgUpd:nClientWidth) / 2
      	nBordaSup := (oDlgUpd:nHeight - oDlgUpd:nClientHeight) - nBordaEsq
      	//-- Esta parte é só para forçar o HELP a abrir logo abaixo da célula
      	oBrw:GetCellRect(nCol,nRow,oRect)
      	nCelHeight  := oRect:nBottom - oRect:nTop
      	oRect:nTop  := oRect:nTop - (oDlgUpd:nTop + nBordaSup) + nCelHeight
      	oRect:nLeft := oRect:nLeft - (oDlgUpd:nLeft + nBordaEsq)
      	oGetHlp:Move(oRect:nTop,oRect:nLeft,1,1,Nil,.T.)
      	oGetHlp:SetFocus()
      	//-- Abertura do HELP
      	ShowHelpCpo(aListUpd[nRow,2],aListUpd[nRow,nCol,1],Len(aListUpd[nRow,nCol,1]),{"Este update não possui critério de validação"},1)
      	oBrw:SetFocus()
   	Else
      	aListUpd[nRow,1] := !aListUpd[nRow,1]
      	oBrw:Refresh()
   	EndIf
   	
Return .T.


//+-------------+------------+-------+-----------------------+------+-------------+
//|Programa:    |ProcClick   |Autor: |David Alves dos Santos |Data: |07/03/2016   |
//|-------------+------------+-------+-----------------------+------+-------------|
//|Descricao:   |Ao clicar no botão processar.                                    |
//|-------------+-----------------------------------------------------------------|
//|Uso:         |Certisign - Certificadora Digital.                               |
//+-------------+-----------------------------------------------------------------+
Static Function ProcClick( aListUpd, aEmpresas, oDlgUpd )
   
   If Empty(aListUpd[1,2])
      Return .F.
   EndIf
   RpcClearEnv()
   oProcess := MsNewProcess():New({||CSProcUpd( aListUpd, aEmpresas )}, "Atualizando Base de Dados", 'Aguarde o termino do processamento ...', .F. )
   oProcess:Activate()
   oDlgUpd:End()
   
Return .T.


//+-------------+------------+-------+-----------------------+------+-------------+
//|Programa:    |CSProcUpd   |Autor: |David Alves dos Santos |Data: |07/03/2016   |
//|-------------+------------+-------+-----------------------+------+-------------|
//|Descricao:   |PROCESSA A ATUALIZACAO DO AMBIENTE                               |
//|-------------+-----------------------------------------------------------------|
//|Uso:         |Certisign - Certificadora Digital.                               |
//+-------------+-----------------------------------------------------------------+
Static Function CSProcUpd( aListUpd, aEmpresas )
	
	Local nAux       := 0
	Local nCntUpd    := 0
	Local nCntEmp    := 0
	Local nCntTar    := 0
	Local nEmpresa   := 0
	Local bGrvUpd    := .T.
	Local cAliasRec  := ""
	Local cQuery     := ""
	Local nRecnoUpd  := 0
	Local nPosTam    := 0
	Local nPosSXG    := 0
	
	Local aEstrutSIX := {}
	Local aEstrutSX2 := {}
	Local aEstrutSX3 := {}
	Local aEstrutSX5 := {}
	Local aEstrutSX7 := {}
	Local aEstrutSX9 := {}
	Local aEstrutSXA := {}
	Local aEstrutSXB := {}
	Local aEstrutSX6 := {}
	
	Local aSX2       := {}
	Local aSIX       := {}
	Local aSX3       := {}
	Local aSX5       := {}
	Local aSX7       := {}
	Local aSX9       := {}
	Local aSXA       := {}
	Local aSXB       := {}
	Local aSX6       := {}
	Local aExcFun    := {}
	Local aAtualiza  := {{},{},{},{},{},{},{},{},{},{}}

	Local aArqUpd    := {}
	Local lDelInd    := .F.
	Local cMsg       := ""
	
	Local i          := 0
	Local j          := 0
	
	Private aTarefas   := {}
	Private aResumo    := {}
	
	aEstrutSX2 := { "X2_CHAVE"   , "X2_PATH"    , "X2_ARQUIVO", "X2_NOME"    , "X2_NOMESPA", "X2_NOMEENG", "X2_DELET"  , "X2_MODO"   ,;
               	    "X2_TTS"     , "X2_ROTINA"  , "X2_PYME"   , "X2_UNICO"   , "X2_MODOEMP", "X2_MODOUN" , "X2_MODULO" , "X2_SYSOBJ" ,;
               	    "X2_USROBJ"}
	
	aEstrutSIX := { "INDICE"     , "ORDEM"      , "CHAVE"     , "DESCRICAO"  , "DESCSPA"   , "DESCENG"   , "PROPRI"    , "F3"        ,;
               	    "NICKNAME"   , "SHOWPESQ"}
	
	aEstrutSX3 := { "X3_ARQUIVO" , "X3_ORDEM"   , "X3_CAMPO"  , "X3_TIPO"   , "X3_TAMANHO", "X3_DECIMAL", "X3_TITULO" , "X3_TITSPA" ,;
               	    "X3_TITENG"  , "X3_DESCRIC" , "X3_DESCSPA", "X3_DESCENG", "X3_PICTURE", "X3_VALID"  , "X3_USADO"  , "X3_RELACAO",;
               	    "X3_F3"      , "X3_NIVEL"   , "X3_RESERV" , "X3_CHECK"  , "X3_TRIGGER", "X3_PROPRI" , "X3_BROWSE" , "X3_VISUAL" ,;
               	    "X3_CONTEXT" , "X3_OBRIGAT" , "X3_VLDUSER", "X3_CBOX"   , "X3_CBOXSPA", "X3_CBOXENG", "X3_PICTVAR", "X3_WHEN"   ,;
               	    "X3_INIBRW"  , "X3_GRPSXG"  , "X3_FOLDER" , "X3_PYME"   , "X3_ORTOGRA", "X3_IDXFLD"}

	aEstrutSX5 := { "X5_TABELA"  , "X5_CHAVE"   , "X5_DESCRI" , "X5_DESCSPA", "X5_DESCENG" }

	aEstrutSX7 := { "X7_CAMPO"   , "X7_SEQUENC" , "X7_REGRA"  , "X7_CDOMIN" , "X7_TIPO"   , "X7_SEEK"   , "X7_ALIAS"  , "X7_ORDEM"  ,;
               	    "X7_CHAVE"   , "X7_PROPRI"  , "X7_CONDIC" }
	
	aEstrutSX9 := { "X9_DOM"     , "X9_IDENT"   , "X9_CDOM"   , "X9_EXPDOM", "X9_EXPCDOM", "X9_PROPRI", ;
               	    "X9_LIGDOM"  , "X9_LIGCDOM" , "X9_CONDSQL", "X9_USEFIL", "X9_ENABLE" , "X9_VINFIL", "X9_CHVFOR"}
	
	aEstrutSXA := { "XA_ALIAS"   , "XA_ORDEM"   , "XA_DESCRIC", "XA_DESCSPA", "XA_DESCENG", "XA_PROPRI", "XA_AGRUP", "XA_TIPO" }
	
	aEstrutSXB := { "XB_ALIAS"   , "XB_TIPO"    , "XB_SEQ"    , "XB_COLUNA" , "XB_DESCRI" , "XB_DESCSPA", "XB_DESCENG", "XB_CONTEM" ,;
               	    "XB_WCONTEM"}
	
	aEstrutSX6 := { "X6_FIL"     , "X6_VAR"    , "X6_TIPO"   , "X6_DESCRIC", "X6_DSCSPA" , "X6_DSCENG" , "X6_DESC1"  , "X6_DSCSPA1",;
               	    "X6_DSCENG1" , "X6_DESC2"  , "X6_DSCSPA2", "X6_DSCENG2", "X6_CONTEUD", "X6_CONTSPA", "X6_CONTENG", "X6_PROPRI" ,;
               	    "X6_PYME"    , "X6_VALID"  , "X6_INIT"   , "X6_DEFPOR" , "X6_DEFSPA" , "X6_DEFENG"}

	nPosTam := AScan(aEstrutSX3,"X3_TAMANHO")
	nPosSXG := AScan(aEstrutSX3,"X3_GRPSXG")
	//-- Contando o número de updates a serem processados
	For nAux := 1 To Len(aListUpd)
   		If aListUpd[nAux,1]
      		nCntUpd++
   		EndIf
	Next
	//-- Contando o número de empresas a serem processados
	For nEmpresa := 1 To Len(aEmpresas)
   		If aEmpresas[nEmpresa,1]
			nCntEmp++
   		EndIf
	Next
	//-- Multiplicando pelo número de empresas
	nCntUpd := nCntUpd * nCntEmp
	oProcess:SetRegua2(nCntUpd)

	For nEmpresa := 1 To Len(aEmpresas)
   		//-- Se não processa esta empresa
   		If !aEmpresas[nEmpresa,1]
      		Loop
   		EndIf
   		//-- Se não conseguiu abrir o arquivo de empresa em modo exclusivo
   		If !MyOpenSm0Ex()
      		Loop
   		EndIf 
   		//-- Se não conseguiu criar um ambiente
   		SM0->(DbGoTo(aEmpresas[nEmpresa,5]))
   		RpcSetType(3)
   		If !RpcSetEnv(SM0->M0_CODIGO, FWGETCODFILIAL)
      		Loop
   		EndIf
   		//-- Processa as atualizações
   		nModulo := 05 //SIGAFAT
   		lMsFinalAuto := .F.
   		aTarefas   := {}
   		aAtualiza  := {{},{},{},{},{},{},{},{},{},{}}
   		If bGrvUpd
      		CriaTabUpd()
   		EndIf
   		
   		//-- INICIO DAS ATUALIZACOES
   		For nAux := 1 To Len(aListUpd)
      		//-- Se não processa o conversor
      		If !aListUpd[nAux,1]
         		Loop
      		EndIf 
      		aSX2       := {}
      		aSIX       := {}
      		aSX3       := {}
      		aSX5       := {}
      		aSX7       := {}
      		aSX9       := {}
      		aSXB       := {}
      		aSX6       := {}
      		aExcFun    := {}
      		oProcess:IncRegua1( "Processando "+ aListUpd[nAux,2] + " - " + SM0->M0_CODIGO + " " + AllTrim(SM0->M0_NOME) + " ..." )
      		//-- Obtem a lista de tarefas conforme updates selecionados na lista
      		conout("Lendo a lista de tarefas do "+aListUpd[nAux,2])
      		//-- ESTRUTURA DO ARRAY aTarefas:
      		//-- aTarefas[01] - Array com os dados SX2
      		//-- aTarefas[02] - Array com os dados SIX
      		//-- aTarefas[03] - Array com os dados SX3
      		//-- aTarefas[04] - Array com os dados SX5
      		//-- aTarefas[05] - Array com os dados SX7
      		//-- aTarefas[06] - Array com os dados SX9
      		//-- aTarefas[07] - Array com os dados SXA
      		//-- aTarefas[08] - Array com os dados SXB
      		//-- aTarefas[09] - Array com os dados SX6
      		//-- aTarefas[10] - Array com as rotina pós Update
      		aTarefas := &( "u_" + aListUpd[nAux,2] + '()' )
		
      		For i := 1 To Len(aTarefas[1]) //-- SX2
         		AAdd( aSX2, aTarefas[1,i] )
      		Next
		
      		For i := 1 To Len(aTarefas[2]) //-- SIX
         		AAdd( aSIX, aTarefas[2,i] )
      		Next
		
      		For i := 1 To Len(aTarefas[3]) //-- SX3
         		AAdd( aSX3, aTarefas[3,i] )
      		Next
		
      		For i := 1 To Len(aTarefas[4]) //-- SX5
         		AAdd( aSX5, aTarefas[4,i] )
      		Next
		
      		For i := 1 To Len(aTarefas[5]) //-- SX7
         		AAdd( aSX7, aTarefas[5,i] )
      		Next
	
      		For i := 1 To Len(aTarefas[6]) //-- SX9
         		AAdd( aSX9, aTarefas[6,i] )
      		Next
		
      		For i := 1 To Len(aTarefas[7]) //-- SXA
         		AAdd( aSXA, aTarefas[7,i] )
      		Next
		
      		For i := 1 To Len(aTarefas[8]) //-- SXB
         		AAdd( aSXB, aTarefas[8,i] )
      		Next
		
      		If Len(aTarefas) >= 9 .And. Type("aTarefas[9]") == "A"
         		For i := 1 To Len(aTarefas[9]) //-- SX6
            		AAdd( aSX6, aTarefas[9,i] )
         		Next
      		EndIf
		
      		//--Acrescentado parametro: rotinas de ajuste de base dados
      		If Len(aTarefas) >= 10 .And. Type("aTarefas[10]") == "A"
         		For i := 1 To Len(aTarefas[10]) //--Rotinas de ajuste
            		If ValType(aTarefas[10,i]) == "C" //-- Nome de função
               		If FindFunction( aTarefas[10,i] )
                  		AAdd( aExcFun, aTarefas[10,i] )
               		EndIf
            		ElseIf ValType(aTarefas[10,i]) == "B" //-- Bloco de código
               		AAdd( aExcFun, aTarefas[10,i] )
            		EndIf
         		Next
      		EndIf
      		//-- Contando o número de ações fazer
      		nCntTar := 0
      		For i := 1 To Len(aTarefas)
         		If !Empty(aTarefas[i])
            		nCntTar++
         		EndIf
      		Next
      		oProcess:SetRegua2(nCntTar)
      		conout("Número de tarefas do "+aListUpd[nAux,2]+": "+AllTrim(Str(nCntTar)))
      		
      		//-- PROCESSA ATUALIZACOES - SX2
      		If Len(aSX2) > 0
         		oProcess:IncRegua2( "Dicionário de arquivos" + " - " + SM0->M0_CODIGO + " " + AllTrim(SM0->M0_NOME) + " ..." )
         		conout( "Dicionário de arquivos" + " - " + SM0->M0_CODIGO + " " + AllTrim(SM0->M0_NOME) + " ..." )
      		EndIf
      		SX2->(DbSetOrder(1))
      		For i := 1 To Len(aSX2)
         		conout( "Atualizando tabela "+aSX2[i,1])
         		If !SX2->(MsSeek(aSX2[i,1]))
            		RecLock("SX2",.T.)
         		Else
	         		//Caso tenha mudado o indice unico apaga o mesmo
	         		If Len(aSX2[i]) > 11 .And. aSX2[i,12] != Nil
	            		If !Empty(SX2->X2_UNICO) //Se não está vazio o indice unico
	               		If Upper( AllTrim( SX2->X2_UNICO ) ) <> Upper( AllTrim( aSX2[i,12] ) ) //Se está diferente do valor do array
	                  		If MSFILE( RetSqlName( aSX2[i,1] ),RetSqlName( aSX2[i,1] ) + '_UNQ', "TOPCONN" ) //Checa se o indice existe
	                     		TcInternal(60,RetSqlName(aSX2[i,1]) + "|" + RetSqlName(aSX2[i,1]) + "_UNQ") //Exclui sem precisar baixar o TOP
	                  		EndIf
	               		EndIf
	            		EndIf
	         		EndIf
            		RecLock('SX2',.F.)
         		EndIf
         		For j := 1 To Len(aSX2[i])
            		If SX2->(FieldPos(aEstrutSX2[j])) > 0 .And. aSX2[i,j] <> Nil
               		SX2->(FieldPut(FieldPos(aEstrutSX2[j]),aSX2[i,j]))
            		EndIf
         		Next j
         		SX2->(dbCommit())
         		SX2->(MsUnLock())
         		AAdd(aAtualiza[1], AClone(aSX2[i]) )
      		Next i
      		
      		//-- ATUALIZANDO O SX3
      		If Len(aSX3) > 0
         		oProcess:IncRegua2( "Dicionário de campos" + " - " + SM0->M0_CODIGO + " " + AllTrim(SM0->M0_NOME) + " ..." )
         		conout( "Dicionário de campos" + " - " + SM0->M0_CODIGO + " " + AllTrim(SM0->M0_NOME) + " ..." )
      		EndIf
      		SX3->(DbSetOrder(2))
      		SXG->(DbSetOrder(1))
      		For i := 1 To Len(aSX3)
         		If !Empty(aSX3[i,1])
            		conout( "Atualizando campos tabela "+aSX3[i,1])
            		If Len(aSX3[i]) >= nPosSXG
               		If !Empty(aSX3[i,nPosSXG])
                  		//-- Busca o tamanho do campo na tabela de grupos
                  		If SXG->(DbSeek(Padr(aSX3[i,nPosSXG],Len(SXG->XG_GRUPO))))
                     		If aSX3[i,nPosTam] <> SXG->XG_SIZE
                        			conout( "Alterado tamanho do campo " +AllTrim(aSX3[i,3])+ " - Tamanho Original: " +AllTrim(Str(aSX3[i,nPosTam]))+ ", Tamanho Grupo: " +AllTrim(Str(SXG->XG_SIZE)) )
                        			aSX3[i,nPosTam] := SXG->XG_SIZE
                     		EndIf
                  		EndIf
               		EndIf
            		EndIf
            		If !SX3->(dbSeek(Padr(aSX3[i,3],Len(SX3->X3_CAMPO))))
               		If AScan(aArqUpd,aSX3[i,1]) == 0
                  		aAdd(aArqUpd,aSX3[i,1])
               		EndIf
               		RecLock("SX3",.T.)
            		Else
               		If AScan(aArqUpd,aSX3[i,1]) == 0
                  		aAdd(aArqUpd,aSX3[i,1])
               		EndIf
               		RecLock("SX3",.F.)
            		EndIf
            		conout( "Atualizando campo "+AllTrim(aSX3[i,3])+" da tabela "+aSX3[i,1])
            		For j:=1 To Len(aSX3[i])
               		If SX3->(FieldPos(aEstrutSX3[j])) > 0 .And. aSX3[i,j] != NIL
                  		SX3->(FieldPut(FieldPos(aEstrutSX3[j]),aSX3[i,j]))
               		EndIf
            		Next j
            		SX3->(dbCommit())
            		SX3->(MsUnLock())
            		AAdd( aAtualiza[3], AClone(aSX3[i]) )
         		EndIf
      		Next i
      		
      		//-- PROCESSA ATUALIZACOES - SIX
      		If Len(aSIX) > 0
         		oProcess:IncRegua2( "Dicionário de índices" + " - " + SM0->M0_CODIGO + " " + AllTrim(SM0->M0_NOME) + " ..." )
         		conout( "Dicionário de índices" + " - " + SM0->M0_CODIGO + " " + AllTrim(SM0->M0_NOME) + " ..." )
      		EndIf
      		SIX->(DbSetOrder(1))
      		For i := 1 To Len(aSIX)
         		If !Empty(aSIX[i,1])
            		conout( "Atualizando indices da tabela "+aSIX[i,1])
            		If !SIX->(MsSeek(aSIX[i,1]+aSIX[i,2]))
               		RecLock("SIX",.T.)
               		lDelInd := .F.
            		Else
               		RecLock("SIX",.F.)
               		lDelInd := .T. //Se for alteracao precisa apagar o indice do banco
            		EndIf
            		If UPPER(AllTrim(SIX->CHAVE)) != UPPER(Alltrim(aSIX[i,3]))
               		If AScan( aArqUpd, aSIX[i,1] ) == 0
                  		aAdd(aArqUpd,aSIX[i,1])
               		EndIf
               		For j := 1 To Len(aSIX[i])
                  		If SIX->(FieldPos(aEstrutSIX[j])) > 0
                     		SIX->(FieldPut(FieldPos(aEstrutSIX[j]),aSIX[i,j]))
                  		EndIf
               		Next j
               		SIX->(dbCommit())
               		SIX->(MsUnLock())
               		If lDelInd
                  		TcInternal(60,RetSqlName(aSix[i,1]) + "|" + RetSqlName(aSix[i,1]) + aSix[i,2]) //Exclui sem precisar baixar o TOP
               		Endif
               		AAdd( aAtualiza[2], AClone(aSIX[i]) )
            		EndIf
         		EndIf
      		Next i
      		__SetX31Mode(.F.)
      		For i := 1 To Len(aArqUpd)
         		If Select(aArqUpd[i]) > 0
            		DbSelectArea(aArqUpd[i])
            		dbCloseArea()
         		EndIf
         		X31UpdTable(aArqUpd[i])
         		If __GetX31Error()
            		MsgAlert(__GetX31Trace())
            		Aviso("Atencao!","Ocorreu um erro desconhecido durante a atualizacao da tabela : "+ aArqUpd[i] + ". Verifique a integridade do dicionario e da tabela.",{"Continuar"},2)
         		EndIf
      		Next i
      		
      		//-- ATUALIZANDO O SX5
      		If Len(aSX5) > 0
         		oProcess:IncRegua2( "Dicionário de tabelas genéricas" + " - " + SM0->M0_CODIGO + " " + AllTrim(SM0->M0_NOME) + " ..." )
         		conout( "Dicionário de tabelas genéricas" + " - " + SM0->M0_CODIGO + " " + AllTrim(SM0->M0_NOME) + " ..." )
      		EndIf
      		SX5->(DbSetOrder(1)) //--X5_FILIAL+X5_TABELA+X5_CHAVE
      		For i := 1 To Len(aSX5)
         		If !Empty(aSX5[i,1])
            		conout( "Atualizando tabela generica "+aSX5[i,1])
            		If !SX5->(Msseek(xFilial('SX5') + PadR(aSX5[i,1],Len(SX5->X5_TABELA)) + PadR(aSX5[i,2],Len(SX5->X5_CHAVE))))
               		RecLock("SX5",.T.)
               		SX5->X5_FILIAL := xFilial('SX5')
            		Else
               		RecLock("SX5",.F.)
            		Endif
            		For j :=1 To Len(aSX5[i])
               		If !Empty(SX5->(FieldName(FieldPos(aEstrutSX5[j]))))
                  		SX5->(FieldPut(FieldPos(aEstrutSX5[j]),aSX5[i,j]))
               		EndIf
            		Next j
            		SX5->(dbCommit())
            		SX5->(MsUnLock())
            		AAdd( aAtualiza[4], AClone(aSX5[i]) )
         		EndIf
      		Next i
      		
      		//-- ATUALIZANDO O SX7
      		If Len(aSX7) > 0
         		oProcess:IncRegua2( "Dicionário de gatilhos" + " - " + SM0->M0_CODIGO + " " + AllTrim(SM0->M0_NOME) + " ..." )
         		conout( "Dicionário de tabelas genéricas" + " - " + SM0->M0_CODIGO + " " + AllTrim(SM0->M0_NOME) + " ..." )
      		EndIf
      		SX7->(DbSetOrder(1))
      		For i := 1 To Len(aSX7)
         		If !Empty(aSX7[i][1])
            		conout( "Atualizando gatilho do campo "+aSX7[i,1])
            		If !SX7->(Msseek( PadR(aSX7[i,1],Len(SX7->X7_CAMPO)) + aSX7[i,2] ))
               		RecLock("SX7",.T.)
            		Else
               		RecLock("SX7",.F.)
            		Endif
            		For j :=1 To Len(aSX7[i])
               		If !Empty(SX7->(FieldName(FieldPos(aEstrutSX7[j]))))
                  		SX7->(FieldPut(FieldPos(aEstrutSX7[j]),aSX7[i,j]))
               		EndIf
            		Next j
            		SX7->(dbCommit())
            		SX7->(MsUnLock())
            		AAdd( aAtualiza[5], AClone(aSX7[i]) )
         		EndIf
      		Next i
      		
      		//-- ATUALIZANDO O SX9
      		If Len(aSX9) > 0
         		oProcess:IncRegua2( "Dicionário de relacionamentos" + " - " + SM0->M0_CODIGO + " " + AllTrim(SM0->M0_NOME) + " ..." )
         		conout( "Dicionário de relacionamentos" + " - " + SM0->M0_CODIGO + " " + AllTrim(SM0->M0_NOME) + " ..." )
      		EndIf
      		SX9->(DbSetOrder(2))
      		For i := 1 To Len(aSX9)
         		If !Empty(aSX9[i][1])
            		conout( "Atualizando relacionamento da tabela "+aSX9[i,1]+" com "+aSX9[i,3])
            		If !SX9->(MsSeek( PadR(aSX9[i,3],Len(SX9->X9_CDOM)) + PadR(aSX9[i,1],Len(SX9->X9_DOM) )))
               		RecLock("SX9",.T.)
            		Else
               		RecLock("SX9",.F.)
            		EndIf
            		For j :=1 To Len(aSX9[i])
               		If !Empty(SX9->(FieldName(FieldPos(aEstrutSX9[j]))))
                  		SX9->(FieldPut(FieldPos(aEstrutSX9[j]),aSX9[i,j]))
               		EndIf
            		Next j
            		SX9->(dbCommit())
            		SX9->(MsUnLock())
            		AAdd( aAtualiza[6], AClone(aSX9[i]) )
         		EndIf
      		Next i
      		
      		//-- ATUALIZANDO O SXA
      		If Len(aSXA) > 0
         		oProcess:IncRegua2( "Dicionário de pastas cadastrais" + " - " + SM0->M0_CODIGO + " " + AllTrim(SM0->M0_NOME) + " ..." )
         		conout( "Dicionário de pastas cadastrais" + " - " + SM0->M0_CODIGO + " " + AllTrim(SM0->M0_NOME) + " ..." )
      		EndIf
      		SXA->(DbSetOrder(1))
      		For i := 1 To Len(aSXA)
         		If !Empty(aSXA[i,1])
            		conout( "Atualizando pastas cadastrais "+aSXA[i,1])
            		If !SXA->(Msseek( aSXA[i,1] + aSXA[i,2]))
               		RecLock("SXA",.T.)
            		Else
               		RecLock("SXA",.F.)
            		Endif
            		For j :=1 To Len(aSXA[i])
               		If !Empty(SXA->(FieldName(FieldPos(aEstrutSXA[j]))))
                  		SXA->(FieldPut(FieldPos(aEstrutSXA[j]),aSXA[i,j]))
               		EndIf
            		Next j
            		SXA->(dbCommit())
            		SXA->(MsUnLock())
            		AAdd( aAtualiza[7], AClone(aSXA[i]) )
         		EndIf
      		Next i
      		
      		//-- ATUALIZANDO O SXB
      		If Len(aSXB) > 0
         		oProcess:IncRegua2( "Dicionário de consultas padrão" + " - " + SM0->M0_CODIGO + " " + AllTrim(SM0->M0_NOME) + " ..." )
         		conout( "Dicionário de consultas padrão" + " - " + SM0->M0_CODIGO + " " + AllTrim(SM0->M0_NOME) + " ..." )
      		EndIf
      		SXB->(DbSetOrder(1)) //--XB_ALIAS+XB_TIPO+XB_SEQ+XB_COLUNA
      		For i := 1 To Len(aSXB)
         		If !Empty(aSXB[i,1])
            		conout( "Atualizando consulta padrão "+aSXB[i,1])
            		If !SXB->(Msseek( PadR(aSXB[i,1],Len(SXB->XB_ALIAS)) + aSXB[i,2] + aSXB[i,3] + aSXB[i,4] ))
               		RecLock("SXB",.T.)
               		SX5->X5_FILIAL := xFilial('SX5')
            		Else
               		RecLock("SXB",.F.)
            		Endif
            		For j :=1 To Len(aSXB[i])
               		If !Empty(SXB->(FieldName(FieldPos(aEstrutSXB[j]))))
                  		SXB->(FieldPut(FieldPos(aEstrutSXB[j]),aSXB[i,j]))
               		EndIf
            		Next j
            		SXB->(dbCommit())
            		SXB->(MsUnLock())
            		AAdd( aAtualiza[8], AClone(aSXB[i]) )
         		EndIf
      		Next i
      		
      		//-- PROCESSA ATUALIZACOES - SX6
      		If Len(aSX6) > 0
         		oProcess:IncRegua2( "Dicionário de parâmetros" + " - " + SM0->M0_CODIGO + " " + AllTrim(SM0->M0_NOME) + " ..." )
         		conout( "Dicionário de parâmetros" + " - " + SM0->M0_CODIGO + " " + AllTrim(SM0->M0_NOME) + " ..." )
      		EndIf
      		SX6->(DbSetOrder(1))
      		For i := 1 To Len(aSX6)
         		conout( "Atualizando parametro "+aSX6[i,2])
         		If !SX6->(MsSeek(aSX6[i,1]+aSX6[i,2]))
            		RecLock("SX6",.T.)
         		Else
            		RecLock('SX6',.F.)
         		EndIf
         		For j:=1 To Len(aSX6[i])
            		If SX6->(FieldPos(aEstrutSX6[j])) > 0
               		SX6->(FieldPut(FieldPos(aEstrutSX6[j]),aSX6[i,j]))
            		EndIf
         		Next j
         		SX6->(dbCommit())
         		SX6->(MsUnLock())
         		AAdd(aAtualiza[9], AClone(aSX6[i]) )
      		Next i
      		If Len(aExcFun) > 0
         		oProcess:IncRegua2( "Rotina de ajuste" + " - " + SM0->M0_CODIGO + " " + AllTrim(SM0->M0_NOME) + " ..." )
         		conout( "Rotina de ajuste" + " - " + SM0->M0_CODIGO + " " + AllTrim(SM0->M0_NOME) + " ..." )
      		EndIf
      		//--Rotinas de ajuste de base apos criacao de tabelas, campos e indices.
      		For i := 1 To Len(aExcFun)
         		If ValType(aExcFun[i]) == "C" //-- Nome de função
            		conout( "Atualizando função "+AllTrim(aExcFun[i]))
            		cMsg := &(AllTrim(aExcFun[i]) + '()' )
            		AAdd( aAtualiza[10], {aExcFun[i],cMsg} )
         		ElseIf ValType(aExcFun[i]) == "B" //-- Bloco de código
            		conout( "Atualizando função "+GetCbSource(aExcFun[i]))
            		cMsg := Eval(aExcFun[i])
            		AAdd( aAtualiza[10], {GetCbSource(aExcFun[i]),cMsg} )
         		EndIf
      		Next i
      		//-- Grava o registro  do UPDATE atualizado
      		If bGrvUpd
         		DbSelectArea(cCSUpdCtl)
         		If (cCSUpdCtl)->(MsSeek(aListUpd[nAux,2],.F.))
            		cQuery := "UPDATE "+cCSUpdCtl
            		cQuery += " SET MAQUINA ='"+ComputerName()+"',USUARIO='"+LogUserName()+"',DATAUPD='"+DtoS(Date())+"',HORAUPD='"+Time()+"'"
            		cQuery += " WHERE NOMEUPD = '"+aListUpd[nAux,2]+"'"
         		Else
            		cQuery := "SELECT MAX(R_E_C_N_O_) RECNO FROM "+cCSUpdCtl
            		cAliasRec := GetNextAlias()
            		DbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasRec,.T.,.T.)
            		TCSetField(cAliasRec,'RECNO','N',10,0)
            		If (cAliasRec)->(!Eof())
               		nRecnoUpd := (cAliasRec)->Recno
            		EndIf
            		(cAliasRec)->(DbCloseArea())
            		nRecnoUpd++
            		cQuery := "INSERT INTO "+cCSUpdCtl+" (NOMEUPD,MAQUINA,USUARIO,DATAUPD,HORAUPD,R_E_C_N_O_)"
            		cQuery += " VALUES ('"+aListUpd[nAux,2]+"','"+ComputerName()+"','"+LogUserName()+"','"+DtoS(Date())+"','"+Time()+"',"+AllTrim(Str(nRecnoUpd))+")"
         		EndIf
         		TcSQLExec(cQuery)
      		EndIf
   		Next
   		bGrvUpd := .F.
   		RpcClearEnv()
   		AAdd(aResumo, {aEmpresas[nEmpresa,2] + ' - ' + aEmpresas[nEmpresa,3] + ': ' + aEmpresas[nEmpresa,4], aAtualiza} )
	Next

	CSViewLog( aResumo )

Return


//+-------------+------------+-------+-----------------------+------+-------------+
//|Programa:    |MyOpenSM0Ex |Autor: |David Alves dos Santos |Data: |07/03/2016   |
//|-------------+------------+-------+-----------------------+------+-------------|
//|Descricao:   |Efetua a abertura do SM0 exclusivo                               |
//|-------------+-----------------------------------------------------------------|
//|Uso:         |Certisign - Certificadora Digital.                               |
//+-------------+-----------------------------------------------------------------+
Static Function MyOpenSM0Ex()

	Local lOpen := .F.
	Local nLoop := 0
	
	SET DELETED ON
	
	For nLoop := 1 To 20
   		DbUseArea( .T.,, "SIGAMAT.EMP", "SM0", .F., .F. )
   		If !Empty( Select( "SM0" ) )
	      	lOpen := .T.
     	 	DbSetIndex("SIGAMAT.IND")
      		Exit
   		EndIf
   		Sleep( 500 )
	Next nLoop
		
	If !lOpen
   		MsgAlert( "Nao foi possivel a abertura da tabela de empresas de forma exclusiva !" )
	EndIf
		
Return( lOpen )


//+-------------+------------+-------+-----------------------+------+-------------+
//|Programa:    |GetListUpd  |Autor: |David Alves dos Santos |Data: |07/03/2016   |
//|-------------+------------+-------+-----------------------+------+-------------|
//|Descricao:   |Retorna a lista com os Updates disponiveis para realização       |
//|-------------+-----------------------------------------------------------------|
//|Uso:         |Certisign - Certificadora Digital.                               |
//+-------------+-----------------------------------------------------------------+
Static Function GetListUpd(lLoadAtu,lEmpty)

	Local nAux  := 0
	Local lExecUpd := .F.
	Local cUsuario := ""
	Local cMaquina := ""
	Local cDataUpd := ""
	Local cHoraUpd := ""

	aListUpd := {}
	lEmpty := .F.
	For nAux := 1 To 9999
   		cUpdate := StrZero(nAux,4)
   		If FindFunction( 'u_CFTU' + cUpdate)
 	     	lExecUpd := .F.
      		cUsuario := ""
      		cMaquina := ""
      		cDataUpd := ""
      		cHoraUpd := ""
      		If (cCSUpdCtl)->(lExecUpd := MsSeek( 'CFTU' + cUpdate ,.F.))
         		conout("Update u_CFTU"+cUpdate+ " ja executado.")
         		If !lLoadAtu
            		Loop
         		EndIf
         		cUsuario := (cCSUpdCtl)->USUARIO
         		cMaquina := (cCSUpdCtl)->MAQUINA
         		cDataUpd := (cCSUpdCtl)->DATAUPD
         		cHoraUpd := (cCSUpdCtl)->HORAUPD
      		EndIf
      		conout("Carregando informacoes update u_CFTU"+cUpdate)
      		aRet := &('StaticCall(CFTU' + cUpdate + ',UpdGetInfo)' )
      		AAdd(aListUpd,{.F.,aRet[1],aRet[2],aRet[5],lExecUpd,aRet[3],aRet[4],cUsuario,cMaquina,cDataUpd,cHoraUpd})
   		EndIf
	Next
	//-- Se nao encontrou updates no RPO
	If Len(aListUpd)==0
   		AAdd( aListUpd, {.F.,'','',Nil,.F.,'','','','','',''} )
   		lEmpty := .T.
	EndIf

Return Nil


//+-------------+------------+-------+-----------------------+------+-------------+
//|Programa:    |CSSelectSM0 |Autor: |David Alves dos Santos |Data: |07/03/2016   |
//|-------------+------------+-------+-----------------------+------+-------------|
//|Descricao:   |Exibe janela para escolha das empresas que devem ser processadas |
//|-------------+-----------------------------------------------------------------|
//|Uso:         |Certisign - Certificadora Digital.                               |
//+-------------+-----------------------------------------------------------------+
Static Function CSSelectSM0(aEmpresas)

	Local oDlgSM0
	Local oListBox
	Local aHList     := {}
	Local oOk        := LoadBitMap(GetResources(),"LBOK")
	Local oNo        := LoadBitMap(GetResources(),"LBNO")
	Local lMarcaItem := .T.
	
	DEFINE MSDIALOG oDlgSM0 TITLE 'Selecione as Empresas para o processamento...' From 9,0 To 30,52
	
		AAdd( aHList, ' ')
		AAdd( aHList, 'Empresa' )
		AAdd( aHList, 'Filial' )
		AAdd( aHList, 'Nome' )
		AAdd( aHList, 'Id.')
		
		oListBox := TWBrowse():New(005,005,155,145,,aHList,,oDlgSM0,,,,,,,,,,,,, "ARRAY", .T. )
		oListBox:SetArray( aEmpresas )
		oListBox:bLine := {|| { If(aEmpresas[oListBox:nAT,1], oOk, oNo),;
                  		aEmpresas[oListBox:nAT,2],;
                  		aEmpresas[oListBox:nAT,3],;
                  		aEmpresas[oListBox:nAT,4],;
                  		aEmpresas[oListBox:nAT,5]}}
		
		oListBox:bLDblClick := {|| aEmpresas[oListBox:nAt,1] := !aEmpresas[oListBox:nAt,1], oListBox:Refresh()}
		
		DEFINE SBUTTON FROM    4,170 TYPE  1 ACTION (oDlgSM0:End()) ENABLE OF oDlgSM0
		DEFINE SBUTTON FROM 18.5,170 TYPE 11 ACTION (Aeval(aEmpresas,{|aElem|aElem[1] := lMarcaItem}), lMarcaItem := !lMarcaItem,,oListBox:Refresh()) ONSTOP 'Marca/Desmarca' ENABLE OF oDlgSM0
	
	ACTIVATE MSDIALOG oDlgSM0 CENTERED

Return( aEmpresas )


//+-------------+-----------+-------+-----------------------+------+-------------+
//|Programa:    |CSViewLog  |Autor: |David Alves dos Santos |Data: |07/03/2016   |
//|-------------+-----------+-------+-----------------------+------+-------------|
//|Descricao:   |Exibe o LOG das atualizações realizadas.                        |
//|-------------+----------------------------------------------------------------|
//|Uso:         |Certisign - Certificadora Digital.                              |
//+-------------+----------------------------------------------------------------+
Static Function CSViewLog( aResumo )
	
	Local oDlg
	Local oTree
	Local oFont
	Local oPanel
	Local lSair := .F.
	Private cTxtShow := ''
	
	lOpen := MyOpenSm0Ex()
	If lOpen
   		SM0->(DbGoTop())
   		RpcSetType(3)
   		RpcSetEnv(SM0->M0_CODIGO, FWGETCODFILIAL)
   		nModulo := 05 //-- SIGAFAT
   		lMsFinalAuto := .F.
	
   		DEFINE FONT oFont NAME "Tahoma" SIZE 0, -10
		
   		DEFINE MSDIALOG oDlg TITLE 'LOG das Atualizacoes' PIXEL FROM 00,00 TO 450,650

   			oPanel := tPanel():New(005,114,"",oDlg,,,,,CLR_WHITE,210, 202, .T.)
   			oPanel:Hide()
			
   			oTree           := DbTree():New(005,005,220,110,oDlg,,,.T.)
   			oTree:LShowHint := .F.
   			oTree:oFont     := oFont
   			oTree:bChange   := {|| CSShowItem( oPanel, oTree, aResumo ) }
			
   			DEFINE SBUTTON FROM 210,260 TYPE 13 ACTION (MsFreeObj(@oPanel, .T.), CSGrvLog( aResumo )) ENABLE OF oDlg
   			DEFINE SBUTTON FROM 210,295 TYPE  1 ACTION (MsFreeObj(@oPanel, .T.), oDlg:End()) ENABLE OF oDlg
			
   			//-- Chama a rotina de construcao do Tree
   			MsgRun('Aguarde, Montando o Tree com as atualizacoes...',,{|| CSTreeLog(oTree, aResumo)} )

   		ACTIVATE MSDIALOG oDlg CENTERED
   		RpcClearEnv()
	EndIf

Return


//+-------------+------------+-------+-----------------------+------+-------------+
//|Programa:    |CSTreeLog   |Autor: |David Alves dos Santos |Data: |07/03/2016   |
//|-------------+------------+-------+-----------------------+------+-------------|
//|Descricao:   |Monta a TREE com as atualizações realizadas                      |
//|-------------+-----------------------------------------------------------------|
//|Uso:         |Certisign - Certificadora Digital.                               |
//+-------------+-----------------------------------------------------------------+
Static Function CSTreeLog(oTree, aResumo)

	Local j
	Local cQuebra:= ''
	Local nCount := 0
	
	For nCount := 1 To Len( aResumo )
	
   		oTree:AddTree(aResumo[nCount,1] + Space(30),.T.,,,"FOLDER5","FOLDER6",Space(16))
	
   		//-- SX2
   		oTree:AddTree('SX2 - Arquivos',.T.,,,"FOLDER5","FOLDER6",Space(16))
   		If Len(aResumo[nCount,2,1]) > 0
      		For j := 1 To Len( aResumo[nCount,2,1] )
         		oTree:AddTreeItem( 'Arquivo: ' + aResumo[nCount,2,1,j,4],'',, 'SX2' + StrZero(nCount,3) + ',2,01,' + StrZero(j,4) )
      		Next j
   		Else
      		oTree:AddTreeItem( 'Nenhuma atualizacao realizada','',,Space(16))
   		EndIf
   		oTree:EndTree()
		
   		//-- SIX
   		oTree:AddTree('SIX - Indices',.T.,,,"FOLDER5","FOLDER6",Space(16))
   		If Len(aResumo[nCount,2,2]) > 0
      		For j := 1 To Len( aResumo[nCount,2,2] )
         		oTree:AddTreeItem( 'Indice: ' + aResumo[nCount,2,2,j,4],'',,'SIX' + StrZero(nCount,3) + ',2,02,' + StrZero(j,4) )
      		Next j
   		Else
      		oTree:AddTreeItem( 'Nenhuma atualizacao realizada','',,Space(16))
   		EndIf
   		oTree:EndTree()
		
   		//-- SX3
   		oTree:AddTree('SX3 - Dicionario de Dados',.T.,,,"FOLDER5","FOLDER6",Space(16))
   		If Len(aResumo[nCount,2,3]) > 0
      		For j := 1 To Len( aResumo[nCount,2,3] )
         		If cQuebra <> aResumo[nCount,2,3,j,1]
            		If !Empty(cQuebra)
               		oTree:EndTree()
            		EndIf
            		oTree:AddTree('Tabela: ' + aResumo[nCount,2,3,j,1],.T.,,,"FOLDER5","FOLDER6",Space(16))
            		cQuebra := aResumo[nCount,2,3,j,1]
         		EndIf
         		oTree:AddTreeItem( 'Campo: ' + aResumo[nCount,2,3,j,3],'',,'SX3' + StrZero(nCount,3) + ',2,03,' + StrZero(j,4))
      		Next j
      		oTree:EndTree()
   		Else
      		oTree:AddTreeItem( 'Nenhuma atualizacao realizada','',,Space(16))
   		EndIf
   		oTree:EndTree()
	
   		//-- SX5
   		oTree:AddTree('SX5 - Tabelas Genericas',.T.,,,"FOLDER5","FOLDER6",Space(16))
   		If Len(aResumo[nCount,2,4]) > 0
      		For j := 1 To Len( aResumo[nCount,2,4] )
         		oTree:AddTreeItem( 'Tabela: ' + aResumo[nCount,2,4,j,3],'',,'SX5' + StrZero(nCount,3) + ',2,04,' + StrZero(j,4))
      		Next j
   		Else
      		oTree:AddTreeItem( 'Nenhuma atualizacao realizada','',,Space(16))
   		EndIf
   		oTree:EndTree()
		
   		//-- SX6
   		oTree:AddTree('SX6 - Parametros',.T.,,,"FOLDER5","FOLDER6",Space(16))
   		If Len(aResumo[nCount,2,9]) > 0
      		For j := 1 To Len( aResumo[nCount,2,9] )
         		oTree:AddTreeItem( 'Parametro: ' + aResumo[nCount,2,9,j,1] + aResumo[nCount,2,9,j,2],'',,'SX6' + StrZero(nCount,3) + ',2,09,' + StrZero(j,4))
      		Next j
   		Else
      		oTree:AddTreeItem( 'Nenhuma atualizacao realizada','',,Space(16))
   		EndIf
   		oTree:EndTree()

   		//-- SX7
   		oTree:AddTree('SX7 - Gatilhos',.T.,,,"FOLDER5","FOLDER6",Space(16))
   		If Len(aResumo[nCount,2,5]) > 0
      		For j := 1 To Len( aResumo[nCount,2,5] )
         		oTree:AddTreeItem( 'Gatilho: ' + aResumo[nCount,2,5,j,1] + '/' + aResumo[nCount,2,5,j,2],'',,'SX7' + StrZero(nCount,3) + ',2,05,' + StrZero(j,4))
      		Next j
   		Else
      		oTree:AddTreeItem( 'Nenhuma atualizacao realizada','',,Space(16))
   		EndIf
   		oTree:EndTree()
		
   		//-- SX9
   		oTree:AddTree('SX9 - Relacionamentos',.T.,,,"FOLDER5","FOLDER6",Space(16))
   		If Len(aResumo[nCount,2,6]) > 0
      		For j := 1 To Len( aResumo[nCount,2,6] )
         		oTree:AddTreeItem( 'Relacionamento: ' + aResumo[nCount,2,6,j,1] + '/' + aResumo[nCount,2,6,j,3],'',,'SX9' + StrZero(nCount,3) + ',2,06,' + StrZero(j,4))
      		Next j
   		Else
      		oTree:AddTreeItem( 'Nenhuma atualizacao realizada','',,Space(16))
   		EndIf
   		oTree:EndTree()
		
   		//-- SXA
   		oTree:AddTree('SXA - Pastas (Folders)',.T.,,,"FOLDER5","FOLDER6",Space(16))
   		If Len(aResumo[nCount,2,7]) > 0
      		For j := 1 To Len( aResumo[nCount,2,7] )
         		oTree:AddTreeItem( 'Pasta: ' + aResumo[nCount,2,7,j,3],'',, 'SXA' + StrZero(nCount,3) + ',2,07,' + StrZero(j,4))
      		Next j
   		Else
      		oTree:AddTreeItem( 'Nenhuma atualizacao realizada','',,Space(16))
   		EndIf
   		oTree:EndTree()

   		//-- SXB
   		oTree:AddTree('SXB - Consultas Padroes',.T.,,,"FOLDER5","FOLDER6",Space(16))
   		If Len(aResumo[nCount,2,8]) > 0
      		For j := 1 To Len( aResumo[nCount,2,8] )
         		If aResumo[nCount,2,8,j,2] == '1'
            		oTree:AddTreeItem( 'Consulta: ' + aResumo[nCount,2,8,j,5],'',, 'SXB' + StrZero(nCount,3) + ',2,08,' + StrZero(j,4))
         		EndIf
      		Next j
   		Else
      		oTree:AddTreeItem( 'Nenhuma atualizacao realizada','',,Space(16))
   		EndIf
   		oTree:EndTree()
		
   		If Type("aResumo[" + AllTrim(Str(nCount))+ ",2,10]") == "A"
      		//-- Rotinas de ajuste de base de dados
      		oTree:AddTree('Rotinas de ajuste de base de dados',.T.,,,"FOLDER5","FOLDER6",Space(16))
      		If Len(aResumo[nCount,2,10]) > 0
         		For j := 1 To Len( aResumo[nCount,2,10] )
            		oTree:AddTreeItem( 'Rotina: ' + aResumo[nCount,2,10,j,1],'',, 'FXE' + StrZero(nCount,3) + ',2,10,' + StrZero(j,4))
         		Next j
      		Else
         		oTree:AddTreeItem( 'Nenhuma atualizacao realizada','',,Space(16))
      		EndIf
      		oTree:EndTree()
   		EndIf
   		oTree:EndTree()
	Next nCount

Return



//+-------------+-----------+-------+-----------------------+------+-------------+
//|Programa:    |CSShowItem |Autor: |David Alves dos Santos |Data: |07/03/2016   |
//|-------------+-----------+-------+-----------------------+------+-------------|
//|Descricao:   |Visualiza o item selecionado na TREE.                           |
//|-------------+----------------------------------------------------------------|
//|Uso:         |Certisign - Certificadora Digital.                              |
//+-------------+----------------------------------------------------------------+
Static Function CSShowItem( oPanel, oTree, aResumo )

	Local cTab     := Left( oTree:GetCargo(), 3 )
	Local cElem    := SubStr( oTree:GetCargo(), 4, 13)
	Local oFont
	Local cTpParam := ''
	Local aInfo    := {}
	
	DEFINE FONT oFont NAME 'Arial' SIZE 0, -12 BOLD
	
	MsFreeObj(@oPanel, .T.)
	oPanel:Hide()
	
	If !Empty(cTab)
   		aInfo := aClone(&('aResumo['+cElem+']'))
   		If cTab == 'SX2'
	
      		@ 005,005 To 020, 205 Label 'Tabela:' Of oPanel Pixel
      		@ 010,008 Say aInfo[1] + ' - ' + Posicione('SX2',1,aInfo[1],'X2_NOME');
               		Of oPanel Pixel COLOR CLR_BLUE FONT oFont
	
      		@ 025,005 To 040,100  Label 'Arquivo:' Of oPanel Pixel
      		@ 030,008 Say aInfo[3] Of oPanel Pixel COLOR CLR_BLUE FONT oFont

      		@ 025,105 To 040,205 Label 'Path:' Of oPanel Pixel
      		@ 030,108 Say aInfo[2] Of oPanel Pixel COLOR CLR_BLUE FONT oFont

      		@ 045,005 To 060,100 Label 'Descrição:' Of oPanel Pixel
      		@ 050,008 Say aInfo[4] Of oPanel Pixel COLOR CLR_BLUE FONT oFont

      		@ 045,105 To 060,205 Label 'Modo de Acesso:' Of oPanel Pixel
      		@ 050,108 Say IF(Upper(aInfo[8]) ==  'E', 'Exclusivo', 'Compartilhado');
               		Of oPanel Pixel COLOR CLR_BLUE FONT oFont

      		@ 065,005 To 080,205 Label 'Rotina:' Of oPanel Pixel
      		@ 070,008 Say aInfo[10] Of oPanel Pixel COLOR CLR_BLUE FONT oFont

   		ElseIf cTab == 'SIX'

      		@ 005,005 To 020, 205 Label 'Arquivo:' Of oPanel Pixel
      		@ 010,008 Say aInfo[1] + ' - ' + Posicione('SX2',1,aInfo[1],'X2_NOME');
               		Of oPanel Pixel COLOR CLR_BLUE FONT oFont
		
      		@ 025,005 To 040,030 Label 'Ordem:' Of oPanel Pixel
      		@ 030,008 Say aInfo[2] Of oPanel Pixel COLOR CLR_BLUE FONT oFont
		
      		@ 025,035 To 040,205 Label 'Chave:' Of oPanel Pixel
      		@ 030,038 Say aInfo[3] Of oPanel Pixel COLOR CLR_BLUE FONT oFont
		
      		@ 045,005 To 060,205 Label 'Descrição:' Of oPanel Pixel
      		@ 050,008 Say aInfo[4] Of oPanel Pixel COLOR CLR_BLUE FONT oFont
		
   		ElseIf cTab == 'SX3'
		
      		@ 005,005 To 020,205 Label 'Arquivo:' Of oPanel Pixel
      		@ 010,008 Say aInfo[1] + ' - ' + Posicione('SX2',1,aInfo[1],'X2_NOME');
               		Of oPanel Pixel COLOR CLR_BLUE FONT oFont
		
      		@ 025,005 To 040,070 Label 'Campo:' Of oPanel Pixel
      		@ 030,008 Say aInfo[3] Of oPanel Pixel COLOR CLR_BLUE FONT oFont
		
      		@ 025,075 To 040,170 Label 'Titulo:' Of oPanel Pixel
      		@ 030,078 Say aInfo[7] Of oPanel Pixel COLOR CLR_BLUE FONT oFont
		
      		@ 025,175 To 040,205 Label 'Ordem:' Of oPanel Pixel
      		@ 030,178 Say aInfo[2] Of oPanel Pixel COLOR CLR_BLUE FONT oFont
		
      		@ 045,005 To 060,205 Label 'Descrição:' Of oPanel Pixel
      		@ 050,008 Say aInfo[10] Of oPanel Pixel COLOR CLR_BLUE FONT oFont
		
      		@ 065,005 To 080,040 Label 'Tamanho:' Of oPanel Pixel
      		@ 070,008 Say aInfo[5] Of oPanel Pixel COLOR CLR_BLUE FONT oFont
		
      		@ 065,045 To 080,080 Label 'Decimal:' Of oPanel Pixel
      		@ 070,048 Say aInfo[6] Of oPanel Pixel COLOR CLR_BLUE FONT oFont
		
      		@ 065,085 To 080,170 Label 'Picture' Of oPanel Pixel
      		@ 070,088 Say aInfo[13] Of oPanel Pixel COLOR CLR_BLUE FONT oFont

      		@ 065,175 To 080,205 Label 'Usado:' Of oPanel Pixel
      		@ 070,178 Say If(x3uso(aInfo[15]), 'Sim', 'Não') Of oPanel Pixel COLOR CLR_BLUE FONT oFont
		
      		@ 085,005 To 100,205 Label 'Validação:' Of oPanel Pixel
      		@ 090,008 Say Left(aInfo[14],55) + ;
               		If(Len(aInfo[14]) > 55, '...','') Of oPanel Pixel COLOR CLR_BLUE FONT oFont
		
      		@ 105,005 To 120,205 Label 'Inicializador Padrão:' Of oPanel Pixel
      		@ 110,008 Say Left(aInfo[16],55) + ;
               		If(Len(aInfo[16]) > 55, '...','') Of oPanel Pixel COLOR CLR_BLUE FONT oFont
			
      		@ 125,005 To 140,205 Label 'Inicializador Padrão (Browse):' Of oPanel Pixel
      		@ 130,008 Say Left(aInfo[33],55) +;
               		If(Len(aInfo[33]) > 55, '...','') Of oPanel Pixel COLOR CLR_BLUE FONT oFont
		
      		@ 145,005 To 160,205 Label 'Modo de Edição:' Of oPanel Pixel
      		@ 150,008 Say Left(aInfo[32],55) +;
               		If(Len(aInfo[32]) > 55, '...','') Of oPanel Pixel COLOR CLR_BLUE FONT oFont
		
      		@ 165,005 To 180,040 Label 'Contexto:' Of oPanel Pixel
      		@ 170,008 Say If(Upper(aInfo[25]) == 'V', 'Virtual', 'Real') Of oPanel Pixel COLOR CLR_BLUE FONT oFont
		
      		@ 165,045 To 180,085 Label 'Propriedade:' Of oPanel Pixel
      		@ 170,048 Say If(Upper(aInfo[24]) == 'A', 'Alterar', 'Visualizar') Of oPanel Pixel COLOR CLR_BLUE FONT oFont
		
      		@ 165,090 To 180,125 Label 'Browse:' Of oPanel Pixel
      		@ 170,093 Say If(Upper(aInfo[23]) == 'S', 'Sim', 'Não') Of oPanel Pixel COLOR CLR_BLUE FONT oFont

      		@ 165,130 To 180,175 Label 'Cons. Padrão:' Of oPanel Pixel
      		@ 170,133 Say aInfo[17] Of oPanel Pixel COLOR CLR_BLUE FONT oFont
		
      		@ 165,180 To 180,205 Label 'Pasta:' Of oPanel Pixel
      		@ 170,183 Say aInfo[35] Of oPanel Pixel COLOR CLR_BLUE FONT oFont
		
      		@ 185,005 To 200,205 Label 'Lista de Opções:' Of oPanel Pixel
      		@ 190,008 Say aInfo[28] Of oPanel Pixel COLOR CLR_BLUE FONT oFont
		
   		ElseIf cTab == 'SX5'
      		@ 005,005 To 020,040 Label 'Tabela:' Of oPanel Pixel
      		@ 010,008 Say aInfo[1] Of oPanel Pixel COLOR CLR_BLUE FONT oFont
		
      		@ 005,045 To 020,085 Label 'Chave:' Of oPanel Pixel
      		@ 010,048 Say aInfo[2] Of oPanel Pixel COLOR CLR_BLUE FONT oFont
		
      		@ 025,005 To 040,205 Label 'Descrição:' Of oPanel Pixel
      		@ 030,008 Say aInfo[3] Of oPanel Pixel COLOR CLR_BLUE FONT oFont
		
   		ElseIf cTab == 'SX6'
      		@ 005,005 To 020,085 Label 'Parametro:' Of oPanel Pixel
      		@ 010,008 Say aInfo[2] Of oPanel Pixel COLOR CLR_BLUE FONT oFont

			cTpParam := aInfo[3]
      		If cTpParam == 'C'
         		cTpParam := 'Caracter'
      		ElseIf cTpParam == 'D'
         		cTpParam := 'Data'
      		ElseIf cTpParam == 'L'
         		cTpParam := 'Logico'
      		ElseIf cTpParam == 'N'
         		cTpParam := 'Numerico'
      		EndIf
		
      		@ 005,090 TO 020,150 Label 'Tipo:' Of oPanel Pixel
      		@ 010,093 Say cTpParam Of oPanel Pixel COLOR CLR_BLUE FONT oFont
		
      		@ 025,005 To 060,205 Label 'Descrição:' Of oPanel Pixel
      		@ 032,008 Say aInfo[4] Of oPanel Pixel COLOR CLR_BLUE FONT oFont
      		@ 039,008 Say aInfo[7] Of oPanel Pixel COLOR CLR_BLUE FONT oFont
      		@ 046,008 Say aInfo[10]Of oPanel Pixel COLOR CLR_BLUE FONT oFont
		
      		@ 065,005 To 080,205 Label 'Conteúdo:' Of oPanel Pixel
      		@ 072,008 Say aInfo[13] Of oPanel Pixel COLOR CLR_BLUE FONT oFont
		
   		ElseIf cTab == 'SX7'
		
      		@ 005,005 To 020,050 Label 'Origem:' Of oPanel Pixel
      		@ 010,008 Say aInfo[1] Of oPanel Pixel COLOR CLR_BLUE FONT oFont
		
      		@ 005,055 To 020,105 Label 'Destino:' Of oPanel Pixel
      		@ 010,058 Say aInfo[4] Of oPanel Pixel COLOR CLR_BLUE FONT oFont
		
      		@ 005,110 To 020,145 Label 'Seq.:' Of oPanel Pixel
      		@ 010,113 Say aInfo[2] Of oPanel Pixel COLOR CLR_BLUE FONT oFont
		
      		@ 005,150 To 020,205 Label 'Tipo:' Of oPanel Pixel
      		@ 010,153 Say If(AllTrim(aInfo[5]) == 'P', 'Primario', If(AllTrim(aInfo[4]) == 'E', 'Estrangeiro', 'Posicionamento'));
               		Of oPanel Pixel COLOR CLR_BLUE FONT oFont
		
      		@ 025,005 To 040,205 Label 'Regra:' Of oPanel Pixel
      		@ 030,008 Say aInfo[3] Of oPanel Pixel COLOR CLR_BLUE FONT oFont
		
      		@ 045,005 To 060,035 Label 'Posiciona?' Of oPanel Pixel
      		@ 050,008 Say If(Upper(aInfo[6]) == 'S', 'Sim', 'Não') Of oPanel Pixel COLOR CLR_BLUE FONT oFont
		
      		@ 045,040 To 060,070 Label 'Alias:' Of oPanel Pixel
      		@ 050,043 Say aInfo[7] Of oPanel Pixel COLOR CLR_BLUE FONT oFont
		
      		@ 045,075 To 060,105 Label 'Ordem:' Of oPanel Pixel
      		@ 050,078 Say aInfo[8] Of oPanel Pixel COLOR CLR_BLUE FONT oFont
		
      		@ 065,005 To 080,205 Label 'Chave:' Of oPanel Pixel
      		@ 070,008 Say Left(aInfo[9],55) + IF(Len(aInfo[9]) > 55, '...', '') ;
               		Of oPanel Pixel COLOR CLR_BLUE FONT oFont

			@ 085,005 To 100,205 Label 'Condicao:' Of oPanel Pixel
      		@ 090,008 Say aInfo[11] Of oPanel Pixel COLOR CLR_BLUE FONT oFont

   		ElseIf cTab == 'SX9'

      		@ 005,005 To 020,070 Label 'Dominio:' Of oPanel Pixel
      		@ 010,008 Say aInfo[1] Of oPanel Pixel COLOR CLR_BLUE FONT oFont
		
      		@ 005,075 To 020,140 Label 'Contradominio:' Of oPanel Pixel
      		@ 010,078 Say aInfo[3] Of oPanel Pixel COLOR CLR_BLUE FONT oFont
		
      		@ 025,005 To 040,205 Label 'Exp Dom:' Of oPanel Pixel
      		@ 030,008 Say Left(aInfo[4],55) + Iif(Len(aInfo[4]) > 55, '...', '') ;
               		Of oPanel Pixel COLOR CLR_BLUE FONT oFont
		
      		@ 045,005 To 060,205 Label 'Exp CDom:' Of oPanel Pixel
      		@ 050,008 Say Left(aInfo[5],55) + Iif(Len(aInfo[5]) > 55, '...', '') ;
               		Of oPanel Pixel COLOR CLR_BLUE FONT oFont
		
   		ElseIf cTab == 'SXA'
		
      		@ 005,005 To 020,045 Label 'Alias:' Of oPanel Pixel
      		@ 010,008 Say aInfo[1] Of oPanel Pixel COLOR CLR_BLUE FONT oFont
		
      		@ 005,050 To 020,090 Label 'Ordem:' Of oPanel Pixel
      		@ 010,053 Say aInfo[2] Of oPanel Pixel COLOR CLR_BLUE FONT oFont
		
      		@ 025,005 To 040,205 Label 'Descrição' Of oPanel Pixel
      		@ 030,008 Say aInfo[3] Of oPanel Pixel COLOR CLR_BLUE FONT oFont
		
   		ElseIf cTab == 'SXB'
      		@ 005,005 To 020,045 Label 'Alias:' Of oPanel Pixel
      		@ 010,008 Say aInfo[1] Of oPanel Pixel COLOR CLR_BLUE FONT oFont
		
      		@ 025,005 To 040,205 Label 'Descrição' Of oPanel Pixel
      		@ 030,008 Say aInfo[5] Of oPanel Pixel COLOR CLR_BLUE FONT oFont
		
   		ElseIf cTab == 'FXE'
      		@ 005,005 To 020,200 Label 'Mensagens:' Of oPanel Pixel
      		@ 010,008 Say Left(aInfo[2],55) + Iif(Len(aInfo[2]) > 55, '...', '') ;
               		Of oPanel Pixel COLOR CLR_BLUE FONT oFont
	
   		EndIf

   		oPanel:Refresh(.T.)
   		oPanel:Show()
	EndIf

Return


//+-------------+------------+-------+-----------------------+------+-------------+
//|Programa:    |CSGrvLog    |Autor: |David Alves dos Santos |Data: |07/03/2016   |
//|-------------+------------+-------+-----------------------+------+-------------|
//|Descricao:   |Grava os dados da execução do LOG                                |
//|-------------+-----------------------------------------------------------------|
//|Uso:         |Certisign - Certificadora Digital.                               |
//+-------------+-----------------------------------------------------------------+
Static Function CSGrvLog( aResumo )
	
	Local cTexto := ''
	Local cLinha := ''
	Local i      := 0
	Local j      := 0
	Local cFile  := ''
	Local cMask  := "Arquivos Texto (*.TXT) |*.txt|"
	
	cFile := cGetFile(cMask,"")
	
	If !Empty(cFile)
   		For i := 1 To Len(aResumo)

			cTexto += Repl('=',220)
      		cTexto += CRLF
      		cTexto += 'Empresa: ' + aResumo[i,1] + CRLF
      		cTexto += Repl('=',220)
		
      		cTexto += CRLF
      		cTexto += 'Atualizacoes - SX2: Tabelas' + CRLF
      		If Len(aResumo[i,2,1]) > 0
         		cTexto += 'Alias  Path                                      Arquivo   Descricao                       Modo Acesso' + CRLF
         		cLinha := ''
         		For j := 1 To Len( aResumo[i,2,1] )
            		cLinha += aResumo[i,2,1,j,1]            + Space(04) +;
                      		aResumo[i,2,1,j,2]            + Space(02) +;
                      		aResumo[i,2,1,j,3]            + Space(02) +;
                      		PadR(aResumo[i,2,1,j,4],30)   + Space(02) +;
                      		Iif(Upper(aResumo[i,2,1,j,8]) == 'E', 'Exclusivo', 'Compartilhado') + CRLF
         		Next j
         		If Len(cTexto) + Len(cLinha) > 1000000
            		CSSavLog(cFile,cTexto)
            		cTexto := ''
         		EndIf
         		cTexto += cLinha
      		Else
         		cTexto += 'Nenhuma atualizacao realizada.' + CRLF
      		EndIf
		
      		cTexto +=  CRLF
      		cTexto += 'Atualizacoes - SIX: Indices' + CRLF
      		If Len(aResumo[i,2,2]) > 0
         		cTexto += 'Indice  Ordem  Chave                                               Descricao' + CRLF
         		cLinha := ''
         		For j := 1 To Len( aResumo[i,2,2] )
            		cLinha += aResumo[i,2,2,j,1]                  + Space(09) +;
                      		aResumo[i,2,2,j,2]                  + Space(02) +;
                      		PadR(Left(aResumo[i,2,2,j,3],50),50)+ Space(02) +;
                      		Left(aResumo[i,2,2,j,4],50) + CRLF
         		Next j
         		If Len(cTexto) + Len(cLinha) > 1000000
            		CSSavLog(cFile,cTexto)
            		cTexto := ''
         		EndIf
         		cTexto += cLinha
      		Else
         		cTexto += 'Nenhuma atualizacao realizada.' + CRLF
      		EndIf
	
      		cTexto += CRLF
      		cTexto += 'Atualizacoes - SX3: Dicionario de Dados' + CRLF
      		If Len(aResumo[i,2,3]) > 0
         		cTexto += 'Arquivo  Ordem  Campo       Tipo  Tamanho  Decimais  Titulo        Descricao' + CRLF
         		cLinha := ''
         		For j := 1 To Len( aResumo[i,2,3] )
            		cLinha += aResumo[i,2,3,j,1]          + Space(09) +;
                      		aResumo[i,2,3,j,2]          + Space(02) +;
                      		PadR(aResumo[i,2,3,j,3],10) + Space(05) +;
                      		aResumo[i,2,3,j,4]          + Space(06) +;
                      		Str(aResumo[i,2,3,j,5],3)   + Space(09) +;
                      		Str(aResumo[i,2,3,j,6],1)   + Space(02) +;
                      		PadR(aResumo[i,2,3,j,7],12) + Space(02) +;
                      		aResumo[i,2,3,j,10] + CRLF
         		Next j
         		If Len(cTexto) + Len(cLinha) > 1000000
            		CSSavLog(cFile,cTexto)
            		cTexto := ''
         		EndIf
         		cTexto += cLinha
      		Else
         		cTexto += 'Nenhuma atualizacao realizada.' + CRLF
      		EndIf

      		cTexto +=  CRLF
      		cTexto += 'Atualizacoes - SX5: Tabelas Genericas' + CRLF
      		If Len(aResumo[i,2,4]) > 0
         		cTexto += 'Tabela  Chave   Descricao' + CRLF
         		cLinha := ''
         		For j := 1 To Len( aResumo[i,2,4] )
            		cLinha += aResumo[i,2,4,j,1] + Space(06) +;
                      		aResumo[i,2,4,j,2] + Space(02) +;
                      		aResumo[i,2,4,j,3] + CRLF
         		Next j
         		If Len(cTexto) + Len(cLinha) > 1000000
            		CSSavLog(cFile,cTexto)
            		cTexto := ''
         		EndIf
         		cTexto += cLinha
      		Else
         		cTexto += 'Nenhuma atualizacao realizada.' + CRLF
      		EndIf

      		cTexto += CRLF
      		cTexto += 'Atualizacoes - SX7: Gatilhos' + CRLF
      		If Len(aResumo[i,2,5]) > 0
         		cTexto += 'Origem      Destino     Seq  Regra' + CRLF
         		cLinha := ''
         		For j := 1 To Len( aResumo[i,2,5] )
            		cLinha += PadR(aResumo[i,2,5,j,1],10) + Space(02) +;
                      		PadR(aResumo[i,2,5,j,4],10) + Space(02) +;
                      		aResumo[i,2,5,j,2]          + Space(02) +;
                      		aResumo[i,2,5,j,3]          + CRLF
         		Next j
         		If Len(cTexto) + Len(cLinha) > 1000000
            		CSSavLog(cFile,cTexto)
            		cTexto := ''
         		EndIf
         		cTexto += cLinha
      		Else
         		cTexto += 'Nenhuma atualizacao realizada.' + CRLF
      		EndIf
		
      		cTexto += CRLF
      		cTexto += 'Atualizacoes - SX9: Relacionamentos' + CRLF
      		If Len(aResumo[i,2,6]) > 0
         		cTexto += 'Dominio  Contradominio  Exp Dom                                             Exp CDom' + CRLF
         		cLinha := ''
         		For j := 1 To Len( aResumo[i,2,6] )
            		cLinha += aResumo[i,2,6,j,1] + Space(06) +;
                      		aResumo[i,2,6,j,3] + Space(12) +;
                      		PadR(Left(aResumo[i,2,6,j,4],50),50)+ Space(02) +;
                      		PadR(Left(aResumo[i,2,6,j,5],50),50)+ CRLF
         		Next j
         		If Len(cTexto) + Len(cLinha) > 1000000
            		CSSavLog(cFile,cTexto)
            		cTexto := ''
         		EndIf
         		cTexto += cLinha
      		Else
         		cTexto += 'Nenhuma atualizacao realizada.' + CRLF
      		EndIf
		
      		cTexto +=  CRLF
      		cTexto += 'Atualizacoes - SXA: Pastas' + CRLF
      		If Len(aResumo[i,2,7]) > 0
         		cTexto += 'Arquivo  Ordem  Descricao' + CRLF
         		cLinha := ''
         		For j := 1 To Len( aResumo[i,2,7] )
            		cLinha += aResumo[i,2,7,j,1] + Space(10) +;
                      		aResumo[i,2,7,j,2] + Space(02) +;
                      		aResumo[i,2,7,j,3] + CRLF
		
         		Next j
         		If Len(cTexto) + Len(cLinha) > 1000000
            		CSSavLog(cFile,cTexto)
            		cTexto := ''
         		EndIf
         		cTexto += cLinha
      		Else
         		cTexto += 'Nenhuma atualizacao realizada.' + CRLF
      		EndIf
		
      		cTexto +=  CRLF
      		cTexto += 'Atualizacoes - SXB: Consultas Padroes' + CRLF
      		If Len(aResumo[i,2,8]) > 0
         		cTexto += 'Arquivo  Tipo  Sq  Coluna  Descricao             Conteudo' + CRLF
         		cLinha := ''
         		For j := 1 To Len( aResumo[i,2,8] )
            		cLinha += PadR(aResumo[i,2,8,j,1],6)   + Space(06) +;
                      		aResumo[i,2,8,j,2]           + Space(02) +;
                      		aResumo[i,2,8,j,3]           + Space(06) +;
                      		PadR(aResumo[i,2,8,j,4],2)   + Space(02) +;
                      		PadR(aResumo[i,2,8,j,5],20)  + Space(06) +;
                      		Left(aResumo[i,2,8,j,8],160) + CRLF
         		Next j
         		If Len(cTexto) + Len(cLinha) > 1000000
            		CSSavLog(cFile,cTexto)
            		cTexto := ''
         		EndIf
         		cTexto += cLinha
      		Else
         		cTexto += 'Nenhuma atualizacao realizada.' + CRLF
      		EndIf
      		If Type("aResumo[" + AllTrim(Str(i))+ ",2,10]") == "A"
         		cTexto +=  CRLF
         		cTexto += 'Atualizacoes de rotinas' + CRLF
         		If Len(aResumo[i,2,10]) > 0
            		cTexto += 'Rotina            Status' + CRLF
            		cLinha := ''
            		For j := 1 To Len( aResumo[i,2,10] )
               		cLinha += AllTrim(aResumo[i,2,10,j,1])+' - '+aResumo[i,2,10,j,2]+ CRLF
            		Next j
            		If Len(cTexto) + Len(cLinha) > 1000000
               		CSSavLog(cFile,cTexto)
               		cTexto := ''
            		EndIf
            		cTexto += cLinha
         		Else
            		cTexto += 'Nenhuma atualizacao realizada.' + CRLF
         		EndIf
      		EndIf
   		Next
		CSSavLog(cFile,cTexto)
		//-- MemoWrite(cFile,cTexto)
   		MsgInfo('Arquivo de LOG salvo com sucesso!')
	EndIf

Return



//+-------------+-----------+-------+-----------------------+------+-------------+
//|Programa:    |CSSavLog   |Autor: |David Alves dos Santos |Data: |07/03/2016   |
//|-------------+-----------+-------+-----------------------+------+-------------|
//|Descricao:   |Salva os dados da execução do LOG em arquivo.                   |
//|-------------+----------------------------------------------------------------|
//|Uso:         |Certisign - Certificadora Digital.                              |
//+-------------+----------------------------------------------------------------+
Static Function CSSavLog(cFile, cTexto)

	Local nHandle := 0
	Local cMask   := "Arquivos Texto (*.TXT) |*.txt|"

	Default cFile  := cGetFile(cMask,"")
	Default cTexto := ""

	If !File(cFile)  //-- Arquivo não existe
   		//-- Cria o arquivo de log
   		nHandle := FCreate(cFile,FC_NORMAL)
   		FSeek(nHandle, 0) 			//-- Posiciona no inicio do arquivo de log
	Else  //-- Arquivo existe
   		nHandle := FOpen(cFile,FO_READWRITE+FO_EXCLUSIVE)
   		FSeek(nHandle, 0, FS_END)	//-- Posiciona no fim do arquivo de log
	EndIf
	
	FWrite(nHandle,cTexto,len(cTexto))	//-- Grava o conteudo da variavel no arquivo de log
	FClose(nHandle) 						//-- Fecha o arquivo de log
	
Return


//+-------------+-----------+-------+-----------------------+------+-------------+
//|Programa:    |CriaTabUpd |Autor: |David Alves dos Santos |Data: |07/03/2016   |
//|-------------+-----------+-------+-----------------------+------+-------------|
//|Descricao:   |Cria a tabela de controle dos Updates e abre a mesma.           |
//|-------------+----------------------------------------------------------------|
//|Uso:         |Certisign - Certificadora Digital.                              |
//+-------------+----------------------------------------------------------------+
Static Function CriaTabUpd()
	
	Local nStatus    := 0
	local cQuery     := ""
	Local aEstrutura := {;
                     	{'NOMEUPD','C',10,0}  ,; //-- Nome do update.
                     	{'MAQUINA','C',100,0} ,; //-- HostName da maquina.
                     	{'USUARIO','C',100,0} ,; //-- Nome do usuário.
                     	{'DATAUPD','C',8,0}   ,; //-- Data que foi executado o update.
                     	{'HORAUPD','C',8,0}    ; //-- Hora que foi executado o update.
                    	   }
                    	   
   If !TcCanOpen(cCSUpdCtl)
      DBCreate(cCSUpdCtl,aEstrutura,"TOPCONN")
   EndIf
   
   DbUseArea(.T.,'TOPCONN',cCSUpdCtl,cCSUpdCtl,.T.,.T.)
   TCSetField(cCSUpdCtl,'DATAUPD','D',8,0)
   //-- Cria o arquivo de indice para a tabela
   If !TcCanOpen(cCSUpdCtl,cCSUpdCtl+"1")
      (cCSUpdCtl)->(DBCreateIndex(cCSUpdCtl +'1','NOMEUPD',{||NOMEUPD},.F.))
   EndIf
   (cCSUpdCtl)->(DbSetIndex(cCSUpdCtl +'1'))
   (cCSUpdCtl)->(DbSetOrder(1))
   
Return( .T. )


//+-------------+-----------+-------+-----------------------+------+-------------+
//|Programa:    |GetNxtOr   |Autor: |David Alves dos Santos |Data: |05/04/2016   |
//|-------------+-----------+-------+-----------------------+------+-------------|
//|Descricao:   |Retorna a proxima ordem do SX3.                                 |
//|-------------+----------------------------------------------------------------|
//|Uso:         |Certisign - Certificadora Digital.                              |
//+-------------+----------------------------------------------------------------+
User Function NxtOrdX3(cAliasX3)
	
	Local cOrdem := ""
	
	SX3->(DbSetOrder(1))
	SX3->(DbSeek(cAliasX3))
	While SX3->(!Eof()) .And. SX3->X3_ARQUIVO == cAliasX3
		cOrdem  := Soma1(SX3->X3_ORDEM)
		SX3->(DbSkip())	
	EndDo
	
Return( cOrdem )