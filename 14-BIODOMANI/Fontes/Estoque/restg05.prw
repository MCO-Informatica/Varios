//Bibliotecas
#Include "Protheus.ch"
#Include "TopConn.ch"

// Modo de Uso
// 1) - Criar Gatilho com as seguintes espeficicacoes
// 2) CAMPO: D1_LOCAL  
// 3) REGRA: iif(M->D1_LOCAL="01A3", U_zCodAno(),"")
// 4) CONTRADOMINIO: D1_LOTECTL

User Function RESTG05()

Local cCodFull  := ""
Local cMes      := ""
Local cYear     := ""


IF ALLTRIM(FUNNAME())$" MATA240.MATA241" .and. CTM < "500" 
    cCodFull := GetSx8Num("LOT")
    confirmSx8()

    cMes := StrZero(Month(dDataBase),2)
    cYear:= StrZero(Year(dDataBase),4)
ENDIF

Return (cCodFull+"-"+cMes+"/"+cYear)
