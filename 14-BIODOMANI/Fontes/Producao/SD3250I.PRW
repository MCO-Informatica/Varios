#Include "Protheus.ch"
#Include "RwMake.ch"
#Include "TbiConn.ch"


USER FUNCTION SD3250I()

	Local _aArea :=GetArea()
    Local _aMata240 := {}
	Local _cMes := StrZero(Month(dDataBase+(365*3)),2) 	//----> PEGA O MES DAQUI 3 ANOS
	Local _cAno := strZero(Year(dDataBase+(365*3)),4)	//----> PEGA O ANO DAQUI 3 ANOS
	Local _cDia := Iif(_cMes$"02","28","30")			//----> SEMPRE DIA 30 (FEVEREIRO SEMPRE 28)
	Local _cDateVal := _cDia+"/"+_cMes+"/"+_cAno		//----> STRING COM DATA DE VALIDADE DO LOTE
	Local _nQtdeDif := SD3->D3_QUANT - Round((Posicione("SC2",1,xFilial("SC2")+SD3->D3_OP,"C2_QUANT")*0.9),0)	//----> QTDE TOTAL DA OP MENOS OS 90% INICIAIS DA OP
	Local _cLocal := "01A1"								//----> ARMAZEM LOOKLOG (ANTECIPANDO O ESTOQUE DA FABRICA)
	Local _cOp := SD3->D3_OP							//----> NUMERO DA ORDEM DE PRODUCAO
	Local _cProd := SD3->D3_COD							//----> CODIGO DO PRODUTO
	Local _cUm := SD3->D3_UM							//----> UNIDADE MEDIDA DO PRODUTO
	Local _cLote := SD3->D3_LOTECTL						//----> LOTE DO PRODUTO
	Local _dDtValid := SD3->D3_DTVALID					//----> DATA DE VALIDADE DO LOTE
	Local _cDoc := SD3->D3_DOC							//----> DOCUMENTO
	Local _cNumSeq := SD3->D3_NUMSEQ					//----> DOCUMENTO
	Local _nApont := Posicione("SD3",18,xFilial("SD3")+SUBS(_cOp,1,6)+_cProd+_cLocal+_cLote,"D3_QUANT") //----> QUANTIDADE JA APONTADA
    Local _nRecno := Recno()

	
    //----> GRAVA A ENTRADA NA TABELA DE MOVIMENTACAO INTERNA (SD3)
    dbSelectArea("SD3")
    _nRecno := Recno()
    Reclock("SD3",.T.)
    SD3->D3_FILIAL                  := xFilial("SD3")
    SD3->D3_TM                      := "002"
    SD3->D3_COD                     := _cProd
    SD3->D3_QUANT                   := _nQtdeDif
    SD3->D3_UM                      := _cUm
    SD3->D3_CF                      := "DE0"
    SD3->D3_LOCAL                   := "01A1"
    SD3->D3_DOC                     := _cDoc
    SD3->D3_EMISSAO                 := dDataBase
    SD3->D3_DOC                     := _cDoc
    SD3->D3_NUMSEQ                  := _cNumSeq
    SD3->D3_TIPO                    := Posicione("SB1",1,xFilial("SB1")+_cProd,"B1_TIPO")
    SD3->D3_USUARIO                 := CUSERNAME
    SD3->D3_CHAVE                   := "E0"
    SD3->D3_LOTECTL                 := _cLote
    SD3->D3_DTVALID                 := _dDtValid
    SD3->D3_STSERV                  := "1"
    SD3->D3_GARANTI                 := "N"
    MsUnLock()


    //----> GRAVA A ENTRADA NA TABELA DE MANUTENCAO DE LOTES (SD5)
    dbSelectArea("SD5")
    Reclock("SD5",.T.)
    SD5->D5_FILIAL                  := xFilial("SD5")
    SD5->D5_PRODUTO                 := _cProd
    SD5->D5_LOCAL                   := "01A1"
    SD5->D5_DOC                     := _cDoc
    SD5->D5_DATA                    := dDataBase
    SD5->D5_ORIGLAN                 := "002"
    SD5->D5_NUMSEQ                  := _cNumSeq
    SD5->D5_QUANT                   := _nQtdeDif
    SD5->D5_LOTECTL                 := _cLote
    SD5->D5_DTVALID                 := _dDtValid
    SD5->D5_PRMAIOR                 := "N"
    MsUnLock()

	MsgAlert("O apontamento da ordem de produção "+SC2->C2_NUM+" atualizou o armazém LookLog com sucesso!")

    dbSelectArea("SD3")
    dbGoto(_nRecno)

    DBSelectArea("SX1")
    DBSetOrder(1)
    nSpace := Len(SX1->X1_GRUPO) - 6
    If DbSeek("MTA300"+Space(nSpace)+"01")
        RecLock("SX1",.F.)
        SX1->X1_CNT01 := "01A1"
        MsUnlock()
    Endif
    If DbSeek("MTA300"+Space(nSpace)+"02")
        RecLock("SX1",.F.)
        SX1->X1_CNT01 := "01A1"
        MsUnlock()
    Endif
    If DbSeek("MTA300"+Space(nSpace)+"03")
        RecLock("SX1",.F.)
        SX1->X1_CNT01 := _cProd
        MsUnlock()
    Endif
    If DbSeek("MTA300"+Space(nSpace)+"04")
        RecLock("SX1",.F.)
        SX1->X1_CNT01 := _cProd
        MsUnlock()
    Endif

    MATA300()
    dbSelectArea("SD3")
    dbGoTo(_nRecno)

    /*
    //----> SO EXECUTA SE NAO HOUVE NENHUMA ENTRADA NO ARMAZEM 01A1 AINDA
	If _nApont == 0
		aAdd(_aMata240, {"D3_TM"      , "002"	                             , NIL})
		aAdd(_aMata240, {"D3_DOC"     , SUBS(_cOp,1,6)		                 , NIL})
		aAdd(_aMata240, {"D3_COD"     , _cProd			                     , NIL})
		aAdd(_aMata240, {"D3_UM"      , _cUm				                 , NIL})
		aAdd(_aMata240, {"D3_QUANT"   , _nQtdeDif                            , NIL})
		aAdd(_aMata240, {"D3_LOCAL"   , _cLocal      		                 , NIL})
		aAdd(_aMata240, {"D3_OP" 	  , _cOp	                             , NIL})
		aAdd(_aMata240, {"D3_EMISSAO" , dDataBase                            , NIL})

		//----> VERIFICA SE O PRODUTO CONTROLA LOTE (B1_RASTRO)
		If Rastro(_cProd)
			aAdd(_aMata240, {"D3_LOTECTL" , _cLote				             , NIL})
			aAdd(_aMata240, {"D3_DTVALID" , _dDtValid		                 , NIL})
		EndIf

		dbselectarea ("SD3")
		_lMSErroAuto := .F.
		msExecAuto({|x|MATA240(x)}, _aMata240, 3)

		If _lmserroauto
			mostraerro()
		Else
			MsgAlert("O apontamento da ordem de produção "+SUBS(_cOp,1,6)+" atualizou o armazém LookLog com sucesso!")
		EndIf
	Else
		MsgStop("Você já atualizou o estoque do armazém LookLog para esta ordem de produção "+SUBS(_cOp,1,6))
	EndIf*/


RestArea(_aArea)

Return


