#DEFINE _enter char(13)+char(10)

/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
北赏屯屯屯屯脱屯屯屯屯屯送屯屯屯淹屯屯屯屯屯屯屯屯屯退屯屯屯淹屯屯屯屯屯屯槐蓖屯淹屯屯屯屯屯屯屯屯北
北+-------------+----------------+-----------------------+----------+----------------------------+北
北|Programa		|PE01NFESEFAZ()	 |  Connit - Vanilson    |  Data	|    09/11/11	 			 |北
北+-------------+----------------+-----------------------+----------+----------------------------+北
北|			 	|  Ponto de entrada localizado na fun玢o XmlNfeSef do rdmake NFESEFAZ. 			 |北
北|	Descri玢o	|  Atrav閟 deste ponto � poss韛el realizar manipula珲es nos dados do produto, 	 |北
北|				|  mensagens adicionais, destinat醨io, dados da nota, pedido de venda ou compra, |北
北|				|  antes da montagem do XML, no momento da transmiss鉶 da NFe.					 |北
北+-------------+--------------------------------------------------------------------------------|北
北|Sintaxe      | FISR001()	 		                                      						 |北
北+-------------+--------------------------------------------------------------------------------+北
北|Par鈓etros   | N鉶 tem									              					     |北
北+-------------+--------------------------------------------------------------------------------+北
北|Retorno      | Array													  						 |北
北+-------------+--------------------------------------------------------------------------------+北
北|Uso          | Especifico para Laselva                                 						 |北
北+-------------+--------------------------------------------------------------------------------+北
北韧屯屯屯屯拖屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯图北
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
*/

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 25/09/2012	alexandre	altera玢o para verificar se o nro do complemento � igual ao right do endere鏾. se for, deixa o complemnto (aDesc[4]) em branco
// 25/09/2012   alexandre   altera玢o anterior comentada
// 15/01/2014   Thiago      altera玢o para trazer o codigo ean como informa玢o adicional do produto, preenchendo a tag InfAdProd do XML
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function PE01NFESEFAZ()
////////////////////////////

Local   aProd		:= aParam[01]
Local   cMensCli	:= aParam[02]
Local   cMensFis	:= aParam[03]
Local   aDest 		:= aParam[04]
Local   aNota 		:= aParam[05]
Local   aInfoItem	:= aParam[06]
Local   aDupl		:= aParam[07]
Local   aTransp		:= aParam[08]
Local   aEntrega	:= aParam[09]
Local   aRetirada	:= aParam[10]
Local   aVeiculo	:= aParam[11]
Local   aReboque	:= aParam[12]

Local cTes			:= ""
Local cFormula		:= ""
Local cRoma	 		:= ""
Local cFilDes		:= ""
Local aRetorno		:= {}
Local aArea			:= GetArea()
Local EMAIL
/*
If alltrim(aDest[4]) == right(alltrim(aDest[3]), len(alltrim(aDest[4])))
	aDest[3] := left(alltrim(aDest[3]))
EndIf

For _nI := 1 to len(aProd)
	If empty(aProd[_nI,4])
		SB1->(dbSetOrder(1))
		If SB1->(MsSeek( xFilial("SB1") + aProd[_nI,2],.F.))
			aProd[_nI,4]  := SB1->B1_DESC
			aProd[_nI,25] := IIF(EMPTY(ALLTRIM(SB1->B1_CODBAR)),"",SB1->B1_CODBAR) // Codigo EAN
		EndIf
	EndIf
Next
*/
For _nI := 1 to len(aProd)
	// Se nao tiver descri玢o, atualiza com a descri玢o do cadastro de produtos
	If empty(aProd[_nI,4])
		SB1->(dbSetOrder(1))
		If SB1->(MsSeek( xFilial("SB1") + aProd[_nI,2],.F.))
			aProd[_nI,4]  := SB1->B1_DESC
			//aProd[_nI,25] := IIF(EMPTY(ALLTRIM(SB1->B1_CODBAR)),"",SB1->B1_CODBAR) // Codigo EAN
		EndIf
	EndIf
	// Atualiza a tag de informa玢o adicional com o codigo de barras (EAN) do produto
	SB1->(dbSetOrder(1))
	If SB1->(MsSeek( xFilial("SB1") + aProd[_nI,2],.F.))
		aProd[_nI,25] := IIF(EMPTY(ALLTRIM(SB1->B1_CODBAR)),"",SB1->B1_CODBAR) // Codigo EAN
		aProd[_nI][3] := IIF(EMPTY(ALLTRIM(SB1->B1_CODBAR)),SB1->B1_XCODBAR,SB1->B1_CODBAR) // Codigo EAN
	EndIf
Next

If !empty(aTransp) .and. aTransp[1] $ GetMv('LS_TRANSP')
	If empty(aDest[12])
		aDest[12] := aTransp[7]
	Else
		aDest[12] := aDest[12] + ";" + aTransp[7]
	Endif
Endif

If alltrim(aNota[1]) == "8"
	cRoma	 	:= Posicione("PA6",1, xFilial("PA6")+SC5->C5_NUM+SC5->C5_FILIAL,"PA6_NUMROM")	 // LSV - Verifica a exist阯cia de romaneio
	cFilDes	 	:= Posicione("PA6",1, xFilial("PA6")+SC5->C5_NUM+SC5->C5_FILIAL,"PA6_FILDES")
ElseIf alltrim(aNota[1]) == '9'
	cMensFis    := SF1->F1_DADOSAD
EndIf


/*
+-------------------------------------------------------------------------------------+
|Verifica se o EAN contido no produto � v醠ido, caso n鉶, substitui por: "" (Branco). |
+-------------------------------------------------------------------------------------+
*/
For i = 1 To Len(aProd)
	// Medida Paleativa, mesmo com o tratamento algumas NFs est鉶 dando erro de
	//If !vldCodBar(Left(Alltrim(aProd[i][3]),13))
	aProd[i][3] := IIF(EMPTY(ALLTRIM(SB1->B1_CODBAR)),SB1->B1_XCODBAR,SB1->B1_CODBAR) // Codigo EAN
	//EndIf
	
Next


/*
+-------------------------------------------------------------------------------------+
|Verifica se a NF possui um romaneio, caso sim, inclui nos dados adicionais da NF	  |
+-------------------------------------------------------------------------------------+
*/
If !Empty(cRoma)
	cMensCli +=	"Romaneio/Destino: " + cRoma + " - " + cFilDes
EndIf


aadd(aRetorno,aProd)
aadd(aRetorno,cMensCli)
aadd(aRetorno,cMensFis)
aadd(aRetorno,aDest)
aadd(aRetorno,aNota)
aadd(aRetorno,aInfoItem)
aadd(aRetorno,aDupl)
aadd(aRetorno,aTransp)
aadd(aRetorno,aEntrega)
aadd(aRetorno,aRetirada)
aadd(aRetorno,aVeiculo)
aadd(aRetorno,aReboque)

Return	aRetorno

/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北赏屯屯屯屯脱屯屯屯屯屯送屯屯屯淹屯屯屯屯屯屯屯屯屯退屯屯屯淹屯屯屯屯屯屯槐�
北+-------------+----------------+------------------+-------+-------------+北
北|Fun玢o 		|  vldCodBar	 |Vanilson - Connit | Data	| 01-11-2011  |北
北+-------------+----------------+------------------+-------+-------------+北
北|Descri玢o 	| Fun玢o utilizada para verificar se c骴igo EAN digitado  |北
北|             | � v醠ido.											      |北
北+-------------+---------------------------------------------------------+北
北|Sintaxe      |  vldCodBar( cCodBar ) 					   			  |北
北+-------------+---------------------------------------------------------+北
北|Par鈓etros   |  String com c骴igo EAN de 13 digitos		              |北
北+-------------+---------------------------------------------------------+北
北|Retorno      | .F. = Inv醠ido, .T. = V醠ido 					 		  |北
北+-------------+---------------------------------------------------------+北
北|Uso          | Programa principal				                      |北
北+-------------+---------------------------------------------------------+北
北韧屯屯屯屯拖屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯急�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
*/

Static Function vldCodBar( cCodBar )  //Efetua a Valida玢o de C骴igo de Barra tipo EAN13

Local nCalc   := 0
Local nDigito := 0
Local lVld    := .F.

For nX := Len( cCodBar ) -1 To 1 Step -1 // Multiplica da direita para esquerda as posi珲es PAR por 3 e as IMPAR por 1, somando todas no variavel nCalc
	
	If nX % 2 == 0
		nCalc += Val( SubsTR( cCodBar,nx,1 ) ) * 3
	Else
		nCalc +=  Val( SubsTR( cCodBar,nx,1 ) )
	EndIF
	
Next

//Ceiling arredonda para cima.
nDigito :=  ( Ceiling(nCalc/10) * 10 ) -  nCalc // O resultado da soma dos digitos � arredondado para o multiplo de 10 imediatamente superior, logo ap髎 subtraido do valor n鉶 arredondado.
lVld := IIF( SubsTR( cCodBar,13,1 ) == cValTochar( nDigito ), .T. , .F. )

Return lVld


