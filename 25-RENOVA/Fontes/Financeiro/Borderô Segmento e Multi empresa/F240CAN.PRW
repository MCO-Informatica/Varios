#INCLUDE "RwMake.CH"
#INCLUDE "Protheus.CH"
#INCLUDE "TopConn.CH"


////////////////////////////////////////////////////////////////////////////////////
//                                                                                //
//  Função:    F240CAN   										Módulo: SIGAFIN   //
//                                                                                //
//  Autor:     											Data: 06/06/2013          //
//                                                                                //
//  Descrição: Pontos de Entrada após exclusão do borderô.                        //
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
