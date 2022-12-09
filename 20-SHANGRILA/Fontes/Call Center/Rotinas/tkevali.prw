
#INCLUDE "protheus.ch"
#INCLUDE "rwmake.ch"

//==========================================================================================================================================================
//Nelson Hammel - 02/09/11 - Validações de linhas

User Function TKEVALI()

Local lReturn := .T.
xDescMax:=0


_cTES		:=	aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "UB_TES"})]
_cProduto	:=	aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "UB_PRODUTO"})]
_cLocal	:=	aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "UB_LOCAL"})]

If Subs(_cProduto,1,1)$"Z"
 	If _cTES < '600' .Or. _cTES > '699'
   		MsgStop("TES informada fora do range 600 à 699 não é permitido.","TES Errada")
   		lReturn := .f.
   	EndIf
   	
   	If Posicione("SF4",1,xFilial("SF4")+_cTES,"F4_ESTOQUE")$"S" .and. !Subs(_cLocal,1,1)$"P"
   		MsgStop("Armazém informado fora do range P0 à P9 não é permitido.","Armazém Errado")
   		lReturn := .f.
   	EndIf
ElseIf !Subs(_cProduto,1,1)$"Z"
 	If _cTES >= '600' .And. _cTES <= '699' .And. Posicione("SF4",1,xFilial("SF4")+_cTES,"F4_ESTOQUE")$"S"
   		MsgStop("TES informada dentro do range 600 à 699 não permitido.","TES Errada")
   		lReturn := .f.
   	EndIf
   	
   	If Posicione("SF4",1,xFilial("SF4")+_cTES,"F4_ESTOQUE")$"S" .and. Subs(_cLocal,1,1)$"P"
   		MsgStop("Armazém informado dentro do range P0 à P9 não é permitido.","Armazém Errado")
   		lReturn := .f.
   	EndIf
EndIf


//========================================================================================================================================================
If M->UA_OPER<>"3"
	
	If acols[n,Len(aCols[n])] == .F.
		
		xPosDesc	 := aScan(aHeader,{|x| AllTrim(x[2])=="UB_DESC"})
		xPosProduto	 := aScan(aHeader,{|x| AllTrim(x[2])=="UB_PRODUTO"})
		xPosLocal	 := aScan(aHeader,{|x| AllTrim(x[2])=="UB_LOCAL"})
		xPosDescri	 := aScan(aHeader,{|x| AllTrim(x[2])=="UB_DESCRI"})
		xPosQuant	 := aScan(aHeader,{|x| AllTrim(x[2])=="UB_QUANT"})
		xPosVrUnit	 := aScan(aHeader,{|x| AllTrim(x[2])=="UB_VRUNIT"})
		xPosPrcTab	 := aScan(aHeader,{|x| AllTrim(x[2])=="UB_PRCTAB"})
		xPosVlrItem	 := aScan(aHeader,{|x| AllTrim(x[2])=="UB_VLRITEM"})
		xPosOper	 := aScan(aHeader,{|x| AllTrim(x[2])=="UB_OPER"})
		xPosTes		 := aScan(aHeader,{|x| AllTrim(x[2])=="UB_TES"})
		xPosDtEntre	 := aScan(aHeader,{|x| AllTrim(x[2])=="UB_DTENTRE"})
		xPosCf		 := aScan(aHeader,{|x| AllTrim(x[2])=="UB_CF"})
		xPosTabela	 := aScan(aHeader,{|x| AllTrim(x[2])=="UB_TABELA"})
		xPosPeVend	 := aScan(aHeader,{|x| AllTrim(x[2])=="UB_PEDVEND"})
		
		Do Case
			Case Empty(aCols[N,xPosProduto])
				Alert("Produto não informado!")
				lReturn:=.F.
			Case Empty (aCols[N,xPosLocal])
				Alert("Armazem não informado!")
				lReturn:=.F.
			Case Empty (aCols[N,xPosDescri])
				Alert("Descrição não informado!")
				lReturn:=.F.
			Case Empty (aCols[N,xPosQuant])
				Alert("Quantidade não informado!")
				lReturn:=.F.
			Case Empty (aCols[N,xPosVrUnit])
				Alert("Valor unitário não informado!")
				lReturn:=.F.
			Case Empty (aCols[N,xPosPrcTab])
				Alert("Preço tabela não informado!")
				lReturn:=.F.
			Case Empty (aCols[N,xPosVlrItem])
				Alert("Valor item não informado!")
				lReturn:=.F.
			Case Empty (aCols[N,xPosTes])
				Alert("Digite o tipo de Operação")
				lReturn:=.F.
			Case Empty (aCols[N,xPosCf])
				Alert("Código fiscal não informado!")
				lReturn:=.F.
		EndCase

	EndIf
	
EndIf


Return(lReturn)
