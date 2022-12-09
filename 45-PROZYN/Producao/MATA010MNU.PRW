
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MTA010MNU ºAutor  ³Newbridge           º Data ³  08/22/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ PE para tratar desbloqueio do cadastro de produto          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User function MTA010MNU()
    local aMenu := {}   

    Aadd(aRotina,      {"Desbloq. Prod.",     "U_MARKBLOE()"    , 0, 2 } ) 

Return AClone(aMenu)

User Function  MT010ALT()
    DbSelectArea("SB1")
    DbSetOrder(1)
    If DbSeek(xFilial("SB1") + SB1->B1_COD )
        RecLock("SB1",.F.)
        SB1->B1_MSBLQL := '1'
        SB1->B1_ATIVO :='N'
        MsUnlock()
    EndIf   

Return


User Function MARKBLOE() 
    local cLibUsr:= GetMV("MV_DBLPROD")
    Local cUsr   := RetCodUsr()

    If cUSr $ cLibUsr   

        DbSelectArea("SB1")
        DbSetOrder(1)
        If DbSeek(xFilial("SB1") + SB1->B1_COD )
            RecLock("SB1",.F.)
            SB1->B1_MSBLQL := '2'
            SB1->B1_ATIVO :='S'
            MsUnlock() 
        Endif
    else
        Alert("O Usuário Logado não tem permissão de acesso a esta Funcionalidade..")
    Endif
Return
