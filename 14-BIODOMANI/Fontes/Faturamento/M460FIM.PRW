#INCLUDE "TOPCONN.CH"

/*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
PONTO DE ENTRADA CHAMADA M460FIM, SE REFERE A GRAVAÇÃO APÓS (DEPOIS) DA PREPARAÇÃO DE DOCUMENTO DE SAÍDA. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%*/
User Function M460FIM()
	Local aArea := GetArea()
	Local aAreaC5 := sc5->(GetArea())
	Local aAreaC6 := sc6->(GetArea())
	Local aAreaE1 := se1->(GetArea())
	Local lRet    := .t.
	Local _cIdEnt := " "
	Local cTrb  := ""
	Local nI 	:= 0
	Local aSe1 	:= {}
	Local nParc := 0
	Local cNaturez := ""
	//Local aParam    := ""
	Local _cAux := "0"+Subs(cFilAnt,3,2)

	Private lMsErroAuto := .f.

	If sc5->c5_formapg == 'DV' .and. !Empty(sf2->f2_dupl) .and. sf2->f2_tipo == 'N'

		cNaturez := &(GetMv("MV_1DUPNAT",,"sa1->a1_naturez"))  //MV_1DUPREF

		cSql := "select * from "+RetSQLName("SZ3")+" z3 "
		cSql += "where z3_filial = '"+xFilial("SZ3")+"' and z3_pedido = '"+sc5->c5_num+"' and z3.d_e_l_e_t_ = ' ' "
		cSql += "order by z3_item"

		cSql := ChangeQuery( cSql )
		cTrb := GetNextAlias()
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),cTrb,.F.,.T.)
		if !(ctrb)->( Eof() )

			Begin Transaction

				se1->(DbSetOrder(2))
				se1->(dbSeek(xFilial()+sf2->f2_cliente+sf2->f2_loja+sf2->f2_prefixo+sf2->f2_dupl))
				While !se1->(Eof()) .and. se1->e1_cliente == sf2->f2_cliente .and. se1->e1_loja == sf2->f2_loja .and. ;
						se1->e1_prefixo == sf2->f2_prefixo .and. se1->e1_num == sf2->f2_dupl
					se1->(RecLock("SE1", .F.))
					se1->(DbDelete())
					se1->(MsUnLock())
					se1->(dbSkip())
				End

				while !(ctrb)->( Eof() )

					if !empty((ctrb)->z3_condpg)
						//Condicao(nValTot,cCond,nVIPI,dData,nVSol)
						aParc := Condicao((ctrb)->z3_valor,(ctrb)->z3_condpg,,dDataBase,)
						for nI := 1 to len(aParc)
							nParc +=1
							lMsErroAuto := .f.
							aSe1 := {}
							aadd( aSe1 , {"E1_PREFIXO",sf2->f2_prefixo    ,Nil} )
							aadd( aSe1 , {"E1_NUM"	  ,sf2->f2_dupl       ,Nil} )
							aadd( aSe1 , {"E1_PARCELA",alltrim(str(nParc)),Nil} )
							aadd( aSe1 , {"E1_TIPO"   ,"NF "              ,Nil} )
							aadd( aSe1 , {"E1_CLIENTE",sf2->f2_cliente    ,Nil} )
							aadd( aSe1 , {"E1_LOJA"   ,sf2->f2_loja       ,Nil} )
							aadd( aSe1 , {"E1_EMISSAO",dDataBase          ,Nil} )
							aadd( aSe1 , {"E1_NATUREZ",cNaturez           ,Nil} )
							aadd( aSe1 , {"E1_FORMAPG",(ctrb)->z3_forma   ,Nil} )
							aadd( aSe1 , {"E1_VENCTO" ,aParc[nI,1]        ,Nil} )
							aadd( aSe1 , {"E1_VALOR"  ,aParc[nI,2]        ,Nil} )
							aadd( aSe1 , {"E1_X_AUTCC",(ctrb)->z3_numaut  ,Nil} )
							aadd( aSe1 , {"E1_X_TERMI",(ctrb)->z3_numter  ,Nil} )
							aadd( aSe1 , {"E1_X_DATCC",stod((ctrb)->z3_dtaut),Nil} )
							aadd( aSe1 , {"E1_X_OBS1" ,sc5->c5_obs1       ,Nil} )
							aadd( aSe1 , {"E1_X_OBS2" ,sc5->c5_obs2       ,Nil} )
							aadd( aSe1 , {"E1_X_OBS3" ,sc5->c5_obs3       ,Nil} )
							aadd( aSe1 , {"E1_PEDIDO" ,sc5->c5_num        ,Nil} )
							aadd( aSe1 , {"E1_ORIGEM" ,"MATA460"          ,Nil} )
							MSExecAuto({|x,y| Fina040(x,y)},aSe1,3) //Inclusao
							if lMsErroAuto
								DisarmTransaction()
								MostraErro()
							endif
						next
					else
						nParc +=1
						lMsErroAuto := .f.
						aSe1 := {}
						aadd( aSe1 , {"E1_PREFIXO",sf2->f2_prefixo     ,Nil} )
						aadd( aSe1 , {"E1_NUM"	  ,sf2->f2_dupl        ,Nil} )
						aadd( aSe1 , {"E1_PARCELA" ,alltrim(str(nParc)),Nil} )
						aadd( aSe1 , {"E1_TIPO"    ,"NF "              ,Nil} )
						aadd( aSe1 , {"E1_CLIENTE" ,sf2->f2_cliente    ,Nil} )
						aadd( aSe1 , {"E1_LOJA"    ,sf2->f2_loja       ,Nil} )
						aadd( aSe1 , {"E1_EMISSAO" ,dDataBase          ,Nil} )
						aadd( aSe1 , {"E1_NATUREZ" ,cNaturez           ,Nil} )
						aadd( aSe1 , {"E1_FORMAPG" ,(ctrb)->z3_forma   ,Nil} )
						aadd( aSe1 , {"E1_VENCTO"  ,stod((ctrb)->z3_dtvenc),Nil} )
						aadd( aSe1 , {"E1_VALOR"   ,(ctrb)->z3_valor   ,Nil} )
						aadd( aSe1 , {"E1_X_AUTCC" ,(ctrb)->z3_numaut  ,Nil} )
						aadd( aSe1 , {"E1_X_TERMI" ,(ctrb)->z3_numter  ,Nil} )
						aadd( aSe1 , {"E1_X_DATCC" ,stod((ctrb)->z3_dtaut),Nil} )
						aadd( aSe1 , {"E1_X_OBS1"  ,sc5->c5_obs1       ,Nil} )
						aadd( aSe1 , {"E1_X_OBS2"  ,sc5->c5_obs2       ,Nil} )
						aadd( aSe1 , {"E1_X_OBS3"  ,sc5->c5_obs3       ,Nil} )
						aadd( aSe1 , {"E1_PEDIDO"  ,sc5->c5_num        ,Nil} )
						aadd( aSe1 , {"E1_ORIGEM"  ,"MATA460"          ,Nil} )
						MSExecAuto({|x,y| Fina040(x,y)},aSe1,3) //Inclusao
						if lMsErroAuto
							DisarmTransaction()
							MostraErro()
						endif
					endif

					(ctrb)->( DbSkip() )
				End

			End Transaction
		else
			MsgAlert("Pedido com forma de pagamento DIVERSOS INCONSISTENTE! Solicite que o Departamento Comercial revise o pedido para não gerar informações erradas ao Departamento Financeiro.","ATENÇÃO")
		endif

		(ctrb)->( DbCloseArea() )
		RestArea(aAreaE1)

	EndIf

	IF SC5->C5_DF == "N"
		lRet := .F.
		MsgAlert("Por ser um Documento NÃO FISCAL, não poderá ser transmitido!","ATENÇÃO")

		/* ATIVAR SOMENTE EM 01/01/2022 (MARCOS GOMES) */
		//if sf2->f2_x_empfa == "0103" .and. sf2->f2_serie == "F03" .and. sf2->f2_cliente == "355449"
		//	cRet := u_fazPreNota(sf2->f2_doc, sf2->f2_serie, sf2->f2_cliente, sf2->f2_loja, "001900"/*CNPJ 06.165.638/0001-69*/, "01", 2, '01', '0101') //Gerar pré-Nota Fiscal de Entrada
		//	if !empty(cRet)
		//		MessageBox(cRet,"ATENÇÃO", 16)
		//	endif
		//endif

	ELSE

		If _cAux == SF2->F2_SERIE

			_cIdEnt := RetIdEnti() //RETORNA A ENTIDADE DE NF DE ACORDO COM A FILIAL.

			SpedNFeTrf("SF2",SF2->F2_SERIE,SF2->F2_DOC,SF2->F2_DOC,_cIdEnt,"1","1","4.00",,,) // FUNÇÃO QUE TRANSMITE AUTOMÁTICA.

			MsgInfo("NOTA FISCAL acabou de ser transmitida!!! Por favor verifique no MONITOR FAIXA","ATENÇÃO") //EXIBE A MENSAGEM DIZENDO QUE A NOTA FOI TRANSMITIDA.

			U_MonitNFE( SF2->F2_SERIE, SF2->F2_DOC, SF2->F2_DOC,"SF2") //EXIBE A CONSULTA NFE DIZENDO QUE A NOTA FOI TRANSMITIDA OU NÃO.

			If SF2->F2_FIMP$"S" //----> NOTA AUTORIZADA
				Processa( {|| U_zGerDanfe("SF2")}, "Impressão DANFE", "Imprimindo DANFE...", .f.)
			else
				MsgInfo("Faça a impressão da DANFE daqui alguns minutos, pois a nota fiscal "+SF2->F2_SERIE+SF2->F2_DOC+" ainda não foi autorizada na SEFAZ.","ATENÇÃO") //EXIBE A MENSAGEM DIZENDO QUE A NOTA FOI TRANSMITIDA.    
			EndIf
		else
			lRet := .F.
			Alert("A nota fiscal "+SF2->F2_DOC+"/"+SF2->F2_SERIE+" não pertence a empresa/filial corrente.")
		ENDIF


	/* ATIVAR SOMENTE EM 01/01/2022 (LUCAS BAIA)
	//Se conseguir posicionar no pedido
	IF SC5->(DbSeek(FWxFilial('SC5') + nPedido ))
     
    	//Se conseguir posicionar nos itens do pedido
		IF SC6->(DbSeek(FWxFilial('SC6') + nPedido ))

			IF SC6->C6_TES == "502" //Definir a condição com Ricardo.

				aParam  := {SC5->C5_NOTA, SC5->C5_SERIE} //Array Definidos como aParam.
				lGravou := EXECBLOCK("RCOMF01",.F.,.F.,aParam) //ExecAuto para gerar a Nota Fiscal de Entrada da Transferência.

			ENDIF

		ENDIF

	ENDIF*/

    /*IF MSGYESNO("Deseja Imprimir a DANFE ?")
        U_zGerDanfe() //FONTE PARA IMPRESSÃO DE DANFE.
    ELSE
        lRet := .F. //CASO CLICAR EM NÃO, NÃO FAZERÁ NADA.
    ENDIF*/
ENDIF

RestArea(aAreaC6)
RestArea(aAreaC5)
RestArea(aArea)

return lRet
