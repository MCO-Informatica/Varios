
#INCLUDE "protheus.ch"
#INCLUDE "rwmake.ch"

//==========================================================================================================================================================
//Nelson Hammel - 14/09/11 - Ponto de entrada para incluir botao na lateral esquerda que libera atendimentos

User Function TMKBARLA()
Local aButtons := {}

AAdd(aButtons ,{ "S4WB005N"	,	{|| Liberar1()}, 'Liberar','Liberar'})

SetKey( VK_F4, { || SALDO1() 	} )
SetKey( VK_F2, { || TABDESC() 	} )
Return(aButtons)

//===============================================================================================================
Static Function Saldo1()

xPProduto	:= aScan(aHeader,{|x| AllTrim(x[2])=="UB_PRODUTO"})

DbSelectArea("SB1")
DbSetOrder(1)
DbSeek(xFilial("SB1")+aCols[N,xPProduto])
MaViewSB2(SB1->B1_COD)
DbCloseArea("SB1")

//===============================================================================================================
Static Function Liberar1()

CQuery := "SELECT * FROM " + RetSqlName("SZ3") + " SZ3 "
CQuery += "WHERE 	Z3_CODUSR	='"+__cUserId+"' "
CQuery += "AND SZ3.D_E_L_E_T_ = '' "
cQuery := ChangeQuery(cQuery)
MsAguarde({|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery),'TABSZ3', .F., .T.)},"Aguarde")

DbSelectArea("TABSZ3")

If TABSZ3->Z3_NIVEL>=5
	
	xPMtBlok2	:= aScan(aHeader,{|x| AllTrim(x[2])=="UB_MTBLOK2"})
	xPMtBlok3	:= aScan(aHeader,{|x| AllTrim(x[2])=="UB_MTBLOK3"})
	xPMtBlok4	:= aScan(aHeader,{|x| AllTrim(x[2])=="UB_MTBLOK4"})
	
	If M->UA_CANC<>"S"
		
		If MsgYesNo("ATENÇÃO! Deseja liberar o atendimento selecionado","")
			Iif (M->UA_OPER=="1",M->UA_FLAG :='3',)
			Iif (M->UA_1OPER=="1",M->UA_FLAG :='3',)
			Iif (M->UA_1OPER=="1",M->UA_OPER :='1',)
			Iif (M->UA_1OPER=="2",M->UA_FLAG :='3',)
			M->UA_IMP:=""
			M->UA_MTBLOK1 	:=""
			M->UA_MTBLOK2 	:=""
			M->UA_MTBLOK3 	:=""
			M->UA_MTBLOK4 	:=""
			M->UA_MTBLOK5 	:=""
			M->UA_MTBLOK6 	:=""
			M->UA_MTBLOK7 	:=""
			
			For _R:=1 to Len(Acols)
				aCols[_R,xPMtBlok2]:=""
				aCols[_R,xPMtBlok3]:=""
				aCols[_R,xPMtBlok4]:=""
			Next
			
			Alert("Processo concluido")
			
		EndIf
		
	EndIf
	
EndIf

DbCloseArea("SZ3")

Return

//===========================================================================================================================================================
Static Function TabDesc()

//=================================
//Variaveis

xArray		:={}
xPosProduto	:= aScan(aHeader,{|x| AllTrim(x[2])=="UB_PRODUTO"})
xEstNorte 	:= GETMV("MV_NORTE")
xGrupo		:=Alltrim(Posicione("SB1",1,xFilial("SB1")+aCols[n,xPosProduto],"B1_GRUPO"))
xEst		:=Alltrim(Posicione("SA1",1,xFilial("SA1")+M->UA_CLIENTE+M->UA_LOJA,"A1_EST"))
Iif (xEst=='SP', xRegiao := '1',Iif(xEst $ xEstNorte,xRegiao := '2',xRegiao := '3'))
xRegra		:=Alltrim(M->UA_X_CODRE)


//================================
//Query para trazer dados da tabela de regras de descontos

CQuery := "SELECT * FROM " + RetSqlName("SZ1") + " SZ1 "
CQuery += "WHERE 	Z1_CODIGO	='"+Alltrim(xRegra)+"' "
CQuery += "AND 		Z1_REGIAO	='"+Alltrim(xRegiao)+"' "
CQuery += "AND 		Z1_GRUPO	='"+Alltrim(xGrupo)+"' "
CQuery += "AND SZ1.D_E_L_E_T_ = '' "
CQuery += "ORDER BY Z1_ITEM "
MemoWrite("C:\query.txt",cQuery)
cQuery := ChangeQuery(cQuery)
MsAguarde({|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery),'TABSZ1', .F., .T.)},"Regra de Descontos")

DbSelectArea("TABSZ1")
DbGoTop()
While !Eof()
	Aadd(xArray,{TABSZ1->Z1_CODIGO,TABSZ1->Z1_GRUPO,TABSZ1->Z1_REGIAO,TABSZ1->Z1_VALATE,TABSZ1->Z1_DESC1,TABSZ1->Z1_DESC5,TABSZ1->Z1_DESC6,TABSZ1->Z1_PRZMED})
	DbSkip()
EndDo
DbCloseArea("TABSZ1")

//========================================================================================================================================================
//Janela para digitação de descontos

@120,100 to 400,900 Dialog oDlg1 Title "Regras de Desconto"
@25,030 Say "| Regra"
@25,060 Say "| Grupo"
@25,080 Say "| Região"
@25,100 Say "| Valor até"
@25,140 Say "| Desc Comerc"
@25,180 Say "| Desc ICM"
@25,220 Say "| Desc Cond Pagto"
@25,270 Say "| Prazo Médio"
@25,320 Say "| Desc Maximo"

@45,030 Say "| "+xArray[1,1]
@45,060 Say "| "+xArray[1,2]
@45,080 Say "| "+xArray[1,3]
@45,100 Say "| "+Str(xArray[1,4],9,2)
@45,140 Say "| "+Str(xArray[1,5],5,2)
@45,180 Say "| "+Str(xArray[1,6],5,2)
@45,220 Say "| "+Str(xArray[1,7],5,2)
@45,270 Say "| "+Str(xArray[1,8],3,0)
@45,320 Say Str((100-xArray[1,6]-xArray[1,5]-xArray[1,7]-100),6,2)
@55,030 Say "| "+xArray[2,1]
@55,060 Say "| "+xArray[2,2]
@55,080 Say "| "+xArray[2,3]
@55,100 Say "| "+Str(xArray[2,4],9,2)
@55,140 Say "| "+Str(xArray[2,5],5,2)
@55,180 Say "| "+Str(xArray[2,6],5,2)
@55,220 Say "| "+Str(xArray[2,7],5,2)
@55,270 Say "| "+Str(xArray[2,8],3,0)
@55,320 Say Str((100-xArray[2,6]-xArray[2,5]-xArray[2,7]-100),6,2)
@65,030 Say "| "+xArray[3,1]
@65,060 Say "| "+xArray[3,2]
@65,080 Say "| "+xArray[3,3]
@65,100 Say "| "+Str(xArray[3,4],9,2)
@65,140 Say "| "+Str(xArray[3,5],5,2)
@65,180 Say "| "+Str(xArray[3,6],5,2)
@65,220 Say "| "+Str(xArray[3,7],5,2)
@65,270 Say "| "+Str(xArray[3,8],3,0)
@65,320 Say Str((100-xArray[3,6]-xArray[3,5]-xArray[3,7]-100),6,2)
@75,030 Say "| "+xArray[4,1]
@75,060 Say "| "+xArray[4,2]
@75,080 Say "| "+xArray[4,3]
@75,100 Say "| "+Str(xArray[4,4],9,2)
@75,140 Say "| "+Str(xArray[4,5],5,2)
@75,180 Say "| "+Str(xArray[4,6],5,2)
@75,220 Say "| "+Str(xArray[4,7],5,2)
@75,270 Say "| "+Str(xArray[4,8],3,0)
@75,320 Say Str((100-xArray[4,6]-xArray[4,5]-xArray[4,7]-100),6,2)
Activate dialog oDlg1 centered


Return()

