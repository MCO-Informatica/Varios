#Include "RWMAKE.CH"
#Include "TOPCONN.CH" 
#Include "Protheus.Ch"
#INCLUDE 'COLORS.CH'

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ CALCPESO Autor ³ Luiz Alberto        ³ Data ³ 03/03/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Objetivo  ³ Funcao responsavel pelo preenchimento dos campos         ±±
				   de Peso Bruto e Peso Liquido do Pedido de Vendas
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ METALACRE                                        ³±±
±±                                                                        ³±±
±±                                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
/*/
User Function CalcPeso(cValor)
Local nVolume := 0
Local nPesoBruto := 0                  
Local nPesoLiqui := 0

If cEmpAnt <> '01'
	Return cValor
Endif

nPosItem := ASCAN(aHeader, {|aVal| Alltrim(aVal[2]) == "C6_ITEM"})
nPosProd := ASCAN(aHeader, {|aVal| Alltrim(aVal[2]) == "C6_PRODUTO"})
nPosQtde := ASCAN(aHeader, {|aVal| Alltrim(aVal[2]) == "C6_QTDVEN"})
nPosQtdL := ASCAN(aHeader, {|aVal| Alltrim(aVal[2]) == "C6_QTDLIB"})
nPosEmba := ASCAN(aHeader, {|aVal| Alltrim(aVal[2]) == "C6_XEMBALA"})
nPosVolm := ASCAN(aHeader, {|aVal| Alltrim(aVal[2]) == "C6_XVOLITE"})
nPosPesB := ASCAN(aHeader, {|aVal| Alltrim(aVal[2]) == "C6_XPBITEM"})
nPosPesL := ASCAN(aHeader, {|aVal| Alltrim(aVal[2]) == "C6_XPLITEM"})

If ! aCols[n,Len(aHeader)+1]
	Posicione("SB1",1,xFilial("SB1")+aCols[n,nPosProd],"")
		 
    // Posiciona-se no item do pedido atual gravado e efetua o abatimento caso o mesmo já tenha sido atendido parcialmente
       
    lOk := .f.
    lAc := .t.

	// Posiciona Registro do Conteudo da Embalagem
	If !Z06->(dbSetOrder(1), dbSeek(xFilial("Z06")+aCols[n,nPosEmba]))
		lAc := .f.
	Endif
	// Posiciona Registro do Tipo da Embalagem
	If !Z05->(dbSetOrder(1), dbSeek(xFilial("Z05")+Z06->Z06_EMBALA))
		lAc := .f.
	Endif                                     

                  
	If lAc	// Se Encontrou os Registros de Embalagem então Calculo, senão, irá abrir tela para digitação
	
		&&Quantidade de Caixas/Item    &&Oscar
		nxCaixa	:= aCols[n,nPosQtde]/Z06->Z06_QTDMAX
		nInt  := Int(nxCaixa)
		nFrac := (nxCaixa - nInt)
		If !Empty(nFrac)
		    nInt++
		Endif
		nxCaixa := nInt
		nxCaixa := Iif(Empty(nxCaixa),1,nxCaixa)

		// Efetua a Soma de Mais uma caixa
		// apenas se a quantidade faturada for superior
		// a quantidade maxima da embalagem

//		If aCols[n,nPosQtde] > Z06->Z06_QTDMAX
//			IIf(Mod(aCols[n,nPosQtde],Z06->Z06_QTDMAX)<>0,nxCaixa+=1,0)
//		Endif
				
		&&Peso Liquido/Item
		nxPliqu:=Z06->Z06_PESOUN*aCols[n,nPosQtde]
		&&Peso Bruto/Item
		nxPbrut:=Z06->Z06_PESOUN*aCols[n,nPosQtde]+(Z05->Z05_PESOEM*nxCaixa)
	
		// Preenche Vetores aCols Posicionado
	            

		aCols[n,nPosVolm] := nxCaixa
		aCols[n,nPosPesB] := nxPbrut
		aCols[n,nPosPesL] := nxPliqu
	Endif
Endif

For _nItem := 1 to Len(aCols)                    
    If ! aCols[_nItem,Len(aHeader)+1]
		 Posicione("SB1",1,xFilial("SB1")+aCols[_nItem,nPosProd],"")
		 
		 If Type("aCols[_nItem,nPosVolm]") <> "U"
			 nVolume += aCols[_nItem,nPosVolm]
			 nPesoBruto += aCols[_nItem,nPosPesB]
			 nPesoLiqui += aCols[_nItem,nPosPesL]
         Endif
    EndIf
Next

M->C5_VOLUME1 := nVolume
M->C5_PBRUTO := nPesoBruto
M->C5_PESOL  := nPesoLiqui       
GetDRefresh() 
Return cValor




/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VldProd Autor ³ Luiz Alberto        ³ Data ³ 07/10/14 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Objetivo  ³ Funcao responsavel pela validação da producao com base
				na capacidade disponivel do recurso e data prevista de 
				entrega
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ METALACRE                                        ³±±
±±                                                                        ³±±
±±                                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
/*/
User Function CalcProd()
Local aArea := GetArea()
Private    oOk		 := LoadBitmap(GetResources(),"LBTIK")
Private    oNo  	 := LoadBitmap(GetResources(),"LBNO")
Private  oSinalNo    := LoadBitmap(GetResources(),"BR_VERMELHO")
Private  oSinalOk    := LoadBitmap(GetResources(),"BR_VERDE")
Private  oSinalSi    := LoadBitmap(GetResources(),"BR_AZUL")
Private oOpcionais
Private oRcp5

/*If GetEnvServer()$"TESTE"
	U_CProd() // Capacitacao Diferenciada por Produto, ainda em teste
	Return .T.
Endif
*/
GetDRefresh()

dEntrega := dDataBase+1

If IsInCallStack("MATA410") .Or. Ascan( aHeader, { |x| Alltrim(x[2]) == "C6_PRODUTO" } ) > 0
	If !Empty(M->C5_PEDWEB)
		Return .t.
	Endif
	nPosProd := Ascan( aHeader, { |x| Alltrim(x[2]) == "C6_PRODUTO" } )
	nPosQtde := Ascan( aHeader, { |x| Alltrim(x[2]) == "C6_QTDVEN" } )
	nPosEntr := Ascan( aHeader, { |x| Alltrim(x[2]) == "C6_ENTREG" } )
	dEntrega := Iif(Type("M->C6_ENTREG")<>"U",M->C6_ENTREG,aCols[n,nPosEntr])
	cProduto := Iif(Type("M->C6_PRODUTO")<>"U",M->C6_PRODUTO,aCols[n,nPosProd])
	nQuant   := Iif(Type("M->C6_QTDVEN")<>"U"  ,M->C6_QTDVEN,aCols[n,nPosQtde])        
ElseIf IsInCallStack("TMKA271") 
	nPosProd := Ascan( aHeader, { |x| Alltrim(x[2]) == "UB_PRODUTO" } )
	nPosQtde := Ascan( aHeader, { |x| Alltrim(x[2]) == "UB_QUANT" } )
	nPosEntr := Ascan( aHeader, { |x| Alltrim(x[2]) == "UB_DTENTRE" } )
	dEntrega := Iif(Type("M->UB_DTENTRE")<>"U",M->UB_DTENTRE,aCols[n,nPosEntr])
	cProduto := Iif(Type("M->UB_PRODUTO")<>"U",M->UB_PRODUTO,aCols[n,nPosProd])
	nQuant   := Iif(Type("M->UB_QUANT")<>"U"  ,M->UB_QUANT  ,aCols[n,nPosQtde])        
ElseIf IsInCallStack("MATA650") 
	If M->C2_XOP == '1'
		Return .t.
	Endif
	dEntrega := M->C2_DATPRF
	cProduto := M->C2_PRODUTO
	nQuant   := M->C2_QUANT
ElseIf ProcName(12)$'U_TRMA03PREC'
	dEntrega := aCols[n, aScan(aHeader,{|x|AllTrim(x[2])=="C2_DATPRF"   }) ]
	cProduto := aCols[n, aScan(aHeader,{|x|AllTrim(x[2])=="C2_PRODUTO"   }) ]
	nQuant   := aCols[n, aScan(aHeader,{|x|AllTrim(x[2])=="C2_QUANT"   }) ]
Endif

// Quantidade de Dias a Pular
// Se For Após Meio dia Então Pula 6 dias

dLimite := dDataBase

nTotDias	:= Iif(Left(Time(),5)<='12:00',5,6)
While nTotDias > 0 .And. !GetNewPAR("MV_MTLEFDS",.T.)	// Bloqueia Entregas aos Fins de Semana .F. Não Libera .T. Libera
	If Dow(dLimite) <> 1 .And. Dow(dLimite) <> 7	// Nao é Sab nem Domingo
		dLimite++
		nTotDias--
	ElseIf Dow(dLimite) == 1 .Or. Dow(dLimite) == 7
		dLimite++
	Endif        
Enddo

dInicio	:= Iif(!Empty(dEntrega),dEntrega,dLimite)

// Montando Datas Disponiveis

SB1->(dbSetOrder(1), dbSeek(xFilial("SB1")+cProduto))
SBM->(dbSetOrder(1), dbSeek(xFilial("SBM")+SB1->B1_GRUPO))

// Validação será executada Apenas em geração 
If IsInCallStack("MATA410") .Or. IsInCallStack("TMKA271") 
	If dInicio < dLimite
		Alert("Atenção a Data da Entrega Deverá ser Igual ou Superior a " + Iif(Left(Time(),5)<='12:00','5','6') + " Dias Úteis ! - Data Ideal: " + DtoC(dLimite) + " !")
		Return .T.
	Endif
	If dInicio < dDataBase
		Alert("Atenção a Data da Entrega Não Pode Ser Inferior a Data Atual !")
		Return .F.
	Endif
Endif

// Verifica se é feriado

If SP3->(dbSetOrder(2), dbSeek(xFilial("SP3")+StrZero(Month(dInicio),2)+StrZero(Day(dInicio),2))) .And. SP3->P3_FIXO == 'S'
	MsgStop("Atenção dia " + DtoC(dInicio) + " Trata-se de Feriado (" + AllTrim(Capital(SP3->P3_DESC)) + "), Impossivel Agendar Entregas !")
	Return .f.
Else
	If SP3->(dbSetOrder(1), dbSeek(xFilial("SP3")+DtoS(dInicio))) .And. SP3->P3_FIXO == 'N'
		MsgStop("Atenção dia " + DtoC(dInicio) + " Trata-se de Feriado (" + AllTrim(Capital(SP3->P3_DESC)) + "), Impossivel Agendar Entregas !")
		Return .f.
	Endif
Endif

SB1->(dbSetOrder(1), dbSeek(xFilial("SB1")+cProduto))
	
cGrupoProd	:= SB1->B1_GRUPO
	
cQuery:= " SELECT C6_NUM, C6_ITEM, C6_PRODUTO, C6_ENTREG, BM_DESC, C6_QTDENT, B1_GRUPO, B1_TIPO, BM_CAPDIA, SUM(C6_QTDVEN-C6_QTDENT) C6_QTDVEN " + CRLF
cQuery+= " FROM " + RetSqlName("SC6") +  " C6   " +CRLF
cQuery+= " , " + RetSqlName("SB1") +  " B1   " +CRLF
cQuery+= " , " + RetSqlName("SBM") +  " BM   " +CRLF
cQuery+= " , " + RetSqlName("SC5") +  " C5   " +CRLF
cQuery+= " WHERE    "
CQUERY+= "          C6_FILIAL='"+XFilial("SC6")+"' AND C6.D_E_L_E_T_<>'*'  " +CRLF   
CQUERY+= " AND      C5_FILIAL='"+XFilial("SC5")+"' AND C5.D_E_L_E_T_<>'*'  " +CRLF
cQuery+= " AND      B1.D_E_L_E_T_<>'*'  AND      B1_FILIAL='"+XFilial("SB1")+"' " +CRLF
cQuery+= " AND      BM_FILIAL='"+XFilial("SBM")+"' AND BM.D_E_L_E_T_<>'*'  " +CRLF
cQuery+= " AND      C6_QTDENT < C6_QTDVEN  AND C6_BLQ NOT IN('R')  AND C6_PRODUTO = B1_COD "+CRLF     
CQUERY+= " AND      C5_NUM = C6_NUM AND C5_CLIENTE = C6_CLI AND C5_LOJACLI = C6_LOJA AND C5_TIPO = 'N'  " +CRLF
cQuery+= " AND      B1_GRUPO = BM_GRUPO   "+CRLF 
cQuery+= " AND      C6_TES <> '516'   "+CRLF            
//cQuery+= " AND C6_NUMOP = '' "		


If cGrupoProd=="612" .or. cGrupoProd=="613"

	cQuery+= " 		AND (BM_GRUPO='612' OR BM_GRUPO='613') " +CRLF

ElseIf cGrupoProd=="605" .or. cGrupoProd=="617"

	cQuery+= " 		AND (BM_GRUPO='605' OR BM_GRUPO='617') " +CRLF

ElseIf cGrupoProd=="620" .or. cGrupoProd=="621"

	cQuery+= " 		AND (BM_GRUPO='620' OR BM_GRUPO='621') " +CRLF

Else

	cQuery+= " 		AND BM_GRUPO='"+cGrupoProd+"'  " +CRLF  

EndIf
cQuery+= " AND C6_ENTREG >= '" + DToS(dInicio) + "' " +CRLF   
cQuery+= " GROUP BY C6_NUM, C6_ITEM, C6_PRODUTO, C6_ENTREG, BM_DESC, C6_QTDENT, B1_GRUPO, B1_TIPO, BM_CAPDIA " +CRLF   
cQuery+= " ORDER BY C6_ENTREG, C6_PRODUTO " +CRLF   

DbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), 'TMPSC6', .F., .T. )
  
TcSetField("TMPSC6","C6_ENTREG","D",8,0)

Count To nReg

dbSelectArea("TMPSC6")
dbGoTop()    
ProcRegua(nReg)
lConfirma := .f.	
aOpc	:= {}            
While TMPSC6->(!Eof())
	IncProc("Aguarde Localizando Datas de Entregas Disponiveis")
	
	nCargaDia	:= TMPSC6->BM_CAPDIA                                                             
	lAchouSc2	:= .f.
	If SC2->(dbSetOrder(9), dbSeek(xFilial("SC2")+TMPSC6->C6_NUM+TMPSC6->C6_ITEM+TMPSC6->C6_PRODUTO))
		lAchouSc2	:= .t.
	Endif
	
	nAchou := Ascan(aOpc,{|x| x[3] == DtoC(TMPSC6->C6_ENTREG)}) // .And. x[4] == cProduto
	If Empty(nAchou)
		AAdd(aOpc,{oOk,;
						'2',;
						DtoC(TMPSC6->C6_ENTREG),;
						Iif(lAchouSC2,(SC2->C2_QUANT-SC2->C2_QUJE),TMPSC6->C6_QTDVEN),;						
						nCargaDia,;
						(nCargaDia - Iif(lAchouSC2,(SC2->C2_QUANT-SC2->C2_QUJE),TMPSC6->C6_QTDVEN)),;
						TMPSC6->C6_ENTREG})
	Else 
		aOpc[nAchou,4] += Iif(lAchouSC2,(SC2->C2_QUANT-SC2->C2_QUJE),TMPSC6->C6_QTDVEN)
		aOpc[nAchou,5] := nCargaDia
		aOpc[nAchou,6] := (aOpc[nAchou,5] - aOpc[nAchou,4])
	Endif

	If TMPSC6->C6_ENTREG==dEntrega
		lConfirma := .t.
	Endif
		
	TMPSC6->(dbSkip(1))
Enddo
TMPSC6->(dbCloseArea())
	

cQuery:= " SELECT C2_PEDIDO, C2_ITEMPV, C2_PRODUTO, C2_NUM, C2_ITEM, C2_SEQUEN, A1_NOME, C2_DATAJF, "
CQUERY+= " B1_GRUPO, BM_DESC, BM_CAPDIA, C2_QUANT, C2_QUJE, C2_DATPRF, B1_DESC "
CQUERY+= " 
CQUERY+= "  , CASE WHEN C2_PEDIDO <> '' THEN ( "
CQUERY+= " 	ISNULL((SELECT TOP 1 GA_DESCOPC FROM " + RETSQLNAME("SGA") + " GA , " + RETSQLNAME("SC6") + " C6 WHERE GA_GROPC = LEFT(C6_OPC,2) "
CQUERY+= " 			AND GA_OPC = SUBSTRING(C6_OPC,4,4) AND GA.D_E_L_E_T_<>'*' and C6_NUM = C2_PEDIDO AND C6_ITEM = C2_ITEMPV  ),'') ) "
CQUERY+= " 		WHEN C2_PEDIDO = '' THEN '' "
CQUERY+= " END AS OPCIONAL "
CQUERY+= " FROM "   +CRLF
cQuery+= " " + RetSqlName("SC2") +  " C2   " +CRLF
cQuery+= " , " + RetSqlName("SB1") +  " B1   " +CRLF
cQuery+= " , " + RetSqlName("SA1") +  " A1   " +CRLF
cQuery+= " , " + RetSqlName("SBM") +  " BM   " +CRLF
cQuery+= " WHERE    "
CQUERY+= "          C2_FILIAL='"+XFilial("SC2")+"' AND C2.D_E_L_E_T_<>'*'  " +CRLF
cQuery+= " AND      B1.D_E_L_E_T_<>'*'  " +CRLF
cQuery+= " AND      BM_FILIAL='"+XFilial("SBM")+"' AND BM.D_E_L_E_T_<>'*'  " +CRLF
cQuery+= " AND      A1_FILIAL='"+XFilial("SA1")+"' AND A1.D_E_L_E_T_<>'*'  " +CRLF   
cQuery+= " AND      B1_FILIAL='"+XFilial("SB1")+"' AND B1.D_E_L_E_T_<>'*'  " +CRLF
cQuery+= " AND      C2_PRODUTO = B1_COD  "+CRLF         
cQuery+= " AND      B1_GRUPO = BM_GRUPO  AND C2_CLI = A1_COD AND C2_LOJA = A1_LOJA "
CQUERY+= " AND (C2_QUANT-C2_QUJE-C2_PERDA) > 0 AND (C2_PEDIDO <> '' OR B1_TIPO IN ('PA','PC') ) " +CRLF

If cGrupoProd=="612" .or. cGrupoProd=="613"

	cQuery+= " 		AND (BM_GRUPO='612' OR BM_GRUPO='613') " +CRLF

ElseIf cGrupoProd=="605" .or. cGrupoProd=="617"

	cQuery+= " 		AND (BM_GRUPO='605' OR BM_GRUPO='617') " +CRLF

ElseIf cGrupoProd=="620" .or. cGrupoProd=="621"

	cQuery+= " 		AND (BM_GRUPO='620' OR BM_GRUPO='621') " +CRLF

Else

	cQuery+= " 		AND BM_GRUPO='"+cGrupoProd+"'  " +CRLF  

EndIf
cQuery+= " AND C2_DATPRF >= '" + DToS(dInicio) + "' " +CRLF   
cQuery+= " AND C2_PEDIDO = '' "
cQuery+= " ORDER BY C2_DATPRF, B1_GRUPO   " +CRLF

DbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), 'TMPSC2', .F., .T. )
  
TcSetField("TMPSC2","C2_DATPRF","D",8,0)

Count To nReg

dbSelectArea("TMPSC2")
dbGoTop()    
ProcRegua(nReg)
lConfirma := .f.	
While TMPSC2->(!Eof())
	IncProc("Aguarde Localizando Datas de Entregas Disponiveis")
	
	nCargaDia	:= TMPSC2->BM_CAPDIA                                                             

	nAchou := Ascan(aOpc,{|x| x[3] == DtoC(TMPSC2->C2_DATPRF)}) // .And. x[4] == cProduto
	If Empty(nAchou)
		AAdd(aOpc,{oOk,;
						'2',;
						DtoC(TMPSC2->C2_DATPRF),;
						(TMPSC2->C2_QUANT-TMPSC2->C2_QUJE),;						
						nCargaDia,;
						(nCargaDia - (TMPSC2->C2_QUANT-TMPSC2->C2_QUJE)),;
						TMPSC2->C2_DATPRF})
	Else 
		aOpc[nAchou,4] += (TMPSC2->C2_QUANT-TMPSC2->C2_QUJE)
		aOpc[nAchou,5] := nCargaDia
		aOpc[nAchou,6] := (aOpc[nAchou,5] - aOpc[nAchou,4])
	Endif

	If TMPSC2->C2_DATPRF==dEntrega
		lConfirma := .t.
	Endif
		
	TMPSC2->(dbSkip(1))
Enddo
TMPSC2->(dbCloseArea())

dDtInic := dInicio
dDtFim	:= dInicio+30
SBM->(dbSetOrder(1), dbSeek(xFilial("SBM")+cGrupoProd))

nCargaDia	:= SBM->BM_CAPDIA

While dDtInic <= dDtFim
	If !GetNewPAR("MV_MTLEFDS",.T.)	// Bloqueia Entregas aos Fins de Semana .F. Não Libera .T. Libera
		If Dow(dDtInic) == 1 .Or. Dow(dDtInic) == 7
			dDtInic++;Loop
		Endif        

		// Verifica se é feriado
		
		If SP3->(dbSetOrder(2), dbSeek(xFilial("SP3")+StrZero(Month(dDtInic),2)+StrZero(Day(dDtInic),2))) .And. SP3->P3_FIXO == 'S'
			dDtInic++;Loop
		Else
			If SP3->(dbSetOrder(1), dbSeek(xFilial("SP3")+DtoS(dDtInic))) .And. SP3->P3_FIXO == 'N'
				dDtInic++;Loop
			Endif
		Endif
		
	Endif

	nAchou := Ascan(aOpc,{|x| x[3] == DtoC(dDtInic)}) // .And. x[4] == cProduto
	If Empty(nAchou)
		AAdd(aOpc,{oOk,;
						'2',;
						DtoC(dDtInic),;
						0,;						
						nCargaDia,;
						nCargaDia,;
						dDtInic})
	Endif
	
	dDtInic	:= DataValida(++dDtInic,.t.)
Enddo
RestArea(aArea)

aSort(aOpc,,, { |x,y| DTOS(y[07]) > DTOS(x[07]) } )      

// Calcula Totais
nTotProduzir	:= 0.00
nTotCapacDia	:= 0.00
nSaldoAtual		:= 0.00

For nE := 1 To Len(aOpc)
	nTotProduzir	+=	aOpc[nE,4]
	nTotCapacDia	+=	aOpc[nE,5]
	nSaldoAtual		+=	aOpc[nE,6]
Next

If Empty(Len(aOpc))
	MsgAlert("Atenção Não Existem Entregas Disponiveis para Este Produto !")
	RestArea(aArea)
	Return .t.
Endif

If Type("l650Auto") == "U"
	l650Auto := .f.
Endif

If !l650Auto	// Se Estiver sendo Executado ExecAuto Então Não Processa
	
	DEFINE MSDIALOG oRcp5 TITLE "Seleção Datas Entregas  - Produto: " + AllTrim(SB1->B1_COD) + ' ' + Alltrim(SB1->B1_DESC) + " Qtde Produzir: " + TransForm(nQuant,"@E 999,999,999.999") FROM 000, 000  TO 350, 720 COLORS 0, 16777215 PIXEL Style DS_MODALFRAME 
	oRcp5:lEscClose := .F. //Não permite sair ao usuario se precionar o ESC
	
	@ 010, 005 LISTBOX oOpcionais Fields HEADER '','',"Dt.Entrega",'Qtd a Produzir','Capac.Diaria','Saldo' SIZE 340, 140 OF oRcp5 PIXEL //ColSizes 50,50
	
	oOpcionais:SetArray(aOpc)
	oOpcionais:bLine := {|| {	Iif(aOpc[oOpcionais:nAt,2]=="1",oSinalOk,Iif(nQuant<=aOpc[oOpcionais:nAt,6],oSinalSi,oSinalNo)),;
	    							Iif(aOpc[oOpcionais:nAt,2]=="1",oOk,oNo),;
	        						aOpc[oOpcionais:nAt,3],;
						      		TransForm(aOpc[oOpcionais:nAt,4],'@E 9,999,999.999'),;
						      		TransForm(aOpc[oOpcionais:nAt,5],'@E 9,999,999.999'),;
						      		TransForm(aOpc[oOpcionais:nAt,6],'@E 9,999,999.999')}}
	
	oOpcionais:bLDblClick := {||DblClick(oOpcionais:nAt,nQuant)}
	
	nOpc := 0
		
	//@ 180,050 BUTTON "Confirma"		  		SIZE 50,15 ACTION (nOpc:=1, Close(oRcp5))
			
	@ 160, 010 BUTTON oBotaoCnf PROMPT "&Selecionar" 			ACTION (Close(oRcp5),nOpc:=1) SIZE 060, 010 OF oRcp5 PIXEL
	@ 160, 070 BUTTON oBotaoCan PROMPT "&Cancelar" 				ACTION (Close(oRcp5),nOpc:=0) SIZE 060, 010 OF oRcp5 PIXEL
	
	@ 155,150 SAY "Total Prod"   	SIZE 80,10 COLOR CLR_BLUE,CLR_WHITE OF oRcp5 PIXEL 
	@ 155,200 SAY "Total Cap.Dia"   SIZE 80,10 COLOR CLR_BLUE,CLR_WHITE OF oRcp5 PIXEL 
	@ 155,250 SAY "Saldo Atual"   	SIZE 80,10 COLOR CLR_BLUE,CLR_WHITE OF oRcp5 PIXEL 
	
	@ 165,150 SAY oObj1 VAR nTotProduzir Picture '@E 9,999,999.999' SIZE 60,15 COLOR CLR_GREEN,CLR_WHITE  OF oRcp5 PIXEL 
	@ 165,200 SAY oObj2 VAR nTotCapacDia Picture '@E 9,999,999.999' SIZE 60,15 COLOR CLR_GREEN,CLR_WHITE  OF oRcp5 PIXEL 
	If (nSaldoAtual - nQuant) > 0.00
		@ 165,250 SAY oObj3 VAR nSaldoAtual  Picture '@E 9,999,999.999' SIZE 60,15 COLOR CLR_GREEN,CLR_WHITE  OF oRcp5 PIXEL 
	Else	
		@ 165,250 SAY oObj3 VAR nSaldoAtual  Picture '@E 9,999,999.999' SIZE 60,15 COLOR CLR_RED,CLR_WHITE  OF oRcp5 PIXEL 
	Endif
	
	oObj1:oFont := TFont():New('Arial',,18,,.T.,,,,.T.,.F.)
	oObj2:oFont := TFont():New('Arial',,18,,.T.,,,,.T.,.F.)
	oObj3:oFont := TFont():New('Arial',,18,,.T.,,,,.T.,.F.)
		
	
	ACTIVATE MSDIALOG oRcp5 CENTERED //ON INIT EnchoiceBar(oRcp,{||If(oGet:Tud_oOk(),_nOpca:=1,_nOpca:=0)},{||oRcp:End()})
		
	dRetorno	:= CtoD('')
	If nOpc == 1
		For nI := 1 To Len(aOpc)
			If aOpc[nI,2] == '1' //.And. nQuant <= aOpc[nI,9]
				dRetorno := CtoD(aOpc[nI,3])
				Exit
			Endif
		Next 
	Endif
	If IsInCallStack("TMKA271") 
		If Type("M->UB_DTENTRE")<>"U"
			M->UB_DTENTRE	:= dRetorno
		Else
			aCols[n,nPosEntr] := dRetorno
		Endif
	ElseIf IsInCallStack("MATA410") .Or. Ascan( aHeader, { |x| Alltrim(x[2]) == "C6_PRODUTO" } ) > 0
		If Type("M->C6_ENTREG")<>"U"
			M->C6_ENTREG	:= dRetorno
		Else
			aCols[n,nPosEntr] := dRetorno
		Endif
	ElseIf IsInCallStack("MATA650") 
		M->C2_DATPRF	:= dRetorno
	Endif
Else                               
	M->C2_DATPRF	:= dEntrega
Endif
GetDRefresh()
Return .t.



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ DblClick³ Autor ³ Luiz Alberto        ³ Data ³ 06/12/11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Funcao Responsavel pelo Double Click Tela Rotas ³±±
±±³          |                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function dblClick(nPos,nQuant)
Local aArea := GetArea()

If nQuant > aOpc[nPos,6]
	Alert("Data da Entrega Não Disponivel, pois irá ultrapassar capacidade diária !, Porém Momentaneamente Acessivel !")
//	Return .t.
Endif

dDtSel	:=	CtoD(aOpc[nPos,3])

If !GetNewPAR("MV_MTLEFDS",.T.)	// Bloqueia Entregas aos Fins de Semana .F. Não Libera .T. Libera
	If Dow(dDtSel) == 1 .Or. Dow(dDtSel) == 7
		Alert("Data da Entrega Não Pode Ser Aos Fins de Semana e Feriados !")
		Return .F.
	Endif        

	// Verifica se é feriado
		
	If SP3->(dbSetOrder(2), dbSeek(xFilial("SP3")+StrZero(Month(dDtSel),2)+StrZero(Day(dDtSel),2))) .And. SP3->P3_FIXO == 'S'
		Alert("Data da Entrega Não Pode Ser Aos Fins de Semana e Feriados !")
		Return .F.
	Else
		If SP3->(dbSetOrder(1), dbSeek(xFilial("SP3")+DtoS(dDtSel))) .And. SP3->P3_FIXO == 'N'
			Alert("Data da Entrega Não Pode Ser Aos Fins de Semana e Feriados !")
			Return .F.
		Endif
	Endif
Endif

If aOpc[nPos,2]=="1"
	aOpc[nPos,2]:="2"
Else

	aOpc[nPos,2]:="1"
	For nI := 1 To Len(aOpc)
		If nI <> nPos
			aOpc[nI,2] := '2'
		Endif
	Next
Endif 
oOpcionais:Refresh()
oRcp5:Refresh()
Return .t.



