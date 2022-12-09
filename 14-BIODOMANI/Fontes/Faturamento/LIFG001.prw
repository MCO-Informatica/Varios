#Include "Protheus.ch"

User Function LIFG001()

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
    ElseIf  M->C5_VENDE == "3"
            M->C5_VEND1	:= ""
            M->C5_VEND2	:= ""
            M->C5_VEND3 := "EC0000"
    ElseIf	M->C5_VENDE =="4"
        M->C5_VEND1	:= ""
        M->C5_VEND2	:= ""
        M->C5_VEND3 := ""
    ElseIf  M->UA_VENDE == "1"
        If 	!Empty(SA1->A1_VEND)
            M->UA_VEND  := SA1->A1_VEND
            M->UA_VEND2 := ""
        Else
            ShowHelpDlg("Linha de Venda", {"Não foi possivel preencher o Vendedor Cosmobeauty."},5,{"Acesse o cadastro de cliente e preencha o vendedor."},5)
        EndIf
    ElseIf  M->UA_VENDE == "2"
        If !Empty(SA1->A1_VEND1)
            M->UA_VEND 	:= ""
            M->UA_VEND2	:= SA1->A1_VEND1
        Else
            ShowHelpDlg("Linha de Venda", {"Não foi possivel preencher o Vendedor Samana."},5,{"Acesse o cadastro de cliente e preencha o vendedor."},5)
        EndIf
    ElseIf	M->UA_VENDE == "3"
        M->UA_VEND 	:= ""
        M->UA_VEND2	:= ""
    Else
        ShowHelpDlg("Linha de Venda não Preenchido", {"Não foi possível preencher o Vendedor."},5,{"Preencha o campo Linha de Venda."},5)
    EndIf

Return
