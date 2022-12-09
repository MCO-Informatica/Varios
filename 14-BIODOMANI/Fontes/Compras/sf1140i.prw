#Include 'Protheus.ch'

//---------------------------------------------------------------------------------
// Rotina | SF1140I        | Autor | Lucas Baia          | Data |    29/08/2022	
//---------------------------------------------------------------------------------
// Descr. | Ponto de Entrada executado após a Inclusão de Pré-Nota.
//---------------------------------------------------------------------------------
// Uso    | BIODOMANI COSMETICOS
//---------------------------------------------------------------------------------


User Function SF1140I()

Local _lInclui  := PARAMIXB[1]
Local _lAltera  := PARAMIXB[2]
Local _aArea    := GetArea()
Local _aAreaSD1 := SD1->(GetArea())
Local l01a3     := .f.

If _lInclui .OR. _lAltera

    SD1->(DbSetOrder(1),dbSeek(xfilial()+sf1->f1_doc+sf1->f1_serie+sf1->f1_fornece+sf1->f1_loja))
    While !sd1->(Eof()) .And. sd1->(d1_filial+d1_doc+d1_serie+d1_fornece+d1_loja) == sf1->(f1_filial+F1_doc+F1_serie+F1_fornece+F1_loja)

		if sd1->d1_local == "01A3"
			l01a3 := .t.
		endif
        sd1->(dbSkip())
	Enddo

    if l01a3
		u_docgrf(SF1->F1_DOC,SF1->F1_SERIE,SF1->F1_FORNECE,SF1->F1_LOJA)
	endif

ENDIF

RestArea(_aAreaSD1)
RestArea(_aArea)

Return
