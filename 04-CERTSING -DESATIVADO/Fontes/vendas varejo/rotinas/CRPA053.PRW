
#INCLUDE "totvs.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  |CRPA053   º Autor ³ Renato Ruy         º Data ³  02/09/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Exportar dados da do cadastro De-Para em um arquivo CSV.   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Certisign                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function CRPA053()

Local aPergs := {}
Local aRet 	 := {}
Local cMsg 	 := ""
Local lRet 
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


aAdd( aPergs ,{2,"Somente Vinculado" 	,"N"			, {"S=Sim", "N=Não"}, 50,'.T.',.T.}) 
aAdd( aPergs ,{6,"Gravar arquivo"		,Space(70)		,"","","",50,.F.,""}) 

If ParamBox(aPergs ,"Exportar Produtos",aRet)
	CRPA053R(aRet[1],aRet[2])
Endif 

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  |CRPA053R  º Autor ³ Renato Ruy         º Data ³  02/09/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Gerar CSV com os dados da tabela selecionada.     		  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Certisign                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function CRPA053R(cAtivo,cArquivo)

Local cItens  := ""
Local lAtivo  := .T. 
Local nHdl	  := 0
Local lDesat  := .F.
Local aAreaPA8:= PA8->(GetArea())

Private aCampos := {}

//Renato Ruy - 13/10/2016
//Chama funcao para montar cabeçalho.
CTSA020C()

//Cria o arquivo utilizado para gravação
nHdl    := fCreate(cArquivo)

//Cria cabeçalho do CSV exportado.
For nCab := 1 to Len(aCampos)

	SX3->( dbSetOrder(2) )
	If SX3->( dbSeek( aCampos[nCab] ) )
		cItens += SX3->X3_TITULO+";"
	EndIf

Next

//Quebra linha
cItens += CRLF

//Se posiciona na tabela de preços selecionada pelo usuario
PA8->( dbSetOrder(1) )
	
//Enquanto e a mesma tabela grava no CSV.
While !PA8->(EOF())
	
	//Validação de produto ativo na tabela.
	lAtivo := Iif(Empty(PA8->PA8_CATPRO),.F.,.T.)
	
	//Retorna conforme o parametro. 
	If lAtivo
		//Busca campos e alimenta os dados.
		For nCab := 1 to Len(aCampos)
			If ValType(PA8->&(aCampos[nCab])) == "N"
				cItens += Transform(PA8->&(aCampos[nCab]),"@E 999,999,999,999.99") + ";"
			Elseif ValType(PA8->&(aCampos[nCab])) == "D"
				cItens += DtoC(PA8->&(aCampos[nCab])) + ";"
			Else
				cItens += PA8->&(aCampos[nCab]) + ";"
			EndIf
		Next
		
		//Quebra linha
		cItens += CRLF
	Endif
    
	PA8->(DbSkip())
Enddo

//Grava os dados no arquivo
If nHdl != -1
	fWrite(nHdl,cItens)
	MsgInfo("O arquivo foi gerado no caminho: " + AllTrim(cArquivo))
	
	//Fecha o arquivo gerado.
	fClose(nHdl)
Else
	MsgInfo("Não foi possível gerar o arquivo!")
Endif

RestArea(aAreaPA8)
Return

//Renato Ruy - 14/10/2016
//Retorna um array com o campos utilizados
Static Function CTSA020C()

AADD(aCampos,"PA8_CODBPG")
AADD(aCampos,"PA8_DESBPG")
AADD(aCampos,"PA8_CODMP8")
AADD(aCampos,"PA8_DESMP8")
AADD(aCampos,"PA8_CLAPRO")
AADD(aCampos,"PA8_CATPRO")
AADD(aCampos,"PA8_CONCER")
AADD(aCampos,"PA8_VLSOFT")
AADD(aCampos,"PA8_PRDCON")
AADD(aCampos,"PA8_VALSW")
AADD(aCampos,"PA8_VALHW")
AADD(aCampos,"PA8_IMAGEM")

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  |CRPA053I  º Autor ³ Renato Ruy         º Data ³  02/09/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Importar dados dos produtos 									º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Certisign                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function CRPA053I()

Local aPergs := {}
Local aRet 	 := {}
Local cMsg 	 := ""
Local lRet 
Local aAreaSX1 := SX1->( GetArea() )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


aAdd( aPergs ,{6,"Buscar arquivo"		,Space(70)		,"","","",50,.F.,""})

If ParamBox(aPergs ,"Importar Tabela",aRet)
	CRPA053W(aRet[1])
Endif 

// Restaura grupo de perguntas
RestArea( aAreaSX1 )     

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  |CRPA053W  º Autor ³ Renato Ruy         º Data ³  02/09/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Gerar CSV com os dados da tabela selecionada.     		  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Certisign                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function CRPA053W(cArquivo)

Local cItens  := ""
Local cLinha  := ""
Local cCodItem:= ""
Local aDados  := {}
Local nConta  := 0

Private aCampos := {}

//Renato Ruy - 13/10/2016
//Chama funcao para montar cabeçalho.
CTSA020C()

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
	
	PA8->(DbSetOrder(1))
	If PA8->(DbSeek(xFilial("PA8")+AllTrim(aDados[Ascan( aCampos, { |x| AllTrim(x)=="PA8_CODBPG" } )])))
		If PA8->(Reclock("PA8",.F.))
		
			//PA8->PA8_CODBPG := aDados[Ascan( aCampos, { |x| AllTrim(x)=="PA8_CODBPG" } )]
			//PA8->PA8_DESBPG := aDados[Ascan( aCampos, { |x| AllTrim(x)=="PA8_DESBPG" } )]
			//PA8->PA8_CODMP8 := aDados[Ascan( aCampos, { |x| AllTrim(x)=="PA8_CODMP8" } )]
			//PA8->PA8_DESMP8 := aDados[Ascan( aCampos, { |x| AllTrim(x)=="PA8_DESMP8" } )]
			PA8->PA8_CLAPRO := aDados[Ascan( aCampos, { |x| AllTrim(x)=="PA8_CLAPRO" } )]
			PA8->PA8_CATPRO := PadL(AllTrim(aDados[Ascan( aCampos, { |x| AllTrim(x)=="PA8_CATPRO" } )]),2,"0")
			PA8->PA8_CONCER := aDados[Ascan( aCampos, { |x| AllTrim(x)=="PA8_CONCER" } )]
			PA8->PA8_VLSOFT := Val(StrTran(StrTran(aDados[Ascan( aCampos, { |x| AllTrim(x)=="PA8_VLSOFT" } )],".",""),",","."))
			PA8->PA8_PRDCON := aDados[Ascan( aCampos, { |x| AllTrim(x)=="PA8_PRDCON" } )]
			PA8->PA8_VALSW  := Val(StrTran(StrTran(aDados[Ascan( aCampos, { |x| AllTrim(x)=="PA8_VALSW" } )],".",""),",","."))
			PA8->PA8_VALHW  := Val(StrTran(StrTran(aDados[Ascan( aCampos, { |x| AllTrim(x)=="PA8_VALHW" } )],".",""),",","."))
			PA8->PA8_IMAGEM := aDados[Ascan( aCampos, { |x| AllTrim(x)=="PA8_IMAGEM" } )] 		
			PA8->(MsUnlock()) 
		Endif
	Endif

	//Pulo para a próxima linha.
	FT_FSKIP()
Enddo

If nConta > 1
	MsgInfo("As informações foram importadas!","Cadastro de Produtos Site")
Else
	MsgInfo("Não foram importadas informações!","Cadastro de Produtos Site")
EndIf

Return