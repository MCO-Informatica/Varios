#Include "rwmake.ch"
   

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ AT450OKD ºAutor  ³ ROBSON BUENO       º Data ³  20/09/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Excluindo Processos a Partir da OS   .                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Compras / Fiscal                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function AT450OKD()
Local lOk := .T.
// Não se pode deltar uma Pré OS na rotina de Ordem de Serviço
if M->AB6_XPREOS = '1'
	Alert("Pré Ordem de Serviço só pode ser excluída pela rotina de Pré Ordem de Serviço")
	lOk := .F.
endif
if lOk
 	lok := U_AT450DC(.T.)
endif 	
Return lOk

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ AT450DC  ºAutor  ³ ROBSON BUENO       º Data ³  20/09/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Excluindo ordem de Servico                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Compras / Fiscal                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

USER FUNCTION AT450DC(lOkOP)
local cProcura
Local aArea      := (GetArea())  
Local aCampos    :={}
Local c450Pv
Local c450ItemPv 
Local c450Ctr
Local c450Ctrori
PRIVATE aSav650 := Array(20)
// Verifica controle de processo antes de excluir
dbselectarea("PC2")
dbSetOrder(6)
MsSeek(xfilial("PC2")+AB7->AB7_PV+SUBSTRING(AB7->AB7_ITPV,1,2)+"OS:"+AB6->AB6_NUMOS+" - 01 - "+AB6->AB6_NREDUZ)
IF SUBSTRING(PC2->PC2_INF,1,14)="OS:"+AB7->AB7_NUMOS+" - 01"
       c450Pv    :=PC2->PC2_NUM
       c450ItemPv:=PC2->PC2_ITEM
       c450Ctr   :=PC2->PC2_CTR
       c450Ctrori:=PC2->PC2_CTRORI
       // 1 - ELIMINA PROCESSO ATUAL
       IF U_HCIPDPR(c450Pv,c450ItemPv,c450Ctr)=.T. .AND. lOkOp  // PEDIDO - ITEM - CONTROLE
         U_HCIEXPR(c450Pv,c450ItemPv,c450Ctr) 
       ELSE  
         LoKoP:=.F.
       ENDIF
       // 2- ELIMINA processo do Faturamento OS se Possivel
       IF U_HCIPDPR(c450Pv,c450ItemPV,c450CtrOri)=.T. .AND. lOkOp // PEDIDO - ITEM - CONTROLE
         U_HCIEXPR(c450Pv,c450ItemPv,c450Ctrori) 
       ENDIF  
ENDIF
// CONTINUA A ROTINA ANTERIOR
If lOkOp
// VERIFICANDO SE PEDIDO DE VENDA SAIU
dbSelectArea("SC5")
dbSetOrder(1)
IF MsSeek(xFilial("SC5")+"B" + SUBSTR(AB6->AB6_NUMOS,2,5))
	IF SC5->C5_NOTA<>"      "
	  Aviso("Atencao","	Nao sera possivel excluir OS pois o Material Ja Saiu para Beneficiar.Utilize a opcao Cancelar",{"OK"},2) //"Atencao"###"Nao registro de estoques para este produto."###"Voltar"			  
      lokop:=.F.
      RestArea(aArea)
      Return lOkOP     
    ELSE
     a410altera("SC5",RECNO(),4)
     a410deleta("SC5",RECNO(),5)
     dbSelectArea("SC5")
     dbSetOrder(1)
     IF MsSeek(xFilial("SC5")+"B" + SUBSTR(AB6->AB6_NUMOS,2,5))
       Aviso("Atencao","	Nao sera possivel excluir OS pois náo foi efetiva a acao de exclusao do PV",{"OK"},2) //"Atencao"###"Nao registro de estoques para este produto."###"Voltar"
       lokop:=.F.
       RestArea(aArea)
       Return lOkOP     
     ENDIF    
    ENDIF
ENDIF
dbSelectArea("AB7")
DbSetOrder(1)
MsSeek(xFilial("AB7")+AB6->AB6_NUMOS)
While ( !Eof() .And. AB7->AB7_FILIAL == xFilial("AB7") .And.;
    							AB7->AB7_NUMOS== AB6->AB6_NUMOS )
	IF AB7->AB7_PV="      "       
	  cProcura:=AB6->AB6_NUMOS+"01"+"EST" 
	else
	  cProcura:=AB6->AB6_NUMOS+"01"+"CAS"
	endif  
	DbSelectArea("SC2")
	dbSetOrder(1)
	If MsSeek(xfilial("SC2")+cProcura)     	
       	IF SC2->C2_QUJE=0 
       	  RecLock("SC2",.F.,.T.)
		  dbDelete()
		  MsUnLock()
		ENDIF  
	ENDIF 
	DbSelectArea("SC2")
	dbSetOrder(1)
	If MsSeek(xfilial("SC2")+cProcura)    
	 
       Aviso("Atencao","	Nao sera possivel excluir OS pois náo foi efetiva a acao de exclusao da OP... OP Encerrada... ",{"OK"},2) //"Atencao"###"Nao registro de estoques para este produto."###"Voltar"
       lokop:=.F.
       RestArea(aArea)
       Return lOkOP     
    ENDIF
	dbSelectArea("AB7")
	dbSkip()
EndDo

// EXCLUINDO AMARRACAO OS X PV

dbSelectArea("AB7")
DbSetOrder(1)
MsSeek(xFilial("AB7")+AB6->AB6_NUMOS)
IF (!Eof() .And. AB7->AB7_FILIAL == xFilial("AB7") .And.;
   							AB7->AB7_NUMOS== AB6->AB6_NUMOS )
  IF AB7->AB7_PV="      "  .OR. AB7->AB7_TIPO='5'  
  ELSE
    dbSelectArea("SZK")
    DbSetOrder(4)
    IF MsSeek(xFilial("SZK")+"OS"+AB6->AB6_NUMOS+"01 "+"PV"+AB7->AB7_PV+AB7->AB7_ITPV)
      Reclock("SZK",.F.)
      DbDelete()
    MsUnLock()
    ENDIF
  ENDIF
ENDIF 
else
  Aviso("Atencao","Nao sera possivel excluir OS pois Existem Rotinas posteriores Baixadas... Elimine as amarrações de Processo para depois excluir OS... ",{"OK"},2) //"Atencao"###"Nao registro de estoques para este produto."###"Voltar"
endif
RestArea(aArea)
Return lOkOP     
                      