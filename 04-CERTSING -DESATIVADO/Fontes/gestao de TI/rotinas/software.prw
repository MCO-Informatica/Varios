#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NOVO2     �Autor  �Microsiga           � Data �  05/24/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function Software()

// 1=Ativo;2=Manutencao;3=Estocado;4=Baixado
Local aCores		:= {	{ "U04->U04_STATUS=='1'",	"BR_VERDE"		},;
							{ "U04->U04_STATUS=='2'",	"BR_VERMELHO"	},;
							{ "U04->U04_STATUS=='3'",	"BR_PRETO"		};
						 }

If !U_TILicenca()
	Return(.F.)
Endif

PRIVATE aRotina := {	{ "Pesquisar",	"AxPesqui", 	0, 1	},;
						{ "Visualizar",	"U_SoftVis",	0, 2	},;
						{ "Incluir",	"U_SoftInc",	0, 3	},;
						{ "Alterar",	"U_SoftAlt",	0, 4, 2	},;
						{ "Excluir",	"U_SoftExc",	0, 5, 1	},;
						{ "Legenda",	"U_SoftLeg",	0, 2	},;
						{ "Anexar Documentos",	"MsDocument('U04',U04->(RecNo()),4)",	0, 4	};
						 }

//�����������������������������������������������������Ŀ
//� Ponto de entrada para tratar o menu da rotina de    �
//� controle de software.                               � 
//� Criado por: Marcelo Celi Marques                    � 
//� Data:  19/10/2012				                    �
//�������������������������������������������������������
IF ExistBlock("SCSOFMENU")
	aRotina := ExecBlock("SCSOFMENU",.f.,.f.,{aRotina})
Endif	
	

//��������������������������������������������������������������Ŀ
//� Define o cabecalho da tela de atualizacoes                   �
//����������������������������������������������������������������
PRIVATE cCadastro := "Cadastramento de Software"

//��������������������������������������������������������������Ŀ
//� Endereca a funcao de BROWSE                                  �
//����������������������������������������������������������������
mBrowse(0,0,0,0,"U04",,,,,,aCores)

Return(.T.)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �SoftWARE  �Autor  �Microsiga           � Data �  06/25/09   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function SoftVis(cAlias, nReg, nOpc)

Local oDlg
Local aButtons	:= {}
Local aHeader	:= {}
Local aCols		:= {}
Local nI		:= 0
Local aCampos	:= {}
Local nWidth	:= oMainWnd:nClientWidth
Local nHeight	:= oMainWnd:nClientHeight
Local nOpcA		:= 0
Local cQuery	:= ""
Local aLbx		:= {}
Local aTipo		:= {"Desk Top", "Note Book", "Impressora Rede"}
Local aPropri	:= {"Empresa", "Particular"}
Local aStatus	:= {"Ativo","Manutencao","Estocado","Baixado"}

Private oMsMGet
Private aTela[0][0]
Private aGets[0][0]

// Calcula as coordenadas para a DIALOG e demais objetos
If nWidth == 0 .OR. nHeight == 0
	nWidth	:= 1000		// 1024
	nHeight	:= 615		// 768
Endif
nWidth	:= nWidth * .99
nHeight	:= nHeight * .95

// Dados para a MsMGet
RegToMemory(cAlias,.F.)

SX3->( DbSetOrder(1) )
SX3->( MsSeek("U04") )
While SX3->( !Eof() ) .AND. SX3->X3_ARQUIVO == "U04"
	If SX3->X3_CONTEXT <> "V" .AND. X3USO(SX3->X3_USADO)
		Aadd(aCampos, SX3->X3_CAMPO )
	Endif
	SX3->( DbSkip() )
End

cQuery	:=	" SELECT  U00_CODHRD, U00_TIPHRD, U00_MARCA, U00_PROPRI, U00_STATUS, U00_CODLOC, U00_SETOR, U00_NOMCPU, U00_NOMUSR, U00_IP, U00_NOMFUN " +;
			" FROM    " + RetSQLName("U01") + " U01, " + RetSQLName("U00") + " U00 " +;
			" WHERE   U01.U01_FILIAL = '" + xFilial("U01") + "' AND " +;
			"         U01.U01_CODSFT = '" + U04->U04_CODSFT + "' AND " +;
			"         U01.D_E_L_E_T_ = ' ' AND " +;
			"         U00.U00_FILIAL = '" + xFilial("U00") + "' AND " +;
			"         U00.U00_CODHRD = U01.U01_CODHRD AND " +;
			"         U00.D_E_L_E_T_ = ' ' "
PLSQuery( cQuery, "U00TMP" )
While U00TMP->( !Eof() )
	
	SZ3->( DbSetOrder(1) )
	SZ3->( MsSeek( xFilial("SZ3")+U00TMP->U00_CODLOC ) )
	
	U06->( DbSetOrder(1) )
	U06->( MsSeek( xFilial("U06")+U00TMP->U00_TIPHRD ) )
	
	Aadd( aLbx, {	U00TMP->U00_CODHRD,;
					U06->U06_DESTIP,;//aTipo[Val(U00TMP->U00_TIPHRD)],;
					U00TMP->U00_MARCA,;
					aPropri[Val(U00TMP->U00_PROPRI)],;
					aStatus[Val(U00TMP->U00_STATUS)],;
					SZ3->Z3_DESENT,;
					U00TMP->U00_SETOR,;
					U00TMP->U00_NOMCPU,; 
					U00TMP->U00_NOMUSR,; 
					U00TMP->U00_IP,;
					U00TMP->U00_NOMFUN } )
	
	U00TMP->( DbSkip() )
End
U00TMP->( DbCloseArea() )

If Len(aLbx) == 0
	Aadd( aLbx, { "","","","","","","","","","","" } )
Endif

//Aadd(aButtons,{ "FERRAM",	{|| MDP90Copy() }, "Copia os agendados de uma dia para outro dia.", "Copiar" } )

DEFINE DIALOG oDlg TITLE cCadastro SIZE nWidth, nHeight PIXEL
	
	EnchoiceBar(oDlg,{|| IIF(Obrigatorio(aGets,aTela).AND.SWVld(1),(nOpcA:=1,oDlg:End()),AllWaysTrue()) },{|| oDlg:End() },,aButtons)
	
	oMsMGet := MsMGet():New(cAlias,nReg,nOpc,,,,,{015,000,(nHeight/4),(nWidth/2)},,3,,,,oDlg)
	
	@ (nHeight/4),000 LISTBOX oLbx FIELDS HEADER "Hardware", "Tipo", "Marca", "Propriedade", "Status", "Local", "Setor", "Nome CPU", "Login Usuario", "Endere�o IP", "Funcion�rio" SIZE (nWidth/2),(nHeight/4)-15 OF oDlg PIXEL
	
	oLbx:SetArray(aLbx)
	oLbx:bLine := {||{	aLbx[oLbx:nAt][01],;
						aLbx[oLbx:nAt][02],;
						aLbx[oLbx:nAt][03],;
						aLbx[oLbx:nAt][04],;
						aLbx[oLbx:nAt][05],;
						aLbx[oLbx:nAt][06],;
						aLbx[oLbx:nAt][07],;
						aLbx[oLbx:nAt][08],;
						aLbx[oLbx:nAt][09],;
						aLbx[oLbx:nAt][10],;
						aLbx[oLbx:nAt][11];
						}}
	
ACTIVATE DIALOG oDlg CENTERED

Return(.T.)



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �SoftWARE  �Autor  �Microsiga           � Data �  06/25/09   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function SoftInc(cAlias, nReg, nOpc)

Local oDlg
Local aButtons	:= {}
Local aHeader	:= {}
Local aCols		:= {}
Local nI		:= 0
Local aCampos	:= {}
Local nWidth	:= oMainWnd:nClientWidth
Local nHeight	:= oMainWnd:nClientHeight
Local nOpcA		:= 0

Private oMsMGet
Private aTela[0][0]
Private aGets[0][0]

// Calcula as coordenadas para a DIALOG e demais objetos
If nWidth == 0 .OR. nHeight == 0
	nWidth	:= 1000		// 1024
	nHeight	:= 615		// 768
Endif
nWidth	:= nWidth * .99
nHeight	:= nHeight * .95

// Dados para a MsMGet
RegToMemory(cAlias,.T.)

SX3->( DbSetOrder(1) )
SX3->( MsSeek("U04") )
While SX3->( !Eof() ) .AND. SX3->X3_ARQUIVO == "U04"
	If SX3->X3_CONTEXT <> "V" .AND. X3USO(SX3->X3_USADO)
		Aadd(aCampos, SX3->X3_CAMPO )
	Endif
	SX3->( DbSkip() )
End

//Aadd(aButtons,{ "FERRAM",	{|| MDP90Copy() }, "Copia os agendados de uma dia para outro dia.", "Copiar" } )

DEFINE DIALOG oDlg TITLE cCadastro SIZE nWidth, nHeight PIXEL

EnchoiceBar(oDlg,{|| IIF(Obrigatorio(aGets,aTela).AND.SWVld(1),(nOpcA:=1,oDlg:End()),AllWaysTrue()) },{|| oDlg:End() },,aButtons)

oMsMGet := MsMGet():New(cAlias,nReg,nOpc,,,,,{015,000,(nHeight/2)-15,(nWidth/2)},,3,,,,oDlg)

ACTIVATE DIALOG oDlg CENTERED

If nOpcA == 1
	SWGrv(aCampos)
Else
	(cAlias)->( RollBackSX8() )
Endif

Return(.T.)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �SoftWARE  �Autor  �Microsiga           � Data �  06/25/09   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function SoftAlt(cAlias, nReg, nOpc)

Local oDlg
Local aButtons	:= {}
Local aHeader	:= {}
Local aCols		:= {}
Local nI		:= 0
Local aCampos	:= {}
Local nWidth	:= oMainWnd:nClientWidth
Local nHeight	:= oMainWnd:nClientHeight
Local nOpcA		:= 0

Private oMsMGet
Private aTela[0][0]
Private aGets[0][0]

// Calcula as coordenadas para a DIALOG e demais objetos
If nWidth == 0 .OR. nHeight == 0
	nWidth	:= 1000		// 1024
	nHeight	:= 615		// 768
Endif
nWidth	:= nWidth * .99
nHeight	:= nHeight * .95

// Dados para a MsMGet
RegToMemory(cAlias,.F.)

SX3->( DbSetOrder(1) )
SX3->( MsSeek("U04") )
While SX3->( !Eof() ) .AND. SX3->X3_ARQUIVO == "U04"
	If SX3->X3_CONTEXT <> "V" .AND. X3USO(SX3->X3_USADO)
		Aadd(aCampos, SX3->X3_CAMPO )
	Endif
	SX3->( DbSkip() )
End

//Aadd(aButtons,{ "FERRAM",	{|| MDP90Copy() }, "Copia os agendados de uma dia para outro dia.", "Copiar" } )

DEFINE DIALOG oDlg TITLE cCadastro SIZE nWidth, nHeight PIXEL

EnchoiceBar(oDlg,{|| IIF(Obrigatorio(aGets,aTela).AND.SWVld(1),(nOpcA:=1,oDlg:End()),AllWaysTrue()) },{|| oDlg:End() },,aButtons)

oMsMGet := MsMGet():New(cAlias,nReg,nOpc,,,,,{015,000,(nHeight/2)-15,(nWidth/2)},,3,,,,oDlg)

ACTIVATE DIALOG oDlg CENTERED

If nOpcA == 1
	SWGrv(aCampos)
Else
	(cAlias)->( RollBackSX8() )
Endif

Return(.T.)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �SoftWARE  �Autor  �Microsiga           � Data �  06/25/09   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function SoftExc(cAlias, nReg, nOpc)

Local oDlg
Local aButtons	:= {}
Local aHeader	:= {}
Local aCols		:= {}
Local nI		:= 0
Local aCampos	:= {}
Local nWidth	:= oMainWnd:nClientWidth
Local nHeight	:= oMainWnd:nClientHeight
Local nOpcA		:= 0

Private oMsMGet

// Calcula as coordenadas para a DIALOG e demais objetos
If nWidth == 0 .OR. nHeight == 0
	nWidth	:= 1000		// 1024
	nHeight	:= 615		// 768
Endif
nWidth	:= nWidth * .99
nHeight	:= nHeight * .95

// Dados para a MsMGet
RegToMemory(cAlias,.T.)

SX3->( DbSetOrder(1) )
SX3->( MsSeek("U04") )
While SX3->( !Eof() ) .AND. SX3->X3_ARQUIVO == "U04"
	If SX3->X3_CONTEXT <> "V" .AND. X3USO(SX3->X3_USADO)
		Aadd(aCampos, SX3->X3_CAMPO )
	Endif
	SX3->( DbSkip() )
End

//Aadd(aButtons,{ "FERRAM",	{|| MDP90Copy() }, "Copia os agendados de uma dia para outro dia.", "Copiar" } )

DEFINE DIALOG oDlg TITLE cCadastro SIZE nWidth, nHeight PIXEL

EnchoiceBar(oDlg,{|| IIF(SWVld(2),(nOpcA:=1,oDlg:End()),AllWaysTrue()) },{|| oDlg:End() },,aButtons)

oMsMGet := MsMGet():New(cAlias,nReg,nOpc,,,,,{015,000,(nHeight/2)-15,(nWidth/2)},,3,,,,oDlg)

ACTIVATE DIALOG oDlg CENTERED

If nOpcA == 1
	U04->( RecLock("U04",.F.) )
	U04->( DbDelete() )
	U04->( MsUnlock() )
	
	//�����������������������������������������������������Ŀ
	//� Ponto de entrada para integracoes apos a exclusao   �
	//� da tabela U04.                                      � 
	//� Criado por: Marcelo Celi Marques                    � 
	//� Data:  16/10/2012				                    �
	//�������������������������������������������������������
	IF ExistBlock("SOFDELU04")
		ExecBlock("SOFDELU04",.f.,.f.)
	Endif	
	
Endif

Return(.T.)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �SOFTWARE  �Autor  �Microsiga           � Data �  05/24/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function SWVld(nAcao)

Local cLog	:= ""

If nAcao == 1		// Gravar
	If M->U04_TIPLIC == "3" .AND. Empty(M->U04_CONTRA)
		cLog += "O n�mero do contrato � obrigat�rio para este tipo de licen�a." + CRLF
	Endif
Endif

If nAcao == 2		// Excluir
	If U04->U04_QTDLIC <> U04->U04_SLDLIC
		cLog += "Existem licen�as instaladas em equipamentos e este software n�o poder� ser excluido." + CRLF
	Endif
Endif


If !Empty(cLog)
	MsgStop("Aten��o, corrija as pendencias abaixo: "+CRLF+CRLF+cLog)
	Return(.F.)
Endif

Return(.T.)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �SOFTWARE  �Autor  �Microsiga           � Data �  05/24/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function SWGrv(aCampos)

Local nI		:= 0
Local cCampo	:= ""

Begin Transaction
	RollBackSX8()
	
	U04->( RecLock("U04", INCLUI) )
	
	If INCLUI
		U04->U04_FILIAL	:= xFilial("U04")
		U04->U04_CODSFT	:= GetSXENum("U04", "U04_CODSFT")
		
		ConfirmSX8()
	Endif
	
	For nI := 1 To Len(aCampos)
		cCampo := aCampos[nI]
		U04->(&cCampo) := M->(&cCampo)
	Next nI
	
	U04->( MsUnLock() )
	
	//�����������������������������������������������������Ŀ
	//� Ponto de entrada para integracoes apos a gravacao   �
	//� da tabela U04.                                      � 
	//� Criado por: Marcelo Celi Marques                    � 
	//� Data:  16/10/2012				                    �
	//�������������������������������������������������������
	IF ExistBlock("SOFGRVU04")
		ExecBlock("SOFGRVU04",.f.,.f.)
	Endif	
	
End Transaction

Return(.T.)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �SOFTWARE  �Autor  �Microsiga           � Data �  06/25/09   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function SOFTLeg()

// 1=Ativo;2=Manutencao;3=Estocado;4=Baixado

BrwLegenda(cCadastro,"Legenda", {	{"BR_VERDE",	"Dispon�vel para instala��es"},;
									{"BR_VERMELHO",	"Suspendido temporariamente"},;
									{"BR_PRETO",	"Cancelado em definitivo"};
								  };
			)

Return(.T.)
