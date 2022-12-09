#INCLUDE "rwmake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ                            
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ RFATR14  ³ Autor ³ Genilson Moreira Lucas  ³ Data ³ 27/07/2010 ³±±
±±³          ³          ³       ³ MVG Consultoria Ltda    ³      ³            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Relatorio de Faturamento por Estado x Representante            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³ Quebra por Estado					                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³             ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador   ³  Data  ³              Motivo da Alteracao                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³        ³                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RFATR14()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Relacao de Faturamento - Representante por Estado"
Local cPict          := ""
Local titulo         := "Relacao de Faturamento - Representante por Estado"
Local nLin         	 := 80
Local Cabec1       	 := ""
Local Cabec2       	 := ""
Local imprime      	 := .T.

Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 132
Private tamanho      := "M"
Private nomeprog     := "RFATR14"
Private nTipo        := 18
Private aOrd         := {"Por Estado"}
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "RFATR14"
Private cString 	 := "SF2"
Private cPerg   	 := PadR("FATR10",Len(SX1->X1_GRUPO))
Private nOrdem

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

_aRegs := {}

AAdd(_aRegs,{cPerg,"01","Data Inicial ?   ","Data Inicial ?   ","Data Inicial ?   ","mv_ch0","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","",""})
AAdd(_aRegs,{cPerg,"02","Data Final ?     ","Data Final ?     ","Data Final ?     ","mv_ch0","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","",""})
AAdd(_aRegs,{cPerg,"03","Do Grupo ?       ","Do Grupo ?     ? ","Do Grupo ?       ","mv_ch0","C",04,0,0,"G","","mv_par03","","","","","","","","","","","","","","SBM","","","","","","","","","","",""})
AAdd(_aRegs,{cPerg,"04","Ate o Grupo ?    ","Ate o Grupo ?    ","Ate o Grupo ?    ","mv_ch0","C",04,0,0,"G","","mv_par04","","","","","","","","","","","","","","SBM","","","","","","","","","","",""})
AAdd(_aRegs,{cPerg,"05","Do Produto ?     ","Do Produto ?     ","Do Produto ?     ","mv_ch0","C",15,0,0,"G","","mv_par05","","","","","","","","","","","","","","SB1","","","","","","","","","","",""})
AAdd(_aRegs,{cPerg,"06","Ate o Produto ?  ","Ate o Produto ?  ","Ate o Produto ?  ","mv_ch0","C",15,0,0,"G","","mv_par06","","","","","","","","","","","","","","SB1","","","","","","","","","","",""})
AAdd(_aRegs,{cPerg,"07","Do Estado ?      ","Do Estado ?      ","Do Estado ?      ","mv_ch0","C",02,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","",""})
AAdd(_aRegs,{cPerg,"08","Ate o Estado ?   ","Ate o Estado ?   ","Ate o Estado ?   ","mv_ch0","C",02,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","",""})
AAdd(_aRegs,{cPerg,"09","Do Vendedor ?    ","Do Vendedor ?    ","Do Vendedor ?    ","mv_ch0","C",06,0,0,"G","","mv_par09","","","","","","","","","","","","","","SA3","","","","","","","","","","",""})
AAdd(_aRegs,{cPerg,"10","Ate o Vendedor ? ","Ate o Vendedor ? ","Ate o Vendedor ? ","mv_ch0","C",06,0,0,"G","","mv_par10","","","","","","","","","","","","","","SA3","","","","","","","","","","",""})
AAdd(_aRegs,{cPerg,"11","Moeda ?		  ","Moeda ? 		  ","Moeda ? 		  ","mv_ch0","N",01,0,0,"C","","mv_par11","Real","Real","Real","Dolar","Dolar","Dolar","","","","","","","","","","","","","","","","","","",""})

ValidPerg(_aRegs,cPerg)

Pergunte(cPerg,.F.)

dbSelectArea(cString)
dbSetOrder(1)

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


Cabec1       	 := "REPRESENTANTE                    VALOR          VALOR          VALOR        COMISSAO"
Cabec2       	 := "                                 BRUTO          DEVOL          LIQUI        COMISSAO"

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


_nValBru := 0
_nValDev := 0
_nValLiq := 0 
_nValCom := 0
_tValBru := 0
_tValDev := 0
_tValLiq := 0
_tValCom := 0

titulo += Iif(MV_PAR11 == 1, " - Em Real"," - Em Dolar")
//----> POR ESTADO
BuscaEstado()	//----> query para busca dos dados de faturamento

dbSelectArea("QUERY")
SetRegua(RecCount())
dbGoTop()

While !Eof()
	
	If lAbortPrint
		@nLin,000		 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	If nLin > 70
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 9
	Endif
	
	If !Empty(aReturn[7]) .And. !&(aReturn[7])
		dbSelectArea("QUERY")
		dbSkip()
		Loop
	EndIf
	
	dbSelectArea("QUERY")
	_cEstado :=	QUERY->F2_EST
	@ nLin, 000		PSAY "Estado: "+_cEstado
	
	nLin++
	nLin++
	
	If nLin > 70
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 9
	Endif
	
	While Eof() == .f. .And. _cEstado	==	QUERY->F2_EST
		
		If nLin > 70
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 9
		Endif
		
		If !Empty(aReturn[7]) .And. !&(aReturn[7])
			dbSelectArea("QUERY")
			dbSkip()
			Loop
		EndIf
		
		dbSelectArea("QUERY") 
		 
		BuscaDevEst()	//----> query para busca dos dados de Devolução
		dbSelectArea("DEVOL")
			
		_cVendedor :=	QUERY->F2_VEND1
		
		@ nLin, 000		PSAY _cVendedor+" "+Posicione("SA3",1,xFilial("SA3")+_cVendedor,"A3_NREDUZ")
		@ nLin, pCol()+002	PSAY Iif(MV_PAR11 == 1,QUERY->D2_TOTAL,xMoeda(QUERY->D2_TOTAL,1,2))					Picture(PesqPict("SD2","D2_TOTAL"))
		@ nLin, pCol()+001	PSAY IIf(MV_PAR11 == 1,DEVOL->D1_TOTAL,xMoeda(DEVOL->D1_TOTAL,1,2))				Picture(PesqPict("SD2","D2_TOTAL"))
		@ nLin, pCol()+001	PSAY IIf(MV_PAR11 == 1,QUERY->D2_TOTAL-DEVOL->D1_TOTAL,xMoeda(QUERY->D2_TOTAL-DEVOL->D1_TOTAL,1,2))	Picture(PesqPict("SD2","D2_TOTAL"))
		        
		BuscaComissao()	//----> query para busca da comissão
		BuscaComDev()	//----> query para busca da comissão
	                          
		dbSelectArea("COMIS") 
		dbSelectArea("COMISDEV") 
		@ nLin, pCol()+002	PSAY Iif(MV_PAR11 == 1,COMIS->E3_COMIS - COMISDEV->E3_COMIS,xMoeda(COMIS->E3_COMIS - COMISDEV->E3_COMIS,1,2))	Picture(PesqPict("SD2","D2_TOTAL"))  
	     	
		nLin++

		_nValBru += QUERY->D2_TOTAL
		_nValDev += DEVOL->D1_TOTAL
		_nValLiq += QUERY->D2_TOTAL-DEVOL->D1_TOTAL
		_nValCom += COMIS->E3_COMIS - COMISDEV->E3_COMIS
		
		_tValBru += QUERY->D2_TOTAL
		_tValDev += DEVOL->D1_TOTAL
		_tValLiq += QUERY->D2_TOTAL - DEVOL->D1_TOTAL
		_tValCom += COMIS->E3_COMIS - COMISDEV->E3_COMIS
		dbSelectArea("DEVOL")
		dbCloseArea("DEVOL")
         
		dbSelectArea("COMIS")
		dbCloseArea("COMIS")
		
		dbSelectArea("COMISDEV")
		dbCloseArea("COMISDEV")
		
		dbSelectArea("QUERY")
		dbSkip()
	EndDo
	
	nLin++
	
	If nLin > 70
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 9
	Endif
	
	
	@ nLin, 000			PSAY "Total Estado: "
	@ nLin, pCol()+010	PSAY IIf(MV_PAR11 == 1,_nValBru,xMoeda(_nValBru,1,2))			Picture(PesqPict("SD2","D2_TOTAL"))
	@ nLin, pCol()+001	PSAY Iif(MV_PAR11 == 1,_nValDev,xMoeda(_nValDev,1,2))			Picture(PesqPict("SD2","D2_TOTAL"))
	@ nLin, pCol()+001	PSAY IIf(MV_PAR11 == 1,_nValLiq,xMoeda(_nValLiq,1,2))			Picture(PesqPict("SD2","D2_TOTAL"))
	@ nLin, pCol()+002	PSAY Iif(MV_PAR11 == 1,_nValCom,xMoeda(_nValCom,1,2))			Picture(PesqPict("SD2","D2_TOTAL"))
	
	nLin++
	
	@ nLin, 000 PSAY __PrtThinLine()
	
	nLin++
	
	If nLin > 70
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 9
	Endif
	
	
	_nValBru := 0
	_nValDev := 0
	_nValLiq := 0
	_nValCom := 0
	
	dbSelectArea("QUERY")
	
EndDo

nLin++

If nLin > 70
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	nLin := 9
Endif


@ nLin, 000			PSAY "Total Geral: "
@ nLin, pCol()+011	PSAY IIf(MV_PAR11 == 1,_tValBru,xMoeda(_tValBru,1,2))			Picture(PesqPict("SD2","D2_TOTAL"))
@ nLin, pCol()+001	PSAY Iif(MV_PAR11 == 1,_tValDev,xMoeda(_tValDev,1,2))			Picture(PesqPict("SD2","D2_TOTAL"))
@ nLin, pCol()+001	PSAY Iif(MV_PAR11 == 1,_tValLiq,xMoeda(_tValLiq,1,2))			Picture(PesqPict("SD2","D2_TOTAL"))
@ nLin, pCol()+002	PSAY Iif(MV_PAR11 == 1,_tValCom,xMoeda(_tValCom,1,2))			Picture(PesqPict("SD2","D2_TOTAL"))

dbSelectArea("QUERY")
dbCloseArea("QUERY")

SET DEVICE TO SCREEN

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return

Static Function BuscaEstado()

Local _cQuery := ""

_cQuery += "SELECT SF2010.F2_EST, SF2010.F2_VEND1, SUM(SD2010.D2_TOTAL) AS D2_TOTAL "
_cQuery += "FROM SD2010 INNER JOIN "
_cQuery += "SB1010 ON SD2010.D2_COD = SB1010.B1_COD INNER JOIN "
_cQuery += "SF4010 ON SD2010.D2_TES = SF4010.F4_CODIGO INNER JOIN "
_cQuery += "SF2010 ON SD2010.D2_FILIAL = SF2010.F2_FILIAL AND SD2010.D2_CLIENTE = SF2010.F2_CLIENTE AND "
_cQuery += "SD2010.D2_LOJA = SF2010.F2_LOJA AND SD2010.D2_DOC = SF2010.F2_DOC AND "
_cQuery += "SD2010.D2_SERIE = SF2010.F2_SERIE INNER JOIN "
_cQuery += "SA3010 ON SF2010.F2_VEND1 = SA3010.A3_COD "
_cQuery += "WHERE(SD2010.D_E_L_E_T_ = '') AND (SB1010.D_E_L_E_T_ = '') AND (SA3010.D_E_L_E_T_ = '') AND (SF2010.D_E_L_E_T_ = '') AND "
_cQuery += "(SF4010.D_E_L_E_T_ = '') "
_cQuery += "AND (SD2010.D2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"')"
_cQuery += "AND (SD2010.D2_COD BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"')"
_cQuery += "AND (SB1010.B1_GRUPO BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"')"
_cQuery += "AND (SF2010.F2_EST BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"')"
_cQuery += "AND (SF2010.F2_VEND1 BETWEEN '"+MV_PAR09+"' AND '"+MV_PAR10+"')"   
_cQuery += "AND SF4010.F4_DUPLIC = 'S' AND SF2010.F2_TIPO = 'N' "
_cQuery += "GROUP BY SF2010.F2_EST, SF2010.F2_VEND1 "
_cQuery += "ORDER BY SF2010.F2_EST, SF2010.F2_VEND1 "

_cQuery	:=	ChangeQuery(_cQuery)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"QUERY",.T.,.T.)

TcSetField("QUERY","D2_TOTAL"  ,"N",TamSX3("D2_TOTAL"  )[1],TamSX3("D2_TOTAL"  )[2])
TcSetField("QUERY","D2_QUANT"  ,"N",TamSX3("D2_QUANT"  )[1],TamSX3("D2_QUANT"  )[2])

Return

// ------->> BUSCA COMISSÃO
Static Function BuscaComissao()

Local _cQuery := " "
_cQuery += " SELECT SE3010.E3_VEND, SUM(SE3010.E3_COMIS) AS E3_COMIS "
_cQuery += " FROM SE3010 INNER JOIN "
_cQuery += " SF2010 ON SF2010.F2_DOC = SE3010.E3_NUM AND SF2010.F2_CLIENTE = SE3010.E3_CODCLI AND "
_cQuery += " SF2010.F2_LOJA = SE3010.E3_LOJA AND SF2010.F2_VEND1 = SE3010.E3_VEND AND " 
_cQuery += " SF2010.F2_SERIE = SE3010.E3_PREFIXO "
_cQuery += " WHERE (SE3010.D_E_L_E_T_ = '') AND (SF2010.D_E_L_E_T_ = '') AND SE3010.E3_COMIS > 0  AND "
_cQuery += " (SE3010.E3_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"') AND "
_cQuery += " SF2010.F2_EST = '"+QUERY->F2_EST +"' AND SE3010.E3_VEND = '"+QUERY->F2_VEND1 +"' "
_cQuery += " GROUP BY SE3010.E3_VEND "
_cQuery += " ORDER BY SE3010.E3_VEND "

_cQuery	:=	ChangeQuery(_cQuery)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"COMIS",.T.,.T.)
TcSetField("COMIS","E3_COMIS"  ,"N",TamSX3("E3_COMIS")[1],TamSX3("E3_COMIS")[2])

Return    

Static Function BuscaComDev()

Local _cQuery := " "
_cQuery += " SELECT SE3010.E3_VEND, SUM(SE3010.E3_COMIS) AS E3_COMIS "
_cQuery += " FROM SE3010 INNER JOIN "
_cQuery += " SF2010 ON SF2010.F2_DOC = SE3010.E3_NUM AND SF2010.F2_CLIENTE = SE3010.E3_CODCLI AND "
_cQuery += " SF2010.F2_LOJA = SE3010.E3_LOJA AND SF2010.F2_VEND1 = SE3010.E3_VEND AND " 
_cQuery += " SF2010.F2_SERIE = SE3010.E3_PREFIXO "
_cQuery += " WHERE (SE3010.D_E_L_E_T_ = '') AND (SF2010.D_E_L_E_T_ = '') AND SE3010.E3_COMIS < 0  AND "
_cQuery += " (SE3010.E3_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"') AND "
_cQuery += " SF2010.F2_EST = '"+QUERY->F2_EST +"' AND SE3010.E3_VEND = '"+QUERY->F2_VEND1 +"' "
_cQuery += " GROUP BY SE3010.E3_VEND "
_cQuery += " ORDER BY SE3010.E3_VEND "

_cQuery	:=	ChangeQuery(_cQuery)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"COMISDEV",.T.,.T.)
TcSetField("COMISDEV","E3_COMIS"  ,"N",TamSX3("E3_COMIS")[1],TamSX3("E3_COMIS")[2])

Return

Static Function BuscaDevEst()

Local _cQuery := ""

_cQuery += "SELECT SF1010.F1_EST, SUM(SD1010.D1_TOTAL - SD1010.D1_VALDESC) AS D1_TOTAL "
_cQuery += "FROM SD1010 INNER JOIN "
_cQuery += "SD2010 ON SD1010.D1_NFORI = SD2010.D2_DOC AND SD1010.D1_SERIORI = SD2010.D2_SERIE AND " 
_cQuery += "SD1010.D1_FILIAL = SD2010.D2_FILIAL AND SD1010.D1_FORNECE = SD2010.D2_CLIENTE AND " 
_cQuery += "SD1010.D1_LOJA = SD2010.D2_LOJA AND "
_cQuery += "SD1010.D1_ITEMORI = SD2010.D2_ITEM INNER JOIN "

_cQuery += "SF4010 ON SD1010.D1_TES = SF4010.F4_CODIGO INNER JOIN "

_cQuery += "SF2010 ON SD2010.D2_FILIAL = SF2010.F2_FILIAL AND SD2010.D2_DOC = SF2010.F2_DOC AND "
_cQuery += "SD2010.D2_SERIE = SF2010.F2_SERIE INNER JOIN "    

_cQuery += "SF1010 ON SD1010.D1_FILIAL = SF1010.F1_FILIAL AND SF1010.F1_DOC = SD1010.D1_DOC AND SD1010.D1_SERIE = SF1010.F1_SERIE AND "
_cQuery += "SD1010.D1_FORNECE = SF1010.F1_FORNECE AND SD1010.D1_LOJA = SF1010.F1_LOJA "

_cQuery += "WHERE (SF4010.D_E_L_E_T_ = '') AND (SD1010.D_E_L_E_T_ = '') AND (SD2010.D_E_L_E_T_ = '') AND (SF1010.D_E_L_E_T_ = '') AND "
_cQuery += "(SF2010.D_E_L_E_T_ = '') AND (SD1010.D1_DTDIGIT BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"') AND "
_cQuery += "SF1010.F1_EST = '"+QUERY->F2_EST+"' AND SF2010.F2_VEND1 = '"+QUERY->F2_VEND1+"' AND "
_cQuery += "SD1010.D1_TIPO = 'D' "     
_cQuery += "GROUP BY SF1010.F1_EST, SF2010.F2_VEND1 "
_cQuery += "ORDER BY SF1010.F1_EST, SF2010.F2_VEND1 "

_cQuery	:=	ChangeQuery(_cQuery)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"DEVOL",.T.,.T.)

Return                                           
