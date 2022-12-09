/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT100LOK  ºAutor  ³Robson Bueno        º Data ³  02/01/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³validacao da linha no documento de entrada                  º±±
±±º          ³importacao para controle de lancamento no financeiro        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³HCI                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MT100LOK() 
local lret:=.T. 
Local nPosOp:= aScan(aHeader,{|x| AllTrim(x[2])=="D1_OP"})
Local nPosOp2:= aScan(aHeader,{|x| AllTrim(x[2])=="D1_XOP"})
Local nPosPV:= aScan(aHeader,{|x| AllTrim(x[2])=="D1_PEDIDO"})
Local nPosPC:=aScan(aHeader,{|x| AllTrim(x[2])=="D1_PEDIDO"})
Local nPosItPC:=aScan(aHeader,{|x| AllTrim(x[2])=="D1_ITEMPC"})
Local nPosProd:=aScan(aHeader,{|x| AllTrim(x[2])=="D1_COD"})
Local nPosTes:=aScan(aHeader,{|x| AllTrim(x[2])=="D1_TES"})
Local nPosCusto:=aScan(aHeader,{|x| AllTrim(x[2])=="D1_VUNIT"})
Local nPosLocal:=aScan(aHeader,{|x| AllTrim(x[2])=="D1_LOCAL"})
Private cEmpAtual:= SM0->M0_CODIGO
IF cEmpAtual="01"
IF ACOLS[N,nPosTes]='111' .or. ACOLS[N,nPosTes]='112' .or. ACOLS[N,nPosTes]='113' .or.ACOLS[N,nPosTes]='114'
     IF ACOLS[N,nPosOp]="          " .AND. ACOLS[N,nPosPv]="      "  
        MSGINFO("A TES INFORMADA REQUER A AMARRACAO COM A OP")
        LRET:=.F.
     ELSE
       IF ACOLS[N,nPosPV]="      "
         dbSelectArea("AB7")
         DbSetOrder(1)         
         if MsSeek(xFilial("AB7")+SUBSTRING(ACOLS[N,nPosPV],1,6))
           IF ACOLS[N,nPosCusto]>AB7->AB7_CUSUNIT
             MSGINFO("O valor da Ordem de Servico Diverge com o valor informado na entrada, Revise a OS")
              LRET:=.F.
           endif   
         endif
       ENDIF
     ENDIF
ENDIF 
endif
IF cEmpAtual="02"
  //ATRIBUI O n. Da OP no campo da xOP -- para nao perdermos o historico
  //ACOLS[N,nPosOp2]:=ACOLS[N,nPosOp]
  // SE FOR SERVICO NAO CONTROLA O VALOR DA OC
  IF substr(ACOLS[N,nPosProd],1,4)="SERV" 
  ELSE
    // So Permite se o valor da Compra for = da entrada. + tolerancia
    if ACOLS[N,nPosPC]<>"      "
        if ACOLS[N,nPosCusto]>POSICIONE("SC7",1,XFILIAL("SC7")+ACOLS[N,nPosPC]+ACOLS[N,nPosItPc],"C7_PRECO")*1.05 
          MSGINFO("O Valor da Ordem de Compra <" + STR(POSICIONE("SC7",1,XFILIAL("SC7")+ACOLS[N,nPosPC]+ACOLS[N,nPosItPc],"C7_PRECO"))+"> Diverge com o valor informado na entrada <"+STR(ACOLS[N,nPosCusto])+">, Revise a Ordem de Compra")
          LRET:=.F.
        endif
    endif
  endif
endif 
/*
IF cEmpAtual="01"
   IF ACOLS[N,nPosLocal]<>"MN" .AND. ACOLS[N,nPosLocal]<>"MI"
        MSGINFO("Entradas Permitidas somente nos Armazens [MN e MI]")
        LRET:=.F. 
   endif
endif
*/  
Return lRet