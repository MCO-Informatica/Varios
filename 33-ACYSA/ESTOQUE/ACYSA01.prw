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
//PUBLIC cPESO := 0
//PUBLIC cQTD  := 1

lOpca := .F.                   
                                                                
DEFINE FONT oFont10 NAME "Times New Roman" Size 10,10 BOLD
 
DEFINE MSDIALOG oDlg1 TITLE "PARAMETRO PARA IMPRESSรO" FROM 000, 000  TO 300, 300 COLOR 0, 16777215 PIXEL

oDlg1:lEscClose := .F.   

@ 010,010 GROUP oGroup1 TO 115,140 PROMPT " INFORMAR " OF oDlg1 COLOR 0, 16777215 PIXEL

@ 025,015 SAY "Ordem Produ็ใo" Of oDlg1 PIXEL COLOR CLR_RED
//@ 050,015 SAY "Peso:" Of oDlg1 PIXEL  COLOR CLR_RED
//@ 075,015 SAY "Quantidade" Of oDlg1 PIXEL COLOR CLR_RED

@ 035,015 MSGET oOP   VAR cOP F3 'SC2' SIZE 100,010 OF oDlg1 PIXEL
//@ 060,015 MSGET oPESO VAR cPESO PICTURE "@R 999999" SIZE 075,010 OF oDlg1 PIXEL
//@ 085,015 MSGET oQTD  VAR cQTD  PICTURE "@R 99" SIZE 025,010 OF oDlg1 PIXEL

@ 125,010 BUTTON oButtonE1 PROMPT "Sair"		SIZE 50,20 OF oDlg1 PIXEL ACTION (lOpca := .F.,oDlg1:End())
@ 125,090 BUTTON oButtonE2 PROMPT "Imprimir"	SIZE 50,20 OF oDlg1 PIXEL ACTION (lOpca := .T.,IMPRIMIR())
                                   
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
cPeso := u_XToledo(.f.)
                                
if Empty(cOP)
   Alert("Ordem de Produ็ใo nใo Informado !")
   Return()
endif          

//dbSelectArea("SD3")
//dbSetOrder(1)         
//If !SD3->(dbSeek(xFilial("SD3")+ALLTRIM(cOP)))
//   Alert("Ordem de Produ็ใo nใo existe na tabela (SD3) Movimenta็ใo !")
//   Return()
//endif          

//cQuery:= " SELECT * FROM "+RetSqlName("SD3")+" "                 
//cQuery+= "  WHERE D3_FILIAL = '"+xFilial("SD3")+"' "
//cQuery+= "    AND D3_OP =  '"+cOP+"' "
//cQuery+= "    AND D3_CF = 'PR0' "
//cQuery+= "    AND D_E_L_E_T_ = ' ' "
//DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),'TPC1',.F.,.F.)		
                            
//TPC1->(dbGoTop())
//While TPC1->(!Eof())

DbSelectArea("SC2")
DbSetOrder(1)
If DbSeek(xFilial("SC2")+ALLTRIM(cOP))    

	DbSelectArea("SB1")
	DbSetOrder(1)	
	DbSeek(xFilial("SB1")+SC2->C2_PRODUTO)
               
	aDados := {}
	aAdd(aDados,{"D3_TM"  		, '001'   	 		  	  				, Nil})
	aAdd(aDados,{"D3_OP"  		, cOP			 		  	  				, Nil})         
	aAdd(aDados,{"D3_COD"  		, SC2->C2_PRODUTO    		  	  				, Nil})
	aAdd(aDados,{"D3_UM" 	 	, SB1->B1_UM   	 		  	  				, Nil})
	aAdd(aDados,{"D3_QUANT"  	, cPeso  		  	  				, Nil})
	aAdd(aDados,{"D3_LOCAL"  	, SB1->B1_LOCPAD  		  	  				, Nil})
	
	lMsErroAuto := .F.
		
	MSExecAuto({|x,y| mata250(x,y)},aDados,3)
				
	If lMSErroAuto
		
		MostraErro()   
		lRet := .F.        
		Return(.f.)
	Else
		dbSelectArea("SD3")
		dbSetOrder(1)         
		If !SD3->(dbSeek(xFilial("SD3")+ALLTRIM(cOP)))
		   Alert("Ordem de Produ็ใo nใo existe na tabela (SD3) Movimenta็ใo !")
		   Return(.f.)
		endif          

	EndIf



   MSCBPRINTER("ZEBRA","LPT1",,,.F.,,,,,,)
	
   MSCBCHKSTATUS(.F.) 
	
   MSCBLOADGRF("logo.pcx")	
	     
   MSCBBEGIN(1,6)    
   
   MSCBGRAFIC(14,10,"logo")
                     
   MSCBBOX(10,40,90,85)
   
   MSCBLineH(10,55+2,90) 
   MSCBLineH(10,70+2,90) 
   
   MSCBLineV(35,55+2,70+2) 
   MSCBLineV(75,55+2,70+2) 
   MSCBLineV(50,70+2,85) 

   MSCBBOX(10,116,90,123)
   MSCBLineV(35,116,123) 
   MSCBLineV(75,116,123)     
   
//+---------------------------------------------------------------------------------------------------+
//| Manutencao realizada conforme solicitacao do usuario Rubens em 20/05/2013.                        |
//| Solicitado para replicar a informacao da terceira parte da etiqueta na segunda parte, modificando |
//| apenas de Ordem de producao para Hora de impressao.                                               |
//+---------------------------------------------------------------------------------------------------+
//| Inicio - by Thiago S. Joaquim                                                                     |
//+---------------------------------------------------------------------------------------------------+

   MSCBBOX(10,091,90,098)
   MSCBLineV(35,091,098) 
   MSCBLineV(75,091,098) 

//+---------------------------------------------------------------------------------------------------+
//| Fim                                                                                               |
//+---------------------------------------------------------------------------------------------------+
   
   MSCBSAY(27,35,"WWW.ACYSA.COM.BR", "N","0","035,035")   

   xB1_DESC := Posicione("SB1",1,xFilial("SB1")+SC2->C2_PRODUTO,"B1_DESC") 
   MSCBSAY(11,40+1,"Descricao", "N", "0","018,018")
   FOR A:= 1 TO LEN(xB1_DESC)
      if SUBSTR(xB1_DESC,A,1) $ '0123456789'
   		 xB1_DESC1:= SUBSTR(xB1_DESC,1,A-1)      
   		 xB1_DESC2:= SUBSTR(xB1_DESC,A,LEN(xB1_DESC)) 
   		 EXIT
      endif      
   NEXT A
   
   MSCBSAY(11,37+7,xB1_DESC1, "N","0","050,030")   
   MSCBSAY(11,43+7,xB1_DESC2, "N","0","050,030")   

   MSCBSAY(11,55+3,"Ordem Producao", "N", "0","018,018")
   MSCBSAY(11,55+7+3,cOP, "N","0","050,030")   

   MSCBSAY(36,55+3,"Codigo", "N", "0","018,018")
   MSCBSAY(36,55+7+3,SC2->C2_PRODUTO, "N","0","050,030")   
                      
   MSCBSAY(76,55+3,"Peso", "N", "0","018,018")
   MSCBSAY(76,55+7+3,Transform(cpeso,"@E 999999"), "N","0","050,030")   

   MSCBSAY(11,70+3,"Data", "N", "0","018,018")
   MSCBSAY(11,70+7,DTOC(dDATABASE), "N","0","050,030")   

   MSCBSAY(51,70+3,"Hora", "N", "0","018,018")
   MSCBSAY(51,70+7,LEFT(TIME(),5), "N","0","050,030")   

//+---------------------------------------------------------------------------------------------------+
//| Manutencao realizada conforme solicitacao do usuario Rubens em 20/05/2013.                        |
//| Solicitado para replicar a informacao da terceira parte da etiqueta na segunda parte, modificando |
//| apenas de Ordem de producao para Hora de impressao.                                               |
//+---------------------------------------------------------------------------------------------------+
//| Inicio - by Thiago S. Joaquim                                                                     |
//+---------------------------------------------------------------------------------------------------+

//   MSCBSAY(11,115+2,"Ordem Producao", "N", "0","018,018")
//   MSCBSAY(11,115+5,cOP, "N","0","025,025") 
   MSCBSAY(11,115+2,"Data / Hora", "N", "0","018,018")
   MSCBSAY(11,115+5,DTOC(dDATABASE) + ' / ' + LEFT(TIME(),5), "N","0","025,025")     
   
//+---------------------------------------------------------------------------------------------------+
//| Fim                                                                                               |
//+---------------------------------------------------------------------------------------------------+

   MSCBSAY(36,115+2,"Codigo", "N", "0","018,018")
   MSCBSAY(36,115+5,SC2->C2_PRODUTO, "N","0","025,025")   
                      
   MSCBSAY(76,115+2,"Peso", "N", "0","018,018")
   MSCBSAY(76,115+5,Transform(cPESO,"@E 999999"), "N","0","025,025")   

//+---------------------------------------------------------------------------------------------------+
//| Manutencao realizada conforme solicitacao do usuario Rubens em 20/05/2013.                        |
//| Solicitado para replicar a informacao da terceira parte da etiqueta na segunda parte, modificando |
//| apenas de Ordem de producao para Hora de impressao.                                               |
//+---------------------------------------------------------------------------------------------------+
//| Inicio - by Thiago S. Joaquim                                                                     |
//+---------------------------------------------------------------------------------------------------+

//   MSCBSAYBAR(30,095,ALLTRIM(SD3->D3_LOTECTL),"N","C",13,.F.,.T.,.F.,,2,1,.F.,.F.,"1",.T.)		   

   MSCBSAY(11,090+2,"Data / Hora", "N", "0","018,018")
   MSCBSAY(11,090+5,DTOC(dDATABASE) + ' / ' + LEFT(TIME(),5), "N","0","025,025")     

   MSCBSAY(36,090+2,"Codigo", "N", "0","018,018")
   MSCBSAY(36,090+5,SC2->C2_PRODUTO, "N","0","025,025")   
                      
   MSCBSAY(76,090+2,"Peso", "N", "0","018,018")
   MSCBSAY(76,090+5,Transform(cPESO,"@E 999999"), "N","0","025,025")   
   MSCBSAYBAR(30,099,ALLTRIM(SD3->D3_LOTECTL),"N","C",09,.F.,.T.,.F.,,2,1,.F.,.F.,"1",.T.)		   
   
//+---------------------------------------------------------------------------------------------------+
//| Fim                                                                                               |
//+---------------------------------------------------------------------------------------------------+

   MSCBSAYBAR(30,124,ALLTRIM(SD3->D3_LOTECTL),"N","C",09,.F.,.T.,.F.,,2,1,.F.,.F.,"1",.T.)		   

   MSCBEND()
        
   MSCBCLOSEPRINTER()

EndIf
//	TPC1->(dbSkip())
//EndDo               
//TPC1->(dbCloseArea())                           
	
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


//--------------------------------------------------------------
User Function pesoTLD()                        
Local oButton1
Local oFont1 := TFont():New("MS Sans Serif",,048,,.T.,,,,,.F.,.F.)
Local oGet1
Local cGet1 := u_XToledo(.f.)
Local oSay1
Static oDlg

  DEFINE MSDIALOG oDlg TITLE "New Dialog" FROM 000, 000  TO 300, 700 COLORS 0, 16777215 PIXEL

    @ 030, 009 SAY oSay1 PROMPT "PESO : " SIZE 102, 033 OF oDlg FONT oFont1 COLORS 0, 16777215 PIXEL
    @ 030, 113 MSGET oGet1 VAR cGet1 PICTURE "@E 9,999,999.99" WHEN .F. SIZE 225, 036 OF oDlg COLORS 0, 16777215 FONT oFont1 PIXEL
    @ 107, 248 BUTTON oButton1 PROMPT "&OK" SIZE 068, 033 OF oDlg FONT oFont1 PIXEL ACTION(ODLG:END())

  ACTIVATE MSDIALOG oDlg CENTERED

Return