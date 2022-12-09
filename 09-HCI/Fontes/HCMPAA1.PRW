#INCLUDE "Protheus.ch" 
#INCLUDE "Rwmake.CH"
#INCLUDE "TopConn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษอออออออออออออัออออออออออัออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออปฑฑ
ฑฑบ Programa    ณHCMPAA1   ณ Programa para Recalculo de Custo CMV                         บฑฑ
ฑฑบ             ณ          ณ                                                              บฑฑ
ฑฑฬอออออออออออออุออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Solicitante ณ 20.04.07 ณ Robson                                                       บฑฑ
ฑฑฬอออออออออออออุออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Autor       ณ 20.04.07 ณ Robson Bueno                                                 บฑฑ
ฑฑฬอออออออออออออุออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Produ็ใo    ณ ??.??.?? ณ Ignorado                                                     บฑฑ
ฑฑฬอออออออออออออุออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Parโmetros  ณ Nil                                                                     บฑฑ
ฑฑฬอออออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Retorno     ณ Nil                                                                     บฑฑ
ฑฑฬอออออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Observa็๕es ณ                                                                         บฑฑ
ฑฑบ             ณ                                                                         บฑฑ
ฑฑบ             ณ                                                                         บฑฑ
ฑฑบ             ณ                                                                         บฑฑ
ฑฑบ             ณ                                                                         บฑฑ
ฑฑฬอออออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Altera็๕es  ณ ??.??.?? - Nome - Descri็ใo                                             บฑฑ
ฑฑศอออออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function HCMPAA1()


Local aAreaAtu	:= GetArea()												// Salva a area atual
Local lRet		:= .T.
LOCAL cDesComp :=Space(255)
LOCAL dInicio  :=ctod("  /  /  ")
LOCAL dFim     :=ctod("  /  /  ")
Local oDlgL
Local cTitulo :="Reprocessa CMV"
@ 000,000 To 180,400 Dialog Odlg1 Title OemToAnsi("Rotina Refaz Tabela CMV")
@ 003,008 To 85,200 Title OemToAnsi("Digite o Periodo de Recalculo?")

@ 015,015 Say OemToAnsi("Inicio:") OF Odlgl PIXEL
@ 015,045 msget dInicio  SIZE 60,10 OF OdlgL PIXEL
@ 035,015 Say OemToAnsi("Fim:") OF Odlgl PIXEL
@ 035,045 msget dFim  SIZE 60,10 OF OdlgL PIXEL
@ 055,030 BMPBUTTON TYPE 1 ACTION 	Processa({|| OkProc(odlg1,dInicio,dFim)},cTitulo,"Atualizando dados, aguarde...")
@ 055,060 BMPBUTTON TYPE 2 ACTION Finaliza(odlg1)

Activate Dialog Odlg1 CENTER
 
   
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
Static Function OkProc(odlg1,dInicio,dFim)
Local aArea     := GetArea()
Local nRegistros := 0
Local cQry
lOCAL cQry2
LOCAL nValbruto:=0
Local nValIcm:=0
Local nValIpi:=0
Local nValPis:=0
Local nValCof:=0
Local nValCom:=0
Local nBaseCom:=0
Local nBaseItem:=0
lOCAL nPercom:=0
lOCAL cPedido
Local cVendedor
Local nVlCusto
Local nEntradas  
Local cCodigo
Local cQuerySD1 
LOCAL cQuerySD3 
lOCAL cQuerySB2
Local cOp
Local nEstoque
Local nEstoqueOri
Local nSaldo

If MsgYesNo("Esta rotina reprocessa os valores de Custo CMV partindo de entradas efetuadas no periodo selecionado. Deseja realmente processar esta rotina?")
    //deletando dados atuais das comissoes no periodo estipulado
    dbSelectArea("PAA")
	dbSetOrder(1)
    ProcRegua(RecCount())
	While !Eof() 
        // BUSCANDO PRODUTO NOS MOVIMENTOS DE ENTRADA
        DbSelectArea("SF4")
		dbSetOrder(1)
		// VERIFICA SE O CAMPO F4_RAPIDA TEM NO BANCO DE DADOS ATUAL
		cCodigo:=PAA->PAA_COD
		If (FieldPos("F4_RAPIDA") > 0 )                    
  			aHistent:={}
  			cQuerySD1 := "SELECT SD1.D1_COD,SD1.D1_FORNECE,SD1.D1_LOJA,SD1.D1_PEDIDO,SD1.D1_ITEMPC,SD1.D1_QUANT,SD1.D1_CUSTO,SD1.D1_TOTAL,SD1.D1_ICMSRET," 
  			cQuerySD1 += "SD1.D1_DOC,SD1.D1_ITEM,SD1.D1_VALIPI,SD1.D1_VALICM,SD1.D1_VALIMP5,SD1.D1_VALIMP6,SD1.D1_DTDIGIT,SD1.D1_TES,SD1.D1_EMISSAO,SF4.F4_RAPIDA,SF4.F4_CODIGO " 
  			cQuerySD1 += "FROM " + RetSqlName("SD1")+ " SD1 "+" INNER JOIN "+RetSqlName("SF4")+" SF4 ON SF4.F4_CODIGO = SD1.D1_TES WHERE "
  			cQuerySD1 += "SD1.D1_FILIAL = '"+xFilial("SD1")+"' AND "
  			cQuerySD1 += "SD1.D1_COD = '"+cCodigo+"' AND "
  			cQuerySD1 += "SD1.D1_EMISSAO >= '"+DTOS(dInicio)+"' AND "
        	cQuerySD1 += "SD1.D1_EMISSAO <= '"+DTOS(dFim)+"' AND "                                  
  			cQuerySD1 += "SF4.F4_RAPIDA ='S' AND " 
  			cQuerySD1 += "SD1.D_E_L_E_T_=' ' ORDER BY SD1.D1_COD ASC"
  			//cQuery := ChangeQuery(cQuery)
		ELSE
  	  		cQuerySD1 := "SELECT SD1.D1_COD,SD1.D1_FORNECE,SD1.D1_LOJA,SD1.D1_PEDIDO,SD1.D1_ITEMPC,SD1.D1_QUANT,SD1.D1_CUSTO,SD1.D1_TOTAL,SD1.D1_ICMSRET," 
        	cQuerySD1 += "SD1.D1_DOC,SD1.D1_ITEM,SD1.D1_VALIPI,SD1.D1_VALICM,SD1.D1_VALIMP5,SD1.D1_VALIMP6,SD1.D1_DTDIGIT,SD1.D1_TES,SD1.D1_EMISSAO " 
        	cQuerySD1 += "FROM " + RetSqlName("SD1")+ " SD1 WHERE "
        	cQuerySD1 += "SD1.D1_FILIAL = '"+xFilial("SD1")+"' AND "
        	cQuerySD1 += "SD1.D1_COD = '"+cCodigo+"' AND "              
        	cQuerySD1 += "SD1.D1_EMISSAO >= '"+DTOS(dInicio)+"' AND "
        	cQuerySD1 += "SD1.D1_EMISSAO <= '"+DTOS(dFim)+"' AND "
        	cQuerySD1 += "SD1.D_E_L_E_T_=' ' ORDER BY SD1.D1_COD ASC"
  			//cQuery := ChangeQuery(cQuery)
		ENDIF
        //cQuery := ChangeQuery(cQuery)
        If ( Select ("SD1") <> 0 )
        	dbSelectArea ("SD1")
            dbCloseArea ()
        Endif
        dBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuerySD1),"SD1",.T.,.T.)
        dbSelectArea("SD1")
		nEntradas:=0
		nVlCusto:=0
		While (!Eof() .And. SD1->D1_COD == cCodigo )
               IF SD1->D1_TES $ "101/10B/102/156/106/109/172/174" //"101/102/156/108/109"
                 IF SD1->D1_TES = "101"
                   nVlCusto:=nVlCusto+SD1->D1_TOTAL-SD1->D1_VALICM-SD1->D1_VALIMP5-SD1->D1_VALIMP6
         		   nEntradas:= nEntradas+SD1->D1_QUANT
                 ELSE
                   IF SD1->D1_TES = "106"
                      nVlCusto:=nVlCusto+SD1->D1_TOTAL+SD1->D1_VALIPI+SD1->D1_ICMSRET-SD1->D1_VALIMP5-SD1->D1_VALIMP6
                      nEntradas:= nEntradas+SD1->D1_QUANT
                   ELSE
                     IF SD1->D1_TES = "172"
                       IF CTOD(SUBSTRING(SD1->D1_EMISSAO,7,2)+'/'+SUBSTRING(SD1->D1_EMISSAO,5,2)+'/'+SUBSTRING(SD1->D1_EMISSAO,3,2))>=CTOD("20/08/13") 
                          nVlCusto:=nVlCusto+SD1->D1_TOTAL-SD1->D1_VALICM-SD1->D1_VALIMP5-SD1->D1_VALIMP6
                          nEntradas:= nEntradas+SD1->D1_QUANT
                       ELSE
                          nVlCusto:=nVlCusto+SD1->D1_TOTAL-SD1->D1_VALICM-(SD1->D1_TOTAL*9.25/100)
                          nEntradas:= nEntradas+SD1->D1_QUANT
                       ENDIF
                     ELSE
                       nVlCusto:=nVlCusto+SD1->D1_TOTAL+SD1->D1_VALIPI-SD1->D1_VALICM-SD1->D1_VALIMP5-SD1->D1_VALIMP6
         			   nEntradas:= nEntradas+SD1->D1_QUANT
                     ENDIF
                   ENDIF
                 ENDIF
               else
                 IF SD1->D1_TES $ "301/305/310/312/311/315/317/314/316/318"
                   nVlCusto:=nVlCusto+SD1->D1_TOTAL
         		   nEntradas:= nEntradas+SD1->D1_QUANT
                 else
                   nVlCusto:=nVlCusto+SD1->D1_TOTAL-SD1->D1_VALICM-SD1->D1_VALIMP5-SD1->D1_VALIMP6
         	       nEntradas:= nEntradas+SD1->D1_QUANT
                 endif
               endif
               dbSkip()
        EndDo
		// GRAVANDO NOVOS PARAMETROS DE CUSTO NA TABELA CMV
		dbSelectArea("PAA")			
		IF nEntradas>0 
		  RecLock("PAA",.F.)
     	    PAA->PAA_SALDO	:= 1
     	    PAA->PAA_UNIT	:=nVlCusto/nEntradas
     	    PAA->PAA_TOTAL	:=nVlCusto/nEntradas
     	    PAA->PAA_DATA	:=DATE()
     	  MsUnLock() 	      
		  IncProc("Produto:"+cCodigo+ " Atualizado Custo p/ R$" +transform(PAA->PAA_UNIT,"@e 999,999.99"))
		else
	      IncProc("Produto:"+cCodigo+ " Nao Atualizado")
		endif		
		dbSkip()
	EndDo	
ENDIF 
		
If MsgYesNo("Esta rotina inclui produtos que entraram no periodo selecionado que eventualmente nao estejam na tabela CMV. Deseja realmente processar esta rotina?")			
        // BUSCANDO PRODUTO NOS MOVIMENTOS DE ENTRADA
        DbSelectArea("SF4")
		dbSetOrder(1)
        // BUSCANDO PRODUTO NOS MOVIMENTOS DE ENTRADA
        cQuerySD1 :=""
       	If (FieldPos("F4_RAPIDA") > 0 )                    
  			aHistent:={}
  			cQuerySD1 := "SELECT SD1.D1_COD,SD1.D1_FORNECE,SD1.D1_LOJA,SD1.D1_PEDIDO,SD1.D1_ITEMPC,SD1.D1_QUANT,SD1.D1_CUSTO,SD1.D1_TOTAL,SD1.D1_ICMSRET," 
  			cQuerySD1 += "SD1.D1_DOC,SD1.D1_ITEM,SD1.D1_VALIPI,SD1.D1_VALICM,SD1.D1_VALIMP5,SD1.D1_VALIMP6,SD1.D1_DTDIGIT,SD1.D1_TES,SD1.D1_EMISSAO,SF4.F4_RAPIDA,SF4.F4_CODIGO " 
  			cQuerySD1 += "FROM " + RetSqlName("SD1")+ " SD1 "+" INNER JOIN "+RetSqlName("SF4")+" SF4 ON SF4.F4_CODIGO = SD1.D1_TES WHERE "
  			cQuerySD1 += "SD1.D1_FILIAL = '"+xFilial("SD1")+"' AND "
  			cQuerySD1 += "SD1.D1_EMISSAO >= '"+DTOS(dInicio)+"' AND "
        	cQuerySD1 += "SD1.D1_EMISSAO <= '"+DTOS(dFim)+"' AND "                                  
  			cQuerySD1 += "SF4.F4_RAPIDA ='S' AND " 
  			cQuerySD1 += "SD1.D_E_L_E_T_=' ' ORDER BY SD1.D1_COD ASC"
  			//cQuery := ChangeQuery(cQuery)
		ELSE
  	  		cQuerySD1 := "SELECT SD1.D1_COD,SD1.D1_FORNECE,SD1.D1_LOJA,SD1.D1_PEDIDO,SD1.D1_ITEMPC,SD1.D1_QUANT,SD1.D1_CUSTO,SD1.D1_TOTAL,SD1.D1_ICMSRET," 
        	cQuerySD1 += "SD1.D1_DOC,SD1.D1_ITEM,SD1.D1_VALIPI,SD1.D1_VALICM,SD1.D1_VALIMP5,SD1.D1_VALIMP6,SD1.D1_DTDIGIT,SD1.D1_TES,SD1.D1_EMISSAO " 
        	cQuerySD1 += "FROM " + RetSqlName("SD1")+ " SD1 WHERE "
        	cQuerySD1 += "SD1.D1_FILIAL = '"+xFilial("SD1")+"' AND "
         	cQuerySD1 += "SD1.D1_EMISSAO >= '"+DTOS(dInicio)+"' AND "
        	cQuerySD1 += "SD1.D1_EMISSAO <= '"+DTOS(dFim)+"' AND "
        	cQuerySD1 += "SD1.D_E_L_E_T_=' ' ORDER BY SD1.D1_COD ASC"
  			//cQuery := ChangeQuery(cQuery)
		ENDIF
        //cQuery := ChangeQuery(cQuery)
        /*
        cQuerySD1 :=""
        cQuerySD1 := "SELECT SD1.D1_COD,SD1.D1_FORNECE,SD1.D1_LOJA,SD1.D1_PEDIDO,SD1.D1_ITEMPC,SD1.D1_QUANT,SD1.D1_CUSTO,SD1.D1_TOTAL,SD1.D1_ICMSRET," 
        cQuerySD1 += "SD1.D1_DOC,SD1.D1_ITEM,SD1.D1_VALIPI,SD1.D1_VALICM,SD1.D1_VALIMP5,SD1.D1_VALIMP6,SD1.D1_DTDIGIT,SD1.D1_TES,SD1.D1_EMISSAO " 
        cQuerySD1 += "FROM " + RetSqlName("SD1")+ " SD1 WHERE "
        cQuerySD1 += "SD1.D1_FILIAL = '"+xFilial("SD1")+"' AND "
        cQuerySD1 += "SD1.D1_EMISSAO >= '"+DTOS(dInicio)+"' AND "
        cQuerySD1 += "SD1.D1_EMISSAO <= '"+DTOS(dFim)+"' AND "
        cQuerySD1 += "SD1.D_E_L_E_T_=' ' ORDER BY SD1.D1_COD ASC"  
        */
        //cQuery := ChangeQuery(cQuery)
        If ( Select ("SD1") <> 0 )
        	dbSelectArea ("SD1")
            dbCloseArea ()
        Endif
        dBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuerySD1),"SD1",.T.,.T.)
        dbSelectArea("SD1")
		While ( !Eof() )
	     	cCodigo:=SD1->D1_COD
		    nEntradas:=0
		    nVlCusto:=0
		    dbSelectArea("PAA")
	        dbSetOrder(1)
	        If MsSeek(xFilial("PAA")+cCodigo)
		       dbSelectArea("SD1")
		       While (SD1->D1_COD == cCodigo )
		         dbSkip()
		       EndDo  
		    else
		       dbSelectArea("SD1")
		       While (SD1->D1_COD == cCodigo )
               IF SD1->D1_TES $ "101/10B/102/156/106/109/172/174" //"101/102/156/108/109"
                 IF SD1->D1_TES = "101"
                    nVlCusto:=nVlCusto+SD1->D1_TOTAL-SD1->D1_VALICM-SD1->D1_VALIMP5-SD1->D1_VALIMP6
         			nEntradas:= nEntradas+SD1->D1_QUANT
                 ELSE
                    IF SD1->D1_TES = "106"
                      nVlCusto:=nVlCusto+SD1->D1_TOTAL+SD1->D1_VALIPI+SD1->D1_ICMSRET-SD1->D1_VALIMP5-SD1->D1_VALIMP6
                      nEntradas:= nEntradas+SD1->D1_QUANT
                    ELSE
                      IF SD1->D1_TES = "172"
                       IF CTOD(SUBSTRING(SD1->D1_EMISSAO,7,2)+'/'+SUBSTRING(SD1->D1_EMISSAO,5,2)+'/'+SUBSTRING(SD1->D1_EMISSAO,3,2))>=CTOD("20/08/13") 
                         nVlCusto:=nVlCusto+SD1->D1_TOTAL-SD1->D1_VALICM-SD1->D1_VALIMP5-SD1->D1_VALIMP6
                         nEntradas:= nEntradas+SD1->D1_QUANT
                       ELSE
                         nVlCusto:=nVlCusto+SD1->D1_TOTAL-SD1->D1_VALICM-(SD1->D1_TOTAL*9.25/100)
                         nEntradas:= nEntradas+SD1->D1_QUANT
                       ENDIF
                     ELSE
                       nVlCusto:=nVlCusto+SD1->D1_TOTAL+SD1->D1_VALIPI-SD1->D1_VALICM-SD1->D1_VALIMP5-SD1->D1_VALIMP6
         			   nEntradas:= nEntradas+SD1->D1_QUANT
                     ENDIF
                    ENDIF
                 ENDIF
               else
                 IF SD1->D1_TES $ "301/305/310/312/311/315/317/314/316/318"
                   nVlCusto:=nVlCusto+SD1->D1_TOTAL
         	       nEntradas:= nEntradas+SD1->D1_QUANT
                 else
                   If (FieldPos("F4_RAPIDA") > 0 )  
                     nVlCusto:=nVlCusto+SD1->D1_TOTAL-SD1->D1_VALICM-SD1->D1_VALIMP5-SD1->D1_VALIMP6
         		     nEntradas:= nEntradas+SD1->D1_QUANT
                   ENDIF
                 endif
               endif 
               dbSkip()
               EndDo
            endif  
		    // GRAVANDO NOVOS PARAMETROS DE CUSTO NA TABELA CMV
		    dbSelectArea("PAA")			
		    IF nEntradas>0 
		       RecLock("PAA",.t.)
     	       PAA->PAA_FILIAL	:=xFilial("PAA")
     	       PAA->PAA_COD		:=cCodigo
     	       PAA->PAA_DESCRI  :=Posicione("SB1",1,xFilial("SB1")+cCodigo,"B1_DESC") 
     	       PAA->PAA_SALDO	:= 1
     	       PAA->PAA_UNIT	:=nVlCusto/nEntradas
     	       PAA->PAA_TOTAL	:=nVlCusto/nEntradas
     	       PAA->PAA_DATA	:=DATE()
     	       MsUnLock() 	      
		    else
	        endif
	        dbSelectArea("SD1")		
		EndDo	
endif 

If MsgYesNo("Esta rotina <INCLUI> produtos que entratam por produ็ใo efetuadas no periodo selecionado. Deseja realmente processar esta rotina?")
        // BUSCANDO PRODUTO NOS MOVIMENTOS DE ENTRADA
        cQuerySD3 :=""
        cQuerySD3 := "SELECT SD3.D3_COD,SD3.D3_EMISSAO,SD3.D3_QUANT,SD3.D3_OP,SD3.D3_CF " 
        cQuerySD3 += "FROM " + RetSqlName("SD3")+ " SD3 WHERE "
        cQuerySD3 += "SD3.D3_FILIAL = '"+xFilial("SD3")+"' AND "
        cQuerySD3 += "SD3.D3_EMISSAO >= '"+DTOS(dInicio)+"' AND "
        cQuerySD3 += "SD3.D3_EMISSAO <= '"+DTOS(dFim)+"' AND "
        cQuerySD3 += "SD3.D3_CF= 'PR0' AND "
        cQuerySD3 += "SD3.D_E_L_E_T_=' ' ORDER BY SD3.D3_COD ASC"
        //cQuery := ChangeQuery(cQuery)
        If ( Select ("SD3") <> 0 )
        	dbSelectArea ("SD3")
            dbCloseArea ()
        Endif
        dBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuerySD3),"SD3",.T.,.T.)
        dbSelectArea("SD3")
		nEntradas:=0
		nVlCusto:=0
		While ( !Eof() )
	     	cCodigo:=SD3->D3_COD
	     	nEntradas:=0
		    nVlCusto:=0
		    dbSelectArea("PAA")
	        dbSetOrder(1)
	        If MsSeek(xFilial("PAA")+cCodigo)
		       dbSelectArea("SD3")
		       While (SD3->D3_COD == cCodigo )
		         dbSkip()
		       EndDo  
		    else
		       dbSelectArea("SD3")
		       While (SD3->D3_COD == cCodigo )
                   nEntradas:=nEntradas+SD3->D3_QUANT
                   cOp	     :=SD3->D3_OP
                   cQuerySD1 :=""
                   cQuerySD1 := "SELECT SD1.D1_OP,SD1.D1_TOTAL FROM " + RetSqlName("SD1")+ " SD1 WHERE "
                   cQuerySD1 += "SD1.D1_FILIAL = '"+xFilial("SD1")+"' AND "
                   cQuerySD1 += "SD1.D1_OP = '"+cOp+"' AND "
                   cQuerySD1 += "SD1.D_E_L_E_T_=' '"
                   //cQuery := ChangeQuery(cQuery)
                   If ( Select ("SD1") <> 0 )
        	          dbSelectArea ("SD1")
                      dbCloseArea ()
                   Endif
                   dBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuerySD1),"SD1",.T.,.T.)
                   dbSelectArea("SD1")
		           While (!Eof() .and. trim(SD1->D1_OP) == trim(cOp))
                     nVlCusto:=nVlCusto+SD1->D1_TOTAL
                     dbSkip()
                   enddo
                   dbSelectArea("SD3")
                   dbSkip()
               EndDo    
		       // GRAVANDO NOVOS PARAMETROS DE CUSTO NA TABELA CMV
		       dbSelectArea("PAA")			
		       IF nEntradas>0 .AND. nVlCusto>0
		         RecLock("PAA",.t.)
     	         PAA->PAA_FILIAL	:=xFilial("PAA")
     	         PAA->PAA_COD		:=cCodigo
     	         PAA->PAA_DESCRI  :=Posicione("SB1",1,xFilial("SB1")+cCodigo,"B1_DESC") 
     	         PAA->PAA_SALDO	:= 1
     	         PAA->PAA_UNIT	:=nVlCusto/nEntradas
     	         PAA->PAA_TOTAL	:=nVlCusto/nEntradas
     	         PAA->PAA_DATA	:=DATE()
     	         MsUnLock() 	      
		      else
	          endif
	        endif
	        dbSelectArea("SD3")		
		EndDo	
endif  

If MsgYesNo("Esta rotina reprocessa os valores de Custo CMV DE TODOS OS PRODUTOS com base no estoque x entradas. Deseja realmente processar esta rotina?")
    //deletando dados atuais das comissoes no periodo estipulado
    dbSelectArea("PAA")
	dbSetOrder(1)
    ProcRegua(RecCount())
    dbGoTop()
	While !Eof() 
        // Produto da Pesquisa
        cCodigo:=PAA->PAA_COD
        nEstoque:=0
        nEstoqueOri:=0
        //extraindo saldo em estoque
        DbSelectArea("SB2")
        dbSetOrder(1)
        MsSeek(xfilial("SB2")+cCodigo)
        While ( !Eof() .And. SB2->B2_COD == cCodigo )
            nEstoque:=nEstoque+SB2->B2_QATU+SB2->B2_QNPT
	        dbSkip()
        EndDo
        nEstoqueOri:=nEstoque
        // Operacao quando Houver Estoque Disponivel
        if nEstoque>0
          // BUSCANDO PRODUTO NOS MOVIMENTOS DE ENTRADA
          DbSelectArea("SF4")
		  dbSetOrder(1)
          cQuerySD1 :=""
       	  If (FieldPos("F4_RAPIDA") > 0 )                    
  			aHistent:={}
  			cQuerySD1 := "SELECT SD1.D1_COD,SD1.D1_FORNECE,SD1.D1_LOJA,SD1.D1_PEDIDO,SD1.D1_ITEMPC,SD1.D1_QUANT,SD1.D1_CUSTO,SD1.D1_TOTAL,SD1.D1_ICMSRET," 
  			cQuerySD1 += "SD1.D1_DOC,SD1.D1_ITEM,SD1.D1_VALIPI,SD1.D1_VALICM,SD1.D1_VALIMP5,SD1.D1_VALIMP6,SD1.D1_DTDIGIT,SD1.D1_TES,SD1.D1_EMISSAO,SF4.F4_RAPIDA,SF4.F4_CODIGO " 
  			cQuerySD1 += "FROM " + RetSqlName("SD1")+ " SD1 "+" INNER JOIN "+RetSqlName("SF4")+" SF4 ON SF4.F4_CODIGO = SD1.D1_TES WHERE "
  			cQuerySD1 += "SD1.D1_FILIAL = '"+xFilial("SD1")+"' AND "
  			cQuerySD1 += "SD1.D1_COD = '"+cCodigo+"' AND " 
  			cQuerySD1 += "SF4.F4_RAPIDA ='S' AND " 
  			cQuerySD1 += "SD1.D_E_L_E_T_=' ' ORDER BY SD1.R_E_C_N_O_ DESC"
  			//cQuery := ChangeQuery(cQuery)
		  ELSE
  	  		cQuerySD1 := "SELECT SD1.D1_COD,SD1.D1_FORNECE,SD1.D1_LOJA,SD1.D1_PEDIDO,SD1.D1_ITEMPC,SD1.D1_QUANT,SD1.D1_CUSTO,SD1.D1_TOTAL,SD1.D1_ICMSRET," 
        	cQuerySD1 += "SD1.D1_DOC,SD1.D1_ITEM,SD1.D1_VALIPI,SD1.D1_VALICM,SD1.D1_VALIMP5,SD1.D1_VALIMP6,SD1.D1_DTDIGIT,SD1.D1_TES,SD1.D1_EMISSAO " 
        	cQuerySD1 += "FROM " + RetSqlName("SD1")+ " SD1 WHERE "  
        	cQuerySD1 += "SD1.D1_FILIAL = '"+xFilial("SD1")+"' AND "
        	cQuerySD1 += "SD1.D1_COD = '"+cCodigo+"' AND " 
          	cQuerySD1 += "SD1.D_E_L_E_T_=' ' ORDER BY SD1.R_E_C_N_O_ DESC"
  			//cQuery := ChangeQuery(cQuery)
		  ENDIF
          //cQuery := ChangeQuery(cQuery)
          /*
          // extraindo valores com base nas entradas
          cQuerySD1 := "SELECT SD1.D1_COD,SD1.D1_FORNECE,SD1.D1_LOJA,SD1.D1_PEDIDO,SD1.D1_ITEMPC,SD1.D1_QUANT,SD1.D1_CUSTO,SD1.D1_TOTAL,SD1.D1_ICMSRET," 
          cQuerySD1 += "SD1.D1_DOC,SD1.D1_ITEM,SD1.D1_VALIPI,SD1.D1_VALICM,SD1.D1_VALIMP5,SD1.D1_VALIMP6,SD1.D1_DTDIGIT,SD1.D1_TES,SD1.D1_EMISSAO " 
          cQuerySD1 += "FROM " + RetSqlName("SD1")+ " SD1 WHERE "
          cQuerySD1 += "SD1.D1_FILIAL = '"+xFilial("SD1")+"' AND "
          cQuerySD1 += "SD1.D1_COD = '"+cCodigo+"' AND "              
          cQuerySD1 += "SD1.D_E_L_E_T_=' ' ORDER BY SD1.R_E_C_N_O_ DESC"   
          */
          //cQuery := ChangeQuery(cQuery)
          If ( Select ("SD1") <> 0 )
         	dbSelectArea ("SD1")
            dbCloseArea ()
          Endif
          dBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuerySD1),"SD1",.T.,.T.)
          dbSelectArea("SD1")
		  nSaldo:=nEstoque
		  nVlCusto:=0
		  nEntradas:=0
		  While ( !Eof() .And. SD1->D1_COD == cCodigo .and. nSaldo>0 )
               IF SD1->D1_TES $ "101/10B/102/156/106/109/172/174"
                 IF SD1->D1_TES = "101"
                    if nSaldo<SD1->D1_QUANT
                      nVlCusto:=nVlCusto+(((SD1->D1_TOTAL-SD1->D1_VALICM-SD1->D1_VALIMP5-SD1->D1_VALIMP6)/SD1->D1_QUANT)*nSaldo)
         			else
             		  nVlCusto:=nVlCusto+SD1->D1_TOTAL-SD1->D1_VALICM-SD1->D1_VALIMP5-SD1->D1_VALIMP6
         			endif
         			nSaldo:= nSaldo-SD1->D1_QUANT
         			nEntradas:=nEntradas+1  
                 ELSE
                 	IF nSaldo<SD1->D1_QUANT 
                    	IF SD1->D1_TES = "106"
                      		nVlCusto:=nVlCusto+(((SD1->D1_TOTAL+SD1->D1_VALIPI+SD1->D1_ICMSRET-SD1->D1_VALIMP5-SD1->D1_VALIMP6)/SD1->D1_QUANT)*nSaldo)
                    	ELSE
                      		IF SD1->D1_TES = "172"
                       			IF CTOD(SUBSTRING(SD1->D1_EMISSAO,7,2)+'/'+SUBSTRING(SD1->D1_EMISSAO,5,2)+'/'+SUBSTRING(SD1->D1_EMISSAO,3,2))>=CTOD("20/08/13") 
                         			nVlCusto:=nVlCusto+(((SD1->D1_TOTAL-SD1->D1_VALICM-SD1->D1_VALIMP5-SD1->D1_VALIMP6)/SD1->D1_QUANT)*nSaldo)
                       			ELSE
                         			nVlCusto:=nVlCusto+(((SD1->D1_TOTAL-SD1->D1_VALICM-(SD1->D1_TOTAL*9.25/100))/SD1->D1_QUANT)*nSaldo)
                       			ENDIF
                     		ELSE
                       			nVlCusto:=nVlCusto+(((SD1->D1_TOTAL+SD1->D1_VALIPI-SD1->D1_VALICM-SD1->D1_VALIMP5-SD1->D1_VALIMP6)/SD1->D1_QUANT)*nSaldo)
         			 		ENDIF
                    	ENDIF
                   	ELSE
                    	IF SD1->D1_TES = "106"
                     		nVlCusto:=nVlCusto+SD1->D1_TOTAL+SD1->D1_VALIPI+SD1->D1_ICMSRET-SD1->D1_VALIMP5-SD1->D1_VALIMP6
                    	ELSE
                      		IF SD1->D1_TES = "172"
                       			IF CTOD(SUBSTRING(SD1->D1_EMISSAO,7,2)+'/'+SUBSTRING(SD1->D1_EMISSAO,5,2)+'/'+SUBSTRING(SD1->D1_EMISSAO,3,2))>=CTOD("20/08/13") 
                         			nVlCusto:=nVlCusto+SD1->D1_TOTAL-SD1->D1_VALICM-SD1->D1_VALIMP5-SD1->D1_VALIMP6                       
                       			ELSE
                         			nVlCusto:=nVlCusto+SD1->D1_TOTAL-SD1->D1_VALICM-(SD1->D1_TOTAL*9.25/100)                       
                       			ENDIF
                      		ELSE
                        		nVlCusto:=nVlCusto+SD1->D1_TOTAL+SD1->D1_VALIPI-SD1->D1_VALICM-SD1->D1_VALIMP5-SD1->D1_VALIMP6
         			  		ENDIF
                    	ENDIF
                   	ENDIF
                    nSaldo:= nSaldo-SD1->D1_QUANT
         		    nEntradas:=nEntradas+1  
                 ENDIF
               ELSE
                 IF SD1->D1_TES $ "301/305/310/312/311/315/317/314/316/318"
                   if nSaldo<SD1->D1_QUANT  
                     nVlCusto:=nVlCusto+(SD1->D1_TOTAL/SD1->D1_QUANT*nSaldo)
         	       else
         		     nVlCusto:=nVlCusto+SD1->D1_TOTAL
         		   endif
         		   nSaldo:= nSaldo-SD1->D1_QUANT
         	       nEntradas:=nEntradas+1  
                 ELSE
                   If (FieldPos("F4_RAPIDA") > 0 )  
                     if nSaldo<SD1->D1_QUANT
                       nVlCusto:=nVlCusto+(((SD1->D1_TOTAL-SD1->D1_VALICM-SD1->D1_VALIMP5-SD1->D1_VALIMP6)/SD1->D1_QUANT)*nSaldo)
         		     else
             	       nVlCusto:=nVlCusto+SD1->D1_TOTAL-SD1->D1_VALICM-SD1->D1_VALIMP5-SD1->D1_VALIMP6
         		     endif
         		     nSaldo:= nSaldo-SD1->D1_QUANT
         		     nEntradas:=nEntradas+1  
                   ENDIF
                 ENDIF
               ENDIF
               if nSaldo<0 
                 nSaldo:=0
               endif  
               dbSkip()
          EndDo
		  IF nSaldo<0 
		    nSaldo:=0
		  endif  
		  // GRAVANDO NOVOS PARAMETROS DE CUSTO NA TABELA CMV
		  dbSelectArea("PAA")			
		  IF nEntradas>0 
		    RecLock("PAA",.F.)
     	    PAA->PAA_SALDO	:= nEstoque
     	    PAA->PAA_UNIT	:=nVlCusto/(nEstoque-nSaldo)
     	    PAA->PAA_TOTAL	:=nVlCusto
     	    PAA->PAA_DATA	:=DATE()
     	    MsUnLock() 	      
		    IncProc("Produto:"+cCodigo+ " Atualizado Custo p/ R$" +transform(PAA->PAA_UNIT,"@e 999,999.99"))
		  else
	        IncProc("Produto:"+cCodigo+ " Nao Atualizado")
		  endif		
		endif
		// operacao quando hao houver estoque	
		if nEstoqueOri<=0
          // BUSCANDO PRODUTO NOS MOVIMENTOS DE ENTRADA
          DbSelectArea("SF4")
          dbSetOrder(1)
          cQuerySD1 :=""
       	  If (FieldPos("F4_RAPIDA") > 0 )                    
  		     aHistent:={}
  		     cQuerySD1 := "SELECT SD1.D1_COD,SD1.D1_FORNECE,SD1.D1_LOJA,SD1.D1_PEDIDO,SD1.D1_ITEMPC,SD1.D1_QUANT,SD1.D1_CUSTO,SD1.D1_TOTAL,SD1.D1_ICMSRET," 
  			 cQuerySD1 += "SD1.D1_DOC,SD1.D1_ITEM,SD1.D1_VALIPI,SD1.D1_VALICM,SD1.D1_VALIMP5,SD1.D1_VALIMP6,SD1.D1_DTDIGIT,SD1.D1_TES,SD1.D1_EMISSAO,SF4.F4_RAPIDA,SF4.F4_CODIGO " 
  			 cQuerySD1 += "FROM " + RetSqlName("SD1")+ " SD1 "+" INNER JOIN "+RetSqlName("SF4")+" SF4 ON SF4.F4_CODIGO = SD1.D1_TES WHERE "
  			 cQuerySD1 += "SD1.D1_FILIAL = '"+xFilial("SD1")+"' AND "
  			 cQuerySD1 += "SD1.D1_COD = '"+cCodigo+"' AND " 
  			 cQuerySD1 += "SF4.F4_RAPIDA ='S' AND " 
  			 cQuerySD1 += "SD1.D_E_L_E_T_=' ' ORDER BY SD1.R_E_C_N_O_ DESC"
  			 //cQuery := ChangeQuery(cQuery)
		  ELSE
  	  	     cQuerySD1 := "SELECT SD1.D1_COD,SD1.D1_FORNECE,SD1.D1_LOJA,SD1.D1_PEDIDO,SD1.D1_ITEMPC,SD1.D1_QUANT,SD1.D1_CUSTO,SD1.D1_TOTAL,SD1.D1_ICMSRET," 
        	 cQuerySD1 += "SD1.D1_DOC,SD1.D1_ITEM,SD1.D1_VALIPI,SD1.D1_VALICM,SD1.D1_VALIMP5,SD1.D1_VALIMP6,SD1.D1_DTDIGIT,SD1.D1_TES,SD1.D1_EMISSAO " 
        	 cQuerySD1 += "FROM " + RetSqlName("SD1")+ " SD1 WHERE "  
        	 cQuerySD1 += "SD1.D1_FILIAL = '"+xFilial("SD1")+"' AND "
        	 cQuerySD1 += "SD1.D1_COD = '"+cCodigo+"' AND " 
          	 cQuerySD1 += "SD1.D_E_L_E_T_=' ' ORDER BY SD1.R_E_C_N_O_ DESC"
  			 //cQuery := ChangeQuery(cQuery)
		  ENDIF
           /*      
           // extraindo valores com base nas entradas
           cQuerySD1 := "SELECT SD1.D1_COD,SD1.D1_FORNECE,SD1.D1_LOJA,SD1.D1_PEDIDO,SD1.D1_ITEMPC,SD1.D1_QUANT,SD1.D1_CUSTO,SD1.D1_TOTAL,SD1.D1_ICMSRET," 
           cQuerySD1 += "SD1.D1_DOC,SD1.D1_ITEM,SD1.D1_VALIPI,SD1.D1_VALICM,SD1.D1_VALIMP5,SD1.D1_VALIMP6,SD1.D1_DTDIGIT,SD1.D1_TES,SD1.D1_EMISSAO " 
           cQuerySD1 += "FROM " + RetSqlName("SD1")+ " SD1 WHERE "
           cQuerySD1 += "SD1.D1_FILIAL = '"+xFilial("SD1")+"' AND "
           cQuerySD1 += "SD1.D1_COD = '"+cCodigo+"' AND "              
           cQuerySD1 += "SD1.D_E_L_E_T_=' ' ORDER BY SD1.R_E_C_N_O_ DESC"
           */
          //cQuery := ChangeQuery(cQuery)
          If ( Select ("SD1") <> 0 )
         	dbSelectArea ("SD1")
            dbCloseArea ()
          Endif
          dBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuerySD1),"SD1",.T.,.T.)
          dbSelectArea("SD1")
		  nSaldo:=nEstoqueOri
		  nVlCusto:=0
		  nEntradas:=0
		  While ( !Eof() .And. SD1->D1_COD == cCodigo .and. nSaldo<=0 )
               IF SD1->D1_TES $ "101/10B/102/156/106/109/172/174"
                 IF SD1->D1_TES = "101"
                    nVlCusto:=nVlCusto+((SD1->D1_TOTAL-SD1->D1_VALICM-SD1->D1_VALIMP5-SD1->D1_VALIMP6)/SD1->D1_QUANT)
         		    nSaldo:= 1
         		    nEntradas:=1
         		 ELSE
                   	IF SD1->D1_TES = "106"
                    	nVlCusto:=nVlCusto+((SD1->D1_TOTAL+SD1->D1_VALIPI-SD1->D1_VALICM-SD1->D1_VALIMP5-SD1->D1_VALIMP6)/SD1->D1_QUANT)
                    ELSE
                    	IF SD1->D1_TES = "172"
                    		IF CTOD(SUBSTRING(SD1->D1_EMISSAO,7,2)+'/'+SUBSTRING(SD1->D1_EMISSAO,5,2)+'/'+SUBSTRING(SD1->D1_EMISSAO,3,2))>=CTOD("20/08/13") 
                      		    nVlCusto:=nVlCusto+((SD1->D1_TOTAL-SD1->D1_VALICM-SD1->D1_VALIMP5-SD1->D1_VALIMP6)/SD1->D1_QUANT)
                    		ELSE
                      			nVlCusto:=nVlCusto+((SD1->D1_TOTAL-SD1->D1_VALICM-(SD1->D1_TOTAL*9.25/100))/SD1->D1_QUANT)
                    		ENDIF
                       	ELSE
                       	    nVlCusto:=nVlCusto+((SD1->D1_TOTAL+SD1->D1_VALIPI-SD1->D1_VALICM-SD1->D1_VALIMP5-SD1->D1_VALIMP6)/SD1->D1_QUANT)
         			 	ENDIF
                    endif
                    nSaldo:= 1
         		    nEntradas:=1
                 ENDIF
               ELSE
                 IF SD1->D1_TES $ "301/305/310/312/311/315/317/314/316/318"
                   nVlCusto:=nVlCusto+(SD1->D1_TOTAL/SD1->D1_QUANT*nSaldo)
         		   nSaldo:= 1
         		   nEntradas:=1
                 ELSE
                   If (FieldPos("F4_RAPIDA") > 0 )  
                     nVlCusto:=nVlCusto+((SD1->D1_TOTAL-SD1->D1_VALICM-SD1->D1_VALIMP5-SD1->D1_VALIMP6)/SD1->D1_QUANT)
         		     nSaldo:= 1
         		     nEntradas:=1 
         		   ENDIF
         		 ENDIF  
               ENDIF
               dbSkip()
          EndDo
		   // GRAVANDO NOVOS PARAMETROS DE CUSTO NA TABELA CMV
		  dbSelectArea("PAA")			
		  IF nEntradas>0 
		    RecLock("PAA",.F.)
     	    PAA->PAA_SALDO	:= nEntradas
     	    PAA->PAA_UNIT	:=nVlCusto
     	    PAA->PAA_TOTAL	:=nVlCusto
     	    PAA->PAA_DATA	:=DATE()
     	    MsUnLock() 	      
		    IncProc("Produto:"+cCodigo+ " Atualizado Custo p/ R$" +transform(PAA->PAA_UNIT,"@e 999,999.99"))
		  else
	        IncProc("Produto:"+cCodigo+ " Nao Atualizado")
		  endif		
		endif
	   dbSelectArea("PAA")	
       dbSkip()
	EndDo	
ENDIF

If MsgYesNo("Deseja atribuir ultimo preco de entrada para todos os produtos com Custo Medio = 0. Deseja realmente processar esta rotina?")
    
    dbSelectArea("PAA")
	dbSetOrder(1)
    ProcRegua(RecCount()) 
    dbGoTop()
	While !Eof() 
        if PAA->PAA_UNIT=0
	        // Produto da Pesquisa
	        cCodigo:=PAA->PAA_COD
	        nEstoque:=1
	        nEstoqueOri:=0
	        //extraindo saldo em estoque
	        nEstoqueOri:=nEstoque
	        // Operacao quando Houver Estoque Disponivel
	        if nEstoque>0
	          // BUSCANDO PRODUTO NOS MOVIMENTOS DE ENTRADA
              DbSelectArea("SF4")
		      dbSetOrder(1)
	          cQuerySD1 :=""
       	      If (FieldPos("F4_RAPIDA") > 0 )                    
  		        aHistent:={}
  		        cQuerySD1 := "SELECT SD1.D1_COD,SD1.D1_FORNECE,SD1.D1_LOJA,SD1.D1_PEDIDO,SD1.D1_ITEMPC,SD1.D1_QUANT,SD1.D1_CUSTO,SD1.D1_TOTAL,SD1.D1_ICMSRET," 
  			    cQuerySD1 += "SD1.D1_DOC,SD1.D1_ITEM,SD1.D1_VALIPI,SD1.D1_VALICM,SD1.D1_VALIMP5,SD1.D1_VALIMP6,SD1.D1_DTDIGIT,SD1.D1_TES,SD1.D1_EMISSAO,SF4.F4_RAPIDA,SF4.F4_CODIGO " 
  			    cQuerySD1 += "FROM " + RetSqlName("SD1")+ " SD1 "+" INNER JOIN "+RetSqlName("SF4")+" SF4 ON SF4.F4_CODIGO = SD1.D1_TES WHERE "
  			    cQuerySD1 += "SD1.D1_FILIAL = '"+xFilial("SD1")+"' AND "
  			    cQuerySD1 += "SD1.D1_COD = '"+cCodigo+"' AND " 
  			    cQuerySD1 += "SF4.F4_RAPIDA ='S' AND " 
  			    cQuerySD1 += "SD1.D_E_L_E_T_=' ' ORDER BY SD1.R_E_C_N_O_ DESC"
  			    //cQuery := ChangeQuery(cQuery)
		      ELSE
  	  	        cQuerySD1 := "SELECT SD1.D1_COD,SD1.D1_FORNECE,SD1.D1_LOJA,SD1.D1_PEDIDO,SD1.D1_ITEMPC,SD1.D1_QUANT,SD1.D1_CUSTO,SD1.D1_TOTAL,SD1.D1_ICMSRET," 
        	    cQuerySD1 += "SD1.D1_DOC,SD1.D1_ITEM,SD1.D1_VALIPI,SD1.D1_VALICM,SD1.D1_VALIMP5,SD1.D1_VALIMP6,SD1.D1_DTDIGIT,SD1.D1_TES,SD1.D1_EMISSAO " 
        	    cQuerySD1 += "FROM " + RetSqlName("SD1")+ " SD1 WHERE "  
        	    cQuerySD1 += "SD1.D1_FILIAL = '"+xFilial("SD1")+"' AND "
        	    cQuerySD1 += "SD1.D1_COD = '"+cCodigo+"' AND " 
          	    cQuerySD1 += "SD1.D_E_L_E_T_=' ' ORDER BY SD1.R_E_C_N_O_ DESC"
  			    //cQuery := ChangeQuery(cQuery)
		      ENDIF
	          /*
	          // extraindo valores com base nas entradas
	          cQuerySD1 := "SELECT SD1.D1_COD,SD1.D1_FORNECE,SD1.D1_LOJA,SD1.D1_PEDIDO,SD1.D1_ITEMPC,SD1.D1_QUANT,SD1.D1_CUSTO,SD1.D1_TOTAL,SD1.D1_ICMSRET," 
	          cQuerySD1 += "SD1.D1_DOC,SD1.D1_ITEM,SD1.D1_VALIPI,SD1.D1_VALICM,SD1.D1_VALIMP5,SD1.D1_VALIMP6,SD1.D1_DTDIGIT,SD1.D1_TES,SD1.D1_EMISSAO " 
	          cQuerySD1 += "FROM " + RetSqlName("SD1")+ " SD1 WHERE "
	          cQuerySD1 += "SD1.D1_FILIAL = '"+xFilial("SD1")+"' AND "
	          cQuerySD1 += "SD1.D1_COD = '"+cCodigo+"' AND "              
	          cQuerySD1 += "SD1.D_E_L_E_T_=' ' ORDER BY SD1.R_E_C_N_O_ DESC"
	          */
	          //cQuery := ChangeQuery(cQuery)
	          If ( Select ("SD1") <> 0 )
	         	dbSelectArea ("SD1")
	            dbCloseArea ()
	          Endif
	          dBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuerySD1),"SD1",.T.,.T.)
	          dbSelectArea("SD1")
			  nSaldo:=nEstoque
			  nVlCusto:=0
			  nEntradas:=0
			  While ( !Eof() .And. SD1->D1_COD == cCodigo .and. nSaldo>0 )
	               IF SD1->D1_TES $ "101/10B/102/106/156/107/109/172/174"
	                 IF SD1->D1_TES = "101"
	                    if nSaldo<SD1->D1_QUANT
	                      nVlCusto:=nVlCusto+(((SD1->D1_TOTAL-SD1->D1_VALICM-SD1->D1_VALIMP5-SD1->D1_VALIMP6)/SD1->D1_QUANT)*nSaldo)
	         			else
	             		  nVlCusto:=nVlCusto+SD1->D1_TOTAL-SD1->D1_VALICM-SD1->D1_VALIMP5-SD1->D1_VALIMP6
	         			endif
	         			nSaldo:= nSaldo-SD1->D1_QUANT
	         			nEntradas:=nEntradas+1  
	                 ELSE
                 		if nSaldo<SD1->D1_QUANT 
                    		IF SD1->D1_TES = "106"
                      			nVlCusto:=nVlCusto+(((SD1->D1_TOTAL+SD1->D1_VALIPI+SD1->D1_ICMSRET-SD1->D1_VALIMP5-SD1->D1_VALIMP6)/SD1->D1_QUANT)*nSaldo)
                    		ELSE
                      			IF SD1->D1_TES = "172"
                       				IF CTOD(SUBSTRING(SD1->D1_EMISSAO,7,2)+'/'+SUBSTRING(SD1->D1_EMISSAO,5,2)+'/'+SUBSTRING(SD1->D1_EMISSAO,3,2))>=CTOD("20/08/13") 
                         				nVlCusto:=nVlCusto+(((SD1->D1_TOTAL-SD1->D1_VALICM-SD1->D1_VALIMP5-SD1->D1_VALIMP6)/SD1->D1_QUANT)*nSaldo)
                       				ELSE
                         				nVlCusto:=nVlCusto+(((SD1->D1_TOTAL-SD1->D1_VALICM-(SD1->D1_TOTAL*9.25/100))/SD1->D1_QUANT)*nSaldo)
                       				ENDIF
                     			ELSE
                       				nVlCusto:=nVlCusto+(((SD1->D1_TOTAL+SD1->D1_VALIPI-SD1->D1_VALICM-SD1->D1_VALIMP5-SD1->D1_VALIMP6)/SD1->D1_QUANT)*nSaldo)
         			 			ENDIF
                    		ENDIF
                   		ELSE
                    		IF SD1->D1_TES = "106"
                     			nVlCusto:=nVlCusto+SD1->D1_TOTAL+SD1->D1_VALIPI+SD1->D1_ICMSRET-SD1->D1_VALIMP5-SD1->D1_VALIMP6
                    		ELSE
                      			IF SD1->D1_TES = "172"
                       				IF CTOD(SUBSTRING(SD1->D1_EMISSAO,7,2)+'/'+SUBSTRING(SD1->D1_EMISSAO,5,2)+'/'+SUBSTRING(SD1->D1_EMISSAO,3,2))>=CTOD("20/08/13") 
                         				nVlCusto:=nVlCusto+SD1->D1_TOTAL-SD1->D1_VALICM-SD1->D1_VALIMP5-SD1->D1_VALIMP6                       
                       				ELSE
                         				nVlCusto:=nVlCusto+SD1->D1_TOTAL-SD1->D1_VALICM-(SD1->D1_TOTAL*9.25/100)                       
                       				ENDIF
                      			ELSE
                        			nVlCusto:=nVlCusto+SD1->D1_TOTAL+SD1->D1_VALIPI-SD1->D1_VALICM-SD1->D1_VALIMP5-SD1->D1_VALIMP6
         			  			ENDIF
                    		ENDIF
                   		ENDIF
                    	nSaldo:= nSaldo-SD1->D1_QUANT
         		    	nEntradas:=nEntradas+1  
                 	 ENDIF
	         	   ELSE
	                 IF SD1->D1_TES $ "301/305/310/312/311/315/317/314/316/318"
	                   if nSaldo<SD1->D1_QUANT  
	                     nVlCusto:=nVlCusto+(SD1->D1_TOTAL/SD1->D1_QUANT*nSaldo)
	         	       else
	         		     nVlCusto:=nVlCusto+SD1->D1_TOTAL
	         		   endif
	         		   nSaldo:= nSaldo-SD1->D1_QUANT
	         	       nEntradas:=nEntradas+1  
	                 ELSE
	                   If (FieldPos("F4_RAPIDA") > 0 )  
	                     if nSaldo<SD1->D1_QUANT
	                       nVlCusto:=nVlCusto+(((SD1->D1_TOTAL-SD1->D1_VALICM-SD1->D1_VALIMP5-SD1->D1_VALIMP6)/SD1->D1_QUANT)*nSaldo)
	         		     else
	             		   nVlCusto:=nVlCusto+SD1->D1_TOTAL-SD1->D1_VALICM-SD1->D1_VALIMP5-SD1->D1_VALIMP6
	         		     endif
	         		     nSaldo:= nSaldo-SD1->D1_QUANT
	         		     nEntradas:=nEntradas+1  
	                   ENDIF
	                 ENDIF
	               ENDIF
	               if nSaldo<0 
	                 nSaldo:=0
	               endif  
	               dbSkip()
	          EndDo
			  IF nSaldo<0 
			    nSaldo:=0
			  endif  
			  // GRAVANDO NOVOS PARAMETROS DE CUSTO NA TABELA CMV
			  dbSelectArea("PAA")			
			  IF nEntradas>0 
			    RecLock("PAA",.F.)
	     	    PAA->PAA_SALDO	:= nEstoque
	     	    PAA->PAA_UNIT	:=nVlCusto/(nEstoque-nSaldo)
	     	    PAA->PAA_TOTAL	:=nVlCusto
	     	    PAA->PAA_DATA	:=DATE()
	     	    MsUnLock() 	      
			    IncProc("Produto:"+cCodigo+ " Atualizado Custo p/ R$" +transform(PAA->PAA_UNIT,"@e 999,999.99"))
			  else
		        IncProc("Produto:"+cCodigo+ " Nao Atualizado")
			  endif		
			endif
			// operacao quando hao houver estoque	
			if nEstoqueOri<=0
	          // BUSCANDO PRODUTO NOS MOVIMENTOS DE ENTRADA
              DbSelectArea("SF4")
		      dbSetOrder(1)
	          // extraindo valores com base nas entradas
	          cQuerySD1 :=""
       	      If (FieldPos("F4_RAPIDA") > 0 )                    
  		        aHistent:={}
  		        cQuerySD1 := "SELECT SD1.D1_COD,SD1.D1_FORNECE,SD1.D1_LOJA,SD1.D1_PEDIDO,SD1.D1_ITEMPC,SD1.D1_QUANT,SD1.D1_CUSTO,SD1.D1_TOTAL,SD1.D1_ICMSRET," 
  			    cQuerySD1 += "SD1.D1_DOC,SD1.D1_ITEM,SD1.D1_VALIPI,SD1.D1_VALICM,SD1.D1_VALIMP5,SD1.D1_VALIMP6,SD1.D1_DTDIGIT,SD1.D1_TES,SD1.D1_EMISSAO,SF4.F4_RAPIDA,SF4.F4_CODIGO " 
  			    cQuerySD1 += "FROM " + RetSqlName("SD1")+ " SD1 "+" INNER JOIN "+RetSqlName("SF4")+" SF4 ON SF4.F4_CODIGO = SD1.D1_TES WHERE "
  			    cQuerySD1 += "SD1.D1_FILIAL = '"+xFilial("SD1")+"' AND "
  			    cQuerySD1 += "SD1.D1_COD = '"+cCodigo+"' AND " 
  			    cQuerySD1 += "SF4.F4_RAPIDA ='S' AND " 
  			    cQuerySD1 += "SD1.D_E_L_E_T_=' ' ORDER BY SD1.R_E_C_N_O_ DESC"
  			    //cQuery := ChangeQuery(cQuery)
		      ELSE
  	  	        cQuerySD1 := "SELECT SD1.D1_COD,SD1.D1_FORNECE,SD1.D1_LOJA,SD1.D1_PEDIDO,SD1.D1_ITEMPC,SD1.D1_QUANT,SD1.D1_CUSTO,SD1.D1_TOTAL,SD1.D1_ICMSRET," 
        	    cQuerySD1 += "SD1.D1_DOC,SD1.D1_ITEM,SD1.D1_VALIPI,SD1.D1_VALICM,SD1.D1_VALIMP5,SD1.D1_VALIMP6,SD1.D1_DTDIGIT,SD1.D1_TES,SD1.D1_EMISSAO " 
        	    cQuerySD1 += "FROM " + RetSqlName("SD1")+ " SD1 WHERE "  
        	    cQuerySD1 += "SD1.D1_FILIAL = '"+xFilial("SD1")+"' AND "
        	    cQuerySD1 += "SD1.D1_COD = '"+cCodigo+"' AND " 
          	    cQuerySD1 += "SD1.D_E_L_E_T_=' ' ORDER BY SD1.R_E_C_N_O_ DESC"
  			    //cQuery := ChangeQuery(cQuery)
		      ENDIF
	          /*
	          cQuerySD1 := "SELECT SD1.D1_COD,SD1.D1_FORNECE,SD1.D1_LOJA,SD1.D1_PEDIDO,SD1.D1_ITEMPC,SD1.D1_QUANT,SD1.D1_CUSTO,SD1.D1_TOTAL,SD1.D1_ICMSRET," 
	          cQuerySD1 += "SD1.D1_DOC,SD1.D1_ITEM,SD1.D1_VALIPI,SD1.D1_VALICM,SD1.D1_VALIMP5,SD1.D1_VALIMP6,SD1.D1_DTDIGIT,SD1.D1_TES,SD1.D1_EMISSAO " 
	          cQuerySD1 += "FROM " + RetSqlName("SD1")+ " SD1 WHERE "
	          cQuerySD1 += "SD1.D1_FILIAL = '"+xFilial("SD1")+"' AND "
	          cQuerySD1 += "SD1.D1_COD = '"+cCodigo+"' AND "              
	          cQuerySD1 += "SD1.D_E_L_E_T_=' ' ORDER BY SD1.R_E_C_N_O_ DESC" 
	          */
	          //cQuery := ChangeQuery(cQuery)
	          If ( Select ("SD1") <> 0 )
	         	dbSelectArea ("SD1")
	            dbCloseArea ()
	          Endif
	          dBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuerySD1),"SD1",.T.,.T.)
	          dbSelectArea("SD1")
			  nSaldo:=nEstoqueOri
			  nVlCusto:=0
			  nEntradas:=0
			  While ( !Eof() .And. SD1->D1_COD == cCodigo .and. nSaldo<=0 )
                   IF SD1->D1_TES $ "101/10B/102/156/106/109/172/174"
	                 IF SD1->D1_TES = "101"
	                    nVlCusto:=nVlCusto+((SD1->D1_TOTAL-SD1->D1_VALICM-SD1->D1_VALIMP5-SD1->D1_VALIMP6)/SD1->D1_QUANT)
	         		    nSaldo:= 1
	         		    nEntradas:=1
	         		 ELSE
	                   	IF SD1->D1_TES = "106"
                      		nVlCusto:=nVlCusto+((SD1->D1_TOTAL+SD1->D1_VALIPI-SD1->D1_VALICM-SD1->D1_VALIMP5-SD1->D1_VALIMP6)/SD1->D1_QUANT)
                       	ELSE
                      		IF SD1->D1_TES = "172"
                       			IF CTOD(SUBSTRING(SD1->D1_EMISSAO,7,2)+'/'+SUBSTRING(SD1->D1_EMISSAO,5,2)+'/'+SUBSTRING(SD1->D1_EMISSAO,3,2))>=CTOD("20/08/13") 
                         		    nVlCusto:=nVlCusto+((SD1->D1_TOTAL-SD1->D1_VALICM-SD1->D1_VALIMP5-SD1->D1_VALIMP6)/SD1->D1_QUANT)
                       			ELSE
                         			nVlCusto:=nVlCusto+((SD1->D1_TOTAL-SD1->D1_VALICM-(SD1->D1_TOTAL*9.25/100))/SD1->D1_QUANT)
                       			ENDIF
                     		ELSE
                       	        nVlCusto:=nVlCusto+((SD1->D1_TOTAL+SD1->D1_VALIPI-SD1->D1_VALICM-SD1->D1_VALIMP5-SD1->D1_VALIMP6)/SD1->D1_QUANT)
         			 		ENDIF
                    	ENDIF
                        nSaldo:= 1
         		        nEntradas:=1
	         		 endif
                   ELSE
	                 IF SD1->D1_TES $ "301/305/310/312/311/315/317/314/316/318"
	                   nVlCusto:=nVlCusto+(SD1->D1_TOTAL/SD1->D1_QUANT*nSaldo)
	         		   nSaldo:= 1
	         		   nEntradas:=1
	                 ELSE
                       If (FieldPos("F4_RAPIDA") > 0 ) 
	                     nVlCusto:=nVlCusto+((SD1->D1_TOTAL-SD1->D1_VALICM-SD1->D1_VALIMP5-SD1->D1_VALIMP6)/SD1->D1_QUANT)
	         		     nSaldo:= 1
	         		     nEntradas:=1
	                   ENDIF
	                 ENDIF
	               ENDIF
	               dbSkip()
	          EndDo
			   // GRAVANDO NOVOS PARAMETROS DE CUSTO NA TABELA CMV
			  dbSelectArea("PAA")			
			  IF nEntradas>0 
			    RecLock("PAA",.F.)
	     	    PAA->PAA_SALDO	:= nEntradas
	     	    PAA->PAA_UNIT	:=nVlCusto
	     	    PAA->PAA_TOTAL	:=nVlCusto
	     	    PAA->PAA_DATA	:=DATE()
	     	    MsUnLock() 	      
			    IncProc("Produto:"+cCodigo+ " Atualizado Custo p/ R$" +transform(PAA->PAA_UNIT,"@e 999,999.99"))
			  else
		        IncProc("Produto:"+cCodigo+ " Nao Atualizado")
			  endif		
			endif
		   dbSelectArea("PAA")	
       ENDIF
       dbSkip()
	EndDo	
ENDIF 

If MsgYesNo("Deseja Incluir ultimo preco de entrada para todos os produtos com Custo Medio = 0 (Objeto Produ็ใo). Deseja realmente processar esta rotina?")
    dbSelectArea("PAA")
	dbSetOrder(1)
    ProcRegua(RecCount())
    dbGoTop()
	While !Eof() 
        cCodigo:=PAA->PAA_COD
        if PAA->PAA_UNIT==0
	        // Produto da Pesquisa
	        nEstoque:=1
	        nEstoqueOri:=0
            cQuerySD3 :=""
            cQuerySD3 := "SELECT SD3.D3_COD,SD3.D3_EMISSAO,SD3.D3_QUANT,SD3.D3_OP,SD3.D3_CF " 
            cQuerySD3 += "FROM " + RetSqlName("SD3")+ " SD3 WHERE "
            cQuerySD3 += "SD3.D3_FILIAL = '"+xFilial("SD3")+"' AND "
            cQuerySD3 += "SD3.D3_EMISSAO >= '"+DTOS(dInicio)+"' AND "
            cQuerySD3 += "SD3.D3_EMISSAO <= '"+DTOS(dFim)+"' AND "
            cQuerySD3 += "SD3.D3_CF= 'PR0' AND "
            cQuerySD3 += "SD3.D3_COD='"+cCodigo+"' AND "
            cQuerySD3 += "SD3.D_E_L_E_T_=' ' ORDER BY SD3.D3_EMISSAO DESC"
            //cQuery := ChangeQuery(cQuery)
            If ( Select ("SD3") <> 0 )
            	dbSelectArea ("SD3")
                dbCloseArea ()
            Endif
            dBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuerySD3),"SD3",.T.,.T.)
            dbSelectArea("SD3")
			nEntradas:=0
		    nVlCusto:=0
		    IF SD3->(!Eof())
	           	nEntradas:=nEntradas+SD3->D3_QUANT
                cOp	     :=SD3->D3_OP
                cQuerySD1 :=""
                cQuerySD1 := "SELECT SD1.D1_OP,SD1.D1_TOTAL FROM " + RetSqlName("SD1")+ " SD1 WHERE "
                cQuerySD1 += "SD1.D1_FILIAL = '"+xFilial("SD1")+"' AND "
                cQuerySD1 += "SD1.D1_OP = '"+cOp+"' AND "
                cQuerySD1 += "SD1.D_E_L_E_T_=' '"
                //cQuery := ChangeQuery(cQuery)
                If ( Select ("SD1") <> 0 )
        	         		dbSelectArea ("SD1")
                      		dbCloseArea ()
                Endif
                dBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuerySD1),"SD1",.T.,.T.)
               	dbSelectArea("SD1")
		       	While (!Eof() .and. trim(SD1->D1_OP) == trim(cOp))
               		nVlCusto:=nVlCusto+SD1->D1_TOTAL
               		dbSkip()
               	enddo	
	        endif   	
	        // GRAVANDO NOVOS PARAMETROS DE CUSTO NA TABELA CMV
		    dbSelectArea("PAA")			
		    IF nEntradas>0 .AND. nVlCusto>0
		    	RecLock("PAA",.f.)
     	    	PAA->PAA_SALDO	:= 1
     	    	PAA->PAA_UNIT	:=nVlCusto/nEntradas
     	    	PAA->PAA_TOTAL	:=nVlCusto/nEntradas
     	    	PAA->PAA_DATA	:=DATE()
     	    	MsUnLock() 	      
		    else
	        endif   	
	        IncProc("Produto:"+cCodigo+ " Atualizado Custo p/ R$" +transform(PAA->PAA_UNIT,"@e 999,999.99"))
		else
	        IncProc("Produto:"+cCodigo+ " Nao Atualizado")
	    endif  
	    dbSelectArea("PAA")
        dbSkip()   	
	enddo           	
endif
                                                                        

Close(Odlg1)
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

Close(Odlg1)

Return
                 


