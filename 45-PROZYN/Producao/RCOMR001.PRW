#INCLUDE "Rwmake.ch"
#INCLUDE "Protheus.ch"
#INCLUDE "COLORS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRCOMR001  บAutor  ณLeonardo Ibelli         บData ณ 19/04/16 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Relat๓rio Pedido compras Importa็ใo                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออ?อออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Protheus 12 - Empresa Prozyn.                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/



User Function RCOMR001()

Private cPerg   := "RCOMR001"
Private aLinhas	:= {} 	// Array com o memo dividido em linhas

//Define um estilo e tamanho de fonte a ser utilizado
Private oFont1:= TFont():New( "Arial",,12,,.f.,,,,,.f. )
Private oFont2:= TFont():New( "Arial",,12,,.T.,,,,,.f. )
Private oFont3:= TFont():New( "Arial",,12,,.t.,,,,,.t. )
Private oFont4:= TFont():New( "Arial",,12,,.t.,,,,,.f. )
Private oFont5:= TFont():New( "Arial",,12,,.f.,,,,,.f. )
Private oFont6:= TFont():New( "Arial",,12,,.T.,,,,,.T. )
Private oFont7:= TFont():New( "Arial",,12,,.T.,,,,,.T. )
Private oFont8:= TFont():New( "Arial",,12,,.F.,,,,,.f. )
Private oFont9:= TFont():New( "Arial",,22,,.T.,,,,,.f. )

Private _nTotQtd   := 0
Private _nTotFinal := 0
Private _nDescIt   := 0
Private _nTotMerc  := 0
Private _cTexto    := ""

//Define um objeto de impressใo
Private oPrn:=TMSPrinter():New()
ValidPerg()
If !pergunte(cPerg,.T.)
	return
EndIF

Private nPagFim := 1

DbSelectArea("SC7")
dbSetorder(1)
set softseek on
dbSeek(xFilial("SC7") + mv_par01)
Set softseek oFF
While !Eof() .AND. SC7->C7_NUM >= MV_PAR01 .AND. SC7->C7_NUM <= MV_PAR02
	IF  SC7->C7_EMISSAO >= MV_PAR03 .AND. SC7->C7_EMISSAO <= MV_PAR04
		
		DbSelectArea("SA2")
		DbSetOrder(1)
		Dbseek(xFilial("SA2")+ SC7->C7_FORNECE)
		
		_cPedido := SC7->C7_NUM
		nLin := 100
		nLin += 694
		nCol := 0
		nCol2 := -695
		
		oPrn:StartPage()
		nLin := 100
		//---------------------------------------------------------------------------------------------------------------------
		Private nPag	:= 1
		Cabec()
		nLin += 50
		oPrn:say (nLin,nCol+0215, "Supplier:"   	    		,oFont2,100,,,3)
		oPrn:say (nLin,nCol+0500, Alltrim(SA2->A2_NOME)			,oFont2,100,,,3)
		oPrn:say (nLin,nCol+1180, "Date:"     			    	,oFont2,100,,,3)
		oPrn:say (nLin,nCol+1510, DTOC(SC7->C7_EMISSAO)			,oFont2,100,,,3)
		oPrn:Box(nLin,nCol+0185,nLin+100,nCol2+1180) //linha,coluna,linha,coluna
		oPrn:Box(nLin,nCol+486,nLin+400,nCol2+1868) //linha,coluna,linha,coluna
		oPrn:Box(nLin,nCol+1173,nLin+100,nCol2+2195) //linha,coluna,linha,coluna
		oPrn:Box(nLin,nCol+1500,nLin+400,nCol2+2900) //linha,coluna,linha,coluna
		nLin += 100
		oPrn:say (nLin,nCol+0215, "Adress:"   				,oFont2,100,,,3)
		oPrn:say (nLin,nCol+0500, SA2->A2_NR_END +" "+ RTRIM(SA2->A2_END)+", "+ RTRIM(SA2->A2_BAIRRO)		,oFont2,100,,,3)
		oPrn:say (nLin,nCol+1180, "Phone/Fax:" 		    	,oFont2,100,,,3)
		oPrn:say (nLin,nCol+1510, SA2->A2_DDI + " " + SA2->A2_DDD + " " + Alltrim(SA2->A2_TEL)   				,oFont2,100,,,3)
		oPrn:Box(nLin,nCol+1173,nLin+150,nCol2+2195) //linha,coluna,linha,coluna
		oPrn:Box(nLin,nCol+0185,nLin+150,nCol2+1180) //linha,coluna,linha,coluna
		nLin +=50
		oPrn:say (nLin,nCol+0500, Alltrim(SA2->A2_ESTADO + " - " +	Posicione("SYA",1,xFilial("SYA")+SA2->A2_PAIS,"YA_DESCR")) 		,oFont2,100,,,3)   //
		nLin += 100
		oPrn:say (nLin, nCol+0215, "Contact person:"   		,oFont2,100,,,3)
		oPrn:say (nLin,nCol+0500, Alltrim(SC7->C7_CONTATO)   		,oFont2,100,,,3)
		oPrn:say (nLin,nCol+1180, "E-mail:"     			    	,oFont2,100,,,3)
		oPrn:say (nLin,nCol+1510, Alltrim(SA2->A2_EMAIL)   				,oFont2,100,,,3)
		oPrn:Box(nLin,nCol+1173,nLin+150,nCol2+2195) //linha,coluna,linha,coluna
		oPrn:Box(nLin,nCol+0185,nLin+150,nCol2+1180) //linha,coluna,linha,coluna
		nLin += 300
		itens()
		
		//------------------------------------------------------------------------------------------------------------
		
	ENDIF
	DbSelectArea("SC7")
	dbSetorder(1)
	DbSkip()
	Loop
Enddo

oPrn:Preview()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณItens  บAutor  ณLeonardo Ibelli          บData ณ  19/04/16  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Imprime os Itens do Pedido de Compra.                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Prozyn							       	                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Itens()

DbSelectArea("SC7")
dbSetorder(1)
set softseek on
dbSeek(xFilial("SC7") + _cPedido)
Set softseek oFF
While !Eof() .AND. SC7->C7_NUM = _cPedido
	
	oPrn:Say(nLin,nCol+0215, "Product:"   				,oFont2,100,,,3)//
	oPrn:Say(nLin,nCol+0815,alltrim(SC7->C7_DESCRI)				,oFont2,100,,,3)//
	oPrn:Box(nLin,nCol+0185,nLin+100,nCol2+1500) //linha,coluna,linha,coluna
	oPrn:Box(nLin,nCol+805,nLin+100,nCol2+2900) //linha,coluna,linha,coluna
	nLin += 100
	oPrn:Say(nLin,nCol+0215, "Quantity:"				,oFont2,100,,,3)//
	oPrn:Say(nLin,nCol+0815, TRANSFORM(SC7->C7_QUANT ,"@E 999,999.99") + " " + alltrim(SC7->C7_UM)          ,oFont2,100,,,3)//
	oPrn:Box(nLin,nCol+0185,nLin+100,nCol2+1500) //linha,coluna,linha,coluna
	oPrn:Box(nLin,nCol+805,nLin+100,nCol2+2900) //linha,coluna,linha,coluna
	nLin += 100
	oPrn:Say(nLin,nCol+215, "FOB/Kg:"				,oFont2,100,,,3)//
	oPrn:Say(nLin,nCol+0815, TRANSFORM(SC7->C7_PESO_B ,"@E 999,999.99") + " " + alltrim(SC7->C7_UM)          ,oFont2,100,,,3)//
	oPrn:Box(nLin,nCol+0185,nLin+100,nCol2+1500) //linha,coluna,linha,coluna
	oPrn:Box(nLin,nCol+805,nLin+100,nCol2+2900) //linha,coluna,linha,coluna
	nLin +=100
	
	If nLin >= 3010 //verifica se chegou ao final da pagina
		nPagFim++
		oPrn:EndPage()
		oPrn:StartPage()
		nLin := 100
		nLin += 694
		nCol := 0
		nCol2 := -695
	EndIf
	
	DbSelectArea("SC7")
	dbSetorder(1)
	DbSkip()
	Loop
Enddo

oPrn:Say(nLin,nCol+0215, "Total Cost:"			,oFont2,100,,,3)//
oPrn:Say(nLin,nCol+0815, "USD " + TRANSFORM(SC7->C7_TOTAL * SC7->C7_TXMOEDA ,"@E 999,999.99")			,oFont2,100,,,3)
oPrn:Box(nLin,nCol+0185,nLin+100,nCol2+1500) //linha,coluna,linha,coluna
oPrn:Box(nLin,nCol+805,nLin+100,nCol2+2900) //linha,coluna,linha,coluna
nLin += 100
If nLin >= 3010 //verifica se chegou ao final da pagina
	nPagFim++
	oPrn:EndPage()
	oPrn:StartPage()
	nLin := 100
	nLin += 694
	nCol := 0
	nCol2 := -695
EndIf

oPrn:Say(nLin,nCol+0215, "Packing:"			,oFont2,100,,,3)//
oPrn:Say(nLin,nCol+0810, "1,100 Kg x 4 IBC containers"			,oFont2,100,,,3)//
oPrn:Box(nLin,nCol+0185,nLin+100,nCol2+1500) //linha,coluna,linha,coluna
oPrn:Box(nLin,nCol+805,nLin+100,nCol2+2900) //linha,coluna,linha,coluna
nLin += 100
If nLin >= 3010 //verifica se chegou ao final da pagina
	nPagFim++
	oPrn:EndPage()
	oPrn:StartPage()
	nLin := 100
	nLin += 694
	nCol := 0
	nCol2 := -695
EndIf

oPrn:Say(nLin,nCol+0215, "Insurance:"			,oFont2,100,,,3)//
oPrn:Say(nLin,nCol+0815, "Covered by us in Brazil"				,oFont2,100,,,3)//
oPrn:Box(nLin,nCol+0185,nLin+100,nCol2+1500) //linha,coluna,linha,coluna
oPrn:Box(nLin,nCol+805,nLin+100,nCol2+2900) //linha,coluna,linha,coluna
nLin += 100
If nLin >= 3010 //verifica se chegou ao final da pagina
	nPagFim++
	oPrn:EndPage()
	oPrn:StartPage()
	nLin := 100
	nLin += 694
	nCol := 0
	nCol2 := -695
EndIf

oPrn:Say(nLin,nCol+0215, "Final destination:"			,oFont2,100,,,3)//
oPrn:Say(nLin,nCol+0815, "Santos Port, Sใo Paulo, Brazil"			,oFont2,100,,,3)//
oPrn:Box(nLin,nCol+0185,nLin+100,nCol2+1500) //linha,coluna,linha,coluna
oPrn:Box(nLin,nCol+805,nLin+100,nCol2+2900) //linha,coluna,linha,coluna
nLin += 100
If nLin >= 3010 //verifica se chegou ao final da pagina
	nPagFim++
	oPrn:EndPage()
	oPrn:StartPage()
	nLin := 100
	nLin += 694
	nCol := 0
	nCol2 := -695
EndIf

oPrn:Say(nLin,nCol+0215, "E.T.D.:"			,oFont2,100,,,3)//
oPrn:Say(nLin,nCol+0810, "Midlle of July;"			,oFont2,100,,,3)//
oPrn:Box(nLin,nCol+0185,nLin+100,nCol2+1500) //linha,coluna,linha,coluna
oPrn:Box(nLin,nCol+805,nLin+100,nCol2+2900) //linha,coluna,linha,coluna
nLin += 100
If nLin >= 3010 //verifica se chegou ao final da pagina
	nPagFim++
	oPrn:EndPage()
	oPrn:StartPage()
	nLin := 100
	nLin += 694
	nCol := 0
	nCol2 := -695
EndIf

oPrn:Say(nLin,nCol+0815, "No discrepancies will be accepted on FOB unit value, net"			,oFont2,100,,,3)//
oPrn:Box(nLin,nCol+0185,nLin+200,nCol2+1500) //linha,coluna,linha,coluna
oPrn:Box(nLin,nCol+805,nLin+100,nCol2+2900) //linha,coluna,linha,coluna
nLin += 45
If nLin >= 3010 //verifica se chegou ao final da pagina
	nPagFim++
	oPrn:EndPage()
	oPrn:StartPage()
	nLin := 100
	nLin += 694
	nCol := 0
	nCol2 := -695
EndIf

oPrn:Say(nLin,nCol+0215, "Invoicing:"			,oFont2,100,,,3)//
oPrn:Say(nLin,nCol+0815, "weight or technical description of goods."			,oFont2,100,,,3)//
nLin += 55
If nLin >= 3010 //verifica se chegou ao final da pagina
	nPagFim++
	oPrn:EndPage()
	oPrn:StartPage()
	nLin := 100
	nLin += 694
	nCol := 0
	nCol2 := -695
EndIf
oPrn:Say(nLin,nCol+0215, "Payment terms:"			,oFont2,100,,,3)//
oPrn:Say(nLin,nCol+0815, "90 days after BL date"	,oFont2,100,,,3)//
oPrn:Box(nLin,nCol+0185,nLin+100,nCol2+1500) //linha,coluna,linha,coluna
oPrn:Box(nLin,nCol+805,nLin+100,nCol2+2900) //linha,coluna,linha,coluna
nLin += 100
If nLin >= 3010 //verifica se chegou ao final da pagina
	nPagFim++
	oPrn:EndPage()
	oPrn:StartPage()
	nLin := 100
	nLin += 694
	nCol := 0
	nCol2 := -695
EndIf

oPrn:Say(nLin,nCol+0815, "You must send to our office the original signed documents:"			,oFont2,100,,,3)//
oPrn:Box(nLin,nCol+0185,nLin+227,nCol2+1500) //linha,coluna,linha,coluna
oPrn:Box(nLin,nCol+0805,nLin+227,nCol2+2900) //linha,coluna,linha,coluna
nLin += 45
If nLin >= 3010 //verifica se chegou ao final da pagina
	nPagFim++
	oPrn:EndPage()
	oPrn:StartPage()
	nLin := 100
	nLin += 694
	nCol := 0
	nCol2 := -695
EndIf

oPrn:Say(nLin,nCol+0815, "Commercial Invoice, BL, Certificate of Analysis and Packing List"			,oFont2,100,,,3)//
nLin += 45
If nLin >= 3010 //verifica se chegou ao final da pagina
	nPagFim++
	oPrn:EndPage()
	oPrn:StartPage()
	nLin := 100
	nLin += 694
	nCol := 0
	nCol2 := -695
EndIf

oPrn:Say(nLin,nCol+0215, "Documents:"			,oFont2,100,,,3)//
oPrn:Say(nLin,nCol+0815, "Please send by a-mail, one copy of all documents before loading"			,oFont2,100,,,3)//
nLin += 45
If nLin >= 3010 //verifica se chegou ao final da pagina
	nPagFim++
	oPrn:EndPage()
	oPrn:StartPage()
	nLin := 100
	nLin += 694
	nCol := 0
	nCol2 := -695
EndIf

oPrn:Say(nLin,nCol+0815, ",for our analysis/approval."			,oFont2,100,,,3)//
nLin += 90
If nLin >= 3010 //verifica se chegou ao final da pagina
	nPagFim++
	oPrn:EndPage()
	oPrn:StartPage()
	nLin := 100
	nLin += 694
	nCol := 0
	nCol2 := -695
EndIf

oPrn:Say(nLin,nCol+0815, "1) Name of Supplier;"			,oFont2,100,,,3)//
oPrn:Box(nLin,nCol+0185,nLin+0300,nCol2+1500) //linha,coluna,linha,coluna
oPrn:Box(nLin,nCol+0805,nLin+0300,nCol2+2900) //linha,coluna,linha,coluna
nLin += 45
If nLin >= 3010 //verifica se chegou ao final da pagina
	nPagFim++
	oPrn:EndPage()
	oPrn:StartPage()
	nLin := 100
	nLin += 694
	nCol := 0
	nCol2 := -695
EndIf

oPrn:Say(nLin,nCol+0815, "2) Commercial name of the product;"			,oFont2,100,,,3)//
nLin += 45
If nLin >= 3010 //verifica se chegou ao final da pagina
	nPagFim++
	oPrn:EndPage()
	oPrn:StartPage()
	nLin := 100
	nLin += 694
	nCol := 0
	nCol2 := -695
EndIf

oPrn:Say(nLin,nCol+0215, "The packing label"			,oFont2,100,,,3)//
oPrn:Say(nLin,nCol+0815, "3) Lot number;"			,oFont2,100,,,3)//
nLin += 45
If nLin >= 3010 //verifica se chegou ao final da pagina
	nPagFim++
	oPrn:EndPage()
	oPrn:StartPage()
	nLin := 100
	nLin += 694
	nCol := 0
	nCol2 := -695
EndIf

oPrn:Say(nLin,nCol+0215, "must mention:"			,oFont2,100,,,3)//
oPrn:Say(nLin,nCol+0815, "4) Net weight"			,oFont2,100,,,3)//
nLin += 45
If nLin >= 3010 //verifica se chegou ao final da pagina
	nPagFim++
	oPrn:EndPage()
	oPrn:StartPage()
	nLin := 100
	nLin += 694
	nCol := 0
	nCol2 := -695
EndIf

oPrn:Say(nLin,nCol+0815, "5) Date of production"			,oFont2,100,,,3)//
nLin += 45
If nLin >= 3010 //verifica se chegou ao final da pagina
	nPagFim++
	oPrn:EndPage()
	oPrn:StartPage()
	nLin := 100
	nLin += 694
	nCol := 0
	nCol2 := -695
EndIf

oPrn:Say(nLin,nCol+0815, "6) Date of expiration"			,oFont2,100,,,3)//
rodape()

oPrn:StartPage()
nLin := 100
nCol := 0
nCol2 := -695

DbSelectArea("SC7")
dbSetorder(1)
set softseek on
dbSeek(xFilial("SC7") + _cPedido)
Set softseek oFF
While !Eof() .AND. SC7->C7_NUM = _cPedido
	If ALLTRIM(SC7->C7_TRANSP) != ''
		DbSelectArea("SA4")
		DbSetOrder(1)                  
		Dbseek(xFilial("SA4")+SC7->C7_TRANSP)
		
		oPrn:Say(nLin,nCol+0180, "OUR TRANSPORT AGENT WILL BE:"   				,oFont3,100,,,3)//
		nLin += 90
		oPrn:Say(nLin,nCol+0180, Alltrim(SA4->A4_NOME)   				,oFont2,100,,,3)//
		nLin += 50
		oPrn:Say(nLin,nCol+0180, RTRIM(SA4->A4_END) + ", "+RTRIM(SA4->A4_BAIRRO)+", "+SA4->A4_CEP 	,oFont2,100,,,3)//
		nLin += 50
		oPrn:Say(nLin,nCol+0180, RTRIM(SA4->A4_MUN + ", "+SA4->A4_EST+", "+ " - " +  POSICIONE("SA4", 1, xFilial("SA4") + SA4->A4_CODPAIS, "YA_DESCR")),oFont2,100,,,3)
		nLin += 50
		oPrn:Say(nLin,nCol+0180, "TEL " + SA4->A4_DDI + " " + SA4->A4_DDD + " " + SA4->A4_TEL   				,oFont2,100,,,3)//
		nLin += 50
		oPrn:Say(nLin,nCol+0180, alltrim(SA4->A4_EMAIL)   				,oFont2,100,,,3)//
		nLin += 50
		oPrn:Say(nLin,nCol+0180,alltrim(SA4->A4_CONTATO)    				,oFont2,100,,,3)//
		nLin += 80
		oPrn:Say(nLin,nCol+0180, "NOTIFY WILL BE:"   				,oFont3,100,,,3)//
		nLin += 90
		oPrn:Say(nLin,nCol+0180, "LPC LOGISTICA INTERNACIONAL LTDA"   				,oFont2,100,,,3)//
		nLin += 50
		oPrn:Say(nLin,nCol+0180, "Ricardo da Mata"   				,oFont2,100,,,3)//
		nLin += 50
		oPrn:Say(nLin,nCol+0180, "Email: ricardo.mata@lpc.com.br"   				,oFont2,100,,,3)//
		nLin += 50
		oPrn:Say(nLin,nCol+0180, "Rua Canuto Saraiva, 575 - Mooca"   				,oFont2,100,,,3)//
		nLin += 50
		oPrn:Say(nLin,nCol+0180, "03113-010 - SP - Brazil"   				,oFont2,100,,,3)//
		rodape()
		
		DbSelectArea("SA4")
		dbSetorder(1)
		DbSkip()
	Endif
	
	DbSelectArea("SC7")
	dbSetorder(1)
	DbSkip()
	Loop
Enddo
//SC7->(DbSkip(-1))
Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCabec  บAutor  ณLeonardo Ibelli          บData ณ  19/04/16  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Impressใo do Cabe็alho                                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Prozyn 							                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Cabec()

nLin := 100
//cBitMap:= "" + ".Bmp"
//oPrn:SayBitmap( nlin+10,nCol+100,cBitMap,200,200)  //Logo da empresa

nLin += 40
oPrn:Say(nLin,nCol+0900, "PURCHASE ORDER"  ,oFont9,100,,,3)
nLin += 80
oPrn:Box(nLin,nCol+0100,nLin,nCol2+2900) //linha,coluna,linha,coluna
nLin += 35
oPrn:Say(nLin,nCol+0185, "Please consider this P.O. as Shipping Instructions also. We kindly ask you to follow it in order to avoid" ,oFont8,100,,,3)
nLin += 40
oPrn:Say(nLin,nCol+0185, "unnecessary delay in clearing of goods." ,oFont8,100,,,3)
nLin += 50

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRodape  บAutor  ณLeonardo Ibelli         บData ณ  19/04/16  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Impressใo do rodape                                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Prozyn 							                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function rodape()

nLin +=150
oPrn:Say(nLin,nCol+0850, "PROZYN INDฺSTRIA E COMษRCIO LTDA"			,oFont2,100,,,3)//
nLin += 45
oPrn:Say(nLin,nCol+0770, "CNPJ: 65.477.507/0001-86 - EI: 113.012.893.112"			,oFont2,100,,,3)//
nLin += 45
oPrn:Say(nLin,nCol+0300, "Rua Dr. Paulo Leite de Oliveira, 199 - Jd. Raposo Tavares - Sใo Paulo - SP - Brazil - CEP 0551-020"			,oFont2,100,,,3)//
nLin += 45
oPrn:Say(nLin,nCol+0770, "Tel: +55 11 3732-0000 - FAX: +55 11 3732 0021"			,oFont2,100,,,3)//
nLin += 45
oPrn:Say(nLin,nCol+740, "Email: arthur.oliveira@prozyn.com.br/ rafael@prozyn.com.br"			,oFont2,100,,,3)//
If nLin >= 3010 //verifica se chegou ao final da pagina
	nPagFim++
	oPrn:EndPage()
	oPrn:StartPage()
	nLin := 100
	nLin += 694
	nCol := 0
	nCol2 := -695
EndIf

oPrn:endpage()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออออออัออออออออออออปฑฑ
ฑฑบPrograma  ณValidPerg  บAutor ณLeonardo Ibelli          บData ณ  21/04/16  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออนฑฑ
ฑฑบDesc.     ณValidPerg                                                      บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Protheus 12 - Empresa Prozyn                      		     บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ValidPerg()

Local i := 0
Local j := 0

Public aRegs :={}
_sAlias := Alias()
dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,10)
//Public aRegs :={}

AADD(aRegs,{cPerg,"01","De  Numero   ?","","","mv_ch1","C",06,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"02","Ate Numero   ?","","","mv_ch2","C",06,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"03","De  Data     ?","","","mv_ch3","D",08,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"04","Ate Data     ?","","","mv_ch4","D",08,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","",""})

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

Return
