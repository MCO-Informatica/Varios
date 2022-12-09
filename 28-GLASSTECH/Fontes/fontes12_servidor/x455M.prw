//#INCLUDE "X455M.CH"
#INCLUDE "protheus.CH"
#Include "topconn.ch"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � MATA455  � Autor � Rosane Luciane Chene  � Data � 18.01.95 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Programa de Liberacao de Estoque                           ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe e � Void MATA455(void)                                         ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
��� ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                     ���
�������������������������������������������������������������������������Ĵ��
��� PROGRAMADOR  � DATA   � BOPS �  MOTIVO DA ALTERACAO                   ���
�������������������������������������������������������������������������Ĵ��
��� Rogerio F.G. �26/11/97�12619 �Inc.de Pergunta para Sel. Registros     ���
��� Edson/Rogerio�12/12/97�12619 �Acerto do Indice Tmp.                   ���
��� Edson   M.   �09/01/98�XXXXX �Acerto da gravacao do Campo C6_OP       ���
��� Marcelo Pime.�28/01/98�12697A�Verificacao do produto se est� bloqueado���
��� Edson   M.   �18/02/98�XXXXX �Acerto da Pesquisa.                     ���
��� Rodrigo Sart.�11/05/98�XXXXXX�Acerto dos Locks Moinho Dias Branco     ���
��� Lucas        �04/08/98�XXXXXX�Inicializacao do Array aArrayAE.        ���
��� Edson   M.   �28/12/98�XXXXX �Inclusao do PE M455FIL.                 ���
��� Viviani      �08/11/99�Melhor�Nova cria��o de dialogos (Protheus)     ���
��� Aline C.Vale �20/05/99�21712 �Criacao de PE MTA455I                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
//��������������������������������������������������������������Ŀ
//� Define Array contendo as Rotinas a executar do programa      �
//� ----------- Elementos contidos por dimensao ------------     �
//� 1. Nome a aparecer no cabecalho                              �
//� 2. Nome da Rotina associada                                  �
//� 3. Usado pela rotina                                         �
//� 4. Tipo de Transa��o a ser efetuada                          �
//�    1 - Pesquisa e Posiciona em um Banco de Dados             �
//�    2 - Simplesmente Mostra os Campos                         �
//�    3 - Inclui registros no Bancos de Dados                   �
//�    4 - Altera o registro corrente                            �
//�    5 - Remove o registro corrente do Banco de Dados          �
//����������������������������������������������������������������
User Function x455M()
//��������������������������������������������������������������Ŀ
//� Define Variaveis                                             �
//����������������������������������������������������������������
Local aArea     := GetArea()


Local bOk			:= {|| oDlg:End() }    
  
Local aButtons	:= {}   
	
Local aSize 			:= {}
Local aInfoAdvSize	:= {}
Local aInfo			:= {}
Local aPosObj			:= {}
Local aObjects		:= {}

Local cPerg     := "MTA455"
Local cFilSC9   := ""
Local cCondicao := ""
Local aIndSC9   := {}
Local aCores    := {{"C9_BLEST=='  '.And.C9_BLCRED=='  '.And.(C9_BLWMS>='05'.OR.C9_BLWMS='  ').And.Iif(SC9->((FieldPos('C9_BLTMS') > 0)), Empty(C9_BLTMS), .T.)",'ENABLE' },;//Item Liberado
	{ "(C9_BLCRED=='10'.And.C9_BLEST=='10').Or.(C9_BLCRED=='ZZ'.And.C9_BLEST=='ZZ')",'DISABLE'},;		   	//Item Faturado
	{ "!C9_BLCRED=='  '.And.C9_BLCRED<>'10'.And.C9_BLCRED<>'ZZ'",'BR_AZUL'},;	//Item Bloqueado - Credito
	{ "!C9_BLEST=='  '.And.C9_BLEST<>'10'.And.C9_BLEST<>'ZZ'",'BR_PRETO'},;	//Item Bloqueado - Estoque
	{ "C9_BLWMS<='05'.And.!C9_BLWMS=='  '",'BR_AMARELO'},;	//Item Bloqueado - WMS
	{ "Iif(SC9->((FieldPos('C9_BLTMS') > 0)), !Empty(C9_BLTMS), .F.)"  ,'BR_LARANJA'}}	//Item Bloqueado - TMS

//��������������������������������������������������������������Ŀ
//� Ponto de Entrada para alterar cores do Browse do Cadastro    �
//����������������������������������������������������������������
If ExistBlock("MA455COR")
	aCores := ExecBlock("MA455COR",.F.,.F.,aCores)
Endif

Private bFiltraBrw := {|| Nil}
Private cCadastro := OemToAnsi("Liberacao de Estoque")		//"Libera��o de Estoque"
If ( cPaisLoc $ "ARG|POR|EUA" )
	Private aArrayAE:={}
EndIf
Private aRotina := MenuDef()

private oVerde    	:= LoadBitmap(GetResources(),'BR_VERDE')    
private oAmarelo  	:= LoadBitmap(GetResources(),'BR_AMARELO') 
private oVermelho 	:= LoadBitmap(GetResources(),'BR_VERMELHO') 
Private oAzul			:= LoadBitmap(GetResources(),'BR_AZUL')
Private oLaranja		:= LoadBitmap(GetResources(),'BR_LARANJA')
Private oPreto		:= LoadBitmap(GetResources(),'BR_PRETO')
Private oOk      		:= LoadBitmap( nil, "LBOK" )
Private oNo      		:= LoadBitmap( nil, "LBNO" )

Private cCondPers	:= ""

Private bCancel		:= {|| oDlg:End()}  
Private oDlg 



Aadd( aButtons, {"LEGEND", {|| A450Legend()}			, "Legenda"} )
Aadd( aButtons, {"AUTOMAT",{|| U_LibAutom()}			, "Autom�tica"} )
Aadd( aButtons, {"MANUAL", {|| U_LibManu()}			, "Manual"} )
//Aadd( aButtons, {"NOVALIB",{|| U_NewLib()}		 	, "Nova Libera��o"} )
Aadd( aButtons, {"ATUBRW",{|| atuBrw()}		 		, "Atualiza Browse"} )


If VerSenha(137)
	//��������������������������������������������������������������Ŀ
	//� So Ped. Bloqueados   mv_par01          Sim Nao               �
	//����������������������������������������������������������������
	If Pergunte(cPerg,.T.)
		If (ExistBlock("M455FIL"))
			cFilSC9 := ExecBlock("M455FIL",.f.,.f.)
		EndIf
		//�����������������������������������������������������������������������������������Ŀ
		//�EXECUTAR CHAMADA DE FUNCAO p/ integracao com sistema de Distribuicao - NAO REMOVER �
		//�������������������������������������������������������������������������������������
		dbSelectArea("SC9")
		dbSetOrder(1)
		SC9->(MsSeek(xFilial("SC9")))
		Do Case
			Case mv_par01 == 1 //Somente de Estoque
				cFilSC9   := If(Empty(cFilSC9),".T.",cFilSC9)
				cCondicao := "C9_FILIAL=='"+xFilial("SC9")+"'.And."
				cCondicao += "C9_BLEST<>'  '.And."
				cCondicao += "C9_BLCRED=='  '.And."
				cCondicao += cFilSC9
				
				cCondPers := " AND C9_BLEST<>'  ' AND C9_BLCRED='  ' "
			Case MV_PAR01==2 //Sem Restricao
				cCondicao := cFilSC9
			Case MV_PAR01==3 //Somente WMS
				cFilSC9   := If(Empty(cFilSC9),".T.",cFilSC9)
				cCondicao := "C9_FILIAL=='"+xFilial("SC9")+"'.And."
				cCondicao += "C9_BLEST=='  '.And."
				cCondicao += "C9_BLCRED=='  '.And."
				cCondicao += "C9_BLWMS=='03'.And."
				cCondicao += cFilSC9
				
				cCondPers := " AND C9_BLEST='  ' AND C9_BLCRED='  ' AND C9_BLWMS='03' "
			OtherWise //Todos os Bloqueios
				cFilSC9   := If(Empty(cFilSC9),".T.",cFilSC9)
				cCondicao := "C9_FILIAL=='"+xFilial("SC9")+"'.And."
				cCondicao += "((C9_BLEST<>'  '.And."
				cCondicao += "C9_BLCRED=='  ').OR."
				cCondicao += "C9_BLWMS=='03').And."
				cCondicao += cFilSC9
				
				cCondPers := " AND ((C9_BLEST<>'  ' AND C9_BLCRED='  ') OR C9_BLWMS='03') "
		EndCase
		If !Empty(cCondicao)
			bFiltraBrw := {|| FilBrowse("SC9",@aIndSC9,@cCondicao) }
			Eval(bFiltraBrw)
		EndIf
		//��������������������������������������������������������������Ŀ
		//� Endereca a funcao de BROWSE                                  �
		//����������������������������������������������������������������
		dbSelectArea("SC9")
		If ( Eof() )
			HELP(" ",1,"RECNO")
		Else
			//mBrowse( 7, 4,20,74,"SC9",,,,,,aCores) //,,"C9_BLEST"	
			
			//Redimensionamento da tela.
			aSize 			:= MsAdvSize(nil,.F.)
			aInfoAdvSize	:= { aSize[1] , aSize[2] , aSize[3] , aSize[4] , 0 , 0 }
			AAdd( aObjects, { 100, 100 , .T., .T. })
			aInfo		:= { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
			aPosObj 	:= MsObjSize( aInfo, aObjects)

			// Montagem da Interaface
			oDlg 	:= MSDialog():New(aSize[1], aSize[2], aSize[6], aSize[5], OEMTOANSI("Libera��o de Estoque"),,,,,,,, oMainWnd, .T.)
			
			oBrowse := TCBrowse():New( aPosObj[1][1] , aPosObj[1][2], aPosObj[1][4] - 20 , aPosObj[1][3] - 35 ,,;                     
			{'','','Pedido','Item','Cliente','Loja','Produto','Qt Liberada','Nota Fiscal','Serie NF','DT Liberacao','Sequencia','Grupo','Prc Venda','Agreg. liber.','Bloq.Estoque','Bloq.Credito','N do Remito','Item Remito','Armazem','Bloqueio WMS','N. da Carga','Seq. da Carga','Servico','End. Padr�o','Estr. Fisica','Qt Liberada2','Inf.Bloqueio','Seq. Empenho','Tipo OP','Data Entrega'},{50,50,50},;                     
			oDlg,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )
			
			aBrowse := {}
			aBrowse := CarregaArray(cCondPers)
			oBrowse:SetArray(aBrowse)
		
			/*oBrowse:AddColumn(TCColumn():New(''  , {|| if(aBrowse[oBrowse:nAt,1],oOk,oNo) }  ,,,,,,.T.,.F.,,,,.F.,))
			oBrowse:AddColumn(TCColumn():New(''  ,{|| aBrowse[oBrowse:nAt,1] },,,,,,.T.,.F.,,,,.F.,))
			oBrowse:AddColumn(TCColumn():New("Pedido",{||aBrowse[oBrowse:nAt,1] },,,,"LEFT",,.F.,.F.,,,,.F.,))
			oBrowse:AddColumn(TCColumn():New("Item",{||SC9->C9_ITEM },,,,"LEFT",,.F.,.F.,,,,.F.,))
			oBrowse:AddColumn(TCColumn():New("Cliente",{||SC9->C9_CLIENTE },,,,"LEFT",,.F.,.F.,,,,.F.,))
			oBrowse:AddColumn(TCColumn():New("Loja",{||SC9->C9_LOJA },,,,"LEFT",,.F.,.F.,,,,.F.,))
			oBrowse:AddColumn(TCColumn():New("Produto",{||SC9->C9_PRODUTO },,,,"LEFT",,.F.,.F.,,,,.F.,))
			oBrowse:AddColumn(TCColumn():New("Qt Liberada",{||SC9->C9_QTDLIB },"@E 999,999,999.99",,,"RIGHT",,.F.,.F.,,,,.F.,))
			oBrowse:AddColumn(TCColumn():New("Nota Fiscal",{||SC9->C9_NFISCAL },,,,"LEFT",,.F.,.F.,,,,.F.,))
			oBrowse:AddColumn(TCColumn():New("Serie NF",{||SC9->C9_SERIENF },,,,"LEFT",,.F.,.F.,,,,.F.,))
			oBrowse:AddColumn(TCColumn():New("DT Liberacao",{||SC9->C9_DATALIB },,,,"LEFT",,.F.,.F.,,,,.F.,))
			oBrowse:AddColumn(TCColumn():New("Sequencia",{||SC9->C9_SEQUEN },,,,"LEFT",,.F.,.F.,,,,.F.,))
			oBrowse:AddColumn(TCColumn():New("Grupo",{||SC9->C9_GRUPO },,,,"LEFT",,.F.,.F.,,,,.F.,))
			oBrowse:AddColumn(TCColumn():New("Prc Venda",{||SC9->C9_PRCVEN },"@E 999,999,999.99",,,"RIGHT",,.F.,.F.,,,,.F.,))
			oBrowse:AddColumn(TCColumn():New("Agreg. liber.",{||SC9->C9_AGREG },,,,"LEFT",,.F.,.F.,,,,.F.,))
			oBrowse:AddColumn(TCColumn():New("Bloq.Estoque",{||SC9->C9_BLEST },,,,"LEFT",,.F.,.F.,,,,.F.,))
			oBrowse:AddColumn(TCColumn():New("Bloq.Credito",{||SC9->C9_BLCRED },,,,"LEFT",,.F.,.F.,,,,.F.,))
			oBrowse:AddColumn(TCColumn():New("N do Remito",{||SC9->C9_REMITO },,,,"LEFT",,.F.,.F.,,,,.F.,))
			oBrowse:AddColumn(TCColumn():New("Item Remito",{||SC9->C9_ITEMREM },,,,"LEFT",,.F.,.F.,,,,.F.,))
			oBrowse:AddColumn(TCColumn():New("Armazem",{||SC9->C9_LOCAL },,,,"LEFT",,.F.,.F.,,,,.F.,))
			oBrowse:AddColumn(TCColumn():New("Bloqueio WMS",{||SC9->C9_BLWMS },,,,"LEFT",,.F.,.F.,,,,.F.,))
			oBrowse:AddColumn(TCColumn():New("N. da Carga",{||SC9->C9_CARGA },,,,"LEFT",,.F.,.F.,,,,.F.,))
			oBrowse:AddColumn(TCColumn():New("Seq. da Carga",{||SC9->C9_SEQCAR },,,,"LEFT",,.F.,.F.,,,,.F.,))
			oBrowse:AddColumn(TCColumn():New("Servico",{||SC9->C9_SERVIC },,,,"LEFT",,.F.,.F.,,,,.F.,))
			oBrowse:AddColumn(TCColumn():New("End. Padr�o",{||SC9->C9_ENDPAD },,,,"LEFT",,.F.,.F.,,,,.F.,))
			oBrowse:AddColumn(TCColumn():New("Estr. Fisica",{||SC9->C9_TPESTR },,,,"LEFT",,.F.,.F.,,,,.F.,))
			oBrowse:AddColumn(TCColumn():New("Qt Liberada2",{||SC9->C9_QTDLIB2 },"@E 999,999,999.99",,,"RIGHT",,.F.,.F.,,,,.F.,))
			oBrowse:AddColumn(TCColumn():New("Inf.Bloqueio",{||SC9->C9_BLINF },,,,"LEFT",,.F.,.F.,,,,.F.,))
			oBrowse:AddColumn(TCColumn():New("Seq. Empenho",{||SC9->C9_TRT },,,,"LEFT",,.F.,.F.,,,,.F.,))
			oBrowse:AddColumn(TCColumn():New("Tipo OP",{||SC9->C9_TPOP },,,,"LEFT",,.F.,.F.,,,,.F.,))
			oBrowse:AddColumn(TCColumn():New("Data Entrega",{||SC9->C9_DATENT },,,,"LEFT",,.F.,.F.,,,,.F.,))		
			*/
			oBrowse:AddColumn(TCColumn():New(''  , {|| if(aBrowse[oBrowse:nAt,1],oOk,oNo) }  ,,,,,,.T.,.F.,,,,.F.,))
			oBrowse:AddColumn(TCColumn():New(''  ,{|| aBrowse[oBrowse:nAt,2] },,,,,,.T.,.F.,,,,.F.,))
			oBrowse:AddColumn(TCColumn():New("Pedido",{||aBrowse[oBrowse:nAt,3] },,,,"LEFT",,.F.,.F.,,,,.F.,))
			oBrowse:AddColumn(TCColumn():New("Item",{||aBrowse[oBrowse:nAt,4] },,,,"LEFT",,.F.,.F.,,,,.F.,))
			oBrowse:AddColumn(TCColumn():New("Cliente",{||aBrowse[oBrowse:nAt,5] },,,,"LEFT",,.F.,.F.,,,,.F.,))
			oBrowse:AddColumn(TCColumn():New("Loja",{||aBrowse[oBrowse:nAt,6] },,,,"LEFT",,.F.,.F.,,,,.F.,))
			oBrowse:AddColumn(TCColumn():New("Produto",{||aBrowse[oBrowse:nAt,7] },,,,"LEFT",,.F.,.F.,,,,.F.,))
			oBrowse:AddColumn(TCColumn():New("Qt Liberada",{||aBrowse[oBrowse:nAt,8] },"@E 999,999,999.99",,,"RIGHT",,.F.,.F.,,,,.F.,))
			oBrowse:AddColumn(TCColumn():New("Nota Fiscal",{||aBrowse[oBrowse:nAt,9] },,,,"LEFT",,.F.,.F.,,,,.F.,))
			oBrowse:AddColumn(TCColumn():New("Serie NF",{||aBrowse[oBrowse:nAt,10] },,,,"LEFT",,.F.,.F.,,,,.F.,))
			oBrowse:AddColumn(TCColumn():New("DT Liberacao",{||aBrowse[oBrowse:nAt,11] },,,,"LEFT",,.F.,.F.,,,,.F.,))
			oBrowse:AddColumn(TCColumn():New("Sequencia",{||aBrowse[oBrowse:nAt,12] },,,,"LEFT",,.F.,.F.,,,,.F.,))
			oBrowse:AddColumn(TCColumn():New("Grupo",{||aBrowse[oBrowse:nAt,13] },,,,"LEFT",,.F.,.F.,,,,.F.,))
			oBrowse:AddColumn(TCColumn():New("Prc Venda",{||aBrowse[oBrowse:nAt,14] },"@E 999,999,999.99",,,"RIGHT",,.F.,.F.,,,,.F.,))
			oBrowse:AddColumn(TCColumn():New("Agreg. liber.",{||aBrowse[oBrowse:nAt,15] },,,,"LEFT",,.F.,.F.,,,,.F.,))
			oBrowse:AddColumn(TCColumn():New("Bloq.Estoque",{||aBrowse[oBrowse:nAt,16] },,,,"LEFT",,.F.,.F.,,,,.F.,))
			oBrowse:AddColumn(TCColumn():New("Bloq.Credito",{||aBrowse[oBrowse:nAt,17] },,,,"LEFT",,.F.,.F.,,,,.F.,))
			oBrowse:AddColumn(TCColumn():New("N do Remito",{||aBrowse[oBrowse:nAt,18] },,,,"LEFT",,.F.,.F.,,,,.F.,))
			oBrowse:AddColumn(TCColumn():New("Item Remito",{||aBrowse[oBrowse:nAt,19] },,,,"LEFT",,.F.,.F.,,,,.F.,))
			oBrowse:AddColumn(TCColumn():New("Armazem",{||aBrowse[oBrowse:nAt,20] },,,,"LEFT",,.F.,.F.,,,,.F.,))
			oBrowse:AddColumn(TCColumn():New("Bloqueio WMS",{||aBrowse[oBrowse:nAt,21] },,,,"LEFT",,.F.,.F.,,,,.F.,))
			oBrowse:AddColumn(TCColumn():New("N. da Carga",{||aBrowse[oBrowse:nAt,22] },,,,"LEFT",,.F.,.F.,,,,.F.,))
			oBrowse:AddColumn(TCColumn():New("Seq. da Carga",{||aBrowse[oBrowse:nAt,23] },,,,"LEFT",,.F.,.F.,,,,.F.,))
			oBrowse:AddColumn(TCColumn():New("Servico",{||aBrowse[oBrowse:nAt,24] },,,,"LEFT",,.F.,.F.,,,,.F.,))
			oBrowse:AddColumn(TCColumn():New("End. Padr�o",{||aBrowse[oBrowse:nAt,25] },,,,"LEFT",,.F.,.F.,,,,.F.,))
			oBrowse:AddColumn(TCColumn():New("Estr. Fisica",{||aBrowse[oBrowse:nAt,26] },,,,"LEFT",,.F.,.F.,,,,.F.,))
			oBrowse:AddColumn(TCColumn():New("Qt Liberada2",{||aBrowse[oBrowse:nAt,27] },"@E 999,999,999.99",,,"RIGHT",,.F.,.F.,,,,.F.,))
			oBrowse:AddColumn(TCColumn():New("Inf.Bloqueio",{||aBrowse[oBrowse:nAt,28] },,,,"LEFT",,.F.,.F.,,,,.F.,))
			oBrowse:AddColumn(TCColumn():New("Seq. Empenho",{||aBrowse[oBrowse:nAt,29] },,,,"LEFT",,.F.,.F.,,,,.F.,))
			oBrowse:AddColumn(TCColumn():New("Tipo OP",{||aBrowse[oBrowse:nAt,30] },,,,"LEFT",,.F.,.F.,,,,.F.,))
			oBrowse:AddColumn(TCColumn():New("Data Entrega",{||aBrowse[oBrowse:nAt,31] },,,,"LEFT",,.F.,.F.,,,,.F.,))	
			
			oBrowse:bHeaderClick := {|o,x| markAll() , oBrowse:refresh()}
			oBrowse:bLDblClick   := {|z,x| IIf(aBrowse[oBrowse:nAt,2] <> oVermelho .AND. aBrowse[oBrowse:nAt,2] <> oVerde,  aBrowse[oBrowse:nAt,1] :=  !aBrowse[oBrowse:nAt,1],) }
			
			ACTIVATE DIALOG oDlg CENTERED on Init EnchoiceBar(oDlg,bOK,bCancel,,aButtons,,,.F.,.F.,.F.,.F.,.F.)
		EndIf
	EndIf
	//����������������������������������������������������������������Ŀ
	//�Restaura a integridade da rotina                                �
	//������������������������������������������������������������������
	dbSelectArea("SC9")
	RetIndex("SC9")
	dbClearFilter()
	aEval(aIndSc9,{|x| Ferase(x[1]+OrdBagExt())})
Else
	HELP(" ",1,"SEMPERM")
Endif
RestArea(aArea)
Return(.T.)
/*/
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �A455LibAut� Autor � Rosane Luciane Chene  � Data � 18.01.95 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Rotina para gerar liberacoes automaticas de estoque        ���
�������������������������������������������������������������������������Ĵ��
���Uso       � MATA455                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function xLibA(cAlias,cCampo,nOpcE,cMarca,lInverte)

Local nOpca    := 0
Local aSays    := {}
Local aButtons := {}
Local cPerg    := "LIBAT2"
//��������������������������������������������������������������Ŀ
//� Utiliza arquivo de liberados para geracao na nota            �
//����������������������������������������������������������������
dbSelectArea(cAlias)
dbSetOrder(1)
//���������������������������������������������������������������Ŀ
//� mv_par01 Pedido de          ?                                 �
//� mv_par02 Pedido ate         ?                                 �
//� mv_par03 Cliente de         ?                                 �
//� mv_par04 Cliente ate        ?                                 �
//� mv_par05 Dta Liberacao de   ?                                 �
//� mv_par06 Dta Liberacao ate  ?                                 �
//� mv_par07 Quanto ao Estoque  ? Estoque/WMS  WMS                �
//�����������������������������������������������������������������
If Pergunte(cPerg,.T.)
//��������������������������������������������������������������Ŀ
//� Nova forma de criar dialogos para processos Batch            �
//� COMPATIVEL COM PROTHEUS (BOF)                                �
//����������������������������������������������������������������
AADD(aSays,OemToAnsi( "  Este programa  tem  como  objetivo  liberar  automaticamente os pedidos de  " ) )
AADD(aSays,OemToAnsi( "  venda com bloqueio de estoque                                               " ) )

AADD(aButtons, { 5,.T.,{||Pergunte(cPerg) } } )
AADD(aButtons, { 1,.T.,{|o| nOpca:= 1, o:oWnd:End() } } )
AADD(aButtons, { 2,.T.,{|o| o:oWnd:End() }} )

FormBatch( cCadastro, aSays, aButtons )

//��������������������������������������������������������������Ŀ
//� Ponto de entrada para validar libera��es de Estoque          �
//�                                                              �
//����������������������������������������������������������������
If ExistBlock("MTA455E")
	nOpca := ExecBlock("MTA455E",.F.,.F.)
Endif

If nOpcA == 1
		Processa({|lEnd| u_x450Processa(cAlias,.F.,.T.,@lEnd,Nil,MV_PAR07==2)},,,.T.)
	EndIf
EndIf
Return(.T.)

/*/
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �A455LibMan� Autor � Rosane Luciane Chene  � Data � 18.01.95 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Rotina para gerar liberacoes manuais                       ���
�������������������������������������������������������������������������Ĵ��
���Uso       � MATA455                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function xLibM(cAlias,nReg,nQuant,cRecnos,cPedidos,nOpcx)
Local i
Local aArea      := GetArea()
Local aSaldos    := {}
Local dLimLib    := dDataBase
Local cDescBloq  := ""
Local nOpcA      := 0
Local nQtdVen    := 0
Local nCntFor    := 0
Local nX         := 0
Local lContinua  := .T.
Local lSelLote   := GetNewPar("MV_SELLOTE","2") == "1"
Local lVersao    := (VAL(GetVersao(.F.)) == 11 .And. GetRpoRelease() >= "R6" .Or. VAL(GetVersao(.F.)) > 11)
Local aRet455Sld := Nil  // Trata retorno do Ponto de Entrada Mta455Sld
Local oDlg
Local oBtn

//-- Variaveis utilizadas pela funcao wmsexedcf
Private aLibSDB	:= {}
Private aWmsAviso:= {}

//�����������������������������������������������������������������Ŀ
//� Funcao utilizada para verificar a ultima versao dos fontes      �
//� SIGACUS.PRW, SIGACUSA.PRX e SIGACUSB.PRX, aplicados no rpo do   |
//| cliente, assim verificando a necessidade de uma atualizacao     |
//| nestes fontes. NAO REMOVER !!!                                  �
//�������������������������������������������������������������������
If !(FindFunction("SIGACUS_V") .And. SIGACUS_V() >= 20050512)
	Final("Atualizar SIGACUS.PRW !!!")
EndIf
If !(FindFunction("SIGACUSA_V") .And. SIGACUSA_V() >= 20050512)
	Final("Atualizar SIGACUSA.PRX !!!")
EndIf
If !(FindFunction("SIGACUSB_V") .And. SIGACUSB_V() >= 20050512)
	Final("Atualizar SIGACUSB.PRX !!!")
EndIf

If SC9->C9_BLCRED == "10" .AND. SC9->C9_BLEST == "10"
	HELP(" ",1,"A450NFISCA")
	lContinua:= .F.
EndIf

If !Empty(SC9->C9_BLCRED)
	If SC9->C9_BLCRED == "09"
		HELP(" ",1,"A455REJEIT")
	Else
		HELP(" ",1,"A455BLCRED")
	EndIf
	lContinua:= .F.
EndIf

If SC9->C9_LOCAL==SuperGetMV("MV_CQ", .F.,"98")
	PutHelp("PA455NOCQ",{"Libera��o manual de estoque n�o permiti","da para o almoxarifado CQ."},{"Libera��o manual de estoque n�o permiti","da para o almoxarifado CQ."},{"Libera��o manual de estoque n�o permiti","da para o almoxarifado CQ."})
	HELP(" ",1,"A455NOCQ")
	lContinua := .F.
EndIf

If SC9->C9_BLCRED == "  " .And. SC9->C9_BLEST == "  " .And. SC9->C9_BLWMS == "  "
	Help(" ",1,"A450JALIB")
	lContinua:= .F.
EndIf

If !Empty(SC9->C9_BLCRED) .And. Empty(SC9->C9_BLEST)
	Help(" ",1,"A455CREDIT")
	lContinua:= .F.
EndIf

//������������������������������������������������������������������������Ŀ
//�Caso os parametros MV_CUSFIFO e MV_FFONLIN estejam habilitados nao sera |
//|permitida a liberacao manual de estoque.                                |  
//��������������������������������������������������������������������������
If SuperGetMv("MV_CUSFIFO",.F.,.F.) .And. SuperGetMv("MV_FFONLIN",.F.,.F.)
	PutHelp ("PA450FIFO",	{"Quando utilizado o Custo Fifo On-Line"	,"n�o e permitida a libera��o manual do "	,"saldo bloqueado por estoque."	},;
							{"When used the Cost Fifo On-Line and"		,"not allowed the manual release of the"	,"balance blocked for supply."	},;
							{"Cuando utilizado el costo Fifo On-Line"	,"no permitido el lanzamiento manual del"	,"saldo bloqueado por estoque."	},;
							.F.)
	Help(" ",1,"A450FIFO")
	lContinua := .F.
EndIf

If !SoftLock(cAlias)
	lContinua:= .F.
EndIf
dbSelectArea("SC5")

dbSetOrder(1)
If dbSeek(xFilial()+SC9->C9_PEDIDO)
	If !SoftLock("SC5")
		lContinua:= .F.
	EndIf
EndIf

If ( lContinua )
	dbSelectArea(cAlias)
	cMCusto := GetMV("mv_mcusto")

	dbSelectArea("SC5")
	dbSetOrder(1)
	dbSeek(cFilial+SC9->C9_PEDIDO)

	dbSelectArea("SC6")
	dbSetOrder(1)
	dbSeek(cFilial+SC9->C9_PEDIDO+SC9->C9_ITEM+SC9->C9_PRODUTO)

	If SC5->C5_TIPO $ "DB"
		dbSelectArea("SA2")
		dbSetOrder(1)
		dbSeek(cFilial+SC5->C5_CLIENTE+SC5->C5_LOJACLI)
	Else
		dbSelectArea("SA1")
		dbSetOrder(1)
		dbSeek(cFilial+SC5->C5_CLIENTE+SC5->C5_LOJACLI)
	EndIf

	dbSelectArea("SB1")
	dbSetOrder(1)
	dbSeek(cFilial+SC9->C9_PRODUTO)

	dbSelectArea("SB2")
	dbSetOrder(1)
	dbSeek(cFilial+SC6->C6_PRODUTO+SC6->C6_LOCAL)
 
 	If lVersao
		dbSelectArea("NNR")
		dbSetOrder(1)
		dbSeek(cFilial+SC6->C6_LOCAL)
	EndIf
	
	dbSelectArea("SM2")
	dbSetOrder(1)
	dbSeek(dDataBase,.T.)

	dbSelectArea(cAlias)
	If SC9->C9_BLEST == "02"
		cDescBloq := OemToAnsi("Estoque")
	EndIf
		
	If U_aSelecL(@aSaldos,nQuant,cPedidos) == 1 // se Confirmou
		nOpca := 2
	EndIf
	
	aAux := {}
	aAux := strToKarr(cRecnos,",")
	
	For i := 1 to len(aAux)
		
		SC9->(dbGoTo(val(aAux[i])))
	
		If ( ExistBlock("MTA455P") )
			If ( !Execblock("MTA455P",.F.,.F.,{ nOpcA }) )
				nOpcA := 0
			EndIf
		EndIf
		If ExistBlock("MTA455SLD")
			If ValType(aRet455Sld := Execblock("MTA455SLD",.F.,.F.,{ nOpcA, aSaldos })) == "A"
				nOpca   := If(nOpca == 2 .And. aRet455Sld[1], 2, 0)
				aSaldos := aClone(aRet455Sld[2])
			Endif	
		Endif	
	
		If nOpcA == 2
		
			U_x450grv(1,.F.,.T.,Nil,aSaldos)
			If (Existblock("MTA455I"))
				ExecBlock("MTA455I",.f.,.f.)
			EndIf
			//-- Integrado ao wms devera avaliar as regras para convocacao do servico e disponibilizar os 
			//-- registros do SDB para convocacao
			If	IntDL() .And. !Empty(aLibSDB)
				WmsExeDCF('2')
			EndIf
		EndIf
		
	Next
EndIf
MsUnLockAll()
RestArea(aArea)
Return(.T.)


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    � A455LibAlt� Autor � Henry Fila           � Data � 01.09.03 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Retorna de liberacao manual de estoque com alteracao da    ���
���          � quantidade                                                 ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � ExpN1 := A455LibAut(ExpC1,ExpN2,ExpN3)                     ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpC1 := Alias                                             ���
���          � ExpN2 := Registro                                          ���
���          � ExpN3 := Opcao                                             ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � Nenhum                                                     ���
�������������������������������������������������������������������������Ĵ��
���Uso       � A455LibAut()                                               ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function xALib(cAlias,nReg,nOpcx)

Local aArea      := GetArea()
Local aSaldos    := {}
Local aLib       := {.T.,.T.,.T.,.T.}
Local dLimLib    := dDataBase
Local cDescBloq  := ""
Local cMCusto    := ""
Local nX         := 0
Local nOpcA      := 0
Local nQtdVen    := 0
Local nCntFor    := 0
Local nVlrCred   := 0
Local nTpLiber   := 1
Local nQtdAnt    := 0
Local lContinua  := .T.
Local lSelLote   := GetNewPar("MV_SELLOTE","2") == "1"
Local lHelp      := .T.           
Local lVersao    := (VAL(GetVersao(.F.)) == 11 .And. GetRpoRelease() >= "R6" .Or. VAL(GetVersao(.F.)) > 11)
Local nOptLib    := SuperGetMv("MV_OPLBEST",.F.,0)
Local aRet455Sld := Nil  // Trata retorno do Ponto de Entrada Mta455Sld
Local oDlg
Local oRadio
Local oBtn
//-- Define lbloqDCF somente quando NAO houver integracao com o WMS
If	!(IntDL(SC9->C9_PRODUTO) .And. !Empty(SC9->C9_SERVIC))
	//- Status dos Bloqueios do pedido de venda. Se .T. DCF gerado, tem que estornar.
	Private lbloqDCF := !Empty(SC9->C9_BLCRED+SC9->C9_BLEST)
EndIf
//�����������������������������������������������������������������Ŀ
//� Funcao utilizada para verificar a ultima versao dos fontes      �
//� SIGACUS.PRW, SIGACUSA.PRX e SIGACUSB.PRX, aplicados no rpo do   |
//| cliente, assim verificando a necessidade de uma atualizacao     |
//| nestes fontes. NAO REMOVER !!!                                  �
//�������������������������������������������������������������������
IF !(FindFunction("SIGACUS_V") .and. SIGACUS_V() >= 20050512)
    Final("Atualizar SIGACUS.PRW !!!")
Endif
IF !(FindFunction("SIGACUSA_V") .and. SIGACUSA_V() >= 20050512)
    Final("Atualizar SIGACUSA.PRX !!!")
Endif
IF !(FindFunction("SIGACUSB_V") .and. SIGACUSB_V() >= 20050512)
    Final("Atualizar SIGACUSB.PRX !!!")
Endif

If SC9->C9_BLCRED == "10" .AND. SC9->C9_BLEST == "10"
	HELP(" ",1,"A450NFISCA")
	lContinua:= .F.
EndIf
If !Empty(SC9->C9_BLCRED)
	If SC9->C9_BLCRED == "09"
		HELP(" ",1,"A455REJEIT")
	Else
		HELP(" ",1,"A455BLCRED")
	EndIf
	lContinua:= .F.
EndIf
If !Empty(SC9->C9_BLCRED) .And. Empty(SC9->C9_BLEST)
	Help(" ",1,"A455CREDIT")
	lContinua:= .F.
EndIf
If !SoftLock(cAlias)
	lContinua:= .F.
EndIf
dbSelectArea("SC5")
dbSetOrder(1)
If dbSeek(xFilial()+SC9->C9_PEDIDO)
	If !SoftLock("SC5")
		lContinua:= .F.
	EndIf
EndIf     

If !(Empty(SC9->C9_REMITO)) .And. cPaisLoc <> "BRA"
	PutHelp ("PA450REMI",	{"Este item n�o poder� ser liberado"        ,"novamente. J� existe Remito gerado para"  ,"o item."						},;
							{"This item cannot be approved "            ,"again. There is a Packing Slip "          ,"generated for the item. "	   	},;
							{"No se podra liberar este item "           ,"nuevamente. Se genero Remito para el "    ,"item."				     	},;
							.F.)
	Help(" ",1,"A450REMI")
	lContinua:= .F.
EndIf

If ( lContinua )
	dbSelectArea(cAlias)
	cMCusto := GetMV("mv_mcusto")

	dbSelectArea("SC5")
	dbSetOrder(1)
	dbSeek(cFilial+SC9->C9_PEDIDO)

	dbSelectArea("SC6")
	dbSetOrder(1)
	dbSeek(cFilial+SC9->C9_PEDIDO+SC9->C9_ITEM+SC9->C9_PRODUTO)

	If SC5->C5_TIPO $ "DB"
		dbSelectArea("SA2")
		dbSetOrder(1)
		dbSeek(cFilial+SC5->C5_CLIENTE+SC5->C5_LOJACLI)
	Else
		dbSelectArea("SA1")
		dbSetOrder(1)
		dbSeek(cFilial+SC5->C5_CLIENTE+SC5->C5_LOJACLI)
	EndIf

	dbSelectArea("SB1")
	dbSetOrder(1)
	dbSeek(cFilial+SC9->C9_PRODUTO)

	dbSelectArea("SB2")
	dbSetOrder(1)
	dbSeek(cFilial+SC6->C6_PRODUTO+SC6->C6_LOCAL)
	
 	If lVersao
		dbSelectArea("NNR")
		dbSetOrder(1)
		dbSeek(cFilial+SC6->C6_LOCAL)
	EndIf

	dbSelectArea("SM2")
	dbSetOrder(1)
	dbSeek(dDataBase,.T.)

	dbSelectArea(cAlias)
	If SC9->C9_BLEST == "02"
		cDescBloq := OemToAnsi("Estoque")
	EndIf
	
	u_aSelecL(@aSaldos,nQtdNew)
	
	If ( ExistBlock("MTA455P") )
		If ( !Execblock("MTA455P",.F.,.F.,{ nOpcA }) )
			nOpcA := 0
		EndIf
	EndIf

	If ExistBlock("MTA455SLD")
		If ValType(aRet455Sld := Execblock("MTA455SLD",.F.,.F.,{ nOpcA, aSaldos })) == "A"
			nOpca   := If(nOpca == 2 .And. aRet455Sld[1], 2, 0)
			aSaldos := aClone(aRet455Sld[2])
		Endif	
	Endif	

	If nOpcA == 2
		//������������������������������������������������������������������Ŀ
		//� Executa somente se a quantidade nova for diferente da original   �
		//��������������������������������������������������������������������
		If (SC9->C9_QTDLIB <> nQtdNew) .Or. lSelLote
			Begin Transaction
				nVlrCred := 0
				nQtdAnt  := SC9->C9_QTDLIB - nQtdNew

				//��������������������������������������������������������������Ŀ
				//� Estorna a liberacao atual                                    �
				//����������������������������������������������������������������
				SC9->(A460Estorna(/*lMata410*/,/*lAtuEmp*/,@nVlrCred))
				//��������������������������������������������������������������Ŀ
				//� Libera novamente de acordo com a opcao do radio selecionada  �
				//����������������������������������������������������������������
				If Len(aSaldos)>0
					For nX := 1 To Len(aSaldos)
						If nQtdNew > 0
							RecLock("SC6")
							SC6->C6_LOTECTL := aSaldos[nX][1]
							SC6->C6_NUMLOTE := aSaldos[nX][2]
							//-- Grava o endereco somente quando NAO ha integracao com o wms
							If	!(IntDL(SC6->C6_PRODUTO) .And. !Empty(SC6->C6_SERVIC))
								SC6->C6_LOCALIZ := aSaldos[nX][3]
    						EndIf
							SC6->C6_NUMSERI := aSaldos[nX][4]
							SC6->C6_DTVALID := aSaldos[nX][7]
							SC6->C6_POTENCI := aSaldos[nX][6]
							U_xLibdoFat(SC6->(RecNo()),Min(aSaldos[nX][5],nQtdNew),aLib[1],aLib[2],aLib[3],aLib[4],.F.,.F.,/*aEmpenho*/,/*bBlock*/,/*aEmpPronto*/,/*lTrocaLot*/,/*lOkExpedicao*/,@nVlrCred,/*nQtdalib2*/)
							nQtdNew -= aSaldos[nX][5]
							SC6->C6_LOTECTL := ''//aSaldos[nX][1]
							SC6->C6_NUMLOTE := ''//aSaldos[nX][2]
							SC6->C6_LOCALIZ := ''//aSaldos[nX][3]
							SC6->C6_NUMSERI := ''//aSaldos[nX][4]
							SC6->C6_DTVALID := Ctod('')//aSaldos[nX][7]
							SC6->C6_POTENCI := 0//aSaldos[nX][6]
						EndIf
					Next nX
				Else
					U_xLibdoFat(SC6->(RecNo()),@nQtdNew,aLib[1],aLib[2],aLib[3],aLib[4],.F.,.F.,/*aEmpenho*/,/*bBlock*/,/*aEmpPronto*/,/*lTrocaLot*/,/*lOkExpedicao*/,@nVlrCred,/*nQtdalib2*/)
				EndIf
				If ( SuperGetMv("MV_GRVBLQ2" ) .And. nQtdAnt > 0)
					u_xLibdoFat(SC6->(RecNo()),@nQtdAnt,.T.,.F.,.T.,.F.,.F.,.F.,/*aEmpenho*/,/*bBlock*/,/*aEmpPronto*/,/*lTrocaLot*/,/*lOkExpedicao*/,@nVlrCred,/*nQtdalib2*/)
				EndIf
				SC6->(MaLiberOk({SC9->C9_PEDIDO},.F.))
			End Transaction
		Endif	
		If (Existblock("MTA455NL"))
			ExecBlock("MTA455NL",.f.,.f.)
		EndIf
	EndIf
EndIf
MsUnLockAll()
RestArea(aArea)
Return(.T.)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    � A455QtdL  � Autor � Henry Fila           � Data � 01.09.03 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Consistencia da quantidade liberada                        ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � ExpL1 := A455QtdL(ExpN1)                                   ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpN1 := Quantidade                                        ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � .T. ou .F.                                                 ���
�������������������������������������������������������������������������Ĵ��
���Uso       � A455LibAlt()                                               ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function xAQtd(nQuant)

Local aTam      := TamSX3("C6_QTDVEN")

Local cProduto  := ""
Local cAlias    := Alias()
Local cGrade    := ""

Local nQtdEnt   := 0
Local nQtdLib   := 0
Local nQtdVen   := 0
Local nQtdOri   := SC9->C9_QTDLIB

Local lRsDoFAt  := IIF(SuperGetMv("MV_RSDOFAT") == "S",.F.,.T.)
Local lBloq     := .F.
Local lGrade    := MaGrade()
Local lRet      := .T.

nQtdLib  := nQuant

If (nQtdOri <> nQtdLib)

	If Empty(SC9->C9_RESERVA) 

		SC6->(dbsetOrder(1))
		If SC6->(MsSeek(xFilial("SC6")+SC9->C9_PEDIDO+SC9->C9_ITEM+SC9->C9_PRODUTO))

			cProduto  := SC6->C6_PRODUTO
			lBloq     := (AllTrim(SC6->C6_BLQ) $ "RS" )
			nQtdVen   := SC6->C6_QTDVEN
			nQtdEnt   := SC6->C6_QTDENT
			cGrade    := SC6->C6_GRADE

			If lGrade
				MatGrdPrrf(@cProduto)
			Endif

			If ( lBloq .And. lRsDoFat .and. nQtdLib > 0  )
				Help(" ",1,"A410ELIM")
				lRet := .F.
			Endif

			If lRet
				If SuperGetMv("MV_LIBACIM")
					If !lGrade  .Or. cGrade <> "S"
						If Round(nQtdLib,aTam[2]) > Round(SC6->C6_QTDVEN - (SC6->C6_QTDEMP+SC6->C6_QTDENT)+nQtdOri,aTam[2])
							Help(" ",1,"A440QTDL")
							lRet := .F.
						Endif
					EndIf
				Endif
			Endif
		Endif
	Else
		Help(" ",1,"A455RESERV")//"Alteracao nao permitida pois a liberacao possui reserva."
		lRet := .f.
	Endif
Endif

dbSelectArea(cAlias)
Return( lRet )

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    � A455Ok    � Autor � Henry Fila           � Data � 01.09.03 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Consistencia se o produto possui rastrabilidade            ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � ExpL1 := A455QtdL(ExpN1,ExpN2)                             ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpN1 := Opcao                                             ���
���          � ExpN2 := Quantidade                                        ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � .T. ou .F.                                                 ���
�������������������������������������������������������������������������Ĵ��
���Uso       � A455LibAlt()                                               ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function xAOK(nOpcao,nQtdNew)

Local lRet := .T.

If (Rastro(SC9->C9_PRODUTO) .Or. Localiza(SC9->C9_PRODUTO)) .And. (nQtdNew <> SC9->C9_QTDLIB) .And.;
	nOpcao == 3
	Help(" ",1,"A455LOCAL") //"Liberacao manual nao permitida pois o produto possui rastreabilidade ou localizacao fisica"
	lRet := .F.
Endif

Return(lRet)


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �A455SelLote� Autor �Eduardo Riera         � Data �16.09.2003���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Permite ao usuario selecionar ou alterar o Numero do Lote e���
���          � Localiza��o na Liberacao Manual de Estoque...              ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpA1: Array dos saldos a Liberar                          ���
���          � ExpN2: Quantidade a Liberar                                ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � ExpA1 := aSaldo, array com elementos alterados...          ���
�������������������������������������������������������������������������Ĵ��
���Uso       � MATA455                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function aSelecL(aSaldos,nQtdALib,cPedidos)

Local aArea      := GetArea()
Local aAreaSB2   := SB2->(GetArea())
Local aBrowse    := {}
Local aStruTrb   := {}
Local aSldLote   := {}
Local aObjects   := {}
Local aSize      := MsAdvSize( .F. )
Local aPosObj    := {}
Local aInfo      := {}
Local aAux       := {}
Local nX         := 0
Local nOpcA      := 0
Local nQtdSel    := 0
Local cArquivo   := ""
Local cCursor    := "TRB"
Local lUsaVenc   := IIf(!Empty(SC9->C9_LOTECTL+SC9->C9_NUMLOTE),.T.,(SuperGetMv('MV_LOTVENC')=='S'))
Local lLote      := (SuperGetMv("MV_SELPLOT",.F.,"2") == "1")
Local lInfoWms   := (IntDL(SC9->C9_PRODUTO) .And. !Empty(SC9->C9_SERVIC))
Local oDlg
Local oMark
Local oQtdSel
Local lValSel    :=  Existblock("MTA455VL")               ///// Vari�vel para valida��o da tela no ponto de entrada "MTA455VL"
Local lSelLtNew := SuperGetMv("MV_SELTNEW",.F.,.F.)
//��������������������������������������������������������������Ŀ
//� MV_VLDLOTE - Utilizado para visualizar somente os lotes que  | 
//| possuem o campo B8_DATA com o valor menor ou igual a database|
//| do sistema                                                   �
//����������������������������������������������������������������
Local lVldDtLote := SuperGetMV("MV_VLDLOTE",.F.,.T.)

aSaldos := {}

If SC9->C9_QTDRESE == 0

	//��������������������������������������������������������Ŀ
	//� Define arquivo de trabalho                             �
	//����������������������������������������������������������
	aadd(aStruTrb,{"TRB_OK","C",2,0})
	aadd(aStruTrb,{"TRB_LOTECT","C",TamSx3("C6_LOTECTL")[1],TamSx3("C6_LOTECTL")[2]})
	aadd(aStruTrb,{"TRB_NUMLOT","C",TamSx3("C6_NUMLOTE")[1],TamSx3("C6_NUMLOTE")[2]})
	aadd(aStruTrb,{"TRB_LOCALI","C",TamSx3("C6_LOCALIZ")[1],TamSx3("C6_LOCALIZ")[2]})
	aadd(aStruTrb,{"TRB_POTENC","N",TamSx3("C6_POTENCI")[1],TamSx3("C6_POTENCI")[2]})
	aadd(aStruTrb,{"TRB_NUMSER","C",TamSx3("C6_NUMSERI")[1],TamSx3("C6_NUMSERI")[2]})
	aadd(aStruTrb,{"TRB_QTDLIB","N",TamSx3("C6_QTDLIB")[1] ,TamSx3("C6_QTDLIB")[2]})
	If lSelLtNew
		aadd(aStruTrb,{"TRB_QTDSEL","N",TamSx3("C6_QTDLIB")[1] ,TamSx3("C6_QTDLIB")[2]})
	EndIf
	aadd(aStruTrb,{"TRB_DTVALI","D",TamSx3("C6_DTVALID")[1],TamSx3("C6_DTVALID")[2]})

	aadd(aBrowse,{"TRB_OK",,""})
	//aadd(aBrowse,{"TRB_LOTECT",,RetTitle("C6_LOTECTL")})
	//aadd(aBrowse,{"TRB_NUMLOT",,RetTitle("C6_NUMLOTE")})
	aadd(aBrowse,{"TRB_LOCALI",,RetTitle("C6_LOCALIZ")})
	//aadd(aBrowse,{"TRB_POTENC",,RetTitle("C6_POTENCI")})
	//aadd(aBrowse,{"TRB_NUMSER",,RetTitle("C6_NUMSERI")})
	If lSelLtNew
		aadd(aBrowse,{"TRB_QTDLIB",,"Qtde Dispon�vel"}) //-- Qtde Dispon�vel
		aadd(aBrowse,{"TRB_QTDSEL",,"Qtde Selecionada"}) //-- Qtde Selecionada
	Else
		aadd(aBrowse,{"TRB_QTDLIB",,RetTitle("C6_QTDLIB")})
	EndIf
	//aadd(aBrowse,{"TRB_DTVALI",,RetTitle("C6_DTVALID")})

	If ExistBlock("A455SLT1")
		aAux := ExecBlock("A455SLT1",.F.,.F.,{aStruTrb,aBrowse})
		aStruTrb := aAux[1]
		aBrowse  := aAux[2]
	EndIf

	cArquivo := CriaTrab(aStruTrb,.T.)
	dbUseArea(.T.,__localDriver,cArquivo,"TRB",.F.,.F.)

	If ExistBlock("A455VENC")
		lUsaVenc := ExecBlock("A455VENC",.F.,.F.)
	EndIf	
		
	dbSelectArea("SB2")
	dbSetOrder(1)
	MsSeek(xFilial("SB2")+SC9->C9_PRODUTO+SC9->C9_LOCAL)

	//���������������������������������������������������������������������������������Ŀ
	//�Deve-se obter o saldo do produto pela funcao SaldoSB2 sem considerar os empenhos.�
	//�A funcao SldPorLote fara o tratamento correto dos lotes/enderecos ja empenhados, �
	//�exibindo todos os enderecos/numeros de serie disponiveis.                        �
	//�����������������������������������������������������������������������������������
	aSldLote := SldPorLote(SC9->C9_PRODUTO,SC9->C9_LOCAL,SaldoSb2(nil,.F.),0,Iif(lLote,Nil,SC9->C9_LOTECTL),Iif(lLote,Nil,SC9->C9_NUMLOTE),SC6->C6_LOCALIZ,SC6->C6_NUMSERI,NIL,NIL,NIL,lUsaVenc,,,IIf(lVldDtLote,dDataBase,Nil),lInfoWms)
	
	//��������������������������������������������������������Ŀ
	//� Monta o arquivo de trabalho                            �
	//����������������������������������������������������������
	For nX := 1 To Len(aSldLote)
		RecLock("TRB",.T.)
		TRB->TRB_OK := ""
		TRB->TRB_LOTECT := aSldLote[nX][01]
		TRB->TRB_NUMLOT := aSldLote[nX][02]
		TRB->TRB_LOCALI := aSldLote[nX][03]
		TRB->TRB_NUMSER := aSldLote[nX][04]
		TRB->TRB_QTDLIB := aSldLote[nX][05]
		TRB->TRB_POTENC := aSldLote[nX][12]
		TRB->TRB_DTVALI := aSldLote[nX][07]
		If ExistBlock("A455SLT2")
			ExecBlock("A455SLT2",.F.,.F.)
		EndIf
		MsUnLock()
	Next nX
	TRB->(dbGotop())


	//��������������������������������������������������������������������������Ŀ
	//�Passo parametros para calculo da resolucao da tela                        �
	//����������������������������������������������������������������������������
	aObjects := {}
	aadd( aObjects, { 100, 030, .T., .F. } )
	aadd( aObjects, { 100, 090, .T., .T. } )
	aInfo    := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 0, 0 }
	aPosObj  := MsObjSize( aInfo, aObjects, .T. )

	DEFINE MSDIALOG oDlg FROM aSize[7], 000 TO aSize[6], aSize[5] TITLE OemToAnsi("Escolha de Lotes") PIXEL //"Escolha de Lotes"
	DEFINE SBUTTON FROM aPosObj[1,1]+010,aPosObj[1,4]-070 TYPE 1 ACTION (nOpcA:=1,Iif(lValSel,(ExecBlock("MTA455VL",.f.,.f.,{"TRB"}),(lSelecao := .T., oDlg:End(),.T.),.F.),oDlg:End()))  ENABLE OF oDlg
	DEFINE SBUTTON FROM aPosObj[1,1]+010,aPosObj[1,4]-035 TYPE 2 ACTION (nOpcA:=2,oDlg:End()) ENABLE OF oDlg
	@ aPosObj[1,1],aPosObj[1,2] TO aPosObj[1,3],aPosObj[1,4] LABEL "" OF oDlg  PIXEL
	@ aPosObj[1,1]+010,010 SAY OemToAnsi("Qtd.neste Item")	SIZE 46, 7 OF oDlg PIXEL //"Qtd.neste Item"
	@ aPosObj[1,1]+010,072 SAY nQtdALib PICTURE PesqPictQt("C9_QTDLIB",10) SIZE 53, 7 OF oDlg PIXEL
	
	@ aPosObj[1,1]+010,120 SAY OemToAnsi("Qtd.Selecionada") SIZE 46, 7 OF oDlg PIXEL 		  //"Qtd.Selecionada"
	@ aPosObj[1,1]+010,160 SAY oQtdSel	 VAR nQtdSel Picture PesqPictQt("C9_QTDLIB",10) SIZE 53, 7 OF oDlg PIXEL
	
	@ aPosObj[1,1]+010,230 SAY OemToAnsi("Referente ao(s) Pedido(s):") SIZE 100, 7 OF oDlg PIXEL 
	@ aPosObj[1,1]+010,320 SAY cPedidos SIZE 100, 7 OF oDlg PIXEL 
	
	@ aPosObj[1,1]+020,230 SAY OemToAnsi("Produto:") SIZE 100, 7 OF oDlg PIXEL 
	@ aPosObj[1,1]+020,320 SAY alltrim(SC9->C9_PRODUTO) + " - " + Posicione("SB1",1,xFilial("SB1") + SC9->C9_PRODUTO,"B1_DESC" ) SIZE 100, 7 OF oDlg PIXEL 
	
	oMark := MsSelect():New("TRB","TRB_OK",Nil,aBrowse,.F.,Nil,{aPosObj[2,1]+3,aPosObj[2,2],aPosObj[2,3]-3,aPosObj[2,4]})
	If lSelLtNew
		oMark:bAVal := {|| MarkLote(@oQtdSel,nQtdALib,@nQtdSel)}
	Else
		oMark:bAval := {|| lOk := nQtdSel>nQtdALib.And.!TRB->(IsMark("TRB_OK",ThisMark(),ThisInv())),;
			TRB->TRB_OK:=IIf(TRB->(IsMark("TRB_OK",ThisMark(),ThisInv())).Or.lOk,"",ThisMark()),;
			nQtdSel := IIf(lOk,nQtdSel,IIf(TRB->(IsMark("TRB_OK",ThisMark(),ThisInv())),nQtdSel+TRB->TRB_QTDLIB,nQtdSel-TRB->TRB_QTDLIB)),;
			oQtdSel:SetText(nQtdSel) }
	EndIf
	oMark:oBrowse:lHasMark    := .T.
	oMark:oBrowse:lCanAllmark := .F.

	If (Existblock("MTA455ML"))
		nQtdSel := ExecBlock("MTA455ML",.f.,.f.,{"TRB"})
	EndIf

	ACTIVATE MSDIALOG oDlg VALID nQtdSel >= nQtdALib

	//��������������������������������������������������������������������������Ŀ
	//�Verifico os lotes escolhidos                                              �
	//����������������������������������������������������������������������������
	If nOpcA == 1
		dbSelectArea("TRB")
		dbGotop()
		While !Eof()
			If IsMark("TRB_OK",ThisMark(),ThisInv())
				If lSelLtNew
					aadd(aSaldos,{TRB->TRB_LOTECT,TRB->TRB_NUMLOT,TRB->TRB_LOCALI,TRB->TRB_NUMSER,TRB->TRB_QTDSEL,TRB->TRB_POTENC,TRB->TRB_DTVALI})
				Else
					aadd(aSaldos,{TRB->TRB_LOTECT,TRB->TRB_NUMLOT,TRB->TRB_LOCALI,TRB->TRB_NUMSER,TRB->TRB_QTDLIB,TRB->TRB_POTENC,TRB->TRB_DTVALI})
				EndIf
			EndIf
			dbSelectArea("TRB")
			dbSkip()
		EndDo
	EndIf
	dbSelectArea("TRB")
	dbCloseArea()
	FErase(cArquivo+GetDbExtension())
Else
    Help(" ",1,"MT455RESV",,OemtoAnsi("Este item possui reserva especifica de um lote."),1,0)
Endif

RestArea(aArea)
Return(nOpcA)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MarkLote �Autor  � Andre Anjos        � Data �  16/08/12   ���
�������������������������������������������������������������������������͹��
���Descricao � No duplo clique da selecao de lote exibe tela para informar���
���          � quantidade a selecionar.                                   ���
�������������������������������������������������������������������������͹��
���Parametros� oQtdSel: say da quantidade total selecionada.			  ���
���			 � nQtdALib: quantidade do item da liberacao.				  ���
���			 � nQtdSel: quantidade selecionada para o item da liberacao.  ���
�������������������������������������������������������������������������͹��
���Uso       � MATA455                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function MarkLote(oQtdSel,nQtdALib,nQtdSel)
Local lOk     := nQtdSel > nQtdALib .And. !TRB->(IsMark("TRB_OK",ThisMark(),ThisInv()))
Local nQtde   := 0
Local oDlg    := NIL
Local lMarcou := .F.

TRB->TRB_OK := If(TRB->(IsMark("TRB_OK",ThisMark(),ThisInv())) .Or. lOk,"",ThisMark())
If !lOk
	If TRB->TRB_OK == ThisMark()
		nQtde := Min(TRB->TRB_QTDLIB,nQtdALib - nQtdSel)
		oDlg := MSDialog():New(0,0,80,155,"Qtde Selecionada",,,,,,,,oMainWnd,.T.) //-- Qtde Selecionada
		TGet():Create(oDlg,{|u| If(PCount()>0,nQtde:= u,nQtde)},5,5,70,10,PesqPict("SC6","C6_QTDLIB"),{|| MarkVldQtd(nQtdALib,nQtdSel,nQtde)},,,,,,.T.,,,,,,,,,,"nQtde")
		TButton():Create(oDlg,20,5,"OK",{|| lMarcou := .T.,oDlg:End()},70,10,,,,.T.)
		oDlg:Activate(,,,.T.)
		
		If lMarcou .And. nQtde > 0
			TRB->TRB_QTDSEL := nQtde
			nQtdSel += TRB->TRB_QTDSEL
		Else
			TRB->TRB_OK := ""
		EndIf
	Else
		nQtdSel -= TRB->TRB_QTDSEL
		TRB->TRB_QTDSEL := 0
	EndIf
EndIf
oQtdSel:SetText(nQtdSel)

Return lOk

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MarkVldQtd�Autor  � Andre Anjos		 � Data �  17/08/12   ���
�������������������������������������������������������������������������͹��
���Descricao � Funcao que valida a quantidade de selecionada do lote/end. ���
�������������������������������������������������������������������������͹��
���Parametros� nQtdALib: quantidade do item da liberacao.				  ���
���			 � nQtdSel: quantidade selecionada para o item da liberacao.  ���
���			 � nQtde: quantidade digitada na selecao do lote/endereco.	  ���
�������������������������������������������������������������������������͹��
���Uso       � MATA455                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function MarkVldQtd(nQtdALib,nQtdSel,nQtde)
Local lRet

lRet := nQtde >= 0 .And.;					//-- Qtde deve ser positiva
		nQtde <= TRB->TRB_QTDLIB .And.; 	//-- Qtde deve ser menor ou igual ao saldo do lote
		nQtde <= nQtdALib - nQtdSel			//-- Qtde deve ser menor ou igual ao saldo a selecionar

If !lRet
	Help(" ",1,"QTDNVLD",,"Quantidade inv�lida. A quantidade n�o pode ser maior que o saldo do lote/endere�o ou saldo a selecionar.",1,1) //-- Quantidade inv�lida. A quantidade n�o pode ser maior que o saldo do lote/endere�o ou saldo a selecionar.
EndIf

Return lRet

/*/
���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �MenuDef   � Autor � Marco Bianchi         � Data �01/09/2006���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Utilizacao de menu Funcional                               ���
���          �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Array com opcoes da rotina.                                 ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Parametros do array a Rotina:                               ���
���          �1. Nome a aparecer no cabecalho                             ���
���          �2. Nome da Rotina associada                                 ���
���          �3. Reservado                                                ���
���          �4. Tipo de Transa��o a ser efetuada:                        ���
���          �    1 - Pesquisa e Posiciona em um Banco de Dados           ���
���          �    2 - Simplesmente Mostra os Campos                       ���
���          �    3 - Inclui registros no Bancos de Dados                 ���
���          �    4 - Altera o registro corrente                          ���
���          �    5 - Remove o registro corrente do Banco de Dados        ���
���          �5. Nivel de acesso                                          ���
���          �6. Habilita Menu Funcional                                  ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function MenuDef()

Private aRotina := {	{ "Pesquisar","PesqBrw"			, 0 , 1,0,.F.},;	// "Pesquisar"
						{ "Automatica","U_xLibA"		, 0 , 0,0,NIL},;	// "Autom�tica"
						{ "Manual","U_xLibM"			, 0 , 0,0,NIL},;	// "Manual"
						{ "Nova Liberacao","U_xALib"	, 0 , 0,0,NIL},;	// "Nova Liberacao"
						{ "Legenda","U_A450Legend"		, 0 , 3,0,.F.} }	// "Legenda"

If ExistBlock("MA455MNU")
	ExecBlock("MA455MNU",.F.,.F.)
EndIf

Return(aRotina)

















/*/
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Fun��o    �A450Grava � Rev.  � Eduardo Riera         � Data �02.02.2002 ���
��������������������������������������������������������������������������Ĵ��
���          �Rotina de atualizacao da liberacao de credito                ���
���          �                                                             ���
��������������������������������������������������������������������������Ĵ��
���Parametros�ExpN1: 1 - Liberacao                                         ���
���          �       2 - Rejeicao                                          ���
���          �ExpL2: Indica uma Liberacao de Credito                       ���
���          �ExpL3: Indica uma liberacao de Estoque                       ���
���          �ExpL4: Indica se exibira o help da liberacao                 ���
���          �ExpA5: Saldo dos lotes a liberar                             ���
���          �ExpA6: Forca analise da liberacao de estoque                 ���
��������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                       ���
���          �                                                             ���
��������������������������������������������������������������������������Ĵ��
���Descri��o �Esta rotina realiza a atualizacao da liberacao de pedido de  ���
���          �venda com base na tabela SC9.                                ���
���          �                                                             ���
��������������������������������������������������������������������������Ĵ��
���Uso       � Materiais                                                   ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
/*/
User Function x450grv(nOpc,lAtuCred,lAtuEst,lHelp,aSaldos,lAvEst)

Local aArea     := GetArea()
Local aAreaC9   := SC9->(GetArea())
Local aSaldoP3  := {}

Local lCredito  := Empty(SC9->C9_BLCRED)

Local nQtdEst   := 0
Local nMCusto   :=  Val(SuperGetMv("MV_MCUSTO"))
Local nQtdPoder3:= 0
Local nQtdEmP3  := 0
Local nQtdALib  := 0
Local lEstoque  := .F.
Local lMvAvalEst:= SuperGetMv("MV_AVALEST")==2
Local lBlqEst   := SuperGetMv("MV_AVALEST")==3 .And. Empty(aSaldos)
Local cLiberOk := ""
Local cBlq      := ""
Local cBloquei  := ""
Local nX

DEFAULT lHelp   := .T.
DEFAULT aSaldos := {}
DEFAULT lAvEst  := .F.

//- Status dos Bloqueios do pedido de venda. Se .T. DCF gerado, tem que estornar.
Private lbloqDCF := !Empty(SC9->C9_BLCRED+SC9->C9_BLEST)
lBlqEst := lBlqEst .And. !lAvEst
//������������������������������������������������������������������������Ŀ
//�Posiciona Registros                                                     �
//��������������������������������������������������������������������������
dbSelectArea("SC5")
dbSetOrder(1)
MsSeek(xFilial("SC5")+SC9->C9_PEDIDO)

dbSelectArea("SC6")
dbSetOrder(1)
MsSeek(xFilial("SC6")+SC9->C9_PEDIDO+SC9->C9_ITEM+SC9->C9_PRODUTO)

dbSelectArea("SA1")
dbSetOrder(1)
MsSeek(xFilial("SA1")+SC9->C9_CLIENTE+SC9->C9_LOJA)

dbSelectArea("SF4")
dbSetOrder(1)
MsSeek(xFilial("SF4")+SC6->C6_TES)
//������������������������������������������������������������������������Ŀ
//�Moeda Forte do Cliente                                                  �
//��������������������������������������������������������������������������
nMCusto:= If (SA1->A1_MOEDALC > 0, SA1->A1_MOEDALC, nMCusto)					
dbSelectArea("SB2")
dbSetOrder(1)
MsSeek(cFilial+SC6->C6_PRODUTO+SC6->C6_LOCAL)

//������������������������������������������������������������������������Ŀ
//�Liberacao do SC9                                                        �
//��������������������������������������������������������������������������
If ( nOpc == 1 )
	Begin Transaction
		//������������������������������������������������������������������������Ŀ
		//�Travamento dos Registros                                                �
		//��������������������������������������������������������������������������
		If !(SC5->C5_TIPO $ "DB")
			RecLock("SA1",.F.)
		EndIf
		RecLock("SC5",.F.)
		RecLock("SC6",.F.)
		RecLock("SC9",.F.)
		If ( SB2->(Found()) )
			RecLock("SB2",.F.)
		EndIf
		//������������������������������������������������������������������������Ŀ
		//�Calcula a quantidade disponivel em estoque                              �
		//��������������������������������������������������������������������������
		nQtdEst :=SC9->C9_QTDLIB
		If ( Empty(SC9->C9_RESERVA) .And. !Empty(SC9->C9_BLCRED+SC9->C9_BLEST) .And. SF4->F4_ESTOQUE == "S")				
			If lBlqEst
				lEstoque := .F.
			Else
				If Empty(aSaldos)
					lEstoque := A440VerSB2(@nQtdEst,lMvAvalEst)
				Else          
					lEstoque := A440VerSB2(@nQtdEst,lMvAvalEst,,,,.F.)
				EndIf
			EndIf
		Else
			lEstoque := .T.
		EndIf
		If ( nQtdEst == 0 )
			nQtdEst  := SC9->C9_QTDLIB
			lEstoque := .F.
		EndIf
		//������������������������������������������������������������������������Ŀ
		//�Avaliacao de Credito                                                    �
		//��������������������������������������������������������������������������
		If ( lAtuCred .And. !Empty(SC9->C9_BLCRED) )
			MaAvalSC9("SC9",4,Nil,Nil,Nil,.F.)
			SC9->C9_BLCRED := ""
			SC9->C9_BLEST := "02"
			MaAvalSC9("SC9",3)
			lCredito := .T.
			//������������������������������������������������������������������������Ŀ
			//�Regrava a quantidade empenha quando solicitado                          �
			//��������������������������������������������������������������������������
			If ( lMvAvalEst )
				SC6->C6_QTDEMP -= SC9->C9_QTDLIB
				SC9->C9_QTDLIB := nQtdEst
				SC9->C9_QTDLIB2 := nQtdEst * ( SC6->C6_UNSVEN / SC6->C6_QTDVEN )
				SC6->C6_QTDEMP += SC9->C9_QTDLIB
			EndIf
		EndIf
		If ( Empty(SC9->C9_BLCRED) .And. (lAtuEst .Or. lEstoque))			
			//������������������������������������������������������������������������Ŀ
			//�Avaliacao do Estoque                                                    �
			//��������������������������������������������������������������������������
			If !( SF4->F4_PODER3=='D' .And. !(SC5->C5_TIPO$"CIPD") )
				aSaldoP3   := MaNeedP3(SC9->C9_QTDLIB,IIf(Empty(SC9->C9_BLCRED+SC9->C9_BLEST),SC9->C9_QTDLIB,0))
				nQtdPoder3 := aSaldoP3[2]
				nQtdEmP3   := aSaldoP3[3]
			Else
				nQtdPoder3 := 0
				nQtdEmP3   := 0
			EndIf
			If Rastro(SC9->C9_PRODUTO) .Or. Localiza(SC9->C9_PRODUTO) .Or. !Empty(SC9->C9_RESERVA) .Or. nQtdPoder3 <> 0 .Or. nQtdEmP3 <> 0
				If (Rastro(SC9->C9_PRODUTO) .Or. Localiza(SC9->C9_PRODUTO)) .And. !lEstoque
					//Nao faz nada.
				Else

					RecLock("SC5")
					cLiberOk := SC5->C5_LIBEROK
					nQtdALib := SC9->C9_QTDLIB				
					cBlq     := SC5->C5_BLQ
					cBloquei := SC6->C6_BLOQUEI
					SC9->(a460Estorna())
					SC5->C5_BLQ     := cBlq
					SC6->C6_BLOQUEI := cBloquei
					If Len(aSaldos)>0
						For nX := 1 To Len(aSaldos)
							RecLock("SC6")
							SC6->C6_LOTECTL := aSaldos[nX][1]
							SC6->C6_NUMLOTE := aSaldos[nX][2]
							SC6->C6_LOCALIZ := aSaldos[nX][3]
							SC6->C6_NUMSERI := aSaldos[nX][4]
							SC6->C6_DTVALID := aSaldos[nX][7]
							SC6->C6_POTENCI := aSaldos[nX][6]
							
							u_xLibdoFat(SC6->(RecNo()),Min(aSaldos[nX][5],nQtdALib),@lCredito,@lEstoque,!(lAtuCred .Or. Empty(SC9->C9_BLCRED)),!Empty(SC9->C9_BLEST),.F.,.F.)
							nQtdALib -= Min(aSaldos[nX][5],nQtdALib)
							
							SC6->C6_LOTECTL := ''//aSaldos[nX][1]
							SC6->C6_NUMLOTE := ''//aSaldos[nX][2]
							SC6->C6_LOCALIZ := ''//aSaldos[nX][3]
							SC6->C6_NUMSERI := ''//aSaldos[nX][4]
							SC6->C6_DTVALID := Ctod('')//aSaldos[nX][7]
							SC6->C6_POTENCI := 0//aSaldos[nX][6]
											
						Next nX 				
					Else
						U_xLibdoFat(SC6->(RecNo()),SC9->C9_QTDLIB,@lCredito,@lEstoque,!(lAtuCred .Or. Empty(SC9->C9_BLCRED)),!Empty(SC9->C9_BLEST),.F.,.F.)
					EndIf	
					RecLock("SC5")
					SC5->C5_LIBEROK := cLiberOk
				EndIf
			Else
				//������������������������������������������������������������������������Ŀ
				//�Retira o Bloqueio de Estoque                                            �
				//��������������������������������������������������������������������������
				If SC9->C9_BLWMS == "03" .And. SC9->C9_BLEST == "  "
					MaAvalSC9("SC9",9,{{ "","","","",SC9->C9_QTDLIB,SC9->C9_QTDLIB2,Ctod(""),"","","",SC9->C9_LOCAL}})
				Else
					FatAtuEmpN("-")
					MaAvalSC9("SC9",6,{{ "","","","",SC9->C9_QTDLIB,SC9->C9_QTDLIB2,Ctod(""),"","","",SC9->C9_LOCAL}},Nil,Nil,.F.)
					SC9->C9_BLEST := ""
					MaAvalSC9("SC9",5,{{ "","","","",SC9->C9_QTDLIB,SC9->C9_QTDLIB2,Ctod(""),"","","",SC9->C9_LOCAL}})
					dbSelectArea("SC9")
					MsUnlock()
					dBCommit()
					FatAtuEmpN("+")
				EndIf
			EndIf
		EndIf
	End Transaction
	If ( (lAtuEst .And. !Empty(SC9->C9_BLEST)) ) .And. lHelp
		Help(" ",1,"A455LIBMAN",, "Liberacao manual de estoque nao permitida.", 1, 1 ) //"Liberacao manual de estoque nao permitida."
		lHelp := .F.
	EndIf
Else
	//������������������������������������������������������������������������Ŀ
	//�Rejeicao do SC9                                                         �
	//��������������������������������������������������������������������������
	Begin Transaction
		//������������������������������������������������������������������������Ŀ
		//�Efetua o Bloqueio de Credito por Rejeicao                               �
		//��������������������������������������������������������������������������
		RecLock("SC9")
		SC9->C9_BLCRED := "09"
		MsUnlock()	
	End Transaction
EndIf
RestArea(aAreaC9)
RestArea(aArea)
Return(Nil)








/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �MaLibDoFat� Autor �Eduardo Riera          � Data �09.03.99  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Liberacao dos Itens de Pedido de Venda                      ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �ExpN1: Quantidade Liberada                                  ���
�������������������������������������������������������������������������Ĵ��
���Transacao �Nao possui controle de Transacao a rotina chamadora deve    ���
���          �controlar a Transacao e os Locks                            ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpN1: Registro do SC6                                      ���
���          �ExpN2: Quantidade a Liberar                                 ���
���          �ExpL3: Bloqueio de Credito                                  ���
���          �ExpL4: Bloqueio de Estoque                                  ���
���          �ExpL5: Avaliacao de Credito                                 ���
���          �ExpL6: Avaliacao de Estoque                                 ���
���          �ExpL7: Permite Liberacao Parcial                            ���
���          �ExpL8: Tranfere Locais automaticamente                      ���
���          �ExpA9: Empenhos ( Caso seja informado nao efetua a gravacao ���
���          �       apenas avalia ).                                     ���
���          �ExpbA: CodBlock a ser avaliado na gravacao do SC9           ���
���          �ExpAB: Array com Empenhos previamente escolhidos            ���
���          �       (impede selecao dos empenhos pelas rotinas)          ���
���          �ExpLC: Indica se apenas esta trocando lotes do SC9          ���
���          �ExpND: Valor a ser adicionado ao limite de credito          ���
���          �ExpNE: Quantidade a Liberar - segunda UM                    ���
�������������������������������������������������������������������������Ĵ��
���Observacao�Deve estar numa transacao                                   ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao Efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function xLibdoFat(nRegSC6,nQtdaLib,lCredito,lEstoque,lAvCred,lAvEst,lLibPar,lTrfLocal,aEmpenho,bBlock,aEmpPronto,lTrocaLot,lOkExpedicao,nVlrCred,nQtdalib2)

Local aArea    	:= GetArea("SC6")
Local aAreaSA1 	:= SA1->(GetArea())
Local aAreaSF4 	:= SF4->(GetArea())
Local aAreaSC5 	:= {}
Local aAreaSC6 	:= {}
Local nQtdLib  	:= nQtdALib
Local nQtdLib2 	:= nQtdALib2
Local lContinua	:= .T.
Local lIntACD  	:= SuperGetMV("MV_INTACD",.F.,"0") == "1"
Local lPedLib  	:= .F.
Local lLibItPrev	:= SuperGetMV( 'MV_FATLBPR', .F., '.T.' )	//Indica se permite a libera��o de Itens previstos do Pedido de Venda

nQtdLib := nQtdALib
//������������������������������������������������������������������������Ŀ
//�Seta os parametros defaults                                             �
//��������������������������������������������������������������������������
DEFAULT nQtdALib    := SC6->C6_QTDLIB
DEFAULT nQtdALib2   := SC6->C6_QTDLIB2
DEFAULT lCredito    := .T.
DEFAULT lEstoque    := .T.
DEFAULT lAvCred     := .T.
DEFAULT lAvEst      := .T.
DEFAULT lOkExpedicao:= .F.
//������������������������������������������Ŀ
//�Verificar se o Pedido ja possui liberacao �
//��������������������������������������������
If lIntACD .And. IsInCallStack("MATA455") 
	lPedLib :=SC9->(dbSeek(xFilial("SC9")+SC6->(SC6->C6_NUM+SC6->C6_ITEM)))
EndIf

//������������������������������������������������������������������������Ŀ
//�Posiciona Pedido                                                        �
//��������������������������������������������������������������������������
If Empty(SC6->C6_BLOQUEI) .And. AllTrim(SC6->C6_BLQ)<>"R" .And. If(lPedLib,If(SC9->(FieldPos("C9_ORDSEP"))<> 0,If(Empty(SC9->C9_ORDSEP),.T.,If(!Empty(SC9->C9_ORDSEP) .And. !Empty(SC9->C9_NFISCAL),.T.,.F.)),.T.),.T.) 

	dbSelectArea("SC6")
	If nRegSC6<>0
		aAreaSC6 := GetArea()
		MsGoto(nRegSC6)
	Else
		aAreaSC6 := GetArea("SC6")
	EndIf

	If SB1->B1_FILIAL+SB1->B1_COD <> xFilial('SB1')+SC6->C6_PRODUTO
		SB1->(DbSetOrder(1))
		SB1->(MsSeek(xFilial('SB1')+SC6->C6_PRODUTO))
	Endif
	dbSelectArea("SC5")
	dbSetOrder(1)
	If ( xFilial("SC5")==SC5->C5_FILIAL .And. SC5->C5_NUM==SC6->C6_NUM )
		aAreaSC5 := GetArea("SC5")
	Else
		MsSeek(xFilial("SC5")+SC6->C6_NUM)
		aAreaSC5 := GetArea()
	EndIf
	//������������������������������������������������������������������������Ŀ
	//�Integracao com EEC													   �
	//�Funcao: AvChkStDesp()												   �
	//�Parametros: Nro do pedido de venda. 									   �
	//�Retorno: True  - O pedido de venda podera ser liberado visto que as 	   �
	//�					despesas ja foram integradas.						   �
	//�         False - O pedido de venda n�o poder� ser liberado visto que    �
	//�					existem pendencias para as despesas.				   �
	//��������������������������������������������������������������������������
	If !Empty(SC5->C5_PEDEXP)
		If FindFunction("AvChkStDesp")
			If !AvChkStDesp(SC5->C5_NUM)
				lContinua := .F.
			EndIf
		EndIf
	EndIf	
	
	//------------------------------------------------------------------------------
	// Verifica o tipo de opera��o (C6_TPOP) antes de liberar. Itens previstos n�o
	// podem ser liberados a menos que o par�metro MV_FATLBPR esteja como .T.
	// Altera��o realizada para atender o requisito de Programa��o de Entrega.
	//------------------------------------------------------------------------------
	If ( SC6->C6_TPOP == "P" ) .And. ( !lLibItPrev )
		lContinua := .F.
	EndIf
	
	If lContinua
		If nRegSC6 == 0 .Or. ( RecLock("SC5") .And. RecLock("SC6") )
			If Empty(SC5->C5_BLQ)
				If nQtdALib2 == 0 .And. SC6->C6_UNSVEN <> 0
					nQtdALib2 := SB1->(ConvUm(SC6->C6_PRODUTO,nQtdALib,Nil,2))
					If nQtdALib2 == 0
						If SC6->C6_QTDVEN-SC6->C6_QTDEMP-SC6->C6_QTDENT-nQtdALib==0
							nQtdALib2 := SC6->C6_UNSVEN-SC6->C6_QTDEMP2-SC6->C6_QTDENT2
						Else
							nQtdALib2 := nQtdALib*SC6->C6_UNSVEN/SC6->C6_QTDVEN
						EndIf
					EndIf
					SC6->C6_QTDLIB2:= nQtdALib2
					nQtdALib2 := SC6->C6_QTDLIB2
				EndIf
				SC6->C6_QTDLIB := nQtdALib
				SC6->C6_QTDLIB2:= nQtdALib2
				FatAtuEmpN("-")
				nQtdLib := xGeraC9(@nQtdLib,@lCredito,@lEstoque,lAvCred,lAvEst,lLibPar,lTrfLocal,@aEmpenho,bBlock,aEmpPronto,lTrocaLot,lOkExpedicao,@nVlrCred,@nQtdlib2)
				FatAtuEmpN("+")
			EndIf
		EndIf
	Else
		nQtdLib := 0	
	EndIf
	RestArea(aAreaSC5)
	RestArea(aAreaSC6)

Else
	nQtdLib := 0
Endif

//������������������������������������������������������������������������Ŀ
//�Restaura a Entrada                                                      �
//��������������������������������������������������������������������������
RestArea(aAreaSA1)
RestArea(aAreaSF4)
RestArea(aArea)
Return(nQtdLib)















/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �A440GeraC9� Rev.  �Eduardo Riera          � Data �22.03.99  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Gravacao do item liberado do pedido de Venda                ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � ExpN1: Quantidade realmente liberada                       ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpN1: Quantidade a Liberar                                ���
���          � ExpL2: Indica se o Credito foi Liberado                    ���
���          � ExpL3: Indica se o Estoque foi Liberado                    ���
���          � ExpL4: Avalia Credito                                      ���
���          � ExpL5: Avalia Estoque                                      ���
���          � ExpL6: Permite Liberacao Parcial                           ���
���          � ExpL7: Tranfere Locais automaticamente                     ���
���          � ExpA8: Empenhos ( Caso seja informado nao efetua a gravacao���
���          �       apenas avalia ).                                     ���
���          � Expb9: CodBlock a ser avaliado na gravacao do SC9          ���
���          � ExpAB: Array com Empenhos previamente escolhidos           ���
���          �       (impede selecao dos empenhos pelas rotinas)          ���
���          �ExpL8: Indica se apenas esta trocando lotes do SC9          ���
���          �ExpN9: Valor a ser adicionado ao limite de credito          ���
���          �ExpNA: Quantidade a Liberar na segunda UM                   ���
�������������������������������������������������������������������������Ĵ��
���Observacao� O registro do SC5/SC6 deve estar posicionado               ���
���          � Deve estar numa transacao                                  ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao Efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function xGeraC9(nQtdLib,lCredito,lEstoque,lAvCred,lAvEst,lLiber,lTransf,aEmpenho,;
							bBlock,aEmpPronto,lTrocaLot,lOkExpedicao,nVlrCred,nQtdLib2)

Local aArea     := GetArea(Alias())
Local aAreaSA1  := SA1->(GetArea())
Local aAreaSB2  := SB2->(GetArea())
Local aAreaSF4  := SF4->(GetArea())
Local aSaldos   := {}
Local aLocal    := {}

Local nSldSB6   := 0
Local cBlCred   := ""
Local cBlEst    := ""
Local cAliasSB6 := "SB6"
Local lQuery    := .F.

Local lBlqCrd   := GetMv("MV_BLQCRED")
Local lTravas   := .T.

Local nQtdJaLib := 0
Local nQtdPoder3:= 0
Local nQtdNPT   := 0
Local nQtdNosso := 0
Local lMTValAvC := ExistBlock("MTVALAVC")
Local	nValAv	 := 0
Local aEmpBN	:= If(FindFunction("A410CarBen"),A410CarBen(SC6->C6_NUM,SC6->C6_ITEM),{})
Local nX        := 0	
Local nMvTipCrd 	:= SuperGetMV("MV_TIPACRD", .F., 1)
Local nVlrTitAbe	:= 0
Local nVlrTitAtr	:= 0	

#IFDEF TOP
	Local cQuery    := ""
#ENDIF 	

//��������������������������������Ŀ
//�Tratamento para e-Commerce      �
//����������������������������������
Local lECommerce := SuperGetMV("MV_LJECOMM",,.F.) .And. GetRpoRelease("R5")
Local cOrcamto   := ""    //Obtem o orcamento original para poder posicionar na tabela MF5.

//������������������������������������������������������������������������Ŀ
//�Ajusta a Entrada da Rotina                                              �
//��������������������������������������������������������������������������
DEFAULT lAvCred     := .T.
DEFAULT lAvEst      := .T.
DEFAULT lLiber      := .F.
DEFAULT lTransf     := .F.
DEFAULT lOkExpedicao:= .F.

If ( At(SC5->C5_TIPO,"CIP") > 0 )
	lLiber := .F.
EndIf
dbSelectArea("SF4")
dbSetOrder(1)
MsSeek(xFilial("SF4")+SC6->C6_TES)

//������������������������������������������������������������������������Ŀ
//�Posiciona Registros                                                     �
//��������������������������������������������������������������������������
If ( At(SC5->C5_TIPO,"DB") == 0 .And. SF4->F4_DUPLIC=='S' )
	dbSelectArea("SA1")
	dbSetOrder(1)
	MsSeek(xFilial("SA1")+SC6->C6_CLI+SC6->C6_LOJA)
	lTravas := RecLock("SA1")
EndIf

dbSelectArea("SB2")
dbSetOrder(1)
If ( MsSeek(xFilial("SB2")+SC6->C6_PRODUTO+SC6->C6_LOCAL) .And. lTravas )
	lTravas := RecLock("SB2")
EndIf
//������������������������������������������������������������������������Ŀ
//�Verifica se o SB2 e o SA1 estao Travados                                �
//��������������������������������������������������������������������������
If ( lTravas )
	//������������������������������������������������������������������������Ŀ
	//�Complementos nao devem ter o Credito ou Estoque Avaliado.               �
	//�Devolucao de Poder de Terceiro nao deve ter o Credito avaliado.         �
	//��������������������������������������������������������������������������
	If ( AT(SC5->C5_TIPO,"CIP") > 0 .Or. ( SF4->F4_PODER3 == "D" .And. SF4->F4_ESTOQUE=="N") .Or. MaTesSel(SF4->F4_CODIGO) )
		lEstoque := .T.
		lCredito := .T.
	Else
		//������������������������������������������������������������������������Ŀ
		//�Avaliacao de Estoque                                                    �
		//��������������������������������������������������������������������������
		If ( lAvEst )
			//������������������������������������������������������������������������Ŀ
			//�Somente avalia-se estoque quando ha movimentacao e nao ha reserva       �
			//��������������������������������������������������������������������������
			If ( SF4->F4_ESTOQUE == "S" .And. Empty(SC6->C6_RESERVA) )
				If SuperGetMV("MV_AVALEST")==3 .And. (!FUNNAME() == "X455M") 
					lEstoque := .F.
					For nX := 1 To Len( aEmpBN )
						A410LibBen(1,aEmpBN[nX,1],aEmpBN[nX,2],SC6->C6_QTDVEN,SC6->C6_UNSVEN)
					Next
				Else
					lEstoque := A440VerSB2(@nQtdLib,lLiber,lTransf,@aLocal,@aEmpenho)
				EndIf
			Else
				If ( !Empty(SC6->C6_RESERVA) )
					lEstoque := .T.
					nQtdLib := Min(SC6->C6_QTDRESE,nQtdLib)
				Else
					lEstoque := .T.
				EndIf
			EndIf
		EndIf
		//������������������������������������������������������������������������Ŀ
		//�Avaliacao de Credito                                                    �
		//��������������������������������������������������������������������������
		If ( lAvCred )
			If ( !SC5->C5_TIPO $ "DB" )
				If ( SF4->F4_DUPLIC == "S" .Or. SuperGetMv("MV_LIBNODP")=="S" )
					If ( lBlqCrd .And. !lEstoque )
						lCredito := .F.
						cBlCred  := "02"
					Else
						If lMTValAvC
							nValAv	:=	ExecBLock("MTValAvC",.F.,.F.,{'xGeraC9',SC6->C6_PRCVEN*nQtdLib,Nil})
						Else
							nValAv	:=	SC6->C6_PRCVEN*nQtdLib
						Endif
						//A variavel nValItPed (Private) he criada nas funcoes:(A440Grava, A410Grava e a440Proces)
						If nMvTipCrd == 2 .AND. FindFunction("FatCredTools") .AND. Type("nValItPed") <> "U" 
							
							If nValItPed == 0
								//Consulta os titulos em aberto
								nVlrTitAbe := SldCliente(SC9->C9_CLIENTE + SC9->C9_LOJA, Nil, Nil, .F.)
								//Consulta os titulos em atraso				
								nVlrTitAtr := CrdXTitAtr(SC9->C9_CLIENTE + SC9->C9_LOJA, Nil, Nil, .F.)
							EndIf
							
							nValItPed += nValAv
							
							LJMsgRun("Aguarde... Efetuando Analise de Cr�dito.",,{|| lCredito := FatCredTools(SA1->A1_COD,SA1->A1_LOJA, nValItPed, nVlrTitAbe, nVlrTitAtr)})//"Aguarde... Efetuando Analise de Cr�dito."
							//lCredito := FatCredTools(SA1->A1_COD,SA1->A1_LOJA, nValItPed, nVlrTitAbe, nVlrTitAtr)
						Else
							lCredito := MaAvalCred(SA1->A1_COD,SA1->A1_LOJA,nValAV,SC5->C5_MOEDA,.T.,@cBlCred,@aEmpenho,@nVlrCred)
						EndIf
					EndIf
				Else
					lCredito := .T.
				EndIf
			Else
				lCredito := .T.
			EndIf
		EndIf
	EndIf
EndIf
//���������������������������������������������������������������������������Ŀ
//�Para e-Commerce ira gravar com bloqueio de credito para Boleto(FI) e sem   �
//�bloqueio para os demais.                                                   �
//�����������������������������������������������������������������������������
If  lECommerce .And. !( Empty(SC5->C5_ORCRES) ) .And. ChkFile("MF5")
    MF5->( DbSetOrder(1) ) //MF5_FILIAL+MF5_ECALIA+MF5_ECVCHV

    cOrcamto := Posicione("SL1",1,xFilial("SL1")+SC5->C5_ORCRES,"L1_ORCRES")
    
    If  !( Empty(cOrcamto) ) .And. !( Empty(Posicione("MF5",1,xFilial("MF5")+"SL1"+xFilial("SL1")+cOrcamto,"MF5_ECPEDI")) )
	    If  (Alltrim(SL1->L1_FORMPG) == "FI") .And. (MF5->MF5_ECPAGO != "1")
	    	cBlCred  := "02"
	    	lCredito := .F.
	    Else	
	    	cBlCred  := "  "
	    	lCredito := .T.
	    EndIf
    EndIf
EndIf
//������������������������������������������������������������������������Ŀ
//�Neste momento eh gerado os empenhos e o SC9 dependendo do caso          �
//��������������������������������������������������������������������������
If ( lTravas .And. (SC5->C5_TIPO$"CIP" .Or. nQtdLib > 0 .Or. MaTesSel(SF4->F4_CODIGO)) )
	//����������������������������������������������������������������������Ŀ
	//�Busca dados ref. ao Beneficiamento no SB6 para gerar Registros no SC9 �
	//������������������������������������������������������������������������
	If ( SF4->F4_PODER3=='D' .And. !(SC5->C5_TIPO$"CIPD") )
		nQtdPoder3 := nQtdLib
	Else
		If lCredito .And. lEstoque
			aSaldos := MaNeedP3(nQtdLib)
			nQtdNosso := aSaldos[1]
			nQtdPoder3:= aSaldos[2]
			nQtdNPT   := aSaldos[3]
		Else
			nQtdNosso := nQtdLib
		EndIf
	EndIf
	//������������������������������������������������������������������������Ŀ
	//�Verifica os codigos de bloqueio                                         �
	//��������������������������������������������������������������������������
	If ( Empty(cBlCred) )
		If ( !lCredito )
			If At(SC5->C5_TIPO,"DB") == 0 .And. SF4->F4_DUPLIC == 'S' .And. SC5->C5_TIPLIB == "2" .And.;
				( !Empty(SA1->A1_VENCLC) .And. SA1->A1_VENCLC < dDataBase ) .And. nVlrCred <= 0
				cBlCred := "04"		//Vencimento do Limite de Credito
			Else
				cBlCred := "01"
			EndIf
		EndIf
	EndIf
	If ( Empty(cBlEst) )
		If ( !lEstoque )
			cBlEst := "02"
		EndIf
	EndIf
	//������������������������������������������������������������������������Ŀ
	//�Tratamento da quantidade a ser liberada do poder de terceiros           �
	//��������������������������������������������������������������������������
	If nQtdPoder3 > 0
		//�����������������������������������������������������������������Ŀ
		//�Posiciona Registros                                              �
		//�������������������������������������������������������������������
		dbSelectArea("SB6")
		If Empty(SC6->C6_IDENTB6)
			dbSetOrder(1)
		Else
			dbSetOrder(3)
		EndIf		
		#IFDEF TOP
			cAliasSB6 := "xGeraC9"
			lQuery    := .T.
			aStruSB6  := SB6->(dbStruct())
			SB6->(dbCommit())						

			cQuery := "SELECT B6_FILIAL,B6_CLIFOR,B6_LOJA,B6_IDENT,B6_PRODUTO,"
			cQuery += "B6_QULIB,B6_SALDO "
			cQuery += "FROM "+RetSqlName("SB6")+" SB6 "
			cQuery += "WHERE SB6.B6_FILIAL='"+xFilial("SB6")+"' AND "
			cQuery += "SB6.B6_PRODUTO='"+SC6->C6_PRODUTO+"' AND "
			If !Empty(SC6->C6_IDENTB6)
				cQuery += "SB6.B6_IDENT='"+SC6->C6_IDENTB6+"' AND "
			EndIf
			cQuery += "(SB6.B6_SALDO-SB6.B6_QULIB)>0 AND "
			cQuery += "SB6.D_E_L_E_T_=' ' "
			cQuery += "ORDER BY "+SqlOrder(SB6->(IndexKey()))

			cQuery := ChangeQuery(cQuery)

			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSB6,.T.,.T.)
			For nX := 1 To Len(aStruSB6)
				If aStruSB6[nX][2] <> "C" .And. FieldPos(aStruSB6[nX][1])<>0
					TcSetField(cAliasSB6,aStruSB6[nX][1],aStruSB6[nX][2],aStruSB6[nX][3],aStruSB6[nX][4])
				EndIf
			Next nX
		#ELSE
			If Empty(SC6->C6_IDENTB6)
				MsSeek(xFilial("SB6")+SC6->C6_PRODUTO)
			Else
				MsSeek(xFilial("SB6")+SC6->C6_IDENTB6+SC6->C6_PRODUTO)
			EndIf
		#ENDIF
		While (!Eof() .And.  xFilial("SB6") == (cAliasSB6)->B6_FILIAL .And.;
				IIf(Empty(SC6->C6_IDENTB6),.T.,;				
				SC6->C6_IDENTB6==(cAliasSB6)->B6_IDENT) .And.;
				SC6->C6_PRODUTO==(cAliasSB6)->B6_PRODUTO .And.;
				nQtdPoder3 > 0 )
			nSldSB6 := ( (cAliasSB6)->B6_SALDO - (cAliasSB6)->B6_QULIB )
			If ( nSldSB6 > 0 )
				nSldSb6 := Min(nSldSB6,nQtdPoder3)
				If !( ( Rastro(SC6->C6_PRODUTO).Or.Localiza(SC6->C6_PRODUTO) ) .And.;
						SuperGetMv("MV_GERABLQ")=="N" .And. !lEstoque )
					MaGravaSc9(nSldSb6,cBlCred,cBlEst,@aLocal,@aEmpenho,(cAliasSB6)->B6_IDENT,bBlock,aEmpPronto,nQtdLib2,@nVlrCred)
					nQtdJaLib += nSldSb6
				EndIf
				nQtdPoder3 -= nSldSB6
			EndIf
			dbSelectArea(cAliasSB6)
			dbSkip()
		EndDo
		If lQuery
			dbSelectArea(cAliasSB6)
			dbCloseArea()
			dbSelectArea("SB6")
		EndIf
	EndIf
	//������������������������������������������������������������������������Ŀ
	//�Tratamento da quantidade a ser liberada - Nossa em Terceiros            �
	//��������������������������������������������������������������������������
	If nQtdNPT > 0
		//������������������������������������������������������������������������Ŀ
		//�Verificacao do Parametro MV_GERABLQ                                     �
		//��������������������������������������������������������������������������
		If !( (Rastro(SC6->C6_PRODUTO) .Or. Localiza(SC6->C6_PRODUTO)) .And.;
				SuperGetMv("MV_GERABLQ")=="N" .And. !lEstoque )
			MaGravaSc9(nQtdNPT,cBlCred,cBlEst,@aLocal,@aEmpenho,,bBlock,aEmpPronto,,@nVlrCred,"03")
			nQtdJaLib += nQtdNPT
		EndIf
	EndIf
	//������������������������������������������������������������������������Ŀ
	//�Tratamento da quantidade a ser liberada - Nosso Poder                   �
	//��������������������������������������������������������������������������

	If nQtdNosso > 0 .Or. MaTesSel(SF4->F4_CODIGO)	.Or. Ma440Compl()
		//������������������������������������������������������������������������Ŀ
		//�Verificacao do Parametro MV_GERABLQ                                     �
		//��������������������������������������������������������������������������
		If !( (Rastro(SC6->C6_PRODUTO) .Or. Localiza(SC6->C6_PRODUTO)) .And.;
				SuperGetMv("MV_GERABLQ")=="N" .And. !lEstoque )
			MaGravaSc9(nQtdNosso,cBlCred,cBlEst,@aLocal,@aEmpenho,,bBlock,aEmpPronto,nQtdLib2,@nVlrCred,,lOkExpedicao)
			nQtdJaLib += nQtdNosso
		EndIf
		//������������������������������������������������������������������������Ŀ
		//�Verificacao do Parametro MV_GRVBLQ2                                     �
		//��������������������������������������������������������������������������
		If ( SuperGetMv("MV_GRVBLQ2" ) .And. aEmpenho == Nil )
			If ( nQtdLib <> SC6->C6_QTDLIB ) .OR. ( SC6->C6_QTDLIB <> 0 )
				nQtdLib := SC6->C6_QTDLIB
				If ( nQtdLib <> 0 )
					If !lCredito
						lAvEst := .F.
						lEstoque := .F.
					Else
						lAvEst := .T.
					EndIf
					nQtdJaLib += xGeraC9(nQtdLib,lCredito,lEstoque,lAvCred,lAvEst,lLiber,lTransf,@aEmpenho,bBlock,aEmpPronto,lTrocaLot,lOkExpedicao,@nVlrCred)
				EndIf
			EndIf
		EndIf
	EndIf
EndIf
If ( lTravas )
	//������������������������������������������������������������������������Ŀ
	//�Atualiza a quantidade liberada para zero                                �
	//��������������������������������������������������������������������������
	If ( aEmpenho == Nil )
		SC6->C6_QTDLIB  := 0
		SC6->C6_QTDLIB2 := 0
	EndIf
EndIf
If ( !lTravas )
	lCredito := .F.
	lEstoque := .F.
	nQtdLib  := 0
EndIf
RestArea(aAreaSA1)
RestArea(aAreaSB2)
RestArea(aAreaSF4)
RestArea(aArea)
Return(nQtdJaLib)












/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �MaGravaSC9� Autor �Eduardo Riera          � Data �19.03.99  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Gravacao da Liberacao do pedido de Venda                    ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpN1: Quantidade a Ser Liberada                            ���
���          �ExpC2: Codigo do Bloqueio de Credito                        ���
���          �       "01" - Bloqueio de Credito por valor                 ���
���          �       "04" - Bloqueio por Vencimento do Limite de Credito  ���
���          �ExpC3: Codigo do Bloqueio de Estoque                        ���
���          �       "02" - Bloqueio de Estoque                           ���
���          �ExpA4: Array com os locais a serem transferidos             ���
���          �ExpA5: Empenhos ( Caso seja informado nao efetua a gravacao ���
���          �       apenas avalia ).                                     ���
���          �ExpC6: Identificador do SB6                                 ���
���          �Expb7: CodBlock a ser avaliado na gravacao do SC9           ���
���          �ExpA8: Array com Empenhos previamente escolhidos            ���
���          �       (impede selecao dos empenhos pelas rotinas)          ���
���          �ExpN9: Quantidade a ser liberada na segunda UM              ���
���          �ExpNA: Valor a ser adicionado ao limite de credito          ���
���          �ExpCB: Codigo de bloqueio do WMS                            ���
���          �           01 - Bloqueio de Enderecamento do WMS/Somente SB2���
���          �           02 - Bloqueio de Enderecamento do WMS            ���
���          �           03 - Bloqueio de WMS - Externo                   ���
�������������������������������������������������������������������������Ĵ��
���Observacao�1) Esta funcao deve gerar os empenhos de Lote e Localizacao ���
���          �2) Quando ha Reserva no SC6 os empenhos ja foram efetuados  ���
���          �   mas devem ser trocados.                                  ���
���          �3) deve estar numa transacao                                ���
���          �4) SC5/SC6 devem estar posicionados e travados              ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao Efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���16/05/2007�Norbert Waage  �Bops 125161 - Atualizacao do status do orca-���
���          �               �mento no Televendas (SIGATMK) apos liberacao���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function MaGravaSC9(nQtdLib,cBlqCred,cBlqEst,aLocal,aEmpenho,cIdentB6,bBlock,aEmpPronto,nQtdLib2,nVlrCred,cBlqWMS,lOkExpedicao)

Static lMA440GrLt
Static cTiposLC

Local aArea    	:= GetArea(Alias())
Local aAreaSA1 	:= SA1->(GetArea())
Local aAreaSB2 	:= SB2->(GetArea())
Local aAreaSF4 	:= SF4->(GetArea())
Local aAreaSB1 	:= SB1->(GetArea())
Local aAuxiliar := {}
Local aLocaliz  := {}
Local aSaldos   := {}
Local nX        := 0
Local nY        := 0
Local nAuxiliar := 0
Local nQtdRese  := 0
Local nMCusto   := 0
Local nSaveSX8  := GetSX8Len()
Local nRegEmp   := 0
Local cQuery    := ""
Local cNameQry  := ""
Local cSeqSC9   := "00"
Local cReserva  := ""
Local cSeekDCF  := ''
Local lAtualiza := If(aEmpenho==Nil,.T.,.F.)
Local lEstoque  := .F.
Local lCredito  := .F.
Local lHasWMS   := IntDl(SC6->C6_PRODUTO) .And. !Empty(SC6->C6_SERVIC) //-- Soh considera o uso do WMS se houver Servico Preenchido para o Item do SC6
Local lUsaVenc  := .F.
Local lReserva  := .F.
Local lEmpenha  := .F.
Local lResEst   := SuperGetMv("MV_RESEST")
Local lIntACD	:= SuperGetMV("MV_INTACD",.F.,"0") == "1"
Local dValidLote:= Ctod( "" )
Local nRecSC9   := 0
Local nPrcVen   := 0
Local nTotSC9   := 0
Local nTotSC9Aux := 0
Local nDecimal   := TamSx3("C9_PRCVEN")[2]
//��������������������������������Ŀ
//�Tratamento para e-Commerce      �
//����������������������������������
Local lECommerce := SuperGetMV("MV_LJECOMM",,.F.) .And. GetRpoRelease("R5")

DEFAULT cBlqWms      := ""
DEFAULT cIdentB6     := ""
DEFAULT lMA440GrLt   := ExistBlock("MA440GRLT")
DEFAULT aEmpPronto   := {}
DEFAULT cTiposLC     := GetSESTipos({ || ES_SALDUP == "2"},"1")
DEFAULT lOkExpedicao := .F.

//������������������������������������������������������������������������Ŀ
//� Configura a reserva de estoque quando for e-Commerce                   �
//��������������������������������������������������������������������������
If  lECommerce .AND. !( Empty(SC5->C5_ORCRES) ) .AND. SL1->( FieldPos("L1_ECFLAG") > 0 ) .AND. (Posicione("SL1",1,xFilial("SL1")+SC5->C5_ORCRES,"L1_ECFLAG")=="1")
	lResEst := .T.
EndIf

//�����������������������������������������������������Ŀ
//� Baixa as qtdes transferidas para o local do pedido  �
//�������������������������������������������������������
If ( lAtualiza )
	For nX :=1 To Len(aLocal)
		MaTrfLocal(SC6->C6_PRODUTO,aLocal[nX][1],SC6->C6_LOCAL,aLocal[nX][2],SC6->C6_NUM,.F.)
	Next nX
EndIf
//������������������������������������������������������������������������Ŀ
//�Posiciona Registros                                                     �
//��������������������������������������������������������������������������
dbSelectArea("SF4")
dbSetOrder(1)
MsSeek(xFilial("SF4")+SC6->C6_TES)
//������������������������������������������������������������������������Ŀ
//�Verifica a Sequencia de Liberacao do SC9                                �
//��������������������������������������������������������������������������
#IFDEF TOP
	If ( TcSrvType()<>"AS/400" )
		SC9->(dbCommit())
		cNameQry := "MAGRAVASC9"

		cQuery := "SELECT MAX(C9_SEQUEN) SEQUEN "
		cQuery +=   "FROM "+RetSqlName("SC9")+" SC9 "
		cQuery +=   "WHERE C9_FILIAL='"+xFilial("SC9")+"' AND "
		cQuery +=         "C9_PEDIDO='"+SC6->C6_NUM+"' AND "
		cQuery +=         "C9_ITEM='"+SC6->C6_ITEM+"' AND "
		cQuery +=         "SC9.D_E_L_E_T_<>'*'"

		cQuery := ChangeQuery(cQuery)

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cNameQry,.T.,.T.)
		If !Empty(SEQUEN)
			cSeqSC9 := AllTrim(SEQUEN)
		EndIf
		dbCloseArea()
		dbSelectArea("SC9")
	Else
#ENDIF
	dbSelectArea("SC9")
	dbSetOrder(1)
	If ( MsSeek(xFilial("SC9")+SC6->C6_NUM+SC6->C6_ITEM,.F.) )
		While ( !Eof() .And. SC9->C9_FILIAL == xFilial("SC9") .And.;
				SC9->C9_PEDIDO == SC6->C6_NUM .And.;
				SC9->C9_ITEM   == SC6->C6_ITEM )
			If ( SC9->C9_PRODUTO == SC6->C6_PRODUTO )
				cSeqSC9  := SC9->C9_SEQUEN
			EndIf
			dbSelectArea("SC9")
			dbSkip()
		Enddo
	EndIf
	#IFDEF TOP
	EndIf
	#ENDIF
cSeqSC9 := Soma1(cSeqSC9,Len(SC9->C9_SEQUEN))
//������������������������������������������������������������������������Ŀ
//�Inicializa as variaveis                                                 �
//��������������������������������������������������������������������������
nQtdLib2  := If(nQtdLib2==Nil,SB1->(ConvUm(SC6->C6_PRODUTO,nQtdLib,0,2)),nQtdLib2)
If nQtdLib2 == 0 .And. SC6->C6_UNSVEN <> 0
	If Empty( SC6->C6_QTDVEN-SC6->C6_QTDEMP-SC6->C6_QTDENT-nQtdLib )
		//���������������������������������������������������������������������������Ŀ
		//� Se baixou toda a quantidade na primeira UM, baixa totalmente a segunda UM �
		//�����������������������������������������������������������������������������
		nQtdLib2 := SC6->C6_UNSVEN-SC6->C6_QTDEMP2-SC6->C6_QTDENT2
	Else
		//������������������������������������������������������������������������Ŀ
		//� Se nao, baixa proporcionamenre a quantidade baixada na primeira UM     �
		//��������������������������������������������������������������������������
		nQtdLib2 := nQtdLib*SC6->C6_UNSVEN/SC6->C6_QTDVEN
	EndIf
	SC6->C6_QTDLIB2:= nQtdLib2
	nQtdLib2 := SC6->C6_QTDLIB2
EndIf
lReserva  := !Empty(SC6->C6_RESERVA)
lEstoque  := Empty(AllTrim(cBlqEst))
lCredito  := Empty(AllTrim(cBlqCred))
If ( SF4->F4_ESTOQUE=="S" .And. nQtdLib > 0 .And. lEstoque .And. (lCredito .Or. lResEst) .And. lAtualiza)
	//������������������������������������������������������������������������Ŀ
	//�Verifica os novos lotes.                                                �
	//��������������������������������������������������������������������������
	If !Rastro(SC6->C6_PRODUTO) .And. !Localiza(SC6->C6_PRODUTO)
		If Len(aEmpPronto) > 0
			aSaldos := ACLONE(aEmpPronto)
			lEmpenha := .T.
		Else
			aSaldos := {{ "","","","",nQtdLib,nQtdLib2,Ctod(""),"","","",SC6->C6_LOCAL,0}}
		EndIf
		aLocaliz := { aSaldos }
	Else
		//������������������������������������������������������������������������Ŀ
		//� Ponto de Entrada p/ movimentar estoque antes da selecao Lote X Localiz.�
		//��������������������������������������������������������������������������
		If lMA440GrLt
			ExecBlock("MA440GRLT",.F.,.F.,{SC6->C6_PRODUTO,SC6->C6_LOCAL,nQtdLib,SC6->C6_LOTECTL,SC6->C6_NUMLOTE,SC6->C6_LOCALIZ,SC6->C6_NUMSERI})
		EndIf
		//������������������������������������������������������������������������Ŀ
		//� Verifica se devem ser escolhidos Lotes/Sub-Lotes/Localizacao ou nao    �
		//��������������������������������������������������������������������������
		If Len(aEmpPronto) > 0
			aSaldos := ACLONE(aEmpPronto)
			lEmpenha := .T.
		Else
			lUsaVenc:= If(!Empty(SC6->C6_LOTECTL+SC6->C6_NUMLOTE),.T.,(SuperGetMv('MV_LOTVENC')=='S'))
			If ( !lHasWMS .Or. !Empty(SC6->C6_LOCALIZ+SC6->C6_NUMSERI) ) .And. (!lReserva .Or. (lReserva .And. Rastro(SC6->C6_PRODUTO) .And. Empty(SC0->C0_LOTECTL+SC0->C0_NUMLOTE)))
				aSaldos := SldPorLote(SC6->C6_PRODUTO,SC6->C6_LOCAL,nQtdLib,nQtdLib2,SC6->C6_LOTECTL,SC6->C6_NUMLOTE,SC6->C6_LOCALIZ,SC6->C6_NUMSERI,NIL,NIL,NIL,lUsaVenc,nil,nil,dDataBase)
				lEmpenha := .T.
			Else
				SC0->( dbSetOrder(1) )
				If !Empty(SC6->C6_RESERVA) .And.;
					(xFilial("SC0")+SC6->C6_RESERVA+SC6->C6_PRODUTO+SC6->C6_LOCAL==SC0->C0_FILIAL+SC0->C0_NUM+SC0->C0_PRODUTO+SC0->C0_LOCAL .Or. ;
					SC0->( dbSeek( xFilial("SC0")+SC6->C6_RESERVA+SC6->C6_PRODUTO+SC6->C6_LOCAL ) ) )

					//������������������������������������������������������������������������Ŀ
					//� Pesquisa a data de validade dos lotes                                  �
					//��������������������������������������������������������������������������
					If Rastro(SC6->C6_PRODUTO,"L")
						SB8->( dbSetOrder( 3 ) )
						SB8->( MsSeek( xFilial( "SB8" ) + SC0->C0_PRODUTO + SC0->C0_LOCAL + SC0->C0_LOTECTL ) )
						dValidLote := SB8->B8_DTVALID
					ElseIf Rastro(SC6->C6_PRODUTO,"S")
						SB8->( dbSetOrder( 3 ) )
						SB8->( MsSeek( xFilial( "SB8" ) + SC0->C0_PRODUTO + SC0->C0_LOCAL + SC0->C0_LOTECTL + SC0->C0_NUMLOTE ) )
						dValidLote := SB8->B8_DTVALID
					Else
						dValidLote := Ctod( "" )
					EndIf

					aSaldos := {{ SC0->C0_LOTECTL,SC0->C0_NUMLOTE,SC0->C0_LOCALIZ,SC0->C0_NUMSERI,nQtdLib,nQtdLib2,dValidLote,"","","",SC0->C0_LOCAL,0}}
				Else
					cReserva := ""
					lReserva := .F.
					aSaldos := {{ SC6->C6_LOTECTL,SC6->C6_NUMLOTE,SC6->C6_LOCALIZ,SC6->C6_NUMSERI,nQtdLib,nQtdLib2,Ctod(""),"","","",SC6->C6_LOCAL,0}}
				EndIf
			EndIf
		EndIf
		//������������������������������������������������������������������������Ŀ
		//�Aglutina os lotes/sub-lotes iguais                                      �
		//�Quando ha criacao de reservas na liberacao nao se deve aglutinar as     �
		//�localizacoes fisicas.                                                   �
		//��������������������������������������������������������������������������
		If ( lCredito .Or. lResEst)
			aAuxiliar := aClone(aSaldos)
			aSaldos   := {}
			For nX := 1 To Len(aAuxiliar)
				nAuxiliar := aScan(aSaldos,{|x|x[1]==aAuxiliar[nX,1] .And.;
					x[2]==aAuxiliar[nX,2] .And.;
					x[11]==aAuxiliar[nX,11] })
				If ( nAuxiliar == 0 )
					AAdd(aSaldos,Array(Len(aAuxiliar[nX])))
					For nY := 1 To Len(aAuxiliar[nX])
						aSaldos[Len(aSaldos)][nY] := aAuxiliar[nX,nY]
					Next nY
					AAdd(aLocaliz,{ aAuxiliar[nX] })
				Else
					//������������������������������������������������������������������������Ŀ
					//�Quando aglutina os lotes/sub-lotes iguais com localizacoes diferentes,  �
					//�limpa a localizacao fisica do array asaldos                             �
					//��������������������������������������������������������������������������
					If !( aSaldos[nAuxiliar,3] == aAuxiliar[nX,3] )
						aSaldos[nAuxiliar,3] := ""
					EndIf
					aSaldos[nAuxiliar][5] += aAuxiliar[nX,5]
					aSaldos[nAuxiliar][6] += aAuxiliar[nX,6]
					AAdd(aLocaliz[nAuxiliar],aAuxiliar[nX])
				EndIf
			Next nX
		Else
			aLocaliz:= { aSaldos }
		EndIf
	EndIf
Else
	If Len(aEmpPronto) > 0
		aSaldos := ACLONE(aEmpPronto)
		lEmpenha := .T.
	Else
		aSaldos := {{ "","","","",nQtdLib,nQtdLib2,Ctod(""),"","","",SC6->C6_LOCAL,0}}
	EndIf
	aLocaliz:= { aSaldos }
EndIf
//������������������������������������������������������������������������Ŀ
//� Verifica se o Bloqueio de Enderecamento do WMS deve ser efetuado       �
//��������������������������������������������������������������������������
If lHasWMS
	If lEmpenha
		cBlqWMS := "02"
	Else
		//-- Um pedido de venda pode ter liberacoes parciais, essas parciais geram uma sequencia no SC9 gravada em
		//-- C9_SEQUEN, o sistema ira gravar uma nova O.S.WMS referente as liberacoes gravando essa sequencia no campo
		//-- DCF_NUMSEQ
		cBlqWMS := '01'
		DCF->(DbSetOrder(2)) //-- FILIAL+SERVIC+DOCTO+SERIE+CLIFOR+LOJA+CODPRO
		If	DCF->(MsSeek(cSeekDCF:=xFilial('DCF')+SC6->C6_SERVIC+PadR(SC6->C6_NUM,Len(DCF->DCF_DOCTO))+PadR(SC6->C6_ITEM,Len(DCF->DCF_SERIE))+SC6->C6_CLI+SC6->C6_LOJA+SC6->C6_PRODUTO))
			While DCF->(!Eof() .And. DCF->DCF_FILIAL + DCF->DCF_SERVIC + DCF->DCF_DOCTO + DCF->DCF_SERIE + DCF->DCF_CLIFOR + DCF->DCF_LOJA + DCF->DCF_CODPRO == cSeekDCF)
				If	DCF->DCF_NUMSEQ == PadR(cSeqSC9,Len(DCF->DCF_NUMSEQ))
					cBlqWMS := '05'
					Exit
				EndIf
				DCF->(DbSkip())
			EndDo
		EndIf
	EndIf
EndIf
//������������������������������������������������������������������������Ŀ
//� Verifica se o Bloqueio de Enderecamento do WMS deve ser efetuado       �
//��������������������������������������������������������������������������
For nX := 1 To Len(aSaldos)
	//������������������������������������������������������������������������Ŀ
	//� Efetua a Gravacao do SC9                                               �
	//��������������������������������������������������������������������������
	If lAtualiza
		//������������������������������������������������������������������������Ŀ
		//�Garante o estoque caso haja bloqueio de credito atraves de uma reserva  �
		//�de material.                                                            �
		//��������������������������������������������������������������������������
		If !lCredito .And. lResEst .And. SF4->F4_ESTOQUE=="S" .And. !lReserva .And. lEstoque
			cReserva := CriaVar("C0_NUM")
			nQtdRese := aSaldos[nX,5]
			If Empty(cReserva)
				cReserva := NextNumero("SC0",1,"C0_NUM",.T.)
			Else
				While ( GetSX8Len() > nSaveSX8 )
					ConfirmSx8()
				EndDo
			EndIf
			If !a430Reserva({1,"PD",SC5->C5_NUM,"",cFilAnt},@cReserva,;
					SC6->C6_PRODUTO,aSaldos[nX,11],nQtdRese,;
					{aSaldos[nX,2],aSaldos[nX,1],aSaldos[nX,3],aSaldos[nX,4]})
				cReserva := ""
			Else
				//��������������������������������������������������������������Ŀ
				//� Atualiza a qtde em aberto do pedido de venda                 �
				//����������������������������������������������������������������
				dbSelectArea("SB2")
				dbSetOrder(1)
				If ( !MsSeek(xFilial("SB2")+SC6->C6_PRODUTO+aSaldos[nX,11]) )
					CriaSB2( SC6->C6_PRODUTO,aSaldos[nX,11] )
				EndIf
				RecLock("SB2")
				SB2->B2_QPEDVEN -= nQtdRese
				SB2->B2_QPEDVE2 -= ConvUM(SB2->B2_COD, nQtdRese, 0, 2)
				//��������������������������������������������������������������Ŀ
				//� Atualiza o saldo da reserva                                  �
				//����������������������������������������������������������������
				dbSelectArea("SC0")
				dbSetOrder(1)
				If (xFilial("SC0")+cReserva+SC6->C6_PRODUTO+aSaldos[nX,11]==SC0->C0_FILIAL+SC0->C0_NUM+SC0->C0_PRODUTO+SC0->C0_LOCAL .Or. ;
						MsSeek(xFilial("SC0")+cReserva+SC6->C6_PRODUTO+aSaldos[nX,11]) )
					RecLock("SC0")
					SC0->C0_QUANT -= nQtdRese
					SC0->C0_TIPO  := "PD"
					SC0->C0_QTDPED += nQtdRese
				EndIf
				//��������������������������������������������������������������Ŀ
				//� Atualiza o item do pedidod de venda                          �
				//����������������������������������������������������������������
				RecLock("SC6")
				SC6->C6_QTDRESE += nQtdRese
				SC6->C6_RESERVA := cReserva
			EndIf
		Else
			cReserva := SC6->C6_RESERVA
			nQtdRese := SC6->C6_QTDRESE
		EndIf
		nValor := A410Arred(nQtdLib*SC6->C6_PRCVEN,"C6_PRCVEN")
		
		If nX == Len(aSaldos) .And. Len(aSaldos) > 1 .And. Empty(SC6->C6_LOTECTL) .And. Rastro(SC6->C6_PRODUTO)
			nPrcVen := noRound(nValor - nTotSC9,nDecimal) / aSaldos[nX,5]
			nPrcVen := A410Arred(nPrcVen,"C6_PRCVEN")
			If ( SuperGetMv("MV_ARREFAT") == "N" )
				nTotSC9Aux := nTotSC9
				nTotSC9 += a410Arred(aSaldos[nX,5] * nPrcVen ,"C9_PRCVEN")
				If nValor - nTotSC9 <> 0
					nPrcVen += a410Arred((nValor-nTotSC9)/aSaldos[nX,5] ,"C6_PRCVEN")
				EndIf
				nTotSC9 := nTotSC9Aux
			EndIf
		EndIf
		RecLock("SC9",.T.)
		SC9->C9_FILIAL := xFilial("SC9")
		SC9->C9_PEDIDO := SC6->C6_NUM
		SC9->C9_ITEM    := SC6->C6_ITEM
		SC9->C9_SEQUEN  := cSeqSC9
		SC9->C9_PRODUTO := SC6->C6_PRODUTO
		SC9->C9_CLIENTE := SC6->C6_CLI
		SC9->C9_LOJA    := SC6->C6_LOJA
		SC9->C9_PRCVEN  := IIF(nPrcVen==0,SC6->C6_PRCVEN,nPrcVen)
		SC9->C9_DATALIB := dDataBase
		SC9->C9_LOTECTL := aSaldos[nX,1]
		SC9->C9_NUMLOTE := aSaldos[nX,2]
		SC9->C9_QTDLIB  := aSaldos[nX,5]
		SC9->C9_QTDLIB2 := aSaldos[nX,6]
		SC9->C9_DTVALID := aSaldos[nX,7]
		SC9->C9_POTENCI := aSaldos[nX,12]		
		SC9->C9_BLCRED  := cBlqCred
		SC9->C9_BLEST   := cBlqEst
		SC9->C9_BLWMS   := cBlqWMS
		SC9->C9_QTDRESE := Min(nQtdRese,SC9->C9_QTDLIB)
		SC9->C9_RESERVA := cReserva
		SC9->C9_AGREG  := &(SuperGetMv("MV_AGREG"))
		SC9->C9_GRUPO  := &(SuperGetMv("MV_GRUPFAT"))
		SC9->C9_IDENTB6:= cIdentB6
		SC9->C9_LOCAL  := aSaldos[nX,11]
		SC9->C9_SERVIC := SC6->C6_SERVIC
		SC9->C9_PROJPMS:= SC6->C6_PROJPMS
		SC9->C9_TASKPMS:= SC6->C6_TASKPMS
		If SC6->(FieldPos('C6_TRT')) > 0 .And.SC9->(FieldPos('C9_TRT'))  > 0
			SC9->C9_TRT  := SC6->C6_TRT
		Endif	
		SC9->C9_LICITA := SC6->C6_LICITA
		SC9->C9_TPCARGA:= SC5->C5_TPCARGA
		SC9->C9_ENDPAD := SC6->C6_ENDPAD
		SC9->C9_TPESTR := SC6->C6_TPESTR
		SC9->C9_EDTPMS := SC6->C6_EDTPMS
		If ( SC9->( FieldPos('C9_DATENT') ) > 0 )
			SC9->C9_DATENT := SC6->C6_ENTREG
		EndIf
		//Grava tipo da Ordem de Produ��o na libera��o
		If ( SC9->( FieldPos('C9_TPOP') ) > 0 )
			If ( SC6->C6_TPOP == ' ' ) .Or. ( SC6->C6_TPOP == 'F' )
				SC9->C9_TPOP := '1'
			Else
				SC9->C9_TPOP := '2'
			EndIf
		EndIf

	   nTotSC9 += a410Arred(SC9->C9_QTDLIB * SC9->C9_PRCVEN ,"C9_PRCVEN")
		//��������������������������������������������������������������������������������������Ŀ
		//� Regra do WMS, onde: 1=Apanhe por Lote/2=Apanhe por Numero de Serie/3=Apanhe por Data �
		//����������������������������������������������������������������������������������������
		SC9->C9_REGWMS := SC6->C6_REGWMS
		//-- Executa bloco de comandos para montagem de cargas (Oms521Car)
		If ( bBlock <> Nil )
			nRecSC9 := SC9->(Recno())
			Eval(bBlock)
			SC9->(dbGoto(nRecSC9))
			If SoftLock("SC9")
				RecLock("SC9",.F.)
			EndIf
		EndIf
		If cPaisLoc == "COL" //Tratamento de Terceros em Vendas
			SC9->C9_NIT := SC6->C6_NIT
		Endif
		If SC9->(FieldPos("C9_CODISS")) > 0
			SC9->C9_CODISS := SC6->C6_CODISS
		Endif
		If SC9->(FieldPos("C9_RETOPER")) > 0
			SB1->(dbSetOrder(1))
			SB1->(dbSeek(xFilial("SB1")+SC6->C6_PRODUTO))
			//������������������������������������������������������������������������Ŀ
			//�O campo C9_RETOPER � considerado na quebra de Nota Fiscal.              |
			//�Alguns Clientes que migraram da versao 8 para 10 estao tendo problemas  |
			//�com esta quebra pois na versao 8 esse campo nao possuia um inicializador| 
			//�padrao e muitos produtos estao com esse campo em branco.                |
			//�Os campos em branco "" devem ser considerados como "2"=Nao. Assim qdo   |
			//|houver dois produtos ou mais onde alguns estao com os campos em branco e|
			//|e outros com "2" todos devem sair na mesma Nota Fiscal                  |
			//��������������������������������������������������������������������������

			If !Empty(SB1->B1_RETOPER)	
				SC9->C9_RETOPER := SB1->B1_RETOPER
			Else
				SC9->C9_RETOPER := "2"
			Endif	
			
		Endif
		If ExistBlock("M440SC9I")
			ExecBlock("M440SC9I",.F.,.F.)
		EndIf
		MaAvalSC9("SC9",1,aLocaliz[nX],Nil,Nil,Nil,Nil,Nil,@nVlrCred,,,,lOkExpedicao)
		//�������������������������������������������������������������Ŀ
		//�Atualiza o orcamento do Televendas, se foi originado a partir�
		//�dele no modulo Call Center (SIGATMK)                         �
		//���������������������������������������������������������������
		TkAtuTlv(SC9->C9_PEDIDO,2)

		//���������������������������������������������������Ŀ
		//� Integracao com o  ACD			  				  �
		//�����������������������������������������������������
		If lIntACD .And. FindFunction("CBMTA440C9")
			CBMTA440C9()
		//�����������������������������������������������������Ŀ
		//� Ponto de entrada para todos os itens do pedido.     �
		//�������������������������������������������������������
		ElseIf ( ExistTemplate("MTA440C9") )
			ExecTemplate("MTA440C9",.F.,.F.)
		EndIf

		//�����������������������������������������������������Ŀ
		//� Ponto de entrada para todos os itens do pedido.     �
		//�������������������������������������������������������
		If ( ExistBlock("MTA440C9") )
			ExecBlock("MTA440C9",.F.,.F.)
		EndIf
	Else
		//������������������������������������������������������������������������Ŀ
		//�Acumula os dados na variavel aEmpenho                                   �
		//��������������������������������������������������������������������������
		If ( SF4->F4_ESTOQUE == "S" .And. aSaldos[nX,5] > 0 )
			//��������������������������������������������������������������Ŀ
			//� Atualiza qtde a ser reservada no pedido informado            �
			//����������������������������������������������������������������
			dbSelectArea("SB2")
			dbSetOrder(1)
			MsSeek(xFilial("SB2")+SC6->C6_PRODUTO+aSaldos[nX,11])
			RecLock("SB2")
			//������������������������������������������������������������������������Ŀ
			//�Verifica se ha bloqueio de estoque                                      �
			//��������������������������������������������������������������������������
			If ( lCredito .And. lEstoque )
				//������������������������������������������������������������������������Ŀ
				//�Atualiza os empenhos quando ha localizacao                              �
				//��������������������������������������������������������������������������
				nRegEmp := aScan(aEmpenho[2],{|x| x[1]==SB2->(RecNo()) .And.;
					x[3] == SC6->C6_LOCALIZ+SC6->C6_NUMSERI+SC6->C6_NUMLOTE+SC6->C6_LOTECTL })
				If ( nRegEmp == 0 )
					AAdd(aEmpenho[2],{ SB2->(RecNo()),aSaldos[nX,5],SC6->C6_LOCALIZ+SC6->C6_NUMSERI+SC6->C6_NUMLOTE+SC6->C6_LOTECTL,aSaldos[nX,6]})
				Else
					aEmpenho[2][nRegEmp][2] += aSaldos[nX,5]
					aEmpenho[2][nRegEmp][4] += aSaldos[nX,6]
				EndIf
			EndIf
		EndIf
		If ( SF4->F4_DUPLIC=="S" .And. !SC5->C5_TIPO$"DB" )
			dbSelectArea("SA1")
			dbSetOrder(1)
			MsSeek(xFilial("SA1")+SC6->C6_CLI+SC6->C6_LOJA)
			RecLock("SA1")
			nMCusto :=  If(SA1->A1_MOEDALC > 0,SA1->A1_MOEDALC,Val(SuperGetMv("MV_MCUSTO")))
			If ( Empty(cBlqCred) )
				nRegEmp := aScan(aEmpenho[1],{|x| x[1]==SA1->(RecNo())})
				If ( nRegEmp == 0 )
					AAdd(aEmpenho[1],{ SA1->(RecNo()),0,0})
					nRegEmp := Len(aEmpenho[1])
				EndIf
				aEmpenho[1][nRegEmp][2] += xMoeda( aSaldos[nX,5] * SC6->C6_PRCVEN , SC5->C5_MOEDA , nMCusto , dDataBase )
				aEmpenho[1][nRegEmp][3] += xMoeda( aSaldos[nX,5] * SC6->C6_PRCVEN , SC5->C5_MOEDA , nMCusto , dDataBase )
			EndIf
		EndIf
	EndIf
	//������������������������������������������������������������������������Ŀ
	//�Incrementa o SC9                                                        �
	//��������������������������������������������������������������������������
	cSeqSC9 := Soma1(cSeqSC9,Len(SC9->C9_SEQUEN))
Next nX
//������������������������������������������������������������������������Ŀ
//�Restaura a entrada da rotina                                            �
//��������������������������������������������������������������������������
RestArea(aAreaSA1)
RestArea(aAreaSB2)
RestArea(aAreaSF4)
RestArea(aAreaSB1)
RestArea(aArea)
Return(.T.)






/*/
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Fun��o    �A450Proces� Rev.  � Eduardo Riera         � Data �02.02.2002 ���
��������������������������������������������������������������������������Ĵ��
���          �Rotina de processamento da reavalicao de credito             ���
���          �                                                             ���
��������������������������������������������������������������������������Ĵ��
���Parametros� ExpC1: Alias de Entrada                                     ���
���          � ExpL2: Indica se o Credito de ser Reavaliado                ���
���          � ExpL3: Indica se o Estoque de ser Reavaliado                ���
���          � ExpL4: Flag de cancelamento                                 ���
���          � ExpL5: Indica se o processamento devera ser feito em todas  ���
���          �        as filiais                                           ���
���          � ExpL6: Indica se os bloqueios de WMS devem ser reavaliados  ���
���          �                                                             ���
��������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                       ���
���          �                                                             ���
��������������������������������������������������������������������������Ĵ��
���Descri��o �Esta rotina reavalia o credito com base nos parametros da    ���
���          �rotina de liberacao de credito ( MaAvalCred ). O estoque     ���
���          �sera realiada caso o credito seja liberado.                  ���
���          �                                                             ���
��������������������������������������������������������������������������Ĵ��
���Uso       � Materiais                                                   ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
/*/
User Function x450Proces(cAlias,lAvCred,lAvEst,lEnd,lEmpresa,lAvWMS)

Local aArea     := GetArea()
Local aAreaSM0  := SM0->(GetArea())
Local aRegSC6   := {}
Local bWhile    := {|| !Eof()}
Local lQuery    := .F.
Local lCredito  := .F.
Local lEstoque  := .F.
Local lMvAvalEst:= SuperGetMV("MV_AVALEST")==2
Local lBlqEst   := SuperGetMV("MV_AVALEST")==3 .And. !lAvEst
Local lMta450T2 := (ExistBlock("MTA450T2"))
Local lMt450End := (ExistBlock("MT450END"))
Local lMta450T  := (ExistBlock("MTA450T"))
Local lMa450Ped := (ExistBlock("MA450PED"))
Local lMTValAvC := (ExistBlock("MTVALAVC"))
Local lMT450Ite := (ExistBlock("MT450ITE"))                             
Local lMT450TpLi:= (ExistBlock("MT450TPLI"))
Local nValAV	 := 0
Local lLibPedCr := .T.
Local cBlqCred  := ""
Local cQuery    := ""
Local cIndSC9   := ""
Local cAliasSC9 := "MA450PROC"
Local cMensagem := ""
Local cEmpresa  := cEmpAnt
Local cSavFil   := cFilAnt
Local cTipLib   := ""
Local cQuebra   := ""
Local nValItPed 	:= 0		
Local nMvTipCrd 	:= SuperGetMV("MV_TIPACRD", .F., 1)
Local nVlrTitAbe	:= 0
Local nVlrTitAtr	:= 0
//��������������������������������Ŀ
//�Tratamento para e-Commerce      �
//����������������������������������
Local lECommerce := SuperGetMV("MV_LJECOMM",,.F.)
Local cOrcamto   := ""     //Obtem o Orcamento original para posicionar na tabela MF5

DEFAULT lEmpresa := .F.
DEFAULT lAvWMS   := .F.

//-- Variaveis utilizadas pela funcao wmsexedcf
Private aLibSDB	:= {}
Private aWmsAviso:= {}

//������������������������������������������������������������������������Ŀ
//� Verifica o numero de registros a processar                             �
//��������������������������������������������������������������������������
ProcRegua(SC9->(LastRec()))
//������������������������������������������������������������������������Ŀ
//� Verifica as filiais a serem liberadas                                  �
//��������������������������������������������������������������������������
If lEmpresa
	cEmpresa := cEmpAnt
	bWhile   := {|| !Eof() .And. SM0->M0_CODIGO == cEmpresa }
Else
	cEmpresa := cEmpAnt+cFilAnt
	bWhile   := {|| !Eof() .And. SM0->M0_CODIGO+FWGETCODFILIAL == cEmpresa }
EndIf
dbSelectArea("SM0")
dbSetOrder(1)
MsSeek(cEmpresa)
While Eval(bWhile)
	//������������������������������������������������������������������������Ŀ
	//� Verifica a filial corrente                                             �
	//��������������������������������������������������������������������������
	cFilAnt := FWGETCODFILIAL
	If lEmpresa
		cMensagem := "("+FWGETCODFILIAL+"/"+SM0->M0_FILIAL+") "+RetTitle("C6_NUM")
	Else
		cMensagem := RetTitle("C6_NUM")
	EndIf
	//������������������������������������������������������������������������Ŀ
	//� Monta a Query de Pesquisa                                              �
	//��������������������������������������������������������������������������
	dbSelectArea("SC9")
	dbSetOrder(1)
	#IFDEF TOP
		If (TcSrvType()!="AS/400")
			lQuery := .T.
			cQuery := "SELECT SC9.R_E_C_N_O_ RECNO, SC9.C9_FILIAL,SC9.C9_PEDIDO,SC9.C9_ITEM,SC9.C9_BLCRED,SC5.C5_TIPLIB,SC6.R_E_C_N_O_ SC6RECNO "
			cQuery += "FROM "+RetSqlName("SC9")+" SC9,"
			cQuery += RetSqlName("SC5")+" SC5,"
			cQuery += RetSqlName("SC6")+" SC6 "
			cQuery += "WHERE SC9.C9_FILIAL = '"+xFilial("SC9")+"' AND "
			cQuery += "SC9.C9_PEDIDO  >= '"+MV_PAR01+"' AND "
			cQuery += "SC9.C9_PEDIDO  <= '"+MV_PAR02+"' AND "
			cQuery += "SC9.C9_CLIENTE >= '"+MV_PAR03+"' AND "
			cQuery += "SC9.C9_CLIENTE <= '"+MV_PAR04+"' AND "
			cQuery += "SC9.C9_NFISCAL = '"+Space(Len(SC9->C9_NFISCAL))+"' AND "
			cQuery += "SC9.D_E_L_E_T_ <> '*' AND "
			cQuery += "SC5.C5_FILIAL  = '"+xFilial("SC5")+"' AND "
			cQuery += "SC5.C5_NUM     = SC9.C9_PEDIDO AND "
			cQuery += "SC5.D_E_L_E_T_ <> '*' AND "			
			cQuery += "SC6.C6_FILIAL  = '"+xFilial("SC6")+"' AND "
			cQuery += "SC6.C6_NUM     = SC9.C9_PEDIDO AND "
			cQuery += "SC6.C6_ITEM    = SC9.C9_ITEM AND "
			cQuery += "SC6.C6_PRODUTO = SC9.C9_PRODUTO AND "			
			cQuery += "SC6.C6_ENTREG  >= '"+Dtos(MV_PAR05)+"' AND "
			cQuery += "SC6.C6_ENTREG  <= '"+Dtos(MV_PAR06)+"' AND "
			cQuery += "SC6.D_E_L_E_T_ <> '*' "

			If ( lAvCred .And. !lAvEst )
				cQuery += "AND (SC9.C9_BLCRED IN ('01','04') ) "
			EndIf
			If ( lAvEst .And. !lAvCred )
				cQuery += "AND ( SC9.C9_BLEST = '02' OR SC9.C9_BLWMS='03' ) AND SC9.C9_BLCRED='  ' "
			EndIf
			If ( lAvEst .And. lAvCred )
				cQuery += "AND (SC9.C9_BLEST = '02' OR SC9.C9_BLCRED IN('01','04') OR SC9.C9_BLWMS='03') "
			EndIf
			If ( lAvWMS .And. !lAvEst )
				cQuery += "AND (SC9.C9_BLWMS='03') "
			EndIf    

			If ExistBlock("MT450QRY")
				cQuery := ExecBlock("MT450QRY",.F.,.F.,{ cQuery })
			EndIf
			
			cQuery += "ORDER BY "+SqlOrder(SC9->(IndexKey()))
			cQuery := ChangeQuery(cQuery)

			dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),cAliasSC9, .T., .T.)

		Else
	#ENDIF
		cQuery := "C9_FILIAL=='"+xFilial("SC9")+"'.And."
		cQuery += "C9_PEDIDO>='"+MV_PAR01+"'.And."
		cQuery += "C9_PEDIDO<='"+MV_PAR02+"'.And."
		cQuery += "C9_CLIENTE>='"+MV_PAR03+"'.And."
		cQuery += "C9_CLIENTE<='"+MV_PAR04+"'.And."
		cQuery += "C9_NFISCAL=='"+Space(Len(SC9->C9_NFISCAL))+"'.And."
		If ( lAvCred .And. !lAvEst )
			cQuery += "(C9_BLCRED=='01'.OR.C9_BLCRED=='04')"
		EndIf
		If ( lAvEst .And. !lAvCred )
			cQuery += "(C9_BLEST=='02'.OR.C9_BLWMS=='03').AND.C9_BLCRED=='  '"
		EndIf
		If ( lAvCred .And. lAvEst )
			cQuery += "(C9_BLCRED=='01'.OR.C9_BLCRED=='04'.OR.C9_BLEST=='02'.OR.C9_BLWMS=='03')"
		EndIf
		If ( lAvWMS .And. !lAvEst )
			cQuery += "(SC9.C9_BLWMS='03')"
		EndIf

		If ExistBlock("MT450FIL")
			cQuery += ".And."+ExecBlock("MT450FIL",.F.,.F.)
		EndIf
		
		//���������������������������������������������������������������������Ŀ
		//� Abre com outro alias pois o SC9 pode estar filtrado                 �
		//�����������������������������������������������������������������������
		ChkFile("SC9",.F.,cAliasSC9)
		dbSelectArea(cAliasSC9)
		cIndSC9 := CriaTrab(,.F.)
		IndRegua(cAliasSC9,cIndSC9,IndexKey(),,cQuery)
		dbGotop()
		#IFDEF TOP
		EndIf
		#ENDIF
	dbSelectArea(cAliasSC9)
	While (!((cAliasSC9)->(Eof())) .And. xFilial("SC9") == (cAliasSC9)->C9_FILIAL )
		//���������������������������������������������������������������������Ŀ
		//� Verifica o tipo de Liberacao                                        �
		//�����������������������������������������������������������������������
		If lQuery
			cTipLib := (cAliasSC9)->C5_TIPLIB
		Else
			dbSelectArea("SC5")
			dbSetOrder(1)
			MsSeek(xFilial("SC5")+(cAliasSC9)->C9_PEDIDO)
			cTipLib := SC5->C5_TIPLIB
		EndIf                              
		
		If lMT450Ite
			ExecBlock("MT450ITE",.F.,.F.,{cAliasSC9})
		Endif			

		If lMT450TpLi 
			cTipLib := ExecBlock("MT450TPLI",.F.,.F.,{cTipLib})
		Endif			
		
		If cTipLib == "1"
			//���������������������������������������������������������������������Ŀ
			//� Controle da Query para TOP CONNECT execeto AS/400                   �
			//�����������������������������������������������������������������������
			dbSelectArea("SC9")
			If ( lQuery )
				MsGoto((cAliasSC9)->RECNO)
			Else
				MsGoto((cAliasSC9)->(RecNo()))
			EndIf
			//������������������������������������������������������������������������Ŀ
			//�Posiciona Registros                                                     �
			//��������������������������������������������������������������������������
			dbSelectArea("SC6")
			dbSetOrder(1)
			MsSeek(xFilial("SC6")+SC9->C9_PEDIDO+SC9->C9_ITEM+SC9->C9_PRODUTO)
			If ( SC6->C6_ENTREG >= mv_par05 .And. SC6->C6_ENTREG <= mv_par06 )
				dbSelectArea("SF4")
				dbSetOrder(1)
				MsSeek(cFilial+SC6->C6_TES)
				dbSelectArea("SC5")
				dbSetOrder(1)
				If MsSeek(xFilial("SC5")+SC9->C9_PEDIDO)
					//���������������������������������������������������������������������������Ŀ
					//�Para e-Commerce ira gravar com bloqueio de credito para Boleto(FI) e sem   �
					//�bloqueio para os demais. Sera liberado com a baixa do titulo.              �
					//�����������������������������������������������������������������������������
					If  lECommerce .And. !( Empty(SC5->C5_ORCRES) ) .And. ChkFile("MF5")
					    MF5->( DbSetOrder(1) ) //MF5_FILIAL+MF5_ECALIA+MF5_ECVCHV
					
					    cOrcamto := Posicione("SL1",1,xFilial("SL1")+SC5->C5_ORCRES,"L1_ORCRES")
					    
					    If  !( Empty(cOrcamto) ) .And. !( Empty(Posicione("MF5",1,xFilial("MF5")+"SL1"+xFilial("SL1")+cOrcamto,"MF5_ECPEDI")) )
						    If  (Alltrim(SL1->L1_FORMPG) == "FI")
								(cAliasSC9)->( dbSkip() )
								IncProc(cMensagem+"..:"+(cAliasSC9)->C9_PEDIDO+"/"+(cAliasSC9)->C9_ITEM)
								Loop
						    EndIf
					    EndIf
					EndIf

					If SC5->C5_TIPO$"BD"
						dbSelectArea("SA2")
						dbSetOrder(1)
						MsSeek(xFilial("SA2")+SC9->C9_CLIENTE+SC9->C9_LOJA)
						If ( lAvCred )
							lCredito := .T.
						Else
							lCredito := Empty(SC9->C9_BLCRED)
						EndIf
					Else
						dbSelectArea("SA1")
						dbSetOrder(1)
						MsSeek(xFilial("SA1")+SC9->C9_CLIENTE+SC9->C9_LOJA)
						//������������������������������������������������������������������������Ŀ
						//�Realiza a Avaliacao de Credito                                          �
						//��������������������������������������������������������������������������
						If ( lAvCred )
							If lMTValAvC
								nValAv	:=	ExecBLock("MTValAvC",.F.,.F.,{'MA450PROCES',SC9->C9_PRCVEN*SC9->C9_QTDLIB,Nil})
							Else
								nValAv	:=	SC9->C9_PRCVEN*SC9->C9_QTDLIB					  
							Endif			
							//Analise de credito via Intellector Tools
							If nMvTipCrd == 2 .AND. FindFunction("FatCredTools") 
								
								If nValItPed == 0
									//Consulta os titulos em aberto
									nVlrTitAbe := SldCliente(SC9->C9_CLIENTE + SC9->C9_LOJA, Nil, Nil, .F.)
									//Consulta os titulos em atraso				
									nVlrTitAtr := CrdXTitAtr(SC9->C9_CLIENTE + SC9->C9_LOJA, Nil, Nil, .F.)
								EndIf
								
								nValItPed += nValAv
								
								LJMsgRun("Aguarde... Efetuando Analise de Cr�dito.",,{|| lCredito := FatCredTools(SC9->C9_CLIENTE, SC9->C9_LOJA, nValItPed, nVlrTitAbe, nVlrTitAtr)})//"Aguarde... Efetuando Analise de Cr�dito."
								//lCredito := FatCredTools(SC9->C9_CLIENTE, SC9->C9_LOJA, nValItPed, nVlrTitAbe, nVlrTitAtr)
							Else
								lCredito := MaAvalCred(SC9->C9_CLIENTE,SC9->C9_LOJA,nValAv,SC5->C5_MOEDA,.T.,@cBlqCred)
							EndIf
						Else
							lCredito := Empty(SC9->C9_BLCRED)
						EndIf
					EndIf
					If ( lAvEst .And. lCredito )
						If ( SF4->F4_ESTOQUE == "S" .And. Empty(SC9->C9_RESERVA))
							If lBlqEst
								lEstoque := .F.
							Else
								lEstoque := A440VerSB2(SC9->C9_QTDLIB,lMvAvalEst)
							EndIf
						Else
							lEstoque := .T.
						Endif
					Else
						lEstoque := IF(Empty(SC9->C9_BLEST),.T.,.F.)
					EndIf
					If ( SC6->(Found()) .And. ((lCredito .And. lAvCred) .Or. (lEstoque .And. lAvEst .And. lCredito)) )
						Do Case
							//����������������������������������������������������������������Ŀ
							//� Avalia Credito e Estoque                                       �
							//������������������������������������������������������������������
						Case ( lAvCred .And. lAvEst .And. lCredito .And. lEstoque)
							u_x450grv(1,.T.,.T.,,,lAvEst)
							//����������������������������������������������������������������Ŀ
							//� Avalia Credito e Nao Estoque                                   �
							//������������������������������������������������������������������
						Case ( lAvCred .And. !lAvEst .And. lCredito )
							u_x450grv(1,.T.,.F.,,,lAvEst)
							//����������������������������������������������������������������Ŀ
							//� Avalia Credito e bloqueia por Limite excedido                  �
							//������������������������������������������������������������������
						Case ( lAvCred .And. !lCredito )
							Begin Transaction
								RecLock(cAlias,.F.)
								SC9->C9_BLCRED := cBlCred
								MsUnLock()
							End Transaction
							//����������������������������������������������������������������Ŀ
							//� Avalia Estoque e Libera Estoque                                �
							//������������������������������������������������������������������
						Case ( lAvEst .And. lEstoque .And. lCredito)
							u_x450grv(1,.F.,lAvEst,,,lAvEst)
							//����������������������������������������������������������������Ŀ
							//� Avalia Estoque e Bloqueia Estoque                              �
							//������������������������������������������������������������������
						Case ( lAvEst .And. !lEstoque )
							Begin Transaction
								RecLock(cAlias,.F.)
								SC9->C9_BLEST := "02"
								MsUnLock()
							End Transaction
						EndCase
					EndIf
					If ( lMta450T )
						ExecBlock("MTA450T",.F.,.F.)
					EndIf
				EndIf
			EndIf
		Else
			//������������������������������������������������������������������������Ŀ
			//�Posiciona Registros                                                     �
			//��������������������������������������������������������������������������
			If !lQuery
				dbSelectArea("SC6")
				dbSetOrder(1)
				MsSeek(xFilial("SC6")+(cAliasSC9)->C9_PEDIDO+(cAliasSC9)->C9_ITEM+(cAliasSC9)->C9_PRODUTO)	
				aadd(aRegSC6,SC6->(RecNo()))
			Else
				aadd(aRegSC6,(cAliasSC9)->SC6RECNO)
			EndIf

			If ( lMta450T2 )
				ExecBlock("MTA450T2",.F.,.F.)
			EndIf

			If (cAliasSC9)->C9_BLCRED <> '  '
				lLibPedCr := .F.
			Endif	
		EndIf
		cQuebra := (cAliasSC9)->C9_PEDIDO
		dbSelectArea(cAliasSC9)
		dbSkip()
		IncProc(cMensagem+"..:"+(cAliasSC9)->C9_PEDIDO+"/"+(cAliasSC9)->C9_ITEM)
		//������������������������������������������������������������������������Ŀ
		//� Liberacao por Pedido de Venda                                          �
		//��������������������������������������������������������������������������
		If cQuebra <> (cAliasSC9)->C9_PEDIDO .Or. (cAliasSC9)->(Eof())
			If Len(aRegSC6) > 0
				dbSelectArea("SC5")
				dbSetOrder(1)
				MsSeek(xFilial("SC5")+cQuebra)

				//���������������������������������������������������������������������������Ŀ
				//�Para e-Commerce ira gravar com bloqueio de credito para Boleto(FI) e sem   �
				//�bloqueio para os demais. Sera liberado com a baixa do titulo.              �
				//�����������������������������������������������������������������������������
				If  lECommerce .And. !( Empty(SC5->C5_ORCRES) ) .And. ChkFile("MF5")
				    MF5->( DbSetOrder(1) ) //MF5_FILIAL+MF5_ECALIA+MF5_ECVCHV
				
				    cOrcamto := Posicione("SL1",1,xFilial("SL1")+SC5->C5_ORCRES,"L1_ORCRES")
				    
				    If  !( Empty(cOrcamto) ) .And. !( Empty(Posicione("MF5",1,xFilial("MF5")+"SL1"+xFilial("SL1")+cOrcamto,"MF5_ECPEDI")) )
					    If  (Alltrim(SL1->L1_FORMPG) == "FI")
							aRegSC6 := {}
							Loop
					    EndIf
				    EndIf
				EndIf

				Begin Transaction
					MaAvalSC5("SC5",3,.F.,.F.,,,,,,cQuebra,aRegSC6,.T.,!lLibPedCr)					
					aRegSC6 := {}
				End Transaction
				lLibPedCr := .T.			
			EndIf
			If lMa450Ped
				Execblock("MA450PED",.F.,.F.,{cQuebra} )
			Endif
		EndIf
		//������������������������������������������������������������������������Ŀ
		//� Controle de cancelamento do usuario                                    �
		//��������������������������������������������������������������������������
		If lEnd
			Exit
		EndIf
		
		If ( lMt450End )
			ExecBlock("MT450END",.F.,.F.)
		EndIf
		
	EndDo
	dbSelectArea(cAliasSC9)
	dbCloseArea()
	dbSelectArea("SM0")
	dbSkip()
EndDo
//-- Integrado ao wms devera avaliar as regras para convocacao do servico e disponibilizar os 
//-- registros do SDB para convocacao
If	IntDL() .And. !Empty(aLibSDB)
	WmsExeDCF('2')
EndIf
//������������������������������������������������������������������������Ŀ
//�Restaura a integridade da rotina                                        �
//��������������������������������������������������������������������������
cFilAnt := cSavFil
dbSelectArea("SC9")
RestArea(aAreaSM0)
RestArea(aArea)
Return(.T.)



Static Function RetLegenda(nRec)
Local oCor

SC9->(dbGoTo(nRec))	

If SC9->C9_BLEST=='  '.And.SC9->C9_BLCRED=='  '.And.(SC9->C9_BLWMS>='05'.OR.SC9->C9_BLWMS='  ').And.Iif(SC9->((FieldPos('C9_BLTMS') > 0)), Empty(SC9->C9_BLTMS), .T.)
	oCor := oVerde
ElseIf (SC9->C9_BLCRED=='10'.And.SC9->C9_BLEST=='10').Or.(SC9->C9_BLCRED=='ZZ'.And.SC9->C9_BLEST=='ZZ')
	oCor := oVermelho
ElseIf !SC9->C9_BLCRED=='  '.And.SC9->C9_BLCRED<>'10'.And.SC9->C9_BLCRED<>'ZZ'
	oCor := oAzul
ElseIf !SC9->C9_BLEST=='  '.And.SC9->C9_BLEST<>'10'.And.SC9->C9_BLEST<>'ZZ'
	oCor := oPreto
ElseIf SC9->C9_BLWMS<='05'.And.!SC9->C9_BLWMS=='  '
	oCor := oAmarelo
ElseIf Iif(SC9->((FieldPos('C9_BLTMS') > 0)), !Empty(SC9->C9_BLTMS), .F.)
	oCor := oLaranja
EndIf



Return oCor




Static Function markAll()
Local nI

For nI := 1 to len(aBrowse)

	If 	aBrowse[nI,2] <> oVerde .AND. aBrowse[nI,2] <> oVermelho
		aBrowse[nI,1] := .T.
	EndIf

Next nI

oBrowse:refresh()
Return


Static Function CarregaArray(cCondicao)
Local aRet := {}
Local cQuery := ""

cQuery := "SELECT "
cQuery += "	C9_PEDIDO, "
cQuery += "	C9_ITEM, "
cQuery += "	C9_CLIENTE, "
cQuery += "	C9_LOJA, "
cQuery += "	C9_PRODUTO, "
cQuery += "	C9_QTDLIB, "
cQuery += "	C9_NFISCAL, "
cQuery += "	C9_SERIENF, "
cQuery += "	C9_DATALIB, "
cQuery += "	C9_SEQUEN, "
cQuery += "	C9_GRUPO, "
cQuery += "	C9_PRCVEN, "
cQuery += "	C9_AGREG, "
cQuery += "	C9_BLEST, "
cQuery += "	C9_BLCRED, "
cQuery += "	C9_REMITO, "
cQuery += "	C9_ITEMREM, "
cQuery += "	C9_LOCAL, "
cQuery += "	C9_BLWMS, "
cQuery += "	C9_CARGA, "
cQuery += "	C9_SEQCAR, "
cQuery += "	C9_SERVIC, "
cQuery += "	C9_ENDPAD, "
cQuery += "	C9_TPESTR, "
cQuery += "	C9_QTDLIB2, "
cQuery += "	C9_BLINF, "
cQuery += "	C9_TRT, "
cQuery += "	C9_TPOP, "
cQuery += "	C9_DATENT, "
cQuery += "	R_E_C_N_O_ RECN "
cQuery += "FROM "
cQuery += "	" + RetSqlName("SC9") + " SC9 "
cQuery += "WHERE "
cQuery += "	SC9.D_E_L_E_T_ = ' ' AND "
cQuery += "	SC9.C9_FILIAL = '"+xFilial("SC9")+"' "
cQuery +=  cCondicao
cQuery += "ORDER BY C9_PEDIDO,C9_ITEM,C9_SEQUEN,C9_PRODUTO  "

// Processamento da Query	
TCQUERY cQuery NEW ALIAS "qTemp"

TCSetField("qTemp", "C9_DATALIB", "D", 8, 0)
TCSetField("qTemp", "C9_DATENT", "D", 8, 0)


qTemp->(dbGoTop())

While !qTemp->(eof())
	aadd(aRet,{.F.,RetLegenda(qTemp->RECN),qTemp->C9_PEDIDO,qTemp->C9_ITEM,qTemp->C9_CLIENTE,qTemp->C9_LOJA,qTemp->C9_PRODUTO,qTemp->C9_QTDLIB,qTemp->C9_NFISCAL,qTemp->C9_SERIENF,qTemp->C9_DATALIB,qTemp->C9_SEQUEN,qTemp->C9_GRUPO,qTemp->C9_PRCVEN,qTemp->C9_AGREG,qTemp->C9_AGREG,qTemp->C9_BLCRED,qTemp->C9_REMITO,qTemp->C9_ITEMREM,qTemp->C9_LOCAL,qTemp->C9_BLWMS,qTemp->C9_CARGA,qTemp->C9_SEQCAR,qTemp->C9_SERVIC,qTemp->C9_ENDPAD,qTemp->C9_TPESTR,qTemp->C9_QTDLIB2,qTemp->C9_BLINF,qTemp->C9_TRT,qTemp->C9_TPOP,qTemp->C9_DATENT})
	qTemp->(dbSkip())
End

qTemp->(dbCloseArea())



Return aRet



User Function LibAutom()
Local i
Local aArea 		:= GetArea()
Local aAreaSC9 	:= SC9->(GetArea())

/*For i := 1 to len(aBrowse)
	If aBrowse[i,1] // se est� marcado
	
		SC9->(DbSelectArea("SC9"))
		SC9->(dbSetOrder(1)) // C9_FILIAL+C9_PEDIDO+C9_ITEM+C9_SEQUEN+C9_PRODUTO
		SC9->(dbSeek(xFilial("SC9") + aBrowse[i,3] + aBrowse[i,4] + aBrowse[i,12] + aBrowse[i,7]))
		
		U_xLibA("SC9",SC9->(RECNO()))
			
	EndIf

Next
*/

U_xLibA("SC9",SC9->(RECNO()))

AtuBrw()

RestArea(aArea)
RestArea(aAreaSC9)

Return



User Function LibManu()

Local aProds		:= {}
Local nPos			:= 0
Local i
Local aArea 		:= GetArea()
Local aAreaSC9 	:= SC9->(GetArea())

For i := 1 to len(aBrowse)

	If aBrowse[i,1] // se est� marcado
	
		SC9->(DbSelectArea("SC9"))
		SC9->(dbSetOrder(1)) // C9_FILIAL+C9_PEDIDO+C9_ITEM+C9_SEQUEN+C9_PRODUTO
		SC9->(dbSeek(xFilial("SC9") + aBrowse[i,3] + aBrowse[i,4] + aBrowse[i,12] + aBrowse[i,7]))
		
		nPos := aScan(aProds,{|x| alltrim(x[4]) == alltrim(SC9->C9_PRODUTO) } )
		If nPos == 0
			
			aadd(aProds,{SC9->C9_PEDIDO,SC9->C9_ITEM,SC9->C9_SEQUEN,SC9->C9_PRODUTO,SC9->C9_QTDLIB,cValtoChar(SC9->(RECNO())),SC9->C9_PEDIDO})
		Else
			aProds[nPos,5] += SC9->C9_QTDLIB
			aProds[nPos,6] += "," + cValtoChar(SC9->(RECNO()))
			aProds[nPos,7] += "," + SC9->C9_PEDIDO
		EndIf
	EndIf
Next

For i := 1 to len(aProds)

	SC9->(DbSelectArea("SC9"))
	SC9->(dbSetOrder(1)) // C9_FILIAL+C9_PEDIDO+C9_ITEM+C9_SEQUEN+C9_PRODUTO
	SC9->(dbSeek(xFilial("SC9") + aProds[i,1] + aProds[i,2] + aProds[i,3] + aProds[i,4]))
	
	
	
	U_xLibM("SC9",SC9->(RECNO()), aProds[i,5], aProds[i,6], aProds[i,7] )
	
Next

/*
For i := 1 to len(aBrowse)
	If aBrowse[i,1] // se est� marcado
	
		SC9->(DbSelectArea("SC9"))
		SC9->(dbSetOrder(1)) // C9_FILIAL+C9_PEDIDO+C9_ITEM+C9_SEQUEN+C9_PRODUTO
		SC9->(dbSeek(xFilial("SC9") + aBrowse[i,3] + aBrowse[i,4] + aBrowse[i,12] + aBrowse[i,7]))
		
		
		
		U_xLibM("SC9",SC9->(RECNO()) )
			
	EndIf

Next
*/

atuBrw()


RestArea(aArea)
RestArea(aAreaSC9)


Return



User Function NewLib()

Local i
Local aArea 		:= GetArea()
Local aAreaSC9 	:= SC9->(GetArea())

For i := 1 to len(aBrowse)
	If aBrowse[i,1] // se est� marcado
	
		SC9->(DbSelectArea("SC9"))
		SC9->(dbSetOrder(1)) // C9_FILIAL+C9_PEDIDO+C9_ITEM+C9_SEQUEN+C9_PRODUTO
		SC9->(dbSeek(xFilial("SC9") + aBrowse[i,3] + aBrowse[i,4] + aBrowse[i,12] + aBrowse[i,7]))
		
		U_xALib("SC9",SC9->(RECNO()))
			
	EndIf

Next

AtuBrw()

RestArea(aArea)
RestArea(aAreaSC9)

Return

Static Function AtuBrw()

aBrowse := {}
aBrowse := CarregaArray(cCondPers)
oBrowse:SetArray(aBrowse)
oBrowse:Refresh()


Return