#INCLUDE "Protheus.ch"
#INCLUDE "TopConn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMTA410E   บAutor  ณBruno Daniel Abrigo บ Data ณ  14/03/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Apos deletar o registro do SC6 (Itens dos pedidos de vendasบฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Metalacre                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

// VERIFICA SE PODERA VOLTAR A NUMERACAO DO LACRE CASO EXISTA ALGUMA NUMERACAO SUPERIOR

User Function A410EXC()   
Local lAchou := .F.

If cEmpAnt <> '01'
	Return .T.
Endif

dbSelectArea("SC6")
SC6->(dbSetOrder(1))
SC6->(dbSeek(xFilial("SC6")+M->C5_NUM ))
While SC6->(!Eof()) .And. SC6->C6_FILIAL + SC6->C6_NUM == xFilial("SC6")+M->C5_NUM .and. !lachou
	If !Empty(SC6->C6_XLACRE)
		//Se for EXCLUSAO, exclui o numero de lacre caso a personalizacao esteja configurada para reaproveitar numeros
		dbSelectArea("Z00")
		Z00->(dbSetOrder(1))
		If Z00->(dbSeek(xFilial("Z00")+SC6->C6_XLACRE ))

			IF SELECT("TMP")  >0
				TMP->(DBCLOSEAREA())
			ENDIF
			cQuery := "SELECT MAX(R_E_C_N_O_) AS RECNOZ01"
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
				RECZ01 := TMP->RECNOZ01
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
				lOk := .t.
				If !Empty(TMP->R_E_C_N_O_) .and. !TMP->(eof())
					lOk := .f.
				Endif
				
				TMP->(dbCloseArea())
				
				If !lOk
					LACHOU := .T.
					cMsg := 'Pedido No. ' + M->C5_NUM + ' Numera็ใo Nใo Retornada Devido Existir Pedidos Superiores. Deseja Continuar? ' + Chr(13) + Chr(10)
					if MsgYesNo(cMsg)
					
					else
						lRet := .f.
						return lRet
					endif
				Endif
	
				IF SELECT("TMP")  >0
					TMP->(DBCLOSEAREA())
				ENDIF
			ENDIF	     
        ENDIF
	Endif
	
	SC6->(dbSkip(1))
Enddo


Return .t.		
