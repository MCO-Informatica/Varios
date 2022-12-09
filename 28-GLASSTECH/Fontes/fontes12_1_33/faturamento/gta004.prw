#include "Protheus.ch"

User Function gta004()

	Local aAreas := {sa1->(GetArea()), GetArea()}

	Local lLibPv	:= .f.
	Local lShowPV 	:= .f.	//SuperGetMv("MV_FATTEPO",,.f.)
	Local lGerouPV	:= .f.

	Private aHeadC6	:= {}
	Private aHeadD4	:= {}

	if scj->cj_status == "B"
		MsgInfo("Orçamento já baixado/efetivado", "Status Orçamento")
		Return
	endif

	If SuperGetMV("MV_ORCSLIB",,.f.)
		Pergunte("MTA410",.f.)
		lLibPV := MV_PAR01==1
	EndIf

	Pergunte("MTA416",.f.)

	sx3->(dbSetOrder(1))
	sx3->(MsSeek("SC6",.t.))
	While !sx3->(Eof()) .and. sx3->x3_arquivo == "SC6"
		if alltrim(SX3->X3_CAMPO) == "C6_NUMORC" .or. X3Uso(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL
			Aadd(aHeadC6,{trim(X3Titulo()),;
				SX3->X3_CAMPO,;
				SX3->X3_PICTURE,;
				SX3->X3_TAMANHO,;
				SX3->X3_DECIMAL,;
				".F.",;//SX3->X3_VALID
			SX3->X3_USADO,;
				SX3->X3_TIPO,;
				SX3->X3_ARQUIVO,;
				SX3->X3_CONTEXT } )
		EndIf
		sx3->(dbSkip())
	End
	/*
	sx3->(MsSeek("SD4",.t.))
	While !sx3->(Eof()) .and. SX3->X3_ARQUIVO == "SD4"
		If ( X3Uso(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL )
			Aadd(aHeadD4,{ Trim(X3Titulo()),;
				SX3->X3_CAMPO,;
				SX3->X3_PICTURE,;
				SX3->X3_TAMANHO,;
				SX3->X3_DECIMAL,;
				SX3->X3_VALID,;
				SX3->X3_USADO,;
				SX3->X3_TIPO,;
				SX3->X3_ARQUIVO,;
				SX3->X3_CONTEXT })
		EndIf
		sx3->(dbSkip())
	End
	*/
	if MsgYesNo("Confirma efetivação do Orçamento "+scj->cJ_num+"? ", "Efetivação orçamento","YESNO")
		FwMsgRun( , {|| MaBxOrc(scj->cJ_num,MV_PAR01==1,MV_PAR02==1,MV_PAR03==1,lShowPV,aHeadC6,aHeadD4,lLibPV) } ,;
			"Aguarde",;
			"Efetivando orçamento..." )
		lGerouPV := VerGerouPV(scj->cJ_num)
		If lGerouPV
			//sc6->(dbSetOrder(1))
			//sc6->( dbseek(xfilial()+sc5->c5_num) )
			//while !sc6->(eof()) .and. sc6->c6_filial == sc5->c5_filial .and. sc6->c6_num == sc5->c5_num
			//	sc6->(RecLock("SC6",.f.))
			//	sc6->c6_numorc := sck->ck_num+sck->ck_item
			//	sc6->(MsUnLock())
			//	sc6->(dbskip())
			//end
			if scj->cj_cliente+scj->cj_loja != sa1->a1_cod+sa1->a1_loja
				sa1->(DbSetOrder(1))
				sa1->( DbSeek( xFilial()+scj->cj_cliente+scj->cj_loja ) )
			endif
			if scj->cj_condpag != sa1->a1_cond
				sa1->(RecLock("SA1",.f.))
				sa1->a1_cond := scj->cj_condpag
				sa1->(MsUnLock())
			endif
			MsgInfo("O orçamento "+scj->cj_num+" gerou com sucesso o Pedido de venda: "+sc5->c5_num,"Atenção")
		else
			MsgStop("O processo com o orçamento "+scj->cj_num+" não gerou Pedido de venda.","Atenção")
		endif

	endif

	aEval(aAreas, {|x| RestArea(x) })

Return

Static Function VerGerouPV(cNumOrc)

	Local lPVGerado	:= .t.
	Local aAreas	:= {SCJ->(GetArea()), SCK->(GetArea()), GetArea()} as array

	sck->(DbEval({|| lPVGerado := !Empty(SCK->CK_NUMPV)},, {|| SCK->(CK_FILIAL+CK_NUM) == xFilial("SCK")+cNumOrc},,,.T.))

	AEval(aAreas, {|x| RestArea(x) })

Return lPVGerado
