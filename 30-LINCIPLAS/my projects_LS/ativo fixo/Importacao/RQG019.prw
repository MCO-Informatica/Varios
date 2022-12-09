#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � RQG019   � Autor � Ricado Felipelli   � Data �  31/08/09   ���
�������������������������������������������������������������������������͹��
���Descricao � Gera lancamentos contabeis CT2 a partir dos dados migrados ���
���          � do ativo (socin ) SN1                                      ���
�������������������������������������������������������������������������͹��
���Uso       � AP8 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function RQG019


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������
Private cPerg   := Padr("CT2",len(SX1->X1_GRUPO)," ")
Private oLeTxt

Private cString := "SN1"

dbSelectArea("SN1")
dbSetOrder(1)

//���������������������������������������������������������������������Ŀ
//� Montagem da tela de processamento.                                  �
//�����������������������������������������������������������������������

@ 200,1 TO 380,380 DIALOG oLeTxt TITLE OemToAnsi("Criacao de CT2")
@ 02,10 TO 080,190
@ 10,018 Say " Este programa ira gerar lancamentos contabeis CT2, "
@ 18,018 Say " a partir dos dos migrados do socin SN1"
@ 26,018 Say " SN1 -> CT2"

@ 70,128 BMPBUTTON TYPE 01 ACTION OkLeTxt()
@ 70,158 BMPBUTTON TYPE 02 ACTION Close(oLeTxt)
@ 70,188 BMPBUTTON TYPE 05 ACTION Pergunte(cPerg,.T.)

Activate Dialog oLeTxt Centered

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � OKLETXT  � Autor � AP6 IDE            � Data �  31/08/09   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao chamada pelo botao OK na tela inicial de processamen���
���          � to. Executa processamentop                                 ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function OkLeTxt

//���������������������������������������������������������������������Ŀ
//� Inicializa a regua de processamento                                 �
//�����������������������������������������������������������������������
Processa({|| RunCont() },"Processando...")
Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � RUNCONT  � Autor � AP5 IDE            � Data �  31/08/09   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao auxiliar chamada pela PROCESSA.  A funcao PROCESSA  ���
���          � monta a janela com a regua de processamento.               ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function RunCont

dbselectarea("CT2")
dbsetorder(1)
dbselectarea("SN1")
dbsetorder(1)
while SN1->(!eof())
	_filialn1 := SN1->N1_FILIAL
	
	cQuery := " SELECT CT2_FILIAL,CT2_DATA,CT2_DOC FROM "
	cQuery += RetSqlName("CT2")+" CT2 (NOLOCK),  "
	cQuery += " WHERE CT2_FILIAL = '" + SN1->N1_FILIAL + "'"
	cQuery += " AND CT2_DATA = '" + DTOS(SN1->N1_AQUISIC) + "'"
	cQuery += " AND CT2.D_E_L_E_T_ = '' "
	cQuery += " ORDER BY CT2_DOC DESC "

	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TRBCT2', .F., .T.)
	_numdoc := TRBCT2->CT2_DOC
	TRBCT2->(dbclosearea())
	
	
	while _filialn1 == SN1->N1_FILIAL
//		Begin Transaction
		_numdoc++
		//Grava o CT2
		DbSelectArea("CT2")
		Reclock("CT2",.T.)
		CT2->CT2_FILIAL := SN1->N1_FILIAL // 01
		CT2->CT2_DATA   := SN1->N1_AQUISIC // 20090827
		CT2->CT2_LOTE   := '008860'
		CT2->CT2_SBLOTE := '001'
		CT2->CT2_DOC    := strzero(_numdoc)
		CT2->CT2_LINHA  := '001'
		CT2->CT2_MOEDLC := '01
		CT2->CT2_DC     := '3'
		CT2->CT2_DEBITO       := ''
		CT2->CT2_CREDIT        := ''
		CT2->CT2_VALOR    := ''
		CT2->CT2_HIST:= ''
		CT2->CT2_EMPORI := ''
		CT2->CT2_FILORI := ''
		CT2->CT2_TPSALD := ''
		CT2->CT2_SEQUEN := ''
		CT2->CT2_MANUAL := ''
		CT2->CT2_ORIGEM:= ''
		CT2->CT2_ROTINA:= ''
		CT2->CT2_AGLUT:= ''
		CT2->CT2_LP := ''
		CT2->CT2_SEQHIS:= ''
		CT2->CT2_SEQLAN := ''
		CT2->CT2_CRCONV:= ''
		CT2->CT2_DTCV3  := ''
		
		CT2->(dbskip())
	enddo
enddo
Return nil
