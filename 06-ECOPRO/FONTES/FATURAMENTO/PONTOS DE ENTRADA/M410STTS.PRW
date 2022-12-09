#Include "Protheus.ch"
#include "tbiconn.ch"

/*3 - Inclusão, 4 - Alteração, 5 - Exclusão, 6 - Cópia, 7 - Devolução de Compras*/

User Function M410STTS()

	Local _nOper    := PARAMIXB[1]
	Local _aArea	:=	GetArea()

	If _nOper == 5

		dbSelectArea("SCJ")
		SCJ->(dbSetOrder(1))
		SCJ->(DbGoTop())

		If  !Empty(SC6->C6_NUMORC)

			SCJ->(dbSeek(xFilial("SCJ")+Substr(SC6->C6_NUMORC,1,6)+M->C5_CLIENTE+M->C5_LOJACLI,.f.))
			RecLock("SCJ",.f.)
			SCJ->CJ_STATUS := "A"
			MsUnLock()
			MsgInfo("Numero Orcamento" + Substr(SC6->C6_NUMORC,1,6),"Orçamento foi Reaberto!")
		EndIf

	EndIf


	IF _nOper == 3 //---> Inclusão

		RecLock("SC5", .F.)
		SC5->C5_YUSRINC := UsrFullName(RetCodUsr())
		SC5->C5_YDATINC := DDatabase
		SC5->C5_YHRINC  := SUBS(Time(),1,5)
		MsUnlock()

		procProducao(sc5->c5_num,_nOper)

		if !empty(sc5->c5_xidapi) .and. alltrim(sc5->c5_especi1) == "Servico"
			cMens := ""
			geraFatura(sc5->c5_num,@cMens)
		EndIf

	ELSEIF _nOper == 4 //---> Alteração

		RecLock("SC5", .F.)
		SC5->C5_YUSRALT := UsrFullName(RetCodUsr())
		SC5->C5_YDATALT := DDatabase
		SC5->C5_YHRALT  := SUBS(Time(),1,5)
		MsUnlock()

		//if !empty(sc5->c5_xidapi) .and. alltrim(sc5->c5_especi1) == "Servico"
		//    cMens := ""
		//    geraFatura(sc5->c5_num,@cMens)
		//EndIf
		//procProducao(sc5->c5_num,3)

	ELSEIF _nOper == 6 //---> Cópia

		RecLock("SC5", .F.)
		SC5->C5_YUSRINC := UsrFullName(RetCodUsr())
		SC5->C5_YDATINC := DDatabase
		SC5->C5_YHRINC  := SUBS(Time(),1,5)
		MsUnlock()

		procProducao(sc5->c5_num,3)

	ENDIF

	RestArea(_aArea)

Return Nil


Static function geraFatura(cPedido,cMens)
	Local lRet 	 := .t.
	Local cError := ""
	Local oError := ErrorBlock( { |e| cError := e:Description } )

	Private lMsErroAuto := .f.

	Begin Sequence

		Pergunte("MT460A",.F.)
		FtJobNFs("SC9","A",.F.,.F.,.F.,.F.,.F.,0,0,0,.F.,.F.,cPedido,1)

	End Sequence

	ErrorBlock(oError)	//Restaurando bloco de erro do sistema
	If !Empty(cError)	//Se houve erro, será mostrado ao usuário
		lRet := .f.
		cMens := "Inconsistência no Faturamento do Pedido: "+cPedido+". Detalhes: "+Substr(cError,1,150)
	else
		cMens := "FIm Faturamento do Pedido "+cPedido
	EndIf

Return(lRet)


Static function procProducao(cPedido,nOpe)

	Local cEmailTo 	:= ""
	Local cEmailCc 	:= ""
	Local cAssunto 	:= ""
	Local cMensagem := ""
	Local aAnexos	:= {}
	Local cAssinatu := ""
	Local cError	:= ""
	Local lMostra	:= .f.
	Local cProdPest := ""
	Local cProdOps  := ""
	Local aProdOps  := {}
	Local cMens     := ""
	Local lFaz      := .f.
	Local lacharOp	:= .t.

	Local cNumOP    := ""
	Local aVetor	:= {}
	//Local aEmpen := {}
	Local nI		:= 0

	sc2->(dbSetOrder(1))
	sb1->(dbSetOrder(1))
	sb2->(dbSetOrder(1))
	sc2->(dbSetOrder(1))
	sc6->(dbSetOrder(1))
	sc6->(dbSeek(xFilial()+cPedido))
	While !sc6->(EoF()) .and. sc6->c6_num == cPedido
		sb1->(dbSeek(xFilial()+sc6->c6_produto))
		sb2->(dbSeek(xFilial()+sc6->c6_produto+sc6->c6_local))

		lFaz := .f.
		cProdOps := ""

		if sb1->b1_xkit == 'S' .and. sb2->b2_qatu-sb2->b2_qemp-sb2->b2_reserva-(sb2->b2_qpedven-sc6->c6_qtdven) < sc6->c6_qtdven
			lFaz := .t.
			cQuery := "select g1_filial,g1_cod,g1_comp,g1_quant,b2_local,b2_qatu,b2_reserva,b2_qpedven,b2_qemp from "+RetSQLName("SG1")+" g1 "
			cQuery += "inner join "+RetSQLName("SB2")+" b2 on b2_filial = g1_filial and b2_cod = g1_comp and b2.d_e_l_e_t_ = ' ' "
			cQuery += "where g1_filial = '"+xFilial("SG1")+"' and g1_cod = '"+sc6->c6_produto+"' and g1.d_e_l_e_t_ = ' ' "
			cQuery := ChangeQuery( cQuery )
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRB",.f.,.t.)
			while !trb->( Eof() )
				nqtdVen := sc6->c6_qtdven * trb->g1_quant
				if trb->b2_qatu-trb->b2_qemp-trb->b2_reserva-trb->b2_qpedven < nqtdVen
					lFaz := .f.
				endif
				trb->( DbSkip() )
			end
			trb->( DbCloseArea() )

			if lFaz
				cProdOps += "<p>Item "+sc6->c6_item+" Cód. "+alltrim((sc6->c6_produto))+"/"+sc6->c6_local+", Qtd.Sol. "+alltrim(str(sc6->c6_qtdven))+"</p>"
			else
				cProdPest += "<p>Item "+sc6->c6_item+" Cód. "+alltrim((sc6->c6_produto))+"/"+sc6->c6_local+", Qtd.Sol. "+alltrim(str(sc6->c6_qtdven))+"</p>"
			endif
		elseif sb1->b1_xkit != 'S' .and. sb2->b2_qatu-sb2->b2_qemp-sb2->b2_reserva-(sb2->b2_qpedven-sc6->c6_qtdven) < sc6->c6_qtdven
			cProdPest += "<p>Item "+sc6->c6_item+" Cód. "+alltrim((sc6->c6_produto))+"/"+sc6->c6_local+", Qtd.Sol. "+alltrim(str(sc6->c6_qtdven))+"</p>"
		endif

		if lFaz
			//cNumOP := getNumSC2()
			lacharOp := .t.
			while lacharOp
				cNumOP := GetMV("MV_XNUMSC2")
				if sc2->( dbseek( xFilial("SC2")+cNumOP ) )
					nNum := val(substr(cNumOP,2,5))+1
					cNumOP := "S"+strzero(nNum,5)
					putMV("MV_XNUMSC2", cNumOP)
				else
					lacharOp := .f.
				endif
			end

			aVetor := { {'C2_FILIAL'    ,xFilial("SC2")       ,NIL},;
				{'C2_NUM'       ,cNumOP     ,NIL},;
				{'C2_ITEM'      ,"01"       ,NIL},;
				{'C2_SEQUEN'    ,"001"      ,NIL},;
				{'C2_PRODUTO'   ,sc6->c6_produto,NIL},;
				{'C2_LOCAL'     ,sc6->c6_local  ,NIL},;
				{'C2_QUANT'     ,sc6->c6_qtdven ,NIL},;
				{'C2_DATPRI'    ,dDataBase  ,NIL},;
				{'C2_DATPRF'    ,dDataBase+7,NIL},;
				{'C2_OBS'       ,"PEDIDO: "+SC5->C5_NUM+" - EMISSÃO: "+DTOC(SC5->C5_EMISSAO)+" - CLIENTE: "+SA1->A1_NOME,NIL},;
				{'AUTEXPLODE'   ,"S"        ,NIL}}

			cMens  := ""
			if fazOP(aVetor,nOpe,@cMens)

				aadd( aProdOps, { cNumOP, cProdOps } )

				nNum := val(substr(cNumOP,2,5))+1
				cNumOP := "S"+strzero(nNum,5)
				putMV("MV_XNUMSC2", cNumOP)
                /*
				aVetor := { {"D4_COD"     ,sc2->c2_produto,Nil},; //COM O TAMANHO EXATO DO CAMPO
				    {"D4_LOCAL"   ,sc2->c2_local  ,Nil},;
					{"D4_OP"      ,sc2->c2_num+sc2->c2_item+sc2->c2_sequen+sc2->c2_itemgrd  ,Nil},;
					{"D4_DATA"    ,dDatabase      ,Nil},;
					{"D4_QTDEORI" ,sc2->c2_quant  ,Nil},;
					{"D4_QUANT"   ,sc2->c2_quant  ,Nil},;
					{"D4_TRT"     ,"   "          ,Nil},;
					{"D4_QTSEGUM" ,0              ,Nil}}

				aEmpen := {}
				aadd(aEmpen,{sc2->c2_quant,;  // SD4->D4_QUANT
				""      ,;  // DC_LOCALIZ
				""      ,;  // DC_NUMSERI
				0       ,;  // D4_QTSEGUM
				.F.})

				if fazEmpenho(aVetor,aEmpen,4,@cMens,lMostra)

					cQuery := "select d4_cod,d4_local,d4_quant,b2_qatu from "+RetSQLName("SD4")+" d4 "
					cQuery += "inner join "+RetSQLName("SB2")+" b2 on b2_FILIAL = d4_filial and b2_cod = d4_cod and b2_local = d4_local and b2.d_e_l_e_t_ = ' ' "
					cQuery += "where d4_filial = '"+xFilial("SD4")+"' and d4_op = '"+sc2->c2_num+sc2->c2_item+sc2->c2_sequen+sc2->c2_itemgrd+"' and d4.d_e_l_e_t_ = ' ' and d4_quant > b2_qatu "
					cQuery := ChangeQuery( cQuery )
					dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRB",.f.,.t.)
					if trb->( Eof() )

						aVetor := {}
						aAdd(aVetor, {"D3_TM"   ,'001'          , NIL})
						aAdd(aVetor, {"D3_COD"  ,sc2->c2_produto, NIL})
						aAdd(aVetor, {"D3_UM"   ,sc2->c2_um     , NIL})
						aAdd(aVetor, {"D3_QUANT",sc2->c2_quant  , NIL})
						aAdd(aVetor, {"D3_OP"   ,sc2->c2_num+sc2->c2_item+sc2->c2_sequen+sc2->c2_itemgrd, NIL})
						aAdd(aVetor, {"D3_LOCAL",sc2->c2_local  , NIL})
						aAdd(aVetor, {"D3_EMISSAO",dDataBase    , NIL})
						aAdd(aVetor, {"D3_PERDA",0              , NIL})
						if !ApontaSimples(aVetor,nOpe,@cMens,lMostra)
							alert(cMens)
						endif

						//aVetor := {}
						//aadd(aVetor,{"H6_OP"        , sc2->c2_num     ,NIL})
						//aadd(aVetor,{"H6_PRODUTO"   , sc2->c2_produto ,NIL})
						//aadd(aVetor,{"H6_DTAPONT"   , sc2->c2_datprf  ,NIL})
						//if !fazApontamento(aVetor,nOpe,@cMens,lMostra)
						//    alert(cMens)
						//endif
					else

						while !trb->( Eof() )
							cProdPest += "Cód. "+alltrim((trb->d4_cod))+"/"+trb->d4_local+", Qtd.Sol. "+alltrim(str(trb->d4_quant))+chr(13)+chr(10)
							trb->( DbSkip() )
						end

						//endif

						trb->( DbCloseArea() )
					endif
				else
					alert(cMens)
				endif
                */
			else
				alert(cMens)
			endif
		endif

		sc6->(DbSkip())
	End

	cEmailTo := "hugo.carvalho@ecoprosustentavel.com.br"
	cEmailCc := "expedicao@ecoprosustentavel.com.br;thiago.silverio@ecoprosustentavel.com.br"
	if len(aProdOps) > 0
		cAssunto := "Abertura de Ordem de Serviço"
		for nI := 1 to len(aProdOps)
			cMensagem := '<html>'
			cMensagem += '<body>'
			cMensagem := "<p>Feito Pedido: "+SC5->C5_NUM+" - Emissão: "+DTOC(SC5->C5_EMISSAO)+" - Cliente: "+alltrim(SA1->A1_NOME)+"</p>"
			cMensagem += "<p>Foi Aberta a Ordem de Serviço "+aProdOps[nI,1]+" para o(s) produto(s):</p>"
			cMensagem += aProdOps[nI,2]
			cMensagem += '</body>'
			cMensagem += '</html>'
			if u_envmail(cEmailTo ,cEmailCc ,cAssunto ,cMensagem ,aAnexos, cAssinatu, cError, lMostra)
				if lMostra
					alert(cMensagem)
				endif
			endif
		Next
	endif

	cEmailTo := "hugo.carvalho@ecoprosustentavel.com.br"
	cEmailCc := "thiago.silverio@ecoprosustentavel.com.br"
	if !Empty(cProdPest)
		cAssunto := "Produto sem estoque"
		cMensagem := '<html>'
		cMensagem += '<body>'
		cMensagem += "<p>Feito Pedido: "+SC5->C5_NUM+" - Emissão: "+DTOC(SC5->C5_EMISSAO)+" - Cliente: "+alltrim(SA1->A1_NOME)+"</p>"
		cMensagem += "<p>É Necessário abertura de produção ou compra do(s) produto(s):</p>"
		cMensagem += cProdPest
		cMensagem += '</body>'
		cMensagem += '</html>'
		if u_envmail(cEmailTo ,cEmailCc ,cAssunto ,cMensagem ,aAnexos, cAssinatu, cError, lMostra)
			if lMostra
				alert(cMensagem)
			endif
		endif
	endif

return


Static function fazOP(aVetor,nOpc,cMens)
	Local lRet 	 := .t.
	Local cError := ""
	Local oError := ErrorBlock( { |e| cError := e:Description } )

	Private lMsErroAuto := .f.

	Begin Sequence

		MSExecAuto({|x,Y| Mata650(x,Y)},aVetor,nOpc)
		If lMsErroAuto
			cError := MostraErro()
		EndIf

	End Sequence

	ErrorBlock(oError)	//Restaurando bloco de erro do sistema
	If !Empty(cError)	//Se houve erro, será mostrado ao usuário
		lRet := .f.
		cMens := "OP não gerada. Detalhes: "+Substr(cError,1,150)
	else
		cMens := "OP gerada."
	EndIf

Return(lRet)

/*
Static function fazEmpenho(aVetor,aEmpen,nOpc,cMens,lMostra)
	Local lRet 	 := .t.
    Local nI     := 0
    Local aLog   := {}
	Local cError := ""
	Local oError := ErrorBlock( { |e| cError := e:Description } )

	Private lMsErroAuto := .f.

	Begin Sequence

        MSExecAuto({|x,y,z| mata380(x,y,z)},aVetor,nOpc,aEmpen) 
		if lMostra
            MostraErro()
		else
			cError += "Erro "+alltrim(str(nOpc))+": "
			aLog := GetAutoGRLog()
			For nI := 1 To Len(aLog)
				cError += aLog[nI]+chr(13)+chr(10)
			Next
		endif

	End Sequence

	ErrorBlock(oError)	//Restaurando bloco de erro do sistema
	If !Empty(cError)	//Se houve erro, será mostrado ao usuário
		lRet := .f.
		cMens := "Empenho não realizado no Pedido. Detalhes: "+Substr(cError,1,150)
	else
		cMens := "Empenho Realizado para o pedido."
	EndIf

Return(lRet)


Static function fazApontamento(aMata680,nOpc,cMens,lMostra)
	Local lRet 	 := .t.
    Local nI     := 0
    Local aLog   := {}
	Local cError := ""
	Local oError := ErrorBlock( { |e| cError := e:Description } )

	Private lMsErroAuto := .f.

	Begin Sequence

        MsExecAuto({|x,y|MATA680(x,y)},aMata680,nOpc)
		if lMostra
            MostraErro()
		else
			cError += "Erro "+alltrim(str(nOpc))+": "
			aLog := GetAutoGRLog()
			For nI := 1 To Len(aLog)
				cError += aLog[nI]+chr(13)+chr(10)
			Next
		endif

	End Sequence

	ErrorBlock(oError)	//Restaurando bloco de erro do sistema
	If !Empty(cError)	//Se houve erro, será mostrado ao usuário
		lRet := .f.
		cMens := "Apontamento não realizado para o Pedido. Detalhes: "+Substr(cError,1,150)
	else
		cMens := "Apontamento realizado para o pedido."
	EndIf

Return(lRet)

Static function ApontaSimples(aMata250,nOpc,cMens,lMostra)
	Local lRet 	 := .t.
	Local nI     := 0
	Local aLog   := {}
	Local cError := ""
	Local oError := ErrorBlock( { |e| cError := e:Description } )

	Private lMsErroAuto := .f.

	Begin Sequence

		MSExecAuto({|x,y|MATA250(x,y)},aMata250,nOpc)
		If lMsErroAuto
			if lMostra
				MostraErro()
			else
				cError += "Erro "+alltrim(str(nOpc))+": "
				aLog := GetAutoGRLog()
				For nI := 1 To Len(aLog)
					cError += aLog[nI]+chr(13)+chr(10)
				Next
			endif
		EndIf

	End Sequence

	ErrorBlock(oError)	//Restaurando bloco de erro do sistema
	If !Empty(cError)	//Se houve erro, será mostrado ao usuário
		lRet := .f.
		cMens := "Apontamento Simples não realizado para o Pedido. Detalhes: "+Substr(cError,1,150)
	else
		cMens := "Apontamento Simples realizado para o pedido."
	EndIf

Return(lRet)
*/
