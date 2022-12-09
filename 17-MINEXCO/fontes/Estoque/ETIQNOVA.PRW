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

USER FUNCTION ETIQNOVA()

Local cCmd, bExecok	:= .F.
Local lRet			:= .T.

cPerg      := "ETIPRO"  // Nome da Pergunte
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
		
		dbSelectArea("SB8")
		dbSetOrder(6)
		If dbSeek(xFilial("SB8")+MV_PAR01+MV_PAR02,.F.)
			
			MSCBPRINTER("OS 214","LPT1",,,.f.,) //Setei Impressora Eltron pois OS 214 ou ARGOX ou ALLEGRO nao imprime nada.
			MSCBCHKSTATUS(.F.) //status da impressora, se .F. imprime mesmo com problema de impressora, se .T. nao imprime
			MSCBINFOETI("Etiqueta Produto","")
			MSCBWRITE("H20"+CHR(13)+CHR(10))  //aumenta a temperatura da impressora

			ProcRegua(SBF->(RecCount()))
			
			While  ! SB8->(eof()) .And. SB8->B8_PRODUTO == MV_PAR01 .And. SB8->B8_LOTECTL <= MV_PAR03 
				
				If SB8->B8_SALDO > 0 
					bExecOk:= .T.
					IncProc("Imprimindo Etiqueta...")
					MSCBBEGIN(1,6) //Inicio da Imagem da Etiqueta
					//MSCBSAY(05,09,"","N","2","1,1")
					MSCBSAY(05,08,ALLTRIM("MINEXCO "+SB1->B1_COD)+" - "+SUBS(SB1->B1_DESC,1,25),"N","2","1,1")
					//MSCBSAYBAR(70,08,ALLTRIM(SB1->B1_CODBAR),'N','MB07',04,.f.,.f.,.f.,,2,2,,,,.T.)
					//MSCBSAY(05,05,"Lote: "+SB8->B8_LOTECTL,"N","2","1,1")
					//MSCBSAY(35,05,"Chapa: "+SB8->B8_LOTEFOR + "  "+Transform(SB8->B8_SALDO,"@E 99.9999")+ " M2","N","2","1,1")
					//MSCBSAYBAR(05,00,ALLTRIM(SB8->B8_LOTECTL),'N','MB07',04,.f.,.f.,.f.,,2,2,,,,.T.)
					//MSCBSAYBAR(45,00,ALLTRIM(SB8->B8_LOTEFOR),'N','MB07',04,.f.,.f.,.f.,,2,2,,,,.T.)
					//MSCBSAY(90,01,"","N","2","1,1")
					MSCBEND()
					
				EndIf

				dbSelectArea("SB8")
				dbSkip()
			End
		EndIf
		
		If !bExecOk
			msgalert("Nenhum registro encontrado com os parametros selecionados, ou nao existe saldo em estoque, ou o parametro quantidade esta informado 0 (zero).")
		Else
			MSCBCLOSEPRINTER()
		EndIf
	EndIf
	
Else
	msgalert("Voce Cancelou a Operação.")
EndIf

Return

