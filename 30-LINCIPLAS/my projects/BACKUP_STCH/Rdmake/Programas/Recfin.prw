#include "protheus.ch"        // incluido pelo assistente de conversao do AP5 IDE em 04/05/02

User Function Recfin()        // incluido pelo assistente de conversao do AP5 IDE em 04/05/02


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � RECIBO   � Autor � Rodrigo Demetrios     � Data � 03.11.06 ���
�������������������������������������������������������������������������Ĵ��
���Revisao   � Protheus �       �                       � Data � 03.11.06 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Emissao de Recibos                                         ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Financeiro                                                 ���
�������������������������������������������������������������������������Ĵ��
���Arquivos  � SE1 - Contas a Receber       � SA2 - Fornecedor            ���
���Utilizados� SA1 - Cliente                � SE2 - Contas a Pagar        ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
//��������������������������������������������������������������Ŀ
//� Define Variaveis                                             �
//����������������������������������������������������������������

cDesc1       := "Este Programa Tem Como Objetivo Imprimir Relat�rio "
cDesc2       := "De Acordo Com os Parametros Informados Pelo Usuario."
cDesc3       := "Recibo de Pagamento"
cPict        := ""
titulo       := "Recibo de Pagamento"
nLin         := 80
imprime      := .T.
lEnd         := .F.
lAbortPrint  := .F.
CbTxt        := ""
limite       := 80
tamanho      := "M"
nomeprog     := "RECFIN" 
nTipo        := 15
aReturn      := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
nLastKey     := 0
_cPerg       := "RECFIN"
cbtxt        := Space(10)
cbcont       := 00
CONTFL       := 01
m_pag        := 01
wnrel        := "RECFIN" 
cString      := "SE5"
_nTotNcc     := 0
_nTotal      := 0
nOrdem       := 1
CABEC1       := ""
CABEC2       := ""


pergunte("RECFIN",.F.)

wnrel := SetPrint(cString,NomeProg,_cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

RptStatus({|| RunReport()},Titulo)// Substituido pelo assistente de conversao do AP5 IDE em 04/05/02 ==> RptStatus({|| Execute(RunReport)},cTitulo)

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    �RUNREPORT � Autor � Andre Elias        � Data �  17/09/01   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS ���
���          � monta a janela com a regua de processamento.               ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function RunReport()

IF mv_par03 == 1
	
ELSE
	
	
	
	dbSelectArea("SE5")
	cFilTrab   := CriaTrab("",.F.)
	cCondicao  := "E5_FILIAL=='"+xFilial("SE5")+"'.And."
	cCondicao  += "E5_NUMCHEQ>='"+MV_PAR01+"'.And.E5_NUMCHEQ<='"+MV_PAR02+"' .AND. (E5_TIPODOC $ 'VL/BA/  ') "
	IndRegua("SE5",cFilTrab,"E5_FILIAL+E5_NUMCHEQ",,cCondicao,"Filtrando")    // "Selecionando Registros..."
	DbGoTop()
	SetRegua(RecCount())
	While !Eof()
		IncRegua()
		
		
		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif
		
		If nLin > 55
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 10
		Endif
		
		
		dbSelectArea("SE2")           // Arq. de Contas a Receber
		dbsetorder(1)
		dbSeek(xFilial()+SE5->E5_PREFIXO + SE5->E5_NUMERO + SE5->E5_PARCELA + SE5->E5_TIPO  + SE5->E5_FORNECE  + SE5->E5_LOJA)
		
		nLin := nLin + 3
		@ nLin, 022 Psay "R E C I B O     D E     P A G A M E N T O"
		nLin := nLin + 8
		@ nLin, 010 Psay "RECIBO N.:   " +SE5->E5_PREFIXO + " - " + SE5->E5_NUMERO + " - " + SE5->E5_PARCELA
		nLin := nLin + 3
		@ nLin, 010 Psay "VALOR R$:    " + AllTrim(TRANSFORM(SE5->E5_VALOR,"@E 99,999,999.99"))
		nLin := nLin + 3
		nLin := nLin + 3
		@ nLin, 010 Psay "RECEBEMOS DA LINCIPLAS IND. E COM. LTDA, A IMPORTANCIA SUPRA DE"
		nLin := nLin + 2
		_cExtenso := Extenso(SE5->E5_VALOR,.F.,1)
		_cExtenso :=_cExtenso+" "+Replicate("*",79-len(_cExtenso))
		_aExtenso := {}
		AADD(_aExtenso,substr(_cExtenso,1,79))
		AADD(_aExtenso,substr(_cExtenso,80,160))
		@ nLin, 010 Psay AllTrim(TRANSFORM(SE5->E5_VALOR,"@E 99,999,999.99"))+" (" + _aExtenso[1]
		nLin := nLin + 2
		@ nLin, 010 Psay _aExtenso[2]+")"
		nLin := nLin + 2
		@ nLin, 010 Psay "ATRAVES DO CHEQUE: " + SE5->E5_NUMCHEQ + "BANCO: " + SE5->E5_BANCO + " AGENCIA: " + SE5->E5_AGENCIA +" CONTA: "  + SE5->E5_CONTA
		nLin := nLin + 2
		@ nLin, 010 Psay "REFERENTE A  " + SE2->E2_HIST
		
		nLin := nLin + 6
		@ nLin, 010 Psay "GUARULHOS, "+StrZero(Day(DDATABASE),2)+" DE "
		MesExt()
		@ nLin, 040 Psay " DE " + StrZero(Year(DDATABASE),4)
		nLin := nLin + 9
		@ nLin, 008 Psay "            ______________________________         "
		nLin := nLin + 2
		@ nLin, 020 Psay "FORNECEDOR: " + SE5->E5_FORNECE + " - " + SE5->E5_LOJA +   "  -->  " + SE5->E5_BENEF
		nLin := nLin + 21
		
		dbSelectArea("SE5")
		dbSkip()
	EndDo
ENDIF
dbSelectArea("SE5")
RETINDEX()

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
�������������������������������������������������������������������������Ŀ��
���Fun��o    �  MesExt  � Autor � Andre Elias           � Data � 16.08.96 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Imprimir mes por extenso                                   ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   �  MesExt()                                                  ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � RecFin                                                     ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
// Substituido pelo assistente de conversao do AP5 IDE em 04/05/02 ==> Function MesExt
Static Function MesExt()
IF mv_par03 == 1
	_nMes := Month(DDATABASE)
ELSE
	_nMes := Month(DDATABASE)
ENDIF
_aMes := {}
AADD(_aMes,"JANEIRO")
AADD(_aMes,"FEVEREIRO")
AADD(_aMes,"MARCO")
AADD(_aMes,"ABRIL")
AADD(_aMes,"MAIO")
AADD(_aMes,"JUNHO")
AADD(_aMes,"JULHO")
AADD(_aMes,"AGOSTO")
AADD(_aMes,"SETEMBRO")
AADD(_aMes,"OUTUBRO")
AADD(_aMes,"NOVEMBRO")
AADD(_aMes,"DEZEMBRO")
@ nLin, 028 Psay UPPER(_aMes[_nMes])
Return

