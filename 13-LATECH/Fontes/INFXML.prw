#include "Protheus.ch"
#include "rwmake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³INFXML  ºAutor  ³Michel rabetti costa º Data ³  05/03/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Este programan tem como objetivo gerar informações refente º±±
±±º          ³    xml da nota em questão                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function INFXML()
Local cRet:=''                    

/*
dbSelectArea("SF2")
dbSetOrder(1)
IF SF2->(dbSeek(xFilial()+SE1->(E1_NUM+E1_PREFIXO)+SA1->(A1_COD+A1_LOJA)+' '+'N'))
cRet:=PADR(SF2->(F2_DOC+F2_SERIE),15)  
cRet+=STRZERO(SF2->F2_VALBRUT*100,13) 
cRet+=GravaData(SF2->F2_EMISSAO,.F.,5)
cRet+=PADR(SF2->F2_CHVNFE,44)
cRet+=SPACE(313)
ENDIF
*/
dbSelectArea("SF3")
dbSetOrder(5)
IF SF3->(dbSeek(xFilial()+SE1->(E1_NUM+E1_PREFIXO)+SA1->(A1_COD+A1_LOJA)))
cRet:=PADR(SF3->(F3_NFISCAL+F3_SERIE),15)  
cRet+=STRZERO(SF3->F3_VALBRUT*100,13) 
cRet+=GravaData(SF3->F3_EMISSAO,.F.,5)
cRet+=PADR(SF3->F3_CHVNFE,44)
cRet+=SPACE(313)
ENDIF

Return(cRet)
