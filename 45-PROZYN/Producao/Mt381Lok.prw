#INCLUDE 'RWMAKE.CH'
#INCLUDE 'PROTHEUS.CH'

/*���������������������������������������������������������������������������
����������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao	 � MT381LOK   � Autor � Denis Varella     � Data � 12/08/2019 ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada que atualiza o lote de produtos ainda     ���
���Desc.     � n�o separados.                                             ���
���Desc.     �                                                            ���
���Desc.     �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Espec�fico para a empresa Prozyn               			  ���
������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/

User Function MT381LOK()
Local aArea := GetArea()
Local lRet	:= .T.

lRet := PermAtuEmp()

If lRet
	lRet := AtuLtNSep()
EndIf

RestArea(aArea)
Return lRet


/*���������������������������������������������������������������������������
����������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao	 � AtuLtNSep  � Autor � Denis Varella     � Data � 12/08/2019 ���
�������������������������������������������������������������������������͹��
���Desc.     � Atualiza lote de produtos no empenho ainda n�o separados	 ���
���Desc.     � 				                                             ���
���Desc.     �                                                            ���
���Desc.     �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Espec�fico para a empresa Prozyn               			  ���
������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
Static Function AtuLtNSep()

Local aArea := GetArea()
Local aOrdSep := {}
Local cOP :=  SD4->D4_OP

Local cProd := aCols[n][GDFieldPos("D4_COD")]
Local cLote	:= aCols[n][GDFieldPos("D4_LOTECTL")]
Local lRet	:= .T.
Local cCodUsr	:= Alltrim(RetCodUsr())
Local cCodUApv	:= U_MyNewSX6("CV_USALEMP", "000068"	,"C","Usuarios liberados a alterar empenho", "", "", .F. )
Local nOS		:= 0 

SD4->(DbSetOrder(1))
SD4->(DbSeek(xFilial("SD4")+cProd+cOP))

If Alltrim(SD4->D4_LOTECTL) != Alltrim(cLote) .And. !(Alltrim(cCodUsr) $ Alltrim(cCodUApv))
	
	//Busco as ordens de separa��o amarradas a esta OP
	DbSelectArea("SZT")
	DbSelectArea("CB8")
	
	SZT->(DbSetOrder(3))
	SZT->(DbGoTop())
	If SZT->(DbSeek(xFilial("SZT")+cOP))
		aAdd(aOrdSep,SZT->ZT_ORDSEP)  //Separa��o Inteira
		aAdd(aOrdSep,SZT->ZT_ORDSEP2) //Separa��o Fracionada
		aAdd(aOrdSep,SZT->ZT_ORDSEP3) //Aglutina��o de Fracionada
	EndIf
	
	For nOS := 1 to len(aOrdSep)
		CB8->(DbSetOrder(1))
		CB8->(DbGoTop())
		If CB8->(DbSeek(xFilial("CB8")+aOrdSep[nOS]))
			While CB8->(!EOF()) .AND. CB8->CB8_ORDSEP == aOrdSep[nOS] .AND. CB8->CB8_FILIAL == xFilial("CB8") .AND. lRet
				
				If CB8->CB8_PROD == cProd .AND. CB8->CB8_LOTECT == SD4->D4_LOTECTL
					If CB8->CB8_SALDOS != CB8->CB8_QTDORI
						Alert("A separa��o deste produto j� foi iniciada. Para altera��o ser� necess�rio realizar o estorno do processo.")
						aCols[n][GDFieldPos("D4_LOTECTL")] := SD4->D4_LOTECTL						
						lRet := .F.
					EndIf
				EndIf
				CB8->(DbSkip())
			EndDo
		EndIf
		
		
	Next nOS
	
EndIf

RestArea(aArea)
Return lRet


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT381LOK  �Autor  �Henio Brasil        � Data � 26/04/2018  ���
�������������������������������������������������������������������������͹��
���Descricao �Pto Entrada para validar o Ajuste de Empenho no Modelo 2    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Empresa   �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
����������������������������������������������������������������������������*/
Static Function PermAtuEmp() 

Local lReturn	:= .T.                                
Local aOpcMan	:= ParamIxb		// 1-Inclusao | 2-Alteracao 
Local cUserLog	:= RetCodUsr() // c�digo do usu�rio Logado.      
Local lDeleted 	:= GdDeleted()
Local cUserMov	:= SuperGetMv("NB_USRMTE", .F., "000000")   

/* 
������������������������������������������������������������������������Ŀ
�Valida se o usuario tem permissao para deletar a linha do empenho       �  
��������������������������������������������������������������������������*/
If !(cUserLog $ cUserMov) .And. lDeleted 
	MsgAlert("Caro usu�rio, voc� n�o tem permiss�o para excluir a linha do empenho! Contate o Administrador! ","Permiss�o de Usuario")  
	lReturn	:= .F. 
Endif
Return lReturn
