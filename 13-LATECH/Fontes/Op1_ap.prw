#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05
#IFNDEF WINDOWS
	#DEFINE PSAY SAY
#ENDIF

User Function Op1()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP6 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("TITULO,CSTRING,WNREL,CDESC,AORD,TAMANHO")
SetPrvt("LIMITE,ARETURN,CPERG,NLASTKEY,CBCONT,NQUANTITEM")
SetPrvt("CABEC1,COP,CDESCRI,CABEC2,NQUANT,NOMEPROG")
SetPrvt("NTIPO,CPRODUTO,CQTD,CINDSC2,NINDSC2,AARRAY")
SetPrvt("LI,CBTXT,M_PAG,COBSERV,XORDEM,LEND")
SetPrvt("DDTFIM,CTIPOCONV,NFATORCONV,CETAPA,I,T")
SetPrvt("NCONV,_NPESO,_NMETRAG,NBEGIN,_C2RECNO,DDTAFIN")
SetPrvt("AARRAYPRO,LIMPITEM,NCNTARRAY,A01,A02,NX")
SetPrvt("NI,NL,NY,CNUM,CITEM,LIMPCAB")
SetPrvt("CDESCRI1,CDESCRI2,CCNT,CCABEC1,CCABEC2,_APERGUNTAS")
SetPrvt("_NLACO,")

#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 12/02/05 ==> 	#DEFINE PSAY SAY
#ENDIF

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � MATR820  � Autor � Paulo Boschetti       � Data � 07.07.92 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Relacao Das Ordens de Producao                             ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe e � MATR820(void)                                              ���
�������������������������������������������������������������������������Ĵ��
���OBS       � Programa transf. em RDMAKE por Fabricio Carlos David (CTC) ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
/*/

titulo   := ""
cString  := "SC2"
wnrel    :="MATR820"
cDesc    := "Este programa ira imprimir a Rela��o das Ordens de Produ��o"
aOrd     := {"Por Numero","Por Produto","Por Centro de Custo","Por Prazo de Entrega"}
tamanho  := "P"
limite   := 80 
aReturn  := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
cPerg    :="KENREC    "
nLastKey := 0
//��������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                           �
//����������������������������������������������������������������

    Pergunta(cPerg)          // Caso nao exista Cria o grupo de perguntas
    pergunte(cPerg,.F.)

//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                         �
//� mv_par01            // Da OP                                 �
//� mv_par02            // Ate a OP                              �
//� mv_par03            // Da data                               �
//� mv_par04            // Ate a data                            �
//� mv_par05            // Imprime Nome Cientifico               �
//� mv_par06            // Cor do Produto                        �
//� mv_par07            // Pecas                                 �
//� mv_par08            // Pecas                                 �
//� mv_par09            // Tear                                  �
//� mv_par10            // Urdume                                �
//� mv_par11            // Trama                                 �
//� mv_par12            // Lote                                  �
//� mv_par13            // Lote                                  �
//����������������������������������������������������������������

If !ChkFile("SH8",.F.)
	Help(" ",1,"SH8EmUso")
	Return()
Endif

//��������������������������������������������������������������Ŀ
//� Envia controle para a funcao SETPRINT                        �
//����������������������������������������������������������������

wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc,"","",.F.,aOrd)

If nLastKey == 27
	dbSelectArea("SH8")
	Set Filter To
	dbCloseArea()
	//��������������������������������������������������������������Ŀ
	//� Retira o SH8 da variavel cFopened ref. a abertura no MNU     �
	//����������������������������������������������������������������
	ClosFile("SH8")
	dbSelectArea("SC2")
	Return()
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
	Return()
Endif

#IFDEF WINDOWS
  RptStatus({||R820Imp()})// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==>   RptStatus({||Execute(R820Imp)})
#ELSE
  R820Imp()
#ENDIF

Return(NIL)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � R820Imp  � Autor � Waldemiro L. Lustosa  � Data � 13.11.95 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Chamada do Relat�rio                                       ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR820                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function R820Imp
Static Function R820Imp()

//��������������������������������������������������������������Ŀ
//� Define Variaveis                                             �
//����������������������������������������������������������������
CbCont:=""
nQuantItem:=0
cabec1:=""
cOp:="" 
cDescri:=""
cabec2:=""
limite := 80
nQuant := 1
nomeprog   := "MATR820"
nTipo      := 18
cProduto   := SPACE(LEN(SC2->C2_PRODUTO))
cQtd       :=""
cIndSC2 := CriaTrab(NIL,.F.)
nIndSC2 :=0
aArray   :={}
li := 80
//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para Impressao do Cabecalho e Rodape    �
//����������������������������������������������������������������
cbtxt    := SPACE(10)
cbcont   := 0
m_pag    := 1
//��������������������������������������������������������������Ŀ
//� Monta os Cabecalhos                                          �
//����������������������������������������������������������������
cabec1 := ""
cabec2 := ""

//��������������������������������������������������������������Ŀ
//� Observacoes                                                  �
//����������������������������������������������������������������

cObserv := "" 
xORDEM  := Substr(mv_par01, 1, 6)
DbSelectArea("SC2")
DbSetOrder(1)

If DbSeek( xFilial("SC2") + xORDEM )
   While SC2->C2_FILIAL == xFilial("SC2") .and. ;
	 Substr(SC2->C2_NUM,1,6) == xORDEM
	 cObserv := cObserv + AllTrim(SC2->C2_OBS)
	 DbSkip()
   EndDo
EndIf

dbSelectArea("SC2")
If aReturn[8] == 4
	#IFDEF AS400
	  IndRegua("SC2",cIndSC2,"C2_FILIAL+C2_DATPRF",,,"Selecionando Registros...")
	#ELSE
	  IndRegua("SC2",cIndSC2,"C2_FILIAL+DTOS(C2_DATPRF)",,,"Selecionando Registros...")
	#ENDIF
	
	dbGoTop()
Else
	dbSetOrder(aReturn[8])
EndIf

dbSeek(xFilial())

SetRegua(LastRec())

While !Eof()
	
	#IFNDEF WINDOWS
	  If LastKey() == 286    //ALT_A
		  lEnd := .t.
		  Exit
	  End
	#ENDIF
	
	IF LastKEy()==27
		@ Prow()+1,001 PSAY "CANCELADO PELO OPERADOR"
		Exit
	EndIF
	
	IncRegua()
	
	If C2_FILIAL+C2_NUM+C2_ITEM+C2_SEQUEN < xFilial()+mv_par01 .or. C2_FILIAL+C2_NUM+C2_ITEM+C2_SEQUEN > xFilial()+mv_par02
		dbSkip()
		Loop
	EndIf
	
	If  C2_DATPRF < mv_par03 .Or. C2_DATPRF > mv_par04
		dbSkip()
		Loop
	Endif

	cProduto  := SC2->C2_PRODUTO
	nQuant    := SC2->C2_QUANT - SC2->C2_QUJE - SC2->C2_PERDA
	dDtFim    := SC2->C2_DATPRF
	
	dbSelectArea("SB1")
	dbSetOrder(1)
	dbSeek(xFilial()+cProduto)

	//��������������������������������������������������������������Ŀ
	//� Adiciona o primeiro elemento da estrutura , ou seja , o Pai  �
	//����������������������������������������������������������������
	
	cTipoConv  := SB1->B1_TIPCONV
	nFatorConv := SB1->B1_CONV

	//��������������������������������������������������������������Ŀ
	//� Adiciona o primeiro elemento da estrutura , ou seja , o Pai  �
	//����������������������������������������������������������������
	AddAr820(nQuant)

	cOp:=SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN
	MontStruc() 
	
	aSort( aArray,2,, { |x, y| (x[8]+x[7]) < (y[8]+y[7]) } )

	Li := 0                                 // linha inicial do relatorio
	
	
	//���������������������������������������������������������Ŀ
	//� Imprime cabecalho                                       �
	//�����������������������������������������������������������
	cabecOp()  // MSG
	cEtapa  := "001"

	For I := 2 TO Len(aArray)
		 
		 DbSelectArea("SG1")
		 DbSetOrder(1)
		 DbSeek( xFilial("SG1") + aArray[1][1] + aArray[I][1] + aArray[I][7] )
					 // Produto    + Etapa        + Sequencia
		
		 If cEtapa <> SG1->G1_ETAPA
                    @ Li , 000 PSAY "+----------+--------+------------------------------------+-----------+--------+"
		      Li := Li + 1
		      cEtapa := SG1->G1_ETAPA
		 EndIf
		
		@ Li , 000 PSAY "| "
		//cQtd:= Alltrim(Transform(aArray[I][5],PesqPictQt("D4_QUANT",11,4)))
		cQtd:= aArray[I][5]
        @ Li , 003 PSAY SG1->G1_QUANT     PICTURE "@E 999.999"      // QUANTIDADE DA ESTRUTURA
		@ Li , 011 PSAY "|"
		@ Li , 014 PSAY aArray[I][1]                                // CODIGO PRODUTO
		@ Li , 021 PSAY "|" 
        @ li , 022 PSAY Substr(AllTrim(aArray[I][2]),1,28)          // DESCRICAO
        @ Li , 058 PSAY "|"
        @ li,  059 PSAY cQtd   PICTURE "@E 9999.999 9"                 // QUANTIDADE EMPENHADA
		@ Li , 070 PSAY "|"
		@ Li , 079 PSAY "|"
		Li:=Li+1                                 
		skip
		
		//���������������������������������������������������������Ŀ
		//� Se nao couber, salta para proxima folha                 �
		//�����������������������������������������������������������
		
		IF li > 63
			Li := 0
			cabecOp()               // imprime cabecalho da OP
		EndIF
		
	Next 
	
	//��������������������������������������������������������������Ŀ
	//� Imprimir Rodape                                              �
	//����������������������������������������������������������������
	
	For T := 1 To 2   // COMPLETA DUAS LINHAS DO FORMULARIO
	    @ Li , 000 PSAY "|"     
	    @ Li , 078 PSAY "|"
	      Li := Li + 1
	Next
	    @ Li , 000 PSAY "| DATA DE PREVISAO.: " + Dtoc( dDtaFin )
	    @ Li , 078 PSAY "|"
	      Li := Li + 1
	    @ Li , 000 PSAY "|"     
	    @ Li , 078 PSAY "|"
	      Li := Li + 1
        @ Li , 000 PSAY "+----------+--------+------------------------------------+-----------+--------+"
          Li := Li + 2
        @ Li , 040 PSAY "_______________________________________"
          Li := Li + 1
        @ Li , 040 PSAY "| DEPARTAMENTO |   DATA   |   VISTO   |"
          Li := Li + 1
        @ Li , 040 PSAY "_______________________________________"
          Li := Li + 1
        @ Li , 040 PSAY "| Digitacao    |          |           |"
          Li := Li + 1
        @ Li , 040 PSAY "_______________________________________"
          Li := Li + 1
        @ Li , 040 PSAY "| Conferencia  |          |           |"
          Li := Li + 1
        @ Li , 040 PSAY "_______________________________________"
	
	//��������������������������������������������������������������Ŀ
	//� Imprimi Ficha de Rolo                                        �
	//����������������������������������������������������������������
	  li := 000

        @ li , 000 PSAY Padc(Alltrim(SM0->M0_NOMECOM),80)
          li := li + 2
        @ li , 000 PSAY Padc("FICHA DE ROLO - "+SC2->C2_NUM,80)
          li := li + 3
	@ li , 000 PSAY "PRODUTO : "
        @ li , 010 PSAY Alltrim(cProduto) + " "+Substr( cDescri,1 , 30 )
        @ li , 059 PSAY "TEAR    : "+ mv_par09
	  li := li + 2
	 
	 //���������������������������������������������������������Ŀ
	 //� Verifica conversao do produto                           �
	 //�����������������������������������������������������������

	   If Empty( SC2->C2_QTSEGUM )
		   nConv := IIF( cTipoConv == "M" , (SC2->C2_QUANT - SC2->C2_QUJE) * nFatorConv,  (SC2->C2_QUANT - SC2->C2_QUJE) / nFatorConv )
	      Else
		   nConv := SC2->C2_QTSEGUM             // QUANT. 2a UNIDADE DE MED. ATRAVES DA DIGITACAO NA OP
	   EndIf
	
           @ li , 000 PSAY "PESO    : "
	   _nPeso := IIF(SC2->C2_UM=="KG",SC2->C2_QUANT - SC2->C2_QUJE - SC2->C2_PERDA,nConv)
           @ li , 004 PSAY _nPeso
           @ li , 020 PSAY "METRAGEM : "
	   _nMetrag := IIF(SC2->C2_UM=="KG",nConv,SC2->C2_QUANT - SC2->C2_QUJE - SC2->C2_PERDA)
       @ li , 032 PSAY _nMetrag Picture "@E 99999.99"
	
        @ li , 060 PSAY "PARTIDA : "
        @ li , 070 PSAY SC2->C2_NUM
	  li := li + 2
        @ li , 000 PSAY "URDUME  : " + mv_par10
        @ li , 020 PSAY "LOTE     : " + mv_par12
    @ li , 060 PSAY "PREVISAO : " + Dtoc( dDtaFin )
	  li := li + 2
        @ li , 000 PSAY "TRAMA   : " + mv_par11
        @ li , 020 PSAY "LOTE     : " + mv_par13
	  li := li + 2
        @ li , 000 PSAY "COR     : " + mv_par06
	  li := li + 2
	@ li , 000 PSAY "+-----------------+-------------------+-------------------+--------------------+"
	  li := li + 1
	@ li , 000 PSAY "| LAVAR JIGGER No.|  TINGIR TURBO No. | TINGIR JIGGER No. |  ENROLADEIRA No.   |"
	  li := li + 1
	@ li , 000 PSAY "+-----------------+-------------------+-------------------+--------------------+"
	  li := li + 1
	@ li , 000 PSAY "|"
	@ li , 018 PSAY "|"
	@ li , 038 PSAY "|"
	@ li , 058 PSAY "|"
	@ li , 079 PSAY "|"
	  li := li + 1
	@ li , 000 PSAY "|"
	@ li , 018 PSAY "|"
	@ li , 038 PSAY "|"
	@ li , 058 PSAY "|"
	@ li , 079 PSAY "|"
	  li := li + 1
	@ li , 000 PSAY "+-----------------+-------------------+-------------------+--------------------+"
	  li := li + 1
	@ li , 000 PSAY "| Oper.:          | Oper.:            | Oper.:            | Oper.:             |" 
	  li := li + 1
	@ li , 000 PSAY "+-----------------+-------------------+-------------------+--------------------+"
	  li := li + 2
	@ li , 000 PSAY "+-------+---------+-----------+---------+------------+-------+-----------------+"
	  li := li + 1
	@ li , 000 PSAY "| RAMA  | LARG.   | MTS. MIN. | TEMP.   | OPERADOR   | DATA  | OBSERVACAO      |"
	  li := li + 1
	@ li , 000 PSAY "+-------+---------+-----------+---------+------------+-------+-----------------+"
	  li := li + 1
	@ li , 000 PSAY "| SECAR |         |           |         |            |       |                 |"
	  li := li + 1
	@ li , 000 PSAY "+-------+---------+-----------+---------+------------+-------+-----------------+"
	  li := li + 1
	@ li , 000 PSAY "| FIXAR |         |           |         |            |       |                 |"
	  li := li + 1
	@ li , 000 PSAY "+-------+---------+-----------+---------+------------+-------+-----------------+"
	  li := li + 1
	@ li , 000 PSAY "| ACAB. |         |           |         |            |       |                 |"
	  li := li + 1
	@ li , 000 PSAY "+-------+---------+-----------+---------+------------+-------+-----------------+"
	  li := li + 2

    @ li , 000 PSAY "OBSERVACOES : " + Subs(cObserv,01,40)
	  li := li + 1
    @ li , 000 PSAY "              " + Subs(cObserv,41,80)
	  li := li + 2
	@ li , 000 PSAY "PECAS : " + mv_par07
	  li := li + 1
	@ li , 010 PSAY mv_par08
	  li := li + 1
    @ li , 000 PSAY PADC("R  E  V  I  S  A  O",80)
      li := li + 3
    @ li , 000 PSAY "PROD : ______  PROD : ______  REPR : ______  +---------------------------------+"
      li := li + 1
    @ li , 000 PSAY "                                             |           OBSERVACOES           |"
      li := li + 1
    @ li , 000 PSAY "PROD : ______  PROD : ______  REPR : ______  |                                 |"
      li := li + 1
    @ li , 000 PSAY "                                             +---------------------------------+"
      li := li + 1
    @ li , 000 PSAY "PROD : ______  PROD : ______  REPR : ______  |                                 |"
      li := li + 1
    @ li , 000 PSAY "                                             +---------------------------------+"
      li := li + 1
    @ li , 000 PSAY "PROD : ______  PROD : ______  RETA : ______  |                                 |"
      li := li + 1
    @ li , 000 PSAY "                                             +---------------------------------+"
      li := li + 1
    @ li , 000 PSAY "PROD : ______  PROD : ______  ENCO : ______  |                                 |"
      li := li + 1
    @ li , 000 PSAY "                                             +---------------------------------+"
      li := li + 1
    @ li , 000 PSAY "                                             |                                 |"
      li := li + 1
    @ Li , 000 PSAY "_______________________________________      +---------------------------------+"
      Li := Li + 1
    @ Li , 000 PSAY "| DEPARTAMENTO |   DATA   |   VISTO   |      |                                 |"
      Li := Li + 1
    @ Li , 000 PSAY "_______________________________________      +---------------------------------+"
      Li := Li + 1
    @ Li , 000 PSAY "| Revisao      |          |           |      |                                 |"
      Li := Li + 1
    @ Li , 000 PSAY "_______________________________________      +---------------------------------+"
      Li := Li + 1
    @ Li , 000 PSAY "| Digitacao    |          |           |      |                                 |"
      Li := Li + 1
    @ Li , 000 PSAY "_______________________________________      +---------------------------------+"

	//��������������������������������������������������������������Ŀ
	//� Imprimir Relacao de medidas para Cliente == HUNTER DOUGLAS.  �
	//����������������������������������������������������������������
	dbSelectArea("SX3")
	dbSetOrder(1)
	dbSeek("SMX")
	If Found() .And. SC2->C2_DESTINA == "P"
		R820Medidas()
	EndIf
	
	m_pag:=m_pag+1
	Li := 0                                 // linha inicial - ejeta automatico
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

Set device to Screen

If aReturn[5] == 1
	Set Printer TO
	dbCommitall()
	ourspool(wnrel)
Endif

MS_FLUSH()

Return(NIL)
/*/
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
/*/
// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function AddAr820
Static Function AddAr820()

cDesc := SB1->B1_DESC
//�����������������������������������������������������������Ŀ
//� Verifica se imprime nome cientifico do produto. Se Sim    �
//� verifica se existe registro no SB5 e se nao esta vazio    �
//�������������������������������������������������������������
If mv_par05 == 1
	dbSelectArea("SB5")
	dbSeek(xFilial()+SB1->B1_COD)
	If Found() .and. !Empty(B5_CEME)
		cDesc := B5_CEME
	EndIf
ElseIf mv_par05 == 2
	cDesc := SB1->B1_DESC
Else
      //�����������������������������������������������������������Ŀ
      //� Verifica se imprime descricao digitada ped.venda, se sim  �
      //� verifica se existe registro no SC6 e se nao esta vazio    �
      //�������������������������������������������������������������
	
	If SC2->C2_DESTINA == "P"
		dbSelectArea("SC6")
		dbSetOrder(1)
		dbSeek(xFilial()+SC2->C2_NUM+SC2->C2_ITEM)
		If Found() .and. !Empty(C6_DESCRI) .and. C6_PRODUTO==SB1->B1_COD
			cDesc := C6_DESCRI
		ElseIf C6_PRODUTO #SB1->B1_COD
			dbSelectArea("SB5")
			dbSeek(xFilial()+SB1->B1_COD)
			If Found() .and. !Empty(B5_CEME)
				cDesc := B5_CEME
		       EndIf
		EndIf
	EndIf
EndIf

dbSelectArea("SB2")
dbSeek(xFilial()+SB1->B1_COD)
dbSelectArea("SD4")

DbSelectArea("SG1") // msg
DbSetOrder(3)
DbSeek( xFilial("SG1") + SD4->D4_COD )
	     
dbSelectArea("SD4")
	     //  01         02    03         04         05     06                 07          08
AADD(aArray,{SB1->B1_COD,cDesc,SB1->B1_TIPO,SB1->B1_UM,nQuant,SB2->B2_LOCALIZ,SD4->D4_TRT,SG1->G1_ETAPA } ) //nQuant

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

Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function MontStruc
Static Function MontStruc()

dbSelectArea("SD4")
dbSetOrder(2)
dbSeek(xFilial()+cOp)

While !Eof() .And. D4_FILIAL+D4_OP == xFilial()+cOp
	//���������������������������������������������������������Ŀ
	//� Posiciona no produto desejado                           �
	//�����������������������������������������������������������
	dbSelectArea("SB1")
	dbSeek(xFilial()+SD4->D4_COD)
	If SD4->D4_QUANT > 0
		nQuant:=SD4->D4_QUANT
		AddAr820()
	EndIf
	dbSelectArea("SD4")
	dbSkip()
Enddo

dbSetOrder(1)

Return()

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

Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function CabecOp
Static Function CabecOp()

nBegin:=0

If li #5
    li := 0
Endif

@ LI , 000 PSAY Padc(Alltrim(SM0->M0_NOMECOM),80)
  LI := LI + 1
@ LI , 000 PSAY Padc("RECEITA PARA TINGIMENTO - "+SC2->C2_NUM,80)
  LI := LI + 1
@ LI , 000 PSAY Padc("EMISSAO "+Dtoc(dDataBase),80)
  LI := LI + 3
@ LI , 000 PSAY "PRODUTO : " + aArray[1][1]
  
  //���������������������������������������������������������Ŀ
  //� Imprime descricao do Produto                            �
  //�����������������������������������������������������������
  
  cDescri:=aArray[1][2]
  ImpDescr()
  
  //���������������������������������������������������������Ŀ
  //� Verifica conversao do produto                           �
  //�����������������������������������������������������������
  
  If Empty( SC2->C2_QTSEGUM )
     nConv := IIF( cTipoConv == "M" , (SC2->C2_QUANT - SC2->C2_QUJE) * nFatorConv,  (SC2->C2_QUANT - SC2->C2_QUJE) / nFatorConv )
     Else
	  nConv := SC2->C2_QTSEGUM             // QUANT. 2a UNIDADE DE MED. ATRAVES DA DIGITACAO NA OP
  EndIf
  
  LI := LI + 1
@ Li , 000 PSAY "PESO    : "          
@ Li , 006 PSAY IIF(SC2->C2_UM=="KG",(SC2->C2_QUANT - SC2->C2_QUJE),nConv)   PICTURE PesqPictQt("C2_QUANT",12)
@ Li , 020 PSAY "METRAGEM  : "
_nMetrag := IIF(SC2->C2_UM=="KG",nConv,(SC2->C2_QUANT - SC2->C2_QUJE))
@ Li , 032 PSAY _nMetrag Picture "@E 99999.99"
     
@ Li , 042 PSAY "PARTIDA : " 
@ Li , 052 PSAY SC2->C2_NUM
@ Li , 060 PSAY "ROMANEIO : ________"
  Li := Li + 2
@ Li , 000 PSAY "TURBO N.: ____"
@ Li , 019 PSAY "OPERADOR  : ____________________"
@ Li , 059 PSAY "DATA     : ________"
  Li := Li + 2
@ Li , 000 PSAY "COR     : " + mv_par06
  Li := Li + 2
@ Li , 000 PSAY "OBS.    : " + Subs(cObserv,01,40)
  Li := Li + 1
@ Li , 000 PSAY "          " + Subs(cObserv,41,80)
  Li := Li + 2
@ Li , 000 PSAY "|   | TURBO/JIGGER               |   | SO TURBO               |   | SO JIGGER "
  Li := Li + 2
@ Li , 000 PSAY "+----------+--------+------------------------------------+-----------+--------+"
  Li := Li+1
@ Li , 000 PSAY "|QTD./PORC.| CODIGO | DESCRICAO                          |   TOTAL   | OBS.   |"
  Li:=Li + 1
Return()

/*/
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
��� Fun��o   � Verilim  � Autor � Paulo Boschetti       � Data � 18/07/92 ���
�������������������������������������������������������������������������Ĵ��
��� Descri��o�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Sintaxe  � Verilim()                                                  ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR820                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
/*/

Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function Verilim
Static Function Verilim()

//����������������������������������������������������������������������Ŀ
//� Verifica a possibilidade de impressao da proxima operacao alocada na �
//� mesma folha.                                                                                                                 �
//� 7 linhas por operacao => (total da folha) 66 - 7 = 59                                �
//������������������������������������������������������������������������
IF Li > 59                                              // Li > 55
	Li := 0
	cRotOper(0)                                     // Imprime cabecalho roteiro de operacoes
Endif

Return(Li)

/*/
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
/*/

Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function ImpDescr//(cDescri) static
Static Function ImpDescr//(cDescri) static()

DbSelectArea("SB1")
DbSetOrder(1)

/* tirado de uso em 19/11/2001 por Ricardo 
If DbSeek( xFilial("SB1") + Substr( aArray[1][1], 1, 6 ))
   cDescri := SB1->B1_DESC
EndIf
*/

If DbSeek( xFilial("SB1") + aArray[1][1])
   cDescri := SB1->B1_DESC
EndIf

DbSelectArea("SC2")
_C2RECNO := Recno()
DbSetOrder(1)
DbSeek( xFilial("SC2") + Substr( cOp,1,8) + "001" )

dDtaFin := SC2->C2_DATPRF
DbGoTo(_C2RECNO)

For nBegin := 1 To Len(Alltrim(cDescri)) Step 50
    @li,020 PSAY Substr(cDescri,nBegin,50)
	li:=li+1
Next nBegin

/*/
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
/*/

Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function R820Medidas
Static Function R820Medidas()
aArrayPro   := {}
lImpItem    := .T.
nCntArray   := 0
a01         := ""
a02         := ""
nX          :=0
nI          :=0
nL          :=0
nY          :=0
cNum        :=""
cItem       :=""
lImpCab     := .T.
nBegin      :=0
cProduto    :=""
cDesc       :=""
cDescri     :=""
cDescri1    :=""
cDescri2    :=""


//������������������������������������������������������������Ŀ
//� Imprime Relacao de Medidas do cliente quando OP for gerada �
//� por pedidos de vendas.                                     �
//��������������������������������������������������������������
dbSelectArea("SC5")
dbSetOrder(1)
dbSeek(xFilial()+SC2->C2_NUM)
If Found()
	cNum     := SC2->C2_NUM
	cItem    := SC2->C2_ITEM
	cProduto := SC2->C2_PRODUTO

	//��������������������������������������������������������������Ŀ
	//� Imprimir somente se houver Observacoes.                      �
	//����������������������������������������������������������������
	IF !Empty(SC5->C5_OBSERVA)
		IF li > 53
			@ 03,001 PSAY "HUNTER DOUGLAS DO BRASIL LTDA"
			@ 05,008 PSAY "CONFIRMACAO DE PEDIDOS  -  "+IIF( SC5->C5_VENDA=="01","ASSESSORIA","DISTRIBUICAO")
			@ 05,055 PSAY "No. RMP    : "+SC5->C5_NUM+"-"+SC5->C5_VENDA
			@ 06,055 PSAY "DATA IMPRES: "+DTOC(dDataBase)
			li := 07
		EndIF
		li:=li+1
		@ li,001 PSAY "--------------------------------------------------------------------------------"
		li:=li+1
		cDescri := SC5->C5_OBSERVA
		@ li,001 PSAY " OBSERVACAO: " 
		@ li,018 PSAY SubStr(cDescri,1,60)
		For nBegin := 61 To Len(Trim(cDescri)) Step 60
			li:=li+1
			cDesc:=Substr(cDescri,nBegin,60)
			@ li,018 PSAY cDesc
		Next nBegin
		li:=li+1
		cDescri1 := SC5->C5_OBSERV1
		@ li,018 PSAY SubStr(cDescri1,1,60)
		For nBegin := 61 To Len(Trim(cDescri1)) Step 60
			li:=li+1
			cDesc:=Substr(cDescri1,nBegin,60)
			@ li,018 PSAY cDesc
		Next nBegin
		Li:=Li+1
		cDescri2 := SC5->C5_OBSERV2
		@ li,018 PSAY SubStr(cDescri2,1,60)
		For nBegin := 61 To Len(Trim(cDescri2)) Step 60
			li:=li+1
			cDesc:=Substr(cDescri2,nBegin,60)
			@ li,018 PSAY cDesc
		Next nBegin
		li:=li+1
		@ li,001 PSAY "--------------------------------------------------------------------------------"
		li:=li+1
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
			nCntArray:=nCntArray+1
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
		@ li,009 PSAY aArrayPro[nx]
		Li:=Li+1
		Li:=Li+1
		dbSelectArea("SMX")
		dbSetOrder(2)
		dbSeek( xFilial()+cNum+Subs(aArrayPro[nX],06,15) )
		While !Eof() .And. M6_FILIAL+M6_NRREL+M6_PRODUTO == xFilial()+cNum+Subs(aArrayPro[nX],06,15)
			If li > 58
				R820CabMed()
			EndIF
			IF M6_ITEM == Subs(aArrayPro[nX],1,2)
				@ li,002 PSAY M6_QUANT
				@ li,013 PSAY "PECAS COM"
				@ li,023 PSAY M6_COMPTO
				@ li,035 PSAY M6_OBS
				li:=li+1
			EndIF
			dbSkip()
		End
		li:=li+1
	Next nX
	@ li,001 PSAY "--------------------------------------------------------------------------------"
EndIf
Return(Nil)

/*/
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
/*/

Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function R820CabMed
Static Function R820CabMed()

cCabec1 := SM0->M0_NOME+"               RELACAO DE MEDIDAS             NRO :"
cCabec2 := "MAQUINA                       FERRAMENTA               OPERACAO"

Li := 0

Li:=Li+1
@Li  ,  0 PSAY REPLICATE("*",80)
Li:=Li+1
@Li  ,  0 PSAY cCabec1
@Li  , 69 PSAY SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN
Li:=Li+1
@Li  ,  0 PSAY REPLICATE("*",80)
Li:=Li+1
Li:=Li+1
Return(Nil)


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � Pergunta � Autor � Marcos Gomes          � Data � 01/12/99 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Cria grupo de Perguntas caso nao exista no SX1             ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � PCP - especifico Kenia                                     ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function Pergunta
Static Function Pergunta()
		  
//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                         �
//� mv_par01            // Da OP                                 �
//� mv_par02            // Ate a OP                              �
//� mv_par03            // Da data                               �
//� mv_par04            // Ate a data                            �
//� mv_par05            // Imprime Nome Cientifico               �
//� mv_par06            // Cor do Produto                        �
//� mv_par07            // Pecas                                 �
//� mv_par08            // Pecas                                 �
//� mv_par09            // Tear                                  �
//� mv_par10            // Urdume                                �
//� mv_par11            // Trama                                 �
//� mv_par12            // Lote                                  �
//� mv_par13            // Lote                                  �
//����������������������������������������������������������������

_aPerguntas := {}             
		  // 01     02       03                    04     05  06 7 8  9      10                               11           12        13 14        15        16 17           18     19 20     21        22 23 24 25  26 
AADD(_aPerguntas,{"KENREC","01","Da O.P.               ?","mv_ch1","C",11,0,0,"G","                               ","mv_par01","            ","","","              ","","","             ","","","           ","","","","","SC2",})
AADD(_aPerguntas,{"KENREC","02","Ate a O.P.            ?","mv_ch2","C",11,0,0,"G","                               ","mv_par02","            ","","","              ","","","             ","","","           ","","","","","SC2",})
AADD(_aPerguntas,{"KENREC","03","Da Data               ?","mv_ch3","D",08,0,0,"G","                               ","mv_par03","            ","","","              ","","","             ","","","           ","","","","","   ",})
AADD(_aPerguntas,{"KENREC","04","Ate a Data            ?","mv_ch4","D",08,0,0,"G","                               ","mv_par04","            ","","","              ","","","             ","","","           ","","","","","   ",})
AADD(_aPerguntas,{"KENREC","05","Descricao do Produto  ?","mv_ch5","N",01,0,0,"C","                               ","mv_par05","Descr.Cient.","","","Descr.Generica","","","Pedido Venda ","","","           ","","","","","   ",})
AADD(_aPerguntas,{"KENREC","06","Cor do Produto        ?","mv_ch6","C",20,0,0,"G","                               ","mv_par06","            ","","","              ","","","             ","","","           ","","","","","   ",})
AADD(_aPerguntas,{"KENREC","07","Pecas 1a linha        ?","mv_ch7","C",60,0,0,"G","                               ","mv_par07","            ","","","              ","","","             ","","","           ","","","","","   ",})
AADD(_aPerguntas,{"KENREC","08","Pecas 2a linha        ?","mv_ch8","C",60,0,0,"G","                               ","mv_par08","            ","","","              ","","","             ","","","           ","","","","","   ",})
AADD(_aPerguntas,{"KENREC","09","Tear                  ?","mv_ch9","C",20,0,0,"G","                               ","mv_par09","            ","","","              ","","","             ","","","           ","","","","","   ",})
AADD(_aPerguntas,{"KENREC","10","Urdume                ?","mv_cha","C",20,0,0,"G","                               ","mv_par10","            ","","","              ","","","             ","","","           ","","","","","   ",})
AADD(_aPerguntas,{"KENREC","11","Trama                 ?","mv_chb","C",20,0,0,"G","                               ","mv_par11","            ","","","              ","","","             ","","","           ","","","","","   ",})
AADD(_aPerguntas,{"KENREC","12","Lote                  ?","mv_chc","C",20,0,0,"G","                               ","mv_par12","            ","","","              ","","","             ","","","           ","","","","","   ",})
AADD(_aPerguntas,{"KENREC","13","Lote                  ?","mv_chd","C",20,0,0,"G","                               ","mv_par13","            ","","","              ","","","             ","","","           ","","","","","   ",})

DbSelectArea("SX1")
FOR _nLaco:=1 to LEN(_aPerguntas)
   If !dbSeek(_aPerguntas[_nLaco,1]+_aPerguntas[_nLaco,2])
     RecLock("SX1",.T.)
     SX1->X1_Grupo     := _aPerguntas[_nLaco,01]
     SX1->X1_Ordem     := _aPerguntas[_nLaco,02]
     SX1->X1_Pergunt   := _aPerguntas[_nLaco,03]
     SX1->X1_Variavl   := _aPerguntas[_nLaco,04]
     SX1->X1_Tipo      := _aPerguntas[_nLaco,05]
     SX1->X1_Tamanho   := _aPerguntas[_nLaco,06]
     SX1->X1_Decimal   := _aPerguntas[_nLaco,07]
     SX1->X1_Presel    := _aPerguntas[_nLaco,08]
     SX1->X1_Gsc       := _aPerguntas[_nLaco,09]
     SX1->X1_Valid     := _aPerguntas[_nLaco,10]
     SX1->X1_Var01     := _aPerguntas[_nLaco,11]
     SX1->X1_Def01     := _aPerguntas[_nLaco,12]
     SX1->X1_Cnt01     := _aPerguntas[_nLaco,13]
     SX1->X1_Var02     := _aPerguntas[_nLaco,14]
     SX1->X1_Def02     := _aPerguntas[_nLaco,15]
     SX1->X1_Cnt02     := _aPerguntas[_nLaco,16]
     SX1->X1_Var03     := _aPerguntas[_nLaco,17]
     SX1->X1_Def03     := _aPerguntas[_nLaco,18]
     SX1->X1_Cnt03     := _aPerguntas[_nLaco,19]
     SX1->X1_Var04     := _aPerguntas[_nLaco,20]
     SX1->X1_Def04     := _aPerguntas[_nLaco,21]
     SX1->X1_Cnt04     := _aPerguntas[_nLaco,22]
     SX1->X1_Var05     := _aPerguntas[_nLaco,23]
     SX1->X1_Def05     := _aPerguntas[_nLaco,24]
     SX1->X1_Cnt05     := _aPerguntas[_nLaco,25]
     SX1->X1_F3        := _aPerguntas[_nLaco,26]
     MsUnLock()
   EndIf
NEXT



Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

