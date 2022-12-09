#include "rwmake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ NFSERV ³ Autor ³ Joveniriam     i       ³ Data ³21/12/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Locacao   ³ CSA - SP.        ³Contato ³ ealberti@microsiga.com.br      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Impressao De Notas Fiscais De Saida Servicos.              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Projeto   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Layout Especifico Para Municipio de Barueri - SP.      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista Resp.³  Data  ³ Bops ³ Manutencao Efetuada                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³  /  /  ³      ³                                        ³±±
±±³              ³  /  /  ³      ³                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function NFSERV()

//Inicializa Variaveis
Private nLastKey   := 0
Private aReturn    := { "Especial", 1,"Administracao", 1, 2, 1,"",1 }
Private _cNomeProg := "NFSERV"
Private _cString   := "SF2"
Private _cPerg     := "ATNF01      "
Private _cTitulo   := "IMPRESSAO DE NOTA FISCAL DE SAIDA (Servicos)					"
Private _cDesc1    := "Este programa tem por objetivo a impressao das notas fiscais	"
Private _cDesc2    := "de saida (Servicos) da empresa ATIVA, conforme os parametros	"
Private _cDesc3    := "informados pelo usuario.                                    	"

//Chamada de funcao para criacao de perguntas no SX1
_fCriaSX1()

//Verifica perguntas no SX1
Pergunte(_cPerg,.f.)

//Chamada para a Setprint
wnrel := SetPrint(_cString,_cNomeProg,_cPerg,@_cTitulo,_cDesc1,_cDesc2,_cDesc3,.f.,,.f.,,,.f.)

//Verifica se foi cancelada a impressao
If nLastKey == 27
	Return
Endif

SetDefault(aReturn,_cString)

//Verifica se foi cancelada a impressao
If nLastKey == 27
	Return
Endif

//Chamada para funcao principal do programa
RptStatus({|| RptDetail()})

Set Device To Screen

If aReturn[5] == 1
	Set Printer To
	DbcommitAll()
	OurSpool(wnrel)
Endif

Ms_Flush()

Return()
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RptDetail ºAutor  ³ Eduardo Alberti    º Data ³22/Mar/2007  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Montagem de Lay-Out e impressao da nota fiscal (Serviços).  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Layout Especifico Para Municipio de Santo Andre - SP.       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function RptDetail()

Local _aCab   , _aItens   , _aCliFor, _aDup    , _aTransp  , _aPosIpi  , _aLetIpi
Local _nI     , _nTamdesc , _nMens  , _nTamMens, _nPesoBru , _nPesoLiq , _nTotVol
Local _cCfo   , _cTexto   , _cMens  , _cDescPro
Local _lDispo , _lCalcVol ,_nTotdupl
Local _cRepr1 , _cRepr2

DbSelectArea("SF2")
DbSetOrder(1)
MsSeek(xFilial()+mv_par01+mv_par03,.t.)

SetRegua(Val(mv_par02)-Val(mv_par01))

While SF2->F2_FILIAL == xFilial() .And. SF2->F2_DOC <= mv_par02 .And. !Eof()
	
	If SF2->F2_SERIE <> mv_par03
		DbSkip()
		Incregua()
		Loop
	Endif
	
	//Inicia Matriz com dados do cabecalho da nota
	_aCab    := {}
	
	Aadd(_aCab,SF2->F2_DOC     )  	//Numero da nota		[01]
	Aadd(_aCab,SF2->F2_EMISSAO )  	//Emissao da nota    	[02]
	Aadd(_aCab,SF2->F2_BASEICM )  	//Valor base do ICMS 	[03]
	Aadd(_aCab,SF2->F2_VALICM  )  	//Valor do ICMS      	[04]
	Aadd(_aCab,SF2->F2_VALIPI  )  	//Valor do IPI       	[05]
	Aadd(_aCab,SF2->F2_FRETE   )  	//Valor do frete     	[06]
	Aadd(_aCab,SF2->F2_SEGURO  )  	//Valor do Seguro    	[07]
	Aadd(_aCab,SF2->F2_VALMERC )  	//Total dos produtos 	[08]
	Aadd(_aCab,SF2->F2_VALMERC+;
	SF2->F2_SEGURO +;
	SF2->F2_FRETE  +;
	SF2->F2_VALIPI )   				//Total da nota			[09]
	Aadd(_aCab,SF2->F2_PBRUTO  )  	//Peso Bruto na nota	[10]
	Aadd(_aCab,SF2->F2_PLIQUI  )  	//Peso Liq. na nota		[11]
	Aadd(_aCab,SF2->F2_ESPECI1 )  	//Especie na nota		[12]
	Aadd(_aCab,SF2->F2_VOLUME1 )  	//Volume na nota		[13]
	Aadd(_aCab,SF2->F2_BASEISS )  	//Base ISS				[14]
	Aadd(_aCab,SF2->F2_VALISS  )  	//Valor ISS				[15]
	Aadd(_aCab,SF2->F2_VALINSS  )  	//Valor INSS		[16]
	Aadd(_aCab,SF2->F2_VALIRRF  )  	//Valor IRRF		[17]   //NADIA
	Aadd(_aCab,SF2->F2_VALPIS  )  	//Valor PIS 		[18]
	Aadd(_aCab,SF2->F2_VALCOFI  )  	//Valor COFINS [19]
	Aadd(_aCab,SF2->F2_VALCSLL  )  	//Valor CSLL		[20]
	
	
	//Inicia Matriz com dados dos itens da nota
	_aItens  := {}
	
	_aPosIpi := {}
	
	_aLetIpi := {"A","B","C","D","E","F","G","H","I","J","K"}
	
	_aCfo    := {}
	
	//Alimenta matriz dos itens
	DbSelectArea("SD2")
	DbSetOrder(3)
	MsSeek(xFilial()+ SF2->F2_DOC + SF2->F2_SERIE + SF2->F2_CLIENTE + SF2->F2_LOJA,.t.)
	
	DbSelectArea("SC5")
	DbSetOrder(1)
	MsSeek(xFilial()+ SD2->D2_PEDIDO,.t.)
	
	//Volume
	_nTotVol  := 0
	_lCalcVol:= .t.
	
	If !Empty(SC5->C5_VOLUME1)
		_lCalcVol:= .f.
		_nTotVol := SC5->C5_VOLUME1
	Endif
	
	//Variaveis para tratamento de mais de um cfop na mesma nota
	_cCfo   := ""
	_cTexto := ""
	_nDESCZFR := 0      // Desconto zona franca
	
	While xFilial() == SD2->D2_FILIAL .And. SD2->D2_DOC == SF2->F2_DOC .And. ;
		SD2->D2_SERIE == SF2->F2_SERIE .And. !Eof()
		
		_cDescPro := ""
		
		DbSelectArea("SB1")
		DbSetorder(1)
		MsSeek(xFilial()+ SD2->D2_COD,.t.)
		//Salva descricao do produto
		_cDescPro := SB1->B1_DESC
		
		DbSelectArea("SF4")
		DbSetOrder(1)
		MsSeek(xFilial() + SD2->D2_TES,.t.)
		
		//Adiciona registros de itens da nota na matriz
		Aadd(_aItens,{	SD2->D2_COD  					,;	// 01
		_cDescPro						,;	// 02
		SB1->B1_POSIPI 					,;	// 03
		SB1->B1_ORIGEM					,;	// 04
		SD2->D2_UM   					,;	// 05
		SD2->D2_QUANT					,;	// 06
		SD2->D2_PRCVEN+SD2->D2_DESCZFR	,;	// 07
		SD2->D2_TOTAL+SD2->D2_DESCZFR	,;	// 08
		SD2->D2_PICM 					,;	// 09
		SD2->D2_IPI						,;	// 10
		SD2->D2_VALIPI					,;	// 11
		SD2->D2_CF						,;	// 12
		SD2->D2_NFORI					,;	// 13
		SD2->D2_SERIORI					,;	// 14
		SB1->B1_PESO					,;	// 15
		SB1->B1_PESBRU					,;	// 16
		SD2->D2_ALIQISS					})	// 17
		
		
		// Desconto zona franca
		_nDESCZFR := _nDESCZFR + SD2->D2_DESCZFR
		
		//Adiciona item com a posicao de IPI
		If Len(_aPosIpi) > 0
			If !Empty(SB1->B1_POSIPI)
				If Ascan( _aPosIpi, SB1->B1_POSIPI ) == 0
					Aadd( _aPosIpi , SB1->B1_POSIPI )
				Endif
			Endif
		Else
			Aadd( _aPosIpi , SB1->B1_POSIPI )
		Endif
		
		//Tratamento para mais de um cfop na mesma nota
		If _cCfo == ""
			_cCfo   := Alltrim(SD2->D2_CF)
			_cTexto := Alltrim(SF4->F4_TEXTO)
		Else
			If Alltrim(SD2->D2_CF) $ _cCfo
				_cCfo := _cCfo
			Else
				_cCfo   := _cCfo+"/"+Alltrim(SD2->D2_CF)
				_cTexto := _cTexto+"/"+Alltrim(SF4->F4_TEXTO)
			Endif
		Endif
		
		/*/Carrega mensagens de nota amarradas ao CFO
		If Len(_aCfo) > 0
			If !Empty(SF4->F4_MEN)
				If ( Ascan( _aCfo ,SF4->F4_MEN )) == 0
					Aadd(_aCfo,SF4->F4_MEN)
				Endif
			Endif
		Else
			If !Empty(SF4->F4_MEN)
				Aadd(_aCfo,SF4->F4_MEN)
			Endif
		Endif
		/*/
		
		DbSelectArea("SD2")
		SD2->(DbSkip())
		
	EndDo
	
	//Inicia matriz com dados do cliente / fornecedor
	_aCliFor := {}
	
	//Verifica se a nota e para cliente ou fornecedor
	If SF2->F2_TIPO $ "B|D"
		
		//Fornecedor
		DbSelectArea("SA2")
		DbSetOrder(1)
		MsSeek(xFilial()+SF2->F2_CLIENTE+SF2->F2_LOJA)
		
		Aadd(_aCliFor,SA2->A2_NOME   )  			//Nome do fornec.   [01]
		Aadd(_aCliFor,SA2->A2_CGC    )  			//CNPJ/CPF          [02]
		Aadd(_aCliFor,SA2->A2_END    ) 				//Endereco          [03]
		Aadd(_aCliFor,SA2->A2_BAIRRO )  			//Bairro            [04]
		Aadd(_aCliFor,SA2->A2_CEP    )  			//CEP               [05]
		Aadd(_aCliFor,SA2->A2_MUN    )  			//Municipio         [06]
		Aadd(_aCliFor,SA2->A2_TEL    )  			//Telefone          [07]
		Aadd(_aCliFor,SA2->A2_FAX    )  			//FAX               [08]
		Aadd(_aCliFor,SA2->A2_EST    )  			//Estado            [09]
		Aadd(_aCliFor,SA2->A2_INSCR  )  			//Incricao Estadual [10]
		//Endereco de Cob.	[11]
		Aadd(_aCliFor,"")
		//End. de Entrega   [12]
		Aadd(_aCliFor,"")
		Aadd(_aCliFor,SA2->A2_COD + SA2->A2_LOJA) 	//Cod. do Fornec.	[13]
		Aadd(_aCliFor,SA2->A2_EMAIL)			 	//E-Mail do Fornec.	[14]
		Aadd(_aCliFor,SA2->A2_INSCRM )  	//Incricao Municipal		[15]
		
	Else
		
		//Cliente
		DbSelectArea("SA1")
		DbSetOrder(1)
		MsSeek(xFilial()+SF2->F2_CLIENTE+SF2->F2_LOJA)
		
		Aadd(_aCliFor,SA1->A1_NOME   )  	//Nome do cliente   		[01]
		Aadd(_aCliFor,SA1->A1_CGC    )  	//CNPJ/CPF          		[02]
		Aadd(_aCliFor,SA1->A1_END    )  	//Endereco          		[03]
		Aadd(_aCliFor,SA1->A1_BAIRRO )  	//Bairro            		[04]
		Aadd(_aCliFor,SA1->A1_CEP    )  	//CEP               		[05]
		Aadd(_aCliFor,SA1->A1_MUN    )  	//Municipio         		[06]
		Aadd(_aCliFor,SA1->A1_TEL    )  	//Telefone          		[07]
		Aadd(_aCliFor,SA1->A1_FAX    )  	//FAX               		[08]
		Aadd(_aCliFor,SA1->A1_EST    )  	//Estado            		[09]
		Aadd(_aCliFor,SA1->A1_INSCR  )  	//Incricao Estadual 		[10]
		
		Aadd(_aCliFor,Alltrim(SA1->A1_ENDCOB)+" "+Alltrim(SA1->A1_BAIRROC))//Endereco de Cob   		[11]
		Aadd(_aCliFor,Alltrim(SA1->A1_CEPC))  //CEP COBRANÇA             [12]
		Aadd(_aCliFor,Alltrim(SA1->A1_MUNC))  // MUNICIPIO DE COBRANÇA   [13]
		Aadd(_aCliFor,Alltrim(SA1->A1_ESTC))  // UF DE COBRANÇA          [14]

		//+"/"+Alltrim(SA1->A1_MUNC)+"/"+Alltrim(SA1->A1_BAIRROC)+"/"+Alltrim(SA1->A1_CEPC)+"/"+Alltrim(SA1->A1_ESTC))
		//End. de Entrega   		[12]
		//	Aadd(_aCliFor,"Ent-"+Alltrim(SA1->A1_ENDENT)+"/"+Alltrim(SA1->A1_MUNE)+"/"+Alltrim(SA1->A1_BAIRROE)+"/"+Alltrim(SA1->A1_CEPE)+"/"+Alltrim(SA1->A1_ESTE)+"/"+Alltrim(SA1->A1_CGC))
		//	Aadd(_aCliFor,SA1->A1_COD+SA1->A1_LOJA) //Codigo do Cliente	[13]
		//	Aadd(_aCliFor,SA1->A1_EMAIL)		//E-Mail do Cliente			[14]
		Aadd(_aCliFor,SA1->A1_INSCRM )  	//Incricao Municipal		[15]
		Aadd(_aCliFor,"Entregar :-"+Alltrim(SA1->A1_ENDENT)+" - "+Alltrim(SA1->A1_MUNE)+" - "+Alltrim(SA1->A1_BAIRROE)+" - "+Alltrim(SA1->A1_CEPE)+" - "+Alltrim(SA1->A1_ESTE)) //+"CNPJ/CPF "+Alltrim(SA1->A1_CGC)) //[16]

		Aadd(_aCliFor,Alltrim(SA1->A1_RECISS))  // RECOLHE ISS[17] : 1=SIM; 2=NAO //14-11-2008

		lEntrega := .f.
		If !empty(SA1->A1_ENDENT)
			lEntrega := .t.
		Endif
	Endif
	
	//Inicia matriz com dados das duplicatas
	_aDup    := {}
	
	//Se a nota possuir duplicatas
	If !Empty(SF2->F2_DUPL)
		_nTotdupl := 0
		
		DbSelectArea("SE1")
		DbSetOrder(1)
		MsSeek(xFilial()+SF2->F2_SERIE+SF2->F2_DUPL,.t.)
		
		While xFilial() == SE1->E1_FILIAL .And. SE1->E1_PREFIXO == SF2->F2_SERIE ;
			.And. SE1->E1_NUM == SF2->F2_DUPL .And. !Eof()
			
			If SE1->E1_TIPO <> "NF "
				SE1->(DbSkip())
				Loop
			Endif

		/*
		14-11-2008
		IMPLEMENTACAO DA VERIFICACAO DO CAMPO A1_RECISS (Recolhe ISS ?) PARA DEDUZIR OU NAO O VALOR DO ISS
		1=Sim; 
		2=Nao
		*/ If Alltrim(_aCliFor[17]) == "1"
		   		unValPar := (SE1->E1_VALOR - SE1->E1_ISS - SE1->E1_INSS - SE1->E1_CSLL - SE1->E1_COFINS - SE1->E1_PIS - SE1->E1_IRRF)//LISONDA SP E PLAYPISO 
		   Else
				unValPar := (SE1->E1_VALOR - SE1->E1_INSS - SE1->E1_CSLL - SE1->E1_COFINS - SE1->E1_PIS)   //LISONDA-RJ DESTACA NAO RETEM
			EndIf		   
			
			//Aadd(_aDup,{(SE1->E1_NUM + "-" + SE1->E1_PARCELA),SE1->E1_VENCTO,  (SE1->E1_VALOR - SE1->E1_ISS - SE1->E1_INSS - SE1->E1_CSLL - SE1->E1_COFINS - SE1->E1_PIS)   }) //14-11-2008
			Aadd(_aDup,{(SE1->E1_NUM + "-" + SE1->E1_PARCELA),SE1->E1_VENCTO,  unValPar   }) //14-11-2008
			//_nTotdupl := _nTotdupl + (SE1->E1_VALOR - SE1->E1_ISS - SE1->E1_INSS - SE1->E1_CSLL - SE1->E1_COFINS - SE1->E1_PIS)
			_nTotdupl := _nTotdupl + unValPar  //14-11-2008
			
			SE1->(DbSkip())
		EndDo
	Endif
	
	//Inicia matriz com dados da transportadora
	_aTransp := {}
	
	//Se a nota possuir transportadora
	If !Empty(SF2->F2_TRANSP)
		
		DbSelectArea("SA4")
		DbSetOrder(1)
		MsSeek(xFilial()+SF2->F2_TRANSP,.t.)
		
		Aadd(_aTransp,SA4->A4_NOME   )     // Nome Transportadora  [01]
		Aadd(_aTransp,SA4->A4_CGC    )     // CGC                  [02]
		Aadd(_aTransp,SA4->A4_END    )     // Endereco             [03]
		Aadd(_aTransp,SA4->A4_MUN    )     // Municipio            [04]
		Aadd(_aTransp,SA4->A4_EST    )     // Estado               [05]
		Aadd(_aTransp,SA4->A4_INSEST )     // Inscricao Estadual   [06]
		
	Endif
	
	//Inicia a Impressao da nota atual
	_nLi := 004
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³                 Altera Salto De Linha Da Impressora 1/8                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	@ _nLi , 000 PSAY Chr(27) + "0"		// 1/8
	
	//Compacta Caractere de impressao
	@ _nLi, 000 PSAY Chr(15)
	
	//Imprime Numero da nota fiscal
	//@ _nLi , 120 Psay _aCab[01]
	_nLi+=2
	
	
	//Imprime natureza da operacao
	@ _nLi , 080 Psay "PRESTACAO DE SERVICOS"          //_cTexto
	_nLi+=2
	
	//Imprime Prest. de Servico de:
	@ _nLi , 080 Psay "CONSTRUCAO CIVIL "
	_nLi+=2
	
	//Imprime data de emissao da nota fiscal
	@ _nLi , 080 Psay _aCab[02]
	_nLi += 5
	
	//Impressao de duplicatas
	//Se Existirem duplicatas a serem impressas
	If Len(_aDup) > 0
		
		//Comprime impressao
		//@ _nLi , 000 Psay Chr(15)
		
		For _nI := 1 To Len(_aDup)
			
			// Imprime Primeira Duplicata
			If _nI == 1
				
				@ _nLi , 020	Psay _aDup[_nI,01]									// Numero
				@ _nLi , 045	Psay Transform(_aDup[_nI,03],"@e 999,999,999.99") 	// Valor
				@ _nLi , 070	Psay _aDup[_nI,01]									// Numero
				@ _nLi , 095	Psay DtoC(_aDup[_nI,02])							// Vencimento
				
			ElseIf	_nI == 2
				_nLi+=1
				@ _nLi , 020	Psay _aDup[_nI,01]									// Numero
				@ _nLi , 045	Psay Transform(_aDup[_nI,03],"@e 999,999,999.99") 	// Valor
				@ _nLi , 070	Psay _aDup[_nI,01]									// Numero
				@ _nLi , 095	Psay DtoC(_aDup[_nI,02])							// Vencimento
				
			ElseIf	_nI == 3  //nadia
				_nLi+=1
				@ _nLi , 020	Psay _aDup[_nI,01]									// Numero
				@ _nLi , 045	Psay Transform(_aDup[_nI,03],"@e 999,999,999.99") 	// Valor
				@ _nLi , 070	Psay _aDup[_nI,01]									// Numero
				@ _nLi , 095	Psay DtoC(_aDup[_nI,02])							// Vencimento	
				
			EndIf
		Next _nI
 Else
		_nLi+=6
	Endif
	
	_nLi+=7
	
	//Imprime nome do cliente
	@ _nLi , 036 Psay Alltrim(_aCliFor[01])  //+ Space(1) + Substr(_aCliFor[13],1,6)+"-"+Substr(_aCliFor[13],7,2)    alterado em 05-03-2009 Rosana
	
	_nLi += 2
	
	//Imprime endereco do cliente
	@ _nLi , 036 Psay _aCliFor[03]
	
	//Imprime bairro do cliente
	@ _nLi , 077 Psay _aCliFor[04]      //era @ _nLi , 068, A1_END tem tamanho 40. alterado em 05-03-2009 Rosana
	_nLi += 1
	
	
	//Imprime UF do Cliente
	@ _nLi , 090 Psay _aCliFor[09]
	
	//Imprime CEP do Cliente
	@ _nLi , 110 Psay _aCliFor[05] Picture "@R 99999-999"
	_nLi += 1
	//Imprime municipio do cliente
	@ _nLi , 036 Psay _aCliFor[06]
	_nLi+=2
	
	//ENDERECO DE COBRAÇA
	//Impressao de endereco de cobranca.
	@ _nLi , 036 Psay _aCliFor[11]
	@ _nLi , 110 Psay _aCliFor[12] Picture "@R 99999-999"   //era @ _nLi , 077 , 36 do inicío+A1_ENDCOB=40 +' '+A1_BAIRROC = 30, acrescentei picture, alterado em 05-03-2009 Rosana
	_nLi+=2
	//Impressao municipio de cobranca.
	@ _nLi , 036 Psay _aCliFor[13]
	@ _nLi , 090 Psay _aCliFor[15]
	_nLi+=2
	
	If Len(Alltrim( _aCliFor[02])) > 11
		//Imprime CNPJ do Cliente
		@ _nLi , 036 Psay _aCliFor[02] Picture "@R 99.999.999/9999-99"
	Else
		//Imprime CPF do Cliente
		@ _nLi , 036 Psay _aCliFor[02] Picture "@R 999.999.999-99"
	Endif
	
	//Imprime IE do Cliente
	@ _nLi , 090 Psay _aCliFor[10]
	
	// Vai Para Itens da Nota Fiscal
	_nLi+=3
	
	
	//Valor por Extenso
	
	If Len(_aDup) > 0
		@ _nLi, 036 PSAY extenso( _nTotdupl)
	Endif
	
	_nLi+=10
	
	//Impressao dos itens da NF
	
	//Tamanho da descricao
	_nTamDesc := 0
	
	//Pesos
	_nPesoBru := 0
	_nPesoLiq := 0
	
	For _nI := 1 to Len(_aItens)
		
		//Calcula Peso Liquido e Bruto
		_nPesoLiq += _aItens[_nI,06] * _aItens[_nI,15]
		_nPesoBru += _aItens[_nI,06] * _aItens[_nI,16]
		
		//Calculo de volumes
		If _lCalcVol
			_nTotVol  += _aItens[_nI,06]
		Endif
		
		//Tamanho da descricao
		_nTamDesc := Len(Alltrim(_aItens[_nI,02]))
		
		//Posicao da letra na matriz da posicao de IPI
		//_nPos := Ascan(_aPosIpi,_aItens[_nI,03])
		@ _nLi , 005 Psay _aItens[_nI,05] //Unidade de medida
		
		@ _nLi , 010 Psay _aItens[_nI,06] Picture "@E 9999.99" //Quantidade
		
		@ _nLi , 030 Psay Substr(_aItens[_nI,02],1,65) //Descricao
		
		
		@ _nLi , 096 Psay _aItens[_nI,07] Picture "@E 99,999,999.99" //Valor unitario
		
		@ _nLi , 115 Psay _aItens[_nI,08] Picture "@E 99,999,999.99" // Valor total
		//@ _nLi , 092 Psay _aItens[_nI,17] Picture "@E 99,999,999.99" // % ISS
		//@ _nLi , 115 Psay _aItens[_nI,09] Picture "99.9" //Perc ICMS
		//@ _nLi , 120 Psay _aItens[_nI,10] Picture "99.9" //Perc IPI
		//@ _nLi , 125 Psay _aItens[_nI,11] Picture "@E 9,999,999.99" //Valor IPI
		_nLi += 1
		
		//Tratamento para descricoes maiores que 40 posicoes
		If _nTamDesc > 65
			_nPosDesc := 66
			While _nPosDesc < _nTamDesc
				@ _nLi , 023 Psay Substr(_aItens[_nI,02],_nPosDesc,40) //Descricao
				_nPosDesc+=65
				_nLi += 1
			EndDo
		Endif
		
	Next _nI
	
	// Zona Franca
	If _nDESCZFR > 0
		_nLi++
		@ _nLi ,009 Psay "Desconto ICMS 7% : " +TRANSFORM(_nDESCZFR,"@e 999,999,999.99")
		_nLi++
	Endif
	
	// Inicia a Impressao De Mensagens
	//If _nLi <= 42
	
	//	_nLi 	:= 42
	_cMens 	:= ""
	_nMens 	:= 0
	
	//Mensagem padrao do pedido //AQUI
	_nLi += 3
	
	If !Empty(SC5->C5_MENPAD)
		_cMens := Alltrim(Formula(SC5->C5_MENPAD))
	Endif
	
	//Mensagem livre do pedido
	If !Empty(SC5->C5_MENNOTA)
		If Empty(_cMens)
			_cMens := Alltrim(SC5->C5_MENNOTA)
		Else
			_cMens += " * " + Alltrim(SC5->C5_MENNOTA)
		Endif
	Endif
	
	//Tratamento para descricoes maiores que 73 posicoes
	@ _nLi , 023 Psay Substr(_cMens,1,73) //Mensagem
	_nLi += 1
	If  Len(Alltrim(_cMens)) > 73
		_nPosDesc := 74
		While _nPosDesc <  Len(Alltrim(_cMens)) //_nTamDesc
			@ _nLi , 023 Psay Substr(_cMens,_nPosDesc,73) //Mensagem
			_nPosDesc+=73
			_nLi += 1
		EndDo
	Endif
	
	//Tratamento de endereço de entrega
	If lEntrega
		_nLi += 2
		@ _nLi , 023 Psay _aCliFor[16]
	Endif
	
	
	//Tratamento dos impostos
	_nLi += 2
	
	If !Empty(_acab[15])        //Valor do ISS
		@ _nLi , 023 Psay "Valor do ISS " + TRANSFORM(_aCab[15],"@e 999,999,999.99")
		_nLi += 1
	Endif
	
	If !Empty( _acab[16])       //Valor do Inss
		@ _nLi , 023 Psay "Valor do INSS " + TRANSFORM(_aCab[16],"@e 999,999,999.99")
		_nLi += 1
	Endif
	
	If !Empty( _acab[17])       //Valor do IRRF
		@ _nLi , 023 Psay "Valor do IRRF " + TRANSFORM(_aCab[17],"@e 999,999,999.99")
		_nLi += 1
	Endif
	
	If !Empty( _acab[18])       //Valor do PIS
		@ _nLi , 023 Psay "Valor do PIS " + TRANSFORM(_aCab[18],"@e 999,999,999.99")
		_nLi += 1
	Endif
	
	If !Empty( _acab[19])       //Valor do Cofins
		@ _nLi , 023 Psay "Valor do COFINS " + TRANSFORM(_aCab[19],"@e 999,999,999.99")
		_nLi += 1
	Endif

	If !Empty( _acab[20])       //Valor do CSLL
		@ _nLi , 023 Psay "Valor do CSLL " + TRANSFORM(_aCab[20],"@e 999,999,999.99")
		_nLi += 1
	Endif
	
	
	/*/Mensagens amarradas ao TES
	For _nI := 1 To Len(_aCfo)
		If Empty(_cMens)
			_cMens := Alltrim(Formula(_aCfo[_nI]))
		Else
			_cMens += " * " + Alltrim(Formula(_aCfo[_nI]))
		Endif
		
	Next _nI
	/*/
	
	
	//Tamanho da mensagem
	_nTamMens := Len(_cMens)
	_nCount   := 1
	
	While .t.
		If _nTamMens > _nMens
			//		@ _nLi , 012 Psay Substr(_cMens,_nMens,050)
			_nMens+=050
			/*
			If Len(_aPosIpi) >= _nCount
			@ _nLi , 077 Psay _aPosIpi[_nCount]
			_nCount++
			Endif
			*/
			_nLi++
		Else
			Exit
		Endif
	EndDo
	//Endif
	
	_nLi := 70 // era 44
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³            Altera Salto De Linha Da Impressora 1/6(Normal)              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//@ _nLi , 000 PSAY Chr(27) + "2"	// 1/6
	
	//Imprime os totais da nota
	//@ _nLi , 003 Psay _aCab[03] Picture "@E 999,999,999.99"  	//Base ICMS
	//@ _nLi , 018 Psay _aCab[04] Picture "@E 999,999,999.99"  	//Valor ICMS
	//@ _nLi , 066 Psay _aCab[08] Picture "@E 999,999,999.99"  	//Total produtos
	//	@ _nLi , 012 Psay _aCab[14] Picture "@E 999,999,999.99"  	//Base Calculo ISSQN
	//	@ _nLi , 048 Psay _aCab[15] Picture "@E 999,999,999.99"  	//Valor Do ISS
	@ _nLi , 109 Psay _aCab[09] Picture "@E 999,999,999.99"  	//Total da nota
	_nLi+=10
	
	//@ _nLi , 010 Psay _aCab[01]
	_nLi+=07
	
	//Imprime os totais da nota
	//@ _nLi , 003 Psay _aCab[06] Picture "@E 999,999,999.99"  //Valor frete
	//@ _nLi , 018 Psay _aCab[07] Picture "@E 999,999,999.99"  //Valor Seguro
	//@ _nLi , 052 Psay _aCab[05] Picture "@E 999,999,999.99"  //Valor IPI
	
	//_nLi+=3
	/*
	If Len(_aTransp) >0
	
	@ _nLi , 001 Psay _aTransp[01]		// Nome Transportadora
	@ _nLi , 057 Psay _aTransp[03]		// Endereco
	
	_nLi += 2
	
	If SC5->C5_TPFRETE == "C"
	@ _nLi , 000 Psay "X"
	Else
	@ _nLi , 011 Psay "X"
	Endif
	
	/*
	@ _nLi , 066 Psay _aTransp[02]
	
	_nLi+=2
	
	@ _nLi , 003 Psay _aTransp[03]
	@ _nLi , 041 Psay _aTransp[04]
	@ _nLi , 067 Psay _aTransp[05]
	@ _nLi , 068 Psay _aTransp[06]
	/*
	
	Endif
	
	//Impressao de Quantidade de Volumes
	@ _nLi , 035 Psay _aCab[13] Picture "99999"
	
	//Impressao de Especie
	@ _nLi , 045 Psay _aCab[12]
	
	//Impressao de Peso Liquido
	@ _nLi , 075 Psay _aCab[11] Picture "@E 99,999.9999"
	
	//Impressao de Peso Bruto
	@ _nLi , 093 Psay _aCab[10] Picture "@E 99,999.9999"
	
	
	/*
	_nLi   := 53 // era 52
	
	//Impressao de Quantidade de Volumes
	@ _nLi , 003 Psay _nTotVol Picture "99999"
	//Impressao de Especie
	@ _nLi , 012 Psay "Volume(s)"
	//Impressao da Marca
	@ _nLi , 025 Psay "Centrik"
	
	_nLi   := 56
	
	If _nCount <= Len(_aPosIpi)
	While Len(_aPosIpi) >= _nCount
	@ _nLi , 077 Psay _aPosIpi[_nCount]
	_nCount++
	_nLi++
	EndDo
	Endif
	*/
	
	
	
	//Descompressao de caractere de impressao
	@ _nLi , 000 Psay Chr(18)
	
	//_nLi := 69
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³            Altera Salto De Linha Da Impressora 1/6(Normal)              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	@ _nLi , 000 PSAY Chr(27) + "2"	// 1/6
	
	@ _nLi , 001 Psay ""
	
	//Finaliza a impressao da nota atual
	
	//Zera o formulario
	SetPrc(0,0)
	
	//Avanca para a proxima nota
	DbSelectArea("SF2")
	DbSkip()
	IncRegua()
Enddo

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³_fCriaSX1 ºAutor  ³ Eduardo Alberti    º Data ³ 22/Mar/2007 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Criacao de perguntas no SX1                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function _FcriaSX1()

DbSelectArea("SX1")
DbSetOrder(1)

_cPerg := padr(_cPerg, 10)

If ! MsSeek(_cPerg+"01",.t.)
	Reclock("SX1",.t.)
	SX1->X1_GRUPO   := _cPerg
	SX1->X1_ORDEM   := "01"
	SX1->X1_PERGUNT := "Da Nota:"
	SX1->X1_VARIAVL := "mv_ch1"
	SX1->X1_TIPO    := "C"
	SX1->X1_TAMANHO := 9
	SX1->X1_DECIMAL := 0
	SX1->X1_PRESEL  := 0
	SX1->X1_GSC     := "G"
	SX1->X1_VALID   := ""
	SX1->X1_VAR01   := "mv_par01"
	SX1->X1_DEF01   := ""
	MsUnLock()
EndIf


DbSelectArea("SX1")
DbSetOrder(1)

If ! MsSeek(_cPerg+"02",.t.)
	Reclock("SX1",.t.)
	SX1->X1_GRUPO   := _cPerg
	SX1->X1_ORDEM   := "02"
	SX1->X1_PERGUNT := "Ate a Nota:"
	SX1->X1_VARIAVL := "mv_ch2"
	SX1->X1_TIPO    := "C"
	SX1->X1_TAMANHO := 9
	SX1->X1_DECIMAL := 0
	SX1->X1_PRESEL  := 0
	SX1->X1_GSC     := "G"
	SX1->X1_VALID   := ""
	SX1->X1_VAR01   := "mv_par02"
	SX1->X1_DEF01   := ""
	MsUnLock()
EndIf

DbSelectArea("SX1")
DbSetOrder(1)

If ! MsSeek(_cPerg+"03",.t.)
	Reclock("SX1",.t.)
	SX1->X1_GRUPO   := _cPerg
	SX1->X1_ORDEM   := "03"
	SX1->X1_PERGUNT := "Da Serie:"
	SX1->X1_VARIAVL := "mv_ch3"
	SX1->X1_TIPO    := "C"
	SX1->X1_TAMANHO := 3
	SX1->X1_DECIMAL := 0
	SX1->X1_PRESEL  := 0
	SX1->X1_GSC     := "G"
	SX1->X1_VALID   := ""
	SX1->X1_VAR01   := "mv_par01"
	SX1->X1_DEF01   := ""
	MsUnLock()
EndIf

Return()
