#Include "Protheus.ch"  

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³METEC01   ³ Autor ³ Adalberto Mendes Neto ³ Data ³18/02/2014³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Locacao   ³ Metalacre        ³Contato ³adalberto.neto@totvs.com.br     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Funcao para o gatilho do D1_COD. Vai pegar o numero da no- ³±±        
±±³          ³ digitado no cabecalho e vai jogar no campo D1_LOTECTL.     ³±±        
±±³          ³ Somente para os produtos que tenham B1_RASTRO = S          ³±±        
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Nota de Entrada                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista Resp.³  Data  ³ Manutencao Efetuada                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³        ³                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function METEC01( )
	                   
Local cNumNota	:= CNFISCAL
Local cQuery	:= ""
Local cLinha   	:= CHR(13) + CHR(10)   
Local aArea    	:= GetArea()  
Local cCodPro	:= M->D1_COD	
Local nPosLote  := aScan(aHeader, {|x| Upper(AllTrim(x[2])) == 'D1_LOTECTL' })

// Se o Lote Já Foi Preenchido no Caso de Notas de Devolucao Então Retorna com o Mesmo valor

//If !Empty(aCols[n,nPosLote])
//	Return aCols[n,nPosLote]
//Endif

cQuery := "SELECT" + cLinha
cQuery += "	B1_COD, B1_DESC, B1_FILIAL, B1_RASTRO" + cLinha
cQuery += "FROM" + cLinha
cQuery += "	" + RetSqlName("SB1") + " " + cLinha
cQuery += "WHERE" + cLinha
cQuery += "	D_E_L_E_T_ = ''" + cLinha
cQuery += "	AND B1_COD = '" + cCodPro + "'" + cLinha 
cQuery += "	AND B1_FILIAL = '" + cFilAnt + "'" + cLinha
dbUseArea(.T.,	"TOPCONN",	TcGenQry(,,cQuery), "QUERY",	.T., .T.)

QUERY->( dbGoTop() )

If !QUERY->(EOF())
	If QUERY->B1_RASTRO <> "L"
		cNumNota := ""
	Endif	
Endif

QUERY->(dbCloseArea())          

RestArea(aArea)              
	
Return( cNumNota )