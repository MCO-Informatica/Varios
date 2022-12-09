#INCLUDE "Totvs.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CRPR080   º Autor ³ Renato Ruy         º Data ³  02/01/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Codigo gerado pelo AP6 IDE.                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function CRPR080


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Relatório Sintetico de Remuneração"
Local cPict          := ""
Local titulo       := "Relatório Sintetico de Remuneração"
Local nLin         := 80

Local Cabec1       := "Relatório contendo todas informações das remunerações referente ao mês"
Local Cabec2       := ""
Local imprime      := .T.
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite           := 220
Private tamanho          := "G"
Private nomeprog         := "NOME" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo            := 18
Private aReturn          := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey        := 0
Private cPerg       := "CPR080"
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "NOME" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := "SZ6"

dbSelectArea("SZ6")
dbSetOrder(1)

ValidPerg()

pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  02/01/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem
Local cImpLin := ""
Local nTotal  := 0
Local nQuant  := 0
Local nValHar := 0
Local nValSof := 0
Local nValFat := 0
Local nVlFatu := 0
Local nVlLiq  := 0
Local nVlDesc := 0
Local nVlComi := 0
Local cCodCCR := ""
Local cCodAc  := ""
Local cDesEnt := ""
Local lQuebra := .F.

dbSelectArea(cString)
dbSetOrder(1)

titulo := "Relatório Sintetico de Remuneração" + MV_PAR01

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetRegua(RecCount())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta Query Para impressão da Sincor e Credenciada					³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If (AllTrim(MV_PAR02) $ "SIN/CRD/CACB/FECO/CER/BR/NOT/SINR" .Or. Empty(MV_PAR02)) .And. MV_PAR03 == 1
	cQuery := " SELECT  Z6_PRODUTO, "
	cQuery += " Z6_DESCRPR, "
	cQuery += " Z6_CODCCR, "
	cQuery += " Count(*) Quant, "
	cQuery += " Z6_CODAC, "
	cQuery += " SUM(BASE_HARDWARE) BASE_HARDWARE, "
	cQuery += " SUM(BASE_SOFTWARE) BASE_SOFTWARE, "
	cQuery += " SUM(BASE_COMISSAO) BASE_COMISSAO, "
	cQuery += " SUM(VALOR_COMISSAO) VALOR_COMISSAO "
	cQuery += " From (SELECT "
	cQuery += " Z6_PRODUTO, "
	cQuery += " Z6_DESCRPR, "
	cQuery += " Z6_CODCCR, "
	cQuery += " Z6_PEDGAR, "
	cQuery += " Z6_PEDSITE, "
	cQuery += " Z6_CODAC, "
	cQuery += " SUM(CASE WHEN Z6_CATPROD = '1' THEN Z6_BASECOM ELSE 0 END) BASE_HARDWARE, "
	cQuery += " SUM(CASE WHEN Z6_CATPROD = '2' THEN Z6_BASECOM ELSE 0 END) BASE_SOFTWARE, "
	cQuery += " SUM(Z6_BASECOM) BASE_COMISSAO, "
	cQuery += " SUM(Z6_VALCOM) VALOR_COMISSAO "
	cQuery += " FROM " + RetSQLName("SZ6") + " SZ6 "
	cQuery += " JOIN PROTHEUS.SZ3010 SZ3 ON SZ3.Z3_FILIAL = ' ' AND Z6_CODENT = SZ3.Z3_CODENT AND SZ3.D_E_L_E_T_ = ' ' "
  	cQuery += " LEFT JOIN PROTHEUS.SZF010 SZF ON ZF_FILIAL = ' ' AND ZF_COD = Z6_CODVOU AND ZF_COD > '0' AND SZF.D_E_L_E_T_ = ' ' AND Trim(ZF_PDESGAR) = Trim(Z6_PRODUTO) AND ZF_SALDO = 0 "
	cQuery += " LEFT JOIN PROTHEUS.SZ5010 SZ5 ON SZ5.Z5_FILIAL = ' ' AND SZ5.Z5_PEDGAR > '0' AND SZ5.Z5_PEDGAR = Trim(regexp_replace(ZF_PEDIDO,'[[:punct:]]',' ')) AND SZ5.D_E_L_E_T_ = ' 'AND SZ5.Z5_PRODGAR > '0' "
	cQuery += " LEFT JOIN PROTHEUS.SZH010 SZH ON ZH_FILIAL = ' ' AND ZH_TIPO = Z6_TIPVOU AND SZH.D_E_L_E_T_ = ' ' "
	cQuery += " LEFT JOIN PROTHEUS.SZ3010 SZ32 ON SZ32.Z3_FILIAL = ' ' AND Z6_CODPOS = SZ32.Z3_CODGAR AND SZ32.Z3_CODGAR > '0' AND SZ32.Z3_TIPENT = '4' AND SZ32.D_E_L_E_T_ = ' ' "
	cQuery += " WHERE "
	cQuery += " SZ6.D_E_L_E_T_ = ' '  "
	cQuery += " AND Z6_FILIAL = ' '  "
	cQuery += " AND Z6_PERIODO = '"+MV_PAR01+"' "
	cQuery += " AND SubStr(Z6_CODAC,1,4) = '" +MV_PAR02+"' "
	cQuery += " AND z6_tpentid = '4' "
	cQuery += " GROUP BY "
	cQuery += " Z6_PRODUTO, "
	cQuery += " Z6_DESCRPR, "
	cQuery += " Z6_CODCCR, "
	cQuery += " Z6_PEDGAR, "
	cQuery += " Z6_PEDSITE, "
	cQuery += " Z6_CODAC) "
	cQuery += " GROUP BY  "
	cQuery += " Z6_PRODUTO, "
	cQuery += " Z6_DESCRPR, "
	cQuery += " Z6_CODCCR, "
	cQuery += " Z6_CODAC "
	cQuery += " ORDER BY Z6_CODCCR,Z6_PRODUTO "
	
	If Select("SZ6TMP") > 0
		SZ6TMP->( DbCloseArea() )
	EndIf
	
	PLSQuery( cQuery, "SZ6TMP" )
	
	If SZ6TMP->(Eof())
		MsgInfo('Não foi possível encontrar registros com os parâmetros informados.')
		SZ6TMP->( DbCloseArea() )
		Return(.F.)
	EndIf
	
	Cabec1 := ""
	
	Cabec1 += PADR("Cód. Produto"		,25 ," ")
	Cabec1 += PADR("Descrição Produto"	,100," ")
	Cabec1 += PADR("Quantidade"	   		,20 ," ")
	Cabec1 += PADR("Valor Hardware"		,20 ," ")
	Cabec1 += PADR("Valor Software"		,20 ," ")
	Cabec1 += PADR("Valor Faturado"		,20 ," ")
	Cabec1 += PADR("Valor Comissão"		,20 ," ")
	
	SZ6TMP->(dbGoTop())
	
	cCodCCR := SZ6TMP->Z6_CODCCR
	
	If nLin > 60 // Salto de Página. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif
	
	@nLin,00 PSAY "CCR: " + Posicione("SZ3",1,xFilial("SZ3")+SZ6TMP->Z6_CODCCR,"Z3_DESENT")
	@nLin,00 PSAY Replicate("_",220)
	nLin 	:= nLin + 1
	
	
	While !EOF("SZ6TMP")
	
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica o cancelamento pelo usuario...                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif
		
		IncRegua()
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Impressao do cabecalho do relatorio. . .                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		If nLin > 60 // Salto de Página. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		Endif
		
		If  cCodCCR <> SZ6TMP->Z6_CODCCR
			
			//Imprime Totais
			@nLin,00 PSAY Replicate("_",220)
			nLin 	:= nLin + 1
			
			//Imprime Totais
			cImpLin := PADR("SUBTOTAL --> ",125 ," ")
			cImpLin += PADR(Transform(nQuant 			,"@E 999,999,999")		,20 ," ")
			cImpLin += PADR(Transform(nValHar 			,"@E 999,999,999.99")	,20 ," ")
			cImpLin += PADR(Transform(nValSof 			,"@E 999,999,999.99")	,20 ," ")
			cImpLin += PADR(Transform(nValFat			,"@E 999,999,999.99")	,20 ," ")
			cImpLin += PADR(Transform(nTotal 			,"@E 999,999,999.99")	,20 ," ")
			
			@nLin,00 PSAY cImpLin
			
			nLin 	:= nLin + 2
			@nLin,00 PSAY PADL("Total             --> " + Transform(nTotal,"@E 999,999,999.99")	,220 ," ")
			nLin 	:= nLin + 1
			
			If nLin > 60 // Salto de Página. Neste caso o formulario tem 55 linhas...
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 8
			Endif
			
			SZ3->(DbSetOrder(1))
			SZ3->(DbSeek( xFilial("SZ3") + cCodCCR))
			
			If !Empty(SZ3->Z3_CODPAR)
				cQuery2 := " SELECT SUM(Z6_VALCOM) Z6_VALCOM FROM " + RetSQLName("SZ6") + " SZ6 WHERE SZ6.D_E_L_E_T_ = ' ' AND Z6_FILIAL = ' ' AND Z6_PERIODO = '"+MV_PAR01+"' AND Z6_CODENT IN "+FormatIn(AllTrim(SZ3->Z3_CODPAR) + Iif(!Empty(SZ3->Z3_CODPAR2),"," + AllTrim(SZ3->Z3_CODPAR2),""),",")+" AND z6_tpentid = '7' "
			
				If Select("TMP2") > 0
					TMP2->(DbCloseArea())
				EndIf
				PLSQuery( cQuery2, "TMP2" )
				
				@nLin,00 PSAY PADL("Total Campanha    --> " + Transform(TMP2->Z6_VALCOM,"@E 999,999,999.99")	,220 ," ")
				nLin 	:= nLin + 1
				
				nTotal += TMP2->Z6_VALCOM
			EndIf
			
			cQuery2 := " SELECT SUM(Z6_VALCOM) Z6_VALCOM FROM " + RetSQLName("SZ6") + " SZ6 WHERE SZ6.D_E_L_E_T_ = ' ' AND Z6_FILIAL = ' ' AND Z6_PERIODO = '"+MV_PAR01+"' AND Z6_CODENT = '"+AllTrim(cCodCCR)+"' AND z6_tpentid = 'B' "
	
			If Select("TMP2") > 0
				TMP2->(DbCloseArea())
			EndIf
			PLSQuery( cQuery2, "TMP2" )
			
			@nLin,00 PSAY PADL("Visita Externa    --> " + Transform(TMP2->Z6_VALCOM,"@E 999,999,999.99")	,220 ," ")
			nLin 	:= nLin + 1
			
			nTotal += TMP2->Z6_VALCOM

			If AllTrim(MV_PAR02) == "CACB" .OR. AllTrim(MV_PAR02) == "FECO"
			
				cQuery2 := " SELECT SUM(Z6_VALCOM) Z6_VALCOM FROM " + RetSQLName("SZ6") + " SZ6 JOIN " + RetSQLName("SZ3") + " SZ32 ON SZ32.Z3_FILIAL = SZ6.Z6_FILIAL AND SZ32.Z3_CODENT = SZ6.Z6_CODENT AND SZ32.Z3_RETPOS != 'N' AND SZ32.D_E_L_E_T_ = ' ' WHERE SZ6.D_E_L_E_T_ = ' ' AND Z6_FILIAL = ' ' AND Z6_PERIODO = '"+MV_PAR01+"' AND Z6_CODCCR   = '"+AllTrim(cCodCCR)+"' AND z6_tpentid = '8' "
				If Select("TMP3") > 0
					TMP3->(DbCloseArea())
				EndIf
				PLSQuery( cQuery2, "TMP3" )
				
				@nLin,00 PSAY PADL("Total Federação   --> " + Transform(TMP3->Z6_VALCOM,"@E 999,999,999.99")	,220 ," ")
				nLin 	:= nLin + 1
				
				nTotal += TMP3->Z6_VALCOM
				
				//cQuery2 := " SELECT SUM(Z6_VALCOM) Z6_VALCOM FROM " + RetSQLName("SZ6") + " SZ6 WHERE SZ6.D_E_L_E_T_ = ' ' AND Z6_FILIAL = ' ' AND Z6_PERIODO = '"+MV_PAR01+"' AND Z6_CODCCR   = '"+AllTrim(cCodCCR)+"' AND z6_tpentid = '10' "
				//If Select("TMP3") > 0
				//	TMP3->(DbCloseArea())
				//EndIf
				//PLSQuery( cQuery2, "TMP3" )
				
				//@nLin,00 PSAY PADL("Total Adicional   --> " + Transform(TMP3->Z6_VALCOM,"@E 999,999,999.99")	,220 ," ")
				//nLin 	:= nLin + 1
				
				//nTotal += TMP3->Z6_VALCOM
				
			EndIf
			
			/*
			If AllTrim(MV_PAR02) == "FECO"
				
				cQuery2 := " SELECT SUM(Z6_VALCOM) Z6_VALCOM FROM " + RetSQLName("SZ6") + " SZ6 WHERE SZ6.D_E_L_E_T_ = ' ' AND Z6_FILIAL = ' ' AND Z6_PERIODO = '"+MV_PAR01+"' AND Z6_CODCCR   = '"+AllTrim(cCodCCR)+"' AND z6_tpentid IN ('2','5') "
				If Select("TMP3") > 0
					TMP3->(DbCloseArea())
				EndIf
				PLSQuery( cQuery2, "TMP3" )
				
				@nLin,00 PSAY PADL("Total Federação   --> " + Transform(TMP3->Z6_VALCOM,"@E 999,999,999.99")	,220 ," ")
				nLin 	:= nLin + 1
				
				nTotal += TMP3->Z6_VALCOM
				
			EndIf
			*/
			
			If nLin > 60 // Salto de Página. Neste caso o formulario tem 55 linhas...
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 8
			Endif
			
			@nLin,00 PSAY PADL("Total Geral       --> " + Transform(nTotal,"@E 999,999,999.99")	,220 ," ")
			nLin 	:= nLin + 1
			
			//Priscila Kuhn - 09/11/2015
			//Controle de PA dos parceiros
			SZ3->(DbSetOrder(1))
			SZ3->(DbSeek(xFilial("SZ3")+cCodCCR))
			
			//Verifico se tem fornecedor vinculado para fazer busca.
			If !Empty(SZ3->Z3_CODFOR)
				
				cQuery := " SELECT E2_PREFIXO, E2_NUM, E2_PARCELA, E2_VALOR, E2_SALDO, E2_EMISSAO "
				cQuery += " FROM " + RetSqlName("SE2") + " SE2"
				cQuery += " WHERE "
				cQuery += " E2_FILIAL = ' ' AND "
				cQuery += " E2_TIPO = 'PA' AND "
				cQuery += " E2_SALDO > 0 AND "
				cQuery += " E2_FORNECE = '" + SZ3->Z3_CODFOR + "' AND "
				cQuery += " E2_LOJA = '01' AND "
				cQuery += " SE2.D_E_L_E_T_ = ' ' "
				
				If Select("TMP3") > 0
					TMP3->(DbCloseArea())
				EndIf
				
				PLSQuery( cQuery, "TMP3" )
				
				TMP3->(DbGoTop())
				
				//Pulo 2 linhas linha antes de gerar informacoes dos PA's
				If !TMP3->(EOF())
				
					If nLin > 57 // Salto de Página. Neste caso o formulario tem 55 linhas...
						Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
						nLin := 8
						@nLin,00 PSAY "CONTINUAÇÃO PA - CCR: " + Posicione("SZ3",1,xFilial("SZ3")+cCodCCR,"Z3_DESENT")
						nLin 	:= nLin + 1
					Endif 
					
					cLin := "==========================    DADOS PAGAMENTO ANTECIPADO     ==========================="
					@nLin,00 PSAY cLin
					nLin 	:= nLin + 1
					
					//Adiciono cabecalho
					cLin := PADR("PREFIXO"   ,12," ")
					cLin += PADR("TITULO"    ,12," ")
					cLin += PADR("PARCELA"   ,12," ")
					cLin += PADR("DT.EMISSAO",12," ")
					cLin += PADL("VALOR         ",20," ")
					cLin += PADL("SALDO PA      ",20," ")
					
					@nLin,00 PSAY cLin
					nLin 	:= nLin + 1
				EndIf
				
				//Efetuo gravação de dados do relatório em arquivo.
				While !TMP3->(EOF()) 
				
					If nLin > 57 // Salto de Página. Neste caso o formulario tem 55 linhas...
						Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
						nLin := 8
						@nLin,00 PSAY "CONTINUAÇÃO PA - CCR: " + Posicione("SZ3",1,xFilial("SZ3")+cCodCCR,"Z3_DESENT")
						nLin 	:= nLin + 1  
						
						//Adiciono cabecalho
						cLin := PADR("PREFIXO"   ,12," ")
						cLin += PADR("TITULO"    ,12," ")
						cLin += PADR("PARCELA"   ,12," ")
						cLin += PADR("DT.EMISSAO",12," ")
						cLin += PADL("VALOR         ",20," ")
						cLin += PADL("SALDO PA      ",20," ")
	
						@nLin,00 PSAY cLin
						nLin 	:= nLin + 1
					Endif
					
					//Gravo dados PA
					cLin := PADR(TMP3->E2_PREFIXO 								,12," ")
					cLin += PADR(TMP3->E2_NUM	  	   							,12," ")
					cLin += PADR(TMP3->E2_PARCELA 	   							,12," ")
					cLin += PADR(DTOC(TMP3->E2_EMISSAO)							,12," ")
					cLin += PADR(TRANSFORM(TMP3->E2_VALOR, "@E 999,999,999.99")	,20," ")
					cLin += PADR(TRANSFORM(TMP3->E2_SALDO, "@E 999,999,999.99")	,20," ")
					
					@nLin,00 PSAY cLin
					nLin 	:= nLin + 1					
					
					TMP3->(DbSkip())
				EndDo
			
			EndIf
			
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
			
			@nLin,00 PSAY "CCR: " + Posicione("SZ3",1,xFilial("SZ3")+SZ6TMP->Z6_CODCCR,"Z3_DESENT")
			@nLin,00 PSAY Replicate("_",220)
			nLin 	:= nLin + 1
			
			cCodCCR := SZ6TMP->Z6_CODCCR
			cCodAc	:= SZ6TMP->Z6_CODAC

			//Zera valores
			nQuant  	:= 0
			nValHar  	:= 0
			nValSof  	:= 0
			nValFat  	:= 0
			nTotal		:= 0
			
			
		EndIf
				
		cImpLin := PADR(SZ6TMP->Z6_PRODUTO											,25 ," ")
		cImpLin += PADR(SZ6TMP->Z6_DESCRPR											,100," ")
		cImpLin += PADR(Transform(SZ6TMP->QUANT 			,"@E 999,999,999")		,20 ," ")
		cImpLin += PADR(Transform(SZ6TMP->BASE_HARDWARE 	,"@E 999,999,999.99")	,20 ," ")
		cImpLin += PADR(Transform(SZ6TMP->BASE_SOFTWARE 	,"@E 999,999,999.99")	,20 ," ")
		cImpLin += PADR(Transform(SZ6TMP->BASE_COMISSAO 	,"@E 999,999,999.99")	,20 ," ")
		cImpLin += PADR(Transform(SZ6TMP->VALOR_COMISSAO 	,"@E 999,999,999.99")	,20 ," ")
		
		@nLin,00 PSAY cImpLin
		nLin 	:= nLin + 1
		
		//Guarda valores para totalizador
		cImpLin 	:= ""
		nQuant  	+= SZ6TMP->QUANT
		nValHar  	+= SZ6TMP->BASE_HARDWARE
		nValSof  	+= SZ6TMP->BASE_SOFTWARE
		nValFat  	+= SZ6TMP->BASE_COMISSAO
		nTotal		+= SZ6TMP->VALOR_COMISSAO
		
		DbSelectArea("SZ6TMP")
		SZ6TMP->(dbSkip()) // Avanca o ponteiro do registro no arquivo

	EndDo
	
	//Fecha Arquivo usado
	If Select("SZ6TMP") > 0
		SZ6TMP->( DbCloseArea() )
	EndIf
	
	//Imprime Totais
	cImpLin := PADR("SUBTOTAL --> ",125 ," ")
	cImpLin += PADR(Transform(nQuant 			,"@E 999,999,999")		,20 ," ")
	cImpLin += PADR(Transform(nValHar 			,"@E 999,999,999.99")	,20 ," ")
	cImpLin += PADR(Transform(nValSof 			,"@E 999,999,999.99")	,20 ," ")
	cImpLin += PADR(Transform(nValFat			,"@E 999,999,999.99")	,20 ," ")
	cImpLin += PADR(Transform(nTotal 			,"@E 999,999,999.99")	,20 ," ")
	
	@nLin,00 PSAY Replicate("_",220)
	nLin 	:= nLin + 1
	
	@nLin,00 PSAY cImpLin
	nLin 	:= nLin + 2
	
	If nLin > 60 // Salto de Página. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif
	@nLin,00 PSAY PADL("Total             --> " + Transform(nTotal,"@E 999,999,999.99")	,220 ," ")
	nLin 	:= nLin + 1
	If nLin > 60 // Salto de Página. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif
	
	If !Empty(SZ3->Z3_CODPAR)
		cQuery2 := " SELECT SUM(Z6_VALCOM) Z6_VALCOM FROM " + RetSQLName("SZ6") + " SZ6 WHERE SZ6.D_E_L_E_T_ = ' ' AND Z6_FILIAL = ' ' AND Z6_PERIODO = '"+MV_PAR01+"' AND Z6_CODENT IN "+FormatIn(AllTrim(SZ3->Z3_CODPAR) + Iif(!Empty(SZ3->Z3_CODPAR2),"," + AllTrim(SZ3->Z3_CODPAR2),""),",")+" AND z6_tpentid = '7' "
	
		If Select("TMP2") > 0
			TMP2->(DbCloseArea())
		EndIf
		PLSQuery( cQuery2, "TMP2" )
		
		@nLin,00 PSAY PADL("Total Campanha    --> " + Transform(TMP2->Z6_VALCOM,"@E 999,999,999.99")	,220 ," ")
		nLin 	:= nLin + 1
		
		nTotal += TMP2->Z6_VALCOM
	EndIf
	
	cQuery2 := " SELECT SUM(Z6_VALCOM) Z6_VALCOM FROM " + RetSQLName("SZ6") + " SZ6 WHERE SZ6.D_E_L_E_T_ = ' ' AND Z6_FILIAL = ' ' AND Z6_PERIODO = '"+MV_PAR01+"' AND Z6_CODENT = '"+AllTrim(cCodCCR)+"' AND z6_tpentid = 'B' "
	
	If Select("TMP2") > 0
		TMP2->(DbCloseArea())
	EndIf
	PLSQuery( cQuery2, "TMP2" )
	
	@nLin,00 PSAY PADL("Visita Externa    --> " + Transform(TMP2->Z6_VALCOM,"@E 999,999,999.99")	,220 ," ")
	nLin 	:= nLin + 1
	
	nTotal += TMP2->Z6_VALCOM
	
	
	If AllTrim(MV_PAR02) == "CACB" .OR. AllTrim(MV_PAR02) == "FECO"
			
		cQuery2 := " SELECT SUM(Z6_VALCOM) Z6_VALCOM FROM " + RetSQLName("SZ6") + " SZ6 JOIN " + RetSQLName("SZ3") + " SZ32 ON SZ32.Z3_FILIAL = SZ6.Z6_FILIAL AND SZ32.Z3_CODENT = SZ6.Z6_CODENT AND SZ32.Z3_RETPOS != 'N' AND SZ32.D_E_L_E_T_ = ' ' WHERE SZ6.D_E_L_E_T_ = ' ' AND Z6_FILIAL = ' ' AND Z6_PERIODO = '"+MV_PAR01+"' AND Z6_CODCCR   = '"+AllTrim(cCodCCR)+"' AND z6_tpentid = '8' "
		If Select("TMP3") > 0
			TMP3->(DbCloseArea())
		EndIf
		PLSQuery( cQuery2, "TMP3" )
		
		@nLin,00 PSAY PADL("Total Federação   --> " + Transform(TMP3->Z6_VALCOM,"@E 999,999,999.99")	,220 ," ")
		nLin 	:= nLin + 1
		
		nTotal += TMP3->Z6_VALCOM
		
	EndIf
			
	/*
	If AllTrim(MV_PAR02) == "FECO"
		
		cQuery2 := " SELECT SUM(Z6_VALCOM) Z6_VALCOM FROM " + RetSQLName("SZ6") + " SZ6 WHERE SZ6.D_E_L_E_T_ = ' ' AND Z6_FILIAL = ' ' AND Z6_PERIODO = '"+MV_PAR01+"' AND Z6_CODCCR   = '"+AllTrim(cCodCCR)+"' AND z6_tpentid IN ('2','5') "
		If Select("TMP3") > 0
			TMP3->(DbCloseArea())
		EndIf
		PLSQuery( cQuery2, "TMP3" )
		
		@nLin,00 PSAY PADL("Total Federação  --> " + Transform(TMP3->Z6_VALCOM,"@E 999,999,999.99")	,220 ," ")
		nLin 	:= nLin + 1
		
		nTotal += TMP3->Z6_VALCOM
		
	EndIf
	*/
	
	@nLin,00 PSAY PADL("Total Geral       --> " + Transform(nTotal,"@E 999,999,999.99")	,220 ," ")
	nLin 	:= nLin + 1
	
	//Priscila Kuhn - 09/11/2015
	//Controle de PA dos parceiros
	SZ3->(DbSetOrder(1))
	SZ3->(DbSeek(xFilial("SZ3")+cCodCCR))
	
	//Verifico se tem fornecedor vinculado para fazer busca.
	If !Empty(SZ3->Z3_CODFOR)
		
		cQuery := " SELECT E2_PREFIXO, E2_NUM, E2_PARCELA, E2_VALOR, E2_SALDO, E2_EMISSAO "
		cQuery += " FROM " + RetSqlName("SE2") + " SE2"
		cQuery += " WHERE "
		cQuery += " E2_FILIAL = ' ' AND "
		cQuery += " E2_TIPO = 'PA' AND "
		cQuery += " E2_SALDO > 0 AND "
		cQuery += " E2_FORNECE = '" + SZ3->Z3_CODFOR + "' AND "
		cQuery += " E2_LOJA = '01' AND "
		cQuery += " SE2.D_E_L_E_T_ = ' ' "
		
		If Select("TMP3") > 0
			TMP3->(DbCloseArea())
		EndIf
		
		PLSQuery( cQuery, "TMP3" )
		
		TMP3->(DbGoTop())
		
		//Pulo 2 linhas linha antes de gerar informacoes dos PA's
		If !TMP3->(EOF())
		
			If nLin > 57 // Salto de Página. Neste caso o formulario tem 55 linhas...
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 8
				@nLin,00 PSAY "CONTINUAÇÃO PA - CCR: " + Posicione("SZ3",1,xFilial("SZ3")+cCodCCR,"Z3_DESENT")
				nLin 	:= nLin + 1
			Endif 
			
			cLin := "==========================    DADOS PAGAMENTO ANTECIPADO     ==========================="
			nLin 	:= nLin + 1
			@nLin,00 PSAY cLin
			nLin 	:= nLin + 1
			
			//Adiciono cabecalho
			cLin := PADR("PREFIXO"   ,12," ")
			cLin += PADR("TITULO"    ,12," ")
			cLin += PADR("PARCELA"   ,12," ")
			cLin += PADR("DT.EMISSAO",12," ")
			cLin += PADL("VALOR         ",20," ")
			cLin += PADL("SALDO PA      ",20," ")
			
			@nLin,00 PSAY cLin
			nLin 	:= nLin + 1
		EndIf
		
		While !TMP3->(EOF()) 
		
			If nLin > 57 // Salto de Página. Neste caso o formulario tem 55 linhas...
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 8
				@nLin,00 PSAY "CONTINUAÇÃO PA - CCR: " + Posicione("SZ3",1,xFilial("SZ3")+SZ6TMP->Z6_CODCCR,"Z3_DESENT")
				nLin 	:= nLin + 1  
				
				//Adiciono cabecalho
				cLin := PADR("PREFIXO"   ,12," ")
				cLin += PADR("TITULO"    ,12," ")
				cLin += PADR("PARCELA"   ,12," ")
				cLin += PADR("DT.EMISSAO",12," ")
				cLin += PADL("VALOR         ",20," ")
				cLin += PADL("SALDO PA      ",20," ")

				@nLin,00 PSAY cLin
				nLin 	:= nLin + 1
			Endif
			
			//Gravo dados PA
			cLin := PADR(TMP3->E2_PREFIXO 								,12," ")
			cLin += PADR(TMP3->E2_NUM	  	   							,12," ")
			cLin += PADR(TMP3->E2_PARCELA 	   							,12," ")
			cLin += PADR(DTOC(TMP3->E2_EMISSAO)							,12," ")
			cLin += PADR(TRANSFORM(TMP3->E2_VALOR, "@E 999,999,999.99")	,20," ")
			cLin += PADR(TRANSFORM(TMP3->E2_SALDO, "@E 999,999,999.99")	,20," ")
			
			@nLin,00 PSAY cLin
			nLin 	:= nLin + 1					
			
			TMP3->(DbSkip())
		EndDo
	
	EndIf
	
	
	If nLin > 60 // Salto de Página. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif
	
EndIf

//Imprime informacoes da Sincor e BR.

//Altera o cabecalho

If  AllTrim(MV_PAR02) $ "FEN" .And. MV_PAR03 == 1
	Cabec1 := ""
	
	Cabec1 += PADR("Quantidade"	   		,20 ," ")
	Cabec1 += PADR("Cód. Produto"		,25 ," ")
	Cabec1 += PADR("Descrição Produto"	,100," ")
	Cabec1 += PADR("Valor Hardware"		,20 ," ")
	Cabec1 += PADR("Valor Software"		,20 ," ")
	Cabec1 += PADR("Valor Faturado"		,20 ," ")
	Cabec1 += PADR("Valor Comissão"		,20 ," ")
	
	//Busca Dados
	cQuery := " SELECT   Z6_PRODUTO,  "
	cQuery += "          Z6_DESCRPR,  "
	cQuery += "          Z6_CODCCR,  "
	cQuery += "          Count(*) Quant,  "
	cQuery += "          Z6_CODAC,  "
	cQuery += "          SUM(BASE_HARDWARE) BASE_HARDWARE,  "
	cQuery += "          SUM(BASE_SOFTWARE) BASE_SOFTWARE,  "
	cQuery += "          SUM(BASE_COMISSAO) BASE_COMISSAO,  "
	cQuery += "          SUM(VALOR_COMISSAO) VALOR_COMISSAO  "
	cQuery += "          From (SELECT  Z6_PRODUTO,  "
	cQuery += "                        Z6_DESCRPR,  "
	cQuery += "                        Z6_CODCCR,  "
	cQuery += "                        Z6_PEDGAR,  "
	cQuery += "                        Z6_PEDSITE,  "
	cQuery += "                        Z6_CODAC,  "
	cQuery += "                        SUM(CASE WHEN Z6_CATPROD = '1' THEN Z6_BASECOM ELSE 0 END) BASE_HARDWARE,  "
	cQuery += "                        SUM(CASE WHEN Z6_CATPROD = '2' THEN Z6_BASECOM ELSE 0 END) BASE_SOFTWARE,  "
	cQuery += "                        SUM(Z6_BASECOM) BASE_COMISSAO,  "
	cQuery += "                        SUM(Z6_VALCOM) VALOR_COMISSAO  "
	cQuery += "                        FROM " + RetSQLName("SZ6") + " SZ6 "
	cQuery += " 					   JOIN PROTHEUS.SZ3010 SZ3 ON SZ3.Z3_FILIAL = ' ' AND Z6_CODENT = SZ3.Z3_CODENT AND SZ3.D_E_L_E_T_ = ' ' "
  	cQuery += " 					   LEFT JOIN PROTHEUS.SZF010 SZF ON ZF_FILIAL = ' ' AND ZF_COD = Z6_CODVOU AND ZF_COD > '0' AND SZF.D_E_L_E_T_ = ' ' AND Trim(ZF_PDESGAR) = Trim(Z6_PRODUTO) AND ZF_SALDO = 0 "
	cQuery += " 					   LEFT JOIN PROTHEUS.SZ5010 SZ5 ON SZ5.Z5_FILIAL = ' ' AND SZ5.Z5_PEDGAR > '0' AND SZ5.Z5_PEDGAR = Trim(regexp_replace(ZF_PEDIDO,'[[:punct:]]',' ')) AND SZ5.D_E_L_E_T_ = ' 'AND SZ5.Z5_PRODGAR > '0' "
	cQuery += " 					   LEFT JOIN PROTHEUS.SZH010 SZH ON ZH_FILIAL = ' ' AND ZH_TIPO = Z6_TIPVOU AND SZH.D_E_L_E_T_ = ' ' "
	cQuery += " 					   LEFT JOIN PROTHEUS.SZ3010 SZ32 ON SZ32.Z3_FILIAL = ' ' AND Z6_CODPOS = SZ32.Z3_CODGAR AND SZ32.Z3_CODGAR > '0' AND SZ32.Z3_TIPENT = '4' AND SZ32.D_E_L_E_T_ = ' ' "
	cQuery += "                        WHERE  SZ6.D_E_L_E_T_ = ' '   AND "
	cQuery += "                        Z6_FILIAL = ' '   AND "
	cQuery += "                        Z6_PERIODO = '"+MV_PAR01+"' AND "
	cQuery += "                        SubStr(Z6_CODAC,1,4) = '" +MV_PAR02+ "' AND "
	cQuery += "                        z6_tpentid = '4'  "
	cQuery += "                        GROUP BY  Z6_PRODUTO,  Z6_DESCRPR,  Z6_CODCCR,  Z6_PEDGAR,  Z6_PEDSITE,  Z6_CODAC)  "
	cQuery += " GROUP BY   Z6_PRODUTO,  Z6_DESCRPR,  Z6_CODCCR,  Z6_CODAC  "
	cQuery += " ORDER BY Z6_CODCCR,COUNT(*),Z6_PRODUTO "
	
	If Select("SZ6TM2") > 0
		SZ6TM2->( DbCloseArea() )
	EndIf
	
	PLSQuery( cQuery, "SZ6TM2" )
	
	If SZ6TM2->(Eof())
		MsgInfo('Não foi possível encontrar registros com os parâmetros informados.')
		SZ6TM2->( DbCloseArea() )
		Return(.F.)
	EndIf
	
	DbSelectArea("SZ6TM2")
	SZ6TM2->(DbGoTop())
	
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	nLin := 8
	
	cCodCCR := SZ6TM2->Z6_CODCCR
	@nLin,00 PSAY "CCR: " + Posicione("SZ3",1,xFilial("SZ3")+SZ6TM2->Z6_CODCCR,"Z3_DESENT")
	nLin 	:= nLin + 1
	@nLin,00 PSAY Replicate("_",220)
	nLin 	:= nLin + 1
	
	While !EOF("SZ6TM2")
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica o cancelamento pelo usuario...                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Impressao do cabecalho do relatorio. . .                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		If nLin > 60 // Salto de Página. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		Endif
		
		If  cCodCCR <> SZ6TM2->Z6_CODCCR
			
			//Imprime Totais
			@nLin,00 PSAY Replicate("_",220)
			nLin 	:= nLin + 1
			
			//Imprime Totais
			cImpLin := PADR(Transform(nQuant 			,"@E 999,999,999")		,20 ," ")
			cImpLin += PADR("SUBTOTAL --> ",125 ," ")
			cImpLin += PADR(Transform(nValHar 			,"@E 999,999,999.99")	,20 ," ")
			cImpLin += PADR(Transform(nValSof 			,"@E 999,999,999.99")	,20 ," ")
			cImpLin += PADR(Transform(nValFat			,"@E 999,999,999.99")	,20 ," ")
			cImpLin += PADR(Transform(nTotal 			,"@E 999,999,999.99")	,20 ," ")
			
			@nLin,00 PSAY cImpLin
			nLin 	:= nLin + 1
			
			If !(AllTrim(MV_PAR02) $ "FEN")
				
				cQuery4 := " SELECT  Z6_CODCCR, Z6_NOMVEND, SUM(Z6_VLRPROD) Z6_VALFAT, SUM(Z6_VALCOM) Z6_VALCOM FROM " + RetSQLName("SZ6")
				cQuery4 += " WHERE Z6_FILIAL = ' ' AND Z6_TPENTID = '7' AND Z6_PERIODO = '"+MV_PAR01+"' AND Z6_CODENT IN "+FormatIn(AllTrim(SZ3->Z3_CODPAR) + Iif(!Empty(SZ3->Z3_CODPAR2),"," + AllTrim(SZ3->Z3_CODPAR2),""),",")+" AND D_E_L_E_T_ = ' ' "
				cQuery4 += " GROUP BY Z6_CODCCR, Z6_NOMVEND "
				
				If Select("TMP4") > 0
					TMP4->( DbCloseArea() )
				EndIf
				
				PLSQuery( cQuery4, "TMP4" )
				
				DbSelectArea("TMP4")
				TMP4->(DbGoTop())
				
				If !TMP4->(Eof())
					
					//Imprime Totais
					nLin 	:= nLin + 1
					
					If nLin > 60 // Salto de Página. Neste caso o formulario tem 55 linhas...
						Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
						nLin := 8
					Endif
					cImpLin := "| VENDEDOR " + Space(89) 		+ "|"
					cImpLin += PADR("TOTAL FAT. "	 ,19 ," ")  + "|"
					cImpLin += PADR("TOTAL COM. "	 ,19 ," ")  + "|"
					@nLin,00 PSAY cImpLin
					//nLin 	:= nLin + 1
					@nLin,00 PSAY Replicate("_",220)
					nLin 	:= nLin + 1
					
				EndIf
				
				nVlFatu := 0
				nVlComi := 0
				
				While !EOF("TMP4")
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Verifica o cancelamento pelo usuario...                             ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					
					If lAbortPrint
						@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
						Exit
					Endif
					
					nLin 	:= nLin + 1
					
					If nLin > 60 // Salto de Página. Neste caso o formulario tem 55 linhas...
						Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
						nLin := 8
						
						cImpLin := "| VENDEDOR " + Space(89) 		+ "|"
						cImpLin += PADR("TOTAL FAT. "	 ,19 ," ")  + "|"
						cImpLin += PADR("TOTAL COM. "	 ,19 ," ")  + "|"
						@nLin,00 PSAY cImpLin
						//nLin 	:= nLin + 1
						@nLin,00 PSAY Replicate("_",220)
						nLin 	:= nLin + 1
					Endif
					
					cImpLin := PADR(TMP4->Z6_NOMVEND											,100 ," ")
					cImpLin += PADR(Transform(TMP4->Z6_VALFAT 			,"@E 999,999,999.99")	,20 ," ")
					cImpLin += PADR(Transform(TMP4->Z6_VALCOM 			,"@E 999,999,999.99")	,20 ," ")
					
					nVlFatu += TMP4->Z6_VALFAT
					nVlComi += TMP4->Z6_VALCOM
					
					@nLin,00 PSAY cImpLin
					
					TMP4->(DbSkip())
				EndDo
			EndIf
			
			//Imprime SubTotal
			If nVlFatu > 0
				nLin 	:= nLin + 1
				@nLin,00 PSAY Replicate("_",220)
				cImpLin := PADR("SUBTOTAL --> "	 ,99 ," ")  + "|"
				cImpLin += PADR(Transform( nVlFatu ,"@E 999,999,999.99"),19 ," ")  + "|"
				cImpLin += PADR(Transform( nVlComi ,"@E 999,999,999.99"),19 ," ")  + "|"
				nLin 	:= nLin + 1
				@nLin,00 PSAY cImpLin
			EndIf
			
			//Imprime Totais
			nLin 	:= nLin + 2
			@nLin,00 PSAY PADL("Total             --> " + Transform(nTotal,"@E 999,999,999.99")	,220 ," ")
			
			If nVlFatu > 0
				nLin 	:= nLin + 1
				If nLin > 60 // Salto de Página. Neste caso o formulario tem 55 linhas...
					Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
					nLin := 8
				Endif
				
				@nLin,00 PSAY PADL("Tot. Com. Campanha -> " + Transform(nVlComi,"@E 999,999,999.99")	,220 ," ")
				nLin 	:= nLin + 1
			EndIf
			
			cQuery2 := " SELECT SUM(Z6_VALCOM) Z6_VALCOM FROM " + RetSQLName("SZ6") + " SZ6 WHERE SZ6.D_E_L_E_T_ = ' ' AND Z6_FILIAL = ' ' AND Z6_PERIODO = '"+MV_PAR01+"' AND Z6_CODENT = '"+AllTrim(cCodCCR)+"' AND z6_tpentid = 'B' "
	
			If Select("TMP2") > 0
				TMP2->(DbCloseArea())
			EndIf
			PLSQuery( cQuery2, "TMP2" )
			
			@nLin,00 PSAY PADL("Visita Externa    --> " + Transform(TMP2->Z6_VALCOM,"@E 999,999,999.99")	,220 ," ")
			nLin 	:= nLin + 1
			
			nTotal += TMP2->Z6_VALCOM
			
			nLin 	:= nLin + 1
			If nLin > 60 // Salto de Página. Neste caso o formulario tem 55 linhas...
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 8
			Endif
			
			@nLin,00 PSAY PADL("Total Geral       --> " + Transform(nTotal+nVlComi,"@E 999,999,999.99")	,220 ," ")
			
			//Priscila Kuhn - 09/11/2015
			//Controle de PA dos parceiros
			SZ3->(DbSetOrder(1))
			SZ3->(DbSeek(xFilial("SZ3")+cCodCCR))
			
			//Verifico se tem fornecedor vinculado para fazer busca.
			If !Empty(SZ3->Z3_CODFOR)
				
				cQuery := " SELECT E2_PREFIXO, E2_NUM, E2_PARCELA, E2_VALOR, E2_SALDO, E2_EMISSAO "
				cQuery += " FROM " + RetSqlName("SE2") + " SE2"
				cQuery += " WHERE "
				cQuery += " E2_FILIAL = ' ' AND "
				cQuery += " E2_TIPO = 'PA' AND "
				cQuery += " E2_SALDO > 0 AND "
				cQuery += " E2_FORNECE = '" + SZ3->Z3_CODFOR + "' AND "
				cQuery += " E2_LOJA = '01' AND "
				cQuery += " SE2.D_E_L_E_T_ = ' ' "
				
				If Select("TMP3") > 0
					TMP3->(DbCloseArea())
				EndIf
				
				PLSQuery( cQuery, "TMP3" )
				
				TMP3->(DbGoTop())
				
				//Pulo 2 linhas linha antes de gerar informacoes dos PA's
				If !TMP3->(EOF())
				
					If nLin > 57 // Salto de Página. Neste caso o formulario tem 55 linhas...
						Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
						nLin := 8
						@nLin,00 PSAY "CONTINUAÇÃO PA - CCR: " + Posicione("SZ3",1,xFilial("SZ3")+cCodCCR,"Z3_DESENT")
						nLin 	:= nLin + 1
					Endif 
					
					cLin := "==========================    DADOS PAGAMENTO ANTECIPADO     ==========================="
					@nLin,00 PSAY cLin
					nLin 	:= nLin + 1
					
					//Adiciono cabecalho
					cLin := PADR("PREFIXO"   ,12," ")
					cLin += PADR("TITULO"    ,12," ")
					cLin += PADR("PARCELA"   ,12," ")
					cLin += PADR("DT.EMISSAO",12," ")
					cLin += PADL("VALOR         ",20," ")
					cLin += PADL("SALDO PA      ",20," ")
					
					@nLin,00 PSAY cLin
					nLin 	:= nLin + 1
				EndIf
				
				//Efetuo gravação de dados do relatório em arquivo.
				While !TMP3->(EOF()) 
				
					If nLin > 57 // Salto de Página. Neste caso o formulario tem 55 linhas...
						Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
						nLin := 8
						@nLin,00 PSAY "CONTINUAÇÃO PA - CCR: " + Posicione("SZ3",1,xFilial("SZ3")+SZ6TMP->Z6_CODCCR,"Z3_DESENT")
						nLin 	:= nLin + 1  
						
						//Adiciono cabecalho
						cLin := PADR("PREFIXO"   ,12," ")
						cLin += PADR("TITULO"    ,12," ")
						cLin += PADR("PARCELA"   ,12," ")
						cLin += PADR("DT.EMISSAO",12," ")
						cLin += PADL("VALOR         ",20," ")
						cLin += PADL("SALDO PA      ",20," ")
	
						@nLin,00 PSAY cLin
						nLin 	:= nLin + 1
					Endif
					
					//Gravo dados PA
					cLin := PADR(TMP3->E2_PREFIXO 								,12," ")
					cLin += PADR(TMP3->E2_NUM	  	   							,12," ")
					cLin += PADR(TMP3->E2_PARCELA 	   							,12," ")
					cLin += PADR(DTOC(TMP3->E2_EMISSAO)							,12," ")
					cLin += PADR(TRANSFORM(TMP3->E2_VALOR, "@E 999,999,999.99")	,20," ")
					cLin += PADR(TRANSFORM(TMP3->E2_SALDO, "@E 999,999,999.99")	,20," ")
					
					@nLin,00 PSAY cLin
					nLin 	:= nLin + 1					
					
					TMP3->(DbSkip())
				EndDo
			
			EndIf
			
			
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
			cCodCCR := SZ6TM2->Z6_CODCCR
			
			@nLin,00 PSAY "CCR: " + Posicione("SZ3",1,xFilial("SZ3")+SZ6TM2->Z6_CODCCR,"Z3_DESENT")
			nLin 	:= nLin + 1
			@nLin,00 PSAY Replicate("_",220)
			nLin 	:= nLin + 1
			
			//Zera valores
			nQuant  	:= 0
			nValHar  	:= 0
			nValSof  	:= 0
			nValFat  	:= 0
			nTotal		:= 0			
			
		EndIf
		
		cImpLin := PADR(Transform(SZ6TM2->QUANT 			,"@E 999,999,999")		,20 ," ")
		cImpLin += PADR(SZ6TM2->Z6_PRODUTO											,25 ," ")
		cImpLin += PADR(SZ6TM2->Z6_DESCRPR											,100," ")
		cImpLin += PADR(Transform(SZ6TM2->BASE_HARDWARE 	,"@E 999,999,999.99")	,20 ," ")
		cImpLin += PADR(Transform(SZ6TM2->BASE_SOFTWARE 	,"@E 999,999,999.99")	,20 ," ")
		cImpLin += PADR(Transform(SZ6TM2->BASE_COMISSAO 	,"@E 999,999,999.99")	,20 ," ")
		cImpLin += PADR(Transform(SZ6TM2->VALOR_COMISSAO 	,"@E 999,999,999.99")	,20 ," ")
		
		@nLin,00 PSAY cImpLin
		
		//Guarda valores para totalizador
		cImpLin 	:= ""
		nQuant  	+= SZ6TM2->QUANT
		nValHar  	+= SZ6TM2->BASE_HARDWARE
		nValSof  	+= SZ6TM2->BASE_SOFTWARE
		nValFat  	+= SZ6TM2->BASE_COMISSAO
		nTotal		+= SZ6TM2->VALOR_COMISSAO
		
		nLin 	:= nLin + 1 // Avanca a linha de impressao

		
		
		DbSelectArea("SZ6TM2")
		
		SZ6TM2->(dbSkip()) // Avanca o ponteiro do registro no arquivo
	EndDo
	
	//Fecha Arquivo usado
	If Select("SZ6TM2") > 0
		SZ6TM2->( DbCloseArea() )
	EndIf
	
	//Imprime Totais
	cImpLin := PADR(Transform(nQuant 			,"@E 999,999,999")		,20 ," ")
	cImpLin += PADR("SUBTOTAL --> ",125 ," ")
	cImpLin += PADR(Transform(nValHar 			,"@E 999,999,999.99")	,20 ," ")
	cImpLin += PADR(Transform(nValSof 			,"@E 999,999,999.99")	,20 ," ")
	cImpLin += PADR(Transform(nValFat			,"@E 999,999,999.99")	,20 ," ")
	cImpLin += PADR(Transform(nTotal 			,"@E 999,999,999.99")	,20 ," ")
	
	@nLin,00 PSAY Replicate("_",220)
	nLin 	:= nLin + 1
	
	@nLin,00 PSAY cImpLin
	
	nLin 	:= nLin + 2
	
	If nLin > 60 // Salto de Página. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif
	
	@nLin,00 PSAY PADL("Total             --> " + Transform(nTotal,"@E 999,999,999.99")	,220 ," ")
	
	nLin 	:= nLin + 1
	If nLin > 60 // Salto de Página. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif
	
	If nVlFatu > 0
		nLin 	:= nLin + 1
		If nLin > 60 // Salto de Página. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		Endif
		
		@nLin,00 PSAY PADL("Tot. Fat. Campanha -> " + Transform(nVlComi,"@E 999,999,999.99")	,220 ," ")
		nLin 	:= nLin + 1
	EndIf
	
	@nLin,00 PSAY PADL("Total Geral       --> " + Transform(nTotal+nVlComi,"@E 999,999,999.99")	,220 ," ")
	
	//Priscila Kuhn - 09/11/2015
	//Controle de PA dos parceiros
	SZ3->(DbSetOrder(1))
	SZ3->(DbSeek(xFilial("SZ3")+cCodCCR))
	
	//Verifico se tem fornecedor vinculado para fazer busca.
	If !Empty(SZ3->Z3_CODFOR)
		
		cQuery := " SELECT E2_PREFIXO, E2_NUM, E2_PARCELA, E2_VALOR, E2_SALDO, E2_EMISSAO "
		cQuery += " FROM " + RetSqlName("SE2") + " SE2"
		cQuery += " WHERE "
		cQuery += " E2_FILIAL = ' ' AND "
		cQuery += " E2_TIPO = 'PA' AND "
		cQuery += " E2_SALDO > 0 AND "
		cQuery += " E2_FORNECE = '" + SZ3->Z3_CODFOR + "' AND "
		cQuery += " E2_LOJA = '01' AND "
		cQuery += " SE2.D_E_L_E_T_ = ' ' "
		
		If Select("TMP3") > 0
			TMP3->(DbCloseArea())
		EndIf
		
		PLSQuery( cQuery, "TMP3" )
		
		TMP3->(DbGoTop())
		
		//Pulo 2 linhas linha antes de gerar informacoes dos PA's
		If !TMP3->(EOF())
		
			If nLin > 57 // Salto de Página. Neste caso o formulario tem 55 linhas...
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 8
				@nLin,00 PSAY "CONTINUAÇÃO PA - CCR: " + Posicione("SZ3",1,xFilial("SZ3")+cCodCCR,"Z3_DESENT")
				nLin 	:= nLin + 1
			Endif 
			
			cLin := "==========================    DADOS PAGAMENTO ANTECIPADO     ==========================="
			@nLin,00 PSAY cLin
			nLin 	:= nLin + 1
			
			//Adiciono cabecalho
			cLin := PADR("PREFIXO"   ,12," ")
			cLin += PADR("TITULO"    ,12," ")
			cLin += PADR("PARCELA"   ,12," ")
			cLin += PADR("DT.EMISSAO",12," ")
			cLin += PADL("VALOR         ",20," ")
			cLin += PADL("SALDO PA      ",20," ")
			
			@nLin,00 PSAY cLin
			nLin 	:= nLin + 1
		EndIf
		
		//Efetuo gravação de dados do relatório em arquivo.
		While !TMP3->(EOF()) 
		
			If nLin > 57 // Salto de Página. Neste caso o formulario tem 55 linhas...
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 8
				@nLin,00 PSAY "CONTINUAÇÃO PA - CCR: " + Posicione("SZ3",1,xFilial("SZ3")+SZ6TMP->Z6_CODCCR,"Z3_DESENT")
				nLin 	:= nLin + 1  
				
				//Adiciono cabecalho
				cLin := PADR("PREFIXO"   ,12," ")
				cLin += PADR("TITULO"    ,12," ")
				cLin += PADR("PARCELA"   ,12," ")
				cLin += PADR("DT.EMISSAO",12," ")
				cLin += PADL("VALOR         ",20," ")
				cLin += PADL("SALDO PA      ",20," ")

				@nLin,00 PSAY cLin
				nLin 	:= nLin + 1
			Endif
			
			//Gravo dados PA
			cLin := PADR(TMP3->E2_PREFIXO 								,12," ")
			cLin += PADR(TMP3->E2_NUM	  	   							,12," ")
			cLin += PADR(TMP3->E2_PARCELA 	   							,12," ")
			cLin += PADR(DTOC(TMP3->E2_EMISSAO)							,12," ")
			cLin += PADR(TRANSFORM(TMP3->E2_VALOR, "@E 999,999,999.99")	,20," ")
			cLin += PADR(TRANSFORM(TMP3->E2_SALDO, "@E 999,999,999.99")	,20," ")
			
			@nLin,00 PSAY cLin
			nLin 	:= nLin + 1					
			
			TMP3->(DbSkip())
		EndDo
	
	EndIf
	
	
EndIf

//Tratamento para Impressao de AC.
If  MV_PAR03 == 2
	Cabec1 := ""
	
	Cabec1 += PADR("Quantidade"	   		,20 ," ")
	Cabec1 += PADR("Cód. Produto"		,25 ," ")
	Cabec1 += PADR("Descrição Produto"	,100," ")
	Cabec1 += PADR("Valor Hardware"		,20 ," ")
	Cabec1 += PADR("Valor Software"		,20 ," ")
	Cabec1 += PADR("Valor Faturado"		,20 ," ")
	Cabec1 += PADR("Valor Comissão"		,20 ," ")
	
	//Busca Dados
	cQuery := " SELECT   Z6_PRODUTO,  "
	cQuery += "          Z6_DESCRPR,  "
	cQuery += "          Z6_CODCCR,  "
	cQuery += "          Count(*) Quant,  "
	cQuery += "          Z6_CODAC,  "
	cQuery += "          SUM(BASE_HARDWARE) BASE_HARDWARE,  "
	cQuery += "          SUM(BASE_SOFTWARE) BASE_SOFTWARE,  "
	cQuery += "          SUM(BASE_COMISSAO) BASE_COMISSAO,  "
	cQuery += "          SUM(VALOR_COMISSAO) VALOR_COMISSAO  "
	cQuery += "          From (SELECT  Z6_PRODUTO,  "
	cQuery += "                        Z6_DESCRPR,  "
	cQuery += "                        Z6_CODENT Z6_CODCCR,  "
	cQuery += "                        Z6_PEDGAR,  "
	cQuery += "                        Z6_PEDSITE,  "
	cQuery += "                        Z6_CODAC,  "
	cQuery += "                        SUM(CASE WHEN Z6_CATPROD = '1' THEN Z6_BASECOM ELSE 0 END) BASE_HARDWARE,  "
	cQuery += "                        SUM(CASE WHEN Z6_CATPROD = '2' THEN Z6_BASECOM ELSE 0 END) BASE_SOFTWARE,  "
	cQuery += "                        SUM(Z6_BASECOM) BASE_COMISSAO,  "
	cQuery += "                        SUM(Z6_VALCOM) VALOR_COMISSAO  "
	cQuery += "                        FROM " + RetSQLName("SZ6") + " SZ6 "
	cQuery += "                        WHERE  SZ6.D_E_L_E_T_ = ' '   AND "
	cQuery += "                        Z6_FILIAL = ' '   AND "
	cQuery += "                        Z6_PERIODO = '"+MV_PAR01+"' AND "
	If !Empty(MV_PAR02)
		cQuery += "                        SubStr(Z6_CODAC,1,4) = '" +MV_PAR02+ "' AND "
	EndIf
	cQuery += "                        z6_tpentid IN ('2','5')  "
	cQuery += "                        GROUP BY  Z6_PRODUTO,  Z6_DESCRPR,  Z6_CODENT,  Z6_PEDGAR,  Z6_PEDSITE,  Z6_CODAC)  "
	cQuery += " GROUP BY   Z6_PRODUTO,  Z6_DESCRPR,  Z6_CODCCR,  Z6_CODAC  "
	cQuery += " ORDER BY Z6_CODCCR,COUNT(*),Z6_PRODUTO "
	
	If Select("SZ6TM2") > 0
		SZ6TM2->( DbCloseArea() )
	EndIf
	
	PLSQuery( cQuery, "SZ6TM2" )
	
	If SZ6TM2->(Eof())
		MsgInfo('Não foi possível encontrar registros com os parâmetros informados.')
		SZ6TM2->( DbCloseArea() )
		Return(.F.)
	EndIf
	
	DbSelectArea("SZ6TM2")
	SZ6TM2->(DbGoTop())
	
	cCodCCR := SZ6TM2->Z6_CODCCR 
	
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	nLin := 8
	@nLin,00 PSAY "CCR: " + Posicione("SZ3",1,xFilial("SZ3")+SZ6TM2->Z6_CODCCR,"Z3_DESENT")
	nLin 	:= nLin + 1
	@nLin,00 PSAY Replicate("_",220)
	nLin 	:= nLin + 1
	
	While !EOF("SZ6TM2")
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica o cancelamento pelo usuario...                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Impressao do cabecalho do relatorio. . .                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		If nLin > 60 // Salto de Página. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		Endif
		
		If  cCodCCR == SZ6TM2->Z6_CODCCR
			cImpLin := PADR(Transform(SZ6TM2->QUANT 			,"@E 999,999,999")		,20 ," ")
			cImpLin += PADR(SZ6TM2->Z6_PRODUTO											,25 ," ")
			cImpLin += PADR(SZ6TM2->Z6_DESCRPR											,100," ")
			cImpLin += PADR(Transform(SZ6TM2->BASE_HARDWARE 	,"@E 999,999,999.99")	,20 ," ")
			cImpLin += PADR(Transform(SZ6TM2->BASE_SOFTWARE 	,"@E 999,999,999.99")	,20 ," ")
			cImpLin += PADR(Transform(SZ6TM2->BASE_COMISSAO 	,"@E 999,999,999.99")	,20 ," ")
			cImpLin += PADR(Transform(SZ6TM2->VALOR_COMISSAO 	,"@E 999,999,999.99")	,20 ," ")
			
			@nLin,00 PSAY cImpLin
			
			//Guarda valores para totalizador
			cImpLin 	:= ""
			nQuant  	+= SZ6TM2->QUANT
			nValHar  	+= SZ6TM2->BASE_HARDWARE
			nValSof  	+= SZ6TM2->BASE_SOFTWARE
			nValFat  	+= SZ6TM2->BASE_COMISSAO
			nTotal		+= SZ6TM2->VALOR_COMISSAO
			
			nLin 	:= nLin + 1 // Avanca a linha de impressao
		EndIf
		
		If  cCodCCR <> SZ6TM2->Z6_CODCCR
			
			//Imprime Totais
			@nLin,00 PSAY Replicate("_",220)
			nLin 	:= nLin + 1
			
			//Imprime Totais
			cImpLin := PADR(Transform(nQuant 			,"@E 999,999,999")		,20 ," ")
			cImpLin += PADR("SUBTOTAL --> ",125 ," ")
			cImpLin += PADR(Transform(nValHar 			,"@E 999,999,999.99")	,20 ," ")
			cImpLin += PADR(Transform(nValSof 			,"@E 999,999,999.99")	,20 ," ")
			cImpLin += PADR(Transform(nValFat			,"@E 999,999,999.99")	,20 ," ")
			cImpLin += PADR(Transform(nTotal 			,"@E 999,999,999.99")	,20 ," ")
			
			@nLin,00 PSAY cImpLin
			
			cQuery4 := " SELECT  Z6_CODCCR, Z6_DESENT, SUM(Z6_VLRPROD) Z6_VALFAT, SUM(Z6_VALCOM) Z6_VALCOM FROM " + RetSQLName("SZ6")
			cQuery4 += " WHERE Z6_FILIAL = ' ' AND Z6_TPENTID = '7' AND Z6_PERIODO = '"+MV_PAR01+"' AND Z6_CODENT IN "+FormatIn(AllTrim(SZ3->Z3_CODPAR) + Iif(!Empty(SZ3->Z3_CODPAR2),"," + AllTrim(SZ3->Z3_CODPAR2),""),",")+" AND D_E_L_E_T_ = ' ' "
			cQuery4 += " GROUP BY Z6_CODCCR, Z6_DESENT "
			
			If Select("TMP4") > 0
				TMP4->( DbCloseArea() )
			EndIf
			
			PLSQuery( cQuery4, "TMP4" )
			
			DbSelectArea("TMP4")
			TMP4->(DbGoTop())
			
			If !TMP4->(Eof())
				
				//Imprime Totais
				nLin 	:= nLin + 1
				
				If nLin > 60 // Salto de Página. Neste caso o formulario tem 55 linhas...
					Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
					nLin := 8
				Endif
				cImpLin := "| PARCEIRO " + Space(89) 		+ "|"
				cImpLin += PADR("TOTAL FAT. "	 ,19 ," ")  + "|"
				cImpLin += PADR("TOTAL COM. "	 ,19 ," ")  + "|"
				@nLin,00 PSAY cImpLin
				//nLin 	:= nLin + 1
				@nLin,00 PSAY Replicate("_",220)
				nLin 	:= nLin + 1
				
			EndIf
			
			nVlFatu := 0
			nVlComi := 0
			
			While !EOF("TMP4")
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Verifica o cancelamento pelo usuario...                             ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				
				If lAbortPrint
					@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
					Exit
				Endif
				
				nLin 	:= nLin + 1
				
				If nLin > 60 // Salto de Página. Neste caso o formulario tem 55 linhas...
					Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
					nLin := 8
					
					cImpLin := "| PARCEIRO " + Space(89) 		+ "|"
					cImpLin += PADR("TOTAL FAT. "	 ,19 ," ")  + "|"
					cImpLin += PADR("TOTAL COM. "	 ,19 ," ")  + "|"
					@nLin,00 PSAY cImpLin
					//nLin 	:= nLin + 1
					@nLin,00 PSAY Replicate("_",220)
					nLin 	:= nLin + 1
				Endif
				
				cImpLin := PADR(TMP4->Z6_DESENT											,100 ," ")
				cImpLin += PADR(Transform(TMP4->Z6_VALFAT 			,"@E 999,999,999.99")	,20 ," ")
				cImpLin += PADR(Transform(TMP4->Z6_VALCOM 			,"@E 999,999,999.99")	,20 ," ")
				
				nVlFatu += TMP4->Z6_VALFAT
				nVlComi += TMP4->Z6_VALCOM
				
				@nLin,00 PSAY cImpLin
				
				TMP4->(DbSkip())
			EndDo
			
			//Imprime SubTotal
			If nVlFatu > 0
				nLin 	:= nLin + 1
				@nLin,00 PSAY Replicate("_",220)
				cImpLin := PADR("SUBTOTAL --> "	 ,99 ," ")  + "|"
				cImpLin += PADR(Transform( nVlFatu ,"@E 999,999,999.99"),19 ," ")  + "|"
				cImpLin += PADR(Transform( nVlComi ,"@E 999,999,999.99"),19 ," ")  + "|"
				nLin 	:= nLin + 1
				@nLin,00 PSAY cImpLin
			EndIf
			
			//Imprime Totais
			nLin 	:= nLin + 2
			@nLin,00 PSAY PADL("Total             --> " + Transform(nTotal,"@E 999,999,999.99")	,220 ," ")
			
			If nVlFatu > 0
				nLin 	:= nLin + 1
				If nLin > 60 // Salto de Página. Neste caso o formulario tem 55 linhas...
					Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
					nLin := 8
				Endif
				
				@nLin,00 PSAY PADL("Tot. Com. Campanha -> " + Transform(nVlComi,"@E 999,999,999.99")	,220 ," ")
			EndIf
			
			nLin 	:= nLin + 1
			If nLin > 60 // Salto de Página. Neste caso o formulario tem 55 linhas...
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 8
			Endif
			
			@nLin,00 PSAY PADL("Total Geral       --> " + Transform(nTotal+nVlComi,"@E 999,999,999.99")	,220 ," ")
			
			//Priscila Kuhn - 09/11/2015
			//Controle de PA dos parceiros
			SZ3->(DbSetOrder(1))
			SZ3->(DbSeek(xFilial("SZ3")+cCodCCR))
			
			//Verifico se tem fornecedor vinculado para fazer busca.
			If !Empty(SZ3->Z3_CODFOR)
				
				cQuery := " SELECT E2_PREFIXO, E2_NUM, E2_PARCELA, E2_VALOR, E2_SALDO, E2_EMISSAO "
				cQuery += " FROM " + RetSqlName("SE2") + " SE2"
				cQuery += " WHERE "
				cQuery += " E2_FILIAL = ' ' AND "
				cQuery += " E2_TIPO = 'PA' AND "
				cQuery += " E2_SALDO > 0 AND "
				cQuery += " E2_FORNECE = '" + SZ3->Z3_CODFOR + "' AND "
				cQuery += " E2_LOJA = '01' AND "
				cQuery += " SE2.D_E_L_E_T_ = ' ' "
				
				If Select("TMP3") > 0
					TMP3->(DbCloseArea())
				EndIf
				
				PLSQuery( cQuery, "TMP3" )
				
				TMP3->(DbGoTop())
				
				//Pulo 2 linhas linha antes de gerar informacoes dos PA's
				If !TMP3->(EOF())
				
					If nLin > 57 // Salto de Página. Neste caso o formulario tem 55 linhas...
						Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
						nLin := 8
						@nLin,00 PSAY "CONTINUAÇÃO PA - CCR: " + Posicione("SZ3",1,xFilial("SZ3")+cCodCCR,"Z3_DESENT")
						nLin 	:= nLin + 1
					Endif 
					
					cLin := "==========================    DADOS PAGAMENTO ANTECIPADO     ==========================="
					@nLin,00 PSAY cLin
					nLin 	:= nLin + 1
					
					//Adiciono cabecalho
					cLin := PADR("PREFIXO"   ,12," ")
					cLin += PADR("TITULO"    ,12," ")
					cLin += PADR("PARCELA"   ,12," ")
					cLin += PADR("DT.EMISSAO",12," ")
					cLin += PADL("VALOR         ",20," ")
					cLin += PADL("SALDO PA      ",20," ")
					
					@nLin,00 PSAY cLin
					nLin 	:= nLin + 1
				EndIf
				
				//Efetuo gravação de dados do relatório em arquivo.
				While !TMP3->(EOF()) 
				
					If nLin > 57 // Salto de Página. Neste caso o formulario tem 55 linhas...
						Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
						nLin := 8
						@nLin,00 PSAY "CONTINUAÇÃO PA - CCR: " + Posicione("SZ3",1,xFilial("SZ3")+SZ6TMP->Z6_CODCCR,"Z3_DESENT")
						nLin 	:= nLin + 1  
						
						//Adiciono cabecalho
						cLin := PADR("PREFIXO"   ,12," ")
						cLin += PADR("TITULO"    ,12," ")
						cLin += PADR("PARCELA"   ,12," ")
						cLin += PADR("DT.EMISSAO",12," ")
						cLin += PADL("VALOR         ",20," ")
						cLin += PADL("SALDO PA      ",20," ")
	
						@nLin,00 PSAY cLin
						nLin 	:= nLin + 1
					Endif
					
					//Gravo dados PA
					cLin := PADR(TMP3->E2_PREFIXO 								,12," ")
					cLin += PADR(TMP3->E2_NUM	  	   							,12," ")
					cLin += PADR(TMP3->E2_PARCELA 	   							,12," ")
					cLin += PADR(DTOC(TMP3->E2_EMISSAO)							,12," ")
					cLin += PADR(TRANSFORM(TMP3->E2_VALOR, "@E 999,999,999.99")	,20," ")
					cLin += PADR(TRANSFORM(TMP3->E2_SALDO, "@E 999,999,999.99")	,20," ")
					
					@nLin,00 PSAY cLin
					nLin 	:= nLin + 1					
					
					TMP3->(DbSkip())
				EndDo
			
			EndIf
						
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
			
			@nLin,00 PSAY "CCR: " + Posicione("SZ3",1,xFilial("SZ3")+SZ6TM2->Z6_CODCCR,"Z3_DESENT")
			nLin 	:= nLin + 1
			@nLin,00 PSAY Replicate("_",220)
			nLin 	:= nLin + 1
			
			//Zera valores
			nQuant  	:= 0
			nValHar  	:= 0
			nValSof  	:= 0
			nValFat  	:= 0
			nTotal		:= 0
			
			
		EndIf
		DbSelectArea("SZ6TM2")
		
		If cCodCCR == SZ6TM2->Z6_CODCCR
			SZ6TM2->(dbSkip()) // Avanca o ponteiro do registro no arquivo
		Else
			cCodCCR := SZ6TM2->Z6_CODCCR
		EndIf
	EndDo
	
	//Fecha Arquivo usado
	If Select("SZ6TM2") > 0
		SZ6TM2->( DbCloseArea() )
	EndIf
	
	//Imprime Totais
	cImpLin := PADR(Transform(nQuant 			,"@E 999,999,999")		,20 ," ")
	cImpLin += PADR("SUBTOTAL --> ",125 ," ")
	cImpLin += PADR(Transform(nValHar 			,"@E 999,999,999.99")	,20 ," ")
	cImpLin += PADR(Transform(nValSof 			,"@E 999,999,999.99")	,20 ," ")
	cImpLin += PADR(Transform(nValFat			,"@E 999,999,999.99")	,20 ," ")
	cImpLin += PADR(Transform(nTotal 			,"@E 999,999,999.99")	,20 ," ")
	
	@nLin,00 PSAY Replicate("_",220)
	nLin 	:= nLin + 1
	
	@nLin,00 PSAY cImpLin
	
	nLin 	:= nLin + 2
	
	If nLin > 60 // Salto de Página. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif
	
	@nLin,00 PSAY PADL("Total             --> " + Transform(nTotal,"@E 999,999,999.99")	,220 ," ")
	
	nLin 	:= nLin + 1
	If nLin > 60 // Salto de Página. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif
	
	If nVlFatu > 0
		If nLin > 60 // Salto de Página. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		Endif
		
		@nLin,00 PSAY PADL("Tot. Fat. Campanha -> " + Transform(nVlFatu,"@E 999,999,999.99")	,220 ," ")
		nLin 	:= nLin + 1
	EndIf
	
	@nLin,00 PSAY PADL("Total Geral       --> " + Transform(nTotal+nVlFatu,"@E 999,999,999.99")	,220 ," ")
	
	//Priscila Kuhn - 09/11/2015
	//Controle de PA dos parceiros
	SZ3->(DbSetOrder(1))
	SZ3->(DbSeek(xFilial("SZ3")+cCodCCR))
	
	//Verifico se tem fornecedor vinculado para fazer busca.
	If !Empty(SZ3->Z3_CODFOR)
		
		cQuery := " SELECT E2_PREFIXO, E2_NUM, E2_PARCELA, E2_VALOR, E2_SALDO, E2_EMISSAO "
		cQuery += " FROM " + RetSqlName("SE2") + " SE2"
		cQuery += " WHERE "
		cQuery += " E2_FILIAL = ' ' AND "
		cQuery += " E2_TIPO = 'PA' AND "
		cQuery += " E2_SALDO > 0 AND "
		cQuery += " E2_FORNECE = '" + SZ3->Z3_CODFOR + "' AND "
		cQuery += " E2_LOJA = '01' AND "
		cQuery += " SE2.D_E_L_E_T_ = ' ' "
		
		If Select("TMP3") > 0
			TMP3->(DbCloseArea())
		EndIf
		
		PLSQuery( cQuery, "TMP3" )
		
		TMP3->(DbGoTop())
		
		//Pulo 2 linhas linha antes de gerar informacoes dos PA's
		If !TMP3->(EOF())
		
			If nLin > 57 // Salto de Página. Neste caso o formulario tem 55 linhas...
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 8
				@nLin,00 PSAY "CONTINUAÇÃO PA - CCR: " + Posicione("SZ3",1,xFilial("SZ3")+cCodCCR,"Z3_DESENT")
				nLin 	:= nLin + 1
			Endif 
			
			cLin := "==========================    DADOS PAGAMENTO ANTECIPADO     ==========================="
			@nLin,00 PSAY cLin
			nLin 	:= nLin + 1
			
			//Adiciono cabecalho
			cLin := PADR("PREFIXO"   ,12," ")
			cLin += PADR("TITULO"    ,12," ")
			cLin += PADR("PARCELA"   ,12," ")
			cLin += PADR("DT.EMISSAO",12," ")
			cLin += PADL("VALOR         ",20," ")
			cLin += PADL("SALDO PA      ",20," ")
			
			@nLin,00 PSAY cLin
			nLin 	:= nLin + 1
		EndIf
		
		//Efetuo gravação de dados do relatório em arquivo.
		While !TMP3->(EOF()) 
		
			If nLin > 57 // Salto de Página. Neste caso o formulario tem 55 linhas...
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 8
				@nLin,00 PSAY "CONTINUAÇÃO PA - CCR: " + Posicione("SZ3",1,xFilial("SZ3")+SZ6TMP->Z6_CODCCR,"Z3_DESENT")
				nLin 	:= nLin + 1  
				
				//Adiciono cabecalho
				cLin := PADR("PREFIXO"   ,12," ")
				cLin += PADR("TITULO"    ,12," ")
				cLin += PADR("PARCELA"   ,12," ")
				cLin += PADR("DT.EMISSAO",12," ")
				cLin += PADL("VALOR         ",20," ")
				cLin += PADL("SALDO PA      ",20," ")

				@nLin,00 PSAY cLin
				nLin 	:= nLin + 1
			Endif
			
			//Gravo dados PA
			cLin := PADR(TMP3->E2_PREFIXO 								,12," ")
			cLin += PADR(TMP3->E2_NUM	  	   							,12," ")
			cLin += PADR(TMP3->E2_PARCELA 	   							,12," ")
			cLin += PADR(DTOC(TMP3->E2_EMISSAO)							,12," ")
			cLin += PADR(TRANSFORM(TMP3->E2_VALOR, "@E 999,999,999.99")	,20," ")
			cLin += PADR(TRANSFORM(TMP3->E2_SALDO, "@E 999,999,999.99")	,20," ")
			
			@nLin,00 PSAY cLin
			nLin 	:= nLin + 1					
			
			TMP3->(DbSkip())
		EndDo
	
	EndIf
	
	
EndIf

//Faço tratamento para clube do revendedor.
If MV_PAR03 == 5
	
	Cabec1 := PADR("QUANTIDADE"	 ,19 ," ")  + "|"
	If MV_PAR04 != 2
		Cabec1 += PADR("NOME PARCEIRO"	 ,49 ," ") + "|"
	EndIf
	If MV_PAR04 == 3
		Cabec1 += PADR("PRODUTO"	 ,49 ," ") + "|"
	Else
		Cabec1 += PADR("VENDEDOR"	 	 ,49 ," ")  + "|"
	EndIf
	Cabec1 += PADR("TOTAL FAT. "	 ,19 ," ")  + "|"
	Cabec1 += PADR("TOTAL COM. "	 ,19 ," ")  + "|"
	
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	nLin := 8
	
	If MV_PAR04 == 1 //Geral
		cQuery := " SELECT Z6_DESENT, 
		cQuery += " Z6_NOMVEND, SUM(Z6_VLRPROD) Z6_VALFAT, SUM(Z6_VALCOM) Z6_VALCOM, COUNT(*) QUANTIDADE FROM PROTHEUS.SZ6010 "
		cQuery += " WHERE "
		cQuery += " Z6_FILIAL = ' ' AND "
		cQuery += " Z6_PERIODO = '"+MV_PAR01+"' AND "
		cQuery += " Z6_TPENTID IN ('7','10') AND "
		cQuery += " D_E_L_E_T_ = ' ' "
		cQuery += " GROUP BY Z6_DESENT, Z6_NOMVEND "
		cQuery += " Order by  Z6_DESENT"
	Elseif MV_PAR04 == 2 //Clube
		cQuery := " SELECT Z6_DESREDE, Z6_DESENT , Z6_PRODUTO, SUM(Z6_VLRPROD) Z6_VALFAT, SUM(Z6_VALCOM) Z6_VALCOM, COUNT(*) QUANTIDADE FROM PROTHEUS.SZ6010 "
		cQuery += " WHERE "
		cQuery += " Z6_FILIAL = ' ' AND "
		cQuery += " Z6_PERIODO = '"+MV_PAR01+"' AND "
		cQuery += " (Z6_TPENTID = '10' OR (Z6_TPENTID = '7' AND Z6_CODAC = 'ICP')) AND "
		cQuery += " D_E_L_E_T_ = ' ' "
		cQuery += " GROUP BY  Z6_DESREDE, Z6_DESENT, Z6_PRODUTO "
		cQuery += " Order by  Z6_DESREDE, Z6_DESENT, Z6_PRODUTO "
	Elseif MV_PAR04 == 3 //Campanha
		cQuery := " SELECT Z6_DESENT, Z6_PRODUTO , SUM(Z6_VLRPROD) Z6_VALFAT, SUM(Z6_VALCOM) Z6_VALCOM, COUNT(*) QUANTIDADE FROM PROTHEUS.SZ6010 "
		cQuery += " WHERE "
		cQuery += " Z6_FILIAL = ' ' AND "
		cQuery += " Z6_PERIODO = '"+MV_PAR01+"' AND "
		cQuery += " Z6_TPENTID = '7' AND "
		cQuery += " D_E_L_E_T_ = ' ' "
		cQuery += " GROUP BY Z6_DESENT, Z6_PRODUTO "
		cQuery += " Order by  Z6_DESENT,Z6_PRODUTO"		
	EndIf
	
	
	If Select("TMP") > 0
		TMP->( DbCloseArea() )
	EndIf
	
	PLSQuery( cQuery, "TMP" )
	
	DbSelectArea("TMP")
	TMP->(DbGoTop())
	                                                           
	nVlFatu := 0
	nVlComi := 0
	cDesEnt := TMP->Z6_DESENT
	
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	nLin := 8
	
	@nLin,00 PSAY "CCR: " + TMP->Z6_DESENT
	nLin 	:= nLin + 1
	@nLin,00 PSAY Replicate("_",220)
	nLin 	:= nLin + 1
	
	While !EOF("TMP")
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica o cancelamento pelo usuario...                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif
		
		nLin 	:= nLin + 1
		                                                                                                      
		If nLin > 60 // Salto de Página. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		Endif
		
		lQuebra := Iif(AllTrim(cDesEnt) <> AllTrim(TMP->Z6_DESENT),.T.,.F.)		
		
		If lQuebra
			cDesEnt := TMP->Z6_DESENT
			
			nLin 	:= nLin + 1
			@nLin,00 PSAY Replicate("_",220)
			cImpLin := PADR(Transform( nQuant ,"@E 999,999,999.99"),19 ," ")  + "|"
			If MV_PAR04 != 2
				cImpLin += Space(99)  + "|"
			Else
				cImpLin += Space(49)  + "|"
			EndIf
			cImpLin += PADR(Transform( nVlFatu ,"@E 999,999,999.99"),19 ," ")  + "|"
			cImpLin += PADR(Transform( nVlComi ,"@E 999,999,999.99"),19 ," ")  + "|"
			nLin 	:= nLin + 1
			@nLin,00 PSAY cImpLin
			
			nQuant  := 0
			nVlFatu := 0
			nVlComi := 0
			
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
			
			@nLin,00 PSAY "CCR: " + TMP->Z6_DESENT
			nLin 	:= nLin + 1
			@nLin,00 PSAY Replicate("_",220)
			nLin 	:= nLin + 1
			
		EndIf
		
		cImpLin := PADR(Transform(TMP->QUANTIDADE 			,"@E 999,999,999.99")	,20 ," ")
		If MV_PAR04 != 2
			cImpLin += PADR(TMP->Z6_DESENT											,50 ," ")
		EndIf
		cImpLin += PADR(TMP->Z6_PRODUTO											,50 ," ")
		cImpLin += PADR(Transform(TMP->Z6_VALFAT 			,"@E 999,999,999.99")	,20 ," ")
		cImpLin += PADR(Transform(TMP->Z6_VALCOM 			,"@E 999,999,999.99")	,20 ," ")
		
		nVlFatu += TMP->Z6_VALFAT
		nVlComi += TMP->Z6_VALCOM
		nQuant  += TMP->QUANTIDADE
		
		@nLin,00 PSAY cImpLin
		
		TMP->(DbSkip())
	EndDo
	
	nLin 	:= nLin + 1
	@nLin,00 PSAY Replicate("_",220)
	cImpLin := PADR(Transform( nQuant ,"@E 999,999,999.99"),19 ," ")  + "|" 
	If MV_PAR04 == 2
		cImpLin += Space(49)  + "|"
	Else
		cImpLin += Space(99)  + "|"
	EndIf
	cImpLin += PADR(Transform( nVlFatu ,"@E 999,999,999.99"),19 ," ")  + "|"
	cImpLin += PADR(Transform( nVlComi ,"@E 999,999,999.99"),19 ," ")  + "|"
	nLin 	:= nLin + 1
	@nLin,00 PSAY cImpLin
	
	
EndIf

//Faço tratamento para Canal.
If MV_PAR03 == 3 .Or. MV_PAR03 == 4
	
	Cabec1 := PADR("QUANTIDADE"	 ,19 ," ")  + "|"
	Cabec1 += "PRODUTO" + Space(23) 		+ "|"
	Cabec1 += PADR("TOTAL FAT. "	 ,19 ," ")  + "|"
	Cabec1 += PADR("DESCONTOS "	 	 ,19 ," ")  + "|"
	Cabec1 += PADR("TOTAL LIQ. "	 ,19 ," ")  + "|"
	Cabec1 += PADR("TOTAL COM. "	 ,19 ," ")  + "|"
	
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	nLin := 8
	
	cQuery := " SELECT Z6_DESENT, "
	cQuery += " Z6_PRODUTO, "
	cQuery += " SUM(Z6_VLRPROD) Z6_VALFAT, "
	cQuery += " SUM(Z6_BASECOM) Z6_VALLIQ, "
	cQuery += " SUM(Z6_VALCOM) Z6_VALCOM, "
	cQuery += " SUM(Z6_VLRABT) Z6_VLRABT, "
	cQuery += " COUNT(*) QUANTIDADE "
	cQuery += " FROM PROTHEUS.SZ6010 SZ6 "
	cQuery += " JOIN PROTHEUS.SZ3010 SZ3 ON SZ3.Z3_FILIAL = ' ' AND Z6_CODENT = SZ3.Z3_CODENT AND SZ3.D_E_L_E_T_ = ' ' "
  	cQuery += " LEFT JOIN PROTHEUS.SZF010 SZF ON ZF_FILIAL = ' ' AND ZF_COD = Z6_CODVOU AND ZF_COD > '0' AND SZF.D_E_L_E_T_ = ' ' AND Trim(ZF_PDESGAR) = Trim(Z6_PRODUTO) AND ZF_SALDO = 0 "
	cQuery += " LEFT JOIN PROTHEUS.SZ5010 SZ5 ON SZ5.Z5_FILIAL = ' ' AND SZ5.Z5_PEDGAR > '0' AND SZ5.Z5_PEDGAR = Trim(regexp_replace(ZF_PEDIDO,'[[:punct:]]',' ')) AND SZ5.D_E_L_E_T_ = ' 'AND SZ5.Z5_PRODGAR > '0' "
	cQuery += " LEFT JOIN PROTHEUS.SZH010 SZH ON ZH_FILIAL = ' ' AND ZH_TIPO = Z6_TIPVOU AND SZH.D_E_L_E_T_ = ' ' "
	cQuery += " LEFT JOIN PROTHEUS.SZ3010 SZ32 ON SZ32.Z3_FILIAL = ' ' AND Z6_CODPOS = SZ32.Z3_CODGAR AND SZ32.Z3_CODGAR > '0' AND SZ32.Z3_TIPENT = '4' AND SZ32.D_E_L_E_T_ = ' ' "
	cQuery += " WHERE "
	cQuery += " Z6_FILIAL = ' ' AND "
	cQuery += " Z6_PERIODO = '"+MV_PAR01+"' AND "
	cQuery += " Z6_TPENTID = '"+Iif(MV_PAR03==3,"1","8")+"' AND "
	cQuery += " SZ6.D_E_L_E_T_ = ' ' "
	cQuery += " GROUP BY Z6_DESENT,Z6_PRODUTO  "
	cQuery += " ORDER BY Z6_DESENT "
	
	If Select("TMP") > 0
		TMP->( DbCloseArea() )
	EndIf
	
	PLSQuery( cQuery, "TMP" )
	
	DbSelectArea("TMP")
	TMP->(DbGoTop())
	
	nVlFatu := 0
	nVlComi := 0
	cDesEnt := TMP->Z6_DESENT
	
	
	@nLin,00 PSAY "ENTIDADE: " + TMP->Z6_DESENT
	@nLin,00 PSAY Replicate("_",220)
	nLin 	:= nLin + 2
	
	While !EOF("TMP")
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica o cancelamento pelo usuario...                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif
		
		nLin 	:= nLin + 1
		
		If nLin > 60 // Salto de Página. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		Endif
		
		If cDesEnt <> TMP->Z6_DESENT
			
			nLin 	:= nLin + 1
			@nLin,00 PSAY Replicate("_",220)
			cImpLin := PADR(Transform( nQuant ,"@E 999,999,999.99"),19 ," ")  + "|"
			cImpLin += Space(29)  + "|"
			cImpLin += PADR(Transform( nVlFatu ,"@E 999,999,999.99"),19 ," ")  + "|"
			cImpLin += PADR(Transform( nVlDesc ,"@E 999,999,999.99"),19 ," ")  + "|"
			cImpLin += PADR(Transform( nVlLiq  ,"@E 999,999,999.99"),19 ," ")  + "|"
			cImpLin += PADR(Transform( nVlComi ,"@E 999,999,999.99"),19 ," ")  + "|"
			nLin 	:= nLin + 1
			@nLin,00 PSAY cImpLin
			
			nVlFatu := 0
			nVlComi := 0
			nQuant  := 0
			nVlLiq  := 0
			nVlDesc := 0
			
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
			
			cDesEnt := TMP->Z6_DESENT
			
			@nLin,00 PSAY "ENTIDADE: " + TMP->Z6_DESENT
			@nLin,00 PSAY Replicate("_",220)
			nLin 	:= nLin + 2
		EndIf
		
		cImpLin := PADR(Transform(TMP->QUANTIDADE 			,"@E 999,999,999.99")	,20 ," ")
		cImpLin += PADR(TMP->Z6_PRODUTO												,30 ," ")
		cImpLin += PADR(Transform(TMP->Z6_VALFAT 			,"@E 999,999,999.99")	,20 ," ")
		cImpLin += PADR(Transform(TMP->Z6_VLRABT 			,"@E 999,999,999.99")	,20 ," ")
		cImpLin += PADR(Transform(TMP->Z6_VALLIQ 			,"@E 999,999,999.99")	,20 ," ")
		cImpLin += PADR(Transform(TMP->Z6_VALCOM 			,"@E 999,999,999.99")	,20 ," ")
		
		nVlFatu += TMP->Z6_VALFAT
		nVlLiq  += TMP->Z6_VALLIQ
		nVlDesc += TMP->Z6_VLRABT
		nVlComi += TMP->Z6_VALCOM
		nQuant  += TMP->QUANTIDADE
		
		@nLin,00 PSAY cImpLin
		
		TMP->(DbSkip())
	EndDo
	
	nLin 	:= nLin + 1
	@nLin,00 PSAY Replicate("_",220)
	cImpLin := PADR(Transform( nQuant ,"@E 999,999,999.99"),19 ," ")  + "|"
	cImpLin += Space(29)  + "|"
	cImpLin += PADR(Transform( nVlFatu ,"@E 999,999,999.99"),19 ," ")  + "|"
	cImpLin += PADR(Transform( nVlDesc ,"@E 999,999,999.99"),19 ," ")  + "|"
	cImpLin += PADR(Transform( nVlLiq  ,"@E 999,999,999.99"),19 ," ")  + "|"
	cImpLin += PADR(Transform( nVlComi ,"@E 999,999,999.99"),19 ," ")  + "|"
	nLin 	:= nLin + 1
	@nLin,00 PSAY cImpLin
	
EndIf


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SET DEVICE TO SCREEN

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em disco, chama o gerenciador de impressao...          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma ValidPerg ºAutor  ³Renato Ruy Bernardo    º Data ³  04/06/2013º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função Responsavel por criar as perguntas utilizadas no    º±±
±±º          ³ Relatório.                                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Certisign                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ValidPerg()
Local aHelp		:=	{}


cPerg := PADR( cPerg, Len(SX1->X1_GRUPO) )


//    ( [ cGrupo ] 	[ cOrdem ] 	[ cPergunt ] 				[ cPerSpa ] 				[ cPerEng ] 				[ cVar ] 	[ cTipo ] 	[ nTamanho ] 	[ nDecimal ] 	[ nPresel ] [ cGSC ] 	[ cValid ] 	[ cF3 ] 	[ cGrpSxg ] [ cPyme ] 	[ cVar01 ] 	[ cDef01 ] 			[ cDefSpa1 ] 		[ cDefEng1 ] 		[ cCnt01 ] [ cDef02 ] 		[ cDefSpa2 ] 	[ cDefEng2 ] 	[ cDef03 ] [ cDefSpa3 ] [ cDefEng3 ] 	[ cDef04 ] 	[ cDefSpa4 ] 	[ cDefEng4 ] 	[ cDef05 ] 	[ cDefSpa5 ] 	[ cDefEng5 ] 	 [ aHelpPor ] 	[ aHelpEng ] 	 	[ aHelpSpa ] 		[ cHelp ] 	)
PutSX1(	cPerg		,"01" 		,"Periodo  ?"	   			,"Periodo  ?"  	  	 		,"Periodo  ?"  		 		,"mv_ch1" 	,"C" 		,06     		,0      		,0     		,"G"		,""          ,""	    ,""         ,"S"        ,"mv_par01"	,""        			,""           		,""          		,""   		,""             ,""             ,""             ,""   		,""   		,""   			,""   		,""   			,""   		    ,""         ,""   			,""   			, {""}		  ,	 {""}  				, {""} 				,""   		)
PutSX1(	cPerg		,"02" 		,"AC  ?"		   			,"AC  ?"	  	  	 		,"AC  ?"	  		 		,"mv_ch2" 	,"C" 		,04     		,0      		,0     		,"G"		,""          ,""	    ,""         ,"S"        ,"mv_par02"	,""        			,""           		,""          		,""   		,""             ,""             ,""             ,""   		,""   		,""   			,""   		,""   			,""   		    ,""         ,""   			,""   			, {""}		  ,	 {""}  				, {""} 				,""   		)
PutSX1(	cPerg		,"03" 		,"Tipo Entidade ?"	  		,"Tipo Entidade ?"	  		,"Tipo Entidade ?"	  		,"mv_ch3" 	,"N" 		,01     		,0      		,0     		,"C"		,""          ,""	    ,""         ,"S"        ,"mv_par03"	,"Posto"   			,"Posto"   			,"Posto"   			,""   		,"AC"           ,"AC"           ,"AC"           ,"Canal"    ,"Canal"    ,"Canal"    	,"Federação","Federação"	,"Federação"	,"Campanha/Clube","Campanha/Clube","Campanha/Clube", {""}		  ,	 {""}  				, {""} 				,""   		)
PutSX1(	cPerg		,"04" 		,"Tipo Campanha ?"	  		,"Tipo Campanha ?"	  		,"Tipo Campanha ?"	  		,"mv_ch4" 	,"N" 		,01     		,0      		,0     		,"C"		,""          ,""	    ,""         ,"S"        ,"mv_par04"	,"Geral"   			,"Geral"   			,"Geral"   			,""   		,"Revendedor"   ,"Revendedor"   ,"Revendedor"   ,"Contador" ,"Contador" ,"Contador"  	,""    		,""		        ,""		        ,""         ,""   			,""   			, {""}		  ,	 {""}  				, {""} 				,""   		)
Return

