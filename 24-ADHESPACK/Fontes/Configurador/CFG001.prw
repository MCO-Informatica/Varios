/*/
������������������������������������������������������������������������������
������������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ���
���Funcao    � CHKSTRU � Autor � Lucas Baia             � Data � 21.02.22 ����
�������������������������������������������������������������������������Ĵ���
���Descricao � Ajusta Base X SX3 X SINDEX                                 ����
��������������������������������������������������������������������������ٱ��
������������������������������������������������������������������������������
������������������������������������������������������������������������������
/*/
#INCLUDE "PROTHEUS.CH"                                                                     

//��������������������������������������������������������������������������Ŀ
//� Define variaveus staticas...                                             �
//����������������������������������������������������������������������������
Static oMemo
Static cMemo := "" 

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Program   � CFG001	�Author � Lucas Baia       � Date � 21/02/2022    ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao de atualizacao da estrutura das tabelas (CHKTOP).   ���
�������������������������������������������������������������������������͹��
���Use       � SIGACFG 											          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function CFG001()

	//��������������������������������������������������������������������������Ŀ
	//� Define variaveis da funcao...                                            �
	//����������������������������������������������������������������������������
	PRIVATE oDlg
	PRIVATE aCritica  := {}
	PRIVATE lCritico  := .F.
	PRIVATE cDataBase := AllTrim(TCGetDB())
	
	//��������������������������������������������������������������������������Ŀ
	//� Inicializa dados...                                                      �
	//����������������������������������������������������������������������������
	cMemo    := ""
	cMascara := "   "
	//��������������������������������������������������������������������������Ŀ
	//� Define dialogo...                                                        �
	//����������������������������������������������������������������������������
	DEFINE MSDIALOG oDlg TITLE "Atualizador de Estrutura - Versao 2.1" FROM 0,0 TO 330,600 PIXEL
	//��������������������������������������������������������������������������Ŀ
	//� Define objeto memo...                                                    �
	//����������������������������������������������������������������������������
	@ 3,3 GET oMemo  VAR cMemo MEMO SIZE 297,130 OF oDlg PIXEL
	oMemo:lReadOnly := .T.
	//��������������������������������������������������������������������������Ŀ
	//� Define objetos de inputs....                                             �
	//����������������������������������������������������������������������������
	@ 138, 003 SAY "Mascara :" OF oDlg PIXEL SIZE 050,006
	@ 137, 030 GET cMascara Picture "@!" OF oDlg VALID /*ValidaAlias(cMascara)*/SIZE 050,006 PIXEL
	@ 138, 085 SAY "-->>  INSIRA A TABELA QUE DESEJA ATUALIZAR OU DEIXE EM BRANCO" OF oDlg PIXEL SIZE 300,006
	@ 150, 085 SAY "      PARA TODAS AS TABELAS DO SX2" OF oDlg PIXEL SIZE 300,006
	DEFINE SBUTTON FROM 152,03 TYPE 1 ACTION(Processa({||fOK(cMascara)})) OF oDlg ENABLE PIXEL
	//��������������������������������������������������������������������������Ŀ
	//� Ativa o dialogo...                                                       �
	//����������������������������������������������������������������������������
	ACTIVATE DIALOG oDlg CENTERED
	//��������������������������������������������������������������������������Ŀ
	//� Fim da Rotina...                                                         �
	//����������������������������������������������������������������������������

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Program   � fOK		�Author � Lucas Baia         � Date � 21/02/2022  ���
�������������������������������������������������������������������������͹��
���Desc.     � Valida a mascara das tabelas a atualizar. 				  ���
�������������������������������������������������������������������������͹��
���Param.    � cMascara - Mascara informada pelo usuario. 				  ���
�������������������������������������������������������������������������͹��
���Use       � SIGACFG 											          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static function fOK(cMascara)

	Local aStruSX3 	:= {}
	Local _aAreaSX2	:= {}
	
	If Empty(cMascara)
	
		__SetX31Mode(.F.)

		DbSelectArea("SX2")
		SX2->(DbSetOrder(1))
		ProcRegua(SX2->(RecCount()))
		SX2->(DbGotop())
		While !SX2->(Eof())
			_aAreaSX2 := SX2->(GetArea())
			IncProc("Tabela: "+ SX2->X2_CHAVE)
			X31UpdTable(SX2->X2_CHAVE)
			DbSelectArea(SX2->X2_CHAVE)

			//Desbloqueando altera��es no dicion�rio
			__SetX31Mode(.T.)
			
			DbCloseArea()
			RestArea(_aAreaSX2)
			SX2->(Dbskip())
		EndDo	
	Else
		__SetX31Mode(.F.)

		X31UpdTable(Alltrim(cMascara))

		If __GetX31Error()
			Alert(__GetX31Trace())
			Aviso("Atencao!","Ocorreu um erro desconhecido durante a atualizacao!")
		EndIf

		DbSelectArea(Alltrim(cMascara))
		//Desbloqueando altera��es no dicion�rio
		__SetX31Mode(.T.)

	EndIf


Return
