#INCLUDE "Protheus.ch"
#INCLUDE "TopConn.ch"
#INCLUDE "TBICONN.CH"
/*
���������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������
�����������������������������������������������������������������������������������������ͻ��
��� Programa    � CTBXFUN  � Biblioteca de Fun��es Cont�beis                              ���
�����������������������������������������������������������������������������������������͹��
��� Autor       �          �                                                              ���
�����������������������������������������������������������������������������������������͹��
��� Observa��es � Aqui devem ser inclu�das apenas as fun��es de uso comum na contabilidade���
���             � e para tartamento de lan�amentos padronizados                           ���
�����������������������������������������������������������������������������������������ͼ��
���������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������
*/

/*
���������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������
�����������������������������������������������������������������������������������������ͻ��
��� Programa    � GetConta � Rotina para buscar os dados do lan�amento cont�bil conforme  ���
���             �          � to tipo de opera��o                                          ���
�����������������������������������������������������������������������������������������͹��
��� Solicitante � 05.09.06 �                                                              ���
�����������������������������������������������������������������������������������������͹��
��� Autor       � 05.09.06 �                                                              ���
�����������������������������������������������������������������������������������������͹��
��� Produ��o    � ??.??.?? � Ignorado                                                     ���
�����������������������������������������������������������������������������������������͹��
��� Par�metros  � Nil.                                                                    ���
�����������������������������������������������������������������������������������������͹��
��� Retorno     � Nil.                                                                    ���
�����������������������������������������������������������������������������������������͹��
��� Observa��es �                                                                         ���
���             �                                                                         ���
�����������������������������������������������������������������������������������������͹��
��� Altera��es  � 99.99.99 - Consultor - Descri��o da altera��o                           ���
���             �                                                                         ���
�����������������������������������������������������������������������������������������ͼ��
���������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������
*/
User Function GetConta(cTipMov, cDC, cProcesso)

Local aAreaAtu	:= GetArea()
Local aAreaPZA	:= PZA->(GetArea())
Local xRet		:= ""
Local cCampo	:= ""

//�����������������������������������������������������������������Ŀ
//�Se n�o tiver c�digo de opera��o compatibiliza o retorno da fun��o�
//�������������������������������������������������������������������
If Empty(cTipMov)
	If  ("T" $ cDC) .or. ("V" $ cDC) .Or. ("B" $ cDC)
		xRet	:= .F.
	Else
		xRet	:= " "
	Endif
Else
	//�������������������������������������������������������������������Ŀ
	//�Posiciona no arquivo de amarra��o Tipo de Opera��o x Conta Cont�bil�
	//���������������������������������������������������������������������
	dbSelectArea("PZA")
	dbSetOrder(1)
	If MsSeek(xFilial("PZA")+cTipMov)
		//������������������������������������Ŀ
		//�Se for retorno de valor do principal�
		//��������������������������������������
		If ("V" $ cDC)
			If PZA->PZA_VLRPRI == "1"		// Contabiliza o valor principal
				xRet	:= .T.
			Else
				xRet	:= .F.
			EndIf
		//����������������������������������Ŀ
		//�Se for retorno de valor das baixas�
		//������������������������������������
		ElseIf ("B" $ cDC)
			If PZA->PZA_VLRBXA == "1"		// Contabiliza o valor da baixa
				xRet	:= .T.
			Else
				xRet	:= .F.
			EndIf
		//��������������������������������Ŀ
		//�Se for retorno de valor do custo�
		//����������������������������������
		ElseIf ("T" $ cDC)
			If PZA->PZA_VLRCUS == "1"		// Contabiliza o valor principal
				xRet	:= .T.
			Else
				xRet	:= .F.
			EndIf
		//���������������������������Ŀ
		//�Se for retorno de hist�rico�
		//�����������������������������
		ElseIf ("H" $ cDC)
			//���������������������������������������������������������������������Ŀ
			//�Formata o campo a ser processado de acordo com os par�metros passados�
			//�����������������������������������������������������������������������
			cCampo	:= "PZA_"+cDC+cProcesso
			//�����������������������������������Ŀ
			//�Obtem o conte�do do campo formatado�
			//�������������������������������������
			cCampo	:= &(cCampo)
		
			xRet	:= AllTrim(cCampo)
		//�������������������������������������������������������������������������Ŀ
		//�Se for retorno de conta,centro de custo, item cont�bil ou classe de valor�
		//���������������������������������������������������������������������������
		Else
			//���������������������������������������������������������������������Ŀ
			//�Formata o campo a ser processado de acordo com os par�metros passados�
			//�����������������������������������������������������������������������
			cCampo	:= "PZA_"+cDC+cProcesso
			//�����������������������������������Ŀ
			//�Obtem o conte�do do campo formatado�
			//�������������������������������������
			cCampo	:= &(cCampo)
			//���������������������������������������������������������������������������������Ŀ
			//�Verifica se o conte�do de campo � uma personaliza��o ou um campo de algum arquivo�
			//�S� executa a macro quando o conte�do n�o for uma conta formatada                 �
			//�����������������������������������������������������������������������������������
			If ("->" $ cCampo) .Or. ("U_" $ cCampo)
				xRet	:= AllTrim(&(cCampo))
			Else
				xRet	:= AllTrim(cCampo)
			EndIf
			//��������������������������������������������������������������Ŀ
			//�Compatibiliza o conte�do com o tamanho do campo baseado no SX3�
			//����������������������������������������������������������������
			If cDC $ "U"
				xRet	:= xRet+Space( TAMSX3("CTT_CUSTO")[1] - Len(xRet) )
			ElseIf cDC $ "I"
				xRet	:= xret+Space( TAMSX3("CTD_ITEM")[1] - Len(xRet) )
			ElseIf cDC $ "L"
				xRet	:= xret+Space( TAMSX3("CTH_CLVL")[1] - Len(xRet) )
			Else
				xRet	:= xRet+Space( TAMSX3("CT1_CONTA")[1] - Len(xRet) )
			EndIf
		EndIf
	//��������������������������������������������������������������������������������Ŀ
	//�Se n�o acha o c�digo de opera��o informado, retorna valor nulo para n�o dar erro�
	//����������������������������������������������������������������������������������	
	Else
		If  ("T" $ cDC) .or. ("V" $ cDC) .or. ("B" $ cDC)
			xRet	:= .F.
		Else
			xRet	:= " "
		Endif
	EndIf
EndIf

RestArea(aAreaPZA)
RestArea(aAreaAtu)

Return(xRet)



/*
���������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������
�����������������������������������������������������������������������������������������ͻ��
��� Programa    � CadTipo  � Rotina de manuten��o na tabela de amarra��o tipo de opera��o ���
���             �          � x Centro de Custo.                                           ���
�����������������������������������������������������������������������������������������͹��
��� Solicitante � 05.09.06 �                                                              ���
�����������������������������������������������������������������������������������������͹��
��� Autor       � 05.09.06 �                                                              ���
�����������������������������������������������������������������������������������������͹��
��� Produ��o    � ??.??.?? � Ignorado                                                     ���
�����������������������������������������������������������������������������������������͹��
��� Par�metros  � Nil.                                                                    ���
�����������������������������������������������������������������������������������������͹��
��� Retorno     � Nil.                                                                    ���
�����������������������������������������������������������������������������������������͹��
��� Observa��es �                                                                         ���
���             �                                                                         ���
�����������������������������������������������������������������������������������������͹��
��� Altera��es  � 99.99.99 - Consultor - Descri��o da altera��o                           ���
���             �                                                                         ���
�����������������������������������������������������������������������������������������ͼ��
���������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������
*/
User Function CadTipo()

Local cCadTipoAl	:= ".T."
Local cCadTipoEx	:= "U_CadTpExc()"

Private cCadastro	:= "Cadastro de Tipo de Movimento x Contabiliza��o"

AxCadastro("PZA", cCadastro, cCadTipoEx, cCadTipoal)

Return(Nil)



/*
���������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������
�����������������������������������������������������������������������������������������ͻ��
��� Programa    � CadTpExc � Rotina que verifica se o tipo de opera��o a ser exclu�do foi ���
���             �          � utilizado.                                                   ���
�����������������������������������������������������������������������������������������͹��
��� Solicitante � 05.09.06 �                                                              ���
�����������������������������������������������������������������������������������������͹��
��� Autor       � 05.09.06 �                                                              ���
�����������������������������������������������������������������������������������������͹��
��� Produ��o    � ??.??.?? � Ignorado                                                     ���
�����������������������������������������������������������������������������������������͹��
��� Par�metros  � Nil.                                                                    ���
�����������������������������������������������������������������������������������������͹��
��� Retorno     � Nil.                                                                    ���
�����������������������������������������������������������������������������������������͹��
��� Observa��es �                                                                         ���
���             �                                                                         ���
�����������������������������������������������������������������������������������������͹��
��� Altera��es  � 99.99.99 - Consultor - Descri��o da altera��o                           ���
���             �                                                                         ���
�����������������������������������������������������������������������������������������ͼ��
���������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������
*/
User Function CadTpExc()

Local aAreaAtu	:= GetArea()
Local lRet	:= .T.
Local cQry	:= ""

cQry	:= " SELECT SUM(QDEREG) AS TOTREG"
cQry	+= " FROM ("
cQry	+= "	SELECT COUNT(*) AS QDEREG"
cQry	+= "	FROM "+RetSqlName("SD1")+" SD1"
cQry	+= "	WHERE SD1.D1_FILIAL = '"+xFilial("SD1")+"'"
cQry	+= "	AND SD1.D1_OPER = '"+PZA->PZA_TIPMOV+"'"
cQry	+= "	AND SD1.D_E_L_E_T_ <> '*'"
If SD2->(FieldPos("D2_XTIPOP")) > 0
	cQry	+= " UNION"
	cQry	+= "	SELECT COUNT(*) AS QDEREG"
	cQry	+= "	FROM "+RetSqlName("SD2")+" SD2"
	cQry	+= "	WHERE SD2.D2_FILIAL = '"+xFilial("SD2")+"'"
	cQry	+= "	AND SD2.D2_XTIPOP = '"+PZA->PZA_TIPMOV+"'"
	cQry	+= "	AND SD2.D_E_L_E_T_ <> '*'"
EndIf
If SE2->(FieldPos("E2_XOPER")) > 0
	cQry	+= " UNION"
	cQry	+= "	SELECT COUNT(*) AS QDEREG"
	cQry	+= "	FROM "+RetSqlName("SE2")+" SE2"
	cQry	+= "	WHERE SE2.E2_FILIAL = '"+xFilial("SE2")+"'"
	cQry	+= "	AND SE2.E2_XOPER = '"+PZA->PZA_TIPMOV+"'"
	cQry	+= "	AND SE2.D_E_L_E_T_ <> '*'"
EndIf
If SE2->(FieldPos("E1_XOPER")) > 0
	cQry	+= " UNION"
	cQry	+= "	SELECT COUNT(*) AS QDEREG"
	cQry	+= "	FROM "+RetSqlName("SE2")+" SE2"
	cQry	+= "	WHERE SE1.E1_FILIAL = '"+xFilial("SE1")+"'"
	cQry	+= "	AND SE1.E1_XOPER = '"+PZA->PZA_TIPMOV+"'"
	cQry	+= "	AND SE1.D_E_L_E_T_ <> '*'"
EndIf
cQry	+= ") BASE"

If Select("PZADEL") > 0
	dbSelectArea("PZADEL")
	dbCloseArea()
EndIf

TCQUERY cQry NEW ALIAS "PZADEL"
dbSelectArea("PZADEL")
dbGoTop()

If PZADEL->TOTREG > 0
	Aviso(	cCadastro,;
			"Este tipo de opera��o foi utilizado em algum movimento passado e n�o poder� ser exclu�do.",;
			{"&Continua"},,;
			"Sem Permiss�o" )
	lRet	:= .F.
EndIf

dbSelectarea("PZADEL")
dbCloseArea()

RestArea(aAreaAtu)

Return(lRet)

/*
���������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������
�����������������������������������������������������������������������������������������ͻ��
��� Programa    � VldCadTp � Rotina para validar a digita��o da conta contabil, centro de ���
���             �          � custo, item cont�bil e classe de valor na tabela PZA.        ���
�����������������������������������������������������������������������������������������͹��
��� Solicitante � 05.09.06 �                                                              ���
�����������������������������������������������������������������������������������������͹��
��� Autor       � 05.09.06 �                                                              ���
�����������������������������������������������������������������������������������������͹��
��� Produ��o    � ??.??.?? � Ignorado                                                     ���
�����������������������������������������������������������������������������������������͹��
��� Par�metros  � Nil.                                                                    ���
�����������������������������������������������������������������������������������������͹��
��� Retorno     � Nil.                                                                    ���
�����������������������������������������������������������������������������������������͹��
��� Observa��es �                                                                         ���
���             �                                                                         ���
�����������������������������������������������������������������������������������������͹��
��� Altera��es  � 99.99.99 - Consultor - Descri��o da altera��o                           ���
���             �                                                                         ���
�����������������������������������������������������������������������������������������ͼ��
���������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������
*/
User Function VldCadTp(cConteudo,cAlias)

Local lRet	:= .T.

If !Empty(cConteudo)
	If !("->" $ cConteudo .Or. "U_" $ cConteudo)
		If cAlias == "CT1"		// Conta Cont�bil
			cConteudo	:= SubStr(cConteudo,1,TAMSX3("CT1_CONTA")[1])
			If Empty(GetAdvFVal("CT1", "CT1_CONTA", xFilial("CT1")+cConteudo, 1, ""))
				Aviso(	cCadastro,;
						"A conta informada n�o consta do cadastro de plano de contas ! Escolha uma conta v�lida.",;
						{"&Continua"},,;
						"Conta: "+AllTrim(cConteudo))
				lRet	:= .F.
			EndIf
		ElseIf cAlias == "CTT"	// Centro de Custo
			cConteudo	:= SubStr(cConteudo,1,TAMSX3("CTT_CUSTO")[1])
			If Empty(GetAdvFVal("CTT", "CTT_CUSTO", xFilial("CTT")+cConteudo, 1, ""))
				Aviso(	cCadastro,;
						"O centro de custo informado n�o consta do cadastro de Custos ! Escolha um centro de custo v�lido.",;
						{"&Continua"},,;
						"Centro de Custo: "+AllTrim(cConteudo))
				lRet	:= .F.
			EndIf
		ElseIf cAlias == "CTD"	// Item Cont�bil
			cConteudo	:= SubStr(cConteudo,1,TAMSX3("CTD_ITEM")[1])
			If Empty(GetAdvFVal("CTD", "CTD_ITEM", xFilial("CTD")+cConteudo, 1, ""))
				Aviso(	cCadastro,;
						"O item cont�bil informado n�o consta do cadastro de Custos ! Escolha um item cont�bil v�lido.",;
						{"&Continua"},,;
						"Item cont�bil: "+AllTrim(cConteudo))
				lRet	:= .F.
			EndIf
		EndIf
	Else
		If "U_" $ cConteudo
			If !FindFunction(AllTrim(cConteudo))
				Aviso(	cCadastro,;
					"A personaliza��o informada n�o consta do reposit�rio em uso ! Troque o reposit�rio ou a fun��o.",;
					{"&Continua"},,;
					"Fun��o: "+AllTrim(cConteudo))
				lRet	:= .F.
			EndIf
		EndIf
	EndIf
Endif
	
Return(lRet)


/*
���������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������
�����������������������������������������������������������������������������������������ͻ��
��� Programa    � TpOpVld  � Rotina para validar se o tipo de opera��o pode ser utilizado ���
���             �          � Por defini��o de 01 a 49 ser�o para sa�das de 50 at� ZZ para ���
���             �          � entradas.                                                    ���
�����������������������������������������������������������������������������������������͹��
��� Solicitante � 05.09.06 �                                                              ���
�����������������������������������������������������������������������������������������͹��
��� Autor       � 05.09.06 �                                                              ���
�����������������������������������������������������������������������������������������͹��
��� Produ��o    � ??.??.?? � Ignorado                                                     ���
�����������������������������������������������������������������������������������������͹��
��� Par�metros  � ExpC1 = Tipo de Opera��o a ser pesquisado                               ���
�����������������������������������������������������������������������������������������͹��
��� Retorno     � ExpL1 = .T. pode ser utilizado .F. n�o pode ser utilizado               ���
�����������������������������������������������������������������������������������������͹��
��� Observa��es �                                                                         ���
���             �                                                                         ���
�����������������������������������������������������������������������������������������͹��
��� Altera��es  � 99.99.99 - Consultor - Descri��o da altera��o                           ���
���             �                                                                         ���
�����������������������������������������������������������������������������������������ͼ��
���������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������
*/
User Function TpOpVld(cTpOper)

Local lRet		:= .T.
Local cRotina	:= Alltrim(FunName())
Local cDescOp	:= Tabela("DJ", cTpOper, .F.)

//������������������������������Ŀ
//� Inclus�o do Contas a Receber �
//��������������������������������
If cRotina $ "FINA050" .And. cTpOper >= "01" .And. cTpOper <= "49"
	Aviso(	"Tipo de Opera��o",;
			"O tipo de opera��o informado ("+cTpOper+"-"+cDescOp+") n�o � v�lido para ser utilizado na rotina."+Chr(13)+Chr(10)+;
			"Escolha um tipo maior que 50.",;
			{"&Continua"},2,;
			"Rotina: " + cRotina )
	lRet	:= .F.
ElseIf cRotina $ "MATA410" .And. cTpOper >= "50" .And. cTpOper <= "01"
	Aviso(	"Tipo de Opera��o",;
			"O tipo de opera��o informado ("+cTpOper+"-"+cDescOp+") n�o � v�lido para ser utilizado na rotina."+chr(13)+Chr(10)+;
			"Escolha um tipo menor que 50.",;
			{"&Continua"},2,;
			"Rotina "+ cRotina )
	lRet	:= .F.
EndIf

Return(lRet)



/*
���������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������
�����������������������������������������������������������������������������������������ͻ��
��� Programa    � CadTpOp  � Rotina para dar manuten��o na tabela de tipo de opera��o (DJ)���
���             �          �                                                              ���
�����������������������������������������������������������������������������������������͹��
��� Solicitante � 05.01.07 �                                                              ���
�����������������������������������������������������������������������������������������͹��
��� Autor       � 05.01.07 �                                                              ���
�����������������������������������������������������������������������������������������͹��
��� Produ��o    � ??.??.?? � Ignorado                                                     ���
�����������������������������������������������������������������������������������������͹��
��� Par�metros  � Nil                                                                     ���
�����������������������������������������������������������������������������������������͹��
��� Retorno     � Nil                                                                     ���
�����������������������������������������������������������������������������������������͹��
��� Observa��es �                                                                         ���
���             �                                                                         ���
�����������������������������������������������������������������������������������������͹��
��� Altera��es  � 99.99.99 - Consultor - Descri��o da altera��o                           ���
���             �                                                                         ���
�����������������������������������������������������������������������������������������ͼ��
���������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������
*/
User Function CadTpOp()

Local aAreaAtu	:= GetArea()

//������������������������������������������������������������Ŀ
//� Chama a fun��o da Lib que da manuten��o nas tabelas do SX5 �
//��������������������������������������������������������������
U_AltTbSX5("DJ")

RestArea(aAreaAtu)

Return(Nil)
