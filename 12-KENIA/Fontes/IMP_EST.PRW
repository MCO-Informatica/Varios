#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 16/04/05

User Function IMP_EST()        // incluido pelo assistente de conversao do AP6 IDE em 16/04/05

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("_CARQSB1,_ANOMECPO,_ATIPOCPO,_ATAMCPO,_ADECCPO,_AFIELDS")
SetPrvt("_I,FVAL,")

processa({||RunProc()},"Saldo Inicial por Lote")// Substituido pelo assistente de conversao do AP6 IDE em 16/04/05 ==> processa({||Execute(RunProc)},"Exporta Base de Dados")
return

// Substituido pelo assistente de conversao do AP6 IDE em 16/04/05 ==> function runproc
Static function runproc()

dbSelectArea("SBJ")
_cIndex	:=	Criatrab(Nil,.f.)
_cChave	:=	"SBJ->(BJ_FILIAL+DTOS(BJ_DATA)+BJ_COD+BJ_LOCAL)"
IndRegua("SBJ",_cIndex,_cChave,,,"Selecionando Indice...")
ProcRegua(LastRec())

_nSaldo	:=	0
_nSaldo2:=	0

dbSeek(xFilial("SBJ")+"20050430",.f.)

While !Eof() .And. Dtos(SBJ->BJ_DATA) == "20050430"
	
	_cChave	:=	SBJ->(BJ_COD+BJ_LOCAL)
	_cProd	:=	SBJ->BJ_COD
	_cLocal	:=	SBJ->BJ_LOCAL
	
	While SBJ->(BJ_COD+BJ_LOCAL) == _cChave
			
		IncProc("Saldos Iniciais por Lote")
	
		_nSaldo		+=	SBJ->BJ_QINI 
		_nSaldo2	+=	SBJ->BJ_QISEGUM			
	
		dbSelectArea("SBJ")
		dbSkip()
	EndDo

	dbSelectArea("SB9")
	dbSetOrder(1)
	If dbSeek(xFilial("SB9")+_cChave,.f.)
		RecLock("SB9",.f.)
	    SB9->B9_QINI	:=	_nSaldo
	    SB9->B9_QISEGUM	:=	_nSaldo2
	    MsUnLock()
	Else
		RecLock("SB9",.t.)
	    SB9->B9_FILIAL	:=	xFilial("SB9")
	    SB9->B9_COD		:=	_cProd
	    SB9->B9_COD		:=	_cLocal
	    SB9->B9_QINI	:=	_nSaldo
	    SB9->B9_QISEGUM	:=	_nSaldo2
	    SB9->B9_DATA	:=	CTOD("30/04/05")
	    MsUnLock()
    EndIf
	
	_nSaldo	:=	0
	_nSaldo2:=	0
	
	dbSelectArea("SBJ")
EndDo

Return
