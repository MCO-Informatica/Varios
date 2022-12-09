#Include "totvs.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCSTA100   บ Autor ณ RENATO RUY BERNARDOบ Data ณ  17/04/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ VALIDAวรO PARA NAO ALTERAR QUANDO SE TRATA DE COMBO        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CERTISIGN                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User function CSTA100()

Local nCODGAR := aScan( aHeader,{|p| AllTrim(p[2])=="DA1_CODGAR"})
Local nCODPRO := aScan( aHeader,{|p| AllTrim(p[2])=="DA1_CODPRO"})
Local nQTDLOT := aScan( aHeader,{|p| AllTrim(p[2])=="DA1_QTDLOT"})
Local nITEM	  := aScan( aHeader,{|p| AllTrim(p[2])=="DA1_ITEM"})
Local nATIVO  := aScan( aHeader,{|p| AllTrim(p[2])=="DA1_ATIVO"})
Local nDatVig := aScan( aHeader,{|p| AllTrim(p[2])=="DA1_DATVIG"})
Local dDataAtu:= Date()
Local nI 	  := 0
Local lRet	  := .T.

//Se o produto atual e ativado
If aCols[N,nATIVO] == "1"
	//Renato Ruy - 
	aCols[N,nDatVig] := Iif(Empty(aCols[N,nDatVig]),date(),aCols[N,nDatVig])
	//Percorre todas as linhas procurando produto gar + faixa igual a atual
	For nI := 1 To Len(aCols)
		//N - numero da linha Atual
		If nI != N .And. aCols[N,nCODGAR] == aCols[nI,nCODGAR] .And. aCols[N,nQTDLOT] == aCols[nI,nQTDLOT] .And. aCols[nI,nATIVO] == "1" .And. !Empty(aCols[N,nCODGAR]) 
			lRet := .F.
			MsgInfo("Jแ existe cadastro ativo para este produto no item: " + aCols[nI,nITEM] )
		//Renato Ruy - 30/10/2017
		//Gera data de inicio da vigencia para nใo gerar duplicidade
		Elseif nI != N .And. aCols[nI,nATIVO] == "1" .And. aCols[N,nCODPRO] == aCols[nI,nCODPRO] .And. aCols[N,nDatVig] == aCols[nI,nDatVig]
			aCols[N,nDatVig] := aCols[N,nDatVig] - 1
		Endif
	Next
Endif

Return lRet
