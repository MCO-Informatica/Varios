#Include "Rwmake.ch"
#Include "Protheus.ch"
#Include "TopConn.ch"

User Function Cplano1

// +-------------------------+
// | Declaração de Variáveis |
// +-------------------------+

Local _aArea := GetArea()

_cConta := "112001"

// +-----------------------------------------------------+
// | Verifica se já existe Conta Contábil para o Cliente |
// +-----------------------------------------------------+

DbSelectArea("SA1")
DbSetOrder(1)
DbGotop()

While !EOF()
 
DbSelectArea("CT1")
DbSetOrder(1)                            

_cCodCli := IIF(SM0->M0_CODIGO == "01",SA1->A1_COD,SUBS(SA1->A1_COD,2,5))

If !DbSeek(xFilial("CT1") + _cConta + _cCodCli,.f.)

	While !RecLock("CT1",.t.)
	Enddo
	CT1->CT1_CONTA  := _cConta + _cCodCli
	CT1->CT1_DESC01 := SA1->A1_NOME
	CT1->CT1_CLASSE := "2"
	CT1->CT1_NORMAL := "1"
	CT1->CT1_RES    := ""
	CT1->CT1_BLOQ   := "2"
	CT1->CT1_DC     := ""
	CT1->CT1_CVD02  := "1"
	CT1->CT1_CVD03  := "1"
	CT1->CT1_CVD04  := "1"
	CT1->CT1_CVD05  := "1"
	CT1->CT1_CVC02  := "1"
	CT1->CT1_CVC03  := "1"
	CT1->CT1_CVC04  := "1"
	CT1->CT1_CVC05  := "1"
	CT1->CT1_CTASUP := _cConta
	CT1->CT1_ACITEM := "2"
	CT1->CT1_ACCUST := "2"
	CT1->CT1_ACCLVL := "2"
	CT1->CT1_DTEXIS := CTOD("01/01/80")
	CT1->CT1_AGLSLD := "2"
	CT1->CT1_CCOBRG := "2"
	CT1->CT1_ITOBRG := "2"
	CT1->CT1_CLOBRG := "2"
	CT1->CT1_LALUR  := "0"
	CT1->CT1_CTLALU := _cConta + _cCodCli
	MsUnLock()

Elseif DbSeek(xFilial("CT1") + _cConta + _cCodCli,.f.)

	While !RecLock("CT1",.f.)
	Enddo
	CT1->CT1_DESC01 := SA1->A1_NOME
	MsUnLock()

EndIf

DbSelectArea("SA1")
DbSetOrder(1)
Dbskip()

Enddo
                
ALERT ("TERMINO DE PROCESSAMENTO !!!")

// +----------------------------+
// | Restaura Ambiente Original |
// +----------------------------+

RestArea(_aArea)

Return(.t.)
