#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณPZROTSA  		บAutor  Guilherme	     บ Data ณ  16/11/2020 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณBot๕es referente a impressใo de Sach๊.			 	      บฑฑ
ฑฑบ          ณ								                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Ap		                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PZROTSA()

Local oDlg
Local oButton1, oSay1
//Local oButton2, oSay2
//Local oButton3, oSay3
//Local oButton4, oSay4
//Local oButton5, oSay5
Public _nOpc	:= 0

oFont     := TFont():New('Arial',,-18,.T.) 
oDlg   	  := TDialog()   :New( 0, 0, 300, 300, "Tipo de impressao" ,,,,, CLR_BLACK,CLR_WHITE ,,, .T. )
oSay1  	  := TSay()      :New( 040, 005, {|| "Tipo de impressao do Rotulo:"} ,oDlg,,oFont,,,,.T.,,, 300, 200 )
//oButton1  := TButton()   :New( 080, 002, "Impressao",oDlg,{|| _nOpc := 1,oDlg:End() }, 40,12,,,.F.,.T.,.F.,,.F.,,,.F. ) 
//oButton2  := TButton()   :New( 080, 050, "Reimpressao",oDlg,{|| _nOpc := 2,oDlg:End() }, 40,12,,,.F.,.T.,.F.,,.F.,,,.F. )  
//oButton3  := TButton()   :New( 080, 100, "Manutencao",oDlg,{|| _nOpc := 3,oDlg:End() }, 40,12,,,.F.,.T.,.F.,,.F.,,,.F. )
//oButton4  := TButton()   :New( 080, 150, "Inclusao",oDlg,{|| _nOpc := 4,oDlg:End() }, 40,12,,,.F.,.T.,.F.,,.F.,,,.F. )
oButton1  := TButton()   :New( 080, 050, "SACHส",oDlg,{|| _nOpc := 5,oDlg:End() }, 40,12,,,.F.,.T.,.F.,,.F.,,,.F. )
//oButton5  := TButton()   :New( 080, 200, "Isopor",oDlg,{|| _nOpc := 5,oDlg:End() }, 40,12,,,.F.,.T.,.F.,,.F.,,,.F. )
//oButton4  := TButton()   :New( 110, 120, "Sair",oDlg, , 40,12,,,.F.,.T.,.F.,,.F.,,,.F. )

oDlg:Activate( , , ,.T.)

Return
