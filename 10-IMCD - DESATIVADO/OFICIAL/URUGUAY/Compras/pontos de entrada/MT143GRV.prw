#include 'protheus.ch'


/*/{Protheus.doc} MT143GRV
Punto de entrada ejecutado antes de la Inclusi�n / Visualizaci�n / 
Modificaci�n o Borrado del registro
@type function
@version 1.0
@author marcio.katsumata
@since 30/03/2020
@return nil, nil
@see    https://centraldeatendimento.totvs.com/hc/es/articles/360021147672-MP-COM-MATA143-Despacho-Puntos-de-entrada-Par%C3%A1metros-y-Tablas-disponibles-en-la-Rutina-
/*/
user function MT143GRV()

    //--------------------------------
    //Realiza a limpeza da vari�vel 
    //global __cInternet
    //--------------------------------
    u_limpaMata143()

return