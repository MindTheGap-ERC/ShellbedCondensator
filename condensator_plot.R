condensator_plot=function(input,keyword=""){
  #### 0. Check Input and Define Global Options ####
  
  if(!is.character(keyword)) stop("keyword needs to be a character")
  
  # Remove capitalization from inputs -> keywords are NOT case sensitive
  keyword=tolower(keyword)
  
  # Warning when no valid keyword was handed over as input
  if (!any(c("time","age model", "height", "condensation", "section without sed info") %in% keyword)){
    stop("No valid input for keyword. Try \"Time\", \"Height\", \"Condensation\", or \"Age Model\".")
  }
  
  ### Global Plotting Options
  no_of_ticks=input$plot_options$par_options["no_of_ticks"]
  axis_label_distance=input$plot_options$par_options["axis_label_distance"]
  tick_label_distance=input$plot_options$par_options["tick_label_distance"]
  label_expansion=input$plot_options$par_options["label_expansion"]
  
  if(input$incorrect_input==TRUE){
    plot(NULL,
         xlim=c(0,1),
         ylim=c(0,1),
         xaxt='n',
         yaxt='n',
         xlab ='',
         ylab='')
  } else{
    #### 1. Time Realm #### 
    if ( keyword == "time" ){ 
      # limits and rescaling for y axis
      if (all(input$dep_rate_time==0)){
        y_limits_time=c(0,1)
        y_rescale_sed_rate_time=1
      }
      else{
        if (mean(range(c(input$dep_rate_time,0)))<0){
          y_limits_time=c(-1,1)
          y_rescale_sed_rate_time=-min(c(input$dep_rate_time,input$dep_rate_time_sub_input))
        }
        else{
          y_limits_time=range(c(input$dep_rate_time,0,input$dep_rate_time_sub_input))/max(c(input$dep_rate_time,input$dep_rate_time_sub_input))
          y_rescale_sed_rate_time=max(c(input$dep_rate_time,input$dep_rate_time_sub_input))
        }
      }
      ### Generate Framework Plot ###
      plot(NULL,
           xlim=range(input$times),
           ylim=y_limits_time,
           ylab='',
           xlab='',
           yaxt='n',
           mgp=c(axis_label_distance,tick_label_distance,0))
      mtext(side=1,
            text=paste(input$plot_options$name_options["T_name"],
                       " [",
                       input$plot_options$name_options["T_unit"] ,
                       "]",
                       sep=""),
            line=axis_label_distance,
            cex=label_expansion)
      
      ### Plot Hiatuses ###
      # Draw polygons for eroded time intervals
      if (length(input$hiatus_list)>0){
        for (i in 1:length(input$hiatus_list)){
          hiatus_start=replace(input$hiatus_list[[i]]['beginning'],is.na(input$hiatus_list[[i]]['beginning']),-max(input$times))
          hiatus_end=replace(input$hiatus_list[[i]]['end'],is.na(input$hiatus_list[[i]]['end']),2*max(input$times))
          polygon(x=c(hiatus_start,hiatus_end,hiatus_end,hiatus_start),
                  y=c(rep(y_limits_time[1]-1,2), rep(y_limits_time[2]+1,2)),
                  lty=0,
                  col=input$plot_options$col_options['erosion_col'])
        }
      }
      #draw x axis for reference
      lines(x=range(input$times),
            y=c(0,0),
            col=input$plot_options$col_options["baseline_col"],
            lwd=input$plot_options$line_options["baseline_lwd"])
      
      ### Plot Sedimentation Rate ###
      # generate axis for sed. rate (right)
      right_ticks=axisTicks(usr=range(c(0,input$dep_rate_time,input$dep_rate_time_sub_input)),
                            log=FALSE,
                            nint =  no_of_ticks-1)
      axis(side=4,
           at=right_ticks/y_rescale_sed_rate_time,
           labels=as.character(right_ticks),
           mgp=c(0,tick_label_distance,0),)
      if (input$pos_input_volume==FALSE){
        mtext(side=4,
              text = paste(input$plot_options$name_options["sed_rate_name"],
                           " [" ,
                           input$plot_options$name_options["L_unit"] ,
                           " per " ,
                           input$plot_options$name_options["T_unit"] ,
                           "]",
                           sep=""),
              col=input$plot_options$col_options['sed_col'],
              line=axis_label_distance,
              cex=label_expansion)
        # draw sed rate
        lines(x=input$times,
              y=input$dep_rate_time/y_rescale_sed_rate_time,
              col=input$plot_options$col_options['sed_col'],
              lwd=input$plot_options$line_options["sed_lwd"])
      }
      else{   
        lab_position=par("usr")[3]+ 0.01*diff(par("usr")[c(3,4)])
        mtext(side=4,
              text = paste(input$plot_options$name_options["sed_rate_name"],
                           " (incl. ",
                           input$plot_options$name_options["sed_content_name"],
                           " Volume) [" ,
                           input$plot_options$name_options["L_unit"] ,
                           " per " ,
                           input$plot_options$name_options["T_unit"] ,
                           "]",
                           sep=""),
              col=input$plot_options$col_options['sed_col'],
              line=axis_label_distance,
              cex=label_expansion,
              at=lab_position,
              adj=0)
        
        mtext(side=4,
              text = paste(input$plot_options$name_options["sed_rate_name"],sep=""),
              col=input$plot_options$col_options["sed_col_minus_input"],
              line=axis_label_distance,
              cex=label_expansion,
              at=lab_position,
              adj=0)
        
        # draw sed rate
        lines(x=input$times,
              y=input$dep_rate_time_sub_input/y_rescale_sed_rate_time,
              col=input$plot_options$col_options["sed_col_minus_input"],
              lwd=input$plot_options$line_options["sed_lwd_minus_input"])
        
        lines(x=input$times,
              y=input$dep_rate_time/y_rescale_sed_rate_time,
              col=input$plot_options$col_options['sed_col'],
              lwd=input$plot_options$line_options["sed_lwd"])
      }
      
      
      ### Temporal Pattern ###
      # generate y limits for for pattern
      if(all(input$pattern_time==0)){
        y_max_pattern_time=1
      }
      else{
        y_max_pattern_time=max(input$pattern_time)
      }
      # get ticks for axis
      left_ticks=axisTicks(usr=c(0,y_max_pattern_time),
                           log=FALSE,
                           nint =  no_of_ticks-1)
      # draw left axis
      axis(side=2,
           at=left_ticks/y_max_pattern_time,
           labels=as.character(left_ticks),
           mgp=c(0,tick_label_distance,0))
      # label left axis
      mtext(side=2,
            text = paste(input$plot_options$name_options["sed_content_name"],
                         " ",
                         input$plot_options$name_options["sed_content_name_addition_time"],
                         " [",
                         input$plot_options$name_options["sed_content_unit"],
                         " per ",
                         input$plot_options$name_options["T_unit"] ,
                         "]",
                         sep=''),
            col=input$plot_options$col_options['pattern_col'],
            line=axis_label_distance,
            cex=label_expansion)
      # draw pattern
      lines(x=input$times,
            y=input$pattern_time/y_max_pattern_time,
            col=input$plot_options$col_options['pattern_col'],
            lwd=input$plot_options$line_options["pattern_lwd"])
      
      if(input$plot_options$points_plot$plot_sed_points==TRUE){
        selection=!duplicated(input$plot_options$points_plot$x_sed_points)
        points(x=input$plot_options$points_plot$x_sed_points[selection],
               y=input$plot_options$points_plot$y_sed_points[selection]/y_rescale_sed_rate_time,
               cex=input$plot_options$points_plot$sed_points_expansion,
               pch=input$plot_options$points_plot$sed_points_pch,
               col=input$plot_options$points_plot$sed_points_col,
               bg=input$plot_options$points_plot$sed_points_bg)
        text(x=input$plot_options$points_plot$x_sed_points[selection],
             y=input$plot_options$points_plot$y_sed_points[selection]/y_rescale_sed_rate_time,
             labels=input$plot_options$points_plot$sed_points_labels[selection],
             pos=input$plot_options$points_plot$sed_points_labels_pos,
             cex=input$plot_options$point_plot$sed_points_labels_expansion)
      }
      
      if(input$plot_options$points_plot$plot_pat_points==TRUE){
        selection=!duplicated(input$plot_options$points_plot$x_pat_points)
        points(x=input$plot_options$points_plot$x_pat_points[selection],
               y=input$plot_options$points_plot$y_pat_points[selection]/y_max_pattern_time,
               cex=input$plot_options$points_plot$pat_points_expansion,
               pch=input$plot_options$points_plot$pat_points_pch,
               col=input$plot_options$points_plot$pat_points_col,
               bg=input$plot_options$points_plot$pat_points_bg)
        
        text(x=input$plot_options$points_plot$x_pat_points[selection],
             y=input$plot_options$points_plot$y_pat_points[selection]/y_max_pattern_time,
             labels=input$plot_options$points_plot$pat_points_labels[selection],
             pos=input$plot_options$points_plot$pat_points_labels_pos,
             cex=input$plot_options$point_plot$pat_points_labels_expansion)
      }
      
      ### Label Hiatuses ###
      if (length(input$hiatus_list)>0){
        for (i in 1:length(input$hiatus_list)){
          hiatus_start=replace(input$hiatus_list[[i]]['beginning'],is.na(input$hiatus_list[[i]]['beginning']),0)
          hiatus_end=replace(input$hiatus_list[[i]]['end'],is.na(input$hiatus_list[[i]]['end']),max(input$times))
          text(x=mean(c(hiatus_start,hiatus_end)),
               y=mean(y_limits_time),
               labels=input$plot_options$name_options["erosion_label_time"] ,
               srt=90,
               cex=label_expansion)
        }
      }
    }
    
    #### 2. Age Model ####
    if ( keyword == "age model" ){
      # y limits for plot
      if (all(input$age_model_uneroded==0)){ # if no sedimentation at all happened
        y_limits_age_model=c(0,1)
      } else {
        y_limits_age_model=range(input$age_model_uneroded)
      }
      # generate empty plot
      plot(NULL,
           ylim=y_limits_age_model,
           xlim=range(input$times),
           xlab='',
           ylab='',
           mgp=c(axis_label_distance,tick_label_distance,0))
      mtext(side=1,
            line=axis_label_distance,
            text=paste(input$plot_options$name_options["T_name"],
                       " [",
                       input$plot_options$name_options["T_unit"] ,
                       "]",
                       sep=""),
            cex=label_expansion)
      mtext(side=2,
            line=axis_label_distance,
            text=paste(input$plot_options$name_options["L_name"],
                       " [", input$plot_options$name_options["L_unit"] ,
                       "]",
                       sep=""),
            cex=label_expansion)
      # draw erosion polygons
      if (length(input$hiatus_list)>0){
        for (i in 1:length(input$hiatus_list)){
          hiatus_start=replace(input$hiatus_list[[i]]['beginning'],is.na(input$hiatus_list[[i]]['beginning']),-max(input$times))
          hiatus_end=replace(input$hiatus_list[[i]]['end'],is.na(input$hiatus_list[[i]]['end']),2*max(input$times))
          polygon(x=c(hiatus_start,hiatus_end,hiatus_end,hiatus_start),
                  y=c(rep(y_limits_age_model[1]-1,2), rep(y_limits_age_model[2]+1,2)),
                  lty=0,
                  col=input$plot_options$col_options['erosion_col'])
        }
      }
      # x axis for reference
      lines(x=range(input$times),
            y=c(0,0),
            col=input$plot_options$col_options["baseline_col"],
            lwd=input$plot_options$line_options["baseline_lwd"])
      # uneroded age model
      lines(x=input$times,
            y=input$age_model_uneroded,
            col=input$plot_options$col_options['sed_col_eroded'],
            lwd=input$plot_options$line_options["sed_lwd_eroded"])
      # eroded age model
      lines(x=input$times,
            y=input$age_model_eroded,
            col=input$plot_options$col_options['sed_col'],
            lwd=input$plot_options$line_options["sed_lwd"])
      # label the eroded time intervals
      if (length(input$hiatus_list)>0){
        for (i in 1:length(input$hiatus_list)){
          text(x=mean(c(replace(input$hiatus_list[[i]]['beginning'],is.na(input$hiatus_list[[i]]['beginning']),0),
                        replace(input$hiatus_list[[i]]['end'],is.na(input$hiatus_list[[i]]['end']),max(input$times)))),
               y=mean(y_limits_age_model),
               labels=input$plot_options$name_options["erosion_label_age_model"],
               srt=90,
               cex=label_expansion)
        }
      }
    }
    
    
    #### 3. Stratigraphic Height + Sed Rate ####
    if ( keyword == "height" ){
      ### If Everything is Eroded (No Positive Sediment Accumulation) ###
      if (input$age_model_uneroded[length(input$age_model_uneroded)] <= input$age_model_uneroded[1]){
        plot(NULL,
             xlim=c(0,1),
             ylim=c(0,1),
             xaxt='n',
             yaxt='n',
             xlab='',
             ylab='',
             mgp=c(axis_label_distance,tick_label_distance,0))
        # mark complete plot as eroded
        polygon(x=c(-1,2,2,-1),
                y=c(-1,-1,2,2),
                lty=0,
                col=input$plot_options$col_options['erosion_col'])
        # add label that everything was eroded
        text(x=0.5,
             y=0.5,
             labels=input$plot_options$name_options["erosion_label_everything_eroded"],
             cex=label_expansion)
      }
      ### Positive Sediment Accumulation ###
      else{
        plot(NULL,
             ylim=c(0,1),
             xlim=range(input$age_model_eroded[!is.na(input$age_model_eroded)]),
             xlab='',
             ylab='',
             yaxt='n',
             mgp=c(axis_label_distance,tick_label_distance,0))
        mtext(side=1,
              text=paste(input$plot_options$name_options["L_name"],
                         " [",
                         input$plot_options$name_options["L_unit"] ,
                         "]",
                         sep=""),
              line=axis_label_distance,
              cex=label_expansion)
        lines(x=range(input$age_model_eroded[!is.na(input$age_model_eroded)]),
              y=c(0,0),
              col=input$plot_options$col_options["baseline_col"],
              lwd=input$plot_options$line_options["baseline_lwd"])
        
        ### Plot Sedimentation rate ###
        # get y limit for sed rate
        if (max(input$dep_rate_strat[!is.na(input$dep_rate_strat)])<=0){
          y_max_sed_rate=1
        }
        else{
          y_max_sed_rate=max(input$dep_rate_strat[!is.na(input$dep_rate_strat)])
        }
        right_ticks=axisTicks(usr=range(c(0,y_max_sed_rate)),
                              log=FALSE,
                              nint =  no_of_ticks-1)
        axis(side=4,
             at=right_ticks/y_max_sed_rate,
             labels=as.character(right_ticks),
             mgp=c(axis_label_distance,tick_label_distance,0))
        mtext(text=paste(input$plot_options$name_options["sed_rate_name_strat"],
                         " [" ,
                         input$plot_options$name_options["L_unit"] ,
                         " per " ,
                         input$plot_options$name_options["T_unit"] ,
                         "]",
                         sep=""),
              side=4,
              line=axis_label_distance,
              col=input$plot_options$col_options['sed_col'],
              cex=label_expansion)
        # draw sed rate
        lines(x=input$age_model_eroded,
              y=input$dep_rate_strat/y_max_sed_rate,
              col=input$plot_options$col_options['sed_col'],
              lwd=input$plot_options$line_options["sed_lwd"])
        
        ### Draw Pattern ###
        mtext(text=paste(input$plot_options$name_options["sed_content_name"],
                         " ",
                         input$plot_options$name_options["sed_content_name_addition_strat"],
                         " [",
                         input$plot_options$name_options["sed_content_unit"],
                         " per ",
                         input$plot_options$name_options["L_unit"] ,
                         "]",
                         sep=''),
              side = 2,
              line=axis_label_distance,
              col=input$plot_options$col_options['pattern_col'],
              cex=label_expansion)
        ## get max plotted y value
        if (max(input$pattern_strat[!is.na(input$pattern_strat)])==0){
          y_max_pattern=1
        }
        else{
          y_max_pattern=c(1.2*min(tail(sort(input$pattern_strat[!is.na(input$pattern_strat)]),ceiling(0.05*sum(!is.na(input$age_model_eroded))))))
        }
        # determine left ticks
        left_ticks=axisTicks(usr=c(0,y_max_pattern),
                             log=FALSE,
                             nint =  no_of_ticks-1)
        # draw left axis
        axis(side=2,
             at=left_ticks/y_max_pattern,
             labels=as.character(left_ticks),
             mgp=c(axis_label_distance,tick_label_distance,0))
        # draw pattern
        lines(x=input$age_model_eroded,
              y=input$pattern_strat/y_max_pattern,
              col=input$plot_options$col_options['pattern_col'],
              lwd=input$plot_options$line_options["pattern_lwd"])
        
        ### Draw and Label Hiatuses ###
        if (length(input$hiatus_list)>0){
          for (i in 1:length(input$hiatus_list)){
            lines(x=rep(input$hiatus_list[[i]]['height'],2),
                  y=c(-1,2),
                  col=input$plot_options$col_options['erosion_col'],
                  lwd=input$plot_options$line_options["hiatus_lwd"])
            text(x=input$hiatus_list[[i]]['height'],
                 y=0.5,
                 labels=input$plot_options$name_options["erosion_label_strat"],
                 srt=90,
                 cex=label_expansion)
          }
        }
      }
    }
    
    #### 4. Stratigraphic Height + Condensation ####
    if ( keyword == "condensation" ){
      ### If Everything is Eroded ###
      if (input$age_model_uneroded[length(input$age_model_uneroded)] <= input$age_model_uneroded[1]){
        plot(NULL,
             xlim=c(0,1),
             ylim=c(0,1),
             xaxt='n',
             yaxt='n',
             xlab='',
             ylab='',
             mgp=c(axis_label_distance,tick_label_distance,0))
        # mark complete plot as eroded
        polygon(x=c(-1,2,2,-1),
                y=c(-1,-1,2,2),
                lty=0,
                col=input$plot_options$col_options['erosion_col'])
        # add label that everything was eroded
        text(x=0.5,
             y=0.5,
             labels=input$plot_options$name_options["erosion_label_everything_eroded"],
             cex=label_expansion)
      }
      ### If Section Was Formed ###
      else{
        plot(NULL,
             ylim=c(0,1),
             xlim=range(input$age_model_eroded[!is.na(input$age_model_eroded)]),
             xlab="",
             ylab='',
             yaxt='n',
             mgp=c(axis_label_distance,tick_label_distance,0))
        # x label
        mtext(side=1,
              text=paste(input$plot_options$name_options["L_name"],
                         " ",
                         "[",
                         input$plot_options$name_options["L_unit"] ,
                         "]",
                         sep=""),
              line=axis_label_distance,
              cex=label_expansion)
        lines(x=range(input$age_model_eroded[!is.na(input$age_model_eroded)]),
              y=c(0,0),
              col=input$plot_options$col_options["baseline_col"],
              lwd=input$plot_options$line_options["baseline_lwd"])
        
        ### Plot Condensation Rate ###
        # get y limit for sed rate
        if (max(input$condensation_strat[!is.na(input$condensation_strat)])<=0){
          y_max_cond=1
        }
        else{
          y_max_cond=c(1.2*min(tail(sort(input$condensation_strat[!is.na(input$condensation_strat)]),ceiling(0.05*sum(!is.na(input$age_model_eroded))))))
        }
        # get ticks location
        right_ticks=axisTicks(usr=c(0,y_max_cond),
                              log=FALSE,
                              nint =  no_of_ticks-1)
        # plot right axis
        axis(side=4,
             at=right_ticks/y_max_cond,
             labels=as.character(right_ticks),
             mgp=c(axis_label_distance,tick_label_distance,0))
        # draw 
        mtext(text=paste(input$plot_options$name_options["condensation_name"],
                         " [",
                         input$plot_options$name_options["T_unit"] ,
                         " per " ,
                         input$plot_options$name_options["L_unit"] ,
                         "]",
                         sep="" ),
              side=4,
              line=axis_label_distance,
              col=input$plot_options$col_options['sed_col'],
              cex=label_expansion)
        lines(x=input$age_model_eroded,
              y=input$condensation_strat/y_max_cond,
              col=input$plot_options$col_options['sed_col'],
              lwd=input$plot_options$line_options["sed_lwd"])
        
        ### Stratigraphic Pattern ###
        # left axis label
        mtext(text=paste(input$plot_options$name_options["sed_content_name"],
                         " ",
                         input$plot_options$name_options["sed_content_name_addition_strat"],
                         " ",
                         "[",
                         input$plot_options$name_options["sed_content_unit"],
                         " per ",
                         input$plot_options$name_options["L_unit"] ,
                         "]",
                         sep=''),
              side = 2,
              line=axis_label_distance,
              col=input$plot_options$col_options['pattern_col'],
              cex=label_expansion)
        ## get max plotted y value
        if (max(input$pattern_strat[!is.na(input$pattern_strat)])==0){
          y_max_pattern=1
        }
        else{
          y_max_pattern=c(1.2*min(tail(sort(input$pattern_strat[!is.na(input$pattern_strat)]),ceiling(0.05*sum(!is.na(input$age_model_eroded))))))
        }
        left_ticks=axisTicks(usr=c(0,y_max_pattern),
                             log=FALSE,
                             nint =  no_of_ticks-1)
        # draw left axis
        axis(side=2,
             at=left_ticks/y_max_pattern,
             labels=as.character(left_ticks),
             mgp=c(axis_label_distance,tick_label_distance,0))
        # draw pattern
        lines(x=input$age_model_eroded,
              y=input$pattern_strat/y_max_pattern,
              col=input$plot_options$col_options['pattern_col'],
              lwd=input$plot_options$line_options["pattern_lwd"])
        
        ### Plot and Label Hiatuses ###
        if (length(input$hiatus_list)>0){
          for (i in 1:length(input$hiatus_list)){
            lines(x=rep(input$hiatus_list[[i]]['height'],2),
                  y=c(-1,2),
                  col=input$plot_options$col_options['erosion_col'],
                  lwd=input$plot_options$line_options["hiatus_lwd"])
            text(x=input$hiatus_list[[i]]['height'],
                 y=0.5,
                 labels=input$plot_options$name_options["erosion_label_strat"],
                 srt=90,
                 cex = label_expansion)
          }
        }
      }
    }
  }
  
  
  #### 4. Stratigraphic Height + Condensation ####
  if ( keyword == "section without sed info" ){
    ### If Everything is Eroded ###
    if (input$age_model_uneroded[length(input$age_model_uneroded)] <= input$age_model_uneroded[1]){
      plot(NULL,
           xlim=c(0,1),
           ylim=c(0,1),
           xaxt='n',
           yaxt='n',
           xlab='',
           ylab='',
           mgp=c(axis_label_distance,tick_label_distance,0))
      # mark complete plot as eroded
      polygon(x=c(-1,2,2,-1),
              y=c(-1,-1,2,2),
              lty=0,
              col=input$plot_options$col_options['erosion_col'])
      # add label that everything was eroded
      text(x=0.5,
           y=0.5,
           labels=input$plot_options$name_options["erosion_label_everything_eroded"],
           cex=label_expansion)
    }
    ### If Section Was Formed ###
    else{
      plot(NULL,
           ylim=c(0,1),
           xlim=range(input$age_model_eroded[!is.na(input$age_model_eroded)]),
           xlab="",
           ylab='',
           yaxt='n',
           mgp=c(axis_label_distance,tick_label_distance,0))
      # x label
      mtext(side=1,
            text=paste(input$plot_options$name_options["L_name"],
                       " ",
                       "[",
                       input$plot_options$name_options["L_unit"] ,
                       "]",
                       sep=""),
            line=axis_label_distance,
            cex=label_expansion)
      lines(x=range(input$age_model_eroded[!is.na(input$age_model_eroded)]),
            y=c(0,0),
            col=input$plot_options$col_options["baseline_col"],
            lwd=input$plot_options$line_options["baseline_lwd"])
      
      ### Stratigraphic Pattern ###
      # left axis label
      mtext(text=paste(input$plot_options$name_options["sed_content_name"],
                       " ",
                       input$plot_options$name_options["sed_content_name_addition_strat"],
                       " ",
                       "[",
                       input$plot_options$name_options["sed_content_unit"],
                       " per ",
                       input$plot_options$name_options["L_unit"] ,
                       "]",
                       sep=''),
            side = 2,
            line=axis_label_distance,
            col=input$plot_options$col_options['pattern_col'],
            cex=label_expansion)
      ## get max plotted y value
      if (max(input$pattern_strat[!is.na(input$pattern_strat)])==0){
        y_max_pattern=1
      }
      else{
        y_max_pattern=c(1.2*min(tail(sort(input$pattern_strat[!is.na(input$pattern_strat)]),ceiling(0.05*sum(!is.na(input$age_model_eroded))))))
      }
      left_ticks=axisTicks(usr=c(0,y_max_pattern),
                           log=FALSE,
                           nint =  no_of_ticks-1)
      # draw left axis
      axis(side=2,
           at=left_ticks/y_max_pattern,
           labels=as.character(left_ticks),
           mgp=c(axis_label_distance,tick_label_distance,0))
      # draw pattern
      lines(x=input$age_model_eroded,
            y=input$pattern_strat/y_max_pattern,
            col=input$plot_options$col_options['pattern_col'],
            lwd=input$plot_options$line_options["pattern_lwd"])
      
      ### Plot and Label Hiatuses ###
      if (length(input$hiatus_list)>0){
        for (i in 1:length(input$hiatus_list)){
          lines(x=rep(input$hiatus_list[[i]]['height'],2),
                y=c(-1,2),
                col=input$plot_options$col_options['erosion_col'],
                lwd=input$plot_options$line_options["hiatus_lwd"])
          text(x=input$hiatus_list[[i]]['height'],
               y=0.5,
               labels=input$plot_options$name_options["erosion_label_strat"],
               srt=90,
               cex = label_expansion)
        }
      }
    }
  }
}