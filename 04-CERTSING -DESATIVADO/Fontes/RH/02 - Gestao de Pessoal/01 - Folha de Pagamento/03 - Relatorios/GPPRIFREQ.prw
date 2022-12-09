#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"            
#Include 'Colors.ch'       
/*       
GPEA922 - FATOS RELEVAMTES
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGPPRIFREQ บAutor  ณ Primainfo          บ Data ณ  03/22/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Ficha de Controle de Frequencia                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Clientes PRIMAINFO                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function GPPRIFREQ()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Impressao do Controle de Frequencia"
Local cPict          := ""
Local titulo         := "IMPRESSAO DO CONTROLE DE FREQUENCIA"
Local nLin           := 80
Local Cabec1         := ""
Local Cabec2         := ""
Local imprime        := .T.
Private aOrd	  	 := {"Matricula","Nome","Centro Custo + Matricula","Centro Custo + Nome"}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private limite       := 132
Private tamanho      := "M"
Private nomeprog     := "CP001"
Private nTipo        := 15
Private aReturn      := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey     := 0
Private cPerg        := Padr("GPPRIFREQ",Len(SX1->X1_GRUPO))
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "GPPRIFREQ"
Private cString      := "SRA"

fPriPerg()                                              

pergunte(cPerg,.F.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta a interface padrao com o usuario...                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,Tamanho,,.T.)
If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)
If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

nOrdem := aReturn[8]
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Processamento. RPTSTATUS monta janela com a regua de processamento. ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณRUNREPORT บ Autor ณ AP6 IDE            บ Data ณ  11/12/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local aAreaSRA
Local dDtDe, dDtAte, cAno, cFilDe, cFilAte
Local cCcDe, cCcAte, cTnoDe, cTnoAte
Local cMatDe, cMatAte, cSit, cCat, cQuery
Local cArqNtx, nX, dTemp, nCol,nColDet, cTipDia
Local cOldFil, cOldCc, cOldTno
Local aDias  := {}
Local aInfo  := {}
Local lFisrt := .T.
LOCAL oBrush
LOCAL aCoords1 := {}
LOCAL aCoords2 := {}
LOCAL aCoords3 := {}               
Local cDia := ""
Local nCol := 0
Local nXY  := 0
Local nXYZ  := 0
Local nWXYZ := 0
Local nAno  := 0
Local nLin2 := 0
Local nAB,nAC,nAD,nAM,nCP,nFE,nFT,nLG,nLM,nSP,nOT,nAS := 0
Private lSemMov
Private oCabec, oCabecNeg, oTopico, oTopicoNeg
Private oDadosNeg, oDados, oCelula,oCelSmal, oCelulaNeg, oSmallCel
Private oPrint
Private cTPSP6	 	:= ""
Private cCodSPK  	:= ""
Private cCodSPC  	:= ""
Private nHrsSPK	 	:= 0
Private cFilSPK		:= ""
Private cMatSPK		:= ""
Private dDtDeSPK	:= CtoD("  /  /  ")
Private dDtAteSPK   := CtoD("  /  /  ")             
Private cTpResc    	:= ""
Private cDesResc	:= ""
Private nQtdeOco	:= 0                                 
Private nQtRegSPC,nQtRegSPK := 0
Private cFilSP6		:= Space(02)
Private cFilSP9     := Space(02)
Private aMotivos	:= {}

Pergunte(cPerg,.F.)
dDtDe   := mv_par01
dDtAte  := mv_par02
If dDtAte > (dDtDe + 365.25)
	dDtAte  := (dDtDe + 365.25)-1
EndIf
cFilDe  := mv_par03
cFilAte := mv_par04
cCcDe   := mv_par05
cCcAte  := mv_par06
cTnoDe  := mv_par07
cTnoAte := mv_par08
cMatDe  := mv_par09
cMatAte := mv_par10
cSit    := mv_par11
cCat    := mv_par12        
lSemMov := mv_par13 == 1 
lImpSal := IIf(mv_par13 == 1,.t.,.f.)

If Empty( dDtDe ) .Or. Empty( dDtAte )
	Aviso( "ATENCAO","Periodo p/ Impressao Nao Informado",{"Sair"} )
	Return
EndIf

// Define os Fontes
oCabec     := TFont():New("Tahoma",14,14,,.F.,,,,.T.,.F.)
oCabecNeg  := TFont():New("Tahoma",18,18,,.T.,,,,.T.,.F.)
oDados     := TFont():New("Tahoma",12,12,,.F.,,,,.T.,.F.)
oDadosNeg  := TFont():New("Tahoma",12,12,,.T.,,,,.T.,.F.)
oTopico    := TFont():New("Times New Roman",10,10,,.F.,,,,.T.,.F.)
oTopicoNeg := TFont():New("Times New Roman",10,10,,.T.,,,,.T.,.F.)
oSmallCel  := TFont():New("Courier New",10,10,,.T.,,,,.T.,.F.)
oCelula    := TFont():New("Courier New",12,12,,.F.,,,,.T.,.F.)
oCelSmal   := TFont():New("Courier New",10,10,,.F.,,,,.T.,.F.)
oCelSmal2  := TFont():New("Courier New",08,08,,.F.,,,,.T.,.F.)
oCelulaNeg := TFont():New("Courier New",12,12,,.T.,,,,.T.,.F.)

// Inicializa Objeto de Impressao
oPrint := TMSPrinter():New()
oPrint:SetLandScape()

oBrush := TBrush():New( , CLR_LIGHTGRAY)

oPrint:StartPage()   // Inicia uma nova pแgina

nLin := 0001

//cArqNtx := CriaTrab( Nil, .F. )
dbSelectArea( "SRA" )
//Matricula
If nOrdem = 1
	dbSetorder(1)
//Nome
ElseIf nOrdem = 2
	dbSetorder(3)
//C.Custo + Matricula
ElseIf nOrdem = 3
	dbSetorder(2)
//C.Custo + Nome
ElseIf nOrdem = 4
	dbSetorder(8)
Endif	

dbGoTop()
SetRegua(RecCount())

While SRA->(!Eof())
	IncRegua()
	If (SRA->RA_FILIAL   < cFilDe  .Or. SRA->RA_FILIAL   > cFilAte) .Or. ;
	   (SRA->RA_CC       < cCcDe   .Or. SRA->RA_CC       > cCcAte)  .Or. ;
	   (SRA->RA_TNOTRAB  < cTnoDe  .Or. SRA->RA_TNOTRAB  > cTnoAte) .Or. ;
	   (SRA->RA_MAT      < cMatDe  .Or. SRA->RA_MAT      > cMatAte) .Or. ;
	   !(SRA->RA_CATFUNC $ cCat) .Or. !(SRA->RA_SITFOLH $ cSit)
	   SRA->(dbSkip())
	   Loop
	EndIf
	
	//Zera Array com motivos
	aMotivos	:= {}
	
	//Trata Filiais
	cFilSP6		:= IIf(!Empty(xFilial("SP6")),SRA->RA_FILIAL,xFilial("SP6"))
	cFilSP9		:= IIf(!Empty(xFilial("SP9")),SRA->RA_FILIAL,xFilial("SP9"))	

	GerDia(SRA->RA_FILIAL, SRA->RA_MAT, dDtDe, dDtAte)			

	If !lSemMov .and. Len(aMotivos) = 0
		SRA->(dbSkip())
		Loop
	EndIf   
		
	nAB := 0
	nAC := 0
	nAD := 0
	nAM := 0
	nCP := 0
	nFE := 0
	nFT := 0
	nLG := 0
	nLM := 0
	nSP := 0
	nOT := 0
	nAS := 0
	
	oPrint:StartPage()

	oPrint:Box(0080,0080,2350,3020) //BORDA DA FOLHA
	oPrint:Box(0100,0100,0350,3000) //BORDA CONTROLE DE FREQUENCIA

	oPrint:SayBitmap(0150  ,0120,"\system\lgrl"+cEmpAnt+cFilAnt+".bmp",0450,180)
	oPrint:Say( 0200, 1250, "CONTROLE DE FREQUสNCIA" , oCabecNeg )

	oPrint:Box(0370,0100,0800,3000) //BORDA QUADRO FUNCIONARIO
	oPrint:Say(0400, 0120, "Funcionแrio: "+SRA->RA_MAT + " - " + Alltrim(SRA->RA_NOMECMP) , oCelulaNeg )
	oPrint:Say(0400, 1800, "Admissao:" + DtoC(SRA->RA_ADMISSA), oCelulaNeg )
	//oPrint:Box(0500,2200,0560,2980)
	//oPrint:Say(0500, 2220, DtoC(SRA->RA_ADMISSA) , oCelulaNeg )
    

	//oPrint:Box(0400,0650,0460,2980)
	//oPrint:Say(0400, 0670, SRA->RA_MAT + Alltrim(SRA->RA_NOME) , oCelulaNeg )
	oPrint:Say(0500, 0120, "Perํodo de Apura็ใo: "+DtoC(dDtDe) + " a " +  DtoC(dDtAte), oCelulaNeg )
	oPrint:Say(0500, 1800, "Demissao: "+DtoC(SRA->RA_DEMISSA) , oCelulaNeg )


	oPrint:Say(0600, 0120, "Centro Custo: "+Alltrim(SRA->RA_CC) + " - " + Alltrim(Posicione("CTT",1,xFilial("CTT")+ SRA->RA_CC, "CTT_DESC01",,SRA->RA_FILIAL )) , oCelulaNeg )
	oPrint:Say(0600, 1800, "Funcao: "+Alltrim(SRA->RA_CODFUNC) + " - " + Alltrim(Posicione("SRJ",1,xFilial("SRJ")+ SRA->RA_CODFUNC, "RJ_DESC",,SRA->RA_FILIAL )) , oCelulaNeg )


	//oPrint:Box(0500,0800,0560,1200)
	//oPrint:Say(0500, 0920, DtoC(dDtDe) , oCelulaNeg )
	//oPrint:Say(0500, 1320, "Ate:" , oCelulaNeg )
	//oPrint:Box(0500,1500,0560,1900)
	//oPrint:Say(0500, 1620, DtoC(dDtAte) , oCelulaNeg )
	//oPrint:Say(0500, 2020, "Admissao:" , oCelulaNeg )
	//oPrint:Box(0500,2200,0560,2980)
	//oPrint:Say(0500, 2220, DtoC(SRA->RA_ADMISSA) , oCelulaNeg )
	//oPrint:Say(0600, 0120, "Matricula:" , oCelulaNeg )
	//oPrint:Box(0600,0400,0660,0700)
	//oPrint:Say(0600, 0420, SRA->RA_MAT , oCelulaNeg )
	//oPrint:Say(0600, 0800, "Desc. C.C.:" , oCelulaNeg )
	//oPrint:Box(0600,1100,0660,1900)
	//oPrint:Say(0600, 1120, Posicione("CTT",1,xFilial("CTT")+ SRA->RA_CC, "CTT->CTT_DESC01",,SRA->RA_FILIAL ), oCelulaNeg )
	//oPrint:Say(0600, 2020, "Admissใo:" , oCelulaNeg )
	//oPrint:Box(0600,2300,0660,2980)
	//oPrint:Say(0600, 2520, DtoC(SRA->RA_ADMISSA), oCelulaNeg )
                                    
	//TpRes(SRA->RA_FILIAL, SRA->RA_MAT)
	//oPrint:Say(0700, 0120, "Demissao:" , oCelulaNeg )
	//oPrint:Box(0700,0400,0760,0900)
	//oPrint:Say(0700, 0420, DtoC(SRA->RA_DEMISSA), oCelulaNeg )
	//oPrint:Say(0700, 1000, "Motivo do Deslig.:" , oCelulaNeg )

	//If 	!Empty(cTpResc)
	//	oPrint:Say(0700, 1520, cTpResc+" - "+cDesResc, oCelulaNeg )
	//Endif

	//oPrint:Box(0700,1500,0760,2980)
	nLin += 0820

	oPrint:Line( nLin,      0100, nLin,      3000 )		// Linha
	oPrint:Line( nLin,      0100, nLin+0060, 0100 )		// Coluna
	oPrint:Say( nLin, 0120, "Dia" , oCelulaNeg )
	oPrint:Line( nLin,      0272, nLin+0060, 0272 )		// ColunaMES/ANO

	nXY  := 0
	nCol := 0

	For nXY := 1 To 31
		oPrint:Line( nLin,0360+nCol, nLin+0060,0360+nCol )		// Coluna1
		nCol += 88
	Next nXY

	oPrint:Line( nLin+0060, 0100, nLin+0060, 3000 )		// $Linha

	nXY  := 0
	nCol := 0
	
	For nXY := 1 To 31
		oPrint:Say( nLin, 0282+nCol, Alltrim(Str(nXY)) , oCelulaNeg )
		nCol += 88
	Next nXY

	nLin += 0100

	nWXYZ := Month(dDtDe)
	nAno  := Year(dDtDe)

	For nXYZ := 1 To 12

		nXY  := 0
		nCol := 0

		oPrint:Line( nLin,      0100, nLin,      3000 )		// Linha
		oPrint:Line( nLin,      0100, nLin+0060, 0100 )		// Coluna
		oPrint:Say( nLin, 0110, Subs(MesExtenso(nWXYZ),1,3)+"/"+Subs(StrZero(nAno,4),3,2), oCelulaNeg )
		oPrint:Line( nLin,      0272, nLin+0060, 0272 )		// Coluna Mes
	
		For nXY := 1 To 31
			n_PosMot := aScan( aMotivos, { |x| x[1] == Stod(Strzero(nAno,4)+StrZero(nWXYZ,2)+StrZero(nXY,2)) } )
			If n_PosMot = 0
				cTPSP6 := "  "
			Else
				cTPSP6 := aMotivos[n_PosMot,2]
			Endif

			oPrint:Say( nLin, 0272+nCol+10, Alltrim(cTPSP6), oCelulaNeg )

			oPrint:Line( nLin,0360+nCol, nLin+0060,0360+nCol )		// Coluna1
			
			IF cTPSP6 = "AB" 
				nAB += 1
			ElseIf cTPSP6 = "AC" 
				nAC += 1
			ElseIf cTPSP6 = "AD" 
				nAD += 1
			ElseIf cTPSP6 = "AM" 
				nAM += 1
			ElseIf cTPSP6 = "CP" 
				nCP += 1
			ElseIf cTPSP6 = "FE" 
				nFE += 1
			ElseIf cTPSP6 = "FT" 
				nFT += 1
			ElseIf cTPSP6 = "LG" 
				nLG += 1
			ElseIf cTPSP6 = "LM" 
				nLM += 1
			ElseIf cTPSP6 = "SP" 
				nSP += 1
			ElseIf cTPSP6 = "OT" 
				nOT += 1
			ElseIf cTPSP6 = "AS" 
				nAS += 1
			EndIf
			
			nCol += 88                                                         
		Next nXY
		
		nWXYZ := nWXYZ + 1
		
		If nWXYZ >= 13
			nWXYZ := 1
			nAno := nAno + 1
		EndIf		 
	
		oPrint:Line( nLin+0060, 0100, nLin+0060, 3000 )		// $Linha
	
		nLin += 0060
	
	Next nXYZ

	nLin += 0040

	oPrint:Box(1650,0100,1650+0060,1050)                           
	oPrint:Say(1650,0450, "LEGENDA" , oCelulaNeg )
	oPrint:Box(1711,0100,2330,1050)                           
	oPrint:Say(1731,0120, "AB: Abono Legal" , oCelulaNeg )
	oPrint:Say(1781,0120, "AC: Acidente de Trab." , oCelulaNeg )
	oPrint:Say(1831,0120, "AD: Auxํlio Doen็a" , oCelulaNeg )
	oPrint:Say(1882,0120, "AM: Atestado M้dico" , oCelulaNeg )
	oPrint:Say(1933,0120, "CP: Compensacoes" , oCelulaNeg )
	oPrint:Say(1984,0120, "FE: F้rias" , oCelulaNeg )
	oPrint:Say(2035,0120, "FT: Falta" , oCelulaNeg )
	oPrint:Say(2086,0120, "LG: Licen็a Casamento" , oCelulaNeg )
	oPrint:Say(2137,0120, "LM: Licen็a Matern" , oCelulaNeg )
	oPrint:Say(2188,0120, "SP: Suspensใo/Advertencia" , oCelulaNeg )
	oPrint:Say(2238,0120, "OT: Outros" , oCelulaNeg )
	oPrint:Say(2286,0120, "AS: Atrasos/Saidas " , oCelulaNeg )
	oPrint:Say(1731,0700, "Total: " +Transform(nAB,'@E 9,999'), oCelulaNeg )
	oPrint:Say(1781,0700, "Total: " +Transform(nAC,'@E 9,999'), oCelulaNeg )
	oPrint:Say(1831,0700, "Total: " +Transform(nAD,'@E 9,999'), oCelulaNeg )
	oPrint:Say(1882,0700, "Total: " +Transform(nAM,'@E 9,999'), oCelulaNeg )
	oPrint:Say(1933,0700, "Total: " +Transform(nCP,'@E 9,999'), oCelulaNeg )
	oPrint:Say(1984,0700, "Total: " +Transform(nFE,'@E 9,999'), oCelulaNeg )
	oPrint:Say(2035,0700, "Total: " +Transform(nFT,'@E 9,999'), oCelulaNeg )
	oPrint:Say(2086,0700, "Total: " +Transform(nLG,'@E 9,999'), oCelulaNeg )
	oPrint:Say(2137,0700, "Total: " +Transform(nLM,'@E 9,999'), oCelulaNeg )
	oPrint:Say(2188,0700, "Total: " +Transform(nSP,'@E 9,999'), oCelulaNeg )
	oPrint:Say(2238,0700, "Total: " +Transform(nOT,'@E 9,999'), oCelulaNeg )
	oPrint:Say(2286,0700, "Total: " +Transform(nAS,'@E 9,999'), oCelulaNeg )	
//	oPrint:Say(2436,0700, "Total: " +Transform(nFD,'@E 9,999'), oCelulaNeg )
//	oPrint:Box(1650,1150,1710,3000)                           
//	oPrint:Say(1650,1170, "Anota็๕es Gerais:" , oCelulaNeg )
        
	nXY := 0
	nLin2:= 0
		
//	For nXY := 1 To 12
//		oPrint:Box(1731,1150,1781+nLin2,3000)                           		// Coluna1
//		nLin2 += 50
//	Next nXY


	//ULTIMAS PROMOCOES
	If lImpSal
		//REAJUSTES
		aProm	:= {}
		cFilSX5 := IIf(!Empty(xFilial("SX5")), SRA->RA_FILIAL, xFilial("SX5"))
		cQuery 	:= ""
		cQuery 	+= " SELECT R3_FILIAL,R3_MAT,R3_DATA,R3_TIPO, X5_DESCRI, R7_DESCFUN, R3_VALOR"
		cQuery 	+= " FROM "+RetSqlName("SR3") + " SR3, "+RetSqlName("SR7") + " SR7, "+RetSqlName("SX5") + " SX5"
		cQuery 	+= " WHERE "
		cQuery 	+= " 	SR3.D_E_L_E_T_ = ' '"
		cQuery 	+= " AND SR7.D_E_L_E_T_ = ' '"
		cQuery 	+= " AND SX5.D_E_L_E_T_ = ' '"
		cQuery 	+= " AND R3_FILIAL = '"+SRA->RA_FILIAL+"'"
		cQuery 	+= " AND R3_MAT = '"+SRA->RA_MAT+"'"
		cQuery 	+= " AND R3_FILIAL = R7_FILIAL"
		cQuery 	+= " AND R3_MAT = R7_MAT"
		cQuery 	+= " AND R3_DATA = R7_DATA"
		cQuery 	+= " AND R3_TIPO = R7_TIPO"
		cQuery 	+= " AND X5_TABELA = '41'"
		cQuery 	+= " AND X5_FILIAL = '"+cFilSX5+"'"		
		cQuery 	+= " AND R3_TIPO = X5_CHAVE"
		cQuery 	+= " AND R3_SEQ = R7_SEQ"
		cQuery 	+= " AND R3_DATA >= '"+dtos(dDataBase-1825)+"'" //ultimos 5 anos
		cQuery 	+= " AND R3_PD IN ('   ','000')"
		cQuery 	+= " ORDER BY 3,4"
		TCQuery cQuery New Alias "W004"
		TcSetField( "W004", "R3_DATA"  ,"D",8, 0 )
		TcSetField( "W004", "R3_VALOR" ,"N",12, 2 )
		
		nValAnt	:= 0
		While W004->(!Eof())
//			If 	!W004->R3_TIPO $ "001/002/003/009"
				AAdd(aProm,{Dtoc(W004->R3_DATA)+ " "+ Subs(W004->X5_DESCRI,1,30) +" "+Subs(W004->R7_DESCFUN,1,35) + " "+Transform(W004->R3_VALOR,"@E 999,999.99")+Transform( IIf( nValAnt > 0,((W004->R3_VALOR/nValAnt)-1) * 100,0),"@E 999.99")+"%" })
//			Endif
			nValAnt := W004->R3_VALOR
			W004->(dbSkip())
		Enddo
		
		W004->(dbCloseArea())

		oPrint:Box(1650,1600,1650+0060,3000)
		oPrint:Say(1650,2100, "ACOES SALARIAIS" , oCelulaNeg )
		nxLin := 1731
		For xt := 1 to Min(Len(aProm),10)
			oPrint:Say(nxLin,1620, aProm[XT,1], oCelSmal2 )
			nxLin += 40
		Next
		
		oPrint:Box(1711,1600,nxLin,3000)
	Endif

	oPrint:EndPage()
	nLin := 0001

	SRA->(dbSkip())
EndDo

SRA->(RetIndex())

Set Century Off
SET DEVICE TO SCREEN

dbCommitAll()
SET PRINTER TO
oPrint:Preview()

MS_FLUSH()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfPriPerg  บAutor  ณ Primainfo          บ Data ณ  11/12/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Perguntas do Sistema.                                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
Static Function fPriPerg()

Local aRegs := {}


aAdd(aRegs,{ cPerg,'01','Data De                 ?','','','mv_ch1','D',08,0,0,'G','NaoVazio   ','mv_par01','               ','','','','','           ','','','','','         ','','','','','            ','','','','','           ','','','','      ','' })
aAdd(aRegs,{ cPerg,'02','Data Ate                ?','','','mv_ch2','D',08,0,0,'G','NaoVazio   ','mv_par02','               ','','','','','           ','','','','','         ','','','','','            ','','','','','           ','','','','      ','' })
aAdd(aRegs,{ cPerg,'03','Filial De               ?','','','mv_ch3','C',02,0,0,'G','           ','mv_par03','               ','','','','','           ','','','','','         ','','','','','            ','','','','','           ','','','','SM0   ','' })
aAdd(aRegs,{ cPerg,'04','Filial Ate              ?','','','mv_ch4','C',02,0,0,'G','NaoVazio   ','mv_par04','               ','','','','','           ','','','','','         ','','','','','            ','','','','','           ','','','','SM0   ','' })
aAdd(aRegs,{ cPerg,'05','Centro Custo De         ?','','','mv_ch5','C',09,0,0,'G','           ','mv_par05','               ','','','','','           ','','','','','         ','','','','','            ','','','','','           ','','','','CTT   ','' })
aAdd(aRegs,{ cPerg,'06','Centro Custo Ate        ?','','','mv_ch6','C',09,0,0,'G','NaoVazio   ','mv_par06','               ','','','','','           ','','','','','         ','','','','','            ','','','','','           ','','','','CTT   ','' })
aAdd(aRegs,{ cPerg,'07','Turno Trabalho De       ?','','','mv_ch7','C',03,0,0,'G','           ','mv_par07','               ','','','','','           ','','','','','         ','','','','','            ','','','','','           ','','','','SR6   ','' })
aAdd(aRegs,{ cPerg,'08','Turno Trabalho Ate      ?','','','mv_ch8','C',03,0,0,'G','NaoVazio   ','mv_par08','               ','','','','','           ','','','','','         ','','','','','            ','','','','','           ','','','','SR6   ','' })
aAdd(aRegs,{ cPerg,'09','Matricula De            ?','','','mv_ch9','C',06,0,0,'G','           ','mv_par09','               ','','','','','           ','','','','','         ','','','','','            ','','','','','           ','','','','SRA   ','' })
aAdd(aRegs,{ cPerg,'10','Matricula Ate           ?','','','mv_cha','C',06,0,0,'G','NaoVazio   ','mv_par10','               ','','','','','           ','','','','','         ','','','','','            ','','','','','           ','','','','SRA   ','' })
aAdd(aRegs,{ cPerg,'11','Situacoes               ?','','','mv_chb','C',05,0,0,'G','fSituacao  ','mv_par11','               ','','','','','           ','','','','','         ','','','','','            ','','','','','           ','','','','      ','' })
aAdd(aRegs,{ cPerg,'12','Categorias              ?','','','mv_chc','C',15,0,0,'G','fCategoria ','mv_par12','               ','','','','','           ','','','','','         ','','','','','            ','','','','','           ','','','','      ','' })
aAdd(aRegs,{ cPerg,'13','Imprime sem Movimento   ?','','','mv_chd','N',01,0,0,'C','           ','mv_par13','Sim            ','','','','','Nao        ','','','','','         ','','','','','            ','','','','','           ','','','','      ','' })
aAdd(aRegs,{ cPerg,'14','Imprime Salario         ?','','','mv_che','N',01,0,0,'C','           ','mv_par14','Sim            ','','','','','Nao        ','','','','','         ','','','','','            ','','','','','           ','','','','      ','' })

dbSelectArea("SX1")
For i:=1 to Len(aRegs)
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

Return                                                                          

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGerDia    บAutor  ณEduardo Porto       บ Data ณ  11/12/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Gera dias Folga											   ฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
Static Function GerDia(cFilSPK,cMatSPK,dDtDeSPK,dDtAteSPK)
                                        
aAreaSRA:= GetArea()
cQuery 		:= ""

//ABONOS MOV.ABERT0
cQuery		:= " SELECT PK.PK_CODABO,P6.P6_TPABO,PK.PK_DATA"
cQuery		+= " FROM "+RETSQLNAME("SPK")+" PK,"+RETSQLNAME("SP6")+" P6,"+RETSQLNAME("SPC")+" PC"
cQuery		+= " WHERE PK.PK_FILIAL = '" + cFilSPK + "'"
cQuery		+= " AND PK.PK_MAT = '"+ cMatSPK + "'"
cQuery		+= " AND PK.PK_DATA BETWEEN '"+dtos(dDtDeSPK)+"' AND '"+dtos(dDtAteSPK)+"'"                                               
cQuery      += " AND PK.PK_CODABO = P6.P6_CODIGO"
cQuery      += " AND PC_FILIAL = PK_FILIAL"
cQuery      += " AND PC_MAT = PK_MAT"
cQuery      += " AND PC_DATA = PK_DATA"
cQuery      += " AND PC_PD = PK_CODEVE"
cQuery		+= " AND PK.D_E_L_E_T_ <> '*'" 
cQuery		+= " AND PC.D_E_L_E_T_ <> '*'" 
cQuery		+= " AND P6.D_E_L_E_T_ <> '*'" 
cQuery		+= " AND P6_FILIAL = '"+cFilSP6 +"'"
cQuery		+= " AND P6_TPABO <> '  '"

//ABONOS MOV.FECHADO
cQuery		+= " UNION ALL"
cQuery		+= " SELECT PK.PK_CODABO,P6.P6_TPABO,PK.PK_DATA"
cQuery		+= " FROM "+RETSQLNAME("SPK")+" PK,"+RETSQLNAME("SP6")+" P6,"+RETSQLNAME("SPH")+" PH"
cQuery		+= " WHERE PK.PK_FILIAL = '" + cFilSPK + "'"
cQuery		+= " AND PK.PK_MAT = '"+ cMatSPK + "'"
cQuery		+= " AND PK.PK_DATA BETWEEN '"+dtos(dDtDeSPK)+"' AND '"+dtos(dDtAteSPK)+"'"                                               
cQuery      += " AND PK.PK_CODABO = P6.P6_CODIGO"
cQuery      += " AND PH_FILIAL = PK_FILIAL"
cQuery      += " AND PH_MAT = PK_MAT"
cQuery      += " AND PH_DATA = PK_DATA"
cQuery      += " AND PH_PD = PK_CODEVE"
cQuery		+= " AND PK.D_E_L_E_T_ <> '*'" 
cQuery		+= " AND PH.D_E_L_E_T_ <> '*'" 
cQuery		+= " AND P6.D_E_L_E_T_ <> '*'" 
cQuery		+= " AND P6_FILIAL = '"+cFilSP6 +"'"
cQuery		+= " AND P6_TPABO <> '  '"


//FALTAS NAO ABONADAS
cQuery		+= " UNION ALL"
cQuery		+= " SELECT P9.P9_CODIGO PK_CODABO, 'FT' AS P6_TPABO,PC_DATA AS PK_DATA "
cQuery		+= " FROM "+RETSQLNAME("SPC")+" PC,"+RETSQLNAME("SP9")+" P9"
cQuery		+= " WHERE PC.PC_FILIAL = '" + cFilSPK + "'"
cQuery		+= " AND PC.PC_MAT = '"+ cMatSPK  + "'"
cQuery		+= " AND PC.PC_DATA BETWEEN '"+dtos(dDtDeSPK)+"' AND '"+dtos(dDtAteSPK)+"'"
cQuery      += " AND (PC.PC_ABONO = '' OR (PC.PC_ABONO <> '' AND PC.PC_QUANTC > PC.PC_QTABONO))"
cQuery      += " AND PC.PC_PDI = '   '"
cQuery      += " AND PC.PC_PD = P9.P9_CODIGO"
cQuery      += " AND (P9.P9_IDPON = '010A' OR P9.P9_CODFOL = '420')"
cQuery      += " AND P9.P9_BHORAS <> 'S'"
cQuery		+= " AND PC.D_E_L_E_T_ <> '*'" 
cQuery		+= " AND P9.D_E_L_E_T_ <> '*'" 
cQuery		+= " AND P9_FILIAL = '"+cFilSP9 +"'"

cQuery		+= " UNION ALL"
cQuery		+= " SELECT P9.P9_CODIGO PK_CODABO, 'FT' AS P6_TPABO,PH_DATA AS PK_DATA "
cQuery		+= " FROM "+RETSQLNAME("SPH")+" PC,"+RETSQLNAME("SP9")+" P9"
cQuery		+= " WHERE PC.PH_FILIAL = '" + cFilSPK + "'"
cQuery		+= " AND PC.PH_MAT = '"+ cMatSPK  + "'"
cQuery		+= " AND PC.PH_DATA BETWEEN '"+dtos(dDtDeSPK)+"' AND '"+dtos(dDtAteSPK)+"'"
cQuery      += " AND (PC.PH_ABONO = '' OR (PC.PH_ABONO <> '' AND PC.PH_QUANTC > PC.PH_QTABONO))"
cQuery      += " AND PC.PH_PDI = '   '"
cQuery      += " AND PC.PH_PD = P9.P9_CODIGO"
cQuery      += " AND (P9.P9_IDPON = '010A' OR P9.P9_CODFOL = '420')"
cQuery      += " AND P9.P9_BHORAS <> 'S'"
cQuery		+= " AND PC.D_E_L_E_T_ <> '*'" 
cQuery		+= " AND P9.D_E_L_E_T_ <> '*'" 
cQuery		+= " AND P9_FILIAL = '"+cFilSP9 +"'"

//FALTAS NAO ABONADAS - CODIGO INFORMADO
cQuery		+= " UNION ALL"
cQuery		+= " SELECT P9.P9_CODIGO PK_CODABO, 'FT' AS P6_TPABO,PC_DATA AS PK_DATA "
cQuery		+= " FROM "+RETSQLNAME("SPC")+" PC,"+RETSQLNAME("SP9")+" P9"
cQuery		+= " WHERE PC.PC_FILIAL = '" + cFilSPK + "'"
cQuery		+= " AND PC.PC_MAT = '"+ cMatSPK  + "'"
cQuery		+= " AND PC.PC_DATA BETWEEN '"+dtos(dDtDeSPK)+"' AND '"+dtos(dDtAteSPK)+"'"
cQuery      += " AND PC.PC_PDI <> '   '" 
cQuery      += " AND P9_CODIGO = PC_PDI"
cQuery      += " AND P9_TIPOCOD = '2'"
cQuery      += " AND P9.P9_BHORAS <> 'S'"
cQuery		+= " AND PC.D_E_L_E_T_ <> '*'" 
cQuery		+= " AND P9.D_E_L_E_T_ <> '*'" 
cQuery		+= " AND P9_FILIAL = '"+cFilSP9 +"'"

cQuery		+= " UNION ALL"
cQuery		+= " SELECT P9.P9_CODIGO PK_CODABO, 'FT' AS P6_TPABO,PH_DATA AS PK_DATA "
cQuery		+= " FROM "+RETSQLNAME("SPH")+" PH,"+RETSQLNAME("SP9")+" P9"
cQuery		+= " WHERE PH.PH_FILIAL = '" + cFilSPK + "'"
cQuery		+= " AND PH.PH_MAT = '"+ cMatSPK  + "'"
cQuery		+= " AND PH.PH_DATA BETWEEN '"+dtos(dDtDeSPK)+"' AND '"+dtos(dDtAteSPK)+"'"
cQuery      += " AND PH.PH_PDI <> '   '" 
cQuery      += " AND P9_CODIGO = PH_PDI"
cQuery      += " AND P9_TIPOCOD = '2'"
cQuery      += " AND P9.P9_BHORAS <> 'S'"
cQuery		+= " AND PH.D_E_L_E_T_ <> '*'" 
cQuery		+= " AND P9.D_E_L_E_T_ <> '*'" 
cQuery		+= " AND P9_FILIAL = '"+cFilSP9 +"'"


//ATRASOS/SAIDAS
cQuery		+= " UNION ALL"
cQuery		+= " SELECT P9.P9_CODIGO PK_CODABO, 'AS' AS P6_TPABO,PC_DATA AS PK_DATA "
cQuery		+= " FROM "+RETSQLNAME("SPC")+" PC,"+RETSQLNAME("SP9")+" P9"
cQuery		+= " WHERE PC.PC_FILIAL = '" + cFilSPK + "'"
cQuery		+= " AND PC.PC_MAT = '"+ cMatSPK  + "'"
cQuery		+= " AND PC.PC_DATA BETWEEN '"+dtos(dDtDeSPK)+"' AND '"+dtos(dDtAteSPK)+"'"
cQuery      += " AND (PC.PC_ABONO = '' OR (PC.PC_ABONO <> '' AND PC.PC_QUANTC > PC.PC_QTABONO))"
cQuery      += " AND PC.PC_PDI = '   '"
cQuery      += " AND PC.PC_PD = P9.P9_CODIGO"
cQuery      += " AND P9.P9_IDPON IN ('008A','012A','014A','020A')"
cQuery      += " AND P9.P9_BHORAS <> 'S'"
cQuery		+= " AND PC.D_E_L_E_T_ <> '*'" 
cQuery		+= " AND P9.D_E_L_E_T_ <> '*'" 
cQuery		+= " AND P9_FILIAL = '"+cFilSP9 +"'"

cQuery		+= " UNION ALL"
cQuery		+= " SELECT P9.P9_CODIGO PK_CODABO, 'AS' AS P6_TPABO,PH_DATA AS PK_DATA "
cQuery		+= " FROM "+RETSQLNAME("SPH")+" PC,"+RETSQLNAME("SP9")+" P9"
cQuery		+= " WHERE PC.PH_FILIAL = '" + cFilSPK + "'"
cQuery		+= " AND PC.PH_MAT = '"+ cMatSPK  + "'"
cQuery		+= " AND PC.PH_DATA BETWEEN '"+dtos(dDtDeSPK)+"' AND '"+dtos(dDtAteSPK)+"'"
cQuery      += " AND (PC.PH_ABONO = '' OR (PC.PH_ABONO <> '' AND PC.PH_QUANTC > PC.PH_QTABONO))"
cQuery      += " AND PC.PH_PDI = '   '"
cQuery      += " AND PC.PH_PD = P9.P9_CODIGO"
cQuery      += " AND P9.P9_IDPON IN ('008A','012A','014A','020A')"
cQuery      += " AND P9.P9_BHORAS <> 'S'"
cQuery		+= " AND PC.D_E_L_E_T_ <> '*'" 
cQuery		+= " AND P9.D_E_L_E_T_ <> '*'" 
cQuery		+= " AND P9_FILIAL = '"+cFilSP9 +"'"

//ADVERTENCIAS
cQuery		+= " UNION ALL"
cQuery		+= " SELECT ' ' AS PK_CODABO, 'AV' AS P6_TPABO,TO8_DTOCOR AS PK_DATA "
cQuery		+= " FROM "+RETSQLNAME("TO8")+" TO8"
cQuery		+= " WHERE"
cQuery		+= " TO8.D_E_L_E_T_ <> '*' "
cQuery		+= " AND TO8_GRAVID IN ('1','2')"
cQuery		+= " AND TO8_FILIAL = '" + cFilSPK + "'"
cQuery		+= " AND TO8_MAT = '"+ cMatSPK  + "'"
cQuery		+= " AND TO8_DTOCOR BETWEEN '"+dtos(dDtDeSPK)+"' AND '"+dtos(dDtAteSPK)+"'"

//MEDIDAS DISCIPLINATES
cQuery		+= " UNION ALL"
cQuery		+= " SELECT ' ' AS PK_CODABO, 'SP' AS P6_TPABO,TIT_DATA AS PK_DATA "
cQuery		+= " FROM "+RETSQLNAME("TIT")+" TIT"
cQuery		+= " WHERE"
cQuery		+= " TIT.D_E_L_E_T_ <> '*' "
cQuery		+= " AND TIT_TIPO = '1'
cQuery		+= " AND TIT_FILIAL = '" + cFilSPK + "'
cQuery		+= " AND TIT_MAT = '"+ cMatSPK  + "'"
cQuery		+= " AND TIT_DATA BETWEEN '"+dtos(dDtDeSPK)+"' AND '"+dtos(dDtAteSPK)+"'"


//SUSPENSOES
cQuery		+= " UNION ALL"
cQuery		+= " SELECT ' ' AS PK_CODABO, 'SP' AS P6_TPABO,TO8_DTOCOR AS PK_DATA "
cQuery		+= " FROM "+RETSQLNAME("TO8")+" TO8"
cQuery		+= " WHERE"
cQuery		+= " TO8.D_E_L_E_T_ <> '*' "
cQuery		+= " AND TO8_GRAVID IN ('3')"
cQuery		+= " AND TO8_FILIAL = '" + cFilSPK + "'"
cQuery		+= " AND TO8_MAT = '"+ cMatSPK  + "'"
cQuery		+= " AND TO8_DTOCOR BETWEEN '"+dtos(dDtDeSPK)+"' AND '"+dtos(dDtAteSPK)+"'"
cQuery		+= " ORDER BY 3,2,1

TCQuery cQuery New Alias "EPSPK6"		      
TcSetField( "EPSPK6", "PK_DATA", "D",08, 0 )

RestArea( aAreaSRA )

dbSelectArea("EPSPK6")
dbGotop()
While EPSPK6->(!Eof())
	AAdd(aMotivos,{EPSPK6->PK_DATA,EPSPK6->P6_TPABO,EPSPK6->PK_CODABO})
	EPSPK6->(dbSkip())
Enddo

EPSPK6->(dbCloseArea())

//Adiciona F้rias
aFerias := {}
aDoenca := {}
aAcid   := {}
aMater  := {}
dbSelectArea("SR8")
dbSetOrder(1)
If dbSeek(SRA->RA_FILIAL+SRA->RA_MAT)
	While !Eof() .And. SRA->RA_FILIAL+SRA->RA_MAT == SR8->R8_FILIAL+SR8->R8_MAT
		If SR8->R8_TIPOAFA = "001" .And. (dDtDeSPK >= SR8->R8_DATAINI .Or. (dDtDeSPK <= SR8->R8_DATAFIM .Or. Empty(SR8->R8_DATAFIM)))
			AAdd(aFerias,{SR8->R8_DATAINI,IIf(Empty(SR8->R8_DATAFIM),dDtAteSPK,SR8->R8_DATAFIM)})
		ElseIf SR8->R8_TIPOAFA = "004" .And. (dDtDeSPK >= SR8->R8_DATAINI .Or. (dDtDeSPK <= SR8->R8_DATAFIM .Or. Empty(SR8->R8_DATAFIM)))
			AAdd(aDoenca,{SR8->R8_DATAINI,IIf(Empty(SR8->R8_DATAFIM),dDtAteSPK,SR8->R8_DATAFIM)})
		ElseIf SR8->R8_TIPOAFA = "003" .And. (dDtDeSPK >= SR8->R8_DATAINI .Or. (dDtDeSPK <= SR8->R8_DATAFIM .Or. Empty(SR8->R8_DATAFIM)))
			AAdd(aAcid,{SR8->R8_DATAINI,IIf(Empty(SR8->R8_DATAFIM),dDtAteSPK,SR8->R8_DATAFIM)})
		ElseIf SR8->R8_TIPOAFA $ "006/007/008" .And. (dDtDeSPK >= SR8->R8_DATAINI .Or. (dDtDeSPK <= SR8->R8_DATAFIM .Or. Empty(SR8->R8_DATAFIM)))
			AAdd(aMater,{SR8->R8_DATAINI,IIf(Empty(SR8->R8_DATAFIM),dDtAteSPK,SR8->R8_DATAFIM)})
		Endif
		dbSelectArea("SR8")
		dbskip()
	Enddo
Endif

For z := dDtDeSPK to dDtAteSPK
	If aScan( aFerias, { |x| z >= x[1] .And. z <= x[2] } ) > 0
		AAdd(aMotivos,{z,"FE","  "})
	Endif
	If aScan( aDoenca, { |x| z >= x[1] .And. z <= x[2] } ) > 0
		AAdd(aMotivos,{z,"AD","  "})
	Endif
	If aScan( aAcid, { |x| z >= x[1] .And. z <= x[2] } ) > 0
		AAdd(aMotivos,{z,"AC","  "})
	Endif
	If aScan( aMater, { |x| z >= x[1] .And. z <= x[2] } ) > 0
		AAdd(aMotivos,{z,"LM","  "})
	Endif
Next z

aSort( aMotivos,,,{ |x,y| x[1] < y[1] } )	

Return()         
