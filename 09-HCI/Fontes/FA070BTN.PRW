#INCLUDE "PROTHEUS.CH"
#INCLUDE "JPEG.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MA030ROT  ºAutor  ³ROBSON BUENO        º Data ³  13/02/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de Entrada na Ordem de Compra (PC) para agregar       º±±
±±º          ³observacoes especificas do negocio HCI (VIA CONTRATO)       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function FA070BTN()             
//	AADD(aButtons, {"G.Ctas.Pag", {|| FA070BT1(.T.)}, "G.Ctas.Pag."}) //"Recálculo dos Impostos"  
//	{{"G.Ctas Pag"	,"U_FA070BT1()" , 0 , 3}}
//{"G. Etiqueta"	,"U_MT140RT1()" , 0 , 6}

Return({{"SIMULACA",{|| U_FA070BT1()},"G.CtPag"}})




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MA120B01  ºAutor  ³Robson Bueno        º Data ³  13/02/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Amarrar Observacao na OC                                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function FA070BT1()
Local lVerOk:=.t.
Local cCnpj
Local cFornece
Local cLojaf

if SE1->E1_TIPO="RA " .or. SE1->E1_TIPO="NCC" .or. SE1->E1_TIPO="NF"
ELSE
  Aviso("Processo Interrompido","Somente podera ser gerado Contas a Pagar a Partir de Titulos tipo [RA/NCC/NF]",{"&Ok"},,"Inconsistencia") 
  lVerOk:=.f.

ENDIF

IF lVerOk=.t. 
  //Fase1 Verificar se existe o cliente como fornecedor
  DbSelectArea("SA1")
  SA1->(DbSetOrder(1))
  if SA1->(DbSeek(xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA))
    cCnpj:= sa1->a1_cgc
  endif
  //Fase2 Incluir Cadastro de Fornecedores
  DbSelectArea("SA2")
  SA2->(DbSetOrder(3))
  if SA2->(DbSeek(xFilial("SA2")+cCnpj))
    cFornece:=SA2->A2_COD
    cLojaf:=SA2->A2_LOJA
  ELSE
    RecLock("SA2",.T.)
    SA2->A2_COD		:="C"+SUBSTRING(SA1->A1_COD,2,5)
    SA2->A2_LOJA	:=SA1->A1_LOJA
    SA2->A2_NOME	:=SA1->A1_NOME
    SA2->A2_NREDUZ	:=SA1->A1_NREDUZ
    SA2->A2_TIPOF	:="6"
    SA2->A2_CEP		:=SA1->A1_CEP
    SA2->A2_END		:=SA1->A1_END
    SA2->A2_BAIRRO	:=SA1->A1_BAIRRO
    SA2->A2_MUN		:=SA1->A1_MUN
    SA2->A2_EST		:=SA1->A1_EST
    SA2->A2_TIPO	:=SA1->A1_EST
    SA2->A2_CGC		:=SA1->A1_CGC
    SA2->A2_INSCR	:=SA1->A1_INSCR
    SA2->A2_NATUREZ	:="2010"
    SA2->A2_CONTA	:="1.1.2.03.05"
    SA2->A2_CLVL	:="C"+SA1->A1_COD
    SA2->A2_XQUALIF	:="1"
    SA2->A2_PRODUT	:="2"
    SA2->A2_ISO9001	:="A"
    MSUNLOCK("SA2")
    cFornece:=SA2->A2_COD
    cLojaf:=SA2->A2_LOJA
  ENDIF  
  //Fase3 Incluir o titulo no Contas a Pagar 
  DbSelectArea("SE2")
  SE2->(DbSetOrder(1))
  
  if SE1->E1_TIPO="RA " .or. SE1->E1_TIPO="NCC"
   		if SE2->(DbSeek(xFilial("SE2")+"010"+SE1->E1_NUM+SE1->E1_PARCELA+"NDC"))
    		Aviso("Processo Interrompido","Ja Existe titulo para esta finalidade no Contas a Pagar Solicite Exclusao p/ nova inclusao",{"&Ok"},,"Inconsistencia") 
    		lVerOk:=.f.
  		else
    		RecLock("SE2",.T.)
    		SE2->E2_FORNECE	:=cFornece
    		SE2->E2_NUM		:=SE1->E1_NUM
    		SE2->E2_TIPO	:="NDC"
    		SE2->E2_VALOR	:=SE1->E1_SALDO
    		SE2->E2_NATUREZ	:="2010"
    		SE2->E2_EMISSAO	:=SE1->E1_EMISSAO
    		SE2->E2_VENCTO	:=SE1->E1_VENCTO
    		SE2->E2_VENCREA	:=SE1->E1_VENCREA
    		SE2->E2_PREFIXO	:="010"
    		SE2->E2_LOJA	:=cLojaf
    		SE2->E2_VLCRUZ	:=SE1->E1_SALDO
    		SE2->E2_HIST	:="Tit Cred a Pagar"
    		SE2->E2_ORIGEM	:="FINA050"
    		SE2->E2_EMIS1	:=SE1->E1_EMIS1
    		SE2->E2_MOEDA	:=SE1->E1_MOEDA
    		SE2->E2_NOMFOR  :=SE1->E1_NOMCLI
    		SE2->E2_SALDO	:=SE1->E1_SALDO
    		MSUNLOCK("SE2")
    		Aviso("Processo Concluido","Processo concluido com sucesso",{"&Ok"},,"Processo") 
  		endif
  endif
  
    if SE1->E1_TIPO="NF "
   		if SE2->(DbSeek(xFilial("SE2")+"010"+SE1->E1_NUM+SE1->E1_PARCELA+"NDF"))
    		Aviso("Processo Interrompido","Ja Existe titulo para esta finalidade no Contas a Pagar Solicite Exclusao p/ nova inclusao",{"&Ok"},,"Inconsistencia") 
    		lVerOk:=.f.
  		else
    		RecLock("SE2",.T.)
    		SE2->E2_FORNECE	:=cFornece
    		SE2->E2_NUM		:=SE1->E1_NUM
    		SE2->E2_TIPO	:="NF"
    		SE2->E2_VALOR	:=SE1->E1_SALDO
    		SE2->E2_NATUREZ	:="2002"
    		SE2->E2_EMISSAO	:=SE1->E1_EMISSAO
    		SE2->E2_VENCTO	:=SE1->E1_VENCTO
    		SE2->E2_VENCREA	:=SE1->E1_VENCREA
    		SE2->E2_PREFIXO	:="011"
    		SE2->E2_LOJA	:=cLojaf
    		SE2->E2_VLCRUZ	:=SE1->E1_SALDO
    		SE2->E2_HIST	:="Tit CTRECEB TR CTPAG"
    		SE2->E2_ORIGEM	:="FINA050"
    		SE2->E2_EMIS1	:=SE1->E1_EMIS1
    		SE2->E2_MOEDA	:=SE1->E1_MOEDA
    		SE2->E2_NOMFOR  :=SE1->E1_NOMCLI
    		SE2->E2_SALDO	:=SE1->E1_SALDO
    		MSUNLOCK("SE2")
    		Aviso("Processo Concluido","Processo concluido com sucesso",{"&Ok"},,"Processo") 
  		endif
  endif
         
  

endif

Return(lVerOk)


