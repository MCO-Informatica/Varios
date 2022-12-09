#INCLUDE "FINR130.CH"
#INCLUDE "PROTHEUS.CH"

#DEFINE QUEBR				1
#DEFINE CLIENT			2
#DEFINE TITUL				3
#DEFINE TIPO				4
#DEFINE NATUREZA			5
#DEFINE EMISSAO			6
#DEFINE VENCTO			7
#DEFINE VENCREA			8
#DEFINE BANC				9
#DEFINE VL_ORIG			10
#DEFINE VL_NOMINAL			11
#DEFINE VL_CORRIG			12
#DEFINE VL_VENCIDO			13
#DEFINE NUMBC				14
#DEFINE VL_JUROS			15                                     
#DEFINE ATRASO			16
#DEFINE HISTORICO			17
#DEFINE VL_SOMA			18                                       

Static lFWCodFil := FindFunction("FWCodFil")
Static __lTempLOT
Static cDBType	:= Alltrim(Upper(TCGetDB()))
Static lSQL		:= !(cDBType $"ORACLE|POSTGRES|DB2|INFORMIX")
STATIC _nTamSEQ
STATIC cAliasProc

// 17/08/2009 - Compilacao para o campo filial de 4 posicoes
// 18/08/2009 - Compilacao para o campo filial de 4 posicoes

/*/
����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � FINR130  � Autor � Daniel Tadashi Batori � Data � 01.08.06 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Posi��o dos Titulos a Receber					          ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe e � FINR130(void)                                              ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
����������������������������������������������������������������������������
*/

User Function CSFIN030()
Local cDesc1 :=OemToAnsi(STR0001)  //"Imprime a posi��o dos titulos a receber relativo a data ba-"
Local cDesc2 :=OemToAnsi(STR0002)  //"se do sistema."
Local cDesc3 :=""
Local wnrel
Local cString:="SE1"
Local nRegEmp:=SM0->(RecNo())
Local dOldDtBase := dDataBase
Local dOldData	:= dDatabase

Private titulo  :=""
Private cabec1  :=""
Private cabec2  :=""

Private aLinha   :={}
Private aReturn  :={ OemToAnsi(STR0003), 1,OemToAnsi(STR0004), 1, 2, 1, "",1 }  //"Zebrado"###"Administracao"
Private cPerg	 :="CSRF130"
Private nJuros   :=0
Private nLastKey :=0
Private nomeprog :="CSFIN030"
Private tamanho  :="G"
Private cShowQry := ''

Private cMVBR10925  := SuperGetMv("MV_BR10925", ,"2") 
Private dDtVenc 	  := ddatabase
Private lAbortPrint := .F.
Private lShowQry    := .F.
//��������������������������Ŀ
//� Defini��o dos cabe�alhos �
//����������������������������
titulo := OemToAnsi(STR0005)  //"Posicao dos Titulos a Receber"
cabec1 := OemToAnsi(STR0006)  //"Codigo Nome do Cliente      Prf-Numero         TP  Natureza    Data de  Vencto   Vencto  Bco St  Valor Original |        Titulos Vencidos          | Titulos a Vencer | Num        Vlr.juros ou  Dias   Historico     "
cabec2 := OemToAnsi(STR0007)  //"                            Parcela                            Emissao  Titulo    Real                         |  Valor Nominal   Valor Corrigido |   Valor Nominal  | Banco       permanencia  Atraso               "

AjustaSX1()

//Nao retire esta chamada. Verifique antes !!!
//Ela � necessaria para o correto funcionamento da pergunte 36 (Data Base)
PutDtBase()

SetKey( VK_F12 , {|| lShowQry := MsgYesNo('Exportar a consulta SQL?','Relat�rio Aging' ) } )

Pergunte( cPerg,.F.)

//������������������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros												�
//� mv_par01		 // Do Cliente 													   �
//� mv_par02		 // Ate o Cliente													   �
//� mv_par03		 // Do Prefixo														   �
//� mv_par04		 // Ate o prefixo 												   �
//� mv_par05		 // Do Titulo													      �
//� mv_par06		 // Ate o Titulo													   �
//� mv_par07		 // Do Banco														   �
//� mv_par08		 // Ate o Banco													   �
//� mv_par09		 // Do Vencimento 												   �
//� mv_par10		 // Ate o Vencimento												   �
//� mv_par11		 // Da Natureza														�
//� mv_par12		 // Ate a Natureza													�
//� mv_par13		 // Da Emissao															�
//� mv_par14		 // Ate a Emissao														�
//� mv_par15		 // Qual Moeda															�
//� mv_par16		 // Imprime provisorios												�
//� mv_par17		 // Reajuste pelo vecto												�
//� mv_par18		 // Impr Tit em Descont												�
//� mv_par19		 // Relatorio Anal/Sint												�
//� mv_par20		 // Consid Data Base?  												�
//� mv_par21		 // Consid Filiais  ?  												�
//� mv_par22		 // da filial													      �
//� mv_par23		 // a flial 												         �
//� mv_par24		 // Da loja  															�
//� mv_par25		 // Ate a loja															�
//� mv_par26		 // Consid Adiantam.?												�
//� mv_par27		 // Da data contab. ?												�
//� mv_par28		 // Ate data contab.?												�
//� mv_par29		 // Imprime Nome    ?												�
//� mv_par30		 // Outras Moedas   ?												�
//� mv_par31       // Imprimir os Tipos												�
//� mv_par32       // Nao Imprimir Tipos												�
//� mv_par33       // Abatimentos  - Lista/Nao Lista/Despreza					�
//� mv_par34       // Consid. Fluxo Caixa												�
//� mv_par35       // Salta pagina Cliente											�
//� mv_par36       // Data Base													      �
//� mv_par37       // Compoe Saldo por: Data da Baixa, Credito ou DtDigit  �
//� MV_PAR38       // Tit. Emissao Futura												�
//� MV_PAR39       // Converte Valores 												�
//��������������������������������������������������������������������������
//���������������������������������������Ŀ
//� Envia controle para a fun��o SETPRINT �
//�����������������������������������������

wnrel:="CSFIN030"               //Nome Default do relatorio em Disco
aOrd :={	OemToAnsi(STR0008),;//"Por Cliente"
	OemToAnsi(STR0009),;		//"Por Prefixo/Numero"
	OemToAnsi(STR0010),; 		//"Por Banco"
	OemToAnsi(STR0011),;		//"Por Venc/Cli"
	OemToAnsi(STR0012),;		//"Por Natureza"
	OemToAnsi(STR0013),; 		//"Por Emissao"
	OemToAnsi(STR0014),;		//"Por Ven\Bco"
	OemToAnsi(STR0015),; 		//"Por Cod.Cli."
	OemToAnsi(STR0016),; 		//"Banco/Situacao"
	OemToAnsi(STR0047) } 		//"Por Numero/Tipo/Prefixo"

wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

CONOUT( "["+ "CSFIN030 > AGING" + " - " + Dtoc( date() ) + " - " + time() + " ] " + "INICIO" )

RptStatus({|lEnd| FA130Imp(@lEnd,wnRel,cString)},titulo)  // Chamada do Relatorio

SM0->(dbGoTo(nRegEmp))
cFilAnt := IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL )

//Acerta a database de acordo com a database real do sistema
dDataBase := dOldDtBase

CONOUT( "["+ "CSFIN030 > AGING" + " - " + Dtoc( date() ) + " - " + time() + " ] " + "FINAL" )

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 � FA130Imp � Autor � Paulo Boschetti	    � Data � 01.06.92 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Imprime relat�rio dos T�tulos a Receber					  ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe e � FA130Imp(lEnd,WnRel,cString)								  ���
�������������������������������������������������������������������������Ĵ��
���Parametros� lEnd	  - A��o do Codeblock				    			  ���
���			 � wnRel   - T�tulo do relat�rio 							  ���
���			 � cString - Mensagem										  ���
�������������������������������������������������������������������������Ĵ��
��� Uso		 � Generico 												  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function FA130Imp(lEnd,WnRel,cString)
Local CbCont
Local CbTxt
Local lContinua 	:= .T.
Local cCond1
Local cCond2
Local cCarAnt
Local nTit0			:=0
Local nTit1			:=0
Local nTit2			:=0
Local nTit3			:=0
Local nTit4			:=0
Local nTit5			:=0
Local nTotJ			:=0
Local nTot0			:=0
Local nTot1			:=0
Local nTot2			:=0
Local nTot3			:=0
Local nTot4			:=0
Local nTotTit		:=0
Local nTotJur		:=0
Local nTotFil0		:=0
Local nTotFil1		:=0
Local nTotFil2		:=0
Local nTotFil3		:=0
Local nTotFil4		:=0
Local nTotFilTit	:=0
Local nTotFilJ		:=0
Local nAtraso		:=0
Local nTotAbat		:=0
Local nSaldo		:=0
Local dDataReaj
Local dDataAnt := dDataBase
Local lQuebra

Local nMesTit0		:= 0
Local nMesTit1 		:= 0
Local nMesTit2 		:= 0
Local nMesTit3 		:= 0
Local nMesTit4 		:= 0
Local nMesTTit	 	:= 0
Local nMesTitj 		:= 0

Local cIndexSe1
Local cChaveSe1
Local nIndexSE1
Local dDtCtb	:=	CTOD("//")
Local cTipos  		:= ""
#IFDEF TOP
	Local aStru 	:= SE1->(dbStruct()), ni
#ENDIF	
Local aTamCli  		:= TAMSX3("E1_CLIENTE")
Local lF130Qry 		:= ExistBlock("F130QRY")
// variavel  abaixo criada p/pegar o nr de casas decimais da moeda
Local ndecs 		:= Msdecimais(mv_par15)
Local nAbatim 		:= 0
Local nDescont		:= 0
Local nVlrOrig		:= 0
Local nGem 			:= 0
Local aFiliais 		:= {}
Local aAreaSE5
Local cCorpBak    := ""
Local lRelCabec		:= .F.  
Local cFilNat 		:= SE1->E1_NATUREZ

// *************************************************
// Utilizada para guardar os abatimentos baixados *
// que devem subtrair o saldo do titulo principal.*
// *************************************************
Local nBx,aAbatBaixa	:= {}
Local nValPCC		:= 0

Local nLenFil		:= 0
Local nX			:= 0
Local cFilQry		:= ""
Local cFilSE1		:= ""
Local cFilSE5		:= ""
Local lHasLot		:= HasTemplate("LOT")
Local lTemGEM		:= ExistTemplate("GEMDESCTO") .And. HasTemplate("LOT")
Local lAS400		:= (Upper(TcSrvType()) != "AS/400" .And. Upper(TcSrvType()) != "ISERIES")
Local cMvDesFin		:= SuperGetMV("MV_DESCFIN",,"I")
Local aCliAbt		:= {}	// Clientes com titulos de abatimento
Local lFJurCst		:= Existblock("FJURCST")	// Ponto de entrada para calculo de juros
Local lAbatIMPBx	:= .F.
Local aRecSE1Cmp	:= {}
Local lArgentina 	:= ( cPaisLoc=="ARG" )
Local lFilterUser	:= .F.
Local lNaoListAbat	:= ( mv_par33 != 1 )
Local lEmissFutura	:= ( MV_PAR38 == 1 )
Local lTamNum 		:= TamSX3("E1_NUM")[1]

Local cCodVend    := _cCodCli := _cLojCli   := _cNomCli  := _cPrefixo   := _cTitulo    := _cParcela  := _cTipoTit    := _cNatureza  := _cEmissao  := '' 
Local _cVectoReal := _cBanco  := _cValorOri := _cTitVenc := _cTitVcorri := _cTitVlrAtu := _cNumBanco := _cDiasAtraso := _cHistorico := _cVencidos := '' 
Local _cVendedor  := _cVecto  := _cJuros    := _cVoucher := _cFluxoVou := _cTipoVou := _cCliVou := _cCliNome := _cProdGar := _cDProGar := _cProdVou := ''
Local nTitVenc    := nTitVCorr := nTitVlrAtu := 0  

Local _CPEDIDO  := "" 
Local _CPEDGAR  := ""
Local _CPEDSITE := ""
Local _cOs		:= ""
Local _cMensagem:= ""

Local lRet       := .F.
Local cPath      := GetTempPath() //Fun��o que retorna o caminho da pasta temp do usu�rio logado, exemplo: %temp%
Local cDir       := Curdir()
Local nConta     := 0
Local cNameFile  := Upper('Aging_' + dTos(Date()) + '.CSV')
Local cCabec     := "CLIENTE" + ';' + "LOJA" + ';' + "NOME CLIENTE" + ';' + "PREFIXO" + ';' + "TITULO" + ';' + "PARCELA" + ';' + "TP" + ';' + "NATUREZA" + ';' +;
                    "DATA EMISSAO" + ';' + "VENCTO TITULO" + ';' + "VENCTO REAL" + ';' + "BANCO" + ';' + "VALOR ORIGINAL" + ';' + ;
                    "TIT VENCIDOS VALOR ATUAL" + ';' + "TIT VENCIDOS VALOR CORRIGIDO" + ';' + "TIT a VENCER VALOR ATUAL" + ';' + "VLR. JUROS" + ';' +;
                    "NUM BANCARIO" + ';' + "VENDEDOR" + ';' + "DIAS ATRASO" + ';' + "HISTORICO" + ';' + "COD VOUCHER" + ';' + "FLUXO VOUCHER" + ';' +;
                    "TIPO VOUCHER" + ';' + "CLIENTE VOUCHER" + ';' + "NOME CLIENTE VOUCHER" + ';' + "PRODUTO GAR" + ';' + "DESCRICAO" + ';' +; 
                    "PRODUTO VOUCHER" + ';'+ "PEDIDO PROTHEUS" + ';'+ "PEDIDO GAR" + ';'+ "PEDIDO SITE" + ';'+ "NUMERO DA OS" + ';'
                                      
                    
Private cDado    := ''
Private nHdl     := 0

PRIVATE nRegSM0 	:= SM0->(Recno())
PRIVATE nAtuSM0 	:= SM0->(Recno())
PRIVATE nOrdem		:= 0
PRIVATE dBaixa 		:= dDataBase
PRIVATE cFilDe
PRIVATE cFilAte

Default __lTempLOT 	:= HasTemplate("LOT")

SET CENTURY OFF // Exibe data no formato DD/MM/AA 
//��������������������������������������������������������������Ŀ
//� Ponto de entrada para Filtrar os tipos sem entrar na tela do �
//� FINRTIPOS(), localizacao Argentina.                          �
//����������������������������Jose Lucas, Localiza��es Argentina��
IF EXISTBLOCK("F130FILT")
	cTipos	:=	EXECBLOCK("F130FILT",.f.,.f.)
ENDIF

nOrdem:=aReturn[8]
cMoeda:=Alltrim(Str(mv_par15,2))

//�����������������������������������������������������������Ŀ
//� Vari�veis utilizadas para Impress�o do Cabe�alho e Rodap� �
//�������������������������������������������������������������
cbtxt 	:= OemtoAnsi(STR0046)
cbcont	:= 1
li 		:= 80
m_pag 	:= 1

//������������������������������������������������������������������Ŀ
//� POR MAIS ESTRANHO QUE PARE�A, ESTA FUNCAO DEVE SER CHAMADA AQUI! �
//�                                                                  �
//� A fun��o SomaAbat reabre o SE1 com outro nome pela ChkFile para  �
//� efeito de performance. Se o alias auxiliar para a SumAbat() n�o  �
//� estiver aberto antes da IndRegua, ocorre Erro de & na ChkFile,   �
//� pois o Filtro do SE1 uptrapassa 255 Caracteres.                  �
//��������������������������������������������������������������������
SomaAbat("","","","R")

//�����������������������������������������������������������Ŀ
//� Atribui valores as variaveis ref a filiais                �
//�������������������������������������������������������������
If mv_par21 == 2
	cFilDe  := IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL )
	cFilAte := IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL )
ELSE
	cFilDe := mv_par22	// Todas as filiais
	cFilAte:= mv_par23
Endif

//Acerta a database de acordo com o parametro
If mv_par20 == 1    // Considera Data Base
	dBaixa := dDataBase := mv_par36
Else
	If dDataBase < MV_PAR36
		dBaixa := dDataBase := mv_par36	
	EndIf
Endif

dbSelectArea("SM0")
dbSeek(cEmpAnt+cFilDe,.T.)

nRegSM0 := SM0->(Recno())
nAtuSM0 := SM0->(Recno())

// Cria vetor com os codigos das filiais da empresa corrente
aFiliais := FinRetFil()

SetRegua(0)
IncRegua()

// Restringi momentaneamente para SQL e Oracle pois o Parse est� com erro quando trata-se de DB2
If !(cDBType $ "DB2|INFORMIX") .AND. ( ( MV_PAR37 == 2 ) .Or. ( MV_PAR37 == 3 ) )
	If ( cAliasProc == NIL )
		cAliasProc	:= getNextAlias()
	Endif
	CriaProc(cAliasProc)
Endif

While !Eof() .and. M0_CODIGO == cEmpAnt .and. IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL ) <= cFilAte
	
	dbSelectArea("SE1")
	cFilAnt := IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL )

	// *****************************************
	// Bloco utilizado para nao duplicar      *
	// registros quando Filial compartilhada  *
	// na gest�o corporativa. Exempo SE1:     *
	//  Filial  = Compartilhado               *
	//  Unidade = Exclusivo                   *
	//  Empresa = Exclusivo                   *
	// *****************************************
	If cCorpBak<>xFilial("SE1")
		cCorpBak	:= xFilial("SE1")
	Else
		dbSelectArea("SM0")
		SM0->(DbSkip())
		Loop
	EndIf
	Set Softseek On

	cFilSE5		:= xFilial( "SE5" )
	cFilSE1		:= xFilial( "SE1" )
	cFilSA1		:= xFilial( "SA1" )
	cFilSA6		:= xFilial( "SA6" )
	cFilSED		:= xFilial( "SED" )

	lVerCmpFil	:= !Empty(cFilSE1) .And. !Empty(cFilSE5) .And. Len(aFiliais) > 1

	If !lRelCabec
		If mv_par19 == 1 //1 = Analitico - 2 = Sintetico
			titulo := AllTrim(Titulo) + " " + OemToAnsi(STR0080)+ " " + AllTrim(GetMv("MV_MOEDA"+cMoeda))+ OemToAnsi(STR0026)  //" - Analitico"
			
		Else
			titulo := AllTrim(Titulo) + " " + OemToAnsi(STR0080)+ " " + AllTrim(GetMv("MV_MOEDA"+cMoeda)) + OemToAnsi(STR0027)  //" - Sintetico"
			cabec1 := OemToAnsi(STR0044)  //"                                                                                                               |        Titulos Vencidos          | Titulos a Vencer |            Vlr.juros ou             (Vencidos+Vencer)"
			cabec2 := OemToAnsi(STR0045)  //"                                                                                                               |  Valor Nominal   Valor Corrigido |   Valor Nominal  |             permanencia                              "
		EndIf
	EndIf	
	#IFDEF TOP

		// Verifica se deve montar filtro de filiais para compensacao em filiais diferentes
		If mv_par20 == 1 .And. lVerCmpFil
			nLenFil	:= Len( aFiliais )
			cFilQry	:= ""
			For nX := 1 To nLenFil
				If aFiliais[nX] != cFilSE5
					If !Empty( cFilQry ) 
						cFilQry += ", "
					Endif
					cFilQry += "'" + aFiliais[nX] + "'"
				EndIf
			Next nX
		EndIf

		// Verifica os titulos que possuem qualquer tipo de abatimento, para evitar chamada da SumAbat sem necessidade
		cQuery := "SELECT "

		cQuery += "E1_CLIENTE, E1_LOJA "
		cQuery += "FROM " + RetSQLName( "SE1" ) + " "
		cQuery += "WHERE "                                             
		cQuery += "    E1_FILIAL = '" + cFilSE1 + "' "
		cQuery += "AND E1_TIPO IN " + FormatIn( MVABATIM, "|" ) + " "
		cQuery += "AND D_E_L_E_T_ = ' ' "
		cQuery += "GROUP BY E1_CLIENTE, E1_LOJA "

		cQuery := ChangeQuery(cQuery)                   
		
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRBABT",.T.,.T.)	
		
		Do While ! EoF()
			AAdd( aCliAbt, TRBABT->E1_CLIENTE + TRBABT->E1_LOJA )
			dbSkip()
		EndDo                   
		
 		dbSelectArea( "SE1" )
		
		TRBABT->( dbCloseArea() )
		/*
		If nOrdem = 1
			cQuery := ""
			aEval(SE1->(DbStruct()),{|e| If(!Alltrim(e[1])$"E1_FILIAL#E1_NOMCLI#E1_CLIENTE#E1_LOJA#E1_PREFIXO#E1_NUM#E1_PARCELA#E1_TIPO", cQuery += ","+AllTrim(e[1]),Nil)})
			cQuery := "SELECT E1_FILIAL, E1_NOMCLI, E1_CLIENTE, E1_LOJA, E1_PREFIXO, E1_NUM,E1_PARCELA, E1_TIPO, "+ SubStr(cQuery,2)
		Else
			cQuery := "SELECT * "
		EndIf*/
		
		cQuery := "SELECT SE1.*, F2_MENNOTA "
		
		cQuery += "  FROM "+	RetSqlName("SE1") + " SE1 " 
		cQuery += "  LEFT JOIN " +	RetSqlName("SF2") + " SF2 ON F2_FILIAL = '"+xFilial("SF2")+"' AND F2_DOC > ' ' AND F2_DOC = E1_NUM AND F2_SERIE = E1_SERIE AND SF2.D_E_L_E_T_ = ' ' "
		cQuery += " WHERE E1_FILIAL = '" + cFilSE1 + "'"
		cQuery += "   AND SE1.D_E_L_E_T_ = ' ' "
	#ENDIF
	
	IF nOrdem = 1 .and. !lRelCabec
		//cChaveSe1 := "E1_FILIAL+E1_NOMCLI+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO"
		cChaveSe1 := "E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO"
		#IFDEF TOP
			cOrder := SqlOrder(cChaveSe1)
		#ELSE
			cIndexSe1 := CriaTrab(nil,.f.)
			IndRegua("SE1",cIndexSe1,cChaveSe1,,Fr130IndR(),OemToAnsi(STR0022))
			nIndexSE1 := RetIndex("SE1")
			dbSetIndex(cIndexSe1+OrdBagExt())
			dbSetOrder(nIndexSe1+1)
			dbSeek(xFilial("SE1"))
		#ENDIF
		cCond1 := "SE1->E1_CLIENTE <= mv_par02"
		cCond2 := "SE1->E1_CLIENTE + SE1->E1_LOJA"
		titulo := titulo + OemToAnsi(STR0017)  //" - Por Cliente"
		lRelCabec := .T.
		
	Elseif nOrdem = 2 .and. !lRelCabec
		SE1->(dbSetOrder(1))
		#IFNDEF TOP
			dbSeek(cFilial+mv_par03+mv_par05)
		#ELSE
			cOrder := SqlOrder(IndexKey())
		#ENDIF
		cCond1 := "E1_NUM <= mv_par06"
		cCond2 := "E1_NUM"
		titulo := titulo + OemToAnsi(STR0018)  //" - Por Numero"
		lRelCabec := .T.
		
	Elseif nOrdem = 3 .and. !lRelCabec
		SE1->(dbSetOrder(4))
		#IFNDEF TOP
			dbSeek(cFilial+mv_par07)
		#ELSE
			cOrder := SqlOrder(IndexKey())
		#ENDIF
		cCond1 := "E1_PORTADO <= mv_par08"
		cCond2 := "E1_PORTADO"
		titulo := titulo + OemToAnsi(STR0019)  //" - Por Banco"
		lRelCabec := .T.
		
	Elseif nOrdem = 4 .and. !lRelCabec
		SE1->(dbSetOrder(7))
		#IFNDEF TOP
			dbSeek(cFilial+DTOS(mv_par09))
		#ELSE
			cOrder := SqlOrder(IndexKey())
		#ENDIF
		cCond1 := Iif(mv_par40 = 2, "E1_VENCTO", "E1_VENCREA")+" <= mv_par10"
		cCond2 := Iif(mv_par40 = 2, "E1_VENCTO", "E1_VENCREA")
		titulo := titulo + OemToAnsi(STR0020)  //" - Por Data de Vencimento"
		lRelCabec := .T.
		
	Elseif nOrdem = 5 .and. !lRelCabec
		SE1->(dbSetOrder(3))
		#IFNDEF TOP
			dbSeek(cFilial+mv_par11)
		#ELSE
			cOrder := SqlOrder(IndexKey())
		#ENDIF
		cCond1 := "E1_NATUREZ <= mv_par12"
		cCond2 := "E1_NATUREZ"
		titulo := titulo + OemToAnsi(STR0021)  //" - Por Natureza"
		lRelCabec := .T.
		
	Elseif nOrdem = 6 .and. !lRelCabec
		SE1->(dbSetOrder(6))
		#IFNDEF TOP
			dbSeek( cFilial+DTOS(mv_par13))
		#ELSE
			cOrder := SqlOrder(IndexKey())
		#ENDIF
		cCond1 := "E1_EMISSAO <= mv_par14"
		cCond2 := "E1_EMISSAO"
		titulo := titulo + OemToAnsi(STR0042)  //" - Por Emissao"
		lRelCabec := .T.
		
	Elseif nOrdem == 7 .and. !lRelCabec
		cChaveSe1 := "E1_FILIAL+DTOS("+Iif(mv_par40 = 2, "E1_VENCTO", "E1_VENCREA")+")+E1_PORTADO+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO"
		#IFNDEF TOP
			cIndexSe1 := CriaTrab(nil,.f.)
			IndRegua("SE1",cIndexSe1,cChaveSe1,,Fr130IndR(),OemToAnsi(STR0022))
			nIndexSE1 := RetIndex("SE1")
			dbSetIndex(cIndexSe1+OrdBagExt())
			dbSetOrder(nIndexSe1+1)
			dbSeek(xFilial("SE1"))
		#ELSE
			cOrder := SqlOrder(cChaveSe1)
		#ENDIF
		cCond1 := Iif(mv_par40 = 2, "E1_VENCTO", "E1_VENCREA")+" <= mv_par10"
		cCond2 := "DtoS("+Iif(mv_par40 = 2, "E1_VENCTO", "E1_VENCREA")+")+E1_PORTADO+E1_AGEDEP+E1_CONTA"
		titulo := titulo + OemToAnsi(STR0023)  //" - Por Vencto/Banco"
		lRelCabec := .T.
		
	Elseif nOrdem = 8 .and. !lRelCabec
		SE1->(dbSetOrder(2))
		#IFNDEF TOP
			dbSeek(cFilial+mv_par01,.T.)
		#ELSE
			cOrder := SqlOrder(IndexKey())
		#ENDIF
		cCond1 := "E1_CLIENTE <= mv_par02"
		cCond2 := "E1_CLIENTE"
		titulo := titulo + OemToAnsi(STR0024)  //" - Por Cod.Cliente"
		lRelCabec := .T.
		
	Elseif nOrdem = 9 .and. !lRelCabec
		cChave := "E1_FILIAL+E1_PORTADO+E1_SITUACA+E1_NOMCLI+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO"
		#IFNDEF TOP
			dbSelectArea("SE1")
			cIndex := CriaTrab(nil,.f.)
			IndRegua("SE1",cIndex,cChave,,fr130IndR(),OemToAnsi(STR0022))
			nIndex := RetIndex("SE1")
			dbSetIndex(cIndex+OrdBagExt())
			dbSetOrder(nIndex+1)
			dbSeek(xFilial("SE1"))
		#ELSE
			cOrder := SqlOrder(cChave)
		#ENDIF
		cCond1 := "E1_PORTADO <= mv_par08"
		cCond2 := "E1_PORTADO+E1_SITUACA"
		titulo := titulo + OemToAnsi(STR0025)  //" - Por Banco e Situacao"
		lRelCabec := .T.
		
	ElseIf nOrdem == 10 .and. !lRelCabec
		cChave := "E1_FILIAL+E1_NUM+E1_TIPO+E1_PREFIXO+E1_PARCELA"
		#IFNDEF TOP
			dbSelectArea("SE1")
			cIndex := CriaTrab(nil,.f.)
			IndRegua("SE1",cIndex,cChave,,,OemToAnsi(STR0022))
			nIndex := RetIndex("SE1")
			dbSetIndex(cIndex+OrdBagExt())
			dbSetOrder(nIndex+1)
			dbSeek(xFilial("SE1")+mv_par05)
		#ELSE
			cOrder := SqlOrder(cChave)
		#ENDIF
		cCond1 := "E1_NUM <= mv_par06"
		cCond2 := "E1_NUM"
		titulo := titulo + OemToAnsi(STR0048)  //" - Numero/Prefixo"	
		lRelCabec := .T.
		
	Endif
	
	If mv_par19 <> 1 //1 = Analitico - 2 = Sintetico
		cabec1 := OemToAnsi(STR0044)  //"Nome do Cliente      |        Titulos Vencidos          | Titulos a Vencer |            Vlr.juros ou             (Vencidos+Vencer)"
		cabec2 := OemToAnsi(STR0045)  //"|  Valor Nominal   Valor Corrigido |   Valor Nominal  |             permanencia                              "
	EndIf
	
	cFilterUser:=aReturn[7]
	Set Softseek Off
	
	#IFDEF TOP                                  
		If ! ( Empty( mv_par01 ) .And. AllTrim( Upper( mv_par02 ) ) == Replicate( "Z", Len( mv_par02 ) ) )
			cQuery += " AND E1_CLIENTE between '" + mv_par01        + "' AND '" + mv_par02 + "'"
		EndIf	
		
		If ! ( Empty( mv_par24 ) .And. AllTrim( Upper( mv_par25 ) ) == Replicate( "Z", Len( mv_par25 ) ) )
			cQuery += " AND E1_LOJA    between '" + mv_par24        + "' AND '" + mv_par25 + "'"
		EndIf
		
		If ! ( Empty( mv_par03 ) .And. AllTrim( Upper( mv_par04 ) ) == Replicate( "Z", Len( mv_par04 ) ) )		
			cQuery += " AND E1_PREFIXO between '" + mv_par03        + "' AND '" + mv_par04 + "'"
		EndIf	
		
		If ! ( Empty( mv_par05 ) .And. AllTrim( Upper( mv_par06 ) ) == Replicate( "Z", Len( mv_par06 ) ) )		
			cQuery += " AND E1_NUM     between '" + mv_par05        + "' AND '" + mv_par06 + "'"
		EndIf
		
		If ! ( Empty( mv_par07 ) .And. AllTrim( Upper( mv_par08 ) ) == Replicate( "Z", Len( mv_par08 ) ) )		
			cQuery += " AND E1_PORTADO between '" + mv_par07        + "' AND '" + mv_par08 + "'"
		EndIf
			
		If mv_par40 == 2
			cQuery += " AND E1_VENCTO between '" + DTOS(mv_par09)  + "' AND '" + DTOS(mv_par10) + "'"
		Else
			cQuery += " AND E1_VENCREA between '" + DTOS(mv_par09)  + "' AND '" + DTOS(mv_par10) + "'"		
		Endif
		
		If 	! ( Empty( mv_par11 ) .And. AllTrim( Upper( mv_par12 ) ) == Replicate( "Z", Len( mv_par12 ) ) )				
			cQuery += " AND (E1_MULTNAT = '1' OR (E1_NATUREZ BETWEEN '"+MV_PAR11+"' AND '"+MV_PAR12+"'))"
		EndIf
			                                        
		If mv_par13 <> mv_par27 .Or. mv_par14 <> mv_par28
			cQuery += " AND E1_EMISSAO between '" + DTOS(mv_par13)  + "' AND '" + DTOS(mv_par14) + "'"
		EndIf	

		If MV_PAR38 == 2 .And. mv_par28 <> mv_par36  //Nao considerar titulos com emissao futura
			cQuery += " AND E1_EMISSAO <= '" + DTOS(mv_par36) + "'"
		Endif

		//cQuery += " AND ((E1_EMIS1  Between '"+ DTOS(mv_par27)+"' AND '"+DTOS(mv_par28)+"') OR E1_EMISSAO Between '"+DTOS(mv_par27)+"' AND '"+DTOS(mv_par28)+"')"
		cQuery += " AND E1_EMIS1  Between '"+ DTOS(mv_par27)+"' AND '"+DTOS(mv_par28)+"'"
		If !Empty(mv_par31) // Deseja imprimir apenas os tipos do parametro 31
			cQuery += " AND E1_TIPO IN "+FormatIn(AllTrim(mv_par31),";") 
		ElseIf !Empty(Mv_par32) // Deseja excluir os tipos do parametro 32
			cQuery += " AND E1_TIPO NOT IN "+FormatIn(AllTrim(mv_par32),";")
		EndIf              
		
		//If mv_par18 == 2
			//cQuery += " AND E1_SITUACA NOT IN ( '2', '7' ) "
		//Endif
		
		If mv_par20 == 2
			cQuery += ' AND E1_SALDO <> 0'   
		Else                                                                                   
			If mv_par37 == 1
				cQuery += " AND ( E1_SALDO > 0 OR E1_BAIXA > '" + DtoS( dDataBase ) + "' ) " 
			EndIf	
		Endif

		If mv_par26 == 2 
			cQuery += "AND E1_TIPO NOT IN " + FormatIn( MVRECANT + "/" + MV_CRNEG, "/" )
		Endif
		         
		If mv_par33 != 1                                            
			If mv_par16 == 2
				cQuery += " AND E1_TIPO NOT IN " + FormatIn( MVABATIM + "|" + MVPROVIS, "|" ) 
			Else	
				cQuery += " AND E1_TIPO NOT IN " + FormatIn( MVABATIM, "|" ) 
			EndIf	
		EndIf	

		If mv_par34 == 1
			cQuery += " AND E1_FLUXO <> 'N'"
		Endif		                                      
		
		If mv_par21 <> 2
			If Empty( E1_FILIAL )
				cQuery += " AND E1_FILORIG between '" + mv_par22 + "' AND '" + mv_par23 + "'"				
			Else
				cQuery += " AND E1_FILIAL between '" + mv_par22 + "' AND '" + mv_par23 + "'"				
			EndIf
		Endif 
		
		If mv_par30 == 2 // nao imprime
			cQuery += " AND E1_MOEDA = "+cMoeda
		Endif
		                 
        //������������������������������������������������������������������������Ŀ
        //� Ponto de entrada para inclusao de parametros no filtro a ser executado �
        //��������������������������������������������������������������������������
	    
		If lF130Qry 
			cQuery += ExecBlock("F130QRY",.f.,.f.)
		Endif

		cQuery += " ORDER BY "+ cOrder
		
		cQuery := ChangeQuery(cQuery)
		
		cShowQry := 'CSFIN030 > ' + CRLF + cQuery
		
		dbSelectArea("SE1")
		dbCloseArea()
		dbSelectArea("SA1")
		
		dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'SE1', .F., .T.)
		
		
		For ni := 1 to Len(aStru)
			If aStru[ni,2] != 'C'
				TCSetField('SE1', aStru[ni,1], aStru[ni,2],aStru[ni,3],aStru[ni,4])
			Endif
		Next
	#ENDIF
	
	If MV_MULNATR .And. nOrdem == 5
		Finr135R3(cTipos, lEnd, @nTot0, @nTot1, @nTot2, @nTot3, @nTotTit, @nTotJ)
		#IFDEF TOP
			dbSelectArea("SE1")
			dbCloseArea()
			ChKFile("SE1")
			dbSelectArea("SE1")
			dbSetOrder(1)
		#ENDIF
		If Empty(xFilial("SE1"))
			Exit
		Endif
		dbSelectArea("SM0")
		dbSkip()
		Loop
	Endif
	
	IF File( cDir + cNameFile )
		Ferase( cDir + cNameFile)
	EndIF
	
	nHdl := FCreate( cNameFile )
	FWrite( nHdl, cCabec + CRLF )
	
	CONOUT( "["+ "CSFIN030 > AGING" + " - " + Dtoc( date() ) + " - " + time() + " ] " + "Processamento da Query" )
		
	While SE1->( !Eof() ) .And. SE1->E1_FILIAL == cFilSE1 .And. &cCond1
		
		IF	lEnd
			@PROW()+1,001 PSAY OemToAnsi(STR0028)  //"CANCELADO PELO OPERADOR"
			Exit
		Endif
		
		Store 0 To nTit1,nTit2,nTit3,nTit4,nTit5
		
		//����������������������������������������Ŀ
		//� Carrega data do registro para permitir �
		//� posterior analise de quebra por mes.   �
		//������������������������������������������
		dDataAnt := If(nOrdem == 6 , SE1->E1_EMISSAO,  Iif(mv_par40 = 2, SE1->E1_VENCTO, SE1->E1_VENCREA))
		
		cCarAnt := &cCond2

		dbSelectArea( "SE1" )
		
		While &cCond2==cCarAnt .and. !Eof() .and. lContinua .and. SE1->E1_FILIAL == cFilSE1
			
			IF lEnd
				@PROW()+1,001 PSAY OemToAnsi(STR0028)  //"CANCELADO PELO OPERADOR"
				lContinua := .F.
				Exit
			EndIF

			
			//��������������������������������������������������������������Ŀ
			//� Considera filtro do usuario                                  �
			//����������������������������������������������������������������
			If !Empty(cFilterUser).and.!(&cFilterUser)
				dbSelectArea("SE1")			
				dbSkip()
				Loop
			Endif
			
			If mv_par18 == 2
				If SE1->E1_SITUACA == '2' .OR. SE1->E1_SITUACA == '7'
					dbSkip()
					Loop
				Endif	
			Endif
			
			// Tratamento da correcao monetaria para a Argentina
			If  lArgentina .And. (mv_par15 <> 1) .And.  SE1->E1_CONVERT=='N'
				dbSkip()
				Loop
			Endif
			//������������������������������������������������������Ŀ
			//� Verifica se trata-se de abatimento ou somente titulos�
			//� at� a data base. 									 �
			//��������������������������������������������������������
			If (mv_par38 == 2 .And. SE1->E1_EMISSAO > mv_par36)
				IF !Empty(SE1->E1_TITPAI)
					aAdd( aAbatBaixa , { SE1->(E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+E1_CLIENTE+E1_LOJA) , SE1->E1_TITPAI } )
				Else
					cMTitPai := FTITPAI()
					aAdd( aAbatBaixa , { SE1->(E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+E1_CLIENTE+E1_LOJA) , cMTitPai } )
				EndIf              
				dbSelectArea("SE1")				
				dbSkip()
				Loop
			Endif
			
			//Quando Retroagir saldo, data menor que o solicitado e o titulo estiver 
			//baixado nao mostrar no relatorio
			If (MV_PAR20 == 1 .and. cMVBR10925 == "1" .and. SE1->E1_EMISSAO <= MV_PAR36 .and. SE1->E1_TIPO $ "PIS/COF/CSL")
				dbSkip()
				Loop				
			EndIf	
			
			// dDtContab para casos em que o campo E1_EMIS1 esteja vazio
			dDtCtb	:=	CTOD("//")
			dDtCtb	:= Iif(Empty(SE1->E1_EMIS1),SE1->E1_EMISSAO,SE1->E1_EMIS1)
                    
			#IFDEF TOP

				If dDtCtb < mv_par27 .Or. dDtCtb > mv_par28 
					SE1->( dbSkip() )
					Loop
				Endif
	
			#ELSE
				If mv_par18 == 2 .and. SE1->E1_SITUACA $ "27"
					dbSkip()
					Loop
				Endif
				//����������������������������������������Ŀ
				//� Verifica se esta dentro dos parametros �
				//������������������������������������������
				dbSelectArea("SE1")
				IF SE1->E1_CLIENTE < mv_par01 .OR. SE1->E1_CLIENTE > mv_par02 .OR. ;
					SE1->E1_PREFIXO < mv_par03 .OR. SE1->E1_PREFIXO > mv_par04 .OR. ;
					SE1->E1_NUM	 	 < mv_par05 .OR. SE1->E1_NUM 		> mv_par06 .OR. ;
					SE1->E1_PORTADO < mv_par07 .OR. SE1->E1_PORTADO > mv_par08 .OR. ;
					Iif(mv_par40 = 2, SE1->E1_VENCTO, SE1->E1_VENCREA) < mv_par09 .OR. ;
					Iif(mv_par40 = 2, SE1->E1_VENCTO, SE1->E1_VENCREA) > mv_par10 .OR. ;
					SE1->E1_NATUREZ < mv_par11 .OR. SE1->E1_NATUREZ > mv_par12 .OR. ;
					SE1->E1_EMISSAO < mv_par13 .OR. SE1->E1_EMISSAO > mv_par14 .OR. ;
					SE1->E1_LOJA    < mv_par24 .OR. SE1->E1_LOJA    > mv_par25 .OR. ;
					dDtCtb          < mv_par27 .OR. dDtCtb          > mv_par28 .OR. ;
					(SE1->E1_EMISSAO > mv_par36 .and. !lEmissFutura)
					dbSkip()
					Loop
				Endif
			#ENDIF
			
			// Verifica se existe a taxa na data do vencimento do titulo, se nao existir, utiliza a taxa da database
			If SE1->E1_VENCREA < dDataBase
				If mv_par17 == 2 .And. RecMoeda(SE1->E1_VENCREA,cMoeda) > 0
					dDataReaj := SE1->E1_VENCREA
				Else
					dDataReaj := dDataBase
				EndIf	
			Else
				dDataReaj := dDataBase
			EndIf
						
			If mv_par20 == 1	// Considera Data Base
			    If SE1->E1_SALDO == SE1->E1_VALOR
			    	nSaldo := SE1->E1_SALDO
				Else
					nSaldo := SaldoTit(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_TIPO,SE1->E1_NATUREZ,"R",SE1->E1_CLIENTE,mv_par15,dDataReaj,MV_PAR36,SE1->E1_LOJA,,Iif(MV_PAR39==2,Iif(!Empty(SE1->E1_TXMOEDA),SE1->E1_TXMOEDA,RecMoeda(SE1->E1_EMISSAO,SE1->E1_MOEDA)),0),mv_par37)
				EndIf
				
				//Verifica se existem compensa��es em outras filiais para descontar do saldo, pois a SaldoTit() somente
				//verifica as movimenta��es da filial corrente. Nao deve processar quando existe somente uma filial.
				If lVerCmpFil
					nSaldo -= Round(NoRound(xMoeda(FRVlCompFil("R",SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_TIPO,SE1->E1_CLIENTE,SE1->E1_LOJA,mv_par37,aFiliais,cFilQry,lAS400),;
									SE1->E1_MOEDA,mv_par15,dDataReaj,ndecs+1,Iif(mv_par39==2,Iif(!Empty(SE1->E1_TXMOEDA),SE1->E1_TXMOEDA,RecMoeda(SE1->E1_EMISSAO,SE1->E1_MOEDA) ),0 ) ),;
									nDecs+1),nDecs)
				EndIf  
				
				// Subtrai decrescimo para recompor o saldo na data escolhida.
				If (Str(SE1->E1_VALOR,17,2) == Str(nSaldo,17,2)) .And. ((SE1->E1_DECRESC > 0) .OR. (SE1->E1_DESCONT >0 .And. SE1->E1_SDDECRE == 0) ) .and. F130DESC()
					If  SE1->E1_DECRESC > 0 
						nSAldo -= SE1->E1_DECRESC
					Endif
					If SE1->E1_DESCONT>0 .and. SE1->E1_DECRESC == 0 
						nSAldo -= SE1->E1_DESCONT
					Endif
				EndIf
 				
				// Soma Acrescimo para recompor o saldo na data escolhida.
				If Str(SE1->E1_VALOR,17,2) == Str(nSaldo,17,2) .And. SE1->E1_ACRESC > 0 .And. SE1->E1_SDACRES == 0
					nSAldo += SE1->E1_ACRESC
				Endif

				//Se abatimento verifico a data da baixa.
				//Por nao possuirem movimento de baixa no SE5, a saldotit retorna 
				//sempre saldo em aberto quando mv_par33 = 1 (Abatimentos = Lista) 
				If mv_par33 == 1
					If SE1->E1_TIPO == "BOL"
						aParam := {SE1->E1_FILIAL,SE1->E1_NOMCLI,SE1->E1_CLIENTE,SE1->E1_LOJA,SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA}
						aAbatBaixa:=PesqAbat(aParam)
					Else			
						If SE1->E1_TIPO $ MVABATIM .and. ;
							((SE1->E1_BAIXA <= dDataBase .and. !Empty(SE1->E1_BAIXA)) .or. ;
							 (SE1->E1_MOVIMEN <= dDataBase .and. !Empty(SE1->E1_MOVIMEN))	) .and.;
							 SE1->E1_SALDO == 0			
							nSaldo := 0
							IF !Empty(SE1->E1_TITPAI)
								aAdd( aAbatBaixa , { SE1->(E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+E1_CLIENTE+E1_LOJA) , SE1->E1_TITPAI } )
							Else
								cMTitPai := FTITPAI()
								aAdd( aAbatBaixa , { SE1->(E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+E1_CLIENTE+E1_LOJA) , cMTitPai } )
							EndIf
						Endif 
					EndIf
				EndIf
								
				If ( cMVBR10925 == "1" .and. SE1->E1_EMISSAO <= MV_PAR36 .and. !(SE1->E1_TIPO $ "PIS/COF/CSL") .and. !(SE1->E1_TIPO $ MVABATIM))
					nValPcc := SumPCC130(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,dBaixa,SE1->E1_CLIENTE,SE1->E1_LOJA,mv_par15)
					nSaldo -= nValPcc
				EndIf
				If nSaldo <> 0 .and. SE1->E1_TIPO $ "NCC" .and. (MV_PAR37 == 2 .OR. MV_PAR37 == 3).and. SE1->E1_MOVIMEN <= dDataBase .and. SE1->E1_SALDO == 0
					dbSelectArea("SE1")				
					DbSkip()
					Loop
				EndIf
				If SE1->E1_TIPO == "RA "   //somente para titulos ref adiantamento verifica se nao houve cancelamento da baixa posterior data base (mv_par36)
					nSaldo -= F130TipoBA( cFilSE5 )
				EndIf
			Else
				nSaldo := xMoeda((SE1->E1_SALDO+SE1->E1_SDACRES-SE1->E1_SDDECRE),SE1->E1_MOEDA,mv_par15,dDataReaj,ndecs+1,Iif(MV_PAR39==2,Iif(!Empty(SE1->E1_TXMOEDA),SE1->E1_TXMOEDA,RecMoeda(SE1->E1_EMISSAO,SE1->E1_MOEDA)),0))
			Endif
			
			//Caso exista desconto financeiro (cadastrado na inclusao do titulo), 
			//subtrai do valor principal.
			If SE1->E1_DESCFIN > 0 .Or. SE1->E1_DECRESC > 0
  				If Empty( SE1->E1_BAIXA ) .Or. cMvDesFin == "P" .Or. (mv_par20==1 .And. cMvDesFin=="I" .And. dDataBase<SE1->E1_BAIXA)
					nDescont := FaDescFin("SE1",dBaixa,nSaldo,1,.T.,lTemGem)
					If nDescont > 0
						nSaldo := nSaldo - nDescont
					Endif
				EndIf
			EndIf	
						
			If ! SE1->E1_TIPO $ MVABATIM
				If ! (SE1->E1_TIPO $ MVRECANT+"/"+MV_CRNEG) .And. ;
					!( MV_PAR20 == 2 .And. nSaldo == 0 )  	// deve olhar abatimento pois e zerado o saldo na liquidacao final do titulo
					                                                          
			   		dbSelectArea("__SE1")
			   		dbSetOrder(2)
			   		dbSeek( cFilSED + SE1->E1_CLIENTE + SE1->E1_LOJA + SE1->E1_PREFIXO + SE1->E1_NUM + SE1->E1_PARCELA + SE1->E1_TIPO )
					cFilNat := SE1->E1_NATUREZ				
					aTitImp := F130RETIMP( cFilNat, cFilSED )					
					
					If (nPos := (aScan(aTitImp, {|x| x[1] <> SE1->E1_TIPO }))) > 0 .and. aTitImp[nPos][2]
						
						//Quando considerar Titulos com emissao futura, eh necessario
						//colocar-se a database para o futuro de forma que a Somaabat()
						//considere os titulos de abatimento
						If mv_par38 == 1
							dOldData := dDataBase
							dDataBase := CTOD("31/12/40")
						Endif

						// Somente verifica abatimentos se existirem titulos deste tipo para o cliente
						If aScan( aCliAbt, SE1->(E1_CLIENTE + E1_LOJA) ) > 0
							nAbatim := SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",mv_par15,dDataReaj,SE1->E1_CLIENTE,SE1->E1_LOJA)
						Else
							nAbatim := 0
						EndIf
						
						If mv_par38 == 1
							dDataBase := dOldData
						Endif
						
						If mv_par33 != 1  //somente deve considerar abatimento no saldo se nao listar
							If STR(nSaldo,17,2) == STR(nAbatim,17,2)
								nSaldo := 0
							ElseIf mv_par33 == 2 //Se nao listar ele diminui do saldo
								nSaldo-= nAbatim
							Endif
						Else
							// Subtrai o Abatimento caso o mesmo j� tenho sido baixado ou n�o esteja listado no relatorios
							/*nBx := aScan( aAbatBaixa, {|x| x[2]= SE1->(E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+E1_CLIENTE+E1_LOJA) } )
							If (SE1->E1_BAIXA <= dDataBase .and. !Empty(SE1->E1_BAIXA) .and. nBx>0)
								aDel( aAbatBaixa , nBx)
								aSize(aAbatBaixa, Len(aAbatBaixa)-1)
								nSaldo-= nAbatim
							ElseIF !Empty(SE1->E1_BAIXA)
								nSaldo-= nAbatim
							EndIf*/

							//Deve abater sempre.
							nSaldo -= nAbatim
						EndIf
					EndIf
				EndIf
			Endif	
			nSaldo:=Round(NoRound(nSaldo,3),2)	
			
			//������������������������������������������������������Ŀ
			//� Desconsidera caso saldo seja menor ou igual a zero   �
			//��������������������������������������������������������
			If nSaldo <= 0
				dbSkip()
				Loop
			Endif					
				
			SA1->( dbSeek( cFilSA1 + SE1->E1_CLIENTE + SE1->E1_LOJA ) )
			If nOrdem == 3 .Or. nOrdem == 9
				SA6->( dbSeek( cFilSA6 + SE1->E1_PORTADO ) )
			EndIf
    	
			IF li > 58
				nAtuSM0 := SM0->(Recno())
				SM0->(dbGoto(nRegSM0))
				cabec(titulo,cabec1,cabec2,nomeprog,tamanho,GetMv("MV_COMP"))
				SM0->(dbGoTo(nAtuSM0))
			EndIF
			
			If mv_par19 == 1 //1 = Analitico - 2 = Sintetico 
			
				@li,	0 PSAY SE1->E1_CLIENTE + "-" + SE1->E1_LOJA + "-" +;
					IIF(mv_par29 == 1, SubStr(SA1->A1_NREDUZ,1,20), SubStr(SA1->A1_NOME,1,20))
				li := IIf (aTamCli[1] > 6,li+1,li)
				
				@li, 31 PSAY SE1->E1_PREFIXO+"-"+SE1->E1_NUM+"-"+SE1->E1_PARCELA         
				li := if( LEN( SE1->E1_NUM ) > 9, li+1, li )
				
				@li, 49 PSAY AllTrim(SE1->E1_TIPO)
				@li, 53 PSAY SE1->E1_NATUREZ
				@li, 63 PSAY SE1->E1_EMISSAO
				@li, 74 PSAY SE1->E1_VENCTO
				@li, 85 PSAY SE1->E1_VENCREA   
				
				_cCodCli    := SE1->E1_CLIENTE
				_cLojCli    := SE1->E1_LOJA
				_cNomCli    := IIF( mv_par29 == 1, SA1->A1_NREDUZ, SA1->A1_NOME )
				_cNomCli    := Alltrim( STRTRAN(_cNomCli, ';', ' ') )
				_cPrefixo   := SE1->E1_PREFIXO
				_cTitulo    := SE1->E1_NUM
				_cParcela   := SE1->E1_PARCELA
				_cTipoTit   := AllTrim(SE1->E1_TIPO)
				_cNatureza  := SE1->E1_NATUREZ 
				_cEmissao   := dToC(SE1->E1_EMISSAO)
				_cVecto     := dToC(SE1->E1_VENCTO)
				_cVectoReal := dToC(SE1->E1_VENCREA) 
				_cOs		:= Iif("NUMERO DO ATENDIMENTO" $ Upper(SE1->F2_MENNOTA),StrTran(UPPER(SE1->F2_MENNOTA),"NUMERO DO ATENDIMENTO: ",""),SE1->E1_OS)
								
				If mv_par20 == 1  //Recompoe Saldo Retroativo              
				    //Titulo foi Baixado e Data da Baixa e menor ou igual a Data Base do Relat�rio
				    IF !Empty(SE1->E1_BAIXA) 
				    	If SE1->E1_BAIXA <= mv_par36 .Or. !Empty( SE1->E1_PORTADO )
							@li, 95 PSAY SE1->E1_PORTADO+" "+SE1->E1_TIPMOV
						EndIf
					Else                                                                                   
					    //Titulo n�o foi Baixado e foi transferido para Carteira e Data Movimento e menor 
				    	//ou igual a Data Base do Relat�rio
						If Empty(SE1->E1_BAIXA) .and. SE1->E1_MOVIMEN <= mv_par36
							@li, 95 PSAY SE1->E1_PORTADO+" "+SE1->E1_TIPMOV             
						EndIf
					ENDIF
				Else   // Nao Recompoe Saldo Retroativo
					@li, 95 PSAY SE1->E1_PORTADO+" "+SE1->E1_TIPMOV
				EndIf
				
				_cBanco := SE1->E1_PORTADO
				
				nVlrOrig := Round(NoRound(xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,mv_par15,SE1->E1_EMISSAO,ndecs+1,Iif(MV_PAR39==2,Iif(!Empty(SE1->E1_TXMOEDA),SE1->E1_TXMOEDA,RecMoeda(SE1->E1_EMISSAO,SE1->E1_MOEDA)),0))* If(SE1->E1_TIPO$MVABATIM+"/"+MV_CRNEG+"/"+MVRECANT+"/"+MVABATIM, -1,1),nDecs+1),nDecs)
				@li,100 PSAY nVlrOrig Picture TM(nVlrOrig,15,nDecs)
				
				_cValorOri := lTrim(Transform(nVlrOrig,"@E 999,999,999.99"))
			Endif
			
			If dDataBase >= E1_VENCREA	//vencidos

				If mv_par19 == 1 //1 = Analitico - 2 = Sintetico
					nTitVenc := nSaldo * If((SE1->E1_TIPO$MV_CRNEG+"/"+MVRECANT+"/"+MVABATIM +"/"+MVFUABT) .OR. lAbatIMPBx , -1,1)
					@li,116 PSAY nTitVenc Picture TM(nTitVenc,16,nDecs)
					_cTitVenc := lTrim( Transform( nTitVenc,"@E 999,999,999.99" ) )
				EndIf 
				nJuros := 0
				// Somente chamad fa070juros se realmente houver necessidade de calculo de juros			
				If lFJurCst .Or. !Empty(SE1->E1_VALJUR) .Or. !Empty(SE1->E1_PORCJUR)
					fa070Juros(mv_par15)
				EndIf	                                                           
				
				// Se titulo do Template GEM4
				If __lTempLOT .And. SE1->(FieldPos("E1_NCONTR")) > 0 .And. !Empty(SE1->E1_NCONTR) .And. SE1->E1_VALOR==SE1->E1_SALDO
					nJuros -= nGem
				EndIf
				dbSelectArea("SE1")
				If mv_par19 == 1 //1 = Analitico - 2 = Sintetico
					nTitVCorr := (nSaldo+nJuros)* If(SE1->E1_TIPO$MV_CRNEG+"/"+MVRECANT+"/"+MVABATIM, -1,1)
					@li,133 PSAY nTitVCorr Picture TM(nTitVCorr,16,nDecs)
					_cTitVcorri := lTrim( Transform( nTitVCorr,"@E 999,999,999.99" ) )
					//Transform((nSaldo+nJuros)* If(SE1->E1_TIPO$MV_CRNEG+"/"+MVRECANT+"/"+MVABATIM, -1,1),"@E 999,999,999.99")
					                         
				EndIf
				If SE1->E1_TIPO $ MVRECANT+"/"+MV_CRNEG .or. (mv_par33 == 1 .and. SE1->E1_TIPO $ MVABATIM)
					nTit0 -= Round(NoRound(xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,mv_par15,SE1->E1_EMISSAO,ndecs+1,Iif(MV_PAR39==2,Iif(!Empty(SE1->E1_TXMOEDA),SE1->E1_TXMOEDA,RecMoeda(SE1->E1_EMISSAO,SE1->E1_MOEDA)),0)),ndecs+1),ndecs)
					nTit1 -= (nSaldo)
					nTit2 -= (nSaldo+nJuros)
					nMesTit0 -= Round(NoRound( xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,mv_par15,SE1->E1_EMISSAO,ndecs+1,Iif(MV_PAR39==2,Iif(!Empty(SE1->E1_TXMOEDA),SE1->E1_TXMOEDA,RecMoeda(SE1->E1_EMISSAO,SE1->E1_MOEDA)),0)),ndecs+1),ndecs)
					nMesTit1 -= (nSaldo)
					nMesTit2 -= (nSaldo+nJuros)
					nTotJur  -= nJuros
					nMesTitj -= nJuros
					nTotFilJ -= nJuros
				Else
					If !SE1->E1_TIPO $ MVABATIM
						nTit0 += Round(NoRound(xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,mv_par15,SE1->E1_EMISSAO,ndecs+1,Iif(MV_PAR39==2,Iif(!Empty(SE1->E1_TXMOEDA),SE1->E1_TXMOEDA,RecMoeda(SE1->E1_EMISSAO,SE1->E1_MOEDA)),0)),ndecs+1),ndecs)						
						nTit1 += (nSaldo) + nAbatim
						nTit2 += (nSaldo+nJuros) + nAbatim
						nMesTit0 += Round(NoRound(xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,mv_par15,SE1->E1_EMISSAO,ndecs+1,Iif(MV_PAR39==2,Iif(!Empty(SE1->E1_TXMOEDA),SE1->E1_TXMOEDA,RecMoeda(SE1->E1_EMISSAO,SE1->E1_MOEDA)),0)),ndecs+1),ndecs)
						nMesTit1 += (nSaldo)
						nMesTit2 += (nSaldo+nJuros)
						nTotJur  += nJuros
						nMesTitj += nJuros
						nTotFilJ += nJuros
					Endif	
				Endif
			Else	//A vencer
				If mv_par19 == 1 //1 = Analitico - 2 = Sintetico
					nTitVlrAtu := nSaldo * If(SE1->E1_TIPO$MV_CRNEG+"/"+MVRECANT+"/"+MVABATIM, -1,1)
					@li,148 PSAY nTitVlrAtu Picture TM(nTitVlrAtu,16,nDecs)
					_cTitVlrAtu := lTrim( Transform( nTitVlrAtu,"@E 999,999,999.99" ) )
				EndIf
				If ! ( SE1->E1_TIPO $ MVRECANT+"/"+MV_CRNEG+"/"+MVABATIM)
					nTit0 += Round(NoRound(xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,mv_par15,SE1->E1_EMISSAO,ndecs+1,Iif(MV_PAR39==2,Iif(!Empty(SE1->E1_TXMOEDA),SE1->E1_TXMOEDA,RecMoeda(SE1->E1_EMISSAO,SE1->E1_MOEDA)),0)),ndecs+1),ndecs)
					nTit3 += (nSaldo-nTotAbat)
					nTit4 += (nSaldo-nTotAbat)
					nMesTit0 += Round(NoRound(xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,mv_par15,SE1->E1_EMISSAO,ndecs+1,Iif(MV_PAR39==2,Iif(!Empty(SE1->E1_TXMOEDA),SE1->E1_TXMOEDA,RecMoeda(SE1->E1_EMISSAO,SE1->E1_MOEDA)),0)),ndecs+1),ndecs)
					nMesTit3 += (nSaldo-nTotAbat)
					nMesTit4 += (nSaldo-nTotAbat)
				ElseIF ( SE1->E1_TIPO $ MVRECANT+"/"+MV_CRNEG ) .or. (mv_par33 == 1 .and. SE1->E1_TIPO $ MVABATIM) 
					nTit0 -= Round(NoRound(xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,mv_par15,SE1->E1_EMISSAO,ndecs+1,Iif(MV_PAR39==2,Iif(!Empty(SE1->E1_TXMOEDA),SE1->E1_TXMOEDA,RecMoeda(SE1->E1_EMISSAO,SE1->E1_MOEDA)),0)),ndecs+1),ndecs)
					nTit3 -= (nSaldo-nTotAbat)
					nTit4 -= (nSaldo-nTotAbat)
					nMesTit0 -= Round(NoRound(xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,mv_par15,SE1->E1_EMISSAO,ndecs+1,Iif(MV_PAR39==2,Iif(!Empty(SE1->E1_TXMOEDA),SE1->E1_TXMOEDA,RecMoeda(SE1->E1_EMISSAO,SE1->E1_MOEDA)),0)),ndecs+1),ndecs)
					nMesTit3 -= (nSaldo-nTotAbat)
					nMesTit4 -= (nSaldo-nTotAbat)
				Endif
			Endif
			
			If mv_par19 == 1 //1 = Analitico - 2 = Sintetico
				@ li, 168 PSAY Substr(SE1->E1_NUMBCO,1,15)
				_cNumBanco := AllTrim(Substr(SE1->E1_NUMBCO,1,TamSx3("E1_NUMBCO")[1]))
			EndIf
			If nJuros > 0
				If mv_par19 == 1 //1 = Analitico - 2 = Sintetico
					@ Li,182 PSAY nJuros Picture Tm(nJuros, 16,nDecs)//PesqPict("SE1","E1_JUROS",16,MV_PAR15)
					_cJuros := Transform(nJuros,"@E 999,999,999.99")
				EndIf
				nJuros := 0
			Endif
			
			IF dDataBase > SE1->E1_VENCREA .And. !(SE1->E1_TIPO $ MVRECANT+"/"+MV_CRNEG)
				nAtraso:=dDataBase-SE1->E1_VENCTO
				IF Dow(SE1->E1_VENCTO) == 1 .Or. Dow(SE1->E1_VENCTO) == 7
					IF Dow(dBaixa) == 2 .and. nAtraso <= 2
						nAtraso := 0
					EndIF
				EndIF
				nAtraso := IIF(nAtraso<0,0,nAtraso)
				IF nAtraso>0
					If mv_par19 == 1 //1 = Analitico - 2 = Sintetico
						@li ,200 PSAY nAtraso Picture "99999"
						_cDiasAtraso := Transform(nAtraso,"99999")
					EndIf
				EndIF
			Else
				If !(SE1->E1_TIPO $ MVRECANT+"/"+MV_CRNEG)
					nAtraso:=dDataBase-if(dDataBase==SE1->E1_VENCREA,SE1->E1_VENCREA,SE1->E1_VENCTO)
					nAtraso:=If(nAtraso<0,0,nAtraso)					
				Else
					nAtraso:=0
				EndIf						
				If mv_par19 == 1 //1 = Analitico - 2 = Sintetico
					@li ,200 PSAY nAtraso Picture "99999"
					_cDiasAtraso := lTrim(Transform(nAtraso,"99999"))
				EndIf	
			EndIF
			If mv_par19 == 1 //1 = Analitico - 2 = Sintetico
				@li,206 PSAY SubStr(SE1->E1_HIST,1,14)//+SE1->E1_ORIGPV
					
					_CPEDIDO := SE1->E1_PEDIDO
					_CPEDGAR := SE1->E1_PEDGAR
					_CPEDSITE:= SE1->E1_XNPSITE
					
				IF .NOT. Empty(SE1->E1_XNUMVOU)
					SZF->( dbSetOrder(1) )
					SZF->( dbSeek( xFilial('SZF') + SE1->E1_XFLUVOU + SE1->E1_XNUMVOU ) )
					//COD VOUCHER | FLUXO VOUCHER | TIPO VOUCHER | CLIENTE VOUCHER | PRODUTO GAR | PRODUTO VOUCHER
					_cVoucher  := Alltrim(SZF->ZF_COD)
					_cFluxoVou := Alltrim(SZF->ZF_CODFLU)
					_cTipoVou  := Alltrim(SZF->ZF_TIPOVOU)
					IF _cTipoVou == 'F'
						_cCliVou  := SZF->ZF_CODCLI
						_cCliNome := Alltrim( STRTRAN( Posicione( 'SA1',1,xFilial('SA1') + SZF->(ZF_CODCLI+ZF_LOJCLI), "A1_NOME" ), ';', '' ) )
					EndIF
					_cProdGar  := Alltrim(SZF->ZF_PDESGAR)
					_cDProGar  := Alltrim( Posicione( 'PA8',1,xFilial('PA8') + SZF->ZF_PDESGAR, "PA8_DESBPG" ) )
					_cProdVou  := Alltrim(SZF->ZF_PRODEST)
				EndIF
				_cHistorico := Alltrim(SE1->E1_HIST)
			EndIf
			
			If mv_par19 == 1 //1 = Analitico - 2 = Sintetico
				cCodVend := SE1->E1_VEND1
				SA3->(DbSetOrder(1)) // Filial + Codigo
				SA3->(DbSeek( xfilial("SA3")+ Alltrim(cCodVend) ))
					_cVendedor := Rtrim(SA3->A3_NOME)
				SA3->(DbCloseArea())	
			EndIf
			
			cDado += _cCodCli + ';' +  _cLojCli + ';' +  _cNomCli + ';' +  _cPrefixo + ';' +  _cTitulo + ';' +  _cParcela + ';' +  _cTipoTit + ';' +;  
			         _cNatureza + ';' +  _cEmissao + ';' +  _cVecto + ';' + _cVectoReal + ';' +  _cBanco + ';' +  _cValorOri + ';' +  _cTitVenc + ';' +;
			         _cTitVcorri + ';' +  _cTitVlrAtu + ';' + _cJuros + ';' + _cNumBanco + ';' +  _cVendedor + ';' +  _cDiasAtraso + ';' + _cHistorico + ';' +; 
			         CHR(160)+_cVoucher + ';' + _cFluxoVou + ';' + _cTipoVou + ';' + _cCliVou + ';' + _cCliNome + ';' +  _cProdGar + ';' + _cDProGar + ';' +; 
			         _cProdVou  + ';' +  _CPEDIDO  + ';' + 	_CPEDGAR  + ';' + 	_CPEDSITE+ ';' + _cOs + ';'+ CRLF  
   			nConta += 1
   			
   			
   			_cCodCli := _cLojCli := _cNomCli := _cPrefixo := _cTitulo := _cParcela := _cTipoTit := _cNatureza := _cEmissao := _cVecto := ''
			_cVectoReal := _cBanco := _cValorOri := _cTitVenc := _cTitVcorri := _cTitVlrAtu := _cNumBanco := _cVendedor := _cDiasAtraso := '' 
			_cHistorico := _cVoucher := _cFluxoVou := _cTipoVou := _cCliVou := _cCliNome := _cProdGar := _cProdVou := _cDProGar := ''
			_CPEDIDO :=  _CPEDGAR :=  _CPEDSITE := _cOs := ''
			             
			//����������������������������������������Ŀ
			//� Carrega data do registro para permitir �
			//� posterior an�lise de quebra por mes.   �
			//������������������������������������������
			dDataAnt := Iif(nOrdem == 6, SE1->E1_EMISSAO, Iif(mv_par40 = 2, SE1->E1_VENCTO, SE1->E1_VENCREA))
			dbSelectArea("SE1")
			dbSkip()
			nTotTit ++
			nMesTTit ++
			nTotFiltit++
			nTit5 ++
			If mv_par19 == 1 //1 = Analitico - 2 = Sintetico
				li++
			EndIf
			
			//Renato Ruy - 28/03/2017
			//Alteracao para agilizar a gravacao dos dados.
			If nConta == 500 .Or. Eof()
   				FWrite( nHdl, cDado )
   				nConta := 0
   				cDado  := ""
			Endif
			
		Enddo

		If nOrdem == 3 .Or. nOrdem == 9
			SA6->(dbSeek(xFilial()+cCarAnt))
		EndIf
			
		IF nTit5 > 0 .and. nOrdem != 2 .and. nOrdem != 10
			SubTot130(nTit0,nTit1,nTit2,nTit3,nTit4,nOrdem,cCarAnt,nTotJur,nDecs)
			If mv_par19 == 1 //1 = Analitico - 2 = Sintetico
				Li++
			EndIf
		Endif
		
		//����������������������������������������Ŀ
		//� Verifica quebra por m�s	  			   �
		//������������������������������������������
		lQuebra := .F.
		If nOrdem == 4  .and. (Month(Iif(mv_par40 = 2, SE1->E1_VENCTO, SE1->E1_VENCREA)) # Month(dDataAnt) .or. Iif(mv_par40 = 2, SE1->E1_VENCTO, SE1->E1_VENCREA) > mv_par10)
			lQuebra := .T.
		Elseif nOrdem == 6 .and. (Month(SE1->E1_EMISSAO) # Month(dDataAnt) .or. SE1->E1_EMISSAO > mv_par14)
			lQuebra := .T.
		Endif
		If lQuebra .and. nMesTTit # 0
			ImpMes130(nMesTit0,nMesTit1,nMesTit2,nMesTit3,nMesTit4,nMesTTit,nMesTitJ,nDecs)
			nMesTit0 := nMesTit1 := nMesTit2 := nMesTit3 := nMesTit4 := nMesTTit := nMesTitj := 0
		Endif
		nTot0+=nTit0
		nTot1+=nTit1
		nTot2+=nTit2
		nTot3+=nTit3
		nTot4+=nTit4
		nTotJ+=nTotJur
		
		nTotFil0+=nTit0
		nTotFil1+=nTit1
		nTotFil2+=nTit2
		nTotFil3+=nTit3
		nTotFil4+=nTit4
		Store 0 To nTit0,nTit1,nTit2,nTit3,nTit4,nTit5,nTotJur,nTotAbat
	Enddo

	dbSelectArea("SE1")		// voltar para alias existente, se nao, nao funciona
	
	//����������������������������������������Ŀ
	//� Imprimir TOTAL por filial somente quan-�
	//� do houver mais do que 1 filial.        �
	//������������������������������������������
	if mv_par21 == 1 .and. SM0->(Reccount()) > 1
		ImpFil130(nTotFil0,nTotFil1,nTotFil2,nTotFil3,nTotFil4,nTotFiltit,nTotFilJ,nDecs)
	Endif
	Store 0 To nTotFil0,nTotFil1,nTotFil2,nTotFil3,nTotFil4,nTotFilTit,nTotFilJ
	If Empty(xFilial("SE1"))
		Exit
	Endif
	
	#IFDEF TOP
		dbSelectArea("SE1")
		dbCloseArea()
		ChKFile("SE1")
		dbSelectArea("SE1")
		dbSetOrder(1)
	#ENDIF

	dbSelectArea("SM0")
	dbSkip()
Enddo

SM0->(dbGoTo(nRegSM0))
cFilAnt := IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL )

If ( MV_PAR37 == 2 ) .Or. ( MV_PAR37 == 3 )
	DelProc(cAliasProc)
	cAliasProc := NIL
Endif

IF li != 80
	IF li > 58
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,GetMv("MV_COMP"))
	EndIF
	TotGer130(nTot0,nTot1,nTot2,nTot3,nTot4,nTotTit,nTotJ,nDecs)
	Roda(cbcont,cbtxt,"G")
EndIF

Set Device To Screen

CONOUT( "["+ "CSFIN030 > AGING" + " - " + Dtoc( date() ) + " - " + time() + " ] " + "GERACAO EXCEL" )

Sleep(500)
	
FClose( nHdl )

IF File( cPath + cNameFile )
	Ferase( cPath + cNameFile)
EndIF		

Sleep(500)

lRet := __CopyFile( cNameFile, cPath + cNameFile )

IF lRet
	Sleep(500)
	
	Ferase( cDir + cNameFile)
	
	IF ! ApOleClient("MsExcel") 
		MsgAlert("MsExcel n�o instalado. Para abrir o arquivo, localize-o na pasta %temp% .","Confer�ncia Aging")
	Else
		ShellExecute( "Open", cPath + cNameFile , '', '', 1 )
	EndIF
Else
	MsgAlert('N�o foi poss�vel copiar o arquivo para a pasta %temp%, o arquivo encontra-se no diret�rio [' + cDir + cNameFile + '] ;' + CRLF +;
	         'Verifique com Sistemas Corporativos.','Confer�ncia Aging')
EndIF

#IFNDEF TOP
	dbSelectArea("SE1")
	dbClearFil()
	RetIndex( "SE1" )
	If !Empty(cIndexSE1)
		FErase (cIndexSE1+OrdBagExt())
	Endif
	dbSetOrder(1)
#ELSE
	dbSelectArea("SE1")
	dbCloseArea()
	ChKFile("SE1")
	dbSelectArea("SE1")
	dbSetOrder(1)
#ENDIF

If aReturn[5] = 1
	Set Printer TO
	dbCommitAll()
	Ourspool(wnrel)
Endif
MS_FLUSH()
SET CENTURY ON

If lShowQry
	A030ShowQry( cShowQry )
EndIF

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 �SubTot130 � Autor � Paulo Boschetti 		  � Data � 01.06.92 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Imprimir SubTotal do Relatorio										  ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe e � SubTot130()																  ���
�������������������������������������������������������������������������Ĵ��
���Parametros�																				  ���
�������������������������������������������������������������������������Ĵ��
��� Uso 	    � Generico																	  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function SubTot130(nTit0,nTit1,nTit2,nTit3,nTit4,nOrdem,cCarAnt,nTotJur,nDecs)

Local cCarteira := " "
Local lFR130Tel := ExistBlock("FR130TELC")
Local cCampoCli := ""
Local cTelefone := ""

If lFR130Tel
	cCampoCli := ExecBlock("FR130TELC",.F.,.F.)
	If !SA1->(FieldPos(cCampoCli)) > 0
		cCampoCli := ""
	EndIf
EndIf

cTelefone := Alltrim(Transform(SA1->A1_DDD, PesqPict("SA1","A1_DDD"))+"-"+ Iif(!Empty(cCampoCli),Transform(SA1->(&cCampocli),PesqPict("SA1",cCampoCli)),TransForm(SA1->A1_TEL,PesqPict("SA1","A1_TEL")) ) )

DEFAULT nDecs := Msdecimais(mv_par15)

If mv_par19 == 1 //1 = Analitico - 2 = Sintetico
	li++
EndIf
IF li > 58
	nAtuSM0 := SM0->(Recno())
	SM0->(dbGoto(nRegSM0))
	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,GetMv("MV_COMP"))
	SM0->(dbGoTo(nAtuSM0))
EndIF
If nOrdem = 1
	@li,000 PSAY IIF(mv_par29 == 1,Substr(SA1->A1_NREDUZ,1,40),Substr(SA1->A1_NOME,1,40))+" "+ cTelefone + " "+ STR0054 + Right(cCarAnt,2)+Iif(mv_par21==1,STR0055+cFilAnt + " - " + Alltrim(SM0->M0_FILIAL),"") //"Loja - "###" Filial - "
Elseif nOrdem == 4 .or. nOrdem == 6
	@li,000 PSAY OemToAnsi(STR0037)  // "S U B - T O T A L ----> "
	@li,028 PSAY cCarAnt
	@li,PCOL()+2 PSAY Iif(mv_par21==1,cFilAnt+ " - " + Alltrim(SM0->M0_FILIAL),"  ")
Elseif nOrdem = 3
	@li,000 PSAY OemToAnsi(STR0037)  // "S U B - T O T A L ----> "
	@li,028 PSAY Iif(Empty(SA6->A6_NREDUZ),OemToAnsi(STR0029),SA6->A6_NREDUZ) + " " + Iif(mv_par21==1,cFilAnt+ " - " + Alltrim(SM0->M0_FILIAL),"")
ElseIf nOrdem == 5
	dbSelectArea("SED")
	dbSeek(cFilial+cCarAnt)
	@li,000 PSAY OemToAnsi(STR0037)  // "S U B - T O T A L ----> "
	@li,028 PSAY cCarAnt + " "+Substr(ED_DESCRIC,1,50) + " " + Iif(mv_par21==1,cFilAnt+ " - " + Alltrim(SM0->M0_FILIAL),"")
	dbSelectArea("SE1")
Elseif nOrdem == 7
	@li,000 PSAY OemToAnsi(STR0037)  // "S U B - T O T A L ----> "
	@li,028 PSAY SubStr(cCarAnt,7,2)+"/"+SubStr(cCarAnt,5,2)+"/"+SubStr(cCarAnt,3,2)+" - "+SubStr(cCarAnt,9,3) + " " +Iif(mv_par21==1,cFilAnt+ " - " + Alltrim(SM0->M0_FILIAL),"")
ElseIf nOrdem = 8
	@li,000 PSAY SA1->A1_COD+" "+Substr(SA1->A1_NOME,1,40)+" "+ cTelefone + " " + Iif(mv_par21==1,cFilAnt+ " - " + Alltrim(SM0->M0_FILIAL),"")
ElseIf nOrdem = 9
	cCarteira := Situcob(cCarAnt)
	@li,000 PSAY SA6->A6_COD+" "+SA6->A6_NREDUZ + SubStr(cCarteira,1,2) + " "+SubStr(cCarteira,3,20) + " " + Iif(mv_par21==1,cFilAnt+ " - " + Alltrim(SM0->M0_FILIAL),"")
Endif
If mv_par19 == 1 //1 = Analitico - 2 = Sintetico
	@li,102 PSAY nTit0		  Picture TM(nTit0,16,nDecs)
Endif 
@li,116 PSAY nTit1		  Picture TM(nTit1,16,nDecs)
@li,133 PSAY nTit2		  Picture TM(nTit2,16,nDecs)
@li,149 PSAY nTit3		  Picture TM(nTit3,16,nDecs)
If nTotJur > 0
	@li,182 PSAY nTotJur  Picture TM(nTotJur,16,nDecs)
Endif
@li,200 PSAY nTit2+nTit3 Picture TM(nTit2+nTit3,16,nDecs)

li++
If (nOrdem = 1 .Or. nOrdem == 8) .And. mv_par35 == 1 // Salta pag. por cliente
	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,GetMv("MV_COMP"))
Endif
Return .T.

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 � TotGer130� Autor � Paulo Boschetti       � Data � 01.06.92 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Imprimir total do relatorio										  ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe e � TotGer130()																  ���
�������������������������������������������������������������������������Ĵ��
���Parametros�																				  ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico																	  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
STATIC Function TotGer130(nTot0,nTot1,nTot2,nTot3,nTot4,nTotTit,nTotJ,nDecs)

Local _cTot0 := _cTot1 := _cTot2 := _cTot3 := _cTotJ := _cTotal := ''
DEFAULT nDecs := Msdecimais(mv_par15)

li++
IF li > 58
	nAtuSM0 := SM0->(Recno())
	SM0->(dbGoto(nRegSM0))
	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,GetMv("MV_COMP"))
	SM0->(dbGoTo(nAtuSM0))
EndIF

@li,000 PSAY OemToAnsi(STR0038) //"T O T A L   G E R A L ----> " + " " + Iif(mv_par21==1,cFilAnt,"")
@li,028 PSAY "("+ALLTRIM(STR(nTotTit))+" "+IIF(nTotTit > 1,OemToAnsi(STR0039),OemToAnsi(STR0040))+")"		//"TITULOS"###"TITULO"
If mv_par19 == 1 //1 = Analitico - 2 = Sintetico
	@li,102 PSAY nTot0		  Picture TM(nTot0,16,nDecs)
Endif
@li,116 PSAY nTot1		  Picture TM(nTot1,16,nDecs)
@li,133 PSAY nTot2		  Picture TM(nTot2,16,nDecs)
@li,149 PSAY nTot3		  Picture TM(nTot3,16,nDecs)
@li,182 PSAY nTotJ		  Picture TM(nTotJ,16,nDecs)
@li,200 PSAY nTot2+nTot3 Picture TM(nTot2+nTot3,16,nDecs)

_cTot0  := Transform(nTot0,"@E 999,999,999.99") 
_cTot1  := Transform(nTot1,"@E 999,999,999.99")
_cTot2  := Transform(nTot2,"@E 999,999,999.99")
_cTot3  := Transform(nTot3,"@E 999,999,999.99")
_cTotJ  := Transform(nTotJ,"@E 999,999,999.99")
_cTotal := Transform(nTot2+nTot3,"@E 999,999,999.99")

cDado := '' + CRLF
cDado += OemToAnsi(STR0038) + "("+ALLTRIM(STR(nTotTit))+" "+IIF(nTotTit > 1,OemToAnsi(STR0039),OemToAnsi(STR0040))+")" + ';' + ';' + ';' + ';' +; 
		';' + ';' + ';' + ';' + ';' + ';' + ';' + ';' + _cTot0 + ';' + _cTot1 + ';' + _cTot2 + ';' + _cTot3 + ';' + _cTotJ + ';' + ';' + ';' +; 
		';' + _cTotal

FWrite( nHdl, cDado + CRLF )

li++
li++
Return .T.

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 �ImpMes130 � Autor � Vinicius Barreira	  � Data � 12.12.94 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �IMPRIMIR TOTAL DO RELATORIO - QUEBRA POR MES					  ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe e � ImpMes130() 															  ���
�������������������������������������������������������������������������Ĵ��
���Parametros� 																			  ���
�������������������������������������������������������������������������Ĵ��
��� Uso		 � Generico 																  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
STATIC Function ImpMes130(nMesTot0,nMesTot1,nMesTot2,nMesTot3,nMesTot4,nMesTTit,nMesTotJ,nDecs)

DEFAULT nDecs := Msdecimais(mv_par15)
li++
IF li > 58
	nAtuSM0 := SM0->(Recno())
	SM0->(dbGoto(nRegSM0))
	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,GetMv("MV_COMP"))
	SM0->(dbGoTo(nAtuSM0))
EndIF
@li,000 PSAY OemToAnsi(STR0041)  //"T O T A L   D O  M E S ---> "
@li,028 PSAY "("+ALLTRIM(STR(nMesTTit))+" "+IIF(nMesTTit > 1,OemToAnsi(STR0039),OemToAnsi(STR0040))+")"  //"TITULOS"###"TITULO"
If mv_par19 == 1 //1 = Analitico - 2 = Sintetico
	@li,102 PSAY nMesTot0   Picture TM(nMesTot0,16,nDecs)
Endif
@li,116 PSAY nMesTot1	Picture TM(nMesTot1,16,nDecs)
@li,133 PSAY nMesTot2	Picture TM(nMesTot2,16,nDecs)
@li,149 PSAY nMesTot3	Picture TM(nMesTot3,16,nDecs)
@li,182 PSAY nMesTotJ	Picture TM(nMesTotJ,16,nDecs)
@li,200 PSAY nMesTot2+nMesTot3 Picture TM(nMesTot2+nMesTot3,16,nDecs)
li+=2
Return(.T.)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 � ImpFil130� Autor � Paulo Boschetti  	  � Data � 01.06.92 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Imprimir total do relatorio										  ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe e � ImpFil130()																  ���
�������������������������������������������������������������������������Ĵ��
���Parametros�																				  ���
�������������������������������������������������������������������������Ĵ��
��� Uso 	    � Generico																	  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
STATIC Function ImpFil130(nTotFil0,nTotFil1,nTotFil2,nTotFil3,nTotFil4,nTotFilTit,nTotFilJ,nDecs,nOrdem)

DEFAULT nDecs := Msdecimais(mv_par15)

li++
IF li > 58
	nAtuSM0 := SM0->(Recno())
	SM0->(dbGoto(nRegSM0))
	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,GetMv("MV_COMP"))
	SM0->(dbGoTo(nAtuSM0))
EndIF
@li,000 PSAY OemToAnsi(STR0043)+" "+Iif(mv_par21==1,cFilAnt+" - " + AllTrim(SM0->M0_FILIAL),"")  //"T O T A L   F I L I A L ----> "
If mv_par19 == 1 //1 = Analitico - 2 = Sintetico
	@li,102 PSAY nTotFil0        Picture TM(nTotFil0,16,nDecs)
Endif
@li,116 PSAY nTotFil1        Picture TM(nTotFil1,15,nDecs)
@li,132 PSAY nTotFil2        Picture TM(nTotFil2,15,nDecs)
@li,149 PSAY nTotFil3        Picture TM(nTotFil3,15,nDecs)
@li,182 PSAY nTotFilJ		  Picture TM(nTotFilJ,15,nDecs)
@li,200 PSAY nTotFil2+nTotFil3 Picture TM(nTotFil2+nTotFil3,15,nDecs)
li+=2
Return .T.

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 �fr130Indr � Autor � Wagner           	  � Data � 12.12.94 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Monta Indregua para impressao do relat�rio						  ���
�������������������������������������������������������������������������Ĵ��
��� Uso		 � Generico 																  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function fr130IndR()
Local cString

cString := 'SE1->E1_FILIAL=="'+xFilial("SE1")+'".And.'
cString += 'SE1->E1_CLIENTE>="'+mv_par01+'".and.SE1->E1_CLIENTE<="'+mv_par02+'".And.'
cString += 'SE1->E1_PREFIXO>="'+mv_par03+'".and.SE1->E1_PREFIXO<="'+mv_par04+'".And.'
cString += 'SE1->E1_NUM>="'+mv_par05+'".and.SE1->E1_NUM<="'+mv_par06+'".And.'
cString += 'DTOS('+Iif(mv_par40 = 2, 'SE1->E1_VENCTO', 'SE1->E1_VENCREA')+')>="'+DTOS(mv_par09)+'".And.'
cString += 'DTOS('+Iif(mv_par40 = 2, 'SE1->E1_VENCTO', 'SE1->E1_VENCREA')+')<="'+DTOS(mv_par10)+'".And.'
cString += '(SE1->E1_MULTNAT == "1" .OR. (SE1->E1_NATUREZ>="'+mv_par11+'".and.SE1->E1_NATUREZ<="'+mv_par12+'")).And.'
cString += 'DTOS(SE1->E1_EMISSAO)>="'+DTOS(mv_par13)+'".and.DTOS(SE1->E1_EMISSAO)<="'+DTOS(mv_par14)+'"'
If !Empty(mv_par31) // Deseja imprimir apenas os tipos do parametro 31
	cString += '.And.SE1->E1_TIPO$"'+mv_par31+'"'
ElseIf !Empty(Mv_par32) // Deseja excluir os tipos do parametro 32 
	cString += '.And. !(Alltrim(SE1->E1_TIPO) $ "'+ ALLTRIM(MV_PAR32)+'")'
EndIf
IF mv_par34 == 1  // Apenas titulos que estarao no fluxo de caixa
	cString += '.And.(SE1->E1_FLUXO!="N")'	
Endif
Return cString

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � PutDtBase� Autor � Mauricio Pequim Jr    � Data � 18/07/02 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Acerta parametro database do relatorio                     ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Finr130.prx                                                ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function PutDtBase()
Local _sAlias	:= Alias()

dbSelectArea("SX1")
dbSetOrder(1)
If MsSeek("FIN130    36")
	//Acerto o parametro com a database
	RecLock("SX1",.F.)
	Replace x1_cnt01		With "'"+DTOC(dDataBase)+"'"
	MsUnlock()	
Endif

dbSelectArea(_sAlias)
Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Situcob   �Autor  �Mauricio Pequim Jr. � Data �13.04.2005   ���
�������������������������������������������������������������������������͹��
���Desc.     �Retorna situacao de cobranca do titulo                      ���
�������������������������������������������������������������������������͹��
���Uso       � FINR130                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function SituCob(cCarAnt)

Local aSituaca := {}
Local aArea		:= GetArea()
Local cCart		:= " "

//���������������������������������'1'�������������������������������������Ŀ
//� Monta a tabela de situa��es de T�tulos										 �
//������������������������������������������������������������������������
dbSelectArea("SX5")
dbSeek(cFilial+"07")
While SX5->X5_FILIAL+SX5->X5_tabela == cFilial+"07"
	cCapital := Capital(X5Descri())
	AADD( aSituaca,{SubStr(SX5->X5_CHAVE,1,2),OemToAnsi(SubStr(cCapital,1,20))})
	dbSkip()
EndDo

nOpcS := (Ascan(aSituaca,{|x| Alltrim(x[1])== Substr(cCarAnt,4,1) }))
If nOpcS > 0
	cCart := aSituaca[nOpcS,1]+aSituaca[nOpcs,2]		
ElseIf Empty(SE1->E1_SITUACA)
	cCart := "0 "+STR0029
Endif
RestArea(aArea)
Return cCart

/*/
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Fun��o    � SumAbatPCC� Autor � Igor Franzoi			 � Data�19/12/2011 ���
��������������������������������������������������������������������������Ĵ��
���Descri��o � Soma os abatimentos do PCC em caso de saldo retroativo	   ���
��������������������������������������������������������������������������Ĵ��
���Uso       � Finr130.prx                                                 ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
/*/
Static Function SumAbatPCC(cPrefixo,cNumero,cParcela,dDataRef,cCodCli,cLoja,nMoeda)

Local cAlias	:= Alias()
Local nOrdem	:= indexord()
Local cQuery	:= ""
Local nTotPcc	:= 0

DEFAULT nMoeda	:= 1

#IFDEF TOP

	cQryAlias := GetNextAlias()

	cQuery	:= " SELECT E1_FILIAL, E1_PREFIXO, E1_NUM, E1_TIPO, E1_EMISSAO, E1_VALOR, E1_TXMOEDA, E1_MOEDA, E1_TITPAI, R_E_C_N_O_ RECNO "
	cQuery	+= " FROM "+RetSqlName("SE1")
	cQuery	+= " WHERE E1_FILIAL = '"+xFilial("SE1")+"' AND "
	cQuery	+= " E1_PREFIXO = '"+cPrefixo+"' AND "
	cQuery	+= " E1_NUM = '"+cNumero+"' AND "
	cQuery	+= " E1_CLIENTE = '"+cCodCli+"' AND "
	cQuery	+= " E1_LOJA = '"+cLoja+"' AND "
	cQuery	+= " E1_TIPO IN ('PIS','COF','CSL') AND "
	cQuery	+= " E1_EMISSAO <= '"+Dtos(dDataRef)+"' AND "
	cQuery	+= " D_E_L_E_T_ = ' ' "

	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cQryAlias , .F., .T.)

	While (cQryAlias)->( !Eof() )
		If FTITRAPAI((cQryAlias)->E1_TITPAI) //Verifica se o Titulo PAI e um RA e nao abate o PCC
			nTotPcc += xMoeda((cQryAlias)->E1_VALOR,(cQryAlias)->E1_MOEDA,nMoeda,dDataRef,,If(cPaisLoc=="BRA",(cQryAlias)->E1_TXMOEDA,0))
		EndIf
		(cQryAlias)->(dbSkip())		
	EndDo
	
	(cQryAlias)->(dbCloseArea())

#ELSE

	If Select("__SE1") == 0
		ChkFile("SE1",.F.,"__SE1")
	Else
		dbSelectArea("__SE1")
	EndIf
	
	dbSetOrder(1)
	dbSeek(xFilial("SE1")+cPrefixo+cNumero+cParcela)
	
	While ( !Eof() .and. E1_FILIAL == xFilial("SE1") .and. E1_PREFIXO == cPrefixo .and. E1_NUM == cNumero )
		If ( AllTrim(E1_CLIENTE) == AllTrim(cCodCli) .and. AllTrim(E1_LOJA) == AllTrim(cLoja) )
			If ( E1_TIPO $  "PIS/COF/CSL" .and. E1_EMISSAO <= dDataRef ) .AND. FTITRAPAI( E1_TITPAI) //Verifica se o Titulo PAI e um RA e nao abate o PCC
				nTotPcc += xMoeda(E1_VALOR,E1_MOEDA,nMoeda,dDataRef,,If(cPaisLoc=="BRA",E1_TXMOEDA,0))
			EndIf
		EndIf
		dbSkip()
	EndDo
	
#ENDIF

DbSelectArea(cAlias)
DbSetOrder(nOrdem)

Return(nTotPcc)

/*/
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Fun��o    � SumPCC130� Autor � Igor Franzoi			 � Data�19/12/2011 ���
��������������������������������������������������������������������������Ĵ��
���Descri��o � Soma os abatimentos do PCC em caso de saldo retroativo	   ���
��������������������������������������������������������������������������Ĵ��
���Uso       � Finr130.prx                                                 ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
/*/
Static Function SumPCC130(cPrefixo,cNumero,cParcela,dDataRef,cCodCli,cLoja,nMoeda)

Local cAlias	:= Alias()
Local nOrdem	:= indexord()

Local nTotPcc	:= 0

Default nMoeda	:= 1

cQryAlias := GetNextAlias()

cCondSE1 := "% E1_FILIAL = '"+xFilial("SE1")+"' AND "
cCondSE1 += " E1_PREFIXO = '"+cPrefixo+"' AND "
cCondSE1 += " E1_NUM = '"+cNumero+"' AND "
cCondSE1 += " E1_CLIENTE = '"+cCodCli+"' AND "
cCondSE1 += " E1_LOJA = '"+cLoja+"' AND "
cCondSE1 += " E1_TIPO IN ('PIS','COF','CSL') AND "
cCondSE1 += " E1_EMISSAO <= '"+Dtos(dDataRef)+"' %"

BeginSql alias cQryAlias
	SELECT E1_FILIAL, E1_PREFIXO, E1_NUM, E1_TIPO, E1_EMISSAO, E1_VALOR, E1_TXMOEDA, E1_MOEDA, R_E_C_N_O_ RECNO
	FROM %table:SE1% SE1
	WHERE 
	%exp:cCondSE1% AND SE1.%NotDel%
EndSql

While (cQryAlias)->( !Eof() )
	nTotPcc += xMoeda((cQryAlias)->E1_VALOR,(cQryAlias)->E1_MOEDA,nMoeda,dDataRef,,If(cPaisLoc=="BRA",(cQryAlias)->E1_TXMOEDA,0))
	(cQryAlias)->(dbSkip())		
EndDo

(cQryAlias)->(dbCloseArea())

DbSelectArea(cAlias)
DbSetOrder(nOrdem)

Return(nTotPcc)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �AjustaSX1 �Autor  �Raphael Zampieri    � Data �11.06.2008   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ajusta perguntas da tabela SX1                              ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � FINR130                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function AjustaSX1()

Local aArea := GetArea()
Local aHelpPor	:= {}
Local aHelpEng	:= {}
Local aHelpSpa	:= {}
Local aRegs		:= {}  
Local nTamTitSX3:= 0       
Local cGrupoSX3	:= ""


dbSelectArea("SX3")
dbSetOrder(2)
dbSeek("E1_NUM")     
nTamTitSX3	:= SX3->X3_TAMANHO
cGrupoSX3	:= SX3->X3_GRPSXG  
dbSetOrder(1)

//            cPerg	Ordem	PergPort         cPerSpa        cPerEng           cVar  Tipo     nTam	 1 2 3    4   cVar01  cDef01  cDefSpa1    cDefEng1    cCont01	        cVar02	   cDef02           cDefSpa2         cDefEng2   cCnt02 cVar03 cDef03   cDefSpa3  cDefEng3  	cCnt03	cVar04	cDef04  cDefSpa4  cDefEng4  cCnt04 	cVar05 	 cDef05	 cDefSpa5  cDefEng5	 cCnt05	 cF3	cGrpSxg  cPyme	 aHelpPor aHelpEng	aHelpSpa  cHelp
AAdd(aRegs,{"FIN130", "05","Do Titulo  ?","�De Titulo  ?","From Bill  ?",  "mv_ch5","C",nTamTitSX3,0,0,"G","","mv_tit_de","",      "",         "",         "",               "",        "",              "",              "",       "",    "",   "",        "",      "",       "",     "",    "",      "",        "",      "",     "",      "",     "",       "",      "",   "",   cGrupoSX3, "S",     "",      "",        "",     ""})
AAdd(aRegs,{"FIN130", "06","Ate o Titulo  ?","�A Titulo  ?","To Bill  ?",  "mv_ch6","C",nTamTitSX3,0,0,"G","","mv_tit_ate","",      "",         "",    "ZZZZZZZZZZZZZZZZZZZZ",          "",        "",              "",              "",       "",    "",   "",        "",      "",       "",     "",    "",      "",        "",      "",     "",      "",     "",       "",      "",   "",   cGrupoSX3, "S",     "",      "",        "",     ""})

ValidPerg(aRegs,"FIN130",.T.)

RestArea( aArea )
 
//Inclusao da pergunta: "Considera data - Vencimento ou Vencimento Real"
aHelpPor	:= {}
aHelpEng	:= {}
aHelpSpa	:= {}

Aadd( aHelpPor, "Informe a data de vencimento que ser� "  )
Aadd( aHelpPor, "considerada na impressao do relat�rio "  )

Aadd( aHelpSpa, "Informe la fecha de vencimiento que se "   )
Aadd( aHelpSpa, "considerar� en la impresi�n del informe. " )

Aadd( aHelpEng, "Enter expiration date to be considered "  )
Aadd( aHelpEng, "to print the report."                     )


PutSx1( "FIN130", "40","Considera data","Considera fecha","Consider date","mv_chv","N",1,0,1,"C","","","","",;
	"mv_par40","Vencimento Real","Venc. Real","Real Expiration","","Vencimento","Vencimiento","Expiration","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

//Ajuste da pergunta: "Considera Adiantam. ? - MV_PAR26"
aHelpPor	:= {}
aHelpEng	:= {}
aHelpSpa	:= {}

Aadd( aHelpPor, "Selecione a op��o �Sim� para que os " )
Aadd( aHelpPor, "t�tulos referentes a adiantamentos, " )
Aadd( aHelpPor, "cadastrados sob os tipos �RA e NCC� " )
Aadd( aHelpPor, "devam ser considerados na gera��o do" )
Aadd( aHelpPor, " relat�rio, ou �N�o�, caso contr�rio.")

Aadd( aHelpSpa, "Elija la opcion �Si� para que los ")
Aadd( aHelpSpa, "titulos referentes a anticipos, ")
Aadd( aHelpSpa, "registrados bajo los tipos �RA e NCC�")
Aadd( aHelpSpa, ", sean considerados en la generacion ")
Aadd( aHelpSpa, "del informe, o en caso contrario, ")
Aadd( aHelpSpa, "elija �No�.")                                  

Aadd( aHelpEng, "Select the option �Yes� so that the ")     
Aadd( aHelpEng, "bills related to the advances ")
Aadd( aHelpEng, "registered under the types �RA and ")
Aadd( aHelpEng, "NCC� can be considered in the report")
Aadd( aHelpEng, " generation, or �No�, otherwise.")

PutHelp("P.FIN13026.",aHelpPor,aHelpEng,aHelpSpa,.T.)               

aHelpPor	:= {}
aHelpEng	:= {}
aHelpSpa	:= {}

Aadd( aHelpPor, "Selecione a op��o �Sim� para que    " )
Aadd( aHelpPor, "sejam pesquisados movimentos em todas" )
Aadd( aHelpPor, "filiais para procurar compensacoes  " )
Aadd( aHelpPor, "entre filiais. Caso nao tenha estes " )
Aadd( aHelpPor, "movimentos, seleciona 'N�o'.        " )
Aadd( aHelpPor, "*Somente ambiente com SE5 exclusiva." )

Aadd( aHelpSpa, "Seleccione la opcion 'Si' para que  " )
Aadd( aHelpSpa, "se busquen los movimientos en todas " )
Aadd( aHelpSpa, "las sucursales para encontrar 		 " )
Aadd( aHelpSpa, "compensaciones entre sucursales.    " )
Aadd( aHelpSpa, "En caso de que existan estos        " )
Aadd( aHelpSpa, "movimientos, seleccione 'No'. Solo  ")
Aadd( aHelpSpa, "entorno con SE5 exclusiva." )

Aadd( aHelpEng, "Select option Yes so the transactions" )
Aadd( aHelpEng, "among branches as well as            " )
Aadd( aHelpEng, "compensations among branches are     " )
Aadd( aHelpEng, "searched. If there are no transactions" )
Aadd( aHelpEng, "select No. Only exclusive SES        " )
Aadd( aHelpEng, "environment.                         " )

PutSx1( "FIN130", "41","Compensa��o entre Filiais?","?Compensaciones sucursales?","Compensations branches?","mv_chx","N",1,0,2,"C","","","","",;
	"mv_par41","Sim","Si","Yes","","Nao","No","No","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)
	
Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � FR130RetNat �Autor � Gustavo Henrique  � Data � 25/05/10   ���
�������������������������������������������������������������������������͹��
���Descricao � Retorna codigo e descricao da natureza para quebra do      ���
���          � relatorio analitico por ordem de natureza.                 ���
�������������������������������������������������������������������������͹��
���Parametros� EXPC1 - Codigo da natureza para pesquisa                   ���
�������������������������������������������������������������������������͹��
���Uso       � Financeiro                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function FR130RetNat( cCodNat )

SED->( dbSetOrder( 1 ) )
SED->( MsSeek( xFilial("SED") + cCodNat ) )

Return( MascNat(SED->ED_CODIGO) + " - " + SED->ED_DESCRIC + If( mv_par21==1, cFilAnt + " - " + Alltrim(SM0->M0_FILIAL), "" ) )


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � FR130TotSoma �Autor � Gustavo Henrique � Data � 05/26/10   ���
�������������������������������������������������������������������������͹��
���Descricao � Totaliza somatoria da coluna (Vencidos+A Vencer) quando    ���
���          � selecionado relatorio por ordem de natureza e parametro    ���
���          � MV_MULNATR ativado.                                        ���
�������������������������������������������������������������������������͹��
���Uso       � Financeiro                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function FR130TotSoma( oTotCorr, oTotVenc, nTotVenc, nTotGeral, nOrdem )

nTotVenc	:= oTotCorr:GetValue() + oTotVenc:GetValue()

If nOrdem == 5 
	nTotGeral	+= nTotVenc
EndIf

Return .T.
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Rotina    �Fr135Cond �Autor  �Claudio D. de Souza � Data �  28/08/01   ���
�������������������������������������������������������������������������͹��
���Desc.     � Avalia condicoes para filtrar os registros que serao       ���
���          � impressos.                                                 ���
�������������������������������������������������������������������������͹��
���Uso       � FINR135                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function Fr130Cond(cTipos)
Local lRet := .T.
Local dDtContab 
Local dDtDigDis
Local aArea		:= getArea()
Local aResult	:= {}
Local lProc		:= cAliasProc <> Nil

DEFAULT _nTamSEQ	:= TAMSX3('E5_SEQ')[1]
// dDtContab para casos em que o campo E1_EMIS1 esteja vazio
dDtContab := Iif(Empty(SE1->E1_EMIS1),SE1->E1_EMISSAO,SE1->E1_EMIS1)

//��������������������������������������������������������������Ŀ
//� Filtrar com base no Pto de entrada do Usuario...             �
//����������������������������Jose Lucas, Localiza��es Argentina��
Do Case
Case !Empty(SE1->E1_BAIXA)
	If mv_par20 == 2 .and. SE1->E1_SALDO == 0
		lRet := .F.
	Elseif SE1->E1_SALDO == 0

		If ( MV_PAR37 == 1 ) .and. SE1->E1_BAIXA <= dDataBase
			lRet := .F.
		ElseIf (cDBType != "DB2") .AND. ( ( MV_PAR37 == 2 ) .Or. ( MV_PAR37 == 3 ) )
			If cAliasProc == NIL
				cAliasProc	:= getNextAlias()
				lProc := CriaProc(cAliasProc)
			Endif
			If lProc .AND. TCSPExist( cAliasProc )
				aResult := TCSPExec( cAliasProc , MV_PAR37, SE1->E1_FILIAL ,SE1->E1_PREFIXO ,SE1->E1_NUM ,;
								SE1->E1_PARCELA ,SE1->E1_TIPO ,SE1->E1_CLIENTE ,SE1->E1_LOJA )
		
				If !Empty(aResult)
					dDtDigDis := StoD(aResult[1])
					If dDtDigDis <= dDataBase
						lRet := .F.
					Endif
				Else
				    MsgInfo('Erro na execu��o da Stored Procedure : '+TcSqlError())
				    conout(TcSqlError())
				Endif
			Endif
		Endif
	Endif
//������������������������������������������������������Ŀ
//� Verifica se trata-se de abatimento ou somente titulos�
//� at� a data base. 									 �
//��������������������������������������������������������
Case (MV_PAR33 == 3 .AND. SE1->E1_TIPO $ MVABATIM +"/"+MVFUABT)
	lRet := .F.
//������������������������������������������������������Ŀ
//� Verifica se ser� impresso titulos provis�rios		   �
//��������������������������������������������������������
Case SE1->E1_TIPO $ MVPROVIS .and. mv_par16 == 2
	lRet := .F.
//������������������������������������������������������Ŀ
//� Verifica se ser� impresso titulos de Adiantamento	   �
//��������������������������������������������������������
Case SE1->E1_TIPO $ MVRECANT+"/"+MV_CRNEG .and. mv_par26 == 2
	lRet := .F.
Case !Empty(cTipos)
	If !(SE1->E1_TIPO $ cTipos)
	   lRet := .F.
	Endif
Case mv_par30 == 2 // nao imprime
	//����������������������������������������Ŀ
	//� Verifica se deve imprimir outras moedas�
	//������������������������������������������
	If SE1->E1_MOEDA != mv_par15 // verifica moeda do campo=moeda parametro
		lRet := .F.
	Endif
EndCase

RestArea(aArea)
	
Return lRet
    
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �F040RETIMP�Autor  � Totvs              � Data �  30/07/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � Efetua a validacao na exclusao do titulo                   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/ 
Static Function F130RETIMP(cFiltro)

Local aTitulos := {}
Local aAreaSE1	:= SE1->(GetArea())

dbSelectArea("SED")
dbSetOrder(1)
If DbSeek (xFilial("SED")+cFiltro)
	If SED->ED_CALCIRF=="S"	  	
     	AADD(aTitulos,{MVIRABT, .T.})
 	EndIf
   	If SED->ED_CALCINS=="S"
       	AADD(aTitulos,{MVINABT,.T.})
   	EndIf
 	If SED->ED_CALCPIS=="S"	 
    	 AADD(aTitulos,{MVPIABT,.T.})
 	EndIf
   	If SED->ED_CALCCOF=="S"	  	  	
     	AADD(aTitulos,{MVCFABT,.T.})
 	EndIf
   	If SED->ED_CALCCSL=="S"
     	AADD(aTitulos,{MVCSABT,.T.})
   	EndIf
 	If SED->ED_CALCISS=="S"	
     	AADD(aTitulos,{MVISABT,.T.})
	EndIf
EndIf

RestArea(aAreaSE1)

Return aTitulos

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FTITPAI   �Autor Leandro Sousa         � Data �  12/23/11   ���
�������������������������������������������������������������������������͹��
���Desc.     � Caso algum titulo de abatimento tenho o campo E1_TITPAI em ���
���          � branco a fun�ao ira preencher para o relatorio ficar correto��
�������������������������������������������������������������������������͹��
���Uso       � FINR130                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function FTITPAI()
Local aArea := GetArea()
Local aAreaSE1 := SE1->(GetArea())
Local cChave := xFilial("SE1")+SE1->(E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA)
Local cTitP 

DbSelectArea("__SE1")
dbSetOrder(2)
If DbSeek(cChave)
	While __SE1->(!Eof()) .and. cChave == xFilial("SE1")+__SE1->(E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA)
		If ! __SE1->E1_TIPO $ MVABATIM +"/"+MVFUABT
			CTitP := PADR(__SE1->(E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+E1_CLIENTE+E1_LOJA),TAMSX3('E1_TITPAI')[1])
			Exit
		EndIf	
	DbSkip()
	EndDo
EndIF

RestArea(aAreaSE1)            
RestArea(aArea)

Return cTitP

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FINR130   �Autor  �Microsiga           � Data �  05/11/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � Rotina que ira definir qual desconto sera levado em considera�
���          � �ao o registro da SE5 ou o campo da tabela SE1             ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

STATIC Function F130DESC()
Local lRet := .T.
Local aArea := GetArea()
Local cChave := SE1->(E1_PREFIXO + E1_NUM +E1_PARCELA +E1_TIPO +E1_CLIENTE +E1_LOJA )

dbSelectArea("SE5")
dbSetOrder(7) // filial + prefixo + numero + parcela + tipo + clifor + loja + sequencia
If DbSeek(xFilial("SE5")+cChave)
	While SE5->(!EOF()) .and. cChave == SE5->(E5_PREFIXO + E5_NUMERO +E5_PARCELA +E5_TIPO +E5_CLIENTE +E5_LOJA )
		If SE5->E5_TIPODOC == "DC" .and. (SE1->E1_DESCONT == SE5->E5_VALOR) .and. SE1->E1_DECRESC == 0
			lRet := .F.
		Endif
		SE5->(dbSkip())
	EndDo
Endif

RestArea(aArea)

Return lRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �F130TipoBA�Autor  �Microsiga           � Data �  13/08/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � Rotina para buscar na SE5 quando titulo eh tipo RA para    ���
���          � verificar a data de cancelamento que sera gravado no       ���
���          � campo E5_HIST entre ###[AAAAMMDD]### a fim de compor o     ���
���          � saldo adequadamente                                        ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/


STATIC Function F130TipoBA()
Local nPosDtCanc := 0
Local nValor := 0
Local aArea := GetArea()
Local cChave := SE1->(E1_PREFIXO + E1_NUM +E1_PARCELA +E1_TIPO +E1_CLIENTE +E1_LOJA )

dbSelectArea("SE5")
dbSetOrder(7) // filial + prefixo + numero + parcela + tipo + clifor + loja + sequencia
If DbSeek(xFilial("SE5")+cChave)
	While SE5->(!EOF()) .and. cChave == SE5->(E5_PREFIXO + E5_NUMERO +E5_PARCELA +E5_TIPO +E5_CLIENTE +E5_LOJA )
		If SE5->E5_TIPODOC == "BA" .and. E5_SITUACA = 'C'
			If ( nPosDtCanc := At("###[", SE5->E5_HISTOR) ) > 0
				If  SE5->E5_DATA <= MV_PAR36 .And. STOD(SUBS(SE5->E5_HISTOR, nPosDtCanc+4,8)) > MV_PAR36
					nValor := SE5->E5_VALOR
					Exit
				EndIf
			EndIf
		Endif
		SE5->(dbSkip())
	EndDo
Endif

RestArea(aArea)

Return nValor

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FTITRAPAI �Autor  �Telso Carneiro      � Data �  15/08/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � Verifica se o titulo de abatimento no campo E1_TITPAI e    ���
���          � RA                                                         ���
�������������������������������������������������������������������������͹��
���Uso       � FINR130                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function FTITRAPAI(cTITPAI)
Local aArea    := GetArea()
Local lRet     := .T.
Local nTamPref := 0
Local nTamNum  := 0
Local nTamParc := 0
Local nTamTipo := 0
Local cTipo    := "" 
//Controla o Pis Cofins e Csll na RA (1 = Controla reten��o de impostos no RA; ou 2 = N�o controla reten��o de impostos no RA(default))
Local lRaRtImp := If (FindFunction("FRaRtImp"),FRaRtImp(),.F.)

If !Empty(cTITPAI) .And. lRaRtImp
	nTamFil  := TAMSX3('E1_FILIAL')[1]
	nTamPref := TAMSX3('E1_PREFIXO')[1]
	nTamNum  := TAMSX3('E1_NUM')[1]
	nTamParc := TAMSX3('E1_PARCELA')[1]
	nTamTipo := TAMSX3('E1_TIPO')[1]
	cTipo    := Subs(cTITPAI,(1+nTamPref+nTamNum+nTamParc),nTamTipo)   
	
	If cTipo $ MVRECANT // Titulo pai e um RA
		lRet := .F.
	EndIf	
EndIf
RestArea(aArea)
            

Return lRet

Static Function CriaProc(cAliasProc)

Local __cTamFil := StrZero(TamSx3("E1_FILIAL")[1],3)
Local __cTamPre := StrZero(TamSx3("E1_PREFIXO")[1],3)
Local __cTamNum := StrZero(TamSx3("E1_NUM")[1],3)
Local __cTamPar := StrZero(TamSx3("E1_PARCELA")[1],3)
Local __cTamTip := StrZero(TamSx3("E1_TIPO")[1],3)
Local __cTamCli := StrZero(TamSx3("E1_CLIENTE")[1],3)
Local __cTamLoj := StrZero(TamSx3("E1_LOJA")[1],3)
Local __nTamSeqData  := ( TamSx3("E5_SEQ")[1] + 8)
Local __nTamSeq  := ( TamSx3("E5_SEQ")[1] )
Local __cTamSeqData  := StrZero( ( __nTamSeq + 8 ) ,3)
Local cQuery	:= ""
Local lOk		:= .T.
Local nPTratRec	:= 0

cQuery += "create procedure "+cAliasProc+" ("+CRLF
cQuery += "	@IN_TIPDATA	integer ,"+CRLF
cQuery += "	@IN_FILIAL	char(" 	+ __cTamFil + "),"+CRLF
cQuery += "	@IN_PREFIXO	char(" 	+ __cTamPre + "),"+CRLF
cQuery += "	@IN_NUMERO	char(" 	+ __cTamNum + "),"+CRLF
cQuery += "	@IN_PARCELA	char(" 	+ __cTamPar + "),"+CRLF
cQuery += "	@IN_TIPO	char(" 	+ __cTamTip + "),"+CRLF
cQuery += "	@IN_CLIENTE	char(" 	+ __cTamCli + "),"+CRLF
cQuery += "	@IN_LOJA	char(" 	+ __cTamLoj + "),"+CRLF
cQuery += "	@OUT_RET	char(8) output"+CRLF
cQuery += ") as"+CRLF
cQuery += " " + CRLF

cQuery += "Declare @cFilial Varchar(" 	+ __cTamFil + ")" + CRLF
cQuery += "Declare @cPrefixo Varchar(" 	+ __cTamPre + ")" + CRLF
cQuery += "Declare @cNumero Varchar(" 	+ __cTamNum + ")" + CRLF
cQuery += "Declare @cParcela Varchar(" 	+ __cTamPar + ")" + CRLF
cQuery += "Declare @cTipo Varchar(" 	+ __cTamTip + ")" + CRLF
cQuery += "Declare @cCliente Varchar(" 	+ __cTamCli + ")" + CRLF
cQuery += "Declare @cLoja Varchar(" 	+ __cTamLoj + ")" + CRLF
cQuery += "Declare @cRetSQLSE1 char(3)" + CRLF
cQuery += "Declare @cRetSQLSE5 char(3)" + CRLF
cQuery += "Declare @cSeqData Varchar("	+__cTamSeqData+")"+ CRLF

cQuery += " " + CRLF
cQuery += "Begin " + CRLF
cQuery += "   " + CRLF

cQuery += "   select @cFilial = @IN_FILIAL" + CRLF
cQuery += "   select @cPrefixo = @IN_PREFIXO " + CRLF
cQuery += "   select @cNumero = @IN_NUMERO" + CRLF
cQuery += "   select @cParcela = @IN_PARCELA" + CRLF
cQuery += "   select @cTipo = @IN_TIPO" + CRLF
cQuery += "   select @cCliente = @IN_CLIENTE" + CRLF
cQuery += "   select @cLoja = @IN_LOJA" + CRLF
cQuery += "   select @cSeqData = '"+SPACE(__nTamSeqData)+"'" + CRLF

cQuery += "   "+CRLF
cQuery += "		If @IN_TIPDATA = 2" + CRLF
cQuery += "   		SELECT @cSeqData = MAX(B.E5_SEQ || B.E5_DTDISPO) " + CRLF

cQuery += " 		FROM "+RetSqlName("SE1")+" SE1, "+RetSqlName("SE5")+" B "+ CRLF
cQuery += " 		WHERE SE1.E1_FILIAL =  @cFilial " + CRLF
cQuery += " 		AND SE1.E1_PREFIXO = @cPrefixo " + CRLF
cQuery += " 		AND SE1.E1_NUM = @cNumero " + CRLF
cQuery += " 		AND SE1.E1_PARCELA = @cParcela " + CRLF
cQuery += " 		AND SE1.E1_TIPO = @cTipo " + CRLF
cQuery += " 		AND SE1.E1_CLIENTE = @cCliente " + CRLF
cQuery += " 		AND SE1.E1_LOJA = @cLoja " + CRLF
cQuery += " 		AND SE1.D_E_L_E_T_ = ' '"+ CRLF
cQuery += " 		AND B.D_E_L_E_T_ = ' '"+ CRLF
cQuery += " 		AND B.E5_FILIAL = SE1.E1_FILIAL"+ CRLF
cQuery += " 		AND B.E5_PREFIXO = SE1.E1_PREFIXO"+ CRLF
cQuery += " 		AND B.E5_NUMERO = SE1.E1_NUM "+ CRLF
cQuery += " 		AND B.E5_PARCELA  = SE1.E1_PARCELA"+ CRLF
cQuery += " 		AND B.E5_TIPO  = SE1.E1_TIPO"+ CRLF
cQuery += " 		AND B.E5_CLIFOR  = SE1.E1_CLIENTE"+ CRLF
cQuery += " 		AND B.E5_LOJA  = SE1.E1_LOJA"+ CRLF
cQuery += " 		GROUP BY SE1.E1_FILIAL, SE1.E1_PREFIXO, SE1.E1_NUM , SE1.E1_PARCELA, SE1.E1_TIPO, SE1.E1_CLIENTE, SE1.E1_LOJA "+ CRLF

cQuery += " " + CRLF
cQuery += "		Else" + CRLF
cQuery += " " + CRLF
cQuery += " 		begin" + CRLF
cQuery += " " + CRLF

cQuery += "   		SELECT @cSeqData = MAX(B.E5_SEQ || B.E5_DTDISPO) " + CRLF
cQuery += " 		FROM "+RetSqlName("SE1")+" SE1, "+RetSqlName("SE5")+" B "+ CRLF
cQuery += " 		WHERE SE1.E1_FILIAL =  @cFilial " + CRLF
cQuery += " 		AND SE1.E1_PREFIXO = @cPrefixo " + CRLF
cQuery += " 		AND SE1.E1_NUM = @cNumero " + CRLF
cQuery += " 		AND SE1.E1_PARCELA = @cParcela " + CRLF
cQuery += " 		AND SE1.E1_TIPO = @cTipo " + CRLF
cQuery += " 		AND SE1.E1_CLIENTE = @cCliente " + CRLF
cQuery += " 		AND SE1.E1_LOJA = @cLoja " + CRLF
cQuery += " 		AND SE1.D_E_L_E_T_ = ' '"+ CRLF
cQuery += " 		AND B.D_E_L_E_T_ = ' '"+ CRLF
cQuery += " 		AND B.E5_FILIAL = SE1.E1_FILIAL"+ CRLF
cQuery += " 		AND B.E5_PREFIXO = SE1.E1_PREFIXO"+ CRLF
cQuery += " 		AND B.E5_NUMERO = SE1.E1_NUM "+ CRLF
cQuery += " 		AND B.E5_PARCELA  = SE1.E1_PARCELA"+ CRLF
cQuery += " 		AND B.E5_TIPO  = SE1.E1_TIPO"+ CRLF
cQuery += " 		AND B.E5_CLIFOR  = SE1.E1_CLIENTE"+ CRLF
cQuery += " 		AND B.E5_LOJA  = SE1.E1_LOJA"+ CRLF
cQuery += " 		GROUP BY SE1.E1_FILIAL, SE1.E1_PREFIXO, SE1.E1_NUM , SE1.E1_PARCELA, SE1.E1_TIPO, SE1.E1_CLIENTE, SE1.E1_LOJA "+ CRLF
cQuery += " " + CRLF
cQuery += " 		End" + CRLF

cQuery += "   select @OUT_RET = SUBSTRING( @cSeqData , " + STR(__nTamSeq+1) +","+__cTamSeqData+")" + CRLF

cQuery += "End" + CRLF

cQuery := CtbAjustaP(.T., cQuery, @nPTratRec)
cQuery := MsParse(cQuery,If(Upper(TcSrvType())= "ISERIES", "DB2", cDBType ) )
cQuery := CtbAjustaP(.F., cQuery, nPTratRec)

If !TCSPExist( cAliasProc )
	lOk := FinSqlExec(cQuery)
	If !lOk
		UserException( "Erro na cria��o da procedure " + CRLF + TCSqlError()  + CRLF + cStatement )  //
	Endif
EndIf

Return lOk


Static Function FinSqlExec( cStatement )
Local bBlock	:= ErrorBlock( { |e| ChecErro(e) } )
Local lRetorno := .T.

BEGIN SEQUENCE
	IF TcSqlExec(cStatement) <> 0
		UserException( "Erro na instru��o de execu��o SQL" + CRLF + TCSqlError()  + CRLF + cStatement )  //
		lRetorno := .F.
	Endif
RECOVER
	lRetorno := .F.
END SEQUENCE
ErrorBlock(bBlock)

Return lRetorno


STATIC Function	DelProc(cAliasProc)

FinSqlExec( "Drop procedure "+ cAliasProc )

Return

//-----------------------------------------------------------------------
// Rotina | A110Script | Autor | Rafael Beghini     | Data | 16.09.2015
//-----------------------------------------------------------------------
// Descr. | Rotina para apresentar o script de instru��o SQL na tela.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A030ShowQry( cSQL )
	Local cNomeArq := ''
	Local nHandle := 0
	Local lEmpty := .F.
	AutoGrLog('ativar para apagar')
	cNomeArq := NomeAutoLog()
	lEmpty := Empty( cNomeArq )
	If !lEmpty
		nHandle := FOpen( cNomeArq, 2 )
		FClose( nHandle )
		FErase( cNomeArq )
	Endif
	AutoGrLog( cSQL )
	MostraErro()
	If !lEmpty
		FClose( nHandle )
		FErase( cNomeArq )
	Endif
Return