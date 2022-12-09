#Include "Protheus.ch"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GP010FIMPE  ºAutor  ³Felipe Valenca    º Data ³  10-25-12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada para incluir um Recurso quando for       º±±
±±º          ³ incluido um funcionario.                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function GP010FIMPE()

    Local cCodRec := ""
    Local _aArea  := GetArea()

    If INCLUI

        dbSelectArea("AE8")
        RecLock("AE8",.T.)
        AE8->AE8_FILIAL := xFilial("AE8")
        AE8->AE8_RECURS := "SRA"+SRA->RA_FILIAL+SRA->RA_MAT
        AE8->AE8_DESCRI := SRA->RA_NOME
        AE8->AE8_TIPO	:= "2" //Trabalho
        AE8->AE8_UMAX 	:= 100
        AE8->AE8_CALEND := "001"
        AE8->AE8_EMAIL  := SRA->RA_EMAIL
        AE8->AE8_ATIVO  := "1"
        AE8->AE8_PRODUT := "MOF"
        AE8->AE8_CODFUN := SRA->RA_MAT
        AE8->AE8_FUNCAO := SRA->RA_CODFUNC
        MsUnlock()
        RestArea(_aArea)

    Elseif ALTERA

//	dbSelectArea("AE8")
//	dbSetOrder(5)
//	If dbSeek(xFilial("AE8")+SRA->RA_CODFUNC,.F.)                                                          

// ALTERADO O INDICE, DEVIDO A MUDANCA DO CODIGO DO RECURSO. MVG CONSULTORIA FELIPE VALENCA -- 20121207 -- 	
        dbSelectArea("AE8")
        dbSetOrder(1)
        If dbSeek('  '+'SRA'+SRA->RA_FILIAL+SRA->RA_MAT,.F.)

            RecLock("AE8",.F.)
            AE8->AE8_DESCRI := SRA->RA_NOME
            AE8->AE8_TIPO	:= "2" //Trabalho
            AE8->AE8_UMAX 	:= 100
            AE8->AE8_CALEND := "001"
            AE8->AE8_EMAIL  := SRA->RA_EMAIL
            AE8->AE8_ATIVO 	:= "1"
            AE8->AE8_CODFUN := SRA->RA_MAT
            AE8->AE8_FUNCAO := SRA->RA_CODFUNC
            MsUnlock()
        Else
            RecLock("AE8",.T.)
            AE8->AE8_RECURS := "SRA"+SRA->RA_FILIAL+SRA->RA_MAT
            AE8->AE8_DESCRI := SRA->RA_NOME
            AE8->AE8_TIPO	:= "2" //Trabalho
            AE8->AE8_UMAX 	:= 100
            AE8->AE8_CALEND := "001"
            AE8->AE8_EMAIL  := SRA->RA_EMAIL
            AE8->AE8_ATIVO 	:= "1"
            AE8->AE8_CODFUN := SRA->RA_MAT
            AE8->AE8_FUNCAO := SRA->RA_CODFUNC
            MsUnlock()
        Endif

        RestArea(_aArea)
    Elseif EXCLUI

        dbSelectArea("AE8")
        dbSetOrder(1)
        If dbSeek('  '+'SRA'+SRA->RA_FILIAL+SRA->RA_MAT,.F.)

            RecLock("SRA",.F.)
            dbDelete()
            MsUnlock()

        Endif

    Endif

Return