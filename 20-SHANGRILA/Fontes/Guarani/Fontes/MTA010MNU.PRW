#include "rwmake.ch"
#include "protheus.ch"

User Function MTA010MNU
    aAdd(aRotina, { "Atualizar Imagens","U_MT010ALL()"		, 0 , 2, 0, .F.} )		//"Atualizar Imagens"
Return

User Function MT010ALL
    Processa({||Atualizar(),"Processando..."})
Return

Static Function Atualizar()
    Local cPath		:= ""//GetSrvProfString("Startpath","")
    Local nH, nSize, nRead, cImgBuffer := ""
    Local _x := 0
    Local cBmpPict	:= "", cPathPict := ""
    DbSelectArea("SB1")
    DbSetOrder(1)
    ProcRegua(LastRec())
    DbGotop()
    While !SB1->(Eof())
        If SB1->B1_MSBLQL # "1"
            IncProc("Produto "+SB1->B1_COD)
            // Nome da imagem
            cBmpPict 	:= Upper( AllTrim( SB1->B1_COD) )
            cPathPict 	:= AllTrim ( cPath+"imagens\" + cBmpPict )

            // Extraindo imagem jpg e gravando no diretorio
            //RepExtract(SB1->B1_BITMAP1, cPathPict)
            For _x := 1 to 5
                _cFMBMP := "B1_MBMP"+cValToChar(_x)
                _cFBMP  := "B1_BITMAP"+cValToChar(_x)
                If _x != 1
                    cBmpPict := Upper( AllTrim( SB1->B1_COD) )+'_'+strZero(_x,2)
                EndIf
                cPathPict 	:= AllTrim ( cPath+"imagens\" + cBmpPict )
                If !Empty(cBmpPict)	.AND. File( cPathPict + ".jpg" )
                    // Extraindo dados do jpg para gravacao em campo
                    nH := Fopen(cPathPict+".jpg",0)
                    nSize := fSeek(nH,0,2)
                    fSeek(nH,0)

                    cImgBuffer := space(nSize)
                    nRead := fRead(nH,@cImgBuffer,nSize)
                    fClose(nH)

                    // Excluir arquivo
                    //FErase( cPathPict + ".jpg" )

                    // Imagens 1 e 2 iguais
                    Reclock("SB1",.F.)
                    SB1->&(_cFMBMP)	:= cImgBuffer //grava o campo memo
                    //SB1->&(_cFBMP) := cBmpPict //grava o b1_bitmap
                    //SB1->B1_MBMP2	:= cImgBuffer  ; SB1->B1_BITMAP2 := cBmpPict
                    MsUnlock()
                else
                    Reclock("SB1",.F.)
                    SB1->&(_cFMBMP)	:= "" //grava o campo memo
                    //SB1->&(_cFBMP) := "" //grava o b1_bitmap
                    //SB1->B1_MBMP2	:= cImgBuffer  ; SB1->B1_BITMAP2 := cBmpPict
                    MsUnlock()
                Endif
            Next
        EndIf
        SB1->(DbSkip())
    EndDo

Return
