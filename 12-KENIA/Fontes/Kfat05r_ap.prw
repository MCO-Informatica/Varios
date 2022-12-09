#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05
#IFNDEF WINDOWS
	#DEFINE PSAY SAY
#ENDIF

User Function Kfat05r()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

Private _nCusto	:=	0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("NTAMANHO,NLIMITE,CTITULO,CDESC1,CDESC2,CDESC3")
SetPrvt("ARETURN,NOMEPROG,CPERG,LCONTINUA,NLIN,WNREL")
SetPrvt("CSTRING,NLASTKEY,NPAG,NITENS,NITFORM,NIMPFORM")
SetPrvt("CVENDORI,CNATUREZA,CFINANCEIRO,XTOTAL,XDADOS,LCOMPLETE")
SetPrvt("NPRE_UNI,I,AREGS,J,")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ KFAT05R  ³ Autor ³Ricardo Correa de Souza³ Data ³04/10/2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Emissao do Pedido de Vendas Lay Out Especifico             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Kenia Industrias Texteis Ltda                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   Analista   ³  Data  ³             Motivo da Alteracao               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³        ³                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
/*/

#IFNDEF WINDOWS
	// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 12/02/05 ==>     #DEFINE PSAY SAY
#ENDIF

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Variaveis Utilizadas no Parametro                                         *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

//mv_par01                Do Pedido N£mero
//mv_par02                At‚ o Pedido N£mero

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Variaveis Utilizadas no Relatorio                                         *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

nTamanho  := "P"
nLimite   := 132
cTitulo   := PADC( "Emissao de Pedidos", 74 )
cDesc1    := PADC( "Se houver alguma divêrgencia no pedido, favor responder este e-mail ", 74 )
cDesc2    := PADC( "informando, caso contrário daremos andamento na produção.", 74 )
cDesc3    := PADC( "Att.", 74 )
cDesc4    := PADC( "Depto.Comercial", 74 )
aReturn   := { "Especifico", 1, "Departamento Comercial", 1, 1, 1, "", 1 }
nomeprog  := "KFAT05R"
cPerg     := "FAT05R    "
lContinua := .T.
nLin      := 0
wnrel     := "KFAT05R"
cString   := "SC5"
nLastKey  := 0
nLin      := 0
nPag      := 1
nItens    := 0
nItForm   := 10
nImpForm  := 0

ValidPerg()

Pergunte( cPerg, .F. )

wnrel := SetPrint(cString,wnrel,cPerg,cTitulo,cDesc1,cDesc2,cDesc3,.F.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

#IFDEF WINDOWS
	RptStatus({|| Imprime()},cTitulo)// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==>     RptStatus({|| Execute(Imprime)},cTitulo)
#ELSE
	Imprime()
#ENDIF

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function Imprime
Static Function Imprime()

Private _cMod	:=	Space(15)

DbSelectArea("SB1")                 // Produtos
DbSetOrder(1)                       // Codigo

DbSelectArea("SA1")                 // Clientes
DbSetOrder(1)                       // Codigo

DbSelectArea("SA3")                 // Vendedores / Representantes
DbSetOrder(1)                       // Codigo

DbSelectArea("SA4")                 // Transportadoras
DbSetOrder(1)                       // Codigo

DbSelectArea("SE4")                 // Condi‡äes de Pagto
DbSetOrder(1)                       // Codigo

DbSelectArea("SF4")                 // TES
DbSetOrder(1)                       // Numero Pedido + Item + Produto

DbSelectArea("SC6")                 // Itens dos Pedidos
DbSetOrder(1)                       // Numero Pedido + Cod. Produto

DbSelectArea("SC5")                 // Pedidos de Venda
DbSetOrder(1)                       // Numero Pedido
DbSeek( xFilial("SC5") + mv_par01 )

SetRegua( Val(mv_par02)-Val(mv_par01)+1 )
@ nLin,  00 PSAY AvalImp( nLimite )

Do While !Eof() .AND. SC5->C5_NUM <= mv_par02
	
	IncRegua()
	
	DbSelectArea("SC6")
	DbSeek( xFilial("SC6") + SC5->C5_NUM )
	
	DbSelectArea("SA1")
	DbSeek( xFilial("SA1")+ SC5->C5_CLIENTE + SC5->C5_LOJACLI )
	
	DbSelectArea("SA3")
	DbSeek( xFilial("SA3") + SA1->A1_VEND )
	cVendOri := SA3->A3_NREDUZ
	
	DbSelectArea("SA3")
	DbSeek( xFilial("SA3") + SC5->C5_VEND1 )
	If cVendOri == SA3->A3_NREDUZ
		cVendOri := ""
	EndIf
	
	DbSelectArea("SE4")
	DbSeek( xFilial("SE4") + SC5->C5_CONDPAG )
	
	DbSelectArea("SA4")
	DbSeek( xFilial("SA4") + SC5->C5_TRANSP )
	
	@ 001 , 000 PSAY Replic( "_", 129 )
	
	@ 002 , 000 PSAY "|"
	@ 002 , 128 PSAY "|"
	
	@ 003 , 000 PSAY "|"
	@ 003 , 001 PSAY Padc("K  E  N  I  A     I  N  D  U  S  T  R  I  A  S     T  E  X  T  E  I  S     L  T  D  A",131)
	@ 003 , 128 PSAY "|"
	
	@ 004 , 000 PSAY "|"
	@ 004 , 128 PSAY "|"
	
	@ 005 , 000 PSAY "|"
	@ 005 , 001 PSAY Padc("P  E  D  I  D  O     D  E     V  E  N  D  A",131)
	@ 005 , 128 PSAY "|"
	
	@ 006 , 000 PSAY "|"
	@ 006 , 128 PSAY "|"
	
	@ 007 , 000 PSAY "| *** DADOS CADASTRAIS ***"
	@ 007 , 128 PSAY "|"
	
	@ 008 , 000 PSAY "| Pedido Cliente    : "+SC5->C5_PEDCLI
	@ 008 , 060 PSAY "Pedido Interno    : "+SC5->C5_NUM
	@ 008 , 100 PSAY "Emissao      : "+Dtoc(SC5->C5_EMISSAO)
	@ 008 , 128 PSAY "|"
	
	@ 009 , 000 PSAY "| Codigo Cliente    : "+SC5->C5_CLIENTE+"/"+SC5->C5_LOJACLI
	@ 009 , 060 PSAY "Nome Cliente      : "+SA1->A1_NOME
	@ 009 , 128 PSAY "|"
	
	@ 010 , 000 PSAY "| Endereco          : "+SA1->A1_END
	@ 010 , 060 PSAY "Cep               : "
	@ 010 , 080 PSAY SA1->A1_CEP Picture "@R 99999-999"
	If !Empty(cVendOri)
		@ 010 , 100 PSAY "Vend. Origem : "+cVendOri
	EndIf
	@ 010 , 128 PSAY "|"
	
	@ 011 , 000 PSAY "| Cidade/Estado     : "+SA1->A1_MUN+" - "+SA1->A1_EST
	@ 011 , 060 PSAY "Telefone          : "+SA1->A1_TEL1
	@ 011 , 100 PSAY "Fax          : "+SA1->A1_FAX
	@ 011 , 128 PSAY "|"
	
	@ 012 , 000 PSAY "| C.G.C.            : "
	@ 012 , 022 PSAY SA1->A1_CGC Picture "@R 99.999.999/9999-99"
	@ 012 , 060 PSAY "Inscr. Estadual   : "+SA1->A1_INSCR
	@ 012 , 128 PSAY "|"
	
	@ 013 , 000 PSAY "| Contato           : "+SA1->A1_CONTATO
	@ 013 , 060 PSAY "Nome Fantasia     : "+SA1->A1_NREDUZ
	@ 013 , 100 PSAY "Frete        : "+Iif( SC5->C5_TPFRETE=="F", "A PAGAR", "PAGO" )
	@ 013 , 128 PSAY "|"
	
	@ 014 , 000 PSAY "| Cod. Vendedor     : "+SC5->C5_VEND1
	@ 014 , 060 PSAY "Transportadora    : "+Subs(SA4->A4_NOME,1,18)
	@ 014 , 100 PSAY "Telefone     : "+SA4->A4_TEL
	@ 014 , 128 PSAY "|"
	
	@ 015 , 000 PSAY "|"
	@ 015 , 128 PSAY "|"
	
	@ 016 , 000 PSAY "| *** DADOS COMERCIAIS ***"
	@ 016 , 128 PSAY "|"
	
	@ 017 , 000 PSAY "| Cond. Pagto       : "+SE4->E4_DESCRI
	@ 017 , 060 PSAY "Nome Vendedor     : "+SA3->A3_NREDUZ
	@ 017 , 100 PSAY "Comissao     : "
	@ 017 , 114 PSAY SC5->C5_COMIS1 Picture "@E 99.99"
	@ 017 , 128 PSAY "|"
	
	@ 018 , 000 PSAY "| Tabela            : "+SC5->C5_TABELA
	@ 018 , 060 PSAY "Tipo              : "+Iif(SC5->C5_TPCOBR=="1 ","NO",Iif(SC5->C5_TPCOBR=="2 ","C1",Iif(SC5->C5_TPCOBR=="3 ","C3",Iif(SC5->C5_TPCOBR=="4 ","D3","DF"))))
	@ 018 , 128 PSAY "|"
	
	@ 019 , 000 PSAY "|                   : "+SC5->C5_PAPELET
	@ 019 , 060 PSAY "Natureza          : "
	cNatureza := Posicione("SED",1,xFilial("SED")+SC5->C5_NATUREZ,"SED->ED_DESCRIC")
	@ 019 , 080 PSAY Alltrim(SC5->C5_NATUREZ)+" "+Subs(cNatureza,1,20)
	@ 019 , 100 PSAY "Financeiro   : "
	cFinanceiro := Posicione("SF4",1,xFilial("SF4")+SC6->C6_TES,"SF4->F4_DUPLIC")
	@ 019 , 115 PSAY Iif(cFinanceiro $"S","SIM","NAO")
	@ 019 , 128 PSAY "|"
	
	@ 020 , 000 PSAY "| Data Ult. Compra  : "+DTOC(SA1->A1_ULTCOM)
	@ 020 , 060 PSAY "| Data Prim. Compra : "+DTOC(SA1->A1_PRICOM)
	@ 020 , 128 PSAY "|"

	@ 021 , 000 PSAY "|"
	@ 021 , 128 PSAY "|"
	
	@ 022 , 000 PSAY Replic( "_", 129 )
	
	nLin := 23
	
	@ nLin , 000 PSAY Repli("_",129)
	nLin := nLin + 1
	@ nLin , 000 Psay "| It | Ordem        | Cor | Artigo               | % Desc | Quantidade | Vlr. Unit. | Vlr. Total | Entrega  |    VC     | Fmt"
	@ nLin , 128 Psay "|"
	nLin := nLin + 1
	@ nLin , 000 PSAY Repli("_",129)
	
	DbSelectArea("SC6")
	xTOTAL := { 0, 0 }    // ** Total em Qtde, Total em R$
	xDADOS := .F.
	lComplete := .T.
	
	Do While !Eof() .AND. SC6->C6_NUM == SC5->C5_NUM
		
		//----> PEDIDOS DE TERCEIROS
		If Alltrim(SC5->C5_NATUREZ)$"0015"
			
			If nLin > 59
				lComplete := .F.
				@ nLin , 000 PSAY Replic("_", 129 )
				nLin := 2
				@ nLin , 120 PSAY "CONTINUA ..."
				nLin := 1
				@ nLin, 000 PSAY "CONTINUACAO..."
				nLin := nLin + 2
				
				@ nLin , 000 PSAY Repli("_",129)
				nLin := nLin + 1
				@ nLin , 000 Psay "| It | Ordem        | Cor | Artigo               | % Desc | Quantidade | Vlr. Unit. | Vlr. Total | Entrega  |    VC     | Fmt"
				@ nLin , 128 Psay "|"
				nLin := nLin + 1
				@ nLin , 000 PSAY Repli("_",129)
			EndIf
			
			DbSelectArea("SB1")
			DbSeek( xFilial("SB1") + SC6->C6_PRODUTO )
			
			DbSelectArea("SF4")
			DbSeek( xFilial("SF4") + SC6->C6_TES )
			
			nLin := nLin + 1
			@ nLin, 000 		PSAY "| "+SC6->C6_ITEM
			@ nLin, Pcol()+001 	PSAY "| "+Subs(SC6->C6_PRODUTO,1,3)+Subs(SC6->C6_PRODUTO,7)
			@ nLin, Pcol()+001 	PSAY "| "+Subs(SC6->C6_PRODUTO,4,3)
			
			If Alltrim(SC6->C6_PRODUTO) $"2207/2221/2999"
				@ nLin, Pcol()+001 	PSAY "| "+Subs(SC6->C6_DESCRI,1,20)
			Else
				@ nLin, Pcol()+001 	PSAY "| "+Subs(Posicione("SZC",1,xFilial("SZC")+SC6->C6_CLI+SC6->C6_LOJA+SC6->C6_PRODUTO,"ZC_DESCPRO"),1,20)
			EndIf
			
			@ nLin, Pcol()+001 	PSAY "|"
			@ nLin, Pcol()+002 	PSAY SC6->C6_DESCONT Picture "@E 99.99"
			@ nLin, Pcol()+001 	PSAY "|"
			@ nLin, Pcol()+001 	PSAY SC6->C6_QTDVEN Picture "@E 999,999.99"
			@ nLin, Pcol()+001 	PSAY "|"
			
			//----> SO IMPRIME VALORES DE MAO DE OBRA
			If Alltrim(SC6->C6_PRODUTO) $"2207/2221/2999"
				
				_cMod	:=	Alltrim(SC6->C6_PRODUTO)
				
				If SC6->C6_DESCONT > 0
					nPre_Uni := Round((SC6->C6_PRCVEN / ((SC6->C6_DESCONT / 100) - 1)*-1),2)
					@ nLin, Pcol()+001 	PSAY nPre_Uni            Picture"@E 9,999.9999"
				Else
					@ nLin, Pcol()+001 	PSAY SC6->C6_PRCVEN      Picture"@E 9,999.9999"
				EndIf
				@ nLin, Pcol()+001 	PSAY "|"
				@ nLin, Pcol()+001 	PSAY SC6->C6_VALOR Picture "@E 999,999.99"
				@ nLin, Pcol()+001 	PSAY "|"
			Else
				@ nLin, Pcol()+001 	PSAY 0				Picture "@E 9,999.9999"
				@ nLin, Pcol()+001 	PSAY "|"
				@ nLin, Pcol()+001 	PSAY 0				Picture "@E 999,999.99"
				@ nLin, Pcol()+001 	PSAY "|"
				BuscaCusto()
				
				_cMod := Space(15)
			EndIf
			
			@ nLin, Pcol()+001 	PSAY Dtoc(SC6->C6_ENTREG)
			@ nLin, Pcol()+001 	PSAY "|"
			
			
			@ nLin, Pcol()+000 	PSAY _nCusto			Picture "@E 9,999.9999"
			@ nLin, Pcol()+001 	PSAY "|"
			@ nLin, Pcol()+001 	PSAY Iif(SC6->C6_FORMATO=="1","C","T")
			@ nLin, Pcol()+005 	PSAY "|"
			
			xTOTAL[1] := xTOTAL[1] + Iif(Alltrim(SC6->C6_PRODUTO)$"2207/2221/2999",SC6->C6_QTDVEN,0)
			xTOTAL[2] := xTOTAL[2] + Iif(Alltrim(SC6->C6_PRODUTO)$"2207/2221/2999",NoRound(SC6->C6_VALOR,2),0)
			
			nLin   := nLin + 1
			nItens := nItens + 1
			
			_nCusto:= 0
			
			DbSelectArea("SC6")
			DbSkip()
			
			//----> PEDIDOS KENIA
		Else
			If nLin > 59
				lComplete := .F.
				@ nLin , 000 PSAY Replic("_", 129 )
				nLin := 2
				@ nLin , 120 PSAY "CONTINUA ..."
				nLin := 1
				@ nLin, 000 PSAY "CONTINUACAO..."
				nLin := nLin + 2
				
				@ nLin , 000 PSAY Repli("_",129)
				nLin := nLin + 1
				@ nLin , 000 Psay "| It | Ordem        | Cor | Artigo               | % Desc | Quantidade | Vlr. Unit. | Vlr. Total | Entrega  |    VC     | Fmt"
				@ nLin , 128 Psay "|"
				nLin := nLin + 1
				@ nLin , 000 PSAY Repli("_",129)
			EndIf
			
			DbSelectArea("SB1")
			DbSeek( xFilial("SB1") + SC6->C6_PRODUTO )
			
			DbSelectArea("SF4")
			DbSeek( xFilial("SF4") + SC6->C6_TES )
			
			nLin := nLin + 1
			@ nLin, 000 PSAY "| "+SC6->C6_ITEM
			@ nLin, Pcol()+001 	PSAY "| "+Subs(SC6->C6_PRODUTO,1,3)+Subs(SC6->C6_PRODUTO,7)
			@ nLin, Pcol()+001 	PSAY "| "+Subs(SC6->C6_PRODUTO,4,3)
			@ nLin, Pcol()+001 	PSAY "| "+Subs(SB1->B1_X_ARTG,1,20)
			@ nLin, Pcol()+001 	PSAY "|"
			@ nLin, Pcol()+002 	PSAY SC6->C6_DESCONT Picture "@E 99.99"
			@ nLin, Pcol()+001 	PSAY "|"
			@ nLin, Pcol()+001 	PSAY SC6->C6_QTDVEN Picture "@E 999,999.99"
			@ nLin, Pcol()+001 	PSAY "|"
			If SC6->C6_DESCONT > 0
				nPre_Uni := Round((SC6->C6_PRCVEN / ((SC6->C6_DESCONT / 100) - 1)*-1),2)
				@ nLin, Pcol()+001 	PSAY nPre_Uni            Picture"@E 9,999.9999"
			Else
				@ nLin, Pcol()+001 	PSAY SC6->C6_PRCVEN      Picture"@E 9,999.9999"
			EndIf
			@ nLin, Pcol()+001 	PSAY "|"
			@ nLin, Pcol()+001 	PSAY SC6->C6_VALOR  Picture "@E 999,999.99"
			@ nLin, Pcol()+001 	PSAY "|"
			@ nLin, Pcol()+001 	PSAY Dtoc(SC6->C6_ENTREG)
			@ nLin, Pcol()+001 	PSAY "|"
			@ nLin, Pcol()+000 	PSAY 0				Picture "@E 999,999.99"
			@ nLin, Pcol()+001 	PSAY "|"
			@ nLin, Pcol()+001 	PSAY Iif(SC6->C6_FORMATO=="1","C","T")
			@ nLin, Pcol()+005 	PSAY "|"
			
			xTOTAL[1] := xTOTAL[1] + SC6->C6_QTDVEN
			xTOTAL[2] := xTOTAL[2] + NoRound(SC6->C6_VALOR,2)
			
			nLin   := nLin + 1
			nItens := nItens + 1
			
			
			DbSelectArea("SC6")
			DbSkip()
		EndIf
	EndDo
	
	nImpForm := nItForm - nItens
	
	For I:= 1 to nImpForm
		nLin := nLin + 1
		@ nLin, 000 PSAY "|"
		@ nLin, 005 PSAY "|"
		@ nLin, 020 PSAY "|"
		@ nLin, 026 PSAY "|"
		@ nLin, 049 PSAY "|"
		@ nLin, 058 PSAY "|"
		@ nLin, 071 PSAY "|"
		@ nLin, 084 PSAY "|"
		@ nLin, 097 PSAY "|"
		@ nLin, 108 PSAY "|"
		@ nLin, 120 PSAY "|"
		@ nLin, 128 PSAY "|"
		nLin := nLin + 1
	Next
	
	nLin := nLin + 1
	
	@ nLin, 000 PSAY "|"
	@ nLin, 005 PSAY "|"
	@ nLin, 020 PSAY "|"
	@ nLin, 026 PSAY "| TOTAL PEDIDO -->"
	@ nLin, 049 PSAY "|"
	@ nLin, 058 PSAY "|"
	@ nLin, 060 PSAY xTOTAL[1]  Picture"@E 999,999.99"
	@ nLin, 071 PSAY "|"
	@ nLin, 084 PSAY "|"
	@ nLin, 086 PSAY xTOTAL[2]  Picture"@E 999,999.99"
	@ nLin, 097 PSAY "|"
	@ nLin, 108 PSAY "|"
	@ nLin, 120 PSAY "|"
	@ nLin, 128 PSAY "|"
	nLin := nLin + 1
	@ nLin, 000 PSAY Repli("_",129)
	nLin := nLin + 1
	
	//----> imprime quadro de observacoes de credito e vendas
	@ nLin, 000 PSAY Repli("_",129)
	nLin := nLin + 1
	@ nLin, 000 PSAY "| Observacoes de Credito  "
	@ nLin, 064 PSAY "| | Observacoes de Vendas"
	@ nLin, 128 PSAY "|"
	nLin := nLin + 1
	@ nLin, 000 PSAY "| Risco: "+SA1->A1_RISCO
	@ nLin, 064 PSAY "| |"
	@ nLin, 068 PSAY SC5->C5_OBSVEN1
	@ nLin, 128 PSAY "|"
	nLin := nLin + 1
	@ nLin, 000 PSAY "|"
	@ nLin, 064 PSAY "| |"
	@ nLin, 068 PSAY SC5->C5_OBSVEN2
	@ nLin, 128 PSAY "|"
	nLin := nLin + 1
	@ nLin, 000 PSAY "|"
	@ nLin, 064 PSAY "| |"
	@ nLin, 128 PSAY "|"
	nLin := nLin + 1
	@ nLin, 000 PSAY Repli("_",129)
	nLin := nLin + 1
	
	//----> imprime quadro de observacoes para nota fiscal
	@ nLin, 000 PSAY Repli("_",129)
	nLin := nLin + 1
	@ nLin, 000 PSAY "| Mensagem Para Nota Fiscal: "
	@ nLin, 128 PSAY "|"
	nLin := nLin + 1
	@ nLin, 000 PSAY "|"
	@ nLin, 002 PSAY SC5->C5_MENNOTA
	@ nLin, 128 PSAY "|"
	nLin := nLin + 1
	@ nLin, 000 PSAY "|"
	@ nLin, 128 PSAY "|"
	nLin := nLin + 1
	@ nLin, 000 PSAY Repli("_",129)
	
	//----> imprime quadro para anotacoes expedicao e quadro de assinaturas
	nLin := nLin + 1
	@ nLin, 000 PSAY Repli("_",129)
	nLin := nLin + 1
	@ nLin, 000 PSAY "| Anotacoes Expedicao"
	@ nLin, 090 PSAY "| DEPARTAMENTO |   DATA   |   VISTO   |"
	nLin := nLin + 1
	@ nLin, 000 PSAY "|"
	@ nLin ,090 PSAY "_______________________________________"
	nLin := nLin + 1
	@ nLin, 000 PSAY "| Data ____/____/____         Conferido Por _____________"
	@ nLin, 090 PSAY "| Digitacao    |          |           |"
	nLin := nLin + 1
	@ nLin, 000 PSAY "|"
	@ nLin ,090 PSAY "_______________________________________"
	nLin := nLin + 1
	@ nLin, 000 PSAY "| NFiscal _________  NFiscal _________  NFiscal _________"
	@ nLin, 090 PSAY "| Credito      |          |           |"
	nLin := nLin + 1
	@ nLin, 000 PSAY "|"
	@ nLin ,090 PSAY "_______________________________________"
	nLin := nLin + 1
	@ nLin, 000 PSAY "| Volume Total  _______       |__| Encapados   |__| Pecas"
	@ nLin, 090 PSAY "| Vendas       |          |           |"
	nLin := nLin + 1
	@ nLin, 000 PSAY "|"
	@ nLin ,090 PSAY "_______________________________________"
	nLin := nLin + 1
	@ nLin, 000 PSAY "| Data das Notas ____/____/____                          "
	@ nLin, 090 PSAY "| Faturamento  |          |           |"
	nLin := nLin + 1
	@ nLin, 000 PSAY Repli("_",129)
	nLin := nLin + 1
	@ nLin, 000 PSAY "| It | Qtde Mts |     | It | Qtde Mts |     | It | Qtde Mts |     | It | Qtde Mts |     | It | Qtde Mts |     | It | Qtde Mts   |"
	nLin := nLin + 1
	@ nLin, 000 PSAY Repli("_",129)
	nLin := nLin + 1
	@ nLin, 000 PSAY "|    |          |     |    |          |     |    |          |     |    |          |     |    |          |     |    |            |"
	nLin := nLin + 1
	@ nLin, 000 PSAY Repli("_",129)
	nLin := nLin + 1
	@ nLin, 000 PSAY "|    |          |     |    |          |     |    |          |     |    |          |     |    |          |     |    |            |"
	nLin := nLin + 1
	@ nLin, 000 PSAY Repli("_",129)
	nLin := nLin + 1
	@ nLin, 000 PSAY "|    |          |     |    |          |     |    |          |     |    |          |     |    |          |     |    |            |"
	nLin := nLin + 1
	@ nLin, 000 PSAY Repli("_",129)
	nLin := nLin + 1
	@ nLin, 000 PSAY "|    |          |     |    |          |     |    |          |     |    |          |     |    |          |     |    |            |"
	nLin := nLin + 1
	@ nLin, 000 PSAY Repli("_",129)
	nLin := nLin + 1
	@ nLin, 000 PSAY "|    |          |     |    |          |     |    |          |     |    |          |     |    |          |     |    |            |"
	nLin := nLin + 1
	@ nLin, 000 PSAY Repli("_",129)
	
	nImpForm := 0
	nItens   := 0
	nLin     := 0
	DbSelectArea("SC5")
	DbSkip()
EndDo

@ nLin, 000 PSAY " "

SetPrc(0,0)

RetIndex("SC5")

If aReturn[5] == 1
	Set Printer TO
	dbcommitAll()
	ourspool(wnrel)
Endif

Ms_Flush()

Return

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Fim do Programa                                                           *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function ValidPerg
Static Function ValidPerg()

DbSelectArea("SX1")
DbSetOrder(1)
If !DbSeek(cPerg)
	
	aRegs := {}
	
	Aadd(aRegs,{cPerg,'01','Do Pedidio     ? ','mv_ch1','C',06, 0, 0,'G', '', 'mv_par01','','','','','','','','','','','','','','',''})
	Aadd(aRegs,{cPerg,'02','Ate o Pedido   ? ','mv_ch2','C',06, 0, 0,'G', '', 'mv_par02','','','','','','','','','','','','','','',''})
	
	For i:=1 to Len(aRegs)
		Dbseek(cPerg+StrZero(i,2))
		If found() == .f.
			RecLock("SX1",.t.)
			For j:=1 to Fcount()
				FieldPut(j,aRegs[i,j])
			Next
			MsUnLock()
		EndIf
	Next
EndIf

Return()


Static Function BuscaCusto()

Local _nQtdBase	:=	0

dbSelectArea("SG1")
dbSetOrder(1)
If dbSeek(xFilial("SG1")+SC6->C6_PRODUTO,.f.)
	
	dbSelectArea("SZC")
	dbSetOrder(2)
	If dbSeek(xFilial("SZC")+SC6->C6_PRODUTO+SC5->C5_SERVICO,.f.)
		_cTipCob	:=	SZC->ZC_TIPCOB
	Else
		_cTipCob	:=	Iif(_cMod$"2207","K","M")
	EndIf
	
	While SG1->G1_COD == SC6->C6_PRODUTO
		
		_cTipo	:=	Posicione("SB1",1,xFilial("SB1")+SG1->G1_COMP,"B1_TIPO")
		
		If _cTipo$"KC KT TC TT"
			_nQtdBase	:=	SG1->G1_QUANT
			dbSelectarea("SG1")
			dbSkip()
		EndIf
		
		dbSelectarea("SG1")
		dbSkip()
	EndDo
	
	dbSeek(xFilial("SG1")+SC6->C6_PRODUTO,.f.)
	
	While SG1->G1_COD == SC6->C6_PRODUTO
		
		_cTipo	:=	Posicione("SB1",1,xFilial("SB1")+SG1->G1_COMP,"B1_TIPO")
		
		If _cTipo$"KC KT TC TT"
			dbSelectarea("SG1")
			dbSkip()
			loop
		EndIf
		
		
		_nCusto		:=	_nCusto	+	Iif(SG1->G1_FIXVAR$"V",((SG1->G1_QUANT/_nQtdBase)*SC6->C6_QTDVEN),SG1->G1_QUANT) * Posicione("SB1",1,xFilial("SB1")+SG1->G1_COMP,"B1_CUSTD")
		
		dbSelectarea("SG1")
		dbSkip()
	EndDo
Else
	MsgBox("O produto "+Alltrim(SC6->C6_PRODUTO)+" não possui estrutura cadastrada, portanto não será calculado o custo da receita.","Estrutura não Cadastrada","Stop")
	_cTipCob := ""
EndIf

_nConv	:=	Posicione("SB1",1,xFilial("SB1")+SC6->C6_PRODUTO,"B1_CONV")
_nCusto	:=	(_nCusto / Iif(_cTipCob$"K",(SC6->C6_QTDVEN * _nConv),SC6->C6_QTDVEN))

Return(_nCusto)
