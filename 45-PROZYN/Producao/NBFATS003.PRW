#INCLUDE 'Protheus.ch'
#INCLUDE 'TOPCONN.ch'
#include "TOTVS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NBFAT003   ºAutor  ³Denis Varella     º Data ³  03/08/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.   ³Ponto de entrada para validação da tabela de preço - C6_VALOR º±±
±±º          ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico                                                 º±±
±±º          ³ **** SOMENTE PROTHEUS ****                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function NBFAT003()
	Local aArea    := GetArea()
	Local nRet     := M->C6_PRCVEN
	Local cProduto := trim(GDFieldGet("C6_PRODUTO",n))
	Local cTabela  := trim(M->C5_TABELA)  
	Local cQuery:=""
	Local cAliasDA1 := GetNextAlias()
	Local _nCount	:= 0

	//If (ALLTRIM(M->C5_NATUREZ) != '41908' .AND. ALLTRIM(M->C5_NATUREZ) != '41914'.AND. ALLTRIM(M->C5_NATUREZ) != '30008')
	If (ALLTRIM(M->C5_NATUREZ) != '21003' .AND. ALLTRIM(M->C5_NATUREZ) != '21004'.AND. ALLTRIM(M->C5_NATUREZ) != '10307')
	//If ! Empty(cTabela)
		If ! Empty(cTabela) .AND. !ALLTRIM(M->C5_TIPO) $" C I P"
			If ! Empty(cProduto) .And. nRet <> 0
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
							nRet := 0
						Else
							If nRet != (cAliasDA1)->DA1_PRCVEN
								nRet := (cAliasDA1)->DA1_PRCVEN * aCols[N,aScan(aHeader,{|x| UPPER(AllTrim(x[2]))=="C6_QTDVEN" })]
							Else
								nRet := nRet * aCols[N,aScan(aHeader,{|x| UPPER(AllTrim(x[2]))=="C6_QTDVEN" })]
							Endif
						Endif
						(cAliasDA1)->(dbSkip())
					Enddo
				Else
					nRet := 0
				EndIf
			
			Endif
		Else
			nRet := 0
		Endif 
		
		
	Else   //Se for Amostra ou Bonificação ou Triangulação   
		nRet := nRet * aCols[N,aScan(aHeader,{|x| UPPER(AllTrim(x[2]))=="C6_QTDVEN" })]
	EndIf
		
	RestArea(aArea)
Return(nRet)		
