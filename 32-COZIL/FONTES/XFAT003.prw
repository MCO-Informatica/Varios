#INCLUDE "PROTHEUS.CH"

User Function XFAT003(cPar)
	
	Local nRevisao	:= 0  
	Local nMod		:= 0
	Local nMp			:= 0      
	
	If AllTrim(cPar) == "COD"	
		//Atribuicao do numero de revisao		
		dbSelectArea("SZ3")
		SZ3->(dbSetOrder(2))
		SZ3->(MsSeek(xFilial("SZ3") + M->Z3_PRODUTO))
		If SZ3->(EOF())
			M->Z3_REVISAO := "000"
		Else
			//Percorre a tabela procurando o ultimo registro 
			While !SZ3->(EOF()) .And. AllTrim(SZ3->Z3_PRODUTO) == AllTrim(M->Z3_PRODUTO)
				SZ3->(dbSkip())
			EndDo
			SZ3->(dbSkip(-1))
			M->Z3_REVISAO := StrZero(Val(SZ3->Z3_REVISAO) + 1, 3)
		EndIf
	EndIf
	
	// VERIFICA A UTILIZACAO DOS CAMPOS DE SIMULACAO
	If M->Z3_SIMMP <= 0
		nMp := M->Z3_MP
	Else
		nMp := M->Z3_SIMMP				
	EndIf
	
	If M->Z3_SIMMOD <= 0
		nMod := M->Z3_MOD
	Else
		nMod := M->Z3_SIMMOD
	EndIf
		
	// SOMA DAS %
	M->Z3_SOMA := 	M->Z3_ADM + M->Z3_COMERC + M->Z3_LUCRO + M->Z3_COMGER +;
								M->Z3_COMVEN + M->Z3_PROMO + M->Z3_MKT + M->Z3_RAPEL + M->Z3_CROSDOC+;
								M->Z3_RISCO + M->Z3_COFINS + M->Z3_PIS + M->Z3_ICMS + M->Z3_IR + M->Z3_CSSL
	
	// CALCULA PRECO
	M->Z3_PRECO := (nMod + nMp) / (1 - M->Z3_SOMA / 100)	
	
	// CALCULA MARGEM DE NEGOCIACAO
	M->Z3_VALNEG := M->Z3_PRECO / ((100 - M->Z3_MGNEG) / 100)    
	
	// CALCULA LUCRO LIQUIDO
	M->Z3_LIQUIDO := M->Z3_VALNEG * M->Z3_LUCRO / 100
	                    
	// NOME DO USUARIO
	If AllTrim(M->Z3_USUAR) == ""
		M->Z3_USUAR := UsrRetName(RetCodUsr())                                                                             
	EndIf
	
//Return()	
Return(M->Z3_PRODUTO) 