#include "rwmake.ch"
#Include "Protheus.Ch"
#include "topconn.ch"
#include "tbiconn.ch"
#include "tbicode.ch"

#Define ENTER Chr(13)+Chr(10)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณACYSA01   บ Autor ณFONTANELLI	         บ Data ณ 19/12/2012  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Impressao de Etiqueta de Codigo de Barras          	      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ ACYSA	                           	                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function ACYSA01()

Local a 

Local lOpca :=	.F.

PUBLIC cOP   := Space(13)
PUBLIC cPESO := 0
PUBLIC cQTD  := 1

lOpca := .F.                   
                                                                
DEFINE FONT oFont10 NAME "Times New Roman" Size 10,10 BOLD
 
DEFINE MSDIALOG oDlg1 TITLE "PARAMETRO PARA IMPRESSรO" FROM 000, 000  TO 300, 300 COLOR 0, 16777215 PIXEL

oDlg1:lEscClose := .F.   

@ 010,010 GROUP oGroup1 TO 115,140 PROMPT " INFORMAR " OF oDlg1 COLOR 0, 16777215 PIXEL

@ 025,015 SAY "Ordem Produ็ใo" Of oDlg1 PIXEL COLOR CLR_RED
@ 050,015 SAY "Peso:" Of oDlg1 PIXEL  COLOR CLR_RED
@ 075,015 SAY "Quantidade" Of oDlg1 PIXEL COLOR CLR_RED

@ 035,015 MSGET oOP   VAR cOP F3 'SC2' SIZE 100,010 OF oDlg1 PIXEL
@ 060,015 MSGET oPESO VAR cPESO PICTURE "@R 999,999.99" SIZE 075,010 OF oDlg1 PIXEL
@ 085,015 MSGET oQTD  VAR cQTD  PICTURE "@R 99" SIZE 025,010 OF oDlg1 PIXEL

@ 125,010 BUTTON oButtonE1 PROMPT "Sair"		SIZE 50,20 OF oDlg1 PIXEL ACTION (lOpca := .F.,oDlg1:End())
@ 125,090 BUTTON oButtonE2 PROMPT "Imprimir"	SIZE 50,20 OF oDlg1 PIXEL ACTION (lOpca := .T.,IMPRIMIR(),oDlg1:End())
                                   
ACTIVATE MSDIALOG oDlg1  CENTERED                         

return()   
         

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณIMPRIMIR  บ Autor ณFontanelli          บ Data ณ 18/04/2008  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณFuncao Auxiliar                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Imprimir()
                    

SeqATE := 0

                                
if Empty(cOP)
   Alert("Ordem de Produ็ใo nใo Informado !")
   Return()
endif          

if cPESO = 0
   Alert("Peso nใo Informado !")
   Return()
endif

if cQTD = 0
   Alert("Quantidade nใo Informada !")
   Return()
endif

cQuery:= " SELECT * FROM "+RetSqlName("SD3")+" "                 
cQuery+= "  WHERE D3_FILIAL = '"+xFilial("SD3")+"' "
cQuery+= "    AND D3_OP =  '"+cOP+"' "
cQuery+= "    AND D3_CF = 'PR0' "
cQuery+= "    AND D_E_L_E_T_ = ' ' "
DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),'TPC1',.F.,.F.)		
                        
if !Empty(TPC1->D3_COD)

	SeqATE := cQTD
	
	MSCBPRINTER("ZEBRA","LPT1",,,.F.,,,,,,)
	
	MSCBCHKSTATUS(.f.) 
	
	MSCBLOADGRF("LOGO.PCX")	
	     
	For a:= 1 to SEQATE
	
	   MSCBBEGIN(1,6)    
	   
	   MSCBGRAFIC(22,12,"LOGO")
	                     
	   MSCBBOX(10,40,90,85)
	   MSCBLineH(10,55,90) 
	   MSCBLineH(10,70,90) 
	   MSCBLineV(35,55,70) 
	   MSCBLineV(65,55,70) 
	   MSCBLineV(50,70,85) 

	   MSCBBOX(10,116,90,123)
	   MSCBLineV(35,116,123) 
	   MSCBLineV(65,116,123)     
	   
	   MSCBSAY(35,35,"WWW.ACYSA.COM.BR", "N","0","025,025")   
	   
	   xB1_DESC := Posicione("SB1",1,xFilial("SB1")+TPC1->D3_COD,"B1_DESC") 
	   MSCBSAY(11,40+2,"Descricao", "N", "0","018,018")
	   MSCBSAY(11,40+7,xB1_DESC, "N","0","050,030")   

	   MSCBSAY(11,55+2,"Ordem Producao", "N", "0","018,018")
	   MSCBSAY(11,55+7,cOP, "N","0","050,030")   

	   MSCBSAY(36,55+2,"Lote", "N", "0","018,018")
	   MSCBSAY(36,55+7,'12349876'/*TPC1->D3_LOTE*/, "N","0","050,030")   
	                      
  	   MSCBSAY(66,55+2,"Peso", "N", "0","018,018")
	   MSCBSAY(66,55+7,Transform(cPESO,"@E 999,999.99"), "N","0","050,030")   

	   MSCBSAY(11,70+2,"Data", "N", "0","018,018")
	   MSCBSAY(11,70+7,DTOC(dDATABASE), "N","0","050,030")   

	   MSCBSAY(51,70+2,"Hora", "N", "0","018,018")
	   MSCBSAY(51,70+7,LEFT(TIME(),5), "N","0","050,030")   


	   MSCBSAY(11,115+2,"Ordem Producao", "N", "0","018,018")
	   MSCBSAY(11,115+5,cOP, "N","0","025,025")   

	   MSCBSAY(36,115+2,"Lote", "N", "0","018,018")
	   MSCBSAY(36,115+5,'12349876'/*TPC1->D3_LOTE*/, "N","0","025,025")   
	                      
  	   MSCBSAY(66,115+2,"Peso", "N", "0","018,018")
	   MSCBSAY(66,115+5,Transform(cPESO,"@E 999,999.99"), "N","0","025,025")   

	   MSCBSAYBAR(10,095,ALLTRIM(TPC1->D3_COD),"N","C",13,.F.,.T.,.F.,,2,1,.F.,.F.,"1",.T.)		   
	
	   MSCBSAYBAR(10,124,ALLTRIM(TPC1->D3_COD),"N","C",09,.F.,.T.,.F.,,2,1,.F.,.F.,"1",.T.)		   
	
	   MSCBEND()
	        
	Next
	
	MSCBCLOSEPRINTER()

endif
	
TPC1->(dbCloseArea())
		
Return()	

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณValidP1   ณ Autor ณ Fontanelli            ณ Data ณ 21.02.11  ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Parametros da rotina.                			      	   ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ValidP1(cPerg)

dbSelectArea("SX1")
dbSetOrder(1)

aRegs:={}              
aAdd(aRegs,{cPerg,"01","Ordem de Producao ?" 	,"","","mv_ch1","C",13,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SC2","","","","","","","",""})	
aAdd(aRegs,{cPerg,"02","Peso ?"				  	,"","","mv_ch2","N",12,2,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})	
aAdd(aRegs,{cPerg,"03","Quantidade ?"	 		,"","","mv_ch3","N",03,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})	

For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			FieldPut(j,aRegs[i,j])
		Next
		MsUnlock()
		dbCommit()
	Endif
Next
                          
Return(.T.)

