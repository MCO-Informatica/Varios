#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �F200VAR      � Autor � Isaque          � Data �  06/02/17   ���
�������������������������������������������������������������������������͹��
���Descricao � P.E. ALTERAR VALOR RECEBIDO QUANDO O ARQUIVO DE RETORNO VEM���
���          � COM VALOR RECEBIDO DESCONTADO O VALOR DA TARIFA BANCARIA	  ���
�������������������������������������������������������������������������͹��
���Uso       � Protheus 11                                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function F200VAR()
Local aValores 	:= PARAMIXB[01]
Local aArea 	:= GetArea()
Local cIdCnab	:= cNumTit
Local nValor	:=0
Local nVlLiq	:=nValRec-nJuros-nMulta

If !empty (cIdCnab)
    dbselectarea("SE1")
    dbsetorder(16)
    If dbseek(xfilial("SE1")+cIdCnab)
    	nValor := SE1->E1_VLCRUZ
    	If nValor > nVlLiq
    		nValRec := nValrec+nDespes
    	EndIf  
    	nDespes:=0
    EndIF
EndIF

RestArea(aArea)




RETURN

//aValores := ( { cNumTit, dBaixa, cTipo, cNsNum, nDespes, nDescont, nAbatim, nValRec, nJuros, nMulta, nOutrDesp, nValCc, dDataCred, cOcorr, cMotBan, xBuffer,dDtVc,{} })
