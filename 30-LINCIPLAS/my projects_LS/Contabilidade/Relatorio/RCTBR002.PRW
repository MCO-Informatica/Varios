#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ RCTBR002 บ Autor ณ Ricardo Felipelli  บ Data ณ  29/07/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Relatorio gerencial de despesas,                           บฑฑ
ฑฑบ          ณ Solicitante: joao mochizuki                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ mp8 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function RCTBR002

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Private oGeraTxt
Private cPerg       := Padr("CTBR02",len(SX1->X1_GRUPO)," ")
Private cString     := "CT2"    

_pergunt()

Pergunte(cPerg,.t.)
dbSelectArea("CT2")
dbSetOrder(1)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Montagem da tela de processamento.                                  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

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
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณ OKGERATXTบ Autor ณ AP5 IDE            บ Data ณ  29/07/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao chamada pelo botao OK na tela inicial de processamenบฑฑ
ฑฑบ          ณ to. Executa a geracao do arquivo texto.                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function OkGeraTxt

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Cria o arquivo texto                                                ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local aCabExcel     :={} 
Local aItensExcel   :={}

AADD(aCabExcel, {"CT2_FILIAL", "C",  02, 0 })
AADD(aCabExcel, {"CT2_DATA",   "D",  02, 0 })
AADD(aCabExcel, {"CT2_LOTE",   "C",  06, 0 })
AADD(aCabExcel, {"CT2_DOC",    "C",  06, 0 })
AADD(aCabExcel, {"CT2_DEBITO", "C",  20, 0 })
AADD(aCabExcel, {"CT2_CREDIT", "C",  20, 0 })
AADD(aCabExcel, {"CT2_VALOR",  "N",  17, 2 })
AADD(aCabExcel, {"CT2_HIST",   "C",  40, 0 })
AADD(aCabExcel, {"CT2_CCD",    "C",  09, 0 })
AADD(aCabExcel, {"CT2_CCC",    "C",  09, 0 })
AADD(aCabExcel, {"CT2_ROTINA", "C",  10, 0 })
AADD(aCabExcel, {"CT2_SEQIDX", "C",  10, 0 })

MsgRun("Favor Aguardar.....", "Selecionando os Registros",; 
	{|| GProcItens(aCabExcel, @aItensExcel)}) 

MsgRun("Favor Aguardar.....", "Exportando os Registros para o Excel",; 
	{||DlgToExcel({{"GETDADOS",; 
	"POSIวรO DE TอTULOS DE VENDOR NO PERอODO",; 
	aCabExcel,aItensExcel}})}) 

dbselectarea("TMP")
dbclosearea()
Return 



/*/ 
+----------------------------------------------------------------------
| Fun็ใo | GProcItens | Autor | Ricardo Felipelli   | Data | | 
+----------------------------------------------------------------------
| Uso | Curso ADVPL | 
+----------------------------------------------------------------------
/*/ 

Static Function GProcItens(aHeader, aCols) 

Local aItem 
Local nX 
                                                                            
_periodo  := "('" + strzero(month(mv_par01),2) + "'"
_monthini := month(mv_par01)
_monthfim := month(mv_par02)    
_monthatu := _monthini
while _monthatu < month(mv_par02)
	_monthatu ++
	_periodo += ",'"+strzero(_monthatu,2)+"'"
enddo   
_periodo += ")"
 
cQuery := " SELECT CT2_FILIAL, "         
cQuery += "        SUBSTRING(CT2_DATA,7,2)+'/'+SUBSTRING(CT2_DATA,5,2)+'/'+SUBSTRING(CT2_DATA,1,4) AS CT2_DATA, "
cQuery += "        CT2_LOTE, CT2_DOC, CT2_DEBITO, CT2_CREDIT, CT2_VALOR, CT2_HIST, CT2_CCD, CT2_CCC, CT2_ROTINA, CT2_SEQIDX "
cQuery += " FROM " + RetSqlName("CT2") + " (NOLOCK)"
cQuery += " WHERE D_E_L_E_T_ = '' AND "
cQuery += " ( CT2_DEBITO BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' OR "
cQuery += " CT2_CREDIT BETWEEN '" + MV_PAR05 + "' AND  '" + MV_PAR06 + "' ) AND "
cQuery += " ( CT2_DEBITO LIKE '5%' AND MONTH(CT2_DATA) IN "+_periodo+"  OR "
cQuery += " 	  CT2_DEBITO LIKE '4%' AND MONTH(CT2_DATA) IN "+_periodo+" OR "
cQuery += "       CT2_CREDIT LIKE '5%' AND MONTH(CT2_DATA) IN "+_periodo+" OR "
cQuery += "       CT2_CREDIT LIKE '4%' AND MONTH(CT2_DATA) IN "+_periodo+" )   "
cQuery += " ORDER BY CT2_DATA "                                                                     

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
SX1->X1_PERGUNT := "Ata Conta DEBITO     ?"
SX1->X1_VARIAVL := "mv_ch"+_param
SX1->X1_TIPO    := "C"
SX1->X1_TAMANHO := 20
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
SX1->X1_PERGUNT := "Da Conta CREDITO    ?"
SX1->X1_VARIAVL := "mv_ch"+_param
SX1->X1_TIPO    := "C"
SX1->X1_TAMANHO := 20
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
SX1->X1_PERGUNT := "Ata Conta CREDITO    ?"
SX1->X1_VARIAVL := "mv_ch"+_param
SX1->X1_TIPO    := "C"
SX1->X1_TAMANHO := 20
SX1->X1_DECIMAL := 0
SX1->X1_GSC     := "G"
SX1->X1_VAR01   := "mv_par" + strzero(_ordem,2)
SX1->X1_F3      := ""
MsUnLock()
dbCommit()
_Ordem++
_param := Soma1(_param)

	
Return(nil)
