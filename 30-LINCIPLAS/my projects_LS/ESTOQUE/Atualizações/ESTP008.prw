#INCLUDE "Rwmake.ch"
#INCLUDE "Topconn.ch"
#INCLUDE "TbiConn.ch"
#INCLUDE "TbiCode.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ESTP008   ºAutor  ³Antonio Carlos      º Data ³  22/04/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Atualiza os registros da tabela SD2 - Itens da NF Saida     º±±
±±º          ³para os casos onde o campo D2_CUSTO1 não foi gravado.       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Laselva                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function ESTP008()

Private aSays		:= {}
Private aButtons	:= {}
Private	nOpca		:= 0 
Private cPerg		:= Padr("ESTP08",len(SX1->X1_GRUPO)," ")  
Private cCadastro	:= "Atualiza Custo Itens NF Saida"
Private dDatad		
Private dDataa		:= CTOD("  /  /  ")
ValidPerg()
Pergunte(cPerg, .F.)

AADD(aSays,"Este programa tem o objetivo de atualizar os registros")
AADD(aSays,"da tabela SD2 (Itens NF de Saida) onde o campo custo")
AADD(aSays,"nao foi gravado.")
AADD(aButtons, { 1,.T.,{|o| nOpca:= 1,o:oWnd:End() } } )
AADD(aButtons, { 2,.T.,{|o| o:oWnd:End() }} )
FormBatch( cCadastro, aSays, aButtons )
	
If nOpcA == 1
 	If Pergunte(cPerg,.T.)
	 	dDataa := MV_PAR01
	 	LjMsgRun("Aguarde..., Atualizando registros...",, {|| AtuDados() })	
	 EndIf	
EndIf	
		
Return
	
Static Function AtuDados()

dDatad := DTOS(dDataa)
dDatad := Substr(dDatad,1,6)+"01"

If Substr(SM0->M0_CGC,1,8) == "53928891"

	cUpd := " UPDATE "+RetSqlName("SD2") 
	cUpd += " SET D2_CUSTO1 = 0" 
	cUpd += " CASE WHEN B9_VINI1 > 0 THEN B9_VINI1/B9_QINI ELSE "
	cUpd += " CASE WHEN D1_CUSTO > 0 THEN D1_CUSTO / D1_QUANT ELSE "
	cUpd += " CASE WHEN D3_CUSTO1 > 0 THEN D3_CUSTO1 / D3_QUANT ELSE "
	cUpd += " CASE WHEN B1_UPRC <> 0 THEN B1_UPRC ELSE  0 "
	cUpd += " END 		END 	END  END "
	cUpd += " FROM "+RetSqlName("SD2")+" SD2 (NOLOCK)"
	cUpd += " INNER JOIN "+RetSqlName("SB1")+" SB1 (NOLOCK)"
	cUpd += " ON D2_COD = B1_COD AND SB1.D_E_L_E_T_ = ''" 
	cUpd += " LEFT JOIN "+RetSqlName("SB9")+" SB9 (NOLOCK)"
	cUpd += " ON ( D2_FILIAL = B9_FILIAL AND D2_COD = B9_COD AND B9_DATA = '"+DTOS(dDataa)+"' AND SB9.D_E_L_E_T_ = ''  ) "
	cUpd += " LEFT JOIN "+RetSqlName("SD3")+" SD3 (NOLOCK)"
	cUpd += " ON ( D3_FILIAL = D2_FILIAL AND D3_COD = D2_COD AND D3_TM = '010'  AND SD3.D_E_L_E_T_ = '' ) "
	cUpd += " LEFT JOIN "+RetSqlName("SD1")+" SD1 (NOLOCK)"
	cUpd += " ON ( D1_FILIAL = D2_FILIAL AND D1_COD = D2_COD AND D1_EMISSAO = D2_EMISSAO AND SD1.D_E_L_E_T_ = '' ) "
	cUpd += " WHERE "
	cUpd += " D2_FILIAL = '"+xFilial("SD2")+"' AND "
	cUpd += " D2_EMISSAO BETWEEN '"+dDatad+"' AND '"+DTOS(dDataa)+"' AND "
	cUpd += " D2_TIPO = 'N' AND "
	cUpd += " D2_CUSTO1 = 0 AND "
	cUpd += " SD2.D_E_L_E_T_ = '' "
	                                    
	TcSQLExec(cUpd)	
	
Else	

	cUpd := " UPDATE "+RetSqlName("SD2") 
	cUpd += " SET D2_CUSTO1 = D2_PRCVEN*D2_QUANT"
	cUpd += " FROM "+RetSqlName("SD2")+" SD2 (NOLOCK)"
	cUpd += " WHERE "
	cUpd += " D2_FILIAL = '"+xFilial("SD2")+"' AND "
	cUpd += " D2_EMISSAO BETWEEN '"+dDatad+"' AND '"+DTOS(dDataa)+"' AND "
	cUpd += " D2_TIPO = 'B' AND "
	cUpd += " D2_CUSTO1 = 0 AND "
	cUpd += " SD2.D_E_L_E_T_ = '' "
	
	TcSQLExec(cUpd)	
	
EndIf	
	                                    
MsgInfo("Processamento efetuado com sucesso!")
	
Return

Static Function ValidPerg()

nXX      := 0
aPerg    := {}

/*01*/aAdd(aPerg,{ "Data do Movimento:        	 " , "D" , 08 , 00 , "G" , "" , "" , "" , "" , "","" })

For nXX := 1 to Len( aPerg )
	If !SX1->( DbSeek( cPerg + StrZero( nXX , 2 ) ) )
		RecLock( "SX1" , .T. )
		SX1->X1_GRUPO     := cPerg
		SX1->X1_ORDEM     := StrZero( nXX , 2 )
		SX1->X1_VARIAVL   := "mv_ch"  + Chr( nXX + 96 )
		SX1->X1_VAR01     := "mv_par" + Strzero( nXX , 2 )
		SX1->X1_PRESEL    := 1
		SX1->X1_PERGUNT   := aPerg[ nXX , 01 ]
		SX1->X1_TIPO      := aPerg[ nXX , 02 ]
		SX1->X1_TAMANHO   := aPerg[ nXX , 03 ]
		SX1->X1_DECIMAL   := aPerg[ nXX , 04 ]
		SX1->X1_GSC       := aPerg[ nXX , 05 ]
		SX1->X1_DEF01     := aPerg[ nXX , 06 ]
		SX1->X1_DEF02     := aPerg[ nXX , 07 ]
		SX1->X1_DEF03     := aPerg[ nXX , 08 ]
		SX1->X1_DEF04     := aPerg[ nXX , 09 ]
		SX1->X1_DEF05     := aPerg[ nXX , 10 ]
		SX1->X1_F3        := aPerg[ nXX , 11 ]
		SX1->( MsUnlock() )
	EndIf
Next nXX

Return