#Include "rwmake.Ch"
#Include "PROTHEUS.Ch"

/*
"LP 001/001 " + alltrim(mv_par03)  + ' ' + time() + ' ' + cUserName + ' ' + LERDATA(8,10)           

1o. Estrutura da linha do arquivo TXT analisado:
LLLDDMMYYYYTDDDDDDDDDDDDDDDDDDDDCCCCCCCCCCCCCCCCCCCCVVVVVVVVVVVVVVVVVVVVHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH
Aonde:
LLL      - C�digo do lan�amento padr�o            : 001 - 003 (03)
DDMMYYYY - Data no formato DD/MM/YYYY             : 004 - 011 (08)
T        - Tipo do lan�amento cont�bil (DC)       : 012 - 012 (01)
DDD      - Conta � debito do lan�amento cont�bil  : 013 - 032 (20)
CCC      - Conta � cr�dito do lan�amento cont�bil : 033 - 052 (20)
VVV      - Valor do lan�amento cont�bil           : 053 - 072 (20)
HHH      - Hist�tico do lan�amento contabil       : 073 - 112 (40)

2o. O tamanho de linha a ser configurado para correta leitura deste arquivo ser� 114 (�ltima posi��o de informa��o (112) + 2 caracteres de final de linha.

3o. Uso do LerData(x,y):
A. LerData(4,8) --> Alterar� a data do sistema para o conte�do dispon�vel na linha no formato DDMMYYYY.

/*

// 17/08/2009 -- Filial com mais de 2 caracteres

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � CTBA500  � Autor � Pilar S. Albaladejo   � Data � 29/01/02 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Programa de Lan�amentos Cont�beis Off-Line TXT             ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � CTBA500()                                                  ���
�������������������������������������������������������������������������Ĵ��
���Uso       � SIGACTB                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function LS_CTBA500()

Local aSays 	:= {}
Local aButtons	:= {}
Local dDataSalv := dDataBase
Local nOpca 	:= 0

Private cCadastro := "Contabiliza��o de Arquivos TXT"
Private lAtureg:= .T.        

//Ponto de entrada provisorio ate corre��o do Remote. BOPS 00000138556
If ExistBlock("CT500REG")
	lAtureg:=ExecBlock("CT500REG",.F.,.F.)
EndIf

//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                         �
//� mv_par01 // Mostra Lan�amentos Cont�beis                     �
//� mv_par02 // Aglutina Lan�amentos Cont�beis                   �
//� mv_par03 // Arquivo a ser importado                          �
//� mv_par04 // Numero do Lote                                   �
//� mv_par05 // Quebra Linha em Doc.							 �
//� mv_par06 // Tamanho da linha	 							 �
//����������������������������������������������������������������
Pergunte("CTB500",.f.)

AADD(aSays,OemToAnsi( 'O objetivo deste programa � gerar lan�amentos cont�beis' ) )
AADD(aSays,OemToAnsi( 'a partir de um arquivo texto.' ) )

AADD(aButtons, { 5,.T.,{|| Pergunte("CTB500",.T. ) } } )
AADD(aButtons, { 1,.T.,{|| nOpca:= 1, If( CTBOk(), FechaBatch(), nOpca:=0 ) }} )
AADD(aButtons, { 2,.T.,{|| FechaBatch() }} )

FormBatch( cCadastro, aSays, aButtons )
	
IF nOpca == 1
	mv_par03 := alltrim(mv_par03)
	_cArq := 
	FT_FUSE(mv_par03)
	FT_FGotop()
	Do	While ( !FT_FEof() )
			
		nHdlLock := MsFCreate()
		Do While 
			_cLinha  := alltrim(FT_FREADLN())

			FT_FSkip()
		EndDO
		fClose()
	
	EndDo
	FT_FUse()
	
	
	If FindFunction("CTBSERIALI")
		While !CTBSerialI("CTBPROC","ON")
		EndDo
	EndIf
	Processa({|lEnd| Ctb500Proc()})
	If FindFunction("CTBSERIALI")
		CTBSerialF("CTBPROC","ON")
	EndIf
Endif

dDataBase := dDataSalv

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �CTB500Proc� Autor � Pilar S. Albaladejo   � Data � 29.01.02 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Processamento do lancamento contabil TXT                   ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � CTB500Proc()                                               ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function Ctb500Proc()

Local cLote		:= CriaVar("CT2_LOTE")
Local cArquivo
Local cPadrao
Local lHead		:= .F.					// Ja montou o cabecalho?
Local lPadrao
Local lAglut
Local nTotal	:=0
Local nHdlPrv	:=0
Local nBytes	:=0
Local nHdlImp
Local nTamArq
Local nTamLinha := Iif(Empty(mv_par06),512,mv_par06)

PRIVATE xBuffer	:=Space(nTamLinha)
Private aRotina := {	{ "","" , 0 , 1},;
						{ "","" , 0 , 2 },;
						{ "","" , 0 , 3 },;
						{ "","" , 0 , 4 } }
Private Inclui := .T.							

If Empty(mv_par03)
	Help(" ",1,"NOFLEIMPOR")
	Return
End	

nHdlImp:=FOpen(Mv_Par03,64)
If nHdlImp == -1
	Help(" ",1,"NOFLEIMPOR")
	Return
Endif

//��������������������������������������������������������������Ŀ
//� Verifica o N�mero do Lote                                    �
//����������������������������������������������������������������
cLote := mv_par04
If Empty(cLote)
	Help(" ",1,"NOCT210LOT")
	Return
	
EndIf	

nTamArq:=FSeek(nHdlImp,0,2)
FSeek(nHdlImp,0,0)
ProcRegua(nTamArq)

While nBytes < nTamArq
   If lAtureg
		IncProc()
	endIf	
	xBuffer	:= Space(nTamLinha)
	FREAD(nHdlImp,@xBuffer,nTamLinha)

	cPadrao	:= SubStr(xBuffer,1,3)
	lPadrao	:= VerPadrao(cPadrao)
	IF lPadrao
		IF !lHead
			lHead := .T.
			nHdlPrv:=HeadProva(cLote,"CTBA500",Substr(cUsuario,7,6),@cArquivo)
		End
		nTotal += DetProva(nHdlPrv,cPadrao,"CTBA500",cLote)
		If mv_par05 == 1			// Cada linha contabilizada sera um documento
			RodaProva(nHdlPrv,nTotal)
						
			If ExistBlock("CT500PRV")
				ExecBlock("CT500PRV",.F.,.F.,{nTotal})
			Endif
						
			//�����������������������������������������������������Ŀ
			//� Envia para Lan�amento Cont�bil                      �
			//�������������������������������������������������������
			lDigita	:=IIF(mv_par01==1,.T.,.F.)
			lAglut 	:=IIF(mv_par02==1,.T.,.F.)
			cA100Incl(cArquivo,nHdlPrv,3,cLote,lDigita,lAglut)
			lHead	:= .F.     
			If ExistBlock("CT500ARQ")     
				ExecBlock("CT500ARQ",.F.,.F.)
			Endif
		
		EndIf
	EndIf
	nBytes+=nTamLinha
EndDo

FClose(nHdlImp)
//�����������������������������������������������������Ŀ
//� Grava Rodape                                        �
//�������������������������������������������������������
If lHead
	RodaProva(nHdlPrv,nTotal)

	If ExistBlock("CT500PRV")
		ExecBlock("CT500PRV",.F.,.F.,{nTotal})
	Endif

	//�����������������������������������������������������Ŀ
	//� Envia para Lan�amento Cont�bil                      �
	//�������������������������������������������������������
	lDigita := IIF(mv_par01==1,.T.,.F.)
	lAglut  := IIF(mv_par02==1,.T.,.F.)
	cA100Incl(cArquivo,nHdlPrv,3,cLote,lDigita,lAglut)
Endif

Return

/*
1o. Estrutura da linha do arquivo TXT analisado:LLLDDMMYYYYTDDDDDDDDDDDDDDDDDDDDCCCCCCCCCCCCCCCCCCCCVVVVVVVVVVVVVVVVVVVVHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH
Aonde:
LLL      - C�digo do lan�amento padr�o            : 001 - 003 (03)
DDMMYYYY - Data no formato DD/MM/YYYY             : 004 - 011 (08)
T        - Tipo do lan�amento cont�bil (DC)       : 012 - 012 (01)
DDD      - Conta � debito do lan�amento cont�bil  : 013 - 032 (20)
CCC      - Conta � cr�dito do lan�amento cont�bil : 033 - 052 (20)
VVV      - Valor do lan�amento cont�bil           : 053 - 072 (20)
HHH      - Hist�tico do lan�amento contabil       : 073 - 112 (40)

2o. O tamanho de linha a ser configurado para correta leitura deste arquivo ser� 114 (�ltima posi��o de informa��o (112) + 2 caracteres de final de linha.

3o. Uso do LerData(x,y):
A. LerData(4,8) --> Alterar� a data do sistema para o conte�do dispon�vel na linha no formato DDMMYYYY.

*/

User Function ALTDATAL()
_dData := dDataLanc

Return(_dData)




