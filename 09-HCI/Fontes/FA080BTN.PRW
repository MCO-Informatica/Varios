#INCLUDE "PROTHEUS.CH"
#INCLUDE "JPEG.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FA080BTN  ºAutor  ³ROBSON BUENO        º Data ³  13/02/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de Entrada na Ordem de Compra (PC) para agregar       º±±
±±º          ³observacoes especificas do negocio HCI (VIA CONTRATO)       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function FA080BTN()             
//	AADD(aButtons, {"G.Ctas.Pag", {|| FA070BT1(.T.)}, "G.Ctas.Pag."}) //"Recálculo dos Impostos"  
//	{{"G.Ctas Pag"	,"U_FA070BT1()" , 0 , 3}}
//{"G. Etiqueta"	,"U_MT140RT1()" , 0 , 6}

Return({{"SIMULACA",{|| U_FA080BT1()},"G.CtRec"}})




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
User Function FA080BT1()
Local lVerOk:=.t.
Local cCnpj
Local cFornece
Local cLojaf
IF lVerOk=.t. 
  //Fase1 Verificar se existe o cliente como fornecedor
  DbSelectArea("SA2")
  SA2->(DbSetOrder(1))
  if SA2->(DbSeek(xFilial("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA))
    cCnpj:= sa2->a2_cgc
  endif
  //Fase2 Incluir Cadastro de Fornecedores
  DbSelectArea("SA1")
  SA1->(DbSetOrder(3))
  if SA1->(DbSeek(xFilial("SA1")+cCnpj))
    cFornece:=SA1->A1_COD
    cLojaf:=SA1->A1_LOJA
  ELSE
    RecLock("SA1",.T.)
    SA1->A1_COD		:="F"+SUBSTRING(SA2->A2_COD,2,5)
    SA1->A1_LOJA	:=SA2->A2_LOJA
    SA1->A1_NOME	:=SA2->A2_NOME
    SA1->A1_NREDUZ	:=SA2->A2_NREDUZ
    SA1->A1_TIPO	:="1"
    SA1->A1_CEP		:=SA2->A2_CEP
    SA1->A1_END		:=SA2->A2_END
    SA1->A1_BAIRRO	:=SA2->A2_BAIRRO
    SA1->A1_MUN		:=SA2->A2_MUN
    SA1->A1_EST		:=SA2->A2_EST
    SA1->A1_TIPO	:=SA2->A2_EST
    SA1->A1_CGC		:=SA2->A2_CGC
    SA1->A1_INSCR	:=SA2->A2_INSCR
    SA1->A1_NATUREZ	:="1805"
    SA1->A1_CONTA	:="1.1.2.01.01"         
    SA1->A1_CLVL	:="C"+SA1->A1_COD 
    SA1->A1_XVAL1   :="N"
    SA1->A1_XVAL2   :="N"
    SA1->A1_XVAL3   :="N"
    SA1->A1_XVAL4   :="N"
    SA1->A1_COD_NUM	:=SA2->A2_COD_NUM
    SA1->A1_MSBLQL  :="2"
    MSUNLOCK("SA1")
    cFornece:=SA1->A1_COD
    cLojaf:=SA1->A1_LOJA
  ENDIF  
  //Fase3 Incluir o titulo no Contas a RECEBER 
  DbSelectArea("SE1")
  SE1->(DbSetOrder(1))
  if SE1->(DbSeek(xFilial("SE1")+"011"+SE2->E2_NUM+SE2->E2_PARCELA+"NCC"))
    Aviso("Processo Interrompido","Ja Existe titulo para esta finalidade no Contas a Receber Solicite Exclusao p/ nova inclusao",{"&Ok"},,"Inconsistencia") 
    lVerOk:=.f.
  else
    RecLock("SE1",.T.)
    SE1->E1_CLIENTE	:=cFornece
    SE1->E1_NUM		:=SE2->E2_NUM
    SE1->E1_TIPO	:="NCC"
    SE1->E1_VALOR	:=nValPgto
    SE1->E1_NATUREZ	:="1805"
    SE1->E1_EMISSAO	:=SE2->E2_EMISSAO
    SE1->E1_VENCTO	:=SE2->E2_VENCTO
    SE1->E1_VENCREA	:=SE2->E2_VENCREA
    SE1->E1_PREFIXO	:="011"
    SE1->E1_LOJA	:=cLojaf
    SE1->E1_VLCRUZ	:=nValPgto
    SE1->E1_HIST	:="Tit Cred a Rec"
    SE1->E1_ORIGEM	:="FINA080"
    SE1->E1_EMIS1	:=SE2->E2_EMIS1
    SE1->E1_MOEDA	:=SE2->E2_MOEDA
    SE1->E1_NOMCLI  :=SE2->E2_NOMFOR
    SE1->E1_SALDO	:=nValPgto
    MSUNLOCK("SE1")
    Aviso("Processo Concluido","Processo concluido com sucesso",{"&Ok"},,"Processo") 
  ENDIF  
endif

Return(lVerOk)


