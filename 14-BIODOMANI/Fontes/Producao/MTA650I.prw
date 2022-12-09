#include 'protheus.ch'
#include 'parmtype.ch'
#Include "Totvs.ch"


User Function MTA650I()

	/*Local _aArea := GetArea()
	Local _aMata240 := {}
	Local _cMes := StrZero(Month(dDataBase+(365*3)),2) 	//----> PEGA O MES DAQUI 3 ANOS
	Local _cAno := strZero(Year(dDataBase+(365*3)),4)	//----> PEGA O ANO DAQUI 3 ANOS
	Local _cDia := Iif(_cMes$"02","28","30")			//----> SEMPRE DIA 30 (FEVEREIRO SEMPRE 28)
	Local _cDateVal := _cDia+"/"+_cMes+"/"+_cAno		//----> STRING COM DATA DE VALIDADE DO LOTE
	Local _nQtde := Round((SC2->C2_QUANT*0.9),0) 		//----> CONSIDERAR 90% DA QUANTIDADE DA OP
	Local _cLocal := "01A1"								//----> ARMAZEM LOOKLOG (ANTECIPANDO O ESTOQUE DA FABRICA)

	aAdd(_aMata240, {"D3_TM"      , "002"	                             , NIL})
	aAdd(_aMata240, {"D3_DOC"     , SC2->C2_NUM  		                 , NIL})
	aAdd(_aMata240, {"D3_COD"     , SC2->C2_PRODUTO		                 , NIL})
	aAdd(_aMata240, {"D3_UM"      , SC2->C2_UM			                 , NIL})
	aAdd(_aMata240, {"D3_QUANT"   , _nQtde						         , NIL})
	aAdd(_aMata240, {"D3_LOCAL"   , _cLocal      		                 , NIL})
	aAdd(_aMata240, {"D3_EMISSAO" , dDataBase                            , NIL})

	//----> VERIFICA SE O PRODUTO CONTROLA LOTE (B1_RASTRO)
	If Rastro(SC2->C2_PRODUTO)
		aAdd(_aMata240, {"D3_LOTECTL" , SUBS(SC2->C2_NUM,3,4)+SUBS(DTOC(DDATABASE),9,2)		                 , NIL})
		aAdd(_aMata240, {"D3_DTVALID" , CTOD(_cDateVal)                   , NIL})
	EndIf

	dbselectarea ("SD3")
	_lMSErroAuto := .F.
	msExecAuto({|x|MATA240(x)}, _aMata240, 3)

	If _lmserroauto
		mostraerro()
	Else
		MsgAlert("A abertura da ordem de produção "+SC2->C2_NUM+" atualizou o armazém LookLog com sucesso!")
	EndIf


	RestArea(_aArea)*/

Return Nil
