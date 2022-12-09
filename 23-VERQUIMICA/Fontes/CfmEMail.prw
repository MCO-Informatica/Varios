#Include "Protheus.Ch"
#Include "TopConn.Ch"
#Include "Ap5Mail.Ch"

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+----------------------+------------------------------+------------------+||
||| Programa: CfmEMail   | Autor: Celso Ferrone Martins | Data: 18/12/2014 |||
||+-----------+----------+------------------------------+------------------+||
||| Descricao | Envio de email especifico da empresa                       |||
||+-----------+------------------------------------------------------------+||
||| Alteracao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Uso       |                                                            |||
||+-----------+------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==============================================================================
*/

User Function CfmEMail(cAssunto,cMensagem,cDeFrom,cPara,cAnexo,lQuebraDest)

Local lRetOk        := .F.
Local cRetErro      := ""
Local cEnvServer    := GetEnvServer()
Local cComCopia     := ""
Local cMsgEnvServ   := ""
Local cToAux        := ""
Local aTo           := {}

Local cRelServ      := GetMv("MV_RELSERV")
Local cRelaCnt      := GetMv("MV_RELACNT")
Local cRelPsw       := GetMv("MV_RELPSW")
Local lAuth         := GetMv("MV_RELAUTH",,.F.)

Default cDeFrom     := ""
Default cMensagem   := ""
Default cAnexo      := ""
Default lQuebraDest := .F.

cMensagem := StrTran(cMensagem,CHR(13)+CHR(10),"")

If Upper(Alltrim(cEnvServer)) != "ENVIRONMENT"
	
	cMsgEnvServ += "<Table Border='0' Width='800'>"
	cMsgEnvServ += "  <Tr>"
	cMsgEnvServ += "    <Td Align='Center'>"
	cMsgEnvServ += "      <Font Color='#FF0000' Size='3' Face='Verdana'><B>E-mail enviado no ambiente "+Alltrim(cEnvServer)+"</B></Font>"
	cMsgEnvServ += "    </Td>"
	cMsgEnvServ += "  </Tr>"
	cMsgEnvServ += "</Table>"

	cMsgEnvServ += "<Br>"
	
	cMsgEnvServ += "<Br>"

	cMsgEnvServ += "<Table Border='0' Width='800'>"
	cMsgEnvServ += "  <Tr>"
	cMsgEnvServ += "    <Td Align='Center'>"
	cMsgEnvServ += "      <Font Color='#FFFFFF' Size='2' Face='Verdana'><B>"+cPara+"</B></Font>"
	cMsgEnvServ += "    </Td>"
	cMsgEnvServ += "  </Tr>"
	cMsgEnvServ += "</Table>"
	
	cMensagem := cMsgEnvServ + cMensagem
	
	cAssunto :="("+Alltrim(cEnvServer)+") - "+ cAssunto
	//cComCopia := "celso@armi.com.br"
	cPara := "ti@verquimica.com.br"
EndIf

If Empty(cPara)
	Return .T.
EndIf

If Empty(cDeFrom)
	cDeFrom := cRelaCnt
EndIf

aTo := &("{'"+Replace(cPara,";","','")+"'}")

cPara := Replace(cPara,";","; ")

If Len(aTo) > 35
	lQuebraDest := .T.
EndIf

If lQuebraDest
	cMensagem += "<Br>"
	cMensagem += "<Br>"
	cMensagem += "<Table Width='800' Border='0' CellPadding='0' CellSpacing='1' Style='Font-Family:Courier New;Font-Size:12px;'>"
	cMensagem += "  <Tr>"
	cMensagem += "    <Td>"
	cMensagem += "      <B>O E-mail acima foi enviado aos seguintes destinatarios:</b>"
	cMensagem += "    </Td>"
	cMensagem += "  </Tr>"
	cMensagem += "  <Tr>"
	cMensagem += "    <Td>"
	cMensagem +=        cPara
	cMensagem += "    </Td>"
	cMensagem += "  </Tr>"
	cMensagem += "</Table>"
Else
	aTo := {cPara}
EndIf

For nX := 1 to Len(aTo)
	
	cToAux := aTo[nX]
	If !Empty(cToAux)
		
		Connect Smtp ;
			Server   cRelServ;
			Account  cRelaCnt;
			Password cRelPsw;
			Result   lRetOk
		
		If lRetOk
			
			If lAuth
				lRetOk := MailAuth(cRelaCnt,cRelPsw)
			EndIf
			
			If lRetOk

				Send Mail ;
					From       cDeFrom;
					To         cToAux;
					Bcc        cComCopia;
					Subject    cAssunto;
					Body       cMensagem;
					Attachment cAnexo;
					Result     lRetOk
				
				If !lRetOk
					Get Mail Error cRetErro
				EndIf
			Else
				Get Mail Error cRetErro
			EndIf
			
			Disconnect Smtp Server Result lRetOk
			
			If !lRetOk
				Get Mail Error cRetErro
			EndIf
			
		Else
			Get Mail Error cRetErro
		EndIf
		
	EndIf
	
Next nX

Return(.T.)
/*
User Function Z15Ajuste()

Local cStatus,cUsuarioI,cUsuarioA,cDataI,cDataA,cTipo := "3"
DbSelectArea("Z15") ; DbSetOrder(1)

Z15->(DbGoTop())

While !Z15->(Eof())
	LeLog(@cStatus,@cUsuarioI,@cUsuarioA,@cDataI,@cDataA,cTipo)
	RecLock("Z15",.F.)
	Z15->Z15_REVUSR := Upper(cUsuarioI)
	Z15->Z15_REVDAT := cTod(cDataI)
	MsUnLock()
	Z15->(DbSkip())
EndDo

Return()
*/
/*
User Function SC5Ajuste()

Local dDtEntVq := cTod("")

DbSelectArea("SC5") ; DbSetOrder(1)
DbSelectArea("SC6") ; DbSetOrder(1)

SC5->(DbGoTop())
While !SC5->(Eof())
	If Empty(SC5->C5_ENTREG)
		dDtEntVq := cTod("")
		If SC6->(DbSeek(xFilial("SC6")+SC5->C5_NUM))
			While !SC6->(Eof()) .And. SC6->(C6_FILIAL+C6_NUM) == xFilial("SC6")+SC5->C5_NUM
				If Empty(dDtEntVq)
					dDtEntVq := SC6->C6_ENTREG
				Else
					If dDtEntVq > SC6->C6_ENTREG
						dDtEntVq := SC6->C6_ENTREG
					EndIf
				EndIf
				SC6->(DbSkip())
			EndDo
		EndIf
		If !Empty(dDtEntVq)
			RecLock("SC5",.F.)
			SC5->C5_ENTREG  := dDtEntVq
			MsUnLock()
		EndIf
	EndIf
	SC5->(DbSkip())
EndDo

Return()
*/
/*
User Function SC6Ajuste()

DbSelectArea("SUB") ; DbSetOrder(1)
DbSelectArea("SC6") ; DbSetOrder(1)
SUB->(DbGoTop())
While !SUB->(Eof())
	If !Empty(SUB->UB_NUMPV)
		If SC6->(DbSeek(xFilial("SC6")+SUB->(UB_NUMPV+UB_ITEMPV)))
			RecLock("SC6",.F.)
				SC6->C6_VQ_PICM := SUB->UB_VQ_PICM
			MsUnLock()
		EndIf
	EndIf
	SUB->(DbSkip())
EndDo

Return()
*/
/*
User Function cfmz02z15()

DbSelectArea("Z02") ; DbSetOrder(1)
DbSelectArea("Z15") ; DbSetOrder(1)
Z02->(DbGoTop())
While !Z02->(Eof())
	RecLock("Z15",.T.)
	Z15->Z15_FILIAL := Z02->Z02_FILIAL
	Z15->Z15_COD    := Z02->Z02_COD
	Z15->Z15_DATAIN := Z02->Z02_DATAIN
	Z15->Z15_ORIGEM := Z02->Z02_ORIGEM
	Z15->Z15_REVISA := Z02->Z02_REVISA
	Z15->Z15_DATAAL := Z02->Z02_DATAAL
	Z15->Z15_UM     := Z02->Z02_UM
	Z15->Z15_MOEDA  := Z02->Z02_MOEDA
	Z15->Z15_TXMOED := Z02->Z02_TXMOED
	Z15->Z15_DATACO := Z02->Z02_DATACO
	Z15->Z15_FRETEC := Z02->Z02_FRETEC
	Z15->Z15_REFCOM := Z02->Z02_REFCOM
	Z15->Z15_DENSID := Z02->Z02_DENSID
	Z15->Z15_DTRCOM := Z02->Z02_DTRCOM
	Z15->Z15_MARGEA := Z02->Z02_MARGEA
	Z15->Z15_MARGEB := Z02->Z02_MARGEB
	Z15->Z15_MARGEC := Z02->Z02_MARGEC
	Z15->Z15_MARGED := Z02->Z02_MARGED
	Z15->Z15_MARGEE := Z02->Z02_MARGEE
	Z15->Z15_CUSOPE := Z02->Z02_CUSOPE
	Z15->Z15_CODMP  := Z02->Z02_CODMP
	Z15->Z15_CODEM  := Z02->Z02_CODEM
	Z15->Z15_PICMMP := Z02->Z02_PICMMP
	Z15->Z15_PIPIMP := Z02->Z02_PIPIMP
	Z15->Z15_PICMEM := Z02->Z02_PICMEM
	Z15->Z15_PIPIEM := Z02->Z02_PIPIEM
	Z15->Z15_CUSTO  := Z02->Z02_CUSTO
	Z15->Z15_PEXTRA := Z02->Z02_PEXTRA
	Z15->Z15_VEXTRA := Z02->Z02_VEXTRA
	Z15->Z15_REVUSR := Z02->Z02_USERGI
	MsUnLock()
	
	Z02->(DbSkip())
EndDo


Return()
*/


User Function ajustasbm()

DbSelectArea("SD1") ; DbSetOrder(1) ; DbGoTop()
DbSelectArea("SD2") ; DbSetOrder(1) ; DbGoTop()
DbSelectArea("SD3") ; DbSetOrder(1) ; DbGoTop()
DbSelectArea("SB1") ; DbSetOrder(1)

While !SD1->(Eof())
	If SB1->(DbSeek(xFilial("SB1")+SD1->D1_COD))
		RecLock("SD1",.F.)
		SD1->D1_GRUPO := SB1->B1_GRUPO
		MsUnLock()
	EndIf
	SD1->(DbSkip())
EndDo

While !SD2->(Eof())
	If SB1->(DbSeek(xFilial("SB1")+SD2->D2_COD))
		RecLock("SD2",.F.)
		SD2->D2_GRUPO := SB1->B1_GRUPO
		MsUnLock()
	EndIf

	SD2->(DbSkip())
EndDo

While !SD3->(Eof())
	If SB1->(DbSeek(xFilial("SB1")+SD3->D3_COD))
		RecLock("SD3",.F.)
		SD3->D3_GRUPO := SB1->B1_GRUPO
		MsUnLock()
	EndIf
	SD3->(DbSkip())
EndDo

Return()

/**/
User Function CfmF4Texto()

DbSelectArea("SF4") ; DbSetOrder(1)
DbSelectArea("SX5") ; DbSetOrder(1)

SF4->(DbGoTop())
While !SF4->(Eof())
	If SX5->(DbSeek(xFilial("SX5")+"13"+SF4->F4_CF))
		RecLock("SF4",.F.)
		SF4->F4_TEXTO := SX5->X5_DESCRI
		MsUnLock()
	EndIf
	SF4->(DbSkip())
EndDo

Return()




User Function CfmAjusta()

DbSelectArea("SF2") ; DbSetOrder(1)
DbSelectArea("SD2") ; DbSetOrder(3)
DbSelectArea("SF4") ; DbSetOrder(1)
DbSelectArea("Z04") ; DbSetOrder(2) //Z04_FILIAL+Z04_DOC+Z04_SERIE+Z04_TIPO+Z04_CLIENT+Z04_LOJA
DbSelectArea("SB1") ; DbSetOrder(1)
DbSelectArea("SM2") ; DbSetOrder(1)

SF2->(DbGoTop())

While !SF2->(Eof())
	
	If Z04->(DbSeek(xFilial("Z04")+SF2->(F2_DOC+F2_SERIE+F2_TIPO+F2_CLIENTE+F2_LOJA)))
	
		lDelZ04 := .F.
		
		While !Z04->(Eof()) .and. Z04->(Z04_FILIAL+Z04_DOC+Z04_SERIE+Z04_TIPO+Z04_CLIENT+Z04_LOJA) == xFilial("Z04")+SF2->(F2_DOC+F2_SERIE+F2_TIPO+F2_CLIENTE+F2_LOJA)
			
			If Z04->Z04_STATUS == "V"
				cZ04Obs := "DELETADO - CFMAJUSTA - "+AllTrim(Z04->Z04_OBSERV)
				RecLock("Z04",.F.)
				Z04->Z04_OBSERV := cZ04Obs
				MsUnLock()
				RecLock("Z04",.F.)
				Z04->(DbDelete())
				MsUnLock()
				lDelZ04 := .T.
			EndIf
			Z04->(DbSkip())
		EndDo

		If lDelZ04
			If SD2->(DbSeek(xFilial("SD2")+SF2->(F2_DOC+F2_SERIE)))
				While !SD2->(Eof()) .And. SF2->(F2_DOC+F2_SERIE) == SD2->(D2_DOC+D2_SERIE)
					
					If  SB1->(DbSeek(xFilial("SB1")+SD2->D2_COD))
						
						If SC6->(DbSeek(xFilial("SC6")+SD2->(D2_PEDIDO+D2_ITEMPV)))
							
							If SC6->C6_VQ_UM == "KG"
								nQtdSd2 := SD2->D2_QUANT
							Else
								nQtdSd2 := SD2->D2_QUANT/SB1->B1_CONV
							EndIf
							nTxMoed2 := 1
							If SC6->C6_VQ_MOED == "2"
								If SM2->(DbSeek(dTos(SD2->D2_EMISSAO)))
									nTxMoed2 := SM2->M2_MOEDA2
								EndIf
							EndIf
							_nValTab := Round(SC6->C6_VQ_VAL *nTxMoed2, 2)
							_nValNot := Round(SC6->C6_VQ_UNIT*nTxMoed2, 2) //SC6->C6_PRCVEN
							
							If _nValTab <> _nValNot .And. AllTrim(Posicione("SF4",1,xFilial("SF4")+SC6->C6_TES,"F4_DUPLIC")) == "S" .And. !Empty(SF2->F2_VEND1)
								DbSelectArea("Z04")
								RecLock("Z04", .T.)
								Z04->Z04_FILIAL := xFilial("Z04")
								Z04->Z04_VENDED := SF2->F2_VEND1
								Z04->Z04_EMISSA := SF2->F2_EMISSAO
								Z04->Z04_DOC    := SF2->F2_DOC
								Z04->Z04_SERIE  := SF2->F2_SERIE
								Z04->Z04_TIPO   := SF2->F2_TIPO
								Z04->Z04_CLIENT := SF2->F2_CLIENTE
								Z04->Z04_LOJA   := SF2->F2_LOJA
								Z04->Z04_ITEM   := SD2->D2_ITEM
								Z04->Z04_COD    := SD2->D2_COD
								Z04->Z04_TABELA := SC6->C6_VQ_TABE
								Z04->Z04_UM     := SC6->C6_VQ_UM
								Z04->Z04_MOEDA  := SC6->C6_VQ_MOED
								Z04->Z04_QUANT  := nQtdSd2//SC6->C6_VQ_QTDE//SD2->D2_QUANT
								Z04->Z04_VALTAB := _nValTab
								Z04->Z04_VALNOT := _nValNot
								Z04->Z04_TIPODC := If(_nValTab > _nValNot, "D", "C")
								Z04->Z04_VALOR  := Abs(_nValTab-_nValNot)*nQtdSd2//SC6->C6_VQ_QTDE
								Z04->Z04_OBSERV := If(_nValTab > _nValNot, "DEBITO GERADO AUTOMATICAMENTE - CFMAJUSTA", "CREDITO GERADO AUTOMATICAMENTE - CFMAJUSTA")
								Z04->Z04_USER   := __cUserId
								Z04->Z04_DTLANC := Date()
								Z04->Z04_HRLANC := Time()
								Z04->Z04_STATUS := "V"
								Z04->Z04_REGIAO := Posicione("SA1",1,xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,"A1_REGIAO") //08/12/2014
								Z04->Z04_GRPVEN := Posicione("SA1",1,xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,"A1_GRPVEN") //08/12/2014
								Z04->(MsUnlock())
							EndIf
							//
						EndIf
					EndIf
					
					SD2->(DbSkip())
					
				EndDo
			EndIf
		EndIf
	EndIf
	
	SF2->(DbSkip())
	
EndDo

Return()