#INCLUDE "rwmake.ch"
/*
*********************************************************************************
***Programa  ³ RFATR09  ³ Autor ³ Eduardo Marcolongo      ³ Data ³ 30/07/2009 ***
*********************************************************************************
***Descricao ³ Demonstrativo de Resultado                                     ***
*********************************************************************************
***Uso       ³ Sangrila             Solicitante: sra.Adriana                  ***
*********************************************************************************
***             ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL              ***
*********************************************************************************
***Programador   ³  Data  ³              Motivo da Alteracao                  ***
*********************************************************************************
***                															  **
*********************************************************************************
*/
User Function RFATR09

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Demonstrativo de Resultados"
Local cPict          := ""
Local titulo         := "Demonstrativo de Resultados"
Local nLin         	 := 80
Local Cabec1       	 := "Data          Recebidos       Pagos        ICMS    IPI   ST"
Local Cabec2       	 := ""
Local imprime      	 := .T.
Local aOrd 			 := ""//{"Por Data","Por Cliente","Por Natureza","Por Vendedor"}

Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 220
Private tamanho      := "G"
Private nomeprog     := "RFATR09"
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "RFATR09"
Private cString 	 := ""
Private cPerg   	 := PadR("FATR09",Len(SX1->X1_GRUPO))
Private nOrdem

Private sTopo     := ""
Private dInicio   := ""
Private dFim      := ""

Private nRecebido  := 0
Private nPagos     := 0
Private nFaturado  := 0
Private nIcms      := 0
Private nIPI       := 0
Private nST        := 0
Private nFrete     := 0
Private nDevol     := 0
Private nInicial   := 0
Private nInicial2  := 0
Private nEntrada   := 0
Private nERecebido := 0
Private nEPago     := 0
Private nEICMS     := 0
Private nEIPI      := 0

Private nTRecebidos	:= 0
Private nTPagos		:= 0
Private nTMerc		:= 0
Private nTICMS		:= 0
Private nTIPI		:= 0
Private nTST		:= 0
Private nTFaturado	:= 0
Private nTEntrada	:= 0
Private nTERecebido := 0
Private nTEPago     := 0
Private nTEICMS     := 0
Private nTEIPI 		:= 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
validperg()
Pergunte(cPerg,.f.)

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)
If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)
If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)
nOrdem:= aReturn[8]
Cabec1       	 := ""
Cabec2       	 := "NATUREZA        "

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  23/05/05   º±±
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

Local _aTmp  := {}                    
AAdd ( _aTmp, {"DTREF" 		,"D", 08, 00} ) 
AAdd ( _aTmp, {"INICIAL" 	,"N", 12, 02} )
AAdd ( _aTmp, {"INICIAL2" 	,"N", 12, 02} )
AAdd ( _aTmp, {"TOTMERC" 	,"N", 12, 02} )  
AAdd ( _aTmp, {"RECEBIDO" 	,"N", 12, 02} ) 
AAdd ( _aTmp, {"PAGOS" 		,"N", 12, 02} )
AAdd ( _aTmp, {"ICMS"	 	,"N", 12, 02} )
AAdd ( _aTmp, {"IPI"	 	,"N", 12, 02} )
AAdd ( _aTmp, {"ST" 		,"N", 12, 02} )
AAdd ( _aTmp, {"FRETE" 		,"N", 12, 02} )
AAdd ( _aTmp, {"DEVOL"	 	,"N", 12, 02} )
AAdd ( _aTmp, {"ENTRADA"	,"N", 12, 02} )
AAdd ( _aTmp, {"ERECEBIDO"	,"N", 12, 02} )
AAdd ( _aTmp, {"EPAGO"		,"N", 12, 02} )
AAdd ( _aTmp, {"EICMS"	 	,"N", 12, 02} )
AAdd ( _aTmp, {"EIPI"	 	,"N", 12, 02} )

_cTable := CriaTrab(_aTmp,.T.)
DbUseArea(.T.,"DBFCDX",_cTable,"DTF",.T.,.F.)

dInicio := mv_par01
dFim    := mv_par02
saldo_inicial()
saldo_novo()

while dInicio <= dFim
	vlr_recebido() 
	vlr_pago()
	vlr_faturamento()
	vlr_icms()
	vlr_ipi()
	vlr_st()
	vlr_devolucao()         
	vlr_frete()
	vlr_entrada()
	vlr_eicms()
	vlr_eipi()
	vlr_erecebido()
	vlr_epago()

	dbSelectArea("DTF")    
	RecLock("DTF",.t.)
	DTF->DTREF    := dInicio
	DTF->INICIAL  := nInicial
	DTF->INICIAL2 := nInicial2
	DTF->RECEBIDO := nRecebido
	DTF->PAGOS    := nPagos
	DTF->TOTMERC  := nFaturado
	DTF->ICMS     := nIcms
	DTF->IPI      := nIpi
	DTF->ST       := nST
	DTF->FRETE    := nFrete
	DTF->DEVOL    := nDevol
	DTF->ENTRADA  := nEntrada
	DTF->ERECEBIDO:= nERecebido
	DTF->EPAGO    := nEPago
	DTF->EICMS    := nEIcms
	DTF->EIPI     := nEIPI
	MsUnLock()      
	dInicio := (dInicio+1)
EndDo
        
dbSelectArea("DTF")
SetRegua(RecCount())
dbGoTop()                   

While !EOF()

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
   If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 8
   Endif  

   if sTopo = ""            
      @nLin,02  PSAY "1.Saldo Inicial:"                 
      @nLin,30  PSAY nInicial  Picture "@E 999,999.99"               
      
      @nLin,100 PSAY "0.Saldo Inicial:"                       
      @nLin,130 PSAY nInicial2  Picture "@E 999,999.99"
      //@nLin,50  PSAY ("Periodo: "+mv_par01+" a "+mv_par02)

      nLin  := (nLin+1)
      @nLin,02  PSAY "Data"
      @nLin,22  PSAY "1.Recebidos"
      @nLin,37  PSAY "1.Pagos"
      @nLin,52  PSAY "1.Fat.Bruto"
      @nLin,67  PSAY "ICMS"
      @nLin,82  PSAY "IPI"
      @nLin,97  PSAY "Subs.Trib."
      @nLin,112 PSAY "ICMS Entr." 
      @nLin,127 PSAY "IPI Entr."
      @nLin,142 PSAY "Faturado"
      @nLin,157 PSAY "Recebidos"
      @nLin,172 PSAY "Entradas"                   
      @nLin,187 PSAY "Pagos"
      nLin  := (nLin+1)
      stopo := "S"
   endif   
   if ((DTF->RECEBIDO <> 0) .OR. (DTF->PAGOS <> 0) .OR. (DTF->TOTMERC <> 0) .OR.  ;
       (DTF->ICMS <> 0) .OR. (DTF->IPI <> 0) .OR. (DTF->ST <> 0) .OR. (DTF->FRETE <> 0) .OR.  ;
       (DTF->DEVOL <> 0) .OR. (DTF->ENTRADA <> 0) .OR. (DTF->EICMS <>0) .OR. (DTF->EIPI <> 0)) 
       @nLin,02  PSAY DTF->DTREF
       @nLin,20  PSAY DTF->RECEBIDO  Picture "@E 999,999.99"
       @nLin,35  PSAY DTF->PAGOS     Picture "@E 999,999.99"
       @nLin,50  PSAY DTF->TOTMERC   Picture "@E 999,999.99"
       @nLin,65  PSAY DTF->ICMS      Picture "@E 999,999.99"
       @nLin,80  PSAY DTF->IPI       Picture "@E 999,999.99"
       @nLin,95  PSAY DTF->ST        Picture "@E 999,999.99"
       @nLin,110 PSAY DTF->EICMS     Picture "@E 999,999.99"                                             
       @nLin,125 PSAY DTF->EIPI      Picture "@E 999,999.99"
       @nLin,140 PSAY ((DTF->TOTMERC-DTF->IPI-DTF->FRETE-DTF->ST)-DTF->DEVOL)  Picture "@E 999,999.99"
       @nLin,155 PSAY DTF->ERECEBIDO Picture "@E 999,999.99"       
       @nLin,170 PSAY DTF->ENTRADA   Picture "@E 999,999.99"
       @nLin,185 PSAY DTF->EPAGO     Picture "@E 999,999.99"

       //@nLin,200 PSAY DTF->FRETE    Picture "@E 999,999.99"
       //@nLin,215 PSAY DTF->DEVOL    Picture "@E 999,999.99"
       
          nTRecebidos := (nTRecebidos+DTF->RECEBIDO)
          nTPagos     := (nTPagos+DTF->Pagos)
          nTMerc      := (nTMerc+DTF->TOTMERC)
          nTICMS      := (nTICMS+DTF->ICMS)
          nTIPI       := (nTIPI+DTF->IPI)
          nTST        := (nTST+DTF->ST)
          nTFaturado  := (nTFaturado+((DTF->TOTMERC-DTF->IPI-DTF->FRETE-DTF->ST)-DTF->DEVOL))
          nTEntrada   := (nTEntrada+DTF->ENTRADA)
          nTERecebido := (nTERecebido+DTF->ERECEBIDO)       
          nTEPago     := (nTEPago+DTF->EPAGO)
          nTEICMS     := (nTEICMS+DTF->EICMS)
          nTEIPI      := (nTEIPI+DTF->EIPI)
          nLin := nLin + 1 // Avanca a linha de impressao
   endif   
   dbSkip() // Avanca o ponteiro do registro no arquivo
EndDo              

nLin := nLin + 1
@nLin,20  PSAY nTRECEBIDO  Picture "@E 999,999.99"
@nLin,35  PSAY nTPAGOS     Picture "@E 999,999.99"
@nLin,50  PSAY nTMERC      Picture "@E 999,999.99"
@nLin,65  PSAY nTICMS      Picture "@E 999,999.99"
@nLin,80  PSAY nTIPI       Picture "@E 999,999.99"
@nLin,95  PSAY nTST        Picture "@E 999,999.99" 
@nLin,110 PSAY nTEICMS     Picture "@E 999,999.99"
@nLin,125 PSAY nTEIPI      Picture "@E 999,999.99"
@nLin,140 PSAY nTFaturado  Picture "@E 999,999.99" 
@nLin,155 PSAY nTERecebido Picture "@E 999,999.99" 
@nLin,170 PSAY nTEntrada   Picture "@E 999,999.99" 
@nLin,185 PSAY nTEPago     Picture "@E 999,999.99"
                
nLin := nLin + 2
@nLin,02  PSAY "1.Saldo Final:"
@nLin,30  PSAY nInicial  Picture "@E 999,999.99"
nLin := nLin + 1      
@nLin,02  PSAY "Saldo Pagar ICMS:"
@nLin,30  PSAY (nTICMS-nTEICMS)  Picture "@E 999,999.99"
nLin := nLin + 1      
@nLin,02  PSAY "Saldo Pagar IPI:"
@nLin,30  PSAY (nTIPI-nTEIPI) Picture "@E 999,999.99"
nLin := nLin + 1      
@nLin,02  PSAY "Valor ST:"
@nLin,30  PSAY (nTST) Picture "@E 999,999.99"
nLin := nLin + 3      
                             
@nLin,02  PSAY "0.Saldo Final:"                   
@nLin,30  PSAY (nTERecebido-nTEPago)  Picture "@E 999,999.99"
nLin := nLin + 1      

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

dbCloseArea("DTF")
MS_FLUSH()

Return

Static Function vlr_recebido()
Local cQuery := ""                                    
Local dData  := dInicio
cQuery := "SELECT SUM(E5_VALOR) AS E5_VALOR FROM SE5010 WHERE E5_DATA = '"+DTOS(dData)+"' AND E5_RECPAG = 'R' "
cQuery += "AND E5_SITUACA IN ('','0','1','2','3,','4','5','6','7','F','G') "
cQuery += "AND D_E_L_E_T_ = '' AND E5_NATUREZ = '101' "
cQuery += "AND E5_PREFIXO IN ('1  ','NFE' AND E5_TIPODOC NOT IN ('JR','MT', 'J2','M2')"
cQuery := ChangeQuery(cQuery)
	
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"RC",.T.,.T.)
dbSelectArea("RC")
dbGoTop()        
nRecebido := RC->E5_VALOR
dbCloseArea("RC")
Return                                                  

Static Function vlr_pago()
Local cQuery := ""
Local dData  := dInicio
cQuery := "SELECT SUM(E5_VALOR) AS E5_VALOR FROM SE5010 WHERE E5_RECPAG = 'P' AND "
cQuery += "E5_DATA = '"+DTOS(dData)+"' AND E5_MOEDA = '' AND D_E_L_E_T_ = '' AND "
cQuery += "(E5_TIPODOC NOT IN ('DC','D2','JR','J2','TL','MT','M2','CM','C2','TR','TE','E2')) AND "
cQuery += "(E5_SITUACA NOT IN ('C','E','X')) AND ((E5_TIPODOC = 'CD' AND E5_VENCTO <= E5_DATA) OR (E5_TIPODOC <> 'CD')) AND "
cQuery += "E5_NATUREZ <> '20401' AND (E5_PREFIXO = '1' OR E5_PREFIXO = 'GPE' OR E5_PREFIXO = 'ICM' OR E5_PREFIXO = 'IPI') AND "
cQuery += "(E5_MOTBX = 'NOR')"
cQuery := ChangeQuery(cQuery)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"PG",.T.,.T.)
dbSelectArea("PG")
dbGoTop()
nPagos := PG->E5_VALOR
dbCloseArea("PG")
Return                                                                                      

Static Function vlr_faturamento()
Local cQuery := ""
Local dData  := dInicio
//A pedido da Adriana em 18.09.09 deixei igual ao estfat
cQuery := "SELECT Sum(F2_VALFAT) AS VALCONT "
cQuery += "FROM SF2010 WHERE F2_EMISSAO = '"+DTOS(dData)+"' AND "
cQuery += "F2_TIPO<>'B' And F2_TIPO<>'D' And F2_TIPO<>'C' And F2_TIPO<>'I' And F2_TIPO<>'P' And D_E_L_E_T_ <> '*'"
cQuery := ChangeQuery(cQuery)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"FA",.T.,.T.)
dbSelectArea("FA")
dbGoTop()
nFaturado := FA->ValCont
dbCloseArea("FA")
Return            

Static Function vlr_icms()
Local cQuery := ""
Local dData  := dInicio
cQuery := "SELECT SUM(F3_VALICM) AS VALICM FROM SF3010 WHERE F3_EMISSAO = '"+DTOS(dData)+"' "
cQuery += "AND F3_CFO > '4999' AND D_E_L_E_T_ = '' AND F3_OBSERV <> 'NF CANCELADA' AND (F3_SERIE = '1' OR F3_SERIE = 'NFE')"
cQuery := ChangeQuery(cQuery)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"IC",.T.,.T.)
dbSelectArea("IC")
dbGoTop()

nICMS     := IC->VALICM
dbCloseArea("IC")
Return

Static Function vlr_ipi()
Local cQuery := ""
Local dData  := dInicio
cQuery := "SELECT SUM(F3_VALIPI) AS VALIPI FROM SF3010 WHERE F3_EMISSAO = '"+DTOS(dData)+"' "
cQuery += "AND F3_OBSERV = '' AND F3_CFO > '4999' AND D_E_L_E_T_ = '' AND F3_OBSERV <> 'NF CANCELADA' AND (F3_SERIE = '1' OR F3_SERIE = 'NFE')"
cQuery := ChangeQuery(cQuery)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"IP",.T.,.T.)
dbSelectArea("IP")
dbGoTop()

nIPI     := IP->VALIPI
dbCloseArea("IP")
Return

Static Function vlr_st()
Local cQuery := ""
Local dData  := dInicio
cQuery := "SELECT SUM(F2_ICMSRET) AS ICMSRET FROM SF2010 WHERE F2_EMISSAO = '"+DTOS(dData)+"' AND (F2_SERIE = '1' OR F2_SERIE = 'NFE') "
cQuery += "AND F2_TIPO<>'B' And F2_TIPO<>'D' And F2_TIPO<>'C' And F2_TIPO<>'I' And F2_TIPO<>'P' AND D_E_L_E_T_ <> '*' "
cQuery += "GROUP BY F2_EMISSAO"
cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"ST",.T.,.T.)
dbSelectArea("ST")
dbGoTop()

nST     := ST->ICMSRET
dbCloseArea("ST")
Return                                        

Static Function vlr_devolucao()
Local cQuery := ""
Local dData  := dInicio
cQuery := "SELECT SUM(SD1.D1_TOTAL+SD1.D1_ICMSRET+SD1.D1_VALIPI+SD1.D1_VALFRE-SD1.D1_VALDESC)  AS TOTAL "
cQuery += "FROM SF1010 SF1 INNER JOIN SD1010 SD1 ON (SF1.F1_DOC = SD1.D1_DOC) "
cQuery += "WHERE SD1.D1_TIPO = 'D' AND SF1.F1_EMISSAO = '"+DTOS(dData)+"' AND SF1.D_E_L_E_T_ = '' AND SD1.D_E_L_E_T_ = '' "
cQuery += "GROUP BY SF1.F1_EMISSAO"
cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"DV",.T.,.T.)
dbSelectArea("DV")
dbGoTop()

nDevol := DV->TOTAL
dbCloseArea("DV")
Return                 

Static Function vlr_frete()
Local cQuery := ""
Local dData  := dInicio
cQuery := "SELECT Sum(F2_FRETE) As FRETE "
cQuery += "FROM SF2010 "
cQuery += "WHERE F2_EMISSAO = '"+DTOS(dData)+"' AND "
cQuery += "F2_TIPO<>'B' And F2_TIPO<>'D' And F2_TIPO<>'C' And F2_TIPO<>'I' And F2_TIPO<>'P' And "
cQuery += "D_E_L_E_T_ <> '*' "
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"FR",.T.,.T.)
dbSelectArea("FR")
dbGoTop()

nFrete := FR->FRETE
dbCloseArea("FR")
Return

Static Function vlr_entrada()
Local cQuery := ""
Local dData  := dInicio
cQuery := "SELECT SUM(E5_VALOR) AS VALOR FROM SE5010 "
cQuery += "WHERE E5_DTDISPO = '"+DTOS(dData)+"' AND (E5_NATUREZ = '101' OR E5_NATUREZ = '102') AND D_E_L_E_T_ = '' "
cQuery += "AND E5_RECONC = 'x' AND E5_RECPAG = 'R'"
cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"EN",.T.,.T.)
dbSelectArea("EN")
dbGoTop()

nEntrada := EN->VALOR
dbCloseArea("EN")
Return

Static Function vlr_erecebido()
Local cQuery := ""
Local dData  := dInicio
cQuery := "SELECT SUM(E5_VALOR) AS VALOR FROM SE5010 "
cQuery += "WHERE E5_DTDISPO = '"+DTOS(dData)+"' AND (E5_NATUREZ <> '107') AND D_E_L_E_T_ = '' "
cQuery += "AND E5_RECONC = 'x' AND E5_RECPAG = 'R'"
cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"ER",.T.,.T.)
dbSelectArea("ER")
dbGoTop()

nERecebido := ER->VALOR
dbCloseArea("ER")
Return

Static Function vlr_epago()
Local cQuery := ""
Local dData  := dInicio
cQuery := "SELECT SUM(E5_VALOR) AS VALOR FROM SE5010 "
cQuery += "WHERE E5_DTDISPO = '"+DTOS(dData)+"' AND (E5_NATUREZ <> '80101') AND D_E_L_E_T_ = '' "
cQuery += "AND E5_RECONC = 'x' AND E5_RECPAG = 'P'"
cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"EP",.T.,.T.)
dbSelectArea("EP")
dbGoTop()

nEPago := EP->VALOR
dbCloseArea("EP")
Return

Static Function vlr_eicms()
Local cQuery := ""
Local dData  := dInicio
cQuery := "SELECT SUM(F3_VALICM) AS VALICM FROM SF3010 WHERE F3_EMISSAO = '"+DTOS(dData)+"' AND F3_CFO < '5000' "
cQuery += "AND F3_VALICM <> '0' AND D_E_L_E_T_ = '' AND F3_OBSERV <> 'NF CANCELADA'" 
cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"EC",.T.,.T.)
dbSelectArea("EC")
dbGoTop()

nEICMS     := EC->VALICM
dbCloseArea("EC")
Return

Static Function vlr_eipi()
Local cQuery := ""
Local dData  := dInicio
cQuery := "SELECT SUM(F3_VALIPI) AS VALIPI FROM SF3010 WHERE F3_EMISSAO = '"+DTOS(dData)+"' AND F3_CFO < '5000' "
cQuery += "AND F3_VALIPI <> '0' AND D_E_L_E_T_ = '' AND F3_OBSERV <> 'NF CANCELADA'"
cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"EP",.T.,.T.)
dbSelectArea("EP")
dbGoTop()

nEIPI     := EP->VALIPI
dbCloseArea("EP")
Return

Static Function saldo_inicial()
Local cQuery := ""
Local dData  := (dInicio-1)  
Local nSaldo1:= 0
Local nSaldo2:= 0    
cQuery := "SELECT E8_SALATUA FROM SE8010 "
cQuery += "WHERE E8_CONTA = '74950' "
cQuery += "AND E8_DTSALAT <= '"+DTOS(dData)+"' AND D_E_L_E_T_ = '' ORDER BY E8_DTSALAT DESC
cQuery := ChangeQuery(cQuery)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"SI",.T.,.T.)
dbSelectArea("SI")
DBGOTOP()

nSaldo1 := SI->E8_SALATUA
dbCloseArea("SI")          

cQuery := "SELECT E8_SALATUA FROM SE8010 "
cQuery += "WHERE E8_CONTA = '111228' "
cQuery += "AND E8_DTSALAT <= '"+DTOS(dData)+"' AND D_E_L_E_T_ = '' ORDER BY E8_DTSALAT DESC
cQuery := ChangeQuery(cQuery)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"SI",.T.,.T.)
dbSelectArea("SI")
DBGOTOP()

nSaldo2 := SI->E8_SALATUA
dbCloseArea("SI")        

nInicial := (nSaldo1+nSaldo2)  
Return 

Static Function saldo_novo()
Local cQuery := ""
Local cQuery2:= ""
Local dData  := (dInicio-1)  
cQuery := "SELECT A6_COD, A6_AGENCIA, A6_NUMCON FROM SA6010 WHERE D_E_L_E_T_ = ''"
cQuery := ChangeQuery(cQuery)
                                                         
dbCloseArea("BCO")                                                         
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"BCO",.T.,.T.)
dbSelectArea("BCO")

DBGOTOP()
Do While !BCO->(Eof())                                                                                             
   cQuery2 := "SELECT * FROM SE8010 WHERE E8_BANCO = '"+trim(BCO->A6_COD)+"' AND E8_AGENCIA = '"+trim(BCO->A6_AGENCIA)+"' AND E8_CONTA = '"+trim(BCO->A6_NUMCON)+"' AND "
   cQuery2 += "E8_DTSALAT <= '"+DTOS(dData)+"' AND D_E_L_E_T_ = '' ORDER BY E8_DTSALAT DESC"
   cQuery2 := ChangeQuery(cQuery2)
   dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery2),"SI2",.T.,.T.)
   dbSelectArea("SI2") 
   nInicial2 := nInicial2+SI2->E8_SALATUA
   dbCloseArea("SI2")          
   
   BCO->(dbSkip())
Enddo

dbCloseArea("BCO")          
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³VALIDPERG º Autor ³ AP5 IDE            º Data ³  13/04/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Verifica a existencia das perguntas criando-as caso seja   º±±
±±º          ³ necessario                                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ValidPerg

Local _sAlias := Alias()
Local aRegs := {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,10)

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
aAdd(aRegs,{cPerg,"01","Do Periodo         ?","Do Periodo         ?","Do Periodo         ?","mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Ate o Periodo      ?","Ate o Periodo      ?","Ate o Periodo      ?","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","Da Filial          ?","Da Filial          ?","Da Filial          ?","mv_ch3","C",02,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"04","Ate Filial         ?","Ate Filial         ?","Ate Filial         ?","mv_ch4","C",02,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"05","Da Natureza        ?","Da Natureza        ?","Da Natureza        ?","mv_ch5","C",06,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"06","Ate Natureza       ?","Ate Natureza       ?","Ate Natureza       ?","mv_ch6","C",06,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","",""})

For i := 1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next

dbSelectArea(_sAlias)

Return
