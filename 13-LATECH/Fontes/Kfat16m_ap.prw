#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function Kfat16m()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("_NPOS,_CPROD,_NPRCVEN,_CTES,_NPRCMIN,_NCONDMED")
SetPrvt("_NCOND,_CSUPERIOR,_CAUXSUP,_ACOND,_I,_NMEDIA")
SetPrvt("_CREGIAO,")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ KFAT16M  ³ Autor ³                       ³ Data ³03/08/2002³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Valida Preco de Venda com o Preco Minimo - 07/28/42/56 DDL ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Kenia Industrias Texteis Ltda                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   Analista   ³  Data  ³             Motivo da Alteracao               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³        ³                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
/*/                                                            

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Processamento                                                             *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

_nPos       :=  Ascan(aHeader,{|x|Upper(Alltrim(x[2]))=="C6_PRODUTO"})
_cProd      :=  aCols[n,_nPos]

_nPos       :=  Ascan(aHeader,{|x|Upper(Alltrim(x[2]))=="C6_PRCVEN"})
_nPrcVen    :=  aCols[n,_nPos]

_nPos       :=  Ascan(aHeader,{|x|Upper(Alltrim(x[2]))=="C6_TES"})
_cTes       :=  aCols[n,_nPos]

_nPrcMin    :=  0
_nCondMed   :=  0
_nCond      :=  0

_cSuperior  :=  Alltrim(Subs(cUsuario,7,14))
_cAuxSup    :=  "Administrador Alberto Kadayan Rogerio Kadayan"

DbSelectArea("SF4")
DbSetOrder(1)
DbSeek(xFilial("SF4")+_cTes,.f.)

//----> VERIFICA SE O TES GERA FINANCEIRO
If Alltrim(SF4->F4_DUPLIC) $ "S"

    //----> VERIFICA SE E ADMINISTRADOR/ROGERIO
    If !_cSuperior $ _cAuxSup

        //----> POLITICA OUTROS
        If M->C5_PAPELETA $ "O"
            DbSelectArea("SZ2")
            DbSetOrder(1)
            If !DbSeek(xFilial("SZ2")+Subs(_cProd,1,3),.f.)
                If !DbSeek(xFilial("SZ2")+Alltrim(_cProd),.f.)
                    MsgBox("Atencao Sr(a) "+Alltrim(Subs(cUsuario,7,14))+", o produto "+Alltrim(_cProd)+" nao possui preco minimo cadastrado na Tabela de Precos Minimos por Artigo. Favor cadastrar o preco minimo do artigo para dar continuidade ao cadastramento do pedido.","Validacao Preco Minimo","Stop")
                    _nPrcVen    :=  0
					Return(_nPrcVen)
                EndIf
            EndIf
    
            DbSelectArea("SA1")
            DbSetOrder(1)
            DbSeek(xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI,.f.)
        
            _aCond := Condicao(1000,M->C5_CONDPAG,0)
   
            For _i := 1 to Len(_aCond)
        
                _nCond      :=  _aCond[_i,1] - dDataBase
    
                _nCondMed   :=  _nCondMed + _nCond
    
            Next
    
            _nCondMed := Int(_nCondMed / Len(_aCond))
    
            //----> REGIAO DE SAO PAULO
            If SA1->A1_EST $ "SP"

                //----> PRECO MINIMO BASE 07 DDL
                If _nCondMed >= 0 .And. _nCondMed <= 7
                    _nPrcMin    :=  Round(((SZ2->Z2_PSP07_1 / 4) * 0.90) * 0.95,2)
                    _nMedia     :=  07
    
                //----> PRECO MINIMO BASE 28 DDL
                ElseIf _nCondMed > 7 .And. _nCondMed <= 28
                    _nPrcMin    :=  Round(((SZ2->Z2_PSP28_1 / 4) * 0.90) * 0.95,2)
                    _nMedia     :=  28
            
                //----> PRECO MINIMO BASE 42 DDL
                ElseIf _nCondMed > 28 .And. _nCondMed <= 42
                    _nPrcMin    :=  Round(((SZ2->Z2_PSP42_1 / 4) * 0.90) * 0.95,2)
                    _nMedia     :=  42
    
                //----> PRECO MINIMO BASE 56 DDL
                ElseIf _nCondMed > 42 
                    _nPrcMin    :=  Round(((SZ2->Z2_PSP56_1 / 4) * 0.90) * 0.95,2)
                    _nMedia     :=  56
                EndIf
        
                _cRegiao    :=  "Sao Paulo"
        
            //----> REGIAO NORTE/NORDESTE
            ElseIf SA1->A1_EST $ "AC.AL.AM.BA.CE.DF.ES.GO.MA.MS.MT.PA.PB.PE.PI.RN.RO.RR.SE.TO"

                //----> PRECO MINIMO BASE 07 DDL
                If _nCondMed >= 0 .And. _nCondMed <= 7
                    _nPrcMin    :=  Round((((SZ2->Z2_PSP07_1 * 0.86) / 4) * 0.90) * 0.95,2)
                    _nMedia     :=  07
    
                //----> PRECO MINIMO BASE 28 DDL
                ElseIf _nCondMed > 7 .And. _nCondMed <= 28
                    _nPrcMin    :=  Round((((SZ2->Z2_PSP28_1 * 0.86) / 4) * 0.90) * 0.95,2)
                    _nMedia     :=  28
       
                //----> PRECO MINIMO BASE 42 DDL
                ElseIf _nCondMed > 28 .And. _nCondMed <= 42
                    _nPrcMin    :=  Round((((SZ2->Z2_PSP42_1 * 0.86) / 4) * 0.90) * 0.95,2)
                    _nMedia     :=  42
    
                //----> PRECO MINIMO BASE 56 DDL
                ElseIf _nCondMed > 42 
                    _nPrcMin    :=  Round((((SZ2->Z2_PSP56_1 * 0.86) / 4) * 0.90) * 0.95,2)
                    _nMedia     :=  56
                EndIf
    
                _cRegiao    :=  "Norte/Nordeste"
    
            //----> REGIAO SUL/SUDESTE   
            ElseIf SA1->A1_EST $ "MG.PR.RJ.RS.SC"

                //----> PRECO MINIMO BASE 07 DDL
                If _nCondMed >= 0 .And. _nCondMed <= 7
                    _nPrcMin    :=  Round((((SZ2->Z2_PSP07_1 * 0.92) / 4) * 0.90) * 0.95,2)
                    _nMedia     :=  07
    
                //----> PRECO MINIMO BASE 28 DDL
                ElseIf _nCondMed > 7 .And. _nCondMed <= 28
                    _nPrcMin    :=  Round((((SZ2->Z2_PSP28_1 * 0.92) / 4) * 0.90) * 0.95,2)
                    _nMedia     :=  28
        
                //----> PRECO MINIMO BASE 42 DDL
                ElseIf _nCondMed > 28 .And. _nCondMed <= 42
                    _nPrcMin    :=  Round((((SZ2->Z2_PSP42_1 * 0.92) / 4) * 0.90) * 0.95,2)
                    _nMedia     :=  42
        
                //----> PRECO MINIMO BASE 56 DDL
                ElseIf _nCondMed > 42 
                    _nPrcMin    :=  Round((((SZ2->Z2_PSP56_1 * 0.92) / 4) * 0.90) * 0.95,2)
                    _nMedia     :=  56
                EndIf
        
                _cRegiao    :=  "Sul/Sudeste"
        
            EndIf

        //----> POLITICA UNI
        ElseIf M->C5_PAPELETA $ "N"
            DbSelectArea("SZ2")
            DbSetOrder(1)
            If !DbSeek(xFilial("SZ2")+Subs(_cProd,1,3),.f.)
                If !DbSeek(xFilial("SZ2")+Alltrim(_cProd),.f.)
                    MsgBox("Atencao Sr(a) "+Alltrim(Subs(cUsuario,7,14))+", o produto "+Alltrim(_cProd)+" nao possui preco minimo cadastrado na Tabela de Precos Minimos por Artigo. Favor cadastrar o preco minimo do artigo para dar continuidade ao cadastramento do pedido.","Validacao Preco Minimo","Stop")
                    _nPrcVen    :=  0
					Return(_nPrcVen)
                EndIf
            EndIf
    
            DbSelectArea("SA1")
            DbSetOrder(1)
            DbSeek(xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI,.f.)
    
            _aCond := Condicao(1000,M->C5_CONDPAG,0)

            For _i := 1 to Len(_aCond)
    
                _nCond      :=  _aCond[_i,1] - dDataBase

                _nCondMed   :=  _nCondMed + _nCond
    
            Next

            _nCondMed := Int(_nCondMed / Len(_aCond))

            //----> REGIAO DE SAO PAULO
            If SA1->A1_EST $ "SP"

                //----> PRECO MINIMO BASE 07 DDL
                If _nCondMed >= 0 .And. _nCondMed <= 7
                    _nPrcMin    :=  Round((SZ2->Z2_PSP07_1) * 0.90,2)
                    _nMedia     :=  07
        
                //----> PRECO MINIMO BASE 28 DDL
                ElseIf _nCondMed > 7 .And. _nCondMed <= 28
                    _nPrcMin    :=  Round((SZ2->Z2_PSP28_1) * 0.90,2)
                    _nMedia     :=  28
        
                //----> PRECO MINIMO BASE 42 DDL
                ElseIf _nCondMed > 28 .And. _nCondMed <= 42
                    _nPrcMin    :=  Round((SZ2->Z2_PSP42_1) * 0.90,2)
                    _nMedia     :=  42
        
                //----> PRECO MINIMO BASE 56 DDL
                ElseIf _nCondMed > 42 
                    _nPrcMin    :=  Round((SZ2->Z2_PSP56_1) * 0.90,2)
                    _nMedia     :=  56
                EndIf
    
                _cRegiao    :=  "Sao Paulo"
    
            //----> REGIAO NORTE/NORDESTE
            ElseIf SA1->A1_EST $ "AC.AL.AM.BA.CE.DF.ES.GO.MA.MS.MT.PA.PB.PE.PI.RN.RO.RR.SE.TO"

                //----> PRECO MINIMO BASE 07 DDL
                If _nCondMed >= 0 .And. _nCondMed <= 7
                    _nPrcMin    :=  Round((SZ2->Z2_PSP07_1 * 0.86) * 0.90,2)
                    _nMedia     :=  07
    
                //----> PRECO MINIMO BASE 28 DDL
                ElseIf _nCondMed > 7 .And. _nCondMed <= 28
                    _nPrcMin    :=  Round((SZ2->Z2_PSP28_1 * 0.86) * 0.90,2)
                    _nMedia     :=  28
    
                //----> PRECO MINIMO BASE 42 DDL
                ElseIf _nCondMed > 28 .And. _nCondMed <= 42
                    _nPrcMin    :=  Round((SZ2->Z2_PSP42_1 * 0.86) * 0.90,2)
                    _nMedia     :=  42
            
                //----> PRECO MINIMO BASE 56 DDL
                ElseIf _nCondMed > 42 
                    _nPrcMin    :=  Round((SZ2->Z2_PSP56_1 * 0.86) * 0.90,2)
                    _nMedia     :=  56
                EndIf
    
                _cRegiao    :=  "Norte/Nordeste"
        
            //----> REGIAO SUL/SUDESTE   
            ElseIf SA1->A1_EST $ "MG.PR.RJ.RS.SC"

                //----> PRECO MINIMO BASE 07 DDL
                If _nCondMed >= 0 .And. _nCondMed <= 7
                    _nPrcMin    :=  Round((SZ2->Z2_PSP07_1 * 0.92) * 0.90,2)
                    _nMedia     :=  07

                //----> PRECO MINIMO BASE 28 DDL
                ElseIf _nCondMed > 7 .And. _nCondMed <= 28
                    _nPrcMin    :=  Round((SZ2->Z2_PSP28_1 * 0.92) * 0.90,2)
                    _nMedia     :=  28

                //----> PRECO MINIMO BASE 42 DDL
                ElseIf _nCondMed > 28 .And. _nCondMed <= 42
                    _nPrcMin    :=  Round((SZ2->Z2_PSP42_1 * 0.92) * 0.90,2)
                    _nMedia     :=  42
    
                //----> PRECO MINIMO BASE 56 DDL
                ElseIf _nCondMed > 42 
                    _nPrcMin    :=  Round((SZ2->Z2_PSP56_1 * 0.92) * 0.90,2)
                    _nMedia     :=  56
                EndIf
    
                _cRegiao    :=  "Sul/Sudeste"
    
            EndIf
    
        //----> POLITICA UM
        ElseIf M->C5_PAPELETA $ "S"
            DbSelectArea("SZ2")
            DbSetOrder(1)
            If !DbSeek(xFilial("SZ2")+Subs(_cProd,1,3),.f.)
                If !DbSeek(xFilial("SZ2")+Alltrim(_cProd),.f.)
                    MsgBox("Atencao Sr(a) "+Alltrim(Subs(cUsuario,7,14))+", o produto "+Alltrim(_cProd)+" nao possui preco minimo cadastrado na Tabela de Precos Minimos por Artigo. Favor cadastrar o preco minimo do artigo para dar continuidade ao cadastramento do pedido.","Validacao Preco Minimo","Stop")
                    _nPrcVen    :=  0
					Return(_nPrcVen)
                EndIf
            EndIf
        
            DbSelectArea("SA1")
            DbSetOrder(1)
            DbSeek(xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI,.f.)
    
            _aCond := Condicao(1000,M->C5_CONDPAG,0)
        
            For _i := 1 to Len(_aCond)
        
                _nCond      :=  _aCond[_i,1] - dDataBase
        
                _nCondMed   :=  _nCondMed + _nCond
    
            Next
    
            _nCondMed := Int(_nCondMed / Len(_aCond))
    
            //----> REGIAO DE SAO PAULO
            If SA1->A1_EST $ "SP"

                //----> PRECO MINIMO BASE 07 DDL
                If _nCondMed >= 0 .And. _nCondMed <= 7
                    _nPrcMin    :=  Round(((SZ2->Z2_PSP07_1 ) * 0.90) * 0.90,2)
                    _nMedia     :=  07
    
                //----> PRECO MINIMO BASE 28 DDL
                ElseIf _nCondMed > 7 .And. _nCondMed <= 28
                    _nPrcMin    :=  Round(((SZ2->Z2_PSP28_1 ) * 0.90) * 0.90,2)
                    _nMedia     :=  28
    
                //----> PRECO MINIMO BASE 42 DDL
                ElseIf _nCondMed > 28 .And. _nCondMed <= 42
                    _nPrcMin    :=  Round(((SZ2->Z2_PSP42_1 ) * 0.90) * 0.90,2)
                    _nMedia     :=  42

                //----> PRECO MINIMO BASE 56 DDL
                ElseIf _nCondMed > 42 
                    _nPrcMin    :=  Round(((SZ2->Z2_PSP56_1 ) * 0.90) * 0.90,2)
                    _nMedia     :=  56
                EndIf

                _cRegiao    :=  "Sao Paulo"

            //----> REGIAO NORTE/NORDESTE
            ElseIf SA1->A1_EST $ "AC.AL.AM.BA.CE.DF.ES.GO.MA.MS.MT.PA.PB.PE.PI.RN.RO.RR.SE.TO"

                //----> PRECO MINIMO BASE 07 DDL
                If _nCondMed >= 0 .And. _nCondMed <= 7
                    _nPrcMin    :=  Round(((SZ2->Z2_PSP07_1 * 0.86) * 0.90) * 0.90,2)
                    _nMedia     :=  07
    
                //----> PRECO MINIMO BASE 28 DDL
                ElseIf _nCondMed > 7 .And. _nCondMed <= 28
                    _nPrcMin    :=  Round(((SZ2->Z2_PSP28_1 * 0.86) * 0.90) * 0.90,2)
                    _nMedia     :=  28
    
                //----> PRECO MINIMO BASE 42 DDL
                ElseIf _nCondMed > 28 .And. _nCondMed <= 42
                    _nPrcMin    :=  Round(((SZ2->Z2_PSP42_1 * 0.86) * 0.90) * 0.90,2)
                    _nMedia     :=  42
    
                //----> PRECO MINIMO BASE 56 DDL
                ElseIf _nCondMed > 42 
                    _nPrcMin    :=  Round(((SZ2->Z2_PSP56_1 * 0.86) * 0.90) * 0.90,2)
                    _nMedia     :=  56
                EndIf
    
                _cRegiao    :=  "Norte/Nordeste"
    
            //----> REGIAO SUL/SUDESTE   
            ElseIf SA1->A1_EST $ "MG.PR.RJ.RS.SC"

                //----> PRECO MINIMO BASE 07 DDL
                If _nCondMed >= 0 .And. _nCondMed <= 7
                    _nPrcMin    :=  Round(((SZ2->Z2_PSP07_1 * 0.92) * 0.90) * 0.90,2)
                    _nMedia     :=  07

                //----> PRECO MINIMO BASE 28 DDL
                ElseIf _nCondMed > 7 .And. _nCondMed <= 28
                    _nPrcMin    :=  Round(((SZ2->Z2_PSP28_1 * 0.92) * 0.90) * 0.90,2)
                    _nMedia     :=  28
    
                //----> PRECO MINIMO BASE 42 DDL
                ElseIf _nCondMed > 28 .And. _nCondMed <= 42
                    _nPrcMin    :=  Round(((SZ2->Z2_PSP42_1 * 0.92) * 0.90) * 0.90,2)
                    _nMedia     :=  42
    
                //----> PRECO MINIMO BASE 56 DDL
                ElseIf _nCondMed > 42 
                    _nPrcMin    :=  Round(((SZ2->Z2_PSP56_1 * 0.92) * 0.90) * 0.90,2)
                    _nMedia     :=  56
                EndIf
    
                _cRegiao    :=  "Sul/Sudeste"
    
            EndIf
        EndIf
    
        //----> VERIFICA SE O PRECO DIGITADO ESTA ABAIXO DO PRECO MINIMO
        If _nPrcVen < _nPrcMin

            MsgBox("Atencao Sr(a) "+Alltrim(Subs(cUsuario,7,14))+", o preco de venda informado esta abaixo do preco minimo calculado para a regiao "+Alltrim(_cRegiao)+" e condicao media "+StrZero(_nMedia,2)+" DDL. O sistema assumira o preco minimo de "+Transform(_nPrcMin,'@EB 999,999.99')+" para o produto "+Alltrim(_cProd)+".","Validacao Preco Minimo","Stop")

            _nPrcVen    :=  Round(_nPrcMin,2)
        EndIf

    EndIf
EndIf

Return(_nPrcVen)

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Fim do Programa                                                           *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
