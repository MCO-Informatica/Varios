#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³  mta410OK  ³ Autor ³ Denis Varella       ³ Data ³ 02/08/17 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Ponto de Entrada para calculo do total de volumes          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ 															  ³±±
±±³          ³                                                            ³±±
±±³          ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function MT410TOK()
	Local nOpc := ''
	Local nW := 0    
	Local nB := nNewV := 0
	Local aST := {}
	Local _lRet		:= .T.
	Local cCodULib	:= U_MyNewSX6("CV_USLBAPV", ""	,"C","Usuarios liberados a alterar pedido, sem interferir no bloqueio", "", "", .F. )
	Local cCodUsr	:= Alltrim(RetCodUsr())
	Local lAtcl  	:= SuperGetMv('MV_ATICL',,.T.)  // ativar ou não o calculo do ciclo do pedido
	Local nX		:= 0
	Local i 		:= 0	
	Local _nDiasTol := SuperGetMV("MV_DIASTOL",,15) //Dias para tolerância de atraso médio para liberação do pedido
	Local nOldValor := 0
	Local nNewValor := 0

	Local nOldQtd := 0
	Local nNewQtd := 0
	Local lDuplic := .F.
	
	Private lNbRet := .F.
	Private oDlgPvt
	//Says e Gets
	Private oSayUsr
	Private oGetUsr, cGetUsr := Space(25)
	Private oSayPsw
	Private oGetPsw, cGetPsw := Space(20)
	Private oGetErr, cGetErr := ""
	//Dimensões da janela
	Private nJanLarg := 200
	Private nJanAltu := 200
	nOpc := PARAMIXB[1] 
	SetPrvt("_CNUMPED,_NTOTAL,I,_NPOSPEC,_NVALOR,M->C5_VOLUME1")

	//Validação da data de faturamento
	/*If !VldDtFat()
	Return .F.
	EndIf*/

	If ALTERA
		cQry := "SELECT CB7_ORDSEP FROM CB7010 WHERE CB7_PEDIDO = '"+M->C5_NUM+"' and D_E_L_E_T_ = '' "
		dbUseArea(.T.,"TOPCONN", TCGenQry(,,cQry),'PEDSEP',.T.,.T.)

		If PEDSEP->(!Eof())
			If !empty(PEDSEP->CB7_ORDSEP) .and. M->C5_FECENT != SC5->C5_FECENT
				MsgAlert("Este pedido possui ordem de separação: "+trim(PEDSEP->CB7_ORDSEP)+", impossível alterar a data de entrega.","Atenção!")
				Return .F.
			EndIf
		EndIf

		PEDSEP->(DbCloseArea())
	EndIf

	If !(Alltrim(cCodUsr) $ Alltrim(cCodULib)) .And. lAtcl
		//Validação da data do PCP
		If !U_PZ410PCP()
			Return .F.
		EndIf

		//Validação do forecast
		If !U_PZCVV204()
			Return .F.
		EndIf
	EndIf

	//Validação do armazem CQ
	If !VldArmzCq()
		Return .F.
	EndIf
	nPosITEM   := aScan(aHeader,{|x| AllTrim(x[2])=="C6_ITEM"})
	nPosTES    := aScan(aHeader,{|x| AllTrim(x[2])=="C6_TES"})
	nPosCFOP   := aScan(aHeader,{|x| AllTrim(x[2])=="C6_CF"})

	_nPosPec  	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_QTDVEN" })
	_nPosLib  	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_QTDLIB" })
	_nPosPro  	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRODUTO" })
	_nPosUm	  	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_UM" })

	nPosDesc	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_DESCRI" })

	_cNumPed := M->C5_NUM
	_cCodCli := M->C5_CLIENTE
	_cLjCli  := M->C5_LOJACLI

	_nTotal  := 0         //M->C5_VOLUME1
	_nPesoT	 := 0		  //M->C5_PESOL
	_nPesoTB := 0		  //M->C5_PESBRU
	_cEspc 	 := ""
	cProd	 := ""


	IF SM0->M0_CODFIL == "02"
		RETURN(.T.)
	Endif	    

	IF SM0->M0_ESTCOB ==  "PA"
		RETURN(.T.)
	EndIf	

	If  INCLUI .OR. ALTERA     //MODIFICADO EM 02/07/2001

		For I := 1 to len(aCols)
			If aCols[I,Len(aHeader)+1] == .F.  //verifica se nao esta deletado
				If !lDuplic .and. Posicione("SF4",1,xFilial("SF4")+aCols[I,aScan(aHeader,{|x| Upper(AllTrim(x[2]))=="C6_TES"})],"F4_DUPLIC") == 'S'
					lDuplic := .T.
				EndIf
				nNewValor += aCols[I,aScan(aHeader,{|x| Upper(AllTrim(x[2]))=="C6_VALOR"})]
				If AllTrim(GetAdvFVal("SA7","A7_XSEGMEN",xFilial("SA7")+_cCodCli+_cLjCli+aCols[I,_nPosPro],1))  == "" .And. ((M->C5_TIPO <> 'B') .And. (M->C5_TIPO <> 'D')) 
					MsgStop("Segmento não preenchido na amarração:"+Chr(13) + Chr(10)+Chr(13) + Chr(10)+"Cliente: "+AllTrim(M->C5_NOMECLI)+Chr(13) + Chr(10)+"Produto: "+AllTrim(aCols[I,nPosDesc]),"BLOQUEIO")
					Return .F.
				EndIf
				_nValor   := (Posicione("SB1",1,xFilial("SB1") + aCols[I,_nPosPro],"B1_PESO") * aCols[I,_nPosPec]) / Posicione("SB1",1,xFilial("SB1") + aCols[I,_nPosPro],"B1_QE")
				_nPesoL	  := (Posicione("SB1",1,xFilial("SB1") + aCols[I,_nPosPro],"B1_PESO") * aCols[I,_nPosPec])
				_nPesoT	  += _nPesoL
				_nPesoB	  := _nPesoL + (_nValor * (Posicione("SB1",1,xFilial("SB1") + aCols[I,_nPosPro],"B1_PESOEMB")))
				_nPesoTB  += _nPesoB
				_nTotal   += _nValor
				If _cEspc != "" .AND. _cEspc != Posicione("SB1",1,xFilial("SB1") + aCols[I,_nPosPro],"B1_ESPVEND")
					_cEspc	  := "VOLUMES"
				Else
					_cEspc 	  := Posicione("SB1",1,xFilial("SB1") + aCols[I,_nPosPro],"B1_ESPVEND")
				Endif
				If len(aST) > 0   
					For nX := 1 to len(aST) 
						If aST[nX][1] == aCols[I,_nPosPro] .and. aST[nX][2] != aCols[I,aScan(aHeader,{|x| UPPER(AllTrim(x[2]))=="C6_CLASFIS" })]
							MsgStop("Situação Tributária divergente entre itens do pedido.","BLOQUEIO")
							Return .F.
						EndIf
					Next        
				EndIf
				aAdd(aST,{aCols[I,_nPosPro],aCols[I,aScan(aHeader,{|x| UPPER(AllTrim(x[2]))=="C6_CLASFIS" })]})
			EndIf
		Next

		If !M->C5_YESPPES
			//If(ALLTRIM(M->C5_ESPECI1)) == ''
			M->C5_ESPECI1 := _cEspc
			If _nTotal < 1
				_nTotal := 1
			Endif
			M->C5_VOLUME1 := _nTotal
			//Endif

			If _nPesoT != 0
				M->C5_PESOL   := _nPesoT  
				M->C5_PBRUTO  := _nPesoTB 
			Endif
		EndIf 
	Endif

	If Altera

		M->C5_ALTDT:= dDatabase                  
		M->C5_ALTHORA:= TIME()
		M->C5_ALTUSER:= USRRETNAME(__CUSERID)

	EndIf                                     

	If Inclui .Or. Altera

		If ExistBlock("RFATE007")
			_lRet := ExecBlock("RFATE007") //Chamada de rotina para atualização dos percentuais de comissão para vendedor nos itens do pedido de venda
		EndIf

		For nW := 1 To len(aCols)                 
			nDiasLau  := POsicione("SA7",1,xFilial("SA7") + M->C5_CLIENTE + M->C5_LOJACLI + acols[nW,Ascan(aHeader,{|x| Upper(AllTrim(x[2]))=="C6_PRODUTO"})] , 'A7_ANTEMPO' )   
			nDiasProd := POsicione("SB1",1,xFilial("SB1") + acols[nW,Ascan(aHeader,{|x| Upper(AllTrim(x[2]))=="C6_PRODUTO"})],'B1_PE' )
			aCols[nW,aScan(aHeader,{|x| Upper(AllTrim(x[2]))=="C6_CC" })] := Posicione('SB1',1,xfilial('SB1')+aCols[nW,_nPosPro], 'B1_CC')   
			aCols[nW,aScan(aHeader,{|x| Upper(AllTrim(x[2]))=="C6_CONTA" })] := Posicione('SB1',1,xfilial('SB1')+aCols[nW,_nPosPro], 'B1_CONTA')   
			aCols[nW,aScan(aHeader,{|x| Upper(AllTrim(x[2]))=="C6_ITEMCTA" })] := Posicione('SB1',1,xfilial('SB1')+aCols[nW,_nPosPro], 'B1_ITEMCC')   
			aCols[nW,aScan(aHeader,{|x| Upper(AllTrim(x[2]))=="C6_CLVL" })] := Posicione('SB1',1,xfilial('SB1')+aCols[nW,_nPosPro], 'B1_CLVL')    

		Next


	EndIf                            

	If lAtcl == .T. .And. !(Alltrim(cCodUsr) $ Alltrim(cCodULib))     

		If Inclui .Or. Altera // bloqueio valor minimo de faturamento. 

			nMinFt := SuperGetMv('MV_VLMIFAT',,2000)  

			If M->C5_MOEDA == 1 
				nTxmd:= 1
			else
				If M->C5_TXMOEDA == 0
					Aviso("Atenção-Tx.Moeda","Por gentileza, preencher a Tx.PTAX. ",{"Ok"},2)
					Return .F.
				Else
					nTxmd:= M->C5_TXMOEDA
				EndIf
			endif

			nValor:= aCols[1,aScan(aHeader,{|x| Upper(AllTrim(x[2]))=="C6_VALOR"})] * nTxmd 

			For nW := 2 To len(aCols)                 
				nValor+= aCols[nW,aScan(aHeader,{|x| Upper(AllTrim(x[2]))=="C6_VALOR"})]* nTxmd		
			Next
			
			

			If Alltrim(Posicione("SF4",1,xFilial("SF4") + aCols[1,aScan(aHeader,{|x| Upper(AllTrim(x[2]))=="C6_TES"})] , 'F4_DUPLIC' )) == "S"

				IF nValor < nMinFt
					If Aviso("Atenção-Faturamento Mínimo"," Este pedido não atingiu o valor mínimo de Faturamento!!"+CRLF+"Deseja Continuar? ",{"Sim","Não"},2)==2
						Return(.F.)
					EndIf

				Endif

			Endif
		Endif
	Endif

	If Altera


		DbSelectArea("SC6")
		SC6->(DbSetOrder(1))
		If SC6->(DbSeek(xFilial("SC6")+M->C5_NUM))
			While SC6->(!EOF()) .AND. SC6->C6_FILIAL == xFilial("SC6") .AND. SC6->C6_NUM == M->C5_NUM
				nOldValor += SC6->C6_VALOR
				nOldQtd += SC6->C6_QTDVEN
				SC6->(DbSkip())
			EndDo
		EndIf
		For nNewV := 1 To len(aCols)
			If !aCols[nNewV,Len(aHeader)+1]
				nNewQtd += aCols[nNewV,aScan(aHeader,{|x| Upper(AllTrim(x[2]))=="C6_QTDVEN"})]
			EndIf
		Next nNewV

		If (nNewQtd > 0 .and. (nNewQtd != nOldQtd .or. M->C5_FECENT != SC5->C5_FECENT))
			If trim(M->C5_YTPBLQ) == 'OK'
				M->C5_YTPBLQ := ""
			EndIf
			U_WFALTPED(nNewQtd != nOldQtd,M->C5_FECENT != SC5->C5_FECENT)
		EndIf
		
	EndIf
	//Novo bloqueio financeiro ~ Denis Varella 01/06/2021
	M->C5_XBLQFIN := ''
	If M->C5_TIPO == 'N' .and. lDuplic
		If ((SA1->A1_METR > _nDiasTol .And. SA1->A1_ATR > 0) .OR. M->C5_CONDPAG $ GetMv("MV_BLQFCND") .OR. (nNewValor > SA1->A1_LC - SA1->A1_SALDUP)) 
			If (Inclui .or. (Altera .and. (nNewQtd != nOldQtd .or. M->C5_FECENT != SC5->C5_FECENT .or. nNewValor != nOldValor)))
				MsgAlert("Cliente passará por análise financeira para liberação.","Bloqueio Financeiro")
				M->C5_XBLQFIN := 'B'
				For nB := 1 to len(aCols)
					aCols[nB,_nPosLib] := 0
				Next nB
			EndIf
		EndIf
	EndIf

Return(.T.)   



// Static Function fVdUsr2()       
// 	Local cAprCic 	:= SuperGetMv('MV_APRVCL1',,"newbridge") //definir os aprovadores 
// 	Local cUsrAux := Alltrim(cGetUsr)
// 	Local cPswAux := Alltrim(cGetPsw)
// 	Local cCodAux := ""

// 	//Pega o código do usuário
// 	PswOrder(2)
// 	If !Empty(cUsrAux) .And. PswSeek(cUsrAux) .And. cUsrAux $ cAprCic //compara com o parametro de aprovadores 
// 		cCodAux := PswRet(1)[1][1]

// 		//Agora verifica se a senha bate com o usuário
// 		If !PswName(cPswAux)
// 			cGetErr := "Senha inválida!"
// 			oGetErr:Refresh()
// 			Return

// 			//Senão, atualiza o retorno como verdadeiro
// 		Else
// 			lNbRet := .T.
// 		endif

// 		//Senão atualiza o erro e retorna para a rotina
// 	Else
// 		cGetErr := "Usuário não Autorizado!"
// 		oGetErr:Refresh()
// 		Return
// 	EndIf



// 	//Se o retorno for válido, fecha a janela
// 	If lNbRet
// 		oDlgPvt:End()
// 	EndIf
// Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³VldDtFat		ºAutor  ³Microsiga	     º Data ³  27/02/2019 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Validação da data de previsão de faturamento				  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Ap		                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
// Static Function VldDtFat()

// 	Local nX			:= 0
// 	Local dDtPrevFat	:= M->C5_FECENT
// 	Local nPosDt		:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_ENTREG" })
// 	Local lRet			:= .T.

// 	For nX := 1 To Len(aCols)
// 		If dDtPrevFat < aCols[nX][nPosDt]
// 			Aviso("Atenção","A data 'Prev. Fat.' não pode ser menor que a data 'Entrega PCP'",{"Ok"},2)
// 			lRet	:= .F.
// 			Exit
// 		EndIf
// 	Next

// 	If !U_PZCVV004(dDtPrevFat)
// 		lRet := .F.
// 	EndIf

// Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³VldArmzCq		ºAutor  ³Microsiga	     º Data ³  29/05/2019 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Validação de armazem										  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Ap		                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function VldArmzCq()

	Local aArea 	:= GetArea()
	Local lRet		:= .T.
	Local cArmCq  	:= SuperGetMv('MV_CQ',,"98")
	Local nPosLoc   := aScan(aHeader,{|x| Upper(AllTrim(x[2]))=="C6_LOCAL"})
	Local nX		:= 0

	For nX := 1 To Len(aCols)
		If Alltrim(aCols[nX][nPosLoc]) == Alltrim(cArmCq)
			lRet := .F.
			Help(" ",1,"ARMZCQ",,GetMv("MV_CQ"),2,15)
			exit
		EndIf
	Next

	RestArea(aArea)
Return lRet
