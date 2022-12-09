#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RENREVAPROV    º Autor ³ WELLINGTON MENDES  º Data ³  23/01/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ GATILHO NA REVISÃO PARA DEFINIR SE A MESMA VAI OU NÃO PARA
APROVAÇÃO
REGRA
CN9_APROV = 'BRANCO' - NAO VAI
CN9_APROV = 'GRUPO DE APROVAÇÃO - VAI PARA APROVAÇÃO                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ RENOVA                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function RENREVAPROV(_cTipRev,_UnidReqs)

Local _RetGroup := ''
Local _TipoRev:= GETMV("MV_XAPROV")//Tipos de Revisão que não tem necessidade de WorkFlow
Local _aArea   	:= GetArea()

IF 'REVCON'+_cTipRev $ _TipoRev .OR. 	M->CN9_ESPCTR == '2'
	_RetGroup:= '     ' //Sem grupo, não gera SCR para aprovação por WF.
Else //Volta o Grupo de aprovação da unidade requisitante. Foi feito dessa forma, pois o usuario pode digitar o tipo de revisão errado e trocar sem sair da tela.
	DbSelectArea("SY3")
	DbSetOrder(1)
	SY3->(DbSeek(xFilial("SY3")+ Alltrim(_UnidReqs)))
	_RetGroup := SY3->Y3_GRAPROV
Endif
RestArea(_aArea)
Return(_RetGroup)

