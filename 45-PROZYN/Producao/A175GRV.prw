#include 'protheus.ch'
#include 'parmtype.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³A175GRV		ºAutor  ³Microsiga	     º Data ³  06/06/2019 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³P.E. apos a gravação da baixa do CQ						  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Ap		                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function A175GRV()

Local aArea := GetArea()

//Atualização da data de fabricação
AtuDtFab(SD7->D7_NUMERO)

RestArea(aArea)	
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³AtuDtFab		ºAutor  ³Microsiga	     º Data ³  06/06/2019 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Atualiza da de fabricação dos produtos utilizados no 		  º±±
±±º          ³movimento                                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Ap		                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AtuDtFab(cDocD7)

Local aArea 	:= GetArea()
Local cQuery	:= ""
Local cArqTmp	:= GetNextAlias()
Local dDtFabric	:= CTOD('')
	

	Local _cAlias2 := ''
	Local aItem:= {}
	Local aCabSDA := {}
	Local nCount := 0
	Local cItem := ''
	local cEnder:=''
	Local nTamanho := TamSX3('DB_ITEM')[01]
	Local nModAux := nModulo

	Private lMsErroAuto := .F.



Default cDocD7	:= ""

cQuery	:= " SELECT D7_PRODUTO, D7_LOTECTL, D7_NUMLOTE FROM "+RetSqlName("SD7")+" SD7 "+CRLF
cQuery	+= " WHERE SD7.D7_FILIAL = '"+xFilial("SD7")+"' "+CRLF
cQuery	+= " AND SD7.D7_NUMERO = '"+cDocD7+"' "+CRLF
cQuery	+= " AND SD7.D_E_L_E_T_ = ' ' "+CRLF
cQuery	+= " GROUP BY D7_PRODUTO, D7_LOTECTL, D7_NUMLOTE "+CRLF

DbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQuery) , cArqTmp,.T.,.T.)

While (cArqTmp)->(!Eof())
	dDtFabric := CTOD('')
	
	//Data de fabricação
	dDtFabric := U_PZCVADT5((cArqTmp)->D7_PRODUTO,, (cArqTmp)->D7_LOTECTL, (cArqTmp)->D7_NUMLOTE)
	
	If !Empty(dDtFabric)
		//Atualiza a data de fabricação
		U_PZCVA005((cArqTmp)->D7_PRODUTO,, (cArqTmp)->D7_LOTECTL, (cArqTmp)->D7_NUMLOTE, dDtFabric)
	EndIf
	
	(cArqTmp)->(DbSkip())
EndDo

If Select(cArqTmp) > 0
	(cArqTmp)->(DbCloseArea())
EndIf

RestArea(aArea)

//ENDEREÇAMENTO AUTOMATICO APÓS GRAVAÇÃO DOS RESULTADOS  - DANIEL 15/08/2020

/* 
			_cQry2 := " 			SELECT * FROM SDA010 DA  "+CRLF  
			_cQry2 += " 			INNER JOIN SB1010 B1 ON B1_COD  = DA_PRODUTO "+CRLF 
			_cQry2 += " 			AND B1.D_E_L_E_T_ <> '*' "+CRLF  
			_cQry2 += " 			INNER JOIN SD7010 D7 ON (TRIM(DA_PRODUTO)+TRIM(DA_DOC)+TRIM(DA_NUMSEQ)+TRIM(DA_LOTECTL)) =  "+CRLF
			_cQry2 += " 			(TRIM(D7_PRODUTO)+TRIM(D7_NUMERO)+TRIM(D7_NUMSEQ)+TRIM(D7_LOTECTL))   "+CRLF
			_cQry2 += " 			WHERE  DA_SALDO <> 0 AND   DA.D_E_L_E_T_<> '*' and "+CRLF
			_cQry2 += " 			D7_NUMERO = '" + cDocD7 + "' AND  "+CRLF
			IF SD7->D7_LOCDEST <> '20' .or. SD7->D7_LOCDEST <> '99'
			_cQry2 += " 			D7_LOCALIZ <> '265.26.001.01'  AND "+CRLF 
			ENDIF
			_cQry2 += " 			D7_ESTORNO <> 'S' AND "+CRLF  	
			_cQry2 += " 			D7.D_E_L_E_T_<> '*' "+CRLF */


_cQry2 := " 	SELECT * FROM (   SELECT DA_PRODUTO, DA_LOCAL, DA_NUMSEQ, DA_DOC, D7_LOCALIZ, D7_LOCDEST, D7_LOCAL, B1_QE, B1_DESC FROM SDA010 DA  
_cQry2 += " 			 			INNER JOIN SB1010 B1 ON B1_COD  = DA_PRODUTO 
_cQry2 += " 			 			AND B1.D_E_L_E_T_ <> '*' 
_cQry2 += " 			 			INNER JOIN SD7010 D7 ON (TRIM(DA_PRODUTO)+TRIM(DA_DOC)+TRIM(DA_NUMSEQ)+TRIM(DA_LOTECTL)) =  
_cQry2 += " 			 			(TRIM(D7_PRODUTO)+TRIM(D7_NUMERO)+TRIM(D7_NUMSEQ)+TRIM(D7_LOTECTL))   
_cQry2 += " 			 			WHERE  
_cQry2 += " 						DA_SALDO <> 0 AND   DA.D_E_L_E_T_<> '*' and 
_cQry2 += " 			 			D7_NUMERO = '" + cDocD7 + "' AND 
_cQry2 += " 			 			D7_ESTORNO <> 'S' AND 
_cQry2 += " 						D7.D_E_L_E_T_<> '*') AS VERLOCDEST
_cQry2 += " 			WHERE 
_cQry2 += " 			(TRIM(VERLOCDEST.D7_LOCALIZ)+TRIM(VERLOCDEST.D7_LOCDEST)) NOT IN ('265.26.001.0198','265.26.001.0103','265.26.001.0101')



			Memowrite('queryENDAUT.txt', _cQry2)

			_cAlias2 := GetNextAlias()

			
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQry2),_cAlias2,.T.,.F.)
			
			dbSelectArea(_cAlias2)

		(_cAlias2)->(dbEval( { || nCount++ } ))
		(_cAlias2)->(dbGoTop())

		if nCount == 0
			alert("Sem itens disponíveis para o endereçamento!")
		else
		nModulo := 4	// alteração para o modulo estoque para nao dar array out of bounds por motivo de uso de campo das tabelas sda e sdb no modulo de qualidade. 

			dbSelectArea("SDA")
			SDA->(dbSetOrder(1))


	While !(_cAlias2)->(EOF())
 
 	SDA->(dbGoTop()) // posiciona o cabeçalho
			if SDA->(dbSeek( xfilial("SDA") + (_cAlias2)->DA_PRODUTO + (_cAlias2)->DA_LOCAL + (_cAlias2)->DA_NUMSEQ ))
				if SDA->DA_SALDO > 0
					lMsErroAuto := .F.


					  aCabSDA := {}
					 	
						aAdd( aCabSDA, {"DA_PRODUTO" ,SDA->DA_PRODUTO, Nil} )
						aAdd( aCabSDA, {"DA_NUMSEQ" ,SDA->DA_NUMSEQ , Nil} )

				IF (SDA->DA_SALDO>(_cAlias2)->B1_QE .and.!(Alltrim(SDA->DA_LOCAL) $ '99|20')) // tratativa para o armazem 20 de restos de produção
						nF:=(SDA->DA_SALDO/(_cAlias2)->B1_QE) // Calculo da quantidade de itens conforme qtde por embalagem. 
						nQuant:= (_cAlias2)->B1_QE
						cEnder:= (_cAlias2)->D7_LOCALIZ
				Else	
						nF:= 1
						nQuant:= SDA->DA_SALDO
						If SDA->DA_LOCAL == '20'
						cEnder:= "171.01.000.01" //apontamento de fracionados no armazem 20 
						elseif SDA->DA_LOCAL == '99'
						cEnder:= "171.00.099.99" //apontamento de fracionados no armazem 99
						else // outros armazens para apenas uma etiqueta
						cEnder:=(_cAlias2)->D7_LOCALIZ	
						Endif

				endif

						//pega o ultimo item da sdb para nao dar item duplicado

						_cQry3 := "  SELECT ISNULL (MAX(DB_ITEM),0) AS ULTITEM FROM SDB010 DB WHERE "
						_cQry3 += "  DB_NUMSEQ = '" + SDA->DA_NUMSEQ + "' AND "
						_cQry3 += "  DB_PRODUTO = '" + SDA->DA_PRODUTO + "' AND "
						_cQry3 += "  DB_LOCAL = '" + SDA->DA_LOCAL + "' AND "
						_cQry3 += "  DB_LOCALIZ = '" + cEnder + "'  AND "
						_cQry3 += "  DB.D_E_L_E_T_ <> '*' "

						_cAlias3 := GetNextAlias()
			
						dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQry3),_cAlias3,.T.,.F.)
			
						dbSelectArea(_cAlias3)

						If val((_cAlias3)->ULTITEM) > 0
	   						nItem := val((_cAlias3)->ULTITEM)
	   					Else
							nItem:= 0
		   				EndIf
						(_cAlias3)->(DbCloseArea())

						aItem:= {}

						For nX := 1 To nF
	    					nItem += 1
							cItem  := PadL(nItem, nTamanho, "0")
							aAdd(aItem,{{"DB_ITEM",cItem,NIL},;
          								{"DB_LOCALIZ",cEnder,NIL},;
          								{"DB_DATA",dDataBase,NIL},;
          					 			{"DB_QUANT",nQuant,NIL}})
									  
						Next

					MSExecAuto({|x,y,z| mata265(x,y,z)},aCabSDA,aItem,3) //Distribui

					If lMsErroAuto    
					MostraErro()
					Else  
					MsgAlert("Endereçamento Automatico Ok!" + CRLF + " Prod.: "+ SDA->DA_PRODUTO + " - " + (_cAlias2)->B1_DESC + CRLF + " Armz: " + SDA->DA_LOCAL + " Endereço: " + cEnder)  
					Endif

				endif
			endif

		(_cAlias2)->(dbSkip())
	enddo

(_cAlias2)->(dbCloseArea())

Endif

//EndIf

// FIM DA EXECAUTO DO ENDEREÇAMENTO AUTOMATICO - DANIEL 16/08/2020

	nModulo := nModAux // Voltar variavel para o modulo corrente. 



Return


User Function MA265BLOT // Ponto de entrada que inibe rotina de validação de lote da tabela SDD
Return .F.


 
