#Include "Rwmake.ch"

/*
+------------+---------+--------+---------------+-------+---------------+
| Programa:  | FCTBM03 | Autor: | Fl?vio Sard?o | Data: | Setembro/2010 |
+------------+---------+--------+---------------+-------+---------------+
| Descri??o: | Altera Conta Cont?beis da Tabela CT2                     |
+------------+----------------------------------------------------------+
| Uso:       | Verion ?leo Hidr?ulica Ltda.                             |
+------------+----------------------------------------------------------+
*/

User Function FCTBM03

// +-------------------------+
// | Declara??o de Vari?veis |
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
		// | Busca Conta D?bito Nova |
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
		// | Busca Conta Cr?dito Nova |
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