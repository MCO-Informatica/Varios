#INCLUDE "RwMake.CH"
#INCLUDE "Protheus.CH"
#INCLUDE "TopConn.CH"


////////////////////////////////////////////////////////////////////////////////////
//                                                                                //
//  Fun??o:    F240CAN   										M?dulo: SIGAFIN   //
//                                                                                //
//  Autor:     											Data: 06/06/2013          //
//                                                                                //
//  Descri??o: Pontos de Entrada ap?s exclus?o do border?.                        //
//             Utilizado para limpar o campo E2_IDCNAB                            //
//                                                                                //
//////////////////////////////////////////////////////////////////////////////////// 


User Function F240CAN()

If !Empty(SE2->E2_IDCNAB)
	RecLock("SE2",.F.)
	SE2->E2_IDCNAB := ""
	msUnlock()
End If

Return()
