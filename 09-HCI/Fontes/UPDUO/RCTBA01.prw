#include "rwmake.ch"
/*
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������
�����������������������������������������������������������������������������Ŀ��
���Programa  � RCTBA01  � Autor � Ricardo Correa de Souza � Data � 23/09/2005 ���
�����������������������������������������������������������������������������Ĵ��
���Descricao � Limpa Lancamentos Contabeis e Flags de Contabilizacao          ���
�����������������������������������������������������������������������������Ĵ��
���Observacao�                                                                ���
�����������������������������������������������������������������������������Ĵ��
���Uso       � Scenika Diagnosticos Ltda                                      ���
�����������������������������������������������������������������������������Ĵ��
���             ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL              ���
�����������������������������������������������������������������������������Ĵ��
���Programador   �  Data  �              Motivo da Alteracao                  ���
�����������������������������������������������������������������������������Ĵ��
���              �        �                                                   ���
������������������������������������������������������������������������������ٱ�
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������
*/

User Function RCTBA01()

@ 200,1 TO 430,500 DIALOG oDlg1 TITLE "LIMPEZA DOS REGISTROS CONTABILIZADOS VIA LANCAMENTO PADRAO"
@ 5,08 TO 90,240

@ 035,040 Say OemtoAnsi("Esta rotina tem o objetivo de limpar os registros contabilizados para que sejam")
@ 055,040 Say OemtoAnsi("reprocessados atraves da contabilizacao off-line conforme parametro selecionado")

@ 98,130 BMPBUTTON TYPE 05 ACTION Pergunte("CTBA01",.T.)
@ 98,170 BMPBUTTON TYPE 01 ACTION LimFin1()
@ 98,210 BMPBUTTON TYPE 02 ACTION Close(oDlg1)

Pergunte("CTBA01",.F.)

ACTIVATE DIALOG oDlg1 CENTERED

Return(nil)

Static Function Limfin1()

Processa({|lend| LimpFin2()},"Alterando")

MsgInfo("Limpeza efetuada com sucesso!!!","Aviso ")

Close(oDlg1)

Return

Static Function LimpFin2()
Private _Query := ""

If     Mv_Par03 == 1
	LimpaTudo()
ElseIf Mv_Par03 == 2
	LimpaFin()
ElseIf Mv_Par03 == 3
	LimpaFat()
ElseIf Mv_Par03 == 4
	LimpaCom()
Endif

Return

Static Function LimpaTudo()

#IFDEF TOP
	
	//�������������������������������Ŀ
	//� Limpa Flag do Contas a Receber�
	//���������������������������������
	
	_Query:="UPDATE  "+RetSQLName("SE1")+" SET E1_LA= ''"
	_Query+="WHERE E1_EMIS1 >='"+DTOS(MV_PAR01)+"' AND E1_EMIS1 <='"+DTOS(MV_PAR02)+"' AND "
	_Query+="E1_FILIAL >='"+MV_PAR04+"' AND E1_FILIAL <= '"+MV_PAR05+"' AND "
	_Query+="E1_ORIGEM LIKE '%FINA%' AND "
	_Query+="D_E_L_E_T_<>'*'"
	TCSQLEXEC(_Query)
	
	
	//������������������������������Ŀ
	//� Limpa Flag do Contas a Pagar �
	//��������������������������������
	_Query:="UPDATE  "+RetSQLName("SE2")+" SET E2_LA= '' "
	_Query+="WHERE E2_EMIS1 >='"+DTOS(MV_PAR01)+"' AND E2_EMIS1 <='"+DTOS(MV_PAR02)+"' AND "
	_Query+="E2_FILIAL >='"+MV_PAR04+"' AND E2_FILIAL <= '"+MV_PAR05+"' AND "
	_Query+="E2_ORIGEM LIKE '%FINA%' AND "
	_Query+="D_E_L_E_T_<>'*'"
	TCSQLEXEC(_Query)
	
	
	//�����������������������������Ŀ
	//� Limpa Flag da Mov. Bancaria �
	//�������������������������������
	_Query:="UPDATE  "+RetSQLName("SE5")+" SET E5_LA = ''  "
	_Query+="WHERE E5_DATA >='"+DTOS(MV_PAR01)+"' AND E5_DATA <='"+DTOS(MV_PAR02)+"' AND "
	_Query+="E5_FILIAL >='"+MV_PAR04+"' AND E5_FILIAL <= '"+MV_PAR05+"' AND "
	_Query+="E5_MOTBX<>'DAC'  AND "
	_Query+="D_E_L_E_T_<>'*'"
	TCSQLEXEC(_Query)
	
	//�������������������������������Ŀ
	//� Limpa Flag do Cad. de Cheques �
	//���������������������������������
	_Query:="UPDATE  "+RetSQLName("SEF")+" SET EF_LA = '' "
	_Query+="WHERE EF_DATA >='"+DTOS(MV_PAR01)+"' AND EF_DATA <='"+DTOS(MV_PAR02)+"' AND "
	_Query+="EF_FILIAL >='"+MV_PAR04+"' AND EF_FILIAL <= '"+MV_PAR05+"' AND "
	_Query+="D_E_L_E_T_<>'*'"
	TCSQLEXEC(_Query)
	
	//��������������������������������������������Ŀ
	//� Limpa Flag das NFS. de Entrada - Cabecalho �
	//����������������������������������������������
	_Query:="UPDATE  "+RetSQLName("SF1")+" SET F1_CPROVA = '', F1_DTLANC = ''  "
	_Query+="WHERE F1_DTDIGIT >='"+DTOS(MV_PAR01)+"' AND F1_DTDIGIT <='"+DTOS(MV_PAR02)+"' AND "
	_Query+="F1_FILIAL >='"+MV_PAR04+"' AND F1_FILIAL <= '"+MV_PAR05+"' AND "
	_Query+="D_E_L_E_T_<>'*'"
	TCSQLEXEC(_Query)
	
	/*
	// ESPECIFICO
	//����������������������������������������Ŀ
	//� Limpa Flag das NFS. de Entrada - Itens �
	//������������������������������������������
	_Query:="UPDATE  "+RetSQLName("SD1")+" SET D1_CONTA = '  ' "
	_Query+="WHERE D1_DTDIGIT >='"+DTOS(MV_PAR01)+"' AND D1_DTDIGIT <='"+DTOS(MV_PAR02)+"' AND "
	_Query+="D_E_L_E_T_<>'*'"
	TCSQLEXEC(_Query)
	*/
	
	//������������������������������������������Ŀ
	//� Limpa Flag das NFS. de Saida - Cabecalho �
	//��������������������������������������������
	_Query:="UPDATE  "+RetSQLName("SF2")+" SET F2_DTLANC = ''"
	_Query+="WHERE F2_EMISSAO>='"+DTOS(MV_PAR01)+"' AND F2_EMISSAO <='"+DTOS(MV_PAR02)+"' AND "
	_Query+="F2_FILIAL >='"+MV_PAR04+"' AND F2_FILIAL <= '"+MV_PAR05+"' AND "
	_Query+="D_E_L_E_T_<>'*'"
	TCSQLEXEC(_Query)
	
	
	// Alterado por Paulo Henrique - Microsiga - em 08/11/2001
	// Incluida a Limpeza para Notas Fiscais de Saida
	/*
	//��������������������������������������Ŀ
	//� Limpa Flag das NFS. de Saida - Itens �
	//����������������������������������������
	_Query:="UPDATE  "+RetSQLName("SD2")+" SET D2_CONTA = '  '"
	_Query+="WHERE D2_EMISSAO>='"+DTOS(MV_PAR01)+"' AND D2_EMISSAO <='"+DTOS(MV_PAR02)+"' AND "
	_Query+="D_E_L_E_T_<>'*'"
	TCSQLEXEC(_Query)
	*/
	
#ELSE
	
	dbSelectArea("SE1")
	dbSetOrder(6)
	// Alterado por Cl�udio retirado o IF e o Endif
	dbSeek(xFilial()+DTOS(MV_PAR01),.T.)
	nrec := LastRec()
	ProcRegua(nrec)
	While !Eof() .And. SE1->E1_EMIS1 >= MV_PAR01 .And. SE1->E1_EMIS1 <= MV_PAR02
		IncProc("Alterando Contas a Receber....")
		If SE1->E1_ORIGEM $ "FINA"
			dbSelectArea("SE1")
			RecLock("SE1",.F.)
			SE1->E1_LA := " "
			MsUnlock()
		Endif
		dbSkip()
	EndDo
	
	//������������������������������Ŀ
	//� Limpa Flag do Contas a Pagar �
	//��������������������������������
	dbSelectArea("SE2")
	dbSetOrder(5)
	// Alterado por Cl�udio retirado o IF e o Endif
	dbSeek(xFilial()+DTOS(MV_PAR01),.T.)
	nrec := LastRec()
	ProcRegua(nrec)
	While !Eof() .And. SE2->E2_EMIS1 >= MV_PAR01 .And. SE2->E2_EMIS1 <= MV_PAR02
		IncProc("Alterando Contas a Pagar....")
		If SE2->E2_ORIGEM $ "FINA"
			RecLock("SE2",.F.)
			SE2->E2_LA := " "
			MsUnlock()
		Endif
		dbSkip()
	EndDo
	
	//�����������������������������Ŀ
	//� Limpa Flag da Mov. Bancaria �
	//�������������������������������
	dbSelectArea("SE5")
	dbSetOrder(1)
	// Alterado por Cl�udio retirado o IF e o Endif
	dbSeek(xFilial()+DTOS(MV_PAR01),.T.)
	nrec := LastRec()
	ProcRegua(nrec)
	While !Eof() .And. SE5->E5_DATA >= MV_PAR01 .And. SE5->E5_DATA <= MV_PAR02
		
		IncProc("Alterando Movimento Bancario....")
		IF E5_MOTBX <> "DAC"
			RecLock("SE5",.F.)
			SE5->E5_LA    := " "
			MsUnlock()
			dbSkip()
		Endif
		
	EndDo
	
	//�������������������������������Ŀ
	//� Limpa Flag do Cad. de Cheques �
	//���������������������������������
	dbSelectArea("SEF")
	dbSetOrder(1)
	DbGotop()
	nrec := LastRec()
	ProcRegua(nrec)
	While !Eof()
		IncProc("Alterando Cadastro de Cheque....")
		If SEF->EF_DATA >= MV_PAR01 .And. SEF->EF_DATA <= MV_PAR02
			dbSelectArea("SEF")
			RecLock("SEF",.F.)
			SEF->EF_LA := " "
			MsUnlock()
		Endif
		dbSkip()
	EndDo
	
	//��������������������������������������������Ŀ
	//� Limpa Flag das NFS. de Entrada - Cabecalho �
	//����������������������������������������������
	dbSelectArea("SF1")
	DbOrderNickName("SF1_DATA")
	
	//dbSetOrder(6)
	dbGoTop()
	nRec := LastRec()
	ProcRegua(nRec)
	// Alterado por Cl�udio retirado o IF e o Endif
	// Alterado por Cl�udio incluso no comando SEEK o campo ".T." em 27/11/01
	dbSeek(xFilial()+DTOS(Mv_Par01),.T.)
	While SF1->F1_DTDIGIT >= Mv_Par01 .And. SF1->F1_DTDIGIT <= Mv_Par02 .And. !Eof()
		IncProc("Alterando Cabecalho de Nf. De Entrada....")
		RecLock("SF1",.F.)
		SF1->F1_CPROVA := " "
		SF1->F1_DTLANC := Ctod(Space(08))
		MsUnlock()
		dbSkip()
	Enddo
	
	
	/*
	//����������������������������������������Ŀ
	//� Limpa Flag das NFS. de Entrada - Itens �
	//������������������������������������������
	dbSelectArea("SD1")
	// Alterado por Cl�udio de indice 6 para 11 em 27/11/01
	dbSetOrder(6)
	dbGoTop()
	nRec := LastRec()
	ProcRegua(nRec)
	// Alterado por Cl�udio retirado o IF e o Endif
	// Alterado por Cl�udio incluso no comando SEEK o campo ".T." em 27/11/01
	dbSeek(xFilial()+DTOS(Mv_Par01),.T.)
	While SD1->D1_DTDIGIT >= Mv_Par01 .And. SD1->D1_DTDIGIT <= Mv_Par02 .And. !Eof()
	IncProc("Alterando Itens de Nota Fiscal de Entrada....")
	RecLock("SD1",.F.)
	SD1->D1_CONTA := " "
	MsUnlock()
	dbSkip()
	Enddo
	*/
	
	//������������������������������������������Ŀ
	//� Limpa Flag das NFS. de Saida - Cabecalho �
	//��������������������������������������������
	dbSelectArea("SF2")
	dbSetOrder(7)
	dbGoTop()
	nRec := LastRec()
	ProcRegua(nRec)
	// Alterado por Cl�udio retirado o IF e o Endif
	// Alterado por Cl�udio incluso no comando SEEK o campo ".T." em 27/11/01
	dbSeek(xFilial()+DTOS(Mv_Par01),.T.)
	While SF2->F2_EMISSAO >= Mv_Par01 .And. SF2->F2_EMISSAO <= Mv_Par02 .And. !Eof()
		IncProc("Alterando Cabecalho de Nf. De Saida....")
		RecLock("SF2",.F.)
		SF2->F2_DTLANC := Ctod(Space(08))
		MsUnlock()
		dbSkip()
	Enddo
	
	/*
	// Alterado por Paulo Henrique - Microsiga - em 08/11/2001
	// Incluida a Limpeza para Notas Fiscais de Saida
	//��������������������������������������Ŀ
	//� Limpa Flag das NFS. de Saida - Itens �
	//����������������������������������������
	
	dbSelectArea("SD2")
	dbSetOrder(5)
	dbGoTop()
	nRec := LastRec()
	ProcRegua(nRec)
	// Alterado por Cl�udio retirado o IF e o Endif
	// Alterado por Cl�udio incluso no comando SEEK o campo ".T." em 27/11/01
	dbSeek(xFilial()+DTOS(Mv_Par01),.T.)
	While SD2->D2_EMISSAO >= Mv_Par01 .And. SD2->D2_EMISSAO <= Mv_Par02 .And. !Eof()
	IncProc("Alterando Itens de Nota Fiscal de Saida....")
	RecLock("SD2",.F.)
	SD2->D2_CONTA := ""
	MsUnlock()
	dbSkip()
	Enddo
	*/
	
#ENDIF


//�����������������������������Ŀ
//� Limpa Lancamentos Cont�beis �
//�������������������������������
LimpaCont()

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � LimpaFin � Autor � Almeida               � Data � 03/08/03 ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Limpa Contabilizacao do Financeiro                         ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function LimpaFin()


#IFDEF TOP
	
	
	//�������������������������������Ŀ
	//� Limpa Flag do Contas a Receber�
	//���������������������������������
	
	_Query:="UPDATE  "+RetSQLName("SE1")+" SET E1_LA= ''"
	_Query+="WHERE E1_EMIS1 >='"+DTOS(MV_PAR01)+"' AND E1_EMIS1 <='"+DTOS(MV_PAR02)+"' AND "
	_Query+="E1_FILIAL >='"+MV_PAR04+"' AND E1_FILIAL <= '"+MV_PAR05+"' AND "
	_Query+="E1_ORIGEM LIKE '%FINA%' AND "
	_Query+="D_E_L_E_T_<>'*'"
	TCSQLEXEC(_Query)
	
	
	//������������������������������Ŀ
	//� Limpa Flag do Contas a Pagar �
	//��������������������������������
	_Query:="UPDATE  "+RetSQLName("SE2")+" SET E2_LA= '' "
	_Query+="WHERE E2_EMIS1 >='"+DTOS(MV_PAR01)+"' AND E2_EMIS1 <='"+DTOS(MV_PAR02)+"' AND "
	_Query+="E2_FILIAL >='"+MV_PAR04+"' AND E2_FILIAL <= '"+MV_PAR05+"' AND "
	_Query+="E2_ORIGEM LIKE '%FINA%' AND "
	_Query+="D_E_L_E_T_<>'*'"
	TCSQLEXEC(_Query)
	
	
	//�����������������������������Ŀ
	//� Limpa Flag da Mov. Bancaria �
	//�������������������������������
	_Query:="UPDATE  "+RetSQLName("SE5")+" SET E5_LA=''  "
	_Query+="WHERE E5_DATA >='"+DTOS(MV_PAR01)+"' AND E5_DATA <='"+DTOS(MV_PAR02)+"' AND "
	_Query+="E5_FILIAL >='"+MV_PAR04+"' AND E5_FILIAL <= '"+MV_PAR05+"' AND "
	_Query+="E5_MOTBX<>'DAC'  AND "
	_Query+="D_E_L_E_T_<>'*'"
	TCSQLEXEC(_Query)
	
	//�������������������������������Ŀ
	//� Limpa Flag do Cad. de Cheques �
	//���������������������������������
	_Query:="UPDATE  "+RetSQLName("SEF")+" SET EF_LA='' "
	_Query+="WHERE EF_DATA >='"+DTOS(MV_PAR01)+"' AND EF_DATA <='"+DTOS(MV_PAR02)+"' AND "
	_Query+="EF_FILIAL >='"+MV_PAR04+"' AND EF_FILIAL <= '"+MV_PAR05+"' AND "
	_Query+="D_E_L_E_T_<>'*'"
	TCSQLEXEC(_Query)
	
	
#ELSE
	
	//��������������������������������Ŀ
	//� Limpa Flag do Contas a Receber �
	//����������������������������������
	dbSelectArea("SE1")
	dbSetOrder(6)
	// Alterado por Cl�udio retirado o IF e o Endif
	dbSeek(xFilial()+DTOS(MV_PAR01),.T.)
	nrec := LastRec()
	ProcRegua(nrec)
	While !Eof() .And. SE1->E1_EMIS1 >= MV_PAR01 .And. SE1->E1_EMIS1 <= MV_PAR02
		IncProc("Alterando Contas a Receber....")
		If SE1->E1_ORIGEM $ "FINA"
			dbSelectArea("SE1")
			RecLock("SE1",.F.)
			SE1->E1_LA := " "
			MsUnlock()
		Endif
		dbSkip()
	EndDo
	
	//������������������������������Ŀ
	//� Limpa Flag do Contas a Pagar �
	//��������������������������������
	dbSelectArea("SE2")
	dbSetOrder(5)
	// Alterado por Cl�udio retirado o IF e o Endif
	dbSeek(xFilial()+DTOS(MV_PAR01),.T.)
	nrec := LastRec()
	ProcRegua(nrec)
	While !Eof() .And. SE2->E2_EMIS1 >= MV_PAR01 .And. SE2->E2_EMIS1 <= MV_PAR02
		IncProc("Alterando Contas a Pagar....")
		If SE2->E2_ORIGEM $ "FINA"
			RecLock("SE2",.F.)
			SE2->E2_LA := " "
			MsUnlock()
		Endif
		dbSkip()
	EndDo
	
	//�������������������������������Ŀ
	//� Limpa Flag do Cad. de Cheques �
	//���������������������������������
	dbSelectArea("SEF")
	dbSetOrder(1)
	dbGotop()
	nrec := LastRec()
	ProcRegua(nrec)
	While !Eof()
		IncProc("Alterando Cadastro de Cheque....")
		If SEF->EF_DATA >= MV_PAR01 .And. SEF->EF_DATA <= MV_PAR02
			dbSelectArea("SEF")
			RecLock("SEF",.F.)
			SEF->EF_LA := ""
			MsUnlock()
		Endif
		dbSkip()
	EndDo
	
	//�����������������������������Ŀ
	//� Limpa Flag da Mov. Bancaria �
	//�������������������������������
	dbSelectArea("SE5")
	dbSetOrder(1)
	// Alterado por Cl�udio retirado o IF e o Endif
	dbSeek(xFilial()+DTOS(MV_PAR01),.T.)
	nrec := LastRec()
	ProcRegua(nrec)
	While !Eof() .And. SE5->E5_DATA >= MV_PAR01 .And. SE5->E5_DATA <= MV_PAR02
		IncProc("Alterando Movimento Bancario ....")
		IF E5_MOTBX <> "DAC"
			RecLock("SE5",.F.)
			SE5->E5_LA    := " "
			MsUnlock()
		Endif
		dbSkip()
	EndDo
	
#ENDIF

//�����������������������������Ŀ
//� Limpa Lancamentos Cont�beis �
//�������������������������������
LimpaCont()

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � LimpaFat � Autor � Almeida               � Data � 08/11/01 ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Limpa Contabiliza��o do Faturamento                        ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function LimpaFat()

#IFDEF TOP
	
	//������������������������������������������Ŀ
	//� Limpa Flag das NFS. de Saida - Cabecalho �
	//��������������������������������������������
	_Query:="UPDATE  "+RetSQLName("SF2")+" SET F2_DTLANC ='' "
	_Query+="WHERE F2_EMISSAO >='"+DTOS(MV_PAR01)+"' AND F2_EMISSAO <='"+DTOS(MV_PAR02)+"' AND "
	_Query+="F2_FILIAL >='"+MV_PAR04+"' AND F2_FILIAL <= '"+MV_PAR05+"' AND "
	_Query+="D_E_L_E_T_<>'*'"
	TCSQLEXEC(_Query)
	
	
	//��������������������������������������Ŀ
	//� Limpa Flag das NFS. de Saida - Itens �
	//����������������������������������������
	_Query:="UPDATE  "+RetSQLName("SD2")+" SET D2_CONTA='' "
	_Query+="WHERE D2_EMISSAO >='"+DTOS(MV_PAR01)+"' AND D2_EMISSAO <='"+DTOS(MV_PAR02)+"' AND "
	_Query+="D2_FILIAL >='"+MV_PAR04+"' AND D2_FILIAL <= '"+MV_PAR05+"' AND "
	_Query+="D_E_L_E_T_<>'*'"
	TCSQLEXEC(_Query)
	
	
#ELSE
	
	//������������������������������������������Ŀ
	//� Limpa Flag das NFS. de Saida - Cabecalho �
	//��������������������������������������������
	dbSelectArea("SF2")
	dbSetOrder(6)
	dbGoTop()
	nRec := LastRec()
	ProcRegua(nRec)
	// Alterado por Cl�udio retirado o IF e o Endif
	// Alterado por Cl�udio incluso no comando SEEK o campo ".T." em 27/11/01
	dbSeek(xFilial()+DTOS(Mv_Par01),.T.)
	While SF2->F2_EMISSAO >= Mv_Par01 .And. SF2->F2_EMISSAO <= Mv_Par02 .And. !Eof()
		IncProc("Alterando Cabecalho de Nf. De Saida....")
		RecLock("SF2",.F.)
		SF2->F2_DTLANC := Ctod(Space(08))
		MsUnlock()
		dbSkip()
	Enddo
	
	//��������������������������������������Ŀ
	//� Limpa Flag das NFS. de Saida - Itens �
	//����������������������������������������
	
	dbSelectArea("SD2")
	dbSetOrder(5)
	dbGoTop()
	nRec := LastRec()
	ProcRegua(nRec)
	// Alterado por Cl�udio retirado o IF e o Endif
	// Alterado por Cl�udio incluso no comando SEEK o campo ".T." em 27/11/01
	dbSeek(xFilial()+DTOS(Mv_Par01),.T.)
	While SD2->D2_EMISSAO >= Mv_Par01 .And. SD2->D2_EMISSAO <= Mv_Par02 .And. !Eof()
		IncProc("Alterando Itens de Nota Fiscal de Saida....")
		RecLock("SD2",.F.)
		SD2->D2_CONTA := ""
		MsUnlock()
		dbSkip()
	Enddo
	
#endif

//�����������������������������Ŀ
//� Limpa Lancamentos Cont�beis �
//�������������������������������
LimpaCont()

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � LimpaCom � Autor � Almeida               � Data � 03/08/03 ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Limpa Contabliza��o do Compras                             ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function LimpaCom()

#IFDEF TOP
	
	//��������������������������������������������Ŀ
	//� Limpa Flag das NFS. de Entrada - Cabecalho �
	//����������������������������������������������
	_Query:="UPDATE  "+RetSQLName("SF1")+" SET F1_CPROVA ='',F1_DTLANC='' "
	_Query+="WHERE F1_DTDIGIT >='"+DTOS(MV_PAR01)+"' AND F1_DTDIGIT <='"+DTOS(MV_PAR02)+"' AND "
	_Query+="F1_FILIAL >='"+MV_PAR04+"' AND F1_FILIAL <= '"+MV_PAR05+"' AND "
	_Query+="D_E_L_E_T_<>'*'"
	TCSQLEXEC(_Query)
	
	
	//����������������������������������������Ŀ
	//� Limpa Flag das NFS. de Entrada - Itens �
	//������������������������������������������
	_Query:="UPDATE  "+RetSQLName("SD1")+" SET D1_CONTA ='' "
	_Query+="WHERE D1_DTDIGIT >='"+DTOS(MV_PAR01)+"' AND D1_DTDIGIT <='"+DTOS(MV_PAR02)+"' AND "
	_Query+="D1_FILIAL >='"+MV_PAR04+"' AND D1_FILIAL <= '"+MV_PAR05+"' AND "
	_Query+="D_E_L_E_T_<>'*'"
	TCSQLEXEC(_Query)
	
	
#ELSE
	
	//��������������������������������������������Ŀ
	//� Limpa Flag das NFS. de Entrada - Cabecalho �
	//����������������������������������������������
	dbSelectArea("SF1")
	DbOrderNickName("SF1_DATA")
	//dbSetOrder(6)
	dbGoTop()
	nRec := LastRec()
	ProcRegua(nRec)
	// Alterado por Cl�udio retirado o IF e o Endif
	// Alterado por Cl�udio incluso no comando SEEK o campo ".T." em 27/11/01
	dbSeek(xFilial()+DTOS(Mv_Par01),.T.)
	While SF1->F1_DTDIGIT >= Mv_Par01 .And. SF1->F1_DTDIGIT <= Mv_Par02 .And. !Eof()
		IncProc("Alterando Cabecalho de Nf. De Entrada....")
		RecLock("SF1",.F.)
		SF1->F1_CPROVA := " "
		SF1->F1_DTLANC := Ctod(Space(08))
		MsUnlock()
		dbSkip()
	Enddo
	
	//����������������������������������������Ŀ
	//� Limpa Flag das NFS. de Entrada - Itens �
	//������������������������������������������
	
	dbSelectArea("SD1")
	//Alterado por Cl�udio de indice 6 para 11 em 27/11/01
	dbSetOrder(6)
	dbGoTop()
	nRec := LastRec()
	ProcRegua(nRec)
	// Alterado por Cl�udio retirado o IF e o Endif
	// Alterado por Cl�udio incluso no comando SEEK o campo ".T." em 27/11/01
	dbSeek(xFilial()+DTOS(Mv_Par01),.T.)
	While SD1->D1_DTDIGIT >= Mv_Par01 .And. SD1->D1_DTDIGIT <= Mv_Par02 .And. !Eof()
		IncProc("Alterando Itens de Nota Fiscal de Entrada....")
		RecLock("SD1",.F.)
		SD1->D1_CONTA := " "
		MsUnlock()
		dbSkip()
	Enddo
	
#endif

//�����������������������������Ŀ
//� Limpa Lancamentos Cont�beis �
//�������������������������������
LimpaCont()

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � LimpaCont� Autor � Alexandro da Silva    � Data � 03/08/03 ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Limpa Lan�amentos Cont�beis do Financeiro, Faturamento e   ���
���          � Compras ou em todos os m�dulos citados                     ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������

�����������������������������������������������������������������������������
/*/

Static Function LimpaCont()
Local _areasmo := {}

//�����������������������������Ŀ
//� Limpa Flag da Mov. Contabil �
//�������������������������������
#IFDEF TOP
	
	
	_query:="DELETE FROM "+RetSQLName("CT2")
	_query+=" WHERE CT2_DATA >='"+DTOS(MV_PAR01)+"' AND CT2_DATA <='"+DTOS(MV_PAR02)+"' AND "
	_Query+="CT2_FILIAL >='"+MV_PAR04+"' AND CT2_FILIAL <= '"+MV_PAR05+"' AND "
	if     mv_par03 == 1
		_query+="CT2_LOTE IN('008810','008811','008820','008821','008850','008851') AND "
	elseif mv_par03 == 2
		_query+="CT2_LOTE IN('008850','008851') AND "
	elseif mv_par03 == 3
		_query+="CT2_LOTE IN('008820','008821') AND "
	elseif mv_par03 == 4
		_query+="CT2_LOTE IN('008810','008811') AND "
	endif
	
	/*
	if mv_par03 <> 2  // financeiro
		_query+="CT2_FILIAL ='"+xfilial("CT2")+"' AND "
	endif
	*/
	_query+=" D_E_L_E_T_<>'*'"
	//TCSQLEXEC(_Query)
	
	
#ELSE
	
	
	if mv_par03 <> 2  // financeiro
		
		dbselectarea("si2")
		dbsetorder(3)
		dbgotop()
		nrec := lastrec()
		procregua(nrec)
		// alterado por cl�udio retirado o if e o endif
		dbseek(xfilial()+dtos(mv_par01),.t.)
		while si2->i2_data >= mv_par01 .and. si2->i2_data <= mv_par02 .and. !eof()
			incproc("deletando registros na mov. contabil....")
			if     mv_par03 == 1
				_clotecon := "8810/8820/8850"
			elseif mv_par03 == 2
				_clotecon := "8850"
			elseif mv_par03 == 3
				_clotecon := "8820"
			elseif mv_par03 == 4
				_clotecon := "8810"
			endif
			
			if si2->i2_lote $ _clotecon
				dbselectarea("si2")
				reclock("si2",.f.)
				dbdelete()
				msunlock()
			endif
			dbskip()
		enddo
		
	else
		
		dbselectarea("sm0")
		_areasmo:=getarea()
		
		dbgotop()
		
		while !eof()
			
			//����������������������������������������������������������������������Ŀ
			//�retorna a filial corrente.                                            �
			//������������������������������������������������������������������������
			cfilant:= cfilial:= SM0->M0_CODFIL
			
			dbselectarea("si2")
			dbsetorder(3)
			dbgotop()
			nrec := lastrec()
			procregua(nrec)
			// alterado por cl�udio retirado o if e o endif
			dbseek(xfilial()+dtos(mv_par01),.t.)
			while si2->i2_data >= mv_par01 .and. si2->i2_data <= mv_par02 .and. !eof()
				incproc("deletando registros na mov. contabil....")
				if     mv_par03 == 1
					_clotecon := "8810/8820/8850"
				elseif mv_par03 == 2
					_clotecon := "8850"
				elseif mv_par03 == 3
					_clotecon := "8820"
				elseif mv_par03 == 4
					_clotecon := "8810"
				endif
				
				if si2->i2_lote $ _clotecon
					dbselectarea("si2")
					reclock("si2",.f.)
					dbdelete()
					msunlock()
				endif
				dbskip()
			enddo
			
			dbselectarea("sm0")
			sm0->(DBSKIP())
			
		enddo
		
		dbselectarea("sm0")
		RestArea(_areasmo)
		cfilant:= cfilial:= SM0->M0_CODFIL
		
	endif
	
#endif

Return
