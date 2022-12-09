#include 'Protheus.ch'
#INCLUDE "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MT681AIN  ºAutor  ³Microsiga           º Data ³  21/11/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Apos Confirmação de Apontamento Modelo 2 e Campo Perda
				Maior que Zero.
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
                          
User Function MT681AIN()  
Local aArea := GetArea()

// Guarda Informações dos Parâmetros Atuais

cMV_PAR01 := MV_PAR01
cMV_PAR02 := MV_PAR02
cMV_PAR03 := MV_PAR03
cMV_PAR04 := MV_PAR04
cMV_PAR05 := MV_PAR05
cMV_PAR06 := MV_PAR06
cMV_PAR07 := MV_PAR07
cMV_PAR08 := MV_PAR08
cMV_PAR09 := MV_PAR09
cMV_PAR10 := MV_PAR10
cMV_PAR11 := MV_PAR11
cMV_PAR12 := MV_PAR12
cMV_PAR13 := MV_PAR13
cMV_PAR14 := MV_PAR14
cMV_PAR15 := MV_PAR15
cMV_PAR16 := MV_PAR16
cMV_PAR17 := MV_PAR17
cMV_PAR18 := MV_PAR18
cMV_PAR19 := MV_PAR19
cMV_PAR20 := MV_PAR20

If SH6->H6_PERDCUS > 0     
	SB1->(dbSetOrder(1), dbSeek(xFilial("SB1")+SH6->H6_PRODUTO))
	
	cCusmed:=GETMV("MV_CUSMED")
	cNumSeq := ''
	cNumSeq := GravaSBC(SH6->H6_OP,SH6->H6_OPERAC,SH6->H6_RECURSO,"MATA685")
	aPerda:={}
	aHdPerda:={}
Endif

MV_PAR01 := cMV_PAR01
MV_PAR02 := cMV_PAR02
MV_PAR03 := cMV_PAR03
MV_PAR04 := cMV_PAR04
MV_PAR05 := cMV_PAR05
MV_PAR06 := cMV_PAR06
MV_PAR07 := cMV_PAR07
MV_PAR08 := cMV_PAR08
MV_PAR09 := cMV_PAR09
MV_PAR10 := cMV_PAR10
MV_PAR11 := cMV_PAR11
MV_PAR12 := cMV_PAR12
MV_PAR13 := cMV_PAR13
MV_PAR14 := cMV_PAR14
MV_PAR15 := cMV_PAR15
MV_PAR16 := cMV_PAR16
MV_PAR17 := cMV_PAR17
MV_PAR18 := cMV_PAR18
MV_PAR19 := cMV_PAR19
MV_PAR20 := cMV_PAR20

RestArea(aArea)
Return Nil


// Ponto de entrada executado na gravação das movimentações internas referente a perda
// para preencher o campo D3_DOC com o numero da OP

User Function SBCDOCT()
cDocto := PARAMIXB[1]

cDocto := Left(SH6->H6_OP,8)

Return cDocto