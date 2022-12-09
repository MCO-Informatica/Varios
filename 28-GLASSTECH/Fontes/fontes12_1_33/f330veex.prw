User Function f330veex()
	Local aArea := getarea()
	Local aAreaE5 := se5->(getarea())
	Local cQuery := ""
	Local nI := 0
	//Local cDel := iif(AScan(arotina, {|x| AllTrim(x[1]) == capital(substr( cCadastro, at('-',cCadastro)+2))})==4,"*"," ")
	Local cDel := iif(Paramixb[1]==4,"*"," ")
	
	for nI := 1 to len(aTitulos)
		cQuery := "SELECT * FROM "+RetSQLName("SE5")+" E5 "
		cQuery += "WHERE E5_FILIAL = '"+aTitulos[nI,13]+"' AND E5_PREFIXO = '"+substr(aTitulos[nI,7],1,3)+"' "
		cQuery += "AND E5_NUMERO = '"+substr(aTitulos[nI,7],4,9)+"' AND E5_PARCELA = '"+substr(aTitulos[nI,7],13,1)+"' "
		//cQuery += "AND E5_TIPO = '"+SE1->E1_TIPO+"' AND E5_CLIFOR = '"+SE1->E1_CLIENTE+"' AND E5_LOJA = '"+SE1->E1_LOJA+"' "
		cQuery += "AND RTRIM(E5_DOCUMEN) = '"+aTitulos[nI,1]+aTitulos[nI,2]+aTitulos[nI,3]+aTitulos[nI,4]+aTitulos[nI,5]+"' "
		cQuery += "AND E5_SEQ = '"+aTitulos[nI,8]+"' AND E5.D_E_L_E_T_ = '"+cDel+"'  ORDER BY  E5_SEQ"
		cQuery := ChangeQuery( cQuery )
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRB",.f.,.t.)
		If trb->(!Eof()) .and. Val( TRB->E5_IDMOVI ) <> 0

			_nResult := TCSPExec('f080pcan', Val( TRB->E5_IDMOVI ), 'R', TRB->E5_FILIAL , TRB->E5_ORIGBD )

			If _nResult[1] =  0

				MsgInfo('Não conformidade ao cancelar a baixa do Titulo ' + rTrim( SE1->E1_NUM ) + '/' + SE1->E1_PARCELA + ' ' +rTrim( SE1->E1_NOMCLI ) + '.', 'Rotina Exclusão Baixa (fa330eac)' )
				_lRet := .F.

			End

		endif
		TRB->( DbCloseArea() )
	NEXT

	RestArea(aAreaE5)
	RestArea(aArea)

Return
