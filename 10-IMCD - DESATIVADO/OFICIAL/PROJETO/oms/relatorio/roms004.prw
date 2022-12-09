#INCLUDE "rwmake.ch"
#INCLUDE "protheus.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ROMS004   º Autor ³ Giane              º Data ³  30/03/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatorio Ordem Operacao de carga                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Makeni - OMS                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function ROMS004 
	Local _aArea := GetArea()
	Local Tamanho := "G"     
	Local cString := "SC5" 

	//oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "ROMS004" , __cUserID )

	Private oPrint
	Private cPerg := "ROMS004"    
	Private nRow1 := 0

	CriaSX1(cPerg)
	//pergunte(cPerg,.f.)

	wnrel:="ROMS004"  
	titulo := ""
	cDesc1 := ""
	cDesc2 := ""
	cDesc3 := ""

	oPrint:=TMSPrinter():New( "Ordem de Operação de Carga" )
	oPrint:SetLandscape() // ou SetPortrait()
	oPrint:StartPage()   // Inicia uma nova página  
	oPrint:SetPaperSize(9) 

	if !oPrint:Setup()     
		oPrint:EndPage()
		RestArea(_aArea)             
		Return nil
	endif 

	Impress(oPrint)

	oPrint:EndPage()     // Finaliza a página

	oPrint:Preview()     // Visualiza antes de imprimir
	RestArea(_aArea)
Return nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³  Impress ³ Autor ³ Giane                 ³ Data ³ 30/03/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Rotina monta a impressao da ordem de operacao de carga     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico Makeni - OMS                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function Impress(oPrint)

	LOCAL oFont16n
	LOCAL oFont24
	LOCAL oFont12, oFont12n
	LOCAL oFont18, oFont14n
	Local nCount := 0

	Private oFont10n, oFont10

	//Parametros de TFont.New()
	//1.Nome da Fonte (Windows)
	//3.Tamanho em Pixels
	//5.Bold (T/F)

	oFont10  := TFont():New("Arial",9,10,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont16n := TFont():New("Arial",9,16,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont24  := TFont():New("Arial",9,24,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont18  := TFont():New("Arial",9,18,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont10n := TFont():New("Arial",9,10,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont12  := TFont():New("Arial",9,12,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont12n := TFont():New("Arial",9,12,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont14n := TFont():New("Arial",9,14,.T.,.F.,5,.T.,5,.T.,.F.)

	_nPag := 0                                 

	oPrint:Box(nRow1+060,100,nRow1+2300,3300) //desenha o box grande do tamanho da folha               

	oPrint:Say(nRow1+0070,1050,"ORDEM DE OPERAÇÃO DE CARGA"  ,oFont24)
	nRow1 := nRow1 + 0260                        

	oPrint:Line(nRow1,101,nRow1,3299) 

	nRow1 := nRow1 + 0015
	oPrint:Say(nRow1,105,"Data:" ,oFont16n) 
	oPrint:Say(nRow1,730, "_____/_____/_____",oFont16n)  
	oPrint:Say(nRow1,1310, "Emitido Por: " ,oFont16n) 

	oPrint:Line(nRow1+65,101,nRow1+65,3299)                                   
	oPrint:Line(nRow1+85,101,nRow1+85,3299)  

	nRow1 :=nRow1 + 0085 
	oPrint:Line(nRow1,0710,nRow1+0390,0710) //imprime barra vertical  

	oPrint:Say(nRow1+0005,0720,"1" ,oFont18) 
	oPrint:Line(nRow1+65,710,nRow1+65,3299)  

	nRow1 := nRow1 + 0065
	oPrint:Say(nRow1+0005,0720,"2" ,oFont18) 
	oPrint:Line(nRow1+65,710,nRow1+65,3299)  

	nRow1 := nRow1 + 0065  
	oPrint:Say(nRow1+0030,0240,"C L I E N T E S" ,oFont18) 
	oPrint:Say(nRow1+0005,0720,"3" ,oFont18) 
	oPrint:Line(nRow1+65,710,nRow1+65,3299)  

	nRow1 := nRow1 + 0065
	oPrint:Say(nRow1+0005,0720,"4" ,oFont18) 
	oPrint:Line(nRow1+65,710,nRow1+65,3299)  

	nRow1 := nRow1 + 0065
	oPrint:Say(nRow1+0005,0720,"5" ,oFont18) 
	oPrint:Line(nRow1+65,710,nRow1+65,3299)  

	nRow1 := nRow1 + 0065
	oPrint:Say(nRow1+0005,0720,"6" ,oFont18) 
	oPrint:Line(nRow1+65,101,nRow1+65,3299)  
	nRow1 := nRow1 + 0065

	nRow1 := nRow1 + 0040
	oPrint:Line(nRow1,101,nRow1,3299)
	oPrint:Say(nRow1+0005,0105,"TRANSPORTADORA:" ,oFont16n) 
	oPrint:Say(nRow1+0005,2400,"PLACA DO VEÍCULO:" ,oFont16n)  

	nRow1 := nRow1 + 0065
	oPrint:Line(nRow1,101,nRow1,3299)
	oPrint:Say(nRow1+0005,0105,"HORÁRIO DE INÍCIO: _____:_____" ,oFont16n) 
	oPrint:Say(nRow1+0005,1250,"TEMPERATURA: _____ºC" ,oFont16n) 
	oPrint:Say(nRow1+0005,2335,"HORÁRIO DE TÉRMINO:" ,oFont16n) 

	nRow1 := nRow1 + 0065
	oPrint:Line(nRow1+0005,101,nRow1+0005,3299)

	nRow1 := nRow1 + 0040
	oPrint:Line(nRow1,101,nRow1,3299)    

	oPrint:Say(nRow1+0005,1700,"ATENÇÃO:" ,oFont18) 
	nRow1 := nRow1 + 0065
	oPrint:Say(nRow1+0005,1300,"UTILIZAR TODOS OS EPI'S NECESSÁRIOS" ,oFont16n) 
	nRow1 := nRow1 + 0065
	oPrint:Say(nRow1+0005,0550,"VERIFICAR SE AS CONEXÕES ESTÃO CORRETAS, VERIFICAR SE O TANQUE DO VEÍCULO ESTÁ LIMPO" ,oFont16n) 
	nRow1 := nRow1 + 0065
	oPrint:Say(nRow1+0005,0550,"VERIFICAR O ATERRAMENTO DOS EQUIPAMENTOS E SE A BOCA DE VISITA DO VEÍCULO ESTÁ ABERTA" ,oFont16n) 
	nRow1 := nRow1 + 0065
	oPrint:Line(nRow1+0005,101,nRow1+0005,3299)

	nRow1 :=nRow1 + 0005 //0010      
	nInc := 415
	oPrint:Say(nRow1,0105,"PRODUTO:" ,oFont10)  
	oPrint:Box(nRow1,1000,nRow1+nInc,1000) 
	oPrint:Say(nRow1,1020,"ATERRAMENTO" ,oFont10)
	oPrint:Box(nRow1,1250,nRow1+nInc,1250)        
	oPrint:Say(nRow1,1330,"TANQUE" ,oFont10)
	oPrint:Box(nRow1,1510,nRow1+nInc,1510)   
	oPrint:Say(nRow1,1530,"CONEXÕES OK?" ,oFont10) 
	oPrint:Box(nRow1,1790,nRow1+nInc,1790)          
	oPrint:Say(nRow1,1810,"BOCA DE VISITA" ,oFont10) 
	oPrint:Box(nRow1,2060,nRow1+nInc,2060)
	oPrint:Say(nRow1,2080,"Nº TICKET" ,oFont10) 
	oPrint:Box(nRow1,2240,nRow1+nInc,2240)
	oPrint:Say(nRow1,2260,"TQ VEICULO" ,oFont10) 
	oPrint:Box(nRow1,2460,nRow1+nInc,2460)
	oPrint:Say(nRow1,2480," QUANT.L" ,oFont10)
	oPrint:Box(nRow1,2640,nRow1+nInc,2640)
	oPrint:Say(nRow1,2660," QUANT.KG" ,oFont10)
	oPrint:Box(nRow1,2840,nRow1+nInc,2840)
	oPrint:Say(nRow1,2860,"BOM" ,oFont10)
	oPrint:Box(nRow1,2940,nRow1+nInc,2940)
	oPrint:Say(nRow1,2960,"TQ" ,oFont10) 
	oPrint:Box(nRow1,3030,nRow1+nInc,3030)
	oPrint:Say(nRow1,3050,"RESP" ,oFont10)   

	nRow1 := nRow1 + 0040
	oPrint:Say(nRow1,1100,"OK? " ,oFont10)
	oPrint:Say(nRow1,1260,"VEICULO LIMPO?" ,oFont10)
	oPrint:Say(nRow1,1860,"ABERTA?" ,oFont10) 
	oPrint:Say(nRow1,2880,"BA" ,oFont10)                  

	fLinProd("1", 0045)
	For nCount := 2 to 6
		fLinProd( STR(NCOUNT,1) , 0055)
	Next
	oPrint:Line(nRow1+0055,101,nRow1+0055,3299)
	nRow1 := nRow1 + 0055
	oPrint:Line(nRow1+0040,101,nRow1+0040,3299)             
	nRow1 := nRow1 +  0045 

	oPrint:Say(nRow1+0005,0105,"DENSIDADE G/CM3" ,oFont14n) 
	oPrint:Say(nRow1+0005,0700,"1- _______________" ,oFont14n) 
	oPrint:Say(nRow1+0005,1095,"2- _______________" ,oFont14n) 
	oPrint:Say(nRow1+0005,1485,"3- _______________" ,oFont14n) 
	oPrint:Say(nRow1+0005,1875,"4- _______________" ,oFont14n) 
	oPrint:Say(nRow1+0005,2265,"5- _______________" ,oFont14n) 
	oPrint:Say(nRow1+0005,2655,"6- _______________" ,oFont14n) 
	oPrint:Line(nRow1+0060,101,nRow1+0060,3299)    
	nRow1 := nRow1 + 60

	oPrint:Say(nRow1+0005,0105,"Nº DOS LACRES: " ,oFont14n)    
	oPrint:Box(nRow1,0495,nRow1+0060,0495) 
	oPrint:Say(nRow1+0005,0500,"1" ,oFont14n)

	oPrint:Box(nRow1,1900,nRow1+0060,1900) 
	oPrint:Say(nRow1+0005,1905,"2" ,oFont14n) 
	nRow1 := nRow1 + 60

	oPrint:Line(nRow1,101,nRow1,3299) 
	oPrint:Say(nRow1+0005,0105,"3" ,oFont14n) 
	oPrint:Box(nRow1,1900,nRow1+0060,1900) 
	oPrint:Say(nRow1+0005,1905,"4" ,oFont14n) 
	nRow1 := nRow1 + 60

	oPrint:Line(nRow1,101,nRow1,3299) 
	oPrint:Say(nRow1+0005,0105,"5" ,oFont14n) 
	oPrint:Box(nRow1,1900,nRow1+0060,1900) 
	oPrint:Say(nRow1+0005,1905,"6" ,oFont14n) 
	nRow1 := nRow1 + 60               

	oPrint:Line(nRow1,101,nRow1,3299)  
	oPrint:Say(nRow1+0005,0105,"OBSERVAÇÕES: " ,oFont14n)  
	nRow1 := nRow1 + 60              
	oPrint:Line(nRow1,101,nRow1,3299)
	nRow1 := nRow1 + 60              
	oPrint:Line(nRow1,101,nRow1,3299)

	nRow1 := nRow1 + 150             
	oPrint:Line(nRow1,101,nRow1,2700)
	oPrint:Say(nRow1+0005,0105,"Visto Operador 1" ,oFont14n) 
	oPrint:Say(nRow1+0005,0750,"Visto Operador 2" ,oFont14n) 
	oPrint:Say(nRow1+0005,1550,"Visto Supervisor" ,oFont14n) 
	oPrint:Say(nRow1+0005,2200,"Visto Segurança"  ,oFont14n) 

	oPrint:EndPage() // Finaliza a página

Return Nil


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ fLinProd ³ Autor ³   Giane               ³ Data ³ 07/04/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime Linha dos Produtos                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/             
Static Function fLinProd(cItem, nSLin)

	oPrint:Line(nRow1+nSLin,101,nRow1+nSLin,3299) 
	nRow1 := nRow1 + nSLin
	oPrint:Say(nRow1+0005,0105,cItem ,oFont10) 
	oPrint:Box(nRow1+0007,1015,nRow1+0035,1045)
	oPrint:Say(nRow1,1050,"SIM" ,oFont10n)  
	oPrint:Box(nRow1+0007,1120,nRow1+0035,1160)
	oPrint:Say(nRow1,1165,"NAO" ,oFont10n)  

	oPrint:Box(nRow1+0007,1260,nRow1+0035,1290)
	oPrint:Say(nRow1,1295,"SIM" ,oFont10n)  
	oPrint:Box(nRow1+0007,1375,nRow1+0035,1405)
	oPrint:Say(nRow1,1410,"NAO" ,oFont10n)

	oPrint:Box(nRow1+0007,1530,nRow1+0035,1560) 
	oPrint:Say(nRow1,1565,"SIM" ,oFont10n)  
	oPrint:Box(nRow1+0007,1645,nRow1+0035,1675)
	oPrint:Say(nRow1,1680,"NAO" ,oFont10n)

	oPrint:Box(nRow1+0007,1810,nRow1+0035,1840)                                           
	oPrint:Say(nRow1,1845,"SIM" ,oFont10n)  
	oPrint:Box(nRow1+0007,1925,nRow1+0035,1955)
	oPrint:Say(nRow1,1960,"NAO" ,oFont10n)  

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ CriaSX1  ³ Autor ³   Luis Henrique       ³ Data ³ 17/10/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Ajusta Grupo de Perguntas                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function CriaSX1(cPerg)

	Local _aArea := GetArea()



	RestArea(_aArea)
Return
