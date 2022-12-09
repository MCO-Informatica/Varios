#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"                       
#INCLUDE "TOPCONN.CH"
#Include "Tbiconn.Ch"
#include "TbiCode.ch"
#Define STR_PULA		Chr(13)+Chr(10)

User Function AFTERLOGIN()

	Local _alArea		:= GetArea()
	Local _cMenuXNU		:= FWGetMnuFile()
	Local _oDlgAT		:= Nil
	Local _cQuery := ""


	Private _oGDadosAD	:= Nil
	Private _oGDadosAM	:= Nil
	Private _oGDadosTD	:= Nil
	Private _oGDadosTM	:= Nil
	Private _aHeadAD	:= {}
	Private _aHeadAM	:= {}
	Private _aHeadTD	:= {}
	Private _aHeadTM	:= {}
	Private _aColsAD	:= {}
	Private _aColsAM	:= {}
	Private _aColsTD	:= {}
	Private _aColsTM	:= {}
	Private _dDtIni		:= FirstDay(dDataBase)
	Private _dDtFim		:= LastDay(dDataBase)


	_cQuery += "update "+RetSqlName("SC2")+" as a set c2_itempv = "+STR_PULA
	_cQuery += "coalesce( "+STR_PULA
	_cQuery += "( "+STR_PULA
	_cQuery += "select b.c2_itempv from "+RetSqlName("SC2")+" as b  "+STR_PULA
	_cQuery += "where b.c2_filial = a.c2_filial  and b.c2_num = a.c2_num and b.c2_item = a.c2_item and b.c2_sequen = '001' and b.d_e_l_e_t_= ' ' "+STR_PULA
	_cQuery += "), "+STR_PULA
	_cQuery += "'   '), "+STR_PULA
	_cQuery += "c2_pedido = "+STR_PULA
	_cQuery += "coalesce( "+STR_PULA
	_cQuery += "( "+STR_PULA
	_cQuery += "select b.c2_pedido from "+RetSqlName("SC2")+" as b  "+STR_PULA
	_cQuery += "where b.c2_filial = a.c2_filial  and b.c2_num = a.c2_num and b.c2_item = a.c2_item and b.c2_sequen = '001' and b.d_e_l_e_t_= ' ' "+STR_PULA
	_cQuery += "), "+STR_PULA
	_cQuery += "'   '), "+STR_PULA
	_cQuery += "c2_roteiro = "+STR_PULA
	_cQuery += "coalesce( "+STR_PULA
	_cQuery += "( "+STR_PULA
	_cQuery += "select b.c2_roteiro from "+RetSqlName("SC2")+" as b  "+STR_PULA
	_cQuery += "where b.c2_filial = a.c2_filial  and b.c2_num = a.c2_num and b.c2_item = a.c2_item and b.c2_sequen = '001' and b.d_e_l_e_t_= ' ' "+STR_PULA
	_cQuery += "), "+STR_PULA
	_cQuery += "'   ') "+STR_PULA
	_cQuery += "where a.c2_filial = '"+xFilial("SC2")+"' and a.c2_sequen <> '001' and a.c2_quje < a.c2_quant and a.d_e_l_e_t_ = ' ' "+STR_PULA
	_cQuery += "and a.c2_num in "+STR_PULA
	_cQuery += "( "+STR_PULA
	_cQuery += "select s.c2_num from "+RetSqlName("SC2")+" as s where s.c2_filial = '"+xFilial("SC2")+"' and s.c2_quje < s.c2_quant and s.d_e_l_e_t_ = ' ' and s.c2_sequen = '001' "+STR_PULA
	_cQuery += ") "+STR_PULA

	//alert(_cQuery)

	TcSqlExec(_cQuery)

	If "PORTAL_VEND.XNU" $ AllTrim(UPPER(_cMenuXNU)) //nModulo == 98 //AllTrim(Upper(aRetModName[nModulo,2])) $ "SIGAESP"
		_fGetAgend()
		_fGetTaref()
		
		DEFINE MSDIALOG _oDlgAT TITLE OEMTOANSI("Agenda/Tarefa") FROM C(0),C(0) TO C(440),C(1015) OF _oDlgAT PIXEL
		
			_oTFold		:= TFolder():New(005,005,{"Agenda do Dia","Agenda do Mês"},,_oDlgAT,,,,.T.,,642,125,,) 
			_oGDadosAD 	:= MsNewGetDados():New(0,0,113,640, ,"AllWaysTrue","AllWaysTrue","",,2,999,"AllWaysTrue","AllWaysTrue","AllWaysTrue",_oTFold:aDialogs[1],_aHeadAD,_aColsAD)
			_oGDadosAM 	:= MsNewGetDados():New(0,0,113,640, ,"AllWaysTrue","AllWaysTrue","",,000,999,"AllWaysTrue","AllWaysTrue","AllWaysTrue",_oTFold:aDialogs[2],_aHeadAM,_aColsAM)
			                                                                                               
			_oTFold2	:= TFolder():New(135,005,{"Tarefa do Dia","Tarefa do Mês"},,_oDlgAT,,,,.T.,,642,125,,) 
			_oGDadosTD 	:= MsNewGetDados():New(0,0,113,640, ,"AllWaysTrue","AllWaysTrue","",,2,999,"AllWaysTrue","AllWaysTrue","AllWaysTrue",_oTFold2:aDialogs[1],_aHeadTD,_aColsTD)
			_oGDadosTM 	:= MsNewGetDados():New(0,0,113,640, ,"AllWaysTrue","AllWaysTrue","",,000,999,"AllWaysTrue","AllWaysTrue","AllWaysTrue",_oTFold2:aDialogs[2],_aHeadTM,_aColsTM)
			
		ACTIVATE MSDIALOG _oDlgAT On Init EnchoiceBar(_oDlgAT,{|| nOpcA:=1,_oDlgAT:End()},{||nOpca:=0,_oDlgAT:End()},,) Centered	
	EndIf
	
	RestArea(_alArea)
	
Return()

Static Function _fGetAgend()

	Local _aCampos	:= {"AD7_DATA", "AD7_TOPICO", "AD7_HORA1", "AD7_HORA2", "AD7_CODCLI", "AD7_LOJA", "AD7_NCLI", "AD7_LOCAL"}
	Local _cQuery	:= ""
	Local _cAliasAD	:= GetNextAlias()
	Local _cAliasAM	:= GetNextAlias()
	Local _cVend	:= U_HCIDM010("SUSPEC")[1]
	
	DbSelectArea("SX3")
	SX3->(DbSetOrder(2)) // Campo
	For _nX := 1 to Len(_aCampos)
		If SX3->(MsSeek(_aCampos[_nX]))
			Aadd(_aHeadAD,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,;
						SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})

			Aadd(_aHeadAM,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,;
						SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
		Else
			If Alltrim(_aCampos[_nX]) == "AD7_NCLI"
				Aadd(_aHeadAD,{ "Nome","AD7_NOMCLI",	PesqPict('SA1','A1_NOME'),40,0,"","€€€€€€€€€€€€€€°","C","","","",""})
				Aadd(_aHeadAM,{ "Nome","AD7_NOMCLI",	PesqPict('SA1','A1_NOME'),40,0,"","€€€€€€€€€€€€€€°","C","","","",""})
			EndIf

		Endif
	Next _nX
	
	DbSelectArea("SX3")
	SX3->(DbSetOrder(2)) // Campo
	_aAux := {}
	For _nX := 1 to Len(_aCampos)
		If DbSeek(_aCampos[_nX])
			Aadd(_aAux,CriaVar(SX3->X3_CAMPO))
		Else
			If Alltrim(_aCampos[_nX]) == "AD7_NCLI"
				Aadd(_aAux,Space(TAMSX3("A1_NOME")[1]))
			EndIf		
		EndIf
	Next _nX
	Aadd(_aAux,.F.)
	
	_cQuery := "SELECT AD7_DATA, AD7_TOPICO, AD7_HORA1, AD7_HORA2, AD7_CODCLI, AD7_LOJA, A1_NOME, AD7_LOCAL"
	_cQuery	+= " FROM " + RetSqlName("AD7") + " AD7 "
	
	_cQuery	+= " INNER JOIN " + RetSqlName("SA1") + " SA1 "
	_cQuery	+= " ON A1_FILIAL = '" + xFilial("SA1") + "' "
	_cQuery	+= " AND A1_COD = AD7_CODCLI "
	_cQuery	+= " AND A1_LOJA = AD7_LOJA "
	_cQuery	+= " AND SA1.D_E_L_E_T_ = ' '"
	
	_cQuery	+= " WHERE AD7_FILIAL = '" + xFilial("AD7") + "' " 
	_cQuery	+= " AND AD7_DATA = '" + DtoS(dDataBase) + "'"
	_cQuery	+= " AND AD7_VEND IN (" + Iif(!Empty(_cVend),SUBSTR(_cVend,1,LEN(_cVend)-1),"' '") + ") "
	_cQuery	+= " AND AD7.D_E_L_E_T_ = ' ' "
	TcQuery _cQuery New Alias &(_cAliasAD)
	
	If (_cAliasAD)->(!EOF())
		While (_cAliasAD)->(!EOF())
			_aAux2	:= {}
			aadd(_aAux2, (_cAliasAD)->AD7_DATA)
			aadd(_aAux2, (_cAliasAD)->AD7_TOPICO)
			aadd(_aAux2, (_cAliasAD)->AD7_HORA1)
			aadd(_aAux2, (_cAliasAD)->AD7_HORA2)
			aadd(_aAux2, (_cAliasAD)->AD7_CODCLI)
			aadd(_aAux2, (_cAliasAD)->AD7_LOJA)
			aadd(_aAux2, (_cAliasAD)->A1_NOME)
			aadd(_aAux2, (_cAliasAD)->AD7_LOCAL)
			Aadd(_aAux2,.F.)
			Aadd(_aColsAD,_aAux2)
			(_cAliasAD)->(dbSkip())
		EndDo
	Else
		Aadd(_aColsAD,_aAux)
	EndIf
	
	(_cAliasAD)->(dbCloseArea())
	
	_cQuery := "SELECT AD7_DATA, AD7_TOPICO, AD7_HORA1, AD7_HORA2, AD7_CODCLI, AD7_LOJA, A1_NOME, AD7_LOCAL"
	_cQuery	+= " FROM " + RetSqlName("AD7") + " AD7 "
	
	_cQuery	+= " INNER JOIN " + RetSqlName("SA1") + " SA1 "
	_cQuery	+= " ON A1_FILIAL = '" + xFilial("SA1") + "' "
	_cQuery	+= " AND A1_COD = AD7_CODCLI "
	_cQuery	+= " AND A1_LOJA = AD7_LOJA "
	_cQuery	+= " AND SA1.D_E_L_E_T_ = ' '"
	
	_cQuery	+= " WHERE AD7_FILIAL = '" + xFilial("AD7") + "' "
	_cQuery	+= " AND AD7_DATA BETWEEN '" + DtoS(_dDtIni) + "' AND '" + DtoS(_dDtFim) + "' "
	_cQuery	+= " AND AD7_VEND IN (" + Iif(!Empty(_cVend),SUBSTR(_cVend,1,LEN(_cVend)-1),"' '") + ") "
	_cQuery	+= " AND AD7.D_E_L_E_T_ = ' ' "
	TcQuery _cQuery New Alias &(_cAliasAM)
	
	If (_cAliasAM)->(!EOF())
		While (_cAliasAM)->(!EOF())
			_aAux2	:= {}
			aadd(_aAux2, (_cAliasAM)->AD7_DATA)
			aadd(_aAux2, (_cAliasAM)->AD7_TOPICO)
			aadd(_aAux2, (_cAliasAM)->AD7_HORA1)
			aadd(_aAux2, (_cAliasAM)->AD7_HORA2)
			aadd(_aAux2, (_cAliasAM)->AD7_CODCLI)
			aadd(_aAux2, (_cAliasAM)->AD7_LOJA)
			aadd(_aAux2, (_cAliasAM)->A1_NOME)
			aadd(_aAux2, (_cAliasAM)->AD7_LOCAL)
			Aadd(_aAux2,.F.)
			Aadd(_aColsAM,_aAux2)
			(_cAliasAM)->(dbSkip())
		EndDo
	Else
		Aadd(_aColsAM,_aAux)
	EndIf
	
	(_cAliasAM)->(dbCloseArea())
	
Return()

Static Function _fGetTaref()

	Local _aCampos	:= {"AD8_DTINI", "AD8_DTFIM", "AD8_TAREFA", "AD8_TOPICO", "AD8_STATUS", "AD8_PRIOR"}
	Local _cQuery	:= ""
	Local _cAliasTD	:= GetNextAlias()
	Local _cAliasTM	:= GetNextAlias()
	
	DbSelectArea("SX3")
	SX3->(DbSetOrder(2)) // Campo
	For _nX := 1 to Len(_aCampos)
		If SX3->(MsSeek(_aCampos[_nX]))
			Aadd(_aHeadTD,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,;
						SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})

			Aadd(_aHeadTM,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,;
						SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})

		Endif
	Next _nX
	
	DbSelectArea("SX3")
	SX3->(DbSetOrder(2)) // Campo
	_aAux := {}
	For _nX := 1 to Len(_aCampos)
		If DbSeek(_aCampos[_nX])
			Aadd(_aAux,CriaVar(SX3->X3_CAMPO))
		EndIf
	Next _nX
	Aadd(_aAux,.F.)
	
	_cQuery := "SELECT AD8_DTINI, AD8_DTFIM, AD8_TAREFA, AD8_TOPICO, AD8_STATUS, AD8_PRIOR"
	_cQuery	+= " FROM " + RetSqlName("AD8")
	_cQuery	+= " WHERE AD8_FILIAL = '" + xFilial("AD8") + "' "
	_cQuery	+= " AND AD8_DTINI = '" + DtoS(dDataBase) + "'"
	_cQuery	+= " AND AD8_CODUSR = '" + __cUserId + "' "
	_cQuery	+= " AND D_E_L_E_T_ = ' ' "
	TcQuery _cQuery New Alias &(_cAliasTD)
	
	If (_cAliasTD)->(!EOF())
		While (_cAliasTD)->(!EOF())
			_aAux2	:= {}
			aadd(_aAux2, (_cAliasTD)->AD8_DTINI)
			aadd(_aAux2, (_cAliasTD)->AD8_DTFIM)
			aadd(_aAux2, (_cAliasTD)->AD8_TAREFA)
			aadd(_aAux2, (_cAliasTD)->AD8_TOPICO)
			aadd(_aAux2, (_cAliasTD)->AD8_STATUS)
			aadd(_aAux2, (_cAliasTD)->AD8_PRIOR)
			Aadd(_aAux2,.F.)
			Aadd(_aColsTD,_aAux2)
			(_cAliasTD)->(dbSkip())
		EndDo
	Else
		Aadd(_aColsTD,_aAux)
	EndIf
	
	(_cAliasTD)->(dbCloseArea())
	
	_cQuery := "SELECT AD8_DTINI, AD8_DTFIM, AD8_TAREFA, AD8_TOPICO, AD8_STATUS, AD8_PRIOR"
	_cQuery	+= " FROM " + RetSqlName("AD8")
	_cQuery	+= " WHERE AD8_FILIAL = '" + xFilial("AD8") + "' "
	_cQuery	+= " AND AD8_DTINI BETWEEN '" + DtoS(_dDtIni) + "' AND '" + DtoS(_dDtFim) + "' "
	_cQuery	+= " AND AD8_CODUSR = '" + __cUserId + "' "
	_cQuery	+= " AND D_E_L_E_T_ = ' ' "
	TcQuery _cQuery New Alias &(_cAliasTM)
	
	If (_cAliasTM)->(!EOF())
		While (_cAliasTM)->(!EOF())
			_aAux2	:= {}
			aadd(_aAux2, (_cAliasTM)->AD8_DTINI)
			aadd(_aAux2, (_cAliasTM)->AD8_DTFIM)
			aadd(_aAux2, (_cAliasTM)->AD8_TAREFA)
			aadd(_aAux2, (_cAliasTM)->AD8_TOPICO)
			aadd(_aAux2, (_cAliasTM)->AD8_STATUS)
			aadd(_aAux2, (_cAliasTM)->AD8_PRIOR)
			Aadd(_aAux2,.F.)
			Aadd(_aColsTM,_aAux2)
			(_cAliasTM)->(dbSkip())
		EndDo
	Else
		Aadd(_aColsTM,_aAux)
	EndIf
		
	(_cAliasTM)->(dbCloseArea())
		
Return()
