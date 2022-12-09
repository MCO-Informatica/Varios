#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05
#INCLUDE "topconn.ch"
#IFNDEF WINDOWS
	#DEFINE PSAY SAY
#ENDIF

User Function Knotdeb()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP6 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("NORDEM,TAM,LIMITE,TITULO,CDESC1,CDESC2")
SetPrvt("CDESC3,CNATUREZA,CSTRING,LCONTINUA,ARETURN,NOMEPROG")
SetPrvt("NLASTKEY,CPERG,WNREL,NTOTJUR,NVALJUR,_CNUMDEB")
SetPrvt("CNOMECLI,CENDCLI,CBAIRRO,CCEP,CMUNCLI,CESTCLI")
SetPrvt("CCGCCLI,CINSCCLI,CCOBCLI,CCEPCOB,CBAIRROCOB,CMUNCOB")
SetPrvt("CESTCOB,NLIN,CTIPOTIT,CNUMNF,CTIPO,NVALDUP")
SetPrvt("CPARCELA,DVENCTO,DPAGTO,NLININI,NOPC,CCOR")
SetPrvt("_APERGUNTAS,_NLACO,")

// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 12/02/05 ==> #INCLUDE "topconn.ch"

#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 12/02/05 ==> 	#DEFINE PSAY SAY
#ENDIF

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � DUPLI    � Autor � Alexandre Miguel      � Data � 05/12/00 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Nota de Debito                                             ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Exclusivo para Clientes Microsiga,                         ���
���          � Alterado para o Cliente Kenia Textil                       ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

//��������������������������������������������������������������Ŀ
//� Define Variaveis                                             �
//����������������������������������������������������������������
//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                         �
//� mv_cli_de            // Cliente de                           �
//� mv_cli_ate           // Cliente Ate                          �
//� mv_dtpagam           // Pagamento de                         �
//� mv_dtpagam           // Pagamento Ate                        �
//����������������������������������������������������������������
nOrdem     := 0
tam        := "P"
limite     := 80
titulo     := PADC("NOTA DE DEBITO",71)
cDesc1     := PADC("Este programa ira emitir Notas de Debito. ",71)
cDesc2     := ""
cDesc3     := ""
cNatureza  := ""
cString    := "SE1"
lContinua  :=  .T.
aReturn    :=  { "Especial", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog   := "KNOTDEB"
nLastKey   :=  0
cPerg      := "NTDEB1"
wnrel      := "NDEB"
nTotJur    := 0
nValJur    := 0
			   
//��������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas.                          �
//����������������������������������������������������������������
perguntas()
pergunte(cPerg,.F.)

//��������������������������������������������������������������Ŀ
//� Envia controle para a funcao SETPRINT                        �
//����������������������������������������������������������������

wnrel:=SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.F.,,.F.,tam)

#IFNDEF WINDOWS
	If LastKey() == 27 .or. nLastKey == 27
		__RetProc()
	Endif
#ENDIF

SetDefault(aReturn,cString)

//��������������������������������������������������������������Ŀ
//� Verifica Posicao do Formulario na Impressora                 �
//����������������������������������������������������������������
VerImp()

#IFNDEF WINDOWS
	If LastKey() == 27 .OR. nLastKey == 27
		__RetProc()
	Endif
#ENDIF

#IFDEF WINDOWS
	RptStatus({|| Duplicata()})// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> 	RptStatus({|| Execute(Duplicata)})
	__RetProc()
// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> 	Function Duplicata
Static Function Duplicata()
#ENDIF

//��������������������������������������������������������������Ŀ
//� Inicio do Processamento da Nota de Debito                    �
//����������������������������������������������������������������

dbSelectArea("SE1")                // * Contas a Receber
dbSetOrder(2)
dbSeek(xFilial("SE1")+mv_par01+mv_par02,.T.)

SetRegua(LastRec())

While !Eof() .and. SE1->E1_FILIAL  == xFilial("SE1");
	     .and. SE1->E1_CLIENTE+SE1->E1_LOJA == mv_par01+mv_par02
											   
	#IFNDEF WINDOWS
		IF LastKey()==286
			@ 00,01 PSAY "** CANCELADO PELO OPERADOR **"
			lContinua := .F.
			Exit
		Endif
	#ELSE
		IF lAbortPrint
			@ 00,01 PSAY "** CANCELADO PELO OPERADOR **"
			lContinua := .F.
			Exit
		Endif
	#ENDIF
	
	//�������������������������������������Ŀ
	//� Verifica o tipo de titulo           �
	//���������������������������������������

While !EoF() .and. SE1->E1_PREFIXO=="UNI" .OR. SE1->E1_PREFIXO=="   "
	If  SE1->E1_TIPO == "NDC"
		dbSkip()
		Loop
	Endif
Enddo
	 _cNumDeb := GetSx8Num("NDB")
	 confirmSx8()

	 @ 000, 000 PSAY Chr(18)
	 @ 002, 065 PSAY Dtoc(dDataBase)    // Data de Emissao
	 @ 011, 005 PSAY _cNumDeb           // Numero Seq da Nota de Debito
	 @ 011, 035 PSAY _cNumDeb
	 @ 011, 048 PSAY Dtoc(dDataBase+20) // Data de Vencto N Debito
	  
	dbSelectArea("SA1")                 // * Cadastro de Clientes
	dbSetOrder(1)
	dbSeek(xFilial("SA1")+mv_par01+mv_par02,.T.)

	cNomeCli   := SA1->A1_NOME               // Nome do Cliente
	cEndCli    := SA1->A1_END                // Endereco do Cliente
	cBairro    := SA1->A1_BAIRRO             // Bairro
	cCEP       := SA1->A1_CEP                // CEP do Cliente
	cMunCli    := SA1->A1_MUN                // Municipio do Cliente
	cEstCli    := SA1->A1_EST                // Estado do Cliente
	cCGCCli    := SA1->A1_CGC                // CGC do Cliente
	cInscCli   := SA1->A1_INSCR              // Inscricao estadual do Cliente
	cCobCli    := SA1->A1_ENDCOB             // Endereco de Cobranca do Cliente
	cCepCob    := SA1->A1_CEPC               // Cep de Cobranca
	cBairroCob := SA1->A1_BAIRROC            // Bairro de cobranca
	cMunCob    := SA1->A1_MUNC               // Municipio de cobranca
	cEstCob    := SA1->A1_ESTC               // Estado de cobranca
 
	//�������������������������������������Ŀ
	//� Impressao dos Dados do Cliente      �
	//���������������������������������������
	
	  
	  @ 015, 009 PSAY cNomeCli
	  @ 016, 009 PSAY cEndCli
	  @ 016, 039 PSAY cBairro
	  @ 017, 009 PSAY cMunCli
	  @ 017, 041 PSAY cEstCli
	  @ 017, 060 PSAY TRANSFORM(cCEP,"@R 99999-999")
	  @ 018, 009 PSAY cMunCli
	  @ 019, 009 PSAY cCGCCli     PICTURE "@R 99.999.999/9999-99"
	  @ 019, 041 PSAY cInscCli // PICTURE "@R 999.999.999.999"
	  @ 021, 009 PSAY cCobCli  
	  @ 021, 039 PSAY cBairroCob
	  @ 022, 009 PSAY cMunCob 
	  @ 022, 039 PSAY cEstCob 
	  @ 022, 060 PSAY TRANSFORM(cCepCob,"@R 99999-999")
	
	//��������������������������������������������������������������Ŀ
	//�  Levantamento dos Dados da Nota de Debito                    �
	//����������������������������������������������������������������
	   nLin := 32 

	   dbSelectArea("SE1")
	   cTipoTit := SE1->E1_TIPO
	   
	   While SE1->E1_TIPO == cTipoTit 
	
		   cNumNF     :=SE1->E1_NUM             // Numero da Titulo          
		   cTipo      :=SE1->E1_TIPO            // Tipo do Titulo      
		   nValDup    :=SE1->E1_VALOR           // Valor do Titulo   
		   cParcela   :=SE1->E1_PARCELA         // Numero da Parcela
		   dVencto    :=SE1->E1_VENCTO          // Vencimento da Parcela  
		   dPagto     :=SE1->E1_BAIXA           // Data de Pagamento        
  
	   //��������������������������������������������������������������Ŀ
	   //�                IMPRESSAO DOS TITULOS                         �
	   //����������������������������������������������������������������
		   @ nLin, 010 PSAY cNumNF  
		   @ nLin, 016 PSAY cTipo   
		   @ nLin, 025 PSAY nValDup  PICTURE "@E 999,999,999.99"
		   @ nLin, 036 PSAY DTOC(dVencto)
		   @ nLin, 048 PSAY DTOC(dPagto) 
		 
		   DbSkip()
		   nLin := nLin + 1
	   
	   EndDo
	   
	   @ 36, 000 PSAY ""
	   SETPRC (0,0)
	  
	//��������������������������������������������������������������Ŀ
	//� Avan�o da R�gua de Processamento                             �
	//����������������������������������������������������������������
	
		IncRegua()

	//������������������������������������������������Ŀ
	//� Termino da Impressao da Duplicata              �
	//��������������������������������������������������
  
	  Exit
   
Enddo

	//������������������������������������������������������������Ŀ
	//� Fechamento do Programa da Duplicata                        �
	//��������������������������������������������������������������

dbSelectArea("SE1")
dbSetOrder(1)

Set Device To Screen

dbCommitAll()

If aReturn[5] == 1
	Set Printer TO
	ourspool(wnrel)
Endif

MS_FLUSH()

__RetProc()


/*/

�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � VERIMP   � Autor � Luiz Carlos Vieira    � Data � 30/09/96 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Verifica posicionamento de papel na Impressora             ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Lincoln                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function VerImp
Static Function VerImp()

nLin:= 0                // Contador de Linhas
nLinIni:=0
If aReturn[5]==2
	
	nOpc       := 1
	#IFNDEF WINDOWS
		cCor       := "B/BG"
	#ENDIF
	
	While .T.
		
		SetPrc(0,0)
		dbCommitAll()
		
		@ nLin ,000 PSAY " "
		@ nLin ,003 PSAY "*"
		
		#IFNDEF WINDOWS
			Set Device to Screen
			DrawAdvWindow(" Formulario ",10,25,14,56)
			SetColor(cCor)
			@ 12,27 PSAY "Formulario esta posicionado?"
			nOpc:=Menuh({"Sim","Nao","Cancela Impressao"},14,26,"b/w,w+/n,r/w","SNC","",1)
			Set Device To Print
		#ELSE
			IF MsgYesNo("Fomulario esta posicionado ? ")
				nOpc := 1
			ElseIF MsgYesNo("Tenta Novamente ? ")
				nOpc := 2
			Else
				nOpc := 3
			Endif
		#ENDIF
		Do Case
			Case nOpc==1
				lContinua:=.T.
				Exit
			Case nOpc==2
				Loop
			Case nOpc==3
				lContinua:=.F.
				__RetProc()
		EndCase
	End
Endif

__RetProc()

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

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function Pergunta
Static Function Pergunta()
		  
//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                         �
//� mv_cli_de            // Cliente de                           �
//� mv_cli_ate           // Cliente Ate                          �
//� mv_dtpagam           // Pagamento  de                        �
//� mv_dtpagam           // Pagamento  ate                       �
//����������������������������������������������������������������
_aPerguntas := {}             
		  // 01     02       03                  04     05  06 7 8  9      10                               11           12        13 14        15        16 17    18     19 20     21        22 23 24 25  26 
AADD(_aPerguntas,{"NTDEB1","01","Cliente de         ?","mv_ch1","C",06,0,0,"G","                               ","mv_par01","            ","","","              ","","","       ","","","           ","","","","","SA1",})
AADD(_aPerguntas,{"NTDEB1","02","Cliente Ate        ?","mv_ch2","C",06,0,0,"G","                               ","mv_par02","            ","","","              ","","","       ","","","           ","","","","","SA1",})
AADD(_aPerguntas,{"NTDEB1","03","Dt Pagamento de    ?","mv_ch3","D",08,0,0,"G","                               ","mv_par03","            ","","","              ","","","       ","","","           ","","","","","   ",})
AADD(_aPerguntas,{"NTDEB1","04","Dt Pagamento Ate   ?","mv_ch4","D",08,0,0,"G","                               ","mv_par04","            ","","","              ","","","       ","","","           ","","","","","   ",})

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
	 SX1->X1_F3        := _aPerguntas[_nLaco,26]
	 MsUnLock()
   EndIf
NEXT
__RetProc()




Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

