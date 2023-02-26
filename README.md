# Trailblazer

The Waze of Skiing

Setup Instructions:

/* No longer necessary, for now you can just start the project by opening SundayRiver.xcodeproj and pressing "command R" */

(Requires Xcode Installation and docker installation)

  Clone Repository

  Navigate to /trailblazer/Database in terminal
  
  Run command in terminal:
    
      docker run --name trailblazer -e POSTGRES_DB=VaporTrailblazer \
        -e POSTGRES_USER=mckee_p \
        -e POSTGRES_PASSWORD=trailblazer \
        -p 5432:5432 -d postgres


  Reveal TrailBlazer Folder in Finder
  
  Open Package.swift in TILApp
  
  Run the program(Command R), make sure target is my computer

  Return to root folder 
  
  Open xcode.proj
  
  Run the program (Command R)

## Link To Testflight 

https://testflight.apple.com/join/qY7GGL3a
