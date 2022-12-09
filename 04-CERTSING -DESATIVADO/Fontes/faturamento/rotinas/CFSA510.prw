#Include "PROTHEUS.Ch"

#define STR0001 "Contabilizacao dos movimentos de Valida��o e Emiss�o de Certificados GAR"
#define STR0002 "  O  objetivo  deste programa  e  o  de  gerar  lancamentos  contabeis"
#define STR0003 "a partir dos movimentos de Valida��o e Emiss�o de Certificados GAR "
#define STR0004 "com faturamento anterior a 31/12/14"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CFSA510   � Autor �Giovanni A Rodrigues� Data �  17/11/14   ���
�������������������������������������������������������������������������͹��
���Descricao � Processar integra��o cont�bil das Emiss�es e Valida��es de ���
���          �Certificados (SZ5) 	                                      ���
�������������������������������������������������������������������������͹��
���Uso       � Novo ponto de faturamento Certisign			              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function CFSA510


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������


Local aSays 	:= {}
Local aButtons	:= {}
Local dDataSalv := dDataBase
Local nOpca 	:= 0

Private cCadastro :="Integra��o cont�bil dos movimentos de Valida��o e Emiss�o de Certificados. Espec�fico para pedidos Faturados com data anterior a 31/12/2014"

Private cString := "SZ5"


//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                         �
//� mv_par01 // Mostra Lan�amentos Cont�beis                     �
//� mv_par02 // Aglutina Lan�amentos Cont�beis                   �
//� mv_par03 // Arquivo a ser importado                          �
//� mv_par04 // Numero do Lote                                   �
//� mv_par05 // Quebra Linha em Doc.							 �
//� mv_par06 // Tamanho da linha	 							 �
//����������������������������������������������������������������
Pergunte("CFSA510",.f.)

AADD(aSays,OemToAnsi( STR0002 ) )
AADD(aSays,OemToAnsi( STR0003 ) )
AADD(aSays,OemToAnsi( STR0004 ) )

AADD(aButtons, { 5,.T.,{|| Pergunte("CFSA510",.T. ) } } )
AADD(aButtons, { 1,.T.,{|| nOpca:= 1, If( CTBOk(), FechaBatch(), nOpca:=0 ) }} )
AADD(aButtons, { 2,.T.,{|| FechaBatch() }} )

FormBatch( cCadastro, aSays, aButtons )
	                              
	
IF nOpca == 1                     
	
	//Trata as valida��es
	If FindFunction("CTBSERIALI")
		While !CTBSerialI("CTBPROC","ON")
		EndDo
	EndIf
	Processa({|lEnd| CFSA510Proc("V")})
	If FindFunction("CTBSERIALI")
		CTBSerialF("CTBPROC","ON")
	EndIf

	//Trata as emiss�es
	If FindFunction("CTBSERIALI")
		While !CTBSerialI("CTBPROC","ON")
		EndDo
	EndIf
	Processa({|lEnd| CFSA510Proc("E")})
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
���Fun��o    �CFSA510Proc� Autor �                     � Data � 17/11/14  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Processamento do lancamento contabil SZ5                   ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � CFSA510Proc()                                              ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function CFSA510Proc(cTipo)

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
Local nTamLinha := 1 //Iif(Empty(mv_par06),512,mv_par06)
Local cQuery    :="" 
Local cAliasTRB := GetNextAlias()
Local aFlagCTB:={}

Private aRotina := MenuDef()
Private Inclui := .T.							


//��������������������������������������������������������������Ŀ
//� Verifica o N�mero do Lote                                    �
//����������������������������������������������������������������
If ctipo=="V"
	cLote := "008821"

	cQuery:="SELECT  SZ5.R_E_C_N_O_ RECNOSZ5, SF2.R_E_C_N_O_ RECNOSF2, SD2.R_E_C_N_O_ RECNOSD2 "
	cQuery+="FROM "
	cQuery+="PROTHEUS.SZ5010 SZ5, "
	cQuery+="PROTHEUS.SC5010 SC5, "
	cQuery+="PROTHEUS.SD2010 SD2, "
	cQuery+="PROTHEUS.SC6010 SC6, "
	cQuery+="PROTHEUS.SF2010 SF2 "
	cQuery+="WHERE  "
	cQuery+="  Z5_FILIAL= " + ValToSql(xFilial('SZ5')) +" AND Z5_PEDGAR>=' ' AND SZ5.D_E_L_E_T_=' ' AND Z5_DATVAL>= "+ValToSql(DTOS(MV_PAR01))+ " AND Z5_DATVAL<= " + ValToSql(DTOS(MV_PAR02))
	cQuery+="  AND C5_FILIAL= " +ValToSql(xFilial('SC5')) + " AND C5_CHVBPAG=Z5_PEDGAR AND SC5.D_E_L_E_T_=' ' 
	cQuery+="  AND D2_FILIAL=C5_FILIAL AND D2_PEDIDO=C5_NUM AND SD2.D_E_L_E_T_=' ' "
	cQuery+="  AND C6_FILIAL=D2_FILIAL AND C6_NUM=D2_PEDIDO AND C6_ITEM=D2_ITEMPV AND SC6.D_E_L_E_T_= ' ' AND C6_XOPER = '52' "
	cQuery+="  AND F2_FILIAL=D2_FILIAL AND F2_DOC =D2_DOC AND F2_SERIE=D2_SERIE AND SF2.D_E_L_E_T_=' ' "  

Endif	

If ctipo=="E"
	cLote := "008822"

	cQuery:="SELECT  SZ5.R_E_C_N_O_ RECNOSZ5, SF2.R_E_C_N_O_ RECNOSF2, SD2.R_E_C_N_O_ RECNOSD2 "
	cQuery+="FROM "
	cQuery+="PROTHEUS.SZ5010 SZ5, "
	cQuery+="PROTHEUS.SC5010 SC5, "
	cQuery+="PROTHEUS.SD2010 SD2, "
	cQuery+="PROTHEUS.SC6010 SC6, "
	cQuery+="PROTHEUS.SF2010 SF2 "
	cQuery+="WHERE  "
	cQuery+="  Z5_FILIAL= " + ValToSql(xFilial('SZ5'))+" AND Z5_PEDGAR>=' ' AND SZ5.D_E_L_E_T_=' ' AND Z5_DATEMIS>= "+ValToSql(DTOS(MV_PAR01))+ " AND Z5_DATEMIS<= " + ValToSql(DTOS(MV_PAR02))
	cQuery+="  AND C5_FILIAL= "+ValToSql(xFilial('SC5'))+ " AND C5_CHVBPAG=Z5_PEDGAR AND SC5.D_E_L_E_T_=' ' 
	cQuery+="  AND D2_FILIAL=C5_FILIAL AND D2_PEDIDO=C5_NUM AND SD2.D_E_L_E_T_=' ' "
	cQuery+="  AND C6_FILIAL=D2_FILIAL AND C6_NUM=D2_PEDIDO AND C6_ITEM=D2_ITEMPV AND SC6.D_E_L_E_T_= ' ' AND C6_XOPER = '51' "
	cQuery+="  AND F2_FILIAL=D2_FILIAL AND F2_DOC =D2_DOC AND F2_SERIE=D2_SERIE AND SF2.D_E_L_E_T_=' ' "  
Endif
	
cQuery+="ORDER BY 1,2,3 "

cQuery := ChangeQuery(cQuery)

nRecnos:= 1 //Contar registros resultante da consulta

cCount :=' SELECT COUNT(*) COUNT FROM ( ' + cQuery + ' ) QUERY '

If At('ORDER  BY', Upper(cCount)) > 0
	cCount := SubStr(cCount,1,At('ORDER  BY',cCount)-1) + SubStr(cCount,RAt(')',cCount))
Endif
 
DbUseArea( .T., 'TOPCONN', TCGENQRY(,,cCount),cAliasTRB,.F.,.T.)
nRecnos := (cAliasTRB)->COUNT
(cAliasTRB)->(DbCloseArea())

IF nRecnos==0
     
	Return
Endif

cAliasTRB := GetNextAlias()
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasTRB,.T.,.T.)
                              
ProcRegua(nRecnos)
cLPSf2	:= "220"
lLpSf2	:= VerPadrao(cLPSf2)
cLPSd2	:= "210"
lLpSd2	:= VerPadrao(cLPSd2)

nRecSf2New:=0

If select("GTLEGADO") <= 0
	USE GTLEGADO ALIAS GTLEGADO SHARED NEW VIA "TOPCONN"
	If NetErr()
		UserException("Falha ao abrir GTLEGADO - SHARED" )
	Endif
	DbSetIndex("GTLEGADO01")
	DbSetOrder(1)
Endif                            

aFlagCTB:={}

IF lLpSf2 .and. lLpSd2
	While !(cAliasTRB)->(Eof())
	    
	    IncProc() //Atualiza o contador da Regua de progresso
        //Mantem o registro posicionado no cadastro de Valida��es do Pedido GAR SZ5
        //Atualiza a data base para contabiliza��o
        SZ5->(DBGOTO((cAliasTRB)->RECNOSZ5))    
		
	    
		DbSelectArea('GTLEGADO')
		If !DbSeek(cTipo+SZ5->Z5_PEDGAR) .or. GTLEGADO->GT_INPROC==.t.
    	    (cAliasTRB)->(DbSkip()) 
		    Loop                                     
		Endif
		If cTipo=='V'
			dDataBase:=SZ5->Z5_DATVAL        
        Endif
        If cTipo=='E'
			dDataBase:=SZ5->Z5_DATEMIS        
        Endif
        //Abre o cabe�alho de contabiliza��o para o primeiro registro do pedido GAR
	    //Posiciona na Tabela da SF2 para contabiliza��o do cabe�alho da nota
	    nRecSf2Proc:=(cAliasTRB)->(RECNOSF2)
		SF2->(DBGOTO(nRecSf2Proc))    
                
        While !(cAliasTRB)->(Eof()).and. nRecSf2Proc==(cAliasTRB)->RECNOSF2

		 	nRecSD2:=(cAliasTRB)->(RECNOSD2)
			SD2->(DBGOTO(nRecSD2))                 
			//posiciona TES para contabiliza��o
            SF4->(DBSETORDER(1))
            SF4->(DBSEEK(XFILIAL("SF4")+SD2->D2_TES)) 
            //posiciona cliente para contabiliza��o
            SA1->(DBSETORDER(1))
            SA1->(DBSEEK(XFILIAL("SA1")+SD2->D2_CLIENTE+SD2->D2_LOJA)) 
            //POSICIONA PRODUTO PARA CONTABILIZA��O
             //posiciona cliente para contabiliza��o
            SB1->(DBSETORDER(1))
            SB1->(DBSEEK(XFILIAL("SB1")+SD2->D2_COD))              
            
	        If !lHead
				aAdd(aFlagCTB,{"F2_DTLANC2",dDataBase,"SF2",(cAliasTRB)->RECNOSF2,0,0,0})
				lHead := .T.
				nHdlPrv := HeadProva(cLote,"CFSA510",Substr(cUsuario,7,6),@cArquivo)
				nTotal += DetProva(nHdlPrv,cLPSf2,"CFSA510",cLote,,,,,,,,@aFlagCTB)
		    EndIf
		    
			nTotal += DetProva(nHdlPrv,cLPSd2,"CFSA510",cLote,,,,,,,,@aFlagCTB)
	        //Vai para o pr�ximo Registro de processamento                                
	        
    	    (cAliasTRB)->(DbSkip()) 
	    Enddo
        
        //Gera o Rodap� do lan�amento
   	   	RodaProva(nHdlPrv,nTotal)
		//�����������������������������������������������������Ŀ
		//� Envia para Lan�amento Cont�bil                      �
		//�������������������������������������������������������
		lDigita	:=.F.
		lAglut 	:=.F.
		cA100Incl(cArquivo,nHdlPrv,3,cLote,lDigita,lAglut,,,,@aFlagCTB)
		nTotal  := 0
		lHead	:= .F. 
		
 	    GTLEGADO->( RecLock("GTLEGADO",.F.) )
 	    GTLEGADO->GT_INPROC := .T.
 	    GTLEGADO->( MsUnlock() )
 	EndDo
EndIf

dbSelectArea(cAliasTRB)
dbCloseArea()

Return


/*/
���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �MenuDef   � Autor � Ana Paula N. Silva     � Data �01/12/06 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Utilizacao de menu Funcional                               ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Array com opcoes da rotina.                                 ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Parametros do array a Rotina:                               ���
���          �1. Nome a aparecer no cabecalho                             ���
���          �2. Nome da Rotina associada                                 ���
���          �3. Reservado                                                ���
���          �4. Tipo de Transa��o a ser efetuada:                        ���
���          �		1 - Pesquisa e Posiciona em um Banco de Dados     ���
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
Local aRotina := {	{ "","" , 0 , 1},;
						{ "","" , 0 , 2 },;
						{ "","" , 0 , 3 },;
						{ "","" , 0 , 4 } }
Return(aRotina)