/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MT110TOk ³ Autor ³                       ³ Data ³30/09/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Ponto     ³ Ponto de Entrada na TudoOk da GetDados do MATA110.         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ RENOVA							                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

#include "rwmake.ch"
#include "TopConn.ch"

User Function MT110TOK

Local l_Ret     := .T.
Local a_Area   := GetArea("SC1")
Local _a_Area2   := GetArea("SY3")
Local nPosPrd  := Ascan(aHeader,{|x| Alltrim(x[2]) == "C1_PRODUTO"})
Local nPosQtd  := Ascan(aHeader,{|x| Alltrim(x[2]) == "C1_QUANT"})
Local nPosVlr  := Ascan(aHeader,{|x| Alltrim(x[2]) == "C1_VLESTIM"})
Local nPosTipo := Ascan(aHeader,{|x| Alltrim(x[2]) == "C1_XTIPO"})
Local aRegra   := {}
Local nValor   := 0
//Local cRegra   := GetMV("MV_XCOMCEN")
Local nValLimC := GetMv("MV_XVLCDEC")  // Valor limite para compras decentralizadas

If Inclui .or. Altera
	
	If Len(Alltrim(cUnidReq)) == 0
		Msgbox("Solicitação sem Unidade de Requisicao Preenchida!!!","A T E N Ç Ã O ","OK")
		l_Ret    := .F.
		
	Endif
	
	If Empty(_cAprovSC)
		Msgbox("O campo *Gestor U.Req*, não pode estar em branco! Por favor, dar um TAB do campo *Unid. Requis.*.","A T E N Ç Ã O ","OK")
		l_Ret    := .f.
	Endif
	
	DbselectArea("SY3")
	DbSetOrder(1)
	DbSeek( xFilial("SY3")+cUnidReq)
	
	If Empty(SY3->Y3_GRAPROV)
		Msgbox("Unidade requisitante sem o grupo de aprovação preenchida!!!","A T E N Ç Ã O ","OK")
		l_Ret    := .F.
	Endif
	/* Ja validado na SC
	If Empty(SY3->Y3_XAPROV)
	Msgbox("Unidade requisitante sem o aprovador de SC preenchido!!!","A T E N Ç Ã O ","OK")
	l_Ret    := .F.
	Endif
	*/
	
	_nTotSol := 0 //variavel para calcular o total da sc
	If l_Ret
		For _nIt := 1 TO Len(aCols)
			If !aCols[_nIt][Len(aHeader)+1]
				aCols[_nIt][aScan(aHeader,{|x| x[2] = "C1_GRAPROV"})]   := SY3->Y3_GRAPROV
				aCols[_nIt][aScan(aHeader,{|x| x[2] = "C1_XAPROV" })]   := SY3->Y3_XAPROSC
				// Apura do total da solicitação
				_nTotSol += (aCols[_nIt][nPosQtd] * aCols[_nIt][nPosVlr]) // Valor estimado
			Endif
		Next
	Endif
	
	// Define de acordo com o valor total da SC´s se o processo de compras será centralizado ou não
	
	If l_Ret
		_CTipoCen := iif(_nTotSol >= nValLimC ,'1','2') // 1-Centralizada - 2 - Centralizada
		For n_It := 1 TO Len(aCols)
			If !aCols[n_It][Len(aHeader)+1]
				aCols[n_It][nPosTipo]   := _CTipoCen
			Endif
		Next
	Endif
	
	lRegraGrExc := .F.
	// Verifica se o item obrigatoriamente é para compra centralizada
	If l_Ret
		For n_It := 1 TO Len(aCols)
			// Compara a origem, regras para produto importado
			_cOrigem := Posicione("SB1",1,xFilial("SB1")+aCols[n_It][nPosPrd],"B1_ORIGEM")
			If _cOrigem $ "1/6"
				lRegraGrExc := .T.
			Endif
			// Compara se o item deve ser centralizado independente do valor
			_cCompCen := Posicione("SB1",1,xFilial("SB1")+aCols[n_It][nPosPrd],"B1_XITEMC")// ITEM CENTRALIZADO
			If _cCompCen = '1'
				lRegraGrExc := .T.
			Endif
			
		Next n_It
	Endif
	
	// Atualiza do campo tipo de compra caso a regra de Sub Grupo/Modelo tenha sido atendida
	If l_Ret .and. lRegraGrExc
		For n_It := 1 TO Len(aCols)
			aCols[n_It][nPosTipo] := '1'
		Next n_It
	Endif
	
Endif

RestArea(_a_Area2)
RestArea(a_Area)

Return(l_Ret)