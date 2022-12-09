#Include "PROTHEUS.CH"

User Function CSATF099()

Processa({||RunProc()},"Corrige Depreciação Legado")

return

Static Function RunProc()

dbSelectArea("SN3")
dbSetOrder(1)
dbGoTop()
ProcRegua(RecCount())

While !Eof()
    
    IncProc("Processando o SN3 "+SN3->N3_CBASE+" - "+SN3->N3_ITEM+" - "+SN3->N3_TIPO+" - "+StrZero(Recno(),10))

    If !SN3->N3_FILIAL$"02"
        dbSelectArea("SN3")
        dbSkip()
        Loop
    EndIf

    RecLock("SN3",.f.)
    SN3->N3_VRDBAL1 := SN3->N3_VRDACM1
    SN3->N3_VRDBAL2 := SN3->N3_VRDACM2
    SN3->N3_VRDBAL3 := SN3->N3_VRDACM3
    SN3->N3_VRDBAL4 := SN3->N3_VRDACM4
    SN3->N3_VRDBAL5 := SN3->N3_VRDACM5
    MsUnLock()


    dbSelectArea("SN4")
    dbSetOrder(1)

    //ProcRegua(RecCount())

    If dbSeek(SN3->(N3_FILIAL+N3_CBASE+N3_ITEM+N3_TIPO),.F.)


        While !Eof() .and. SN4->(N4_FILIAL+N4_CBASE+N4_ITEM+N4_TIPO) ==  SN3->(N3_FILIAL+N3_CBASE+N3_ITEM+N3_TIPO)

            //IncProc("Processando o SN4 "+SN4->N4_CBASE+" - "+SN4->N4_ITEM+" - "+SN4->N4_TIPO+" - "+StrZero(Recno(),10))
  
            If SN4->N4_DATA < SN3->N3_DINDEPR

                dbSelectArea("SN3")                
                RecLock("SN3",.f.)
                SN3->N3_VRDBAL1 := SN3->N3_VRDBAL1 - SN4->N4_VLROC1
                SN3->N3_VRDBAL2 := SN3->N3_VRDBAL2 - SN4->N4_VLROC2
                SN3->N3_VRDBAL3 := SN3->N3_VRDBAL3 - SN4->N4_VLROC3
                SN3->N3_VRDBAL4 := SN3->N3_VRDBAL4 - SN4->N4_VLROC4
                SN3->N3_VRDBAL5 := SN3->N3_VRDBAL5 - SN4->N4_VLROC5
                SN3->N3_VRDACM1 := SN3->N3_VRDACM1 - SN4->N4_VLROC1
                SN3->N3_VRDACM2 := SN3->N3_VRDACM2 - SN4->N4_VLROC2
                SN3->N3_VRDACM3 := SN3->N3_VRDACM3 - SN4->N4_VLROC3
                SN3->N3_VRDACM4 := SN3->N3_VRDACM4 - SN4->N4_VLROC4
                SN3->N3_VRDACM5 := SN3->N3_VRDACM5 - SN4->N4_VLROC5
                MsUnLock()

                
                dbSelectArea("SN5")
                dbSetOrder(1)

                //ProcRegua(RecCount())

                If dbSeek(SN4->(N4_FILIAL+N4_CONTA),.F.)

                    While !Eof() .and. SN5->(N5_FILIAL+N5_CONTA) == SN4->(N4_FILIAL+N4_CONTA)

                        //IncProc("Processando o registro SN5 "+StrZero(Recno(),10))


                        If SN5->N5_DATA >= SN3->N3_DINDEPR .AND. SN5->N5_TIPO == SN4->N4_TIPOCNT .AND. SN5->N5_TPSALDO == SN4->N4_TPSALDO
                            
                            //ALERT("ACHEI DEPRECIACAO NA SN5")
                            
                            RecLock("SN5",.f.)
                            SN5->N5_VALOR1  :=  SN5->N5_VALOR1 - SN4->N4_VLROC1
                            SN5->N5_VALOR2  :=  SN5->N5_VALOR2 - SN4->N4_VLROC2
                            SN5->N5_VALOR3  :=  SN5->N5_VALOR3 - SN4->N4_VLROC3
                            SN5->N5_VALOR4  :=  SN5->N5_VALOR4 - SN4->N4_VLROC4
                            SN5->N5_VALOR5  :=  SN5->N5_VALOR5 - SN4->N4_VLROC5
                            MsUnLock()
                        
                            dbSelectArea("SN6")
                            dbSetOrder(1)
            
                            //ProcRegua(RecCount())

                            If dbSeek(SN5->(N5_FILIAL+N5_CONTA),.F.)
                        
                                While !Eof() .and. SN6->(N6_FILIAL+N6_CONTA) == SN5->(N5_FILIAL+N5_CONTA)

                                    //IncProc("Processando o registro SN6 "+StrZero(Recno(),10))

                                    If SN6->N6_DATA == SN3->N3_AQUISIC .AND. SN6->N6_TIPO == SN5->N5_TIPO .AND. SN6->N6_TPSALDO == SN5->N5_TPSALDO .AND. SN6->N6_CCUSTO == SN3->N3_CCUSTO .AND. SN6->N6_SUBCTA == SN3->N3_SUBCCON
            
                                        //ALERT("ACHEI DEPRECIACAO NA SN6")

                                        RecLock("SN6",.f.)
                                        SN6->N6_VALOR1  :=  SN6->N6_VALOR1 - SN4->N4_VLROC1
                                        SN6->N6_VALOR2  :=  SN6->N6_VALOR2 - SN4->N4_VLROC2
                                        SN6->N6_VALOR3  :=  SN6->N6_VALOR3 - SN4->N4_VLROC3
                                        SN6->N6_VALOR4  :=  SN6->N6_VALOR4 - SN4->N4_VLROC4
                                        SN6->N6_VALOR5  :=  SN6->N6_VALOR5 - SN4->N4_VLROC5
                                        MsUnLock()
                                    EndIf
                                    
                                    dbSelectArea("SN6")
                                    dbSkip()
                                EndDo
                                                                                   
                            EndIf
                       
                        EndIf

                        dbSelectArea("SN5")
                        dbSkip()
                    EndDo

                EndIf*/

                dbSelectArea("SN4")
                RecLock("SN4",.F.)
                dbDelete()
                MsUnLock()

            EndIf
        
            dbSelectArea("SN4")
            dbSkip()
        EndDo

    EndIf

    dbSelectArea("SN3")
    dbSkip()    
EndDo    

//ATFA120()

Return
