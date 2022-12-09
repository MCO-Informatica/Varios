#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMVCDEF.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ FT300MNU | Autor ³ Luiz Alberto        ³ Data ³ 06/07/16 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Objetivo  ³ Ponto de Entrada Adicionar Opçao Copia de Oportunidades
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ METALACRE                                        ³±±
±±                                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
/*/
User Function FT300MNU()                               
Local aArea := GetArea()
Local aRot	:= {}

aRotina := PARAMIXB[1]
 
ADD OPTION aRotina TITLE "Copia" ACTION "U_CpyOpor()" OPERATION 2 ACCESS 0

//AADD(aRotina,{ "Copia","U_CpyOpor()",0,6,0,NIL})

RestArea(aArea)
Return aRotina


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ CpyOpor | Autor ³ Luiz Alberto        ³ Data ³ 06/07/16 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Objetivo  ³ Função para Efetuar Copia de Oportunidade de Vendas
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ METALACRE                                        ³±±
±±                                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
/*/
User Function CpyOpor()                               
Local aArea 	:= 	GetArea()

If !MsgYesNo("Confirma a Cópia da Oportunidade de Vendas " + AD1->AD1_NROPOR + " ?") 
	Return .f.
Else
	Processa({||U_CppNow(), 'Aguarde a Copia da Oportunidade ' + AD1->AD1_NROPOR + "..."})   
Endif               

RestArea(aArea)
Return .t.


User Function CppNow()
Local aArea := GetArea()
Local nReg2	:=	1
Local nReg3	:=	1
Local nReg4	:=	1
Local nReg9	:=	1
Local nRegj	:=	1

cOpoOri		:=	AD1->AD1_NROPOR
cOpoRev		:=	AD1->AD1_REVISA
cCodOpor	:=	GetSx8Num("AD1","AD1_NROPOR")
cRevisao	:=	'01'
ConfirmSx8()        

// Leitura das Tabelas da Oportunidade atual

aDadosAD1 := {}
aDadosAD2 := {}
aDadosAD3 := {}
aDadosAD4 := {}
aDadosAD9 := {}
aDadosADJ := {}

ProcRegua(AD1->(FCount()))
For nI := 1 To AD1->(FCount())
	IncProc('Copiando Cabeçalho...Campo: '+RetTitle(AD1->(FieldName(nI))))
	
	AAdd(aDadosAD1, {AD1->(FieldName(nI)),AD1->(FieldGet(nI))} )
Next                                         

If AD2->(dbSetOrder(1), dbSeek(xFilial("AD2")+cOpoOri+cOpoRev))
	nReg2 := 1
	While AD2->(!Eof()) .And. AD2->AD2_FILIAL	==	xFilial("AD2") .And. AD2->AD2_NROPOR == cOpoOri .And. AD2->AD2_REVISA == cOpoRev
		ProcRegua(AD2->(FCount()))
		For nI := 1 To AD2->(FCount())
			IncProc('Copiando Time Vendas...Campo: '+RetTitle(AD2->(FieldName(nI))))
			
			AAdd(aDadosAD2, {nReg2,AD2->(FieldName(nI)),AD2->(FieldGet(nI))} )
		Next                                         
		AD2->(dbSkip(1))
		nReg2++
	Enddo
Endif

If AD3->(dbSetOrder(1), dbSeek(xFilial("AD3")+cOpoOri+cOpoRev))
	nReg3 := 1
	While AD3->(!Eof()) .And. AD3->AD3_FILIAL	==	xFilial("AD3") .And. AD3->AD3_NROPOR == cOpoOri .And. AD3->AD3_REVISA == cOpoRev
		ProcRegua(AD3->(FCount()))
		For nI := 1 To AD3->(FCount())
			IncProc('Copiando Concorrentes...Campo: '+RetTitle(AD3->(FieldName(nI))))
			
			AAdd(aDadosAD3, {nReg3,AD3->(FieldName(nI)),AD3->(FieldGet(nI))} )
		Next                                         
		AD3->(dbSkip(1))
		nReg3++
	Enddo
Endif

If AD4->(dbSetOrder(1), dbSeek(xFilial("AD4")+cOpoOri+cOpoRev))
	nReg4 := 1
	While AD4->(!Eof()) .And. AD4->AD4_FILIAL	==	xFilial("AD4") .And. AD4->AD4_NROPOR == cOpoOri .And. AD4->AD4_REVISA == cOpoRev
		ProcRegua(AD4->(FCount()))
		For nI := 1 To AD4->(FCount())
			IncProc('Copiando Parceiros...Campo: '+RetTitle(AD4->(FieldName(nI))))
			
			AAdd(aDadosAD4, {nReg4,AD4->(FieldName(nI)),AD4->(FieldGet(nI))} )
		Next                                         
		AD4->(dbSkip(1))
		nReg4++
	Enddo
Endif

If AD9->(dbSetOrder(1), dbSeek(xFilial("AD9")+cOpoOri+cOpoRev))
	nReg9 := 1
	While AD9->(!Eof()) .And. AD9->AD9_FILIAL	==	xFilial("AD9") .And. AD9->AD9_NROPOR == cOpoOri .And. AD9->AD9_REVISA == cOpoRev
		ProcRegua(AD9->(FCount()))
		For nI := 1 To AD9->(FCount())
			IncProc('Copiando Contatos...Campo: '+RetTitle(AD9->(FieldName(nI))))
			
			AAdd(aDadosAD9, {nReg9,AD9->(FieldName(nI)),AD9->(FieldGet(nI))} )
		Next                                         
		AD9->(dbSkip(1))
		nReg9++
	Enddo
Endif
            
If ADJ->(dbSetOrder(1), dbSeek(xFilial("ADJ")+cOpoOri+cOpoRev))
	nRegj := 1
	While ADJ->(!Eof()) .And. ADJ->ADJ_FILIAL	==	xFilial("ADJ") .And. ADJ->ADJ_NROPOR == cOpoOri .And. ADJ->ADJ_REVISA == cOpoRev
		ProcRegua(ADJ->(FCount()))
		For nI := 1 To ADJ->(FCount())
			IncProc('Copiando Produtos...Campo: '+RetTitle(ADJ->(FieldName(nI))))
			
			AAdd(aDadosADJ, {nRegj,ADJ->(FieldName(nI)),ADJ->(FieldGet(nI))} )
		Next                                         
		ADJ->(dbSkip(1))
		nRegj++
	Enddo
Endif

/// Gravação
                          
If AD1->(dbSetOrder(1), dbSeek(xFilial("AD1")+cCodOpor))
	cCodOpor	:=	GetSx8Num("AD1","AD1_NROPOR")
	cRevisao	:=	'01'
	ConfirmSx8()        
Endif
If RecLock("AD1",.t.)
	ProcRegua(Len(aDadosAD1))
	For nI := 1 To Len(aDadosAD1)                                        
		IncProc('Gravando Cópia...Campo: '+RetTitle(aDadosAD1[nI,1]))
   		If aDadosAD1[nI,1]=='AD1_FILIAL'
   			AD1->AD1_FILIAL := xFilial("AD1")
   		ElseIf aDadosAD1[nI,1]=='AD1_NROPOR'
   			AD1->AD1_NROPOR	:=	cCodOpor
   		ElseIf aDadosAD1[nI,1]=='AD1_REVISA'
   			AD1->AD1_REVISA	:=	'01'
   		Else
			nPos := AD1->(FieldPos(aDadosAD1[nI,1]))
			AD1->(FieldPut(nPos,aDadosAD1[nI,2]))
		Endif
	Next
	AD1->AD1_STATUS	:=	'1'      
	AD1->AD1_ENCERR	:=	''      
	AD1->AD1_MEMENC	:=	''      
	AD1->AD1_DTENCE	:=	CtoD('')
	AD1->AD1_POTPED	:=	0
	AD1->AD1_POTCTR	:=	0
	AD1->AD1_DATA	:=	dDataBase
	AD1->AD1_HORA	:=	Left(Time(),5)
	AD1->AD1_USER	:=	__cUserId
	AD1->AD1_PROVEN	:=	'000001'
	AD1->AD1_STAGE	:=	'000001'
	AD1->AD1_COPIA	:=	'S'
	AD1->AD1_OPORI	:=	cOpoOri
	AD1->(MsUnlock())
Endif

If Len(aDadosAD2)> 0 
	ProcRegua(Len(aDadosAD2))
	For nReg := 1 To nReg2-1
		RecLock("AD2",.t.)
		For nI := 1 To Len(aDadosAD2)                                        
			If aDadosAD2[nI,1]==nReg
				IncProc('Gravando Cópia...Campo: '+RetTitle(aDadosAD2[nI,2]))
		   		If aDadosAD2[nI,2]=='AD2_FILIAL'
		   			AD2->AD2_FILIAL := xFilial("AD2")
		   		ElseIf aDadosAD2[nI,2]=='AD2_NROPOR'
		   			AD2->AD2_NROPOR	:=	cCodOpor
		   		ElseIf aDadosAD2[nI,2]=='AD2_REVISA'
		   			AD2->AD2_REVISA	:=	'01'
		   		Else
					nPos := AD2->(FieldPos(aDadosAD2[nI,2]))
					AD2->(FieldPut(nPos,aDadosAD2[nI,3]))
				Endif
			Endif
		Next
		AD2->(MsUnlock())
	Next
Endif

If Len(aDadosAD3)> 0 
	ProcRegua(Len(aDadosAD3))
	For nReg := 1 To nReg3-1
		RecLock("AD3",.t.)
		For nI := 1 To Len(aDadosAD3)                                        
			If aDadosAD3[nI,1]==nReg
				IncProc('Gravando Cópia...Campo: '+RetTitle(aDadosAD3[nI,2]))
		   		If aDadosAD3[nI,2]=='AD3_FILIAL'
		   			AD3->AD3_FILIAL := xFilial("AD3")
		   		ElseIf aDadosAD3[nI,2]=='AD3_NROPOR'
		   			AD3->AD3_NROPOR	:=	cCodOpor
		   		ElseIf aDadosAD3[nI,2]=='AD3_REVISA'
		   			AD3->AD3_REVISA	:=	'01'
		   		Else
					nPos := AD3->(FieldPos(aDadosAD3[nI,2]))
					AD3->(FieldPut(nPos,aDadosAD3[nI,3]))
				Endif
			Endif
		Next
		AD3->(MsUnlock())
	Next
Endif      

If Len(aDadosAD4)> 0 
	ProcRegua(Len(aDadosAD4))
	For nReg := 1 To nReg4-1
		RecLock("AD4",.t.)
		For nI := 1 To Len(aDadosAD4)                                        
			If aDadosAD4[nI,1]==nReg
				IncProc('Gravando Cópia...Campo: '+RetTitle(aDadosAD4[nI,2]))
		   		If aDadosAD4[nI,2]=='AD4_FILIAL'
		   			AD4->AD4_FILIAL := xFilial("AD4")
		   		ElseIf aDadosAD4[nI,2]=='AD4_NROPOR'
		   			AD4->AD4_NROPOR	:=	cCodOpor
		   		ElseIf aDadosAD4[nI,2]=='AD4_REVISA'
		   			AD4->AD4_REVISA	:=	'01'
		   		Else
					nPos := AD4->(FieldPos(aDadosAD4[nI,2]))
					AD4->(FieldPut(nPos,aDadosAD4[nI,3]))
				Endif
			Endif
		Next
		AD4->(MsUnlock())
	Next
Endif      

If Len(aDadosAD9)> 0 
	ProcRegua(Len(aDadosAD9))
	For nReg := 1 To nReg9-1
		RecLock("AD9",.t.)
		For nI := 1 To Len(aDadosAD9)                                        
			If aDadosAD9[nI,1]==nReg
				IncProc('Gravando Cópia...Campo: '+RetTitle(aDadosAD9[nI,2]))
		   		If aDadosAD9[nI,2]=='AD9_FILIAL'
		   			AD9->AD9_FILIAL := xFilial("AD9")
		   		ElseIf aDadosAD9[nI,2]=='AD9_NROPOR'
		   			AD9->AD9_NROPOR	:=	cCodOpor
		   		ElseIf aDadosAD9[nI,2]=='AD9_REVISA'
		   			AD9->AD9_REVISA	:=	'01'
		   		Else
					nPos := AD9->(FieldPos(aDadosAD9[nI,2]))
					AD9->(FieldPut(nPos,aDadosAD9[nI,3]))
				Endif
			Endif
		Next
		AD9->(MsUnlock())
	Next
Endif      

If Len(aDadosADJ)> 0 
	ProcRegua(Len(aDadosADJ))
	For nReg := 1 To nRegj-1
		RecLock("ADJ",.t.)
		For nI := 1 To Len(aDadosADJ)                                        
			If aDadosADJ[nI,1]==nReg
				IncProc('Gravando Cópia...Campo: '+RetTitle(aDadosADJ[nI,2]))
		   		If aDadosADJ[nI,2]=='ADJ_FILIAL'
		   			ADJ->ADJ_FILIAL := xFilial("ADJ")
		   		ElseIf aDadosADJ[nI,2]=='ADJ_NROPOR'
		   			ADJ->ADJ_NROPOR	:=	cCodOpor
		   		ElseIf aDadosADJ[nI,2]=='ADJ_REVISA'
		   			ADJ->ADJ_REVISA	:=	'01'
		   		Else
					nPos := ADJ->(FieldPos(aDadosADJ[nI,2]))
					ADJ->(FieldPut(nPos,aDadosADJ[nI,3]))
				Endif
			Endif
		Next
		ADJ->(MsUnlock())
	Next
Endif

MsgInfo("Copia Efetuada Com Sucesso - Nova Oportunidade de Vendas Gerada - " + cCodOpor)

RestArea(aArea)
Return .t.

	

                 
