/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RFATE004    º Autor ³ Adriano Leonardo  º Data ³  26/05/15 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Função resposável por criar tela de markbrowse para seleçãoº±±
±±º          ³ dos tipos de produtos que deverão ser considerados no catá-º±±
±±º          ³ logo.                                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Específico para a empresa LDI                			  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function RFATE004()
	
	Private _cAlias 	:= GetNextAlias()
	Private _cTabTmp2 	:= GetNextAlias()
	Private _cTabTmp3 	:= GetNextAlias()
	Private _cTabTmp4 	:= GetNextAlias()
	Private _cTabTmp5 	:= GetNextAlias()
	Private _cSZ8Tmp 	:= GetNextAlias()
	Private _cSZ1Tmp 	:= GetNextAlias()
	Private _cSB1Tmp 	:= GetNextAlias()
	Private _cSBMTmp 	:= GetNextAlias()
	Private _cSZ5Tmp 	:= GetNextAlias()
	Private _cTabTmp 	:= GetNextAlias()
	Private _cQryTmp
	Private cMarca2   	:= GetMark()
	Private cCadastro	:= "Selecione os tipos de produto a serem impressos"
	Private _cTipos		:= ""
	Private _cProduto	:= RTRIM(SB1->B1_COD)
	
	
	
	//Funções chamadas na tela do markbrowse
	Private aRotina 	:= {{"&Confirmar"	, "U_RESTR48C()",0,1},;
							{"In&verter"	, "U_RESTR48D()",0,1} }
	
	Private bMark2    	:= {|| MarkSel2()}
	
	_aCpoTmp2 := {} // Campos que serao exibidos no MarkBrowse
	
	AADD(_aCpoTmp2,{"TC_OK"		," "," "				})
	AADD(_aCpoTmp2,{"TC_CODESP"	," ","Codigo Especifico"})
	AADD(_aCpoTmp2,{"TC_COD"	," ","Codigo"			})
	AADD(_aCpoTmp2,{"TC_DESC"	," ","Descrição" 		})
	
	_aEstru2 := {} // Estrutura do Arquivo Temporario
	
	AADD(_aEstru2,{"TC_OK"			, "C",02,0})
	AADD(_aEstru2,{"TC_CODESP"		, "C",06,0})
	AADD(_aEstru2,{"TC_COD"			, "C",06,0})
	AADD(_aEstru2,{"TC_DESC"		, "C",200,0})
	
	_cArq := CriaTrab(_aCpoTmp2,.F.) //Nome do arquivo temporário
	DbCreate(_cArq,_aEstru2)
	DbUseArea(.T.,,_cArq,_cTabTmp,.F.)
	
	//Consulta no banco de dados para seleção dos tipos de produtos que serão considerados no relatório
	_cQryTmp := "SELECT CASE WHEN(SELECT COUNT(*) FROM " + RetSqlName("SZ8") + " SZ8 " + " WHERE SZ8.D_E_L_E_T_='' "
	_cQryTmp += "AND SZ8.Z8_FILIAL='" + xFilial("SZ8") + "' "
	_cQryTmp += "AND Z8_CODFRA=SZ7.Z7_COD "
	_cQryTmp += "AND SZ8.Z8_CODPRO='"+SB1->B1_COD+"')>0 THEN '"+cMarca2+"' ELSE '' END Z7_MARK, "
	_cQryTmp += "Z7_CODESP, "
	_cQryTmp += "Z7_COD, "
	_cQryTmp += "Z7_DESC "                                                         
	_cQryTmp += "FROM " + RetSqlName("SZ7") + " SZ7 "
	_cQryTmp += "WHERE SZ7.D_E_L_E_T_='' "
	_cQryTmp += "AND SZ7.Z7_FILIAL='" + xFilial("SZ7") + "' "
	_cQryTmp += "ORDER BY 1 DESC, Z7_COD ASC "
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQryTmp),_cSZ8Tmp,.F.,.T.)
	          
	dbSelectArea(_cSZ8Tmp)
	dbGoTop()
	
	While (_cSZ8Tmp)->(!EOF())
	
		dbSelectArea(_cTabTmp)
		
		//Preencho a tabela temporária com o resultado da query
		RecLock(_cTabTmp,.T.)
			(_cTabTmp)->TC_OK 		:= (_cSZ8Tmp)->Z7_MARK
			(_cTabTmp)->TC_CODESP  	:= (_cSZ8Tmp)->Z7_CODESP
			(_cTabTmp)->TC_COD	 	:= (_cSZ8Tmp)->Z7_COD
			(_cTabTmp)->TC_DESC 	:= (_cSZ8Tmp)->Z7_DESC			
	   		(_cTabTmp)->(MsUnlock())                        
		
		dbSelectArea(_cSZ8Tmp)
		dbSkip()
	EndDo
	
	//Crio tela para marcação dos itens a serem impressos, dentro do intervalo de parâmetros definidos pelo usuário
	MarkBrowse(_cTabTmp,"TC_OK",,_aCpoTmp2,,cMarca2,"U_RESTR48C()",,,,"eval(bMark2)")
	
Return() 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RESTR048    º Autor ³ Adriano Leonardo  º Data ³  26/05/15 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Função resposável por marcar os tipos de produtos selecio- º±±
±±º          ³ nados pelo usuário para impressão do catálogo.             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Específico para a empresa LDI                			  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function MarkSel2()
	
	Local lDesmarc := IsMark("TC_OK", cMarca2, .T.)
	
	If !Empty((_cTabTmp)->TC_OK)
	   DbSelectArea(_cTabTmp)
	   
	   RecLock(_cTabTmp,.F.)
		   Replace TC_OK With Space(2)
		   
		   _cTipos := StrTran(_cTipos,";"+(_cTabTmp)->TC_COD+""	,"")
	   	   _cTipos := StrTran(_cTipos,"" +(_cTabTmp)->TC_COD+""	,"")
			If SubStr(AllTrim(_cTipos),1,1)==";"
				_cTipos := SubStr(AllTrim(_cTipos),2,Len(AllTrim(_cTipos)))
			EndIf
			
	   MsUnlock()
	Else
	   DbSelectArea(_cTabTmp)
	   
	   RecLock(_cTabTmp,.F.)
		   Replace TC_OK With cMarca2
		   _cTipos += IIF(Empty(_cTipos),""+(_cTabTmp)->TC_COD+"",";" + (_cTabTmp)->TC_COD+"")
	   MsUnlock()
	EndIf            
	
	
Return()

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RESTR048    º Autor ³ Adriano Leonardo  º Data ³  26/05/15 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Confirma seleção dos tipos de produtos (markbrowse).       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Específico para a empresa LDI                			  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function RESTR48C()

	Local _nCont	:= 0
	_lRestr048 := .T.
	
	_aAux := Separa(_cTipos,";")
	
	DbSelectArea("SZ8")
	DbSetOrder(2) //filial+codproduto
	dbGoTop()
	If Dbseek(xFilial("SZ8") + RTRIM(SB1->B1_COD))
		While !EOF() .and.  SZ8->Z8_FILIAL == XFILIAL("SZ8") .AND. SZ8->Z8_CODPRO == _cProduto  
      		RecLock("SZ8",.F.)  
      		Delete
			SZ8->(MsUnlock())
    		dbSelectArea("SZ8")
 			dbSetOrder(2)
			DbSkip()
    	Enddo
	EndIf
	For _nCont := 1 To Len(_aAux)
		DbSelectArea("SZ8")
		RecLock("SZ8",.T.)
			SZ8->Z8_CODFRA := _aAux[_nCont]
			SZ8->Z8_CODPRO := SB1->B1_COD
			SZ8->Z8_FILIAL := xFilial("SZ8")
		SZ8->(MsUnlock())
	Next
	
	CloseBrowse()
Return()

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RESTR048    º Autor ³ Adriano Leonardo  º Data ³  26/05/15 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Inverte seleção dos tipos de produtos (markbrowse).        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Específico para a empresa LDI                			  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function RESTR48D()
	
	(_cTabTmp)->(DbGoTop())
	While (_cTabTmp)->(!EOF())
	   MarkSel2()
	   (_cTabTmp)->(DbSkip())
	EndDo
	
Return()