#Include "Totvs.ch"

User Function FA100ROT              

Local aRotina := aClone(PARAMIXB[1])//Adiciona Rotina Customizada a EnchoiceBar

aAdd( aRotina, { "Rastrear LP", "U_CSCTB01('SE5',SE5->E5_NUMERO,SE5->E5_CLIFOR,SE5->E5_LOJA,SE5->E5_DATA,SE5->(RECNO()))", 0 ,12 })

Return aRotina                                        