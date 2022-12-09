#Include "RwMake.ch"
/*/
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    � RGCTA05  � Autor � TOTVS                 � Data � 20/10/08 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Geracao do codigo inteligente para Contratos               ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Uso       � DIEDRO 	                                                  ���
�������������������������������������������������������������������������Ĵ��
���Obs.      � Gatilho        : CN9_                                      ���      
���          � Contra Dominio : CN9_                                      ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function RGCTA05()
*
Local aArea  := GetArea()
Local cArea  := M->CN9_XTIPO  
Local cGrupo :=STRZERO(YEAR(M->CN9_DTINIC),4)
Local cCodNew := Alltrim(cArea) + Alltrim(cGrupo) + "00001"
*
IF Inclui
   	If Empty(cArea)
		M->CN9_DTINIC   := SPACE(Len(M->CN9_DTINIC))
		cCodNew := SPACE(Len(M->CN9_NUMERO))
	Endif                                                             
	*                                                                        
	dbSelectArea("CN9")
	dbSetOrder(1)
	While .T.
		IF !MsSeek(xFilial("CN9")+cCodNew)
			Exit
		Endif
//		cCodNew := Subs(cCodNew,1,9)+SOMA1(Right(cCodNew,5)) Romay 24-07-2015
	cCodNew := Subs(cCodNew,1,len(cCodNew)-5)+SOMA1(Right(cCodNew,5)) //Romay 24-07-2015
	Enddo
	*
Else
	cCodNew := M->CN9_NUMERO
Endif
RestArea(aArea)
Return(cCodNew)