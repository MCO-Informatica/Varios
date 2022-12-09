
#INCLUDE "PROTHEUS.CH"

User Function RPCPG02()

    Local _cOp  := M->D3_OP
	Local _cMes := StrZero(Month(dDataBase+(365*3)),2) 	//----> PEGA O MES DAQUI 3 ANOS
	Local _cAno := strZero(Year(dDataBase+(365*3)),4)	//----> PEGA O ANO DAQUI 3 ANOS
	Local _cDia := Iif(_cMes$"02","28","30")			//----> SEMPRE DIA 30 (FEVEREIRO SEMPRE 28)
	Local _cDateVal := _cDia+"/"+_cMes+"/"+_cAno		//----> STRING COM DATA DE VALIDADE DO LOTE


    _cDateVal := CTOD(_cDateVal)

Return(_cDateVal)
