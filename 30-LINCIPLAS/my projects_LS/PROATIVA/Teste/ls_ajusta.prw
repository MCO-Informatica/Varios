/*�������������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������������
�����������������������������������������������������������������������������������������������ͻ��
���Programa  � LS_AJUSTA  � Autor � Jose Renato July                          � Data � MAI/2016 ���
�����������������������������������������������������������������������������������������������͹��
���Descricao � Efetua o ajuste na base de dados, de acordo com a necessidade.                   ���
�����������������������������������������������������������������������������������������������͹��
���Uso       � Especifico para clientes TOTVS - LASEVA                                          ���
�����������������������������������������������������������������������������������������������͹��
���               ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL                              ���
�����������������������������������������������������������������������������������������������͹��
���Autor       �  Data  � Descricao da Atualizacao                                              ���
�����������������������������������������������������������������������������������������������͹��
���            �???/2016� #???AAMMDD-                                                           ���
�����������������������������������������������������������������������������������������������ͼ��
���������������������������������������������������������������������������������������������������
�������������������������������������������������������������������������������������������������*/
#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'TOPCONN.CH'
#INCLUDE 'TBICONN.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE 'FONT.CH'

//-- Variaveis para mensagens em caixas de dialogo.
#DEFINE _fTt0 'Aten��o !'
#DEFINE _fTt1 'Espec�fico TI LASELVA. ('+Lower(AllTrim(FunName()))+')'
#DEFINE _fCx0 'INFO'
#DEFINE _fCx1 'STOP'
#DEFINE _fCx2 'OK'
#DEFINE _fCx3 'ALERT'
#DEFINE _fCx4 'YESNO'
#DEFINE _fCx5 'NOYES'

#DEFINE TAMPSW 20

User Function LS_AJUSTA()

//-- Define Variaveis.
Local nOpca 		:= 0, oDlg
Local aSays			:= {} , aButtons := {}
Local cMens			:= ''

cCadastro 	:= OemtoAnsi('Movimentos das De loja')

#IFDEF TOP
	TCInternal(5,'*OFF')   //-- Desliga Refresh no Lock do Top
#ENDIF

//-- Declara��o de Variaveis Private dos Objetos.
Private oFont15		:= TFont():New('Arial',,15,,.T.,,,,.T.,.F.)
Private oFont16		:= TFont():New('Arial',,16,,.T.,,,,.T.,.F.)

Private cMsg001		:= PadC(OemToAnsi('P R O C E S S A M E N T O     D E     A J U S T E S'),100)
Private cMsg002		:= OemToAnsi('Executa os ajustes na base de dados devido a n�o conformidade existente ')
Private cMsg003		:= OemToAnsi('na integracao do Front Loja e a retaguardo do Protheus.                 ')
Private _lOk 		:= .T.
Private oDlg

aMotivo		:= {'1=Ajusta 001','2=Ajusta 002','3=Ajusta 003','4=Ajusta 004','5=Ajusta 005'}
nMotivo		:= '1'

//�����������������������������������������������������������������������������������������������Ŀ
//� Interface para a comunicacao com o usuario.                                                   �
//�������������������������������������������������������������������������������������������������
Define FONT oFnt NAME 'Arial' Size C(012),C(014) BOLD
Define msDialog oDlg From C(015),C(006) To C(220),C(400) Title cCadastro Pixel

@ C(002),C(002) To C(034),C(196) 																					Pixel Of oDlg

@ C(005),C(005) Say cMsg001										Size C(190),C(010) COLOR CLR_HRED  Font oFont15		Pixel Of oDlg
@ C(015),C(005) Say cMsg002										Size C(190),C(010) COLOR CLR_BLACK Font oFont15		Pixel Of oDlg
@ C(025),C(005) Say cMsg003										Size C(190),C(010) COLOR CLR_BLACK Font oFont15		Pixel Of oDlg

@ C(036),C(002) To C(085),C(196) 																					Pixel Of oDlg
@ C(041),C(020) Say 'Sele��o: '									Size C(090),C(010) COLOR CLR_BLUE  Font oFont16		Pixel Of oDlg
@ C(040),C(060) msComboBox oCombo Var nMotivo Items aMotivo 	Size C(090),C(010) COLOR CLR_HBLUE Font oFont16		Pixel Of oDlg

Define sButton From C(090),C(050) Type 1 Enable Of oDlg Action (_lOk := .T.,oDlg:End())
Define sButton From C(090),C(120) Type 2 Enable Of oDlg Action (_lOk := .F.,oDlg:End())

Activate msDialog oDlg Centered

//-- Executa a selecao efetuada.
If _lOk
	Do Case
	Case nMotivo = '1'							// .
		IMP_LS_X()		// IMP_LS_1()
	Case nMotivo = '2'							// .
		IMP_LS_X()		// IMP_LS_2()
	Case nMotivo = '3'							// .
		IMP_LS_X()		// IMP_LS_3()
	Case nMotivo = '4'							// .
		IMP_LS_X()		// IMP_LS_4()
	Case nMotivo = '5'							// .
		IMP_LS_X()		// IMP_LS_5()
	OtherWise
		msgAlert('Op��o inv�lida.')
	EndCase
EndIf

Return()
/*�������������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������������
�����������������������������������������������������������������������������������������������ͻ��
���Funcao    � IMP_LS_X   � Autor � Jose Renato July                          � Data � MAI/2016 ���
�����������������������������������������������������������������������������������������������͹��
���Descricao � Atualizacao do status da geracao da gia no cabecaljho da nota fiscal.            ���
�����������������������������������������������������������������������������������������������ͼ��
���������������������������������������������������������������������������������������������������
�������������������������������������������������������������������������������������������������*/
Static Function IMP_LS_X()

_fMg0 	:= OemToAnsi('Em desenvolvimento !') 								+ CRLF
_fMg0 	+= OemToAnsi('Aguarde a libera��o pelo administrador do sistema !')	+ CRLF
_fMg0 	+= OemToAnsi('Informe: [ LS_AJUSTA ]')
Aviso(OemToAnsi(_fTt1),_fMg0,{'Ok'})

Return()
/*�������������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������������
�����������������������������������������������������������������������������������������������ͻ��
���Funcao    � IMP_LS_1   � Autor � Jose Renato July                          � Data � MAI/2016 ���
�����������������������������������������������������������������������������������������������͹��
���Descricao � Atualizacao do status da geracao da gia no cabecaljho da nota fiscal.            ���
�����������������������������������������������������������������������������������������������ͼ��
���������������������������������������������������������������������������������������������������
�������������������������������������������������������������������������������������������������*/
Static Function IMP_LS_1()

Do While .T.

	//-- Definicao de variaveis.
	Private oFont15		:= TFont():New('Arial',,15,,.T.,,,,.T.,.T.)
	Private oFont15B 	:= TFont():New('Arial',,15,,.T.,,,,.T.,.F.)
	Private oFont17B 	:= TFont():New('Arial',,17,,.T.,,,,.T.,.F.)
	Private oFont18B 	:= TFont():New('Arial',,17,,.T.,,,,.T.,.F.)

	Private ocFilial
	Private oNFiscal
	Private oNomeCli
	Private oValDifa
	Private oStsDifa
	Private oStsAler
	Private oValTota
	Private oStsEsta
	Private oCodBarr

	Private _cFilial 	:= Space(TamSX3('F2_FILIAL')[1])
	Private cNFiscal 	:= Space(TamSX3('F2_DOC')[1])

	cNomeCli 			:= Space(TamSX3('A1_NOME')[1])
	nValDifa			:= 0
	nValTota			:= 0
	cStsDifa			:= ''
	cStsEsta			:= ''
	_cSerie				:= '2'
	_cSerie				:= PadR(_cSerie,TamSx3('F2_SERIE')[1])
	cStsAler			:= ''
	cCodBarr			:= Space(TamSX3('E2_CODBAR')[1])
	_cEstCodbr			:= '|BA|DF|ES|MA|PA|RJ|SP|'

	//�����������������������������������������������������������������������������������������������Ŀ
	//� Interface para a comunicacao com o usuario.                                                   �
	//�������������������������������������������������������������������������������������������������
	Define FONT oFnt NAME 'Arial' Size C(012),C(014) BOLD
	Define msDialog oDlg1 Title cCadastro From C(015),C(006) To C(250),C(400) Pixel

	@ C(001),C(001) TO C(080),C(197)
	@ C(081),C(001) TO C(100),C(197)
	@ C(101),C(001) TO C(118),C(197)

	@ C(006),C(005) Say 'Filial:'						Size C(050),C(008) COLOR CLR_BLACK 	Font oFont15 	Pixel Of oDlg1
	@ C(021),C(005) Say 'Nota fiscal:'					Size C(050),C(008) COLOR CLR_BLACK 	Font oFont15 	Pixel Of oDlg1
	@ C(036),C(005) Say 'Cliente:'						Size C(050),C(008) COLOR CLR_BLACK 	Font oFont15 	Pixel Of oDlg1
	@ C(051),C(005) Say 'Valor Total: '					Size C(050),C(008) COLOR CLR_BLACK 	Font oFont15 	Pixel Of oDlg1
	@ C(066),C(005) Say 'Valor Difaul: '				Size C(050),C(008) COLOR CLR_BLACK 	Font oFont15 	Pixel Of oDlg1
	@ C(087),C(005) Say 'C�digo Barras:'				Size C(050),C(008) COLOR CLR_BLACK 	Font oFont15 	Pixel Of oDlg1

	@ C(005),C(040) MsGet ocFilial		Var _cFilial 	Size C(070),C(008) COLOR CLR_HBLUE	Font oFont15B 	Pixel Of oDlg1 	Picture '@!'
	@ C(006),C(130) Say   oStsAler 		Var cStsAler 	Size C(080),C(008) COLOR CLR_HRED 	Font oFont18B 	Pixel Of oDlg1 	Picture '@!'
	@ C(020),C(040) MsGet oNFiscal		Var cNFiscal 	Size C(070),C(008) COLOR CLR_HBLUE	Font oFont15B 	Pixel Of oDlg1 	Picture '@!'	Valid GNRE_001(_cFilial,cNFiscal,_cSerie)
	@ C(020),C(130) Say   oStsEsta 		Var cStsEsta 	Size C(080),C(008) COLOR CLR_GREEN 	Font oFont18B 	Pixel Of oDlg1 	Picture '@!'
	@ C(035),C(040) Say   oNomeCli		Var cNomeCli 	Size C(130),C(008) COLOR CLR_BLACK 	Font oFont15B 	Pixel Of oDlg1 	Picture '@!'
	@ C(050),C(040) Say   oValTota 		Var nValTota 	Size C(030),C(008) COLOR CLR_BLACK 	Font oFont15B 	Pixel Of oDlg1 	Picture PesqPict('SD2','D2_TOTAL')
	@ C(065),C(040) Say   oValDifa 		Var nValDifa 	Size C(030),C(008) COLOR CLR_BLACK 	Font oFont15B 	Pixel Of oDlg1 	Picture PesqPict('SD2','D2_DIFAL')
	@ C(065),C(100) Say   oStsDifa 		Var cStsDifa 	Size C(080),C(008) COLOR CLR_HRED 	Font oFont17B 	Pixel Of oDlg1 	Picture '@!'
	@ C(086),C(040) MsGet oCodBarr 		Var cCodBarr 	Size C(130),C(008) COLOR CLR_HRED 	Font oFont17B 	Pixel Of oDlg1 	Picture PesqPict('SE2','E2_CODBAR') Valid GNRE_005()

	Define sButton From C(106),C(050) Type 1 Enable Of oDlg1 Action (_lOk := .T.,oDlg1:End())
	Define sButton From C(106),C(120) Type 2 Enable Of oDlg1 Action (_lOk := .F.,oDlg1:End())

	Activate msDialog oDlg1 Centered

	If _lOk .And. nValDifa > 0

		If !Empty(cCodBarr) .And. cStsEsta $ _cEstCodbr

			cFilNota	:= _cFilial
			cNumNota	:= cNFiscal	
			cObs		:= 'CodBar: ' + cCodBarr + CRLF			// Codigo de barras
			cCodDig		:= 'GNRE gerada manualmente: [ ' + cStsEsta + ' ].'
			cCodBar		:= cCodBarr
			cFornLoj	:= AllTrim(GetMV('MV_RECST'+cStsEsta))
			dDtVenc		:= dDataBase
			nValor		:= nValDifa

			//�����������������������������������������������������������������������������������������������Ŀ
			//� Geracao do registro no contas a pagar - Funcao encontrada no fonte GIABAIXA.                  �
			//�������������������������������������������������������������������������������������������������
			Processa({|| U_GIA_BXA3() },'Gerando registro no contas a pagar...')

		EndIf

		//�����������������������������������������������������������������������������������������������Ŀ
		//� Atualiza o status no SF2                                                                      �
		//�������������������������������������������������������������������������������������������������
		//-- 1=GNRE gerada, 2=GIA Cta Pagar, 3=Gia Confirmada, 4=GIA Bordero e 5=Gia Paga
		_cOrigem	:= '3'
		U_GNRE_003(_cOrigem,_cFilial,cNFiscal,_cSerie)

	EndIf

	_fMg0 := OemToAnsi('Continua com o atualiza��o das GIAs ?')
	If MsgBox(_fMg0,_fTt1,_fCx4) == .F.
		Exit
	EndIf

EndDo

Return()
/*�������������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������������
�����������������������������������������������������������������������������������������������ͻ��
���Static    � GNRE_001   � Autor � Jose Renato July                          � Data � MAI/2016 ���
�����������������������������������������������������������������������������������������������͹��
���Descricao � Validacao da nota fiscal selecionada.                                            ���
�����������������������������������������������������������������������������������������������ͼ��
���������������������������������������������������������������������������������������������������
�������������������������������������������������������������������������������������������������*/
Static Function GNRE_001(_cFilial,cNFiscal,_cSerie)

//�����������������������������������������������������������������������������������������������Ŀ
//� Variaveis utilizadas na funcao.                                                               �
//�������������������������������������������������������������������������������������������������
Private _lRet		:= .T.

If !Empty(cNFiscal)

	//-- Verifica o status da nota fiscal.
	dbSelectArea('SF2')
	dbSetOrder(1)
	If SF2->(dbSeek(_cFilial+cNFiscal+_cSerie))
		cStsEsta	:= SF2->F2_EST
		cNFiscal 	:= SF2->F2_DOC
		cNomeCli 	:= Posicione('SA1',1,xFilial('SA1')+SF2->(F2_CLIENTE+F2_LOJA),'A1_NOME')

		DlgRefresh(cNomeCli)
		DlgRefresh(cStsAler)
		DlgRefresh(cStsEsta)

		//-- Efetuao a soma do difal e do total os itens da NF
		GNRE_002(_cFilial,cNFiscal,_cSerie)

	Else
		_cFilial 	:= Space(TamSX3('F2_FILIAL')[1])
		cNFiscal 	:= Space(TamSX3('F2_DOC')[1])
		cNomeCli 	:= Space(TamSX3('A1_NOME')[1])
		nValTota	:= 0
		nValDifa	:= 0

		_fMg0 	:= OemToAnsi('Nota fiscal N�O cadastrada.') 	+ CRLF + CRLF
		_fMg0 	+= OemToAnsi('Favor verificar !') 				+ CRLF
		MsgBox(_fMg0,_fTt1,_fCx3)

	EndIf

EndIf

DlgRefresh(cNomeCli)
DlgRefresh(oValDifa)
DlgRefresh(oValTota)
DlgRefresh(oStsAler)
DlgRefresh(oStsEsta)

Return(_lRet)
/*�������������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������������
�����������������������������������������������������������������������������������������������ͻ��
���Funcao    � GNRE_002   � Autor � Jose Renato July                          � Data � MAI/2016 ���
�����������������������������������������������������������������������������������������������͹��
���Descricao � Selecao da nota fiscal.                                                          ���
�����������������������������������������������������������������������������������������������ͼ��
���������������������������������������������������������������������������������������������������
�������������������������������������������������������������������������������������������������*/
Static Function GNRE_002(_cFilial,cNFiscal,_cSerie)

//�����������������������������������������������������������������������������������������������Ŀ
//� Seleciona as vendas realizadas no periodo solicitado.                                         �
//�������������������������������������������������������������������������������������������������
cQuery := " SELECT "																		+ CRLF
cQuery += " F2_FILIAL  , F2_DOC     , F2_SERIE   , F2_CLIENTE , F2_LOJA    , F2_XGIASTA , "	+ CRLF
cQuery += " SUM(F3_VALCONT) F3_VALCONT   , "												+ CRLF
cQuery += " SUM(F3_DIFAL)   F3_DIFAL     "													+ CRLF
cQuery += " FROM " + RetSqlName("SF2") + " SF2, "
cQuery += "      " + RetSqlName("SF3") + " SF3  "
cQuery += " WHERE SF2.D_E_L_E_T_  = '' "													+ CRLF
cQuery += "   AND SF3.D_E_L_E_T_  = '' "													+ CRLF
cQuery += "   AND F2_FILIAL       = '" + _cFilial + "'"										+ CRLF
cQuery += "   AND F2_DOC          = '" + cNFiscal + "'"										+ CRLF
cQuery += "   AND F2_SERIE        = '" + _cSerie  + "'"										+ CRLF
cQuery += "   AND F2_FILIAL       = F3_FILIAL "												+ CRLF
cQuery += "   AND F2_DOC          = F3_NFISCAL "											+ CRLF
cQuery += "   AND F2_SERIE        = F3_SERIE "												+ CRLF
cQuery += "   AND F2_CLIENTE      = F3_CLIEFOR "											+ CRLF
cQuery += "   AND F2_LOJA         = F3_LOJA "												+ CRLF
cQuery += " GROUP BY F2_FILIAL,F2_DOC,F2_SERIE,F2_CLIENTE,F2_LOJA,F2_XGIASTA"				+ CRLF
cQuery += " ORDER BY F2_FILIAL,F2_DOC,F2_SERIE"												+ CRLF

cQuery := ChangeQuery(cQuery)
IIf(Select('TRX')>0,TRX->(dbCloseArea()),.T.)
dbUseArea(.T.,'TOPCONN',TCGENQRY(,,cQuery),'TRX',.T.,.T. )

nValTota	:= TRX->F3_VALCONT
nValDifa	:= TRX->F3_DIFAL
cStsAler 	:= ''
cStsDifa	:= ''
_cF2XGIASTA	:= AllTrim(TRX->F2_XGIASTA)

If nValDifa	= 0
	cStsDifa	:= 'DIFAL ZERADO !'
EndIf

//-- 1=GNRE gerada, 2=GIA Cta Pagar, 3=Gia Confirmada, 4=GIA Bordero e 5=Gia Paga
Do Case
Case _cF2XGIASTA $ ' '
	cStsAler 	:= 'ATEN��O: N�O h� GNRE gerada.'
Case _cF2XGIASTA $ '1'
	cStsAler 	:= 'GNRE gerada.'
Case _cF2XGIASTA $ '2'
	cStsAler 	:= 'GIA no Cta Pagar.'
Case _cF2XGIASTA $ '3'
	cStsAler 	:= 'Gia Confirmada.'
Case _cF2XGIASTA $ '4'
	cStsAler 	:= 'GIA em Bordero.'
Case _cF2XGIASTA $ '5'
	cStsAler 	:= 'ATEN��O: Gia Paga.'
OtherWise
	//cStsAler 	:= 'Favor verificar !'
EndCase

DlgRefresh(oStsDifa)
DlgRefresh(cStsDifa)
DlgRefresh(cStsAler)
DlgRefresh(oStsAler)

Return()
/*�������������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������������
�����������������������������������������������������������������������������������������������ͻ��
���Funcao    � GNRE_003   � Autor � Jose Renato July                          � Data � MAI/2016 ���
�����������������������������������������������������������������������������������������������͹��
���Descricao � Atualizacao diversas do status da geracao da gia.                                ���
�����������������������������������������������������������������������������������������������ͼ��
���������������������������������������������������������������������������������������������������
�������������������������������������������������������������������������������������������������*/
User Function GNRE_003(_cOrigem,_cFilial,cNFiscal,_cSerie)

Default _cOrigem	:= ' '
Default _cFilial	:= Space(TamSX3('F2_FILIAL')[1])
Default cNFiscal	:= Space(TamSX3('F2_DOC')[1])
Default _cSerie		:= Space(TamSX3('F2_SERIE')[1])

cNFiscal	:= PadR(cNFiscal,TamSx3('F2_DOC')[1])
_cSerie		:= PadR(_cSerie,TamSx3('F2_SERIE')[1])

dbSelectArea('SF2')
SF2->(dbSetOrder(1))			// F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA+F2_FORMUL+F2_TIPO
If SF2->(dbSeek(_cFilial+cNFiscal+_cSerie))

	_cF2XGIASTA	:= SF2->F2_XGIASTA

	//-- 1=GNRE gerada, 2=GIA Cta Pagar, 3=Gia Confirmada, 4=GIA Bordero e 5=Gia Paga
	Do Case
	Case _cOrigem $ '|0|'			// XML a ser gerado
		_cF2XGIASTA	:= ' '
	Case _cOrigem $ '|1|'			// XML gerado
		_cF2XGIASTA	:= '1'
	Case _cOrigem $ '|2|'			// Confirmacao o recebimento do TXT
		_cF2XGIASTA	:= '2'
	Case _cOrigem $ '|3|'			// Confirmacao o recebimento do PDF
		_cF2XGIASTA	:= '3'
	Case _cOrigem $ '|4|'			// Confirmacao geracao do bordero de pagamento
		_cF2XGIASTA	:= '4'
	OtherWise						// Confirmacao o pagamento do titulo
		_cF2XGIASTA	:= '5'
	EndCase

	//-- Atualiza o status da gia.
	dbSelectArea('SF2')
	Do While !SF2->(RecLock('SF2',.F.))
	EndDo
	SF2->F2_XGIASTA		:= _cF2XGIASTA
	SF2->(dbCommit())
	SF2->(msUnLock())

EndIf

Return()
/*�������������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������������
�����������������������������������������������������������������������������������������������ͻ��
���Funcao    � IMP_LS_2   � Autor � Jose Renato July                          � Data � MAI/2016 ���
�����������������������������������������������������������������������������������������������͹��
���Descricao �                                                                                  ���
�����������������������������������������������������������������������������������������������ͼ��
���������������������������������������������������������������������������������������������������
�������������������������������������������������������������������������������������������������*/
Static Function IMP_LS_2()

//-- Definicao de variaveis.
Private oFont15		:= TFont():New('Arial',,15,,.T.,,,,.T.,.T.)
Private oFont15B 	:= TFont():New('Arial',,15,,.T.,,,,.T.,.F.)

Private ocFilial
Private oNFiscal
Private _cFilial 	:= Space(02)
Private cNFiscal 	:= Space(250)

_cSerie				:= '2'
_cSerie				:= PadR(_cSerie,TamSx3('F2_SERIE')[1])

aTipo1		:= {'1=Notas','2=Dias'}
nTipo1		:= '1'


//�����������������������������������������������������������������������������������������������Ŀ
//� Interface para a comunicacao com o usuario.                                                   �
//�������������������������������������������������������������������������������������������������
Define FONT oFnt NAME 'Arial' Size C(012),C(014) BOLD
Define msDialog oDlg1 Title cCadastro From C(015),C(006) To C(220),C(400) Pixel

@ C(001),C(001) TO C(080),C(197)
@ C(081),C(001) TO C(102),C(197)

@ C(006),C(005) Say 'Filial:'								Size C(050),C(008) COLOR CLR_BLACK 	Font oFont15 	Pixel Of oDlg1
@ C(021),C(005) Say 'Nota fiscal:'							Size C(050),C(008) COLOR CLR_BLACK 	Font oFont15 	Pixel Of oDlg1

@ C(005),C(040) MsGet ocFilial		Var _cFilial 			Size C(070),C(008) COLOR CLR_HBLUE	Font oFont15B 	Pixel Of oDlg1 	Picture '@!'
@ C(020),C(040) MsGet oNFiscal		Var cNFiscal 			Size C(150),C(008) COLOR CLR_HBLUE	Font oFont15B 	Pixel Of oDlg1 	Picture '@!'
@ C(035),C(040) msComboBox oCombo 	Var nTipo1 Items aTipo1 Size C(090),C(010) COLOR CLR_HBLUE Font oFont16		Pixel Of oDlg

Define sButton From C(086),C(050) Type 1 Enable Of oDlg1 Action (_lOk := .T.,oDlg1:End())
Define sButton From C(086),C(120) Type 2 Enable Of oDlg1 Action (_lOk := .F.,oDlg1:End())

Activate msDialog oDlg1 Centered

If _lOk
	//�����������������������������������������������������������������������������������������������Ŀ
	//�                                                                                               �
	//�������������������������������������������������������������������������������������������������
	Processa({|lEnd| GNRE_004(_cFilial,cNFiscal,_cSerie,nTipo1)})
EndIf

Return()
/*�������������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������������
�����������������������������������������������������������������������������������������������ͻ��
���Funcao    � GNRE_004   � Autor � Jose Renato July                          � Data � MAI/2016 ���
�����������������������������������������������������������������������������������������������͹��
���Descricao �                                                                                  ���
�����������������������������������������������������������������������������������������������ͼ��
���������������������������������������������������������������������������������������������������
�������������������������������������������������������������������������������������������������*/
Static Function GNRE_004(_cFilial,cNFiscal,_cSerie,nTipo1)

//-- 1=GNRE gerada, 2=GIA Cta Pagar, 3=Gia Confirmada, 4=GIA Bordero e 5=Gia Paga
cFilNota	:= _cFilial
cNumNota	:= AllTrim(cNFiscal)
_cSerie		:= PadR(_cSerie,TamSx3('F2_SERIE')[1])
_dVenIni	:= dDataBase - 1
_dVenFim	:= dDataBase
cNumProc	:= ''

//�����������������������������������������������������������������������������������������������Ŀ
//� Selecao para a atualizacao do campo do status da GIA na nota fiscal.                          �
//�������������������������������������������������������������������������������������������������
cQuery := " SELECT "
cQuery += " F2_DOC     , SF2.R_E_C_N_O_  R_E_C_N_O_ "
cQuery += " FROM " + RetSqlName("SF2") + " SF2 "
cQuery += " WHERE D_E_L_E_T_  = '' "
cQuery += "   AND F2_XGIASTA  = '1' "
cQuery += "   AND F2_FILIAL   = '" + cFilNota + "' "
If nTipo1	= '1'
cQuery += "   AND F2_DOC     IN  " + FormatIn(cNumNota,',') + " "
cQuery += "   AND F2_SERIE    = '" + _cSerie  + "' "
Else
cQuery += "   AND F2_EMISSAO BETWEEN '"+ DToS(_dVenIni) +"' AND '"+ DToS(_dVenFim) +"'"
EndIf

cQuery := ChangeQuery(cQuery)
IIf(Select('TRB0')>0,TRB0->(dbCloseArea()),.T.)
dbUseArea(.T.,'TOPCONN',TCGENQRY(,,cQuery),'TRB0',.T.,.T.)
dbSelectArea('TRB0')

nReg	:= 0
TRB0->(dbGoTop())
Count To nReg
TRB0->(dbGoTop())

If nReg > 0

	ProcRegua(nReg)

	Do While !TRB0->(Eof()) .And. nReg > 0

		IncProc(TRB0->F2_DOC)

		dbSelectArea('TRB0')
		nRecno		:= TRB0->R_E_C_N_O_

		dbSelectArea('SF2')
		SF2->(dbGoTo(nRecno))
		Do While !SF2->(RecLock('SF2',.F.))
		EndDo
		SF2->F2_XGIASTA		:= ''
		SF2->(dbCommit())
		SF2->(msUnLock())

		dbSelectArea('TRB0')
		TRB0->(dbSkip())

		cNumProc	:= cNumProc + SF2->F2_DOC + IIf(Eof(),'',', ')

	EndDo

EndIf
IIf(Select('TRB0')>0,TRB0->(dbCloseArea()),.T.)

cNumNota	:= AllTrim(cNumNota) + '.'
cNumProc	:= AllTrim(cNumProc) + '.'

_cMens01	:= 'Notas fiscais solicitadas: ' 	+ CRLF
_cMens01	+= cNumNota							+ CRLF + CRLF
_cMens01	+= 'Notas fiscais processadas: ' 	+ CRLF
_cMens01	+= cNumProc							+ CRLF + CRLF
Aviso('Altera��o de status das GNREs'	, _cMens01	, {'OK'},3)

Return()
/*�������������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������������
�����������������������������������������������������������������������������������������������ͻ��
���Funcao    � GNRE_005   � Autor � Jose Renato July                          � Data � MAI/2016 ���
�����������������������������������������������������������������������������������������������͹��
���Descricao �                                                                                  ���
�����������������������������������������������������������������������������������������������ͼ��
���������������������������������������������������������������������������������������������������
�������������������������������������������������������������������������������������������������*/
Static Function GNRE_005()

_lRet1		:= .F.
_cEstCodbr	:= '|BA|DF|ES|MA|PA|RJ|SP|'

Do Case
Case cStsEsta $ _cEstCodbr
	If !Empty(cCodBarr)
		_lRet1	:= .T.
		U_DMBARRAS(cCodBarr)		// Funcao encontrado no fonte DM_E2CBar.
	Else
		Alert('Codigo de Barras Obrigat�rio...')
	EndIf
Case !cStsEsta $ _cEstCodbr
	_lRet1	:= .T.
EndCase

Return(_lRet1)
/*�������������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������������
�����������������������������������������������������������������������������������������������ͻ��
���Funcao    � IMP_LS_3   � Autor � Jose Renato July                          � Data � FEV/2016 ���
�����������������������������������������������������������������������������������������������͹��
���Descricao � Efetua a populacao das tabela SF6 e CDC.                                         ���
�����������������������������������������������������������������������������������������������ͼ��
���������������������������������������������������������������������������������������������������
�������������������������������������������������������������������������������������������������*/
Static Function IMP_LS_3()

//�����������������������������������������������������������������������������������������������Ŀ
//� Declara��o de Variaveis Private dos Objetos.                                                  �
//�������������������������������������������������������������������������������������������������
Local _lOk		:= .F.

Private oFont15		:= TFont():New('Arial',,15,,.T.,,,,.T.,.F.)
Private oFont16		:= TFont():New('Arial',,16,,.T.,,,,.T.,.F.)

Private oDlg1
Private oGerente
Private oNomeUsu
Private oSTSenha
Private oDocumento
Private oNomeFonec
//Private oSTDeleta
Private cGerente	:= Space(TamSX3('C5_VEND1')[1])
Private cSenhaAc	:= Space(TAMPSW)

Private cAlias		:= 'SF2'

cNomeUsu			:= Space(TamSX3('A2_NOME')[1])
cSTSenha			:= ''
cSTDeleta			:= ''

//�����������������������������������������������������������������������������������������������Ŀ
//� Interface para a comunicacao com o usuario.                                                   �
//�������������������������������������������������������������������������������������������������
Define FONT oFnt NAME 'Arial' Size C(012),C(014) BOLD
Define msDialog oDlg1 From C(015),C(006) To C(219),C(404) Title OemToAnsi('Atualiza SF6 e CDC') Pixel

@ C(002),C(002) TO C(041),C(199) 																		Pixel 			Of oDlg1
@ C(010),C(004) Say 'Cod. Usuario: '				Size C(050),C(008) COLOR CLR_BLUE 	Font oFont15	Pixel 			Of oDlg1
@ C(010),C(110) Say 'Senha: '						Size C(050),C(008) COLOR CLR_BLUE 	Font oFont15	Pixel 			Of oDlg1
@ C(009),C(038) MsGet oGerente		Var cGerente	Size C(050),C(008) COLOR CLR_HBLUE 	Font oFont16 	Pixel 			Of oDlg1 Picture '@!' Valid U_FUN_DM_U(cGerente,.T.)
@ C(009),C(132) MsGet cSenhaAc 						Size C(035),C(006) 									Pixel PASSWORD  Of oDlg1 Picture ''   Valid U_FUN_DM_S(cGerente,cSenhaAc)
@ C(010),C(167) Say oSTSenha 		Var cSTSenha	Size C(052),C(008) COLOR CLR_HRED	Font oFont15 	Pixel 			Of oDlg1
@ C(025),C(038) Say oNomeUsu		Var cNomeUsu	Size C(150),C(008) COLOR CLR_BLACK 	Font oFont16 	Pixel 			Of oDlg1

Define sButton From C(089),C(050) Type 1 Enable Of oDlg1 Action(_lOk:=.T.,oDlg1:End())
Define sButton From C(089),C(120) Type 2 Enable Of oDlg1 Action(_lOk:=.F.,oDlg1:End())

Activate msDialog oDlg1 Centered

If _lOk
	_cUsuario 	:= cGerente
	_cUsu_Ger	:= IIf(_cUsuario $ SuperGetMV('DM_SF6CDC',,'|000940|000281|'),.T.,.F.)
	If !_cUsu_Ger
		_fMg0		:= _fTt0 															+ CRLF
		_fMg0		+= 'Usu�rio ' + _cUsuario + ' sem autoriza��o para processar. !' 	+ CRLF
		_fMg0		+= 'Favor verificar !' 												+ CRLF
		MsgBox(_fMg0,_fTt1,_fCx1)
	Else

		//�����������������������������������������������������������������������������������������������Ŀ
		//� Processa a selecao dos registros do faturamento e popula as tabelas SF6 e CDC.                �
		//�������������������������������������������������������������������������������������������������
		Processa({|| GNRE_006() },'Popula tabelas SF6 e CDC','Populando registros...')

	EndIf

EndIf

Return()
/*�������������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������������
�����������������������������������������������������������������������������������������������ͻ��
���Funcao    � IMP_LS_4   � Autor � Jose Renato July                          � Data � ABR/2016 ���
�����������������������������������������������������������������������������������������������͹��
���Descricao � Efetua a liberacao do parametro para a geracao da gnre.                          ���
�����������������������������������������������������������������������������������������������ͼ��
���������������������������������������������������������������������������������������������������
�������������������������������������������������������������������������������������������������*/
Static Function IMP_LS_4()

//-- Declara��o de Variaveis Private dos Objetos.
Local _lOk		:= .F.

Private oFont15		:= TFont():New('Arial',,15,,.T.,,,,.T.,.F.)
Private oFont16		:= TFont():New('Arial',,16,,.T.,,,,.T.,.F.)

Private oDlg1
Private oGerente
Private oNomeUsu
Private oSTSenha
Private oDocumento
Private oNomeFonec
//Private oSTDeleta
Private cGerente	:= Space(TamSX3('C5_VEND1')[1])
Private cSenhaAc	:= Space(TAMPSW)

cNomeUsu			:= Space(TamSX3('A2_NOME')[1])
cSTSenha			:= ''
cSTDeleta			:= ''

_lLibGnre			:= SuperGetMV('DM_GNRELIB',,'.F.')
oLibGnre			:= ''
cLibGnre			:= _lLibGnre

//-- Interface para a comunicacao com o usuario.
Define FONT oFnt NAME 'Arial' Size C(012),C(014) BOLD
Define msDialog oDlg1 From C(015),C(006) To C(219),C(404) Title OemToAnsi('Libera a gera��o da GNRE') Pixel

@ C(002),C(002) TO C(041),C(199) 																		Pixel 			Of oDlg1
@ C(010),C(004) Say 'Cod. Usuario: '				Size C(050),C(008) COLOR CLR_BLUE 	Font oFont15	Pixel 			Of oDlg1
@ C(010),C(110) Say 'Senha: '						Size C(050),C(008) COLOR CLR_BLUE 	Font oFont15	Pixel 			Of oDlg1
@ C(009),C(038) MsGet oGerente		Var cGerente	Size C(050),C(008) COLOR CLR_HBLUE 	Font oFont16 	Pixel 			Of oDlg1 Picture '@!' Valid U_FUN_DM_U(cGerente,.T.)
@ C(009),C(132) MsGet cSenhaAc 						Size C(035),C(006) 									Pixel PASSWORD  Of oDlg1 Picture ''   Valid U_FUN_DM_S(cGerente,cSenhaAc)
@ C(010),C(167) Say oSTSenha 		Var cSTSenha	Size C(052),C(008) COLOR CLR_HRED	Font oFont15 	Pixel 			Of oDlg1
@ C(025),C(038) Say oNomeUsu		Var cNomeUsu	Size C(150),C(008) COLOR CLR_BLACK 	Font oFont16 	Pixel 			Of oDlg1

@ C(043),C(001) TO C(080),C(199) 																		Pixel 			Of oDlg1
@ C(050),C(002) Say 'Parametro da libera��o: '		Size C(150),C(008) COLOR CLR_BLUE	Font oFont15	Pixel 			Of oDlg1
@ C(050),C(070) Say oLibGnre 		Var cLibGnre	Size C(010),C(008) COLOR CLR_BLACK	Font oFont16 	Pixel 			Of oDlg1

Define sButton From C(089),C(050) Type 1 Enable Of oDlg1 Action(_lOk:=.T.,oDlg1:End())
Define sButton From C(089),C(120) Type 2 Enable Of oDlg1 Action(_lOk:=.F.,oDlg1:End())

Activate msDialog oDlg1 Centered

If _lOk

	_cUsuario 	:= cGerente 		//RetCodUsr()	// Retorna o codigo do usuario
	_cUsu_Ger	:= IIf(_cUsuario $ SuperGetMV('DM_SF6CDC',,'|000940|000281|000785|'),.T.,.F.)
	If !_cUsu_Ger
		_fMg0		:= _fTt0 															+ CRLF
		_fMg0		+= 'Usu�rio ' + _cUsuario + ' sem autoriza��o para processar. !' 	+ CRLF
		_fMg0		+= 'Favor verificar !' 												+ CRLF
		MsgBox(_fMg0,_fTt1,_fCx1)
	Else

		_lLibGnre	:= SuperGetMV('DM_GNRELIB',,'.F.')
		If _lLibGnre
			_lLibGnre := '.F.'
		Else
			_lLibGnre := '.T.'
		EndIf

		//-- Grava o numero da fatura para processamento 2015.
		GetMv('DM_GNRELIB')
		SX6->(RecLock('SX6',.F.))
		SX6->X6_CONTEUD := _lLibGnre
		SX6->(MsUnlock())

		_fMg0		:= _fTt0 											+ CRLF + CRLF
		_fMg0		+= 'Altera��o efetuada para: '+ _lLibGnre + '.' 	+ CRLF
		MsgBox(_fMg0,_fTt1,_fCx0)

	EndIf

EndIf

Return()
/*�������������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������������
�����������������������������������������������������������������������������������������������ͻ��
���Funcao    � GNRE_006   � Autor � Jose Renato July                          � Data � FEV/2016 ���
�����������������������������������������������������������������������������������������������͹��
���Descricao � Processa a selecao dos registros do faturamento e popula as tabelas SF6 e CDC.   ���
�����������������������������������������������������������������������������������������������ͼ��
���������������������������������������������������������������������������������������������������
�������������������������������������������������������������������������������������������������*/
Static Function GNRE_006()

//-- 1=GNRE gerada, 2=GIA Cta Pagar, 3=Gia Confirmada, 4=GIA Bordero e 5=Gia Paga
_cStGia			:= '| 1|2|3|4|5|'
_cEstSim		:= '|AC|AL|AP|AM|BA|CE|DF|ES|GO|MA|MG|MT|MS|PA|PB|PR|PE|PI|RJ|RN|RO|RR|RS|SC|SP|SE|TO|'	// Apartir de 29/01
_cEstNao		:= '|ES|'		//'|BA|DF|ES|MA|RJ|SP|'					// Nao gera GNRE, ou por existir IE ou nao permite emissao na GNRE
_dDtIni 		:= CToD('01/03/2016')
_dDtFim 		:= CToD('31/03/2016') //dDataBase

//-- Seleciona as vendas realizadas no periodo solicitado.
/*
cQuery := " SELECT "																			+ CRLF
cQuery += " A1_EST     , "																		+ CRLF
cQuery += " F2_FILIAL  , F2_DOC     , F2_SERIE   , SF2.R_E_C_N_O_ , "							+ CRLF
cQuery += "  SUM(D2_TOTAL) D2_TOTAL   , "														+ CRLF
cQuery += "  SUM(D2_DIFAL) D2_DIFAL     "														+ CRLF
cQuery += " FROM " + RetSqlName("SA1") + " SA1, "
cQuery += "      " + RetSqlName("SD2") + " SD2, "
cQuery += "      " + RetSqlName("SF2") + " SF2, "
cQuery += "      " + RetSqlName("SF4") + " SF4  "												+ CRLF
cQuery += " WHERE SA1.D_E_L_E_T_  = '' "														+ CRLF
cQuery += "   AND SD2.D_E_L_E_T_  = '' "														+ CRLF
cQuery += "   AND SF2.D_E_L_E_T_  = '' "														+ CRLF
cQuery += "   AND SF4.D_E_L_E_T_  = '' "														+ CRLF
cQuery += "   AND A1_EST     NOT IN " + FormatIn(_cEstNao,'|') + " "							+ CRLF
cQuery += "   AND A1_EST         IN " + FormatIn(_cEstSim,'|') + " "							+ CRLF
cQuery += "   AND D2_TIPO         = 'N' "														+ CRLF
cQuery += "   AND D2_DIFAL        > 0 "															+ CRLF
cQuery += "   AND F2_FILIAL       = D2_FILIAL "													+ CRLF
cQuery += "   AND F2_DOC          = D2_DOC "													+ CRLF
cQuery += "   AND F2_SERIE        = D2_SERIE "													+ CRLF
cQuery += "   AND F2_XGIASTA     IN " + FormatIn(_cStGia,'|') + " "								+ CRLF
cQuery += "   AND F2_EMISSAO BETWEEN '"+ DToS(_dDtIni) +"' AND '"+ DToS(_dDtFim) +"'"			+ CRLF
cQuery += "   AND F2_CLIENTE      = A1_COD "													+ CRLF
cQuery += "   AND F2_LOJA         = A1_LOJA "													+ CRLF
cQuery += "   AND F2_CHVNFE      <> '' "														+ CRLF
cQuery += "   AND F4_CODIGO       = D2_TES "													+ CRLF
cQuery += "   AND F4_DUPLIC       = 'S' "														+ CRLF
cQuery += " GROUP BY A1_EST,F2_FILIAL,F2_DOC,F2_SERIE,SF2.R_E_C_N_O_"							+ CRLF
cQuery += " UNION "																				+ CRLF
*/

cQuery := " SELECT "																			+ CRLF
cQuery += " F3_ESTADO     , "
cQuery += " F3_FILIAL  , F3_NFISCAL     , F3_SERIE   , F3_CLIEFOR     , F3_LOJA     , "			+ CRLF
cQuery += " F3_ALIQICM , "																		+ CRLF
cQuery += " SUM(F3_VALCONT) F3_TOTAL   , "														+ CRLF
cQuery += " SUM(F3_DIFAL)   F3_DIFAL     "														+ CRLF
cQuery += " FROM " + RetSqlName("SF3") + " SF3 "												+ CRLF
cQuery += " WHERE SF3.D_E_L_E_T_  = '' "														+ CRLF
cQuery += "   AND F3_ESTADO  NOT IN " + FormatIn(_cEstNao,'|') + " "							+ CRLF
cQuery += "   AND F3_ESTADO      IN " + FormatIn(_cEstSim,'|') + " "							+ CRLF
cQuery += "   AND F3_DIFAL        > 0 "															+ CRLF
//cQuery += "   AND F3_NFISCAL      = '301304' "													+ CRLF
cQuery += "   AND F3_EMISSAO BETWEEN '"+ DToS(_dDtIni) +"' AND '"+ DToS(_dDtFim) +"'"			+ CRLF
cQuery += " GROUP BY F3_ESTADO,F3_FILIAL,F3_NFISCAL,F3_SERIE,F3_CLIEFOR,F3_LOJA,F3_ALIQICM"		+ CRLF
cQuery += " ORDER BY F3_ESTADO,F3_FILIAL,F3_NFISCAL,F3_ALIQICM"									+ CRLF
cQuery := ChangeQuery(cQuery)
IIf(Select('TRX')>0,TRX->(dbCloseArea()),.T.)
MsAguarde({|| dbUseArea(.T.,'TOPCONN',TCGENQRY(,,cQuery),'TRX',.T.,.T. )},_fTt1,'Selecionando registros...')

dbSelectArea('TRX')
TRX->(dbGoTop())
Count To _nRegSel
TRX->(dbGoTop())

//-- Processa a geracao do arquivo texto para integracao com o GRNE.
If _nRegSel > 0

	ProcRegua(_nRegSel)
	TRX->(dbGoTop())

	Do While !TRX->(Eof()) .And. _nRegSel > 0

		IncProc('Populando tabelas SF6/CDC...')

		dbSelectArea('TRX')
		_cChave			:= TRX->(F3_FILIAL+F3_CLIEFOR+F3_LOJA+F3_NFISCAL+F3_SERIE)
		_nF3AliqIcm		:= TRX->F3_ALIQICM
		_nF3Difal		:= TRX->F3_DIFAL

		dbSelectArea('SF2')
		SF2->(dbSetOrder(2))
		If SF2->(dbSeek(_cChave))

			cFilNota	:= SF2->F2_FILIAL
			cNumNota	:= SF2->F2_DOC
			_cSerie		:= SF2->F2_SERIE
			_cCliente	:= SF2->F2_CLIENTE
			_cLoja		:= SF2->F2_LOJA
			cF2EST		:= SuperGetMV('MV_ESTADO')
			cNumSF6		:= cFilNota + cF2EST + (SF2->F2_PREFIXO + StrZero(Val(SF2->F2_DOC),TamSx3('F2_DOC')[1]))

			//-- Dah um 'tapa' no DIFAUL das vendas do loja.
			_cChaveSD2	:= cFilNota + cNumNota + _cSerie + _cCliente + _cLoja
			_lProcIcm	:= .F.
			dbSelectArea('SD2')
			SD2->(dbSetOrder(3))		// D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM
			If SD2->(dbSeek(_cChaveSD2)) .And. SD2->D2_ORIGLAN = 'VD'
				Do While !Eof() .And. SD2->(D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA) = cFilNota+cNumNota+_cSerie+_cCliente+_cLoja
					If SD2->D2_PICM == _nF3AliqIcm .And. !_lProcIcm
						_lProcIcm	:= .T.
						Do While !SD2->(RecLock('SD2',.F.))
						EndDo
						SD2->D2_DIFAL 	:= _nF3Difal
						SD2->D2_NREDUZ	:= 'Tapa no Difal'
						SD2->(MsUnlock())
					EndIf
					SD2->(dbSkip())
				EndDo
			EndIf

			dbSelectArea('SF6')
			SF6->(dbSetOrder(1))		// F6_FILIAL+F6_EST+F6_NUMERO
			If !SF6->(dbSeek(cNumSF6))

				//�����������������������������������������������������������������������������������������������Ŀ
				//� Processa a populacao dos registros nas tabelas SF6 e CDC. Fonte GIABAIXA.                     �
				//�������������������������������������������������������������������������������������������������
				U_GIA_BXA9(cFilNota,cNumNota,_cSerie)

			EndIf
		EndIf
	
		dbSelectArea('TRX')
		TRX->(dbSkip())

	EndDo

Else
	_fMg0 	:= OemToAnsi('N�O h� nota fiscal para processamento.') + CRLF + CRLF
	_fMg0 	+= OemToAnsi('Favor verificar !') + CRLF
	MsgBox(_fMg0,_fTt1,_fCx3)
EndIf

Return()
/*�������������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������������
�����������������������������������������������������������������������������������������������ͻ��
���Funcao    � C          � Autor � Jose Renato July                          � Data � OUT/2015 ���
�����������������������������������������������������������������������������������������������͹��
���Descricao � Mantem o Layout indepEndente da resolucao horizontal do Monitor do Usuario.      ���
�����������������������������������������������������������������������������������������������ͼ��
���������������������������������������������������������������������������������������������������
�������������������������������������������������������������������������������������������������*/
Static Function C(nTam)

Local nHRes	:=	oMainWnd:nClientWidth		// Resolucao horizontal do monitor

If nHRes == 640								// Resolucao 640x480 (soh o Ocean e o Classic aceitam 640)
	nTam *= 0.8
ElseIf (nHRes == 798).Or.(nHRes == 800)	// Resolucao 800x600
	nTam *= 1
Else										// Resolucao 1024x768 e acima
	nTam *= 1.28
EndIf

If 'MP8' $ oApp:cVersion
	If (AllTrim(GetTheme()) == 'FLAT') .Or. SetMdiChild()
		nTam *= 0.90
	EndIf
EndIf

Return(Int(nTam))
/*�������������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������������
�����������������������������������������������������������������������������������������������ͻ��
���                                                                                             ���
���              ��������  ��  ��  ������               ������  ���  ��  ����                   ���
���                 ��     ��  ��  ��                   ��      ���� ��  �� ��                  ���
���                 ��     ������  �����                �����   �� ����  ��  ��                 ���
���                 ��     ��  ��  ��                   ��      ��  ���  �� ��                  ���
���                 ��     ��  ��  ������               ������  ��   ��  ����                   ���
���                                                                                             ���
�����������������������������������������������������������������������������������������������ͼ��
���������������������������������������������������������������������������������������������������
�������������������������������������������������������������������������������������������������*/