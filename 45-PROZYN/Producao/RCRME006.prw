#INCLUDE 'RWMAKE.CH'
#INCLUDE 'PROTHEUS.CH'

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³ RCRME006 ³ Autor ³ Adriano Leonardo    ³ Data ³ 29/09/2016 ³±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina de encerramento/abertura do forecast.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Específico para a empresa Prozyn               			  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function RCRME006()

Local _aSavArea := GetArea()
Local _aSavSZ2	:= SZ2->(GetArea())
Local _cMsg		:= ""
Local _cAlias	:= GetNextAlias()   
Local _nPrec	:= 0
Private _cRotina:= "RCRME006"
Private cPerg	:= "RCRME006"

_cMsg += "Atenção, está rotina irá fechar o budget de " + AllTrim(Str(Year(dDataBase)+1)) + " "
_cMsg += "ou reabrir o forecast do ano posterior para edição, escolha a opção desejada." + CHR(13) + CHR(10) + CHR(13) + CHR(10)
_cMsg += "Só utilize a opção de fechamento após todos os gerentes terem finalizado os lançamentos, caso precise ajustar outro período, altere a data base do sistema."

_nOpc := Aviso("Forecast",_cMsg,{"&Fechamento","&Abertura","&Cancelar"},3)

If _nOpc == 3
	MsgStop("Rotina cancelada pelo usuário",_cRotina+"_001")
	Return()
EndIf

_cQry := "SELECT Z2_PRODUTO, Z2_CLIENTE, Z2_LOJA, Z2_ANO, Z2_TOPICO, Z2_QTM01, Z2_QTM02, Z2_QTM03, Z2_QTM04, Z2_QTM05, Z2_QTM06, Z2_QTM07, Z2_QTM08, Z2_QTM09, Z2_QTM10, Z2_QTM11, Z2_QTM12, SZ2.R_E_C_N_O_ [Z2_RECNO] FROM " + RetSqlName("SZ2") + " SZ2 "
_cQry += "WHERE SZ2.D_E_L_E_T_='' "
_cQry += "AND SZ2.Z2_FILIAL='" + xFilial("SZ2") + "' "
_cQry += "AND SZ2.Z2_TOPICO='F' "
_cQry += "AND SZ2.Z2_ANO='" + StrZero(Year(dDataBase)+1,4) + "' "

If _nOPc == 1 //Fechamento
	_cQry += "AND SZ2.Z2_STATUS<>'F' "
ElseIf _nOPc == 2 //Abertura
	_cQry += "AND SZ2.Z2_STATUS='F' "
EndIf      

Memowrite("ForecastxBudget.txt",_cQry)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQry),_cAlias,.T.,.F.)

dbSelectArea(_cAlias)
dbGoTop()

While (_cAlias)->(!EOF()) 
	_nPrec      := U_RCRME007((_cAlias)->Z2_CLIENTE,(_cAlias)->Z2_LOJA,(_cAlias)->Z2_PRODUTO,StrZero(Year(dDataBase)+1,4),"2")  // inclusão do parametro para calculo do preço bruto - Daniel - 09/01/2019  
	
	dbSelectArea("SZ2")
	dbGoTo((_cAlias)->Z2_RECNO)
	
	If _nOpc == 1 //Fechamento
				
		dbSelectArea("SZ2")
		
		RecLock("SZ2",.F.)
			SZ2->Z2_STATUS := "F"
		SZ2->(MsUnlock())
		
		_lInclui := .T.
		
		dbSelectArea("SZ2")
		dbSetOrder(1)
		If dbSeek(xFilial("SZ2") + (_cAlias)->Z2_CLIENTE + (_cAlias)->Z2_LOJA + (_cAlias)->Z2_PRODUTO + StrZero(Year(dDataBase)+1,4) + "B")
			_lInclui := .F.
		EndIf
		
		dbSelectArea("SZ2")
		RecLock("SZ2",_lInclui)
			If _lInclui
				SZ2->Z2_FILIAL	:= xFilial("SZ2")
				SZ2->Z2_PRODUTO	:= (_cAlias)->Z2_PRODUTO
				SZ2->Z2_CLIENTE	:= (_cAlias)->Z2_CLIENTE
				SZ2->Z2_LOJA	:= (_cAlias)->Z2_LOJA
				SZ2->Z2_ANO		:= Year(dDataBase)+1
				SZ2->Z2_TOPICO	:= "B" //F=Forecast | B=Budget
			EndIf
			
			SZ2->Z2_QTM01	:= (_cAlias)->Z2_QTM01
			SZ2->Z2_QTM02	:= (_cAlias)->Z2_QTM02
			SZ2->Z2_QTM03	:= (_cAlias)->Z2_QTM03
			SZ2->Z2_QTM04	:= (_cAlias)->Z2_QTM04
			SZ2->Z2_QTM05	:= (_cAlias)->Z2_QTM05
			SZ2->Z2_QTM06	:= (_cAlias)->Z2_QTM06
			SZ2->Z2_QTM07	:= (_cAlias)->Z2_QTM07
			SZ2->Z2_QTM08	:= (_cAlias)->Z2_QTM08
			SZ2->Z2_QTM09	:= (_cAlias)->Z2_QTM09
			SZ2->Z2_QTM10	:= (_cAlias)->Z2_QTM10
			SZ2->Z2_QTM11	:= (_cAlias)->Z2_QTM11
			SZ2->Z2_QTM12	:= (_cAlias)->Z2_QTM12
			SZ2->Z2_PRECO01 := _nPrec //Preços incluído por Denis Varella ~ 29/12/2017
			SZ2->Z2_PRECO02 := _nPrec
			SZ2->Z2_PRECO03 := _nPrec
			SZ2->Z2_PRECO04 := _nPrec
			SZ2->Z2_PRECO05 := _nPrec
			SZ2->Z2_PRECO06 := _nPrec
			SZ2->Z2_PRECO07 := _nPrec
			SZ2->Z2_PRECO08 := _nPrec
			SZ2->Z2_PRECO09 := _nPrec
			SZ2->Z2_PRECO10 := _nPrec
			SZ2->Z2_PRECO11 := _nPrec
			SZ2->Z2_PRECO12 := _nPrec  
			SZ2->Z2_DATA	:= dDataBase
			SZ2->Z2_STATUS	:= "F" //Fechado
		SZ2->(MsUnlock())
	ElseIf _nOpc == 2 //Reabrir forecast posterior
		dbSelectArea("SZ2")
		
		RecLock("SZ2",.F.)
			SZ2->Z2_STATUS := "A"
		SZ2->(MsUnlock())
		
		
		_lInclui := .T.
		
		dbSelectArea("SZ2")
		dbSetOrder(1)
		If dbSeek(xFilial("SZ2") + (_cAlias)->Z2_CLIENTE + (_cAlias)->Z2_LOJA + (_cAlias)->Z2_PRODUTO + StrZero(Year(dDataBase)+1,4) + "B")
			_lInclui := .F.
		EndIf
		
		dbSelectArea("SZ2")
		RecLock("SZ2",_lInclui)
			If _lInclui
				SZ2->Z2_FILIAL	:= xFilial("SZ2")
				SZ2->Z2_PRODUTO	:= (_cAlias)->Z2_PRODUTO
				SZ2->Z2_CLIENTE	:= (_cAlias)->Z2_CLIENTE
				SZ2->Z2_LOJA	:= (_cAlias)->Z2_LOJA
				SZ2->Z2_ANO		:= Year(dDataBase)+1
				SZ2->Z2_TOPICO	:= "B" //F=Forecast | B=Budget
			EndIf
			SZ2->Z2_STATUS	:= "A" //Fechado
		SZ2->(MsUnlock())
	EndIf
	
	dbSelectArea(_cAlias)
	dbSkip()
EndDo

If _nOpc == 1
	MsgInfo("O budget de " + StrZero(Year(dDataBase)+1,4) + " foi encerrado com sucesso!",_cRotina+"_002")
ElseIf _nOpc== 2
	MsgInfo("O budget de " + StrZero(Year(dDataBase)+1,4) + " foi reaberto com sucesso!" ,_cRotina+"_003")
EndIf

RestArea(_aSavSZ2)
RestArea(_aSavArea)

Return()