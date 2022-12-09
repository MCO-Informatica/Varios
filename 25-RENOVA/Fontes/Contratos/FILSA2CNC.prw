# include 'protheus.ch'
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FILSA2CNC º Autor ³ Jose Carlos        º Data ³  17/07/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Consulta Padrao Fornecedor X Contrato                      º±±
±±º          ³ Cadastro SZ7 campo Z7_FORNECE X3_F3 "SA2CNC"               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ RENOVA                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function FILSA2CNC()   
Local cQuery	:= ""
Local cAliasQry := GetNextAlias()
Local aItens	:= {} 
Local aTitulo	:= {}
Local lCancel	:= .T.
Local cCadastro	:= "Fornecedores" 
Local lRet		:= .F. 
Local aAreaAtu	:= GetArea()

cQuery := "SELECT A2_COD, A2_LOJA, A2_NOME "
cQuery += "FROM "+RetSqlName("SA2")+ " SA2, "+RetSqlName("CNC")+" CNC "
cQuery += " WHERE A2_FILIAL  = '"+xFilial("SA2")+"'"
cQuery += "   AND A2_COD = CNC_CODIGO "
cQuery += "   AND A2_LOJA = CNC_LOJA " 
cQuery += "   AND CNC_FILIAL = '"+xFilial("CNC")+"'" 
cQuery += "   AND CNC_NUMERO = '"+M->Z7_CONTRA+"' "
cQuery += "   AND CNC_REVISA = '"+M->Z7_REVISAO+"' "  
cQuery += "   AND SA2.D_E_L_E_T_  = ' ' " 
cQuery += "   AND CNC.D_E_L_E_T_  = ' ' "
cQuery := ChangeQuery( cQuery )

dbUseArea( .T., "TOPCONN", TcGenQry( , , cQuery ), cAliasQry, .F., .T. )
DbSelectArea(cAliasQry)
(cAliasQry)->(DbGoTop())

While (cAliasQry)->(!Eof())
    Aadd(aItens,{ (cAliasQry)->A2_COD, (cAliasQry)->A2_LOJA, (cAliasQry)->A2_NOME })
    (cAliasQry)->(dbSkip())
EndDo

(cAliasQry)->(DbCloseArea())  

If Len(aItens) > 0
     Aadd( aTitulo, "Código" )
     Aadd( aTitulo, "Loja" )
     Aadd( aTitulo, "Nome" )

     aCabec := aClone(aTitulo)

     nRet := TmsF3Array( aTitulo, aItens, cCadastro, lCancel, /*aNewButton*/ , aCabec )
     
	If nRet > 0
		//-- VAR_IXB: Variavel publica utilizada como retorno da consulta F3
		VAR_IXB := aItens[ nRet, 1 ] + aItens[ nRet, 2 ]
		lRet    := .T.
	Else
		lRet := .F.
	EndIF
Else
	Help( "",1,"HELP","FILSA2CNC","Nao existem dados para a consulta",1,0)
	lRet := .F.
EndIf

RestArea(aAreaAtu)
Return(lRet)    


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VldForContrPA º Autor ³ Jose Carlos    º Data ³  17/07/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Validacao digitacao fornecedor                             º±±
±±º          ³ Cadastro SZ7 campo Z7_FORNECE X3_VALIDUSR                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ RENOVA                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function VldForContrPA()
Local lRetorno	:= .F.
Local aAreaAtu	:= GetArea()  
   
DbSelectArea("SA2")
SA2->(DbSetOrder(1))

//Correção para gatilhar corretamente a loja do fornecedor
If SA2->( DbSeek(xFilial('SA2')+M->Z7_FORNECE+	M->Z7_LOJA ) )
   //	M->Z7_LOJA	:= SA2->A2_LOJA
	lRetorno := .T.
EndIF

If lRetorno .And. !Empty(M->Z7_CONTRA)
	DbSelectArea('CNC')
	CNC->(DbSetOrder(1))
	
	lRetorno := CNC->( DbSeek(xFilial("CNC") +M->Z7_CONTRA+M->Z7_REVISAO+M->Z7_FORNECE+M->Z7_LOJA) )  
	
	If !lRetorno
		Help( "",1,"HELP","VldForContrPA","Fornecedor não localizado no Contrato.",1,0)	
	EndIf
EndIf

RestArea( aAreaAtu )
Return(lRetorno)