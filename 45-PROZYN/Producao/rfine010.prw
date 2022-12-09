#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao	 � RFINE010 � Autor � Adriano Leonardo    � Data � 08/11/2016 ���
�������������������������������������������������������������������������͹��
���Desc.     � Rotina respons�vel por chamar a rotina de rec�lculo de     ���
���          � comiss�es padr�o (FINA440) e logo ap�s o t�rmino da rotina ���
���          � padr�o, avalio as reten��es e rebecimentos para gerar novas���
���          � comiss�es avaliando t�tulos em atraso e titulos cuja comis-���
���          � s�o foi retida e o cliente pagou e dever� ser restitu�da ao���
���          � vendedor.                                                  ���
�������������������������������������������������������������������������͹��
���Uso       � Espec�fico para a empresa Prozyn               			  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/

User Function RFINE010()
	
	Local _aSavArea := GetArea()
	Local _aSavSA3	:= SA3->(GetArea())
	Local _cRotina	:= "RFINE010"
	Local aMyUsers := {}
	Local nThread := 0
	Private cVendDe := ""
	Private cVendAte := ""
	Private dDataDe := CtoD("  /  /    ")
	Private dDataAte := CtoD("  /  /    ")
	
	if Pergunte("AFI440",.t.)

		aMyUsers := Getuserinfoarray(.t.)
		aEval(aMyUsers,{|x| iif( alltrim(upper(x[5])) == "U_FINA440",nThread++,nil )  })
		if nThread == 0
			FINA440(.t.) //Chamada da rotina padr�o de rec�lculo de comiss�o

			Pergunte("AFI440",.F.)
	
			Processa({|lEnd| FreteEntrada()},_cRotina,"Processando rec�lculo de comiss�es..."	,.T.) //Chamada de fun��o para grava��o do frete de entrada
	                   
			RestArea(_aSavSA3)
			RestArea(_aSavArea)
		else
			MsgInfo("Rec�lculo de comiss�es esta sendo executado agora por outra sess�o. Favor aguardar!", "Advert�ncia")
		endif
	endif
	
Return()


/* Parametros:
cNomFunc - Nome Fun��o(com u_ na frente),
nTotFunc - qtd x que fun��o pode rodar ao mesmo tempo,
nTotLic - n�mero total de licen�as
*/
Static function verSleep(cNomFunc,nTotFunc,nTotLic)
	Local nThread := 0
	Local nTotLUs := 0
	Local aMyUsers := Getuserinfoarray()

	aEval(aMyUsers,{|x| iif( substr(upper(x[5]),1,len(cNomFunc)) == cNomFunc,nThread++,nil )  })
	aEval(aMyUsers,{|x| iif( !empty(x[5]),nTotLUs++,nil )  })
	While nThread > nTotFunc .and. nTotLUs > nTotLic
		sleep(5000)		// 5 segundos
		nThread := nTotLUs := 0
		aMyUsers := Getuserinfoarray()
		aEval(aMyUsers,{|x| iif( substr(upper(x[5]),1,len(cNomFunc)) == cNomFunc,nThread++,nil )  })
		aEval(aMyUsers,{|x| iif( !empty(x[5]),nTotLUs++,nil )  })
	End

Return


Static Function FreteEntrada()

	// Local aAuto			:= {}
	Local _cAliasSE3	:= GetNextAlias()
	// Local nFreteD1 := 0
	Private lMsErroAuto	:= .F.
	Private aNFSProc := {}

	_cQry := "SELECT distinct SE3.E3_VEND, "
	_cQry += "SE3.E3_EMISSAO, SE3.E3_SERIE, SE3.E3_NUM, SE3.E3_PARCELA, SE3.E3_TIPO, SE3.E3_CODCLI, SE3.E3_LOJA, SE3.E3_PEDIDO, "
	_cQry += "SE3.E3_COMIS, SE3.E3_BASE, SE3.E3_PORC, SE3.E3_VENCTO, SE3.E3_MOEDA,SE3.E3_PREFIXO,E3_TIPO "
	_cQry += "FROM " + RetSqlName("SE1") + " SE1 WITH (NOLOCK) "
	_cQry += "INNER JOIN " + RetSqlname("SF2") + " SF2 WITH (NOLOCK) ON SF2.F2_FILIAL = '" + xFilial("SF2") + "' AND F2_DOC = E1_NUM AND F2_SERIE = E1_PREFIXO AND SF2.D_E_L_E_T_ = '' "
	_cQry += "INNER JOIN " + RetSqlName("SE3") + " SE3 WITH (NOLOCK) "
	_cQry += "ON SE1.D_E_L_E_T_='' "
	_cQry += "AND SE1.E1_FILIAL='" + xFilial("SE1") + "' "
	_cQry += "AND SE3.D_E_L_E_T_='' "
	_cQry += "AND SE3.E3_FILIAL='" + xFilial("SE3") + "' "
	_cQry += "AND SE1.E1_SERIE=SE3.E3_SERIE "
	_cQry += "AND SE1.E1_NUM=SE3.E3_NUM "
	_cQry += "AND SE1.E1_CLIENTE=SE3.E3_CODCLI "
	_cQry += "AND SE1.E1_LOJA=SE3.E3_LOJA "

	If MV_PAR07 == 1
		_cQry += "AND SE1.E1_TIPO != 'NCC' "
	EndIf
	_cQry += "AND SE1.E1_TIPO != 'AB-' "
	_cQry += "AND SE3.E3_TIPO != 'AB-' "

	_cQry += "AND SE3.E3_BAIEMI = 'B' " //Alterado por Denis Varella ~ 15/02/2018 ~ Chumbado para rec�lculo de comiss�es apenas para Emiss�o
	_cQry += "AND SE3.E3_DATA = '' " //Alterado por Denis Varella ~ 18/12/2017
	_cQry += "AND SE1.E1_BAIXA BETWEEN '" + DTOS(MV_PAR01) + "' and '" + DTOS(MV_PAR02) + "' "
	_cQry += "AND SE3.E3_VEND BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' "
	_cQry += " ORDER BY SE3.E3_NUM,SE3.E3_PARCELA,SE3.E3_TIPO "

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQry),_cAliasSE3,.T.,.F.)

	dbSelectArea(_cAliasSE3)

	While (_cAliasSE3)->(!EOF())

		If trim((_cAliasSE3)->E3_TIPO) == 'NCC'
			DBSelectArea("SF1")
			SF1->(DBSetOrder(1))
			SF1->(DBSeek(xFilial("SF1")+(_cAliasSE3)->E3_NUM+(_cAliasSE3)->E3_SERIE+(_cAliasSE3)->E3_CODCLI+(_cAliasSE3)->E3_LOJA))
			aArea := GetArea()
			U_F440NCC()
			RestArea(aArea)
		ElseIf trim((_cAliasSE3)->E3_TIPO) == 'AB-'
			/*
				DBSelectArea("SF2") 
				DBSetOrder(1)
				DBSeek(xFilial("SE3")+(_cAliasSE3)->E3_NUM+(_cAliasSE3)->E3_SERIE+(_cAliasSE3)->E3_CODCLI+(_cAliasSE3)->E3_LOJA) 
				U_F440ABM()
					(_cAliasSE3)->(dbSkip())
			*/
		Else
			DBSelectArea("SF2")
			SF2->(DBSetOrder(1))
			If SF2->(DBSeek(xFilial("SF2")+(_cAliasSE3)->E3_NUM+(_cAliasSE3)->E3_SERIE+(_cAliasSE3)->E3_CODCLI+(_cAliasSE3)->E3_LOJA))
				aArea := GetArea()
				U_F440COM(MV_PAR01,MV_PAR02,MV_PAR03,MV_PAR04,(_cAliasSE3)->E3_PARCELA)
				RestArea(aArea)
			EndIf
		EndIf

		(_cAliasSE3)->(dbSkip())
	End

	If MsgYesNo("Deseja Gerar Apura��o de Margem?")
		U_PFINR012(MV_PAR01,MV_PAR02,MV_PAR03,MV_PAR04,MV_PAR05)
	EndIf

	If MsgYesNo("Deseja Gerar Relat�rio de Comiss�o?")
		U_PFINR011(MV_PAR01,MV_PAR02,MV_PAR03,MV_PAR04,MV_PAR05)
	EndIf

	(_cAliasSE3)->(dbCloseArea())

Return()

