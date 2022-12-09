#Include "Protheus.ch"   
//#Include "rdmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPFIN001 บAutor  ณRene Lopes            บ Data ณ  09/25/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณAjustar titulos com problema                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/                                                                          

User Function PFIN020()

Local _nDias:= 30
Local c2
Local c3
Local c4
Local c5
Local c6
Local c7


Local cAlias := "TRB"

 BeginSQL Alias cAlias 

/*	SELECT 
	E1_FILIAL  		AS FILIAL,
	E1_PREFIXO 		AS PREFIXO,
	E1_NUM 			AS NUM,
	E1_PARCELA		AS PARCELA,
	E1_TIPO 		AS TIPO,
	E1.R_E_C_N_O_ 	AS REC,
	E1.D_E_L_E_T_ 	AS DEL	
	FROM SC5010 SC5 INNER JOIN SE1010 E1 ON C5_CLIENTE = E1_CLIENTE AND C5_NUM = E1_PEDIDO AND
	C5_XNPSITE = E1_XNPSITE
	WHERE 
	C5_CHVBPAG <> ' ' AND
	C5_XNPSITE <> ' ' AND
	C5_CONDPAG = '001' AND
	C5_EMISSAO >= '20120917' AND
	SC5.D_E_L_E_T_ = ' '   */
	
		SELECT 
   			E1_FILIAL  		AS FILIAL,
			E1_PREFIXO 		AS PREFIXO,
			E1_NUM 			AS NUM,
			E1_PARCELA		AS PARCELA,
			E1_TIPO 		AS TIPO,
			E1.R_E_C_N_O_ 	AS REC,
			E1.D_E_L_E_T_ 	AS DEL	
 	 	FROM 
 		 	SE1010 E1
  		WHERE
  			E1_TIPMOV = '2' AND
  			E1_EMISSAO > '20120901' AND
 	 		E1_EMISSAO = E1_VENCTO AND
  			E1_SALDO > '0' AND
  			E1.D_E_L_E_T_ = ' ' 
 
 EndSQL 

DBSelectArea("TRB")
TRB->(dbGoTop())   

DBSELECTAREA("SE1")
DBSETORDER(1)  //E1_FILIAL + E1_PREFIXO + E1_NUM + E1_PARCELA + E1_TIPO + R_E_C_N_O_ + D_E_L_E_T_

WHILE TRB->(!EOF())

//c1:=TRB->FILIAL
c2 := TRB->PREFIXO
c3 := TRB->NUM
c4 := TRB->PARCELA
c5 := TRB->TIPO
c6 := TRB->REC
c7 := TRB->DEL

SE1->(Dbseek(xFilial("SE1")+c2+c3+c4+c5))    

If Found()
RecLock("SE1", .F.)
	cDateNew := E1_VENCTO + _nDias        
	cDateRea := E1_VENCREA + _nDias
	E1_VENCTO := cDateNew
	E1_VENCREA := cDateRea
SE1->(MsUnlock())
EndIf

TRB->(Dbskip())

ENDDO 

TRB->(DbCloseArea())  

MSALERT("PROCESSO FINALIZADO")

Return()