#Include "Rwmake.ch"
#Include "Protheus.ch"
#Include "TopConn.ch"

/*
+------------+----------+--------+-----------------+-------+--------------+
| Programa:  | M020INC  | Autor: | Silverio Bastos | Data: | Janeiro/2010 |
+------------+----------+--------+-----------------+-------+--------------+
| Descri��o: | Ponto de Entrada na Inclus�o de Fornecedores para incluir  |
|            | a Conta Cont�bil respectiva.                               |
+------------+------------------------------------------------------------+
| Uso:       | Verion �leo Hidr�ulica Ltda.                               |
+------------+------------------------------------------------------------+
*/

User Function M020INC

// +-------------------------+
// | Declara��o de Vari�veis |
// +-------------------------+

Local _aArea := GetArea()

_cConta := "211001"

// Rotina para cria��o da Conta Contabil no Fornecedor.

_cCodFor := SA2->A2_COD

While !RecLock("SA2",.f.)
Enddo
SA2->A2_CONTA  := _cConta + SA2->A2_COD
MsUnLock()


// +----------------------------+
// | Restaura Ambiente Original |
// +----------------------------+

RestArea(_aArea)

Return(.t.)
