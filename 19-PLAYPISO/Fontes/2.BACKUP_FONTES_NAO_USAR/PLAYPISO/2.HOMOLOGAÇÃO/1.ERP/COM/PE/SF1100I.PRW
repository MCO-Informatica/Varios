# include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SF1100I   ºAutor  ³Avelino Santiago    º Data ³  23/08/2008 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina responsável pela amarração da nota de entrada com osº±±
±±º          ³ titulos do financeiro 									  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP8 - Mapsolo                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function SF1100I()

_cObra 			:= Space(09)                                                                            
_cDescObr 	:= ""  
_cProjobr  		:= ""
_cProjeto 		:= ""

dbSelectArea("SD1")
dbSetorder(1)
If dbSeek(xFilial("SD1") + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA)
	_cObra := SD1->D1_CC
Endif

dbSelectArea("SE2")
dbSetOrder(6)
If dbSeek(xFilial("SE2") + SF1->F1_FORNECE + SF1->F1_LOJA + SF1->F1_SERIE + SF1->F1_DOC)
	While !Eof() .and. SF1->F1_FORNECE + SF1->F1_LOJA + SF1->F1_SERIE + SF1->F1_DOC == SE2->E2_FORNECE + SE2->E2_LOJA + SE2->E2_PREFIXO + SE2->E2_NUM

		dbSelectArea("CTT")  // Posiciona CTT para trazer a descrição da Obra MHD 17/12/09
		DbsetOrder(1)
		DbSeek(xfilial("CTT")+_cObra)
		_cDescObr := CTT->CTT_DESC01                     
		
		dbSelectArea("AF8")  // Posiciona CTT para trazer a descrição da Obra MHD 17/12/09
		DbsetOrder(8)
		DbSeek(xfilial("AF8")+_cObra)
        If Found()
			_cProJoBR := AF8->AF8_CODOBR
			_cProjeto   := AF8->AF8_PROJET
        Endif
        
		dbSelectArea("SE2")
		dbSetOrder(6)
		RecLock("SE2", .F.)
		SE2->E2_XCC 			:= _cObra
		SE2->E2_XDESCR    := _cDescObr
		SE2->E2_XPROJET	:= _cProjeto
		MsUnlock()                         
	
		dbSelectArea("SE2")
		dbSetOrder(6)
		dbSkip()
	
	Enddo
Endif

Return(.T.)  
