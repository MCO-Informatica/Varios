#INCLUDE "FIVEWIN.CH"

Static cAliasTop

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ImpOpCb  ³ Autor ³ Luiz Alberto          ³ Data ³ 13.11.15 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Ordens de Producao em Código de Barras Grafico             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Intercarta                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
User Function ImpOpCb()
Local aArea := GetArea()    
Local aPosCb := {	{08.5,07,14},;
					{11.5,07,14},;
					{14.5,07,14},;
					{17.5,07,14},;
					{23.5,07,14},;
					{08.5,07,14},;
					{11.5,07,14},;
					{14.5,07,14},;
					{17.5,07,14},;
					{23.5,07,14},;
					{08.5,07,14},;
					{11.5,07,14},;
					{14.5,07,14},;
					{17.5,07,14},;
					{23.5,07,14},;
					{08.5,07,14},;
					{11.5,07,14},;
					{14.5,07,14},;
					{17.5,07,14},;
					{23.5,07,14},;
					{08.5,07,14},;
					{11.5,07,14},;
					{14.5,07,14},;
					{17.5,07,14},;
					{23.5,07,14},;
					{08.5,07,14},;
					{11.5,07,14},;
					{14.5,07,14},;
					{17.5,07,14},;
					{23.5,07,14}}
					
Private lVer116   := (VAL(GetVersao(.F.)) == 11 .And. GetRpoRelease() >= "R6" .Or. VAL(GetVersao(.F.))  > 11)
Private aArray	 := {}
Private cPerg	 := PadR('IMPOP',10)

AjustaSX1(cPerg)

Pergunte(cPerg,.f.)

MV_PAR01 := SC2->C2_NUM + SC2->C2_ITEM + SC2->C2_SEQUEN + SC2->C2_ITEMGRD
MV_PAR02 := SC2->C2_NUM + SC2->C2_ITEM + SC2->C2_SEQUEN + SC2->C2_ITEMGRD

oPrn  := TMSPrinter():New()
oPrn:SetPortrait()
If !oPrn:Setup()
	Return
Endif

cCepPict:=PesqPict("SA1","A1_CEP")
cCGCPict:=PesqPict("SA1","A1_CGC")

oFont1 := TFont():New( "Arial",,16,,.t.,,,,,.f. )
oFont2 := TFont():New( "Arial",,14,,.T.,,,,,.f. )
oFont3 := TFont():New( "Arial",,12,,.t.,,,,,.f. )
oFont3b := TFont():New( "Arial",,12,,.t.,,,,,.f. )
oFont4 := TFont():New( "Arial",,10,,.f.,,,,,.f. )
oFont4b := TFont():New( "Arial",,10,,.T.,,,,,.f. )
oFont5 := TFont():New( "Arial",,06,,.t.,,,,,.f. )
oFont6 := TFont():New( "Arial",,08,,.f.,,,,,.f. )
oFont6b := TFont():New( "Arial",,08,,.t.,,,,,.f. )
oFont7b := TFont():New( "Arial",,12,,.t.,,,,,.f. )
oFont8 := TFont():New( "Arial",,14,,.f.,,,,,.f. )
oFont9 := TFont():New( "Arial",,10,,.t.,,,,,.f. )
oFont10:= TFont():New( "Arial",,12,,.f.,,,,,.f. )
oFont18:= TFont():New( "Arial",,18,,.t.,,,,,.f. )
oFont18S:= TFont():New( "Arial",,18,,.f.,,,,,.f. )
oFont24:= TFont():New( "Arial",,16,,.t.,,,,,.f. )

oFont1c := TFont():New( "Courier New",,16,,.t.,,,,,.f. )
oFont2c := TFont():New( "Courier New",,16,,.f.,,,,,.f. )
oFont3c := TFont():New( "Courier New",,10,,.t.,,,,,.f. )
oFont4c := TFont():New( "Courier New",,10,,.f.,,,,,.f. )
oFont5c := TFont():New( "Courier New",,09,,.t.,,,,,.f. )
oFont6c := TFont():New( "Courier New",,09,,.T.,,,,,.f. )
oFont7c := TFont():New( "Courier New",,14,,.t.,,,,,.f. )
oFont8c := TFont():New( "Courier New",,10,,.f.,,,,,.f. )
oFont9c := TFont():New( "Courier New",,12,,.t.,,,,,.f. )
oFont10c:= TFont():New( "Courier New",,12,,.f.,,,,,.f. )
oBrush  := TBrush():NEW("",CLR_HGRAY)          

cQuery := "SELECT SC2.C2_FILIAL, SC2.C2_NUM, SC2.C2_ITEM, SC2.C2_SEQUEN, SC2.C2_ITEMGRD, SC2.C2_DATPRF, "
cQuery += "SC2.C2_DATRF, SC2.C2_PRODUTO, SC2.C2_DESTINA, SC2.C2_PEDIDO, SC2.C2_ROTEIRO, SC2.C2_QUJE, "
cQuery += "SC2.C2_PERDA, SC2.C2_QUANT, SC2.C2_DATPRI, SC2.C2_CC, SC2.C2_DATAJI, SC2.C2_DATAJF, "
cQuery += "SC2.C2_STATUS, SC2.C2_OBS, SC2.C2_TPOP, "
cQuery += "SC2.R_E_C_N_O_  SC2RECNO FROM "+RetSqlName("SC2")+" SC2 WHERE "
cQuery += "SC2.C2_FILIAL='"+xFilial("SC2")+"' AND SC2.D_E_L_E_T_=' ' AND "
cQuery += "SC2.C2_NUM + SC2.C2_ITEM + SC2.C2_SEQUEN + SC2.C2_ITEMGRD BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "' "
cQuery += "ORDER BY SC2.C2_FILIAL, SC2.C2_DATPRF"
cQuery := ChangeQuery(cQuery)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TMPX1',.T.,.T.)

Count To nReg

nLin := 5000

TMPX1->(dbGoTop())
While TMPX1->(!Eof())              
	SC2->(dbGoTo(TMPX1->SC2RECNO))

	cNumOp	:= SC2->C2_NUM + SC2->C2_ITEM + SC2->C2_SEQUEN + SC2->C2_ITEMGRD
	
	nLin := 5000
	
	While SC2->(!Eof()) .And. cNumOp == SC2->C2_NUM + SC2->C2_ITEM + SC2->C2_SEQUEN + SC2->C2_ITEMGRD	
		If nLin > 2800
			If nLin <> 5000
				oPrn:EndPage()
			Endif
			Cabec()
		Endif
		
		//-- Valida se a OP deve ser Impressa ou n„o
	//	If !MtrAValOP(mv_par10,"SC2",cAliasTop)
	//		dbSkip()
	//		Loop
	//	EndIf
		
		cProduto  := SC2->C2_PRODUTO
		nQuant    := aSC2Sld('SC2')
		
		SB1->(dbSetOrder(1), dbSeek(xFilial("SB1")+cProduto))
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Adiciona o primeiro elemento da estrutura , ou seja , o Pai  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		SD4->(dbSetOrder(2), dbSeek(xFilial("SD4")+SC2->(C2_NUM+C2_ITEM+C2_SEQUEN)))
		
		AddAr820(nQuant)
		
		MontStruc(SC2->(C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD),nQuant)
		
		aSort( aArray,2,, { |x, y| (x[1]+x[8]) < (y[1]+y[8]) } )
	
		cSeekWhile := "SG2->(G2_FILIAL+G2_PRODUTO+G2_CODIGO)"
		dbSelectArea("SG2")                                                      
		dbSetOrder(1)
		If SG2->(dbSetOrder(1), dbSeek(xFilial("SG2")+aArray[1][1]+aArray[1][9]))   //a630SeekSG2(1,aArray[1][1],xFilial("SG2")+aArray[1][1]+aArray[1][9],@cSeekWhile) 
			nConta    := 1   
			While SG2->(!Eof()) .And. SG2->(G2_FILIAL+G2_PRODUTO+G2_CODIGO) == xFilial("SG2")+aArray[1][1]+aArray[1][9]
				
				If nLin > 2800 .Or. nConta > 4
					nConta := 1
					oPrn:EndPage()
					Cabec()
				Endif
	
				dbSelectArea("SH1")
				dbSeek(xFilial()+SG2->G2_RECURSO)                     
				
				cBar:= SC2->C2_NUM + SC2->C2_ITEM + SC2->C2_SEQUEN + SG2->G2_OPERAC
						
				oPrn:Say( nLin, 0050, SG2->G2_OPERAC+'a. '+Capital(SUBS(Iif(Empty(SG2->G2_RECURSO),SG2->G2_DESCRI,SH1->H1_DESCRI),1,25)),oFont2,100 )
	
				MSBAR("CODE128",aPosCb[nConta,1],aPosCb[nConta,2],cBar+'11',oPrn,.F.,Nil,Nil,0.025,1.5,Nil,Nil,"A",.F.)
				MSBAR("CODE128",aPosCb[nConta,1],aPosCb[nConta,3],cBar+'22',oPrn,.F.,Nil,Nil,0.025,1.5,Nil,Nil,"A",.F.) 
	
				nLin+=325       
				nConta++        
				cOpera	:=	SG2->G2_OPERAC
	                    
	        	SG2->(dbSkip(1))
	   		Enddo
	   		nLin:=2700  
	   		nConta := 5
			oPrn:Say( nLin, 0050, 'Encerramento da O.P.',oFont2,100 )
	
			cBar:= SC2->C2_NUM + SC2->C2_ITEM + SC2->C2_SEQUEN + cOpera
			
			MSBAR("CODE128",aPosCb[nConta,1],aPosCb[nConta,2],cBar+'88',oPrn,.F.,Nil,Nil,0.025,1.5,Nil,Nil,"A",.F.)
	   		
	   		nLin:=3100
			oPrn:Say( nLin, 0050, SC2->C2_OBS,oFont2,100 )
	   	Endif
	   	
	   	SC2->(dbSkip(1))
   	Enddo	     
   	oPrn:EndPage()

   	TMPX1->(dbSkip(1))
Enddo

TMPX1->(dbCloseArea())

dbSelectArea("SC2")
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se em disco, desvia para Spool                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oPrn:Preview()
MS_FLUSH()
Return

Static Function Cabec()

oPrn:StartPage()
oPrn:Say( 0050, 0020, " ",oFont1,100 ) // startando a impressora

oPrn:Box( 0050, 0020, 2950, 2300) // Box Total  
oPrn:Box( 0050, 0020, 0309, 2300) // Box Divisao Cabecalho
oPrn:Box( 2950, 0020, 3300, 2300) // Box Observa;'oes

cLogo      	:= FisxLogo("1")

oPrn:SayBitmap( 0080,030,cLogo,0200,0200)

oPrn:Say( 0050, 0900, 'ORDEM DE PRODUÇÃO',oFont24,100 )

oPrn:Say( 0015, 2000, 'Emissao: ' + DtoC(SC2->C2_EMISSAO),oFont6,100 )

/*oPrn:Say( 0170, 0400, SM0->M0_NOMECOM,oFont24,100 )
oPrn:Say( 0250, 0400, SM0->M0_ENDENT,oFont9,100 )
oPrn:Say( 0300, 0400, TransForm(SM0->M0_CEPENT,cCepPict) + ' - ' + AllTrim(SM0->M0_CIDENT) + ' - ' + AllTrim(SM0->M0_ESTENT),oFont9,100 )
oPrn:Say( 0350, 0400, 'CNPJ: ' + TransForm(SM0->M0_CGC,cCGCPict) + ' IE.: ' + SM0->M0_INSC,oFont9,100 )
	*/

cProduto := SC2->C2_PRODUTO
//SZU->(dbSetOrder(1), dbSeek(xFilial("SZU")+SubStr(cProduto,4,6)))
SB1->(dbSetOrder(1), dbSeek(xFilial("SB1")+SC2->C2_PRODUTO))

oPrn:Say( 0320, 0050, 'Número OP:' ,oFont9c,100 )
oPrn:Say( 0320, 0500, (SC2->C2_NUM + SC2->C2_ITEM + SC2->C2_SEQUEN + SC2->C2_ITEMGRD),oFont9c,100 )
oPrn:Say( 0380, 0050, 'Cliente Prod:' ,oFont9c,100 )
//oPrn:Say( 0380, 0500, Capital(SZU->ZU_DESCR),oFont9c,100 )

oPrn:Say( 0320, 0800, 'Cores:' ,oFont9c,100 )

//oPrn:Say( 0320, 1450, 'Variação:' ,oFont9c,100 )
//oPrn:Say( 0320, 1680, Iif(SC2->(FieldPos("C2_ZVARIAC"))>0 .And. SC2->C2_ZVARIAC=='1','Sim','Nao'),oFont9c,100 )

oPrn:Say( 0320, 1800, '1a.Un:' ,oFont9c,100 )
oPrn:Say( 0320, 1950, SB1->B1_UM,oFont9c,100 )

oPrn:Say( 0320, 2070, '2a.Un:' ,oFont9c,100 )
oPrn:Say( 0320, 2220, SB1->B1_SEGUM,oFont9c,100 )

/*oPrn:Say( 0320, 1000, SB1->B1_ZCODCO1,oFont3b,100 )
oPrn:Say( 0320, 1110, SB1->B1_ZCODCO2,oFont3b,100 )
oPrn:Say( 0320, 1220, SB1->B1_ZCODCO3,oFont3b,100 )
oPrn:Say( 0320, 1330, SB1->B1_ZCODCO4,oFont3b,100 )
  */

oPrn:Say( 0440, 0050, 'Produto:' ,oFont9c,100 )
oPrn:Say( 0440, 0500, SC2->C2_PRODUTO,oFont9c,100 )

oPrn:Say( 0440, 1100, 'Qtde:' ,oFont9c,100 )
oPrn:Say( 0440, 1600, TransForm(SC2->C2_QUANT,'@E 9,999,999.99')+' '+Capital(SC2->C2_UM),oFont9c,,,,1)

oPrn:Say( 0440, 1700, 'Qtde:' ,oFont9c,100 )
oPrn:Say( 0440, 2200, TransForm(SC2->C2_QTSEGUM,'@E 9,999,999.99')+' '+Capital(SC2->C2_SEGUM),oFont9c,,,,1)

oPrn:Say( 0380, 1700, 'Produz:__________ Kg' ,oFont9c,100 )

oPrn:Say( 0500, 0050, 'Descrição:' ,oFont9c,100 )
oPrn:Say( 0500, 0500, SB1->B1_DESC,oFont9c,100 )


oPrn:Box( 0600, 0020, 0700, 2300) // Box Titulo Colunas
oPrn:FillRect({0601,0021,0699,2299},oBrush)

oPrn:Say( 0610, 0850, 'Roteiro de Operações',oFont18,100 )

oPrn:Box( 0700, 0020, 0800, 2300) // Box Dados do Favorecido
oPrn:Say( 0730, 0200, 'O R D E M',oFont18,100 )
oPrn:Say( 0730, 1000, 'I N I C I O',oFont18,100 )
oPrn:Say( 0730, 1920, 'F I M',oFont18,100 )

nLin := 1000

oPrn:Box( 2500, 0020, 2600, 2300) // Box Titulo Colunas
oPrn:FillRect({2501,0021,2599,2299},oBrush)

oPrn:Say( 2510, 0850, 'Encerramento da O.P.',oFont18,100 )
oPrn:Say( 2970, 0850, 'Observações:',oFont18,100 )

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ImpRodape³ Autor ³ Daniel G.Jr.TI1239    ³ Data ³ 22/12/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime o rodape do formulario e salta para a proxima folha³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ImpRodape(Void)   			         					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ 					                     				      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ RCOMR02                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ImpRodape()

oPrn:Say( 1730, 0070, "CONTINUA ..." ,oFont3,100 )

Return .T.



/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o   ³ AddAr820 ³ Autor ³ Paulo Boschetti       ³ Data ³ 07/07/92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o³ Adiciona um elemento ao Array                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Sintaxe  ³ AddAr820(ExpN1)                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpN1 = Quantidade da estrutura                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR820                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
Static Function AddAr820(nQuantItem)
Local cDesc   := SB1->B1_DESC
Local cLocal  := ""
Local cKey    := ""
Local cRoteiro:= ""   
Local nQtdEnd    
Local lExiste

Local lVer116   := (VAL(GetVersao(.F.)) == 11 .And. GetRpoRelease() >= "R6" .Or. VAL(GetVersao(.F.))  > 11)   

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se imprime nome cientifico do produto. Se Sim    ³
//³ verifica se existe registro no SB5 e se nao esta vazio    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cDesc := SB1->B1_DESC

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se imprime ROTEIRO da OP ou PADRAO do produto    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Empty(SC2->C2_ROTEIRO)
	cRoteiro:=SC2->C2_ROTEIRO
Else
	If !Empty(SB1->B1_OPERPAD)
		cRoteiro:=SB1->B1_OPERPAD
	Else
		dbSelectArea("SG2")
		If dbSeek(xFilial()+SC2->C2_PRODUTO+"01")
			cRoteiro:="01"
		EndIf
	EndIf
EndIf
 
If lVer116
	dbSelectArea("NNR")
	dbSeek(xFilial()+SD4->D4_LOCAL)
Else
	dbSelectArea("SB2")
	dbSeek(xFilial()+SB1->B1_COD+SD4->D4_LOCAL) 
EndIf

dbSelectArea("SD4")
cKey:=SD4->D4_COD+SD4->D4_LOCAL+SD4->D4_OP+SD4->D4_TRT+SD4->D4_LOTECTL+SD4->D4_NUMLOTE
cLocal:=SB2->B2_LOCALIZ
                                  
lExiste := .F.

If !lVer116
	DbSelectArea("SDC")
	DbSetOrder(2)
	DbSeek(xFilial("SDC")+cKey)
	While !Eof().And. SDC->(DC_PRODUTO+DC_LOCAL+DC_OP+DC_TRT+DC_LOTECTL+DC_NUMLOTE) == cKey 
		cLocal  :=DC_LOCALIZ      
		nQtdEnd :=DC_QTDORIG 
		
		AADD(aArray, {SB1->B1_COD,cDesc,SB1->B1_TIPO,SB1->B1_UM,nQtdEnd,SD4->D4_LOCAL,cLocal,SD4->D4_TRT,cRoteiro,If(mv_par12 == 1,SD4->D4_LOTECTL,""),If(mv_par12 == 1,SD4->D4_NUMLOTE,"") } )
		lExiste := .T. 
		dbSkip()
	end
endif 

dbSelectArea("SD4")

if !lExiste 
	If lVer116
		AADD(aArray, {SB1->B1_COD,cDesc,SB1->B1_TIPO,SB1->B1_UM,nQuantItem,SD4->D4_LOCAL,NNR->NNR_DESCRI,SD4->D4_TRT,cRoteiro,SD4->D4_LOTECTL,SD4->D4_NUMLOTE } )
	Else
		AADD(aArray, {SB1->B1_COD,cDesc,SB1->B1_TIPO,SB1->B1_UM,nQuantItem,SD4->D4_LOCAL,cLocal,SD4->D4_TRT,cRoteiro,SD4->D4_LOTECTL,SD4->D4_NUMLOTE } )
	EndIf
endif

Return
/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o   ³ MontStruc³ Autor ³ Ary Medeiros          ³ Data ³ 19/10/93 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o³ Monta um array com a estrutura do produto                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Sintaxe  ³ MontStruc(ExpC1,ExpN1,ExpN2)                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Codigo do produto a ser explodido                  ³±±
±±³          ³ ExpN1 = Quantidade base a ser explodida                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR820                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/
Static Function MontStruc(cOp,nQuant)

lItemNeg := .f.

dbSelectArea("SD4")
dbSetOrder(2)
dbSeek(xFilial()+cOp)

While !Eof() .And. D4_FILIAL+D4_OP == xFilial()+cOp
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Posiciona no produto desejado                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SB1")
	If dbSeek(xFilial()+SD4->D4_COD)
		If SD4->D4_QUANT > 0 .Or. (lItemNeg .And. SD4->D4_QUANT < 0)
			AddAr820(SD4->D4_QUANT)
		EndIf
	Endif
	dbSelectArea("SD4")
	dbSkip()
Enddo

dbSetOrder(1)

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AjustaSX1 ºAutor  ³Microsiga           º Data ³  12/16/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MetaLacre - Protheus 11                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


Static Function AjustaSX1(cPerg)

Local aAreaAtu	:= GetArea()
Local aAreaSX1	:= SX1->( GetArea() )
Local nTamanho  := (TAMSX3("C2_NUM")[1] + TAMSX3("C2_ITEM")[1] + TAMSX3("C2_SEQUEN")[1] + TAMSX3("C2_ITEMGRD")[1])


PutSx1(	cPerg, "01", "Ordem de Produção De  ? ", "" , "","Mv_ch1","C"                     ,nTamanho,                       0 , 2,"G","",   "SC2","","","Mv_par01","","","","","","","","","","","","","","","","",{"Informe a Ordem de Producao Inicial",""},{""},{""},"")
PutSx1(	cPerg, "02", "Ordem de Produção Ate ? ", "" , "","Mv_ch2","C"                     ,nTamanho,                       0 , 2,"G","",   "SC2","","","Mv_par02","","","","","","","","","","","","","","","","",{"Informe a Ordem de Producao Final",""},{""},{""},"")

RestArea( aAreaSX1 )
RestArea( aAreaAtu )

Return() 
