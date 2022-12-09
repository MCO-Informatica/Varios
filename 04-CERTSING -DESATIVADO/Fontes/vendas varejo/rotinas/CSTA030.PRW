
#INCLUDE "totvs.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  |CSTA030   º Autor ³ Renato Ruy         º Data ³  02/09/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Importar dados para tabela de preço através de um arquivo. º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Certisign                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function CSTA030()

Local aPergs := {}
Local aRet 	 := {}
Local cMsg 	 := ""
Local lRet 
Local aAreaSX1 := SX1->( GetArea() )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


aAdd( aPergs ,{1,"Código da Tabela : "	,DA0->DA0_CODTAB,"@!"				,'.T.',"SZF",'.T.',80,.F.})
aAdd( aPergs ,{6,"Buscar arquivo"		,Space(70)		,"","","",50,.F.,""})

If ParamBox(aPergs ,"Importar Tabela",aRet)
	CSTA030R(aRet[1],aRet[2])
Endif 

// Restaura grupo de perguntas
RestArea( aAreaSX1 )     

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  |CSTA030R  º Autor ³ Renato Ruy         º Data ³  02/09/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Gerar CSV com os dados da tabela selecionada.     		  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Certisign                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function CSTA030R(cCodTab,cArquivo)

Local cItens  := ""
Local cLinha  := ""
Local cCodItem:= ""
Local aDados  := {}
Local nConta  := 0
Local cCodComb:= ""
Local nPrcComb:= 0
Local nRenComb:= 0

Private aCampos := {}

Default cCodtab := ""

//Renato Ruy - 13/10/2016
//Chama funcao para montar cabeçalho.
CTSA030C()

//Cria cabeçalho do CSV exportado.
For nCab := 1 to Len(aCampos)

	SX3->( dbSetOrder(2) )
	If SX3->( dbSeek( aCampos[nCab] ) )
		cItens += SX3->X3_TITULO+";"
	EndIf

Next

//Quebra linha
cItens += CRLF

//busca o arquivo que sera utilizado para leitura.
FT_FUSE(cArquivo)

//Enquanto nao é fim de arquivo, efetua leitura
While !FT_FEOF()

	nConta += 1

	//Leio a linha e gero array com os dados
	cLinha	:= alltrim(FT_FREADLN())
	
	//Faço tratamento para não gerar erro nas colunas
	While ";;" $ cLinha
		cLinha	:= StrTran(cLinha,";;",";-;")
	EndDo
	
	aDados 	:= StrTokArr(cLinha,";")
	
	//Verifico se falta campo
	If Len(aDados) != Len(aCampos) .And. nConta == 1
   		MsgInfo("Por favor verifique o arquivo, o formato não é igual ao exportado!") 
   		Return		
	EndIf
	
	//Fecha o arquivo se estiver aberto e se ja tem a sequencia, utiliza a mesma.
	If Empty(cCodItem)
		If Select("TMPITEM") > 0
			DbSelectArea("TMPITEM")
			TMPITEM->(DbCloseArea())
		Endif
		
		Beginsql Alias "TMPITEM"
		
			SELECT MAX(DA1_ITEM) ITEM FROM %Table:DA1%
			WHERE
			DA1_FILIAL = ' ' AND
			DA1_CODTAB = %EXP:cCodTab% AND
			D_E_L_E_T_ = ' '
		
		Endsql
		
		cCodItem := TMPITEM->ITEM
		
	EndIf
	
	//Se não é o cabeçalho, se posiciona e atualiza.
	If nConta > 1
	
		//Renato Ruy - 17/10/2016
		//Busca ultimo item da tabela de preço.
		cCodItem := Soma1(cCodItem)
		
		//Se posiciona na tabela de combo
		If AllTrim(aDados[Ascan( aCampos, { |x| AllTrim(x)=="DA1_CODCOB" } )]) != "-" .And. !Empty(AllTrim(aDados[Ascan( aCampos, { |x| AllTrim(x)=="DA1_CODCOB" } )])) 
			cCodComb := PadL(AllTrim(aDados[Ascan( aCampos, { |x| AllTrim(x)=="DA1_CODCOB" } )]),15,"0")
		Else
			cCodComb := ""		
		EndIf
		nPrcComb := 0
		nRenComb := 0
		
		SZJ->(DbSetOrder(1))
		If SZJ->(DbSeek(xFilial("SZJ")+cCodComb)) .And. !Empty(cCodComb)
		    
		    //Faz um laço para aglutinar os valores.
			While !SZJ->(EOF()) .And. SZJ->ZJ_COMBO == cCodComb
				
				nPrcComb += SZJ->ZJ_PRETAB
				nRenComb += SZJ->ZJ_PRERENO
				
				SZJ->(DbSkip())	
			Enddo
		
		EndIf
		
		//Renato Ruy - 26/12/16
		//Garantir que os produtos importados foram desativados.
		DA1->(DbSetOrder(1))
		If DA1->(DbSeek(xFilial("DA1")+cCodtab+aDados[Ascan( aCampos, { |x| AllTrim(x)=="DA1_CODPRO" } )]))
			While AllTrim(DA1->DA1_CODPRO) == AllTrim(aDados[Ascan( aCampos, { |x| AllTrim(x)=="DA1_CODPRO" } )])
				If DA1->DA1_ATIVO  == "1" .And. AllTrim(DA1->DA1_CODGAR) == AllTrim(aDados[Ascan( aCampos, { |x| AllTrim(x)=="DA1_CODGAR" } )])
					DA1->(Reclock("DA1",.F.))
						DA1->DA1_ATIVO  := "2"
					DA1->(Msunlock())
				Endif
				DA1->(DbSkip())
			Enddo
		EndIf
	
		If DA1->(Reclock("DA1",.T.))
			
			//Campos caractere.
			DA1->DA1_FILIAL := xFilial("DA1")
			DA1->DA1_CODTAB := cCodtab
			DA1->DA1_ITEM   := cCodItem
			DA1->DA1_CODPRO := Iif(aDados[Ascan( aCampos, { |x| AllTrim(x)=="DA1_CODPRO" } )]=="-","",aDados[Ascan( aCampos, { |x| AllTrim(x)=="DA1_CODPRO" } )])
			//DA1->DA1_DESCRI := Iif(aDados[Ascan( aCampos, { |x| AllTrim(x)=="DA1_DESCRI" } )]=="-","",aDados[Ascan( aCampos, { |x| AllTrim(x)=="DA1_DESCRI" } )])
			DA1->DA1_CODCOB := cCodComb
			DA1->DA1_CODGAR := Iif(aDados[Ascan( aCampos, { |x| AllTrim(x)=="DA1_CODGAR" } )]=="-","",aDados[Ascan( aCampos, { |x| AllTrim(x)=="DA1_CODGAR" } )])
			DA1->DA1_DESGAR := Iif(aDados[Ascan( aCampos, { |x| AllTrim(x)=="DA1_DESGAR" } )]=="-","",aDados[Ascan( aCampos, { |x| AllTrim(x)=="DA1_DESGAR" } )])
			DA1->DA1_ATIVO  := CSTA030V(cCodtab, DA1->DA1_CODGAR)
			DA1->DA1_ESTADO := Iif(aDados[Ascan( aCampos, { |x| AllTrim(x)=="DA1_ESTADO" } )]=="-","",aDados[Ascan( aCampos, { |x| AllTrim(x)=="DA1_ESTADO" } )])
			DA1->DA1_TPOPER := Iif(aDados[Ascan( aCampos, { |x| AllTrim(x)=="DA1_TPOPER" } )]=="-","",aDados[Ascan( aCampos, { |x| AllTrim(x)=="DA1_TPOPER" } )])
			DA1->DA1_INDLOT := Iif(aDados[Ascan( aCampos, { |x| AllTrim(x)=="DA1_INDLOT" } )]=="-","",aDados[Ascan( aCampos, { |x| AllTrim(x)=="DA1_INDLOT" } )])
			DA1->DA1_GRUPO  := Iif(aDados[Ascan( aCampos, { |x| AllTrim(x)=="DA1_GRUPO"  } )]=="-","",aDados[Ascan( aCampos, { |x| AllTrim(x)=="DA1_GRUPO"  } )])
			DA1->DA1_REFGRD := Iif(aDados[Ascan( aCampos, { |x| AllTrim(x)=="DA1_REFGRD" } )]=="-","",aDados[Ascan( aCampos, { |x| AllTrim(x)=="DA1_REFGRD" } )])
			DA1->DA1_XDSSIT := Iif(aDados[Ascan( aCampos, { |x| AllTrim(x)=="DA1_XDSSIT" } )]=="-","",aDados[Ascan( aCampos, { |x| AllTrim(x)=="DA1_XDSSIT" } )])
			DA1->DA1_ITEMGR := Iif(aDados[Ascan( aCampos, { |x| AllTrim(x)=="DA1_ITEMGR" } )]=="-","",aDados[Ascan( aCampos, { |x| AllTrim(x)=="DA1_ITEMGR" } )])
			DA1->DA1_DESAMI := Iif(aDados[Ascan( aCampos, { |x| AllTrim(x)=="DA1_DESAMI" } )]=="-","",aDados[Ascan( aCampos, { |x| AllTrim(x)=="DA1_DESAMI" } )])

			//Campos Data
			DA1->DA1_DATVIG := dDatabase//data inicio vigencia
			
			//Campos numerico
			DA1->DA1_PRCVEN := Iif(!Empty(cCodComb),nPrcComb,Val(StrTran(StrTran(aDados[Ascan( aCampos, { |x| AllTrim(x)=="DA1_PRCVEN" } )],".",""),",",".")))
			DA1->DA1_VLRDES := Val(StrTran(StrTran(aDados[Ascan( aCampos, { |x| AllTrim(x)=="DA1_VLRDES" } )],".",""),",","."))
			DA1->DA1_PERDES := Val(StrTran(StrTran(aDados[Ascan( aCampos, { |x| AllTrim(x)=="DA1_PERDES" } )],".",""),",","."))
			DA1->DA1_XPRCRE := Iif(!Empty(cCodComb),nRenComb,Val(StrTran(StrTran(aDados[Ascan( aCampos, { |x| AllTrim(x)=="DA1_XPRCRE" } )],".",""),",",".")))
			DA1->DA1_FRETE  := Val(StrTran(StrTran(aDados[Ascan( aCampos, { |x| AllTrim(x)=="DA1_FRETE"  } )],".",""),",","."))
			DA1->DA1_QTDLOT := Val(StrTran(StrTran(aDados[Ascan( aCampos, { |x| AllTrim(x)=="DA1_QTDLOT" } )],".",""),",","."))
			DA1->DA1_MOEDA  := Val(StrTran(StrTran(aDados[Ascan( aCampos, { |x| AllTrim(x)=="DA1_MOEDA"  } )],".",""),",","."))
			DA1->DA1_PRCMAX := Val(StrTran(StrTran(aDados[Ascan( aCampos, { |x| AllTrim(x)=="DA1_PRCMAX" } )],".",""),",","."))
			DA1->DA1_NUMPAR := Val(StrTran(StrTran(aDados[Ascan( aCampos, { |x| AllTrim(x)=="DA1_NUMPAR" } )],".",""),",","."))
			
			DA1->(MsUnlock()) 
		Endif

		
	Endif

	//Pulo para a próxima linha.
	FT_FSKIP()
Enddo

If nConta > 1
	MsgInfo("As informações foram importadas!","Tabela de Preço")
Else
	MsgInfo("Não foram importadas informações!","Tabela de Preço")
EndIf

Return

//Renato Ruy - 14/10/2016
//Retorna um array com o campos utilizados
Static Function CTSA030C()

AADD(aCampos,"DA1_CODTAB")
AADD(aCampos,"DA1_ITEM  ")
AADD(aCampos,"DA1_CODPRO")
//AADD(aCampos,"DA1_DESCRI")
AADD(aCampos,"DA1_DESAMI")
AADD(aCampos,"DA1_CODCOB")
AADD(aCampos,"DA1_XDSSIT")
AADD(aCampos,"DA1_PRCVEN")
AADD(aCampos,"DA1_CODGAR")
AADD(aCampos,"DA1_DESGAR")
AADD(aCampos,"DA1_VLRDES")
AADD(aCampos,"DA1_PERDES")
AADD(aCampos,"DA1_ATIVO ")
AADD(aCampos,"DA1_XPRCRE")
AADD(aCampos,"DA1_FRETE ")
AADD(aCampos,"DA1_ESTADO")
AADD(aCampos,"DA1_TPOPER")
AADD(aCampos,"DA1_QTDLOT")
AADD(aCampos,"DA1_INDLOT")
AADD(aCampos,"DA1_MOEDA ")
AADD(aCampos,"DA1_DATVIG")
AADD(aCampos,"DA1_GRUPO ")
AADD(aCampos,"DA1_REFGRD")
AADD(aCampos,"DA1_PRCMAX")
AADD(aCampos,"DA1_ITEMGR")
AADD(aCampos,"DA1_NUMPAR")

Return

//Renato Ruy - 23/04/2018
//Validação para não permitir item duplicado ativo para tabelas do mesmo grupo.

Static Function CSTA030V(cCodTab, cCodGar)

Local cRet 	 := "1"
Local cCodTabF := " "
Local cQuery	 := " "

Default cCodTab := " "
Default cCodGar := " "

	//Renato Ruy - 31/05/2016
	//Consultar se o produto pode ser ativado, caso nao exista vinculo em outro grupo
	cQuery := " SELECT Z3_CODENT, Z3_CODTAB FROM " + RetSqlName("SZ3")
	cQuery += " WHERE "
	cQuery += " Z3_FILIAL = '"+xFilial("SZ3")+"' AND "
	cQuery += " Z3_CODTAB LIKE '%"+cCodTab+"%' AND "
	cQuery += " Z3_TIPENT IN ('2','5') AND "
	cQuery += " D_E_L_E_T_ = ' ' "
	
	cQuery := ChangeQuery(cQuery)
	If Select("TMPGRU") > 0
		DbSelectArea("TMPGRU")
		TMPGRU->(DbCloseArea())
	EndIf
	dbUseArea(.T., 'TOPCONN', TCGenQry(,,cQuery),"TMPGRU", .F., .T.) 
	
	While !TMPGRU->(EOF())
	    
		cCodTabF := "% " + FormatIn(StrTran(StrTran(RTrim(TMPGRU->Z3_CODTAB),RTrim(cCodTab),""),",,",","),",") + " %"
		
		//Verifica se o item ja esta ativo em outra tabela.
		If Select("TMPDUP") > 0
			DbSelectArea("TMPDUP")
			TMPDUP->(DbCloseArea())
		EndIf
		BeginSql Alias "TMPDUP"
			SELECT MAX(DA1_CODTAB) CODTAB, COUNT(*) CONTA FROM %TABLE:DA1%
			WHERE
			DA1_FILIAL = %XFILIAL:DA1% AND
			DA1_CODGAR = %EXP:cCodGar% AND
			DA1_ATIVO = '1' AND
			DA1_CODTAB IN %EXP:cCodTabF% AND
			%NOTDEL%
		Endsql
		
		If TMPDUP->CONTA > 0
			Alert("O produto "+AllTrim(cCodGar)+" está vinculado na tabela: "+TMPDUP->CODTAB+" e vinculado no grupo: "+TMPGRU->Z3_CODENT+" o mesmo será importado, mas permanecera inativo!")
			cRet := "2"
			Exit
		Endif
		
		TMPGRU->(DbSkip())
	Enddo

Return cRet