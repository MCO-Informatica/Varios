/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ FINA040	³ Autor ³ Fabio Reis 	 	    ³ Data ³ 16/10/13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Ponto entrada legendas do Contas a Receber	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function FINALEG
Local nReg     := PARAMIXB[1]
Local cAlias   := PARAMIXB[2]
Local uRetorno := {}
Local aLegenda := {	{"BR_VERDE"    , "Titulo em aberto"       },;	// "Titulo em aberto"				
					{"BR_AZUL"     , "Baixado parcialmente"   },;	// "Baixado parcialmente"
					{"BR_VERMELHO" , "Titulo baixado"         },;	// "Titulo Baixado"					
					{"BR_PRETO"    , "Titulo em bordero"      },;	// "Titulo em Bordero"					
					{"BR_BRANCO"   , "Adiantamento com saldo" },;	// "Adiantamento com saldo"  
					{"BR_CINZA"	   , "Titulo baixado parcialmente e em bordero" }} 	//6. "Titulo baixado parcialmente e em bordero"
If nReg = Nil	
	// Chamada direta da funcao onde nao passa, via menu Recno eh passado	
	// BR_PINK BR_LARANJA BR_MARRON
	uRetorno := {}
		
	If cAlias = "SE1"		

		Aadd(aLegenda, {"BR_AMARELO", "Titulo protestado"}) //"Titulo Protestado"		
		Aadd(uRetorno, { 'ROUND(E1_SALDO,2) == ROUND(E1_VALOR,2) .and. E1_SITUACA == "F"', aLegenda[7][1] } )		

		//-- Adicinando cor cinza para natureza N001 - CUSTOMIZADO		
		Aadd(aLegenda, {"PMSEDT3"   , "Demonstracao"})
		Aadd(aLegenda, {"BR_LARANJA", "Cartao Deb."}) // Alt	 
		Aadd(aLegenda, {"BR_PINK"	, "Cartao Cred."}) // Alt		
		Aadd(uRetorno, { 'ROUND(E1_SALDO,2) == ROUND(E1_VALOR,2) .and. E1_SITUACA == "D" ', aLegenda[len(aLegenda)-2][1] } )				
		Aadd(uRetorno, { 'ROUND(E1_SALDO,2) == ROUND(E1_VALOR,2) .and. E1_SITUACA == "Z" ', aLegenda[len(aLegenda)-1][1] } )				
		Aadd(uRetorno, { 'ROUND(E1_SALDO,2) == ROUND(E1_VALOR,2) .and. E1_SITUACA == "X" ', aLegenda[len(aLegenda)  ][1] } )				

		Aadd(uRetorno, { 'ROUND(E1_SALDO,2) = 0'										 , aLegenda[3][1] } )	
		Aadd(uRetorno, { '!Empty(E1_NUMBOR) .and.(ROUND(E1_SALDO,2) # ROUND(E1_VALOR,2))', aLegenda[6][1] } ) //"Titulo baixado parcialmente
		Aadd(uRetorno, { 'E1_TIPO == "'+MVRECANT+'".and. ROUND(E1_SALDO,2) > 0'			 , aLegenda[5][1] } )		
		Aadd(uRetorno, { '!Empty(E1_NUMBOR)'											 , aLegenda[4][1] } )		
	  	Aadd(uRetorno, { 'ROUND(E1_SALDO,2) # ROUND(E1_VALOR,2)'						 , aLegenda[2][1] } )		
		Aadd(uRetorno, { '.T.'															 , aLegenda[1][1] } )	

	Else		
		IF !Empty(GetMv("MV_APRPAG")) .or. GetMv("MV_CTLIPAG")			
			Aadd(aLegenda, {"BR_AMARELO", "Titulo aguardando liberacao"}) //Titulo aguardando liberacao			
			Aadd(uRetorno, { ' EMPTY(E2_DATALIB) .AND. (SE2->E2_SALDO+SE2->E2_SDACRES-SE2->E2_SDDECRE) > GetMV("MV_VLMINPG") .AND. E2_SALDO > 0', aLegenda[6][1] } )		
		EndIf		

		Aadd(uRetorno, { 'E2_TIPO == "'+MVPAGANT+'" .and. ROUND(E2_SALDO,2) > 0', aLegenda[5][1] } )		
		Aadd(uRetorno, { 'ROUND(E2_SALDO,2) + ROUND(E2_SDACRES,2)  = 0', aLegenda[3][1] } )		
		Aadd(uRetorno, { '!Empty(E2_NUMBOR)', aLegenda[4][1] } )		
		Aadd(uRetorno, { 'ROUND(E2_SALDO,2)+ ROUND(E2_SDACRES,2) # ROUND(E2_VALOR,2)+ ROUND(E2_ACRESC,2)', aLegenda[2][1] } )		
		Aadd(uRetorno, { '.T.', aLegenda[1][1] } )	
	Endif
Else	
	If cAlias = "SE1"		
		Aadd(aLegenda,{"BR_AMARELO", "Titulo protestado"}) //"Titulo Protestado"
		//-- Adicinando Cartao Deb./ Cred.		
   		Aadd(aLegenda, {"PMSEDT2"   , "Demonstracao"})
		Aadd(aLegenda, {"BR_LARANJA", "Cartao Deb."}) // Alt	 
		Aadd(aLegenda, {"BR_PINK",  "Cartao Cred."}) // Alt		
	
	Else		
		IF !Empty(GetMv("MV_APRPAG")) .or. GetMv("MV_CTLIPAG")			
			Aadd(aLegenda, {"BR_AMARELO",  "Titulo aguardando liberacao"}) //Titulo aguardando liberacao		
		EndIf	
	Endif		
	BrwLegenda(cCadastro, "LEGENDA", aLegenda)
   //BrwLegenda(cCadastro, "Cartao Cred.", aLegenda)
Endif

Return uRetorno