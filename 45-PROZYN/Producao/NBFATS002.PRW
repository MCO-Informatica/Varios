#INCLUDE 'Protheus.ch'
#INCLUDE 'TOPCONN.ch'
#include "TOTVS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NBFAT002   ºAutor  ³Denis Varella     º Data ³  02/08/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.  ³Ponto de entrada para validação da tabela de preço - C6_PRCVEN º±±
±±º          ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico                                                 º±±
±±º          ³ **** SOMENTE PROTHEUS ****                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function NBFAT002(nPreco,nQtd,nTotal)
	Local aArea    	:= GetArea()
	Local nRet     	:= nPreco
	Local cProduto 	:= trim(GDFieldGet("C6_PRODUTO",n))
	Local cTabela  	:= trim(M->C5_TABELA)
	Local cQuery	:=""
	Local cAliasDA1 := GetNextAlias()
	Local _nCount	:= 0
	Local cNat		:= ''
	Local cNaturezas
	Local aNaturezas
	Local nX := 0

	If !IsBLind() //Ajuste para não dar erro na Execauto da loja integrada. Gustavo Gonzalez - 05/11/2021

		///If (ALLTRIM(M->C5_NATUREZ) != '41908' .AND. ALLTRIM(M->C5_NATUREZ) != '41914' .AND. ALLTRIM(M->C5_NATUREZ) != '30008')
		cNaturezas := GETMV('MV_NATZTAB')
		aNaturezas := Separa(cNaturezas,';',.F.)

		For nX := 1 to len(aNaturezas)
			If cNat != ''
				cNat += "|"
			EndIf
			cNat += aNaturezas[nX]
		Next

//If (ALLTRIM(M->C5_NATUREZ) != '21003' .AND. ALLTRIM(M->C5_NATUREZ) != '21004' .AND. ALLTRIM(M->C5_NATUREZ) != '10307' )
		If (ALLTRIM(M->C5_NATUREZ) $ "'"+cNat+"'" )// .AND. !ALLTRIM(M->C5_TIPO) $ "C I P"
		Else
//	If !Empty(cTabela)  
			If !Empty(cTabela)
				If ! Empty(cProduto) .And. nPreco <> 0
					cQuery:= "SELECT top 1 * FROM " + RetSqlName('DA1') + " WHERE DA1_CODTAB = '" + cTabela + "' AND DA1_CODPRO = '" + cProduto + "' and D_E_L_E_T_ <> '*' order by DA1_DATVIG DESC"

					TcQuery cQuery New Alias (cAliasDA1)
					dbSelectArea(cAliasDA1)

					(cAliasDA1)->(DbGotOP())
					While !(cAliasDA1)->(EOF())
						_nCount++
						(cAliasDA1)->(dbSkip())
					Enddo


					(cAliasDA1)->(DbGotOP())
					If _nCount >= 1
						While !(cAliasDA1)->(EOF())
							If DTOS(dDatabase) < (cAliasDA1)->DA1_DATVIG
								MsgStop("Não existe uma tabela de preço ativa para este cliente.","BLOQUEIO")
								nRet := 0
							Else
								If nPreco == (cAliasDA1)->DA1_PRCVEN
									nRet := nPreco
								Else
									MsgStop('Ajustar o preço unitário, pois não corresponde aos valores pré-definidos na tabela de preço','BLOQUEIO')
									nRet := (cAliasDA1)->DA1_PRCVEN
								Endif
							Endif
							(cAliasDA1)->(dbSkip())
						Enddo
					Else
						MsgStop('Este produto não encontra-se na tabela de preço.','BLOQUEIO')
						nRet := 0
					EndIf

				Endif
			Else
				MsgStop('É necessário preencher o campo tabela.','BLOQUEIO')
				nRet := 0
			Endif

		Endif

		RestArea(aArea)
	EndIf
Return(nRet)
