#INCLUDE "rwmake.ch"
#Define CRLF ( chr(13)+chr(10) )

/*/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥NOVO4     ∫ Autor ≥ AP6 IDE            ∫ Data ≥  27/01/12   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Descricao ≥ Codigo gerado pelo AP6 IDE.                                ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ AP6 IDE                                                    ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
/*/

User Function RCMaqPD()

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := ""
Local cPict          := ""
Local titulo         := "RelatÛrio Carga Fabrica"
Local nLin           := 80

Local Cabec1         := ""
Local Cabec2         := ""
Local imprime        := .T.
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 220
Private tamanho      := "G"
Private nomeprog     := "RCMaqPD" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "RCMaqPD" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cPerg        := "RCarma"
Private cString      := "SB1"

AjustaSX1()
Pergunte(cPerg,.F.)

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If MV_PAR04 == 1
	Cabec1         := "     PEDIDO       CLIENTE                                    O.F.      PEDIDO CLIENTE   ENTR.PEDIDO   ENTR.AJUST          QUANTIDADE       QUANTIDADE        CAPACIDADE        TOTAL GRUPO       QT.LIMITE"
	Cabec2         := "                  CNPJ             LOCAL DE ENTREGA                                                                       PROGRAMADA        EM ABERTO          DIARIA             NO DIA           NO DIA "
ElseIf MV_PAR04 == 2                                                                                                                                                                                                           
	Cabec1         := "                        C”DIGO                 DESCRICAO                                                               QUANTIDADE           CAPACIDADE               TOTAL GRUPO       QT.LIMITE"
	Cabec2         := "                                                                                                                       EM ABERTO              DIARIA                   NO DIA            NO DIA "
ElseIf MV_PAR04 == 3                                                                                                                                                                                                            
	Cabec1         := "                        C”DIGO                 DESCRICAO                                                               QUANTIDADE           CAPACIDADE               QT.LIMITE"
	Cabec2         := "                                                                                                                       EM ABERTO              DIARIA                  NO DIA "
EndIf
                          
If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)
                                                                                                                                                                                
If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return


Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem
Local cQuery    := ""
Local nQPProd   := 0 // Quantidade programada por produto/Dia
Local nQAProd   := 0 // Quantidade em aberto  por produto/Dia

Local nQPDia    := 0 // Quantidade programada por Dia
Local nQADia    := 0 // Quantidade em aberto  por Dia
Local nCTotDia  := 0 // Capacidade Total Dia
Local nCTotGeral:= 0 // Capacidade Total Geral
Local nLimDia   := 0 // Total limite periodo


If Select("TRB") <> 0
	TRB->(dbCloseArea())
Endif

cQuery:= " SELECT    C2_DATPRI, C2_DATPRF, C6_ENTREG, C2_PRODUTO, C6_PRODUTO, B1_GRUPO, B1_DESC, BM_DESC, C5_CLIENTE, C5_LOJACLI, A1_REGIAO, C6_NUM, C6_ITEM, C6_PEDCLI, C6_NUMOP, C6_ITEMOP,    " +CRLF
&&cQuery:= " SELECT    C2_DATPRI, C2_DATPRF, C6_ENTREG, C2_PRODUTO C6_PRODUTO, B1_GRUPO, B1_DESC, BM_DESC, C5_CLIENTE, C5_LOJACLI, A1_REGIAO, C6_NUM, C6_ITEM, C6_PEDCLI, C6_NUMOP, C6_ITEMOP,    " +CRLF
cQuery+= "        C6_QTDVEN, C6_QTDENT, A1_CGC, A1_NOME, A1_END, A1_EST, A1_BAIRRO, A1_MUN, BM_CAPDIA, C2_DATAJF, ISNULL((SELECT TOP 1 GA_DESCOPC FROM " + RetSqlName("SGA") + " GA WHERE GA_GROPC = LEFT(C6_OPC,2) AND GA_OPC = SUBSTRING(C6_OPC,4,4) AND GA.D_E_L_E_T_<>'*'  ),'') OPCIONAL   " +CRLF
cQuery+= " FROM " + RetSqlName("SC6") +  " C6   " +CRLF
cQuery+= " INNER JOIN " + RetSqlName("SB1") + " B1 ON C6_PRODUTO=B1_COD AND B1.D_E_L_E_T_<>'*'  AND B1_TIPO='PA'  " +CRLF                       	
If !Empty(MV_PAR03)
	cQuery+= " AND B1_GRUPO = '" + MV_PAR03 + "'   " +CRLF
EndIf
cQuery+= " INNER JOIN " + RetSqlName("SBM") + " BM ON BM_FILIAL = '" + xFilial('SBM')  + "'  AND ((B1_GRUPO = BM_GRUPO AND B1_XGRUPO = '') OR B1_XGRUPO = BM_GRUPO) AND BM.D_E_L_E_T_<>'*'      " +CRLF
cQuery+= " LEFT  JOIN " + RetSqlName("SC2") + " C2 ON  C2_PEDIDO=C6_NUM  AND C2_ITEMPV=C6_ITEM AND C2.D_E_L_E_T_<>'*'  " +CRLF && AND C6_PRODUTO BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "'      " +CRLF C6_FILIAL = '" + xFilial('SC6')  + "' 
&&cQuery+= " LEFT  JOIN " + RetSqlName("SC6") + " C6 ON C6_FILIAL = '" + xFilial('SC6')  + "' AND C6.D_E_L_E_T_<>'*'   AND C6_PRODUTO BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "'      " +CRLF
cQuery+= " LEFT  JOIN " + RetSqlName("SC5") + " C5 ON C5_FILIAL = '" + xFilial('SC5')  + "'  AND C5_NUM= C6_NUM AND C5.D_E_L_E_T_<>'*'     " +CRLF
cQuery+= " LEFT  JOIN " + RetSqlName("SA1") + " A1 ON A1_COD=C5_CLIENTE AND A1_LOJA=C5_LOJACLI AND A1.D_E_L_E_T_<>'*'       " +CRLF
cQuery+= " WHERE    C6_FILIAL='"+XFilial("SC6")+"' AND C6.D_E_L_E_T_<>'*'  AND C6_QTDVEN-C6_QTDENT>0 " +CRLF
cQuery+= " AND C6_ENTREG BETWEEN '" + DToS(MV_PAR05) + "' AND '" + DToS(MV_PAR06) + "'    " +CRLF                            
cQuery+= " AND C6_PRODUTO BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "'  "+CRLF

If MV_PAR04==3
	cQuery+= " ORDER BY C6_ENTREG, B1_GRUPO   " +CRLF
Else
	cQuery+= " ORDER BY C6_ENTREG, C6_PRODUTO   " +CRLF
EndIf

MemoWrite('C:\Qry\RCMaqPD' + DToS(MV_PAR05) + substr(time(),1,4) + '.txt',cQuery)

DbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), "TRB", .F., .T. )

SetRegua(RecCount())
dbGoTop()

If MV_PAR04 == 1 // RelatÛrio Detalhado
	
	
	cProd := TRB->C6_PRODUTO
	cData := TRB->C6_ENTREG
	cDatAnt := TRB->C6_ENTREG
	cProAnt := TRB->C6_PRODUTO
	cDesAnt := TRB->BM_DESC
	cGrpAnt := TRB->B1_GRUPO
	
	While !TRB->(EOF())
		
		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif
		
		//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
		//≥ Impressao do cabecalho do relatorio. . .                            ≥
		//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
		
		If nLin > 55 // Salto de P·gina. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 9
		Endif
		
		@nLin,005 PSAY TRB->C6_NUM  
		@nLin,014 PSAY TRB->A1_NOME
		@nLin,060 PSAY TRB->C6_NUMOP
		@nLin,075 PSAY TRB->C6_PEDCLI
		@nLin,090 PSAY DToC(SToD(TRB->C6_ENTREG))
		@nLin,105 PSAY DToC(SToD(TRB->C2_DATAJF)) 
		@nLin,120 PSAY TRB->C6_QTDVEN Picture "@E 999,999,999"
		@nLin,135 PSAY TRB->C6_QTDVEN - TRB->C6_QTDENT  Picture "@E 999,999,999"
		@nLin,155 PSAY TRB->BM_CAPDIA Picture "@E 999,999,999"   
		@nLin,175 PSAY CargaGrp(TRB->B1_GRUPO, SToD(TRB->C6_ENTREG), SToD(TRB->C6_ENTREG)) Picture "@E 999,999,999"
		@nLin,191 PSAY TRB->BM_CAPDIA -CargaGrp(TRB->B1_GRUPO, SToD(TRB->C6_ENTREG), SToD(TRB->C6_ENTREG)) Picture "@E 999,999,999"
		
		nLin++
		
		@nLin,015 PSAY TRB->A1_CGC Picture "@R 99.999.999/9999-99"
		@nLin,035 PSAY TRB->A1_END
		@nLin,090 PSAY Left(TRB->A1_MUN,20)
		@nLin,105 PSAY TRB->A1_BAIRRO
		@nLin,130 PSAY TRB->A1_EST     
		
		nLin++
		
		@nLin,060 PSAY TRB->A1_REGIAO 
		
		nQPProd += TRB->C6_QTDVEN
		nQAProd += TRB->C6_QTDVEN - TRB->C6_QTDENT
		
		nQPDia += TRB->C6_QTDVEN
		nQADia += TRB->C6_QTDVEN - TRB->C6_QTDENT
		
		nLin++
		
		cDatAnt := TRB->C6_ENTREG
		cProAnt := TRB->C6_PRODUTO
		cDesAnt := Alltrim(TRB->B1_DESC) + ' ' + AllTrim(TRB->OPCIONAL)
		cGrpAnt := TRB->B1_GRUPO
		
		cData := TRB->C6_ENTREG
		cProd := TRB->C6_PRODUTO
		
		TRB->(DbSkip())
		
		If TRB->(EOF()) .or. TRB->C6_PRODUTO <> cProd  .or. TRB->C6_ENTREG <> cData
			@nLin,005 PSAY "TOTAL DIA/PRODUTO:     " +  cGrpAnt +  "  " + cDesAnt
			@nLin,120 PSAY nQPProd  Picture "@E 999,999,999"
			@nLin,145 PSAY nQAProd  Picture "@E 999,999,999"
			
			@nLin,000 PSAY Replicate("_",125)
			nLin++
			
			nQPProd := 0
			nQPProd := 0
			
		EndIf
		If TRB->(EOF()) .or. TRB->C6_ENTREG <> cData
			@nLin,040 PSAY "TOTAL GERAL DIA: " +  DToC(SToD(cDatAnt))
			@nLin,120 PSAY nQPDia  Picture "@E 999,999,999"
			@nLin,145 PSAY nQADia Picture "@E 999,999,999"
			nLin++
			@nLin,000 PSAY Replicate("_",220)
			nLin++
			nQPDia := 0
			nQADia := 0
		EndIf
	EndDo
	
	
ElseIf MV_PAR04 == 2
	
	nQADia:= 0
	nCTotGeral:=0
	nLimGeral :=0
	nQADiaTot :=0
	
	While !TRB->(EOF())
		
		cProd := TRB->C6_PRODUTO
		cData := TRB->C6_ENTREG
		cDatAnt := TRB->C6_ENTREG
		cProAnt := TRB->C6_PRODUTO
		cDesAnt := Alltrim(TRB->B1_DESC) + ' ' + AllTrim(TRB->OPCIONAL)
		cGrpAnt := TRB->B1_GRUPO
		
		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif
		
		//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
		//≥ Impressao do cabecalho do relatorio. . .                            ≥
		//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
		
		If nLin > 55 // Salto de P·gina. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 9
		Endif
		
		
		While !TRB->(EOF()) .AND. TRB->C6_PRODUTO == cProd .and. cData == TRB->C6_ENTREG
			nQAProd += TRB->C6_QTDVEN - TRB->C6_QTDENT
			nCTotDia:= TRB->BM_CAPDIA   
			dDtIni	:= SToD(TRB->C6_ENTREG)
			dDtFim	:= SToD(TRB->C6_ENTREG) 
			cGrpAnt	:= TRB->B1_GRUPO
			TRB->(DbSkip())
		EndDo
		
		@nLin,005 PSAY "TOTAL DIA/PRODUTO: "
		@nLin,025 PSAY cProd
		@nLin,045 PSAY cDesAnt
		
		@nLin,120 PSAY nQAProd Picture "@E 999,999,999"
		@nLin,140 PSAY nCTotDia Picture "@E 999,999,999"
		@nLin,165 PSAY CargaGrp(cGrpAnt, dDtIni, dDtFim) Picture "@E 999,999,999"
		@nLin,180 PSAY nCTotDia-CargaGrp(cGrpAnt, dDtIni, dDtFim) Picture "@E 999,999,999"
		
		nQADia    += nQAProd
		nCTotGeral+= nCTotDia
		nLimGeral += nQAProd - nCTotDia
		
		
		nQAProd := 0
		cCTotDia:= 0
		nLin++
		
		
		If cData <> TRB->C6_ENTREG
			
			
			@nLin,040 PSAY "TOTAL GERAL DIA: " +  DToC(SToD(cData))
			@nLin,120 PSAY nQADia    Picture "@E 999,999,999"
			nQADiaTot+= nQADia
			//	@nLin,140 PSAY nCTotGeral Picture "@E 999,999,999"
			//	@nLin,160 PSAY nLimGeral Picture "@E 999,999,999"
			
			nLin++
			@nLin,000 PSAY Replicate("_",220)
			nLin++
			nQAProd := 0
			nQAProd := 0
			nQADia  := 0
			nCTotGeral := 0
			nLimGeral := 0
			
		EndIf
	EndDo
	nLin++
	@nLin,040 PSAY "TOTAL GERAL PERIODO: " +  DToC(MV_PAR05) +" ATE "+DToC(MV_PAR06)
	@nLin,120 PSAY nQADiaTot 	   Picture "@E 999,999,999,999"
	@nLin,000 PSAY Replicate("_",220)
	
ElseIf MV_PAR04 == 3
	
	nQADia:= 0
	nCTotGeral:=0
	nLimGeral :=0
	nQADiaTot :=0
	nQAP80 	  :=0
	nCTotD80  :=0
	cDesc80	  :=""
	nQAP22 	  :=0
	nCTotD22  :=0
	cDesc22	  :=""
	
	While !EOF()
		
		cProd := TRB->C6_PRODUTO
		cData := TRB->C6_ENTREG
		cDatAnt := TRB->C6_ENTREG
		cProAnt := TRB->C6_PRODUTO
		cDesAnt := TRB->BM_DESC
		cGrpAnt := TRB->B1_GRUPO
		
		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif
		
		//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
		//≥ Impressao do cabecalho do relatorio. . .                            ≥
		//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
		
		If nLin > 55 // Salto de P·gina. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 9
		Endif
		
		If AllTrim(TRB->B1_GRUPO) $ "612/613"    //Familia 80 e 81
			While !TRB->(EOF()) .AND. cGrpAnt == TRB->B1_GRUPO
				nQAP80   += TRB->C6_QTDVEN - TRB->C6_QTDENT
				nCTotD80 := TRB->BM_CAPDIA
				cDesc80  += If (AllTrim(cDesAnt) $ cDesc80, "", AllTrim(cDesAnt) + " / ")
				nQADia    += TRB->C6_QTDVEN - TRB->C6_QTDENT
				nCTotGeral+= TRB->BM_CAPDIA
				nLimGeral += TRB->BM_CAPDIA - (TRB->C6_QTDVEN - TRB->C6_QTDENT)
				TRB->(DbSkip())
			EndDo
					
			nQAProd := 0
			cCTotDia:= 0
		ElseIf AllTrim(TRB->B1_GRUPO) $ "605/617"  //Familia 22 e 31
			While !TRB->(EOF()) .AND. cGrpAnt == TRB->B1_GRUPO
				nQAP22   += TRB->C6_QTDVEN - TRB->C6_QTDENT
				nCTotD22 := TRB->BM_CAPDIA
				cDesc22  += If (AllTrim(cDesAnt) $ cDesc22, "", AllTrim(cDesAnt) + " / ")      
				nQADia    += TRB->C6_QTDVEN - TRB->C6_QTDENT
				nCTotGeral+= TRB->BM_CAPDIA
				nLimGeral += TRB->BM_CAPDIA - (TRB->C6_QTDVEN - TRB->C6_QTDENT)   
				TRB->(DbSkip())   
			EndDo
			
			nQAProd := 0
			cCTotDia:= 0
		Else
			While !TRB->(EOF()) .AND. cGrpAnt == TRB->B1_GRUPO
				nQAProd += TRB->C6_QTDVEN - TRB->C6_QTDENT
				nCTotDia:= TRB->BM_CAPDIA
				TRB->(DbSkip())
			EndDo
			
			@nLin,005 PSAY "TOTAL DIA/GRUPO: "
			@nLin,025 PSAY cGrpAnt
			@nLin,045 PSAY cDesAnt
			
			@nLin,120 PSAY nQAProd Picture "@E 999,999,999"
			@nLin,140 PSAY nCTotDia Picture "@E 999,999,999"
			@nLin,160 PSAY nCTotDia-nQAProd Picture "@E 999,999,999"
			
			nQADia    += nQAProd
			nCTotGeral+= nCTotDia
			nLimGeral += nCTotDia - nQAProd
			
			
			nQAProd := 0
			cCTotDia:= 0
			nLin++
			
		EndIf
		
		If cData <> TRB->C6_ENTREG
			
			If nQAP80>0
				@nLin,005 PSAY "TOTAL DIA/GRUPO: "
				@nLin,025 PSAY "612/613"
				@nLin,045 PSAY "Familia REF.80 / Familia REF.81" //cDesc80
				
				@nLin,120 PSAY nQAP80 Picture "@E 999,999,999"
				@nLin,140 PSAY nCTotD80 Picture "@E 999,999,999"
				@nLin,160 PSAY nCTotD80-nQAP80 Picture "@E 999,999,999"
				nLin++
				nQAP80 	  :=0
				nCTotD80  :=0
				cDesc80	  :=""
			EndIF

			If nQAP22>0
				@nLin,005 PSAY "TOTAL DIA/GRUPO: "
				@nLin,025 PSAY "605/617"
				@nLin,045 PSAY "Familia REF.22 / Familia REF.31"//cDesc22
				
				@nLin,120 PSAY nQAP22 Picture "@E 999,999,999"
				@nLin,140 PSAY nCTotD22 Picture "@E 999,999,999"
				@nLin,160 PSAY nCTotD22 - nQAP22 Picture "@E 999,999,999"
				nLin++
				nQAP22 	  :=0
				nCTotD22  :=0
				cDesc22	  :=""
			EndIF
			
			@nLin,040 PSAY "TOTAL GERAL DIA: " +  DToC(SToD(cData))
			@nLin,120 PSAY nQADia    Picture "@E 999,999,999"
			nQADiaTot+= nQADia
			@nLin,140 PSAY nCTotGeral Picture "@E 999,999,999"
			@nLin,160 PSAY nLimGeral Picture "@E 999,999,999"
			
			nLin++
			@nLin,000 PSAY Replicate("_",220)
			nLin++
			nQAProd := 0
			nQAProd := 0
			nQADia  := 0
			nCTotGeral := 0
			nLimGeral := 0
			
		EndIf
		
	EndDo
	nLin++
	@nLin,040 PSAY "TOTAL GERAL PERIODO: " +  DToC(MV_PAR05) +" ATE "+DToC(MV_PAR06)
	@nLin,120 PSAY nQADiaTot 	   Picture "@E 999,999,999,999"
	@nLin,000 PSAY Replicate("_",220)
	
EndIf

TRB->(dbCloseArea())

SET DEVICE TO SCREEN


If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return

Static Function CargaGrp(cGrupo, dDataIni, dDataFim)

cGrupo:= AllTrim(cGrupo)

cQuery:= " SELECT ISNULL((SUM(C6_QTDVEN)-SUM(C6_QTDENT)),0) QTD_OCUP  " +CRLF
cQuery+= " FROM "+RetSqlName("SBM")+" BM  " +CRLF
cQuery+= " INNER JOIN "+RetSqlName("SB1")+" B1 ON B1_FILIAL='"+XFilial("SB1")+"' AND ((B1_GRUPO = BM_GRUPO AND B1_XGRUPO = '') OR B1_XGRUPO = BM_GRUPO) AND B1.D_E_L_E_T_<>'*' AND B1_TIPO='PA'  " +CRLF
cQuery+= " INNER JOIN "+RetSqlName("SC6")+" C6 ON C6_FILIAL='"+XFilial("SC6")+"' AND C6_PRODUTO=B1_COD AND C6.D_E_L_E_T_<>'*' AND C6_PRODUTO BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "'      " +CRLF
//cQuery+= " LEFT  JOIN " + RetSqlName("SC6") + " C6 ON C6_FILIAL = '" + xFilial('SC6')  + "'  AND C2_PEDIDO=C6_NUM  AND C2_ITEMPV=C6_ITEM AND C6.D_E_L_E_T_<>'*'   
cQuery+= " WHERE	BM_FILIAL='"+XFilial("SBM")+"'  " +CRLF  
If cGrupo=="612" .or. cGrupo=="613"
	cQuery+= " 		AND (BM_GRUPO='612' OR BM_GRUPO='613') " +CRLF
ElseIf cGrupo=="605" .or. cGrupo=="617"
	cQuery+= " 		AND (BM_GRUPO='605' OR BM_GRUPO='617') " +CRLF
Else
	cQuery+= " 		AND BM_GRUPO='"+cGrupo+"'  " +CRLF  
EndIf
cQuery+= " 		AND BM.D_E_L_E_T_<>'*'  " +CRLF
//cQuery+= " 		AND C2_DATPRI>='"+DToS(dDataIni)+"'  " +CRLF        
//cQuery+= " 		AND C2_DATPRF<='"+DToS(dDataFim)+"'  " +CRLF 
cQuery+= " 		AND C6_ENTREG BETWEEN '" + DToS(dDataIni) + "' AND '" + DToS(dDataFim) + "'    " +CRLF
		
MemoWrite('C:\qry\qrygrp.txt',cQuery)

DbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), "GRP", .F., .T. )     

nQtOcup:= GRP->QTD_OCUP

GRP->(DbCloseArea())


Return (nQtOcup)

Static Function AjustaSX1()

PutSx1(cPerg, "01","Item De      ?","","","mv_ch1" ,"C",15,0,0,"G","","SB1","","","mv_par01","","","","","","","","","","","","","","","","","","","")
PutSx1(cPerg, "02","Item Ate     ?","","","mv_ch2" ,"C",15,0,0,"G","","SB1","","","mv_par02","","","","","","","","","","","","","","","","","","","")
PutSx1(cPerg, "03","Grupo        ?","","","mv_ch3" ,"C",04,0,0,"G","","SBM","","","mv_par03","","","","","","","","","","","","","","","","","","","")
PutSx1(cPerg, "04","Tipo         ?","","","mv_ch4", "N",01,0,0,"C","","   ","","","mv_par04","Detalhado",""      ,""      ,""    ,"Sintetico"    ,""     ,""      ,"Sintetico Grupo",""      ,""      ,""            ,""      ,""     ,""        ,""      ,""      ,""      ,""      ,""      ,"")
PutSx1(cPerg, "05","Entrega De   ?","","","mv_ch5" ,"D",08,0,0,"G","","   ","","","mv_par05","","","","","","","","","","","","","","","","","","","")
PutSx1(cPerg, "06","Entrega Ate  ?","","","mv_ch6" ,"D",08,0,0,"G","","   ","","","mv_par06","","","","","","","","","","","","","","","","","","","")

Return()
