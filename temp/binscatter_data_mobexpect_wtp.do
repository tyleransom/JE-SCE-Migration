insheet using ../temp/binscatter_data_mobexpect_wtp.csv

twoway (scatter wtp_frac_moved chance_move_residence, mcolor(navy) lcolor(maroon)) , graphregion(fcolor(white))  xtitle(chance_move_residence) ytitle(wtp_frac_moved) legend(off order()) graphregion(color(white))
