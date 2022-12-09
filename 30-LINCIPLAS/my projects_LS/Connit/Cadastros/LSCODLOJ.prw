#Include "RwMake.ch"

/*
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������
�����������������������������������������������������������������������������ͻ��
���Programa  � LSCODLOJ � Autor �Eduardo Felipe da Silva � Data �  19/05/08   ��� 
���          �                   Ricardo Felipelli       � Data �  08/09/08   ��� 
�����������������������������������������������������������������������������͹��
���Descricao � Verifica se o Cliente/Fornecedor j� existe no cadastro.        ���
�����������������������������������������������������������������������������͹��
���Uso       � Laselva                                              	      ���
�����������������������������������������������������������������������������ͼ��
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������
*/

User Function LSCODLOJ(xAlias,xCodigo,xLoja,xCnpj,xBloq,xTipo)

Local cAlias	:= GetArea()
Local lRet 	   	:= .T.
Local cCnpj    	:= &(ReadVar())
Local cCodigo	:= &(xCodigo)
Local cLoja		:= "01"

If Len(Alltrim(cCnpj)) > 11
 	DbSelectArea(xAlias)                         
	DbSetOrder(1)
	If DbSeek(xFilial(xAlias)+cCodigo) 
		cCodigo := GetSxeNum((xAlias),&(xCodigo))                                                
		
		ConfirmSX8()
	EndIf 

	DbSetOrder(3)
	DbSeek(xFilial(xAlias)+Substr(cCnpj,1,8)) 
	While !Eof() .And. Substr(cCnpj,1,8) == Substr((xAlias)->&(xCnpj),1,8) .And. Len(cCnpj) > 11 
	
		If Len((xAlias)->&(xCnpj)) > 11 .and. (xAlias)->&(xCodigo) <> '999999' .and. (xAlias)->&(xBloq) <> '1'
			cCodigo :=  (xAlias)->&(xCodigo)
			If cLoja <= Soma1((xAlias)->&(xLoja),2)// .and. !(Soma1((xAlias)->&(xLoja),2) $ GetMv('LS_FILERRO'))
				cLoja	:=	Soma1((xAlias)->&(xLoja),2)
			EndIf
		EndIf
 		(xAlias)->(dbSkip())
	EndDo
EndIf
	     
If 	xTipo == 'A1_TIPO' .and. M->A1_TIPO == 'F' .and. !empty(M->A1_LOJA) .and. M->A1_PESSOA == 'J' .and. left(M->A1_CGC,8) $ GetMv('MV_LSVCNPJ') + GetMv('MV_CNPJCOL')
	If Posicione('SA1',9,M->A1_CGC + M->A1_LOJA,'A1_CGC') == M->A1_CGC 
		M->&(xCodigo) := '999999'
	Else
		MsgBox('Necess�rio cadastrar a loja para depois cadastrar o cliente padr�o da loja','ATEN��O!!!!','ALERT')
		cCnpj := ''
	EndIf
Else	

	M->&(xCodigo) := cCodigo
	M->&(xLoja)   := cLoja
EndIf

RestArea(cAlias)

Return(cCnpj)


