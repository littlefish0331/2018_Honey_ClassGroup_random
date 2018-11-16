#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#
getwd()
library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
  
  # 讀取學生名單
  Data <- reactive({
    # A <- readRDS("data/name.rds")
    # 
    A <- read.csv("data/name.csv", stringsAsFactors = F, fileEncoding = "UTF-8")
    # 
    # shiny上面不能連動Github
    # A <- read.csv("https://raw.githubusercontent.com/littlefish0331/2018_Honey_ClassGroup_random/master/name.csv",
    #               stringsAsFactors = F); colnames(A) <- c("Number", "Dep", "Name")
    # A
  })
  
  # 讀取學生原始分組名單
  Original_Data <- reactive({
    # A <- readRDS("data/original.rds")
    # 
    A <- read.csv("data/original.csv", stringsAsFactors = F, fileEncoding = "UTF-8")
    colnames(A) <- c("Group 1", "Group 2", "Group 3", "Group 4", "Group 5")
    A
    # 
    # A <- read.csv("https://raw.githubusercontent.com/littlefish0331/2018_Honey_ClassGroup_random/master/original.csv",
    #               stringsAsFactors = F)
  })
  
  
  
  
  
  # 顯示學生名單
  # 按照學號大小
  output$namelist1 <- renderTable({
    Data()[1:8,]
  })
  output$namelist2 <- renderTable({
    Data()[9:16,]
  })
  output$namelist3 <- renderTable({
    Data()[17:24,]
  })
  
  
  
  
  
  # 顯示學生原始分組名單
  # 按照組別排列
  output$grouplist <- renderTable({
    Original_Data()
  })
  
  # 亂數分組結果
  # 要連動亂數按鈕
  randomData <- eventReactive(input$random,{
    # set.seed(123)
    idx <- sample(x = 1:25, size = 25, replace = F)
    tmp <- Data()[idx,]
    # ttmp <- tmp[, 2:3] %>% apply(., 1, paste, collapse = " ") %>% as.character() #如果要顯示系級或是學號
    ttmp <- tmp[,3]
    
    AA <- ttmp %>% matrix(ncol = 5, byrow = T)
    colnames(AA) <- c("Group 1", "Group 2", "Group 3", "Group 4", "Group 5")
    AA
  })
  
  
  
  
  # 依照不同的按鈕，呈現不同的結果
  v <- reactiveValues(data = NULL, times = 0)
  observeEvent(input$defalut, {
    v$data <- Original_Data()
    v$times <- 0
  })
  observeEvent(input$random, {
    v$data <- randomData()
    v$times <- v$times+1
  })
  
  # 呈現亂數分組結果
  output$random_group <- renderTable({
    if (is.null(v$data)) return()
    v$data
  })
  
  
  
  output$value <- renderText({
    v$times
  })
  
  
  
  
  
  # 下載本次分組名單
  output$downloadData <- downloadHandler(
    filename = function() {
      tmp <- Sys.time() %>% substring(text = ., first = 1, last = 10)
      tmp <- paste0(tmp, "_random.csv")
      return(tmp)
    },
    content = function(filename) {
      df <- randomData() %>% as.data.frame()
      write.csv(df, filename, row.names = F, fileEncoding = "CP950") 
      #未設定編碼就是UTF-8。可以改成CP950試試看。或是BIG-5
    }
  )
  
  
  
})
