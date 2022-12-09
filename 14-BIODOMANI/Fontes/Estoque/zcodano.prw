//Bibliotecas
#Include "Protheus.ch"
#Include "TopConn.ch"

// Modo de Uso
// 1) - Criar Gatilho com as seguintes espeficicacoes
// 2) CAMPO: D1_LOCAL  
// 3) REGRA: iif(M->D1_LOCAL="01A3", U_zCodAno(),"")
// 4) CONTRADOMINIO: D1_LOTECTL

User Function zCodAno()

cCodFull := GetSx8Num("LOT")
confirmSx8()

cMes := StrZero(Month(dDataBase),2)
cYear:= StrZero(Year(dDataBase),4)

Return (cCodFull+"-"+cMes+"/"+cYear)
