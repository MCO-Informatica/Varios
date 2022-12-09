#INCLUDE "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณJPMSA001     บAutor  ณFelipe Valenca   บ Data ณ  07-12-12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina para importar todo os Funcionarios para o cadastro  บฑฑ
ฑฑบ          ณ de Recursos.                                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function JPMSA001

    Local _aArea := {}

    cQuery := "Select * From "+RetSqlName("SRA")+" SRA "
    cQuery += "Where D_E_L_E_T_ = '' AND RA_SITFOLH <> 'D' AND RA_MSBLQL = '2' "

    If Select("TRB") > 0
        dbSelectArea("TRB")
        dbCloseArea()
    Endif

    DbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TRB", .F., .T.)

    dbSelectArea("TRB")
    dbGoTop()

    Do While !TRB->(Eof())
        _aArea := GetArea()

        dbSelectArea("AE8")
        dbSetOrder(1)
        If !dbSeek('  '+'SRA'+TRB->RA_FILIAL+TRB->RA_MAT,.F.)
            RecLock("AE8",.T.)
            AE8->AE8_FILIAL := xFilial("AE8")
            AE8->AE8_RECURS := "SRA"+TRB->RA_FILIAL+TRB->RA_MAT
            AE8->AE8_DESCRI := TRB->RA_NOME
            AE8->AE8_TIPO	:= "2" //Trabalho
            AE8->AE8_UMAX 	:= 100
            AE8->AE8_CALEND := "001"
            AE8->AE8_EMAIL  := TRB->RA_EMAIL
            AE8->AE8_ATIVO  := "1"
            AE8->AE8_PRODUT := "MOF"
            AE8->AE8_CODFUN := TRB->RA_MAT
            AE8->AE8_FUNCAO := TRB->RA_CODFUNC
            MsUnlock()
            RestArea(_aArea)
        Endif
        dbSelectArea("TRB")
        dbSkip()

    EndDo

Return