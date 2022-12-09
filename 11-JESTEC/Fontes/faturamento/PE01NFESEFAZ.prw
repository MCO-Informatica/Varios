#INCLUDE "PROTHEUS.CH"
/*
�����������������������������������������������������������������������������
���Programa  � PE01NFESEFAZ �Autor� SERGIO JUNIOR    � Data �11/06/2014   ���
�������������������������������������������������������������������������͹��
���Desc.     � P.E. NA ROTINA NFESEFAZ PARA TRATAR OS DADOS ANTES DA      ���
���          � MONTAGEM DO XML.                                           ���
���          � PARAMETROS RECEBIDOS NO PARAMIXB:                          ���
���          � {aProd, cMensCli, cMensFis, aDest, aNota, aInfoItem,       ���
���          � aDupl, aTransp, aEntrega, aRetirada, aVeiculo, aReboque}   ���
�������������������������������������������������������������������������͹��
���Uso       � CLIENTE - JESTEC                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/                            
User Function PE01NFESEFAZ()
    Local aMatriz   	:= PARAMIXB
    Local cMensCli  	:= aMatriz[2]


// Observacao Nota Fiscal
    If !(SC5->C5_XMENNOT $ cMensCli)
        If Len(cMensCli) > 0 .And. SubStr(cMensCli, Len(cMensCli), 1) <> " "
            cMensCli += " "
        EndIf
        cMensCli += SC5->C5_XMENNOT
    EndIf

// ATUALIZA A MENSAGEM FISCAL DA NOTA
    aMatriz[2] += cMensCli

Return aMatriz