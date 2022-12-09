#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TKGRPED   ºAutor  ³Rodrigo Cirne de Andradeº Data ³  10/07/2009 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Validacao do Endereco de Entrega Antes da Confirmacao do Pedido º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Health Tech                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function TKGRPED()

    Local cMsg     := "Atenção:Informações obrigatórias não preenchidas:"
    Local lRet     := .F.
    Local aObrigat := {}
    Local nI       := 0
//Local aGrupo     := UsrRetGrp(,RetCodUsr())
//Local cGrupo     := ""

//if RetCodUsr() = "000000"                   
//   lSuperv:=.T.
//   cGrupo := "000018"
//endif      

//if len(aGrupo) >= 1 
//   if aGrupo[1] $ "000017;000018;000019" 
//      lSuperv:=.T.
//      cGrupo := aGrupo[1]
//   endif
//EndIf

    If M->UA_OPER$"3"
        lRet := .T.
        Return(lRet)
//ElseIf !Empty(AllTrim(M->UA_TRANSP))
//   lRet := .T.
//Else
//   cMsg := "Atenção: Transportadora não informada."+chr(13)+chr(10)+"Preenchimento obrigatório, favor informar."
//   MessageBox(cMsg, "Falta de informação",16) 
    EndIf

    if Empty(AllTrim(M->UA_X_EMPFA))
        Aadd(aObrigat, "Emp Fat")
        nI++
    Endif
    if Empty(AllTrim(M->UA_X_ARMAZ))
        Aadd(aObrigat, "Armazem")
        nI++
    Endif
    if Empty(AllTrim(M->UA_DF))
        Aadd(aObrigat, "Docto Fiscal")
        nI++
    Endif
    if Empty(AllTrim(M->UA_XDIA))
        Aadd(aObrigat, "Nao Entregar")
        nI++
    Endif
    if Empty(AllTrim(M->UA_OBS1))
        Aadd(aObrigat, "Msg Pedido 1")
        nI++
    Endif
    if Empty(AllTrim(M->UA_FORMAPG))
        Aadd(aObrigat, "Forma PG")
        nI++
    Endif
//if Empty(AllTrim(M->UA_VENDE))
//   Aadd(aObrigat, "Linha Venda")
//   nI++
//Endif
    if Empty(AllTrim(M->UA_TRANSP))
        Aadd(aObrigat, "Transportadora")
        nI++
    Endif

    if nI = 0
        lRet :=.T.
    Else
        For nI := 1 to Len(aObrigat)
            if nI = 1
                cMsg += Chr(13)
            endif
            cMsg += Chr(13)+"   - "+aObrigat[nI]
        Next X
        lRet := .F.
        cMsg += Chr(10)+Chr(13)+"Corrija as informações e salve novamente."
        MessageBox(cMsg, "Falta de informação",16)
    Endif



Return(lRet)


