condensator=function(xdep,
                     ydep,
                     xpat,
                     ypat,
                     duration,
                     input_volume=0,
                     plot_options=NULL,
                     suppress_errors=FALSE){
  
  
#### 0. Check Input ####
  
#### 0.1 Input Check with Silent Errors (For Shiny) ####
  if (suppress_errors==TRUE){
    ### Check Duration ###
    # needs to be numeric vector with 1 strictly positive finite entry ###
    if (!is.vector(duration, mode = "numeric")) return(list(incorrect_input=TRUE))
    if (!(length(duration)==1 & duration>0 & is.finite(duration))) return(list(incorrect_input=TRUE))
    
    ### Check input volume ###
    # needs to be numeric vector with 1 nonnegative finite entry ###
    if (!is.vector(input_volume, mode = "numeric")) return(list(incorrect_input=TRUE))
    if (!(length(input_volume)==1 & input_volume>=0 & is.finite(input_volume))) return(list(incorrect_input=TRUE))
    
    ### Check xdep, ydep, xpat, and ypat ###
    # xdep, ydep, xpat, and ypat need to be vectors
    if (!( is.vector(xdep) & is.vector(ydep) & is.vector(xpat) & is.vector(ypat) )) return(list(incorrect_input=TRUE))
    # xdep and ydep need the same number of entries
    if (length(xdep)!=length(ydep)) return(list(incorrect_input=TRUE))
    # xpat and ypat need the same number of entries
    if (length(xpat)!=length(ypat)) return(list(incorrect_input=TRUE))
    ## remove NAs
    xdep=xdep[!(is.na(xdep)|is.na(ydep))]
    ydep=ydep[!(is.na(xdep)|is.na(ydep))]
    xpat=xpat[!(is.na(xpat)|is.na(ypat))]
    ypat=ypat[!(is.na(xpat)|is.na(ypat))]
    # xdep, ydep, xpat, and ypat need to have only numeric entries
    if (!all(is.numeric(c(xdep,ydep,xpat,ypat)))) return(list(incorrect_input=TRUE))
    # xdep, ydep, xpat, and ypat need to have only finite entries
    if (!all(is.finite(c(xdep,ydep,xpat,ypat)))) return(list(incorrect_input=TRUE))
    # xdep and xpat need at least 2 unique entries
    if (min(c(length(unique(xdep)),length(unique(xpat))))<=1) return(list(incorrect_input=TRUE))
    # all values in ypat need to be nonnegative
    if (any(ypat<0)) return(list(incorrect_input=TRUE))
  }
  else{
    
    #### 0.2 Input Check with Display of Errors ####
    ### Check Duration ###
    # needs to be numeric vector with 1 strictly positive finite entry ###
    if (!is.vector(duration, mode = "numeric")) stop('Expecting numeric value for duration')
    if (!(length(duration)==1 & duration>0 & is.finite(duration))) stop('Expecting one strictly positive finite numeric value for duration')
    
    ### Check input volume ###
    # needs to be numeric vector with 1 nonnegative finite entry ###
    if (!is.vector(input_volume, mode = "numeric")) stop('Expecting numeric value for input_volume')
    if (!(length(input_volume)==1 & input_volume>=0 & is.finite(input_volume))) stop('Expecting one nonnegative finite numeric value for input_volume')
    
    ### Check xdep, ydep, xpat, and ypat ###
    # xdep, ydep, xpat, and ypat need to be vectors
    if (!( is.vector(xdep) & is.vector(ydep) & is.vector(xpat) & is.vector(ypat) )) stop("xdep, ydep, xpat, and ypat need to be vectors")
    # xdep and ydep need the same number of entries
    if (length(xdep)!=length(ydep)) stop("xdep and ydep need the same number of entries")
    # xpat and ypat need the same number of entries
    if (length(xpat)!=length(ypat)) stop("xpat and ypat need the same number of entries")
    ## remove NAs
    xdep=xdep[!(is.na(xdep)|is.na(ydep))]
    ydep=ydep[!(is.na(xdep)|is.na(ydep))]
    xpat=xpat[!(is.na(xpat)|is.na(ypat))]
    ypat=ypat[!(is.na(xpat)|is.na(ypat))]
    # xdep, ydep, xpat, and ypat need to have only numeric entries
    if (!all(is.numeric(c(xdep,ydep,xpat,ypat)))) stop("All entries in xdep, ydep, xpat, and ypat must be numeric")
    # xdep, ydep, xpat, and ypat need to have only finite entries
    if (!all(is.finite(c(xdep,ydep,xpat,ypat)))) stop("All entries in xdep, ydep, xpat, and ypat must be finite")
    # xdep and xpat need at least 2 unique entries
    if (min(c(length(unique(xdep)),length(unique(xpat))))<=1) stop("Both xdep and xpat need at least two unique entries after removal of NAs")
    # all values in ypat need to be nonnegative
    if (any(ypat<0)) stop("All entries in ypat need to be nonnegative")
  }
  
  #### 0.3 Remove Duplicates ####
  ydep=ydep[!duplicated(xdep)]
  xdep=xdep[!duplicated(xdep)]
  ypat=ypat[!duplicated(xpat)]
  xpat=xpat[!duplicated(xpat)]
  
  #### 0.4 Sort Input ####
  local_sorted=sort(xdep,
                    decreasing = FALSE,
                    index.return=TRUE)
  xdep=local_sorted$x
  ydep=ydep[local_sorted$ix]
  local_sorted=sort(xpat,
                    decreasing = FALSE,
                    index.return=TRUE)
  xpat=local_sorted$x
  ypat=ypat[local_sorted$ix]
  
  
  #### 1. Define Options for Plot ####
  if (is.null(plot_options)){
    plot_options=list(col_options=c(pattern_col='red',
                                    sed_col="blue",
                                    sed_col_eroded=rgb(red=col2rgb("blue")[1,1],
                                                       green=col2rgb("blue")[2,1],
                                                       blue=col2rgb("blue")[3,1],
                                                       maxColorValue =255,
                                                       alpha=124),
                                    sed_col_minus_input='black',
                                    erosion_col=grey(0.7),
                                    baseline_col='black'),
                      line_options=c(pattern_lwd=3,
                                     sed_lwd=3,
                                     sed_lwd_eroded=1.5,
                                     sed_lwd_minus_input=3,
                                     hiatus_lwd=5,
                                     baseline_lwd=3),
                      name_options=c(L_unit='m',
                                     L_name='Stratigraphic Height',
                                     T_unit='Myr',
                                     T_name='Time',
                                     sed_rate_name='Sedimentation Rate',
                                     sed_rate_name_strat='Formation Velocity of Section',
                                     sed_content_name='Shell',
                                     sed_content_unit='#',
                                     sed_content_name_addition_time='Input',
                                     sed_content_name_addition_strat='Abundance',
                                     condensation_name='Sedimentary Condensation',
                                     erosion_label_time='Will Be Eroded',
                                     erosion_label_age_model='Erosion',
                                     erosion_label_strat='Hiatus',
                                     erosion_label_everything_eroded='No Section Formed'),
                      par_options=c(no_of_ticks=5,
                                    axis_label_distance=1.55,
                                    tick_label_distance=0.6,
                                    label_expansion=1.1),
                      points_plot=list(plot_sed_points=FALSE,
                                        x_sed_points=NA,
                                        y_sed_points=NA,
                                        sed_points_pch=NA,
                                        sed_points_expansion=NA,
                                        sed_points_col=NA,
                                        sed_points_bg=NA,
                                        sed_points_labels=NA,
                                        sed_points_labels_col=NA,
                                        sed_points_labels_pos=NA,
                                        sed_points_labels_expansion=NA,
                                        plot_pat_points=FALSE,
                                        x_pat_points=NA,
                                        y_pat_points=NA,
                                        pat_points_pch=NA,
                                        pat_points_expansion=NA,
                                        pat_points_col=NA,
                                        pat_points_bg=NA,
                                        pat_points_labels=NA,
                                        pat_points_labels_col=NA,
                                        pat_points_labels_pos=NA,
                                        pat_points_labels_expansion=NA))
  }
  
  
  #### 2. Determine Times of Evalation ####
  
  #### 2.1 Determine Zeros of Sedimentation Rate ####
  times_to_add=numeric()
  h=length(xdep)
  while(h>1){
    if((ydep[h]>0 & ydep[h-1]<0) | (ydep[h]<0 & ydep[h-1]>0)){
      t_zero=((-ydep[h-1])/((ydep[h]-ydep[h-1])/(xdep[h]-xdep[h-1])))+xdep[h-1]
      ydep=c(ydep[xdep<t_zero],0,ydep[xdep>t_zero])  
      xdep=c(xdep[xdep <t_zero],t_zero,xdep[xdep>t_zero])
      # add 10^-6 values left and right of the zeros to increase precision around hiatuses
      times_to_add=c(times_to_add,t_zero + 10^(-6), t_zero - 10^(-6))
    }
    h=h-1
  }
  
  #### 2.2 Determine Times of Evalaution ####
  times=sort(unique(c(times_to_add,xdep,xpat,seq(0,duration,length.out = 1000))))
  times=times[times >=0 & times <= duration]
  points_of_eval=length(times)
  
    
  #### 3. Determine Uneroded Age Model ####
  
  #### 3.1 Determine Sed Rate at All Relevant Points ####
  ydep= approx(x=xdep,
              y=ydep,
              xout=times,
              yleft=0,
              yright=0)[[2]] +
        input_volume*
        approx(x=xpat,
              y=ypat,
              xout=times,
              yleft=0,
              yright=0)[[2]]
        

  #### 3.2 Determine Raw Age Model ####
  #integrate over the sedimentation rate using the trapezoidal rule
  age_model_uneroded=cumsum(c(0,(times[2:points_of_eval]-times[1:(points_of_eval-1)])*(0.5*(ydep[1:(points_of_eval-1)]+ydep[2:points_of_eval]))))
  
  
  #### 4. Extreme Case: Everything is Eroded  ####
  if ( age_model_uneroded[points_of_eval] <= 0 ){  # if everything is eroded
    ### Return Results
    pattern_time=approx(xpat,ypat,xout=times,yleft=0,yright=0)[[2]]
    return(list( times=times,
                 heights=rep(NA,points_of_eval),
                 dep_rate_time=ydep,
                 dep_rate_time_sub_input=ydep-input_volume*pattern_time,
                 pattern_time=pattern_time,
                 age_model_uneroded=age_model_uneroded,
                 age_model_eroded=rep(NA,points_of_eval),
                 pattern_strat=rep(NA,points_of_eval),
                 dep_rate_strat=rep(NA,points_of_eval),
                 condensation_strat=rep(NA,points_of_eval),
                 hiatus_list=list(c('height'=NA,
                                    'beginning'=NA,
                                    'end'=NA)),
                 pos_input_volume=input_volume>0,
                 plot_options=plot_options,
                 incorrect_input=FALSE))
  }
  
    
  #### 5. Flatten Parts with Erosion In Age Model ####
  
  #### 5.1 Add values at end and beginning for the removal of hiatuses below ####
  age_model_uneroded=c(rep(age_model_uneroded[1],3), age_model_uneroded,rep(age_model_uneroded[points_of_eval],2))
  times=c((0-c(3,2,1)),times,duration+c(1,2))
  ydep=c(rep(0,3),ydep,rep(0,2))
  age_model_eroded=age_model_uneroded
  points_of_eval=points_of_eval+5
  h=points_of_eval #running index for flattening procedure, counting backwards from high (young) to low (old)

  #### 5.2 Flatten the age model ####
  erosion_level=age_model_uneroded[h]
  
  while (h>2){
    ## Case A: Only erosion in next time step, Transition from erosion to deposition in the following time step
    if ( age_model_eroded[h-1]> erosion_level & age_model_eroded[h-2]< erosion_level ){
      # transition erosion - non erosion
      # determine time at which erosion transitions into deposition
      # i.e., where the age model has the value "erosion_level"
      transition_time= (erosion_level-age_model_eroded[h-2])*(times[h-1]-times[h-2])/(age_model_eroded[h-1]-age_model_eroded[h-2]) + times[h-2]
      # insert time of transition into times vector
      times=c(times[1:(h-2)], transition_time, times[(h-1):points_of_eval])
      # update age models according to the added transition time
      age_model_eroded=c(age_model_eroded[1:(h-2)],erosion_level,age_model_eroded[(h-1):points_of_eval])
      age_model_uneroded=c(age_model_uneroded[1:(h-2)],erosion_level,age_model_uneroded[(h-1):points_of_eval])
      # flatten two values older than transition times
      age_model_eroded[c(h,h+1)]=erosion_level # ????????
      # update sedimentation rate
      #inserted_sed_rate=((ydep[h-1]-ydep[h-2])/(times[h-1]-times[h-2]))*(transition_time-times[h-2])+ydep[h-2]
      ydep=c(ydep[1:(h-2)],
             (((ydep[h-1]-ydep[h-2])/(times[h-1]-times[h-2]))*(transition_time-times[h-2])+ydep[h-2]), #inserted sed rate
             ydep[(h-1):points_of_eval])
      # update erosion level
      erosion_level=age_model_eroded[h-2]
      points_of_eval=points_of_eval+1
      #move to the left
      h=h-2
    }
    ## Case B: only erosion in the next two steps
    if (age_model_eroded[h-1] > erosion_level & age_model_eroded[h-2] >= erosion_level){
      #strict erosion: erode value to the left
      age_model_eroded[h-1]=erosion_level
      #move to the left
      h=h-1
    }
    ## Case C: no erosion in the next step
    if (age_model_eroded[h-1] <= erosion_level){
      #update erosion_level
      erosion_level=age_model_eroded[h-1]
      #move to the left
      h=h-1
    }
  }
  
  
  #### 6. Deal with hiatuses ####
  hiatus_list=list()
  
  #### 6.1 Erode flattened parts, collect information on hiatuses ####
  stratigrapic_heights_hiatuses=sort(unique(age_model_eroded[duplicated(age_model_eroded)]))
  # examine each hiatus individually
  for (i in 1:length(stratigrapic_heights_hiatuses)){
    #indices where hiatus is located
    hiatus_indices=range(which(age_model_eroded == stratigrapic_heights_hiatuses[i]))
    ## Case A: Short hiatus (= only one time interval)
    if ((hiatus_indices[1]+1)==hiatus_indices[2]){
      # insert a time point in its middle, adjust age models accordingly
      times=c(times[1:hiatus_indices[1]], mean(times[hiatus_indices]),times[hiatus_indices[2]:points_of_eval])
      age_model_eroded=c(age_model_eroded[1:hiatus_indices[1]],NA,age_model_eroded[hiatus_indices[2]:points_of_eval])
      age_model_uneroded=c(age_model_uneroded[1:hiatus_indices[1]],stratigrapic_heights_hiatuses[i],age_model_uneroded[hiatus_indices[2]:points_of_eval])
      ydep=c(ydep[1:hiatus_indices[1]],mean(c(ydep[hiatus_indices])),ydep[hiatus_indices[2]:points_of_eval])
      points_of_eval=points_of_eval+1
    } else { ## Case B: Long hiatus (longer than one one time interval)
      # replace flattened parts with NA
      age_model_eroded[(hiatus_indices[1]+1):(hiatus_indices[2]-1)]=NA
    }
    # store information about hiatus
    hiatus_list[[i]]=c('height'=stratigrapic_heights_hiatuses[i],
                       'beginning'=times[hiatus_indices[1]],
                       'end'=times[hiatus_indices[2]])
  }
  
  #### 6.2 treat "artificial" haituses introduced in 5.1 at beginning and end of the section ####
  # if last hiatus starts after deposition of section -> artificial -> remove
  if ( hiatus_list[[length(stratigrapic_heights_hiatuses)]]['beginning'] >= duration ){
    hiatus_list[[length(stratigrapic_heights_hiatuses)]]=NULL
  } else {
    hiatus_list[[length(hiatus_list)]]['end']=NA
  }
  # if "true" hiatus note that it has no well-defined end
  
  # if first hiatus ends before deposition of section -> artificial -> remove
  if ( hiatus_list[[1]]['end'] <= 0 ){
    hiatus_list[[1]]=NULL
  } else {
    hiatus_list[[1]]['beginning']=NA
  }
  # if "true" hiatus note that it has no well-defined beginning
  
  
  #### 7. Generate Output Data ####
  #### 7.1 Remove Residual Parts Generated by 5.1 from Age Models ####
  age_model_eroded=age_model_eroded[4:(points_of_eval-2)]
  age_model_uneroded=age_model_uneroded[4:(points_of_eval-2)]
  times=times[4:(points_of_eval-2)]
  ydep=ydep[4:(points_of_eval-2)]
  
  #### 7.2 Make Sure Section Starts at Stratigraphic Height 0 ####
  # get lowest non-eroded point
  start_of_section=min(age_model_eroded[!is.na(age_model_eroded)])
  #noramlize sections to start at 0
  age_model_eroded=age_model_eroded-start_of_section
  age_model_uneroded=age_model_uneroded-start_of_section
  # adjust hiatus heights too
  if (length(hiatus_list)>0){
    for (i in 1:length(hiatus_list)){
      hiatus_list[[i]]['height']=hiatus_list[[i]]['height']-start_of_section
    }
  }
  
  #### 7.3 Get Values of Sed Rate and Pattern ####
  pattern_time=approx(xpat,ypat,xout=times,yleft=0,yright=0)[[2]]
  pattern_strat=pattern_time/ydep
  pattern_strat[is.infinite(pattern_strat) | is.na(age_model_eroded) ]=NA
  sed_rate_strat=ydep
  sed_rate_strat[is.na(age_model_eroded)]=NA
  condensation_strat=1/sed_rate_strat
  condensation_strat[is.infinite(condensation_strat)]=NA


  #### 8. Return Output ####
  return(list(times=times,
              heights=age_model_eroded,
              dep_rate_time=ydep,
              dep_rate_time_sub_input=ydep-input_volume*pattern_time,
              pattern_time=pattern_time,
              age_model_uneroded=age_model_uneroded,
              age_model_eroded=age_model_eroded,
              pattern_strat=pattern_strat,
              dep_rate_strat=sed_rate_strat,
              condensation_strat=condensation_strat,
              hiatus_list=hiatus_list,
              pos_input_volume=input_volume>0,
              plot_options=plot_options,
              incorrect_input=FALSE))
}