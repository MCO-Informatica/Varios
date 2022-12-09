#INCLUDE "Protheus.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M410DEL  ºAutor  ³Luiz Alberto V Alves º Data ³  01/03/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada na exclusao do Pedido de Venda para efetuarº±±
±±º          ³a volta da numeracao dos lacres							  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Metalacre                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
// DELETA A NUMERACAO NA EXCLUSAO DO PEDIDO
// EH EXECUTADO DEPOIS DO PONTO DE ENTRADA A410EXC

User Function MA410DEL()              

Local aArea := GetArea()
Local cMsg	:= ''
local RECZ01 := 0

dbSelectArea("SC6")
SC6->(dbSetOrder(1))
SC6->(dbSeek(xFilial("SC6")+SC5->C5_NUM ))  // Posiciona no item que esta sendo deletado

aAreaSC5	:= SC5->(GetArea())
aAreaSC6	:= SC6->(GetArea())
aAreaSC9	:= SC9->(GetArea())
aAreaSA1	:= SA1->(GetArea())

If cEmpAnt == '01' 
	If SC5->(dbSetOrder(1), dbSeek(xFilial("SC5")+SC5->C5_NUM)) .And. Empty(SC5->C5_PEDWEB)
		U_CargaPed(SC5->C5_NUM) // Ajusta Saldo Carga Fabrica
	Endif
Endif			
RestArea(aAreaSC5)
RestArea(aAreaSC6)
RestArea(aAreaSC9)
RestArea(aAreaSA1)


While SC6->(!Eof()) .And. SC6->C6_FILIAL + SC6->C6_NUM == xFilial("SC6")+SC5->C5_NUM //faz um while nos itens
	If !Empty(SC6->C6_XLACRE) 	// se o campo lacre nao estiver vazio
								//Se for EXCLUSAO, exclui o numero de lacre caso a personalizacao esteja configurada para reaproveitar numeros 

		dbSelectArea("Z00")
		Z00->(dbSetOrder(1))
		If Z00->(dbSeek(xFilial("Z00")+SC6->C6_XLACRE )) // procura o lacre na tabela Z00

			IF SELECT("TMP")  >0
				TMP->(DBCLOSEAREA())
			ENDIF 
			
			cQuery := "SELECT MAX(R_E_C_N_O_) AS RECZ01 "
			cQuery += "FROM "+RetSqlName("Z01")+" Z01 "
			cQuery += "WHERE Z01.Z01_FILIAL='"+xFilial("SC6")+"' AND "
			cQuery += "Z01.Z01_COD = '"+Z00->Z00_COD+"' AND "
			cQuery += "Z01.Z01_PV = '"+SC6->C6_NUM+"' AND "
			cQuery += "Z01.D_E_L_E_T_<>'*' " 
			     
			cQuery := ChangeQuery( cQuery )
			dbUseArea( .T., "TOPCONN", TcGenQry( , , cQuery ), 'TMP' )
			
			DBSELECTAREA("TMP")
			DBGOTOP() 
			
			IF !EOF()
				RECZ01 := TMP->RECZ01
			ENDIF
            
			IF RECZ01 <> 0
				IF SELECT("TMP")  >0
					TMP->(DBCLOSEAREA())
				ENDIF  
				
				cQuery := "SELECT R_E_C_N_O_ "
				cQuery += "FROM "+RetSqlName("Z01")+" Z01 "
				cQuery += "WHERE Z01.Z01_FILIAL='"+xFilial("SC6")+"' AND "
				cQuery += "Z01.Z01_COD = '"+Z00->Z00_COD+"' AND "
				cQuery += "Z01.R_E_C_N_O_ > " + ALLTRIM(STR(RECZ01)) +" AND "
				cQuery += "Z01.D_E_L_E_T_<>'*' AND Z01.Z01_COPIA <> 'C' " 
				     
				cQuery := ChangeQuery( cQuery )
				dbUseArea( .T., "TOPCONN", TcGenQry( , , cQuery ), 'TMP' ) 
				
				DBSELECTAREA("TMP")
				DBGOTOP() 
				
				lOk := .T.
				If !Empty(TMP->R_E_C_N_O_)
					lOk := .F.
				Endif
				
				TMP->(dbCloseArea())
				
				If !lOk

				Else
					RecLock("Z00",.f.)
						Z00->Z00_LACINI := Z00->Z00_LACINI - SC6->C6_QTDVEN
						Z00->Z00_LACRE  := Z00->Z00_LACRE - SC6->C6_QTDVEN 
					Z00->(MsUnlock())
					
				Endif
	
				IF SELECT("TMP")  >0
					TMP->(DBCLOSEAREA())
				ENDIF
				     
				// Exclusao da Linha do Item do Pedido na Personalizacao
				// de Lacres
				
				dbSelectArea("Z01")
				Z01->(dbSetOrder(1))
				If Z01->(dbSeek(xFilial("Z01")+SC6->C6_XLACRE+SC6->C6_NUM+SC6->C6_ITEM ))
					If RecLock("Z01",.f.)
						Z01->(dbDelete())
						Z01->(MsUnlock())
					Endif
				Endif  
			ENDIF
		Endif

	Endif
	
	SC6->(dbSkip(1))
Enddo

RestArea(aArea) 

Return .t.		
