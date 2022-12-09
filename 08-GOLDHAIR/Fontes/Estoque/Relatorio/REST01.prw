#include "rwmake.ch"
#INCLUDE "PROTHEUS.CH"                                                                        
#include "TBICONN.CH"
#include "TBICODE.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³REST01   ºAutor  ³Guilherme Giuliano   º Data ³  13/11/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Programa para impressao de etiqueta de produtos            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GOLD HAIR                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


************************************************************************
User Function REST01                                                     
************************************************************************
Private nRBanco := 1
Private nOpca := 0   
Private cPerg := ""                            

@ 001,001 TO 150,170 DIALOG oDlg TITLE OemToAnsi("Geração de Boleto")

@ 003, 004 SAY oSay2 PROMPT "Escolha o Tipo de Impressao:" SIZE 060, 007 OF oDlg COLORS 0, 16777215 PIXEL
@ 015, 004 RADIO oRadMenu1 VAR nRBanco ITEMS "Materia Prima","Produto Acabado","Dados Cliente" SIZE 160, 019 OF oDlg COLOR 0, 16777215 PIXEL 

@ 048,015 BUTTON "&Ok"       SIZE 25,12 PIXEL ACTION (nOpca := 1,oDlg:End())
@ 048,048 BUTTON "&Cancelar" SIZE 25,12 PIXEL ACTION (nOpca := 0,oDlg:End())

ACTIVATE MSDIALOG oDlg CENTER
// Define Variaveis
                                                                            
IF nOpca == 0
	Return
ENDIF                 

do case
	case nRBanco == 1 	                
		cPerg := PADR("REST01A",10)
		AjustaSX1()
		Pergunte(cPerg,.F.)
		IF Pergunte(cPerg,.T.)
			U_REST01A()
		ELSE
			Return
		ENDIF
	case nRBanco == 2
		cPerg := PADR("REST01B",10)
		AjustaSX1()
		Pergunte(cPerg,.F.)
		IF Pergunte(cPerg,.T.)
			U_REST01B()
		ELSE
			Return
		ENDIF
	case nRBanco == 3
		cPerg := PADR("REST01C",10)
		AjustaSX1()
		Pergunte(cPerg,.F.)
		IF Pergunte(cPerg,.T.)
			U_REST01C()
		ELSE
			Return
		ENDIF
End case	

Return


************************************************************************
User Function REST01A
************************************************************************
Local a_linha := {}
Local c_resto
Local nX   := 0
Local nYh  := 0
Local nYm  := 0
Local nYp  := 0
Local nlen := 0
Local cPac := space(40)
Local cHos := ""
Local cMed := ""
Local nCopias := IF(MV_PAR08 == 0,1,MV_PAR08)
Local _cModelo := "ELTRON" //ELTRON
Local _cPorta := "LPT1" // "COM1" + "9600,E,8,2"
Local nLinha := 0
Local aMemo  := {}

dbselectarea("SB1")
dbsetorder(1)
dbseek(xFilial("SB1")+MV_PAR01) 

dbselectarea("SA2")
dbsetorder(1)
lSa2 := dbseek(xFilial("SA2")+PADR(MV_PAR03,6))		

For nX := 1 To nCopias

	MSCBPRINTER(_cModelo,_cPorta,,,.F.)

	MSCBBEGIN(1,3)
    
/*	cCodBarras := Alltrim(MV_PAR02)+" "+Alltrim(MV_PAR03)+" "+substr(dtoc(MV_PAR04),1,2)+substr(dtoc(MV_PAR04),4,2)+substr(dtoc(MV_PAR04),7,2)
	cCodBarras := STRTRAN(cCodBarras,"/","") 
	cCodBarras := IF(len(alltrim(cCodBarras))>29,alltrim(STRTRAN(cCodBarras,"-","")),alltrim(cCodBarras))
	MSCBSAYBAR(IF(len(alltrim(cCodBarras))>29,10,15),02,substr(cCodBarras,1,29),'N','MB07',11,.f.,.t.,,,2,2)
*/				
	nLin := 5
	MSCBSAY(018 ,nLin,"CONTROLE DE QUALIDADE",'N','1','2,2')
	nLin += 10
	MSCBLINEH(02,nLin-2,110,2,"B")
	MSCBSAY(005 ,nLin,"PRODUTO: ",'N','1','2,2')
	MSCBSAY(030 ,nLin,SUBSTR(SB1->B1_DESC,1,25), "N", "1", "2,2")
	IF len(Alltrim(SB1->B1_DESC)) > 25
		nLin += 4
		MSCBSAY(030 ,nLin,substr(SB1->B1_DESC,26), "N", "1", "2,2")
	ENDIF
	MSCBLINEH(02,nLin+3,110,2,"B")
	nLin += 6
	MSCBSAY(005 ,nLin,"CODIGO: ",'N','1','2,2')
	MSCBSAY(030 ,nLin,SB1->B1_COD,'N','1','2,2')			
	MSCBLINEH(02,nLin+3,110,2,"B")
	nLin += 6
	MSCBSAY(005 ,nLin,"QUANT: ",'N','1','2,2')
	MSCBSAY(030 ,nLin,Transform(MV_PAR02,"@E 9999999.999")+" "+Alltrim(SB1->B1_UM), "N", "1", "2,2")
	MSCBLINEH(02,nLin+3,110,2,"B")
	nLin += 6
	MSCBSAY(005 ,nLin,"FORNEC: ",'N','1','2,2')
	MSCBSAY(030 ,nLin,substr(Upper(Alltrim(SA2->A2_NOME)),1,25),'N','1','2,2')			
	IF len(Alltrim(SA2->A2_NOME)) > 25
		nLin += 4
		MSCBSAY(030 ,nLin,substr(SA2->A2_NOME,26), "N", "1", "2,2")
	ENDIF
	MSCBLINEH(02,nLin+3,110,2,"B")
	nLin += 6
	MSCBSAY(005 ,nLin,"LOTE: ",'N','1','2,2')
	MSCBSAY(030 ,nLin,MV_PAR04, "N", "1", "2,2")
	MSCBLINEH(02,nLin+3,110,2,"B")	
	nLin += 6
	MSCBSAY(005 ,nLin,"VALIDADE: ",'N','1','2,2')
	MSCBSAY(030 ,nLin,dtoc(MV_PAR05),'N','1','2,2')			
	MSCBLINEH(02,nLin+3,110,2,"B")	
	nLin += 6
	MSCBSAY(005 ,nLin,"DATA: ",'N','1','2,2')
	MSCBSAY(030 ,nLin,dtoc(MV_PAR06),'N','1','2,2')			
	MSCBLINEH(02,nLin+3,110,2,"B")
	nLin += 6
	MSCBSAY(005 ,nLin,"ANALISTA: ",'N','1','2,2')
	MSCBSAY(030 ,nLin,UPPER(MV_PAR07),'N','1','2,2')				
	MSCBLINEH(02,nLin+3,110,2,"B")


	MSCBEND()

	MSCBCLOSEPRINTER()	
Next nx

Return                                                

************************************************************************
User Function REST01B
************************************************************************
Local a_linha := {}
Local c_resto
Local nX   := 0
Local nYh  := 0
Local nYm  := 0
Local nYp  := 0
Local nlen := 0
Local cPac := space(40)
Local cHos := ""
Local cMed := ""
Local nCopias := IF(MV_PAR06 == 0,1,MV_PAR06)
Local _cModelo := "ELTRON" //ELTRON
Local _cPorta := "LPT1" // "COM1" + "9600,E,8,2"
Local nLinha := 0
Local aMemo  := {}

dbselectarea("SB1")
dbsetorder(1)
dbseek(xFilial("SB1")+MV_PAR01) 

For nX := 1 To nCopias

	MSCBPRINTER(_cModelo,_cPorta,,,.F.)

	MSCBBEGIN(1,3)
    
	nLin := 10
	MSCBLINEH(02,nLin-2,110,2,"B")
	MSCBSAY(005 ,nLin,"PRODUTO: ",'N','1','2,2')
	MSCBSAY(030 ,nLin,SUBSTR(SB1->B1_DESC,1,25), "N", "1", "2,2")
	IF len(Alltrim(SB1->B1_DESC)) > 25
		nLin += 4
		MSCBSAY(030 ,nLin,substr(SB1->B1_DESC,26), "N", "1", "2,2")
	ENDIF
	MSCBLINEH(02,nLin+4,110,2,"B")
	nLin += 7
	MSCBSAY(005 ,nLin,"CODIGO: ",'N','1','2,2')
	MSCBSAY(030 ,nLin,SB1->B1_COD,'N','1','2,2')			
	MSCBLINEH(02,nLin+4,110,2,"B")
	nLin += 7
	MSCBSAY(005 ,nLin,"QUANT: ",'N','1','2,2')
	MSCBSAY(030 ,nLin,Transform(MV_PAR05,"@E 9999999.999")+" "+Alltrim(SB1->B1_UM), "N", "1", "2,2")
	MSCBLINEH(02,nLin+4,110,2,"B")
	nLin += 7
	MSCBSAY(005 ,nLin,"LOTE: ",'N','1','2,2')
	MSCBSAY(030 ,nLin,MV_PAR02, "N", "1", "2,2")
	MSCBLINEH(02,nLin+4,110,2,"B")	
	nLin += 7
	MSCBSAY(005 ,nLin,"DATA FAB: ",'N','1','2,2')
	MSCBSAY(030 ,nLin,dtoc(MV_PAR03),'N','1','2,2')			
	MSCBLINEH(02,nLin+4,110,2,"B")
	nLin += 7
	MSCBSAY(005 ,nLin,"VALIDADE: ",'N','1','2,2')
	MSCBSAY(030 ,nLin,dtoc(MV_PAR04),'N','1','2,2')			
	MSCBLINEH(02,nLin+4,110,2,"B")	
	nLin += 8
	MSCBSAYBAR(10,nLin,Alltrim(SB1->B1_CODBAR),'N','MB07',11,.f.,.t.,,,2,4)
	MSCBEND()

	MSCBCLOSEPRINTER()	
Next nx

Return

************************************************************************
User Function REST01C
************************************************************************
Local a_linha := {}
Local c_resto
Local nX   := 0
Local nYh  := 0
Local nYm  := 0
Local nYp  := 0
Local nlen := 0
Local cPac := space(40)
Local cHos := ""
Local cMed := ""
Local nCopias := IF(MV_PAR03 == 0,1,MV_PAR03)
Local _cModelo := "ELTRON" //ELTRON
Local _cPorta := "LPT1" // "COM1" + "9600,E,8,2"
Local nLinha := 0
Local aMemo  := {}

dbselectarea("SF2")
dbsetorder(1)
dbseek(xFilial("SF2")+PADR(MV_PAR01,9)+PADR(MV_PAR02,9))		
                                                                
IF !SF2->F2_TIPO $ "B|D"
	dbselectarea("SF2")
	dbsetorder(1)
	dbseek(xFilial("SF2")+PADR(MV_PAR01,9)+PADR(MV_PAR02,3))		
	cCliente := SF2->F2_CLIENTE
	cLoja    := SF2->F2_LOJA
	dEmissao := SF2->F2_EMISSAO
	nCopias  := IF(!Empty(SF2->F2_VOLUME1),SF2->F2_VOLUME1,nCopias)	
	dbselectarea("SA1")
	dbsetorder(1)
	dbseek(xFilial("SA1")+cCliente+cLoja)
	cNome := SA1->A1_NOME			
	cEnd := SA1->A1_END
	cMun := SA1->A1_MUN
	cCep := TRANSFORM(SA1->A1_CEP,"@R 99999-999")
	cBairro := SA1->A1_BAIRRO
	cEst := SA1->A1_EST 
	
ELSE
	dbselectarea("SF1")
	dbsetorder(1)
	dbseek(xFilial("SF1")+PADR(MV_PAR01,9)+PADR(MV_PAR02,3))		
	cCliente := SF1->F1_FORNECE
	cLoja    := SF1->F1_LOJA
	dEmissao := SF1->F1_DTDIGIT
	nCopias  := IF(!Empty(SF1->F1_VOLUME1),SF1->F1_VOLUME1,nCopias)
	dbselectarea("SA2")
	dbsetorder(1)
	dbseek(xFilial("SA2")+cCliente+cLoja)
	cNome := SA2->A2_NOME			
	cEnd := SA2->A2_END
	cMun := SA2->A2_MUN
	cCep := TRANSFORM(SA2->A2_CEP,"@R 99999-999")
	cBairro := SA2->A2_BAIRRO
	cEst := SA2->A2_EST 
ENDIF	

For nX := 1 To nCopias

	MSCBPRINTER(_cModelo,_cPorta,,,.F.)

	MSCBBEGIN(1,3)
    
	nLin := 5
	MSCBSAY(008 ,nLin,"NOTA FISCAL: "+alltrim(MV_PAR01)+"  SERIE: "+MV_PAR02,'N','1','2,2')
	nLin += 4
	MSCBSAY(008 ,nLin,"EMISSAO: "+dtoc(dEmissao)+"   VOLUME: "+strzero(nX,3)+"/"+strzero(nCopias,3),'N','1','2,2')
	nLin += 7
	MSCBLINEH(002,nLin-2,110,2,"B")
	MSCBSAY(030 ,nLin,"DESTINATARIO",'N','1','2,2')
	nLin += 6
	MSCBSAY(005 ,nLin,"CLIENTE:", "N", "1", "1,2")
	MSCBSAY(018 ,nLin,UPPER(substr(Alltrim(cNome),1,25)), "N", "1", "1,2")
	nLin += 4                                                      
	MSCBSAY(005 ,nLin,"ENDERECO:", "N", "1", "1,2")
	MSCBSAY(018 ,nLin,UPPER(Alltrim(substr(cEnd,1,32))), "N", "1", "1,2")
	MSCBSAY(060 ,nLin,"CEP:", "N", "1", "1,2")
	MSCBSAY(072 ,nLin,UPPER(Alltrim(cCep)), "N", "1", "1,2")
	IF len(Alltrim(cEnd)) > 32
		nLin += 4
		MSCBSAY(018 ,nLin,UPPER(Alltrim(substr(cEnd,33))), "N", "1", "2,2")
	ENDIF
	nLin += 4                                                      
	MSCBSAY(005 ,nLin,"BAIRRO:", "N", "1", "1,2")
	MSCBSAY(018 ,nLin,UPPER(Alltrim(cBairro)), "N", "1", "1,2")	
	MSCBSAY(060 ,nLin,"CID/EST:", "N", "1", "1,2")
	MSCBSAY(072 ,nLin,UPPER(Alltrim(cMun))+"/"+UPPER(cEst), "N", "1", "1,2")	
	nLin += 5
	MSCBLINEH(02,nLin,110,2,"B")
	nLin += 4
	MSCBSAY(030 ,nLin,"REMETENTE",'N','1','2,2')
	nLin += 6	    
	MSCBSAY(005 ,nLin,"EMPRESA:", "N", "1", "1,2")
	MSCBSAY(018 ,nLin,UPPER(substr(Alltrim(SM0->M0_NOMECOM),1,60)), "N", "1", "1,2")
	nLin += 4                                                      
	MSCBSAY(005 ,nLin,"ENDERECO:", "N", "1", "1,2")
	MSCBSAY(018 ,nLin,UPPER(Alltrim(SM0->M0_ENDCOB)), "N", "1", "1,2")
	MSCBSAY(060 ,nLin,"CEP:", "N", "1", "1,2")
	MSCBSAY(072 ,nLin,Alltrim(TRANSFORM(SM0->M0_CEPCOB,"@R 99999-999")), "N", "1", "1,2")
	nLin += 4                                                      
	MSCBSAY(005 ,nLin,"BAIRRO:", "N", "1", "1,2")
	MSCBSAY(018 ,nLin,UPPER(Alltrim(SM0->M0_BAIRCOB)), "N", "1", "1,2")	
	MSCBSAY(060 ,nLin,"CID/EST:", "N", "1", "1,2")
	MSCBSAY(072 ,nLin,UPPER(Alltrim(SM0->M0_CIDCOB))+"/"+UPPER(SM0->M0_ESTCOB), "N", "1", "1,2")	
	nLin += 5        
	MSCBLINEH(02,nLin,100,2,"B")

	MSCBEND()

	MSCBCLOSEPRINTER()	
Next nx

Return

******************************************************
Static Function AjustaSX1                             
******************************************************

do Case
	Case nRBanco == 1
		PutSx1(	cPerg, "01", "Produto? ",         ".", ".","mv_ch1", "C", 15, 0, 0, "G", "", "SB1", "", "","mv_par01", "", "", "", "", "", "", "", "","", "", "", "", "", "", "", "","", "", "" )
		PutSx1(	cPerg, "02", "Quantidade? ", 	  ".", ".","mv_ch2", "N", 12, 3, 0, "G", "", "", 	  "", "","mv_par02", "", "", "", "", "", "", "", "","", "", "", "", "", "", "", "","", "", "" )
		PutSx1(	cPerg, "03", "Fornecedor? ",      ".", ".","mv_ch3", "C", 06, 0, 0, "G", "", "SA2",   "", "","mv_par03", "", "", "", "", "", "", "", "","", "", "", "", "", "", "", "","", "", "" )
		PutSx1(	cPerg, "04", "Lote	 ? ",         ".", ".","mv_ch4", "C", 12, 0, 0, "G", "", "",      "", "","mv_par04", "", "", "", "", "", "", "", "","", "", "", "", "", "", "", "","", "", "" )
		PutSx1(	cPerg, "05", "Validade? ",        ".", ".","mv_ch5", "D", 08, 0, 0, "G", "", "",      "", "","mv_par05", "", "", "", "", "", "", "", "","", "", "", "", "", "", "", "","", "", "" )
		PutSx1(	cPerg, "06", "Emissão? ", 		  ".", ".","mv_ch6", "D", 08, 0, 0, "G", "", "",      "", "","mv_par06", "", "", "", "", "", "", "", "","", "", "", "", "", "", "", "","", "", "" )
		PutSx1(	cPerg, "07", "Analista? ",        ".", ".","mv_ch7", "C", 15, 0, 0, "G", "", "",      "", "","mv_par07", "", "", "", "", "", "", "", "","", "", "", "", "", "", "", "","", "", "" )
		PutSx1(	cPerg, "08", "Copias? ",          ".", ".","mv_ch8", "N", 03, 0, 0, "G", "", "",      "", "","mv_par08", "", "", "", "", "", "", "", "","", "", "", "", "", "", "", "","", "", "" )
	Case nRBanco == 2
		PutSx1(	cPerg, "01", "Produto? ",         ".", ".","mv_ch1", "C", 15, 0, 0, "G", "", "SB1", "", "","mv_par01", "", "", "", "", "", "", "", "","", "", "", "", "", "", "", "","", "", "" )
		PutSx1(	cPerg, "02", "Lote	 ? ",         ".", ".","mv_ch2", "C", 12, 0, 0, "G", "", "",      "", "","mv_par02", "", "", "", "", "", "", "", "","", "", "", "", "", "", "", "","", "", "" )
		PutSx1(	cPerg, "03", "Data Fabricação? ", ".", ".","mv_ch3", "D", 08, 0, 0, "G", "", "",      "", "","mv_par03", "", "", "", "", "", "", "", "","", "", "", "", "", "", "", "","", "", "" )
		PutSx1(	cPerg, "04", "Validade? ",        ".", ".","mv_ch4", "D", 08, 0, 0, "G", "", "",      "", "","mv_par04", "", "", "", "", "", "", "", "","", "", "", "", "", "", "", "","", "", "" )
		PutSx1(	cPerg, "05", "Quantidade? ", 	  ".", ".","mv_ch5", "N", 12, 3, 0, "G", "", "", 	  "", "","mv_par05", "", "", "", "", "", "", "", "","", "", "", "", "", "", "", "","", "", "" )
		PutSx1(	cPerg, "06", "Copias? ",          ".", ".","mv_ch6", "N", 03, 0, 0, "G", "", "",      "", "","mv_par09", "", "", "", "", "", "", "", "","", "", "", "", "", "", "", "","", "", "" )
	Case nRBanco == 3
		PutSx1(	cPerg, "01", "Nota Fiscal? ",    ".", ".","mv_ch1", "C", 09, 0, 0, "G", "", "SF2", "", "","mv_par01", "", "", "", "", "", "", "", "","", "", "", "", "", "", "", "","", "", "" )
		PutSx1(	cPerg, "02", "Serie ? ",         ".", ".","mv_ch2", "C", 03, 0, 0, "G", "", "",      "", "","mv_par02", "", "", "", "", "", "", "", "","", "", "", "", "", "", "", "","", "", "" )
		PutSx1(	cPerg, "03", "Copias? ",          ".", ".","mv_ch3", "N", 03, 0, 0, "G", "", "",      "", "","mv_par03", "", "", "", "", "", "", "", "","", "", "", "", "", "", "", "","", "", "" )
End Case						

Return