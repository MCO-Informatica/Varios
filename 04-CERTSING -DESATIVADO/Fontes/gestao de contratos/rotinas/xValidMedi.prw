#Include 'Protheus.ch'

/*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
FONTE CUSTOMIZADO CHAMADO xValidMedi, PARA VALIDAR SE O CONTRATO FOR PARCELADO, A QUANTIDADE TEM QUE SER SEMPRE 1.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%*/
User Function xValidMedi()

Local _cContrato := M->CND_CONTRA
Local _cRevisao  := M->CND_REVISA
Local _cNumero   := M->CND_NUMERO
Local _nQuant    := aCols[n,Ascan(aHeader, {|x| Alltrim(x[2]) == "CNE_QUANT" })]  //M->CNE_QUANT


DbSelectArea("CNA")
DbSetOrder(1)

If DbSeek(xFilial("CNA")+ _cContrato + _cRevisao + _cNumero,.f.)
    IF CNA->CNA_XPARC = "S"
        IF !aCols[N][Len(aHeader)+1]
            IF aCols[n,Ascan(aHeader, {|x| Alltrim(x[2]) == "CNE_QUANT" })] <> 1 .OR. aCols[n,Ascan(aHeader, {|x| Alltrim(x[2]) == "CNE_QUANT" })] == 0//Round(nQuant,0) //cValtoChar(Round( M->CNE_QUANT, 0 ))
                Alert("Contratos parcelados não permitem medição de quantidade diferente de 1")
                //aCols[N][_nQuant] := 1
                _nQuant := 0
            ENDIF
        ENDIF
    ENDIF
ENDIF

Return _nQuant
