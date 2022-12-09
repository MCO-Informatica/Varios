#INCLUDE "TopConn.ch"    
#Include "PROTHEUS.Ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma ³MTA410T ºAutor ³Luiz Alberto - Totalsiga º Data ³ 07/03/12  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada executado apos gravacao do pedido de vendaº±±
±±º          ³para atualização lacre inicial e final                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ METALACRE                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MTA410T()   
Local aAreaSC5 := SC5->(GetArea())
Local aAreaSC6 := SC6->(GetArea())
Local aAreaSC9 := SC9->(GetArea())
Local lOk	:= .F.
LOCAL LGO   := .T.

If cEmpAnt <> '01'
	Return .T.
Endif      

If Type("_lReap") == "U"
	Public _lReap := .F.
Endif                   


If Type("_cPedRep") == "U"
	Public _cPedRep := ''
Endif



LgO := u_posgrava()
       
// Grava Total no Pedido de Vendas

RestArea(aAreaSC5)
RestArea(aAreaSC6)
RestArea(aAreaSC9)

//U_TotPed(SC5->C5_NUM)

RestArea(aAreaSC5)
RestArea(aAreaSC6)
RestArea(aAreaSC9)

IF LgO 
	If INCLUI	// executado apenas na inclusão do Pedido e Vendas
		PROCESSA({|| U_JobCiclo(SC5->C5_CLIENTE,SC5->C5_LOJACLI)},"Aguarde", "Processando Ciclo, Cliente ==> " + SC5->C5_CLIENTE+"/"+SC5->C5_LOJACLI)
	Endif

	If SC6->(dbSetOrder(1), dbSeek(xFilial("SC6")+SC5->C5_NUM))
		While SC6->(!Eof()) .And. xFilial("SC6")==SC6->C6_FILIAL .And. SC6->C6_NUM == SC5->C5_NUM
			//      Bruno\ Abrigo em 10/04/12        
			
			// NOVO ITEM: QDO ATINGIR OS CARACTERES PRECONFIGURADOS MANDA UMA MENSAGEM NA TELA.
			DBSELECTAREA("Z00")
			DBSETORDER(3) // FILIAL + CODIGO + CLIENTE + LOJA
			IF DBSEEK(XFILIAL("Z00") + SC6->C6_XLACRE + SC6->C6_CLI + SC6->C6_LOJA )
				IF Z00->Z00_PDINME == 'S'
					IF LEN(ALLTRIM(STR(SC6->C6_XFIM))) > 6  .OR. SC6->C6_XFIM > 999999
						MSGALERT("A numeração do lacre do item " + SC6->C6_PRODUTO  + " atingiu o numero de caracteres configurado na tabela de personalização.")
						MSGALERT("Favor incluir uma NOVA personalização para o cliente " + ALLTRIM(SC5->C5_NOMECLI)  + ", LOJA " + SC5->C5_LOJACLI + ".")
					ENDIF					
				ELSE
					IF LEN(ALLTRIM(STR(SC6->C6_XFIM))) > Z00->Z00_TMLACRE
						MSGALERT("A numeração do lacre do item " + SC6->C6_PRODUTO + " atingiu o numero de caracteres configurado na tabela de personalização.")
						MSGALERT("Favor verificar a personalização " + SC6->C6_XLACRE + " e aumente o numero do campo Tamanho do lacre.")
					ENDIF     
			    ENDIF
			ENDIF			
			
			
			aAreaSC5	:= SC5->(GetArea())
			aAreaSC6	:= SC6->(GetArea())
			aAreaSC9	:= SC9->(GetArea())
			aAreaSA1	:= SA1->(GetArea())

			If cEmpAnt == '01'
				If Empty(SC5->C5_PEDWEB)
					U_CargaPed(SC6->C6_NUM,SC6->C6_ITEM,SC6->C6_PRODUTO) // Ajusta Saldo Carga Fabrica
				Endif
			Endif
									
			RestArea(aAreaSC5)
			RestArea(aAreaSC6)
			RestArea(aAreaSC9)
			RestArea(aAreaSA1)

			If SC6->C6_RECALC <> '1' // Luiz Alberto - 02-05-12
				SC6->(dbSkip(1));Loop
			Endif   
			
			lOk:=.T.
			dbSelectArea("Z02")
			Z02->(dbSetOrder(3))
			If !Z02->(DBSeek(xFilial("Z02")+SC6->C6_XLACRE+SC5->C5_CLIENTE+SC5->C5_LOJACLI))
				if !Empty(SC6->C6_XLACRE)
					MsgAlert('Personalizacao ' + SC6->C6_XLACRE + ' Não Localizada Para Este Cliente !! '+CRLF+"Favor Cadastrar!")
				Endif
				RestArea(aAreaSC5)
				RestArea(aAreaSC6)
				RestArea(aAreaSC9)
				Return .F.
			Endif
			SC6->(dbSkip())
		Enddo
	Endif
ELSE
	RestArea(aAreaSC5)
	RestArea(aAreaSC6)
	RestArea(aAreaSC9)
	RETURN .F.
ENDIF
RestArea(aAreaSC5)
RestArea(aAreaSC6)
RestArea(aAreaSC9)
Return .T.
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Ajuste    ºAutor  ³Bruno Daniel Abrigo º Data ³  04/24/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Diversos ajustes desenvolvidos para recalcular seq lacre   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Metalacre                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Ajuste()
Local cQry			:=""
Local aAreaSC6  	:= SC6->(GetArea())
Local nCont			:=0
Local lOk           :=.T.
Local _nRec         :=0

cQry:= " SELECT Z01_COD, Z01_PV, Z01_ITEMPV,Z01_PROD,Z01_INIC,Z01_FIM,Z01_FIM-Z01_INIC+1 C6_QTDVEN,Z01.R_E_C_N_O_ 'REC',"
cqry+= " Z01_OP,Z01_STAT , Z01_COPIA, CASE WHEN C6_RECALC IS NULL THEN '1' ELSE C6_RECALC END C6_RECALC FROM  "+RETSQLNAME("Z01")+" Z01 WITH(NOLOCK) "+CRLF
cQry+= "  LEFT OUTER JOIN  "+RETSQLNAME("SC6")+" SC6 WITH(NOLOCK) ON C6_PRODUTO = Z01_PROD AND C6_XLACRE = Z01_COD  AND C6_ITEM = Z01_ITEMPV AND "
cqry+= " SC6.D_E_L_E_T_  <> '*' AND Z01_PV = C6_NUM "+CRLF
cQry+= " WHERE  Z01_COD = '"+Alltrim(SC6->C6_XLACRE)+"'  AND Z01_FILIAL = '"+xFilial("SC6")+"' AND Z01.D_E_L_E_T_  <> '*' AND Z01_STAT <> '4' "
cqry+= " --AND C6_RECALC <> '2' "+CRLF
cQry+= "GROUP BY Z01_COD, Z01_PV, Z01_ITEMPV,Z01_PROD,Z01_INIC,Z01_FIM,C6_QTDVEN,Z01_STAT ,Z01.R_E_C_N_O_,Z01_OP,Z01_STAT,C6_RECALC , Z01_COPIA "+CRLF
cQry+= "ORDER BY Z01.R_E_C_N_O_ --Z01_PV,Z01_ITEMPV "+CRLF

MemowRite("c:\Qry\MTA410E.sql",cQry)
TCQUERY cQry New Alias "TRB"

dbSelectArea("TRB");TRB->(dbGotop())
If TRB->(Eof())
	TRB->(dbCloseArea());Return .T.
Endif

While !TRB->(EOF())
	if !Empty(Alltrim(TRB->Z01_OP))
		_nRec:=TRB->(REC)
	Endif  
	nCont++;TRB->(dbSkip())
Enddo

SetRegua(nCont);TRB->(dbGotop())

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
		
		If TRB->C6_RECALC == "2" .OR. TRB->Z01_STAT <> "1"  .OR. ( TRB->Z01_STAT == "1" .and. !Empty(Alltrim(TRB->Z01_OP)) ) .OR. TRB->(REC) <= _nRec ;
			.or. TRB->Z01_COPIA =  "C"
			
			Z00->(RecLock("Z00",.F.))
			Z00->Z00_LACRE:= TRB->Z01_FIM+1 &&Z00->Z00_LACRE-SC6->C6_QTDVEN
			Z00->(MsUnlock())
		Else
			
			dbSelectArea("Z01");Z01->(dbSetOrder(1))
			
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
				
				dbselectarea("SC6")
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
	IncRegua()
	TRB->(dbSkip())
Enddo
//U_ChkLacre(SC6->C6_XLACRE)
RestArea(aAreaSC6);TRB->(dbCloseArea())

Return



User Function TotPed(cNumPed)
Local aArea := GetArea()
// Gravacao do Campo Valor Total do Pedido de Vendas
	
If !SC5->(dbSetOrder(1), dbSeek(xFilial("SC5")+cNumPed))
	RestArea(aArea)
	Return .f.
Endif

MaFisIni(SC5->C5_CLIENTE,;  // 1-Codigo Cliente/Fornecedor
   SC5->C5_LOJACLI,;  // 2-Loja do Cliente/Fornecedor
   "C",;     // 3-C:Cliente , F:Fornecedor
   SC5->C5_TIPO,;   // 4-Tipo da NF
   SC5->C5_TIPOCLI,;         // 5-Tipo do Cliente/Fornecedor
   MaFisRelImp("MTR700",{"SC5","SC6"}),;   // 6-Relacao de Impostos que suportados no arquivo
   ,;     // 7-Tipo de complemento
   ,;     // 8-Permite Incluir Impostos no Rodape .T./.F.
   "SB1",;     // 9-Alias do Cadastro de Produtos - ("SBI" P/ Front Loja)
   "MTR700")    // 10-Nome da rotina que esta utilizando a funcao

   nItem := 0   
   nValIcmSt := 0
   nDesconto := 0
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Faz manualmente porque nao chama a funcao Cabec()                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nNrItem:=0
If SC6->(dbSetOrder(1), dbSeek(xFilial("SC6")+SC5->C5_NUM))
	While !Eof() .And. SC6->C6_FILIAL = xFilial("SC6") .And. SC6->C6_NUM == cNumPed
		nNritem+=1
		dbSkip()
	Enddo         
Endif
   
nTotQtde  := 0.00   
nVlrTotal := 0.00
nTotDesc  := 0.00                                          
nIPI        := 0.00                                          
nICM        := 0.00                                          
nValIcm     := 0.00                                          
nValIpi     := 0.00                                          
nTotIpi	    := 0.00                                          
nTotIcms	:= 0.00                                          
nTotDesp	:= 0.00                                          
nTotFrete	:= 0.00                                          
nTotalNF	:= 0.00                                          
nTotSeguro  := 0.00                                          
nTotMerc    := 0.00                                          
nTotIcmSol  := 0.00                    
aPlanFrete  := {}                      

If SC6->(dbSetOrder(1), dbSeek(xFilial("SC6")+SC5->C5_NUM))
	While SC6->(!Eof()) .And. xFilial("SC6")==SC6->C6_FILIAL .And. SC6->C6_NUM == SC5->C5_NUM
		nItem ++
		MaFisAdd(SC6->C6_PRODUTO,;   	   // 1-Codigo do Produto ( Obrigatorio )
				SC6->C6_TES,;		       // 2-Codigo do TES ( Opcional )
				SC6->C6_QTDVEN,;		   // 3-Quantidade ( Obrigatorio )
				SC6->C6_PRCVEN,;	       // 4-Preco Unitario ( Obrigatorio )
				nDesconto,;                // 5-Valor do Desconto ( Opcional )
				nil,;		               // 6-Numero da NF Original ( Devolucao/Benef )
				nil,;		               // 7-Serie da NF Original ( Devolucao/Benef )
				nil,;			       	   // 8-RecNo da NF Original no arq SD1/SD2
				SC5->C5_FRETE/nNritem,;	   // 9-Valor do Frete do Item ( Opcional )
				SC5->C5_DESPESA/nNritem,;  // 10-Valor da Despesa do item ( Opcional )
				SC5->C5_SEGURO/nNritem,;   // 11-Valor do Seguro do item ( Opcional )
				0,;						   // 12-Valor do Frete Autonomo ( Opcional )
				SC6->C6_Valor+nDesconto,;  // 13-Valor da Mercadoria ( Obrigatorio )
				0,;						   // 14-Valor da Embalagem ( Opcional )
				0,;		     			   // 15-RecNo do SB1
				0) 	           	           // 16-RecNo do SF4     
	      nIPI        := MaFisRet(nItem,"IT_ALIQIPI")
	      nICM        := MaFisRet(nItem,"IT_ALIQICM")
	      nValIcm     := MaFisRet(nItem,"IT_VALICM")	           
	      nValIpi     := MaFisRet(nItem,"IT_VALIPI")	      
	      nTotIpi	    := MaFisRet(,'NF_VALIPI')
	      nTotIcms	:= MaFisRet(,'NF_VALICM')        
	      nTotDesp	:= MaFisRet(,'NF_DESPESA')
	      nTotFrete	:= MaFisRet(,'NF_FRETE')
	      nTotalNF	:= MaFisRet(,'NF_TOTAL')
	      nTotSeguro  := MaFisRet(,'NF_SEGURO')
	      aValIVA     := MaFisRet(,"NF_VALIMP")
	      nTotMerc    := MaFisRet(,"NF_TOTAL")
	      nTotIcmSol  := MaFisRet(nItem,'NF_VALSOL')
	      
	      nTotQtde    += (SC6->C6_QTDVEN - SC6->C6_QTDENT)   
	      
	      SC6->(DbSkip())  

   	EndDo 
	nVlrTotal := Round(nTotMerc + nTotIpi + nTotSeguro+nTotDesp - nTotDesc,2)
Endif	   
MaFisEnd()//Termino	

If RecLock("SC5",.f.)
	SC5->C5_TOTPED := nVlrTotal
	SC5->(MsUnlock())
Endif          

RestArea(aArea)
Return .t.