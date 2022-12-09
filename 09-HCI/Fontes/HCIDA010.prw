#INCLUDE "PROTHEUS.CH"
#INCLUDE "Rwmake.CH"
#INCLUDE "TopConn.CH" 

#DEFINE CRLF CHR(13) + CHR(10)

//-------------------------------------------------------------------
/*/{Protheus.doc} HCIDA010
Rotina para atualizar o campo C6_XICMRET, icms retido do pedido de venda.

@author 	BZechetti | Bruna Zechetti de Oliveira
@since 		29/06/2015
@version 	P11
@obs    	Rotina Especifica HCI
/*/
//-------------------------------------------------------------------
User Function HCIDA010()

	Local _cQuery 		:= ""
	Local _cAliasRet	:= GetNextAlias()
	Local _aArea		:= GetArea()
	Local _aAreaC6		:= SC6->(GetArea())
	Local _cC6IcmRet	:= "LOG_HCIDA010_" + DtoS(DdataBase) + "_" + StrTran(Time(),":")+ ".txt"
	Local _nHandle		:= FCreate("\"+_cC6IcmRet)
	Local _cLinha		:= ""
	Local _nOk			:= 0
	Local _aParBox		:= {}
	
	aadd(_aParBox,{1,"Data De? "    ,Ctod(Space(8)) ,"@D",".T.","",".T.",08,.T.})       
	aAdd(_aParBox,{1,"Data Ate? "	,Ctod(Space(8))	,"@D","MV_PAR02 >= MV_PAR01","",".T.",08,.T.})
	                             	
	If ParamBox(_aParBox,"Grv C6_XICMRET",,,,,,,,,.T.,.T.)
		If _nHandle > 0
			_cLinha := "[HCIDA010] - Incio da Rotina " + Time()
			FWrite(_nHandle,AllTrim(_cLinha)+CRLF)
		EndIF
		
		_cQuery := "SELECT D2_ICMSRET, SC6.R_E_C_N_O_ AS CRECNO, C6_NUM, C6_ITEM "
		_cQuery += " FROM " + RetSqlName("SC6") + " SC6 "
		
		_cQuery += " INNER JOIN " + RetSqlName("SC5") + " SC5 "
		_cQuery += " ON C5_FILIAL = C6_FILIAL"
		_cQuery += " AND C5_NUM = C6_NUM"
		_cQuery += " AND C5_EMISSAO BETWEEN '" + DtoS(MV_PAR01) +"' AND '" + DtoS(MV_PAR02) + "' "
		
		_cQuery += " INNER JOIN " + RetSqlName("SD2") + " SD2 "
		_cQuery += " ON D2_FILIAL = C6_FILIAL "
		_cQuery += " AND D2_PEDIDO = C6_NUM "
		_cQuery += " AND D2_ITEMPV = C6_ITEM "
		_cQuery += " AND D2_CLIENTE = C6_CLI "
		_cQuery += " AND D2_LOJA = C6_LOJA "
		_cQuery += " AND D2_ICMSRET > 0 "
		_cQuery += " AND SD2.D_E_L_E_T_ = ' ' "
		
		_cQuery += " WHERE C6_FILIAL = '" + xFilial("SC6") + "' "
		_cQuery += " AND C6_XICMRET = 0 "
	//	_cQuery += " AND C6_NUM = '232350' "
		_cQuery += " AND SC6.D_E_L_E_T_ = ' ' "
		_cQuery += " ORDER BY C6_FILIAL, C6_NUM, C6_ITEM "
		TcQuery _cQuery New Alias &(_cAliasRet)
		
		If (_cAliasRet)->(!EOF())
			dbSelectArea("SC6")
			SC6->(dbSetOrder(1))
			While (_cAliasRet)->(!EOF())
				SC6->(dbGoTo((_cAliasRet)->CRECNO))
				If SC6->C6_NUM == (_cAliasRet)->C6_NUM .AND. SC6->C6_ITEM == (_cAliasRet)->C6_ITEM .AND. SC6->C6_FILIAL == xFilial("SC6")
					If RecLock("SC6",.F.)
						_nOk++
						SC6->C6_XICMRET	:= (_cAliasRet)->D2_ICMSRET
						SC6->(MsUnLock())
					EndIf
				EndIf
				(_cAliasRet)->(dbSkip())
			EndDo
		EndIf
		
		If _nHandle > 0
			_cLinha := "[HCIDA010] - Processado(s) " + AllTrim(Str(_nOk)) + " registro(s)."
			FWrite(_nHandle,AllTrim(_cLinha)+CRLF)
			_cLinha := "[HCIDA010] - Fim da Rotina " + Time()
			FWrite(_nHandle,AllTrim(_cLinha)+CRLF)
			FClose(_nHandle)
		EndIF
		
		Aviso(OEMTOANSI("Atenção"),"Finalização da rotina de atualização do campo de ICMS Retido do pedido de venda [C6_XICMRET]." + CRLF +;
								"Processado(s) " + AllTrim(Str(_nOk)) + " registro(s).",{"Ok"},2)
	
	EndIf	
	
	RestArea(_aArea)
	RestArea(_aAreaC6)

Return()