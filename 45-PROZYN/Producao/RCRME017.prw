/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RESTR048    º Autor ³ Adriano Leonardo  º Data ³  07/07/15 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Função resposável por criar tela de markbrowse para seleçãoº±±
±±º          ³ dos contatos a serem selecionados                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Específico para a empresa Prozyn                			  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function RCRME017()
	Private _cTabTmp3 	:= GetNextAlias()
	Private _cSZ1Tmp 	:= GetNextAlias()
	Private _cEnt		:= CHR(13) + CHR(10)
	Private cMarca3   	:= GetMark()
	Private _cQryTmp           
	Private _cArm		:= ""	
	Private cCadastro	:= "Selecione os documentos"
	
	//Funções chamadas na tela do markbrowse
	Private aRotina 	:= {{"&Confirmar"	, "U_RESTR48G()",0,1},;
							{"In&verter"	, "U_RESTR48H()",0,1} }
	
	Private bMark3    	:= {|| MarkSel3()}
	
	_aCpoTmp3 := {} // Campos que serao exibidos no MarkBrowse
	
	AADD(_aCpoTmp3,{"TD_OK"		," "," "				})
	AADD(_aCpoTmp3,{"TD_CODIGO"	," ","Código"			})
	AADD(_aCpoTmp3,{"TD_DESC"	," ","Descrição"		        })
	
	_aEstru3 := {} // Estrutura do Arquivo Temporario
	
	AADD(_aEstru3,{"TD_OK"			, "C",02,0})
	AADD(_aEstru3,{"TD_CODIGO"		, "C",06,0})
	AADD(_aEstru3,{"TD_DESC"		, "C",60,0})
	
	_cArq3 := CriaTrab(_aCpoTmp3,.F.) //Nome do arquivo temporário
	DbCreate(_cArq3,_aEstru3)
	DbUseArea(.T.,,_cArq3,_cTabTmp3,.F.)
	
	//Consulta no banco de dados para seleção dos tipos de produtos que serão considerados no relatório
	_cQryTmp := "SELECT '' AS [ZN_OK], ZN_CODIGO, ZN_DESC FROM " + RetSqlName("SZN") + " SZN " + _cEnt
	_cQryTmp += "WHERE SZN.D_E_L_E_T_='' " + _cEnt
	_cQryTmp += "AND SZN.ZN_FILIAL='" + xFilial("SZN") + "' " + _cEnt
		
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQryTmp),_cSZ1Tmp,.F.,.T.)
	
	dbSelectArea(_cSZ1Tmp)
	dbGoTop()
	
	While (_cSZ1Tmp)->(!EOF())
		
		dbSelectArea(_cTabTmp3)
		
		//Preencho a tabela temporária com o resultado da query
		RecLock(_cTabTmp3,.T.)
			(_cTabTmp3)->TD_OK 		:= (_cSZ1Tmp)->ZN_OK
			(_cTabTmp3)->TD_CODIGO 	:= (_cSZ1Tmp)->ZN_CODIGO
			(_cTabTmp3)->TD_DESC 	:= RTRIM((_cSZ1Tmp)->ZN_DESC)
		(_cTabTmp3)->(MsUnlock())
		
		dbSelectArea(_cSZ1Tmp)
		dbSkip()
	EndDo
	
	//Crio tela para marcação dos itens a serem impressos, dentro do intervalo de parâmetros definidos pelo usuário
	MarkBrowse(_cTabTmp3,"TD_OK",,_aCpoTmp3,,cMarca3,"U_RESTR48G()",,,,"eval(bMark3)")
	
Return(_cArm)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RESTR048    º Autor ³ Adriano Leonardo  º Data ³  07/07/15 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Confirma seleção dos armazéns (markbrowse).                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Específico para a empresa LDI                			  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function RESTR48G()
	_lRestr048 := .T.
	CloseBrowse()
Return(_cArm)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RESTR048    º Autor ³ Adriano Leonardo  º Data ³  07/07/15 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Inverte seleção dos armazéns (markbrowse).                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Específico para a empresa LDI                			  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function RESTR48H()
	
	(_cTabTmp3)->(DbGoTop())
	While (_cTabTmp3)->(!EOF())
	   MarkSel3()
	   (_cTabTmp3)->(DbSkip())
	EndDo
	
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

Static Function MarkSel3()
	
	Local lDesmarc := IsMark("TD_OK", cMarca3, .T.)
	
	If !Empty((_cTabTmp3)->TD_OK)
	   DbSelectArea(_cTabTmp3)
	   
	   RecLock(_cTabTmp3,.F.)
		   Replace TD_OK With Space(2)
		   _cArm := StrTran(_cArm,", "+RTRIM((_cTabTmp3)->TD_DESC),"")
	   	   _cArm := StrTran(_cArm,RTRIM((_cTabTmp3)->TD_DESC)	,"")

			If SubStr(AllTrim(_cArm),1,1)==", "
				_cArm := SubStr(AllTrim(_cArm),2,Len(AllTrim(_cArm)))
			EndIf
			
	   MsUnlock()
	Else
	   DbSelectArea(_cTabTmp3)
	   
	   RecLock(_cTabTmp3,.F.)
		   Replace TD_OK With cMarca3
		   _cArm += IIF(Empty(_cArm),RTRIM((_cTabTmp3)->TD_DESC),", " + RTRIM((_cTabTmp3)->TD_DESC))
	   MsUnlock()
	EndIf
	
Return()