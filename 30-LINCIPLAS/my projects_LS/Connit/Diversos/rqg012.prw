#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ rqg012  			 Ricardo Felipelli   º Data ³  20/05/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Corrige tabela se1 com natureza em branco, ajusta pela     º±±
±±º          ³ conta do cadastro de produto                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Laselva                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function rqg012()
Local _Opcao := .f.

If MsgYesNO("Corrige as natureza em branco (SE1)  ??  ","executa")
	Processa({|| CorrSE1()},"Processando...")
EndIf


Return nil

Static Function CorrSE1()
           
Dbselectarea("SA1")
dbsetorder(1)

Dbselectarea("SE1")
dbsetorder(1)
SE1->(dbgotop())
ProcRegua( LastRec() )

while SE1->(!eof())
	IncProc( SE1->E1_PREFIXO )                             
	IF SE1->E1_NATUREZ <> SPACE(10)
		SE1->(dbskip())
		LOOP
	ENDIF

    SA1->(dbseek(space(02) + SE1->E1_CLIENTE + SE1->E1_LOJA))
    IF SA1->(FOUND())
       // buscar a natureza no SED pela conta contabil do fornecedor
             
       _nat := ''
		cQuery := " SELECT * FROM " + RetSqlName('SED') + " (NOLOCK)"
		cQuery += " WHERE ED_CONTA ='"+SA1->A1_CONTA+"'"
		cQuery += " AND D_E_L_E_T_ = ''"

		dbUseArea(.T., 'TOPCONN', TCGenQry(,,cQuery), "TRB", .F., .T.)        
        _nat := TRB->ED_CODIGO
        dbselectarea("TRB")
        dbclosearea("TRB")
        
		RecLock("SE1",.F.)
		SE1->E1_NATUREZ := _nat
		MsUnlock()
    endif
    
	SE1->(dbskip())
	
enddo


return nil
