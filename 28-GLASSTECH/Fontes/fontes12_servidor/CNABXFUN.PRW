#include "RWMAKE.CH"
#Include "PROTHEUS.Ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CNABREGN ºAutor  ³Ronald -  Oficina1   º Data ³  13/08/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Monta complemento de detalhamento dos dados de tributo no   º±±
±±º          ³registro N do Cnab a pagar                                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³CPS Color                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CNABREGN()

Local cReturn := ""

If SEA->EA_MODELO $ "16" //16-PAGAMENTO DE TRIBUTOS - DARF NORMAL - SEGMENTO N2
                     
   cPerApu := DTOS(SE2->E2_XPERAPU)
   cDtVenc := DTOS(SE2->E2_VENCTO)

   cReturn := STRZERO(VAL(SE2->E2_XCODREC),6) //Código da Receita do Tributo - Embora o campo seja alfanumérico, informar o código da receita alinhado à direita e completando com zeros à esquerda. Deve ser obtido nas agências da Secretaria da Receita Federal ou através do site no endereço: http://www.receita.fazenda.gov.br.
   cReturn += "01"                            //Tipo de Identificação do Contribuinte - 1 = CNPJ, 2 = CPF, 3 = NIT/PIS/PASEP, 4 = CEI, 6 = NB, 7 = n°. do título, 8 = DEBCAD, 9 = referência.
   cReturn += SM0->M0_CGC                     //Identificação do Contribuinte
   cReturn += "16"                            //Código de Identificação do Tributo	- 16' Tributo DARF Normal.
   cReturn += SUBSTR(cPerApu,7,2)+SUBSTR(cPerApu,5,2)+SUBSTR(cPerApu,1,4) //Período de Apuração	- DDMMAAAA, DD para dia, MM para mês e AAAA para ano.
   cReturn += PADR(SE2->E2_XREFDAR,17)        //Número de Referência
   cReturn += STRZERO(((SE2->E2_SALDO+SE2->E2_ACRESC-SE2->E2_DECRESC-SE2->E2_MULTA-SE2->E2_JUROS)*100),15) //Valor Principal	160	174	13	2	Numérico		G042	
   cReturn += STRZERO(SE2->E2_MULTA,15) //Valor da Multa	175	189	13	2	Numérico		G048	
   cReturn += STRZERO(SE2->E2_JUROS,15) //Valor dos Juros / Encargos	190	204	13	2	Numérico		G047	
   cReturn += SUBSTR(cDtVenc,7,2)+SUBSTR(cDtVenc,5,2)+SUBSTR(cDtVenc,1,4) //Data do Vencimento - DDMMAAAA, DD para dia, MM para mês e AAAA para ano. 
   cReturn += SPACE(18)    //Uso Exclusivo FEBRABAN/CNAB - Na remessa, informar 'brancos' (espaços).

ElseIf SEA->EA_MODELO $ "17" //17-PAGAMENTO DE TRIBUTOS - GPS  - SEGMENTO N1

   cCodRec := IIF(EMPTY(SE2->E2_XCODREC),"002100",SE2->E2_XCODREC)
          
   cReturn := STRZERO(VAL(cCodRec),6)   //Codigo da Receita do Tributo 
   cReturn += "01"        //Tipo de Identificação do Contribuinte - 1 = CNPJ, 2 = CPF, 3 = NIT/PIS/PASEP, 4 = CEI, 6 = NB, 7 = n°. do título, 8 = DEBCAD, 9 = referência.
   cReturn += SM0->M0_CGC //Identificação do Contribuinte                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
   cReturn += "17"        //Código de Identificação do Tributo - 17' = Tributo GPS (Guia Previdência Social)                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
   cReturn += SE2->E2_XMESREF //Mês e ano de competência = MMAAAA, MM para mês e AAAA para ano. 
   cReturn += STRZERO(((SE2->E2_SALDO+SE2->E2_ACRESC-SE2->E2_DECRESC-SE2->E2_MULTA-SE2->E2_JUROS)*100),15) //Valor Previsto do pagamento do INSS - É vedada a utilização da GPS para recolhimento de Receita de valor total inferior ao estipulado pela Resolução INSS/PR vigente.
   cReturn += STRZERO(SE2->E2_MULTA*100,15) //Valor de Outras Entidades
   cReturn += STRZERO(SE2->E2_JUROS*100,15) //Atualização Monetária
   cReturn += SPACE(45)     //Uso Exclusivo FEBRABAN/CNAB - Na remessa, informar 'brancos' (espaços).

ElseIf SEA->EA_MODELO $ "18" //18-PAGAMENTO DE TRIBUTOS - DARF SIMPLES   - SEGMENTO N3

   cPerApu := DTOS(SE2->E2_XPERAPU)
   cDtVenc := DTOS(SE2->E2_VENCTO)

   cReturn := "6106  "						   //Código da Receita do Tributo - Embora o campo seja alfanumérico, informar o código da receita alinhado à direita e completando com zeros à esquerda. Deve ser obtido nas agências da Secretaria da Receita Federal ou através do site no endereço: http://www.receita.fazenda.gov.br.
   cReturn += "01"                            //Tipo de Identificação do Contribuinte - 1 = CNPJ, 2 = CPF, 3 = NIT/PIS/PASEP, 4 = CEI, 6 = NB, 7 = n°. do título, 8 = DEBCAD, 9 = referência.
   cReturn += SM0->M0_CGC                     //Identificação do Contribuinte
   cReturn += "18"                            //Código de Identificação do Tributo	- 16' Tributo DARF Normal.
   cReturn += SUBSTR(cPerApu,7,2)+SUBSTR(cPerApu,5,2)+SUBSTR(cPerApu,1,4) //Período de Apuração	- DDMMAAAA, DD para dia, MM para mês e AAAA para ano.
   cReturn += PADR(SE2->E2_XREFDAR,17)        //Número de Referência
   cReturn += STRZERO(((SE2->E2_SALDO+SE2->E2_ACRESC-SE2->E2_DECRESC-SE2->E2_MULTA-SE2->E2_JUROS)*100),15) //Valor Principal	160	174	13	2	Numérico		G042	
   cReturn += STRZERO(SE2->E2_MULTA,15) //Valor da Multa	175	189	13	2	Numérico		G048	
   cReturn += STRZERO(SE2->E2_JUROS,15) //Valor dos Juros / Encargos	190	204	13	2	Numérico		G047	
   cReturn += SUBSTR(cDtVenc,7,2)+SUBSTR(cDtVenc,5,2)+SUBSTR(cDtVenc,1,4) //Data do Vencimento - DDMMAAAA, DD para dia, MM para mês e AAAA para ano. 
   cReturn += SPACE(18)    //Uso Exclusivo FEBRABAN/CNAB - Na remessa, informar 'brancos' (espaços).

      
ElseIf SEA->EA_MODELO $ "22/23/24" //17-PAGAMENTO DE TRIBUTOS - GARE ICMS SP - SEGMENTO N4

   cCodRec := IIF(EMPTY(SE2->E2_XCODREC),"000462",SE2->E2_XCODREC)
   cDtVenc := DTOS(SE2->E2_VENCTO)
      
   cReturn := STRZERO(VAL(cCodRec),6)   //Codigo da Receita do Tributo 
   cReturn += "01"        //Tipo de Identificação do Contribuinte - 1 = CNPJ, 2 = CPF, 3 = NIT/PIS/PASEP, 4 = CEI, 6 = NB, 7 = n°. do título, 8 = DEBCAD, 9 = referência.
   cReturn += SM0->M0_CGC //Identificação do Contribuinte                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
   cReturn += SEA->EA_MODELO//Código de Identificação do Tributo - 22’ = Tributo - GARE-SP ICMS   
   cReturn += SUBSTR(cDtVenc,7,2)+SUBSTR(cDtVenc,5,2)+SUBSTR(cDtVenc,1,4) //Data do Vencimento - DDMMAAAA, DD para dia, MM para mês e AAAA para ano. 
   cReturn += PADR(SM0->M0_INSC,12) //12, Inscricao Estadual
   cReturn += SPACE(13)   //Divida Ativa / N.Etiqueta
   cReturn += SE2->E2_XMESREF //Periodo de Referencia = MMAAAA, MM para mês e AAAA para ano. 
   cReturn += SPACE(13)   //Numero da Parcela / Notificacao
   cReturn += STRZERO(((SE2->E2_SALDO+SE2->E2_ACRESC-SE2->E2_DECRESC-SE2->E2_MULTA-SE2->E2_JUROS)*100),15) //Valor da Receita
   cReturn += STRZERO(SE2->E2_MULTA*100,14) //Valor dos Juros
   cReturn += STRZERO(SE2->E2_JUROS*100,14) //valor da Multa
   cReturn += SPACE(1)    //Uso Exclusivo FEBRABAN/CNAB

ElseIf SEA->EA_MODELO $ "01" //01-PAGAMENTO DE TRIBUTOS - FGTS- SEGMENTO W4

   cCodRec := IIF(EMPTY(SE2->E2_XCODREC),"000462",SE2->E2_XCODREC)
   cDtVenc := DTOS(SE2->E2_VENCTO)
      
   cReturn := STRZERO(VAL(cCodRec),6)   //Codigo da Receita do Tributo 
   cReturn += "01"        //Tipo de Identificação do Contribuinte - 1 = CNPJ, 2 = CPF, 3 = NIT/PIS/PASEP, 4 = CEI, 6 = NB, 7 = n°. do título, 8 = DEBCAD, 9 = referência.
   cReturn += SM0->M0_CGC //Identificação do Contribuinte                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
   cReturn += SEA->EA_MODELO//Código de Identificação do Tributo - 01’ = Tributo - FGTS   
   cReturn += SPACE(1)    //Uso Exclusivo FEBRABAN/CNAB

EndIf                         

Return(cReturn)