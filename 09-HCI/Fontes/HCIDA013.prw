#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"

User Function HCIDA013()

	Local alEstrut		:= {}
	Local alCampos		:= {}
	Local olChkB		:= Nil
	Local olBtn1		:= Nil
	Local olBtn2		:= Nil
	Local olBtn3		:= Nil
	Local clNomTmp		:= ""
	Local clMarca		:= "X"
	Local llChkB		:= .T.
	Local _nOpc			:= 0
	Local _dDatDe		:= FirstDay(Date())
	Local _dDatAte		:= LastDay(Date())	
	Private olMark		:= Nil
	Private _cClientes	:= U_HCIDM010("CLIENTE")
	Private _oVlrCom	:= Nil
	Private _nVlrCom	:= 0
	
	If Empty(_cClientes)
		_cClientes	:= SPACE(TAMSX3("E3_CODCLI")[1]+TAMSX3("E3_LOJA")[1])
	EndIf
	
	aAdd(alCampos,{"EMISSAO"	,,"Emissao"		,PesqPict("SE3","E3_EMISSAO")	})
	aAdd(alCampos,{"PREFIXO"	,,"Prefixo"		,PesqPict("SE3","E3_PREFIXO")	})	
	aAdd(alCampos,{"TITULO"		,,"Titulo"		,PesqPict("SE3","E3_NUM")		})	
	aAdd(alCampos,{"PARCELA"	,,"Parcela"		,PesqPict("SE3","E3_PARCELA")	})	
	aAdd(alCampos,{"TIPO"		,,"Tipo"		,PesqPict("SE3","E3_TIPO")		})	
	aAdd(alCampos,{"CODCLI"		,,"Cod.Cliente"	,PesqPict("SE3","E3_CODCLI")		})	
	aAdd(alCampos,{"LOJCLI"		,,"Loja"		,PesqPict("SE3","E3_LOJA")		})	
	aAdd(alCampos,{"NOMCLI"		,,"Nome Cliente",PesqPict("SA1","A1_NREDUZ")		})	
	aAdd(alCampos,{"BASE"		,,"Base"		,PesqPict("SE3","E3_BASE")		})	
	aAdd(alCampos,{"PORCENT"	,,"Porcentagem"	,PesqPict("SE3","E3_PORC")		})	
	aAdd(alCampos,{"COMISSAO"	,,"Comissao"	,PesqPict("SE3","E3_COMIS")		})	

	aAdd(alEstrut,{"EMISSAO"	,"D",TamSX3("E3_EMISSAO")[1]	,TamSX3("E3_EMISSAO")[2]	})
	aAdd(alEstrut,{"PREFIXO"	,"C",TamSX3("E3_PREFIXO")[1]	,TamSX3("E3_PREFIXO")[2]	})	
	aAdd(alEstrut,{"TITULO"		,"C",TamSX3("E3_NUM")[1]		,TamSX3("E3_NUM")[2]		})	
	aAdd(alEstrut,{"PARCELA"	,"C",TamSX3("E3_PARCELA")[1]	,TamSX3("E3_PARCELA")[2]	})	
	aAdd(alEstrut,{"TIPO"		,"C",TamSX3("E3_TIPO")[1]		,TamSX3("E3_TIPO")[2]		})	
	aAdd(alEstrut,{"CODCLI"		,"C",TamSX3("E3_CODCLI")[1]		,TamSX3("E3_CODCLI")[2]		})	
	aAdd(alEstrut,{"LOJCLI"		,"C",TamSX3("E3_LOJA")[1]		,TamSX3("E3_LOJA")[2]		})	
	aAdd(alEstrut,{"NOMCLI"		,"C",TamSX3("A1_NREDUZ")[1]		,TamSX3("A1_NREDUZ")[2]		})	
	aAdd(alEstrut,{"BASE"		,"N",TamSX3("E3_BASE")[1]		,TamSX3("E3_BASE")[2]		})	
	aAdd(alEstrut,{"PORCENT"	,"N",TamSX3("E3_PORC")[1]		,TamSX3("E3_PORC")[2]		})	
	aAdd(alEstrut,{"COMISSAO"	,"N",TamSX3("E3_COMIS")[1]		,TamSX3("E3_COMIS")[2]		})	

	clNomTmp	:= CriaTrab(alEstrut,.T.)
	If Select("TMPCOM") > 0
		TMPCOM->(dbCloseArea())
	EndIf
	dbUseArea(.T.,,clNomTmp,"TMPCOM",.F.)
	
	INDEX ON DTOS(EMISSAO) TAG IND1 TO "TMPCOM"

	RptStatus({|lEnd| FGrvTMP(_dDatDe,_dDatAte,@lEnd)},"Gerando tabela temporária..Aguarde!")

	TMPCOM->(dbSetOrder(1))
	TMPCOM->(dbGoTop())
	
	@000,000 To 540,1095 DIALOG _oDlgCom TITLE "Comissão"
	
		olMark	:= MsSelect():New("TMPCOM","",,alCampos,,@clMarca,{25,04,250,550})
		
		@ 007,004 SAY "Data De:"						SIZE 55,9 OF _oDlgCom PIXEL COLOR CLR_BLUE
		@ 004,034 MSGET _dDatDe    		 SIZE 40 ,9 OF _oDlgCom PIXEL
		@ 007,104 SAY "Data Ate:"						SIZE 55,9 OF _oDlgCom PIXEL COLOR CLR_BLUE
		@ 004,134 MSGET _dDatAte 		 SIZE 40 ,9 OF _oDlgCom PIXEL
		
		@ 255,004 Say "Total Comissão:" SIZE 60,7  PIXEL COLOR CLR_HBLUE
		@ 255,050 MSGET _oVlrCom Var _nVlrCom Picture PesqPict('SE3','E3_COMIS') WHEN .F. SIZE 60,08 PIXEL COLOR CLR_HBLUE
		
		@ 004,220 BUTTON olBtn3		PROMPT "Pesquisar" 		SIZE 40,12 ACTION (Iif(!Empty(_dDatDe).And.!Empty(_dDatAte),;
																				(FGrvTMP(_dDatDe,_dDatAte),TMPCOM->(dbGoTop())),;
																				Aviso(OEMTOANSI("Atenção"),"Favor preencher o campo Data De e Até!",{"Ok"},2))) 	PIXEL OF _oDlgCom
		@ 255,500 BUTTON olBtn2		PROMPT "Fechar"  		SIZE 40,12 ACTION _oDlgCom:End() PIXEL OF _oDlgCom

	ACTIVATE DIALOG _oDlgCom CENTERED
	
Return()

Static Function FGrvTMP(_dDatDe,_dDatAte)

	Local _cQuery		:= ""
	Local _cCodTipo		:= ""
	Local _cAliasCOM	:= GetNextAlias()


	If Select("TMPCOM") > 0
		TMPCOM->(dbGoTop())
		If TMPCOM->(!Eof())
			While TMPCOM->(!Eof())
				If RecLock("TMPCOM", .F., .T.)
					TMPCOM->( dbDelete() )
					TMPCOM->( MsUnLock() )
				EndIf
				TMPCOM->( dbSkip() )				
			EndDo
		EndIf
	EndIf

	_cQuery	:= "SELECT	E3_EMISSAO, E3_PREFIXO, E3_NUM, E3_PARCELA, E3_TIPO, E3_BASE, E3_PORC, E3_COMIS, E3_CODCLI, E3_LOJA, A1_NREDUZ "
	_cQuery	+= " FROM " + RetSqlName("SE3") + " SE3 "
	
	_cQuery	+= " INNER JOIN " + RetSqlName("SA1") + " SA1 "
	_cQuery	+= " ON A1_FILIAL = '" + xFilial("SA1") +"' "
	_cQuery	+= " AND A1_COD = E3_CODCLI "
	_cQuery	+= " AND A1_LOJA = E3_LOJA "
	
	_cQuery	+= " WHERE E3_FILIAL = '" + xFilial("SE3") + "' "
	_cQuery	+= " AND E3_CODCLI||E3_LOJA IN (" + _cClientes + ") "
	_cQuery	+= " AND E3_EMISSAO BETWEEN '" + DtoS(_dDatDe) + "' AND '" + DtoS(_dDatAte) + "' "
	_cQuery	+= " AND SE3.D_E_L_E_T_ = ' '"
    _cQuery	+= " ORDER BY E3_EMISSAO "
	TcQuery _cQuery New Alias &(_cAliasCOM)	
	
	If (_cAliasCOM)->(!EOF())
		ProcRegua((_cAliasCOM)->(RecCount()))
		While (_cAliasCOM)->(!EOF())
			IncProc()
			If RecLock("TMPCOM",.T.)
				TMPCOM->EMISSAO		:= STOD((_cAliasCOM)->E3_EMISSAO)
				TMPCOM->PREFIXO		:= (_cAliasCOM)->E3_PREFIXO
				TMPCOM->TITULO		:= (_cAliasCOM)->E3_NUM
				TMPCOM->PARCELA		:= (_cAliasCOM)->E3_PARCELA
				TMPCOM->TIPO		:= (_cAliasCOM)->E3_TIPO
				TMPCOM->CODCLI		:= (_cAliasCOM)->E3_CODCLI
				TMPCOM->LOJCLI		:= (_cAliasCOM)->E3_LOJA
				TMPCOM->NOMCLI		:= (_cAliasCOM)->A1_NREDUZ
				TMPCOM->BASE		:= (_cAliasCOM)->E3_BASE
				TMPCOM->PORCENT		:= (_cAliasCOM)->E3_PORC
				TMPCOM->COMISSAO	:= (_cAliasCOM)->E3_COMIS
				_nVlrCom+=(_cAliasCOM)->E3_COMIS
				TMPCOM->(MsUnLock())
			EndIf		
			(_cAliasCOM)->(dbSkip())
		EndDO
	EndIf
	(_cAliasCOM)->(dbCloseArea())
	
    TMPCOM->(dbSetOrder(1))

Return(Nil)
