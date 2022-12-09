#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³F200ABAT  ºAutor  ³Opvs (David)        º Data ³  17/02/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de Entrada para ajustar o Banco Informado no Portador º±±
±±º          ³do Título ou mantem o Banco Informado nos Paramentros de Bx º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function F200ABAT

//Parametros Informados na Baixa do CNAB
Local cBancoPar	:= mv_par06
Local cAgenPar	:= mv_par07
Local cContPar 	:= mv_par08
//Informacoes de Portador do Título
Local cBancoSE1	:= SE1->E1_PORTADO
Local cAgenSE1	:= SE1->E1_AGEDEP
Local cContSE1 	:= SE1->E1_CONTA

//Retorna conta e agencia novamente
cBanco	:= IIf( Empty(cBancoSE1), cBancoPar, cBancoSE1 )
cAgencia:= IIf( Empty(cAgenSE1), cAgenPar, cAgenSE1 )
cConta	:= IIf( Empty(cContSE1), cContPar, cContSE1 )  

Return