#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.ch"
#INCLUDE "TopConn.ch"

/*
+-----------+----------+-------+----------------------+------+-------------+
| Função:   | VAEMR01  | Autor | Jorge Henrique Alves | Data | Abril/2010  |          
+-----------+----------+-------+----------------------+------+-------------+
| Descrição | Relatório De Demonstrativo AEM	                           |    
+-----------+--------------------------------------------------------------+
| Uso       | Verion Agricultura                                           |
+-----------+--------------------------------------------------------------+
*/
User Function VAEMR01(_cNFDe,_cNFAte,_cSerie)

Local aArea      := GetArea()

Private Titulo	 := "DEMONSTRATIVO AEM"
Private cPerg    := "VAEMR01"
Private nLastKey := 0
Private NomeProg := FunName()
Private nColMax  := 3400
Private nColMin  := 035
Private nLinMax  := 2200
Private wnrel	 := ""

m_pag := 1

wnrel := "VAEMR01"            //Nome Default do Relatório em Disco

cPerg := PadR( cPerg , Len(SX1->X1_GRUPO) , " " )

If ValType(_cNFDe) == "U" .Or. ValType(_cNFAte) == "U" .Or. ValType(_cSerie) == "U"
	
	_fVldPerg()
	
	If !pergunte(cPerg,.T.)
		Return
	EndIf	

	_cNFDe  := mv_par01
	_cNFAte := mv_par02
	_cSerie := mv_par03
	
EndIf


Processa({|| CursorWait(),VAEMR01_A(Titulo,_cNFDe,_cNFAte,_cSerie),CursorArrow()},"Gerando Demonstrativo, Por favor Aguarde...")

RestArea(aArea)

Return


/*
+-----------+------------+-------+----------------------+------+-------------+
| Função    | VAEMR01_A  | Autor | Jorge Henrique Alves | Data | Abril/2010  |
+-----------+------------+-------+----------------------+------+-------------+
| Descrição | Cria os Objetos para o Relatório Gráfico                       |
+-----------+----------------------------------------------------------------+
| Uso       | Verion Agricultura                                             |
+----------------------------------------------------------------------------+
*/

Static Function VAEMR01_A(Titulo,_cNFDe,_cNFAte,_cSerie)

Private oPrint := Nil
Private k      := 1
Private nLin   := 3500

//Definição das fontes a serem utilizadas

Private oFont06  := tFont():New("TIMES NEW ROMAN",06,06,,.f.,,,,.t.,.f.)
Private oFont06N := tFont():New("TIMES NEW ROMAN",06,06,,.t.,,,,.t.,.f.)
Private oFont08  := tFont():New("TIMES NEW ROMAN",08,08,,.f.,,,,.t.,.f.)
Private oFont08N := tFont():New("TIMES NEW ROMAN",08,08,,.t.,,,,.t.,.f.)
Private oFont09  := tFont():New("TIMES NEW ROMAN",09,09,,.f.,,,,.t.,.f.)
Private oFont09A := tFont():New("ARITAL"         ,09,09,,.f.,,,,.t.,.f.)
Private oFont09N := tFont():New("TIMES NEW ROMAN",09,09,,.t.,,,,.t.,.f.)
Private oFont10  := tFont():New("TIMES NEW ROMAN",10,10,,.f.,,,,.t.,.f.)
Private oFont10A := tFont():New("ARIAL"          ,10,10,,.f.,,,,.t.,.f.)
Private oFont10N := tFont():New("TIMES NEW ROMAN",10,10,,.t.,,,,.t.,.f.)
Private oFont10AN:= tFont():New("ARIAL"          ,10,10,,.t.,,,,.t.,.f.)
Private oFont11  := tFont():New("TIMES NEW ROMAN",11,11,,.f.,,,,.t.,.f.)
Private oFont11A := tFont():New("ARIAL"          ,11,11,,.f.,,,,.t.,.f.)
Private oFontOBS := tFont():New("COURIER NEW"    ,11,11,,.f.,,,,.t.,.f.)
Private oFont11N := tFont():New("TIMES NEW ROMAN",11,11,,.t.,,,,.t.,.f.)
Private oFont11AN:= tFont():New("ARIAL"          ,11,11,,.t.,,,,.t.,.f.)
Private oFont12  := tFont():New("TIMES NEW ROMAN",12,12,,.f.,,,,.t.,.f.)
Private oFont12N := tFont():New("TIMES NEW ROMAN",12,12,,.t.,,,,.t.,.f.)
Private oFont14  := tFont():New("TIMES NEW ROMAN",14,14,,.f.,,,,.t.,.f.)
Private oFont14N := tFont():New("TIMES NEW ROMAN",14,14,,.t.,,,,.t.,.f.)
Private oFont14A := tFont():New("ARIAL"          ,14,14,,.f.,,,,.t.,.f.)
Private oFont16  := tFont():New("TIMES NEW ROMAN",16,16,,.f.,,,,.t.,.f.)
Private oFont16N := tFont():New("TIMES NEW ROMAN",16,16,,.t.,,,,.t.,.f.)
Private oFont18  := tFont():New("TIMES NEW ROMAN",18,18,,.f.,,,,.t.,.f.)
Private oFont18N := tFont():New("TIMES NEW ROMAN",18,18,,.t.,,,,.t.,.f.) 
Private oFont26  := tFont():New("TIMES NEW ROMAN",26,26,,.f.,,,,.t.,.f.)
Private oFont26N := tFont():New("TIMES NEW ROMAN",26,26,,.t.,,,,.t.,.f.)

oPrint:= TMSPrinter():New(Titulo)
oPrint:SetPortrait()			//Modo Retrato
oPrint:SetPaperSize(9)     		//A4

If !oPrint:IsPrinterActive()
	oPrint:Setup()
EndIf

If !oPrint:IsPrinterActive()
	Aviso("Atenção","Não foi Possível Imprimir o Relatório, pois não há Nenhuma Impressora Conectada.",{"OK"})
	Return(Nil)
EndIf

nLin := VAEMR01_B(oPrint,k,Titulo,_cNFDe,_cNFAte,_cSerie)

oPrint:Preview()

Set Device To Screen

MS_FLUSH()

oPrint := Nil

Return(Nil)


/*
+------------+------------+-------+----------------------+-------+-------------+
| Função:    | VAEMR01_B  | Autor | Jorge Henrique Alves | Data: | Abril/2010  |
+------------+------------+-------+----------------------+-------+-------------+
| Descrição: | Impressão do Detalhe do Relatório.                              |
+------------+-----------------------------------------------------------------+
| Uso        | Verion Agricultura                                              |
+------------+-----------------------------------------------------------------+
*/

Static Function VAEMR01_B(oPrint,k,Titulo,_cNFDe,_cNFAte,_cSerie)

Local nQuant    	:= 1
Local nomeprog  	:= "DEMONSTRATIVO AEM"
Local nCont    		:= _nTrt := _nQtd := 0, _cSQL1 := _cSQL2 := ""

Private nContpag   	:= 0 
Private lFirstPage 	:= .t.
Private aPcol       := {0100,0380,0700,1960}
Private nPgLin 	   	:= 0, _cNumNF := _cSerNF := ""



//Monta primeira Query de processamento filtrando os produtos da NF que possum estrutura
_cSQL1 := "Select D2_DOC,D2_SERIE,D2_COD,B1_DESC,Sum(D2_QUANT) as D2_QUANT From " + RetSqlName("SD2") + " as _D2 "
_cSQL1 += "Inner Join " + RetSqlName("SB1") + " as _B1 on B1_COD = D2_COD "
_cSQL1 += "Where _D2.D_E_L_E_T_ <> '*' and D2_DOC >= '" + _cNFDe + "' and D2_DOC <= '" + _cNFAte + "' and D2_SERIE = '" + _cSerie + "' and "
_cSQL1 += "	D2_FILIAL = '" + xFilial("SD2") + "' and B1_FILIAL = '" + xFilial("SB1") + "' "
_cSQL1 += "Group By D2_DOC,D2_SERIE,D2_COD,B1_DESC "
_cSQL1 += "Order By D2_DOC,D2_SERIE,D2_COD "

conout(_cSQL1)
If Select("xSD2") > 0
	DbSelectArea("xSD2")
	DbCloseArea()
EndIf

TcQuery _cSQL1 New Alias "xSD2"	

DbSelectArea("xSD2")
DbGoTop()

ProcRegua(RecCount())

While !Eof()

	DbSelectArea("SG1")
	DbSetOrder(1)
	If !DbSeek(xFilial("SG1") + xSD2->D2_COD)
		DbSelectArea("xSD2")
		DbSkip()
		Loop
	EndIf	
		
	_cNumNF  := xSD2->D2_DOC 
	_cSerNF  := xSD2->D2_SERIE
	nLin     := 3500
    nContPag := 0
    
	While !Eof() .And. xSD2->D2_DOC + xSD2->D2_SERIE == _cNumNF + _cSerie
		
		_fPlinha() //Verifica necessidade de iniciar nova página
		
		oPrint:Say(nLin,aPcol[1],OemToAnsi("Codigo:"),oFont08)
		oPrint:Say(nLin,aPcol[2],OemToAnsi(xSD2->D2_COD),oFont08)
		oPrint:Say(nLin,aPcol[3],OemToAnsi(SubStr(xSD2->B1_DESC,1,50)),oFont08)
		oPrint:Say(nLin,aPcol[4],OemToAnsi("Base Estrut.:"),oFont08)
		
		nLin += 40
		
		//Busca a estrutura do produto
		_cSQL2 := "Select G1_COMP,G1_QUANT,G1_PERDA,B1_DESC From " + RetSqlName("SG1") + " as G1 "
		_cSQL2 += "Inner Join " + RetSqlName("SB1") + " as B1 on G1_COMP = B1_COD "
		_cSQL2 += "Where G1_FILIAL = '" + xFilial("SG1") + "' And B1_FILIAL = '" + xFilial("SB1") + "' And "
		_cSQL2 += "G1_COD = '" + xSD2->D2_COD + "' And G1.D_E_L_E_T_ <> '*' And B1.D_E_L_E_T_ <> '*' "
		
		If Select("xSG1") > 0
			DbSelectArea("xSG1")
			DbCloseArea()
		EndIf
		
		TcQuery _cSQL2 New Alias "xSG1"	
		
		DbSelectArea("xSG1")
		DbGoTop()
		
		_nTrt := 2
		
		While !Eof()		

			_fPlinha()
			
			oPrint:Say(nLin,aPcol[1],OemToAnsi(StrZero(_nTrt,3,0)),oFont08)
			oPrint:Say(nLin,aPcol[2],OemToAnsi(xSG1->G1_COMP),oFont08)
			oPrint:Say(nLin,aPcol[3],OemToAnsi(SubStr(xSG1->B1_DESC,1,50)),oFont08)
			oPrint:Say(nLin,aPcol[4],OemToAnsi(Transform((xSG1->G1_QUANT  + (xSG1->G1_PERDA/100)) * xSD2->D2_QUANT,"@E 99999.999999")),oFont08)
			
			_nQtd := (xSG1->G1_QUANT  + (xSG1->G1_PERDA/100)) * xSD2->D2_QUANT
            
			nLin += 40
			
			DbSelectArea("SG1")
			DbSetOrder(1)
			If DbSeek(xFilial("SG1") + xSG1->G1_COMP)
				VAEMR01_D(_nQtd,_nTrt,xSG1->G1_COMP) //Verifica outros níveis de estrutura
			EndIf	
			
			DbSelectArea("xSG1")
			DbSkip()
		
		EndDo
				
		DbSelectArea("xSD2")
		DbSkip()
		
		oPrint:Line(nLin,0080,nLin,2250)
		oPrint:Line(nLin+2,0080,nLin+2,2250)
		
		nLin += 20
		
	EndDo

	DbSelectArea("xSD2")

EndDo
	
Return

/*
+---------+----------+
| Função: | _fPLinha |
+---------+----------+
*/

Static Function _fPLinha

If nLin > 3400
	oPrint:EndPage()			// Finaliza a Página
	nContPag++
	VAEMR01_C(oPrint,k,Titulo)	// Função que monta o Cabeçalho Padrão	
	lFirstPage := .f.
EndIf

Return 

/*
+----------+------------+-------+----------------------+------+-------------+
| Função   | VAEMR01_C  | Autor | Jorge Henrique Alves | Data | Abril/2010  |
+----------+------------+-------+----------------------+------+-------------+
| Descrição| Função que monta os dados do cabeçalho Do relatório		    |
+----------+----------------------------------------------------------------+
| Uso      | Verion Agricultura                                             |
+----------+----------------------------------------------------------------+
*/ 

Static Function VAEMR01_C(oPrint,k,Titulo)

oPrint:StartPage()

nLin := 100

oPrint:SayBitmap(nLin,0250,"aem1.bmp",200,191)
oPrint:SayBitmap(nLin + 190,0100,"verionlogo.bmp",450,155)

oPrint:Say(nLin,0720,OemToAnsi("AEM RURAL MAQUINAS E EQUIPAMENTOS LTDA ME"),oFont12N)
oPrint:Say(nLin,2080,OemToAnsi("Pg. " + Alltrim(Str(nContPag))),oFont08)
nLin += 45
oPrint:Say(nLin,0720,OemToAnsi("REPRESENTANTE VERION AGRICULTURA DE PRECISÃO NO BRASIL"),oFont10)
nLin += 45
oPrint:Say(nLin,0720,OemToAnsi("Rua Cantagalo, 584 - Tatuapé - São Paulo/SP - Brasil - CEP 03319-000"),oFont10)
nLin += 45
oPrint:Say(nLin,0720,OemToAnsi("Fone: ++55 11 2093-4956 - Fax: ++ 55 11 2093-4959"),oFont10)
nLin += 45
oPrint:Say(nLin,0720,OemToAnsi("E-mail: agricola@verion.com.br - Site: http://www.verion.com.br"),oFont10)
nLin += 45
oPrint:Say(nLin,0720,OemToAnsi("CNPJ: 54.482.252/0001-23  IE: 111.295.824.110"),oFont10)
nLin += 170

oPrint:Say(nLin,0600,OemToAnsi("DEMONSTRATIVO ANALITICO DA ESTRUTURA DE PRODUTOS"),oFont12N)
nLin += 110

oPrint:Say(nLin,0250,OemToAnsi("NOTA FISCAL Nº: " + Alltrim(_cNumNF) + "  -  " + "SERIE: " + Alltrim(_cSerNF)),oFont11)
nLin += 110

oPrint:Say(nLin,0100,OemToAnsi("NIVEL"),oFont09)
oPrint:Say(nLin,0380,OemToAnsi("CODIGO"),oFont09)
oPrint:Say(nLin,0700,OemToAnsi("DESCRICAO"),oFont09)
oPrint:Say(nLin,1960,OemToAnsi("QUANTIDADE"),oFont09)
nLin += 45

oPrint:Line(nLin,0080,nLin,2250)
oPrint:Line(nLin+2,0080,nLin+2,2250)

nLin += 30

Return

/*
+----------+------------+-------+----------------------+------+-------------+
| Função   | VAEMR01_D  | Autor | Jorge Henrique Alves | Data | Abril/2010  |
+----------+------------+-------+----------------------+------+-------------+
| Descrição| Explode os sub-niveis de estrutura							    |
+----------+----------------------------------------------------------------+
| Uso      | Verion Agricultura                                             |
+----------+----------------------------------------------------------------+
*/ 

Static Function VAEMR01_D(nQtdPai,_nNivel,_cCod)
Local _nRec := _nQuant := 0, _cProd := ""
Local _nSeq := _nNivel + 1

DbSelectArea("SG1")
While !Eof() .And. SG1->G1_FILIAL == xFilial("SG1") .And. SG1->G1_COD == _cCod
	
	_fPlinha()
	
	oPrint:Say(nLin,aPcol[1] + _nSeq + 10,OemToAnsi(StrZero(_nSeq,3,0)),oFont08)
	oPrint:Say(nLin,aPcol[2],OemToAnsi(SG1->G1_COMP),oFont08)
	oPrint:Say(nLin,aPcol[3],OemToAnsi(SubStr(Posicione("SB1",1,xFilial("SB1") + SG1->G1_COMP,"B1_DESC"),1,50)),oFont08)
	oPrint:Say(nLin,aPcol[4],OemToAnsi(Transform((SG1->G1_QUANT  + (SG1->G1_PERDA/100)) * nQtdPai,"@E 99999.999999")),oFont08)
	
	nLin += 40
	
	_nQuant := (SG1->G1_QUANT  + (SG1->G1_PERDA/100)) * nQtdPai
	
	_nRec := SG1->(Recno())
	
	DbSelectArea("SG1")
	If DbSeek(xFilial("SG1") + SG1->G1_COMP)
 		VAEMR01_D(_nQuant,_nSeq,SG1->G1_COD) //Verifica sub-niveis de estrutura	
 	EndIf
 	
 	DbSelectArea("SG1")
 	DbGoTo(_nRec)
 	DbSkip()
 	
EndDo

Return



/*
+------------+-----------+--------+----------------+-------+-----------+
| Programa:  | _fVldPerg | Autor: | Jorge H. Alves | Data: | Abril/2010|
+------------+-----------+--------+----------------+-------+-----------+
| Descrição  | Verifica se já existem os parâmetros (cPerg) no sistema |
+------------+---------------------------------------------------------+
| Uso        | Verion Agricultura                                      |
+------------+---------------------------------------------------------+
*/

Static Function _fVldPerg()

dbSelectArea("SX1")
dbSetOrder(1)

If !DbSeek(cPerg + "01")
	While !RecLock("SX1",.t.)
	Enddo
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "01"
	SX1->X1_PERGUNT := "Da Nota Fiscal     ?"
	SX1->X1_VARIAVL := "mv_ch1"
	SX1->X1_TIPO    := "C"
	SX1->X1_TAMANHO := LEN(SD2->D2_DOC)
	SX1->X1_GSC     := "G"
	SX1->X1_VAR01   := "mv_par01"
	MsUnLock()

EndIf

If !DbSeek(cPerg + "02")
	While !RecLock("SX1",.t.)
	Enddo
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "02"
	SX1->X1_PERGUNT := "Ate Nota Fiscal   ?"
	SX1->X1_VARIAVL := "mv_ch2"
	SX1->X1_TIPO    := "C"
	SX1->X1_TAMANHO := LEN(SD2->D2_DOC)
	SX1->X1_GSC     := "G"
	SX1->X1_VAR01   := "mv_par02"
	MsUnLock()

EndIf 

If !DbSeek(cPerg + "03")
	While !RecLock("SX1",.t.)
	Enddo
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "03"
	SX1->X1_PERGUNT := "Serie   ?"
	SX1->X1_VARIAVL := "mv_ch3"
	SX1->X1_TIPO    := "C"
	SX1->X1_TAMANHO := LEN(SD2->D2_SERIE)
	SX1->X1_GSC     := "G"
	SX1->X1_VAR01   := "mv_par03"	
	MsUnLock()

EndIf 



Return
