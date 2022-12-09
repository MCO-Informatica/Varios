#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CTSA014   �Autor  �David de Olvieira   � Data �  14/07/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �Compensa�ao de Titulos NCC com os demais Titulos 			 ���
���          �relacionados                                                ���
�������������������������������������������������������������������������͹��
���Uso       � Certisign                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function CTSA014()

Local nHandle	:= -1
Local cFile		:= ""
Local cUFEmp	:= SM0->M0_ESTCOB
Local oDlg											// Dialog para escolha da Lista
Local nOpc		:= 0								// 1 = Ok, 2 = Cancela
Local dEmissDe	:= dDataBase
Local dEmissAt	:= dDataBase
Local cCliDe	:= Space(TamSx3("A1_COD")[1])
Local cCliAt	:= Space(TamSx3("A1_COD")[1])

PRIVATE aTitulos	:={}
PRIVATE aRecNo 		:= {}
PRIVATE aRegSE1 	:= {}
PRIVATE aBaixaSE5 	:= {}
PRIVATE	cPrefixo 	:= SE1->E1_PREFIXO
PRIVATE	cNum		:= SE1->E1_NUM
PRIVATE	cTipoTit 	:= SE1->E1_TIPO
PRIVATE	cCliente 	:= SE1->E1_CLIENTE
PRIVATE	cLoja 		:= SE1->E1_LOJA
PRIVATE	cSaldo		:= CriaVar("E1_SALDO")
PRIVATE	nValor		:= CriaVar("E1_SALDO")
PRIVATE	cParcela 	:= SE1->E1_PARCELA
PRIVATE	nMoeda		:= SE1->E1_MOEDA
PRIVATE	dBaixa		:= Date()
PRIVATE	nValTot		:= 0
PRIVATE	nSeqBx 		:= 0
PRIVATE	nPosSaldo	:=0
PRIVATE	nPosValor	:=0
PRIVATE	cBanco		:= Criavar("E1_PORTADO")
Private lCredito 	:= .F.
Private nPosATit 	:= 0
Private aRLocks		:= {}
Private cLote		:= ""
Private nRecAtu		:= 0
Private lTitCompB	:= .T.
Private lMsErroAuto := .F.
Private lMsHelpAuto := .F.

DEFINE MSDIALOG oDlg FROM  000,000 TO 165,550 TITLE "Compensa��o financeira NCC" PIXEL

@ 010,010 SAY "Este programa ir� realizar a compensa��o financeira dos t�tulos tipo NCC em abeto com respectivos Titulos." OF oDlg PIXEL

@ 025,10 SAY "Cliente De" OF oDlg PIXEL
@ 025,70 MSGET cCliDe SIZE 40,5 F3 "CLI" OF oDlg PIXEL 

@ 025,120 SAY "Cliente At�" OF oDlg PIXEL
@ 025,180 MSGET cCliAt SIZE 40,5 F3 "CLI" OF oDlg PIXEL 

@ 040,10 SAY "Emiss�o De" OF oDlg PIXEL
@ 040,70 MSGET dEmissDe SIZE 40,5 OF oDlg PIXEL VALID !Empty(dEmissDe)

@ 040,120 SAY "Emiss�o At�" OF oDlg PIXEL
@ 040,180 MSGET dEmissAt SIZE 40,5 OF oDlg PIXEL VALID !Empty(dEmissAt)

@ 060,060 BUTTON "OK"		SIZE 40,13 OF oDlg PIXEL ACTION (nOpc := 1,oDlg:End())
@ 060,230 BUTTON "Cancel"	SIZE 40,13 OF oDlg PIXEL ACTION (nOpc := 2,oDlg:End())

ACTIVATE MSDIALOG oDlg CENTERED

If !nOpc == 1 .or. !Pergunte("FIN330",.T.)
	Return(.F.)
EndIf

cFile := cGetFile("\", "Diret�rios", 1,"X:\" ,.F. , GETF_RETDIRECTORY+GETF_LOCALHARD )
cFile +="CTSA014.LOG"

// Comeca o processamento de alteracao dos pedidos
If !File(cFile)
	nHandle := FCREATE(cFile,1)
Else
	While FERASE(cFile)==-1
	End
	nHandle := FCREATE(cFile,1)
Endif

Processa( { || CT014Fin(nHandle,cCliDe,cCliAt,dEmissDe,dEmissAt) } )

FClose(nHandle)

MsgStop("Rotina conclu�da com sucesso."+CRLF+"Verifique log de processamento em "+cFile )

Return(.T.)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GARA151   �Autor  �David de Oliveira   � Data �  14/07/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Certisign                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function CT014Fin(nHandle,cCliDe,cCliAt,dEmissDe,dEmissAt)

Local aRet		:= {}
Local cQuery	:= ""
Local nRecAux	:= 0
Local cChavSE1 	:= ""
Local nValorSE1	:= 0
Local nRecNCC	:= 0
Local nRecE1Atu := 0

cQuery	:=	" SELECT "
cQuery	+=	" 	SE1B.RECE1NCC, SE1B.SALDONCC, SE1A.R_E_C_N_O_ RECE1COMP, SUM(SE1A.E1_SALDO) SALDOCOMP "
cQuery	+=	" FROM "
cQuery	+=	" 	"+RetSqlName("SE1")+" SE1A INNER JOIN	( "
cQuery	+=	" 								SELECT "
cQuery	+=	" 									E1_CLIENTE, "
cQuery	+=	" 									E1_LOJA, "
cQuery	+=	" 									D1_SERIORI, "
cQuery	+=	" 									D1_NFORI, "
cQuery	+=	" 									SE1.R_E_C_N_O_ RECE1NCC, "
cQuery	+=	" 									E1_SALDO SALDONCC "
cQuery	+=	" 								FROM "
cQuery	+=	" 									"+RetSqlName("SE1")+" SE1 INNER JOIN "+RetSqlName("SD1")+" SD1 ON "
cQuery	+=	" 									E1_SERIE = D1_SERIE AND "
cQuery	+=	" 									E1_NUM = D1_DOC AND "
cQuery	+=	" 									E1_CLIENTE = D1_FORNECE AND "
cQuery	+=	" 									E1_LOJA = D1_LOJA "
cQuery	+=	" 								WHERE "
cQuery	+=	" 									E1_FILIAL = '"+xFilial("SE1")+"' AND "
cQuery	+=	" 									E1_CLIENTE BETWEEN '"+cCliDe+"' AND '"+cCliAt+"' AND "
cQuery	+=	" 									E1_EMISSAO BETWEEN '"+DtoS(dEmissDe)+"' AND '"+DtoS(dEmissAt)+"' AND "
cQuery	+=	" 									E1_TIPO = 'NCC'AND "
cQuery	+=	" 									E1_ORIGEM='MATA100' AND "
cQuery	+=	" 									E1_SALDO > 0 AND "
cQuery	+=	" 									SE1.D_E_L_E_T_ = ' ' AND "
cQuery	+=	" 									D1_FILIAL = '"+xFilial("SD1")+"' AND "
cQuery	+=	" 									SD1.D_E_L_E_T_ = ' ' "
cQuery	+=	" 								GROUP BY "
cQuery	+=	" 									E1_CLIENTE, "
cQuery	+=	" 									E1_LOJA, "
cQuery	+=	" 									D1_SERIORI, "
cQuery	+=	" 									D1_NFORI, "
cQuery	+=	" 									SE1.R_E_C_N_O_, "
cQuery	+=	" 									E1_SALDO "
cQuery	+=	" 							) SE1B ON "
cQuery	+=	" 	SE1A.E1_NUM = SE1B.D1_NFORI AND "
cQuery	+=	" 	SE1A.E1_SERIE = SE1B.D1_SERIORI AND "
cQuery	+=	" 	SE1A.E1_CLIENTE = SE1B.E1_CLIENTE AND "
cQuery	+=	" 	SE1A.E1_LOJA = SE1B.E1_LOJA "
cQuery	+=	" WHERE "
cQuery	+=	" 	SE1A.E1_FILIAL = '"+xFilial("SE1")+"' AND "
cQuery	+=	" 	SE1A.E1_TIPO <> 'NCC' AND "
//cQuery	+=	" 	SE1A.E1_SALDO > 0 AND " 
cQuery	+=	" 	SE1A.D_E_L_E_T_ = ' ' "
cQuery	+=	" GROUP BY "
cQuery	+=	" 	SE1B.RECE1NCC, "
cQuery	+=	" 	SE1B.SALDONCC, "
cQuery	+=	" 	SE1A.R_E_C_N_O_ "
cQuery	+=	" ORDER BY "
cQuery	+=	" 	SE1B.RECE1NCC, SE1A.R_E_C_N_O_	"

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"SE1TMP",.F.,.T.)	

TcSetField("SE1TMP", "SALDONCC", "N", TamSx3("E1_SALDO")[1], TamSx3("E1_SALDO")[2])
TcSetField("SE1TMP", "SALDOCOMP", "N", TamSx3("E1_SALDO")[1], TamSx3("E1_SALDO")[2])

ProcRegua( SE1TMP->( RecCount() ) )
SE1TMP->( DbGoTop() )   

If SE1TMP->( Eof() )
	FWrite(nHandle, "N�o foram encontrados Dados para Processamento" + CRLF )
	Return(.F.)
EndIf

nRecAtu++

While SE1TMP->( !Eof() )

	Incproc( "Compensando t�tulos "+AllTrim(Str(nRecAtu)) )
	ProcessMessage()
	
	SE1->( DbGoTo(SE1TMP->RECE1NCC) )
	nRecNCC		:= SE1TMP->RECE1NCC
	cChavSE1 	:= SE1->(E1_PREFIXO+E1_NUM+E1_TIPO+E1_PARCELA)
	nValorSE1	:= SE1->E1_VALOR
	lRetComp	:= FA330Comp()
	If lRetComp 
		FWrite(nHandle, " ->Titulo "+cChavSE1+"  valor "+TransForm(nValorSE1,"@E 999,999,999.99")+" compensado com os titulos abaixo" + CRLF )
	Else
		FWrite(nHandle, " ->Titulo "+cChavSE1+"  valor "+TransForm(nValorSE1,"@E 999,999,999.99")+" n�o compensado com os titulos abaixo" + CRLF )
	EndIf
	
	If Len(aRecno) > 0
		aEval(aRecno,{|x| SE1->(DbGoto(x)) , FWrite(nHandle, "		*>Titulo  "+SE1->(E1_PREFIXO+E1_NUM+E1_TIPO+E1_PARCELA)+"  valor "+TransForm(SE1->E1_VALOR,"@E 999,999,999.99") + " Saldo "+ TransForm(SE1->E1_SALDO,"@E 999,999,999.99")  + CRLF ) })
	EnDiF	
	
	If !lTitCompB
		nRecE1Atu := SE1->( RecNo() )
		SE1->( DbGoTo(nRecNCC) )		
		CTS014baix(SE1->E1_SALDO)
		
		If !lMsErroAuto  
			FWrite(nHandle, " ->Titulo "+cChavSE1+"  valor "+TransForm(nValorSE1,"@E 999,999,999.99")+" Baixado Por Da��o" + CRLF )
		Else
			FWrite(nHandle, " ->Titulo "+cChavSE1+"  valor "+TransForm(nValorSE1,"@E 999,999,999.99")+" n�o foi possivel Baixa-lo por Da��o" + CRLF )
		EndIF
		
	EndIf   
	
	FWrite(nHandle, CRLF )
End
SE1TMP->( DbCloseArea() )

Return(.T.)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 � Fa330Comp� Autor � Mauricio Pequim Jr.   � Data � 18/04/94 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Marca��o dos titulos para compensa��o					  ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe	 � Fa330Comp() 												  ���
�������������������������������������������������������������������������Ĵ��
��� Uso		 � Gen�rico 												  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function fA330Comp(cAlias,cCampo,nOpcE,oDlgPae,cLoteFat,cOrigem,aNumLay)
//�������������������������������Ŀ
//� Define Vari�veis 				 �
//���������������������������������
Local lPanelFin := If (FindFunction("IsPanelFin"),IsPanelFin(),.F.)
Local nTotal		:= 0
Local nHdlPrv		:= 0
Local nValorComp	:= 0
Local nSeq			:= 0
Local nValBX		:= 0			// Valor da baixa na moeda 1
Local nValBX2		:= 0			// Valor da baixa na moeda do tit principal
Local nX
Local cAdiantamento
Local cDadosTitulo
Local cArquivo
Local cPadrao	:= "596"
Local lContabil	:= .F.
Local lPadrao
Local lDigita
Local dEmissao	:= SE1->E1_EMISSAO
Local lMarcado	:= .F.
Local aBaixas	:= {}
Local nTotAbat	:= 0
Local nTotAbtIni	:= 0		//Abatimento do titulo de Partida
Local nTitIni	:= SE1->(Recno())
Local nDecs		:= 2
Local nSalTit	:= 0
Local nDecs1	:= MsDecimais(1)
Local cVarQ		:= "  "
Local lFa330Cmp	:= ExistBlock( "FA330CMP" )
Local nSldReal	:= 0
Local nLinha	:= 0
Local nTit		:= 0
Local nA		:= 0
Local cKeyAbt	:= ""
Local nSe1Rec	:= 0
Local nAcresc	:= 0
Local nDecres	:= 0
Local nIndexAtu	:= SE1->(IndexOrd())
Local nVlrCompe // Criadaa para exibir o conteudo do Help correto quando o usuario
// pressionar F1 sobre o campo
Local lDeleted	:= .F.
Local lfa330Bx	:= Existblock("FA330BX")
Local aArea		:={}
Local lVldDtFin	:= .T.
Local aDiario	:= {}
Local nTotComp	:= 0
Local nValComp	:= 0
Local nRecNcc	:= 0
Local nSldNcc	:= 0

Default cOrigem :=""
DEFAULT aNumLay := {}

aTitulos	:={}
aRecNo 		:= {}
aRegSE1 	:= {}
aBaixaSE5 	:= {}
cPrefixo 	:= SE1->E1_PREFIXO
cNum		:= SE1->E1_NUM
cTipoTit 	:= SE1->E1_TIPO
cCliente 	:= SE1->E1_CLIENTE
cLoja 		:= SE1->E1_LOJA
cSaldo		:= CriaVar("E1_SALDO")
nValor		:= CriaVar("E1_SALDO")
cParcela 	:= SE1->E1_PARCELA
nMoeda		:= SE1->E1_MOEDA
dBaixa		:= Date()
nValTot		:= 0
nSeqBx 		:= 0
nPosSaldo	:=0
nPosValor	:=0
cBanco		:= Criavar("E1_PORTADO")
lCredito 	:= .F.
nPosATit 	:= 0
aRLocks		:= {}
cLote		:= ""
nRecAtu		:= 0

nVlrCompe	:= nValor

If SE1->E1_TIPO $ MVRECANT+"/"+MV_CRNEG .or. cOrigem =="MATA465"
	lCredito := .T.
Endif

If !FA330Lock(,SE1->(Recno()))
	Return(.F.)
Endif

aArea:=GetArea()

//������������������������������������������������������������������Ŀ
//� Se vier do mata465 ou da LOCXNF, forca os valores dos parametros �
//��������������������������������������������������������������������
Pergunte("FIN330",.F.)
MV_PAR01 := 1 				// Considera Loja  Sim/Nao
MV_PAR02 := 1 				// Considera Cliente Original/Outros
MV_PAR03 :=	SE1->E1_CLIENTE // Do Cliente
MV_PAR04 :=	SE1->E1_CLIENTE // Ate Cliente
MV_PAR05 := 2				// Compensa Titulos Transferidos S/[N]
MV_PAR06 := 2				// Calcula Comissao sobre valores de NCC
MV_PAR07 := 2				// Mostra Lancto Contabil
MV_PAR08 := 2				//Considera abatimentos para compensar
MV_PAR09 := 2				// Contabiliza On-Line
MV_PAR10 := 2				//Considera Filiais abaixo
MV_PAR11 := "  " 			//Filial De
MV_PAR12 := "zz"			//Filial Ate
MV_PAR13 := 2				// Calcula Comissao sobre valores de RA
MV_PAR14 := 2				// Reutiliza taxas informadas

RestArea(aArea)

If ExistBlock("F330DTFIN")
	lVldDtFin := ExecBlock("F330DTFIN",.F.,.F.)
EndIf
//��������������������������������������������������������������Ŀ
//� Verifica se data do movimento n�o � menor que data limite de �
//� movimentacao no financeiro    										  �
//����������������������������������������������������������������
If lVldDtFin .and. !DtMovFin()
	Return(.F.)
Endif
//�����������������������������������������������������������Ŀ
//� N�o permite que t�tulos j� baixados possam ser acessados. �
//�������������������������������������������������������������
If SE1->E1_SALDO == 0
//	Help(" ",1,"FA330JABAI")
	Return (.F.)
Endif
//������������������������������������������������������������������������Ŀ
//� Titulos provisorios nao sao compensaveis como titulo principal.        �
//��������������������������������������������������������������������������
If cTipoTit $ MVPROVIS
	// Help(" ",1,"NOCMPPROV",,STR0042+chr(13)+STR0043,1,0 )   //"Nao � permitida a compensacao a partir de"###"um titulo provisorio"
	//��������������������������������������Ŀ
	//� Recupera a Integridade dos dados     �
	//����������������������������������������
	dbSelectArea("SE1")
	dbSetOrder(nIndexAtu)
	DeleteObject(oOk)
	DeleteObject(oNo)
	FA330aUnlock()
	Return (.F.)
Endif

//�����������������������������Ŀ
//� Estrutura aTxMoedas         �
//� [1] -> Nome Moeda          	�
//� [2] -> Taxa a Ser Utilizada	�
//� [3] -> Picture          	�
//� [4] -> Taxa do dia atual    �
//�������������������������������
If Type("aTxMoedas") <> "A"  .Or. MV_PAR14 == 2
	aTxMoedas:={}
EndIf

If Len(aTxMoedas) == 0
	Aadd(aTxMoedas,{"",1,PesqPict("SM2","M2_MOEDA1"),1})
	
	For nA := 2	To MoedFin()
		cMoedaTx :=	Str(nA,IIf(nA <= 9,1,2))
		If !Empty(GetMv("MV_MOEDA"+cMoedaTx))
			nVlMoeda := RecMoeda(Date(),nA)
			Aadd(aTxMoedas,{GetMv("MV_MOEDA"+cMoedaTx),nVlMoeda,PesqPict("SM2","M2_MOEDA"+cMoedaTx),nVlMoeda })
		Else
			Exit
		Endif
	Next
EndIf

//�����������������������������������������������������������Ŀ
//� Inicializa a gravacao dos lancamentos do SIGAPCO          �
//�������������������������������������������������������������
PcoIniLan("000016")

While .T.
	//����������������������������������Ŀ
	//� Titulo a ser compensado			 �
	//������������������������������������
	nOpca  :=0
	nTotAbtIni := SumAbatRec(cPrefixo,cNum,cParcela,SE1->E1_MOEDA,"S",dBaixa)
	If mv_par08 == 1
		nSaldo := (SE1->E1_SALDO - nTotAbtIni + SE1->E1_SDACRES - SE1->E1_SDDECRE)
	ELSE
		nSaldo := SE1->E1_SALDO + SE1->E1_SDACRES - SE1->E1_SDDECRE
	Endif
	nRecno := SE1->(Recno())
	
	cDadostitulo := SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO
	
	cPrefixo	:= SE1->E1_PREFIXO
	cNum		:= SE1->E1_NUM
	cParcela	:= SE1->E1_PARCELA
	cTipoTit	:= SE1->E1_TIPO
	cCliente	:= SE1->E1_CLIENTE
	cLoja		:= SE1->E1_LOJA
	nVlrCompe	:= SE1->E1_SALDO
	cPedgar		:= SE1->E1_PEDGAR
	dBaixa		:= Date()	
	
	nValor		:= nVlrCompe
	nRecNcc		:= SE1TMP->RECE1NCC
	nSldNcc		:= SE1TMP->SALDONCC
	

	While SE1TMP->( !Eof() ) .and. SE1TMP->RECE1NCC == nRecNcc
		
		SE1->(DbGoTo(SE1TMP->RECE1COMP))
		nValComp := SE1->E1_SALDO
		
		aAdd( aTitulos, {	SE1->E1_PREFIXO,;
							SE1->E1_NUM,;
							SE1->E1_PARCELA,;
							SE1->E1_TIPO,;
							SE1->E1_LOJA,;
							Transform(xMoeda(SE1->E1_SALDO+SE1->E1_SDACRES-SE1->E1_SDDECRE- Iif(  Type("nTotAbat") <> "N" ,0,nTotAbat),SE1->E1_MOEDA,nMoeda,,5,Fa340TxMd(SE1->E1_MOEDA,0),Fa340TxMd(nMoeda,0)),"@E 9999,999,999.99"),;
							Transform(nValComp,"@E 9999,999,999.99"),;
							.T.,;
							nValComp,;
							Transform(xMoeda(SE1->E1_SDACRES,SE1->E1_MOEDA,nMoeda,,5,Fa340TxMd(SE1->E1_MOEDA,0),Fa340TxMd(nMoeda,0)),"@E 9999,999,999.99"),;
							Transform(xMoeda(SE1->E1_SDDECRE,SE1->E1_MOEDA,nMoeda,,5,Fa340TxMd(SE1->E1_MOEDA,0),Fa340TxMd(nMoeda,0)),"@E 9999,999,999.99"),;
							SE1->E1_HIST,; 
							SE1->E1_FILIAL} )
		aAdd( aRecNo, SE1->(RecNo()) )
		
		nTotComp += nValComp
		
		SE1TMP->( DbSkip() )
		nRecAtu++
	End

	lTitCompB	:= Iif( nTotComp == 0, .F., .T.)
	
	If nValor == 0 .OR. nSldNcc <> nTotComp
		Return(.F.)
	Endif
	
	If Len(aTitulos) == 0
		//���������������������������������������Ŀ
		//� Recupera a Integridade dos dados	  �
		//�����������������������������������������
		dbSelectArea("SE1")
		dbSetOrder(nIndexAtu)
		dbGoTo(nTitIni)
		
		FA330aUnlock()
		
		Return(.F.)
	Endif
	
	nOpcA := 1
	If nOpcA == 1
		If lFa330Cmp
			ExecBlock("FA330Cmp",.F.,.F.)
		Endif
		nValTot := 0
		For nX:=1 to Len(aTitulos)
			If aTitulos[nX,8]
				nValtot+=Fa330VTit(aTitulos[nX,7])
			Endif
		Next
		//���������������������������������������������������������Ŀ
		//� Verifica se o Vlr. Informado e'igual ao calculado.      �
		//�����������������������������������������������������������
		If Str(nValtot,17,2) != Str(nValor,17,2) .and. nValor != 0;
			.and. nOpca == 1
			// Help(" ",1,"FA330COMP")
			Return(.F.)
		Endif
		//���������������������������������������������������������Ŀ
		//� Verifica se o Vlr. Informado e'compativel com o Saldo.  �
		//�����������������������������������������������������������
		nValor := nValTot
		If Str(nValor,17,2) > Str(nSaldo,17,2)
			// Help(" ",1,"FA330IVAL")
			Return(.F.)
		EndIf
		DbSelectArea("SE1")
		nOrdSE1	:= IndexOrd()
		dbGotop()
		lPadrao:=VerPadrao(cPadrao)
		VALOR := 0
		ABATIMENTO := 0
		aRegSE1 := {}
		aBaixaSE5 := {}
		//�����������������������������������������������������Ŀ
		//� Inicio da prote��o via TTS								  �
		//�������������������������������������������������������
		Begin Transaction
		For nTit := 1 to Len(aTitulos)
			nPosATit := nTit  // Variavel de posicao do titulo no array
			If aTitulos[nTit,8]
				lMarcado := .T.
			Endif
			//���������������������������������������������������������Ŀ
			//� Caso o titulo esteja selecionado para compensa��o...    �
			//�����������������������������������������������������������
			IF lMarcado
				lMarcado := .F.
				IF lPadrao .and. !lContabil .and. mv_par09 == 1
					nTotal := 0
					lContabil := .t.
					nHdlPrv:=HeadProva(cLote,"FINA330",Substr(cUsuario,7,6),@cArquivo)
				Endif
				dbSelectArea("SE1")
				dbGoTo(aRecNo[nTit])
				aAdd(aRegSE1, aRecNo[nTit])
				cAdiantamento := E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+E1_LOJA
				If (SE1->E1_TIPO == MV_CRNEG) .and. (SE1->E1_SALDO > aTitulos[nTit,9]) .AND. ((aTitulos[nTit,9]+nTotAbtIni) == F330SldPri(nRecNo))
					aTitulos[nTit,9] := aTitulos[nTit,9] + nTotAbtIni
				EndIf
				//��������������������������������������������������Ŀ
				//� Valor da baixa na moeda 1 							  �
				//����������������������������������������������������
				If cPaisLoc == "BRA"
					nValBx := aTitulos[nTit,9]
					If mv_par02 == 1
						nAcresc := Fa330VTit(aTitulos[nTit,10])
						nDecres := Fa330VTit(aTitulos[nTit,11])
					Else
						nAcresc := Fa330VTit(aTitulos[nTit,13])
						nDecres := Fa330VTit(aTitulos[nTit,14])
					Endif
				Else
					nValBx := Fa330VTit(aTitulos[nTit,7])
					If mv_par02 == 1
						nAcresc := Fa330VTit(aTitulos[nTit,11])
						nDecres := Fa330VTit(aTitulos[nTit,12])
					Else
						nAcresc := Fa330VTit(aTitulos[nTit,13])
						nDecres := Fa330VTit(aTitulos[nTit,14])
					Endif
				Endif
				IF lPadrao
					If cPaisLoc == "BRA"
						nValorComp += Round(NoRound(xMoeda(nValBX,nMoeda,1,,3,Fa340TxMd(nMoeda,0)),3),2)
					Else
						nValorComp += xMoeda(nValBX,nMoeda,1,aTitulos[nTit,10],,aTxMoedas[aTitulos[nTit,9]][2])
					EndIf
				EndIf
				dbSelectArea("SE1")
				dbGoTo(nRecNo)
				//��������������������������������������������������Ŀ
				//� Guardo dados do titulo principal para utilizar   �
				//� no historico da contabiliza��o                   �
				//����������������������������������������������������
				STRLCTPAD := SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO
				
				//��������������������������������������������������Ŀ
				//� Valor da Baixa na moeda do titulo principal 	  �
				//����������������������������������������������������
				If cPaisLoc == "BRA"
					nValBx2 := aTitulos[nTit,9]
					If mv_par02 == 1
						nAcresc := Fa330VTit(aTitulos[nTit,10])
						nDecres := Fa330VTit(aTitulos[nTit,11])
					Else
						nAcresc := Fa330VTit(aTitulos[nTit,13])
						nDecres := Fa330VTit(aTitulos[nTit,14])
					Endif
				Else
					nValBx2 := Fa330VTit(aTitulos[nTit,7])
					If mv_par02 == 1
						nAcresc := Fa330VTit(aTitulos[nTit,11])
						nDecres := Fa330VTit(aTitulos[nTit,12])
					Else
						nAcresc := Fa330VTit(aTitulos[nTit,13])
						nDecres := Fa330VTit(aTitulos[nTit,14])
					Endif
				Endif
				
				Fa330Grv(lPadrao,nValBx2,cAdiantamento,StrZero(nSeq,2),aRecno[nTit],@aBaixas,cOrigem,lCredito,mv_par09,nAcresc,nDecres,aBaixaSE5,nTotAbtIni)
				
				aEval(aBaixaSE5,{|x| SE5->(DbGoTo(x)),RecLock("SE5",.F.), SE5->E5_HISTOR:= "(Comp. Rot. CTSA014)"+SE5->E5_HISTOR, SE5->(MsUnlock())})
				
				//��������������������������������������������������Ŀ
				//� Posiciona no adiantamento para contabiliza��o    �
				//����������������������������������������������������
				dbSelectArea("SE1")
				dbGoTo(aRecNo[nTit])
				If lCredito .and. mv_par08 == 1
					nTotAbat := SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",SE1->E1_MOEDA,,SE1->E1_CLIENTE)
				Else
					nTotAbat := 0
				Endif
				//����������������������������������Ŀ
				//� Acerta o saldo do adiantamento	 �
				//������������������������������������
				Reclock("SE1")
				If cPaisLoc == "BRA"
					If nValBx == Fa330VTit(aTitulos[nTit,6])
						SE1->E1_SALDO := 0
						SE1->E1_SDACRES := 0
						SE1->E1_SDDECRE := 0
					Else
						SE1->E1_SALDO	-= Round(Noround(xMoeda(nValBx-nAcresc+nDecres,nMoeda,SE1->E1_MOEDA,,3,Fa340TxMd(nMoeda,0),Fa340TxMd(SE1->E1_MOEDA,0)),3),2)
						SE1->E1_SDACRES	-= Round(Noround(xMoeda(nAcresc               ,nMoeda,SE1->E1_MOEDA,,3,Fa340TxMd(nMoeda,0),Fa340TxMd(SE1->E1_MOEDA,0)),3),2)
						SE1->E1_SDDECRE	-= Round(Noround(xMoeda(nDecres               ,nMoeda,SE1->E1_MOEDA,,3,Fa340TxMd(nMoeda,0),Fa340TxMd(SE1->E1_MOEDA,0)),3),2)
					Endif
					SE1->E1_VALLIQ := nValBx
					If STR(SE1->E1_SALDO,17,2) == STR(nTotAbat,17,2)
						SE1->E1_SALDO := 0
					Endif
					SE1->E1_MOVIMEN:= Date()
				Else
					If nValBx == Fa330VTit(aTitulos[nTit,6])
						SE1->E1_SALDO := 0
						SE1->E1_SDACRES := 0
						SE1->E1_SDDECRE := 0
					Else
						nDecs := MsDecimais(SE1->E1_MOEDA)
						nSalTit := SE1->E1_SALDO - Round(xMoeda(nValBx-nAcresc+nDecres,nMoeda,SE1->E1_MOEDA,Date(),nDecs+1,aTxMoedas[nMoeda][2],aTxMoedas[SE1->E1_MOEDA][2]),nDecs)
						SE1->E1_SALDO   := Iif(nSalTit <= 0,0,nSalTit)
					EndIf
					SE1->E1_MOVIMEN := Date()
					SE1->E1_VALLIQ  += Round(xMoeda(nValBx-nAcresc+nDecres,nMoeda,1,Date(),nDecs1+1,aTxMoedas[nMoeda][2]),nDecs1)
				EndIf
				SE1->E1_BAIXA := dBaixa
				SE1->E1_STATUS:= IIF(SE1->E1_STATUS != "R",Iif(SE1->E1_SALDO > 0.01,"A","B"),"R")
				MsUnlock()
				nSE1Rec := SE1->(Recno())
				cKeyAbt := SE1->(E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA)
				// Efetua a baixa dos titulos de abatimento
				If lCredito .AND. SE1->E1_SALDO - nTotAbat <= 0   //Se nao for titulo de adiantamento
					If Select("__SE1") == 0
						SumAbatRec("","","",1,"")
					Endif
					dbSelectArea("__SE1")
					__SE1->(dbSetOrder(2))
					__SE1->(dbSeek(xFilial("SE1")+cKeyAbt))
					While !EOF() .And. E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA==xFilial("SE1")+cKeyAbt
						IF E1_TIPO $ MVABATIM+"/"+MVIRABT+"/"+MVINABT+"/"+MVPIABT+"/"+;
							MVCFABT+"/"+MVCSABT
							RecLock("__SE1")
							Replace E1_SALDO	  With 0
							Replace E1_BAIXA	  With If(E1_BAIXA <= dBaixa, dBaixa, E1_BAIXA)
							Replace E1_STATUS   With "B"
						EndIF
						dbSkip()
					Enddo
					__SE1->(dbSetOrder(1))
				Endif
				dbSelectArea("SE1")
				dbGoto(nSE1Rec)
				VALOR2 := 0
				VALOR3 := 0
				VALOR4 := 0
				VALOR5 := 0
				VALOR6 := 0
				
				If lCredito
					VALOR2 := SE1->E1_IRRF
					VALOR3 := SE1->E1_PIS
					VALOR4 := SE1->E1_COFINS
					VALOR5 := SE1->E1_CSLL
					VALOR6 := SE1->E1_INSS
				Endif
				
				IF lPadrao .and. mv_par09 == 1
					nTotal+=DetProva(nHdlPrv,cPadrao,"FINA330",cLote)
				Endif
				
				VALOR2 := 0
				VALOR3 := 0
				VALOR4 := 0
				VALOR5 := 0
				VALOR6 := 0
				
				dbSelectArea ("SE1")
				dbSetOrder(1)
				If lfa330Bx
					Execblock("FA330BX",.f.,.f.)
				Endif
			Endif
		Next
		nRegSE5 := SE5->(Recno())
		nRegSE1 := SE1->(Recno())
		/*
		If GetMv("MV_COMISCR") == "S" .and. GetMv("MV_TPCOMIS") == "O"
			dbSelectArea("SE1")
			dbSetOrder(2)
			dbGoto(nRecNo)
			//��������������������������������������������������Ŀ
			//� Verifica se calcula comissao sobre valores       �
			//� de NCC ou RA que compuseram a compenca��o Receb. �
			//����������������������������������������������������
			If mv_par06 == 2 .Or. mv_par13 == 2
				For nLinha:= Len(aBaixas) to 1 Step -1
					lDeleted := .F.
					// Verifica se ha a 5 dimensao na matriz de valores baixados
					If Len(aBaixas[nLinha][1]) >= 5
						If mv_par06 == 2
							If MV_CRNEG $ SubStr(aBaixas[nLinha][1][5],nTamTit+1,nTamTip)
								ADEL(aBaixas,nLinha)
								ASIZE(aBaixas,Len(aBaixas)-1)
								lDeleted := .T.
							Endif
						Endif
						If mv_par13 == 2 .And. !lDeleted
							If MVRECANT $ SubStr(aBaixas[nLinha][1][5],nTamTit+1,nTamTip)
								ADEL(aBaixas,nLinha)
								ASIZE(aBaixas,Len(aBaixas)-1)
							Endif
						Endif
					Endif
				Next
			Endif
			//��������������������������������������������Ŀ
			//� Calcula comissao, se houver vendedor		  �
			//����������������������������������������������
			If Len(aBaixas) > 0
				AeVal(aBaixas,{|x|Fa440CalcB(x,.F.,.F.,"FINA070")})
			EndIf
		Endif
		*/
		
		If lPadrao .and. mv_par09 == 1
			VALOR2 := SE1->E1_IRRF
			VALOR3 := SE1->E1_PIS
			VALOR4 := SE1->E1_COFINS
			VALOR5 := SE1->E1_CSLL
			VALOR6 := SE1->E1_INSS
			
			SE5->(dbGoBottom())
			SE5->(dbSkip())
			SE1->(dbGoBottom())
			SE1->(dbSkip())
			VALOR := nValorComp
			nSldReal := Round(NoRound(xMoeda(nSaldo,nMoeda,1,,3,Fa340TxMd(nMoeda,0)),3),2)
			ABATIMENTO := IIF(STR(nSldReal,17,2) == STR(nValorComp,17,2),nTotAbat,0)
			REGVALOR := nRecno		// Variavel para usu�rio reposicionar o registro do RA
			nTotal+=DetProva(nHdlPrv,cPadrao,"FINA330",cLote)
			RodaProva(nHdlPrv,nTotal)
			
			If cPaisLoc == 'PTG'
				For nX := 1 To Len(aBaixaSE5)
					AAdd(aDiario,{"SE5",aBaixaSE5[nX],cCodDiario,"E5_NODIA","E5_DIACTB"})
				Next nX
			EndIf
			
			//�����������������������������������������������������Ŀ
			//� Envia para Lan�amento Cont�bil							  �
			//�������������������������������������������������������
			lDigita := IIF( mv_par07 == 1,.t., .f. )
			cA100Incl(cArquivo,nHdlPrv,3,cLote,lDigita,.F.,,,,,,aDiario)
			
			VALOR  := 0
			VALOR2 := 0
			VALOR3 := 0
			VALOR4 := 0
			VALOR5 := 0
			VALOR6 := 0
			
		Endif
		SE5->(dbGoTo(nRegSE5))
		SE1->(dbGoTo(nRegSE1))
		
		//integracao com modulo PCO
		Fa330IntPco(nRecno, aRegSE1, aBaixaSE5)
		
		//�����������������������������������������������������Ŀ
		//� Final  da protecao via TTS	                        �
		//�������������������������������������������������������
		End Transaction
		
	Endif
	Exit
EndDo

cPrefixo := CriaVar("E1_PREFIXO")
cNum		:= CriaVar("E1_NUM")
cTipoTit := CriaVar("E1_TIPO")
cCliente := CriaVar("E1_CLIENTE")
cLoja 	:= CriaVar("E1_LOJA")
cSaldo	:= CriaVar("E1_SALDO")
nValor	:= CriaVar("E1_SALDO")
cParcela := CriaVar("E1_PARCELA")
nMoeda	:= 1
nValor	:= 0
nValTot	:= 0

//�����������������������������������������������������������Ŀ
//� Finaliza a gravacao dos lancamentos do SIGAPCO            �
//�������������������������������������������������������������
PcoFinLan("000016")

//���������������������������������������Ŀ
//� Recupera a Integridade dos dados		�
//�����������������������������������������
dbSelectArea("SE1")
dbSetOrder(nIndexAtu)
dbGoTo(nTitIni)

FA330aUnlock()

Return(.T.)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GARA150   �Autor  �Armando M. Tessaroli� Data �  12/08/09   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Certisign                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function FA330Lock(cChave,nRecno,lHelp,cfilOrig)

Local aArea		:= {}
Local lRet		:= .F.                           

DEFAULT lHelp	:=	.F.
   
If nRecno <> Nil             
	SE1->(MsGoto(nRecno))
Else                               
	aArea	:=	getArea()
	SE1->(DbSetOrder(1))
	SE1->(MsSeek(cfilorig+cChave))
Endif                         
	
	
If SE1->(MsRLock())
	AAdd(aRLocks, SE1->(Recno()))
	lRet	:=	.T.
ElseIf lHelp                                       
	
//	MsgAlert(STR0060)

Endif	
If Len(aArea) > 0
	RestArea(aArea)
Endif	

Return lRet


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Fa330IntPco �Autor �Paulo Carnelossi    � Data �  22/11/06  ���
�������������������������������������������������������������������������͹��
���Desc.     �funcao que gera os lancamentos no sigapco (PcoDetLan())     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function Fa330IntPco(nRecSE1, aRecnoSE1, aBaixasSE5)
Local aArea := GetArea()
Local aAreaSE1 := SE1->(GetArea())
Local aAreaSE5 := SE5->(GetArea())
Local nX

If SuperGetMV("MV_PCOINTE",.F.,"2")=="1"

	dbSelectArea("SE1")
	dbGoto(nRecSE1) //titulo principal apos a compensacao
	
	//��������������������������������������������������������������������Ŀ
	//� Grava lan�amento no PCO ref titulo principal apos a compensacao    �
	//����������������������������������������������������������������������
	PCODetLan("000016","01","FINA330")
	
	For nX := 1 TO Len(aRecnoSE1) // ARRAY COM REGISTROS TITULOS COMPENSADOS
	
		//grava lcto ref. titulo compensado
		dbSelectArea("SE1")	
		dbGoto(aRecnoSE1[nX])
		//��������������������������������������������������������������������Ŀ
		//� Grava lan�amento no PCO ref titulo compensado apos a compensacao   �
		//����������������������������������������������������������������������
		PCODetLan("000016","02","FINA330")
	
		//grava lctos das baixas referente titulo principal e titulo compensado
		dbSelectArea("SE5")
		
		dbGoto(aBaixasSE5[(nX*2)-1])
		//�����������������������������������������������������������������������������������������������Ŀ
		//� Grava lan�amento no PCO ref baixa (Mov.Bancaria-SE5) do titulo principal apos a compensacao   �
		//�������������������������������������������������������������������������������������������������
		PCODetLan("000016","03","FINA330")
	
		dbGoto(aBaixasSE5[(nX*2)])
		//����������������������������������������������������������������������������Ŀ
		//� Grava lan�amento no PCO ref baixa do titulo compensado (Mov.Bancaria-SE5)  �
		//������������������������������������������������������������������������������
		PCODetLan("000016","04","FINA330")
	
	Next

EndIf
	
RestArea(aAreaSE5)
RestArea(aAreaSE1)
RestArea(aArea)

Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GARA150   �Autor  �Armando M. Tessaroli� Data �  12/08/09   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Certisign                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function FA330aUnlock()
AEval(aRLocks,{|x,y| SE1->(MsRUnlock(x))})  
aRLocks:={}
Return


/*/
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 �Fa330VTit � Autor � Mauricio Pequim Jr.   � Data � 22/09/97 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Retorna o saldo ou valor do titulo a ser compensado		  ���
�������������������������������������������������������������������������Ĵ��
��� Uso		 � Fina330													  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
STATIC Function Fa330VTit(aTitulo,cTipoTit,cValor)
LOCAL nValor
cValor := IIF (cValor == NIL,aTitulo,cValor)	
nValor := DesTrans(cValor)
Return nValor

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CTSA012   �Autor  �Microsiga           � Data �  07/15/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function CTS014baix(nVlrBaixa)

aBaixa	:=	{}
AADD( aBaixa, { "E1_PREFIXO" 	, SE1->E1_PREFIXO						, Nil } )	// 01
AADD( aBaixa, { "E1_NUM"     	, SE1->E1_NUM		 					, Nil } )	// 02
AADD( aBaixa, { "E1_PARCELA" 	, SE1->E1_PARCELA						, Nil } )	// 03
AADD( aBaixa, { "E1_TIPO"    	, SE1->E1_TIPO							, Nil } )	// 04
AADD( aBaixa, { "E1_CLIENTE"	, SE1->E1_CLIENTE						, Nil } )	// 05
AADD( aBaixa, { "E1_LOJA"    	, SE1->E1_LOJA							, Nil } )	// 06
AADD( aBaixa, { "AUTMOTBX"  	, "DAC"									, Nil } )	// 07
AADD( aBaixa, { "AUTBANCO"  	, ""									, Nil } )	// 08
AADD( aBaixa, { "AUTAGENCIA"  	, ""									, Nil } )	// 09
AADD( aBaixa, { "AUTCONTA"  	, ""									, Nil } )	// 10
AADD( aBaixa, { "AUTDTBAIXA"	, dDataBase								, Nil } )	// 11
AADD( aBaixa, { "AUTHIST"   	, "Baixa automatica(CTSA014)"			, Nil } )	// 12 
AADD( aBaixa, { "AUTDESCONT" 	, 0										, Nil } )	// 13
AADD( aBaixa, { "AUTMULTA"	 	, 0										, Nil } )	// 14
AADD( aBaixa, { "AUTJUROS"		, 0										, Nil } )	// 15
AADD( aBaixa, { "AUTOUTGAS" 	, 0										, Nil } )	// 16
AADD( aBaixa, { "AUTVLRPG"  	, 0        								, Nil } )	// 17
AADD( aBaixa, { "AUTVLRME"  	, 0										, Nil } )	// 18
AADD( aBaixa, { "AUTCHEQUE"  	, ""									, Nil } )	// 19
AADD( aBaixa, { "AUTVALREC"  	, nVlrBaixa								, Nil } )	// 20
AADD( aBaixa, { "AUTDTCREDITO"	, dDataBase								, Nil } )	// 21

lMsErroAuto := .F.
lMsHelpAuto := .F.

PutMv("MV_ANTCRED","T")
SuperGetMv("MV_ANTCRED",.T.,.T.)

MSExecAuto({|x,y| Fina070(x,y)},aBaixa,3)

PutMv("MV_ANTCRED","F")

Return