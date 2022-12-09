#INCLUDE "TOPCONN.CH" 

user function PedComList 

local cPerg := "PComList"

criaSX1(cPerg)

if !Pergunte(cPerg, .T.)
	Return
endif   

getCli()
Imprime()  

If Select("SC7") <> 0
	DBSelectArea("SC7")
	DBCloseArea()
EndIf        
            
return  

//**************************

static function getCli    

local cQuery := ""

DbSelectArea("SA2"); DbSetOrder(1)


cQuery := "SELECT C7_NUM, C7_FORNECE, C7_LOJA, C7_EMISSAO, C7_CONAPRO, C7_TOTAL, C7_ITEM, C7_PRODUTO, C7_QTSEGUM, C7_SEGUM, C7_IPI, C7_PICM, C7_XXDTREV"
cQuery += "       C7_COND, C7_TPFRETE, C7_FRETE, C7_CC, C7_CONTA, C7_DESCRI, C7_QUANT, C7_PRECO, C7_XXREV, C7_MOEDA, C7_ENCER,  R_E_C_N_O_ NRECNO, "
cQuery += "       C7_DATPRF, C7_UM, C7_VALIPI, C7_USER, C7_APROV, C7_OBS, C7_DESC, C7_NUMSC, C7_ITEMCTA, C7_MSG, C7_REAJUST, C7_DESPESA, C7_SEGURO, C7_VALFRE, C7_VLDESC "
cQuery += " FROM " + RetSQLName("SC7") + " SC7 "
cQuery += "WHERE C7_FILIAL = '" + XFILIAL("SC7") + "' AND "
cQuery += "C7_NUM     >= '" + MV_PAR01 + "' AND  "
cQuery += "C7_NUM     <= '" + MV_PAR02 + "' AND  "
cQuery += "C7_FORNECE >= '" + MV_PAR03 + "' AND  "
cQuery += "C7_FORNECE <= '" + MV_PAR04 + "' AND  "
cQuery += "C7_EMISSAO >= '" + DTOS(MV_PAR05) + "' AND  "
cQuery += "C7_EMISSAO <= '" + DTOS(MV_PAR06) + "' AND  "
cQuery += "C7_PRODUTO >= '" + MV_PAR07 + "' AND  "
cQuery += "C7_PRODUTO <= '" + MV_PAR08 + "' AND  "
cQuery += "C7_ITEMCTA >= '" + MV_PAR09 + "' AND  "
cQuery += "C7_ITEMCTA <= '" + MV_PAR10 + "' AND  "
cQuery += "C7_CONAPRO <> 'B' AND "
cQuery += "SC7.D_E_L_E_T_ <> '*'"
cQuery += "ORDER BY C7_NUM, C7_ITEM"
cQuery := ChangeQuery(cQuery)

If Select("SC7") <> 0
	DBSelectArea("SC7")
	DBCloseArea()
EndIf 

TCQuery cQuery New Alias "SC7"
SC7->(DBGoTop())                    

return
                       
//**************************

static function imprime

local oPrint   := TMSPrinter():New(OemToAnsi('Relatorio')) //Cria um objeto que permite visualizar e imprimir relatorio.
local oFont    := TFont():New("Calibri",,8)   
local oFontCab := TFont():New("Calibri",,8,,.T.) 
local oFontTit := TFont():New("Calibri",,14,,.T.)
local nLinha   := 0
Private nCont  := 0
Private nCont1 := 1
Private Cont   := 1
Private Cont1  := 1


oPrint:SetLandScape() 
oPrint:SetPaperSize(9) 
oPrint:Setup()
  
oPrint:StartPage()
  
cFileLogo := "lgrl" + cEmpAnt + ".bmp"
//cFileLogo	:= GetSrvProfString('Startpath','') + 'LOGORECH02' + '.BMP';
nCont	:= 0

	//**********
	If Cont > Cont1
		nCont1 := nCont1 + 1
		Cont := 1
	Endif
	Cont := Cont + 1

	lCrtPag	:= .T.
	nLinMax	:= 32
	nLinAtu	:= 1
  
  	If lCrtPag
		nCont := nCont + 1

	Endif
	
	
	//**********

_nTamStr	:= 70
_lChkTam	:= .T.
_nTamDesc	:= 70

                     
do while !SC7->(Eof())
	

	if nLinha > 2300 .OR. nLinha == 0
	    if nLinha <> 0	
	    	
	    	If lCrtPag
				nCont := nCont + 1
		
			Endif
	    
			oPrint:EndPage()
		endif
		
		
		
		oPrint:Say  (0140,3100,"Página: " + Transform(StrZero(ncont,3),""),oFont) 
		//oPrint:Say  (0140,3120," de " +Transform(StrZero(ncont1,3),""),oFont) // ****
		
		oPrint:StartPage()	
		oPrint:Box	(0050,0050,0200,3300) //Box Cabeça
		
		oPrint:Box	(0050,0050,0200,550) // logo
		oPrint:SayBitmap(100,100,cFileLogo,400,70)
		
		oPrint:Box	(0050,0050,0200,3300) // Titulo Pedido
		oPrint:Say(0100,1500,"PEDIDOS DE COMPRA", oFontTit,,,,2)
		
		//oPrint:Box	(0200,0050,0260,3300) // Titulo Pedido   
		oPrint:Say(0210, 0050 , "NºPed"		, oFontCab)
		oPrint:Say(0210, 0150 , "C.Forn", oFontCab)
		oPrint:Say(0210, 0250 , "Fornecedor", oFontCab)
		oPrint:Say(0210, 0700 , "Item"			, oFontCab)
		oPrint:Say(0210, 0780 , "Cód.Prod."		, oFontCab)
		oPrint:Say(0210, 1000 , "Descrição"		, oFontCab)
		oPrint:Say(0210, 1850 , "QTD."			, oFontCab)
		oPrint:Say(0210, 2000 , "Un.", oFontCab)
		oPrint:Say(0210, 2100 , "Preço Unit.", oFontCab)
		oPrint:Say(0210, 2300 , "Total", oFontCab)
		oPrint:Say(0210, 2550 , "Dt.Entrega", oFontCab)
		oPrint:Say(0210, 2750 , "Item Contábil", oFontCab)
		oPrint:Say(0210, 3000 , "Dt.Emissão", oFontCab)
		oPrint:Say(0210, 3150 , "Status", oFontCab)
		nLinha := 280
		nLinhaBox := 282	
	endif
	
	//TRBPedComList
	
    oPrint:Say(nLinha, 0050, SC7->C7_NUM, oFont)
    oPrint:Say(nLinha, 0150, SC7->C7_FORNECE, oFont)
    oPrint:Say(nLinha, 0250, Posicione("SA2",1,xFilial("SA2") + SC7->C7_FORNECE,"A2_NREDUZ"), oFont) 
    oPrint:Say(nLinha, 0700, SC7->C7_ITEM, oFont)
    oPrint:Say(nLinha, 0780, SC7->C7_PRODUTO, oFont)
    
    oPrint:Say(nLinha, 1850, Transform(SC7->C7_QUANT,"@E 999,999.9999") , oFont)
    oPrint:Say(nLinha, 2000, SC7->C7_UM, oFont)
    oPrint:Say(nLinha, 2100, Transform(SC7->C7_PRECO,"@E 999,999,999.99"), oFont)
    oPrint:Say(nLinha, 2300, Transform(SC7->C7_TOTAL,"@E 999,999,999.99"), oFont)
    oPrint:Say(nLinha, 2550, Substr(SC7->C7_DATPRF,7,2) + "/" + Substr(SC7->C7_DATPRF,5,2) + "/" + Substr(SC7->C7_DATPRF,1,4), oFont)
    oPrint:Say(nLinha, 2750, SC7->C7_ITEMCTA, oFont)
    oPrint:Say(nLinha, 3000, Substr(SC7->C7_EMISSAO,7,2) + "/" + Substr(SC7->C7_EMISSAO,5,2) + "/" + Substr(SC7->C7_EMISSAO,1,4), oFont)//TRBPedComList->C7_EMISSAO, oFont)
    IF SC7->C7_ENCER == "E"    	
    	oPrint:Say(nLinha, 3150, "Fechado", oFont)
    else
    	oPrint:Say(nLinha, 3150, "Aberto", oFont)
    endif
    //******************************
    if len(alltrim(SC7->C7_DESCRI)) > 45
	    For nXi := 1 To MLCount(SC7->C7_DESCRI,45)
	    If ! Empty(MLCount(SC7->C7_DESCRI,45))
	          If ! Empty(MemoLine(SC7->C7_DESCRI,45,nXi))
	               oPrint:Say(nLinha,1100,OemToAnsi(MemoLine(SC7->C7_DESCRI,45,nXi)),oFont)
	               oPrint:Box	(nLinha+2,0050,nLinha+2,3300)   
	               nLinha += 50
	          EndIf
	    EndIf
	    
		Next nXi
		nLinha -= 50
	else
		oPrint:Say(nLinha, 1100, SC7->C7_DESCRI, oFont)
	endif
    //******************************
    
    //oPrint:Say(nLinha, 1000, SC7->C7_DESCRI, oFont)

    oPrint:Box	(nLinha+2,0050,nLinha+2,3300)              
    nLinha += 50     
    nLinhaBox += 50
         
	SC7->(DbSkip())

enddo  
      
nCont := nCont + 1 //==============
nCont1 := nCont1 + 1 //============== 
  
oPrint:EndPage() 
oPrint:Preview()

return  

//**************************

static function criaSX1(cPerg)

cAlias	:= Alias()
_nPerg 	:= 1

dbSelectArea("SX1")
dbSetOrder(1)
If dbSeek(cPerg)
	DO WHILE ALLTRIM(SX1->X1_GRUPO) == ALLTRIM(cPerg)
		_nPerg := _nPerg + 1
		DBSKIP()
	ENDDO
ENDIF

aRegistro:= {}
//          Grupo/Ordem/Pergunt              		/SPA/ENG/Variavl/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/DefSPA1/DefENG1/Cnt01/Var02/Def02/DefSPA2/DefENG2/Cnt02/Var03/Def03/DefSPA3/DefENG3/Cnt03/Var04/Def04/DefSPA4/DefENG4/Cnt04/Var05/Def05/DefSPA5/DefENG5/Cnt05/F3/Pyme/GRPSXG/HELP/PICTURE
aAdd(aRegistro,{cPerg,"01","Do Pedido?		","","","mv_ch1","C",06,00,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SC7","","","",""})
aAdd(aRegistro,{cPerg,"02","Ate Pedido?		","","","mv_ch2","C",06,00,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SC7","","","",""})
aAdd(aRegistro,{cPerg,"03","Do Fornecedor?	","","","mv_ch3","C",06,00,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SA2","","","",""})
aAdd(aRegistro,{cPerg,"04","Ate Fornecedor?	","","","mv_ch4","C",06,00,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SA2","","","",""})
aAdd(aRegistro,{cPerg,"05","Da Emissao?		","","","mv_ch5","D",08,00,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegistro,{cPerg,"06","Ate Emissao?	","","","mv_ch6","D",08,00,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegistro,{cPerg,"07","Do Produto?		","","","mv_ch7","C",25,00,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","SB1","","","",""})
aAdd(aRegistro,{cPerg,"08","Ate Produto?	","","","mv_ch8","C",25,00,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","SB1","","","",""})
aAdd(aRegistro,{cPerg,"09","Do Item Conta?	","","","mv_ch9","C",13,00,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","CTD","","","",""})
aAdd(aRegistro,{cPerg,"10","Ate Item Conta?	","","","mv_cha","C",13,00,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","CTD","","","",""})
aAdd(aRegistro,{cPerg,"11","Imprim./Visual?	","","","mv_chb","N",01,00,2,"N","","mv_par11","Imprimir","","","","","Visua.Impr.","","","","","","","","","","","","","","","","","","","   ","","","",""})
IF Len(aRegistro) >= _nPerg
	For i:= _nPerg  to Len(aRegistro)
		Reclock("SX1",.t.)
		For j:=1 to FCount()
			If J<= LEN (aRegistro[i])
				FieldPut(j,aRegistro[i,j])
			Endif
		Next
		MsUnlock()
	Next
EndIf
dbSelectArea(cAlias)
return 