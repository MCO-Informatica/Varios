#Include "Protheus.ch"
#Include "rwmake.ch" 
#INCLUDE "TBICONN.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ RFATR03  ³ Autor ³ MARCIO LOPES            ³ Data ³ 15/03/2011 ³±±
±±³          ³          ³       ³                         ³      ³            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Impressao Etiquetas                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³ Etiqueta Codigo de Barras                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³             ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador   ³  Data  ³              Motivo da Alteracao                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³        ³                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RFATR99()

Private cQuery
Private cDesc			:= ""
Private cClas			:= ""
Private cGrup			:= ""
Private cDim1			:= ""
Private cDim2			:= ""
Private cDim3			:= ""
Private cDim4			:= ""
Private cDim5			:= ""
Private cDim6			:= ""
Private cDim7			:= ""
Private aCodBar			:= {}


//cPerg      := "ETIZ01"  // Nome da Pergunte

//If ! Pergunte(cPerg,.T.)
//     Return
//Endif

cQuery := "SELECT * FROM " +RETSQLNAME("SB1")
cQuery += " WHERE B1_COD BETWEEN '000001' AND '000006'"
cQuery += " ORDER BY B1_FILIAL, B1_COD"

dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "TRB", .F., .T.)

DBSELECTAREA("TRB")
DBGOTOP()
//SB1->(DBSEEK(XFILIAL("SB1")+MV_PAR01))

WHILE !EOF()
	   
		cDesc			:= "TESTE DESCRICAO"
		cClas			:= "TESTE CLASSE"
		aCodBar			:= {B1_COD}
        
        IF SUBSTR(ALLTRIM(B1_GRUPO),1,2) = "14"
        	cDim1 := "10,2-178mm x 262mm"
			cDim2 := "10-178mm x 258mm"
			cDim3 := "8,9-168mm x 223mm"
		ENDIF
		

//		MSCBPRINTER("TLP 2844","LPT1",,61,.f.,) //Setei Impressora Eltron pois OS 214 ou ARGOX ou ALLEGRO nao imprime nada.
		MSCBPRINTER("ALLEGRO","LPT1",,,.f.,) //Setei Impressora Eltron pois OS 214 ou ARGOX ou ALLEGRO nao imprime nada.
		MSCBCHKSTATUS(.F.) //status da impressora, se .F. imprime mesmo com problema de impressora, se .T. nao imprime
	    MSCBBEGIN(1,6)
		MSCBSAY(91,02,cDesc,"R","2","1,1")
		MSCBSAY(89,02,"AJUSTAVAL PARA " + cClas,"R","5","1,1")
		MSCBSAY(85,02,cDim1,"R","1","0,001")
		MSCBSAY(83,02,cDim2,"R","1","0,001")
		MSCBSAY(81,02,cDim2,"R","1","0,001")		
		MSCBSAYBAR(87,25,aCodBar[1],'R','MB07',15,.f.,.t.,,,2,2)
		
		MSCBSAY(62,02,cDesc,"R","2","1,1")
		MSCBSAY(60,02,"AJUSTAVAL PARA "+ cClas,"R","2","1,1") 
		MSCBSAY(56,02,cDim1,"R","1","0,001")
		MSCBSAY(54,02,cDim2,"R","1","0,001")
		MSCBSAY(52,02,cDim2,"R","1","0,001")		
		MSCBSAYBAR(58,25,aCodBar[1],'R','MB07',15,.f.,.t.,,,2,2)		

		MSCBSAY(33,02,cDesc,"R","2","1,1")
		MSCBSAY(31,02,"AJUSTAVAL PARA " + cClas,"R","2","1,1")
		MSCBSAY(27,02,cDim1,"R","1","0,001")
		MSCBSAY(25,02,cDim2,"R","1","0,001")
		MSCBSAY(23,02,cDim2,"R","1","0,001")		
		MSCBSAYBAR(29,25,aCodBar[1],'R','MB07',15,.f.,.t.,,,2,2)			
		
		MSCBEND() //Fim da Imagem da Etiqueta
		MSCBCLOSEPRINTER()
		

DBSKIP()

ENDDO
DBCLOSEAREA("TRB") 

Return
