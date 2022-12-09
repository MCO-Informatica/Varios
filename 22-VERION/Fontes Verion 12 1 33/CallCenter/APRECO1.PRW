#include "protheus.ch"
#INCLUDE "TOPCONN.CH"

user function APRECO1()

PUBLIC _cod
PUBLIC _VALOR
PUBLIC _cPROD := acols[n,2]
PUBLIC _cReturn 
public _nVALOR

//----------------------------------------------------------------------------------------------------------------------------//
//                                                                                                                            //
//									AVDTEC  -  YURI PORTO - 26/10/2013                                                        //
//                                                                                                                            //
//----------------------------------------------------------------------------------------------------------------------------//
//      		  					 PROGRAMA PARA ALTERAR Oconsultores PREÇO CONFORME A REGIÃO DO CLIENTE                               //
//     									  			ALIMENTA O CAMPO SB1->B1_PRV1                                             //
//													CONFORME VALOR DOS CAMPOS                               				  //
//    					  						 SB1->B1_VLFIM* (POR REGIÃO)    											  //
//												PARA SER USADO NA "SUB" (TELA CALL-CENTER)                                    //
//							NO FINAL DO PROGRAMA NECESSARIAMENTE ELE DEVOLVE A AREA PARA A TABELA SUB						  //
//----------------------------------------------------------------------------------------------------------------------------//

DbSelectArea("SA1")
Dbgotop()
dbsetorder(1)
Dbseek(Xfilial("SA1") + M->UA_CLIENTE)

//----------------------------------------------------------------------------------IDENTIFICA O ESTADO(UF)DO CLIENTE
//---------------------------SELECIONA O PRODUTO    consultores
dbSelectArea("SB1")
dbsetorder(1)
dbseek(Xfilial("SB1") + acols[n,2])

dbSelectArea("SA1")
dbsetorder(1)
dbseek(Xfilial("SA1") + M->UA_CLIENTE)

_VALOR := 0

IF SA1->A1_REGI == "1" 	//------------------------------------------------------------------------------CLIENTE SITUAÇÃO 3
	_VALOR := SB1->B1_VLFIM1
endif
IF SA1->A1_REGI == "2" 	//------------------------------------------------------------------------------CLIENTE SITUAÇÃO 3
	_VALOR := SB1->B1_VLFIM2
endif
IF SA1->A1_REGI == "3" 	//------------------------------------------------------------------------------CLIENTE SITUAÇÃO 3
	_VALOR := SB1->B1_VLFIM3
endif
IF SA1->A1_REGI == "4" 	//--------------------------------------------------------------------------CLIENTE SITUAÇÃO 4
	_VALOR := SB1->B1_VLFIM4
endif
IF SA1->A1_REGI =="5" 	//--------------------------------------------------------------------------CLIENTE SITUAÇÃO 5
	_VALOR := SB1->B1_VLFIM5
endif
IF SA1->A1_REGI == "6" 	//--------------------------------------------------------------------------CLIENTE SITUAÇÃO 6
	_VALOR := SB1->B1_VLFIM6
endif
IF SA1->A1_REGI == "7"	//--------------------------------------------------------------------------CLIENTE SITUAÇÃO 7
	_VALOR := SB1->B1_VLFIM7
EndIf

IF _VALOR = 0
	_VALOR = SB1->B1_VLBRUTO
ENDIF
//----------------------------------------------------------------------------------------------exceções


//--------------------------------------------------------------------------CLIENTE SITUAÇÃO 1
//------------------------------------SE É IMPORTADO E VENDIDOS PARA FORA DO ESTADO DE SP = ALIQ 1
If SB1->B1_ORIGEM == "1"
		If SA1->A1_EST <> "SP" 
			IF SA1->A1_TIPO <> "N" 
				_VALOR := SB1->B1_VLFIM1                                  
			ENDIF			
		EndIf
endif

//------------------------------------Não Contribuinte
IF SA1->A1_TIPO = "N" 
	_VALOR := SB1->B1_VLFIM5
endif                       

//------------------------DIFERIDO
//  Produto = Diferido sim  E cliente = Revendedor ou Industrial localizado em São Paulo = Alíquota 2
If SB1->B1_DIFERIM = "S"
	If SA1->A1_EST == "SP" 
		If SA1->A1_TIPO ="I" .OR. SA1->A1_TIPO ="R"
			_VALOR := SB1->B1_VLFIM2
		EndIf
	EndIf
endif

//--------------------------------------------------------------------grava o valor correto PARA VENDA
DbSelectArea("SB1")
RECLOCK("SB1",.F.)
 SB1->B1_PRV1:=_VALOR
MSUNLOCK()
SB1->(DbCloseArea())
SA1->(DbCloseArea())
_cReturn :=_VALOR
_VALOR := 0
                                                  
//--------------------------------------------------------------------RETORNA A  AREA DE TRABALHO "SUB"
dbSelectArea("SUB")
dbSetOrder(1)
Dbseek(Xfilial("SUB") + SUB->UB_NUM)
//_cReturn
return(_cReturn)
