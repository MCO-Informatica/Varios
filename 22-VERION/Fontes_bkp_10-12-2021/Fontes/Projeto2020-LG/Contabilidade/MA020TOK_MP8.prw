#Include "Rwmake.ch"
#Include "Protheus.ch"
#Include "TopConn.ch"

/*
+------------+----------+--------+---------------+-------+--------------+
| Programa:  | MA020TOK | Autor: | Flávio Sardão | Data: | Janeiro/2010 |
+------------+----------+--------+---------------+-------+--------------+
| Descrição: | Ponto de Entrada na Inclusão de Fornecedores para inclu- |
|            | ir a Conta Contábil respectiva.                          |
+------------+----------------------------------------------------------+
| Uso:       | Verion Óleo Hidráulica Ltda.                             |
+------------+----------------------------------------------------------+
*/

User Function MA020TOK

// +-------------------------+
// | Declaração de Variáveis |
// +-------------------------+

Local _aArea := GetArea()

_cConta := "211001"

// +--------------------------------------------------------+
// | Verifica se já existe Conta Contábil para o Fornecedor |
// +--------------------------------------------------------+

DbSelectArea("CT1")
DbSetOrder(1)
                 
_cCodFor := M->A2_COD

If !DbSeek(xFilial("CT1") + _cConta + _cCodFor,.f.)


	While !RecLock("CT1",.t.)
	Enddo
	CT1->CT1_CONTA  := _cConta + _cCodFor
	CT1->CT1_DESC01 := M->A2_NOME
	CT1->CT1_CLASSE := "2"
	CT1->CT1_NORMAL := "2"
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
	CT1->CT1_DTEXIS :=  CToD('01/01/1980') //dDataBase
	CT1->CT1_AGLSLD := "2"
	CT1->CT1_CCOBRG := "2"
	CT1->CT1_ITOBRG := "2"
	CT1->CT1_CLOBRG := "2"
	CT1->CT1_LALUR  := "0"
	CT1->CT1_CTLALU := _cConta + _cCodFor
	MsUnLock()

EndIf

// +----------------------------+
// | Restaura Ambiente Original |
// +----------------------------+

RestArea(_aArea)

Return(.t.)