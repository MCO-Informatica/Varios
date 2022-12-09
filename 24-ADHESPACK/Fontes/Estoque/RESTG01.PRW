#include "totvs.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma          ³ RESTG01              º Analista    ³ Luiz Suguiura                          º  Data  ³     26/09/2021  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao         ³ Gatilho utilizado para retornar o codigo do produto a partir da combinacao:                            º±±
±±º                  ³ Cliente (B1_XCLIENT) + Tipo (B1_TIPO) + Sub-Tipo (B1_XSUBTIP) + Grupo (B1_GRUPO) + Sequencial          º±±   
±±º                  ³                                                                                                        º±± 
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso               ³ Exclusivo : Air Catering                                                                               º±±  
±±º                  ³                                                                                                        º±±  
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Definicao da Funcao de gatilho RESTG01                                                                                     //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

User Function RESTG01()

Local aSaveArea := GetArea()
Local cRet := ""
cMsg := ""

if Empty(Alltrim(M->B1_XCLIENT)) .OR. Empty(AllTrim(M->B1_TIPO)) .or. Empty(AllTrim(M->B1_XSUBTIP)) .or. Empty(AllTrim(M->B1_GRUPO))
   Alert("Algum campo obrigatório não foi preenchido. Favor revisar.")
   Return(cRet)
endif

cRet := Subs(M->B1_XCLIENT,3,4) + M->B1_TIPO + M->B1_XSUBTIP + M->B1_GRUPO
             
dbSelectArea("SB1")
dbSetOrder(1)
if !dbSeek(xFilial("SB1")+cRet)
   cRet += "001"
else
   dbSeek(xFilial("SB1")+cRet)
   while Subs(M->B1_XCLIENT,3,4) + M->B1_TIPO + M->B1_XSUBTIP + M->B1_GRUPO == Subs(SB1->B1_XCLIENT,3,4) + SB1->B1_TIPO + SB1->B1_XSUBTIP + SB1->B1_GRUPO
      cCodAtu := SB1->B1_COD  
      DBSkip()
   enddo
   cSeq := SubStr(cCodAtu,13,3)
   if cSeq = "999"
      cMsg := "Atenção: Para esse sequenciamento '"+cRet+"' já se esgotaram as 999 possibilidades."+chr(13)+"Escolha outra combinação de Cliente, Tipo, Sub-Tipo e Grupo."
      MessageBox(cMsg,"Erro de Codificação",16)
      cRet := ""
   else
      cSeq := StrZero(Val(cSeq)+1,3)
      cRet += cSeq
   endif
endif

RestArea(aSaveArea)
                       
Return(cRet)   
