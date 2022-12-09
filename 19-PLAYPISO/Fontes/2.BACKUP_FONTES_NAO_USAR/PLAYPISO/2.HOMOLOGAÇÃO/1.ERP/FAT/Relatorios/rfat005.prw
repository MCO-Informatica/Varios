#INCLUDE "rwmake.ch"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RFAT005   � Autor �Alexandre Sousa     � Data �  22/10/10   ���
�������������������������������������������������������������������������͹��
���Descricao �Relatorio de log de alteracao de pedidos de venda.          ���
���          �as alteracoes de data e valores sao captadas.               ���
�������������������������������������������������������������������������͹��
���Uso       �Especifico LISONDA.                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function RFAT005()

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "LOG DE ALTERACAO DE PEDIDOS"
Local cPict          := ""
Local titulo       := "LOG DE ALTERACAO DE PEDIDOS"
Local nLin         := 80

Local Cabec2       := ""
Local imprime      := .T.
Local aOrd := {}
//                              10        20        30        40        50        60        70        80        90
//                     1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
Local Cabec1       := "  Pedido  Item           Valor    Dt.Entrega     Usuario               Dt. Altera��o       Hora "
//                       999999   99     9,999,999.99      99/99/99    999999-xxxxxxxxxxxxxxx     99/99/99     99:99:99
Private a_pos		:= { 3,       12,   19,               37,         49,                        76,          89  }
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite           := 132
Private tamanho          := "M"
Private nomeprog         := "RFAT005" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo            := 15
Private aReturn          := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey        := 0
Private cPerg       := "RFAT005"
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "RFAT005" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := "SZ4"

dbSelectArea("SZ4")
dbSetOrder(2)

ValidPerg()

pergunte(cPerg,.F.)

//���������������������������������������������������������������������Ŀ
//� Monta a interface padrao com o usuario...                           �
//�����������������������������������������������������������������������

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//���������������������������������������������������������������������Ŀ
//� Processamento. RPTSTATUS monta janela com a regua de processamento. �
//�����������������������������������������������������������������������

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    �RUNREPORT � Autor � AP6 IDE            � Data �  22/10/10   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS ���
���          � monta a janela com a regua de processamento.               ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem

dbSelectArea(cString)
dbSetOrder(2)

//���������������������������������������������������������������������Ŀ
//� SETREGUA -> Indica quantos registros serao processados para a regua �
//�����������������������������������������������������������������������
SetRegua(RecCount())


DbSeek(xFilial('SZ4')+alltrim(MV_PAR01))

While !EOF() .and. SZ4->Z4_PEDIDO = alltrim(MV_PAR01)

   //���������������������������������������������������������������������Ŀ
   //� Verifica o cancelamento pelo usuario...                             �
   //�����������������������������������������������������������������������

   If lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif

   //���������������������������������������������������������������������Ŀ
   //� Impressao do cabecalho do relatorio. . .                            �
   //�����������������������������������������������������������������������

   If nLin > 55 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 8
   Endif

//                              10        20        30        40        50        60        70        80        90
//                     1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//Local Cabec1       := "  Pedido  Item           Valor    Dt.Entrega     Usuario               Dt. Altera��o       Hora "
//                       999999   99     9,999,999.99      99/99/99    999999-xxxxxxxxxxxxxxx     99/99/99     99:99:99
   // Coloque aqui a logica da impressao do seu programa...
   // Utilize PSAY para saida na impressora. Por exemplo:
   @nLin,a_pos[01] PSAY SZ4->Z4_PEDIDO
   @nLin,a_pos[02] PSAY SZ4->Z4_ITEM
   @nLin,a_pos[03] PSAY Transform(SZ4->Z4_VALOR, "@E 9,999,999.99")
   @nLin,a_pos[04] PSAY DtoC(SZ4->Z4_ENTREG)
   @nLin,a_pos[05] PSAY SZ4->Z4_CODUSR+'-'+SZ4->Z4_USUARIO
   @nLin,a_pos[06] PSAY DtoC(SZ4->Z4_DATA)
   @nLin,a_pos[07] PSAY SZ4->Z4_HORA
   

   nLin := nLin + 1 // Avanca a linha de impressao

   dbSkip() // Avanca o ponteiro do registro no arquivo
EndDo

//���������������������������������������������������������������������Ŀ
//� Finaliza a execucao do relatorio...                                 �
//�����������������������������������������������������������������������

SET DEVICE TO SCREEN

//���������������������������������������������������������������������Ŀ
//� Se impressao em disco, chama o gerenciador de impressao...          �
//�����������������������������������������������������������������������

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �ValidPerg �Autor  �Cosme da Silva Nunes�Data  �13.11.2007   ���
�������������������������������������������������������������������������͹��
���Uso       �                              							  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ValidPerg()

Local aRegs   := {}

cPerg := PADR(cPerg,10)
//			Grupo 	/Ordem	/Pergunta				/Pergunta Espanhol	/Pergunta Ingles	/Variavel	/Tipo	/Tamanho	/Decimal/Presel	/GSC	/Valid	/Var01		/Def01	/DefSpa1/DefEng1/Cnt01	/Var02	/Def02	/DefSpa2/DefEng2/Cnt02	/Var03	/Def03	/DefSpa3/DefEng3/Cnt03	/Var04	/Def04	/DefSpa4/DefEng4/Cnt04	/Var05	/Def05	/DefSpa5/DefEng5/Cnt05	/F3		/GRPSX6
Aadd(aRegs,{cPerg	,"01"	,"'Pedido ?"			,""					,""					,"mv_ch1"	,"C"	,06			,00		,0		,"G"	,""		,"mv_par01"	,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,"SC5"	,""		})
//Aadd(aRegs,{cPerg	,"02"	,"Numero de Copias ?"	,""					,""					,"mv_ch2"	,"N"	, 2			,00		,2		,"G"	,""		,"mv_par02"	,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		})

LValidPerg( aRegs )

Return