#include "PROTHEUS.CH"
#include "TOPCONN.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMFIN003   บAutor  ณ Otacilio A. Junior บ Data ณ  10/01/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina para gerar arquivo TXT p/envio ao SERASA            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function MFIN003()
	private cPerg   	:= "MFIN003"
	private nOpca 	:= 0
	private aSays		:= {}
	private aButtons	:= {}
	private cCadastro	:= "Exporta็ใo de dados para o SERASA"
	private aHelp     := {}
	Private aArea		:= GetArea()

	
	aAdd(aSays, "Esta rotina gera um arquivo texto, com a finalidade de enviar")
	aAdd(aSays, "informa็๕es sobre os clientes para a SERASA.")
	aAdd(aSays, "Os dados serใo gerados de acordo com os parโmetros informados")
	aAdd(aSays, "pelo usuแrio.")
	aAdd(aButtons, { 5,.T.,{|| Pergunte(cPerg,.T. ) } } )
	aAdd(aButtons, { 1,.T.,{|o| nOpca := 1 , o:oWnd:End()}} )
	aAdd(aButtons, { 2,.T.,{|o| o:oWnd:End() }} )

	FormBatch( cCadastro, aSays, aButtons )

	If nOpca == 1

		Pergunte(cPerg, .F.)
		If MV_PAR03 == 1
			Processa({||MFI03GER1()})
			MsgAlert("Arquivo Carga gerado com sucesso")
		Else
			Processa({||MFI03GER2()})
			MsgAlert("Arquivo Concilia gerado com sucesso")
		EndIf
	EndIf
Return Nil

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMFIN003   บAutor  ณMicrosiga           บ Data ณ  01/04/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Gerar arquivo texto para envio ao SERASA                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function MFI03GER1()

	Local cFile  := Alltrim(MV_PAR04)
	Local cTexto := ""
	Local cQuery := ""
	Local cEof   := Chr(13) + Chr(10)
	Local nQuant := 0
	Local nQuant1:= 0
	Local lFirst := .T.
	Local cCnpj  := ""
	Local nHandle

	cQuery := "SELECT E1_PREFIXO, E1_NUM, E1_PARCELA, E1_CLIENTE, E1_LOJA, E1_EMISSAO, E1_VENCREA, E1_VALOR, E1_SALDO, E1_VALLIQ, E1_BAIXA, A1_MSBLQL,"
	cQuery += " A1_PESSOA, A1_CGC, A1_NOME, A1_NREDUZ, A1_END, A1_BAIRRO, A1_MUN, A1_EST, A1_CEP, A1_DDD, A1_TEL, A1_FAX, A1_EMAIL, A1_PRICOM, E1_TIPO "
	cQuery += " FROM " + RetSqlName("SE1") + " SE1, "+RetSqlName("SA1") + " SA1"
	cQuery += " WHERE SE1.E1_FILIAL = '" + xFilial("SE1") + "'"
	cQuery += "   AND SA1.A1_FILIAL = '" + xFilial("SA1") + "'"
	cQuery += "   AND SA1.A1_COD = E1_CLIENTE"
	cQuery += "   AND SA1.A1_LOJA = E1_LOJA"
	cQuery += "   AND SA1.A1_PESSOA = 'J'"
	cQuery += "   AND SA1.A1_EST <> 'EX'"
	cQuery += "   AND (SE1.E1_EMISSAO >= '" + Dtos(MV_PAR01) + "'"
	cQuery += "   AND SE1.E1_EMISSAO <= '" + Dtos(MV_PAR02) + "' OR " 
	cQuery += "       SE1.E1_BAIXA >= '" + Dtos(MV_PAR01) + "'"
	cQuery += "   AND SE1.E1_BAIXA <= '" + Dtos(MV_PAR02) + "')"
	cQuery += "   AND SE1.E1_TIPO NOT IN " + FormatIn(MVABATIM, "|")
	cQuery += "   AND SE1.E1_TIPO <> 'RA '"
	cQuery += "   AND SE1.D_E_L_E_T_ <> '*'"
	cQuery += "   AND SA1.D_E_L_E_T_ <> '*'"
	cQuery += " ORDER BY SE1.E1_FILIAL, SE1.E1_CLIENTE, SE1.E1_LOJA"
	cQuery := ChangeQuery( cQuery )
	DbUseArea(.T., "TOPCONN", TcGenQry( , , cQuery ), "TRB1", .T., .T.)

	TcSetField('TRB1', 'E1_EMISSAO', 'D', 08, 0)
	TcSetField('TRB1', 'E1_VENCREA', 'D', 08, 0)
	TcSetField('TRB1', 'E1_BAIXA'  , 'D', 08, 0)
	TcSetField('TRB1', 'A1_PRICOM' , 'D', 08, 0)

	TRB1->(DbGoTop())
	nHandle := Fcreate(cFile)

	//Header
	cTexto := "00"							//campo01
	cTexto += "RELATO COMP NEGOCIOS"  		//campo02
	cTexto += SM0->M0_CGC	  				//campo03
	cTexto += GravaData(mv_par01, .F., 8)	//campo04
	cTexto += GravaData(mv_par02, .F., 8)	//campo05
	//if MV_PAR01 == MV_PAR02
	//	cTexto += "D"						//campo05
	//Elseif (MV_PAR02 - MV_PAR01) <= 7
	//	cTexto += "S"						//campo05
	//Elseif (MV_PAR02 - MV_PAR01) > 7 .and. (MV_PAR02 - MV_PAR01) <= 15
	//	cTexto += "Q"						//campo05
	//Elseif (MV_PAR02 - MV_PAR01) >= 15 .and. (MV_PAR02 - MV_PAR01) <= 31
	//	cTexto += "M"						//campo05
	//Else 
	cTexto += "S"						//campo05
	//EndIf

	cTexto += Space(15)						//campo06
	cTexto += Space(03)						//campo07
	cTexto += Space(29) 					//campo08
	cTexto += "V."							//campo09
	cTexto += "01"							//campo10
	cTexto += Space(26)						//campo11

	Fwrite(nHandle, cTexto + cEof)
	cCNPJ:= TRB1->A1_CGC
	cCGC := ""
	aACGC:= {}

	While TRB1->(!Eof())

		If SUBSTR(TRB1->A1_CGC,1,8) <> cCGC
			cCGC := SUBSTR(TRB1->A1_CGC,1,8)
			aACGC:=u_pegaCGC(TRB1->A1_CGC)
			lFirst:= .T.
		EndIf
		IncProc()

		If TRB1->E1_BAIXA > MV_PAR02
			TRB1->(DbSkip())
			Loop
		EndIf

		cTexto := ""
		If lfirst
			cTexto += "01" 								//campo01
			cTexto += aACGC[1]		  					//campo02
			cTexto += "01"								//campo03
			cTexto += Gravadata(aACGC[2],.F.,8) //campo04
			If aACGC[3] == "1"
				IF DDATABASE - aACGC[2] < 365
					cTexto += "2"						//campo05
				Else
					cTexto += "1"						//campo05
				EndIf
			Else
				cTexto += "3"						//campo05
			EndIf
			cTexto += Space(38)							//campo06
			cTexto += Space(34) 					  	//campo07
			cTexto += Space(01) 					  	//campo08
			cTexto += Space(30) 					   	//campo09
			nQuant++
			Fwrite(nHandle, cTexto + cEof)
			lFirst:= .f.
		Endif
		cTexto := ""
		cTexto += "01" 							   				//campo01
		cTexto += TRB1->A1_CGC		  							//campo02
		cTexto += "05"							   				//campo03
		IF TRB1->E1_TIPO <> "NCC"
			cNumDev:= Posicione("SD1",1,xFilial("SD1")+SE1->E1_NUM+E1_PREFIXO,"D1_NFORI")
			cTexto += iif(Empty(cNumDev),padr(TRB1->(E1_NUM),10),Padr(cNumDev,10))					//campo04
			cTexto += GravaData(TRB1->E1_EMISSAO, .F., 8)		//campo05
			cTexto += StrZero(TRB1->E1_VALOR*100, 13, 0) 		//campo06
		Else
			cTexto += padr(TRB1->(E1_NUM),10)					//campo04
			cTexto += GravaData(TRB1->E1_EMISSAO, .F., 8)		//campo05
			cTexto += "9999999999999"							//campo06
		EndIf
		cTexto += GravaData(TRB1->E1_VENCREA, .F., 8)			//campo07
		If EMPTY(TRB1->E1_BAIXA)
			cTexto += SPACE(8)									//campo08
		ELSE
			cTexto += GravaData(TRB1->E1_BAIXA, .F., 8)		//campo08
		ENDIF
		cTexto += "#D"+padr(TRB1->(E1_PREFIXO+E1_NUM+"-"+E1_PARCELA),32)	//campo09
		cTexto += Space(01)										//campo10
		cTexto += Space(24)										//campo11
		cTexto += Space(02)										//campo12
		cTexto += Space(01)										//campo13
		cTexto += Space(01)										//campo14
		cTexto += Space(02)										//campo15
		nQuant1++

		Fwrite(nHandle, cTexto + cEof)
		TRB1->(DbSkip())
		If TRB1->A1_CGC <> cCNPJ
			cCNPJ := TRB1->A1_CGC
		EndIf
	End
	//Trailler
	cTexto := ""
	cTexto += "99" 							   	   				//campo01
	cTexto += StrZero(Iif(MV_PAR03 == 1,nquant,0),11)  		//campo02
	cTexto += Space(44)						   					//campo03
	cTexto += StrZero(nquant1,11)  								//campo04
	cTexto += Space(11)											//campo05
	cTexto += Space(11)											//campo06
	cTexto += Space(10)											//campo07
	cTexto += Space(30)											//campo08

	Fwrite(nHandle, cTexto + cEof)
	TRB1->(DbCloseArea())
	Fclose(nHandle)
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMFIN003   บAutor  ณMicrosiga           บ Data ณ  01/04/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Gerar arquivo texto para envio ao SERASA                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function MFI03GER2()

	Local cFile   := Alltrim(MV_PAR04)
	Local cTexto  := ""
	Local cQuery  := ""
	Local cEof    := Chr(13) + Chr(10)
	Local nQuant  := 0
	Local nQuant1 := 0
	Local lFirst  := .T.
	Local cCnpj   := ""
	Local nHandle := 0
	Local nHandle1:= 0
	Local nTamId  := 3
	Local nTamReg := 131
	Local nBytes  := 0
	Local nLin    := 0
	Local aStru   := {}
	Local cLimite := ""
	Local cBaixa  := ""
	lOCAL cTitulo := "ATENวรO"

	If !File(cFile)
		MsgAlert("O arquivo informado nใo existe.", cTitulo)
		RestArea(aArea)
		Return
	Else
		nHandle1 := fOpen(cFile)
		If nHandle1 == -1
			MsgStop("O arquivo nใo pode ser aberto.", cTitulo)
			RestArea(aArea)
			Return
		EndIf
	EndIf

	fSeek(nHandle1, 0, 0)  // Volta no inicio do arquivo FS_SET = 0
	cLinha := ""
	nBytes := fRead(nHandle1, @cLinha, nTamReg)  
	nLin++

	aAdd( aStru, { "NUMERO",  "C", 009, 0 }	)
	aAdd( aStru, { "PREFIXO", "C", 003, 0 }	)
	aAdd( aStru, { "PARCELA", "C", 002, 0 }	)
	aAdd( aStru, { "BAIXA",   "D", 008, 0 }	)
	aAdd( aStru, { "LINHA",   "C", 200, 0 }	)

	If oTmpTable <> Nil
		oTmpTable:Delete()
		oTmpTable := Nil
	Endi

	oTmpTable := FWTemporaryTable():New("TRB")  
	oTmpTable:SetFields(aStru) 
	oTmpTable:AddIndex("1",{"NUMERO","PREFIXO","PARCELA"})
	oTmpTable:Create()  

	DBSELECTAREA("TRB") 
	Reclock("TRB",.T.)
	TRB->LINHA  := cLinha
	TRB->(MSUNLOCK())

	cLinha := ""
	nBytes := fRead(nHandle1, @cLinha, nTamReg)  
	nLin++

	While nBytes > 0

		If SubStr(cLinha,01,2) $ '01'
			Reclock("TRB",.T.)
			TRB->NUMERO := SubStr(cLinha,19,9)
			If  SubStr(cLinha,66,2) == "#D"
				TRB->PREFIXO:= iif( SubStr(cLinha,68,3) == "000","1  ", SubStr(cLinha,68,3))
				TRB->PARCELA:= SubStr(cLinha,78,2) 
			Else
				TRB->PREFIXO:= "1  "
			EndIf
			TRB->LINHA  := cLinha
			TRB->(MSUNLOCK())
		Else
			Reclock("TRB",.T.)
			TRB->LINHA  := cLinha
			TRB->(MSUNLOCK())
		EndIf 

		cLinha := ""
		nBytes := fRead(nHandle1, @cLinha, nTamReg)  
		nLin++

	End 

	nHandle := Fcreate("C:\Microsiga\Serasa\remessa\concilia"+dtos(ddatabase)+".TXT")

	DBSELECTAREA("TRB") 
	TRB->(DBGOTOP())
	cLimite:= Substr(TRB->LINHA,45,08) 
	While TRB->(!EOF())
		If SUBSTR(TRB->LINHA,1,2) == "00" .Or. SUBSTR(TRB->LINHA,1,2) == "99"
			Fwrite(nHandle, SUBSTR(TRB->LINHA,1,130)+cEof)
		Else
			//cBaixa:= DTOS(Posicione("SE1",1,xFilial("SE1")+TRB->(PREFIXO+NUMERO+PARCELA),"E1_BAIXA"))
			SE1->(DbSelectarea("SE1"))
			SE1->(DbSetOrder(1))
			If SE1->(DbSeek(xFilial("SE1")+TRB->(PREFIXO+NUMERO+PARCELA)))
				If Dtos(SE1->E1_BAIXA) > cLimite
					cBaixa:= SPACE(08)
				Else
					cBaixa:= Dtos(SE1->E1_BAIXA)
				EndIf
			Else                            
				cBaixa:=SPACE(08) //"NAOACHEI  "
			EndIf
			Fwrite(nHandle, Substr(TRB->LINHA,1,57)+cBaixa+Substr(TRB->LINHA,66,65)+ cEof)
		EndIf

		TRB->(DBSKIP())
	End

	TRB->(DbCloseArea())
	Fclose(nHandle)

	//MsgAlert("Arquivo Concilia gerado com sucesso")

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ PegaCGC  บAutor  ณMicrosiga           บ Data ณ  26/02/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Captura o CGC do Cliente que primeiro comprou na empresa.  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function PegaCGC(cCGC)

	Local aArea  := GetArea()
	Local cRet   := ""
	Local dPRICOM:= CTOD("  /  /  ")
	Local cBloq  := ""

	SA1->(DbSetOrder(3))
	SA1->(DbSeek(xFilial("SA1")+Substr(cCGC,1,8)))
	While SA1->(!EOF()) .AND. Substr(cCGC,1,8) == Substr(SA1->A1_CGC,1,8)
		If SA1->A1_PRICOM < dPRICOM .or. Empty(dPRICOM)
			cRet   := SA1->A1_CGC    
			dPRICOM:= SA1->A1_PRICOM 
			cBloq  := SA1->A1_MSBLQL 
		EndIf
		SA1->(DbSkip())
	End

	RestArea(aArea)        

Return({cRet,dPRICOM,cBloq})
