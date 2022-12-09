#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#DEFINE ENTER CHR(13)+CHR(10)

//	Programa	LS_COMPATIB
//	Autor 		Fabiano Pereira
//	Data 		17/06/09
//	Descricao 	Replica Gatilho / Consulta Padrao / Parametros para outras Empresas
//	Uso       	Protheus

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LS_COMPATIB()
///////////////////////////

Local oDlg
Local nRadioGrp1	:= 0
Local oRadioGrp1
Private nCount 	:= 0
Private nQtdArq	:=	0
Private lArquivos	:=	.T.
Private lSelecEmpresa:= .F.
Private VISUAL := .F.
Private INCLUI := .F.
Private ALTERA := .F.
Private DELETA := .F.
Private cNaoEncontrou:=	''
Private cTabelaSX		:=	''
Private nOpcao			:=	0
Private _StartPath 	:= AllTrim(GetSrvProfString("StartPath", ""))
Private _RootPath		:=	AllTrim(GetSrvProfString("RootPath",  ""))
Private cMarca 		:= GetMark()
Private 	aCampos 		:=	{}
Private _aEmpresa		:= {}


DEFINE MSDIALOG oDlg TITLE "Replica Sxs" FROM C(178),C(181) TO C(450),C(504) PIXEL

@ C(003),C(007) TO C(120),C(153) LABEL "" PIXEL OF oDlg

@ C(014),C(029) Radio oRadioGrp1 Var nRadioGrp1 Items 	"   Existe  SX3_Old X SX3_Atual  ",;	//	[1]-cfglog
"   Existe  SX3 X TOP            ",;	//	[2]-cfglog
"   Tamanho dos campos           ",;  	//	[3]-cfglog
"   Indices-SIX                  ",;  	//	[4]-cfglog
"   Paramentros-SX6              ",;   //	[5]-TXT-SX6
"   Gatilhos-SX7                 ",;   //	[6]-TXT-SX7
"   Cons.Padrão-SXB              ",;  	//	[7]-TXT-SXB
"   SX2                          ",;	//	[8]-TXT-SX2
"   Folder                       ",;	//	[9]-cfglog
"   Selecionar Filiais  			",; 	//	[10]
"   Baca                    		";
3D Size C(110),C(010) PIXEL OF oDlg

DEFINE SBUTTON FROM C(112),C(050) TYPE 1 ENABLE OF oDlg Action(LS_Opcao(nRadioGrp1))
DEFINE SBUTTON FROM C(112),C(092) TYPE 2 ENABLE OF oDlg Action (Close(oDlg))

ACTIVATE MSDIALOG oDlg CENTERED

IIF(Select('TMP') != 0, TMP->(DbCloseArea()),)
IIF(Select('TMP_PAR') != 0, TMP_PAR->(DbCloseArea()),)

Return(.T.)

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function LS_Opcao(nOpcao)
////////////////////////////////

SetPrvt("oFont1","oDlg1","oGrp1","oSay1","oGet1","oSBtn1")
Private aCBox			:=	{}
Private nQtdRegistro	:= 1000
Private cEmpBase		:=	''

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³	 EMPRESAS     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea('SM0');DbGoTop()
Do While !Eof()
	
	nPos := Ascan(_aEmpresa, {|X| X[1] == SM0->M0_CODIGO } )
	If nPos == 0
		//		[ 1 ]				[ 2 ]					[ 3 ]				[ 4 ]				[ 5 ]  		 [ 6 ]->Flag
		Aadd( _aEmpresa, { SM0->M0_CODIGO, SM0->M0_CODFIL, AllTrim(SM0->M0_NOME) , AllTrim(SM0->M0_FILIAL), AllTrim(SM0->M0_NOMECOM), '' }  )
	Else
		_aEmpresa[nPos][2] += '/'+SM0->M0_CODFIL
	EndIf
	
	If SM0->M0_CODIGO+SM0->M0_CODFIL == '0101'
		cEmpBase := SM0->M0_CODIGO+' Filial: '+SM0->M0_CODFIL+' - '+AllTrim(SM0->M0_NOME)+' / '+AllTrim(SM0->M0_FILIAL)
	EndIf
	
	DbSkip()
EndDo

aSort(_aEmpresa,,, {|X,Y| X[1] < Y[1] } )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³	 CRIA ARQUIVO BASE SX3, CHECSTRU	|
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nOpcao != 11
	CriaArquivoSxs()
EndIf

If lSelecEmpresa == .F.
	Processa ({|| LS_EMPRESAS_SX3() },'Atuailzando Arquivo - SX3 - EMPRESAS ','Processando...', .T.)
EndIf

If AllTrim(Str(nOpcao)) $ '1/2/3/4/9'
	oFont1     := TFont():New( "MS Sans Serif",0,-11,,.T.,0,,700,.F.,.F.,,,,,, )
	oDlg1      := MSDialog():New( 091,232,248,559,"oDlg1",,,.F.,,,,,,.T.,,oFont1,.T. )
	oGrp1      := TGroup():New( 004,012,048,140,"",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
	oSay1      := TSay():New( 016,016,{||"Quantidade de registro no arquivo cfglog"},oGrp1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,120,008)
	oGet1      := TGet():New( 028,044,{|u| If(PCount()>0,nQtdRegistro:=u,nQtdRegistro)},oGrp1,060,008,'',,CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
	oSBtn1     := SButton():New( 052,056,1,{|| oDlg1:End() },oDlg1,,"", )
	oDlg1:Activate(,,,.T.)
EndIf

If nOpcao == 1
	Processa ({|| LS_SX3_ATU() },'Atuailzando Arquivo - SX3 - CAMPOS NOVOS','Processando...', .T.)	// cfglog
Elseif nOpcao == 2
	Processa ({|| LS_SX3_X_TOP() },'Atuailzando Arquivo - SX3 X TOP ','Processando...', .T.) 	//	cfglog
Elseif nOpcao == 3
	Processa ({|| LS_TAM_SX3() },'Atuailzando Arquivo - SX3 - TAMANHO ','Processando...', .T.) 	//	cfglog
Elseif nOpcao == 4
	Processa ({|| LS_SIX_ATU() },'Atuailzando Arquivo - SIX ','Processando...', .T.) 	//	cfglog
Elseif nOpcao == 5
	Processa ({|| LS_SX6_ATU() },'Atuailzando Arquivo - SX6 ','Processando...', .T.) 	//	TXT - SX6
Elseif nOpcao == 6
	Processa ({|| LS_SX7_ATU() },'Atuailzando Arquivo - SX7 ','Processando...', .T.) 	//	TXT - TXT
Elseif nOpcao == 7
	Processa ({|| LS_SXB_ATU() },'Atuailzando Arquivo - SXB ','Processando...', .T.) 	//	TXT - SXB
Elseif nOpcao == 8
	Processa ({|| LS_SX2_ATU() },'Atuailzando Arquivo - SX2 ','Processando...', .T.)  	// TXT - SX2
Elseif nOpcao == 9
	Processa ({|| LS_FOLDER() },'Atuailzando Arquivo - ABAS ','Processando...', .T.)  	//	cfglog
Elseif nOpcao == 10
	Processa ({|| LS_EMPRESAS_SX3() },'Atuailzando Arquivo - SX3 - EMPRESAS ','Processando...', .T.)
Elseif nOpcao == 11
	Processa ({|| Cope_Baca() },'Programa Bacalhau...','Processando...', .T.)
Endif

Return

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function LS_SX3_ATU()
////////////////////////////

Local cNaoEncontrou := 	''
Local lArquivos	:=	 .T.
Local nQtdArq		:=	 0
private nCount 	:=  0


cMsg := 'Este programa tem objetivo de COPIAR OS CAMPOS de um arquivo SX3(VERSÃO ANTIGA) para o cfglog'+ENTER
cMsg += 'para, posteriormente, serem criados pelo configurador'+ENTER
cMsg += 'Ex. Verifica SX3_V8.DBF e compara com o SX3_V10'
If Aviso('Grava no cfglog', cMsg ,{'Continuar','Sair'} , 2 )	==  2
	Return()
EndIf

lRet := ARQ_OBRIGATORIO('SX3_OLD','.DBF')

If !lRet
	Return()
EndIf


For _nY:=1 To Len(_aEmpresa)
	
	If _aEmpresa[_nY][6] == 'X'
		
		cSx3_Old		:=	'SX3_OLD_'+_aEmpresa[_nY][1]+'.DBF'
		cArqCfglog 	:=	'sx3x31'+_aEmpresa[_nY][1]+'.dtc'  //sx3x3101.dtc
		cNaoEncontrou := ''
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³	ABRE O ARQUIVO SX3_OLD	  |
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		IIF( Select('SX3_OLD')!=0, SX3_OLD->(DbCLoseArea()  ), )
		DbUseArea(.T.,,'\cfglog\SXs\'+cSx3_Old,'SX3_OLD',.T.,.T.)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³	ABRE O ARQUIVO NO CFGLOG  |
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		IIF( Select('_CFGLOG')  !=0, _CFGLOG->(DbCLoseArea()  ), )
		DbUseArea(.T.,"ctreecdx",'\cfglog\'+cArqCfglog,'_CFGLOG',.T.,.F.)
		
		
		nCount := 0
		SX3->(dbEval({ || nCount++ }))
		ProcRegua(nCount)
		nCount := 0
		
		lApagaSX3 := .F.
		If MsgYesNo('Empresa '+_aEmpresa[_nY][1]+ENTER+'Deseja Apagar os registros que existem no SX3 e que nao estao no TOP???'+ENTER+'Para que else sejam criados novamente ???')
			lApagaSX3 := .T.
		EndIf
		
		SX3_OLD->(DbGoTop())
		Do While  !SX3_OLD->(Eof())
			
			IncProc(SX3_OLD->X3_CAMPO)
			
			SX3->(DbGoTop()); SX3->(DbSetOrder(2))   // X3_CAMPO
			If !SX3->(DbSeek(SX3_OLD->X3_CAMPO, .F.))
				
				//	GRAVA NO _CFGLOG O CONTEUDO DO SX3_OLD
				GRAVA_NO_ARQUIVO('_CFGLOG','SX3_OLD', .T., _aEmpresa[_nY][1] )
				
				/*	DELETO NO SX3 PARA PODER CRIAR NO BANCO O CAMPO... */
				If lApagaSX3
					DbSelectArea('SX3')
					RecLock('SX3',.F.)
					DBDelete()
					MsUnLock()
				EndIf
				
				nCount++
				If	nCount == nQtdRegistro
					nQtdArq++
					// CRIA NOVO ARQUIVO sx3x3101.dtc [ renomeia o antigo COM "_" no final ]
					NOVO_SX3X301XX( _aEmpresa[_nY][1], nQtdArq )
					nCount := 0
				EndIf
			Else
				cNaoEncontrou += SX3_OLD->X3_CAMPO+ENTER
			Endif
			
			
			SX3_OLD->(DbSkip())
			
		EndDo
		
		MsgInfo('Empresa '+_aEmpresa[_nY][1]+ENTER+'Verificação SX3 - CAMPOS NOVOS concluida com sucesso...')
		
		If Len(cNaoEncontrou) > 0
			Aviso('OPA!!! ', cNaoEncontrou ,{'Sair'} , 3 )
		EndIf
		
		IIF( Select('SX3_OLD') 	!=0, SX3_OLD->(DbCLoseArea()  ), )
		IIF( Select('_CFGLOG')	!=0, _CFGLOG->(DbCLoseArea()  ), )
		
	EndIf
	
Next

MsgInfo('Fim da rotina - LS_SX3_ATU'+ENTER+'Obrigado por utilizar o Compatibilizador de SXs')

Return()

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function LS_TAM_SX3()
////////////////////////////

Local nCount 		:=	0
Local nQtdArq		:=	0
Local lArquivos 	:=	.T.
Local lArquivos	:=	.T.
Local cNaoEncontrou := 	''

cMsg := 'Este programa tem objetivo de COMPARAR O TAMANHO dos campos de um arquivo SX3(VERSÃO ANTIGA) com a versao atual do SX3'+ENTER
cMsg += 'para, posteriormente, serem criados pelo configurador'+ENTER
cMsg := 'Grava apenas no cfglog - verifica todo o SX3'
If Aviso('Grava no cfglog', cMsg ,{'Continuar','Sair'} , 2 )	==  2
	Return()
EndIf

lRet := ARQ_OBRIGATORIO('SX3_OLD','.DBF')

If !lRet
	Return()
EndIf

For _nY:=1 To Len(_aEmpresa)
	
	If _aEmpresa[_nY][6] == 'X'
		
		cSx3_Old		:=	'SX3_OLD_'+_aEmpresa[_nY][1]+'.DBF'
		cArqCfglog 	:=	'sx3x31'+_aEmpresa[_nY][1]+'.dtc'  //sx3x3101.dtc
		cNaoEncontrou := ''
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³	ABRE O ARQUIVO SX3_OLD	  |
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		IIF( Select('SX3_OLD')!=0, SX3_OLD->(DbCLoseArea()  ), )
		DbUseArea(.T.,,'\cfglog\SXs\'+cSx3_Old,'SX3_OLD',.T.,.T.)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³	ABRE O ARQUIVO NO CFGLOG  |
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		IIF( Select('_CFGLOG')  !=0, _CFGLOG->(DbCLoseArea()  ), )
		DbUseArea(.T.,"ctreecdx",'\cfglog\'+cArqCfglog,'_CFGLOG',.T.,.F.)
		
		nCount := 0
		SX3->(dbEval({ || nCount++ }))
		ProcRegua(nCount)
		
		lApagaSX3 := .F.
		If MsgYesNo('Empresa '+_aEmpresa[_nY][1]+ENTER+'Deseja Apagar os registros que existem no SX3 e que nao estao no TOP???'+ENTER+'Para que else sejam criados novamente ???')
			lApagaSX3 := .T.
		EndIf
		
		nCount := 0
		SX3_OLD->(DbGoTop())
		Do While  !SX3_OLD->(Eof())
			
			IncProc(SX3_OLD->X3_CAMPO)
			
			SX3->(DbGoTop()); SX3->(DbSetOrder(2))   // X3_CAMPO
			If SX3->(DbSeek(SX3_OLD->X3_CAMPO, .F.))
				
				If SX3->X3_TAMANHO < SX3_OLD->X3_TAMANHO .Or. SX3->X3_DECIMAL < SX3_OLD->X3_DECIMAL
					
					//	GRAVA NO _CFGLOG O CONTEUDO DO SX3_OLD
					GRAVA_NO_ARQUIVO('_CFGLOG','SX3', .T., _aEmpresa[_nY][1] )
					
					/*	DELETO NO SX3 PARA PODER CRIAR NO BANCO O CAMPO... */
					If lApagaSX3
						DbSelectArea('SX3')
						RecLock('SX3',.F.)
						DBDelete()
						MsUnLock()
					EndIf
					
					nCount++
					If	nCount == nQtdRegistro
						nQtdArq++
						// CRIA NOVO ARQUIVO sx3x3101.dtc [ renomeia o antigo COM "_" no final ]
						NOVO_SX3X301XX( _aEmpresa[_nY][1], nQtdArq )
						nCount := 0
					EndIf
					
				Endif
				
			EndIf
			
			SX3_OLD->(DbSkip())
			
		EndDo
		
		MsgInfo('Empresa '+_aEmpresa[_nY][1]+ENTER+'Verificação SX3 - COMPARACAO TAMANHO concluida com sucesso...')
		
		If Len(cNaoEncontrou) > 0
			Aviso('OPA!!! ', cNaoEncontrou ,{'Sair'} , 3 )
		EndIf
		
		IIF( Select('SX3_OLD') 	!=0, SX3_OLD->(DbCLoseArea()  ), )
		IIF( Select('_CFGLOG')	!=0, _CFGLOG->(DbCLoseArea()  ), )
		
	EndIf
Next

MsgInfo('Fim da rotina - LS_TAM_SX3'+ENTER+'Obrigado por utilizar o Compatibilizador de SXs')

Return

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function LS_SX3_X_TOP()
//////////////////////////////

Local nCount 		:= 0
Local nQtdArq		:=	0
Local lArquivos	:=	.T.
Local cNaoEncontrou := 	''

cMsg := 'Este programa tem objetivo de VERIFICAR CAMPOS que existam no SX3 e nao estejam criados no Banco'+ENTER
cMsg := 'Grava apenas no cfglog - verifica todo o SX3'
If Aviso('Grava no cfglog', cMsg ,{'Continuar','Sair'} , 2 )	==  2
	Return()
EndIf


If Aviso('CheckStru','Deseja Rodar o programa para compara campos que existem no SX3'+ENTER+'e que NÃO existem no Banco(TOP) ??',{'Sim','Não'}, 2) = 1
	Processa ({|| LS_CheckStru() },'Rodando CheckStru','Processando CheckStru...', .T.)
EndIf


For _nY:=1 To Len(_aEmpresa)
	
	If _aEmpresa[_nY][6] == 'X'
		
		cTabCheckDb	:=	'CHKESTRU_'+_aEmpresa[_nY][1]+'.DBF'
		cArqCfglog 	:=	'sx3x31'+_aEmpresa[_nY][1]+'.dtc'  //sx3x3101.dtc
		cNaoEncontrou := ''
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³	ABRE O CHECKSTRU DA EMPRESA XX	|
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		IIF( Select('_STRU')  !=0, _STRU->(DbCLoseArea()  ), )
		DbUseArea(.T.,,'\cfglog\SXs\'+cTabCheckDb,'_STRU',.T.,.F.)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³	ABRE O ARQUIVO NO CFGLOG  |
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		IIF( Select('_CFGLOG')  !=0, _CFGLOG->(DbCLoseArea()  ), )
		DbUseArea(.T.,"ctreecdx",'\cfglog\'+cArqCfglog,'_CFGLOG',.T.,.F.)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³	ABRE O ARQUIVO SX3 		  |
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		IIF( Select('SX3')  !=0, SX3->(DbCLoseArea()  ), )
		DbUseArea(.T.,,_StartPath+'SX3'+_aEmpresa[_nY][1]+'0','SX3',.T.,.T.)
		
		
		nCount := 0
		SX3->(dbEval({ || nCount++ }))
		ProcRegua(nCount)
		
		lApagaSX3 := .F.
		If MsgYesNo('Empresa '+_aEmpresa[_nY][1]+ENTER+'Deseja Apagar os registros que existem no SX3 e que nao estao no TOP???'+ENTER+'Para que else sejam criados novamente ???')
			lApagaSX3 := .T.
		EndIf
		
		nCount := 0
		_STRU->(DbGoTop())
		Do While  !_STRU->(Eof())
			
			SX3->(DbGoTop()); SX3->(DbSetOrder(2))   	//	X3_CAMPO
			If SX3->(DbSeek(_STRU->CAMPO, .F.))			//	APOS RODAR CheckStr(q.verifica oq tem no SX3 e nao tem no TOP) o prw ira deletar no SX3 e cria-la no cfglog para criar novamente no SX3 e TOP.
				If Alltrim(SX3->X3_VISUAL) != 'V' .And. AllTrim(SX3->X3_CONTEXT) != 'V'
					
					//	GRAVA NO _CFGLOG O CONTEUDO DO SX3_OLD
					GRAVA_NO_ARQUIVO('_CFGLOG','SX3', .T., _aEmpresa[_nY][1])
					
					/*	DELETO NO SX3 PARA PODER CRIAR NO BANCO O CAMPO... */
					If lApagaSX3
						DbSelectArea('SX3')
						RecLock('SX3',.F.)
						DBDelete()
						MsUnLock()
					EndIf
					
					nCount++
					If	nCount == nQtdRegistro
						nQtdArq++
						// CRIA NOVO ARQUIVO sx3x3101.dtc [ renomeia o antigo COM "_" no final ]
						NOVO_SX3X301XX( _aEmpresa[_nY][1], nQtdArq )
						nCount := 0
					EndIf
					
				EndIf
				
			Else
				cNaoEncontrou += _STRU->TABELA+' - '+_STRU->CAMPO+ENTER
			Endif
			
			IncProc(_STRU->CAMPO)
			
			_STRU->(DbSkip())
			
		EndDo
		
		Alert('Empresa '+_aEmpresa[_nY][1]+ENTER+'Verificação SX3 X TOP concluida com sucesso...')
		
		If Len(cNaoEncontrou) > 0
			Aviso('OPA!!! ', cNaoEncontrou ,{'Sair'} , 3 )
		EndIf
		
		
	EndIf
Next

MsgInfo('Fim da rotina - LS_SX3_X_TOP'+ENTER+'Obrigado por utilizar o Compatibilizador de SXs')

Return()

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function LS_CHECKSTRU()
//////////////////////////////

Local X3Stru    := {}
Local TabStru   := {}
Local aCampos   := {}
Local cAlias    := ""
Local cALiasNew := ""
Local cArquivo  := ""
Local cFile     := ""
Local cdados    := ""
Local nPos      := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ ESTE PROGRAMA TEM OBJETIVO DE GERAR UM ARQUIVOS      	³
//³ NA PASTA \cfglog\SXs\ CHKESTRU + o numero da empresa.	³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

lRet := ARQ_OBRIGATORIO('CHKESTRU','.DBF')
If !lRet
	Return()
EndIf


For _nY:=1 To Len(_aEmpresa)
	
	If _aEmpresa[_nY][6] == 'X'
		
		cTabCheckDb	:=	'CHKESTRU_'+_aEmpresa[_nY][1]
		
		IIF( Select(cTabCheckDb)  !=0, cTabCheckDb->(DbCLoseArea()  ), )
		DbUseArea(.T.,,'\cfglog\SXs\'+cTabCheckDb,cTabCheckDb,.T.,.F.)
		
		
		IIF( Select('SX3')  !=0, SX3->(DbCLoseArea()  ), )
		DbUseArea(.T.,,_StartPath+'SX3'+_aEmpresa[_nY][1]+'0','SX3',.T.,.T.)
		
		nCount := 0
		SX3->(dbEval({ || nCount++ }))
		ProcRegua(nCount)
		SX3->(DbGoTop())
		
		IncProc('CheckStru - Empresa '+_aEmpresa[_nY][1]+' - '+_aEmpresa[_nY][4]+'\'+_aEmpresa[_nY][3] )
		
		DbSelectArea("SX3")
		cFilter := DbFilter()
		Set Filter To
		DbGoTop()
		
		Do While !Eof()
			
			cAlias   	:= SX3->X3_ARQUIVO
			cAliasNew	:= SX3->X3_ARQUIVO+'J'
			cArquivo 	:= SX3->X3_ARQUIVO+_aEmpresa[_nY][1]+'0'   //'010'
			X3Stru   	:=	{}
			TabStru  	:=	{}
			
			IIF( Select(cArquivo)  !=0, cArquivo->(DbCLoseArea()),  )
			
			
			If Left(cAlias,2) == 'SX' .And. 	Left(cAlias,3) != 'SX5' // CASO TENHA ALGUM SX NO BANCO
				DbSelectArea("SX3")
				DbSkip()
				Loop
			EndIf
			
			IncProc('Tabela: '+cAlias +' - '+SX3->X3_CAMPO+'  Empresa: '+_aEmpresa[_nY][1] )
			
			Do While SX3->X3_ARQUIVO == cAlias .And. !EOF()
				If Alltrim(SX3->X3_VISUAL) != 'V' .And. AllTrim(SX3->X3_CONTEXT) != 'V'
					Aadd(x3stru,{X3_CAMPO,X3_TIPO,X3_TAMANHO,X3_DECIMAL})
				EndIf
				DbSkip()
			EndDo
			
			If !TCCanOpen(cArquivo)		//	Verifica a existência de tabelas e índices no servidor.
				IIF( Select(cArquivo)  !=0, cArquivo->(DbCLoseArea()),  )
				DbSelectArea("SX3")
				DbSkip()
				Loop
			Endif
			
			//DBUSEAREA (<Lnome área>,<nome driver>, <arquivo> <apelido>,<Lconpartilhado>,<Lapenas leitura> ).
			IIF( !Empty(Alias()) .And. Alias()!= 'SX3' , DbCLoseArea(),  )
			DbUseArea(.T.,"TOPCONN",cArquivo,cAliasNew,.F.,.F.)
			
			If Select(cAliasNew) == 0
				
				//	fiz um baca pq disse que nao abriu... tento novamente abrir...
				DbSelectArea(cAlias)
				If Select(cAlias) == 0
					
					Alert('Nao abriu MESMO... -> '+ cAlias)
					
					Reclock(cTabCheckDb, .T.)
					Tabela	:= 	cArquivo
					Campo  	:= 	'NAO ABRIU'
					MsUnLock()
					
				Else
					DbSelectArea(cAlias);DbGoTop()
					TabStru	:= DbStruct()		//	Retorna um array contendo a estrutura da tabela aberta sob a Alias atual.
				EndIf
				DbCLoseArea()
			Else
				
				DbSelectArea(cAliasNew)
				//If LastRec() > 0			//	Verifica se tem algum registro na tabela
				TabStru	:= DbStruct()		//	Retorna um array contendo a estrutura da tabela aberta sob a Alias atual.
				DbCLoseArea()
			Endif
			
			
			For X:=1 To Len(X3Stru)
				cDados 	:= X3Stru[X][1]
				nPos 		:= Ascan(TabStru,{|x| x[1] == AllTrim(cDados) } )
				
				If nPos == 0
					DbSelectArea(cTabCheckDb)
					Reclock(cTabCheckDb, .T.)
					Tabela	:= 	cArquivo
					Campo  	:= 	X3Stru[X][1]
					Tipox3 	:= 	X3Stru[X][2]
					TamSx3 	:= 	X3Stru[X][3]
					DecSx3 	:= 	X3Stru[X][4]
					MsUnLock()
				Endif
			Next
			
			DbSelectArea("SX3")
			DbSkip()
		EndDo
		
		DbSelectArea(cTabCheckDb)
		//Copy To '\cfglog\SXs\'+cTabCheckDb+'.DBF'
		FErase(cFile)
		DbCLoseArea()
		
		DbSelectArea("SX3")
		Set Filter To &cFilter
		
	EndIf
Next

Return
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function LS_EMPRESAS_SX3()
/////////////////////////////////

Local nCount 		:=	0
Local nQtdArq		:=	0
Local lArquivos	:=	.T.

Private oBrw
Private lTransf :=	.F.
Private	cFilLoja

_nAltura 	:= 	oMainWnd:nClientHeight - 200
_nLargura 	:= 	oMainWnd:nClientWidth  - 232
_nHRes		:=		oMainWnd:nClientWidth

If _nHRes < 1278
	Font_Arial := TFont():New( "Arial",0,-11,,.F.,0,,400,.F.,.F.,,,,,, )
	Font_Tah   := TFont():New( "Arial",0,-11,,.F.,0,,400,.F.,.F.,,,,,, )
Else
	Font_Arial := TFont():New( "Arial",0,-15,,.T.,0,,700,.F.,.F.,,,,,, )
	Font_Tah   := TFont():New( "Tahoma",0,-16,,.T.,0,,700,.F.,.F.,,,,,, )
Endif

oDlg2      := MSDialog():New( 000 ,000,_nAltura-050,_nLargura,"Seleção da(s) Empresa(s) para replicar SX",,,.F.,,,,,,.T.,,,.T. )
lbTexto    := TSay():New( 004,020,{||"ESTE PROGRAMA TEM COMO BASE OS ARQUIVOS DA EMPRESA:    " + cEmpBase },oDlg2,,Font_Tah,.F.,.F.,.F.,.T.,CLR_HRED,CLR_WHITE,252,008)

Grp2       := TGroup():New( _nAltura/13-20, 010 ,_nAltura/3+25, _nLargura-400  ,"",oDlg2,CLR_BLACK,CLR_WHITE,.T.,.F. )

If !lSelecEmpresa
	oTbl()
EndIf

DbSelectArea("TMP");DbGoTop()

oBrw       := MsSelect():New( "TMP","OK","",{	{"OK","","",""},;
{"M0_CODIGO","","Empresa","" },;
{"M0_CODFIL","","Filial",""},;
{"M0_NOME","","Nome",""},;
{"X","","",""}},.F.,;
cMarca,{_nAltura/13-10,016,_nAltura/3+15 ,_nLargura-410},,, Grp2 )

oBrw:oBrowse:BHeaderClick := {|| MarcaDesMarca('TMP'), oBrw:oBrowse:Refresh() }

BtnOk       := TButton():New( _nAltura/3+30,_nAltura/3    ,"&Ok"      ,oDlg2, {|| GravaMarca(), oDlg2:End() } ,050,012,,,,.T.,,"OK",,, ,.F. )
BtnNo       := TButton():New( _nAltura/3+30,_nAltura/3+080,"&Cancelar",oDlg2, {|| oDlg2:End() },050,012,,,,.T.,,"Cancelar",,,,.F. )


oDlg2:Activate(,,,.T.)

lSelecEmpresa	:= .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³CONTA O NUMERO DE REGISTRO DO SX3 EMPRESA: MERCOSUL  |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//SET DELE OFF
//MsAguarde( {|| SX3->( dbEval( { ||  nCount++ })) },'Processando','Aguarde contando registros...')


Return()

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function LS_FOLDER()
///////////////////////////

Local nCount 			:= 0
Local cNaoEncontrou  := ''
Local lArquivos		:=	.T.
Local nQtdArq			:=	0

cMsg := 'Este programa tem objetivo de AJUSTAR o posicionamento dos campos nos folder, conforme Empresa 01'+ENTER
cMsg += 'Grava cfglog - verifica todo SX3'
If Aviso('Grava no cfglog', cMsg ,{'Continuar','Sair'} , 2 )	==  2
	Return()
EndIf

lRet := ARQ_OBRIGATORIO('SX3_OLD','.DBF')

If !lRet
	Return()
EndIf


For _nY:=1 To Len(_aEmpresa)
	
	If _aEmpresa[_nY][6] == 'X'
		
		cSx3_Old		:=	'SX3_OLD_'+_aEmpresa[_nY][1]+'.DBF'
		cArqCfglog 	:=	'sx3x31'  +_aEmpresa[_nY][1]+'.dtc'  //sx3x3101.dtc
		cNaoEncontrou := ''
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³	ABRE O ARQUIVO SX3_OLD	  |
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		IIF( Select('SX3_OLD')!=0, SX3_OLD->(DbCLoseArea()  ), )
		DbUseArea(.T.,,'\cfglog\SXs\'+cSx3_Old,'SX3_OLD',.T.,.T.)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³	ABRE O ARQUIVO NO CFGLOG  |
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		IIF( Select('_CFGLOG')  !=0, _CFGLOG->(DbCLoseArea()  ), )
		DbUseArea(.T.,"ctreecdx",'\cfglog\'+cArqCfglog,'_CFGLOG',.T.,.F.)
		
		nCount := 0
		SX3->(dbEval({ || nCount++ }))
		ProcRegua(nCount)
		
		
		lApagaSX3 := .F.
		If MsgYesNo('Empresa '+_aEmpresa[_nY][1]+ENTER+'Deseja Apagar os registros que existem no SX3 e que nao estao no TOP???'+ENTER+'Para que else sejam criados novamente ???')
			lApagaSX3 := .T.
		EndIf
		
		SX3_OLD->(DbGoTop())
		Do While  !SX3_OLD->(Eof())
			
			IncProc(SX3_OLD->X3_CAMPO)
			
			SX3->(DbGoTop()); SX3->(DbSetOrder(2))   	//	X3_CAMPO
			If SX3->(DbSeek(SX3_OLD->X3_CAMPO, .F.))		//	APOS RODAR CheckStr(q.verifica oq tem no SX3 e nao tem no TOP) o prw ira deletar no SX3 e cria-la no cfglog para criar novamente no SX3 e TOP.
				If AllTrim(SX3->X3_FOLDER) != AllTrim(SX3_OLD->X3_FOLDER)
					
					//	GRAVA NO _CFGLOG O CONTEUDO DO SX3_OLD
					GRAVA_NO_ARQUIVO('_CFGLOG','SX3', .T., _aEmpresa[_nY][1])
					
					/*	DELETO NO SX3 PARA PODER CRIAR NO BANCO O CAMPO... */
					If lApagaSX3
						DbSelectArea('SX3')
						RecLock('SX3',.F.)
						DBDelete()
						MsUnLock()
					EndIf
					
					nCount++
					If	nCount == nQtdRegistro
						nQtdArq++
						// CRIA NOVO ARQUIVO sx3x3101.dtc [ renomeia o antigo COM "_" no final ]
						NOVO_SX3X301XX( _aEmpresa[_nY][1], nQtdArq )
						nCount := 0
					EndIf
				EndIf
			Else
				cNaoEncontrou += SX3_OLD->X3_CAMPO+ENTER
			Endif
			
			SX3_OLD->(DbSkip())
			
		EndDo
		
		MsgInfo('Empresa '+_aEmpresa[_nY][1]+ENTER+'Verificação SX3 - COMPARACAO FOLDER concluida com sucesso...')
		
		If Len(cNaoEncontrou) > 0
			Aviso('OPA!!! ', cNaoEncontrou ,{'Sair'} , 3 )
		EndIf
		
		IIF( Select('SX3_OLD') 	!=0, SX3_OLD->(DbCLoseArea()  ), )
		IIF( Select('_CFGLOG')	!=0, _CFGLOG->(DbCLoseArea()  ), )
		
	EndIf
Next

MsgInfo('Fim da rotina - LS_FOLDER'+ENTER+'Obrigado por utilizar o Compatibilizador de SXs')


Return()

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function LS_SIX_ATU()
////////////////////////////

nCount	:= 0
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³     INDICES     |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cMsg := 'Este programa tem objetivo de AJUSTAR o arquivo de INDICES(SIX) '+ENTER
cMsg += 'Caso o indice da Empresa 01 não existir na Empresa(s) selecionada(s) o programa ira criar.'
cMsg := 'Grava TXT ou SIX - seleciona SIX'
If Aviso('Grava em TXT ou SIX', cMsg ,{'Continuar','Sair'} , 2 )	==  2
	Return()
EndIf

lRet := ARQ_OBRIGATORIO('INDICES')

If !lRet
	Return()
EndIf


IIF( Select('SIX')!=0, SIX->(DbCLoseArea()  ), )
DbUseArea(.T.,,_StartPath+'SIX010','SIX',.T.,.F.);DbSetIndex(_StartPath+'SIX010')
SIX->(DbGoTop())
SET DELE OFF
MsAguarde( {|| SIX->( dbEval( { ||  nCount++ })) },'Processando','Aguarde registros - Indices...')
ProcRegua(SIX->(nCount))
SIX->(DbGoTop())

cMsg :=	'Deseja gerar um arquivo TXT ou gravar no SIX da(s) Empresa(s) selecionada ?'
nOp  := 	Aviso('Gravar em...', cMsg ,{'TXT','SIX'} , 2 )
lTxt := IIF(nOp==1, .T., .F. )


For _nY:= 1 To Len(_aEmpresa)
	
	If _aEmpresa[_nY][6] == 'X'
		
		cArqSXI 	:= ''
		_nCount	:=	0
		
		cMsg	:=	'Deseja selecionar um ou mais INDICE(s) ou verificar todos ???'
		If Aviso('Seleção Parametro. Empresa '+_aEmpresa[_nY][1], cMsg ,{'Selecionar','Todos'} , 2 )	 == 1
			Processa ({|| ReplicaSXs('SIX') },'ReplicaSXs - SIX ','Processando...', .T.)
			lReplicaTodos	:= .F.
			cTabela 	:=	"'"+'TMP_PAR'+"'"
		Else
			Processa ({|| },'ReplicaSXs - SIX ','Processando...', .T.)
			lReplicaTodos	:= .T.
			cTabela 	:=	"'"+'SIX'+"'"
		EndIf
		
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³	ABRE SIX DA EMPRESA XXX	  |
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		IIF( Select('_SIX')  !=0, _SIX->(DbCLoseArea()  ), )
		DbUseArea(.T.,,_StartPath+'SIX0'+AllTrim(_aEmpresa[X][1]),'_SIX',.T.,.F.)
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³	ABRE ARQUIVO DE INDICES NO CFGLOG	|
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		IIF( Select('_SIXLOG')  !=0, _SIXLOG->(DbCLoseArea()  ), )
		DbUseArea(.T.,,'\CFGLOG\SIXX31'+Alltrim(_aEmpresa[X][1])+'.DTC','_SIXLOG',.T.,.F.)
		
		
		&cTabela->(DbGoTop())
		Do While  !&cTabela->(Eof())
			
			If !lReplicaTodos
				If Empty(&cTabela->OK)
					&cTabela->(DbSkip())
					Loop
				EndIf
			EndIf
			
			SIX->(IncProc(AllTrim(SIX->INDICE)+'  -  Empresa: '+AllTrim(_aEmpresa[X][1])+' - '+AllTrim(_aEmpresa[X][3]) ))
			
			_SIX->(DbGoTop()); _SIX->(DbSetOrder(1))
			If !_SIX->(DbSeek(&cTabela->INDICE + &cTabela->ORDEM, .F.))
				If lTxt
					cArqSXI	+=	'X6_FIL		:'	+	&cTabela->X6_FIL		+ENTER
					cArqSXI	+=	'INDICE		:'	+	&cTabela->INDICE		+ENTER
					cArqSXI	+=	'ORDEM		:'	+	&cTabela->ORDEM		+ENTER
					cArqSXI	+=	'CHAVE		:'	+	&cTabela->CHAVE		+ENTER
					cArqSXI	+=	'DESCRICAO	:'	+	&cTabela->DESCRICAO	+ENTER
					cArqSXI	+=	'DESCSPA		:'	+	&cTabela->DESCSPA		+ENTER
					cArqSXI	+=	'DESCENG		:'	+	&cTabela->DESCENG		+ENTER
					cArqSXI	+=	'PROPRI		:'	+	&cTabela->PROPRI		+ENTER
					cArqSXI	+=	'F3			:'	+	&cTabela->F3			+ENTER
					cArqSXI	+=	'NICKNAME	:'	+	&cTabela->NICKNAME	+ENTER
					cArqSXI	+=	'SHOWPESQ	:'	+	&cTabela->SHOWPESQ	+ENTER
					cArqSXI	+=	'_F_L_A_G	:' +	'0'						+ENTER
					cArqSXI	+=	'_R_E_C_N_O	:'	+	0							+ENTER
					cArqSXI	+=	'_M_0_E_M_P	:'	+	Alltrim(_aEmpresa[X][1])	+ENTER
					cArqSXI += Replicate('-', 100) +ENTER
					_nCount++
				Else
					RecLock('_SIXLOG',.T.)
					_SIXLOG->INDICE		:=	SIX->INDICE
					_SIXLOG->ORDEM			:=	SIX->ORDEM
					_SIXLOG->CHAVE			:=	SIX->CHAVE
					_SIXLOG->DESCRICAO	:=	SIX->DESCRICAO
					_SIXLOG->DESCSPA		:=	SIX->DESCSPA
					_SIXLOG->DESCENG		:=	SIX->DESCENG
					_SIXLOG->PROPRI		:=	SIX->PROPRI
					_SIXLOG->F3				:=	SIX->F3
					_SIXLOG->NICKNAME		:=	SIX->NICKNAME
					_SIXLOG->SHOWPESQ		:=	SIX->SHOWPESQ
					_SIXLOG->_F_L_A_G 	:=	'0'
					_SIXLOG->_R_E_C_N_O	:=	0
					_SIXLOG->_M_0_E_M_P	:=	Alltrim(_aEmpresa[X][1])
					MsUnLock()
				EndIf
			Endif
			
			IncProc()
			cTabela->(DbSkip())
			
		EndDo
		
		If !Empty(cArqSXI)
			
			cArqSx6 += ENTER+'TOTAL REGISTROS: '+AllTrim(Str(_nCount))+ENTER+Replicate('-', 100)
			MemoWrit('cfglog\Sxs\SIX_'+_aEmpresa[_nY][1]+'.TXT', cArqSxI )
			
			MsgInfo(	'Empresa '+_aEmpresa[_nY][1]+ENTER+'Verificação SIX concluida com sucesso...'+ENTER+;
			'Arquivo gerado [SIX_'+_aEmpresa[_nY][1]+'] em cfglog\Sxs\')
		Else
			MsgInfo('Não foi encontrado nenhuma diferençca entre o SIX da Empresa 01 para o SIX Empresa '+_aEmpresa[_nY][1])
		EndIf
		
		IIF( Select('_SIX')   	!=0, _SIX->(DbCLoseArea()  ), )
		IIF( Select('_SIXLOG')	!=0, _SIXLOG->(DbCLoseArea()  ), )
		
	EndIf
Next

MsgInfo('Fim da rotina - LS_SIX_ATU'+ENTER+'Obrigado por utilizar o Compatibilizador de SXs')

Return

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function LS_SX6_ATU()
////////////////////////////

Local nCount :=	0
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³    PARAMETROS	  |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cMsg := 'Este programa tem objetivo de COPIAR OS PARAMETROS (SX6) da Empresa 01 que nao existem nas demais Empresas'+ENTER
If Aviso('Grava em TXT ou SX6 - Seleciona SX6', cMsg ,{'Continuar','Sair'} , 2 )	==  2
	Return()
EndIf


IIF( Select('SX6')!=0, SX6->(DbCLoseArea()  ), )
DbUseArea(.T.,,_StartPath+'SX610','SX6',.T.,.F.);DbSetIndex(_StartPath+'SX6010')
SX6->(DbGoTop())
SET DELE OFF
MsAguarde( {|| SX6->( dbEval( { ||  nCount++ })) },'Processando','Aguarde registros - Parametros...')
ProcRegua(SX6->(nCount))
SX6->(DbGoTop())


cMsg :=	'Deseja gerar um arquivo TXT ou gravar no SX6 da(s) Empresa(s) selecionada ?'
nOp  := 	Aviso('Gravar em...', cMsg ,{'TXT','SX6'} , 2 )
lTxt := IIF(nOp==1, .T., .F. )

For _nY:= 1 To Len(_aEmpresa)
	
	If _aEmpresa[_nY][6] == 'X'
		cArqSX6 	:= ''
		_nCount	:=	0	
		
		cMsg	:=	'Deseja selecionar um ou mais PARAMETRO(s) ou verificar todos ???'
		If Aviso('Seleção Parametro. Empresa '+_aEmpresa[_nY][1], cMsg ,{'Selecionar','Todos'} , 2 ) == 1
			Processa ({|| ReplicaSXs('SX6') },'ReplicaSXs - SX6 ','Processando...', .T.)
			lReplicaTodos	:= .F.
			cTabela 	:=	"'"+'TMP_PAR'+"'"
		Else
			Processa ({|| },'ReplicaSXs - SX6 ','Processando...', .T.)
			lReplicaTodos	:= .T.
			cTabela 	:=	"'"+'SX6'+"'"
		EndIf
		
		IIF(Select('_SX6') > 0,	_SX6->(DbCloseArea()),)
		DbUseArea(.T.,,_StartPath+'SX6'+AllTrim(_aEmpresa[_nY][1])+'0','_SX6',.T.,.F.)
		DbSetIndex(_StartPath+'SX6'+AllTrim(_aEmpresa[_nY][1])+'0')
		
		&cTabela->(DbGoTop())
		Do While  !&cTabela->(Eof())
			
			If !lReplicaTodos
				If Empty(&cTabela->OK)
					&cTabela->(DbSkip())
					Loop
				EndIf
			EndIf
			
			_SX6->(DbGoTop()); _SX6->(DbSetOrder(1))
			If !_SX6->(DbSeek(&cTabela->X6_FIL + &cTabela->X6_VAR, .F.))
				If lTxt
					cArqSX6	+=	'X6_FIL		:'	+	&cTabela->X6_FIL		+ENTER
					cArqSX6	+=	'X6_VAR		:'	+	&cTabela->X6_VAR		+ENTER
					cArqSX6	+=	'X6_TIPO		:'	+	&cTabela->X6_TIPO		+ENTER
					cArqSX6	+=	'X6_DESCRIC	:'	+	&cTabela->X6_DESCRIC	+ENTER
					cArqSX6	+=	'X6_CONTEUD	:'	+	&cTabela->X6_CONTEUD	+ENTER
					cArqSX6	+=	'X6_PROPRI	:'	+	'U'+ENTER
					cArqSX6 += Replicate('-', 100)+ENTER
					_nCount++
				Else
					RecLock('_SX6',.T.)
					_SX6->X6_FIL		:=	SX6->X6_FIL
					_SX6->X6_VAR		:=	SX6->X6_VAR
					_SX6->X6_TIPO		:=	SX6->X6_TIPO
					_SX6->X6_DESCRIC	:=	SX6->X6_DESCRIC
					_SX6->X6_CONTEUD	:=	SX6->X6_CONTEUD
					_SX6->X6_PROPRI	:=	'U'
					MsUnLock()
				EndIf
			Endif
			IncProc()
			&cTabela->(DbSkip())
		EndDo
		
		If !Empty(cArqSx6)
			
			cArqSx6 += ENTER+'TOTAL REGISTROS: '+AllTrim(Str(_nCount))+ENTER+Replicate('-', 100)
			MemoWrit('cfglog\Sxs\SX6_'+_aEmpresa[_nY][1]+'.TXT', cArqSx6 )
			
			MsgInfo(	'Empresa '+_aEmpresa[_nY][1]+ENTER+'Verificação SX6 concluida com sucesso...'+ENTER+;
			'Arquivo gerado [SX6_'+_aEmpresa[_nY][1]+'] em cfglog\Sxs\')
		Else
			MsgInfo('Não foi encontrado nenhuma diferençca entre o SX6 da Empresa 01 para o SX6 Empresa '+_aEmpresa[_nY][1])
		EndIf
		
		IIF( Select('_SX6')	  !=0, _SX6->(DbCLoseArea()  ), )
		IIF( Select('TMP_PAR') !=0, TMP_PAR->(DbCLoseArea()  ), )
		
	EndIf
	
Next

MsgInfo('Fim da rotina - LS_SX6_ATU'+ENTER+'Obrigado por utilizar o Compatibilizador de SXs')


Return

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function LS_SX7_ATU()
////////////////////////////

nCount	:=	0
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³    GATILHOS     |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cMsg := 'Este programa tem objetivo de Gerar um TXT DOS GATILHOS (SX7) da Empresa 01 que nao existem nas demais Empresas e Filiais'+ENTER
cMsg += 'Não irei alterar a tabela SX7 pq pode haver sequencia dos gatilhos diferente nas Empresas\Filiais.'
If Aviso('Grava TXT - Seleciona SX7', cMsg ,{'Continuar','Sair'} , 2 )	==  2
	Return()
EndIf


IIF( Select('SX7')!=0, SX7->(DbCLoseArea()  ), )
SX7->(DbGoTop())
SET DELE OFF
MsAguarde( {|| SX7->( dbEval( { ||  nCount++ })) },'Processando','Aguarde registros - Gatilhos...')
ProcRegua(SX7->(nCount))
SX7->(DbGoTop())

For _nY:= 1 To Len(_aEmpresa)
	
	If _aEmpresa[_nY][6] == 'X'
		
		cArqSx7	:=	''
		_nCount	:=	0
		
		cMsg	:=	'Deseja selecionar um ou mais GATILHO(s) ou verificar todos ???'
		If Aviso('Seleção Parametro. Empresa '+_aEmpresa[_nY][1], cMsg ,{'Selecionar','Todos'} , 2 )	 == 1
			Processa ({|| ReplicaSXs('SX7') },'ReplicaSXs - SX7 ','Processando...', .T.)
			lReplicaTodos	:= .F.
			cTabela 	:=	"'"+'TMP_PAR'+"'"
		Else
			Processa ({|| },'ReplicaSXs - SX7 ','Processando...', .T.)
			lReplicaTodos	:= .T.
			cTabela 	:=	"'"+'SX7'+"'"
		EndIf
		
		IIF(Select('_SX7') != 0,	_SX7->(DbCloseArea()),)
		DbUseArea(.T.,,_StartPath+'SX7'+AllTrim(_aEmpresa[_nY][1])+'0','_SX7',.T.,.F.)
		DbSetIndex(_StartPath+'SX7'+AllTrim(_aEmpresa[_nY][1])+'0')
		
		
		&cTabela->(DbGoTop())
		Do While  !&cTabela->(Eof())
			
			If !lReplicaTodos
				If Empty(&cTabela->OK)
					&cTabela->(DbSkip())
					Loop
				EndIf
			EndIf
			
			If !_SX7->(DbSeek(&cTabela->X7_CAMPO + &cTabela->X7_SEQUENC, .F.))
				
				/*
				RecLock('_SX7',.T.)
				_SX7->X7_SEQUENC	:=	SX7->X7_SEQUENC
				_SX7->X7_REGRA		:=	SX7->X7_REGRA
				_SX7->X7_CDOMIN 	:=	SX7->X7_CDOMIN
				_SX7->X7_TIPO		:= SX7->X7_TIPO
				_SX7->X7_SEEK		:=	SX7->X7_SEEK
				_SX7->X7_ALIAS		:=	SX7->X7_ALIAS
				_SX7->X7_ORDEM		:=	SX7->X7_ORDEM
				_SX7->X7_CHAVE		:=	SX7->X7_CHAVE
				_SX7->X7_CONDIC	:=	SX7->X7_CONDIC
				_SX7->X7_PROPRI	:=	SX7->X7_PROPRI
				MsUnLock()
				*/
				
				cArqSx7 += 'CAMPO    : '+&cTabela->X7_CAMPO  	+ENTER
				cArqSx7 += 'SEQUENCIA: '+&cTabela->X7_SEQUENC	+ENTER
				cArqSx7 += 'REGRA    : '+&cTabela->X7_REGRA		+ENTER
				cArqSx7 += 'CDOMIN   : '+&cTabela->X7_CDOMIN		+ENTER
				cArqSx7 += 'TIPO     : '+&cTabela->X7_TIPO		+ENTER
				cArqSx7 += 'SEEK     : '+&cTabela->X7_SEEK		+ENTER
				cArqSx7 += 'ALIAS    : '+&cTabela->X7_ALIAS		+ENTER
				cArqSx7 += 'ORDEM    : '+Alltrim(Str(&cTabela->X7_ORDEM))	+ENTER
				cArqSx7 += 'CHAVE    : '+&cTabela->X7_CHAVE		+ENTER
				cArqSx7 += 'CONDIC   : '+&cTabela->X7_CONDIC		+ENTER
				cArqSx7 += 'PROPRI   : '+&cTabela->X7_PROPRI		+ENTER
				cArqSx7 += Replicate('-', 100)+ENTER
				_nCount++
				
			Endif
			
			&cTabela->(DbSkip())
			IncProc()
		EndDo
		
		If !Empty(cArqSx7)
			
			cArqSx7 += ENTER+'TOTAL REGISTROS: '+AllTrim(Str(_nCount))+ENTER+Replicate('-', 100)
			MemoWrit('cfglog\Sxs\SX7_'+_aEmpresa[_nY][1]+'.TXT', cArqSx7 )
			
			MsgInfo(	'Empresa '+_aEmpresa[_nY][1]+ENTER+'Verificação SX7 concluida com sucesso...'+ENTER+;
			'Arquivo gerado [SX7_'+_aEmpresa[_nY][1]+'] em cfglog\Sxs\')
		Else
			MsgInfo('Não foi encontrado nenhuma diferençca entre o SX7 da Empresa 01 para o SX7 Empresa '+_aEmpresa[_nY][1])
		EndIf
		
		IIF( Select('_SX7') !=0, _SX7->(DbCLoseArea()  ), )
		IIF( Select('TMP_PAR') !=0, TMP_PAR->(DbCLoseArea()  ), )
		
	EndIf
	
Next

MsgInfo('Fim da rotina - LS_SX7_ATU'+ENTER+'Obrigado por utilizar o Compatibilizador de SXs')

Return

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function LS_SXB_ATU()
////////////////////////////

Local nCount :=	0
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ CONSULTA PADRAO |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cMsg := 'Este programa tem objetivo de copiar os registros do arquivo SXB para demais Empresas e Filiais'+ENTER
cMsg += 'Caso o SXB da Empresa 01 não existir na Empresa(s) selecionada(s) o programa ira criar.'
If Aviso('Grava em TXT ou SXB - Seleciona SXB', cMsg ,{'Continuar','Sair'} , 2 )	==  2
	Return()
EndIf

IIF( Select('SXB')!=0, SXB->(DbCLoseArea()  ), )
SXB->(DbGoTop())
SET DELE OFF
MsAguarde( {|| SXB->( dbEval( { ||  nCount++ })) },'Processando','Aguarde registros - Cons.Padrão...')
ProcRegua(SXB->(nCount))
SXB->(DbGoTop())

cMsg :=	'Deseja gerar um arquivo TXT ou gravar no SXB da(s) Empresa(s) selecionada ?'
nOp  := 	Aviso('Gravar em...', cMsg ,{'TXT','SXB'} , 2 )
lTxt := IIF(nOp==1, .T., .F. )


For _nY:= 1 To Len(_aEmpresa)
	
	If _aEmpresa[_nY][6] == 'X'
		cArqSXB 	:= ''
		_nCount	:=	0
		
		cMsg	:=	'Deseja selecionar um ou mais SXB ou verificar todos ???'
		If Aviso('Seleção Parametro. Empresa '+_aEmpresa[_nY][1], cMsg ,{'Selecionar','Todos'} , 2 )	 == 1
			Processa ({|| ReplicaSXs('SXB') },'ReplicaSXs - SXB ','Processando...', .T.)
			lReplicaTodos	:= .F.
			cTabela 	:=	"'"+'TMP_PAR'+"'"
		Else
			Processa ({|| },'ReplicaSXs - SXB ','Processando...', .T.)
			lReplicaTodos	:= .T.
			cTabela 	:=	"'"+'SXB'+"'"
		EndIf
		
		
		IIF(Select('_SXB') > 0,	_SXB->(DbCloseArea()),)
		DbUseArea(.T.,,_StartPath+'SXB'+AllTrim(_aEmpresa[_nY][1])+'0','_SXB',.T.,.F.)
		DbSetIndex(_StartPath+'SXB'+AllTrim(_aEmpresa[_nY][1])+'0')
		
		&cTabela->(DbGoTop())
		Do While  !&cTabela->(Eof())
			
			If !lReplicaTodos
				If Empty(&cTabela->OK)
					&cTabela->(DbSkip())
					Loop
				EndIf
			EndIf
			
			_SXB->(DbGoTop()); _SXB->(DbSetOrder(1))
			If !_SXB->(DbSeek(&cTabela->XB_ALIAS, .F.))
				If lTxt
					cArqSXB	+=	'XB_ALIAS	: ' + &cTabela->XB_ALIAS	+ENTER
					cArqSXB	+=	'XB_TIPO		: ' + &cTabela->XB_TIPO		+ENTER
					cArqSXB	+=	'XB_SEQ		: ' + &cTabela->XB_SEQ		+ENTER
					cArqSXB	+=	'XB_COLUNA	: ' + &cTabela->XB_COLUNA	+ENTER
					cArqSXB	+=	'XB_DESCRI	: ' + &cTabela->XB_DESCRI	+ENTER
					cArqSXB	+=	'XB_DESCSPA	: ' + &cTabela->XB_DESCSPA	+ENTER
					cArqSXB	+=	'XB_DESCENG	: ' + &cTabela->XB_DESCENG	+ENTER
					cArqSXB	+=	'XB_CONTEM	: ' + &cTabela->XB_CONTEM	+ENTER
					cArqSXB += Replicate('-', 100)+ENTER
					_nCount++
				Else
					RecLock('_SXB',.T.)
					_SXB->XB_ALIAS		:=	&cTabela->XB_ALIAS
					_SXB->XB_TIPO		:=	&cTabela->XB_TIPO
					_SXB->XB_SEQ		:=	&cTabela->XB_SEQ
					_SXB->XB_COLUNA	:=	&cTabela->XB_COLUNA
					_SXB->XB_DESCRI	:=	&cTabela->XB_DESCRI
					_SXB->XB_DESSPA	:=	&cTabela->XB_DESSPA
					_SXB->XB_DESENG	:=	&cTabela->XB_DESENG
					_SXB->XB_CONTEM	:=	&cTabela->XB_CONTEM
					MsUnLock()
				EndIf
			Endif
			
			&cTabela->(DbSkip())
			IncProc()
		EndDo
		
		If !Empty(cArqSxB)
			
			cArqSxB += ENTER+'TOTAL REGISTROS: '+AllTrim(Str(_nCount))+ENTER+Replicate('-', 100)
			MemoWrit('cfglog\Sxs\SXB_'+_aEmpresa[_nY][1]+'.TXT', cArqSxB )
			
			MsgInfo(	'Empresa '+_aEmpresa[_nY][1]+ENTER+'Verificação SXB concluida com sucesso...'+ENTER+;
			'Arquivo gerado [SXB_'+_aEmpresa[_nY][1]+'] em cfglog\Sxs\')
		Else
			MsgInfo('Não foi encontrado nenhuma diferençca entre o SXB da Empresa 01 para o SXB Empresa '+_aEmpresa[_nY][1])
		EndIf
		
		IIF( Select('_SXB') 	!=0, _SXB->(DbCLoseArea()  ), )
		IIF( Select('TMP_PAR') !=0, TMP_PAR->(DbCLoseArea()  ), )
	EndIf
	
Next

MsgInfo('Fim da rotina - LS_SXB_ATU'+ENTER+'Obrigado por utilizar o Compatibilizador de SXs')

Return

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function LS_SX2_ATU()
////////////////////////////

Local nCount	:=	0

cMsg := 'Este programa tem objetivo de COPIAR os registro do arquivo SX2 para as demais Empresas'+ENTER
cMsg += 'Caso o SX2 da Empresa 01 não existir na Empresa(s) selecionada(s) o programa ira criar.'
If Aviso('Grava em TXT ou SX2 - Seleciona SX2', cMsg ,{'Continuar','Sair'} , 2 )	==  2
	Return()
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³     TABELAS     |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//IIF( Select('SX2')!=0, SX2->(DbCLoseArea()  ), )
SX2->(DbGoTop())
SET DELE OFF
MsAguarde( {|| SX2->( dbEval( { ||  nCount++ })) },'Processando','Aguarde registros - SX2...')
ProcRegua(SX2->(nCount))
SX2->(DbGoTop())

cMsg :=	'Deseja gerar um arquivo TXT ou gravar no SX2 da(s) Empresa(s) selecionada ?'
nOp  := 	Aviso('Gravar em...', cMsg ,{'TXT','SX2'} , 2 )
lTxt := IIF(nOp==1, .T., .F. )

For _nY:= 1 To Len(_aEmpresa)
	
	If _aEmpresa[_nY][6] == 'X'
		cArqSX2 	:= ''
		_nCount	:=	0
		
		cMsg	:=	'Deseja selecionar um ou mais SX2 ou verificar todos ???'
		If Aviso('Seleção Parametro. Empresa '+_aEmpresa[_nY][1], cMsg ,{'Selecionar','Todos'} , 2 )	 == 1
			Processa ({|| ReplicaSXs('SX2') },'ReplicaSXs - SX2 ','Processando...', .T.)
			lReplicaTodos	:= .F.
			cTabela 	:=	"'"+'TMP_PAR'+"'"
		Else
			Processa ({|| },'ReplicaSXs - SX2 ','Processando...', .T.)
			lReplicaTodos	:= .T.
			cTabela 	:=	"'"+'SX2'+"'"
		EndIf
		
		IIF(Select('_SX2') > 0,	_SX2->(DbCloseArea()),)
		DbUseArea(.T.,,_StartPath+'SX2'+AllTrim(_aEmpresa[_nY][1])+'0','_SX2',.T.,.F.)
		DbSetIndex(_StartPath+'SX2'+AllTrim(_aEmpresa[_nY][1])+'0')
		
		&cTabela->(DbGoTop())
		Do While  !&cTabela->(Eof())
			
			If !lReplicaTodos
				If Empty(&cTabela->OK)
					&cTabela->(DbSkip())
					Loop
				EndIf
			EndIf
			
			_SX2->(DbGoTop()); _SX2->(DbSetOrder(1))
			If !_SX2->(DbSeek(&cTabela->X2_CHAVE, .F.))
				If lTxt
					cArqSX2	+=	'X2_CHAVE		: '	+	&cTabela->X2_CHAVE	+ENTER
					cArqSX2	+=	'SX2->X2_PATH	: '	+	&cTabela->X2_PATH		+ENTER
					cArqSX2	+=	'X2_ARQUIVO		: '	+	Left(&cTabela->X2_ARQUIVO,4)+AllTrim(_aEmpresa[_nY][1])	+ENTER
					cArqSX2	+=	'SX2->X2_NOME	: '	+	&cTabela->X2_NOME		+ENTER
					cArqSX2	+=	'SX2->X2_NOMESPA: '	+	&cTabela->X2_NOMESPA	+ENTER
					cArqSX2	+=	'SX2->X2_NOMEENG:	'	+	&cTabela->X2_NOMEENG	+ENTER
					cArqSX2	+=	'SX2->X2_ROTINA: 	'	+	&cTabela->X2_ROTINA	+ENTER
					cArqSX2	+=	'SX2->X2_MODO	:	'	+	&cTabela->X2_MODO		+ENTER
					cArqSX2	+=	'SX2->X2_DELET	:	'	+	Alltrim(Str(&cTabela->X2_DELET))	+ENTER
					cArqSX2	+=	'SX2->X2_TTS	:	'	+	&cTabela->X2_TTS		+ENTER
					cArqSX2	+=	'SX2->X2_UNICO	:	'	+	&cTabela->X2_UNICO	+ENTER
					cArqSX2	+=	'SX2->X2_PYME	:	'	+	&cTabela->X2_PYME		+ENTER
					cArqSX2	+=	'SX2->X2_TTS	:	'	+	&cTabela->X2_TTS		+ENTER
					cArqSx2 += Replicate('-', 100)+ENTER
					_nCount++
				Else
					
					RecLock('_SX2',.T.)
					_SX2->X2_CHAVE		:=	&cTabela->X2_CHAVE
					_SX2->X2_PATH		:=	&cTabela->X2_PATH
					_SX2->X2_ARQUIVO	:=	Left(&cTabela->X2_ARQUIVO,4)+AllTrim(_aEmpresa[X][1])
					_SX2->X2_NOME		:=	&cTabela->X2_NOME
					_SX2->X2_NOMESPA	:=	&cTabela->X2_NOMESPA
					_SX2->X2_NOMEENG	:=	&cTabela->X2_NOMEENG
					_SX2->X2_ROTINA	:=	&cTabela->X2_ROTINA
					_SX2->X2_MODO		:=	&cTabela->X2_MODO
					_SX2->X2_DELET		:=	&cTabela->X2_DELET
					_SX2->X2_TTS		:=	&cTabela->X2_TTS
					_SX2->X2_UNICO		:=	&cTabela->X2_UNICO
					_SX2->X2_PYME		:=	&cTabela->X2_PYME
					_SX2->X2_TTS		:=	&cTabela->X2_TTS
					MsUnLock()
				EndIf
			Endif
			
			IncProc()
			&cTabela->(DbSkip())
		EndDo
		
		
		If !Empty(cArqSx2)
			
			cArqSx2 += ENTER+'TOTAL REGISTROS: '+AllTrim(Str(_nCount))+ENTER+Replicate('-', 100)
			MemoWrit('cfglog\Sxs\SX2_'+_aEmpresa[_nY][1]+'.TXT', cArqSx2 )
			
			MsgInfo(	'Empresa '+_aEmpresa[_nY][1]+ENTER+'Verificação SX2 concluida com sucesso...'+ENTER+;
			'Arquivo gerado [SX2_'+_aEmpresa[_nY][1]+'] em cfglog\Sxs\')
		Else
			MsgInfo('Não foi encontrado nenhuma diferençca entre o SX2 da Empresa 01 para o SX2 Empresa '+_aEmpresa[_nY][1])
		EndIf
		
		IIF( Select('_SX2') 	!=0, _SX2->(DbCLoseArea()  ), )
		IIF( Select('TMP_PAR') !=0, TMP_PAR->(DbCLoseArea()  ), )
	EndIf
Next

MsgInfo('Fim da rotina - LS_SX2_ATU'+ENTER+'Obrigado por utilizar o Compatibilizador de SXs')

Return

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function C(nTam)
///////////////////////

Local nHRes	:=	oMainWnd:nClientWidth	// Resolucao horizontal do monitor
If nHRes == 640	// Resolucao 640x480 (soh o Ocean e o Classic aceitam 640)
	nTam *= 0.8
ElseIf (nHRes == 798).Or.(nHRes == 800)	// Resolucao 800x600
	nTam *= 1
Else	// Resolucao 1024x768 e acima
	nTam *= 1.28
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Tratamento para tema "Flat"³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If "MP8" $ oApp:cVersion
	If (Alltrim(GetTheme()) == "FLAT") .Or. SetMdiChild()
		nTam *= 0.90
	EndIf
EndIf
Return Int(nTam)

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function ARQ_OBRIGATORIO(cArquivo, cExtensao)
////////////////////////////////////////////////////

Local lRet := .T.

If cArquivo == 'INDICES'
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³		VERIFICA ARQUIVOS QUE CRIA OS INDICES		 |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For _nY:=1 To Len(_aEmpresa)
		If _aEmpresa[_nY][6] == 'X'
			If !File('\cfglog\SIXX31'+Alltrim(_aEmpresa[_nY][1])+'.DTC')
				If File('\cfglog\SXs\sixx.dtc')
					_COPYFILE('\cfglog\SXs\SIXX.DTC','\cfglog\SIXX31'+Alltrim(_aEmpresa[_nY][1])+'.DTC')
				Else
					MsgAlert('Preciso do arquivo:  \cfglog\SXs\sixx.dtc para empresa ' + Alltrim(_aEmpresa[_nY][1]) )
					lRet := .F.
				EndIf
			Endif
		EndIf
	Next
	
ElseIf cArquivo == 'CHKESTRU' .Or. cArquivo == 'SX3_OLD'
	
	For _nY:=1 To Len(_aEmpresa)
		If _aEmpresa[_nY][6] == 'X'
			
			//cArquivo := '\cfglog\SXs\CHKESTRU_'+_aEmpresa[_nY][1]+'.DBF'
			cArquivo := '\cfglog\SXs\'+cArquivo+'_'+_aEmpresa[_nY][1]+'.DBF'
			
			If !File(cArquivo)
				MsgAlert('Preciso do arquivo: '+ cArquivo)
				lRet := .F.
			EndIf
		EndIf
	Next
EndIf

Return(lRet)

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function GRAVA_NO_ARQUIVO(cArquivo, cTabela, lGrava, cEmpresa)
/////////////////////////////////////////////////////////////////////

cArquivo := "'"+cArquivo+"'"
cTabela 	:=	"'"+cTabela+"'"

RecLock('_CFGLOG',lGrava)
&(cArquivo)->X3_ARQUIVO		:=	&(cTabela)->X3_ARQUIVO
&(cArquivo)->X3_ORDEM		:=	&(cTabela)->X3_ORDEM
&(cArquivo)->X3_CAMPO		:=	&(cTabela)->X3_CAMPO
&(cArquivo)->X3_TIPO			:=	&(cTabela)->X3_TIPO
&(cArquivo)->X3_TAMANHO		:=	&(cTabela)->X3_TAMANHO
&(cArquivo)->X3_DECIMAL		:=	&(cTabela)->X3_DECIMAL
&(cArquivo)->X3_TITULO		:=	&(cTabela)->X3_TITULO
&(cArquivo)->X3_TITSPA		:=	&(cTabela)->X3_TITSPA
&(cArquivo)->X3_TITENG		:=	&(cTabela)->X3_TITENG
&(cArquivo)->X3_DESCRIC		:=	&(cTabela)->X3_DESCRIC
&(cArquivo)->X3_DESCSPA		:=	&(cTabela)->X3_DESCSPA
&(cArquivo)->X3_DESCENG		:=	&(cTabela)->X3_DESCENG
&(cArquivo)->X3_PICTURE		:=	&(cTabela)->X3_PICTURE
&(cArquivo)->X3_VALID  		:=	&(cTabela)->X3_VALID
&(cArquivo)->X3_USADO  		:=	&(cTabela)->X3_USADO
&(cArquivo)->X3_RELACAO		:=	&(cTabela)->X3_RELACAO
&(cArquivo)->X3_F3			:=	&(cTabela)->X3_F3
&(cArquivo)->X3_NIVEL		:=	&(cTabela)->X3_NIVEL
&(cArquivo)->X3_RESERV		:=	&(cTabela)->X3_RESERV
&(cArquivo)->X3_CHECK		:=	&(cTabela)->X3_CHECK
&(cArquivo)->X3_TRIGGER		:=	&(cTabela)->X3_TRIGGER
&(cArquivo)->X3_PROPRI		:=	&(cTabela)->X3_PROPRI
&(cArquivo)->X3_BROWSE		:=	&(cTabela)->X3_BROWSE
&(cArquivo)->X3_VISUAL		:=	&(cTabela)->X3_VISUAL
&(cArquivo)->X3_CONTEXT		:=	&(cTabela)->X3_CONTEXT
&(cArquivo)->X3_OBRIGAT		:=	&(cTabela)->X3_OBRIGAT
&(cArquivo)->X3_VLDUSER		:=	&(cTabela)->X3_VLDUSER
&(cArquivo)->X3_CBOX   		:=	&(cTabela)->X3_CBOX
&(cArquivo)->X3_CBOXSPA		:=	&(cTabela)->X3_CBOXSPA
&(cArquivo)->X3_CBOXENG		:=	&(cTabela)->X3_CBOXENG
&(cArquivo)->X3_PICTVAR		:=	&(cTabela)->X3_PICTVAR
&(cArquivo)->X3_WHEN   		:=	&(cTabela)->X3_WHEN
&(cArquivo)->X3_INIBRW 		:=	&(cTabela)->X3_INIBRW
&(cArquivo)->X3_GRPSXG 		:=	&(cTabela)->X3_GRPSXG
&(cArquivo)->X3_FOLDER 		:=	&(cTabela)->X3_FOLDER
&(cArquivo)->X3_PYME 		:=	&(cTabela)->X3_PYME
&(cArquivo)->X3_CONDSQL		:=	&(cTabela)->X3_CONDSQL
&(cArquivo)->X3_CHKSQL	 	:=	&(cTabela)->X3_CHKSQL
&(cArquivo)->X3_IDXSRV	 	:=	&(cTabela)->X3_IDXSRV
&(cArquivo)->X3_ORTOGRA	 	:=	&(cTabela)->X3_ORTOGRA
&(cArquivo)->X3_IDXFLD	 	:=	&(cTabela)->X3_IDXFLD
&(cArquivo)->X3_TELA	 		:=	&(cTabela)->X3_TELA
&(cArquivo)->_F_L_A_G 		:=	'0'
&(cArquivo)->_R_E_C_N_O		:=	 0
&(cArquivo)->_M_0_E_M_P		:=	cEmpresa
&(cArquivo)->X3_HELP 		:=	&(cTabela)->X3_DESCRIC
MsUnLock()
Return

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function NOVO_SX3X301XX( cEmpresa, nQtdArq )
///////////////////////////////////////////////////

IIF( Select('_CFGLOG')  !=0, _CFGLOG->(DbCLoseArea()  ), )
FRENAME( '\cfglog\sx3x31'+cEmpresa+'.dtc', '\cfglog\sx3x3101_'+AllTrim(Str(nQtdArq))+'.dtc' )
_COPYFILE('\cfglog\SXs\SX3.dtc','\cfglog\sx3x31'+cEmpresa+'.dtc')

IIF( Select('_CFGLOG')  !=0, _CFGLOG->(DbCLoseArea()  ), )
DbUseArea(.T.,"ctreecdx",'\cfglog\sx3x31'+cEmpresa+'.dtc','_CFGLOG',.T.,.F.)


Return()

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function oTbl()
//////////////////////

Local 	aCampos := 	{}
Private 	cTmp

aAdd( aCampos, {"OK"		    	, "C", 002,000 })
aAdd( aCampos, {"M0_CODIGO"	, "C", 002,000	})
aAdd( aCampos, {"M0_CODFIL"	, "C", 020,000	})
aAdd( aCampos, {"M0_NOME"		, "C", 050,000	})
aAdd( aCampos, {"X" 	         , "C", 002,000	})

cTmp := CriaTrab( aCampos, .T. )
Use (cTmp) Alias TMP New Exclusive
//INDEX ON Z2_SERIE  TAG 1 TO &cTmp
DbSelectArea('TMP')
For nX:= 1 To Len(_aEmpresa)
	RecLock('TMP',.T.)
	TMP->M0_CODIGO	:=	_aEmpresa[nX][1]
	TMP->M0_CODFIL	:=	_aEmpresa[nX][2]
	TMP->M0_NOME	:=	AllTrim(_aEmpresa[nX][3]) +' / '+ AllTrim(_aEmpresa[nX][4])
	MsUnLock()
Next
Return

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function MarcaDesMarca(cTemp)//	cTemp == "TMP" ou "TMP_PAR"
///////////////////////////////////////////////////////////////////

Local lMarca := .F.

//	apenas para veripereiraficar se ha algum marcado ou nao
DbSelectArea(cTemp);DbGoTop()
Do While !Eof()
	If Marked("OK")
		lMarca := .T.
		Exit
	EndIf
	DbSkip()
EndDo

DbSelectArea(cTemp);DbGoTop()
Do While !Eof()
	RecLock(cTemp,.F.)
	If !lMarca		// TMP_PAR->&(aCampos[X][1])	:=	&(cTabelaSX+'->'+aCampos[X][1])
		&(cTemp+"->OK")	:=	cMarca
	Else
		&(cTemp+"->OK")	:=	''
	EndIf
	MsUnLock()
	
	DbSkip()
EndDo

DbSelectArea(cTemp);DbGoTop()

Return

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function GravaMarca()
////////////////////////////

Local lMarca

DbSelectArea('TMP');DbGoTop()
Do While !Eof()
	
	If Marked("OK")
		RecLock('TMP',.F.)
		TMP->OK	:=	cMarca
		MsUnLock()
		
		lMarca	:=	.T.
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³		VERIFICA ARQUIVOS QUE CRIA OS CAMPOS 	    |
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If AllTrim(Str(nOpcao)) $ '1/2/3/4/9'
			If !File('\CFGLOG\SX3X31'+Alltrim(TMP->M0_CODIGO)+'.dtc')
				_COPYFILE('\CFGLOG\SXs\SX3.dtc','\CFGLOG\SX3X31'+Alltrim(Alltrim(TMP->M0_CODIGO))+'.dtc')
			Endif
			
			If !File('\CFGLOG\SXs\CHKESTRU_'+Alltrim(TMP->M0_CODIGO)+'.DBF')
				_COPYFILE('\CFGLOG\SXs\CHKESTRU.DBF','\CFGLOG\SXs\CHKESTRU_'+Alltrim(TMP->M0_CODIGO)+'.DBF')
			Endif
		EndIf
	Else
		lMarca	:=	.F.
	EndIf
	
	nPos := Ascan(_aEmpresa, {|X| X[1] == TMP->M0_CODIGO } ) //.And. X[2] == TMP->M0_CODFIL } )
	_aEmpresa[nPos][6] := IIF(lMarca, 'X', '')
	
	DbSelectArea('TMP')
	DbSkip()
	
EndDo

DbSelectArea('TMP');DbGoTop()

Return

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function CriaArquivoSxs()
////////////////////////////////

If !File('\cfglog\SXs')
	Alert('Preciso de seguinte diretorio:  \cfglog\SXs  ')
	Return
EndIf

If !File('\cfglog\SXs\CHKESTRU.DBF')
	aCampos   := {}
	Aadd(aCampos,{"TABELA"	,"C",10,0 } )
	Aadd(aCampos,{"CAMPO"	,"C",10,0 } )
	Aadd(aCampos,{"TIPX3"	,"C",01,0 } )
	Aadd(aCampos,{"TAMSX3"	,"N",03,0 } )
	Aadd(aCampos,{"DECSX3"	,"N",03,0 } )
	
	cFile := CriaTrab(aCampos,.T.)
	DbUseArea(.T.,,cFile,'CHKESTRU',.T.,.F.)
	Copy To '\cfglog\SXs\CHKESTRU.DBF'
	DbCLoseArea()
	FErase(cFile)
EndIf


If !File('\cfglog\SXs\sx3.dtc')
	
	If File('\cfglog\SXs\sx3.dbf')
		Alert('Converta o arquivo \cfglog\SXs\sx3.dbf para CTree (sx3.dtc) ')
		Return
	EndIf
	
	aCampos   := {}
	Aadd(aCampos,{"X3_ARQUIVO"	,"C",003,0 } )	//	TamSX3("X3_ARQUIVO")[1],0 } )
	Aadd(aCampos,{"X3_ORDEM"	,"C",002,0 } )
	Aadd(aCampos,{"X3_CAMPO"	,"C",010,0 } )
	Aadd(aCampos,{"X3_TIPO"		,"C",001,0 } )
	Aadd(aCampos,{"X3_TAMANHO"	,"N",003,0 } )
	Aadd(aCampos,{"X3_DECIMAL"	,"N",001,0 } )
	Aadd(aCampos,{"X3_TITULO"	,"C",012,0 } )
	Aadd(aCampos,{"X3_TITSPA"	,"C",012,0 } )
	Aadd(aCampos,{"X3_TITENG"	,"C",012,0 } )
	Aadd(aCampos,{"X3_DESCRIC"	,"C",025,0 } )
	Aadd(aCampos,{"X3_DESCSPA"	,"C",025,0 } )
	Aadd(aCampos,{"X3_DESCENG"	,"C",025,0 } )
	Aadd(aCampos,{"X3_PICTURE"	,"C",045,0 } )
	Aadd(aCampos,{"X3_VALID"	,"C",128,0 } )
	Aadd(aCampos,{"X3_USADO"	,"C",015,0 } )
	Aadd(aCampos,{"X3_RELACAO"	,"C",128,0 } )
	Aadd(aCampos,{"X3_F3"		,"C",006,0 } )
	Aadd(aCampos,{"X3_NIVEL"	,"N",001,0 } )
	Aadd(aCampos,{"X3_RESERV"	,"C",002,0 } )
	Aadd(aCampos,{"X3_CHECK"	,"C",001,0 } )
	Aadd(aCampos,{"X3_TRIGGER"	,"C",001,0 } )
	Aadd(aCampos,{"X3_PROPRI"	,"C",001,0 } )
	Aadd(aCampos,{"X3_BROWSE"	,"C",001,0 } )
	Aadd(aCampos,{"X3_VISUAL"	,"C",001,0 } )
	Aadd(aCampos,{"X3_CONTEXT"	,"C",001,0 } )
	Aadd(aCampos,{"X3_OBRIGAT"	,"C",001,0 } )
	Aadd(aCampos,{"X3_VLDUSER"	,"C",128,0 } )
	Aadd(aCampos,{"X3_CBOX"		,"C",128,0 } )
	Aadd(aCampos,{"X3_CBOXSPA"	,"C",128,0 } )
	Aadd(aCampos,{"X3_CBOXENG"	,"C",128,0 } )
	Aadd(aCampos,{"X3_PICTVAR"	,"C",020,0 } )
	Aadd(aCampos,{"X3_WHEN"		,"C",060,0 } )
	Aadd(aCampos,{"X3_INIBRW"	,"C",080,0 } )
	Aadd(aCampos,{"X3_GRPSXG"	,"C",003,0 } )
	Aadd(aCampos,{"X3_FOLDER"	,"C",001,0 } )
	Aadd(aCampos,{"X3_PYME"		,"C",001,0 } )
	Aadd(aCampos,{"X3_CONDSQL"	,"C",250,0 } )
	Aadd(aCampos,{"X3_CHKSQL"	,"C",250,0 } )
	Aadd(aCampos,{"X3_IDXSRV"	,"C",001,0 } )
	Aadd(aCampos,{"X3_ORTOGRA"	,"C",001,0 } )
	Aadd(aCampos,{"X3_IDXFLD"	,"C",001,0 } )
	Aadd(aCampos,{"X3_TELA"	   ,"C",015,0 } )
	Aadd(aCampos,{"_F_L_A_G"	,"C",001,0 } )
	Aadd(aCampos,{"_R_E_C_N_O"	,"N",010,0 } )
	Aadd(aCampos,{"_M_0_E_M_P"	,"C",002,0 } )
	Aadd(aCampos,{"X3_HELP"		,"M",010,0 } )
	cFile := CriaTrab(aCampos,.T.)
	DbUseArea(.T.,,cFile,'SXs_sx3',.T.,.F.)
	Copy To '\cfglog\SXs\sx3.dbf'
	DbCLoseArea()
	FErase(cFile)
	
	Alert('Converta o arquivo \cfglog\SXs\sx3.dbf para CTree (sx3.dtc)')
	Return
	
EndIf

Return

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function ReplicaSXs(cTabSX)	// BROSWER PARA SELECIONAR OS PARAM.
////////////////////////////////////////////////////////////////////////

Private 	aMsSelect:=	{}
Private 	cIndexPadrao :=	''
Private 	lInformaSx 	 := .F.
Private 	cPesquisa	 :=	Space(50)
cTabelaSX  	:= cTabSX

SetPrvt("oDlgPar","oGrp1","oSay1","oSay2","oGet1","oBtPesquisar","oGrp2","oBrw1","oBtnGravar","oBtnCancela")

oDlgPar    := MSDialog():New( 088,192,617,909,"Replica "+cTabSX,,,.F.,,,,,,.T.,,,.T. )
oGrp1      := TGroup():New( 012,004,032,352,"",oDlgPar,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSay1      := TSay():New( 020,008,{||"Pesquisa:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay2      := TSay():New( 020,132,{||"Indice: "  + cIndexPadrao },oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,120,008)
oGet1      := TGet():New( 018,036,{|u| If(PCount()>0,cPesquisa:=u,cPesquisa)},oGrp1,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oBtPesquis := TButton():New( 016,104,"Ok",oGrp1,{|| IIF(!lInformaSx, TMP_PAR->(DbGoTop(),DbSeek(cPesquisa, .T.)), CarregaSX(AllTrim(cPesquisa)) ), oBrw1:oBrowse:Refresh() },020,012,,,,.T.,,"",,,,.F. )

oGrp2      := TGroup():New( 036,004,236,352,"",oDlgPar,CLR_BLACK,CLR_WHITE,.T.,.F. )

Processa ({|| oTbPar() },'Processando Arquivo... Agusrde...','Processando...', .T.)

DbSelectArea("TMP_PAR")
oBrw1      := MsSelect():New( "TMP_PAR","OK","", aMsSelect ,.F.,cMarca,{044,008,232,348},,, oGrp2 )

oBrw1:oBrowse:BHeaderClick := {|| MarcaDesMarca('TMP_PAR'), oBrw1:oBrowse:Refresh() }

oBtnGravar := TButton():New( 240,096,"Replicar",oDlgPar, {|| oDlgPar:End()},037,012,,,,.T.,,"",,,,.F. )
oBtnCancel := TButton():New( 240,188,"Cancela",oDlgPar,  {|| oDlgPar:End()},037,012,,,,.T.,,"",,,,.F. )

oDlgPar:Activate(,,,.T.)

Return

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function  oTbPar()	// CRIA TABELA PARA O MSSELECT
//////////////////////////////////////////////////////////

Local cTmpPar
Local	cTabSX		:=	"'"+ cTabelaSX+"'" // PRECISO DAS ASPAS PARA UTILIAZR NO SELECT() ABAIXO
Private	nTamTab	:=	0
aCampos 	:=	{}

IIF( Select(cTabSX)!=0, cTabSX->(DbCLoseArea()  ), )
cTabSX	:= '_'+cTabelaSX		//	_SX7	-	ALIAS DO DbUseArea
DbUseArea(.T.,,_StartPath+cTabelaSX+'010', cTabSX ,.T.,.F.)
DbSelectArea(cTabelaSX)		//	SX7
cIndexPadrao := IndexKey(IndexOrd())	//	PEGA O INDICE PADRAO DA TABELA

aTabStru		 := DbStruct()

Aadd( aCampos,   {"OK", "C", 002,000 })
Aadd( aMsSelect, {"OK", "", "",""} )
For X:=1 To Len(aTabStru)
	Aadd( aCampos ,  { aTabStru[X][1], aTabStru[X][2],aTabStru[X][3],aTabStru[X][4]} )
	Aadd( aMsSelect, { aTabStru[X][1], "", aTabStru[X][1],""} )
Next

IIF( Select('TMP_PAR')!=0, TMP_PAR->(DbCLoseArea()  ), )

cTmpPar := CriaTrab( aCampos, .T. )
Use (cTmpPar) Alias TMP_PAR New Exclusive
INDEX ON &cIndexPadrao  TAG 1 TO &cTmpPar

cMsg := 'Carregar todos os SXs ou você ira informar ???'
If Aviso('Carregar SXs', cMsg ,{'Informar','Todos'} , 2 )	==  2
	Processa ({|| CarregaSX('TODOS') },'Carregando Arquivos SXs','Processando...', .T.)
Else
	lInformaSx := .T.
EndIf

Return

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function CarregaSX(cInfoPar) //	CARREGA OS CAMPOS DO SX... PARA O MSSELECT
//////////////////////////////////////////////////////////////////////////////////

nCount:=0
nXX   :=0

If cInfoPar == 'TODOS'
	cTabelaSX 	 := '_'+cTabelaSX   // PASSOU A SER _SX7
	&(cTabelaSX)->( dbEval( { || nCount++ }))
	ProcRegua(nCount)
	
	&(cTabelaSX)->(DbGoTop())
	Do While !&(cTabelaSX)->(Eof())
		nXX++
		IncProc('Lendo SXs...','Aguarde...')
		
		RecLock('TMP_PAR',.T.)
		For X:=1 To Len(aCampos)
			If aCampos[X][1] != 'OK'
				TMP_PAR->&(aCampos[X][1])	:=	&(cTabelaSX+'->'+aCampos[X][1])
			EndIf
		Next
		MsUnLock()
		&(cTabelaSX)->(DbSkip())
	EndDo
	
Else
	
	&(cTabelaSX)->(DbGoTop())
	If &(cTabelaSX)->(DbSeek(cInfoPar, .F.))
		
		lOk := .T.
		//	VERIFICA SE PARAMETRO JA ESTA NO TABELA TEMP.
		DbSelectArea('TMP_PAR');DbGoTop()
		Do While !Eof()
			If cInfoPar == AllTrim(TMP_PAR->&(aCampos[2][1]))
				lOk := .F.
				Exit
			EndIf
			TMP_PAR->(DbSkip())
		EndDo
		
		If lOk
			Do While cInfoPar == AllTrim(  &( cTabelaSX+'->'+aCampos[2][1] )  )	// VERIFICA SE PARAM DIGITADO TEM MAIS DE UM..
				RecLock('TMP_PAR',.T.)
				For X:=1 To Len(aCampos)
					If aCampos[X][1] != 'OK'
						TMP_PAR->&(aCampos[X][1])	:=	&(cTabelaSX+'->'+aCampos[X][1])
					EndIf
				Next
				MsUnLock()
				&(cTabelaSX)->(DbSkip())
			EndDo
		EndIf
		
	Else
		Alert('Parametro  ['+Alltrim(cInfoPar)+']  não encontrado!!!')
	EndIf
	
EndIf
TMP_PAR->(DbGoTop())

Return

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function Cope_Baca()
///////////////////////////

Local cDiretorio	:=	_RootPath+'\data_atu\'
Local aDiretorio 	:= {}
Local aTamanho		:=	{}

cMsg	:=	'Este Baca tem objetivo de verificar os arquivos na pasta  '+cDiretorio+'  e '+ENTER
cMsg	+=	'ira comparar se o arquivo existe no SX2 e separa-los'
If Aviso('Programa Baca', cMsg ,{'Continuar','Sair'} , 2 )	==  1
	
	aDir( cDiretorio+'*.DBF'  , aDiretorio , aTamanho )
	ProcRegua(Len(aDiretorio))
	
	For _nY:=1 To Len(_aEmpresa)
		If _aEmpresa[_nY][6] == 'X'
			IIF(Select('_SX2') > 0,	_SX2->(DbCloseArea()),)
			DbUseArea(.T.,,_StartPath+'SX2'+AllTrim(_aEmpresa[_nY][1])+'0','_SX2',.T.,.F.)
			DbSetIndex(_StartPath+'SX2'+AllTrim(_aEmpresa[_nY][1])+'0')
			
			For _nX:=1 To Len(aDiretorio)
				cFile	:=	RetFileName(aDiretorio[_nX])
				
				If Len(cFile) != 6
					Loop
				EndIf
				
				If Right(cFile, 3) == _aEmpresa[_nY][1]+'0' //	'010'
					
					IncProc('Empresa: '+_aEmpresa[_nY][1]+' - '+_aEmpresa[_nY][3]+' - Arquivo: '+ aDiretorio[_nX])
					
					cTabela := "'"+aDiretorio[_nX]+"'"
					IIF(Select(cTabela)!=0, cTabela->(DbCloseArea()), )
					
					If _SX2->(DbSeek(cFile,.F.))
						_COPYFILE(cDiretorio+aDiretorio[_nX],cDiretorio+'Ok_Protheus\'+_aEmpresa[_nY][1]+'\'+aDiretorio[_nX])
						FErase(cDiretorio+aDiretorio[_nX])
					Else
						_COPYFILE(cDiretorio+aDiretorio[_nX],cDiretorio+'No_Protheus\'+_aEmpresa[_nY][1]+'\'+aDiretorio[_nX])
						FErase(cDiretorio+aDiretorio[_nX])
					EndIf
				EndIf
			Next
		EndIf
	Next
	
	IIF(Select('_SX2') > 0,	_SX2->(DbCloseArea()),)
	MsgInfo('Final da Rotina...')
	
EndIf

Return
