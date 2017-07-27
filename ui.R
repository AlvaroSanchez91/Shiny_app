
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

var_texto='Esta aplicacion shiny proporciona información de los datos creditos, a su vez, permite predecir los ingresos de nuevos individuos.'

var_texto_mi_tfm='Los datos estan se dividen en las siguientes categorias:X, Ingresos, Limite, Tasa, NumTarjetas ,Edad, Educacion, Sexo, Estudiante, Casado, Raza, Balance.'

library(shiny)

shinyUI(fluidPage(
  
  navbarPage('Datos Bancarios',
  ############ tabPanel: Inf
    tabPanel('Información',
             tags$img(src="logoR.png",align="left",width='150px'),
             br(),br(),br(),br(),
             hr(),
             h3('Objetivos:'),
             var_texto,
             h3('Autor:'),
             strong('Alvaro Sanchez Castañeda'),
             h3('Resumen:'),
             var_texto_mi_tfm
             
             ),
  ############ tabPanel: Datos
  tabPanel('Datos',
           DT::dataTableOutput('OUTdatos')
           #input$OUTdatos
           

  ),
  ############ tabPanel: Unidimensional
  tabPanel('Unidimensional',
           sidebarLayout(
             sidebarPanel(
               selectInput("SelVariable01Uni",
                           "Selecciona variable numérica:",
                           choices = names(creditos)[c(var_numer)],
                           selected = names(creditos)[var_numer[1]]
               ),
               
               selectInput("SelVariable02Uni",
                           "Selecciona variable categórica:",
                           choices = names(creditos)[c(var_categ)],
                           selected = names(creditos)[var_numer[1]]
               )
               
             ),

             # Show a plot of the generated distribution
             mainPanel(
               tabsetPanel (
                 tabPanel('Visualizacion variable numérica', 
                          checkboxInput("regresionMultible2","Márginales", T),
                          plotOutput('densidad')
                          ),
                 tabPanel('Visualización variable categórica', plotOutput('diagbarras')),
                 tabPanel('Resumen numérico', verbatimTextOutput('summaryCat'),verbatimTextOutput('summaryNum'))

               )
             )
           )

  ),
  # ############ tabPanel: Bidimensional
  tabPanel('Bidimensional',
           sidebarLayout(
             sidebarPanel(
               selectInput("SelVariable01",
                           "Selecciona variable numerica:",
                           choices = names(creditos)[c(var_numer)],
                           selected = names(creditos)[var_numer[1]]
               ),
               selectInput("SelVariable02",
                           "Selecciona variable numerica:",
                           choices = names(creditos)[c(var_numer)],
                           selected = names(creditos)[var_numer[1]]
               ),
               selectInput("SelVariable03",
                           "Selecciona variable categorica:",
                           choices = names(creditos)[c(var_categ)],
                           selected = names(creditos)[var_numer[1]]
               )
             ),

             # Show a plot of the generated distribution
             mainPanel(
               tabsetPanel (
                 ##################Ï tab:
                 tabPanel('Dispersion',
                          plotly::plotlyOutput('OUTdispersion')
                          ),
                 ##################Ï tab:
                 tabPanel('Regresión',
                          #mio
                          checkboxInput("regresionMultible","Márginales", T),
                          #hasta aqui
                          plotly::plotlyOutput('OUTReglineal')
                 ),
                 ##################Ï tab:
                 tabPanel('Dispersion cat',
                          
                          plotly::plotlyOutput('OUTdispersioncat')
                 )

               )
             )
           )

  ),
  # ############ tabPanel: Mapas
  tabPanel('Mapa',
           br(),
           leaflet::leafletOutput('map',height='600px')

  ),
  
  ################# tabPanel: Modelo
  tabPanel('Predecir',
   
           sidebarLayout(
             sidebarPanel(
               h3('Introducir formato csv con cabeceras en español.'),
               fileInput('file1',"Datos a predecir"),
               downloadButton('downloadPred', 'Descargar Predicciones')
             ),
             
             # Show a plot of the generated distribution
             mainPanel(
               tabsetPanel (
                 ##################Ï tab:
                 tabPanel('Tabla con predicciones',
                          DT::dataTableOutput('TablaLeida',height = "50%")
                 ),
                 ##################Ï tab:
                 tabPanel('Información del Modelo',
                          
                          verbatimTextOutput("summary")
                          
                 )
                 # ##################Ï tab:
                 # tabPanel('Dispersion cat',
                 #          h3("hola")
                 #          #plotly::plotlyOutput('OUTdispersioncat')
                 # )
                 
               )
             )
           )
           
           
  )
  
  
##################### fin navbarPage
             )

))


