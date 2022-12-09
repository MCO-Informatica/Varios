#Include "RwMake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ LSCODLOJ º Autor ³Eduardo Felipe da Silva º Data ³  19/05/08   º±± 
±±º          ³                   Ricardo Felipelli       º Data ³  08/09/08   º±± 
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Verifica se o Cliente/Fornecedor já existe no cadastro.        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laselva                                              	      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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
		MsgBox('Necessário cadastrar a loja para depois cadastrar o cliente padrão da loja','ATENÇÃO!!!!','ALERT')
		cCnpj := ''
	EndIf
Else	

	M->&(xCodigo) := cCodigo
	M->&(xLoja)   := cLoja
EndIf

RestArea(cAlias)

Return(cCnpj)


