// Vers�o de 20/09/07 - 17h
#INCLUDE "CFINC010.CH"
#INCLUDE "PROTHEUS.CH"

#DEFINE QTDETITULOS	1
#DEFINE MOEDATIT		2
#DEFINE VALORTIT		3
#DEFINE VALORREAIS	4

Static lFc010Con 
Static lFc010ConT
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Program   �CFINC010  � Autor �Anderson Zanni         � Data �20.08.2007���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Consulta a Posicao Financeira de Clientes (Personalizado)   ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � Nenhum                                                     ���
�������������������������������������������������������������������������Ĵ��
���Parametros� Nenhum                                                     ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao Efetuada                         ���
�������������������������������������������������������������������������Ĵ��
��� 20/08/07 � Zanni         � Considera cliente de entrega do pedido e   ���
���          �               � todos os clientes de faturamento.          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function CFinc010()
//��������������������������������������������������������������Ŀ
//� Define Variaveis 											           �
//����������������������������������������������������������������
Private cCadastro	:=	STR0005 	  // "Consulta Posi�ao Clientes"
Private aRotina	:=	{{STR0001, "AxPesqui" , 0 , 1},; //"Pesquisar"
						    {STR0002, "AxVisual" , 0 , 2},;  //"Visualizar"
							 {STR0003, "U_cFC010CON()" , 0 , 2},;  //"Consultar"
							 {STR0004, "U_cFC010IMP()" , 0 , 4}}   //"Impressao"

//���������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros 					      �
//� MV_PAR01		  // Emissao De           		            �
//� MV_PAR02		  // Emissao Ate                          �
//� MV_PAR03		  // Vencimento De                        �
//� MV_PAR04		  // Vencimento Ate                       �
//� MV_PAR05		  // Considera Provisorios                �
//� MV_PAR06		  // Do Prefixo                           �
//� MV_PAR07		  // At� Prefixo                          �
//� MV_PAR08        // Considera Faturados                  �
//� MV_PAR09        // Considera Liquidados                 �
//� MV_PAR10        // Pedidos c/Itens Bloq.                �
//� MV_PAR11        // Titulos Gerados por Liquidacao       �
//�����������������������������������������������������������
//������������������������������������������������������������Ŀ
//� Ativa tecla F12 para acessar os parametros				      �
//��������������������������������������������������������������
SetKey(VK_F12, { || pergunte("FIC010",.T.) } )
//������������������������������������������������������������Ŀ
//�Seleciona o Cadastro de Clientes.            			   �
//��������������������������������������������������������������
dbSelectArea("SA1")
dbSetOrder(1)
//��������������������������������������������������������������Ŀ
//� Endereca a funcao de BROWSE                                  �
//����������������������������������������������������������������
mBrowse( 6, 1,22,75,"SA1")
//����������������������������������������������������������������Ŀ
//� Desativa tecla F12                                             �
//������������������������������������������������������������������
SetKey(VK_F12,Nil)
Return(.T.)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �Fc010Con  � Autor � Eduardo Riera         � Data �31.12.1999���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Consunta a Posicao de Clientes                              ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � Nenhum                                                     ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpC1 : Alias                                              ���
���          � ExpN2 : Recno                                              ���
���          � ExpN3 : nOpc da MBrowse      l                             ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao Efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function cFc010Con(cAlias,nRecno,nOpcx)

Local aParam := {}

Private Inclui := .F.
Private Altera := .F.

If Pergunte("FIC010",FunName()=="FINC010") .Or. FunName()<>"FINC010"

	aadd(aParam,MV_PAR01)
	aadd(aParam,MV_PAR02)
	aadd(aParam,MV_PAR03)
	aadd(aParam,MV_PAR04)
	aadd(aParam,MV_PAR05)
	aadd(aParam,MV_PAR06)
	aadd(aParam,MV_PAR07)
	aadd(aParam,MV_PAR08)
	aadd(aParam,MV_PAR09)
	aadd(aParam,MV_PAR10)
	aadd(aParam,MV_PAR11)
	aadd(aParam,MV_PAR12)

	If VerSenha(104) //Permite consulta a Posicao de Cliente
		U_cFc010Cli(aParam)
	Else
		Help(" ",1,"SEMPERM")
	EndIf
EndIf
Return(Nil)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 �fc010Imp  � Autor �Eduardo Riera          � Data �04/01/2000���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Funcao de Impressao ao dos Itens individuais da Posicao de  ���
���          �Cliente.                                                    ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe	 �Fc010Imp()          													  ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpN1		: Recno do Arquivo principal                      ���
���          �ExpN2		: nBrowse                                         ���
�������������������������������������������������������������������������Ĵ��
��� Uso		 � FINC010													 				  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function cFc010Imp()

Local aArea    := GetArea()
Local cTitulo  := cCadastro
Local cDesc1   := STR0048 //"Este programa ir� imprimir a Consulta de um Cliente,"
Local cDesc2   := STR0049 //"informando os dados acumulados do Cliente, os Pedidos"
Local cDesc3   := STR0050 //"em aberto, Titulos em Aberto e rela��o do Faturamento."
Local cString  := "SA1"
Local wnrel    := "FINC010"

Private Tamanho := "G"
Private Limite  := 220
Private cPerg   := "FIC010"
Private aReturn := { STR0051,1,STR0051,1,2,1,"",1} //"Zebrado"###"Administracao"
Private nLastKey:= 0
Private m_pag   := 1
Private lEnd    := .F.
Private nCasas := GetMv("MV_CENT")

If Pergunte(cPerg,.T.)
	wnrel := SetPrint(cString,wnrel,cPerg,@cTitulo,cDesc1,cDesc2,cDesc3,.F.,,.F.,Tamanho,,.F.)
	If ( nLastKey == 0 )
		SetDefault(aReturn,cString)
		If ( nLastKey == 0 )
			RptStatus({|lEnd| ImpDet(@lEnd,wnRel,cString,"FINC010",cTitulo)},cTitulo)
		EndIf
	EndIf
	dbSelectArea(cString)
	dbClearFilter()
	dbSetOrder(1)
	RestArea(aArea)
EndIf

Return(.T.)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �Fc010Cli  � Autor � Eduardo Riera         � Data �31.12.1999���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Consulta a Posicao de Clientes                              ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � Nenhum                                                     ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpA1 : [1] Data de Emissao Inicial                        ���
���          �         [2] Data de Emissao Final                          ���
���          �         [3] Vencimento Inicial                             ���
���          �         [4] Vencimento Final                               ���
���          �         [5] Considera Provisorios (1) Sim (2) Nao          ���
���          �         [6] Prefixo Inicial                                ���
���          �         [7] Prefixo Final                                  ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao Efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���18/08/2000�Eduardo Motta  � Botao para consultar OSs em Aberto caso    ���
���          �               � esteja instalado o VEICULOS                ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function cFc010Cli(aParam)

Local aArea 	:= GetArea()
Local aAlias	:= {}
Local oDlg
Local cCadastro := STR0005 //"Consulta Posi�ao Clientes"
Local cCgc		:= RetTitle("A1_CGC")
Local cMoeda    := ""
Local nMcusto   := Iif(SA1->A1_MOEDALC > 0, SA1->A1_MOEDALC, Val(GetMv("MV_MCUSTO")))         
Local aSavAhead := If(Type("aHeader")=="A",aHeader,{})
Local aSavAcol  := If(Type("aCols")=="A",aCols,{})
Local nSavN     := If(Type("N")=="N",n,0)
Local nConLin   := 0
Local aCols     :={}
Local aHeader   :={}
Local cSalFin	:=""
Local cLcFin	:=""
Local aGet      := {"","","",""}
Local cTelefone := Alltrim(SA1->A1_DDI+" "+SA1->A1_DDD+" "+SA1->A1_TEL)
Local lFc010Bol := ExistBlock( "FC010BOL" )
Local lSigaGE   := GetMv("MV_ACATIVO") //Integracao Gestao Educacional

SX3->(DbSetOrder(2))
cLcFin	:=	If(SX3->(DbSeek("A1_LCFIN")) ,X3Titulo(),STR0076)
cSalFin  := If(SX3->(DbSeek("A1_SALFIN")),X3Titulo(),STR0075)
cMoeda  		:= " "+Pad(Getmv("MV_SIMB"+Alltrim(STR(nMCusto))),4)
lFc010ConT      := If(lFc010ConT==Nil,ExistTemplate("FC010CON"),lFc010ConT)
lFc010Con       := If(lFc010Con==Nil,ExistBlock("FC010CON"),lFc010Con) 
Private nCasas := GetMv("MV_CENT")

aHeader	:= {STR0077,STR0078,STR0069+AllTrim(cMoeda)," ",STR0077,STR0005}  
//LIMITE DE CREDITO # PRIMEIRA COMPRA
Aadd(aCols,{STR0014,TRansform(xMoeda(SA1->A1_LC, nMcusto, 1,dDataBase),PesqPict("SA1","A1_LC",14,1)),;
			TRansform(SA1->A1_LC,PesqPict("SA1","A1_LC",14,nMCusto)),;
			" ",if(lSigaGE,STR0111,STR0015),SPACE(07)+DtoC(SA1->A1_PRICOM)}) // LIMITE DE CREDITO # Primeira Parcela / Primeira Compra 
//SALDO # ULTIMA COMPRA
Aadd(aCols,{if(lSigaGE,STR0109,STR0010),TRansform(SA1->A1_SALDUP,PesqPict("SA1","A1_SALDUP",14,1) ),;
            TRansform(SA1->A1_SALDUPM,PesqPict("SA1","A1_SALDUPM",14,nMcusto)),;
			" ",if(lSigaGE,STR0112,STR0016),SPACE(07)+DtoC(SA1->A1_ULTCOM)}) // Valor Parcelas / Saldo  / Ultima Parcela / Ultima Compra
//Limite de credito secundario # MAIOR ATRASO
Aadd(aCols,{cLcFin,TRansform(xMoeda(SA1->A1_LCFIN,nMcusto,1,dDatabase,MsDecimais(1)),PesqPict("SA1","A1_LCFIN",14,1)),;     
            TRansform(SA1->A1_LCFIN,PesqPict("SA1","A1_LCFIN",14,nMcusto)),;
            " ",STR0017,Transform(SA1->A1_MATR,PesqPict("SA1","A1_MATR",14))}) // Limite sec / Maior Atraso    
//SAldo do limite de credito secundario $ media de Atraso
Aadd(aCols,{cSalFin,TRansform(SA1->A1_SALFIN,PesqPict("SA1","A1_SALFIN",14,1)),;
           TRansform(SA1->A1_SALFINM,PesqPict("SA1","A1_SALFINM",14,nMcusto)),;
           " ",STR0018,Transform(SA1->A1_METR,PesqPict("SA1","A1_METR",14))}) // Saldo em Cheque / Media de Atraso
//Maior Compra # Grau de risco
Aadd(aCols,{if(lSigaGE,STR0110,STR0011),;
				TRansform(xMoeda(SA1->A1_MCOMPRA, nMcusto ,1, dDataBase,MsDecimais(1) ),PesqPict("SA1","A1_MCOMPRA",14,1) ) ,;
				TRansform(SA1->A1_MCOMPRA,PesqPict("SA1","A1_MCOMPRA",14,nMcusto)),;
                " ",STR0019,SPACE(25)+SA1->A1_RISCO}) // Maior Compra / Grau de Risco
//MAior Saldo
Aadd(aCols,{STR0012,;
			TRansform(xMoeda(SA1->A1_MSALDO, nMcusto ,1, dDataBase,MsDecimais(1) ),PesqPict("SA1","A1_MSALDO",14,1)),;
            TRansform(SA1->A1_MSALDO,PesqPict("SA1","A1_MSALDO",14,nMcusto)),;
            " "," ",""}) //Maior saldo
 
DEFINE MSDIALOG oDlg FROM	09,0 TO 30,80 TITLE cCadastro OF oMainWnd

@ 001,002 TO 043, 267 OF oDlg	PIXEL
@ 130,002 TO 154, 114 OF oDlg	PIXEL
@ 130,121 TO 154, 267 OF oDlg	PIXEL

If lSigaGE
	
	DbSelectArea("JA2")
	DbSetOrder( 5 )
	dbSeek(xFilial("JA2")+SA1->A1_COD+SA1->A1_LOJA)
	
	@ 004,005 SAY STR0108 SIZE 050,07          OF oDlg PIXEL	// Registro Academico
	@ 012,004 GET JA2->JA2_NUMRA 		SIZE 075,09 WHEN .F. OF oDlg PIXEL
	
Else
	
	@ 004,005 SAY STR0006 SIZE 025,07          OF oDlg PIXEL //"Codigo"
	@ 012,004 MSGET SA1->A1_COD      SIZE 070,09 WHEN .F. OF oDlg PIXEL

	@ 004,077 SAY STR0007 SIZE 020,07          OF oDlg PIXEL //"Loja"
	@ 012,077 MSGET SA1->A1_LOJA     SIZE 021,09 WHEN .F. OF oDlg PIXEL
	
EndIf

@ 004,100 SAY STR0008 SIZE 025,07 OF oDlg PIXEL //"Nome"
@ 012,100 MSGET SA1->A1_NOME     SIZE 150,09 WHEN .F. OF oDlg PIXEL

@ 023,005 SAY cCGC    SIZE 025,07 OF oDlg PIXEL
@ 030,004 MSGET SA1->A1_CGC      SIZE 070,09 PICTURE StrTran(PicPes(SA1->A1_PESSOA),"%C","") WHEN .F. OF oDlg PIXEL

@ 023,077 SAY STR0009 SIZE 025,07 OF oDlg PIXEL //"Telefone"
@ 030,077 MSGET cTelefone	       SIZE 060,09 WHEN .F. OF oDlg PIXEL

@ 023,141 SAY RetTitle("A1_VENCLC")  SIZE 035,07 OF oDlg PIXEL
@ 030,141 MSGET SA1->A1_VENCLC       SIZE 060,09 WHEN .F. OF oDlg PIXEL

If ! lSigaGE
	
	@ 023,206 SAY STR0057 SIZE 035,07 OF oDlg PIXEL //"Vendedor"
	@ 030,206 MSGET SA1->A1_VEND  	 SIZE 053,09 WHEN .F. OF oDlg PIXEL

EndIf

oLbx := RDListBox(3.5, .42, 264, 70, aCols, aHeader,{38,51,51,11,50,63})   

@ 124,002 SAY STR0020 SIZE 061,07 OF oDlg PIXEL //"Cheques Devolvidos"
@ 124,121 SAY STR0021 SIZE 061,07 OF oDlg PIXEL //"Titulos Protestados"

@ 133,005 SAY STR0022 SIZE 034,07 OF oDlg PIXEL //"Quantidade"
@ 133,045 SAY STR0023 SIZE 066,07 OF oDlg PIXEL //"Ultimo Devolvido"
@ 133,126 SAY STR0022 SIZE 034,07 OF oDlg PIXEL //"Quantidade"
@ 133,163 SAY STR0024 SIZE 076,07 OF oDlg PIXEL //"Ultimo Protesto"

@ 141,006 MSGET SA1->A1_CHQDEVO  SIZE 024,08 WHEN .F. OF oDlg PIXEL
@ 141,045 MSGET SA1->A1_DTULCHQ  SIZE 050,08 WHEN .F. OF oDlg PIXEL
@ 141,126 MSGET SA1->A1_TITPROT  SIZE 024,08 WHEN .F. OF oDlg PIXEL
@ 141,163 MSGET SA1->A1_DTULTIT  SIZE 050,08 WHEN .F. OF oDlg PIXEL

@ 001,272 BUTTON Iif(lSigaGE,STR0105,STR0025) SIZE 40,12 FONT oDlg:oFont ACTION If( lFc010Bol, ExecBlock( "FC010BOL", .F., .F., {1,@aAlias,aParam,.T.,aGet} ), U_cFc010Brow(1,@aAlias,aParam,.T.,aGet))  OF oDlg PIXEL //"Boleto Aberto" / "Tit Aberto"
@ 015,272 BUTTON Iif(lSigaGE,STR0106,STR0026) SIZE 40,12 FONT oDlg:oFont ACTION If( lFc010Bol, ExecBlock( "FC010BOL", .F., .F., {2,@aAlias,aParam,.T.,aGet} ), U_cFC010Brow(2,@aAlias,aParam,.T.,aGet))  OF oDlg PIXEL //"Boleto Pago" / "Tit Recebidos"

If ! lSigaGE
	@ 029,272 BUTTON STR0027 SIZE 40,12 FONT oDlg:oFont ACTION U_cFc010Brow(3,@aAlias,aParam,.T.,aGet)	OF oDlg PIXEL //"Pedidos"
	@ 043,272 BUTTON STR0028 SIZE 40,12 FONT oDlg:oFont ACTION U_cFc010Brow(4,@aAlias,aParam,.T.,aGet)	OF oDlg PIXEL //"Faturamento"
	nConLin+=14
Else
	@ 029,272 BUTTON STR0107 SIZE 40,12 ACTION ACAR590(JA2->JA2_NUMRA) OF oDlg PIXEL  // "Extrato"
EndIf

If ( cPaisLoc<>"BRA" )
	@ 043+nConLin,272 BUTTON STR0029 SIZE 40,12 FONT oDlg:oFont ACTION U_cFc010Brow(5,@aAlias,aParam,.T.,aGet)	OF oDlg PIXEL //"Cheques/Trans"
	nConLin+=14
EndIf
If ( lFC010ConT )
	@ 043+nConLin,272 BUTTON STR0030 SIZE 40,12 FONT oDlg:oFont ACTION ExecTemplate("FC010CON",.F.,.F.) OF oDlg  PIXEL //"Cons.Especif."
	nConLin+=14
EndIf
If ( lFC010Con )
	@ 043+nConLin,272 BUTTON STR0030 SIZE 40,12 FONT oDlg:oFont ACTION ExecBlock("FC010CON",.F.,.F.) OF oDlg  PIXEL //"Cons.Especif."
	nConLin+=14
EndIf
If Trim(GetMV("MV_VEICULO")) == "S"
   @ 043+nConLin,272 BUTTON STR0058 SIZE 40,12 FONT oDlg:oFont ACTION FG_SALOSV(SA1->A1_COD,SA1->A1_LOJA,," ","T") OF oDlg PIXEL  //"OSs em Aberto"
   nConLin+=14
EndIf   
If Select("SAO") # 0
   @ 043+nConLin,272 BUTTON STR0059 SIZE 40,12 FONT oDlg:oFont ACTION Mata030Ref("SA1",SA1->(Recno()),2) OF oDlg PIXEL //"Referencias"
   nConLin+=14
EndIf   
@ 043+nConLin,272 BUTTON STR0095 SIZE 40,12 FONT oDlg:oFont ACTION TmkC020() OF oDlg PIXEL //Historico de Cobranca
@ 143,272 BUTTON STR0031 SIZE 40,12 FONT oDlg:oFont ACTION oDlg:End() 	OF oDlg PIXEL //"Sair"
ACTIVATE MSDIALOG oDlg CENTERED

//������������������������������������������������������������������������Ŀ
//�Restaura a Integridade dos Dados                                        �
//��������������������������������������������������������������������������
aHeader := aSavAHead
aCols   := aSavaCol
N       := nSavN
aEval(aAlias,{|x| (x[1])->(dbCloseArea()),Ferase(x[2]+GetDBExtension()),Ferase(x[2]+OrdBagExt())})
dbSelectArea("SA1")
RestArea(aArea)

Return(.T.)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �Fc010Brow � Autor � Eduardo Riera         � Data �31.12.1999���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Consulta a Posicao de Clientes                              ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � Nenhum                                                     ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpN1 : nOpcao                                             ���
���          �         [1] Titulos em Aberto                              ���
���          �         [2] Titulos Recebidos                              ���
���          �         [3] Pedidos                                        ���
���          �         [4] Faturamento                                    ���
���          � ExpA2 : Alias a Serem Fechados.                            ���
���          � ExpA3 : [1] Data de Emissao Inicial                        ���
���          �         [2] Data de Emissao Final                          ���
���          �         [3] Vencimento Inicial                             ���
���          �         [4] Vencimento Final                               ���
���          �         [5] Considera Provisorios (1) Sim (2) Nao          ���
���          �         [6] Prefixo Inicial                                ���
���          �         [7] Prefixo Final                                  ���
���          � ExpL4 : Indica se os dados devem ser exibidos              ���
���          � ExpL5 : Indica se os dados serao montados para o relatorio ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao Efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function cFc010Brow(nBrowse,aAlias,aParam,lExibe,aGet,lRelat)

Local aArea		:= GetArea()
Local aAreaSC5  := SC5->(GetArea())
Local aAreaSC6  := SC6->(GetArea())
Local aAreaSC9  := SC9->(GetArea())
Local aAreaSF4  := SF4->(GetArea())
Local aStru		:= {}
Local aQuery    := {}
Local aSay      := {"","","","","","",""}
Local oGetDb
Local oScrPanel
Local oBold
Local oDlg
Local oBtn
Local bVisual
Local bWhile
Local bFiltro
Local cAlias	:= ""
Local cArquivo  := ""
Local cCadastro := ""
#IFDEF TOP
	Local cQuery    := ""
	Local cDbMs
#ENDIF	
Local cQry		:= ""
Local cChave	:= ""
Local lQuery    := .F.
Local nCntFor   := 0
Local nSalped   := 0
Local nSalpedl  := 0
Local nSalpedb  := 0
Local nQtdPed   := 0
Local nTotAbat := 0
Local cAnterior := ""
Local nTaxaM	:= 0	
Local nMoeda
Local oTipo,nTipo	:=	1	,	bTipo,oCheq
Local aTotRec := {{0,1,0,0}} // Totalizador de titulos a receber por por moeda
Local aTotPag := {{0,1,0,0}} // Totalizador de titulos recebidos por por moeda
Local nAscan 
Local nTotalRec:=0
Local aSize     := MsAdvSize( .F. )
Local aPosObj1  := {}                 
Local aObjects  := {}                       
Local aCpos     := {}
Local cCheques	:=	IIF(Type('MVCHEQUES')=='C',MVCHEQUES,MVCHEQUE)
Local nI
Local lPosClFt  := (SuperGetMv("MV_POSCLFT",.F.,"N") == "S")

Private aHeader := {}
DEFAULT lRelat := .F.

aGet := {"","","","","","",""}

Do Case
Case ( nBrowse == 1 )	
	cCadastro := STR0025
	cAlias    := "FC010QRY01"
	aSay[1]   := STR0032 //"Qtd.Tit."
	aSay[2]   := STR0033 //"Principal"
	aSay[3]   := STR0034 //"Saldo"
	aSay[4]   := STR0046 //"Juros"
	aSay[5]   := STR0091 //"Acresc."
	aSay[6]   := STR0092 //"Decresc."
	aSay[7]   := STR0104 //"Tot.Geral"
	bVisual   := {|| Fc010Visua((cAlias)->XX_RECNO,nBrowse) }
Case ( nBrowse == 2 )
	cCadastro := STR0026
	cAlias    := "FC010QRY02"
	aSay[1]   := STR0036 //"Qtd.Pag."
	aSay[2]   := STR0037 //"Principal"
	aSay[3]   := STR0038 //"Vlr.Pagto"
	bVisual   := {|| Fc010Visua((cAlias)->XX_RECNO,nBrowse) }
Case ( nBrowse == 3 )
	cCadastro := STR0027
	cAlias    := "FC010QRY03"
	aSay[1]   := STR0039 //"Qtd.Ped."
	aSay[2]   := STR0040 //"Tot.Pedido"
	aSay[3]   := STR0041 //"Tot.Liber."
	aSay[4]   := STR0042 //"Sld.Pedido"
	bVisual   := {|| Fc010Visua((cAlias)->XX_RECNO,nBrowse) }
Case ( nBrowse == 4 )
	cCadastro := STR0028
	cAlias    := "FC010QRY04"
	aSay[1]   := STR0043 //"Qtd.Notas"
	aSay[2]   := STR0044 //"Tot.Fatur."
	bVisual   := {|| Fc010Visua((cAlias)->XX_RECNO,nBrowse) }
Case ( nBrowse == 5 )
   cCadastro := STR0061 //"Cartera de cheques"
   cAlias    := "FC010QRY05"
   aSay[1]   := STR0062 //"Pendiente"
	If cPaisLoc == 'URU'
		aSay[2]   := STR0088 //"Rechazado"
	Else
	   aSay[2]   := STR0063 //"Negociado"
	Endif   
   aSay[3]   := STR0064 //"Cobrado"
   bVisual   := {|| Fc010Visua((cAlias)->XX_RECNO,1) }
EndCase

Do Case
	//������������������������������������������������������������������������Ŀ
	//�Titulo em Aberto                                                        �
	//��������������������������������������������������������������������������
	Case ( nBrowse == 1 )
		If !lRelat
			Aadd(aHeader,{"",	"XX_BITMAP","@BMP",10,0,"","","C","",""})
			Aadd(aStru,{"XX_BITMAP","C",12,0})
		Endif	
		dbSelectArea("SX3")
		dbSetOrder(2)
		dbSeek("E1_FILIAL")
		aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
		aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		dbSeek("E1_CLIENTE")
		aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
		aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		dbSeek("E1_LOJA")
		aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
		aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		dbSeek("E1_NOMCLI")
		aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
		aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		dbSeek("E1_PREFIXO")
		aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
		aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		dbSeek("E1_NUM")
		aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
		aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		dbSeek("E1_PARCELA")
		aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
		aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		dbSeek("E1_TIPO")
		aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
		aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		dbSeek("E1_EMISSAO")
		aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
		aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		dbSeek("E1_VENCTO")
		aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
		aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		dbSeek("E1_VENCREA")
		aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
		aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		
		If !lRelat
			dbSeek("E1_MOEDA")
			aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
			
			dbSeek("E1_VALOR")
			aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
			aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
			aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		Endif	

		dbSeek("E1_VLCRUZ")
		aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
		aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})

		aadd(aHeader,{STR0086,"E1_ABT","@E 999,999,999.99",14,2,"","","N","","V" } ) //"Abatimentos"
		aadd(aStru ,{"E1_ABT","N",14,2})

		dbSeek("E1_SDACRES")
		aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
		aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})

		dbSeek("E1_SDDECRE")
		aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
		aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})

		dbSeek("E1_VALJUR")
		aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
		aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})

		dbSeek("E1_SALDO")
		aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
		aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})

		aadd(aHeader,{ STR0103,"E1_SALDO2",SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } ) // "Saldo na moeda tit"
		aadd(aStru ,{"E1_SALDO2",SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})

		dbSeek("E1_NATUREZ")
		aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
		aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		dbSeek("E1_PORTADO")
		aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
		aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		dbSeek("E1_NUMBCO")
		aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
		aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})

		If !lRelat
			dbSeek("E1_NUMLIQ")
			aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
			aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
			aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		Endif

		dbSeek("E1_HIST")
		aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
		aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})

		aadd(aHeader,{STR0035,"E1_ATR","99999",5,0,"","","N","","V" } ) //"Atraso"
		aadd(aStru ,{"E1_ATR","N",5,0})

		If !lRelat
			dbSeek("E1_CHQDEV")
			aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		Endif

		#ifdef SPANISH
			Aadd(aStru,{"X5_DESCSPA","C",25,0})
		#else
			#ifdef ENGLISH
				Aadd(aStru,{"X5_DESCENG","C",25,0})			
			#else
				Aadd(aStru,{"X5_DESCRI","C",25,0})
			#endif
		#endif
		
		aadd(aStru,{"XX_RECNO","N",12,0})
		If !lRelat
			aadd(aStru,{"E1_MOEDA","N",02,0})
		Endif	

		aadd(aQuery,{"E1_PORCJUR","N",12,4})
		aadd(aQuery,{"E1_MOEDA","N",02,0})
		aadd(aQuery,{"E1_VALOR","N",16,2})
		
		If cPaisLoc == "BRA"
			aadd(aQuery,{"E1_TXMOEDA","N",17,4})
		Endif	

		#ifdef SPANISH
			Aadd(aHeader,{STR0045,"X5_DESCSPA","@!",25,0,"","","C","SX5","" } ) //"Situacao"					
		#else
			#ifdef ENGLISH
				Aadd(aHeader,{STR0045,"X5_DESCENG","@!",25,0,"","","C","SX5","" } ) //"Situacao"								
			#else
				Aadd(aHeader,{STR0045,"X5_DESCRI","@!",25,0,"","","C","SX5","" } ) //"Situacao"
			#endif
		#endif

		SX3->(dbSetOrder(1))

		If ( Select(cAlias) ==	0 )
			cArquivo := CriaTrab(,.F.)			
			aadd(aAlias,{ cAlias , cArquivo })
			aadd(aStru,{"FLAG","L",01,0})
			dbCreate(cArquivo,aStru)
			dbUseArea(.T.,,cArquivo,cAlias,.F.,.F.)
			IndRegua(cAlias,cArquivo,"E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO")

			#IFDEF TOP
				If ( TcSrvType()!="AS/400" )
					lQuery := .T.
					cQuery := ""
					aEval(aQuery,{|x| cQuery += ","+AllTrim(x[1])})
					cQuery := "SELECT "+SubStr(cQuery,2)
					cQuery +=         ",SE1.R_E_C_N_O_ SE1RECNO"
					
					#ifdef SPANISH
						cQuery += ",SX5.X5_DESCSPA "
					#else
						#ifdef ENGLISH
							cQuery += ",SX5.X5_DESCENG "				
						#else
							cQuery += ",SX5.X5_DESCRI "								
						#endif
					#endif
					
					cQuery += "FROM "+RetSqlName("SE1")+" SE1,"
					cQuery +=         RetSqlName("SX5")+" SX5 "
					cQuery += "WHERE "  //SE1.E1_FILIAL='"+xFilial("SE1")+"' AND "
					//cQuery +=       "SE1.E1_CLIENTE='"+SA1->A1_COD+"' AND "
					//cQuery +=       "SE1.E1_LOJA='"+SA1->A1_LOJA+"' AND "
					cQuery +=       "SE1.E1_CLIENTE+E1_LOJA In ("+U_Titular(SA1->A1_COD, SA1->A1_LOJA)+") AND "
					cQuery +=       "SE1.E1_EMISSAO>='"+Dtos(aParam[1])+"' AND "
					cQuery +=       "SE1.E1_EMISSAO<='"+Dtos(aParam[2])+"' AND "
					cQuery +=       "SE1.E1_VENCREA>='"+Dtos(aParam[3])+"' AND "
					cQuery +=       "SE1.E1_VENCREA<='"+Dtos(aParam[4])+"' AND "
					If ( aParam[5] == 2 )
						cQuery +=   "SE1.E1_TIPO<>'PR ' AND "
					EndIf					
					cQuery += "SE1.E1_PREFIXO>='"+aParam[6]+"' AND "
					cQuery += "SE1.E1_PREFIXO<='"+aParam[7]+"' AND " 
					If cPaisLoc != "BRA"
						cQuery += "SE1.E1_TIPO NOT IN" + FormatIn(cCheques,"|") + " AND "
					Endif	
					cQuery += "SE1.E1_FATURA IN('"+Space(Len(SE1->E1_FATURA))+"','NOTFAT') AND "
					cQuery += "SE1.E1_SALDO > 0 AND "

					If aParam[11] == 2 // Se nao considera titulos gerados pela liquidacao
						cQuery += "SE1.E1_NUMLIQ ='"+Space(Len(SE1->E1_NUMLIQ))+"' AND "
						cQuery += "SE1.E1_TIPOLIQ='"+Space(Len(SE1->E1_TIPOLIQ))+"' AND "
					Endif

					cQuery +=		"SE1.D_E_L_E_T_=' ' AND "
					cQuery +=      "SX5.X5_FILIAL='"+xFilial("SX5")+"' AND "
					cQuery +=		"SX5.X5_TABELA='07' AND "
					cQuery +=		"SX5.X5_CHAVE=SE1.E1_SITUACA AND "
					cQuery +=		"SX5.D_E_L_E_T_=' ' "

					cQuery += "AND SE1.E1_TIPO NOT LIKE '__-' UNION ALL "+cQuery
					cQuery += "AND SE1.E1_TIPO LIKE '__-'"

					cQuery := ChangeQuery(cQuery)
					cQry   := cArquivo+"A"

					dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cQry,.T.,.T.)

					aEval(aQuery,{|x| If(x[2]!="C",TcSetField(cQry,x[1],x[2],x[3],x[4]),Nil)})
				Else
			#ENDIF
				cQry := "SE1"
			#IFDEF TOP
				EndIf
			#ENDIF
			dbSelectArea(cQry)
			If ( !lQuery )
				dbSetOrder(2)
				dbSeek(xFilial("SE1")+SA1->A1_COD+SA1->A1_LOJA)

				bWhile := {|| !Eof() .And. xFilial("SE1") == SE1->E1_FILIAL .And.;
											SA1->A1_COD    == SE1->E1_CLIENTE .And.;
											SA1->A1_LOJA   == SE1->E1_LOJA }
				bFiltro:= {|| !(SE1->E1_TIPO $ MVABATIM) .And.;
									SE1->E1_EMISSAO >= aParam[1] .And.;
									SE1->E1_EMISSAO <= aParam[2] .And.;
									SE1->E1_VENCREA >= aParam[3] .And.;
									SE1->E1_VENCREA <= aParam[4] .And.;
									If(aParam[5]==2,SE1->E1_TIPO!="PR ",.T.) .And.;
									SE1->E1_PREFIXO >= aParam[6] .And.;
									SE1->E1_PREFIXO <= aParam[7] .And.;
									SE1->E1_SALDO   > 0 .And.;
									IIf(cPaisLoc == "BRA",.T.,!(SE1->E1_TIPO$cCheques)) .And.;
									IIF(aParam[11] == 2, Empty(SE1->E1_NUMLIQ) .And. Empty(SE1->E1_TIPOLIQ),.T.)}
			Else
				bWhile := {|| !Eof() }
				bFiltro:= {|| .T. }
			EndIf			
			While ( Eval(bWhile) )				
				If ( Eval(bFiltro) )
					If ( !lQuery )
						dbSelectArea("SX5")
						dbSetOrder(1)
						MsSeek(xFilial("SX5")+"07"+SE1->E1_SITUACA)
					EndIf
					dbSelectArea(cAlias)
					dbSetOrder(1)
					cChave := (cQry)->(E1_CLIENTE)+(cQry)->(E1_LOJA) +;
								 (cQry)->(E1_PREFIXO)+(cQry)->(E1_NUM)+;
								 (cQry)->(E1_PARCELA)
					cChave += If((cQry)->(E1_TIPO)	$ MVABATIM, "",;
					              (cQry)->(E1_TIPO))
					If ( !dbSeek(cChave) )
						RecLock(cAlias,.T.)						
					Else
						RecLock(cAlias,.F.)
					EndIf
					DbSetOrder(1)
					nTotAbat := 0
					For nCntFor := 1 To Len(aStru)
						Do Case
						
						#ifdef SPANISH
							Case ( AllTrim(aStru[nCntFor][1])=="X5_DESCSPA" )
								If !( (cQry)->(E1_TIPO)	$ MVABATIM )
									If ( lQuery )
										(cAlias)->X5_DESCSPA := (cQry)->X5_DESCSPA
									Else
										(cAlias)->X5_DESCSPA := SX5->X5_DESCSPA
									EndIf
								Endif	
						#else
							#ifdef ENGLISH
								Case ( AllTrim(aStru[nCntFor][1])=="X5_DESCENG" )
									If !( (cQry)->(E1_TIPO)	$ MVABATIM )
										If ( lQuery )
											(cAlias)->X5_DESCENG := (cQry)->X5_DESCENG
										Else
											(cAlias)->X5_DESCENG := SX5->X5_DESCENG
										EndIf
									Endif	
							#else
								Case ( AllTrim(aStru[nCntFor][1])=="X5_DESCRI" )
									If !( (cQry)->(E1_TIPO)	$ MVABATIM )
										If ( lQuery )
											(cAlias)->X5_DESCRI := (cQry)->X5_DESCRI
										Else
											(cAlias)->X5_DESCRI := SX5->X5_DESCRI
										EndIf
									Endif	
							#endif
						#endif
							
						Case ( AllTrim(aStru[nCntFor][1])=="E1_VALJUR" )
						Case ( AllTrim(aStru[nCntFor][1])=="E1_ABT" )
							If cPaisLoc == "BRA"
								nTaxaM := (cQry)->E1_TXMOEDA
							Else
								nTaxaM:=round((cQry)->E1_VLCRUZ / (cQry)->E1_VALOR,4)  // Pegar a taxa da moeda usada qdo da inclus�o do titulo
							Endif
							If ( (cQry)->(E1_TIPO)	$ MVABATIM )
								(cAlias)->E1_ABT += (nTotAbat := xMoeda((cQry)->(E1_SALDO),(cQry)->(E1_MOEDA),1,(cQry)->(E1_EMISSAO),,nTaxaM))
							Endif
							If ( !lQuery )
								(cAlias)->E1_ABT := (nTotAbat := SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,,SE1->E1_CLIENTE,SE1->E1_LOJA))
							Endif
						
						Case ( AllTrim(aStru[nCntFor][1])=="E1_SALDO" )
							If cPaisLoc == "BRA"
								nTaxaM := (cQry)->E1_TXMOEDA
							Else
								nTaxaM:=round((cQry)->E1_VLCRUZ / (cQry)->E1_VALOR,4)  // Pegar a taxa da moeda usada qdo da inclus�o do titulo
							Endif	
							If ( (cQry)->(E1_TIPO)	$ MVABATIM )
								If aParam[12] == 2	 // mv_par12 = 2 : Considera juros e taxa de pernamencia na visualizacao de titulos em aberto.
									(cAlias)->E1_SALDO -= nTotAbat
								Endif
							Else
								(cAlias)->E1_SALDO += xMoeda((cQry)->(E1_SALDO),(cQry)->(E1_MOEDA),1,dDataBase,,ntaxaM)
								If aParam[12] == 2   // mv_par12 = 2 : Considera juros e taxa de pernamencia na visualizacao de titulos em aberto.
									(cAlias)->E1_SALDO += xMoeda((cAlias)->E1_SDACRES - (cAlias)->E1_SDDECRE,(cQry)->(E1_MOEDA),1,dDataBase,,ntaxaM)
									(cAlias)->E1_SALDO += xMoeda(FaJuros((cQry)->E1_VALOR,(cQry)->E1_SALDO,(cQry)->E1_VENCTO,(cQry)->E1_VALJUR,(cQry)->E1_PORCJUR,(cQry)->E1_MOEDA,(cQry)->E1_EMISSAO,,If(cPaisLoc=="BRA",(cQry)->E1_TXMOEDA,0)),(cQry)->E1_MOEDA,1,,,If(cPaisLoc=="BRA",(cQry)->E1_TXMOEDA,0))
								Endif
							EndIf
							If ( !lQuery )
								If aParam[12] == 2   // mv_par12 = 2 : Considera juros e taxa de pernamencia na visualizacao de titulos em aberto.	
									(cAlias)->E1_SALDO -= nTotAbat
								Endif
							EndIf
						Case ( AllTrim(aStru[nCntFor][1])=="E1_SALDO2" )
							If ( (cQry)->(E1_TIPO)	$ MVABATIM )
								If aParam[12] == 2   // mv_par12 = 2 : Considera juros e taxa de pernamencia na visualizacao de titulos em aberto.	
									(cAlias)->E1_SALDO2 -= nTotAbat
								Endif
							Else
								(cAlias)->E1_SALDO2 += (cQry)->(E1_SALDO)
								If aParam[12] == 2   // mv_par12 = 2 : Considera juros e taxa de pernamencia na visualizacao de titulos em aberto.	
									(cAlias)->E1_SALDO2 += (cAlias)->E1_SDACRES - (cAlias)->E1_SDDECRE
									(cAlias)->E1_VALJUR := xMoeda(FaJuros((cQry)->E1_VALOR,(cAlias)->E1_SALDO2,(cQry)->E1_VENCTO,(cQry)->E1_VALJUR,(cQry)->E1_PORCJUR,(cQry)->E1_MOEDA,(cQry)->E1_EMISSAO,,If(cPaisLoc=="BRA",(cQry)->E1_TXMOEDA,0)),(cQry)->E1_MOEDA,1,,,If(cPaisLoc=="BRA",(cQry)->E1_TXMOEDA,0))
									(cAlias)->E1_SALDO2 += xMoeda((cAlias)->E1_VALJUR,1,(cQry)->(E1_MOEDA),dDataBase,,ntaxaM)
								Endif
							EndIf
							If ( !lQuery )
								If aParam[12] == 2   // mv_par12 = 2 : Considera juros e taxa de pernamencia na visualizacao de titulos em aberto.	
									(cAlias)->E1_SALDO2 -= nTotAbat
								Endif
							EndIf		
						Case ( AllTrim(aStru[nCntFor][1])=="XX_RECNO" )
							If !( (cQry)->(E1_TIPO)	$ MVABATIM )
								If ( lQuery )
									(cAlias)->XX_RECNO := (cQry)->SE1RECNO
								Else
									(cAlias)->XX_RECNO := SE1->(RecNo())
								EndIf
							Endif
						Case ( !lRelat .And. AllTrim(aStru[nCntFor][1])=="XX_BITMAP" )
							If (cQry)->E1_CHQDEV == "1"
								(cAlias)->XX_BITMAP := 	"BR_AMARELO"
							Else
								(cAlias)->XX_BITMAP := If(ROUND((cQry)->E1_SALDO,2) != ROUND((cQry)->E1_VALOR,2),"BR_AZUL","BR_VERDE")
							Endif
						Case ( AllTrim(aStru[nCntFor][1])=="E1_TIPO" )
							If ( Empty((cAlias)->E1_TIPO) )
								(cAlias)->E1_TIPO := (cQry)->E1_TIPO
							EndIf
						Case ( AllTrim(aStru[nCntFor][1])=="E1_ATR" )
							If dDataBase > DataValida((cQry)->E1_VENCTO)
								(cAlias)->E1_ATR := dDataBase - (cQry)->E1_VENCTO
							Else
								(cAlias)->E1_ATR := dDataBase - DataValida((cQry)->E1_VENCTO,.T.)
							Endif
						Case ( AllTrim(aStru[nCntFor][1])=="FLAG" )
						
						Case ( AllTrim(aStru[nCntFor][1])=="E1_VLCRUZ" )
							If !((cQry)->(E1_TIPO)	$ MVABATIM)
								(cAlias)->E1_VLCRUZ := xMoeda((cQry)->(E1_VALOR),(cQry)->(E1_MOEDA),1,dDataBase,,If(cPaisLoc=="BRA",(cQry)->E1_TXMOEDA,0))
							Endif
						OtherWise							
							If !( (cQry)->(E1_TIPO)	$ MVABATIM )
								(cAlias)->(FieldPut(nCntFor,(cQry)->(FieldGet(FieldPos(aStru[nCntFor][1])))))
							Endif	
						EndCase
					Next nCntFor
					dbSelectArea(cAlias)
					If nTotAbat = 0
						If ( (cAlias)->E1_SALDO <= 0 )
							dbDelete()
						EndIf
					Endif						
					MsUnLock()
				EndIf
				dbSelectArea(cQry)
				dbSkip()				
			EndDo
			If ( lQuery )
				dbSelectArea(cQry)
				dbCloseArea()
			EndIf
			dbSelectArea(cAlias)
			IndRegua(cAlias,cArquivo,"DTOS(E1_VENCREA)")
		EndIf
		//������������������������������������������������������������������������Ŀ
		//�Totais da Consulta                                                      �
		//��������������������������������������������������������������������������
		aGet[1] := 0
		aGet[2] := 0
		aGet[3] := 0
		aGet[4] := 0
		aGet[5] := 0
		aGet[6] := 0
		aGet[7] := 0
		aTotRec := {{0,1,0,0}} // Totalizador de titulos a receber por por moeda
		dbSelectArea(cAlias)
		dbGotop()
		While !EOF()
		 	aGet[1]++
		 	If !lRelat
			 	SE1->(DbGoto((cAlias)->XX_RECNO))	// Posiciona no arquivo original para obter os valores
		 				 										// em outras moedas e em R$
				nAscan := Ascan(aTotRec,{|e| e[MOEDATIT] == E1_MOEDA})
			Endif	
			If E1_TIPO $ "RA #"+MV_CRNEG
				aGet[2] -= E1_VLCRUZ
				aGet[3] -= E1_SALDO
				aGet[4] -= E1_VALJUR
				aGet[7] -= E1_SALDO
				If !lRelat
					aGet[5] -= xMoeda(E1_SDACRES,E1_MOEDA,1,dDataBase,,ntaxaM)
					aGet[6] -= xMoeda(E1_SDDECRE,E1_MOEDA,1,dDataBase,,ntaxaM)
					If nAscan = 0
						Aadd(aTotRec,{1,E1_MOEDA,SE1->E1_SALDO*(-1),If(E1_MOEDA>1,xMoeda(SE1->E1_SALDO,E1_MOEDA,1,,,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0)),SE1->E1_SALDO)*(-1)})
					Else
						aTotRec[nAscan][QTDETITULOS]--
						aTotRec[nAscan][VALORTIT]		-= SE1->E1_SALDO
						aTotRec[nAscan][VALORREAIS]	-= If(E1_MOEDA>1,xMoeda(SE1->E1_SALDO,E1_MOEDA,1,,,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0)),SE1->E1_SALDO)
					Endif
				Endif	
			Else	
				aGet[2] += E1_VLCRUZ
				aGet[3] += E1_SALDO
				aGet[4] += E1_VALJUR
				aGet[7] += E1_SALDO
				If !lRelat
					aGet[5] += xMoeda(E1_SDACRES,E1_MOEDA,1,dDataBase,,ntaxaM)
					aGet[6] += xMoeda(E1_SDDECRE,E1_MOEDA,1,dDataBase,,ntaxaM)
					If nAscan = 0
						Aadd(aTotRec,{1,E1_MOEDA,SE1->E1_SALDO,If(E1_MOEDA>1,xMoeda(SE1->E1_SALDO,E1_MOEDA,1,,,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0)),SE1->E1_SALDO)})
					Else
						aTotRec[nAscan][QTDETITULOS]++
						aTotRec[nAscan][VALORTIT]		+= SE1->E1_SALDO
						aTotRec[nAscan][VALORREAIS]	+= If(E1_MOEDA>1,xMoeda(SE1->E1_SALDO,E1_MOEDA,1,,,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0)),SE1->E1_SALDO)
					Endif
				Endif
			Endif
			dbSkip()
		Enddo
		If !lRelat
			nTotalRec:=0
			aEval(aTotRec,{|e| nTotalRec+=e[VALORREAIS]})
			Aadd(aTotRec,{"","",STR0096,nTotalRec}) //"Total ====>>"
			// Formata as colunas
			aEval(aTotRec,{|e|	If(ValType(e[VALORTIT]) == "N"	, e[VALORTIT]		:= Transform(e[VALORTIT],Tm(e[VALORTIT],16,nCasas)),Nil),;
										If(ValType(e[VALORREAIS]) == "N"	, e[VALORREAIS]	:= Transform(e[VALORREAIS],Tm(e[VALORREAIS],16,nCasas)),Nil)})
		Endif										

		aGet[1] := TransForm(aGet[1],Tm(aGet[1],16,0))
		aGet[2] := TransForm(aGet[2],Tm(aGet[2],16,nCasas))
		aGet[3] := TransForm(aGet[3],Tm(aGet[3],16,nCasas))
		aGet[4] := TransForm(aGet[4],Tm(aGet[4],16,nCasas))
		aGet[5] := TransForm(aGet[5],Tm(aGet[5],16,nCasas))
		aGet[6] := TransForm(aGet[6],Tm(aGet[6],16,nCasas))
		aGet[7] := TransForm(aGet[7],Tm(aGet[7],16,nCasas))		
		//������������������������������������������������������������������������Ŀ
		//�Titulos Recebidos                                                       �
		//��������������������������������������������������������������������������
	Case ( nBrowse == 2 )
		dbSelectArea("SX3")
		dbSetOrder(2)
		dbSeek("E1_FILIAL")
		aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
		aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		dbSeek("E1_CLIENTE")
		aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
		aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		dbSeek("E1_LOJA")
		aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
		aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		dbSeek("E1_NOMCLI")
		aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
		aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		dbSeek("E1_PREFIXO")
		aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
		aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		dbSeek("E1_NUM")
		aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
		aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		dbSeek("E1_PARCELA")
		aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
		aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		dbSeek("E1_TIPO")
		aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
		aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		
		IF !lRelat
			dbSeek("E1_MOEDA")
			aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
			aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
			aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})

			dbSeek("E1_VALOR")
			aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
			aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
			aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		Endif	
		
		dbSeek("E1_VLCRUZ")
		aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
		aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		
		For nCntFor := 1 To 4
			dbSeek(	If(nCntFor==1,	"E5_VLJUROS",;
						If(nCntFor==2,	"E5_VLMULTA",;
						If(nCntFor==3,	"E5_VLCORRE",;
											"E5_VLDESCO"))))
			aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
			aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
			aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		Next	
		
		dbSeek("E5_VALOR")
		aadd(aHeader,{STR0047,"E1_PAGO",SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,"V" } ) //"Pago"
		aadd(aStru ,{"E1_PAGO",SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
				
		IF !lRelat
			dbSeek("E1_VALOR")
			aadd(aHeader,{ STR0093,"E1_VLMOED2",SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } ) //"Vlr pago  moeda tit."
			aadd(aStru ,{"E1_VLMOED2",SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
			
			dbSeek("E5_VLMOED2")
			aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
			aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})

			If cPaisLoc == "BRA"
				dbSeek("E5_TXMOEDA")
				aadd(aHeader,{AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
				aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
				aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
			Endif
		Endif	

		dbSeek("E1_EMISSAO")
		aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
		aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})

		dbSeek("E1_VENCTO")
		aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})		

		dbSeek("E1_VENCREA")
		aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
		aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		dbSeek("E5_DATA")
		aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
		aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		dbSeek("E5_DTDISPO")
		aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
		aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})

		dbSeek("E1_NATUREZ")
		aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
		aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})

		If !lRelat
			dbSeek("E1_NUMLIQ")
			aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
			aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
			aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		Endif

		dbSeek("E5_BANCO")
		aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
		aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})

		dbSeek("E5_AGENCIA")
		aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
		aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})

		dbSeek("E5_CONTA")
		aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
		aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})

		dbSeek("E5_HISTOR")
		aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
		aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})

		dbSeek("E5_MOTBX")
		aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
		aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})

		If !lRelat
			dbSeek("E5_CNABOC")
			aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
			aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
			aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		Endif

		dbSeek("E5_TIPODOC")
		aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})		


		aadd(aHeader,{STR0035,"E1_ATR","99999",5,0,"","","N","","V" } ) //"Atraso"
		aadd(aStru ,{"E1_ATR","N",5,0})

		dbSeek("E1_VALJUR")
		aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
		aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})

		aadd(aStru,{"XX_RECNO","N",12,0})
		
		If cPaisLoc == "BRA"
			aadd(aQuery,{"E1_TXMOEDA","N",17,4})
		Endif	

		SX3->(DbSetOrder(1))

		If ( Select(cAlias) ==	0 )
			cArquivo := CriaTrab(,.F.)			
			aadd(aAlias,{ cAlias , cArquivo })
			aadd(aStru,{"FLAG","L",01,0})
			dbCreate(cArquivo,aStru)
			dbUseArea(.T.,,cArquivo,cAlias,.F.,.F.)
			IndRegua(cAlias,cArquivo,"E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO")

			#IFDEF TOP
				If ( TcSrvType()!="AS/400" )
					cQuery := ""
					aEval(aQuery,{|x| cQuery += ","+AllTrim(x[1])})
					cQuery := "SELECT "+SubStr(cQuery,2)+",SE5.R_E_C_N_O_ SE5RECNO , SE5.E5_DOCUMEN E5_DOCUMEN "
					cQuery += "FROM "+RetSqlName("SE1")+" SE1,"
					cQuery +=         RetSqlName("SE5")+" SE5 "
					cQuery += "WHERE " //SE1.E1_FILIAL='"+xFilial("SE1")+"' AND "
					//cQuery +=       "SE1.E1_CLIENTE='"+SA1->A1_COD+"' AND "
					//cQuery +=       "SE1.E1_LOJA='"+SA1->A1_LOJA+"' AND "
					cQuery +=       "SE1.E1_CLIENTE+E1_LOJA In ("+U_Titular(SA1->A1_COD, SA1->A1_LOJA)+") AND "
					cQuery +=       "SE1.E1_EMISSAO>='"+Dtos(aParam[1])+"' AND "
					cQuery +=       "SE1.E1_EMISSAO<='"+Dtos(aParam[2])+"' AND "
					cQuery +=       "SE1.E1_VENCREA>='"+Dtos(aParam[3])+"' AND "
					cQuery +=       "SE1.E1_VENCREA<='"+Dtos(aParam[4])+"' AND "
					If ( aParam[5] == 2 )
						cQuery +=   "SE1.E1_TIPO<>'PR ' AND "
					EndIf					
					If aParam[8] == 2
						cQuery += " SE1.E1_FATURA IN('"+Space(Len(SE1->E1_FATURA))+"','NOTFAT') AND "
					Endif
					cQuery +=       "SE1.E1_PREFIXO>='"+aParam[6]+"' AND "
					cQuery +=       "SE1.E1_PREFIXO<='"+aParam[7]+"' AND "
					If cPaisLoc != "BRA"
						cQuery += "SE1.E1_TIPO NOT IN" + FormatIn(cCheques,"|") + " AND "
					Endif	
					If aParam[09] == 2
						cQuery += "( SE1.E1_NUMLIQ ='"+Space(Len(SE1->E1_NUMLIQ))+"' OR "
						cQuery += "( SE1.E1_NUMLIQ <>'"+Space(Len(SE1->E1_NUMLIQ))+"' AND "
						cQuery += " SE1.E1_TIPOLIQ ='"+Space(Len(SE1->E1_TIPOLIQ))+"')) AND "
					Endif
					cQuery +=		"SE1.E1_TIPO NOT LIKE '__-' AND "
					cQuery +=		"SE1.E1_TIPO NOT IN ('RA ','PA ','"+MV_CRNEG+"','"+MV_CPNEG+"') AND "
					cQuery +=		"SE1.D_E_L_E_T_=' ' AND "
					cQuery +=       "SE5.E5_FILIAL=SE1.E1_FILIAL AND "  //+xFilial("SE5")+"' AND "
					cQuery +=		"SE5.E5_NATUREZ=SE1.E1_NATUREZ AND "
					cQuery +=		"SE5.E5_PREFIXO=SE1.E1_PREFIXO AND "
					cQuery +=		"SE5.E5_NUMERO=SE1.E1_NUM AND "
					cQuery +=		"SE5.E5_PARCELA=SE1.E1_PARCELA AND "
					cQuery +=		"SE5.E5_TIPO=SE1.E1_TIPO AND "
					cQuery +=		"SE5.E5_CLIFOR=SE1.E1_CLIENTE AND "
					cQuery +=		"SE5.E5_LOJA=SE1.E1_LOJA AND "
					cQuery +=		"SE5.E5_RECPAG='R' AND "
					cQuery +=		"SE5.E5_SITUACA<>'C' AND "
					cQuery +=		"SE5.D_E_L_E_T_=' ' AND NOT EXISTS ("
					cQuery += "SELECT A.E5_NUMERO "
					cQuery += "FROM "+RetSqlName("SE5")+" A "
					cQuery += "WHERE A.E5_FILIAL='"+xFilial("SE5")+"' AND "
					cQuery +=		"A.E5_NATUREZ=SE5.E5_NATUREZ AND "
					cQuery +=		"A.E5_PREFIXO=SE5.E5_PREFIXO AND "
					cQuery +=		"A.E5_NUMERO=SE5.E5_NUMERO AND "
					cQuery +=		"A.E5_PARCELA=SE5.E5_PARCELA AND "
					cQuery +=		"A.E5_TIPO=SE5.E5_TIPO AND "
					cQuery +=		"A.E5_CLIFOR=SE5.E5_CLIFOR AND "
					cQuery +=		"A.E5_LOJA=SE5.E5_LOJA AND "
					cQuery +=		"A.E5_SEQ=SE5.E5_SEQ AND "
					cQuery +=		"A.E5_TIPODOC='ES' AND "
					cQuery +=		"A.E5_RECPAG<>'R' AND "
					cQuery +=		"A.D_E_L_E_T_=' ')"

					cQuery := ChangeQuery(cQuery)
					cQry   := cArquivo+"A"

					dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cQry,.T.,.T.)

					aEval(aQuery,{|x| If(x[2]!="C",TcSetField(cQry,x[1],x[2],x[3],x[4]),Nil)})

					dbSelectArea(cQry)
					bWhile := {|| !Eof() }
					bFiltro:= {|| (cQry)->E5_TIPODOC $ "VL/BA/V2/CP/LJ/R$" }
					cAnterior := ""
					While ( Eval(bWhile) )				
						If ( Eval(bFiltro) )
							dbSelectArea(cAlias)
							dbSetOrder(1)
							RecLock(cAlias,.T.)
							For nCntFor := 1 To Len(aStru)
								Do Case
									Case ( AllTrim(aStru[nCntFor][1])=="E1_PAGO" )
										If ( (cQry)->E5_TIPODOC $ "VL/BA/V2/CP/LJ/R$" )
											(cAlias)->E1_PAGO += (cQry)->E5_VALOR
										EndIf
									Case ( AllTrim(aStru[nCntFor][1])=="E1_VLMOED2" ) .And. !lRelat
										If ( (cQry)->E5_TIPODOC $ "VL/BA/V2/CP/LJ/R$" ) .And. (cQry)->E1_MOEDA > 1
											(cAlias)->E1_VLMOED2 := If((cQry)->E1_MOEDA > 1, (cQry)->E5_VLMOED2, (cQry)->E5_VALOR)
										EndIf	
									Case ( AllTrim(aStru[nCntFor][1])=="E1_SALDO2" )
										If ( (cQry)->(E1_TIPO)	$ MVABATIM )
											(cAlias)->E1_SALDO2 -= nTotAbat
										Else
											(cAlias)->E1_SALDO2 += (cQry)->(E1_SALDO)
											(cAlias)->E1_SALDO2 += (cAlias)->E1_SDACRES - (cAlias)->E1_SDDECRE
										EndIf
										If ( !lQuery )
											(cAlias)->E1_SALDO2 -= nTotAbat
										EndIf	
									Case ( AllTrim(aStru[nCntFor][1])=="E1_VLCRUZ" )
										If ( (cQry)->E5_TIPODOC $ "VL/BA/V2/CP/LJ/R$" )
											If cAnterior != (cQry)->(E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO)
												(cAlias)->E1_VLCRUZ := (cQry)->E1_VLCRUZ
												cAnterior := (cQry)->(E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO)
											Endif
										EndIf										
									Case ( AllTrim(aStru[nCntFor][1])=="E1_ATR" )
										If (cQry)->E5_DATA > DataValida((cQry)->E1_VENCTO,.T.)
											(cAlias)->E1_ATR := (cQry)->E5_DATA - (cQry)->E1_VENCTO
										Else
											(cAlias)->E1_ATR := (cQry)->E5_DATA - DataValida((cQry)->E1_VENCTO,.T.)
										Endif
									Case cPaisLoc=="BRA" .And. ( AllTrim(aStru[nCntFor][1])=="E5_TXMOEDA" )  .And. !lRelat
										If (cQry)->E1_MOEDA == 1
											(cAlias)->E5_TXMOEDA := 1
		                  				Else
											If (cQry)->E5_TXMOEDA == 0 
												(cAlias)->E5_TXMOEDA := ((cQry)->E5_VALOR /(cQry)->E5_VLMOED2)
											Else
												(cAlias)->E5_TXMOEDA := (cQry)->E5_TXMOEDA
											Endif
										Endif
									Case ( !lRelat .And. AllTrim(aStru[nCntFor][1])=="E1_NUMLIQ" )
										If (cQry)->E5_MOTBX == "LIQ"
											If Empty( (cQry)->E1_NUMLIQ )
												(cAlias)->E1_NUMLIQ := SUBSTR((cQry)->E5_DOCUMEN,1,TamSx3("E1_NUMLIQ")[1])
											Else
												(cAlias)->(FieldPut(nCntFor,(cQry)->(FieldGet(FieldPos(aStru[nCntFor][1])))))			
											Endif		
										Endif
									Case ( AllTrim(aStru[nCntFor][1])=="XX_RECNO" )
										(cAlias)->XX_RECNO := (cQry)->SE5RECNO

									Case ( AllTrim(aStru[nCntFor][1])=="FLAG" )
			
									OtherWise
										(cAlias)->(FieldPut(nCntFor,(cQry)->(FieldGet(FieldPos(aStru[nCntFor][1])))))
								EndCase
							Next nCntFor
							(cAlias)->(MsUnLock())
						EndIf
						dbSelectArea(cQry)
						dbSkip()				
					EndDo
					dbSelectArea(cQry)
					dbCloseArea()
				Else
			#ENDIF
				dbSelectArea("SE1")
				dbSetOrder(2)
				dbSeek(xFilial("SE1")+SA1->A1_COD+SA1->A1_LOJA)
				bWhile := {|| !Eof() .And. xFilial("SE1") == SE1->E1_FILIAL .And.;
									SA1->A1_COD    == SE1->E1_CLIENTE .And.;
									SA1->A1_LOJA   == SE1->E1_LOJA }
				bFiltro:= {|| 	SubStr(SE1->E1_TIPO,3,1)!="-" .And.;
									SE1->E1_EMISSAO >= aParam[1] .And.;
									SE1->E1_EMISSAO <= aParam[2] .And.;
									SE1->E1_VENCREA >= aParam[3] .And.;
									SE1->E1_VENCREA <= aParam[4] .And.;
									If(aParam[5]==2,SE1->E1_TIPO!="PR ",.T.) .And.;
									SE1->E1_PREFIXO >= aParam[6] .And.;
									SE1->E1_PREFIXO <= aParam[7] .And.;
									IIf(cPaisLoc == "BRA",.T.,!(SE1->E1_TIPO$cCheques)) .And.;
									If(!Empty(SE1->E1_FATURA) .And. Substr(SE1->E1_FATURA,1,6) != "NOTFAT",aParam[8]==1, .T.).AND.;
									IIF(aParam[09] == 2, Empty(SE1->E1_NUMLIQ) .OR. (!Empty(SE1->E1_NUMLIQ) .And. Empty(SE1->E1_TIPOLIQ)),.T.)}
									
				While ( Eval(bWhile) )
					If ( Eval(bFiltro) )
						dbSelectArea("SE5")
						dbSetOrder(4)
						dbSeek(xFilial("SE5")+SE1->E1_NATUREZ+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO)

						While ( !Eof() .And. xFilial("SE5") == SE5->E5_FILIAL .And.;
								SE1->E1_NATUREZ == SE5->E5_NATUREZ .And.;
								SE1->E1_PREFIXO == SE5->E5_PREFIXO .And.;
								SE1->E1_NUM == SE5->E5_NUMERO      .And.;
								SE1->E1_PARCELA == SE5->E5_PARCELA .And.;
								SE1->E1_TIPO == SE5->E5_TIPO )

							If ((!SE5->E5_TIPO $ "RA /PA /"+MV_CRNEG+"/"+MV_CPNEG) .And. !TemBxCanc() .and. ;
										SE5->E5_SITUACA <> "C" .And. SE5->E5_TIPODOC $ "VL/BA/V2/CP/LJ/R$")
								RecLock(cAlias,.T.)
								For nCntFor := 1 To Len(aStru)
									Do Case
									Case ( AllTrim(aStru[nCntFor][1])=="E1_PAGO" )
										If ( SE5->E5_TIPODOC $ "VL/BA/V2/CP/LJ/R$" )
											(cAlias)->E1_PAGO += SE5->E5_VALOR
										EndIf
									Case ( AllTrim(aStru[nCntFor][1])=="E1_VLMOED2" ) .And. !lRelat
										If ( SE5->E5_TIPODOC $ "VL/BA/V2/CP/LJ/R$" ) .And. SE1->E1_MOEDA > 1
											(cAlias)->E1_VLMOED2 := If(SE1->E1_MOEDA > 1, SE5->E5_VLMOED2, SE5->E5_VALOR)
										EndIf		
									Case ( AllTrim(aStru[nCntFor][1])=="E1_VLCRUZ" )
										If ( SE5->E5_TIPODOC $ "VL/BA/V2/CP/LJ/R$" )
											If cAnterior != SE1->(E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO)
												(cAlias)->E1_VLCRUZ := SE1->E1_VLCRUZ
												cAnterior := SE1->(E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO)
											Endif
										Endif	
									Case ( AllTrim(aStru[nCntFor][1])=="E1_ATR" )
										If SE5->E5_DATA > DataValida(SE1->E1_VENCTO,.T.)
											(cAlias)->E1_ATR := SE5->E5_DATA - SE1->E1_VENCTO
										Else
											(cAlias)->E1_ATR := SE5->E5_DATA - DataValida(SE1->E1_VENCTO,.T.)
										Endif
									Case cPaisLoc=="BRA" .And. ( AllTrim(aStru[nCntFor][1])=="E5_TXMOEDA" ) .And. !lRelat
		                     			If SE1->E1_MOEDA == 1
        		             				(cAlias)->E5_TXMOEDA := 1
            							Else
											If SE5->E5_TXMOEDA == 0 
												(cAlias)->E5_TXMOEDA := (SE5->E5_VALOR /SE5->E5_VLMOED2)
											Else
												(cAlias)->E5_TXMOEDA := SE5->E5_TXMOEDA
											Endif
										Endif
									Case ( AllTrim(aStru[nCntFor][1])=="E1_NUMLIQ" )
										If SE5->E5_MOTBX == "LIQ"
											If Empty(SE1->E1_NUMLIQ)
												(cAlias)->E1_NUMLIQ := SUBSTR(SE5->E5_DOCUMEN,1,TamSx3("E1_NUMLIQ")[1])
											Else
												(cAlias)->(FieldPut(nCntFor,SE1->(FieldGet(FieldPos(aStru[nCntFor][1])))))
											Endif
										Endif
									Case ( AllTrim(aStru[nCntFor][1])=="XX_RECNO" )
										(cAlias)->XX_RECNO := SE5->(RecNo())
									Case ( "E5_"$AllTrim(aStru[nCntFor][1]) )
										(cAlias)->(FieldPut(nCntFor,SE5->(FieldGet(FieldPos(aStru[nCntFor][1])))))
									Case ( AllTrim(aStru[nCntFor][1])=="FLAG" )
									OtherWise
										(cAlias)->(FieldPut(nCntFor,SE1->(FieldGet(FieldPos(aStru[nCntFor][1])))))
									EndCase
								Next nCntFor
								(cAlias)->(MsUnLock())
							EndIf
							dbSelectArea("SE5")
							dbSkip()
						EndDo										
					EndIf
					dbSelectArea("SE1")
					dbSkip()					
				EndDo
				#IFDEF TOP
				EndIf					
				#ENDIF
			dbSelectArea(cAlias)
			IndRegua(cAlias,cArquivo,"DTOS(E1_VENCREA)")
		EndIf
		//������������������������������������������������������������������������Ŀ
		//�Totais da Consulta                                                      �
		//��������������������������������������������������������������������������
		aGet[1] := 0
		aGet[2] := 0
		aGet[3] := 0
		aTotPag := {{0,1,0,0}} // Totalizador de titulos recebidos por por moeda
		dbSelectArea(cAlias)
		dbGotop()
		U_cFC010TotRc(aGet,cAlias,aTotPag)  // Totais de Baixas
		If !lRelat
			nTotalRec:=0
			aEval(aTotPag,{|e| nTotalRec+=e[VALORREAIS]})
			Aadd(aTotPag,{"","",STR0094,nTotalRec}) //"Total ====>>"
			// Formata as colunas
			aEval(aTotPag,{|e|	If(ValType(e[VALORTIT]) == "N"	, e[VALORTIT]		:= Transform(e[VALORTIT],Tm(e[VALORTIT],16,nCasas)),Nil),;
										If(ValType(e[VALORREAIS]) == "N"	, e[VALORREAIS]	:= Transform(e[VALORREAIS],Tm(e[VALORREAIS],16,nCasas)),Nil)})
		Endif
		aGet[1] := TransForm(aGet[1],Tm(aGet[1],16,0))
		aGet[2] := TransForm(aGet[2],Tm(aGet[2],16,nCasas))
		aGet[3] := TransForm(aGet[3],Tm(aGet[3],16,nCasas))
		//������������������������������������������������������������������������Ŀ
		//�Pedidos                                                                 �
		//��������������������������������������������������������������������������
	Case ( nBrowse == 3 )
		dbSelectArea("SX3")
		dbSetOrder(2)
		dbSeek("C5_FILIAL")
		aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
		aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		dbSeek("C5_NUM")
		aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
		aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		dbSeek("C5_EMISSAO")
		aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
		aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		dbSeek("C6_VALOR")
		aadd(aHeader,{STR0040,"XX_SLDTOT",SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } ) //"Tot.Pedido"
		aadd(aStru ,{"XX_SLDTOT",SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		aadd(aHeader,{STR0041,"XX_SLDLIB",SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } ) //"Sld.Liberado"
		aadd(aStru ,{"XX_SLDLIB",SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		aadd(aHeader,{STR0042,"XX_SLDPED",SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } ) //"Sld.Pedido"
		aadd(aStru ,{"XX_SLDPED",SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		aadd(aStru,{"XX_RECNO","N",12,0})

		SX3->(dbSetOrder(1))

		If ( Select(cAlias) ==	0 )
			cArquivo := CriaTrab(,.F.)			
			aadd(aAlias,{ cAlias , cArquivo })
			aadd(aStru,{"FLAG","L",01,0})
			dbCreate(cArquivo,aStru)
			dbUseArea(.T.,,cArquivo,cAlias,.F.,.F.)
			IndRegua(cAlias,cArquivo,"C5_NUM")

			#IFDEF TOP
				If ( TcSrvType()!="AS/400" )
					lQuery := .T.
					cQuery := "SELECT SC5.C5_FILIAL FILIAL, SC5.C5_NUM PEDIDO,"
					cQuery += 		  "SC5.C5_EMISSAO EMISSAO,"
					cQuery += 		  "SC5.C5_MOEDA MOEDA,"
					cQuery += 		  "SC5.R_E_C_N_O_ SC5RECNO,"
					cQuery += 		  "(C6_QTDVEN-C6_QTDEMP-C6_QTDENT) QTDVEN,"
					cQuery +=		  "C6_PRCVEN PRCVEN,"
					cQuery +=         "1 TIPO,"
					cQuery +=         "C5_EMISSAO DATALIB," //NAO RETIRAR - POSTGRES
					cQuery +=         "C6_BLQ BLCRED "		//NAO RETIRAR - POSTGRES
					cQuery += "FROM "+RetSqlName("SC5")+" SC5,"
					cQuery +=         RetSqlName("SC6")+" SC6,"
					cQuery +=         RetSqlName("SF4")+" SF4 "
					cQuery += "WHERE " //SC5.C5_FILIAL='"+xFilial("SC5")+"' AND "
					//cQuery += 		"(SC5.C5_CLIENT='"+SA1->A1_COD+"' AND "
					//cQuery +=		"SC5.C5_LOJAENT='"+SA1->A1_LOJA+"' AND SC5.C5_CLIENT <> '' AND SC5.C5_LOJAENT <> '') AND"
					cQuery += 		"SC5.C5_CLIENTE||C5_LOJACLI In ("+U_Titular(SA1->A1_COD, SA1->A1_LOJA)+") AND "
					cQuery +=		"SC5.C5_TIPO NOT IN('D','B') AND "
					cQuery +=		"SC5.C5_EMISSAO >='"+Dtos(aParam[1])+"' AND "
					cQuery +=		"SC5.C5_EMISSAO <='"+Dtos(aParam[2])+"' AND "	
					cQuery +=		"SC5.D_E_L_E_T_=' ' AND "
					cQuery +=		"SC6.C6_FILIAL=SC5.C5_FILIAL AND "  //+xFilial("SC6")+"' AND "
					cQuery +=		"SC6.C6_NUM=SC5.C5_NUM AND "
					cQuery +=		"SC6.C6_BLQ NOT IN('R ') AND "
					If aParam[10] == 2 // nao considera pedidos com bloqueio
						cQuery +=		"SC6.C6_BLQ NOT IN('S ') AND "
					Endif
					cQuery +=		"(SC6.C6_QTDVEN-SC6.C6_QTDEMP-SC6.C6_QTDENT)>0 AND "
					cQuery +=		"SC6.D_E_L_E_T_=' ' AND "
					cQuery +=		"SF4.F4_FILIAL='"+xFilial("SF4")+"' AND "
					cQuery +=		"SF4.F4_CODIGO=SC6.C6_TES AND "
					cQuery +=		"SF4.F4_DUPLIC='S' AND "
					cQuery +=		"SF4.D_E_L_E_T_=' ' "
					cQuery += "UNION ALL "
					cQuery += "SELECT SC5.C5_FILIAL FILIAL, C5_NUM PEDIDO,"
					cQuery += 		  "C5_EMISSAO EMISSAO,"
					cQuery += 		  "C5_MOEDA MOEDA,"
					cQuery += 		  "SC5.R_E_C_N_O_ SC5RECNO,"					
					cQuery += 		  "C9_QTDLIB QTDVEN,"
					cQuery +=		  "C9_PRCVEN PRCVEN, "
					cQuery +=         "2 TIPO,"										
					cQuery +=		  "C9_DATALIB DATALIB, "
					cQuery +=		  "C9_BLCRED BLCRED "
					cQuery += "FROM "+RetSqlName("SC5")+" SC5,"+RetSqlName("SC6")+" SC6,"
					cQuery +=         RetSqlName("SF4")+" SF4,"+RetSqlName("SC9")+" SC9 "
					cQuery += "WHERE " //SC5.C5_FILIAL='"+xFilial("SC5")+"' AND "
					cQuery += 		"SC5.C5_CLIENTE||C5_LOJACLI In ("+U_Titular(SA1->A1_COD, SA1->A1_LOJA)+") AND "
					cQuery +=		"SC5.C5_TIPO NOT IN('D','B') AND "
					cQuery +=		"SC5.C5_EMISSAO >='"+Dtos(aParam[1])+"' AND "
					cQuery +=		"SC5.C5_EMISSAO <='"+Dtos(aParam[2])+"' AND "						
					cQuery +=		"SC5.D_E_L_E_T_=' ' AND "
					cQuery +=		"SC6.C6_FILIAL=SC5.C5_FILIAL AND "  //+xFilial("SC6")+"' AND "
					cQuery +=		"SC6.C6_NUM=SC5.C5_NUM AND "
					cQuery +=		"SC6.D_E_L_E_T_=' ' AND "
					cQuery +=		"SC6.C6_BLQ NOT IN('R ') AND "
					If aParam[10] == 2 // nao considera pedidos com bloqueio
						cQuery +=		"SC6.C6_BLQ NOT IN('S ') AND "
					Endif
					cQuery +=		"SF4.F4_FILIAL='"+xFilial("SF4")+"' AND "
					cQuery +=		"SF4.F4_CODIGO=SC6.C6_TES AND "
					cQuery +=		"SF4.F4_DUPLIC='S' AND "
					cQuery +=		"SF4.D_E_L_E_T_=' ' AND "
					cQuery += 		"SC9.C9_FILIAL='"+xFilial("SC9")+"' AND "
					cQuery +=		"SC9.C9_PEDIDO=SC5.C5_NUM AND "
					cQuery +=		"SC9.C9_ITEM=SC6.C6_ITEM AND "
					cQuery +=		"SC9.C9_PRODUTO=SC6.C6_PRODUTO AND "		
					cQuery +=		"SC9.C9_NFISCAL='"+Space(Len(SC9->C9_NFISCAL))+"' AND "
					cQuery +=		"SC9.D_E_L_E_T_=' '"

					cQuery := ChangeQuery(cQuery)
					cQry   := cArquivo+"A"
					// Alert(cQuery)

					dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cQry,.T.,.T.)

					TcSetField(cQry,"EMISSAO","D")
					TcSetField(cQry,"DATALIB","D")
					TcSetField(cQry,"TIPO","N",1)
					TcSetField(cQry,"SC5RECNO","N",12,0) 
					TcSetField(cQry,"QTDVEN","N",TamSx3("C6_QTDVEN")[1],TamSx3("C6_QTDVEN")[2])
					TcSetField(cQry,"PRCVEN","N",TamSx3("C6_PRCVEN")[1],TamSx3("C9_PRCVEN")[2])
										
					dbSelectArea(cQry)
					bWhile := {|| !Eof() }
					bFiltro:= {|| .T. }
					While ( Eval(bWhile) )				
						If ( Eval(bFiltro) )
							dbSelectArea(cAlias)
							dbSetOrder(1)
							cChave := (cQry)->(PEDIDO)
							If ( !dbSeek(cChave) )
								RecLock(cAlias,.T.)
							Else
								RecLock(cAlias,.F.)
							EndIf
							(cAlias)->C5_FILIAL  := (cQry)->FILIAL
							If ( (cQry)->TIPO == 1 )       
								(cAlias)->C5_NUM     := (cQry)->PEDIDO
								(cAlias)->C5_EMISSAO := (cQry)->EMISSAO
								(cAlias)->XX_SLDTOT  += xMoeda((cQry)->QTDVEN*(cQry)->PRCVEN,(cQry)->MOEDA,1,(cQry)->EMISSAO)
								(cAlias)->XX_SLDLIB  := 0
								(cAlias)->XX_SLDPED  := (cAlias)->XX_SLDTOT
							Else
								(cAlias)->C5_NUM     := (cQry)->PEDIDO
								(cAlias)->C5_EMISSAO := (cQry)->EMISSAO						
								If ( Empty((cQry)->BLCRED) )
									(cAlias)->XX_SLDLIB  += xMoeda((cQry)->QTDVEN*(cQry)->PRCVEN,(cQry)->MOEDA,1,(cQry)->DATALIB)
									(cAlias)->XX_SLDTOT  += xMoeda((cQry)->QTDVEN*(cQry)->PRCVEN,(cQry)->MOEDA,1,(cQry)->DATALIB)
								Else
									(cAlias)->XX_SLDTOT  += xMoeda((cQry)->QTDVEN*(cQry)->PRCVEN,(cQry)->MOEDA,1,(cQry)->DATALIB)
									(cAlias)->XX_SLDPED  += xMoeda((cQry)->QTDVEN*(cQry)->PRCVEN,(cQry)->MOEDA,1,(cQry)->DATALIB)
								EndIf
							EndIf
							(cAlias)->XX_RECNO := (cQry)->SC5RECNO
							(cAlias)->(MsUnLock())
						EndIf
						dbSelectArea(cQry)
						dbSkip()				
					EndDo
					dbSelectArea(cQry)
					dbCloseArea()			
				Else
			#ENDIF
				dbSelectArea("SC5")
				dbSetOrder(3)
				dbSeek(xFilial("SC5")+SA1->A1_COD)
				While ( !Eof() .And. SC5->C5_FILIAL==xFilial("SC5") .And.;
						SC5->C5_CLIENTE == SA1->A1_COD )
					nSalPed := 0
					nSalPedb:= 0
					nSalPedL:= 0
					nQtdPed := 0											
					If ( SC5->C5_LOJACLI == SA1->A1_LOJA .And. !(SC5->C5_TIPO $ "DB") .And. SC5->C5_EMISSAO >= aParam[1] .And. C5_EMISSAO <= aParam[2] )
						dbSelectArea("SC6")
						dbSetOrder(1)
						dbSeek(xFilial("SC6")+SC5->C5_NUM)
						While ( !Eof() .And. SC6->C6_FILIAL == xFilial('SC5') .And.;
								SC6->C6_NUM == SC5->C5_NUM )
							If ( !AllTrim(SC6->C6_BLQ) $ "R"+If(aParam[10]==2,"#S",""))
								dbSelectArea("SF4")
								dbSetOrder(1)
								dbSeek(cFilial+SC6->C6_TES)
								//�����������������������������������������������������������Ŀ
								//� Buscar Qtde no arquivo SC9 (itens liberados) p/ A1_SALPEDL�
								//�������������������������������������������������������������
								dbSelectArea("SC9")
								dbSetOrder(2)
								dbSeek(xFilial("SC9")+SC6->C6_CLI+SC6->C6_LOJA+SC6->C6_NUM+SC6->C6_ITEM)
								If ( SF4->F4_DUPLIC == "S" )
									While ( !Eof() .And. xFilial("SC9") == SC9->C9_FILIAL .And.;
											SC6->C6_CLI == SC9->C9_CLIENTE .And.;
											SC6->C6_LOJA == SC9->C9_LOJA .And.;
											SC6->C6_NUM == SC9->C9_PEDIDO .And.;
											SC6->C6_ITEM == SC9->C9_ITEM )
										If ( Empty(C9_NFISCAL) .And. SC6->C6_PRODUTO==SC9->C9_PRODUTO )
											If ( Empty(SC9->C9_BLCRED) )
												nSalpedl += xMoeda( SC9->C9_QTDLIB * SC9->C9_PRCVEN , SC5->C5_MOEDA , 1 , SC9->C9_DATALIB )
											Else
												nSalpedb += xMoeda( SC9->C9_QTDLIB * SC9->C9_PRCVEN , SC5->C5_MOEDA , 1 , SC9->C9_DATALIB )
											EndIf
										EndIf
										dbSelectArea("SC9")
										dbSkip()
									EndDo
								Endif
								If ( SF4->F4_DUPLIC == "S" )
									nQtdPed := SC6->C6_QTDVEN - SC6->C6_QTDEMP - SC6->C6_QTDENT
									nQtdPed := IIf( nQtdPed < 0 , 0 , nQtdPed )
									nSalped += xMoeda( nQtdPed * SC6->C6_PRCVEN , SC5->C5_MOEDA , 1 , SC5->C5_EMISSAO )
								EndIf
							EndIf
							dbSelectArea("SC6")
							dbSkip()
						EndDo
					EndIf
					If ( nSalped+nSalpedl+nSalpedb > 0 )
						RecLock(cAlias,.T.)
						(cAlias)->C5_NUM     := SC5->C5_NUM
						(cAlias)->C5_EMISSAO := SC5->C5_EMISSAO
						(cAlias)->XX_SLDTOT  := nSalPed+nSalPedL+nSalPedb
						(cAlias)->XX_SLDLIB  := nSalPedL
						(cAlias)->XX_SLDPED  := nSalPed+nSalPedb
						(cAlias)->XX_RECNO    := SC5->(RecNo())
						MsUnlock()
					EndIf
					dbSelectArea("SC5")
					dbSkip()
				EndDo
				#IFDEF TOP
				EndIf
				#ENDIF
		EndIf
		dbSelectArea(cAlias)
		dbGotop()
		aGet[1] := 0
		aGet[2] := 0
		aGet[3] := 0
		aGet[4] := 0
		dbEval({|| 	aGet[1]++,;
			aGet[2]+=XX_SLDTOT,;
			aGet[3]+=XX_SLDLIB,;
			aGet[4]+=XX_SLDPED})

		aGet[1] := TransForm(aGet[1],Tm(aGet[1],16,0))
		aGet[2] := TransForm(aGet[2],Tm(aGet[2],16,nCasas))
		aGet[3] := TransForm(aGet[3],Tm(aGet[3],16,nCasas))
		aGet[4] := TransForm(aGet[4],Tm(aGet[3],16,nCasas))	
		//������������������������������������������������������������������������Ŀ
		//�Notas Fiscais                                                           �
		//��������������������������������������������������������������������������
	Case ( nBrowse == 4 )
		aCpos:={"F2_FILIAL","F2_CLIENTE","F2_LOJA","F2_SERIE","F2_DOC","F2_EMISSAO","F2_DUPL","F2_VALFAT","F2_FRETE",;
			    "F2_HORA","F2_TRANSP","A4_NREDUZ"}
		If cPaisLoc != "BRA"
			AAdd(aCpos,"F2_MOEDA") 
			AAdd(aCpos,"F2_TXMOEDA")
		EndIf
					
		dbSelectArea("SX3")
		dbSetOrder(2)
		For nI := 1 To Len(aCpos)
			dbSeek(aCpos[nI])
			aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
			aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		Next nI

		aadd(aStru,{"XX_RECNO","N",12,0})

		SX3->(dbSetOrder(1))

		If ( Select(cAlias) ==	0 )
			cArquivo := CriaTrab(,.F.)			
			aadd(aAlias,{ cAlias , cArquivo })
			aadd(aStru,{"FLAG","L",01,0})
			dbCreate(cArquivo,aStru)
			dbUseArea(.T.,,cArquivo,cAlias,.F.,.F.)
			IndRegua(cAlias,cArquivo,"DTOS(F2_EMISSAO)+F2_SERIE+F2_DOC")

			#IFDEF TOP
				cDbMs	 := UPPER(TcGetDb())
				If ( TcSrvType()!="AS/400" .and. cDbMs!="POSTGRES")
					lQuery := .T.

					cQuery := "SELECT SF2.F2_FILIAL F2_FILIAL, SF2.F2_DOC F2_DOC,"
					cQuery += 		"  SF2.F2_SERIE F2_SERIE,"
					cQuery += 		"  SF2.F2_CLIENTE F2_CLIENTE,"
					cQuery += 		"  SF2.F2_LOJA F2_LOJA,"
					cQuery += 		"  SF2.F2_EMISSAO F2_EMISSAO,"
					cQuery +=		"  SF2.F2_DUPL F2_DUPL,"
					cQuery += 		"  SF2.F2_VALFAT F2_VALFAT, "
					cQuery += 		"  SF2.F2_FRETE F2_FRETE, "
					cQuery += 		"  SF2.F2_HORA F2_HORA, "
					cQuery += 		"  SF2.F2_TRANSP F2_TRANSP, "
  					If cPaisLoc <> "BRA"                        
						cQuery +=	"  SF2.F2_MOEDA F2_MOEDA, "
						cQuery +=	"  SF2.F2_TXMOEDA F2_TXMOEDA, "
					EndIf
					cQuery += 		"  SA4.A4_COD A4_COD, "
					cQuery += 		"  SA4.A4_NREDUZ A4_NREDUZ, "
					cQuery += 		"  SF2.R_E_C_N_O_ SF2RECNO "
					cQuery += "FROM "+RetSqlName("SF2")+" SF2 "
					If cDbMs == "INFORMIX"
						cQuery += ", OUTER "+ RetSqlName("SA4") + " SA4 "
					ElseIf cDbMs == "DB2"
				      cQuery += " LEFT OUTER JOIN "+ RetSqlName("SA4") + " SA4 "
						cQuery += " ON ( SF2.F2_TRANSP = SA4.A4_COD ) "
						cQuery += " AND SA4.A4_FILIAL = '"+xFilial("SA4")+"' "
						cQuery += " AND SA4.D_E_L_E_T_ = ' '"	
					Else
						cQuery += ", "+ RetSqlName("SA4") + " SA4 "
					Endif
					cQuery += " WHERE " //SF2.F2_FILIAL='"+xFilial("SF2")+"' AND "
					//cQuery += 		" SF2.F2_CLIENTE='"+SA1->A1_COD+"' AND "
					//cQuery +=		" SF2.F2_LOJA='"+SA1->A1_LOJA+"' AND "
					cQuery += 		" SF2.F2_CLIENTE||F2_LOJA In ("+U_Titular(SA1->A1_COD, SA1->A1_LOJA)+") AND "
					cQuery +=		" SF2.F2_TIPO NOT IN('D','B') AND "
					cQuery +=		" SF2.F2_EMISSAO>='"+DTOS(aParam[1])+"' AND "
					cQuery +=		" SF2.F2_EMISSAO<='"+DTOS(aParam[2])+"' AND "
					If !lPosClFt // lPosClFt = .T., Considera todos os pedidos (sem gerar titulos no financeiro)
						cQuery +=		" SF2.F2_VALFAT > 0 AND "
					Endif
					cQuery +=		" SF2.D_E_L_E_T_=' '"

					If cDbMs == "ORACLE"
						cQuery += " AND SF2.F2_TRANSP = SA4.A4_COD(+) "
						cQuery += " AND SA4.A4_FILIAL(+) = '"+xFilial("SA4")+"' "
						cQuery += " AND SA4.D_E_L_E_T_(+) = ' '"	

					ElseIf cDbMs == "INFORMIX"
						cQuery += " AND SF2.F2_TRANSP = SA4.A4_COD "
						cQuery += " AND SA4.A4_FILIAL = '"+xFilial("SA4")+"' "
						cQuery += " AND SA4.D_E_L_E_T_ = ' '"	

					ElseIf !(cDbMs == "DB2")
				   	cQuery += " AND SF2.F2_TRANSP *= SA4.A4_COD "			
						// cQuery += " AND SA4.A4_FILIAL = SF2.F2_FILIAL"   //+xFilial("SA4")+"' "
						cQuery += " AND SA4.D_E_L_E_T_ = ' '"	
					Endif
  				
					cQuery := ChangeQuery(cQuery)
					cQry   := cArquivo+"A"      
					// Alert(cQuery)


					dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cQry,.T.,.T.)

					TcSetField(cQry,"F2_EMISSAO","D")
					TcSetField(cQry,"F2_VALFAT","N",TamSx3("F2_VALFAT")[1],TamSx3("F2_VALFAT")[2])
					TcSetField(cQry,"F2_FRETE","N",TamSx3("F2_FRETE")[1],TamSx3("F2_FRETE")[2])
					TcSetField(cQry,"SF2RECNO","N",12,0)
					If cPaisLoc <> "BRA"
						TcSetField(cQry,"F2_MOEDA","N",TamSx3("F2_MOEDA")[1],TamSx3("F2_MOEDA")[2])
						TcSetField(cQry,"F2_TXMOEDA","N",TamSx3("F2_TXMOEDA")[1],TamSx3("F2_TXMOEDA")[2])
					EndIf                                                                                
				Else
			#ENDIF
				cQry := "SF2"

				#IFDEF TOP
				EndIf
				#ENDIF
			aGet[1] := 0
			aGet[2] := 0
			dbSelectArea(cQry)
			If ( !lQuery )
				dbSetOrder(2)
				dbSeek(xFilial("SF2")+SA1->A1_COD+SA1->A1_LOJA)
				bWhile := {|| !Eof() .And. xFilial("SF2") == SF2->F2_FILIAL .And.;
					SA1->A1_COD == SF2->F2_CLIENTE .And.;
					SA1->A1_LOJA == SF2->F2_LOJA }
				If lPosClFt // Considera todos os pedidos (sem gerar titulos no financeiro)
					bFiltro:= {|| !SF2->F2_TIPO$"DB" .And.;
					SF2->F2_EMISSAO >= aParam[1]     .And.;
					SF2->F2_EMISSAO <= aParam[2]}
				Else        // Considera apenas os faturados (somente que geraram titulos no financeiro)
					bFiltro:= {|| !SF2->F2_TIPO$"DB" .And.;
					SF2->F2_EMISSAO >= aParam[1] .And.;
					SF2->F2_EMISSAO <= aParam[2] .And.;
					SF2->F2_VALFAT  >  0}
				Endif
			Else
				bWhile := {|| !Eof() }
				bFiltro:= {|| .T. }
			EndIf			
			While ( Eval(bWhile) )				
				If ( Eval(bFiltro) )
					If !lQuery
					   // Se nao for query, posiciona SA4 para obter o nome da transportadora
						SA4->(MsSeek(xFilial("SA4")+SF2->F2_TRANSP))
					Endif
					RecLock(cAlias,.T.)
					(cAlias)->F2_FILIAL  := (cQry)->F2_FILIAL
					(cAlias)->F2_SERIE   := (cQry)->F2_SERIE
					(cAlias)->F2_DOC     := (cQry)->F2_DOC
					(cAlias)->F2_CLIENTE := (cQry)->F2_CLIENTE
					(cAlias)->F2_LOJA    := (cQry)->F2_LOJA
					(cAlias)->F2_EMISSAO := (cQry)->F2_EMISSAO
					(cAlias)->F2_DUPL    := (cQry)->F2_DUPL
					(cAlias)->F2_VALFAT  := (cQry)->F2_VALFAT
					(cAlias)->F2_FRETE   := (cQry)->F2_FRETE
					(cAlias)->F2_HORA    := (cQry)->F2_HORA
					(cAlias)->F2_TRANSP  := (cQry)->F2_TRANSP
					If cPaisLoc != "BRA"                      
						(cAlias)->F2_MOEDA    := (cQry)->F2_MOEDA
						(cAlias)->F2_TXMOEDA  := (cQry)->F2_TXMOEDA
					EndIf
					(cAlias)->A4_NREDUZ  := If(lQuery,(cQry)->A4_NREDUZ,SA4->A4_NREDUZ)
					(cAlias)->XX_RECNO   := If(lQuery,(cQry)->SF2RECNO,SF2->(RecNo()))
					(cAlias)->(MsUnLock())
				EndIf
				dbSelectArea(cQry)
				dbSkip()				
			EndDo
			If ( lQuery )
				dbSelectArea(cQry)
				dbCloseArea()
			EndIf
		EndIf		
		aGet[1] := 0
		aGet[2] := 0
		dbSelectArea(cAlias)
		dbGotop()
		If cPaisLoc == "BRA"
			dbEval({|| aGet[1]++,aGet[2]+=F2_VALFAT})
		Else 
			dbEval({|| aGet[1]++,aGet[2]+=Iif(F2_MOEDA == 1,F2_VALFAT,xMoeda(F2_VALFAT,F2_MOEDA,1,F2_EMISSAO,MsDecimais(1),F2_TXMOEDA))})			
		EndIf
		aGet[1] := TransForm(aGet[1],Tm(aGet[1],16,0))
		aGet[2] := TransForm(aGet[2],Tm(aGet[2],16,nCasas))			
	Case (nBrowse	==	5)
   		DEFINE MSDIALOG oCheq FROM   15,1 TO 150,272 TITLE STR0072 PIXEL //"Seleccion de parametros"
      	@ 6 , 11 TO 60, 93 OF oCheq   LABEL STR0073 PIXEL //"Tipos de cheques a exhibir"
      	@ 11, 13 RADIO oTipo VAR nTipo ;
               PROMPT STR0062,STR0064,If(cPaisLoc == 'URU',STR0088,STR0063),STR0074;  //"Pendientes"###"Cobrados"###"Negociados"###"Todos"
               OF oCheq PIXEL SIZE 75,12

      	DEFINE SBUTTON FROM 45, 100 TYPE 1 ACTION oCheq:End() ENABLE OF oCheq //11,132
	   	ACTIVATE MSDIALOG oCheq CENTERED
		
		Do case
			Case nTipo 	== 	1
				bTipo	:=	{ || (cQry)->E1_SALDO > 0 }
        	Case nTipo	==	2
				bTipo	:=	{ || !((cQry)->E1_SITUACA $ " 0FG") .And. (cQry)->E1_SALDO == 0 }
        	Case nTipo	==	3
				bTipo	:=	{ || (cQry)->E1_STATUS == "R" .And. (cQry)->E1_SITUACA $ " 0FG" .And. (cQry)->E1_SALDO == 0}
        	Case nTipo	==	4
				bTipo	:=	{ || .T. }
		EndCase

		nMoeda := 1
		dbSelectArea("SX3")
		dbSetOrder(2)
		dbSeek("E1_STATUS")
		aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})

		aadd(aHeader,{AllTrim(X3TITULO()),"XX_ESTADO","@!",04,0,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
		aadd(aStru,{"XX_ESTADO","C",04,0})

		dbSeek("E1_PREFIXO")
		aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
		aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		dbSeek("E1_NUM")
		aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
		aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		dbSeek("E1_PARCELA")
		aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
		aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		dbSeek("E1_NUMNOTA")
		aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
		aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		dbSeek("E1_EMISSAO")
		aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
		aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		dbSeek("E1_VALOR")
		aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
		aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		dbSeek("E1_MOEDA")
		aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
		aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		dbSeek("E1_VLCRUZ")
		aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
		aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		dbSeek("E1_VENCREA")
		aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
		aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		dbSeek("E1_NATUREZ")
		aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
		aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		dbSeek("E1_PORTADO")
		aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
		aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		dbSeek("E1_BCOCHQ")
		aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
		aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		dbSeek("E1_HIST")
		aadd(aHeader,{ AllTrim(X3TITULO()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
		aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})

		dbSeek("E1_SITUACA")
		aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		aadd(aHeader,{STR0045,"X5_DESCRI","@!",25,0,"","","C","SX5","" } ) //"Situacao"
		aadd(aStru,{"X5_DESCRI","C",25,0})

		aadd(aStru,{"XX_RECNO" ,"N",12,0})
		aadd(aStru,{"XX_VALOR" ,"N",18,0})

		dbSeek("E1_SALDO")
		aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})

		SX3->(dbSetOrder(1))
                        	
		cArquivo := CriaTrab(,.F.)			
		If !lExibe
			aadd(aAlias,{ cAlias , cArquivo })
   	Endif
		aadd(aStru,{"FLAG","L",01,0})
		dbCreate(cArquivo,aStru)
		dbUseArea(.T.,,cArquivo,cAlias,.F.,.F.)
		IndRegua(cAlias,cArquivo,"E1_PREFIXO+E1_NUM+E1_PARCELA")

		#IFDEF TOP
			If ( TcSrvType()!="AS/400" )
				lQuery := .T.
				cQuery := ""
				aEval(aQuery,{|x| cQuery += ","+AllTrim(x[1])})
				cQuery := "SELECT "+SubStr(cQuery,2)
				cQuery +=         ",SE1.R_E_C_N_O_ SE1RECNO"
				cQuery +=         ",SX5.X5_DESCRI "
				cQuery += "FROM "+RetSqlName("SE1")+" SE1,"
				cQuery +=         RetSqlName("SX5")+" SX5 "
				cQuery += "WHERE " //SE1.E1_FILIAL='"+xFilial("SE1")+"' AND "
				//cQuery +=      "SE1.E1_CLIENTE='"+SA1->A1_COD+"' AND "
				//cQuery +=      "SE1.E1_LOJA='"+SA1->A1_LOJA+"' AND "
				cQuery += 		"SE1.E1_CLIENTE||E1_LOJA In ("+U_Titular(SA1->A1_COD, SA1->A1_LOJA)+") AND "
				cQuery +=      "SE1.E1_EMISSAO>='"+Dtos(aParam[1])+"' AND "
				cQuery +=      "SE1.E1_EMISSAO<='"+Dtos(aParam[2])+"' AND "
				cQuery +=      "SE1.E1_VENCREA>='"+Dtos(aParam[3])+"' AND "
				cQuery +=		"SE1.E1_VENCREA<='"+Dtos(aParam[4])+"' AND "
				cQuery +=		"SE1.E1_TIPO IN" + FormatIn(cCheques,"|") + " AND "
				cQuery +=      "SE1.E1_PREFIXO>='"+aParam[6]+"' AND "
				cQuery +=      "SE1.E1_PREFIXO<='"+aParam[7]+"' AND "
				cQuery +=   "SE1.E1_MOEDA  = "+Alltrim(STR(nMoeda))+" AND "
				cQuery +=		"SE1.D_E_L_E_T_=' ' AND "
				cQuery +=      "SX5.X5_FILIAL='"+xFilial("SX5")+"' AND "
				cQuery +=		"SX5.X5_TABELA='07' AND "
				cQuery +=		"SX5.X5_CHAVE=SE1.E1_SITUACA AND "
				cQuery +=		"SX5.D_E_L_E_T_=' ' "

				cQuery := ChangeQuery(cQuery)
				cQry   := cArquivo+"A"

				MsAguarde({ || dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cQry,.T.,.T.)},STR0065) //"Seleccionado registros en el servidor"

				aEval(aQuery,{|x| If(x[2]!="C",TcSetField(cQry,x[1],x[2],x[3],x[4]),Nil)})
			Else
		#ENDIF
			cQry := "SE1"
		#IFDEF TOP
			EndIf
		#ENDIF

		dbSelectArea(cQry)
		If ( !lQuery )
			dbSetOrder(2)
			dbSeek(xFilial("SE1")+SA1->A1_COD+SA1->A1_LOJA)

			bWhile := {|| !Eof() .And. xFilial("SE1") == SE1->E1_FILIAL .And.;
										SA1->A1_COD    == SE1->E1_CLIENTE .And.;
										SA1->A1_LOJA   == SE1->E1_LOJA }
			bFiltro:= {|| 	SE1->E1_EMISSAO >= aParam[1] .And.;
								SE1->E1_EMISSAO <= aParam[2] .And.;
								SE1->E1_VENCREA >= aParam[3] .And.;
								SE1->E1_VENCREA <= aParam[4] .And.;
								SE1->E1_TIPO	 $ cCheques .And.;
								SE1->E1_PREFIXO >= aParam[6] .And.;
								SE1->E1_PREFIXO <= aParam[7]}
		Else
			bWhile := {|| !Eof() }
			bFiltro:= {|| .T. }
		EndIf			

		While ( Eval(bWhile) )				
			If ( Eval(bFiltro) ) .And. Eval(bTipo)
				If ( !lQuery )
					dbSelectArea("SX5")
					dbSetOrder(1)
					MsSeek(xFilial("SX5")+"07"+SE1->E1_SITUACA)
				EndIf
				dbSelectArea(cAlias)
				dbSetOrder(1)
				cChave := (cQry)->(E1_PREFIXO)+(cQry)->(E1_NUM)+(cQry)->(E1_PARCELA)
				If ( !dbSeek(cChave) )
					RecLock(cAlias,.T.)						
				Else
					RecLock(cAlias,.F.)
				EndIf
				For nCntFor := 1 To Len(aStru)
					Do Case
						Case ( AllTrim(aStru[nCntFor][1])=="X5_DESCRI" )
							If ( lQuery )
								(cAlias)->X5_DESCRI := (cQry)->X5_DESCRI
							Else
								(cAlias)->X5_DESCRI := SX5->X5_DESCRI
							EndIf
						Case ( AllTrim(aStru[nCntFor][1])=="XX_ESTADO" )
							If lQuery
								If (cQry)->E1_SALDO > 0
									(cAlias)->XX_ESTADO := STR0066 //"PEND"
								ElseIf (cQry)->E1_STATUS == "R" .And. (cQry)->E1_SITUACA $ "0FG"
									(cAlias)->XX_ESTADO := If(cPaisLoc == 'URU',STR0089,STR0067) //"NEGO"
								Else									
									(cAlias)->XX_ESTADO := STR0068 //"COBR"
								Endif
							Else
								If SE1->E1_SALDO > 0
									(cAlias)->XX_ESTADO := STR0066 //"PEND"
								ElseIf SE1->E1_STATUS == "R" .And. SE1->E1_SITUACA $ "0FG"
									(cAlias)->XX_ESTADO := IIf(cPaisLoc == "URU",STR0089,STR0067) //"NEGO"
								Else									
									(cAlias)->XX_ESTADO := STR0068 //"COBR"
								Endif
							Endif
						Case ( AllTrim(aStru[nCntFor][1])=="XX_RECNO" )
							If ( lQuery )
								(cAlias)->XX_RECNO := (cQry)->SE1RECNO
							Else
								(cAlias)->XX_RECNO := SE1->(RecNo())
							EndIf
						Case ( AllTrim(aStru[nCntFor][1])=="XX_VALOR" )
							If ( lQuery )
								(cAlias)->XX_VALOR := IIf(nMoeda  > 1, xMoeda((cQry)->E1_VALOR,(cQry)->E1_MOEDA,nMoeda,,,If(cPaisLoc=="BRA",(cQry)->E1_TXMOEDA,0)),(cQry)->E1_VLCRUZ)
							Else
								(cAlias)->XX_VALOR :=  IIf(nMoeda  > 1, xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,nMoeda,,,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0)),SE1->E1_VLCRUZ)
							EndIf
						Case ( AllTrim(aStru[nCntFor][1])=="FLAG" )

						OtherWise							
							(cAlias)->(FieldPut(nCntFor,(cQry)->(FieldGet(FieldPos(aStru[nCntFor][1])))))
					EndCase
				Next nCntFor
				dbSelectArea(cAlias)
				MsUnLock()
			EndIf
			dbSelectArea(cQry)
			dbSkip()				
		EndDo
		If ( lQuery )
			dbSelectArea(cQry)
			dbCloseArea()
		EndIf                                              
		//������������������������������������������������������������������������Ŀ
		//�Totais da Consulta                                                      �
		//��������������������������������������������������������������������������
		dbSelectArea(cAlias)
		dbGotop()
		aGet	:=	{0,0,0,0,0,0}
		While !EOF()
			DO CASE
				CASE XX_ESTADO	==	STR0066 //"PEND"
				 	aGet[1]	+=	(cAlias)->XX_VALOR
				 	aGet[4]++
				CASE XX_ESTADO	==	If(cPaisLoc == 'URU',STR0089,STR0067) //"NEGO"
				 	aGet[2]	+=	(cAlias)->XX_VALOR
				 	aGet[5]++
				CASE XX_ESTADO	==	STR0068 //"COBR"
				 	aGet[3]	+=	(cAlias)->XX_VALOR
				 	aGet[6]++
			EndCase				 	
			dbSkip()
		Enddo
		If lExibe
 		    aGet[1] := TransForm(aGet[1],Tm(aGet[1],16,MsDecimais(nMoeda))) + " (" +Alltrim(STR(aGet[4]))+")"
			aGet[2] := TransForm(aGet[2],Tm(aGet[2],16,MsDecimais(nMoeda))) + " (" +Alltrim(STR(aGet[5]))+")"
			aGet[3] := TransForm(aGet[3],Tm(aGet[3],16,MsDecimais(nMoeda))) + " (" +Alltrim(STR(aGet[6]))+")"
			aGet[4] := STR0069+GetMv("MV_MOEDA1") //"Valores en "
		EndIf
	Otherwise
		Alert(STR0060)		//N�o Implementado
		lExibe := .f.
EndCase	
//������������������������������������������������������������������������Ŀ
//�Exibe os dados Gerados                                                  �
//��������������������������������������������������������������������������
If ( lExibe )
	dbSelectArea(cAlias)
	dbGotop()
	If ( !Eof() )
		
		aObjects := {} 
		AAdd( aObjects, { 100, 35,  .t., .f., .t. } )
		AAdd( aObjects, { 100, 100 , .t., .t. } )
		AAdd( aObjects, { 100, 50 , .t., .f. } )
		
		aInfo    := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 } 
		aPosObj1 := MsObjSize( aInfo, aObjects) 
		
		DEFINE FONT oBold    NAME "Arial" SIZE 0, -12 BOLD

		DEFINE MSDIALOG oDlg FROM	aSize[7],0 TO aSize[6],aSize[5] TITLE cCadastro OF oMainWnd PIXEL
		@ aPosObj1[1,1], aPosObj1[1,2] MSPANEL oScrPanel PROMPT "" SIZE aPosObj1[1,3],aPosObj1[1,4] OF oDlg LOWERED

		@ 04,004 SAY OemToAnsi(STR0006) SIZE 025,07          OF oScrPanel PIXEL //"Codigo"
		@ 12,004 SAY SA1->A1_COD  SIZE 060,09  OF oScrPanel PIXEL FONT oBold

		@ 04,067 SAY OemToAnsi(STR0007) SIZE 020,07          OF oScrPanel PIXEL //"Loja"
		@ 12,067 SAY SA1->A1_LOJA SIZE 021,09 OF oScrPanel PIXEL FONT oBold

		@ 04,090 SAY OemToAnsi(STR0008) SIZE 025,07 OF oScrPanel PIXEL //"Nome"
		@ 12,090 SAY SA1->A1_NOME SIZE 165,09 OF oScrPanel PIXEL FONT oBold

		oGetDb:=MsGetDB():New(aPosObj1[2,1],aPosObj1[2,2],aPosObj1[2,3],aPosObj1[2,4],2,"",,,.F.,,,.F.,,cAlias,,,,,,.T.)
		oGetdb:lDeleta:=NIL
		dbSelectArea(cAlias)
		dbGotop()

		@ aPosObj1[3,1]+04,005 SAY aSay[1] SIZE 025,07 OF oDlg PIXEL
		@ aPosObj1[3,1]+04,175 SAY aSay[2] SIZE 025,07 OF oDlg PIXEL
		@ aPosObj1[3,1]+15,005 SAY aSay[3] SIZE 025,07 OF oDlg PIXEL
		@ aPosObj1[3,1]+15,175 SAY aSay[4] SIZE 025,07 OF oDlg PIXEL
		@ aPosObj1[3,1]+26,005 SAY aSay[5] SIZE 025,07 OF oDlg PIXEL
		@ aPosObj1[3,1]+26,175 SAY aSay[6] SIZE 025,07 OF oDlg PIXEL

		@ aPosObj1[3,1]+04,045 SAY aGet[1] SIZE 060,07 OF oDlg PIXEL
		@ aPosObj1[3,1]+04,215 SAY aGet[2] SIZE 060,07 OF oDlg PIXEL
		@ aPosObj1[3,1]+15,045 SAY aGet[3] SIZE 060,07 OF oDlg PIXEL
		@ aPosObj1[3,1]+15,215 SAY aGet[4] SIZE 060,07 OF oDlg PIXEL
		@ aPosObj1[3,1]+26,045 SAY aGet[5] SIZE 060,07 OF oDlg PIXEL
		@ aPosObj1[3,1]+26,215 SAY aGet[6] SIZE 060,07 OF oDlg PIXEL

		If ( nBrowse == 1 ) // Para titulos em aberto, mostra legenda.
			Fc010Legenda(oDlg,aPosObj1,aSay,aGet)
		Endif
		
		DEFINE SBUTTON 		FROM 04,aPosObj1[1,3]-If(nBrowse <= 2,60,30) TYPE  1  ENABLE OF oScrPanel ACTION ( oDlg:End() )
		// Exibe o botao de distribuicao por moedas, apenas na consulta de titulos
		// em aberto e recebidos
		If nBrowse <= 2
			SButton():New( 4, aPosObj1[1,3]-30, 18,{||Fc010Moeda(If(nBrowse==1,aTotRec,aTotPag),oScrPanel)},oScrPanel,.T.,STR0097) //"Consulta distribui��o por moedas"
		Endif	
		DEFINE SBUTTON oBtn 	FROM 19,aPosObj1[1,3]-30 TYPE 15 ENABLE OF oScrPanel

		oBtn:lAutDisable := .F.
		If ( bVisual != Nil )
			oBtn:bAction := bVisual
		Else
			oBtn:SetDisable(.T.)
		EndIf
		ACTIVATE MSDIALOG oDlg
	Else
		Help(" ",1,"REGNOIS")	
	EndIf
	If nBrowse == 5
		(cAlias)->(dbCloseArea()) ;Ferase(cArquivo+GetDBExtension());Ferase(cArquivo+OrdBagExt())
	Endif
EndIf
RestArea(aAreaSC5)
RestArea(aAreaSC6)
RestArea(aAreaSC9)
RestArea(aAreaSF4)
RestArea(aArea)
Return(aHeader)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 �fc010Visua� Autor �Eduardo Riera  		� Data �04/01/2000���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Funcao de Visualizacao dos Itens individuais da Posicao de  ���
���          �Cliente.                                                    ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe	 �Fc010Visua()        						     			  ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpN1		: Recno do Arquivo principal                      ���
���          �ExpN2		: nBrowse                                         ���
�������������������������������������������������������������������������Ĵ��
��� Uso		 � FINC010													 				  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function Fc010Visua(nRecno,nBrowse)

Local aArea := GetArea()
Local aAreaSE1 := SE1->(GetArea())
Local aAreaSE5 := SE5->(GetArea())
Local aAreaSC5 := SC5->(GetArea())
Local aSavAhead:= If(Type("aHeader")=="A",aHeader,{})
Local aSavAcol := If(Type("aCols")=="A",aCols,{})
Local nSavN    := If(Type("N")=="N",N,0)

Do Case
Case ( nBrowse == 1 )
	SE1->(MsGoto(nRecno))
	SE1->(AxVisual("SE1",nRecNo,2))

Case ( nBrowse == 2 )
	SE5->(MsGoto(nRecno))
	SE5->(AxVisual("SE5",nRecNo,2))

Case ( nBrowse == 3 )
	SC5->(MsGoto(nRecno))		
	SC5->(a410Visual("SC5",nRecNo,2))

Case ( nBrowse == 4 )
	SF2->(MsGoto(nRecno))
	SF2->(Mc090Visual("SF2",nRecNo,2))
	
EndCase
//������������������������������������������������������������������������Ŀ
//�Restaura a Integridade dos Dados                                        �
//��������������������������������������������������������������������������
aHeader := aSavAHead
aCols   := aSavACol
N       := nSavN

RestArea(aAreaSC5)
RestArea(aAreaSE5)
RestArea(aAreaSE1)
RestArea(aArea)
Return(.T.)	

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Program   � ImpDet   � Autor � Eduardo Riera         � Data �02.07.1998���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Controle de Fluxo do Relatorio.                             ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Nenhum                                                      ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ImpDet(lEnd,wnrel,cString,cNomeprog,cTitulo)

Local li      := 100 // Contador de Linhas
Local lImp    := .F. // Indica se algo foi impresso
Local cbCont  := 0   // Numero de Registros Processados
Local cbText  := ""  // Mensagem do Rodape
Local cMoeda  := ""
Local aCol    := {}
Local aHeader := {}
Local nCntFor := 0
//
//                          1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21        22
//                01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
Local cCabec1 := ""
Local cCabec2 := ""
Local aAlias  := {}
Local aParam  := {}
Local nMCusto := If(SA1->A1_MOEDALC > 0,SA1->A1_MOEDALC,Val(GetMv("MV_MCUSTO")))
Local cSalFin :=""
Local cLcFin  :=""
Local aGet      := {"","","",""}
	
SX3->(DbSetOrder(2))
cLcFin	:=	If(SX3->(DbSeek("A1_LCFIN")) ,X3Titulo(),STR0076)
cSalFin  := If(SX3->(DbSeek("A1_SALFIN")),X3Titulo(),STR0075)

aadd(aParam,MV_PAR01)
aadd(aParam,MV_PAR02)
aadd(aParam,MV_PAR03)
aadd(aParam,MV_PAR04)
aadd(aParam,MV_PAR05)
aadd(aParam,MV_PAR06)
aadd(aParam,MV_PAR07)
aadd(aParam,MV_PAR08)
aadd(aParam,MV_PAR09)
aadd(aParam,MV_PAR10)
aadd(aParam,MV_PAR11)
aadd(aParam,MV_PAR12)

cMoeda	:= AllTrim(STR(nMCusto))
cMoeda	:= SubStr(Getmv("MV_SIMB"+cMoeda)+Space(4),1,4)

dbSelectArea(cString)
SetRegua(LastRec())
dbSetOrder(1)

Li := cabec(cTitulo,cCabec1,cCabec2,cNomeProg,Tamanho)
@li,000 PSAY Replicate("*",220)
Li++
@li,001 PSAY RetTitle("A1_COD")+": "+SA1->A1_COD+" "+RetTitle("A1_NOME")+": "+SA1->A1_NOME+" "+RetTitle("A1_TEL")+": "+;
	Alltrim(SA1->A1_DDI+" "+SA1->A1_DDD+" "+SA1->A1_TEL)
Li++
@li,001 PSAY RetTitle("A1_CGC")+": "+SA1->A1_CGC
Li++
@Li,001 PSAY RetTitle("A1_PRICOM")+": "+DTOC(SA1->A1_PRICOM)
Li++
@Li,001 PSAY RetTitle("A1_ULTCOM")+": "+DTOC(SA1->A1_ULTCOM)
Li++
@Li,001 PSAY RetTitle("A1_MATR")+": "+TransForm(SA1->A1_MATR,PesqPict("SA1","A1_MATR",4))
Li++
@Li,001 PSAY RetTitle("A1_METR")+": "+TransForm(SA1->A1_METR,PesqPict("SA1","A1_METR",4)) 
Li++
@Li,001 PSAY RetTitle("A1_CHQDEVO")+": "+TransForm(SA1->A1_CHQDEVO,PesqPict("SA1","A1_CHQDEVO",4))
Li++
@Li,001 PSAY RetTitle("A1_DTULCHQ")+": "+Dtoc(SA1->A1_DTULCHQ)
Li++
@Li,001 PSAY RetTitle("A1_TITPROT")+": "+TransForm(SA1->A1_TITPROT,PesqPict("SA1","A1_TITPROT",4))
Li++
@Li,001 PSAY RetTitle("A1_DTULTIT")+": "+DtoC(SA1->A1_DTULTIT)
Li++
@Li,001 PSAY RetTitle("A1_RISCO")+": "+SA1->A1_RISCO
Li++
@Li,001 PSAY RetTitle("A1_VENCLC")+": "+Dtoc(SA1->A1_VENCLC)
Li++
@Li,001 PSAY STR0077+Space(31-Len(STR0077))+STR0078+;
Space(11-Len(STR0078))+STR0069+cMoeda
Li++
@Li,001 PSAY RetTitle("A1_SALDUP")+": "+Space(20-Len(RetTitle("A1_SALDUP")))+TransForm(SA1->A1_SALDUP,PesqPict("SA1","A1_SALDUP",14,1))+;
SPACE(6)+TransForm(SA1->A1_SALDUPM,PesqPict("SA1","A1_SALDUPM",14,nMcusto))
Li++
@Li,001 PSAY RetTitle("A1_MCOMPRA")+": "+Space(20-Len(RetTitle("A1_MCOMPRA")))+TransForm(xMoeda(SA1->A1_MCOMPRA,nMcusto,1,dDataBase,MsDecimais(1)),;
PesqPict("SA1","A1_MCOMPRA",14,1))+SPACE(6)+TransForm(SA1->A1_MCOMPRA,PesqPict("SA1","A1_MCOMPRA",14,nMcusto))
Li++
@Li,001 PSAY RetTitle("A1_MSALDO")+": "+Space(20-Len(RetTitle("A1_MSALDO")))+TransForm(xMoeda(SA1->A1_MSALDO,nMcusto,1,dDataBase,MsDecimais(1)),;
PesqPict("SA1","A1_MCOMPRA",14,1))+SPACE(6)+TransForm(SA1->A1_MSALDO,PesqPict("SA1","A1_MCOMPRA",14,nMCusto))
Li++

@Li,001 PSAY cSalFin+": "+Space(20-Len(cSalFin))+;
TRansform(SA1->A1_SALFIN,PesqPict("SA1","A1_SALFIN",14,1))+SPACE(6)+;
TRansform(SA1->A1_SALFINM,PesqPict("SA1","A1_SALFINM",14,nMcusto))
Li++

@Li,001 PSAY cLcFin+": "+Space(20-Len(cLcFin))+;
TRansform(xMoeda(SA1->A1_LCFIN,nMcusto,1,dDatabase,MsDecimais(1)),PesqPict("SA1","A1_LCFIN",14,1))+;
SPACE(6)+TRansform(SA1->A1_LCFIN,PesqPict("SA1","A1_LCFIN",14,nMcusto))

Li++

@Li,001 PSAY RetTitle("A1_LC")+": "+Space(20-Len(RetTitle("A1_LC")))+TransForm(xMoeda(SA1->A1_LC,nMcusto,1,dDataBase,MsDecimais(nMCusto)),PesqPict("SA1","A1_LC",14,nMCusto))+SPACE(6)+;
        		 TransForm(SA1->A1_LC,PesqPict("SA1","A1_LC",14,1))

Li+=3
@Li,001 PSAY PadC(STR0053,Limite) //"TITULOS EM ABERTO"
Li++
aHeader := Fc010Brow(1,@aAlias,aParam,.F.,aGet,.T.)
IncRegua(1)
cCabec1 := ""
aCol    := {}
dbSelectArea(aAlias[Len(aAlias)][1])
dbGotop()
aadd(aCol,1)
For nCntFor := 1 To Len(aHeader)
		If !(Alltrim(aHeader[nCntFor][2]) $ "E1_SDACRES#E1_SDDECRE") .and. !(Alltrim(aHeader[nCntFor][2])== "E1_SALDO2")
		cCabec1 += PadR(aHeader[nCntFor][1],Max(Len(TransForm(FieldGet(FieldPos(aHeader[nCntFor][2])),Trim(aHeader[nCntFor][3]))),Len(AllTrim(aHeader[nCntFor][1]))))+Space(1)
	Endif
	aadd(aCol,Len(cCabec1)+1)
Next nCntFor
@ Li,001 PSAY cCabec1
Li++
While ( !Eof() )
	lImp := .T.
	If lEnd
		@ Prow()+1,001 PSAY STR0070 //"CANCELADO PELO OPERADOR"
		Exit
	EndIf
	If ( Li > 56 )
		li := cabec(cTitulo,cCabec1,cCabec2,cNomeprog,Tamanho)
		li++
	Endif
	For nCntFor := 1 To Len(aHeader)
		If !(Alltrim(aHeader[nCntFor][2]) $ "E1_SDACRES#E1_SDDECRE") .and. !(Alltrim(aHeader[nCntFor][2])== "E1_SALDO2")
			@ Li,aCol[nCntFor] PSAY TransForm(FieldGet(FieldPos(aHeader[nCntFor][2])),Trim(aHeader[nCntFor][3]))
		Endif		
	Next nCntFor
	Li++
	dbSkip()
	cbCont++
EndDo
Li++
@Li,001 PSAY STR0087 + RIGHT(aGet[1],5)  //"Total : "
@Li,069 PSAY aGet[2]
@Li,119 PSAY aGet[3]

Li+=3
If ( Li > 55 )
	li := cabec(cTitulo,"","",cNomeprog,Tamanho)
	li++
Endif

@Li,001 PSAY PadC(STR0054,Limite) //"TITULOS RECEBIDOS"
Li++
aHeader := Fc010Brow(2,@aAlias,aParam,.F.,aGet,.T.)
cCabec1 := ""
aCol    := {}
IncRegua(2)

dbSelectArea(aAlias[Len(aAlias)][1])
dbGotop()
aadd(aCol,1)
For nCntFor := 1 To Len(aHeader)
	If !Alltrim(aHeader[nCntFor][2]) $ "E5_VLJUROS#E5_VLMULTA#E5_VLCORRE#E5_VLDESCO"
		cCabec1 += PadR(aHeader[nCntFor][1],Max(Len(TransForm(FieldGet(FieldPos(aHeader[nCntFor][2])),Trim(aHeader[nCntFor][3]))),Len(AllTrim(aHeader[nCntFor][1]))))+Space(1)	
		aadd(aCol,Len(cCabec1)+1)
	Else
		aadd(aCol,aCol[Len(aCol)])		// Deixar aCol do mesmo tamanho de aHeader para que na impressao nao
						  						// ocorram problemas.
	Endif	
Next nCntFor
@ Li,001 PSAY cCabec1
Li++
While ( !Eof() )
	lImp := .T.
	If lEnd
		@ Prow()+1,001 PSAY STR0070 //"CANCELADO PELO OPERADOR"
		Exit
	EndIf
	If ( Li > 56 )
		li := cabec(cTitulo,cCabec1,cCabec2,cNomeprog,Tamanho)
		li++
	Endif
	For nCntFor := 1 To Len(aHeader)
		If !Alltrim(aHeader[nCntFor][2]) $ "E5_VLJUROS#E5_VLMULTA#E5_VLCORRE#E5_VLDESCO"
			@ Li,aCol[nCntFor] PSAY TransForm(FieldGet(FieldPos(aHeader[nCntFor][2])),Trim(aHeader[nCntFor][3]))
		Endif	
	Next nCntFor
	Li++
	dbSkip()
	cbCont++
EndDo
Li++
@Li,001 PSAY STR0087 + RIGHT(aGet[1],5)   //"Total : "
@Li,054 PSAY aGet[3]

Li+=3
If ( Li > 55 )
	li := cabec(cTitulo,"","",cNomeprog,Tamanho)
	li++
Endif

@Li,001 PSAY PadC(STR0055,Limite) //"PEDIDOS"
Li++
aHeader := Fc010Brow(3,@aAlias,aParam,.F.,aGet,.T.)
cCabec1 := ""
aCol    := {}
IncRegua(3)

dbSelectArea(aAlias[Len(aAlias)][1])
dbGotop()
aadd(aCol,1)
For nCntFor := 1 To Len(aHeader)
	cCabec1 += PadR(aHeader[nCntFor][1],Max(Len(TransForm(FieldGet(FieldPos(aHeader[nCntFor][2])),Trim(aHeader[nCntFor][3]))),Len(AllTrim(aHeader[nCntFor][1]))))+Space(1)	
	aadd(aCol,Len(cCabec1)+1)
Next nCntFor
@ Li,001 PSAY cCabec1
Li++
While ( !Eof() )
	lImp := .T.
	If lEnd
		@ Prow()+1,001 PSAY STR0070 //"CANCELADO PELO OPERADOR"
		Exit
	EndIf
	If ( Li > 56 )
		li := cabec(cTitulo,cCabec1,cCabec2,cNomeprog,Tamanho)
		li++
	Endif
	For nCntFor := 1 To Len(aHeader)
		@ Li,aCol[nCntFor] PSAY TransForm(FieldGet(FieldPos(aHeader[nCntFor][2])),Trim(aHeader[nCntFor][3]))
	Next nCntFor
	Li++
	dbSkip()
	cbCont++
EndDo
Li+=2

@Li,001 PSAY STR0087 + RIGHT(aGet[1],5)   //"Total : "
@Li,019 PSAY Transform(Val(StrTran(aGet[2],".","")),"@E 999,999,999.99")
@Li,034 PSAY Transform(Val(StrTran(aGet[3],".","")),"@E 999,999,999.99")
@Li,049 PSAY Transform(Val(StrTran(aGet[4],".","")),"@E 999,999,999.99")

Li+=3

If ( Li > 55 )
	li := cabec(cTitulo,"","",cNomeprog,Tamanho)
	li++
Endif

@Li,001 PSAY PadC(STR0056,Limite) //"FATURAMENTO"
Li++
aHeader := Fc010Brow(4,@aAlias,aParam,.F.,aGet,.T.)
cCabec1 := ""
aCol    := {}
IncRegua(4)

dbSelectArea(aAlias[Len(aAlias)][1])
dbGotop()
aadd(aCol,1)
For nCntFor := 1 To Len(aHeader)
	cCabec1 += PadR(aHeader[nCntFor][1],Max(Len(TransForm(FieldGet(FieldPos(aHeader[nCntFor][2])),Trim(aHeader[nCntFor][3]))),Len(AllTrim(aHeader[nCntFor][1]))))+Space(1)	
	aadd(aCol,Len(cCabec1)+1)
Next nCntFor
@ Li,001 PSAY cCabec1
Li++
While ( !Eof() )
	lImp := .T.
	If lEnd
		@ Prow()+1,001 PSAY STR0070 //"CANCELADO PELO OPERADOR"
		Exit
	EndIf
	If ( Li > 56 )
		li := cabec(cTitulo,cCabec1,cCabec2,cNomeprog,Tamanho)
		li++
	Endif
	For nCntFor := 1 To Len(aHeader)
		@ Li,aCol[nCntFor] PSAY TransForm(FieldGet(FieldPos(aHeader[nCntFor][2])),Trim(aHeader[nCntFor][3]))
	Next nCntFor
	Li++
	dbSkip()
	cbCont++
EndDo
Li++
@Li,001 PSAY STR0087 + RIGHT(aGet[1],5)   //"Total : "
@Li,045 PSAY aGet[2]
Li++

If cPaisLoc	<> "BRA"
	Li++
	@Li,001 PSAY PadC(STR0061,Limite) //"Cartera de Cheques"
	Li++
	
	aHeader := Fc010Brow(5,@aAlias,aParam,.F.,aGet,.T.)
	
	IncRegua(5)
	
	cCabec1 := ""
	aCol    := {}
	
	dbSelectArea(aAlias[Len(aAlias)][1])
	dbGotop()
	
	aadd(aCol,1)
	
	For nCntFor := 1 To Len(aHeader)
		//������������������������������������������������������������������������Ŀ
		//� Verifica se e um campo numero, para alinhar a direita                  �
		//��������������������������������������������������������������������������
		
		If aHeader[nCntFor,8] == "N"
			cCabec1 += PadL(aHeader[nCntFor,1],Max(Len(TransForm(FieldGet(FieldPos(aHeader[nCntFor,2])),Trim(aHeader[nCntFor,3]))),Len(AllTrim(aHeader[nCntFor,1]))))+Space(1)
		Else
			cCabec1 += PadR(aHeader[nCntFor,1],Max(Len(TransForm(FieldGet(FieldPos(aHeader[nCntFor,2])),Trim(aHeader[nCntFor,3]))),Len(AllTrim(aHeader[nCntFor,1]))))+Space(1)
		EndIf
				
		aadd(aCol,Len(cCabec1)+1)
	Next nCntFor
	
	@ Li,001 PSAY alltrim(cCabec1)
	
	Li++
	
	//����������������������������������������������������Ŀ
	//� Variaveis que controlam os totalizadores           �
	//������������������������������������������������������
	
	aVals	:=	{0,0,0,0,0,0}	
	nPosEst	:=	Ascan(aHeader,{|x| Trim(x[2]) == "XX_ESTADO"})
	nPosVal	:=	Ascan(aHeader,{|x| Trim(x[2]) == "E1_VLCRUZ"})
	dbSelectArea(aAlias[Len(aAlias)][1])
	dbGotop()
	
	While ( !Eof() )
		lImp := .T.
		
		If lEnd
			@ Prow()+1,001 PSAY STR0070 //"CANCELADO PELO OPERADOR"
			Exit
		EndIf
		
		If ( Li > 56 )
			li := cabec(cTitulo,cCabec1,cCabec2,cNomeprog,Tamanho)
			li++
		Endif
	
	
		For nCntFor := 1 To Len(aHeader)
			@ Li,aCol[nCntFor] PSAY TransForm(FieldGet(FieldPos(aHeader[nCntFor][2])),Trim(aHeader[nCntFor][3]))
	 	Next

		Li++
		cbCont++
		Do Case
			CASE FieldGet(FieldPos(aHeader[nPosEst,2]))	==	STR0066 //"PEND"
			 	aVals[1]	+=	FieldGet(FieldPos(aHeader[nPosVal,2]))
			 	aVals[4]++
			CASE FieldGet(FieldPos(aHeader[nPosEst,2]))	==	If(cPaisLoc == 'URU',STR0089,STR0067) //"NEGO"
			 	aVals[2]	+=	FieldGet(FieldPos(aHeader[nPosVal,2]))
			 	aVals[5]++
			CASE FieldGet(FieldPos(aHeader[nPosEst,2]))	==	STR0068 //"COBR"
			 	aVals[3]	+=	FieldGet(FieldPos(aHeader[nPosVal,2]))
			 	aVals[6]++
		EndCase				 	

		dbSkip()
	 EndDo
	
	Li++
	
	@Li,000  PSAY STR0071 //"Totales --> "
	@Li,020 	PSAY STR0062+ " : " + Transform(aVals[1],Tm(aVals[1],16,MsDecimais(1))) + " (" + Alltrim(STR(aVals[4])) + ")" //"Pendientes"
	If cPaisLoc == "URU"
		@Li,060	PSAY STR0088+ " : " + Transform(aVals[2],Tm(aVals[2],16,MsDecimais(1)))	+ " (" + Alltrim(STR(aVals[5])) + ")" //"Negociados"
	Else
	@Li,060	PSAY STR0063+ " : " + Transform(aVals[2],Tm(aVals[2],16,MsDecimais(1)))	+ " (" + Alltrim(STR(aVals[5])) + ")" //"Negociados"
	Endif
	@Li,100 	PSAY STR0064+ " : " + Transform(aVals[3],Tm(aVals[3],16,MsDecimais(1)))	+ " (" + Alltrim(STR(aVals[6])) + ")" //"Cobrados  "
	
	Li++
Endif
If ( lImp )
	Roda(cbCont,cbText,Tamanho)
EndIf
If Trim(GetMV("MV_VEICULO")) == "S"
   FG_SALOSV(SA1->A1_COD,SA1->A1_LOJA,," ","I")
EndIf   

aEval(aAlias,{|x| (x[1])->(dbCloseArea()),Ferase(x[2]+GetDBExtension()),Ferase(x[2]+OrdBagExt())})
dbSelectArea("SA1")
Set Device To Screen
Set Printer To


If ( aReturn[5] = 1 )
	dbCommitAll()
	OurSpool(wnrel)
Endif
MS_FLUSH()
Return(.T.)


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Program   �FC010TotRc� Autor � Mauricio Pequim Jr    � Data �30.08.2001���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Somat�ria dos titulos recebidos                             ���
�������������������������������������������������������������������������Ĵ��
���Parametros�aGet - Array que guardar� o nro de titulos, valores princi- ���
���          �       pais e valor da baixa                                ���
���          �cAlias - Alias do arquivo tempor�rio                        ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function cFC010TotRc(aGet,cAlias,aTotPag)
Local cTitAnt := ""
Local nAscan

While !Eof()
	aGet[1]++
	// Impressao do relatorio nao existe E1_MOEDA no temporario
	If FieldPos("E1_MOEDA") > 0
		nAscan := Ascan(aTotPag,{|e| e[MOEDATIT] == E1_MOEDA})
		If nAscan = 0
			Aadd(aTotPag,{1,E1_MOEDA,If(E1_MOEDA>1,E1_VLMOED2,E1_PAGO),E1_PAGO})
		Else
			aTotPag[nAscan][QTDETITULOS]++
			aTotPag[nAscan][VALORTIT]		+= If(E1_MOEDA>1,E1_VLMOED2,E1_PAGO)
			aTotPag[nAscan][VALORREAIS]	+= E1_PAGO
		Endif
	Endif
	//����������������������������������������������������������������Ŀ
	//� Somo o valor do titulo apenas uma vez em caso de baixa parcial �
	//������������������������������������������������������������������
	If (cAlias)->(E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO) != cTitAnt
		aGet[2]+= E1_VLCRUZ
		cTitAnt := (cAlias)->(E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO)
	Endif
	aGet[3] += E1_PAGO
	dbSkip()
Enddo
Return (aGet)	

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Program   �Fc010Moeda� Autor � Claudio Donizete Souza� Data �13.11.2002���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Exibe os totais a pagar a recebidos por moeda               ���
�������������������������������������������������������������������������Ĵ��
���Parametros�aTotais- Matriz de totais por moeda								  ���
���          �oDlg   - Objeto dialog que sera exibida a tela da consulta  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function cFc010Moeda(aTotais,oDlg)
Local	aCab := { STR0098	,; //"Qtde. Titulos"
					 STR0099	,; //"Moeda"
					 STR0100	,; //"Valor na moeda"
					 STR0101} 	//"Valor em R$"
Local oLbx					 
	DEFINE DIALOG oDlg FROM 0,0 TO 20,70 TITLE STR0102 OF oDlg //"Distribui��o por moeda"
	oLbx := RDListBox(.5, .4, 270, 130, aTotais, aCab)
	oLbx:LNOHSCROLL := .T.
	oLbx:LHSCROLL := .F.
	ACTIVATE MSDIALOG oDlg CENTERED
Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Program   �Fc010Legen� Autor � Claudio Donizete Souza� Data �13.11.2002���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Exibe legenda de titulos baixados parcial ou totalmente     ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
static Function Fc010Legenda(oDlg,aPosObj1,aSay,aGet)
	@ aPosObj1[3,1]+37,005 SAY aSay[7] SIZE 025,07 OF oDlg PIXEL  //Total Geral
	@ aPosObj1[3,1]+37,045 SAY aGet[7] SIZE 060,07 OF oDlg PIXEL

	@ aPosObj1[3,1]+4, 300 BITMAP oBmp RESNAME "BR_AZUL" SIZE 16,16 NOBORDER OF oDlg PIXEL
	@ aPosObj1[3,1]+4, 310 SAY STR0093 OF oDlg PIXEL // "Baixado parcial"
			
	@ aPosObj1[3,1]+15, 300 BITMAP oBmp1 RESNAME "BR_VERDE" SIZE 16,16 NOBORDER OF oDlg PIXEL
	@ aPosObj1[3,1]+15, 310 SAY STR0094 OF oDlg PIXEL // "Sem baixas"

	@ aPosObj1[3,1]+26, 300 BITMAP oBmp RESNAME "BR_AMARELO" SIZE 16,16 NOBORDER OF oDlg PIXEL
	@ aPosObj1[3,1]+26, 310 SAY STR0113 OF oDlg PIXEL   //"Titulo c/ Cheque Devolvido"

Return Nil	

/*\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
Retorna os clientes de faturamento de um determinado cliente de entrega   
/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/*/
User Function Titular(_cCli, _cLoj)
_cArea := GetArea()
_cQuery := "Select DISTINCT C5_CLIENTE, C5_LOJACLI From "+RetSqlName('SC5')+" Where C5_CLIENT = '"+_cCli+"' And C5_LOJAENT = '"+_cLoj+"' And D_E_L_E_T_ = ' '"
dbUseArea(.T.,"TOPCONN",TCGENQRY(,,_cQuery),"TRB_CLI",.F.,.T.)
_cRet := "'"+_cCli+_cLoj+"',"
Do While !EoF()        
   _cRet += "'"+TRB_CLI->(C5_CLIENTE+C5_LOJACLI)+"',"   
   DbSkip()
EndDo                       
_cRet := Left(_cRet, Len(_cRet)-1)
TRB_CLI->(DbCloseArea())
RestArea(_cArea)    
Return _cRet

