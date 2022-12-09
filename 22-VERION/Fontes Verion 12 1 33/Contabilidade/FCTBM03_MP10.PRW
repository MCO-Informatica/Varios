#Include "Rwmake.ch"

/*
+------------+---------+--------+---------------+-------+---------------+
| Programa:  | FCTBM03 | Autor: | Flávio Sardão | Data: | Setembro/2010 |
+------------+---------+--------+---------------+-------+---------------+
| Descrição: | Altera Conta Contábeis da Tabela CT2                     |
+------------+----------------------------------------------------------+
| Uso:       | Verion Óleo Hidráulica Ltda.                             |
+------------+----------------------------------------------------------+
*/

User Function FCTBM03

// +-------------------------+
// | Declaração de Variáveis |
// +-------------------------+

Local _aArea := GetArea()

// +-------------------------+
// | Posiciona na Tabela CT2 |
// +-------------------------+

DbSelectArea("CT2")
DbSetOrder(1)
DbGoTop()

While !Eof()

		// +-------------------------+
		// | Busca Conta Débito Nova |
		// +-------------------------+

		DbSelectArea("CT1")
		DbSetOrder(1)

		If DbSeek(xFilial("CT1") + CT2->CT2_DEBITO,.f.) .And. !Empty(CT2->CT2_DEBITO)

			While !RecLock("CT2",.f.)
			Enddo
			CT2->CT2_DEBITO := Alltrim(CT1->CT1_DESC02)
			MsUnLock()

		EndIf

		// +--------------------------+
		// | Busca Conta Crédito Nova |
		// +--------------------------+

		DbSelectArea("CT1")
		DbSetOrder(1)

		If DbSeek(xFilial("CT1") + CT2->CT2_CREDIT,.f.) .And. !Empty(CT2->CT2_CREDIT)

			While !RecLock("CT2",.f.)
			Enddo
			CT2->CT2_CREDIT := Alltrim(CT1->CT1_DESC02)
			MsUnLock()

		EndIf

		DbSelectArea("CT2")
		DbSkip()
Enddo

// +----------------------------+
// | Restaura Ambiente Original |
// +----------------------------+

RestArea(_aArea)

Return
