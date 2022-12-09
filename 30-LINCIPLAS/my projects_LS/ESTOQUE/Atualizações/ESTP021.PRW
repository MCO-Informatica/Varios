#INCLUDE "rwmake.CH"
#INCLUDE "PROTHEUS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ESTP021   ºAutor  ³Ilidio Abreu	     º Data ³  05/03/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Esta rotina tem por objetivo rever e / ou atualizar os TES º±±
±±º          ³ de entrada e saida da tabela SBZ baseado em uma matriz que º±±
±±º          ³ deve ser atualizada dentro deste programa.                 º±±
±±º          ³ Esta rotina foi feita para ser usada apenas uma vez....    º±±
±±º          ³ (...espero...)                                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laselva Bookstore                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/                                                         

User function ESTP021   

dbselectarea("SB1") 
dbSetOrder(1)

dbselectarea("SBZ") 
dbgotop()


aTES	:= {} 	// TES Saida e Entrada
// aTES {Grupo de Produto, TES Entrada, TES Saida}
// AaDd(aTES	,{"0002", "235", "708" })
// AaDd(aTES	,{"0003", "229", "760" })
AaDd(aTES	,{"0004", "229", "847" })
AaDd(aTES	,{"0006", "229", "847" })
// AaDd(aTES	,{"0013", "235", "708" })
// AaDd(aTES	,{"0001", "235", "756" })
// AaDd(aTES	,{"0031", "235", "756" })
// AaDd(aTES	,{"0019", "235", "756" })
// AaDd(aTES	,{"0017", "235", "708" })
// AaDd(aTES	,{"0013", "235", "708" })
// AaDd(aTES	,{"0018", "235", "756" })
// AaDd(aTES	,{"0029", "235", "756" })
// AaDd(aTES	,{"0016", "235", "756" })
// AaDd(aTES	,{"0002", "235", "708" })
// AaDd(aTES	,{"0008", "235", "708" })
// AaDd(aTES	,{"0007", "229", "760" })
// AaDd(aTES	,{"0010", "235", "760" })

While ! SBZ->(eof())
	// Procura em SB1 o Grupo deste produto
	if ! SB1->(dbseek("  "+SBZ->BZ_COD))
		SBZ->(dbskip())
		Loop
    endif   

	// Procura os TES em aTES
	nPos:= 0
    nPos := aScan(aTES,{|x| x[1] == SB1->B1_GRUPO })
	if nPos == 0 
		SBZ->(dbskip())
		Loop
	endif    
    
   reclock("SBZ", .f.)
    SBZ->BZ_TE := aTES[nPos][2]
    
	if nPos = 1 .or. nPos = 2       // revistas
	    SBZ->BZ_TE := "229"
		if isdigit(SBZ->BZ_FILIAL)
			SBZ->BZ_TS := "710" 		
    	else
    	 	SBZ->BZ_TS := "516"
    	 endif
	endif
	
	msunlock()
	SBZ->(dbskip())

Enddo
