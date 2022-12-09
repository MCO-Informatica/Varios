#Include "Protheus.ch"
#Include "RwMake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �JPMSG003  �Autor  �Felipe Valen�a      � Data �  14-11-12   ���
�������������������������������������������������������������������������͹��
���Desc.     � Gatilho para calculo da quantidade de horas do apontamento ���
���          � do projeto.                                                ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/


User Function JPMSG003

    Local nQtdHr := 0
    Local nSubHr := 0
    Local nPosTPH := aScan(aHeader,{|x| Alltrim(x[2]) == "AFU_XTPHOR"})
    Local nPosHrI := aScan(aHeader,{|x| Alltrim(x[2]) == "AFU_HORAI"})
    Local nPosHrF := aScan(aHeader,{|x| Alltrim(x[2]) == "AFU_HORAF"})
    Local nPosALM := aScan(aHeader,{|x| Alltrim(x[2]) == "AFU_XALMOC"})

    If M->AFU_HORAF <> Nil
        nSubHr := SubHoras(VAL(Transform(aCols[n][nPosHrF],"99.99")),VAL(Transform(aCols[n][nPosHrI],"99.99")))
        nQtdHr := SubHoras (nSubHr,Val(Transform(aCols[n][nPosAlm],"99.99")))
    Endif

Return nQtdHr