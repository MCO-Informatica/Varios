#Include "Protheus.ch"

User Function RFATG05()

Local _aArea    := GetArea()

DbSelectArea("SA1")
SA1->(DbSetOrder(1))

IF SA1->(DbSeek(xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI))

    If  M->C5_VENDE == "1"
        If 	!Empty(SA1->A1_VEND)
            M->C5_VEND1 := SA1->A1_VEND
            M->C5_VEND2 := ""
            M->C5_VEND3 := ""
        Else
            ShowHelpDlg("Linha de Venda", {"Não foi possivel preencher o Vendedor Cosmobeauty."},5,{"Acesse o cadastro de cliente e preencha o vendedor."},5)
        EndIf
    ElseIf  M->C5_VENDE == "2"
        If !Empty(SA1->A1_VEND1)
            M->C5_VEND1	:= ""
            M->C5_VEND2	:= SA1->A1_VEND1
            M->C5_VEND3 := ""
        Else
            ShowHelpDlg("Linha de Venda", {"Não foi possivel preencher o Vendedor Samana."},5,{"Acesse o cadastro de cliente e preencha o vendedor."},5)
        EndIf
    ElseIf	M->C5_VENDE == "3"
        M->C5_VEND1	:= ""
        M->C5_VEND2	:= ""
        M->C5_VEND3 := "EC0000"
    Else
        M->C5_VEND1	:= ""
        M->C5_VEND2	:= ""
        M->C5_VEND3 := ""
    EndIf

ENDIF

RestArea(_aArea)

Return(M->C5_VENDE)
