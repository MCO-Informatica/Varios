
#INCLUDE "protheus.ch"
#INCLUDE "rwmake.ch"

//==========================================================================================================================================================
//Nelson Hammel - 13/10/11 - Ponto de entrada para mudar cores no Mbrowse TMK271

User Function Tk271Cor(cPasta)

Local aArea  := GetArea()                                                                                     //marrom = cinza
Local aCores := {}

If cPasta == '2' //Televendas

aCores  := {{"(Val(SUA->UA_OPER)==3 .And. Val(SUA->UA_FLAG)==2 .and. SUA->UA_CANC <> 'S'  	)"	,"BR_MARRON"	},; //(Atendimento)				MARROM
			{"(Val(SUA->UA_OPER)==3 .And. Val(SUA->UA_FLAG)==2 .and. SUA->UA_CANC <> 'S'	)"	,"BR_MARRON"	},; //(Atendimento)				MARROM
			{"(Val(SUA->UA_OPER)==3 .And. Val(SUA->UA_FLAG)==1 .and. SUA->UA_CANC <> 'S'	)"	,"BR_LARANJA"	},;	//(Fat Bloqueado) 			LARANJA
			{"(Val(SUA->UA_OPER)==2 .And. Val(SUA->UA_FLAG)==1 .and. SUA->UA_CANC <> 'S'	)"	,"BR_LARANJA"	},;	//(Fat Bloqueado) 			LARANJA
			{"(Val(SUA->UA_OPER)==1 .And. Val(SUA->UA_FLAG)==2 .and. SUA->UA_CANC <> 'S' .And. Val(SUA->UA_DOC)>0)"	,"BR_VERMELHO"	},;	//(Fat Não Bloqueado C\NF)	VERMELHO
			{"(Val(SUA->UA_OPER)==1 .And. Val(SUA->UA_FLAG)==3 .and. SUA->UA_CANC <> 'S' .And. Val(SUA->UA_DOC)>0)"	,"BR_VERMELHO"	},;	//(Fat Liberado C\ NF)		VERMELHO
			{"(Val(SUA->UA_OPER)==1 .And. Val(SUA->UA_FLAG)==2 .and. SUA->UA_CANC <> 'S' .And. Val(SUA->UA_DOC)==0)","BR_VERDE"		},;	//(Fat Não Bloqueado)		VERDE
			{"(Val(SUA->UA_OPER)==1 .And. Val(SUA->UA_FLAG)==3 .and. SUA->UA_CANC <> 'S' .And. Val(SUA->UA_DOC)==0)","BR_VERDE"		},;	//(Fat Liberado)			VERDE
			{"(Val(SUA->UA_OPER)==3 .And. Val(SUA->UA_FLAG)==4	) .and. SUA->UA_CANC <> 'S' "	,"BR_CINZA"		},;  //(Orçamento Bloqueado)	CINZA
			{"(Val(SUA->UA_OPER)==3 .And. Alltrim(SUA->UA_IMP)=='' .and. SUA->UA_CANC <> 'S'  )","BR_AZUL"		},; //(Orçamento Liberado)		AZUL
			{"(Val(SUA->UA_OPER)==3 .And. Val(SUA->UA_FLAG)==3	) .and. SUA->UA_CANC <> 'S'    ","BR_CINZA"		},;  //(Orçamento Bloqueado)	CINZA
			{"SUA->UA_CANC == 'S' "																,"BR_CANCEL"		}}  //(Cancelado)				PRETO

//			{"(Val(SUA->UA_OPER)==3 .And. Alltrim(SUA->UA_IMP)=='N'	)"							,"BR_CINZA"		},;  //(Orçamento Bloqueado)	CINZA
//			{"(Val(SUA->UA_OPER)==2 .And. Alltrim(SUA->UA_IMP)=='' 	)"							,"BR_AZUL"		},; //(Orçamento Não Bloqueado)	AZUL

EndIf
RestArea(aArea)

Return aCores
/*
aCores  := {{"(Val(SUA->UA_OPER)==3 .And. Val(SUA->UA_FLAG)==2 		.And. Val(SUA->UA_1OPER)==0)"							,"BR_MARRON"	},; //(Atendimento)				MARROM
			{"(Val(SUA->UA_OPER)==3 .And. Val(SUA->UA_FLAG)==2 		.And. Val(SUA->UA_1OPER)==3)"							,"BR_MARRON"	},; //(Atendimento)				MARROM
			{"(Val(SUA->UA_OPER)==3 .And. Val(SUA->UA_FLAG)==1 		.And. Val(SUA->UA_1OPER)==1)"							,"BR_LARANJA"	},;	//(Fat Bloqueado) 			LARANJA
			{"(Val(SUA->UA_OPER)==1 .And. Val(SUA->UA_FLAG)==2 		.And. Val(SUA->UA_1OPER)==1 .And. Val(SUA->UA_DOC)>0)"	,"BR_VERMELHO"	},;	//(Fat Não Bloqueado C\NF)	VERMELHO
			{"(Val(SUA->UA_OPER)==1 .And. Val(SUA->UA_FLAG)==3 		.And. Val(SUA->UA_1OPER)==1 .And. Val(SUA->UA_DOC)>0)"	,"BR_VERMELHO"	},;	//(Fat Liberado C\ NF)		VERMELHO
			{"(Val(SUA->UA_OPER)==1 .And. Val(SUA->UA_FLAG)==2 		.And. Val(SUA->UA_1OPER)==1 .And. Val(SUA->UA_DOC)==0)"	,"BR_VERDE"		},;	//(Fat Não Bloqueado)		VERDE
			{"(Val(SUA->UA_OPER)==1 .And. Val(SUA->UA_FLAG)==3 		.And. Val(SUA->UA_1OPER)==1 .And. Val(SUA->UA_DOC)==0)"	,"BR_VERDE"		},;	//(Fat Liberado)			VERDE
			{"(Val(SUA->UA_OPER)==3 .And. Alltrim(SUA->UA_IMP)==''  .And. Val(SUA->UA_1OPER)==2)"							,"BR_AZUL"		},; //(Orçamento Liberado)		AZUL
			{"(Val(SUA->UA_OPER)==2 .And. Alltrim(SUA->UA_IMP)=='' 	.And. Val(SUA->UA_1OPER)==2)"							,"BR_AZUL"		},; //(Orçamento Não Bloqueado)	AZUL
			{"(Val(SUA->UA_OPER)==3 .And. Alltrim(SUA->UA_IMP)=='N'	.And. Val(SUA->UA_1OPER)==2)"							,"BR_CINZA"		},;  //(Orçamento Bloqueado)	CINZA
			{"SUA->UA_CANC<>''"																								,"BR_PRETO"		}}  //(Cancelado)				PRETO
*/
