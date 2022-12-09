#INCLUDE "TOPCONN.CH"

User Function M410PVNF()

	Local _aArea 	:= GetArea()
	Local _lRet	 	:= .t.
	Local cSql      := ""
	Local cTrb      := ""

	dbSelectArea("SA1")
	dbSetOrder(1)
	dbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,.f.)

	dbSelectArea("SZ8")
	dbSetOrder(3) //---> Z8_FILIAL + Z8_COD + Z8_USUARIO

	IF cFilAnt<>SC5->C5_X_EMPFA
		_lRet := .F.
		Alert("O Pedido de Venda "+SC5->C5_NUM+" não pertence a empresa/filial corrente.")
		Return _lRet
	ELSEIF SC5->C5_NOTA <> ' ' .AND. SC5->C5_SERIE <> ' '
		_lRet := .F.
		Alert("O Pedido de Venda "+SC5->C5_NUM+" já foi faturado."+chr(13)+;
			chr(13)+;
			"A Nota Fiscal é "+SC5->C5_NOTA+" Série "+SC5->C5_SERIE)
		Return _lRet

	ELSEIF SC5->C5_X_EMPFA$"0103" //.AND. !SC5->C5_DF$'N'
		If !RetCodUsr()$"000094" // ARIANE PODE
			_lRet := .F.
			Alert("Empresa "+cFilAnt+" bloqueada para faturamento","ATENÇÃO")
			Return _lRet
		EndIf

	ELSEIF SZ8->(!(dbSeek(xFilial("SZ8")+cFilAnt+RetCodUsr())))
		_lRet := .F.
		Alert("Usuário não autorizado para faturar Notas pela Filial "+cFilAnt+"","ATENÇÃO")
		Return _lRet
	ENDIF

	If Alltrim(SC5->C5_FORMAPG)$"DV"
		cSql := "select * from "+RetSQLName("SZ3")+" z3 "
		cSql += "where z3_filial = '"+xFilial("SZ3")+"' and z3_pedido = '"+sc5->c5_num+"' and z3.d_e_l_e_t_ = ' ' "
		cSql += "order by z3_item"
		cSql := ChangeQuery( cSql )
		cTrb := GetNextAlias()
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),cTrb,.F.,.T.)
		if (ctrb)->( Eof() )
			_lRet := .F.
			Alert("Pedido com forma de pagamento DIVERSOS INCONSISTENTE. A nota fiscal não será gerada!","ATENÇÃO")
			(ctrb)->( DbCloseArea() )
			Return _lRet
		else
			while !(ctrb)->( Eof() )
				if empty((ctrb)->z3_condpg) .and. dtos(dDatabase) > (ctrb)->z3_dtvenc
					_lRet := .f.
					Alert("Data do vencimento menor que data atual na tela de formas de pagamento. A nota fiscal não será gerada!", "ATENÇÃO")
                    (ctrb)->( DbCloseArea() )
                    Return _lRet
				endif
                (ctrb)->(dbskip())
			end
		EndIf
		(ctrb)->( DbCloseArea() )
	EndIf

	If SA1->A1_SITFIN$"I"

		_lRet := .f.

		MsgStop("Cliente inadimplente. Não será permitido a geração da nota fiscal. Favor verificar junto ao Depto. Financeiro.")

	Else

		dbSelectArea("SC9")
		dbSetOrder(1)
		If dbSeek(SC5->C5_FILIAL+SC5->C5_NUM,.F.)
			While Eof() == .f. .And. SC9->(C9_FILIAL+C9_PEDIDO) == SC5->(C5_FILIAL+C5_NUM)


			/*
			//----> VERIFICA SE ESTÁ BLOQUEADO POR ESTOQUE
                If SC9->C9_BLEST $ "02" .AND. SC9->C9_LOCAL $"01A1"

				dbSelectArea("SB1")
				dbSetOrder(1)
				dbSeek(xFilial("SB1")+SC9->C9_PRODUTO,.F.)

                    If MsgYesNo("O produto "+Alltrim(SC9->C9_PRODUTO)+" "+Alltrim(SB1->B1_DESC)+" não possui saldo em estoque para atender o pedido. Deseja forçar a entrada em estoque?","Força Entrada Estoque?")
			    
						_aMata240 := {}
									        
						aAdd(_aMata240, {"D3_TM"      , "002"	             , NIL})
						aAdd(_aMata240, {"D3_DOC"     , "PV2019"       		 , NIL})
						aAdd(_aMata240, {"D3_COD"     , SC9->C9_PRODUTO		 , NIL})
						aAdd(_aMata240, {"D3_UM"      , SB1->B1_UM			 , NIL})
						aAdd(_aMata240, {"D3_QUANT"   , SC9->C9_QTDLIB		 , NIL})
						aAdd(_aMata240, {"D3_LOCAL"   , SC9->C9_LOCAL		 , NIL})
						aAdd(_aMata240, {"D3_EMISSAO" , dDataBase            , NIL})
						
                        If Rastro(SC9->C9_PRODUTO)
							aAdd(_aMata240, {"D3_LOTECTL" , "PV2019"		     , NIL})
							aAdd(_aMata240, {"D3_DTVALID" , CTOD("31/12/2022")   , NIL})
                        EndIf

                        If Localiza(SC9->C9_PRODUTO)
							MsgAlert("O produto "+Alltrim(SC9->C9_PRODUTO)+" "+Alltrim(SB1->B1_DESC)+" controla endereço. Portanto é necessário endereçar essa entrada forçada no estoque","Endereçar Entrada Forçada")
                        EndIf
						
						dbselectarea ("SD3")
						lMSErroAuto := .F.
						msExecAuto({|x|MATA240(x)}, _aMata240, 3)
								        
                        If lmserroauto
							mostraerro()
                        EndIf

						dbSelectArea("SC9")
						RecLock("SC9",.f.)
						SC9->C9_BLEST	:=	""
						MsUnLock()

                    EndIf

                EndIf
			*/

				//----> INICIO GRAVACAO DOS CAMPOS CUSTOMIZADOS SC9 - 21/09/2017 - RICARDO SOUZA - MCINFOTEC
				RecLock("SC9",.f.)
				SC9->C9_DF		:=	SC5->C5_DF
				SC9->C9_X_EMPFA	:=	SC5->C5_X_EMPFA
				MsUnLock()
				//----> FIM GRAVACAO DOS CAMPOS CUSTOMIZADOS SC9 - 21/09/2017 - RICARDO SOUZA - MCINFOTEC
				dbSelectArea("SC9")
				dbSkip()
			EndDo
		EndIf
	EndIf

	RestArea(_aArea)


Return(_lRet)
