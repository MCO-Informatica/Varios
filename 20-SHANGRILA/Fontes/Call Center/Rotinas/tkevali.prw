
#INCLUDE "protheus.ch"
#INCLUDE "rwmake.ch"

//==========================================================================================================================================================
//Nelson Hammel - 02/09/11 - Valida��es de linhas

User Function TKEVALI()

Local lReturn := .T.
xDescMax:=0


_cTES		:=	aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "UB_TES"})]
_cProduto	:=	aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "UB_PRODUTO"})]
_cLocal	:=	aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "UB_LOCAL"})]

If Subs(_cProduto,1,1)$"Z"
 	If _cTES < '600' .Or. _cTES > '699'
   		MsgStop("TES informada fora do range 600 � 699 n�o � permitido.","TES Errada")
   		lReturn := .f.
   	EndIf
   	
   	If Posicione("SF4",1,xFilial("SF4")+_cTES,"F4_ESTOQUE")$"S" .and. !Subs(_cLocal,1,1)$"P"
   		MsgStop("Armaz�m informado fora do range P0 � P9 n�o � permitido.","Armaz�m Errado")
   		lReturn := .f.
   	EndIf
ElseIf !Subs(_cProduto,1,1)$"Z"
 	If _cTES >= '600' .And. _cTES <= '699' .And. Posicione("SF4",1,xFilial("SF4")+_cTES,"F4_ESTOQUE")$"S"
   		MsgStop("TES informada dentro do range 600 � 699 n�o permitido.","TES Errada")
   		lReturn := .f.
   	EndIf
   	
   	If Posicione("SF4",1,xFilial("SF4")+_cTES,"F4_ESTOQUE")$"S" .and. Subs(_cLocal,1,1)$"P"
   		MsgStop("Armaz�m informado dentro do range P0 � P9 n�o � permitido.","Armaz�m Errado")
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
				Alert("Produto n�o informado!")
				lReturn:=.F.
			Case Empty (aCols[N,xPosLocal])
				Alert("Armazem n�o informado!")
				lReturn:=.F.
			Case Empty (aCols[N,xPosDescri])
				Alert("Descri��o n�o informado!")
				lReturn:=.F.
			Case Empty (aCols[N,xPosQuant])
				Alert("Quantidade n�o informado!")
				lReturn:=.F.
			Case Empty (aCols[N,xPosVrUnit])
				Alert("Valor unit�rio n�o informado!")
				lReturn:=.F.
			Case Empty (aCols[N,xPosPrcTab])
				Alert("Pre�o tabela n�o informado!")
				lReturn:=.F.
			Case Empty (aCols[N,xPosVlrItem])
				Alert("Valor item n�o informado!")
				lReturn:=.F.
			Case Empty (aCols[N,xPosTes])
				Alert("Digite o tipo de Opera��o")
				lReturn:=.F.
			Case Empty (aCols[N,xPosCf])
				Alert("C�digo fiscal n�o informado!")
				lReturn:=.F.
		EndCase

	EndIf
	
EndIf


Return(lReturn)
