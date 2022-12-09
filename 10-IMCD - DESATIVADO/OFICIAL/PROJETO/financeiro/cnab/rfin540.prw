/*複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴컴컫컴컴컴쩡컴컴컴컴커굇
굇쿑un뇚o    ?MATR540R3?Autor ?Claudinei M. Benzi       ?Data ?13.04.92 낢?
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴컴컨컴컴컴좔컴컴컴컴캑굇
굇쿏escri뇚o ?Relatorio de Comissoes.                                       낢?
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴캑굇
굇쿞intaxe   ?MATR540(void)                                                 낢?
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴캑굇
굇?Uso      ?Generico                                                      낢?
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸굇
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇 
굇旼컴컴컴컫컴컴컴쩡컴컴컴컴컫컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커굇
굇?DATA   ?BOPS 쿛rogramad.쿌LTERACAO                                      낢?
굇쳐컴컴컴컵컴컴컴탠컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴캑굇
굇?5.02.03쿦XXXXX쿐duardo Ju쿔nclusao de Queries para filtros em TOPCONNECT.낢?
굇읕컴컴컴컨컴컴컴좔컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸굇
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽*/

User Function RFIN540()
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//?Define Variaveis                                             ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
Local wnrel
Local titulo    := "Relatorio de Comissoes"
Local cDesc1    := "Emissao do relatorio de Comissoes."
Local tamanho   := "G"
Local limite    := 220
Local cString   := "SE3"
Local cAliasAnt := Alias()
Local cOrdemAnt := IndexOrd()
Local nRegAnt   := Recno()

//oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "RFIN540" , __cUserID )

PUBLIC cDescVend := " "

Private aReturn := { OemToAnsi("Zebrado"), 1,OemToAnsi("Administracao"), 1, 2, 1, "",1 }  //"Zebrado"###"Administracao"
Private nomeprog:= "MATR540"
Private aLinha  := { },nLastKey := 0
Private cPerg   := "MTR540"

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//?Verifica as perguntas selecionadas                           ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸

Pergunte("MTR540",.F.)
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
//?Variaveis utilizadas para parametros                          ?
//?mv_par01        	// Pela <E>missao,<B>aixa ou <A>mbos      ?
//?mv_par02        	// A partir da data                       ?
//?mv_par03        	// Ate a Data                             ?
//?mv_par04 	    	// Do Vendedor                            ?
//?mv_par05	     	// Ao Vendedor                            ?
//?mv_par06	     	// Quais (a Pagar/Pagas/Ambas)            ?
//?mv_par07	     	// Incluir Devolucao ?                    ?
//?mv_par08	     	// Qual moeda                             ?
//?mv_par09	     	// Comissao Zerada ?                      ?
//?mv_par10	     	// Abate IR Comiss                        ?
//?mv_par11	     	// Quebra pag.p/Vendedor                  ?
//?mv_par12	     	// Tipo de Relatorio (Analitico/Sintetico)?
//?mv_par13	     	// Imprime detalhes origem                ?
//?mv_par14         // Nome cliente							  ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//?Envia controle para a funcao SETPRINT                        ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
wnrel := "MATR540"
wnrel := SetPrint(cString,wnrel,cPerg,titulo,cDesc1,"","",.F.,"",.F.,Tamanho)

If nLastKey==27
	dbClearFilter()
	Return
Endif
SetDefault(aReturn,cString)
If nLastKey ==27
	dbClearFilter()
	Return
Endif

RptStatus({|lEnd| U_C540Imp(@lEnd,wnRel,cString)},Titulo)

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//?Retorna para area anterior, indice anterior e registro ant.  ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
DbSelectArea(caliasAnt)
DbSetOrder(cOrdemAnt)
DbGoto(nRegAnt)
Return

/*複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽?
굇쿑un뇚o    ?C540IMP  ?Autor ?Rosane Luciane Chene  ?Data ?09.11.95 낢?
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙?
굇쿏escri뇚o ?Chamada do Relatorio                                       낢?
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙?
굇?Uso      ?MATR540			                                          낢?
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽*/
User Function C540Imp(lEnd,WnRel,cString)
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//?Define Variaveis                                             ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸

Local CbCont,cabec1,cabec2
Local tamanho  := "G"
Local limite   := 220
Local nomeprog := "MATR540"
Local imprime  := .T.
Local cPict    := ""
Local cTexto,j :=0,nTipo:=0
Local cCodAnt,nCol:=0
Local nAc1:=0,nAc2:=0,nAg1:=0,nAg2:=0,nAc3:=0,nAg3:=0,nAc4:=0,nAg4:=0,lFirstV:=.T.
Local nTregs,nMult,nAnt,nAtu,nCnt,cSav20,cSav7
Local lContinua:= .T.
Local cNFiscal :=""
Local aCampos  :={}
Local lImpDev  := .F.
Local cBase    := ""
Local cNomArq, cCondicao, cFilialSE1, cFilialSE3, cChave, cFiltroUsu
Local nDecs    := GetMv("MV_CENT"+(IIF(mv_par08 > 1 , STR(mv_par08,1),"")))
Local nBasePrt :=0, nComPrt:=0 
Local aStru    := SE3->(dbStruct()), ni
Local nDecPorc := TamSX3("E3_PORC")[2]

Local cDocLiq   := ""
Local cTitulo  := "" 
Local dEmissao := CTOD( "" ) 
Local nTotLiq  := 0
Local aLiquid  := {}
Local aValLiq  := {}
Local aLiqProp := {}
Local ny
Local aColuna := IIF(cPaisLoc <> "MEX",{15,19,42,46,83,95,107,119,130,137,153,169,176,195,203},{28,35,58,62,99,111,123,135,146,153,169,185,192,211,219})
Local nVLRET  := GetMV("MV_VLRETIR")
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//?Variaveis utilizadas para Impressao do Cabecalho e Rodape    ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
cbtxt    := Space(10)
cbcont   := 00
li       := 80
m_pag    := 01
imprime  := .T.

nTipo := IIF(aReturn[4]==1,15,18)

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//?Definicao dos cabecalhos                                     ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
If mv_par12 == 1
	If mv_par01 == 1
		titulo := OemToAnsi("RELATORIO DE COMISSOES")+OemToAnsi("PGTO PELA EMISSAO")+" ("+OemToAnsi("MOEDA")+") "+ " - " + GetMv("MV_MOEDA" + STR(mv_par08,1)) //"RELATORIO DE COMISSOES "###"(PGTO PELA EMISSAO)"
	Elseif mv_par01 == 2
		titulo := OemToAnsi("RELATORIO DE COMISSOES")+OemToAnsi("PGTO PELA BAIXA")+" ("+OemToAnsi("MOEDA")+") "+ " - " + GetMv("MV_MOEDA" + STR(mv_par08,1))  //"RELATORIO DE COMISSOES "###"(PGTO PELA BAIXA)"
	Else
		titulo := OemToAnsi("RELATORIO DE COMISSOES")+" ("+OemToAnsi("MOEDA")+") "+ " - " + GetMv("MV_MOEDA" + STR(mv_par08,1))  //"RELATORIO DE COMISSOES"
	Endif

	cabec1:=OemToAnsi("PRF NUMERO   PARC. CODIGO DO              LJ  NOME                                 DT.BASE     DATA        DATA        DATA       NUMERO          VALOR           VALOR      %           VALOR    TIPO")
	cabec2:=OemToAnsi("    TITULO         CLIENTE                                                         COMISSAO    VENCTO      BAIXA       PAGTO      PEDIDO         TITULO            BASE               COMISSAO   COMISSAO")
									// XXX XXXXXXxxxxxx X XXXXXXxxxxxxxxxxxxxx   XX  012345678901234567890123456789012345 XX/XX/XXxx  XX/XX/XXxx  XX/XX/XXxx  XX/XX/XXxx XXXXXX 12345678901,23  12345678901,23  99.99  12345678901,23     X       AJUSTE
									// 0         1         2         3         4         5         6         7         8         9         10        11        12        13        14        15        16        17        18        19        20        21
									// 0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
	If cPaisLoc == "MEX"
		Cabec1 := Substr(Cabec1,1,10) + Space(16) + Substr(Cabec1,11)
		Cabec2 := Substr(Cabec2,1,10) + Space(16) + Substr(Cabec2,11)
	EndIf								
Else
	If mv_par01 == 1
		titulo := OemToAnsi("RELATORIO DE COMISSOES")+OemToAnsi("PGTO PELA EMISSAO")+" ("+OemToAnsi("MOEDA")+") "+ " - " + GetMv("MV_MOEDA" + STR(mv_par08,1)) //"RELATORIO DE COMISSOES "###"(PGTO PELA EMISSAO)"
	Elseif mv_par01 == 2
		titulo := OemToAnsi("RELATORIO DE COMISSOES")+OemToAnsi("PGTO PELA BAIXA")+" ("+OemToAnsi("MOEDA")+") "+ " - " + GetMv("MV_MOEDA" + STR(mv_par08,1))  //"RELATORIO DE COMISSOES "###"(PGTO PELA BAIXA)"
	Else
		titulo := OemToAnsi("RELATORIO DE COMISSOES")+" ("+OemToAnsi("MOEDA")+") "+ " - " + GetMv("MV_MOEDA" + STR(mv_par08,1))  //"RELATORIO DE COMISSOES"
	Endif
	cabec1:=OemToAnsi("CODIGO VENDEDOR                                           TOTAL            TOTAL      %            TOTAL           TOTAL           TOTAL")
	cabec2:=OemToAnsi("                                                         TITULO             BASE                COMISSAO              IR          (-) IR")
                                //"XXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 123456789012,23  123456789012,23  99.99  123456789012,23 123456789012,23 123456789012,23
                                //"0         1         2         3         4         5         6         7         8         9         10        11        12        13        14        15        16        17        18        19        20        21
                                //"0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
EndIf

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//?Monta condicao para filtro do arquivo de trabalho            ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸

DbSelectArea("SE3")	// Posiciona no arquivo de comissoes
DbSetOrder(2)			// Por Vendedor
cFilialSE3 := xFilial()
cNomArq :=CriaTrab("",.F.)

cCondicao := "SE3->E3_FILIAL=='" + cFilialSE3 + "'"
cCondicao += ".And.SE3->E3_VEND>='" + mv_par04 + "'"
cCondicao += ".And.SE3->E3_VEND<='" + mv_par05 + "'"
cCondicao += ".And.DtoS(SE3->E3_EMISSAO)>='" + DtoS(mv_par02) + "'"
cCondicao += ".And.DtoS(SE3->E3_EMISSAO)<='" + DtoS(mv_par03) + "'" 

If mv_par01 == 1
	cCondicao += ".And.SE3->E3_BAIEMI!='B'"  // Baseado pela emissao da NF
Elseif mv_par01 == 2
	cCondicao += " .And.SE3->E3_BAIEMI=='B'"  // Baseado pela baixa do titulo
Endif 

If mv_par06 == 1 		// Comissoes a pagar
	cCondicao += ".And.Dtos(SE3->E3_DATA)=='"+Dtos(Ctod(""))+"'"
ElseIf mv_par06 == 2 // Comissoes pagas
	cCondicao += ".And.Dtos(SE3->E3_DATA)!='"+Dtos(Ctod(""))+"'"
Endif

If mv_par09 == 1 		// Nao Inclui Comissoes Zeradas
   cCondicao += ".And.SE3->E3_COMIS<>0"
EndIf

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//?Cria expressao de filtro do usuario                          ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
If ( ! Empty(aReturn[7]) )
	cFiltroUsu := &("{ || " + aReturn[7] +  " }")
Else
	cFiltroUsu := { || .t. }
Endif

nAg1 := nAg2 := nAg3 := nAg4 := 0

#IFDEF TOP
	If TcSrvType() != "AS/400"
		cOrder := SqlOrder(SE3->(IndexKey()))
		
		cQuery := "SELECT * "
		cQuery += "  FROM "+	RetSqlName("SE3")
		cQuery += " WHERE (E3_FILIAL = '" + xFilial("SE3") + "' AND "
	  	cQuery += "	E3_VEND >= '"  + mv_par04 + "' AND E3_VEND <= '"  + mv_par05 + "' AND " 
		cQuery += "	E3_EMISSAO >= '" + Dtos(mv_par02) + "' AND E3_EMISSAO <= '"  + Dtos(mv_par03) + "' AND " 
		
		If mv_par01 == 1
			cQuery += "E3_BAIEMI <> 'B' AND "  //Baseado pela emissao da NF
		Elseif mv_par01 == 2
			cQuery += "E3_BAIEMI =  'B' AND "  //Baseado pela baixa do titulo  
		EndIf	
		
		If mv_par06 == 1 		//Comissoes a pagar
			cQuery += "E3_DATA = '" + Dtos(Ctod("")) + "' AND "
		ElseIf mv_par06 == 2 //Comissoes pagas
  			cQuery += "E3_DATA <> '" + Dtos(Ctod("")) + "' AND "
		Endif 
		
		If mv_par09 == 1 		//Nao Inclui Comissoes Zeradas
   		cQuery+= "E3_COMIS <> 0 AND "
		EndIf  
		
//		cQuery += "D_E_L_E_T_ <> '*' ) OR (E3_FILIAL = '  ' AND D_E_L_E_T_ <> '*' )"   

		//**********************************************************************//
		//Alterado em 09/01/2014, pelo analista Marcus Vinicius Barros (Totvs) //
		//Pois a clausula "OR", carrega todos os vendedores no relatorio      //
		//gerando diversas paginas em branco.							     //
		//******************************************************************//

		cQuery += "D_E_L_E_T_ <> '*' ) "   

		cQuery += " ORDER BY "+ cOrder

		cQuery := ChangeQuery(cQuery)
											
//		dbSelectArea("SE3")
//		dbCloseArea()
		dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TSE3', .F., .T.)
			
		For ni := 1 to Len(aStru)
			If aStru[ni,2] != 'C'
				TCSetField('TSE3', aStru[ni,1], aStru[ni,2],aStru[ni,3],aStru[ni,4])
			Endif
		Next 
	Else
	
#ENDIF	
		//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
		//?Cria arquivo de trabalho                                     ?
		//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
		cChave := IndexKey()
		cNomArq :=CriaTrab("",.F.)
		IndRegua("SE3",cNomArq,cChave,,cCondicao, OemToAnsi("Selecionando Registros..."))
		nIndex := RetIndex("SE3")
		DbSelectArea("SE3") 
		#IFNDEF TOP
			DbSetIndex(cNomArq+OrdBagExT())
		#ENDIF
		DbSetOrder(nIndex+1)

#IFDEF TOP
	EndIf
#ENDIF	

SetRegua(RecCount())		// Total de Elementos da regua 
DbGotop()   

While !Eof()
	IF lEnd
		@Prow()+1,001 PSAY OemToAnsi("CANCELADO PELO OPERADOR")
		lContinua := .F.
		Exit
	EndIF
	IncRegua()
	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//?Processa condicao do filtro do usuario                       ?
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	If ! Eval(cFiltroUsu)
		Dbskip()
		Loop
	Endif                                      
		
	nAc1 := nAc2 := nAc3 := nAc4 := 0
	lFirstV:= .T.
	cVend  := TSE3->E3_VEND
	
	While !Eof() .AND. TSE3->E3_VEND == cVend
		IncRegua()
		cDocLiq:= ""
		//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
		//?Processa condicao do filtro do usuario                       ?
		//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
		If ! Eval(cFiltroUsu)
			Dbskip()
			Loop
		Endif  
		
		If  Empty(TSE3->E3_FILIAL)
			dbSkip()
			Loop
		Endif
		
		
		If li > 55
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
		EndIF
		
		//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
		//?Seleciona o Codigo do Vendedor e Imprime o seu Nome          ?
		//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸

		dbSelectArea("SE1")
		dbSetOrder(1)
		dbSeek(xFilial()+TSE3->E3_PREFIXO+TSE3->E3_NUM+TSE3->E3_PARCELA+TSE3->E3_TIPO)

		//Daniel: Verificar se o titulo foi compensado por uma NCC (Devolucao). Se sim, desconsidera.
		dbSelectArea("SE5")     
		dbSetOrder(7)
		dbSeek(xFilial("SE5") + SE1->E1_PREFIXO + SE1->E1_NUM + SE1->E1_PARCELA + SE1->E1_TIPO + SE1->E1_CLIENTE + SE1->E1_LOJA + TSE3->E3_SEQ)
		If Found() .and. SE5->E5_MOTBX == "CMP" .AND. "NCC" $ SE5->E5_DOCUMEN                            	// Compensacao de NCC
			dbSelectArea("TSE3")																				// Desconsidera
			dbSkip()   
			Loop
		Else 
            dbSelectArea("SE1")
			IF lFirstV
				dbSelectArea("SA3")
				dbSeek(xFilial()+TSE3->E3_VEND)
				If mv_par12 == 1
					cDescVend := TSE3->E3_VEND + " " + A3_NOME 
					@li, 00 PSAY OemToAnsi("Vendedor : ") + cDescVend //"Vendedor : "
					li+=2
				Else
					@li, 00 PSAY TSE3->E3_VEND
					@li, 07 PSAY A3_NOME 
				EndIf
				dbSelectArea("TSE3")
				lFirstV := .F.
			EndIF
		
			If mv_par12 == 1
				@li, 00 PSAY TSE3->E3_PREFIXO
				@li, 04 PSAY TSE3->E3_NUM
				@li, aColuna[1] PSAY TSE3->E3_PARCELA
				@li, aColuna[2] PSAY TSE3->E3_CODCLI
				@li, aColuna[3] PSAY TSE3->E3_LOJA
			
				dbSelectArea("SA1")
				dbSeek(xFilial()+TSE3->E3_CODCLI+TSE3->E3_LOJA)
				@li, aColuna[4] PSAY IF(mv_par14 == 1,Substr(SA1->A1_NREDUZ,1,35),Substr(SA1->A1_NOME,1,35))
			
				dbSelectArea("TSE3")
				@li, aColuna[5] PSAY TSE3->E3_EMISSAO
			EndIf
		
	
			nVlrTitulo := Round(xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,MV_PAR08,SE1->E1_EMISSAO,nDecs+1),nDecs)
			dVencto    := SE1->E1_VENCTO  
			dEmissao   := SE1->E1_EMISSAO 
			aLiquid	  := {}
			aValLiq		:= {}
			aLiqProp	  	:= {}
			nTotLiq		:= 0
			If mv_par13 == 1 .And. !Empty(SE1->E1_NUMLIQ) .And. FindFunction("FA440LIQSE1")
				cLiquid := SE1->E1_NUMLIQ			
				cDocLiq := SE1->E1_NUMLIQ
				// Obtem os registros que deram origem ao titulo gerado pela liquidacao
				Fa440LiqSe1(SE1->E1_NUMLIQ,@aLiquid,@aValLiq)
				For ny := 1 to Len(aValLiq)
					nTotLiq += aValLiq[ny,2]
				Next
				For ny := 1 to Len(aValLiq)
					aAdd(aLiqProp,(nVlrTitulo/nTotLiq)*aValLiq[ny,2])
				Next
			Endif
			/*
			Nas comissoes geradas por baixa pego a data da emissao da comissao que eh igual a data da baixa do titulo.
			Isto somente dara diferenca nas baixas parciais
			*/	 
		
			If TSE3->E3_BAIEMI == "B"
				dBaixa     := TSE3->E3_EMISSAO
	    	Else
				dBaixa     := SE1->E1_BAIXA
			Endif
			
			If Eof()
				dbSelectArea("SF2")
				dbSetorder(1)
				dbSeek(xFilial()+TSE3->E3_NUM+TSE3->E3_PREFIXO) 
				nVlrTitulo := Round(xMoeda(F2_VALFAT,SF2->F2_MOEDA,mv_par08,SF2->F2_EMISSAO,nDecs+1,SF2->F2_TXMOEDA),nDecs)
				
				dVencto    := " "
				dBaixa     := " "
				
				dEmissao   := SF2->F2_EMISSAO 
				
				If Eof()
					nVlrTitulo := 0
					dbSelectArea("SE1")
					dbSetOrder(1)
					cFilialSE1 := xFilial()
					dbSeek(cFilialSE1+TSE3->E3_PREFIXO+TSE3->E3_NUM)
					While ( !Eof() .And. TSE3->E3_PREFIXO == SE1->E1_PREFIXO .And.;
							TSE3->E3_NUM == SE1->E1_NUM .And.;
							TSE3->E3_FILIAL == cFilialSE1 )
						If ( SE1->E1_TIPO == TSE3->E3_TIPO  .And. ;
							SE1->E1_CLIENTE == TSE3->E3_CODCLI .And. ;
							SE1->E1_LOJA == TSE3->E3_LOJA )
							nVlrTitulo += Round(xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,MV_PAR08,SE1->E1_EMISSAO,nDecs+1),nDecs)
							dVencto    := " "
							dBaixa     := " "
						EndIf
						dbSelectArea("SE1")
						dbSkip()
					EndDo
				EndIf
			Endif
	
			//Preciso destes valores para pasar como parametro na funcao TM(), e como 
			//usando a xmoeda direto na impressao afetaria a performance (deveria executar
			//duas vezes, uma para imprimir e outra para pasar para a picture), elas devem]
			//ser inicializadas aqui. Bruno.
	
			nBasePrt:=	Round(xMoeda(TSE3->E3_BASE ,1,MV_PAR08,dEmissao,nDecs+1),nDecs)
			nComPrt :=	Round(xMoeda(TSE3->E3_COMIS,1,MV_PAR08,dEmissao,nDecs+1),nDecs)
	
			If nBasePrt < 0 .And. nComPrt < 0
				nVlrTitulo := nVlrTitulo * -1
			Endif	
		
			dbSelectArea("TSE3")
			
			If mv_par12 == 1
				@ li,aColuna[6]  PSAY dVencto
				@ li,aColuna[7]  PSAY dBaixa
				@ li,aColuna[8]  PSAY TSE3->E3_DATA
				@ li,aColuna[9]  PSAY TSE3->E3_PEDIDO	Picture "@!"
				@ li,aColuna[10] PSAY nVlrTitulo		Picture tm(nVlrTitulo,14,nDecs)
				@ li,aColuna[11] PSAY nBasePrt 			Picture tm(nBasePrt,14,nDecs)
				If cPaisLoc<>"BRA"
					@ li,aColuna[12] PSAY TSE3->E3_PORC		Picture tm(SE3->E3_PORC,6,nDecPorc)
				Else
					@ li,aColuna[12] PSAY TSE3->E3_PORC		Picture tm(SE3->E3_PORC,6)
				Endif
				@ li,aColuna[13] PSAY nComPrt			Picture tm(nComPrt,14,nDecs)
				@ li,aColuna[14] PSAY TSE3->E3_BAIEMI
	
				If ( TSE3->E3_AJUSTE == "S" .And. MV_PAR07==1)
					@ li,aColuna[15] PSAY "AJUSTE "
				EndIf
				li++
				// Imprime titulos que deram origem ao titulo gerado por liquidacao
				If mv_par13 == 1
					For nI := 1 To Len(aLiquid)
						If li > 55
							cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
						EndIF
						If nI == 1
							@ ++li, 0 PSAY __PrtThinLine()
							@ ++li, 0 PSAY "Detalhes : Titulos de origem da liquida豫o " +SE1->E1_NUMLIQ // "Detalhes : Titulos de origem da liquida豫o "
							@ ++li,10 PSAY "Prefixo    Numero          Parc    Tipo    Cliente   Loja    Nome                                       Valor Titulo      Data Liq.         Valor Liquida豫o      Valor Base Liq."
	//         Prefixo    Numero          Parc    Tipo    Cliente   Loja    Nome                                       Valor Titulo      Data Liq.         Valor Liquida豫o      Valor Base Liq.
	//         XXX        XXXXXXXXXXXX    XXX     XXXX    XXXXXXXXXXXXXX    XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  999999999999999     99/99/9999          999999999999999      999999999999999 
	   					@ ++li, 0 PSAY __PrtThinLine()
							li++
						Endif
						cDocLiq  := SE1->E1_NUMLIQ
						SE1->(MsGoto(aLiquid[nI]))
						SA1->(MsSeek(xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA))
						@li,  10 PSAY SE1->E1_PREFIXO
						@li,  21 PSAY SE1->E1_NUM
						@li,  37 PSAY SE1->E1_PARCELA
						@li,  45 PSAY SE1->E1_TIPO
						@li,  53 PSAY SE1->E1_CLIENTE
						@li,  64 PSAY SE1->E1_LOJA
						@li,  71 PSAY IF(mv_par14 == 1,Substr(SA1->A1_NREDUZ,1,35),Substr(SA1->A1_NOME,1,35))
						@li, 111 PSAY SE1->E1_VALOR PICTURE Tm(SE1->E1_VALOR,15,nDecs)
						@li, 132 PSAY aValLiq[nI,1] 
						@li, 151 PSAY aValLiq[nI,2] PICTURE Tm(SE1->E1_VALOR,15,nDecs)
						@li, 172 PSAY aLiqProp[nI] PICTURE Tm(SE1->E1_VALOR,15,nDecs)
						li++
					Next
					// Imprime o separador da ultima linha
					If Len(aLiquid) >= 1
						@ li++, 0 PSAY __PrtThinLine()
					Endif
				Endif	
			EndIf
			nAc1 += nBasePrt
			nAc2 += nComPrt
			If cTitulo <> TSE3->E3_PREFIXO+TSE3->E3_NUM+TSE3->E3_PARCELA+TSE3->E3_TIPO+TSE3->E3_VEND+TSE3->E3_CODCLI+TSE3->E3_LOJA  .And. Empty(cDocLiq)
				nAc3   += nVlrTitulo
				cTitulo:= TSE3->E3_PREFIXO+TSE3->E3_NUM+TSE3->E3_PARCELA+TSE3->E3_TIPO+TSE3->E3_VEND+TSE3->E3_CODCLI+TSE3->E3_LOJA
				cDocLiq:= ""
			EndIf
			
		Endif
		
		dbSelectArea("TSE3")
		dbSkip()
	EndDo
	
	If mv_par12 == 1
		li++
	
		If li > 55
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
		EndIF
		@ li, 00  PSAY OemToAnsi("TOTAL DO VENDEDOR --> ")+cDescVend  //"TOTAL DO VENDEDOR --> "
		@ li,aColuna[10]-1  PSAY nAc3 	PicTure tm(nAc3,15,nDecs)
		@ li,aColuna[11]-1  PSAY nAc1 	PicTure tm(nAc1,15,nDecs)
	
		If nAc1 != 0
			If cPaisLoc=="BRA"
				@ li, aColuna[12] PSAY (nAc2/nAc1)*100   PicTure "999.99"
			Else
				@ li, aColuna[12] PSAY NoRound((nAc2/nAc1)*100)   PicTure "999.99"
			Endif
		Endif
	
		@ li, aColuna[13]-1  PSAY nAc2 PicTure tm(nAc2,15,nDecs)
		li++                                   
		
		
		If MV_PAR09 == 1   // Lista comissoes zeradas
	
			li++
			@ li++, 0 PSAY __PrtThinLine()
			li++
			@li, 00 PSAY OemToAnsi("Comissoes zeradas do vendedor : ") + cDescVend
			li+=2
			
			dbSelectArea("SE1")
			dbSetOrder(7)
			dbSeek(xFilial("SE1") + Dtos(MV_PAR02),.T.)
			do While !Eof() .and. SE1->E1_FILIAL == xFilial("SE1") .and. SE1->E1_VENCREA <= MV_PAR03
				
				If SE1->E1_VEND1 <> cVend .or. SE1->E1_COMIS1 <> 0 .or. SE1->E1_TIPO <> "NF "                        	// Rejeita registro se a comissao for diferente de zero
					dbSkip()
					Loop
				Endif 
				
				If Posicione("SE3",1,xFilial("SE3") + SE1->E1_PREFIXO + SE1->E1_NUM + SE1->E1_PARCELA,"E3_BASE") <> 0    	//Rejeita registro se ja estiver na SE3
					dbSkip()
					Loop
				Endif

				If li > 55
					cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
				EndIF
				
				@li, 00 PSAY SE1->E1_PREFIXO
				@li, 04 PSAY SE1->E1_NUM
				@li, aColuna[1] PSAY SE1->E1_PARCELA
				@li, aColuna[2] PSAY SE1->E1_CLIENTE
				@li, aColuna[3] PSAY SE1->E1_LOJA
				
				dbSelectArea("SA1")
				dbSeek(xFilial()+SE1->E1_CLIENTE + SE1->E1_LOJA)
				@li, aColuna[4] PSAY IF(mv_par14 == 1,Substr(SA1->A1_NREDUZ,1,35),Substr(SA1->A1_NOME,1,35))
				li++
				dbSelectArea("SE1")
				dbSkip()
			Enddo
		Endif
		
		If mv_par10 > 0 .And. (nAc2 * mv_par10 / 100) > nVLRET //IR
			@ li, 00  PSAY OemToAnsi("TOTAL DO IR      -->")  //"TOTAL DO IR       --> "
			nAc4 += (nAc2 * mv_par10 / 100)				
			@ li, aColuna[13]-1  PSAY nAc4 PicTure tm(nAc2 * mv_par10 / 100,15,nDecs)
			li ++
			@ li, 00  PSAY OemToAnsi("TOTAL (-) IR     -->")  //"TOTAL (-) IR      --> "
			@ li, aColuna[13]-1 PSAY nAc2 - nAc4 PicTure tm(nAc2,15,nDecs)
			li ++
		EndIf
	
		@ li, 00  PSAY __PrtThinLine()

		If mv_par11 == 1  // Quebra pagina por vendedor (padrao)
			li := 60  
		Else
		   li+= 2
		Endif
	Else
		If li > 55
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
		EndIF
		@ li,048  PSAY nAc3 	PicTure tm(nAc3,15,nDecs)
		@ li,065  PSAY nAc1 	PicTure tm(nAc1,15,nDecs)
		If nAc1 != 0
			If cPaisLoc=="BRA"
				@ li, 081 PSAY (nAc2/nAc1)*100   PicTure "999.99"
			Else
				@ li, 081 PSAY NoRound((nAc2/nAc1)*100)   PicTure "999.99"
			Endif
		Endif
		@ li, 089  PSAY nAc2 PicTure tm(nAc2,15,nDecs)
		If mv_par10 > 0 .And. (nAc2 * mv_par10 / 100) > nVLRET //IR
			nAc4 += (nAc2 * mv_par10 / 100)
			@ li, 105  PSAY nAc4 PicTure tm(nAc2 * mv_par10 / 100,15,nDecs)
			@ li, 121 PSAY nAc2 - nAc4 PicTure tm(nAc2,15,nDecs)
		EndIf
		li ++
	EndIf
	
	dbSelectArea("TSE3")
	nAg1 += nAc1
	nAg2 += nAc2
 	nAg3 += nAc3
 	nAg4 += nAc4
EndDo

If (nAg1+nAg2+nAg3+nAg4) != 0
	If li > 55
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
	Endif

	If mv_par12 == 1
		@li,  00 PSAY OemToAnsi("TOTAL GERAL      -->")  //"TOTAL  GERAL      --> "
		@li, aColuna[10]-1 PSAY nAg3	Picture tm(nAg3,15,nDecs)
		@li, aColuna[11]-1 PSAY nAg1	Picture tm(nAg1,15,nDecs)
		If cPaisLoc=="BRA"
			@li, aColuna[12] PSAY (nAg2/nAg1)*100 Picture "999.99"
		Else
			@li, aColuna[12] PSAY NoRound((nAg2/nAg1)*100) Picture "999.99"
		Endif
		@li, aColuna[13]-1 PSAY nAg2 Picture tm(nAg2,15,nDecs)
		If mv_par10 > 0 .And. (nAg2 * mv_par10 / 100) > nVLRET //IR
			li ++
			@ li, 00  PSAY OemToAnsi("TOTAL DO IR       -->")  //"TOTAL DO IR       --> "
			@ li, 175  PSAY nAg4 PicTure tm((nAg2 * mv_par10 / 100),15,nDecs)
			li ++
			@ li, 00  PSAY OemToAnsi("TOTAL (0) IR       -->")  //"TOTAL (-) IR       --> "
			@ li, 175  PSAY nAg2 - nAg4 Picture tm(nAg2,15,nDecs)
		EndIf
	Else
		@li,000  PSAY __PrtThinLine()
		li ++
		@li,000 PSAY OemToAnsi("TOTAL GERAL     -->")  //"TOTAL  GERAL      --> "
		@li,048 PSAY nAg3	Picture tm(nAg3,15,nDecs)
		@li,065 PSAY nAg1	Picture tm(nAg1,15,nDecs)
		If cPaisLoc=="BRA"
			@li,081 PSAY (nAg2/nAg1)*100 Picture "999.99"
		Else
			@li,081 PSAY NoRound((nAg2/nAg1)*100) Picture "999.99"
		Endif
		@li,089 PSAY nAg2 Picture tm(nAg2,15,nDecs)
		If mv_par10 > 0 .And. (nAg2 * mv_par10 / 100) > nVLRET //IR
			@ li,105  PSAY nAg4 PicTure tm((nAg2 * mv_par10 / 100),15,nDecs)
			@ li,121  PSAY nAg2 - nAg4 Picture tm(nAg2,15,nDecs)
		EndIf
	EndIf
	roda(cbcont,cbtxt,"G")
EndIF
    
#IFDEF TOP
	If TcSrvType() != "AS/400"
  		dbSelectArea("TSE3")
		DbCloseArea()
		chkfile("SE3")
	Else	
#ENDIF
		fErase(cNomArq+OrdBagExt())
#IFDEF TOP
	Endif
#ENDIF

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//?Restaura a integridade dos dados                             ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
DbSelectArea("SE3")
RetIndex("SE3")
DbSetOrder(2)
dbClearFilter()

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//?Se em disco, desvia para Spool                               ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
If aReturn[5] = 1
	Set Printer To
	dbCommitAll()
	ourspool(wnrel)
Endif

MS_FLUSH()

