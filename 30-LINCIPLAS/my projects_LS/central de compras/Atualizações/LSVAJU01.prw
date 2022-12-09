/*�������������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������������
�����������������������������������������������������������������������������������������������ͻ��
���Funcao    � LSVAJU01   � Autor � Jose Renato July                          � Data � SET/2014 ���
�����������������������������������������������������������������������������������������������͹��
���Descricao � Ajusta a tabela SBZ da filial RC com base na filial BH.                          ���
�����������������������������������������������������������������������������������������������͹��
���Uso       � Especifico para clientes TOTVS - LASELVA                                         ���
�����������������������������������������������������������������������������������������������͹��
���               ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL                              ���
�����������������������������������������������������������������������������������������������͹��
���Autor       �  Data  � Descricao da Atualizacao                                              ���
�����������������������������������������������������������������������������������������������͹��
���            �???/2012� #???AAMMDD-                                                           ���
���            �???/2012� #???AAMMDD-                                                           ���
���            �???/2012� #???AAMMDD-                                                           ���
�����������������������������������������������������������������������������������������������ͼ��
���������������������������������������������������������������������������������������������������
�������������������������������������������������������������������������������������������������*/
#INCLUDE 'PROTHEUS.CH' 
#INCLUDE 'TOPCONN.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'AP5MAIL.CH'

User Function LSVAJU01()

Local oProcess
Local oDlg
Local nOpcA      := 0
Local cCadastro  := OemtoAnsi('Avalia��o do cadastro dos Indicadores do Produto.')
Local aSays      := {}
Local aButtons   := {}

Private cString  := 'SBZ'
Private l_Termi  := .F.
Private _cCta001 := 0
Private _cCta002 := 0

Private _fTt0       := 'Aten��o.'
Private _fTt1       := 'Espec�fico LASELVA - Programa: ' + Alltrim(FunName())
Private _fCx0       := 'INFO'
Private _fCx1       := 'STOP'
Private _fCx2       := 'OK'
Private _fCx3       := 'ALERT'
Private _fCx4       := 'YESNO'
	
aAdd(aSays,OemToAnsi('Atualiza��o do cadastro dos Indicadores de Produtos.         '))
aAdd(aSays,OemToAnsi('                                                             '))
aAdd(aSays,OemToAnsi('Atualizar� os campos do BZ_EMIN, BZ_EMA e BZ_PRV1.           '))
aAdd(aSays,OemToAnsi('                                                             '))
aAdd(aButtons, {1,.T.,{|o| nOpcA:= 1,If(MsgYesNo(OemToAnsi('Confirma atualiza��o?'),OemToAnsi('Aten��o.')),o:oWnd:End(),nOpcA:=0)}})
aAdd(aButtons, {2,.T.,{|o| o:oWnd:End()}})
FormBatch(cCadastro,aSays,aButtons,,200,405)

If nOpcA == 1

	oProcess:= MsNewProcess():New({|lEnd| RunExe01(oProcess)},_fTt1,'',.F.)
	oProcess:Activate()
	If l_Termi
		_cMsg := '       Termino normal !'  + CHR(13) + CHR(13)
		_cMsg += 'Atualizados     - ' + Str(_cCta001) + CHR(13)
		_cMsg += 'Lidos           - ' + Str(_cCta002) + CHR(13)
		Msgbox(_cMsg,'Registros atualizados','INFO')
	EndIf
	
EndIf

dbSelectArea('SBZ')
Retindex('SBZ')

Return()
/*�������������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������������
�����������������������������������������������������������������������������������������������ͻ��
���Static    � RunExe01   � Autor � Jose Renato July                          � Data � SET/2014 ���
�����������������������������������������������������������������������������������������������͹��
���Descricao �                                                                                  ���
�����������������������������������������������������������������������������������������������ͼ��
���������������������������������������������������������������������������������������������������
�������������������������������������������������������������������������������������������������*/
Static Function RunExe01(oObj)

oObj:SetRegua1(2)
oObj:IncRegua1('')
oObj:IncRegua1('Ajustando TABELA SBZ ...')
oObj:SetRegua2(1)
oObj:IncRegua2('...')

//�����������������������������������������������������������������������������������������������Ŀ
//� Seleciona a tabela SXB para execucao das atividades de atualizacao.                           �
//�������������������������������������������������������������������������������������������������
cQuery 	:= " SELECT DISTINCT "
cQuery 	+= " BZ_COD , BZ_EMIN , BZ_EMAX , BZ_PRV1 "
cQuery 	+= "  FROM " + RetSqlName("SBZ") + " SBZ "
cQuery 	+= " WHERE SBZ.BZ_FILIAL = 'BH' "
cQuery 	+= "   AND SBZ.D_E_L_E_T_ = '' "

//�����������������������������������������������������������������������������������������������Ŀ
//� Calcula a quantidade de registros para a contagem da regua.                                   �
//�������������������������������������������������������������������������������������������������
c_VerQry := " SELECT COUNT(*) AS _nCount FROM (" + cQuery + ") AS MYQUERY "
c_VerQry := ChangeQuery(c_VerQry)
If Select('QRYTEMP') > 0
	dbSelectArea('QRYTEMP')
	QRYTEMP->(dbCloseArea())
EndIf
dbUseArea(.T.,'TOPCONN',TCGENQRY(,,c_VerQry),'QRYTEMP',.T.,.T.)
_nConta	:= QRYTEMP->_NCOUNT
dbSelectArea('QRYTEMP')
QRYTEMP->(dbCloseArea())

//�����������������������������������������������������������������������������������������������Ŀ
//� Executa Query para a selecao de registros.                                                    �
//�������������������������������������������������������������������������������������������������
cQuery  += " ORDER BY BZ_COD "
cQuery 	:= ChangeQuery(cQuery)
If Select('TEMP_01') > 0
	TEMP_01->(dbCloseArea())
EndIf
dbUseArea(.T.,'TOPCONN',TCGENQRY(,,cQuery),'TEMP_01',.T.,.T.)
dbSelectArea('TEMP_01')

If !Eof()
	
	//�����������������������������������������������������������������������������������������������Ŀ
	//� Contador da regua de processamento.                                                           �
	//�������������������������������������������������������������������������������������������������
	dbSelectArea('TEMP_01')
	_nRegistro := 0 //Adcionado GRS - 03/10/2014
	TEMP_01->(DBEVAL({|| _nRegistro++}))//Adcionado GRS - 03/10/2014
	
	oObj:SetRegua2(_nRegistro)
	dbGoTop()
	
	Do While !Eof()
		
		//�����������������������������������������������������������������������������������������������Ŀ
		//� Incrementa a regua de processamento.                                                          �
		//�������������������������������������������������������������������������������������������������
		IncProc("Atualizando tabela SBZ - " + AllTrim(TEMP_01->BZ_COD) )
		oObj:IncRegua2("Ajustando a tabela SBZ: " + AllTrim(TEMP_01->BZ_COD) + ".")
		
		dbSelectArea("SBZ")
		dbSetOrder(1)
		If SBZ->(dbSeek("BH" + TEMP_01->BZ_COD))
			RecLock("SBZ",.F.)
			SBZ->BZ_EMIN	:= TEMP_01->BZ_EMIN
			SBZ->BZ_EMAX	:= TEMP_01->BZ_EMAX
			SBZ->BZ_PRV1	:= TEMP_01->BZ_PRV1
			SBZ->(MsUnlock())
		    _cCta001++
		EndIf

		dbSelectArea('TEMP_01')
		TEMP_01->(dbSkip())
		
	EndDo
	TEMP_01->(dbCloseArea())
	
EndIf

l_Termi  := .T.

Return()
/*�������������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������������
�����������������������������������������������������������������������������������������������Ŀ��
���              ��������  ��  ��  �����                ������  ���  ��  ����                   ���
���                 ��     ��  ��  ��                   ��      ���� ��  �� ��                  ���
���                 ��     ������  ����                 ������  �� ����  ��  ��                 ���
���                 ��     ��  ��  ��                   ��      ��  ���  �� ��                  ���
���                 ��     ��  ��  �����                ������  ��   ��  ����                   ���
������������������������������������������������������������������������������������������������ٱ�
���������������������������������������������������������������������������������������������������
�������������������������������������������������������������������������������������������������*/