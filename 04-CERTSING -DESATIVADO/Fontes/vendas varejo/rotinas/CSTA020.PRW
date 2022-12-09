
#INCLUDE "totvs.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  |CSTA020   º Autor ³ Renato Ruy         º Data ³  02/09/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Exportar dados da tabela de preço para um arquivo CSV.     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Certisign                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function CSTA020()

Local aPergs := {}
Local aRet 	 := {}
Local cMsg 	 := ""
Local lRet 
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


aAdd( aPergs ,{1,"Código da Tabela : "	,DA0->DA0_CODTAB,"@!"				,'.T.',"SZF",'.T.',80,.F.})
aAdd( aPergs ,{2,"Somente Ativo"	   	,"N"			, {"S=Sim", "N=Não"}, 50,'.T.',.T.}) 
aAdd( aPergs ,{6,"Gravar arquivo"		,Space(70)		,"","","",50,.F.,""})
aAdd( aPergs ,{2,"Desativa Produtos"   	,"N"			, {"S=Sim", "N=Não"}, 50,'.T.',.T.}) 

If ParamBox(aPergs ,"Exportar Tabelas",aRet)
	CSTA020R(aRet[1],aRet[2],aRet[3],aRet[4])
Endif 

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  |CSTA020R  º Autor ³ Renato Ruy         º Data ³  02/09/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Gerar CSV com os dados da tabela selecionada.     		  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Certisign                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function CSTA020R(cCodTab,cAtivo,cArquivo,cDesat)

Local cItens  := ""
Local lAtivo  := .T. 
Local nHdl	  := 0
Local lDesat  := .F.

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
DA1->( dbSetOrder(1) )
If DA1->( dbSeek( xFilial("DA1") + cCodTab ) )

	 
	
	//Enquanto e a mesma tabela grava no CSV.
	While !DA1->(EOF()) .And. cCodTab == DA1->DA1_CODTAB
		
		//Validação de produto ativo na tabela.
		lAtivo := Iif(cAtivo=="N" .Or. DA1->DA1_ATIVO == "1",.T.,.F.)
		
		//Retorna conforme o parametro. 
		If lAtivo
			//Busca campos e alimenta os dados.
			For nCab := 1 to Len(aCampos)
				If ValType(DA1->&(aCampos[nCab])) == "N"
					cItens += Transform(DA1->&(aCampos[nCab]),"@E 999,999,999,999.99") + ";"
				Elseif ValType(DA1->&(aCampos[nCab])) == "D"
					cItens += DtoC(DA1->&(aCampos[nCab])) + ";"
				Else
					cItens += DA1->&(aCampos[nCab]) + ";"
				EndIf
			Next
			
			//Quebra linha
			cItens += CRLF
		Endif
		
		//Renato Ruy - 17/10/2016
		//Através do parâmetro desabilita o produtos da tabela.
		If cDesat == "S" .And. DA1->DA1_ATIVO == "1" .And. nHdl != -1
			DA1->(Reclock("DA1",.F.))
				DA1->DA1_ATIVO := "2"
			DA1->(Msunlock())
		Endif
	    
		DA1->(DbSkip())
	Enddo

EndIf

//Grava os dados no arquivo
If nHdl != -1
	fWrite(nHdl,cItens)
	MsgInfo("O arquivo foi gerado no caminho: " + AllTrim(cArquivo))
	
	//Fecha o arquivo gerado.
	fClose(nHdl)
Else
	MsgInfo("Não foi possível gerar o arquivo!")
Endif


Return

//Renato Ruy - 14/10/2016
//Retorna um array com o campos utilizados
Static Function CTSA020C()

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