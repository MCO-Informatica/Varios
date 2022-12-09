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
User Function XGatPA ()
Local aArea	   := GetArea()
Local cQuje1   := M->H6_QTDPROD   // PEGA A QTDE APONTADA
Local cLote    := M->H6_LOTECTL   // PEGA O NUMERO DO LOTE
Local cProdut  := M->H6_PRODUTO   // PEGA O PRODUTO 
Local cQUJE    := SC2->C2_QUJE
Local lOK      := .T. 

cLote    := ALLTRIM(cLote)
cProdut  := ALLTRIM(cProdut)
cQuje    := cValtochar(cQuje)
cQuje1   := cValtochar(cQuje1)

cPro := SUBSTR(cProdut,1,1) // PEGA A PRIMEIRA LETRA DO PRODUTO

DBSELECTAREA("SB1")
DBSETORDER(1)
DBSEEK(xFilial("SB1")+ cProdut) // VAI NA TABELA DE PRODUTO E BUSCA O PRODUTO QUE ESTA SENDO APONTADO

cTipoX := SB1->B1_TIPO  // PEGA O TIPO DE PRODUTO, PRA VER SE EH UM PA 

cQry1:= " SELECT C2_NUM, C2_ITEM" 
cQry1+= " FROM "+RETSQLNAME("SC2")+" SC2"
cQry1+= " WHERE (C2_NUM+C2_ITEM) = '"+cLote+"' " 
cQry1+= " AND C2_SEQUEN <> '001' " 
	
If Select("TRF") > 0
	TRF->(dbCloseArea())
EndIf

TCQUERY cQry1 New Alias "TRF"
	
cNumIm := TRF->C2_NUM

IF (cPro == 'L' .OR. cTipoX == 'PA')   // SO VAI VALIDAR SE FOR UM PRODUTO ACABADO - PAI
	IF cNumIm <> " "
		
		cQry:= " SELECT C2_QUANT, C2_QUJE, C2_PRODUTO, C2_NUM, C2_ITEM, D4_LOTECTL" // QUERY VAI TRAZER TODOS OS LOTES REFERENTE A ESSA OP PAI
		cQry+= " FROM "+RETSQLNAME("SC2")+" SC2"
		cQry+= " INNER JOIN "+RETSQLNAME("SD4")+" SD4"
		cQry+= " ON C2_FILIAL = D4_FILIAL  AND (C2_NUM+C2_ITEM) = D4_LOTECTL"
		cQry+= " WHERE D4_LOTECTL = '"+cLote+"' "
		cQry+= " AND C2_SEQUEN <> '001' "
		cQry+= " AND SC2.D_E_L_E_T_='' "
		cQry+= " AND SD4.D_E_L_E_T_='' "
			
		If Select("TRS") > 0
			TRS->(dbCloseArea())
		EndIf
		
		TCQUERY cQry New Alias "TRS"
		
		cD4Lote := TRS->D4_LOTECTL
				
		IF cD4Lote = " "    // SE NAO TRAZER NENHUM REGISTRO EH PORQUE AINDA NAO FOI APONTADO OU LIBERADO NADA DESTA OP PAI
			lOK := .F.
			ALERT("Não existe apontamento para alguma OP Filha desta OP Pai, favor apontar primeiro as OPs filhas referente a esta OP Pai")
			RestArea(aArea)
			RETURN lOK
		ENDIF
		
		WHILE TRS->(!EOF()) // TRAZ TODOS OS REGISTROS REFERENTE A ESTA OP PAI
			
			cQujeX := TRS->C2_QUJE // Pega a quantidade produzida da OP FILHA

			cTotal := 0
			
			cTotal := VAL(cQuje1) + VAL(cQuje)  // A qtde que esta sendo apontada + a qtde já apontada é maior do que a OP Filha
			
			IF cTotal  > cQujeX //A qtde da OP Pai nao pode ser maior que a qtde da OP filha
				lOK := .F.
				ALERT("Quantidade incorreta, a quantidade máxima disponivel para apontamento desta OP Pai é de '"+CVALTOCHAR(cQujex)+"'")
				RestArea(aArea)
				RETURN lOK
			ENDIF
			
			TRS->(DbSkip())
		ENDDO
	ENDIF
ENDIF
RestArea(aArea)
Return lOK