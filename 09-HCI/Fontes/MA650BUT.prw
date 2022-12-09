#INCLUDE "PROTHEUS.CH"
//-------------------------------------------------------------------
/*/{Protheus.doc} MA650BUT
Adiciona itens no menu principal do fonte MATA650

@author		Jair Ribeiro 
@since		01/08/2015
@version	1.0
@obs		Rotina Especifica
/*/
//-------------------------------------------------------------------
User Function MA650BUT()
aAdd(aRotina,{'Digitalizacao','u_LOTXM010',0,5}) 
aAdd(aRotina,{'PV/OP Ajusta','u_PVOPAJ',0,5})
aAdd(ARotina,{'Grava Prazos','u_OPOCLT',0,5})
aAdd(ARotina,{'Recalcula CM','u_OPRCM',0,5})
Return aRotina

//-------------------------------------------------------------------
User Function PVOPAJ()
  Local cPv
  Local cItPv
  Local cOP 
  Local cOpItem
  Local cOpSeq
  Local lRet:=.F.
  cOp    :=SC2->C2_NUM
  cOpItem:=SC2->C2_ITEM
  cOpSeq :=SC2->C2_SEQUEN
  cPv	 :=SC2->C2_PEDIDO
  cItemPv:=SC2->C2_ITEMPV
  IF cOpSeq="CAS"
    If MsgYesNo("Deseja realmente Retirar o Pedido de Vendas da OP?","Automacao de Processo")   
        Reclock("SC2",.F.)
        SC2->C2_PEDIDO:=""
        SC2->C2_ITEMPV:=""
        MsUnLock()
    ENDIF
    lRet:=.t.
  ENDIF
  If  lRet=.f.
  If cPv="      "  .or. cOpSeq<>"001"
      MsgInfo("Pedido de Venda nao informado no registro selecionado ou selecao nao se refere a uma OP Mae. Verifique")
  else
    If MsgYesNo("Deseja realmente Expandir para OP Filhas da OP:" + cOp + cOpItem + " o Numero do Pedido: "+ cPv + " ?","Automacao de Processo")    
      dbSelectArea("SC2")
      DbSetOrder(1)
      MsSeek(xFilial("SC2")+cOp+cOpItem+cOpSeq)
      do while (!Eof() .And. cOp==SC2->C2_NUM .And. cOpItem==SC2->C2_ITEM)
        Reclock("SC2",.F.)
        SC2->C2_PEDIDO:=cPv 
        SC2->C2_ITEMPV:=cItemPv
        MsUnLock()
        dbSkip()
      enddo
      MsgInfo("Pedido de Venda Propagado para a itens filhos da OP:" + cOp +"")
    endif
  endif    
  endif
Return       

//----------------------------------------------------------------------------------
// FUNCAO PARA EXTRAIR DOS PROCESSOS A DATA LIMITE PARA ENTREGA DAS MATERIAS PRIMAS
// PARA ATENDER A OP --- CARREGA 2 CAMPOS NA SC2 --- C2_DATCPA -- C2_DTLT --   
//----------------------------------------------------------------------------------

User Function OPOCLT()
  Local cPv
  Local cItPv
  Local cOP 
  Local cOpItem
  Local cOpSeq
  Local cChave
  Local cOc
  Local cItem
  Local dPrazo:=Date()-1 
  Local dLead :=Date()-1
  Local lRet:=.F.
  Local aArea    := GetArea()
  if MsgYesNo("Esta rotina extrai dados dos prazos de compra e lead time e guardam na Ordem de Producao. O processamento e lento. Deseja realmente processar esta rotina?")
    // ABRE ARQUIVO DAS ORDENS DE PRODUCAO
    DbSelectArea("SC2")
    DbSetOrder(1)
    DbGoTop()
    do while (!Eof())
      // 1O PASSO -- AVALIA SOMENTE AS ORDENS DE PRODUCAO NAO ENCERRADAS E STATUS=NORMAL
      IF  SC2->C2_QUANT<>SC2->C2_QUJE .AND. SC2->C2_STATUS $ "N, "
        cChave:=SC2->C2_NUM + SC2->C2_ITEM + SC2->C2_SEQUEN
        //2O PASSO -- ABRE ARQUIVO DE SOLICITACOES 
        DbSelectArea("SC1")  			// abre tabela de solicitacoes
        DbSetOrder(4)        			// abre indice que permite localizadao pelo Numero da OP
        MsSeek(xFilial("SC1")+cChave)  // Localiza 1o Registro com a Chave da Op a Ser Avaliada.
        do while (!Eof() .And. SUBSTR(SC1->C1_OP,1,11)=cChave)
          If SC1->C1_PEDIDO<>"      "  // Executa a procura na compra somente dos casos em que a compra ja foi realizada
             cOc  :=   SC1->C1_PEDIDO
             cItem:=   SC1->C1_ITEMPED
             //3o PASSO -- ABRE ARQUIVO DAS ORDENS DE COMPRA 
             DbSelectArea("SC7")  			    // abre tabela de Ordens de Compra
             DbSetOrder(1)        			    // abre indice que permite localizadao pelo Numero da Ordem de Compra
             MsSeek(xFilial("SC7")+cOc+cItem)  // Localiza 1o Registro com a da Compra a ser Localizada.
             do while (!Eof() .And. SC7->C7_NUM=cOc .and. SC7->C7_ITEM=cItem)
               IF SC7->C7_QUANT<>SC7->C7_QUJE .and. dPrazo<SC7->C7_DATPRF
                 dPrazo:=SC7->C7_DATPRF        // guarda o prazo mais longo de entrega das compras relacionadas a OP
               Endif  
               DbSelectArea("SC7")  	
               SC7->(dbSkip())
             enddo 
          endif
          // 4o Passo -- Verifica o Lead Time das Solicitaoes
          DbSelectArea("SB1")  			             // abre tabela de Produtos
          DbSetOrder(1)   
          IF MsSeek(xFilial("SB1")+SC1->C1_PRODUTO) // Localiza o Produto para extrair o Lead Time.
            if dLead< Date()+SB1->B1_PE
              dLead:=Date()+SB1->B1_PE
            ENDIF   
          ENDIF
          DbSelectArea("SC1")  
          SC1->(dbSkip())
        enddo
      ENDIF
      // PROCESSO DE GRAVACAO DE DADOS
      IF dPrazo<Date() .and. dLead<Date()
        // nada a fazer
      else
        // guarda dados das pesquisas nos campos C2_DATCPA -- C2_DTLT --
        DbSelectArea("SC2")
        Reclock("SC2",.F.)
        if dPrazo>Date() 
          SC2->C2_DATCPA:=dPrazo 
        endif
        If dLead>Date()
          SC2->C2_DTLT  :=DLead
        endif
        MsUnLock()
        lRet:=.T.
      endif        
      // seta as variaveis para o padrao para nova pesquisa
      cOc:="      "
      cItem:="    "
      dPrazo:=Date()-1 
      dLead :=Date()-1
      DbSelectArea("SC2")
      SC2->(dbSkip())
    enddo    
  endif    
  if lRet
    MsgInfo("Processo Realizado com Sucesso")
  else
    MsgInfo("Nada Foi Feito")
  endif
  RestArea(aArea)   
Return 

//----------------------------------------------------------------------------------
// FUNCAO PARA REFAZER O CARGA MAQUINA (SH8)
// PARA ATENDER A OP --- CARREGA 2 CAMPOS NA SC2 --- C2_DATCPA -- C2_DTLT --   
//----------------------------------------------------------------------------------

User Function OPOCM() 
   Local cOp
   Local dDtAju:=CTOD("  /  /  " )   
   // Informacoes relevantes
   // Indices SH8
   // 1 - H8_FILIAL+H8_OP+H8_OPER+H8_DESDOBR 
   // 2 - H8_FILIAL+H8_RECURSO+STR(H8_BITINI,8)
   // 3 - H8_FILIAL+H8_RECURSO+STR(H8_BITFIM,8)                                                                                                                                                                                                                                                                                                                                                                               
      
   // 1a Fase - Realoca as Ops Com Limitacoes de Prazos de Compra 
   DbSelectArea("SH8")  			             // abre tabela do Carga maquina
   DbSetOrder(1)                                 // Abre Indice 1 (Filial + Op + Oper + Desdobram
   DbGoTop()
   Do While (!Eof())
     // Ler o Registro atual
     cOp:=SH8->H8_OP
     // Abre a Ordem de Producao e Verifica se ha limitador para Inicio da Producao
     DbSelectArea("SC2")
     DbSetOrder(1)
     IF MsSeek(xFilial("SC2")+cOp+"  ") // Localiza o Produto para extrair o Lead Time.
       dDtAju:=SC2->C2_DATCPA
       IF SC2->C2_DTLT <> CTOD("  /  /  ")
         IF SC2->C2_DATCPA<SC2->C2_DTLT 
           dDtAju:=SC2->C2_DTLT
         ENDIF   
       ENDIF
       IF dDtAju<>CTOD("  /  /  ") 
       
       ENDIF
     ENDIF
   Enddo
   // 1a Fase - Recalcula os elementos com base no que ja foi firmado 
   
   





Return
   
    