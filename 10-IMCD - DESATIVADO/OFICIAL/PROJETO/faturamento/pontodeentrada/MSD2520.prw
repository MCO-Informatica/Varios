#include 'protheus.ch'


/*/{Protheus.doc} MSD2520
Esse ponto de entrada est� localizado na fun��o A520Dele(). 
� chamado antes da exclus�o do registro no SD2.
@type function
@version 1.0
@author marcio.katsumata
@since 13/05/2020
@return nil, nil
@see https://tdn.totvs.com/display/public/PROT/MSD2520
/*/
user function MSD2520()

    //--------------------------------------
    //Retira todas as informa��es de lote no
    //estorno do documento
    //---------------------------------------
    staticCall(M460DEL, retiraEnd)
    
return