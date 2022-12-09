#INCLUDE 'RWMAKE.CH'
#INCLUDE 'PROTHEUS.CH'

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³ RCOME002   ³ Autor ³ Adriano Leonardo    ³ Data ³ 16/06/16 ³±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina responsável por avaliar a base do CNPJ na inclusão  º±±
±±ºDesc.     ³ de um fornecedor e ajustar a codificação (código + loja)   º±±
±±ºDesc.     ³ seguindo o conceito de loja.                               º±±
±±ºDesc.     ³ Agrupando as filias no mesmo código.                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Específico para a empresa Prozyn               			  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function RCOME002()

Private _cRotina	:= "RCOME002"
Private _aSavArea	:= GetArea()
Private _cQuery		:= ""
Private _cAlias		:= GetNextAlias()
Private _cEnt		:= CHR(13) + CHR(10)

If Inclui .And. M->A2_TIPO<>"F" .And. !Empty(M->A2_CGC) .And. M->A2_EST<>"EX"
	
	_cQuery := "SELECT MAX(A2_COD) [A2_COD], MAX(A2_LOJA) [A2_LOJA] FROM " + RetSqlName("SA2") + " SA2 " + _cEnt
	_cQuery += "WHERE SA2.D_E_L_E_T_='' " + _cEnt
	_cQuery += "AND SA2.A2_FILIAL='" + xFilial("SA2") + "' " + _cEnt
	_cQuery += "AND SA2.A2_CGC<>'" + M->A2_CGC + "' " + _cEnt
	_cQuery += "AND SA2.A2_CGC LIKE '" + SubStr(M->A2_CGC,1,8) + "%' " + _cEnt
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),_cAlias,.T.,.F.)
	
	dbSelectArea(_cAlias)
	
	If (_cAlias)->(!EOF())
		If (_cAlias)->A2_COD <> Nil .And. !Empty((_cAlias)->A2_COD)
			M->A2_COD 	:= (_cAlias)->A2_COD
			M->A2_LOJA	:= Soma1((_cAlias)->A2_LOJA)
			
			_lVerifica	:= .T.
			
			dbSelectArea("SA2")
			dbSetOrder(1)
			While _lVerifica
				If dbSeek(xFilial("SA2")+M->A2_COD+M->A2_LOJA)
					M->A2_LOJA	:= Soma1(M->A2_LOJA)
				Else
					_lVerifica	:= .F.
				EndIf
			EndDo
		EndIf
	EndIf
	
	dbSelectArea(_cAlias)
	(_cAlias)->(dbCloseArea())
	
EndIf

RestArea(_aSavArea)

Return({M->A2_COD,M->A2_LOJA})