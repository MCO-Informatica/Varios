#Include "RWMAKE.CH"
#Include "TOPCONN.CH"
#Include "Protheus.Ch"
#include "TbiConn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ TK271COR บAutor  ณMateus Hengle       บ Data ณ    18/12/13 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPonto de entrada para atualizar as legendas no CRM...       บฑฑ
ฑฑฬออออออออออฯอออัออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso           ณ METALACRE                                              บฑฑ
ฑฑฬออออออออออออออุออออออออัอออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑณAnalista Resp.ณ  Data  ณ Manutencao Efetuada                           ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณAdalberto Netoณ11/03/14ณAlterei o nome da cor MARROM para VIOLETA      ณฑฑ
ฑฑศออออออออออออออฯออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function TK271COR()    

Local aArea  := GetArea()
Local aVetor := {}      
local alegend:= {} 

PROCESSA({||U_ATULEG()},"Aguarde", "Atualizando Legendas...")

aadd(aVetor,{"UA_STATUS == 'NF.' .And. UA_OPER == '1' .And. UA_CANC <> 'S'"  					   	,"BR_VERMELHO"}) // CRIAR O CAMPO UA_NOTAFIS NA PRODUCAO  
aadd(aVetor,{"UA_OPER == '3' .AND. UA_CANC <> 'S'" 	   					   						   	,"BR_VIOLETA"}) 
aadd(aVetor,{"UA_OPER == '2' .AND. UA_CANC <> 'S'"   					   						   	,"BR_AZUL"}) 
aadd(aVetor,{"UA_STATUS $ 'LIB*SUP' .And. UA_LIBERA == 'S' .AND. UA_CANC <> 'S' .AND. UA_TEMOP <> 'X' .AND. UA_TEMOP <>'S'"    	,"BR_AMARELO"})   // CRIAR O CAMPO UA_LIBERA NA PRODUCAO 
aadd(aVetor,{"UA_LIBERA <> 'S' .AND. UA_CANC <> 'S'"						   					   	,"BR_VERDE"})  
aadd(aVetor,{"UA_CANC == 'S'" 						  					   					   	 	,"BR_PRETO"}) 
aadd(aVetor,{"UA_TEMOP =='S' .AND. UA_CANC <> 'S'"						  						 	,"BR_PINK"}) 
aadd(aVetor,{"UA_TEMOP == 'X' .AND. UA_CANC <> 'S'"   					   						 	,"BR_LARANJA"})  // CRIAR O CAMPO UA_BLCRED NA PRODUCAO   

For nX:=1 To Len(alegend)          		
	AADD(aVetor,{alegend[nX,1],alegend[nX,2],alegend[nX,3],alegend[nX,4],alegend[nX,5],alegend[nX,6],alegend[nX,7],alegend[nX,8]} )
Next nX
                                                                                          
Return aVetor                                           	

User Function ATULEG() 


CQRYG := " UPDATE "+RETSQLNAME("SUA") 
CQRYG += " SET UA_LIBERA = C5_LIBEROK,"
CQRYG += " UA_TEMOP = C5_TEMOP"  		 // ATUALIZA O CAMPO PRA MUDAR A LEGENDA PRA PINK - OP GERADA
CQRYG += " FROM "+RETSQLNAME("SC5")+" SC5" 
cQRYG += " INNER JOIN "+RETSQLNAME("SUA")+" SUA"
cQRYG += " ON UA_FILIAL = C5_FILIAL AND UA_NUMSC5 = C5_NUM" 
CQRYG += " WHERE UA_CANC <> 'S'"
CQRYG += " AND (UA_TEMOP <> C5_TEMOP "  		 // aTUALIZA Sำ SE ESTIVER DIFERENTE NAO TODOS COMO ANTES
CQRYG += " OR UA_LIBERA = C5_LIBEROK)"
CQRYG += " AND SC5.D_E_L_E_T_ ='' " 
CQRYG += " AND SUA.D_E_L_E_T_ ='' " 

TcSqlExec(cQRYG) 


CQRYG1 := " UPDATE "+RETSQLNAME("SUA") 
CQRYG1 += " SET UA_BLCRED = ISNULL(C9_BLCRED,'') " 
CQRYG1 += " FROM "+RETSQLNAME("SC9")+" SC9" 
cQRYG1 += " RIGHT JOIN "+RETSQLNAME("SUA")+" SUA"
cQRYG1 += " ON UA_FILIAL = C9_FILIAL AND UA_NUMSC5 = C9_PEDIDO" 
CQRYG1 += " AND UA_BLCRED <> C9_BLCRED " 
CQRYG1 += " AND SC9.D_E_L_E_T_ ='' " 
CQRYG1 += " AND SUA.D_E_L_E_T_ ='' " 

TcSqlExec(cQRYG1)

// QUERY QUE ATUALIZA O CAMPO DO NUMERO E ITEM DA OP TRAZENDO DA SC5 PARA SUB - AJUSTE FEITO EM 07/04/14 - MATEUS HENGLE
CQRYG7 := " UPDATE "+RETSQLNAME("SUB") 
CQRYG7 += " SET UB_NUMOP = C6_NUMOP, UB_ITEMOP = C6_ITEMOP" 
CQRYG7 += " FROM "+RETSQLNAME("SC6")+" SC6" 
cQRYG7 += " RIGHT JOIN "+RETSQLNAME("SUB")+" SUB"
cQRYG7 += " ON UB_FILIAL = C6_FILIAL AND UB_NUMPV = C6_NUM AND UB_ITEM = C6_ITEM" 
CQRYG7 += " WHERE SC6.D_E_L_E_T_ ='' " 
CQRYG7 += " AND SUB.UB_NUMOP <> C6_NUMOP " 
CQRYG7 += " AND SUB.D_E_L_E_T_ ='' " 

TcSqlExec(cQRYG7)


Return


/*

CQRYG := " SELECT C5_NUM, C5_NOTA, C5_LIBEROK, C5_TEMOP, UA_NUMSC5" 
CQRYG += " FROM "+RETSQLNAME("SC5")+" SC5"   
cQRYG += " LEFT JOIN "+RETSQLNAME("SUA")+" SUA"
cQRYG += " ON UA_FILIAL = C5_FILIAL AND UA_NUMSC5 = C5_NUM" 
CQRYG += " WHERE C5_NUMAT <>'' " 
CQRYG += " AND SC5.D_E_L_E_T_ ='' " 
CQRYG += " AND SUA.D_E_L_E_T_ ='' " 
CQRYG += " ORDER BY C5_NUM"   


If Select("TRG") > 0
	TRG->(dbCloseArea())
EndIf

TCQUERY CQRYG New Alias "TRG" 
While TRG->(!EOF()) 

	cPed    := TRG->C5_NUM
	cNOTA   := TRG->C5_NOTA 			// ENCERRADO
	cLibera := TRG->C5_LIBEROK         // PEDIDO LIBERADO
	cTemOP  := TRG->C5_TEMOP           // OP GERADA

	DBSELECTAREA("SUA")
	DBSETORDER(8)
	IF DBSEEK(XFILIAL("SUA")+ cPed ) 
		RecLock("SUA",.F.)   
		SUA->UA_NOTAFIS  := cNota
		SUA->UA_LIBERA   := cLibera
		SUA->UA_TEMOP    := cTemOP 
		MsUnlock()
	ENDIF

	TRG->(DbSkip())
ENDDO 

CQRY := " SELECT C9_PEDIDO, C9_BLCRED"
CQRY += " FROM "+RETSQLNAME("SC9")+" SC9" // ATUALIZA O CAMPO C9_BLCRED PARA O UA_BLCRED PARA ATUALIZAR A LEGENDA
CQRY += " WHERE SC9.D_E_L_E_T_ ='' " 

If Select("TRA") > 0
	TRA->(dbCloseArea())
EndIf

TCQUERY CQRY New Alias "TRA" 
While TRA->(!EOF())

	cPed    := TRA->C9_PEDIDO
	cBLCRED := TRA->C9_BLCRED

	DBSELECTAREA("SUA")
	DBSETORDER(8)
	IF DBSEEK(XFILIAL("SUA")+ cPed ) .AND. SUA->UA_CANC <>'S' 
		RecLock("SUA",.F.)   
		SUA->UA_BLCRED  := cBLCRED
		MsUnlock()
	ENDIF

	TRA->(DbSkip())
ENDDO 

Return

/* VERIFICA SE O PEDIDO ESTA ENCERRADO, NOTA FISCAL EMITIDA
CQRYG := " SELECT C5_NUM, C5_NOTA"
CQRYG += " FROM "+RETSQLNAME("SC5")+" SC5" // ATUALIZA O CAMPO C9_BLCRED PARA O UA_BLCRED PARA ATUALIZAR A LEGENDA
CQRYG += " WHERE SC5.D_E_L_E_T_ ='' " 

If Select("TRG") > 0
	TRG->(dbCloseArea())
EndIf

TCQUERY CQRYG New Alias "TRG" 
While TRG->(!EOF()) 

	cPediX    := TRG->C5_NUM
	cNOTA     := TRG->C5_NOTA

	DBSELECTAREA("SUA")
	DBSETORDER(8)
	IF DBSEEK(XFILIAL("SUA")+ cPediX ) .AND. SUA->UA_CANC <>'S' 
		RecLock("SUA",.F.)   
		SUA->UA_NOTAFIS  := cNota
		MsUnlock()
	ENDIF

	TRG->(DbSkip())
ENDDO 

// VERIFICA SE O PEDIDO NA SC5 ESTA LIBERADO OU BLOQUEADO E ALIMENTA UM CAMPO NA SUA
CQRY8 := " SELECT C5_NUM, C5_LIBEROK"
CQRY8 += " FROM "+RETSQLNAME("SC5")+" SC5" // ATUALIZA O CAMPO C9_BLCRED PARA O UA_BLCRED PARA ATUALIZAR A LEGENDA
CQRY8 += " WHERE SC5.D_E_L_E_T_ ='' " 

If Select("TRD") > 0
	TRD->(dbCloseArea())
EndIf

TCQUERY CQRY8 New Alias "TRD" 
While TRD->(!EOF()) 

	cPedi    := TRD->C5_NUM
	cLibera  := TRD->C5_LIBEROK

	DBSELECTAREA("SUA")
	DBSETORDER(8)
	IF DBSEEK(XFILIAL("SUA")+ cPedi ) .AND. SUA->UA_CANC <>'S' 
		RecLock("SUA",.F.)   
		SUA->UA_LIBERA  := cLibera
		MsUnlock()
	ENDIF

	TRD->(DbSkip())
ENDDO 



// VERIFICA SE TEM BLOQUEIO DE CREDITO
CQRY := " SELECT C9_PEDIDO, C9_BLCRED"
CQRY += " FROM "+RETSQLNAME("SC9")+" SC9" // ATUALIZA O CAMPO C9_BLCRED PARA O UA_BLCRED PARA ATUALIZAR A LEGENDA
CQRY += " WHERE SC9.D_E_L_E_T_ ='' " 

If Select("TRA") > 0
	TRA->(dbCloseArea())
EndIf

TCQUERY CQRY New Alias "TRA" 
While TRA->(!EOF())

	cPed    := TRA->C9_PEDIDO
	cBLCRED := TRA->C9_BLCRED

	DBSELECTAREA("SUA")
	DBSETORDER(8)
	IF DBSEEK(XFILIAL("SUA")+ cPed ) .AND. SUA->UA_CANC <>'S' 
		RecLock("SUA",.F.)   
		SUA->UA_BLCRED  := cBLCRED
		MsUnlock()
	ENDIF

	TRA->(DbSkip())
ENDDO 


// ALTERAR O CAMPO C5_TEMOP PARA 'S' VIA SDU E COMENTAR DAQUI PRA BAIXO PRA TESTAR O FONTE

// VERIFICA SE TEM OP GERADA
CQRY1 := " SELECT C5_NUM, C5_TEMOP"
CQRY1 += " FROM "+RETSQLNAME("SC5")+" SC5"  // ATUALIZA O CAMPO C5_TEMOP PARA O UA_TEMOP PARA ATUALIZAR A LEGENDA
CQRY1 += " WHERE SC5.D_E_L_E_T_ ='' " 

If Select("TRC") > 0
	TRC->(dbCloseArea())
EndIf

TCQUERY CQRY1 New Alias "TRC" 
While TRC->(!EOF())

	cPed1    := TRC->C5_NUM
	cTemop   := TRC->C5_TEMOP

	DBSELECTAREA("SUA")
	DBSETORDER(8)
	IF DBSEEK(XFILIAL("SUA")+ cPed1 ) 
		RecLock("SUA",.F.)   
		SUA->UA_TEMOP  := cTemop
		MsUnlock()
	ENDIF

	TRC->(DbSkip())
ENDDO

Return 



