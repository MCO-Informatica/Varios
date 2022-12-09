#Include "rwmake.Ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � MATR820  � Autor � Paulo Boschetti       � Data � 07.07.92 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Ordens de Producao                                         ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe e � MATR820(void)                                              ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
*/
User Function SHMR820()

Local titulo  := "Ordens de Producao"
Local cString := "SC2"
Local wnrel   := "MATR820"
Local cDesc   := "Este programa ira imprimir a Rela��o das Ordens de Produ��o"
Local aOrd    := {"Por Numero","Por Produto","Por Centro de Custo","Por Prazo de Entrega"}	//"Por Numero"###"Por Produto"###"Por Centro de Custo"###"Por Prazo de Entrega"
Local tamanho := "P"

Private aReturn  := {"Zebrado",1,"Administracao", 1, 2, 1, "",1 }	//"Zebrado"###"Administracao"
Private cPerg    :=PadR("MTR820",Len(SX1->X1_GRUPO))
Private nLastKey := 0
Private lItemNeg := .F.
//��������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                           �
//����������������������������������������������������������������
pergunte(cPerg,.F.)
//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                         �
//� mv_par01            // Da OP                                 �
//� mv_par02            // Ate a OP                              �
//� mv_par03            // Da data                               �
//� mv_par04            // Ate a data                            �
//� mv_par05            // Imprime roteiro de operacoes          �
//� mv_par06            // Imprime codigo de barras              �
//� mv_par07            // Imprime Nome Cientifico               �
//� mv_par08            // Imprime Op Encerrada                  �
//� mv_par09            // Impr. por Ordem de                    �
//� mv_par10            // Impr. OP's Firmes, Previstas ou Ambas �
//� mv_par11            // Impr. Item Negativo na Estrutura      �
//� mv_par12            // 1a. ou 2a. Unidade de Medida          �
//����������������������������������������������������������������
If !ChkFile("SH8",.F.)
	Help(" ",1,"SH8EmUso")
	Return
Endif
//��������������������������������������������������������������Ŀ
//� Envia controle para a funcao SETPRINT                        �
//����������������������������������������������������������������

wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc,"","",.F.,aOrd,,Tamanho)

lItemNeg := GetMv("MV_NEGESTR") .And. mv_par11 == 1

If nLastKey == 27
	dbSelectArea("SH8")
	Set Filter To
	dbCloseArea()
	//��������������������������������������������������������������Ŀ
	//� Retira o SH8 da variavel cFopened ref. a abertura no MNU     �
	//����������������������������������������������������������������
	ClosFile("SH8")
	dbSelectArea("SC2")
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	dbSelectArea("SH8")
	Set Filter To
	dbCloseArea()
	//��������������������������������������������������������������Ŀ
	//� Retira o SH8 da variavel cFopened ref. a abertura no MNU     �
	//����������������������������������������������������������������
	ClosFile("SH8")
	dbSelectArea("SC2")
	Return
Endif

RptStatus({|lEnd| R820Imp(@lEnd,wnRel,titulo,tamanho)},titulo)

Return NIL

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � R820Imp  � Autor � Waldemiro L. Lustosa  � Data � 13.11.95 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Chamada do Relat�rio                                       ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR820			                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function R820Imp(lEnd,wnRel,titulo,tamanho)

//��������������������������������������������������������������Ŀ
//� Define Variaveis                                             �
//����������������������������������������������������������������
Local CbCont,cabec1,cabec2
Local limite     := 80
Local nQuant     := 1
Local nomeprog   := "MATR820"
Local nTipo      := 18
Local cProduto   := SPACE(LEN(SC2->C2_PRODUTO))
Local cQtd
Local cIndSC2    := CriaTrab(NIL,.F.), nIndSC2
Private aArray   := {}
Private li       := 80
//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para Impressao do Cabecalho e Rodape    �
//����������������������������������������������������������������
cbtxt    := SPACE(10)
cbcont   := 0
m_pag    := 0
//��������������������������������������������������������������Ŀ
//� Monta os Cabecalhos                                          �
//����������������������������������������������������������������
cabec1 := ""
cabec2 := ""

dbSelectArea("SC2")
If aReturn[8] == 4
	//#IFDEF TOP
		IndRegua("SC2",cIndSC2,"C2_FILIAL+C2_DATPRF",,,"Selecionando Registros...")	//"Selecionando Registros..."
	//#ELSE
	//	IndRegua("SC2",cIndSC2,"C2_FILIAL+DTOS(C2_DATPRF)",,,"Selecionando Registros...")	//"Selecionando Registros..."
	//#ENDIF
	dbGoTop()
Else
	dbSetOrder(aReturn[8])
EndIf

dbSeek(xFilial())

SetRegua(LastRec())

While !Eof()
	
	IF lEnd
		@ Prow()+1,001 PSay "CANCELADO PELO OPERADOR"
		Exit
	EndIF
	
	IncRegua()
	
	If C2_FILIAL+C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD < xFilial()+mv_par01 .or. C2_FILIAL+C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD > xFilial()+mv_par02
		dbSkip()
		Loop
	EndIf
	
	If  C2_DATPRF < mv_par03 .Or. C2_DATPRF > mv_par04
		dbSkip()
		Loop
	Endif
	
	If !(Empty(C2_DATRF)) .And. mv_par08 == 2
		dbSkip()
		Loop
	Endif
	
	//-- Valida se a OP deve ser Impressa ou n�o
	If !MtrAValOP(mv_par10, 'SC2')
		dbSkip()
		Loop
	EndIf
	
	cProduto  := SC2->C2_PRODUTO
	nQuant    := aSC2Sld()
	
	dbSelectArea("SB1")
	dbSeek(xFilial()+cProduto)
	
	//��������������������������������������������������������������Ŀ
	//� Adiciona o primeiro elemento da estrutura , ou seja , o Pai  �
	//����������������������������������������������������������������
	AddAr820(nQuant)
	
	MontStruc(SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN+SC2->C2_ITEMGRD,nQuant)
	
	If mv_par09 == 1
		aSort( aArray,2,, { |x, y| (x[1]+x[8]) < (y[1]+y[8]) } )
	Else
		aSort( aArray,2,, { |x, y| (x[8]+x[1]) < (y[8]+y[1]) } )
	ENDIF
	
	//���������������������������������������������������������Ŀ
	//� Imprime cabecalho                                       �
	//�����������������������������������������������������������
	cabecOp(Tamanho)
	
	For I := 2 TO Len(aArray)
		
		@Li ,   0 PSay aArray[I][1]    	 				   	// CODIGO PRODUTO
		For nBegin := 1 To Len(Alltrim(aArray[I][2])) Step 31
			@li,016 PSay Substr(aArray[I][2],nBegin,31)
			li++
		Next nBegin
		Li--
		
   	    cQtd    := Alltrim(Transform(aArray[I][5],PesqPictQt("D4_QUANT",14)))		
		cQtd2um := Alltrim(Transform(aArray[I][11],PesqPictQt("D4_QTSEGUM",12)))		
		
		@Li , (46+11-Len(cQtd)) PSay cQtd					// QUANTIDADE
		@Li ,  57 PSay "|"+aArray[I][4]+"|"			  	// UNIDADE DE MEDIDA

		@Li ,  73-Len(cQtd2UM)   PSay cQtd2UM				        	// Quantidade 2a. UM
		@Li ,  73 PSay "|"+aArray[I][10]+"|"			  	// UNIDADE DE MEDIDA 2a. UM

		@li ,  77 PSay aArray[I][6]+"|"                  	// ALMOXARIFADO
//		@li ,  64 PSay Substr(aArray[I][7],1,12)         	// LOCALIZACAO
//		@li ,  76 PSay "|"+aArray[I][8]                  	// SEQUENCIA
		Li++
		@Li ,  00 PSay __PrtThinLine()
		Li++
		   
		//���������������������������������������������������������Ŀ
		//� Se nao couber, salta para proxima folha                 �
		//�����������������������������������������������������������
		IF li > 63
			Li := 0
			CabecOp(Tamanho)		// imprime cabecalho da OP
		EndIF
		
	Next I
	
	If mv_par05 == 1
		RotOper()   	// IMPRIME ROTEIRO DAS OPERACOES
	Endif
	
	//��������������������������������������������������������������Ŀ
	//� Imprimir Relacao de medidas para Cliente == HUNTER DOUGLAS.  �
	//����������������������������������������������������������������
	dbSelectArea("SX3")
	dbSetOrder(1)
	dbSeek("SMX")
	If Found() .And. SC2->C2_DESTINA == "P"
		R820Medidas()
	EndIf
	
*	m_pag++
	Li := 0					// linha inicial - ejeta automatico
	aArray:={}
	
	dbSelectArea("SC2")
	dbSkip()
	
EndDO

dbSelectArea("SH8")
dbCloseArea()

//��������������������������������������������������������������Ŀ
//� Retira o SH8 da variavel cFopened ref. a abertura no MNU     �
//����������������������������������������������������������������
ClosFile("SH8")

dbSelectArea("SC2")
If aReturn[8] == 4
	RetIndex("SC2")
	Ferase(cIndSC2+OrdBagExt())
EndIf
Set Filter To
dbSetOrder(1)

If aReturn[5] = 1
	Set Printer TO
	dbCommitall()
	ourspool(wnrel)
Endif

MS_FLUSH()

Return NIL

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
��� Fun��o   � AddAr820 � Autor � Paulo Boschetti       � Data � 07/07/92 ���
�������������������������������������������������������������������������Ĵ��
��� Descri��o� Adiciona um elemento ao Array                              ���
�������������������������������������������������������������������������Ĵ��
��� Sintaxe  � AddAr820(ExpN1)                                            ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpN1 = Quantidade da estrutura                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR820                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
*/
Static Function AddAr820(nQuantItem)
Local cDesc := SB1->B1_DESC
Local cRoteiro:=""
//�����������������������������������������������������������Ŀ
//� Verifica se imprime nome cientifico do produto. Se Sim    �
//� verifica se existe registro no SB5 e se nao esta vazio    �
//�������������������������������������������������������������
If mv_par07 == 1
	dbSelectArea("SB5")
	dbSeek(xFilial()+SB1->B1_COD)
	If Found() .and. !Empty(B5_CEME)
		cDesc := B5_CEME
	EndIf
ElseIf mv_par07 == 2
	cDesc := SB1->B1_DESC
Else
	//�����������������������������������������������������������Ŀ
	//� Verifica se imprime descricao digitada ped.venda, se sim  �
	//� verifica se existe registro no SC6 e se nao esta vazio    �
	//�������������������������������������������������������������
	If SC2->C2_DESTINA == "P"
		dbSelectArea("SC6")
		dbSetOrder(1)
		dbSeek(xFilial()+SC2->C2_PEDIDO+SC2->C2_ITEM)
		If Found() .and. !Empty(C6_DESCRI) .and. C6_PRODUTO==SB1->B1_COD
			cDesc := C6_DESCRI
		ElseIf C6_PRODUTO # SB1->B1_COD
			dbSelectArea("SB5")
			dbSeek(xFilial()+SB1->B1_COD)
			If Found() .and. !Empty(B5_CEME)
				cDesc := B5_CEME
			EndIf
		EndIf
	EndIf
EndIf

//�����������������������������������������������������������Ŀ
//� Verifica se imprime ROTEIRO da OP ou PADRAO do produto    �
//�������������������������������������������������������������
If !Empty(SC2->C2_ROTEIRO)
	cRoteiro:=SC2->C2_ROTEIRO
Else
	If !Empty(SB1->B1_OPERPAD)
		cRoteiro:=SB1->B1_OPERPAD
	Else
		dbSelectArea("SG2")
		If dbSeek(xFilial()+SC2->C2_PRODUTO+"01")
			RecLock("SB1",.F.)
			Replace B1_OPERPAD With "01"
			MsUnLock()
			cRoteiro:="01"
		EndIf
	EndIf
EndIf

dbSelectArea("SB2")
dbSeek(xFilial()+SB1->B1_COD+SD4->D4_LOCAL)
dbSelectArea("SD4")
//If mv_par12 == 1 // 1a. Unidade de Medida 
AADD(aArray, {SB1->B1_COD,cDesc,SB1->B1_TIPO,SB1->B1_UM,nQuantItem,D4_LOCAL,SB2->B2_LOCALIZ,D4_TRT,cRoteiro,SB1->B1_SEGUM,SD4->D4_QTSEGUM } )
//	                1       2       3            4          5          6            7          8       9       10            11
//	AADD(aArray, {SB1->B1_COD,cDesc,SB1->B1_TIPO,SB1->B1_UM,nQuantItem,D4_LOCAL,SB2->B2_LOCALIZ,D4_TRT,cRoteiro } )	
//Else
//	AADD(aArray, {SB1->B1_COD,cDesc,SB1->B1_TIPO,SB1->B1_SEGUM,nQuantItem,D4_LOCAL,SB2->B2_LOCALIZ,D4_TRT,cRoteiro } )
//EndIf		

/*/
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
��� Fun��o   � MontStruc� Autor � Ary Medeiros          � Data � 19/10/93 ���
�������������������������������������������������������������������������Ĵ��
��� Descri��o� Monta um array com a estrutura do produto                  ���
�������������������������������������������������������������������������Ĵ��
��� Sintaxe  � MontStruc(ExpC1,ExpN1,ExpN2)                               ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpC1 = Codigo do produto a ser explodido                  ���
���          � ExpN1 = Quantidade base a ser explodida                    ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR820                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
/*/
Static Function MontStruc(cOp,nQuant)

dbSelectArea("SD4")
dbSetOrder(2)
dbSeek(xFilial()+cOp)

While !Eof() .And. D4_FILIAL+D4_OP == xFilial()+cOp
	//���������������������������������������������������������Ŀ
	//� Posiciona no produto desejado                           �
	//�����������������������������������������������������������
	dbSelectArea("SB1")
	dbSeek(xFilial()+SD4->D4_COD)
    // 
    
    _nQuant    := SD4->D4_QUANT
    _nQuant2um := SD4->D4_QTSEGUM
    //
//	If SD4->D4_QUANT > 0 .Or. (lItemNeg .And. SD4->D4_QUANT < 0)
//		AddAr820(SD4->D4_QUANT)
//	EndIf              
	If _nQuant > 0 .Or. (lItemNeg .And. _nQuant < 0)
//		AddAr820(_nQuant,_nQuant2um)
		AddAr820(_nQuant)		
	EndIf
	
	
	dbSelectArea("SD4")
	dbSkip()
Enddo

dbSetOrder(1)

Return

/*/
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
��� Fun��o   � CabecOp  � Autor � Paulo Boschetti       � Data � 07/07/92 ���
�������������������������������������������������������������������������Ĵ��
��� Descri��o� Monta o cabecalho da Ordem de Producao                     ���
�������������������������������������������������������������������������Ĵ��
��� Sintaxe  � CabecOp()                                                  ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR820                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
/*/
Static Function CabecOp(Tamanho)

Local cCabec1 := SM0->M0_NOME+"        O R D E M   D E   P R O D U C A O       NRO :"
Local cCabec2 := "  C O M P O N E N T E S                                                         "
//Local cCabec3 := "CODIGO          DESCRICAO                      QUANTIDADE|UM|AL|LOCALIZACAO |SEQ"
Local cCabec3 := "CODIGO          DESCRICAO                      QUANTIDADE|UM| QUANT. 2A. |UM|AL|"
//  	          012345678901234567890123456789012345678901234567890123456789012345678901234567890
//                	        1         2         3         4         5         6         7         8
Local nBegin

If li # 5
	li := 0
Endif

Cabec("","","","",Tamanho,18,{cCabec1+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN},.F.)

Li+=2
IF (mv_par06 == 1) .And. aReturn[5] # 1
	//���������������������������������������������������������Ŀ
	//� Imprime o codigo de barras do numero da OP              �
	//�����������������������������������������������������������
	oPr := ReturnPrtObj()   
	cCode := (SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN+SC2->C2_ITEMGRD)
	MSBAR2("CODE128",2.5,0.5,Alltrim(cCode),oPr,Nil,Nil,Nil,nil ,1.5 ,Nil,Nil,Nil)
	Li += 5
ENDIF
@Li,00 PSay "Produto: "+aArray[1][1]+ " " +aArray[1][2]	//"Produto: "
Li++
@Li,00 PSay "Emissao:"+DTOC(dDatabase)						//"Emissao:"
@Li,73 PSay "Fol:"+TRANSFORM(m_pag,'999')				//"Fol:"
Li++

//���������������������������������������������������������Ŀ
//� Imprime nome do cliente quando OP for gerada            �
//� por pedidos de venda                                    �
//�����������������������������������������������������������
If SC2->C2_DESTINA == "P"
	dbSelectArea("SC5")
	dbSetOrder(1)
	If dbSeek(xFilial()+SC2->C2_PEDIDO,.F.)
		dbSelectArea("SA1")
		dbSetOrder(1)
		dbSeek(xFilial()+SC5->C5_CLIENTE+SC5->C5_LOJACLI)
		@Li,00 PSay "Cliente :"
		@Li,10 PSay SC5->C5_CLIENTE+"-"+SC5->C5_LOJACLI+" "+A1_NOME
		dbSelectArea("SG1")
		Li++
	EndIf
EndIf

//���������������������������������������������������������Ŀ
//� Imprime a quantidade original quando a quantidade da    �
//� Op for diferente da quantidade ja entregue              �
//�����������������������������������������������������������
If SC2->C2_QUJE + SC2->C2_PERDA > 0
	@Li,00 PSay "Qtde Prod.:"
	@Li,11 PSay aSC2Sld()		PICTURE PesqPictQt("C2_QUANT",14)
	@Li,26 PSay "Qtde Orig.:"
	@Li,37 PSay SC2->C2_QUANT	PICTURE PesqPictQt("C2_QUANT",14)
Else
	@Li,00 PSay "Quantidade :"
	@Li,15 PSay SC2->C2_QUANT - SC2->C2_QUJE	PICTURE PesqPictQt("C2_QUANT",14)
Endif

@Li,56 PSay "INICIO             F I M"
Li++
@Li,00 PSay "Unid. Medida : "+aArray[1][4]			//"Unid. Medida : "
@Li,42 PSay "Prev. : "+DTOC(SC2->C2_DATPRI)	//"Prev. : "
@Li,62 PSay "Prev. : "+DTOC(SC2->C2_DATPRF)	//"Prev. : "
Li++
@Li,00 PSay "C.Custo: "+SC2->C2_CC				//"C.Custo: "
@Li,42 PSay "Ajuste: "+DTOC(SC2->C2_DATAJI)	//"Ajuste: "
@Li,62 PSay "Ajuste: "+DTOC(SC2->C2_DATAJF)	//"Ajuste: "
Li++
If SC2->C2_STATUS == "S"
	@Li,00 PSay "Status: OP Sacramentada"
ElseIf SC2->C2_STATUS == "U"
	@Li,00 PSay "Status: OP Suspensa"
ElseIf SC2->C2_STATUS $ " N"
	@Li,00 PSay "Status: OP Normal"
EndIf
@Li,42 PSay "Real  :   /  /      Real  :   /  / "
Li++

If !(Empty(SC2->C2_OBS))
	@Li,00 PSay "Observacao: "
	For nBegin := 1 To Len(Alltrim(SC2->C2_OBS)) Step 65
		@li,012 PSay Substr(SC2->C2_OBS,nBegin,65)
		li++
	Next nBegin
EndIf

@Li,00 PSay __PrtFatLine()
Li++
@Li,00 PSay cCabec2
Li++
@Li,00 PSay cCabec3
Li++
@Li,00 PSay __PrtFatLine()
Li++

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
��� Fun��o   � RotOper  � Autor � Paulo Boschetti       � Data � 18/07/92 ���
�������������������������������������������������������������������������Ĵ��
��� Descri��o� Imprime Roteiro de Operacoes                               ���
�������������������������������������������������������������������������Ĵ��
��� Sintaxe  � RotOper()                                                  ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR820                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
*/
Static Function RotOper()

Local cCabec1 := SM0->M0_NOME+"              ROTEIRO DE OPERACOES              NRO :"
Local cCabec2 := "RECURSO                       FERRAMENTA               OPERACAO"
Local nBegin, lSH8

dbSelectArea("SG2")
If dbSeek(xFilial()+aArray[1][1]+aArray[1][9],.F.)
	
	cRotOper()
	
	While !Eof() .And. G2_FILIAL+G2_PRODUTO+G2_CODIGO = xFilial()+aArray[1][1]+aArray[1][9]
		
		dbSelectArea("SH4")
		dbSeek(xFilial()+SG2->G2_FERRAM)
		
		dbSelectArea("SH8")
		dbSetOrder(1)
		dbSeek(xFilial()+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN+SC2->C2_ITEMGRD+SG2->G2_OPERAC)
		lSH8 := IIf(Found(),.T.,.F.)
		
		If lSH8
			While !Eof() .And. SH8->H8_FILIAL+SH8->H8_OP+SH8->H8_OPER == xFilial()+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN+SC2->C2_ITEMGRD+SG2->G2_OPERAC
				ImpRot(lSH8)
				dbSelectArea("SH8")
				dbSkip()
			End
		Else
			ImpRot(lSH8)
		Endif
		
		dbSelectArea("SG2")
		dbSkip()
		
	EndDo
	
Endif

Return Li

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
��� Fun��o   � ImpRot   � Autor � Marcos Bregantim      � Data � 10/07/95 ���
�������������������������������������������������������������������������Ĵ��
��� Descri��o� Imprime Roteiro de Operacoes                               ���
�������������������������������������������������������������������������Ĵ��
��� Sintaxe  � ImpRot()                                                   ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR820                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
*/
Static Function ImpRot(lSH8)
Local nBegin

dbSelectArea("SH1")
dbSeek(xFilial()+IIf(lSH8,SH8->H8_RECURSO,SG2->G2_RECURSO))

Verilim()

@Li,00 PSay IIF(lSH8,SH8->H8_RECURSO,SG2->G2_RECURSO)+" "+SUBS(SH1->H1_DESCRI,1,25)
@Li,33 PSay SG2->G2_FERRAM+" "+SUBS(SH4->H4_DESCRI,1,20)
@Li,61 PSay SG2->G2_OPERAC

For nBegin := 1 To Len(Alltrim(SG2->G2_DESCRI)) Step 16
	@li,064 PSay Substr(SG2->G2_DESCRI,nBegin,16)
	li++
Next nBegin

Li+=1
@Li,00 PSay "INICIO  ALOC.: "+IIF(lSH8,DTOC(SH8->H8_DTINI),Space(8))+" "+IIF(lSH8,SH8->H8_HRINI,Space(5))+" "+" INICIO  REAL :"+" ____/ ____/____ ___:___"	//"INICIO  ALOC.: "###" INICIO  REAL :"
Li++
@Li,00 PSay "TERMINO ALOC.: "+IIF(lSH8,DTOC(SH8->H8_DTFIM),Space(8))+" "+IIF(lSH8,SH8->H8_HRFIM,Space(5))+" "+" TERMINO REAL :"+" ____/ ____/____ ___:___"	//"TERMINO ALOC.: "###" TERMINO REAL :"
Li++
@Li,00 PSay "Quantidade :"
@Li,13 PSay IIF(lSH8,SH8->H8_QUANT,aSC2Sld()) PICTURE PesqPictQt("H8_QUANT",14)
@Li,28 PSay "Quantidade Produzida :               Perdas :"
Li++
@Li,00 PSay __PrtThinLine()
Li++

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
��� Fun��o   � RotOper  � Autor � Paulo Boschetti       � Data � 18/07/92 ���
�������������������������������������������������������������������������Ĵ��
��� Descri��o� Imprime Roteiro de Operacoes                               ���
�������������������������������������������������������������������������Ĵ��
��� Sintaxe  � RotOper()                                                  ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR820                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
*/
Static Function cRotOper()

Local cCabec1 := SM0->M0_NOME+"              ROTEIRO DE OPERACOES              NRO :"
Local cCabec2 := "RECURSO                       FERRAMENTA               OPERACAO"

Li++
@Li,00 PSay __PrtFatLine()
Li++
@Li,00 PSay cCabec1
@Li,67 PSay SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN+SC2->C2_ITEMGRD
Li++
@Li,00 PSay __PrtFatLine()
Li++
@Li,00 PSay "Produto: "+aArray[1][1]	//"Produto: "
ImpDescr(aArray[1][2])

//���������������������������������������������������������Ŀ
//� Imprime a quantidade original quando a quantidade da    �
//� Op for diferente da quantidade ja entregue              �
//�����������������������������������������������������������
If SC2->C2_QUJE + SC2->C2_PERDA > 0
	@Li,00 PSay "Qtde Prod.:"
	@Li,11 PSay aSC2Sld()		PICTURE PesqPictQt("C2_QUANT",14)
	@Li,26 PSay "Qtde Orig.:"
	@Li,37 PSay SC2->C2_QUANT	PICTURE PesqPictQt("C2_QUANT",14)
Else
	@Li,00 PSay "Quantidade :"
	@Li,15 PSay aSC2Sld()	PICTURE PesqPictQt("C2_QUANT",14)
Endif

Li++
@Li,00 PSay "C.Custo: "+SC2->C2_CC	//"C.Custo: "
Li++
@Li,00 PSay __PrtFatLine()
Li++
@Li,00 PSay cCabec2
Li++
@Li,00 PSay __PrtFatLine()
Li++
Return Li

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
��� Fun��o   � Verilim  � Autor � Paulo Boschetti       � Data � 18/07/92 ���
�������������������������������������������������������������������������Ĵ��
��� Descri��o�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Sintaxe  � Verilim()                                                  ���
�������������������������������������������������������������������������Ĵ��
���Parametros� 			                                          		  ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR820                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
*/
Static Function Verilim()

//����������������������������������������������������������������������Ŀ
//� Verifica a possibilidade de impressao da proxima operacao alocada na �
//� mesma folha.																			 �
//� 7 linhas por operacao => (total da folha) 66 - 7 = 59					 �
//������������������������������������������������������������������������
IF Li > 59						// Li > 55
	Li := 0
	cRotOper(0)					// Imprime cabecalho roteiro de operacoes
Endif
Return Li

/*
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Fun��o    � BARCODE  � Autor � Ricardo Dutra          � Data � 16/08/93 ���
��������������������������������������������������������������������������Ĵ��
���Descri��o � Programa para imprimir codigo de barras                     ���
��������������������������������������������������������������������������Ĵ��
���Sintaxe   � CodBar(ExpC1)								                        ���
��������������������������������������������������������������������������Ĵ��
���Uso       � Generico                                                    ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
*/
#define ESC	27
Static Function BarCode(cCodigo)
Local nLargura := 40	// largura de impressao do codigo
Local i, j, l, k, nCarac, cTexto, cEsc, cCode, nLimite, nImp, nBorda, nLin
Local aV0 := { Replicate(Chr(0),7), Chr(0) + Chr(0) + Chr(0) }
Local aV1 := { Replicate(Chr(127),6), Chr(127) + Chr(127) }
Local aImp [50]

nLin := 0							// imprime codigo comeco formulario
cEsc := Chr(ESC)

//��������������������������������������������������������������������Ŀ
//� Reseta a impressora na posicao atual - comeco formulario           �
//����������������������������������������������������������������������
@ 0,0 PSay cEsc + "@"				// reseta a impressora nesta posicao

cTexto := cCodigo
cTexto := "*" + cTexto + "*"		// caracteres de inicio e fim

nImp := 1
aImp [nImp] := ""
nLimite := Len(cTexto)

FOR i := 1 TO nLimite
	nCarac := Asc (Substr (cTexto, i, 1))
	
	//����������������������������������������������������������Ŀ
	//� Atribui um codigo a cada caracter                        �
	//������������������������������������������������������������
	
	IF nCarac == 42					// *
		cCode := "2122121222"
	ELSEIF nCarac == 32				// branco
		cCode := "2112221222"
	ELSEIF nCarac == 48				// 0
		cCode := "2221121222"
	ELSEIF nCarac == 49				// 1
		cCode := "1221222212"
	ELSEIF nCarac == 50				// 2
		cCode := "2211222212"
	ELSEIF nCarac == 51				// 3
		cCode := "1211222222"
	ELSEIF nCarac == 52				// 4
		cCode := "2221122212"
	ELSEIF nCarac == 53				// 5
		cCode := "1221122222"
	ELSEIF nCarac == 54				// 6
		cCode := "2211122222"
	ELSEIF nCarac == 55				// 7
		cCode := "2221221212"
	ELSEIF nCarac == 56				// 8
		cCode := "1221221222"
	ELSEIF nCarac == 57				// 9
		cCode := "2211221222"
	ELSEIF nCarac == 65				// A
		cCode := "1222212212"
	ELSEIF nCarac == 66				// B
		cCode := "2212212212"
	ELSEIF nCarac == 67				// C
		cCode := "1212212222"
	ELSEIF nCarac == 68				// D
		cCode := "2222112212"
	ELSEIF nCarac == 69				// E
		cCode := "1222112222"
	ELSEIF nCarac == 70				// F
		cCode := "2212112222"
	ELSEIF nCarac == 71				// G
		cCode := "2222211212"
	ELSEIF nCarac == 72				// H
		cCode := "1222211222"
	ELSEIF nCarac == 73				// I
		cCode := "2212211222"
	ELSEIF nCarac == 74				// J
		cCode := "2222111222"
	ELSEIF nCarac == 75				// K
		cCode := "1222222112"
	ELSEIF nCarac == 76				// L
		cCode := "2212222112"
	ELSEIF nCarac == 77				// M
		cCode := "1212222122"
	ELSEIF nCarac == 78				// N
		cCode := "2222122112"
	ELSEIF nCarac == 79				// O
		cCode := "1222122122"
	ELSEIF nCarac == 80				// P
		cCode := "2212122122"
	ELSEIF nCarac == 81				// Q
		cCode := "2222221112"
	ELSEIF nCarac == 82				// R
		cCode := "1222221122"
	ELSEIF nCarac == 83				// S
		cCode := "2212221122"
	ELSEIF nCarac == 84				// T
		cCode := "2222121122"
	ELSEIF nCarac == 85				// U
		cCode := "1122222212"
	ELSEIF nCarac == 86				// V
		cCode := "2112222212"
	ELSEIF nCarac == 87				// W
		cCode := "1112222222"
	ELSEIF nCarac == 88				// X
		cCode := "2122122212"
	ELSEIF nCarac == 89				// Y
		cCode := "1122122222"
	ELSEIF nCarac == 90				// Z
		cCode := "2112122222"
	ENDIF
	
	//���������������������������������������������������������������Ŀ
	//� Adiciona barras ou espacos ao array de impressao, sendo :     �
	//� - barra grossa  = 6 * Chr(127)                				      �
	//� - barra fina    = 2 * Chr(127)								         �
	//� - espaco grosso = 7 * Chr(0)                                  �
	//� - espaco fino   = 3 * Chr(0) 								         �
	//�																               �
	//� As barras e espacos sao alocados de acordo com os caracteres  �
	//� de cCode, tomados 2 a 2, sendo que o primeiro designa as bar- �
	//� ras e o segundo, os espacos. 								         �
	//� Se o caracter for 1 => barra/espaco grosso					      �
	//� Se o caracter for 2 => barra/espaco fino					         �
	//�����������������������������������������������������������������
	FOR j := 1 to 9 STEP 2
		aImp[nImp] := aImp[nImp] + aV1 [val(substr(cCode,j,1))] + ;
		aV0 [val(substr(cCode,j + 1,1))]
	NEXT
	
	l := len(aImp[nImp])
	
	//����������������������������������������������������������������������Ŀ
	//�Se tamanho do string atual de impressao for maior que 120,				 �
	//�copia o que ultrapassou para o proximo string								 �
	//�Limita o string atual para 120 + caracteres de controle de imp grafica�
	//�Incrementa contador de strings													 �
	//������������������������������������������������������������������������
	IF l > 120
		aImp[nImp+1] := Right(aImp[nImp],l -120)
		aImp[nImp] := cEsc + "L" + Chr(120) + Chr(0) + Left(aImp[nImp],120)
		nImp++
	ENDIF
NEXT

j := Len(aImp[nImp])

//���������������������������������������������������Ŀ
//�Borda esquerda da etiqueta para centrar o codigo   �
//�����������������������������������������������������
nBorda := (nLargura - (j + (nImp - 1) * 120 ) / Len(cTexto)) / 2

IF nBorda < 0
	return -2		// Codigo muito grande p/largura especificada
ENDIF

//��������������������������������������������������������������Ŀ
//� Acrescenta caracteres de controle grafico ao ultimo string   �
//����������������������������������������������������������������
aImp[nImp] := cEsc + "L" + Chr(j)+Chr(0) + aImp[nImp] + cEsc + "3" + Chr(1)

FOR l := 1 to 4					// imprime quatro linhas
	FOR k := 1 to 3				// imprime tres vezes
		FOR i := 1 to nImp		// contador de strings
			@ nLin,nBorda+(i-1)*10 PSay aImp[i]
		NEXT
		nLin++
	NEXT
	
	//��������������������������������������������������������������Ŀ
	//� Seta tamanho de linha para posicionar para a proxima         �
	//����������������������������������������������������������������
	@ nLin,1 PSay cEsc + "3" + Chr(18)
	nLin++
NEXT

//��������������������������������������������������������������������Ŀ
//� Seta tamanho de linha p/ posicionar cursor proxima coluna de texto �
//����������������������������������������������������������������������
@ nLin,1 PSay  cEsc + "3" + Chr(24)
nLin++

@ nLin,1 PSay cEsc + "2"			// cancela espacamentos de linha progrados

//��������������������������������������������������������������������Ŀ
//� Imprime o numero da OP expandido e centralizado, embaixo do codigo �
//����������������������������������������������������������������������
cNumOp := Replicate(" ",3) + cTexto		// para centralizar
@ nLin,nBorda PSay Chr(14) + cNumOp	    // imprime expandido
nLin++
@ nLin,0 PSay Chr(20)					// volta ao normal

RETURN

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � ImpDescr � Autor � Marcos Bregantim      � Data � 31.08.93 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Imprimir descricao do Produto.                             ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � ImpProd(Void)                                              ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MatR820                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ImpDescr(cDescri)

For nBegin := 1 To Len(Alltrim(cDescri)) Step 50
	@li,025 PSay Substr(cDescri,nBegin,50)
	li++
Next nBegin

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �R820Medidas� Autor � Jose Lucas           � Data � 25.01.94 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Imprime o registros referentes as medidas do Pedido Filho. ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � R820Medidas(Void)                                          ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MatR820                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function R820Medidas()
Local aArrayPro := {}, lImpItem := .T.
Local nCntArray := 0,a01 := "",a02 := ""
Local nX:=0,nI:=0,nL:=0,nY:=0
Local cNum:="", cItem:="",lImpCab := .T.
Local nBegin, cProduto:="", cDesc, cDescri, cDescri1, cDescri2

//������������������������������������������������������������Ŀ
//� Imprime Relacao de Medidas do cliente quando OP for gerada �
//� por pedidos de vendas.                                     �
//��������������������������������������������������������������
dbSelectArea("SC5")
dbSetOrder(1)
If dbSeek(xFilial()+SC2->C2_PEDIDO,.F.)
	cNum := SC2->C2_NUM
	cItem := SC2->C2_ITEM
	cProduto := SC2->C2_PRODUTO
	//��������������������������������������������������������������Ŀ
	//� Imprimir somente se houver Observacoes.                      �
	//����������������������������������������������������������������
	IF !Empty(SC5->C5_OBSERVA)
		IF li > 53
			@ 03,001 PSay "HUNTER DOUGLAS DO BRASIL LTDA"
			@ 05,008 PSay "CONFIRMACAO DE PEDIDOS  -  "+IIF( SC5->C5_VENDA=="01","ASSESSORIA","DISTRIBUICAO")
			@ 05,055 PSay "No. RMP    : "+SC5->C5_NUM+"-"+SC5->C5_VENDA
			@ 06,055 PSay "DATA IMPRES: "+DTOC(dDataBase)
			li := 07
		EndIF
		li++
		@ li,001 PSay "--------------------------------------------------------------------------------"
		li++
		cDescri := SC5->C5_OBSERVA
		@ li,001 PSay " OBSERVACAO: "
		@ li,018 PSay SubStr(cDescri,1,60)
		For nBegin := 61 To Len(Trim(cDescri)) Step 60
			li++
			cDesc:=Substr(cDescri,nBegin,60)
			@ li,018 PSay cDesc
		Next nBegin
		li++
		cDescri1 := SC5->C5_OBSERV1
		@ li,018 PSay SubStr(cDescri1,1,60)
		For nBegin := 61 To Len(Trim(cDescri1)) Step 60
			li++
			cDesc:=Substr(cDescri1,nBegin,60)
			@ li,018 PSay cDesc
		Next nBegin
		Li++
		cDescri2 := SC5->C5_OBSERV2
		@ li,018 PSay SubStr(cDescri2,1,60)
		For nBegin := 61 To Len(Trim(cDescri2)) Step 60
			li++
			cDesc:=Substr(cDescri2,nBegin,60)
			@ li,018 PSay cDesc
		Next nBegin
		li++
		@ li,001 PSay "--------------------------------------------------------------------------------"
		li++
	EndIf
	
	//��������������������������������������������������������������Ŀ
	//� Carregar as medidas em array para impressao.                 �
	//����������������������������������������������������������������
	dbSelectArea("SMX")
	dbSetOrder(2)
	dbSeek(xFilial()+cNum+cProduto)
	While !Eof() .And. M6_FILIAL+M6_NRREL+M6_PRODUTO == xFilial()+cNum+cProduto
		IF M6_ITEM == cItem
			AADD(aArrayPro,M6_ITEM+" - "+M6_PRODUTO)
			nCntArray++
			cCnt := StrZero(nCntArray,2)
			aArray&cCnt := {}
			While !Eof() .And. M6_FILIAL+M6_NRREL+M6_PRODUTO == xFilial()+cNum+cProduto
				If M6_ITEM == cItem
					AADD(aArray&cCnt,{ Str(M6_QUANT,9,2)," PECAS COM ",M6_COMPTO})
				EndIf
				dbSkip()
			End
		Else
			dbSkip()
		EndIF
	End
	cCnt := StrZero(nCntArray+1,2)
	aArray&cCnt := {}
	
	For nX := 1 TO Len(aArrayPro)
		If li > 58
			R820CabMed()
		EndIF
		@ li,009 PSay aArrayPro[nx]
		Li++
		Li++
		dbSelectArea("SMX")
		dbSetOrder(2)
		dbSeek( xFilial()+cNum+Subs(aArrayPro[nX],06,15) )
		While !Eof() .And. M6_FILIAL+M6_NRREL+M6_PRODUTO == xFilial()+cNum+Subs(aArrayPro[nX],06,15)
			If li > 58
				R820CabMed()
			EndIF
			IF M6_ITEM == Subs(aArrayPro[nX],1,2)
				@ li,002 PSay M6_QUANT
				@ li,013 PSay "PECAS COM"
				@ li,023 PSay M6_COMPTO
				@ li,035 PSay M6_OBS
				li ++
			EndIF
			dbSkip()
		End
		li++
	Next nX
	@ li,001 PSay "--------------------------------------------------------------------------------"
EndIf
Return Nil

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �R820CabMed � Autor � Jose Lucas           � Data � 25.01.94 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Imprime o cabecalho referentes as medidas do Pedido Filho. ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � R820CabMed(Void)                                           ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MatR820                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function R820CabMed()

Local cCabec1 := SM0->M0_NOME+"               RELACAO DE MEDIDAS             NRO :"
Local cCabec2 := "MAQUINA                       FERRAMENTA               OPERACAO"

Li := 0

Li++
@Li,00 PSay __PrtFatLine()
Li++
@Li,00 PSay cCabec1
@Li,67 PSay SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN+SC2->C2_ITEMGRD
Li++
@Li,00 PSay __PrtFatLine()
Li++
Li++
Return Nil
