#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RCTBR002 º Autor ³ Ricardo Felipelli  º Data ³  29/07/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatorio gerencial de despesas,                           º±±
±±º          ³ Solicitante: joao mochizuki                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ mp8 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function LS_RCTBR002

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private oGeraTxt
Private cPerg       := Padr("CTBR02",len(SX1->X1_GRUPO)," ")
Private cString     := "CT2"    

_pergunt()

Pergunte(cPerg,.f.)
dbSelectArea("CT2")

dbSetOrder(1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montagem da tela de processamento.                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

@ 200,001 TO 380,380 DIALOG oGeraTxt TITLE OemToAnsi("Relatorio Gerencial de Despesas")
@ 002,010 TO 080,190
@ 010,018 Say " Este programa tem como objetivo gerar o relatorio gerencial de "
@ 018,018 Say " despesas de acordo com os parametros informados pelo usuario.  "
@ 026,018 Say " Para posterior abertura no EXCEL                               "

@ 065,090 BMPBUTTON TYPE 01 ACTION OkGeraTxt()
@ 065,120 BMPBUTTON TYPE 02 ACTION Close(oGeraTxt)
@ 065,150 BMPBUTTON TYPE 05 ACTION Pergunte(cPerg,.T.)

Activate Dialog oGeraTxt Centered     


Return
   

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ OKGERATXTº Autor ³ AP5 IDE            º Data ³  29/07/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao chamada pelo botao OK na tela inicial de processamenº±±
±±º          ³ to. Executa a geracao do arquivo texto.                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function OkGeraTxt

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria o arquivo texto                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local aCabExcel     :={} 
Local aItensExcel   :={}

AADD(aCabExcel, {"CT2_FILIAL", "C",  02, 0 })
AADD(aCabExcel, {"CT2_DATA",   "D",  02, 0 })
AADD(aCabExcel, {"CT2_LOTE",   "C",  06, 0 })
AADD(aCabExcel, {"CT2_DOC",    "C",  06, 0 })
AADD(aCabExcel, {"CT2_DEBITO", "C",  20, 0 })
AADD(aCabExcel, {"CTA_DEBITO", "C",  20, 0 }) // Para trazer a descrição da conta CCREDIT
AADD(aCabExcel, {"CT2_CREDIT", "C",  20, 0 })
AADD(aCabExcel, {"CTA_CREDITO","C",  40, 0 }) // Para trazer a descrição da conta CCREDIT
AADD(aCabExcel, {"CT2_VALOR",  "N",  17, 2 })
AADD(aCabExcel, {"MES",        "C",  02, 0 })
AADD(aCabExcel, {"CT2_HIST",   "C",  40, 0 })
AADD(aCabExcel, {"CT2_CCD",    "C",  09, 0 })
AADD(aCabExcel, {"DESCCCD",    "C",  40, 0 }) // ver como vai trazer a informação da tabela CTT (CCUSTODEB)
AADD(aCabExcel, {"CT2_CCC",    "C",  09, 0 })
AADD(aCabExcel, {"DESCCCC",    "C",  40, 0 }) // ver como vai trazer a informação da tabela CTT (CCUSTOCRED)
AADD(aCabExcel, {"CT2_ROTINA", "C",  10, 0 })
AADD(aCabExcel, {"CT2_SEQIDX", "C",  10, 0 }) // Os próximos campos foram acrescentados pelo Rodrigo (a usuária pediu 7)



MsgRun("Favor Aguardar.....", "Selecionando os Registros",; 
	{|| GProcItens(aCabExcel, @aItensExcel)}) 

MsgRun("Favor Aguardar.....", "Exportando os Registros para o Excel",; 
	{||DlgToExcel({{"GETDADOS",; 
	"POSIÇÃO DE TÍTULOS DE VENDOR NO PERÍODO",; 
	aCabExcel,aItensExcel}})}) 

dbselectarea("TMP")
dbclosearea()
Return 



/*/ 
+----------------------------------------------------------------------
| Função | GProcItens | Autor | Ricardo Felipelli   | Data | | 
+----------------------------------------------------------------------
| Uso | Curso ADVPL | 
+----------------------------------------------------------------------
/*/ 

Static Function GProcItens(aHeader, aCols) 

Local aItem 
Local nX 
Local _cHist
Local _nPosic
Local _cNfiscal

                                                                            
_monthini := LEFT(DTOS(mv_par01),6)
_monthfim := LEFT(DTOS(mv_par02),6) + 'ZZ'
 
cQuery := " SELECT CT2_FILIAL, "         
cQuery += _cEnter + "        SUBSTRING(CT2_DATA,7,2)+'/'+SUBSTRING(CT2_DATA,5,2)+'/'+SUBSTRING(CT2_DATA,1,4) AS CT2_DATA, "
cQuery += _cEnter + "        CT2_LOTE, CT2_DOC, CT2_DEBITO, CT1DEB.CT1_DESC01 CTA_DEBITO, CT2_CREDIT, CT1CRED.CT1_DESC01 CTA_CREDITO, CT2_VALOR, SUBSTRING(CT2_DATA,5,2) MES, CT2_HIST, "

cQuery += _cEnter + "		   CT2_CCD, ISNULL(CTTCCD.CTT_DESC01,'') DESCCCD, CT2_CCC, ISNULL(CTTCCC.CTT_DESC01,'') DESCCCC, "
cQuery += _cEnter + "		   CT2_ROTINA, CT2_SEQIDX"
cQuery += _cEnter + " FROM " + RetSqlName("CT2") + " (NOLOCK) "
cQuery += _cEnter + " INNER JOIN " + RetSqlName("CT1") + " CT1DEB (NOLOCK)"
cQuery += _cEnter + " ON CT1DEB.CT1_CONTA = CT2_DEBITO"
cQuery += _cEnter + " AND CT1DEB.D_E_L_E_T_ = ''"

cQuery += _cEnter + " INNER JOIN " + RetSqlName("CT1") + " CT1CRED (NOLOCK)"
cQuery += _cEnter + " ON CT1CRED.CT1_CONTA = CT2_CREDIT"
cQuery += _cEnter + " AND CT1CRED.D_E_L_E_T_ = ''"

cQuery += _cEnter + " LEFT JOIN " + RetSqlName("CTT") + " CTTCCD (NOLOCK) "
cQuery += _cEnter + " ON CT2_CCD = CTTCCD.CTT_CUSTO AND CTTCCD.D_E_L_E_T_ = '' "

cQuery += _cEnter + " LEFT JOIN " + RetSqlName("CTT") + " CTTCCC (NOLOCK)"
cQuery += _cEnter + " ON CT2_CCC = CTTCCC.CTT_CUSTO AND CTTCCC.D_E_L_E_T_ = '' "

cQuery += _cEnter + " WHERE " + RetSqlName("CT2") + ".D_E_L_E_T_ = '' AND"
cQuery += _cEnter + " ( CT2_DEBITO BETWEEN '" + mv_par03 +"' AND '" + mv_par04 +"' OR CT2_CREDIT BETWEEN '" + mv_par05 +"' AND '" + mv_par06 +"' ) AND"

/* cQuery += _cEnter + " ( CT2_DEBITO BETWEEN '4' AND '5ZZZZ' OR CT2_CREDIT BETWEEN '4' AND '5ZZZZ' ) AND */


cQuery += _cEnter + " LEFT(CT2_DATA,6) BETWEEN '" + _monthini + "' AND '" + _monthfim + "'"

cQuery += _cEnter + " ORDER BY CT2_VALOR, CT2_DATA "


dbUseArea(.T., 'TOPCONN', TCGenQry(,,cQuery), "TMP", .F., .T.)                    

	
DbGotop()

While TMP->(!EOF()) 
	aItem := Array(Len(aHeader)) 
	For nX := 1 to Len(aHeader) 
		IF aHeader[nX][2] == "C" 
			aItem[nX] := CHR(160)+TMP->&(aHeader[nX][1]) 
		ELSE 
			aItem[nX] := TMP->&(aHeader[nX][1]) 
		ENDIF 
	Next nX 

	AADD(aCols,aItem) 
	aItem := {} 
	TMP->(dbSkip()) 

End      

oGeraTxt:end()

Return



*****
Static function _pergunt()
**************************

_Ordem := 1
_param := '1'

dbSelectArea("SX1")
dbSetOrder(1)
dbSeek(cPerg+strzero(_ordem,2))
If Eof()
	RecLock("SX1",.T.)
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := strzero(_ordem,2)
Else
	RecLock("SX1",.F.)
End
SX1->X1_PERGUNT := "Da Data de Lancam. ?"
SX1->X1_VARIAVL := "mv_ch"+_param
SX1->X1_TIPO    := "D"
SX1->X1_TAMANHO := 8
SX1->X1_DECIMAL := 0
SX1->X1_GSC     := "G"
SX1->X1_VAR01   := "mv_par" + strzero(_ordem,2)
SX1->X1_F3      := ""
MsUnLock()
dbCommit()
_Ordem++
_param := Soma1(_param)


dbSelectArea("SX1")
dbSetOrder(1)
dbSeek(cPerg+strzero(_ordem,2))
If Eof()
	RecLock("SX1",.T.)
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := strzero(_ordem,2)
Else
	RecLock("SX1",.F.)
End
SX1->X1_PERGUNT := "Ate Data do Lancam. ?"
SX1->X1_VARIAVL := "mv_ch"+_param
SX1->X1_TIPO    := "D"
SX1->X1_TAMANHO := 8
SX1->X1_DECIMAL := 0
SX1->X1_GSC     := "G"
SX1->X1_VAR01   := "mv_par" + strzero(_ordem,2)
SX1->X1_F3      := ""
MsUnLock()
dbCommit()
_Ordem++
_param := Soma1(_param)


dbSelectArea("SX1")
dbSetOrder(1)
dbSeek(cPerg+strzero(_ordem,2))
If Eof()
	RecLock("SX1",.T.)
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := strzero(_ordem,2)
Else
	RecLock("SX1",.F.)
End
SX1->X1_PERGUNT := "Da Conta DEBITO     ?"
SX1->X1_VARIAVL := "mv_ch"+_param
SX1->X1_TIPO    := "C"
SX1->X1_TAMANHO := 20
SX1->X1_DECIMAL := 0
SX1->X1_GSC     := "G"
SX1->X1_VAR01   := "mv_par" + strzero(_ordem,2)
SX1->X1_F3      := "CT1.1"
MsUnLock()
dbCommit()
_Ordem++
_param := Soma1(_param)
	                                                                          

dbSelectArea("SX1")
dbSetOrder(1)
dbSeek(cPerg+strzero(_ordem,2))
If Eof()
	RecLock("SX1",.T.)
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := strzero(_ordem,2)
Else
	RecLock("SX1",.F.)
End
SX1->X1_PERGUNT := "Ate Conta DEBITO     ?"
SX1->X1_VARIAVL := "mv_ch"+_param
SX1->X1_TIPO    := "C"
SX1->X1_TAMANHO := 20
SX1->X1_DECIMAL := 0
SX1->X1_GSC     := "G"
SX1->X1_VAR01   := "mv_par" + strzero(_ordem,2)
SX1->X1_F3      := "CT1.1"
MsUnLock()
dbCommit()
_Ordem++
_param := Soma1(_param)


dbSelectArea("SX1")
dbSetOrder(1)
dbSeek(cPerg+strzero(_ordem,2))
If Eof()
	RecLock("SX1",.T.)
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := strzero(_ordem,2)
Else
	RecLock("SX1",.F.)
End
SX1->X1_PERGUNT := "Da Conta CREDITO    ?"
SX1->X1_VARIAVL := "mv_ch"+_param
SX1->X1_TIPO    := "C"
SX1->X1_TAMANHO := 20
SX1->X1_DECIMAL := 0
SX1->X1_GSC     := "G"
SX1->X1_VAR01   := "mv_par" + strzero(_ordem,2)
SX1->X1_F3      := "CT1.1"
MsUnLock()
dbCommit()
_Ordem++
_param := Soma1(_param)
	                                                                          

dbSelectArea("SX1")
dbSetOrder(1)
dbSeek(cPerg+strzero(_ordem,2))
If Eof()
	RecLock("SX1",.T.)
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := strzero(_ordem,2)
Else
	RecLock("SX1",.F.)
End
SX1->X1_PERGUNT := "Ate Conta CREDITO    ?"
SX1->X1_VARIAVL := "mv_ch"+_param
SX1->X1_TIPO    := "C"
SX1->X1_TAMANHO := 20
SX1->X1_DECIMAL := 0
SX1->X1_GSC     := "G"
SX1->X1_VAR01   := "mv_par" + strzero(_ordem,2)
SX1->X1_F3      := "CT1.1"
MsUnLock()
dbCommit()
_Ordem++
_param := Soma1(_param)

	
Return(nil)
