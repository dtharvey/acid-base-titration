# server for acid-base-titration

# packages to load; first two needed for using shiny
library(shiny)
library(shinythemes)
library(titrationCurves) # simulates titration curves
library(shape) # used to draw arrows

# place for data files and scripts used in server file
indicator.name = c("bromophenol blue (3.0-4.6)",
                   "bromocresol green (3.8-5.4)", 
                   "methyl red (4.2-6.3)",
                   "bromocresol purple (5.2-6.8)", 
                   "bromothymol blue (6.0-7.6)", 
                   "phenol red (6.8-8.4)", 
                   "cresol red (7.2-8.8)", 
                   "p-naphtholbenzein (9.0-11.0)", 
                   "alizarin yellow R (10.1-12.0)")

acid.color = c(5,5,8,5,5,5,5,5,5) # color of indicator's acid form
acid.limit = c(3.0,3.8,4.2,5.2,6.0,6.8,7.2,9.0,10.1) # acid pH limit
base.color = c(3,3,5,8,3,3,8,3,8) # color of indicator's base form
base.limit = c(4.6,5.4,6.3,6.8,7.6,8.4,8.8,11.0,12.0) # base pH limit

# set color scheme
palette("Okabe-Ito")

shinyServer(function(input, output, session){
  
# code for introduction figure
  output$intro_plot = renderPlot({

    # create color ramp palette for indicator's color change
    ind.color = colorRampPalette(colors = c(8,5), alpha = FALSE)
    
    # create titration curve data
    intro.data = sa_sb(conc.acid = 0.05066, conc.base = 0.1183, 
                       vol.acid = 50, plot = FALSE)
    
    # find index for beginning and and of indicator's color change
    ind_begin_index = which.min(abs(4.2 - intro.data$ph))
    ind_end_index = which.min(abs(6.3 - intro.data$ph))
    
    # find equivalence point and endpoint
    eq_ph = 7
    ep_ph = (4.2 + 6.3)/2
    eq_vol = intro.data$volume[which.min(abs(eq_ph - intro.data$ph))]
    ep_vol = intro.data$volume[which.min(abs(ep_ph - intro.data$ph))]
    
    # plot titration curve before indicator change
    plot(x = intro.data$volume[1:ind_begin_index], 
         xlab = "volume of NaOH added (mL)",
         y = intro.data$ph[1:ind_begin_index],type = "p",
         pch = 19, cex = 2, col = 8, ylab = "pH of solution",
         xlim = c(0,max(intro.data$volume)), 
         ylim = c(0,max(intro.data$ph)))
    
    # plot titration curve through indicator's color change
    points(x = intro.data$volume[ind_begin_index:ind_end_index],
           y = intro.data$ph[ind_begin_index:ind_end_index],
           pch = 19, cex = 2, 
           col = ind.color(ind_end_index-ind_begin_index + 1))
    
    # plot remainder of titration curve
    points(x = intro.data$volume[ind_end_index:length(intro.data$volume)],
           y = intro.data$ph[ind_end_index:length(intro.data$ph)],
           pch = 19, cex = 2,
           col = 5)
    grid()
    
    # add arrows and text
    arrows(x0 = eq_vol-5, y0 = eq_ph, 
           x1 = eq_vol-0.5, y1 = eq_ph, 
           code = 2, lwd = 4, col = 1, length = 0.1)
    arrows(x0 = ep_vol+0.5, y0 = ep_ph, x1 = ep_vol+5, y1 = ep_ph,
           code = 1, lwd = 4, col = 1, length = 0.1)
    text(x = ep_vol + 5.1, y = ep_ph, 
         cex = 1.5, "endpoint", pos = 4)
    text(x = eq_vol-5, y = eq_ph, "equivalence point", 
         cex = 1.5, pos = 2)
  })

# code for SA/SB plot
  output$activity1_plot = renderPlot({
    
    # identify the indicator
    act1_indindex = which(indicator.name == input$act1_ind)
    
    # create titration curve data and setup color scheme for indicator
    old.par = par(mar = c(5,4,1,2))
    if (input$act1_analyte == "strong acid"){
      act1.data = sa_sb(conc.acid = 10^input$act1_concanalyte, 
                        conc.base = 10^input$act1_conctitrant, 
                        vol.acid = input$act1_volanalyte, 
                        plot = FALSE)
      ind.color = colorRampPalette(colors = c(acid.color[act1_indindex],
                                              base.color[act1_indindex]), 
                                   alpha = FALSE)
      act1_indstart = which.min(abs(acid.limit[act1_indindex]-act1.data$ph))
      act1_indend = which.min(abs(base.limit[act1_indindex]-act1.data$ph))
      
      # plot titration curve before indicator change
      plot(x = act1.data$volume[1:act1_indstart],
           y = act1.data$ph[1:act1_indstart],
           xlab = "volume of titrant (mL)", ylab = "pH",
           type = "p", pch = 19, cex = 2, col = acid.color[act1_indindex],
           xlim = c(input$act1_voltitrant[1], input$act1_voltitrant[2]),
           ylim = c(0,14))
      grid()
      
      # plot titration curve through indicator's change
      points(x = act1.data$volume[act1_indstart:act1_indend],
             y = act1.data$ph[act1_indstart:act1_indend],
             pch = 19, cex = 2,
             col = ind.color(act1_indend - act1_indstart + 1))
      
      # plot titration curve after indicator's change
      points(x = act1.data$volume[act1_indend:length(act1.data$volume)],
             y = act1.data$ph[act1_indend:length(act1.data$ph)],
             pch = 19, cex = 2,
             col = base.color[act1_indindex])
    } else {
      act1.data = sb_sa(conc.base = 10^input$act1_concanalyte, 
                        conc.acid = 10^input$act1_conctitrant, 
                        vol.base = input$act1_volanalyte, 
                        plot = FALSE)
      ind.color = colorRampPalette(colors = c(base.color[act1_indindex],
                                              acid.color[act1_indindex]), 
                                   alpha = FALSE)
      act1_indstart = which.min(abs(base.limit[act1_indindex]-act1.data$ph))
      act1_indend = which.min(abs(acid.limit[act1_indindex]-act1.data$ph))
      
      # plot titration curve before indicator change
      plot(x = act1.data$volume[1:act1_indstart],
           y = act1.data$ph[1:act1_indstart],
           xlab = "volume of titrant (mL)", ylab = "pH",
           type = "p", pch = 19, cex = 2, col = base.color[act1_indindex],
           xlim = c(input$act1_voltitrant[1], input$act1_voltitrant[2]),
           ylim = c(0,14))
      grid()
      
      # plot titration curve through indicator's change
      points(x = act1.data$volume[act1_indstart:act1_indend],
             y = act1.data$ph[act1_indstart:act1_indend],
             pch = 19, cex = 2,
             col = ind.color(act1_indend - act1_indstart + 1))
      
      # plot titration curve after indicator's change
      points(x = act1.data$volume[act1_indend:length(act1.data$volume)],
             y = act1.data$ph[act1_indend:length(act1.data$ph)],
             pch = 19, cex = 2,
             col = acid.color[act1_indindex])
    }
    
    # endpoint pH and volume
    act1_ep_ph = (acid.limit[act1_indindex] + base.limit[act1_indindex])/2
    act1_ep_vol = act1.data$volume[which.min(abs(act1_ep_ph-act1.data$ph))]
    arrows(x0 = act1_ep_vol+0.5, y0 = act1_ep_ph, 
           x1 = act1_ep_vol+5, y1 = act1_ep_ph,
           code = 1, lwd = 4, col = 1, length = 0.1)
    text(x = act1_ep_vol + 5.1, y = act1_ep_ph, 
         cex = 1.5, "endpoint", pos = 4)
    par(old.par)
  })

# code for monoprotic WA/WB plot  
  output$activity2_plot = renderPlot({
    old.par = par(mar = c(5,4,1,2))  
    # identify the indicator
    act2_indindex = which(indicator.name == input$act2_ind)
    
    # create titration curve data and setup color scheme for indicator
    if (input$act2_analyte == "weak acid"){
      act2.data = wa_sb(conc.acid = 10^input$act2_concanalyte, 
                        conc.base = 10^input$act2_conctitrant, 
                        vol.acid = input$act2_volanalyte, 
                        pka = input$act2_pk, plot = FALSE)
      ind.color = colorRampPalette(colors = c(acid.color[act2_indindex],
                                              base.color[act2_indindex]), 
                                   alpha = FALSE)
      act2_indstart = which.min(abs(acid.limit[act2_indindex]-act2.data$ph))
      act2_indend = which.min(abs(base.limit[act2_indindex]-act2.data$ph))
      
      # plot titration curve before indicator change
      plot(x = act2.data$volume[1:act2_indstart],
           y = act2.data$ph[1:act2_indstart],
           xlab = "volume of titrant (mL)", ylab = "pH",
           type = "p", pch = 19, cex = 2, col = acid.color[act2_indindex],
           xlim = c(input$act2_voltitrant[1], input$act2_voltitrant[2]),
           ylim = c(0,14))
      grid()
      
      # plot titration curve through indicator's change
      points(x = act2.data$volume[act2_indstart:act2_indend],
             y = act2.data$ph[act2_indstart:act2_indend],
             pch = 19, cex = 2,
             col = ind.color(act2_indend - act2_indstart + 1))
      
      # plot titration curve after indicator's change
      points(x = act2.data$volume[act2_indend:length(act2.data$volume)],
             y = act2.data$ph[act2_indend:length(act2.data$ph)],
             pch = 19, cex = 2,
             col = base.color[act2_indindex])
    } else {
      act2.data = wb_sa(conc.base = 10^input$act2_concanalyte, 
                        conc.acid = 10^input$act2_conctitrant, 
                        vol.base = input$act2_volanalyte, 
                        pka = 14 - input$act2_pk, plot = FALSE)
      ind.color = colorRampPalette(colors = c(base.color[act2_indindex],
                                              acid.color[act2_indindex]), 
                                   alpha = FALSE)
      act2_indstart = which.min(abs(base.limit[act2_indindex]-act2.data$ph))
      act2_indend = which.min(abs(acid.limit[act2_indindex]-act2.data$ph))
      
      # plot titration curve before indicator change
      plot(x = act2.data$volume[1:act2_indstart],
           y = act2.data$ph[1:act2_indstart],
           xlab = "volume of titrant (mL)", ylab = "pH",
           type = "p", pch = 19, cex = 2, col = base.color[act2_indindex],
           xlim = c(input$act2_voltitrant[1], input$act2_voltitrant[2]),
           ylim = c(0,14))
      grid()
      
      # plot titration curve through indicator's change
      points(x = act2.data$volume[act2_indstart:act2_indend],
             y = act2.data$ph[act2_indstart:act2_indend],
             pch = 19, cex = 2,
             col = ind.color(act2_indend - act2_indstart + 1))
      
      # plot titration curve after indicator's change
      points(x = act2.data$volume[act2_indend:length(act2.data$volume)],
             y = act2.data$ph[act2_indend:length(act2.data$ph)],
             pch = 19, cex = 2,
             col = acid.color[act2_indindex])
    }
    
    # endpoint pH and volume
    act2_ep_ph = (acid.limit[act2_indindex] + base.limit[act2_indindex])/2
    act2_ep_vol = act2.data$volume[which.min(abs(act2_ep_ph-act2.data$ph))]
    arrows(x0 = act2_ep_vol+0.5, y0 = act2_ep_ph, 
           x1 = act2_ep_vol+5, y1 = act2_ep_ph,
           code = 1, lwd = 4, col = 1, length = 0.1)
    text(x = act2_ep_vol + 5.1, y = act2_ep_ph, 
         cex = 1.5, "endpoint", pos = 4)
    par(old.par)
  })
 
# code for diprotic WA/WB plot 
  output$activity3_plot = renderPlot({
    
    # identify the indicator
    act3_indindex = which(indicator.name == input$act3_ind)
    old.par = par(mar = c(5,4,1,2))
    # create titration curve data and setup color scheme for indicator
    if (input$act3_analyte == "weak acid"){
      act3.data = diwa_sb(conc.acid = 10^input$act3_concanalyte, 
                        conc.base = 10^input$act3_conctitrant, 
                        vol.acid = input$act3_volanalyte, 
                        pka1 = input$act3_pk[1], pka2 = input$act3_pk[2],
                        plot = FALSE)
      ind.color = colorRampPalette(colors = c(acid.color[act3_indindex],
                                              base.color[act3_indindex]), 
                                   alpha = FALSE)
      act3_indstart = which.min(abs(acid.limit[act3_indindex]-act3.data$ph))
      act3_indend = which.min(abs(base.limit[act3_indindex]-act3.data$ph))
      
      # plot titration curve before indicator change
      plot(x = act3.data$volume[1:act3_indstart],
           y = act3.data$ph[1:act3_indstart],
           xlab = "volume of titrant (mL)", ylab = "pH",
           type = "p", pch = 19, cex = 2, col = acid.color[act3_indindex],
           xlim = c(input$act3_voltitrant[1], input$act3_voltitrant[2]),
           ylim = c(0,14))
      grid()
      
      # plot titration curve through indicator's change
      points(x = act3.data$volume[act3_indstart:act3_indend],
             y = act3.data$ph[act3_indstart:act3_indend],
             pch = 19, cex = 2,
             col = ind.color(act3_indend - act3_indstart + 1))
      
      # plot titration curve after indicator's change
      points(x = act3.data$volume[act3_indend:length(act3.data$volume)],
             y = act3.data$ph[act3_indend:length(act3.data$ph)],
             pch = 19, cex = 2,
             col = base.color[act3_indindex])
    } else {
      act3.data = diwb_sa(conc.base = 10^input$act3_concanalyte, 
                        conc.acid = 10^input$act3_conctitrant, 
                        vol.base = input$act3_volanalyte, 
                        pka1 = 14 - input$act3_pk[2],
                        pka2 = 14 - input$act3_pk[1],
                        plot = FALSE)
      ind.color = colorRampPalette(colors = c(base.color[act3_indindex],
                                              acid.color[act3_indindex]), 
                                   alpha = FALSE)
      act3_indstart = which.min(abs(base.limit[act3_indindex]-act3.data$ph))
      act3_indend = which.min(abs(acid.limit[act3_indindex]-act3.data$ph))
      
      # plot titration curve before indicator change
      plot(x = act3.data$volume[1:act3_indstart],
           y = act3.data$ph[1:act3_indstart],
           xlab = "volume of titrant (mL)", ylab = "pH",
           type = "p", pch = 19, cex = 2, col = base.color[act3_indindex],
           xlim = c(input$act3_voltitrant[1], input$act3_voltitrant[2]),
           ylim = c(0,14))
      grid()
      
      # plot titration curve through indicator's change
      points(x = act3.data$volume[act3_indstart:act3_indend],
             y = act3.data$ph[act3_indstart:act3_indend],
             pch = 19, cex = 2,
             col = ind.color(act3_indend - act3_indstart + 1))
      
      # plot titration curve after indicator's change
      points(x = act3.data$volume[act3_indend:length(act3.data$volume)],
             y = act3.data$ph[act3_indend:length(act3.data$ph)],
             pch = 19, cex = 2,
             col = acid.color[act3_indindex])
    }
    
    # endpoint pH and volume
    act3_ep_ph = (acid.limit[act3_indindex] + base.limit[act3_indindex])/2
    act3_ep_vol = act3.data$volume[which.min(abs(act3_ep_ph-act3.data$ph))]
    arrows(x0 = act3_ep_vol+0.5, y0 = act3_ep_ph, 
           x1 = act3_ep_vol+5, y1 = act3_ep_ph,
           code = 1, lwd = 4, col = 1, length = 0.1)
    text(x = act3_ep_vol + 5.1, y = act3_ep_ph, 
         cex = 1.5, "endpoint", pos = 4)
    par(old.par)
  })
  
  
  # code for plot on wrapping up tabPanel
  output$wrapup_plot = renderPlot({
    normal = diwa_sb(conc.base = 0.2)
    firstderiv = derivative(normal, plot = FALSE)
    old.par = par(mfrow = c(2,1), mar = c(5,4,1,2))
    plot(x = normal$volume, y = normal$ph, type = "l", 
         lwd = 4, col = 6, xlab = "volume of titrant (mL)", ylab = "pH",
         xlim = c(0,100), ylim = c(0,14))
    abline(v = c(25, 50), lwd = 2, col = 8, lty = 3)
    grid()
    plot(x = firstderiv$first_deriv$x1,
         y = firstderiv$first_deriv$y1,
         type = "l", lwd = 4, col = 6, xlab = "volume of titrant (mL)",
         ylab = "∂pH/∂V", xlim = c(0,100))
    abline(v = c(25, 50), lwd = 2, col = 8, lty = 3)
    grid()
    par(old.par)
    
  })
  
  
}) # close the servers
