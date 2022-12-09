#Include "Protheus.ch"
//�����������������������������������������������������������������������������
//���Programa  � CN100VST �Autor  �Pedro Augusto       � Data �  15/10/15   ���
//�������������������������������������������������������������������������͹��
//���Desc.     � Ponto de entrada usado para validar alteracao de situacao  ���
//�������������������������������������������������������������������������͹��
//���Uso       � RENOVA                                                     ���
//�����������������������������������������������������������������������������
// Situacoes Possiveis para alteracao do contrato.
//	DEF_SCANC "01" //Cancelado
//	DEF_SELAB "02" //Em Elaboracao
//	DEF_SEMIT "03" //Emitido
//	DEF_SAPRO "04" //Em Aprovacao
//	DEF_SVIGE "05" //Vigente
//	DEF_SPARA "06" //Paralisado
//	DEF_SSPAR "07" //Sol Fina.
//	DEF_SFINA "08" //Finalizado
//	DEF_SREVS "09" //Revisao
//	DEF_SREVD "10" //Revisado

User Function CN100VST()

	Local _aAreaCN9  := GetArea("CN9")
	Local _aAreaCNA  := GetArea("CNA")
	Local _aAreaCNB  := GetArea("CNB")
	Local _aAreaCN1  := GetArea("CN1")
	Local _lRet 	 := .T.
	Local _cSitAtu	 := CN9->CN9_SITUAC
	Local _UniReq	 := CN9->CN9_XUNIDR //UNIDADE REQUISITANTE.
	Local _cSitNew	 := ParamIXB[1]
	Local lRet       := .T.
	Local _CtrCliVen := CN9->CN9_ESPCTR // SE PREENCHIDO � CONTRATO DE VENDA.

	If _CtrCliVen =='2'// contrato de venda, retorna .T. e sai do PE.
		_lRet := .T.
		Return(_lRet)
	Endif
	If _cSitNew == '04'
		If Empty(CN9->CN9_APROV)
			MsgAlert('N�o foi encontrado Grupo de Aprova��o para esta opera��o. Favor solicitar revis�o da unidade requisitante: ' +ALLTRIM(_UniReq),'Controle de Al�adas')
			_lRet := .F.
		EndIf
	ElseIf _cSitNew == '05'
		If _cSitAtu == '04'
			MsgAlert('Esta operacao nao pode ser realizada, a transi��o para a situa��o "Vigente" ser� realizada ao termino do processo de aprova��o!','Controle de Al�adas')
			_lRet := .F.
		Else
			MsgAlert('Esta operacao nao pode ser realizada, primeiro deve passar pela situacao Em Aprovacao!','Controle de Al�adas')
			_lRet := .F.
		EndIf
	EndIf

	If _cSitAtu == '07' .And. _cSitNew == '08' .And. _lRet
		cQuery := "SELECT * FROM " + RetSqlName("SCR") + " SCR WHERE "
		cQuery += "SCR.CR_FILIAL = '" + xFilial("SCR") + "' AND "
		cQuery += "RTRIM(SCR.CR_NUM) = '" + CN9->CN9_NUMERO + "' AND "
		cQuery += "SCR.CR_TIPO = 'CT' AND "
		cQuery += "SCR.CR_STATUS = '02' AND "
		cQuery += "SCR.D_E_L_E_T_ = ''"

		cQuery := ChangeQuery( cQuery )
		dbUseArea( .T., 'TOPCONN', TcGenQry( ,, cQuery ), "TRBSCR", .F., .T. )

		If TRBSCR->(!EOF())
			MsgAlert('Este contrato est� em processo de aprova��o.','Controle de Al�adas')
			_lRet := .F.
		EndIf
		TRBSCR->(dbCloseArea())
	EndIf

	RestArea(_aAreaCN9)
	RestArea(_aAreaCNA)
	RestArea(_aAreaCNB)
	RestArea(_aAreaCN1)

Return(_lRet)
