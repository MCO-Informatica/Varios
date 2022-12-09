#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PRCKIT    � Autor � LEANDRO DURAN E RODRIGO KAVABATA        ���
�������������������������������������������������������������������������͹��
���Descricao � PROTOCOLOS DE ENVIO DE DOCUMENTOS TOUTATIS                 ���
�������������������������������������������������������������������������͹��
���Uso       � � Data �  21.12.10                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function PRCKIT
//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������
Local cDesc1         := ""
Local cDesc2         := ""
Local cDesc3         := ""
Local cPict          := ""                                         
Local titulo         := "PRE�O DO KIT"
Local nLin           := 80
Local Cabec1         := "Kit             Componente      descri��o                                          Quantidade  Pre�o de Venda"
Local Cabec2         := ""
Local imprime        := .T.
Local aOrd           := {}

Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 80
Private tamanho      := "M"
Private nomeprog     := "PRCKIT" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cPerg        := "PRCKIT"
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "PRCKIT" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString      := "SE2"
Private cquery     
Private cquebra      := ""
Private cquebraNF    := ""

//ValidPerg()
Pergunte(cPerg,.T.)
//���������������������������������������������������������������������Ŀ
//� Monta a interface padrao com o usuario...                           �
//�����������������������������������������������������������������������
wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)

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
���Fun��o    �RUNREPORT � Autor � AP6 IDE            � Data �  14.11.03   ���
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

PRIVATE _nCONT  :=0
PRIVATE _nVALOR :=0
//���������������������������������������������������������������������Ŀ
//� Query de filtro dos Pedidos que estao com Bloqueio 
//�����������������������������������������������������������������������
cquery := "  select G1_COD, "
cquery += "         G1_COMP, "
cquery += "         G1_QUANT, "
cquery += "         B1_DESC, "
cquery += "         B1_VERVEN "
cquery += "    from SG1020, SB1020 "
cquery += "   where SG1020.D_E_L_E_T_ = '' "
cquery += "     and SB1020.D_E_L_E_T_ = '' "
cquery += "     and G1_COMP = B1_COD "
cquery += "     and G1_COD = '"+MV_PAR01+"' "
cquery += "order by 1 "

MEMOWRIT("RFAT02.SQL", cquery)
TCQUERY cQuery NEW ALIAS "TMP01"

//���������������������������������������������������������������������Ŀ
//� Grava no TRB o rersultado da query acima
//�����������������������������������������������������������������������
dbSelectArea("TMP01")
dbGoTop()
//���������������������������������������������������������������������Ŀ
//� SETREGUA -> Indica quantos registros serao processados para a regua �
//�����������������������������������������������������������������������
SetRegua(RecCount())

While TMP01->(!EOF())
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
   //���������������������������������������������������������������������Ŀ
   //Quebra o Relatorio X Cliente+Loja
   //�����������������������������������������������������������������������                              
   //           1         2         3         4         5         6         7         8         9
   // 0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
   // Kit             Componente      descri��o                                          Quantidade  Pre�o de Venda
   // XXXXXXXXXXXXXXX XXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 999,999.99  999,999,999.99
   @nLin,000 PSAY TMP01->G1_COD
   @nLin,016 PSAY TMP01->G1_COMP
   @nLin,032 PSAY TMP01->B1_DESC
   @nLin,083 PSAY Transform( TMP01->G1_QUANT, "@E 999,999.99" )
   @nLin,095 PSAY Transform( TMP01->B1_VERVEN, "@E 999,999,999.99" )
   nLin := nLin + 1

   _nVALOR := _nVALOR + TMP01->B1_VERVEN
   
   dbSelectArea("TMP01")
   dbSkip() 
EndDo                                  
      
nLin := nLin + 2
@nLin,000 PSAY "____________________________________________________________________________________________________________________________________________________________________________________"
nLin := nLin + 1
@nLin,076 PSAY "VALOR TOTAL DO KIT"
@nLin,095 PSAY Transform( _nVALOR, "@E 999,999,999.99" )
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

DbCloseArea("TMP01")
DbCloseArea("TMP02")

MS_FLUSH()
Return
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    �VALIDPERG � Autor � AP5 IDE            � Data �  06/04/02   ���
�������������������������������������������������������������������������͹��
���Descri��o � Verifica a existencia das perguntas criando-as caso seja   ���
���          � necessario (caso nao existam).                             ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ValidPerg()

Local _sAlias := Alias()
Local aRegs := {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,10)
AAdd(aRegs,{cPerg,"01","Produto De?","Produto De?","Produto De?","mv_ch1","C",15,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AAdd(aRegs,{cPerg,"02","Produto Ate?","Produto Ate?","Produto Ate?","mv_ch2","C",15,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AAdd(aRegs,{cPerg,"03","Data De?","Data De?","Data De?","mv_ch3","D",8,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AAdd(aRegs,{cPerg,"04","Data Ate?","Data Ate?","Data Ate?","mv_ch4","D",8,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","",""})

For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next

dbSelectArea(_sAlias)

Return(NIL)
