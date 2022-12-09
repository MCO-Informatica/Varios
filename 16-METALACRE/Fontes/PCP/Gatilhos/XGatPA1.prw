#Include "RWMAKE.CH"
#Include "TOPCONN.CH"
#Include "Protheus.Ch" 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³XGatPA  ºAutor  ³ Mateus Hengle      ºData  ³ 08/08/13      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescric.  ³Trava o apontamento de um PA se o PI nao tiver saldo        º±±
±±º          ³TOTVS TRIAH    											  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Metalacre                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/  
User Function XGatPA1 ()
Local aArea	:= GetArea()
Local cQuje    := M->H6_QTDPROD   // PEGA A QTDE APONTADA
Local cLote    := M->H6_LOTECTL 
Local cProdut  := M->H6_PRODUTO   // PEGA O NUMERO DA OP (LOTE)
Local nQtdProd := M->H6_QTDPROD   // PEGA A QTDE APONTADA
Local lOK      := .T.
Private	lEmpPrev		:= If(SuperGetMV("MV_QTDPREV")== "S",.T.,.F.)

cLote    := ALLTRIM(cLote)
cProdut  := ALLTRIM(cProdut)

cPro := SUBSTR(cProdut,1,1) // PEGA A PRIMEIRA LETRA DO PRODUTO

DBSELECTAREA("SB1")
DBSETORDER(1)
DBSEEK(xFilial("SB1")+ cProdut) // VAI NA TABELA DE PRODUTO E BUSCA O PRODUTO QUE ESTA SENDO APONTADO

cTipoX := SB1->B1_TIPO  // PEGA O TIPO DE PRODUTO, PRA VER SE EH UM PA  

/*cQry1:= " SELECT C2_NUM, C2_ITEM" 
cQry1+= " FROM "+RETSQLNAME("SC2")+" SC2"
cQry1+= " WHERE (C2_NUM+C2_ITEM) = '"+cLote+"' " 
cQry1+= " AND C2_SEQUEN <> '001' " 
	
If Select("TRF") > 0
	TRF->(dbCloseArea())
EndIf

TCQUERY cQry1 New Alias "TRF"
	
cNumIm := TRF->C2_NUM */

IF (cPro == 'L' .OR. cTipoX == 'PA')   // SO VAI VALIDAR SE FOR UM PRODUTO ACABADO - PAI  
	//IF cNumIm <> " "
	
		cQry:= " SELECT C2_NUM, C2_ITEM, C2_SEQUEN, C2_PRODUTO, C2_DATRF, C2_LOCAL "
   		cQry+= " FROM "+RETSQLNAME("SC2")+" SC2"
   		cQry+= " WHERE (C2_NUM + C2_ITEM) = '"+cLote+"' "
   		cQry+= " AND C2_SEQUEN <> '001' "
   		cQry+= " AND C2_DATRF = '' "
   		cQry+= " AND SC2.D_E_L_E_T_='' "
		cQry+= " ORDER BY C2_NUM, C2_ITEM, C2_SEQUEN"
	
   	   	If Select("TRS") > 0
	   		TRS->(dbCloseArea())
   		EndIf
	
   		TCQUERY cQry New Alias "TRS"
	 
		cProdX := ''
    	cNum   := TRS->C2_NUM
	
		lSaldoPI := .T.        
		
		While TRS->(!Eof())
			//B8_FILIAL, B8_PRODUTO, B8_LOCAL, B8_LOTECTL, B8_NUMLOTE, B8_DTVALID, R_E_C_N_O_, D_E_L_E_T_
			nSaldo:=0
			If SB8->(dbSetOrder(3), dbSeek(xFilial("SB8")+TRS->C2_PRODUTO+TRS->C2_LOCAL+TRS->C2_NUM+TRS->C2_ITEM))
				While SB8->(!EOF()) .And. AllTrim(xFilial("SB8")+TRS->C2_PRODUTO+TRS->C2_LOCAL+TRS->C2_NUM+TRS->C2_ITEM)==AllTrim(SB8->(B8_FILIAL+B8_PRODUTO+B8_LOCAL+B8_LOTECTL))
					nSaldo+=SB8SALDO(,,,,,lEmpPrev,,,.T.)
			
					SB8->(dbSkip(1))
				End
			Endif         
			
			If SG1->(dbSetOrder(1), dbSeek(xFilial("SG1")+M->H6_PRODUTO+TRS->C2_PRODUTO))
				nSaldo := (nSaldo * SG1->G1_QUANT)
			Endif
			
			cProdX += ' Produto: ' + AllTrim(TRS->C2_PRODUTO) + " Saldo: " + TransForm(nSaldo,"@E 9,999,999.9999") + Chr(13)
			
			If nSaldo < nQtdProd
				lSaldoPI := .f.
			Endif
			
			TRS->(dbSkip(1))
		Enddo

   		TRS->(dbCloseArea())
   		
		IF !lSaldoPI
	   		lOK := .F. 
			ALERT("Existe PI com Saldo Insuficiente : "+Chr(10)+Chr(13)+ALLTRIM(cProdX))
			RestArea(aArea)
			RETURN lOK
		ENDIF 
   //ENDIF
ENDIF
RestArea(aArea)	
Return lOK