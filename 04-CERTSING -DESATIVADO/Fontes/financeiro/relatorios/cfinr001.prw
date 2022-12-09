#INCLUDE "TopConn.ch"
#DEFINE ENTER CHR(13) + CHR(10)
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CFINR001  � Autor � Convergence        � Data �  19/10/08   ���
�������������������������������������������������������������������������͹��
���Descricao � relatorio de titulos nao recebidos Bpag                    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �Especifico para o cliente Certsign                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function CFINR001
//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������
Local cDesc1   := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2   := "de acordo com os parametros informados pelo usuario."
Local cDesc3   := "Titulos Gerados BPAG"
Local cPict    := ""
Local titulo   := "Titulos Gerados BPAG - Com Saldo"
Local nLin     := 80
Local Cabec1   := "Codigo-Loja   Nome do Cliente  Titulo Parc Vencimento  Num Bpag  Num AR  Municipio     Estado     Saldo  Observacao                                          Bandeira   Cartao  Parcela                Autorizacao Operadora     "
//Local Cabec1   := "Codigo-Loja   Nome do Cliente  Titulo Parc Vencimento  Num Bpag  Num AR  Municipio     Estado     Saldo  Observacao                                          Bandeira   Cartao  Parcela  CS    Validade Autorizacao            "
Local Cabec2   := "                               "
//                 XXXXXXXXXXXXXXX  99/99/99  99:99  999999 999999.99-XXXXXXXXXXXXXXXXXXXXXXXX  SIM       XX_XXXXXXX  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
Local imprime  := .T.
Local aOrd 		:= {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 220
Private tamanho      := "G"
Private nomeprog     := "CFINR001"
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cPerg       := "RFIN01"
Private cbtxt      	:= Space(10)
Private cbcont     	:= 00
Private CONTFL     	:= 01
Private m_pag      	:= 01
Private wnrel      	:= "CFATR001"
Private cString		:= "SE1"

//���������������������������������������������������������������������Ŀ
//� Valida a existencia de perguntas e alimenta em memoria	            �
//�����������������������������������������������������������������������
//ValidPerg(cPerg)
Pergunte(cPerg,.F.)

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
���Fun��o    �RUNREPORT � Autor � AP6 IDE            � Data �  11/07/06   ���
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
//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������
Local cArqTmp 		:= ""
Local aEstr			:= {}
Local cInd1			:= CriaTrab(Nil,.F.)
Local cQuery		:= ""
Local cSelect		:= ""
Local cSeleCount	:= ""
Local cQry			:= ""
Local nTotRegs		:= 0
Local lRecLock		:= .T.
Local cVendAnt		:= ""
Local nSaldo		:= 0
Local nLinha		:= 0

//���������������������������������������������������������������������Ŀ
//�Monta clausulas da query a serem utilizadas no relatorio             �
//�����������������������������������������������������������������������

cSelect := "Select A1_MUN,A1_EST,SE1.* "+ENTER
cSelect += "From "+RetSqlName("SE1")+" SE1 ,"+RetSqlName("SA1")+" SA1" + ENTER
cSelect += "Where SE1.D_E_L_E_T_ = ' ' And"+ENTER
cSelect += "	   E1_CLIENTE  >= '"+     mv_par01   +"' And E1_CLIENTE    <= '"+     mv_par02 +"' And "+ENTER
cSelect += "	   E1_VENCTO  >= '"+     dtos(mv_par03)   +"' And E1_VENCTO    <= '"+     dtos(mv_par04) +"' And "+ENTER
cSelect += "	   E1_EMISSAO >= '"+     dtos(mv_par05)   +"' And E1_EMISSAO   <= '"+     dtos(mv_par06) +"' And "+ENTER
cSelect += "	   E1_CLIENTE = A1_COD And E1_LOJA = A1_LOJA and E1_SALDO > 0" +ENTER
cSelect += "Order By E1_PREFIXO, E1_NUM"+ENTER

//���������������������������������������������������������������������Ŀ
//�Executa query para selecao dos registros a serem processados no rel. �
//�����������������������������������������������������������������������
cQry := cSelect
If Select("TMPQ") > 0
	dbSelectArea("TMPQ")
	dbCloseArea()
EndIf
MemoWrite("CFINR001A.sql",cQry)

TcQuery cQry New Alias "TMPQ"

TCSetField('TMPQ','E1_VENCTO','D')

//���������������������������������������������������������������������Ŀ
//� SETREGUA -> Indica quantos registros serao processados para a regua �
//�����������������������������������������������������������������������
SetRegua(RecCount())

//������������������������������������������������������������������������������Ŀ
//� Loop no arquivo de trabalho para impressao dos registros                  	|
//��������������������������������������������������������������������������������
DbSelectArea('TMPQ')
DbGoTop()
Do While !TMPQ->(EOF())
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
		nLin := 9
	Endif
	
	IF !EMPTY(Posicione('SC5',1,xFilial('SC5')+TMPQ->E1_PEDIDO,'C5_CHVBPAG') )
	
	//���������������������������������������������������������������������Ŀ
	//� Imprime detalhes do relatorio                                       �
	//�����������������������������������������������������������������������
	@nLin,001 pSay TMPQ->E1_CLIENTE +"-"+ TMPQ-> E1_LOJA //	C�digo/Loja do Cliente
	@nLin,012 pSay Substr(TMPQ->E1_NOMCLI,1,15)   // Nome do Cliente
	@nLin,030 pSay TMPQ->E1_NUM     // Numero do Titulo
	@nLin,039 pSay TMPQ->E1_PARCELA  // Parcela do Titulo
	@nLin,043 pSay TMPQ->E1_VENCTO   // Vencimento do Titulo
	@nLin,055 pSay Posicione('SC5',1,xFilial('SC5')+TMPQ->E1_PEDIDO,'C5_CHVBPAG')  // numero do Bpag
	@nLin,065 pSay Posicione('SC5',1,xFilial('SC5')+TMPQ->E1_PEDIDO,'C5_AR')  //  AR
	@nLin,073 psay substr(TMPQ->A1_MUN,1,12)   // Cidade do cliente
	@nLin,087 psay TMPQ->A1_EST  // UF do cliente
	@nLin,095 psay TMPQ->E1_SALDO   Picture ("@E 9,999.99")// UF do cliente
	@nLin,105 psay substr(Posicione('SC5',1,xFilial('SC5')+TMPQ->E1_PEDIDO,'C5_MENNOTA'),1,50)  // MENSAGEM DA NOTA
	@nLin,157 psay substr(Posicione('SC5',1,xFilial('SC5')+TMPQ->E1_PEDIDO,'C5_XBANDEI'),1,10)  
	@nLin,168 psay Right(Alltrim(Posicione('SC5',1,xFilial('SC5')+TMPQ->E1_PEDIDO,'C5_XCARTAO')),4)  	
	@nLin,176 psay Posicione('SC5',1,xFilial('SC5')+TMPQ->E1_PEDIDO,'C5_XPARCEL')
	//@nLin,185 psay Posicione('SC5',1,xFilial('SC5')+TMPQ->E1_PEDIDO,'C5_XCODSEG') 	
	//@nLin,191 psay Posicione('SC5',1,xFilial('SC5')+TMPQ->E1_PEDIDO,'C5_XVALIDA') 		
	@nLin,199 psay Posicione('SC5',1,xFilial('SC5')+TMPQ->E1_PEDIDO,'C5_XCODAUT')  				
	
	// Caso seja apenas exclus�o
	
	nSaldo:= nSaldo + TMPQ->E1_SALDO
	nLin++
	
	//���������������������������������������������������������������������Ŀ
	//�Totaliza valores por vendedor                                        �
	//�����������������������������������������������������������������������
	ENDIF
	TMPQ->(dbSkip())
	
	IF TMPQ->(EOF())
		nLin := nLin + 2
		@nLin,000 psay Replicate("-",200)
		nLin++
		@nLin,001 psay "TOTAL  - "
		@nLin,092 psay nSaldo picture("@E 9,999,999.99")
	Endif
EndDo

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
���Fun��o    �VALIDPERG � Autor �                    � Data �  11/07/06   ���
�������������������������������������������������������������������������͹��
���Descri��o � Verifica a existencia das perguntas criando-as caso seja   ���
���          � necessario                                                 ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ValidPerg(cPerg)
//�������������������������Ŀ
//� Definicoes de variaveis �
//���������������������������
Local aArea   := GetArea()
Local aRegs   := {}
aAdd(aRegs,{cPerg,"01","cliente  de             	 ?     ","","","mv_ch1","C",06,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","cliente  at�        	     ?     ","","","mv_ch2","C",06,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","vencimento de            	 ?     ","","","mv_ch3","D",08,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"04","vencimento at�           	 ?     ","","","mv_ch4","D",08,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"05","faturamento de            	 ?     ","","","mv_ch5","D",08,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"06","faturamento at�           	 ?     ","","","mv_ch6","D",08,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","",""})


//��������������������������������������������Ŀ
//�Atualizacao do SX1 com os parametros criados�
//����������������������������������������������
DbSelectArea("SX1")
DbSetorder(1)
For nX:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[nX,2])
		RecLock("SX1",.T.)
		For nY:=1 to FCount()
			If nY <= Len(aRegs[nX])
				FieldPut(nY,aRegs[nX,nY])
			EndIf
		Next
		SX1->(MsUnlock())
	EndIf
Next
//�������������������������Ŀ
//�Retorna ambiente original�
//���������������������������
RestArea(aArea)
Return(Nil)
