#include 'protheus.ch'
#include 'tbiconn.ch'
#include 'topconn.ch'    

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � CHAMUS   �Autor �Luis Henrique Robusto� Data �  07/02/05   ���
�������������������������������������������������������������������������͹��
���Desc.     � CONTROLE DE CHAMADOS...                                    ���
���          � Controla os chamados, inclui, altera, exclui, e verifica   ���
���          � os andamentos de chamados...                               ���
�������������������������������������������������������������������������͹��
���Uso       � Grupo Rech Tratores                                        ���
�������������������������������������������������������������������������͹��
���DATA      � ANALISTA �  MOTIVO                                         ���
�������������������������������������������������������������������������͹��
���          �          �                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

#define CHR_LINE				'<hr>'
#define CHR_CENTER_OPEN			'<div align="center" >'
#define CHR_CENTER_CLOSE   		'</div>'
#define CHR_FONT_DET_OPEN		'<font face="Courier New" size="2">'
#define CHR_FONT_DET_CLOSE		'</font>'
#define CHR_ENTER				'<br>'
#define CHR_NEGRITO				'<b>'
#define CHR_NOTNEGRITO			'</b>'

User Function CHAMUS()
Private	_cEmpUso  	:= AllTrim(cEmpAnt)+"/",;
		_cPerg    	:= "CHAMUS",;
		_bFiltraBrw	:= ''
		_aIndexSZC 	:= {}
		_cFiltro  	:= ''

Private	cCadastro 	:= OemToAnsi('Controle de Chamados'),;
		cAlias	  	:= 'SZC',;
		aCores    	:= {{ "SZC->ZC_STATUS=='0'", 'ENABLE' },; // Aberto
						{ "SZC->ZC_STATUS=='8'", 'BR_PRETO'},; // Cancelado
						{ "SZC->ZC_STATUS=='9'", 'DISABLE'},; // Encerrado
						{ "SZC->ZC_STATUS=='1'", 'BR_AMARELO'} },;// Em analise
		aRotina   	:= {{ 'Pesquisar','AxPesqui',0,1},;
		               	{ 'Visualizar','U_CHAMEdit',0,2},;
        		       	{ 'Incluir','U_CHAMEdit',0,3},;
		               	{ 'Alterar','U_CHAMEdit',0,4},;
		               	{ 'Excluir','U_CHAMEdit',0,5},;
		               	{ 'Ence&rrar','U_CHAMEdit',0,6},;
		               	{ '&Cancelar','U_CHAMCan',0,7},;
		               	{ 'Im&primir','U_CHAMPRINT',0,9},;
		               	{ 'Legenda','U_CHAMLeng',0,8}}

		DbSelectArea(cAlias)
		(cAlias)->(DbSetOrder(1))
		(cAlias)->(DbGoTop())

		If	( cNivel < 8 ) // Caso nao seja Usuario Superior 
			If	! ( AllTrim(cModulo) $ "ATF|" ) // Caso o modulo nao seja Ativo Fixo
				_cFiltro := "SZC->ZC_SOLCHAM == __cUserId" // Filtra, mostrando somente os chamados do usuario.
			Else
				_cFiltro := "_cEmpUso $ SZC->ZC_EMPCHAM" // Filtra, mostrando os dados de todos os usuarios, mas somente da mesma empresa.
			EndIf
		Else
			AjustaSx1(_cPerg) // ajusta os parametros da rotina.
			If	! Pergunte(_cPerg,.T.) // Faz as perguntas ao usuario.
				Return .f.
			Else
				// Monta o filtro de acordo com os parametros selecionados.
				If	( mv_par01 == 1 ) // Pendentes
					_cFiltro := "(AllTrim(SZC->ZC_STATUS)='0' .or. AllTrim(SZC->ZC_STATUS)='1') "
				ElseIf	( mv_par01 == 2 ) // Em analise
					_cFiltro := "AllTrim(SZC->ZC_STATUS)='1'"
				ElseIf	( mv_par01 == 3 ) // Encerrados
					_cFiltro := "AllTrim(SZC->ZC_STATUS)='9'"
				ElseIf	( mv_par01 == 4 ) // Cancelados
					_cFiltro := "AllTrim(SZC->ZC_STATUS)='8'"
				Else
					_cFiltro := "AllTrim(SZC->ZC_STATUS)$'0/1/8/9'"
				EndIf
				If	( mv_par02 == 1 ) // Alto
					_cFiltro += " .AND. AllTrim(SZC->ZC_PRICHAM)='A'"
				ElseIf	( mv_par02 == 2 ) // Normal
					_cFiltro += " .AND. AllTrim(SZC->ZC_PRICHAM)='N'"
				ElseIf	( mv_par02 == 3 ) // Baixa
					_cFiltro += " .AND. AllTrim(SZC->ZC_PRICHAM)='B'"
				Else
					_cFiltro += " .AND. AllTrim(SZC->ZC_PRICHAM)$'A/B/N'"
				EndIf
				_cFiltro += " .AND. SZC->ZC_PROGRAM >= '" + mv_par03 + "' .AND. SZC->ZC_PROGRAM <= '" + mv_par04 + "' "
				If	( mv_par05 == 1 ) // Filtra por Tecnico /1=Sim,2=Nao
					_cFiltro += " .AND. ( (SZC->ZC_SOLCHAM == __cUserId) .or. (SZC->ZC_TECALOC == __cUserId) .or. (SZC->ZC_TECNICO == __cUserId) ) "
				EndIf
				If	( ! Empty(mv_par06) )
					_cFiltro += " .AND. ( AllTrim(Upper(mv_par06)) $ Upper(SZC->ZC_DESC) .or. AllTrim(Upper(mv_par06)) $ Upper(SZC->ZC_OCORREN) ) "
				EndIf
			EndIf
		EndIf

		If	! Empty(_cFiltro)
			_bFiltraBrw := {|| FilBrowse("SZC",@_aIndexSZC,@_cFiltro) }
			Eval(_bFiltraBrw)
		EndIf

		mBrowse(6,1,22,75,'SZC',,,,,,aCores)

		EndFilBrw("SZC",_aIndexSZC)

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �xChamados �Autor �Luis Henrique Robusto� Data �  07/02/05   ���
�������������������������������������������������������������������������͹��
���Desc.     � Chamados...                                                ���
�������������������������������������������������������������������������͹��
���Uso       � Funcao Principal                                           ���
�������������������������������������������������������������������������͹��
���DATA      � ANALISTA �  MOTIVO                                         ���
�������������������������������������������������������������������������͹��
���          �          �                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function CHAMEdit( cAlias, nReg, nOpcion )
Local	oWindow,;
		oFontWin,;
		aFolders	:= {},;
		aHead		:= {},;
		bOk 		:= "{ || Iif(Iif(nOpcao<>6,!Empty(cDesCham).and.!Empty(cTipCham).and.!Empty(cPriCham),!Empty(cDesCham).and.!Empty(cTipCham).and.!Empty(cPriCham).and.!Empty(cClasFech)),(lSave:=.t.,oWindow:End()),Nil) }",;
		bCancel 	:= "{ || lSave:=.f. , oWindow:End() }",;
		aButtons	:= {},;
		_cMsgCic	:= '',;
		cTitWin

Private	nRegSM0		:= SM0->(Recno())

Private	cNumCham	:= Space(8),;
		cDesCham	:= Space(80),;
		dDtAbert	:= dDataBase,;
		dHrAbert	:= Time(),;
		cSolCham	:= __cUserId,;
		cEmpCham	:= cEmpAnt+'/'+cFilAnt,;
		cTipCham	:= Space(4),;
		cPriCham 	:= Space(4),;
		cModCham	:= cModulo,;
		cProgCham	:= Space(15),;
		mAberOcor,;
		oAberOcor,;
		mSoluOcor,;
		oSoluOcor,;
		mComentar,;
		oComentar,;
		dDtFecha	:= Ctod('  /  /  '),;
		dHrFecha	:= '  :  :  ',;
		cTecCham	:= Space(6),;
		cClasFech	:= Space(4),;
		cTecAloc	:= Space(6)

Private	nOpcao 		:= nOpcion,;		// Numero da opcao selecionada..
		lSave		:= .f.,;			// Variavel controla se tem ou nao que salvar.
		lEdite		:= .f.				// Controla se edita ou nao os dados.

Private	_oTipCham,;
		_cTipCham	:= Space(20),;
		_oPriCham,;
		_cPriCham	:= Space(20),;
		_oSolCham,;
		_cSolCham	:= Space(20),;
		_oEmpCham,;
		_cEmpCham	:= Space(20),;
		_oTecAloc,;
		_cTecAloc	:= Space(20),;
		_oTecCham,;
		_cMailTec,;
		_cTecCham	:= Space(20),;
		_oClasFech,;
		_cClasFech	:= Space(20),;
		_oModulo,;
		_oModCham,;
		_oPrograma,;
		_oProgCham,;
		oRadio,;
		nRadio 		:= 1

		//��������������������������������������Ŀ
		//�Verifica se o chamado esta cancelado.!�
		//����������������������������������������
		If	( nOpcao <> 3 ) .and. ( SZC->ZC_STATUS == '8' )
			Return
		EndIf

		//������������������������������������������������Ŀ
		//�Verifica qual o titulo sera colocado na janela.!�
		//��������������������������������������������������
		If	( nOpcao == 3 ) // Incluir
			cTitWin := 'Incluir'
		ElseIf	( nOpcao == 4 ) // Alterar
			cTitWin := 'Alterar'
		ElseIf	( nOpcao == 5 ) // Excluir
			cTitWin := 'Excluir'
		ElseIf	( nOpcao == 2 ) // Visualizar
			cTitWin := 'Visualizar'
		ElseIf	( nOpcao == 6 ) // Encerrar
			cTitWin := 'Encerrar'
		EndIf

		//�����������������������������Ŀ
		//�Autoriza a editar os "edites"�
		//�������������������������������
		If	( cNivel >= 8 ) .or. ( AllTrim(cModulo) $ "ATF|" )
			lEdite := .t.
		EndIf

		If	( cNivel < 8 )
			If	( nOpcao == 4 ) .or. ( nOpcao == 5 ) .or. ( nOpcao == 6 )
				Help('',1,'CHAMUS',,OemToAnsi('Voc� n�o tem permiss�o para '+cTitWin+'.'),1)
				Return
			EndIf
		EndIf

		//������������������������������������Ŀ
		//�Verifica se o usuario pode alterar !�
		//��������������������������������������
		If	( nOpcao==4 ) .and. ( ! Empty(SZC->ZC_TECNICO) )
			Help('',1,'CHAMUS',,OemToAnsi('Este chamado j� foi encerrado.'),1)
			Return
		EndIf

		//������������������������������������Ŀ
		//�Verifica se o usuario pode alterar !�
		//��������������������������������������
		If	( nOpcao==5 ) .and. ( ! Empty(SZC->ZC_TECNICO) .or. ! Empty(SZC->ZC_TECALOC) ) 
			Help('',1,'CHAMUS',,OemToAnsi('Este chamado j� foi encerrado.'),1)
			Return
		EndIf

		//�������������������Ŀ
		//�Atualiza os dados.!�
		//���������������������
		If	( nOpcao <> 3 )
			cNumCham	:= SZC->ZC_NUMCHAM
			cEmpCham	:= SZC->ZC_EMPCHAM
			cSolCham	:= SZC->ZC_SOLCHAM
			cPriCham	:= SZC->ZC_PRICHAM
			cDesCham	:= SZC->ZC_DESC
			cTipCham	:= SZC->ZC_TIPO
			cModCham	:= SZC->ZC_MODULO
			cProgCham	:= SZC->ZC_PROGRAM
			dDtAbert	:= SZC->ZC_DTABERT
			dHrAbert	:= SZC->ZC_HRABERT
			mAberOcor	:= SZC->ZC_OCORREN
			cTecAloc	:= SZC->ZC_TECALOC
			mComentar	:= SZC->ZC_COMENTA
			dDtFecha	:= SZC->ZC_DTFECHA
			dHrFecha	:= SZC->ZC_HRFECHA
			cTecCham	:= SZC->ZC_TECNICO
			cClasFech	:= SZC->ZC_CLASSIF
			mSoluOcor	:= SZC->ZC_SOLUCAO
			//�����������������������������������Ŀ
			//�Quando estiver alterando o Chamado.�
			//�������������������������������������
			If	( nOpcao == 4 ) .and. Empty(cTecAloc)
				cTecAloc := __cUserId // Atualiza o Tecnico Alocado
			EndIf
			//�������������������������Ŀ
			//�Quando estiver ENCERRANDO�
			//���������������������������
			If	( nOpcao == 6 ) .and. Empty(cTecCham)
				dDtFecha	:= dDataBase
				dHrFecha	:= Time()
				cTecCham	:= __cUserId
			EndIf
		Else
			cNumCham	:= GetSx8Num('SZC','ZC_NUMCHAM')
		EndIf

		//��������������������������������������������Ŀ
		//�Monta a janela de interacao com o usuario. !�
		//����������������������������������������������
		DEFINE MSDIALOG oWindow FROM 38,16 TO 550,531 TITLE Alltrim(OemToAnsi('Chamados - Ocorr�ncias ['+cTitWin+']')) Pixel //430,531 
		DEFINE FONT oFontWin NAME 'Arial' SIZE 6, 15 BOLD
		DEFINE FONT oFontMemo NAME 'Courier New' SIZE 0,15
		@ 015, 005 To 050, 255 Label OemToAnsi('Controle de Chamados') Of oWindow Pixel
		@ 023, 011 Say OemToAnsi('Chamado') Size 023, 007 Of oWindow Pixel
		@ 033, 011 MsGet cNumCham Size 017, 010 When .F. Font oFontWin Of oWindow Pixel
		@ 023, 050 Say OemToAnsi('Descri��o') Size 028, 007 Of oWindow Pixel
		@ 033, 050 MsGet cDesCham Size 200, 010 Picture ('@!') When nOpcao<>5.and.nOpcao<>2 Valid TEXTO() Of oWindow Pixel

		//��������������������
		//�Define os Folders.�
		//��������������������
		aAdd(aFolders,OemToAnsi('&Informa��es'))
		aAdd(aHead,'HEADER 1')
		aAdd(aFolders,OemToAnsi('&Abertura'))
		aAdd(aHead,'HEADER 2')
		If	( nOpcao == 2 ) .or. ( nOpcao == 4 ) .or. ( nOpcao == 5 ) .or. ( nOpcao == 6 )
			aAdd(aFolders,OemToAnsi('&Coment�rios T�cnicos'))
			aAdd(aHead,'HEADER 3')
		EndIf
		If	( nOpcao == 2 ) .or. ( nOpcao == 6 ) .or. ( nOpcao == 5 )
			aAdd(aFolders,OemToAnsi('&Encerramento'))
			aAdd(aHead,'HEADER 4')
		EndIf	
		oFolder := TFolder():New(055,005,aFolders,aHead,oWindow,,,,.T.,.F.,250,192)
		For nx:=1 to Len(aFolders)
			DEFINE SBUTTON FROM 5000,5000 TYPE 5 ACTION Allwaystrue() ENABLE OF oFolder:aDialogs[nx]
		Next nx

		//�����������Ŀ
		//�Informacoes�
		//�������������
		@ 005, 005 Say OemToAnsi('Tipo:') Size 025, 007 Of oFolder:aDialogs[1] Pixel
		@ 005, 040 MsGet cTipCham Size 035, 010 F3 'ZO ' Valid xValid(1) When nOpcao<>5.and.nOpcao<>2 Of oFolder:aDialogs[1] Pixel
		@ 005, 083 Say _oTipCham Var _cTipCham Font oFontWin Of oFolder:aDialogs[1] Pixel
		@ 017, 005 Say OemToAnsi('Prioridade:') Size 025, 007 Of oFolder:aDialogs[1] Pixel
		@ 017, 040 MsGet cPriCham Size 035, 010 F3 'ZP ' Valid xValid(2) When nOpcao<>5.and.nOpcao<>2 Of oFolder:aDialogs[1] Pixel
		@ 017, 083 Say _oPriCham Var _cPriCham Font oFontWin Of oFolder:aDialogs[1] Pixel
		@ 029, 005 Say _oModulo Var OemToAnsi('M�dulo:') Size 025, 007 Of oFolder:aDialogs[1] Pixel
		@ 029, 040 MsGet _oModCham Var cModCham Size 035, 010 When .f. Of oFolder:aDialogs[1] Pixel
		@ 041, 005 Say _oPrograma Var OemToAnsi('Programa:') Size 025, 007 Of oFolder:aDialogs[1] Pixel
		@ 041, 040 MsGet _oProgCham Var cProgCham Size 060, 010 When nOpcao<>5.and.nOpcao<>2 Of oFolder:aDialogs[1] Pixel
		If	( Empty(dDtFecha) )
			@ 095, 005 Say OemToAnsi('Dias em atraso:') Size 040, 007 Of oFolder:aDialogs[1] Pixel
			@ 095, 055 Say TransForm(dDataBase-dDtAbert,'@R 9999') Size 060, 010 Of oFolder:aDialogs[1] Pixel
		EndIf
		_oModulo:lVisible := .f.
		_oModCham:lVisible := .f.
		_oPrograma:lVisible := .f.
		_oProgCham:lVisible := .f.

		//��������Ŀ
		//�Abertura�
		//����������
		@ 005, 005 Say OemToAnsi('Data/Hora:') Size 025, 007 Of oFolder:aDialogs[2] Pixel
		@ 005, 040 MsGet dDtAbert Size 035, 010 When .f. Of oFolder:aDialogs[2] Pixel
		@ 005, 080 MsGet dHrAbert Size 035, 010 When .f. Of oFolder:aDialogs[2] Pixel
		@ 017, 005 Say OemToAnsi('Solicitante:') Size 025, 007 Of oFolder:aDialogs[2] Pixel
		@ 017, 040 MsGet cSolCham Size 035, 010 F3 'USR' Valid xValid(3) When lEdite .and. nOpcao<>5.and.nOpcao<>2 Of oFolder:aDialogs[2] Pixel
		@ 017, 083 Say _oSolCham Var _cSolCham Font oFontWin Of oFolder:aDialogs[2] Pixel
		xValid(3) // Atualiza os Solicitantes
		@ 029, 005 Say OemToAnsi('Empresa:') Size 025, 007 Of oFolder:aDialogs[2] Pixel
		@ 029, 040 MsGet cEmpCham Size 035, 010 When .f. Of oFolder:aDialogs[2] Pixel
		@ 029, 083 Say _oEmpCham Var _cEmpCham Font oFontWin Of oFolder:aDialogs[2] Pixel
		xValid(4) // Atualiza a empresa/filial
		@ 041, 005 Say OemToAnsi('Ocorr�ncia:') Size 028, 007 Of oFolder:aDialogs[2] Pixel
		@ 041, 040 Get oAberOcor Var mAberOcor Memo When nOpcao<>5.and.nOpcao<>2 Size 200, 112 Of oFolder:aDialogs[2] Pixel
		oAberOcor:oFont:=oFontMemo
		
		//�����������Ŀ
		//�Comentarios�
		//�������������
		If	( nOpcao == 2 ) .or. ( nOpcao == 4 ) .or. ( nOpcao == 5 ) .or. ( nOpcao == 6 )
			@ 005, 005 Say OemToAnsi('T�c.Alocado:') Size 030, 007 Of oFolder:aDialogs[3] Pixel
			@ 005, 040 MsGet cTecAloc Size 035, 010 F3 'USR' Valid xValid(5) When lEdite .and. nOpcao<>5.and.nOpcao<>2 Of oFolder:aDialogs[3] Pixel
			@ 005, 083 Say _oTecAloc Var _cTecAloc Font oFontWin Of oFolder:aDialogs[3] Pixel
			If	( nOpcao <> 2 ) .and. ( nOpcao <> 5 )
				xValid(5) // Atualiza o Alocado
			EndIf	
			@ 017, 005 Say OemToAnsi('Coment�rios:') Size 030, 007 Of oFolder:aDialogs[3] Pixel
			@ 017, 040 Get oComentar Var mComentar Memo When nOpcao<>5.and.nOpcao<>2 Size 200, 132 Of oFolder:aDialogs[3] Pixel
			oComentar:oFont:=oFontMemo
		EndIf

		//������������Ŀ
		//�Encerramento�
		//��������������
		If	( nOpcao == 2 ) .or. ( nOpcao == 5 ) .or. ( nOpcao == 6 )
			@ 005, 005 Say OemToAnsi('Data/Hora:') Size 025, 007 Of oFolder:aDialogs[4] Pixel
			@ 005, 040 MsGet dDtFecha Size 035, 010 When .f. Of oFolder:aDialogs[4] Pixel
			@ 005, 080 MsGet dHrFecha Size 035, 010 When .f. Of oFolder:aDialogs[4] Pixel
			@ 017, 005 Say OemToAnsi('T�cnico:') Size 025, 007 Of oFolder:aDialogs[4] Pixel
			@ 017, 040 MsGet cTecCham Size 035, 010 F3 'USR' Valid xValid(6) When lEdite .and. nOpcao<>5.and.nOpcao<>2 Of oFolder:aDialogs[4] Pixel
			@ 017, 083 Say _oTecCham Var _cTecCham Font oFontWin Of oFolder:aDialogs[4] Pixel
			xValid(6) // Atualiza o Tecnico
			@ 029, 005 Say OemToAnsi('Classif.') Size 025, 007 Of oFolder:aDialogs[4] Pixel
			@ 029, 040 MsGet cClasFech Size 035, 010 F3 'ZQ ' Valid xValid(7) When nOpcao<>5.and.nOpcao<>2 Of oFolder:aDialogs[4] Pixel
			@ 029, 083 Say _oClasFech Var _cClasFech Font oFontWin Of oFolder:aDialogs[4] Pixel
			@ 041, 005 Say OemToAnsi('Solu��o:') Size 028, 007 Of oFolder:aDialogs[4] Pixel
			@ 041, 040 Get oSoluOcor Var mSoluOcor Memo When nOpcao<>5.and.nOpcao<>2 Size 200, 100 Of oFolder:aDialogs[4] Pixel
			oSoluOcor:oFont:=oFontMemo
			@ 145, 005 Say OemToAnsi('Env. Resp.:') Size 030, 007 Of oFolder:aDialogs[4] Pixel
			@ 145, 040 Radio oRadio Var nRadio When lEdite.and.nOpcao<>5.and.nOpcao<>2 Size 090,007 Of oFolder:aDialogs[4] Pixel Prompt OemToAnsi('N�o enviar'),OemToAnsi('CIC (Comunicador Intrachat)'),OemToAnsi('E-Mail do Solicitante')
		EndIf

		If	( nOpcao <> 3 )
			xValid(1)
			xValid(2)
			If	( nOpcao == 2 ) .or. ( nOpcao == 5 ) .or. ( nOpcao == 6 )
				xValid(7)
			EndIf
		EndIf
		ACTIVATE MSDIALOG oWindow CENTERED ON INIT EnchoiceBar(oWindow,&(bOk),&(bCancel),,aButtons)

		//�������������������������������������������Ŀ
		//�Executa o processo de gravacao dos dados. !�
		//���������������������������������������������
		If	( lSave )
			//�����������������Ŀ
			//�Salva os dados...�
			//�������������������
			If	( nOpcao <> 2 )
				MsgRun(OemToAnsi('Gerando o Chamado.... Aguarde....'),'',{|| CursorWait(), xGravaDados() ,CursorArrow()})
			EndIf
			//������������������������������������Ŀ
			//�Envia as mensagens de "ENCERRAMENTO"�
			//��������������������������������������
			If	( nOpcao == 6 ) // ENCERRAR
				If	( nRadio == 2 ) // CIC
					_cMsgCic += Chr(10)+Chr(13)
					_cMsgCic += 'O Chamado ' + cNumCham 
					_cMsgCic += Chr(10)+Chr(13)+Chr(10)+Chr(13)
					_cMsgCic += AllTrim(cDesCham)
					_cMsgCic += Chr(10)+Chr(13)
					_cMsgCic += 'Foi Encerrado...'+Chr(10)+Chr(13)
					_cMsgCic += AllTrim(Substr(mSoluOcor,1,300)) + '...'
					U_SENDCIC(AllTrim(Upper(UsrRetName(cSolCham))),OemToAnsi(_cMsgCic))
				ElseIf	( nRadio == 3 ) // E-MAIL
					WfAvisaCham(UsrRetMail(cSolCham))
				EndIf
			EndIf
		Else
			If	( nOpcao == 3 )
				RollBackSx8()
			EndIf
		EndIf

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � CHAMCan  �Autor �Luis Henrique Robusto� Data �  09/02/05   ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao para cancelar o chamado.                            ���
�������������������������������������������������������������������������͹��
���Uso       � Funcao Principal                                           ���
�������������������������������������������������������������������������͹��
���DATA      � ANALISTA � MOTIVO                                          ���
�������������������������������������������������������������������������͹��
���          �          �                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function CHAMCan()

	If	( SZC->ZC_STATUS == '0' )
		If	MsgYesNo(OemToAnsi('Deseja cancelar realmente este chamado ?'))
			If	RecLock('SZC',.F.)
				Replace SZC->ZC_STATUS	With '8'
				MsUnLock()
			Else
				Help('',1,'REGNOIS')
			EndIf
		EndIf
	Else
		Help('',1,'CHAMUS',,OemToAnsi('Este chamado n�o pode ser cancelado.'),1)
	EndIf

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �xGravaDados�Autor�Luis Henrique Robusto� Data �  07/02/05   ���
�������������������������������������������������������������������������͹��
���Desc.     � Valida os dados digitados...                               ���
�������������������������������������������������������������������������͹��
���Uso       � Funcao Principal                                           ���
�������������������������������������������������������������������������͹��
���DATA      � ANALISTA �  MOTIVO                                         ���
�������������������������������������������������������������������������͹��
���          �          �                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function xGravaDados()

	If	RecLock('SZC',Iif(nOpcao==3,.t.,.f.))
		If	( nOpcao == 5 )
			DbDelete()
		Else
			Replace SZC->ZC_NUMCHAM		With cNumCham
			Replace SZC->ZC_EMPCHAM		With cEmpCham
			Replace SZC->ZC_SOLCHAM		With cSolCham
			Replace SZC->ZC_PRICHAM		With cPriCham
			Replace SZC->ZC_DESC		With cDesCham
			Replace SZC->ZC_TIPO		With cTipCham
			If	( AllTrim(cTipCham) == '001' )
				Replace SZC->ZC_MODULO	With cModCham
				Replace SZC->ZC_PROGRAM	With cProgCham
			Else
				Replace SZC->ZC_MODULO	With Space(3)
				Replace SZC->ZC_PROGRAM	With Space(15)
			EndIf
			Replace SZC->ZC_DTABERT		With dDtAbert
			Replace SZC->ZC_HRABERT		With dHrAbert
			Replace SZC->ZC_OCORREN		With mAberOcor
			Replace SZC->ZC_TECALOC		With cTecAloc
			If	( Empty(cTecAloc) ) .and. ( ! Empty(cTecCham) )
				Replace SZC->ZC_TECALOC	With cTecCham
			EndIf
			Replace SZC->ZC_COMENTA		With mComentar
			Replace SZC->ZC_DTFECHA		With dDtFecha
			Replace SZC->ZC_HRFECHA		With dHrFecha
			Replace SZC->ZC_TECNICO		With cTecCham
			Replace SZC->ZC_CLASSIF		With cClasFech
			Replace SZC->ZC_SOLUCAO		With mSoluOcor
			If	( ! Empty(cTecCham) ) // Encerrado
				Replace SZC->ZC_STATUS		With '9'
			ElseIf	( ! Empty(cTecAloc) ) // Em analise
				Replace SZC->ZC_STATUS		With '1'
			ElseIf	( Empty(cTecCham) .and. Empty(cTecAloc) )
				Replace SZC->ZC_STATUS		With '0'
			EndIf
		EndIf
		MsUnLock()
	Else
		Help('',1,'REGNOIS')
	EndIf
	
	If	( nOpcao == 3 )
		ConfirmSx8Num('SZC')
	EndIf

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � xValid() �Autor �Luis Henrique Robusto� Data �  07/02/05   ���
�������������������������������������������������������������������������͹��
���Desc.     � Valida os dados digitados...                               ���
�������������������������������������������������������������������������͹��
���Uso       � Funcao Principal                                           ���
�������������������������������������������������������������������������͹��
���DATA      � ANALISTA �  MOTIVO                                         ���
�������������������������������������������������������������������������͹��
���          �          �                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function xValid( nType )
Local	lReturn	:= .f.

		Do Case
		Case	( nType == 1 ) // Tipo
			If	( ! Empty(cTipCham) )
				If	ExistCpo('SX5','ZO'+cTipCham)
					lReturn := .t.
					_cTipCham := Tabela('ZO',cTipCham)
					_oTipCham:Refresh()
				EndIf
				If	( AllTrim(cTipCham) == '001' )
					cModCham:= cModulo
					_oModulo:lVisible := .t.
					_oModCham:lVisible := .t.
					_oPrograma:lVisible := .t.
					_oProgCham:lVisible := .t.
				Else
					_oModulo:lVisible := .f.
					_oModCham:lVisible := .f.
					_oPrograma:lVisible := .f.
					_oProgCham:lVisible := .f.
				EndIf
			EndIf
		Case	( nType == 2 ) // Prioridade
			If	( ! Empty(cPriCham) )
				If	ExistCpo('SX5','ZP'+cPriCham)
					lReturn := .t.
					_cPriCham := Tabela('ZP',cPriCham)
					_oPriCham:Refresh()
				EndIf
			EndIf
		Case	( nType == 3 ) // Solicitante
			If	UsrExist(cSolCham)
				lReturn := .t.
				_cSolCham := Upper(UsrFullName(cSolCham))
				_oSolCham:Refresh()
			EndIf
		Case	( nType == 4 ) // Empresa
			nRegSM0   := SM0->(Recno())
			DbSelectArea('SM0')
			SM0->(DbGoTop())
			While 	SM0->( ! Eof() )
					If	( SubStr(cEmpCham,1,2) == AllTrim(SM0->M0_CODIGO) ) .and. ( SubStr(cEmpCham,4,2) == AllTrim(SM0->M0_CODFIL) )
						_cEmpCham := AllTrim(Upper(SM0->M0_NOME))+' ('+AllTrim(Upper(SM0->M0_FILIAL))+')'
					EndIf
				SM0->(DbSkip())	
			End
			SM0->(DbGoTo(nRegSM0))
			_oEmpCham:Refresh()
		Case	( nType == 5 ) // Tecnico Alocado
			If	( ! Empty(cTecAloc) )
				If	UsrExist(cTecAloc)
					lReturn := .t.
					_cTecAloc := Upper(UsrFullName(cTecAloc))
					_oTecAloc:Refresh()
				EndIf
			Else
				lReturn := .t.
			EndIf
		Case	( nType == 6 ) // Tecnico que solucionou
			If	( ! Empty(cTecCham) )
				If	UsrExist(cTecCham)
					lReturn := .t.
					_cMailTec := UsrRetMail(cTecCham)
					_cTecCham := Upper(UsrFullName(cTecCham))
					_oTecCham:Refresh()
				EndIf
			Else
				lReturn := .t.
			EndIf
		Case	( nType == 7 ) // Classificacao
			If	( ! Empty(cClasFech) )
				If	ExistCpo('SX5','ZQ'+cClasFech)
					lReturn := .t.
					_cClasFech := Tabela('ZQ',cClasFech)
					_oClasFech:Refresh()
				EndIf
			EndIf
		End Case

Return lReturn

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � CHAMLeng �Autor �Luis Henrique Robusto� Data �  07/02/04   ���
�������������������������������������������������������������������������͹��
���Desc.     � Lengenda da rotina..                                       ���
�������������������������������������������������������������������������͹��
���Uso       � Funcao Principal                                           ���
�������������������������������������������������������������������������͹��
���DATA      � ANALISTA �  MOTIVO                                         ���
�������������������������������������������������������������������������͹��
���          �          �                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function CHAMLeng()
Local	aLegenda  := {	{'ENABLE'		,'Aberto'},;
						{'BR_AMARELO'	,'Em An�lise'},;
						{'BR_PRETO'	    ,'Cancelado'},;
						{'DISABLE'		,'Encerrado'}	}

		BrwLegenda(cCadastro,'Legenda',aLegenda)

Return .T.

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �WfAvisaCham�Autor �Luis Henrique Robusto�Data �  09/02/05   ���
�������������������������������������������������������������������������͹��
���Desc.     � ENVIO DE E-MAILs de resposta.                              ���
���          � Esta funcao envia um e-mail para o usuario que solicitou.  ���
�������������������������������������������������������������������������͹��
���Uso       � Funcao Principal                                           ���
�������������������������������������������������������������������������͹��
���DATA      � ANALISTA  �  MOTIVO                                        ���
�������������������������������������������������������������������������͹��
���          �           �                                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function WfAvisaCham( cTo )
Local	_cSmtpSrv 	:= AllTrim(GetMv('MV_WFSMTPS')),;
		_cAccount 	:= AllTrim(GetMv('MV_WFCONTA')),;
		_cPassSmtp	:= AllTrim(GetMv('MV_WFSENHA')),;
		_cSmtpError	:= '',;
		_lOk		:= .f.,;
		_cTitulo 	:= OemToAnsi('[GRUPO SHANGRI-L�] CHAMADO: '+cNumCham),;
		_cTo		:= cTo,;
		_cFrom		:= _cMailTec,;
		_cMensagem	:= '',;
		_lReturn	:= .f.

		//�������������������������������������Ŀ
		//�Monta a mensagem no corpo do e-mail..�
		//���������������������������������������
		_cMensagem	+= CHR_CENTER_OPEN + CHR_CENTER_CLOSE + CHR_LINE + CHR_ENTER
		_cMensagem	+= CHR_FONT_DET_OPEN
		_cMensagem	+= OemToAnsi('Chamado: ') + cNumCham + CHR_ENTER + CHR_ENTER
		_cMensagem	+= OemToAnsi('Foi Encerrado.... ') + CHR_ENTER + CHR_ENTER
		_cMensagem	+= OemToAnsi('Solu��o: ') + mSoluOcor + CHR_ENTER + CHR_ENTER
		_cMensagem	+= OemToAnsi('T�cnico: ') + _cTecCham + CHR_ENTER + CHR_ENTER
		_cMensagem	+= CHR_LINE + CHR_ENTER + CHR_NEGRITO
		_cMensagem	+= OemToAnsi('Grupo Shangri-l�') + CHR_NOTNEGRITO + CHR_ENTER
		_cMensagem	+= CHR_NEGRITO + OemToAnsi('Centro de Processamento de dados') + CHR_ENTER + CHR_NOTNEGRITO
		_cMensagem	+= CHR_ENTER + CHR_LINE
		_cMensagem	+= CHR_FONT_DET_CLOSE

		//�����������������������������Ŀ
		//�Conectando com o Servidor. !!�
		//�������������������������������
		CONNECT SMTP SERVER _cSmtpSrv ACCOUNT _cAccount PASSWORD _cPassSmtp RESULT _lOk
		ConOut('Conectando com o Servidor SMTP')

		//���������������������������������������������������������������������������������Ŀ
		//�Caso a conexao for esbelecida com sucesso, inicia o processo de envio do e-mail..�
		//�����������������������������������������������������������������������������������
		If	( _lOk )
			ConOut('Enviando o e-mail')
			SEND MAIL FROM _cFrom TO _cTo SUBJECT _cTitulo BODY _cMensagem RESULT _lOk
			ConOut('De........: ' + _cFrom)
			ConOut('Para......: ' + _cTo)
			ConOut('Assunto...: ' + _cTitulo)
			ConOut('Status....: Enviado com Sucesso')
			If	( ! _lOk )
				GET MAIL ERROR _cSmtpError
				ConOut(_cSmtpError)
				_lReturn := .f.
			EndIf
			DISCONNECT SMTP SERVER
			ConOut('Desconectando do Servidor')
			_lReturn := .t.
		Else
			GET MAIL ERROR _cSmtpError
			ConOut(_cSmtpError)
			_lReturn := .f.
		EndIf

Return _lReturn

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �xPrintCham�Autor �Luis Henrique Robusto� Data �  11/02/05   ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao para imprimir o chamado.                            ���
�������������������������������������������������������������������������͹��
���Uso       � Funcao Principal                                           ���
�������������������������������������������������������������������������͹��
���DATA      � ANALISTA �  MOTIVO                                         ���
�������������������������������������������������������������������������͹��
���          �          �                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function CHAMPRINT()
Private	cStartPath	:= GetSrvProfString('Startpath',''),;
		cFileLogo	:= cStartPath + 'shan.bmp'
//;;#		cFileLogo	:= cStartPath + 'logorech_' + AllTrim(cEmpAnt) + '.bmp'

Private	oPrint		:= TMSPrinter():New(OemToAnsi('Controle de Chamado')),;
		oBrush		:= TBrush():New(,4),;
		oFont07		:= TFont():New('Courier New',07,07,,.F.,,,,.T.,.F.),;
		oFont08		:= TFont():New('Courier New',08,08,,.F.,,,,.T.,.F.),;
		oFont08n	:= TFont():New('Courier New',08,08,,.T.,,,,.T.,.F.),;
		oFont10Co   := TFont():New('Courier New',10,10,,.F.,,,,.T.,.F.),;
		oFont09		:= TFont():New('Tahoma',09,09,,.F.,,,,.T.,.F.),;
		oFont10		:= TFont():New('Tahoma',10,10,,.F.,,,,.T.,.F.),;
		oFont10n	:= TFont():New('Courier New',10,10,,.T.,,,,.T.,.F.),;
		oFont11		:= TFont():New('Tahoma',11,11,,.F.,,,,.T.,.F.),;
		oFont12		:= TFont():New('Tahoma',12,12,,.T.,,,,.T.,.F.),;
		oFont14		:= TFont():New('Tahoma',14,14,,.T.,,,,.T.,.F.),;
		oFont14s	:= TFont():New('Arial',14,14,,.T.,,,,.T.,.T.),;
		oFont15		:= TFont():New('Courier New',15,15,,.T.,,,,.T.,.F.),;
		oFont18		:= TFont():New('Arial',18,18,,.T.,,,,.T.,.T.),;
		oFont18n	:= TFont():New('Arial',18,18,,.T.,,,,.T.,.F.),;
		oFont16		:= TFont():New('Arial',16,16,,.T.,,,,.T.,.F.),;
		oFont22		:= TFont():New('Arial',22,22,,.T.,,,,.T.,.F.)

Private	aAberOcor	:= {},;
		aComentar	:= {},;
		aSolucao	:= {}

Private	nLin		:= 30	// Linha que o sistema esta imprimindo.
		nPage		:= 0

		//������������������������Ŀ
		//�Monta os dados em array.�
		//��������������������������
		For i:=1 To MlCount(SZC->ZC_OCORREN,56)
			If	! Empty(AllTrim(MemoLine(SZC->ZC_OCORREN,56,i)))
				aAdd(aAberOcor,AllTrim(MemoLine(SZC->ZC_OCORREN,56,i)))
			EndIf
		Next
		For i:=1 To MlCount(SZC->ZC_COMENTA,56)
			If	! Empty(AllTrim(MemoLine(SZC->ZC_COMENTA,56,i)))
				aAdd(aComentar,AllTrim(MemoLine(SZC->ZC_COMENTA,56,i)))
			EndIf
		Next
		For i:=1 To MlCount(SZC->ZC_SOLUCAO,56)
			If	! Empty(AllTrim(MemoLine(SZC->ZC_SOLUCAO,56,i)))
				aAdd(aSolucao,AllTrim(MemoLine(SZC->ZC_SOLUCAO,56,i)))
			EndIf
		Next

		//����������������������������������������Ŀ
		//�Seta a pagina para impressao em Retrato.�
		//������������������������������������������
		oPrint:SetPortrait()

		xCabecPrint()

		//��������������������������������������������
		//�IMPRIME A PARTE DE INFORMACOES DO CHAMADO.�
		//��������������������������������������������
		oPrint:Say(nLin,0050,OemToAnsi('N�mero Chamado: '),oFont08n)
		oPrint:Say(nLin,0350,OemToAnsi('Descri��o: '),oFont08n)
		oPrint:Say(nLin,1600,OemToAnsi('Dt. Abertura: '),oFont08n)
		oPrint:Say(nLin,2000,OemToAnsi('Empresa/Filial: '),oFont08n)
		nLin += 40
		oPrint:Say(nLin,0050,SZC->ZC_NUMCHAM,oFont10Co)
		oPrint:Say(nLin,0350,SubStr(SZC->ZC_DESC,1,50),oFont10Co)
		oPrint:Say(nLin,1600,DtoC(SZC->ZC_DTABERT)+'-'+SZC->ZC_HRABERT,oFont10Co)
		oPrint:Say(nLin,2000,SZC->ZC_EMPCHAM,oFont10Co)

		nLin += 60 // Espaco entre os campos

		oPrint:Say(nLin,0050,OemToAnsi('Tipo: '),oFont08n)
		oPrint:Say(nLin,1000,OemToAnsi('Prioridade: '),oFont08n)
		oPrint:Say(nLin,1600,OemToAnsi('Solicitante: '),oFont08n)
		nLin += 40
		oPrint:Say(nLin,0050,Tabela('ZO',SZC->ZC_TIPO) + ' ' + SZC->ZC_MODULO + ' ' + SZC->ZC_PROGRAM,oFont10Co)
		oPrint:Say(nLin,1000,Tabela('ZP',SZC->ZC_PRICHAM),oFont10Co)
		oPrint:Say(nLin,1600,Upper(UsrFullName(SZC->ZC_SOLCHAM)),oFont10Co)

		nLin += 60 // Espaco entre os campos

		oPrint:Say(nLin,0050,OemToAnsi('Ocorr�ncia:'),oFont08n)

		For i:=1 To Len(aAberOcor)
			nLin += 40
			If	( nLin >= 3000 )
				xCabecPrint()
			EndIf
			oPrint:Say(nLin,0050,aAberOcor[i],oFont10Co)
		Next i

		nLin += 60 // Espaco entre os campos

		If	( nLin >= 3000 )
			xCabecPrint()
		EndIf

		oPrint:Line(nLin,0050,nLin,2300) // Linha Separacao

		nLin += 30

		If	( nLin >= 3000 )
			xCabecPrint()
		EndIf

		//����������������������������������
		//�IMPRIME OS DADOS DOS COMENTARIOS�
		//����������������������������������
		If	( SZC->ZC_STATUS == '1' ) .or. ( SZC->ZC_STATUS == '8' ) .or. ( SZC->ZC_STATUS == '9' )

			oPrint:Say(nLin,0050,OemToAnsi('T�cnico Alocado:'),oFont08n)
			nLin += 40
			If	( nLin >= 3000 )
				xCabecPrint()
			EndIf

			oPrint:Say(nLin,0050,Upper(UsrFullName(SZC->ZC_TECALOC)),oFont10Co)

			nLin += 60 // Espaco entre os campos

			If	( nLin >= 3000 )
				xCabecPrint()
			EndIf

			oPrint:Say(nLin,0050,OemToAnsi('Coment�rios:'),oFont08n)

			For i:=1 To Len(aComentar)
				nLin += 40
				If	( nLin >= 3000 )
					xCabecPrint()
				EndIf
				oPrint:Say(nLin,0050,aComentar[i],oFont10Co)
			Next i

			nLin += 60 // Espaco entre os campos

			If	( nLin >= 3000 )
				xCabecPrint()
			EndIf

			oPrint:Line(nLin,0050,nLin,2300) // Linha Separacao

			nLin += 30

			If	( nLin >= 3000 )
				xCabecPrint()
			EndIf

		EndIf	

		//����������������������������������
		//�IMPRIME OS DADOS DOS COMENTARIOS�
		//����������������������������������
		If	( SZC->ZC_STATUS == '9' ) .or. ( SZC->ZC_STATUS == '8' )

			oPrint:Say(nLin,0050,OemToAnsi('T�cnico:'),oFont08n)
			oPrint:Say(nLin,1600,OemToAnsi('Dt. Encerramento: '),oFont08n)
			oPrint:Say(nLin,2000,OemToAnsi('Classifica��o: '),oFont08n)
			nLin += 40
			oPrint:Say(nLin,0050,Upper(UsrFullName(SZC->ZC_TECNICO)),oFont10Co)
			oPrint:Say(nLin,1600,DtoC(SZC->ZC_DTFECHA)+'-'+SZC->ZC_HRFECHA,oFont10Co)
			If	! Empty(SZC->ZC_CLASSIF)
				oPrint:Say(nLin,2000,Tabela('ZQ',SZC->ZC_CLASSIF),oFont10Co)
			EndIf

			nLin += 60 // Espaco entre os campos

			If	( nLin >= 3000 )
				xCabecPrint()
			EndIf

			oPrint:Say(nLin,0050,OemToAnsi('Solu��o:'),oFont08n)

			For i:=1 To Len(aSolucao)
				nLin += 40
				If	( nLin >= 3000 )
					xCabecPrint()
				EndIf
				oPrint:Say(nLin,0050,aSolucao[i],oFont10Co)
			Next i

			nLin += 60 // Espaco entre os campos

			If	( nLin >= 3000 )
				xCabecPrint()
			EndIf

			oPrint:Line(nLin,0050,nLin,2300) // Linha Separacao

		EndIf

		//������������������������������Ŀ
		//�Fina a impressao do relatorio.�
		//��������������������������������
		oPrint:EndPage()

		//�������������������������������������������Ŀ
		//�Mostra em video a impressao do relatorio. !�
		//���������������������������������������������
		oPrint:Preview()

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �xCabecPrint�Autor �Luis Henrique Robusto� Data �  11/02/05  ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao para imprimir o cabecalho do relatorio.             ���
�������������������������������������������������������������������������͹��
���Uso       � Funcao Principal                                           ���
�������������������������������������������������������������������������͹��
���DATA      � ANALISTA �  MOTIVO                                         ���
�������������������������������������������������������������������������͹��
���          �          �                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function xCabecPrint()
Local	cStatus	:= ''

		If	( SZC->ZC_STATUS == '0' )
			cStatus	:= 'Aberto'
		ElseIf	( SZC->ZC_STATUS == '1' )
			cStatus	:= 'Em An�lise'
		ElseIf	( SZC->ZC_STATUS == '8' )
			cStatus	:= 'Cancelado'
		ElseIf	( SZC->ZC_STATUS == '9' )
			cStatus	:= 'Encerrado'
		EndIf

		nLin := 30

		If	( nPage > 0 )
			oPrint:EndPage()
		EndIf
		
		nPage++

		//������������������������������Ŀ
		//�Inicia a impressao da pagina.!�
		//��������������������������������
		oPrint:StartPage()

		//���������������������������������Ŀ
		//�Imprime o cabecalho da empresa. !�
		//�����������������������������������
		oPrint:SayBitmap(nLin+20,040,cFileLogo,230,175) // 560,350)
		oPrint:Say(nLin+20,700,'GRUPO SHANGRI-L�',oFont16)
		oPrint:Say(nLin+150,700,'Centro de Processamento de Dados',oFont11)
		oPrint:Say(nLin+195,700,'Suporte on-line',oFont11)
		oPrint:Say(nLin+285,700,AllTrim('Duvidas: marcos@gruposhangrila.com.br'),oFont11)

		oPrint:Say(nLin+100,1700,'Ficha de Chamado',oFont18n)
		oPrint:Say(nLin+180,1700,SZC->ZC_NUMCHAM + ' - ' + OemToAnsi(cStatus),oFont14s)

		nLin += 450

		oPrint:Line(nLin,0050,nLin,2300) // Linha Separacao

		nLin += 30

Return

Static Function AjustaSx1(cPerg)
Local	_nx		:= 0,;
		_nh		:= 0,;
		_nlh	:= 0,;
		_aHelp	:= Array(8,1),;
		_aRegs  := {},;
		_sAlias := Alias(),;
		_aHead	:= {"SX1->X1_GRUPO","SX1->X1_ORDEM","SX1->X1_PERGUNTE","SX1->X1_PERSPA","SX1->X1_PERENG	",;
					"SX1->X1_VARIAVL","SX1->X1_TIPO","SX1->X1_TAMANHO","SX1->X1_DECIMAL","SX1->X1_PRESEL",;
					"SX1->X1_GSC","SX1->X1_VALID","SX1->X1_VAR01","SX1->X1_DEF01","SX1->X1_DEF02",;
					"SX1->X1_DEF03","SX1->X1_DEF04","SX1->X1_DEF05","SX1->X1_F3"}

		//��������������������������������������������Ŀ
		//�Cria uma array, contendo todos os valores...�
		//����������������������������������������������
		aAdd(_aRegs,{cPerg,'01',"Filtrar por ?"      ,"Filtrar por ?"      ,"Filtrar por ?"      ,'mv_ch1','N', 1,0,0,'C','','mv_par01','Pendentes','Em analise','Encerrados','Cancelados','Todos',''})
		aAdd(_aRegs,{cPerg,'02',"Prioridade ?"       ,"Prioridade ?"       ,"Prioridade ?"       ,'mv_ch2','N', 1,0,0,'C','','mv_par02','Alta','Normal','Baixa','Ambas','',''})
		aAdd(_aRegs,{cPerg,'03',"Programa Inicial? " ,"Programa Inicial? " ,"Programa Inicial? " ,'mv_ch3','C',10,0,0,'G','','mv_par03','','','','',"",""})
		aAdd(_aRegs,{cPerg,'04',"Programa Final? "   ,"Programa Final? "   ,"Programa Final? "   ,'mv_ch4','C',10,0,0,'G','','mv_par04','','','','',"",""})
		aAdd(_aRegs,{cPerg,'05',"Filtra por Tecnico?","Filtra por Tecnico?","Filtra por Tecnico?",'mv_ch5','N', 1,0,0,'C','','mv_par05','Sim','Nao','','',"",""})
		aAdd(_aRegs,{cPerg,'06',"Que contem (palavra)","Que contem (palavra)","Que contem (palavra)",'mv_ch6','C',20,0,0,'G','','mv_par06','','','','',"",""})

		DbSelectArea('SX1')
		SX1->(DbSetOrder(1))

		For _nx:=1 to Len(_aRegs)
			If	RecLock('SX1',Iif(!SX1->(DbSeek(_aRegs[_nx][01]+_aRegs[_nx][02])),.t.,.f.))
				For nlh:=1 to Len(_aHead)
					If	( nlh <> 10 )
						Replace &(_aHead[nlh]) With _aRegs[_nx][nlh]
					EndIf
				Next nlh
				MsUnlock()
			Else
				Help('',1,'REGNOIS')
			Endif
		Next _nx

		//���������������������������������������������������
		//�Monta array com o help dos campos dos parametros.�
		//���������������������������������������������������
		aAdd(_aHelp[01],OemToAnsi("Escolha os chamados que deseja visualizar: Abertos, em analise, encerrados, cancelados ou todos."))
		aAdd(_aHelp[02],OemToAnsi("De qual prioridade voc� quer visualizar?"))
		aAdd(_aHelp[03],OemToAnsi("Programa, para os chamados envolvendo Microsiga, inicial ?"))
		aAdd(_aHelp[04],OemToAnsi("Programa, para os chamados envolvendo Microsiga, final ?"))
		For _nh:=1 to Len(_aHelp)
			PutSX1Help("P."+AllTrim(cPerg)+StrZero(_nh,2)+".",_aHelp[_nh],_aHelp[_nh],_aHelp[_nh])
		Next _nh

Return Nil