#INCLUDE 'PROTHEUS.CH'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT103FIM  ºAutor  ³                				20/05/2015º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada para atualziar entidades contabeis na tabelaº±±
±±           ³SE2 quando do item tiver o maior valor.                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Renova                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MT103FIM()

Local _nModulo   := PARAMIXB[1]
Local _nOpca     := PARAMIXB[2]

If INCLUI .and. _nOpca > 0 //.and. !Empty(SD1->D1_PEDIDO)
	
	_ATUSE2()
	
Endif

Return Nil

Static Function _ATUSE2()

Local _cQuery  := ''
Local _cQuery2 := ''
Local _cQuery3 := ''
Local _cQuery4 := ''
Local _cQuery4 := ''
Local _cAliasP  := GetNextAlias()
Local _nValorM := 0
Local _nValorV := 0
//Entidades Contabeis:
Local _cConta  := ''
Local _cCusto  := ''
Local _cItem   := ''
Local _cClasse := ''
Local _Enti05B := ''
Local _Enti05C := ''
//Fornecedores de retenções:
Local _FornMuc := Alltrim(GETMV("MV_MUNIC")) //ISS
Local _FornUni := Alltrim(GETMV("MV_UNIAO")) //PCC e IRRF
Local _FornIns := Alltrim(GETMV("MV_FORINSS"))  //INSS
Local _cTipPCC := Alltrim(GETMV("MV_BX10925")) //1-Baixa /\ 2-Emissão
Local _cTipIrf := Alltrim(GETMV("MV_VENCIRF")) //E-Emissão /\ V-Vencimento /\ C-Contabilidade
Local _cTipIss := Alltrim(GETMV("MV_VENCISS")) //E-Emissão /\ V-Vencimento /\ C-Contabilidade
Local _cTipIns := Alltrim(GETMV("MV_VENCINS")) //1-Emissão /\ 2-Vencimento
Local _lTipMPI := SuperGetMV("MV_MP447",.T.,.F.)

//Seleciona Dados da SD1 de maior valor da mesma nota.........
_cQuery := "SELECT D1_FILIAL, D1_DOC, D1_SERIE, D1_FORNECE, D1_LOJA, D1_TOTAL, D1_CONTA, D1_CC, D1_ITEMCTA, D1_CLVL, D1_EC05DB, D1_EC05CR FROM "+ RetsqlName("SD1") //PRECISA COLOCAR CLASSE DE VALORES E ENDIDADE 05
_cQuery += " WHERE D1_FILIAL = '"+xFilial("SF1")+"'"
_cQuery += " AND D1_DOC = '"+SF1->F1_DOC+ "'"
_cQuery += " AND D1_SERIE = '"+SF1->F1_SERIE+ "'"
_cQuery += " AND D1_FORNECE = '"+SF1->F1_FORNECE+ "'"
_cQuery += " AND D1_LOJA = '"+SF1->F1_LOJA+ "'"
_cQuery += " AND D_E_L_E_T_ <> '*'"

dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),_cAliasP,.T.,.T.)

(_cAliasP)->(DbGoTop())

Do While !(_cAliasP)->(Eof())
	
	_nValorM := (_cAliasP)->D1_TOTAL
	
	If _nValorM > _nValorV
		
		_nValorV := _nValorM
		_cConta  := (_cAliasP)->D1_CONTA
		_cCusto  := (_cAliasP)->D1_CC
		_cItem   := (_cAliasP)->D1_ITEMCTA
		_cClasse := (_cAliasP)->D1_CLVL
		_Enti05B := (_cAliasP)->D1_EC05DB
		_Enti05C := (_cAliasP)->D1_EC05CR
		
	EndIf
	
	(_cAliasP)->(DbSkip())
	
EndDo

//Atualiza entidades contabeis no contas a pagar Notas Fornecedores
_cQuery2 := "UPDATE " + RetSqlName("SE2") + " SET E2_DEBITO = '"+ _cConta +"'"
_cQuery2 += " , E2_CCD = '"+ _cCusto + "'"
_cQuery2 += " , E2_ITEMD = '"+ _cItem + "'"
_cQuery2 += " , E2_CLVLDB = '"+ _cClasse + "'"
_cQuery2 += " , E2_CREDIT = '"+ _cConta + "'"
_cQuery2 += " , E2_CCC = '"+ _cCusto + "'"
_cQuery2 += " , E2_ITEMC = '"+ _cItem + "'"
_cQuery2 += " , E2_CLVLCR = '"+ _cClasse + "'"
_cQuery2 += " , E2_EC05DB = '"+ _Enti05B + "'"
_cQuery2 += " , E2_EC05CR = '"+ _Enti05C + "'"
_cQuery2 += " WHERE E2_FILIAL = '"+xFilial("SF1")+"'"
_cQuery2 += " AND E2_FORNECE = '"+SF1->F1_FORNECE+ "'"
_cQuery2 += " AND E2_LOJA = '"+SF1->F1_LOJA+ "'"
_cQuery2 += " AND E2_PREFIXO = '"+SF1->F1_SERIE+ "'"
_cQuery2 += " AND E2_NUM = '"+SF1->F1_DOC+ "'"
_cQuery2 += " AND D_E_L_E_T_ <> '*'"

TCSQLEXEC(_cQuery2)

If _cTipIss <> 'V'
	//Atualiza entidades contabeis no contas a pagar Tipo TX - ISS
	_cQuery3 := "UPDATE " + RetSqlName("SE2") + " SET E2_DEBITO = '"+ _cConta +"'"
	_cQuery3 += " , E2_CCD = '"+ _cCusto + "'"
	_cQuery3 += " , E2_ITEMD = '"+ _cItem + "'"
	_cQuery3 += " , E2_CLVLDB = '"+ _cClasse + "'"
	_cQuery3 += " , E2_CREDIT = '"+ _cConta + "'"
	_cQuery3 += " , E2_CCC = '"+ _cCusto + "'"
	_cQuery3 += " , E2_ITEMC = '"+ _cItem + "'"
	_cQuery3 += " , E2_CLVLCR = '"+ _cClasse + "'"
	_cQuery3 += " , E2_EC05DB = '"+ _Enti05B + "'"
	_cQuery3 += " , E2_EC05CR = '"+ _Enti05C + "'"
	_cQuery3 += " WHERE E2_FILIAL = '"+xFilial("SF1")+"'"
	_cQuery3 += " AND E2_FORNECE = '"+_FornMuc+ "'"
	_cQuery3 += " AND E2_LOJA = '00'"
	_cQuery3 += " AND E2_PREFIXO = '"+SF1->F1_SERIE+ "'"
	_cQuery3 += " AND E2_NUM = '"+SF1->F1_DOC+ "'"
	_cQuery3 += " AND D_E_L_E_T_ <> '*'"
	
	TCSQLEXEC(_cQuery3)
	
EndIf

If _cTipIns = '1'
	//Atualiza entidades contabeis no contas a pagar Tipo TX - INSS
	_cQuery4 := "UPDATE " + RetSqlName("SE2") + " SET E2_DEBITO = '"+ _cConta +"'"
	_cQuery4 += " , E2_CCD = '"+ _cCusto + "'"
	_cQuery4 += " , E2_ITEMD = '"+ _cItem + "'"
	_cQuery4 += " , E2_CLVLDB = '"+ _cClasse + "'"
	_cQuery4 += " , E2_CREDIT = '"+ _cConta + "'"
	_cQuery4 += " , E2_CCC = '"+ _cCusto + "'"
	_cQuery4 += " , E2_ITEMC = '"+ _cItem + "'"
	_cQuery4 += " , E2_CLVLCR = '"+ _cClasse + "'"
	_cQuery4 += " , E2_EC05DB = '"+ _Enti05B + "'"
	_cQuery4 += " , E2_EC05CR = '"+ _Enti05C + "'"
	_cQuery4 += " WHERE E2_FILIAL = '"+xFilial("SF1")+"'"
	_cQuery4 += " AND E2_FORNECE = '"+_FornIns+ "'"
	_cQuery4 += " AND E2_LOJA = '00'"
	_cQuery4 += " AND E2_PREFIXO = '"+SF1->F1_SERIE+ "'"
	_cQuery4 += " AND E2_NUM = '"+SF1->F1_DOC+ "'"
	_cQuery4 += " AND D_E_L_E_T_ <> '*'"
	
	TCSQLEXEC(_cQuery4)
	
EndIf

If _cTipPCC = '2' .or. _cTipIrf <> 'V' .or. _lTipMPI
	//Atualiza entidades contabeis no contas a pagar Tipo TX - PCC + IRRF
	_cQuery5 := "UPDATE " + RetSqlName("SE2") + " SET E2_DEBITO = '"+ _cConta +"'"
	_cQuery5 += " , E2_CCD = '"+ _cCusto + "'"
	_cQuery5 += " , E2_ITEMD = '"+ _cItem + "'"
	_cQuery5 += " , E2_CLVLDB = '"+ _cClasse + "'"
	_cQuery5 += " , E2_CREDIT = '"+ _cConta + "'"
	_cQuery5 += " , E2_CCC = '"+ _cCusto + "'"
	_cQuery5 += " , E2_ITEMC = '"+ _cItem + "'"
	_cQuery5 += " , E2_CLVLCR = '"+ _cClasse + "'"
	_cQuery5 += " , E2_EC05DB = '"+ _Enti05B + "'"
	_cQuery5 += " , E2_EC05CR = '"+ _Enti05C + "'"
	_cQuery5 += " WHERE E2_FILIAL = '"+xFilial("SF1")+"'"
	_cQuery5 += " AND E2_FORNECE = '"+_FornUni+ "'"
	_cQuery5 += " AND E2_LOJA = '00'"
	_cQuery5 += " AND E2_PREFIXO = '"+SF1->F1_SERIE+ "'"
	_cQuery5 += " AND E2_NUM = '"+SF1->F1_DOC+ "'"
	_cQuery5 += " AND D_E_L_E_T_ <> '*'"
	
	TCSQLEXEC(_cQuery5)
	
EndIf     

(_cAliasP)->(DbCloseArea())

Return Nil