#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.CH"
#include "MSGRAPHI.CH"
#include "Ap5Mail.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma ณ RPCPR005 บAutor ณ Roberta                   บ Data ณ16/04/13บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Relatorio de OP                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico para Prozyn                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function RPCPR005()

	//**************************************************************************************
	//                              Define Variaveis
	//**************************************************************************************

	cabec1     :=""
	cabec2	  :=""
	wnrel      :="RPCPR005"
	Titulo     :="Ordem de Producao"
	cDesc1     :="Este relatorio vai emitir Ordem de Producao"
	cDesc2     :=""
	cDesc3     :=""
	cString    :="SC7"
	nElementos := 0
	nLastKey   := 0
	aReturn    := { "Especial", 1,"Compras", 1, 3, 1, "",1 } 
	nomeprog   := "RPCPR005"
	cPerg      := "RPCPR005"
	m_pag      := 1
	nTipo      := 15
	_cPed      := ""
	_dDtEntr   := Ctod("  /  /  ")
	_cCfop     := ""
	_cDesCF    := ""
	_cDesVen   := ""
	_cVend     := ""
	_cDesCon   := ""
	_cCond     := ""
	_Emissao   := Ctod("  /  /  ")
	_cSerie    := ""
	_cNotaFis  := ""
	_cNota     := ""
	_cObs      := ""
	_cIdComp   := ""
	_cPictQtde := ""


	Private oFont1:= TFont():New( "Arial",,10,,.f.,,,,,.f. )
	Private oFont2:= TFont():New( "Arial",,12,,.t.,,,,,.f. )
	Private oFont3:= TFont():New( "Arial",,12,,.t.,,,,,.F. )
	Private oFont4:= TFont():New( "Arial",,12,,.t.,,,,,.f. )
	Private oFont5:= TFont():New( "Arial",,16,,.t.,,,,,.F. )
	Private oFont6:= TFont():New( "Courier New",,14,,.t.,,,,,.f. )
	Private oFont7:= TFont():New( "Arial",,8,,.t.,,,,,.f. )
	Private oFont8:= TFont():New( "Arial",,6,,.t.,,,,,.f. )
	Private oFont9:= TFont():New( "Arial",,10,,.T.,,,,,.F. )
	Private Tamanho	:= "G"
	Private nQbr	:= 2000

	If Select("TMP1") > 0
		TMP1->(DbCloseArea())
	EndIF


	Private oPrn:=TMSPrinter():New()

	Private nPag:=1

	//**************************************************************************************
	//                     Verifica as perguntas selecionadas
	//**************************************************************************************

	ValidPerg()

	pergunte(cPerg,.F.)

	//**************************************************************************************
	//                    Envia controle para a funcao SETPRINT
	//**************************************************************************************

	wnrel:=SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.F.,"",.F.,Tamanho,"",.F.)

	If nLastKey == 27
		Return
	Endif

	SetDefault(aReturn,cString)

	If nLastKey == 27
		Return
	Endif

	//**************************************************************************************
	//                                Rotina RptDetail
	//**************************************************************************************
	SetPrvt("_NDESCFIN,_nDesFalt,_cFornece,_cPedido,_cLoja,_cUser,_nPag")

	RptStatus({|| RptDetail()})

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRCOMR005  บAutor  ณMicrosiga           บ Data ณ  10/06/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function RptDetail()

	Local x := 0          
	//Local nMicro	:= 0
	Local nMacro1		:= 0
	Local nMacro2		:= 0
	Local oBrush1 		:= TBrush():New( , CLR_HGRAY/*Rgb(245, 245, 240)*/ ) 
	Local lZebra		:= .T.
	Local nConvPv		:= 0
	Local lCabecNaoaler := .F.
	Local lCabecaler	:= .F.
	Local lCabecEmb		:= .F.

	Private cModPrep := ''

	//Valida็ใo do relatorio
	If !VldRel()
		Return
	EndIf

	oPrn:setup()
	oPrn:SetLandscape()//Paisagem
	oPrn:SetPaperSize(DMPAPER_A4)
	//oPrn:setportrait()  //retrato

	Dbselectarea("SC2")
	Dbsetorder(1)
	Set softseek on
	DBseek(xFilial("SC2") + MV_PAR01 )
	Set softseek off

	While !Eof().AND. SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN <= MV_PAR02

		If SC2->C2_EMISSAO < MV_PAR03 .OR. SC7->C7_EMISSAO > MV_PAR04
			Dbselectarea("SC2")
			Dbsetorder(1)
			DBSKIP()
			Loop
		Endif

		oPrn:StartPage()

		_cOP   := SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN
		_cProd := SC2->C2_PRODUTO
		_cRot  := IF(Empty(SC2->C2_ROTEIRO),"01",SC2->C2_ROTEIRO)
		_nLin := 50
		_nPag := 1 
		nTotMP  := 0
		nTotKg  := 0
		nTotint := 0

		nConvPv := Posicione("SB1",1,xFilial("SB1") + SC2->C2_PRODUTO, "B1_CONV")

		MSBAR("CODE128",04.8,25,Alltrim(_cOP),oPrn,.F.,,.T.,0.025,1.3,NIL,NIL,NIL,.F.)		//impressใo normal
		//MSBAR("CODE128",01.9,11.4,Alltrim(_cOP),oPrn,.F.,,.T.,0.018,0.5,NIL,NIL,NIL,.F.)		//impressใo normal

		oPrn:SayBitMap(_nLin+25,0050,"\system\logoproma.bmp",320,109)
		_nLin+=050
		oPrn:Say(_nLin,1300,"Ordem de Produ็ใo: " + _cOP,oFont5,100)

		If MV_PAR05 == 1
			oPrn:Say(_nLin+70,1550,"GRAMAS",oFont4,100)
		EndIf

		_nLin+=070
		oPrn:Say(_nLin,2900,"Pแgina:  " + Alltrim(STR(_nPag )),oFont2,100)

		_nLin+=100
		oPrn:Box(_nLin,0000,_nLin,3600)
		_nLin+=050

		oPrn:Say(_nLin,0050,"Produto: " + AllTrim(SC2->C2_PRODUTO) + " - "  + Posicione("SB1",1,xFilial("SB1") + Sc2->C2_PRODUTO,"B1_DESCINT"),oFont4,100)
		_nLin+=60
		oPrn:Say(_nLin,0050,"Lote: " + AllTrim(SC2->C2_LOTECTL),oFont2,100)
		oPrn:Say(_nLin,0500,"Validade: " + DTOC(SC2->C2_DTVALID),oFont2,100)
		oPrn:Say(_nLin,2900,"Emissใo: " + DTOC(SC2->C2_EMISSAO),oFont2,100)
		oPrn:Say(_nLin,2140,"CONFERIDO: ",oFont5,100)
		_nLin+=80
		oPrn:Say(_nLin,2140,"Por_____________",oFont5,100)
		_nLin+=60
		oPrn:Say(_nLin,0050,"Sala: "+SC2->C2_SALA + "      Misturador: "+SC2->C2_MISTURA+" - "+AllTrim(Posicione("SZP",1,xFilial("SZP") + SC2->C2_MISTURA,"ZP_MIST")) + "      Tempo de Mistura: __________" ,oFont1,100)
		_nLin+=60
		oPrn:Say(_nLin,0050,"Quantidade:  " + Iif(MV_PAR05==1,Transform(SC2->C2_QTSEGUM,X3PICTURE("C2_QTSEGUM")),Transform(SC2->C2_QUANT,X3PICTURE("C2_QUANT"))) + "      Saldo a Produzir: " + Iif(MV_PAR05==1,Transform(SC2->C2_QTSEGUM - (SC2->C2_QUJE*nConvPv), X3PICTURE("C2_QTSEGUM")),Transform(SC2->C2_QUANT - SC2->C2_QUJE, X3PICTURE("C2_QUANT"))) + "      Unidade: " + Iif(MV_PAR05==1,SC2->C2_SEGUM,SC2->C2_UM),oFont1,100)

		_nLin+=60


		// coletar oS resgitro referente a ultima informa็ใo da Op por produto
		// A QUERY ABAIXO IRA TRAZER TODOS OS REGISTROS
		cquery := "Select * "
		cquery += "From "+RetSqlName("SH6")+" SH6 "
		cquery += "Where SH6.H6_FILIAL  = '" + xFilial("SH6") + "' AND "
		cquery += "SH6.H6_PRODUTO = '" + _cProd +"'AND "
		cquery += "SH6.D_E_L_E_T_ <> '*' "
		cquery += "Order By H6_DTAPONT"  // ESTOU ORDENANDO POR DATA DE EMISSAO
		cquery :=ChangeQuery(cquery)
		dbUseArea(.T., "TOPCONN", TcGenQry(,,cquery), "eSH6")

		DbSelectArea("eSH6")

		_dDtaOP   := CTOD("  /  /  ")
		_cOrp     := ""
		_cProduto := ""
		_nQtdOp   := 0
		_cTempo   := ""

		While !EOF()
			If Alltrim(eSH6->H6_OP) <> _cOP
				_dDtaOP   := STOD(eSH6->H6_DATAINI)
				_cOrp     := eSH6->H6_OP
				_cProduto := eSH6->H6_PRODUTO
				_nQtdOp   := eSH6->H6_QTDPROD
				_cTempo   := (eSH6->H6_TEMPO)//ELAPTIME(SH6->H6_TEMPO)
			EndIf

			DbSelectArea("eSH6")
			DbSkip()
		Enddo

		//	eSC2->(DbCloseArea())
		eSH6->(DbCloseArea())

		// QUANDO TERMINAR O WHILE ACIMA VOCE TERA OS ULTIMOS DADOS GRAVADOS DA OP POR PRODUTO ORDENADO POR DATA
		// E SO IMPRIMIR AS VARIAVEIS ( _dDtaOP,_cOrp,_nQtdOp )
		oPrn:Say(_nLin,0050,"Controle de Peneira:  [___] Conforme  [___] Nใo Conforme          Manuten็ใo corretiva:  [___] Sim  [___] Nใo          Teve Limpeza  [___] Sim  [___] Nใo" + _cTempo,oFont1,100)
		_nLin += 60
		_nLin+=100
		oPrn:Box(_nLin,0000,_nLin,3600)
		_nLin+=50

		oPr := ReturnPrtObj()
		cCode := _cOP


		//MSBAR3("CODE128",_nlin+400,0.5,Alltrim(cCode),oPr,Nil,Nil,Nil,nil ,1.5 ,Nil,Nil,Nil)

		If _nLin > nQbr  //2400
			_nPag++
			oPrn:EndPage()
			oPrn:StartPage()
			_nLin := 50
		Endif

		oPrn:Say(_nLin,0050,"C๓digo",oFont4,100)
		oPrn:Say(_nLin,0250,"Descri็ใo",oFont4,100)
		If MV_PAR05 == 1
			//oPrn:Say(_nLin,1100,"Qtd.Gramas",oFont1,100)
		Else
			oPrn:Say(_nLin,1190,"QTD",oFont4,100)
		EndIf
		oPrn:Say(_nLin,1300,"UM",oFont4,100)
		oPrn:Say(_nLin,1400,"Arm",oFont4,100)
		oPrn:Say(_nLin,1550,"Lote",oFont4,100)

		If MV_PAR05 == 2
			//oPrn:Say(_nLin,1850,"Decimal",oFont1,100)
			//oPrn:Say(_nLin,2050,"___________",oFont1,100)
			oPrn:Say(_nLin,2350,"Kg",oFont4,100)
			oPrn:Say(_nLin,2500,"___________",oFont1,100)
			oPrn:Say(_nLin,2800,"Inteiro",oFont4,100)
			oPrn:Say(_nLin,3000,"___________",oFont1,100)
		Else
			oPrn:Say(_nLin,1950,"___________________________________________________",oFont1,100)
		EndIf


		//Se a Quantidade a ser produzida for Menor que 5 deverแ apresenta 5 casas decimais, caso contrแrio deve-se apresentar 3 casas. Por CR - Valdimari Martins - 01/02/2017 
		//if SC2->C2_QUANT >= 5
		_cPictQtde :=  "@E 999,999.999"
		/*else  
		_cPictQtde :=  "@E 9,999.99999"
		endif*/

		//imprimindo os empenhos
		DbselectArea("SD4") //empenhos
		DbSetOrder(2) //num op + produto
		If DbSeek(xFilial("SD4") + _cOP + SPACE(2))         //o numero da OP na SD4 tem 13 caracteres 

			CQRY := " SELECT B1.B1_COD, D4.D4_COD, D4.D4_LOTECTL, B1.B1_UM, B1.B1_SEGUM, B1.B1_TIPO, B1_SNALERG, B1.B1_SNALERG, B1.B1_QE, B1.B1_DESC, D4.D4_LOCAL, SUM(D4.D4_QTSEGUM) AS D4_QTSEGUM, SUM(D4.D4_QTDEORI) AS D4_QTDEORI, D4.D4_OP FROM SD4010  D4 "
			CQRY += " INNER JOIN SB1010 B1 ON B1.B1_COD = D4.D4_COD "
			CQRY += " AND B1.D_E_L_E_T_ = ' '"
			CQRY +=	" AND B1_TIPO != 'MO' "
			CQRY += " WHERE  D4_OP = '"+_cOP+"'"
			CQRY += " AND D4.D_E_L_E_T_ =' '  "
			CQRY += " GROUP BY D4.D4_OP, B1.B1_COD, D4.D4_COD, D4.D4_LOTECTL, B1.B1_UM,B1.B1_SEGUM, B1.B1_TIPO, B1_SNALERG, B1.B1_SNALERG, B1.B1_QE,B1.B1_DESC, D4.D4_LOCAL "
			CQRY += " ORDER BY  B1.B1_SNALERG, B1.B1_TIPO DESC"
			CQRY :=CHANGEQUERY(	CQRY )  
			If select("TMP1") > 0 
				Dbselectarea("TMP1")
				DBCLOSEAREA()
			endif
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,CQRY),"TMP1",.T.,.F.)

			
		While !TMP1->(EOF())
			
			If  TMP1->B1_SNALERG == "2" .and.  TMP1->B1_TIPO <> "EM" .and. !lCabecNaoaler
				_nLin+=050
				oPrn:Say(_nLin+30,300,"                                                                                              ***		NรO ALERGสNICOS		***                                                                ",oFont4,300)
				_nLin+=050
				lCabecNaoaler := .T.
			ElseIf TMP1->B1_SNALERG == " " .and. TMP1->B1_TIPO <> "EM" .and. !lCabecNaoaler
				_nLin+=050
				oPrn:Say(_nLin+30,300,"                                                                                              ***		NรO ALERGสNICOS		***                                                                ",oFont4,300)
				_nLin+=050
				lCabecNaoaler := .T.
			ElseIf  TMP1->B1_SNALERG == "1"  .and. TMP1->B1_TIPO <> "EM" .and.  !lCabecaler
				_nLin+=050
				oPrn:Say(_nLin+30,300,"                                                                                              ***		ALERGสNICOS		***                                                                ",oFont4,300)
				_nLin+=050
				lCabecaler := .T.
			ElseIf TMP1->B1_TIPO == "EM" .and. !lCabecEmb	
				_nLin+=050
				oPrn:Say(_nLin+30,300,"                                                                                              ***		EMBALAGEM		***                                                                ",oFont4,300)
				_nLin+=050
				lCabecEmb:= .T.
			EndIf
				
			
			If lZebra
				oPrn:FillRect( {45+_nLin, 45, 97+_nLin, 3300}, oBrush1 )
				lZebra := .F.
			Else
				lZebra := .T.
			EndIf  

				DbSelectArea("SDC")   //cadastro de endere็o
				DbSetOrder(2)        //produto, arm, endereco
				If DbSeek(xFilial("SDC") + TMP1->D4_COD + TMP1->D4_LOCAL + TMP1->D4_OP)
					_cEnde := SDC->DC_LOCALIZ
				Else
					_cEnde := SPACE(15)
				Endif
				_nLin := _nLin + 50
				oPrn:Say(_nLin,0050,TMP1->D4_COD,oFont1,100)
				oPrn:Say(_nLin,0250,TMP1->B1_DESC,oFont1,100)
				If MV_PAR05 == 2 .Or. Alltrim(TMP1->B1_TIPO) == 'EM'
					oPrn:Say(_nLin,1280,Transform(NOROUND(TMP1->D4_QTDEORI,3), _cPictQtde),oFont1,100,,,1)
					oPrn:Say(_nLin,1300,TMP1->B1_UM,oFont1,100)
				Else
					oPrn:Say(_nLin,1280,Transform(NOROUND(TMP1->D4_QTSEGUM,3), _cPictQtde),oFont1,100,,,1)
					oPrn:Say(_nLin,1300,TMP1->B1_SEGUM ,oFont1,100)
				EndIf

				oPrn:Say(_nLin,1400,TMP1->D4_LOCAL,oFont1,100)
				oPrn:Say(_nLin,1550,TMP1->D4_LOTECTL,oFont1,100)

				//nMicro	:= 0
				nMacro1	:= 0
				nMacro2	:= 0

				If UPPER(Alltrim(TMP1->B1_TIPO)) $ "MP|PI|PA"

					If MV_PAR05 == 2
						If TMP1->B1_QE == Int(TMP1->D4_QTDEORI)
							//nMicro	:= TMP1->D4_QTDEORI-Int(TMP1->D4_QTDEORI)
							nMacro1	:= TMP1->D4_QTDEORI - (int(TMP1->D4_QTDEORI/TMP1->B1_QE)*TMP1->B1_QE)
							nMacro2	:= int(TMP1->D4_QTDEORI - nMacro1)

						ElseIf TMP1->B1_QE < TMP1->D4_QTDEORI 
							//nMicro	:= TMP1->D4_QTDEORI-Int(TMP1->D4_QTDEORI)
							nMacro1	:= TMP1->D4_QTDEORI -  (int(TMP1->D4_QTDEORI/TMP1->B1_QE)*TMP1->B1_QE)
							nMacro2	:= int(TMP1->D4_QTDEORI - nMacro1) 

						Else
							//nMicro	:= TMP1->D4_QTDEORI-Int(TMP1->D4_QTDEORI)
							nMacro1	:= TMP1->D4_QTDEORI
							nMacro2	:= 0
						EndIf
					Else
						If TMP1->B1_QE == Int(TMP1->D4_QTSEGUM)
							//nMicro	:= TMP1->D4_QTSEGUM-Int(TMP1->D4_QTSEGUM)
							nMacro1	:= TMP1->D4_QTSEGUM
							nMacro2	:= int(TMP1->D4_QTSEGUM) - nMacro1 

						ElseIf TMP1->B1_QE < TMP1->D4_QTSEGUM 
							//nMicro	:= TMP1->D4_QTSEGUM-Int(TMP1->D4_QTSEGUM)
							nMacro1	:= TMP1->D4_QTDEORI -  (int(TMP1->D4_QTDEORI/TMP1->B1_QE)*TMP1->B1_QE)
							nMacro2	:= int(TMP1->D4_QTSEGUM) - nMacro1 

						Else
							//nMicro	:= TMP1->D4_QTSEGUM-Int(TMP1->D4_QTSEGUM)
							nMacro1	:= TMP1->D4_QTSEGUM
							nMacro2	:= 0
						EndIf					
					EndIf
				nTotKg  += nMacro1
				nTotInt += nMacro2
				Else
					//nMicro	:= 0
					nMacro1	:= 0
					nMacro2	:= 0
				EndIf

				If MV_PAR05 == 2
					//oPrn:Say(_nLin,1980,Transform(NOROUND(nMicro,3)	, _cPictQtde),oFont1,100,,,1)
					//oPrn:Say(_nLin,2050,"_____________",oFont1,100)
					oPrn:Say(_nLin,2430,Transform(NOROUND(nMacro1,3)	, _cPictQtde),oFont1,100,,,1)
					oPrn:Say(_nLin,2500,"_____________",oFont1,100)
					oPrn:Say(_nLin,2930,Transform(NOROUND(nMacro2,3)	, _cPictQtde),oFont1,100,,,1)
					oPrn:Say(_nLin,3000,"_____________",oFont1,100)
				Else
					//oPrn:Say(_nLin,1980,Transform(NOROUND(nMicro,3)	, _cPictQtde),oFont1,100,,,1)
					oPrn:Say(_nLin,1950,"___________________________________________________",oFont1,100)
				EndIf

				If _nLin > nQbr
					_nPag++
					oPrn:EndPage()
					oPrn:StartPage()
					_nLin := 50
					oPrn:SayBitMap(_nLin+25,0050,"\system\logoproma.bmp",400,100)
					_nLin+=050
					oPrn:Say(_nLin,1300,"Ordem de Produ็ใo: " + _cOP,oFont4,100)

					If MV_PAR05 == 1
						oPrn:Say(_nLin+70,1550,"GRAMAS",oFont4,100)
					EndIf

					_nLin+=070
					oPrn:Say(_nLin,2900,"Pแgina:  " + Alltrim(STR(_nPag )),oFont2,100)
					_nLin+=100
					oPrn:Box(_nLin,0000,_nLin,3600)
					_nLin+=050

					oPrn:Say(_nLin,0050,"C๓digo",oFont1,100)
					oPrn:Say(_nLin,0250,"Descri็ใo",oFont1,100)
					oPrn:Say(_nLin,1100,"Quantidade",oFont1,100)
					oPrn:Say(_nLin,1300,"UM",oFont1,100)
					oPrn:Say(_nLin,1400,"Arm",oFont1,100)
					oPrn:Say(_nLin,1550,"Lote",oFont1,100)

					If MV_PAR05 == 2
						//oPrn:Say(_nLin,1850,"Decimal",oFont1,100)
						oPrn:Say(_nLin,2050,"Visto",oFont1,100)
						oPrn:Say(_nLin,2300,"Kg",oFont1,100)
						oPrn:Say(_nLin,2500,"Visto",oFont1,100)
						oPrn:Say(_nLin,2800,"Inteiro",oFont1,100)
						oPrn:Say(_nLin,3000,"Visto",oFont1,100)
					Else
						oPrn:Say(_nLin,2050,"Visto",oFont1,100)
					EndIf
				Endif

				If TMP1->B1_TIPO $ "MP|PI|PA"
					If MV_PAR05 == 2
						nTotMP += TMP1->D4_QTDEORI
					Else
						nTotMP += TMP1->D4_QTSEGUM
					EndIf
				EndIf

				//cadastro de endere็o
				TMP1->(DbSkip())
		enddo      

			_nLin := _nLin + 60   
			oPrn:Say(_nLin,0050,"TOTAL MP: ",oFont1,100)
			oPrn:Say(_nLin,1300,Transform(nTotMP, _cPictQtde),oFont1,100,,,1)
			oPrn:Say(_nLin,2450,Transform(nTotKg, _cPictQtde),oFont1,100,,,1)
			oPrn:Say(_nLin,2930,Transform(nTotInt, _cPictQtde),oFont1,100,,,1)
			lCabecNaoaler  := .F.
			lCabecaler	   := .F.
			lCabecEmb	   := .F.

		EndIF

		_nLin := _nLin + 60 
		oPrn:Say(_nLin,0050,"PESAGEM:         SACO PLASTICO:_________      LACRE PLASTICO:_________ ",oFont1,100)
		_nLin+=100
		oPrn:Box(_nLin,0000,_nLin,3600)

		//imprimir os recursos
		_cObs1     := ""
		DbSelectArea("SG2") //roteiro de operacoes
		DbSetOrder(1)       //produto, codigo do roteiro, operacao
		If DbSeek(xFilial("SG2") + _cProd + _cRot)
			while !EOF() .and. SG2->G2_PRODUTO + SG2->G2_CODIGO == _cProd + _cRot
				//_cObs1 := SG2->G2_OBS - //Comentado Bruno Rian 28/06
				If _nLin > nQbr
					_nPag++
					oPrn:EndPage()
					oPrn:StartPage()
					_nLin := 50
					oPrn:SayBitMap(_nLin+20,0050,"\system\logoproma.bmp",400,100)
					_nLin+=050
					oPrn:Say(_nLin,1300,"Ordem de Produ็ใo: " + _cOP,oFont4,100)

					If MV_PAR05 == 1
						oPrn:Say(_nLin+70,1550,"GRAMAS",oFont4,100)
					EndIf

					_nLin+=070
					oPrn:Say(_nLin,2900,"Pแgina:  " + Alltrim(STR(_nPag )),oFont2,100)
					_nLin+=100
					oPrn:Box(_nLin,0000,_nLin,3600)
				Endif

				_nLin := _nLin + 50
				oPrn:Say(_nLin,0050,"Recurso:  " + SG2->G2_RECURSO + " - " + Posicione("SH1",1,xFilial("SH1") + SG2->G2_RECURSO,"H1_DESCRI"),oFont1,100)
				oPrn:Say(_nLin,1200,"Opera็ใo: " + SG2->G2_OPERAC + " - " + SG2->G2_DESCRI,oFont1,100)
				_nLin := _nLin + 50

				//	_lPLinha:= .T.
				//If !Empty (SG2->G2_OBS) - Comentato Bruno Rian 28/06
					oPrn:Say(_nLin,0050,"Observa็๕es: " ,oFont1,100,,,)
					_nMens := MlCount(_cObs1,200)
					For x:= 1 to _nMens //mlcount serve para contar quantas linhas de tamanho 50 tem no campo memo
						oPrn:Say(_nlin,0250,Memoline(_cObs1,200,x),oFont1,100,,,3) // o x no memoline indica qual linha deve ser impressa.
						_nLin += 50

						oPrn:Say(_nLin,0050,"INอCIO: ________/________/________  _____:_____      TษRMINO: ________/________/________  _____:_____",oFont1,100,,,)
						_nLin+=50
						//	_lPLinha := .T.
					Next //assim o for ้ executado para o numero de linhas que tem no memo. o mesmo tamanho que esta no mlcount d
				//EndIf

				_nLin := _nLin + 50
				oPrn:Box(_nLin,0000,_nLin,3600)		
				DbSelectArea("SG2")
				DbSkip()
			Enddo
		Endif

		cModPrep := SC2->C2_YPREPA2

		Dbselectarea("SC2")
		Dbsetorder(1)
		DbSkip()

		Assinatura()

		oPrn:EndPage()

	Enddo

	oPrn:Preview()

	MS_FLUSH()

Return()


Static Function QuebraPag()
	If _nLin > nQbr
		_nPag++
		oPrn:EndPage()
		oPrn:StartPage()
		_nLin := 50
		oPrn:SayBitMap(_nLin+25,0050,"\system\logoproma.bmp",400,100)
		_nLin+=050
		oPrn:Say(_nLin,1300,"Ordem de Produ็ใo: " + _cOP,oFont4,100)

		If MV_PAR05 == 1
			oPrn:Say(_nLin+70,1550,"GRAMAS",oFont4,100)
		EndIf

		_nLin+=070
		oPrn:Say(_nLin,2900,"Pแgina:  " + Alltrim(STR(_nPag )),oFont2,100)
		_nLin+=100
		oPrn:Box(_nLin,0000,_nLin,3600)
		_nLin+=050

	EndIf

Return()


Static Function Assinatura()
	Local aModPrep	:= {}
	Local nX		:= 0
	_nLin+=70 

	//Nadia  
	cLinPrep := '' 
	lImptTit := .T.

	aModPrep := QbrTxtToArray(cModPrep,150, , .T.)
	For nX := 1 To Len(aModPrep)
		QuebraPag()
		oPrn:Say(_nLin,0050,Iif(lImptTit,"MODO PREPARO: ",Space(30)) + aModPrep[nX] ,oFont1,100,,,)
		_nLin+=70
		lImptTit := .F.
	Next

	QuebraPag()
	oPrn:Say(_nLin,0050,"DEPTO TษCNICO: __________________________________________________________________________",oFont1,100,,,)
	_nLin+=70
	QuebraPag()
	oPrn:Say(_nLin,0050,"PESAGEM: ________________________     INอCIO: ______/______/______  ____:____    TษRMINO: ______/______/______  ____:____		INอCIO: ______/______/______  ____:____    TษRMINO: ______/______/______  ____:____",oFont1,100,,,)
	_nLin+=70
	QuebraPag()
	oPrn:Say(_nLin,0050,"ADIวรO : ________________________     INอCIO: ______/______/______  ____:____    TษRMINO: ______/______/______  ____:____",oFont1,100,,,)
	_nLin+=70
	QuebraPag()
	oPrn:Say(_nLin,0050,"ENSAQUE: ________________________     INอCIO: ______/______/______  ____:____    TษRMINO: ______/______/______  ____:____",oFont1,100,,,)
	oPrn:Say(_nLin,2380,"CONFERIDO: ",oFont5,100)
	_nLin+=90
	oPrn:Say(_nLin,2380,"Por_______________ ",oFont5,100)
	_nLin+=90
	oPrn:Say(_nLin,2380,"Data_____/______/________",oFont5,100)
	QuebraPag()
	oPrn:Say(_nLin,0050,"QUANTIDADE TOTAL DE CAIXAS: _____________________________               QUANTIDADE PRODUZIDA(KG): ___________________",oFont1,100,,,)
	_nLin+=70

	QuebraPag()
	oPrn:Say(_nLin,0050,"APONTAMENTO DA OP: ___________________________________________",oFont1,100,,,)
	_nLin+=70

	//QuebraPag()
	//oPrn:Say(_nLin,0050,"ENDEREวAMENTO DA OP: _________________________________________",oFont1,100,,,)
	//_nLin+=70

	QuebraPag()
	oPrn:Say(_nLin,0050,"INSPEวรO DE QUALIDADE: ___________________________________________     DATA: ______/______/______  ____:____",oFont1,100,,,)
	_nLin+=70

	QuebraPag()
	oPrn:Say(_nLin,0050,"AMOSTRA DE RETENวรO RECEBIDA POR: ________________________________     DATA: ______/______/______  ____:____",oFont1,100,,,)
Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRCOMR005  บAutor  ณMicrosiga           บ Data ณ  10/06/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ValidPerg()

	Local i := 0
	Local j := 0

	_sAlias := Alias()
	dbSelectArea("SX1")
	dbSetOrder(1)
	cPerg := PADR(cPerg,10)
	aRegs :={}

	//------------------------------------------------------------------------------------
	//  Variaveis utilizadas para parametros
	//------------------------------------------------------------------------------------
	//   mv_par01                 // De  Pedido
	//   mv_par02                 // Ate Pedido
	//   mv_par03                 // Emissใo de
	//   mv_par04                 // Emissใo ate
	//   mv_par05                 // 2ชUM
	//------------------------------------------------------------------------------------

	AADD(aRegs,{cPerg,"01","De Ord.Producao                 ?","","","mv_ch1","C",11,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SC2",""})
	AADD(aRegs,{cPerg,"02","At้ Ord.Producao                ?","","","mv_ch2","C",11,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SC2",""})
	AADD(aRegs,{cPerg,"03","Emissใo de    					?","","","mv_ch3","D",08,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"04","Emissใo ate   					?","","","mv_ch4","D",08,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"05","Imprime 2ชUM                    ?","","","mv_ch5","N",01,0,0,"C","","mv_par05","Sim","","","","","Nao","","","","","","","","","","","","","","","","","","","",""})

	For i:=1 to Len(aRegs)
		If !dbSeek(cPerg+aRegs[i,2])
			RecLock("SX1",.T.)
			For j:=1 to FCount()
				If j <= Len(aRegs[i])
					FieldPut(j,aRegs[i,j])
				Else
					exit
				Endif
			Next
			MsUnlock()
		Endif
	Next

	dbSelectArea(_sAlias)

Return()


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVldRel  บAutor  ณMicrosiga           บ Data ณ  24/01/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Valida็ใo do relatorio                                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function VldRel()

	Local lRet			:= .T.
	Local cVldOpEmb		:= VldEmbOp()
	Local cVldQtdOpPd 	:= VldQtdOpPd()
	Local cVldD4G1		:= VldD4xG1()

	If !Empty(cVldOpEmb)
		Aviso("Valida็ใo-1", cVldOpEmb, {"Ok"},3)
		lRet := .F.
	EndIf

	If lRet .And. !Empty(cVldQtdOpPd)
		If Aviso("Valida็ใo-2", cVldQtdOpPd, {"Sim","Nใo"},3) == 1
			lRet := .F.
		EndIf
	EndIf

	If lRet .And. !Empty(cVldD4G1)
		Aviso("Valida็ใo-3", cVldD4G1, {"Ok"},3)
		lRet := .F.
	EndIf

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVldEmbOp  บAutor  ณMicrosiga           บ Data ณ  24/01/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Valida็ใo do cadastro da embalagem na OP                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function VldEmbOp()

	Local aArea 	:= GetArea()
	Local cQuery	:= ""
	Local cArqTmp	:= GetNextAlias()
	Local cRet		:= ""

	cQuery	:= " SELECT (SC2.C2_NUM+SC2.C2_ITEM+SC2.C2_SEQUEN) CHAVE, SC2.C2_NUM, "+CRLF
	cQuery	+= " SC2.C2_ITEM, SC2.C2_SEQUEN, SC2.C2_PRODUTO, B1_COD FROM "+RetSqlName("SC2")+" SC2 "+CRLF 

	cQuery	+= " INNER JOIN "+RetSqlName("SD4")+" SD4 "+CRLF
	cQuery	+= " ON SD4.D4_FILIAL = SC2.C2_FILIAL "+CRLF
	cQuery	+= " AND SD4.D4_OP = (SC2.C2_NUM+SC2.C2_ITEM+SC2.C2_SEQUEN) "+CRLF
	cQuery	+= " AND SD4.D_E_L_E_T_ = ' ' "+CRLF

	cQuery	+= " INNER JOIN "+RetSqlName("SB1")+" SB1 "+CRLF
	cQuery	+= " ON SB1.B1_FILIAL =  '"+xFilial("SB1")+"' "+CRLF
	cQuery	+= " AND SB1.B1_COD = SD4.D4_COD "+CRLF
	cQuery	+= " AND SB1.B1_TIPO = 'MP' "+CRLF
	cQuery	+= " AND SB1.B1_QE = '0' "+CRLF
	cQuery	+= " AND SB1.D_E_L_E_T_ = ' ' "+CRLF 

	cQuery	+= " WHERE SC2.C2_FILIAL = '"+xFilial("SC2")+"' "+CRLF
	cQuery	+= " AND (LTRIM(RTRIM(SC2.C2_NUM))+LTRIM(RTRIM(SC2.C2_ITEM))+LTRIM(RTRIM(SC2.C2_SEQUEN))) >= '"+MV_PAR01+"' "+CRLF
	cQuery	+= " AND (LTRIM(RTRIM(SC2.C2_NUM))+LTRIM(RTRIM(SC2.C2_ITEM))+LTRIM(RTRIM(SC2.C2_SEQUEN))) <= '"+MV_PAR02+"' "+CRLF
	cQuery	+= " AND SC2.D_E_L_E_T_ = ' ' "+CRLF
	cQuery	+= " ORDER BY C2_NUM, C2_ITEM, C2_SEQUEN, B1_COD "  

	DbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQuery) , cArqTmp,.T.,.T.)

	While (cArqTmp)->(!Eof())

		cRet += "-OP: "+(cArqTmp)->CHAVE+ "   Produto: "+Alltrim((cArqTmp)->B1_COD)+";"+CRLF

		(cArqTmp)->(DbSkip())
	EndDo

	If !Empty(cRet)
		cRet := "Existem produtos cadastrados sem a quantidade por embalagem  (B1_QE) preenchida: "+CRLF+cRet
	EndIf

	If Select(cArqTmp) > 0 
		(cArqTmp)->(DbCloseArea())
	EndIf

	RestArea(aArea)
Return cRet



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVldQtdOpPdบAutor  ณMicrosiga           บ Data ณ  12/06/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Valida็ใo da quantidade OP vs Produzido	                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                       	              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function VldQtdOpPd()

	Local aArea 	:= GetArea()
	Local cQuery	:= ""
	Local cArqTmp	:= GetNextAlias()
	Local cRet		:= ""

	cQuery	:= " SELECT (SC2.C2_NUM+SC2.C2_ITEM+SC2.C2_SEQUEN) CHAVE, "+CRLF
	cQuery	+= " C2_QUANT, SUM(D4_QTDEORI) D4_QTDEORI FROM "+RetSqlName("SC2")+" SC2 "+CRLF 

	cQuery	+= " INNER JOIN "+RetSqlName("SD4")+" SD4 "+CRLF
	cQuery	+= " ON SD4.D4_FILIAL = SC2.C2_FILIAL "+CRLF
	cQuery	+= " AND SD4.D4_OP = (SC2.C2_NUM+SC2.C2_ITEM+SC2.C2_SEQUEN) "+CRLF
	cQuery	+= " AND SD4.D_E_L_E_T_ = ' ' "+CRLF

	cQuery	+= " INNER JOIN "+RetSqlName("SB1")+" SB1 "+CRLF
	cQuery	+= " ON SB1.B1_FILIAL =  '"+xFilial("SB1")+"' "+CRLF
	cQuery	+= " AND SB1.B1_COD = SD4.D4_COD "+CRLF
	cQuery	+= " AND SB1.B1_TIPO IN('MP','PI','PA') "+CRLF
	cQuery	+= " AND SB1.D_E_L_E_T_ = ' ' "+CRLF 

	cQuery	+= " WHERE SC2.C2_FILIAL = '"+xFilial("SC2")+"' "+CRLF
	cQuery	+= " AND (LTRIM(RTRIM(SC2.C2_NUM))+LTRIM(RTRIM(SC2.C2_ITEM))+LTRIM(RTRIM(SC2.C2_SEQUEN))) >= '"+MV_PAR01+"' "+CRLF
	cQuery	+= " AND (LTRIM(RTRIM(SC2.C2_NUM))+LTRIM(RTRIM(SC2.C2_ITEM))+LTRIM(RTRIM(SC2.C2_SEQUEN))) <= '"+MV_PAR02+"' "+CRLF
	cQuery	+= " AND SC2.D_E_L_E_T_ = ' ' "+CRLF
	cQuery	+= " GROUP BY C2_NUM, C2_ITEM, C2_SEQUEN, C2_QUANT "
	cQuery	+= " ORDER BY C2_NUM, C2_ITEM, C2_SEQUEN "  

	DbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQuery) , cArqTmp,.T.,.T.)

	While (cArqTmp)->(!Eof())

		If (cArqTmp)->D4_QTDEORI != (cArqTmp)->C2_QUANT
			cRet += "-OP: "+(cArqTmp)->CHAVE+ " com diverg๊ncia da quantidade produzida "+;
			"(Qtd. Op ("+Alltrim(Str((cArqTmp)->C2_QUANT))+") | Qtd.Produz. ("+Alltrim(Str((cArqTmp)->D4_QTDEORI))+"));"+CRLF
		EndIf


		(cArqTmp)->(DbSkip())
	EndDo

	If !Empty(cRet)
		cRet := "Diverg๊ncia de dados entre OP x Produzido. Deseja cancelar a emissใo do relat๓rio ?"+CRLF+CRLF+cRet
	EndIf

	If Select(cArqTmp) > 0 
		(cArqTmp)->(DbCloseArea())
	EndIf

	RestArea(aArea)
Return cRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVldD4xG1	บAutor  ณMicrosiga           บ Data ณ  10/03/20   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Valida็ใo da quantidade de itens na SD4 x SG1              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                       	              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function VldD4xG1()

	Local aArea		:= GetArea()
	Local cArqTmp	:= GetNextAlias()
	Local cQuery	:= ""
	Local cRet		:= ""

	cQuery	:= " SELECT * FROM ( "+CRLF
	cQuery	+= " SELECT (LTRIM(RTRIM(SC2.C2_NUM))+LTRIM(RTRIM(SC2.C2_ITEM))+LTRIM(RTRIM(SC2.C2_SEQUEN))) OP, C2_PRODUTO, "+CRLF
	cQuery	+= " 	COUNT(DISTINCT SD4.D4_COD) CONTSD4, COUNT(DISTINCT SG1.G1_COMP) CONTSG1 "+CRLF
	cQuery	+= "  FROM "+RetSqlName("SC2")+" SC2 "+CRLF

	cQuery	+= " INNER JOIN "+RetSqlName("SG1")+" SG1 "+CRLF
	cQuery	+= " ON SG1.G1_FILIAL= '"+xFilial("SG1")+"' "+CRLF
	cQuery	+= " AND SG1.G1_COD = SC2.C2_PRODUTO "+CRLF
	cQuery	+= " AND SG1.D_E_L_E_T_ = ' ' "+CRLF
	cQuery	+= " AND EXISTS (SELECT 'X' FROM "+RetSqlName("SB1")+" SB1 "+CRLF
	cQuery	+= " 			WHERE SB1.B1_FILIAL = '"+xFilial("SB1")+"' "+CRLF
	cQuery	+= " 			AND SB1.B1_COD = SG1.G1_COMP "+CRLF
	cQuery	+= " 			AND SB1.B1_TIPO IN('MP','PI','PA') "+CRLF
	cQuery	+= " 			AND SB1.D_E_L_E_T_ = ' ' "+CRLF
	cQuery	+= " 			 ) "+CRLF

	cQuery	+= " LEFT JOIN "+RetSqlName("SD4")+" SD4 "+CRLF
	cQuery	+= " ON SD4.D4_FILIAL = SC2.C2_FILIAL "+CRLF
	cQuery	+= " AND SD4.D4_PRODUTO = SC2.C2_PRODUTO " +CRLF
	cQuery	+= " AND SD4.D4_OP = (LTRIM(RTRIM(SC2.C2_NUM))+LTRIM(RTRIM(SC2.C2_ITEM))+LTRIM(RTRIM(SC2.C2_SEQUEN))) "+CRLF
	cQuery	+= " AND SD4.D_E_L_E_T_ = ' ' "+CRLF
	cQuery	+= " AND EXISTS (SELECT 'X' FROM "+RetSqlName("SB1")+" SB1 "+CRLF
	cQuery	+= " 			WHERE SB1.B1_FILIAL = '"+xFilial("SB1")+"' "+CRLF
	cQuery	+= " 			AND SB1.B1_COD = SD4.D4_COD "+CRLF
	cQuery	+= " 			AND SB1.B1_TIPO IN('MP','PI','PA') "+CRLF
	cQuery	+= " 			AND SB1.D_E_L_E_T_ = ' ' "+CRLF
	cQuery	+= " 			 ) "+CRLF

	cQuery	+= " WHERE SC2.C2_FILIAL = '"+xFilial("SC2")+"' "+CRLF
	cQuery	+= " AND (LTRIM(RTRIM(SC2.C2_NUM))+LTRIM(RTRIM(SC2.C2_ITEM))+LTRIM(RTRIM(SC2.C2_SEQUEN))) BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "+CRLF
	cQuery	+= " AND SC2.C2_YAMOSTR = '2' "+CRLF
	cQuery	+= " AND SC2.D_E_L_E_T_ = ' ' "+CRLF
	cQuery	+= " GROUP BY C2_NUM, C2_ITEM, C2_SEQUEN, C2_PRODUTO "+CRLF
	cQuery	+= " ) DADOS "+CRLF
	cQuery	+= " WHERE CONTSD4 != CONTSG1 "+CRLF
	cQuery	+= " AND CONTSD4 > 0 "+CRLF
	cQuery	+= " ORDER BY OP "+CRLF

	DbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQuery) , cArqTmp,.T.,.T.)

	While (cArqTmp)->(!Eof())

		cRet += GetPrdDiv((cArqTmp)->C2_PRODUTO, (cArqTmp)->OP) 

		(cArqTmp)->(DbSkip())
	EndDo

	If !Empty(cRet)
		cRet := "Empenho divergente da estrutura: "+CRLF+CRLF+cRet
	EndIf

	If Select(cArqTmp) > 0
		(cArqTmp)->(DbCloseArea())
	EndIf

	RestArea(aArea)
Return cRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGetPrdDiv		บAutor  ณMicrosiga       บ Data ณ  10/03/20   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRetorna o codigo do produto divergente		              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                       	              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GetPrdDiv(cProd, cOp)

	Local aArea		:= GetArea()
	Local cArqTmp	:= GetNextAlias()
	Local cQuery	:= ""
	Local cRet		:= ""

	Default cProd	:= "" 
	Default cOp		:= ""	

	cQuery	:= " SELECT G1_COMP, B1_DESC, B1_TIPO FROM "+RetSqlName("SG1")+" SG1 "+CRLF

	cQuery	+= " INNER JOIN "+RetSqlName("SB1")+" SB1 "+CRLF
	cQuery	+= " ON SB1.B1_FILIAL = SG1.G1_FILIAL "+CRLF
	cQuery	+= " AND SB1.B1_COD = SG1.G1_COMP "+CRLF
	cQuery	+= " AND SB1.B1_TIPO IN('MP','PI','PA') "+CRLF
	cQuery	+= " AND SB1.D_E_L_E_T_ = ' ' "+CRLF

	cQuery	+= " WHERE SG1.G1_FILIAL= '"+xFilial("SG1")+"' "+CRLF
	cQuery	+= " AND SG1.G1_COD = '"+cProd+"' "+CRLF 
	cQuery	+= " AND SG1.D_E_L_E_T_ = ' ' "+CRLF
	cQuery	+= " AND NOT EXISTS(SELECT 'X' FROM "+RetSqlName("SD4")+" SD4 "+CRLF
	cQuery	+= " 				WHERE SD4.D4_FILIAL= '"+xFilial("SD4")+"' "+CRLF
	cQuery	+= " 				AND SD4.D4_OP = '"+cOp+"' "+CRLF
	cQuery	+= " 				AND SD4.D4_COD = SG1.G1_COMP "+CRLF
	cQuery	+= " 				AND SD4.D4_PRODUTO = '"+cProd+"' "+CRLF
	cQuery	+= " 				AND SD4.D_E_L_E_T_ = ' ' "+CRLF
	cQuery	+= " 				) "+CRLF

	DbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQuery) , cArqTmp,.T.,.T.)

	While (cArqTmp)->(!Eof())

		cRet += "-OP: "+Alltrim(cOp)+ " Produto: "+Alltrim((cArqTmp)->G1_COMP)+" - "+Alltrim((cArqTmp)->B1_DESC) +CRLF

		(cArqTmp)->(DbSkip())
	EndDo

	If Select(cArqTmp) > 0
		(cArqTmp)->(DbCloseArea())
	EndIf

	RestArea(aArea)
Return cRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณQbrTxtToArray	บAutor  ณMicrosiga       บ Data ณ  12/06/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Quebra o texto em array					                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                       	              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function QbrTxtToArray(cTexto, nMaxCol, cQuebra, lTiraBra)
	Local aArea     := GetArea()
	Local aTexto    := {}
	Local aAux      := {}
	Local nAtu      := 0
	Default cTexto  := ''
	Default nMaxCol := 80
	Default cQuebra := ';'
	Default lTiraBra:= .T.

	//Quebrando o Array, conforme -Enter-
	aAux:= StrTokArr(cTexto,Chr(13))

	//Correndo o Array e retirando o tabulamento
	For nAtu:=1 TO Len(aAux)
		aAux[nAtu]:=StrTran(aAux[nAtu],Chr(10),'')
	Next

	//Correndo as linhas quebradas
	For nAtu:=1 To Len(aAux)

		//Se o tamanho de Texto, for maior que o n๚mero de colunas
		If (Len(aAux[nAtu]) > nMaxCol)

			//Enquanto o Tamanho for Maior
			While (Len(aAux[nAtu]) > nMaxCol)
				//Pegando a quebra conforme texto por parโmetro
				nUltPos:=RAt(cQuebra,SubStr(aAux[nAtu],1,nMaxCol))

				//Caso nใo tenha, a ๚ltima posi็ใo serแ o ๚ltimo espa็o em branco encontrado
				If nUltPos == 0
					nUltPos:=Rat(' ',SubStr(aAux[nAtu],1,nMaxCol))
				EndIf

				//Se nใo encontrar espa็o em branco, a ๚ltima posi็ใo serแ a coluna mแxima
				If(nUltPos==0)
					nUltPos:=nMaxCol
				EndIf

				//Adicionando Parte da Sring (de 1 at้ a ฺlima posi็ใo vแlida)
				aAdd(aTexto,SubStr(aAux[nAtu],1,nUltPos))

				//Quebrando o resto da String
				aAux[nAtu] := SubStr(aAux[nAtu], nUltPos+1, Len(aAux[nAtu]))
			EndDo

			//Adicionando o que sobrou
			aAdd(aTexto,aAux[nAtu])
		Else
			//Se for menor que o Mแximo de colunas, adiciona o texto
			aAdd(aTexto,aAux[nAtu])
		EndIf
	Next

	//Se for para tirar os brancos
	If lTiraBra
		//Percorrendo as linhas do texto e aplica o AllTrim
		For nAtu:=1 To Len(aTexto)
			aTexto[nAtu] := Alltrim(aTexto[nAtu])
		Next
	EndIf

	RestArea(aArea)
Return aTexto
