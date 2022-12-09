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

User Function MTA410E()

// Bruno Abrigo em 14.05.12
// tratamento multi-empresas
If cEmpAnt <> '01'
	Return
Endif

U_POSGRAVA()

RptStatus( {||  U_Ajuste() }, "Aguarde recalculando...","Ajustando Itens deletados...", .T. )
Return 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAjuste    บAutor  ณBruno Daniel Abrigo บ Data ณ  04/24/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Diversos ajustes desenvolvidos para recalcular seq lacre   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Metalacre                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function Ajuste(pedajus)                                                  '

Local cQry			:=""
Local aAreaSC6  	:= SC6->(GetArea())
Local nCont:=0
Local nLacreHist	:=0
Local lOk           :=.T.
Local _nRec         :=0
    
IF EMPTY(PEDAJUS)

ELSE
	DBSELECTAREA("SC6")
	DBSETORDER(1)
	DBSEEK(XFILIAL("SC6") + PEDAJUS )
	aAreaSC6  	:= SC6->(GetArea())
ENDIF

/*
cQry:= " SELECT Z01_COD, Z01_PV, Z01_ITEMPV,Z01_PROD,Z01_INIC,Z01_FIM,C6_QTDVEN,Z01.R_E_C_N_O_,Z01_OP,Z01_STAT,CASE WHEN C6_RECALC IS NULL THEN '1' ELSE C6_RECALC END C6_RECALC  FROM "+RETSQLNAME("Z01")+" Z01 WITH(NOLOCK) "+CRLF
cQry+= " INNER JOIN "+RETSQLNAME("SC6")+" SC6 WITH(NOLOCK) ON C6_PRODUTO = Z01_PROD AND C6_XLACRE = Z01_COD  AND C6_ITEM = Z01_ITEMPV AND SC6.D_E_L_E_T_  <> '*' AND Z01_PV = C6_NUM "+CRLF
cQry+= "WHERE  Z01_COD = '"+Alltrim(SC6->C6_XLACRE)+"'  AND Z01_FILIAL = '"+xFilial("SC6")+"' AND Z01.D_E_L_E_T_  <> '*' AND Z01_STAT <> '4' AND C6_RECALC <> '2' "+CRLF
cQry+= "GROUP BY Z01_COD, Z01_PV, Z01_ITEMPV,Z01_PROD,Z01_INIC,Z01_FIM,C6_QTDVEN,Z01_STAT ,Z01.R_E_C_N_O_,Z01_OP,Z01_STAT "+CRLF
cQry+= "ORDER BY Z01.R_E_C_N_O_ --Z01_PV,Z01_ITEMPV "+CRLF
*/

cQry:= " SELECT Z01_COD, Z01_PV, Z01_ITEMPV,Z01_PROD,Z01_INIC,Z01_FIM,Z01_FIM-Z01_INIC+1 C6_QTDVEN,Z01.R_E_C_N_O_ 'REC' ,Z01_OP,Z01_STAT, "
cqry += "  Z01_COPIA, CASE WHEN C6_RECALC IS NULL THEN '1' ELSE C6_RECALC END C6_RECALC FROM  "+RETSQLNAME("Z01")+" Z01 WITH(NOLOCK) "+CRLF
cQry+= "  LEFT OUTER JOIN  "+RETSQLNAME("SC6")+" SC6 WITH(NOLOCK) ON C6_PRODUTO = Z01_PROD AND C6_XLACRE = Z01_COD  AND C6_ITEM = Z01_ITEMPV AND SC6.D_E_L_E_T_  <> '*' AND Z01_PV = C6_NUM "+CRLF
cQry+= "WHERE  Z01_COD = '"+Alltrim(SC6->C6_XLACRE)+"'  AND Z01_FILIAL = '"+xFilial("SC6")+"' AND Z01.D_E_L_E_T_  <> '*' AND Z01_STAT <> '4' --AND C6_RECALC <> '2' "+CRLF
cQry+= "GROUP BY Z01_COD, Z01_PV, Z01_ITEMPV,Z01_PROD,Z01_INIC,Z01_FIM,C6_QTDVEN,Z01_STAT ,Z01.R_E_C_N_O_,Z01_OP,Z01_STAT,C6_RECALC , Z01_COPIA "+CRLF
cQry+= "ORDER BY Z01.R_E_C_N_O_ --Z01_PV,Z01_ITEMPV "+CRLF
MemowRite("c:\Qry\MTA410E.sql",cQry) 

If Select("TRB") > 0
   	TRB->(dbCloseArea())
EndIf

TCQUERY cQry New Alias "TRB"

dbSelectArea("TRB");TRB->(dbGotop())
If TRB->(Eof())
	TRB->(dbCloseArea());Return .T.
Endif


// Contador para regua de processamento
While !TRB->(EOF())
	nCont++
	if !Empty(Alltrim(TRB->Z01_OP))
		_nRec:=TRB->(REC)
	Endif
	
	TRB->(dbSkip())
Enddo

SetRegua(nCont)
TRB->(dbGotop())

dbSelectArea("Z00");Z00->(dbSetOrder(1))
Z00->(dbSeek(xFilial("Z00")+SC6->C6_XLACRE ))


While !TRB->(EOF())
	
	// Bruno Abrigo em 16.05.2012;Trata intervalo
	IF TRB->(REC) > ( Iif(Empty(Alltrim(Z00->Z00_REGZ01)),0,Val(Z00->Z00_REGZ01)) )
		
		// Retorna lacre para recalculo
		If lOk
			dbSelectArea("Z00");Z00->(dbSetOrder(1))
			If Z00->(dbSeek(xFilial("Z00")+SC6->C6_XLACRE ))
				Z00->(RecLock("Z00",.F.))
				Z00->Z00_LACRE:= Z00->Z00_LACINI
				Z00->(MsUnlock())
			Endif
			lOk:=!lOk
		Endif
		
		If TRB->C6_RECALC == "2" .OR. TRB->Z01_STAT <> "1"  .OR. ( TRB->Z01_STAT == "1" .and. !Empty(Alltrim(TRB->Z01_OP)) ) .OR. TRB->(REC) <= _nRec;
			.or. TRB->Z01_COPIA =  "C"
			// Status q nใo altera os itens, porem atualiza recalculo do cabec
			dbSelectArea("Z00")
			Z00->(dbSetOrder(1))
			If Z00->(dbSeek(xFilial("Z00")+SC6->C6_XLACRE ))
				Z00->(RecLock("Z00",.F.))
					Z00->Z00_LACRE:= TRB->Z01_FIM+1
				Z00->(MsUnlock())
			Endif
		Else
			dbSelectArea("Z00")
			Z00->(dbSetOrder(1))
			If Z00->(dbSeek(xFilial("Z00")+SC6->C6_XLACRE ))
				dbSelectArea("Z01")
				Z01->(dbSetOrder(1))
				If Z01->(dbSeek(xFilial("Z01")+Z00->Z00_COD+TRB->Z01_PV+TRB->Z01_ITEMPV ))
					
					Z01->(RecLock("Z01",.F.))
					Z01->Z01_FILIAL	:= xFilial("Z01")
					Z01->Z01_COD	:= TRB->Z01_COD
					Z01->Z01_PV		:= TRB->Z01_PV
					Z01->Z01_ITEMPV	:= TRB->Z01_ITEMPV
					Z01->Z01_INIC	:= Z00->Z00_LACRE
					Z01->Z01_FIM	:= Z00->Z00_LACRE + TRB->C6_QTDVEN -1
					Z01->Z01_STAT	:= "1"
					Z01->Z01_PROD	:=TRB->Z01_PROD
					Z01->(MsUnlock())
					
					Z00->(RecLock("Z00",.F.))
					Z00->Z00_LACRE := Z01->Z01_FIM +1
					Z00->(MsUnlock())
					
					If SC6->(dbSetOrder(1), dbSeek(xFilial("SC6")+TRB->Z01_PV+TRB->Z01_ITEMPV))
						If SC6->(RecLock("SC6",.F.))
							SC6->C6_XINIC:= Z01->Z01_INIC
							SC6->C6_XFIM := Z01->Z01_FIM 
							SC6->(MsUnlock())
						Endif
					Endif
				Endif
			Endif
		Endif
	Endif
	IncRegua()
	TRB->(dbSkip())
Enddo


RestArea(aAreaSC6)
TRB->(dbCloseArea())

Return
