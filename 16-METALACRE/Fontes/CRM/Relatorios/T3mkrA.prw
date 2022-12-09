#INCLUDE "TMKR3A.CH"
#INCLUDE "RWMAKE.CH"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun�"o    � Tmkr3A   � Autor � Armando M. Tessaroli  � Data � 26/03/03 ���
�������������������������������������������������������������������������Ĵ��
���Descri�"o � Emissao do Orcamentos de Vendas                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Televendas (SUA)                                           ���
�������������������������������������������������������������������������Ĵ��
���Analista  � Data/Bops/Ver �Manutencao Efetuada                         ���
������������������������������������������������������������������������Ĵ��
���          �        �      �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
����������������������������������������������������������������������������
/*/
User Function T3mkrA(cNumAte)

//��������������������������������������������������������������Ŀ
//� Define Variaveis                                             �
//����������������������������������������������������������������
Local wnrel   	:= "TMKR3A"  	 	// Nome do Arquivo utilizado no Spool
Local Titulo 	:= STR0001 			// "Emissao do orcamento de Vendas - Televendas"
Local cDesc1 	:= STR0002 			// "Este programa ira emitir o orcamento de vendas criado no sistema"
Local cDesc2 	:= STR0003 			// "com ou sem liberacao ou a emissao da nota fiscal."
Local cDesc3 	:= STR0004 			// "Informe os parametros de selecao para emissao dos orcamentos"
Local nReg   	:= 0
Local nomeprog	:= "TMKR3A.PRX"			// nome do programa
Local cString 	:= "SUA"				// Alias utilizado na Filtragem
Local lDic    	:= .F. 					// Habilita/Desabilita Dicionario
Local lComp   	:= .F. 					// Habilita/Desabilita o Formato Comprimido/Expandido
Local lFiltro 	:= .T. 					// Habilita/Desabilita o Filtro

Private Tamanho := "M"					// P/M/G
Private Limite  := 220 					// 80/132/220
Private aReturn := { STR0005,;			// [1] Reservado para Formulario	//"Zebrado"
					 1,;				// [2] Reservado para N� de Vias
					 STR0006,;			// [3] Destinatario					//"Administracao"
					 2,;				// [4] Formato => 1-Comprimido 2-Normal	
					 2,;	    		// [5] Midia   => 1-Disco 2-Impressora
					 1,;				// [6] Porta ou Arquivo 1-LPT1... 4-COM1...
					 "",;				// [7] Expressao do Filtro
					 1 } 				// [8] Ordem a ser selecionada
					 					// [9]..[10]..[n] Campos a Processar (se houver)

Private m_pag   := 1  				 	// Contador de Paginas
Private nLastKey:= 0  				 	// Controla o cancelamento da SetPrint e SetDefault
Private cPerg   := "TMK03A"  		 	// Pergunta do Relatorio
Private aOrdem  := {}  				 	// Ordem do Relatorio

//��������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                           �
//����������������������������������������������������������������
Pergunte(cPerg,.F.)

//���������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                          �
//� Mv_Par01           // Do Vendedor                             �
//� Mv_Par02           // Ate o Vendedor                          �
//� Mv_Par03           // A Partir de                             �
//� Mv_Par04           // Ate o dia                               �
//� Mv_Par05           // Da Orcamento                            �
//� Mv_Par06           // Ate o Orcamento                         �
//�����������������������������������������������������������������

wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,lDic,aOrdem,lComp,Tamanho,lFiltro)

If (nLastKey == 27)
	DbSelectArea(cString)
	DbSetOrder(1)
	Set Filter to
	Return
Endif

SetDefault(aReturn,cString)

If (nLastKey == 27)
	DbSelectArea(cString)
	DbSetOrder(1)
	Set Filter to
	Return
Endif

RptStatus({|lEnd| TK3AImp(@lEnd,wnRel,cString,nomeprog,Titulo,cNumAte)},Titulo)

Return(.T.)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun�"o    � TK3AImp  � Autor � Armando M. Tessaroli  � Data � 26/03/03 ���
�������������������������������������������������������������������������Ĵ��
���Descri�"o � Emissao do Orcamento de Vendas                             ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Televendas                                                 ���
�������������������������������������������������������������������������Ĵ��
���Analista  � Data/Bops/Ver �Manutencao Efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �        �      �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function TK3AImp(lEnd,wnrel,cString,nomeprog,Titulo,cNumAte)

//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para Impressao Do Cabecalho e Rodape    �
//����������������������������������������������������������������
Local nLi		:= 0			// Linha a ser impressa
Local nMax		:= 58			// Maximo de linhas suportada pelo relatorio
Local cbCont	:= 0			// Numero de Registros Processados
Local cbText	:= SPACE(10)	// Mensagem do Rodape
Local cCabec1	:= "" 			// Label dos itens
Local cCabec2	:= "" 			// Label dos itens

//�������������������������������������������������������Ŀ
//�Declaracao de variaveis especificas para este relatorio�
//���������������������������������������������������������
Local cArqTrab	:= ""		// Nome do arquivo temporario
Local nInd		:= 0		// Controle do arquivo temporario
Local cCodCli	:= ""		// Dados do cliente ou prospect
Local cNome		:= ""		// Dados do cliente ou prospect
Local cEnder	:= ""		// Dados do cliente ou prospect
Local cCGC		:= ""		// Dados do cliente ou prospect
Local cRG		:= ""		// Dados do cliente ou prospect
Local cContato	:= ""		// Nome do contato
Local cEntidade	:= ""		// Alias da entidade SA1 ou SUS
Local cFormPag	:= ""		// Forma de pagamento
Local lSC5		:= .F.		// Controle de impressao dos dados do pedido de vendas
Local aFatura	:= {}		// Dados da fatura
Local nCol		:= 0		// Controle
Local nI		:= 0		// Controle

If cNumAte <> Nil
	Mv_Par01 := ""
	Mv_Par02 := "ZZZZZZ"
	Mv_Par03 := Ctod("01/01/00")
	Mv_Par04 := Ctod(("31/12/")+Str(Year(dDataBase),4,0))
	Mv_Par05 := cNumAte
	Mv_Par06 := cNumAte
Endif

DbSelectArea("SUA")
SetRegua(RecCount())		// Total de Elementos da regua

#IFDEF TOP
	cQuery :=	" SELECT	* " +;
				" FROM " + RetSqlName("SUA") + " SUA" +;
				" WHERE	SUA.UA_FILIAL = '" + xFilial("SUA") + "' AND" +;
				"		SUA.UA_CANC = '' AND" +;
				"		SUA.UA_VEND BETWEEN '" + Mv_Par01 + "' AND '" + Mv_Par02 + "' AND" +;
				"		SUA.UA_EMISSAO BETWEEN '" + DtoS(Mv_Par03) + "' AND '" + DtoS(Mv_Par04) + "' AND" +;
				"		SUA.UA_NUM BETWEEN '" + Mv_Par05 + "' AND '" + Mv_Par06 + "' AND" +;
				"		SUA.D_E_L_E_T_ = ' ' " +;
				" ORDER BY UA_FILIAL, UA_VEND, UA_EMISSAO"
	
	cQuery	:= ChangeQuery(cQuery)
	// MemoWrite("TMKR03.SQL", cQuery)
	DbSelectArea("SUA")
	DbCloseArea()
	DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'SUA', .F., .T.)
	
	TCSetField('SUA', 'UA_EMISSAO',	'D')
	TCSetField('SUA', 'UA_PROSPEC',	'L')
	TCSetField('SUA', 'UA_DTLIM',	'D')

#ELSE
	cArqTrab := CriaTrab("",.F.)
	IndRegua(cString,cArqTrab,"SUA->UA_FILIAL+SUA->UA_VEND+DTOS(SUA->UA_EMISSAO)",,,STR0007) //"Selecionando Registros..."
	dbCommit()
	nIndex := RetIndex("SUA")
	dbSetIndex(cArqTrab+OrdBagExt())
	
	DbSelectArea("SUA")
	DbSetOrder(nIndex+1)
	MsSeek(xFilial("SUA")+(Mv_Par01),.T.) //Vendedor
	
#ENDIF

While	(!Eof())							.AND.;
		SUA->UA_FILIAL == xFilial("SUA")	.AND.;
		SUA->UA_VEND >= Mv_Par01			.AND.;
		SUA->UA_VEND <= Mv_Par02
	
	IncRegua()
	
	If lEnd
		@Prow()+1,000 PSay STR0008 //"CANCELADO PELO OPERADOR"
		Exit
	Endif
	
	//��������������������������������������������������������������Ŀ
	//� Considera filtro do usuario                                  �
	//����������������������������������������������������������������
	If (!Empty(aReturn[7])) .AND. (!&(aReturn[7]))
		DbSkip()
		Loop
	Endif
	
	#IFNDEF TOP
		//�������������������Ŀ
		//�Verifica intervalo.�
		//���������������������
		If (SUA->UA_EMISSAO < Mv_Par03) .or. (SUA->UA_EMISSAO > Mv_Par04)
			DbSkip()
			Loop
		Endif
		
		//�������������������������������Ŀ
		//�Verifica o intervalo de codigos�
		//���������������������������������
		If !Empty(Mv_Par05) .AND. !Empty(Mv_Par06)
			If SUA->UA_NUM < Mv_Par05 .Or. SUA->UA_NUM > Mv_Par06
				DbSkip()
				Loop
			Endif
		Endif
		
		//������������������������������������ �
		//�Se nao for um ORCAMENTO nao imprime�
		//������������������������������������ �
		If SUA->UA_OPER <> "2"
			DbSkip()
			Loop
		Endif
	#ENDIF
	
	//�����������������������������Ŀ
	//�Armazena os dados da Empresa.�
	//�������������������������������
	If !SUA->UA_PROSPEC
		cEntidade	:=	"SA1"
		cCodCli		:=	Posicione("SA1",1,xFilial("SA1")+SUA->UA_CLIENTE+SUA->UA_LOJA,"SA1->A1_COD") + " - " +;
						Posicione("SA1",1,xFilial("SA1")+SUA->UA_CLIENTE+SUA->UA_LOJA,"SA1->A1_LOJA")
		cNome		:=	Posicione("SA1",1,xFilial("SA1")+SUA->UA_CLIENTE+SUA->UA_LOJA,"SA1->A1_NOME")
		cEnder		:=	Posicione("SA1",1,xFilial("SA1")+SUA->UA_CLIENTE+SUA->UA_LOJA,"SA1->A1_END")
		cCGC		:=	Posicione("SA1",1,xFilial("SA1")+SUA->UA_CLIENTE+SUA->UA_LOJA,"SA1->A1_CGC")
		cRg			:=	Posicione("SA1",1,xFilial("SA1")+SUA->UA_CLIENTE+SUA->UA_LOJA,"SA1->A1_INSCR")
		If Empty(cRg)
			cRg :=	Posicione("SA1",1,xFilial("SA1")+SUA->UA_CLIENTE+SUA->UA_LOJA,"SA1->A1_RG")
		Endif
	Else
		cEntidade	:=	"SUS"
		cCodCli		:=	Posicione("SUS",1,xFilial("SUS")+SUA->UA_CLIENTE+SUA->UA_LOJA,"SUS->US_COD") + " - " +;
						Posicione("SUS",1,xFilial("SUS")+SUA->UA_CLIENTE+SUA->UA_LOJA,"SUS->US_LOJA")
		cNome    	:=	Posicione("SUS",1,xFilial("SUS")+SUA->UA_CLIENTE+SUA->UA_LOJA,"SUS->US_NOME")
		cEnder   	:=	Posicione("SA1",1,xFilial("SUS")+SUA->UA_CLIENTE+SUA->UA_LOJA,"SUS->US_END")
		cCGC     	:=	Posicione("SUS",1,xFilial("SUS")+SUA->UA_CLIENTE+SUA->UA_LOJA,"SUS->US_CGC")
	Endif
	
	//��������������������������������������������������������������Ŀ
	//�Monta uma string com as formas de pagamento utilizada na venda�
	//����������������������������������������������������������������
	DbSelectArea("SL4")
	DbSetOrder(1)
	cFormPag := ""
	If MsSeek(xFilial("SL4") + SUA->UA_NUM + "SIGATMK")
		While	(!Eof())							.AND.;
				SL4->L4_Filial == xFilial("SL4")	.AND.;
				SL4->L4_Num == SUA->UA_NUM			.AND.;
				Trim(SL4->L4_ORIGEM) == "SIGATMK"
			
			If !(Trim(SL4->L4_FORMA) $ cFormPag)
				cFormPag := cFormPag + Trim(SL4->L4_FORMA) + "/"
			Endif
			AaDd(aFatura, {SL4->L4_Data, SL4->L4_Valor, SL4->L4_Forma} )
			DbSkip()
		End
		cFormPag := SubStr(cFormPag,1,Len(cformPag)-1)
	Endif
	
	//�����������������������������Ŀ
	//�Seleciona contato.           �
	//�������������������������������
	cContato := Posicione("SU5",1,xFilial("SU5")+SUA->UA_CODCONT,"U5_CONTAT")
	
	//�����������������������������������������������������������Ŀ
	//�Funcao que incrementa a linha e verifica a quebra de pagina�
	//�������������������������������������������������������������
	Tk3ALinha(@nLi,nMax+1,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho)
	@ nLi,000 PSay __PrtThinLine()
	
	Tk3ALinha(@nLi,1,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho)
	@ nLi,000 PSay "| " + PadR(STR0009,9) + " " + PadR(cCodCli,30) //"Empresa"
	@ nLi,044 PSay "|"
	@ nLi,046 PSay PadR(STR0010,25) //"LOCAL DE ENTREGA"
	@ nLi,088 PSay "|"
	@ nLi,090 PSay PadR(STR0011,25) //"ENDERECO DE COBRANCA"
	@ nLi,131 PSay "|"
	
	Tk3ALinha(@nLi,1,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho)
	@ nLi,000 PSay "| " + PadR(cNome,40) // STR0012 - "Nome"
	@ nLi,044 PSay "|"
	@ nLi,045 PSay Repl("-",43)
	@ nLi,088 PSay "|"
 	@ nLi,089 PSay Repl("-",42)
	@ nLi,131 PSay "|"
	
	Tk3ALinha(@nLi,1,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho)
	@ nLi,000 PSay "| " + PadR(cEnder,40) // STR0013 - "Endereco"
	@ nLi,044 PSay "|"
	@ nLi,046 PSay SubStr(SUA->UA_ENDENT,1,40)
	@ nLi,088 PSay "|"
	@ nLi,090 PSay SubStr(SUA->UA_ENDCOB,1,40)
	@ nLi,131 PSay "|"
	
	Tk3ALinha(@nLi,1,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho)
	@ nLi,000 PSay "| " + PadR(cRg,30) // STR0014 - "Inscr./RG"
	@ nLi,044 PSay "|"
	@ nLi,046 PSay Transform(SUA->UA_CEPE, "99999-999") + SubStr(SUA->UA_BAIRROE,1,31)
	@ nLi,088 PSay "|"
	@ nLi,090 PSay Transform(SUA->UA_CEPC, "99999-999") + SubStr(SUA->UA_BAIRROC,1,31)
	@ nLi,131 PSay "|"
	
	Tk3ALinha(@nLi,1,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho)
	@ nLi,000 PSay "| "		// STR0015 - "CPF/CNPJ"
	@ nLi,002 PSay cCGC Picture IIF(Len(cCGC)==14,'@R 99.999.999/9999-99','@R 999.999.999-99')
	@ nLi,044 PSay "|"
	@ nLi,046 PSay Trim(SubStr(SUA->UA_MUNE,1,35)) + " - " + SUA->UA_ESTE
	@ nLi,088 PSay "|"
	@ nLi,090 PSay Trim(SubStr(SUA->UA_MUNC,1,35)) + " - " + SUA->UA_ESTC
	@ nLi,131 PSay "|"
	
	Tk3ALinha(@nLi,1,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho)
	@ nLi,000 PSay __PrtThinLine()
	
	
	//������������������������������Ŀ
	//�Imprime os dados do orcamento.�
	//��������������������������������
	dbSelectArea("SUA")
	Tk3ALinha(@nLi,2,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho)
	@ nLi,000 PSay __PrtFatLine()
	
	Tk3ALinha(@nLi,1,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho)
	@ nLi,000 PSay STR0016 + SUA->UA_NUM //"Atendimento : "
	@ nLi,066 PSay STR0018 + Dtoc(SUA->UA_EMISSAO) //"Emissao     : "
	
	Tk3ALinha(@nLi,1,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho)
	@ nLi,000 PSay STR0022 + SubStr(cContato,1,49) //"Contato     : "
	@ nLi,066 PSay STR0020 + SUA->UA_INICIO + " / " + SUA->UA_FIM //"Inicio / Fim: "
	
	Tk3ALinha(@nLi,1,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho)
	@ nLi,000 PSay STR0024 + SubStr(Posicione("SA3",1,xFilial("SA3")+SUA->UA_VEND,"A3_NOME"),1,49) //"Vendedor    : "
	@ nLi,066 PSay STR0025 + SubStr(Posicione("SE4",1,xFilial("SE4")+SUA->UA_CONDPG,"E4_DESCRI"),1,48) //"Cond. Pagto : "
	
	Tk3ALinha(@nLi,1,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho)
	@ nLi,000 PSay STR0026 + SubStr(Posicione("SU7",1,xFilial("SU7")+SUA->UA_OPERADO,"U7_NOME"),1,49) //"Operador    : "
	@ nLi,066 PSay STR0027 + If(SUA->UA_TPCARGA=="1",STR0028,STR0029) //"Mapa Carreg.: "###"CARREGA"###"NAO CARREGA"
	
	Tk3ALinha(@nLi,1,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho)
	@ nLi,000 PSay STR0030 + SubStr(cFormPag,1,49) //"Forma Pagto : "
	@ nLi,066 PSay STR0031 + Transform(SUA->UA_PDESCAB, "@E 999.99") //"Indenizacao : "
	
	Tk3ALinha(@nLi,1,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho)
	@ nLi,000 PSay STR0032 + SubStr(Posicione("SA4",1,xFilial("SA4")+SUA->UA_TRANSP,"A4_NOME"),1,49) //"Transportad.: "
	@ nLi,066 PSay STR0033 + DtoC(SUA->UA_DTLIM) //"Validade    : "
	
	Tk3ALinha(@nLi,1,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho)
	@ nLi,000 PSay __PrtThinLine()
	
	//���������������������������������������������������������������������Ŀ
	//�  Impresssao do campo memo da observacao						        �
	//�����������������������������������������������������������������������
	aLinha := Tk3AMemo(SUA->UA_CODOBS, 120)
	If Len(aLinha) > 0
		For nI := 1 To Len(aLinha)
			Tk3ALinha(@nLi,1,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho)
			If nI == 1
				@ nLi,000 PSay PadR(STR0034,12) //"Observacao: "
			Endif
			@ nLi,13 PSay aLinha[nI]
		Next nI
	Endif
	
	//����������������������������������������Ŀ
	//�Imprime os produtos/servicos orcamentos.�
	//������������������������������������������
	dbSelectArea("SUB")
	dbSetOrder(1)
	If dbSeek(xFilial("SUB")+SUA->UA_NUM)
		Tk3ALinha(@nLi,1,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho)
		@ nLi,000 PSay __PrtThinLine()
		
		Tk3ALinha(@nLi,1,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho)
		@ nLi,000 PSay PadR(STR0035,Limite) //"Item Produto         Descricao                     UM   Qtde     Vlr Unit.      Vlr Item %Desc.     Val. Desc. %Acresc.  Val Acresc."
		
		Tk3ALinha(@nLi,1,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho)
		@ nLi,000 PSay __PrtThinLine()
		
		nTotQtd  := 0 
		nTotGeral:= 0
		
		While	(!Eof())							.AND.;
				xFilial("SUB") == SUB->UB_FILIAL	.AND.;
				SUA->UA_NUM    == SUB->UB_NUM
			
			DbSelectArea("SB1")
			DbSetOrder(1)
			DbSeek(xFilial("SB1")+SUB->UB_PRODUTO)
			
			Tk3ALinha(@nLi,1,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho)
			@ nLi,000		  	PSay SUB->UB_ITEM			PICTURE PESQPICT("SUB","UB_ITEM")
			@ nLi,PCol()+3  	PSay SB1->B1_COD 			PICTURE PESQPICT("SB1","B1_COD")
			@ nLi,PCol()+1  	PSay Left(SUB->UB_XDESCR ,29)	PICTURE PESQPICT("SB1","B1_DESC")
			@ nLi,PCol()+3  	PSay SB1->B1_UM				PICTURE PESQPICT("SB1","B1_UM")
			@ nLi,PCol()+1  	PSay SUB->UB_QUANT			PICTURE "@E 99999.99"
			@ nLi,PCol()  		PSay SUB->UB_VRUNIT			PICTURE "@E 99,999,999.99"
			@ nLi,PCol()+1	  	PSay SUB->UB_VLRITEM		PICTURE "@E 99,999,999.99"
			@ nLi,PCol()    	PSay SUB->UB_DESC			PICTURE PESQPICT("SUB","UB_DESC")
			@ nLi,PCol()+1    PSay SUB->UB_VALDESC		PICTURE PESQPICT("SUB","UB_VALDESC")
			@ nLi,PCol()+1    PSay SUB->UB_ACRE			PICTURE PESQPICT("SUB","UB_ACRE")
			@ nLi,PCol()+0.5  PSay SUB->UB_VALACRE		PICTURE PESQPICT("SUB","UB_VALACRE")
			
			nTotQtd  += SUB->UB_QUANT
			nTotGeral+= SUB->UB_VLRITEM 
			
			dbSelectArea("SUB")
			dbSkip()
		End
		
		
		//����������������������������������������Ŀ
		//�Imprime os totais de quantidade e valor.�
		//������������������������������������������
		Tk3ALinha(@nLi,1,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho)
		@ nLi,000 PSay __PrtThinLine()
		
		Tk3ALinha(@nLi,1,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho)
		@ nLi,053 PSay PadR(STR0036,23) + Transform(nTotQtd, "@E 99,999,999.99") //"Total das quantidades"
		@ nLi,096 PSay PadR(STR0037,24) + Transform(nTotGeral, "@E 99,999,999.99") //"Valor total do orcamento"
	Endif
	
	//�������������������������������Ŀ
	//�Imprime as formas de pagamento.�
	//���������������������������������
	If len(aFatura) > 0
		nCol := 0
		Tk3ALinha(@nLi,3,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho)
		@ nLi,000 PSay __PrtFatLine()
		
		Tk3ALinha(@nLi,1,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho)
		@ nLi,000 PSay PadR(STR0038,Limite) //"| Vencto   Forma          Valor || Vencto   Forma          Valor || Vencto   Forma          Valor || Vencto   Forma          Valor |"
		
		Tk3ALinha(@nLi,1,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho)
		@ nLi,000 PSay __PrtThinLine()
		
		Tk3ALinha(@nLi,1,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho)
		For nI := 1 to len(aFatura)
			If nCol == 0
				@ nLi,nCol PSay "| " + DtoC(aFatura[nI][1]) + " " + SubStr(aFatura[nI][3],1,9) + " " + Transform(aFatura[nI][2], "@E 999,999.99")
				nCol+=32
			Else
				@ nLi,nCol PSay "|| " + DtoC(aFatura[nI][1]) + " " + SubStr(aFatura[nI][3],1,9) + " " + Transform(aFatura[nI][2], "@E 999,999.99")
				nCol+=33
			Endif
			If nCol == 131
				@ nLi,nCol PSay "|"
				Tk3ALinha(@nLi,3,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho)
				nCol := 0
			Endif
		Next nI
		
		If nCol == 32
			@ nLi,nCol		PSay "||"
			@ nLi,nCol+33	PSay "||"
			@ nLi,nCol+66	PSay "||"
			@ nLi,131	PSay "|"
			Tk3ALinha(@nLi,1,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho)
		Elseif nCol == 65
			@ nLi,nCol		PSay "||"
			@ nLi,nCol+33	PSay "||"
			@ nLi,131	PSay "|"
			Tk3ALinha(@nLi,1,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho)
		Elseif nCol == 98
			@ nLi,nCol		PSay "||"
			@ nLi,131	PSay "|"
			Tk3ALinha(@nLi,1,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho)
		Endif
		@ nLi,000 PSay __PrtThinLine()
	Endif
	
	aFatura   := {}
	nTotQtd   := 0
	nTotGeral := 0
	
	dbSelectArea("SUA")
	dbSkip()
	
End

//�����������������������������Ŀ
//�Imprime o rodape do relatorio�
//�������������������������������
Roda(cbCont,cbText,Tamanho)

#IFDEF TOP
	DbSelectArea("SUA")
	DbCloseArea()
	ChkFile("SUA")
#ELSE
	dbSelectArea("SUA")
	RetIndex("SUA")
	Set Filter To
	dbSetOrder(1)
	FErase(cArqTrab+OrdBagExt())
	FErase(cArqTrab)
#ENDIF

Set Device To Screen

If aReturn[5] == 1
	Set Printer TO
	dbcommitAll()
	ourspool(wnrel)
Endif

MS_FLUSH()

Return(.T.)



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
��������������������������������������������������������������������������"��
���Programa  �Tk3AMemo  �Autor  �Armando M. Tessaroli� Data �  25/03/03   ���
�������������������������������������������������������������������������͹��
���Desc.     �Monta o texto conforme foi digitado pelo operador e quebra  ���
���          �as linhas no tamanho especificado sem cortar palavras e     ���
���          �devolve um array com os textos a serem impressos.           ���
�������������������������������������������������������������������������͹��
���Uso       � Call Center                                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function Tk3AMemo(cCodigo,nTam)

Local cString	:= MSMM(cCodigo,nTam)		// Carrega o memo da base de dados
Local nI		:= 0    					// Contador dos caracteres	
Local nJ		:= 0    					// Contador dos caracteres	
Local nL		:= 0						// Contador das linhas 
Local cLinha	:= ""						// Guarda a linha editada no campo memo
Local aLinhas	:= {}						// Array com o memo dividido em linhas

For nI := 1 TO Len(cString)
	If (MsAscii(SubStr(cString,nI,1)) <> 13) .AND. (nL < nTam)
		// Enquanto n�o houve enter na digitacao e a linha nao atingiu o tamanho maximo
		cLinha+=SubStr(cString,nI,1)
		nL++
	Else    
		// Se a linha atingiu o tamanho maximo ela vai entrar no array
		If MsAscii(SubStr(cString,nI,1)) <> 13
			nI--
			For nJ := Len(cLinha) To 1 Step -1
				// Verifica se a ultima palavra da linha foi quebrada, entao retira e passa pra frente
				If SubStr(cLinha,nJ,1) <> " "
					nI--
					nL--
				Else
					Exit
				Endif
			Next nJ
			// Se a palavra for maior que o tamanho maximo entao ela vai ser quebrada
			If nL <=0
				nL := Len(cLinha)
			Endif
		Endif
		
		// Testa o valor de nL para proteger o fonte e insere a linha no array
		If nL >= 0
			cLinha := SubStr(cLinha,1,nL)
			AAdd(aLinhas, cLinha)
			cLinha := ""
			nL := 0
		Endif	
	Endif
Next nI

// Se o nL > 0, eh porque o usuario nao deu enter no fim do memo e eu adiciono a linha no array.
If nL >= 0
	cLinha := SubStr(cLinha,1,nL)
	AAdd(aLinhas, cLinha)
	cLinha := ""
	nL := 0
Endif	

Return(aLinhas)



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
��������������������������������������������������������������������������"��
���Programa  �Tk3ALinha �Autor  �Armando M. Tessaroli� Data �  06/02/03   ���
�������������������������������������������������������������������������͹��
���Desc.     �   Incrementa o contador de linhas para impress�o nos relato���
���          �rios e verifica se uma nova pagina sera iniciada.           ���
�������������������������������������������������������������������������͹��
���Uso       � Call Center                                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function Tk3ALinha(	nLi,		nInc,		nMax,		titulo,;
	   						cCabec1,	cCabec2,	nomeprog,	tamanho)

Local nChrComp	:= IIF(aReturn[4]==1,15,18)

nLi+=nInc
If nLi > nMax .or. nLi < 5
	nLi := Cabec(titulo,cCabec1,cCabec2,nomeprog,tamanho,nChrComp)
	nLi++
Endif

Return(Nil)
