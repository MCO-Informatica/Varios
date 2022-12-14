#include "RWMAKE.CH"
#Include "PROTHEUS.Ch"

/*
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????ͻ??
???Programa  ?CNABREGN ?Autor  ?Ronald -  Oficina1   ? Data ?  13/08/19   ???
?????????????????????????????????????????????????????????????????????????͹??
???Desc.     ?Monta complemento de detalhamento dos dados de tributo no   ???
???          ?registro N do Cnab a pagar                                  ???
???          ?                                                            ???
?????????????????????????????????????????????????????????????????????????͹??
???Uso       ?CPS Color                                                   ???
?????????????????????????????????????????????????????????????????????????ͼ??
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
*/

User Function CNABREGN()

Local cReturn := ""

If SEA->EA_MODELO $ "16" //16-PAGAMENTO DE TRIBUTOS - DARF NORMAL - SEGMENTO N2
                     
   cPerApu := DTOS(SE2->E2_XPERAPU)
   cDtVenc := DTOS(SE2->E2_VENCTO)

   cReturn := STRZERO(VAL(SE2->E2_XCODREC),6) //C?digo da Receita do Tributo - Embora o campo seja alfanum?rico, informar o c?digo da receita alinhado ? direita e completando com zeros ? esquerda. Deve ser obtido nas ag?ncias da Secretaria da Receita Federal ou atrav?s do site no endere?o: http://www.receita.fazenda.gov.br.
   cReturn += "01"                            //Tipo de Identifica??o do Contribuinte - 1 = CNPJ, 2 = CPF, 3 = NIT/PIS/PASEP, 4 = CEI, 6 = NB, 7 = n?. do t?tulo, 8 = DEBCAD, 9 = refer?ncia.
   cReturn += SM0->M0_CGC                     //Identifica??o do Contribuinte
   cReturn += "16"                            //C?digo de Identifica??o do Tributo	- 16' Tributo DARF Normal.
   cReturn += SUBSTR(cPerApu,7,2)+SUBSTR(cPerApu,5,2)+SUBSTR(cPerApu,1,4) //Per?odo de Apura??o	- DDMMAAAA, DD para dia, MM para m?s e AAAA para ano.
   cReturn += PADR(SE2->E2_XREFDAR,17)        //N?mero de Refer?ncia
   cReturn += STRZERO(((SE2->E2_SALDO+SE2->E2_ACRESC-SE2->E2_DECRESC-SE2->E2_MULTA-SE2->E2_JUROS)*100),15) //Valor Principal	160	174	13	2	Num?rico		G042	
   cReturn += STRZERO(SE2->E2_MULTA,15) //Valor da Multa	175	189	13	2	Num?rico		G048	
   cReturn += STRZERO(SE2->E2_JUROS,15) //Valor dos Juros / Encargos	190	204	13	2	Num?rico		G047	
   cReturn += SUBSTR(cDtVenc,7,2)+SUBSTR(cDtVenc,5,2)+SUBSTR(cDtVenc,1,4) //Data do Vencimento - DDMMAAAA, DD para dia, MM para m?s e AAAA para ano. 
   cReturn += SPACE(18)    //Uso Exclusivo FEBRABAN/CNAB - Na remessa, informar 'brancos' (espa?os).

ElseIf SEA->EA_MODELO $ "17" //17-PAGAMENTO DE TRIBUTOS - GPS  - SEGMENTO N1

   cCodRec := IIF(EMPTY(SE2->E2_XCODREC),"002100",SE2->E2_XCODREC)
          
   cReturn := STRZERO(VAL(cCodRec),6)   //Codigo da Receita do Tributo 
   cReturn += "01"        //Tipo de Identifica??o do Contribuinte - 1 = CNPJ, 2 = CPF, 3 = NIT/PIS/PASEP, 4 = CEI, 6 = NB, 7 = n?. do t?tulo, 8 = DEBCAD, 9 = refer?ncia.
   cReturn += SM0->M0_CGC //Identifica??o do Contribuinte                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
   cReturn += "17"        //C?digo de Identifica??o do Tributo - 17' = Tributo GPS (Guia Previd?ncia Social)                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
   cReturn += SE2->E2_XMESREF //M?s e ano de compet?ncia = MMAAAA, MM para m?s e AAAA para ano. 
   cReturn += STRZERO(((SE2->E2_SALDO+SE2->E2_ACRESC-SE2->E2_DECRESC-SE2->E2_MULTA-SE2->E2_JUROS)*100),15) //Valor Previsto do pagamento do INSS - ? vedada a utiliza??o da GPS para recolhimento de Receita de valor total inferior ao estipulado pela Resolu??o INSS/PR vigente.
   cReturn += STRZERO(SE2->E2_MULTA*100,15) //Valor de Outras Entidades
   cReturn += STRZERO(SE2->E2_JUROS*100,15) //Atualiza??o Monet?ria
   cReturn += SPACE(45)     //Uso Exclusivo FEBRABAN/CNAB - Na remessa, informar 'brancos' (espa?os).

ElseIf SEA->EA_MODELO $ "18" //18-PAGAMENTO DE TRIBUTOS - DARF SIMPLES   - SEGMENTO N3

   cPerApu := DTOS(SE2->E2_XPERAPU)
   cDtVenc := DTOS(SE2->E2_VENCTO)

   cReturn := "6106  "						   //C?digo da Receita do Tributo - Embora o campo seja alfanum?rico, informar o c?digo da receita alinhado ? direita e completando com zeros ? esquerda. Deve ser obtido nas ag?ncias da Secretaria da Receita Federal ou atrav?s do site no endere?o: http://www.receita.fazenda.gov.br.
   cReturn += "01"                            //Tipo de Identifica??o do Contribuinte - 1 = CNPJ, 2 = CPF, 3 = NIT/PIS/PASEP, 4 = CEI, 6 = NB, 7 = n?. do t?tulo, 8 = DEBCAD, 9 = refer?ncia.
   cReturn += SM0->M0_CGC                     //Identifica??o do Contribuinte
   cReturn += "18"                            //C?digo de Identifica??o do Tributo	- 16' Tributo DARF Normal.
   cReturn += SUBSTR(cPerApu,7,2)+SUBSTR(cPerApu,5,2)+SUBSTR(cPerApu,1,4) //Per?odo de Apura??o	- DDMMAAAA, DD para dia, MM para m?s e AAAA para ano.
   cReturn += PADR(SE2->E2_XREFDAR,17)        //N?mero de Refer?ncia
   cReturn += STRZERO(((SE2->E2_SALDO+SE2->E2_ACRESC-SE2->E2_DECRESC-SE2->E2_MULTA-SE2->E2_JUROS)*100),15) //Valor Principal	160	174	13	2	Num?rico		G042	
   cReturn += STRZERO(SE2->E2_MULTA,15) //Valor da Multa	175	189	13	2	Num?rico		G048	
   cReturn += STRZERO(SE2->E2_JUROS,15) //Valor dos Juros / Encargos	190	204	13	2	Num?rico		G047	
   cReturn += SUBSTR(cDtVenc,7,2)+SUBSTR(cDtVenc,5,2)+SUBSTR(cDtVenc,1,4) //Data do Vencimento - DDMMAAAA, DD para dia, MM para m?s e AAAA para ano. 
   cReturn += SPACE(18)    //Uso Exclusivo FEBRABAN/CNAB - Na remessa, informar 'brancos' (espa?os).

      
ElseIf SEA->EA_MODELO $ "22/23/24" //17-PAGAMENTO DE TRIBUTOS - GARE ICMS SP - SEGMENTO N4

   cCodRec := IIF(EMPTY(SE2->E2_XCODREC),"000462",SE2->E2_XCODREC)
   cDtVenc := DTOS(SE2->E2_VENCTO)
      
   cReturn := STRZERO(VAL(cCodRec),6)   //Codigo da Receita do Tributo 
   cReturn += "01"        //Tipo de Identifica??o do Contribuinte - 1 = CNPJ, 2 = CPF, 3 = NIT/PIS/PASEP, 4 = CEI, 6 = NB, 7 = n?. do t?tulo, 8 = DEBCAD, 9 = refer?ncia.
   cReturn += SM0->M0_CGC //Identifica??o do Contribuinte                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
   cReturn += SEA->EA_MODELO//C?digo de Identifica??o do Tributo - 22? = Tributo - GARE-SP ICMS   
   cReturn += SUBSTR(cDtVenc,7,2)+SUBSTR(cDtVenc,5,2)+SUBSTR(cDtVenc,1,4) //Data do Vencimento - DDMMAAAA, DD para dia, MM para m?s e AAAA para ano. 
   cReturn += PADR(SM0->M0_INSC,12) //12, Inscricao Estadual
   cReturn += SPACE(13)   //Divida Ativa / N.Etiqueta
   cReturn += SE2->E2_XMESREF //Periodo de Referencia = MMAAAA, MM para m?s e AAAA para ano. 
   cReturn += SPACE(13)   //Numero da Parcela / Notificacao
   cReturn += STRZERO(((SE2->E2_SALDO+SE2->E2_ACRESC-SE2->E2_DECRESC-SE2->E2_MULTA-SE2->E2_JUROS)*100),15) //Valor da Receita
   cReturn += STRZERO(SE2->E2_MULTA*100,14) //Valor dos Juros
   cReturn += STRZERO(SE2->E2_JUROS*100,14) //valor da Multa
   cReturn += SPACE(1)    //Uso Exclusivo FEBRABAN/CNAB

ElseIf SEA->EA_MODELO $ "01" //01-PAGAMENTO DE TRIBUTOS - FGTS- SEGMENTO W4

   cCodRec := IIF(EMPTY(SE2->E2_XCODREC),"000462",SE2->E2_XCODREC)
   cDtVenc := DTOS(SE2->E2_VENCTO)
      
   cReturn := STRZERO(VAL(cCodRec),6)   //Codigo da Receita do Tributo 
   cReturn += "01"        //Tipo de Identifica??o do Contribuinte - 1 = CNPJ, 2 = CPF, 3 = NIT/PIS/PASEP, 4 = CEI, 6 = NB, 7 = n?. do t?tulo, 8 = DEBCAD, 9 = refer?ncia.
   cReturn += SM0->M0_CGC //Identifica??o do Contribuinte                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
   cReturn += SEA->EA_MODELO//C?digo de Identifica??o do Tributo - 01? = Tributo - FGTS   
   cReturn += SPACE(1)    //Uso Exclusivo FEBRABAN/CNAB

EndIf                         

Return(cReturn)