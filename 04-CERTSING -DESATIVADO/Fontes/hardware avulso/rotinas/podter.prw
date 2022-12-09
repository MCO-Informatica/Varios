# Include 'Protheus.ch'
# Include 'Topconn.ch'                                      

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPODTER    บAutor  ณDarcio R. Sporl     บ Data ณ  20/05/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao criada para fazer o retorno de poder de terceiro     บฑฑ
ฑฑบ          ณe baixar o saldo do mesmo automaticamente, para controle    บฑฑ
ฑฑบ          ณde entrega do cliente certsign.                             บฑฑ 
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ 
ฑฑบUso       ณ OPVS / Certisign                                           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAlteracoesณ #ASD20120518 - Alteracoes para chamada direta por schedule,บฑฑ  
ฑฑบ          ณ aglutinando NF retorno por DATA+POSTO ATENDIMENTO.         บฑฑ 
ฑฑบ          ณ Programa totalmente reestruturado.                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/                                                           

User Function PODTER(aParSch)            
         
Local _aArea   		:= GetArea() 					//Armazena areas para posterior retorno  
Local _cQuery1  	:= "" 							//Selecao de itens SZ5 a processar 
Local _lCtrlVld		:= .F.							//Retorno do controle de validacoes
Local _lLimite		:= .F.							//Se emitiu por atingir limite de itens (990) do mesmo fornecedor na mesma NF = .T., mantem no mesmo item sem skip
Local cJobEmp	:= aParSch[1]
Local cJobFil	:= aParSch[2]
Local _lJob 	:= (Select('SX6')==0)

If _lJob
	RpcSetType(3)
	RpcSetEnv(cJobEmp, cJobFil)
EndIf


Private _nSldB6		:= 0							//Checa se existe saldo no SB6
Private _cForAtu  	:= "" 							//Chave fornecedor atual (posicionado)
Private _cLojAtu  	:= "" 							//Chave loja atual (posicionada)    
Private _cPrdAtu	:= ""                         	//Chave produto atual (posicionado)
Private _cSerie   	:= SuperGetMV("MV_XSERDEV",,"2")		//Serie da NF de Entrada - retorno terceiros  
Private _cTesDev  	:= SuperGetMV("MV_XTESDEV",,"008")		//Tes utilizado para devolucao de poder de terceiro
Private _cTipoNF  	:= SuperGetMV("MV_XTPDEVO",,"N")		//Tipo de documento de entrada referente a devolucao
Private _cEspecie 	:= SuperGetMV("MV_XESPECI",,"SPED")		//Especie na nota fiscal de entrada, referente a devolucao  
Private _cTpNrNfs 	:= SuperGetMV("MV_TPNRNFS",,"2")    	//Serie da NF de Saida (param. para numeracao autom.) 
Private _cNumDev 	:= PadR(NxtSX5Nota(_cSerie, .T., _cTpNrNfs), TamSX3("F1_DOC")[1])	//Numero da NF de Entrada - retorno terceiros 
Private _aItens   	:= {} 							//Array com linhas da SD2 
Private _aEmail	  	:= {} 							//Dados para envio do email     
Private _aRecnoZ5 	:= {} 							//Array com recnos SZ5 a marcar como processados   
Private _nRecnoF1 	:= 0 							//Recno da NFe Entrada gravada
Private _nTotDev	:= 0							//Armazena quantidade total devolvida para a chave forncedor+loja+produto    
Private _nSldDevZ5 	:= 0							//Quantidade inicial/restante pendente a devolver
Private _nSldPrdB6 	:= 0							//Quantidade do produto no terceiro disponivel para devolver     
Private _aQtdDev	:= {}                          	//Quantidade devolvida para a chave Fornecedor+Loja+produto - criado para o caso de quebra de itens 990 e na marcacao da SZ5
Private lMsErroAuto := .F. 							//Controla erro retorno rotina

_lCtrlVld := U_PODTER1() //Funcao de controle das validacoes

//Se nao validar, aborta
If	!_lCtrlVld	
	RestArea(_aArea)
	Return()
EndIf   
  
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณSelecao dos itens na SZ5 a processar.                         ณ 
//ณNa alteracao de _cQuery1, atentar-se tambem para _cQuery6.    ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู   


Conout("PODTER - Montando a query")
                                                                                
_cQuery1 := "SELECT FORNECE, LOJA, PRODUTO, SUM(QTDENT) AS QTDVEN " 
_cQuery1 += "FROM ( "            

//Entrega mํdia venda avulsa
_cQuery1 += "SELECT SZ8.Z8_FORNEC AS FORNECE, SZ8.Z8_LOJA AS LOJA, SC6.C6_PRODUTO AS PRODUTO, SUM(SC6.C6_QTDENT) AS QTDENT " 
_cQuery1 += "FROM " + RetSqlName("SZ5") + " SZ5 " 
_cQuery1 += "INNER JOIN " + RetSqlName("SZ3") + " SZ3 ON SZ3.Z3_FILIAL = '" + xFilial("SZ3") + "' "
//_cQuery1 += "AND SZ3.Z3_CODENT <> '' "
_cQuery1 += "AND SZ3.Z3_CODGAR = SZ5.Z5_CODPOS " 
_cQuery1 += "AND SZ3.D_E_L_E_T_ = '' "
_cQuery1 += "INNER JOIN " + RetSqlName("SZ8") + " SZ8 ON SZ8.Z8_FILIAL = '" + xFilial("SZ8") + "' "
//_cQuery1 += "AND SZ8.Z8_COD <> '' "
_cQuery1 += "AND SZ3.Z3_PONDIS = SZ8.Z8_COD "  
_cQuery1 += "AND SZ3.Z3_PONDIS = 'P00172' "  
_cQuery1 += "AND SZ8.D_E_L_E_T_ = '' "
_cQuery1 += "INNER JOIN " + RetSqlName("SC6") + " SC6 ON SC6.C6_FILIAL = '" + xFilial("SC6") + "' "
//_cQuery1 += "AND SC6.C6_NUM <> '' "
//_cQuery1 += "AND SC6.C6_ITEM <> '' "
_cQuery1 += "AND SZ5.Z5_PEDIDO = SC6.C6_NUM " 
_cQuery1 += "AND SZ5.Z5_ITEMPV = SC6.C6_ITEM " 
_cQuery1 += "AND SZ5.Z5_PRODUTO = SC6.C6_PRODUTO " 
_cQuery1 += "AND SC6.C6_XOPER = '53' " 
_cQuery1 += "AND SC6.D_E_L_E_T_ = '' "
_cQuery1 += "WHERE SZ5.Z5_FILIAL = '" + xFilial("SZ5") + "' " 
//_cQuery1 += "AND SZ5.Z5_PEDGAR <> '' "
_cQuery1 += "AND SZ5.Z5_TIPO = 'ENTHAR' "
_cQuery1 += "AND SZ5.Z5_PROCRET = '' " 
_cQuery1 += "AND SZ5.Z5_ROTINA = 'MATA460' "
_cQuery1 += "AND SZ5.D_E_L_E_T_ = '' "
_cQuery1 += "GROUP BY SZ8.Z8_FORNEC, SZ8.Z8_LOJA, SC6.C6_PRODUTO "

_cQuery1 += "UNION " 
              
//Validacao
_cQuery1 += "SELECT SZ8.Z8_FORNEC AS FORNECE, SZ8.Z8_LOJA AS LOJA, SC6.C6_PRODUTO AS PRODUTO, SUM(SC6.C6_QTDENT) AS QTDENT " 
_cQuery1 += "FROM " + RetSqlName("SZ5") + " SZ5 " 
_cQuery1 += "INNER JOIN " + RetSqlName("SZ3") + " SZ3 ON SZ3.Z3_FILIAL = '" + xFilial("SZ3") + "' " 
//_cQuery1 += "AND SZ3.Z3_CODENT <> '' "
_cQuery1 += "AND SZ3.Z3_CODGAR = SZ5.Z5_CODPOS " 
_cQuery1 += "AND SZ3.D_E_L_E_T_ = '' " 
_cQuery1 += "INNER JOIN " + RetSqlName("SZ8") + " SZ8 ON SZ8.Z8_FILIAL = '" + xFilial("SZ8") + "' "
//_cQuery1 += "AND SZ8.Z8_COD <> '' "
_cQuery1 += "AND SZ3.Z3_PONDIS = SZ8.Z8_COD "  
_cQuery1 += "AND SZ3.Z3_PONDIS = 'P00172' "  
_cQuery1 += "AND SZ8.D_E_L_E_T_ = '' "
_cQuery1 += "INNER JOIN " + RetSqlName("SC6") + " SC6 ON SC6.C6_FILIAL = '" + xFilial("SC6") + "' "
//_cQuery1 += "AND SC6.C6_NUM <> '' "
//_cQuery1 += "AND SC6.C6_ITEM <> '' "
_cQuery1 += "AND SC6.C6_XOPER = '53' "
_cQuery1 += "AND SZ5.Z5_PEDGAR = SC6.C6_PEDGAR "  
_cQuery1 += "AND SC6.D_E_L_E_T_ = '' " 
_cQuery1 += "WHERE SZ5.Z5_FILIAL = '" + xFilial("SZ5") + "' "
_cQuery1 += "AND SZ5.Z5_PEDGAR <> '' "
_cQuery1 += "AND SZ5.Z5_TIPO = 'VALIDA' " 
_cQuery1 += "AND SZ5.Z5_PROCRET = '' " 
_cQuery1 += "AND SZ5.Z5_ROTINA = 'GARA130' "
_cQuery1 += "AND SZ5.D_E_L_E_T_ = '' "
_cQuery1 += "GROUP BY SZ8.Z8_FORNEC, SZ8.Z8_LOJA, SC6.C6_PRODUTO) "  

_cQuery1 += "GROUP BY FORNECE, LOJA, PRODUTO " 
_cQuery1 += "ORDER BY FORNECE, LOJA, PRODUTO "         

_cQuery1 := ChangeQuery(_cQuery1)
	       
If	Select("SZ5REG") > 0  
	SZ5REG->(dbCloseArea())
EndIf  
			
TCQUERY _cQuery1 NEW ALIAS "SZ5REG"  

DbSelectArea("SZ5REG")
SZ5REG->(DbGoTop())

//Atualiza variaveis antes de entrar no laco
_cForAtu 	:= SZ5REG->FORNECE
_cLojAtu 	:= SZ5REG->LOJA       
_cPrdAtu	:= SZ5REG->PRODUTO 
_nSldDevZ5 	:= SZ5REG->QTDVEN            
_nSldB6		:= U_PODTER2() 

Conout("PODTER - Entra no laco para emissao da NF Entrada")
                                              
While SZ5REG->(!Eof())//Entra no laco para emissao da NF Entrada  
	
	//Mudou o fornecedor/loja emite a nota
	If		!_cForAtu+_cLojAtu == SZ5REG->FORNECE+SZ5REG->LOJA 
		Conout("PODTER - Mudou o fornecedor loja emite a nota")
		
		If 	Len(_aItens) > 0 .and. Len(_aItens) <= 990 //houver itens (<= 990), emite NF ao fornecedor
			U_PODTER4() //Emite, transmite e imprime NF. 
		Endif
		
		//Atualiza variaveis para novo fornecedor
		_cForAtu 	:= SZ5REG->FORNECE
		_cLojAtu 	:= SZ5REG->LOJA         
		_cPrdAtu	:= SZ5REG->PRODUTO 
		_nSldDevZ5 	:= SZ5REG->QTDVEN  
		_nSldB6 	:= U_PODTER2() 
		
		Loop
			
	//Sendo mesmo fornecedor/loja e atingir limite de 990 itens, emite NF ao fornecedor atual          
	ElseIf	_cForAtu+_cLojAtu == SZ5REG->FORNECE+SZ5REG->LOJA .and. Len(_aItens) == 990  
		Conout("PODTER - Sendo mesmo fornecedor loja e atingir limite de 990 itens, emite NF ao fornecedor atual")
			
			U_PODTER4() //Emite, transmite e imprime NF.     
			                                  
			//Se apos a emissao da NF trocar de produto para o mesmo fornecedor, atualiza variaveis
			If	!_cPrdAtu == SZ5REG->PRODUTO
				_cPrdAtu 	:= SZ5REG->PRODUTO	
				_nSldDevZ5 	:=	SZ5REG->QTDVEN 
				_nSldB6 	:= U_PODTER2()
			EndIf 
			
	//Se ainda existir saldo a devolver na SZ5 e na SB6 para chave Fornecedor+loja+produto correntes
	ElseIf	_cForAtu+_cLojAtu+_cPrdAtu == SZ5REG->FORNECE+SZ5REG->LOJA+SZ5REG->PRODUTO .and. _nSldDevZ5 > 0 .and. _nSldB6 > 0  
		Conout("PODTER - Se ainda existir saldo a devolver na SZ5 e na SB6 para chave Fornecedor loja produto correntes")
			
			U_PODTER3() //Adiciona item atual para proxima NF (mesmo fornecedor)    
				                         
	Else	//Se nenhuma das anteriores, atualiza variaveis                   
		Conout("PODTER - Se nenhuma das anteriores, atualiza variaveis")
	                                            
			If		(Len(_aItens) < 990)  .or.;									  //Se nao atingir maximo de itens na NF, salta registro, ou; 
					(Len(_aItens) == 990 .and. (_nSldDevZ5 == 0 .or. _nSldB6 == 0)) //Se nao atingir maximo de itens na NF e nใo houver saldo, salta registro
			
					SZ5REG->(DbSkip()) //Salta registro
	                
	   				If	SZ5REG->(!EOF()) .and.	_cForAtu+_cLojAtu == SZ5REG->FORNECE+SZ5REG->LOJA
						_cPrdAtu	:= SZ5REG->PRODUTO   
						_nSldDevZ5 	:= SZ5REG->QTDVEN
						_nSldB6 	:= U_PODTER2() 
					EndIf
			
			EndIf
	EndIf		
	Conout("PODTER - Vai pr๓ximo item do laco para emissao da NF Entrada")
					                                                                                     
EndDo       

//Verifica ao sair do laco se deve ou nao emitir NF (ultima - fim de laco)
If 	Len(_aItens) > 0 .and. Len(_aItens) <= 990 
	Conout("PODTER - Verifica ao sair do laco se deve ou nao emitir NF")
	U_PODTER4()
EndIf
	                                                      	                                                      
//Envia email se destinatarios estiverem parametrizados e houver dados a serem informados
If 	Len(_aEmail) > 0
	Conout("PODTER - Envia email se destinatarios estiverem parametrizados e houver dados a serem informados")
	U_PODTER6()
EndIf   	

RestArea(_aArea)    

Return() 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPODTER1   บAutor  ณAldoney Dias        บ Data ณ  20/05/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณControle das validacoes.                                    บฑฑ 
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ 
ฑฑบUso       ณ OPVS / Certisign                                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/                  

User Function PODTER1()  

Local _lRet 	:= .T.         
Local _cPodter  := AllTrim(GetNewPar("MV_XPDTER", "0"))		//Controla ou nao emissao automatica de NFs retorno terceiros automaticamente

//Validacao controle PODER3
If 	!_cPodter == "1"
	_lRet := .F.
	conout("------- [PODTER] EXCESSAO NA GERACAO AUTOMATICA NFe ENTRADA RETORNO DE TERCEIROS: PARAMETRO MV_XPDTER NAO HABILITADO ------- ["+Dtoc(Date())+"-"+TIME()+"]")
EndIf

//Validacao do MV_TPNRNFS (Define numeracao NF saida)
If 	!Alltrim(_cTpNrNfs) $ "1/2/3" //1-SX5 / 2-SXE/SXF / 3-SD9          
	_lRet := .F.  
	conout("------- [PODTER] EXCESSAO NA GERACAO AUTOMATICA NFe ENTRADA RETORNO DE TERCEIROS: PARAMETRO MV_TPNRNFS = "+_cTpNrNfs+" ESTA FORA DAS DEFINICOES PADROES POSSIVEIS: 1, 2 ou 3 ------- ["+Dtoc(Date())+"-"+TIME()+"]") 
EndIf  
                                               
//Validacao da especie da NF Entrada
SX5->(DbSelectArea("SX5"))
SX5->(DbSetOrder(1))
If	!SX5->(DbSeek(xFilial("SX5")+"42"+_cEspecie))
	_lRet := .F.       
	conout("------- [PODTER] EXCESSAO NA GERACAO AUTOMATICA NFe ENTRADA RETORNO DE TERCEIROS: PARAMETRO MV_XESPECI = "+_cEspecie+" DEFINIDO COM CHAVE NAO CONSTANTE NA SX5 TAB 42 ------- ["+Dtoc(Date())+"-"+TIME()+"]")         
EndIf

//Validacao do tipo da NF Entrada
If 	!Alltrim(_cTipoNF) $ "N/P/I/C/B/D" //N=Normal / P=NF de Compl. IPI / I=NF de Compl. ICMS / C=NF de Compl. Preco/Frete / B=NF de Beneficiamento / D=NF de Devolucao
	_lRet := .F.  
	conout("------- [PODTER] EXCESSAO NA GERACAO AUTOMATICA NFe ENTRADA RETORNO DE TERCEIROS: PARAMETRO MV_XTPDEVO = "+_cTipoNF+" ESTA FORA DAS DEFINICOES PADROES POSSIVEIS: P/I/C/B/D ------- ["+Dtoc(Date())+"-"+TIME()+"]") 
EndIf

//Validacao da TES 
SF4->(DbSelectArea("SF4"))
SF4->(DbSetOrder(1))

If 	SF4->(DbSeek(xFilial("SF4") + _cTesDev))
	
	//Verifica se TES de entrada ou saida
	If 	Val(_cTesDev) >= 501 
		
		_lRet := .F.  
		conout("------- [PODTER] EXCESSAO NA GERACAO AUTOMATICA NFe ENTRADA RETORNO DE TERCEIROS: PARAMETRO MV_XTESDEV DEFINIDO COM TES DE SAIDA: "+_cTesDev+" ------- ["+Dtoc(Date())+"-"+TIME()+"]")
	
	Else	
	         
		//Verifica se TES de entrada esta bloqueada
		If	SF4->F4_MSBLQL == "1"
			_lRet := .F.  
			conout("------- [PODTER] EXCESSAO NA GERACAO AUTOMATICA NFe ENTRADA RETORNO DE TERCEIROS: TES DE ENTRADA DEFINIDA NO PARAMETRO MV_XTESDEV ESTA BLOQUEADA: "+_cTesDev+" ------- ["+Dtoc(Date())+"-"+TIME()+"]")
		EndIf
		
		//Verifica se TES de entrada controla poder de terceiro
		If	!SF4->F4_PODER3 == "D"
			_lRet := .F.   
			conout("------- [PODTER] EXCESSAO NA GERACAO AUTOMATICA NFe ENTRADA RETORNO DE TERCEIROS: TES DE ENTRADA DEFINIDA NO PARAMETRO MV_XTESDEV NAO CONTROLA PODER DE TERCEIROS DEVOLUCAO: "+_cTesDev+" ------- ["+Dtoc(Date())+"-"+TIME()+"]")
		EndIf 
	
	EndIf
	  
Else      
	_lRet := .F.   
	conout("------- [PODTER] EXCESSAO NA GERACAO AUTOMATICA NFe ENTRADA RETORNO DE TERCEIROS: TES DEFINIDA NO PARAMETRO MV_XTESDEV NAO ENCONTRADA NO CADASTRO - TABELA SF4: "+_cTesDev+" ------- ["+Dtoc(Date())+"-"+TIME()+"]")
EndIf

Return(_lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPODTER2   บAutor  ณAldoney Dias        บ Data ณ  20/05/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณVerifica se existe saldo do SB6                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ 
ฑฑบUso       ณ OPVS / Certisign                                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/                  

User Function PODTER2()

Local _cQuery2   := "" 	//Soma de itens SB6 pendentes de retorno           

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณSelecao dos itens na SB6 pendentes de retorno                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
_cQuery2 := "SELECT	SUM(SB6.B6_SALDO) AS SALDO "
_cQuery2 += "FROM " + RetSqlName("SB6") + " SB6 "
_cQuery2 += "WHERE SB6.B6_FILIAL = '" + xFilial("SB6") + "' "    
_cQuery2 += "AND SB6.B6_PRODUTO = '" + _cPrdAtu + "' "
_cQuery2 += "AND SB6.B6_CLIFOR = '" + _cForAtu + "' "
_cQuery2 += "AND SB6.B6_LOJA = '" + _cLojAtu + "' " 
_cQuery2 += "AND SB6.D_E_L_E_T_ = '' "  
_cQuery2 += "AND SB6.B6_TPCF = 'F' "
_cQuery2 += "AND SB6.B6_PODER3 = 'R' "
_cQuery2 += "AND SB6.B6_SALDO > 0 "

_cQuery2 := ChangeQuery(_cQuery2)

If	Select("SB6SLD") > 0  
	SB6SLD->(dbCloseArea())
EndIf  
	
TCQUERY _cQuery2 NEW ALIAS "SB6SLD"

DbSelectArea("SB6SLD") 
SB6SLD->(DbGoTop())

Return(SB6SLD->SALDO)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPODTER3   บAutor  ณAldoney Dias        บ Data ณ  20/05/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณIncrementa array com itens da NF Entrada retorno terceiros  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ 
ฑฑบUso       ณ OPVS / Certisign                                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/                  

User Function PODTER3()

Local _cQuery2   := "" 	//Selecao de itens SB6 pendentes de retorno           
Local _nQtDNFOri := 0  	//Quantidade devolvida na NF Origem
Local _aLinha    := {} 	//Array com itens das linhas da SD2 
Local _nQtArray	 := Len(_aQtdDev) //Quantidade de registros no array _aQtdDev   

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณSelecao dos itens na SB6 pendentes de retorno                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
_cQuery2 := "SELECT	DISTINCT SB6.B6_CLIFOR AS FORNECE, SB6.B6_LOJA AS LOJA, SB6.B6_PRODUTO AS PRODUTO, "
_cQuery2 += "SB6.B6_EMISSAO AS EMISSAO, SB6.B6_DOC AS NFORI, SB6.B6_SERIE AS SERIEORI, SB6.B6_SALDO AS SALDO, "
_cQuery2 += "SD2.D2_ITEM AS ITEM, SD2.D2_PRCVEN AS PRCVEN, SD2.D2_NUMSEQ AS NUMSEQ, SB6.B6_IDENT AS IDENT "
_cQuery2 += "FROM " + RetSqlName("SB6") + " SB6 "
_cQuery2 += "INNER JOIN " + RetSqlName("SD2") + " SD2 ON SD2.D2_FILIAL = '" + xFilial("SD2") + "' "
_cQuery2 += "AND SB6.B6_IDENT = SD2.D2_IDENTB6 "
_cQuery2 += "AND SD2.D_E_L_E_T_ = '' "
_cQuery2 += "WHERE SB6.B6_FILIAL = '" + xFilial("SB6") + "' "
_cQuery2 += "AND SB6.B6_PRODUTO = '" + _cPrdAtu + "' "
_cQuery2 += "AND SB6.B6_CLIFOR = '" + _cForAtu + "' "
_cQuery2 += "AND SB6.B6_LOJA = '" + _cLojAtu + "' "   
_cQuery2 += "AND SB6.B6_TPCF = 'F' "
_cQuery2 += "AND SB6.B6_PODER3 = 'R' "
_cQuery2 += "AND SB6.B6_SALDO > 0 "   
_cQuery2 += "AND SB6.D_E_L_E_T_ = '' "
_cQuery2 += "ORDER BY SB6.B6_CLIFOR, SB6.B6_LOJA, SB6.B6_PRODUTO, SB6.B6_EMISSAO, SB6.B6_DOC, SB6.B6_SERIE, SB6.B6_IDENT "

_cQuery2 := ChangeQuery(_cQuery2)

If	Select("SB6REG") > 0  
	SB6REG->(dbCloseArea())
EndIf  
	
TCQUERY _cQuery2 NEW ALIAS "SB6REG"

DbSelectArea("SB6REG") 
SB6REG->(DbGoTop())
			
While SB6REG->(!Eof()) .and. _nSldDevZ5 > 0 .and. Len(_aItens) < 990  

	//Atualiza controle de quantidade nas variaveis
	If	_nSldDevZ5 <= SB6REG->SALDO 
  		_nQtDNFOri := _nSldDevZ5  
  		_nSldDevZ5 := 0  
 	Else   
  		_nQtDNFOri := SB6REG->SALDO  
  		_nSldDevZ5 := _nSldDevZ5-SB6REG->SALDO
  	EndIf
		    				
   	//Adiciona linha na NF
  	AAdd( _aLinha, { "D1_DOC"    	, _cNumDev				   		, Nil } )	
	AAdd( _aLinha, { "D1_SERIE"    	, _cSerie				   		, Nil } )	
	AAdd( _aLinha, { "D1_FORNECE"  	, SB6REG->FORNECE		   		, Nil } )
	AAdd( _aLinha, { "D1_LOJA"    	, SB6REG->LOJA	    	  		, Nil } )
	AAdd( _aLinha, { "D1_COD"    	, SB6REG->PRODUTO 	     		, Nil } )
	AAdd( _aLinha, { "D1_NFORI"		, SB6REG->NFORI			  		, Nil } )
	AAdd( _aLinha, { "D1_SERIORI"	, SB6REG->SERIEORI		 		, Nil } )
	AAdd( _aLinha, { "D1_ITEMORI"  	, SB6REG->ITEM 	    	 		, Nil } )
	AAdd( _aLinha, { "D1_QUANT"		, _nQtDNFOri			 		, Nil } )
	AAdd( _aLinha, { "D1_VUNIT"		, SB6REG->PRCVEN				, Nil } )
	AAdd( _aLinha, { "D1_TOTAL"		, _nQtDNFOri * SB6REG->PRCVEN	, Nil } )
	AAdd( _aLinha, { "D1_TES"		, _cTesDev				 		, Nil } )
	AAdd( _aLinha, { "D1_IDENTB6"	, SB6REG->NUMSEQ		  		, Nil } )
	                       
	AAdd( _aItens,_aLinha)
	_aLinha := {}
	_nSldB6 -= _nQtDNFOri         
	
	//Se ultimo item for igual anterior, entao soma, senao cria registro
	If	_nQtArray > 0
		If	_aQtdDev[_nQtArray][1]+_aQtdDev[_nQtArray][2]+_aQtdDev[_nQtArray][3] ==  SB6REG->FORNECE+SB6REG->LOJA+SB6REG->PRODUTO
			_aQtdDev[_nQtArray][4] += _nQtDNFOri  	
		Else
			AAdd(_aQtdDev,{SB6REG->FORNECE,SB6REG->LOJA,SB6REG->PRODUTO,_nQtDNFOri})
		EndIf
	Else             
		AAdd(_aQtdDev,{SB6REG->FORNECE,SB6REG->LOJA,SB6REG->PRODUTO,_nQtDNFOri})
	EndIf
		
	SB6REG->(DbSkip()) 
	
EndDo

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPODTER4   บAutor  ณAldoney Dias        บ Data ณ  20/05/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณSequencia de acoes na emissao da NF Entrada.                บฑฑ 
ฑฑบ          ณ1) Emissao NFe                                              บฑฑ 
ฑฑบ          ณ2) Marcacao dos registros SZ5 como processados              บฑฑ
ฑฑบ          ณ3) Transmissao NFe ao SEFAZ                                 บฑฑ
ฑฑบ          ณ4) Impressao DANFE ref. NFe                                 บฑฑ
ฑฑบ          ณ5) Marcacao flag de impressao na tabela SF1                 บฑฑ   
ฑฑบ          ณ6) Adicao de dados no array para posterior envio de e-mail  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ 
ฑฑบUso       ณ OPVS / Certisign                                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/                  

User Function PODTER4()

Local _lRetTrans	:= .F. 	//Retorno da transmissao da NFe  
Local _lRetImpre	:= .F. 	//Retorno da impressao da NFe
Local _cPDCod		:= ""  
Local _cPDDescr		:= ""
    
Begin 	Transaction
		U_PODTER5() //Emissao
End 	Transaction     

If	GetMV("MV_XTRFSFZ",,.T.)	
	_lRetTrans := U_TRFNFEAT("SF1",_cNumDev,_cSerie,_cTipoNF,_cForAtu,_cLojAtu,_nRecnoF1) //Tenta transmitir a NFe de Entrada ao SEFAZ 
EndIf

//Se transmitiu, tenta imprimir DANFE referente a NFe de Entrada 
/*
If	GetMV("MV_XPRTNFE",,.F.)
	If	_lRetTrans	
		_lRetImpre := U_PRTNFEAT("SF1",_cNumDev,_cSerie,_cTipoNF,_cForAtu,_cLojAtu,_nRecnoF1) 
	EndIf   
EndIf
*/
   
//Se imprimiu DANFE corretamente, grava flag de impressao
If	_lRetImpre    
	SF1->(DbGoto(_nRecnoF1))
	SF1->(Reclock("SF1"),.F.)
	SF1->F1_FIMP := "S"
	SF1->(MsUnLock())
	_nRecnoF1 := 0
EndIf

//Incrementa array com dados para emissao de email, se destinatarios parametrizados
If 	!Empty(GetMV("MV_XNFETER"))   
	
	DbSelectArea("SZ8")
	SZ8->(DbSetOrder(2))
	SZ8->(DbGoTop())
	
	If	SZ8->(DbSeek(xFilial("SZ8")+_cForAtu+_cLojAtu))
		_cPDCod 	:= SZ8->Z8_COD
		_cPDDescr 	:= Alltrim(SZ8->Z8_DESC)
	EndIf
	
	AAdd( _aEmail, { _cNumDev, _cSerie	, _cForAtu, _cLojAtu,Alltrim(Posicione("SA2",1,xFilial("SA2")+_cForAtu+_cLojAtu,"A2_NOME")), _cPDCod, _cPDDescr} )

	SZ8->(DbCloseArea())
EndIf

//Zera variaveis para proxima NF
_aItens 	:= {}
_aRecnoZ5 	:= {}  

If	SZ5REG->(!EOF()) //Se nao for fim de arquivo, atualiza numero para proxima NF	
	_cNumDev  	:= PadR(NxtSX5Nota(_cSerie, .T., _cTpNrNfs), TamSX3("F1_DOC")[1])
EndIf

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPODTER5   บAutor  ณAldoney Dias        บ Data ณ  20/05/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณEmite NF Entrada retorno terceiros.                         บฑฑ 
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ 
ฑฑบUso       ณ OPVS / Certisign                                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function PODTER5() 
  
Local _aCab	 := {}	//Cabecalho da NF de Entrada
Local _lRet	 := .T.     

//Monta o cabecalho com campos obrigatorios para a NF Entrada
AAdd( _aCab, { "F1_DOC"    , _cNumDev	, Nil } )	// Numero da NF
AAdd( _aCab, { "F1_SERIE"  , _cSerie	, Nil } )	// Serie da NF
AAdd( _aCab, { "F1_FORMUL" , "S"		, Nil } )  	// Formulario proprio
AAdd( _aCab, { "F1_EMISSAO", dDataBase	, Nil } )  	// Data emissao
AAdd( _aCab, { "F1_FORNECE", _cForAtu	, Nil } )	// Codigo do Cliente
AAdd( _aCab, { "F1_LOJA"   , _cLojAtu  	, Nil } )	// Loja do Cliente
AAdd( _aCab, { "F1_TIPO"   , _cTipoNF	, Nil } )	// Tipo da NF
AAdd( _aCab, { "F1_ESPECIE", _cEspecie	, Nil } )	// Especie da NF

conout(" ------ [GARA130] INICIO: GERACAO NF DEVOLUCAO PODER3 "+_cSerie+" | "+_cNumDev+" | "+_cForAtu+" | "+_cLojAtu+" | "+" ------- ["+Dtoc(Date())+"-"+TIME()+"]")

MSExecAuto({|x,y,z| MATA103(x,y,z)}, _aCab, _aItens, 3) //ExecAuto para emissao da NFe de Entrada retorno de terceiros   

If 	lMsErroAuto
	conout(" ------ [GARA130] INCONSISTENCIA NA DEVOLUCAO DO PODER DE TERCEIROS ------- ["+Dtoc(Date())+"-"+TIME()+"]")
	DisarmTransaction()
	MostraErro()
	_lRet := .F.
Else
	conout(" ------ [GARA130] FIM: GERACAO COM SUCESSO DA NF DEVOLUCAO PODER3 "+_cSerie+" | "+_cNumDev+" | "+_cForAtu+" | "+_cLojAtu+" | "+" ------- ["+Dtoc(Date())+"-"+TIME()+"]")
	_lRet := .T.	
EndIf                

_nRecnoF1 := SF1->(Recno()) //Guarda recno gravado para posterior marcacao de impressao
		
Return(_lRet)               

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPODTER6   บAutor  ณAldoney Dias        บ Data ณ  20/05/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณEnvio de email com NFs Entrada emitidas                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ 
ฑฑบUso       ณ OPVS / Certisign                                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
                                       
User Function PODTER6()

Local _cDest 	:= GetMV("MV_XNFETER")
Local _cCopia	:= ""
Local _cAssunto	:= Iif(Len(_aEmail) = 1,"NF de Entrada retorno de terceiro emitida automaticamente","NFs de Entrada retorno de terceiros emitidas automaticamente") 
Local _cMensagem:= ""

_cMensagem := "<html><head><meta http-equiv=Content-Type content='text/html; charset=windows-1252'><meta name=Generator content='Microsoft Word 12 (filtered)'>"
_cMensagem += "<style><!--/* Font Definitions */@font-face{font-family:'Cambria Math';panose-1:2 4 5 3 5 4 6 3 2 4;}@font-face"
_cMensagem += "{font-family:Calibri;panose-1:2 15 5 2 2 2 4 3 2 4;}/* Style Definitions */p.MsoNormal, li.MsoNormal, div.MsoNormal"
_cMensagem += "{margin-top:0cm;margin-right:0cm;margin-bottom:10.0pt;margin-left:0cm;line-height:115%;font-size:11.0pt;font-family:'Calibri','sans-serif';}"
_cMensagem += ".MsoChpDefault{font-size:10.0pt;}@page WordSection1{size:595.3pt 841.9pt;margin:70.85pt 3.0cm 70.85pt 3.0cm;}"
_cMensagem += "div.WordSection1{page:WordSection1;}--></style></head><body lang=PT-BR><div class=WordSection1>"
_cMensagem += "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;line-height:normal'><span style='font-size:10.0pt'>"

//Mensagem inicial corpo email
If	Len(_aEmail) = 1                                                                        
	_cMensagem += "Foi emitida a seguinte Nota Fiscal de Entrada retornando poder de terceiro nesta data:"
Else
	_cMensagem += "Foram emitidas as seguintes Notas Fiscais de Entrada retornando poder de terceiros nesta data:" 
EndIf

_cMensagem += "</span></p><p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;line-height:normal'><span style='font-size:10.0pt'>&nbsp;</span></p>"
_cMensagem += "<table class=MsoTableGrid border=1 cellspacing=0 cellpadding=0 style='border-collapse:collapse;border:none'>"

//cabecalho tabela corpo email
_cMensagem += "<tr>"
_cMensagem += "<td width=115 valign=top style='width:86.4pt;border:solid windowtext 1.0pt;background:#B6DDE8;padding:0cm 5.4pt 0cm 5.4pt'><p class=MsoNormal align=center style='margin-bottom:0cm;margin-bottom:.0001pt;text-align:center;line-height:normal'><b><span style='font-size:10.0pt'>Nota Fiscal</span></b></p></td>"
_cMensagem += "<td width=115 valign=top style='width:86.45pt;border:solid windowtext 1.0pt;border-left:none;background:#B6DDE8;padding:0cm 5.4pt 0cm 5.4pt'><p class=MsoNormal align=center style='margin-bottom:0cm;margin-bottom:.0001pt;text-align:center;line-height:normal'><b><span style='font-size:10.0pt'>Serie</span></b></p></td>"       
_cMensagem += "<td width=115 valign=top style='width:86.45pt;border:solid windowtext 1.0pt;border-left:none;background:#B6DDE8;padding:0cm 5.4pt 0cm 5.4pt'><p class=MsoNormal align=center style='margin-bottom:0cm;margin-bottom:.0001pt;text-align:center;line-height:normal'><b><span style='font-size:10.0pt'>Fornecedor</span></b></p></td>"
_cMensagem += "<td width=115 valign=top style='width:86.45pt;border:solid windowtext 1.0pt;border-left:none;background:#B6DDE8;padding:0cm 5.4pt 0cm 5.4pt'><p class=MsoNormal align=center style='margin-bottom:0cm;margin-bottom:.0001pt;text-align:center;line-height:normal'><b><span style='font-size:10.0pt'>Loja</span></b></p></td>"
_cMensagem += "<td width=115 valign=top style='width:86.45pt;border:solid windowtext 1.0pt;border-left:none;background:#B6DDE8;padding:0cm 5.4pt 0cm 5.4pt'><p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;line-height:normal'><b><span style='font-size:10.0pt'>Nome</span></b></p></td>"
_cMensagem += "<td width=115 valign=top style='width:86.45pt;border:solid windowtext 1.0pt;border-left:none;background:#B6DDE8;padding:0cm 5.4pt 0cm 5.4pt'><p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;line-height:normal'><b><span style='font-size:10.0pt'>PD</span></b></p></td>"
_cMensagem += "</tr>"
               
//itens tabela corpo email
For _nx := 1 to Len(_aEmail)
	_cMensagem += "<tr>"
	_cMensagem += "<td width=115 valign=top style='width:86.45pt;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;padding:0cm 5.4pt 0cm 5.4pt'><p class=MsoNormal align=center style='margin-bottom:0cm;margin-bottom:.0001pt;text-align:center;line-height:normal'><span style='font-size:10.0pt'>"+_aEmail[_nx][1]+"</span></p></td>"
	_cMensagem += "<td width=115 valign=top style='width:86.45pt;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;padding:0cm 5.4pt 0cm 5.4pt'><p class=MsoNormal align=center style='margin-bottom:0cm;margin-bottom:.0001pt;text-align:center;line-height:normal'><span style='font-size:10.0pt'>"+_aEmail[_nx][2]+"</span></p></td>"
	_cMensagem += "<td width=115 valign=top style='width:86.45pt;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;padding:0cm 5.4pt 0cm 5.4pt'><p class=MsoNormal align=center style='margin-bottom:0cm;margin-bottom:.0001pt;text-align:center;line-height:normal'><span style='font-size:10.0pt'>"+_aEmail[_nx][3]+"</span></p></td>"
	_cMensagem += "<td width=115 valign=top style='width:86.45pt;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;padding:0cm 5.4pt 0cm 5.4pt'><p class=MsoNormal align=center style='margin-bottom:0cm;margin-bottom:.0001pt;text-align:center;line-height:normal'><span style='font-size:10.0pt'>"+_aEmail[_nx][4]+"</span></p></td>"
	_cMensagem += "<td width=115 valign=top style='width:86.45pt;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;padding:0cm 5.4pt 0cm 5.4pt'><p class=MsoNormal align=center style='margin-bottom:0cm;margin-bottom:.0001pt;text-align:center;line-height:normal'><span style='font-size:10.0pt'>"+_aEmail[_nx][5]+"</span></p></td>"     
	_cMensagem += "<td width=115 valign=top style='width:86.45pt;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;padding:0cm 5.4pt 0cm 5.4pt'><p class=MsoNormal align=center style='margin-bottom:0cm;margin-bottom:.0001pt;text-align:center;line-height:normal'><span style='font-size:10.0pt'>"+_aEmail[_nx][6]+"</span></p></td>"
	_cMensagem += "<td width=115 valign=top style='width:86.45pt;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;padding:0cm 5.4pt 0cm 5.4pt'><p class=MsoNormal align=center style='margin-bottom:0cm;margin-bottom:.0001pt;text-align:center;line-height:normal'><span style='font-size:10.0pt'>"+_aEmail[_nx][7]+"</span></p></td>"
	_cMensagem += "</tr>"
Next _nx

_cMensagem += "</table><p class=MsoNormal align=center style='margin-bottom:0cm;margin-bottom:.0001pt;text-align:center;line-height:normal'><span style='font-size:10.0pt'>&nbsp;</span></p></div></body></html>"

U_MandEmail(_cMensagem,_cDest,_cAssunto,"",_cCopia,"","") 

Return()