#include "protheus.ch"
                        
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³F200DB2   ºAutor  ³Microsiga           º Data ³  15/01/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ponto de entrada na gravacao das despesas de cobranca       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Verion                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function F200DB2()	

Local aArea	:= GetArea()
Local aArSa6:= SA6->(GetArea())
Local nRecSa6 := SA6->(Recno())                                                       
   
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Tratamento para despesa de cobranca, que devera ser³
//³incluido em outra conta corrente                   ³
//³(Cobranca Caucao Boston)                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Empty(SEE->EE_BCODESP) .and. !Empty(SEE->EE_AGDESP) .and. !Empty(SEE->EE_CCDESP)
	DbSelectArea("SA6")
	DbSetOrder(1)
	If MsSeek(xFilial("SA6")+SEE->EE_BCODESP+SEE->EE_AGDESP+SEE->EE_CCDESP)
	    RecLock("SE5",.F.)
	    SE5->E5_BANCO	:= SEE->EE_BCODESP
	    SE5->E5_AGENCIA := SEE->EE_AGDESP
	    SE5->E5_CONTA	:= SEE->EE_CCDESP
	    MsUnlock()	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄestaL¿
		//³Não será necessário alterar a AtuSalBco pois no FINA200 esta³
		//³rotina e chamada passando-se o banco, agencia e conta       ³
		//³do proprio SE5                                              ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄestaLÙ	   	
	Else
		Aviso("Comunicação bancária",;
		      "Banco designado para baixa das despesas de cobrança inválido. Verifique cadastro Parâmetros Bancos",;
		      {"&Ok"},,;
		      "Despesas Bancárias")
	EndIf
EndIf                           
               
// Reposiciona no SA6 de origem
DbSelectArea("SA6")
DbgoTo(nRecSa6)

RestArea(aArSa6)
RestArea(aArea)

Return()
