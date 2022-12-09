#include "rwmake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ EMP650   ºAutor  ³Alexandre A. Lima   º Data ³ 07/03/2013  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ PONTO DE ENTRADA PARA VERFICACAO E AJUSTE DOS LOCAIS DE    º±±
±±º          ³ EMPENHO DAS MAT.PRIMAS NA OP (MP. DE TERCEIRO OU PROPRIA)  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Exclusivo TSC                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAlteracao ³                                                		      º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function EMP650 // PONTO DE ENTRADA
Local aArea := GetArea()

/*
ESTRUTURA DO ACOLS
posicao     campos
01         Componente - Codigo do produto
02         Quantidade
03         Armazem
04         Sequencia da Estrutura
05         Sub-Lote
06         Lote
07         Validade do Lote (DATA)
08         Potencia
09         Endereco Fisico
10         Num.Serie
11         1a UM
12         Qtde 2a UM
13         2a UM
14         Descricao
15         Esta Deleta ou nao .t. ou .f.
*/

nPosLotCTL :=aScan(aHeader,{|x| AllTrim(x[2])=="D4_LOTECTL"})
nPosDValid :=aScan(aHeader,{|x| AllTrim(x[2])=="D4_DTVALID"})
nPosCod    :=aScan(aHeader,{|x| AllTrim(x[2])=="G1_COMP"})

FOR nIEmp := 1 TO LEN(ACOLS) 
	If SB1->(dbSetOrder(1), dbSeek(xFilial("SB1")+aCols[nIEmp,nPosCod]))
		If AllTrim(SB1->B1_TIPO) $ 'MO'
			aCols[nIEmp,Len(aCols[nIEmp])] := .T.
		ElseIf (AllTrim(SB1->B1_TIPO) $ 'BN' .And. SB1->B1_LOCPAD == 'SR')
			aCols[nIEmp,Len(aCols[nIEmp])] := .T.
		ElseIf AllTrim(SB1->B1_TIPO) $ 'MP'		// produtos do tipo MP Campo Lote e Validade Lote Devem Vir Vazios.
			aCols[nIEmp,nPosLotCTL] := ''
			aCols[nIEmp,nPosDValid] := CtoD('')
		EndIf
	Endif
NEXT 

RestArea(aArea)
RETURN