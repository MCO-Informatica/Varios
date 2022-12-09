/*
=======================================================================================
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+---------------------+-----------------------------------+-----------------------+||
||| Programa: Ma440VLD | Autor: Danilo Alves Del Busso      | Data: 25/08/2015 		|||
||+------------+--------+-----------------------------------+-----------------------+||
||| Descricao: | PE acionado para validaГЦo quando clicado em confirmar liberaГЦo   |||
|||			   | do Pedido     												   		|||
||+------------+--------------------------------------------------------------------+||
||| Alteracao: |                                                               		|||
||+------------+--------------------------------------------------------------------+||
||| Uso:       | Verquimica                                                    		|||
||+------------+--------------------------------------------------------------------+||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
=======================================================================================
*/

User Function MA440VLD()
Local cAreaSC6 := SC6->(GetArea())
Local cAreaSC5 := SC5->(GetArea())
Local cAreaSB1 := SB1->(GetArea())      

cRet := .T.
cMensagem := ""
cCont := 1   
_cGeraFin := ""

DbSelectArea("SC5") ; DbSetOrder(1)
DbSelectArea("SC6") ; DbSetOrder(1)
DbSelectArea("SB1") ; DbSetOrder(1)  
DbSelectArea("SD1") ; DbSetOrder(14)           

nPosLote := aScan(aHeader,{|x| Alltrim(x[2])=='C6_LOTECTL'})
nPosFCI := aScan(aHeader,{|x| Alltrim(x[2])=='C6_FCICOD'})
               
If SC6->(DbSeek(xFilial("SC6")+SC5->C5_NUM))
	While !SC6->(Eof()) .AND. SC6->C6_NUM = SC5->C5_NUM    
		
		
		_cGeraFin	:=	Posicione("SF4",1,xFilial("SF4")+SC6->C6_TES,"F4_DUPLIC")
		
		aItens	 := ACLONE(aCols[cCont])  
	           /*
			If(!Empty(aCols[cCont][nPosLote]) .AND. Empty(aCols[cCont][nPosFCI]))
				RunTrigger(2,cCont,nil,,'C6_LOTECTL')   
			EndIf
		             */                                        
		If((Val(SC6->C6_CLASFIS) >= 300 .AND. Val(SC6->C6_CLASFIS) <= 399) .OR. (Val(SC6->C6_CLASFIS) >= 500 .AND. Val(SC6->C6_CLASFIS) <= 599))
			If(SB1->(DbSeek(xFilial("SB1")+SC6->C6_PRODUTO)))
				If(SB1->B1_TIPO == "MP" .OR. SB1->B1_TIPO == "PA")
						If(Empty(aItens[nPosFCI]))
							If(Empty(aItens[nPosFCI]) .AND. !Empty(aCols[cCont][nPosFCI]))
								if(ApMsgNoYes("Verificamos que o campo referente ao CСdigo FCI do lote " + aCols[n][nPosLote] + "nЦo foi digitado ou foi apagado, identificamos que para este lote possuimos o CODIGO FCI " + aCols[n][nPosFCI] + "previamente cadastrado na base de dados, deseja utiliza-lo?"))
								else                                                      	
									aCols[cCont][nPosFCI] = ""
								endif
							EndIf	
							cMensagem := cMensagem + SC6->C6_PRODUTO + Chr(13) + Chr(10)
							cRet:= .F.   
						EndIf
		   		EndIf
	  		EndIf          
		EndIf          
		aItens := nil
		cCont:= cCont + 1    
		SC6->(DbSkip())  
	EndDo
EndIf

If cRet == .F.
	MsgAlert("CODIGO FCI OBRIGATORIO para os produtos abaixo:" + Chr(13) + Chr(10) + cMensagem, "ATENCAO: CODIGO FCI")
EndIf       

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё ValidaГЦo Referente ao Financeiro - Daniel Salese - Inicio - 16/03/17 Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

If cRet == .T.
	If SC5->C5_VQ_LIBF$"S"
		cRet := .T.
	ElseIf !_cGeraFin$"S"
		cRet := .T.
	Else
		cRet := U_VERQUICRED(SC5->C5_CLIENTE,SC5->C5_LOJACLI,SC5->C5_NUM) 
	EndIf
EndIf

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё ValidaГЦo Referente ao Financeiro - Daniel Salese - Fim    - 16/03/17 Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

Return(cRet)