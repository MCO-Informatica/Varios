#INCLUDE "rwmake.ch" 
#INCLUDE "protheus.ch"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RQUA006   � Autor � Giane              � Data �  25/02/11   ���                     
�������������������������������������������������������������������������͹��
���Descricao � Relatorio Resumo de variaoes dos graneis                   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Makeni /                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function RQUA006()

	Local cDesc1       := "Este programa tem como objetivo imprimir relatorio "
	Local cDesc2       := "de acordo com os parametros informados pelo usuario."
	Local cDesc3       := "Resumo de Varia��es"
	Local cPict        := ""
	Local titulo       := "Resumo de Varia��es dos Graneis"
	Local nLin         := 80    
	Local cPerg        := 'RQUA006'                       
	Local Cabec1       := ""
	Local Cabec2       := ""
	Local imprime      := .T.
	Local aOrd         := {} 
	Local aConf        := {}   
	Local cQuery       := ""      
	Local aAreaAnt     := GetArea()
	Local i := 0

	//oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "RQUA006" , __cUserID )

	Private aPos := Array(13)
	Private lEnd         := .F.
	Private lAbortPrint  := .F.
	Private CbTxt        := ""
	Private limite       := 220
	Private tamanho      := "G"
	Private nomeprog     := "RQUA006" // Coloque aqui o nome do programa para impressao no cabecalho
	Private nTipo        := 15
	Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
	Private nLastKey     := 0
	Private cbtxt        := Space(10)
	Private cbcont       := 00
	Private CONTFL       := 01
	Private m_pag        := 01
	Private wnrel        := "RQUA006" 


	Private cString   

	Cabec1 := "                        "
	For i := 1 To 12
		aPos[i] := Len(Cabec1) + 3
		Cabec1 += PadL(MesExtenso(i), 14)
	Next
	aPos[13] := Len(Cabec1) + 3
	Cabec1 += PadL("Media", 14)

	if !Pergunte(cPerg)
		Return
	Endif     

	cString := "XREC"                                                                                                   
	If Select(cString) > 0
		(cString)->(DbCloseArea())
	EndIf

	cQuery := MontaQry()

	cQuery := ChangeQuery(cQuery) 

	MsgRun("Selecionando registros, aguarde...","Relat�rio Resumo de Varia��es", {|| dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cString,.T.,.T.) })    

	if MV_PAR04 == 1  //EXCEL
		GeraExcel()
	Else 	

		wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,Tamanho,,.F.)

		If nLastKey == 27
			Return
		Endif

		SetDefault(aReturn,cString)

		nTipo := If(aReturn[4]==1,15,18)

		//���������������������������������������������������������������������Ŀ
		//� Processamento. RPTSTATUS monta janela com a regua de processamento. �
		//�����������������������������������������������������������������������

		RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)   

	Endif

	If Select(cString) > 0
		(cString)->(DbCloseArea())
	EndIf

	RestArea(aAreaAnt)
Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MontaQry  � Autor � Giane              � Data �  23/02/11   ���
�������������������������������������������������������������������������͹��
���Descricao � Monta query para imprimir relatorio                        ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Makeni /                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function MontaQry()  
	Local cQuery := ""
	cQuery := "SELECT "    
	//cQuery += "  SUBSTR(SD1.D1_DTDIGIT,5,2) MES,  " 
	cQuery += "  SUBSTR(SZI.ZI_DTINI,5,2) MES,  " 
	cQuery += "  SUM( SB1.B1_PESO * SD1.D1_QUANT ) PESOORI, "  
	cQuery += "  SUM( SZI.ZI_PESINI - SZI.ZI_PESFIM) PESOREC, "                             
	cQuery += "  SUM( (SZI.ZI_PESINI - SZI.ZI_PESFIM) - (SB1.B1_PESO * SD1.D1_QUANT) ) QTDVARIA, "  
	// linha abaixo: se o percentual de variacao retornar "NULL", usa o decode pra jogar 0(zero) no lugar, senao o order by nao funciona   
	cQuery += "  DECODE( ABS( SUM( (SZI.ZI_PESINI - SZI.ZI_PESFIM) - (SB1.B1_PESO * SD1.D1_QUANT) ) * 100) / SUM( SB1.B1_PESO * SD1.D1_QUANT ), NULL, 0,  ABS(SUM( (SZI.ZI_PESINI - SZI.ZI_PESFIM) - (SB1.B1_PESO * SD1.D1_QUANT) )*100) / SUM( SB1.B1_PESO * SD1.D1_QUANT ) ) PERCVARIA, "
	cQuery += "  COUNT(DISTINCT SD1.D1_COD) QTDPROD "
	cQuery += "FROM " 
	cQuery +=    RetSqlName("SD1") + " SD1 " 
	cQuery += "RIGHT JOIN "
	cQuery +=    RetSqlName("SZI") + " SZI ON "
	cQuery += "  AND SZI.ZI_DOC = SD1.D1_DOC AND SZI.ZI_SERIE = SD1.D1_SERIE "
	cQuery += "  AND SZI.ZI_ITEM = SD1.D1_ITEM "
	cQuery += "  AND SZI.ZI_FORNECE = SD1.D1_FORNECE AND SZI.ZI_LOJA = SD1.D1_LOJA "
	cQuery += "  AND SD1.D1_FILIAL = '" + xFilial("SD1") +  "' AND SD1.D_E_L_E_T_ = ' ' "   
	cQuery += "JOIN "
	cQuery +=    RetSqlName("SB1") + " SB1 ON "
	cQuery += "  SB1.B1_FILIAL = '" + xFilial("SB1") + "'  "  
	cQuery += "  AND SB1.B1_COD = SD1.D1_COD "
	cQuery += "  AND SB1.D_E_L_E_T_ = ' ' "   
	cQuery += "LEFT JOIN "
	cQuery +=    RetSqlName("SF1") + " SF1 ON "
	cQuery += "  SF1.F1_FILIAL = '" + xFilial("SF1") + "'  "  
	cQuery += "  AND SF1.F1_DOC = SD1.D1_DOC "
	cQuery += "  AND SF1.F1_SERIE = SD1.D1_SERIE  AND SF1.D_E_L_E_T_ = ' ' "   
	cQuery += "  AND SF1.F1_FORNECE = SD1.D1_FORNECE AND SF1.F1_LOJA = SD1.D1_LOJA " 
	cQuery += "WHERE "     
	cQuery += "  SZI.ZI_FILIAL = '" + xFilial("SZI") + "'  "  
	cQuery += "  AND SZI.D_E_L_E_T_ = ' ' "  
	cQuery += "  AND SUBSTR(SZI.ZI_DTINI,1,4) = '" + MV_PAR01 + "' "   
	cQuery += "  AND SUBSTR(SZI.ZI_DTINI,5,2) BETWEEN '" + strzero(MV_PAR02,2) + "' AND '" + strzero(MV_PAR03,2)  + "' "
	cQuery += "  AND (SB1.B1_TIPCAR = '000001' OR SB1.B1_TIPCAR IS NULL) " //granel  
	cQuery += "GROUP BY SUBSTR(SZI.ZI_DTINI,5,2)  "
	cQuery += "ORDER BY SUBSTR(SZI.ZI_DTINI,5,2) "  

	//cQuery += "  AND SUBSTR(SD1.D1_DTDIGIT,1,4) = '" + MV_PAR01 + "' "   
	//cQuery += "  AND SUBSTR(SD1.D1_DTDIGIT,5,2) BETWEEN " + strzero(MV_PAR02,2) + " AND " + strzero(MV_PAR03,2) 
	//cQuery += "  AND SD1.D1_TIPO = 'N' " 
	//cQuery += "GROUP BY SUBSTR(SD1.D1_DTDIGIT,5,2)  "
	//cQuery += "ORDER BY SUBSTR(SD1.D1_DTDIGIT,5,2) "  

	//memowrite('c:\RQUA006.sql',cquery)

Return cQuery

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    �RUNREPORT � Autor � AP6 IDE            � Data �  18/11/09   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS ���
���          � monta a janela com a regua de processamento.               ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

	Local nOrdem   
	Local aMes := array(12) 
	Local aLinhas 
	Local nMedia := 0
	Local nX := 0

	aFill(aMes, { 0, 0, 0, 0, 0 })

	aLinhas:= { "Recebido Origem(KG)","Recebido Real(KG)","Varia��o(KG)","%Varia��o","Qtd. Produtos" }

	dbSelectArea(cString)

	(cString)->(DbEval({|| aMes[val(MES)] := { PESOORI, PESOREC, QTDVARIA, PERCVARIA, QTDPROD } }) )

	SetRegua(len(aMes))

	For nx := 1 to 5

		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif

		If nLin > 63 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		Endif 		

		@nLin,000 PSAY aLinhas[nx]

		nMedia := 0
		For ny := 1 to len(aMes)

			@nLin,aPos[ny] PSAY  Transform( aMes[nY,nx], "@E 999,999,999")     

			nMedia += aMes[nY,nx] 		 

		Next   

		@nLin,aPos[13] PSAY  Transform( (nMedia / ((MV_PAR03-MV_PAR02)+1 ) ), "@E 999,999,999")    

		nLin++

	Next

	SET DEVICE TO SCREEN

	If aReturn[5]==1
		dbCommitAll()
		SET PRINTER TO
		OurSpool(wnrel)
	Endif

	MS_FLUSH()

Return

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GeraExcel �Autor  � Giane              � Data � 19/11/2009  ���
�������������������������������������������������������������������������͹��
���Desc.     � Exporta relatorio para o excel                             ���
���          �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
Static Function GeraExcel()
	Local aDados := {}   
	Local aCabec := {}   
	Local cPeriodo := ""
	Local aMes := array(12) 
	Local aLinhas 
	Local nMedia := 0    
	Local aAux := {}

	aFill(aMes, { 0, 0, 0, 0, 0 })

	aadd(aCabec, "")
	For i := 1 To 12
		aadd(aCabec, PadL(MesExtenso(i), 14) )
	Next
	aadd(aCabec, "Media")

	aLinhas:= { "Recebido Origem(KG)","Recebido Real(KG)","Varia��o(KG)","%Varia��o","Qtd. Produtos" }

	dbSelectArea(cString)

	(cString)->(DbEval({|| aMes[val(MES)] := { PESOORI, PESOREC, QTDVARIA, PERCVARIA, QTDPROD } }) )

	For nx := 1 to 5 
		aAux := {}
		aadd(aAux, aLinhas[nx] )

		nMedia := 0
		For ny := 1 to len(aMes)

			aadd(aAux,  Transform( aMes[nY,nx], "@E 999,999,999")  )    

			nMedia += aMes[nY,nx] 		 

		Next   

		aadd(aAux,  Transform( (nMedia / ((MV_PAR03-MV_PAR02)+1 ) ), "@E 999,999,999")   )  

		aadd(aDados, aAux)

	Next

	cPeriodo := " Ano " + (MV_PAR01) + " M�s " + strzero(MV_PAR02,2) + " At� " + strzero(MV_PAR03,2)

	DlgToExcel({ {"ARRAY", "Resumo de Varia��es dos Graneis -" + cPeriodo, aCabec, aDados} })

Return