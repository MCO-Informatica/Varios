#INCLUDE "TopConn.ch"
#DEFINE ENTER CHR(13) + CHR(10)
/*/
����������������������������������������������������������������������������
����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ�
���Programa  �CFINR002  � Autor � Rene Lopes	     � Data �  14/07/10   ��
�������������������������������������������������������������������������͹�
���Descricao � Relat�rio de titulo em aberto pagamento com cart�o de      ��
���          � cr�dito                                                    ��
�������������������������������������������������������������������������͹�
���Uso       �											                  ��
�������������������������������������������������������������������������ͼ�
����������������������������������������������������������������������������
����������������������������������������������������������������������������
/*/
User Function CFINR002
//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������
Local cDesc1   := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2   := "de acordo com os parametros informados pelo usuario."
Local cDesc3   := "Titulos Gerados BPAG Cart�o de Credito - Com Saldo"
Local cPict    := ""
Local titulo   := "Titulos Gerados BPAG Cart�o de Credito- Com Saldo"
Local nLin     := 80
Local Cabec1   := " Codigo      Nome do Cliente  Titulo   Parc Vencimento Prefixo   Pedido   Saldo    Observacao                                                             Bandeira    Cartao         Parcela   Dt_Emissao_Ped     "
Local Cabec2   := "                               "
Local imprime  := .T.
Local aOrd 		:= {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
//Private CbTxt        := ""
Private limite       := 220
Private tamanho      := "G"
Private nomeprog     := "CFINR002"
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cPerg       := "RFIN01"
//Private cbtxt      	:= Space(10)
Private cbcont     	:= 00
Private CONTFL     	:= 01
Private m_pag      	:= 01
Private wnrel      	:= "CFATR002"
Private cString		:= "SE1"

//���������������������������������������������������������������������Ŀ
//� Valida a existencia de perguntas e alimenta em memoria	            �
//�����������������������������������������������������������������������
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
//Local cArqTmp 		:= ""
//Local aEstr			:= {}
//Local cInd1			:= CriaTrab(Nil,.F.)
//Local cQuery		:= ""
Local cSelect		:= ""
//Local cSeleCount	:= ""
Local cQry			:= ""
//Local nTotRegs		:= 0
//Local lRecLock		:= .T.
//Local cVendAnt		:= ""
Local nSaldo		:= 0
//Local nLinha		:= 0 
//Local cCliDe		:= MV_PAR01
//Local cCliAte		:= MV_PAR02

//���������������������������������������������������������������������Ŀ
//�Monta clausulas da query a serem utilizadas no relatorio             �
//�����������������������������������������������������������������������
 

cSelect :=  "Select A1_MUN,A1_EST,C5_XBANDEI,SE1.*,SC5.*"+ENTER
cSelect	+=  "From "+RetSQLName("SE1")+" SE1, "+RetSQLNAME("SA1")+" SA1, "+RetSQLNAME("SC5")+" SC5 "+ENTER
cSelect +=  "Where SE1.D_E_L_E_T_ = ' ' And "+ENTER
cSelect +=  "SC5.D_E_L_E_T_ = ' ' AND "+ENTER
cSelect +=  "E1_CLIENTE  >= '"+     mv_par01   +"' And E1_CLIENTE    <= '"+     mv_par02 +"' And "+ENTER
cSelect +=  "E1_VENCTO  >= '"+     dtos(mv_par03)   +"' And E1_VENCTO    <= '"+     dtos(mv_par04) +"' And "+ENTER
cSelect +=	"E1_EMISSAO >= '"+     dtos(mv_par05)   +"' And E1_EMISSAO   <= '"+     dtos(mv_par06) +"' And "+ENTER
cSelect +=  "E1_CLIENTE = A1_COD And E1_LOJA = A1_LOJA and E1_SALDO > 0 "+ENTER
cSelect +=	"AND C5_NUM = E1_PEDIDO AND C5_XBANDEI <> '' "+ENTER
cSelect +=  "Order By E1_PREFIXO, E1_NUM "+ENTER              

//���������������������������������������������������������������������Ŀ
//�Executa query para selecao dos registros a serem processados no rel. �
//�����������������������������������������������������������������������
cQry := cSelect
If Select("TMPQ") > 0
	dbSelectArea("TMPQ")
	dbCloseArea()
EndIf

TcQuery cQry New Alias "TMPQ"


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
	
	//���������������������������������������������������������������������Ŀ
	//� Imprime detalhes do relatorio                                       �
	//�����������������������������������������������������������������������
	@nLin,001 pSay TMPQ->E1_CLIENTE //+"-"+ TMPQ-> E1_LOJA	USER: CIDE, N�O DESEJA O CAMPO LOJA //	C�digo/Loja do Cliente
	@nLin,014 pSay Substr(TMPQ->E1_NOMCLI,1,15)   				     // Nome do Cliente
	@nLin,031 pSay TMPQ->E1_NUM  								    // Numero do Titulo
	@nLin,041 pSay TMPQ->E1_PARCELA								   // Parcela do Titulo
	@nLin,045 pSay TMPQ->E1_VENCTO    // Vencimento do Titulo
	@nLin,055 pSay TMPQ->E1_PREFIXO 								  // Vencimento do Titulo
	@nLin,065 pSay TMPQ->C5_CHVBPAG  							 // numero do Bpag
	//@nLin,065 pSay TMPQ->C5_AR 		   						    //  AR
	//@nLin,073 psay substr(TMPQ->A1_MUN,1,12)  				   // Cidade do cliente
	//@nLin,087 psay TMPQ->A1_EST  							  // UF do cliente
	@nLin,073 psay TMPQ->E1_SALDO   Picture ("@E 9,999.99") // UF do cliente
	@nLin,085 psay Substr(TMPQ->C5_MENNOTA,1,70)           //MENSAGEM DA NOTA
	@nLin,157 psay TMPQ->C5_XBANDEI			              //BANDEIRA DO CARTAO 
	@nLin,168 psay Substr(TMPQ->C5_XCARTAO,1,6)+"***"+ Right(TMPQ->C5_XCARTAO,4)    //4ULTIMOS DIGITOS DO CARTAO 	
	@nLin,185 psay TMPQ->C5_XPARCEL                     
   	@nLin,195 psay TMPQ->C5_EMISSAO  
			
	// Caso seja apenas exclus�o
	
	nSaldo:= nSaldo + TMPQ->E1_SALDO
	nLin++
	
	//���������������������������������������������������������������������Ŀ
	//�Totaliza valores por vendedor                                        �
	//�����������������������������������������������������������������������
	TMPQ->(dbSkip())
	EndDo
	
		nLin := nLin + 2
		@nLin,000 psay Replicate("-",200)
		nLin++
		@nLin,001 psay "TOTAL  - "
		@nLin,092 psay nSaldo picture("@E 9,999,999.99")
	

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
�������������������������������������?������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
/*
Static Function ValidPerg(cPerg)
//�������������������������Ŀ
//� Definicoes de variaveis �
//���������������������������
Local aArea   := GetArea()
Local aRegs   := {}
Local nY
Local nX

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
*/