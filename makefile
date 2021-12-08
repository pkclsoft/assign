assign.a 
  assign.mod { 
    filetype assign.mod src 16
    assemble assign.mod keep=$
  }

assign
  assign.a { link assign keep=assign }

