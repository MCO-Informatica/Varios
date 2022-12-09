#Include "Protheus.ch"
#Include "TopConn.ch"

/*
+=======================================================+
|Programa: COMR002|Autor: Antonio Carlos |Data: 09/03/11|
+=======================================================+
|Descrição: Relatório de Perdas/Revistas.               |
+=======================================================+
|Uso: Especifico Laselva                                |
+=======================================================+
*/

User Function COMR002()

Local cDesc1       := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2       := "com os produtos do Acerto de Consignacao - Revistas. "
Local cDesc3       := " "
Local cPict        := ""
Local titulo       := "ACERTO DE REVISTAS " 
Local nLin         := 80

//012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//          10        20        30        40        50        60        70        80        90        100       110       120       130       140
//Produto           Descricao                       Custo         Consignacao           Vendas        Devolucao     Compra        Perda         Valor

Local Cabec1       := "Produto           Descricao                                 Custo       Consignacao   Vendas        Devolucao     Compra         Perda        Valor"
Local Cabec2       := ""              
Local imprime        := .T.
Local aOrd           := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 220
Private tamanho      := "G"
Private nomeprog     := "RelPerdas" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "RelPerdas" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := ""

wnrel := SetPrint(cString,NomeProg,"",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

ACalcDt(6, 3, dDataBase)

RptStatus({|| RunRel03(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREL03  º Autor ³ AP6 IDE            º Data ³  13/02/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunRel03(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem

Local _cStrAux 	:= ""
Local _cStrCod 	:= ""
Local _aItens	:= {}

Local _nQtdPT	:= 0
Local _nValPT	:= 0
Local _nValP 	:= 0
Local _nQtdPTP	:= 0 
Local _nQtdP	:= 0
Local _nValPTP	:= 0
Local _nQtdG 	:= 0
Local _nQtdPTG	:= 0
Local _nValPTG	:= 0

Local nHdl			:= 0		// Handle do arquivo de log de erros
Local cEOL			:= ""		// Variavel para caractere de CR + LF
Local _cLinha		:= ""		// Conteudo da Linha a ser gravada
Local _lRet			:= 0
Local _cReferArq	:= "ACERTO_"+SM0->M0_FILIAL+"_"+DToS(dDataBase)
Local cDir			:= GetMv("MV_LSVCONS")

_cStrCod := Substr(_cStrAux,1,Len(_cStrAux)-1)

If Select("TMP") > 0
	DbSelectArea("TMP")
	DbCloseArea()
EndIf

cQry := " SELECT A.D2_COD, A.D2_CLIENTE, A.D2_LOJA, B.B1_DESC, "
cQry += " COALESCE((SELECT SUM(E.D1_QUANT) FROM "+RetSqlName("SD1")+" E WITH(NOLOCK)  WHERE E.D1_FILIAL = '"+xFilial("SD2")+"' AND E.D1_COD = A.D2_COD AND E.D1_TES = '229' AND  E.D_E_L_E_T_ = ''),0) AS 'CONSIGNADA', "
cQry += " COALESCE((SELECT D1_CUSTO/D1_QUANT FROM "+RetSqlName("SD1")+" F WITH(NOLOCK)  WHERE F.D1_FILIAL = '"+xFilial("SD2")+"' AND F.D1_COD = A.D2_COD AND F.D1_TES = '229' AND  F.D_E_L_E_T_ = ''),0) AS 'CUSTO', "
cQry += " COALESCE((SELECT SUM(D.D2_QUANT) FROM "+RetSqlName("SD2")+" D WITH(NOLOCK)  WHERE D.D2_FILIAL = '"+xFilial("SD2")+"' AND D.D2_COD = A.D2_COD AND D.D2_TES = '730' AND  D.D_E_L_E_T_ = ''),0) AS 'DEVOLVIDA',"
cQry += " COALESCE(SUM(A.D2_QUANT),0) AS 'VENDIDA', " 
cQry += " COALESCE((SELECT SUM(C.D2_QUANT) FROM "+RetSqlName("SD2")+" C WITH(NOLOCK)  WHERE C.D2_FILIAL = '"+xFilial("SD2")+"' AND C.D2_COD = A.D2_COD AND C.D2_TES = '734' AND  C.D_E_L_E_T_ = ''),0) AS 'COMPRA', "
cQry += " COALESCE((SELECT SUM(A.D2_QUANT) FROM SD2010 A WITH(NOLOCK) WHERE "
cQry += " A.D2_FILIAL = '"+xFilial("SD2")+"' AND A.D2_EMISSAO >= '20110301' AND A.D2_CLIENTE = '999999' AND  A.D2_TIPO = 'N' AND  A.D_E_L_E_T_ = ''),0) - "
cQry += " COALESCE((SELECT SUM(C.D2_QUANT) FROM "+RetSqlName("SD2")+" C WITH(NOLOCK)  WHERE C.D2_FILIAL = '"+xFilial("SD2")+"' AND C.D2_COD = A.D2_COD AND C.D2_TES = '734' AND  C.D_E_L_E_T_ = ''),0) AS 'DIFERENCA' "
cQry += " FROM "+RetSqlName("SD2")+" A WITH(NOLOCK) "
cQry += " INNER JOIN "+RetSqlName("SB1")+" B WITH(NOLOCK)  ON B.B1_COD = A.D2_COD AND B.D_E_L_E_T_ = '' "
cQry += " WHERE "
If SM0->M0_CODFIL == "01"
	cQry += " A.D2_FILIAL IN ( "+GetMv("MV_FILILSV")+" ) AND " 
Else
	cQry += " A.D2_FILIAL = '"+xFilial("SD2")+"' AND "
EndIf
cQry += " A.D2_EMISSAO >= '20110301' AND ( A.D2_ORIGLAN = 'LO' OR A.D2_CLIENTE = '999999' ) AND "
//cQry += " A.D2_COD IN ( "+_cStrCod+" )  AND "
cQry += " A.D2_TIPO = 'N' AND "
cQry += " A.D_E_L_E_T_ = '' "
cQry += " GROUP BY A.D2_COD, A.D2_CLIENTE, A.D2_LOJA, B.B1_DESC "
cQry += " ORDER BY A.D2_CLIENTE, A.D2_LOJA, B.B1_DESC "

Memowrite("COMR002.SQL",cQry)
TcQuery cQry NEW ALIAS "TMP"

SetRegua( RecCount() )
   
If nLin > 55 
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	nLin := 9
EndIf    
	
DbSelectArea("TMP")	
TMP->( DbGoTop() )
If TMP->( !Eof() )

	While TMP->( !Eof() )
	
		If TMP->DIFERENCA <> 0
						
			While TMP->( !Eof() )
		
				If TMP->DIFERENCA < 0
					_nQtdP := (TMP->DIFERENCA*(-1))
					_nValP := TMP->CUSTO*_nQtdP					
					_nQtdPTP += _nQtdP
					_nValPTP += _nValP
				Else
					_nQtdG := TMP->DIFERENCA	
					_nValP := TMP->CUSTO * _nQtdG									
					_nQtdPTG += _nQtdG
					_nValPTG += _nValP
				EndIf
				
				@ nLin,01	PSAY TMP->D2_COD
				@ nLin,18	PSAY Substr( Posicione("SB1",1,xFilial("SB1")+TMP->D2_COD,"B1_DESC"),1,30 ) 
				@ nLin,50	PSAY TMP->CUSTO			Picture "@E 999,999,999.99"   				
   				@ nLin,64	PSAY TMP->CONSIGNADA	Picture "@E 999,999,999.99"
				@ nLin,78	PSAY TMP->VENDIDA		Picture "@E 999,999,999.99"
				@ nLin,92	PSAY TMP->DEVOLVIDA		Picture "@E 999,999,999.99"
				@ nLin,106	PSAY TMP->COMPRA		Picture "@E 999,999,999.99"
				@ nLin,120	PSAY _nQtdP				Picture "@E 999,999,999.99"
				@ nLin,134	PSAY _nValP				Picture "@E 999,999,999.99"
				
				nLin := nLin + 1 
														
				TMP->( DbSkip() )
		
			EndDo 
			
			_nQtdPT += _nQtdPTP-_nQtdPTG
			_nValPT	+= _nValPTP-_nValPTG
							
		EndIf					
	    	
		TMP->( DbSkip() )
		
	EndDo
	
EndIf

FClose(nHdl)

SET DEVICE TO SCREEN

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return     

Static Function TkExpXls() 

Local _cArqExp:= ""
Local _nI     := 0
Local nHdl    := 0
Local cEOL    := "CHR(13)+CHR(10)"
Local n		  := 0

Private aExcel := {}

_cArqExp := cGetFile("Exportacao Excel|*.CSV|","Escolha o arquivo",0,"C:\",.T.,GETF_LOCALHARD) 

If Empty(Alltrim(_cArqExp))
	Return
EndIf

If At( ".CSV", Upper(_cArqExp) ) == 0
	_cArqExp += ".CSV"
EndIf

If Empty(cEOL)
    cEOL := CHR(13) + CHR(10)
Else
    cEOL := Trim(cEOL)
    cEOL := &cEOL
Endif

If (nHdl := fCreate(_cArqExp) ) == -1
    MsgAlert("O arquivo " + _cArqExp + " nao pode ser criado! Verifique os parâmetros.","Atenção!")
    Return
Endif

For n := 1 To Len(aDados)
	//Gera informação apenas dos aglutinados marcados.
	If aDados[n,1]
		Processa({|| TKFAT1Ped("E", aDados[n,2], aDados[n,3], aDados[n,4], aDados[n,6], aDados[n,7], aDados[n,9], aDados[n,10], aDados[n,12])}, "Aguarde...", "Selecionando Pedidos.", .F. )
	EndIf
Next

cCpo := 'Filial;Cliente;Loja;Nome;Contrato;Pedido;Cond. Pagto;TES;Produto;Descrição;Quantidade;Preço Venda;Voucher;Veiculo;Documento;Nome;Placa;Chassi;Cor;Fabricação;Modelo;Tipo;Requisição;Emissão;Marca' + cEOL

cLin := Space(Len(cCpo)) + cEOL
cLin := Stuff(cLin,01,Len(cLin),cCpo)

If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
	MsgInfo("Ocorreu um erro na gravação do arquivo.","Atenção!")
    Return
Endif

For n:=1 To Len(aExcel)

	cCpo :=	aExcel[n,1]		 		+ ";" +;
			aExcel[n,2] 			+ ";" +;
         	aExcel[n,3]	 			+ ";" +;
         	aExcel[n,4]	 			+ ";" +;
         	aExcel[n,5]		 		+ ";" +;
         	aExcel[n,6]		 		+ ";" +;
         	aExcel[n,7] 			+ ";" +;
         	aExcel[n,8] 			+ ";" +;
         	aExcel[n,9]				+ ";" +;
			aExcel[n,10]			+ ";" +;
			Str(aExcel[n,11])		+ ";" +;   	
			Str(aExcel[n,12])		+ ";" +;
			aExcel[n,13]			+ ";" +;
			aExcel[n,14]			+ ";" +;
			aExcel[n,15]			+ ";" +;
			aExcel[n,16]			+ ";" +;
			aExcel[n,17]			+ ";" +;
			aExcel[n,18]			+ ";" +;
			aExcel[n,19]			+ ";" +; 
			aExcel[n,20]	 		+ ";" +;
			aExcel[n,21] 			+ ";" +;
			aExcel[n,22] 			+ ";" +;
			aExcel[n,23] 			+ ";" +;
			DtoC(StoD(aExcel[n,24]))+ ";" +; 
			aExcel[n,25]			+ cEOL
	
    cLin := Space(Len(cCpo)) + cEOL
    cLin := Stuff(cLin,01,Len(cLin),cCpo)

    If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
        MsgInfo("Ocorreu um erro na gravação do arquivo.","Atenção!")
        Return
    Endif

Next

fClose(nHdl)

If !ApOleClient("MsExcel")
	MsgInfo("Microsoft Excel não está instalado nessa máquina.","Atenção")
Else
	oExcelApp := MsExcel():New()
	oExcelApp:WorkBooks:Open(_cArqExp)
	oExcelApp:SetVisible(.T.)
EndIf

Return

Static Function ACalcDt(nPeriodo, nTipo, dDtBase)
//Declara variaveis
Local dDtMin	:= CtoD("  /  /  ")
Local dDtMax	:= dDataBase
Local cDtAux	:= ""
Local nQtdAnos 	:= 0
Local nQtdMeses	:= 0
Local aRet		:= {}

//Calcula periodo de acordo com o tipo selecionado
If nTipo == 1 //Dias
	dDtMin:= dDtBase - nPeriodo
ElseIf nTipo == 2 //Semanas
	dDtMin:= dDtBase - (nPeriodo * 7)               
Else //Meses
	nQtdAnos := Int(nPeriodo / 12)
	nQtdMeses:= nPeriodo - (nQtdAnos * 12)
    
	//Calcula data inicial do periodo
	cDtAux:= StrZero(Day(dDtBase),2,0) + "/" + StrZero((Month(dDtBase)- nQtdMeses),2,0) + "/" + StrZero((Year(dDtBase)- nQtdAnos),4,0)
	dDtMin:= CtoD(cDtAux)
	
	//Caso a data seja invalida - Ex 30/02/2007 - Pega o ultimo dia do mes
	If Empty(dDtMin)
		cDtAux:= "01" + SubStr(cDtAux, 3, 8)
		dDtMin:= LastDay(CtoD(cDtAux))
	EndIf
EndIf

//Define retorno - {1.Data Inicial,2.Data Final}
aAdd(aRet, dDtMin) 
aAdd(aRet, dDtMax) 

Return aRet                                                                                                            