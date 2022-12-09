#INCLUDE "TOPCONN.CH"
#include "rwmake.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �LPMSA03   �Autor  �Alexandre Sousa     � Data �  10/04/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �Controle de Versoes de orcamentos. Obriga o usuario a criar ���
���          �uma nova versao a cada nova alteracao do orcamento.         ���
�������������������������������������������������������������������������͹��
���Uso       �Especifico LISONDA.                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function LPMSA03()

	Local aSalvAmb := GetArea()
	Local cTitulo  := 'Controle de altera��es' //Iif( c_tit = Nil, "T�tulo", c_tit)
	Local nPos		:= 1 //Iif(n_pos = Nil, 1, n_pos)
	Local n_x		:= 0
	Local c_tit := " "

	Private c_Lst		:= ''
	Private aVetor   := {}
	Private c_Query := " select *, convert(varchar(10), convert(datetime, Z2_DTINI), 103)  as DTINI, convert(varchar(10), convert(datetime, Z2_DTFIM), 103)  as DTFIM from "+RetSqlName("SZ2")+" where Z2_FILIAL = '"+xFilial("SZ2")+"' and Z2_ORCAME = '"+AF1->AF1_ORCAME+"' and D_E_L_E_T_ <> '*' "
	Private a_campos := {{"Revisao", "Dt.Ini", "Hora Ini.", "Dt.Fim", "Hora Fim", "Respons�vel" }, {"Z2_NUMREV", "DTINI", "Z2_HRINI", "DTFIM", "Z2_HRFIM", "Z2_NOMEUSR"}}
	Private oDlg	:= Nil
	Private oLbx	:= Nil
	Private c_Ret	:= ''

 	If Select("QRX") > 0
		DbSelectArea("QRX")
		DbCloseArea()
	EndIf
	TcQuery c_Query New Alias "QRX"

	//+-------------------------------------+
	//| Carrega o vetor conforme a condicao |
	//+-------------------------------------+
	While QRX->(!EOF())
		aAdd(aVetor, Array(len(a_campos[2])))
		
		For n_x := 1 to len(a_campos[2])
			aVetor[len(aVetor),n_x] := &("QRX->"+a_campos[2,n_x])
		Next
		QRX->(dbSkip())
	End

	If Len( aVetor ) == 0
//	   Aviso( cTitulo, "Nao existe dados para a consulta", {"Ok"} )
//	   Return
		aAdd(aVetor, Array(len(a_campos[2])))
		
		For n_x := 1 to len(a_campos[2])
			aVetor[len(aVetor),n_x] := ''
		Next
	Endif

	//+-----------------------------------------------+
	//| Limitado a dez colunas                        |
	//+-----------------------------------------------+
	c_A := IIf(len(a_campos[1])>=1,a_campos[1,1],'' )
	c_B := IIf(len(a_campos[1])>=2,a_campos[1,2],'' )
	c_C := IIf(len(a_campos[1])>=3,a_campos[1,3],'' )
	c_D := IIf(len(a_campos[1])>=4,a_campos[1,4],'' )
	c_E := IIf(len(a_campos[1])>=5,a_campos[1,5],'' )
	c_F := IIf(len(a_campos[1])>=6,a_campos[1,6],'' )
	c_G := IIf(len(a_campos[1])>=7,a_campos[1,7],'' )
	c_H := IIf(len(a_campos[1])>=8,a_campos[1,8],'' )
	c_I := IIf(len(a_campos[1])>=9,a_campos[1,9],'' )
	c_J := IIf(len(a_campos[1])>=10,a_campos[1,10],'' )

	//+-----------------------------------------------+
	//| Monta a tela para usuario visualizar consulta |
	//+-----------------------------------------------+
	DEFINE MSDIALOG oDlg TITLE cTitulo FROM 000,000 TO 250,500 PIXEL
	@ 010,010 LISTBOX oLbx FIELDS HEADER c_A, c_B, c_C, c_D, c_E, c_F, c_G, c_H, c_I, c_J On DBLCLICK (c_Ret := oLbx:AARRAY[oLbx:NAT][nPos], oDlg:End()) SIZE 230,095 OF oDlg PIXEL	
	                                                			
	oLbx:SetArray( aVetor )
		                    
	c_Lst := '{|| {aVetor[oLbx:nAt,1],'
	For n_x := 2 to len(a_campos[2])-1
		c_Lst += '     aVetor[oLbx:nAt,'+Str(n_x)+'],'
	Next
	c_Lst += '    aVetor[oLbx:nAt,'+Str(len(a_campos[2]))+']}}'

	oLbx:bLine := &c_Lst
	c_Ret := &c_Lst
	
//	DEFINE SBUTTON FROM 107,213 TYPE 2 ACTION (c_Ret := oLbx:AARRAY[oLbx:NAT][nPos], oDlg:End()) ENABLE OF oDlg
	n_m := 4
	n_i := 101
	n_d	:= 0
	n_p := 35
	@ 107,n_i+n_m+n_d Button OemToAnsi("Visualizar") Size 30,12 Action ViewVers(oLbx:AARRAY[oLbx:NAT][nPos])
	n_d += n_p
	@ 107,n_i+n_m+n_d Button OemToAnsi("Nova") Size 30,12 Action NewVers()
	n_d += n_p
	@ 107,n_i+n_m+n_d Button OemToAnsi("Encerrar") Size 30,12 Action CloseVers()
	n_d += n_p
  //	@ 107,n_i+n_m+n_d Button OemToAnsi("Sair") Size 30,12 Action oDlg:End() //substituida pela linha abaixo LH ACTUAL 04/01/2017   
	@ 107,n_i+n_m+n_d Button OemToAnsi("Sair") Size 30,12 Action CloseVers1()

	@ 107,10 Button OemToAnsi("Subir como Oficial") Size 60,12 Action SobeOficial(oLbx:AARRAY[oLbx:NAT][nPos])

	ACTIVATE MSDIALOG oDlg Centered
	
	RestArea( aSalvAmb )


/*nList := 0
aList := {}

//���������������������������������������������������������������������Ŀ
//� Criacao da Interface                                                �
//�����������������������������������������������������������������������
@ 176,317 To 474,945 Dialog mkwdlg Title OemToAnsi("Controle de Altera��es")
@ 16,18 ListBox nList Items aList Size 273,94
Activate Dialog mkwdlg
      */
Return
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NewVers   �Autor  �Microsiga           � Data �  10/04/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �Cria nova versao de um orcamento.                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function NewVers()

	DbSelectArea('SZ2')
	DbSetOrder(1) //Z2_FILIAL, Z2_ORCAME, Z2_NUMREV, R_E_C_N_O_, D_E_L_E_T_
	
	If DbSeek(xFilial('SZ2')+AF1->AF1_ORCAME)
		While SZ2->(!EOF()) .and. AF1->AF1_ORCAME == SZ2->Z2_ORCAME
			If Empty(SZ2->Z2_DTFIM)
				msgAlert('Existe uma revis�o aberta, realize o encerramento antes de come�ar uma nova altera��o', 'A T E N � � O')
				Return
			EndIf
			SZ2->(DbSkip())
		EndDo
	EndIf
	
	RecLock('SZ2', .T.)
	SZ2->Z2_NUMREV	:= U_FGEN003('SZ2', 'Z2_NUMREV', ' Z2_ORCAME = ' + AF1->AF1_ORCAME)
	SZ2->Z2_ORCAME	:= AF1->AF1_ORCAME
	SZ2->Z2_DTINI	:= dDataBase
	SZ2->Z2_HRINI	:= TIME()
	SZ2->Z2_USR		:= __cuserid
	SZ2->Z2_NOMEUSR	:= cusername
	MsUnLock()
	
	RecLock('AF1', .F.)
	AF1->AF1_XVERS := SZ2->Z2_NUMREV
	MsUnLock()
	
	oDlg:End()	
	//U_LPMSA03() comentado LH ACTUAL 04/01/2017
	
Return
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CloseVers �Autor  �Microsiga           � Data �  10/06/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �Encerra a versao atual e guarda os dados gravados.          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function CloseVers()
	
	DbSelectArea('SZ2')
	DbSetOrder(1) //Z2_FILIAL, Z2_ORCAME, Z2_NUMREV, R_E_C_N_O_, D_E_L_E_T_
	If DbSeek(xFilial('SZ2')+AF1->AF1_ORCAME+AF1->AF1_XVERS)
		If !Empty(SZ2->Z2_DTFIM)
			msgAlert('A vers�o atual j� est� encerrada!!', 'A T E N � � O')
			Return
		Endif
		
		If SZ2->Z2_USR <> __cuserid
			msgAlert('O usu�rio: '+Alltrim(SZ2->Z2_NOMEUSR)+' est� alterando esse or�amento, � necess�rio que ele encerre essa vers�o para que outro usu�rio possa alterar!!!', "A T E N � � O")
			Return
		Endif
		
	Else
		msgAlert('N�o existe nenhuma vers�o para esse or�amento!!!', 'A T E N � � O')
		Return
	EndIf
	
	//������������������������������������������������������������Ŀ
	//�Copia as informacoes atuais para nao perder a versao.       �
	//��������������������������������������������������������������
	c_alias1 := 'AF1'
	c_alias2 := 'ZF1'
	RecLock(c_alias2, .T.)
	(c_alias2)->&(c_alias2+"_XREV") := SZ2->Z2_NUMREV
	DbSelectArea('SX3')
	DbSetOrder(1)
	If DbSeek(c_alias1)
		While SX3->X3_ARQUIVO = c_alias1
			If SX3->X3_TIPO <> 'M' .and. SX3->X3_Context <> 'V'
				(c_alias2)->&(c_alias2+substr(SX3->X3_CAMPO,4,16)) := (c_alias1)->&(SX3->X3_CAMPO)
			EndIf
			SX3->(DbSkip())
		EndDo
	EndIf	
	(c_alias2)->(MsUnLock())
	
	a_tabelas := {{'AF2', 'ZF2'}, {'AF3', 'ZF3'}, {'AF4', 'ZF4'}, {'AF5', 'ZF5'}, {'AF7', 'ZF7'}}
	
	For n_x := 1 to len(a_tabelas)
		c_alias1 := a_tabelas[n_x, 1]
		c_alias2 := a_tabelas[n_x, 2]
		DbSelectArea(c_alias1)
		DbSetOrder(1)
		DbSeek(xFilial(c_alias1)+AF1->AF1_ORCAME)
		While (c_alias1)->(!EOF()) .and. (c_alias1)->&(c_alias1+'_ORCAME') = AF1->AF1_ORCAME
			RecLock(c_alias2, .T.)
			(c_alias2)->&(c_alias2+"_XREV") := SZ2->Z2_NUMREV
			DbSelectArea('SX3')
			DbSetOrder(1)
			If DbSeek(c_alias1)
				While SX3->X3_ARQUIVO = c_alias1
					If SX3->X3_TIPO <> 'M' .and. SX3->X3_Context <> 'V'
						(c_alias2)->&(c_alias2+substr(SX3->X3_CAMPO,4,16)) := (c_alias1)->&(SX3->X3_CAMPO)
					EndIf
					SX3->(DbSkip())
				EndDo
			EndIf	
			(c_alias2)->(MsUnLock())
			(c_alias1)->(DbSkip()) 
		EndDo
	Next

	RecLock('SZ2', .F.)
	SZ2->Z2_DTFIM	:= dDataBase
	SZ2->Z2_HRFIM	:= TIME()
	MsUnLock()
	
	oDlg:End()	
	U_LPMSA03()
	
Return   
// criada funcao para que quando o usuario clicar em SAIR seja registro tambem o encerramento da versao, solicitado por Artur 04/01/2017
Static Function CloseVers1()
	
	DbSelectArea('SZ2')
	DbSetOrder(1) //Z2_FILIAL, Z2_ORCAME, Z2_NUMREV, R_E_C_N_O_, D_E_L_E_T_
	If DbSeek(xFilial('SZ2')+AF1->AF1_ORCAME+AF1->AF1_XVERS)
		If !Empty(SZ2->Z2_DTFIM)
			msgAlert('A vers�o atual j� est� encerrada!!', 'A T E N � � O') 
			oDlg:End()
			Return
		Endif
		
		If SZ2->Z2_USR <> __cuserid
			msgAlert('O usu�rio: '+Alltrim(SZ2->Z2_NOMEUSR)+' est� alterando esse or�amento, � necess�rio que ele encerre essa vers�o para que outro usu�rio possa alterar!!!', "A T E N � � O")
			Return
		Endif
		
	Else
		msgAlert('N�o existe nenhuma vers�o para esse or�amento!!!', 'A T E N � � O')
		Return
	EndIf
	
	//������������������������������������������������������������Ŀ
	//�Copia as informacoes atuais para nao perder a versao.       �
	//��������������������������������������������������������������
	c_alias1 := 'AF1'
	c_alias2 := 'ZF1'
	RecLock(c_alias2, .T.)
	(c_alias2)->&(c_alias2+"_XREV") := SZ2->Z2_NUMREV
	DbSelectArea('SX3')
	DbSetOrder(1)
	If DbSeek(c_alias1)
		While SX3->X3_ARQUIVO = c_alias1
			If SX3->X3_TIPO <> 'M' .and. SX3->X3_Context <> 'V'
				(c_alias2)->&(c_alias2+substr(SX3->X3_CAMPO,4,16)) := (c_alias1)->&(SX3->X3_CAMPO)
			EndIf
			SX3->(DbSkip())
		EndDo
	EndIf	
	(c_alias2)->(MsUnLock())
	
	a_tabelas := {{'AF2', 'ZF2'}, {'AF3', 'ZF3'}, {'AF4', 'ZF4'}, {'AF5', 'ZF5'}, {'AF7', 'ZF7'}}
	
	For n_x := 1 to len(a_tabelas)
		c_alias1 := a_tabelas[n_x, 1]
		c_alias2 := a_tabelas[n_x, 2]
		DbSelectArea(c_alias1)
		DbSetOrder(1)
		DbSeek(xFilial(c_alias1)+AF1->AF1_ORCAME)
		While (c_alias1)->(!EOF()) .and. (c_alias1)->&(c_alias1+'_ORCAME') = AF1->AF1_ORCAME
			RecLock(c_alias2, .T.)
			(c_alias2)->&(c_alias2+"_XREV") := SZ2->Z2_NUMREV
			DbSelectArea('SX3')
			DbSetOrder(1)
			If DbSeek(c_alias1)
				While SX3->X3_ARQUIVO = c_alias1
					If SX3->X3_TIPO <> 'M' .and. SX3->X3_Context <> 'V'
						(c_alias2)->&(c_alias2+substr(SX3->X3_CAMPO,4,16)) := (c_alias1)->&(SX3->X3_CAMPO)
					EndIf
					SX3->(DbSkip())
				EndDo
			EndIf	
			(c_alias2)->(MsUnLock())
			(c_alias1)->(DbSkip()) 
		EndDo
	Next

	RecLock('SZ2', .F.)
	SZ2->Z2_DTFIM	:= dDataBase
	SZ2->Z2_HRFIM	:= TIME()
	MsUnLock()
	
	oDlg:End()	
 //	U_LPMSA03()
	
Return
// fim da funcao LH ACTUAL - 04/01/2017


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �LPMSA03   �Autor  �Microsiga           � Data �  10/06/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ViewVers(c_rev)

	a_area := GetArea()

	DbSelectArea('SZ2')
	DbSetOrder(1) //Z2_FILIAL, Z2_ORCAME, Z2_NUMREV, R_E_C_N_O_, D_E_L_E_T_
	DbSeek(xFilial('SZ2')+AF1->AF1_ORCAME+c_rev)

	DbSelectArea('ZF1')
	DbSetorder(1) //ZF1_FILIAL, ZF1_ORCAME, ZF1_XREV, ZF1_DESCRI, R_E_C_N_O_, D_E_L_E_T_
	If DbSeek(xFilial('ZF1')+AF1->AF1_ORCAME+c_rev)
		U_CPMS003("ZF1",ZF1->(Recno()),2)
	Else
		msgalert('Revis�o n�o localizada, verifique no or�amento, ou feche a revis�o atual!!!', 'A T E N � � O')
	EndIf

	RestArea(a_area)

Return
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �SobeOficia�Autor  �Alexandre Sousa     � Data �  10/15/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �Sobe a versao selecionada como a versao oficial do orcamento���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function SobeOficial(c_vers)

	If !Empty(AF1->AF1_XVERS)
		DbSelectArea('SZ2')
		DbSetOrder(1) //Z2_FILIAL, Z2_ORCAME, Z2_NUMREV, R_E_C_N_O_, D_E_L_E_T_
		If DbSeek(xFilial('SZ2')+AF1->AF1_ORCAME+AF1->AF1_XVERS)
			If !Empty(SZ2->Z2_DTFIM)
				msgAlert('Para alterar esse or�amento � necess�rio que seja criada uma nova vers�o!!!', "A T E N � � O")
				Return
			ElseIf SZ2->Z2_USR <> __cuserid
				msgAlert('O usu�rio: '+Alltrim(SZ2->Z2_NOMEUSR)+' est� alterando esse or�amento, � necess�rio que ele encerre essa vers�o para que outro usu�rio possa alterar!!!', "A T E N � � O")
				Return
			EndIf
		Else
			msgAlert('Para alterar esse or�amento � necess�rio que seja criada uma nova vers�o!!!', "A T E N � � O")
			Return
		EndIf
	Else
		msgAlert('Para alterar esse or�amento � necess�rio que seja criada uma nova vers�o!!!', "A T E N � � O")
		Return
	EndIf

	DbSelectArea('SZ2')
	DbSetOrder(1) //Z2_FILIAL, Z2_ORCAME, Z2_NUMREV, R_E_C_N_O_, D_E_L_E_T_
	DbSeek(xFilial('SZ2')+AF1->AF1_ORCAME+c_vers)

	If !msgNoYes('Tem certeza que deseja alterar a vers�o atual do or�amento com os dados da vers�a '+SZ2->Z2_NUMREV+'? N�o ser� possivel realizar o estorno dessa opera��o.', 'A T E N � � O')
		Return
	EndIf

	msgalert('esta realizando a alteracao')
//	Return
	
	//������������������������������������������������������������Ŀ
	//�Copia as informacoes atuais para nao perder a versao.       �
	//��������������������������������������������������������������
	c_alias1 := 'ZF1'
	c_alias2 := 'AF1'
//	(c_alias2)->&(c_alias2+"_XREV") := SZ2->Z2_NUMREV
	DbSelectArea('ZF1')
	DbSetOrder(1) //ZF1_FILIAL, ZF1_ORCAME, ZF1_XREV, ZF1_DESCRI, R_E_C_N_O_, D_E_L_E_T_
	If DbSeek(xFilial('ZF1')+AF1->AF1_ORCAME+c_vers)
		RecLock(c_alias2, .F.)
		DbSelectArea('SX3')
		DbSetOrder(1)
		If DbSeek(c_alias1)
			While SX3->X3_ARQUIVO = c_alias1
				If SX3->X3_TIPO <> 'M' .and. SX3->X3_Context <> 'V'
					(c_alias2)->&(c_alias2+substr(SX3->X3_CAMPO,4,16)) := (c_alias1)->&(SX3->X3_CAMPO)
				EndIf
				SX3->(DbSkip())
			EndDo
		EndIf	
		(c_alias2)->(MsUnLock())
	EndIf
	
	a_tabelas := {{'AF2', 'ZF2'}, {'AF3', 'ZF3'}, {'AF4', 'ZF4'}, {'AF5', 'ZF5'}, {'AF7', 'ZF7'}}
	
	For n_x := 1 to len(a_tabelas)
		c_alias1 := a_tabelas[n_x, 1]
		c_alias2 := a_tabelas[n_x, 2]
		DbSelectArea(c_alias1)
		DbSetOrder(1)
		DbSeek(xFilial(c_alias1)+AF1->AF1_ORCAME)

		//����������������������������������������������������Ŀ
		//�Limpa todos os itens da tabela oficial              �
		//������������������������������������������������������
		While (c_alias1)->(!EOF()) .and. (c_alias1)->&(c_alias1+'_ORCAME') = AF1->AF1_ORCAME
			RecLock(c_alias1, .F.)
			(c_alias1)->(Dbdelete())
			MsUnLock()
			(c_alias1)->(DbSkip()) 
		EndDo
		
		DbSelectArea(c_alias2)
		DbSetOrder(1)//
		If DbSeek(xFilial(c_alias2)+AF1->AF1_ORCAME+c_vers)
			While (c_alias2)->(!EOF()) .and. (c_alias2)->&(c_alias2+'_ORCAME') = AF1->AF1_ORCAME .and. (c_alias2)->&(c_alias2+"_XREV") = SZ2->Z2_NUMREV
				RecLock(c_alias1, .T.)
//				(c_alias1)->&(c_alias2+"_XREV") := SZ2->Z2_NUMREV
				DbSelectArea('SX3')
				DbSetOrder(1)
				If DbSeek(c_alias2)
					While SX3->X3_ARQUIVO = c_alias2
						If SX3->X3_TIPO <> 'M' .and. SX3->X3_Context <> 'V'
							(c_alias1)->&(c_alias1+substr(SX3->X3_CAMPO,4,16)) := (c_alias2)->&(SX3->X3_CAMPO)
						EndIf
						SX3->(DbSkip())
					EndDo
				EndIf	
				(c_alias1)->(MsUnLock())
				(c_alias2)->(DbSkip()) 
			EndDo
		EndIf
	Next

	msgAlert('Alteracao concluida com sucesso!!!', 'A T E N � � O')

Return


