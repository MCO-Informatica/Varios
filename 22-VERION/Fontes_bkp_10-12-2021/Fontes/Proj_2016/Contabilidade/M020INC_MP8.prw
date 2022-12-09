#Include "Rwmake.ch"
#Include "Protheus.ch"
#Include "TopConn.ch"

/*
+------------+----------+--------+-----------------+-------+--------------+
| Programa:  | M020INC  | Autor: | Silverio Bastos | Data: | Janeiro/2010 |
+------------+----------+--------+-----------------+-------+--------------+
| Descrição: | Ponto de Entrada na Inclusão de Fornecedores para incluir  |
|            | a Conta Contábil respectiva.                               |
+------------+------------------------------------------------------------+
| Uso:       | Verion Óleo Hidráulica Ltda.                               |
+------------+------------------------------------------------------------+
*/

User Function M020INC

// +-------------------------+
// | Declaração de Variáveis |
// +-------------------------+

Local _aArea := GetArea()

_cConta := "211001"

// Rotina para criação da Conta Contabil no Fornecedor.

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