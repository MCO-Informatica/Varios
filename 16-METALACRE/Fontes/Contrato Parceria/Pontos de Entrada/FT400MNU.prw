#Include "RWMAKE.CH"
#Include "TOPCONN.CH" 
#Include "Protheus.Ch"
#INCLUDE 'COLORS.CH'

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � FT400MNU | Autor � Luiz Alberto        � Data � 30/04/15 ���
�������������������������������������������������������������������������Ĵ��
���Objetivo  � Ponto de Entrada Adicionar Op�ao Para Libera��o de Contrato
				de Parceria pelos Supervisores de Vendas
�������������������������������������������������������������������������Ĵ��
���Uso       � METALACRE                                        ���
��                                                                        ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function FT400MNU()                               
Local aArea := GetArea()

nAchou := Ascan(aRotina,{|x| 'Provar'$x[1]})
If nAchou > 0
	aRotina[nAchou,2]	:= "U_LibCtr()"
Else
	AADD(aRotina,{ "Libera Contrato","U_LibCtr()",0,6,0,NIL})
Endif

AADD(aRotina,{ "Rastro Contrato","U_RastroCtr()",0,6,0,NIL})

RestArea(aArea)
Return .t.


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � LibCtr | Autor � Luiz Alberto        � Data � 30/04/15 ���
�������������������������������������������������������������������������Ĵ��
���Objetivo  � Fun��o para a Libera��o de Contratos de Parceria
				Bloqueados Ap�s Inclus�o, apenas por usu�rios
				que seus respectivos ID�s constem no parametro
				MV_USLBCTR Usuarios Responsaveis pela libera��o de contratos
							de Parceria
�������������������������������������������������������������������������Ĵ��
���Uso       � METALACRE                                        ���
��                                                                        ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function LibCtr()                               
Local aArea 	:= 	GetArea()
Local cLibUser  :=	GetNewPar('MV_USLBCTR','000000*000001*000020*000033*000194*000012')

If ADA->ADA_STATUS <> 'X'
	MsgStop("Aten��o Apenas Contratos Bloqueados Poder�o Ser Liberados !")
	RestArea(aArea)
	Return .f.     
Endif                  

If !__cUserId$cLibUser
	MsgStop("Aten��o Usu�rio N�o Autorizado a Efetuar Libera��o de Contratos de Parcerias !")
	RestArea(aArea)
	Return .f.     
Endif                  

If MsgYesNo("Confirma a Libera��o do Contrato de Parceria - No. " + ADA->ADA_NUMCTR + " ?") 
	If RecLock("ADA",.f.)
		ADA->ADA_STATUS := 'B'
		ADA->(MsUnlock())
	Endif
Endif

RestArea(aArea)
Return .t.
	

