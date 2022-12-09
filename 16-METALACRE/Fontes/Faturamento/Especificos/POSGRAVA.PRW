#INCLUDE "Protheus.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณM410AGRV  บAutor  ณBruno Daniel Borges บ Data ณ  25/11/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPonto de entrada na gravacao do pedido de vendas para atua- บฑฑ
ฑฑบ          ณlizar as sequencias de personalizacao de lacres             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Metalacre                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function POSGRAVA()                                         

Local aAreaBKP 	:= GetArea()
Local cMsg := ''
Local nPosLacre := AScan(aHeader,{|x| AllTrim(x[2]) == "C6_XLACRE" })
Local nPosQtd   := AScan(aHeader,{|x| AllTrim(x[2]) == "C6_QTDVEN" })
Local nPosItem  := AScan(aHeader,{|x| AllTrim(x[2]) == "C6_ITEM"   })
Local nPosProd  := AScan(aHeader,{|x| AllTrim(x[2]) == "C6_PRODUTO"})
Local nPosRecalc:= AScan(aHeader,{|x| AllTrim(x[2]) == "C6_RECALC"})// Bruno ABrigo em 22.05.12;ira validar se deve continuar
Local nZ01INIC  := AScan(aHeader,{|x| AllTrim(x[2]) == "C6_XINIC" })
Local nZ01FIM   := AScan(aHeader,{|x| AllTrim(x[2]) == "C6_XFIM" })

LOCAL LRET     := .T.                                    
LOCAL Z01INIC 
LOCAL Z01FIM  
local cCopia := ""      
local TMP := GETNEXTALIAS()

Private cStat		:= ""
Private nInic		:= 0
Private nFim		:= 0
Private _lExclui	:=.F.   

If cEmpAnt <> '01'
	Return
Endif                              

If Type("_lReap") == "U"
	Public _lReap := .F. 
endif

If Type("_lStand") == "U"
	Public _lStand := .F. 
endif
   
If Type("_cPedRep") == "U"
	Public _cPedRep := ''
Endif


//Antes da gravacao faz a busca na tabela de lacres, para identificar se os itens ja possui controle gerado
IF !INCLUI .AND. !ALTERA
// TRATAMENTO PARA A EXCLUSAO DO PEDIDO.
// PRECISA EXCLUIR OS ITENS DA TABELA Z01
// qdo o pedido de venda s๓ tem 1 item, ele se perde. pq nessa hora os itens da sc6 ja estao deletados, mas os itens na z01
// ainda existem. 
// FOI COLOCADO A EXCLUSAO AQUI EM CIMA, PARA QUE MESMO COM 1 ITEM Sำ, ELE NรO SE PERCA.
	_lExclui:=.T.          
	IF SELECT(TMP) > 0
		(TMP)->(DBCLOSEAREA())
	ENDIF
	
	cQuery := "SELECT Z01_COD "
	cQuery += "FROM "+RetSqlName("Z01")+" Z01 "
	cQuery += "WHERE Z01.Z01_FILIAL='"+xFilial("SC6")+"' AND " //QUERY TRAZ O CODIGO DA PERSONALIZACAO DO PEDIDO POSICIONADO
	cQuery += "Z01.Z01_PV = '"+M->C5_NUM+"' AND "
	cQuery += "Z01.D_E_L_E_T_<>'*' "
	dbUseArea( .T., "TOPCONN", TcGenQry( , , cQuery ), (TMP) )
	IF !(TMP)->(EOF())
		Z00COD := (TMP)->Z01_COD
	ELSE
		Z00COD := ''
	ENDIF
	(TMP)->(dbCloseArea())

	dbSelectArea("Z00")
	Z00->(dbSetOrder(1))
	If Z00->(dbSeek(xFilial("Z00")+Z00COD )) .And. !Empty(Z00COD)
		IF SELECT(TMP) > 0
			(TMP)->(DBCLOSEAREA())
		ENDIF

		cQuery := "SELECT Z01_PV "
		cQuery += "FROM "+RetSqlName("Z01")+" Z01 "
		cQuery += "WHERE Z01.Z01_FILIAL='"+xFilial("SC6")+"' AND "
		cQuery += "Z01.Z01_COD = '"+Z00->Z00_COD+"' AND "
		cQuery += "Z01.Z01_PV > '"+M->C5_NUM+"' AND "
		cQuery += " ( (Z01.Z01_STAT = '1')  OR Z01.Z01_STAT <> '1') AND "		//Z01.Z01_OP <> '' AND 
		cQuery += "Z01.D_E_L_E_T_<>'*' "
		cQuery := ChangeQuery( cQuery )
		dbUseArea( .T., "TOPCONN", TcGenQry( , , cQuery ), (TMP) )
		lOk := .t.                   
		IF !(TMP)->(EOF())
			lOk := .f.
		ENDIF								
		(TMP)->(dbCloseArea())
										
		If !lOk
//			cMsg += 'Pedido No. ' + SC6->C6_NUM + ' Item: ' + SC6->C6_ITEM+'/'+SC6->C6_PRODUTO + ' Lacre: ' + SC6->C6_XLACRE + ' Numera็ใo Nใo Retornada Devido Existir Pedidos Superiores ' + Chr(13) + Chr(10)
//			if msgYEsNo(cMsg)
//				LRET := .T.	
//			else
//				return .F.
//			endif
		Else
			RecLock("Z00",.f.)
			Z00->Z00_LACRE  := Z00->Z00_LACRE - (SC6->C6_QTDVEN-SC6->C6_QTDENT)
			Z00->(MsUnlock())
		Endif
										
		// Exclusao da Linha do Item do Pedido na Personalizacao// de Lacres
		dbSelectArea("Z01")
		Z01->(dbSetOrder(1))
		If Z01->(dbSeek(xFilial("Z01")+Z00COD+M->C5_NUM)) 
			DO WHILE !Z01->(EOF()) .AND. Z01->Z01_PV == M->C5_NUM
				RecLock("Z01",.f.)
				Z01->(dbDelete())
				Z01->(MsUnlock())
				dbSelectArea("Z01")
				Z01->(DBSKIP())
			ENDDO
		Endif
		
//		U_ChkLacre(Z00COD)
	Endif
// inclusao de pedidos com reaproveitamento, ou seja, copia de pedido que teve nota fiscal de devolucao.
ELSEif !inclui .and.  Altera	// ALTERACAO	3L Systems - Luiz Alberto - 13-05-2014
	cQuery := "SELECT Z01_COD, Z01_PROD, Z01_ITEMPV, R_E_C_N_O_ REG "
	cQuery += "FROM "+RetSqlName("Z01")+" Z01 "
	cQuery += "WHERE Z01.Z01_FILIAL='"+xFilial("SC6")+"' AND " //QUERY TRAZ O CODIGO DA PERSONALIZACAO DO PEDIDO POSICIONADO
	cQuery += "Z01.Z01_PV = '"+M->C5_NUM+"' AND "
	cQuery += "Z01.D_E_L_E_T_<>'*' "
	dbUseArea( .T., "TOPCONN", TcGenQry( , , cQuery ), 'ZZZ01' )
	
	While ZZZ01->(!Eof()) 
		cItemPv := AllTrim(ZZZ01->Z01_ITEMPV)

		nAchou  := Ascan(aCols,{|x| AllTrim(x[nPosItem]) == cItemPv })
		
		If !Empty(nAchou) .And. !aCols[nAchou,Len(aHeader)+1]	// Achou e a Linha Nใo Esta Deletada
			If AllTrim(ZZZ01->Z01_PROD) <> AllTrim(aCols[nAchou,nPosProd])	// Produto Foi Modificado
				Z01->(dbGoTo(ZZZ01->REG))
				
				If RecLock("Z01",.f.)
					Z01->Z01_PROD	:= aCols[nAchou,nPosProd]
					Z01->(MsUnlock())
				Endif
			Endif
		Endif
		
		ZZZ01->(dbSkip(1))
	Enddo
	ZZZ01->(dbCloseArea())

	dbSelectArea("SC6")   
	SC6->(dbSetOrder(1))
	IF SC6->(dbSeek(xFilial("SC6")+SC5->C5_NUM ))   

		// Tratamento de Lotes, Caixas - 10-07-2014 - 3L Systems
			
		lCxLote := (SC6->(FieldPos("C6_XQTLOT")) > 0) // Se o Campo Estiver Criado Entao Faz o Tratamento
			
		nLoteIni	:= 1
		nCaixas		:= 0

		While SC6->(!Eof()) .And. SC6->C6_FILIAL + SC6->C6_NUM == xFilial("SC6")+SC5->C5_NUM
			If RecLock("SC6",.f.)
				If lCxLote	// Tratamento de Numeracao Caixas e Lotes
					Z06->(dbSetOrder(1), dbSeek(xFilial("Z06")+SC6->C6_XEMBALA))
					Z01->(dbSetOrder(1), dbSeek(xFilial("Z01")+SC6->C6_XLACRE+SC6->C6_NUM+SC6->C6_ITEM))
							
					nVlLote	:= Iif(Empty(SC6->C6_XQTLOT),100,SC6->C6_XQTLOT)
					nSaldo  := SC6->C6_QTDVEN
				    nQtLote := Int(Min(nSaldo,Z06->Z06_QTDMAX)/nVlLote)
							
				    For nEtiq := 1 To SC6->C6_XVOLITE
				    	++nCaixas
				    	If nEtiq == 1
				    		SC6->C6_XCXDE	:= nCaixas
				    		SC6->C6_XLOTI 	:= nLoteIni
				    	Endif
									    	
				    	nLoteIni	+= 	CEILING(Min(nSaldo,Z06->Z06_QTDMAX)/nVlLote)
						nSaldo		-=	Min(SC6->C6_QTDVEN,Z06->Z06_QTDMAX)
					Next                                      
		    		SC6->C6_XCXAT	:= nCaixas
		    		SC6->C6_XLOTF 	:= (nLoteIni-1)
			    Endif
                SC6->(MsUnlock())
			Endif
			SC6->(dbSkip())
		EndDo 
	ENDIF

	dbSelectArea("SC5")
	
ELSEif inclui .and.  _lReap 
       
	For III := 1 TO LEN(aCols)

	   If !(aCols[iii,Len(aHeader)+1]) // se o acols nแo estiver deleta processa.  Trata registros deletados Jonas Gouveia 20-08-12

			IF _lReap .and. !_lStand   
				dbselectarea("Z01")
				DBSETORDER(1)
				If Z01->(dbSeek(xFilial("Z01")+aCols[iii,nPosLacre]+_cPedRep+aCols[iii,nPosItem] ))
					Z01->(RecLock("Z01",.F.))
						Z01->Z01_STAT  := '6'
					  	Z01->Z01_COPIA := 'X' //Bruno Abrigo em 02-08-2012 temp
					Z01->(MsUnlock())    
					Z01INIC	   := Z01->Z01_INIC
					Z01FIM	   := Z01->Z01_FIM							
					cCopia     := 'C'
					IF EMPTY(Z01->Z01_NUMERO)
						Z01->Z01_NUMERO := SOMA1(U_GETSOMA('Z01','Z01_NUMERO',,'Z01_FILIAL',XFILIAL("Z01"),,,,, 'M'))
						If Z01->(FieldPos("Z01_LOGINT")) > 0
							Z01->Z01_LOGINT := UsrFullName(__cUserId)+' em '+DtoC(dDataBase)+' as '+Left(Time(),5)
						Endif
					ENDIF
				ELSE
					cCopia     := ''				
				endif    
			ELSEIF _lStand
					Z01INIC	   := aCols[iii,nZ01INIC]
					Z01FIM	   := aCols[iii,nZ01FIM]
					cCopia     := 'C'										
			else	     
				dbselectarea("Z01")
				DBSETORDER(1)
				If Z01->(dbSeek(xFilial("Z01")+aCols[iii,nPosLacre]+_cPedRep+aCols[iii,nPosItem] ))
					Z01INIC	   := Z01->Z01_INIC
					Z01FIM	   := Z01->Z01_FIM							
				endif    			
			Endif
							
			dbselectarea("Z01")
			Z01->(DBGOTOP())
			RecLock("Z01",.T.)
			Z01->Z01_FILIAL	:= xFilial("Z01")
			Z01->Z01_COD	:= aCols[iii,nPosLacre]
			Z01->Z01_PV		:= M->C5_NUM
			Z01->Z01_ITEMPV	:= aCols[iii,nPosItem]
			Z01->Z01_STAT	:= "1"
			Z01->Z01_PROD	:= aCols[iii,nPosProd]    
			Z01->Z01_COPIA	:= cCopia
			if !EMPTY(cCopia)
				Z01->Z01_INIC	:= Z01INIC
				Z01->Z01_FIM	:= Z01FIM
				endif
			endif						
			Z01->Z01_NUMERO := SOMA1(U_GETSOMA('Z01','Z01_NUMERO',,'Z01_FILIAL',XFILIAL("Z01"),,,,, 'M'))
			If Z01->(FieldPos("Z01_LOGINT")) > 0
				Z01->Z01_LOGINT := UsrFullName(__cUserId)+' em '+DtoC(dDataBase)+' as '+Left(Time(),5)
			Endif
			Z01->(MsUnlock())
	next iii               	               
else	           
	If !INCLUI    
		dbSelectArea("SC6")   
		SC6->(dbSetOrder(1))
		IF SC6->(dbSeek(xFilial("SC6")+M->C5_NUM ))   

			// Tratamento de Lotes, Caixas - 10-07-2014 - 3L Systems
			
			lCxLote := (SC6->(FieldPos("C6_XQTLOT")) > 0) // Se o Campo Estiver Criado Entao Faz o Tratamento
			
			nLoteIni	:= 1
			nCaixas		:= 0

			While SC6->(!Eof()) .And. SC6->C6_FILIAL + SC6->C6_NUM == xFilial("SC6")+M->C5_NUM
				If !Empty(SC6->C6_XLACRE)
					//Se for EXCLUSAO, exclui o numero de lacre caso a personalizacao esteja configurada para reaproveitar numeros
					dbSelectArea("Z00")
					Z00->(dbSetOrder(1))
					If Z00->(dbSeek(xFilial("Z00")+SC6->C6_XLACRE ))
						dbSelectArea("Z01")
						Z01->(dbSetOrder(1))
						If Z01->(dbSeek(xFilial("Z01")+SC6->C6_XLACRE+SC6->C6_NUM+SC6->C6_ITEM ))
							//1o. avalia se o pedido foi apenas alterado e se a quantidade permanece a mesma, nesse caso nao muda a numeracao de lacres
							If ALTERA .And. (Z01->Z01_FIM - Z01->Z01_INIC)+1 == SC6->C6_QTDVEN
								If RecLock("SC6",.f.)
									If lCxLote	// Tratamento de Numeracao Caixas e Lotes
										Z06->(dbSetOrder(1), dbSeek(xFilial("Z06")+SC6->C6_XEMBALA))
										Z01->(dbSetOrder(1), dbSeek(xFilial("Z01")+SC6->C6_XLACRE+SC6->C6_NUM+SC6->C6_ITEM))
							
										nVlLote	:= Iif(Empty(SC6->C6_XQTLOT),100,SC6->C6_XQTLOT)
										nSaldo  := SC6->C6_QTDVEN
									    nQtLote := Int(Min(nSaldo,Z06->Z06_QTDMAX)/nVlLote)
							
									    For nEtiq := 1 To SC6->C6_XVOLITE
									    	++nCaixas
									    	If nEtiq == 1
									    		SC6->C6_XCXDE	:= nCaixas
									    		SC6->C6_XLOTI 	:= nLoteIni
									    	Endif
									    	
									    	nLoteIni	+= 	CEILING(Min(nSaldo,Z06->Z06_QTDMAX)/nVlLote)
											nSaldo		-=	Min(SC6->C6_QTDVEN,Z06->Z06_QTDMAX)
										Next                                      
							    		SC6->C6_XCXAT	:= nCaixas
							    		SC6->C6_XLOTF 	:= (nLoteIni-1)
								    Endif
	                                SC6->(MsUnlock())
                                Endif
								SC6->(dbSkip())
								Loop
							Elseif ALTERA .And. (Z01->Z01_FIM - Z01->Z01_INIC)+1 <> SC6->C6_QTDVEN
								Z01->(RecLock("Z01",.F.))
									Z01->(dbDelete())
								Z01->(MsUnlock())
								cStat:="1"
							EndIF
						EndIf
					EndIf
//					U_ChkLacre(SC6->C6_XLACRE)
				EndIf
				SC6->(dbSkip())
			EndDo 
		ENDIF
	EndIf
ENDIF
//Chama funcao de numeracao dos lacres conforme itens dos pedidos
NumeraLacres(cStat,_lExclui,nInic,nFim)

If !Empty(cMsg)
	MsgStop('Aten็ใo: ' + cMsg)
Endif

RestArea(aAreaBKP)

Return(LRET)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNumeraLacresบAutor  ณBruno Daniel Borges บ Data ณ  25/11/11   บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณNumeracao dos lacresc conforme amarracao personalizacao x     บฑฑ
ฑฑบ          ณitens do pedido                                               บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function NumeraLacres(cStat,_lExclui)

Local i
Local nPosLacre := AScan(aHeader,{|x| AllTrim(x[2]) == "C6_XLACRE" })
Local nPosQtd   := AScan(aHeader,{|x| AllTrim(x[2]) == "C6_QTDVEN" })
Local nPosItem  := AScan(aHeader,{|x| AllTrim(x[2]) == "C6_ITEM"   })
Local nPosProd  := AScan(aHeader,{|x| AllTrim(x[2]) == "C6_PRODUTO"})
Local nPosRecalc:= AScan(aHeader,{|x| AllTrim(x[2]) == "C6_RECALC"})// Bruno ABrigo em 22.05.12;ira validar se deve continuar   
Local nZ01INIC  := AScan(aHeader,{|x| AllTrim(x[2]) == "C6_XINIC" })
Local nZ01FIM   := AScan(aHeader,{|x| AllTrim(x[2]) == "C6_XFIM" })
Local TMP := GETNEXTALIAS()
                                    
For i := 1 To Len(aCols)
//    If aCols[i,Len(aHeader)+1] // se o acols nแo estiver deleta processa.  Trata registros deletados Jonas Gouveia 20-08-12
//       Loop
//    End
	If !Empty(aCols[i,nPosLacre]) .and. aCols[i,nPosRecalc]#'2' //.and. !aCols[i,Len(aHeader)+1] // Bruno ABrigo em 22.05.12;ira validar se deve continuar

		dbSelectArea("Z00")
		Z00->(dbSetOrder(1))
		If Z00->(dbSeek(xFilial("Z00")+aCols[i,nPosLacre] ))
			dbSelectArea("Z01")        
			Z01->(DBGOTOP())
			Z01->(dbSetOrder(1))
			If Z01->(dbSeek(xFilial("Z01")+aCols[i,nPosLacre] +M->C5_NUM+aCols[i,nPosItem] ))
				
				// Luiz Alberto - Total Siga - 01/03/2012
				// Se a linha do Pedido de Venda estiver deletada
				// entใo elimina o Item na Personaliza็ใo
				
				If aCols[i,Len(aHeader)+1]  //Linhas apagadas
					If 	Z01->(RecLock("Z01",.F.))
						Z01->(dbDelete())
						Z01->(MsUnlock())
					Endif					
					Loop
				EndIf
				
				// Luiz Alberto - Total Siga - 01/03/2012
				// Z01_STAT -> 1=Em Pedido;2=OP Gerada;3=OP Apontada;4=PV Cancelado
				
				If Z01->Z01_STAT  <> '4' .And. (Z01->Z01_FIM - Z01->Z01_INIC)+1 <> aCols[i,nPosQtd] .AND. Z01->Z01_COPIA <> 'C'
					Z01->(RecLock("Z01",.F.))
					Z01->Z01_FILIAL	:= xFilial("Z01")
					Z01->Z01_COD	:= aCols[i,nPosLacre]
					Z01->Z01_PV		:= M->C5_NUM
					Z01->Z01_ITEMPV	:= aCols[i,nPosItem]
					Z01->Z01_INIC	:= Z00->Z00_LACRE
					Z01->Z01_FIM	:= Z00->Z00_LACRE + aCols[i,nPosQtd]-1
					Z01->Z01_STAT	:= "1"
					Z01->Z01_PROD	:= aCols[i,nPosProd]   
					IF EMPTY(Z01->Z01_NUMERO)   
						Z01->Z01_NUMERO := SOMA1(U_GETSOMA('Z01','Z01_NUMERO',,'Z01_FILIAL',XFILIAL("Z01"),,,,, 'M'))
					ENDIF							
					If Z01->(FieldPos("Z01_LOGINT")) > 0
						Z01->Z01_LOGINT := UsrFullName(__cUserId)+' em '+DtoC(dDataBase)+' as '+Left(Time(),5)
					Endif
					Z01->(MsUnlock())
					
					Z00->(RecLock("Z00",.F.))
					Z00->Z00_LACRE := Z01->Z01_FIM +1
					Z00->(MsUnlock())
					
					// Luiz Alberto - Total Siga - 01/03/2012
					// Posicionamento do Registro na Tabela SC6 - Pois estamos
					// em um Loop apenas do Acols
					// Correcao dos nomes dos campos a serem atualizados
					// estavam como SC6->SC6_XINIC quando na verdade ้ SC6->C6_XINIC.
					
					aCols[i,nZ01INIC]   :=	Z01->Z01_INIC
					aCols[i,nZ01FIM]   	:=	Z01->Z01_FIM

					If SC6->(dbSetOrder(1), dbSeek(xFilial("SC6")+M->C5_NUM+Z01->Z01_ITEMPV))
						If SC6->(RecLock("SC6",.F.)) 
							//ALERT("POSGRAVA1")
							SC6->C6_XINIC:= Z01->Z01_INIC
							SC6->C6_XFIM := Z01->Z01_FIM
							SC6->(MsUnlock())
						Endif
					Endif
					
				ElseIf cStat <> "4" .And. (Z01->Z01_FIM - Z01->Z01_INIC)+1 == aCols[i,nPosQtd]
					Loop
				EndIF
				
			ElseIf !aCols[i,Len(aHeader)+1]      // se a linha nใo estiver deletada entใo inclui registros
				IF SELECT(TMP) > 0
					(TMP)->(DBCLOSEAREA())
				ENDIF
                // PEGA O ULTIMO NUMERO DE NUNERACAO PARA AQUELA CUSTOMIZACAO
				cQuery := "SELECT MAX(Z01_FIM) AS MAXFIM "
				cQuery += "FROM "+RetSqlName("Z01")+" Z01 "
				cQuery += "WHERE Z01.Z01_FILIAL='"+xFilial("Z01")+"' AND "
				cQuery += "Z01.Z01_COD = '"+Z00->Z00_COD+"' AND "
				cQuery += "Z01.D_E_L_E_T_<>'*' "
				cQuery := ChangeQuery( cQuery )
				dbUseArea( .T., "TOPCONN", TcGenQry( , , cQuery ), (TMP) )
					
				IF (TMP)->MAXFIM > 0
					Z00LACRE := (TMP)->MAXFIM+1
				ELSE
					Z00LACRE  := Z00->Z00_LACRE
				ENDIF								
				(TMP)->(dbCloseArea())

				If !_lExclui 
					dbselectarea("Z01")
					Z01->(DBGOTOP())
					RecLock("Z01",.T.)
					Z01->Z01_FILIAL	:= xFilial("Z01")
					Z01->Z01_COD	:= aCols[i,nPosLacre]
					Z01->Z01_PV		:= M->C5_NUM
					Z01->Z01_ITEMPV	:= aCols[i,nPosItem]
					Z01->Z01_STAT	:= "1"
					Z01->Z01_PROD	:= aCols[i,nPosProd]  
					Z01->Z01_INIC	:= Z00LACRE
					Z01->Z01_FIM	:= Z00LACRE + aCols[i,nPosQtd]-1
					Z01->Z01_NUMERO := SOMA1(U_GETSOMA('Z01','Z01_NUMERO',,'Z01_FILIAL',XFILIAL("Z01"),,,,, 'M')) 
					If Z01->(FieldPos("Z01_LOGINT")) > 0
						Z01->Z01_LOGINT := UsrFullName(__cUserId)+' em '+DtoC(dDataBase)+' as '+Left(Time(),5)
					Endif
					Z01->(MsUnlock())
					Z00->(RecLock("Z00",.F.))
					Z00->Z00_LACRE := Z01->Z01_FIM +1
 					Z00->(MsUnlock())
					
					aCols[i,nZ01INIC]   :=	Z01->Z01_INIC
					aCols[i,nZ01FIM]   	:=	Z01->Z01_FIM

					// Luiz Alberto - Total Siga - 01/03/2012
					// Posicionamento do Registro na Tabela SC6 - Pois estamos
					// em um Loop apenas do Acols
					// Correcao dos nomes dos campos a serem atualizados
					// estavam como SC6->SC6_XINIC quando na verdade ้ SC6->C6_XINIC.
					
					If SC6->(dbSetOrder(1), dbSeek(xFilial("SC6")+M->C5_NUM+Z01->Z01_ITEMPV)) 
						IF SC6->C6_XSTAND <> '1' // LINHA COLOCADA POR MATEUS HENGLE EM 04/04/14
							If SC6->(RecLock("SC6",.F.))
						   		SC6->C6_XINIC:= Z01->Z01_INIC
						   		SC6->C6_XFIM := Z01->Z01_FIM 
						   		SC6->(MsUnlock())
							Endif 
						Endif
					Endif
				Endif
			EndIf
		EndIf
//		U_ChkLacre(aCols[i,nPosLacre])
	EndIf
Next i

Return(Nil)
