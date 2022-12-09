
#INCLUDE "MATR730.CH"
#INCLUDE "PROTHEUS.CH"

#DEFINE CHRCOMP If(aReturn[4]==1,15,18)

/*/
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ MATR730  ³ Autor ³ Eduardo José Zanardo  ³ Data ³ 26.12.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Emissao da Pr‚-Nota                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
/*/

User Function Matr731a()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Define Variaveis                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local Titulo  := OemToAnsi(STR0001) //"Emissao da Confirmacao do Pedido"
Local cDesc1  := OemToAnsi(STR0002) //"Emiss„o da confirmac„o dos pedidos de venda, de acordo com"
Local cDesc2  := OemToAnsi(STR0003) //"intervalo informado na op‡„o Parƒmetros."
Local cDesc3  := " "
Local cString := "SC5"  // Alias utilizado na Filtragem
Local lDic    := .F. // Habilita/Desabilita Dicionario
Local lComp   := .F. // Habilita/Desabilita o Formato Comprimido/Expandido
Local lFiltro := .F. // Habilita/Desabilita o Filtro
Local wnrel   := "MATR73A" // Nome do Arquivo utilizado no Spool
Local nomeprog:= "MATR73A"
Local cPerg   := "MTR730    "

Private Tamanho := "G" // P/M/G
Private Limite  := 132 // 80/132/220   220
Private aOrdem  := {}  // Ordem do Relatorio
Private aReturn := { STR0004, 2, STR0005, 1, 2, 1, "",0 } //"Zebrado"###"Administracao"
						//[1] Reservado para Formulario
						//[2] Reservado para N§ de Vias
						//[3] Destinatario
						//[4] Formato => 1-Comprimido 2-Normal
						//[5] Midia   => 1-Disco 2-Impressora
						//[6] Porta ou Arquivo 1-LPT1... 4-COM1...
						//[7] Expressao do Filtro
						//[8] Ordem a ser selecionada
						//[9]..[10]..[n] Campos a Processar (se houver)

Private lEnd    := .F.// Controle de cancelamento do relatorio
Private m_pag   := 1  // Contador de Paginas
Private nLastKey:= 0  // Controla o cancelamento da SetPrint e SetDefault

mv_par01 := SC5->C5_NUM
mv_par02 := SC5->C5_NUM

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica as Perguntas Seleciondas                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Pergunte(cPerg,.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Envia para a SetPrinter                                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*
#IFDEF TOP
	lFiltro := .F.
#ENDIF	
*/
wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,lDic,aOrdem,,Tamanho,lFiltro)
If ( nLastKey==27 )
	dbSelectArea(cString)
	dbSetOrder(1)
	dbClearFilter()
	Return
Endif
SetDefault(aReturn,cString)
If ( nLastKey==27 )
	dbSelectArea(cString)
	dbSetOrder(1)
	dbClearFilter()
	Return
Endif

RptStatus({|lEnd| C730Imp(@lEnd,wnRel,cString,nomeprog,Titulo)},Titulo)


Return(.T.)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³ C730Imp   ³ Autor ³ Eduardo J. Zanardo   ³ Data ³26.12.2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Controle de Fluxo do Relatorio.                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function C730Imp(lEnd,wnrel,cString,nomeprog,Titulo)

Local aPedCli    := {}    
Local aStruSC5   := {}
Local aStruSC6   := {}
Local aC5Rodape  := {}                          
Local aRelImp    := MaFisRelImp("MT100",{"SF2","SD2"})

Local li         := 100 // Contador de Linhas
Local lImp       := .F. // Indica se algo foi impresso
Local lRodape    := .F.

Local cbCont     := 0   // Numero de Registros Processados
Local cbText     := ""  // Mensagem do Rodape
Local cKey 	     := ""
Local cFilter    := ""
Local cAliasSC5  := "SC5"
Local cAliasSC6  := "SC6"
Local cIndex     := CriaTrab(nil,.f.) 
Local cQuery     := ""
Local cQryAd     := ""     
Local cName      := ""
Local cPedido    := ""
Local cCliEnt	 := ""
Local cNfOri     := Nil
Local cSeriOri   := Nil
Local nItem      := 0 
Local nTotQtd    := 0
Local nTotVal    := 0
Local nDesconto  := 0
Local nPesLiq    := 0
Local nSC5       := 0
Local nSC6       := 0 
Local nX         := 0
Local nRecnoSD1  := Nil
/*
#IFDEF TOP
	If TcSrvType() <> "AS/400"
	    cAliasSC5:= "C730Imp"
	    cAliasSC6:= "C730Imp"
		lQuery    := .T.
		aStruSC5  := SC5->(dbStruct())		
		aStruSC6  := SC6->(dbStruct())		
		cQuery := "SELECT SC5.R_E_C_N_O_ SC5REC,SC6.R_E_C_N_O_ SC6REC,"
		cQuery += "SC5.C5_FILIAL,SC5.C5_NUM,SC5.C5_CLIENTE,SC5.C5_LOJACLI,SC5.C5_TIPO,"
		cQuery += "SC5.C5_TIPOCLI,SC5.C5_TRANSP,SC5.C5_PBRUTO,SC5.C5_PESOL,SC5.C5_DESC1,"
		cQuery += "SC5.C5_DESC2,SC5.C5_DESC3,SC5.C5_DESC4,SC5.C5_MENNOTA,SC5.C5_EMISSAO,"
		cQuery += "SC5.C5_CONDPAG,SC5.C5_FRETE,SC5.C5_DESPESA,SC5.C5_FRETAUT,SC5.C5_TPFRETE,SC5.C5_SEGURO,SC5.C5_TABELA,"
		cQuery += "SC5.C5_VOLUME1,SC5.C5_ESPECI1,SC5.C5_MOEDA,SC5.C5_REAJUST,SC5.C5_BANCO,"
		cQuery += "SC5.C5_ACRSFIN,SC5.C5_VEND1,SC5.C5_VEND2,SC5.C5_VEND3,SC5.C5_VEND4,SC5.C5_VEND5,"
		cQuery += "SC5.C5_COMIS1,SC5.C5_COMIS2,SC5.C5_COMIS3,SC5.C5_COMIS4,SC5.C5_COMIS5,"
		If SC5->(FieldPos("C5_CLIENT"))>0
			cQuery += "SC5.C5_CLIENT,"			
		Endif

        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³Esta rotina foi escrita para adicionar no select os campos         ³
        //³usados no filtro do usuario quando houver, a rotina acrecenta      ³
        //³somente os campos que forem adicionados ao filtro testando         ³
        //³se os mesmo já existem no select ou se forem definidos novamente   ³
        //³pelo o usuario no filtro                                           ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	   	

        If !Empty(aReturn[7])
		   For nX := 1 To SC5->(FCount())
		 	  cName := SC5->(FieldName(nX))
		 	  If AllTrim( cName ) $ aReturn[7]
	      		  If aStruSC5[nX,2] <> "M"  
	      		    If !cName $ cQuery .And. !cName $ cQryAd
		        	  cQryAd += cName +","
		            Endif 	
		       	  EndIf
			  EndIf 			       	
		   Next nX
        Endif    
     
        cQuery += cQryAd		

		cQuery += "SC6.C6_FILIAL,SC6.C6_NUM,SC6.C6_PEDCLI,SC6.C6_PRODUTO,"
		cQuery += "SC6.C6_TES,SC6.C6_QTDVEN,SC6.C6_PRUNIT,SC6.C6_VALDESC,"
		cQuery += "SC6.C6_VALOR,SC6.C6_ITEM,SC6.C6_DESCRI,SC6.C6_UM, "
		cQuery += "SC6.C6_PRCVEN,SC6.C6_NOTA,SC6.C6_SERIE,SC6.C6_CLI,"
		cQuery += "SC6.C6_LOJA,SC6.C6_ENTREG,SC6.C6_DESCONT,SC6.C6_LOCAL,"
		cQuery += "SC6.C6_QTDEMP,SC6.C6_QTDLIB,SC6.C6_QTDENT,SC6.C6_NFORI,SC6.C6_SERIORI,SC6.C6_ITEMORI "
		cQuery += "FROM "
		cQuery += RetSqlName("SC5") + " SC5 ,"
		cQuery += RetSqlName("SC6") + " SC6 "		
		cQuery += "WHERE "
		cQuery += "SC5.C5_FILIAL = '"+xFilial("SC5")+"' AND "		
		cQuery += "SC5.C5_NUM >= '"+mv_par01+"' AND " 
		cQuery += "SC5.C5_NUM <= '"+mv_par02+"' AND " 
		cQuery += "SC5.D_E_L_E_T_ = ' ' AND "
		cQuery += "SC6.C6_FILIAL = '"+xFilial("SC6")+"' AND "		 
		cQuery += "SC6.C6_NUM   = SC5.C5_NUM AND "
		cQuery += "SC6.D_E_L_E_T_ = ' ' "
		cQuery += "ORDER BY SC5.C5_NUM"

		cQuery := ChangeQuery(cQuery)
    	
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSC5,.T.,.T.)

		For nSC5 := 1 To Len(aStruSC5)
			If aStruSC5[nSC5][2] <> "C" .and.  FieldPos(aStruSC5[nSC5][1]) > 0
				TcSetField(cAliasSC5,aStruSC5[nSC5][1],aStruSC5[nSC5][2],aStruSC5[nSC5][3],aStruSC5[nSC5][4])
			EndIf
		Next nSC5
	    For nSC6 := 1 To Len(aStruSC6) 
			If aStruSC6[nSC6][2] <> "C" .and. FieldPos(aStruSC6[nSC6][1]) > 0
		    	TcSetField(cAliasSC6,aStruSC6[nSC6][1],aStruSC6[nSC6][2],aStruSC6[nSC6][3],aStruSC6[nSC6][4])
			EndIf
		Next nSC6		    	
	Else
#ENDIF	 
*/
		cAliasSC5 := cString
		dbSelectArea(cAliasSC5)
		cKey := IndexKey()	
		cFilter := dbFilter()
		cFilter += If( Empty( cFilter ),""," .And. " )
		cFilter += 'C5_FILIAL == "'+xFilial("SC5")+'" .And. (C5_NUM >= "'+mv_par01+'" .And. C5_NUM <= "'+mv_par02+'")'
		IndRegua(cAliasSC5,cIndex,cKey,,cFilter,STR0006)		//"Selecionando Registros..."
		#IFNDEF TOP
			DbSetIndex(cIndex+OrdBagExt())
		#ENDIF                           
		SetRegua(RecCount())		// Total de Elementos da regua
		DbGoTop()
/*
#IFDEF TOP
	Endif
#ENDIF	
*/

While !((cAliasSC5)->(Eof())) .and. xFilial("SC5")==(cAliasSC5)->C5_FILIAL

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Executa a validacao dos filtros do usuario           	     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea(cAliasSC5)
lFiltro := IIf((!Empty(aReturn[7]).And.!&(aReturn[7])),.F.,.T.)

If lFiltro
	
	cCliEnt   := IIf(!Empty((cAliasSC5)->(FieldGet(FieldPos("C5_CLIENT")))),(cAliasSC5)->C5_CLIENT,(cAliasSC5)->C5_CLIENTE)
	
	MaFisIni(cCliEnt,;							// 1-Codigo Cliente/Fornecedor
	(cAliasSC5)->C5_LOJACLI,;			// 2-Loja do Cliente/Fornecedor
	If(SC5->C5_TIPO$'DB',"F","C"),;	// 3-C:Cliente , F:Fornecedor
		(cAliasSC5)->C5_TIPO,;				// 4-Tipo da NF
		(cAliasSC5)->C5_TIPOCLI,;			// 5-Tipo do Cliente/Fornecedor
		aRelImp,;							// 6-Relacao de Impostos que suportados no arquivo
		,;						   			// 7-Tipo de complemento
		,;									// 8-Permite Incluir Impostos no Rodape .T./.F.
		"SB1",;							// 9-Alias do Cadastro de Produtos - ("SBI" P/ Front Loja)
		"MATA461")							// 10-Nome da rotina que esta utilizando a funcao
		//Na argentina o calculo de impostos depende da serie.
		If cPaisLoc == 'ARG'                         
			SA1->(DbSetOrder(1))
			SA1->(MsSeek(xFilial()+(cAliasSC5)->C5_CLIENTE+(cAliasSC5)->C5_LOJACLI))
			MaFisAlt('NF_SERIENF',LocXTipSer('SA1',MVNOTAFIS))
		Endif
		
		nTotQtd:=0
		nTotVal:=0
		nPesBru:=0
		nPesLiq:=0
		aPedCli:= {}
		If !lQuery
			dbSelectArea(cAliasSC6)
			dbSetOrder(1)
			dbSeek(xFilial("SC6")+(cAliasSC5)->C5_NUM)
		EndIf
		cPedido    := (cAliasSC5)->C5_NUM
		aC5Rodape  := {}
		aadd(aC5Rodape,{(cAliasSC5)->C5_PBRUTO,(cAliasSC5)->C5_PESOL,(cAliasSC5)->C5_DESC1,(cAliasSC5)->C5_DESC2,;
		(cAliasSC5)->C5_DESC3,(cAliasSC5)->C5_DESC4,(cAliasSC5)->C5_MENNOTA,(cAliasSC5)->C5_MENNOT1,(cAliasSC5)->C5_VROBSPV})
		
		aPedCli := Mtr730Cli(cPedido)
		
		While !((cAliasSC6)->(Eof())) .And. xFilial("SC6")==(cAliasSC6)->C6_FILIAL .And.;
			(cAliasSC6)->C6_NUM == cPedido
			
			cNfOri     := Nil
			cSeriOri   := Nil
			nRecnoSD1  := Nil
			nDesconto  := 0
			
			If !Empty((cAliasSC6)->C6_NFORI)
				dbSelectArea("SD1")
				dbSetOrder(1)
				dbSeek(xFilial("SC6")+(cAliasSC6)->C6_NFORI+(cAliasSC6)->C6_SERIORI+(cAliasSC6)->C6_CLI+(cAliasSC6)->C6_LOJA+;
				(cAliasSC6)->C6_PRODUTO+(cAliasSC6)->C6_ITEMORI)
				cNfOri     := (cAliasSC6)->C6_NFORI
				cSeriOri   := (cAliasSC6)->C6_SERIORI
				nRecnoSD1  := SD1->(RECNO())
			EndIf
			
			dbSelectArea(cAliasSC6)
			
			If lEnd
				@ Prow()+1,001 PSAY STR0007 //"CANCELADO PELO OPERADOR"
				Exit
			EndIf   

			If ((cAliasSC6)->C6_PRCVEN <> (cAliasSC6)->C6_PRUNIT .And. (cAliasSC6)->C6_PRUNIT<> 0 ) .Or. (cAliasSC6)->C6_VALDESC > 0
				nDesconto := (a410Arred((cAliasSC6)->C6_PRUNIT*(cAliasSC6)->C6_QTDVEN,"D2_DESCON")-(cAliasSC6)->C6_VALOR)
				nDesconto := If(nDesconto==0,(cAliasSC6)->C6_VRVLRDE,nDesconto)				
			Endif	
			
			MaFisAdd((cAliasSC6)->C6_PRODUTO,; 	  // 1-Codigo do Produto ( Obrigatorio )
					(cAliasSC6)->C6_TES,;			  // 2-Codigo do TES ( Opcional )
					(cAliasSC6)->C6_QTDVEN,;		  // 3-Quantidade ( Obrigatorio )
					(cAliasSC6)->C6_PRUNIT,;		  // 4-Preco Unitario ( Obrigatorio )
					nDesconto,;       // 5-Valor do Desconto ( Opcional )
					cNfOri,;		                  // 6-Numero da NF Original ( Devolucao/Benef )
					cSeriOri,;		                  // 7-Serie da NF Original ( Devolucao/Benef )
					nRecnoSD1,;			          // 8-RecNo da NF Original no arq SD1/SD2
					0,;							  // 9-Valor do Frete do Item ( Opcional )
					0,;							  // 10-Valor da Despesa do item ( Opcional )
					0,;            				  // 11-Valor do Seguro do item ( Opcional )
					0,;							  // 12-Valor do Frete Autonomo ( Opcional )
					((cAliasSC6)->C6_VALOR+nDesconto),;// 13-Valor da Mercadoria ( Obrigatorio )
					0,;							  // 14-Valor da Embalagem ( Opiconal )
					0,;		     				  // 15-RecNo do SB1
					0) 							  // 16-RecNo do SF4
					  
			nItem += 1
			IF li > 45
				IF lRodape
					ImpRodape(nPesLiq,nTotQtd,nTotVal,@li,nPesBru,aC5Rodape,cAliasSC5,,cAliasSC6)
				Endif
				li := 0
				lRodape := ImpCabec(@li,aPedCli,cAliasSC5)
			Endif
			ImpItem(nItem,@nPesLiq,@li,@nTotQtd,@nTotVal,@nPesBru,cAliasSC6,cAliasSC5)
			If !lQuery
				dbSelectArea(cAliasSC6)
			EndIf
			
			MaFisAlt("NF_FRETE"   ,(cAliasSC5)->C5_FRETE)
			MaFisAlt("NF_SEGURO"  ,(cAliasSC5)->C5_SEGURO)
			MaFisAlt("NF_AUTONOMO",(cAliasSC5)->C5_FRETAUT)
			MaFisAlt("NF_DESPESA" ,(cAliasSC5)->C5_DESPESA)
					
			(cAliasSC6)->(dbSkip())
			li++
		EndDo

		nItem := 0
		IF lRodape
			ImpRodape(nPesLiq,nTotQtd,nTotVal,@li,nPesBru,aC5Rodape,cAliasSC5,.T.,cAliasSC6)
			lRodape:=.F.
		Endif
		
		MaFisEnd()
		
		If !lQuery
			IncRegua()
			dbSelectArea(cAliasSC5)
			dbSkip()
		Endif
		
	Else
		dbSelectArea(cAliasSC5)
		dbSkip()
	EndIf

EndDo 

If lQuery   
    dbSelectArea(cAliasSC5)
	dbCloseArea()
Endif	

Set Device To Screen
Set Printer To

RetIndex("SC5")   
dbSelectArea("SC5")
dbClearFilter()

Ferase(cIndex+OrdBagExt())

dbSelectArea("SC6")
dbClearFilter()
dbSetOrder(1)
dbGotop()

If ( aReturn[5] = 1 )
	dbCommitAll()
	OurSpool(wnrel)
Endif
MS_FLUSH()
Return(.T.)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ImpItem  ³ Autor ³ Claudinei M. Benzi    ³ Data ³ 05.11.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Emissao da Pr‚-Nota                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ ImpItem(void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Matr730                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ImpItem(nItem,nPesLiq,li,nTotQtd,nTotVal,nPesBru,cAliasSC6,cAliasSC5)

Local nUltLib  := 0
Local cChaveD2 := ""
Local nDecs	   := MsDecimais(Max(1,(cAliasSC5)->C5_MOEDA))
Local nValImp  := 0
dbSelectArea("SB1")
dbSeek(xFilial("SB1")+(cAliasSC6)->C6_PRODUTO)
 
@li,000 psay (cAliasSC6)->C6_ITEM
@li,003 psay (cAliasSC6)->C6_PRODUTO
@li,019 psay SUBS(IIF(Empty((cAliasSC6)->C6_DESCRI),SB1->B1_DESC,(cAliasSC6)->C6_DESCRI),1,30)
@li,050 psay (cAliasSC6)->C6_TES
@li,054 psay (cAliasSC6)->C6_UM
@li,056 psay (cAliasSC6)->C6_QTDVEN	Picture PesqPict("SC6","C6_QTDVEN",10)
@li,067 psay (cAliasSC6)->C6_PRCVEN	Picture PesqPict("SC6","C6_PRCVEN",12)
/*
If cPaisLoc == "BRA"
	nValImp	:=	MaFisRet(nItem,"IT_VALIPI")
	@li,080 psay MaFisRet(nItem,"IT_ALIQIPI") Picture "@e 99.99"
Else             
	nValImp	:=	MaRetIncIV(nItem,"2")
	@li,080 psay  nValImp	Picture Tm(nValImp,10,nDecs)
Endif

If ( cPaisLoc=="BRA" )
	@li,086 psay MaFisRet(nItem,"IT_ALIQICM") Picture "@e 99.99" //Aliq de ICMS
	@li,092 psay SB1->B1_ALIQISS	Picture "@e 99.99"    //Aliq de ISS
EndIf
*/
cChaveD2 := xFilial("SD2")+(cAliasSC6)->C6_NOTA+(cAliasSC6)->C6_SERIE+(cAliasSC6)->C6_CLI+(cAliasSC6)->C6_LOJA+(cAliasSC6)->C6_PRODUTO
dbSelectArea("SD2")
dbSetOrder(3)
dbSeek(cChaveD2)
While !Eof() .and. cChaveD2 = xFilial("SD2")+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD
	nUltLib := D2_QUANT
	dbSkip()
EndDo
//97
@li,080   psay (cAliasSC6)->C6_VALOR+nValImp Picture PesqPict("SC6","C6_VALOR",14,nDecs)
//112
@li,095   psay (cAliasSC6)->C6_ENTREG
//122
@li,105   psay (cAliasSC6)->C6_VRDESC    Picture "99.9"
//128
@li,112   psay (cAliasSC6)->C6_QTDEMP  Picture PesqPict("SC6","C6_QTDLIB",10)
@li,120   psay (cAliasSC6)->C6_VRSLDPR Picture PesqPict("SC6","C6_QTDLIB",10)

// CAVALINI --> 18/01/2006
//@li,128   psay (cAliasSC6)->C6_LOCAL
//@li,130   psay (cAliasSC6)->C6_QTDEMP Picture PesqPict("SC6","C6_QTDLIB",10)
//@li,140   psay (cAliasSC6)->C6_QTDVEN - (cAliasSC6)->C6_QTDEMP + (cAliasSC6)->C6_QTDLIB - (cAliasSC6)->C6_QTDENT Picture PesqPict("SC6","C6_QTDLIB",10)
//@li,150   psay nUltLib Picture PesqPict("SD2","D2_QUANT",10)

nTotQtd += (cAliasSC6)->C6_QTDVEN                           
nTotVal += (cAliasSC6)->C6_VALOR+nValImp
nPesLiq	+= SB1->B1_PESO * (cAliasSC6)->C6_QTDVEN
nPesBru += SB1->B1_PESBRU * (cAliasSC6)->C6_QTDVEN
Return (Nil)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ImpRodape³ Autor ³ Claudinei M. Benzi    ³ Data ³ 05.11.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Emissao da Pr‚-Nota                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ ImpRoadpe(void)                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Matr730                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ImpRodape(nPesLiq,nTotQtd,nTotVal,li,nPesBru,aC5Rodape,cAliasSC5,lFinal,cAliasSC6)
Local aCodImps	:=	{} 
Local I     := 0 

DEFAULT lFinal := .F.

//@ li,000 psay Replicate("-",limite-60)
@ li,000 psay Replicate("-",132)
li++
@ li,000 psay STR0029	//" T O T A I S "
@ li,056 psay nTotQtd    Picture PesqPict("SC6","C6_QTDVEN",10)
If ( cPaisLoc=="BRA" )
	@ li,094 psay nTotVal    Picture PesqPict("SC6","C6_VALOR",17)
Else
	@ li,088 psay nTotVal    Picture PesqPict("SC6","C6_VALOR",17)
EndIf

If lFinal
	li++                                                                            
//	@ li,000 psay Replicate("-",limite-60)                                         
    @ li,000 psay Replicate("-",132)
	If cPaisLoc == 'BRA'
		li++                                                                            
		@ li,000 psay "I M P O S T O S ==>" //STR0038
		@ li,026 PSay "Base ICMS"           //STR0039
		@ li,046 PSay "Valor ICMS"          //STR0040
		@ li,067 PSay "Base IPI"            //STR0041
		@ li,087 PSay "Valor IPI"           //STR0042
        li++
		@ li,026 PSay "Base Retido"         //STR0043
		@ li,046 PSay "Valor Retido"        //STR0044
		@ li,067 PSay "Valor Total"         //STR0045	
		li++
		@ li,022 PSay Transform(MaFisRet(,"NF_BASEICM"),"@E 99,999,999.99")
		@ li,042 PSay Transform(MaFisRet(,"NF_VALICM"),"@E 99,999,999.99")
	    @ li,062 PSay Transform(MaFisRet(,"NF_BASEIPI"),"@E 99,999,999.99")
	    @ li,083 PSay Transform(MaFisRet(,"NF_VALIPI"),"@E 99,999,999.99") 
	    li++
		@ li,022 PSay Transform(MaFisRet(,"NF_BASESOL"),"@E 99,999,999.99")
		@ li,042 PSay Transform(MaFisRet(,"NF_VALSOL"),"@E 99,999,999.99")
		@ li,062 PSay Transform(MaFisRet(,"NF_TOTAL"),"@E 99,999,999.99")              	
		li++                                                                            	
		@ li,026 psay "Base ISS"            //STR0046
		@ li,046 PSay "Valor ISS"           //STR0047
		li++                                                                            		
		@ li,022 PSay Transform(MaFisRet(,"NF_BASEISS"),"@E 99,999,999.99")
		@ li,042 PSay Transform(MaFisRet(,"NF_VALISS"),"@E 99,999,999.99")
	Else                                              
	
		aCodImps := MaFisRet(,"NF_IMPOSTOS") //Descricao / /Aliquota / Valor / Base
		li++
		@ li,000 psay "I M P O S T O S ==>" //STR0038
		@ li,025 PSay "Imposto                                 Base      Aliquota         Valor" //STR0049
		li++         			
		@ li,025 PSay           "------------------------------ ------------- ------------- -------------"
		li++
		For I:=1 To Len(aCodImps)// Vetor com os impostos
		   	@ li,25 PSay aCodImps[I][2] 
			@ li,57 PSay aCodImps[I][3] Picture TM(aCodImps[I][4],12,MsDecimais(1))
			@ li,71 PSay aCodImps[I][4] Picture TM(aCodImps[I][4],12,MsDecimais(1))
			@ li,85 PSay aCodImps[I][5] Picture TM(aCodImps[I][4],12,MsDecimais(1))
            li++
		Next
		
	Endif                     
Endif	

@ 50,005 psay STR0030+STR(If(aC5Rodape[1][1] > 0,aC5Rodape[1][1],nPesBru))	//"PESO BRUTO ------>"
@ 51,005 psay STR0031+STR(If(aC5Rodape[1][2] > 0,aC5Rodape[1][2] ,nPesLiq))	//"PESO LIQUIDO ---->"
@ 52,005 psay STR0032	//"VOLUMES --------->"
@ 53,005 psay STR0033	//"SEPARADO POR ---->"
@ 54,005 psay STR0034	//"CONFERIDO POR --->"
@ 55,005 psay STR0035	//"D A T A --------->"

@ 57,000 psay STR0036	//"DESCONTOS: "
@ 57,011 psay aC5Rodape[1][3] Picture "99.99"
@ 57,019 psay aC5Rodape[1][4] picture "99.99"
@ 57,027 psay aC5Rodape[1][5] picture "99.99"
@ 57,035 psay aC5Rodape[1][6] picture "99.99"

@ 59,000 psay "MENSAGEM PARA NOTA FISCAL: "+AllTrim(aC5Rodape[1][7])	
@ 60,000 psay "                           "+AllTrim(aC5Rodape[1][8])
@ 61,000 psay "                           "+AllTrim(aC5Rodape[1][9])


li := 80

Return( NIL )

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ImpCabec ³ Autor ³ Claudinei M. Benzi    ³ Data ³ 05.11.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Emissao da Pr‚-Nota                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ ImpCabec(void)                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Matr730                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ImpCabec(li,aPedCli,cAliasSC5)

Local cHeader	:= ""
Local nPed		:= 0
Local i         := 0 
Local cMoeda	:= ""
Local cCampo    := ""
Local cComis    := ""
Local cPedCli   := ""
Local cPictCgc  := ""
Local aSX3Box   := RetSX3Box(Posicione("SX3",2,"C5_TIPOCLI","X3CBOX()"),,,1)
Local nSX3Box   := aScan(aSX3Box,{|a| a[2]==SC5->C5_TIPOCLI})
If cPaisLoc == "BRA"                                                    
	cHeader := "It Codigo          Desc. do Material TES UM               Quant        Unit.        Total      Entr      Desc          Emp  Pend""
//	cHeader := "It Codigo          Desc. do Material TES UM   Quant.  Valor Unit.        Vl.Tot.C/IPI Entrega   Desc Qtd.Emp Pendente"
	//STR0008	//"It Codigo          Desc. do Material TES UM   Quant.  Valor Unit. IPI   ICM   ISS   Vl.Tot.C/IPI Entrega   Desc Loc.Qtd.a Fat     Saldo  Ult.Fat."
	//          				99 xxxxxxxxxxxxxxx xxxxxxxxxxxxxxxxx 999 XX99999.99999,999,999.9999,99 99,9999,99 999,999,999.99 99/99/9999 9.9  999999999.999999999.999999999,99
	//          				0         1         2         3         4         5         6         7         8         9        10        11        12        13        14
	//                      0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234
Else                                                                                     
	cHeader := "It Codigo          Desc. do Material TES UM   Quant.  Valor Unit.        Vl.Tot.C/IPI Entrega   Desc Qtd.Emp Pendente"
	//          				99 xxxxxxxxxxxxxxx xxxxxxxxxxxxxxxxx 999 XX99999.99999,999,999.9999,99 99,9999,99 999,999,999.99 99/99/9999 9.9  999999999.999999999.999999999,99
	//          				0         1         2         3         4         5         6         7         8         9        10        11        12        13        14
	//                      0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posiciona registro no cliente do pedido                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

IF !((cAliasSC5)->C5_TIPO$"DB")
	dbSelectArea("SA1")
	dbSeek(xFilial("SA1")+(cAliasSC5)->C5_CLIENTE+(cAliasSC5)->C5_LOJACLI)
    cPictCgc := PesqPict("SA1","A1_CGC")	
Else
	dbSelectArea("SA2")
	dbSeek(xFilial("SA2")+(cAliasSC5)->C5_CLIENTE+(cAliasSC5)->C5_LOJACLI)
    cPictCgc := PesqPict("SA2","A2_CGC")	
Endif

dbSelectArea("SA4")
dbSetOrder(1)
dbSeek(xFilial("SA4")+(cAliasSC5)->C5_TRANSP)
dbSelectArea("SE4") 
dbSetOrder(1)
dbSeek(xFilial("SE4")+(cAliasSC5)->C5_CONDPAG)

aSort(aPedCli)
@ 00,000 psay AvalImp(limite)
@ 01,000 psay Replicate("-",132)
//@ 01,000 psay Replicate("-",limite-60)
@ 02,000 psay SM0->M0_NOME
IF !((cAliasSC5)->C5_TIPO$"DB")
	@ 02,041 psay "| "+Left(SA1->A1_COD+"/"+SA1->A1_LOJA+" "+SA1->A1_NOME, 56)
	@ 02,100 psay STR0009		//"| CONFIRMACAO DO PEDIDO "
	@ 03,000 psay SM0->M0_ENDCOB
	@ 03,041 psay "| "+IF( !Empty(SA1->A1_ENDENT) .And. SA1->A1_ENDENT # SA1->A1_END,SA1->A1_ENDENT, SA1->A1_END )
	@ 03,100 psay "|"
	@ 04,000 psay STR0010+SM0->M0_TEL			//"TEL: "
	@ 04,041 psay "| "
	@ 04,043 psay IF( !Empty(SA1->A1_CEPE) .And. SA1->A1_CEPE # SA1->A1_CEP,SA1->A1_CEPE, SA1->A1_CEP )
	@ 04,053 psay IF( !Empty(SA1->A1_MUNE) .And. SA1->A1_MUNE # SA1->A1_MUN,SA1->A1_MUNE, SA1->A1_MUN )
	@ 04,077 psay IF( !Empty(SA1->A1_ESTE) .And. SA1->A1_ESTE # SA1->A1_EST,SA1->A1_ESTE, SA1->A1_EST )
	@ 04,100 psay STR0011		//"| EMISSAO: "
	@ 04,111 psay (cAliasSC5)->C5_EMISSAO
	@ 05,000 psay Iif(cPaisLoc=="BRA",STR0012,Alltrim(Posicione('SX3',2,'A1_CGC','SX3->X3_TITULO'))+":")		//"CGC: "
	@ 05,006 psay SM0->M0_CGC    Picture cPictCGC //"@R 99.999.999/9999-99"
	@ 05,025 psay Subs(SM0->M0_CIDCOB,1,15)
	@ 05,041 psay "|"
    @ 05,043 psay subs(transform(SA1->A1_CGC,PicPes(RetPessoa(SA1->A1_CGC))),1,at("%",transform(SA1->A1_CGC,PicPes(RetPessoa(SA1->A1_CGC))))-1)
	If cPaisLoc == "BRA"	
		@ 05,062 psay AllTrim(STR0013+SA1->A1_INSCR)  Picture PesqPict("SA2","A2_INSCR")			//"IE: "
		@ 05,082 pSay "(" + Left(AllTrim(aSX3Box[nSX3Box,1]),16) + ")"
	Endif
	@ 05,100 psay STR0014+(cAliasSC5)->C5_NUM			//"| PEDIDO N. "
Else
	@ 02,041 psay "| "+SA2->A2_COD+"/"+SA2->A2_LOJA+" "+SA2->A2_NOME
	@ 02,100 psay STR0009	//"| CONFIRMACAO DO PEDIDO "
	@ 03,000 psay SM0->M0_ENDCOB
	@ 03,041 psay "| "+ SA2->A2_END
	@ 03,100 psay "|"
	@ 04,000 psay STR0010+SM0->M0_TEL			//"TEL: "
	@ 04,041 psay "| "+SA2->A2_CEP
	@ 04,053 psay SA2->A2_MUN
	@ 04,077 psay SA2->A2_EST
	@ 04,100 psay STR0011		//"| EMISSAO: "
	@ 04,111 psay (cAliasSC5)->C5_EMISSAO
	@ 05,000 psay Iif(cPaisLoc=="BRA",STR0012,Alltrim(Posicione('SX3',2,'A1_CGC','SX3->X3_TITULO'))+":")		//"CGC: "
	@ 05,006 psay SM0->M0_CGC    Picture cPictCGC //"@R 99.999.999/9999-99"
	@ 05,025 psay Subs(SM0->M0_CIDCOB,1,15)
	@ 05,041 psay "|"
	@ 05,043 psay SA2->A2_CGC    Picture cPictCGC //"@R 99.999.999/9999-99"
	If cPaisLoc == "BRA"	
		@ 05,062 psay AllTrim(STR0013+SA2->A2_INSCR) Picture PesqPict("SA2","A2_INSCR")		//"IE: "
		@ 05,082 pSay "(" + Left(AllTrim(aSX3Box[nSX3Box,1]),16) + ")"
	Endif	
	@ 05,100 psay STR0014+(cAliasSC5)->C5_NUM			//"| PEDIDO N. "
Endif
li:= 6
If Len(aPedCli) > 0
//	@ li,000 psay Replicate("-",limite-60)
    @ li,000 psay Replicate("-",132)
	li++
	@ li,000 psay "PEDIDO(S) DO CLIENTE:"
	cPedCli:=""
	For nPed := 1 To Len(aPedCli)
		cPedCli += aPedCli[nPed]+Space(02)
		If Len(cPedCli) > 100 .or. nPed == Len(aPedCli)
			@ li,23 psay cPedCli
			cPedCli:=""
			li++
		Endif
	Next
Endif
@ li,000 psay Replicate("-",132)
//@ li,000 psay Replicate("-",limite-60)
li++
@ li,000 psay STR0016+(cAliasSC5)->C5_TRANSP+" - "+SA4->A4_NOME+" - "+SA4->A4_TEL			//"TRANSP...: "
li++

For i := 1 to 5
	
	cCampo := "C5_VEND" + Str(i,1,0)
	cComis := "C5_COMIS" + Str(i,1,0)
	
		dbSelectArea("SA3")
		dbSetOrder(1)
		If dbSeek(xFilial("SA3")+(cAliasSC5)->(FieldGet(FieldPos(cCampo))))
			If i == 1
				@ li,000 psay STR0017		//"VENDEDOR.: "
			EndIf
			@ li,011 psay (cAliasSC5)->(FieldGet(FieldPos(cCampo))) + " - "+SA3->A3_NOME
			If i == 1
				@ li,065 psay STR0018		//"COMISSAO: "
			EndIf
			@ li,075 psay (cAliasSC5)->(FieldGet(FieldPos(cComis))) Picture "99.99"
			li++
		EndIf	
Next

@ li,000 psay "REPRES...: "

dbSelectArea("SA3")
dbSetOrder(1)
If dbSeek(xFilial("SA3")+SC5->C5_VEND2)
	@ li,011 psay SC5->C5_VEND2 + " - " + SA3->A3_NOME
	@ li,065 psay STR0018		//"COMISSAO: "
	@ li,075 psay SC5->C5_COMREP Picture "99.99"
	li++
EndIf

@ li,000 psay STR0019+(cAliasSC5)->C5_CONDPAG+" - "+SE4->E4_DESCRI			//"COND.PGTO: "
@ li,065 psay STR0020		//"FRETE...: "
@ li,075 psay (cAliasSC5)->C5_FRETE  Picture "@EZ 999,999,999.99"
If (cAliasSC5)->C5_FRETE > 0
	@ li,090 psay IIF((cAliasSC5)->C5_TPFRETE="C","(CIF)","(FOB)")
Endif
@ li,100 psay STR0021		//"SEGURO: "
@ li,108 psay (cAliasSC5)->C5_SEGURO Picture "@EZ 999,999,999.99"
li++
@ li,000 psay STR0022+(cAliasSC5)->C5_TABELA		//"TABELA...: "
@ li,065 psay STR0023		//"VOLUMES.: "
@ li,075 psay (cAliasSC5)->C5_VOLUME1    Picture "@EZ 999,999"
@ li,100 psay STR0024+(cAliasSC5)->C5_ESPECI1		//"ESPECIE: "
li++
cMoeda:=Strzero((cAliasSC5)->C5_MOEDA,1,0)
@ li,000 psay STR0025+(cAliasSC5)->C5_REAJUST+STR0026 +IIF(cMoeda < "2","1",cMoeda)		//"REAJUSTE.: "###"   Moeda : "
@ li,065 psay STR0027 + (cAliasSC5)->C5_BANCO					//"BANCO: "
@ li,100 psay STR0028+Str((cAliasSC5)->C5_ACRSFIN,6,2)		//"ACRES.FIN.: "
li++
@ li,000 psay Replicate("-",132)
//@ li,000 psay Replicate("-",limite-60)
li++
@ li,000 psay cHeader
li++
@ li,000 psay Replicate("-",132)
//@ li,000 psay Replicate("-",limite-60)
li++

Return( .T. )

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³Mtr730Cli ³ Autor ³ Henry Fila            ³ Data ³ 26.08.02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Função que retorna os pedidos do cliente                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ Mtr730Cli(cPedido)                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1: Numero do pedido                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Matr730                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Mtr730Cli(cPedido)

Local aPedidos := {}
Local aArea    := GetArea()
Local aAreaSC6 := SC6->(GetArea())

SC6->(dbSetOrder(1))
SC6->(MsSeek(xFilial("SC6")+cPedido))

While !(SC6->(Eof())) .And. xFilial("SC6")==SC6->C6_FILIAL .And.;
	SC6->C6_NUM == cPedido                                                    
	
	If !Empty(SC6->C6_PEDCLI) .and. Ascan(aPedidos,SC6->C6_PEDCLI) = 0
		Aadd(aPedidos, SC6->C6_PEDCLI )
	Endif		

	SC6->(dbSkip())                                   
Enddo              

RestArea(aAreaSC6)
RestArea(aArea)

Return(aPedidos)