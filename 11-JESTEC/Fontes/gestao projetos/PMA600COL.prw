#INCLUDE "PROTHEUS.CH"


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PMA600COL    �Autor  �Felipe Valenca   � Data �  15/03/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de Entrada para gravar o AFC_EDT no pedido de venda. ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/


User Function PMA600COL
    Local _aHeadC6

    If AllTrim(_aHeadC6[nX,2]) == "C6_EDTPMS"
        aColsC6[nY,nX] := AFC->AFC_EDT
    Endif


    _aHeadC6 := {}
    dbSelectArea("SX3")
    dbSetOrder(1)
    MsSeek("SC6",.T.)
    While ( !Eof() .And. SX3->X3_ARQUIVO == "SC6" )
        If ( X3Uso(SX3->X3_USADO) .And.;
                !Trim(SX3->X3_CAMPO)=="C6_EDTPMS" .And.;
                cNivel >= SX3->X3_NIVEL )

            Aadd(_aHeadC6,{ Trim(SX3->X3_TITULO),;
                SX3->X3_CAMPO,;
                SX3->X3_PICTURE,;
                SX3->X3_TAMANHO,;
                SX3->X3_DECIMAL,;
                SX3->X3_VALID,;
                SX3->X3_USADO,;
                SX3->X3_TIPO,;
                SX3->X3_ARQUIVO,;
                SX3->X3_CONTEXT })
        EndIf
        dbSelectArea("SX3")
        dbSkip()
    EndDo

Return
