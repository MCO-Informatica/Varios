/*
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ±±
±±³Rdmake	 ³ EtiqProd ³Autor  ³ Magh Moura            ³ Data ³ 16.05.06  ±±
±±º			 ³          ³Modif  ³ Magh Moura            ³ Data ³ 25/09/06  ±±
±±º			 ³          ³Modif  ³ SUPORTE               ³ Data ³ 21/02/07  ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ±±
±±³Descri‡…o ³ Rotina de impressao de etiquetas codigo de Barras	       ±±
±±³          ³ do cadastro de produtos x Lote.                 			   ±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ±±
±±ºUso       ³ Minexco Com. Imp. Exp. Ltda.                                ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ±±
±±ºConf.Impr.³ ELTRON LP2142. (Configurar esse drive de impressao sempre)  ±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

USER FUNCTION ETIQAMO()

Local cCmd, bExecok	:= .F.
Local lRet			:= .T.

cPerg      := "ETIAMO"  // Nome da Pergunte
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If !Pergunte(cPerg,.T.)               
	lRet	:=	.f.
EndIF

If lRet
	dbSelectArea("SB1")
	dbSetOrder(1)
	If dbSeek(xFilial("SB1")+MV_PAR01,.f.)
		
			MSCBPRINTER("OS 214","LPT1",,,.f.,,,"EXPEDICAO") //Setei Impressora Eltron pois OS 214 ou ARGOX ou ALLEGRO nao imprime nada.
			//MSCBPRINTER("ELTRON","LPT1",,08.5,.f.,) //Setei Impressora Eltron pois OS 214 ou ARGOX ou ALLEGRO nao imprime nada.
			MSCBCHKSTATUS(.F.) //status da impressora, se .F. imprime mesmo com problema de impressora, se .T. nao imprime
			MSCBINFOETI("Etiqueta Produto","")
			MSCBWRITE("H20"+CHR(17)+CHR(14))  //aumenta a temperatura da impressora

			ProcRegua(SB1->(RecCount()))
			
			For _nX := 1 to MV_PAR02
				
					bExecOk:= .T.
					IncProc("Imprimindo Etiqueta...")
					MSCBBEGIN(1,6,19.5) //Inicio da Imagem da Etiqueta
					//MSCBBEGIN(1,6) //Inicio da Imagem da Etiqueta
					//MSCBSAY(75,00,"MINEXCO","N","2","1,2")
					MSCBSAY(05,01,ALLTRIM("MINEXCO "+SB1->B1_COD)+" - "+SUBS(SB1->B1_DESC,1,25),"N","2","1,1")
					MSCBSAYBAR(70,00,ALLTRIM(SB1->B1_COD),'N','MB07',04,.f.,.f.,.f.,,2,2,,,,.T.)
					//MSCBSAY(45,03,"MINEXCO","N","2","1,2")
					//MSCBSAY(05,04,"Lote: "+SB8->B8_LOTECTL,"N","2","1,1")
					//MSCBSAY(35,04,"Chapa: "+SB8->B8_LOTEFOR + "  "+Transform(SB8->B8_SALDO,"@E 99.9999")+ " M2","N","2","1,1")
					//MSCBSAYBAR(05,08,ALLTRIM(SB8->B8_LOTECTL),'N','MB07',04,.f.,.f.,.f.,,2,2,,,,.T.)
					//MSCBSAYBAR(35,09,ALLTRIM(SB8->B8_LOTEFOR),'N','MB07',04,.f.,.f.,.f.,,2,2,,,,.T.)
					//MSCBSAY(90,09,"","N","2","1,1")
					MSCBSAY(90,19.5,"","N","2","1,1")
					MSCBEND()
					//sConteudo:=MSCBEND()
			NEXT
		
		If !bExecOk
			msgalert("Nenhum registro encontrado com os parametros selecionados, ou nao existe saldo em estoque, ou o parametro quantidade esta informado 0 (zero).")
		Else
			MSCBCLOSEPRINTER()
			//sConteudo:=MSCBCLOSEPRINTER()
		EndIf
	EndIf
	
Else
	msgalert("Voce Cancelou a Operação.")
EndIf

Return
//Return sConteudo

