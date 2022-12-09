#INCLUDE "Fileio.ch"
#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RFATR11   � Autor � Eduardo Marcolongo � Data �  16.10.09   ���
�������������������������������������������������������������������������͹��
���Solicit.  � Andre/Leonardo                                             ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Shangri-la                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function RFATR11


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������
Local nValida        := ""
Local nLength        := 0
Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Relat�rio de EMails"
Local cPict          := ""
Local titulo         := "Relat�rio de EMails"
Local nLin           := 80
Local Cabec1         := "     Cliente                                      Municipio                     Est       Vend      Rg                 Email"
              *****      123456789012345 12 1234 123456789012345678901234567890 12 1234567890 1234567890 1234567890 1234567890 1234567890 1234567890 1234567890 1234567890 1234567890 1234567890 1234567890 1234567890 1234567890 999,999,999.99 A
              *****      0         1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21        22
              *****      01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
Local Cabec2         := ""
Local imprime        := .T.
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 180 //80
Private tamanho      := "G"
Private nomeprog     := "RFATR11" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cPerg 		 := PadR("RFTR11",Len(SX1->X1_GRUPO))
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "RFATR11" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := "SA1"

dbSelectArea("SA1")
dbSetOrder(1)


//���������������������������������������������������������������������Ŀ
//� Monta a interface padrao com o usuario...                           �
//�����������������������������������������������������������������������
pergunte(cPerg,.F.)
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
���Fun��o    �RUNREPORT � Autor � AP6 IDE            � Data �  20/01/09   ���
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
Local iRegs := 0

dbSelectArea(cString)
dbSetOrder(1)

//���������������������������������������������������������������������Ŀ
//� SETREGUA -> Indica quantos registros serao processados para a regua �
//�����������������������������������������������������������������������

SetRegua(RecCount())

//���������������������������������������������������������������������Ŀ
//� Posicionamento do primeiro registro e loop principal. Pode-se criar �
//� a logica da seguinte maneira: Posiciona-se na filial corrente e pro �
//� cessa enquanto a filial do registro for a filial corrente. Por exem �
//� plo, substitua o dbGoTop() e o While !EOF() abaixo pela sintaxe:    �
//�                                                                     �
//� dbSeek(xFilial())                                                   �
//� While !EOF() .And. xFilial() == A1_FILIAL                           �
//�����������������������������������������������������������������������

IF (nHandle := FCREATE("RFATR11.TXT", FC_NORMAL)) == -1
		MsgInfo("Arquivo n�o pode ser criado")
	BREAK
	ELSE
      FWRITE(nHandle, ("Cliente"+"#"+"Municipio"+"#"+"Estado"+"#"+"Vendedor"+"#"+"Regiao"+"#"+"EMail"+char(13)))
	  FCLOSE(nHandle)
	ENDIF

dbSeek(xFilial("SA1"))
While !EOF()

   //���������������������������������������������������������������������Ŀ
   //� Verifica o cancelamento pelo usuario...                             �
   //�����������������������������������������������������������������������

   //���������������������������������������������������������������������Ŀ
   //� Impressao do cabecalho do relatorio. . .                            �
   //�����������������������������������������������������������������������

   If nLin > 55 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 8
   Endif

   // Coloque aqui a logica da impressao do seu programa...
   // Utilize PSAY para saida na impressora. Por exemplo:
   nValida := "S"
   If A1_FILIAL < mv_par01 .Or. A1_FILIAL > mv_par02
      nValida := "N"
   EndIf
   If A1_EST < mv_par03 .Or. A1_EST > mv_par04
      nValida := "N"
   EndIf
   If A1_VEND < mv_par05 .Or. A1_VEND > mv_par06
      nValida := "N"
   EndIf
   If A1_REGIAO < mv_par07 .Or. A1_REGIAO > mv_par08
      nValida := "N"
   EndIf
   If (TRIM(A1_EMAIL) = "")
      nValida := "N"
   EndIf
   
   If (nValida = "S")    
	   itam :=  tamSX3("A1_NOME")[1]          
	   
	  nHandle := FOPEN("RFATR11.txt", FO_READWRITE + FO_SHARED)
	  IF FERROR() != 0
        MsgInfo("Impossivel abrir o arquivo, Erro : ", FERROR())
	    BREAK
	  ELSE
	  	FSEEK(nHandle, 0, FS_END)
	  	FWRITE(nHandle, (A1_NOME+"#"+A1_MUN+"#"+A1_EST+"#"+A1_VEND+"#"+A1_REGIAO+"#"+A1_EMAIL+char(13)))
		FCLOSE(nHandle)
      ENDIF

	   @nLin,05  PSAY SA1->A1_NOME
	   @nLin,50  PSAY SA1->A1_MUN
	   @nLin,80  PSAY SA1->A1_EST
	   @nLin,90  PSAY SA1->A1_VEND
	   @nLin,100 PSAY SA1->A1_REGIAO
	   @nLin,115 PSAY SA1->A1_EMAIL
	
	   nLin := nLin + 1 // Avanca a linha de impressao
	   iRegs:= iRegs + 1
   EndIf
   
   dbSkip() // Avanca o ponteiro do registro no arquivo
EndDo
                                             
   @nLin,00 PSAY (replicate("_",180))
   @(nLin+1),00 PSAY ("Total de Regs:"+strzero(iregs,5))

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
