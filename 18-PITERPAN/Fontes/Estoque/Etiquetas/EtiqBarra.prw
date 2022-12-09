User Function ETIQBARRA()
Local cPorta
Private cPerg      := "ETIZ01"
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

/*
If SM0->M0_CODIGO <> '20'
	MsgAlert("SOMENTE AS ETIQUETAS DE CÓDIGO DE BARRAS, DEVERÃO SER UTILIZADAS NO AMBIENTE VAREJO!!!")
	Return
EndIf
*/

If ! Pergunte(cPerg,.T.)
	Return
Endif

If  mv_par04 == 1
	cPorta    := "COM1:9600,n,8,1"
ElseIf mv_par04 == 2
	cPorta    := "COM2:9600,n,8,1"
EndIf

dbSelectArea("SB1")
SB1->(dbSetOrder(5))
If ! SB1->(dbSeek(xFilial("SB1")+ ALLTRIM(mv_par01)))
	MsgAlert("O CÓDIGO "+mv_par01+" NÃO FOI ENCONTRADO NO CADASTRO DE PRODUTOS !!!")
	Return
EndIf

//MSCBPRINTER("ARGOX",cPorta,,,.f.)
MSCBPRINTER("ARGOX","LPT1",,,.f.,,,"EXPEDICAO") 
MSCBCHKSTATUS(.F.) 
MSCBLOADGRF("")
MSCBBEGIN(mv_par03,3)
MSCBBOX(02,01,51,30,1)
MSCBBOX(52,01,101,30,1)
MSCBLineH(02,19,51,1)
MSCBLineH(52,19,101,1)
MSCBLineH(02,15,51,1)
MSCBLineH(52,15,101,1)
MSCBSAY(06,24,"CONTEM:" +ALLTRIM(STR(SB1->B1_QTDEMBA)) + " UND", "N", "2", "1.5,1.5")
MSCBSAY(56,24,"CONTEM:" +ALLTRIM(STR(SB1->B1_QTDEMBA)) + " UND", "N", "2", "1.5,1.5")

MSCBSAY(06,21,SUBSTR(SB1->B1_COMPDES,1,15),"N", "2", "01,01")
MSCBSAY(56,22,SUBSTR(SB1->B1_COMPDES,1,15),"N", "2", "01,01")

MSCBSAY(03,16,SUBSTR(SB1->B1_DESC,1,31),"N", "2", "01,01")
MSCBSAY(53,16,SUBSTR(SB1->B1_DESC,1,31),"N", "2", "01,01")
MSCBSAYBAR(12,03,SUBSTR(SB1->B1_CODBAR,1,13),"N","F",8.36,.F.,.T.,.F.,,3,2)
MSCBSAYBAR(62,03,SUBSTR(SB1->B1_CODBAR,1,13),"N","F",8.36,.F.,.T.,.F.,,3,2)
MSCBEND()
MSCBCLOSEPRINTER()
Return             
