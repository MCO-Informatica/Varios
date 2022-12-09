#Include "PROTHEUS.CH"   
#Include "RWMAKE.CH"
#Include "COLORS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCTSDK05   บAutor  ณGiovanni		      บ Data ณ  10/10/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณConsulta Dados do GAR                                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function cPedGar( )    

Local  aArea   := GetArea() 
Local  oGet1
Local  cImp	   := " " 
Private cPedGar   := SPACE(18) 
Private oDlg 
Private lOpcao := .F. 


 DEFINE FONT oBold NAME "Arial" SIZE 0, -10 BOLD
 DEFINE MSDIALOG oDlg TITLE "DIGITE O NฺMERO DO PEDIDO GAR" FROM 000,000 TO 160,370 COLORS 100,300 PIXEL 
    @ 008,010 SAY "Pedido GAR"  FONT oBold  Size 035,015 OF oDlg COLORS 0,16777215 PIXEL 
 	@ 036,050 MSGET oGet1 VAR cPedGar SIZE 060,010 OF oDlg PIXEL
    @ 058,050 BUTTON OK PROMPT "OK" SIZE 037,012 OF oDlg PIXEL Action (lOpcao:=.T.,Close(oDlg))//Valid EXISTCPO("SZ3",cGet1)
    @ 058,098 BUTTON Cancelar PROMPT "Cancelar" SIZE 037,012 OF oDlg PIXEL Action (lOpcao:=.F.,Close(oDlg)) Cancel Of oDlg
 ACTIVATE MSDIALOG oDlg CENTERED 

If lOpcao == .T. .And. !Empty(cPedGar)    
    
	U_CTSDK05(alltrim(cPedGar),.F.)

Endif
 RestArea(aArea)
Return                                                         

