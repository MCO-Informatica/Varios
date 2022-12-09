#Include "Protheus.ch"
#Define NMAXPAGE 50

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ//
//Funcao      : VCNPJCLI()                                    //
//Objetivos   : Consulta especifica util. representantes   	//
//Desenv.  POR: JORGE SATO			    				//
//Data/Hora   : 09/11/15 		                      			//
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ//

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ//
//Funcao      : VCNPJCLI()                                    //
//Objetivos   : Consulta especifica util. representantes   	//
//Desenv.  POR: JORGE SATO			    				//
//Data/Hora   : 09/11/15 		                      			//
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ//

User Function VCNPJCLI() 
 
Local aAreaUso := GetArea() // Guarda a Area 
Local aAreaSX6 := SX6->( GetArea() )
Local cMvGrp 		:= SuperGetMV("MV_GRPREP",,"") 
Private cMv_CNPJVAL := "1"
Private cMv_VCNPJ   := "2"
 
PswOrder(1)
PSWSeek(__CUSERID, .T.) 
aUser      	:= PswRet(1)
IdUsuario  	:= aUser[1][1]  	// codigo do usuario     
GrpUser		:= IIF(LEN(aUser[1][10]) > 0 , aUser[1][10][1], "000000") 	// Grupo Que o usuario Pertence

// só funciona com o usuario diferente do administrador e que tenho o grupo 000023
// para testar não pode ser via DEBUG

If GrpUser $ cMvGrp
	PutMv("MV_VALCNPJ", cMv_VCNPJ) 
Else
	PutMv("MV_VALCNPJ", cMv_CNPJVAL) 
EndIf	 
RestArea( aAreaSX6 )
RestArea( aAreaUso )

MATA030()

PutMv("MV_VALCNPJ", cMv_CNPJVAL)
RestArea( aAreaSX6 )

return()