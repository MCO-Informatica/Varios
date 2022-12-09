#Include 'Protheus.ch'

User Function F450OWN()

Local cString := ""

cString := 'E1_FILIAL="' + cFilial+ '" .And. '
cString += 'DTOS(E1_VENCREA)>="' + DTOS(dVenIni450) + '" .And. '
cString += 'DTOS(E1_VENCREA)<="' + DTOS(dVenFim450) + '" .And. '

// Se nao considera titulos transferidos, filtra (exibe) apenas os titulos que estao em carteira.
If mv_par03 == 2

cString += 'E1_SITUACA $"0123FG" .And. '

Endif

cString += 'E1_MOEDA=' + Alltrim(Str(nMoeda,2)) + ' .And. '
cString += 'E1_TIPO = "NF" .And. '
cString += 'E1_SALDO >0 '


ALERT("F450OWN - RECEBER")
ALERT(CSTRING)

Return(cString)               