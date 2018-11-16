#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(dplyr)
library(shinythemes)
library(RJSONIO)

options(encoding = "UTF-8") # 之後讀取檔案就要改成CP950

shinyUI(fluidPage(
  # shinythemes::themeSelector(),  # <--- Add this somewhere in the UI
  theme = shinytheme("darkly"), # 考慮用 journal, flatly, darkly。

  navbarPage( # navbar導航欄的意思
    "Random Group Generate",
    

    # 上傳檔案區
    tabPanel("Upload Student List",
             pageWithSidebar(
               headerPanel('How to use this!'),
               sidebarPanel(hr()),
               
               # Show Upload Student Name List
               mainPanel()
             )
    ),
    

    # 亂數分組區域
    tabPanel("Ramdom Group", 
             fluidPage(
               tabsetPanel(
                 tabPanel(h4("Student Name List"),
                          br(),
                          column(2),
                          column(3, div(tableOutput('namelist1'), style = "font-size:140%")),
                          column(3, div(tableOutput('namelist2'), style = "font-size:140%")),
                          column(3, div(tableOutput('namelist3'), style = "font-size:140%")),
                          column(1)
                 ),
                 
                 tabPanel(h4("Random Result"),
                          br(),
                          column(2,
                                 br(),br(),br(),br(),
                                 actionButton(inputId = "defalut", label = h4("Default")),
                                 br(),br(),
                                 actionButton("random", h4("Let's random~~")),
                                 br(),br(),br(),br(),
                                 downloadButton('downloadData', 'Download')
                          ),
                          column(5,
                                 tags$h2(tags$b("Original Group")),
                                 wellPanel(div(tableOutput("grouplist"), style = "font-size:140%"), align="center")
                          ),
                          column(5,
                                 tags$h2(tags$b("Random Group")),
                                 wellPanel(div(tableOutput("random_group"), style = "font-size:140%"), align="center")
                          )
                          # verbatimTextOutput("value")
                          # HTML("&nbsp;&nbsp") # 空格的功用
                          
                 )
               )
             )
    )
  )
  
  
))

