library(raster)
library(shiny)
library(leaflet)

# Choices for drop-downs
vars <- c(
  "Data source" = "TEAM"
)

samplingFrequency <- c(
    "Annual" = "annual",
    "Seasonal" = "season",
    "Monthly" = "monthly"
    )

shinyUI(navbarPage("Rates of detection", id="nav",

##   Tab for Interactive Map
  tabPanel("Rates of Detection",
           
     fluidRow(
    div(class="outer",

      tags$head(
        # Include our custom CSS
        includeCSS("styles.css"),
        includeScript("gomap.js")
      ),
      #chartOutput("baseMap", "leaflet"),
      leafletOutput("map", width="100%", height="100%"),
      #tags$style('.leaflet {height: 100%; width: 100%;}'),
      #tags$head(tags$script(src="http://leaflet.github.io/Leaflet.heat/dist/leaflet-heat.js")),
      #uiOutput('heatMap'),
      
      # Portion of side panel menu always present.
      # Shiny versions prior to 0.11 should use class="modal" instead.
      absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
        draggable = FALSE, top = 60, left = "auto", right = 20, bottom = 10,
        width = 330, height = "auto", style = "overflow-y:scroll",

        h2("Rates of detection"),

      	selectInput("dataset", "Camera Trap Project", c("TEAM", "MWPIP")),
        uiOutput("site_checkbox"),
      	#####     SLIDER

      #   # TODO: Make this reactive based on frequencies present in input data
      # 	selectInput("select_time", label = "Sampling Frequency",
      # 	            choices = list("Annual" = 'annual', "Seasonal" = 'seasonal', "Monthly" = 'monthly'),
      # 	            selected = 1),
      #
      #   # TODO: Make this into a reactive UI based on min() and max() of actual data for sites.
      # 	sliderInput("time_slider", label = "Select Time", min = 0,
      # 	            max = 100, value = 50, timeFormat = "%Y-%m-%d"),
        #radioButtons("humans", "Show Humans?", c("Humans", "No Humans"),
        #            selected="No Humans"),
      
      
        checkboxInput("boundary_checkbox", label = "Display Park Boundaries", value = FALSE),
      
        uiOutput("guild.control"),
        uiOutput("red.control"),
        uiOutput("species.list"),
        uiOutput("frequency.control"),
        uiOutput("time.control"),
        hr(),
        #uiOutput("time.selection")#,

        # selectInput(inputId = "samplingFrequency",
        #             label = "Sampling Frequency",
        #             choices = samplingFrequency),
        # checkboxInput(inputId = "show_human",
        #               label = "Show Human Activities?"),

      
        # Portion of side panel menu that appears at bottom after species have been selected.
        conditionalPanel(
          condition = 'input.species != null',

          h3("Site-Specific Plots"),
          h4("Time Series of Site-Wide Rate of Detection"),
          plotOutput("total_ts", height = 200),
          h4("Top 5 Genera by Rate of Detection"),
          plotOutput("top_five_plot", height = 200),

          #h4("Overall Trends"),
          #plotOutput("health_ts", height = 200),
        #hr(),
        h3("Camera Specific Plots"),
        h4("(Click a red point on the map to enable)"),
        plotOutput("camera_ts_benchmark", height = 200),
        plotOutput("camera_ts_benchmark_facet", height = 200)
      )
        
      ),

      # Left# Portion of side panel always present.
      tags$div(id="cite",
        'Data compiled for ', vars['Data source']
      )
    )
  )
  ),

##   Tab for Data Explorer
  tabPanel("Data explorer",
    fluidRow(
      column(1,
        downloadButton('downloadData', 'Download')
      )
    ),
    hr(),
    DT::dataTableOutput("table")
  ),


##   Tab for Camera Statistics Statistics
  tabPanel("Camera stats",
    fluidRow(
       ##   Dropdown widgets
      column(3,
          selectInput("selectStat", label = h4("Select Statistic"), 
               choices = list("Count of images" = 1, "Count of blank images" = 2, "Count of unknown images" = 3,
                              "Count of uncatalogued images" = 4, "Count of wildlife images" = 5, "Count of human-related images" =6,
                              "Average photos per deployment" = 7), selected = 1),
          
          selectInput("selectAgg", label = h4("Select Aggregation Field"),
               choices = list("Project ID & Camera ID" = 1, "Project ID" = 2, "Camera ID" = 3), selected = 1)
            ),
       ##   Data Table
       column(9,
       DT::dataTableOutput("camtable")
       )
      )
  ),


##   Tab for Administrative Statistics
##   NOTE: ADD ADMIN STATS FEATURES TO THE UI HERE
  tabPanel("Administrative stats"),

##    Tab for Species Alert 
##    NOTE: This code is based on Interactive Map Tab
  tabPanel("Species alert",
    div(class="outer",
        tags$head(
          # Include our custom CSS
          includeCSS("styles.css"),
          includeScript("gomap.js")
          ),
        leafletOutput("map.2", width="100%", height="100%"),
        # Portion of side panel menu always present.
        # Shiny versions prior to 0.11 should use class="modal" instead.
        absolutePanel(id = "controls.2", class = "panel panel-default", fixed = TRUE,
           draggable = FALSE, top = 60, left = "auto", right = 20, bottom = 10,
           width = 330, height = "auto", style = "overflow-y:scroll",
           
           h2("Species alert"),
           
           selectInput("dataset.2", "Camera Trap Project", c("TEAM", "MWPIP")),
           uiOutput("site_checkbox.2"),
           
           checkboxInput("boundary_checkbox.2", label = "Display Park Boundaries", value = FALSE),
           
           uiOutput("guild.control.2"),
           uiOutput("red.control.2"),
           uiOutput("species.list.2"),
           uiOutput("frequency.control.2"),
           uiOutput("time.control.2"),
           hr()
                     
        ),
        
        # Left# Portion of side panel always present.
        tags$div(id="cite2",
                'Data compiled for ', vars['Data source']
        )
     )
  ),
conditionalPanel("false", icon("crosshair"))
))
