/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณEXPORTAR  บAutor  ณMicrosiga           บ Data ณ  11/27/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina de Exporta็ใo dos dados do microsiga para Fenix     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

#Include "Protheus.ch"
#Include "RWMake.ch"
#Define CRLF  CHR(13)+CHR(10)

User Function Exportar()     
Private nOpc      := 0
Private cCadastro := "Exporta็ใo de dados."
Private aSay      := {}
Private aButton   := {}    
Private cPerg		  := PADR("EXPORTAR",10)

aAdd( aSay, "Esta rotina irแ exportar dados Microsiga para sistema Fenix" )       
//MsgInfo(xFilial("DA0"))

ValidPerg()  
Pergunte(cPerg,.F.)

aButton  := { { 5,.T.,{|| 	Pergunte(cPerg,.T.) }    } ,;
 						  { 1,.T.,{|| nOpc := 1,FechaBatch()}    } ,;
						  { 2,.T.,{|| FechaBatch() }             }  ;
            }
FormBatch( cCadastro, aSay, aButton )
If nOpc == 1      
	if MV_PAR01=1
	Elseif MV_PAR01 == 2
		if Empty( MV_PAR05 )
			MsgInfo("Necessario preencher a tabela de Pre็o ","Aten็ใo")
			Return(Nil)
		Endif
	Endif

	if Empty(MV_PAR03)
		MsgInfo("Necessario preencher o nome do arquivo","Aten็ใo")
		Return(Nil)
	Endif
	
	if Empty(MV_PAR04)
		MsgInfo("Necessario preencher o caminho do arquivo","Aten็ใo")
		Return(Nil)
	Endif

	if MsgYesNo("Deseja prosseguir com esta opera็ใo?","aten็ใo")
		Processa( {|| Export() }, "Processando..." )          
		
		if MV_PAR01=1
			if !Empty( MV_PAR06 )
				Processa( {|| ReservSA1()  } , "Processando..." )
			Endif	
		Endif	
	
	Endif	
Endif
        
Return(Nil)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณEXPORTAR  บAutor  ณMicrosiga           บ Data ณ  12/01/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Efetua a exporta็ใo de dados contido no array aTamnho      บฑฑ
ฑฑบ          ณ atamanho (nome Campo,tamanho)
ฑฑบ          ณ 
ฑฑบ          ณ 
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                                      
Static Function Export() 
Local cQuery,bCampos  
Local aTamanho
Local cArquivo,cLinha
Local hArq
Local i                  
Local nFor

	cArquivo := RTrim( MV_PAR04 ) + iif(Right(RTrim(MV_PAR04),1)="\","","\") + RTrim( MV_PAR03 ) + iif( RAT(".",MV_PAR03)=0,".TXT","")  
	cArquivo := RTrim( Upper(cArquivo) )  
	
	if (hArq := FCreate( cArquivo ) ) = -1 
		MsgStop("Nใo foi possivel gerar o arquivo [" + cArquivo + "]","Aten็ใo")
		Return(Nil)
	Endif

	if MV_PAR01 == 1 // Tabela de cliente      
	 
	  aTamanho := {	 {"A1_COD+A1_LOJA" 							,020,"C",0} ,;  // 01 - 001  020 cli_Codigo					Texto	020  
								   {"A1_NOME"											,050,"C",0} ,;  // 02 -	021  070 cli_Nome						Texto	050
								   {"A1_END" 		 									,075,"C",0} ,;  // 03 - 071  145 cli_Endereco1			Texto	075
								   {"'' as END2" 									,075,"C",0} ,;  // 04 - 146  220 cli_Endereco2			Texto	075
								   {"A1_MUN"											,040,"C",0} ,;  // 05 -	221  260 cli_Cidade					Texto	040
								   {"A1_EST"											,002,"C",0} ,;  // 06 -	261  262 cli_Estado					Texto	002	
								   {"A1_CEP"											,010,"C",0} ,;  // 07 - 263  272 cli_CEP						Texto	010
								   {"A1_DDD+' '+A1_TEL AS 'FONE'"	,020,"C",0} ,;  // 08 - 273  292 cli_Fone						Texto	020
								   {"A1_DDD+' '+A1_FAX AS 'FAX'" 	,020,"C",0} ,;  // 09 - 293  312 cli_Fax						Texto	020
								   {"A1_EMAIL" 										,100,"C",0} ,;  // 10 - 313  412 cli_Email					Texto	100
								   {"A1_CGC" 											,020,"C",0} ,;  // 11 - 413  432 cli_RegFederal			Texto	020
								   {"A1_INSCR" 										,020,"C",0} ,;  // 12 - 433  452 cli_RegEstadual		Texto	020
								   {"A1_CONTATO" 									,050,"C",0} ,;  // 13 - 453  502 cli_Contato				Texto	050
								   {"A1_VEND" 										,015,"C",0} ,;  // 14 - 503  517 cli_Representante	Texto	015
								   {"A1_TRANSP" 									,015,"C",0} ,;  // 15 - 518  532 cli_Transportadora	Texto	015
									 {"'T' AS A1_NC"								,001,"C",0} ,;  // 16 - 533	 533 cli_Novo						Logico	1	
								   {"A1_OBSERV"   								,255,"C",0} ,;  // 17 - 534	 788 cli_Obs						Memorando	255
								   {"A1_ENDENT"   								,075,"C",0} ,;  // 18 - 789	 863 cli_EntEndereco1		Texto	75
								   {"'' as ENTEND"								,075,"C",0} ,;  // 19 - 864	 938 cli_EntEndereco2		Texto	75
								   {"A1_MUNE" 										,040,"C",0} ,;  // 20 - 939	 978 cli_EntCidade			Texto	40	
								   {"A1_ESTE" 										,002,"C",0} ,;  // 21 - 979	 980 cli_EntEstado			Texto	2		
								   {"A1_CEPE" 	  								,010,"C",0} ,;  // 22 - 981	 990 cli_EntCEP					Texto	10     
								   {"'' AS REST"  								,001,"C",0} ,;  // 23 - 991	 991 cli_EntCEP					Texto	10     
								   {"'' AS TBP"   								,010,"C",0}  }  // 24 - 992	1001 cli_EntCEP					Texto	10     
								   	      
		bCampos := ""
		aEval(aTamanho,{|x| bCampos += x[1] + ","  })
		bCampos := Left(bCampos,Len(bCampos)-1)    

		cQuery := "SELECT " + bCampos + " FROM " + RETSQLNAME("SA1") + " SA1 " + CRLF
		cQuery += "WHERE SA1.D_E_L_E_T_ = ' ' "
		cQuery += "	AND A1_MSBLQL <> '1'"		
		if !Empty( mv_par02 )
			cQuery += " AND A1_XSATIV1 = '" + RTrim( MV_PAR02 ) + "'" 
		Endif
		
		
		

	Elseif  MV_PAR01 == 2 // Tabela de Produtos   
		aTamanho := {	 {"SB1.B1_COD"      		,020,"C",0},; // 01 - 001-020 pro_Codigo			Texto	020 
									 {"SB1.B1_CODBAR"   					,020,"C",0},; // 02 - 021-040 pro_CodBarras		Texto	020 
									 {"SB1.B1_DESC"				     		,050,"C",0},; // 03 - 041-090 pro_Descricao		Texto	050 
									 {"'' AS NomRed"							,020,"C",0},; // 04 - 091-110 pro_Reduzida		Texto	020 
									 {"B1_UM"											,002,"C",0},; // 05 - 111-112 pro_Unidade			Texto	002 
									 {"'' AS Emb"									,010,"C",0},; // 06 - 113-122 pro_Embalagem		Texto	010 
									 {"DA1_PRCVEN"								,020,"M",2},; // 07 - 123-142 pro_Preco				Texto	020 
					 			   {"'1' as Est"								,010,"C",0},;// 08 - 143-152 pro_Quantidae	Texto	010 
									 {"' ' as mult" 							,001,"C",0},; // 09 - 153-153 pro_Multiplo		Texto	001 
									 {"B1_IPI"   				   				,010,"C",0},; // 10 - 154-163 pro_IPI					Texto	010 
	                 {"SUM(SB2.B2_QATU-B2_RESERVA-B2_QPEDVEN) AS 'QTDE'" ,010,"N",0},; // 11 - 164-173 pro_Estoque			Texto	010 
									 {"'' as Dif"									,001,"C",0},; // 12 - 174-174 pro_Estoque			Texto	010 
									 {"'0,00' as PR2"							,020,"C",0},; // 13 - 175-194 pro_Estoque			Texto	010 
									 {"'0,00' as Des"							,010,"C",0},; // 14 - 195-204 pro_Estoque			Texto	010 
									 {"'' as RAT"									,001,"C",0},; // 15 - 205-205 pro_Estoque			Texto	010 
									 {"MAX(DA1_DATVIG) AS 'NGERA'",001,"C",0} } // 16 - CAMPO CONTROLE 

  	bCampos := ""
		aEval(aTamanho,{|x| bCampos += x[1] + ","  })
		bCampos := Left(bCampos,Len(bCampos)-1)  
		
		cQuery  := "SELECT " + bCampos + " FROM " + RETSQLNAME("SB1") + " SB1 " 																				+ CRLF    
		cQuery  += "LEFT JOIN " +  RETSQLNAME("SB2") + " SB2 ON SB1.B1_COD = SB2.B2_COD AND SB2.D_E_L_E_T_ = ' ' " 	  	+ CRLF
		//cQuery  += "LEFT JOIN " +  RETSQLNAME("DA1") + " DA1 ON SB1.B1_COD = DA1.DA1_CODPRO AND (DA1_DATVIG = '' OR DA1_DATVIG >= '" +DTOS(dDATABASE) + "') AND DA1.D_E_L_E_T_ = ' ' "  + CRLF
		cQuery  += "LEFT JOIN " +  RETSQLNAME("DA1") + " DA1 ON SB1.B1_COD = DA1.DA1_CODPRO AND DA1.D_E_L_E_T_ = ' ' "  + CRLF
		cQuery  += "WHERE DA1_CODTAB = '" + Alltrim(MV_PAR05) + "' " + CRLF
		cQuery  += "AND SB1.D_E_L_E_T_ = ' ' " + CRLF
		cQuery  += "GROUP BY SB1.B1_COD,SB1.B1_FILIAL,B1_CODBAR,B1_DESC,B1_UM,DA1_PRCVEN,B1_IPI,SB2.B2_COD " + CRLF
		cQuery  += "ORDER BY SB1.B1_COD,B1_FILIAL "
		
	Elseif  MV_PAR01 == 3 // Tabela de Vendedores SA3
		aTamanho := {  {"A3_COD"    ,015,"C",0},; // 01 - 001-015 rep_Codigo	Texto	015 
									 {"A3_NOME"   ,050,"C",0},; // 02 - 016-065 rep_Nome		Texto	050 
									 {"A3_TEL"    ,020,"C",0},; // 03 - 066-085 rep_Fone1		Texto	020 
									 {"A3_FAX"		,020,"C",0},; // 04 - 086-105 rep_Fone2		Texto	020 
									 {"A3_EMAIL"	,100,"C",0},; // 05 - 106-205 rep_Email		Texto	100 
									 {"'' as Obs"	,255,"C",0} } // 06 - 206-460 rep_Obs			Texto	255 
	
		bCampos := ""
		aEval(aTamanho,{|x| bCampos += x[1] + ","  })
		bCampos := Left(bCampos,Len(bCampos)-1)
		
		cQuery  := "SELECT " + bCampos + " FROM " + RETSQLNAME("SA3") + " SA3 " + CRLF 
		cQuery  += "WHERE SA3.D_E_L_E_T_ = ' ' "       
		cQuery  += "AND SA3.A3_FILIAL = '" + xFilial("SA3") + "'"
		   

	
	Elseif  MV_PAR01 == 4 // Tabela de Transportadora  SA4
		aTamanho := {  {"A4_COD"    ,015,"C",0},; // 01 - 001-015 tra_Codigo				Texto	015 
									 {"A4_NOME"	  ,050,"C",0},; // 02 - 016-065 tra_Nome					Texto	050 
									 {"A4_NREDUZ"	,050,"C",0} } // 03 - 066-115 tra_Denominacao		Texto	050 
									 
	
		bCampos := ""
		aEval(aTamanho,{|x| bCampos += x[1] + ","  })
		bCampos := Left(bCampos,Len(bCampos)-1)
		
		cQuery  := "SELECT " + bCampos + " FROM " + RETSQLNAME("SA4") + " SA4 " + CRLF 
		cQuery  += "WHERE SA4.D_E_L_E_T_ = ' ' " 
		cQuery  += "AND SA4.A4_FILIAL = '" + xFilial("SA4") + "'"

	Elseif  MV_PAR01 == 5 // Condi็๕es de Pagamento
		aTamanho := {  {"E4_CODIGO"    		,010,"C" ,0},; // 01 - 001-015 tra_Codigo				Texto	015 
									 {"E4_DESCRI"	  		,060,"C" ,0},; // 02 - 016-065 tra_Nome					Texto	050  // Alterado o tamanho do campo para 60 para refletir a alteracao do campo no sistema. Kaique
									 {"'0,00' as valmin",020,"C" ,2},; // 02 - 016-065 tra_Nome					Texto	050 
									 {"E4_DESCFIN"	  	,010,"M" ,2},; // 02 - 016-065 tra_Nome					Texto	050 
									 {"E4_ACRSFIN"	  	,010,"M" ,2},; // 02 - 016-065 tra_Nome					Texto	050 
									 {"E4_COND"					,010,"$A",0},; // 02 - 016-065 tra_Nome					Texto	050 
									 {"E4_COND AS DIA"  ,010,"A" ,6} } // 03 - 066-115 tra_Denominacao	Texto	050 
									 
	
		bCampos := ""
		aEval(aTamanho,{|x| bCampos += x[1] + ","  })
		bCampos := Left(bCampos,Len(bCampos)-1)  
		
		
		cQuery  := "SELECT " + bCampos + " FROM " + RETSQLNAME("SE4") + " SE4 " + CRLF 
		cQuery  += "WHERE SE4.D_E_L_E_T_ = ' ' "        
		cQuery  += "AND SE4.E4_FILIAL = '" + xFilial("SE4") + "'"

	
	Else 
		MsgStop("Error")
		Return( Nil )
	Endif
        
	 DbUseArea(.T.,"TOPCONN", TCGenQry(,,ChangeQuery(cQuery)), 'TbTmp', .F. , .T.)
		count to nRegua
		ProcRegua( nRegua ) //QTOS REGISTROS LER     
		TbTmp->(Dbgotop())   
		While TbTmp->(!EOF())
			IncProc()
			cLinha := ""
			For nFor := 1 to TbTmp->(Fcount())     
				if TbTmp->(FieldName(nFor)) == "NGERA"
					Loop
				Endif
			
				cNome    := aTamanho[nFor,1]
				
				bCampos  := TbTmp->(FieldGet(nFor))

			  if aTamanho[nFor,3] = "N"     
			  	nTam    := aTamanho[nFor,2]   
			  	nDec    := aTamanho[nFor,4]
			  	bCampos := Left(STR(bCampos,nTam,nDec),nTam)
			  Elseif aTamanho[nFor,3] = "$A"
			  	
			  	bCampos := "{" + RTrim(bCampos) + "}"
			  	bCampos := &(bCampos)     
			  	bCampos := STR(Len(bCampos),10)
			  Elseif aTamanho[nFor,3] = "A"
			  
			  	bVar := "{" + RTrim(bCampos) + "}"
			  	bVar := &(bVar)         			
			  	bCampos := ""
			  	for i:=1 to Len(bVar)
			  		cLinha += Padr(STR(bVar[i],aTamanho[nFor,2]),aTamanho[nFor,2])
			  	Next i  
			  Elseif aTamanho[nFor,3] = "M"     
			  	nTam    := aTamanho[nFor,2]   
			  	bCampos := Left(Transf(bCampos,"@E 999,999.99"),nTam)
			  Elseif aTamanho[nFor,3] = "C"     
			  	nTam    := aTamanho[nFor,2]   
			  	bCampos := Padr(bCampos,nTam)
			  Endif
				cLinha += Padl(bCampos,aTamanho[nFor,2])
			Next nFor         

			cLinha += CRLF
			FWrite(hArq,cLinha)		   
			TbTmp->(DbSkip())
		End
		FClose(hArq)
		TbTmp->(DbCloseArea())
		
Return(Nil)

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                                      
Static Function ValidPerg()
Local aAreaX1 := GetArea()

	PutSx1( cPerg ,"01","Selecione o Arquivo"  ,"","","MV_CH1","C",01,00,01,"C","U_NOMARQ",""       ,"","","mv_par01","Clientes"		 ,"Clientes"		,"Clientes"		 ,"","Produtos","Produtos","Produtos","Vendedores","Vendedores","Vendedores","Transportadoras","Transportadoras","Transportadoras","Cond. Pagto","Cond. Pagto","Cond. Pagto",{"Selecione o arquivo a ser exportado"},{},{})
	PutSx1( cPerg ,"02","Segmento"           	 ,"","","MV_CH2" ,"C",40,00,01,"G","U_VALIDA","T3"    ,"","","mv_par02","","","","","","","","","","","","","","","","",{"Informe o segmento do cliente "},{},{})    
	PutSx1( cPerg ,"03","Arquivo"           	 ,"","","MV_CH3" ,"C",40,00,01,"G",""				 ,""      ,"","","mv_par03","","","","","","","","","","","","","","","","",{"Informe o nome do arquivo "},{},{})    
	PutSx1( cPerg ,"04","Caminho"           	 ,"","","MV_CH4" ,"C",40,00,01,"G",""				 ,""      ,"","","mv_par04","","","","","","","","","","","","","","","","",{"Informe o caminho do arquivo a ser gerado "},{},{})    
  PutSx1( cPerg ,"05","Pre็o"           	   ,"","","MV_CH5" ,"C",40,00,01,"G",""        ,"TPreco","" ,"","mv_par05","","","","","","","","","","","","","","","","",{"Informe a tabela de Preco de Produto a ser utilizada, Obrigatorio"},{},{})    

  //PutSx1( cPerg ,"06","Renge Cliente"    	   ,"","","MV_CH6" ,"C",40,00,01,"G","","","" ,"","MV_PAR06","","","","","","","","","","","","","","","","",{"Caso seja informado, reserva a quanidade de codigo cliente"},{},{})    

	RestArea(aAreaX1)
Return

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                                      
User Function Valida( nOpc )
Local lRet := .T.
	if !Empty( mv_par02 ) 
		if mv_par01 != 1
			Msginfo("Aten็ใo op็ใo somente valida para Clientes","Atencao")
			lRet := .F.
		Else 
			DbSelectArea("SX5")
			if SX5->(DbSeek( xFilial("SX5") + "T3" + mv_par02 ))
				mv_par02 :=  SX5->X5_DESCRI
		  Endif
		Endif
	Endif
                                             
Return( lRet )
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                                      
User Function NomArq( nOpc )
Local aArq := {"CLIENTES","PRODUTOS","REPRESENTANTES","TRANSPORTADORAS","CONDICOES"}
	mv_par03 := aArq[ mv_par01 ]
Return( .T. )

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                                      
Static Function ReservSA1()
Local cCodAtu,nAte


	cCodAtu	:= GetSxeNum("SA1","A1_COD")
	nAte    := Val(cCodAtu)  + val( MV_PAR06 )

	ProcRegua( Val( MV_PAR06 ) )
	While val(cCodAtu) <= nAte
			IncProc()                                
			cCodAtu	:= GetSxeNum("SA1","A1_COD")
			ConfirmSx8()
	End      
//		cCodAtu	:= GetSxeNum("SA1","A1_COD")

Return