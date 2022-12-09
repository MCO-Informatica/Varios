//Bibliotecas
#Include "Protheus.ch"
#Include "TopConn.ch"

// Modo de Uso
// 2) CAMPO: D3_LOCAL  
// 3) CONTRADOMINIO: D3_LOTECTL

User Function RESTG06()

Local _cCodFull := ""
Local _cMes     := ""
Local _cYear    := ""
Local _cLote    := ""
Local _cArmazem	:= ""

//----> MOVIMENTACAO MULTIPLA DE ENTRADA
If Alltrim(FunName())$"MATA241" .and. cTM < "500"
    _cArmazem	:= aCols[n,Ascan(aHeader, {|x| Alltrim(x[2]) == "D3_LOCAL" })]

//----> MOVIMENTACAO SIMPLES DE ENTRADA
ElseIf Alltrim(FunName())$"MATA240" .and. cTM < "500"
    _cArmazem	:= M->D3_LOCAL
EndIf

//----> ARMAZEM DE EMBALAGEM COM ENDERECAMENTO
IF _cArmazem$"01A3"
    
    _cCodFull := GetSx8Num("LOT")
    confirmSx8()

    _cMes := StrZero(Month(dDataBase),2)
    _cYear:= StrZero(Year(dDataBase),4)

    _cLote:= _cCodFull+"-"+_cMes+"/"+_cYear
ELSE
    _cLote:= aCols[n,Ascan(aHeader, {|x| Alltrim(x[2]) == "D3_LOTECTL" })]
ENDIF

Return (_cLote)
