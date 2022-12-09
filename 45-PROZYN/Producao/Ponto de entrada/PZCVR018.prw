#include "protheus.ch"
#include "report.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �PZCVR018		�Autor  �Guilherme	     � Data �  04/02/2021 ���
�������������������������������������������������������������������������͹��
���Desc.     � Solicita��o de Transfer�ncia.                			  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

 
User Function PZCVR018()
Local oReport
Local oNNT


 
Pergunte("REPORT",.F.)
 
DEFINE REPORT oReport NAME "PZCVR018" TITLE "RELATORIO DE MOVIMENTOS INTERNOS TRANSFERENCIA" PARAMETER "REPORT" ACTION {|oReport| PrintReport(oReport)}
 
    DEFINE SECTION oNNT OF oReport TITLE "Movimento interno Transferencia" TABLES "NNT" //TOTAL IN COLUMN //PAGE HEADER
    oNNT:SetPageBreak()
 
        //DEFINE CELL NAME "NNT_FILIAL"   OF oNNT ALIAS "NNT"
        DEFINE CELL NAME "NNT_PROD"     OF oNNT ALIAS "NNT"
        DEFINE CELL NAME "B1_DESC"      OF oNNT ALIAS "NNT"
        DEFINE CELL NAME "NNT_LOCAL"    OF oNNT ALIAS "NNT"
        DEFINE CELL NAME "NNT_LOCALI"   OF oNNT ALIAS "NNT"
        DEFINE CELL NAME "NNT_LOCDES"   OF oNNT ALIAS "NNT"
        DEFINE CELL NAME "NNT_QUANT"    OF oNNT ALIAS "NNT"
        DEFINE CELL NAME "NNT_LOTECT"   OF oNNT ALIAS "NNT"
         
 
    oReport:PrintDialog()
Return()
 
 
/*
�����������������������������������������������������������������������������
�����������������������������������s�����������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �PrintReport   �Autor  �Guilherme	     � Data �  04/02/2021 ���
�������������������������������������������������������������������������͹��
���Desc.     �P.E. Rotina MATA311 referente a Solicita��o de 			  ���
���          �Transfer�ncia.                                              ���
�������������������������������������������������������������������������͹��
���Uso       � Ap		                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
 

Static Function PrintReport(oReport)
#IFDEF TOP
    Local cAlias     := GetNextAlias()
    Local oNNT       := oReport:Section(1)
    Local cSql       := ""
    Local cValNS     := NNS->NNS_COD
    //Local cValNT     := POSICIONE("NNT",1,xFilial("NNT")+cValNS,"NNT_COD")  
 
    MakeSqlExp("REPORT")

    
        cSql := "%"+cSql+"%"
        BEGIN REPORT QUERY oNNT
     
        BeginSql alias cAlias
        SELECT  NNT_PROD, B1.B1_DESC, NNT_LOCAL, NNT_LOCALI, NNT_LOCDES, NNT_QUANT, NNT_LOTECT FROM %table:NNT% NNT
            INNER JOIN %table:SB1% B1 ON  B1.B1_COD = NNT_PROD
            INNER jOIN %table:NNS% NNS ON NNS_FILIAL = NNT_FILIAL AND NNS_COD = NNT_COD
            WHERE NNT.NNT_COD = %Exp:cValNS%
            AND B1.D_E_L_E_T_ = ' '
            AND NNT.D_E_L_E_T_ = ' '
        EndSql
        END REPORT QUERY oNNT
        oNNT:SetParentQuery()
        oNNT:Print()

#ENDIF
Return
