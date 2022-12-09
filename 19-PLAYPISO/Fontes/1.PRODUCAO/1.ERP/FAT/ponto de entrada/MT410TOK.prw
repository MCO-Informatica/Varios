#Include "PROTHEUS.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT410TOK  �Autor  �Alexandre Sousa     � Data �  10/22/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �P.E. durante o OK do pedido de vendas. Utilizado para gravar���
���          �o log do pedido e validar os valores do centro de custo.    ���
�������������������������������������������������������������������������͹��
���Uso       �Especifico LISONDA.                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MT410TOK()
    
	Local n_x := 0
	Local n_positm := aScan(aHeader, {|x| AllTrim(x[2])=="C6_ITEM"})
	Local n_posent := aScan(aHeader, {|x| AllTrim(x[2])=="C6_ENTREG"})
	Local n_posvlr := aScan(aHeader, {|x| AllTrim(x[2])=="C6_VALOR"})
	
	//���������������������������������������������������������������������������������������������������������Ŀ
	//�Validacao do LOG de alteracao de data e valor                                                            �
	//�����������������������������������������������������������������������������������������������������������
	For n_x := 1 to len(acols)
		If !aCols[n_x, len(aHeader)+1]
			DbSelectArea('SZ4')
			DbSetOrder(1) //Z4_FILIAL, Z4_PEDIDO, Z4_ITEM, R_E_C_N_O_, D_E_L_E_T_
			If DbSeek(xFilial('SZ4')+M->C5_NUM+aCols[n_x, n_positm])
				n_valor := SZ4->Z4_VALOR
				d_data	:= SZ4->Z4_ENTREG
				While SZ4->(!EOF()) .and. M->C5_NUM+aCols[n_x, n_positm] = SZ4->(Z4_PEDIDO+Z4_ITEM)
					n_valor := SZ4->Z4_VALOR
					d_data	:= SZ4->Z4_ENTREG
					SZ4->(DbSkip())
				EndDo
				If aCols[n_x, n_posent] <> d_data .or. aCols[n_x, n_posvlr] <> n_valor
					RecLock('SZ4', .T.)
					SZ4->Z4_FILIAL	:= xFilial('SZ4')
					SZ4->Z4_PEDIDO	:= M->C5_NUM
					SZ4->Z4_ITEM	:= aCols[n_x, n_positm]
					SZ4->Z4_VALOR	:= aCols[n_x, n_posvlr]
					SZ4->Z4_ENTREG	:= aCols[n_x, n_posent]
					SZ4->Z4_CODUSR	:= __cuserid
					SZ4->Z4_USUARIO	:= cusername
					SZ4->Z4_DATA	:= dDataBase
					SZ4->Z4_HORA	:= TIME()
//					SZ4->Z4_MOT		:= ''
					MsUnLock()
				EndIf
			Else
				RecLock('SZ4', .T.)
				SZ4->Z4_FILIAL	:= xFilial('SZ4')
				SZ4->Z4_PEDIDO	:= M->C5_NUM
				SZ4->Z4_ITEM	:= aCols[n_x, n_positm]
				SZ4->Z4_VALOR	:= aCols[n_x, n_posvlr]
				SZ4->Z4_ENTREG	:= aCols[n_x, n_posent]
				SZ4->Z4_CODUSR	:= __cuserid
				SZ4->Z4_USUARIO	:= cusername
				SZ4->Z4_DATA	:= dDataBase
				SZ4->Z4_HORA	:= TIME()
				SZ4->Z4_MOT		:= ''
				MsUnLock()
			EndIf
		EndIf
	Next

	//���������������������������������������������������������������������������������������������������������Ŀ
	//�Validacao do valor do centro de CUSTO.                                                                   �
	//�����������������������������������������������������������������������������������������������������������
	If M->C5_XPEDFIN = 'N'
		Return .T.
	EndIf
	
	DbSelectArea('CTT')                                                  
	DbSetOrder(1) //CTT_FILIAL, CTT_CUSTO, R_E_C_N_O_, D_E_L_E_T_ 
	n_valped := 0
	If DbSeek(xFilial('CTT')+M->C5_CCUSTO)
		For n_x := 1 to len(acols)
			n_valped += aCols[n_x, n_posvlr]
		Next
		
//		DbSelectArea('SC5')
//		DbSetOrder(5) //C5_FILIAL, C5_CCUSTO, R_E_C_N_O_, D_E_L_E_T_
//		DbSeek(xFilial('SC5')+)
		
		
		If n_valped > CTT->CTT_XVLR .and. __cuserid <> '000000'
				msgalert('O limite de valor para esse centro de custo j� foi ultrapassado. Solicite permissao ao Administrador?', 'A T E N � � O')
				Return .F.
//			If !msgYesNo('O limite de valor para esse centro de custo j� foi ultrapassado. Deseja informar a senha de administrador para prosseguir?', 'A T E N � � O')
//				Return .F.
//			Else
//				aSenha := aClone( A410Senha(.T.) )
//				
//				// Posiciona na senha digitada
//				If aConfig()[4]
//				
//					PswOrder( 2 )
//					If PswSeek(aSenha[1])	//usuario
//						lRet := PswName( aSenha[2] )	//senha
//					Else
//						lRet := .F.
//					EndIf
//				Else
//					PswOrder( 3 )
//					lRet := PswSeek(aSenha[2])	//senha
//				EndIf
					                          
				// Se encontrou o usuario verifica se eh de um nivel acima
//				If lRet
//					aRetUsr		:= PswRet()
//					If aRetUsr[1][1] $ '000000'
//						Return .T.
//					Else
///						msgAlert('Usuario n�o autorizado!', 'A T E N � � O')
//						Return .F.
//					Endif	
//				Else
//					msgAlert('Usuario ou senha incorreta!', 'A T E N � � O')
//					Return .F.
//				EndIf
	
//			EndIf
		EndIf
	EndIf
	
Return .T.
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � A410GetSenha � Autor � Gustavo Henrique  � Data � 11/09/02 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Monta dialogo para o usuario informar a senha              ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe e � A410GetSenha()                                             ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Solicitacao de Requerimentos                               ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function A410Senha()
Local oDlgSenha
Local oGetSenha
Local oGetUsu
Local aRet := {}
Local cUsu := Space(15)
Local cSen := Space(10)

// Autoriza��o
DEFINE DIALOG oDlgSenha Of GetWndDefault() TITLE "Autoriza��o" FROM 12, 30 TO 20,55

@ .5,1 SAY "Usu�rio"
@ 1.1,1 MSGET oGetUsu VAR cUsu WHEN aConfig()[4]

@ 2,1 SAY "Senha:"
@ 2.6,1 MSGET oGetSenha VAR cSen PASSWORD

DEFINE SBUTTON FROM 45,65 TYPE 1 ACTION oDlgSenha:End() ENABLE OF oDlgSenha

ACTIVATE MSDIALOG oDlgSenha CENTERED

AAdd( aRet, PadR( cUsu, 15 ) )
AAdd( aRet, PadR( cSen, 06 ) )

Return aRet

