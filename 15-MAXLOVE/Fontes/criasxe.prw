#include "protheus.ch"
#include "topconn.ch"
  
/*/{Protheus.doc}P.E - CriaSXE
                    
    Ponto de entrada para retornar o pr�ximo n�mero que deve ser utilizado na inicializa��o da numera��o. Este ponto de entrada � recomendado
    para casos em que deseja-se alterar a regra padr�o de descoberta do pr�ximo n�mero.
    A execu��o deste ponto de entrada, ocorre em casos de perda das tabelas SXE/SXF ( vers�es legado ) e de reinicializa��o do License Server.
        
    @author: S�livan Sim�es Silva - Email: sulivansimoes@gmail.com
    @since : 15/10/2019
    @version : 1.0
    @param   : PARAMIXB, array, Vetor contendo as informa��es que poder�o ser utilizadas pelo P.E.
    @return  : cRet, caracter, N�mero que ser� utilizado pelo controle de numera��o.
               Caso seja retornado Nulo ( NIL ), a regra padr�o do sistema ser� aplicada. Esta fun��o nunca deve retornar uma string vazia.
                
    @Lik     : 1 - http://tdn.totvs.com/pages/releaseview.action?pageId=6815179      
               2 - https://centraldeatendimento.totvs.com/hc/pt-br/articles/360019303171-MP-ADVPL-CRIASXE-PARA-SOLUCIONAR-LACUNAS-NO-CONTROLE-DE-NUMERA%C3%87%C3%83O
                          
        
    @obs : MANUTEN��ES FEITAS NO C�DIGO:
    --------------------------------------------------------------------------------------------                   
    Vers�o gerada:
    Data:
    Respons�vel:
    Log: [Fale aqui o que foi feito]
    --------------------------------------------------------------------------------------------       
/*/               
  
user function CRIASXE()
    
    local aArea     := getArea()      
    Local cAlias_   := paramixb[1]
    local cCpoSx8   := paramixb[2]
    local cAlias_Sx8:= paramixb[3]
    local nOrdSX8   := paramixb[4]
    local aTabelas  := {}         //Tabelas que ir�o permitir a execu��o do P.E
    local cTabela   := ""         //Alias corrente que ir� permitir a execu��o do P.E.      
    local nCount    := 0                                                                    
    local cQuery    := ""         //Na query eu vejo o ultimo n�mero que t� no banco.
    local cProxNum  := Nil        //Retorno da fun��o.
                                                    
      
    ConOut("[u_CRIASXE] 01 - Entrou no ponto de entrada CRIASXE / Se nao tiver log entre mensagem 01 e 02, nao foi feito nada aqui!")      
        
            
       //Definindo as tabelas que ir�o executar o P.E / Caso precise executar em mais alguma s� adicionar no array e pronto..
       aTabelas := {"SL1","SC7"}
        
       //Percorro array e vejo se tabela corrente deve executar o P.E              
       for nCount := 1 to  len(aTabelas)
        
            if( cAlias_ $ aTabelas[nCount] )
                
                cTabela := aTabelas[nCount]
                                                                                                        
                ConOut("[u_CRIASXE] ->  TRATATIVA | Sera ajustado via P.E numeracao automatica: "+ cAlias_ + " - " +;
                        cCpoSx8 + " - " + cAlias_Sx8 + " - " + cValToChar(nOrdSX8) )           
                exit
            endif    
       next
              
       //Se a tabela corrente estiver na cole��o de tabelas E as vari�veis dos par�metros n�o estiverem com problema.
       if( !empty(cTabela) .AND.  ! ( empty(cAlias_) .AND. empty(cCpoSx8) ) )        
                                
            ConOut("[u_CRIASXE] ->  Antes de criar consulta para pegar ultimo numero do campo "+cCpoSx8 )  
            
            cQuery  := " SELECT MAX("+ cCpoSx8+ ") AS ULTIMO_NUM FROM "+ RetSqlName(cAlias_) +" AS TMP "
            cQuery  += " WHERE TMP.D_E_L_E_T_ = '' "
            cQuery  += " AND C7_NUM BETWEEN '996478' AND '999999' " 
                      
            cQuery := changeQuery(cQuery)
            TcQuery cQuery New Alias 'TMP_QRY'
            
            ConOut("[u_CRIASXE] ->  Depois de criar consulta para pegar ultimo n�mero do campo "+cCpoSx8 )                
            
            //Caso a query retorne ultimo n�mero
            if( !TMP_QRY->(eof() ) )
                                      
                cProxNum := soma1(TMP_QRY->ULTIMO_NUM) //pego ultimo c�digo e somo 1
                
                ConOut("[u_CRIASXE] ->  Proximo numero do campo  "+cCpoSx8+" sera "+cProxNum )             
            else
                
                ConOut("[u_CRIASXE] ->  A query veio vazia ou ocorreu algum problema, nao conseguiu incrementar o proximo numero do campo"+cCpoSx8 )                               
            endif
            
            TMP_QRY->( dbCloseArea() )                 
       endif
    
  
    ConOut("[u_CRIASXE] 02 - Encerrou taferas no ponto de entrada CRIASXE")  
    
    restArea( aArea )
    
return cProxNum
