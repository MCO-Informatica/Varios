#INCLUDE "PROTHEUS.CH"
#INCLUDE "Rwmake.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณ RESTA005 ณ Autor ณ 	Robson Bueno         ณ Data ณ 18.06.08 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Registro de Entrada de Materiais eletronico                 ณฑฑ
ฑฑณ          ณ                                                             ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณUso       ณ RESTA005                                                    ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                      ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ PROGRAMADOR  ณ DATA   ณ BOPS ณ  MOTIVO DA ALTERACAO                    ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤลฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณXXXXXXXXXXXXXXณXX/XX/XXณXXXXXXณ                                         ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RESTA005()
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Define Variaveis                                     ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local aCores    := {},aCampos:={}
// A=A Classificar;C=Classificado;I=Inspecionado;R=Recebido;D=Disponivel;B=Baixado;N=Nao Conforme                                  
aCores    := {	{'ZI_STATUS="A"', 'BR_PRETO'},;		
				{'ZI_STATUS="C"', 'BR_BRANCO'},;   
				{'ZI_STATUS="I"', 'BR_AMARELO'},;
				{'ZI_STATUS="R"', 'BR_LARANJA'},;
				{'ZI_STATUS="D"', 'BR_VERDE'},;
				{'ZI_STATUS="B"', 'BR_VERMELHO'},;
			  	{'ZI_STATUS="N"', 'BR_CINZA'}}     

PRIVATE aRotina := { { "Pesquisar","AxPesqui"  ,0,1},;             	// 	Pesquisa  SA
					 { "Visualizar","AxVisual",0,2},;        			//	Vizualiza SA
                     { OemToAnsi("Cria.Sequenc."),"U_RST005A",0,3},;    	//	Registro
					 { OemToAnsi("Classificar"),"U_RST005A",0,4},; 	//	Cancela Registro
					 { OemToAnsi("Canc.Classif."),"U_RST005A",0,5},; 	//	Cria Sequencia de H
					 { OemToAnsi("Reg.Inspecao"),"U_RST005A",0,6},;
					 { OemToAnsi("Canc.Inspecao"),"U_RST005A",0,7},;
					 { OemToAnsi("Elim.Sequencia"),"U_RST005A",0,8},;
					 { OemToAnsi("Alterar"),"U_RST005A",0,9},;
           { OemToAnsi("Incluir corrida"), "u_MntCorri(1)", 0, 10 ,0,nil},;  
					 { OemToAnsi("Conhecimento"), "MsDocument", 0, 11 ,0,nil},;  
					 { "Legenda","U_RST05LG",0,6} }  
						
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Define o cabecalho da tela de atualizacoes           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
PRIVATE cCadastro := OemToAnsi("Controle de Registros de Entrada (RI)")

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Endereca a funcao de BROWSE                          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู 

mBrowse(6,1,22,75,"SZI",,,,,3,aCores)

Return(.T.)

                  
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRST005A   บAutor  ณRobson Bueno        บ Data ณ 18/08/2008  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณTela para confirmacao da acao acionada na rotina            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณHCI                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RST005A(cAlias,nReg,nOpcX)

Local oDlgl
Local cBase:="H"
Local cAno:=str(year(date()))
Local nInicio:=000000
Local nFim:=999999
Local cTitulo:="Criacao de Sequencia de RI" 
Local cRi:=SZI->ZI_RI
Local nOpca
Local nSaldo:=0
Local nProcesso:=0
lOCAL nFILTRO:=0
Local lOkOP:=.T.
Local cPedido
Local cItem

// OPCAO 4 = CLASSIFICACAO
If nOpcx==9
  nOpca:=AxAltera(cAlias,nReg,4)
endif
IF nOpcx==4 
  IF SZI->ZI_STATUS="A" 
    nOpca := AxAltera(cAlias,nReg,nOpcX)
    nSaldo:=SZI->ZI_QTD    
    // tratamento para controle de processo
    // 1 LOCALIZA POSSIVEL REGISTRO
    DBSELECTAREA("SZK")
    dbSetOrder(4)
    IF LEN(RTRIM(SZI->ZI_ITEM))>2 
      MsSeek(xfilial("SZK")+"OC"+SZI->ZI_COMPRA+SUBSTRING(SZI->ZI_ITEM,2,3))
      nFiltro:=1
    ELSE
      MsSeek(xfilial("SZK")+"OS"+SZI->ZI_COMPRA+RTRIM(SZI->ZI_ITEM))
      nFiltro:=2
    ENDIF  
    DO WHILE (!EOF() .AND. SZI->ZI_COMPRA=SZK->ZK_OC .and. nSaldo>0)
      IF nFiltro=1
        IF SUBSTRING(SZI->ZI_ITEM,2,3)=SZK->ZK_ITEM
          dbselectarea("PC2")
          dbSetOrder(4)
          MsSeek(xfilial("PC2")+SZK->ZK_REF+SUBSTRING(SZK->ZK_REFITEM,1,2)+"000010")
          if PC2->PC2_QTDORI-PC2->PC2_QTD>0 .and. PC2->PC2_NUM=SZK->ZK_REF .AND. SUBSTRING(SZK->ZK_REFITEM,1,2)=PC2->PC2_ITEM .AND. PC2->PC2_SEQ="000010"
            cRegistro:=PC2->PC2_CTR
            if nSaldo>PC2->PC2_QTDORI
             	nProcesso:=PC2->PC2_QTDORI
                U_HCICTPR(SZK->ZK_REF,SUBSTRING(SZK->ZK_REFITEM,1,2),"000010","000012",nProcesso,"Aguardando Inspecao",SZI->ZI_RIDENT,SZI->ZI_CORRIDA,"RI:"+SZI->ZI_RIDENT+" Corrida:"+SZI->ZI_CORRIDA,cRegistro)
            else
                nProcesso:=	nSaldo
                U_HCICTPR(SZK->ZK_REF,SUBSTRING(SZK->ZK_REFITEM,1,2),"000010","000012",nProcesso,"Aguardando Inspecao",SZI->ZI_RIDENT,SZI->ZI_CORRIDA,"RI:"+SZI->ZI_RIDENT+" Corrida:"+SZI->ZI_CORRIDA,cRegistro) 
            endif
            nSaldo:=nSaldo-nProcesso
            // 1 BAIXA SOLICITACAO DE COMPRA E POR EM ORDEM DE COMPRA 
          endif  
          // fim de tratamento                     
        ENDIF
      ELSE
        IF TRIM(SZI->ZI_ITEM)=TRIM(SZK->ZK_ITEM)
          dbselectarea("PC2")
          dbSetOrder(4)
          MsSeek(xfilial("PC2")+SZK->ZK_REF+SUBSTRING(SZK->ZK_REFITEM,1,2)+"000010")
          if PC2->PC2_QTDORI-PC2->PC2_QTD>0 .and. PC2->PC2_NUM=SZK->ZK_REF .AND. SUBSTRING(SZK->ZK_REFITEM,1,2)=PC2->PC2_ITEM .AND. PC2->PC2_SEQ="000010"
            cRegistro:=PC2->PC2_CTR
            if nSaldo>PC2->PC2_QTDORI
             	nProcesso:=PC2->PC2_QTDORI
                U_HCICTPR(SZK->ZK_REF,SUBSTRING(SZK->ZK_REFITEM,1,2),"000010","000012",nProcesso,"Aguardando Inspecao",SZI->ZI_RIDENT,SZI->ZI_CORRIDA,"RI:"+SZI->ZI_RIDENT+" Corrida:"+SZI->ZI_CORRIDA,cRegistro)
            else
                nProcesso:=	nSaldo
                U_HCICTPR(SZK->ZK_REF,SUBSTRING(SZK->ZK_REFITEM,1,2),"000010","000012",nProcesso,"Aguardando Inspecao",SZI->ZI_RIDENT,SZI->ZI_CORRIDA,"RI:"+SZI->ZI_RIDENT+" Corrida:"+SZI->ZI_CORRIDA,cRegistro) 
            endif
            nSaldo:=nSaldo-nProcesso
            // 1 BAIXA SOLICITACAO DE COMPRA E POR EM ORDEM DE COMPRA 
          endif  
          // fim de tratamento                     
        ENDIF
      ENDIF
      DBSKIP()
    ENDDO
    dbSelectArea(cAlias)
  ELSE
    Aviso("Inconcistencia","A situacao do Registro Nao Permite Classificacao",{"Ok"},,"Atencao:")
    RETURN
  ENDIF
endif

// Opcao 5 - Cria Sequencia de H (RI)
IF nOpcX==3
 	
    @ 000,000 To 220,400 Dialog Odlg1 Title OemToAnsi("Criacao de Sequencia de RI")
    @ 003,008 To 110,200 Title OemToAnsi("Faixa de Criacao")
   
    @ 015,015 Say OemToAnsi("Matriz:")  OF Odlgl PIXEL
    @ 015,045 msget cBase  SIZE 20,10  OF OdlgL PIXEL
    @ 028,015 Say OemToAnsi("Ano:") OF Odlgl PIXEL
    @ 028,045 msget cAno  SIZE 40,10  OF OdlgL PIXEL 
    @ 041,015 Say OemToAnsi("Faixa Inicio:") OF Odlgl PIXEL
    @ 041,045 msget nInicio PICTURE("@E 999999") SIZE 40,10  OF OdlgL PIXEL 
    @ 054,015 Say OemToAnsi("Faixa Fim:") OF Odlgl PIXEL
    @ 054,045 msget nFim PICTURE("@E 999999") SIZE 40,10  OF OdlgL PIXEL    
    @ 090,030 BMPBUTTON TYPE 1 ACTION Processa({|| OkProc3(cBase,cAno,nInicio,nFim,odlg1)},cTitulo,"Criando Sequencia, aguarde...")
    @ 090,060 BMPBUTTON TYPE 2 ACTION Finaliza(odlg1)

    Activate Dialog Odlg1 CENTER
  
ENDIF
IF nOpcX==5
   If MsgYesNo("Deseja Eliminar Classificacao Existente?")
     IF SZI->ZI_STATUS="C" .OR. SZI->ZI_STATUS="N" 
       dbselectarea("PC2")
       dbSetOrder(9)
       if MsSeek(xfilial("PC2")+"RI:"+SZI->ZI_RIDENT+" Corrida:"+SZI->ZI_CORRIDA)
         IF U_HCIPDPR(PC2->PC2_NUM,PC2->PC2_ITEM,PC2->PC2_CTR)=.T.  // PEDIDO - ITEM - CONTROLE
           U_HCIEXPR(PC2->PC2_NUM,PC2->PC2_ITEM,PC2->PC2_CTR) 
         ELSE
           lOkOP:=.F.
         ENDIF  
       ENDIF
       IF LOKOP
         If MsgYesNo("Deseja notificar as areas envolvidas sobre esta acao?")
           U_HCTE003(SZI->ZI_COMPRA,SZI->ZI_ITEM,SZI->ZI_COD,SZI->ZI_DESCRI,SZI->ZI_QTD,SZI->ZI_FORNECE,SZI->ZI_LOJA,SZI->ZI_NREDUZ,SZI->ZI_RIDENT,SZI->ZI_CORRIDA,SZI->ZI_ALMOX,"A")
         endif 
         RecLock("SZI",.F.)
         dbDelete()
         MsUnlock()
         RecLock("SZI",.T.)
         SZI->ZI_FILIAL :=xfilial("SZI") 
         SZI->ZI_STATUS :="A"                        	// Status Inicial do RI 
         SZI->ZI_RI     :=RTRIM(cRI)                	// Sequencia RI
         SZI->ZI_DTA    :=DATE()
         SZI->ZI_USUA   :=Substr(cUsuario,7,15)
         MsUnLock()
         // tratamento para controle de processo
         // fim de tratamento       
         Aviso("Resultado da Acao","Registro com Classificacao Cancelada",{"Ok"},,"Atencao:") 
       ELSE
         Aviso("Inconcistencia","A situacao do Registro Nao Permite Extorno da Classificacao",{"Ok"},,"Atencao:")
       ENDIF
     ELSE
       Aviso("Inconcistencia","A situacao do Registro Nao Permite Extorno da Classificacao",{"Ok"},,"Atencao:")
       RETURN
     ENDIF
   endif
endif

// Registrar Inspecao
IF nOpcx==6 
  IF SZI->ZI_STATUS="A" .OR. SZI->ZI_STATUS="I" .OR. SZI->ZI_STATUS="N"
    Aviso("Inconcistencia","A situacao do Registro Nao Permite Registro de Inspecao",{"Ok"},,"Atencao:")
    RETURN
  else  
    if MsgYesNo("O Produto Esta Conforme?")
      //CONTROLE DE PROCESSO
      dbselectarea("PC2")
      dbSetOrder(9)
      if MsSeek(xfilial("PC2")+"RI:"+SZI->ZI_RIDENT+" Corrida:"+SZI->ZI_CORRIDA)
         cPedido:=PC2->PC2_NUM
         cItem	:=PC2->PC2_ITEM
         dbSetOrder(4)
         MsSeek(xfilial("PC2")+cPedido+cItem+"000012")
         if PC2->PC2_QTDORI-PC2->PC2_QTD>0 .and. PC2->PC2_NUM=cPedido .AND. cItem=PC2->PC2_ITEM .AND. PC2->PC2_SEQ="000012"
           cRegistro:=PC2->PC2_CTR
           U_HCICTPR(cPedido,cItem,"000012","000013",PC2->PC2_QTDORI,"Aguardando Analise Docs",PC2->PC2_RI,PC2->PC2_CORRIDA,"Inspecao OK - RI:"+SZI->ZI_RIDENT+" Corrida:"+SZI->ZI_CORRIDA,cRegistro)
         endif  
      endif      
      // FIM DA ROTINA
      DBSELECTAREA("SZI")
      RecLock("SZI",.F.)
      IF SZI->ZI_STATUS="R" .OR. SZI->ZI_STATUS="B"  
      ELSE
        SZI->ZI_STATUS :="I" 
      ENDIF
      SZI->ZI_DTI    :=DATE()
      SZI->ZI_USUI   :=Substr(cUsuario,7,15)
      MsUnLock()   
      Aviso("Resultado da Acao","Registro de Inspecao Efetuado",{"Ok"},,"Atencao:") 
    else
      dbselectarea("PC2")
      dbSetOrder(9)
      if MsSeek(xfilial("PC2")+"RI:"+SZI->ZI_RIDENT+" Corrida:"+SZI->ZI_CORRIDA)
         cPedido:=PC2->PC2_NUM
         cItem	:=PC2->PC2_ITEM
         dbSetOrder(4)                                              
         MsSeek(xfilial("PC2")+cPedido+cItem+"000012")
         if PC2->PC2_QTDORI-PC2->PC2_QTD>0 .and. PC2->PC2_NUM=cPedido .AND. cItem=PC2->PC2_ITEM .AND. PC2->PC2_SEQ="000012"
           cRegistro:=PC2->PC2_CTR
           U_HCICTPR(cPedido,cItem,"000012","000021",PC2->PC2_QTDORI,"NC Detectada",PC2->PC2_RI,PC2->PC2_CORRIDA,"Inspecao NC - RI:"+SZI->ZI_RIDENT+" Corrida:"+SZI->ZI_CORRIDA,cRegistro)
         endif  
      endif      
      // FIM DA ROTINA
      DBSELECTAREA("SZI")
      RecLock("SZI",.F.)
      IF SZI->ZI_STATUS="R" .OR. SZI->ZI_STATUS="B"  
      ELSE
        SZI->ZI_STATUS :="N" 
      ENDIF 
      SZI->ZI_DTN    :=DATE()
      SZI->ZI_USUN   :=Substr(cUsuario,7,15)
      MsUnLock()
      Aviso("Resultado da Acao","Registro de Inspecao Efetuado",{"Ok"},,"Atencao:") 
    endif
  ENDIF
endif
IF nOpcx==7 
  // A=A Classificar;C=Classificado;I=Inspecionado;R=Recebido;D=Disponivel;B=Baixado;N=Nao Conforme        
  IF SZI->ZI_STATUS="A" .OR. SZI->ZI_STATUS="C" .OR. SZI->ZI_STATUS="R" .OR. SZI->ZI_STATUS="D" .OR. SZI->ZI_STATUS="B"    
    Aviso("Inconcistencia","A situacao do Registro Nao Permite o Cancelamento da Inspecao",{"Ok"},,"Atencao:")
    RETURN
  else  
     // CONTROLE DE PROCESSO
    dbselectarea("PC2")
    dbSetOrder(9)
    nFiltro:=0
    if MsSeek(xfilial("PC2")+"Inspecao OK - RI:"+SZI->ZI_RIDENT+" Corrida:"+SZI->ZI_CORRIDA)
         IF U_HCIPDPR(PC2->PC2_NUM,PC2->PC2_ITEM,PC2->PC2_CTR)=.T.  // PEDIDO - ITEM - CONTROLE
           U_HCIEXPR(PC2->PC2_NUM,PC2->PC2_ITEM,PC2->PC2_CTR) 
           nFiltro:=1
         endif    
    ENDIF
    if MsSeek(xfilial("PC2")+"Inspecao NC - RI:"+SZI->ZI_RIDENT+" Corrida:"+SZI->ZI_CORRIDA)
         IF U_HCIPDPR(PC2->PC2_NUM,PC2->PC2_ITEM,PC2->PC2_CTR)=.T.  // PEDIDO - ITEM - CONTROLE
           U_HCIEXPR(PC2->PC2_NUM,PC2->PC2_ITEM,PC2->PC2_CTR) 
           nFiltro:=2
         endif    
    ENDIF
    // FIM DA ROTINA
    IF nFiltro<>3
      RecLock("SZI",.F.)
      SZI->ZI_STATUS :="C" 
      SZI->ZI_DTI    :=CTOD("  /  /  ")
      SZI->ZI_USUI   :=""   
      SZI->ZI_DTN    :=CTOD("  /  /  ")
      SZI->ZI_USUN   :="" 
      MsUnLock() 
      Aviso("Resultado da Acao","Registro de Inspecao Cancelado",{"Ok"},,"Atencao:") 
    ELSE
      Aviso("Inconcistencia","A situacao do Registro Nao Permite o Cancelamento da Inspecao",{"Ok"},,"Atencao:")
      RETURN
    ENDIF
  ENDIF
endif
IF nOpcX<>5
  If MsgYesNo("Deseja notificar as areas envolvidas sobre esta acao?")
    U_HCTE003(SZI->ZI_COMPRA,SZI->ZI_ITEM,SZI->ZI_COD,SZI->ZI_DESCRI,SZI->ZI_QTD,SZI->ZI_FORNECE,SZI->ZI_LOJA,SZI->ZI_NREDUZ,SZI->ZI_RIDENT,SZI->ZI_CORRIDA,SZI->ZI_ALMOX,SZI->ZI_STATUS)
  endif 
ENDIF
Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณOkProc    บAutor  ณRobson Bueno        บ Data ณ 18/04/2007  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณProcessamento no banco de dados da acao solicitada e confir บฑฑ
ฑฑบ          ณmada                                                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณHCI                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function OkProc3(cBase,cAno,nInicio,nFim,odlg1)
Local cAliasSZI := GetArea()
local cRI1
Local cRi2
Local cRi3
Local cRiFim
Local nTamanho
ProcRegua(nFim-nInicio)
// Montando Ri Conforme parametros Informados
dbSelectArea("SZI")
DbSetOrder(1)
FOR X:=nInicio to nFim
  cRi3:=""
  cRi1:=cBase
  cRi2:=substring(LTRIM(cAno),3,2)
  nTamanho:=len(LTRIM(str(x)))
  FOR Y:=5 to nTamanho step -1
    cRi3:=cRi3+"0"
  Next  
  cRi3:=cRi3+Ltrim(str(x))
  cRiFim:=cRi1+cRi2+"-"+cRi3
  if dbSeek(xFilial("SZI")+RTRIM(cRiFim)) 
     Aviso("Observacao","Chave Duplicada no Registro--->"+cRiFim,{"Ok"},,"Atencao:")
     IncProc("Anulado Registro->"+cRiFim)
  else
     RecLock("SZI",.T.)
     SZI->ZI_FILIAL :=xfilial("SZI") 
     SZI->ZI_STATUS :="A"                        	// Status Inicial do RI 
     SZI->ZI_RI     :=RTRIM(cRiFim)                	// Sequencia RI
     SZI->ZI_DTA    :=DATE()
     SZI->ZI_USUA   :=Substr(cUsuario,7,15)
     MsUnLock()
    IncProc("Incluindo Registro->"+cRiFim)
  endif   
next
/*
IF SCP->CP_STATSA=="B"
  RecLock("SCP",.F.)
  SCP->CP_STATSA:=""
  SCP->CP_XAPROVA:=Substr(cUsuario,7,15)
  MsUnLock()
ELSE
  RecLock("SCP",.F.)
  SCP->CP_STATSA:="B"
  SCP->CP_XAPROVA:=""
  MsUnLock()
ENDIF
*/
Close(Odlg1)
RestArea(cAliasSZI)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFinaliza  บAutor  ณRobson Bueno        บ Data ณ 18/04/2007  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFinalizacao do Objeto                                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณHCI                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Finaliza(Odlg1)

Aviso("Observacao","A็ใo Cancelada Pelo Usuario !!!",{"Ok"},,"Atencao:")

Close(Odlg1)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLEGENDA   บAutor  ณRobson Bueno        บ Data ณ 18/04/2007  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณLEGENDA DA MBROWSE                                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณHCI                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/



                 
User Function RST05LG()


BrwLegenda(cCadastro,"Situacoes",{	{"BR_PRETO",	"(RI) Lote Livre"},;
   									{"BR_BRANCO",	"(RI) Lote Classificado"},;
									{"BR_AMARELO",	"(RI) Lote Inspecionado"},;
									{"BR_LARANJA",	"(RI) Lote Recebido"},;
									{"BR_VERDE",	"(RI) Lote Disponivel"},;
									{"BR_VERMELHO",	"(RI) Lote Sem Saldo"},;
                                  	{"BR_CINZA",	"(RI) Lote Nao Conforme"}})

Return (.T.)


                 
