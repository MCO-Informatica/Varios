 #INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍ»±±
±±º Programa:  ³ LISFIN01 Autor: ³ Marcia H. Duque  º Data: ³ abr/2010 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Descricao: ³ Relatório Diário trimestral por Natureza.          º±±
±±º            ³                                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Uso:       ³                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function LISFIN01()

// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// ³ Declaracao de Variaveis ³
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local _cArq1,_cInd1,_cArq2,_cInd2
Local _aStru1       := { }
Local _aStru2       := { }
Local aOrd          := { }
Local cDesc1        := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2        := "de acordo com os parametros informados pelo usuario."
Local cDesc3        := "FLUXO DE PAGAMENTOS"
Local cPict           := " "
Local titulo           := "FLUXO DE PAGAMENTOS: "
Local nLin            := 80
Local Cabec1       := " "
Local Cabec2       := " "
Local imprime      := .t.

Private cString
Private CbTxt       := " "
Private lEnd        := .f.
Private lAbortPrint := .f.
Private limite      := 132
Private tamanho     := "G"
Private nomeprog    := "LISFIN01"
//Private nTipo       := 15
Private aReturn     := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey    := 0
Private cPerg       := "LISF01"
Private cbtxt       := Space(10)
Private cbcont      := 0
Private contfl      := 1
Private m_pag       := 1
Private wnrel       := "LISFIN01
Private cString     := "SE1"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa os codigos de caracter Comprimido/Normal da impressora ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nTipo  := IIF(aReturn[4]==1,15,18)

//ValidPerg()

Pergunte(cPerg,.f.)

// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// ³ Monta a interface padrao com o usuario... ³
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
EndIf

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
EndIf

nTipo := If(aReturn[4]==1,15,18)

// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// ³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

RptStatus({|| Runreport()})
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º Função:    ³ RUNREPORT º Autor: ³  Data: ³ 16/09/2002 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Descrição: ³ prepara os dados do SE2 para impressão            º±±
±±º            ³ RPTSTATUS monta a janela com a regua de processa- º±±
±±º            ³ mento.                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Uso:       ³ Programa principal                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

//Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)
Static Function RunReport()

Local nOrdem
cIndE2	:=IndexKey()
nlin := 80

SetRegua(LastRec())
dbSelectArea("SE1")
cQuery :=  "SELECT * FROM " + RetSqlName("SE1") + " WHERE"
cQuery += " E1_FILIAL>= '" + mv_par01 + "' AND E1_FILIAL <= '" + mv_par02 + "'"
//cQuery += " AND E1_VENCREA >= '" + DTOS(mv_par03) + "'"
cQuery += " AND E1_EMISSAO <= '" + DTOS(mv_par03) + "'"
cQuery += " AND E1_NATUREZ >= '" + mv_par05 + "' AND E1_NATUREZ <= '" + mv_par06 + "'"
cQuery += " AND E1_XCC >= '" + mv_par07 + "' AND E1_XCC <= '" + mv_par08 + "'"
cQuery += " AND D_E_L_E_T_ <> '*'"
cQuery += " ORDER BY " + "E1_XCC + E1_NATUREZ"

//dbSelectArea("SE1")
//cQuery :=  "SELECT E1_FILIAL, E1_VENCREA, E1_VALOR, E1_SALDO, E1_NATUREZ, E1_XCC, E1_NUM, E1_PREFIXO, E5_PREFIXO, E5_XCC, E5_NUM, E5_VALOR, E5_TIPODOC"
//cQuery += " FROM " + RetSqlName("SE1") +" AS SE1"
//cQuery += " INNER JOIN "+ RetSqlName("SE5") +" ON E1_PREFIXO = E5_NUMERO AND E1_NUM = E5_NUMERO WHERE"
//cQuery += " E1_FILIAL>= '" + mv_par01 + "' AND E1_FILIAL <= '" + mv_par02 + "'"
//cQuery += " AND E1_VENCREA >= '" + DTOS(mv_par03) + "'"
//cQuery += " AND E1_NATUREZ >= '" + mv_par05 + "' AND E1_NATUREZ <= '" + mv_par06 + "'"
//cQuery += " AND E1_XCC >= '" + mv_par07 + "' AND E1_XCC <= '" + mv_par08 + "'"
//cQuery += " AND SE1.D_E_L_E_T_ <> '*'"
//cQuery += " ORDER BY " + "E1_NATUREZ"

cQuery := ChangeQuery(cQuery)
dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TRA', .T., .T.)

dbSelectArea("SE2")
cQuery1 :=  "SELECT * FROM " + RetSqlName("SE2") + " WHERE"
cQuery1 += " E2_FILIAL>= '" + mv_par01 + "' AND E2_FILIAL <= '" + mv_par02 + "'"
//cQuery1 += " AND E2_VENCREA >= '" + DTOS(mv_par03) + "'"             
cQuery1 += " AND E2_EMISSAO <= '" + DTOS(mv_par04) + "'"             
cQuery1 += " AND E2_NATUREZ >= '" + mv_par05 + "' AND E2_NATUREZ <= '" + mv_par06 + "'"
cQuery1 += " AND E2_XCC >= '" + mv_par07 + "' AND E2_XCC <= '" + mv_par08 + "'"
cQuery1 += " AND D_E_L_E_T_ <> '*'"
cQuery1 += " ORDER BY " + "E2_XCC + E2_NATUREZ"

cQuery1 := ChangeQuery(cQuery1)
dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery1), 'TRB', .T., .T.)

nMes01	:= month(mv_par03)
nMes02	:= month(mv_par03)+1
nMes03	:= month(mv_par03)+2                                                                         ´
nAnoIni	:= Year(mv_par03)
NAnoFim	:= Year(mv_par04)

//                                                                                                            1         1         1         1
//                              1                2                3                4                5               6                7               8                9                 0                1              2                3
//               123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
//               XXX XXXXXXXXXXXXXXXXXXXXXXXX    |99.999.999,99 99.999.999,99 99.999.999,99 | 99.999.999,99 99.999.999,99 99.999.999,99 | 99.999.999,99 99.999.999,99 99.999.999,99 | 99.999.999,99 99.999.999,99 99.999.999,99
Cabec1 := "Natureza                                               "+Upper(MesExtenso(strzero(nMes01,2)))+space(33)
Cabec1 := Cabec1 + Upper(MesExtenso(strzero(nMes02,2)))+space(30)
Cabec1 := Cabec1 + Upper(MesExtenso(strzero(nMes03,2)))
Cabec1 := Cabec1 + "Proximos                                  "
Cabec2 := 				"                                       ABERTO          PAGO        SALDO         ABERTO          PAGO         SALDO        ABERTO         PAGO         SALDO        ABERTO          PAGO         SALDO          "
titulo :=     				"Fluxo de Pagamentos por Natureza  - Periodo: de " + dtoc(mv_par03) + " Ate "+ dtoc(mv_par04)
//Upper(MesExtenso(Month(mv_par02)))+" / "+Str(Year(mv_par02),4)

SetRegua(LastRec())
aPrevis1 := 0
aPrevis2 := 0
aPrevis3 := 0
aPrevis4 := 0
aRealiz1 := 0
aRealiz2 := 0
aRealiz3 := 0
aRealiz4 := 0
aAberto1 := 0
aAberto2 := 0
aAberto3 := 0
aAberto4 := 0
tPrevis1 := 0
tPrevis2 := 0
tPrevis3 := 0
tPrevis4 := 0
tRealiz1 := 0
tRealiz2 := 0
tRealiz3 := 0
tRealiz4 := 0
tAberto1 := 0
tAberto2 := 0
tAberto3 := 0
tAberto4 := 0

//total Geral.
tgPrevis1 := 0
tgPrevis2 := 0
tgPrevis3 := 0
tgPrevis4 := 0
tgRealiz1 := 0
tgRealiz2 := 0
tgRealiz3 := 0
tgRealiz4 := 0
tgAberto1 := 0
tgAberto2 := 0
tgAberto3 := 0
tgAberto4 := 0

Aprevi := 0
AReal := 0
AAber := 0
nNaturez := {}
nNat := ""
nCC := ""
Somareal := 0
SomaDesc := 0
SomaJur := 0
SomaEst := 0
SomaTot := 0                  
nNatE5 	:= 0

DbSelectArea("TRB")
DbGoTop()

SetRegua(RecCount())

ncol := 001
nCC := TRB->E2_XCC
While !Eof()
	IncRegua()

	If lAbortPrint
		@ nLin , 000 Psay "*** CANCELADO PELO OPERADOR ***"
		Exit
	EndIf
	
	If nLin > 55
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nlin := 10
	EndIf
	
	If E2_NATUREZ <= mv_par05 .and. E2_NATUREZ >= mv_par06
		dbSkip()
		Loop
	Endif
	
	ncol := 001
	nCC := TRB->E2_XCC
	nlin := nlin + 1
	@ nlin , ncol PSAY "Obra : " + Transform(nCC,"@!")   //Projeto
	nlin := nlin + 1
	//nNat := TRB->E2_NATUREZ
	
	//Do while !eof() .and. TRB->E2_FILIAL >= mv_par01 .and. TRB->E2_FILIAL <= MV_PAR02 .and. TRB->E2_VENCREA >= DTOS(MV_PAR03)   .AND. nCC == TRB->E2_XCC  //.AND. E2_VENCREA <= DTOS(MV_PAR04)
	Do while !eof() .and. TRB->E2_FILIAL >= mv_par01 .and. TRB->E2_FILIAL <= MV_PAR02 .and. TRB->E2_EMISSAO <= DTOS(MV_PAR04)   .AND. nCC == TRB->E2_XCC    //.AND. E2_VENCREA <= DTOS(MV_PAR04)
		
		nNat := TRB->E2_NATUREZ
		Do While !eof() .and. TRB->E2_FILIAL >= mv_par01 .and. TRB->E2_FILIAL <= MV_PAR02 .and. TRB->E2_EMISSAO <= DTOS(MV_PAR04)   .AND. nCC == TRB->E2_XCC  .AND. nNat == TRB->E2_NATUREZ

			_cData		:=  TRB->E2_VENCREA
			_cFilial		:=  TRB->E2_FILIAL
			_cprefixo	:= TRB->E2_PREFIXO
			_cNumero	:= TRB->E2_NUM
			_cParcela	:= TRB->E2_PARCELA
			_cTipo 		:= TRB->E2_TIPO
			_cFornece	:= TRB->E2_FORNECE
			_cLoja		:= TRB->E2_LOJA
			_cAlias 		:= "TRB"
			_cBaixa		:= TRB->E2_BAIXA
			
			iF !Empty(_cBaixa )
				dbSelectArea("SE5")
				dbsetorder(7)
				SE5->(dbSeek(XFILIAL("SE5")+_CPREFIXO+_cNUMERO+_cParcela+_cTipo+_cFornece + _cLoja))
					IF Found()           
					nNate5 := nNat
					pegaReal()
				Endif
			Else
				SomaTot := 0
			Endif		
			
			dbSelectArea("TRB")
		    
				Do Case
					Case SUBSTR(TRB->E2_VENCREA,5,2) <= strzero(nMes01,2) //.AND. substr(TRB->E2_VENCREA,1,4) <= STRZERO(NAnoFim,4)
					aPrevis1 := aprevis1 + TRB->E2_VALOR
					aRealiz1 := aRealiz1 + somaTot  //SE5->E5_VALOR //E2_SALDO
					aAberto1 := aAberto1 + TRB->E2_SALDO   
				Case SUBSTR(TRB->E2_VENCREA,5,2) == strzero(nMes02,2)
					aPrevis2 := aPrevis2 + TRB->E2_VALOR
					aRealiz2 := aRealiz2 + somaTot     // SE5->E5_SALDO
					aAberto2 := aAberto2 + TRB->E2_SALDO
				Case SUBSTR(TRB->E2_VENCREA,5,2) == strzero(nMes03,2)
					aPrevis3 := aPrevis3 + TRB->E2_VALOR
					aRealiz3 := aRealiz3 + SomaTot  //E5_SALDO
					aAberto3 := aAberto3 + TRB->E2_SALDO
				Case SUBSTR(TRB->E2_VENCREA,5,2) > strzero(nMes03,2)
					aPrevis4 := aPrevis4 + TRB->E2_VALOR
					aRealiz4 := aRealiz4 + somaTot //E5_SALDO
					aAberto4 := aAberto4 + TRB->E2_SALDO
			Endcase
	
			dbSelectArea("TRB")
			TRB->(dbSkip())
		Enddo	
		//Endif
		
		ncol := 001
		@ nLin ,ncol PSAY Transform(nNat, "@!")         //natureza
		dbSelectArea("SED")
		DbSeek(Xfilial("SED")+nNat)
		nDescr := SED->ED_DESCRIC
		@ nLin, ncol+10 psay substr(nDescr,1,15)
		
		dbSelectArea("TRB")
		For i:=1 to 4 // len(nNaturez)
			
			If lAbortPrint
				@ nLin , 000 Psay "*** CANCELADO PELO OPERADOR ***"
				Exit
			EndIf
			
			If nLin > 55
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nlin := 10
			EndIf
			
			ncol := ncol + 30
			@ nlin  ,ncol PSAY Transform(Aprevis1,"@E 999,999,999.99")       //"apreviS"+alltrim(str(i))
			ncol := ncol + 14
			@ nLin ,ncol PSAY Transform(aRealiz1,"@E 999,999,999.99")   //"aRealiz"+alltrim(str(i))
			ncol := ncol + 14
			@ nlin  ,ncol PSAY Transform(aAberto1,"@E 999,999,999.99")    //"aAberto"+alltrim(str(i))
			ncol := ncol + 14
			@ nlin  ,ncol PSAY Transform(Aprevis2,"@E 999,999,999.99")       //"apreviS"+alltrim(str(i))
			ncol := ncol + 14
			@ nLin ,ncol PSAY Transform(aRealiz2,"@E 999,999,999.99")   //"aRealiz"+alltrim(str(i))
			ncol := ncol + 14
			@ nlin  ,ncol PSAY Transform(aAberto2,"@E 999,999,999.99")    //"aAberto"+alltrim(str(i))
			ncol := ncol + 14
			@ nlin  ,ncol PSAY Transform(Aprevis3,"@E 999,999,999.99")       //"apreviS"+alltrim(str(i))
			ncol := ncol + 14
			@ nLin ,ncol PSAY Transform(aRealiz3,"@E 999,999,999.99")   //"aRealiz"+alltrim(str(i))
			ncol := ncol + 14
			@ nlin  ,ncol PSAY Transform(aAberto3,"@E 999,999,999.99")    //"aAberto"+alltrim(str(i))
			ncol := ncol + 14
			@ nlin  ,ncol PSAY Transform(Aprevis4,"@E 999,999,999.99")       //"apreviS"+alltrim(str(i))
			ncol := ncol + 14
			@ nLin ,ncol PSAY Transform(aRealiz4,"@E 999,999,999.99")   //"aRealiz"+alltrim(str(i))
			ncol := ncol + 14
			@ nlin  ,ncol PSAY Transform(aAberto4,"@E 999,999,999.99")    //"aAberto"+alltrim(str(i))
			ncol := ncol + 14
			//@ nlin  ,ncol PSAY Transform("aAberto"+alltrim(str(i)),"@E 999,999,999.99")    //"aAberto"+alltrim(str(i))
			
		Next
		nLin := nLin + 1
		//Soma totais
		tPrevis1 	:= tPrevis1   + aPrevis1
		tRealiz1 	:= tRealiz1   + aRealiz1
		tAberto1 	:= tAberto1   + aAberto1
		tPrevis2  	:= tPrevis2    + aPrevis2
		tRealiz2  	:= tRealiz2    + aRealiz2
		tAberto2  	:= tAberto2    + aAberto2
		tPrevis3    := tPrevis3     + aPrevis3
		tRealiz3		:= tRealiz3     + aRealiz3
		tAberto3	:= tAberto3    + aAberto3
		tPrevis4		:=	tPrevis4     + aPrevis4
		tRealiz4		:= tRealiz4     + aRealiz4
		tAberto4	:= tAberto4     + aAberto4
	
	    //soma total geral 
   		tgPrevis1 		:= tgPrevis1   + aPrevis1
		tgRealiz1 		:= tgRealiz1   + aRealiz1
		tgAberto1 		:= tgAberto1   + aAberto1
		tgPrevis2  		:= tgPrevis2    + aPrevis2
		tgRealiz2  		:= tgRealiz2    + aRealiz2
		tgAberto2  	:= tgAberto2    + aAberto2
		tgPrevis3    	:= tgPrevis3     + aPrevis3
		tgRealiz3		:= tgRealiz3     + aRealiz3
		tgAberto3		:= tgAberto3    + aAberto3
		tgPrevis4		:=	tgPrevis4     + aPrevis4
		tgRealiz4		:= tgRealiz4     + aRealiz4
		tgAberto4		:= tgAberto4     + aAberto4

		aPrevis1 := 0
		aPrevis2 := 0
		aPrevis3 := 0
		aPrevis4 := 0
		aPrevisT := 0
		aRealiz1 := 0
		aRealiz2 := 0
		aRealiz3 := 0
		aRealiz4 := 0
		aRealizT := 0
		aAberto1 := 0
		aAberto2 := 0
		aAberto3 := 0
		aAberto4 := 0
		aAbertoT := 0
	Enddo
	// Imprime Total por Obra
	If lAbortPrint
		@ nLin , 000 Psay "*** CANCELADO PELO OPERADOR ***"
		Exit
	EndIf
		
	If nLin > 55
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nlin := 10
	EndIf
	
	ncol := 001                                                                                     
	@ nlin, ncol PSAY "total Obra: "
	ncol := ncol + 30
	@ nlin  ,ncol PSAY Transform(tprevis1,"@E 999,999,999.99")       //"apreviS"+alltrim(str(i))
	ncol := ncol + 14
	@ nLin ,ncol PSAY Transform(tRealiz1,"@E 999,999,999.99")   //"aRealiz"+alltrim(str(i))
	ncol := ncol + 14
	@ nlin  ,ncol PSAY Transform(tAberto1,"@E 999,999,999.99")    //"aAberto"+alltrim(str(i))
	ncol := ncol + 14
	@ nlin  ,ncol PSAY Transform(tprevis2,"@E 999,999,999.99")       //"apreviS"+alltrim(str(i))
	ncol := ncol + 14
	@ nLin ,ncol PSAY Transform(tRealiz2,"@E 999,999,999.99")   //"aRealiz"+alltrim(str(i))
	ncol := ncol + 14
	@ nlin  ,ncol PSAY Transform(tAberto2,"@E 999,999,999.99")    //"aAberto"+alltrim(str(i))
	ncol := ncol + 14
	@ nlin  ,ncol PSAY Transform(tprevis3,"@E 999,999,999.99")       //"apreviS"+alltrim(str(i))
	ncol := ncol + 14
	@ nLin ,ncol PSAY Transform(tRealiz3,"@E 999,999,999.99")   //"aRealiz"+alltrim(str(i))
	ncol := ncol + 14
	@ nlin  ,ncol PSAY Transform(tAberto3,"@E 999,999,999.99")    //"aAberto"+alltrim(str(i))
	ncol := ncol + 14
	@ nlin  ,ncol PSAY Transform(tprevis4,"@E 999,999,999.99")       //"apreviS"+alltrim(str(i))
	ncol := ncol + 14
	@ nLin ,ncol PSAY Transform(tRealiz4,"@E 999,999,999.99")   //"aRealiz"+alltrim(str(i))
	ncol := ncol + 14
	@ nlin  ,ncol PSAY Transform(tAberto4,"@E 999,999,999.99")    //"aAberto"+alltrim(str(i))
    nlin := nlin + 1
	//@ nlin  ,ncol PSAY Transform("aAberto"+alltrim(str(i)),"@E 999,999,999.99")    //"aAberto"+alltrim(str(i))
	tPrevis1 := 0
	tPrevis2 := 0
	tPrevis3 := 0
	tPrevis4 := 0
	tRealiz1 := 0
	tRealiz2 := 0
	tRealiz3 := 0
	tRealiz4 := 0
	tAberto1 := 0
	tAberto2 := 0
	tAberto3 := 0
	tAberto4 := 0
	
Enddo            
//Imprime Total geral 
ncol := 001         
nlin := nlin + 1                                                                          
@ nlin, ncol PSAY "total Pago: "
ncol := ncol + 30
@ nlin  ,ncol PSAY Transform(tgprevis1,"@E 999,999,999.99")       //"apreviS"+alltrim(str(i))
ncol := ncol + 14
@ nLin ,ncol PSAY Transform(tgRealiz1,"@E 999,999,999.99")   //"aRealiz"+alltrim(str(i))
ncol := ncol + 14
@ nlin  ,ncol PSAY Transform(tgAberto1,"@E 999,999,999.99")    //"aAberto"+alltrim(str(i))
ncol := ncol + 14
@ nlin  ,ncol PSAY Transform(tgprevis2,"@E 999,999,999.99")       //"apreviS"+alltrim(str(i))
ncol := ncol + 14
@ nLin ,ncol PSAY Transform(tgRealiz2,"@E 999,999,999.99")   //"aRealiz"+alltrim(str(i))
ncol := ncol + 14
@ nlin  ,ncol PSAY Transform(tgAberto2,"@E 999,999,999.99")    //"aAberto"+alltrim(str(i))
ncol := ncol + 14
@ nlin  ,ncol PSAY Transform(tgprevis3,"@E 999,999,999.99")       //"apreviS"+alltrim(str(i))
ncol := ncol + 14
@ nLin ,ncol PSAY Transform(tgRealiz3,"@E 999,999,999.99")   //"aRealiz"+alltrim(str(i))
ncol := ncol + 14
@ nlin  ,ncol PSAY Transform(tgAberto3,"@E 999,999,999.99")    //"aAberto"+alltrim(str(i))
ncol := ncol + 14
@ nlin  ,ncol PSAY Transform(tgprevis4,"@E 999,999,999.99")       //"apreviS"+alltrim(str(i))
ncol := ncol + 14
@ nLin ,ncol PSAY Transform(tgRealiz4,"@E 999,999,999.99")   //"aRealiz"+alltrim(str(i))
ncol := ncol + 14
@ nlin  ,ncol PSAY Transform(tgAberto4,"@E 999,999,999.99")    //"aAberto"+alltrim(str(i))
nlin := nlin + 1


dbCloseArea("TRB")

// Imprime Contas a Receber

aPrevis1 := 0
aPrevis2 := 0
aPrevis3 := 0
aPrevis4 := 0
aPrevisT := 0
aRealiz1 := 0
aRealiz2 := 0
aRealiz3 := 0
aRealiz4 := 0
aRealizT := 0
aAberto1 := 0
aAberto2 := 0
aAberto3 := 0
aAberto4 := 0
aAbertoT := 0
Aprevi := 0
AReal := 0
AAber := 0
nNaturez := {}
nNat := ""

//total Geral.
tgPrevis1 := 0
tgPrevis2 := 0
tgPrevis3 := 0
tgPrevis4 := 0
tgRealiz1 := 0
tgRealiz2 := 0
tgRealiz3 := 0
tgRealiz4 := 0
tgAberto1 := 0
tgAberto2 := 0
tgAberto3 := 0
tgAberto4 := 0

nlin := 80
SomaReal := 0
SomaDesc := 0
SomaJur := 0
SomaEst := 0


DbSelectArea("TRA")
DbGoTop()

SetRegua(RecCount())

ncol := 001
nCC := TRA->E1_XCC
Do While !Eof()         

	IncRegua()
	
	If lAbortPrint
		@ nLin , 000 Psay "*** CANCELADO PELO OPERADOR ***"
		Exit
	EndIf
	
	If nLin > 55
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nlin := 10
	EndIf
	
	If TRA->E1_NATUREZ <= mv_par05 .and. TRA->E1_NATUREZ >= mv_par06
		dbSkip()
		Loop
	Endif
	
	ncol := 001
	nlin := nlin + 1
	@ nlin , ncol PSAY "Obra: " + Transform(nCC,"@!")   //Projeto
	nlin := nlin + 1
	nCC := TRA->E1_XCC
	Do while !eof() .and. TRA->E1_FILIAL >= mv_par01 .and. TRA->E1_FILIAL <= MV_PAR02 .and. TRA->E1_EMISSAO <= DTOS(MV_PAR04)   .AND. nCC == TRA->E1_XCC  //.AND. E2_VENCREA <= DTOS(MV_PAR04)
		
		nNatE1 := E1_NATUREZ
		//Do While !eof() .and. nNat == TRA->E1_NATUREZ
		Do While !eof() .and. TRA->E1_FILIAL >= mv_par01 .and. TRA->E1_FILIAL <= MV_PAR02 .and. TRA->E1_EMISSAO <= DTOS(MV_PAR04)   .AND. nCC == TRA->E1_XCC  .AND. nNatE1 == TRA->E1_NATUREZ
			_cData		:=  TRA->E1_VENCREA
			_cFilial		:=  TRA->E1_FILIAL
			_cprefixo	:= TRA->E1_PREFIXO
			_cNumero	:= TRA->E1_NUM
			_cParcela	:=  TRA->E1_PARCELA
			_cTipo		:= TRA->E1_TIPO
			_cFornece	:= TRA->E1_CLIENTE
			_cLoja		:= TRA->E1_LOJA
			_cAlias 		:= "TRA"
			_cBaixa		:= TRA->E1_BAIXA
			
			iF !Empty(_cBaixa )
				dbSelectArea("SE5")
				dbsetorder(7)
				SE5->(dbSeek(XFILIAL("SE5")+_CPREFIXO+_cNUMERO+_cParcela+_cTipo+_cFornece + _cLoja))
				IF Found()
					nNat5	:= nNatE1
					pegaReal()
				Endif
			Else
				SomaTot := 0
			Endif
					
			dbSelectArea("TRA")
			
			Do Case
				Case SUBSTR(TRA->E1_VENCREA,5,2) == strzero(nMes01,2)
					aPrevis1 := aprevis1 + TRA->E1_VALOR
					aRealiz1 := aRealiz1 + SomaTot   //E1_SALDO
					aAberto1 := aAberto1 + TRA->E1_SALDO
				Case SUBSTR(TRA->E1_VENCREA,5,2) == strzero(nMes02,2)
					aPrevis2 := aPrevis2 + TRA->E1_VALOR
					aRealiz2 := aRealiz2 + somaTot   //E1_SALDO
					aAberto2 := aAberto2 + TRA->E1_SALDO
				Case SUBSTR(TRA->E1_VENCREA,5,2) == strzero(nMes03,2)
					aPrevis3 := aPrevis3 + TRA->E1_VALOR
					aRealiz3 := aRealiz3 + SomaTot      //E1_SALDO
					aAberto3 := aAberto3 + TRA->E1_SALDO
				Case SUBSTR(TRA->E1_VENCREA,5,2) > strzero(nMes03,2)
					aPrevis4 := aPrevis4 + TRA->E1_VALOR
					aRealiz4 := aRealiz4 + SomaTot     //E1_SALDO
					aAberto4 := aAberto4 + TRA->E1_SALDO
			Endcase
			DbSelectArea("TRA")
			dbSkip()
			
		Enddo
		
		ncol := 001
		@ nLin ,ncol PSAY Transform(nNat, "@!")         //natureza
		DbSelectArea("SED")
		DbSeek(Xfilial("SED")+nNatE1)
		nDescr := SED->ED_DESCRIC
		@ nLin, ncol+10 psay substr(nDescr,1,15)

		dbSelectArea("TRA")
		
		For i:=1 to 4 // len(nNaturez)
			
			If lAbortPrint
				@ nLin , 000 Psay "*** CANCELADO PELO OPERADOR ***"
				Exit
			EndIf
			
			If nLin > 55
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nlin := 10
			EndIf
			
			ncol := ncol + 30
			@ nlin  ,ncol PSAY Transform(Aprevis1,"@E 999,999,999.99")       //"apreviS"+alltrim(str(i))
			ncol := ncol + 14
			@ nLin ,ncol PSAY Transform(aRealiz1,"@E 999,999,999.99")   //"aRealiz"+alltrim(str(i))
			ncol := ncol + 14
			@ nlin  ,ncol PSAY Transform(aAberto1,"@E 999,999,999.99")    //"aAberto"+alltrim(str(i))
			ncol := ncol + 14
			@ nlin  ,ncol PSAY Transform(Aprevis2,"@E 999,999,999.99")       //"apreviS"+alltrim(str(i))
			ncol := ncol + 14
			@ nLin ,ncol PSAY Transform(aRealiz2,"@E 999,999,999.99")   //"aRealiz"+alltrim(str(i))
			ncol := ncol + 14
			@ nlin  ,ncol PSAY Transform(aAberto2,"@E 999,999,999.99")    //"aAberto"+alltrim(str(i))
			ncol := ncol + 14
			@ nlin  ,ncol PSAY Transform(Aprevis3,"@E 999,999,999.99")       //"apreviS"+alltrim(str(i))
			ncol := ncol + 14
			@ nLin ,ncol PSAY Transform(aRealiz3,"@E 999,999,999.99")   //"aRealiz"+alltrim(str(i))
			ncol := ncol + 14
			@ nlin  ,ncol PSAY Transform(aAberto3,"@E 999,999,999.99")    //"aAberto"+alltrim(str(i))
			ncol := ncol + 14
			@ nlin  ,ncol PSAY Transform(Aprevis4,"@E 999,999,999.99")       //"apreviS"+alltrim(str(i))
			ncol := ncol + 14
			@ nLin ,ncol PSAY Transform(aRealiz4,"@E 999,999,999.99")   //"aRealiz"+alltrim(str(i))
			ncol := ncol + 14
			@ nlin  ,ncol PSAY Transform(aAberto4,"@E 999,999,999.99")    //"aAberto"+alltrim(str(i))
			ncol := ncol + 14
			//@ nlin  ,ncol PSAY Transform("aAberto"+alltrim(str(i)),"@E 999,999,999.99")    //"aAberto"+alltrim(str(i))
			
		Next
		nLin := nLin + 1
		//Soma totais
		tPrevis1 	:= tPrevis1   + aPrevis1
		tRealiz1 	:= tRealiz1   + aRealiz1
		tAberto1 	:= tAberto1   + aAberto1
		tPrevis2  	:= tPrevis2    + aPrevis2
		tRealiz2  	:= tRealiz2    + aRealiz2
		tAberto2  	:= tAberto2    + aAberto2
		tPrevis3    := tPrevis3     + aPrevis3
		tRealiz3		:= tRealiz3     + aRealiz3
		tAberto3	:= tAberto3    + aAberto3
		tPrevis4		:=	tPrevis4     + aPrevis4
		tRealiz4		:= tRealiz4     + aRealiz4
		tAberto4	:= tAberto4     + aAberto4

	    //soma total geral 
   		tgPrevis1 		:= tgPrevis1   + aPrevis1
		tgRealiz1 		:= tgRealiz1   + aRealiz1
		tgAberto1 		:= tgAberto1   + aAberto1
		tgPrevis2  		:= tgPrevis2    + aPrevis2
		tgRealiz2  		:= tgRealiz2    + aRealiz2
		tgAberto2  	:= tgAberto2    + aAberto2
		tgPrevis3    	:= tgPrevis3     + aPrevis3
		tgRealiz3		:= tgRealiz3     + aRealiz3
		tgAberto3		:= tgAberto3    + aAberto3
		tgPrevis4		:=	tgPrevis4     + aPrevis4
		tgRealiz4		:= tgRealiz4     + aRealiz4
		tgAberto4		:= tgAberto4     + aAberto4

		aPrevis1 := 0
		aPrevis2 := 0
		aPrevis3 := 0
		aPrevis4 := 0
		aPrevisT := 0
		aRealiz1 := 0
		aRealiz2 := 0
		aRealiz3 := 0
		aRealiz4 := 0
		aRealizT := 0
		aAberto1 := 0
		aAberto2 := 0
		aAberto3 := 0
		aAberto4 := 0
		aAbertoT := 0
	Enddo
	// Imprime Total por Obra
	If lAbortPrint
		@ nLin , 000 Psay "*** CANCELADO PELO OPERADOR ***"
		Exit
	EndIf
		
	If nLin > 55
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nlin := 10
	EndIf
	
	ncol := 001                                                                                     
	@ nlin, ncol PSAY "total Obra: "
	ncol := ncol + 30
	@ nlin  ,ncol PSAY Transform(tprevis1,"@E 999,999,999.99")       //"apreviS"+alltrim(str(i))
	ncol := ncol + 14
	@ nLin ,ncol PSAY Transform(tRealiz1,"@E 999,999,999.99")   //"aRealiz"+alltrim(str(i))
	ncol := ncol + 14
	@ nlin  ,ncol PSAY Transform(tAberto1,"@E 999,999,999.99")    //"aAberto"+alltrim(str(i))
	ncol := ncol + 14
	@ nlin  ,ncol PSAY Transform(tprevis2,"@E 999,999,999.99")       //"apreviS"+alltrim(str(i))
	ncol := ncol + 14
	@ nLin ,ncol PSAY Transform(tRealiz2,"@E 999,999,999.99")   //"aRealiz"+alltrim(str(i))
	ncol := ncol + 14
	@ nlin  ,ncol PSAY Transform(tAberto2,"@E 999,999,999.99")    //"aAberto"+alltrim(str(i))
	ncol := ncol + 14
	@ nlin  ,ncol PSAY Transform(tprevis3,"@E 999,999,999.99")       //"apreviS"+alltrim(str(i))
	ncol := ncol + 14
	@ nLin ,ncol PSAY Transform(tRealiz3,"@E 999,999,999.99")   //"aRealiz"+alltrim(str(i))
	ncol := ncol + 14
	@ nlin  ,ncol PSAY Transform(tAberto3,"@E 999,999,999.99")    //"aAberto"+alltrim(str(i))
	ncol := ncol + 14
	@ nlin  ,ncol PSAY Transform(tprevis4,"@E 999,999,999.99")       //"apreviS"+alltrim(str(i))
	ncol := ncol + 14
	@ nLin ,ncol PSAY Transform(tRealiz4,"@E 999,999,999.99")   //"aRealiz"+alltrim(str(i))
	ncol := ncol + 14
	@ nlin  ,ncol PSAY Transform(tAberto4,"@E 999,999,999.99")    //"aAberto"+alltrim(str(i))
    nlin := nlin + 1

	tPrevis1 := 0
	tPrevis2 := 0
	tPrevis3 := 0
	tPrevis4 := 0
	tRealiz1 := 0
	tRealiz2 := 0
	tRealiz3 := 0
	tRealiz4 := 0
	tAberto1 := 0
	tAberto2 := 0
	tAberto3 := 0
	tAberto4 := 0
	
Enddo
//Imprime Total geral Receber
ncol := 001                                                                                     
nlin := nlin + 1
@ nlin, ncol PSAY "total Recebido: "
ncol := ncol + 30
@ nlin  ,ncol PSAY Transform(tgprevis1,"@E 999,999,999.99")       //"apreviS"+alltrim(str(i))
ncol := ncol + 14
@ nLin ,ncol PSAY Transform(tgRealiz1,"@E 999,999,999.99")   //"aRealiz"+alltrim(str(i))
ncol := ncol + 14
@ nlin  ,ncol PSAY Transform(tgAberto1,"@E 999,999,999.99")    //"aAberto"+alltrim(str(i))
ncol := ncol + 14
@ nlin  ,ncol PSAY Transform(tgprevis2,"@E 999,999,999.99")       //"apreviS"+alltrim(str(i))
ncol := ncol + 14
@ nLin ,ncol PSAY Transform(tgRealiz2,"@E 999,999,999.99")   //"aRealiz"+alltrim(str(i))
ncol := ncol + 14
@ nlin  ,ncol PSAY Transform(tgAberto2,"@E 999,999,999.99")    //"aAberto"+alltrim(str(i))
ncol := ncol + 14
@ nlin  ,ncol PSAY Transform(tgprevis3,"@E 999,999,999.99")       //"apreviS"+alltrim(str(i))
ncol := ncol + 14
@ nLin ,ncol PSAY Transform(tgRealiz3,"@E 999,999,999.99")   //"aRealiz"+alltrim(str(i))
ncol := ncol + 14
@ nlin  ,ncol PSAY Transform(tgAberto3,"@E 999,999,999.99")    //"aAberto"+alltrim(str(i))
ncol := ncol + 14
@ nlin  ,ncol PSAY Transform(tgprevis4,"@E 999,999,999.99")       //"apreviS"+alltrim(str(i))
ncol := ncol + 14
@ nLin ,ncol PSAY Transform(tgRealiz4,"@E 999,999,999.99")   //"aRealiz"+alltrim(str(i))
ncol := ncol + 14
@ nlin  ,ncol PSAY Transform(tgAberto4,"@E 999,999,999.99")    //"aAberto"+alltrim(str(i))
nlin := nlin + 1

DbCloseArea("TRA")
dbCloseArea("TRB")

//Set Device to Screen
If aReturn[5] == 1
	Set Printer To
	dbCommitAll()
	ourspool(wnrel)
Endif
MS_FLUSH()

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º Função:    ³ VALIDPERG º Autor: ³ AP5 IDE º Data: ³ 16/09/2002 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Descrição: ³ Verifica a existencia das perguntas criando-as ca-º±±
±±º            ³ so seja necessario (caso nao existam).            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Uso:       ³ Programa principal                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function ValidPerg

Local _sAlias := Alias()
Local aRegs   := { }
Local i,j

DbSelectArea("SX1")
DbSetOrder(1)

cPerg := PADR(cPerg,10)

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
AADD(aRegs,{cPerg,"01","Data Inicial       ?","mv_ch1","D",8,0,0,"G","","mv_par01","","","","","","","","","","","","","","","   "})
AADD(aRegs,{cPerg,"02","Data Final         ?","mv_ch2","D",8,0,0,"G","","mv_par02","","","","","","","","","","","","","","","   "})
AADD(aRegs,{cPerg,"03","Banco Inicial      ?","mv_ch3","C",3,0,0,"G","","mv_par03","","","","","","","","","","","","","","","SA6"})
AADD(aRegs,{cPerg,"04","Banco Final        ?","mv_ch4","C",3,0,0,"G","","mv_par04","","","","","","","","","","","","","","","SA6"})
AADD(aRegs,{cPerg,"05","Pagina Inicial     ?","mv_ch5","N",6,0,0,"G","","mv_par05","","","","","","","","","","","","","","","   "})
For i := 1 to Len(aRegs)
	
	If !DbSeek(cPerg + aRegs[i,2])
		RecLock("SX1",.t.)
		For j := 1 to fCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			EndIf
		Next
		MsUnlock()
	EndIf
	
Next

DbSelectArea(_sAlias)

Return


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria o cabecalho.                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

// MESES ACUMULADOS
AMESES := {}

AMESES := ARRAY(12)
AMESES := {"  JANEIRO  "," FEVEREIRO ","   MARCO   ","   ABRIL   ",;
"    MAIO   ","   JUNHO   ","   JULHO   ","   AGOSTO  ",;
"  SETEMBRO ","  OUTUBRO  "," NOVEMBRO  ","  DEZEMBRO "}
If Day(mv_par02 + 1) == 1
	if MONTH(mv_par02) == 12
		Mes1 := 1
	else
		Mes1:= MONTH(mv_par02) + 1
	Endif
else
	Mes1:= MONTH(mv_par02)
Endif
if Mes1 == 12
	Mes2 := 1
else
	Mes2:= Mes1 + 1
endif

if Mes2 == 12
	Mes3 := 1
else
	Mes3:= Mes2 + 1
endif

CMESES :=" "+  AMESES[Mes1]+ " | "+AMESES[Mes2]+ " | " +AMESES[Mes3] + " | "

Return

// Pega Real     FUNCAO PARA TRAZER OS TITULOS PAGOS CONFORME O TITULO ORIGINAL.
Static Function Pegareal()

SomaReal := 0
SomaDesc := 0
SomaJur := 0                                                                     		
SomaEst := 0
SomaTot := 0

dbSelectArea("SE5")
dbsetorder(7)
//dbSeek(xFilial("SE5")+ _cfilial +_cPrefixo + _cNumero + _cParcela + _cTipo + _cFornece + _cloja)
//Do While !eof() .and. xFilial("SE5") == _cfilial .AND. _cPrefixo == SE5->E5_PREFIXO .AND. _cNumero == SE5->E5_NUMERO .and. _cParcela == SE5->E5_PARCELA .and. _cTipo == SE5->E5_TIPO .and. _cFornece == SE5->E5_CLIFOR .and. _cloja == SE5->E5_LOJA  //.AND. nNatE5 == SE5->E5_NATUREZ
Do While !eof() .and. _cfilial+_cPrefixo+_cNumero+_cParcela+_cTipo+_cFornece+_cLoja == XFILIAL("SE5")+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO+SE5->E5_CLIFOR+SE5->E5_LOJA  //.AND. nNatE5 == SE5->E5_NATUREZ	

	IF SE5->E5_SITUACA == "C"
		DBSKIP()
		LOOP
	ENDIF
	
	//IF SE5->E5_DATA < MV_PAR03
	IF SE5->E5_DATA > MV_PAR04  // data emissao
		dbSkip()
		Loop
	Endif                   
	
/*	if _calias == "TRB"
		IF TRB->E2_BAIXA <> DTOS(SE5->E5_DATA)
			dbSkip()
		    Loop     
		Endif
	ELSEIF _calias == "TRA"
		IF TRA->E1_BAIXA <> DTOS(SE5->E5_DATA)
			dbSkip()                                                                                                                                                                  
			Loop     
		Endif		                                                                                             
	ENDIF
*/		                                                                                                                                                     
	IF !EOF() .AND. _cfilial+_cPrefixo+_cNumero+_cParcela+_cTipo+_cFornece+_cLoja == XFILIAL("SE5")+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO+SE5->E5_CLIFOR+SE5->E5_LOJA  .AND. nNatE5 == SE5->E5_NATUREZ
	
		IF SE5->E5_TIPODOC =="DC"
			SomaDesc :=Somadesc + SE5->E5_VALOR
		ElseIf SE5->E5_TIPODoc == "JR" .OR. SE5->E5_TIPODoc == "MT"
			SomaJur := Somajur + SE5->E5_VALOR
		ElseIf SE5->E5_TIPODOC = "VL" .OR. (SE5->E5_TIPODOC = "BA" .AND. SE5->E5_MOTBX == "NOR"	) .OR. SE5->E5_TIPODOC = 'CP'  // VERIFICAR POIS EXISTEM NA BASE VL E BA
			SomaReal := SomaReal + SE5->E5_VALOR
		ElseIf SE5->E5_TIPODOC = "ES"
			SomaEst  := SomaEst + SE5->E5_VALOR
		ENDIF
	
	ENDIF
		
	dbSelectArea("SE5")
	dbsetorder(7)
	dbSkip()                                                                     
	SomaTot := Somareal - Somadesc + SomaJur  -  SomaEst    
Enddo
//SomaTot := Somareal - Somadesc + SomaJur  -  SomaEst
//nNatE5 := SE5->E5_NATUREZ

Return