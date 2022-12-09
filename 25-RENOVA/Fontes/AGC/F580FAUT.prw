#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWBROWSE.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"
#Include "Rwmake.ch"
/*...................................................................
. Programa.: 	F580FAUT ............................................
. Autor....:	Alcouto                                             .
. Data.....: 	23/03/2021                                          .
. Descricao: 	PE utilizado para substituir o filtro da rotina     .
. padrão.                                                           .
. Uso......: 	Renova Energia                                      .
. Utilizado para filtrar os titulos da RJ conforme critérios        .
. definidos : classe + Prefixo + Fornecedor + dta de dta até.........
*///.................................................................

User Function F580FAUT()

Local oGetFor
Local cGetFor   := Space(6)
Local oGetPrefi
Local cGetPrefi := Space(3)
Local oGetDtDe
Local dGetDtDe  := Date()
Local oGetDtAt
Local dGetDtAt  := Date()
Local oComboClas 
Local cComboClas  := "X" 
Local aClasses := {"1=Trabalhista","2=Garantia","3=Quirografários","4=Micro Empresa","5=Conversão de Crédito","6=Bancos","X=Filtro Padrão"}
Local oSayFor
Local oSayPrefi
Local oSayDtDe
Local oSayDtAt
Local oSayClass
Local cFiltro:=""
Local  oButton1
Static oDlg


If !empty (cComboClas) 

  DEFINE MSDIALOG oDlg TITLE "Filtro para Liberação" FROM 000, 000  TO 350, 250 COLORS 0, 16777215 PIXEL

    @ 012, 020 SAY   oSayFor PROMPT "Informe um Fornecedor" SIZE 080, 010 OF oDlg COLORS 0, 16777215 PIXEL
    @ 023, 020 MSGET oGetFor VAR cGetFor SIZE 085, 010 OF oDlg COLORS 0, 16777215 F3 "SA2" PIXEL
    @ 064, 020 SAY   oSayPrefi PROMPT "Informe um Prefixo" SIZE 080, 010 OF oDlg COLORS 0, 16777215 PIXEL
    @ 076, 020 MSGET oGetPrefi VAR cGetPrefi SIZE 085, 010 OF oDlg COLORS 0, 16777215 PIXEL
    @ 094, 020 SAY   oSayDtDe PROMPT "Informe a Data de:" SIZE 080, 010 OF oDlg COLORS 0, 16777215 PIXEL
    @ 105, 020 MSGET oGetDtDe VAR dGetDtDe SIZE 085, 010 OF oDlg COLORS 0, 16777215 PIXEL
    @ 120, 020 SAY   oSayDtAt PROMPT "Informe a Data ate:" SIZE 080, 010 OF oDlg COLORS 0, 16777215 PIXEL
    @ 131, 020 MSGET oGetDtAt VAR dGetDtAt SIZE 085, 010 OF oDlg COLORS 0, 16777215 PIXEL
    @ 037, 020 SAY   oSayClass PROMPT "Informe uma classe" SIZE 080, 010 OF oDlg COLORS 0, 16777215 PIXEL
    @ 048, 020 MSCOMBOBOX oComboClas VAR cComboClas ITEMS aClasses SIZE 080, 010 OF oDlg COLORS 0, 16777215 PIXEL
    oButton1:= TButton():New(152,020, "Confirmar",oDlg,{||oDlg:End()}, 80,010,,,.F.,.T.,.F.,,.F.,,,.F. )

  ACTIVATE MSDIALOG oDlg CENTERED
            //Retorno conforme seleçao
        Do Case

            Case SubStr(cComboClas ,1,1) == "X"
            cFiltro += "(E2_DATALIB='"+dtos(ctod(""))+"')"

            Case SubStr(cComboClas ,1,1) <> "X" .AND.  !empty(cGetPrefi) .AND. !empty(cGetFor)// classe + Prefixo + Fornecedor
                cFiltro += "E2_XCLASS = '" + SubStr(cComboClas ,1,1) + "'"  
                cFiltro += "AND E2_PREFIXO = '" + ALLTRIM(cGetPrefi) + "'"  
                cFiltro += "AND (E2_DATALIB='"+dtos(ctod(""))+"')"
                cFiltro += "AND E2_FORNECE = '" + cGetFor + "'"
                cFiltro += "AND E2_VENCREA >='"+DTOS(dGetDtDe)+"'"
                cFiltro += "AND E2_VENCREA <='"+Dtos(dGetDtAt)+"'"
                
            Case SubStr(cComboClas ,1,1) <> "X" .AND.  !empty(cGetPrefi) .AND. empty(cGetFor)// classe + Prefixo 
                cFiltro += "E2_XCLASS = '" + SubStr(cComboClas ,1,1) + "'"  
                cFiltro += "AND E2_PREFIXO = '" + ALLTRIM(cGetPrefi) + "'"  
                cFiltro += "AND (E2_DATALIB='"+dtos(ctod(""))+"')"
                //cFiltro += "AND E2_FORNECE = '" + cGetFor + "'"
                cFiltro += "AND E2_VENCREA >='"+DTOS(dGetDtDe)+"'"
                cFiltro += "AND E2_VENCREA <='"+Dtos(dGetDtAt)+"'"

            Case  SubStr(cComboClas ,1,1) <> "X" .AND.  empty(cGetPrefi) .AND. !empty(cGetFor)// Classe + Qq Prefixo + Fornecedor
                cFiltro += "E2_XCLASS = '" + SubStr(cComboClas ,1,1) + "'"  
                //cFiltro += "AND E2_PREFIXO = '" + cGetPrefi + "'"  
                cFiltro += "AND (E2_DATALIB='"+dtos(ctod(""))+"')"
                cFiltro += "AND E2_FORNECE = '" + cGetFor + "'"
                cFiltro += "AND E2_VENCREA >='"+DTOS(dGetDtDe)+"'"
                cFiltro += "AND E2_VENCREA <='"+Dtos(dGetDtAt)+"'"

            Case SubStr(cComboClas ,1,1) <> "X" .AND.  empty(cGetPrefi) .AND. empty(cGetFor) // Classe + Qq Prefixo Prefixo + Todos os fornecedores
                cFiltro += "E2_XCLASS = '" + SubStr(cComboClas ,1,1) + "'"  
                //cFiltro += "AND E2_PREFIXO = '" + cGetPrefi + "'"  
                cFiltro += "AND (E2_DATALIB='"+dtos(ctod(""))+"')"
                //cFiltro += "AND E2_FORNECE = '" + cGetFor + "'"
                cFiltro += "AND E2_VENCREA >='"+DTOS(dGetDtDe)+"'"
                cFiltro += "AND E2_VENCREA <='"+Dtos(dGetDtAt)+"'"
              
        OtherWise
            cFiltro += "(E2_DATALIB='"+dtos(ctod(""))+"')"
            EndCase   
Endif

Return cFiltro
