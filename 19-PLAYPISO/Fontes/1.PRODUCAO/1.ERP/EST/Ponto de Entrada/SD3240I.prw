/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSD3240I   บAutor  ณAlexandre Sousa     บ Data ณ  11/17/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณP.E. durante a gravacao do item na movimentacao interna.    บฑฑ
ฑฑบ          ณutilizado para sincronizar o saldo em estoque das filiais.  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณEspecifico LISONDA / ACTUAL                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function SD3240I()

	If !VerRot("U_AEST001") .and. !VerRot("AEST001")
		If GetAdvFVal("SF5","F5_TIPO",xFilial("SF5")+SD3->D3_TM,1,"N") == "R"
			Posicione("SB1",1,xFilial("SB1")+SD3->D3_COD,"B1_COD")
			//{quantidade,custo,ordem de producao,local,entidade,registro,tipo de movimento}
			//U_AEST001({SD3->D3_QUANT,0,"",SD3->D3_LOCAL,"D3",SD3->(Recno()),"501"})  //[Mauro Nagata, Actual Trend, 19/11/2010]
			U_AEST001({SD3->D3_QUANT,SD3->D3_CUSTO1,"",SD3->D3_LOCAL,"D3",SD3->(Recno()),"510",SD3->D3_DOC})       //definir um TM para esta movimentacao especifica
		Else
			Posicione("SB1",1,xFilial("SB1")+SD3->D3_COD,"B1_COD")                         
			//{quantidade,custo,ordem de producao,local,entidade,registro,tipo de movimento}
			//U_AEST001({SD3->D3_QUANT,SD3->D3_CUSTO1,"",SD3->D3_LOCAL,"D3",SD3->(Recno()),"300"})  //[Mauro Nagata, Actual Trend, 19/11/2010]
			U_AEST001({SD3->D3_QUANT,SD3->D3_CUSTO1,"",SD3->D3_LOCAL,"D3",SD3->(Recno()),"010",SD3->D3_DOC})       //definir um TM para esta movimentacao especifica
		EndIf
	EndIf

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษอออออออออออัออออออออออหอออออออัอออออออออออออออออออออออออออหออออัออออออออออปฑฑ
ฑฑบPrograma   ณ VerRot   บ Autor ณ Jaime Wikanski            บDataณ04.11.2002บฑฑ
ฑฑฬอออออออออออุออออออออออสอออออออฯอออออออออออออออออออออออออออสออออฯออออออออออนฑฑ
ฑฑบDescricao  ณ Verifica se estou na rotina desejada                         บฑฑ
ฑฑศอออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function VerRot(cRotina)
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de variaveis                     						  		 	 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local nActive   	:= 1
Local lExecRot 	:= .F.

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Verifica a origem da rotina               								ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
While !(PROCNAME(nActive)) == ""
   If Alltrim(Upper(PROCNAME(nActive))) $ Alltrim(Upper(cRotina))
      lExecRot := .T.
      Exit
   Endif
   nActive++
Enddo

Return(lExecRot)

