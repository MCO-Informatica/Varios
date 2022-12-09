#INCLUDE "protheus.ch"

User Function FC0101FAT()

Local _aCpos:={}

AAdd(_aCpos,"F2_FILIAL")
AAdd(_aCpos,"F2_EMISSAO")
AAdd(_aCpos,"F2_SERIE")
AAdd(_aCpos,"F2_DOC")
AAdd(_aCpos,"F2_DUPL")
AAdd(_aCpos,"F2_VALFAT")
AAdd(_aCpos,"F2_FRETE")
AAdd(_aCpos,"F2_HORA")
AAdd(_aCpos,"F2_TRANSP")
AAdd(_aCpos,"A4_NREDUZ")
AAdd(_aCpos,"F2_REDESP")
AAdd(_aCpos,"F2_X_NOMRD")
AAdd(_aCpos,"F2_NFELETR")

Return(_aCpos)