#Include "Protheus.ch"

User Function RTMKG05()

    If  M->UA_VENDE == "1"
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
    EndIf

Return(M->UA_VENDE)
