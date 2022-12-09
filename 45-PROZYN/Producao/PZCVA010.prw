#include 'protheus.ch'
#include 'parmtype.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PZCVA010 ºAutor  ³Microsiga 	          º Data ³ 17/03/20   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Copia de produto 											  º±±
±±º          ³												    		  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³			                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function PZCVA010()

	Local aArea	:= GetArea()
	
	If Aviso("Atenção","Confirma a cópia do produto ("+Alltrim(SB1->B1_COD)+") ?",{"Sim","Não"},2) == 1
		MsgRun( "Aguarde...",, { || ProcCopia(SB1->B1_COD) } )
	EndIf
	
	RestArea(aArea)	
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ProcCopia ºAutor  ³Microsiga 	          º Data ³ 17/03/20   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Copia de produto 											  º±±
±±º          ³												    		  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³			                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ProcCopia(cCodProd)

	Local aArea			:= GetArea()
	Local cComplCopia	:= U_MyNewSX6("CV_CPCDPRD", "R"	,"C","Complemento do codigo do produto de reprocesso", "", "", .F. ) 
	Local cCodCpia		:= ""
	Local nOpc			:= 0
	
	Default cCodProd	:= ""

	//Codigo do produto de reprocesso
	cCodCpia := Alltrim(cCodProd)+Alltrim(cComplCopia)

	If VldProdCp(cCodProd, cCodCpia)//Validação antes de realizar a copia

		DbSelectArea("SB1")
		DbSetOrder(1)
		If SB1->(DbSeek(xFilial("SB1") + PadR(cCodProd,TAMSX3("B1_COD")[1])))

			//Grava os dados na tabela SB1
			GrvSb1Sb5(cCodProd, cCodCpia)
			
			If SB1->(DbSeek(xFilial("SB1") + PadR(cCodCpia,TAMSX3("B1_COD")[1])))
				
				nOpc := Aviso("Exito","Produto copiado com sucesso.  ",{"Visualizar","Alterar","Sair"},2)
				If nOpc==1
					A010Visul("SB1",SB1->(Recno()),2)
				ElseIf nOpc==2
					A010ALTERA("SB1",SB1->(Recno()),2)
				EndIf
			Else
				Aviso("Atenção","Não foi possível realizar a cópia do produto, por gentileza, entre em contato com o Administrador.",{"Ok"},2)
			EndIf
		Else	
			Aviso("Atenção","Produto origem ("+Alltrim(cCodProd)+") não encontrado.",{"Ok"},2)
		EndIf

	EndIf	

	RestArea(aArea)	
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VldProdCp ºAutor  ³Microsiga 	          º Data ³ 17/03/20   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Validação do produto na copia								  º±±
±±º          ³												    		  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³			                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function VldProdCp(cCodProd, cCodCpia)

	Local aArea		:= GetArea()
	Local lRet		:= .T.
	Local cMsgErr	:= ""
	Local cTpLib	:= U_MyNewSX6("CV_TPCOPY", "PA|PI"	,"C","Tipos liberados para copias de reprocesso", "", "", .F. )

	Default cCodCpia	:= ""

	DbSelectArea("SB1")
	DbSetOrder(1)
	If SB1->(DbSeek(xFilial("SB1") + PadR(cCodProd,TAMSX3("B1_COD")[1]))) .And. !(Alltrim(SB1->B1_TIPO) $ Alltrim(cTpLib))
		cMsgErr += "-Copia permitida somente para produtos do tipo: "+Alltrim(cTpLib)+CRLF
		lRet	:= .F.
	EndIf
	
	
	//Verifica se o produto se existe cadastro do produto de reprocesso
	DbSelectArea("SB1")
	DbSetOrder(1)
	If SB1->(DbSeek(xFilial("SB1") + PadR(cCodCpia,TAMSX3("B1_COD")[1])))
		cMsgErr += "-Produto já cadastrado anteriormente ("+Alltrim(cCodCpia)+");"+CRLF
		lRet	:= .F.
	EndIf

	//Verifica se o produto é reprocesso
	If SubStr(Alltrim(cCodProd),Len(Alltrim(cCodProd)),1) == "R"
		cMsgErr += "-Não é permitida a cópia de reprocesso;"+CRLF
		lRet	:= .F.
	EndIf

	If !lRet
		Aviso("Validação",cMsgErr,{"Ok"},2)
	EndIf

	RestArea(aArea)
Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GrvSb1	 ºAutor  ³Microsiga	          º Data ³ 17/03/20   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Grava os dados da tabela SB1								  º±±
±±º          ³												    		  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³			                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GrvSb1Sb5(cCodProd, cCodCpia)

	Local aArea		:= GetArea()
	Local cQuery	:= ""
	Local cArqTmp	:= GetNextAlias()
	Local nX		:= 0
	Local aCpoB1Aux := {}
	Local aCamposB1	:= {}

	Default cCodProd	:= "" 
	Default cCodCpia	:= ""

	cQuery	:= " SELECT * FROM "+RetSqlName("SB1")+" SB1 "+CRLF

	cQuery += " LEFT JOIN "+RetSqlName("SB5")+" SB5 "+CRLF
	cQuery += " ON SB5.B5_FILIAL = SB1.B1_FILIAL "+CRLF
	cQuery += " AND SB5.B5_COD = SB1.B1_COD "+CRLF	
	cQuery += " AND SB5.D_E_L_E_T_ = ' ' "+CRLF 

	cQuery	+= " WHERE SB1.B1_FILIAL= '"+xFilial("SB1")+"' "+CRLF
	cQuery	+= " AND SB1.B1_COD = '"+cCodProd+"' "+CRLF 
	cQuery	+= " AND SB1.D_E_L_E_T_ = ' ' "+CRLF

	DbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQuery) , cArqTmp,.T.,.T.)
	aEval( SB5->(dbStruct()),{|x| If(x[2]!="C", TcSetField(cArqTmp,AllTrim(x[1]),x[2],x[3],x[4]),Nil)})
	aEval( SB1->(dbStruct()),{|x| If(x[2]!="C", TcSetField(cArqTmp,AllTrim(x[1]),x[2],x[3],x[4]),Nil)})



	//Preenche o array com os campos da tabela SB1
	aCpoB1Aux := {}
	For nX := 1 TO FCount()
		If (SubStr(FieldName(nX),1,2) == "B1")
			AADD(aCpoB1Aux,FieldName(nX))
		EndIf
	Next 
	//Campos Base de Dados x SX3 (Tabela SB1)
	aCamposB1 := GetCpoAuto(aCpoB1Aux, "SB1")

//B1_COMOD ='N'
	//Preenche o array com os campos da tabela SB5
	aCpoB1Aux := {}
	For nX := 1 TO FCount()
		If (SubStr(FieldName(nX),1,2) == "B5")
			AADD(aCpoB1Aux,FieldName(nX))
		EndIf
	Next 
	//Campos Base de Dados x SX3 (Tabela SB1)
	aCamposB5 := GetCpoAuto(aCpoB1Aux, "SB5")


	//Grava os dados da tabela SB1
	RecLock("SB1",.T.)       

	//Preenche os campos do produto
	For nX := 1 To Len(aCamposB1)
		If Alltrim(aCamposB1[nX]) == "B1_COD"//Codigo do produto
			SB1->&(aCamposB1[nX]) := Alltrim(cCodCpia)
		Else                        
			If !Empty((cArqTmp)->&(aCamposB1[nX]))
				SB1->&(aCamposB1[nX]) := (cArqTmp)->&(aCamposB1[nX])
			EndIf
		EndIf

	Next                       
	SB1->(MsUnLock())    



	//Grava os dados da tabela SB5
	RecLock("SB5",.T.)       

	//Preenche os campos do produto
	For nX := 1 To Len(aCamposB5)
		If Alltrim(aCamposB5[nX]) == "B5_COD"//Codigo do produto
			SB5->&(aCamposB5[nX]) := Alltrim(cCodCpia)
		Else                        
			If !Empty((cArqTmp)->&(aCamposB5[nX]))
				SB5->&(aCamposB5[nX]) := (cArqTmp)->&(aCamposB5[nX])
			EndIf
		EndIf

	Next                       
	SB5->(MsUnLock())  

	If Select(cArqTmp) > 0
		(cArqTmp)->(DbCloseArea())
	EndIf

	RestArea(aArea)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GetCpoAuto ºAutor  ³Microsiga	          º Data ³ 17/03/20   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Retorna os campos da tabela com base no SX3				  º±±
±±º          ³												    		  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³			                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GetCpoAuto(aCpo, cTbSx3)

	Local aArea 	:= GetArea()
	Local aCpoB1SX3	:= {}
	Local aRet		:= {}
	Local nX		:= 0
	Local nY		:= 0

	Default aCpo	:= {} 
	Default cTbSx3	:= ""

	aCpoB1SX3	:= GetCpoSx3(cTbSx3)//Campos do SX3

	For nX := 1 To Len(aCpoB1SX3)

		For nY := 1 To Len(aCpo)
			If Alltrim(aCpo[nY]) == Alltrim(aCpoB1SX3[nX])
				Aadd(aRet, aCpoB1SX3[nX])	
				Exit
			EndIf
		Next

	Next 

	RestArea(aArea)
Return aRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GetCpoSx3 ºAutor  ³Microsiga	          º Data ³ 17/03/20   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Retorna os campos da tabela com base no SX3				  º±±
±±º          ³												    		  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³			                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GetCpoSx3(cAliasTb)

	Local aArea := GetArea()
	Local aRet	:= {}

	Default cAliasTb := ""

	If !Empty(cAliasTb)
		DbSelectArea("SX3")
		DbSetOrder(1)

		If SX3->(DbSeek(cAliasTb))//VERIFICA SE O ALIAS EXISTE

			While SX3->(!Eof()) .And. (Alltrim(SX3->X3_ARQUIVO) == Alltrim(cAliasTb))

				//Adiciona apenas campos reais 			
				If UPPER(Alltrim(SX3->X3_CONTEXT)) != 'V'
					Aadd(aRet,Alltrim(SX3->X3_CAMPO))
				EndIf

				SX3->(DbSkip())
			EndDo

		EndIf


	EndIf
	RestArea(aArea)
Return aRet

