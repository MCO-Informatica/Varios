#include "rwmake.ch"        
#include "Protheus.ch"        


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT120FOL  ºAutor  ³Ricardo Nisiyama    º Data ³  27/06/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Adiciona campo na pasta customizada ^Importacao^ do pedido  º±±
±±º          ³de compra. PE em conjunto com o MT120TEL                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MT120FOL 

Local nOpc    := PARAMIXB[1]
Local aPosGet := PARAMIXB[2]   
Local _cNumPo := ""
cItems := SPACE(30)
aCombo := SPACE(01) 


If nOpc == 3 //inclusao
	_cNumPo   := Space(10)
	//Public _cObsPed      := Space(200)
Else
	_cHist := ""
/*	Do Case
		Case SC7->C7_MISTBX $ "1"
			_cHist := "1=CARTAO BNDES BB VISA"		
		Case SC7->C7_MISTBX $ "2"
			_cHist := "2=CARTAO BNDES CEF MASTERCARD"
		Case SC7->C7_MISTBX $ "3"
			_cHist := "3=CARTAO OUROCARD BB VISA"			
		Case SC7->C7_MISTBX & "4"
			_cHist := "4=CARTAO OUROCARD BB MASTERCARD"						
	EndCase	                    */
	
//	Public _cHitCondPg   := _cHist
	_cNumPo   := SC7->C7_NUMPO
	//Public _cObsPed      := SC7->C7_OBS2
Endif

If nOpc <> 1
 @ 006,aPosGet[3,1] SAY OemToAnsi('Numero P.O.:') OF oFolder:aDialogs[7] PIXEL SIZE 070,009 
 //@ 005,aPosGet[3,2] MSGET _cHitCondPg  PICTURE '@!' F3 "SZ3" OF oFolder:aDialogs[7] PIXEL SIZE 20,009 HASBUTTON
 @ 005,aPosGet[3,2] MSGET _cNumPo  PICTURE '@!'  OF oFolder:aDialogs[7] PIXEL SIZE 070,008 //HASBUTTON

 //@ 011,aPosGet[3,3] SAY OemToAnsi('Observacao:') OF oFolder:aDialogs[7] PIXEL SIZE 070,009 
 //@ 010,aPosGet[3,4] MSGET _cObsPed PICTURE '@!' OF oFolder:aDialogs[7] PIXEL SIZE 150,009 HASBUTTON
Endif 

Return Nil 

