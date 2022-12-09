#INCLUDE "rwmake.ch"

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±+-------------+----------------+------------------+-------+-------------+±±
±±|Programa		|	FISR001()	 |Connit - Vanilson |Data	| 17/11/09	  |±±
±±+-------------+----------------+------------------+-------+-------------+±±
±±|Descrição 	| Relatorio gerencial de despesas, com Aluguel e Energia  |±±		   
±±|             | Mês Atual X Mês Anterior, referente aos últimos         |±±
±±|             | 12 meses                                                |±±
±±+-------------+---------------------------------------------------------+±± 
±±|Sintaxe      | FISR001()	 		                                      |±±
±±+-------------+---------------------------------------------------------+±±
±±|Parâmetros   | Não tem									              |±±
±±+-------------+---------------------------------------------------------+±±
±±|Retorno      | Arquivo Excel											  |±±
±±+-------------+---------------------------------------------------------+±±
±±|Uso          | Especifico para Laselva                                 |±±
±±+-------------+---------------------------------------------------------+±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

User Function FISR001()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local   aButtons    := {}
Local   aSays       := {}
Local   cCadastro   := "Relatorio de Despesas com Aluguel / Energia Eletrica"
Local   nOpcA
Private cPerg       := Padr("FISR01",len(SX1->X1_GRUPO)," ")
Private cString     := "SE2"    

_pergunt()

Pergunte(cPerg,.F.)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montagem da tela de processamento.                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


AADD(aSays,"Este programa tem como objetivo gerar o relatorio gerencial ")
AADD(aSays,"de despesas de acordo com os parametros informados pelo usuario.")
AADD(aSays,"Para posterior abertura no EXCEL")
AADD(aButtons, { 1,.T.,{|o| nOpca:= 1,o:oWnd:End() } } )
AADD(aButtons, { 2,.T.,{|o| o:oWnd:End() }} )
FormBatch( cCadastro, aSays, aButtons )
	
If nOpcA == 1 
 
    Pergunte(cPerg,.T.)
 	OkGeraTxt()
	 	//LjMsgRun("Aguarde..., Processando registros...",, {|| CriaArq() })	
EndIf		
		
Return
 
  

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±+-------------+----------------+------------------+-------+-------------+±±
±±|Função 		|  OkGeraTxt()	 |Vanilson - Connit | Data	| 			  |±±
±±+-------------+----------------+------------------+-------+-------------+±±
±±|Descrição 	| Funcao chamada pelo botao OK na tela inicial de         |±±		   
±±|             | processamento. Executa a geracao do arquivo texto.      |±±
±±+-------------+---------------------------------------------------------+±± 
±±|Sintaxe      |  OkGeraTxt() 								   			  |±±
±±+-------------+---------------------------------------------------------+±±
±±|Parâmetros   |  não tem									              |±±
±±+-------------+---------------------------------------------------------+±±
±±|Retorno      | 												 		  |±±
±±+-------------+---------------------------------------------------------+±±
±±|Uso          | Programa principal				                      |±±
±±+-------------+---------------------------------------------------------+±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
Static Function OkGeraTxt

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria o arquivo texto                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local aCabExcel     :={} 
Local aItensExcel   :={} 

   
If mv_par03 == 1  

    AADD(aCabExcel, {"FILIAL",      	    "C",  02, 0 })
    AADD(aCabExcel, {"TITULO",      	    "C",  08, 0 })
	AADD(aCabExcel, {"SERIE",       	    "C",  02, 0 })
	AADD(aCabExcel, {"PREFIXO",     	    "C",  03, 0 })
	AADD(aCabExcel, {"EMISSAO",     	    "D",  08, 0 })
	AADD(aCabExcel, {"BAIXA",               "D",  08, 0 })
	AADD(aCabExcel, {"COD_FORNECECEDOR",    "C",  26, 0 })
	AADD(aCabExcel, {"NOME_FORNECECEDOR",   "C",  26, 0 })
	AADD(aCabExcel, {"LOJA",                "C",  02, 0 })
	AADD(aCabExcel, {"CODIGO",      	    "C",  15, 0 })
	AADD(aCabExcel, {"VALOR",           	"N",  08, 2 })
	AADD(aCabExcel, {"''",	              	"C",  02, 0 })
	
Else 

    AADD(aCabExcel, {"FILIAL", 				"C",  02, 0 })
    AADD(aCabExcel, {"TITULO",   			"C",  08, 0 })
	AADD(aCabExcel, {"SERIE",   			"C",  03, 0 })
	AADD(aCabExcel, {"EMISSAO",    			"D",  08, 0 })
	AADD(aCabExcel, {"COD_FORNECEDOR", 		"C",  20, 0 })
	AADD(aCabExcel, {"LOJA", 				"C",  02, 0 })
	AADD(aCabExcel, {"NOME",  				"C",  20, 0 })
	AADD(aCabExcel, {"PRODUTO",   			"C",  16, 0 })
	AADD(aCabExcel, {"DESCRICAO",   		"C",  20, 0 })
	AADD(aCabExcel, {"VALOR",    			"N",  10, 2 })
	AADD(aCabExcel, {"''",  				"C",  02, 0 })
	
	
EndIf

	MsgRun("Favor Aguardar.....", "Selecionando os Registros",; 
	    {|| GProcItens(aCabExcel, @aItensExcel)}) 

	   
	If mv_par03 == 1 
	   	
	   	MsgRun("Favor Aguardar.....",   "Exportando os Registros para o Excel",;    
	        {||DlgToExcel({{"GETDADOS", " ALUGUEL ",; 
	        aCabExcel,aItensExcel}})}) 
       
    Else 
    
       	MsgRun("Favor Aguardar.....",   "Exportando os Registros para o Excel",; 
            {||DlgToExcel({{"GETDADOS", " ENERGIA ELETRICA ",; 
	        aCabExcel,aItensExcel}})}) 
       
    EndIf
       
    dbselectarea("TMP")
    dbclosearea()

Return 


/*/ 
+----------------------------------------------------------------------
| Função | GProcItens | Autor | Ricardo Felipelli   | Data | |         |
+----------------------------------------------------------------------
| Uso | Curso ADVPL |                                                  |
+----------------------------------------------------------------------
/*/ 

Static Function GProcItens(aHeader, aCols) 

Local aItem 
Local nX
Local nCount 	:= 1
Local nTotal 	:= 0
Local aLenCol	:= {}	 

_periodo  := "('" + strzero(month(mv_par01),2) + "'"
_monthini := month(mv_par01)
_monthfim := month(mv_par02)    
_monthatu := _monthini

while _monthatu <  month(mv_par02)
	  _monthatu ++
	  _periodo  += ",'"+strzero(_monthatu,2)+"'"
enddo   
_periodo += ")"

If mv_par03 == 1    // Aluguel   
  
    cQuery :=" SELECT D1_FILIAL AS FILIAL,                 		"
    cQuery +=       "D1_DOC      AS TITULO,                		"
    cQuery +=       "D1_SERIE    AS SERIE,                 		"
    cQuery +=       "E2_PREFIXO  AS PREFIXO,               		"
    cQuery +=       "E2_EMISSAO  AS EMISSAO,               		"
    cQuery +=       "E2_BAIXA    AS BAIXA,                 		"
    cQuery +=       "D1_FORNECE  AS COD_FORNECEDOR,        		"
    cQuery +=       "E2_NOMFOR   AS NOME_FORNECEDOR,       		"
    cQuery +=       "D1_LOJA     AS LOJA,                  		"
    cQuery +=       "D1_COD      AS CODIGO,                		"
    cQuery +=       "D1_VUNIT    AS VALOR,				  		"  
    cQuery +=       "' ' 				   				   		"
    cQuery +=" FROM   " + RetSqlName("SE2") + " SE2 (NOLOCK) 	"
    cQuery += " INNER JOIN " + RetSqlName("SD1") + " SD1  (NOLOCK)            "
    cQuery +="ON     D1_DOC+D1_SERIE = E2_NUM+SUBSTRING(E2_PREFIXO,1,1)" 
    cQuery +="WHERE  E2_BAIXA BETWEEN '" + DTOS(mv_par01) + "' AND '" + DTOS(mv_par02) + "'  AND "
    cQuery +=       "D1_COD   IN ('990801', '990802', '990803')  AND                "
    cQuery +=       "SD1.D_E_L_E_T_ = '' AND "
    cQuery +=       "SE2.D_E_L_E_T_ = '' "
	cQuery +="ORDER BY D1_FILIAL" 
    
Else

    cQuery :="SELECT D1_FILIAL     AS FILIAL,	 			   		" +CHAR(13)
    cQuery +=       "D1_DOC        AS TITULO,       	       		" +CHAR(13)
    cQuery +=       "D1_SERIE      AS SERIE,  	 		       		" +CHAR(13)
    cQuery +=       "D1_EMISSAO    AS EMISSAO,	               		" +CHAR(13)
    cQuery +=       "D1_FORNECE    AS COD_FORNECEDOR,          		" +CHAR(13)
    cQuery +=       "D1_LOJA       AS LOJA,                    		" +CHAR(13)
    cQuery +=       "A2_NOME       AS NOME,                    		" +CHAR(13)
    cQuery +=       "D1_COD        AS PRODUTO,                 		" +CHAR(13)
    cQuery +=       "B1_DESC       AS DESCRICAO,               		" +CHAR(13)
    cQuery +=       "SUM(D1_TOTAL) AS VALOR,	   			   		" +CHAR(13)
    cQuery +=       "' '                      				   		" +CHAR(13)
    cQuery += " FROM " + RetSqlName("SD1") + " SD1 (NOLOCK) 	  	"
    cQuery += " INNER JOIN " + RetSqlName("SA2") + " SA2 (NOLOCK) 	"
    cQuery +="ON D1_FORNECE = A2_COD AND D1_LOJA = A2_LOJA AND SA2.D_E_L_E_T_ = '' "
	cQuery +=            "INNER JOIN " + 	RetSqlName("SB1") + " SB1 (NOLOCK)" 
	cQuery +="ON D1_COD = B1_COD AND SB1.D_E_L_E_T_ = '' "
	cQuery +="WHERE D1_COD = '990823'  AND "
	cQuery +="D1_EMISSAO BETWEEN '" + DTOS(mv_par01) + "' AND '" + DTOS(mv_par02) + "' AND " 
	cQuery +="SD1.D_E_L_E_T_ = '' "
	cQuery +="GROUP BY D1_FILIAL, D1_DOC ,D1_SERIE, D1_EMISSAO, D1_FORNECE, D1_LOJA, A2_NOME, D1_COD, B1_DESC "
	cQuery +="ORDER BY D1_FILIAL " 

EndIF                                                                

dbUseArea(.T., 'TOPCONN', TCGenQry(,,cQuery), "TMP", .F., .T.)                    

DbselectArea("TMP")
TMP->( DbGotop() )
If TMP->( !Eof() )
	
	While TMP->( !Eof() ) 
		
		aItem 	:= Array(Len(aHeader)) 
		
		For nX 	:= 1 to Len(aHeader) 
			
			If aHeader[nX][2] == "C" 
				aItem[nX] := CHR(160)+TMP->&(aHeader[nX][1]) 
			Else 
				aItem[nX] := TMP->&(aHeader[nX][1]) 
			EndIf 
			
		Next nX 

		AADD(aCols,aItem) 
		aItem 	:= {} 
			
		If mv_par03 == 1 
			nTotal 	+= aCols[nCount][11]
	    Else
	    	nTotal 	+= aCols[nCount][10]
	    End	
		nCount 	++		
		
		TMP->( dbSkip() ) 
	
	EndDo                                                                    
	
	  If mv_par03 == 1   
	  		AADD(aCols,{" "," "," "," "," "," "," "," "," ","VALOR TOTAL ",nTotal,''})
	  Else                                                                     
	  		AADD(aCols,{" "," "," "," "," "," "," "," ","VALOR TOTAL ",nTotal,''})	   
	  EndIf	 
Else

	MsgStop("Nao existem registros para processamento!")

EndIf    


Return        


// **************************************

Static Function _pergunt()
_sAlias := Alias()
DBSelectArea("SX1")
DBSetOrder(1)                          

aRegs := {}

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
AADD(aRegs,{cPerg,"01","Da Data                ?","Da Data            ?","Da Data            ?","mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"02","Ate a Data             ?","Ate a Data         ?","Ate a Data         ?","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"14","Tipo de Despesa        ?","Tipo de Despesa     ?","Tipo de Despesa   ?","mv_ch3","N", 1,0,1,"C","","mv_par03","Aluguel","","","","","Energia","","","","","","","","","","","","","","","","","","","","",""})

For I:=1 to Len(aRegs)
   If !DBSeek(cPerg+aRegs[i,2])
      RecLock("SX1",.T.)
      //For j:=1 to Max(FCount(), Len(aRegs[i]))
      For j:=1 to Len(aRegs[i])
         FieldPut(j,aRegs[i,j])
      Next
      MsUnlock()
   Endif
Next

DBSelectArea(_sAlias)

Return  
