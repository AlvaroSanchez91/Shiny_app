
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyServer(function(input, output) {
  
#################### Datos
    output$OUTdatos=DT::renderDataTable(creditos, filter='top')

#################### Panel mapa
    output$map=leaflet::renderLeaflet(
      leaflet()%>%
        addTiles()%>%
        setView(lng=-5.98815,lat=37.35945,zoom=18)
      
    )
#################### panel bidimensional:
    datos_bid=reactive({
      data.frame(
        varX = creditos[,input$SelVariable01],
        varY = creditos[,input$SelVariable02],
        Agru = creditos[,input$SelVariable03]
      )
    })
    
#################### panel dispersion:
    output$OUTdispersion=plotly::renderPlotly({
      df_dispersion = datos_bid()
      plotly::plot_ly(df_dispersion,x=~varX,y=~varY)
    })
#################### panel dispersion cat:
    output$OUTdispersioncat=plotly::renderPlotly({
      df_dispersion = datos_bid()
      plotly::plot_ly(df_dispersion,x=~varX,y=~varY, color = ~Agru)
    })
#################### panel reg lineal:
    output$OUTReglineal=plotly::renderPlotly({
      df_dispersion=datos_bid()
      
      if (input$regresionMultible){
        p <- ggplot(data = df_dispersion, aes_string(x =colnames(df_dispersion)[1], y =  colnames(df_dispersion)[2],col = colnames(df_dispersion)[3])) +
          geom_point() + geom_smooth()
      }
      else{
        p <- ggplot(data = df_dispersion, aes_string(x =colnames(df_dispersion)[1], y =  colnames(df_dispersion)[2])) +
         geom_point(aes_string(col =  colnames(df_dispersion)[3])) + geom_smooth()
      }
      plotly::ggplotly(p)
      
      
    })
    
######################################################## Prediccion
 
############################# predecir   
    datos_pred=reactive({
      inFile= input$file1
      
      dat=data.frame(
        read.csv(inFile$datapath)
      )
      rownames(dat)=dat$X
      dat$pred_ingresos=predict(model,dat)
      dat
    })

########################################### descargar   
    output$downloadPred <- downloadHandler(
      filename = "predicciones.csv",
      content = function(file) {
        write.csv(datos_pred(), file)
      }
    )
############################################### tabla    
    output$TablaLeida = DT::renderDataTable({
      
      
      predicciones=datos_pred()
      predicciones[c('X','pred_ingresos')]
      
    }, filter='top',height = "50%")
    
######################################################## Resumen
    output$summary = renderPrint (
      summary(model)
      #model$coefficients
      
                                    )
    
    
  ######################################################################## Unidim
    output$diagbarras = renderPlot( plot(creditos[input$SelVariable02Uni]))
    
    output$densidad <- renderPlot({
      var=input$SelVariable01Uni
      var2=input$SelVariable02Uni
      
      #plot(iris[c(var1,var2)],col=iris$Species)
      if (input$regresionMultible2){
      ggplot(creditos,aes_string(var,fill=var2))+geom_density(alpha=0.5)}
      else{ggplot(creditos,aes_string(var))+geom_density(alpha=0.5,fill='blue')}
      
    })
    
    output$summaryCat = renderPrint (
      summary(creditos[input$SelVariable02Uni])
      )
    output$summaryNum = renderPrint (
      summary(creditos[input$SelVariable01Uni])
    )
    

})
