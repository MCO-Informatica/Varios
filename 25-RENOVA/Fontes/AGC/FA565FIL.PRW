#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWBROWSE.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"
#Include "Rwmake.ch"

/*/{Protheus.doc} FA565FIL
Ponto de entrada para somar uma condição adicional ao filtro padrão
@author Alcouto
@since 15-01-2021

Alterado em 05/03/2021 por Luiz para utilizar a "Natureza Para" e não a Natureza Original do título para seleção
Alterado ------------- por Luiz para atender rotina RFINA002
Alterado ------------- por Luiz para atender rotina RFINA003
Alterado EM 27/04/2021 por Luiz para atender rotina RFINA003 - versão com De-Para de Fornecedor
Alterado em 01/06/2021 por Luiz para atender rotina RFINA004
/*/

User Function FA565FIL() 

Local  cQuery := ""
Local  oComboClas 
Local  cComboClas  := "X"
Local  oComboNat
Local  cComboNat := space(10)
Local  cArqFil := ""
Local  aClasses := {"1=Trabalhista","2=Garantia","3=Quirografários","4=Micro Empresa","5=Emprestimos Classe III","X=Filtro Padrão"}
Local  aNaturezas := {}   //F565FSEL(cArqFil)
LOcal  oSay1
LOcal  oSay2
Local  oButton1
Static oDlg

Public cRJ := ""
Public cTpClasse := "3"

// cRotFina indica qual rotina automática está usando esse PE 
// 002 = RFINA002 (Liquidação) / 003 = RFINA003 (Reliquidação Saldo)  / 004 = RFINA004 (Fase 4)
// Nesse caso, a varíavel pública cOpc também estará disponível
// 
if type("cRotFina") = "C"       // Existindo essa variável = execução automática
   
   if cRotFina = "002"          // RFINA002
      do case 
         case cOpc = "O"
              cQuery += " AND E2_XCLASS = '3' AND E2_XRJ = 'S' "  
              cQuery += "AND (SELECT ED_XCDPARA FROM SED000 WHERE SED000.D_E_L_E_T_ <> '*' "
              cQuery += "AND ED_CODIGO = E2_NATUREZ) = '" + cNatAuto + "' "
              cQuery += "AND NOT (E2_PREFIXO IN "+FormatIn("ARR","|")+") "
              cQuery += "AND NOT (E2_NATUREZ IN "+FormatIn("2217|2203|2215|2335","|")+") "
              cQuery += "AND E2_TIPO <> 'PA' AND E2_TIPO <> 'NDF' "               // Ignora PA e NDF
              cQuery += "AND NOT (E2_FORNECE IN "+FormatIn("UNIAO","|")+") "      // Ignora fornecedor "UNIAO"
         case cOpc = "A"
              cQuery += " AND E2_XCLASS = '3' AND E2_XRJ = 'S' "  
              cQuery += "AND (SELECT ED_XCDPARA FROM SED000 WHERE SED000.D_E_L_E_T_ <> '*' "
              cQuery += "AND ED_CODIGO = E2_NATUREZ) = '" + cNatAuto + "' "
              cQuery += "AND NOT (E2_NATUREZ IN "+FormatIn("2217|2203|2215|2335","|")+") "      
              cQuery += "AND (E2_PREFIXO IN "+FormatIn("ARR","|")+") "
              cQuery += "AND E2_TIPO <> 'PA' AND E2_TIPO <> 'NDF' "               // Ignora PA E NDF
              cQuery += "AND NOT (E2_FORNECE IN "+FormatIn("UNIAO","|")+") "      // Ignora fornecedor "UNIAO"        
         case cOpc = "T"
              cQuery += " AND E2_XCLASS = '3' AND E2_XRJ = 'S' "  
              cQuery += "AND (SELECT ED_XCDPARA FROM SED000 WHERE SED000.D_E_L_E_T_ <> '*' "
              cQuery += "AND ED_CODIGO = E2_NATUREZ) = '" + cNatAuto + "' "
              cQuery += "AND (E2_NATUREZ IN "+FormatIn("2217|2203|2215|2335","|")+") "
              cQuery += "AND NOT (E2_PREFIXO IN "+FormatIn("ARR","|")+") "
              cQuery += "AND E2_TIPO <> 'PA' AND E2_TIPO <> 'NDF' "               // Ignora PA e NDF
              cQuery += "AND NOT (E2_FORNECE IN "+FormatIn("UNIAO","|")+") "      // Ignora fornecedor "UNIAO"        
      endcase
      
   elseif cRotFina = "003"       // RFINA003
      cQuery += " AND E2_XCLASS = '3' AND E2_XRJ = 'S' "                   // Com Classificação e Flag válidas
      cQuery += "AND E2_TIPO <> 'PA' AND E2_TIPO <> 'NDF' "                // Ignora PA e NDF
      cQuery += "AND NOT (E2_FORNECE IN "+FormatIn("UNIAO","|")+") "       // Ignora fornecedor "UNIAO"
      cQuery += "AND E2_PREFIXO = 'PRJ' "                                  // Somente títulos com prefixo "PRJ"
      cQuery += "AND E2_NUM LIKE '______002' "                             // Somente parcela saldo
      if cOpc = "E"
         cQuery += " AND E2_XESSENC = 'S' "                                // Se Credor Essencial
      else
         cQuery += " AND E2_XESSENC <> 'S' "                               // Se Não Essencial
      endif
      cQuery += "AND E2_NATUREZ = '"+cNatAuto+"' "                         // Natureza do registro atual sendo liquidado
   
      // Fornecedor destino título igual fornecedor do registro do TRB003 em execução - implementado em 27/04/2021
      cQuery += "AND (SELECT A2_XFORDES FROM SA2000 WHERE A2_COD = E2_FORNECE AND A2_LOJA = E2_LOJA AND SA2000.D_E_L_E_T_ = '') = '"+TRB003->A2_XFORDES+"' "
      cQuery += "AND (SELECT A2_XLOJDES FROM SA2000 WHERE A2_COD = E2_FORNECE AND A2_LOJA = E2_LOJA AND SA2000.D_E_L_E_T_ = '') = '"+TRB003->A2_XLOJDES+"' "


//   ATENÇÃO: 01/06/2021 - Até o momento, as regras permanecem as mesmas do "003" exceto pelo final do E2_NUM
//                         Financeiro ainda não se pronunciou sobre eventual alteração
//
   elseif cRotFina = "004"       // RFINA004 
      cQuery += " AND E2_XCLASS = '3' AND E2_XRJ = 'S' "                   // Com Classificação e Flag válidas
      cQuery += "AND E2_TIPO <> 'PA' AND E2_TIPO <> 'NDF' "                // Ignora PA e NDF
      cQuery += "AND NOT (E2_FORNECE IN "+FormatIn("UNIAO","|")+") "       // Ignora fornecedor "UNIAO"
      cQuery += "AND E2_PREFIXO = 'PRJ' "                                  // Somente títulos com prefixo "PRJ"
      cQuery += "AND E2_NUM LIKE '______004' "                             // Somente parcela saldo
      if cOpc = "E"
         cQuery += " AND E2_XESSENC = 'S' "                                // Se Credor Essencial
      else
         cQuery += " AND E2_XESSENC <> 'S' "                               // Se Não Essencial
      endif
      cQuery += "AND E2_NATUREZ = '"+cNatAuto+"' "                         // Natureza do registro atual sendo liquidado
   
      // Fornecedor destino título igual fornecedor do registro do TRB004 em execução
      cQuery += "AND (SELECT A2_XFORDES FROM SA2000 WHERE A2_COD = E2_FORNECE AND A2_LOJA = E2_LOJA AND SA2000.D_E_L_E_T_ = '') = '"+TRB004->A2_XFORDES+"' "
      cQuery += "AND (SELECT A2_XLOJDES FROM SA2000 WHERE A2_COD = E2_FORNECE AND A2_LOJA = E2_LOJA AND SA2000.D_E_L_E_T_ = '') = '"+TRB004->A2_XLOJDES+"' "

   endif
  
   Return(cQuery)

endif

// Se chamada a partir do FINA565 executa a partir desse ponto

aNaturezas := F565FSEL(cArqFil)

if Empty(aNaturezas) 
   Alert("Atenção: Não existem títulos para o Filtro utilizado!")
   Return(cQuery)
endif

//Aadd(aNaturezas, "Todos")   

If !empty (cComboClas) 

    DEFINE MSDIALOG oDlg TITLE "Adicionar Filtro aos Titulos" FROM 000, 000  TO 250, 220 COLORS 0, 16777215 PIXEL

        @ 015, 022 SAY oSay1 PROMPT "Escolha uma Classificação" SIZE 069, 011 OF oDlg COLORS 0, 16777215 PIXEL
        @ 030, 022 MSCOMBOBOX oComboClas VAR cComboClas ITEMS aClasses SIZE 067, 010 OF oDlg COLORS 0, 16777215 PIXEL
        @ 045, 022 SAY oSay2 PROMPT "Escolha a Natureza" SIZE 070, 010 OF oDlg COLORS 0, 16777215 PIXEL
        @ 060, 022 MSCOMBOBOX oComboNat VAR cComboNat ITEMS aNaturezas SIZE 067, 010 OF oDlg COLORS 0, 16777215 PIXEL
        oButton1:= TButton():New(090,030, "OK",oDlg,{||oDlg:End()}, 40,10,,,.F.,.T.,.F.,,.F.,,,.F. )
    
    ACTIVATE MSDIALOG oDlg CENTERED

    //Retorno conforme seleçao
    Do Case
        Case SubStr(cComboClas ,1,1) <> "X" .AND.  cComboNat <> "Todos" // classe + natureza
            cQuery += "AND E2_XCLASS = '" + SubStr(cComboClas ,1,1) + "'"  
//          cQuery += "AND E2_NATUREZ = '" + cComboNat + "'"            // Alterado em 05/03/2021 - Luiz
            cQuery += " AND (SELECT ED_XCDPARA FROM SED000 WHERE SED000.D_E_L_E_T_ <> '*'"
            cQuery += " AND ED_CODIGO = E2_NATUREZ) = '" + cComboNat + "' "
//          cQuery += " AND E2_NUMBOR = '' "   // Ignora títulos em Bordero - Incluido em 09/03/2021 - Luiz - retirado em 18/03/2021
        Case  SubStr(cComboClas ,1,1) <> "X" .AND.  cComboNat = "Todos"  // Classe
            cQuery += "AND E2_XCLASS = '" + SubStr(cComboClas ,1,1) + "'"  
//          cQuery += " AND E2_NUMBOR = '' "   // Ignora títulos em Bordero - Incluido em 09/03/2021 - Luiz - retirado em 18/03/2021
        Case  SubStr(cComboClas ,1,1) = "X" .AND.  cComboNat <> "Todos" // Natureza  
//          cQuery += "AND E2_NATUREZ = '" + cComboNat + "'"            // Alterado em 05/03/2021 - Luiz 
            cQuery += " AND (SELECT ED_XCDPARA FROM SED000 WHERE SED000.D_E_L_E_T_ <> '*'"
            cQuery += " AND ED_CODIGO = E2_NATUREZ) = '" + cComboNat + "' "
//          cQuery += " AND E2_NUMBOR = '' "   // Ignora títulos em Bordero - Incluido em 09/03/2021 - Luiz - retirado em 18/03/2021
        OtherWise
            MsgInfo('Foi mantido o filtro padrão')
            cQuery += ""
     EndCase
Endif

cNatureza := cComboNat
if SubStr(cComboClas ,1,1) = "X"
   Public cTpClasse := " "
else
   Public cTpClasse := SubStr(cComboClas ,1,1) 
endif

RETURN cQuery


//====
Static Function F565FSEL(cArqFil)

Local cQuery		:= ""
Local cAliasNAT		:= ""
Local cTmpSe2Fil	:= ""
Local aTam			:= TamSX3("E2_VALOR")
Local aRet          := {}

Default cArqFil		:= ""

//cQuery := "select distinct E2_NATUREZ from " + RetSQLName("SE2")            // Alterado em 05/03/2021 - Luiz
cQuery := "select distinct ED_XCDPARA from " + RetSQLName("SE2")              // Alterado em 05/03/2021 - Luiz 
cQuery += " inner join " + RetSQLName("SED") + " on E2_NATUREZ = ED_CODIGO"   // Alterado em 05/03/2021 - Luiz
If !Empty(aSelFil)
	cQuery += " where " + "E2_FILIAL " + GetRngFil( aSelFil, "SE2", .T., @cTmpSE2Fil)
	cArqFil := cTmpSE2Fil
Else
	cQuery += " where E2_FILIAL = '" + xFilial("SE2") + "'"  
Endif
cQuery += " and E2_FORNECE >= '" + cFornDe + "'"
cQuery += " and E2_FORNECE <= '" + cFornAte + "'"
cQuery += " and E2_LOJA >= '" + cLojaDe + "'"
cQuery += " and E2_LOJA <= '" + cLojaAte + "'"
cQuery += " and E2_PREFIXO >= '" + cPrefDe + "'"
cQuery += " and E2_PREFIXO <= '" + cPrefAte + "'"
cQuery += " and E2_NUM >= '" + cNumDe + "'"
cQuery += " and E2_NUM <= '" + cNumAte + "'"

If nIntervalo == 1
	cQuery += " and E2_EMIS1 >= '" + DTOS(dData565I) + "'"
	cQuery += " and E2_EMIS1 <= '" + DTOS(dData565F) + "'"
Else
	cQuery += " and E2_VENCTO >= '" + DTOS(dData565I) + "'"
	cQuery += " and E2_VENCTO <= '" + DTOS(dData565F) + "'"
EndIf
	
If nChoice == 2 //Nao converte outras moedas
	cQuery += " and E2_MOEDA = " + AllTrim(Str(nMoeda)) 
Endif
	
// AAF - Titulos originados no SIGAEFF não devem ser alterados
cQuery += " and E2_ORIGEM <> 'SIGAEFF'"
	
cQuery += " and E2_SALDO > 0"
cQuery += " and E2_VALOR >= " + AllTrim(Str(nValorDe,aTam[1]+aTam[2]+1,aTam[2]))
cQuery += " and E2_VALOR <= " + AllTrim(Str(nValorAte,aTam[1]+aTam[2]+1,aTam[2]))
	
cQuery += " and not (E2_TIPO in " + FormatIn(MVABATIM,"|") + ")"   // '!(E2_TIPO$MVABATIM).And.'
	
If !lReliquida 	//Liquida titulos nÆo liquidados anteriormente
	cQuery += " and E2_NUMLIQ = '" + Space(TamSX3("E2_NUMLIQ")[1]) + "'"
ElseIf lReliquida		// Reliquida‡ao
	cQuery  += " and E2_NUMLIQ <> '" + Space(TamSX3("E2_NUMLIQ")[1]) + "'"
Endif
	
cQuery += " and not (E2_TIPO in " + FormatIn(MVPROVIS + "|" + MVPAGANT + "|" + MV_CPNEG,"|") + ")"   		//'!(E2_TIPO$"'+MVPROVIS+"/"+MVPAGANT+"/"+MV_CPNEG+'")'
	
// cQuery += " AND E2_NUMBOR = '' "    // Ignora títulos em Bordero - Incluido em 09/03/2021 - Luiz - Retirado em 18/03/2021

//cQuery += " and D_E_L_E_T_ = ' ' order by E2_NATUREZ"                 // Alterado em 05/03/2021 - Luiz
cQuery += " and SE2000.D_E_L_E_T_ <> '*' and SED000.D_E_L_E_T_ <> '*'"  // Alterado em 05/03/2021 - Luiz
cQuery += " order by ED_XCDPARA"                                        // Alterado em 05/03/2021 - Luiz

/*-*/
cAliasNAT := GetNextAlias()
cQuery := ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),cAliasNAT,.F.,.T.)

DbSelectArea(cAliasNAT)
DbGotop()

If (cAliasNAT)->(Eof())
    aRet := {}
else
    while !EOF()
//      Aadd(aRet, (cAliasNAT)->E2_NATUREZ)             // Alterado em 05/03/2021 - Luiz
        Aadd(aRet, (cAliasNAT)->ED_XCDPARA)             // Alterado em 05/03/2021 - Luiz
        DbSkip()
    enddo
Endif

Return(aRet)
