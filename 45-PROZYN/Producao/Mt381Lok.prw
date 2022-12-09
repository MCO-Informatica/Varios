#INCLUDE 'RWMAKE.CH'
#INCLUDE 'PROTHEUS.CH'

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFuncao	 ณ MT381LOK   ณ Autor ณ Denis Varella     ณ Data ณ 12/08/2019 ณฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Ponto de entrada que atualiza o lote de produtos ainda     บฑฑ
ฑฑบDesc.     ณ nใo separados.                                             บฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especํfico para a empresa Prozyn               			  บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

User Function MT381LOK()
Local aArea := GetArea()
Local lRet	:= .T.

lRet := PermAtuEmp()

If lRet
	lRet := AtuLtNSep()
EndIf

RestArea(aArea)
Return lRet


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFuncao	 ณ AtuLtNSep  ณ Autor ณ Denis Varella     ณ Data ณ 12/08/2019 ณฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Atualiza lote de produtos no empenho ainda nใo separados	 บฑฑ
ฑฑบDesc.     ณ 				                                             บฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especํfico para a empresa Prozyn               			  บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
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
	
	//Busco as ordens de separa็ใo amarradas a esta OP
	DbSelectArea("SZT")
	DbSelectArea("CB8")
	
	SZT->(DbSetOrder(3))
	SZT->(DbGoTop())
	If SZT->(DbSeek(xFilial("SZT")+cOP))
		aAdd(aOrdSep,SZT->ZT_ORDSEP)  //Separa็ใo Inteira
		aAdd(aOrdSep,SZT->ZT_ORDSEP2) //Separa็ใo Fracionada
		aAdd(aOrdSep,SZT->ZT_ORDSEP3) //Aglutina็ใo de Fracionada
	EndIf
	
	For nOS := 1 to len(aOrdSep)
		CB8->(DbSetOrder(1))
		CB8->(DbGoTop())
		If CB8->(DbSeek(xFilial("CB8")+aOrdSep[nOS]))
			While CB8->(!EOF()) .AND. CB8->CB8_ORDSEP == aOrdSep[nOS] .AND. CB8->CB8_FILIAL == xFilial("CB8") .AND. lRet
				
				If CB8->CB8_PROD == cProd .AND. CB8->CB8_LOTECT == SD4->D4_LOTECTL
					If CB8->CB8_SALDOS != CB8->CB8_QTDORI
						Alert("A separa็ใo deste produto jแ foi iniciada. Para altera็ใo serแ necessแrio realizar o estorno do processo.")
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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออัอออออออัออออออออออออออออออออัออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMT381LOK  ณAutor  ณHenio Brasil        ณ Data ณ 26/04/2018  บฑฑ
ฑฑฬออออออออออุออออออออออฯอออออออฯออออออออออออออออออออฯออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณPto Entrada para validar o Ajuste de Empenho no Modelo 2    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบEmpresa   ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function PermAtuEmp() 

Local lReturn	:= .T.                                
Local aOpcMan	:= ParamIxb		// 1-Inclusao | 2-Alteracao 
Local cUserLog	:= RetCodUsr() // c๓digo do usuแrio Logado.      
Local lDeleted 	:= GdDeleted()
Local cUserMov	:= SuperGetMv("NB_USRMTE", .F., "000000")   

/* 
ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
ณValida se o usuario tem permissao para deletar a linha do empenho       ณ  
ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู*/
If !(cUserLog $ cUserMov) .And. lDeleted 
	MsgAlert("Caro usuแrio, voc๊ nใo tem permissใo para excluir a linha do empenho! Contate o Administrador! ","Permissใo de Usuario")  
	lReturn	:= .F. 
Endif
Return lReturn
