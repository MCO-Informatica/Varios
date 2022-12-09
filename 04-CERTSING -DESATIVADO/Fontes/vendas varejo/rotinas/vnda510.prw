#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VNDA510   �Autor  �Opvs (David)        � Data �  06/02/13   ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina de Consulta e sele��o de campos no SX3         ���
���          �                                                            ���
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function VNDA510(cCodAlias)
Local aArea		:= GetArea()
Local cTitDlg		:= "Sele��o de Dados de Dicion�rio"
Local cReturn	:= ""	
Local aDadSel	:= {}
Local cDadRet	:= ""
Local cIniAlias	:= ""

Default cCodAlias := ""

//Verifica se foi informado alias de procura
If !Empty(cCodAlias)
	DbSelectArea("SX3")
	SX3->(DbSetOrder(1))
	
	If SX3->(DbSeek(cCodAlias)) 
		CursorWait()
 		//Alimenta array de dados a serem mostrados na tela
 		While !SX3->(EoF()) .and.  SX3->X3_ARQUIVO == cCodAlias
   			AADD(aDadSel,SX3->X3_CAMPO + "-"+SX3->X3_TITULO+": "+SX3->X3_DESCRIC)			
   			cDadRet	+= SX3->X3_CAMPO 
   			SX3->(DbSkip())	
   		EndDo
   		CursorArrow()
   		
   		//executa fun��o de tela de multi-sele��o de dados
   		f_opcoes(@cReturn,cTitDlg,aDadSel,cDadRet,Nil,Nil,.F.,10,len(aDadSel))
   		
   		//tratamento de retorno da fun�ao
   		cReturn := StrTran(cReturn,"*","")
   		cIniAlias:= Alltrim(SubStr(cReturn,1,At("_",cReturn)))
		//insere no retorno separadores de ","
		If !Empty(cIniAlias)
			cReturn := StrTran(cReturn,cIniAlias,","+cIniAlias)
			cReturn := IIf(SubStr(cReturn,1,1) == ",", SubStr(cReturn,2),cReturn)
		EndIf
   		
 	Else
 		MsgAlert("N�o foi informado Alias v�lido para pesquisa de Sele��o de Dados")
 	EndIf
	
Else
	MsgAlert("N�o foi informado Alias para Sele��o de Dados")
EndIf

RestArea(aArea)

Return(cReturn)