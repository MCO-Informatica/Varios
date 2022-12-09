#include 'protheus.ch'

STATIC aPzOpAux	:= {} 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณACD100EMP บAutor  ณNBC                 บ Data ณ  17/05/2019 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Ponto de entrada do menu Ordem de Separacao               บฑฑ
ฑฑบ          ณ  Utilizada para adicionar funcao customizada               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function ACD100MNU()

	aRotina  := {{"Gerar-Prozyn","u_ACDAPRZ_GRAVA()",0,1} }

Return



User Function ACDAPRZ_GRAVA()
	Local aArea     := GetArea()
	Local aAreaCB8  := CB8->(GetArea())
	Local lCB8      := .F.
	Local cOrdSep   := ""
	Local cTipExp  := "00*08*09*"  //Pre-separacao
	Local cQrySZT := getNextAlias()
	Local cQryZT2 := getNextAlias()        
	Local cQryZT3 := getNextAlias()  
	Local cQryCB7 := getNextAlias()
	Local nX		:= 0
	Local cArqTmp	:= GetNextAlias()
	Local cOpAux	:= ""

	ACDA100_Grava()

	IF aArea[1] == 'SC2'

		If MsgYesNo( 'Deseja Criar OS Aglutinadora de Fracionados?', 'Ord.Separa็ใo' )

			//Esta posicionado na CB7

			//Verificar se existem itens fracionados para criar ord sep pre-separa็ao

			//Fazer somente apos a ultima Ordem de Separa็ao

			DbSelectArea("SZT")
			DbSetOrder(1) //ZT_FILIAL+ZT_ORDSEP+ZT_ITEM+ZT_PROD+ZT_LOCAL+ZT_LOTECTL

			cOpAux := ""
			For nX := 1 To Len(aPzOpAux)
				cOpAux += aPzOpAux[nX]+"|"
			Next 

			cQry2 := "SELECT ZT_PROD, ZT_LOCAL, ZT_LOTECTL, ZT_LCALIZ, SUM(ZT_QTDDIF) ZT_QTDDIF "
			cQry2 += " FROM " + RetSqlName("SZT") + " SZT "
			cQry2 += "WHERE "
			cQry2 += "SZT.D_E_L_E_T_ = ''
			cQry2 += "AND ZT_OP IN "+FORMATIN(cOpAux,"|")
			cQry2 += "Group by "
			cQry2 += "ZT_FILIAL,ZT_PROD, ZT_LOCAL, ZT_LOTECTL, ZT_LCALIZ"


			dbUseArea( .T., "TOPCONN", TcGenQry( ,, cQry2 ) , cQrySZT, .F., .T. )

			If !(cQrySZT)->(Eof())

				Begin Transaction


					CB7->(DbSetOrder(5))
					cOrdSep   := GetSX8Num( "CB7", "CB7_ORDSEP" )

					nW:=1
					While !(cQrySZT)->(Eof())

						//SZT->(DbGoTo((cQrySZT)->RECNO))

						
						CB8->(RecLock( "CB8", .T. ))
						CB8->CB8_FILIAL := xFilial( "CB8" )
						CB8->CB8_ORDSEP := cOrdSep
						CB8->CB8_OP     := ""
						CB8->CB8_ITEM   := IIF(NW<10,"0"+CVALTOCHAR(NW),CVALTOCHAR(NW))
						CB8->CB8_PROD   := (cQrySZT)->ZT_PROD
						CB8->CB8_LOCAL  := (cQrySZT)->ZT_LOCAL
						CB8->CB8_QTDORI := (cQrySZT)->ZT_QTDDIF
						CB8->CB8_SALDOS := (cQrySZT)->ZT_QTDDIF
						CB8->CB8_LCALIZ := (cQrySZT)->ZT_LCALIZ //Space(15)
						CB8->CB8_SEQUEN := ""
						CB8->CB8_LOTECT := (cQrySZT)->ZT_LOTECTL
						CB8->CB8_NUMLOT := " "
						CB8->CB8_CFLOTE := "1"
						CB8->CB8_TIPSEP := If("09*" $ cTipExp,"1"," ")

						lCB8  := .T.
						CB8->(MsUnLock())

						(cQrySZT)->(DbSkip())

						NW++
					Enddo

					If lCB8

						CB7->(DbSetOrder(1))
						CB7->(RecLock( "CB7", .T. ))
						CB7->CB7_FILIAL := xFilial( "CB7" )
						CB7->CB7_ORDSEP := cOrdSep
						CB7->CB7_OP     := ""
						CB7->CB7_LOCAL  := ""
						CB7->CB7_DTEMIS := dDataBase
						CB7->CB7_HREMIS := Time()
						CB7->CB7_STATUS := "0"   // gravar STATUS de nao iniciada somente depois do processo
						CB7->CB7_CODOPE := ""
						CB7->CB7_PRIORI := "1"
						CB7->CB7_ORIGEM := "3"
						CB7->CB7_TIPEXP := cTipExp
						CB7->CB7_TIPSEP  := "2"   //aglutinado de fra็๕es

						ConfirmSX8()

						//aAdd(aLogOS,{"1","OP","Aglutinadora","",CB7->CB7_LOCAL ,"",CB7->CB7_ORDSEP + If("09*" $ cTipExp,"-PRE-SEPARAวAO","-SEPARAวAO" )})

					EndIf

				End Transaction

			EndIf

			// GRAVAวรO DA AMARRAวรO ENTRE FRACOES COM A OS AGLUTINADA FRACIONADA.
			cQry3 := "SELECT R_E_C_N_O_ AS RECNO  "
			cQry3 += "FROM " + RetSqlName("SZT") + " SZT "
			cQry3 += "WHERE "
			cQry3 += "SZT.D_E_L_E_T_ = ''
			cQry3 += "AND ZT_OP IN "+FORMATIN(cOpAux,"|")			

			dbUseArea( .T., "TOPCONN", TcGenQry( ,, cQry3 ) , cQryZT2, .F., .T. )

			If !(cQryZT2)->(Eof())

				Begin Transaction


					While !(cQryZT2)->(Eof())

						SZT->(DbGoTo((cQryZT2)->RECNO))
						SZT->(RecLock( "SZT", .F. ))
						SZT->ZT_ORDSEP3 := cOrdSep
						SZT->(MsUnLock())

						(cQryZT2)->(DbSkip())

					Enddo

				End Transaction 

			Endif 

			If Len(aPzOpAux) > 0
				For nX := 1 To Len(aPzOpAux)
					cArqTmp := GetNextAlias()

					cQry4 := " SELECT R_E_C_N_O_ RECCB7 FROM "+RetSqlName("CB7")+" CB7 "
					cQry4 += " WHERE CB7.CB7_FILIAL = '"+xFilial("CB7")+"' "
					cQry4 += " AND CB7.CB7_OP = '"+aPzOpAux[nX]+"' "
					cQry4 += " AND CB7.CB7_TIPSEP NOT IN('1','2','3') "
					cQry4 += " AND CB7.D_E_L_E_T_ = ' ' "

					DbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQry4) , cArqTmp,.T.,.T.)

					Begin Transaction

						CB7->(DbSetOrder(1))
						While (cArqTmp)->(!Eof())

							CB7->( DbGoTo((cArqTmp)->RECCB7) )

							CB7->(RecLock( "CB7", .F. ))
							CB7->CB7_TIPSEP  := "1"   //inteira
							CB7->(MsUnLock())		

							(cArqTmp)->(DbSkip())
						EndDo

					End Transaction

					If Select(cArqTmp) > 0
						(cArqTmp)->(DbCloseArea())
					EndiF
				Next
			Endif 


			If Select(cQryZT3) > 0
				(cQryZT3)->(DbCloseArea())
			EndIf

			cQry4 := "SELECT DISTINCT ZT_ORDSEP AS ORDSEPI   "
			cQry4 += "FROM " + RetSqlName("SZT") + " SZT "
			cQry4 += "WHERE SZT.D_E_L_E_T_ = ''
			cQry4 += "AND ZT_OP IN "+FORMATIN(cOpAux,"|")

			dbUseArea( .T., "TOPCONN", TcGenQry( ,, cQry4 ) , cQryZT3, .F., .T. )

			(cQryZT3)->(Dbgotop())


			cQry5 := "SELECT COUNT (CB8_ITEM) AS ITENS FROM CB8010  WHERE CB8_ORDSEP = '"+ (cQryZT3)->ORDSEPI +"' AND D_E_L_E_T_ <> '*' "   

			IF SELECT("cQryCB7")>0
				cQryCB7->(DBCloseArea())
			EndIF

			dbUseArea( .T., "TOPCONN", TcGenQry( ,, cQry5 ) , cQryCB7, .F., .T. )      

			IF (cQryCB7)->ITENS == 0

				CB7->(DbSetOrder(1))  
				CB7->(dbSeek(xFilial("CB7")+(cQryZT3)->ORDSEPI) )
				CB7->(RecLock( "CB7", .F. )) 
				CB7->(DbDelete())
				CB7->(MsUnlock())

			Endif

			If Select(cQryCB7) > 0 
				(cQryCB7)->(DbCloseArea())
			EndIf            
			
		Else

			If Len(aPzOpAux) > 0
				For nX := 1 To Len(aPzOpAux)
					cArqTmp := GetNextAlias()

					cQry4 := " SELECT R_E_C_N_O_ RECCB7 FROM "+RetSqlName("CB7")+" CB7 "
					cQry4 += " WHERE CB7.CB7_FILIAL = '"+xFilial("CB7")+"' "
					cQry4 += " AND CB7.CB7_OP = '"+aPzOpAux[nX]+"' "
					cQry4 += " AND CB7.CB7_TIPSEP NOT IN('1','2','3') "
					cQry4 += " AND CB7.D_E_L_E_T_ = ' ' "

					DbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQry4) , cArqTmp,.T.,.T.)

					Begin Transaction

						CB7->(DbSetOrder(1))
						While (cArqTmp)->(!Eof())

							CB7->( DbGoTo((cArqTmp)->RECCB7) )

							CB7->(RecLock( "CB7", .F. ))
							CB7->CB7_TIPSEP  := "1"   //inteira
							CB7->(MsUnLock())		

							(cArqTmp)->(DbSkip())
						EndDo

					End Transaction

					If Select(cArqTmp) > 0
						(cArqTmp)->(DbCloseArea())
					EndiF
				Next
			Endif 

			cQry4 := "SELECT DISTINCT ZT_ORDSEP AS ORDSEPI   "
			cQry4 += "FROM " + RetSqlName("SZT") + " SZT "
			cQry4 += "WHERE "
			cQry4 += "SZT.D_E_L_E_T_ = ''
			cQry4 += "AND ZT_OP IN "+FORMATIN(cOpAux,"|")

			dbUseArea( .T., "TOPCONN", TcGenQry( ,, cQry4 ) , cQryZT3, .F., .T. )

			(cQryZT3)->(Dbgotop())

			cQry5 := "SELECT COUNT (CB8_ITEM) AS ITENS FROM CB8010  WHERE CB8_ORDSEP = '"+ (cQryZT3)->ORDSEPI +"' AND D_E_L_E_T_ <> '*' "   

			IF SELECT("cQryCB7")>0
				cQryCB7->(DBCloseArea())
			EndIF

			dbUseArea( .T., "TOPCONN", TcGenQry( ,, cQry5 ) , cQryCB7, .F., .T. )  


			IF (cQryCB7)->ITENS == 0

				CB7->(DbSetOrder(1))  
				CB7->(dbSeek(xFilial("CB7")+(cQryZT3)->ORDSEPI) )
				CB7->(RecLock( "CB7", .F. )) 
				CB7->(DbDelete())
				CB7->(MsUnlock())

			Endif      
			
			If Select(cQryCB7) > 0 
				(cQryCB7)->(DbCloseArea())
			EndIf            
			
			MsgInfo( 'Processo Finalizado', 'Ord. Separa็ใo' )

		Endif


	EndIf
	RestArea(aArea)
	RestArea(aAreaCB8)

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPZACDST1 บAutor  ณ	                 บ Data ณ  13/12/2019 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Atualiza็ใo da variavel statica para idetnficar as OPดs   บฑฑ
ฑฑบ          ณ  que foram selecionadas						              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function PZACDST1(cOp)

	Default cOp := ""

	aAdd(aPzOpAux, cOp)

Return 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPZACDGT1 บAutor  ณ		             บ Data ณ  13/12/2019 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Retorna a variavel com as OPดs preenchidas				  บฑฑ
ฑฑบ          ณ  											              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function PZACDGT1()
Return aPzOpAux 
