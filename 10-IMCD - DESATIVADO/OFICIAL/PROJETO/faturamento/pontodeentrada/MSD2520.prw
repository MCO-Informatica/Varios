#include 'protheus.ch'


/*/{Protheus.doc} MSD2520
Esse ponto de entrada está localizado na função A520Dele(). 
É chamado antes da exclusão do registro no SD2.
@type function
@version 1.0
@author marcio.katsumata
@since 13/05/2020
@return nil, nil
@see https://tdn.totvs.com/display/public/PROT/MSD2520
/*/
user function MSD2520()

    //--------------------------------------
    //Retira todas as informações de lote no
    //estorno do documento
    //---------------------------------------
    staticCall(M460DEL, retiraEnd)
    
return