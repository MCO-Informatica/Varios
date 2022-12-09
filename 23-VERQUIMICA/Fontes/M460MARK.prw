#Include "Protheus.Ch"
#Include "TopConn.Ch"    

#DEFINE CRLF CHR(13)+CHR(10)

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+---------------------+-------------------------------+------------------+||
||| Programa: M460MARK  | Autor: Celso Ferrone Martins  | Data: 02/02/2015 |||
||+-----------+---------+-------------------------------+------------------+||
||| Descricao | PE para validas os pedidos de vendas marcados              |||
||+-----------+------------------------------------------------------------+||
||| Alteracao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Uso       |                                                            |||
||+-----------+------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==============================================================================
*/

User Function M460MARK()  

Local _aArea    := GetArea()
Local _cAreaSC5 := SC5->(GetArea())
Local _cAreaSC6 := SC6->(GetArea())
Local _cAreaSC9 := SC9->(GetArea())
Local _cAreaSB1 := SB1->(GetArea())
Local _cAreaSB5 := SB5->(GetArea())
Local cMark	    := PARAMIXB[1]
Local lInvt	    := PARAMIXB[2] 
Local aPVA		:= {} 
Local aPV		:= {}         
Local nX		:= 0
Local lOkay	    := .T.     
Local _nQtdIte  := 0  
Local _nQtdMar	:= 0   
Local cQuery 	:= ""        
Local _cMsg		:= ""
Local _Mark1	:= ""
//Private cHoraIni := Time() //para teste de performance

   /*
dbSelectArea( "SC5" )
SC5->( dbSetOrder(1) )

dbSelectArea("SC9")
SC9->( dbGoTop())   

*/
DbSelectArea("SC6") ; DbSetOrder(1)
DbSelectArea("SC9") ; DbSetOrder(1)
DbSelectArea("SA1") ; DbSetOrder(1)
DbSelectArea("SB1") ; DbSetOrder(1)
DbSelectArea("SB5") ; DbSetOrder(1)


cQuery := " SELECT                                               " 
cQuery += "    C9_PEDIDO, C9_OK                                  " 
cQuery += " FROM " + RetSQLName("SC9") + " SC9                   " 
cQuery += " WHERE                                                " 
cQuery += "    D_E_L_E_T_ <> '*'                                 " 
cQuery += "    AND C9_FILIAL = '"+xFilial("SC9")+"'              " 
cQuery += "    AND C9_OK = '"+cMark+"'                           " 


cQuery := ChangeQuery(cQuery)

If Select("TRB") > 0
	TRB->(DbCloseArea())
EndIf

TcQuery cQuery New Alias "TRB"

TRB->(DbGoTop())
_Mark1 := TRB->C9_OK

While !TRB->(Eof())    
 
	If Ascan(aPVA, TRB->C9_PEDIDO ) == 0
		Aadd(aPVA, TRB->C9_PEDIDO )
		Aadd(aPv, {TRB->C9_PEDIDO, "", _nQtdIte, _nQtdMar}) 
	EndIf

	If SC9->C9_OK <> _Mark1
		lOkay	:= .F.
		MsgAlert("Não poderá ser faturado os Pedidos selecionados, pois vai dar divergências nos Itens!", "ATENÇÃO")
		Return (lOkay)
	EndIf

	TRB->(DbSkip())
EndDo

/*
While TRB->(!Eof())

    If SC9->C9_OK <> _Mark1
		lOkay	:= .F.
		MsgAlert("Não poderá ser faturado os Pedidos selecionados, pois vai dar divergências nos Itens!", "ATENÇÃO")
		Return (lOkay)
	EndIf

	If Ascan(aPVA, SC9->C9_PEDIDO ) == 0
		Aadd(aPVA, SC9->C9_PEDIDO )
		Aadd(aPv, {SC9->C9_PEDIDO, "", _nQtdIte, _nQtdMar}) 
	EndIf
	
	TRB->( dbSkip() )
Enddo     */                



For nX := 1 To Len(aPv)         
cBlq := ""  
_nQtdIte := 0 
_nQtdMar := 0                      
	If SC9->(DbSeek(xFilial("SC9")+aPv[nX][1]))
		While !SC9->(EoF()) .AND. SC9->C9_PEDIDO == aPv[nX][1] .AND. !SC9->C9_BLEST == "10" .AND. !SC9->C9_BLCRED == "10"            
			//---> Validação para identificar se o Pedido possui Itens Bloqueados antes de faturar - Lucas Baía (UPDUO)
			IF SC9->C9_BLEST $ '02/03'
				lOkay	:= .F.
				MsgAlert("Existem Produtos com bloqueio de Estoque neste Pedido selecionado, por favor revisar!", "ATENÇÃO")
				Return(lOkay)
			ELSEIF SC9->C9_BLCRED $ '01/02/04/05/06/09'
				lOkay	:= .F.
				MsgAlert("Existem Produtos com bloqueio de Crédito de Cliente neste Pedido selecionado, por favor revisar!", "ATENÇÃO")
				Return(lOkay)
			ENDIF
			//---> Fim da Validação.			
			
			//---> Validação da Licença de Policia Federal - Lucas Baía e Vladimir Alves (UPDUO)
			IF SB5->(DbSeek(xFilial("SB5")+SC9->C9_PRODUTO))

				IF SB1->(DbSeek(xFilial("SB1")+SC9->C9_PRODUTO+SC9->C9_LOCAL))

					IF SA1->(DbSeek(xFilial("SA1")+SC9->C9_CLIENTE+SC9->C9_LOJA))

						IF SB5->B5_PRODPF == "S" //---> Produto Controlado Pela Policia Federal
							
							IF Empty(SA1->A1_VQ_LIPF) .OR. SA1->A1_VQ_DLPF < Date() //---> Data da Policia Federal Vencida.
								lOkay	:= .F.
								MsgAlert("A Data da Licença pela Policia Federal está vencida ou não preenchida!"+chr(13)+chr(10)+;
								chr(13)+chr(10)+;
								"Por favor revisar a Licença da Policia Federal pelo Cadastro de Clientes!", "ATENÇÃO")
							ENDIF
						
						ENDIF	
						
						IF SB5->B5_PRODEX == "S"  //---> Produto Controlado Pelo Exército
								
							IF Empty(SA1->A1_VQ_LIEX) .OR. SA1->A1_VQ_DLEX < Date() //---> Data do Exercito Vencida.
								lOkay	:= .F.
								MsgAlert("A Data da Licença pelo Exercito está vencida ou não preenchida!"+chr(13)+chr(10)+;
								chr(13)+chr(10)+;
								"Por favor revisar a Licença do Exercito pelo Cadastro de Clientes!", "ATENÇÃO")
							ENDIF

						ENDIF
					ENDIF
				ENDIF
			ENDIF
			//---> Fim da Validação.
			
			If  Empty(aPv[nx][2])
				If (SC9->C9_BLEST $ '02/03')			
					cBlq := "BLQ1"
				ElseIf (SC9->C9_BLCRED $ '01/02/04/05/06/09')
					cBlq := "BLQ2"
				Else    
					If Posicione("SF4",1,xFilial("SF4")+Posicione("SC6",1,SC9->C9_FILIAL+SC9->C9_PEDIDO+SC9->C9_ITEM,"C6_TES"),"F4_DUPLIC") $"S" 	  //se gerar duplicata eu valido					
						If SC5->( MsSeek( xFilial( "SC5" ) + SC9->C9_PEDIDO ) )
							If !(SC5->C5_VQ_LIBF$"S")
							   If !U_VERQUICRED(SC9->C9_CLIENTE,SC9->C9_LOJA,SC9->C9_PEDIDO)
									cBlq := "BLQ3"                        	
								EndIf
							EndIf
						EndIf
					EndIf
				EndIf   
				aPv[nX][2] := cBlq          
			EndIf 
			_nQtdIte := _nQtdIte  + 1 
			aPv[nX][3] := _nQtdIte
			If SC9->C9_OK == cMark
				_nQtdMar := _nQtdMar + 1
			EndIf
			aPv[nX][4] := _nQtdMar
			SC9->(DbSkip())
		EndDo           
	EndIf
Next 
                        
For nX := 1 To Len(aPv)
     If !Empty(aPv[nX][2])        
     	If SC9->(DbSeek(xFilial("SC9")+aPv[nX][1]))
			While !SC9->(EoF()) .AND. SC9->C9_PEDIDO == aPv[nX][1] .AND. !SC9->C9_BLEST == "10" .AND. !SC9->C9_BLCRED == "10"            
			     RecLock("SC9", .F.)
			     	SC9->C9_OK := ""
			     SC9->(MsUnlock())
				SC9->(DBSkip())
			EndDo
			                      
			If aPv[nX][2] $ "BLQ1"
				_cMsg += "Não foi gerado documento para o pedido " + aPv[nX][1] + " devido algum item do pedido estar com problema relacionado a Bloqueio Estoque" + CRLF 
			ElseIf aPv[nX][2] $ "BLQ2"
				_cMsg += "Não foi gerado documento para o pedido " + aPv[nX][1] + " devido algum item do pedido estar com problema relacionado a Bloqueio de Credito" + CRLF
			ElseIf aPv[nX][2] $ "BLQ3"                                                                                                                               
				_cMsg += "Não foi gerado documento para o pedido " + aPv[nX][1] + " devido a pendencias financeiras" + CRLF
			EndIf
		EndIf
     Else
     	If aPv[nX][3] <> aPv[nX][4]
     		If MsgYesNo("Para o pedido [" + aPv[nX][1] + "] Existem " + cvaltochar(aPv[nX][3]) + " itens, entretanto, apenas " + cvaltochar(aPv[nX][4]) + " esta(o) marcado(s), deseja selecionar automaticamente os demais itens para gerar a nota fiscal? " )
	     		If SC9->(DbSeek(xFilial("SC9")+aPv[nX][1]))
					While !SC9->(EoF()) .AND. SC9->C9_PEDIDO == aPv[nX][1] .AND. !SC9->C9_BLEST == "10" .AND. !SC9->C9_BLCRED == "10"            
					     RecLock("SC9", .F.)
					     	SC9->C9_OK := cMark
					     SC9->(MsUnlock())
						 SC9->(DBSkip())
					EndDo               
				EndIf
	  		Else                                       
     			If SC9->(DbSeek(xFilial("SC9")+aPv[nX][1]))
					While !SC9->(EoF()) .AND. SC9->C9_PEDIDO == aPv[nX][1] .AND. !SC9->C9_BLEST == "10" .AND. !SC9->C9_BLCRED == "10"            
					     RecLock("SC9", .F.)
					     	SC9->C9_OK := ""
					     SC9->(MsUnlock())
						 SC9->(DBSkip())
					EndDo                                      
				EndIf
     		EndIf
     	EndIf
     EndIF
Next                              
      
If !Empty(_cMsg)
     Alert(_cMsg)
EndIf            

//Por Anderson Goncalves
aSaldoLib 	:= {}
nPos		:= 0
cQuery		:= 0
//============================================
// Pega os registros marcados
//============================================
cQuery := "SELECT R_E_C_N_O_ RECSC9 FROM "+RetSqlName("SC9")+" (NOLOCK) "
cQuery += "WHERE C9_FILIAL = '"+xFilial("SC9")+"' "
cQuery += "AND C9_OK = '"+cMark+"' "
cQuery += "AND LTRIM(RTRIM(C9_BLEST)) = ' ' "
cQuery += "AND LTRIM(RTRIM(C9_BLCRED)) = ' ' "
cQuery += "AND D_E_L_E_T_ = ' ' "

If Select("QUERY") > 0
    QUERY->(dbCloseArea())
Endif
TcQuery cQuery New Alias "QUERY"

dbSelectArea("QUERY")
QUERY->(dbGoTop())
While QUERY->(!EOF())

    SC9->(dbGoTo(QUERY->RECSC9))
    SB2->(dbSeek(xFilial("SB2")+SC9->C9_PRODUTO+SC9->C9_LOCAL))
    If SC6->(dbSeek(xFilial("SC6")+SC9->C9_PEDIDO+SC9->C9_ITEM+SC9->C9_PRODUTO))
        If SF4->F4_ESTOQUE == "S"
            nPos := Ascan(aSaldoLib,{|x| AllTrim(x[1])+AllTrim(x[2]) == AllTrim(SC9->C9_PEDIDO)+AllTrim(SC9->C9_PRODUTO)})
            If nPos == 0
                aAdd(aSaldoLib,{SC9->C9_PEDIDO,;
                                SC9->C9_PRODUTO,;
                                SC9->C9_QTDLIB,;
                                SB2->B2_QATU})
            Else
                aSaldoLib[nPos,3] += SC9->C9_QTDLIB
            EndIf
        EndIf
    Endif

    QUERY->(dbSkip())
Enddo

If Select("QUERY") > 0
    QUERY->(dbCloseArea())
Endif

For nX := 1 To Len(aSaldoLib)
    If aSaldoLib[nX,4] - aSaldoLib[nX,3] < 0
        cQuery := "UPDATE "+RetSqlName("SC9")+" SET C9_OK = ' ' "
        cQuery += "WHERE C9_OK = '" + cMark + "' "
        cQuery += "AND C9_PEDIDO = '" +aSaldoLib[nX,1]+ "' "
        TcSqlExec(cQuery)
        msgAlert("O produto "+AllTrim(aSaldoLib[nX,2])+" do pedido "+AllTrim(aSaldoLib[nX,1])+" não será faturado por falta de saldo no estoque!","M460MARK")
    EndIf
Next nX

RestArea( _cAreaSC9 )
RestArea( _cAreaSC6 )
RestArea( _cAreaSC5 )
RestArea( _cAreaSB1 )
RestArea( _cAreaSB5 )
RestArea( _aArea )
         
//Alert("Tempo de processamento - " + ElapTime(cHoraIni,Time()))    //para teste de performance

Return( lOkay )
