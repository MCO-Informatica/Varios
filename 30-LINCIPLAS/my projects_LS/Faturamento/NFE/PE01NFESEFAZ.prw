#DEFINE _enter char(13)+char(10)

/*
����������������������������������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ����������������������ͱ�
��+-------------+----------------+-----------------------+----------+----------------------------+��
��|Programa		|PE01NFESEFAZ()	 |  Connit - Vanilson    |  Data	|    09/11/11	 			 |��
��+-------------+----------------+-----------------------+----------+----------------------------+��
��|			 	|  Ponto de entrada localizado na fun��o XmlNfeSef do rdmake NFESEFAZ. 			 |��
��|	Descri��o	|  Atrav�s deste ponto � poss�vel realizar manipula��es nos dados do produto, 	 |��
��|				|  mensagens adicionais, destinat�rio, dados da nota, pedido de venda ou compra, |��
��|				|  antes da montagem do XML, no momento da transmiss�o da NFe.					 |��
��+-------------+--------------------------------------------------------------------------------|��
��|Sintaxe      | FISR001()	 		                                      						 |��
��+-------------+--------------------------------------------------------------------------------+��
��|Par�metros   | N�o tem									              					     |��
��+-------------+--------------------------------------------------------------------------------+��
��|Retorno      | Array													  						 |��
��+-------------+--------------------------------------------------------------------------------+��
��|Uso          | Especifico para Laselva                                 						 |��
��+-------------+--------------------------------------------------------------------------------+��
������������������������������������������������������������������������������������������������ͼ��
����������������������������������������������������������������������������������������������������
*/

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 25/09/2012	alexandre	altera��o para verificar se o nro do complemento � igual ao right do endere�o. se for, deixa o complemnto (aDesc[4]) em branco
// 25/09/2012   alexandre   altera��o anterior comentada
// 15/01/2014   Thiago      altera��o para trazer o codigo ean como informa��o adicional do produto, preenchendo a tag InfAdProd do XML
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
	// Se nao tiver descri��o, atualiza com a descri��o do cadastro de produtos
	If empty(aProd[_nI,4])
		SB1->(dbSetOrder(1))
		If SB1->(MsSeek( xFilial("SB1") + aProd[_nI,2],.F.))
			aProd[_nI,4]  := SB1->B1_DESC
			//aProd[_nI,25] := IIF(EMPTY(ALLTRIM(SB1->B1_CODBAR)),"",SB1->B1_CODBAR) // Codigo EAN
		EndIf
	EndIf
	// Atualiza a tag de informa��o adicional com o codigo de barras (EAN) do produto
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
	cRoma	 	:= Posicione("PA6",1, xFilial("PA6")+SC5->C5_NUM+SC5->C5_FILIAL,"PA6_NUMROM")	 // LSV - Verifica a exist�ncia de romaneio
	cFilDes	 	:= Posicione("PA6",1, xFilial("PA6")+SC5->C5_NUM+SC5->C5_FILIAL,"PA6_FILDES")
ElseIf alltrim(aNota[1]) == '9'
	cMensFis    := SF1->F1_DADOSAD
EndIf


/*
+-------------------------------------------------------------------------------------+
|Verifica se o EAN contido no produto � v�lido, caso n�o, substitui por: "" (Branco). |
+-------------------------------------------------------------------------------------+
*/
For i = 1 To Len(aProd)
	// Medida Paleativa, mesmo com o tratamento algumas NFs est�o dando erro de
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
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
��+-------------+----------------+------------------+-------+-------------+��
��|Fun��o 		|  vldCodBar	 |Vanilson - Connit | Data	| 01-11-2011  |��
��+-------------+----------------+------------------+-------+-------------+��
��|Descri��o 	| Fun��o utilizada para verificar se c�digo EAN digitado  |��
��|             | � v�lido.											      |��
��+-------------+---------------------------------------------------------+��
��|Sintaxe      |  vldCodBar( cCodBar ) 					   			  |��
��+-------------+---------------------------------------------------------+��
��|Par�metros   |  String com c�digo EAN de 13 digitos		              |��
��+-------------+---------------------------------------------------------+��
��|Retorno      | .F. = Inv�lido, .T. = V�lido 					 		  |��
��+-------------+---------------------------------------------------------+��
��|Uso          | Programa principal				                      |��
��+-------------+---------------------------------------------------------+��
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
*/

Static Function vldCodBar( cCodBar )  //Efetua a Valida��o de C�digo de Barra tipo EAN13

Local nCalc   := 0
Local nDigito := 0
Local lVld    := .F.

For nX := Len( cCodBar ) -1 To 1 Step -1 // Multiplica da direita para esquerda as posi��es PAR por 3 e as IMPAR por 1, somando todas no variavel nCalc
	
	If nX % 2 == 0
		nCalc += Val( SubsTR( cCodBar,nx,1 ) ) * 3
	Else
		nCalc +=  Val( SubsTR( cCodBar,nx,1 ) )
	EndIF
	
Next

//Ceiling arredonda para cima.
nDigito :=  ( Ceiling(nCalc/10) * 10 ) -  nCalc // O resultado da soma dos digitos � arredondado para o multiplo de 10 imediatamente superior, logo ap�s subtraido do valor n�o arredondado.
lVld := IIF( SubsTR( cCodBar,13,1 ) == cValTochar( nDigito ), .T. , .F. )

Return lVld

