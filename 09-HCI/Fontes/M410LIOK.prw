#INCLUDE "Protheus.ch"
#INCLUDE "TopConn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º Programa    ³ M410LIOK ³ Ponto de entrada na troca de linha, para criar almoxarifado  º±±
±±º             ³          ³ caso nao exista.                                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Solicitante ³ 20.03.07 ³ Robson                                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Autor       ³ 20.03.07 ³ Osmil Squarcine                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Produção    ³ ??.??.?? ³ Ignorado                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Parâmetros  ³ Nil                                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Retorno     ³ Nil                                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Observações ³ 1. Validar se o almoxarifado existe, caso nao exista ele cria o sb2     º±±
±±º             ³                                                                         º±±
±±º             ³                                                                         º±±
±±º             ³                                                                         º±±
±±º             ³                                                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Alterações  ³ ??.??.?? - Nome - Descrição                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function M410LIOK()

Local lRet		 := .T.
Local lContinua  := .T.
Local aAreaAtu	 := GetArea()												// Salva a area atual
Local aAreaSB2	 := SB2->(GetArea())										// Salva a area do SB2
Local dPrazo     := aScan(aHeader, { |x| AllTrim(x[2]) == "C6_ENTREG"} )	// Prazo 
Local nProduto   := aScan(aHeader, { |x| AllTrim(x[2]) == "C6_PRODUTO"} )	// Produto
Local nPLocal	 := aScan(aHeader, { |x| AllTrim(x[2]) == "C6_LOCAL"} )		// Local
Local nItem      := aScan(aHeader, { |x| AllTrim(x[2]) == "C6_ITEM"} )		// Local     
Local nQtd       := aScan(aHeader, { |x| AllTrim(x[2]) == "C6_QTDVEN"} ) 
Local nDias      := aScan(aHeader, { |x| AllTrim(x[2]) == "C6_XDIAS"} )		// Local  
Local nNumRef    := aScan(aHeader, { |x| AllTrim(x[2]) == "C6_NUMREF"} )		// Local  
local nIPI		 :=IIF(ReadVar()=='M->C6_IPI', M->C6_IPI, ACols[n][aScan(aHeader,{|x| AllTrim(x[2])=="C6_IPI"})])
LOCAL cTs		 :=IIF(ReadVar()=='M->C6_TES', M->C6_TES, ACols[n][aScan(aHeader,{|x| AllTrim(x[2])=="C6_TES"})])
Local dPrazo2    := Posicione("SC6",1,xFilial("SC6")+M->C5_NUM+aCols[n, nItem],"C6_ENTREG")
Local nSaldoTot  :=0
Local nSaldoAlm  :=0
Local cLocRes    :=Posicione("SC6",1,xFilial("SC6")+M->C5_NUM+aCols[n, nItem],"C6_LOCAL")
Local nQtdVda    :=IIF(cLocRes=aCols[n, nPLocal],aCols[n, nQtd],0) 
Local nSaldo     :=aCols[n, nQtd]-Posicione("SC6",1,xFilial("SC6")+M->C5_NUM+aCols[n, nItem],"C6_QTDENT")
Private cEmpAtual:= SM0->M0_CODIGO
if nSaldo>0 .and. aCols[n, nPLocal]<>cLocRes
  nSaldoTot  :=U_SALRAP(aCols[n, nProduto])
  nSaldoAlm  :=U_SALRAPV(aCols[n, nProduto],aCols[n, nPLocal],M->C5_NUM,aCols[n, nItem],"PV") 
endif
If !GDDeleted() 
// SE FOR CONTRATO ANALISA AS CONDICOES
If ChkFile("PZZ",.F.)
  dbSelectArea("PZZ")
  dbSetOrder(1)
  If MsSeek(xFilial("PZZ")+aCols[n, nNumRef])
   if aCols[n, nDias]<>PZZ->PZZ_PRAZO
    	TONE(3500,1)
        If MsgYesNo("O Prazo da Venda:-->"+ transform(aCols[n, nDias],"@e 9999") + " dias,  esta diferente do prazo no contrato:-->" +transform(PZZ->PZZ_PRAZO,"@e 9999")+ " dias. Deseja substituir o Prazo da Venda?") 
          aCols[n, nDias]:=PZZ->PZZ_PRAZO 
          aCols[n, dPrazo]:=M->C5_EMISSAO + PZZ->PZZ_PRAZO 
        EndIf
   ENDIF
  ENDIF
ENDIF
dbSelectArea("SB2")
dbSetOrder(1)
  If !MsSeek(xFilial("SB2")+aCols[n, nProduto]+aCols[n, nPLocal])
	TONE(3500,1)
    If MsgYesNo("Deseja Criar Almoxarifado:-->"+ aCols[n, nPLocal] + "   Para o Produto:-->" +aCols[n, nProduto]) 
      CriaSB2(aCols[n, nProduto],aCols[n, nPLocal],xFilial("SB2"))
	Else
  	 aCols[n, nPLocal] := "01"
	EndIf
  else
    // verifica o saldo no estoque para esta demanda 
    If cEmpAtual="01" .AND. nSaldo>0 .AND. aCols[n, nPLocal]<>cLocRes
      if nSaldoAlm+nQtdVda >= aCols[n, nQtd]
      else
        If nSaldoAlm+nQtdVda < aCols[n, nQtd] .or. nSaldoTot<=0  
          IF nSaldoTot<=0 .AND. M->C5_TIPOPV="0" .and. aCols[n, nPLocal] <> "MN" 
             MsgInfo("ATENCAO, O almoxarifado correto para itens sem estoque (Classificados Nacional)=<MN>")
             lret:=.F.
             lContinua:=.F.
          ENDIF 
          IF nSaldoTot<=0 .AND. M->C5_TIPOPV<>"0" .and. aCols[n, nPLocal] <> "MI" 
             MsgInfo("ATENCAO, O almoxarifado correto para itens sem estoque (Classificados Importado)=<MI>")
             lret:=.F.
             lContinua:=.F.
          endif
          if lContinua=.T. .AND. nSaldoAlm+nQtdVda < aCols[n, nQtd] .and. aCols[n, nPLocal]<> "MN" .and. M->C5_TIPOPV="0"
            MsgInfo("ATENCAO, A Quantidade Vendida e Maior que a quantidade disponivel neste Almox, Altere o Almox ou a Quantidade Vendida")
            LRET:=.F.
          endif
          if lContinua=.T. .AND. nSaldoAlm+nQtdVda < aCols[n, nQtd] .and. aCols[n, nPLocal]<> "MI" .and. M->C5_TIPOPV<>"0"
            MsgInfo("ATENCAO, A Quantidade Vendida e Maior que a quantidade disponivel neste Almox, Altere o Almox ou a Quantidade Vendida")
            LRET:=.F.
          endif
        endif
      endif
    endif
  endif	
EndIf
IF ACOLS[N,LEN(ACOLS[N])]=.T.
  dbSelectArea("SZK")
  DbSetOrder(1)
  IF MsSeek(xFilial("SZK")+"PV"+M->C5_NUM+aCols[n, nItem])
    MsgInfo("Exclusao de Item de Pedido nao permitido... Itens amarrados com OC/OS existentes. Contate compras para solucao do problema")
    LRET:=.F.
  ENDIF
  dbSelectArea("PC2")
  DbSetOrder(4)
  MsSeek(xFilial("PC2")+M->C5_NUM+aCols[n, nItem]+"000002")
  WHILE (!Eof() .AND. PC2->PC2_NUM=M->C5_NUM .AND. PC2->PC2_ITEM=aCols[n, nItem] .AND. PC2->PC2_SEQ="000002".and. lRet=.T.)
    if PC2->PC2_QTD >0
      MsgInfo("Exclusao de Item de Pedido nao permitido... O pedido tem Controle de Processo e Somente o Departamento de Diligenciamento Pode Liberar o Pedido")
      LRET:=.F. 
    ENDIF
    DBSKIP()
  EndDo  
ENDIF
IF DOW(aCols[n, dPrazo])=7 .OR. DOW(aCols[n, dPrazo])=1 
  MsgInfo("O Prazo da Venda nao pode se encerrar em Finais de Semana...")
  LRET:=.F.
endif
//SOMENTE O VENDEDOR PODE MUDAR O PRAZO DE ENTREGA
//IF !INCLUI .AND. dPrazo2<> aCols[n, dPrazo] .and. __cUserId<>Posicione("SA3",1,xFilial("SA3")+Posicione("SC5",1,xFilial("SC5")+M->C5_NUM,"C5_AGINT"),"A3_GEREN")
//  MsgInfo("O prazo de Entrega somente pode ser alterado pelo emitente do pedido. Favor Contactar:" + Substr(UsrRetName(Posicione("SA3",1,xFilial("SA3")+Posicione("SC5",1,xFilial("SC5")+M->C5_NUM,"C5_AGINT"), "A3_GEREN")),1,15))
//  LRET:=.F.
//endif  
/*
DbSelectArea("EF0")
dbSetOrder(1)
If MsSeek(xfilial("EF0")+"1"+aCols[n, dPrazo])    
  MsgInfo("O Prazo da Venda nao pode se encerrar em Feriados..."+ EFO->EF0_MOTIVO)
ENDIF  
*/



IF cPaisLoc == "BRA"

	DbSelectArea("SF4")
	dbSetOrder(1)
	If MsSeek(xfilial("SF4")+cTS)    
	  IF nIpi<>0 
	    IF SF4->F4_IPI<> "S" 
	      lRet:=.F.
	      MsgInfo("O <TES> (Tipo de Entrada e saida) selecionado nao permite IPI na venda.","Atencao") 
	    endif   
	  ELSE
	    IF SF4->F4_IPI = "S" .AND. SF4->F4_IPIOBS="2"
	      lRet:=.F.
	   	  MsgInfo("O <TES> (Tipo de Entrada e saida) selecionado obriga IPI na venda.","Atencao") 
	    endif  
	  ENDIF
	endif
	
EndIF	
// Restaura a integridade dos dados
RestArea(aAreaSB2)
RestArea(aAreaAtu)
IF FunName()=="RFATA021" 
  RFTL21K()
ENDIF

Return(lRet)
                 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³ salrapV()³ Autor ³ ROBSON BUENO          ³ Data ³ 07/11/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o  ³ Consulta Saldo Real do Produto            				   ³±±	
±±³           ³ demanda hci							                       ³±±
±±³           ³ cProd = Codigo do Produto desejado                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USO        ³ REMOTE                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function SALRAPV(cProd,cLocal,cPedido,cItem,cOrigem)
Local aAreaAtu	:= GetArea()
Local nSaldo:=0
Local cQueSC6
Local cAm1
Local cAm2
Local cAm3
Local cAm4
lOCAL cAm5
Local cAm6
Local cIndice
Local cPedRef
nCasados:=0
//carregando saldo real do produto
DbSelectArea("SB2")
dbSetOrder(1)
MsSeek(xfilial("SB2")+cProd+cLocal)
While ( !Eof() .And. SB2->B2_COD == cProd .and. SB2->B2_LOCAL==cLocal)
    IF SB2->B2_STATUS<>"2"
     if cOrigem<>"LP"
       nSaldo:=nSaldo+SB2->B2_QATU+SB2->B2_QNPT
	 else
       nSaldo:=nSaldo+SB2->B2_QATU
	 endif
	ENDIF
	dbSkip()
EndDo
//DbSelectArea("SC6")
//dbSetOrder(11)
//MsSeek(xfilial("SC6")+cProd)

cQueSC6 := "SELECT SC6.C6_NUM,SC6.C6_ITEM,SC6.C6_PRODUTO,SC6.C6_TES,SC6.C6_QTDVEN,SC6.C6_QTDENT,SC6.C6_CLI,SC6.C6_LOJA,SC6.C6_LOCAL," 
cQueSC6 += "SC6.C6_PRCVEN,SC6.C6_ENTREG,SC6.C6_NOTA,SC6.C6_DATFAT FROM " + RetSqlName("SC6")+ " SC6 " 
cQueSC6 += "WHERE "
cQueSC6 += "SC6.C6_FILIAL = '"+xFilial("SC6")+"' AND "
cQueSC6 += "SC6.C6_PRODUTO = '"+cProd+"' AND "
cQueSc6 += "SC6.C6_LOCAL = '"+cLocal+"' AND "
if cOrigem="LP"
 cQueSc6 += "SC6.C6_NUM  = '"+cPedido+"' AND "
 cQueSc6 += "SC6.C6_ITEM = '"+cItem+"' AND "
endif
cQueSc6 += "SC6.C6_QTDVEN-SC6.C6_QTDENT>0 AND "
cQueSC6 += "SC6.D_E_L_E_T_=' ' ORDER BY SC6.C6_ENTREG DESC"
//cQuery := ChangeQuery(cQuery)
If ( Select ("QSC6") <> 0 )
			dbSelectArea ("QSC6")
			dbCloseArea ()
Endif
dBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQueSC6),"QSC6",.T.,.T.)
dbSelectArea("QSC6")
While ( !Eof() .And. QSC6->C6_PRODUTO == cProd )
    if Posicione("SF4",1,xFilial("SF4")+QSC6->C6_TES,"F4_DUPLIC")="S".OR. SUBSTR(QSC6->C6_NUM,1,1)="B" .OR. SUBSTR(QSC6->C6_NUM,1,1)="D" .OR. SUBSTR(QSC6->C6_NUM,1,1)="T" .OR. SUBSTR(QSC6->C6_NUM,1,1)="R" .OR. SUBSTR(QSC6->C6_NUM,1,1)="A" .OR. QSC6->C6_TES="514" .OR. QSC6->C6_TES="999" .OR. QSC6->C6_TES="693" .OR. QSC6->C6_TES="553" .OR. QSC6->C6_TES="592" .OR. QSC6->C6_TES="556" .OR. QSC6->C6_TES="591" 
      if cOrigem<>"LP"
        nsaldo:=nSaldo-(QSC6->C6_QTDVEN-QSC6->C6_QTDENT)
      endif
      // rotina nova
      if cOrigem<>"LP"
        IF SUBSTR(QSC6->C6_NUM,1,1)="B" 
          cIndice:="OS"
          cPedRef:="0"+SUBSTR(QSC6->C6_NUM,2,5)
        ELSE  
          cIndice:="PV"
          cPedRef:=QSC6->C6_NUM
        ENDIF  
        IF QSC6->C6_QTDVEN-QSC6->C6_QTDENT>0  
          DbSelectArea("SZK")
          dbSetOrder(1)
          //if Posicione("SZK",1,xFilial("SZK")+cIndice+cPedRef+QSC6->C6_ITEM,"ZK_OC")<>"      " 
          IF MsSeek(xfilial("SZK")+cIndice+cPedRef+QSC6->C6_ITEM)
            cAm1:=SZK->ZK_OC 
            cAm2:=SZK->ZK_ITEM
            cAm3:=SZK->ZK_FORN
            cAm4:=SZK->ZK_TIPO2 
            cAm5:=SZK->ZK_STATUS 
            cAm6:=SZK->ZK_QTS
            dbSelectArea("QSC6")
            IF cAm5<>"4" .AND. cAm4="OC"  
              nCasados:=nCasados + cAm6 
              nSaldo:=nSaldo+cAm6
            ENDIF
            IF cAm5<>"4" .AND. cAm4="OS"
              IF cAm6>0 .AND. cAm6>QSC6->C6_QTDVEN-QSC6->C6_QTDENT 
                nSaldo:=nSaldo+QSC6->C6_QTDVEN-QSC6->C6_QTDENT
              else
                nSaldo:=nSaldo+cAm6
              endif
            endif
          endif 
        endif
      endif  
    ENDIF
	dbSelectArea("QSC6")    
	dbSkip()
EndDo 
if cOrigem<>"LP"
  DBSELECTAREA("SB6")
  DBSETORDER(1)                                                                                                          
  If SB6->(DbSeek(xFilial("SB6")+cProd))
  	While xFilial("SB6") == SB6->B6_FILIAL .and. ! SZB->(Eof()) .and. SB6->B6_PRODUTO == cProd  .and. SB6->B6_LOCAL=cLocal
    	if SB6->B6_SALDO>0 .AND. SB6->B6_TIPO="E" .and. SB6->B6_CLIFOR<>'000090' .AND. SB6->B6_CLIFOR<>'000001'   
    	  nSALDO:=nSALDO-SB6->B6_SALDO
    	ENDIF
   		SB6->(DbSkip())
   	EndDo 
  ENDIF
endif
RestArea(aAreaAtu)
Return (nSaldo)
